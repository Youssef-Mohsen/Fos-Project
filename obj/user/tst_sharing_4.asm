
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
  80003f:	a1 04 30 80 00       	mov    0x803004,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 04 30 80 00       	mov    0x803004,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 00 22 80 00       	push   $0x802200
  800061:	6a 13                	push   $0x13
  800063:	68 1c 22 80 00       	push   $0x80221c
  800068:	e8 80 07 00 00       	call   8007ed <_panic>
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
  800085:	68 34 22 80 00       	push   $0x802234
  80008a:	e8 1b 0a 00 00       	call   800aaa <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	68 68 22 80 00       	push   $0x802268
  80009a:	e8 0b 0a 00 00       	call   800aaa <cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 c4 22 80 00       	push   $0x8022c4
  8000aa:	e8 fb 09 00 00       	call   800aaa <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000b2:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000b9:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	int envID = sys_getenvid();
  8000c0:	e8 79 1b 00 00       	call   801c3e <sys_getenvid>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000c8:	83 ec 0c             	sub    $0xc,%esp
  8000cb:	68 f8 22 80 00       	push   $0x8022f8
  8000d0:	e8 d5 09 00 00       	call   800aaa <cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 b1 19 00 00       	call   801a8e <sys_calculate_free_frames>
  8000dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 01                	push   $0x1
  8000e5:	68 00 10 00 00       	push   $0x1000
  8000ea:	68 2c 23 80 00       	push   $0x80232c
  8000ef:	e8 a9 17 00 00       	call   80189d <smalloc>
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (x != (uint32*)pagealloc_start)
  8000fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000fd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800100:	74 17                	je     800119 <_main+0xe1>
		{is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800102:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 30 23 80 00       	push   $0x802330
  800111:	e8 94 09 00 00       	call   800aaa <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  800119:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800120:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800123:	e8 66 19 00 00       	call   801a8e <sys_calculate_free_frames>
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
  80014c:	e8 3d 19 00 00       	call   801a8e <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015b:	50                   	push   %eax
  80015c:	68 9c 23 80 00       	push   $0x80239c
  800161:	e8 44 09 00 00       	call   800aaa <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	ff 75 d8             	pushl  -0x28(%ebp)
  80016f:	e8 72 17 00 00       	call   8018e6 <sfree>
  800174:	83 c4 10             	add    $0x10,%esp
		expected = 0 ;
  800177:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80017e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800181:	e8 08 19 00 00       	call   801a8e <sys_calculate_free_frames>
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
  80019f:	e8 ea 18 00 00       	call   801a8e <sys_calculate_free_frames>
  8001a4:	29 c3                	sub    %eax,%ebx
  8001a6:	89 d8                	mov    %ebx,%eax
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	50                   	push   %eax
  8001ac:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001af:	68 34 24 80 00       	push   $0x802434
  8001b4:	e8 f1 08 00 00       	call   800aaa <cprintf>
  8001b9:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step A completed!!\n\n\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 7f 24 80 00       	push   $0x80247f
  8001c4:	e8 e1 08 00 00       	call   800aaa <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8001cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d0:	74 04                	je     8001d6 <_main+0x19e>
  8001d2:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8001d6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking free of 2 shared objects ... [25%]\n");
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 98 24 80 00       	push   $0x802498
  8001e5:	e8 c0 08 00 00       	call   800aaa <cprintf>
  8001ea:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  8001ed:	e8 9c 18 00 00       	call   801a8e <sys_calculate_free_frames>
  8001f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	6a 01                	push   $0x1
  8001fa:	68 00 10 00 00       	push   $0x1000
  8001ff:	68 cd 24 80 00       	push   $0x8024cd
  800204:	e8 94 16 00 00       	call   80189d <smalloc>
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	6a 01                	push   $0x1
  800214:	68 00 10 00 00       	push   $0x1000
  800219:	68 2c 23 80 00       	push   $0x80232c
  80021e:	e8 7a 16 00 00       	call   80189d <smalloc>
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if(x == NULL)
  800229:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80022d:	75 17                	jne    800246 <_main+0x20e>
		{is_correct = 0; cprintf("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  80022f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 d0 24 80 00       	push   $0x8024d0
  80023e:	e8 67 08 00 00       	call   800aaa <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp

		expected = 2+1 ; /*2pages +1table*/
  800246:	c7 45 d4 03 00 00 00 	movl   $0x3,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80024d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800250:	e8 39 18 00 00       	call   801a8e <sys_calculate_free_frames>
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
  800279:	68 28 25 80 00       	push   $0x802528
  80027e:	e8 27 08 00 00       	call   800aaa <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp

		sfree(z);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 75 c8             	pushl  -0x38(%ebp)
  80028c:	e8 55 16 00 00       	call   8018e6 <sfree>
  800291:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800294:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80029b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80029e:	e8 eb 17 00 00       	call   801a8e <sys_calculate_free_frames>
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
  8002bc:	e8 cd 17 00 00       	call   801a8e <sys_calculate_free_frames>
  8002c1:	29 c3                	sub    %eax,%ebx
  8002c3:	89 d8                	mov    %ebx,%eax
  8002c5:	83 ec 04             	sub    $0x4,%esp
  8002c8:	50                   	push   %eax
  8002c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cc:	68 34 24 80 00       	push   $0x802434
  8002d1:	e8 d4 07 00 00       	call   800aaa <cprintf>
  8002d6:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002df:	e8 02 16 00 00       	call   8018e6 <sfree>
  8002e4:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8002e7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8002ee:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002f1:	e8 98 17 00 00       	call   801a8e <sys_calculate_free_frames>
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
  80030f:	e8 7a 17 00 00       	call   801a8e <sys_calculate_free_frames>
  800314:	29 c3                	sub    %eax,%ebx
  800316:	89 d8                	mov    %ebx,%eax
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	50                   	push   %eax
  80031c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031f:	68 34 24 80 00       	push   $0x802434
  800324:	e8 81 07 00 00       	call   800aaa <cprintf>
  800329:	83 c4 10             	add    $0x10,%esp

	}
	cprintf("Step B completed!!\n\n\n");
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	68 7d 25 80 00       	push   $0x80257d
  800334:	e8 71 07 00 00       	call   800aaa <cprintf>
  800339:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  80033c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800340:	74 04                	je     800346 <_main+0x30e>
  800342:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800346:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP C: checking range of loop during free... [50%]\n");
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	68 94 25 80 00       	push   $0x802594
  800355:	e8 50 07 00 00       	call   800aaa <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80035d:	e8 2c 17 00 00       	call   801a8e <sys_calculate_free_frames>
  800362:	89 45 c0             	mov    %eax,-0x40(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	6a 01                	push   $0x1
  80036a:	68 01 30 00 00       	push   $0x3001
  80036f:	68 c9 25 80 00       	push   $0x8025c9
  800374:	e8 24 15 00 00       	call   80189d <smalloc>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	6a 01                	push   $0x1
  800384:	68 00 10 00 00       	push   $0x1000
  800389:	68 cb 25 80 00       	push   $0x8025cb
  80038e:	e8 0a 15 00 00       	call   80189d <smalloc>
  800393:	83 c4 10             	add    $0x10,%esp
  800396:	89 45 b8             	mov    %eax,-0x48(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  800399:	c7 45 d4 06 00 00 00 	movl   $0x6,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003a0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8003a3:	e8 e6 16 00 00       	call   801a8e <sys_calculate_free_frames>
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
  8003cc:	e8 bd 16 00 00       	call   801a8e <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 ec 04             	sub    $0x4,%esp
  8003d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	68 9c 23 80 00       	push   $0x80239c
  8003e1:	e8 c4 06 00 00       	call   800aaa <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp

		sfree(w);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	ff 75 bc             	pushl  -0x44(%ebp)
  8003ef:	e8 f2 14 00 00       	call   8018e6 <sfree>
  8003f4:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8003f7:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003fe:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800401:	e8 88 16 00 00       	call   801a8e <sys_calculate_free_frames>
  800406:	29 c3                	sub    %eax,%ebx
  800408:	89 d8                	mov    %ebx,%eax
  80040a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  80040d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800410:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800413:	74 27                	je     80043c <_main+0x404>
  800415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80041c:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80041f:	e8 6a 16 00 00       	call   801a8e <sys_calculate_free_frames>
  800424:	29 c3                	sub    %eax,%ebx
  800426:	89 d8                	mov    %ebx,%eax
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	50                   	push   %eax
  80042c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80042f:	68 34 24 80 00       	push   $0x802434
  800434:	e8 71 06 00 00       	call   800aaa <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80043c:	83 ec 04             	sub    $0x4,%esp
  80043f:	6a 01                	push   $0x1
  800441:	68 ff 1f 00 00       	push   $0x1fff
  800446:	68 cd 25 80 00       	push   $0x8025cd
  80044b:	e8 4d 14 00 00       	call   80189d <smalloc>
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800456:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80045d:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800460:	e8 29 16 00 00       	call   801a8e <sys_calculate_free_frames>
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
  80047e:	e8 0b 16 00 00       	call   801a8e <sys_calculate_free_frames>
  800483:	29 c3                	sub    %eax,%ebx
  800485:	89 d8                	mov    %ebx,%eax
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80048d:	50                   	push   %eax
  80048e:	68 9c 23 80 00       	push   $0x80239c
  800493:	e8 12 06 00 00       	call   800aaa <cprintf>
  800498:	83 c4 10             	add    $0x10,%esp

		sfree(o);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004a1:	e8 40 14 00 00       	call   8018e6 <sfree>
  8004a6:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8004a9:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004b0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004b3:	e8 d6 15 00 00       	call   801a8e <sys_calculate_free_frames>
  8004b8:	29 c3                	sub    %eax,%ebx
  8004ba:	89 d8                	mov    %ebx,%eax
  8004bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004c5:	74 27                	je     8004ee <_main+0x4b6>
  8004c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ce:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004d1:	e8 b8 15 00 00       	call   801a8e <sys_calculate_free_frames>
  8004d6:	29 c3                	sub    %eax,%ebx
  8004d8:	89 d8                	mov    %ebx,%eax
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	50                   	push   %eax
  8004de:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004e1:	68 34 24 80 00       	push   $0x802434
  8004e6:	e8 bf 05 00 00       	call   800aaa <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp

		sfree(u);
  8004ee:	83 ec 0c             	sub    $0xc,%esp
  8004f1:	ff 75 b8             	pushl  -0x48(%ebp)
  8004f4:	e8 ed 13 00 00       	call   8018e6 <sfree>
  8004f9:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8004fc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800503:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800506:	e8 83 15 00 00       	call   801a8e <sys_calculate_free_frames>
  80050b:	29 c3                	sub    %eax,%ebx
  80050d:	89 d8                	mov    %ebx,%eax
  80050f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800512:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800515:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800518:	74 27                	je     800541 <_main+0x509>
  80051a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800521:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800524:	e8 65 15 00 00       	call   801a8e <sys_calculate_free_frames>
  800529:	29 c3                	sub    %eax,%ebx
  80052b:	89 d8                	mov    %ebx,%eax
  80052d:	83 ec 04             	sub    $0x4,%esp
  800530:	50                   	push   %eax
  800531:	ff 75 d4             	pushl  -0x2c(%ebp)
  800534:	68 34 24 80 00       	push   $0x802434
  800539:	e8 6c 05 00 00       	call   800aaa <cprintf>
  80053e:	83 c4 10             	add    $0x10,%esp


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800541:	e8 48 15 00 00       	call   801a8e <sys_calculate_free_frames>
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
  80055b:	68 c9 25 80 00       	push   $0x8025c9
  800560:	e8 38 13 00 00       	call   80189d <smalloc>
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
  800581:	68 cb 25 80 00       	push   $0x8025cb
  800586:	e8 12 13 00 00       	call   80189d <smalloc>
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
  8005a3:	68 cd 25 80 00       	push   $0x8025cd
  8005a8:	e8 f0 12 00 00       	call   80189d <smalloc>
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  8005b3:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8005ba:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8005bd:	e8 cc 14 00 00       	call   801a8e <sys_calculate_free_frames>
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
  8005e6:	e8 a3 14 00 00       	call   801a8e <sys_calculate_free_frames>
  8005eb:	29 c3                	sub    %eax,%ebx
  8005ed:	89 d8                	mov    %ebx,%eax
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005f5:	50                   	push   %eax
  8005f6:	68 9c 23 80 00       	push   $0x80239c
  8005fb:	e8 aa 04 00 00       	call   800aaa <cprintf>
  800600:	83 c4 10             	add    $0x10,%esp

		freeFrames = sys_calculate_free_frames() ;
  800603:	e8 86 14 00 00       	call   801a8e <sys_calculate_free_frames>
  800608:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(o);
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	ff 75 b4             	pushl  -0x4c(%ebp)
  800611:	e8 d0 12 00 00       	call   8018e6 <sfree>
  800616:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(w);
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	ff 75 bc             	pushl  -0x44(%ebp)
  80061f:	e8 c2 12 00 00       	call   8018e6 <sfree>
  800624:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(u);
  800627:	83 ec 0c             	sub    $0xc,%esp
  80062a:	ff 75 b8             	pushl  -0x48(%ebp)
  80062d:	e8 b4 12 00 00       	call   8018e6 <sfree>
  800632:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  800635:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  80063c:	e8 4d 14 00 00       	call   801a8e <sys_calculate_free_frames>
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
  80065f:	e8 2a 14 00 00       	call   801a8e <sys_calculate_free_frames>
  800664:	29 c3                	sub    %eax,%ebx
  800666:	89 d8                	mov    %ebx,%eax
  800668:	83 ec 04             	sub    $0x4,%esp
  80066b:	50                   	push   %eax
  80066c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80066f:	68 34 24 80 00       	push   $0x802434
  800674:	e8 31 04 00 00       	call   800aaa <cprintf>
  800679:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step C completed!!\n\n\n");
  80067c:	83 ec 0c             	sub    $0xc,%esp
  80067f:	68 cf 25 80 00       	push   $0x8025cf
  800684:	e8 21 04 00 00       	call   800aaa <cprintf>
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
  8006a3:	68 e8 25 80 00       	push   $0x8025e8
  8006a8:	e8 fd 03 00 00       	call   800aaa <cprintf>
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
  8006bc:	e8 96 15 00 00       	call   801c57 <sys_getenvindex>
  8006c1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8006c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c7:	89 d0                	mov    %edx,%eax
  8006c9:	c1 e0 02             	shl    $0x2,%eax
  8006cc:	01 d0                	add    %edx,%eax
  8006ce:	01 c0                	add    %eax,%eax
  8006d0:	01 d0                	add    %edx,%eax
  8006d2:	c1 e0 02             	shl    $0x2,%eax
  8006d5:	01 d0                	add    %edx,%eax
  8006d7:	01 c0                	add    %eax,%eax
  8006d9:	01 d0                	add    %edx,%eax
  8006db:	c1 e0 04             	shl    $0x4,%eax
  8006de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006e3:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006e8:	a1 04 30 80 00       	mov    0x803004,%eax
  8006ed:	8a 40 20             	mov    0x20(%eax),%al
  8006f0:	84 c0                	test   %al,%al
  8006f2:	74 0d                	je     800701 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8006f4:	a1 04 30 80 00       	mov    0x803004,%eax
  8006f9:	83 c0 20             	add    $0x20,%eax
  8006fc:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800701:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800705:	7e 0a                	jle    800711 <libmain+0x5b>
		binaryname = argv[0];
  800707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	e8 19 f9 ff ff       	call   800038 <_main>
  80071f:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800722:	e8 b4 12 00 00       	call   8019db <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	68 3c 26 80 00       	push   $0x80263c
  80072f:	e8 76 03 00 00       	call   800aaa <cprintf>
  800734:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800737:	a1 04 30 80 00       	mov    0x803004,%eax
  80073c:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800742:	a1 04 30 80 00       	mov    0x803004,%eax
  800747:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	52                   	push   %edx
  800751:	50                   	push   %eax
  800752:	68 64 26 80 00       	push   $0x802664
  800757:	e8 4e 03 00 00       	call   800aaa <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80075f:	a1 04 30 80 00       	mov    0x803004,%eax
  800764:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80076a:	a1 04 30 80 00       	mov    0x803004,%eax
  80076f:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800775:	a1 04 30 80 00       	mov    0x803004,%eax
  80077a:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800780:	51                   	push   %ecx
  800781:	52                   	push   %edx
  800782:	50                   	push   %eax
  800783:	68 8c 26 80 00       	push   $0x80268c
  800788:	e8 1d 03 00 00       	call   800aaa <cprintf>
  80078d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800790:	a1 04 30 80 00       	mov    0x803004,%eax
  800795:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	50                   	push   %eax
  80079f:	68 e4 26 80 00       	push   $0x8026e4
  8007a4:	e8 01 03 00 00       	call   800aaa <cprintf>
  8007a9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8007ac:	83 ec 0c             	sub    $0xc,%esp
  8007af:	68 3c 26 80 00       	push   $0x80263c
  8007b4:	e8 f1 02 00 00       	call   800aaa <cprintf>
  8007b9:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8007bc:	e8 34 12 00 00       	call   8019f5 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8007c1:	e8 19 00 00 00       	call   8007df <exit>
}
  8007c6:	90                   	nop
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007cf:	83 ec 0c             	sub    $0xc,%esp
  8007d2:	6a 00                	push   $0x0
  8007d4:	e8 4a 14 00 00       	call   801c23 <sys_destroy_env>
  8007d9:	83 c4 10             	add    $0x10,%esp
}
  8007dc:	90                   	nop
  8007dd:	c9                   	leave  
  8007de:	c3                   	ret    

008007df <exit>:

void
exit(void)
{
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007e5:	e8 9f 14 00 00       	call   801c89 <sys_exit_env>
}
  8007ea:	90                   	nop
  8007eb:	c9                   	leave  
  8007ec:	c3                   	ret    

008007ed <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007f3:	8d 45 10             	lea    0x10(%ebp),%eax
  8007f6:	83 c0 04             	add    $0x4,%eax
  8007f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007fc:	a1 24 30 80 00       	mov    0x803024,%eax
  800801:	85 c0                	test   %eax,%eax
  800803:	74 16                	je     80081b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800805:	a1 24 30 80 00       	mov    0x803024,%eax
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	50                   	push   %eax
  80080e:	68 f8 26 80 00       	push   $0x8026f8
  800813:	e8 92 02 00 00       	call   800aaa <cprintf>
  800818:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80081b:	a1 00 30 80 00       	mov    0x803000,%eax
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	ff 75 08             	pushl  0x8(%ebp)
  800826:	50                   	push   %eax
  800827:	68 fd 26 80 00       	push   $0x8026fd
  80082c:	e8 79 02 00 00       	call   800aaa <cprintf>
  800831:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800834:	8b 45 10             	mov    0x10(%ebp),%eax
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	ff 75 f4             	pushl  -0xc(%ebp)
  80083d:	50                   	push   %eax
  80083e:	e8 fc 01 00 00       	call   800a3f <vcprintf>
  800843:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	6a 00                	push   $0x0
  80084b:	68 19 27 80 00       	push   $0x802719
  800850:	e8 ea 01 00 00       	call   800a3f <vcprintf>
  800855:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800858:	e8 82 ff ff ff       	call   8007df <exit>

	// should not return here
	while (1) ;
  80085d:	eb fe                	jmp    80085d <_panic+0x70>

0080085f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800865:	a1 04 30 80 00       	mov    0x803004,%eax
  80086a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800870:	8b 45 0c             	mov    0xc(%ebp),%eax
  800873:	39 c2                	cmp    %eax,%edx
  800875:	74 14                	je     80088b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 1c 27 80 00       	push   $0x80271c
  80087f:	6a 26                	push   $0x26
  800881:	68 68 27 80 00       	push   $0x802768
  800886:	e8 62 ff ff ff       	call   8007ed <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80088b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800892:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800899:	e9 c5 00 00 00       	jmp    800963 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80089e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	85 c0                	test   %eax,%eax
  8008b1:	75 08                	jne    8008bb <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8008b3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008b6:	e9 a5 00 00 00       	jmp    800960 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8008bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008c9:	eb 69                	jmp    800934 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008cb:	a1 04 30 80 00       	mov    0x803004,%eax
  8008d0:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8008d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008d9:	89 d0                	mov    %edx,%eax
  8008db:	01 c0                	add    %eax,%eax
  8008dd:	01 d0                	add    %edx,%eax
  8008df:	c1 e0 03             	shl    $0x3,%eax
  8008e2:	01 c8                	add    %ecx,%eax
  8008e4:	8a 40 04             	mov    0x4(%eax),%al
  8008e7:	84 c0                	test   %al,%al
  8008e9:	75 46                	jne    800931 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008eb:	a1 04 30 80 00       	mov    0x803004,%eax
  8008f0:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8008f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	c1 e0 03             	shl    $0x3,%eax
  800902:	01 c8                	add    %ecx,%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800909:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80090c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800911:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800916:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	01 c8                	add    %ecx,%eax
  800922:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800924:	39 c2                	cmp    %eax,%edx
  800926:	75 09                	jne    800931 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800928:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80092f:	eb 15                	jmp    800946 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800931:	ff 45 e8             	incl   -0x18(%ebp)
  800934:	a1 04 30 80 00       	mov    0x803004,%eax
  800939:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80093f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800942:	39 c2                	cmp    %eax,%edx
  800944:	77 85                	ja     8008cb <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800946:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80094a:	75 14                	jne    800960 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80094c:	83 ec 04             	sub    $0x4,%esp
  80094f:	68 74 27 80 00       	push   $0x802774
  800954:	6a 3a                	push   $0x3a
  800956:	68 68 27 80 00       	push   $0x802768
  80095b:	e8 8d fe ff ff       	call   8007ed <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800960:	ff 45 f0             	incl   -0x10(%ebp)
  800963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800966:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800969:	0f 8c 2f ff ff ff    	jl     80089e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80096f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800976:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80097d:	eb 26                	jmp    8009a5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80097f:	a1 04 30 80 00       	mov    0x803004,%eax
  800984:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80098a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80098d:	89 d0                	mov    %edx,%eax
  80098f:	01 c0                	add    %eax,%eax
  800991:	01 d0                	add    %edx,%eax
  800993:	c1 e0 03             	shl    $0x3,%eax
  800996:	01 c8                	add    %ecx,%eax
  800998:	8a 40 04             	mov    0x4(%eax),%al
  80099b:	3c 01                	cmp    $0x1,%al
  80099d:	75 03                	jne    8009a2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80099f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009a2:	ff 45 e0             	incl   -0x20(%ebp)
  8009a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8009aa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b3:	39 c2                	cmp    %eax,%edx
  8009b5:	77 c8                	ja     80097f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ba:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009bd:	74 14                	je     8009d3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8009bf:	83 ec 04             	sub    $0x4,%esp
  8009c2:	68 c8 27 80 00       	push   $0x8027c8
  8009c7:	6a 44                	push   $0x44
  8009c9:	68 68 27 80 00       	push   $0x802768
  8009ce:	e8 1a fe ff ff       	call   8007ed <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009d3:	90                   	nop
  8009d4:	c9                   	leave  
  8009d5:	c3                   	ret    

008009d6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	8b 00                	mov    (%eax),%eax
  8009e1:	8d 48 01             	lea    0x1(%eax),%ecx
  8009e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e7:	89 0a                	mov    %ecx,(%edx)
  8009e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8009ec:	88 d1                	mov    %dl,%cl
  8009ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	8b 00                	mov    (%eax),%eax
  8009fa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009ff:	75 2c                	jne    800a2d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a01:	a0 08 30 80 00       	mov    0x803008,%al
  800a06:	0f b6 c0             	movzbl %al,%eax
  800a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0c:	8b 12                	mov    (%edx),%edx
  800a0e:	89 d1                	mov    %edx,%ecx
  800a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a13:	83 c2 08             	add    $0x8,%edx
  800a16:	83 ec 04             	sub    $0x4,%esp
  800a19:	50                   	push   %eax
  800a1a:	51                   	push   %ecx
  800a1b:	52                   	push   %edx
  800a1c:	e8 78 0f 00 00       	call   801999 <sys_cputs>
  800a21:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a30:	8b 40 04             	mov    0x4(%eax),%eax
  800a33:	8d 50 01             	lea    0x1(%eax),%edx
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a3c:	90                   	nop
  800a3d:	c9                   	leave  
  800a3e:	c3                   	ret    

00800a3f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a48:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a4f:	00 00 00 
	b.cnt = 0;
  800a52:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a59:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	ff 75 08             	pushl  0x8(%ebp)
  800a62:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a68:	50                   	push   %eax
  800a69:	68 d6 09 80 00       	push   $0x8009d6
  800a6e:	e8 11 02 00 00       	call   800c84 <vprintfmt>
  800a73:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a76:	a0 08 30 80 00       	mov    0x803008,%al
  800a7b:	0f b6 c0             	movzbl %al,%eax
  800a7e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a84:	83 ec 04             	sub    $0x4,%esp
  800a87:	50                   	push   %eax
  800a88:	52                   	push   %edx
  800a89:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a8f:	83 c0 08             	add    $0x8,%eax
  800a92:	50                   	push   %eax
  800a93:	e8 01 0f 00 00       	call   801999 <sys_cputs>
  800a98:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a9b:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800aa2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800aa8:	c9                   	leave  
  800aa9:	c3                   	ret    

00800aaa <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ab0:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800ab7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac6:	50                   	push   %eax
  800ac7:	e8 73 ff ff ff       	call   800a3f <vcprintf>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad5:	c9                   	leave  
  800ad6:	c3                   	ret    

00800ad7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800add:	e8 f9 0e 00 00       	call   8019db <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ae2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 f4             	pushl  -0xc(%ebp)
  800af1:	50                   	push   %eax
  800af2:	e8 48 ff ff ff       	call   800a3f <vcprintf>
  800af7:	83 c4 10             	add    $0x10,%esp
  800afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800afd:	e8 f3 0e 00 00       	call   8019f5 <sys_unlock_cons>
	return cnt;
  800b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	53                   	push   %ebx
  800b0b:	83 ec 14             	sub    $0x14,%esp
  800b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b14:	8b 45 14             	mov    0x14(%ebp),%eax
  800b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b1a:	8b 45 18             	mov    0x18(%ebp),%eax
  800b1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b22:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b25:	77 55                	ja     800b7c <printnum+0x75>
  800b27:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b2a:	72 05                	jb     800b31 <printnum+0x2a>
  800b2c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b2f:	77 4b                	ja     800b7c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b31:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b34:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b37:	8b 45 18             	mov    0x18(%ebp),%eax
  800b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3f:	52                   	push   %edx
  800b40:	50                   	push   %eax
  800b41:	ff 75 f4             	pushl  -0xc(%ebp)
  800b44:	ff 75 f0             	pushl  -0x10(%ebp)
  800b47:	e8 4c 14 00 00       	call   801f98 <__udivdi3>
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	83 ec 04             	sub    $0x4,%esp
  800b52:	ff 75 20             	pushl  0x20(%ebp)
  800b55:	53                   	push   %ebx
  800b56:	ff 75 18             	pushl  0x18(%ebp)
  800b59:	52                   	push   %edx
  800b5a:	50                   	push   %eax
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	ff 75 08             	pushl  0x8(%ebp)
  800b61:	e8 a1 ff ff ff       	call   800b07 <printnum>
  800b66:	83 c4 20             	add    $0x20,%esp
  800b69:	eb 1a                	jmp    800b85 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	ff 75 20             	pushl  0x20(%ebp)
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b7c:	ff 4d 1c             	decl   0x1c(%ebp)
  800b7f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b83:	7f e6                	jg     800b6b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b85:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b93:	53                   	push   %ebx
  800b94:	51                   	push   %ecx
  800b95:	52                   	push   %edx
  800b96:	50                   	push   %eax
  800b97:	e8 0c 15 00 00       	call   8020a8 <__umoddi3>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	05 34 2a 80 00       	add    $0x802a34,%eax
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	0f be c0             	movsbl %al,%eax
  800ba9:	83 ec 08             	sub    $0x8,%esp
  800bac:	ff 75 0c             	pushl  0xc(%ebp)
  800baf:	50                   	push   %eax
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	ff d0                	call   *%eax
  800bb5:	83 c4 10             	add    $0x10,%esp
}
  800bb8:	90                   	nop
  800bb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc5:	7e 1c                	jle    800be3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	8d 50 08             	lea    0x8(%eax),%edx
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 10                	mov    %edx,(%eax)
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	83 e8 08             	sub    $0x8,%eax
  800bdc:	8b 50 04             	mov    0x4(%eax),%edx
  800bdf:	8b 00                	mov    (%eax),%eax
  800be1:	eb 40                	jmp    800c23 <getuint+0x65>
	else if (lflag)
  800be3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be7:	74 1e                	je     800c07 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 00                	mov    (%eax),%eax
  800bee:	8d 50 04             	lea    0x4(%eax),%edx
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 10                	mov    %edx,(%eax)
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8b 00                	mov    (%eax),%eax
  800bfb:	83 e8 04             	sub    $0x4,%eax
  800bfe:	8b 00                	mov    (%eax),%eax
  800c00:	ba 00 00 00 00       	mov    $0x0,%edx
  800c05:	eb 1c                	jmp    800c23 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	8d 50 04             	lea    0x4(%eax),%edx
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	89 10                	mov    %edx,(%eax)
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8b 00                	mov    (%eax),%eax
  800c19:	83 e8 04             	sub    $0x4,%eax
  800c1c:	8b 00                	mov    (%eax),%eax
  800c1e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c28:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c2c:	7e 1c                	jle    800c4a <getint+0x25>
		return va_arg(*ap, long long);
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8b 00                	mov    (%eax),%eax
  800c33:	8d 50 08             	lea    0x8(%eax),%edx
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	89 10                	mov    %edx,(%eax)
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8b 00                	mov    (%eax),%eax
  800c40:	83 e8 08             	sub    $0x8,%eax
  800c43:	8b 50 04             	mov    0x4(%eax),%edx
  800c46:	8b 00                	mov    (%eax),%eax
  800c48:	eb 38                	jmp    800c82 <getint+0x5d>
	else if (lflag)
  800c4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4e:	74 1a                	je     800c6a <getint+0x45>
		return va_arg(*ap, long);
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	8b 00                	mov    (%eax),%eax
  800c55:	8d 50 04             	lea    0x4(%eax),%edx
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	89 10                	mov    %edx,(%eax)
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8b 00                	mov    (%eax),%eax
  800c62:	83 e8 04             	sub    $0x4,%eax
  800c65:	8b 00                	mov    (%eax),%eax
  800c67:	99                   	cltd   
  800c68:	eb 18                	jmp    800c82 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8b 00                	mov    (%eax),%eax
  800c6f:	8d 50 04             	lea    0x4(%eax),%edx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	89 10                	mov    %edx,(%eax)
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	83 e8 04             	sub    $0x4,%eax
  800c7f:	8b 00                	mov    (%eax),%eax
  800c81:	99                   	cltd   
}
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
  800c89:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c8c:	eb 17                	jmp    800ca5 <vprintfmt+0x21>
			if (ch == '\0')
  800c8e:	85 db                	test   %ebx,%ebx
  800c90:	0f 84 c1 03 00 00    	je     801057 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c96:	83 ec 08             	sub    $0x8,%esp
  800c99:	ff 75 0c             	pushl  0xc(%ebp)
  800c9c:	53                   	push   %ebx
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	ff d0                	call   *%eax
  800ca2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca8:	8d 50 01             	lea    0x1(%eax),%edx
  800cab:	89 55 10             	mov    %edx,0x10(%ebp)
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	0f b6 d8             	movzbl %al,%ebx
  800cb3:	83 fb 25             	cmp    $0x25,%ebx
  800cb6:	75 d6                	jne    800c8e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cb8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cbc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cc3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cd1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	8d 50 01             	lea    0x1(%eax),%edx
  800cde:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	0f b6 d8             	movzbl %al,%ebx
  800ce6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ce9:	83 f8 5b             	cmp    $0x5b,%eax
  800cec:	0f 87 3d 03 00 00    	ja     80102f <vprintfmt+0x3ab>
  800cf2:	8b 04 85 58 2a 80 00 	mov    0x802a58(,%eax,4),%eax
  800cf9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cfb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cff:	eb d7                	jmp    800cd8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d01:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d05:	eb d1                	jmp    800cd8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d11:	89 d0                	mov    %edx,%eax
  800d13:	c1 e0 02             	shl    $0x2,%eax
  800d16:	01 d0                	add    %edx,%eax
  800d18:	01 c0                	add    %eax,%eax
  800d1a:	01 d8                	add    %ebx,%eax
  800d1c:	83 e8 30             	sub    $0x30,%eax
  800d1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d22:	8b 45 10             	mov    0x10(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d2a:	83 fb 2f             	cmp    $0x2f,%ebx
  800d2d:	7e 3e                	jle    800d6d <vprintfmt+0xe9>
  800d2f:	83 fb 39             	cmp    $0x39,%ebx
  800d32:	7f 39                	jg     800d6d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d34:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d37:	eb d5                	jmp    800d0e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d39:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3c:	83 c0 04             	add    $0x4,%eax
  800d3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d42:	8b 45 14             	mov    0x14(%ebp),%eax
  800d45:	83 e8 04             	sub    $0x4,%eax
  800d48:	8b 00                	mov    (%eax),%eax
  800d4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d4d:	eb 1f                	jmp    800d6e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d53:	79 83                	jns    800cd8 <vprintfmt+0x54>
				width = 0;
  800d55:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d5c:	e9 77 ff ff ff       	jmp    800cd8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d61:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d68:	e9 6b ff ff ff       	jmp    800cd8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d6d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d72:	0f 89 60 ff ff ff    	jns    800cd8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d7e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d85:	e9 4e ff ff ff       	jmp    800cd8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d8a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d8d:	e9 46 ff ff ff       	jmp    800cd8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d92:	8b 45 14             	mov    0x14(%ebp),%eax
  800d95:	83 c0 04             	add    $0x4,%eax
  800d98:	89 45 14             	mov    %eax,0x14(%ebp)
  800d9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9e:	83 e8 04             	sub    $0x4,%eax
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	83 ec 08             	sub    $0x8,%esp
  800da6:	ff 75 0c             	pushl  0xc(%ebp)
  800da9:	50                   	push   %eax
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	ff d0                	call   *%eax
  800daf:	83 c4 10             	add    $0x10,%esp
			break;
  800db2:	e9 9b 02 00 00       	jmp    801052 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800db7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc3:	83 e8 04             	sub    $0x4,%eax
  800dc6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800dc8:	85 db                	test   %ebx,%ebx
  800dca:	79 02                	jns    800dce <vprintfmt+0x14a>
				err = -err;
  800dcc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dce:	83 fb 64             	cmp    $0x64,%ebx
  800dd1:	7f 0b                	jg     800dde <vprintfmt+0x15a>
  800dd3:	8b 34 9d a0 28 80 00 	mov    0x8028a0(,%ebx,4),%esi
  800dda:	85 f6                	test   %esi,%esi
  800ddc:	75 19                	jne    800df7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dde:	53                   	push   %ebx
  800ddf:	68 45 2a 80 00       	push   $0x802a45
  800de4:	ff 75 0c             	pushl  0xc(%ebp)
  800de7:	ff 75 08             	pushl  0x8(%ebp)
  800dea:	e8 70 02 00 00       	call   80105f <printfmt>
  800def:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800df2:	e9 5b 02 00 00       	jmp    801052 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800df7:	56                   	push   %esi
  800df8:	68 4e 2a 80 00       	push   $0x802a4e
  800dfd:	ff 75 0c             	pushl  0xc(%ebp)
  800e00:	ff 75 08             	pushl  0x8(%ebp)
  800e03:	e8 57 02 00 00       	call   80105f <printfmt>
  800e08:	83 c4 10             	add    $0x10,%esp
			break;
  800e0b:	e9 42 02 00 00       	jmp    801052 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e10:	8b 45 14             	mov    0x14(%ebp),%eax
  800e13:	83 c0 04             	add    $0x4,%eax
  800e16:	89 45 14             	mov    %eax,0x14(%ebp)
  800e19:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1c:	83 e8 04             	sub    $0x4,%eax
  800e1f:	8b 30                	mov    (%eax),%esi
  800e21:	85 f6                	test   %esi,%esi
  800e23:	75 05                	jne    800e2a <vprintfmt+0x1a6>
				p = "(null)";
  800e25:	be 51 2a 80 00       	mov    $0x802a51,%esi
			if (width > 0 && padc != '-')
  800e2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2e:	7e 6d                	jle    800e9d <vprintfmt+0x219>
  800e30:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e34:	74 67                	je     800e9d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e39:	83 ec 08             	sub    $0x8,%esp
  800e3c:	50                   	push   %eax
  800e3d:	56                   	push   %esi
  800e3e:	e8 1e 03 00 00       	call   801161 <strnlen>
  800e43:	83 c4 10             	add    $0x10,%esp
  800e46:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e49:	eb 16                	jmp    800e61 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e4b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e4f:	83 ec 08             	sub    $0x8,%esp
  800e52:	ff 75 0c             	pushl  0xc(%ebp)
  800e55:	50                   	push   %eax
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	ff d0                	call   *%eax
  800e5b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e5e:	ff 4d e4             	decl   -0x1c(%ebp)
  800e61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e65:	7f e4                	jg     800e4b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e67:	eb 34                	jmp    800e9d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e69:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e6d:	74 1c                	je     800e8b <vprintfmt+0x207>
  800e6f:	83 fb 1f             	cmp    $0x1f,%ebx
  800e72:	7e 05                	jle    800e79 <vprintfmt+0x1f5>
  800e74:	83 fb 7e             	cmp    $0x7e,%ebx
  800e77:	7e 12                	jle    800e8b <vprintfmt+0x207>
					putch('?', putdat);
  800e79:	83 ec 08             	sub    $0x8,%esp
  800e7c:	ff 75 0c             	pushl  0xc(%ebp)
  800e7f:	6a 3f                	push   $0x3f
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	ff d0                	call   *%eax
  800e86:	83 c4 10             	add    $0x10,%esp
  800e89:	eb 0f                	jmp    800e9a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e8b:	83 ec 08             	sub    $0x8,%esp
  800e8e:	ff 75 0c             	pushl  0xc(%ebp)
  800e91:	53                   	push   %ebx
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	ff d0                	call   *%eax
  800e97:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e9a:	ff 4d e4             	decl   -0x1c(%ebp)
  800e9d:	89 f0                	mov    %esi,%eax
  800e9f:	8d 70 01             	lea    0x1(%eax),%esi
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	0f be d8             	movsbl %al,%ebx
  800ea7:	85 db                	test   %ebx,%ebx
  800ea9:	74 24                	je     800ecf <vprintfmt+0x24b>
  800eab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eaf:	78 b8                	js     800e69 <vprintfmt+0x1e5>
  800eb1:	ff 4d e0             	decl   -0x20(%ebp)
  800eb4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eb8:	79 af                	jns    800e69 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eba:	eb 13                	jmp    800ecf <vprintfmt+0x24b>
				putch(' ', putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	6a 20                	push   $0x20
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ecc:	ff 4d e4             	decl   -0x1c(%ebp)
  800ecf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed3:	7f e7                	jg     800ebc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ed5:	e9 78 01 00 00       	jmp    801052 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 e8             	pushl  -0x18(%ebp)
  800ee0:	8d 45 14             	lea    0x14(%ebp),%eax
  800ee3:	50                   	push   %eax
  800ee4:	e8 3c fd ff ff       	call   800c25 <getint>
  800ee9:	83 c4 10             	add    $0x10,%esp
  800eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef8:	85 d2                	test   %edx,%edx
  800efa:	79 23                	jns    800f1f <vprintfmt+0x29b>
				putch('-', putdat);
  800efc:	83 ec 08             	sub    $0x8,%esp
  800eff:	ff 75 0c             	pushl  0xc(%ebp)
  800f02:	6a 2d                	push   $0x2d
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	ff d0                	call   *%eax
  800f09:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f12:	f7 d8                	neg    %eax
  800f14:	83 d2 00             	adc    $0x0,%edx
  800f17:	f7 da                	neg    %edx
  800f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f1f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f26:	e9 bc 00 00 00       	jmp    800fe7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f31:	8d 45 14             	lea    0x14(%ebp),%eax
  800f34:	50                   	push   %eax
  800f35:	e8 84 fc ff ff       	call   800bbe <getuint>
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f43:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f4a:	e9 98 00 00 00       	jmp    800fe7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	6a 58                	push   $0x58
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	ff d0                	call   *%eax
  800f5c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f5f:	83 ec 08             	sub    $0x8,%esp
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	6a 58                	push   $0x58
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	ff d0                	call   *%eax
  800f6c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	6a 58                	push   $0x58
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	ff d0                	call   *%eax
  800f7c:	83 c4 10             	add    $0x10,%esp
			break;
  800f7f:	e9 ce 00 00 00       	jmp    801052 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	6a 30                	push   $0x30
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff d0                	call   *%eax
  800f91:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f94:	83 ec 08             	sub    $0x8,%esp
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	6a 78                	push   $0x78
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	ff d0                	call   *%eax
  800fa1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fa4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa7:	83 c0 04             	add    $0x4,%eax
  800faa:	89 45 14             	mov    %eax,0x14(%ebp)
  800fad:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb0:	83 e8 04             	sub    $0x4,%eax
  800fb3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fbf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fc6:	eb 1f                	jmp    800fe7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fc8:	83 ec 08             	sub    $0x8,%esp
  800fcb:	ff 75 e8             	pushl  -0x18(%ebp)
  800fce:	8d 45 14             	lea    0x14(%ebp),%eax
  800fd1:	50                   	push   %eax
  800fd2:	e8 e7 fb ff ff       	call   800bbe <getuint>
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fdd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fe0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fe7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fee:	83 ec 04             	sub    $0x4,%esp
  800ff1:	52                   	push   %edx
  800ff2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ff5:	50                   	push   %eax
  800ff6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff9:	ff 75 f0             	pushl  -0x10(%ebp)
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	ff 75 08             	pushl  0x8(%ebp)
  801002:	e8 00 fb ff ff       	call   800b07 <printnum>
  801007:	83 c4 20             	add    $0x20,%esp
			break;
  80100a:	eb 46                	jmp    801052 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	53                   	push   %ebx
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	ff d0                	call   *%eax
  801018:	83 c4 10             	add    $0x10,%esp
			break;
  80101b:	eb 35                	jmp    801052 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80101d:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  801024:	eb 2c                	jmp    801052 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801026:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80102d:	eb 23                	jmp    801052 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80102f:	83 ec 08             	sub    $0x8,%esp
  801032:	ff 75 0c             	pushl  0xc(%ebp)
  801035:	6a 25                	push   $0x25
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	ff d0                	call   *%eax
  80103c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80103f:	ff 4d 10             	decl   0x10(%ebp)
  801042:	eb 03                	jmp    801047 <vprintfmt+0x3c3>
  801044:	ff 4d 10             	decl   0x10(%ebp)
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	48                   	dec    %eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 25                	cmp    $0x25,%al
  80104f:	75 f3                	jne    801044 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801051:	90                   	nop
		}
	}
  801052:	e9 35 fc ff ff       	jmp    800c8c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801057:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801058:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80105b:	5b                   	pop    %ebx
  80105c:	5e                   	pop    %esi
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    

0080105f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801065:	8d 45 10             	lea    0x10(%ebp),%eax
  801068:	83 c0 04             	add    $0x4,%eax
  80106b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80106e:	8b 45 10             	mov    0x10(%ebp),%eax
  801071:	ff 75 f4             	pushl  -0xc(%ebp)
  801074:	50                   	push   %eax
  801075:	ff 75 0c             	pushl  0xc(%ebp)
  801078:	ff 75 08             	pushl  0x8(%ebp)
  80107b:	e8 04 fc ff ff       	call   800c84 <vprintfmt>
  801080:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801083:	90                   	nop
  801084:	c9                   	leave  
  801085:	c3                   	ret    

00801086 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	8b 40 08             	mov    0x8(%eax),%eax
  80108f:	8d 50 01             	lea    0x1(%eax),%edx
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	8b 10                	mov    (%eax),%edx
  80109d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a0:	8b 40 04             	mov    0x4(%eax),%eax
  8010a3:	39 c2                	cmp    %eax,%edx
  8010a5:	73 12                	jae    8010b9 <sprintputch+0x33>
		*b->buf++ = ch;
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8b 00                	mov    (%eax),%eax
  8010ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8010af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b2:	89 0a                	mov    %ecx,(%edx)
  8010b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b7:	88 10                	mov    %dl,(%eax)
}
  8010b9:	90                   	nop
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	01 d0                	add    %edx,%eax
  8010d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010e1:	74 06                	je     8010e9 <vsnprintf+0x2d>
  8010e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e7:	7f 07                	jg     8010f0 <vsnprintf+0x34>
		return -E_INVAL;
  8010e9:	b8 03 00 00 00       	mov    $0x3,%eax
  8010ee:	eb 20                	jmp    801110 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010f0:	ff 75 14             	pushl  0x14(%ebp)
  8010f3:	ff 75 10             	pushl  0x10(%ebp)
  8010f6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010f9:	50                   	push   %eax
  8010fa:	68 86 10 80 00       	push   $0x801086
  8010ff:	e8 80 fb ff ff       	call   800c84 <vprintfmt>
  801104:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801107:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80110a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80110d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801118:	8d 45 10             	lea    0x10(%ebp),%eax
  80111b:	83 c0 04             	add    $0x4,%eax
  80111e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801121:	8b 45 10             	mov    0x10(%ebp),%eax
  801124:	ff 75 f4             	pushl  -0xc(%ebp)
  801127:	50                   	push   %eax
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	e8 89 ff ff ff       	call   8010bc <vsnprintf>
  801133:	83 c4 10             	add    $0x10,%esp
  801136:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801139:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    

0080113e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80114b:	eb 06                	jmp    801153 <strlen+0x15>
		n++;
  80114d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801150:	ff 45 08             	incl   0x8(%ebp)
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	84 c0                	test   %al,%al
  80115a:	75 f1                	jne    80114d <strlen+0xf>
		n++;
	return n;
  80115c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80116e:	eb 09                	jmp    801179 <strnlen+0x18>
		n++;
  801170:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801173:	ff 45 08             	incl   0x8(%ebp)
  801176:	ff 4d 0c             	decl   0xc(%ebp)
  801179:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117d:	74 09                	je     801188 <strnlen+0x27>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	84 c0                	test   %al,%al
  801186:	75 e8                	jne    801170 <strnlen+0xf>
		n++;
	return n;
  801188:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801199:	90                   	nop
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8d 50 01             	lea    0x1(%eax),%edx
  8011a0:	89 55 08             	mov    %edx,0x8(%ebp)
  8011a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011ac:	8a 12                	mov    (%edx),%dl
  8011ae:	88 10                	mov    %dl,(%eax)
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	84 c0                	test   %al,%al
  8011b4:	75 e4                	jne    80119a <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ce:	eb 1f                	jmp    8011ef <strncpy+0x34>
		*dst++ = *src;
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8d 50 01             	lea    0x1(%eax),%edx
  8011d6:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011dc:	8a 12                	mov    (%edx),%dl
  8011de:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	84 c0                	test   %al,%al
  8011e7:	74 03                	je     8011ec <strncpy+0x31>
			src++;
  8011e9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011ec:	ff 45 fc             	incl   -0x4(%ebp)
  8011ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011f5:	72 d9                	jb     8011d0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011fa:	c9                   	leave  
  8011fb:	c3                   	ret    

008011fc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801208:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80120c:	74 30                	je     80123e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80120e:	eb 16                	jmp    801226 <strlcpy+0x2a>
			*dst++ = *src++;
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8d 50 01             	lea    0x1(%eax),%edx
  801216:	89 55 08             	mov    %edx,0x8(%ebp)
  801219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80121f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801222:	8a 12                	mov    (%edx),%dl
  801224:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801226:	ff 4d 10             	decl   0x10(%ebp)
  801229:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80122d:	74 09                	je     801238 <strlcpy+0x3c>
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	84 c0                	test   %al,%al
  801236:	75 d8                	jne    801210 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80123e:	8b 55 08             	mov    0x8(%ebp),%edx
  801241:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801244:	29 c2                	sub    %eax,%edx
  801246:	89 d0                	mov    %edx,%eax
}
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80124d:	eb 06                	jmp    801255 <strcmp+0xb>
		p++, q++;
  80124f:	ff 45 08             	incl   0x8(%ebp)
  801252:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	84 c0                	test   %al,%al
  80125c:	74 0e                	je     80126c <strcmp+0x22>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 10                	mov    (%eax),%dl
  801263:	8b 45 0c             	mov    0xc(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	38 c2                	cmp    %al,%dl
  80126a:	74 e3                	je     80124f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	0f b6 d0             	movzbl %al,%edx
  801274:	8b 45 0c             	mov    0xc(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	0f b6 c0             	movzbl %al,%eax
  80127c:	29 c2                	sub    %eax,%edx
  80127e:	89 d0                	mov    %edx,%eax
}
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    

00801282 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801285:	eb 09                	jmp    801290 <strncmp+0xe>
		n--, p++, q++;
  801287:	ff 4d 10             	decl   0x10(%ebp)
  80128a:	ff 45 08             	incl   0x8(%ebp)
  80128d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801290:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801294:	74 17                	je     8012ad <strncmp+0x2b>
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	84 c0                	test   %al,%al
  80129d:	74 0e                	je     8012ad <strncmp+0x2b>
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	8a 10                	mov    (%eax),%dl
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	38 c2                	cmp    %al,%dl
  8012ab:	74 da                	je     801287 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b1:	75 07                	jne    8012ba <strncmp+0x38>
		return 0;
  8012b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b8:	eb 14                	jmp    8012ce <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	0f b6 d0             	movzbl %al,%edx
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	0f b6 c0             	movzbl %al,%eax
  8012ca:	29 c2                	sub    %eax,%edx
  8012cc:	89 d0                	mov    %edx,%eax
}
  8012ce:	5d                   	pop    %ebp
  8012cf:	c3                   	ret    

008012d0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 04             	sub    $0x4,%esp
  8012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012dc:	eb 12                	jmp    8012f0 <strchr+0x20>
		if (*s == c)
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012e6:	75 05                	jne    8012ed <strchr+0x1d>
			return (char *) s;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	eb 11                	jmp    8012fe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012ed:	ff 45 08             	incl   0x8(%ebp)
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	8a 00                	mov    (%eax),%al
  8012f5:	84 c0                	test   %al,%al
  8012f7:	75 e5                	jne    8012de <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 04             	sub    $0x4,%esp
  801306:	8b 45 0c             	mov    0xc(%ebp),%eax
  801309:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80130c:	eb 0d                	jmp    80131b <strfind+0x1b>
		if (*s == c)
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801316:	74 0e                	je     801326 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801318:	ff 45 08             	incl   0x8(%ebp)
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	8a 00                	mov    (%eax),%al
  801320:	84 c0                	test   %al,%al
  801322:	75 ea                	jne    80130e <strfind+0xe>
  801324:	eb 01                	jmp    801327 <strfind+0x27>
		if (*s == c)
			break;
  801326:	90                   	nop
	return (char *) s;
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801338:	8b 45 10             	mov    0x10(%ebp),%eax
  80133b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80133e:	eb 0e                	jmp    80134e <memset+0x22>
		*p++ = c;
  801340:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801343:	8d 50 01             	lea    0x1(%eax),%edx
  801346:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801349:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80134e:	ff 4d f8             	decl   -0x8(%ebp)
  801351:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801355:	79 e9                	jns    801340 <memset+0x14>
		*p++ = c;

	return v;
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80136e:	eb 16                	jmp    801386 <memcpy+0x2a>
		*d++ = *s++;
  801370:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801373:	8d 50 01             	lea    0x1(%eax),%edx
  801376:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801379:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80137f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801382:	8a 12                	mov    (%edx),%dl
  801384:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801386:	8b 45 10             	mov    0x10(%ebp),%eax
  801389:	8d 50 ff             	lea    -0x1(%eax),%edx
  80138c:	89 55 10             	mov    %edx,0x10(%ebp)
  80138f:	85 c0                	test   %eax,%eax
  801391:	75 dd                	jne    801370 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80139e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013b0:	73 50                	jae    801402 <memmove+0x6a>
  8013b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b8:	01 d0                	add    %edx,%eax
  8013ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013bd:	76 43                	jbe    801402 <memmove+0x6a>
		s += n;
  8013bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013cb:	eb 10                	jmp    8013dd <memmove+0x45>
			*--d = *--s;
  8013cd:	ff 4d f8             	decl   -0x8(%ebp)
  8013d0:	ff 4d fc             	decl   -0x4(%ebp)
  8013d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d6:	8a 10                	mov    (%eax),%dl
  8013d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013db:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013e3:	89 55 10             	mov    %edx,0x10(%ebp)
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	75 e3                	jne    8013cd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013ea:	eb 23                	jmp    80140f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ef:	8d 50 01             	lea    0x1(%eax),%edx
  8013f2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013fb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013fe:	8a 12                	mov    (%edx),%dl
  801400:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	8d 50 ff             	lea    -0x1(%eax),%edx
  801408:	89 55 10             	mov    %edx,0x10(%ebp)
  80140b:	85 c0                	test   %eax,%eax
  80140d:	75 dd                	jne    8013ec <memmove+0x54>
			*d++ = *s++;

	return dst;
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801426:	eb 2a                	jmp    801452 <memcmp+0x3e>
		if (*s1 != *s2)
  801428:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142b:	8a 10                	mov    (%eax),%dl
  80142d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	38 c2                	cmp    %al,%dl
  801434:	74 16                	je     80144c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801436:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	0f b6 d0             	movzbl %al,%edx
  80143e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	0f b6 c0             	movzbl %al,%eax
  801446:	29 c2                	sub    %eax,%edx
  801448:	89 d0                	mov    %edx,%eax
  80144a:	eb 18                	jmp    801464 <memcmp+0x50>
		s1++, s2++;
  80144c:	ff 45 fc             	incl   -0x4(%ebp)
  80144f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801452:	8b 45 10             	mov    0x10(%ebp),%eax
  801455:	8d 50 ff             	lea    -0x1(%eax),%edx
  801458:	89 55 10             	mov    %edx,0x10(%ebp)
  80145b:	85 c0                	test   %eax,%eax
  80145d:	75 c9                	jne    801428 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80146c:	8b 55 08             	mov    0x8(%ebp),%edx
  80146f:	8b 45 10             	mov    0x10(%ebp),%eax
  801472:	01 d0                	add    %edx,%eax
  801474:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801477:	eb 15                	jmp    80148e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	0f b6 d0             	movzbl %al,%edx
  801481:	8b 45 0c             	mov    0xc(%ebp),%eax
  801484:	0f b6 c0             	movzbl %al,%eax
  801487:	39 c2                	cmp    %eax,%edx
  801489:	74 0d                	je     801498 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80148b:	ff 45 08             	incl   0x8(%ebp)
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801494:	72 e3                	jb     801479 <memfind+0x13>
  801496:	eb 01                	jmp    801499 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801498:	90                   	nop
	return (void *) s;
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014b2:	eb 03                	jmp    8014b7 <strtol+0x19>
		s++;
  8014b4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	8a 00                	mov    (%eax),%al
  8014bc:	3c 20                	cmp    $0x20,%al
  8014be:	74 f4                	je     8014b4 <strtol+0x16>
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	8a 00                	mov    (%eax),%al
  8014c5:	3c 09                	cmp    $0x9,%al
  8014c7:	74 eb                	je     8014b4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	8a 00                	mov    (%eax),%al
  8014ce:	3c 2b                	cmp    $0x2b,%al
  8014d0:	75 05                	jne    8014d7 <strtol+0x39>
		s++;
  8014d2:	ff 45 08             	incl   0x8(%ebp)
  8014d5:	eb 13                	jmp    8014ea <strtol+0x4c>
	else if (*s == '-')
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	3c 2d                	cmp    $0x2d,%al
  8014de:	75 0a                	jne    8014ea <strtol+0x4c>
		s++, neg = 1;
  8014e0:	ff 45 08             	incl   0x8(%ebp)
  8014e3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ee:	74 06                	je     8014f6 <strtol+0x58>
  8014f0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014f4:	75 20                	jne    801516 <strtol+0x78>
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	8a 00                	mov    (%eax),%al
  8014fb:	3c 30                	cmp    $0x30,%al
  8014fd:	75 17                	jne    801516 <strtol+0x78>
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	40                   	inc    %eax
  801503:	8a 00                	mov    (%eax),%al
  801505:	3c 78                	cmp    $0x78,%al
  801507:	75 0d                	jne    801516 <strtol+0x78>
		s += 2, base = 16;
  801509:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80150d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801514:	eb 28                	jmp    80153e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801516:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80151a:	75 15                	jne    801531 <strtol+0x93>
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	8a 00                	mov    (%eax),%al
  801521:	3c 30                	cmp    $0x30,%al
  801523:	75 0c                	jne    801531 <strtol+0x93>
		s++, base = 8;
  801525:	ff 45 08             	incl   0x8(%ebp)
  801528:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80152f:	eb 0d                	jmp    80153e <strtol+0xa0>
	else if (base == 0)
  801531:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801535:	75 07                	jne    80153e <strtol+0xa0>
		base = 10;
  801537:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8a 00                	mov    (%eax),%al
  801543:	3c 2f                	cmp    $0x2f,%al
  801545:	7e 19                	jle    801560 <strtol+0xc2>
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	8a 00                	mov    (%eax),%al
  80154c:	3c 39                	cmp    $0x39,%al
  80154e:	7f 10                	jg     801560 <strtol+0xc2>
			dig = *s - '0';
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	0f be c0             	movsbl %al,%eax
  801558:	83 e8 30             	sub    $0x30,%eax
  80155b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80155e:	eb 42                	jmp    8015a2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	8a 00                	mov    (%eax),%al
  801565:	3c 60                	cmp    $0x60,%al
  801567:	7e 19                	jle    801582 <strtol+0xe4>
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	8a 00                	mov    (%eax),%al
  80156e:	3c 7a                	cmp    $0x7a,%al
  801570:	7f 10                	jg     801582 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	8a 00                	mov    (%eax),%al
  801577:	0f be c0             	movsbl %al,%eax
  80157a:	83 e8 57             	sub    $0x57,%eax
  80157d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801580:	eb 20                	jmp    8015a2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8a 00                	mov    (%eax),%al
  801587:	3c 40                	cmp    $0x40,%al
  801589:	7e 39                	jle    8015c4 <strtol+0x126>
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	3c 5a                	cmp    $0x5a,%al
  801592:	7f 30                	jg     8015c4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	8a 00                	mov    (%eax),%al
  801599:	0f be c0             	movsbl %al,%eax
  80159c:	83 e8 37             	sub    $0x37,%eax
  80159f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015a8:	7d 19                	jge    8015c3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015aa:	ff 45 08             	incl   0x8(%ebp)
  8015ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015b4:	89 c2                	mov    %eax,%edx
  8015b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b9:	01 d0                	add    %edx,%eax
  8015bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015be:	e9 7b ff ff ff       	jmp    80153e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015c3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c8:	74 08                	je     8015d2 <strtol+0x134>
		*endptr = (char *) s;
  8015ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015d6:	74 07                	je     8015df <strtol+0x141>
  8015d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015db:	f7 d8                	neg    %eax
  8015dd:	eb 03                	jmp    8015e2 <strtol+0x144>
  8015df:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <ltostr>:

void
ltostr(long value, char *str)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015fc:	79 13                	jns    801611 <ltostr+0x2d>
	{
		neg = 1;
  8015fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80160b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80160e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801619:	99                   	cltd   
  80161a:	f7 f9                	idiv   %ecx
  80161c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80161f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801622:	8d 50 01             	lea    0x1(%eax),%edx
  801625:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801628:	89 c2                	mov    %eax,%edx
  80162a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162d:	01 d0                	add    %edx,%eax
  80162f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801632:	83 c2 30             	add    $0x30,%edx
  801635:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801637:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80163a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80163f:	f7 e9                	imul   %ecx
  801641:	c1 fa 02             	sar    $0x2,%edx
  801644:	89 c8                	mov    %ecx,%eax
  801646:	c1 f8 1f             	sar    $0x1f,%eax
  801649:	29 c2                	sub    %eax,%edx
  80164b:	89 d0                	mov    %edx,%eax
  80164d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801650:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801654:	75 bb                	jne    801611 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801656:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801660:	48                   	dec    %eax
  801661:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801664:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801668:	74 3d                	je     8016a7 <ltostr+0xc3>
		start = 1 ;
  80166a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801671:	eb 34                	jmp    8016a7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801673:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	01 d0                	add    %edx,%eax
  80167b:	8a 00                	mov    (%eax),%al
  80167d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801680:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	01 c2                	add    %eax,%edx
  801688:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80168b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168e:	01 c8                	add    %ecx,%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801694:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169a:	01 c2                	add    %eax,%edx
  80169c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80169f:	88 02                	mov    %al,(%edx)
		start++ ;
  8016a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016ad:	7c c4                	jl     801673 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b5:	01 d0                	add    %edx,%eax
  8016b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016ba:	90                   	nop
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016c3:	ff 75 08             	pushl  0x8(%ebp)
  8016c6:	e8 73 fa ff ff       	call   80113e <strlen>
  8016cb:	83 c4 04             	add    $0x4,%esp
  8016ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	e8 65 fa ff ff       	call   80113e <strlen>
  8016d9:	83 c4 04             	add    $0x4,%esp
  8016dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ed:	eb 17                	jmp    801706 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f5:	01 c2                	add    %eax,%edx
  8016f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	01 c8                	add    %ecx,%eax
  8016ff:	8a 00                	mov    (%eax),%al
  801701:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801703:	ff 45 fc             	incl   -0x4(%ebp)
  801706:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801709:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80170c:	7c e1                	jl     8016ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80170e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801715:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80171c:	eb 1f                	jmp    80173d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80171e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801721:	8d 50 01             	lea    0x1(%eax),%edx
  801724:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801727:	89 c2                	mov    %eax,%edx
  801729:	8b 45 10             	mov    0x10(%ebp),%eax
  80172c:	01 c2                	add    %eax,%edx
  80172e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801731:	8b 45 0c             	mov    0xc(%ebp),%eax
  801734:	01 c8                	add    %ecx,%eax
  801736:	8a 00                	mov    (%eax),%al
  801738:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80173a:	ff 45 f8             	incl   -0x8(%ebp)
  80173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801740:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801743:	7c d9                	jl     80171e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801745:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801748:	8b 45 10             	mov    0x10(%ebp),%eax
  80174b:	01 d0                	add    %edx,%eax
  80174d:	c6 00 00             	movb   $0x0,(%eax)
}
  801750:	90                   	nop
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801756:	8b 45 14             	mov    0x14(%ebp),%eax
  801759:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80175f:	8b 45 14             	mov    0x14(%ebp),%eax
  801762:	8b 00                	mov    (%eax),%eax
  801764:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80176b:	8b 45 10             	mov    0x10(%ebp),%eax
  80176e:	01 d0                	add    %edx,%eax
  801770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801776:	eb 0c                	jmp    801784 <strsplit+0x31>
			*string++ = 0;
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8d 50 01             	lea    0x1(%eax),%edx
  80177e:	89 55 08             	mov    %edx,0x8(%ebp)
  801781:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	84 c0                	test   %al,%al
  80178b:	74 18                	je     8017a5 <strsplit+0x52>
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	0f be c0             	movsbl %al,%eax
  801795:	50                   	push   %eax
  801796:	ff 75 0c             	pushl  0xc(%ebp)
  801799:	e8 32 fb ff ff       	call   8012d0 <strchr>
  80179e:	83 c4 08             	add    $0x8,%esp
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	75 d3                	jne    801778 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8a 00                	mov    (%eax),%al
  8017aa:	84 c0                	test   %al,%al
  8017ac:	74 5a                	je     801808 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8017ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b1:	8b 00                	mov    (%eax),%eax
  8017b3:	83 f8 0f             	cmp    $0xf,%eax
  8017b6:	75 07                	jne    8017bf <strsplit+0x6c>
		{
			return 0;
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bd:	eb 66                	jmp    801825 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c2:	8b 00                	mov    (%eax),%eax
  8017c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8017c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8017ca:	89 0a                	mov    %ecx,(%edx)
  8017cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d6:	01 c2                	add    %eax,%edx
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017dd:	eb 03                	jmp    8017e2 <strsplit+0x8f>
			string++;
  8017df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	84 c0                	test   %al,%al
  8017e9:	74 8b                	je     801776 <strsplit+0x23>
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	0f be c0             	movsbl %al,%eax
  8017f3:	50                   	push   %eax
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	e8 d4 fa ff ff       	call   8012d0 <strchr>
  8017fc:	83 c4 08             	add    $0x8,%esp
  8017ff:	85 c0                	test   %eax,%eax
  801801:	74 dc                	je     8017df <strsplit+0x8c>
			string++;
	}
  801803:	e9 6e ff ff ff       	jmp    801776 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801808:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801809:	8b 45 14             	mov    0x14(%ebp),%eax
  80180c:	8b 00                	mov    (%eax),%eax
  80180e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	01 d0                	add    %edx,%eax
  80181a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801820:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80182d:	83 ec 04             	sub    $0x4,%esp
  801830:	68 c8 2b 80 00       	push   $0x802bc8
  801835:	68 3f 01 00 00       	push   $0x13f
  80183a:	68 ea 2b 80 00       	push   $0x802bea
  80183f:	e8 a9 ef ff ff       	call   8007ed <_panic>

00801844 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	e8 ef 06 00 00       	call   801f44 <sys_sbrk>
  801855:	83 c4 10             	add    $0x10,%esp
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801860:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801864:	75 07                	jne    80186d <malloc+0x13>
  801866:	b8 00 00 00 00       	mov    $0x0,%eax
  80186b:	eb 14                	jmp    801881 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	68 f8 2b 80 00       	push   $0x802bf8
  801875:	6a 1b                	push   $0x1b
  801877:	68 1d 2c 80 00       	push   $0x802c1d
  80187c:	e8 6c ef ff ff       	call   8007ed <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801889:	83 ec 04             	sub    $0x4,%esp
  80188c:	68 2c 2c 80 00       	push   $0x802c2c
  801891:	6a 29                	push   $0x29
  801893:	68 1d 2c 80 00       	push   $0x802c1d
  801898:	e8 50 ef ff ff       	call   8007ed <_panic>

0080189d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 18             	sub    $0x18,%esp
  8018a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a6:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8018a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018ad:	75 07                	jne    8018b6 <smalloc+0x19>
  8018af:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b4:	eb 14                	jmp    8018ca <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8018b6:	83 ec 04             	sub    $0x4,%esp
  8018b9:	68 50 2c 80 00       	push   $0x802c50
  8018be:	6a 38                	push   $0x38
  8018c0:	68 1d 2c 80 00       	push   $0x802c1d
  8018c5:	e8 23 ef ff ff       	call   8007ed <_panic>
	return NULL;
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	68 78 2c 80 00       	push   $0x802c78
  8018da:	6a 43                	push   $0x43
  8018dc:	68 1d 2c 80 00       	push   $0x802c1d
  8018e1:	e8 07 ef ff ff       	call   8007ed <_panic>

008018e6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	68 9c 2c 80 00       	push   $0x802c9c
  8018f4:	6a 5b                	push   $0x5b
  8018f6:	68 1d 2c 80 00       	push   $0x802c1d
  8018fb:	e8 ed ee ff ff       	call   8007ed <_panic>

00801900 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	68 c0 2c 80 00       	push   $0x802cc0
  80190e:	6a 72                	push   $0x72
  801910:	68 1d 2c 80 00       	push   $0x802c1d
  801915:	e8 d3 ee ff ff       	call   8007ed <_panic>

0080191a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	68 e6 2c 80 00       	push   $0x802ce6
  801928:	6a 7e                	push   $0x7e
  80192a:	68 1d 2c 80 00       	push   $0x802c1d
  80192f:	e8 b9 ee ff ff       	call   8007ed <_panic>

00801934 <shrink>:

}
void shrink(uint32 newSize)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	68 e6 2c 80 00       	push   $0x802ce6
  801942:	68 83 00 00 00       	push   $0x83
  801947:	68 1d 2c 80 00       	push   $0x802c1d
  80194c:	e8 9c ee ff ff       	call   8007ed <_panic>

00801951 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	68 e6 2c 80 00       	push   $0x802ce6
  80195f:	68 88 00 00 00       	push   $0x88
  801964:	68 1d 2c 80 00       	push   $0x802c1d
  801969:	e8 7f ee ff ff       	call   8007ed <_panic>

0080196e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	57                   	push   %edi
  801972:	56                   	push   %esi
  801973:	53                   	push   %ebx
  801974:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801980:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801983:	8b 7d 18             	mov    0x18(%ebp),%edi
  801986:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801989:	cd 30                	int    $0x30
  80198b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80198e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	5b                   	pop    %ebx
  801995:	5e                   	pop    %esi
  801996:	5f                   	pop    %edi
  801997:	5d                   	pop    %ebp
  801998:	c3                   	ret    

00801999 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 04             	sub    $0x4,%esp
  80199f:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019a5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	52                   	push   %edx
  8019b1:	ff 75 0c             	pushl  0xc(%ebp)
  8019b4:	50                   	push   %eax
  8019b5:	6a 00                	push   $0x0
  8019b7:	e8 b2 ff ff ff       	call   80196e <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	90                   	nop
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 02                	push   $0x2
  8019d1:	e8 98 ff ff ff       	call   80196e <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 03                	push   $0x3
  8019ea:	e8 7f ff ff ff       	call   80196e <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 04                	push   $0x4
  801a04:	e8 65 ff ff ff       	call   80196e <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	90                   	nop
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	52                   	push   %edx
  801a1f:	50                   	push   %eax
  801a20:	6a 08                	push   $0x8
  801a22:	e8 47 ff ff ff       	call   80196e <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	56                   	push   %esi
  801a30:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a31:	8b 75 18             	mov    0x18(%ebp),%esi
  801a34:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	51                   	push   %ecx
  801a43:	52                   	push   %edx
  801a44:	50                   	push   %eax
  801a45:	6a 09                	push   $0x9
  801a47:	e8 22 ff ff ff       	call   80196e <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a52:	5b                   	pop    %ebx
  801a53:	5e                   	pop    %esi
  801a54:	5d                   	pop    %ebp
  801a55:	c3                   	ret    

00801a56 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	52                   	push   %edx
  801a66:	50                   	push   %eax
  801a67:	6a 0a                	push   $0xa
  801a69:	e8 00 ff ff ff       	call   80196e <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	ff 75 08             	pushl  0x8(%ebp)
  801a82:	6a 0b                	push   $0xb
  801a84:	e8 e5 fe ff ff       	call   80196e <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 0c                	push   $0xc
  801a9d:	e8 cc fe ff ff       	call   80196e <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 0d                	push   $0xd
  801ab6:	e8 b3 fe ff ff       	call   80196e <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 0e                	push   $0xe
  801acf:	e8 9a fe ff ff       	call   80196e <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 0f                	push   $0xf
  801ae8:	e8 81 fe ff ff       	call   80196e <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	ff 75 08             	pushl  0x8(%ebp)
  801b00:	6a 10                	push   $0x10
  801b02:	e8 67 fe ff ff       	call   80196e <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 11                	push   $0x11
  801b1b:	e8 4e fe ff ff       	call   80196e <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	90                   	nop
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	50                   	push   %eax
  801b3f:	6a 01                	push   $0x1
  801b41:	e8 28 fe ff ff       	call   80196e <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 14                	push   $0x14
  801b5b:	e8 0e fe ff ff       	call   80196e <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	90                   	nop
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 04             	sub    $0x4,%esp
  801b6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b72:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b75:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	51                   	push   %ecx
  801b7f:	52                   	push   %edx
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	50                   	push   %eax
  801b84:	6a 15                	push   $0x15
  801b86:	e8 e3 fd ff ff       	call   80196e <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	52                   	push   %edx
  801ba0:	50                   	push   %eax
  801ba1:	6a 16                	push   $0x16
  801ba3:	e8 c6 fd ff ff       	call   80196e <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	51                   	push   %ecx
  801bbe:	52                   	push   %edx
  801bbf:	50                   	push   %eax
  801bc0:	6a 17                	push   $0x17
  801bc2:	e8 a7 fd ff ff       	call   80196e <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	52                   	push   %edx
  801bdc:	50                   	push   %eax
  801bdd:	6a 18                	push   $0x18
  801bdf:	e8 8a fd ff ff       	call   80196e <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	6a 00                	push   $0x0
  801bf1:	ff 75 14             	pushl  0x14(%ebp)
  801bf4:	ff 75 10             	pushl  0x10(%ebp)
  801bf7:	ff 75 0c             	pushl  0xc(%ebp)
  801bfa:	50                   	push   %eax
  801bfb:	6a 19                	push   $0x19
  801bfd:	e8 6c fd ff ff       	call   80196e <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	50                   	push   %eax
  801c16:	6a 1a                	push   $0x1a
  801c18:	e8 51 fd ff ff       	call   80196e <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	90                   	nop
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	50                   	push   %eax
  801c32:	6a 1b                	push   $0x1b
  801c34:	e8 35 fd ff ff       	call   80196e <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 05                	push   $0x5
  801c4d:	e8 1c fd ff ff       	call   80196e <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 06                	push   $0x6
  801c66:	e8 03 fd ff ff       	call   80196e <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 07                	push   $0x7
  801c7f:	e8 ea fc ff ff       	call   80196e <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_exit_env>:


void sys_exit_env(void)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 1c                	push   $0x1c
  801c98:	e8 d1 fc ff ff       	call   80196e <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	90                   	nop
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ca9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cac:	8d 50 04             	lea    0x4(%eax),%edx
  801caf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	52                   	push   %edx
  801cb9:	50                   	push   %eax
  801cba:	6a 1d                	push   $0x1d
  801cbc:	e8 ad fc ff ff       	call   80196e <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
	return result;
  801cc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ccd:	89 01                	mov    %eax,(%ecx)
  801ccf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	c9                   	leave  
  801cd6:	c2 04 00             	ret    $0x4

00801cd9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	ff 75 10             	pushl  0x10(%ebp)
  801ce3:	ff 75 0c             	pushl  0xc(%ebp)
  801ce6:	ff 75 08             	pushl  0x8(%ebp)
  801ce9:	6a 13                	push   $0x13
  801ceb:	e8 7e fc ff ff       	call   80196e <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf3:	90                   	nop
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 1e                	push   $0x1e
  801d05:	e8 64 fc ff ff       	call   80196e <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 04             	sub    $0x4,%esp
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d1b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	50                   	push   %eax
  801d28:	6a 1f                	push   $0x1f
  801d2a:	e8 3f fc ff ff       	call   80196e <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d32:	90                   	nop
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <rsttst>:
void rsttst()
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 21                	push   $0x21
  801d44:	e8 25 fc ff ff       	call   80196e <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4c:	90                   	nop
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	83 ec 04             	sub    $0x4,%esp
  801d55:	8b 45 14             	mov    0x14(%ebp),%eax
  801d58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d5b:	8b 55 18             	mov    0x18(%ebp),%edx
  801d5e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d62:	52                   	push   %edx
  801d63:	50                   	push   %eax
  801d64:	ff 75 10             	pushl  0x10(%ebp)
  801d67:	ff 75 0c             	pushl  0xc(%ebp)
  801d6a:	ff 75 08             	pushl  0x8(%ebp)
  801d6d:	6a 20                	push   $0x20
  801d6f:	e8 fa fb ff ff       	call   80196e <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
	return ;
  801d77:	90                   	nop
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <chktst>:
void chktst(uint32 n)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	6a 22                	push   $0x22
  801d8a:	e8 df fb ff ff       	call   80196e <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d92:	90                   	nop
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <inctst>:

void inctst()
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 23                	push   $0x23
  801da4:	e8 c5 fb ff ff       	call   80196e <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dac:	90                   	nop
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <gettst>:
uint32 gettst()
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 24                	push   $0x24
  801dbe:	e8 ab fb ff ff       	call   80196e <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 25                	push   $0x25
  801dda:	e8 8f fb ff ff       	call   80196e <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
  801de2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801de5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801de9:	75 07                	jne    801df2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801deb:	b8 01 00 00 00       	mov    $0x1,%eax
  801df0:	eb 05                	jmp    801df7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 25                	push   $0x25
  801e0b:	e8 5e fb ff ff       	call   80196e <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
  801e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e16:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e1a:	75 07                	jne    801e23 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e1c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e21:	eb 05                	jmp    801e28 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 25                	push   $0x25
  801e3c:	e8 2d fb ff ff       	call   80196e <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
  801e44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e47:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e4b:	75 07                	jne    801e54 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e52:	eb 05                	jmp    801e59 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 25                	push   $0x25
  801e6d:	e8 fc fa ff ff       	call   80196e <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
  801e75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e78:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e7c:	75 07                	jne    801e85 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e83:	eb 05                	jmp    801e8a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	ff 75 08             	pushl  0x8(%ebp)
  801e9a:	6a 26                	push   $0x26
  801e9c:	e8 cd fa ff ff       	call   80196e <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea4:	90                   	nop
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	6a 00                	push   $0x0
  801eb9:	53                   	push   %ebx
  801eba:	51                   	push   %ecx
  801ebb:	52                   	push   %edx
  801ebc:	50                   	push   %eax
  801ebd:	6a 27                	push   $0x27
  801ebf:	e8 aa fa ff ff       	call   80196e <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
}
  801ec7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	52                   	push   %edx
  801edc:	50                   	push   %eax
  801edd:	6a 28                	push   $0x28
  801edf:	e8 8a fa ff ff       	call   80196e <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801eec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	51                   	push   %ecx
  801ef8:	ff 75 10             	pushl  0x10(%ebp)
  801efb:	52                   	push   %edx
  801efc:	50                   	push   %eax
  801efd:	6a 29                	push   $0x29
  801eff:	e8 6a fa ff ff       	call   80196e <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	ff 75 10             	pushl  0x10(%ebp)
  801f13:	ff 75 0c             	pushl  0xc(%ebp)
  801f16:	ff 75 08             	pushl  0x8(%ebp)
  801f19:	6a 12                	push   $0x12
  801f1b:	e8 4e fa ff ff       	call   80196e <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
	return ;
  801f23:	90                   	nop
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	52                   	push   %edx
  801f36:	50                   	push   %eax
  801f37:	6a 2a                	push   $0x2a
  801f39:	e8 30 fa ff ff       	call   80196e <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
	return;
  801f41:	90                   	nop
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	50                   	push   %eax
  801f53:	6a 2b                	push   $0x2b
  801f55:	e8 14 fa ff ff       	call   80196e <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	ff 75 0c             	pushl  0xc(%ebp)
  801f6b:	ff 75 08             	pushl  0x8(%ebp)
  801f6e:	6a 2c                	push   $0x2c
  801f70:	e8 f9 f9 ff ff       	call   80196e <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
	return;
  801f78:	90                   	nop
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	ff 75 08             	pushl  0x8(%ebp)
  801f8a:	6a 2d                	push   $0x2d
  801f8c:	e8 dd f9 ff ff       	call   80196e <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
	return;
  801f94:	90                   	nop
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    
  801f97:	90                   	nop

00801f98 <__udivdi3>:
  801f98:	55                   	push   %ebp
  801f99:	57                   	push   %edi
  801f9a:	56                   	push   %esi
  801f9b:	53                   	push   %ebx
  801f9c:	83 ec 1c             	sub    $0x1c,%esp
  801f9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801fa3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801fa7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801faf:	89 ca                	mov    %ecx,%edx
  801fb1:	89 f8                	mov    %edi,%eax
  801fb3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801fb7:	85 f6                	test   %esi,%esi
  801fb9:	75 2d                	jne    801fe8 <__udivdi3+0x50>
  801fbb:	39 cf                	cmp    %ecx,%edi
  801fbd:	77 65                	ja     802024 <__udivdi3+0x8c>
  801fbf:	89 fd                	mov    %edi,%ebp
  801fc1:	85 ff                	test   %edi,%edi
  801fc3:	75 0b                	jne    801fd0 <__udivdi3+0x38>
  801fc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801fca:	31 d2                	xor    %edx,%edx
  801fcc:	f7 f7                	div    %edi
  801fce:	89 c5                	mov    %eax,%ebp
  801fd0:	31 d2                	xor    %edx,%edx
  801fd2:	89 c8                	mov    %ecx,%eax
  801fd4:	f7 f5                	div    %ebp
  801fd6:	89 c1                	mov    %eax,%ecx
  801fd8:	89 d8                	mov    %ebx,%eax
  801fda:	f7 f5                	div    %ebp
  801fdc:	89 cf                	mov    %ecx,%edi
  801fde:	89 fa                	mov    %edi,%edx
  801fe0:	83 c4 1c             	add    $0x1c,%esp
  801fe3:	5b                   	pop    %ebx
  801fe4:	5e                   	pop    %esi
  801fe5:	5f                   	pop    %edi
  801fe6:	5d                   	pop    %ebp
  801fe7:	c3                   	ret    
  801fe8:	39 ce                	cmp    %ecx,%esi
  801fea:	77 28                	ja     802014 <__udivdi3+0x7c>
  801fec:	0f bd fe             	bsr    %esi,%edi
  801fef:	83 f7 1f             	xor    $0x1f,%edi
  801ff2:	75 40                	jne    802034 <__udivdi3+0x9c>
  801ff4:	39 ce                	cmp    %ecx,%esi
  801ff6:	72 0a                	jb     802002 <__udivdi3+0x6a>
  801ff8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ffc:	0f 87 9e 00 00 00    	ja     8020a0 <__udivdi3+0x108>
  802002:	b8 01 00 00 00       	mov    $0x1,%eax
  802007:	89 fa                	mov    %edi,%edx
  802009:	83 c4 1c             	add    $0x1c,%esp
  80200c:	5b                   	pop    %ebx
  80200d:	5e                   	pop    %esi
  80200e:	5f                   	pop    %edi
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    
  802011:	8d 76 00             	lea    0x0(%esi),%esi
  802014:	31 ff                	xor    %edi,%edi
  802016:	31 c0                	xor    %eax,%eax
  802018:	89 fa                	mov    %edi,%edx
  80201a:	83 c4 1c             	add    $0x1c,%esp
  80201d:	5b                   	pop    %ebx
  80201e:	5e                   	pop    %esi
  80201f:	5f                   	pop    %edi
  802020:	5d                   	pop    %ebp
  802021:	c3                   	ret    
  802022:	66 90                	xchg   %ax,%ax
  802024:	89 d8                	mov    %ebx,%eax
  802026:	f7 f7                	div    %edi
  802028:	31 ff                	xor    %edi,%edi
  80202a:	89 fa                	mov    %edi,%edx
  80202c:	83 c4 1c             	add    $0x1c,%esp
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5f                   	pop    %edi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    
  802034:	bd 20 00 00 00       	mov    $0x20,%ebp
  802039:	89 eb                	mov    %ebp,%ebx
  80203b:	29 fb                	sub    %edi,%ebx
  80203d:	89 f9                	mov    %edi,%ecx
  80203f:	d3 e6                	shl    %cl,%esi
  802041:	89 c5                	mov    %eax,%ebp
  802043:	88 d9                	mov    %bl,%cl
  802045:	d3 ed                	shr    %cl,%ebp
  802047:	89 e9                	mov    %ebp,%ecx
  802049:	09 f1                	or     %esi,%ecx
  80204b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80204f:	89 f9                	mov    %edi,%ecx
  802051:	d3 e0                	shl    %cl,%eax
  802053:	89 c5                	mov    %eax,%ebp
  802055:	89 d6                	mov    %edx,%esi
  802057:	88 d9                	mov    %bl,%cl
  802059:	d3 ee                	shr    %cl,%esi
  80205b:	89 f9                	mov    %edi,%ecx
  80205d:	d3 e2                	shl    %cl,%edx
  80205f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802063:	88 d9                	mov    %bl,%cl
  802065:	d3 e8                	shr    %cl,%eax
  802067:	09 c2                	or     %eax,%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	89 f2                	mov    %esi,%edx
  80206d:	f7 74 24 0c          	divl   0xc(%esp)
  802071:	89 d6                	mov    %edx,%esi
  802073:	89 c3                	mov    %eax,%ebx
  802075:	f7 e5                	mul    %ebp
  802077:	39 d6                	cmp    %edx,%esi
  802079:	72 19                	jb     802094 <__udivdi3+0xfc>
  80207b:	74 0b                	je     802088 <__udivdi3+0xf0>
  80207d:	89 d8                	mov    %ebx,%eax
  80207f:	31 ff                	xor    %edi,%edi
  802081:	e9 58 ff ff ff       	jmp    801fde <__udivdi3+0x46>
  802086:	66 90                	xchg   %ax,%ax
  802088:	8b 54 24 08          	mov    0x8(%esp),%edx
  80208c:	89 f9                	mov    %edi,%ecx
  80208e:	d3 e2                	shl    %cl,%edx
  802090:	39 c2                	cmp    %eax,%edx
  802092:	73 e9                	jae    80207d <__udivdi3+0xe5>
  802094:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802097:	31 ff                	xor    %edi,%edi
  802099:	e9 40 ff ff ff       	jmp    801fde <__udivdi3+0x46>
  80209e:	66 90                	xchg   %ax,%ax
  8020a0:	31 c0                	xor    %eax,%eax
  8020a2:	e9 37 ff ff ff       	jmp    801fde <__udivdi3+0x46>
  8020a7:	90                   	nop

008020a8 <__umoddi3>:
  8020a8:	55                   	push   %ebp
  8020a9:	57                   	push   %edi
  8020aa:	56                   	push   %esi
  8020ab:	53                   	push   %ebx
  8020ac:	83 ec 1c             	sub    $0x1c,%esp
  8020af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8020b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020c7:	89 f3                	mov    %esi,%ebx
  8020c9:	89 fa                	mov    %edi,%edx
  8020cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020cf:	89 34 24             	mov    %esi,(%esp)
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	75 1a                	jne    8020f0 <__umoddi3+0x48>
  8020d6:	39 f7                	cmp    %esi,%edi
  8020d8:	0f 86 a2 00 00 00    	jbe    802180 <__umoddi3+0xd8>
  8020de:	89 c8                	mov    %ecx,%eax
  8020e0:	89 f2                	mov    %esi,%edx
  8020e2:	f7 f7                	div    %edi
  8020e4:	89 d0                	mov    %edx,%eax
  8020e6:	31 d2                	xor    %edx,%edx
  8020e8:	83 c4 1c             	add    $0x1c,%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5e                   	pop    %esi
  8020ed:	5f                   	pop    %edi
  8020ee:	5d                   	pop    %ebp
  8020ef:	c3                   	ret    
  8020f0:	39 f0                	cmp    %esi,%eax
  8020f2:	0f 87 ac 00 00 00    	ja     8021a4 <__umoddi3+0xfc>
  8020f8:	0f bd e8             	bsr    %eax,%ebp
  8020fb:	83 f5 1f             	xor    $0x1f,%ebp
  8020fe:	0f 84 ac 00 00 00    	je     8021b0 <__umoddi3+0x108>
  802104:	bf 20 00 00 00       	mov    $0x20,%edi
  802109:	29 ef                	sub    %ebp,%edi
  80210b:	89 fe                	mov    %edi,%esi
  80210d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802111:	89 e9                	mov    %ebp,%ecx
  802113:	d3 e0                	shl    %cl,%eax
  802115:	89 d7                	mov    %edx,%edi
  802117:	89 f1                	mov    %esi,%ecx
  802119:	d3 ef                	shr    %cl,%edi
  80211b:	09 c7                	or     %eax,%edi
  80211d:	89 e9                	mov    %ebp,%ecx
  80211f:	d3 e2                	shl    %cl,%edx
  802121:	89 14 24             	mov    %edx,(%esp)
  802124:	89 d8                	mov    %ebx,%eax
  802126:	d3 e0                	shl    %cl,%eax
  802128:	89 c2                	mov    %eax,%edx
  80212a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80212e:	d3 e0                	shl    %cl,%eax
  802130:	89 44 24 04          	mov    %eax,0x4(%esp)
  802134:	8b 44 24 08          	mov    0x8(%esp),%eax
  802138:	89 f1                	mov    %esi,%ecx
  80213a:	d3 e8                	shr    %cl,%eax
  80213c:	09 d0                	or     %edx,%eax
  80213e:	d3 eb                	shr    %cl,%ebx
  802140:	89 da                	mov    %ebx,%edx
  802142:	f7 f7                	div    %edi
  802144:	89 d3                	mov    %edx,%ebx
  802146:	f7 24 24             	mull   (%esp)
  802149:	89 c6                	mov    %eax,%esi
  80214b:	89 d1                	mov    %edx,%ecx
  80214d:	39 d3                	cmp    %edx,%ebx
  80214f:	0f 82 87 00 00 00    	jb     8021dc <__umoddi3+0x134>
  802155:	0f 84 91 00 00 00    	je     8021ec <__umoddi3+0x144>
  80215b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80215f:	29 f2                	sub    %esi,%edx
  802161:	19 cb                	sbb    %ecx,%ebx
  802163:	89 d8                	mov    %ebx,%eax
  802165:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802169:	d3 e0                	shl    %cl,%eax
  80216b:	89 e9                	mov    %ebp,%ecx
  80216d:	d3 ea                	shr    %cl,%edx
  80216f:	09 d0                	or     %edx,%eax
  802171:	89 e9                	mov    %ebp,%ecx
  802173:	d3 eb                	shr    %cl,%ebx
  802175:	89 da                	mov    %ebx,%edx
  802177:	83 c4 1c             	add    $0x1c,%esp
  80217a:	5b                   	pop    %ebx
  80217b:	5e                   	pop    %esi
  80217c:	5f                   	pop    %edi
  80217d:	5d                   	pop    %ebp
  80217e:	c3                   	ret    
  80217f:	90                   	nop
  802180:	89 fd                	mov    %edi,%ebp
  802182:	85 ff                	test   %edi,%edi
  802184:	75 0b                	jne    802191 <__umoddi3+0xe9>
  802186:	b8 01 00 00 00       	mov    $0x1,%eax
  80218b:	31 d2                	xor    %edx,%edx
  80218d:	f7 f7                	div    %edi
  80218f:	89 c5                	mov    %eax,%ebp
  802191:	89 f0                	mov    %esi,%eax
  802193:	31 d2                	xor    %edx,%edx
  802195:	f7 f5                	div    %ebp
  802197:	89 c8                	mov    %ecx,%eax
  802199:	f7 f5                	div    %ebp
  80219b:	89 d0                	mov    %edx,%eax
  80219d:	e9 44 ff ff ff       	jmp    8020e6 <__umoddi3+0x3e>
  8021a2:	66 90                	xchg   %ax,%ax
  8021a4:	89 c8                	mov    %ecx,%eax
  8021a6:	89 f2                	mov    %esi,%edx
  8021a8:	83 c4 1c             	add    $0x1c,%esp
  8021ab:	5b                   	pop    %ebx
  8021ac:	5e                   	pop    %esi
  8021ad:	5f                   	pop    %edi
  8021ae:	5d                   	pop    %ebp
  8021af:	c3                   	ret    
  8021b0:	3b 04 24             	cmp    (%esp),%eax
  8021b3:	72 06                	jb     8021bb <__umoddi3+0x113>
  8021b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8021b9:	77 0f                	ja     8021ca <__umoddi3+0x122>
  8021bb:	89 f2                	mov    %esi,%edx
  8021bd:	29 f9                	sub    %edi,%ecx
  8021bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8021c3:	89 14 24             	mov    %edx,(%esp)
  8021c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021ce:	8b 14 24             	mov    (%esp),%edx
  8021d1:	83 c4 1c             	add    $0x1c,%esp
  8021d4:	5b                   	pop    %ebx
  8021d5:	5e                   	pop    %esi
  8021d6:	5f                   	pop    %edi
  8021d7:	5d                   	pop    %ebp
  8021d8:	c3                   	ret    
  8021d9:	8d 76 00             	lea    0x0(%esi),%esi
  8021dc:	2b 04 24             	sub    (%esp),%eax
  8021df:	19 fa                	sbb    %edi,%edx
  8021e1:	89 d1                	mov    %edx,%ecx
  8021e3:	89 c6                	mov    %eax,%esi
  8021e5:	e9 71 ff ff ff       	jmp    80215b <__umoddi3+0xb3>
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021f0:	72 ea                	jb     8021dc <__umoddi3+0x134>
  8021f2:	89 d9                	mov    %ebx,%ecx
  8021f4:	e9 62 ff ff ff       	jmp    80215b <__umoddi3+0xb3>
