
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
  80005c:	68 40 40 80 00       	push   $0x804040
  800061:	6a 13                	push   $0x13
  800063:	68 5c 40 80 00       	push   $0x80405c
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
  800085:	68 74 40 80 00       	push   $0x804074
  80008a:	e8 23 0a 00 00       	call   800ab2 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	68 a8 40 80 00       	push   $0x8040a8
  80009a:	e8 13 0a 00 00       	call   800ab2 <cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 04 41 80 00       	push   $0x804104
  8000aa:	e8 03 0a 00 00       	call   800ab2 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000b2:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000b9:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	int envID = sys_getenvid();
  8000c0:	e8 1f 1f 00 00       	call   801fe4 <sys_getenvid>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000c8:	83 ec 0c             	sub    $0xc,%esp
  8000cb:	68 38 41 80 00       	push   $0x804138
  8000d0:	e8 dd 09 00 00       	call   800ab2 <cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 57 1d 00 00       	call   801e34 <sys_calculate_free_frames>
  8000dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 01                	push   $0x1
  8000e5:	68 00 10 00 00       	push   $0x1000
  8000ea:	68 6c 41 80 00       	push   $0x80416c
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
  80010c:	68 70 41 80 00       	push   $0x804170
  800111:	e8 9c 09 00 00       	call   800ab2 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  800119:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800120:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800123:	e8 0c 1d 00 00       	call   801e34 <sys_calculate_free_frames>
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
  80014c:	e8 e3 1c 00 00       	call   801e34 <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015b:	50                   	push   %eax
  80015c:	68 dc 41 80 00       	push   $0x8041dc
  800161:	e8 4c 09 00 00       	call   800ab2 <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	ff 75 d8             	pushl  -0x28(%ebp)
  80016f:	e8 0f 1b 00 00       	call   801c83 <sfree>
  800174:	83 c4 10             	add    $0x10,%esp
		expected = 0 ;
  800177:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80017e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800181:	e8 ae 1c 00 00       	call   801e34 <sys_calculate_free_frames>
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
  80019f:	e8 90 1c 00 00       	call   801e34 <sys_calculate_free_frames>
  8001a4:	29 c3                	sub    %eax,%ebx
  8001a6:	89 d8                	mov    %ebx,%eax
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	50                   	push   %eax
  8001ac:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001af:	68 74 42 80 00       	push   $0x804274
  8001b4:	e8 f9 08 00 00       	call   800ab2 <cprintf>
  8001b9:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step A completed!!\n\n\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 bf 42 80 00       	push   $0x8042bf
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
  8001e0:	68 d8 42 80 00       	push   $0x8042d8
  8001e5:	e8 c8 08 00 00       	call   800ab2 <cprintf>
  8001ea:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  8001ed:	e8 42 1c 00 00       	call   801e34 <sys_calculate_free_frames>
  8001f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	6a 01                	push   $0x1
  8001fa:	68 00 10 00 00       	push   $0x1000
  8001ff:	68 0d 43 80 00       	push   $0x80430d
  800204:	e8 76 19 00 00       	call   801b7f <smalloc>
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	6a 01                	push   $0x1
  800214:	68 00 10 00 00       	push   $0x1000
  800219:	68 6c 41 80 00       	push   $0x80416c
  80021e:	e8 5c 19 00 00       	call   801b7f <smalloc>
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if(x == NULL)
  800229:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80022d:	75 17                	jne    800246 <_main+0x20e>
		{is_correct = 0; cprintf("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  80022f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 10 43 80 00       	push   $0x804310
  80023e:	e8 6f 08 00 00       	call   800ab2 <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp

		expected = 2+1 ; /*2pages +1table*/
  800246:	c7 45 d4 03 00 00 00 	movl   $0x3,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80024d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800250:	e8 df 1b 00 00       	call   801e34 <sys_calculate_free_frames>
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
  800279:	68 68 43 80 00       	push   $0x804368
  80027e:	e8 2f 08 00 00       	call   800ab2 <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp

		sfree(z);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 75 c8             	pushl  -0x38(%ebp)
  80028c:	e8 f2 19 00 00       	call   801c83 <sfree>
  800291:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800294:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80029b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80029e:	e8 91 1b 00 00       	call   801e34 <sys_calculate_free_frames>
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
  8002bc:	e8 73 1b 00 00       	call   801e34 <sys_calculate_free_frames>
  8002c1:	29 c3                	sub    %eax,%ebx
  8002c3:	89 d8                	mov    %ebx,%eax
  8002c5:	83 ec 04             	sub    $0x4,%esp
  8002c8:	50                   	push   %eax
  8002c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cc:	68 74 42 80 00       	push   $0x804274
  8002d1:	e8 dc 07 00 00       	call   800ab2 <cprintf>
  8002d6:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002df:	e8 9f 19 00 00       	call   801c83 <sfree>
  8002e4:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8002e7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8002ee:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002f1:	e8 3e 1b 00 00       	call   801e34 <sys_calculate_free_frames>
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
  80030f:	e8 20 1b 00 00       	call   801e34 <sys_calculate_free_frames>
  800314:	29 c3                	sub    %eax,%ebx
  800316:	89 d8                	mov    %ebx,%eax
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	50                   	push   %eax
  80031c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031f:	68 74 42 80 00       	push   $0x804274
  800324:	e8 89 07 00 00       	call   800ab2 <cprintf>
  800329:	83 c4 10             	add    $0x10,%esp

	}
	cprintf("Step B completed!!\n\n\n");
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	68 bd 43 80 00       	push   $0x8043bd
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
  800350:	68 d4 43 80 00       	push   $0x8043d4
  800355:	e8 58 07 00 00       	call   800ab2 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80035d:	e8 d2 1a 00 00       	call   801e34 <sys_calculate_free_frames>
  800362:	89 45 c0             	mov    %eax,-0x40(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	6a 01                	push   $0x1
  80036a:	68 01 30 00 00       	push   $0x3001
  80036f:	68 09 44 80 00       	push   $0x804409
  800374:	e8 06 18 00 00       	call   801b7f <smalloc>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	6a 01                	push   $0x1
  800384:	68 00 10 00 00       	push   $0x1000
  800389:	68 0b 44 80 00       	push   $0x80440b
  80038e:	e8 ec 17 00 00       	call   801b7f <smalloc>
  800393:	83 c4 10             	add    $0x10,%esp
  800396:	89 45 b8             	mov    %eax,-0x48(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  800399:	c7 45 d4 06 00 00 00 	movl   $0x6,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003a0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8003a3:	e8 8c 1a 00 00       	call   801e34 <sys_calculate_free_frames>
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
  8003cc:	e8 63 1a 00 00       	call   801e34 <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 ec 04             	sub    $0x4,%esp
  8003d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	68 dc 41 80 00       	push   $0x8041dc
  8003e1:	e8 cc 06 00 00       	call   800ab2 <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp

		sfree(w);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	ff 75 bc             	pushl  -0x44(%ebp)
  8003ef:	e8 8f 18 00 00       	call   801c83 <sfree>
  8003f4:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8003f7:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003fe:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800401:	e8 2e 1a 00 00       	call   801e34 <sys_calculate_free_frames>
  800406:	29 c3                	sub    %eax,%ebx
  800408:	89 d8                	mov    %ebx,%eax
  80040a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  80040d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800410:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800413:	74 27                	je     80043c <_main+0x404>
  800415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80041c:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80041f:	e8 10 1a 00 00       	call   801e34 <sys_calculate_free_frames>
  800424:	29 c3                	sub    %eax,%ebx
  800426:	89 d8                	mov    %ebx,%eax
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	50                   	push   %eax
  80042c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80042f:	68 74 42 80 00       	push   $0x804274
  800434:	e8 79 06 00 00       	call   800ab2 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80043c:	83 ec 04             	sub    $0x4,%esp
  80043f:	6a 01                	push   $0x1
  800441:	68 ff 1f 00 00       	push   $0x1fff
  800446:	68 0d 44 80 00       	push   $0x80440d
  80044b:	e8 2f 17 00 00       	call   801b7f <smalloc>
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800456:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80045d:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800460:	e8 cf 19 00 00       	call   801e34 <sys_calculate_free_frames>
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
  80047e:	e8 b1 19 00 00       	call   801e34 <sys_calculate_free_frames>
  800483:	29 c3                	sub    %eax,%ebx
  800485:	89 d8                	mov    %ebx,%eax
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80048d:	50                   	push   %eax
  80048e:	68 dc 41 80 00       	push   $0x8041dc
  800493:	e8 1a 06 00 00       	call   800ab2 <cprintf>
  800498:	83 c4 10             	add    $0x10,%esp

		sfree(o);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004a1:	e8 dd 17 00 00       	call   801c83 <sfree>
  8004a6:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8004a9:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004b0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004b3:	e8 7c 19 00 00       	call   801e34 <sys_calculate_free_frames>
  8004b8:	29 c3                	sub    %eax,%ebx
  8004ba:	89 d8                	mov    %ebx,%eax
  8004bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004c5:	74 27                	je     8004ee <_main+0x4b6>
  8004c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ce:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004d1:	e8 5e 19 00 00       	call   801e34 <sys_calculate_free_frames>
  8004d6:	29 c3                	sub    %eax,%ebx
  8004d8:	89 d8                	mov    %ebx,%eax
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	50                   	push   %eax
  8004de:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004e1:	68 74 42 80 00       	push   $0x804274
  8004e6:	e8 c7 05 00 00       	call   800ab2 <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp

		sfree(u);
  8004ee:	83 ec 0c             	sub    $0xc,%esp
  8004f1:	ff 75 b8             	pushl  -0x48(%ebp)
  8004f4:	e8 8a 17 00 00       	call   801c83 <sfree>
  8004f9:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8004fc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800503:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800506:	e8 29 19 00 00       	call   801e34 <sys_calculate_free_frames>
  80050b:	29 c3                	sub    %eax,%ebx
  80050d:	89 d8                	mov    %ebx,%eax
  80050f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800512:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800515:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800518:	74 27                	je     800541 <_main+0x509>
  80051a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800521:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800524:	e8 0b 19 00 00       	call   801e34 <sys_calculate_free_frames>
  800529:	29 c3                	sub    %eax,%ebx
  80052b:	89 d8                	mov    %ebx,%eax
  80052d:	83 ec 04             	sub    $0x4,%esp
  800530:	50                   	push   %eax
  800531:	ff 75 d4             	pushl  -0x2c(%ebp)
  800534:	68 74 42 80 00       	push   $0x804274
  800539:	e8 74 05 00 00       	call   800ab2 <cprintf>
  80053e:	83 c4 10             	add    $0x10,%esp


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800541:	e8 ee 18 00 00       	call   801e34 <sys_calculate_free_frames>
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
  80055b:	68 09 44 80 00       	push   $0x804409
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
  800581:	68 0b 44 80 00       	push   $0x80440b
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
  8005a3:	68 0d 44 80 00       	push   $0x80440d
  8005a8:	e8 d2 15 00 00       	call   801b7f <smalloc>
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  8005b3:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8005ba:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8005bd:	e8 72 18 00 00       	call   801e34 <sys_calculate_free_frames>
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
  8005e6:	e8 49 18 00 00       	call   801e34 <sys_calculate_free_frames>
  8005eb:	29 c3                	sub    %eax,%ebx
  8005ed:	89 d8                	mov    %ebx,%eax
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005f5:	50                   	push   %eax
  8005f6:	68 dc 41 80 00       	push   $0x8041dc
  8005fb:	e8 b2 04 00 00       	call   800ab2 <cprintf>
  800600:	83 c4 10             	add    $0x10,%esp

		freeFrames = sys_calculate_free_frames() ;
  800603:	e8 2c 18 00 00       	call   801e34 <sys_calculate_free_frames>
  800608:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(o);
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	ff 75 b4             	pushl  -0x4c(%ebp)
  800611:	e8 6d 16 00 00       	call   801c83 <sfree>
  800616:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(w);
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	ff 75 bc             	pushl  -0x44(%ebp)
  80061f:	e8 5f 16 00 00       	call   801c83 <sfree>
  800624:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(u);
  800627:	83 ec 0c             	sub    $0xc,%esp
  80062a:	ff 75 b8             	pushl  -0x48(%ebp)
  80062d:	e8 51 16 00 00       	call   801c83 <sfree>
  800632:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  800635:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  80063c:	e8 f3 17 00 00       	call   801e34 <sys_calculate_free_frames>
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
  80065f:	e8 d0 17 00 00       	call   801e34 <sys_calculate_free_frames>
  800664:	29 c3                	sub    %eax,%ebx
  800666:	89 d8                	mov    %ebx,%eax
  800668:	83 ec 04             	sub    $0x4,%esp
  80066b:	50                   	push   %eax
  80066c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80066f:	68 74 42 80 00       	push   $0x804274
  800674:	e8 39 04 00 00       	call   800ab2 <cprintf>
  800679:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step C completed!!\n\n\n");
  80067c:	83 ec 0c             	sub    $0xc,%esp
  80067f:	68 0f 44 80 00       	push   $0x80440f
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
  8006a3:	68 28 44 80 00       	push   $0x804428
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
  8006bc:	e8 3c 19 00 00       	call   801ffd <sys_getenvindex>
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
  80072a:	e8 52 16 00 00       	call   801d81 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	68 7c 44 80 00       	push   $0x80447c
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
  80075a:	68 a4 44 80 00       	push   $0x8044a4
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
  80078b:	68 cc 44 80 00       	push   $0x8044cc
  800790:	e8 1d 03 00 00       	call   800ab2 <cprintf>
  800795:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800798:	a1 20 50 80 00       	mov    0x805020,%eax
  80079d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	50                   	push   %eax
  8007a7:	68 24 45 80 00       	push   $0x804524
  8007ac:	e8 01 03 00 00       	call   800ab2 <cprintf>
  8007b1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8007b4:	83 ec 0c             	sub    $0xc,%esp
  8007b7:	68 7c 44 80 00       	push   $0x80447c
  8007bc:	e8 f1 02 00 00       	call   800ab2 <cprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8007c4:	e8 d2 15 00 00       	call   801d9b <sys_unlock_cons>
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
  8007dc:	e8 e8 17 00 00       	call   801fc9 <sys_destroy_env>
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
  8007ed:	e8 3d 18 00 00       	call   80202f <sys_exit_env>
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
  800816:	68 38 45 80 00       	push   $0x804538
  80081b:	e8 92 02 00 00       	call   800ab2 <cprintf>
  800820:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800823:	a1 00 50 80 00       	mov    0x805000,%eax
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	50                   	push   %eax
  80082f:	68 3d 45 80 00       	push   $0x80453d
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
  800853:	68 59 45 80 00       	push   $0x804559
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
  800882:	68 5c 45 80 00       	push   $0x80455c
  800887:	6a 26                	push   $0x26
  800889:	68 a8 45 80 00       	push   $0x8045a8
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
  800957:	68 b4 45 80 00       	push   $0x8045b4
  80095c:	6a 3a                	push   $0x3a
  80095e:	68 a8 45 80 00       	push   $0x8045a8
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
  8009ca:	68 08 46 80 00       	push   $0x804608
  8009cf:	6a 44                	push   $0x44
  8009d1:	68 a8 45 80 00       	push   $0x8045a8
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
  800a24:	e8 16 13 00 00       	call   801d3f <sys_cputs>
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
  800a9b:	e8 9f 12 00 00       	call   801d3f <sys_cputs>
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
  800ae5:	e8 97 12 00 00       	call   801d81 <sys_lock_cons>
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
  800b05:	e8 91 12 00 00       	call   801d9b <sys_unlock_cons>
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
  800b4f:	e8 84 32 00 00       	call   803dd8 <__udivdi3>
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
  800b9f:	e8 44 33 00 00       	call   803ee8 <__umoddi3>
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	05 74 48 80 00       	add    $0x804874,%eax
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
  800cfa:	8b 04 85 98 48 80 00 	mov    0x804898(,%eax,4),%eax
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
  800ddb:	8b 34 9d e0 46 80 00 	mov    0x8046e0(,%ebx,4),%esi
  800de2:	85 f6                	test   %esi,%esi
  800de4:	75 19                	jne    800dff <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800de6:	53                   	push   %ebx
  800de7:	68 85 48 80 00       	push   $0x804885
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
  800e00:	68 8e 48 80 00       	push   $0x80488e
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
  800e2d:	be 91 48 80 00       	mov    $0x804891,%esi
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
  801838:	68 08 4a 80 00       	push   $0x804a08
  80183d:	68 3f 01 00 00       	push   $0x13f
  801842:	68 2a 4a 80 00       	push   $0x804a2a
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
  801858:	e8 8d 0a 00 00       	call   8022ea <sys_sbrk>
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
  8018d3:	e8 96 08 00 00       	call   80216e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	74 16                	je     8018f2 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8018dc:	83 ec 0c             	sub    $0xc,%esp
  8018df:	ff 75 08             	pushl  0x8(%ebp)
  8018e2:	e8 d6 0d 00 00       	call   8026bd <alloc_block_FF>
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018ed:	e9 8a 01 00 00       	jmp    801a7c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8018f2:	e8 a8 08 00 00       	call   80219f <sys_isUHeapPlacementStrategyBESTFIT>
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	0f 84 7d 01 00 00    	je     801a7c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	e8 6f 12 00 00       	call   802b79 <alloc_block_BF>
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
  801a6b:	e8 b1 08 00 00       	call   802321 <sys_allocate_user_mem>
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
  801ab3:	e8 85 08 00 00       	call   80233d <get_block_size>
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801abe:	83 ec 0c             	sub    $0xc,%esp
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	e8 b8 1a 00 00       	call   803581 <free_block>
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
  801b5b:	e8 a5 07 00 00       	call   802305 <sys_free_user_mem>
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
  801b69:	68 38 4a 80 00       	push   $0x804a38
  801b6e:	68 84 00 00 00       	push   $0x84
  801b73:	68 62 4a 80 00       	push   $0x804a62
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
  801b96:	eb 64                	jmp    801bfc <smalloc+0x7d>
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
  801bcb:	eb 2f                	jmp    801bfc <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801bcd:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801bd1:	ff 75 ec             	pushl  -0x14(%ebp)
  801bd4:	50                   	push   %eax
  801bd5:	ff 75 0c             	pushl  0xc(%ebp)
  801bd8:	ff 75 08             	pushl  0x8(%ebp)
  801bdb:	e8 2c 03 00 00       	call   801f0c <sys_createSharedObject>
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801be6:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801bea:	74 06                	je     801bf2 <smalloc+0x73>
  801bec:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801bf0:	75 07                	jne    801bf9 <smalloc+0x7a>
  801bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf7:	eb 03                	jmp    801bfc <smalloc+0x7d>
	 return ptr;
  801bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c04:	83 ec 08             	sub    $0x8,%esp
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	ff 75 08             	pushl  0x8(%ebp)
  801c0d:	e8 24 03 00 00       	call   801f36 <sys_getSizeOfSharedObject>
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801c18:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c1c:	75 07                	jne    801c25 <sget+0x27>
  801c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c23:	eb 5c                	jmp    801c81 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c2b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c38:	39 d0                	cmp    %edx,%eax
  801c3a:	7d 02                	jge    801c3e <sget+0x40>
  801c3c:	89 d0                	mov    %edx,%eax
  801c3e:	83 ec 0c             	sub    $0xc,%esp
  801c41:	50                   	push   %eax
  801c42:	e8 1b fc ff ff       	call   801862 <malloc>
  801c47:	83 c4 10             	add    $0x10,%esp
  801c4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801c4d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c51:	75 07                	jne    801c5a <sget+0x5c>
  801c53:	b8 00 00 00 00       	mov    $0x0,%eax
  801c58:	eb 27                	jmp    801c81 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	ff 75 e8             	pushl  -0x18(%ebp)
  801c60:	ff 75 0c             	pushl  0xc(%ebp)
  801c63:	ff 75 08             	pushl  0x8(%ebp)
  801c66:	e8 e8 02 00 00       	call   801f53 <sys_getSharedObject>
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801c71:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801c75:	75 07                	jne    801c7e <sget+0x80>
  801c77:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7c:	eb 03                	jmp    801c81 <sget+0x83>
	return ptr;
  801c7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c89:	83 ec 04             	sub    $0x4,%esp
  801c8c:	68 70 4a 80 00       	push   $0x804a70
  801c91:	68 c1 00 00 00       	push   $0xc1
  801c96:	68 62 4a 80 00       	push   $0x804a62
  801c9b:	e8 55 eb ff ff       	call   8007f5 <_panic>

00801ca0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ca6:	83 ec 04             	sub    $0x4,%esp
  801ca9:	68 94 4a 80 00       	push   $0x804a94
  801cae:	68 d8 00 00 00       	push   $0xd8
  801cb3:	68 62 4a 80 00       	push   $0x804a62
  801cb8:	e8 38 eb ff ff       	call   8007f5 <_panic>

00801cbd <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cc3:	83 ec 04             	sub    $0x4,%esp
  801cc6:	68 ba 4a 80 00       	push   $0x804aba
  801ccb:	68 e4 00 00 00       	push   $0xe4
  801cd0:	68 62 4a 80 00       	push   $0x804a62
  801cd5:	e8 1b eb ff ff       	call   8007f5 <_panic>

00801cda <shrink>:

}
void shrink(uint32 newSize)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ce0:	83 ec 04             	sub    $0x4,%esp
  801ce3:	68 ba 4a 80 00       	push   $0x804aba
  801ce8:	68 e9 00 00 00       	push   $0xe9
  801ced:	68 62 4a 80 00       	push   $0x804a62
  801cf2:	e8 fe ea ff ff       	call   8007f5 <_panic>

00801cf7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	68 ba 4a 80 00       	push   $0x804aba
  801d05:	68 ee 00 00 00       	push   $0xee
  801d0a:	68 62 4a 80 00       	push   $0x804a62
  801d0f:	e8 e1 ea ff ff       	call   8007f5 <_panic>

00801d14 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	57                   	push   %edi
  801d18:	56                   	push   %esi
  801d19:	53                   	push   %ebx
  801d1a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d26:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d29:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d2c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d2f:	cd 30                	int    $0x30
  801d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	5b                   	pop    %ebx
  801d3b:	5e                   	pop    %esi
  801d3c:	5f                   	pop    %edi
  801d3d:	5d                   	pop    %ebp
  801d3e:	c3                   	ret    

00801d3f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 04             	sub    $0x4,%esp
  801d45:	8b 45 10             	mov    0x10(%ebp),%eax
  801d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d4b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	52                   	push   %edx
  801d57:	ff 75 0c             	pushl  0xc(%ebp)
  801d5a:	50                   	push   %eax
  801d5b:	6a 00                	push   $0x0
  801d5d:	e8 b2 ff ff ff       	call   801d14 <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	90                   	nop
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 02                	push   $0x2
  801d77:	e8 98 ff ff ff       	call   801d14 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 03                	push   $0x3
  801d90:	e8 7f ff ff ff       	call   801d14 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	90                   	nop
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 04                	push   $0x4
  801daa:	e8 65 ff ff ff       	call   801d14 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
}
  801db2:	90                   	nop
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	52                   	push   %edx
  801dc5:	50                   	push   %eax
  801dc6:	6a 08                	push   $0x8
  801dc8:	e8 47 ff ff ff       	call   801d14 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	56                   	push   %esi
  801dd6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dd7:	8b 75 18             	mov    0x18(%ebp),%esi
  801dda:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ddd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	56                   	push   %esi
  801de7:	53                   	push   %ebx
  801de8:	51                   	push   %ecx
  801de9:	52                   	push   %edx
  801dea:	50                   	push   %eax
  801deb:	6a 09                	push   $0x9
  801ded:	e8 22 ff ff ff       	call   801d14 <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
}
  801df5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df8:	5b                   	pop    %ebx
  801df9:	5e                   	pop    %esi
  801dfa:	5d                   	pop    %ebp
  801dfb:	c3                   	ret    

00801dfc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e02:	8b 45 08             	mov    0x8(%ebp),%eax
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	52                   	push   %edx
  801e0c:	50                   	push   %eax
  801e0d:	6a 0a                	push   $0xa
  801e0f:	e8 00 ff ff ff       	call   801d14 <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	ff 75 0c             	pushl  0xc(%ebp)
  801e25:	ff 75 08             	pushl  0x8(%ebp)
  801e28:	6a 0b                	push   $0xb
  801e2a:	e8 e5 fe ff ff       	call   801d14 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 0c                	push   $0xc
  801e43:	e8 cc fe ff ff       	call   801d14 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 0d                	push   $0xd
  801e5c:	e8 b3 fe ff ff       	call   801d14 <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 0e                	push   $0xe
  801e75:	e8 9a fe ff ff       	call   801d14 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 0f                	push   $0xf
  801e8e:	e8 81 fe ff ff       	call   801d14 <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	ff 75 08             	pushl  0x8(%ebp)
  801ea6:	6a 10                	push   $0x10
  801ea8:	e8 67 fe ff ff       	call   801d14 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 11                	push   $0x11
  801ec1:	e8 4e fe ff ff       	call   801d14 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	90                   	nop
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_cputc>:

void
sys_cputc(const char c)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 04             	sub    $0x4,%esp
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ed8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	50                   	push   %eax
  801ee5:	6a 01                	push   $0x1
  801ee7:	e8 28 fe ff ff       	call   801d14 <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	90                   	nop
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 14                	push   $0x14
  801f01:	e8 0e fe ff ff       	call   801d14 <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
}
  801f09:	90                   	nop
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 04             	sub    $0x4,%esp
  801f12:	8b 45 10             	mov    0x10(%ebp),%eax
  801f15:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f18:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f1b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	6a 00                	push   $0x0
  801f24:	51                   	push   %ecx
  801f25:	52                   	push   %edx
  801f26:	ff 75 0c             	pushl  0xc(%ebp)
  801f29:	50                   	push   %eax
  801f2a:	6a 15                	push   $0x15
  801f2c:	e8 e3 fd ff ff       	call   801d14 <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	52                   	push   %edx
  801f46:	50                   	push   %eax
  801f47:	6a 16                	push   $0x16
  801f49:	e8 c6 fd ff ff       	call   801d14 <syscall>
  801f4e:	83 c4 18             	add    $0x18,%esp
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	51                   	push   %ecx
  801f64:	52                   	push   %edx
  801f65:	50                   	push   %eax
  801f66:	6a 17                	push   $0x17
  801f68:	e8 a7 fd ff ff       	call   801d14 <syscall>
  801f6d:	83 c4 18             	add    $0x18,%esp
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	52                   	push   %edx
  801f82:	50                   	push   %eax
  801f83:	6a 18                	push   $0x18
  801f85:	e8 8a fd ff ff       	call   801d14 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	6a 00                	push   $0x0
  801f97:	ff 75 14             	pushl  0x14(%ebp)
  801f9a:	ff 75 10             	pushl  0x10(%ebp)
  801f9d:	ff 75 0c             	pushl  0xc(%ebp)
  801fa0:	50                   	push   %eax
  801fa1:	6a 19                	push   $0x19
  801fa3:	e8 6c fd ff ff       	call   801d14 <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_run_env>:

void sys_run_env(int32 envId)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	50                   	push   %eax
  801fbc:	6a 1a                	push   $0x1a
  801fbe:	e8 51 fd ff ff       	call   801d14 <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
}
  801fc6:	90                   	nop
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	50                   	push   %eax
  801fd8:	6a 1b                	push   $0x1b
  801fda:	e8 35 fd ff ff       	call   801d14 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 05                	push   $0x5
  801ff3:	e8 1c fd ff ff       	call   801d14 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 06                	push   $0x6
  80200c:	e8 03 fd ff ff       	call   801d14 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 07                	push   $0x7
  802025:	e8 ea fc ff ff       	call   801d14 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_exit_env>:


void sys_exit_env(void)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 1c                	push   $0x1c
  80203e:	e8 d1 fc ff ff       	call   801d14 <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	90                   	nop
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80204f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802052:	8d 50 04             	lea    0x4(%eax),%edx
  802055:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	52                   	push   %edx
  80205f:	50                   	push   %eax
  802060:	6a 1d                	push   $0x1d
  802062:	e8 ad fc ff ff       	call   801d14 <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
	return result;
  80206a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802070:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802073:	89 01                	mov    %eax,(%ecx)
  802075:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	c9                   	leave  
  80207c:	c2 04 00             	ret    $0x4

0080207f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	ff 75 10             	pushl  0x10(%ebp)
  802089:	ff 75 0c             	pushl  0xc(%ebp)
  80208c:	ff 75 08             	pushl  0x8(%ebp)
  80208f:	6a 13                	push   $0x13
  802091:	e8 7e fc ff ff       	call   801d14 <syscall>
  802096:	83 c4 18             	add    $0x18,%esp
	return ;
  802099:	90                   	nop
}
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <sys_rcr2>:
uint32 sys_rcr2()
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 1e                	push   $0x1e
  8020ab:	e8 64 fc ff ff       	call   801d14 <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
}
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020c1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	50                   	push   %eax
  8020ce:	6a 1f                	push   $0x1f
  8020d0:	e8 3f fc ff ff       	call   801d14 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d8:	90                   	nop
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <rsttst>:
void rsttst()
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 21                	push   $0x21
  8020ea:	e8 25 fc ff ff       	call   801d14 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f2:	90                   	nop
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802101:	8b 55 18             	mov    0x18(%ebp),%edx
  802104:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802108:	52                   	push   %edx
  802109:	50                   	push   %eax
  80210a:	ff 75 10             	pushl  0x10(%ebp)
  80210d:	ff 75 0c             	pushl  0xc(%ebp)
  802110:	ff 75 08             	pushl  0x8(%ebp)
  802113:	6a 20                	push   $0x20
  802115:	e8 fa fb ff ff       	call   801d14 <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
	return ;
  80211d:	90                   	nop
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <chktst>:
void chktst(uint32 n)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	ff 75 08             	pushl  0x8(%ebp)
  80212e:	6a 22                	push   $0x22
  802130:	e8 df fb ff ff       	call   801d14 <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
	return ;
  802138:	90                   	nop
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <inctst>:

void inctst()
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 23                	push   $0x23
  80214a:	e8 c5 fb ff ff       	call   801d14 <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
	return ;
  802152:	90                   	nop
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <gettst>:
uint32 gettst()
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 24                	push   $0x24
  802164:	e8 ab fb ff ff       	call   801d14 <syscall>
  802169:	83 c4 18             	add    $0x18,%esp
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 25                	push   $0x25
  802180:	e8 8f fb ff ff       	call   801d14 <syscall>
  802185:	83 c4 18             	add    $0x18,%esp
  802188:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80218b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80218f:	75 07                	jne    802198 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802191:	b8 01 00 00 00       	mov    $0x1,%eax
  802196:	eb 05                	jmp    80219d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802198:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 25                	push   $0x25
  8021b1:	e8 5e fb ff ff       	call   801d14 <syscall>
  8021b6:	83 c4 18             	add    $0x18,%esp
  8021b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021bc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021c0:	75 07                	jne    8021c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c7:	eb 05                	jmp    8021ce <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 25                	push   $0x25
  8021e2:	e8 2d fb ff ff       	call   801d14 <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
  8021ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021ed:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021f1:	75 07                	jne    8021fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f8:	eb 05                	jmp    8021ff <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
  802204:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 25                	push   $0x25
  802213:	e8 fc fa ff ff       	call   801d14 <syscall>
  802218:	83 c4 18             	add    $0x18,%esp
  80221b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80221e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802222:	75 07                	jne    80222b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802224:	b8 01 00 00 00       	mov    $0x1,%eax
  802229:	eb 05                	jmp    802230 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	ff 75 08             	pushl  0x8(%ebp)
  802240:	6a 26                	push   $0x26
  802242:	e8 cd fa ff ff       	call   801d14 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
	return ;
  80224a:	90                   	nop
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802251:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802254:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	6a 00                	push   $0x0
  80225f:	53                   	push   %ebx
  802260:	51                   	push   %ecx
  802261:	52                   	push   %edx
  802262:	50                   	push   %eax
  802263:	6a 27                	push   $0x27
  802265:	e8 aa fa ff ff       	call   801d14 <syscall>
  80226a:	83 c4 18             	add    $0x18,%esp
}
  80226d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802275:	8b 55 0c             	mov    0xc(%ebp),%edx
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	52                   	push   %edx
  802282:	50                   	push   %eax
  802283:	6a 28                	push   $0x28
  802285:	e8 8a fa ff ff       	call   801d14 <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802292:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802295:	8b 55 0c             	mov    0xc(%ebp),%edx
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	6a 00                	push   $0x0
  80229d:	51                   	push   %ecx
  80229e:	ff 75 10             	pushl  0x10(%ebp)
  8022a1:	52                   	push   %edx
  8022a2:	50                   	push   %eax
  8022a3:	6a 29                	push   $0x29
  8022a5:	e8 6a fa ff ff       	call   801d14 <syscall>
  8022aa:	83 c4 18             	add    $0x18,%esp
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	ff 75 10             	pushl  0x10(%ebp)
  8022b9:	ff 75 0c             	pushl  0xc(%ebp)
  8022bc:	ff 75 08             	pushl  0x8(%ebp)
  8022bf:	6a 12                	push   $0x12
  8022c1:	e8 4e fa ff ff       	call   801d14 <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c9:	90                   	nop
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8022cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	52                   	push   %edx
  8022dc:	50                   	push   %eax
  8022dd:	6a 2a                	push   $0x2a
  8022df:	e8 30 fa ff ff       	call   801d14 <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
	return;
  8022e7:	90                   	nop
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	50                   	push   %eax
  8022f9:	6a 2b                	push   $0x2b
  8022fb:	e8 14 fa ff ff       	call   801d14 <syscall>
  802300:	83 c4 18             	add    $0x18,%esp
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	ff 75 0c             	pushl  0xc(%ebp)
  802311:	ff 75 08             	pushl  0x8(%ebp)
  802314:	6a 2c                	push   $0x2c
  802316:	e8 f9 f9 ff ff       	call   801d14 <syscall>
  80231b:	83 c4 18             	add    $0x18,%esp
	return;
  80231e:	90                   	nop
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	ff 75 0c             	pushl  0xc(%ebp)
  80232d:	ff 75 08             	pushl  0x8(%ebp)
  802330:	6a 2d                	push   $0x2d
  802332:	e8 dd f9 ff ff       	call   801d14 <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
	return;
  80233a:	90                   	nop
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	83 e8 04             	sub    $0x4,%eax
  802349:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80234c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	83 e8 04             	sub    $0x4,%eax
  802362:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802368:	8b 00                	mov    (%eax),%eax
  80236a:	83 e0 01             	and    $0x1,%eax
  80236d:	85 c0                	test   %eax,%eax
  80236f:	0f 94 c0             	sete   %al
}
  802372:	c9                   	leave  
  802373:	c3                   	ret    

00802374 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
  802377:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80237a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802381:	8b 45 0c             	mov    0xc(%ebp),%eax
  802384:	83 f8 02             	cmp    $0x2,%eax
  802387:	74 2b                	je     8023b4 <alloc_block+0x40>
  802389:	83 f8 02             	cmp    $0x2,%eax
  80238c:	7f 07                	jg     802395 <alloc_block+0x21>
  80238e:	83 f8 01             	cmp    $0x1,%eax
  802391:	74 0e                	je     8023a1 <alloc_block+0x2d>
  802393:	eb 58                	jmp    8023ed <alloc_block+0x79>
  802395:	83 f8 03             	cmp    $0x3,%eax
  802398:	74 2d                	je     8023c7 <alloc_block+0x53>
  80239a:	83 f8 04             	cmp    $0x4,%eax
  80239d:	74 3b                	je     8023da <alloc_block+0x66>
  80239f:	eb 4c                	jmp    8023ed <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8023a1:	83 ec 0c             	sub    $0xc,%esp
  8023a4:	ff 75 08             	pushl  0x8(%ebp)
  8023a7:	e8 11 03 00 00       	call   8026bd <alloc_block_FF>
  8023ac:	83 c4 10             	add    $0x10,%esp
  8023af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023b2:	eb 4a                	jmp    8023fe <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8023b4:	83 ec 0c             	sub    $0xc,%esp
  8023b7:	ff 75 08             	pushl  0x8(%ebp)
  8023ba:	e8 fa 19 00 00       	call   803db9 <alloc_block_NF>
  8023bf:	83 c4 10             	add    $0x10,%esp
  8023c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023c5:	eb 37                	jmp    8023fe <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8023c7:	83 ec 0c             	sub    $0xc,%esp
  8023ca:	ff 75 08             	pushl  0x8(%ebp)
  8023cd:	e8 a7 07 00 00       	call   802b79 <alloc_block_BF>
  8023d2:	83 c4 10             	add    $0x10,%esp
  8023d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023d8:	eb 24                	jmp    8023fe <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8023da:	83 ec 0c             	sub    $0xc,%esp
  8023dd:	ff 75 08             	pushl  0x8(%ebp)
  8023e0:	e8 b7 19 00 00       	call   803d9c <alloc_block_WF>
  8023e5:	83 c4 10             	add    $0x10,%esp
  8023e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023eb:	eb 11                	jmp    8023fe <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8023ed:	83 ec 0c             	sub    $0xc,%esp
  8023f0:	68 cc 4a 80 00       	push   $0x804acc
  8023f5:	e8 b8 e6 ff ff       	call   800ab2 <cprintf>
  8023fa:	83 c4 10             	add    $0x10,%esp
		break;
  8023fd:	90                   	nop
	}
	return va;
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	53                   	push   %ebx
  802407:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80240a:	83 ec 0c             	sub    $0xc,%esp
  80240d:	68 ec 4a 80 00       	push   $0x804aec
  802412:	e8 9b e6 ff ff       	call   800ab2 <cprintf>
  802417:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80241a:	83 ec 0c             	sub    $0xc,%esp
  80241d:	68 17 4b 80 00       	push   $0x804b17
  802422:	e8 8b e6 ff ff       	call   800ab2 <cprintf>
  802427:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802430:	eb 37                	jmp    802469 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802432:	83 ec 0c             	sub    $0xc,%esp
  802435:	ff 75 f4             	pushl  -0xc(%ebp)
  802438:	e8 19 ff ff ff       	call   802356 <is_free_block>
  80243d:	83 c4 10             	add    $0x10,%esp
  802440:	0f be d8             	movsbl %al,%ebx
  802443:	83 ec 0c             	sub    $0xc,%esp
  802446:	ff 75 f4             	pushl  -0xc(%ebp)
  802449:	e8 ef fe ff ff       	call   80233d <get_block_size>
  80244e:	83 c4 10             	add    $0x10,%esp
  802451:	83 ec 04             	sub    $0x4,%esp
  802454:	53                   	push   %ebx
  802455:	50                   	push   %eax
  802456:	68 2f 4b 80 00       	push   $0x804b2f
  80245b:	e8 52 e6 ff ff       	call   800ab2 <cprintf>
  802460:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802463:	8b 45 10             	mov    0x10(%ebp),%eax
  802466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246d:	74 07                	je     802476 <print_blocks_list+0x73>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 00                	mov    (%eax),%eax
  802474:	eb 05                	jmp    80247b <print_blocks_list+0x78>
  802476:	b8 00 00 00 00       	mov    $0x0,%eax
  80247b:	89 45 10             	mov    %eax,0x10(%ebp)
  80247e:	8b 45 10             	mov    0x10(%ebp),%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	75 ad                	jne    802432 <print_blocks_list+0x2f>
  802485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802489:	75 a7                	jne    802432 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80248b:	83 ec 0c             	sub    $0xc,%esp
  80248e:	68 ec 4a 80 00       	push   $0x804aec
  802493:	e8 1a e6 ff ff       	call   800ab2 <cprintf>
  802498:	83 c4 10             	add    $0x10,%esp

}
  80249b:	90                   	nop
  80249c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    

008024a1 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
  8024a4:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8024a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024aa:	83 e0 01             	and    $0x1,%eax
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	74 03                	je     8024b4 <initialize_dynamic_allocator+0x13>
  8024b1:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8024b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024b8:	0f 84 c7 01 00 00    	je     802685 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8024be:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8024c5:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8024c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ce:	01 d0                	add    %edx,%eax
  8024d0:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8024d5:	0f 87 ad 01 00 00    	ja     802688 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	0f 89 a5 01 00 00    	jns    80268b <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8024e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ec:	01 d0                	add    %edx,%eax
  8024ee:	83 e8 04             	sub    $0x4,%eax
  8024f1:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8024f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8024fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802502:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802505:	e9 87 00 00 00       	jmp    802591 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80250a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250e:	75 14                	jne    802524 <initialize_dynamic_allocator+0x83>
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	68 47 4b 80 00       	push   $0x804b47
  802518:	6a 79                	push   $0x79
  80251a:	68 65 4b 80 00       	push   $0x804b65
  80251f:	e8 d1 e2 ff ff       	call   8007f5 <_panic>
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	85 c0                	test   %eax,%eax
  80252b:	74 10                	je     80253d <initialize_dynamic_allocator+0x9c>
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 00                	mov    (%eax),%eax
  802532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802535:	8b 52 04             	mov    0x4(%edx),%edx
  802538:	89 50 04             	mov    %edx,0x4(%eax)
  80253b:	eb 0b                	jmp    802548 <initialize_dynamic_allocator+0xa7>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	a3 30 50 80 00       	mov    %eax,0x805030
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 04             	mov    0x4(%eax),%eax
  80254e:	85 c0                	test   %eax,%eax
  802550:	74 0f                	je     802561 <initialize_dynamic_allocator+0xc0>
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 04             	mov    0x4(%eax),%eax
  802558:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255b:	8b 12                	mov    (%edx),%edx
  80255d:	89 10                	mov    %edx,(%eax)
  80255f:	eb 0a                	jmp    80256b <initialize_dynamic_allocator+0xca>
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 00                	mov    (%eax),%eax
  802566:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257e:	a1 38 50 80 00       	mov    0x805038,%eax
  802583:	48                   	dec    %eax
  802584:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802589:	a1 34 50 80 00       	mov    0x805034,%eax
  80258e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802595:	74 07                	je     80259e <initialize_dynamic_allocator+0xfd>
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 00                	mov    (%eax),%eax
  80259c:	eb 05                	jmp    8025a3 <initialize_dynamic_allocator+0x102>
  80259e:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8025a8:	a1 34 50 80 00       	mov    0x805034,%eax
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	0f 85 55 ff ff ff    	jne    80250a <initialize_dynamic_allocator+0x69>
  8025b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b9:	0f 85 4b ff ff ff    	jne    80250a <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8025c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8025ce:	a1 44 50 80 00       	mov    0x805044,%eax
  8025d3:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8025d8:	a1 40 50 80 00       	mov    0x805040,%eax
  8025dd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8025e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e6:	83 c0 08             	add    $0x8,%eax
  8025e9:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	83 c0 04             	add    $0x4,%eax
  8025f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f5:	83 ea 08             	sub    $0x8,%edx
  8025f8:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8025fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	01 d0                	add    %edx,%eax
  802602:	83 e8 08             	sub    $0x8,%eax
  802605:	8b 55 0c             	mov    0xc(%ebp),%edx
  802608:	83 ea 08             	sub    $0x8,%edx
  80260b:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80260d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802610:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802616:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802619:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802620:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802624:	75 17                	jne    80263d <initialize_dynamic_allocator+0x19c>
  802626:	83 ec 04             	sub    $0x4,%esp
  802629:	68 80 4b 80 00       	push   $0x804b80
  80262e:	68 90 00 00 00       	push   $0x90
  802633:	68 65 4b 80 00       	push   $0x804b65
  802638:	e8 b8 e1 ff ff       	call   8007f5 <_panic>
  80263d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802643:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802646:	89 10                	mov    %edx,(%eax)
  802648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	74 0d                	je     80265e <initialize_dynamic_allocator+0x1bd>
  802651:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802656:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802659:	89 50 04             	mov    %edx,0x4(%eax)
  80265c:	eb 08                	jmp    802666 <initialize_dynamic_allocator+0x1c5>
  80265e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802661:	a3 30 50 80 00       	mov    %eax,0x805030
  802666:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802669:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80266e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802671:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802678:	a1 38 50 80 00       	mov    0x805038,%eax
  80267d:	40                   	inc    %eax
  80267e:	a3 38 50 80 00       	mov    %eax,0x805038
  802683:	eb 07                	jmp    80268c <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802685:	90                   	nop
  802686:	eb 04                	jmp    80268c <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802688:	90                   	nop
  802689:	eb 01                	jmp    80268c <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80268b:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802691:	8b 45 10             	mov    0x10(%ebp),%eax
  802694:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80269d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a0:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	83 e8 04             	sub    $0x4,%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	83 e0 fe             	and    $0xfffffffe,%eax
  8026ad:	8d 50 f8             	lea    -0x8(%eax),%edx
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	01 c2                	add    %eax,%edx
  8026b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b8:	89 02                	mov    %eax,(%edx)
}
  8026ba:	90                   	nop
  8026bb:	5d                   	pop    %ebp
  8026bc:	c3                   	ret    

008026bd <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
  8026c0:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	83 e0 01             	and    $0x1,%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	74 03                	je     8026d0 <alloc_block_FF+0x13>
  8026cd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026d0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026d4:	77 07                	ja     8026dd <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026d6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026dd:	a1 24 50 80 00       	mov    0x805024,%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	75 73                	jne    802759 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	83 c0 10             	add    $0x10,%eax
  8026ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026ef:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8026f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fc:	01 d0                	add    %edx,%eax
  8026fe:	48                   	dec    %eax
  8026ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802705:	ba 00 00 00 00       	mov    $0x0,%edx
  80270a:	f7 75 ec             	divl   -0x14(%ebp)
  80270d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802710:	29 d0                	sub    %edx,%eax
  802712:	c1 e8 0c             	shr    $0xc,%eax
  802715:	83 ec 0c             	sub    $0xc,%esp
  802718:	50                   	push   %eax
  802719:	e8 2e f1 ff ff       	call   80184c <sbrk>
  80271e:	83 c4 10             	add    $0x10,%esp
  802721:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802724:	83 ec 0c             	sub    $0xc,%esp
  802727:	6a 00                	push   $0x0
  802729:	e8 1e f1 ff ff       	call   80184c <sbrk>
  80272e:	83 c4 10             	add    $0x10,%esp
  802731:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802734:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802737:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80273a:	83 ec 08             	sub    $0x8,%esp
  80273d:	50                   	push   %eax
  80273e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802741:	e8 5b fd ff ff       	call   8024a1 <initialize_dynamic_allocator>
  802746:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802749:	83 ec 0c             	sub    $0xc,%esp
  80274c:	68 a3 4b 80 00       	push   $0x804ba3
  802751:	e8 5c e3 ff ff       	call   800ab2 <cprintf>
  802756:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802759:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80275d:	75 0a                	jne    802769 <alloc_block_FF+0xac>
	        return NULL;
  80275f:	b8 00 00 00 00       	mov    $0x0,%eax
  802764:	e9 0e 04 00 00       	jmp    802b77 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802769:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802770:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802775:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802778:	e9 f3 02 00 00       	jmp    802a70 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802783:	83 ec 0c             	sub    $0xc,%esp
  802786:	ff 75 bc             	pushl  -0x44(%ebp)
  802789:	e8 af fb ff ff       	call   80233d <get_block_size>
  80278e:	83 c4 10             	add    $0x10,%esp
  802791:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802794:	8b 45 08             	mov    0x8(%ebp),%eax
  802797:	83 c0 08             	add    $0x8,%eax
  80279a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80279d:	0f 87 c5 02 00 00    	ja     802a68 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	83 c0 18             	add    $0x18,%eax
  8027a9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8027ac:	0f 87 19 02 00 00    	ja     8029cb <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8027b2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027b8:	83 e8 08             	sub    $0x8,%eax
  8027bb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	8d 50 08             	lea    0x8(%eax),%edx
  8027c4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027c7:	01 d0                	add    %edx,%eax
  8027c9:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	83 c0 08             	add    $0x8,%eax
  8027d2:	83 ec 04             	sub    $0x4,%esp
  8027d5:	6a 01                	push   $0x1
  8027d7:	50                   	push   %eax
  8027d8:	ff 75 bc             	pushl  -0x44(%ebp)
  8027db:	e8 ae fe ff ff       	call   80268e <set_block_data>
  8027e0:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 40 04             	mov    0x4(%eax),%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	75 68                	jne    802855 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027ed:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8027f1:	75 17                	jne    80280a <alloc_block_FF+0x14d>
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	68 80 4b 80 00       	push   $0x804b80
  8027fb:	68 d7 00 00 00       	push   $0xd7
  802800:	68 65 4b 80 00       	push   $0x804b65
  802805:	e8 eb df ff ff       	call   8007f5 <_panic>
  80280a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802810:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802813:	89 10                	mov    %edx,(%eax)
  802815:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 0d                	je     80282b <alloc_block_FF+0x16e>
  80281e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802823:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802826:	89 50 04             	mov    %edx,0x4(%eax)
  802829:	eb 08                	jmp    802833 <alloc_block_FF+0x176>
  80282b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80282e:	a3 30 50 80 00       	mov    %eax,0x805030
  802833:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802836:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80283b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80283e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802845:	a1 38 50 80 00       	mov    0x805038,%eax
  80284a:	40                   	inc    %eax
  80284b:	a3 38 50 80 00       	mov    %eax,0x805038
  802850:	e9 dc 00 00 00       	jmp    802931 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 00                	mov    (%eax),%eax
  80285a:	85 c0                	test   %eax,%eax
  80285c:	75 65                	jne    8028c3 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80285e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802862:	75 17                	jne    80287b <alloc_block_FF+0x1be>
  802864:	83 ec 04             	sub    $0x4,%esp
  802867:	68 b4 4b 80 00       	push   $0x804bb4
  80286c:	68 db 00 00 00       	push   $0xdb
  802871:	68 65 4b 80 00       	push   $0x804b65
  802876:	e8 7a df ff ff       	call   8007f5 <_panic>
  80287b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802881:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802884:	89 50 04             	mov    %edx,0x4(%eax)
  802887:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80288a:	8b 40 04             	mov    0x4(%eax),%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	74 0c                	je     80289d <alloc_block_FF+0x1e0>
  802891:	a1 30 50 80 00       	mov    0x805030,%eax
  802896:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802899:	89 10                	mov    %edx,(%eax)
  80289b:	eb 08                	jmp    8028a5 <alloc_block_FF+0x1e8>
  80289d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028a0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028a8:	a3 30 50 80 00       	mov    %eax,0x805030
  8028ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8028bb:	40                   	inc    %eax
  8028bc:	a3 38 50 80 00       	mov    %eax,0x805038
  8028c1:	eb 6e                	jmp    802931 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8028c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c7:	74 06                	je     8028cf <alloc_block_FF+0x212>
  8028c9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028cd:	75 17                	jne    8028e6 <alloc_block_FF+0x229>
  8028cf:	83 ec 04             	sub    $0x4,%esp
  8028d2:	68 d8 4b 80 00       	push   $0x804bd8
  8028d7:	68 df 00 00 00       	push   $0xdf
  8028dc:	68 65 4b 80 00       	push   $0x804b65
  8028e1:	e8 0f df ff ff       	call   8007f5 <_panic>
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 10                	mov    (%eax),%edx
  8028eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028ee:	89 10                	mov    %edx,(%eax)
  8028f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 0b                	je     802904 <alloc_block_FF+0x247>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802901:	89 50 04             	mov    %edx,0x4(%eax)
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80290a:	89 10                	mov    %edx,(%eax)
  80290c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80290f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802912:	89 50 04             	mov    %edx,0x4(%eax)
  802915:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802918:	8b 00                	mov    (%eax),%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	75 08                	jne    802926 <alloc_block_FF+0x269>
  80291e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802921:	a3 30 50 80 00       	mov    %eax,0x805030
  802926:	a1 38 50 80 00       	mov    0x805038,%eax
  80292b:	40                   	inc    %eax
  80292c:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802931:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802935:	75 17                	jne    80294e <alloc_block_FF+0x291>
  802937:	83 ec 04             	sub    $0x4,%esp
  80293a:	68 47 4b 80 00       	push   $0x804b47
  80293f:	68 e1 00 00 00       	push   $0xe1
  802944:	68 65 4b 80 00       	push   $0x804b65
  802949:	e8 a7 de ff ff       	call   8007f5 <_panic>
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 00                	mov    (%eax),%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	74 10                	je     802967 <alloc_block_FF+0x2aa>
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295f:	8b 52 04             	mov    0x4(%edx),%edx
  802962:	89 50 04             	mov    %edx,0x4(%eax)
  802965:	eb 0b                	jmp    802972 <alloc_block_FF+0x2b5>
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	a3 30 50 80 00       	mov    %eax,0x805030
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	74 0f                	je     80298b <alloc_block_FF+0x2ce>
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 40 04             	mov    0x4(%eax),%eax
  802982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802985:	8b 12                	mov    (%edx),%edx
  802987:	89 10                	mov    %edx,(%eax)
  802989:	eb 0a                	jmp    802995 <alloc_block_FF+0x2d8>
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029ad:	48                   	dec    %eax
  8029ae:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8029b3:	83 ec 04             	sub    $0x4,%esp
  8029b6:	6a 00                	push   $0x0
  8029b8:	ff 75 b4             	pushl  -0x4c(%ebp)
  8029bb:	ff 75 b0             	pushl  -0x50(%ebp)
  8029be:	e8 cb fc ff ff       	call   80268e <set_block_data>
  8029c3:	83 c4 10             	add    $0x10,%esp
  8029c6:	e9 95 00 00 00       	jmp    802a60 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	6a 01                	push   $0x1
  8029d0:	ff 75 b8             	pushl  -0x48(%ebp)
  8029d3:	ff 75 bc             	pushl  -0x44(%ebp)
  8029d6:	e8 b3 fc ff ff       	call   80268e <set_block_data>
  8029db:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8029de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e2:	75 17                	jne    8029fb <alloc_block_FF+0x33e>
  8029e4:	83 ec 04             	sub    $0x4,%esp
  8029e7:	68 47 4b 80 00       	push   $0x804b47
  8029ec:	68 e8 00 00 00       	push   $0xe8
  8029f1:	68 65 4b 80 00       	push   $0x804b65
  8029f6:	e8 fa dd ff ff       	call   8007f5 <_panic>
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	85 c0                	test   %eax,%eax
  802a02:	74 10                	je     802a14 <alloc_block_FF+0x357>
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0c:	8b 52 04             	mov    0x4(%edx),%edx
  802a0f:	89 50 04             	mov    %edx,0x4(%eax)
  802a12:	eb 0b                	jmp    802a1f <alloc_block_FF+0x362>
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 40 04             	mov    0x4(%eax),%eax
  802a1a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 40 04             	mov    0x4(%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 0f                	je     802a38 <alloc_block_FF+0x37b>
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 40 04             	mov    0x4(%eax),%eax
  802a2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a32:	8b 12                	mov    (%edx),%edx
  802a34:	89 10                	mov    %edx,(%eax)
  802a36:	eb 0a                	jmp    802a42 <alloc_block_FF+0x385>
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a55:	a1 38 50 80 00       	mov    0x805038,%eax
  802a5a:	48                   	dec    %eax
  802a5b:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802a60:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a63:	e9 0f 01 00 00       	jmp    802b77 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a68:	a1 34 50 80 00       	mov    0x805034,%eax
  802a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a74:	74 07                	je     802a7d <alloc_block_FF+0x3c0>
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	8b 00                	mov    (%eax),%eax
  802a7b:	eb 05                	jmp    802a82 <alloc_block_FF+0x3c5>
  802a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a82:	a3 34 50 80 00       	mov    %eax,0x805034
  802a87:	a1 34 50 80 00       	mov    0x805034,%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	0f 85 e9 fc ff ff    	jne    80277d <alloc_block_FF+0xc0>
  802a94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a98:	0f 85 df fc ff ff    	jne    80277d <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	83 c0 08             	add    $0x8,%eax
  802aa4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802aa7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802aae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ab1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ab4:	01 d0                	add    %edx,%eax
  802ab6:	48                   	dec    %eax
  802ab7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802aba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802abd:	ba 00 00 00 00       	mov    $0x0,%edx
  802ac2:	f7 75 d8             	divl   -0x28(%ebp)
  802ac5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ac8:	29 d0                	sub    %edx,%eax
  802aca:	c1 e8 0c             	shr    $0xc,%eax
  802acd:	83 ec 0c             	sub    $0xc,%esp
  802ad0:	50                   	push   %eax
  802ad1:	e8 76 ed ff ff       	call   80184c <sbrk>
  802ad6:	83 c4 10             	add    $0x10,%esp
  802ad9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802adc:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802ae0:	75 0a                	jne    802aec <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802ae2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae7:	e9 8b 00 00 00       	jmp    802b77 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802aec:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802af3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802af6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af9:	01 d0                	add    %edx,%eax
  802afb:	48                   	dec    %eax
  802afc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802aff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b02:	ba 00 00 00 00       	mov    $0x0,%edx
  802b07:	f7 75 cc             	divl   -0x34(%ebp)
  802b0a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b0d:	29 d0                	sub    %edx,%eax
  802b0f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b12:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b15:	01 d0                	add    %edx,%eax
  802b17:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802b1c:	a1 40 50 80 00       	mov    0x805040,%eax
  802b21:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b27:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b34:	01 d0                	add    %edx,%eax
  802b36:	48                   	dec    %eax
  802b37:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b3a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  802b42:	f7 75 c4             	divl   -0x3c(%ebp)
  802b45:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b48:	29 d0                	sub    %edx,%eax
  802b4a:	83 ec 04             	sub    $0x4,%esp
  802b4d:	6a 01                	push   $0x1
  802b4f:	50                   	push   %eax
  802b50:	ff 75 d0             	pushl  -0x30(%ebp)
  802b53:	e8 36 fb ff ff       	call   80268e <set_block_data>
  802b58:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802b5b:	83 ec 0c             	sub    $0xc,%esp
  802b5e:	ff 75 d0             	pushl  -0x30(%ebp)
  802b61:	e8 1b 0a 00 00       	call   803581 <free_block>
  802b66:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802b69:	83 ec 0c             	sub    $0xc,%esp
  802b6c:	ff 75 08             	pushl  0x8(%ebp)
  802b6f:	e8 49 fb ff ff       	call   8026bd <alloc_block_FF>
  802b74:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802b77:	c9                   	leave  
  802b78:	c3                   	ret    

00802b79 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802b79:	55                   	push   %ebp
  802b7a:	89 e5                	mov    %esp,%ebp
  802b7c:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	83 e0 01             	and    $0x1,%eax
  802b85:	85 c0                	test   %eax,%eax
  802b87:	74 03                	je     802b8c <alloc_block_BF+0x13>
  802b89:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b8c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b90:	77 07                	ja     802b99 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b92:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b99:	a1 24 50 80 00       	mov    0x805024,%eax
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	75 73                	jne    802c15 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	83 c0 10             	add    $0x10,%eax
  802ba8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802bab:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802bb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb8:	01 d0                	add    %edx,%eax
  802bba:	48                   	dec    %eax
  802bbb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802bbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bc1:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc6:	f7 75 e0             	divl   -0x20(%ebp)
  802bc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bcc:	29 d0                	sub    %edx,%eax
  802bce:	c1 e8 0c             	shr    $0xc,%eax
  802bd1:	83 ec 0c             	sub    $0xc,%esp
  802bd4:	50                   	push   %eax
  802bd5:	e8 72 ec ff ff       	call   80184c <sbrk>
  802bda:	83 c4 10             	add    $0x10,%esp
  802bdd:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802be0:	83 ec 0c             	sub    $0xc,%esp
  802be3:	6a 00                	push   $0x0
  802be5:	e8 62 ec ff ff       	call   80184c <sbrk>
  802bea:	83 c4 10             	add    $0x10,%esp
  802bed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802bf0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bf3:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802bf6:	83 ec 08             	sub    $0x8,%esp
  802bf9:	50                   	push   %eax
  802bfa:	ff 75 d8             	pushl  -0x28(%ebp)
  802bfd:	e8 9f f8 ff ff       	call   8024a1 <initialize_dynamic_allocator>
  802c02:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c05:	83 ec 0c             	sub    $0xc,%esp
  802c08:	68 a3 4b 80 00       	push   $0x804ba3
  802c0d:	e8 a0 de ff ff       	call   800ab2 <cprintf>
  802c12:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802c15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802c1c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802c23:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802c2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802c31:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c39:	e9 1d 01 00 00       	jmp    802d5b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802c44:	83 ec 0c             	sub    $0xc,%esp
  802c47:	ff 75 a8             	pushl  -0x58(%ebp)
  802c4a:	e8 ee f6 ff ff       	call   80233d <get_block_size>
  802c4f:	83 c4 10             	add    $0x10,%esp
  802c52:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802c55:	8b 45 08             	mov    0x8(%ebp),%eax
  802c58:	83 c0 08             	add    $0x8,%eax
  802c5b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c5e:	0f 87 ef 00 00 00    	ja     802d53 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	83 c0 18             	add    $0x18,%eax
  802c6a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c6d:	77 1d                	ja     802c8c <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c72:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c75:	0f 86 d8 00 00 00    	jbe    802d53 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802c7b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802c81:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802c84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c87:	e9 c7 00 00 00       	jmp    802d53 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	83 c0 08             	add    $0x8,%eax
  802c92:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c95:	0f 85 9d 00 00 00    	jne    802d38 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802c9b:	83 ec 04             	sub    $0x4,%esp
  802c9e:	6a 01                	push   $0x1
  802ca0:	ff 75 a4             	pushl  -0x5c(%ebp)
  802ca3:	ff 75 a8             	pushl  -0x58(%ebp)
  802ca6:	e8 e3 f9 ff ff       	call   80268e <set_block_data>
  802cab:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802cae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb2:	75 17                	jne    802ccb <alloc_block_BF+0x152>
  802cb4:	83 ec 04             	sub    $0x4,%esp
  802cb7:	68 47 4b 80 00       	push   $0x804b47
  802cbc:	68 2c 01 00 00       	push   $0x12c
  802cc1:	68 65 4b 80 00       	push   $0x804b65
  802cc6:	e8 2a db ff ff       	call   8007f5 <_panic>
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 10                	je     802ce4 <alloc_block_BF+0x16b>
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdc:	8b 52 04             	mov    0x4(%edx),%edx
  802cdf:	89 50 04             	mov    %edx,0x4(%eax)
  802ce2:	eb 0b                	jmp    802cef <alloc_block_BF+0x176>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	a3 30 50 80 00       	mov    %eax,0x805030
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 40 04             	mov    0x4(%eax),%eax
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	74 0f                	je     802d08 <alloc_block_BF+0x18f>
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d02:	8b 12                	mov    (%edx),%edx
  802d04:	89 10                	mov    %edx,(%eax)
  802d06:	eb 0a                	jmp    802d12 <alloc_block_BF+0x199>
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d25:	a1 38 50 80 00       	mov    0x805038,%eax
  802d2a:	48                   	dec    %eax
  802d2b:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802d30:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d33:	e9 24 04 00 00       	jmp    80315c <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d3e:	76 13                	jbe    802d53 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802d40:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802d47:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802d4d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d50:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802d53:	a1 34 50 80 00       	mov    0x805034,%eax
  802d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5f:	74 07                	je     802d68 <alloc_block_BF+0x1ef>
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	eb 05                	jmp    802d6d <alloc_block_BF+0x1f4>
  802d68:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6d:	a3 34 50 80 00       	mov    %eax,0x805034
  802d72:	a1 34 50 80 00       	mov    0x805034,%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	0f 85 bf fe ff ff    	jne    802c3e <alloc_block_BF+0xc5>
  802d7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d83:	0f 85 b5 fe ff ff    	jne    802c3e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802d89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8d:	0f 84 26 02 00 00    	je     802fb9 <alloc_block_BF+0x440>
  802d93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d97:	0f 85 1c 02 00 00    	jne    802fb9 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da0:	2b 45 08             	sub    0x8(%ebp),%eax
  802da3:	83 e8 08             	sub    $0x8,%eax
  802da6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	8d 50 08             	lea    0x8(%eax),%edx
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db2:	01 d0                	add    %edx,%eax
  802db4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	83 c0 08             	add    $0x8,%eax
  802dbd:	83 ec 04             	sub    $0x4,%esp
  802dc0:	6a 01                	push   $0x1
  802dc2:	50                   	push   %eax
  802dc3:	ff 75 f0             	pushl  -0x10(%ebp)
  802dc6:	e8 c3 f8 ff ff       	call   80268e <set_block_data>
  802dcb:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd1:	8b 40 04             	mov    0x4(%eax),%eax
  802dd4:	85 c0                	test   %eax,%eax
  802dd6:	75 68                	jne    802e40 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802dd8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ddc:	75 17                	jne    802df5 <alloc_block_BF+0x27c>
  802dde:	83 ec 04             	sub    $0x4,%esp
  802de1:	68 80 4b 80 00       	push   $0x804b80
  802de6:	68 45 01 00 00       	push   $0x145
  802deb:	68 65 4b 80 00       	push   $0x804b65
  802df0:	e8 00 da ff ff       	call   8007f5 <_panic>
  802df5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802dfb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dfe:	89 10                	mov    %edx,(%eax)
  802e00:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	85 c0                	test   %eax,%eax
  802e07:	74 0d                	je     802e16 <alloc_block_BF+0x29d>
  802e09:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e0e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e11:	89 50 04             	mov    %edx,0x4(%eax)
  802e14:	eb 08                	jmp    802e1e <alloc_block_BF+0x2a5>
  802e16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e19:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e21:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e30:	a1 38 50 80 00       	mov    0x805038,%eax
  802e35:	40                   	inc    %eax
  802e36:	a3 38 50 80 00       	mov    %eax,0x805038
  802e3b:	e9 dc 00 00 00       	jmp    802f1c <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	75 65                	jne    802eae <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e49:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e4d:	75 17                	jne    802e66 <alloc_block_BF+0x2ed>
  802e4f:	83 ec 04             	sub    $0x4,%esp
  802e52:	68 b4 4b 80 00       	push   $0x804bb4
  802e57:	68 4a 01 00 00       	push   $0x14a
  802e5c:	68 65 4b 80 00       	push   $0x804b65
  802e61:	e8 8f d9 ff ff       	call   8007f5 <_panic>
  802e66:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e6f:	89 50 04             	mov    %edx,0x4(%eax)
  802e72:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e75:	8b 40 04             	mov    0x4(%eax),%eax
  802e78:	85 c0                	test   %eax,%eax
  802e7a:	74 0c                	je     802e88 <alloc_block_BF+0x30f>
  802e7c:	a1 30 50 80 00       	mov    0x805030,%eax
  802e81:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e84:	89 10                	mov    %edx,(%eax)
  802e86:	eb 08                	jmp    802e90 <alloc_block_BF+0x317>
  802e88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e8b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e90:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e93:	a3 30 50 80 00       	mov    %eax,0x805030
  802e98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ea6:	40                   	inc    %eax
  802ea7:	a3 38 50 80 00       	mov    %eax,0x805038
  802eac:	eb 6e                	jmp    802f1c <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802eae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb2:	74 06                	je     802eba <alloc_block_BF+0x341>
  802eb4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802eb8:	75 17                	jne    802ed1 <alloc_block_BF+0x358>
  802eba:	83 ec 04             	sub    $0x4,%esp
  802ebd:	68 d8 4b 80 00       	push   $0x804bd8
  802ec2:	68 4f 01 00 00       	push   $0x14f
  802ec7:	68 65 4b 80 00       	push   $0x804b65
  802ecc:	e8 24 d9 ff ff       	call   8007f5 <_panic>
  802ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed4:	8b 10                	mov    (%eax),%edx
  802ed6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ed9:	89 10                	mov    %edx,(%eax)
  802edb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ede:	8b 00                	mov    (%eax),%eax
  802ee0:	85 c0                	test   %eax,%eax
  802ee2:	74 0b                	je     802eef <alloc_block_BF+0x376>
  802ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee7:	8b 00                	mov    (%eax),%eax
  802ee9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802eec:	89 50 04             	mov    %edx,0x4(%eax)
  802eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ef5:	89 10                	mov    %edx,(%eax)
  802ef7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802efa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802efd:	89 50 04             	mov    %edx,0x4(%eax)
  802f00:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f03:	8b 00                	mov    (%eax),%eax
  802f05:	85 c0                	test   %eax,%eax
  802f07:	75 08                	jne    802f11 <alloc_block_BF+0x398>
  802f09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f0c:	a3 30 50 80 00       	mov    %eax,0x805030
  802f11:	a1 38 50 80 00       	mov    0x805038,%eax
  802f16:	40                   	inc    %eax
  802f17:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802f1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f20:	75 17                	jne    802f39 <alloc_block_BF+0x3c0>
  802f22:	83 ec 04             	sub    $0x4,%esp
  802f25:	68 47 4b 80 00       	push   $0x804b47
  802f2a:	68 51 01 00 00       	push   $0x151
  802f2f:	68 65 4b 80 00       	push   $0x804b65
  802f34:	e8 bc d8 ff ff       	call   8007f5 <_panic>
  802f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	74 10                	je     802f52 <alloc_block_BF+0x3d9>
  802f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f4a:	8b 52 04             	mov    0x4(%edx),%edx
  802f4d:	89 50 04             	mov    %edx,0x4(%eax)
  802f50:	eb 0b                	jmp    802f5d <alloc_block_BF+0x3e4>
  802f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f55:	8b 40 04             	mov    0x4(%eax),%eax
  802f58:	a3 30 50 80 00       	mov    %eax,0x805030
  802f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f60:	8b 40 04             	mov    0x4(%eax),%eax
  802f63:	85 c0                	test   %eax,%eax
  802f65:	74 0f                	je     802f76 <alloc_block_BF+0x3fd>
  802f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6a:	8b 40 04             	mov    0x4(%eax),%eax
  802f6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f70:	8b 12                	mov    (%edx),%edx
  802f72:	89 10                	mov    %edx,(%eax)
  802f74:	eb 0a                	jmp    802f80 <alloc_block_BF+0x407>
  802f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f79:	8b 00                	mov    (%eax),%eax
  802f7b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f93:	a1 38 50 80 00       	mov    0x805038,%eax
  802f98:	48                   	dec    %eax
  802f99:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802f9e:	83 ec 04             	sub    $0x4,%esp
  802fa1:	6a 00                	push   $0x0
  802fa3:	ff 75 d0             	pushl  -0x30(%ebp)
  802fa6:	ff 75 cc             	pushl  -0x34(%ebp)
  802fa9:	e8 e0 f6 ff ff       	call   80268e <set_block_data>
  802fae:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb4:	e9 a3 01 00 00       	jmp    80315c <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802fb9:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802fbd:	0f 85 9d 00 00 00    	jne    803060 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802fc3:	83 ec 04             	sub    $0x4,%esp
  802fc6:	6a 01                	push   $0x1
  802fc8:	ff 75 ec             	pushl  -0x14(%ebp)
  802fcb:	ff 75 f0             	pushl  -0x10(%ebp)
  802fce:	e8 bb f6 ff ff       	call   80268e <set_block_data>
  802fd3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802fd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fda:	75 17                	jne    802ff3 <alloc_block_BF+0x47a>
  802fdc:	83 ec 04             	sub    $0x4,%esp
  802fdf:	68 47 4b 80 00       	push   $0x804b47
  802fe4:	68 58 01 00 00       	push   $0x158
  802fe9:	68 65 4b 80 00       	push   $0x804b65
  802fee:	e8 02 d8 ff ff       	call   8007f5 <_panic>
  802ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff6:	8b 00                	mov    (%eax),%eax
  802ff8:	85 c0                	test   %eax,%eax
  802ffa:	74 10                	je     80300c <alloc_block_BF+0x493>
  802ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803004:	8b 52 04             	mov    0x4(%edx),%edx
  803007:	89 50 04             	mov    %edx,0x4(%eax)
  80300a:	eb 0b                	jmp    803017 <alloc_block_BF+0x49e>
  80300c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300f:	8b 40 04             	mov    0x4(%eax),%eax
  803012:	a3 30 50 80 00       	mov    %eax,0x805030
  803017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301a:	8b 40 04             	mov    0x4(%eax),%eax
  80301d:	85 c0                	test   %eax,%eax
  80301f:	74 0f                	je     803030 <alloc_block_BF+0x4b7>
  803021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803024:	8b 40 04             	mov    0x4(%eax),%eax
  803027:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80302a:	8b 12                	mov    (%edx),%edx
  80302c:	89 10                	mov    %edx,(%eax)
  80302e:	eb 0a                	jmp    80303a <alloc_block_BF+0x4c1>
  803030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80303a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803043:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803046:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304d:	a1 38 50 80 00       	mov    0x805038,%eax
  803052:	48                   	dec    %eax
  803053:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  803058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305b:	e9 fc 00 00 00       	jmp    80315c <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	83 c0 08             	add    $0x8,%eax
  803066:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803069:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803070:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803073:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803076:	01 d0                	add    %edx,%eax
  803078:	48                   	dec    %eax
  803079:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80307c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80307f:	ba 00 00 00 00       	mov    $0x0,%edx
  803084:	f7 75 c4             	divl   -0x3c(%ebp)
  803087:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80308a:	29 d0                	sub    %edx,%eax
  80308c:	c1 e8 0c             	shr    $0xc,%eax
  80308f:	83 ec 0c             	sub    $0xc,%esp
  803092:	50                   	push   %eax
  803093:	e8 b4 e7 ff ff       	call   80184c <sbrk>
  803098:	83 c4 10             	add    $0x10,%esp
  80309b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80309e:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8030a2:	75 0a                	jne    8030ae <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8030a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a9:	e9 ae 00 00 00       	jmp    80315c <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8030ae:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8030b5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8030bb:	01 d0                	add    %edx,%eax
  8030bd:	48                   	dec    %eax
  8030be:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8030c1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8030c9:	f7 75 b8             	divl   -0x48(%ebp)
  8030cc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030cf:	29 d0                	sub    %edx,%eax
  8030d1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8030d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8030d7:	01 d0                	add    %edx,%eax
  8030d9:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8030de:	a1 40 50 80 00       	mov    0x805040,%eax
  8030e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8030e9:	83 ec 0c             	sub    $0xc,%esp
  8030ec:	68 0c 4c 80 00       	push   $0x804c0c
  8030f1:	e8 bc d9 ff ff       	call   800ab2 <cprintf>
  8030f6:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8030f9:	83 ec 08             	sub    $0x8,%esp
  8030fc:	ff 75 bc             	pushl  -0x44(%ebp)
  8030ff:	68 11 4c 80 00       	push   $0x804c11
  803104:	e8 a9 d9 ff ff       	call   800ab2 <cprintf>
  803109:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80310c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803113:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803116:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803119:	01 d0                	add    %edx,%eax
  80311b:	48                   	dec    %eax
  80311c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80311f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803122:	ba 00 00 00 00       	mov    $0x0,%edx
  803127:	f7 75 b0             	divl   -0x50(%ebp)
  80312a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80312d:	29 d0                	sub    %edx,%eax
  80312f:	83 ec 04             	sub    $0x4,%esp
  803132:	6a 01                	push   $0x1
  803134:	50                   	push   %eax
  803135:	ff 75 bc             	pushl  -0x44(%ebp)
  803138:	e8 51 f5 ff ff       	call   80268e <set_block_data>
  80313d:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803140:	83 ec 0c             	sub    $0xc,%esp
  803143:	ff 75 bc             	pushl  -0x44(%ebp)
  803146:	e8 36 04 00 00       	call   803581 <free_block>
  80314b:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80314e:	83 ec 0c             	sub    $0xc,%esp
  803151:	ff 75 08             	pushl  0x8(%ebp)
  803154:	e8 20 fa ff ff       	call   802b79 <alloc_block_BF>
  803159:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80315c:	c9                   	leave  
  80315d:	c3                   	ret    

0080315e <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80315e:	55                   	push   %ebp
  80315f:	89 e5                	mov    %esp,%ebp
  803161:	53                   	push   %ebx
  803162:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803165:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80316c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803173:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803177:	74 1e                	je     803197 <merging+0x39>
  803179:	ff 75 08             	pushl  0x8(%ebp)
  80317c:	e8 bc f1 ff ff       	call   80233d <get_block_size>
  803181:	83 c4 04             	add    $0x4,%esp
  803184:	89 c2                	mov    %eax,%edx
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	01 d0                	add    %edx,%eax
  80318b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80318e:	75 07                	jne    803197 <merging+0x39>
		prev_is_free = 1;
  803190:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803197:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80319b:	74 1e                	je     8031bb <merging+0x5d>
  80319d:	ff 75 10             	pushl  0x10(%ebp)
  8031a0:	e8 98 f1 ff ff       	call   80233d <get_block_size>
  8031a5:	83 c4 04             	add    $0x4,%esp
  8031a8:	89 c2                	mov    %eax,%edx
  8031aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8031ad:	01 d0                	add    %edx,%eax
  8031af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031b2:	75 07                	jne    8031bb <merging+0x5d>
		next_is_free = 1;
  8031b4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8031bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031bf:	0f 84 cc 00 00 00    	je     803291 <merging+0x133>
  8031c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031c9:	0f 84 c2 00 00 00    	je     803291 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8031cf:	ff 75 08             	pushl  0x8(%ebp)
  8031d2:	e8 66 f1 ff ff       	call   80233d <get_block_size>
  8031d7:	83 c4 04             	add    $0x4,%esp
  8031da:	89 c3                	mov    %eax,%ebx
  8031dc:	ff 75 10             	pushl  0x10(%ebp)
  8031df:	e8 59 f1 ff ff       	call   80233d <get_block_size>
  8031e4:	83 c4 04             	add    $0x4,%esp
  8031e7:	01 c3                	add    %eax,%ebx
  8031e9:	ff 75 0c             	pushl  0xc(%ebp)
  8031ec:	e8 4c f1 ff ff       	call   80233d <get_block_size>
  8031f1:	83 c4 04             	add    $0x4,%esp
  8031f4:	01 d8                	add    %ebx,%eax
  8031f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8031f9:	6a 00                	push   $0x0
  8031fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8031fe:	ff 75 08             	pushl  0x8(%ebp)
  803201:	e8 88 f4 ff ff       	call   80268e <set_block_data>
  803206:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803209:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80320d:	75 17                	jne    803226 <merging+0xc8>
  80320f:	83 ec 04             	sub    $0x4,%esp
  803212:	68 47 4b 80 00       	push   $0x804b47
  803217:	68 7d 01 00 00       	push   $0x17d
  80321c:	68 65 4b 80 00       	push   $0x804b65
  803221:	e8 cf d5 ff ff       	call   8007f5 <_panic>
  803226:	8b 45 0c             	mov    0xc(%ebp),%eax
  803229:	8b 00                	mov    (%eax),%eax
  80322b:	85 c0                	test   %eax,%eax
  80322d:	74 10                	je     80323f <merging+0xe1>
  80322f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803232:	8b 00                	mov    (%eax),%eax
  803234:	8b 55 0c             	mov    0xc(%ebp),%edx
  803237:	8b 52 04             	mov    0x4(%edx),%edx
  80323a:	89 50 04             	mov    %edx,0x4(%eax)
  80323d:	eb 0b                	jmp    80324a <merging+0xec>
  80323f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803242:	8b 40 04             	mov    0x4(%eax),%eax
  803245:	a3 30 50 80 00       	mov    %eax,0x805030
  80324a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80324d:	8b 40 04             	mov    0x4(%eax),%eax
  803250:	85 c0                	test   %eax,%eax
  803252:	74 0f                	je     803263 <merging+0x105>
  803254:	8b 45 0c             	mov    0xc(%ebp),%eax
  803257:	8b 40 04             	mov    0x4(%eax),%eax
  80325a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80325d:	8b 12                	mov    (%edx),%edx
  80325f:	89 10                	mov    %edx,(%eax)
  803261:	eb 0a                	jmp    80326d <merging+0x10f>
  803263:	8b 45 0c             	mov    0xc(%ebp),%eax
  803266:	8b 00                	mov    (%eax),%eax
  803268:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80326d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803276:	8b 45 0c             	mov    0xc(%ebp),%eax
  803279:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803280:	a1 38 50 80 00       	mov    0x805038,%eax
  803285:	48                   	dec    %eax
  803286:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80328b:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80328c:	e9 ea 02 00 00       	jmp    80357b <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803295:	74 3b                	je     8032d2 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803297:	83 ec 0c             	sub    $0xc,%esp
  80329a:	ff 75 08             	pushl  0x8(%ebp)
  80329d:	e8 9b f0 ff ff       	call   80233d <get_block_size>
  8032a2:	83 c4 10             	add    $0x10,%esp
  8032a5:	89 c3                	mov    %eax,%ebx
  8032a7:	83 ec 0c             	sub    $0xc,%esp
  8032aa:	ff 75 10             	pushl  0x10(%ebp)
  8032ad:	e8 8b f0 ff ff       	call   80233d <get_block_size>
  8032b2:	83 c4 10             	add    $0x10,%esp
  8032b5:	01 d8                	add    %ebx,%eax
  8032b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8032ba:	83 ec 04             	sub    $0x4,%esp
  8032bd:	6a 00                	push   $0x0
  8032bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8032c2:	ff 75 08             	pushl  0x8(%ebp)
  8032c5:	e8 c4 f3 ff ff       	call   80268e <set_block_data>
  8032ca:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032cd:	e9 a9 02 00 00       	jmp    80357b <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8032d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032d6:	0f 84 2d 01 00 00    	je     803409 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8032dc:	83 ec 0c             	sub    $0xc,%esp
  8032df:	ff 75 10             	pushl  0x10(%ebp)
  8032e2:	e8 56 f0 ff ff       	call   80233d <get_block_size>
  8032e7:	83 c4 10             	add    $0x10,%esp
  8032ea:	89 c3                	mov    %eax,%ebx
  8032ec:	83 ec 0c             	sub    $0xc,%esp
  8032ef:	ff 75 0c             	pushl  0xc(%ebp)
  8032f2:	e8 46 f0 ff ff       	call   80233d <get_block_size>
  8032f7:	83 c4 10             	add    $0x10,%esp
  8032fa:	01 d8                	add    %ebx,%eax
  8032fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8032ff:	83 ec 04             	sub    $0x4,%esp
  803302:	6a 00                	push   $0x0
  803304:	ff 75 e4             	pushl  -0x1c(%ebp)
  803307:	ff 75 10             	pushl  0x10(%ebp)
  80330a:	e8 7f f3 ff ff       	call   80268e <set_block_data>
  80330f:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803312:	8b 45 10             	mov    0x10(%ebp),%eax
  803315:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803318:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80331c:	74 06                	je     803324 <merging+0x1c6>
  80331e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803322:	75 17                	jne    80333b <merging+0x1dd>
  803324:	83 ec 04             	sub    $0x4,%esp
  803327:	68 20 4c 80 00       	push   $0x804c20
  80332c:	68 8d 01 00 00       	push   $0x18d
  803331:	68 65 4b 80 00       	push   $0x804b65
  803336:	e8 ba d4 ff ff       	call   8007f5 <_panic>
  80333b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333e:	8b 50 04             	mov    0x4(%eax),%edx
  803341:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803344:	89 50 04             	mov    %edx,0x4(%eax)
  803347:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80334a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80334d:	89 10                	mov    %edx,(%eax)
  80334f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803352:	8b 40 04             	mov    0x4(%eax),%eax
  803355:	85 c0                	test   %eax,%eax
  803357:	74 0d                	je     803366 <merging+0x208>
  803359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80335c:	8b 40 04             	mov    0x4(%eax),%eax
  80335f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803362:	89 10                	mov    %edx,(%eax)
  803364:	eb 08                	jmp    80336e <merging+0x210>
  803366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803369:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80336e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803371:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803374:	89 50 04             	mov    %edx,0x4(%eax)
  803377:	a1 38 50 80 00       	mov    0x805038,%eax
  80337c:	40                   	inc    %eax
  80337d:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803382:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803386:	75 17                	jne    80339f <merging+0x241>
  803388:	83 ec 04             	sub    $0x4,%esp
  80338b:	68 47 4b 80 00       	push   $0x804b47
  803390:	68 8e 01 00 00       	push   $0x18e
  803395:	68 65 4b 80 00       	push   $0x804b65
  80339a:	e8 56 d4 ff ff       	call   8007f5 <_panic>
  80339f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	74 10                	je     8033b8 <merging+0x25a>
  8033a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ab:	8b 00                	mov    (%eax),%eax
  8033ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033b0:	8b 52 04             	mov    0x4(%edx),%edx
  8033b3:	89 50 04             	mov    %edx,0x4(%eax)
  8033b6:	eb 0b                	jmp    8033c3 <merging+0x265>
  8033b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bb:	8b 40 04             	mov    0x4(%eax),%eax
  8033be:	a3 30 50 80 00       	mov    %eax,0x805030
  8033c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c6:	8b 40 04             	mov    0x4(%eax),%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	74 0f                	je     8033dc <merging+0x27e>
  8033cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d0:	8b 40 04             	mov    0x4(%eax),%eax
  8033d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033d6:	8b 12                	mov    (%edx),%edx
  8033d8:	89 10                	mov    %edx,(%eax)
  8033da:	eb 0a                	jmp    8033e6 <merging+0x288>
  8033dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033df:	8b 00                	mov    (%eax),%eax
  8033e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8033fe:	48                   	dec    %eax
  8033ff:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803404:	e9 72 01 00 00       	jmp    80357b <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803409:	8b 45 10             	mov    0x10(%ebp),%eax
  80340c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80340f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803413:	74 79                	je     80348e <merging+0x330>
  803415:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803419:	74 73                	je     80348e <merging+0x330>
  80341b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341f:	74 06                	je     803427 <merging+0x2c9>
  803421:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803425:	75 17                	jne    80343e <merging+0x2e0>
  803427:	83 ec 04             	sub    $0x4,%esp
  80342a:	68 d8 4b 80 00       	push   $0x804bd8
  80342f:	68 94 01 00 00       	push   $0x194
  803434:	68 65 4b 80 00       	push   $0x804b65
  803439:	e8 b7 d3 ff ff       	call   8007f5 <_panic>
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	8b 10                	mov    (%eax),%edx
  803443:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803446:	89 10                	mov    %edx,(%eax)
  803448:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	85 c0                	test   %eax,%eax
  80344f:	74 0b                	je     80345c <merging+0x2fe>
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	8b 00                	mov    (%eax),%eax
  803456:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803459:	89 50 04             	mov    %edx,0x4(%eax)
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803462:	89 10                	mov    %edx,(%eax)
  803464:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803467:	8b 55 08             	mov    0x8(%ebp),%edx
  80346a:	89 50 04             	mov    %edx,0x4(%eax)
  80346d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803470:	8b 00                	mov    (%eax),%eax
  803472:	85 c0                	test   %eax,%eax
  803474:	75 08                	jne    80347e <merging+0x320>
  803476:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803479:	a3 30 50 80 00       	mov    %eax,0x805030
  80347e:	a1 38 50 80 00       	mov    0x805038,%eax
  803483:	40                   	inc    %eax
  803484:	a3 38 50 80 00       	mov    %eax,0x805038
  803489:	e9 ce 00 00 00       	jmp    80355c <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80348e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803492:	74 65                	je     8034f9 <merging+0x39b>
  803494:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803498:	75 17                	jne    8034b1 <merging+0x353>
  80349a:	83 ec 04             	sub    $0x4,%esp
  80349d:	68 b4 4b 80 00       	push   $0x804bb4
  8034a2:	68 95 01 00 00       	push   $0x195
  8034a7:	68 65 4b 80 00       	push   $0x804b65
  8034ac:	e8 44 d3 ff ff       	call   8007f5 <_panic>
  8034b1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ba:	89 50 04             	mov    %edx,0x4(%eax)
  8034bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c0:	8b 40 04             	mov    0x4(%eax),%eax
  8034c3:	85 c0                	test   %eax,%eax
  8034c5:	74 0c                	je     8034d3 <merging+0x375>
  8034c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8034cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034cf:	89 10                	mov    %edx,(%eax)
  8034d1:	eb 08                	jmp    8034db <merging+0x37d>
  8034d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034d6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034de:	a3 30 50 80 00       	mov    %eax,0x805030
  8034e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8034f1:	40                   	inc    %eax
  8034f2:	a3 38 50 80 00       	mov    %eax,0x805038
  8034f7:	eb 63                	jmp    80355c <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8034f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034fd:	75 17                	jne    803516 <merging+0x3b8>
  8034ff:	83 ec 04             	sub    $0x4,%esp
  803502:	68 80 4b 80 00       	push   $0x804b80
  803507:	68 98 01 00 00       	push   $0x198
  80350c:	68 65 4b 80 00       	push   $0x804b65
  803511:	e8 df d2 ff ff       	call   8007f5 <_panic>
  803516:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80351c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80351f:	89 10                	mov    %edx,(%eax)
  803521:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803524:	8b 00                	mov    (%eax),%eax
  803526:	85 c0                	test   %eax,%eax
  803528:	74 0d                	je     803537 <merging+0x3d9>
  80352a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80352f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803532:	89 50 04             	mov    %edx,0x4(%eax)
  803535:	eb 08                	jmp    80353f <merging+0x3e1>
  803537:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80353a:	a3 30 50 80 00       	mov    %eax,0x805030
  80353f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803542:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80354a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803551:	a1 38 50 80 00       	mov    0x805038,%eax
  803556:	40                   	inc    %eax
  803557:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80355c:	83 ec 0c             	sub    $0xc,%esp
  80355f:	ff 75 10             	pushl  0x10(%ebp)
  803562:	e8 d6 ed ff ff       	call   80233d <get_block_size>
  803567:	83 c4 10             	add    $0x10,%esp
  80356a:	83 ec 04             	sub    $0x4,%esp
  80356d:	6a 00                	push   $0x0
  80356f:	50                   	push   %eax
  803570:	ff 75 10             	pushl  0x10(%ebp)
  803573:	e8 16 f1 ff ff       	call   80268e <set_block_data>
  803578:	83 c4 10             	add    $0x10,%esp
	}
}
  80357b:	90                   	nop
  80357c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80357f:	c9                   	leave  
  803580:	c3                   	ret    

00803581 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803581:	55                   	push   %ebp
  803582:	89 e5                	mov    %esp,%ebp
  803584:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803587:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80358c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80358f:	a1 30 50 80 00       	mov    0x805030,%eax
  803594:	3b 45 08             	cmp    0x8(%ebp),%eax
  803597:	73 1b                	jae    8035b4 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803599:	a1 30 50 80 00       	mov    0x805030,%eax
  80359e:	83 ec 04             	sub    $0x4,%esp
  8035a1:	ff 75 08             	pushl  0x8(%ebp)
  8035a4:	6a 00                	push   $0x0
  8035a6:	50                   	push   %eax
  8035a7:	e8 b2 fb ff ff       	call   80315e <merging>
  8035ac:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8035af:	e9 8b 00 00 00       	jmp    80363f <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8035b4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035bc:	76 18                	jbe    8035d6 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8035be:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035c3:	83 ec 04             	sub    $0x4,%esp
  8035c6:	ff 75 08             	pushl  0x8(%ebp)
  8035c9:	50                   	push   %eax
  8035ca:	6a 00                	push   $0x0
  8035cc:	e8 8d fb ff ff       	call   80315e <merging>
  8035d1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8035d4:	eb 69                	jmp    80363f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8035d6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035de:	eb 39                	jmp    803619 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8035e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035e6:	73 29                	jae    803611 <free_block+0x90>
  8035e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035eb:	8b 00                	mov    (%eax),%eax
  8035ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035f0:	76 1f                	jbe    803611 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8035f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f5:	8b 00                	mov    (%eax),%eax
  8035f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8035fa:	83 ec 04             	sub    $0x4,%esp
  8035fd:	ff 75 08             	pushl  0x8(%ebp)
  803600:	ff 75 f0             	pushl  -0x10(%ebp)
  803603:	ff 75 f4             	pushl  -0xc(%ebp)
  803606:	e8 53 fb ff ff       	call   80315e <merging>
  80360b:	83 c4 10             	add    $0x10,%esp
			break;
  80360e:	90                   	nop
		}
	}
}
  80360f:	eb 2e                	jmp    80363f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803611:	a1 34 50 80 00       	mov    0x805034,%eax
  803616:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80361d:	74 07                	je     803626 <free_block+0xa5>
  80361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803622:	8b 00                	mov    (%eax),%eax
  803624:	eb 05                	jmp    80362b <free_block+0xaa>
  803626:	b8 00 00 00 00       	mov    $0x0,%eax
  80362b:	a3 34 50 80 00       	mov    %eax,0x805034
  803630:	a1 34 50 80 00       	mov    0x805034,%eax
  803635:	85 c0                	test   %eax,%eax
  803637:	75 a7                	jne    8035e0 <free_block+0x5f>
  803639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80363d:	75 a1                	jne    8035e0 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80363f:	90                   	nop
  803640:	c9                   	leave  
  803641:	c3                   	ret    

00803642 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803642:	55                   	push   %ebp
  803643:	89 e5                	mov    %esp,%ebp
  803645:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803648:	ff 75 08             	pushl  0x8(%ebp)
  80364b:	e8 ed ec ff ff       	call   80233d <get_block_size>
  803650:	83 c4 04             	add    $0x4,%esp
  803653:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80365d:	eb 17                	jmp    803676 <copy_data+0x34>
  80365f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803662:	8b 45 0c             	mov    0xc(%ebp),%eax
  803665:	01 c2                	add    %eax,%edx
  803667:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80366a:	8b 45 08             	mov    0x8(%ebp),%eax
  80366d:	01 c8                	add    %ecx,%eax
  80366f:	8a 00                	mov    (%eax),%al
  803671:	88 02                	mov    %al,(%edx)
  803673:	ff 45 fc             	incl   -0x4(%ebp)
  803676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803679:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80367c:	72 e1                	jb     80365f <copy_data+0x1d>
}
  80367e:	90                   	nop
  80367f:	c9                   	leave  
  803680:	c3                   	ret    

00803681 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803681:	55                   	push   %ebp
  803682:	89 e5                	mov    %esp,%ebp
  803684:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803687:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80368b:	75 23                	jne    8036b0 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80368d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803691:	74 13                	je     8036a6 <realloc_block_FF+0x25>
  803693:	83 ec 0c             	sub    $0xc,%esp
  803696:	ff 75 0c             	pushl  0xc(%ebp)
  803699:	e8 1f f0 ff ff       	call   8026bd <alloc_block_FF>
  80369e:	83 c4 10             	add    $0x10,%esp
  8036a1:	e9 f4 06 00 00       	jmp    803d9a <realloc_block_FF+0x719>
		return NULL;
  8036a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ab:	e9 ea 06 00 00       	jmp    803d9a <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8036b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036b4:	75 18                	jne    8036ce <realloc_block_FF+0x4d>
	{
		free_block(va);
  8036b6:	83 ec 0c             	sub    $0xc,%esp
  8036b9:	ff 75 08             	pushl  0x8(%ebp)
  8036bc:	e8 c0 fe ff ff       	call   803581 <free_block>
  8036c1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8036c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c9:	e9 cc 06 00 00       	jmp    803d9a <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8036ce:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8036d2:	77 07                	ja     8036db <realloc_block_FF+0x5a>
  8036d4:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8036db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036de:	83 e0 01             	and    $0x1,%eax
  8036e1:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8036e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e7:	83 c0 08             	add    $0x8,%eax
  8036ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8036ed:	83 ec 0c             	sub    $0xc,%esp
  8036f0:	ff 75 08             	pushl  0x8(%ebp)
  8036f3:	e8 45 ec ff ff       	call   80233d <get_block_size>
  8036f8:	83 c4 10             	add    $0x10,%esp
  8036fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8036fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803701:	83 e8 08             	sub    $0x8,%eax
  803704:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	83 e8 04             	sub    $0x4,%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	83 e0 fe             	and    $0xfffffffe,%eax
  803712:	89 c2                	mov    %eax,%edx
  803714:	8b 45 08             	mov    0x8(%ebp),%eax
  803717:	01 d0                	add    %edx,%eax
  803719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80371c:	83 ec 0c             	sub    $0xc,%esp
  80371f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803722:	e8 16 ec ff ff       	call   80233d <get_block_size>
  803727:	83 c4 10             	add    $0x10,%esp
  80372a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80372d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803730:	83 e8 08             	sub    $0x8,%eax
  803733:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803736:	8b 45 0c             	mov    0xc(%ebp),%eax
  803739:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80373c:	75 08                	jne    803746 <realloc_block_FF+0xc5>
	{
		 return va;
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	e9 54 06 00 00       	jmp    803d9a <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803746:	8b 45 0c             	mov    0xc(%ebp),%eax
  803749:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80374c:	0f 83 e5 03 00 00    	jae    803b37 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803755:	2b 45 0c             	sub    0xc(%ebp),%eax
  803758:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80375b:	83 ec 0c             	sub    $0xc,%esp
  80375e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803761:	e8 f0 eb ff ff       	call   802356 <is_free_block>
  803766:	83 c4 10             	add    $0x10,%esp
  803769:	84 c0                	test   %al,%al
  80376b:	0f 84 3b 01 00 00    	je     8038ac <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803771:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803774:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803777:	01 d0                	add    %edx,%eax
  803779:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80377c:	83 ec 04             	sub    $0x4,%esp
  80377f:	6a 01                	push   $0x1
  803781:	ff 75 f0             	pushl  -0x10(%ebp)
  803784:	ff 75 08             	pushl  0x8(%ebp)
  803787:	e8 02 ef ff ff       	call   80268e <set_block_data>
  80378c:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	83 e8 04             	sub    $0x4,%eax
  803795:	8b 00                	mov    (%eax),%eax
  803797:	83 e0 fe             	and    $0xfffffffe,%eax
  80379a:	89 c2                	mov    %eax,%edx
  80379c:	8b 45 08             	mov    0x8(%ebp),%eax
  80379f:	01 d0                	add    %edx,%eax
  8037a1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8037a4:	83 ec 04             	sub    $0x4,%esp
  8037a7:	6a 00                	push   $0x0
  8037a9:	ff 75 cc             	pushl  -0x34(%ebp)
  8037ac:	ff 75 c8             	pushl  -0x38(%ebp)
  8037af:	e8 da ee ff ff       	call   80268e <set_block_data>
  8037b4:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037bb:	74 06                	je     8037c3 <realloc_block_FF+0x142>
  8037bd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8037c1:	75 17                	jne    8037da <realloc_block_FF+0x159>
  8037c3:	83 ec 04             	sub    $0x4,%esp
  8037c6:	68 d8 4b 80 00       	push   $0x804bd8
  8037cb:	68 f6 01 00 00       	push   $0x1f6
  8037d0:	68 65 4b 80 00       	push   $0x804b65
  8037d5:	e8 1b d0 ff ff       	call   8007f5 <_panic>
  8037da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037dd:	8b 10                	mov    (%eax),%edx
  8037df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037e2:	89 10                	mov    %edx,(%eax)
  8037e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037e7:	8b 00                	mov    (%eax),%eax
  8037e9:	85 c0                	test   %eax,%eax
  8037eb:	74 0b                	je     8037f8 <realloc_block_FF+0x177>
  8037ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8037f5:	89 50 04             	mov    %edx,0x4(%eax)
  8037f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8037fe:	89 10                	mov    %edx,(%eax)
  803800:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803803:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803806:	89 50 04             	mov    %edx,0x4(%eax)
  803809:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80380c:	8b 00                	mov    (%eax),%eax
  80380e:	85 c0                	test   %eax,%eax
  803810:	75 08                	jne    80381a <realloc_block_FF+0x199>
  803812:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803815:	a3 30 50 80 00       	mov    %eax,0x805030
  80381a:	a1 38 50 80 00       	mov    0x805038,%eax
  80381f:	40                   	inc    %eax
  803820:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803825:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803829:	75 17                	jne    803842 <realloc_block_FF+0x1c1>
  80382b:	83 ec 04             	sub    $0x4,%esp
  80382e:	68 47 4b 80 00       	push   $0x804b47
  803833:	68 f7 01 00 00       	push   $0x1f7
  803838:	68 65 4b 80 00       	push   $0x804b65
  80383d:	e8 b3 cf ff ff       	call   8007f5 <_panic>
  803842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803845:	8b 00                	mov    (%eax),%eax
  803847:	85 c0                	test   %eax,%eax
  803849:	74 10                	je     80385b <realloc_block_FF+0x1da>
  80384b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384e:	8b 00                	mov    (%eax),%eax
  803850:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803853:	8b 52 04             	mov    0x4(%edx),%edx
  803856:	89 50 04             	mov    %edx,0x4(%eax)
  803859:	eb 0b                	jmp    803866 <realloc_block_FF+0x1e5>
  80385b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385e:	8b 40 04             	mov    0x4(%eax),%eax
  803861:	a3 30 50 80 00       	mov    %eax,0x805030
  803866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803869:	8b 40 04             	mov    0x4(%eax),%eax
  80386c:	85 c0                	test   %eax,%eax
  80386e:	74 0f                	je     80387f <realloc_block_FF+0x1fe>
  803870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803873:	8b 40 04             	mov    0x4(%eax),%eax
  803876:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803879:	8b 12                	mov    (%edx),%edx
  80387b:	89 10                	mov    %edx,(%eax)
  80387d:	eb 0a                	jmp    803889 <realloc_block_FF+0x208>
  80387f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803882:	8b 00                	mov    (%eax),%eax
  803884:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803892:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803895:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80389c:	a1 38 50 80 00       	mov    0x805038,%eax
  8038a1:	48                   	dec    %eax
  8038a2:	a3 38 50 80 00       	mov    %eax,0x805038
  8038a7:	e9 83 02 00 00       	jmp    803b2f <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8038ac:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8038b0:	0f 86 69 02 00 00    	jbe    803b1f <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8038b6:	83 ec 04             	sub    $0x4,%esp
  8038b9:	6a 01                	push   $0x1
  8038bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8038be:	ff 75 08             	pushl  0x8(%ebp)
  8038c1:	e8 c8 ed ff ff       	call   80268e <set_block_data>
  8038c6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cc:	83 e8 04             	sub    $0x4,%eax
  8038cf:	8b 00                	mov    (%eax),%eax
  8038d1:	83 e0 fe             	and    $0xfffffffe,%eax
  8038d4:	89 c2                	mov    %eax,%edx
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	01 d0                	add    %edx,%eax
  8038db:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8038de:	a1 38 50 80 00       	mov    0x805038,%eax
  8038e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8038e6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8038ea:	75 68                	jne    803954 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8038ec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038f0:	75 17                	jne    803909 <realloc_block_FF+0x288>
  8038f2:	83 ec 04             	sub    $0x4,%esp
  8038f5:	68 80 4b 80 00       	push   $0x804b80
  8038fa:	68 06 02 00 00       	push   $0x206
  8038ff:	68 65 4b 80 00       	push   $0x804b65
  803904:	e8 ec ce ff ff       	call   8007f5 <_panic>
  803909:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80390f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803912:	89 10                	mov    %edx,(%eax)
  803914:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803917:	8b 00                	mov    (%eax),%eax
  803919:	85 c0                	test   %eax,%eax
  80391b:	74 0d                	je     80392a <realloc_block_FF+0x2a9>
  80391d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803922:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803925:	89 50 04             	mov    %edx,0x4(%eax)
  803928:	eb 08                	jmp    803932 <realloc_block_FF+0x2b1>
  80392a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80392d:	a3 30 50 80 00       	mov    %eax,0x805030
  803932:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803935:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80393a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80393d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803944:	a1 38 50 80 00       	mov    0x805038,%eax
  803949:	40                   	inc    %eax
  80394a:	a3 38 50 80 00       	mov    %eax,0x805038
  80394f:	e9 b0 01 00 00       	jmp    803b04 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803954:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803959:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80395c:	76 68                	jbe    8039c6 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80395e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803962:	75 17                	jne    80397b <realloc_block_FF+0x2fa>
  803964:	83 ec 04             	sub    $0x4,%esp
  803967:	68 80 4b 80 00       	push   $0x804b80
  80396c:	68 0b 02 00 00       	push   $0x20b
  803971:	68 65 4b 80 00       	push   $0x804b65
  803976:	e8 7a ce ff ff       	call   8007f5 <_panic>
  80397b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803981:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803984:	89 10                	mov    %edx,(%eax)
  803986:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803989:	8b 00                	mov    (%eax),%eax
  80398b:	85 c0                	test   %eax,%eax
  80398d:	74 0d                	je     80399c <realloc_block_FF+0x31b>
  80398f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803994:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803997:	89 50 04             	mov    %edx,0x4(%eax)
  80399a:	eb 08                	jmp    8039a4 <realloc_block_FF+0x323>
  80399c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80399f:	a3 30 50 80 00       	mov    %eax,0x805030
  8039a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8039bb:	40                   	inc    %eax
  8039bc:	a3 38 50 80 00       	mov    %eax,0x805038
  8039c1:	e9 3e 01 00 00       	jmp    803b04 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8039c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039cb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039ce:	73 68                	jae    803a38 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039d0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039d4:	75 17                	jne    8039ed <realloc_block_FF+0x36c>
  8039d6:	83 ec 04             	sub    $0x4,%esp
  8039d9:	68 b4 4b 80 00       	push   $0x804bb4
  8039de:	68 10 02 00 00       	push   $0x210
  8039e3:	68 65 4b 80 00       	push   $0x804b65
  8039e8:	e8 08 ce ff ff       	call   8007f5 <_panic>
  8039ed:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8039f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039f6:	89 50 04             	mov    %edx,0x4(%eax)
  8039f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039fc:	8b 40 04             	mov    0x4(%eax),%eax
  8039ff:	85 c0                	test   %eax,%eax
  803a01:	74 0c                	je     803a0f <realloc_block_FF+0x38e>
  803a03:	a1 30 50 80 00       	mov    0x805030,%eax
  803a08:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a0b:	89 10                	mov    %edx,(%eax)
  803a0d:	eb 08                	jmp    803a17 <realloc_block_FF+0x396>
  803a0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a12:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a1a:	a3 30 50 80 00       	mov    %eax,0x805030
  803a1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a28:	a1 38 50 80 00       	mov    0x805038,%eax
  803a2d:	40                   	inc    %eax
  803a2e:	a3 38 50 80 00       	mov    %eax,0x805038
  803a33:	e9 cc 00 00 00       	jmp    803b04 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803a38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803a3f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a47:	e9 8a 00 00 00       	jmp    803ad6 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a52:	73 7a                	jae    803ace <realloc_block_FF+0x44d>
  803a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a57:	8b 00                	mov    (%eax),%eax
  803a59:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a5c:	73 70                	jae    803ace <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803a5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a62:	74 06                	je     803a6a <realloc_block_FF+0x3e9>
  803a64:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a68:	75 17                	jne    803a81 <realloc_block_FF+0x400>
  803a6a:	83 ec 04             	sub    $0x4,%esp
  803a6d:	68 d8 4b 80 00       	push   $0x804bd8
  803a72:	68 1a 02 00 00       	push   $0x21a
  803a77:	68 65 4b 80 00       	push   $0x804b65
  803a7c:	e8 74 cd ff ff       	call   8007f5 <_panic>
  803a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a84:	8b 10                	mov    (%eax),%edx
  803a86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a89:	89 10                	mov    %edx,(%eax)
  803a8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8e:	8b 00                	mov    (%eax),%eax
  803a90:	85 c0                	test   %eax,%eax
  803a92:	74 0b                	je     803a9f <realloc_block_FF+0x41e>
  803a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a97:	8b 00                	mov    (%eax),%eax
  803a99:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a9c:	89 50 04             	mov    %edx,0x4(%eax)
  803a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803aa5:	89 10                	mov    %edx,(%eax)
  803aa7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aad:	89 50 04             	mov    %edx,0x4(%eax)
  803ab0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab3:	8b 00                	mov    (%eax),%eax
  803ab5:	85 c0                	test   %eax,%eax
  803ab7:	75 08                	jne    803ac1 <realloc_block_FF+0x440>
  803ab9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803abc:	a3 30 50 80 00       	mov    %eax,0x805030
  803ac1:	a1 38 50 80 00       	mov    0x805038,%eax
  803ac6:	40                   	inc    %eax
  803ac7:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803acc:	eb 36                	jmp    803b04 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803ace:	a1 34 50 80 00       	mov    0x805034,%eax
  803ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ad6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ada:	74 07                	je     803ae3 <realloc_block_FF+0x462>
  803adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adf:	8b 00                	mov    (%eax),%eax
  803ae1:	eb 05                	jmp    803ae8 <realloc_block_FF+0x467>
  803ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae8:	a3 34 50 80 00       	mov    %eax,0x805034
  803aed:	a1 34 50 80 00       	mov    0x805034,%eax
  803af2:	85 c0                	test   %eax,%eax
  803af4:	0f 85 52 ff ff ff    	jne    803a4c <realloc_block_FF+0x3cb>
  803afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803afe:	0f 85 48 ff ff ff    	jne    803a4c <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803b04:	83 ec 04             	sub    $0x4,%esp
  803b07:	6a 00                	push   $0x0
  803b09:	ff 75 d8             	pushl  -0x28(%ebp)
  803b0c:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b0f:	e8 7a eb ff ff       	call   80268e <set_block_data>
  803b14:	83 c4 10             	add    $0x10,%esp
				return va;
  803b17:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1a:	e9 7b 02 00 00       	jmp    803d9a <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803b1f:	83 ec 0c             	sub    $0xc,%esp
  803b22:	68 55 4c 80 00       	push   $0x804c55
  803b27:	e8 86 cf ff ff       	call   800ab2 <cprintf>
  803b2c:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b32:	e9 63 02 00 00       	jmp    803d9a <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b3a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b3d:	0f 86 4d 02 00 00    	jbe    803d90 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803b43:	83 ec 0c             	sub    $0xc,%esp
  803b46:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b49:	e8 08 e8 ff ff       	call   802356 <is_free_block>
  803b4e:	83 c4 10             	add    $0x10,%esp
  803b51:	84 c0                	test   %al,%al
  803b53:	0f 84 37 02 00 00    	je     803d90 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b5c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803b5f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803b62:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b65:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803b68:	76 38                	jbe    803ba2 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803b6a:	83 ec 0c             	sub    $0xc,%esp
  803b6d:	ff 75 08             	pushl  0x8(%ebp)
  803b70:	e8 0c fa ff ff       	call   803581 <free_block>
  803b75:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803b78:	83 ec 0c             	sub    $0xc,%esp
  803b7b:	ff 75 0c             	pushl  0xc(%ebp)
  803b7e:	e8 3a eb ff ff       	call   8026bd <alloc_block_FF>
  803b83:	83 c4 10             	add    $0x10,%esp
  803b86:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803b89:	83 ec 08             	sub    $0x8,%esp
  803b8c:	ff 75 c0             	pushl  -0x40(%ebp)
  803b8f:	ff 75 08             	pushl  0x8(%ebp)
  803b92:	e8 ab fa ff ff       	call   803642 <copy_data>
  803b97:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803b9a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b9d:	e9 f8 01 00 00       	jmp    803d9a <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803ba2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ba5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803ba8:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803bab:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803baf:	0f 87 a0 00 00 00    	ja     803c55 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803bb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bb9:	75 17                	jne    803bd2 <realloc_block_FF+0x551>
  803bbb:	83 ec 04             	sub    $0x4,%esp
  803bbe:	68 47 4b 80 00       	push   $0x804b47
  803bc3:	68 38 02 00 00       	push   $0x238
  803bc8:	68 65 4b 80 00       	push   $0x804b65
  803bcd:	e8 23 cc ff ff       	call   8007f5 <_panic>
  803bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd5:	8b 00                	mov    (%eax),%eax
  803bd7:	85 c0                	test   %eax,%eax
  803bd9:	74 10                	je     803beb <realloc_block_FF+0x56a>
  803bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bde:	8b 00                	mov    (%eax),%eax
  803be0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803be3:	8b 52 04             	mov    0x4(%edx),%edx
  803be6:	89 50 04             	mov    %edx,0x4(%eax)
  803be9:	eb 0b                	jmp    803bf6 <realloc_block_FF+0x575>
  803beb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bee:	8b 40 04             	mov    0x4(%eax),%eax
  803bf1:	a3 30 50 80 00       	mov    %eax,0x805030
  803bf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf9:	8b 40 04             	mov    0x4(%eax),%eax
  803bfc:	85 c0                	test   %eax,%eax
  803bfe:	74 0f                	je     803c0f <realloc_block_FF+0x58e>
  803c00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c03:	8b 40 04             	mov    0x4(%eax),%eax
  803c06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c09:	8b 12                	mov    (%edx),%edx
  803c0b:	89 10                	mov    %edx,(%eax)
  803c0d:	eb 0a                	jmp    803c19 <realloc_block_FF+0x598>
  803c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c12:	8b 00                	mov    (%eax),%eax
  803c14:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c2c:	a1 38 50 80 00       	mov    0x805038,%eax
  803c31:	48                   	dec    %eax
  803c32:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803c37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c3d:	01 d0                	add    %edx,%eax
  803c3f:	83 ec 04             	sub    $0x4,%esp
  803c42:	6a 01                	push   $0x1
  803c44:	50                   	push   %eax
  803c45:	ff 75 08             	pushl  0x8(%ebp)
  803c48:	e8 41 ea ff ff       	call   80268e <set_block_data>
  803c4d:	83 c4 10             	add    $0x10,%esp
  803c50:	e9 36 01 00 00       	jmp    803d8b <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803c55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c5b:	01 d0                	add    %edx,%eax
  803c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803c60:	83 ec 04             	sub    $0x4,%esp
  803c63:	6a 01                	push   $0x1
  803c65:	ff 75 f0             	pushl  -0x10(%ebp)
  803c68:	ff 75 08             	pushl  0x8(%ebp)
  803c6b:	e8 1e ea ff ff       	call   80268e <set_block_data>
  803c70:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c73:	8b 45 08             	mov    0x8(%ebp),%eax
  803c76:	83 e8 04             	sub    $0x4,%eax
  803c79:	8b 00                	mov    (%eax),%eax
  803c7b:	83 e0 fe             	and    $0xfffffffe,%eax
  803c7e:	89 c2                	mov    %eax,%edx
  803c80:	8b 45 08             	mov    0x8(%ebp),%eax
  803c83:	01 d0                	add    %edx,%eax
  803c85:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c8c:	74 06                	je     803c94 <realloc_block_FF+0x613>
  803c8e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803c92:	75 17                	jne    803cab <realloc_block_FF+0x62a>
  803c94:	83 ec 04             	sub    $0x4,%esp
  803c97:	68 d8 4b 80 00       	push   $0x804bd8
  803c9c:	68 44 02 00 00       	push   $0x244
  803ca1:	68 65 4b 80 00       	push   $0x804b65
  803ca6:	e8 4a cb ff ff       	call   8007f5 <_panic>
  803cab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cae:	8b 10                	mov    (%eax),%edx
  803cb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cb3:	89 10                	mov    %edx,(%eax)
  803cb5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cb8:	8b 00                	mov    (%eax),%eax
  803cba:	85 c0                	test   %eax,%eax
  803cbc:	74 0b                	je     803cc9 <realloc_block_FF+0x648>
  803cbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc1:	8b 00                	mov    (%eax),%eax
  803cc3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803cc6:	89 50 04             	mov    %edx,0x4(%eax)
  803cc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ccc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ccf:	89 10                	mov    %edx,(%eax)
  803cd1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cd7:	89 50 04             	mov    %edx,0x4(%eax)
  803cda:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cdd:	8b 00                	mov    (%eax),%eax
  803cdf:	85 c0                	test   %eax,%eax
  803ce1:	75 08                	jne    803ceb <realloc_block_FF+0x66a>
  803ce3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ce6:	a3 30 50 80 00       	mov    %eax,0x805030
  803ceb:	a1 38 50 80 00       	mov    0x805038,%eax
  803cf0:	40                   	inc    %eax
  803cf1:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803cf6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cfa:	75 17                	jne    803d13 <realloc_block_FF+0x692>
  803cfc:	83 ec 04             	sub    $0x4,%esp
  803cff:	68 47 4b 80 00       	push   $0x804b47
  803d04:	68 45 02 00 00       	push   $0x245
  803d09:	68 65 4b 80 00       	push   $0x804b65
  803d0e:	e8 e2 ca ff ff       	call   8007f5 <_panic>
  803d13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d16:	8b 00                	mov    (%eax),%eax
  803d18:	85 c0                	test   %eax,%eax
  803d1a:	74 10                	je     803d2c <realloc_block_FF+0x6ab>
  803d1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d1f:	8b 00                	mov    (%eax),%eax
  803d21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d24:	8b 52 04             	mov    0x4(%edx),%edx
  803d27:	89 50 04             	mov    %edx,0x4(%eax)
  803d2a:	eb 0b                	jmp    803d37 <realloc_block_FF+0x6b6>
  803d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2f:	8b 40 04             	mov    0x4(%eax),%eax
  803d32:	a3 30 50 80 00       	mov    %eax,0x805030
  803d37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3a:	8b 40 04             	mov    0x4(%eax),%eax
  803d3d:	85 c0                	test   %eax,%eax
  803d3f:	74 0f                	je     803d50 <realloc_block_FF+0x6cf>
  803d41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d44:	8b 40 04             	mov    0x4(%eax),%eax
  803d47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d4a:	8b 12                	mov    (%edx),%edx
  803d4c:	89 10                	mov    %edx,(%eax)
  803d4e:	eb 0a                	jmp    803d5a <realloc_block_FF+0x6d9>
  803d50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d53:	8b 00                	mov    (%eax),%eax
  803d55:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d6d:	a1 38 50 80 00       	mov    0x805038,%eax
  803d72:	48                   	dec    %eax
  803d73:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803d78:	83 ec 04             	sub    $0x4,%esp
  803d7b:	6a 00                	push   $0x0
  803d7d:	ff 75 bc             	pushl  -0x44(%ebp)
  803d80:	ff 75 b8             	pushl  -0x48(%ebp)
  803d83:	e8 06 e9 ff ff       	call   80268e <set_block_data>
  803d88:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8e:	eb 0a                	jmp    803d9a <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803d90:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803d97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803d9a:	c9                   	leave  
  803d9b:	c3                   	ret    

00803d9c <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803d9c:	55                   	push   %ebp
  803d9d:	89 e5                	mov    %esp,%ebp
  803d9f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803da2:	83 ec 04             	sub    $0x4,%esp
  803da5:	68 5c 4c 80 00       	push   $0x804c5c
  803daa:	68 58 02 00 00       	push   $0x258
  803daf:	68 65 4b 80 00       	push   $0x804b65
  803db4:	e8 3c ca ff ff       	call   8007f5 <_panic>

00803db9 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803db9:	55                   	push   %ebp
  803dba:	89 e5                	mov    %esp,%ebp
  803dbc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803dbf:	83 ec 04             	sub    $0x4,%esp
  803dc2:	68 84 4c 80 00       	push   $0x804c84
  803dc7:	68 61 02 00 00       	push   $0x261
  803dcc:	68 65 4b 80 00       	push   $0x804b65
  803dd1:	e8 1f ca ff ff       	call   8007f5 <_panic>
  803dd6:	66 90                	xchg   %ax,%ax

00803dd8 <__udivdi3>:
  803dd8:	55                   	push   %ebp
  803dd9:	57                   	push   %edi
  803dda:	56                   	push   %esi
  803ddb:	53                   	push   %ebx
  803ddc:	83 ec 1c             	sub    $0x1c,%esp
  803ddf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803de3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803de7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803deb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803def:	89 ca                	mov    %ecx,%edx
  803df1:	89 f8                	mov    %edi,%eax
  803df3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803df7:	85 f6                	test   %esi,%esi
  803df9:	75 2d                	jne    803e28 <__udivdi3+0x50>
  803dfb:	39 cf                	cmp    %ecx,%edi
  803dfd:	77 65                	ja     803e64 <__udivdi3+0x8c>
  803dff:	89 fd                	mov    %edi,%ebp
  803e01:	85 ff                	test   %edi,%edi
  803e03:	75 0b                	jne    803e10 <__udivdi3+0x38>
  803e05:	b8 01 00 00 00       	mov    $0x1,%eax
  803e0a:	31 d2                	xor    %edx,%edx
  803e0c:	f7 f7                	div    %edi
  803e0e:	89 c5                	mov    %eax,%ebp
  803e10:	31 d2                	xor    %edx,%edx
  803e12:	89 c8                	mov    %ecx,%eax
  803e14:	f7 f5                	div    %ebp
  803e16:	89 c1                	mov    %eax,%ecx
  803e18:	89 d8                	mov    %ebx,%eax
  803e1a:	f7 f5                	div    %ebp
  803e1c:	89 cf                	mov    %ecx,%edi
  803e1e:	89 fa                	mov    %edi,%edx
  803e20:	83 c4 1c             	add    $0x1c,%esp
  803e23:	5b                   	pop    %ebx
  803e24:	5e                   	pop    %esi
  803e25:	5f                   	pop    %edi
  803e26:	5d                   	pop    %ebp
  803e27:	c3                   	ret    
  803e28:	39 ce                	cmp    %ecx,%esi
  803e2a:	77 28                	ja     803e54 <__udivdi3+0x7c>
  803e2c:	0f bd fe             	bsr    %esi,%edi
  803e2f:	83 f7 1f             	xor    $0x1f,%edi
  803e32:	75 40                	jne    803e74 <__udivdi3+0x9c>
  803e34:	39 ce                	cmp    %ecx,%esi
  803e36:	72 0a                	jb     803e42 <__udivdi3+0x6a>
  803e38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e3c:	0f 87 9e 00 00 00    	ja     803ee0 <__udivdi3+0x108>
  803e42:	b8 01 00 00 00       	mov    $0x1,%eax
  803e47:	89 fa                	mov    %edi,%edx
  803e49:	83 c4 1c             	add    $0x1c,%esp
  803e4c:	5b                   	pop    %ebx
  803e4d:	5e                   	pop    %esi
  803e4e:	5f                   	pop    %edi
  803e4f:	5d                   	pop    %ebp
  803e50:	c3                   	ret    
  803e51:	8d 76 00             	lea    0x0(%esi),%esi
  803e54:	31 ff                	xor    %edi,%edi
  803e56:	31 c0                	xor    %eax,%eax
  803e58:	89 fa                	mov    %edi,%edx
  803e5a:	83 c4 1c             	add    $0x1c,%esp
  803e5d:	5b                   	pop    %ebx
  803e5e:	5e                   	pop    %esi
  803e5f:	5f                   	pop    %edi
  803e60:	5d                   	pop    %ebp
  803e61:	c3                   	ret    
  803e62:	66 90                	xchg   %ax,%ax
  803e64:	89 d8                	mov    %ebx,%eax
  803e66:	f7 f7                	div    %edi
  803e68:	31 ff                	xor    %edi,%edi
  803e6a:	89 fa                	mov    %edi,%edx
  803e6c:	83 c4 1c             	add    $0x1c,%esp
  803e6f:	5b                   	pop    %ebx
  803e70:	5e                   	pop    %esi
  803e71:	5f                   	pop    %edi
  803e72:	5d                   	pop    %ebp
  803e73:	c3                   	ret    
  803e74:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e79:	89 eb                	mov    %ebp,%ebx
  803e7b:	29 fb                	sub    %edi,%ebx
  803e7d:	89 f9                	mov    %edi,%ecx
  803e7f:	d3 e6                	shl    %cl,%esi
  803e81:	89 c5                	mov    %eax,%ebp
  803e83:	88 d9                	mov    %bl,%cl
  803e85:	d3 ed                	shr    %cl,%ebp
  803e87:	89 e9                	mov    %ebp,%ecx
  803e89:	09 f1                	or     %esi,%ecx
  803e8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e8f:	89 f9                	mov    %edi,%ecx
  803e91:	d3 e0                	shl    %cl,%eax
  803e93:	89 c5                	mov    %eax,%ebp
  803e95:	89 d6                	mov    %edx,%esi
  803e97:	88 d9                	mov    %bl,%cl
  803e99:	d3 ee                	shr    %cl,%esi
  803e9b:	89 f9                	mov    %edi,%ecx
  803e9d:	d3 e2                	shl    %cl,%edx
  803e9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ea3:	88 d9                	mov    %bl,%cl
  803ea5:	d3 e8                	shr    %cl,%eax
  803ea7:	09 c2                	or     %eax,%edx
  803ea9:	89 d0                	mov    %edx,%eax
  803eab:	89 f2                	mov    %esi,%edx
  803ead:	f7 74 24 0c          	divl   0xc(%esp)
  803eb1:	89 d6                	mov    %edx,%esi
  803eb3:	89 c3                	mov    %eax,%ebx
  803eb5:	f7 e5                	mul    %ebp
  803eb7:	39 d6                	cmp    %edx,%esi
  803eb9:	72 19                	jb     803ed4 <__udivdi3+0xfc>
  803ebb:	74 0b                	je     803ec8 <__udivdi3+0xf0>
  803ebd:	89 d8                	mov    %ebx,%eax
  803ebf:	31 ff                	xor    %edi,%edi
  803ec1:	e9 58 ff ff ff       	jmp    803e1e <__udivdi3+0x46>
  803ec6:	66 90                	xchg   %ax,%ax
  803ec8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ecc:	89 f9                	mov    %edi,%ecx
  803ece:	d3 e2                	shl    %cl,%edx
  803ed0:	39 c2                	cmp    %eax,%edx
  803ed2:	73 e9                	jae    803ebd <__udivdi3+0xe5>
  803ed4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ed7:	31 ff                	xor    %edi,%edi
  803ed9:	e9 40 ff ff ff       	jmp    803e1e <__udivdi3+0x46>
  803ede:	66 90                	xchg   %ax,%ax
  803ee0:	31 c0                	xor    %eax,%eax
  803ee2:	e9 37 ff ff ff       	jmp    803e1e <__udivdi3+0x46>
  803ee7:	90                   	nop

00803ee8 <__umoddi3>:
  803ee8:	55                   	push   %ebp
  803ee9:	57                   	push   %edi
  803eea:	56                   	push   %esi
  803eeb:	53                   	push   %ebx
  803eec:	83 ec 1c             	sub    $0x1c,%esp
  803eef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ef3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ef7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803efb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803eff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f07:	89 f3                	mov    %esi,%ebx
  803f09:	89 fa                	mov    %edi,%edx
  803f0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f0f:	89 34 24             	mov    %esi,(%esp)
  803f12:	85 c0                	test   %eax,%eax
  803f14:	75 1a                	jne    803f30 <__umoddi3+0x48>
  803f16:	39 f7                	cmp    %esi,%edi
  803f18:	0f 86 a2 00 00 00    	jbe    803fc0 <__umoddi3+0xd8>
  803f1e:	89 c8                	mov    %ecx,%eax
  803f20:	89 f2                	mov    %esi,%edx
  803f22:	f7 f7                	div    %edi
  803f24:	89 d0                	mov    %edx,%eax
  803f26:	31 d2                	xor    %edx,%edx
  803f28:	83 c4 1c             	add    $0x1c,%esp
  803f2b:	5b                   	pop    %ebx
  803f2c:	5e                   	pop    %esi
  803f2d:	5f                   	pop    %edi
  803f2e:	5d                   	pop    %ebp
  803f2f:	c3                   	ret    
  803f30:	39 f0                	cmp    %esi,%eax
  803f32:	0f 87 ac 00 00 00    	ja     803fe4 <__umoddi3+0xfc>
  803f38:	0f bd e8             	bsr    %eax,%ebp
  803f3b:	83 f5 1f             	xor    $0x1f,%ebp
  803f3e:	0f 84 ac 00 00 00    	je     803ff0 <__umoddi3+0x108>
  803f44:	bf 20 00 00 00       	mov    $0x20,%edi
  803f49:	29 ef                	sub    %ebp,%edi
  803f4b:	89 fe                	mov    %edi,%esi
  803f4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f51:	89 e9                	mov    %ebp,%ecx
  803f53:	d3 e0                	shl    %cl,%eax
  803f55:	89 d7                	mov    %edx,%edi
  803f57:	89 f1                	mov    %esi,%ecx
  803f59:	d3 ef                	shr    %cl,%edi
  803f5b:	09 c7                	or     %eax,%edi
  803f5d:	89 e9                	mov    %ebp,%ecx
  803f5f:	d3 e2                	shl    %cl,%edx
  803f61:	89 14 24             	mov    %edx,(%esp)
  803f64:	89 d8                	mov    %ebx,%eax
  803f66:	d3 e0                	shl    %cl,%eax
  803f68:	89 c2                	mov    %eax,%edx
  803f6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f6e:	d3 e0                	shl    %cl,%eax
  803f70:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f74:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f78:	89 f1                	mov    %esi,%ecx
  803f7a:	d3 e8                	shr    %cl,%eax
  803f7c:	09 d0                	or     %edx,%eax
  803f7e:	d3 eb                	shr    %cl,%ebx
  803f80:	89 da                	mov    %ebx,%edx
  803f82:	f7 f7                	div    %edi
  803f84:	89 d3                	mov    %edx,%ebx
  803f86:	f7 24 24             	mull   (%esp)
  803f89:	89 c6                	mov    %eax,%esi
  803f8b:	89 d1                	mov    %edx,%ecx
  803f8d:	39 d3                	cmp    %edx,%ebx
  803f8f:	0f 82 87 00 00 00    	jb     80401c <__umoddi3+0x134>
  803f95:	0f 84 91 00 00 00    	je     80402c <__umoddi3+0x144>
  803f9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f9f:	29 f2                	sub    %esi,%edx
  803fa1:	19 cb                	sbb    %ecx,%ebx
  803fa3:	89 d8                	mov    %ebx,%eax
  803fa5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803fa9:	d3 e0                	shl    %cl,%eax
  803fab:	89 e9                	mov    %ebp,%ecx
  803fad:	d3 ea                	shr    %cl,%edx
  803faf:	09 d0                	or     %edx,%eax
  803fb1:	89 e9                	mov    %ebp,%ecx
  803fb3:	d3 eb                	shr    %cl,%ebx
  803fb5:	89 da                	mov    %ebx,%edx
  803fb7:	83 c4 1c             	add    $0x1c,%esp
  803fba:	5b                   	pop    %ebx
  803fbb:	5e                   	pop    %esi
  803fbc:	5f                   	pop    %edi
  803fbd:	5d                   	pop    %ebp
  803fbe:	c3                   	ret    
  803fbf:	90                   	nop
  803fc0:	89 fd                	mov    %edi,%ebp
  803fc2:	85 ff                	test   %edi,%edi
  803fc4:	75 0b                	jne    803fd1 <__umoddi3+0xe9>
  803fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803fcb:	31 d2                	xor    %edx,%edx
  803fcd:	f7 f7                	div    %edi
  803fcf:	89 c5                	mov    %eax,%ebp
  803fd1:	89 f0                	mov    %esi,%eax
  803fd3:	31 d2                	xor    %edx,%edx
  803fd5:	f7 f5                	div    %ebp
  803fd7:	89 c8                	mov    %ecx,%eax
  803fd9:	f7 f5                	div    %ebp
  803fdb:	89 d0                	mov    %edx,%eax
  803fdd:	e9 44 ff ff ff       	jmp    803f26 <__umoddi3+0x3e>
  803fe2:	66 90                	xchg   %ax,%ax
  803fe4:	89 c8                	mov    %ecx,%eax
  803fe6:	89 f2                	mov    %esi,%edx
  803fe8:	83 c4 1c             	add    $0x1c,%esp
  803feb:	5b                   	pop    %ebx
  803fec:	5e                   	pop    %esi
  803fed:	5f                   	pop    %edi
  803fee:	5d                   	pop    %ebp
  803fef:	c3                   	ret    
  803ff0:	3b 04 24             	cmp    (%esp),%eax
  803ff3:	72 06                	jb     803ffb <__umoddi3+0x113>
  803ff5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ff9:	77 0f                	ja     80400a <__umoddi3+0x122>
  803ffb:	89 f2                	mov    %esi,%edx
  803ffd:	29 f9                	sub    %edi,%ecx
  803fff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804003:	89 14 24             	mov    %edx,(%esp)
  804006:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80400a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80400e:	8b 14 24             	mov    (%esp),%edx
  804011:	83 c4 1c             	add    $0x1c,%esp
  804014:	5b                   	pop    %ebx
  804015:	5e                   	pop    %esi
  804016:	5f                   	pop    %edi
  804017:	5d                   	pop    %ebp
  804018:	c3                   	ret    
  804019:	8d 76 00             	lea    0x0(%esi),%esi
  80401c:	2b 04 24             	sub    (%esp),%eax
  80401f:	19 fa                	sbb    %edi,%edx
  804021:	89 d1                	mov    %edx,%ecx
  804023:	89 c6                	mov    %eax,%esi
  804025:	e9 71 ff ff ff       	jmp    803f9b <__umoddi3+0xb3>
  80402a:	66 90                	xchg   %ax,%ax
  80402c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804030:	72 ea                	jb     80401c <__umoddi3+0x134>
  804032:	89 d9                	mov    %ebx,%ecx
  804034:	e9 62 ff ff ff       	jmp    803f9b <__umoddi3+0xb3>
