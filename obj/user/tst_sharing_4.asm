
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
  80005c:	68 60 40 80 00       	push   $0x804060
  800061:	6a 13                	push   $0x13
  800063:	68 7c 40 80 00       	push   $0x80407c
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
  800085:	68 94 40 80 00       	push   $0x804094
  80008a:	e8 23 0a 00 00       	call   800ab2 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	68 c8 40 80 00       	push   $0x8040c8
  80009a:	e8 13 0a 00 00       	call   800ab2 <cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 24 41 80 00       	push   $0x804124
  8000aa:	e8 03 0a 00 00       	call   800ab2 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000b2:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000b9:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	int envID = sys_getenvid();
  8000c0:	e8 2f 1f 00 00       	call   801ff4 <sys_getenvid>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000c8:	83 ec 0c             	sub    $0xc,%esp
  8000cb:	68 58 41 80 00       	push   $0x804158
  8000d0:	e8 dd 09 00 00       	call   800ab2 <cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 67 1d 00 00       	call   801e44 <sys_calculate_free_frames>
  8000dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 01                	push   $0x1
  8000e5:	68 00 10 00 00       	push   $0x1000
  8000ea:	68 8c 41 80 00       	push   $0x80418c
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
  80010c:	68 90 41 80 00       	push   $0x804190
  800111:	e8 9c 09 00 00       	call   800ab2 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  800119:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800120:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800123:	e8 1c 1d 00 00       	call   801e44 <sys_calculate_free_frames>
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
  80014c:	e8 f3 1c 00 00       	call   801e44 <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015b:	50                   	push   %eax
  80015c:	68 fc 41 80 00       	push   $0x8041fc
  800161:	e8 4c 09 00 00       	call   800ab2 <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	ff 75 d8             	pushl  -0x28(%ebp)
  80016f:	e8 1f 1b 00 00       	call   801c93 <sfree>
  800174:	83 c4 10             	add    $0x10,%esp
		expected = 0 ;
  800177:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80017e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800181:	e8 be 1c 00 00       	call   801e44 <sys_calculate_free_frames>
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
  80019f:	e8 a0 1c 00 00       	call   801e44 <sys_calculate_free_frames>
  8001a4:	29 c3                	sub    %eax,%ebx
  8001a6:	89 d8                	mov    %ebx,%eax
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	50                   	push   %eax
  8001ac:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001af:	68 94 42 80 00       	push   $0x804294
  8001b4:	e8 f9 08 00 00       	call   800ab2 <cprintf>
  8001b9:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step A completed!!\n\n\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 df 42 80 00       	push   $0x8042df
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
  8001e0:	68 f8 42 80 00       	push   $0x8042f8
  8001e5:	e8 c8 08 00 00       	call   800ab2 <cprintf>
  8001ea:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  8001ed:	e8 52 1c 00 00       	call   801e44 <sys_calculate_free_frames>
  8001f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	6a 01                	push   $0x1
  8001fa:	68 00 10 00 00       	push   $0x1000
  8001ff:	68 2d 43 80 00       	push   $0x80432d
  800204:	e8 76 19 00 00       	call   801b7f <smalloc>
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	6a 01                	push   $0x1
  800214:	68 00 10 00 00       	push   $0x1000
  800219:	68 8c 41 80 00       	push   $0x80418c
  80021e:	e8 5c 19 00 00       	call   801b7f <smalloc>
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if(x == NULL)
  800229:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80022d:	75 17                	jne    800246 <_main+0x20e>
		{is_correct = 0; cprintf("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  80022f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 30 43 80 00       	push   $0x804330
  80023e:	e8 6f 08 00 00       	call   800ab2 <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp

		expected = 2+1 ; /*2pages +1table*/
  800246:	c7 45 d4 03 00 00 00 	movl   $0x3,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80024d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800250:	e8 ef 1b 00 00       	call   801e44 <sys_calculate_free_frames>
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
  800279:	68 88 43 80 00       	push   $0x804388
  80027e:	e8 2f 08 00 00       	call   800ab2 <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp

		sfree(z);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 75 c8             	pushl  -0x38(%ebp)
  80028c:	e8 02 1a 00 00       	call   801c93 <sfree>
  800291:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800294:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80029b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80029e:	e8 a1 1b 00 00       	call   801e44 <sys_calculate_free_frames>
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
  8002bc:	e8 83 1b 00 00       	call   801e44 <sys_calculate_free_frames>
  8002c1:	29 c3                	sub    %eax,%ebx
  8002c3:	89 d8                	mov    %ebx,%eax
  8002c5:	83 ec 04             	sub    $0x4,%esp
  8002c8:	50                   	push   %eax
  8002c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cc:	68 94 42 80 00       	push   $0x804294
  8002d1:	e8 dc 07 00 00       	call   800ab2 <cprintf>
  8002d6:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002df:	e8 af 19 00 00       	call   801c93 <sfree>
  8002e4:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8002e7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8002ee:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002f1:	e8 4e 1b 00 00       	call   801e44 <sys_calculate_free_frames>
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
  80030f:	e8 30 1b 00 00       	call   801e44 <sys_calculate_free_frames>
  800314:	29 c3                	sub    %eax,%ebx
  800316:	89 d8                	mov    %ebx,%eax
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	50                   	push   %eax
  80031c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031f:	68 94 42 80 00       	push   $0x804294
  800324:	e8 89 07 00 00       	call   800ab2 <cprintf>
  800329:	83 c4 10             	add    $0x10,%esp

	}
	cprintf("Step B completed!!\n\n\n");
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	68 dd 43 80 00       	push   $0x8043dd
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
  800350:	68 f4 43 80 00       	push   $0x8043f4
  800355:	e8 58 07 00 00       	call   800ab2 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80035d:	e8 e2 1a 00 00       	call   801e44 <sys_calculate_free_frames>
  800362:	89 45 c0             	mov    %eax,-0x40(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	6a 01                	push   $0x1
  80036a:	68 01 30 00 00       	push   $0x3001
  80036f:	68 29 44 80 00       	push   $0x804429
  800374:	e8 06 18 00 00       	call   801b7f <smalloc>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	6a 01                	push   $0x1
  800384:	68 00 10 00 00       	push   $0x1000
  800389:	68 2b 44 80 00       	push   $0x80442b
  80038e:	e8 ec 17 00 00       	call   801b7f <smalloc>
  800393:	83 c4 10             	add    $0x10,%esp
  800396:	89 45 b8             	mov    %eax,-0x48(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  800399:	c7 45 d4 06 00 00 00 	movl   $0x6,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003a0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8003a3:	e8 9c 1a 00 00       	call   801e44 <sys_calculate_free_frames>
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
  8003cc:	e8 73 1a 00 00       	call   801e44 <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 ec 04             	sub    $0x4,%esp
  8003d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	68 fc 41 80 00       	push   $0x8041fc
  8003e1:	e8 cc 06 00 00       	call   800ab2 <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp

		sfree(w);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	ff 75 bc             	pushl  -0x44(%ebp)
  8003ef:	e8 9f 18 00 00       	call   801c93 <sfree>
  8003f4:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8003f7:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003fe:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800401:	e8 3e 1a 00 00       	call   801e44 <sys_calculate_free_frames>
  800406:	29 c3                	sub    %eax,%ebx
  800408:	89 d8                	mov    %ebx,%eax
  80040a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  80040d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800410:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800413:	74 27                	je     80043c <_main+0x404>
  800415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80041c:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80041f:	e8 20 1a 00 00       	call   801e44 <sys_calculate_free_frames>
  800424:	29 c3                	sub    %eax,%ebx
  800426:	89 d8                	mov    %ebx,%eax
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	50                   	push   %eax
  80042c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80042f:	68 94 42 80 00       	push   $0x804294
  800434:	e8 79 06 00 00       	call   800ab2 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80043c:	83 ec 04             	sub    $0x4,%esp
  80043f:	6a 01                	push   $0x1
  800441:	68 ff 1f 00 00       	push   $0x1fff
  800446:	68 2d 44 80 00       	push   $0x80442d
  80044b:	e8 2f 17 00 00       	call   801b7f <smalloc>
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800456:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80045d:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800460:	e8 df 19 00 00       	call   801e44 <sys_calculate_free_frames>
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
  80047e:	e8 c1 19 00 00       	call   801e44 <sys_calculate_free_frames>
  800483:	29 c3                	sub    %eax,%ebx
  800485:	89 d8                	mov    %ebx,%eax
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80048d:	50                   	push   %eax
  80048e:	68 fc 41 80 00       	push   $0x8041fc
  800493:	e8 1a 06 00 00       	call   800ab2 <cprintf>
  800498:	83 c4 10             	add    $0x10,%esp

		sfree(o);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004a1:	e8 ed 17 00 00       	call   801c93 <sfree>
  8004a6:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8004a9:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004b0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004b3:	e8 8c 19 00 00       	call   801e44 <sys_calculate_free_frames>
  8004b8:	29 c3                	sub    %eax,%ebx
  8004ba:	89 d8                	mov    %ebx,%eax
  8004bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004c5:	74 27                	je     8004ee <_main+0x4b6>
  8004c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ce:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004d1:	e8 6e 19 00 00       	call   801e44 <sys_calculate_free_frames>
  8004d6:	29 c3                	sub    %eax,%ebx
  8004d8:	89 d8                	mov    %ebx,%eax
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	50                   	push   %eax
  8004de:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004e1:	68 94 42 80 00       	push   $0x804294
  8004e6:	e8 c7 05 00 00       	call   800ab2 <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp

		sfree(u);
  8004ee:	83 ec 0c             	sub    $0xc,%esp
  8004f1:	ff 75 b8             	pushl  -0x48(%ebp)
  8004f4:	e8 9a 17 00 00       	call   801c93 <sfree>
  8004f9:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8004fc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800503:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800506:	e8 39 19 00 00       	call   801e44 <sys_calculate_free_frames>
  80050b:	29 c3                	sub    %eax,%ebx
  80050d:	89 d8                	mov    %ebx,%eax
  80050f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800512:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800515:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800518:	74 27                	je     800541 <_main+0x509>
  80051a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800521:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800524:	e8 1b 19 00 00       	call   801e44 <sys_calculate_free_frames>
  800529:	29 c3                	sub    %eax,%ebx
  80052b:	89 d8                	mov    %ebx,%eax
  80052d:	83 ec 04             	sub    $0x4,%esp
  800530:	50                   	push   %eax
  800531:	ff 75 d4             	pushl  -0x2c(%ebp)
  800534:	68 94 42 80 00       	push   $0x804294
  800539:	e8 74 05 00 00       	call   800ab2 <cprintf>
  80053e:	83 c4 10             	add    $0x10,%esp


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800541:	e8 fe 18 00 00       	call   801e44 <sys_calculate_free_frames>
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
  80055b:	68 29 44 80 00       	push   $0x804429
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
  800581:	68 2b 44 80 00       	push   $0x80442b
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
  8005a3:	68 2d 44 80 00       	push   $0x80442d
  8005a8:	e8 d2 15 00 00       	call   801b7f <smalloc>
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  8005b3:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8005ba:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8005bd:	e8 82 18 00 00       	call   801e44 <sys_calculate_free_frames>
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
  8005e6:	e8 59 18 00 00       	call   801e44 <sys_calculate_free_frames>
  8005eb:	29 c3                	sub    %eax,%ebx
  8005ed:	89 d8                	mov    %ebx,%eax
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005f5:	50                   	push   %eax
  8005f6:	68 fc 41 80 00       	push   $0x8041fc
  8005fb:	e8 b2 04 00 00       	call   800ab2 <cprintf>
  800600:	83 c4 10             	add    $0x10,%esp

		freeFrames = sys_calculate_free_frames() ;
  800603:	e8 3c 18 00 00       	call   801e44 <sys_calculate_free_frames>
  800608:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(o);
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	ff 75 b4             	pushl  -0x4c(%ebp)
  800611:	e8 7d 16 00 00       	call   801c93 <sfree>
  800616:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(w);
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	ff 75 bc             	pushl  -0x44(%ebp)
  80061f:	e8 6f 16 00 00       	call   801c93 <sfree>
  800624:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(u);
  800627:	83 ec 0c             	sub    $0xc,%esp
  80062a:	ff 75 b8             	pushl  -0x48(%ebp)
  80062d:	e8 61 16 00 00       	call   801c93 <sfree>
  800632:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  800635:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  80063c:	e8 03 18 00 00       	call   801e44 <sys_calculate_free_frames>
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
  80065f:	e8 e0 17 00 00       	call   801e44 <sys_calculate_free_frames>
  800664:	29 c3                	sub    %eax,%ebx
  800666:	89 d8                	mov    %ebx,%eax
  800668:	83 ec 04             	sub    $0x4,%esp
  80066b:	50                   	push   %eax
  80066c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80066f:	68 94 42 80 00       	push   $0x804294
  800674:	e8 39 04 00 00       	call   800ab2 <cprintf>
  800679:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step C completed!!\n\n\n");
  80067c:	83 ec 0c             	sub    $0xc,%esp
  80067f:	68 2f 44 80 00       	push   $0x80442f
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
  8006a3:	68 48 44 80 00       	push   $0x804448
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
  8006bc:	e8 4c 19 00 00       	call   80200d <sys_getenvindex>
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
  80072a:	e8 62 16 00 00       	call   801d91 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	68 9c 44 80 00       	push   $0x80449c
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
  80075a:	68 c4 44 80 00       	push   $0x8044c4
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
  80078b:	68 ec 44 80 00       	push   $0x8044ec
  800790:	e8 1d 03 00 00       	call   800ab2 <cprintf>
  800795:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800798:	a1 20 50 80 00       	mov    0x805020,%eax
  80079d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	50                   	push   %eax
  8007a7:	68 44 45 80 00       	push   $0x804544
  8007ac:	e8 01 03 00 00       	call   800ab2 <cprintf>
  8007b1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8007b4:	83 ec 0c             	sub    $0xc,%esp
  8007b7:	68 9c 44 80 00       	push   $0x80449c
  8007bc:	e8 f1 02 00 00       	call   800ab2 <cprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8007c4:	e8 e2 15 00 00       	call   801dab <sys_unlock_cons>
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
  8007dc:	e8 f8 17 00 00       	call   801fd9 <sys_destroy_env>
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
  8007ed:	e8 4d 18 00 00       	call   80203f <sys_exit_env>
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
  800816:	68 58 45 80 00       	push   $0x804558
  80081b:	e8 92 02 00 00       	call   800ab2 <cprintf>
  800820:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800823:	a1 00 50 80 00       	mov    0x805000,%eax
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	50                   	push   %eax
  80082f:	68 5d 45 80 00       	push   $0x80455d
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
  800853:	68 79 45 80 00       	push   $0x804579
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
  800882:	68 7c 45 80 00       	push   $0x80457c
  800887:	6a 26                	push   $0x26
  800889:	68 c8 45 80 00       	push   $0x8045c8
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
  800957:	68 d4 45 80 00       	push   $0x8045d4
  80095c:	6a 3a                	push   $0x3a
  80095e:	68 c8 45 80 00       	push   $0x8045c8
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
  8009ca:	68 28 46 80 00       	push   $0x804628
  8009cf:	6a 44                	push   $0x44
  8009d1:	68 c8 45 80 00       	push   $0x8045c8
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
  800a24:	e8 26 13 00 00       	call   801d4f <sys_cputs>
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
  800a9b:	e8 af 12 00 00       	call   801d4f <sys_cputs>
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
  800ae5:	e8 a7 12 00 00       	call   801d91 <sys_lock_cons>
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
  800b05:	e8 a1 12 00 00       	call   801dab <sys_unlock_cons>
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
  800b4f:	e8 94 32 00 00       	call   803de8 <__udivdi3>
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
  800b9f:	e8 54 33 00 00       	call   803ef8 <__umoddi3>
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	05 94 48 80 00       	add    $0x804894,%eax
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
  800cfa:	8b 04 85 b8 48 80 00 	mov    0x8048b8(,%eax,4),%eax
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
  800ddb:	8b 34 9d 00 47 80 00 	mov    0x804700(,%ebx,4),%esi
  800de2:	85 f6                	test   %esi,%esi
  800de4:	75 19                	jne    800dff <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800de6:	53                   	push   %ebx
  800de7:	68 a5 48 80 00       	push   $0x8048a5
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
  800e00:	68 ae 48 80 00       	push   $0x8048ae
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
  800e2d:	be b1 48 80 00       	mov    $0x8048b1,%esi
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
  801838:	68 28 4a 80 00       	push   $0x804a28
  80183d:	68 3f 01 00 00       	push   $0x13f
  801842:	68 4a 4a 80 00       	push   $0x804a4a
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
  801858:	e8 9d 0a 00 00       	call   8022fa <sys_sbrk>
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
  8018d3:	e8 a6 08 00 00       	call   80217e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	74 16                	je     8018f2 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8018dc:	83 ec 0c             	sub    $0xc,%esp
  8018df:	ff 75 08             	pushl  0x8(%ebp)
  8018e2:	e8 e6 0d 00 00       	call   8026cd <alloc_block_FF>
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018ed:	e9 8a 01 00 00       	jmp    801a7c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8018f2:	e8 b8 08 00 00       	call   8021af <sys_isUHeapPlacementStrategyBESTFIT>
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	0f 84 7d 01 00 00    	je     801a7c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	e8 7f 12 00 00       	call   802b89 <alloc_block_BF>
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
  801a6b:	e8 c1 08 00 00       	call   802331 <sys_allocate_user_mem>
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
  801ab3:	e8 95 08 00 00       	call   80234d <get_block_size>
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801abe:	83 ec 0c             	sub    $0xc,%esp
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	e8 c8 1a 00 00       	call   803591 <free_block>
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
  801b5b:	e8 b5 07 00 00       	call   802315 <sys_free_user_mem>
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
  801b69:	68 58 4a 80 00       	push   $0x804a58
  801b6e:	68 84 00 00 00       	push   $0x84
  801b73:	68 82 4a 80 00       	push   $0x804a82
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
  801bdb:	e8 3c 03 00 00       	call   801f1c <sys_createSharedObject>
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
  801bfc:	68 8e 4a 80 00       	push   $0x804a8e
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
  801c11:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c14:	83 ec 08             	sub    $0x8,%esp
  801c17:	ff 75 0c             	pushl  0xc(%ebp)
  801c1a:	ff 75 08             	pushl  0x8(%ebp)
  801c1d:	e8 24 03 00 00       	call   801f46 <sys_getSizeOfSharedObject>
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801c28:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c2c:	75 07                	jne    801c35 <sget+0x27>
  801c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c33:	eb 5c                	jmp    801c91 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c3b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c48:	39 d0                	cmp    %edx,%eax
  801c4a:	7d 02                	jge    801c4e <sget+0x40>
  801c4c:	89 d0                	mov    %edx,%eax
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	50                   	push   %eax
  801c52:	e8 0b fc ff ff       	call   801862 <malloc>
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801c5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c61:	75 07                	jne    801c6a <sget+0x5c>
  801c63:	b8 00 00 00 00       	mov    $0x0,%eax
  801c68:	eb 27                	jmp    801c91 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	ff 75 e8             	pushl  -0x18(%ebp)
  801c70:	ff 75 0c             	pushl  0xc(%ebp)
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	e8 e8 02 00 00       	call   801f63 <sys_getSharedObject>
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801c81:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801c85:	75 07                	jne    801c8e <sget+0x80>
  801c87:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8c:	eb 03                	jmp    801c91 <sget+0x83>
	return ptr;
  801c8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c99:	83 ec 04             	sub    $0x4,%esp
  801c9c:	68 94 4a 80 00       	push   $0x804a94
  801ca1:	68 c2 00 00 00       	push   $0xc2
  801ca6:	68 82 4a 80 00       	push   $0x804a82
  801cab:	e8 45 eb ff ff       	call   8007f5 <_panic>

00801cb0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801cb6:	83 ec 04             	sub    $0x4,%esp
  801cb9:	68 b8 4a 80 00       	push   $0x804ab8
  801cbe:	68 d9 00 00 00       	push   $0xd9
  801cc3:	68 82 4a 80 00       	push   $0x804a82
  801cc8:	e8 28 eb ff ff       	call   8007f5 <_panic>

00801ccd <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cd3:	83 ec 04             	sub    $0x4,%esp
  801cd6:	68 de 4a 80 00       	push   $0x804ade
  801cdb:	68 e5 00 00 00       	push   $0xe5
  801ce0:	68 82 4a 80 00       	push   $0x804a82
  801ce5:	e8 0b eb ff ff       	call   8007f5 <_panic>

00801cea <shrink>:

}
void shrink(uint32 newSize)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	68 de 4a 80 00       	push   $0x804ade
  801cf8:	68 ea 00 00 00       	push   $0xea
  801cfd:	68 82 4a 80 00       	push   $0x804a82
  801d02:	e8 ee ea ff ff       	call   8007f5 <_panic>

00801d07 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	68 de 4a 80 00       	push   $0x804ade
  801d15:	68 ef 00 00 00       	push   $0xef
  801d1a:	68 82 4a 80 00       	push   $0x804a82
  801d1f:	e8 d1 ea ff ff       	call   8007f5 <_panic>

00801d24 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	57                   	push   %edi
  801d28:	56                   	push   %esi
  801d29:	53                   	push   %ebx
  801d2a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d36:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d39:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d3c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d3f:	cd 30                	int    $0x30
  801d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d47:	83 c4 10             	add    $0x10,%esp
  801d4a:	5b                   	pop    %ebx
  801d4b:	5e                   	pop    %esi
  801d4c:	5f                   	pop    %edi
  801d4d:	5d                   	pop    %ebp
  801d4e:	c3                   	ret    

00801d4f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	83 ec 04             	sub    $0x4,%esp
  801d55:	8b 45 10             	mov    0x10(%ebp),%eax
  801d58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d5b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	52                   	push   %edx
  801d67:	ff 75 0c             	pushl  0xc(%ebp)
  801d6a:	50                   	push   %eax
  801d6b:	6a 00                	push   $0x0
  801d6d:	e8 b2 ff ff ff       	call   801d24 <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	90                   	nop
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 02                	push   $0x2
  801d87:	e8 98 ff ff ff       	call   801d24 <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 03                	push   $0x3
  801da0:	e8 7f ff ff ff       	call   801d24 <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	90                   	nop
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 04                	push   $0x4
  801dba:	e8 65 ff ff ff       	call   801d24 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	90                   	nop
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	52                   	push   %edx
  801dd5:	50                   	push   %eax
  801dd6:	6a 08                	push   $0x8
  801dd8:	e8 47 ff ff ff       	call   801d24 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	56                   	push   %esi
  801de6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801de7:	8b 75 18             	mov    0x18(%ebp),%esi
  801dea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ded:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801df0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	56                   	push   %esi
  801df7:	53                   	push   %ebx
  801df8:	51                   	push   %ecx
  801df9:	52                   	push   %edx
  801dfa:	50                   	push   %eax
  801dfb:	6a 09                	push   $0x9
  801dfd:	e8 22 ff ff ff       	call   801d24 <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e08:	5b                   	pop    %ebx
  801e09:	5e                   	pop    %esi
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    

00801e0c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	52                   	push   %edx
  801e1c:	50                   	push   %eax
  801e1d:	6a 0a                	push   $0xa
  801e1f:	e8 00 ff ff ff       	call   801d24 <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	ff 75 0c             	pushl  0xc(%ebp)
  801e35:	ff 75 08             	pushl  0x8(%ebp)
  801e38:	6a 0b                	push   $0xb
  801e3a:	e8 e5 fe ff ff       	call   801d24 <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 0c                	push   $0xc
  801e53:	e8 cc fe ff ff       	call   801d24 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 0d                	push   $0xd
  801e6c:	e8 b3 fe ff ff       	call   801d24 <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 0e                	push   $0xe
  801e85:	e8 9a fe ff ff       	call   801d24 <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 0f                	push   $0xf
  801e9e:	e8 81 fe ff ff       	call   801d24 <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	ff 75 08             	pushl  0x8(%ebp)
  801eb6:	6a 10                	push   $0x10
  801eb8:	e8 67 fe ff ff       	call   801d24 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 11                	push   $0x11
  801ed1:	e8 4e fe ff ff       	call   801d24 <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
}
  801ed9:	90                   	nop
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_cputc>:

void
sys_cputc(const char c)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ee8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	50                   	push   %eax
  801ef5:	6a 01                	push   $0x1
  801ef7:	e8 28 fe ff ff       	call   801d24 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
}
  801eff:	90                   	nop
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 14                	push   $0x14
  801f11:	e8 0e fe ff ff       	call   801d24 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
}
  801f19:	90                   	nop
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 04             	sub    $0x4,%esp
  801f22:	8b 45 10             	mov    0x10(%ebp),%eax
  801f25:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f28:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f2b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	6a 00                	push   $0x0
  801f34:	51                   	push   %ecx
  801f35:	52                   	push   %edx
  801f36:	ff 75 0c             	pushl  0xc(%ebp)
  801f39:	50                   	push   %eax
  801f3a:	6a 15                	push   $0x15
  801f3c:	e8 e3 fd ff ff       	call   801d24 <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	52                   	push   %edx
  801f56:	50                   	push   %eax
  801f57:	6a 16                	push   $0x16
  801f59:	e8 c6 fd ff ff       	call   801d24 <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	51                   	push   %ecx
  801f74:	52                   	push   %edx
  801f75:	50                   	push   %eax
  801f76:	6a 17                	push   $0x17
  801f78:	e8 a7 fd ff ff       	call   801d24 <syscall>
  801f7d:	83 c4 18             	add    $0x18,%esp
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	52                   	push   %edx
  801f92:	50                   	push   %eax
  801f93:	6a 18                	push   $0x18
  801f95:	e8 8a fd ff ff       	call   801d24 <syscall>
  801f9a:	83 c4 18             	add    $0x18,%esp
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	6a 00                	push   $0x0
  801fa7:	ff 75 14             	pushl  0x14(%ebp)
  801faa:	ff 75 10             	pushl  0x10(%ebp)
  801fad:	ff 75 0c             	pushl  0xc(%ebp)
  801fb0:	50                   	push   %eax
  801fb1:	6a 19                	push   $0x19
  801fb3:	e8 6c fd ff ff       	call   801d24 <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <sys_run_env>:

void sys_run_env(int32 envId)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	50                   	push   %eax
  801fcc:	6a 1a                	push   $0x1a
  801fce:	e8 51 fd ff ff       	call   801d24 <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
}
  801fd6:	90                   	nop
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	50                   	push   %eax
  801fe8:	6a 1b                	push   $0x1b
  801fea:	e8 35 fd ff ff       	call   801d24 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 05                	push   $0x5
  802003:	e8 1c fd ff ff       	call   801d24 <syscall>
  802008:	83 c4 18             	add    $0x18,%esp
}
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 06                	push   $0x6
  80201c:	e8 03 fd ff ff       	call   801d24 <syscall>
  802021:	83 c4 18             	add    $0x18,%esp
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 07                	push   $0x7
  802035:	e8 ea fc ff ff       	call   801d24 <syscall>
  80203a:	83 c4 18             	add    $0x18,%esp
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <sys_exit_env>:


void sys_exit_env(void)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 1c                	push   $0x1c
  80204e:	e8 d1 fc ff ff       	call   801d24 <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	90                   	nop
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80205f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802062:	8d 50 04             	lea    0x4(%eax),%edx
  802065:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	52                   	push   %edx
  80206f:	50                   	push   %eax
  802070:	6a 1d                	push   $0x1d
  802072:	e8 ad fc ff ff       	call   801d24 <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
	return result;
  80207a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80207d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802080:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802083:	89 01                	mov    %eax,(%ecx)
  802085:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	c9                   	leave  
  80208c:	c2 04 00             	ret    $0x4

0080208f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	ff 75 10             	pushl  0x10(%ebp)
  802099:	ff 75 0c             	pushl  0xc(%ebp)
  80209c:	ff 75 08             	pushl  0x8(%ebp)
  80209f:	6a 13                	push   $0x13
  8020a1:	e8 7e fc ff ff       	call   801d24 <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a9:	90                   	nop
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <sys_rcr2>:
uint32 sys_rcr2()
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 1e                	push   $0x1e
  8020bb:	e8 64 fc ff ff       	call   801d24 <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 04             	sub    $0x4,%esp
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020d1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	50                   	push   %eax
  8020de:	6a 1f                	push   $0x1f
  8020e0:	e8 3f fc ff ff       	call   801d24 <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e8:	90                   	nop
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <rsttst>:
void rsttst()
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 21                	push   $0x21
  8020fa:	e8 25 fc ff ff       	call   801d24 <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802102:	90                   	nop
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 04             	sub    $0x4,%esp
  80210b:	8b 45 14             	mov    0x14(%ebp),%eax
  80210e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802111:	8b 55 18             	mov    0x18(%ebp),%edx
  802114:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802118:	52                   	push   %edx
  802119:	50                   	push   %eax
  80211a:	ff 75 10             	pushl  0x10(%ebp)
  80211d:	ff 75 0c             	pushl  0xc(%ebp)
  802120:	ff 75 08             	pushl  0x8(%ebp)
  802123:	6a 20                	push   $0x20
  802125:	e8 fa fb ff ff       	call   801d24 <syscall>
  80212a:	83 c4 18             	add    $0x18,%esp
	return ;
  80212d:	90                   	nop
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <chktst>:
void chktst(uint32 n)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	ff 75 08             	pushl  0x8(%ebp)
  80213e:	6a 22                	push   $0x22
  802140:	e8 df fb ff ff       	call   801d24 <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
	return ;
  802148:	90                   	nop
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <inctst>:

void inctst()
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 23                	push   $0x23
  80215a:	e8 c5 fb ff ff       	call   801d24 <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
	return ;
  802162:	90                   	nop
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <gettst>:
uint32 gettst()
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 24                	push   $0x24
  802174:	e8 ab fb ff ff       	call   801d24 <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 25                	push   $0x25
  802190:	e8 8f fb ff ff       	call   801d24 <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
  802198:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80219b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80219f:	75 07                	jne    8021a8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a6:	eb 05                	jmp    8021ad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 25                	push   $0x25
  8021c1:	e8 5e fb ff ff       	call   801d24 <syscall>
  8021c6:	83 c4 18             	add    $0x18,%esp
  8021c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021cc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021d0:	75 07                	jne    8021d9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d7:	eb 05                	jmp    8021de <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 25                	push   $0x25
  8021f2:	e8 2d fb ff ff       	call   801d24 <syscall>
  8021f7:	83 c4 18             	add    $0x18,%esp
  8021fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021fd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802201:	75 07                	jne    80220a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802203:	b8 01 00 00 00       	mov    $0x1,%eax
  802208:	eb 05                	jmp    80220f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80220a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 25                	push   $0x25
  802223:	e8 fc fa ff ff       	call   801d24 <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
  80222b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80222e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802232:	75 07                	jne    80223b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802234:	b8 01 00 00 00       	mov    $0x1,%eax
  802239:	eb 05                	jmp    802240 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80223b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	ff 75 08             	pushl  0x8(%ebp)
  802250:	6a 26                	push   $0x26
  802252:	e8 cd fa ff ff       	call   801d24 <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
	return ;
  80225a:	90                   	nop
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802261:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802264:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802267:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	6a 00                	push   $0x0
  80226f:	53                   	push   %ebx
  802270:	51                   	push   %ecx
  802271:	52                   	push   %edx
  802272:	50                   	push   %eax
  802273:	6a 27                	push   $0x27
  802275:	e8 aa fa ff ff       	call   801d24 <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
}
  80227d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802285:	8b 55 0c             	mov    0xc(%ebp),%edx
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	52                   	push   %edx
  802292:	50                   	push   %eax
  802293:	6a 28                	push   $0x28
  802295:	e8 8a fa ff ff       	call   801d24 <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8022a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	6a 00                	push   $0x0
  8022ad:	51                   	push   %ecx
  8022ae:	ff 75 10             	pushl  0x10(%ebp)
  8022b1:	52                   	push   %edx
  8022b2:	50                   	push   %eax
  8022b3:	6a 29                	push   $0x29
  8022b5:	e8 6a fa ff ff       	call   801d24 <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	ff 75 10             	pushl  0x10(%ebp)
  8022c9:	ff 75 0c             	pushl  0xc(%ebp)
  8022cc:	ff 75 08             	pushl  0x8(%ebp)
  8022cf:	6a 12                	push   $0x12
  8022d1:	e8 4e fa ff ff       	call   801d24 <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d9:	90                   	nop
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8022df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	52                   	push   %edx
  8022ec:	50                   	push   %eax
  8022ed:	6a 2a                	push   $0x2a
  8022ef:	e8 30 fa ff ff       	call   801d24 <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
	return;
  8022f7:	90                   	nop
}
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	50                   	push   %eax
  802309:	6a 2b                	push   $0x2b
  80230b:	e8 14 fa ff ff       	call   801d24 <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	ff 75 0c             	pushl  0xc(%ebp)
  802321:	ff 75 08             	pushl  0x8(%ebp)
  802324:	6a 2c                	push   $0x2c
  802326:	e8 f9 f9 ff ff       	call   801d24 <syscall>
  80232b:	83 c4 18             	add    $0x18,%esp
	return;
  80232e:	90                   	nop
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	ff 75 0c             	pushl  0xc(%ebp)
  80233d:	ff 75 08             	pushl  0x8(%ebp)
  802340:	6a 2d                	push   $0x2d
  802342:	e8 dd f9 ff ff       	call   801d24 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
	return;
  80234a:	90                   	nop
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
  802350:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	83 e8 04             	sub    $0x4,%eax
  802359:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80235c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80235f:	8b 00                	mov    (%eax),%eax
  802361:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
  802369:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	83 e8 04             	sub    $0x4,%eax
  802372:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802375:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802378:	8b 00                	mov    (%eax),%eax
  80237a:	83 e0 01             	and    $0x1,%eax
  80237d:	85 c0                	test   %eax,%eax
  80237f:	0f 94 c0             	sete   %al
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80238a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802391:	8b 45 0c             	mov    0xc(%ebp),%eax
  802394:	83 f8 02             	cmp    $0x2,%eax
  802397:	74 2b                	je     8023c4 <alloc_block+0x40>
  802399:	83 f8 02             	cmp    $0x2,%eax
  80239c:	7f 07                	jg     8023a5 <alloc_block+0x21>
  80239e:	83 f8 01             	cmp    $0x1,%eax
  8023a1:	74 0e                	je     8023b1 <alloc_block+0x2d>
  8023a3:	eb 58                	jmp    8023fd <alloc_block+0x79>
  8023a5:	83 f8 03             	cmp    $0x3,%eax
  8023a8:	74 2d                	je     8023d7 <alloc_block+0x53>
  8023aa:	83 f8 04             	cmp    $0x4,%eax
  8023ad:	74 3b                	je     8023ea <alloc_block+0x66>
  8023af:	eb 4c                	jmp    8023fd <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8023b1:	83 ec 0c             	sub    $0xc,%esp
  8023b4:	ff 75 08             	pushl  0x8(%ebp)
  8023b7:	e8 11 03 00 00       	call   8026cd <alloc_block_FF>
  8023bc:	83 c4 10             	add    $0x10,%esp
  8023bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023c2:	eb 4a                	jmp    80240e <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8023c4:	83 ec 0c             	sub    $0xc,%esp
  8023c7:	ff 75 08             	pushl  0x8(%ebp)
  8023ca:	e8 fa 19 00 00       	call   803dc9 <alloc_block_NF>
  8023cf:	83 c4 10             	add    $0x10,%esp
  8023d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023d5:	eb 37                	jmp    80240e <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8023d7:	83 ec 0c             	sub    $0xc,%esp
  8023da:	ff 75 08             	pushl  0x8(%ebp)
  8023dd:	e8 a7 07 00 00       	call   802b89 <alloc_block_BF>
  8023e2:	83 c4 10             	add    $0x10,%esp
  8023e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023e8:	eb 24                	jmp    80240e <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8023ea:	83 ec 0c             	sub    $0xc,%esp
  8023ed:	ff 75 08             	pushl  0x8(%ebp)
  8023f0:	e8 b7 19 00 00       	call   803dac <alloc_block_WF>
  8023f5:	83 c4 10             	add    $0x10,%esp
  8023f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023fb:	eb 11                	jmp    80240e <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8023fd:	83 ec 0c             	sub    $0xc,%esp
  802400:	68 f0 4a 80 00       	push   $0x804af0
  802405:	e8 a8 e6 ff ff       	call   800ab2 <cprintf>
  80240a:	83 c4 10             	add    $0x10,%esp
		break;
  80240d:	90                   	nop
	}
	return va;
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	53                   	push   %ebx
  802417:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80241a:	83 ec 0c             	sub    $0xc,%esp
  80241d:	68 10 4b 80 00       	push   $0x804b10
  802422:	e8 8b e6 ff ff       	call   800ab2 <cprintf>
  802427:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80242a:	83 ec 0c             	sub    $0xc,%esp
  80242d:	68 3b 4b 80 00       	push   $0x804b3b
  802432:	e8 7b e6 ff ff       	call   800ab2 <cprintf>
  802437:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802440:	eb 37                	jmp    802479 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802442:	83 ec 0c             	sub    $0xc,%esp
  802445:	ff 75 f4             	pushl  -0xc(%ebp)
  802448:	e8 19 ff ff ff       	call   802366 <is_free_block>
  80244d:	83 c4 10             	add    $0x10,%esp
  802450:	0f be d8             	movsbl %al,%ebx
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	ff 75 f4             	pushl  -0xc(%ebp)
  802459:	e8 ef fe ff ff       	call   80234d <get_block_size>
  80245e:	83 c4 10             	add    $0x10,%esp
  802461:	83 ec 04             	sub    $0x4,%esp
  802464:	53                   	push   %ebx
  802465:	50                   	push   %eax
  802466:	68 53 4b 80 00       	push   $0x804b53
  80246b:	e8 42 e6 ff ff       	call   800ab2 <cprintf>
  802470:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802473:	8b 45 10             	mov    0x10(%ebp),%eax
  802476:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802479:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247d:	74 07                	je     802486 <print_blocks_list+0x73>
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 00                	mov    (%eax),%eax
  802484:	eb 05                	jmp    80248b <print_blocks_list+0x78>
  802486:	b8 00 00 00 00       	mov    $0x0,%eax
  80248b:	89 45 10             	mov    %eax,0x10(%ebp)
  80248e:	8b 45 10             	mov    0x10(%ebp),%eax
  802491:	85 c0                	test   %eax,%eax
  802493:	75 ad                	jne    802442 <print_blocks_list+0x2f>
  802495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802499:	75 a7                	jne    802442 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80249b:	83 ec 0c             	sub    $0xc,%esp
  80249e:	68 10 4b 80 00       	push   $0x804b10
  8024a3:	e8 0a e6 ff ff       	call   800ab2 <cprintf>
  8024a8:	83 c4 10             	add    $0x10,%esp

}
  8024ab:	90                   	nop
  8024ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8024b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ba:	83 e0 01             	and    $0x1,%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	74 03                	je     8024c4 <initialize_dynamic_allocator+0x13>
  8024c1:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8024c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024c8:	0f 84 c7 01 00 00    	je     802695 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8024ce:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8024d5:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8024d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024de:	01 d0                	add    %edx,%eax
  8024e0:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8024e5:	0f 87 ad 01 00 00    	ja     802698 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	0f 89 a5 01 00 00    	jns    80269b <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8024f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fc:	01 d0                	add    %edx,%eax
  8024fe:	83 e8 04             	sub    $0x4,%eax
  802501:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802506:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80250d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802515:	e9 87 00 00 00       	jmp    8025a1 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80251a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251e:	75 14                	jne    802534 <initialize_dynamic_allocator+0x83>
  802520:	83 ec 04             	sub    $0x4,%esp
  802523:	68 6b 4b 80 00       	push   $0x804b6b
  802528:	6a 79                	push   $0x79
  80252a:	68 89 4b 80 00       	push   $0x804b89
  80252f:	e8 c1 e2 ff ff       	call   8007f5 <_panic>
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 00                	mov    (%eax),%eax
  802539:	85 c0                	test   %eax,%eax
  80253b:	74 10                	je     80254d <initialize_dynamic_allocator+0x9c>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802545:	8b 52 04             	mov    0x4(%edx),%edx
  802548:	89 50 04             	mov    %edx,0x4(%eax)
  80254b:	eb 0b                	jmp    802558 <initialize_dynamic_allocator+0xa7>
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 40 04             	mov    0x4(%eax),%eax
  802553:	a3 30 50 80 00       	mov    %eax,0x805030
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 40 04             	mov    0x4(%eax),%eax
  80255e:	85 c0                	test   %eax,%eax
  802560:	74 0f                	je     802571 <initialize_dynamic_allocator+0xc0>
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 40 04             	mov    0x4(%eax),%eax
  802568:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256b:	8b 12                	mov    (%edx),%edx
  80256d:	89 10                	mov    %edx,(%eax)
  80256f:	eb 0a                	jmp    80257b <initialize_dynamic_allocator+0xca>
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 00                	mov    (%eax),%eax
  802576:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80258e:	a1 38 50 80 00       	mov    0x805038,%eax
  802593:	48                   	dec    %eax
  802594:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802599:	a1 34 50 80 00       	mov    0x805034,%eax
  80259e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a5:	74 07                	je     8025ae <initialize_dynamic_allocator+0xfd>
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	eb 05                	jmp    8025b3 <initialize_dynamic_allocator+0x102>
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b3:	a3 34 50 80 00       	mov    %eax,0x805034
  8025b8:	a1 34 50 80 00       	mov    0x805034,%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	0f 85 55 ff ff ff    	jne    80251a <initialize_dynamic_allocator+0x69>
  8025c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c9:	0f 85 4b ff ff ff    	jne    80251a <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8025cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8025d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8025de:	a1 44 50 80 00       	mov    0x805044,%eax
  8025e3:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8025e8:	a1 40 50 80 00       	mov    0x805040,%eax
  8025ed:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	83 c0 08             	add    $0x8,%eax
  8025f9:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8025fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ff:	83 c0 04             	add    $0x4,%eax
  802602:	8b 55 0c             	mov    0xc(%ebp),%edx
  802605:	83 ea 08             	sub    $0x8,%edx
  802608:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80260a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	01 d0                	add    %edx,%eax
  802612:	83 e8 08             	sub    $0x8,%eax
  802615:	8b 55 0c             	mov    0xc(%ebp),%edx
  802618:	83 ea 08             	sub    $0x8,%edx
  80261b:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80261d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802629:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802630:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802634:	75 17                	jne    80264d <initialize_dynamic_allocator+0x19c>
  802636:	83 ec 04             	sub    $0x4,%esp
  802639:	68 a4 4b 80 00       	push   $0x804ba4
  80263e:	68 90 00 00 00       	push   $0x90
  802643:	68 89 4b 80 00       	push   $0x804b89
  802648:	e8 a8 e1 ff ff       	call   8007f5 <_panic>
  80264d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802653:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802656:	89 10                	mov    %edx,(%eax)
  802658:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265b:	8b 00                	mov    (%eax),%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 0d                	je     80266e <initialize_dynamic_allocator+0x1bd>
  802661:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802666:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802669:	89 50 04             	mov    %edx,0x4(%eax)
  80266c:	eb 08                	jmp    802676 <initialize_dynamic_allocator+0x1c5>
  80266e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802671:	a3 30 50 80 00       	mov    %eax,0x805030
  802676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802679:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80267e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802681:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802688:	a1 38 50 80 00       	mov    0x805038,%eax
  80268d:	40                   	inc    %eax
  80268e:	a3 38 50 80 00       	mov    %eax,0x805038
  802693:	eb 07                	jmp    80269c <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802695:	90                   	nop
  802696:	eb 04                	jmp    80269c <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802698:	90                   	nop
  802699:	eb 01                	jmp    80269c <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80269b:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8026a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8026a4:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b0:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8026b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b5:	83 e8 04             	sub    $0x4,%eax
  8026b8:	8b 00                	mov    (%eax),%eax
  8026ba:	83 e0 fe             	and    $0xfffffffe,%eax
  8026bd:	8d 50 f8             	lea    -0x8(%eax),%edx
  8026c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c3:	01 c2                	add    %eax,%edx
  8026c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c8:	89 02                	mov    %eax,(%edx)
}
  8026ca:	90                   	nop
  8026cb:	5d                   	pop    %ebp
  8026cc:	c3                   	ret    

008026cd <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
  8026d0:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	83 e0 01             	and    $0x1,%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	74 03                	je     8026e0 <alloc_block_FF+0x13>
  8026dd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026e0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026e4:	77 07                	ja     8026ed <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026e6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026ed:	a1 24 50 80 00       	mov    0x805024,%eax
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	75 73                	jne    802769 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f9:	83 c0 10             	add    $0x10,%eax
  8026fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026ff:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802706:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802709:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270c:	01 d0                	add    %edx,%eax
  80270e:	48                   	dec    %eax
  80270f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802712:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802715:	ba 00 00 00 00       	mov    $0x0,%edx
  80271a:	f7 75 ec             	divl   -0x14(%ebp)
  80271d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802720:	29 d0                	sub    %edx,%eax
  802722:	c1 e8 0c             	shr    $0xc,%eax
  802725:	83 ec 0c             	sub    $0xc,%esp
  802728:	50                   	push   %eax
  802729:	e8 1e f1 ff ff       	call   80184c <sbrk>
  80272e:	83 c4 10             	add    $0x10,%esp
  802731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802734:	83 ec 0c             	sub    $0xc,%esp
  802737:	6a 00                	push   $0x0
  802739:	e8 0e f1 ff ff       	call   80184c <sbrk>
  80273e:	83 c4 10             	add    $0x10,%esp
  802741:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802744:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802747:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80274a:	83 ec 08             	sub    $0x8,%esp
  80274d:	50                   	push   %eax
  80274e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802751:	e8 5b fd ff ff       	call   8024b1 <initialize_dynamic_allocator>
  802756:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802759:	83 ec 0c             	sub    $0xc,%esp
  80275c:	68 c7 4b 80 00       	push   $0x804bc7
  802761:	e8 4c e3 ff ff       	call   800ab2 <cprintf>
  802766:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802769:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80276d:	75 0a                	jne    802779 <alloc_block_FF+0xac>
	        return NULL;
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
  802774:	e9 0e 04 00 00       	jmp    802b87 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802780:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802785:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802788:	e9 f3 02 00 00       	jmp    802a80 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802793:	83 ec 0c             	sub    $0xc,%esp
  802796:	ff 75 bc             	pushl  -0x44(%ebp)
  802799:	e8 af fb ff ff       	call   80234d <get_block_size>
  80279e:	83 c4 10             	add    $0x10,%esp
  8027a1:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	83 c0 08             	add    $0x8,%eax
  8027aa:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8027ad:	0f 87 c5 02 00 00    	ja     802a78 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b6:	83 c0 18             	add    $0x18,%eax
  8027b9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8027bc:	0f 87 19 02 00 00    	ja     8029db <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8027c2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c8:	83 e8 08             	sub    $0x8,%eax
  8027cb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8027ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d1:	8d 50 08             	lea    0x8(%eax),%edx
  8027d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027d7:	01 d0                	add    %edx,%eax
  8027d9:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	83 c0 08             	add    $0x8,%eax
  8027e2:	83 ec 04             	sub    $0x4,%esp
  8027e5:	6a 01                	push   $0x1
  8027e7:	50                   	push   %eax
  8027e8:	ff 75 bc             	pushl  -0x44(%ebp)
  8027eb:	e8 ae fe ff ff       	call   80269e <set_block_data>
  8027f0:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 04             	mov    0x4(%eax),%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	75 68                	jne    802865 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027fd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802801:	75 17                	jne    80281a <alloc_block_FF+0x14d>
  802803:	83 ec 04             	sub    $0x4,%esp
  802806:	68 a4 4b 80 00       	push   $0x804ba4
  80280b:	68 d7 00 00 00       	push   $0xd7
  802810:	68 89 4b 80 00       	push   $0x804b89
  802815:	e8 db df ff ff       	call   8007f5 <_panic>
  80281a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802820:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802823:	89 10                	mov    %edx,(%eax)
  802825:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802828:	8b 00                	mov    (%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	74 0d                	je     80283b <alloc_block_FF+0x16e>
  80282e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802833:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802836:	89 50 04             	mov    %edx,0x4(%eax)
  802839:	eb 08                	jmp    802843 <alloc_block_FF+0x176>
  80283b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80283e:	a3 30 50 80 00       	mov    %eax,0x805030
  802843:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802846:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80284b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80284e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802855:	a1 38 50 80 00       	mov    0x805038,%eax
  80285a:	40                   	inc    %eax
  80285b:	a3 38 50 80 00       	mov    %eax,0x805038
  802860:	e9 dc 00 00 00       	jmp    802941 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	85 c0                	test   %eax,%eax
  80286c:	75 65                	jne    8028d3 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80286e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802872:	75 17                	jne    80288b <alloc_block_FF+0x1be>
  802874:	83 ec 04             	sub    $0x4,%esp
  802877:	68 d8 4b 80 00       	push   $0x804bd8
  80287c:	68 db 00 00 00       	push   $0xdb
  802881:	68 89 4b 80 00       	push   $0x804b89
  802886:	e8 6a df ff ff       	call   8007f5 <_panic>
  80288b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802891:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802894:	89 50 04             	mov    %edx,0x4(%eax)
  802897:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80289a:	8b 40 04             	mov    0x4(%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	74 0c                	je     8028ad <alloc_block_FF+0x1e0>
  8028a1:	a1 30 50 80 00       	mov    0x805030,%eax
  8028a6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028a9:	89 10                	mov    %edx,(%eax)
  8028ab:	eb 08                	jmp    8028b5 <alloc_block_FF+0x1e8>
  8028ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8028bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c6:	a1 38 50 80 00       	mov    0x805038,%eax
  8028cb:	40                   	inc    %eax
  8028cc:	a3 38 50 80 00       	mov    %eax,0x805038
  8028d1:	eb 6e                	jmp    802941 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8028d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d7:	74 06                	je     8028df <alloc_block_FF+0x212>
  8028d9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028dd:	75 17                	jne    8028f6 <alloc_block_FF+0x229>
  8028df:	83 ec 04             	sub    $0x4,%esp
  8028e2:	68 fc 4b 80 00       	push   $0x804bfc
  8028e7:	68 df 00 00 00       	push   $0xdf
  8028ec:	68 89 4b 80 00       	push   $0x804b89
  8028f1:	e8 ff de ff ff       	call   8007f5 <_panic>
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 10                	mov    (%eax),%edx
  8028fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028fe:	89 10                	mov    %edx,(%eax)
  802900:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	85 c0                	test   %eax,%eax
  802907:	74 0b                	je     802914 <alloc_block_FF+0x247>
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 00                	mov    (%eax),%eax
  80290e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802911:	89 50 04             	mov    %edx,0x4(%eax)
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80291a:	89 10                	mov    %edx,(%eax)
  80291c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80291f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802922:	89 50 04             	mov    %edx,0x4(%eax)
  802925:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	75 08                	jne    802936 <alloc_block_FF+0x269>
  80292e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802931:	a3 30 50 80 00       	mov    %eax,0x805030
  802936:	a1 38 50 80 00       	mov    0x805038,%eax
  80293b:	40                   	inc    %eax
  80293c:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802941:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802945:	75 17                	jne    80295e <alloc_block_FF+0x291>
  802947:	83 ec 04             	sub    $0x4,%esp
  80294a:	68 6b 4b 80 00       	push   $0x804b6b
  80294f:	68 e1 00 00 00       	push   $0xe1
  802954:	68 89 4b 80 00       	push   $0x804b89
  802959:	e8 97 de ff ff       	call   8007f5 <_panic>
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	85 c0                	test   %eax,%eax
  802965:	74 10                	je     802977 <alloc_block_FF+0x2aa>
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 00                	mov    (%eax),%eax
  80296c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296f:	8b 52 04             	mov    0x4(%edx),%edx
  802972:	89 50 04             	mov    %edx,0x4(%eax)
  802975:	eb 0b                	jmp    802982 <alloc_block_FF+0x2b5>
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 40 04             	mov    0x4(%eax),%eax
  80297d:	a3 30 50 80 00       	mov    %eax,0x805030
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 40 04             	mov    0x4(%eax),%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	74 0f                	je     80299b <alloc_block_FF+0x2ce>
  80298c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298f:	8b 40 04             	mov    0x4(%eax),%eax
  802992:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802995:	8b 12                	mov    (%edx),%edx
  802997:	89 10                	mov    %edx,(%eax)
  802999:	eb 0a                	jmp    8029a5 <alloc_block_FF+0x2d8>
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	8b 00                	mov    (%eax),%eax
  8029a0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029bd:	48                   	dec    %eax
  8029be:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8029c3:	83 ec 04             	sub    $0x4,%esp
  8029c6:	6a 00                	push   $0x0
  8029c8:	ff 75 b4             	pushl  -0x4c(%ebp)
  8029cb:	ff 75 b0             	pushl  -0x50(%ebp)
  8029ce:	e8 cb fc ff ff       	call   80269e <set_block_data>
  8029d3:	83 c4 10             	add    $0x10,%esp
  8029d6:	e9 95 00 00 00       	jmp    802a70 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8029db:	83 ec 04             	sub    $0x4,%esp
  8029de:	6a 01                	push   $0x1
  8029e0:	ff 75 b8             	pushl  -0x48(%ebp)
  8029e3:	ff 75 bc             	pushl  -0x44(%ebp)
  8029e6:	e8 b3 fc ff ff       	call   80269e <set_block_data>
  8029eb:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8029ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f2:	75 17                	jne    802a0b <alloc_block_FF+0x33e>
  8029f4:	83 ec 04             	sub    $0x4,%esp
  8029f7:	68 6b 4b 80 00       	push   $0x804b6b
  8029fc:	68 e8 00 00 00       	push   $0xe8
  802a01:	68 89 4b 80 00       	push   $0x804b89
  802a06:	e8 ea dd ff ff       	call   8007f5 <_panic>
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	74 10                	je     802a24 <alloc_block_FF+0x357>
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1c:	8b 52 04             	mov    0x4(%edx),%edx
  802a1f:	89 50 04             	mov    %edx,0x4(%eax)
  802a22:	eb 0b                	jmp    802a2f <alloc_block_FF+0x362>
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 40 04             	mov    0x4(%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 0f                	je     802a48 <alloc_block_FF+0x37b>
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a42:	8b 12                	mov    (%edx),%edx
  802a44:	89 10                	mov    %edx,(%eax)
  802a46:	eb 0a                	jmp    802a52 <alloc_block_FF+0x385>
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a65:	a1 38 50 80 00       	mov    0x805038,%eax
  802a6a:	48                   	dec    %eax
  802a6b:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802a70:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a73:	e9 0f 01 00 00       	jmp    802b87 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a78:	a1 34 50 80 00       	mov    0x805034,%eax
  802a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a84:	74 07                	je     802a8d <alloc_block_FF+0x3c0>
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	eb 05                	jmp    802a92 <alloc_block_FF+0x3c5>
  802a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a92:	a3 34 50 80 00       	mov    %eax,0x805034
  802a97:	a1 34 50 80 00       	mov    0x805034,%eax
  802a9c:	85 c0                	test   %eax,%eax
  802a9e:	0f 85 e9 fc ff ff    	jne    80278d <alloc_block_FF+0xc0>
  802aa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa8:	0f 85 df fc ff ff    	jne    80278d <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802aae:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab1:	83 c0 08             	add    $0x8,%eax
  802ab4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ab7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802abe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ac1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ac4:	01 d0                	add    %edx,%eax
  802ac6:	48                   	dec    %eax
  802ac7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802aca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802acd:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad2:	f7 75 d8             	divl   -0x28(%ebp)
  802ad5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ad8:	29 d0                	sub    %edx,%eax
  802ada:	c1 e8 0c             	shr    $0xc,%eax
  802add:	83 ec 0c             	sub    $0xc,%esp
  802ae0:	50                   	push   %eax
  802ae1:	e8 66 ed ff ff       	call   80184c <sbrk>
  802ae6:	83 c4 10             	add    $0x10,%esp
  802ae9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802aec:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802af0:	75 0a                	jne    802afc <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802af2:	b8 00 00 00 00       	mov    $0x0,%eax
  802af7:	e9 8b 00 00 00       	jmp    802b87 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802afc:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802b03:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b09:	01 d0                	add    %edx,%eax
  802b0b:	48                   	dec    %eax
  802b0c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802b0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b12:	ba 00 00 00 00       	mov    $0x0,%edx
  802b17:	f7 75 cc             	divl   -0x34(%ebp)
  802b1a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b1d:	29 d0                	sub    %edx,%eax
  802b1f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b22:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b25:	01 d0                	add    %edx,%eax
  802b27:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802b2c:	a1 40 50 80 00       	mov    0x805040,%eax
  802b31:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b37:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b41:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b44:	01 d0                	add    %edx,%eax
  802b46:	48                   	dec    %eax
  802b47:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b4a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  802b52:	f7 75 c4             	divl   -0x3c(%ebp)
  802b55:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b58:	29 d0                	sub    %edx,%eax
  802b5a:	83 ec 04             	sub    $0x4,%esp
  802b5d:	6a 01                	push   $0x1
  802b5f:	50                   	push   %eax
  802b60:	ff 75 d0             	pushl  -0x30(%ebp)
  802b63:	e8 36 fb ff ff       	call   80269e <set_block_data>
  802b68:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802b6b:	83 ec 0c             	sub    $0xc,%esp
  802b6e:	ff 75 d0             	pushl  -0x30(%ebp)
  802b71:	e8 1b 0a 00 00       	call   803591 <free_block>
  802b76:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802b79:	83 ec 0c             	sub    $0xc,%esp
  802b7c:	ff 75 08             	pushl  0x8(%ebp)
  802b7f:	e8 49 fb ff ff       	call   8026cd <alloc_block_FF>
  802b84:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802b87:	c9                   	leave  
  802b88:	c3                   	ret    

00802b89 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802b89:	55                   	push   %ebp
  802b8a:	89 e5                	mov    %esp,%ebp
  802b8c:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	83 e0 01             	and    $0x1,%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	74 03                	je     802b9c <alloc_block_BF+0x13>
  802b99:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b9c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ba0:	77 07                	ja     802ba9 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ba2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ba9:	a1 24 50 80 00       	mov    0x805024,%eax
  802bae:	85 c0                	test   %eax,%eax
  802bb0:	75 73                	jne    802c25 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	83 c0 10             	add    $0x10,%eax
  802bb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802bbb:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802bc2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc8:	01 d0                	add    %edx,%eax
  802bca:	48                   	dec    %eax
  802bcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bd1:	ba 00 00 00 00       	mov    $0x0,%edx
  802bd6:	f7 75 e0             	divl   -0x20(%ebp)
  802bd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bdc:	29 d0                	sub    %edx,%eax
  802bde:	c1 e8 0c             	shr    $0xc,%eax
  802be1:	83 ec 0c             	sub    $0xc,%esp
  802be4:	50                   	push   %eax
  802be5:	e8 62 ec ff ff       	call   80184c <sbrk>
  802bea:	83 c4 10             	add    $0x10,%esp
  802bed:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802bf0:	83 ec 0c             	sub    $0xc,%esp
  802bf3:	6a 00                	push   $0x0
  802bf5:	e8 52 ec ff ff       	call   80184c <sbrk>
  802bfa:	83 c4 10             	add    $0x10,%esp
  802bfd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c03:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802c06:	83 ec 08             	sub    $0x8,%esp
  802c09:	50                   	push   %eax
  802c0a:	ff 75 d8             	pushl  -0x28(%ebp)
  802c0d:	e8 9f f8 ff ff       	call   8024b1 <initialize_dynamic_allocator>
  802c12:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c15:	83 ec 0c             	sub    $0xc,%esp
  802c18:	68 c7 4b 80 00       	push   $0x804bc7
  802c1d:	e8 90 de ff ff       	call   800ab2 <cprintf>
  802c22:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802c25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802c2c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802c33:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802c3a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802c41:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c49:	e9 1d 01 00 00       	jmp    802d6b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802c54:	83 ec 0c             	sub    $0xc,%esp
  802c57:	ff 75 a8             	pushl  -0x58(%ebp)
  802c5a:	e8 ee f6 ff ff       	call   80234d <get_block_size>
  802c5f:	83 c4 10             	add    $0x10,%esp
  802c62:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	83 c0 08             	add    $0x8,%eax
  802c6b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c6e:	0f 87 ef 00 00 00    	ja     802d63 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	83 c0 18             	add    $0x18,%eax
  802c7a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c7d:	77 1d                	ja     802c9c <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c82:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c85:	0f 86 d8 00 00 00    	jbe    802d63 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802c8b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802c91:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802c94:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c97:	e9 c7 00 00 00       	jmp    802d63 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	83 c0 08             	add    $0x8,%eax
  802ca2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ca5:	0f 85 9d 00 00 00    	jne    802d48 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802cab:	83 ec 04             	sub    $0x4,%esp
  802cae:	6a 01                	push   $0x1
  802cb0:	ff 75 a4             	pushl  -0x5c(%ebp)
  802cb3:	ff 75 a8             	pushl  -0x58(%ebp)
  802cb6:	e8 e3 f9 ff ff       	call   80269e <set_block_data>
  802cbb:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802cbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc2:	75 17                	jne    802cdb <alloc_block_BF+0x152>
  802cc4:	83 ec 04             	sub    $0x4,%esp
  802cc7:	68 6b 4b 80 00       	push   $0x804b6b
  802ccc:	68 2c 01 00 00       	push   $0x12c
  802cd1:	68 89 4b 80 00       	push   $0x804b89
  802cd6:	e8 1a db ff ff       	call   8007f5 <_panic>
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 10                	je     802cf4 <alloc_block_BF+0x16b>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cec:	8b 52 04             	mov    0x4(%edx),%edx
  802cef:	89 50 04             	mov    %edx,0x4(%eax)
  802cf2:	eb 0b                	jmp    802cff <alloc_block_BF+0x176>
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	8b 40 04             	mov    0x4(%eax),%eax
  802cfa:	a3 30 50 80 00       	mov    %eax,0x805030
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 40 04             	mov    0x4(%eax),%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	74 0f                	je     802d18 <alloc_block_BF+0x18f>
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d12:	8b 12                	mov    (%edx),%edx
  802d14:	89 10                	mov    %edx,(%eax)
  802d16:	eb 0a                	jmp    802d22 <alloc_block_BF+0x199>
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	8b 00                	mov    (%eax),%eax
  802d1d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d35:	a1 38 50 80 00       	mov    0x805038,%eax
  802d3a:	48                   	dec    %eax
  802d3b:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802d40:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d43:	e9 24 04 00 00       	jmp    80316c <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d4e:	76 13                	jbe    802d63 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802d50:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802d57:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802d5d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d60:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802d63:	a1 34 50 80 00       	mov    0x805034,%eax
  802d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6f:	74 07                	je     802d78 <alloc_block_BF+0x1ef>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 00                	mov    (%eax),%eax
  802d76:	eb 05                	jmp    802d7d <alloc_block_BF+0x1f4>
  802d78:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7d:	a3 34 50 80 00       	mov    %eax,0x805034
  802d82:	a1 34 50 80 00       	mov    0x805034,%eax
  802d87:	85 c0                	test   %eax,%eax
  802d89:	0f 85 bf fe ff ff    	jne    802c4e <alloc_block_BF+0xc5>
  802d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d93:	0f 85 b5 fe ff ff    	jne    802c4e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802d99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9d:	0f 84 26 02 00 00    	je     802fc9 <alloc_block_BF+0x440>
  802da3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802da7:	0f 85 1c 02 00 00    	jne    802fc9 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db0:	2b 45 08             	sub    0x8(%ebp),%eax
  802db3:	83 e8 08             	sub    $0x8,%eax
  802db6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	8d 50 08             	lea    0x8(%eax),%edx
  802dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc2:	01 d0                	add    %edx,%eax
  802dc4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	83 c0 08             	add    $0x8,%eax
  802dcd:	83 ec 04             	sub    $0x4,%esp
  802dd0:	6a 01                	push   $0x1
  802dd2:	50                   	push   %eax
  802dd3:	ff 75 f0             	pushl  -0x10(%ebp)
  802dd6:	e8 c3 f8 ff ff       	call   80269e <set_block_data>
  802ddb:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	8b 40 04             	mov    0x4(%eax),%eax
  802de4:	85 c0                	test   %eax,%eax
  802de6:	75 68                	jne    802e50 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802de8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802dec:	75 17                	jne    802e05 <alloc_block_BF+0x27c>
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	68 a4 4b 80 00       	push   $0x804ba4
  802df6:	68 45 01 00 00       	push   $0x145
  802dfb:	68 89 4b 80 00       	push   $0x804b89
  802e00:	e8 f0 d9 ff ff       	call   8007f5 <_panic>
  802e05:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e0e:	89 10                	mov    %edx,(%eax)
  802e10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e13:	8b 00                	mov    (%eax),%eax
  802e15:	85 c0                	test   %eax,%eax
  802e17:	74 0d                	je     802e26 <alloc_block_BF+0x29d>
  802e19:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e1e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e21:	89 50 04             	mov    %edx,0x4(%eax)
  802e24:	eb 08                	jmp    802e2e <alloc_block_BF+0x2a5>
  802e26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e29:	a3 30 50 80 00       	mov    %eax,0x805030
  802e2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e31:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e40:	a1 38 50 80 00       	mov    0x805038,%eax
  802e45:	40                   	inc    %eax
  802e46:	a3 38 50 80 00       	mov    %eax,0x805038
  802e4b:	e9 dc 00 00 00       	jmp    802f2c <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e53:	8b 00                	mov    (%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	75 65                	jne    802ebe <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e59:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e5d:	75 17                	jne    802e76 <alloc_block_BF+0x2ed>
  802e5f:	83 ec 04             	sub    $0x4,%esp
  802e62:	68 d8 4b 80 00       	push   $0x804bd8
  802e67:	68 4a 01 00 00       	push   $0x14a
  802e6c:	68 89 4b 80 00       	push   $0x804b89
  802e71:	e8 7f d9 ff ff       	call   8007f5 <_panic>
  802e76:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e7f:	89 50 04             	mov    %edx,0x4(%eax)
  802e82:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e85:	8b 40 04             	mov    0x4(%eax),%eax
  802e88:	85 c0                	test   %eax,%eax
  802e8a:	74 0c                	je     802e98 <alloc_block_BF+0x30f>
  802e8c:	a1 30 50 80 00       	mov    0x805030,%eax
  802e91:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e94:	89 10                	mov    %edx,(%eax)
  802e96:	eb 08                	jmp    802ea0 <alloc_block_BF+0x317>
  802e98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e9b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ea0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea3:	a3 30 50 80 00       	mov    %eax,0x805030
  802ea8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb1:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb6:	40                   	inc    %eax
  802eb7:	a3 38 50 80 00       	mov    %eax,0x805038
  802ebc:	eb 6e                	jmp    802f2c <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ebe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec2:	74 06                	je     802eca <alloc_block_BF+0x341>
  802ec4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ec8:	75 17                	jne    802ee1 <alloc_block_BF+0x358>
  802eca:	83 ec 04             	sub    $0x4,%esp
  802ecd:	68 fc 4b 80 00       	push   $0x804bfc
  802ed2:	68 4f 01 00 00       	push   $0x14f
  802ed7:	68 89 4b 80 00       	push   $0x804b89
  802edc:	e8 14 d9 ff ff       	call   8007f5 <_panic>
  802ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee4:	8b 10                	mov    (%eax),%edx
  802ee6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee9:	89 10                	mov    %edx,(%eax)
  802eeb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eee:	8b 00                	mov    (%eax),%eax
  802ef0:	85 c0                	test   %eax,%eax
  802ef2:	74 0b                	je     802eff <alloc_block_BF+0x376>
  802ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef7:	8b 00                	mov    (%eax),%eax
  802ef9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802efc:	89 50 04             	mov    %edx,0x4(%eax)
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f05:	89 10                	mov    %edx,(%eax)
  802f07:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0d:	89 50 04             	mov    %edx,0x4(%eax)
  802f10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f13:	8b 00                	mov    (%eax),%eax
  802f15:	85 c0                	test   %eax,%eax
  802f17:	75 08                	jne    802f21 <alloc_block_BF+0x398>
  802f19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f1c:	a3 30 50 80 00       	mov    %eax,0x805030
  802f21:	a1 38 50 80 00       	mov    0x805038,%eax
  802f26:	40                   	inc    %eax
  802f27:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802f2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f30:	75 17                	jne    802f49 <alloc_block_BF+0x3c0>
  802f32:	83 ec 04             	sub    $0x4,%esp
  802f35:	68 6b 4b 80 00       	push   $0x804b6b
  802f3a:	68 51 01 00 00       	push   $0x151
  802f3f:	68 89 4b 80 00       	push   $0x804b89
  802f44:	e8 ac d8 ff ff       	call   8007f5 <_panic>
  802f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	85 c0                	test   %eax,%eax
  802f50:	74 10                	je     802f62 <alloc_block_BF+0x3d9>
  802f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5a:	8b 52 04             	mov    0x4(%edx),%edx
  802f5d:	89 50 04             	mov    %edx,0x4(%eax)
  802f60:	eb 0b                	jmp    802f6d <alloc_block_BF+0x3e4>
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	8b 40 04             	mov    0x4(%eax),%eax
  802f68:	a3 30 50 80 00       	mov    %eax,0x805030
  802f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f70:	8b 40 04             	mov    0x4(%eax),%eax
  802f73:	85 c0                	test   %eax,%eax
  802f75:	74 0f                	je     802f86 <alloc_block_BF+0x3fd>
  802f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7a:	8b 40 04             	mov    0x4(%eax),%eax
  802f7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f80:	8b 12                	mov    (%edx),%edx
  802f82:	89 10                	mov    %edx,(%eax)
  802f84:	eb 0a                	jmp    802f90 <alloc_block_BF+0x407>
  802f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa3:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa8:	48                   	dec    %eax
  802fa9:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802fae:	83 ec 04             	sub    $0x4,%esp
  802fb1:	6a 00                	push   $0x0
  802fb3:	ff 75 d0             	pushl  -0x30(%ebp)
  802fb6:	ff 75 cc             	pushl  -0x34(%ebp)
  802fb9:	e8 e0 f6 ff ff       	call   80269e <set_block_data>
  802fbe:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc4:	e9 a3 01 00 00       	jmp    80316c <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802fc9:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802fcd:	0f 85 9d 00 00 00    	jne    803070 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	6a 01                	push   $0x1
  802fd8:	ff 75 ec             	pushl  -0x14(%ebp)
  802fdb:	ff 75 f0             	pushl  -0x10(%ebp)
  802fde:	e8 bb f6 ff ff       	call   80269e <set_block_data>
  802fe3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802fe6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fea:	75 17                	jne    803003 <alloc_block_BF+0x47a>
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	68 6b 4b 80 00       	push   $0x804b6b
  802ff4:	68 58 01 00 00       	push   $0x158
  802ff9:	68 89 4b 80 00       	push   $0x804b89
  802ffe:	e8 f2 d7 ff ff       	call   8007f5 <_panic>
  803003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803006:	8b 00                	mov    (%eax),%eax
  803008:	85 c0                	test   %eax,%eax
  80300a:	74 10                	je     80301c <alloc_block_BF+0x493>
  80300c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300f:	8b 00                	mov    (%eax),%eax
  803011:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803014:	8b 52 04             	mov    0x4(%edx),%edx
  803017:	89 50 04             	mov    %edx,0x4(%eax)
  80301a:	eb 0b                	jmp    803027 <alloc_block_BF+0x49e>
  80301c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301f:	8b 40 04             	mov    0x4(%eax),%eax
  803022:	a3 30 50 80 00       	mov    %eax,0x805030
  803027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302a:	8b 40 04             	mov    0x4(%eax),%eax
  80302d:	85 c0                	test   %eax,%eax
  80302f:	74 0f                	je     803040 <alloc_block_BF+0x4b7>
  803031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803034:	8b 40 04             	mov    0x4(%eax),%eax
  803037:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80303a:	8b 12                	mov    (%edx),%edx
  80303c:	89 10                	mov    %edx,(%eax)
  80303e:	eb 0a                	jmp    80304a <alloc_block_BF+0x4c1>
  803040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80304a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803053:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803056:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305d:	a1 38 50 80 00       	mov    0x805038,%eax
  803062:	48                   	dec    %eax
  803063:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  803068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306b:	e9 fc 00 00 00       	jmp    80316c <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	83 c0 08             	add    $0x8,%eax
  803076:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803079:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803080:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803083:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803086:	01 d0                	add    %edx,%eax
  803088:	48                   	dec    %eax
  803089:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80308c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80308f:	ba 00 00 00 00       	mov    $0x0,%edx
  803094:	f7 75 c4             	divl   -0x3c(%ebp)
  803097:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80309a:	29 d0                	sub    %edx,%eax
  80309c:	c1 e8 0c             	shr    $0xc,%eax
  80309f:	83 ec 0c             	sub    $0xc,%esp
  8030a2:	50                   	push   %eax
  8030a3:	e8 a4 e7 ff ff       	call   80184c <sbrk>
  8030a8:	83 c4 10             	add    $0x10,%esp
  8030ab:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8030ae:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8030b2:	75 0a                	jne    8030be <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8030b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b9:	e9 ae 00 00 00       	jmp    80316c <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8030be:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8030c5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8030cb:	01 d0                	add    %edx,%eax
  8030cd:	48                   	dec    %eax
  8030ce:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8030d1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8030d9:	f7 75 b8             	divl   -0x48(%ebp)
  8030dc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030df:	29 d0                	sub    %edx,%eax
  8030e1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8030e4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8030e7:	01 d0                	add    %edx,%eax
  8030e9:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8030ee:	a1 40 50 80 00       	mov    0x805040,%eax
  8030f3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8030f9:	83 ec 0c             	sub    $0xc,%esp
  8030fc:	68 30 4c 80 00       	push   $0x804c30
  803101:	e8 ac d9 ff ff       	call   800ab2 <cprintf>
  803106:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803109:	83 ec 08             	sub    $0x8,%esp
  80310c:	ff 75 bc             	pushl  -0x44(%ebp)
  80310f:	68 35 4c 80 00       	push   $0x804c35
  803114:	e8 99 d9 ff ff       	call   800ab2 <cprintf>
  803119:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80311c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803123:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803126:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803129:	01 d0                	add    %edx,%eax
  80312b:	48                   	dec    %eax
  80312c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80312f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803132:	ba 00 00 00 00       	mov    $0x0,%edx
  803137:	f7 75 b0             	divl   -0x50(%ebp)
  80313a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80313d:	29 d0                	sub    %edx,%eax
  80313f:	83 ec 04             	sub    $0x4,%esp
  803142:	6a 01                	push   $0x1
  803144:	50                   	push   %eax
  803145:	ff 75 bc             	pushl  -0x44(%ebp)
  803148:	e8 51 f5 ff ff       	call   80269e <set_block_data>
  80314d:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803150:	83 ec 0c             	sub    $0xc,%esp
  803153:	ff 75 bc             	pushl  -0x44(%ebp)
  803156:	e8 36 04 00 00       	call   803591 <free_block>
  80315b:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80315e:	83 ec 0c             	sub    $0xc,%esp
  803161:	ff 75 08             	pushl  0x8(%ebp)
  803164:	e8 20 fa ff ff       	call   802b89 <alloc_block_BF>
  803169:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80316c:	c9                   	leave  
  80316d:	c3                   	ret    

0080316e <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80316e:	55                   	push   %ebp
  80316f:	89 e5                	mov    %esp,%ebp
  803171:	53                   	push   %ebx
  803172:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803175:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80317c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803183:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803187:	74 1e                	je     8031a7 <merging+0x39>
  803189:	ff 75 08             	pushl  0x8(%ebp)
  80318c:	e8 bc f1 ff ff       	call   80234d <get_block_size>
  803191:	83 c4 04             	add    $0x4,%esp
  803194:	89 c2                	mov    %eax,%edx
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	01 d0                	add    %edx,%eax
  80319b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80319e:	75 07                	jne    8031a7 <merging+0x39>
		prev_is_free = 1;
  8031a0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8031a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031ab:	74 1e                	je     8031cb <merging+0x5d>
  8031ad:	ff 75 10             	pushl  0x10(%ebp)
  8031b0:	e8 98 f1 ff ff       	call   80234d <get_block_size>
  8031b5:	83 c4 04             	add    $0x4,%esp
  8031b8:	89 c2                	mov    %eax,%edx
  8031ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8031bd:	01 d0                	add    %edx,%eax
  8031bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031c2:	75 07                	jne    8031cb <merging+0x5d>
		next_is_free = 1;
  8031c4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8031cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031cf:	0f 84 cc 00 00 00    	je     8032a1 <merging+0x133>
  8031d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d9:	0f 84 c2 00 00 00    	je     8032a1 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8031df:	ff 75 08             	pushl  0x8(%ebp)
  8031e2:	e8 66 f1 ff ff       	call   80234d <get_block_size>
  8031e7:	83 c4 04             	add    $0x4,%esp
  8031ea:	89 c3                	mov    %eax,%ebx
  8031ec:	ff 75 10             	pushl  0x10(%ebp)
  8031ef:	e8 59 f1 ff ff       	call   80234d <get_block_size>
  8031f4:	83 c4 04             	add    $0x4,%esp
  8031f7:	01 c3                	add    %eax,%ebx
  8031f9:	ff 75 0c             	pushl  0xc(%ebp)
  8031fc:	e8 4c f1 ff ff       	call   80234d <get_block_size>
  803201:	83 c4 04             	add    $0x4,%esp
  803204:	01 d8                	add    %ebx,%eax
  803206:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803209:	6a 00                	push   $0x0
  80320b:	ff 75 ec             	pushl  -0x14(%ebp)
  80320e:	ff 75 08             	pushl  0x8(%ebp)
  803211:	e8 88 f4 ff ff       	call   80269e <set_block_data>
  803216:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803219:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80321d:	75 17                	jne    803236 <merging+0xc8>
  80321f:	83 ec 04             	sub    $0x4,%esp
  803222:	68 6b 4b 80 00       	push   $0x804b6b
  803227:	68 7d 01 00 00       	push   $0x17d
  80322c:	68 89 4b 80 00       	push   $0x804b89
  803231:	e8 bf d5 ff ff       	call   8007f5 <_panic>
  803236:	8b 45 0c             	mov    0xc(%ebp),%eax
  803239:	8b 00                	mov    (%eax),%eax
  80323b:	85 c0                	test   %eax,%eax
  80323d:	74 10                	je     80324f <merging+0xe1>
  80323f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	8b 55 0c             	mov    0xc(%ebp),%edx
  803247:	8b 52 04             	mov    0x4(%edx),%edx
  80324a:	89 50 04             	mov    %edx,0x4(%eax)
  80324d:	eb 0b                	jmp    80325a <merging+0xec>
  80324f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803252:	8b 40 04             	mov    0x4(%eax),%eax
  803255:	a3 30 50 80 00       	mov    %eax,0x805030
  80325a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80325d:	8b 40 04             	mov    0x4(%eax),%eax
  803260:	85 c0                	test   %eax,%eax
  803262:	74 0f                	je     803273 <merging+0x105>
  803264:	8b 45 0c             	mov    0xc(%ebp),%eax
  803267:	8b 40 04             	mov    0x4(%eax),%eax
  80326a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80326d:	8b 12                	mov    (%edx),%edx
  80326f:	89 10                	mov    %edx,(%eax)
  803271:	eb 0a                	jmp    80327d <merging+0x10f>
  803273:	8b 45 0c             	mov    0xc(%ebp),%eax
  803276:	8b 00                	mov    (%eax),%eax
  803278:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80327d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803280:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803286:	8b 45 0c             	mov    0xc(%ebp),%eax
  803289:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803290:	a1 38 50 80 00       	mov    0x805038,%eax
  803295:	48                   	dec    %eax
  803296:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80329b:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80329c:	e9 ea 02 00 00       	jmp    80358b <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8032a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a5:	74 3b                	je     8032e2 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8032a7:	83 ec 0c             	sub    $0xc,%esp
  8032aa:	ff 75 08             	pushl  0x8(%ebp)
  8032ad:	e8 9b f0 ff ff       	call   80234d <get_block_size>
  8032b2:	83 c4 10             	add    $0x10,%esp
  8032b5:	89 c3                	mov    %eax,%ebx
  8032b7:	83 ec 0c             	sub    $0xc,%esp
  8032ba:	ff 75 10             	pushl  0x10(%ebp)
  8032bd:	e8 8b f0 ff ff       	call   80234d <get_block_size>
  8032c2:	83 c4 10             	add    $0x10,%esp
  8032c5:	01 d8                	add    %ebx,%eax
  8032c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8032ca:	83 ec 04             	sub    $0x4,%esp
  8032cd:	6a 00                	push   $0x0
  8032cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8032d2:	ff 75 08             	pushl  0x8(%ebp)
  8032d5:	e8 c4 f3 ff ff       	call   80269e <set_block_data>
  8032da:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032dd:	e9 a9 02 00 00       	jmp    80358b <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8032e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032e6:	0f 84 2d 01 00 00    	je     803419 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8032ec:	83 ec 0c             	sub    $0xc,%esp
  8032ef:	ff 75 10             	pushl  0x10(%ebp)
  8032f2:	e8 56 f0 ff ff       	call   80234d <get_block_size>
  8032f7:	83 c4 10             	add    $0x10,%esp
  8032fa:	89 c3                	mov    %eax,%ebx
  8032fc:	83 ec 0c             	sub    $0xc,%esp
  8032ff:	ff 75 0c             	pushl  0xc(%ebp)
  803302:	e8 46 f0 ff ff       	call   80234d <get_block_size>
  803307:	83 c4 10             	add    $0x10,%esp
  80330a:	01 d8                	add    %ebx,%eax
  80330c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80330f:	83 ec 04             	sub    $0x4,%esp
  803312:	6a 00                	push   $0x0
  803314:	ff 75 e4             	pushl  -0x1c(%ebp)
  803317:	ff 75 10             	pushl  0x10(%ebp)
  80331a:	e8 7f f3 ff ff       	call   80269e <set_block_data>
  80331f:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803322:	8b 45 10             	mov    0x10(%ebp),%eax
  803325:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803328:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80332c:	74 06                	je     803334 <merging+0x1c6>
  80332e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803332:	75 17                	jne    80334b <merging+0x1dd>
  803334:	83 ec 04             	sub    $0x4,%esp
  803337:	68 44 4c 80 00       	push   $0x804c44
  80333c:	68 8d 01 00 00       	push   $0x18d
  803341:	68 89 4b 80 00       	push   $0x804b89
  803346:	e8 aa d4 ff ff       	call   8007f5 <_panic>
  80334b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334e:	8b 50 04             	mov    0x4(%eax),%edx
  803351:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803354:	89 50 04             	mov    %edx,0x4(%eax)
  803357:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80335a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80335d:	89 10                	mov    %edx,(%eax)
  80335f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803362:	8b 40 04             	mov    0x4(%eax),%eax
  803365:	85 c0                	test   %eax,%eax
  803367:	74 0d                	je     803376 <merging+0x208>
  803369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336c:	8b 40 04             	mov    0x4(%eax),%eax
  80336f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803372:	89 10                	mov    %edx,(%eax)
  803374:	eb 08                	jmp    80337e <merging+0x210>
  803376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803379:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80337e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803381:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803384:	89 50 04             	mov    %edx,0x4(%eax)
  803387:	a1 38 50 80 00       	mov    0x805038,%eax
  80338c:	40                   	inc    %eax
  80338d:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803392:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803396:	75 17                	jne    8033af <merging+0x241>
  803398:	83 ec 04             	sub    $0x4,%esp
  80339b:	68 6b 4b 80 00       	push   $0x804b6b
  8033a0:	68 8e 01 00 00       	push   $0x18e
  8033a5:	68 89 4b 80 00       	push   $0x804b89
  8033aa:	e8 46 d4 ff ff       	call   8007f5 <_panic>
  8033af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b2:	8b 00                	mov    (%eax),%eax
  8033b4:	85 c0                	test   %eax,%eax
  8033b6:	74 10                	je     8033c8 <merging+0x25a>
  8033b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bb:	8b 00                	mov    (%eax),%eax
  8033bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c0:	8b 52 04             	mov    0x4(%edx),%edx
  8033c3:	89 50 04             	mov    %edx,0x4(%eax)
  8033c6:	eb 0b                	jmp    8033d3 <merging+0x265>
  8033c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033cb:	8b 40 04             	mov    0x4(%eax),%eax
  8033ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8033d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d6:	8b 40 04             	mov    0x4(%eax),%eax
  8033d9:	85 c0                	test   %eax,%eax
  8033db:	74 0f                	je     8033ec <merging+0x27e>
  8033dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e0:	8b 40 04             	mov    0x4(%eax),%eax
  8033e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033e6:	8b 12                	mov    (%edx),%edx
  8033e8:	89 10                	mov    %edx,(%eax)
  8033ea:	eb 0a                	jmp    8033f6 <merging+0x288>
  8033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ef:	8b 00                	mov    (%eax),%eax
  8033f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803402:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803409:	a1 38 50 80 00       	mov    0x805038,%eax
  80340e:	48                   	dec    %eax
  80340f:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803414:	e9 72 01 00 00       	jmp    80358b <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803419:	8b 45 10             	mov    0x10(%ebp),%eax
  80341c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80341f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803423:	74 79                	je     80349e <merging+0x330>
  803425:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803429:	74 73                	je     80349e <merging+0x330>
  80342b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80342f:	74 06                	je     803437 <merging+0x2c9>
  803431:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803435:	75 17                	jne    80344e <merging+0x2e0>
  803437:	83 ec 04             	sub    $0x4,%esp
  80343a:	68 fc 4b 80 00       	push   $0x804bfc
  80343f:	68 94 01 00 00       	push   $0x194
  803444:	68 89 4b 80 00       	push   $0x804b89
  803449:	e8 a7 d3 ff ff       	call   8007f5 <_panic>
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	8b 10                	mov    (%eax),%edx
  803453:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803456:	89 10                	mov    %edx,(%eax)
  803458:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	85 c0                	test   %eax,%eax
  80345f:	74 0b                	je     80346c <merging+0x2fe>
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	8b 00                	mov    (%eax),%eax
  803466:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803469:	89 50 04             	mov    %edx,0x4(%eax)
  80346c:	8b 45 08             	mov    0x8(%ebp),%eax
  80346f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803472:	89 10                	mov    %edx,(%eax)
  803474:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803477:	8b 55 08             	mov    0x8(%ebp),%edx
  80347a:	89 50 04             	mov    %edx,0x4(%eax)
  80347d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803480:	8b 00                	mov    (%eax),%eax
  803482:	85 c0                	test   %eax,%eax
  803484:	75 08                	jne    80348e <merging+0x320>
  803486:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803489:	a3 30 50 80 00       	mov    %eax,0x805030
  80348e:	a1 38 50 80 00       	mov    0x805038,%eax
  803493:	40                   	inc    %eax
  803494:	a3 38 50 80 00       	mov    %eax,0x805038
  803499:	e9 ce 00 00 00       	jmp    80356c <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80349e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034a2:	74 65                	je     803509 <merging+0x39b>
  8034a4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034a8:	75 17                	jne    8034c1 <merging+0x353>
  8034aa:	83 ec 04             	sub    $0x4,%esp
  8034ad:	68 d8 4b 80 00       	push   $0x804bd8
  8034b2:	68 95 01 00 00       	push   $0x195
  8034b7:	68 89 4b 80 00       	push   $0x804b89
  8034bc:	e8 34 d3 ff ff       	call   8007f5 <_panic>
  8034c1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ca:	89 50 04             	mov    %edx,0x4(%eax)
  8034cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034d0:	8b 40 04             	mov    0x4(%eax),%eax
  8034d3:	85 c0                	test   %eax,%eax
  8034d5:	74 0c                	je     8034e3 <merging+0x375>
  8034d7:	a1 30 50 80 00       	mov    0x805030,%eax
  8034dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034df:	89 10                	mov    %edx,(%eax)
  8034e1:	eb 08                	jmp    8034eb <merging+0x37d>
  8034e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034e6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034fc:	a1 38 50 80 00       	mov    0x805038,%eax
  803501:	40                   	inc    %eax
  803502:	a3 38 50 80 00       	mov    %eax,0x805038
  803507:	eb 63                	jmp    80356c <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803509:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80350d:	75 17                	jne    803526 <merging+0x3b8>
  80350f:	83 ec 04             	sub    $0x4,%esp
  803512:	68 a4 4b 80 00       	push   $0x804ba4
  803517:	68 98 01 00 00       	push   $0x198
  80351c:	68 89 4b 80 00       	push   $0x804b89
  803521:	e8 cf d2 ff ff       	call   8007f5 <_panic>
  803526:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80352c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80352f:	89 10                	mov    %edx,(%eax)
  803531:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803534:	8b 00                	mov    (%eax),%eax
  803536:	85 c0                	test   %eax,%eax
  803538:	74 0d                	je     803547 <merging+0x3d9>
  80353a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80353f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803542:	89 50 04             	mov    %edx,0x4(%eax)
  803545:	eb 08                	jmp    80354f <merging+0x3e1>
  803547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80354a:	a3 30 50 80 00       	mov    %eax,0x805030
  80354f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803552:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803557:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80355a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803561:	a1 38 50 80 00       	mov    0x805038,%eax
  803566:	40                   	inc    %eax
  803567:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80356c:	83 ec 0c             	sub    $0xc,%esp
  80356f:	ff 75 10             	pushl  0x10(%ebp)
  803572:	e8 d6 ed ff ff       	call   80234d <get_block_size>
  803577:	83 c4 10             	add    $0x10,%esp
  80357a:	83 ec 04             	sub    $0x4,%esp
  80357d:	6a 00                	push   $0x0
  80357f:	50                   	push   %eax
  803580:	ff 75 10             	pushl  0x10(%ebp)
  803583:	e8 16 f1 ff ff       	call   80269e <set_block_data>
  803588:	83 c4 10             	add    $0x10,%esp
	}
}
  80358b:	90                   	nop
  80358c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80358f:	c9                   	leave  
  803590:	c3                   	ret    

00803591 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803591:	55                   	push   %ebp
  803592:	89 e5                	mov    %esp,%ebp
  803594:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803597:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80359c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80359f:	a1 30 50 80 00       	mov    0x805030,%eax
  8035a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035a7:	73 1b                	jae    8035c4 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8035a9:	a1 30 50 80 00       	mov    0x805030,%eax
  8035ae:	83 ec 04             	sub    $0x4,%esp
  8035b1:	ff 75 08             	pushl  0x8(%ebp)
  8035b4:	6a 00                	push   $0x0
  8035b6:	50                   	push   %eax
  8035b7:	e8 b2 fb ff ff       	call   80316e <merging>
  8035bc:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8035bf:	e9 8b 00 00 00       	jmp    80364f <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8035c4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035cc:	76 18                	jbe    8035e6 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8035ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d3:	83 ec 04             	sub    $0x4,%esp
  8035d6:	ff 75 08             	pushl  0x8(%ebp)
  8035d9:	50                   	push   %eax
  8035da:	6a 00                	push   $0x0
  8035dc:	e8 8d fb ff ff       	call   80316e <merging>
  8035e1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8035e4:	eb 69                	jmp    80364f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8035e6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ee:	eb 39                	jmp    803629 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8035f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035f6:	73 29                	jae    803621 <free_block+0x90>
  8035f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fb:	8b 00                	mov    (%eax),%eax
  8035fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803600:	76 1f                	jbe    803621 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803605:	8b 00                	mov    (%eax),%eax
  803607:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80360a:	83 ec 04             	sub    $0x4,%esp
  80360d:	ff 75 08             	pushl  0x8(%ebp)
  803610:	ff 75 f0             	pushl  -0x10(%ebp)
  803613:	ff 75 f4             	pushl  -0xc(%ebp)
  803616:	e8 53 fb ff ff       	call   80316e <merging>
  80361b:	83 c4 10             	add    $0x10,%esp
			break;
  80361e:	90                   	nop
		}
	}
}
  80361f:	eb 2e                	jmp    80364f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803621:	a1 34 50 80 00       	mov    0x805034,%eax
  803626:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803629:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80362d:	74 07                	je     803636 <free_block+0xa5>
  80362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803632:	8b 00                	mov    (%eax),%eax
  803634:	eb 05                	jmp    80363b <free_block+0xaa>
  803636:	b8 00 00 00 00       	mov    $0x0,%eax
  80363b:	a3 34 50 80 00       	mov    %eax,0x805034
  803640:	a1 34 50 80 00       	mov    0x805034,%eax
  803645:	85 c0                	test   %eax,%eax
  803647:	75 a7                	jne    8035f0 <free_block+0x5f>
  803649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364d:	75 a1                	jne    8035f0 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80364f:	90                   	nop
  803650:	c9                   	leave  
  803651:	c3                   	ret    

00803652 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803652:	55                   	push   %ebp
  803653:	89 e5                	mov    %esp,%ebp
  803655:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803658:	ff 75 08             	pushl  0x8(%ebp)
  80365b:	e8 ed ec ff ff       	call   80234d <get_block_size>
  803660:	83 c4 04             	add    $0x4,%esp
  803663:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803666:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80366d:	eb 17                	jmp    803686 <copy_data+0x34>
  80366f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803672:	8b 45 0c             	mov    0xc(%ebp),%eax
  803675:	01 c2                	add    %eax,%edx
  803677:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	01 c8                	add    %ecx,%eax
  80367f:	8a 00                	mov    (%eax),%al
  803681:	88 02                	mov    %al,(%edx)
  803683:	ff 45 fc             	incl   -0x4(%ebp)
  803686:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803689:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80368c:	72 e1                	jb     80366f <copy_data+0x1d>
}
  80368e:	90                   	nop
  80368f:	c9                   	leave  
  803690:	c3                   	ret    

00803691 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803691:	55                   	push   %ebp
  803692:	89 e5                	mov    %esp,%ebp
  803694:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803697:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80369b:	75 23                	jne    8036c0 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80369d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036a1:	74 13                	je     8036b6 <realloc_block_FF+0x25>
  8036a3:	83 ec 0c             	sub    $0xc,%esp
  8036a6:	ff 75 0c             	pushl  0xc(%ebp)
  8036a9:	e8 1f f0 ff ff       	call   8026cd <alloc_block_FF>
  8036ae:	83 c4 10             	add    $0x10,%esp
  8036b1:	e9 f4 06 00 00       	jmp    803daa <realloc_block_FF+0x719>
		return NULL;
  8036b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bb:	e9 ea 06 00 00       	jmp    803daa <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8036c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036c4:	75 18                	jne    8036de <realloc_block_FF+0x4d>
	{
		free_block(va);
  8036c6:	83 ec 0c             	sub    $0xc,%esp
  8036c9:	ff 75 08             	pushl  0x8(%ebp)
  8036cc:	e8 c0 fe ff ff       	call   803591 <free_block>
  8036d1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8036d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d9:	e9 cc 06 00 00       	jmp    803daa <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8036de:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8036e2:	77 07                	ja     8036eb <realloc_block_FF+0x5a>
  8036e4:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8036eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ee:	83 e0 01             	and    $0x1,%eax
  8036f1:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8036f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f7:	83 c0 08             	add    $0x8,%eax
  8036fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8036fd:	83 ec 0c             	sub    $0xc,%esp
  803700:	ff 75 08             	pushl  0x8(%ebp)
  803703:	e8 45 ec ff ff       	call   80234d <get_block_size>
  803708:	83 c4 10             	add    $0x10,%esp
  80370b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80370e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803711:	83 e8 08             	sub    $0x8,%eax
  803714:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	83 e8 04             	sub    $0x4,%eax
  80371d:	8b 00                	mov    (%eax),%eax
  80371f:	83 e0 fe             	and    $0xfffffffe,%eax
  803722:	89 c2                	mov    %eax,%edx
  803724:	8b 45 08             	mov    0x8(%ebp),%eax
  803727:	01 d0                	add    %edx,%eax
  803729:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80372c:	83 ec 0c             	sub    $0xc,%esp
  80372f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803732:	e8 16 ec ff ff       	call   80234d <get_block_size>
  803737:	83 c4 10             	add    $0x10,%esp
  80373a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80373d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803740:	83 e8 08             	sub    $0x8,%eax
  803743:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803746:	8b 45 0c             	mov    0xc(%ebp),%eax
  803749:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80374c:	75 08                	jne    803756 <realloc_block_FF+0xc5>
	{
		 return va;
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	e9 54 06 00 00       	jmp    803daa <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803756:	8b 45 0c             	mov    0xc(%ebp),%eax
  803759:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80375c:	0f 83 e5 03 00 00    	jae    803b47 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803762:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803765:	2b 45 0c             	sub    0xc(%ebp),%eax
  803768:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80376b:	83 ec 0c             	sub    $0xc,%esp
  80376e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803771:	e8 f0 eb ff ff       	call   802366 <is_free_block>
  803776:	83 c4 10             	add    $0x10,%esp
  803779:	84 c0                	test   %al,%al
  80377b:	0f 84 3b 01 00 00    	je     8038bc <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803781:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803784:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803787:	01 d0                	add    %edx,%eax
  803789:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80378c:	83 ec 04             	sub    $0x4,%esp
  80378f:	6a 01                	push   $0x1
  803791:	ff 75 f0             	pushl  -0x10(%ebp)
  803794:	ff 75 08             	pushl  0x8(%ebp)
  803797:	e8 02 ef ff ff       	call   80269e <set_block_data>
  80379c:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80379f:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a2:	83 e8 04             	sub    $0x4,%eax
  8037a5:	8b 00                	mov    (%eax),%eax
  8037a7:	83 e0 fe             	and    $0xfffffffe,%eax
  8037aa:	89 c2                	mov    %eax,%edx
  8037ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8037af:	01 d0                	add    %edx,%eax
  8037b1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8037b4:	83 ec 04             	sub    $0x4,%esp
  8037b7:	6a 00                	push   $0x0
  8037b9:	ff 75 cc             	pushl  -0x34(%ebp)
  8037bc:	ff 75 c8             	pushl  -0x38(%ebp)
  8037bf:	e8 da ee ff ff       	call   80269e <set_block_data>
  8037c4:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037cb:	74 06                	je     8037d3 <realloc_block_FF+0x142>
  8037cd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8037d1:	75 17                	jne    8037ea <realloc_block_FF+0x159>
  8037d3:	83 ec 04             	sub    $0x4,%esp
  8037d6:	68 fc 4b 80 00       	push   $0x804bfc
  8037db:	68 f6 01 00 00       	push   $0x1f6
  8037e0:	68 89 4b 80 00       	push   $0x804b89
  8037e5:	e8 0b d0 ff ff       	call   8007f5 <_panic>
  8037ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ed:	8b 10                	mov    (%eax),%edx
  8037ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037f2:	89 10                	mov    %edx,(%eax)
  8037f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037f7:	8b 00                	mov    (%eax),%eax
  8037f9:	85 c0                	test   %eax,%eax
  8037fb:	74 0b                	je     803808 <realloc_block_FF+0x177>
  8037fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803800:	8b 00                	mov    (%eax),%eax
  803802:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803805:	89 50 04             	mov    %edx,0x4(%eax)
  803808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80380e:	89 10                	mov    %edx,(%eax)
  803810:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803816:	89 50 04             	mov    %edx,0x4(%eax)
  803819:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	85 c0                	test   %eax,%eax
  803820:	75 08                	jne    80382a <realloc_block_FF+0x199>
  803822:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803825:	a3 30 50 80 00       	mov    %eax,0x805030
  80382a:	a1 38 50 80 00       	mov    0x805038,%eax
  80382f:	40                   	inc    %eax
  803830:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803835:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803839:	75 17                	jne    803852 <realloc_block_FF+0x1c1>
  80383b:	83 ec 04             	sub    $0x4,%esp
  80383e:	68 6b 4b 80 00       	push   $0x804b6b
  803843:	68 f7 01 00 00       	push   $0x1f7
  803848:	68 89 4b 80 00       	push   $0x804b89
  80384d:	e8 a3 cf ff ff       	call   8007f5 <_panic>
  803852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803855:	8b 00                	mov    (%eax),%eax
  803857:	85 c0                	test   %eax,%eax
  803859:	74 10                	je     80386b <realloc_block_FF+0x1da>
  80385b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385e:	8b 00                	mov    (%eax),%eax
  803860:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803863:	8b 52 04             	mov    0x4(%edx),%edx
  803866:	89 50 04             	mov    %edx,0x4(%eax)
  803869:	eb 0b                	jmp    803876 <realloc_block_FF+0x1e5>
  80386b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386e:	8b 40 04             	mov    0x4(%eax),%eax
  803871:	a3 30 50 80 00       	mov    %eax,0x805030
  803876:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803879:	8b 40 04             	mov    0x4(%eax),%eax
  80387c:	85 c0                	test   %eax,%eax
  80387e:	74 0f                	je     80388f <realloc_block_FF+0x1fe>
  803880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803883:	8b 40 04             	mov    0x4(%eax),%eax
  803886:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803889:	8b 12                	mov    (%edx),%edx
  80388b:	89 10                	mov    %edx,(%eax)
  80388d:	eb 0a                	jmp    803899 <realloc_block_FF+0x208>
  80388f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803892:	8b 00                	mov    (%eax),%eax
  803894:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8038b1:	48                   	dec    %eax
  8038b2:	a3 38 50 80 00       	mov    %eax,0x805038
  8038b7:	e9 83 02 00 00       	jmp    803b3f <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8038bc:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8038c0:	0f 86 69 02 00 00    	jbe    803b2f <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8038c6:	83 ec 04             	sub    $0x4,%esp
  8038c9:	6a 01                	push   $0x1
  8038cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8038ce:	ff 75 08             	pushl  0x8(%ebp)
  8038d1:	e8 c8 ed ff ff       	call   80269e <set_block_data>
  8038d6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dc:	83 e8 04             	sub    $0x4,%eax
  8038df:	8b 00                	mov    (%eax),%eax
  8038e1:	83 e0 fe             	and    $0xfffffffe,%eax
  8038e4:	89 c2                	mov    %eax,%edx
  8038e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e9:	01 d0                	add    %edx,%eax
  8038eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8038ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8038f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8038f6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8038fa:	75 68                	jne    803964 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8038fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803900:	75 17                	jne    803919 <realloc_block_FF+0x288>
  803902:	83 ec 04             	sub    $0x4,%esp
  803905:	68 a4 4b 80 00       	push   $0x804ba4
  80390a:	68 06 02 00 00       	push   $0x206
  80390f:	68 89 4b 80 00       	push   $0x804b89
  803914:	e8 dc ce ff ff       	call   8007f5 <_panic>
  803919:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80391f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803922:	89 10                	mov    %edx,(%eax)
  803924:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803927:	8b 00                	mov    (%eax),%eax
  803929:	85 c0                	test   %eax,%eax
  80392b:	74 0d                	je     80393a <realloc_block_FF+0x2a9>
  80392d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803932:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803935:	89 50 04             	mov    %edx,0x4(%eax)
  803938:	eb 08                	jmp    803942 <realloc_block_FF+0x2b1>
  80393a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80393d:	a3 30 50 80 00       	mov    %eax,0x805030
  803942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803945:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80394a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80394d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803954:	a1 38 50 80 00       	mov    0x805038,%eax
  803959:	40                   	inc    %eax
  80395a:	a3 38 50 80 00       	mov    %eax,0x805038
  80395f:	e9 b0 01 00 00       	jmp    803b14 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803964:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803969:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80396c:	76 68                	jbe    8039d6 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80396e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803972:	75 17                	jne    80398b <realloc_block_FF+0x2fa>
  803974:	83 ec 04             	sub    $0x4,%esp
  803977:	68 a4 4b 80 00       	push   $0x804ba4
  80397c:	68 0b 02 00 00       	push   $0x20b
  803981:	68 89 4b 80 00       	push   $0x804b89
  803986:	e8 6a ce ff ff       	call   8007f5 <_panic>
  80398b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803991:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803994:	89 10                	mov    %edx,(%eax)
  803996:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803999:	8b 00                	mov    (%eax),%eax
  80399b:	85 c0                	test   %eax,%eax
  80399d:	74 0d                	je     8039ac <realloc_block_FF+0x31b>
  80399f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039a7:	89 50 04             	mov    %edx,0x4(%eax)
  8039aa:	eb 08                	jmp    8039b4 <realloc_block_FF+0x323>
  8039ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039af:	a3 30 50 80 00       	mov    %eax,0x805030
  8039b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039b7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c6:	a1 38 50 80 00       	mov    0x805038,%eax
  8039cb:	40                   	inc    %eax
  8039cc:	a3 38 50 80 00       	mov    %eax,0x805038
  8039d1:	e9 3e 01 00 00       	jmp    803b14 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8039d6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039db:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039de:	73 68                	jae    803a48 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039e0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039e4:	75 17                	jne    8039fd <realloc_block_FF+0x36c>
  8039e6:	83 ec 04             	sub    $0x4,%esp
  8039e9:	68 d8 4b 80 00       	push   $0x804bd8
  8039ee:	68 10 02 00 00       	push   $0x210
  8039f3:	68 89 4b 80 00       	push   $0x804b89
  8039f8:	e8 f8 cd ff ff       	call   8007f5 <_panic>
  8039fd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a03:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a06:	89 50 04             	mov    %edx,0x4(%eax)
  803a09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a0c:	8b 40 04             	mov    0x4(%eax),%eax
  803a0f:	85 c0                	test   %eax,%eax
  803a11:	74 0c                	je     803a1f <realloc_block_FF+0x38e>
  803a13:	a1 30 50 80 00       	mov    0x805030,%eax
  803a18:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a1b:	89 10                	mov    %edx,(%eax)
  803a1d:	eb 08                	jmp    803a27 <realloc_block_FF+0x396>
  803a1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a22:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a2a:	a3 30 50 80 00       	mov    %eax,0x805030
  803a2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a38:	a1 38 50 80 00       	mov    0x805038,%eax
  803a3d:	40                   	inc    %eax
  803a3e:	a3 38 50 80 00       	mov    %eax,0x805038
  803a43:	e9 cc 00 00 00       	jmp    803b14 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803a48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803a4f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a57:	e9 8a 00 00 00       	jmp    803ae6 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a62:	73 7a                	jae    803ade <realloc_block_FF+0x44d>
  803a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a67:	8b 00                	mov    (%eax),%eax
  803a69:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a6c:	73 70                	jae    803ade <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a72:	74 06                	je     803a7a <realloc_block_FF+0x3e9>
  803a74:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a78:	75 17                	jne    803a91 <realloc_block_FF+0x400>
  803a7a:	83 ec 04             	sub    $0x4,%esp
  803a7d:	68 fc 4b 80 00       	push   $0x804bfc
  803a82:	68 1a 02 00 00       	push   $0x21a
  803a87:	68 89 4b 80 00       	push   $0x804b89
  803a8c:	e8 64 cd ff ff       	call   8007f5 <_panic>
  803a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a94:	8b 10                	mov    (%eax),%edx
  803a96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a99:	89 10                	mov    %edx,(%eax)
  803a9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a9e:	8b 00                	mov    (%eax),%eax
  803aa0:	85 c0                	test   %eax,%eax
  803aa2:	74 0b                	je     803aaf <realloc_block_FF+0x41e>
  803aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa7:	8b 00                	mov    (%eax),%eax
  803aa9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803aac:	89 50 04             	mov    %edx,0x4(%eax)
  803aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ab5:	89 10                	mov    %edx,(%eax)
  803ab7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803abd:	89 50 04             	mov    %edx,0x4(%eax)
  803ac0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ac3:	8b 00                	mov    (%eax),%eax
  803ac5:	85 c0                	test   %eax,%eax
  803ac7:	75 08                	jne    803ad1 <realloc_block_FF+0x440>
  803ac9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803acc:	a3 30 50 80 00       	mov    %eax,0x805030
  803ad1:	a1 38 50 80 00       	mov    0x805038,%eax
  803ad6:	40                   	inc    %eax
  803ad7:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803adc:	eb 36                	jmp    803b14 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803ade:	a1 34 50 80 00       	mov    0x805034,%eax
  803ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ae6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aea:	74 07                	je     803af3 <realloc_block_FF+0x462>
  803aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aef:	8b 00                	mov    (%eax),%eax
  803af1:	eb 05                	jmp    803af8 <realloc_block_FF+0x467>
  803af3:	b8 00 00 00 00       	mov    $0x0,%eax
  803af8:	a3 34 50 80 00       	mov    %eax,0x805034
  803afd:	a1 34 50 80 00       	mov    0x805034,%eax
  803b02:	85 c0                	test   %eax,%eax
  803b04:	0f 85 52 ff ff ff    	jne    803a5c <realloc_block_FF+0x3cb>
  803b0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b0e:	0f 85 48 ff ff ff    	jne    803a5c <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803b14:	83 ec 04             	sub    $0x4,%esp
  803b17:	6a 00                	push   $0x0
  803b19:	ff 75 d8             	pushl  -0x28(%ebp)
  803b1c:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b1f:	e8 7a eb ff ff       	call   80269e <set_block_data>
  803b24:	83 c4 10             	add    $0x10,%esp
				return va;
  803b27:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2a:	e9 7b 02 00 00       	jmp    803daa <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803b2f:	83 ec 0c             	sub    $0xc,%esp
  803b32:	68 79 4c 80 00       	push   $0x804c79
  803b37:	e8 76 cf ff ff       	call   800ab2 <cprintf>
  803b3c:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b42:	e9 63 02 00 00       	jmp    803daa <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b4a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b4d:	0f 86 4d 02 00 00    	jbe    803da0 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803b53:	83 ec 0c             	sub    $0xc,%esp
  803b56:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b59:	e8 08 e8 ff ff       	call   802366 <is_free_block>
  803b5e:	83 c4 10             	add    $0x10,%esp
  803b61:	84 c0                	test   %al,%al
  803b63:	0f 84 37 02 00 00    	je     803da0 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b6c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803b6f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803b72:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b75:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803b78:	76 38                	jbe    803bb2 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803b7a:	83 ec 0c             	sub    $0xc,%esp
  803b7d:	ff 75 08             	pushl  0x8(%ebp)
  803b80:	e8 0c fa ff ff       	call   803591 <free_block>
  803b85:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803b88:	83 ec 0c             	sub    $0xc,%esp
  803b8b:	ff 75 0c             	pushl  0xc(%ebp)
  803b8e:	e8 3a eb ff ff       	call   8026cd <alloc_block_FF>
  803b93:	83 c4 10             	add    $0x10,%esp
  803b96:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803b99:	83 ec 08             	sub    $0x8,%esp
  803b9c:	ff 75 c0             	pushl  -0x40(%ebp)
  803b9f:	ff 75 08             	pushl  0x8(%ebp)
  803ba2:	e8 ab fa ff ff       	call   803652 <copy_data>
  803ba7:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803baa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803bad:	e9 f8 01 00 00       	jmp    803daa <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803bb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bb5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803bb8:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803bbb:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803bbf:	0f 87 a0 00 00 00    	ja     803c65 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803bc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bc9:	75 17                	jne    803be2 <realloc_block_FF+0x551>
  803bcb:	83 ec 04             	sub    $0x4,%esp
  803bce:	68 6b 4b 80 00       	push   $0x804b6b
  803bd3:	68 38 02 00 00       	push   $0x238
  803bd8:	68 89 4b 80 00       	push   $0x804b89
  803bdd:	e8 13 cc ff ff       	call   8007f5 <_panic>
  803be2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be5:	8b 00                	mov    (%eax),%eax
  803be7:	85 c0                	test   %eax,%eax
  803be9:	74 10                	je     803bfb <realloc_block_FF+0x56a>
  803beb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bee:	8b 00                	mov    (%eax),%eax
  803bf0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bf3:	8b 52 04             	mov    0x4(%edx),%edx
  803bf6:	89 50 04             	mov    %edx,0x4(%eax)
  803bf9:	eb 0b                	jmp    803c06 <realloc_block_FF+0x575>
  803bfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfe:	8b 40 04             	mov    0x4(%eax),%eax
  803c01:	a3 30 50 80 00       	mov    %eax,0x805030
  803c06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c09:	8b 40 04             	mov    0x4(%eax),%eax
  803c0c:	85 c0                	test   %eax,%eax
  803c0e:	74 0f                	je     803c1f <realloc_block_FF+0x58e>
  803c10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c13:	8b 40 04             	mov    0x4(%eax),%eax
  803c16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c19:	8b 12                	mov    (%edx),%edx
  803c1b:	89 10                	mov    %edx,(%eax)
  803c1d:	eb 0a                	jmp    803c29 <realloc_block_FF+0x598>
  803c1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c22:	8b 00                	mov    (%eax),%eax
  803c24:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c3c:	a1 38 50 80 00       	mov    0x805038,%eax
  803c41:	48                   	dec    %eax
  803c42:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803c47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c4d:	01 d0                	add    %edx,%eax
  803c4f:	83 ec 04             	sub    $0x4,%esp
  803c52:	6a 01                	push   $0x1
  803c54:	50                   	push   %eax
  803c55:	ff 75 08             	pushl  0x8(%ebp)
  803c58:	e8 41 ea ff ff       	call   80269e <set_block_data>
  803c5d:	83 c4 10             	add    $0x10,%esp
  803c60:	e9 36 01 00 00       	jmp    803d9b <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803c65:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c68:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c6b:	01 d0                	add    %edx,%eax
  803c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803c70:	83 ec 04             	sub    $0x4,%esp
  803c73:	6a 01                	push   $0x1
  803c75:	ff 75 f0             	pushl  -0x10(%ebp)
  803c78:	ff 75 08             	pushl  0x8(%ebp)
  803c7b:	e8 1e ea ff ff       	call   80269e <set_block_data>
  803c80:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c83:	8b 45 08             	mov    0x8(%ebp),%eax
  803c86:	83 e8 04             	sub    $0x4,%eax
  803c89:	8b 00                	mov    (%eax),%eax
  803c8b:	83 e0 fe             	and    $0xfffffffe,%eax
  803c8e:	89 c2                	mov    %eax,%edx
  803c90:	8b 45 08             	mov    0x8(%ebp),%eax
  803c93:	01 d0                	add    %edx,%eax
  803c95:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c9c:	74 06                	je     803ca4 <realloc_block_FF+0x613>
  803c9e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803ca2:	75 17                	jne    803cbb <realloc_block_FF+0x62a>
  803ca4:	83 ec 04             	sub    $0x4,%esp
  803ca7:	68 fc 4b 80 00       	push   $0x804bfc
  803cac:	68 44 02 00 00       	push   $0x244
  803cb1:	68 89 4b 80 00       	push   $0x804b89
  803cb6:	e8 3a cb ff ff       	call   8007f5 <_panic>
  803cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cbe:	8b 10                	mov    (%eax),%edx
  803cc0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cc3:	89 10                	mov    %edx,(%eax)
  803cc5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cc8:	8b 00                	mov    (%eax),%eax
  803cca:	85 c0                	test   %eax,%eax
  803ccc:	74 0b                	je     803cd9 <realloc_block_FF+0x648>
  803cce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd1:	8b 00                	mov    (%eax),%eax
  803cd3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803cd6:	89 50 04             	mov    %edx,0x4(%eax)
  803cd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cdc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803cdf:	89 10                	mov    %edx,(%eax)
  803ce1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ce4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ce7:	89 50 04             	mov    %edx,0x4(%eax)
  803cea:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ced:	8b 00                	mov    (%eax),%eax
  803cef:	85 c0                	test   %eax,%eax
  803cf1:	75 08                	jne    803cfb <realloc_block_FF+0x66a>
  803cf3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cf6:	a3 30 50 80 00       	mov    %eax,0x805030
  803cfb:	a1 38 50 80 00       	mov    0x805038,%eax
  803d00:	40                   	inc    %eax
  803d01:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803d06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d0a:	75 17                	jne    803d23 <realloc_block_FF+0x692>
  803d0c:	83 ec 04             	sub    $0x4,%esp
  803d0f:	68 6b 4b 80 00       	push   $0x804b6b
  803d14:	68 45 02 00 00       	push   $0x245
  803d19:	68 89 4b 80 00       	push   $0x804b89
  803d1e:	e8 d2 ca ff ff       	call   8007f5 <_panic>
  803d23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d26:	8b 00                	mov    (%eax),%eax
  803d28:	85 c0                	test   %eax,%eax
  803d2a:	74 10                	je     803d3c <realloc_block_FF+0x6ab>
  803d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2f:	8b 00                	mov    (%eax),%eax
  803d31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d34:	8b 52 04             	mov    0x4(%edx),%edx
  803d37:	89 50 04             	mov    %edx,0x4(%eax)
  803d3a:	eb 0b                	jmp    803d47 <realloc_block_FF+0x6b6>
  803d3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3f:	8b 40 04             	mov    0x4(%eax),%eax
  803d42:	a3 30 50 80 00       	mov    %eax,0x805030
  803d47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4a:	8b 40 04             	mov    0x4(%eax),%eax
  803d4d:	85 c0                	test   %eax,%eax
  803d4f:	74 0f                	je     803d60 <realloc_block_FF+0x6cf>
  803d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d54:	8b 40 04             	mov    0x4(%eax),%eax
  803d57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d5a:	8b 12                	mov    (%edx),%edx
  803d5c:	89 10                	mov    %edx,(%eax)
  803d5e:	eb 0a                	jmp    803d6a <realloc_block_FF+0x6d9>
  803d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d63:	8b 00                	mov    (%eax),%eax
  803d65:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d7d:	a1 38 50 80 00       	mov    0x805038,%eax
  803d82:	48                   	dec    %eax
  803d83:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803d88:	83 ec 04             	sub    $0x4,%esp
  803d8b:	6a 00                	push   $0x0
  803d8d:	ff 75 bc             	pushl  -0x44(%ebp)
  803d90:	ff 75 b8             	pushl  -0x48(%ebp)
  803d93:	e8 06 e9 ff ff       	call   80269e <set_block_data>
  803d98:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9e:	eb 0a                	jmp    803daa <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803da0:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803da7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803daa:	c9                   	leave  
  803dab:	c3                   	ret    

00803dac <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803dac:	55                   	push   %ebp
  803dad:	89 e5                	mov    %esp,%ebp
  803daf:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803db2:	83 ec 04             	sub    $0x4,%esp
  803db5:	68 80 4c 80 00       	push   $0x804c80
  803dba:	68 58 02 00 00       	push   $0x258
  803dbf:	68 89 4b 80 00       	push   $0x804b89
  803dc4:	e8 2c ca ff ff       	call   8007f5 <_panic>

00803dc9 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803dc9:	55                   	push   %ebp
  803dca:	89 e5                	mov    %esp,%ebp
  803dcc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803dcf:	83 ec 04             	sub    $0x4,%esp
  803dd2:	68 a8 4c 80 00       	push   $0x804ca8
  803dd7:	68 61 02 00 00       	push   $0x261
  803ddc:	68 89 4b 80 00       	push   $0x804b89
  803de1:	e8 0f ca ff ff       	call   8007f5 <_panic>
  803de6:	66 90                	xchg   %ax,%ax

00803de8 <__udivdi3>:
  803de8:	55                   	push   %ebp
  803de9:	57                   	push   %edi
  803dea:	56                   	push   %esi
  803deb:	53                   	push   %ebx
  803dec:	83 ec 1c             	sub    $0x1c,%esp
  803def:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803df3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803df7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dfb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803dff:	89 ca                	mov    %ecx,%edx
  803e01:	89 f8                	mov    %edi,%eax
  803e03:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e07:	85 f6                	test   %esi,%esi
  803e09:	75 2d                	jne    803e38 <__udivdi3+0x50>
  803e0b:	39 cf                	cmp    %ecx,%edi
  803e0d:	77 65                	ja     803e74 <__udivdi3+0x8c>
  803e0f:	89 fd                	mov    %edi,%ebp
  803e11:	85 ff                	test   %edi,%edi
  803e13:	75 0b                	jne    803e20 <__udivdi3+0x38>
  803e15:	b8 01 00 00 00       	mov    $0x1,%eax
  803e1a:	31 d2                	xor    %edx,%edx
  803e1c:	f7 f7                	div    %edi
  803e1e:	89 c5                	mov    %eax,%ebp
  803e20:	31 d2                	xor    %edx,%edx
  803e22:	89 c8                	mov    %ecx,%eax
  803e24:	f7 f5                	div    %ebp
  803e26:	89 c1                	mov    %eax,%ecx
  803e28:	89 d8                	mov    %ebx,%eax
  803e2a:	f7 f5                	div    %ebp
  803e2c:	89 cf                	mov    %ecx,%edi
  803e2e:	89 fa                	mov    %edi,%edx
  803e30:	83 c4 1c             	add    $0x1c,%esp
  803e33:	5b                   	pop    %ebx
  803e34:	5e                   	pop    %esi
  803e35:	5f                   	pop    %edi
  803e36:	5d                   	pop    %ebp
  803e37:	c3                   	ret    
  803e38:	39 ce                	cmp    %ecx,%esi
  803e3a:	77 28                	ja     803e64 <__udivdi3+0x7c>
  803e3c:	0f bd fe             	bsr    %esi,%edi
  803e3f:	83 f7 1f             	xor    $0x1f,%edi
  803e42:	75 40                	jne    803e84 <__udivdi3+0x9c>
  803e44:	39 ce                	cmp    %ecx,%esi
  803e46:	72 0a                	jb     803e52 <__udivdi3+0x6a>
  803e48:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e4c:	0f 87 9e 00 00 00    	ja     803ef0 <__udivdi3+0x108>
  803e52:	b8 01 00 00 00       	mov    $0x1,%eax
  803e57:	89 fa                	mov    %edi,%edx
  803e59:	83 c4 1c             	add    $0x1c,%esp
  803e5c:	5b                   	pop    %ebx
  803e5d:	5e                   	pop    %esi
  803e5e:	5f                   	pop    %edi
  803e5f:	5d                   	pop    %ebp
  803e60:	c3                   	ret    
  803e61:	8d 76 00             	lea    0x0(%esi),%esi
  803e64:	31 ff                	xor    %edi,%edi
  803e66:	31 c0                	xor    %eax,%eax
  803e68:	89 fa                	mov    %edi,%edx
  803e6a:	83 c4 1c             	add    $0x1c,%esp
  803e6d:	5b                   	pop    %ebx
  803e6e:	5e                   	pop    %esi
  803e6f:	5f                   	pop    %edi
  803e70:	5d                   	pop    %ebp
  803e71:	c3                   	ret    
  803e72:	66 90                	xchg   %ax,%ax
  803e74:	89 d8                	mov    %ebx,%eax
  803e76:	f7 f7                	div    %edi
  803e78:	31 ff                	xor    %edi,%edi
  803e7a:	89 fa                	mov    %edi,%edx
  803e7c:	83 c4 1c             	add    $0x1c,%esp
  803e7f:	5b                   	pop    %ebx
  803e80:	5e                   	pop    %esi
  803e81:	5f                   	pop    %edi
  803e82:	5d                   	pop    %ebp
  803e83:	c3                   	ret    
  803e84:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e89:	89 eb                	mov    %ebp,%ebx
  803e8b:	29 fb                	sub    %edi,%ebx
  803e8d:	89 f9                	mov    %edi,%ecx
  803e8f:	d3 e6                	shl    %cl,%esi
  803e91:	89 c5                	mov    %eax,%ebp
  803e93:	88 d9                	mov    %bl,%cl
  803e95:	d3 ed                	shr    %cl,%ebp
  803e97:	89 e9                	mov    %ebp,%ecx
  803e99:	09 f1                	or     %esi,%ecx
  803e9b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e9f:	89 f9                	mov    %edi,%ecx
  803ea1:	d3 e0                	shl    %cl,%eax
  803ea3:	89 c5                	mov    %eax,%ebp
  803ea5:	89 d6                	mov    %edx,%esi
  803ea7:	88 d9                	mov    %bl,%cl
  803ea9:	d3 ee                	shr    %cl,%esi
  803eab:	89 f9                	mov    %edi,%ecx
  803ead:	d3 e2                	shl    %cl,%edx
  803eaf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eb3:	88 d9                	mov    %bl,%cl
  803eb5:	d3 e8                	shr    %cl,%eax
  803eb7:	09 c2                	or     %eax,%edx
  803eb9:	89 d0                	mov    %edx,%eax
  803ebb:	89 f2                	mov    %esi,%edx
  803ebd:	f7 74 24 0c          	divl   0xc(%esp)
  803ec1:	89 d6                	mov    %edx,%esi
  803ec3:	89 c3                	mov    %eax,%ebx
  803ec5:	f7 e5                	mul    %ebp
  803ec7:	39 d6                	cmp    %edx,%esi
  803ec9:	72 19                	jb     803ee4 <__udivdi3+0xfc>
  803ecb:	74 0b                	je     803ed8 <__udivdi3+0xf0>
  803ecd:	89 d8                	mov    %ebx,%eax
  803ecf:	31 ff                	xor    %edi,%edi
  803ed1:	e9 58 ff ff ff       	jmp    803e2e <__udivdi3+0x46>
  803ed6:	66 90                	xchg   %ax,%ax
  803ed8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803edc:	89 f9                	mov    %edi,%ecx
  803ede:	d3 e2                	shl    %cl,%edx
  803ee0:	39 c2                	cmp    %eax,%edx
  803ee2:	73 e9                	jae    803ecd <__udivdi3+0xe5>
  803ee4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ee7:	31 ff                	xor    %edi,%edi
  803ee9:	e9 40 ff ff ff       	jmp    803e2e <__udivdi3+0x46>
  803eee:	66 90                	xchg   %ax,%ax
  803ef0:	31 c0                	xor    %eax,%eax
  803ef2:	e9 37 ff ff ff       	jmp    803e2e <__udivdi3+0x46>
  803ef7:	90                   	nop

00803ef8 <__umoddi3>:
  803ef8:	55                   	push   %ebp
  803ef9:	57                   	push   %edi
  803efa:	56                   	push   %esi
  803efb:	53                   	push   %ebx
  803efc:	83 ec 1c             	sub    $0x1c,%esp
  803eff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f03:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f13:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f17:	89 f3                	mov    %esi,%ebx
  803f19:	89 fa                	mov    %edi,%edx
  803f1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f1f:	89 34 24             	mov    %esi,(%esp)
  803f22:	85 c0                	test   %eax,%eax
  803f24:	75 1a                	jne    803f40 <__umoddi3+0x48>
  803f26:	39 f7                	cmp    %esi,%edi
  803f28:	0f 86 a2 00 00 00    	jbe    803fd0 <__umoddi3+0xd8>
  803f2e:	89 c8                	mov    %ecx,%eax
  803f30:	89 f2                	mov    %esi,%edx
  803f32:	f7 f7                	div    %edi
  803f34:	89 d0                	mov    %edx,%eax
  803f36:	31 d2                	xor    %edx,%edx
  803f38:	83 c4 1c             	add    $0x1c,%esp
  803f3b:	5b                   	pop    %ebx
  803f3c:	5e                   	pop    %esi
  803f3d:	5f                   	pop    %edi
  803f3e:	5d                   	pop    %ebp
  803f3f:	c3                   	ret    
  803f40:	39 f0                	cmp    %esi,%eax
  803f42:	0f 87 ac 00 00 00    	ja     803ff4 <__umoddi3+0xfc>
  803f48:	0f bd e8             	bsr    %eax,%ebp
  803f4b:	83 f5 1f             	xor    $0x1f,%ebp
  803f4e:	0f 84 ac 00 00 00    	je     804000 <__umoddi3+0x108>
  803f54:	bf 20 00 00 00       	mov    $0x20,%edi
  803f59:	29 ef                	sub    %ebp,%edi
  803f5b:	89 fe                	mov    %edi,%esi
  803f5d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f61:	89 e9                	mov    %ebp,%ecx
  803f63:	d3 e0                	shl    %cl,%eax
  803f65:	89 d7                	mov    %edx,%edi
  803f67:	89 f1                	mov    %esi,%ecx
  803f69:	d3 ef                	shr    %cl,%edi
  803f6b:	09 c7                	or     %eax,%edi
  803f6d:	89 e9                	mov    %ebp,%ecx
  803f6f:	d3 e2                	shl    %cl,%edx
  803f71:	89 14 24             	mov    %edx,(%esp)
  803f74:	89 d8                	mov    %ebx,%eax
  803f76:	d3 e0                	shl    %cl,%eax
  803f78:	89 c2                	mov    %eax,%edx
  803f7a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f7e:	d3 e0                	shl    %cl,%eax
  803f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f84:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f88:	89 f1                	mov    %esi,%ecx
  803f8a:	d3 e8                	shr    %cl,%eax
  803f8c:	09 d0                	or     %edx,%eax
  803f8e:	d3 eb                	shr    %cl,%ebx
  803f90:	89 da                	mov    %ebx,%edx
  803f92:	f7 f7                	div    %edi
  803f94:	89 d3                	mov    %edx,%ebx
  803f96:	f7 24 24             	mull   (%esp)
  803f99:	89 c6                	mov    %eax,%esi
  803f9b:	89 d1                	mov    %edx,%ecx
  803f9d:	39 d3                	cmp    %edx,%ebx
  803f9f:	0f 82 87 00 00 00    	jb     80402c <__umoddi3+0x134>
  803fa5:	0f 84 91 00 00 00    	je     80403c <__umoddi3+0x144>
  803fab:	8b 54 24 04          	mov    0x4(%esp),%edx
  803faf:	29 f2                	sub    %esi,%edx
  803fb1:	19 cb                	sbb    %ecx,%ebx
  803fb3:	89 d8                	mov    %ebx,%eax
  803fb5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803fb9:	d3 e0                	shl    %cl,%eax
  803fbb:	89 e9                	mov    %ebp,%ecx
  803fbd:	d3 ea                	shr    %cl,%edx
  803fbf:	09 d0                	or     %edx,%eax
  803fc1:	89 e9                	mov    %ebp,%ecx
  803fc3:	d3 eb                	shr    %cl,%ebx
  803fc5:	89 da                	mov    %ebx,%edx
  803fc7:	83 c4 1c             	add    $0x1c,%esp
  803fca:	5b                   	pop    %ebx
  803fcb:	5e                   	pop    %esi
  803fcc:	5f                   	pop    %edi
  803fcd:	5d                   	pop    %ebp
  803fce:	c3                   	ret    
  803fcf:	90                   	nop
  803fd0:	89 fd                	mov    %edi,%ebp
  803fd2:	85 ff                	test   %edi,%edi
  803fd4:	75 0b                	jne    803fe1 <__umoddi3+0xe9>
  803fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  803fdb:	31 d2                	xor    %edx,%edx
  803fdd:	f7 f7                	div    %edi
  803fdf:	89 c5                	mov    %eax,%ebp
  803fe1:	89 f0                	mov    %esi,%eax
  803fe3:	31 d2                	xor    %edx,%edx
  803fe5:	f7 f5                	div    %ebp
  803fe7:	89 c8                	mov    %ecx,%eax
  803fe9:	f7 f5                	div    %ebp
  803feb:	89 d0                	mov    %edx,%eax
  803fed:	e9 44 ff ff ff       	jmp    803f36 <__umoddi3+0x3e>
  803ff2:	66 90                	xchg   %ax,%ax
  803ff4:	89 c8                	mov    %ecx,%eax
  803ff6:	89 f2                	mov    %esi,%edx
  803ff8:	83 c4 1c             	add    $0x1c,%esp
  803ffb:	5b                   	pop    %ebx
  803ffc:	5e                   	pop    %esi
  803ffd:	5f                   	pop    %edi
  803ffe:	5d                   	pop    %ebp
  803fff:	c3                   	ret    
  804000:	3b 04 24             	cmp    (%esp),%eax
  804003:	72 06                	jb     80400b <__umoddi3+0x113>
  804005:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804009:	77 0f                	ja     80401a <__umoddi3+0x122>
  80400b:	89 f2                	mov    %esi,%edx
  80400d:	29 f9                	sub    %edi,%ecx
  80400f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804013:	89 14 24             	mov    %edx,(%esp)
  804016:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80401a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80401e:	8b 14 24             	mov    (%esp),%edx
  804021:	83 c4 1c             	add    $0x1c,%esp
  804024:	5b                   	pop    %ebx
  804025:	5e                   	pop    %esi
  804026:	5f                   	pop    %edi
  804027:	5d                   	pop    %ebp
  804028:	c3                   	ret    
  804029:	8d 76 00             	lea    0x0(%esi),%esi
  80402c:	2b 04 24             	sub    (%esp),%eax
  80402f:	19 fa                	sbb    %edi,%edx
  804031:	89 d1                	mov    %edx,%ecx
  804033:	89 c6                	mov    %eax,%esi
  804035:	e9 71 ff ff ff       	jmp    803fab <__umoddi3+0xb3>
  80403a:	66 90                	xchg   %ax,%ax
  80403c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804040:	72 ea                	jb     80402c <__umoddi3+0x134>
  804042:	89 d9                	mov    %ebx,%ecx
  804044:	e9 62 ff ff ff       	jmp    803fab <__umoddi3+0xb3>
