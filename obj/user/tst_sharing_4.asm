
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
  800031:	e8 80 06 00 00       	call   8006b6 <libmain>
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
  80005c:	68 00 40 80 00       	push   $0x804000
  800061:	6a 13                	push   $0x13
  800063:	68 1c 40 80 00       	push   $0x80401c
  800068:	e8 88 07 00 00       	call   8007f5 <_panic>
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
  800085:	68 34 40 80 00       	push   $0x804034
  80008a:	e8 23 0a 00 00       	call   800ab2 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	68 68 40 80 00       	push   $0x804068
  80009a:	e8 13 0a 00 00       	call   800ab2 <cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 c4 40 80 00       	push   $0x8040c4
  8000aa:	e8 03 0a 00 00       	call   800ab2 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000b2:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000b9:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	int envID = sys_getenvid();
  8000c0:	e8 c7 1e 00 00       	call   801f8c <sys_getenvid>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000c8:	83 ec 0c             	sub    $0xc,%esp
  8000cb:	68 f8 40 80 00       	push   $0x8040f8
  8000d0:	e8 dd 09 00 00       	call   800ab2 <cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 ff 1c 00 00       	call   801ddc <sys_calculate_free_frames>
  8000dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 01                	push   $0x1
  8000e5:	68 00 10 00 00       	push   $0x1000
  8000ea:	68 2c 41 80 00       	push   $0x80412c
  8000ef:	e8 8b 1a 00 00       	call   801b7f <smalloc>
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (x != (uint32*)pagealloc_start)
  8000fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000fd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800100:	74 17                	je     800119 <_main+0xe1>
		{is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800102:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 30 41 80 00       	push   $0x804130
  800111:	e8 9c 09 00 00       	call   800ab2 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  800119:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800120:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800123:	e8 b4 1c 00 00       	call   801ddc <sys_calculate_free_frames>
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
  80014c:	e8 8b 1c 00 00       	call   801ddc <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015b:	50                   	push   %eax
  80015c:	68 9c 41 80 00       	push   $0x80419c
  800161:	e8 4c 09 00 00       	call   800ab2 <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	ff 75 d8             	pushl  -0x28(%ebp)
  80016f:	e8 b7 1a 00 00       	call   801c2b <sfree>
  800174:	83 c4 10             	add    $0x10,%esp
		expected = 0 ;
  800177:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80017e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800181:	e8 56 1c 00 00       	call   801ddc <sys_calculate_free_frames>
  800186:	29 c3                	sub    %eax,%ebx
  800188:	89 d8                	mov    %ebx,%eax
  80018a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (diff !=  expected)
  80018d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800190:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800193:	74 27                	je     8001bc <_main+0x184>
		{is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800195:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80019c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80019f:	e8 38 1c 00 00       	call   801ddc <sys_calculate_free_frames>
  8001a4:	29 c3                	sub    %eax,%ebx
  8001a6:	89 d8                	mov    %ebx,%eax
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	50                   	push   %eax
  8001ac:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001af:	68 34 42 80 00       	push   $0x804234
  8001b4:	e8 f9 08 00 00       	call   800ab2 <cprintf>
  8001b9:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step A completed!!\n\n\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 7f 42 80 00       	push   $0x80427f
  8001c4:	e8 e9 08 00 00       	call   800ab2 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8001cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d0:	74 04                	je     8001d6 <_main+0x19e>
  8001d2:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8001d6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking free of 2 shared objects ... [25%]\n");
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 98 42 80 00       	push   $0x804298
  8001e5:	e8 c8 08 00 00       	call   800ab2 <cprintf>
  8001ea:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  8001ed:	e8 ea 1b 00 00       	call   801ddc <sys_calculate_free_frames>
  8001f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	6a 01                	push   $0x1
  8001fa:	68 00 10 00 00       	push   $0x1000
  8001ff:	68 cd 42 80 00       	push   $0x8042cd
  800204:	e8 76 19 00 00       	call   801b7f <smalloc>
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	6a 01                	push   $0x1
  800214:	68 00 10 00 00       	push   $0x1000
  800219:	68 2c 41 80 00       	push   $0x80412c
  80021e:	e8 5c 19 00 00       	call   801b7f <smalloc>
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if(x == NULL)
  800229:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80022d:	75 17                	jne    800246 <_main+0x20e>
		{is_correct = 0; cprintf("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  80022f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 d0 42 80 00       	push   $0x8042d0
  80023e:	e8 6f 08 00 00       	call   800ab2 <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp

		expected = 2+1 ; /*2pages +1table*/
  800246:	c7 45 d4 03 00 00 00 	movl   $0x3,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80024d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800250:	e8 87 1b 00 00       	call   801ddc <sys_calculate_free_frames>
  800255:	29 c3                	sub    %eax,%ebx
  800257:	89 d8                	mov    %ebx,%eax
  800259:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80025c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80025f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800262:	7c 0b                	jl     80026f <_main+0x237>
  800264:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800267:	83 c0 02             	add    $0x2,%eax
  80026a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80026d:	7d 17                	jge    800286 <_main+0x24e>
			{is_correct = 0; cprintf("Wrong previous free: make sure that you correctly free shared object before (Step A)");}
  80026f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 28 43 80 00       	push   $0x804328
  80027e:	e8 2f 08 00 00       	call   800ab2 <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp

		sfree(z);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 75 c8             	pushl  -0x38(%ebp)
  80028c:	e8 9a 19 00 00       	call   801c2b <sfree>
  800291:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800294:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80029b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80029e:	e8 39 1b 00 00       	call   801ddc <sys_calculate_free_frames>
  8002a3:	29 c3                	sub    %eax,%ebx
  8002a5:	89 d8                	mov    %ebx,%eax
  8002a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff !=  expected)
  8002aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002ad:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8002b0:	74 27                	je     8002d9 <_main+0x2a1>
		{is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8002b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002b9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002bc:	e8 1b 1b 00 00       	call   801ddc <sys_calculate_free_frames>
  8002c1:	29 c3                	sub    %eax,%ebx
  8002c3:	89 d8                	mov    %ebx,%eax
  8002c5:	83 ec 04             	sub    $0x4,%esp
  8002c8:	50                   	push   %eax
  8002c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cc:	68 34 42 80 00       	push   $0x804234
  8002d1:	e8 dc 07 00 00       	call   800ab2 <cprintf>
  8002d6:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002df:	e8 47 19 00 00       	call   801c2b <sfree>
  8002e4:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8002e7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8002ee:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002f1:	e8 e6 1a 00 00       	call   801ddc <sys_calculate_free_frames>
  8002f6:	29 c3                	sub    %eax,%ebx
  8002f8:	89 d8                	mov    %ebx,%eax
  8002fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff !=  expected)
  8002fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800300:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800303:	74 27                	je     80032c <_main+0x2f4>
		{is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800305:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80030c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80030f:	e8 c8 1a 00 00       	call   801ddc <sys_calculate_free_frames>
  800314:	29 c3                	sub    %eax,%ebx
  800316:	89 d8                	mov    %ebx,%eax
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	50                   	push   %eax
  80031c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031f:	68 34 42 80 00       	push   $0x804234
  800324:	e8 89 07 00 00       	call   800ab2 <cprintf>
  800329:	83 c4 10             	add    $0x10,%esp

	}
	cprintf("Step B completed!!\n\n\n");
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	68 7d 43 80 00       	push   $0x80437d
  800334:	e8 79 07 00 00       	call   800ab2 <cprintf>
  800339:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  80033c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800340:	74 04                	je     800346 <_main+0x30e>
  800342:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800346:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP C: checking range of loop during free... [50%]\n");
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	68 94 43 80 00       	push   $0x804394
  800355:	e8 58 07 00 00       	call   800ab2 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80035d:	e8 7a 1a 00 00       	call   801ddc <sys_calculate_free_frames>
  800362:	89 45 c0             	mov    %eax,-0x40(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	6a 01                	push   $0x1
  80036a:	68 01 30 00 00       	push   $0x3001
  80036f:	68 c9 43 80 00       	push   $0x8043c9
  800374:	e8 06 18 00 00       	call   801b7f <smalloc>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	6a 01                	push   $0x1
  800384:	68 00 10 00 00       	push   $0x1000
  800389:	68 cb 43 80 00       	push   $0x8043cb
  80038e:	e8 ec 17 00 00       	call   801b7f <smalloc>
  800393:	83 c4 10             	add    $0x10,%esp
  800396:	89 45 b8             	mov    %eax,-0x48(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  800399:	c7 45 d4 06 00 00 00 	movl   $0x6,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003a0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8003a3:	e8 34 1a 00 00       	call   801ddc <sys_calculate_free_frames>
  8003a8:	29 c3                	sub    %eax,%ebx
  8003aa:	89 d8                	mov    %ebx,%eax
  8003ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  8003af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003b2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8003b5:	7c 0b                	jl     8003c2 <_main+0x38a>
  8003b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ba:	83 c0 02             	add    $0x2,%eax
  8003bd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8003c0:	7d 27                	jge    8003e9 <_main+0x3b1>
			{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8003c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c9:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8003cc:	e8 0b 1a 00 00       	call   801ddc <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 ec 04             	sub    $0x4,%esp
  8003d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	68 9c 41 80 00       	push   $0x80419c
  8003e1:	e8 cc 06 00 00       	call   800ab2 <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp

		sfree(w);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	ff 75 bc             	pushl  -0x44(%ebp)
  8003ef:	e8 37 18 00 00       	call   801c2b <sfree>
  8003f4:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8003f7:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003fe:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800401:	e8 d6 19 00 00       	call   801ddc <sys_calculate_free_frames>
  800406:	29 c3                	sub    %eax,%ebx
  800408:	89 d8                	mov    %ebx,%eax
  80040a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  80040d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800410:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800413:	74 27                	je     80043c <_main+0x404>
  800415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80041c:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80041f:	e8 b8 19 00 00       	call   801ddc <sys_calculate_free_frames>
  800424:	29 c3                	sub    %eax,%ebx
  800426:	89 d8                	mov    %ebx,%eax
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	50                   	push   %eax
  80042c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80042f:	68 34 42 80 00       	push   $0x804234
  800434:	e8 79 06 00 00       	call   800ab2 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80043c:	83 ec 04             	sub    $0x4,%esp
  80043f:	6a 01                	push   $0x1
  800441:	68 ff 1f 00 00       	push   $0x1fff
  800446:	68 cd 43 80 00       	push   $0x8043cd
  80044b:	e8 2f 17 00 00       	call   801b7f <smalloc>
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800456:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80045d:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800460:	e8 77 19 00 00       	call   801ddc <sys_calculate_free_frames>
  800465:	29 c3                	sub    %eax,%ebx
  800467:	89 d8                	mov    %ebx,%eax
  800469:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since it's not expected that to invloke sbrk due to the prev. sfree*/)
  80046c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80046f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800472:	74 27                	je     80049b <_main+0x463>
			{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800474:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80047b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80047e:	e8 59 19 00 00       	call   801ddc <sys_calculate_free_frames>
  800483:	29 c3                	sub    %eax,%ebx
  800485:	89 d8                	mov    %ebx,%eax
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80048d:	50                   	push   %eax
  80048e:	68 9c 41 80 00       	push   $0x80419c
  800493:	e8 1a 06 00 00       	call   800ab2 <cprintf>
  800498:	83 c4 10             	add    $0x10,%esp

		sfree(o);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004a1:	e8 85 17 00 00       	call   801c2b <sfree>
  8004a6:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8004a9:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004b0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004b3:	e8 24 19 00 00       	call   801ddc <sys_calculate_free_frames>
  8004b8:	29 c3                	sub    %eax,%ebx
  8004ba:	89 d8                	mov    %ebx,%eax
  8004bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004c5:	74 27                	je     8004ee <_main+0x4b6>
  8004c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ce:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004d1:	e8 06 19 00 00       	call   801ddc <sys_calculate_free_frames>
  8004d6:	29 c3                	sub    %eax,%ebx
  8004d8:	89 d8                	mov    %ebx,%eax
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	50                   	push   %eax
  8004de:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004e1:	68 34 42 80 00       	push   $0x804234
  8004e6:	e8 c7 05 00 00       	call   800ab2 <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp

		sfree(u);
  8004ee:	83 ec 0c             	sub    $0xc,%esp
  8004f1:	ff 75 b8             	pushl  -0x48(%ebp)
  8004f4:	e8 32 17 00 00       	call   801c2b <sfree>
  8004f9:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8004fc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800503:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800506:	e8 d1 18 00 00       	call   801ddc <sys_calculate_free_frames>
  80050b:	29 c3                	sub    %eax,%ebx
  80050d:	89 d8                	mov    %ebx,%eax
  80050f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800512:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800515:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800518:	74 27                	je     800541 <_main+0x509>
  80051a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800521:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800524:	e8 b3 18 00 00       	call   801ddc <sys_calculate_free_frames>
  800529:	29 c3                	sub    %eax,%ebx
  80052b:	89 d8                	mov    %ebx,%eax
  80052d:	83 ec 04             	sub    $0x4,%esp
  800530:	50                   	push   %eax
  800531:	ff 75 d4             	pushl  -0x2c(%ebp)
  800534:	68 34 42 80 00       	push   $0x804234
  800539:	e8 74 05 00 00       	call   800ab2 <cprintf>
  80053e:	83 c4 10             	add    $0x10,%esp


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800541:	e8 96 18 00 00       	call   801ddc <sys_calculate_free_frames>
  800546:	89 45 c0             	mov    %eax,-0x40(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800549:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054c:	89 c2                	mov    %eax,%edx
  80054e:	01 d2                	add    %edx,%edx
  800550:	01 d0                	add    %edx,%eax
  800552:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	6a 01                	push   $0x1
  80055a:	50                   	push   %eax
  80055b:	68 c9 43 80 00       	push   $0x8043c9
  800560:	e8 1a 16 00 00       	call   801b7f <smalloc>
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	89 45 bc             	mov    %eax,-0x44(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80056b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056e:	89 d0                	mov    %edx,%eax
  800570:	01 c0                	add    %eax,%eax
  800572:	01 d0                	add    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	6a 01                	push   $0x1
  800580:	50                   	push   %eax
  800581:	68 cb 43 80 00       	push   $0x8043cb
  800586:	e8 f4 15 00 00       	call   801b7f <smalloc>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 b8             	mov    %eax,-0x48(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800591:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800594:	01 c0                	add    %eax,%eax
  800596:	89 c2                	mov    %eax,%edx
  800598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80059b:	01 d0                	add    %edx,%eax
  80059d:	83 ec 04             	sub    $0x4,%esp
  8005a0:	6a 01                	push   $0x1
  8005a2:	50                   	push   %eax
  8005a3:	68 cd 43 80 00       	push   $0x8043cd
  8005a8:	e8 d2 15 00 00       	call   801b7f <smalloc>
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  8005b3:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8005ba:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8005bd:	e8 1a 18 00 00       	call   801ddc <sys_calculate_free_frames>
  8005c2:	29 c3                	sub    %eax,%ebx
  8005c4:	89 d8                	mov    %ebx,%eax
  8005c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  8005c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005cc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005cf:	7c 0b                	jl     8005dc <_main+0x5a4>
  8005d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005d4:	83 c0 02             	add    $0x2,%eax
  8005d7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8005da:	7d 27                	jge    800603 <_main+0x5cb>
			{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8005dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005e3:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8005e6:	e8 f1 17 00 00       	call   801ddc <sys_calculate_free_frames>
  8005eb:	29 c3                	sub    %eax,%ebx
  8005ed:	89 d8                	mov    %ebx,%eax
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005f5:	50                   	push   %eax
  8005f6:	68 9c 41 80 00       	push   $0x80419c
  8005fb:	e8 b2 04 00 00       	call   800ab2 <cprintf>
  800600:	83 c4 10             	add    $0x10,%esp

		freeFrames = sys_calculate_free_frames() ;
  800603:	e8 d4 17 00 00       	call   801ddc <sys_calculate_free_frames>
  800608:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(o);
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	ff 75 b4             	pushl  -0x4c(%ebp)
  800611:	e8 15 16 00 00       	call   801c2b <sfree>
  800616:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(w);
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	ff 75 bc             	pushl  -0x44(%ebp)
  80061f:	e8 07 16 00 00       	call   801c2b <sfree>
  800624:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(u);
  800627:	83 ec 0c             	sub    $0xc,%esp
  80062a:	ff 75 b8             	pushl  -0x48(%ebp)
  80062d:	e8 f9 15 00 00       	call   801c2b <sfree>
  800632:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  800635:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  80063c:	e8 9b 17 00 00       	call   801ddc <sys_calculate_free_frames>
  800641:	89 c2                	mov    %eax,%edx
  800643:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800646:	29 c2                	sub    %eax,%edx
  800648:	89 d0                	mov    %edx,%eax
  80064a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  80064d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800650:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800653:	74 27                	je     80067c <_main+0x644>
  800655:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80065c:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80065f:	e8 78 17 00 00       	call   801ddc <sys_calculate_free_frames>
  800664:	29 c3                	sub    %eax,%ebx
  800666:	89 d8                	mov    %ebx,%eax
  800668:	83 ec 04             	sub    $0x4,%esp
  80066b:	50                   	push   %eax
  80066c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80066f:	68 34 42 80 00       	push   $0x804234
  800674:	e8 39 04 00 00       	call   800ab2 <cprintf>
  800679:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step C completed!!\n\n\n");
  80067c:	83 ec 0c             	sub    $0xc,%esp
  80067f:	68 cf 43 80 00       	push   $0x8043cf
  800684:	e8 29 04 00 00       	call   800ab2 <cprintf>
  800689:	83 c4 10             	add    $0x10,%esp
	if (is_correct)	eval+=50;
  80068c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800690:	74 04                	je     800696 <_main+0x65e>
  800692:	83 45 f4 32          	addl   $0x32,-0xc(%ebp)
	is_correct = 1;
  800696:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("\n%~Test of freeSharedObjects [4] completed. Eval = %d%%\n\n", eval);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a3:	68 e8 43 80 00       	push   $0x8043e8
  8006a8:	e8 05 04 00 00       	call   800ab2 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp

	return;
  8006b0:	90                   	nop
}
  8006b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8006bc:	e8 e4 18 00 00       	call   801fa5 <sys_getenvindex>
  8006c1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8006c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c7:	89 d0                	mov    %edx,%eax
  8006c9:	c1 e0 03             	shl    $0x3,%eax
  8006cc:	01 d0                	add    %edx,%eax
  8006ce:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8006d5:	01 c8                	add    %ecx,%eax
  8006d7:	01 c0                	add    %eax,%eax
  8006d9:	01 d0                	add    %edx,%eax
  8006db:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8006e2:	01 c8                	add    %ecx,%eax
  8006e4:	01 d0                	add    %edx,%eax
  8006e6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006eb:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f5:	8a 40 20             	mov    0x20(%eax),%al
  8006f8:	84 c0                	test   %al,%al
  8006fa:	74 0d                	je     800709 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	83 c0 20             	add    $0x20,%eax
  800704:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800709:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80070d:	7e 0a                	jle    800719 <libmain+0x63>
		binaryname = argv[0];
  80070f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 0c             	pushl  0xc(%ebp)
  80071f:	ff 75 08             	pushl  0x8(%ebp)
  800722:	e8 11 f9 ff ff       	call   800038 <_main>
  800727:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80072a:	e8 fa 15 00 00       	call   801d29 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	68 3c 44 80 00       	push   $0x80443c
  800737:	e8 76 03 00 00       	call   800ab2 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80073f:	a1 20 50 80 00       	mov    0x805020,%eax
  800744:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80074a:	a1 20 50 80 00       	mov    0x805020,%eax
  80074f:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800755:	83 ec 04             	sub    $0x4,%esp
  800758:	52                   	push   %edx
  800759:	50                   	push   %eax
  80075a:	68 64 44 80 00       	push   $0x804464
  80075f:	e8 4e 03 00 00       	call   800ab2 <cprintf>
  800764:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800767:	a1 20 50 80 00       	mov    0x805020,%eax
  80076c:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800772:	a1 20 50 80 00       	mov    0x805020,%eax
  800777:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80077d:	a1 20 50 80 00       	mov    0x805020,%eax
  800782:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800788:	51                   	push   %ecx
  800789:	52                   	push   %edx
  80078a:	50                   	push   %eax
  80078b:	68 8c 44 80 00       	push   $0x80448c
  800790:	e8 1d 03 00 00       	call   800ab2 <cprintf>
  800795:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800798:	a1 20 50 80 00       	mov    0x805020,%eax
  80079d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	50                   	push   %eax
  8007a7:	68 e4 44 80 00       	push   $0x8044e4
  8007ac:	e8 01 03 00 00       	call   800ab2 <cprintf>
  8007b1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8007b4:	83 ec 0c             	sub    $0xc,%esp
  8007b7:	68 3c 44 80 00       	push   $0x80443c
  8007bc:	e8 f1 02 00 00       	call   800ab2 <cprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8007c4:	e8 7a 15 00 00       	call   801d43 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8007c9:	e8 19 00 00 00       	call   8007e7 <exit>
}
  8007ce:	90                   	nop
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    

008007d1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	6a 00                	push   $0x0
  8007dc:	e8 90 17 00 00       	call   801f71 <sys_destroy_env>
  8007e1:	83 c4 10             	add    $0x10,%esp
}
  8007e4:	90                   	nop
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <exit>:

void
exit(void)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007ed:	e8 e5 17 00 00       	call   801fd7 <sys_exit_env>
}
  8007f2:	90                   	nop
  8007f3:	c9                   	leave  
  8007f4:	c3                   	ret    

008007f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007fb:	8d 45 10             	lea    0x10(%ebp),%eax
  8007fe:	83 c0 04             	add    $0x4,%eax
  800801:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800804:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800809:	85 c0                	test   %eax,%eax
  80080b:	74 16                	je     800823 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80080d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	50                   	push   %eax
  800816:	68 f8 44 80 00       	push   $0x8044f8
  80081b:	e8 92 02 00 00       	call   800ab2 <cprintf>
  800820:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800823:	a1 00 50 80 00       	mov    0x805000,%eax
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	50                   	push   %eax
  80082f:	68 fd 44 80 00       	push   $0x8044fd
  800834:	e8 79 02 00 00       	call   800ab2 <cprintf>
  800839:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80083c:	8b 45 10             	mov    0x10(%ebp),%eax
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 f4             	pushl  -0xc(%ebp)
  800845:	50                   	push   %eax
  800846:	e8 fc 01 00 00       	call   800a47 <vcprintf>
  80084b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	6a 00                	push   $0x0
  800853:	68 19 45 80 00       	push   $0x804519
  800858:	e8 ea 01 00 00       	call   800a47 <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800860:	e8 82 ff ff ff       	call   8007e7 <exit>

	// should not return here
	while (1) ;
  800865:	eb fe                	jmp    800865 <_panic+0x70>

00800867 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80086d:	a1 20 50 80 00       	mov    0x805020,%eax
  800872:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087b:	39 c2                	cmp    %eax,%edx
  80087d:	74 14                	je     800893 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	68 1c 45 80 00       	push   $0x80451c
  800887:	6a 26                	push   $0x26
  800889:	68 68 45 80 00       	push   $0x804568
  80088e:	e8 62 ff ff ff       	call   8007f5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800893:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80089a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008a1:	e9 c5 00 00 00       	jmp    80096b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8008a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	01 d0                	add    %edx,%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	85 c0                	test   %eax,%eax
  8008b9:	75 08                	jne    8008c3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8008bb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008be:	e9 a5 00 00 00       	jmp    800968 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8008c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008d1:	eb 69                	jmp    80093c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8008d8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8008de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008e1:	89 d0                	mov    %edx,%eax
  8008e3:	01 c0                	add    %eax,%eax
  8008e5:	01 d0                	add    %edx,%eax
  8008e7:	c1 e0 03             	shl    $0x3,%eax
  8008ea:	01 c8                	add    %ecx,%eax
  8008ec:	8a 40 04             	mov    0x4(%eax),%al
  8008ef:	84 c0                	test   %al,%al
  8008f1:	75 46                	jne    800939 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8008f8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8008fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800901:	89 d0                	mov    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	c1 e0 03             	shl    $0x3,%eax
  80090a:	01 c8                	add    %ecx,%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800911:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800914:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800919:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80091b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80091e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	01 c8                	add    %ecx,%eax
  80092a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80092c:	39 c2                	cmp    %eax,%edx
  80092e:	75 09                	jne    800939 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800930:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800937:	eb 15                	jmp    80094e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800939:	ff 45 e8             	incl   -0x18(%ebp)
  80093c:	a1 20 50 80 00       	mov    0x805020,%eax
  800941:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80094a:	39 c2                	cmp    %eax,%edx
  80094c:	77 85                	ja     8008d3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80094e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800952:	75 14                	jne    800968 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800954:	83 ec 04             	sub    $0x4,%esp
  800957:	68 74 45 80 00       	push   $0x804574
  80095c:	6a 3a                	push   $0x3a
  80095e:	68 68 45 80 00       	push   $0x804568
  800963:	e8 8d fe ff ff       	call   8007f5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800968:	ff 45 f0             	incl   -0x10(%ebp)
  80096b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800971:	0f 8c 2f ff ff ff    	jl     8008a6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800977:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80097e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800985:	eb 26                	jmp    8009ad <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800987:	a1 20 50 80 00       	mov    0x805020,%eax
  80098c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800992:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800995:	89 d0                	mov    %edx,%eax
  800997:	01 c0                	add    %eax,%eax
  800999:	01 d0                	add    %edx,%eax
  80099b:	c1 e0 03             	shl    $0x3,%eax
  80099e:	01 c8                	add    %ecx,%eax
  8009a0:	8a 40 04             	mov    0x4(%eax),%al
  8009a3:	3c 01                	cmp    $0x1,%al
  8009a5:	75 03                	jne    8009aa <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8009a7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009aa:	ff 45 e0             	incl   -0x20(%ebp)
  8009ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8009b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009bb:	39 c2                	cmp    %eax,%edx
  8009bd:	77 c8                	ja     800987 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009c5:	74 14                	je     8009db <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	68 c8 45 80 00       	push   $0x8045c8
  8009cf:	6a 44                	push   $0x44
  8009d1:	68 68 45 80 00       	push   $0x804568
  8009d6:	e8 1a fe ff ff       	call   8007f5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009db:	90                   	nop
  8009dc:	c9                   	leave  
  8009dd:	c3                   	ret    

008009de <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e7:	8b 00                	mov    (%eax),%eax
  8009e9:	8d 48 01             	lea    0x1(%eax),%ecx
  8009ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ef:	89 0a                	mov    %ecx,(%edx)
  8009f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f4:	88 d1                	mov    %dl,%cl
  8009f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a00:	8b 00                	mov    (%eax),%eax
  800a02:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a07:	75 2c                	jne    800a35 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a09:	a0 28 50 80 00       	mov    0x805028,%al
  800a0e:	0f b6 c0             	movzbl %al,%eax
  800a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a14:	8b 12                	mov    (%edx),%edx
  800a16:	89 d1                	mov    %edx,%ecx
  800a18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1b:	83 c2 08             	add    $0x8,%edx
  800a1e:	83 ec 04             	sub    $0x4,%esp
  800a21:	50                   	push   %eax
  800a22:	51                   	push   %ecx
  800a23:	52                   	push   %edx
  800a24:	e8 be 12 00 00       	call   801ce7 <sys_cputs>
  800a29:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a38:	8b 40 04             	mov    0x4(%eax),%eax
  800a3b:	8d 50 01             	lea    0x1(%eax),%edx
  800a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a41:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a44:	90                   	nop
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a50:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a57:	00 00 00 
	b.cnt = 0;
  800a5a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a61:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	ff 75 08             	pushl  0x8(%ebp)
  800a6a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a70:	50                   	push   %eax
  800a71:	68 de 09 80 00       	push   $0x8009de
  800a76:	e8 11 02 00 00       	call   800c8c <vprintfmt>
  800a7b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a7e:	a0 28 50 80 00       	mov    0x805028,%al
  800a83:	0f b6 c0             	movzbl %al,%eax
  800a86:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	50                   	push   %eax
  800a90:	52                   	push   %edx
  800a91:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a97:	83 c0 08             	add    $0x8,%eax
  800a9a:	50                   	push   %eax
  800a9b:	e8 47 12 00 00       	call   801ce7 <sys_cputs>
  800aa0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800aa3:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800aaa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ab8:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800abf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ace:	50                   	push   %eax
  800acf:	e8 73 ff ff ff       	call   800a47 <vcprintf>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800add:	c9                   	leave  
  800ade:	c3                   	ret    

00800adf <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800ae5:	e8 3f 12 00 00       	call   801d29 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800aea:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	ff 75 f4             	pushl  -0xc(%ebp)
  800af9:	50                   	push   %eax
  800afa:	e8 48 ff ff ff       	call   800a47 <vcprintf>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b05:	e8 39 12 00 00       	call   801d43 <sys_unlock_cons>
	return cnt;
  800b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b0d:	c9                   	leave  
  800b0e:	c3                   	ret    

00800b0f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	53                   	push   %ebx
  800b13:	83 ec 14             	sub    $0x14,%esp
  800b16:	8b 45 10             	mov    0x10(%ebp),%eax
  800b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b22:	8b 45 18             	mov    0x18(%ebp),%eax
  800b25:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b2d:	77 55                	ja     800b84 <printnum+0x75>
  800b2f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b32:	72 05                	jb     800b39 <printnum+0x2a>
  800b34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b37:	77 4b                	ja     800b84 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b39:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b3c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b3f:	8b 45 18             	mov    0x18(%ebp),%eax
  800b42:	ba 00 00 00 00       	mov    $0x0,%edx
  800b47:	52                   	push   %edx
  800b48:	50                   	push   %eax
  800b49:	ff 75 f4             	pushl  -0xc(%ebp)
  800b4c:	ff 75 f0             	pushl  -0x10(%ebp)
  800b4f:	e8 2c 32 00 00       	call   803d80 <__udivdi3>
  800b54:	83 c4 10             	add    $0x10,%esp
  800b57:	83 ec 04             	sub    $0x4,%esp
  800b5a:	ff 75 20             	pushl  0x20(%ebp)
  800b5d:	53                   	push   %ebx
  800b5e:	ff 75 18             	pushl  0x18(%ebp)
  800b61:	52                   	push   %edx
  800b62:	50                   	push   %eax
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	ff 75 08             	pushl  0x8(%ebp)
  800b69:	e8 a1 ff ff ff       	call   800b0f <printnum>
  800b6e:	83 c4 20             	add    $0x20,%esp
  800b71:	eb 1a                	jmp    800b8d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	ff 75 20             	pushl  0x20(%ebp)
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	ff d0                	call   *%eax
  800b81:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b84:	ff 4d 1c             	decl   0x1c(%ebp)
  800b87:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b8b:	7f e6                	jg     800b73 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b8d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9b:	53                   	push   %ebx
  800b9c:	51                   	push   %ecx
  800b9d:	52                   	push   %edx
  800b9e:	50                   	push   %eax
  800b9f:	e8 ec 32 00 00       	call   803e90 <__umoddi3>
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	05 34 48 80 00       	add    $0x804834,%eax
  800bac:	8a 00                	mov    (%eax),%al
  800bae:	0f be c0             	movsbl %al,%eax
  800bb1:	83 ec 08             	sub    $0x8,%esp
  800bb4:	ff 75 0c             	pushl  0xc(%ebp)
  800bb7:	50                   	push   %eax
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	ff d0                	call   *%eax
  800bbd:	83 c4 10             	add    $0x10,%esp
}
  800bc0:	90                   	nop
  800bc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bcd:	7e 1c                	jle    800beb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8b 00                	mov    (%eax),%eax
  800bd4:	8d 50 08             	lea    0x8(%eax),%edx
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	89 10                	mov    %edx,(%eax)
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8b 00                	mov    (%eax),%eax
  800be1:	83 e8 08             	sub    $0x8,%eax
  800be4:	8b 50 04             	mov    0x4(%eax),%edx
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	eb 40                	jmp    800c2b <getuint+0x65>
	else if (lflag)
  800beb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bef:	74 1e                	je     800c0f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	8b 00                	mov    (%eax),%eax
  800bf6:	8d 50 04             	lea    0x4(%eax),%edx
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	89 10                	mov    %edx,(%eax)
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8b 00                	mov    (%eax),%eax
  800c03:	83 e8 04             	sub    $0x4,%eax
  800c06:	8b 00                	mov    (%eax),%eax
  800c08:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0d:	eb 1c                	jmp    800c2b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	8d 50 04             	lea    0x4(%eax),%edx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 10                	mov    %edx,(%eax)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8b 00                	mov    (%eax),%eax
  800c21:	83 e8 04             	sub    $0x4,%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c30:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c34:	7e 1c                	jle    800c52 <getint+0x25>
		return va_arg(*ap, long long);
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	8b 00                	mov    (%eax),%eax
  800c3b:	8d 50 08             	lea    0x8(%eax),%edx
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	89 10                	mov    %edx,(%eax)
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	8b 00                	mov    (%eax),%eax
  800c48:	83 e8 08             	sub    $0x8,%eax
  800c4b:	8b 50 04             	mov    0x4(%eax),%edx
  800c4e:	8b 00                	mov    (%eax),%eax
  800c50:	eb 38                	jmp    800c8a <getint+0x5d>
	else if (lflag)
  800c52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c56:	74 1a                	je     800c72 <getint+0x45>
		return va_arg(*ap, long);
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8b 00                	mov    (%eax),%eax
  800c5d:	8d 50 04             	lea    0x4(%eax),%edx
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	89 10                	mov    %edx,(%eax)
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8b 00                	mov    (%eax),%eax
  800c6a:	83 e8 04             	sub    $0x4,%eax
  800c6d:	8b 00                	mov    (%eax),%eax
  800c6f:	99                   	cltd   
  800c70:	eb 18                	jmp    800c8a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 00                	mov    (%eax),%eax
  800c77:	8d 50 04             	lea    0x4(%eax),%edx
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	89 10                	mov    %edx,(%eax)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8b 00                	mov    (%eax),%eax
  800c84:	83 e8 04             	sub    $0x4,%eax
  800c87:	8b 00                	mov    (%eax),%eax
  800c89:	99                   	cltd   
}
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c94:	eb 17                	jmp    800cad <vprintfmt+0x21>
			if (ch == '\0')
  800c96:	85 db                	test   %ebx,%ebx
  800c98:	0f 84 c1 03 00 00    	je     80105f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c9e:	83 ec 08             	sub    $0x8,%esp
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	53                   	push   %ebx
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	ff d0                	call   *%eax
  800caa:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cad:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb0:	8d 50 01             	lea    0x1(%eax),%edx
  800cb3:	89 55 10             	mov    %edx,0x10(%ebp)
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	0f b6 d8             	movzbl %al,%ebx
  800cbb:	83 fb 25             	cmp    $0x25,%ebx
  800cbe:	75 d6                	jne    800c96 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cc0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cc4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ccb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cd2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cd9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce3:	8d 50 01             	lea    0x1(%eax),%edx
  800ce6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 d8             	movzbl %al,%ebx
  800cee:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cf1:	83 f8 5b             	cmp    $0x5b,%eax
  800cf4:	0f 87 3d 03 00 00    	ja     801037 <vprintfmt+0x3ab>
  800cfa:	8b 04 85 58 48 80 00 	mov    0x804858(,%eax,4),%eax
  800d01:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d03:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d07:	eb d7                	jmp    800ce0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d09:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d0d:	eb d1                	jmp    800ce0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d0f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d16:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d19:	89 d0                	mov    %edx,%eax
  800d1b:	c1 e0 02             	shl    $0x2,%eax
  800d1e:	01 d0                	add    %edx,%eax
  800d20:	01 c0                	add    %eax,%eax
  800d22:	01 d8                	add    %ebx,%eax
  800d24:	83 e8 30             	sub    $0x30,%eax
  800d27:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d32:	83 fb 2f             	cmp    $0x2f,%ebx
  800d35:	7e 3e                	jle    800d75 <vprintfmt+0xe9>
  800d37:	83 fb 39             	cmp    $0x39,%ebx
  800d3a:	7f 39                	jg     800d75 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d3c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d3f:	eb d5                	jmp    800d16 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 c0 04             	add    $0x4,%eax
  800d47:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4d:	83 e8 04             	sub    $0x4,%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d55:	eb 1f                	jmp    800d76 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5b:	79 83                	jns    800ce0 <vprintfmt+0x54>
				width = 0;
  800d5d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d64:	e9 77 ff ff ff       	jmp    800ce0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d69:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d70:	e9 6b ff ff ff       	jmp    800ce0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d75:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d7a:	0f 89 60 ff ff ff    	jns    800ce0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d86:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d8d:	e9 4e ff ff ff       	jmp    800ce0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d92:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d95:	e9 46 ff ff ff       	jmp    800ce0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	83 c0 04             	add    $0x4,%eax
  800da0:	89 45 14             	mov    %eax,0x14(%ebp)
  800da3:	8b 45 14             	mov    0x14(%ebp),%eax
  800da6:	83 e8 04             	sub    $0x4,%eax
  800da9:	8b 00                	mov    (%eax),%eax
  800dab:	83 ec 08             	sub    $0x8,%esp
  800dae:	ff 75 0c             	pushl  0xc(%ebp)
  800db1:	50                   	push   %eax
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	ff d0                	call   *%eax
  800db7:	83 c4 10             	add    $0x10,%esp
			break;
  800dba:	e9 9b 02 00 00       	jmp    80105a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc2:	83 c0 04             	add    $0x4,%eax
  800dc5:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcb:	83 e8 04             	sub    $0x4,%eax
  800dce:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800dd0:	85 db                	test   %ebx,%ebx
  800dd2:	79 02                	jns    800dd6 <vprintfmt+0x14a>
				err = -err;
  800dd4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dd6:	83 fb 64             	cmp    $0x64,%ebx
  800dd9:	7f 0b                	jg     800de6 <vprintfmt+0x15a>
  800ddb:	8b 34 9d a0 46 80 00 	mov    0x8046a0(,%ebx,4),%esi
  800de2:	85 f6                	test   %esi,%esi
  800de4:	75 19                	jne    800dff <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800de6:	53                   	push   %ebx
  800de7:	68 45 48 80 00       	push   $0x804845
  800dec:	ff 75 0c             	pushl  0xc(%ebp)
  800def:	ff 75 08             	pushl  0x8(%ebp)
  800df2:	e8 70 02 00 00       	call   801067 <printfmt>
  800df7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dfa:	e9 5b 02 00 00       	jmp    80105a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dff:	56                   	push   %esi
  800e00:	68 4e 48 80 00       	push   $0x80484e
  800e05:	ff 75 0c             	pushl  0xc(%ebp)
  800e08:	ff 75 08             	pushl  0x8(%ebp)
  800e0b:	e8 57 02 00 00       	call   801067 <printfmt>
  800e10:	83 c4 10             	add    $0x10,%esp
			break;
  800e13:	e9 42 02 00 00       	jmp    80105a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e18:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1b:	83 c0 04             	add    $0x4,%eax
  800e1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800e21:	8b 45 14             	mov    0x14(%ebp),%eax
  800e24:	83 e8 04             	sub    $0x4,%eax
  800e27:	8b 30                	mov    (%eax),%esi
  800e29:	85 f6                	test   %esi,%esi
  800e2b:	75 05                	jne    800e32 <vprintfmt+0x1a6>
				p = "(null)";
  800e2d:	be 51 48 80 00       	mov    $0x804851,%esi
			if (width > 0 && padc != '-')
  800e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e36:	7e 6d                	jle    800ea5 <vprintfmt+0x219>
  800e38:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e3c:	74 67                	je     800ea5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	50                   	push   %eax
  800e45:	56                   	push   %esi
  800e46:	e8 1e 03 00 00       	call   801169 <strnlen>
  800e4b:	83 c4 10             	add    $0x10,%esp
  800e4e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e51:	eb 16                	jmp    800e69 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e53:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	50                   	push   %eax
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	ff d0                	call   *%eax
  800e63:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e66:	ff 4d e4             	decl   -0x1c(%ebp)
  800e69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6d:	7f e4                	jg     800e53 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e6f:	eb 34                	jmp    800ea5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e71:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e75:	74 1c                	je     800e93 <vprintfmt+0x207>
  800e77:	83 fb 1f             	cmp    $0x1f,%ebx
  800e7a:	7e 05                	jle    800e81 <vprintfmt+0x1f5>
  800e7c:	83 fb 7e             	cmp    $0x7e,%ebx
  800e7f:	7e 12                	jle    800e93 <vprintfmt+0x207>
					putch('?', putdat);
  800e81:	83 ec 08             	sub    $0x8,%esp
  800e84:	ff 75 0c             	pushl  0xc(%ebp)
  800e87:	6a 3f                	push   $0x3f
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	ff d0                	call   *%eax
  800e8e:	83 c4 10             	add    $0x10,%esp
  800e91:	eb 0f                	jmp    800ea2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e93:	83 ec 08             	sub    $0x8,%esp
  800e96:	ff 75 0c             	pushl  0xc(%ebp)
  800e99:	53                   	push   %ebx
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	ff d0                	call   *%eax
  800e9f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ea2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ea5:	89 f0                	mov    %esi,%eax
  800ea7:	8d 70 01             	lea    0x1(%eax),%esi
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f be d8             	movsbl %al,%ebx
  800eaf:	85 db                	test   %ebx,%ebx
  800eb1:	74 24                	je     800ed7 <vprintfmt+0x24b>
  800eb3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eb7:	78 b8                	js     800e71 <vprintfmt+0x1e5>
  800eb9:	ff 4d e0             	decl   -0x20(%ebp)
  800ebc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ec0:	79 af                	jns    800e71 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ec2:	eb 13                	jmp    800ed7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	6a 20                	push   $0x20
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	ff d0                	call   *%eax
  800ed1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ed4:	ff 4d e4             	decl   -0x1c(%ebp)
  800ed7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800edb:	7f e7                	jg     800ec4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800edd:	e9 78 01 00 00       	jmp    80105a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ee2:	83 ec 08             	sub    $0x8,%esp
  800ee5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ee8:	8d 45 14             	lea    0x14(%ebp),%eax
  800eeb:	50                   	push   %eax
  800eec:	e8 3c fd ff ff       	call   800c2d <getint>
  800ef1:	83 c4 10             	add    $0x10,%esp
  800ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800efd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f00:	85 d2                	test   %edx,%edx
  800f02:	79 23                	jns    800f27 <vprintfmt+0x29b>
				putch('-', putdat);
  800f04:	83 ec 08             	sub    $0x8,%esp
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	6a 2d                	push   $0x2d
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	ff d0                	call   *%eax
  800f11:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1a:	f7 d8                	neg    %eax
  800f1c:	83 d2 00             	adc    $0x0,%edx
  800f1f:	f7 da                	neg    %edx
  800f21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f27:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f2e:	e9 bc 00 00 00       	jmp    800fef <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f33:	83 ec 08             	sub    $0x8,%esp
  800f36:	ff 75 e8             	pushl  -0x18(%ebp)
  800f39:	8d 45 14             	lea    0x14(%ebp),%eax
  800f3c:	50                   	push   %eax
  800f3d:	e8 84 fc ff ff       	call   800bc6 <getuint>
  800f42:	83 c4 10             	add    $0x10,%esp
  800f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f48:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f4b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f52:	e9 98 00 00 00       	jmp    800fef <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f57:	83 ec 08             	sub    $0x8,%esp
  800f5a:	ff 75 0c             	pushl  0xc(%ebp)
  800f5d:	6a 58                	push   $0x58
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	ff d0                	call   *%eax
  800f64:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f67:	83 ec 08             	sub    $0x8,%esp
  800f6a:	ff 75 0c             	pushl  0xc(%ebp)
  800f6d:	6a 58                	push   $0x58
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	ff d0                	call   *%eax
  800f74:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f77:	83 ec 08             	sub    $0x8,%esp
  800f7a:	ff 75 0c             	pushl  0xc(%ebp)
  800f7d:	6a 58                	push   $0x58
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	ff d0                	call   *%eax
  800f84:	83 c4 10             	add    $0x10,%esp
			break;
  800f87:	e9 ce 00 00 00       	jmp    80105a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f8c:	83 ec 08             	sub    $0x8,%esp
  800f8f:	ff 75 0c             	pushl  0xc(%ebp)
  800f92:	6a 30                	push   $0x30
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	ff d0                	call   *%eax
  800f99:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f9c:	83 ec 08             	sub    $0x8,%esp
  800f9f:	ff 75 0c             	pushl  0xc(%ebp)
  800fa2:	6a 78                	push   $0x78
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	ff d0                	call   *%eax
  800fa9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fac:	8b 45 14             	mov    0x14(%ebp),%eax
  800faf:	83 c0 04             	add    $0x4,%eax
  800fb2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb8:	83 e8 04             	sub    $0x4,%eax
  800fbb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fc7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fce:	eb 1f                	jmp    800fef <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fd0:	83 ec 08             	sub    $0x8,%esp
  800fd3:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd6:	8d 45 14             	lea    0x14(%ebp),%eax
  800fd9:	50                   	push   %eax
  800fda:	e8 e7 fb ff ff       	call   800bc6 <getuint>
  800fdf:	83 c4 10             	add    $0x10,%esp
  800fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fe8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fef:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ff6:	83 ec 04             	sub    $0x4,%esp
  800ff9:	52                   	push   %edx
  800ffa:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	ff 75 f4             	pushl  -0xc(%ebp)
  801001:	ff 75 f0             	pushl  -0x10(%ebp)
  801004:	ff 75 0c             	pushl  0xc(%ebp)
  801007:	ff 75 08             	pushl  0x8(%ebp)
  80100a:	e8 00 fb ff ff       	call   800b0f <printnum>
  80100f:	83 c4 20             	add    $0x20,%esp
			break;
  801012:	eb 46                	jmp    80105a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801014:	83 ec 08             	sub    $0x8,%esp
  801017:	ff 75 0c             	pushl  0xc(%ebp)
  80101a:	53                   	push   %ebx
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	ff d0                	call   *%eax
  801020:	83 c4 10             	add    $0x10,%esp
			break;
  801023:	eb 35                	jmp    80105a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801025:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  80102c:	eb 2c                	jmp    80105a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80102e:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  801035:	eb 23                	jmp    80105a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	ff 75 0c             	pushl  0xc(%ebp)
  80103d:	6a 25                	push   $0x25
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	ff d0                	call   *%eax
  801044:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801047:	ff 4d 10             	decl   0x10(%ebp)
  80104a:	eb 03                	jmp    80104f <vprintfmt+0x3c3>
  80104c:	ff 4d 10             	decl   0x10(%ebp)
  80104f:	8b 45 10             	mov    0x10(%ebp),%eax
  801052:	48                   	dec    %eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3c 25                	cmp    $0x25,%al
  801057:	75 f3                	jne    80104c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801059:	90                   	nop
		}
	}
  80105a:	e9 35 fc ff ff       	jmp    800c94 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80105f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801060:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801063:	5b                   	pop    %ebx
  801064:	5e                   	pop    %esi
  801065:	5d                   	pop    %ebp
  801066:	c3                   	ret    

00801067 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80106d:	8d 45 10             	lea    0x10(%ebp),%eax
  801070:	83 c0 04             	add    $0x4,%eax
  801073:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801076:	8b 45 10             	mov    0x10(%ebp),%eax
  801079:	ff 75 f4             	pushl  -0xc(%ebp)
  80107c:	50                   	push   %eax
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 04 fc ff ff       	call   800c8c <vprintfmt>
  801088:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80108b:	90                   	nop
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	8b 40 08             	mov    0x8(%eax),%eax
  801097:	8d 50 01             	lea    0x1(%eax),%edx
  80109a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a3:	8b 10                	mov    (%eax),%edx
  8010a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a8:	8b 40 04             	mov    0x4(%eax),%eax
  8010ab:	39 c2                	cmp    %eax,%edx
  8010ad:	73 12                	jae    8010c1 <sprintputch+0x33>
		*b->buf++ = ch;
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	8b 00                	mov    (%eax),%eax
  8010b4:	8d 48 01             	lea    0x1(%eax),%ecx
  8010b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ba:	89 0a                	mov    %ecx,(%edx)
  8010bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bf:	88 10                	mov    %dl,(%eax)
}
  8010c1:	90                   	nop
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	01 d0                	add    %edx,%eax
  8010db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010e9:	74 06                	je     8010f1 <vsnprintf+0x2d>
  8010eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ef:	7f 07                	jg     8010f8 <vsnprintf+0x34>
		return -E_INVAL;
  8010f1:	b8 03 00 00 00       	mov    $0x3,%eax
  8010f6:	eb 20                	jmp    801118 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010f8:	ff 75 14             	pushl  0x14(%ebp)
  8010fb:	ff 75 10             	pushl  0x10(%ebp)
  8010fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801101:	50                   	push   %eax
  801102:	68 8e 10 80 00       	push   $0x80108e
  801107:	e8 80 fb ff ff       	call   800c8c <vprintfmt>
  80110c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80110f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801112:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801115:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801120:	8d 45 10             	lea    0x10(%ebp),%eax
  801123:	83 c0 04             	add    $0x4,%eax
  801126:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801129:	8b 45 10             	mov    0x10(%ebp),%eax
  80112c:	ff 75 f4             	pushl  -0xc(%ebp)
  80112f:	50                   	push   %eax
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	ff 75 08             	pushl  0x8(%ebp)
  801136:	e8 89 ff ff ff       	call   8010c4 <vsnprintf>
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801141:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80114c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801153:	eb 06                	jmp    80115b <strlen+0x15>
		n++;
  801155:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801158:	ff 45 08             	incl   0x8(%ebp)
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	84 c0                	test   %al,%al
  801162:	75 f1                	jne    801155 <strlen+0xf>
		n++;
	return n;
  801164:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80116f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801176:	eb 09                	jmp    801181 <strnlen+0x18>
		n++;
  801178:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80117b:	ff 45 08             	incl   0x8(%ebp)
  80117e:	ff 4d 0c             	decl   0xc(%ebp)
  801181:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801185:	74 09                	je     801190 <strnlen+0x27>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	84 c0                	test   %al,%al
  80118e:	75 e8                	jne    801178 <strnlen+0xf>
		n++;
	return n;
  801190:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801193:	c9                   	leave  
  801194:	c3                   	ret    

00801195 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011a1:	90                   	nop
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011b4:	8a 12                	mov    (%edx),%dl
  8011b6:	88 10                	mov    %dl,(%eax)
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	84 c0                	test   %al,%al
  8011bc:	75 e4                	jne    8011a2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

008011c3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d6:	eb 1f                	jmp    8011f7 <strncpy+0x34>
		*dst++ = *src;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8d 50 01             	lea    0x1(%eax),%edx
  8011de:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e4:	8a 12                	mov    (%edx),%dl
  8011e6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	84 c0                	test   %al,%al
  8011ef:	74 03                	je     8011f4 <strncpy+0x31>
			src++;
  8011f1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011f4:	ff 45 fc             	incl   -0x4(%ebp)
  8011f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011fa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011fd:	72 d9                	jb     8011d8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801210:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801214:	74 30                	je     801246 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801216:	eb 16                	jmp    80122e <strlcpy+0x2a>
			*dst++ = *src++;
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	8d 50 01             	lea    0x1(%eax),%edx
  80121e:	89 55 08             	mov    %edx,0x8(%ebp)
  801221:	8b 55 0c             	mov    0xc(%ebp),%edx
  801224:	8d 4a 01             	lea    0x1(%edx),%ecx
  801227:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80122a:	8a 12                	mov    (%edx),%dl
  80122c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80122e:	ff 4d 10             	decl   0x10(%ebp)
  801231:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801235:	74 09                	je     801240 <strlcpy+0x3c>
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	84 c0                	test   %al,%al
  80123e:	75 d8                	jne    801218 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801246:	8b 55 08             	mov    0x8(%ebp),%edx
  801249:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124c:	29 c2                	sub    %eax,%edx
  80124e:	89 d0                	mov    %edx,%eax
}
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801255:	eb 06                	jmp    80125d <strcmp+0xb>
		p++, q++;
  801257:	ff 45 08             	incl   0x8(%ebp)
  80125a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	84 c0                	test   %al,%al
  801264:	74 0e                	je     801274 <strcmp+0x22>
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	8a 10                	mov    (%eax),%dl
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	38 c2                	cmp    %al,%dl
  801272:	74 e3                	je     801257 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	0f b6 d0             	movzbl %al,%edx
  80127c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	0f b6 c0             	movzbl %al,%eax
  801284:	29 c2                	sub    %eax,%edx
  801286:	89 d0                	mov    %edx,%eax
}
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    

0080128a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80128d:	eb 09                	jmp    801298 <strncmp+0xe>
		n--, p++, q++;
  80128f:	ff 4d 10             	decl   0x10(%ebp)
  801292:	ff 45 08             	incl   0x8(%ebp)
  801295:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801298:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80129c:	74 17                	je     8012b5 <strncmp+0x2b>
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	84 c0                	test   %al,%al
  8012a5:	74 0e                	je     8012b5 <strncmp+0x2b>
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8a 10                	mov    (%eax),%dl
  8012ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	38 c2                	cmp    %al,%dl
  8012b3:	74 da                	je     80128f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b9:	75 07                	jne    8012c2 <strncmp+0x38>
		return 0;
  8012bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c0:	eb 14                	jmp    8012d6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	0f b6 d0             	movzbl %al,%edx
  8012ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f b6 c0             	movzbl %al,%eax
  8012d2:	29 c2                	sub    %eax,%edx
  8012d4:	89 d0                	mov    %edx,%eax
}
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    

008012d8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 04             	sub    $0x4,%esp
  8012de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012e4:	eb 12                	jmp    8012f8 <strchr+0x20>
		if (*s == c)
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012ee:	75 05                	jne    8012f5 <strchr+0x1d>
			return (char *) s;
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	eb 11                	jmp    801306 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012f5:	ff 45 08             	incl   0x8(%ebp)
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	84 c0                	test   %al,%al
  8012ff:	75 e5                	jne    8012e6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801301:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801306:	c9                   	leave  
  801307:	c3                   	ret    

00801308 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801311:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801314:	eb 0d                	jmp    801323 <strfind+0x1b>
		if (*s == c)
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80131e:	74 0e                	je     80132e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801320:	ff 45 08             	incl   0x8(%ebp)
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	84 c0                	test   %al,%al
  80132a:	75 ea                	jne    801316 <strfind+0xe>
  80132c:	eb 01                	jmp    80132f <strfind+0x27>
		if (*s == c)
			break;
  80132e:	90                   	nop
	return (char *) s;
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801346:	eb 0e                	jmp    801356 <memset+0x22>
		*p++ = c;
  801348:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134b:	8d 50 01             	lea    0x1(%eax),%edx
  80134e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801351:	8b 55 0c             	mov    0xc(%ebp),%edx
  801354:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801356:	ff 4d f8             	decl   -0x8(%ebp)
  801359:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80135d:	79 e9                	jns    801348 <memset+0x14>
		*p++ = c;

	return v;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80136a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801376:	eb 16                	jmp    80138e <memcpy+0x2a>
		*d++ = *s++;
  801378:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137b:	8d 50 01             	lea    0x1(%eax),%edx
  80137e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801381:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801384:	8d 4a 01             	lea    0x1(%edx),%ecx
  801387:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80138a:	8a 12                	mov    (%edx),%dl
  80138c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80138e:	8b 45 10             	mov    0x10(%ebp),%eax
  801391:	8d 50 ff             	lea    -0x1(%eax),%edx
  801394:	89 55 10             	mov    %edx,0x10(%ebp)
  801397:	85 c0                	test   %eax,%eax
  801399:	75 dd                	jne    801378 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    

008013a0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013b8:	73 50                	jae    80140a <memmove+0x6a>
  8013ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c0:	01 d0                	add    %edx,%eax
  8013c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013c5:	76 43                	jbe    80140a <memmove+0x6a>
		s += n;
  8013c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ca:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013d3:	eb 10                	jmp    8013e5 <memmove+0x45>
			*--d = *--s;
  8013d5:	ff 4d f8             	decl   -0x8(%ebp)
  8013d8:	ff 4d fc             	decl   -0x4(%ebp)
  8013db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013de:	8a 10                	mov    (%eax),%dl
  8013e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	75 e3                	jne    8013d5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013f2:	eb 23                	jmp    801417 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f7:	8d 50 01             	lea    0x1(%eax),%edx
  8013fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801400:	8d 4a 01             	lea    0x1(%edx),%ecx
  801403:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801406:	8a 12                	mov    (%edx),%dl
  801408:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80140a:	8b 45 10             	mov    0x10(%ebp),%eax
  80140d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801410:	89 55 10             	mov    %edx,0x10(%ebp)
  801413:	85 c0                	test   %eax,%eax
  801415:	75 dd                	jne    8013f4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80142e:	eb 2a                	jmp    80145a <memcmp+0x3e>
		if (*s1 != *s2)
  801430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801433:	8a 10                	mov    (%eax),%dl
  801435:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	38 c2                	cmp    %al,%dl
  80143c:	74 16                	je     801454 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80143e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	0f b6 d0             	movzbl %al,%edx
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	8a 00                	mov    (%eax),%al
  80144b:	0f b6 c0             	movzbl %al,%eax
  80144e:	29 c2                	sub    %eax,%edx
  801450:	89 d0                	mov    %edx,%eax
  801452:	eb 18                	jmp    80146c <memcmp+0x50>
		s1++, s2++;
  801454:	ff 45 fc             	incl   -0x4(%ebp)
  801457:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80145a:	8b 45 10             	mov    0x10(%ebp),%eax
  80145d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801460:	89 55 10             	mov    %edx,0x10(%ebp)
  801463:	85 c0                	test   %eax,%eax
  801465:	75 c9                	jne    801430 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801474:	8b 55 08             	mov    0x8(%ebp),%edx
  801477:	8b 45 10             	mov    0x10(%ebp),%eax
  80147a:	01 d0                	add    %edx,%eax
  80147c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80147f:	eb 15                	jmp    801496 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8a 00                	mov    (%eax),%al
  801486:	0f b6 d0             	movzbl %al,%edx
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	0f b6 c0             	movzbl %al,%eax
  80148f:	39 c2                	cmp    %eax,%edx
  801491:	74 0d                	je     8014a0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801493:	ff 45 08             	incl   0x8(%ebp)
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80149c:	72 e3                	jb     801481 <memfind+0x13>
  80149e:	eb 01                	jmp    8014a1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014a0:	90                   	nop
	return (void *) s;
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    

008014a6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ba:	eb 03                	jmp    8014bf <strtol+0x19>
		s++;
  8014bc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	3c 20                	cmp    $0x20,%al
  8014c6:	74 f4                	je     8014bc <strtol+0x16>
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8a 00                	mov    (%eax),%al
  8014cd:	3c 09                	cmp    $0x9,%al
  8014cf:	74 eb                	je     8014bc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3c 2b                	cmp    $0x2b,%al
  8014d8:	75 05                	jne    8014df <strtol+0x39>
		s++;
  8014da:	ff 45 08             	incl   0x8(%ebp)
  8014dd:	eb 13                	jmp    8014f2 <strtol+0x4c>
	else if (*s == '-')
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	3c 2d                	cmp    $0x2d,%al
  8014e6:	75 0a                	jne    8014f2 <strtol+0x4c>
		s++, neg = 1;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
  8014eb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f6:	74 06                	je     8014fe <strtol+0x58>
  8014f8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014fc:	75 20                	jne    80151e <strtol+0x78>
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	3c 30                	cmp    $0x30,%al
  801505:	75 17                	jne    80151e <strtol+0x78>
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	40                   	inc    %eax
  80150b:	8a 00                	mov    (%eax),%al
  80150d:	3c 78                	cmp    $0x78,%al
  80150f:	75 0d                	jne    80151e <strtol+0x78>
		s += 2, base = 16;
  801511:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801515:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80151c:	eb 28                	jmp    801546 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80151e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801522:	75 15                	jne    801539 <strtol+0x93>
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	3c 30                	cmp    $0x30,%al
  80152b:	75 0c                	jne    801539 <strtol+0x93>
		s++, base = 8;
  80152d:	ff 45 08             	incl   0x8(%ebp)
  801530:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801537:	eb 0d                	jmp    801546 <strtol+0xa0>
	else if (base == 0)
  801539:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80153d:	75 07                	jne    801546 <strtol+0xa0>
		base = 10;
  80153f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8a 00                	mov    (%eax),%al
  80154b:	3c 2f                	cmp    $0x2f,%al
  80154d:	7e 19                	jle    801568 <strtol+0xc2>
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	8a 00                	mov    (%eax),%al
  801554:	3c 39                	cmp    $0x39,%al
  801556:	7f 10                	jg     801568 <strtol+0xc2>
			dig = *s - '0';
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	0f be c0             	movsbl %al,%eax
  801560:	83 e8 30             	sub    $0x30,%eax
  801563:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801566:	eb 42                	jmp    8015aa <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	3c 60                	cmp    $0x60,%al
  80156f:	7e 19                	jle    80158a <strtol+0xe4>
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	8a 00                	mov    (%eax),%al
  801576:	3c 7a                	cmp    $0x7a,%al
  801578:	7f 10                	jg     80158a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	8a 00                	mov    (%eax),%al
  80157f:	0f be c0             	movsbl %al,%eax
  801582:	83 e8 57             	sub    $0x57,%eax
  801585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801588:	eb 20                	jmp    8015aa <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8a 00                	mov    (%eax),%al
  80158f:	3c 40                	cmp    $0x40,%al
  801591:	7e 39                	jle    8015cc <strtol+0x126>
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	3c 5a                	cmp    $0x5a,%al
  80159a:	7f 30                	jg     8015cc <strtol+0x126>
			dig = *s - 'A' + 10;
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	0f be c0             	movsbl %al,%eax
  8015a4:	83 e8 37             	sub    $0x37,%eax
  8015a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ad:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015b0:	7d 19                	jge    8015cb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015b2:	ff 45 08             	incl   0x8(%ebp)
  8015b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015bc:	89 c2                	mov    %eax,%edx
  8015be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c1:	01 d0                	add    %edx,%eax
  8015c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015c6:	e9 7b ff ff ff       	jmp    801546 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015cb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d0:	74 08                	je     8015da <strtol+0x134>
		*endptr = (char *) s;
  8015d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015da:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015de:	74 07                	je     8015e7 <strtol+0x141>
  8015e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e3:	f7 d8                	neg    %eax
  8015e5:	eb 03                	jmp    8015ea <strtol+0x144>
  8015e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <ltostr>:

void
ltostr(long value, char *str)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015f9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801600:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801604:	79 13                	jns    801619 <ltostr+0x2d>
	{
		neg = 1;
  801606:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801613:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801616:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801621:	99                   	cltd   
  801622:	f7 f9                	idiv   %ecx
  801624:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801627:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80162a:	8d 50 01             	lea    0x1(%eax),%edx
  80162d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801630:	89 c2                	mov    %eax,%edx
  801632:	8b 45 0c             	mov    0xc(%ebp),%eax
  801635:	01 d0                	add    %edx,%eax
  801637:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80163a:	83 c2 30             	add    $0x30,%edx
  80163d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80163f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801642:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801647:	f7 e9                	imul   %ecx
  801649:	c1 fa 02             	sar    $0x2,%edx
  80164c:	89 c8                	mov    %ecx,%eax
  80164e:	c1 f8 1f             	sar    $0x1f,%eax
  801651:	29 c2                	sub    %eax,%edx
  801653:	89 d0                	mov    %edx,%eax
  801655:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801658:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80165c:	75 bb                	jne    801619 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80165e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801665:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801668:	48                   	dec    %eax
  801669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80166c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801670:	74 3d                	je     8016af <ltostr+0xc3>
		start = 1 ;
  801672:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801679:	eb 34                	jmp    8016af <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80167b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80167e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801681:	01 d0                	add    %edx,%eax
  801683:	8a 00                	mov    (%eax),%al
  801685:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801688:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168e:	01 c2                	add    %eax,%edx
  801690:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801693:	8b 45 0c             	mov    0xc(%ebp),%eax
  801696:	01 c8                	add    %ecx,%eax
  801698:	8a 00                	mov    (%eax),%al
  80169a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80169c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	01 c2                	add    %eax,%edx
  8016a4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016a7:	88 02                	mov    %al,(%edx)
		start++ ;
  8016a9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016ac:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8016af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016b5:	7c c4                	jl     80167b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016b7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016c2:	90                   	nop
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016cb:	ff 75 08             	pushl  0x8(%ebp)
  8016ce:	e8 73 fa ff ff       	call   801146 <strlen>
  8016d3:	83 c4 04             	add    $0x4,%esp
  8016d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	e8 65 fa ff ff       	call   801146 <strlen>
  8016e1:	83 c4 04             	add    $0x4,%esp
  8016e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016f5:	eb 17                	jmp    80170e <strcconcat+0x49>
		final[s] = str1[s] ;
  8016f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fd:	01 c2                	add    %eax,%edx
  8016ff:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	01 c8                	add    %ecx,%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80170b:	ff 45 fc             	incl   -0x4(%ebp)
  80170e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801711:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801714:	7c e1                	jl     8016f7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801716:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80171d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801724:	eb 1f                	jmp    801745 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801726:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801729:	8d 50 01             	lea    0x1(%eax),%edx
  80172c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80172f:	89 c2                	mov    %eax,%edx
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	01 c2                	add    %eax,%edx
  801736:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801739:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173c:	01 c8                	add    %ecx,%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801742:	ff 45 f8             	incl   -0x8(%ebp)
  801745:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801748:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80174b:	7c d9                	jl     801726 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80174d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801750:	8b 45 10             	mov    0x10(%ebp),%eax
  801753:	01 d0                	add    %edx,%eax
  801755:	c6 00 00             	movb   $0x0,(%eax)
}
  801758:	90                   	nop
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80175e:	8b 45 14             	mov    0x14(%ebp),%eax
  801761:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801767:	8b 45 14             	mov    0x14(%ebp),%eax
  80176a:	8b 00                	mov    (%eax),%eax
  80176c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801773:	8b 45 10             	mov    0x10(%ebp),%eax
  801776:	01 d0                	add    %edx,%eax
  801778:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80177e:	eb 0c                	jmp    80178c <strsplit+0x31>
			*string++ = 0;
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8d 50 01             	lea    0x1(%eax),%edx
  801786:	89 55 08             	mov    %edx,0x8(%ebp)
  801789:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	84 c0                	test   %al,%al
  801793:	74 18                	je     8017ad <strsplit+0x52>
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	0f be c0             	movsbl %al,%eax
  80179d:	50                   	push   %eax
  80179e:	ff 75 0c             	pushl  0xc(%ebp)
  8017a1:	e8 32 fb ff ff       	call   8012d8 <strchr>
  8017a6:	83 c4 08             	add    $0x8,%esp
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	75 d3                	jne    801780 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	84 c0                	test   %al,%al
  8017b4:	74 5a                	je     801810 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8017b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b9:	8b 00                	mov    (%eax),%eax
  8017bb:	83 f8 0f             	cmp    $0xf,%eax
  8017be:	75 07                	jne    8017c7 <strsplit+0x6c>
		{
			return 0;
  8017c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c5:	eb 66                	jmp    80182d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ca:	8b 00                	mov    (%eax),%eax
  8017cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8017cf:	8b 55 14             	mov    0x14(%ebp),%edx
  8017d2:	89 0a                	mov    %ecx,(%edx)
  8017d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017db:	8b 45 10             	mov    0x10(%ebp),%eax
  8017de:	01 c2                	add    %eax,%edx
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017e5:	eb 03                	jmp    8017ea <strsplit+0x8f>
			string++;
  8017e7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8a 00                	mov    (%eax),%al
  8017ef:	84 c0                	test   %al,%al
  8017f1:	74 8b                	je     80177e <strsplit+0x23>
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	8a 00                	mov    (%eax),%al
  8017f8:	0f be c0             	movsbl %al,%eax
  8017fb:	50                   	push   %eax
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	e8 d4 fa ff ff       	call   8012d8 <strchr>
  801804:	83 c4 08             	add    $0x8,%esp
  801807:	85 c0                	test   %eax,%eax
  801809:	74 dc                	je     8017e7 <strsplit+0x8c>
			string++;
	}
  80180b:	e9 6e ff ff ff       	jmp    80177e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801810:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801811:	8b 45 14             	mov    0x14(%ebp),%eax
  801814:	8b 00                	mov    (%eax),%eax
  801816:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80181d:	8b 45 10             	mov    0x10(%ebp),%eax
  801820:	01 d0                	add    %edx,%eax
  801822:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801828:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801835:	83 ec 04             	sub    $0x4,%esp
  801838:	68 c8 49 80 00       	push   $0x8049c8
  80183d:	68 3f 01 00 00       	push   $0x13f
  801842:	68 ea 49 80 00       	push   $0x8049ea
  801847:	e8 a9 ef ff ff       	call   8007f5 <_panic>

0080184c <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801852:	83 ec 0c             	sub    $0xc,%esp
  801855:	ff 75 08             	pushl  0x8(%ebp)
  801858:	e8 35 0a 00 00       	call   802292 <sys_sbrk>
  80185d:	83 c4 10             	add    $0x10,%esp
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801868:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80186c:	75 0a                	jne    801878 <malloc+0x16>
  80186e:	b8 00 00 00 00       	mov    $0x0,%eax
  801873:	e9 07 02 00 00       	jmp    801a7f <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801878:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80187f:	8b 55 08             	mov    0x8(%ebp),%edx
  801882:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801885:	01 d0                	add    %edx,%eax
  801887:	48                   	dec    %eax
  801888:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80188b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
  801893:	f7 75 dc             	divl   -0x24(%ebp)
  801896:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801899:	29 d0                	sub    %edx,%eax
  80189b:	c1 e8 0c             	shr    $0xc,%eax
  80189e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8018a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8018a6:	8b 40 78             	mov    0x78(%eax),%eax
  8018a9:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8018ae:	29 c2                	sub    %eax,%edx
  8018b0:	89 d0                	mov    %edx,%eax
  8018b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8018b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018bd:	c1 e8 0c             	shr    $0xc,%eax
  8018c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8018c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8018ca:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8018d1:	77 42                	ja     801915 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8018d3:	e8 3e 08 00 00       	call   802116 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	74 16                	je     8018f2 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8018dc:	83 ec 0c             	sub    $0xc,%esp
  8018df:	ff 75 08             	pushl  0x8(%ebp)
  8018e2:	e8 7e 0d 00 00       	call   802665 <alloc_block_FF>
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018ed:	e9 8a 01 00 00       	jmp    801a7c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8018f2:	e8 50 08 00 00       	call   802147 <sys_isUHeapPlacementStrategyBESTFIT>
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	0f 84 7d 01 00 00    	je     801a7c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	e8 17 12 00 00       	call   802b21 <alloc_block_BF>
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801910:	e9 67 01 00 00       	jmp    801a7c <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801915:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801918:	48                   	dec    %eax
  801919:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80191c:	0f 86 53 01 00 00    	jbe    801a75 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801922:	a1 20 50 80 00       	mov    0x805020,%eax
  801927:	8b 40 78             	mov    0x78(%eax),%eax
  80192a:	05 00 10 00 00       	add    $0x1000,%eax
  80192f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801932:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801939:	e9 de 00 00 00       	jmp    801a1c <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80193e:	a1 20 50 80 00       	mov    0x805020,%eax
  801943:	8b 40 78             	mov    0x78(%eax),%eax
  801946:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801949:	29 c2                	sub    %eax,%edx
  80194b:	89 d0                	mov    %edx,%eax
  80194d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801952:	c1 e8 0c             	shr    $0xc,%eax
  801955:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80195c:	85 c0                	test   %eax,%eax
  80195e:	0f 85 ab 00 00 00    	jne    801a0f <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801967:	05 00 10 00 00       	add    $0x1000,%eax
  80196c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80196f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801976:	eb 47                	jmp    8019bf <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801978:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80197f:	76 0a                	jbe    80198b <malloc+0x129>
  801981:	b8 00 00 00 00       	mov    $0x0,%eax
  801986:	e9 f4 00 00 00       	jmp    801a7f <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  80198b:	a1 20 50 80 00       	mov    0x805020,%eax
  801990:	8b 40 78             	mov    0x78(%eax),%eax
  801993:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801996:	29 c2                	sub    %eax,%edx
  801998:	89 d0                	mov    %edx,%eax
  80199a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80199f:	c1 e8 0c             	shr    $0xc,%eax
  8019a2:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	74 08                	je     8019b5 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  8019ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  8019b3:	eb 5a                	jmp    801a0f <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  8019b5:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  8019bc:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8019bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019c2:	48                   	dec    %eax
  8019c3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019c6:	77 b0                	ja     801978 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8019c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8019cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019d6:	eb 2f                	jmp    801a07 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8019d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019db:	c1 e0 0c             	shl    $0xc,%eax
  8019de:	89 c2                	mov    %eax,%edx
  8019e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e3:	01 c2                	add    %eax,%edx
  8019e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8019ea:	8b 40 78             	mov    0x78(%eax),%eax
  8019ed:	29 c2                	sub    %eax,%edx
  8019ef:	89 d0                	mov    %edx,%eax
  8019f1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019f6:	c1 e8 0c             	shr    $0xc,%eax
  8019f9:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  801a00:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801a04:	ff 45 e0             	incl   -0x20(%ebp)
  801a07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a0a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801a0d:	72 c9                	jb     8019d8 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801a0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a13:	75 16                	jne    801a2b <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801a15:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801a1c:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801a23:	0f 86 15 ff ff ff    	jbe    80193e <malloc+0xdc>
  801a29:	eb 01                	jmp    801a2c <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801a2b:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801a2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a30:	75 07                	jne    801a39 <malloc+0x1d7>
  801a32:	b8 00 00 00 00       	mov    $0x0,%eax
  801a37:	eb 46                	jmp    801a7f <malloc+0x21d>
		ptr = (void*)i;
  801a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801a3f:	a1 20 50 80 00       	mov    0x805020,%eax
  801a44:	8b 40 78             	mov    0x78(%eax),%eax
  801a47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a4a:	29 c2                	sub    %eax,%edx
  801a4c:	89 d0                	mov    %edx,%eax
  801a4e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a53:	c1 e8 0c             	shr    $0xc,%eax
  801a56:	89 c2                	mov    %eax,%edx
  801a58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a5b:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	ff 75 08             	pushl  0x8(%ebp)
  801a68:	ff 75 f0             	pushl  -0x10(%ebp)
  801a6b:	e8 59 08 00 00       	call   8022c9 <sys_allocate_user_mem>
  801a70:	83 c4 10             	add    $0x10,%esp
  801a73:	eb 07                	jmp    801a7c <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801a75:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7a:	eb 03                	jmp    801a7f <malloc+0x21d>
	}
	return ptr;
  801a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801a87:	a1 20 50 80 00       	mov    0x805020,%eax
  801a8c:	8b 40 78             	mov    0x78(%eax),%eax
  801a8f:	05 00 10 00 00       	add    $0x1000,%eax
  801a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801a97:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801a9e:	a1 20 50 80 00       	mov    0x805020,%eax
  801aa3:	8b 50 78             	mov    0x78(%eax),%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	39 c2                	cmp    %eax,%edx
  801aab:	76 24                	jbe    801ad1 <free+0x50>
		size = get_block_size(va);
  801aad:	83 ec 0c             	sub    $0xc,%esp
  801ab0:	ff 75 08             	pushl  0x8(%ebp)
  801ab3:	e8 2d 08 00 00       	call   8022e5 <get_block_size>
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801abe:	83 ec 0c             	sub    $0xc,%esp
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	e8 60 1a 00 00       	call   803529 <free_block>
  801ac9:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801acc:	e9 ac 00 00 00       	jmp    801b7d <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ad7:	0f 82 89 00 00 00    	jb     801b66 <free+0xe5>
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801ae5:	77 7f                	ja     801b66 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801ae7:	8b 55 08             	mov    0x8(%ebp),%edx
  801aea:	a1 20 50 80 00       	mov    0x805020,%eax
  801aef:	8b 40 78             	mov    0x78(%eax),%eax
  801af2:	29 c2                	sub    %eax,%edx
  801af4:	89 d0                	mov    %edx,%eax
  801af6:	2d 00 10 00 00       	sub    $0x1000,%eax
  801afb:	c1 e8 0c             	shr    $0xc,%eax
  801afe:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801b05:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b0b:	c1 e0 0c             	shl    $0xc,%eax
  801b0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801b11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801b18:	eb 2f                	jmp    801b49 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1d:	c1 e0 0c             	shl    $0xc,%eax
  801b20:	89 c2                	mov    %eax,%edx
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	01 c2                	add    %eax,%edx
  801b27:	a1 20 50 80 00       	mov    0x805020,%eax
  801b2c:	8b 40 78             	mov    0x78(%eax),%eax
  801b2f:	29 c2                	sub    %eax,%edx
  801b31:	89 d0                	mov    %edx,%eax
  801b33:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b38:	c1 e8 0c             	shr    $0xc,%eax
  801b3b:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801b42:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801b46:	ff 45 f4             	incl   -0xc(%ebp)
  801b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b4f:	72 c9                	jb     801b1a <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	83 ec 08             	sub    $0x8,%esp
  801b57:	ff 75 ec             	pushl  -0x14(%ebp)
  801b5a:	50                   	push   %eax
  801b5b:	e8 4d 07 00 00       	call   8022ad <sys_free_user_mem>
  801b60:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801b63:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801b64:	eb 17                	jmp    801b7d <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801b66:	83 ec 04             	sub    $0x4,%esp
  801b69:	68 f8 49 80 00       	push   $0x8049f8
  801b6e:	68 84 00 00 00       	push   $0x84
  801b73:	68 22 4a 80 00       	push   $0x804a22
  801b78:	e8 78 ec ff ff       	call   8007f5 <_panic>
	}
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 28             	sub    $0x28,%esp
  801b85:	8b 45 10             	mov    0x10(%ebp),%eax
  801b88:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b8f:	75 07                	jne    801b98 <smalloc+0x19>
  801b91:	b8 00 00 00 00       	mov    $0x0,%eax
  801b96:	eb 74                	jmp    801c0c <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b9e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ba5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bab:	39 d0                	cmp    %edx,%eax
  801bad:	73 02                	jae    801bb1 <smalloc+0x32>
  801baf:	89 d0                	mov    %edx,%eax
  801bb1:	83 ec 0c             	sub    $0xc,%esp
  801bb4:	50                   	push   %eax
  801bb5:	e8 a8 fc ff ff       	call   801862 <malloc>
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801bc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bc4:	75 07                	jne    801bcd <smalloc+0x4e>
  801bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcb:	eb 3f                	jmp    801c0c <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801bcd:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801bd1:	ff 75 ec             	pushl  -0x14(%ebp)
  801bd4:	50                   	push   %eax
  801bd5:	ff 75 0c             	pushl  0xc(%ebp)
  801bd8:	ff 75 08             	pushl  0x8(%ebp)
  801bdb:	e8 d4 02 00 00       	call   801eb4 <sys_createSharedObject>
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801be6:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801bea:	74 06                	je     801bf2 <smalloc+0x73>
  801bec:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801bf0:	75 07                	jne    801bf9 <smalloc+0x7a>
  801bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf7:	eb 13                	jmp    801c0c <smalloc+0x8d>
	 cprintf("153\n");
  801bf9:	83 ec 0c             	sub    $0xc,%esp
  801bfc:	68 2e 4a 80 00       	push   $0x804a2e
  801c01:	e8 ac ee ff ff       	call   800ab2 <cprintf>
  801c06:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c14:	83 ec 04             	sub    $0x4,%esp
  801c17:	68 34 4a 80 00       	push   $0x804a34
  801c1c:	68 a4 00 00 00       	push   $0xa4
  801c21:	68 22 4a 80 00       	push   $0x804a22
  801c26:	e8 ca eb ff ff       	call   8007f5 <_panic>

00801c2b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c31:	83 ec 04             	sub    $0x4,%esp
  801c34:	68 58 4a 80 00       	push   $0x804a58
  801c39:	68 bc 00 00 00       	push   $0xbc
  801c3e:	68 22 4a 80 00       	push   $0x804a22
  801c43:	e8 ad eb ff ff       	call   8007f5 <_panic>

00801c48 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c4e:	83 ec 04             	sub    $0x4,%esp
  801c51:	68 7c 4a 80 00       	push   $0x804a7c
  801c56:	68 d3 00 00 00       	push   $0xd3
  801c5b:	68 22 4a 80 00       	push   $0x804a22
  801c60:	e8 90 eb ff ff       	call   8007f5 <_panic>

00801c65 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c6b:	83 ec 04             	sub    $0x4,%esp
  801c6e:	68 a2 4a 80 00       	push   $0x804aa2
  801c73:	68 df 00 00 00       	push   $0xdf
  801c78:	68 22 4a 80 00       	push   $0x804a22
  801c7d:	e8 73 eb ff ff       	call   8007f5 <_panic>

00801c82 <shrink>:

}
void shrink(uint32 newSize)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c88:	83 ec 04             	sub    $0x4,%esp
  801c8b:	68 a2 4a 80 00       	push   $0x804aa2
  801c90:	68 e4 00 00 00       	push   $0xe4
  801c95:	68 22 4a 80 00       	push   $0x804a22
  801c9a:	e8 56 eb ff ff       	call   8007f5 <_panic>

00801c9f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ca5:	83 ec 04             	sub    $0x4,%esp
  801ca8:	68 a2 4a 80 00       	push   $0x804aa2
  801cad:	68 e9 00 00 00       	push   $0xe9
  801cb2:	68 22 4a 80 00       	push   $0x804a22
  801cb7:	e8 39 eb ff ff       	call   8007f5 <_panic>

00801cbc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	57                   	push   %edi
  801cc0:	56                   	push   %esi
  801cc1:	53                   	push   %ebx
  801cc2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cd4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cd7:	cd 30                	int    $0x30
  801cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	5b                   	pop    %ebx
  801ce3:	5e                   	pop    %esi
  801ce4:	5f                   	pop    %edi
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    

00801ce7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cf3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	52                   	push   %edx
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	50                   	push   %eax
  801d03:	6a 00                	push   $0x0
  801d05:	e8 b2 ff ff ff       	call   801cbc <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	90                   	nop
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 02                	push   $0x2
  801d1f:	e8 98 ff ff ff       	call   801cbc <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 03                	push   $0x3
  801d38:	e8 7f ff ff ff       	call   801cbc <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	90                   	nop
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 04                	push   $0x4
  801d52:	e8 65 ff ff ff       	call   801cbc <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	90                   	nop
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	52                   	push   %edx
  801d6d:	50                   	push   %eax
  801d6e:	6a 08                	push   $0x8
  801d70:	e8 47 ff ff ff       	call   801cbc <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	56                   	push   %esi
  801d7e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d7f:	8b 75 18             	mov    0x18(%ebp),%esi
  801d82:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d85:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	56                   	push   %esi
  801d8f:	53                   	push   %ebx
  801d90:	51                   	push   %ecx
  801d91:	52                   	push   %edx
  801d92:	50                   	push   %eax
  801d93:	6a 09                	push   $0x9
  801d95:	e8 22 ff ff ff       	call   801cbc <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da0:	5b                   	pop    %ebx
  801da1:	5e                   	pop    %esi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801da7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	52                   	push   %edx
  801db4:	50                   	push   %eax
  801db5:	6a 0a                	push   $0xa
  801db7:	e8 00 ff ff ff       	call   801cbc <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	6a 0b                	push   $0xb
  801dd2:	e8 e5 fe ff ff       	call   801cbc <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 0c                	push   $0xc
  801deb:	e8 cc fe ff ff       	call   801cbc <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 0d                	push   $0xd
  801e04:	e8 b3 fe ff ff       	call   801cbc <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 0e                	push   $0xe
  801e1d:	e8 9a fe ff ff       	call   801cbc <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 0f                	push   $0xf
  801e36:	e8 81 fe ff ff       	call   801cbc <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	ff 75 08             	pushl  0x8(%ebp)
  801e4e:	6a 10                	push   $0x10
  801e50:	e8 67 fe ff ff       	call   801cbc <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 11                	push   $0x11
  801e69:	e8 4e fe ff ff       	call   801cbc <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	90                   	nop
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_cputc>:

void
sys_cputc(const char c)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	83 ec 04             	sub    $0x4,%esp
  801e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e80:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	50                   	push   %eax
  801e8d:	6a 01                	push   $0x1
  801e8f:	e8 28 fe ff ff       	call   801cbc <syscall>
  801e94:	83 c4 18             	add    $0x18,%esp
}
  801e97:	90                   	nop
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 14                	push   $0x14
  801ea9:	e8 0e fe ff ff       	call   801cbc <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
}
  801eb1:	90                   	nop
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	83 ec 04             	sub    $0x4,%esp
  801eba:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ec0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ec3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	51                   	push   %ecx
  801ecd:	52                   	push   %edx
  801ece:	ff 75 0c             	pushl  0xc(%ebp)
  801ed1:	50                   	push   %eax
  801ed2:	6a 15                	push   $0x15
  801ed4:	e8 e3 fd ff ff       	call   801cbc <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ee1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	52                   	push   %edx
  801eee:	50                   	push   %eax
  801eef:	6a 16                	push   $0x16
  801ef1:	e8 c6 fd ff ff       	call   801cbc <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801efe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	51                   	push   %ecx
  801f0c:	52                   	push   %edx
  801f0d:	50                   	push   %eax
  801f0e:	6a 17                	push   $0x17
  801f10:	e8 a7 fd ff ff       	call   801cbc <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	52                   	push   %edx
  801f2a:	50                   	push   %eax
  801f2b:	6a 18                	push   $0x18
  801f2d:	e8 8a fd ff ff       	call   801cbc <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	6a 00                	push   $0x0
  801f3f:	ff 75 14             	pushl  0x14(%ebp)
  801f42:	ff 75 10             	pushl  0x10(%ebp)
  801f45:	ff 75 0c             	pushl  0xc(%ebp)
  801f48:	50                   	push   %eax
  801f49:	6a 19                	push   $0x19
  801f4b:	e8 6c fd ff ff       	call   801cbc <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	50                   	push   %eax
  801f64:	6a 1a                	push   $0x1a
  801f66:	e8 51 fd ff ff       	call   801cbc <syscall>
  801f6b:	83 c4 18             	add    $0x18,%esp
}
  801f6e:	90                   	nop
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	50                   	push   %eax
  801f80:	6a 1b                	push   $0x1b
  801f82:	e8 35 fd ff ff       	call   801cbc <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 05                	push   $0x5
  801f9b:	e8 1c fd ff ff       	call   801cbc <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 06                	push   $0x6
  801fb4:	e8 03 fd ff ff       	call   801cbc <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 07                	push   $0x7
  801fcd:	e8 ea fc ff ff       	call   801cbc <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sys_exit_env>:


void sys_exit_env(void)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 1c                	push   $0x1c
  801fe6:	e8 d1 fc ff ff       	call   801cbc <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
}
  801fee:	90                   	nop
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ff7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ffa:	8d 50 04             	lea    0x4(%eax),%edx
  801ffd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	52                   	push   %edx
  802007:	50                   	push   %eax
  802008:	6a 1d                	push   $0x1d
  80200a:	e8 ad fc ff ff       	call   801cbc <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
	return result;
  802012:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802015:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802018:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80201b:	89 01                	mov    %eax,(%ecx)
  80201d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	c9                   	leave  
  802024:	c2 04 00             	ret    $0x4

00802027 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	ff 75 10             	pushl  0x10(%ebp)
  802031:	ff 75 0c             	pushl  0xc(%ebp)
  802034:	ff 75 08             	pushl  0x8(%ebp)
  802037:	6a 13                	push   $0x13
  802039:	e8 7e fc ff ff       	call   801cbc <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
	return ;
  802041:	90                   	nop
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_rcr2>:
uint32 sys_rcr2()
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 1e                	push   $0x1e
  802053:	e8 64 fc ff ff       	call   801cbc <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802069:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	50                   	push   %eax
  802076:	6a 1f                	push   $0x1f
  802078:	e8 3f fc ff ff       	call   801cbc <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
	return ;
  802080:	90                   	nop
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <rsttst>:
void rsttst()
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 21                	push   $0x21
  802092:	e8 25 fc ff ff       	call   801cbc <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
	return ;
  80209a:	90                   	nop
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020a9:	8b 55 18             	mov    0x18(%ebp),%edx
  8020ac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020b0:	52                   	push   %edx
  8020b1:	50                   	push   %eax
  8020b2:	ff 75 10             	pushl  0x10(%ebp)
  8020b5:	ff 75 0c             	pushl  0xc(%ebp)
  8020b8:	ff 75 08             	pushl  0x8(%ebp)
  8020bb:	6a 20                	push   $0x20
  8020bd:	e8 fa fb ff ff       	call   801cbc <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c5:	90                   	nop
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <chktst>:
void chktst(uint32 n)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	ff 75 08             	pushl  0x8(%ebp)
  8020d6:	6a 22                	push   $0x22
  8020d8:	e8 df fb ff ff       	call   801cbc <syscall>
  8020dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e0:	90                   	nop
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <inctst>:

void inctst()
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 23                	push   $0x23
  8020f2:	e8 c5 fb ff ff       	call   801cbc <syscall>
  8020f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fa:	90                   	nop
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <gettst>:
uint32 gettst()
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 24                	push   $0x24
  80210c:	e8 ab fb ff ff       	call   801cbc <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 25                	push   $0x25
  802128:	e8 8f fb ff ff       	call   801cbc <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
  802130:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802133:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802137:	75 07                	jne    802140 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802139:	b8 01 00 00 00       	mov    $0x1,%eax
  80213e:	eb 05                	jmp    802145 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 25                	push   $0x25
  802159:	e8 5e fb ff ff       	call   801cbc <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
  802161:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802164:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802168:	75 07                	jne    802171 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80216a:	b8 01 00 00 00       	mov    $0x1,%eax
  80216f:	eb 05                	jmp    802176 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802171:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 25                	push   $0x25
  80218a:	e8 2d fb ff ff       	call   801cbc <syscall>
  80218f:	83 c4 18             	add    $0x18,%esp
  802192:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802195:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802199:	75 07                	jne    8021a2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80219b:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a0:	eb 05                	jmp    8021a7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 25                	push   $0x25
  8021bb:	e8 fc fa ff ff       	call   801cbc <syscall>
  8021c0:	83 c4 18             	add    $0x18,%esp
  8021c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021c6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021ca:	75 07                	jne    8021d3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d1:	eb 05                	jmp    8021d8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	ff 75 08             	pushl  0x8(%ebp)
  8021e8:	6a 26                	push   $0x26
  8021ea:	e8 cd fa ff ff       	call   801cbc <syscall>
  8021ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f2:	90                   	nop
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	6a 00                	push   $0x0
  802207:	53                   	push   %ebx
  802208:	51                   	push   %ecx
  802209:	52                   	push   %edx
  80220a:	50                   	push   %eax
  80220b:	6a 27                	push   $0x27
  80220d:	e8 aa fa ff ff       	call   801cbc <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
}
  802215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80221d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	52                   	push   %edx
  80222a:	50                   	push   %eax
  80222b:	6a 28                	push   $0x28
  80222d:	e8 8a fa ff ff       	call   801cbc <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80223a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80223d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	6a 00                	push   $0x0
  802245:	51                   	push   %ecx
  802246:	ff 75 10             	pushl  0x10(%ebp)
  802249:	52                   	push   %edx
  80224a:	50                   	push   %eax
  80224b:	6a 29                	push   $0x29
  80224d:	e8 6a fa ff ff       	call   801cbc <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	ff 75 10             	pushl  0x10(%ebp)
  802261:	ff 75 0c             	pushl  0xc(%ebp)
  802264:	ff 75 08             	pushl  0x8(%ebp)
  802267:	6a 12                	push   $0x12
  802269:	e8 4e fa ff ff       	call   801cbc <syscall>
  80226e:	83 c4 18             	add    $0x18,%esp
	return ;
  802271:	90                   	nop
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	52                   	push   %edx
  802284:	50                   	push   %eax
  802285:	6a 2a                	push   $0x2a
  802287:	e8 30 fa ff ff       	call   801cbc <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
	return;
  80228f:	90                   	nop
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	50                   	push   %eax
  8022a1:	6a 2b                	push   $0x2b
  8022a3:	e8 14 fa ff ff       	call   801cbc <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	ff 75 0c             	pushl  0xc(%ebp)
  8022b9:	ff 75 08             	pushl  0x8(%ebp)
  8022bc:	6a 2c                	push   $0x2c
  8022be:	e8 f9 f9 ff ff       	call   801cbc <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
	return;
  8022c6:	90                   	nop
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	ff 75 0c             	pushl  0xc(%ebp)
  8022d5:	ff 75 08             	pushl  0x8(%ebp)
  8022d8:	6a 2d                	push   $0x2d
  8022da:	e8 dd f9 ff ff       	call   801cbc <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
	return;
  8022e2:	90                   	nop
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	83 e8 04             	sub    $0x4,%eax
  8022f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8022f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f7:	8b 00                	mov    (%eax),%eax
  8022f9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	83 e8 04             	sub    $0x4,%eax
  80230a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80230d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802310:	8b 00                	mov    (%eax),%eax
  802312:	83 e0 01             	and    $0x1,%eax
  802315:	85 c0                	test   %eax,%eax
  802317:	0f 94 c0             	sete   %al
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802322:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802329:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232c:	83 f8 02             	cmp    $0x2,%eax
  80232f:	74 2b                	je     80235c <alloc_block+0x40>
  802331:	83 f8 02             	cmp    $0x2,%eax
  802334:	7f 07                	jg     80233d <alloc_block+0x21>
  802336:	83 f8 01             	cmp    $0x1,%eax
  802339:	74 0e                	je     802349 <alloc_block+0x2d>
  80233b:	eb 58                	jmp    802395 <alloc_block+0x79>
  80233d:	83 f8 03             	cmp    $0x3,%eax
  802340:	74 2d                	je     80236f <alloc_block+0x53>
  802342:	83 f8 04             	cmp    $0x4,%eax
  802345:	74 3b                	je     802382 <alloc_block+0x66>
  802347:	eb 4c                	jmp    802395 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802349:	83 ec 0c             	sub    $0xc,%esp
  80234c:	ff 75 08             	pushl  0x8(%ebp)
  80234f:	e8 11 03 00 00       	call   802665 <alloc_block_FF>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80235a:	eb 4a                	jmp    8023a6 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80235c:	83 ec 0c             	sub    $0xc,%esp
  80235f:	ff 75 08             	pushl  0x8(%ebp)
  802362:	e8 fa 19 00 00       	call   803d61 <alloc_block_NF>
  802367:	83 c4 10             	add    $0x10,%esp
  80236a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80236d:	eb 37                	jmp    8023a6 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80236f:	83 ec 0c             	sub    $0xc,%esp
  802372:	ff 75 08             	pushl  0x8(%ebp)
  802375:	e8 a7 07 00 00       	call   802b21 <alloc_block_BF>
  80237a:	83 c4 10             	add    $0x10,%esp
  80237d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802380:	eb 24                	jmp    8023a6 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802382:	83 ec 0c             	sub    $0xc,%esp
  802385:	ff 75 08             	pushl  0x8(%ebp)
  802388:	e8 b7 19 00 00       	call   803d44 <alloc_block_WF>
  80238d:	83 c4 10             	add    $0x10,%esp
  802390:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802393:	eb 11                	jmp    8023a6 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802395:	83 ec 0c             	sub    $0xc,%esp
  802398:	68 b4 4a 80 00       	push   $0x804ab4
  80239d:	e8 10 e7 ff ff       	call   800ab2 <cprintf>
  8023a2:	83 c4 10             	add    $0x10,%esp
		break;
  8023a5:	90                   	nop
	}
	return va;
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	53                   	push   %ebx
  8023af:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8023b2:	83 ec 0c             	sub    $0xc,%esp
  8023b5:	68 d4 4a 80 00       	push   $0x804ad4
  8023ba:	e8 f3 e6 ff ff       	call   800ab2 <cprintf>
  8023bf:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8023c2:	83 ec 0c             	sub    $0xc,%esp
  8023c5:	68 ff 4a 80 00       	push   $0x804aff
  8023ca:	e8 e3 e6 ff ff       	call   800ab2 <cprintf>
  8023cf:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d8:	eb 37                	jmp    802411 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8023da:	83 ec 0c             	sub    $0xc,%esp
  8023dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8023e0:	e8 19 ff ff ff       	call   8022fe <is_free_block>
  8023e5:	83 c4 10             	add    $0x10,%esp
  8023e8:	0f be d8             	movsbl %al,%ebx
  8023eb:	83 ec 0c             	sub    $0xc,%esp
  8023ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8023f1:	e8 ef fe ff ff       	call   8022e5 <get_block_size>
  8023f6:	83 c4 10             	add    $0x10,%esp
  8023f9:	83 ec 04             	sub    $0x4,%esp
  8023fc:	53                   	push   %ebx
  8023fd:	50                   	push   %eax
  8023fe:	68 17 4b 80 00       	push   $0x804b17
  802403:	e8 aa e6 ff ff       	call   800ab2 <cprintf>
  802408:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80240b:	8b 45 10             	mov    0x10(%ebp),%eax
  80240e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802411:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802415:	74 07                	je     80241e <print_blocks_list+0x73>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	eb 05                	jmp    802423 <print_blocks_list+0x78>
  80241e:	b8 00 00 00 00       	mov    $0x0,%eax
  802423:	89 45 10             	mov    %eax,0x10(%ebp)
  802426:	8b 45 10             	mov    0x10(%ebp),%eax
  802429:	85 c0                	test   %eax,%eax
  80242b:	75 ad                	jne    8023da <print_blocks_list+0x2f>
  80242d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802431:	75 a7                	jne    8023da <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802433:	83 ec 0c             	sub    $0xc,%esp
  802436:	68 d4 4a 80 00       	push   $0x804ad4
  80243b:	e8 72 e6 ff ff       	call   800ab2 <cprintf>
  802440:	83 c4 10             	add    $0x10,%esp

}
  802443:	90                   	nop
  802444:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80244f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802452:	83 e0 01             	and    $0x1,%eax
  802455:	85 c0                	test   %eax,%eax
  802457:	74 03                	je     80245c <initialize_dynamic_allocator+0x13>
  802459:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80245c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802460:	0f 84 c7 01 00 00    	je     80262d <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802466:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80246d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802470:	8b 55 08             	mov    0x8(%ebp),%edx
  802473:	8b 45 0c             	mov    0xc(%ebp),%eax
  802476:	01 d0                	add    %edx,%eax
  802478:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80247d:	0f 87 ad 01 00 00    	ja     802630 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	85 c0                	test   %eax,%eax
  802488:	0f 89 a5 01 00 00    	jns    802633 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80248e:	8b 55 08             	mov    0x8(%ebp),%edx
  802491:	8b 45 0c             	mov    0xc(%ebp),%eax
  802494:	01 d0                	add    %edx,%eax
  802496:	83 e8 04             	sub    $0x4,%eax
  802499:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80249e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8024a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ad:	e9 87 00 00 00       	jmp    802539 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8024b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b6:	75 14                	jne    8024cc <initialize_dynamic_allocator+0x83>
  8024b8:	83 ec 04             	sub    $0x4,%esp
  8024bb:	68 2f 4b 80 00       	push   $0x804b2f
  8024c0:	6a 79                	push   $0x79
  8024c2:	68 4d 4b 80 00       	push   $0x804b4d
  8024c7:	e8 29 e3 ff ff       	call   8007f5 <_panic>
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 10                	je     8024e5 <initialize_dynamic_allocator+0x9c>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dd:	8b 52 04             	mov    0x4(%edx),%edx
  8024e0:	89 50 04             	mov    %edx,0x4(%eax)
  8024e3:	eb 0b                	jmp    8024f0 <initialize_dynamic_allocator+0xa7>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	a3 30 50 80 00       	mov    %eax,0x805030
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 04             	mov    0x4(%eax),%eax
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	74 0f                	je     802509 <initialize_dynamic_allocator+0xc0>
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 40 04             	mov    0x4(%eax),%eax
  802500:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802503:	8b 12                	mov    (%edx),%edx
  802505:	89 10                	mov    %edx,(%eax)
  802507:	eb 0a                	jmp    802513 <initialize_dynamic_allocator+0xca>
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 00                	mov    (%eax),%eax
  80250e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802526:	a1 38 50 80 00       	mov    0x805038,%eax
  80252b:	48                   	dec    %eax
  80252c:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802531:	a1 34 50 80 00       	mov    0x805034,%eax
  802536:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802539:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253d:	74 07                	je     802546 <initialize_dynamic_allocator+0xfd>
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	8b 00                	mov    (%eax),%eax
  802544:	eb 05                	jmp    80254b <initialize_dynamic_allocator+0x102>
  802546:	b8 00 00 00 00       	mov    $0x0,%eax
  80254b:	a3 34 50 80 00       	mov    %eax,0x805034
  802550:	a1 34 50 80 00       	mov    0x805034,%eax
  802555:	85 c0                	test   %eax,%eax
  802557:	0f 85 55 ff ff ff    	jne    8024b2 <initialize_dynamic_allocator+0x69>
  80255d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802561:	0f 85 4b ff ff ff    	jne    8024b2 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80256d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802570:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802576:	a1 44 50 80 00       	mov    0x805044,%eax
  80257b:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802580:	a1 40 50 80 00       	mov    0x805040,%eax
  802585:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	83 c0 08             	add    $0x8,%eax
  802591:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	83 c0 04             	add    $0x4,%eax
  80259a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259d:	83 ea 08             	sub    $0x8,%edx
  8025a0:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8025a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	01 d0                	add    %edx,%eax
  8025aa:	83 e8 08             	sub    $0x8,%eax
  8025ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b0:	83 ea 08             	sub    $0x8,%edx
  8025b3:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8025b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8025be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8025c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025cc:	75 17                	jne    8025e5 <initialize_dynamic_allocator+0x19c>
  8025ce:	83 ec 04             	sub    $0x4,%esp
  8025d1:	68 68 4b 80 00       	push   $0x804b68
  8025d6:	68 90 00 00 00       	push   $0x90
  8025db:	68 4d 4b 80 00       	push   $0x804b4d
  8025e0:	e8 10 e2 ff ff       	call   8007f5 <_panic>
  8025e5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ee:	89 10                	mov    %edx,(%eax)
  8025f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f3:	8b 00                	mov    (%eax),%eax
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	74 0d                	je     802606 <initialize_dynamic_allocator+0x1bd>
  8025f9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802601:	89 50 04             	mov    %edx,0x4(%eax)
  802604:	eb 08                	jmp    80260e <initialize_dynamic_allocator+0x1c5>
  802606:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802609:	a3 30 50 80 00       	mov    %eax,0x805030
  80260e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802611:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802616:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802619:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802620:	a1 38 50 80 00       	mov    0x805038,%eax
  802625:	40                   	inc    %eax
  802626:	a3 38 50 80 00       	mov    %eax,0x805038
  80262b:	eb 07                	jmp    802634 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80262d:	90                   	nop
  80262e:	eb 04                	jmp    802634 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802630:	90                   	nop
  802631:	eb 01                	jmp    802634 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802633:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802639:	8b 45 10             	mov    0x10(%ebp),%eax
  80263c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	8d 50 fc             	lea    -0x4(%eax),%edx
  802645:	8b 45 0c             	mov    0xc(%ebp),%eax
  802648:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	83 e8 04             	sub    $0x4,%eax
  802650:	8b 00                	mov    (%eax),%eax
  802652:	83 e0 fe             	and    $0xfffffffe,%eax
  802655:	8d 50 f8             	lea    -0x8(%eax),%edx
  802658:	8b 45 08             	mov    0x8(%ebp),%eax
  80265b:	01 c2                	add    %eax,%edx
  80265d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802660:	89 02                	mov    %eax,(%edx)
}
  802662:	90                   	nop
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    

00802665 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	83 e0 01             	and    $0x1,%eax
  802671:	85 c0                	test   %eax,%eax
  802673:	74 03                	je     802678 <alloc_block_FF+0x13>
  802675:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802678:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80267c:	77 07                	ja     802685 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80267e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802685:	a1 24 50 80 00       	mov    0x805024,%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	75 73                	jne    802701 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	83 c0 10             	add    $0x10,%eax
  802694:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802697:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80269e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a4:	01 d0                	add    %edx,%eax
  8026a6:	48                   	dec    %eax
  8026a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b2:	f7 75 ec             	divl   -0x14(%ebp)
  8026b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b8:	29 d0                	sub    %edx,%eax
  8026ba:	c1 e8 0c             	shr    $0xc,%eax
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	50                   	push   %eax
  8026c1:	e8 86 f1 ff ff       	call   80184c <sbrk>
  8026c6:	83 c4 10             	add    $0x10,%esp
  8026c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026cc:	83 ec 0c             	sub    $0xc,%esp
  8026cf:	6a 00                	push   $0x0
  8026d1:	e8 76 f1 ff ff       	call   80184c <sbrk>
  8026d6:	83 c4 10             	add    $0x10,%esp
  8026d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026df:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8026e2:	83 ec 08             	sub    $0x8,%esp
  8026e5:	50                   	push   %eax
  8026e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026e9:	e8 5b fd ff ff       	call   802449 <initialize_dynamic_allocator>
  8026ee:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026f1:	83 ec 0c             	sub    $0xc,%esp
  8026f4:	68 8b 4b 80 00       	push   $0x804b8b
  8026f9:	e8 b4 e3 ff ff       	call   800ab2 <cprintf>
  8026fe:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802701:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802705:	75 0a                	jne    802711 <alloc_block_FF+0xac>
	        return NULL;
  802707:	b8 00 00 00 00       	mov    $0x0,%eax
  80270c:	e9 0e 04 00 00       	jmp    802b1f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802711:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802718:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80271d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802720:	e9 f3 02 00 00       	jmp    802a18 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80272b:	83 ec 0c             	sub    $0xc,%esp
  80272e:	ff 75 bc             	pushl  -0x44(%ebp)
  802731:	e8 af fb ff ff       	call   8022e5 <get_block_size>
  802736:	83 c4 10             	add    $0x10,%esp
  802739:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	83 c0 08             	add    $0x8,%eax
  802742:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802745:	0f 87 c5 02 00 00    	ja     802a10 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	83 c0 18             	add    $0x18,%eax
  802751:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802754:	0f 87 19 02 00 00    	ja     802973 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80275a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80275d:	2b 45 08             	sub    0x8(%ebp),%eax
  802760:	83 e8 08             	sub    $0x8,%eax
  802763:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802766:	8b 45 08             	mov    0x8(%ebp),%eax
  802769:	8d 50 08             	lea    0x8(%eax),%edx
  80276c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80276f:	01 d0                	add    %edx,%eax
  802771:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	83 c0 08             	add    $0x8,%eax
  80277a:	83 ec 04             	sub    $0x4,%esp
  80277d:	6a 01                	push   $0x1
  80277f:	50                   	push   %eax
  802780:	ff 75 bc             	pushl  -0x44(%ebp)
  802783:	e8 ae fe ff ff       	call   802636 <set_block_data>
  802788:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 04             	mov    0x4(%eax),%eax
  802791:	85 c0                	test   %eax,%eax
  802793:	75 68                	jne    8027fd <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802795:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802799:	75 17                	jne    8027b2 <alloc_block_FF+0x14d>
  80279b:	83 ec 04             	sub    $0x4,%esp
  80279e:	68 68 4b 80 00       	push   $0x804b68
  8027a3:	68 d7 00 00 00       	push   $0xd7
  8027a8:	68 4d 4b 80 00       	push   $0x804b4d
  8027ad:	e8 43 e0 ff ff       	call   8007f5 <_panic>
  8027b2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8027b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027bb:	89 10                	mov    %edx,(%eax)
  8027bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027c0:	8b 00                	mov    (%eax),%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	74 0d                	je     8027d3 <alloc_block_FF+0x16e>
  8027c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027cb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027ce:	89 50 04             	mov    %edx,0x4(%eax)
  8027d1:	eb 08                	jmp    8027db <alloc_block_FF+0x176>
  8027d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8027db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027de:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f2:	40                   	inc    %eax
  8027f3:	a3 38 50 80 00       	mov    %eax,0x805038
  8027f8:	e9 dc 00 00 00       	jmp    8028d9 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 00                	mov    (%eax),%eax
  802802:	85 c0                	test   %eax,%eax
  802804:	75 65                	jne    80286b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802806:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80280a:	75 17                	jne    802823 <alloc_block_FF+0x1be>
  80280c:	83 ec 04             	sub    $0x4,%esp
  80280f:	68 9c 4b 80 00       	push   $0x804b9c
  802814:	68 db 00 00 00       	push   $0xdb
  802819:	68 4d 4b 80 00       	push   $0x804b4d
  80281e:	e8 d2 df ff ff       	call   8007f5 <_panic>
  802823:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802829:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80282c:	89 50 04             	mov    %edx,0x4(%eax)
  80282f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802832:	8b 40 04             	mov    0x4(%eax),%eax
  802835:	85 c0                	test   %eax,%eax
  802837:	74 0c                	je     802845 <alloc_block_FF+0x1e0>
  802839:	a1 30 50 80 00       	mov    0x805030,%eax
  80283e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802841:	89 10                	mov    %edx,(%eax)
  802843:	eb 08                	jmp    80284d <alloc_block_FF+0x1e8>
  802845:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802848:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80284d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802850:	a3 30 50 80 00       	mov    %eax,0x805030
  802855:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802858:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285e:	a1 38 50 80 00       	mov    0x805038,%eax
  802863:	40                   	inc    %eax
  802864:	a3 38 50 80 00       	mov    %eax,0x805038
  802869:	eb 6e                	jmp    8028d9 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80286b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286f:	74 06                	je     802877 <alloc_block_FF+0x212>
  802871:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802875:	75 17                	jne    80288e <alloc_block_FF+0x229>
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 c0 4b 80 00       	push   $0x804bc0
  80287f:	68 df 00 00 00       	push   $0xdf
  802884:	68 4d 4b 80 00       	push   $0x804b4d
  802889:	e8 67 df ff ff       	call   8007f5 <_panic>
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 10                	mov    (%eax),%edx
  802893:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802896:	89 10                	mov    %edx,(%eax)
  802898:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	74 0b                	je     8028ac <alloc_block_FF+0x247>
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	8b 00                	mov    (%eax),%eax
  8028a6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028a9:	89 50 04             	mov    %edx,0x4(%eax)
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028b2:	89 10                	mov    %edx,(%eax)
  8028b4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ba:	89 50 04             	mov    %edx,0x4(%eax)
  8028bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028c0:	8b 00                	mov    (%eax),%eax
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	75 08                	jne    8028ce <alloc_block_FF+0x269>
  8028c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8028ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8028d3:	40                   	inc    %eax
  8028d4:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8028d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028dd:	75 17                	jne    8028f6 <alloc_block_FF+0x291>
  8028df:	83 ec 04             	sub    $0x4,%esp
  8028e2:	68 2f 4b 80 00       	push   $0x804b2f
  8028e7:	68 e1 00 00 00       	push   $0xe1
  8028ec:	68 4d 4b 80 00       	push   $0x804b4d
  8028f1:	e8 ff de ff ff       	call   8007f5 <_panic>
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	74 10                	je     80290f <alloc_block_FF+0x2aa>
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 00                	mov    (%eax),%eax
  802904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802907:	8b 52 04             	mov    0x4(%edx),%edx
  80290a:	89 50 04             	mov    %edx,0x4(%eax)
  80290d:	eb 0b                	jmp    80291a <alloc_block_FF+0x2b5>
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 40 04             	mov    0x4(%eax),%eax
  802915:	a3 30 50 80 00       	mov    %eax,0x805030
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 40 04             	mov    0x4(%eax),%eax
  802920:	85 c0                	test   %eax,%eax
  802922:	74 0f                	je     802933 <alloc_block_FF+0x2ce>
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 40 04             	mov    0x4(%eax),%eax
  80292a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292d:	8b 12                	mov    (%edx),%edx
  80292f:	89 10                	mov    %edx,(%eax)
  802931:	eb 0a                	jmp    80293d <alloc_block_FF+0x2d8>
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802950:	a1 38 50 80 00       	mov    0x805038,%eax
  802955:	48                   	dec    %eax
  802956:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80295b:	83 ec 04             	sub    $0x4,%esp
  80295e:	6a 00                	push   $0x0
  802960:	ff 75 b4             	pushl  -0x4c(%ebp)
  802963:	ff 75 b0             	pushl  -0x50(%ebp)
  802966:	e8 cb fc ff ff       	call   802636 <set_block_data>
  80296b:	83 c4 10             	add    $0x10,%esp
  80296e:	e9 95 00 00 00       	jmp    802a08 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802973:	83 ec 04             	sub    $0x4,%esp
  802976:	6a 01                	push   $0x1
  802978:	ff 75 b8             	pushl  -0x48(%ebp)
  80297b:	ff 75 bc             	pushl  -0x44(%ebp)
  80297e:	e8 b3 fc ff ff       	call   802636 <set_block_data>
  802983:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298a:	75 17                	jne    8029a3 <alloc_block_FF+0x33e>
  80298c:	83 ec 04             	sub    $0x4,%esp
  80298f:	68 2f 4b 80 00       	push   $0x804b2f
  802994:	68 e8 00 00 00       	push   $0xe8
  802999:	68 4d 4b 80 00       	push   $0x804b4d
  80299e:	e8 52 de ff ff       	call   8007f5 <_panic>
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	74 10                	je     8029bc <alloc_block_FF+0x357>
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b4:	8b 52 04             	mov    0x4(%edx),%edx
  8029b7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ba:	eb 0b                	jmp    8029c7 <alloc_block_FF+0x362>
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 40 04             	mov    0x4(%eax),%eax
  8029c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	74 0f                	je     8029e0 <alloc_block_FF+0x37b>
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 40 04             	mov    0x4(%eax),%eax
  8029d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029da:	8b 12                	mov    (%edx),%edx
  8029dc:	89 10                	mov    %edx,(%eax)
  8029de:	eb 0a                	jmp    8029ea <alloc_block_FF+0x385>
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fd:	a1 38 50 80 00       	mov    0x805038,%eax
  802a02:	48                   	dec    %eax
  802a03:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802a08:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a0b:	e9 0f 01 00 00       	jmp    802b1f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a10:	a1 34 50 80 00       	mov    0x805034,%eax
  802a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1c:	74 07                	je     802a25 <alloc_block_FF+0x3c0>
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	eb 05                	jmp    802a2a <alloc_block_FF+0x3c5>
  802a25:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2a:	a3 34 50 80 00       	mov    %eax,0x805034
  802a2f:	a1 34 50 80 00       	mov    0x805034,%eax
  802a34:	85 c0                	test   %eax,%eax
  802a36:	0f 85 e9 fc ff ff    	jne    802725 <alloc_block_FF+0xc0>
  802a3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a40:	0f 85 df fc ff ff    	jne    802725 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	83 c0 08             	add    $0x8,%eax
  802a4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a4f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802a56:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a5c:	01 d0                	add    %edx,%eax
  802a5e:	48                   	dec    %eax
  802a5f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a65:	ba 00 00 00 00       	mov    $0x0,%edx
  802a6a:	f7 75 d8             	divl   -0x28(%ebp)
  802a6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a70:	29 d0                	sub    %edx,%eax
  802a72:	c1 e8 0c             	shr    $0xc,%eax
  802a75:	83 ec 0c             	sub    $0xc,%esp
  802a78:	50                   	push   %eax
  802a79:	e8 ce ed ff ff       	call   80184c <sbrk>
  802a7e:	83 c4 10             	add    $0x10,%esp
  802a81:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802a84:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802a88:	75 0a                	jne    802a94 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802a8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8f:	e9 8b 00 00 00       	jmp    802b1f <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a94:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802a9b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa1:	01 d0                	add    %edx,%eax
  802aa3:	48                   	dec    %eax
  802aa4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802aa7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  802aaf:	f7 75 cc             	divl   -0x34(%ebp)
  802ab2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ab5:	29 d0                	sub    %edx,%eax
  802ab7:	8d 50 fc             	lea    -0x4(%eax),%edx
  802aba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802abd:	01 d0                	add    %edx,%eax
  802abf:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802ac4:	a1 40 50 80 00       	mov    0x805040,%eax
  802ac9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802acf:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ad6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ad9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802adc:	01 d0                	add    %edx,%eax
  802ade:	48                   	dec    %eax
  802adf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ae2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ae5:	ba 00 00 00 00       	mov    $0x0,%edx
  802aea:	f7 75 c4             	divl   -0x3c(%ebp)
  802aed:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802af0:	29 d0                	sub    %edx,%eax
  802af2:	83 ec 04             	sub    $0x4,%esp
  802af5:	6a 01                	push   $0x1
  802af7:	50                   	push   %eax
  802af8:	ff 75 d0             	pushl  -0x30(%ebp)
  802afb:	e8 36 fb ff ff       	call   802636 <set_block_data>
  802b00:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802b03:	83 ec 0c             	sub    $0xc,%esp
  802b06:	ff 75 d0             	pushl  -0x30(%ebp)
  802b09:	e8 1b 0a 00 00       	call   803529 <free_block>
  802b0e:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802b11:	83 ec 0c             	sub    $0xc,%esp
  802b14:	ff 75 08             	pushl  0x8(%ebp)
  802b17:	e8 49 fb ff ff       	call   802665 <alloc_block_FF>
  802b1c:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802b1f:	c9                   	leave  
  802b20:	c3                   	ret    

00802b21 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802b21:	55                   	push   %ebp
  802b22:	89 e5                	mov    %esp,%ebp
  802b24:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	83 e0 01             	and    $0x1,%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	74 03                	je     802b34 <alloc_block_BF+0x13>
  802b31:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b34:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b38:	77 07                	ja     802b41 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b3a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b41:	a1 24 50 80 00       	mov    0x805024,%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	75 73                	jne    802bbd <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	83 c0 10             	add    $0x10,%eax
  802b50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802b53:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802b5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b60:	01 d0                	add    %edx,%eax
  802b62:	48                   	dec    %eax
  802b63:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802b66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b69:	ba 00 00 00 00       	mov    $0x0,%edx
  802b6e:	f7 75 e0             	divl   -0x20(%ebp)
  802b71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b74:	29 d0                	sub    %edx,%eax
  802b76:	c1 e8 0c             	shr    $0xc,%eax
  802b79:	83 ec 0c             	sub    $0xc,%esp
  802b7c:	50                   	push   %eax
  802b7d:	e8 ca ec ff ff       	call   80184c <sbrk>
  802b82:	83 c4 10             	add    $0x10,%esp
  802b85:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802b88:	83 ec 0c             	sub    $0xc,%esp
  802b8b:	6a 00                	push   $0x0
  802b8d:	e8 ba ec ff ff       	call   80184c <sbrk>
  802b92:	83 c4 10             	add    $0x10,%esp
  802b95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b9b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802b9e:	83 ec 08             	sub    $0x8,%esp
  802ba1:	50                   	push   %eax
  802ba2:	ff 75 d8             	pushl  -0x28(%ebp)
  802ba5:	e8 9f f8 ff ff       	call   802449 <initialize_dynamic_allocator>
  802baa:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802bad:	83 ec 0c             	sub    $0xc,%esp
  802bb0:	68 8b 4b 80 00       	push   $0x804b8b
  802bb5:	e8 f8 de ff ff       	call   800ab2 <cprintf>
  802bba:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802bbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802bc4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802bcb:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802bd2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802bd9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be1:	e9 1d 01 00 00       	jmp    802d03 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802bec:	83 ec 0c             	sub    $0xc,%esp
  802bef:	ff 75 a8             	pushl  -0x58(%ebp)
  802bf2:	e8 ee f6 ff ff       	call   8022e5 <get_block_size>
  802bf7:	83 c4 10             	add    $0x10,%esp
  802bfa:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	83 c0 08             	add    $0x8,%eax
  802c03:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c06:	0f 87 ef 00 00 00    	ja     802cfb <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	83 c0 18             	add    $0x18,%eax
  802c12:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c15:	77 1d                	ja     802c34 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c1d:	0f 86 d8 00 00 00    	jbe    802cfb <alloc_block_BF+0x1da>
				{
					best_va = va;
  802c23:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802c29:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802c2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c2f:	e9 c7 00 00 00       	jmp    802cfb <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	83 c0 08             	add    $0x8,%eax
  802c3a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c3d:	0f 85 9d 00 00 00    	jne    802ce0 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802c43:	83 ec 04             	sub    $0x4,%esp
  802c46:	6a 01                	push   $0x1
  802c48:	ff 75 a4             	pushl  -0x5c(%ebp)
  802c4b:	ff 75 a8             	pushl  -0x58(%ebp)
  802c4e:	e8 e3 f9 ff ff       	call   802636 <set_block_data>
  802c53:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802c56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5a:	75 17                	jne    802c73 <alloc_block_BF+0x152>
  802c5c:	83 ec 04             	sub    $0x4,%esp
  802c5f:	68 2f 4b 80 00       	push   $0x804b2f
  802c64:	68 2c 01 00 00       	push   $0x12c
  802c69:	68 4d 4b 80 00       	push   $0x804b4d
  802c6e:	e8 82 db ff ff       	call   8007f5 <_panic>
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	74 10                	je     802c8c <alloc_block_BF+0x16b>
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 00                	mov    (%eax),%eax
  802c81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c84:	8b 52 04             	mov    0x4(%edx),%edx
  802c87:	89 50 04             	mov    %edx,0x4(%eax)
  802c8a:	eb 0b                	jmp    802c97 <alloc_block_BF+0x176>
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 40 04             	mov    0x4(%eax),%eax
  802c92:	a3 30 50 80 00       	mov    %eax,0x805030
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 40 04             	mov    0x4(%eax),%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	74 0f                	je     802cb0 <alloc_block_BF+0x18f>
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 40 04             	mov    0x4(%eax),%eax
  802ca7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802caa:	8b 12                	mov    (%edx),%edx
  802cac:	89 10                	mov    %edx,(%eax)
  802cae:	eb 0a                	jmp    802cba <alloc_block_BF+0x199>
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 00                	mov    (%eax),%eax
  802cb5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccd:	a1 38 50 80 00       	mov    0x805038,%eax
  802cd2:	48                   	dec    %eax
  802cd3:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802cd8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802cdb:	e9 24 04 00 00       	jmp    803104 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ce6:	76 13                	jbe    802cfb <alloc_block_BF+0x1da>
					{
						internal = 1;
  802ce8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802cef:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802cf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802cf5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802cf8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802cfb:	a1 34 50 80 00       	mov    0x805034,%eax
  802d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d07:	74 07                	je     802d10 <alloc_block_BF+0x1ef>
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	eb 05                	jmp    802d15 <alloc_block_BF+0x1f4>
  802d10:	b8 00 00 00 00       	mov    $0x0,%eax
  802d15:	a3 34 50 80 00       	mov    %eax,0x805034
  802d1a:	a1 34 50 80 00       	mov    0x805034,%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	0f 85 bf fe ff ff    	jne    802be6 <alloc_block_BF+0xc5>
  802d27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2b:	0f 85 b5 fe ff ff    	jne    802be6 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802d31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d35:	0f 84 26 02 00 00    	je     802f61 <alloc_block_BF+0x440>
  802d3b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d3f:	0f 85 1c 02 00 00    	jne    802f61 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d48:	2b 45 08             	sub    0x8(%ebp),%eax
  802d4b:	83 e8 08             	sub    $0x8,%eax
  802d4e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	8d 50 08             	lea    0x8(%eax),%edx
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	01 d0                	add    %edx,%eax
  802d5c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	83 c0 08             	add    $0x8,%eax
  802d65:	83 ec 04             	sub    $0x4,%esp
  802d68:	6a 01                	push   $0x1
  802d6a:	50                   	push   %eax
  802d6b:	ff 75 f0             	pushl  -0x10(%ebp)
  802d6e:	e8 c3 f8 ff ff       	call   802636 <set_block_data>
  802d73:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	8b 40 04             	mov    0x4(%eax),%eax
  802d7c:	85 c0                	test   %eax,%eax
  802d7e:	75 68                	jne    802de8 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d80:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d84:	75 17                	jne    802d9d <alloc_block_BF+0x27c>
  802d86:	83 ec 04             	sub    $0x4,%esp
  802d89:	68 68 4b 80 00       	push   $0x804b68
  802d8e:	68 45 01 00 00       	push   $0x145
  802d93:	68 4d 4b 80 00       	push   $0x804b4d
  802d98:	e8 58 da ff ff       	call   8007f5 <_panic>
  802d9d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802da3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802da6:	89 10                	mov    %edx,(%eax)
  802da8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dab:	8b 00                	mov    (%eax),%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	74 0d                	je     802dbe <alloc_block_BF+0x29d>
  802db1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802db6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802db9:	89 50 04             	mov    %edx,0x4(%eax)
  802dbc:	eb 08                	jmp    802dc6 <alloc_block_BF+0x2a5>
  802dbe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dc1:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dc9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd8:	a1 38 50 80 00       	mov    0x805038,%eax
  802ddd:	40                   	inc    %eax
  802dde:	a3 38 50 80 00       	mov    %eax,0x805038
  802de3:	e9 dc 00 00 00       	jmp    802ec4 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802deb:	8b 00                	mov    (%eax),%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	75 65                	jne    802e56 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802df1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802df5:	75 17                	jne    802e0e <alloc_block_BF+0x2ed>
  802df7:	83 ec 04             	sub    $0x4,%esp
  802dfa:	68 9c 4b 80 00       	push   $0x804b9c
  802dff:	68 4a 01 00 00       	push   $0x14a
  802e04:	68 4d 4b 80 00       	push   $0x804b4d
  802e09:	e8 e7 d9 ff ff       	call   8007f5 <_panic>
  802e0e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e17:	89 50 04             	mov    %edx,0x4(%eax)
  802e1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	85 c0                	test   %eax,%eax
  802e22:	74 0c                	je     802e30 <alloc_block_BF+0x30f>
  802e24:	a1 30 50 80 00       	mov    0x805030,%eax
  802e29:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e2c:	89 10                	mov    %edx,(%eax)
  802e2e:	eb 08                	jmp    802e38 <alloc_block_BF+0x317>
  802e30:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e33:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e3b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e40:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e49:	a1 38 50 80 00       	mov    0x805038,%eax
  802e4e:	40                   	inc    %eax
  802e4f:	a3 38 50 80 00       	mov    %eax,0x805038
  802e54:	eb 6e                	jmp    802ec4 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802e56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e5a:	74 06                	je     802e62 <alloc_block_BF+0x341>
  802e5c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e60:	75 17                	jne    802e79 <alloc_block_BF+0x358>
  802e62:	83 ec 04             	sub    $0x4,%esp
  802e65:	68 c0 4b 80 00       	push   $0x804bc0
  802e6a:	68 4f 01 00 00       	push   $0x14f
  802e6f:	68 4d 4b 80 00       	push   $0x804b4d
  802e74:	e8 7c d9 ff ff       	call   8007f5 <_panic>
  802e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7c:	8b 10                	mov    (%eax),%edx
  802e7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e81:	89 10                	mov    %edx,(%eax)
  802e83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	85 c0                	test   %eax,%eax
  802e8a:	74 0b                	je     802e97 <alloc_block_BF+0x376>
  802e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8f:	8b 00                	mov    (%eax),%eax
  802e91:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e94:	89 50 04             	mov    %edx,0x4(%eax)
  802e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e9d:	89 10                	mov    %edx,(%eax)
  802e9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea5:	89 50 04             	mov    %edx,0x4(%eax)
  802ea8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eab:	8b 00                	mov    (%eax),%eax
  802ead:	85 c0                	test   %eax,%eax
  802eaf:	75 08                	jne    802eb9 <alloc_block_BF+0x398>
  802eb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eb4:	a3 30 50 80 00       	mov    %eax,0x805030
  802eb9:	a1 38 50 80 00       	mov    0x805038,%eax
  802ebe:	40                   	inc    %eax
  802ebf:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802ec4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec8:	75 17                	jne    802ee1 <alloc_block_BF+0x3c0>
  802eca:	83 ec 04             	sub    $0x4,%esp
  802ecd:	68 2f 4b 80 00       	push   $0x804b2f
  802ed2:	68 51 01 00 00       	push   $0x151
  802ed7:	68 4d 4b 80 00       	push   $0x804b4d
  802edc:	e8 14 d9 ff ff       	call   8007f5 <_panic>
  802ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee4:	8b 00                	mov    (%eax),%eax
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	74 10                	je     802efa <alloc_block_BF+0x3d9>
  802eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef2:	8b 52 04             	mov    0x4(%edx),%edx
  802ef5:	89 50 04             	mov    %edx,0x4(%eax)
  802ef8:	eb 0b                	jmp    802f05 <alloc_block_BF+0x3e4>
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	8b 40 04             	mov    0x4(%eax),%eax
  802f00:	a3 30 50 80 00       	mov    %eax,0x805030
  802f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f08:	8b 40 04             	mov    0x4(%eax),%eax
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	74 0f                	je     802f1e <alloc_block_BF+0x3fd>
  802f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f12:	8b 40 04             	mov    0x4(%eax),%eax
  802f15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f18:	8b 12                	mov    (%edx),%edx
  802f1a:	89 10                	mov    %edx,(%eax)
  802f1c:	eb 0a                	jmp    802f28 <alloc_block_BF+0x407>
  802f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f21:	8b 00                	mov    (%eax),%eax
  802f23:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f40:	48                   	dec    %eax
  802f41:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802f46:	83 ec 04             	sub    $0x4,%esp
  802f49:	6a 00                	push   $0x0
  802f4b:	ff 75 d0             	pushl  -0x30(%ebp)
  802f4e:	ff 75 cc             	pushl  -0x34(%ebp)
  802f51:	e8 e0 f6 ff ff       	call   802636 <set_block_data>
  802f56:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5c:	e9 a3 01 00 00       	jmp    803104 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802f61:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802f65:	0f 85 9d 00 00 00    	jne    803008 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802f6b:	83 ec 04             	sub    $0x4,%esp
  802f6e:	6a 01                	push   $0x1
  802f70:	ff 75 ec             	pushl  -0x14(%ebp)
  802f73:	ff 75 f0             	pushl  -0x10(%ebp)
  802f76:	e8 bb f6 ff ff       	call   802636 <set_block_data>
  802f7b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802f7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f82:	75 17                	jne    802f9b <alloc_block_BF+0x47a>
  802f84:	83 ec 04             	sub    $0x4,%esp
  802f87:	68 2f 4b 80 00       	push   $0x804b2f
  802f8c:	68 58 01 00 00       	push   $0x158
  802f91:	68 4d 4b 80 00       	push   $0x804b4d
  802f96:	e8 5a d8 ff ff       	call   8007f5 <_panic>
  802f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9e:	8b 00                	mov    (%eax),%eax
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	74 10                	je     802fb4 <alloc_block_BF+0x493>
  802fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa7:	8b 00                	mov    (%eax),%eax
  802fa9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fac:	8b 52 04             	mov    0x4(%edx),%edx
  802faf:	89 50 04             	mov    %edx,0x4(%eax)
  802fb2:	eb 0b                	jmp    802fbf <alloc_block_BF+0x49e>
  802fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb7:	8b 40 04             	mov    0x4(%eax),%eax
  802fba:	a3 30 50 80 00       	mov    %eax,0x805030
  802fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc2:	8b 40 04             	mov    0x4(%eax),%eax
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	74 0f                	je     802fd8 <alloc_block_BF+0x4b7>
  802fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcc:	8b 40 04             	mov    0x4(%eax),%eax
  802fcf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd2:	8b 12                	mov    (%edx),%edx
  802fd4:	89 10                	mov    %edx,(%eax)
  802fd6:	eb 0a                	jmp    802fe2 <alloc_block_BF+0x4c1>
  802fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdb:	8b 00                	mov    (%eax),%eax
  802fdd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802feb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff5:	a1 38 50 80 00       	mov    0x805038,%eax
  802ffa:	48                   	dec    %eax
  802ffb:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  803000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803003:	e9 fc 00 00 00       	jmp    803104 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	83 c0 08             	add    $0x8,%eax
  80300e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803011:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803018:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80301b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80301e:	01 d0                	add    %edx,%eax
  803020:	48                   	dec    %eax
  803021:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803024:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803027:	ba 00 00 00 00       	mov    $0x0,%edx
  80302c:	f7 75 c4             	divl   -0x3c(%ebp)
  80302f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803032:	29 d0                	sub    %edx,%eax
  803034:	c1 e8 0c             	shr    $0xc,%eax
  803037:	83 ec 0c             	sub    $0xc,%esp
  80303a:	50                   	push   %eax
  80303b:	e8 0c e8 ff ff       	call   80184c <sbrk>
  803040:	83 c4 10             	add    $0x10,%esp
  803043:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803046:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80304a:	75 0a                	jne    803056 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80304c:	b8 00 00 00 00       	mov    $0x0,%eax
  803051:	e9 ae 00 00 00       	jmp    803104 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803056:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80305d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803060:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803063:	01 d0                	add    %edx,%eax
  803065:	48                   	dec    %eax
  803066:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803069:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80306c:	ba 00 00 00 00       	mov    $0x0,%edx
  803071:	f7 75 b8             	divl   -0x48(%ebp)
  803074:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803077:	29 d0                	sub    %edx,%eax
  803079:	8d 50 fc             	lea    -0x4(%eax),%edx
  80307c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80307f:	01 d0                	add    %edx,%eax
  803081:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803086:	a1 40 50 80 00       	mov    0x805040,%eax
  80308b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803091:	83 ec 0c             	sub    $0xc,%esp
  803094:	68 f4 4b 80 00       	push   $0x804bf4
  803099:	e8 14 da ff ff       	call   800ab2 <cprintf>
  80309e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8030a1:	83 ec 08             	sub    $0x8,%esp
  8030a4:	ff 75 bc             	pushl  -0x44(%ebp)
  8030a7:	68 f9 4b 80 00       	push   $0x804bf9
  8030ac:	e8 01 da ff ff       	call   800ab2 <cprintf>
  8030b1:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8030b4:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8030bb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030c1:	01 d0                	add    %edx,%eax
  8030c3:	48                   	dec    %eax
  8030c4:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8030c7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8030ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8030cf:	f7 75 b0             	divl   -0x50(%ebp)
  8030d2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8030d5:	29 d0                	sub    %edx,%eax
  8030d7:	83 ec 04             	sub    $0x4,%esp
  8030da:	6a 01                	push   $0x1
  8030dc:	50                   	push   %eax
  8030dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8030e0:	e8 51 f5 ff ff       	call   802636 <set_block_data>
  8030e5:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8030e8:	83 ec 0c             	sub    $0xc,%esp
  8030eb:	ff 75 bc             	pushl  -0x44(%ebp)
  8030ee:	e8 36 04 00 00       	call   803529 <free_block>
  8030f3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8030f6:	83 ec 0c             	sub    $0xc,%esp
  8030f9:	ff 75 08             	pushl  0x8(%ebp)
  8030fc:	e8 20 fa ff ff       	call   802b21 <alloc_block_BF>
  803101:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803104:	c9                   	leave  
  803105:	c3                   	ret    

00803106 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803106:	55                   	push   %ebp
  803107:	89 e5                	mov    %esp,%ebp
  803109:	53                   	push   %ebx
  80310a:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80310d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803114:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80311b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80311f:	74 1e                	je     80313f <merging+0x39>
  803121:	ff 75 08             	pushl  0x8(%ebp)
  803124:	e8 bc f1 ff ff       	call   8022e5 <get_block_size>
  803129:	83 c4 04             	add    $0x4,%esp
  80312c:	89 c2                	mov    %eax,%edx
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	01 d0                	add    %edx,%eax
  803133:	3b 45 10             	cmp    0x10(%ebp),%eax
  803136:	75 07                	jne    80313f <merging+0x39>
		prev_is_free = 1;
  803138:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80313f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803143:	74 1e                	je     803163 <merging+0x5d>
  803145:	ff 75 10             	pushl  0x10(%ebp)
  803148:	e8 98 f1 ff ff       	call   8022e5 <get_block_size>
  80314d:	83 c4 04             	add    $0x4,%esp
  803150:	89 c2                	mov    %eax,%edx
  803152:	8b 45 10             	mov    0x10(%ebp),%eax
  803155:	01 d0                	add    %edx,%eax
  803157:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80315a:	75 07                	jne    803163 <merging+0x5d>
		next_is_free = 1;
  80315c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803163:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803167:	0f 84 cc 00 00 00    	je     803239 <merging+0x133>
  80316d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803171:	0f 84 c2 00 00 00    	je     803239 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803177:	ff 75 08             	pushl  0x8(%ebp)
  80317a:	e8 66 f1 ff ff       	call   8022e5 <get_block_size>
  80317f:	83 c4 04             	add    $0x4,%esp
  803182:	89 c3                	mov    %eax,%ebx
  803184:	ff 75 10             	pushl  0x10(%ebp)
  803187:	e8 59 f1 ff ff       	call   8022e5 <get_block_size>
  80318c:	83 c4 04             	add    $0x4,%esp
  80318f:	01 c3                	add    %eax,%ebx
  803191:	ff 75 0c             	pushl  0xc(%ebp)
  803194:	e8 4c f1 ff ff       	call   8022e5 <get_block_size>
  803199:	83 c4 04             	add    $0x4,%esp
  80319c:	01 d8                	add    %ebx,%eax
  80319e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8031a1:	6a 00                	push   $0x0
  8031a3:	ff 75 ec             	pushl  -0x14(%ebp)
  8031a6:	ff 75 08             	pushl  0x8(%ebp)
  8031a9:	e8 88 f4 ff ff       	call   802636 <set_block_data>
  8031ae:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8031b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031b5:	75 17                	jne    8031ce <merging+0xc8>
  8031b7:	83 ec 04             	sub    $0x4,%esp
  8031ba:	68 2f 4b 80 00       	push   $0x804b2f
  8031bf:	68 7d 01 00 00       	push   $0x17d
  8031c4:	68 4d 4b 80 00       	push   $0x804b4d
  8031c9:	e8 27 d6 ff ff       	call   8007f5 <_panic>
  8031ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 10                	je     8031e7 <merging+0xe1>
  8031d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
  8031dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031df:	8b 52 04             	mov    0x4(%edx),%edx
  8031e2:	89 50 04             	mov    %edx,0x4(%eax)
  8031e5:	eb 0b                	jmp    8031f2 <merging+0xec>
  8031e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ea:	8b 40 04             	mov    0x4(%eax),%eax
  8031ed:	a3 30 50 80 00       	mov    %eax,0x805030
  8031f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f5:	8b 40 04             	mov    0x4(%eax),%eax
  8031f8:	85 c0                	test   %eax,%eax
  8031fa:	74 0f                	je     80320b <merging+0x105>
  8031fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ff:	8b 40 04             	mov    0x4(%eax),%eax
  803202:	8b 55 0c             	mov    0xc(%ebp),%edx
  803205:	8b 12                	mov    (%edx),%edx
  803207:	89 10                	mov    %edx,(%eax)
  803209:	eb 0a                	jmp    803215 <merging+0x10f>
  80320b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803215:	8b 45 0c             	mov    0xc(%ebp),%eax
  803218:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803221:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803228:	a1 38 50 80 00       	mov    0x805038,%eax
  80322d:	48                   	dec    %eax
  80322e:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803233:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803234:	e9 ea 02 00 00       	jmp    803523 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803239:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323d:	74 3b                	je     80327a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80323f:	83 ec 0c             	sub    $0xc,%esp
  803242:	ff 75 08             	pushl  0x8(%ebp)
  803245:	e8 9b f0 ff ff       	call   8022e5 <get_block_size>
  80324a:	83 c4 10             	add    $0x10,%esp
  80324d:	89 c3                	mov    %eax,%ebx
  80324f:	83 ec 0c             	sub    $0xc,%esp
  803252:	ff 75 10             	pushl  0x10(%ebp)
  803255:	e8 8b f0 ff ff       	call   8022e5 <get_block_size>
  80325a:	83 c4 10             	add    $0x10,%esp
  80325d:	01 d8                	add    %ebx,%eax
  80325f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803262:	83 ec 04             	sub    $0x4,%esp
  803265:	6a 00                	push   $0x0
  803267:	ff 75 e8             	pushl  -0x18(%ebp)
  80326a:	ff 75 08             	pushl  0x8(%ebp)
  80326d:	e8 c4 f3 ff ff       	call   802636 <set_block_data>
  803272:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803275:	e9 a9 02 00 00       	jmp    803523 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80327a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80327e:	0f 84 2d 01 00 00    	je     8033b1 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803284:	83 ec 0c             	sub    $0xc,%esp
  803287:	ff 75 10             	pushl  0x10(%ebp)
  80328a:	e8 56 f0 ff ff       	call   8022e5 <get_block_size>
  80328f:	83 c4 10             	add    $0x10,%esp
  803292:	89 c3                	mov    %eax,%ebx
  803294:	83 ec 0c             	sub    $0xc,%esp
  803297:	ff 75 0c             	pushl  0xc(%ebp)
  80329a:	e8 46 f0 ff ff       	call   8022e5 <get_block_size>
  80329f:	83 c4 10             	add    $0x10,%esp
  8032a2:	01 d8                	add    %ebx,%eax
  8032a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8032a7:	83 ec 04             	sub    $0x4,%esp
  8032aa:	6a 00                	push   $0x0
  8032ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032af:	ff 75 10             	pushl  0x10(%ebp)
  8032b2:	e8 7f f3 ff ff       	call   802636 <set_block_data>
  8032b7:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8032ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8032bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8032c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032c4:	74 06                	je     8032cc <merging+0x1c6>
  8032c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8032ca:	75 17                	jne    8032e3 <merging+0x1dd>
  8032cc:	83 ec 04             	sub    $0x4,%esp
  8032cf:	68 08 4c 80 00       	push   $0x804c08
  8032d4:	68 8d 01 00 00       	push   $0x18d
  8032d9:	68 4d 4b 80 00       	push   $0x804b4d
  8032de:	e8 12 d5 ff ff       	call   8007f5 <_panic>
  8032e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e6:	8b 50 04             	mov    0x4(%eax),%edx
  8032e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ec:	89 50 04             	mov    %edx,0x4(%eax)
  8032ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032f5:	89 10                	mov    %edx,(%eax)
  8032f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032fa:	8b 40 04             	mov    0x4(%eax),%eax
  8032fd:	85 c0                	test   %eax,%eax
  8032ff:	74 0d                	je     80330e <merging+0x208>
  803301:	8b 45 0c             	mov    0xc(%ebp),%eax
  803304:	8b 40 04             	mov    0x4(%eax),%eax
  803307:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80330a:	89 10                	mov    %edx,(%eax)
  80330c:	eb 08                	jmp    803316 <merging+0x210>
  80330e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803311:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803316:	8b 45 0c             	mov    0xc(%ebp),%eax
  803319:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80331c:	89 50 04             	mov    %edx,0x4(%eax)
  80331f:	a1 38 50 80 00       	mov    0x805038,%eax
  803324:	40                   	inc    %eax
  803325:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80332a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80332e:	75 17                	jne    803347 <merging+0x241>
  803330:	83 ec 04             	sub    $0x4,%esp
  803333:	68 2f 4b 80 00       	push   $0x804b2f
  803338:	68 8e 01 00 00       	push   $0x18e
  80333d:	68 4d 4b 80 00       	push   $0x804b4d
  803342:	e8 ae d4 ff ff       	call   8007f5 <_panic>
  803347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334a:	8b 00                	mov    (%eax),%eax
  80334c:	85 c0                	test   %eax,%eax
  80334e:	74 10                	je     803360 <merging+0x25a>
  803350:	8b 45 0c             	mov    0xc(%ebp),%eax
  803353:	8b 00                	mov    (%eax),%eax
  803355:	8b 55 0c             	mov    0xc(%ebp),%edx
  803358:	8b 52 04             	mov    0x4(%edx),%edx
  80335b:	89 50 04             	mov    %edx,0x4(%eax)
  80335e:	eb 0b                	jmp    80336b <merging+0x265>
  803360:	8b 45 0c             	mov    0xc(%ebp),%eax
  803363:	8b 40 04             	mov    0x4(%eax),%eax
  803366:	a3 30 50 80 00       	mov    %eax,0x805030
  80336b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336e:	8b 40 04             	mov    0x4(%eax),%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	74 0f                	je     803384 <merging+0x27e>
  803375:	8b 45 0c             	mov    0xc(%ebp),%eax
  803378:	8b 40 04             	mov    0x4(%eax),%eax
  80337b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80337e:	8b 12                	mov    (%edx),%edx
  803380:	89 10                	mov    %edx,(%eax)
  803382:	eb 0a                	jmp    80338e <merging+0x288>
  803384:	8b 45 0c             	mov    0xc(%ebp),%eax
  803387:	8b 00                	mov    (%eax),%eax
  803389:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80338e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803391:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80339a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8033a6:	48                   	dec    %eax
  8033a7:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8033ac:	e9 72 01 00 00       	jmp    803523 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8033b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8033b4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8033b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033bb:	74 79                	je     803436 <merging+0x330>
  8033bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033c1:	74 73                	je     803436 <merging+0x330>
  8033c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c7:	74 06                	je     8033cf <merging+0x2c9>
  8033c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033cd:	75 17                	jne    8033e6 <merging+0x2e0>
  8033cf:	83 ec 04             	sub    $0x4,%esp
  8033d2:	68 c0 4b 80 00       	push   $0x804bc0
  8033d7:	68 94 01 00 00       	push   $0x194
  8033dc:	68 4d 4b 80 00       	push   $0x804b4d
  8033e1:	e8 0f d4 ff ff       	call   8007f5 <_panic>
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	8b 10                	mov    (%eax),%edx
  8033eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ee:	89 10                	mov    %edx,(%eax)
  8033f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	85 c0                	test   %eax,%eax
  8033f7:	74 0b                	je     803404 <merging+0x2fe>
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803401:	89 50 04             	mov    %edx,0x4(%eax)
  803404:	8b 45 08             	mov    0x8(%ebp),%eax
  803407:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80340a:	89 10                	mov    %edx,(%eax)
  80340c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80340f:	8b 55 08             	mov    0x8(%ebp),%edx
  803412:	89 50 04             	mov    %edx,0x4(%eax)
  803415:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	85 c0                	test   %eax,%eax
  80341c:	75 08                	jne    803426 <merging+0x320>
  80341e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803421:	a3 30 50 80 00       	mov    %eax,0x805030
  803426:	a1 38 50 80 00       	mov    0x805038,%eax
  80342b:	40                   	inc    %eax
  80342c:	a3 38 50 80 00       	mov    %eax,0x805038
  803431:	e9 ce 00 00 00       	jmp    803504 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803436:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80343a:	74 65                	je     8034a1 <merging+0x39b>
  80343c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803440:	75 17                	jne    803459 <merging+0x353>
  803442:	83 ec 04             	sub    $0x4,%esp
  803445:	68 9c 4b 80 00       	push   $0x804b9c
  80344a:	68 95 01 00 00       	push   $0x195
  80344f:	68 4d 4b 80 00       	push   $0x804b4d
  803454:	e8 9c d3 ff ff       	call   8007f5 <_panic>
  803459:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80345f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803462:	89 50 04             	mov    %edx,0x4(%eax)
  803465:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803468:	8b 40 04             	mov    0x4(%eax),%eax
  80346b:	85 c0                	test   %eax,%eax
  80346d:	74 0c                	je     80347b <merging+0x375>
  80346f:	a1 30 50 80 00       	mov    0x805030,%eax
  803474:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803477:	89 10                	mov    %edx,(%eax)
  803479:	eb 08                	jmp    803483 <merging+0x37d>
  80347b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80347e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803483:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803486:	a3 30 50 80 00       	mov    %eax,0x805030
  80348b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80348e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803494:	a1 38 50 80 00       	mov    0x805038,%eax
  803499:	40                   	inc    %eax
  80349a:	a3 38 50 80 00       	mov    %eax,0x805038
  80349f:	eb 63                	jmp    803504 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8034a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034a5:	75 17                	jne    8034be <merging+0x3b8>
  8034a7:	83 ec 04             	sub    $0x4,%esp
  8034aa:	68 68 4b 80 00       	push   $0x804b68
  8034af:	68 98 01 00 00       	push   $0x198
  8034b4:	68 4d 4b 80 00       	push   $0x804b4d
  8034b9:	e8 37 d3 ff ff       	call   8007f5 <_panic>
  8034be:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c7:	89 10                	mov    %edx,(%eax)
  8034c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034cc:	8b 00                	mov    (%eax),%eax
  8034ce:	85 c0                	test   %eax,%eax
  8034d0:	74 0d                	je     8034df <merging+0x3d9>
  8034d2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034da:	89 50 04             	mov    %edx,0x4(%eax)
  8034dd:	eb 08                	jmp    8034e7 <merging+0x3e1>
  8034df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034e2:	a3 30 50 80 00       	mov    %eax,0x805030
  8034e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8034fe:	40                   	inc    %eax
  8034ff:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803504:	83 ec 0c             	sub    $0xc,%esp
  803507:	ff 75 10             	pushl  0x10(%ebp)
  80350a:	e8 d6 ed ff ff       	call   8022e5 <get_block_size>
  80350f:	83 c4 10             	add    $0x10,%esp
  803512:	83 ec 04             	sub    $0x4,%esp
  803515:	6a 00                	push   $0x0
  803517:	50                   	push   %eax
  803518:	ff 75 10             	pushl  0x10(%ebp)
  80351b:	e8 16 f1 ff ff       	call   802636 <set_block_data>
  803520:	83 c4 10             	add    $0x10,%esp
	}
}
  803523:	90                   	nop
  803524:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803527:	c9                   	leave  
  803528:	c3                   	ret    

00803529 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803529:	55                   	push   %ebp
  80352a:	89 e5                	mov    %esp,%ebp
  80352c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80352f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803534:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803537:	a1 30 50 80 00       	mov    0x805030,%eax
  80353c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80353f:	73 1b                	jae    80355c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803541:	a1 30 50 80 00       	mov    0x805030,%eax
  803546:	83 ec 04             	sub    $0x4,%esp
  803549:	ff 75 08             	pushl  0x8(%ebp)
  80354c:	6a 00                	push   $0x0
  80354e:	50                   	push   %eax
  80354f:	e8 b2 fb ff ff       	call   803106 <merging>
  803554:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803557:	e9 8b 00 00 00       	jmp    8035e7 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80355c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803561:	3b 45 08             	cmp    0x8(%ebp),%eax
  803564:	76 18                	jbe    80357e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803566:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80356b:	83 ec 04             	sub    $0x4,%esp
  80356e:	ff 75 08             	pushl  0x8(%ebp)
  803571:	50                   	push   %eax
  803572:	6a 00                	push   $0x0
  803574:	e8 8d fb ff ff       	call   803106 <merging>
  803579:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80357c:	eb 69                	jmp    8035e7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80357e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803583:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803586:	eb 39                	jmp    8035c1 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80358e:	73 29                	jae    8035b9 <free_block+0x90>
  803590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	3b 45 08             	cmp    0x8(%ebp),%eax
  803598:	76 1f                	jbe    8035b9 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359d:	8b 00                	mov    (%eax),%eax
  80359f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8035a2:	83 ec 04             	sub    $0x4,%esp
  8035a5:	ff 75 08             	pushl  0x8(%ebp)
  8035a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8035ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8035ae:	e8 53 fb ff ff       	call   803106 <merging>
  8035b3:	83 c4 10             	add    $0x10,%esp
			break;
  8035b6:	90                   	nop
		}
	}
}
  8035b7:	eb 2e                	jmp    8035e7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8035b9:	a1 34 50 80 00       	mov    0x805034,%eax
  8035be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c5:	74 07                	je     8035ce <free_block+0xa5>
  8035c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ca:	8b 00                	mov    (%eax),%eax
  8035cc:	eb 05                	jmp    8035d3 <free_block+0xaa>
  8035ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d3:	a3 34 50 80 00       	mov    %eax,0x805034
  8035d8:	a1 34 50 80 00       	mov    0x805034,%eax
  8035dd:	85 c0                	test   %eax,%eax
  8035df:	75 a7                	jne    803588 <free_block+0x5f>
  8035e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e5:	75 a1                	jne    803588 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8035e7:	90                   	nop
  8035e8:	c9                   	leave  
  8035e9:	c3                   	ret    

008035ea <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8035ea:	55                   	push   %ebp
  8035eb:	89 e5                	mov    %esp,%ebp
  8035ed:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8035f0:	ff 75 08             	pushl  0x8(%ebp)
  8035f3:	e8 ed ec ff ff       	call   8022e5 <get_block_size>
  8035f8:	83 c4 04             	add    $0x4,%esp
  8035fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8035fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803605:	eb 17                	jmp    80361e <copy_data+0x34>
  803607:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80360a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360d:	01 c2                	add    %eax,%edx
  80360f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803612:	8b 45 08             	mov    0x8(%ebp),%eax
  803615:	01 c8                	add    %ecx,%eax
  803617:	8a 00                	mov    (%eax),%al
  803619:	88 02                	mov    %al,(%edx)
  80361b:	ff 45 fc             	incl   -0x4(%ebp)
  80361e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803621:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803624:	72 e1                	jb     803607 <copy_data+0x1d>
}
  803626:	90                   	nop
  803627:	c9                   	leave  
  803628:	c3                   	ret    

00803629 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803629:	55                   	push   %ebp
  80362a:	89 e5                	mov    %esp,%ebp
  80362c:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80362f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803633:	75 23                	jne    803658 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803635:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803639:	74 13                	je     80364e <realloc_block_FF+0x25>
  80363b:	83 ec 0c             	sub    $0xc,%esp
  80363e:	ff 75 0c             	pushl  0xc(%ebp)
  803641:	e8 1f f0 ff ff       	call   802665 <alloc_block_FF>
  803646:	83 c4 10             	add    $0x10,%esp
  803649:	e9 f4 06 00 00       	jmp    803d42 <realloc_block_FF+0x719>
		return NULL;
  80364e:	b8 00 00 00 00       	mov    $0x0,%eax
  803653:	e9 ea 06 00 00       	jmp    803d42 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803658:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80365c:	75 18                	jne    803676 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80365e:	83 ec 0c             	sub    $0xc,%esp
  803661:	ff 75 08             	pushl  0x8(%ebp)
  803664:	e8 c0 fe ff ff       	call   803529 <free_block>
  803669:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80366c:	b8 00 00 00 00       	mov    $0x0,%eax
  803671:	e9 cc 06 00 00       	jmp    803d42 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803676:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80367a:	77 07                	ja     803683 <realloc_block_FF+0x5a>
  80367c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803683:	8b 45 0c             	mov    0xc(%ebp),%eax
  803686:	83 e0 01             	and    $0x1,%eax
  803689:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80368c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368f:	83 c0 08             	add    $0x8,%eax
  803692:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803695:	83 ec 0c             	sub    $0xc,%esp
  803698:	ff 75 08             	pushl  0x8(%ebp)
  80369b:	e8 45 ec ff ff       	call   8022e5 <get_block_size>
  8036a0:	83 c4 10             	add    $0x10,%esp
  8036a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8036a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a9:	83 e8 08             	sub    $0x8,%eax
  8036ac:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	83 e8 04             	sub    $0x4,%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	83 e0 fe             	and    $0xfffffffe,%eax
  8036ba:	89 c2                	mov    %eax,%edx
  8036bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bf:	01 d0                	add    %edx,%eax
  8036c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8036c4:	83 ec 0c             	sub    $0xc,%esp
  8036c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036ca:	e8 16 ec ff ff       	call   8022e5 <get_block_size>
  8036cf:	83 c4 10             	add    $0x10,%esp
  8036d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8036d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d8:	83 e8 08             	sub    $0x8,%eax
  8036db:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8036de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036e4:	75 08                	jne    8036ee <realloc_block_FF+0xc5>
	{
		 return va;
  8036e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e9:	e9 54 06 00 00       	jmp    803d42 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8036ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036f4:	0f 83 e5 03 00 00    	jae    803adf <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8036fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fd:	2b 45 0c             	sub    0xc(%ebp),%eax
  803700:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803703:	83 ec 0c             	sub    $0xc,%esp
  803706:	ff 75 e4             	pushl  -0x1c(%ebp)
  803709:	e8 f0 eb ff ff       	call   8022fe <is_free_block>
  80370e:	83 c4 10             	add    $0x10,%esp
  803711:	84 c0                	test   %al,%al
  803713:	0f 84 3b 01 00 00    	je     803854 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803719:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80371c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80371f:	01 d0                	add    %edx,%eax
  803721:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803724:	83 ec 04             	sub    $0x4,%esp
  803727:	6a 01                	push   $0x1
  803729:	ff 75 f0             	pushl  -0x10(%ebp)
  80372c:	ff 75 08             	pushl  0x8(%ebp)
  80372f:	e8 02 ef ff ff       	call   802636 <set_block_data>
  803734:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803737:	8b 45 08             	mov    0x8(%ebp),%eax
  80373a:	83 e8 04             	sub    $0x4,%eax
  80373d:	8b 00                	mov    (%eax),%eax
  80373f:	83 e0 fe             	and    $0xfffffffe,%eax
  803742:	89 c2                	mov    %eax,%edx
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	01 d0                	add    %edx,%eax
  803749:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80374c:	83 ec 04             	sub    $0x4,%esp
  80374f:	6a 00                	push   $0x0
  803751:	ff 75 cc             	pushl  -0x34(%ebp)
  803754:	ff 75 c8             	pushl  -0x38(%ebp)
  803757:	e8 da ee ff ff       	call   802636 <set_block_data>
  80375c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80375f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803763:	74 06                	je     80376b <realloc_block_FF+0x142>
  803765:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803769:	75 17                	jne    803782 <realloc_block_FF+0x159>
  80376b:	83 ec 04             	sub    $0x4,%esp
  80376e:	68 c0 4b 80 00       	push   $0x804bc0
  803773:	68 f6 01 00 00       	push   $0x1f6
  803778:	68 4d 4b 80 00       	push   $0x804b4d
  80377d:	e8 73 d0 ff ff       	call   8007f5 <_panic>
  803782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803785:	8b 10                	mov    (%eax),%edx
  803787:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80378a:	89 10                	mov    %edx,(%eax)
  80378c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80378f:	8b 00                	mov    (%eax),%eax
  803791:	85 c0                	test   %eax,%eax
  803793:	74 0b                	je     8037a0 <realloc_block_FF+0x177>
  803795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803798:	8b 00                	mov    (%eax),%eax
  80379a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80379d:	89 50 04             	mov    %edx,0x4(%eax)
  8037a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8037a6:	89 10                	mov    %edx,(%eax)
  8037a8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ae:	89 50 04             	mov    %edx,0x4(%eax)
  8037b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037b4:	8b 00                	mov    (%eax),%eax
  8037b6:	85 c0                	test   %eax,%eax
  8037b8:	75 08                	jne    8037c2 <realloc_block_FF+0x199>
  8037ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8037c2:	a1 38 50 80 00       	mov    0x805038,%eax
  8037c7:	40                   	inc    %eax
  8037c8:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037d1:	75 17                	jne    8037ea <realloc_block_FF+0x1c1>
  8037d3:	83 ec 04             	sub    $0x4,%esp
  8037d6:	68 2f 4b 80 00       	push   $0x804b2f
  8037db:	68 f7 01 00 00       	push   $0x1f7
  8037e0:	68 4d 4b 80 00       	push   $0x804b4d
  8037e5:	e8 0b d0 ff ff       	call   8007f5 <_panic>
  8037ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ed:	8b 00                	mov    (%eax),%eax
  8037ef:	85 c0                	test   %eax,%eax
  8037f1:	74 10                	je     803803 <realloc_block_FF+0x1da>
  8037f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f6:	8b 00                	mov    (%eax),%eax
  8037f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037fb:	8b 52 04             	mov    0x4(%edx),%edx
  8037fe:	89 50 04             	mov    %edx,0x4(%eax)
  803801:	eb 0b                	jmp    80380e <realloc_block_FF+0x1e5>
  803803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803806:	8b 40 04             	mov    0x4(%eax),%eax
  803809:	a3 30 50 80 00       	mov    %eax,0x805030
  80380e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803811:	8b 40 04             	mov    0x4(%eax),%eax
  803814:	85 c0                	test   %eax,%eax
  803816:	74 0f                	je     803827 <realloc_block_FF+0x1fe>
  803818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381b:	8b 40 04             	mov    0x4(%eax),%eax
  80381e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803821:	8b 12                	mov    (%edx),%edx
  803823:	89 10                	mov    %edx,(%eax)
  803825:	eb 0a                	jmp    803831 <realloc_block_FF+0x208>
  803827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382a:	8b 00                	mov    (%eax),%eax
  80382c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803834:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80383a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803844:	a1 38 50 80 00       	mov    0x805038,%eax
  803849:	48                   	dec    %eax
  80384a:	a3 38 50 80 00       	mov    %eax,0x805038
  80384f:	e9 83 02 00 00       	jmp    803ad7 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803854:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803858:	0f 86 69 02 00 00    	jbe    803ac7 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80385e:	83 ec 04             	sub    $0x4,%esp
  803861:	6a 01                	push   $0x1
  803863:	ff 75 f0             	pushl  -0x10(%ebp)
  803866:	ff 75 08             	pushl  0x8(%ebp)
  803869:	e8 c8 ed ff ff       	call   802636 <set_block_data>
  80386e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803871:	8b 45 08             	mov    0x8(%ebp),%eax
  803874:	83 e8 04             	sub    $0x4,%eax
  803877:	8b 00                	mov    (%eax),%eax
  803879:	83 e0 fe             	and    $0xfffffffe,%eax
  80387c:	89 c2                	mov    %eax,%edx
  80387e:	8b 45 08             	mov    0x8(%ebp),%eax
  803881:	01 d0                	add    %edx,%eax
  803883:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803886:	a1 38 50 80 00       	mov    0x805038,%eax
  80388b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80388e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803892:	75 68                	jne    8038fc <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803894:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803898:	75 17                	jne    8038b1 <realloc_block_FF+0x288>
  80389a:	83 ec 04             	sub    $0x4,%esp
  80389d:	68 68 4b 80 00       	push   $0x804b68
  8038a2:	68 06 02 00 00       	push   $0x206
  8038a7:	68 4d 4b 80 00       	push   $0x804b4d
  8038ac:	e8 44 cf ff ff       	call   8007f5 <_panic>
  8038b1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8038b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038ba:	89 10                	mov    %edx,(%eax)
  8038bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038bf:	8b 00                	mov    (%eax),%eax
  8038c1:	85 c0                	test   %eax,%eax
  8038c3:	74 0d                	je     8038d2 <realloc_block_FF+0x2a9>
  8038c5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038cd:	89 50 04             	mov    %edx,0x4(%eax)
  8038d0:	eb 08                	jmp    8038da <realloc_block_FF+0x2b1>
  8038d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8038da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038dd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8038f1:	40                   	inc    %eax
  8038f2:	a3 38 50 80 00       	mov    %eax,0x805038
  8038f7:	e9 b0 01 00 00       	jmp    803aac <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8038fc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803901:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803904:	76 68                	jbe    80396e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803906:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80390a:	75 17                	jne    803923 <realloc_block_FF+0x2fa>
  80390c:	83 ec 04             	sub    $0x4,%esp
  80390f:	68 68 4b 80 00       	push   $0x804b68
  803914:	68 0b 02 00 00       	push   $0x20b
  803919:	68 4d 4b 80 00       	push   $0x804b4d
  80391e:	e8 d2 ce ff ff       	call   8007f5 <_panic>
  803923:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803929:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80392c:	89 10                	mov    %edx,(%eax)
  80392e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803931:	8b 00                	mov    (%eax),%eax
  803933:	85 c0                	test   %eax,%eax
  803935:	74 0d                	je     803944 <realloc_block_FF+0x31b>
  803937:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80393c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80393f:	89 50 04             	mov    %edx,0x4(%eax)
  803942:	eb 08                	jmp    80394c <realloc_block_FF+0x323>
  803944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803947:	a3 30 50 80 00       	mov    %eax,0x805030
  80394c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80394f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803954:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803957:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80395e:	a1 38 50 80 00       	mov    0x805038,%eax
  803963:	40                   	inc    %eax
  803964:	a3 38 50 80 00       	mov    %eax,0x805038
  803969:	e9 3e 01 00 00       	jmp    803aac <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80396e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803973:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803976:	73 68                	jae    8039e0 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803978:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80397c:	75 17                	jne    803995 <realloc_block_FF+0x36c>
  80397e:	83 ec 04             	sub    $0x4,%esp
  803981:	68 9c 4b 80 00       	push   $0x804b9c
  803986:	68 10 02 00 00       	push   $0x210
  80398b:	68 4d 4b 80 00       	push   $0x804b4d
  803990:	e8 60 ce ff ff       	call   8007f5 <_panic>
  803995:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80399b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80399e:	89 50 04             	mov    %edx,0x4(%eax)
  8039a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a4:	8b 40 04             	mov    0x4(%eax),%eax
  8039a7:	85 c0                	test   %eax,%eax
  8039a9:	74 0c                	je     8039b7 <realloc_block_FF+0x38e>
  8039ab:	a1 30 50 80 00       	mov    0x805030,%eax
  8039b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039b3:	89 10                	mov    %edx,(%eax)
  8039b5:	eb 08                	jmp    8039bf <realloc_block_FF+0x396>
  8039b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8039c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8039d5:	40                   	inc    %eax
  8039d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8039db:	e9 cc 00 00 00       	jmp    803aac <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8039e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8039e7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039ef:	e9 8a 00 00 00       	jmp    803a7e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8039f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039fa:	73 7a                	jae    803a76 <realloc_block_FF+0x44d>
  8039fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ff:	8b 00                	mov    (%eax),%eax
  803a01:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a04:	73 70                	jae    803a76 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803a06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a0a:	74 06                	je     803a12 <realloc_block_FF+0x3e9>
  803a0c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a10:	75 17                	jne    803a29 <realloc_block_FF+0x400>
  803a12:	83 ec 04             	sub    $0x4,%esp
  803a15:	68 c0 4b 80 00       	push   $0x804bc0
  803a1a:	68 1a 02 00 00       	push   $0x21a
  803a1f:	68 4d 4b 80 00       	push   $0x804b4d
  803a24:	e8 cc cd ff ff       	call   8007f5 <_panic>
  803a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2c:	8b 10                	mov    (%eax),%edx
  803a2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a31:	89 10                	mov    %edx,(%eax)
  803a33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a36:	8b 00                	mov    (%eax),%eax
  803a38:	85 c0                	test   %eax,%eax
  803a3a:	74 0b                	je     803a47 <realloc_block_FF+0x41e>
  803a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3f:	8b 00                	mov    (%eax),%eax
  803a41:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a44:	89 50 04             	mov    %edx,0x4(%eax)
  803a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a4d:	89 10                	mov    %edx,(%eax)
  803a4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a55:	89 50 04             	mov    %edx,0x4(%eax)
  803a58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a5b:	8b 00                	mov    (%eax),%eax
  803a5d:	85 c0                	test   %eax,%eax
  803a5f:	75 08                	jne    803a69 <realloc_block_FF+0x440>
  803a61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a64:	a3 30 50 80 00       	mov    %eax,0x805030
  803a69:	a1 38 50 80 00       	mov    0x805038,%eax
  803a6e:	40                   	inc    %eax
  803a6f:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803a74:	eb 36                	jmp    803aac <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803a76:	a1 34 50 80 00       	mov    0x805034,%eax
  803a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a82:	74 07                	je     803a8b <realloc_block_FF+0x462>
  803a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a87:	8b 00                	mov    (%eax),%eax
  803a89:	eb 05                	jmp    803a90 <realloc_block_FF+0x467>
  803a8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a90:	a3 34 50 80 00       	mov    %eax,0x805034
  803a95:	a1 34 50 80 00       	mov    0x805034,%eax
  803a9a:	85 c0                	test   %eax,%eax
  803a9c:	0f 85 52 ff ff ff    	jne    8039f4 <realloc_block_FF+0x3cb>
  803aa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aa6:	0f 85 48 ff ff ff    	jne    8039f4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803aac:	83 ec 04             	sub    $0x4,%esp
  803aaf:	6a 00                	push   $0x0
  803ab1:	ff 75 d8             	pushl  -0x28(%ebp)
  803ab4:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ab7:	e8 7a eb ff ff       	call   802636 <set_block_data>
  803abc:	83 c4 10             	add    $0x10,%esp
				return va;
  803abf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac2:	e9 7b 02 00 00       	jmp    803d42 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803ac7:	83 ec 0c             	sub    $0xc,%esp
  803aca:	68 3d 4c 80 00       	push   $0x804c3d
  803acf:	e8 de cf ff ff       	call   800ab2 <cprintf>
  803ad4:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  803ada:	e9 63 02 00 00       	jmp    803d42 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ae2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ae5:	0f 86 4d 02 00 00    	jbe    803d38 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803aeb:	83 ec 0c             	sub    $0xc,%esp
  803aee:	ff 75 e4             	pushl  -0x1c(%ebp)
  803af1:	e8 08 e8 ff ff       	call   8022fe <is_free_block>
  803af6:	83 c4 10             	add    $0x10,%esp
  803af9:	84 c0                	test   %al,%al
  803afb:	0f 84 37 02 00 00    	je     803d38 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b04:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803b07:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803b0a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b0d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803b10:	76 38                	jbe    803b4a <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803b12:	83 ec 0c             	sub    $0xc,%esp
  803b15:	ff 75 08             	pushl  0x8(%ebp)
  803b18:	e8 0c fa ff ff       	call   803529 <free_block>
  803b1d:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803b20:	83 ec 0c             	sub    $0xc,%esp
  803b23:	ff 75 0c             	pushl  0xc(%ebp)
  803b26:	e8 3a eb ff ff       	call   802665 <alloc_block_FF>
  803b2b:	83 c4 10             	add    $0x10,%esp
  803b2e:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803b31:	83 ec 08             	sub    $0x8,%esp
  803b34:	ff 75 c0             	pushl  -0x40(%ebp)
  803b37:	ff 75 08             	pushl  0x8(%ebp)
  803b3a:	e8 ab fa ff ff       	call   8035ea <copy_data>
  803b3f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803b42:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b45:	e9 f8 01 00 00       	jmp    803d42 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803b4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b4d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803b50:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803b53:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803b57:	0f 87 a0 00 00 00    	ja     803bfd <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b61:	75 17                	jne    803b7a <realloc_block_FF+0x551>
  803b63:	83 ec 04             	sub    $0x4,%esp
  803b66:	68 2f 4b 80 00       	push   $0x804b2f
  803b6b:	68 38 02 00 00       	push   $0x238
  803b70:	68 4d 4b 80 00       	push   $0x804b4d
  803b75:	e8 7b cc ff ff       	call   8007f5 <_panic>
  803b7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7d:	8b 00                	mov    (%eax),%eax
  803b7f:	85 c0                	test   %eax,%eax
  803b81:	74 10                	je     803b93 <realloc_block_FF+0x56a>
  803b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b86:	8b 00                	mov    (%eax),%eax
  803b88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b8b:	8b 52 04             	mov    0x4(%edx),%edx
  803b8e:	89 50 04             	mov    %edx,0x4(%eax)
  803b91:	eb 0b                	jmp    803b9e <realloc_block_FF+0x575>
  803b93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b96:	8b 40 04             	mov    0x4(%eax),%eax
  803b99:	a3 30 50 80 00       	mov    %eax,0x805030
  803b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba1:	8b 40 04             	mov    0x4(%eax),%eax
  803ba4:	85 c0                	test   %eax,%eax
  803ba6:	74 0f                	je     803bb7 <realloc_block_FF+0x58e>
  803ba8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bab:	8b 40 04             	mov    0x4(%eax),%eax
  803bae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bb1:	8b 12                	mov    (%edx),%edx
  803bb3:	89 10                	mov    %edx,(%eax)
  803bb5:	eb 0a                	jmp    803bc1 <realloc_block_FF+0x598>
  803bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bba:	8b 00                	mov    (%eax),%eax
  803bbc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bd4:	a1 38 50 80 00       	mov    0x805038,%eax
  803bd9:	48                   	dec    %eax
  803bda:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803bdf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803be2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803be5:	01 d0                	add    %edx,%eax
  803be7:	83 ec 04             	sub    $0x4,%esp
  803bea:	6a 01                	push   $0x1
  803bec:	50                   	push   %eax
  803bed:	ff 75 08             	pushl  0x8(%ebp)
  803bf0:	e8 41 ea ff ff       	call   802636 <set_block_data>
  803bf5:	83 c4 10             	add    $0x10,%esp
  803bf8:	e9 36 01 00 00       	jmp    803d33 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803bfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c00:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c03:	01 d0                	add    %edx,%eax
  803c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803c08:	83 ec 04             	sub    $0x4,%esp
  803c0b:	6a 01                	push   $0x1
  803c0d:	ff 75 f0             	pushl  -0x10(%ebp)
  803c10:	ff 75 08             	pushl  0x8(%ebp)
  803c13:	e8 1e ea ff ff       	call   802636 <set_block_data>
  803c18:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1e:	83 e8 04             	sub    $0x4,%eax
  803c21:	8b 00                	mov    (%eax),%eax
  803c23:	83 e0 fe             	and    $0xfffffffe,%eax
  803c26:	89 c2                	mov    %eax,%edx
  803c28:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2b:	01 d0                	add    %edx,%eax
  803c2d:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c34:	74 06                	je     803c3c <realloc_block_FF+0x613>
  803c36:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803c3a:	75 17                	jne    803c53 <realloc_block_FF+0x62a>
  803c3c:	83 ec 04             	sub    $0x4,%esp
  803c3f:	68 c0 4b 80 00       	push   $0x804bc0
  803c44:	68 44 02 00 00       	push   $0x244
  803c49:	68 4d 4b 80 00       	push   $0x804b4d
  803c4e:	e8 a2 cb ff ff       	call   8007f5 <_panic>
  803c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c56:	8b 10                	mov    (%eax),%edx
  803c58:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c5b:	89 10                	mov    %edx,(%eax)
  803c5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c60:	8b 00                	mov    (%eax),%eax
  803c62:	85 c0                	test   %eax,%eax
  803c64:	74 0b                	je     803c71 <realloc_block_FF+0x648>
  803c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c69:	8b 00                	mov    (%eax),%eax
  803c6b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803c6e:	89 50 04             	mov    %edx,0x4(%eax)
  803c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c74:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803c77:	89 10                	mov    %edx,(%eax)
  803c79:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c7f:	89 50 04             	mov    %edx,0x4(%eax)
  803c82:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c85:	8b 00                	mov    (%eax),%eax
  803c87:	85 c0                	test   %eax,%eax
  803c89:	75 08                	jne    803c93 <realloc_block_FF+0x66a>
  803c8b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c8e:	a3 30 50 80 00       	mov    %eax,0x805030
  803c93:	a1 38 50 80 00       	mov    0x805038,%eax
  803c98:	40                   	inc    %eax
  803c99:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803c9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ca2:	75 17                	jne    803cbb <realloc_block_FF+0x692>
  803ca4:	83 ec 04             	sub    $0x4,%esp
  803ca7:	68 2f 4b 80 00       	push   $0x804b2f
  803cac:	68 45 02 00 00       	push   $0x245
  803cb1:	68 4d 4b 80 00       	push   $0x804b4d
  803cb6:	e8 3a cb ff ff       	call   8007f5 <_panic>
  803cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cbe:	8b 00                	mov    (%eax),%eax
  803cc0:	85 c0                	test   %eax,%eax
  803cc2:	74 10                	je     803cd4 <realloc_block_FF+0x6ab>
  803cc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc7:	8b 00                	mov    (%eax),%eax
  803cc9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ccc:	8b 52 04             	mov    0x4(%edx),%edx
  803ccf:	89 50 04             	mov    %edx,0x4(%eax)
  803cd2:	eb 0b                	jmp    803cdf <realloc_block_FF+0x6b6>
  803cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd7:	8b 40 04             	mov    0x4(%eax),%eax
  803cda:	a3 30 50 80 00       	mov    %eax,0x805030
  803cdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce2:	8b 40 04             	mov    0x4(%eax),%eax
  803ce5:	85 c0                	test   %eax,%eax
  803ce7:	74 0f                	je     803cf8 <realloc_block_FF+0x6cf>
  803ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cec:	8b 40 04             	mov    0x4(%eax),%eax
  803cef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cf2:	8b 12                	mov    (%edx),%edx
  803cf4:	89 10                	mov    %edx,(%eax)
  803cf6:	eb 0a                	jmp    803d02 <realloc_block_FF+0x6d9>
  803cf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cfb:	8b 00                	mov    (%eax),%eax
  803cfd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d15:	a1 38 50 80 00       	mov    0x805038,%eax
  803d1a:	48                   	dec    %eax
  803d1b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803d20:	83 ec 04             	sub    $0x4,%esp
  803d23:	6a 00                	push   $0x0
  803d25:	ff 75 bc             	pushl  -0x44(%ebp)
  803d28:	ff 75 b8             	pushl  -0x48(%ebp)
  803d2b:	e8 06 e9 ff ff       	call   802636 <set_block_data>
  803d30:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803d33:	8b 45 08             	mov    0x8(%ebp),%eax
  803d36:	eb 0a                	jmp    803d42 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803d38:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803d3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803d42:	c9                   	leave  
  803d43:	c3                   	ret    

00803d44 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803d44:	55                   	push   %ebp
  803d45:	89 e5                	mov    %esp,%ebp
  803d47:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803d4a:	83 ec 04             	sub    $0x4,%esp
  803d4d:	68 44 4c 80 00       	push   $0x804c44
  803d52:	68 58 02 00 00       	push   $0x258
  803d57:	68 4d 4b 80 00       	push   $0x804b4d
  803d5c:	e8 94 ca ff ff       	call   8007f5 <_panic>

00803d61 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803d61:	55                   	push   %ebp
  803d62:	89 e5                	mov    %esp,%ebp
  803d64:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803d67:	83 ec 04             	sub    $0x4,%esp
  803d6a:	68 6c 4c 80 00       	push   $0x804c6c
  803d6f:	68 61 02 00 00       	push   $0x261
  803d74:	68 4d 4b 80 00       	push   $0x804b4d
  803d79:	e8 77 ca ff ff       	call   8007f5 <_panic>
  803d7e:	66 90                	xchg   %ax,%ax

00803d80 <__udivdi3>:
  803d80:	55                   	push   %ebp
  803d81:	57                   	push   %edi
  803d82:	56                   	push   %esi
  803d83:	53                   	push   %ebx
  803d84:	83 ec 1c             	sub    $0x1c,%esp
  803d87:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d8b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d97:	89 ca                	mov    %ecx,%edx
  803d99:	89 f8                	mov    %edi,%eax
  803d9b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d9f:	85 f6                	test   %esi,%esi
  803da1:	75 2d                	jne    803dd0 <__udivdi3+0x50>
  803da3:	39 cf                	cmp    %ecx,%edi
  803da5:	77 65                	ja     803e0c <__udivdi3+0x8c>
  803da7:	89 fd                	mov    %edi,%ebp
  803da9:	85 ff                	test   %edi,%edi
  803dab:	75 0b                	jne    803db8 <__udivdi3+0x38>
  803dad:	b8 01 00 00 00       	mov    $0x1,%eax
  803db2:	31 d2                	xor    %edx,%edx
  803db4:	f7 f7                	div    %edi
  803db6:	89 c5                	mov    %eax,%ebp
  803db8:	31 d2                	xor    %edx,%edx
  803dba:	89 c8                	mov    %ecx,%eax
  803dbc:	f7 f5                	div    %ebp
  803dbe:	89 c1                	mov    %eax,%ecx
  803dc0:	89 d8                	mov    %ebx,%eax
  803dc2:	f7 f5                	div    %ebp
  803dc4:	89 cf                	mov    %ecx,%edi
  803dc6:	89 fa                	mov    %edi,%edx
  803dc8:	83 c4 1c             	add    $0x1c,%esp
  803dcb:	5b                   	pop    %ebx
  803dcc:	5e                   	pop    %esi
  803dcd:	5f                   	pop    %edi
  803dce:	5d                   	pop    %ebp
  803dcf:	c3                   	ret    
  803dd0:	39 ce                	cmp    %ecx,%esi
  803dd2:	77 28                	ja     803dfc <__udivdi3+0x7c>
  803dd4:	0f bd fe             	bsr    %esi,%edi
  803dd7:	83 f7 1f             	xor    $0x1f,%edi
  803dda:	75 40                	jne    803e1c <__udivdi3+0x9c>
  803ddc:	39 ce                	cmp    %ecx,%esi
  803dde:	72 0a                	jb     803dea <__udivdi3+0x6a>
  803de0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803de4:	0f 87 9e 00 00 00    	ja     803e88 <__udivdi3+0x108>
  803dea:	b8 01 00 00 00       	mov    $0x1,%eax
  803def:	89 fa                	mov    %edi,%edx
  803df1:	83 c4 1c             	add    $0x1c,%esp
  803df4:	5b                   	pop    %ebx
  803df5:	5e                   	pop    %esi
  803df6:	5f                   	pop    %edi
  803df7:	5d                   	pop    %ebp
  803df8:	c3                   	ret    
  803df9:	8d 76 00             	lea    0x0(%esi),%esi
  803dfc:	31 ff                	xor    %edi,%edi
  803dfe:	31 c0                	xor    %eax,%eax
  803e00:	89 fa                	mov    %edi,%edx
  803e02:	83 c4 1c             	add    $0x1c,%esp
  803e05:	5b                   	pop    %ebx
  803e06:	5e                   	pop    %esi
  803e07:	5f                   	pop    %edi
  803e08:	5d                   	pop    %ebp
  803e09:	c3                   	ret    
  803e0a:	66 90                	xchg   %ax,%ax
  803e0c:	89 d8                	mov    %ebx,%eax
  803e0e:	f7 f7                	div    %edi
  803e10:	31 ff                	xor    %edi,%edi
  803e12:	89 fa                	mov    %edi,%edx
  803e14:	83 c4 1c             	add    $0x1c,%esp
  803e17:	5b                   	pop    %ebx
  803e18:	5e                   	pop    %esi
  803e19:	5f                   	pop    %edi
  803e1a:	5d                   	pop    %ebp
  803e1b:	c3                   	ret    
  803e1c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e21:	89 eb                	mov    %ebp,%ebx
  803e23:	29 fb                	sub    %edi,%ebx
  803e25:	89 f9                	mov    %edi,%ecx
  803e27:	d3 e6                	shl    %cl,%esi
  803e29:	89 c5                	mov    %eax,%ebp
  803e2b:	88 d9                	mov    %bl,%cl
  803e2d:	d3 ed                	shr    %cl,%ebp
  803e2f:	89 e9                	mov    %ebp,%ecx
  803e31:	09 f1                	or     %esi,%ecx
  803e33:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e37:	89 f9                	mov    %edi,%ecx
  803e39:	d3 e0                	shl    %cl,%eax
  803e3b:	89 c5                	mov    %eax,%ebp
  803e3d:	89 d6                	mov    %edx,%esi
  803e3f:	88 d9                	mov    %bl,%cl
  803e41:	d3 ee                	shr    %cl,%esi
  803e43:	89 f9                	mov    %edi,%ecx
  803e45:	d3 e2                	shl    %cl,%edx
  803e47:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e4b:	88 d9                	mov    %bl,%cl
  803e4d:	d3 e8                	shr    %cl,%eax
  803e4f:	09 c2                	or     %eax,%edx
  803e51:	89 d0                	mov    %edx,%eax
  803e53:	89 f2                	mov    %esi,%edx
  803e55:	f7 74 24 0c          	divl   0xc(%esp)
  803e59:	89 d6                	mov    %edx,%esi
  803e5b:	89 c3                	mov    %eax,%ebx
  803e5d:	f7 e5                	mul    %ebp
  803e5f:	39 d6                	cmp    %edx,%esi
  803e61:	72 19                	jb     803e7c <__udivdi3+0xfc>
  803e63:	74 0b                	je     803e70 <__udivdi3+0xf0>
  803e65:	89 d8                	mov    %ebx,%eax
  803e67:	31 ff                	xor    %edi,%edi
  803e69:	e9 58 ff ff ff       	jmp    803dc6 <__udivdi3+0x46>
  803e6e:	66 90                	xchg   %ax,%ax
  803e70:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e74:	89 f9                	mov    %edi,%ecx
  803e76:	d3 e2                	shl    %cl,%edx
  803e78:	39 c2                	cmp    %eax,%edx
  803e7a:	73 e9                	jae    803e65 <__udivdi3+0xe5>
  803e7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e7f:	31 ff                	xor    %edi,%edi
  803e81:	e9 40 ff ff ff       	jmp    803dc6 <__udivdi3+0x46>
  803e86:	66 90                	xchg   %ax,%ax
  803e88:	31 c0                	xor    %eax,%eax
  803e8a:	e9 37 ff ff ff       	jmp    803dc6 <__udivdi3+0x46>
  803e8f:	90                   	nop

00803e90 <__umoddi3>:
  803e90:	55                   	push   %ebp
  803e91:	57                   	push   %edi
  803e92:	56                   	push   %esi
  803e93:	53                   	push   %ebx
  803e94:	83 ec 1c             	sub    $0x1c,%esp
  803e97:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e9b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ea3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ea7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803eab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803eaf:	89 f3                	mov    %esi,%ebx
  803eb1:	89 fa                	mov    %edi,%edx
  803eb3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eb7:	89 34 24             	mov    %esi,(%esp)
  803eba:	85 c0                	test   %eax,%eax
  803ebc:	75 1a                	jne    803ed8 <__umoddi3+0x48>
  803ebe:	39 f7                	cmp    %esi,%edi
  803ec0:	0f 86 a2 00 00 00    	jbe    803f68 <__umoddi3+0xd8>
  803ec6:	89 c8                	mov    %ecx,%eax
  803ec8:	89 f2                	mov    %esi,%edx
  803eca:	f7 f7                	div    %edi
  803ecc:	89 d0                	mov    %edx,%eax
  803ece:	31 d2                	xor    %edx,%edx
  803ed0:	83 c4 1c             	add    $0x1c,%esp
  803ed3:	5b                   	pop    %ebx
  803ed4:	5e                   	pop    %esi
  803ed5:	5f                   	pop    %edi
  803ed6:	5d                   	pop    %ebp
  803ed7:	c3                   	ret    
  803ed8:	39 f0                	cmp    %esi,%eax
  803eda:	0f 87 ac 00 00 00    	ja     803f8c <__umoddi3+0xfc>
  803ee0:	0f bd e8             	bsr    %eax,%ebp
  803ee3:	83 f5 1f             	xor    $0x1f,%ebp
  803ee6:	0f 84 ac 00 00 00    	je     803f98 <__umoddi3+0x108>
  803eec:	bf 20 00 00 00       	mov    $0x20,%edi
  803ef1:	29 ef                	sub    %ebp,%edi
  803ef3:	89 fe                	mov    %edi,%esi
  803ef5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ef9:	89 e9                	mov    %ebp,%ecx
  803efb:	d3 e0                	shl    %cl,%eax
  803efd:	89 d7                	mov    %edx,%edi
  803eff:	89 f1                	mov    %esi,%ecx
  803f01:	d3 ef                	shr    %cl,%edi
  803f03:	09 c7                	or     %eax,%edi
  803f05:	89 e9                	mov    %ebp,%ecx
  803f07:	d3 e2                	shl    %cl,%edx
  803f09:	89 14 24             	mov    %edx,(%esp)
  803f0c:	89 d8                	mov    %ebx,%eax
  803f0e:	d3 e0                	shl    %cl,%eax
  803f10:	89 c2                	mov    %eax,%edx
  803f12:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f16:	d3 e0                	shl    %cl,%eax
  803f18:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f20:	89 f1                	mov    %esi,%ecx
  803f22:	d3 e8                	shr    %cl,%eax
  803f24:	09 d0                	or     %edx,%eax
  803f26:	d3 eb                	shr    %cl,%ebx
  803f28:	89 da                	mov    %ebx,%edx
  803f2a:	f7 f7                	div    %edi
  803f2c:	89 d3                	mov    %edx,%ebx
  803f2e:	f7 24 24             	mull   (%esp)
  803f31:	89 c6                	mov    %eax,%esi
  803f33:	89 d1                	mov    %edx,%ecx
  803f35:	39 d3                	cmp    %edx,%ebx
  803f37:	0f 82 87 00 00 00    	jb     803fc4 <__umoddi3+0x134>
  803f3d:	0f 84 91 00 00 00    	je     803fd4 <__umoddi3+0x144>
  803f43:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f47:	29 f2                	sub    %esi,%edx
  803f49:	19 cb                	sbb    %ecx,%ebx
  803f4b:	89 d8                	mov    %ebx,%eax
  803f4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f51:	d3 e0                	shl    %cl,%eax
  803f53:	89 e9                	mov    %ebp,%ecx
  803f55:	d3 ea                	shr    %cl,%edx
  803f57:	09 d0                	or     %edx,%eax
  803f59:	89 e9                	mov    %ebp,%ecx
  803f5b:	d3 eb                	shr    %cl,%ebx
  803f5d:	89 da                	mov    %ebx,%edx
  803f5f:	83 c4 1c             	add    $0x1c,%esp
  803f62:	5b                   	pop    %ebx
  803f63:	5e                   	pop    %esi
  803f64:	5f                   	pop    %edi
  803f65:	5d                   	pop    %ebp
  803f66:	c3                   	ret    
  803f67:	90                   	nop
  803f68:	89 fd                	mov    %edi,%ebp
  803f6a:	85 ff                	test   %edi,%edi
  803f6c:	75 0b                	jne    803f79 <__umoddi3+0xe9>
  803f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803f73:	31 d2                	xor    %edx,%edx
  803f75:	f7 f7                	div    %edi
  803f77:	89 c5                	mov    %eax,%ebp
  803f79:	89 f0                	mov    %esi,%eax
  803f7b:	31 d2                	xor    %edx,%edx
  803f7d:	f7 f5                	div    %ebp
  803f7f:	89 c8                	mov    %ecx,%eax
  803f81:	f7 f5                	div    %ebp
  803f83:	89 d0                	mov    %edx,%eax
  803f85:	e9 44 ff ff ff       	jmp    803ece <__umoddi3+0x3e>
  803f8a:	66 90                	xchg   %ax,%ax
  803f8c:	89 c8                	mov    %ecx,%eax
  803f8e:	89 f2                	mov    %esi,%edx
  803f90:	83 c4 1c             	add    $0x1c,%esp
  803f93:	5b                   	pop    %ebx
  803f94:	5e                   	pop    %esi
  803f95:	5f                   	pop    %edi
  803f96:	5d                   	pop    %ebp
  803f97:	c3                   	ret    
  803f98:	3b 04 24             	cmp    (%esp),%eax
  803f9b:	72 06                	jb     803fa3 <__umoddi3+0x113>
  803f9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803fa1:	77 0f                	ja     803fb2 <__umoddi3+0x122>
  803fa3:	89 f2                	mov    %esi,%edx
  803fa5:	29 f9                	sub    %edi,%ecx
  803fa7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803fab:	89 14 24             	mov    %edx,(%esp)
  803fae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fb2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803fb6:	8b 14 24             	mov    (%esp),%edx
  803fb9:	83 c4 1c             	add    $0x1c,%esp
  803fbc:	5b                   	pop    %ebx
  803fbd:	5e                   	pop    %esi
  803fbe:	5f                   	pop    %edi
  803fbf:	5d                   	pop    %ebp
  803fc0:	c3                   	ret    
  803fc1:	8d 76 00             	lea    0x0(%esi),%esi
  803fc4:	2b 04 24             	sub    (%esp),%eax
  803fc7:	19 fa                	sbb    %edi,%edx
  803fc9:	89 d1                	mov    %edx,%ecx
  803fcb:	89 c6                	mov    %eax,%esi
  803fcd:	e9 71 ff ff ff       	jmp    803f43 <__umoddi3+0xb3>
  803fd2:	66 90                	xchg   %ax,%ax
  803fd4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803fd8:	72 ea                	jb     803fc4 <__umoddi3+0x134>
  803fda:	89 d9                	mov    %ebx,%ecx
  803fdc:	e9 62 ff ff ff       	jmp    803f43 <__umoddi3+0xb3>
