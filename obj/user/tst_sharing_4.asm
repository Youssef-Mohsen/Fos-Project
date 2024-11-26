
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
  80005c:	68 e0 40 80 00       	push   $0x8040e0
  800061:	6a 13                	push   $0x13
  800063:	68 fc 40 80 00       	push   $0x8040fc
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
  800085:	68 14 41 80 00       	push   $0x804114
  80008a:	e8 43 0a 00 00       	call   800ad2 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	68 48 41 80 00       	push   $0x804148
  80009a:	e8 33 0a 00 00       	call   800ad2 <cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 a4 41 80 00       	push   $0x8041a4
  8000aa:	e8 23 0a 00 00       	call   800ad2 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000b2:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000b9:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	int envID = sys_getenvid();
  8000c0:	e8 bc 1f 00 00       	call   802081 <sys_getenvid>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000c8:	83 ec 0c             	sub    $0xc,%esp
  8000cb:	68 d8 41 80 00       	push   $0x8041d8
  8000d0:	e8 fd 09 00 00       	call   800ad2 <cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 f4 1d 00 00       	call   801ed1 <sys_calculate_free_frames>
  8000dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 01                	push   $0x1
  8000e5:	68 00 10 00 00       	push   $0x1000
  8000ea:	68 0c 42 80 00       	push   $0x80420c
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
  80010c:	68 10 42 80 00       	push   $0x804210
  800111:	e8 bc 09 00 00       	call   800ad2 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  800119:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800120:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800123:	e8 a9 1d 00 00       	call   801ed1 <sys_calculate_free_frames>
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
  80014c:	e8 80 1d 00 00       	call   801ed1 <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015b:	50                   	push   %eax
  80015c:	68 7c 42 80 00       	push   $0x80427c
  800161:	e8 6c 09 00 00       	call   800ad2 <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp
		cprintf("50\n");
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	68 14 43 80 00       	push   $0x804314
  800171:	e8 5c 09 00 00       	call   800ad2 <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp
		sfree(x);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	ff 75 d8             	pushl  -0x28(%ebp)
  80017f:	e8 7b 1b 00 00       	call   801cff <sfree>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("52\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 18 43 80 00       	push   $0x804318
  80018f:	e8 3e 09 00 00       	call   800ad2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		expected = 0 ;
  800197:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80019e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001a1:	e8 2b 1d 00 00       	call   801ed1 <sys_calculate_free_frames>
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
  8001bf:	e8 0d 1d 00 00       	call   801ed1 <sys_calculate_free_frames>
  8001c4:	29 c3                	sub    %eax,%ebx
  8001c6:	89 d8                	mov    %ebx,%eax
  8001c8:	83 ec 04             	sub    $0x4,%esp
  8001cb:	50                   	push   %eax
  8001cc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001cf:	68 1c 43 80 00       	push   $0x80431c
  8001d4:	e8 f9 08 00 00       	call   800ad2 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step A completed!!\n\n\n");
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 67 43 80 00       	push   $0x804367
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
  800200:	68 80 43 80 00       	push   $0x804380
  800205:	e8 c8 08 00 00       	call   800ad2 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  80020d:	e8 bf 1c 00 00       	call   801ed1 <sys_calculate_free_frames>
  800212:	89 45 dc             	mov    %eax,-0x24(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	6a 01                	push   $0x1
  80021a:	68 00 10 00 00       	push   $0x1000
  80021f:	68 b5 43 80 00       	push   $0x8043b5
  800224:	e8 76 19 00 00       	call   801b9f <smalloc>
  800229:	83 c4 10             	add    $0x10,%esp
  80022c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	6a 01                	push   $0x1
  800234:	68 00 10 00 00       	push   $0x1000
  800239:	68 0c 42 80 00       	push   $0x80420c
  80023e:	e8 5c 19 00 00       	call   801b9f <smalloc>
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if(x == NULL)
  800249:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80024d:	75 17                	jne    800266 <_main+0x22e>
		{is_correct = 0; cprintf("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  80024f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 b8 43 80 00       	push   $0x8043b8
  80025e:	e8 6f 08 00 00       	call   800ad2 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

		expected = 2+1 ; /*2pages +1table*/
  800266:	c7 45 d4 03 00 00 00 	movl   $0x3,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80026d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800270:	e8 5c 1c 00 00       	call   801ed1 <sys_calculate_free_frames>
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
  800299:	68 10 44 80 00       	push   $0x804410
  80029e:	e8 2f 08 00 00       	call   800ad2 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp

		sfree(z);
  8002a6:	83 ec 0c             	sub    $0xc,%esp
  8002a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8002ac:	e8 4e 1a 00 00       	call   801cff <sfree>
  8002b1:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8002b4:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8002bb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002be:	e8 0e 1c 00 00       	call   801ed1 <sys_calculate_free_frames>
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
  8002dc:	e8 f0 1b 00 00       	call   801ed1 <sys_calculate_free_frames>
  8002e1:	29 c3                	sub    %eax,%ebx
  8002e3:	89 d8                	mov    %ebx,%eax
  8002e5:	83 ec 04             	sub    $0x4,%esp
  8002e8:	50                   	push   %eax
  8002e9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002ec:	68 1c 43 80 00       	push   $0x80431c
  8002f1:	e8 dc 07 00 00       	call   800ad2 <cprintf>
  8002f6:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8002f9:	83 ec 0c             	sub    $0xc,%esp
  8002fc:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002ff:	e8 fb 19 00 00       	call   801cff <sfree>
  800304:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  800307:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80030e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800311:	e8 bb 1b 00 00       	call   801ed1 <sys_calculate_free_frames>
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
  80032f:	e8 9d 1b 00 00       	call   801ed1 <sys_calculate_free_frames>
  800334:	29 c3                	sub    %eax,%ebx
  800336:	89 d8                	mov    %ebx,%eax
  800338:	83 ec 04             	sub    $0x4,%esp
  80033b:	50                   	push   %eax
  80033c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80033f:	68 1c 43 80 00       	push   $0x80431c
  800344:	e8 89 07 00 00       	call   800ad2 <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp

	}
	cprintf("Step B completed!!\n\n\n");
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 65 44 80 00       	push   $0x804465
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
  800370:	68 7c 44 80 00       	push   $0x80447c
  800375:	e8 58 07 00 00       	call   800ad2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80037d:	e8 4f 1b 00 00       	call   801ed1 <sys_calculate_free_frames>
  800382:	89 45 c0             	mov    %eax,-0x40(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800385:	83 ec 04             	sub    $0x4,%esp
  800388:	6a 01                	push   $0x1
  80038a:	68 01 30 00 00       	push   $0x3001
  80038f:	68 b1 44 80 00       	push   $0x8044b1
  800394:	e8 06 18 00 00       	call   801b9f <smalloc>
  800399:	83 c4 10             	add    $0x10,%esp
  80039c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80039f:	83 ec 04             	sub    $0x4,%esp
  8003a2:	6a 01                	push   $0x1
  8003a4:	68 00 10 00 00       	push   $0x1000
  8003a9:	68 b3 44 80 00       	push   $0x8044b3
  8003ae:	e8 ec 17 00 00       	call   801b9f <smalloc>
  8003b3:	83 c4 10             	add    $0x10,%esp
  8003b6:	89 45 b8             	mov    %eax,-0x48(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  8003b9:	c7 45 d4 06 00 00 00 	movl   $0x6,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003c0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8003c3:	e8 09 1b 00 00       	call   801ed1 <sys_calculate_free_frames>
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
  8003ec:	e8 e0 1a 00 00       	call   801ed1 <sys_calculate_free_frames>
  8003f1:	29 c3                	sub    %eax,%ebx
  8003f3:	89 d8                	mov    %ebx,%eax
  8003f5:	83 ec 04             	sub    $0x4,%esp
  8003f8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003fb:	50                   	push   %eax
  8003fc:	68 7c 42 80 00       	push   $0x80427c
  800401:	e8 cc 06 00 00       	call   800ad2 <cprintf>
  800406:	83 c4 10             	add    $0x10,%esp

		sfree(w);
  800409:	83 ec 0c             	sub    $0xc,%esp
  80040c:	ff 75 bc             	pushl  -0x44(%ebp)
  80040f:	e8 eb 18 00 00       	call   801cff <sfree>
  800414:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800417:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80041e:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800421:	e8 ab 1a 00 00       	call   801ed1 <sys_calculate_free_frames>
  800426:	29 c3                	sub    %eax,%ebx
  800428:	89 d8                	mov    %ebx,%eax
  80042a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  80042d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800430:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800433:	74 27                	je     80045c <_main+0x424>
  800435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80043c:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80043f:	e8 8d 1a 00 00       	call   801ed1 <sys_calculate_free_frames>
  800444:	29 c3                	sub    %eax,%ebx
  800446:	89 d8                	mov    %ebx,%eax
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	50                   	push   %eax
  80044c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80044f:	68 1c 43 80 00       	push   $0x80431c
  800454:	e8 79 06 00 00       	call   800ad2 <cprintf>
  800459:	83 c4 10             	add    $0x10,%esp

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	6a 01                	push   $0x1
  800461:	68 ff 1f 00 00       	push   $0x1fff
  800466:	68 b5 44 80 00       	push   $0x8044b5
  80046b:	e8 2f 17 00 00       	call   801b9f <smalloc>
  800470:	83 c4 10             	add    $0x10,%esp
  800473:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800476:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80047d:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800480:	e8 4c 1a 00 00       	call   801ed1 <sys_calculate_free_frames>
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
  80049e:	e8 2e 1a 00 00       	call   801ed1 <sys_calculate_free_frames>
  8004a3:	29 c3                	sub    %eax,%ebx
  8004a5:	89 d8                	mov    %ebx,%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004ad:	50                   	push   %eax
  8004ae:	68 7c 42 80 00       	push   $0x80427c
  8004b3:	e8 1a 06 00 00       	call   800ad2 <cprintf>
  8004b8:	83 c4 10             	add    $0x10,%esp

		sfree(o);
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004c1:	e8 39 18 00 00       	call   801cff <sfree>
  8004c6:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8004c9:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004d0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004d3:	e8 f9 19 00 00       	call   801ed1 <sys_calculate_free_frames>
  8004d8:	29 c3                	sub    %eax,%ebx
  8004da:	89 d8                	mov    %ebx,%eax
  8004dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004e5:	74 27                	je     80050e <_main+0x4d6>
  8004e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ee:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004f1:	e8 db 19 00 00       	call   801ed1 <sys_calculate_free_frames>
  8004f6:	29 c3                	sub    %eax,%ebx
  8004f8:	89 d8                	mov    %ebx,%eax
  8004fa:	83 ec 04             	sub    $0x4,%esp
  8004fd:	50                   	push   %eax
  8004fe:	ff 75 d4             	pushl  -0x2c(%ebp)
  800501:	68 1c 43 80 00       	push   $0x80431c
  800506:	e8 c7 05 00 00       	call   800ad2 <cprintf>
  80050b:	83 c4 10             	add    $0x10,%esp

		sfree(u);
  80050e:	83 ec 0c             	sub    $0xc,%esp
  800511:	ff 75 b8             	pushl  -0x48(%ebp)
  800514:	e8 e6 17 00 00       	call   801cff <sfree>
  800519:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  80051c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800523:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800526:	e8 a6 19 00 00       	call   801ed1 <sys_calculate_free_frames>
  80052b:	29 c3                	sub    %eax,%ebx
  80052d:	89 d8                	mov    %ebx,%eax
  80052f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800532:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800535:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800538:	74 27                	je     800561 <_main+0x529>
  80053a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800541:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800544:	e8 88 19 00 00       	call   801ed1 <sys_calculate_free_frames>
  800549:	29 c3                	sub    %eax,%ebx
  80054b:	89 d8                	mov    %ebx,%eax
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	50                   	push   %eax
  800551:	ff 75 d4             	pushl  -0x2c(%ebp)
  800554:	68 1c 43 80 00       	push   $0x80431c
  800559:	e8 74 05 00 00       	call   800ad2 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800561:	e8 6b 19 00 00       	call   801ed1 <sys_calculate_free_frames>
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
  80057b:	68 b1 44 80 00       	push   $0x8044b1
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
  8005a1:	68 b3 44 80 00       	push   $0x8044b3
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
  8005c3:	68 b5 44 80 00       	push   $0x8044b5
  8005c8:	e8 d2 15 00 00       	call   801b9f <smalloc>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  8005d3:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8005da:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8005dd:	e8 ef 18 00 00       	call   801ed1 <sys_calculate_free_frames>
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
  800606:	e8 c6 18 00 00       	call   801ed1 <sys_calculate_free_frames>
  80060b:	29 c3                	sub    %eax,%ebx
  80060d:	89 d8                	mov    %ebx,%eax
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 d4             	pushl  -0x2c(%ebp)
  800615:	50                   	push   %eax
  800616:	68 7c 42 80 00       	push   $0x80427c
  80061b:	e8 b2 04 00 00       	call   800ad2 <cprintf>
  800620:	83 c4 10             	add    $0x10,%esp

		freeFrames = sys_calculate_free_frames() ;
  800623:	e8 a9 18 00 00       	call   801ed1 <sys_calculate_free_frames>
  800628:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(o);
  80062b:	83 ec 0c             	sub    $0xc,%esp
  80062e:	ff 75 b4             	pushl  -0x4c(%ebp)
  800631:	e8 c9 16 00 00       	call   801cff <sfree>
  800636:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(w);
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	ff 75 bc             	pushl  -0x44(%ebp)
  80063f:	e8 bb 16 00 00       	call   801cff <sfree>
  800644:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(u);
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	ff 75 b8             	pushl  -0x48(%ebp)
  80064d:	e8 ad 16 00 00       	call   801cff <sfree>
  800652:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  800655:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  80065c:	e8 70 18 00 00       	call   801ed1 <sys_calculate_free_frames>
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
  80067f:	e8 4d 18 00 00       	call   801ed1 <sys_calculate_free_frames>
  800684:	29 c3                	sub    %eax,%ebx
  800686:	89 d8                	mov    %ebx,%eax
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	50                   	push   %eax
  80068c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80068f:	68 1c 43 80 00       	push   $0x80431c
  800694:	e8 39 04 00 00       	call   800ad2 <cprintf>
  800699:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step C completed!!\n\n\n");
  80069c:	83 ec 0c             	sub    $0xc,%esp
  80069f:	68 b7 44 80 00       	push   $0x8044b7
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
  8006c3:	68 d0 44 80 00       	push   $0x8044d0
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
  8006dc:	e8 b9 19 00 00       	call   80209a <sys_getenvindex>
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
  80074a:	e8 cf 16 00 00       	call   801e1e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80074f:	83 ec 0c             	sub    $0xc,%esp
  800752:	68 24 45 80 00       	push   $0x804524
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
  80077a:	68 4c 45 80 00       	push   $0x80454c
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
  8007ab:	68 74 45 80 00       	push   $0x804574
  8007b0:	e8 1d 03 00 00       	call   800ad2 <cprintf>
  8007b5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8007bd:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	50                   	push   %eax
  8007c7:	68 cc 45 80 00       	push   $0x8045cc
  8007cc:	e8 01 03 00 00       	call   800ad2 <cprintf>
  8007d1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8007d4:	83 ec 0c             	sub    $0xc,%esp
  8007d7:	68 24 45 80 00       	push   $0x804524
  8007dc:	e8 f1 02 00 00       	call   800ad2 <cprintf>
  8007e1:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8007e4:	e8 4f 16 00 00       	call   801e38 <sys_unlock_cons>
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
  8007fc:	e8 65 18 00 00       	call   802066 <sys_destroy_env>
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
  80080d:	e8 ba 18 00 00       	call   8020cc <sys_exit_env>
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
  800836:	68 e0 45 80 00       	push   $0x8045e0
  80083b:	e8 92 02 00 00       	call   800ad2 <cprintf>
  800840:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800843:	a1 00 50 80 00       	mov    0x805000,%eax
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	ff 75 08             	pushl  0x8(%ebp)
  80084e:	50                   	push   %eax
  80084f:	68 e5 45 80 00       	push   $0x8045e5
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
  800873:	68 01 46 80 00       	push   $0x804601
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
  8008a2:	68 04 46 80 00       	push   $0x804604
  8008a7:	6a 26                	push   $0x26
  8008a9:	68 50 46 80 00       	push   $0x804650
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
  800977:	68 5c 46 80 00       	push   $0x80465c
  80097c:	6a 3a                	push   $0x3a
  80097e:	68 50 46 80 00       	push   $0x804650
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
  8009ea:	68 b0 46 80 00       	push   $0x8046b0
  8009ef:	6a 44                	push   $0x44
  8009f1:	68 50 46 80 00       	push   $0x804650
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
  800a44:	e8 93 13 00 00       	call   801ddc <sys_cputs>
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
  800abb:	e8 1c 13 00 00       	call   801ddc <sys_cputs>
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
  800b05:	e8 14 13 00 00       	call   801e1e <sys_lock_cons>
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
  800b25:	e8 0e 13 00 00       	call   801e38 <sys_unlock_cons>
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
  800b6f:	e8 00 33 00 00       	call   803e74 <__udivdi3>
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
  800bbf:	e8 c0 33 00 00       	call   803f84 <__umoddi3>
  800bc4:	83 c4 10             	add    $0x10,%esp
  800bc7:	05 14 49 80 00       	add    $0x804914,%eax
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
  800d1a:	8b 04 85 38 49 80 00 	mov    0x804938(,%eax,4),%eax
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
  800dfb:	8b 34 9d 80 47 80 00 	mov    0x804780(,%ebx,4),%esi
  800e02:	85 f6                	test   %esi,%esi
  800e04:	75 19                	jne    800e1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e06:	53                   	push   %ebx
  800e07:	68 25 49 80 00       	push   $0x804925
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
  800e20:	68 2e 49 80 00       	push   $0x80492e
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
  800e4d:	be 31 49 80 00       	mov    $0x804931,%esi
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
  801858:	68 a8 4a 80 00       	push   $0x804aa8
  80185d:	68 3f 01 00 00       	push   $0x13f
  801862:	68 ca 4a 80 00       	push   $0x804aca
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
  801878:	e8 0a 0b 00 00       	call   802387 <sys_sbrk>
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
  8018f3:	e8 13 09 00 00       	call   80220b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	74 16                	je     801912 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8018fc:	83 ec 0c             	sub    $0xc,%esp
  8018ff:	ff 75 08             	pushl  0x8(%ebp)
  801902:	e8 53 0e 00 00       	call   80275a <alloc_block_FF>
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80190d:	e9 8a 01 00 00       	jmp    801a9c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801912:	e8 25 09 00 00       	call   80223c <sys_isUHeapPlacementStrategyBESTFIT>
  801917:	85 c0                	test   %eax,%eax
  801919:	0f 84 7d 01 00 00    	je     801a9c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80191f:	83 ec 0c             	sub    $0xc,%esp
  801922:	ff 75 08             	pushl  0x8(%ebp)
  801925:	e8 ec 12 00 00       	call   802c16 <alloc_block_BF>
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
  801a8b:	e8 2e 09 00 00       	call   8023be <sys_allocate_user_mem>
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
  801ad3:	e8 02 09 00 00       	call   8023da <get_block_size>
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801ade:	83 ec 0c             	sub    $0xc,%esp
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	e8 35 1b 00 00       	call   80361e <free_block>
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
  801b7b:	e8 22 08 00 00       	call   8023a2 <sys_free_user_mem>
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
  801b89:	68 d8 4a 80 00       	push   $0x804ad8
  801b8e:	68 85 00 00 00       	push   $0x85
  801b93:	68 02 4b 80 00       	push   $0x804b02
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
  801bfe:	e8 a6 03 00 00       	call   801fa9 <sys_createSharedObject>
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
  801c22:	68 0e 4b 80 00       	push   $0x804b0e
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
  801c66:	e8 68 03 00 00       	call   801fd3 <sys_getSizeOfSharedObject>
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801c71:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c75:	75 07                	jne    801c7e <sget+0x27>
  801c77:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7c:	eb 7f                	jmp    801cfd <sget+0xa6>
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
  801cb1:	eb 4a                	jmp    801cfd <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801cb3:	83 ec 04             	sub    $0x4,%esp
  801cb6:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb9:	ff 75 0c             	pushl  0xc(%ebp)
  801cbc:	ff 75 08             	pushl  0x8(%ebp)
  801cbf:	e8 2c 03 00 00       	call   801ff0 <sys_getSharedObject>
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801cca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ccd:	a1 20 50 80 00       	mov    0x805020,%eax
  801cd2:	8b 40 78             	mov    0x78(%eax),%eax
  801cd5:	29 c2                	sub    %eax,%edx
  801cd7:	89 d0                	mov    %edx,%eax
  801cd9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cde:	c1 e8 0c             	shr    $0xc,%eax
  801ce1:	89 c2                	mov    %eax,%edx
  801ce3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ce6:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801ced:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801cf1:	75 07                	jne    801cfa <sget+0xa3>
  801cf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf8:	eb 03                	jmp    801cfd <sget+0xa6>
	return ptr;
  801cfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801d05:	8b 55 08             	mov    0x8(%ebp),%edx
  801d08:	a1 20 50 80 00       	mov    0x805020,%eax
  801d0d:	8b 40 78             	mov    0x78(%eax),%eax
  801d10:	29 c2                	sub    %eax,%edx
  801d12:	89 d0                	mov    %edx,%eax
  801d14:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d19:	c1 e8 0c             	shr    $0xc,%eax
  801d1c:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801d26:	83 ec 08             	sub    $0x8,%esp
  801d29:	ff 75 08             	pushl  0x8(%ebp)
  801d2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2f:	e8 db 02 00 00       	call   80200f <sys_freeSharedObject>
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801d3a:	90                   	nop
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	68 20 4b 80 00       	push   $0x804b20
  801d4b:	68 de 00 00 00       	push   $0xde
  801d50:	68 02 4b 80 00       	push   $0x804b02
  801d55:	e8 bb ea ff ff       	call   800815 <_panic>

00801d5a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	68 46 4b 80 00       	push   $0x804b46
  801d68:	68 ea 00 00 00       	push   $0xea
  801d6d:	68 02 4b 80 00       	push   $0x804b02
  801d72:	e8 9e ea ff ff       	call   800815 <_panic>

00801d77 <shrink>:

}
void shrink(uint32 newSize)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d7d:	83 ec 04             	sub    $0x4,%esp
  801d80:	68 46 4b 80 00       	push   $0x804b46
  801d85:	68 ef 00 00 00       	push   $0xef
  801d8a:	68 02 4b 80 00       	push   $0x804b02
  801d8f:	e8 81 ea ff ff       	call   800815 <_panic>

00801d94 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	68 46 4b 80 00       	push   $0x804b46
  801da2:	68 f4 00 00 00       	push   $0xf4
  801da7:	68 02 4b 80 00       	push   $0x804b02
  801dac:	e8 64 ea ff ff       	call   800815 <_panic>

00801db1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	57                   	push   %edi
  801db5:	56                   	push   %esi
  801db6:	53                   	push   %ebx
  801db7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc6:	8b 7d 18             	mov    0x18(%ebp),%edi
  801dc9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dcc:	cd 30                	int    $0x30
  801dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801dd4:	83 c4 10             	add    $0x10,%esp
  801dd7:	5b                   	pop    %ebx
  801dd8:	5e                   	pop    %esi
  801dd9:	5f                   	pop    %edi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    

00801ddc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 04             	sub    $0x4,%esp
  801de2:	8b 45 10             	mov    0x10(%ebp),%eax
  801de5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801de8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	52                   	push   %edx
  801df4:	ff 75 0c             	pushl  0xc(%ebp)
  801df7:	50                   	push   %eax
  801df8:	6a 00                	push   $0x0
  801dfa:	e8 b2 ff ff ff       	call   801db1 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	90                   	nop
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 02                	push   $0x2
  801e14:	e8 98 ff ff ff       	call   801db1 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_lock_cons>:

void sys_lock_cons(void)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 03                	push   $0x3
  801e2d:	e8 7f ff ff ff       	call   801db1 <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
}
  801e35:	90                   	nop
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 04                	push   $0x4
  801e47:	e8 65 ff ff ff       	call   801db1 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	90                   	nop
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	52                   	push   %edx
  801e62:	50                   	push   %eax
  801e63:	6a 08                	push   $0x8
  801e65:	e8 47 ff ff ff       	call   801db1 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	56                   	push   %esi
  801e73:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e74:	8b 75 18             	mov    0x18(%ebp),%esi
  801e77:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	56                   	push   %esi
  801e84:	53                   	push   %ebx
  801e85:	51                   	push   %ecx
  801e86:	52                   	push   %edx
  801e87:	50                   	push   %eax
  801e88:	6a 09                	push   $0x9
  801e8a:	e8 22 ff ff ff       	call   801db1 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
}
  801e92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e95:	5b                   	pop    %ebx
  801e96:	5e                   	pop    %esi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    

00801e99 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	52                   	push   %edx
  801ea9:	50                   	push   %eax
  801eaa:	6a 0a                	push   $0xa
  801eac:	e8 00 ff ff ff       	call   801db1 <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	ff 75 0c             	pushl  0xc(%ebp)
  801ec2:	ff 75 08             	pushl  0x8(%ebp)
  801ec5:	6a 0b                	push   $0xb
  801ec7:	e8 e5 fe ff ff       	call   801db1 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 0c                	push   $0xc
  801ee0:	e8 cc fe ff ff       	call   801db1 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 0d                	push   $0xd
  801ef9:	e8 b3 fe ff ff       	call   801db1 <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 0e                	push   $0xe
  801f12:	e8 9a fe ff ff       	call   801db1 <syscall>
  801f17:	83 c4 18             	add    $0x18,%esp
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 0f                	push   $0xf
  801f2b:	e8 81 fe ff ff       	call   801db1 <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	ff 75 08             	pushl  0x8(%ebp)
  801f43:	6a 10                	push   $0x10
  801f45:	e8 67 fe ff ff       	call   801db1 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 11                	push   $0x11
  801f5e:	e8 4e fe ff ff       	call   801db1 <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	90                   	nop
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <sys_cputc>:

void
sys_cputc(const char c)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	83 ec 04             	sub    $0x4,%esp
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f75:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	50                   	push   %eax
  801f82:	6a 01                	push   $0x1
  801f84:	e8 28 fe ff ff       	call   801db1 <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	90                   	nop
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 14                	push   $0x14
  801f9e:	e8 0e fe ff ff       	call   801db1 <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
}
  801fa6:	90                   	nop
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fb5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fb8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	6a 00                	push   $0x0
  801fc1:	51                   	push   %ecx
  801fc2:	52                   	push   %edx
  801fc3:	ff 75 0c             	pushl  0xc(%ebp)
  801fc6:	50                   	push   %eax
  801fc7:	6a 15                	push   $0x15
  801fc9:	e8 e3 fd ff ff       	call   801db1 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	52                   	push   %edx
  801fe3:	50                   	push   %eax
  801fe4:	6a 16                	push   $0x16
  801fe6:	e8 c6 fd ff ff       	call   801db1 <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ff3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	51                   	push   %ecx
  802001:	52                   	push   %edx
  802002:	50                   	push   %eax
  802003:	6a 17                	push   $0x17
  802005:	e8 a7 fd ff ff       	call   801db1 <syscall>
  80200a:	83 c4 18             	add    $0x18,%esp
}
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802012:	8b 55 0c             	mov    0xc(%ebp),%edx
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	52                   	push   %edx
  80201f:	50                   	push   %eax
  802020:	6a 18                	push   $0x18
  802022:	e8 8a fd ff ff       	call   801db1 <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	6a 00                	push   $0x0
  802034:	ff 75 14             	pushl  0x14(%ebp)
  802037:	ff 75 10             	pushl  0x10(%ebp)
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	50                   	push   %eax
  80203e:	6a 19                	push   $0x19
  802040:	e8 6c fd ff ff       	call   801db1 <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	50                   	push   %eax
  802059:	6a 1a                	push   $0x1a
  80205b:	e8 51 fd ff ff       	call   801db1 <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	90                   	nop
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	50                   	push   %eax
  802075:	6a 1b                	push   $0x1b
  802077:	e8 35 fd ff ff       	call   801db1 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 05                	push   $0x5
  802090:	e8 1c fd ff ff       	call   801db1 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 06                	push   $0x6
  8020a9:	e8 03 fd ff ff       	call   801db1 <syscall>
  8020ae:	83 c4 18             	add    $0x18,%esp
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 07                	push   $0x7
  8020c2:	e8 ea fc ff ff       	call   801db1 <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_exit_env>:


void sys_exit_env(void)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 1c                	push   $0x1c
  8020db:	e8 d1 fc ff ff       	call   801db1 <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
}
  8020e3:	90                   	nop
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020ec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020ef:	8d 50 04             	lea    0x4(%eax),%edx
  8020f2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	52                   	push   %edx
  8020fc:	50                   	push   %eax
  8020fd:	6a 1d                	push   $0x1d
  8020ff:	e8 ad fc ff ff       	call   801db1 <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
	return result;
  802107:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80210a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80210d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802110:	89 01                	mov    %eax,(%ecx)
  802112:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	c9                   	leave  
  802119:	c2 04 00             	ret    $0x4

0080211c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	ff 75 10             	pushl  0x10(%ebp)
  802126:	ff 75 0c             	pushl  0xc(%ebp)
  802129:	ff 75 08             	pushl  0x8(%ebp)
  80212c:	6a 13                	push   $0x13
  80212e:	e8 7e fc ff ff       	call   801db1 <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
	return ;
  802136:	90                   	nop
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_rcr2>:
uint32 sys_rcr2()
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 1e                	push   $0x1e
  802148:	e8 64 fc ff ff       	call   801db1 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80215e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	50                   	push   %eax
  80216b:	6a 1f                	push   $0x1f
  80216d:	e8 3f fc ff ff       	call   801db1 <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
	return ;
  802175:	90                   	nop
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <rsttst>:
void rsttst()
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 21                	push   $0x21
  802187:	e8 25 fc ff ff       	call   801db1 <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
	return ;
  80218f:	90                   	nop
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	8b 45 14             	mov    0x14(%ebp),%eax
  80219b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80219e:	8b 55 18             	mov    0x18(%ebp),%edx
  8021a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021a5:	52                   	push   %edx
  8021a6:	50                   	push   %eax
  8021a7:	ff 75 10             	pushl  0x10(%ebp)
  8021aa:	ff 75 0c             	pushl  0xc(%ebp)
  8021ad:	ff 75 08             	pushl  0x8(%ebp)
  8021b0:	6a 20                	push   $0x20
  8021b2:	e8 fa fb ff ff       	call   801db1 <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ba:	90                   	nop
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <chktst>:
void chktst(uint32 n)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	ff 75 08             	pushl  0x8(%ebp)
  8021cb:	6a 22                	push   $0x22
  8021cd:	e8 df fb ff ff       	call   801db1 <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d5:	90                   	nop
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <inctst>:

void inctst()
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 23                	push   $0x23
  8021e7:	e8 c5 fb ff ff       	call   801db1 <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ef:	90                   	nop
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <gettst>:
uint32 gettst()
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 24                	push   $0x24
  802201:	e8 ab fb ff ff       	call   801db1 <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 25                	push   $0x25
  80221d:	e8 8f fb ff ff       	call   801db1 <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
  802225:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802228:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80222c:	75 07                	jne    802235 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80222e:	b8 01 00 00 00       	mov    $0x1,%eax
  802233:	eb 05                	jmp    80223a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 25                	push   $0x25
  80224e:	e8 5e fb ff ff       	call   801db1 <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
  802256:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802259:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80225d:	75 07                	jne    802266 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80225f:	b8 01 00 00 00       	mov    $0x1,%eax
  802264:	eb 05                	jmp    80226b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802266:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 25                	push   $0x25
  80227f:	e8 2d fb ff ff       	call   801db1 <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
  802287:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80228a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80228e:	75 07                	jne    802297 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802290:	b8 01 00 00 00       	mov    $0x1,%eax
  802295:	eb 05                	jmp    80229c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 25                	push   $0x25
  8022b0:	e8 fc fa ff ff       	call   801db1 <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
  8022b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022bb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022bf:	75 07                	jne    8022c8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c6:	eb 05                	jmp    8022cd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	ff 75 08             	pushl  0x8(%ebp)
  8022dd:	6a 26                	push   $0x26
  8022df:	e8 cd fa ff ff       	call   801db1 <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e7:	90                   	nop
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	6a 00                	push   $0x0
  8022fc:	53                   	push   %ebx
  8022fd:	51                   	push   %ecx
  8022fe:	52                   	push   %edx
  8022ff:	50                   	push   %eax
  802300:	6a 27                	push   $0x27
  802302:	e8 aa fa ff ff       	call   801db1 <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
}
  80230a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802312:	8b 55 0c             	mov    0xc(%ebp),%edx
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	52                   	push   %edx
  80231f:	50                   	push   %eax
  802320:	6a 28                	push   $0x28
  802322:	e8 8a fa ff ff       	call   801db1 <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80232f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802332:	8b 55 0c             	mov    0xc(%ebp),%edx
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	6a 00                	push   $0x0
  80233a:	51                   	push   %ecx
  80233b:	ff 75 10             	pushl  0x10(%ebp)
  80233e:	52                   	push   %edx
  80233f:	50                   	push   %eax
  802340:	6a 29                	push   $0x29
  802342:	e8 6a fa ff ff       	call   801db1 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
}
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	ff 75 10             	pushl  0x10(%ebp)
  802356:	ff 75 0c             	pushl  0xc(%ebp)
  802359:	ff 75 08             	pushl  0x8(%ebp)
  80235c:	6a 12                	push   $0x12
  80235e:	e8 4e fa ff ff       	call   801db1 <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
	return ;
  802366:	90                   	nop
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80236c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	52                   	push   %edx
  802379:	50                   	push   %eax
  80237a:	6a 2a                	push   $0x2a
  80237c:	e8 30 fa ff ff       	call   801db1 <syscall>
  802381:	83 c4 18             	add    $0x18,%esp
	return;
  802384:	90                   	nop
}
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	50                   	push   %eax
  802396:	6a 2b                	push   $0x2b
  802398:	e8 14 fa ff ff       	call   801db1 <syscall>
  80239d:	83 c4 18             	add    $0x18,%esp
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	ff 75 0c             	pushl  0xc(%ebp)
  8023ae:	ff 75 08             	pushl  0x8(%ebp)
  8023b1:	6a 2c                	push   $0x2c
  8023b3:	e8 f9 f9 ff ff       	call   801db1 <syscall>
  8023b8:	83 c4 18             	add    $0x18,%esp
	return;
  8023bb:	90                   	nop
}
  8023bc:	c9                   	leave  
  8023bd:	c3                   	ret    

008023be <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	ff 75 0c             	pushl  0xc(%ebp)
  8023ca:	ff 75 08             	pushl  0x8(%ebp)
  8023cd:	6a 2d                	push   $0x2d
  8023cf:	e8 dd f9 ff ff       	call   801db1 <syscall>
  8023d4:	83 c4 18             	add    $0x18,%esp
	return;
  8023d7:	90                   	nop
}
  8023d8:	c9                   	leave  
  8023d9:	c3                   	ret    

008023da <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
  8023dd:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	83 e8 04             	sub    $0x4,%eax
  8023e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8023e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
  8023f6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	83 e8 04             	sub    $0x4,%eax
  8023ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802402:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	83 e0 01             	and    $0x1,%eax
  80240a:	85 c0                	test   %eax,%eax
  80240c:	0f 94 c0             	sete   %al
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80241e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802421:	83 f8 02             	cmp    $0x2,%eax
  802424:	74 2b                	je     802451 <alloc_block+0x40>
  802426:	83 f8 02             	cmp    $0x2,%eax
  802429:	7f 07                	jg     802432 <alloc_block+0x21>
  80242b:	83 f8 01             	cmp    $0x1,%eax
  80242e:	74 0e                	je     80243e <alloc_block+0x2d>
  802430:	eb 58                	jmp    80248a <alloc_block+0x79>
  802432:	83 f8 03             	cmp    $0x3,%eax
  802435:	74 2d                	je     802464 <alloc_block+0x53>
  802437:	83 f8 04             	cmp    $0x4,%eax
  80243a:	74 3b                	je     802477 <alloc_block+0x66>
  80243c:	eb 4c                	jmp    80248a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80243e:	83 ec 0c             	sub    $0xc,%esp
  802441:	ff 75 08             	pushl  0x8(%ebp)
  802444:	e8 11 03 00 00       	call   80275a <alloc_block_FF>
  802449:	83 c4 10             	add    $0x10,%esp
  80244c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80244f:	eb 4a                	jmp    80249b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802451:	83 ec 0c             	sub    $0xc,%esp
  802454:	ff 75 08             	pushl  0x8(%ebp)
  802457:	e8 fa 19 00 00       	call   803e56 <alloc_block_NF>
  80245c:	83 c4 10             	add    $0x10,%esp
  80245f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802462:	eb 37                	jmp    80249b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802464:	83 ec 0c             	sub    $0xc,%esp
  802467:	ff 75 08             	pushl  0x8(%ebp)
  80246a:	e8 a7 07 00 00       	call   802c16 <alloc_block_BF>
  80246f:	83 c4 10             	add    $0x10,%esp
  802472:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802475:	eb 24                	jmp    80249b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802477:	83 ec 0c             	sub    $0xc,%esp
  80247a:	ff 75 08             	pushl  0x8(%ebp)
  80247d:	e8 b7 19 00 00       	call   803e39 <alloc_block_WF>
  802482:	83 c4 10             	add    $0x10,%esp
  802485:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802488:	eb 11                	jmp    80249b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80248a:	83 ec 0c             	sub    $0xc,%esp
  80248d:	68 58 4b 80 00       	push   $0x804b58
  802492:	e8 3b e6 ff ff       	call   800ad2 <cprintf>
  802497:	83 c4 10             	add    $0x10,%esp
		break;
  80249a:	90                   	nop
	}
	return va;
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	53                   	push   %ebx
  8024a4:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8024a7:	83 ec 0c             	sub    $0xc,%esp
  8024aa:	68 78 4b 80 00       	push   $0x804b78
  8024af:	e8 1e e6 ff ff       	call   800ad2 <cprintf>
  8024b4:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8024b7:	83 ec 0c             	sub    $0xc,%esp
  8024ba:	68 a3 4b 80 00       	push   $0x804ba3
  8024bf:	e8 0e e6 ff ff       	call   800ad2 <cprintf>
  8024c4:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cd:	eb 37                	jmp    802506 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8024cf:	83 ec 0c             	sub    $0xc,%esp
  8024d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8024d5:	e8 19 ff ff ff       	call   8023f3 <is_free_block>
  8024da:	83 c4 10             	add    $0x10,%esp
  8024dd:	0f be d8             	movsbl %al,%ebx
  8024e0:	83 ec 0c             	sub    $0xc,%esp
  8024e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8024e6:	e8 ef fe ff ff       	call   8023da <get_block_size>
  8024eb:	83 c4 10             	add    $0x10,%esp
  8024ee:	83 ec 04             	sub    $0x4,%esp
  8024f1:	53                   	push   %ebx
  8024f2:	50                   	push   %eax
  8024f3:	68 bb 4b 80 00       	push   $0x804bbb
  8024f8:	e8 d5 e5 ff ff       	call   800ad2 <cprintf>
  8024fd:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802500:	8b 45 10             	mov    0x10(%ebp),%eax
  802503:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802506:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250a:	74 07                	je     802513 <print_blocks_list+0x73>
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 00                	mov    (%eax),%eax
  802511:	eb 05                	jmp    802518 <print_blocks_list+0x78>
  802513:	b8 00 00 00 00       	mov    $0x0,%eax
  802518:	89 45 10             	mov    %eax,0x10(%ebp)
  80251b:	8b 45 10             	mov    0x10(%ebp),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	75 ad                	jne    8024cf <print_blocks_list+0x2f>
  802522:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802526:	75 a7                	jne    8024cf <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802528:	83 ec 0c             	sub    $0xc,%esp
  80252b:	68 78 4b 80 00       	push   $0x804b78
  802530:	e8 9d e5 ff ff       	call   800ad2 <cprintf>
  802535:	83 c4 10             	add    $0x10,%esp

}
  802538:	90                   	nop
  802539:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802544:	8b 45 0c             	mov    0xc(%ebp),%eax
  802547:	83 e0 01             	and    $0x1,%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 03                	je     802551 <initialize_dynamic_allocator+0x13>
  80254e:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802551:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802555:	0f 84 c7 01 00 00    	je     802722 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80255b:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802562:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802565:	8b 55 08             	mov    0x8(%ebp),%edx
  802568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256b:	01 d0                	add    %edx,%eax
  80256d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802572:	0f 87 ad 01 00 00    	ja     802725 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	85 c0                	test   %eax,%eax
  80257d:	0f 89 a5 01 00 00    	jns    802728 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802583:	8b 55 08             	mov    0x8(%ebp),%edx
  802586:	8b 45 0c             	mov    0xc(%ebp),%eax
  802589:	01 d0                	add    %edx,%eax
  80258b:	83 e8 04             	sub    $0x4,%eax
  80258e:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802593:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80259a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80259f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a2:	e9 87 00 00 00       	jmp    80262e <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8025a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ab:	75 14                	jne    8025c1 <initialize_dynamic_allocator+0x83>
  8025ad:	83 ec 04             	sub    $0x4,%esp
  8025b0:	68 d3 4b 80 00       	push   $0x804bd3
  8025b5:	6a 79                	push   $0x79
  8025b7:	68 f1 4b 80 00       	push   $0x804bf1
  8025bc:	e8 54 e2 ff ff       	call   800815 <_panic>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	74 10                	je     8025da <initialize_dynamic_allocator+0x9c>
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 00                	mov    (%eax),%eax
  8025cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d2:	8b 52 04             	mov    0x4(%edx),%edx
  8025d5:	89 50 04             	mov    %edx,0x4(%eax)
  8025d8:	eb 0b                	jmp    8025e5 <initialize_dynamic_allocator+0xa7>
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 40 04             	mov    0x4(%eax),%eax
  8025e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 40 04             	mov    0x4(%eax),%eax
  8025eb:	85 c0                	test   %eax,%eax
  8025ed:	74 0f                	je     8025fe <initialize_dynamic_allocator+0xc0>
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 40 04             	mov    0x4(%eax),%eax
  8025f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f8:	8b 12                	mov    (%edx),%edx
  8025fa:	89 10                	mov    %edx,(%eax)
  8025fc:	eb 0a                	jmp    802608 <initialize_dynamic_allocator+0xca>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261b:	a1 38 50 80 00       	mov    0x805038,%eax
  802620:	48                   	dec    %eax
  802621:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802626:	a1 34 50 80 00       	mov    0x805034,%eax
  80262b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802632:	74 07                	je     80263b <initialize_dynamic_allocator+0xfd>
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 00                	mov    (%eax),%eax
  802639:	eb 05                	jmp    802640 <initialize_dynamic_allocator+0x102>
  80263b:	b8 00 00 00 00       	mov    $0x0,%eax
  802640:	a3 34 50 80 00       	mov    %eax,0x805034
  802645:	a1 34 50 80 00       	mov    0x805034,%eax
  80264a:	85 c0                	test   %eax,%eax
  80264c:	0f 85 55 ff ff ff    	jne    8025a7 <initialize_dynamic_allocator+0x69>
  802652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802656:	0f 85 4b ff ff ff    	jne    8025a7 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80265c:	8b 45 08             	mov    0x8(%ebp),%eax
  80265f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802665:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80266b:	a1 44 50 80 00       	mov    0x805044,%eax
  802670:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802675:	a1 40 50 80 00       	mov    0x805040,%eax
  80267a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802680:	8b 45 08             	mov    0x8(%ebp),%eax
  802683:	83 c0 08             	add    $0x8,%eax
  802686:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	83 c0 04             	add    $0x4,%eax
  80268f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802692:	83 ea 08             	sub    $0x8,%edx
  802695:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802697:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269a:	8b 45 08             	mov    0x8(%ebp),%eax
  80269d:	01 d0                	add    %edx,%eax
  80269f:	83 e8 08             	sub    $0x8,%eax
  8026a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a5:	83 ea 08             	sub    $0x8,%edx
  8026a8:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8026aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8026b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8026bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026c1:	75 17                	jne    8026da <initialize_dynamic_allocator+0x19c>
  8026c3:	83 ec 04             	sub    $0x4,%esp
  8026c6:	68 0c 4c 80 00       	push   $0x804c0c
  8026cb:	68 90 00 00 00       	push   $0x90
  8026d0:	68 f1 4b 80 00       	push   $0x804bf1
  8026d5:	e8 3b e1 ff ff       	call   800815 <_panic>
  8026da:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8026e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e3:	89 10                	mov    %edx,(%eax)
  8026e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e8:	8b 00                	mov    (%eax),%eax
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	74 0d                	je     8026fb <initialize_dynamic_allocator+0x1bd>
  8026ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026f6:	89 50 04             	mov    %edx,0x4(%eax)
  8026f9:	eb 08                	jmp    802703 <initialize_dynamic_allocator+0x1c5>
  8026fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fe:	a3 30 50 80 00       	mov    %eax,0x805030
  802703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802706:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80270b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802715:	a1 38 50 80 00       	mov    0x805038,%eax
  80271a:	40                   	inc    %eax
  80271b:	a3 38 50 80 00       	mov    %eax,0x805038
  802720:	eb 07                	jmp    802729 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802722:	90                   	nop
  802723:	eb 04                	jmp    802729 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802725:	90                   	nop
  802726:	eb 01                	jmp    802729 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802728:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    

0080272b <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80272e:	8b 45 10             	mov    0x10(%ebp),%eax
  802731:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802734:	8b 45 08             	mov    0x8(%ebp),%eax
  802737:	8d 50 fc             	lea    -0x4(%eax),%edx
  80273a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273d:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80273f:	8b 45 08             	mov    0x8(%ebp),%eax
  802742:	83 e8 04             	sub    $0x4,%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	83 e0 fe             	and    $0xfffffffe,%eax
  80274a:	8d 50 f8             	lea    -0x8(%eax),%edx
  80274d:	8b 45 08             	mov    0x8(%ebp),%eax
  802750:	01 c2                	add    %eax,%edx
  802752:	8b 45 0c             	mov    0xc(%ebp),%eax
  802755:	89 02                	mov    %eax,(%edx)
}
  802757:	90                   	nop
  802758:	5d                   	pop    %ebp
  802759:	c3                   	ret    

0080275a <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
  80275d:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	83 e0 01             	and    $0x1,%eax
  802766:	85 c0                	test   %eax,%eax
  802768:	74 03                	je     80276d <alloc_block_FF+0x13>
  80276a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80276d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802771:	77 07                	ja     80277a <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802773:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80277a:	a1 24 50 80 00       	mov    0x805024,%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	75 73                	jne    8027f6 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	83 c0 10             	add    $0x10,%eax
  802789:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80278c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802793:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802799:	01 d0                	add    %edx,%eax
  80279b:	48                   	dec    %eax
  80279c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80279f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a7:	f7 75 ec             	divl   -0x14(%ebp)
  8027aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ad:	29 d0                	sub    %edx,%eax
  8027af:	c1 e8 0c             	shr    $0xc,%eax
  8027b2:	83 ec 0c             	sub    $0xc,%esp
  8027b5:	50                   	push   %eax
  8027b6:	e8 b1 f0 ff ff       	call   80186c <sbrk>
  8027bb:	83 c4 10             	add    $0x10,%esp
  8027be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027c1:	83 ec 0c             	sub    $0xc,%esp
  8027c4:	6a 00                	push   $0x0
  8027c6:	e8 a1 f0 ff ff       	call   80186c <sbrk>
  8027cb:	83 c4 10             	add    $0x10,%esp
  8027ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8027d7:	83 ec 08             	sub    $0x8,%esp
  8027da:	50                   	push   %eax
  8027db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8027de:	e8 5b fd ff ff       	call   80253e <initialize_dynamic_allocator>
  8027e3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027e6:	83 ec 0c             	sub    $0xc,%esp
  8027e9:	68 2f 4c 80 00       	push   $0x804c2f
  8027ee:	e8 df e2 ff ff       	call   800ad2 <cprintf>
  8027f3:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8027f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027fa:	75 0a                	jne    802806 <alloc_block_FF+0xac>
	        return NULL;
  8027fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802801:	e9 0e 04 00 00       	jmp    802c14 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80280d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802815:	e9 f3 02 00 00       	jmp    802b0d <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802820:	83 ec 0c             	sub    $0xc,%esp
  802823:	ff 75 bc             	pushl  -0x44(%ebp)
  802826:	e8 af fb ff ff       	call   8023da <get_block_size>
  80282b:	83 c4 10             	add    $0x10,%esp
  80282e:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	83 c0 08             	add    $0x8,%eax
  802837:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80283a:	0f 87 c5 02 00 00    	ja     802b05 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802840:	8b 45 08             	mov    0x8(%ebp),%eax
  802843:	83 c0 18             	add    $0x18,%eax
  802846:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802849:	0f 87 19 02 00 00    	ja     802a68 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80284f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802852:	2b 45 08             	sub    0x8(%ebp),%eax
  802855:	83 e8 08             	sub    $0x8,%eax
  802858:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	8d 50 08             	lea    0x8(%eax),%edx
  802861:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802864:	01 d0                	add    %edx,%eax
  802866:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802869:	8b 45 08             	mov    0x8(%ebp),%eax
  80286c:	83 c0 08             	add    $0x8,%eax
  80286f:	83 ec 04             	sub    $0x4,%esp
  802872:	6a 01                	push   $0x1
  802874:	50                   	push   %eax
  802875:	ff 75 bc             	pushl  -0x44(%ebp)
  802878:	e8 ae fe ff ff       	call   80272b <set_block_data>
  80287d:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 40 04             	mov    0x4(%eax),%eax
  802886:	85 c0                	test   %eax,%eax
  802888:	75 68                	jne    8028f2 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80288a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80288e:	75 17                	jne    8028a7 <alloc_block_FF+0x14d>
  802890:	83 ec 04             	sub    $0x4,%esp
  802893:	68 0c 4c 80 00       	push   $0x804c0c
  802898:	68 d7 00 00 00       	push   $0xd7
  80289d:	68 f1 4b 80 00       	push   $0x804bf1
  8028a2:	e8 6e df ff ff       	call   800815 <_panic>
  8028a7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b0:	89 10                	mov    %edx,(%eax)
  8028b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	74 0d                	je     8028c8 <alloc_block_FF+0x16e>
  8028bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028c0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028c3:	89 50 04             	mov    %edx,0x4(%eax)
  8028c6:	eb 08                	jmp    8028d0 <alloc_block_FF+0x176>
  8028c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8028d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8028e7:	40                   	inc    %eax
  8028e8:	a3 38 50 80 00       	mov    %eax,0x805038
  8028ed:	e9 dc 00 00 00       	jmp    8029ce <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	8b 00                	mov    (%eax),%eax
  8028f7:	85 c0                	test   %eax,%eax
  8028f9:	75 65                	jne    802960 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028fb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028ff:	75 17                	jne    802918 <alloc_block_FF+0x1be>
  802901:	83 ec 04             	sub    $0x4,%esp
  802904:	68 40 4c 80 00       	push   $0x804c40
  802909:	68 db 00 00 00       	push   $0xdb
  80290e:	68 f1 4b 80 00       	push   $0x804bf1
  802913:	e8 fd de ff ff       	call   800815 <_panic>
  802918:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80291e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802921:	89 50 04             	mov    %edx,0x4(%eax)
  802924:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802927:	8b 40 04             	mov    0x4(%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	74 0c                	je     80293a <alloc_block_FF+0x1e0>
  80292e:	a1 30 50 80 00       	mov    0x805030,%eax
  802933:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802936:	89 10                	mov    %edx,(%eax)
  802938:	eb 08                	jmp    802942 <alloc_block_FF+0x1e8>
  80293a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80293d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802942:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802945:	a3 30 50 80 00       	mov    %eax,0x805030
  80294a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80294d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802953:	a1 38 50 80 00       	mov    0x805038,%eax
  802958:	40                   	inc    %eax
  802959:	a3 38 50 80 00       	mov    %eax,0x805038
  80295e:	eb 6e                	jmp    8029ce <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802960:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802964:	74 06                	je     80296c <alloc_block_FF+0x212>
  802966:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80296a:	75 17                	jne    802983 <alloc_block_FF+0x229>
  80296c:	83 ec 04             	sub    $0x4,%esp
  80296f:	68 64 4c 80 00       	push   $0x804c64
  802974:	68 df 00 00 00       	push   $0xdf
  802979:	68 f1 4b 80 00       	push   $0x804bf1
  80297e:	e8 92 de ff ff       	call   800815 <_panic>
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 10                	mov    (%eax),%edx
  802988:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80298b:	89 10                	mov    %edx,(%eax)
  80298d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802990:	8b 00                	mov    (%eax),%eax
  802992:	85 c0                	test   %eax,%eax
  802994:	74 0b                	je     8029a1 <alloc_block_FF+0x247>
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	8b 00                	mov    (%eax),%eax
  80299b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80299e:	89 50 04             	mov    %edx,0x4(%eax)
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029a7:	89 10                	mov    %edx,(%eax)
  8029a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029af:	89 50 04             	mov    %edx,0x4(%eax)
  8029b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029b5:	8b 00                	mov    (%eax),%eax
  8029b7:	85 c0                	test   %eax,%eax
  8029b9:	75 08                	jne    8029c3 <alloc_block_FF+0x269>
  8029bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029be:	a3 30 50 80 00       	mov    %eax,0x805030
  8029c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8029c8:	40                   	inc    %eax
  8029c9:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8029ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d2:	75 17                	jne    8029eb <alloc_block_FF+0x291>
  8029d4:	83 ec 04             	sub    $0x4,%esp
  8029d7:	68 d3 4b 80 00       	push   $0x804bd3
  8029dc:	68 e1 00 00 00       	push   $0xe1
  8029e1:	68 f1 4b 80 00       	push   $0x804bf1
  8029e6:	e8 2a de ff ff       	call   800815 <_panic>
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 00                	mov    (%eax),%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	74 10                	je     802a04 <alloc_block_FF+0x2aa>
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 00                	mov    (%eax),%eax
  8029f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fc:	8b 52 04             	mov    0x4(%edx),%edx
  8029ff:	89 50 04             	mov    %edx,0x4(%eax)
  802a02:	eb 0b                	jmp    802a0f <alloc_block_FF+0x2b5>
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 40 04             	mov    0x4(%eax),%eax
  802a0a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	8b 40 04             	mov    0x4(%eax),%eax
  802a15:	85 c0                	test   %eax,%eax
  802a17:	74 0f                	je     802a28 <alloc_block_FF+0x2ce>
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 40 04             	mov    0x4(%eax),%eax
  802a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a22:	8b 12                	mov    (%edx),%edx
  802a24:	89 10                	mov    %edx,(%eax)
  802a26:	eb 0a                	jmp    802a32 <alloc_block_FF+0x2d8>
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a45:	a1 38 50 80 00       	mov    0x805038,%eax
  802a4a:	48                   	dec    %eax
  802a4b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802a50:	83 ec 04             	sub    $0x4,%esp
  802a53:	6a 00                	push   $0x0
  802a55:	ff 75 b4             	pushl  -0x4c(%ebp)
  802a58:	ff 75 b0             	pushl  -0x50(%ebp)
  802a5b:	e8 cb fc ff ff       	call   80272b <set_block_data>
  802a60:	83 c4 10             	add    $0x10,%esp
  802a63:	e9 95 00 00 00       	jmp    802afd <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802a68:	83 ec 04             	sub    $0x4,%esp
  802a6b:	6a 01                	push   $0x1
  802a6d:	ff 75 b8             	pushl  -0x48(%ebp)
  802a70:	ff 75 bc             	pushl  -0x44(%ebp)
  802a73:	e8 b3 fc ff ff       	call   80272b <set_block_data>
  802a78:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7f:	75 17                	jne    802a98 <alloc_block_FF+0x33e>
  802a81:	83 ec 04             	sub    $0x4,%esp
  802a84:	68 d3 4b 80 00       	push   $0x804bd3
  802a89:	68 e8 00 00 00       	push   $0xe8
  802a8e:	68 f1 4b 80 00       	push   $0x804bf1
  802a93:	e8 7d dd ff ff       	call   800815 <_panic>
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 00                	mov    (%eax),%eax
  802a9d:	85 c0                	test   %eax,%eax
  802a9f:	74 10                	je     802ab1 <alloc_block_FF+0x357>
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa9:	8b 52 04             	mov    0x4(%edx),%edx
  802aac:	89 50 04             	mov    %edx,0x4(%eax)
  802aaf:	eb 0b                	jmp    802abc <alloc_block_FF+0x362>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 40 04             	mov    0x4(%eax),%eax
  802ab7:	a3 30 50 80 00       	mov    %eax,0x805030
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	8b 40 04             	mov    0x4(%eax),%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	74 0f                	je     802ad5 <alloc_block_FF+0x37b>
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 40 04             	mov    0x4(%eax),%eax
  802acc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acf:	8b 12                	mov    (%edx),%edx
  802ad1:	89 10                	mov    %edx,(%eax)
  802ad3:	eb 0a                	jmp    802adf <alloc_block_FF+0x385>
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af2:	a1 38 50 80 00       	mov    0x805038,%eax
  802af7:	48                   	dec    %eax
  802af8:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802afd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b00:	e9 0f 01 00 00       	jmp    802c14 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b05:	a1 34 50 80 00       	mov    0x805034,%eax
  802b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b11:	74 07                	je     802b1a <alloc_block_FF+0x3c0>
  802b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b16:	8b 00                	mov    (%eax),%eax
  802b18:	eb 05                	jmp    802b1f <alloc_block_FF+0x3c5>
  802b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1f:	a3 34 50 80 00       	mov    %eax,0x805034
  802b24:	a1 34 50 80 00       	mov    0x805034,%eax
  802b29:	85 c0                	test   %eax,%eax
  802b2b:	0f 85 e9 fc ff ff    	jne    80281a <alloc_block_FF+0xc0>
  802b31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b35:	0f 85 df fc ff ff    	jne    80281a <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	83 c0 08             	add    $0x8,%eax
  802b41:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b44:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802b4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b51:	01 d0                	add    %edx,%eax
  802b53:	48                   	dec    %eax
  802b54:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  802b5f:	f7 75 d8             	divl   -0x28(%ebp)
  802b62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b65:	29 d0                	sub    %edx,%eax
  802b67:	c1 e8 0c             	shr    $0xc,%eax
  802b6a:	83 ec 0c             	sub    $0xc,%esp
  802b6d:	50                   	push   %eax
  802b6e:	e8 f9 ec ff ff       	call   80186c <sbrk>
  802b73:	83 c4 10             	add    $0x10,%esp
  802b76:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802b79:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802b7d:	75 0a                	jne    802b89 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802b7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b84:	e9 8b 00 00 00       	jmp    802c14 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b89:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802b90:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b96:	01 d0                	add    %edx,%eax
  802b98:	48                   	dec    %eax
  802b99:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802b9c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b9f:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba4:	f7 75 cc             	divl   -0x34(%ebp)
  802ba7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802baa:	29 d0                	sub    %edx,%eax
  802bac:	8d 50 fc             	lea    -0x4(%eax),%edx
  802baf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bb2:	01 d0                	add    %edx,%eax
  802bb4:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802bb9:	a1 40 50 80 00       	mov    0x805040,%eax
  802bbe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bc4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802bcb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bd1:	01 d0                	add    %edx,%eax
  802bd3:	48                   	dec    %eax
  802bd4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bd7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bda:	ba 00 00 00 00       	mov    $0x0,%edx
  802bdf:	f7 75 c4             	divl   -0x3c(%ebp)
  802be2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802be5:	29 d0                	sub    %edx,%eax
  802be7:	83 ec 04             	sub    $0x4,%esp
  802bea:	6a 01                	push   $0x1
  802bec:	50                   	push   %eax
  802bed:	ff 75 d0             	pushl  -0x30(%ebp)
  802bf0:	e8 36 fb ff ff       	call   80272b <set_block_data>
  802bf5:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802bf8:	83 ec 0c             	sub    $0xc,%esp
  802bfb:	ff 75 d0             	pushl  -0x30(%ebp)
  802bfe:	e8 1b 0a 00 00       	call   80361e <free_block>
  802c03:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802c06:	83 ec 0c             	sub    $0xc,%esp
  802c09:	ff 75 08             	pushl  0x8(%ebp)
  802c0c:	e8 49 fb ff ff       	call   80275a <alloc_block_FF>
  802c11:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802c14:	c9                   	leave  
  802c15:	c3                   	ret    

00802c16 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802c16:	55                   	push   %ebp
  802c17:	89 e5                	mov    %esp,%ebp
  802c19:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	83 e0 01             	and    $0x1,%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	74 03                	je     802c29 <alloc_block_BF+0x13>
  802c26:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802c29:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802c2d:	77 07                	ja     802c36 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802c2f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802c36:	a1 24 50 80 00       	mov    0x805024,%eax
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	75 73                	jne    802cb2 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	83 c0 10             	add    $0x10,%eax
  802c45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802c48:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802c4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c55:	01 d0                	add    %edx,%eax
  802c57:	48                   	dec    %eax
  802c58:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802c5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  802c63:	f7 75 e0             	divl   -0x20(%ebp)
  802c66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c69:	29 d0                	sub    %edx,%eax
  802c6b:	c1 e8 0c             	shr    $0xc,%eax
  802c6e:	83 ec 0c             	sub    $0xc,%esp
  802c71:	50                   	push   %eax
  802c72:	e8 f5 eb ff ff       	call   80186c <sbrk>
  802c77:	83 c4 10             	add    $0x10,%esp
  802c7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802c7d:	83 ec 0c             	sub    $0xc,%esp
  802c80:	6a 00                	push   $0x0
  802c82:	e8 e5 eb ff ff       	call   80186c <sbrk>
  802c87:	83 c4 10             	add    $0x10,%esp
  802c8a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c90:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802c93:	83 ec 08             	sub    $0x8,%esp
  802c96:	50                   	push   %eax
  802c97:	ff 75 d8             	pushl  -0x28(%ebp)
  802c9a:	e8 9f f8 ff ff       	call   80253e <initialize_dynamic_allocator>
  802c9f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ca2:	83 ec 0c             	sub    $0xc,%esp
  802ca5:	68 2f 4c 80 00       	push   $0x804c2f
  802caa:	e8 23 de ff ff       	call   800ad2 <cprintf>
  802caf:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802cb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802cb9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802cc0:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802cc7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802cce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd6:	e9 1d 01 00 00       	jmp    802df8 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802ce1:	83 ec 0c             	sub    $0xc,%esp
  802ce4:	ff 75 a8             	pushl  -0x58(%ebp)
  802ce7:	e8 ee f6 ff ff       	call   8023da <get_block_size>
  802cec:	83 c4 10             	add    $0x10,%esp
  802cef:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	83 c0 08             	add    $0x8,%eax
  802cf8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cfb:	0f 87 ef 00 00 00    	ja     802df0 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	83 c0 18             	add    $0x18,%eax
  802d07:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d0a:	77 1d                	ja     802d29 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d12:	0f 86 d8 00 00 00    	jbe    802df0 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802d18:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802d1e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d21:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d24:	e9 c7 00 00 00       	jmp    802df0 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	83 c0 08             	add    $0x8,%eax
  802d2f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d32:	0f 85 9d 00 00 00    	jne    802dd5 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802d38:	83 ec 04             	sub    $0x4,%esp
  802d3b:	6a 01                	push   $0x1
  802d3d:	ff 75 a4             	pushl  -0x5c(%ebp)
  802d40:	ff 75 a8             	pushl  -0x58(%ebp)
  802d43:	e8 e3 f9 ff ff       	call   80272b <set_block_data>
  802d48:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802d4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4f:	75 17                	jne    802d68 <alloc_block_BF+0x152>
  802d51:	83 ec 04             	sub    $0x4,%esp
  802d54:	68 d3 4b 80 00       	push   $0x804bd3
  802d59:	68 2c 01 00 00       	push   $0x12c
  802d5e:	68 f1 4b 80 00       	push   $0x804bf1
  802d63:	e8 ad da ff ff       	call   800815 <_panic>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	85 c0                	test   %eax,%eax
  802d6f:	74 10                	je     802d81 <alloc_block_BF+0x16b>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 00                	mov    (%eax),%eax
  802d76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d79:	8b 52 04             	mov    0x4(%edx),%edx
  802d7c:	89 50 04             	mov    %edx,0x4(%eax)
  802d7f:	eb 0b                	jmp    802d8c <alloc_block_BF+0x176>
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 40 04             	mov    0x4(%eax),%eax
  802d87:	a3 30 50 80 00       	mov    %eax,0x805030
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 40 04             	mov    0x4(%eax),%eax
  802d92:	85 c0                	test   %eax,%eax
  802d94:	74 0f                	je     802da5 <alloc_block_BF+0x18f>
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 40 04             	mov    0x4(%eax),%eax
  802d9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9f:	8b 12                	mov    (%edx),%edx
  802da1:	89 10                	mov    %edx,(%eax)
  802da3:	eb 0a                	jmp    802daf <alloc_block_BF+0x199>
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc2:	a1 38 50 80 00       	mov    0x805038,%eax
  802dc7:	48                   	dec    %eax
  802dc8:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802dcd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802dd0:	e9 24 04 00 00       	jmp    8031f9 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ddb:	76 13                	jbe    802df0 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802ddd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802de4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802de7:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802dea:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ded:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802df0:	a1 34 50 80 00       	mov    0x805034,%eax
  802df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfc:	74 07                	je     802e05 <alloc_block_BF+0x1ef>
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	eb 05                	jmp    802e0a <alloc_block_BF+0x1f4>
  802e05:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0a:	a3 34 50 80 00       	mov    %eax,0x805034
  802e0f:	a1 34 50 80 00       	mov    0x805034,%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	0f 85 bf fe ff ff    	jne    802cdb <alloc_block_BF+0xc5>
  802e1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e20:	0f 85 b5 fe ff ff    	jne    802cdb <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802e26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e2a:	0f 84 26 02 00 00    	je     803056 <alloc_block_BF+0x440>
  802e30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e34:	0f 85 1c 02 00 00    	jne    803056 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802e3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3d:	2b 45 08             	sub    0x8(%ebp),%eax
  802e40:	83 e8 08             	sub    $0x8,%eax
  802e43:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	8d 50 08             	lea    0x8(%eax),%edx
  802e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4f:	01 d0                	add    %edx,%eax
  802e51:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	83 c0 08             	add    $0x8,%eax
  802e5a:	83 ec 04             	sub    $0x4,%esp
  802e5d:	6a 01                	push   $0x1
  802e5f:	50                   	push   %eax
  802e60:	ff 75 f0             	pushl  -0x10(%ebp)
  802e63:	e8 c3 f8 ff ff       	call   80272b <set_block_data>
  802e68:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6e:	8b 40 04             	mov    0x4(%eax),%eax
  802e71:	85 c0                	test   %eax,%eax
  802e73:	75 68                	jne    802edd <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e75:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e79:	75 17                	jne    802e92 <alloc_block_BF+0x27c>
  802e7b:	83 ec 04             	sub    $0x4,%esp
  802e7e:	68 0c 4c 80 00       	push   $0x804c0c
  802e83:	68 45 01 00 00       	push   $0x145
  802e88:	68 f1 4b 80 00       	push   $0x804bf1
  802e8d:	e8 83 d9 ff ff       	call   800815 <_panic>
  802e92:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e9b:	89 10                	mov    %edx,(%eax)
  802e9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	74 0d                	je     802eb3 <alloc_block_BF+0x29d>
  802ea6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eab:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802eae:	89 50 04             	mov    %edx,0x4(%eax)
  802eb1:	eb 08                	jmp    802ebb <alloc_block_BF+0x2a5>
  802eb3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eb6:	a3 30 50 80 00       	mov    %eax,0x805030
  802ebb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ebe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ec3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ec6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecd:	a1 38 50 80 00       	mov    0x805038,%eax
  802ed2:	40                   	inc    %eax
  802ed3:	a3 38 50 80 00       	mov    %eax,0x805038
  802ed8:	e9 dc 00 00 00       	jmp    802fb9 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee0:	8b 00                	mov    (%eax),%eax
  802ee2:	85 c0                	test   %eax,%eax
  802ee4:	75 65                	jne    802f4b <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ee6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802eea:	75 17                	jne    802f03 <alloc_block_BF+0x2ed>
  802eec:	83 ec 04             	sub    $0x4,%esp
  802eef:	68 40 4c 80 00       	push   $0x804c40
  802ef4:	68 4a 01 00 00       	push   $0x14a
  802ef9:	68 f1 4b 80 00       	push   $0x804bf1
  802efe:	e8 12 d9 ff ff       	call   800815 <_panic>
  802f03:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f0c:	89 50 04             	mov    %edx,0x4(%eax)
  802f0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f12:	8b 40 04             	mov    0x4(%eax),%eax
  802f15:	85 c0                	test   %eax,%eax
  802f17:	74 0c                	je     802f25 <alloc_block_BF+0x30f>
  802f19:	a1 30 50 80 00       	mov    0x805030,%eax
  802f1e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f21:	89 10                	mov    %edx,(%eax)
  802f23:	eb 08                	jmp    802f2d <alloc_block_BF+0x317>
  802f25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f28:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f30:	a3 30 50 80 00       	mov    %eax,0x805030
  802f35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3e:	a1 38 50 80 00       	mov    0x805038,%eax
  802f43:	40                   	inc    %eax
  802f44:	a3 38 50 80 00       	mov    %eax,0x805038
  802f49:	eb 6e                	jmp    802fb9 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802f4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4f:	74 06                	je     802f57 <alloc_block_BF+0x341>
  802f51:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f55:	75 17                	jne    802f6e <alloc_block_BF+0x358>
  802f57:	83 ec 04             	sub    $0x4,%esp
  802f5a:	68 64 4c 80 00       	push   $0x804c64
  802f5f:	68 4f 01 00 00       	push   $0x14f
  802f64:	68 f1 4b 80 00       	push   $0x804bf1
  802f69:	e8 a7 d8 ff ff       	call   800815 <_panic>
  802f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f71:	8b 10                	mov    (%eax),%edx
  802f73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f76:	89 10                	mov    %edx,(%eax)
  802f78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	85 c0                	test   %eax,%eax
  802f7f:	74 0b                	je     802f8c <alloc_block_BF+0x376>
  802f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f84:	8b 00                	mov    (%eax),%eax
  802f86:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f89:	89 50 04             	mov    %edx,0x4(%eax)
  802f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f92:	89 10                	mov    %edx,(%eax)
  802f94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f9a:	89 50 04             	mov    %edx,0x4(%eax)
  802f9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa0:	8b 00                	mov    (%eax),%eax
  802fa2:	85 c0                	test   %eax,%eax
  802fa4:	75 08                	jne    802fae <alloc_block_BF+0x398>
  802fa6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa9:	a3 30 50 80 00       	mov    %eax,0x805030
  802fae:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb3:	40                   	inc    %eax
  802fb4:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802fb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fbd:	75 17                	jne    802fd6 <alloc_block_BF+0x3c0>
  802fbf:	83 ec 04             	sub    $0x4,%esp
  802fc2:	68 d3 4b 80 00       	push   $0x804bd3
  802fc7:	68 51 01 00 00       	push   $0x151
  802fcc:	68 f1 4b 80 00       	push   $0x804bf1
  802fd1:	e8 3f d8 ff ff       	call   800815 <_panic>
  802fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd9:	8b 00                	mov    (%eax),%eax
  802fdb:	85 c0                	test   %eax,%eax
  802fdd:	74 10                	je     802fef <alloc_block_BF+0x3d9>
  802fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe7:	8b 52 04             	mov    0x4(%edx),%edx
  802fea:	89 50 04             	mov    %edx,0x4(%eax)
  802fed:	eb 0b                	jmp    802ffa <alloc_block_BF+0x3e4>
  802fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff2:	8b 40 04             	mov    0x4(%eax),%eax
  802ff5:	a3 30 50 80 00       	mov    %eax,0x805030
  802ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffd:	8b 40 04             	mov    0x4(%eax),%eax
  803000:	85 c0                	test   %eax,%eax
  803002:	74 0f                	je     803013 <alloc_block_BF+0x3fd>
  803004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803007:	8b 40 04             	mov    0x4(%eax),%eax
  80300a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80300d:	8b 12                	mov    (%edx),%edx
  80300f:	89 10                	mov    %edx,(%eax)
  803011:	eb 0a                	jmp    80301d <alloc_block_BF+0x407>
  803013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80301d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803020:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803029:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803030:	a1 38 50 80 00       	mov    0x805038,%eax
  803035:	48                   	dec    %eax
  803036:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80303b:	83 ec 04             	sub    $0x4,%esp
  80303e:	6a 00                	push   $0x0
  803040:	ff 75 d0             	pushl  -0x30(%ebp)
  803043:	ff 75 cc             	pushl  -0x34(%ebp)
  803046:	e8 e0 f6 ff ff       	call   80272b <set_block_data>
  80304b:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	e9 a3 01 00 00       	jmp    8031f9 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803056:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80305a:	0f 85 9d 00 00 00    	jne    8030fd <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803060:	83 ec 04             	sub    $0x4,%esp
  803063:	6a 01                	push   $0x1
  803065:	ff 75 ec             	pushl  -0x14(%ebp)
  803068:	ff 75 f0             	pushl  -0x10(%ebp)
  80306b:	e8 bb f6 ff ff       	call   80272b <set_block_data>
  803070:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803073:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803077:	75 17                	jne    803090 <alloc_block_BF+0x47a>
  803079:	83 ec 04             	sub    $0x4,%esp
  80307c:	68 d3 4b 80 00       	push   $0x804bd3
  803081:	68 58 01 00 00       	push   $0x158
  803086:	68 f1 4b 80 00       	push   $0x804bf1
  80308b:	e8 85 d7 ff ff       	call   800815 <_panic>
  803090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	74 10                	je     8030a9 <alloc_block_BF+0x493>
  803099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a1:	8b 52 04             	mov    0x4(%edx),%edx
  8030a4:	89 50 04             	mov    %edx,0x4(%eax)
  8030a7:	eb 0b                	jmp    8030b4 <alloc_block_BF+0x49e>
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	8b 40 04             	mov    0x4(%eax),%eax
  8030af:	a3 30 50 80 00       	mov    %eax,0x805030
  8030b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ba:	85 c0                	test   %eax,%eax
  8030bc:	74 0f                	je     8030cd <alloc_block_BF+0x4b7>
  8030be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c1:	8b 40 04             	mov    0x4(%eax),%eax
  8030c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c7:	8b 12                	mov    (%edx),%edx
  8030c9:	89 10                	mov    %edx,(%eax)
  8030cb:	eb 0a                	jmp    8030d7 <alloc_block_BF+0x4c1>
  8030cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d0:	8b 00                	mov    (%eax),%eax
  8030d2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ea:	a1 38 50 80 00       	mov    0x805038,%eax
  8030ef:	48                   	dec    %eax
  8030f0:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8030f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f8:	e9 fc 00 00 00       	jmp    8031f9 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	83 c0 08             	add    $0x8,%eax
  803103:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803106:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80310d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803110:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803113:	01 d0                	add    %edx,%eax
  803115:	48                   	dec    %eax
  803116:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803119:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80311c:	ba 00 00 00 00       	mov    $0x0,%edx
  803121:	f7 75 c4             	divl   -0x3c(%ebp)
  803124:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803127:	29 d0                	sub    %edx,%eax
  803129:	c1 e8 0c             	shr    $0xc,%eax
  80312c:	83 ec 0c             	sub    $0xc,%esp
  80312f:	50                   	push   %eax
  803130:	e8 37 e7 ff ff       	call   80186c <sbrk>
  803135:	83 c4 10             	add    $0x10,%esp
  803138:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80313b:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80313f:	75 0a                	jne    80314b <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803141:	b8 00 00 00 00       	mov    $0x0,%eax
  803146:	e9 ae 00 00 00       	jmp    8031f9 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80314b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803152:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803155:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803158:	01 d0                	add    %edx,%eax
  80315a:	48                   	dec    %eax
  80315b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80315e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803161:	ba 00 00 00 00       	mov    $0x0,%edx
  803166:	f7 75 b8             	divl   -0x48(%ebp)
  803169:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80316c:	29 d0                	sub    %edx,%eax
  80316e:	8d 50 fc             	lea    -0x4(%eax),%edx
  803171:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803174:	01 d0                	add    %edx,%eax
  803176:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  80317b:	a1 40 50 80 00       	mov    0x805040,%eax
  803180:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803186:	83 ec 0c             	sub    $0xc,%esp
  803189:	68 98 4c 80 00       	push   $0x804c98
  80318e:	e8 3f d9 ff ff       	call   800ad2 <cprintf>
  803193:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803196:	83 ec 08             	sub    $0x8,%esp
  803199:	ff 75 bc             	pushl  -0x44(%ebp)
  80319c:	68 9d 4c 80 00       	push   $0x804c9d
  8031a1:	e8 2c d9 ff ff       	call   800ad2 <cprintf>
  8031a6:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8031a9:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8031b0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031b6:	01 d0                	add    %edx,%eax
  8031b8:	48                   	dec    %eax
  8031b9:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8031bc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8031bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8031c4:	f7 75 b0             	divl   -0x50(%ebp)
  8031c7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8031ca:	29 d0                	sub    %edx,%eax
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	6a 01                	push   $0x1
  8031d1:	50                   	push   %eax
  8031d2:	ff 75 bc             	pushl  -0x44(%ebp)
  8031d5:	e8 51 f5 ff ff       	call   80272b <set_block_data>
  8031da:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8031dd:	83 ec 0c             	sub    $0xc,%esp
  8031e0:	ff 75 bc             	pushl  -0x44(%ebp)
  8031e3:	e8 36 04 00 00       	call   80361e <free_block>
  8031e8:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8031eb:	83 ec 0c             	sub    $0xc,%esp
  8031ee:	ff 75 08             	pushl  0x8(%ebp)
  8031f1:	e8 20 fa ff ff       	call   802c16 <alloc_block_BF>
  8031f6:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8031f9:	c9                   	leave  
  8031fa:	c3                   	ret    

008031fb <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8031fb:	55                   	push   %ebp
  8031fc:	89 e5                	mov    %esp,%ebp
  8031fe:	53                   	push   %ebx
  8031ff:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803202:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803209:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803210:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803214:	74 1e                	je     803234 <merging+0x39>
  803216:	ff 75 08             	pushl  0x8(%ebp)
  803219:	e8 bc f1 ff ff       	call   8023da <get_block_size>
  80321e:	83 c4 04             	add    $0x4,%esp
  803221:	89 c2                	mov    %eax,%edx
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	01 d0                	add    %edx,%eax
  803228:	3b 45 10             	cmp    0x10(%ebp),%eax
  80322b:	75 07                	jne    803234 <merging+0x39>
		prev_is_free = 1;
  80322d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803234:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803238:	74 1e                	je     803258 <merging+0x5d>
  80323a:	ff 75 10             	pushl  0x10(%ebp)
  80323d:	e8 98 f1 ff ff       	call   8023da <get_block_size>
  803242:	83 c4 04             	add    $0x4,%esp
  803245:	89 c2                	mov    %eax,%edx
  803247:	8b 45 10             	mov    0x10(%ebp),%eax
  80324a:	01 d0                	add    %edx,%eax
  80324c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80324f:	75 07                	jne    803258 <merging+0x5d>
		next_is_free = 1;
  803251:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803258:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325c:	0f 84 cc 00 00 00    	je     80332e <merging+0x133>
  803262:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803266:	0f 84 c2 00 00 00    	je     80332e <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80326c:	ff 75 08             	pushl  0x8(%ebp)
  80326f:	e8 66 f1 ff ff       	call   8023da <get_block_size>
  803274:	83 c4 04             	add    $0x4,%esp
  803277:	89 c3                	mov    %eax,%ebx
  803279:	ff 75 10             	pushl  0x10(%ebp)
  80327c:	e8 59 f1 ff ff       	call   8023da <get_block_size>
  803281:	83 c4 04             	add    $0x4,%esp
  803284:	01 c3                	add    %eax,%ebx
  803286:	ff 75 0c             	pushl  0xc(%ebp)
  803289:	e8 4c f1 ff ff       	call   8023da <get_block_size>
  80328e:	83 c4 04             	add    $0x4,%esp
  803291:	01 d8                	add    %ebx,%eax
  803293:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803296:	6a 00                	push   $0x0
  803298:	ff 75 ec             	pushl  -0x14(%ebp)
  80329b:	ff 75 08             	pushl  0x8(%ebp)
  80329e:	e8 88 f4 ff ff       	call   80272b <set_block_data>
  8032a3:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8032a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032aa:	75 17                	jne    8032c3 <merging+0xc8>
  8032ac:	83 ec 04             	sub    $0x4,%esp
  8032af:	68 d3 4b 80 00       	push   $0x804bd3
  8032b4:	68 7d 01 00 00       	push   $0x17d
  8032b9:	68 f1 4b 80 00       	push   $0x804bf1
  8032be:	e8 52 d5 ff ff       	call   800815 <_panic>
  8032c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c6:	8b 00                	mov    (%eax),%eax
  8032c8:	85 c0                	test   %eax,%eax
  8032ca:	74 10                	je     8032dc <merging+0xe1>
  8032cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032cf:	8b 00                	mov    (%eax),%eax
  8032d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032d4:	8b 52 04             	mov    0x4(%edx),%edx
  8032d7:	89 50 04             	mov    %edx,0x4(%eax)
  8032da:	eb 0b                	jmp    8032e7 <merging+0xec>
  8032dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032df:	8b 40 04             	mov    0x4(%eax),%eax
  8032e2:	a3 30 50 80 00       	mov    %eax,0x805030
  8032e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ea:	8b 40 04             	mov    0x4(%eax),%eax
  8032ed:	85 c0                	test   %eax,%eax
  8032ef:	74 0f                	je     803300 <merging+0x105>
  8032f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f4:	8b 40 04             	mov    0x4(%eax),%eax
  8032f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032fa:	8b 12                	mov    (%edx),%edx
  8032fc:	89 10                	mov    %edx,(%eax)
  8032fe:	eb 0a                	jmp    80330a <merging+0x10f>
  803300:	8b 45 0c             	mov    0xc(%ebp),%eax
  803303:	8b 00                	mov    (%eax),%eax
  803305:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80330a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803313:	8b 45 0c             	mov    0xc(%ebp),%eax
  803316:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331d:	a1 38 50 80 00       	mov    0x805038,%eax
  803322:	48                   	dec    %eax
  803323:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803328:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803329:	e9 ea 02 00 00       	jmp    803618 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80332e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803332:	74 3b                	je     80336f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803334:	83 ec 0c             	sub    $0xc,%esp
  803337:	ff 75 08             	pushl  0x8(%ebp)
  80333a:	e8 9b f0 ff ff       	call   8023da <get_block_size>
  80333f:	83 c4 10             	add    $0x10,%esp
  803342:	89 c3                	mov    %eax,%ebx
  803344:	83 ec 0c             	sub    $0xc,%esp
  803347:	ff 75 10             	pushl  0x10(%ebp)
  80334a:	e8 8b f0 ff ff       	call   8023da <get_block_size>
  80334f:	83 c4 10             	add    $0x10,%esp
  803352:	01 d8                	add    %ebx,%eax
  803354:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803357:	83 ec 04             	sub    $0x4,%esp
  80335a:	6a 00                	push   $0x0
  80335c:	ff 75 e8             	pushl  -0x18(%ebp)
  80335f:	ff 75 08             	pushl  0x8(%ebp)
  803362:	e8 c4 f3 ff ff       	call   80272b <set_block_data>
  803367:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80336a:	e9 a9 02 00 00       	jmp    803618 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80336f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803373:	0f 84 2d 01 00 00    	je     8034a6 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803379:	83 ec 0c             	sub    $0xc,%esp
  80337c:	ff 75 10             	pushl  0x10(%ebp)
  80337f:	e8 56 f0 ff ff       	call   8023da <get_block_size>
  803384:	83 c4 10             	add    $0x10,%esp
  803387:	89 c3                	mov    %eax,%ebx
  803389:	83 ec 0c             	sub    $0xc,%esp
  80338c:	ff 75 0c             	pushl  0xc(%ebp)
  80338f:	e8 46 f0 ff ff       	call   8023da <get_block_size>
  803394:	83 c4 10             	add    $0x10,%esp
  803397:	01 d8                	add    %ebx,%eax
  803399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80339c:	83 ec 04             	sub    $0x4,%esp
  80339f:	6a 00                	push   $0x0
  8033a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033a4:	ff 75 10             	pushl  0x10(%ebp)
  8033a7:	e8 7f f3 ff ff       	call   80272b <set_block_data>
  8033ac:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8033af:	8b 45 10             	mov    0x10(%ebp),%eax
  8033b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8033b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033b9:	74 06                	je     8033c1 <merging+0x1c6>
  8033bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033bf:	75 17                	jne    8033d8 <merging+0x1dd>
  8033c1:	83 ec 04             	sub    $0x4,%esp
  8033c4:	68 ac 4c 80 00       	push   $0x804cac
  8033c9:	68 8d 01 00 00       	push   $0x18d
  8033ce:	68 f1 4b 80 00       	push   $0x804bf1
  8033d3:	e8 3d d4 ff ff       	call   800815 <_panic>
  8033d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033db:	8b 50 04             	mov    0x4(%eax),%edx
  8033de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e1:	89 50 04             	mov    %edx,0x4(%eax)
  8033e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033ea:	89 10                	mov    %edx,(%eax)
  8033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ef:	8b 40 04             	mov    0x4(%eax),%eax
  8033f2:	85 c0                	test   %eax,%eax
  8033f4:	74 0d                	je     803403 <merging+0x208>
  8033f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f9:	8b 40 04             	mov    0x4(%eax),%eax
  8033fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ff:	89 10                	mov    %edx,(%eax)
  803401:	eb 08                	jmp    80340b <merging+0x210>
  803403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803406:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80340b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803411:	89 50 04             	mov    %edx,0x4(%eax)
  803414:	a1 38 50 80 00       	mov    0x805038,%eax
  803419:	40                   	inc    %eax
  80341a:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80341f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803423:	75 17                	jne    80343c <merging+0x241>
  803425:	83 ec 04             	sub    $0x4,%esp
  803428:	68 d3 4b 80 00       	push   $0x804bd3
  80342d:	68 8e 01 00 00       	push   $0x18e
  803432:	68 f1 4b 80 00       	push   $0x804bf1
  803437:	e8 d9 d3 ff ff       	call   800815 <_panic>
  80343c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343f:	8b 00                	mov    (%eax),%eax
  803441:	85 c0                	test   %eax,%eax
  803443:	74 10                	je     803455 <merging+0x25a>
  803445:	8b 45 0c             	mov    0xc(%ebp),%eax
  803448:	8b 00                	mov    (%eax),%eax
  80344a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80344d:	8b 52 04             	mov    0x4(%edx),%edx
  803450:	89 50 04             	mov    %edx,0x4(%eax)
  803453:	eb 0b                	jmp    803460 <merging+0x265>
  803455:	8b 45 0c             	mov    0xc(%ebp),%eax
  803458:	8b 40 04             	mov    0x4(%eax),%eax
  80345b:	a3 30 50 80 00       	mov    %eax,0x805030
  803460:	8b 45 0c             	mov    0xc(%ebp),%eax
  803463:	8b 40 04             	mov    0x4(%eax),%eax
  803466:	85 c0                	test   %eax,%eax
  803468:	74 0f                	je     803479 <merging+0x27e>
  80346a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346d:	8b 40 04             	mov    0x4(%eax),%eax
  803470:	8b 55 0c             	mov    0xc(%ebp),%edx
  803473:	8b 12                	mov    (%edx),%edx
  803475:	89 10                	mov    %edx,(%eax)
  803477:	eb 0a                	jmp    803483 <merging+0x288>
  803479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80347c:	8b 00                	mov    (%eax),%eax
  80347e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803483:	8b 45 0c             	mov    0xc(%ebp),%eax
  803486:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80348c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803496:	a1 38 50 80 00       	mov    0x805038,%eax
  80349b:	48                   	dec    %eax
  80349c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034a1:	e9 72 01 00 00       	jmp    803618 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8034a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8034a9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8034ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b0:	74 79                	je     80352b <merging+0x330>
  8034b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034b6:	74 73                	je     80352b <merging+0x330>
  8034b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034bc:	74 06                	je     8034c4 <merging+0x2c9>
  8034be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034c2:	75 17                	jne    8034db <merging+0x2e0>
  8034c4:	83 ec 04             	sub    $0x4,%esp
  8034c7:	68 64 4c 80 00       	push   $0x804c64
  8034cc:	68 94 01 00 00       	push   $0x194
  8034d1:	68 f1 4b 80 00       	push   $0x804bf1
  8034d6:	e8 3a d3 ff ff       	call   800815 <_panic>
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	8b 10                	mov    (%eax),%edx
  8034e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034e3:	89 10                	mov    %edx,(%eax)
  8034e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	74 0b                	je     8034f9 <merging+0x2fe>
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	8b 00                	mov    (%eax),%eax
  8034f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034f6:	89 50 04             	mov    %edx,0x4(%eax)
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034ff:	89 10                	mov    %edx,(%eax)
  803501:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803504:	8b 55 08             	mov    0x8(%ebp),%edx
  803507:	89 50 04             	mov    %edx,0x4(%eax)
  80350a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80350d:	8b 00                	mov    (%eax),%eax
  80350f:	85 c0                	test   %eax,%eax
  803511:	75 08                	jne    80351b <merging+0x320>
  803513:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803516:	a3 30 50 80 00       	mov    %eax,0x805030
  80351b:	a1 38 50 80 00       	mov    0x805038,%eax
  803520:	40                   	inc    %eax
  803521:	a3 38 50 80 00       	mov    %eax,0x805038
  803526:	e9 ce 00 00 00       	jmp    8035f9 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80352b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80352f:	74 65                	je     803596 <merging+0x39b>
  803531:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803535:	75 17                	jne    80354e <merging+0x353>
  803537:	83 ec 04             	sub    $0x4,%esp
  80353a:	68 40 4c 80 00       	push   $0x804c40
  80353f:	68 95 01 00 00       	push   $0x195
  803544:	68 f1 4b 80 00       	push   $0x804bf1
  803549:	e8 c7 d2 ff ff       	call   800815 <_panic>
  80354e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803554:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803557:	89 50 04             	mov    %edx,0x4(%eax)
  80355a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80355d:	8b 40 04             	mov    0x4(%eax),%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 0c                	je     803570 <merging+0x375>
  803564:	a1 30 50 80 00       	mov    0x805030,%eax
  803569:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80356c:	89 10                	mov    %edx,(%eax)
  80356e:	eb 08                	jmp    803578 <merging+0x37d>
  803570:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803573:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803578:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80357b:	a3 30 50 80 00       	mov    %eax,0x805030
  803580:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803583:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803589:	a1 38 50 80 00       	mov    0x805038,%eax
  80358e:	40                   	inc    %eax
  80358f:	a3 38 50 80 00       	mov    %eax,0x805038
  803594:	eb 63                	jmp    8035f9 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803596:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80359a:	75 17                	jne    8035b3 <merging+0x3b8>
  80359c:	83 ec 04             	sub    $0x4,%esp
  80359f:	68 0c 4c 80 00       	push   $0x804c0c
  8035a4:	68 98 01 00 00       	push   $0x198
  8035a9:	68 f1 4b 80 00       	push   $0x804bf1
  8035ae:	e8 62 d2 ff ff       	call   800815 <_panic>
  8035b3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035bc:	89 10                	mov    %edx,(%eax)
  8035be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c1:	8b 00                	mov    (%eax),%eax
  8035c3:	85 c0                	test   %eax,%eax
  8035c5:	74 0d                	je     8035d4 <merging+0x3d9>
  8035c7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035cf:	89 50 04             	mov    %edx,0x4(%eax)
  8035d2:	eb 08                	jmp    8035dc <merging+0x3e1>
  8035d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8035dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035df:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f3:	40                   	inc    %eax
  8035f4:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8035f9:	83 ec 0c             	sub    $0xc,%esp
  8035fc:	ff 75 10             	pushl  0x10(%ebp)
  8035ff:	e8 d6 ed ff ff       	call   8023da <get_block_size>
  803604:	83 c4 10             	add    $0x10,%esp
  803607:	83 ec 04             	sub    $0x4,%esp
  80360a:	6a 00                	push   $0x0
  80360c:	50                   	push   %eax
  80360d:	ff 75 10             	pushl  0x10(%ebp)
  803610:	e8 16 f1 ff ff       	call   80272b <set_block_data>
  803615:	83 c4 10             	add    $0x10,%esp
	}
}
  803618:	90                   	nop
  803619:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80361c:	c9                   	leave  
  80361d:	c3                   	ret    

0080361e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80361e:	55                   	push   %ebp
  80361f:	89 e5                	mov    %esp,%ebp
  803621:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803624:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803629:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80362c:	a1 30 50 80 00       	mov    0x805030,%eax
  803631:	3b 45 08             	cmp    0x8(%ebp),%eax
  803634:	73 1b                	jae    803651 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803636:	a1 30 50 80 00       	mov    0x805030,%eax
  80363b:	83 ec 04             	sub    $0x4,%esp
  80363e:	ff 75 08             	pushl  0x8(%ebp)
  803641:	6a 00                	push   $0x0
  803643:	50                   	push   %eax
  803644:	e8 b2 fb ff ff       	call   8031fb <merging>
  803649:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80364c:	e9 8b 00 00 00       	jmp    8036dc <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803651:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803656:	3b 45 08             	cmp    0x8(%ebp),%eax
  803659:	76 18                	jbe    803673 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80365b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803660:	83 ec 04             	sub    $0x4,%esp
  803663:	ff 75 08             	pushl  0x8(%ebp)
  803666:	50                   	push   %eax
  803667:	6a 00                	push   $0x0
  803669:	e8 8d fb ff ff       	call   8031fb <merging>
  80366e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803671:	eb 69                	jmp    8036dc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803673:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803678:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80367b:	eb 39                	jmp    8036b6 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80367d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803680:	3b 45 08             	cmp    0x8(%ebp),%eax
  803683:	73 29                	jae    8036ae <free_block+0x90>
  803685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803688:	8b 00                	mov    (%eax),%eax
  80368a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80368d:	76 1f                	jbe    8036ae <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80368f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803692:	8b 00                	mov    (%eax),%eax
  803694:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803697:	83 ec 04             	sub    $0x4,%esp
  80369a:	ff 75 08             	pushl  0x8(%ebp)
  80369d:	ff 75 f0             	pushl  -0x10(%ebp)
  8036a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8036a3:	e8 53 fb ff ff       	call   8031fb <merging>
  8036a8:	83 c4 10             	add    $0x10,%esp
			break;
  8036ab:	90                   	nop
		}
	}
}
  8036ac:	eb 2e                	jmp    8036dc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8036ae:	a1 34 50 80 00       	mov    0x805034,%eax
  8036b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036ba:	74 07                	je     8036c3 <free_block+0xa5>
  8036bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bf:	8b 00                	mov    (%eax),%eax
  8036c1:	eb 05                	jmp    8036c8 <free_block+0xaa>
  8036c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c8:	a3 34 50 80 00       	mov    %eax,0x805034
  8036cd:	a1 34 50 80 00       	mov    0x805034,%eax
  8036d2:	85 c0                	test   %eax,%eax
  8036d4:	75 a7                	jne    80367d <free_block+0x5f>
  8036d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036da:	75 a1                	jne    80367d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036dc:	90                   	nop
  8036dd:	c9                   	leave  
  8036de:	c3                   	ret    

008036df <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8036df:	55                   	push   %ebp
  8036e0:	89 e5                	mov    %esp,%ebp
  8036e2:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8036e5:	ff 75 08             	pushl  0x8(%ebp)
  8036e8:	e8 ed ec ff ff       	call   8023da <get_block_size>
  8036ed:	83 c4 04             	add    $0x4,%esp
  8036f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8036f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8036fa:	eb 17                	jmp    803713 <copy_data+0x34>
  8036fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8036ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803702:	01 c2                	add    %eax,%edx
  803704:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	01 c8                	add    %ecx,%eax
  80370c:	8a 00                	mov    (%eax),%al
  80370e:	88 02                	mov    %al,(%edx)
  803710:	ff 45 fc             	incl   -0x4(%ebp)
  803713:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803719:	72 e1                	jb     8036fc <copy_data+0x1d>
}
  80371b:	90                   	nop
  80371c:	c9                   	leave  
  80371d:	c3                   	ret    

0080371e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80371e:	55                   	push   %ebp
  80371f:	89 e5                	mov    %esp,%ebp
  803721:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803724:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803728:	75 23                	jne    80374d <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80372a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80372e:	74 13                	je     803743 <realloc_block_FF+0x25>
  803730:	83 ec 0c             	sub    $0xc,%esp
  803733:	ff 75 0c             	pushl  0xc(%ebp)
  803736:	e8 1f f0 ff ff       	call   80275a <alloc_block_FF>
  80373b:	83 c4 10             	add    $0x10,%esp
  80373e:	e9 f4 06 00 00       	jmp    803e37 <realloc_block_FF+0x719>
		return NULL;
  803743:	b8 00 00 00 00       	mov    $0x0,%eax
  803748:	e9 ea 06 00 00       	jmp    803e37 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80374d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803751:	75 18                	jne    80376b <realloc_block_FF+0x4d>
	{
		free_block(va);
  803753:	83 ec 0c             	sub    $0xc,%esp
  803756:	ff 75 08             	pushl  0x8(%ebp)
  803759:	e8 c0 fe ff ff       	call   80361e <free_block>
  80375e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803761:	b8 00 00 00 00       	mov    $0x0,%eax
  803766:	e9 cc 06 00 00       	jmp    803e37 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80376b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80376f:	77 07                	ja     803778 <realloc_block_FF+0x5a>
  803771:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80377b:	83 e0 01             	and    $0x1,%eax
  80377e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803781:	8b 45 0c             	mov    0xc(%ebp),%eax
  803784:	83 c0 08             	add    $0x8,%eax
  803787:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80378a:	83 ec 0c             	sub    $0xc,%esp
  80378d:	ff 75 08             	pushl  0x8(%ebp)
  803790:	e8 45 ec ff ff       	call   8023da <get_block_size>
  803795:	83 c4 10             	add    $0x10,%esp
  803798:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80379b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80379e:	83 e8 08             	sub    $0x8,%eax
  8037a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8037a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a7:	83 e8 04             	sub    $0x4,%eax
  8037aa:	8b 00                	mov    (%eax),%eax
  8037ac:	83 e0 fe             	and    $0xfffffffe,%eax
  8037af:	89 c2                	mov    %eax,%edx
  8037b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b4:	01 d0                	add    %edx,%eax
  8037b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8037b9:	83 ec 0c             	sub    $0xc,%esp
  8037bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037bf:	e8 16 ec ff ff       	call   8023da <get_block_size>
  8037c4:	83 c4 10             	add    $0x10,%esp
  8037c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8037ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037cd:	83 e8 08             	sub    $0x8,%eax
  8037d0:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8037d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037d9:	75 08                	jne    8037e3 <realloc_block_FF+0xc5>
	{
		 return va;
  8037db:	8b 45 08             	mov    0x8(%ebp),%eax
  8037de:	e9 54 06 00 00       	jmp    803e37 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8037e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037e9:	0f 83 e5 03 00 00    	jae    803bd4 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8037ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f2:	2b 45 0c             	sub    0xc(%ebp),%eax
  8037f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8037f8:	83 ec 0c             	sub    $0xc,%esp
  8037fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037fe:	e8 f0 eb ff ff       	call   8023f3 <is_free_block>
  803803:	83 c4 10             	add    $0x10,%esp
  803806:	84 c0                	test   %al,%al
  803808:	0f 84 3b 01 00 00    	je     803949 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80380e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803811:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803814:	01 d0                	add    %edx,%eax
  803816:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803819:	83 ec 04             	sub    $0x4,%esp
  80381c:	6a 01                	push   $0x1
  80381e:	ff 75 f0             	pushl  -0x10(%ebp)
  803821:	ff 75 08             	pushl  0x8(%ebp)
  803824:	e8 02 ef ff ff       	call   80272b <set_block_data>
  803829:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80382c:	8b 45 08             	mov    0x8(%ebp),%eax
  80382f:	83 e8 04             	sub    $0x4,%eax
  803832:	8b 00                	mov    (%eax),%eax
  803834:	83 e0 fe             	and    $0xfffffffe,%eax
  803837:	89 c2                	mov    %eax,%edx
  803839:	8b 45 08             	mov    0x8(%ebp),%eax
  80383c:	01 d0                	add    %edx,%eax
  80383e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803841:	83 ec 04             	sub    $0x4,%esp
  803844:	6a 00                	push   $0x0
  803846:	ff 75 cc             	pushl  -0x34(%ebp)
  803849:	ff 75 c8             	pushl  -0x38(%ebp)
  80384c:	e8 da ee ff ff       	call   80272b <set_block_data>
  803851:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803854:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803858:	74 06                	je     803860 <realloc_block_FF+0x142>
  80385a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80385e:	75 17                	jne    803877 <realloc_block_FF+0x159>
  803860:	83 ec 04             	sub    $0x4,%esp
  803863:	68 64 4c 80 00       	push   $0x804c64
  803868:	68 f6 01 00 00       	push   $0x1f6
  80386d:	68 f1 4b 80 00       	push   $0x804bf1
  803872:	e8 9e cf ff ff       	call   800815 <_panic>
  803877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387a:	8b 10                	mov    (%eax),%edx
  80387c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80387f:	89 10                	mov    %edx,(%eax)
  803881:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803884:	8b 00                	mov    (%eax),%eax
  803886:	85 c0                	test   %eax,%eax
  803888:	74 0b                	je     803895 <realloc_block_FF+0x177>
  80388a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388d:	8b 00                	mov    (%eax),%eax
  80388f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803892:	89 50 04             	mov    %edx,0x4(%eax)
  803895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803898:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80389b:	89 10                	mov    %edx,(%eax)
  80389d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038a3:	89 50 04             	mov    %edx,0x4(%eax)
  8038a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038a9:	8b 00                	mov    (%eax),%eax
  8038ab:	85 c0                	test   %eax,%eax
  8038ad:	75 08                	jne    8038b7 <realloc_block_FF+0x199>
  8038af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8038b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8038bc:	40                   	inc    %eax
  8038bd:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038c6:	75 17                	jne    8038df <realloc_block_FF+0x1c1>
  8038c8:	83 ec 04             	sub    $0x4,%esp
  8038cb:	68 d3 4b 80 00       	push   $0x804bd3
  8038d0:	68 f7 01 00 00       	push   $0x1f7
  8038d5:	68 f1 4b 80 00       	push   $0x804bf1
  8038da:	e8 36 cf ff ff       	call   800815 <_panic>
  8038df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e2:	8b 00                	mov    (%eax),%eax
  8038e4:	85 c0                	test   %eax,%eax
  8038e6:	74 10                	je     8038f8 <realloc_block_FF+0x1da>
  8038e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038eb:	8b 00                	mov    (%eax),%eax
  8038ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f0:	8b 52 04             	mov    0x4(%edx),%edx
  8038f3:	89 50 04             	mov    %edx,0x4(%eax)
  8038f6:	eb 0b                	jmp    803903 <realloc_block_FF+0x1e5>
  8038f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fb:	8b 40 04             	mov    0x4(%eax),%eax
  8038fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803906:	8b 40 04             	mov    0x4(%eax),%eax
  803909:	85 c0                	test   %eax,%eax
  80390b:	74 0f                	je     80391c <realloc_block_FF+0x1fe>
  80390d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803910:	8b 40 04             	mov    0x4(%eax),%eax
  803913:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803916:	8b 12                	mov    (%edx),%edx
  803918:	89 10                	mov    %edx,(%eax)
  80391a:	eb 0a                	jmp    803926 <realloc_block_FF+0x208>
  80391c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391f:	8b 00                	mov    (%eax),%eax
  803921:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803926:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803929:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80392f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803932:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803939:	a1 38 50 80 00       	mov    0x805038,%eax
  80393e:	48                   	dec    %eax
  80393f:	a3 38 50 80 00       	mov    %eax,0x805038
  803944:	e9 83 02 00 00       	jmp    803bcc <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803949:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80394d:	0f 86 69 02 00 00    	jbe    803bbc <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803953:	83 ec 04             	sub    $0x4,%esp
  803956:	6a 01                	push   $0x1
  803958:	ff 75 f0             	pushl  -0x10(%ebp)
  80395b:	ff 75 08             	pushl  0x8(%ebp)
  80395e:	e8 c8 ed ff ff       	call   80272b <set_block_data>
  803963:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803966:	8b 45 08             	mov    0x8(%ebp),%eax
  803969:	83 e8 04             	sub    $0x4,%eax
  80396c:	8b 00                	mov    (%eax),%eax
  80396e:	83 e0 fe             	and    $0xfffffffe,%eax
  803971:	89 c2                	mov    %eax,%edx
  803973:	8b 45 08             	mov    0x8(%ebp),%eax
  803976:	01 d0                	add    %edx,%eax
  803978:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80397b:	a1 38 50 80 00       	mov    0x805038,%eax
  803980:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803983:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803987:	75 68                	jne    8039f1 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803989:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80398d:	75 17                	jne    8039a6 <realloc_block_FF+0x288>
  80398f:	83 ec 04             	sub    $0x4,%esp
  803992:	68 0c 4c 80 00       	push   $0x804c0c
  803997:	68 06 02 00 00       	push   $0x206
  80399c:	68 f1 4b 80 00       	push   $0x804bf1
  8039a1:	e8 6f ce ff ff       	call   800815 <_panic>
  8039a6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8039ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039af:	89 10                	mov    %edx,(%eax)
  8039b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039b4:	8b 00                	mov    (%eax),%eax
  8039b6:	85 c0                	test   %eax,%eax
  8039b8:	74 0d                	je     8039c7 <realloc_block_FF+0x2a9>
  8039ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039c2:	89 50 04             	mov    %edx,0x4(%eax)
  8039c5:	eb 08                	jmp    8039cf <realloc_block_FF+0x2b1>
  8039c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8039cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039d2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e1:	a1 38 50 80 00       	mov    0x805038,%eax
  8039e6:	40                   	inc    %eax
  8039e7:	a3 38 50 80 00       	mov    %eax,0x805038
  8039ec:	e9 b0 01 00 00       	jmp    803ba1 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8039f1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039f6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039f9:	76 68                	jbe    803a63 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039fb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039ff:	75 17                	jne    803a18 <realloc_block_FF+0x2fa>
  803a01:	83 ec 04             	sub    $0x4,%esp
  803a04:	68 0c 4c 80 00       	push   $0x804c0c
  803a09:	68 0b 02 00 00       	push   $0x20b
  803a0e:	68 f1 4b 80 00       	push   $0x804bf1
  803a13:	e8 fd cd ff ff       	call   800815 <_panic>
  803a18:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803a1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a21:	89 10                	mov    %edx,(%eax)
  803a23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a26:	8b 00                	mov    (%eax),%eax
  803a28:	85 c0                	test   %eax,%eax
  803a2a:	74 0d                	je     803a39 <realloc_block_FF+0x31b>
  803a2c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a34:	89 50 04             	mov    %edx,0x4(%eax)
  803a37:	eb 08                	jmp    803a41 <realloc_block_FF+0x323>
  803a39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a3c:	a3 30 50 80 00       	mov    %eax,0x805030
  803a41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a44:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a53:	a1 38 50 80 00       	mov    0x805038,%eax
  803a58:	40                   	inc    %eax
  803a59:	a3 38 50 80 00       	mov    %eax,0x805038
  803a5e:	e9 3e 01 00 00       	jmp    803ba1 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803a63:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a68:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a6b:	73 68                	jae    803ad5 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a6d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a71:	75 17                	jne    803a8a <realloc_block_FF+0x36c>
  803a73:	83 ec 04             	sub    $0x4,%esp
  803a76:	68 40 4c 80 00       	push   $0x804c40
  803a7b:	68 10 02 00 00       	push   $0x210
  803a80:	68 f1 4b 80 00       	push   $0x804bf1
  803a85:	e8 8b cd ff ff       	call   800815 <_panic>
  803a8a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a93:	89 50 04             	mov    %edx,0x4(%eax)
  803a96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a99:	8b 40 04             	mov    0x4(%eax),%eax
  803a9c:	85 c0                	test   %eax,%eax
  803a9e:	74 0c                	je     803aac <realloc_block_FF+0x38e>
  803aa0:	a1 30 50 80 00       	mov    0x805030,%eax
  803aa5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803aa8:	89 10                	mov    %edx,(%eax)
  803aaa:	eb 08                	jmp    803ab4 <realloc_block_FF+0x396>
  803aac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aaf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ab4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab7:	a3 30 50 80 00       	mov    %eax,0x805030
  803abc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803abf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ac5:	a1 38 50 80 00       	mov    0x805038,%eax
  803aca:	40                   	inc    %eax
  803acb:	a3 38 50 80 00       	mov    %eax,0x805038
  803ad0:	e9 cc 00 00 00       	jmp    803ba1 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803ad5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803adc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ae4:	e9 8a 00 00 00       	jmp    803b73 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aec:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803aef:	73 7a                	jae    803b6b <realloc_block_FF+0x44d>
  803af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af4:	8b 00                	mov    (%eax),%eax
  803af6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803af9:	73 70                	jae    803b6b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aff:	74 06                	je     803b07 <realloc_block_FF+0x3e9>
  803b01:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b05:	75 17                	jne    803b1e <realloc_block_FF+0x400>
  803b07:	83 ec 04             	sub    $0x4,%esp
  803b0a:	68 64 4c 80 00       	push   $0x804c64
  803b0f:	68 1a 02 00 00       	push   $0x21a
  803b14:	68 f1 4b 80 00       	push   $0x804bf1
  803b19:	e8 f7 cc ff ff       	call   800815 <_panic>
  803b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b21:	8b 10                	mov    (%eax),%edx
  803b23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b26:	89 10                	mov    %edx,(%eax)
  803b28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b2b:	8b 00                	mov    (%eax),%eax
  803b2d:	85 c0                	test   %eax,%eax
  803b2f:	74 0b                	je     803b3c <realloc_block_FF+0x41e>
  803b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b34:	8b 00                	mov    (%eax),%eax
  803b36:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b39:	89 50 04             	mov    %edx,0x4(%eax)
  803b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b42:	89 10                	mov    %edx,(%eax)
  803b44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b4a:	89 50 04             	mov    %edx,0x4(%eax)
  803b4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b50:	8b 00                	mov    (%eax),%eax
  803b52:	85 c0                	test   %eax,%eax
  803b54:	75 08                	jne    803b5e <realloc_block_FF+0x440>
  803b56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b59:	a3 30 50 80 00       	mov    %eax,0x805030
  803b5e:	a1 38 50 80 00       	mov    0x805038,%eax
  803b63:	40                   	inc    %eax
  803b64:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803b69:	eb 36                	jmp    803ba1 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803b6b:	a1 34 50 80 00       	mov    0x805034,%eax
  803b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b77:	74 07                	je     803b80 <realloc_block_FF+0x462>
  803b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7c:	8b 00                	mov    (%eax),%eax
  803b7e:	eb 05                	jmp    803b85 <realloc_block_FF+0x467>
  803b80:	b8 00 00 00 00       	mov    $0x0,%eax
  803b85:	a3 34 50 80 00       	mov    %eax,0x805034
  803b8a:	a1 34 50 80 00       	mov    0x805034,%eax
  803b8f:	85 c0                	test   %eax,%eax
  803b91:	0f 85 52 ff ff ff    	jne    803ae9 <realloc_block_FF+0x3cb>
  803b97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b9b:	0f 85 48 ff ff ff    	jne    803ae9 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803ba1:	83 ec 04             	sub    $0x4,%esp
  803ba4:	6a 00                	push   $0x0
  803ba6:	ff 75 d8             	pushl  -0x28(%ebp)
  803ba9:	ff 75 d4             	pushl  -0x2c(%ebp)
  803bac:	e8 7a eb ff ff       	call   80272b <set_block_data>
  803bb1:	83 c4 10             	add    $0x10,%esp
				return va;
  803bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb7:	e9 7b 02 00 00       	jmp    803e37 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803bbc:	83 ec 0c             	sub    $0xc,%esp
  803bbf:	68 e1 4c 80 00       	push   $0x804ce1
  803bc4:	e8 09 cf ff ff       	call   800ad2 <cprintf>
  803bc9:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcf:	e9 63 02 00 00       	jmp    803e37 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bd7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bda:	0f 86 4d 02 00 00    	jbe    803e2d <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803be0:	83 ec 0c             	sub    $0xc,%esp
  803be3:	ff 75 e4             	pushl  -0x1c(%ebp)
  803be6:	e8 08 e8 ff ff       	call   8023f3 <is_free_block>
  803beb:	83 c4 10             	add    $0x10,%esp
  803bee:	84 c0                	test   %al,%al
  803bf0:	0f 84 37 02 00 00    	je     803e2d <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803bfc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803bff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c02:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c05:	76 38                	jbe    803c3f <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803c07:	83 ec 0c             	sub    $0xc,%esp
  803c0a:	ff 75 08             	pushl  0x8(%ebp)
  803c0d:	e8 0c fa ff ff       	call   80361e <free_block>
  803c12:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803c15:	83 ec 0c             	sub    $0xc,%esp
  803c18:	ff 75 0c             	pushl  0xc(%ebp)
  803c1b:	e8 3a eb ff ff       	call   80275a <alloc_block_FF>
  803c20:	83 c4 10             	add    $0x10,%esp
  803c23:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803c26:	83 ec 08             	sub    $0x8,%esp
  803c29:	ff 75 c0             	pushl  -0x40(%ebp)
  803c2c:	ff 75 08             	pushl  0x8(%ebp)
  803c2f:	e8 ab fa ff ff       	call   8036df <copy_data>
  803c34:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803c37:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803c3a:	e9 f8 01 00 00       	jmp    803e37 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c42:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803c45:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803c48:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803c4c:	0f 87 a0 00 00 00    	ja     803cf2 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803c52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c56:	75 17                	jne    803c6f <realloc_block_FF+0x551>
  803c58:	83 ec 04             	sub    $0x4,%esp
  803c5b:	68 d3 4b 80 00       	push   $0x804bd3
  803c60:	68 38 02 00 00       	push   $0x238
  803c65:	68 f1 4b 80 00       	push   $0x804bf1
  803c6a:	e8 a6 cb ff ff       	call   800815 <_panic>
  803c6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c72:	8b 00                	mov    (%eax),%eax
  803c74:	85 c0                	test   %eax,%eax
  803c76:	74 10                	je     803c88 <realloc_block_FF+0x56a>
  803c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c7b:	8b 00                	mov    (%eax),%eax
  803c7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c80:	8b 52 04             	mov    0x4(%edx),%edx
  803c83:	89 50 04             	mov    %edx,0x4(%eax)
  803c86:	eb 0b                	jmp    803c93 <realloc_block_FF+0x575>
  803c88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c8b:	8b 40 04             	mov    0x4(%eax),%eax
  803c8e:	a3 30 50 80 00       	mov    %eax,0x805030
  803c93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c96:	8b 40 04             	mov    0x4(%eax),%eax
  803c99:	85 c0                	test   %eax,%eax
  803c9b:	74 0f                	je     803cac <realloc_block_FF+0x58e>
  803c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca0:	8b 40 04             	mov    0x4(%eax),%eax
  803ca3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ca6:	8b 12                	mov    (%edx),%edx
  803ca8:	89 10                	mov    %edx,(%eax)
  803caa:	eb 0a                	jmp    803cb6 <realloc_block_FF+0x598>
  803cac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803caf:	8b 00                	mov    (%eax),%eax
  803cb1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803cb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cc9:	a1 38 50 80 00       	mov    0x805038,%eax
  803cce:	48                   	dec    %eax
  803ccf:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803cd4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cda:	01 d0                	add    %edx,%eax
  803cdc:	83 ec 04             	sub    $0x4,%esp
  803cdf:	6a 01                	push   $0x1
  803ce1:	50                   	push   %eax
  803ce2:	ff 75 08             	pushl  0x8(%ebp)
  803ce5:	e8 41 ea ff ff       	call   80272b <set_block_data>
  803cea:	83 c4 10             	add    $0x10,%esp
  803ced:	e9 36 01 00 00       	jmp    803e28 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803cf2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cf5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cf8:	01 d0                	add    %edx,%eax
  803cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803cfd:	83 ec 04             	sub    $0x4,%esp
  803d00:	6a 01                	push   $0x1
  803d02:	ff 75 f0             	pushl  -0x10(%ebp)
  803d05:	ff 75 08             	pushl  0x8(%ebp)
  803d08:	e8 1e ea ff ff       	call   80272b <set_block_data>
  803d0d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d10:	8b 45 08             	mov    0x8(%ebp),%eax
  803d13:	83 e8 04             	sub    $0x4,%eax
  803d16:	8b 00                	mov    (%eax),%eax
  803d18:	83 e0 fe             	and    $0xfffffffe,%eax
  803d1b:	89 c2                	mov    %eax,%edx
  803d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d20:	01 d0                	add    %edx,%eax
  803d22:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803d25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d29:	74 06                	je     803d31 <realloc_block_FF+0x613>
  803d2b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803d2f:	75 17                	jne    803d48 <realloc_block_FF+0x62a>
  803d31:	83 ec 04             	sub    $0x4,%esp
  803d34:	68 64 4c 80 00       	push   $0x804c64
  803d39:	68 44 02 00 00       	push   $0x244
  803d3e:	68 f1 4b 80 00       	push   $0x804bf1
  803d43:	e8 cd ca ff ff       	call   800815 <_panic>
  803d48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4b:	8b 10                	mov    (%eax),%edx
  803d4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d50:	89 10                	mov    %edx,(%eax)
  803d52:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d55:	8b 00                	mov    (%eax),%eax
  803d57:	85 c0                	test   %eax,%eax
  803d59:	74 0b                	je     803d66 <realloc_block_FF+0x648>
  803d5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5e:	8b 00                	mov    (%eax),%eax
  803d60:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d63:	89 50 04             	mov    %edx,0x4(%eax)
  803d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d69:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d6c:	89 10                	mov    %edx,(%eax)
  803d6e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d74:	89 50 04             	mov    %edx,0x4(%eax)
  803d77:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d7a:	8b 00                	mov    (%eax),%eax
  803d7c:	85 c0                	test   %eax,%eax
  803d7e:	75 08                	jne    803d88 <realloc_block_FF+0x66a>
  803d80:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d83:	a3 30 50 80 00       	mov    %eax,0x805030
  803d88:	a1 38 50 80 00       	mov    0x805038,%eax
  803d8d:	40                   	inc    %eax
  803d8e:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803d93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d97:	75 17                	jne    803db0 <realloc_block_FF+0x692>
  803d99:	83 ec 04             	sub    $0x4,%esp
  803d9c:	68 d3 4b 80 00       	push   $0x804bd3
  803da1:	68 45 02 00 00       	push   $0x245
  803da6:	68 f1 4b 80 00       	push   $0x804bf1
  803dab:	e8 65 ca ff ff       	call   800815 <_panic>
  803db0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db3:	8b 00                	mov    (%eax),%eax
  803db5:	85 c0                	test   %eax,%eax
  803db7:	74 10                	je     803dc9 <realloc_block_FF+0x6ab>
  803db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbc:	8b 00                	mov    (%eax),%eax
  803dbe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dc1:	8b 52 04             	mov    0x4(%edx),%edx
  803dc4:	89 50 04             	mov    %edx,0x4(%eax)
  803dc7:	eb 0b                	jmp    803dd4 <realloc_block_FF+0x6b6>
  803dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dcc:	8b 40 04             	mov    0x4(%eax),%eax
  803dcf:	a3 30 50 80 00       	mov    %eax,0x805030
  803dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd7:	8b 40 04             	mov    0x4(%eax),%eax
  803dda:	85 c0                	test   %eax,%eax
  803ddc:	74 0f                	je     803ded <realloc_block_FF+0x6cf>
  803dde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de1:	8b 40 04             	mov    0x4(%eax),%eax
  803de4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803de7:	8b 12                	mov    (%edx),%edx
  803de9:	89 10                	mov    %edx,(%eax)
  803deb:	eb 0a                	jmp    803df7 <realloc_block_FF+0x6d9>
  803ded:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df0:	8b 00                	mov    (%eax),%eax
  803df2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e0a:	a1 38 50 80 00       	mov    0x805038,%eax
  803e0f:	48                   	dec    %eax
  803e10:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803e15:	83 ec 04             	sub    $0x4,%esp
  803e18:	6a 00                	push   $0x0
  803e1a:	ff 75 bc             	pushl  -0x44(%ebp)
  803e1d:	ff 75 b8             	pushl  -0x48(%ebp)
  803e20:	e8 06 e9 ff ff       	call   80272b <set_block_data>
  803e25:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803e28:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2b:	eb 0a                	jmp    803e37 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803e2d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803e34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803e37:	c9                   	leave  
  803e38:	c3                   	ret    

00803e39 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803e39:	55                   	push   %ebp
  803e3a:	89 e5                	mov    %esp,%ebp
  803e3c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803e3f:	83 ec 04             	sub    $0x4,%esp
  803e42:	68 e8 4c 80 00       	push   $0x804ce8
  803e47:	68 58 02 00 00       	push   $0x258
  803e4c:	68 f1 4b 80 00       	push   $0x804bf1
  803e51:	e8 bf c9 ff ff       	call   800815 <_panic>

00803e56 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803e56:	55                   	push   %ebp
  803e57:	89 e5                	mov    %esp,%ebp
  803e59:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803e5c:	83 ec 04             	sub    $0x4,%esp
  803e5f:	68 10 4d 80 00       	push   $0x804d10
  803e64:	68 61 02 00 00       	push   $0x261
  803e69:	68 f1 4b 80 00       	push   $0x804bf1
  803e6e:	e8 a2 c9 ff ff       	call   800815 <_panic>
  803e73:	90                   	nop

00803e74 <__udivdi3>:
  803e74:	55                   	push   %ebp
  803e75:	57                   	push   %edi
  803e76:	56                   	push   %esi
  803e77:	53                   	push   %ebx
  803e78:	83 ec 1c             	sub    $0x1c,%esp
  803e7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e8b:	89 ca                	mov    %ecx,%edx
  803e8d:	89 f8                	mov    %edi,%eax
  803e8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e93:	85 f6                	test   %esi,%esi
  803e95:	75 2d                	jne    803ec4 <__udivdi3+0x50>
  803e97:	39 cf                	cmp    %ecx,%edi
  803e99:	77 65                	ja     803f00 <__udivdi3+0x8c>
  803e9b:	89 fd                	mov    %edi,%ebp
  803e9d:	85 ff                	test   %edi,%edi
  803e9f:	75 0b                	jne    803eac <__udivdi3+0x38>
  803ea1:	b8 01 00 00 00       	mov    $0x1,%eax
  803ea6:	31 d2                	xor    %edx,%edx
  803ea8:	f7 f7                	div    %edi
  803eaa:	89 c5                	mov    %eax,%ebp
  803eac:	31 d2                	xor    %edx,%edx
  803eae:	89 c8                	mov    %ecx,%eax
  803eb0:	f7 f5                	div    %ebp
  803eb2:	89 c1                	mov    %eax,%ecx
  803eb4:	89 d8                	mov    %ebx,%eax
  803eb6:	f7 f5                	div    %ebp
  803eb8:	89 cf                	mov    %ecx,%edi
  803eba:	89 fa                	mov    %edi,%edx
  803ebc:	83 c4 1c             	add    $0x1c,%esp
  803ebf:	5b                   	pop    %ebx
  803ec0:	5e                   	pop    %esi
  803ec1:	5f                   	pop    %edi
  803ec2:	5d                   	pop    %ebp
  803ec3:	c3                   	ret    
  803ec4:	39 ce                	cmp    %ecx,%esi
  803ec6:	77 28                	ja     803ef0 <__udivdi3+0x7c>
  803ec8:	0f bd fe             	bsr    %esi,%edi
  803ecb:	83 f7 1f             	xor    $0x1f,%edi
  803ece:	75 40                	jne    803f10 <__udivdi3+0x9c>
  803ed0:	39 ce                	cmp    %ecx,%esi
  803ed2:	72 0a                	jb     803ede <__udivdi3+0x6a>
  803ed4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ed8:	0f 87 9e 00 00 00    	ja     803f7c <__udivdi3+0x108>
  803ede:	b8 01 00 00 00       	mov    $0x1,%eax
  803ee3:	89 fa                	mov    %edi,%edx
  803ee5:	83 c4 1c             	add    $0x1c,%esp
  803ee8:	5b                   	pop    %ebx
  803ee9:	5e                   	pop    %esi
  803eea:	5f                   	pop    %edi
  803eeb:	5d                   	pop    %ebp
  803eec:	c3                   	ret    
  803eed:	8d 76 00             	lea    0x0(%esi),%esi
  803ef0:	31 ff                	xor    %edi,%edi
  803ef2:	31 c0                	xor    %eax,%eax
  803ef4:	89 fa                	mov    %edi,%edx
  803ef6:	83 c4 1c             	add    $0x1c,%esp
  803ef9:	5b                   	pop    %ebx
  803efa:	5e                   	pop    %esi
  803efb:	5f                   	pop    %edi
  803efc:	5d                   	pop    %ebp
  803efd:	c3                   	ret    
  803efe:	66 90                	xchg   %ax,%ax
  803f00:	89 d8                	mov    %ebx,%eax
  803f02:	f7 f7                	div    %edi
  803f04:	31 ff                	xor    %edi,%edi
  803f06:	89 fa                	mov    %edi,%edx
  803f08:	83 c4 1c             	add    $0x1c,%esp
  803f0b:	5b                   	pop    %ebx
  803f0c:	5e                   	pop    %esi
  803f0d:	5f                   	pop    %edi
  803f0e:	5d                   	pop    %ebp
  803f0f:	c3                   	ret    
  803f10:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f15:	89 eb                	mov    %ebp,%ebx
  803f17:	29 fb                	sub    %edi,%ebx
  803f19:	89 f9                	mov    %edi,%ecx
  803f1b:	d3 e6                	shl    %cl,%esi
  803f1d:	89 c5                	mov    %eax,%ebp
  803f1f:	88 d9                	mov    %bl,%cl
  803f21:	d3 ed                	shr    %cl,%ebp
  803f23:	89 e9                	mov    %ebp,%ecx
  803f25:	09 f1                	or     %esi,%ecx
  803f27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f2b:	89 f9                	mov    %edi,%ecx
  803f2d:	d3 e0                	shl    %cl,%eax
  803f2f:	89 c5                	mov    %eax,%ebp
  803f31:	89 d6                	mov    %edx,%esi
  803f33:	88 d9                	mov    %bl,%cl
  803f35:	d3 ee                	shr    %cl,%esi
  803f37:	89 f9                	mov    %edi,%ecx
  803f39:	d3 e2                	shl    %cl,%edx
  803f3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f3f:	88 d9                	mov    %bl,%cl
  803f41:	d3 e8                	shr    %cl,%eax
  803f43:	09 c2                	or     %eax,%edx
  803f45:	89 d0                	mov    %edx,%eax
  803f47:	89 f2                	mov    %esi,%edx
  803f49:	f7 74 24 0c          	divl   0xc(%esp)
  803f4d:	89 d6                	mov    %edx,%esi
  803f4f:	89 c3                	mov    %eax,%ebx
  803f51:	f7 e5                	mul    %ebp
  803f53:	39 d6                	cmp    %edx,%esi
  803f55:	72 19                	jb     803f70 <__udivdi3+0xfc>
  803f57:	74 0b                	je     803f64 <__udivdi3+0xf0>
  803f59:	89 d8                	mov    %ebx,%eax
  803f5b:	31 ff                	xor    %edi,%edi
  803f5d:	e9 58 ff ff ff       	jmp    803eba <__udivdi3+0x46>
  803f62:	66 90                	xchg   %ax,%ax
  803f64:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f68:	89 f9                	mov    %edi,%ecx
  803f6a:	d3 e2                	shl    %cl,%edx
  803f6c:	39 c2                	cmp    %eax,%edx
  803f6e:	73 e9                	jae    803f59 <__udivdi3+0xe5>
  803f70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f73:	31 ff                	xor    %edi,%edi
  803f75:	e9 40 ff ff ff       	jmp    803eba <__udivdi3+0x46>
  803f7a:	66 90                	xchg   %ax,%ax
  803f7c:	31 c0                	xor    %eax,%eax
  803f7e:	e9 37 ff ff ff       	jmp    803eba <__udivdi3+0x46>
  803f83:	90                   	nop

00803f84 <__umoddi3>:
  803f84:	55                   	push   %ebp
  803f85:	57                   	push   %edi
  803f86:	56                   	push   %esi
  803f87:	53                   	push   %ebx
  803f88:	83 ec 1c             	sub    $0x1c,%esp
  803f8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fa3:	89 f3                	mov    %esi,%ebx
  803fa5:	89 fa                	mov    %edi,%edx
  803fa7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fab:	89 34 24             	mov    %esi,(%esp)
  803fae:	85 c0                	test   %eax,%eax
  803fb0:	75 1a                	jne    803fcc <__umoddi3+0x48>
  803fb2:	39 f7                	cmp    %esi,%edi
  803fb4:	0f 86 a2 00 00 00    	jbe    80405c <__umoddi3+0xd8>
  803fba:	89 c8                	mov    %ecx,%eax
  803fbc:	89 f2                	mov    %esi,%edx
  803fbe:	f7 f7                	div    %edi
  803fc0:	89 d0                	mov    %edx,%eax
  803fc2:	31 d2                	xor    %edx,%edx
  803fc4:	83 c4 1c             	add    $0x1c,%esp
  803fc7:	5b                   	pop    %ebx
  803fc8:	5e                   	pop    %esi
  803fc9:	5f                   	pop    %edi
  803fca:	5d                   	pop    %ebp
  803fcb:	c3                   	ret    
  803fcc:	39 f0                	cmp    %esi,%eax
  803fce:	0f 87 ac 00 00 00    	ja     804080 <__umoddi3+0xfc>
  803fd4:	0f bd e8             	bsr    %eax,%ebp
  803fd7:	83 f5 1f             	xor    $0x1f,%ebp
  803fda:	0f 84 ac 00 00 00    	je     80408c <__umoddi3+0x108>
  803fe0:	bf 20 00 00 00       	mov    $0x20,%edi
  803fe5:	29 ef                	sub    %ebp,%edi
  803fe7:	89 fe                	mov    %edi,%esi
  803fe9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fed:	89 e9                	mov    %ebp,%ecx
  803fef:	d3 e0                	shl    %cl,%eax
  803ff1:	89 d7                	mov    %edx,%edi
  803ff3:	89 f1                	mov    %esi,%ecx
  803ff5:	d3 ef                	shr    %cl,%edi
  803ff7:	09 c7                	or     %eax,%edi
  803ff9:	89 e9                	mov    %ebp,%ecx
  803ffb:	d3 e2                	shl    %cl,%edx
  803ffd:	89 14 24             	mov    %edx,(%esp)
  804000:	89 d8                	mov    %ebx,%eax
  804002:	d3 e0                	shl    %cl,%eax
  804004:	89 c2                	mov    %eax,%edx
  804006:	8b 44 24 08          	mov    0x8(%esp),%eax
  80400a:	d3 e0                	shl    %cl,%eax
  80400c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804010:	8b 44 24 08          	mov    0x8(%esp),%eax
  804014:	89 f1                	mov    %esi,%ecx
  804016:	d3 e8                	shr    %cl,%eax
  804018:	09 d0                	or     %edx,%eax
  80401a:	d3 eb                	shr    %cl,%ebx
  80401c:	89 da                	mov    %ebx,%edx
  80401e:	f7 f7                	div    %edi
  804020:	89 d3                	mov    %edx,%ebx
  804022:	f7 24 24             	mull   (%esp)
  804025:	89 c6                	mov    %eax,%esi
  804027:	89 d1                	mov    %edx,%ecx
  804029:	39 d3                	cmp    %edx,%ebx
  80402b:	0f 82 87 00 00 00    	jb     8040b8 <__umoddi3+0x134>
  804031:	0f 84 91 00 00 00    	je     8040c8 <__umoddi3+0x144>
  804037:	8b 54 24 04          	mov    0x4(%esp),%edx
  80403b:	29 f2                	sub    %esi,%edx
  80403d:	19 cb                	sbb    %ecx,%ebx
  80403f:	89 d8                	mov    %ebx,%eax
  804041:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804045:	d3 e0                	shl    %cl,%eax
  804047:	89 e9                	mov    %ebp,%ecx
  804049:	d3 ea                	shr    %cl,%edx
  80404b:	09 d0                	or     %edx,%eax
  80404d:	89 e9                	mov    %ebp,%ecx
  80404f:	d3 eb                	shr    %cl,%ebx
  804051:	89 da                	mov    %ebx,%edx
  804053:	83 c4 1c             	add    $0x1c,%esp
  804056:	5b                   	pop    %ebx
  804057:	5e                   	pop    %esi
  804058:	5f                   	pop    %edi
  804059:	5d                   	pop    %ebp
  80405a:	c3                   	ret    
  80405b:	90                   	nop
  80405c:	89 fd                	mov    %edi,%ebp
  80405e:	85 ff                	test   %edi,%edi
  804060:	75 0b                	jne    80406d <__umoddi3+0xe9>
  804062:	b8 01 00 00 00       	mov    $0x1,%eax
  804067:	31 d2                	xor    %edx,%edx
  804069:	f7 f7                	div    %edi
  80406b:	89 c5                	mov    %eax,%ebp
  80406d:	89 f0                	mov    %esi,%eax
  80406f:	31 d2                	xor    %edx,%edx
  804071:	f7 f5                	div    %ebp
  804073:	89 c8                	mov    %ecx,%eax
  804075:	f7 f5                	div    %ebp
  804077:	89 d0                	mov    %edx,%eax
  804079:	e9 44 ff ff ff       	jmp    803fc2 <__umoddi3+0x3e>
  80407e:	66 90                	xchg   %ax,%ax
  804080:	89 c8                	mov    %ecx,%eax
  804082:	89 f2                	mov    %esi,%edx
  804084:	83 c4 1c             	add    $0x1c,%esp
  804087:	5b                   	pop    %ebx
  804088:	5e                   	pop    %esi
  804089:	5f                   	pop    %edi
  80408a:	5d                   	pop    %ebp
  80408b:	c3                   	ret    
  80408c:	3b 04 24             	cmp    (%esp),%eax
  80408f:	72 06                	jb     804097 <__umoddi3+0x113>
  804091:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804095:	77 0f                	ja     8040a6 <__umoddi3+0x122>
  804097:	89 f2                	mov    %esi,%edx
  804099:	29 f9                	sub    %edi,%ecx
  80409b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80409f:	89 14 24             	mov    %edx,(%esp)
  8040a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040aa:	8b 14 24             	mov    (%esp),%edx
  8040ad:	83 c4 1c             	add    $0x1c,%esp
  8040b0:	5b                   	pop    %ebx
  8040b1:	5e                   	pop    %esi
  8040b2:	5f                   	pop    %edi
  8040b3:	5d                   	pop    %ebp
  8040b4:	c3                   	ret    
  8040b5:	8d 76 00             	lea    0x0(%esi),%esi
  8040b8:	2b 04 24             	sub    (%esp),%eax
  8040bb:	19 fa                	sbb    %edi,%edx
  8040bd:	89 d1                	mov    %edx,%ecx
  8040bf:	89 c6                	mov    %eax,%esi
  8040c1:	e9 71 ff ff ff       	jmp    804037 <__umoddi3+0xb3>
  8040c6:	66 90                	xchg   %ax,%ax
  8040c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040cc:	72 ea                	jb     8040b8 <__umoddi3+0x134>
  8040ce:	89 d9                	mov    %ebx,%ecx
  8040d0:	e9 62 ff ff ff       	jmp    804037 <__umoddi3+0xb3>
