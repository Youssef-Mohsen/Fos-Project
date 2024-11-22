
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 1d 04 00 00       	call   800453 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp

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
  80005c:	68 00 3e 80 00       	push   $0x803e00
  800061:	6a 14                	push   $0x14
  800063:	68 1c 3e 80 00       	push   $0x803e1c
  800068:	e8 25 05 00 00       	call   800592 <_panic>
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
	int diff, expected;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  800082:	e8 5a 1b 00 00       	call   801be1 <sys_calculate_free_frames>
  800087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = smalloc("x", 4, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 04                	push   $0x4
  800091:	68 37 3e 80 00       	push   $0x803e37
  800096:	e8 81 18 00 00       	call   80191c <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 3c 3e 80 00       	push   $0x803e3c
  8000b8:	e8 92 07 00 00       	call   80084f <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8000c0:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8000c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ca:	e8 12 1b 00 00       	call   801be1 <sys_calculate_free_frames>
  8000cf:	29 c3                	sub    %eax,%ebx
  8000d1:	89 d8                	mov    %ebx,%eax
  8000d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000dc:	7c 0b                	jl     8000e9 <_main+0xb1>
  8000de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000e1:	83 c0 02             	add    $0x2,%eax
  8000e4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8000e7:	7d 27                	jge    800110 <_main+0xd8>
  8000e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f3:	e8 e9 1a 00 00       	call   801be1 <sys_calculate_free_frames>
  8000f8:	29 c3                	sub    %eax,%ebx
  8000fa:	89 d8                	mov    %ebx,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800102:	50                   	push   %eax
  800103:	68 a0 3e 80 00       	push   $0x803ea0
  800108:	e8 42 07 00 00       	call   80084f <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800110:	e8 cc 1a 00 00       	call   801be1 <sys_calculate_free_frames>
  800115:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = smalloc("y", 4, 0);
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	6a 00                	push   $0x0
  80011d:	6a 04                	push   $0x4
  80011f:	68 38 3f 80 00       	push   $0x803f38
  800124:	e8 f3 17 00 00       	call   80191c <smalloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80012f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800132:	05 00 10 00 00       	add    $0x1000,%eax
  800137:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80013a:	74 17                	je     800153 <_main+0x11b>
  80013c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	68 3c 3e 80 00       	push   $0x803e3c
  80014b:	e8 ff 06 00 00       	call   80084f <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  800153:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80015a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80015d:	e8 7f 1a 00 00       	call   801be1 <sys_calculate_free_frames>
  800162:	29 c3                	sub    %eax,%ebx
  800164:	89 d8                	mov    %ebx,%eax
  800166:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800169:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80016c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80016f:	7c 0b                	jl     80017c <_main+0x144>
  800171:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800174:	83 c0 02             	add    $0x2,%eax
  800177:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80017a:	7d 27                	jge    8001a3 <_main+0x16b>
  80017c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800183:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800186:	e8 56 1a 00 00       	call   801be1 <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	50                   	push   %eax
  800196:	68 a0 3e 80 00       	push   $0x803ea0
  80019b:	e8 af 06 00 00       	call   80084f <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  8001a3:	e8 39 1a 00 00       	call   801be1 <sys_calculate_free_frames>
  8001a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = smalloc("z", 4, 1);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 01                	push   $0x1
  8001b0:	6a 04                	push   $0x4
  8001b2:	68 3a 3f 80 00       	push   $0x803f3a
  8001b7:	e8 60 17 00 00       	call   80191c <smalloc>
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8001c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c5:	05 00 20 00 00       	add    $0x2000,%eax
  8001ca:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001cd:	74 17                	je     8001e6 <_main+0x1ae>
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	68 3c 3e 80 00       	push   $0x803e3c
  8001de:	e8 6c 06 00 00       	call   80084f <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8001e6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001f0:	e8 ec 19 00 00       	call   801be1 <sys_calculate_free_frames>
  8001f5:	29 c3                	sub    %eax,%ebx
  8001f7:	89 d8                	mov    %ebx,%eax
  8001f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800202:	7c 0b                	jl     80020f <_main+0x1d7>
  800204:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800207:	83 c0 02             	add    $0x2,%eax
  80020a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80020d:	7d 27                	jge    800236 <_main+0x1fe>
  80020f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800216:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800219:	e8 c3 19 00 00       	call   801be1 <sys_calculate_free_frames>
  80021e:	29 c3                	sub    %eax,%ebx
  800220:	89 d8                	mov    %ebx,%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	50                   	push   %eax
  800229:	68 a0 3e 80 00       	push   $0x803ea0
  80022e:	e8 1c 06 00 00       	call   80084f <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800236:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80023a:	74 04                	je     800240 <_main+0x208>
  80023c:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800240:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	*x = 10 ;
  800247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024a:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  800250:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800253:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800264:	a1 20 50 80 00       	mov    0x805020,%eax
  800269:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80026f:	89 c1                	mov    %eax,%ecx
  800271:	a1 20 50 80 00       	mov    0x805020,%eax
  800276:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80027c:	52                   	push   %edx
  80027d:	51                   	push   %ecx
  80027e:	50                   	push   %eax
  80027f:	68 3c 3f 80 00       	push   $0x803f3c
  800284:	e8 b3 1a 00 00       	call   801d3c <sys_create_env>
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80028f:	a1 20 50 80 00       	mov    0x805020,%eax
  800294:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  80029a:	a1 20 50 80 00       	mov    0x805020,%eax
  80029f:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8002a5:	89 c1                	mov    %eax,%ecx
  8002a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ac:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8002b2:	52                   	push   %edx
  8002b3:	51                   	push   %ecx
  8002b4:	50                   	push   %eax
  8002b5:	68 3c 3f 80 00       	push   $0x803f3c
  8002ba:	e8 7d 1a 00 00       	call   801d3c <sys_create_env>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8002c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ca:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8002d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d5:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8002db:	89 c1                	mov    %eax,%ecx
  8002dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8002e8:	52                   	push   %edx
  8002e9:	51                   	push   %ecx
  8002ea:	50                   	push   %eax
  8002eb:	68 3c 3f 80 00       	push   $0x803f3c
  8002f0:	e8 47 1a 00 00       	call   801d3c <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8002fb:	e8 88 1b 00 00       	call   801e88 <rsttst>

	sys_run_env(id1);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 d0             	pushl  -0x30(%ebp)
  800306:	e8 4f 1a 00 00       	call   801d5a <sys_run_env>
  80030b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 cc             	pushl  -0x34(%ebp)
  800314:	e8 41 1a 00 00       	call   801d5a <sys_run_env>
  800319:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 c8             	pushl  -0x38(%ebp)
  800322:	e8 33 1a 00 00       	call   801d5a <sys_run_env>
  800327:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  80032a:	90                   	nop
  80032b:	e8 d2 1b 00 00       	call   801f02 <gettst>
  800330:	83 f8 03             	cmp    $0x3,%eax
  800333:	75 f6                	jne    80032b <_main+0x2f3>


	if (*z != 30)
  800335:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	83 f8 1e             	cmp    $0x1e,%eax
  80033d:	74 17                	je     800356 <_main+0x31e>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  80033f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800346:	83 ec 0c             	sub    $0xc,%esp
  800349:	68 48 3f 80 00       	push   $0x803f48
  80034e:	e8 fc 04 00 00       	call   80084f <cprintf>
  800353:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80035a:	74 04                	je     800360 <_main+0x328>
  80035c:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800360:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	atomic_cprintf("%@Now, attempting to write a ReadOnly variable\n\n\n");
  800367:	83 ec 0c             	sub    $0xc,%esp
  80036a:	68 94 3f 80 00       	push   $0x803f94
  80036f:	e8 08 05 00 00       	call   80087c <atomic_cprintf>
  800374:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800377:	a1 20 50 80 00       	mov    0x805020,%eax
  80037c:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800382:	a1 20 50 80 00       	mov    0x805020,%eax
  800387:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80038d:	89 c1                	mov    %eax,%ecx
  80038f:	a1 20 50 80 00       	mov    0x805020,%eax
  800394:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80039a:	52                   	push   %edx
  80039b:	51                   	push   %ecx
  80039c:	50                   	push   %eax
  80039d:	68 c6 3f 80 00       	push   $0x803fc6
  8003a2:	e8 95 19 00 00       	call   801d3c <sys_create_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b3:	e8 a2 19 00 00       	call   801d5a <sys_run_env>
  8003b8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  8003bb:	90                   	nop
  8003bc:	e8 41 1b 00 00       	call   801f02 <gettst>
  8003c1:	83 f8 04             	cmp    $0x4,%eax
  8003c4:	75 f6                	jne    8003bc <_main+0x384>

	if (*z != 50)
  8003c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	83 f8 32             	cmp    $0x32,%eax
  8003ce:	74 17                	je     8003e7 <_main+0x3af>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  8003d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d7:	83 ec 0c             	sub    $0xc,%esp
  8003da:	68 48 3f 80 00       	push   $0x803f48
  8003df:	e8 6b 04 00 00       	call   80084f <cprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8003e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003eb:	74 04                	je     8003f1 <_main+0x3b9>
  8003ed:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8003f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Signal slave2
	inctst();
  8003f8:	e8 eb 1a 00 00       	call   801ee8 <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8003fd:	90                   	nop
  8003fe:	e8 ff 1a 00 00       	call   801f02 <gettst>
  800403:	83 f8 06             	cmp    $0x6,%eax
  800406:	75 f6                	jne    8003fe <_main+0x3c6>

	if (*x != 10)
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	83 f8 0a             	cmp    $0xa,%eax
  800410:	74 17                	je     800429 <_main+0x3f1>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  800412:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	68 48 3f 80 00       	push   $0x803f48
  800421:	e8 29 04 00 00       	call   80084f <cprintf>
  800426:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800429:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80042d:	74 04                	je     800433 <_main+0x3fb>
  80042f:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800433:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("\n%~Test of Shared Variables [Create & Get] completed. Eval = %d%%\n\n", eval);
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	ff 75 f4             	pushl  -0xc(%ebp)
  800440:	68 d4 3f 80 00       	push   $0x803fd4
  800445:	e8 05 04 00 00       	call   80084f <cprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	return;
  80044d:	90                   	nop
}
  80044e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800451:	c9                   	leave  
  800452:	c3                   	ret    

00800453 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800453:	55                   	push   %ebp
  800454:	89 e5                	mov    %esp,%ebp
  800456:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800459:	e8 4c 19 00 00       	call   801daa <sys_getenvindex>
  80045e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800464:	89 d0                	mov    %edx,%eax
  800466:	c1 e0 03             	shl    $0x3,%eax
  800469:	01 d0                	add    %edx,%eax
  80046b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800472:	01 c8                	add    %ecx,%eax
  800474:	01 c0                	add    %eax,%eax
  800476:	01 d0                	add    %edx,%eax
  800478:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80047f:	01 c8                	add    %ecx,%eax
  800481:	01 d0                	add    %edx,%eax
  800483:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800488:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80048d:	a1 20 50 80 00       	mov    0x805020,%eax
  800492:	8a 40 20             	mov    0x20(%eax),%al
  800495:	84 c0                	test   %al,%al
  800497:	74 0d                	je     8004a6 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800499:	a1 20 50 80 00       	mov    0x805020,%eax
  80049e:	83 c0 20             	add    $0x20,%eax
  8004a1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004aa:	7e 0a                	jle    8004b6 <libmain+0x63>
		binaryname = argv[0];
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	ff 75 0c             	pushl  0xc(%ebp)
  8004bc:	ff 75 08             	pushl  0x8(%ebp)
  8004bf:	e8 74 fb ff ff       	call   800038 <_main>
  8004c4:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8004c7:	e8 62 16 00 00       	call   801b2e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004cc:	83 ec 0c             	sub    $0xc,%esp
  8004cf:	68 30 40 80 00       	push   $0x804030
  8004d4:	e8 76 03 00 00       	call   80084f <cprintf>
  8004d9:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e1:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8004e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ec:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	52                   	push   %edx
  8004f6:	50                   	push   %eax
  8004f7:	68 58 40 80 00       	push   $0x804058
  8004fc:	e8 4e 03 00 00       	call   80084f <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800504:	a1 20 50 80 00       	mov    0x805020,%eax
  800509:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80050f:	a1 20 50 80 00       	mov    0x805020,%eax
  800514:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80051a:	a1 20 50 80 00       	mov    0x805020,%eax
  80051f:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800525:	51                   	push   %ecx
  800526:	52                   	push   %edx
  800527:	50                   	push   %eax
  800528:	68 80 40 80 00       	push   $0x804080
  80052d:	e8 1d 03 00 00       	call   80084f <cprintf>
  800532:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800535:	a1 20 50 80 00       	mov    0x805020,%eax
  80053a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	50                   	push   %eax
  800544:	68 d8 40 80 00       	push   $0x8040d8
  800549:	e8 01 03 00 00       	call   80084f <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 30 40 80 00       	push   $0x804030
  800559:	e8 f1 02 00 00       	call   80084f <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800561:	e8 e2 15 00 00       	call   801b48 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800566:	e8 19 00 00 00       	call   800584 <exit>
}
  80056b:	90                   	nop
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800574:	83 ec 0c             	sub    $0xc,%esp
  800577:	6a 00                	push   $0x0
  800579:	e8 f8 17 00 00       	call   801d76 <sys_destroy_env>
  80057e:	83 c4 10             	add    $0x10,%esp
}
  800581:	90                   	nop
  800582:	c9                   	leave  
  800583:	c3                   	ret    

00800584 <exit>:

void
exit(void)
{
  800584:	55                   	push   %ebp
  800585:	89 e5                	mov    %esp,%ebp
  800587:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80058a:	e8 4d 18 00 00       	call   801ddc <sys_exit_env>
}
  80058f:	90                   	nop
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800598:	8d 45 10             	lea    0x10(%ebp),%eax
  80059b:	83 c0 04             	add    $0x4,%eax
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005a1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8005a6:	85 c0                	test   %eax,%eax
  8005a8:	74 16                	je     8005c0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005aa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8005af:	83 ec 08             	sub    $0x8,%esp
  8005b2:	50                   	push   %eax
  8005b3:	68 ec 40 80 00       	push   $0x8040ec
  8005b8:	e8 92 02 00 00       	call   80084f <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005c0:	a1 00 50 80 00       	mov    0x805000,%eax
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	50                   	push   %eax
  8005cc:	68 f1 40 80 00       	push   $0x8040f1
  8005d1:	e8 79 02 00 00       	call   80084f <cprintf>
  8005d6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005dc:	83 ec 08             	sub    $0x8,%esp
  8005df:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e2:	50                   	push   %eax
  8005e3:	e8 fc 01 00 00       	call   8007e4 <vcprintf>
  8005e8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	6a 00                	push   $0x0
  8005f0:	68 0d 41 80 00       	push   $0x80410d
  8005f5:	e8 ea 01 00 00       	call   8007e4 <vcprintf>
  8005fa:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005fd:	e8 82 ff ff ff       	call   800584 <exit>

	// should not return here
	while (1) ;
  800602:	eb fe                	jmp    800602 <_panic+0x70>

00800604 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800604:	55                   	push   %ebp
  800605:	89 e5                	mov    %esp,%ebp
  800607:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80060a:	a1 20 50 80 00       	mov    0x805020,%eax
  80060f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800615:	8b 45 0c             	mov    0xc(%ebp),%eax
  800618:	39 c2                	cmp    %eax,%edx
  80061a:	74 14                	je     800630 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80061c:	83 ec 04             	sub    $0x4,%esp
  80061f:	68 10 41 80 00       	push   $0x804110
  800624:	6a 26                	push   $0x26
  800626:	68 5c 41 80 00       	push   $0x80415c
  80062b:	e8 62 ff ff ff       	call   800592 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800630:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800637:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80063e:	e9 c5 00 00 00       	jmp    800708 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800646:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	85 c0                	test   %eax,%eax
  800656:	75 08                	jne    800660 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800658:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80065b:	e9 a5 00 00 00       	jmp    800705 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800660:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800667:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80066e:	eb 69                	jmp    8006d9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800670:	a1 20 50 80 00       	mov    0x805020,%eax
  800675:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80067b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80067e:	89 d0                	mov    %edx,%eax
  800680:	01 c0                	add    %eax,%eax
  800682:	01 d0                	add    %edx,%eax
  800684:	c1 e0 03             	shl    $0x3,%eax
  800687:	01 c8                	add    %ecx,%eax
  800689:	8a 40 04             	mov    0x4(%eax),%al
  80068c:	84 c0                	test   %al,%al
  80068e:	75 46                	jne    8006d6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800690:	a1 20 50 80 00       	mov    0x805020,%eax
  800695:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80069b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80069e:	89 d0                	mov    %edx,%eax
  8006a0:	01 c0                	add    %eax,%eax
  8006a2:	01 d0                	add    %edx,%eax
  8006a4:	c1 e0 03             	shl    $0x3,%eax
  8006a7:	01 c8                	add    %ecx,%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006b6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	01 c8                	add    %ecx,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006c9:	39 c2                	cmp    %eax,%edx
  8006cb:	75 09                	jne    8006d6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006cd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006d4:	eb 15                	jmp    8006eb <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006d6:	ff 45 e8             	incl   -0x18(%ebp)
  8006d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8006de:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e7:	39 c2                	cmp    %eax,%edx
  8006e9:	77 85                	ja     800670 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006ef:	75 14                	jne    800705 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006f1:	83 ec 04             	sub    $0x4,%esp
  8006f4:	68 68 41 80 00       	push   $0x804168
  8006f9:	6a 3a                	push   $0x3a
  8006fb:	68 5c 41 80 00       	push   $0x80415c
  800700:	e8 8d fe ff ff       	call   800592 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800705:	ff 45 f0             	incl   -0x10(%ebp)
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80070e:	0f 8c 2f ff ff ff    	jl     800643 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800714:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80071b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800722:	eb 26                	jmp    80074a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800724:	a1 20 50 80 00       	mov    0x805020,%eax
  800729:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80072f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800732:	89 d0                	mov    %edx,%eax
  800734:	01 c0                	add    %eax,%eax
  800736:	01 d0                	add    %edx,%eax
  800738:	c1 e0 03             	shl    $0x3,%eax
  80073b:	01 c8                	add    %ecx,%eax
  80073d:	8a 40 04             	mov    0x4(%eax),%al
  800740:	3c 01                	cmp    $0x1,%al
  800742:	75 03                	jne    800747 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800744:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800747:	ff 45 e0             	incl   -0x20(%ebp)
  80074a:	a1 20 50 80 00       	mov    0x805020,%eax
  80074f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800755:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800758:	39 c2                	cmp    %eax,%edx
  80075a:	77 c8                	ja     800724 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80075c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800762:	74 14                	je     800778 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	68 bc 41 80 00       	push   $0x8041bc
  80076c:	6a 44                	push   $0x44
  80076e:	68 5c 41 80 00       	push   $0x80415c
  800773:	e8 1a fe ff ff       	call   800592 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800778:	90                   	nop
  800779:	c9                   	leave  
  80077a:	c3                   	ret    

0080077b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800781:	8b 45 0c             	mov    0xc(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	8d 48 01             	lea    0x1(%eax),%ecx
  800789:	8b 55 0c             	mov    0xc(%ebp),%edx
  80078c:	89 0a                	mov    %ecx,(%edx)
  80078e:	8b 55 08             	mov    0x8(%ebp),%edx
  800791:	88 d1                	mov    %dl,%cl
  800793:	8b 55 0c             	mov    0xc(%ebp),%edx
  800796:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80079a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007a4:	75 2c                	jne    8007d2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007a6:	a0 28 50 80 00       	mov    0x805028,%al
  8007ab:	0f b6 c0             	movzbl %al,%eax
  8007ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b1:	8b 12                	mov    (%edx),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b8:	83 c2 08             	add    $0x8,%edx
  8007bb:	83 ec 04             	sub    $0x4,%esp
  8007be:	50                   	push   %eax
  8007bf:	51                   	push   %ecx
  8007c0:	52                   	push   %edx
  8007c1:	e8 26 13 00 00       	call   801aec <sys_cputs>
  8007c6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d5:	8b 40 04             	mov    0x4(%eax),%eax
  8007d8:	8d 50 01             	lea    0x1(%eax),%edx
  8007db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007de:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007e1:	90                   	nop
  8007e2:	c9                   	leave  
  8007e3:	c3                   	ret    

008007e4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007f4:	00 00 00 
	b.cnt = 0;
  8007f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007fe:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	ff 75 08             	pushl  0x8(%ebp)
  800807:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80080d:	50                   	push   %eax
  80080e:	68 7b 07 80 00       	push   $0x80077b
  800813:	e8 11 02 00 00       	call   800a29 <vprintfmt>
  800818:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80081b:	a0 28 50 80 00       	mov    0x805028,%al
  800820:	0f b6 c0             	movzbl %al,%eax
  800823:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800829:	83 ec 04             	sub    $0x4,%esp
  80082c:	50                   	push   %eax
  80082d:	52                   	push   %edx
  80082e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800834:	83 c0 08             	add    $0x8,%eax
  800837:	50                   	push   %eax
  800838:	e8 af 12 00 00       	call   801aec <sys_cputs>
  80083d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800840:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800847:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80084d:	c9                   	leave  
  80084e:	c3                   	ret    

0080084f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800855:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  80085c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80085f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 f4             	pushl  -0xc(%ebp)
  80086b:	50                   	push   %eax
  80086c:	e8 73 ff ff ff       	call   8007e4 <vcprintf>
  800871:	83 c4 10             	add    $0x10,%esp
  800874:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800877:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80087a:	c9                   	leave  
  80087b:	c3                   	ret    

0080087c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800882:	e8 a7 12 00 00       	call   801b2e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800887:	8d 45 0c             	lea    0xc(%ebp),%eax
  80088a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	ff 75 f4             	pushl  -0xc(%ebp)
  800896:	50                   	push   %eax
  800897:	e8 48 ff ff ff       	call   8007e4 <vcprintf>
  80089c:	83 c4 10             	add    $0x10,%esp
  80089f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8008a2:	e8 a1 12 00 00       	call   801b48 <sys_unlock_cons>
	return cnt;
  8008a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008aa:	c9                   	leave  
  8008ab:	c3                   	ret    

008008ac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	53                   	push   %ebx
  8008b0:	83 ec 14             	sub    $0x14,%esp
  8008b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8008c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008ca:	77 55                	ja     800921 <printnum+0x75>
  8008cc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008cf:	72 05                	jb     8008d6 <printnum+0x2a>
  8008d1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008d4:	77 4b                	ja     800921 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008d6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008d9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008dc:	8b 45 18             	mov    0x18(%ebp),%eax
  8008df:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e4:	52                   	push   %edx
  8008e5:	50                   	push   %eax
  8008e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ec:	e8 93 32 00 00       	call   803b84 <__udivdi3>
  8008f1:	83 c4 10             	add    $0x10,%esp
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	ff 75 20             	pushl  0x20(%ebp)
  8008fa:	53                   	push   %ebx
  8008fb:	ff 75 18             	pushl  0x18(%ebp)
  8008fe:	52                   	push   %edx
  8008ff:	50                   	push   %eax
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	ff 75 08             	pushl  0x8(%ebp)
  800906:	e8 a1 ff ff ff       	call   8008ac <printnum>
  80090b:	83 c4 20             	add    $0x20,%esp
  80090e:	eb 1a                	jmp    80092a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	ff 75 0c             	pushl  0xc(%ebp)
  800916:	ff 75 20             	pushl  0x20(%ebp)
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	ff d0                	call   *%eax
  80091e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800921:	ff 4d 1c             	decl   0x1c(%ebp)
  800924:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800928:	7f e6                	jg     800910 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80092a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80092d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800938:	53                   	push   %ebx
  800939:	51                   	push   %ecx
  80093a:	52                   	push   %edx
  80093b:	50                   	push   %eax
  80093c:	e8 53 33 00 00       	call   803c94 <__umoddi3>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	05 34 44 80 00       	add    $0x804434,%eax
  800949:	8a 00                	mov    (%eax),%al
  80094b:	0f be c0             	movsbl %al,%eax
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	ff 75 0c             	pushl  0xc(%ebp)
  800954:	50                   	push   %eax
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	ff d0                	call   *%eax
  80095a:	83 c4 10             	add    $0x10,%esp
}
  80095d:	90                   	nop
  80095e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800961:	c9                   	leave  
  800962:	c3                   	ret    

00800963 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800966:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80096a:	7e 1c                	jle    800988 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	8d 50 08             	lea    0x8(%eax),%edx
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	89 10                	mov    %edx,(%eax)
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	83 e8 08             	sub    $0x8,%eax
  800981:	8b 50 04             	mov    0x4(%eax),%edx
  800984:	8b 00                	mov    (%eax),%eax
  800986:	eb 40                	jmp    8009c8 <getuint+0x65>
	else if (lflag)
  800988:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098c:	74 1e                	je     8009ac <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 00                	mov    (%eax),%eax
  800993:	8d 50 04             	lea    0x4(%eax),%edx
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	89 10                	mov    %edx,(%eax)
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 00                	mov    (%eax),%eax
  8009a0:	83 e8 04             	sub    $0x4,%eax
  8009a3:	8b 00                	mov    (%eax),%eax
  8009a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009aa:	eb 1c                	jmp    8009c8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	8d 50 04             	lea    0x4(%eax),%edx
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	89 10                	mov    %edx,(%eax)
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	83 e8 04             	sub    $0x4,%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009cd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009d1:	7e 1c                	jle    8009ef <getint+0x25>
		return va_arg(*ap, long long);
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 00                	mov    (%eax),%eax
  8009d8:	8d 50 08             	lea    0x8(%eax),%edx
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	89 10                	mov    %edx,(%eax)
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	83 e8 08             	sub    $0x8,%eax
  8009e8:	8b 50 04             	mov    0x4(%eax),%edx
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	eb 38                	jmp    800a27 <getint+0x5d>
	else if (lflag)
  8009ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f3:	74 1a                	je     800a0f <getint+0x45>
		return va_arg(*ap, long);
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	8b 00                	mov    (%eax),%eax
  8009fa:	8d 50 04             	lea    0x4(%eax),%edx
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	89 10                	mov    %edx,(%eax)
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	8b 00                	mov    (%eax),%eax
  800a07:	83 e8 04             	sub    $0x4,%eax
  800a0a:	8b 00                	mov    (%eax),%eax
  800a0c:	99                   	cltd   
  800a0d:	eb 18                	jmp    800a27 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 00                	mov    (%eax),%eax
  800a14:	8d 50 04             	lea    0x4(%eax),%edx
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	89 10                	mov    %edx,(%eax)
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	8b 00                	mov    (%eax),%eax
  800a21:	83 e8 04             	sub    $0x4,%eax
  800a24:	8b 00                	mov    (%eax),%eax
  800a26:	99                   	cltd   
}
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	56                   	push   %esi
  800a2d:	53                   	push   %ebx
  800a2e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a31:	eb 17                	jmp    800a4a <vprintfmt+0x21>
			if (ch == '\0')
  800a33:	85 db                	test   %ebx,%ebx
  800a35:	0f 84 c1 03 00 00    	je     800dfc <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	53                   	push   %ebx
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4d:	8d 50 01             	lea    0x1(%eax),%edx
  800a50:	89 55 10             	mov    %edx,0x10(%ebp)
  800a53:	8a 00                	mov    (%eax),%al
  800a55:	0f b6 d8             	movzbl %al,%ebx
  800a58:	83 fb 25             	cmp    $0x25,%ebx
  800a5b:	75 d6                	jne    800a33 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a5d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a61:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a68:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a6f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a76:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a80:	8d 50 01             	lea    0x1(%eax),%edx
  800a83:	89 55 10             	mov    %edx,0x10(%ebp)
  800a86:	8a 00                	mov    (%eax),%al
  800a88:	0f b6 d8             	movzbl %al,%ebx
  800a8b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a8e:	83 f8 5b             	cmp    $0x5b,%eax
  800a91:	0f 87 3d 03 00 00    	ja     800dd4 <vprintfmt+0x3ab>
  800a97:	8b 04 85 58 44 80 00 	mov    0x804458(,%eax,4),%eax
  800a9e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800aa0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800aa4:	eb d7                	jmp    800a7d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aa6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800aaa:	eb d1                	jmp    800a7d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ab3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ab6:	89 d0                	mov    %edx,%eax
  800ab8:	c1 e0 02             	shl    $0x2,%eax
  800abb:	01 d0                	add    %edx,%eax
  800abd:	01 c0                	add    %eax,%eax
  800abf:	01 d8                	add    %ebx,%eax
  800ac1:	83 e8 30             	sub    $0x30,%eax
  800ac4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aca:	8a 00                	mov    (%eax),%al
  800acc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800acf:	83 fb 2f             	cmp    $0x2f,%ebx
  800ad2:	7e 3e                	jle    800b12 <vprintfmt+0xe9>
  800ad4:	83 fb 39             	cmp    $0x39,%ebx
  800ad7:	7f 39                	jg     800b12 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800adc:	eb d5                	jmp    800ab3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	83 c0 04             	add    $0x4,%eax
  800ae4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	83 e8 04             	sub    $0x4,%eax
  800aed:	8b 00                	mov    (%eax),%eax
  800aef:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800af2:	eb 1f                	jmp    800b13 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af8:	79 83                	jns    800a7d <vprintfmt+0x54>
				width = 0;
  800afa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b01:	e9 77 ff ff ff       	jmp    800a7d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b06:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b0d:	e9 6b ff ff ff       	jmp    800a7d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b12:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b17:	0f 89 60 ff ff ff    	jns    800a7d <vprintfmt+0x54>
				width = precision, precision = -1;
  800b1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b23:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b2a:	e9 4e ff ff ff       	jmp    800a7d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b2f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b32:	e9 46 ff ff ff       	jmp    800a7d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b37:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3a:	83 c0 04             	add    $0x4,%eax
  800b3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b40:	8b 45 14             	mov    0x14(%ebp),%eax
  800b43:	83 e8 04             	sub    $0x4,%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	50                   	push   %eax
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	ff d0                	call   *%eax
  800b54:	83 c4 10             	add    $0x10,%esp
			break;
  800b57:	e9 9b 02 00 00       	jmp    800df7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5f:	83 c0 04             	add    $0x4,%eax
  800b62:	89 45 14             	mov    %eax,0x14(%ebp)
  800b65:	8b 45 14             	mov    0x14(%ebp),%eax
  800b68:	83 e8 04             	sub    $0x4,%eax
  800b6b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b6d:	85 db                	test   %ebx,%ebx
  800b6f:	79 02                	jns    800b73 <vprintfmt+0x14a>
				err = -err;
  800b71:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b73:	83 fb 64             	cmp    $0x64,%ebx
  800b76:	7f 0b                	jg     800b83 <vprintfmt+0x15a>
  800b78:	8b 34 9d a0 42 80 00 	mov    0x8042a0(,%ebx,4),%esi
  800b7f:	85 f6                	test   %esi,%esi
  800b81:	75 19                	jne    800b9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b83:	53                   	push   %ebx
  800b84:	68 45 44 80 00       	push   $0x804445
  800b89:	ff 75 0c             	pushl  0xc(%ebp)
  800b8c:	ff 75 08             	pushl  0x8(%ebp)
  800b8f:	e8 70 02 00 00       	call   800e04 <printfmt>
  800b94:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b97:	e9 5b 02 00 00       	jmp    800df7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b9c:	56                   	push   %esi
  800b9d:	68 4e 44 80 00       	push   $0x80444e
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 57 02 00 00       	call   800e04 <printfmt>
  800bad:	83 c4 10             	add    $0x10,%esp
			break;
  800bb0:	e9 42 02 00 00       	jmp    800df7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb8:	83 c0 04             	add    $0x4,%eax
  800bbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800bbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc1:	83 e8 04             	sub    $0x4,%eax
  800bc4:	8b 30                	mov    (%eax),%esi
  800bc6:	85 f6                	test   %esi,%esi
  800bc8:	75 05                	jne    800bcf <vprintfmt+0x1a6>
				p = "(null)";
  800bca:	be 51 44 80 00       	mov    $0x804451,%esi
			if (width > 0 && padc != '-')
  800bcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd3:	7e 6d                	jle    800c42 <vprintfmt+0x219>
  800bd5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bd9:	74 67                	je     800c42 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	50                   	push   %eax
  800be2:	56                   	push   %esi
  800be3:	e8 1e 03 00 00       	call   800f06 <strnlen>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bee:	eb 16                	jmp    800c06 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bf0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	50                   	push   %eax
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	ff d0                	call   *%eax
  800c00:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c03:	ff 4d e4             	decl   -0x1c(%ebp)
  800c06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c0a:	7f e4                	jg     800bf0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c0c:	eb 34                	jmp    800c42 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c12:	74 1c                	je     800c30 <vprintfmt+0x207>
  800c14:	83 fb 1f             	cmp    $0x1f,%ebx
  800c17:	7e 05                	jle    800c1e <vprintfmt+0x1f5>
  800c19:	83 fb 7e             	cmp    $0x7e,%ebx
  800c1c:	7e 12                	jle    800c30 <vprintfmt+0x207>
					putch('?', putdat);
  800c1e:	83 ec 08             	sub    $0x8,%esp
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	6a 3f                	push   $0x3f
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	ff d0                	call   *%eax
  800c2b:	83 c4 10             	add    $0x10,%esp
  800c2e:	eb 0f                	jmp    800c3f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c30:	83 ec 08             	sub    $0x8,%esp
  800c33:	ff 75 0c             	pushl  0xc(%ebp)
  800c36:	53                   	push   %ebx
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800c42:	89 f0                	mov    %esi,%eax
  800c44:	8d 70 01             	lea    0x1(%eax),%esi
  800c47:	8a 00                	mov    (%eax),%al
  800c49:	0f be d8             	movsbl %al,%ebx
  800c4c:	85 db                	test   %ebx,%ebx
  800c4e:	74 24                	je     800c74 <vprintfmt+0x24b>
  800c50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c54:	78 b8                	js     800c0e <vprintfmt+0x1e5>
  800c56:	ff 4d e0             	decl   -0x20(%ebp)
  800c59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c5d:	79 af                	jns    800c0e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c5f:	eb 13                	jmp    800c74 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	ff 75 0c             	pushl  0xc(%ebp)
  800c67:	6a 20                	push   $0x20
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	ff d0                	call   *%eax
  800c6e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c71:	ff 4d e4             	decl   -0x1c(%ebp)
  800c74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c78:	7f e7                	jg     800c61 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c7a:	e9 78 01 00 00       	jmp    800df7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 e8             	pushl  -0x18(%ebp)
  800c85:	8d 45 14             	lea    0x14(%ebp),%eax
  800c88:	50                   	push   %eax
  800c89:	e8 3c fd ff ff       	call   8009ca <getint>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9d:	85 d2                	test   %edx,%edx
  800c9f:	79 23                	jns    800cc4 <vprintfmt+0x29b>
				putch('-', putdat);
  800ca1:	83 ec 08             	sub    $0x8,%esp
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	6a 2d                	push   $0x2d
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	ff d0                	call   *%eax
  800cae:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb7:	f7 d8                	neg    %eax
  800cb9:	83 d2 00             	adc    $0x0,%edx
  800cbc:	f7 da                	neg    %edx
  800cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cc4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ccb:	e9 bc 00 00 00       	jmp    800d8c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cd0:	83 ec 08             	sub    $0x8,%esp
  800cd3:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd6:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd9:	50                   	push   %eax
  800cda:	e8 84 fc ff ff       	call   800963 <getuint>
  800cdf:	83 c4 10             	add    $0x10,%esp
  800ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ce8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cef:	e9 98 00 00 00       	jmp    800d8c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cf4:	83 ec 08             	sub    $0x8,%esp
  800cf7:	ff 75 0c             	pushl  0xc(%ebp)
  800cfa:	6a 58                	push   $0x58
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	ff d0                	call   *%eax
  800d01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d04:	83 ec 08             	sub    $0x8,%esp
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	6a 58                	push   $0x58
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	ff d0                	call   *%eax
  800d11:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d14:	83 ec 08             	sub    $0x8,%esp
  800d17:	ff 75 0c             	pushl  0xc(%ebp)
  800d1a:	6a 58                	push   $0x58
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	ff d0                	call   *%eax
  800d21:	83 c4 10             	add    $0x10,%esp
			break;
  800d24:	e9 ce 00 00 00       	jmp    800df7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d29:	83 ec 08             	sub    $0x8,%esp
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	6a 30                	push   $0x30
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	ff d0                	call   *%eax
  800d36:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d39:	83 ec 08             	sub    $0x8,%esp
  800d3c:	ff 75 0c             	pushl  0xc(%ebp)
  800d3f:	6a 78                	push   $0x78
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	ff d0                	call   *%eax
  800d46:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d49:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4c:	83 c0 04             	add    $0x4,%eax
  800d4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	83 e8 04             	sub    $0x4,%eax
  800d58:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d64:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d6b:	eb 1f                	jmp    800d8c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d6d:	83 ec 08             	sub    $0x8,%esp
  800d70:	ff 75 e8             	pushl  -0x18(%ebp)
  800d73:	8d 45 14             	lea    0x14(%ebp),%eax
  800d76:	50                   	push   %eax
  800d77:	e8 e7 fb ff ff       	call   800963 <getuint>
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d8c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d93:	83 ec 04             	sub    $0x4,%esp
  800d96:	52                   	push   %edx
  800d97:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d9a:	50                   	push   %eax
  800d9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9e:	ff 75 f0             	pushl  -0x10(%ebp)
  800da1:	ff 75 0c             	pushl  0xc(%ebp)
  800da4:	ff 75 08             	pushl  0x8(%ebp)
  800da7:	e8 00 fb ff ff       	call   8008ac <printnum>
  800dac:	83 c4 20             	add    $0x20,%esp
			break;
  800daf:	eb 46                	jmp    800df7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800db1:	83 ec 08             	sub    $0x8,%esp
  800db4:	ff 75 0c             	pushl  0xc(%ebp)
  800db7:	53                   	push   %ebx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	ff d0                	call   *%eax
  800dbd:	83 c4 10             	add    $0x10,%esp
			break;
  800dc0:	eb 35                	jmp    800df7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800dc2:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800dc9:	eb 2c                	jmp    800df7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800dcb:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800dd2:	eb 23                	jmp    800df7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd4:	83 ec 08             	sub    $0x8,%esp
  800dd7:	ff 75 0c             	pushl  0xc(%ebp)
  800dda:	6a 25                	push   $0x25
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	ff d0                	call   *%eax
  800de1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de4:	ff 4d 10             	decl   0x10(%ebp)
  800de7:	eb 03                	jmp    800dec <vprintfmt+0x3c3>
  800de9:	ff 4d 10             	decl   0x10(%ebp)
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	48                   	dec    %eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	3c 25                	cmp    $0x25,%al
  800df4:	75 f3                	jne    800de9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800df6:	90                   	nop
		}
	}
  800df7:	e9 35 fc ff ff       	jmp    800a31 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dfc:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e0a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0d:	83 c0 04             	add    $0x4,%eax
  800e10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	ff 75 f4             	pushl  -0xc(%ebp)
  800e19:	50                   	push   %eax
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 04 fc ff ff       	call   800a29 <vprintfmt>
  800e25:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e28:	90                   	nop
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e31:	8b 40 08             	mov    0x8(%eax),%eax
  800e34:	8d 50 01             	lea    0x1(%eax),%edx
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e40:	8b 10                	mov    (%eax),%edx
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	8b 40 04             	mov    0x4(%eax),%eax
  800e48:	39 c2                	cmp    %eax,%edx
  800e4a:	73 12                	jae    800e5e <sprintputch+0x33>
		*b->buf++ = ch;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	8b 00                	mov    (%eax),%eax
  800e51:	8d 48 01             	lea    0x1(%eax),%ecx
  800e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e57:	89 0a                	mov    %ecx,(%edx)
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	88 10                	mov    %dl,(%eax)
}
  800e5e:	90                   	nop
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    

00800e61 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	01 d0                	add    %edx,%eax
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e86:	74 06                	je     800e8e <vsnprintf+0x2d>
  800e88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8c:	7f 07                	jg     800e95 <vsnprintf+0x34>
		return -E_INVAL;
  800e8e:	b8 03 00 00 00       	mov    $0x3,%eax
  800e93:	eb 20                	jmp    800eb5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e95:	ff 75 14             	pushl  0x14(%ebp)
  800e98:	ff 75 10             	pushl  0x10(%ebp)
  800e9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e9e:	50                   	push   %eax
  800e9f:	68 2b 0e 80 00       	push   $0x800e2b
  800ea4:	e8 80 fb ff ff       	call   800a29 <vprintfmt>
  800ea9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eaf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eb5:	c9                   	leave  
  800eb6:	c3                   	ret    

00800eb7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ebd:	8d 45 10             	lea    0x10(%ebp),%eax
  800ec0:	83 c0 04             	add    $0x4,%eax
  800ec3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ec6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec9:	ff 75 f4             	pushl  -0xc(%ebp)
  800ecc:	50                   	push   %eax
  800ecd:	ff 75 0c             	pushl  0xc(%ebp)
  800ed0:	ff 75 08             	pushl  0x8(%ebp)
  800ed3:	e8 89 ff ff ff       	call   800e61 <vsnprintf>
  800ed8:	83 c4 10             	add    $0x10,%esp
  800edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ee9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef0:	eb 06                	jmp    800ef8 <strlen+0x15>
		n++;
  800ef2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef5:	ff 45 08             	incl   0x8(%ebp)
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	84 c0                	test   %al,%al
  800eff:	75 f1                	jne    800ef2 <strlen+0xf>
		n++;
	return n;
  800f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f04:	c9                   	leave  
  800f05:	c3                   	ret    

00800f06 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f13:	eb 09                	jmp    800f1e <strnlen+0x18>
		n++;
  800f15:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f18:	ff 45 08             	incl   0x8(%ebp)
  800f1b:	ff 4d 0c             	decl   0xc(%ebp)
  800f1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f22:	74 09                	je     800f2d <strnlen+0x27>
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	84 c0                	test   %al,%al
  800f2b:	75 e8                	jne    800f15 <strnlen+0xf>
		n++;
	return n;
  800f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f3e:	90                   	nop
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8d 50 01             	lea    0x1(%eax),%edx
  800f45:	89 55 08             	mov    %edx,0x8(%ebp)
  800f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f4e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f51:	8a 12                	mov    (%edx),%dl
  800f53:	88 10                	mov    %dl,(%eax)
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	84 c0                	test   %al,%al
  800f59:	75 e4                	jne    800f3f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f5e:	c9                   	leave  
  800f5f:	c3                   	ret    

00800f60 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f73:	eb 1f                	jmp    800f94 <strncpy+0x34>
		*dst++ = *src;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8d 50 01             	lea    0x1(%eax),%edx
  800f7b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f81:	8a 12                	mov    (%edx),%dl
  800f83:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	84 c0                	test   %al,%al
  800f8c:	74 03                	je     800f91 <strncpy+0x31>
			src++;
  800f8e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f91:	ff 45 fc             	incl   -0x4(%ebp)
  800f94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f97:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f9a:	72 d9                	jb     800f75 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    

00800fa1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb1:	74 30                	je     800fe3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fb3:	eb 16                	jmp    800fcb <strlcpy+0x2a>
			*dst++ = *src++;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8d 50 01             	lea    0x1(%eax),%edx
  800fbb:	89 55 08             	mov    %edx,0x8(%ebp)
  800fbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fc7:	8a 12                	mov    (%edx),%dl
  800fc9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fcb:	ff 4d 10             	decl   0x10(%ebp)
  800fce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd2:	74 09                	je     800fdd <strlcpy+0x3c>
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	84 c0                	test   %al,%al
  800fdb:	75 d8                	jne    800fb5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe9:	29 c2                	sub    %eax,%edx
  800feb:	89 d0                	mov    %edx,%eax
}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    

00800fef <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ff2:	eb 06                	jmp    800ffa <strcmp+0xb>
		p++, q++;
  800ff4:	ff 45 08             	incl   0x8(%ebp)
  800ff7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	84 c0                	test   %al,%al
  801001:	74 0e                	je     801011 <strcmp+0x22>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 10                	mov    (%eax),%dl
  801008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	38 c2                	cmp    %al,%dl
  80100f:	74 e3                	je     800ff4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	0f b6 d0             	movzbl %al,%edx
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	0f b6 c0             	movzbl %al,%eax
  801021:	29 c2                	sub    %eax,%edx
  801023:	89 d0                	mov    %edx,%eax
}
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80102a:	eb 09                	jmp    801035 <strncmp+0xe>
		n--, p++, q++;
  80102c:	ff 4d 10             	decl   0x10(%ebp)
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801035:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801039:	74 17                	je     801052 <strncmp+0x2b>
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	84 c0                	test   %al,%al
  801042:	74 0e                	je     801052 <strncmp+0x2b>
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 10                	mov    (%eax),%dl
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	38 c2                	cmp    %al,%dl
  801050:	74 da                	je     80102c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801052:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801056:	75 07                	jne    80105f <strncmp+0x38>
		return 0;
  801058:	b8 00 00 00 00       	mov    $0x0,%eax
  80105d:	eb 14                	jmp    801073 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	0f b6 d0             	movzbl %al,%edx
  801067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106a:	8a 00                	mov    (%eax),%al
  80106c:	0f b6 c0             	movzbl %al,%eax
  80106f:	29 c2                	sub    %eax,%edx
  801071:	89 d0                	mov    %edx,%eax
}
  801073:	5d                   	pop    %ebp
  801074:	c3                   	ret    

00801075 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 04             	sub    $0x4,%esp
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801081:	eb 12                	jmp    801095 <strchr+0x20>
		if (*s == c)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80108b:	75 05                	jne    801092 <strchr+0x1d>
			return (char *) s;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	eb 11                	jmp    8010a3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801092:	ff 45 08             	incl   0x8(%ebp)
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	84 c0                	test   %al,%al
  80109c:	75 e5                	jne    801083 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80109e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 04             	sub    $0x4,%esp
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b1:	eb 0d                	jmp    8010c0 <strfind+0x1b>
		if (*s == c)
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010bb:	74 0e                	je     8010cb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010bd:	ff 45 08             	incl   0x8(%ebp)
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	75 ea                	jne    8010b3 <strfind+0xe>
  8010c9:	eb 01                	jmp    8010cc <strfind+0x27>
		if (*s == c)
			break;
  8010cb:	90                   	nop
	return (char *) s;
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010e3:	eb 0e                	jmp    8010f3 <memset+0x22>
		*p++ = c;
  8010e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010f3:	ff 4d f8             	decl   -0x8(%ebp)
  8010f6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010fa:	79 e9                	jns    8010e5 <memset+0x14>
		*p++ = c;

	return v;
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801113:	eb 16                	jmp    80112b <memcpy+0x2a>
		*d++ = *s++;
  801115:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801118:	8d 50 01             	lea    0x1(%eax),%edx
  80111b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80111e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801121:	8d 4a 01             	lea    0x1(%edx),%ecx
  801124:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801127:	8a 12                	mov    (%edx),%dl
  801129:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80112b:	8b 45 10             	mov    0x10(%ebp),%eax
  80112e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801131:	89 55 10             	mov    %edx,0x10(%ebp)
  801134:	85 c0                	test   %eax,%eax
  801136:	75 dd                	jne    801115 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80114f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801152:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801155:	73 50                	jae    8011a7 <memmove+0x6a>
  801157:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115a:	8b 45 10             	mov    0x10(%ebp),%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801162:	76 43                	jbe    8011a7 <memmove+0x6a>
		s += n;
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80116a:	8b 45 10             	mov    0x10(%ebp),%eax
  80116d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801170:	eb 10                	jmp    801182 <memmove+0x45>
			*--d = *--s;
  801172:	ff 4d f8             	decl   -0x8(%ebp)
  801175:	ff 4d fc             	decl   -0x4(%ebp)
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	8a 10                	mov    (%eax),%dl
  80117d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801180:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801182:	8b 45 10             	mov    0x10(%ebp),%eax
  801185:	8d 50 ff             	lea    -0x1(%eax),%edx
  801188:	89 55 10             	mov    %edx,0x10(%ebp)
  80118b:	85 c0                	test   %eax,%eax
  80118d:	75 e3                	jne    801172 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80118f:	eb 23                	jmp    8011b4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	8d 50 01             	lea    0x1(%eax),%edx
  801197:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a3:	8a 12                	mov    (%edx),%dl
  8011a5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	75 dd                	jne    801191 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b7:	c9                   	leave  
  8011b8:	c3                   	ret    

008011b9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011cb:	eb 2a                	jmp    8011f7 <memcmp+0x3e>
		if (*s1 != *s2)
  8011cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d0:	8a 10                	mov    (%eax),%dl
  8011d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	38 c2                	cmp    %al,%dl
  8011d9:	74 16                	je     8011f1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	0f b6 d0             	movzbl %al,%edx
  8011e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	0f b6 c0             	movzbl %al,%eax
  8011eb:	29 c2                	sub    %eax,%edx
  8011ed:	89 d0                	mov    %edx,%eax
  8011ef:	eb 18                	jmp    801209 <memcmp+0x50>
		s1++, s2++;
  8011f1:	ff 45 fc             	incl   -0x4(%ebp)
  8011f4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011fd:	89 55 10             	mov    %edx,0x10(%ebp)
  801200:	85 c0                	test   %eax,%eax
  801202:	75 c9                	jne    8011cd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801211:	8b 55 08             	mov    0x8(%ebp),%edx
  801214:	8b 45 10             	mov    0x10(%ebp),%eax
  801217:	01 d0                	add    %edx,%eax
  801219:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80121c:	eb 15                	jmp    801233 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f b6 d0             	movzbl %al,%edx
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	0f b6 c0             	movzbl %al,%eax
  80122c:	39 c2                	cmp    %eax,%edx
  80122e:	74 0d                	je     80123d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801230:	ff 45 08             	incl   0x8(%ebp)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801239:	72 e3                	jb     80121e <memfind+0x13>
  80123b:	eb 01                	jmp    80123e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80123d:	90                   	nop
	return (void *) s;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801249:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801250:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801257:	eb 03                	jmp    80125c <strtol+0x19>
		s++;
  801259:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	3c 20                	cmp    $0x20,%al
  801263:	74 f4                	je     801259 <strtol+0x16>
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	8a 00                	mov    (%eax),%al
  80126a:	3c 09                	cmp    $0x9,%al
  80126c:	74 eb                	je     801259 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	3c 2b                	cmp    $0x2b,%al
  801275:	75 05                	jne    80127c <strtol+0x39>
		s++;
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	eb 13                	jmp    80128f <strtol+0x4c>
	else if (*s == '-')
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	3c 2d                	cmp    $0x2d,%al
  801283:	75 0a                	jne    80128f <strtol+0x4c>
		s++, neg = 1;
  801285:	ff 45 08             	incl   0x8(%ebp)
  801288:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80128f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801293:	74 06                	je     80129b <strtol+0x58>
  801295:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801299:	75 20                	jne    8012bb <strtol+0x78>
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8a 00                	mov    (%eax),%al
  8012a0:	3c 30                	cmp    $0x30,%al
  8012a2:	75 17                	jne    8012bb <strtol+0x78>
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	40                   	inc    %eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	3c 78                	cmp    $0x78,%al
  8012ac:	75 0d                	jne    8012bb <strtol+0x78>
		s += 2, base = 16;
  8012ae:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012b9:	eb 28                	jmp    8012e3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012bf:	75 15                	jne    8012d6 <strtol+0x93>
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	3c 30                	cmp    $0x30,%al
  8012c8:	75 0c                	jne    8012d6 <strtol+0x93>
		s++, base = 8;
  8012ca:	ff 45 08             	incl   0x8(%ebp)
  8012cd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d4:	eb 0d                	jmp    8012e3 <strtol+0xa0>
	else if (base == 0)
  8012d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012da:	75 07                	jne    8012e3 <strtol+0xa0>
		base = 10;
  8012dc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8a 00                	mov    (%eax),%al
  8012e8:	3c 2f                	cmp    $0x2f,%al
  8012ea:	7e 19                	jle    801305 <strtol+0xc2>
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8a 00                	mov    (%eax),%al
  8012f1:	3c 39                	cmp    $0x39,%al
  8012f3:	7f 10                	jg     801305 <strtol+0xc2>
			dig = *s - '0';
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	0f be c0             	movsbl %al,%eax
  8012fd:	83 e8 30             	sub    $0x30,%eax
  801300:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801303:	eb 42                	jmp    801347 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	3c 60                	cmp    $0x60,%al
  80130c:	7e 19                	jle    801327 <strtol+0xe4>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	3c 7a                	cmp    $0x7a,%al
  801315:	7f 10                	jg     801327 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f be c0             	movsbl %al,%eax
  80131f:	83 e8 57             	sub    $0x57,%eax
  801322:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801325:	eb 20                	jmp    801347 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	3c 40                	cmp    $0x40,%al
  80132e:	7e 39                	jle    801369 <strtol+0x126>
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	3c 5a                	cmp    $0x5a,%al
  801337:	7f 30                	jg     801369 <strtol+0x126>
			dig = *s - 'A' + 10;
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	0f be c0             	movsbl %al,%eax
  801341:	83 e8 37             	sub    $0x37,%eax
  801344:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80134d:	7d 19                	jge    801368 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80134f:	ff 45 08             	incl   0x8(%ebp)
  801352:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801355:	0f af 45 10          	imul   0x10(%ebp),%eax
  801359:	89 c2                	mov    %eax,%edx
  80135b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801363:	e9 7b ff ff ff       	jmp    8012e3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801368:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801369:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80136d:	74 08                	je     801377 <strtol+0x134>
		*endptr = (char *) s;
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	8b 55 08             	mov    0x8(%ebp),%edx
  801375:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801377:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137b:	74 07                	je     801384 <strtol+0x141>
  80137d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801380:	f7 d8                	neg    %eax
  801382:	eb 03                	jmp    801387 <strtol+0x144>
  801384:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <ltostr>:

void
ltostr(long value, char *str)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801396:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80139d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a1:	79 13                	jns    8013b6 <ltostr+0x2d>
	{
		neg = 1;
  8013a3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ad:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013be:	99                   	cltd   
  8013bf:	f7 f9                	idiv   %ecx
  8013c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013cd:	89 c2                	mov    %eax,%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d7:	83 c2 30             	add    $0x30,%edx
  8013da:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013df:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e4:	f7 e9                	imul   %ecx
  8013e6:	c1 fa 02             	sar    $0x2,%edx
  8013e9:	89 c8                	mov    %ecx,%eax
  8013eb:	c1 f8 1f             	sar    $0x1f,%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
  8013f2:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f9:	75 bb                	jne    8013b6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801402:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801405:	48                   	dec    %eax
  801406:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801409:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80140d:	74 3d                	je     80144c <ltostr+0xc3>
		start = 1 ;
  80140f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801416:	eb 34                	jmp    80144c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801418:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141e:	01 d0                	add    %edx,%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801425:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	01 c2                	add    %eax,%edx
  80142d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801430:	8b 45 0c             	mov    0xc(%ebp),%eax
  801433:	01 c8                	add    %ecx,%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801439:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	01 c2                	add    %eax,%edx
  801441:	8a 45 eb             	mov    -0x15(%ebp),%al
  801444:	88 02                	mov    %al,(%edx)
		start++ ;
  801446:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801449:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80144c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801452:	7c c4                	jl     801418 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801454:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145a:	01 d0                	add    %edx,%eax
  80145c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80145f:	90                   	nop
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801468:	ff 75 08             	pushl  0x8(%ebp)
  80146b:	e8 73 fa ff ff       	call   800ee3 <strlen>
  801470:	83 c4 04             	add    $0x4,%esp
  801473:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801476:	ff 75 0c             	pushl  0xc(%ebp)
  801479:	e8 65 fa ff ff       	call   800ee3 <strlen>
  80147e:	83 c4 04             	add    $0x4,%esp
  801481:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801484:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80148b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801492:	eb 17                	jmp    8014ab <strcconcat+0x49>
		final[s] = str1[s] ;
  801494:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801497:	8b 45 10             	mov    0x10(%ebp),%eax
  80149a:	01 c2                	add    %eax,%edx
  80149c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	01 c8                	add    %ecx,%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014a8:	ff 45 fc             	incl   -0x4(%ebp)
  8014ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014b1:	7c e1                	jl     801494 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014c1:	eb 1f                	jmp    8014e2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c6:	8d 50 01             	lea    0x1(%eax),%edx
  8014c9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014cc:	89 c2                	mov    %eax,%edx
  8014ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d1:	01 c2                	add    %eax,%edx
  8014d3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	01 c8                	add    %ecx,%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014df:	ff 45 f8             	incl   -0x8(%ebp)
  8014e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e8:	7c d9                	jl     8014c3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	01 d0                	add    %edx,%eax
  8014f2:	c6 00 00             	movb   $0x0,(%eax)
}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	8b 00                	mov    (%eax),%eax
  801509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	01 d0                	add    %edx,%eax
  801515:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80151b:	eb 0c                	jmp    801529 <strsplit+0x31>
			*string++ = 0;
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8d 50 01             	lea    0x1(%eax),%edx
  801523:	89 55 08             	mov    %edx,0x8(%ebp)
  801526:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	84 c0                	test   %al,%al
  801530:	74 18                	je     80154a <strsplit+0x52>
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	0f be c0             	movsbl %al,%eax
  80153a:	50                   	push   %eax
  80153b:	ff 75 0c             	pushl  0xc(%ebp)
  80153e:	e8 32 fb ff ff       	call   801075 <strchr>
  801543:	83 c4 08             	add    $0x8,%esp
  801546:	85 c0                	test   %eax,%eax
  801548:	75 d3                	jne    80151d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	84 c0                	test   %al,%al
  801551:	74 5a                	je     8015ad <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801553:	8b 45 14             	mov    0x14(%ebp),%eax
  801556:	8b 00                	mov    (%eax),%eax
  801558:	83 f8 0f             	cmp    $0xf,%eax
  80155b:	75 07                	jne    801564 <strsplit+0x6c>
		{
			return 0;
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
  801562:	eb 66                	jmp    8015ca <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801564:	8b 45 14             	mov    0x14(%ebp),%eax
  801567:	8b 00                	mov    (%eax),%eax
  801569:	8d 48 01             	lea    0x1(%eax),%ecx
  80156c:	8b 55 14             	mov    0x14(%ebp),%edx
  80156f:	89 0a                	mov    %ecx,(%edx)
  801571:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801578:	8b 45 10             	mov    0x10(%ebp),%eax
  80157b:	01 c2                	add    %eax,%edx
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801582:	eb 03                	jmp    801587 <strsplit+0x8f>
			string++;
  801584:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	84 c0                	test   %al,%al
  80158e:	74 8b                	je     80151b <strsplit+0x23>
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	0f be c0             	movsbl %al,%eax
  801598:	50                   	push   %eax
  801599:	ff 75 0c             	pushl  0xc(%ebp)
  80159c:	e8 d4 fa ff ff       	call   801075 <strchr>
  8015a1:	83 c4 08             	add    $0x8,%esp
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	74 dc                	je     801584 <strsplit+0x8c>
			string++;
	}
  8015a8:	e9 6e ff ff ff       	jmp    80151b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015ad:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b1:	8b 00                	mov    (%eax),%eax
  8015b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bd:	01 d0                	add    %edx,%eax
  8015bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	68 c8 45 80 00       	push   $0x8045c8
  8015da:	68 3f 01 00 00       	push   $0x13f
  8015df:	68 ea 45 80 00       	push   $0x8045ea
  8015e4:	e8 a9 ef ff ff       	call   800592 <_panic>

008015e9 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8015ef:	83 ec 0c             	sub    $0xc,%esp
  8015f2:	ff 75 08             	pushl  0x8(%ebp)
  8015f5:	e8 9d 0a 00 00       	call   802097 <sys_sbrk>
  8015fa:	83 c4 10             	add    $0x10,%esp
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801605:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801609:	75 0a                	jne    801615 <malloc+0x16>
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
  801610:	e9 07 02 00 00       	jmp    80181c <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801615:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80161c:	8b 55 08             	mov    0x8(%ebp),%edx
  80161f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	48                   	dec    %eax
  801625:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801628:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80162b:	ba 00 00 00 00       	mov    $0x0,%edx
  801630:	f7 75 dc             	divl   -0x24(%ebp)
  801633:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801636:	29 d0                	sub    %edx,%eax
  801638:	c1 e8 0c             	shr    $0xc,%eax
  80163b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80163e:	a1 20 50 80 00       	mov    0x805020,%eax
  801643:	8b 40 78             	mov    0x78(%eax),%eax
  801646:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80164b:	29 c2                	sub    %eax,%edx
  80164d:	89 d0                	mov    %edx,%eax
  80164f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801652:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801655:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80165a:	c1 e8 0c             	shr    $0xc,%eax
  80165d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801660:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801667:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80166e:	77 42                	ja     8016b2 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801670:	e8 a6 08 00 00       	call   801f1b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801675:	85 c0                	test   %eax,%eax
  801677:	74 16                	je     80168f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	e8 e6 0d 00 00       	call   80246a <alloc_block_FF>
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168a:	e9 8a 01 00 00       	jmp    801819 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80168f:	e8 b8 08 00 00       	call   801f4c <sys_isUHeapPlacementStrategyBESTFIT>
  801694:	85 c0                	test   %eax,%eax
  801696:	0f 84 7d 01 00 00    	je     801819 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	e8 7f 12 00 00       	call   802926 <alloc_block_BF>
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ad:	e9 67 01 00 00       	jmp    801819 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8016b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016b5:	48                   	dec    %eax
  8016b6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8016b9:	0f 86 53 01 00 00    	jbe    801812 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8016bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8016c4:	8b 40 78             	mov    0x78(%eax),%eax
  8016c7:	05 00 10 00 00       	add    $0x1000,%eax
  8016cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8016cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8016d6:	e9 de 00 00 00       	jmp    8017b9 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8016db:	a1 20 50 80 00       	mov    0x805020,%eax
  8016e0:	8b 40 78             	mov    0x78(%eax),%eax
  8016e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016e6:	29 c2                	sub    %eax,%edx
  8016e8:	89 d0                	mov    %edx,%eax
  8016ea:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016ef:	c1 e8 0c             	shr    $0xc,%eax
  8016f2:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	0f 85 ab 00 00 00    	jne    8017ac <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801704:	05 00 10 00 00       	add    $0x1000,%eax
  801709:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80170c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801713:	eb 47                	jmp    80175c <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801715:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80171c:	76 0a                	jbe    801728 <malloc+0x129>
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
  801723:	e9 f4 00 00 00       	jmp    80181c <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801728:	a1 20 50 80 00       	mov    0x805020,%eax
  80172d:	8b 40 78             	mov    0x78(%eax),%eax
  801730:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801733:	29 c2                	sub    %eax,%edx
  801735:	89 d0                	mov    %edx,%eax
  801737:	2d 00 10 00 00       	sub    $0x1000,%eax
  80173c:	c1 e8 0c             	shr    $0xc,%eax
  80173f:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801746:	85 c0                	test   %eax,%eax
  801748:	74 08                	je     801752 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  80174a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801750:	eb 5a                	jmp    8017ac <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801752:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801759:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80175c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80175f:	48                   	dec    %eax
  801760:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801763:	77 b0                	ja     801715 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801765:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  80176c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801773:	eb 2f                	jmp    8017a4 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801775:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801778:	c1 e0 0c             	shl    $0xc,%eax
  80177b:	89 c2                	mov    %eax,%edx
  80177d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801780:	01 c2                	add    %eax,%edx
  801782:	a1 20 50 80 00       	mov    0x805020,%eax
  801787:	8b 40 78             	mov    0x78(%eax),%eax
  80178a:	29 c2                	sub    %eax,%edx
  80178c:	89 d0                	mov    %edx,%eax
  80178e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801793:	c1 e8 0c             	shr    $0xc,%eax
  801796:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  80179d:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8017a1:	ff 45 e0             	incl   -0x20(%ebp)
  8017a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017aa:	72 c9                	jb     801775 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8017ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017b0:	75 16                	jne    8017c8 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8017b2:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8017b9:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8017c0:	0f 86 15 ff ff ff    	jbe    8016db <malloc+0xdc>
  8017c6:	eb 01                	jmp    8017c9 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8017c8:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8017c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017cd:	75 07                	jne    8017d6 <malloc+0x1d7>
  8017cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d4:	eb 46                	jmp    80181c <malloc+0x21d>
		ptr = (void*)i;
  8017d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8017dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8017e1:	8b 40 78             	mov    0x78(%eax),%eax
  8017e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e7:	29 c2                	sub    %eax,%edx
  8017e9:	89 d0                	mov    %edx,%eax
  8017eb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017f0:	c1 e8 0c             	shr    $0xc,%eax
  8017f3:	89 c2                	mov    %eax,%edx
  8017f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017f8:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8017ff:	83 ec 08             	sub    $0x8,%esp
  801802:	ff 75 08             	pushl  0x8(%ebp)
  801805:	ff 75 f0             	pushl  -0x10(%ebp)
  801808:	e8 c1 08 00 00       	call   8020ce <sys_allocate_user_mem>
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	eb 07                	jmp    801819 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801812:	b8 00 00 00 00       	mov    $0x0,%eax
  801817:	eb 03                	jmp    80181c <malloc+0x21d>
	}
	return ptr;
  801819:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801824:	a1 20 50 80 00       	mov    0x805020,%eax
  801829:	8b 40 78             	mov    0x78(%eax),%eax
  80182c:	05 00 10 00 00       	add    $0x1000,%eax
  801831:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801834:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80183b:	a1 20 50 80 00       	mov    0x805020,%eax
  801840:	8b 50 78             	mov    0x78(%eax),%edx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	39 c2                	cmp    %eax,%edx
  801848:	76 24                	jbe    80186e <free+0x50>
		size = get_block_size(va);
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	e8 95 08 00 00       	call   8020ea <get_block_size>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 c8 1a 00 00       	call   80332e <free_block>
  801866:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801869:	e9 ac 00 00 00       	jmp    80191a <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801874:	0f 82 89 00 00 00    	jb     801903 <free+0xe5>
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801882:	77 7f                	ja     801903 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801884:	8b 55 08             	mov    0x8(%ebp),%edx
  801887:	a1 20 50 80 00       	mov    0x805020,%eax
  80188c:	8b 40 78             	mov    0x78(%eax),%eax
  80188f:	29 c2                	sub    %eax,%edx
  801891:	89 d0                	mov    %edx,%eax
  801893:	2d 00 10 00 00       	sub    $0x1000,%eax
  801898:	c1 e8 0c             	shr    $0xc,%eax
  80189b:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8018a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8018a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a8:	c1 e0 0c             	shl    $0xc,%eax
  8018ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8018ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8018b5:	eb 2f                	jmp    8018e6 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8018b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ba:	c1 e0 0c             	shl    $0xc,%eax
  8018bd:	89 c2                	mov    %eax,%edx
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	01 c2                	add    %eax,%edx
  8018c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8018c9:	8b 40 78             	mov    0x78(%eax),%eax
  8018cc:	29 c2                	sub    %eax,%edx
  8018ce:	89 d0                	mov    %edx,%eax
  8018d0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018d5:	c1 e8 0c             	shr    $0xc,%eax
  8018d8:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  8018df:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8018e3:	ff 45 f4             	incl   -0xc(%ebp)
  8018e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018ec:	72 c9                	jb     8018b7 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	83 ec 08             	sub    $0x8,%esp
  8018f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8018f7:	50                   	push   %eax
  8018f8:	e8 b5 07 00 00       	call   8020b2 <sys_free_user_mem>
  8018fd:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801900:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801901:	eb 17                	jmp    80191a <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801903:	83 ec 04             	sub    $0x4,%esp
  801906:	68 f8 45 80 00       	push   $0x8045f8
  80190b:	68 84 00 00 00       	push   $0x84
  801910:	68 22 46 80 00       	push   $0x804622
  801915:	e8 78 ec ff ff       	call   800592 <_panic>
	}
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 28             	sub    $0x28,%esp
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801928:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80192c:	75 07                	jne    801935 <smalloc+0x19>
  80192e:	b8 00 00 00 00       	mov    $0x0,%eax
  801933:	eb 74                	jmp    8019a9 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801935:	8b 45 0c             	mov    0xc(%ebp),%eax
  801938:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80193b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801942:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801948:	39 d0                	cmp    %edx,%eax
  80194a:	73 02                	jae    80194e <smalloc+0x32>
  80194c:	89 d0                	mov    %edx,%eax
  80194e:	83 ec 0c             	sub    $0xc,%esp
  801951:	50                   	push   %eax
  801952:	e8 a8 fc ff ff       	call   8015ff <malloc>
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80195d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801961:	75 07                	jne    80196a <smalloc+0x4e>
  801963:	b8 00 00 00 00       	mov    $0x0,%eax
  801968:	eb 3f                	jmp    8019a9 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80196a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80196e:	ff 75 ec             	pushl  -0x14(%ebp)
  801971:	50                   	push   %eax
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	e8 3c 03 00 00       	call   801cb9 <sys_createSharedObject>
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801983:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801987:	74 06                	je     80198f <smalloc+0x73>
  801989:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80198d:	75 07                	jne    801996 <smalloc+0x7a>
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
  801994:	eb 13                	jmp    8019a9 <smalloc+0x8d>
	 cprintf("153\n");
  801996:	83 ec 0c             	sub    $0xc,%esp
  801999:	68 2e 46 80 00       	push   $0x80462e
  80199e:	e8 ac ee ff ff       	call   80084f <cprintf>
  8019a3:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8019a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8019b1:	83 ec 08             	sub    $0x8,%esp
  8019b4:	ff 75 0c             	pushl  0xc(%ebp)
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	e8 24 03 00 00       	call   801ce3 <sys_getSizeOfSharedObject>
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8019c5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019c9:	75 07                	jne    8019d2 <sget+0x27>
  8019cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d0:	eb 5c                	jmp    801a2e <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8019d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019d8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e5:	39 d0                	cmp    %edx,%eax
  8019e7:	7d 02                	jge    8019eb <sget+0x40>
  8019e9:	89 d0                	mov    %edx,%eax
  8019eb:	83 ec 0c             	sub    $0xc,%esp
  8019ee:	50                   	push   %eax
  8019ef:	e8 0b fc ff ff       	call   8015ff <malloc>
  8019f4:	83 c4 10             	add    $0x10,%esp
  8019f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8019fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019fe:	75 07                	jne    801a07 <sget+0x5c>
  801a00:	b8 00 00 00 00       	mov    $0x0,%eax
  801a05:	eb 27                	jmp    801a2e <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	ff 75 e8             	pushl  -0x18(%ebp)
  801a0d:	ff 75 0c             	pushl  0xc(%ebp)
  801a10:	ff 75 08             	pushl  0x8(%ebp)
  801a13:	e8 e8 02 00 00       	call   801d00 <sys_getSharedObject>
  801a18:	83 c4 10             	add    $0x10,%esp
  801a1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801a1e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a22:	75 07                	jne    801a2b <sget+0x80>
  801a24:	b8 00 00 00 00       	mov    $0x0,%eax
  801a29:	eb 03                	jmp    801a2e <sget+0x83>
	return ptr;
  801a2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a36:	83 ec 04             	sub    $0x4,%esp
  801a39:	68 34 46 80 00       	push   $0x804634
  801a3e:	68 c2 00 00 00       	push   $0xc2
  801a43:	68 22 46 80 00       	push   $0x804622
  801a48:	e8 45 eb ff ff       	call   800592 <_panic>

00801a4d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a53:	83 ec 04             	sub    $0x4,%esp
  801a56:	68 58 46 80 00       	push   $0x804658
  801a5b:	68 d9 00 00 00       	push   $0xd9
  801a60:	68 22 46 80 00       	push   $0x804622
  801a65:	e8 28 eb ff ff       	call   800592 <_panic>

00801a6a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a70:	83 ec 04             	sub    $0x4,%esp
  801a73:	68 7e 46 80 00       	push   $0x80467e
  801a78:	68 e5 00 00 00       	push   $0xe5
  801a7d:	68 22 46 80 00       	push   $0x804622
  801a82:	e8 0b eb ff ff       	call   800592 <_panic>

00801a87 <shrink>:

}
void shrink(uint32 newSize)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	68 7e 46 80 00       	push   $0x80467e
  801a95:	68 ea 00 00 00       	push   $0xea
  801a9a:	68 22 46 80 00       	push   $0x804622
  801a9f:	e8 ee ea ff ff       	call   800592 <_panic>

00801aa4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aaa:	83 ec 04             	sub    $0x4,%esp
  801aad:	68 7e 46 80 00       	push   $0x80467e
  801ab2:	68 ef 00 00 00       	push   $0xef
  801ab7:	68 22 46 80 00       	push   $0x804622
  801abc:	e8 d1 ea ff ff       	call   800592 <_panic>

00801ac1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	57                   	push   %edi
  801ac5:	56                   	push   %esi
  801ac6:	53                   	push   %ebx
  801ac7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad6:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ad9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801adc:	cd 30                	int    $0x30
  801ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ae4:	83 c4 10             	add    $0x10,%esp
  801ae7:	5b                   	pop    %ebx
  801ae8:	5e                   	pop    %esi
  801ae9:	5f                   	pop    %edi
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	8b 45 10             	mov    0x10(%ebp),%eax
  801af5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801af8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801afc:	8b 45 08             	mov    0x8(%ebp),%eax
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	52                   	push   %edx
  801b04:	ff 75 0c             	pushl  0xc(%ebp)
  801b07:	50                   	push   %eax
  801b08:	6a 00                	push   $0x0
  801b0a:	e8 b2 ff ff ff       	call   801ac1 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	90                   	nop
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 02                	push   $0x2
  801b24:	e8 98 ff ff ff       	call   801ac1 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 03                	push   $0x3
  801b3d:	e8 7f ff ff ff       	call   801ac1 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 04                	push   $0x4
  801b57:	e8 65 ff ff ff       	call   801ac1 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	90                   	nop
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	52                   	push   %edx
  801b72:	50                   	push   %eax
  801b73:	6a 08                	push   $0x8
  801b75:	e8 47 ff ff ff       	call   801ac1 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	56                   	push   %esi
  801b83:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b84:	8b 75 18             	mov    0x18(%ebp),%esi
  801b87:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	56                   	push   %esi
  801b94:	53                   	push   %ebx
  801b95:	51                   	push   %ecx
  801b96:	52                   	push   %edx
  801b97:	50                   	push   %eax
  801b98:	6a 09                	push   $0x9
  801b9a:	e8 22 ff ff ff       	call   801ac1 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba5:	5b                   	pop    %ebx
  801ba6:	5e                   	pop    %esi
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    

00801ba9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	52                   	push   %edx
  801bb9:	50                   	push   %eax
  801bba:	6a 0a                	push   $0xa
  801bbc:	e8 00 ff ff ff       	call   801ac1 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	ff 75 08             	pushl  0x8(%ebp)
  801bd5:	6a 0b                	push   $0xb
  801bd7:	e8 e5 fe ff ff       	call   801ac1 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 0c                	push   $0xc
  801bf0:	e8 cc fe ff ff       	call   801ac1 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 0d                	push   $0xd
  801c09:	e8 b3 fe ff ff       	call   801ac1 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 0e                	push   $0xe
  801c22:	e8 9a fe ff ff       	call   801ac1 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 0f                	push   $0xf
  801c3b:	e8 81 fe ff ff       	call   801ac1 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	ff 75 08             	pushl  0x8(%ebp)
  801c53:	6a 10                	push   $0x10
  801c55:	e8 67 fe ff ff       	call   801ac1 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 11                	push   $0x11
  801c6e:	e8 4e fe ff ff       	call   801ac1 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	90                   	nop
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c85:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	50                   	push   %eax
  801c92:	6a 01                	push   $0x1
  801c94:	e8 28 fe ff ff       	call   801ac1 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	90                   	nop
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 14                	push   $0x14
  801cae:	e8 0e fe ff ff       	call   801ac1 <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	90                   	nop
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cc5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cc8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	6a 00                	push   $0x0
  801cd1:	51                   	push   %ecx
  801cd2:	52                   	push   %edx
  801cd3:	ff 75 0c             	pushl  0xc(%ebp)
  801cd6:	50                   	push   %eax
  801cd7:	6a 15                	push   $0x15
  801cd9:	e8 e3 fd ff ff       	call   801ac1 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	52                   	push   %edx
  801cf3:	50                   	push   %eax
  801cf4:	6a 16                	push   $0x16
  801cf6:	e8 c6 fd ff ff       	call   801ac1 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d03:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	51                   	push   %ecx
  801d11:	52                   	push   %edx
  801d12:	50                   	push   %eax
  801d13:	6a 17                	push   $0x17
  801d15:	e8 a7 fd ff ff       	call   801ac1 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	6a 18                	push   $0x18
  801d32:	e8 8a fd ff ff       	call   801ac1 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	6a 00                	push   $0x0
  801d44:	ff 75 14             	pushl  0x14(%ebp)
  801d47:	ff 75 10             	pushl  0x10(%ebp)
  801d4a:	ff 75 0c             	pushl  0xc(%ebp)
  801d4d:	50                   	push   %eax
  801d4e:	6a 19                	push   $0x19
  801d50:	e8 6c fd ff ff       	call   801ac1 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	50                   	push   %eax
  801d69:	6a 1a                	push   $0x1a
  801d6b:	e8 51 fd ff ff       	call   801ac1 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	90                   	nop
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	50                   	push   %eax
  801d85:	6a 1b                	push   $0x1b
  801d87:	e8 35 fd ff ff       	call   801ac1 <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 05                	push   $0x5
  801da0:	e8 1c fd ff ff       	call   801ac1 <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 06                	push   $0x6
  801db9:	e8 03 fd ff ff       	call   801ac1 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 07                	push   $0x7
  801dd2:	e8 ea fc ff ff       	call   801ac1 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_exit_env>:


void sys_exit_env(void)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 1c                	push   $0x1c
  801deb:	e8 d1 fc ff ff       	call   801ac1 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	90                   	nop
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dfc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dff:	8d 50 04             	lea    0x4(%eax),%edx
  801e02:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	52                   	push   %edx
  801e0c:	50                   	push   %eax
  801e0d:	6a 1d                	push   $0x1d
  801e0f:	e8 ad fc ff ff       	call   801ac1 <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
	return result;
  801e17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e20:	89 01                	mov    %eax,(%ecx)
  801e22:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	c9                   	leave  
  801e29:	c2 04 00             	ret    $0x4

00801e2c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	ff 75 10             	pushl  0x10(%ebp)
  801e36:	ff 75 0c             	pushl  0xc(%ebp)
  801e39:	ff 75 08             	pushl  0x8(%ebp)
  801e3c:	6a 13                	push   $0x13
  801e3e:	e8 7e fc ff ff       	call   801ac1 <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
	return ;
  801e46:	90                   	nop
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 1e                	push   $0x1e
  801e58:	e8 64 fc ff ff       	call   801ac1 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 04             	sub    $0x4,%esp
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e6e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	50                   	push   %eax
  801e7b:	6a 1f                	push   $0x1f
  801e7d:	e8 3f fc ff ff       	call   801ac1 <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
	return ;
  801e85:	90                   	nop
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <rsttst>:
void rsttst()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 21                	push   $0x21
  801e97:	e8 25 fc ff ff       	call   801ac1 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9f:	90                   	nop
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  801eab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801eae:	8b 55 18             	mov    0x18(%ebp),%edx
  801eb1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eb5:	52                   	push   %edx
  801eb6:	50                   	push   %eax
  801eb7:	ff 75 10             	pushl  0x10(%ebp)
  801eba:	ff 75 0c             	pushl  0xc(%ebp)
  801ebd:	ff 75 08             	pushl  0x8(%ebp)
  801ec0:	6a 20                	push   $0x20
  801ec2:	e8 fa fb ff ff       	call   801ac1 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eca:	90                   	nop
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <chktst>:
void chktst(uint32 n)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	ff 75 08             	pushl  0x8(%ebp)
  801edb:	6a 22                	push   $0x22
  801edd:	e8 df fb ff ff       	call   801ac1 <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee5:	90                   	nop
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <inctst>:

void inctst()
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 23                	push   $0x23
  801ef7:	e8 c5 fb ff ff       	call   801ac1 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
	return ;
  801eff:	90                   	nop
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <gettst>:
uint32 gettst()
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 24                	push   $0x24
  801f11:	e8 ab fb ff ff       	call   801ac1 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 25                	push   $0x25
  801f2d:	e8 8f fb ff ff       	call   801ac1 <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
  801f35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f38:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f3c:	75 07                	jne    801f45 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f43:	eb 05                	jmp    801f4a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 25                	push   $0x25
  801f5e:	e8 5e fb ff ff       	call   801ac1 <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
  801f66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f69:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f6d:	75 07                	jne    801f76 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f74:	eb 05                	jmp    801f7b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 25                	push   $0x25
  801f8f:	e8 2d fb ff ff       	call   801ac1 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
  801f97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f9a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f9e:	75 07                	jne    801fa7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fa0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa5:	eb 05                	jmp    801fac <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 25                	push   $0x25
  801fc0:	e8 fc fa ff ff       	call   801ac1 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
  801fc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fcb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fcf:	75 07                	jne    801fd8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd6:	eb 05                	jmp    801fdd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	ff 75 08             	pushl  0x8(%ebp)
  801fed:	6a 26                	push   $0x26
  801fef:	e8 cd fa ff ff       	call   801ac1 <syscall>
  801ff4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff7:	90                   	nop
}
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ffe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802001:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802004:	8b 55 0c             	mov    0xc(%ebp),%edx
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	6a 00                	push   $0x0
  80200c:	53                   	push   %ebx
  80200d:	51                   	push   %ecx
  80200e:	52                   	push   %edx
  80200f:	50                   	push   %eax
  802010:	6a 27                	push   $0x27
  802012:	e8 aa fa ff ff       	call   801ac1 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
}
  80201a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802022:	8b 55 0c             	mov    0xc(%ebp),%edx
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	52                   	push   %edx
  80202f:	50                   	push   %eax
  802030:	6a 28                	push   $0x28
  802032:	e8 8a fa ff ff       	call   801ac1 <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80203f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802042:	8b 55 0c             	mov    0xc(%ebp),%edx
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	6a 00                	push   $0x0
  80204a:	51                   	push   %ecx
  80204b:	ff 75 10             	pushl  0x10(%ebp)
  80204e:	52                   	push   %edx
  80204f:	50                   	push   %eax
  802050:	6a 29                	push   $0x29
  802052:	e8 6a fa ff ff       	call   801ac1 <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	ff 75 10             	pushl  0x10(%ebp)
  802066:	ff 75 0c             	pushl  0xc(%ebp)
  802069:	ff 75 08             	pushl  0x8(%ebp)
  80206c:	6a 12                	push   $0x12
  80206e:	e8 4e fa ff ff       	call   801ac1 <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
	return ;
  802076:	90                   	nop
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80207c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	52                   	push   %edx
  802089:	50                   	push   %eax
  80208a:	6a 2a                	push   $0x2a
  80208c:	e8 30 fa ff ff       	call   801ac1 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
	return;
  802094:	90                   	nop
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	50                   	push   %eax
  8020a6:	6a 2b                	push   $0x2b
  8020a8:	e8 14 fa ff ff       	call   801ac1 <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	ff 75 0c             	pushl  0xc(%ebp)
  8020be:	ff 75 08             	pushl  0x8(%ebp)
  8020c1:	6a 2c                	push   $0x2c
  8020c3:	e8 f9 f9 ff ff       	call   801ac1 <syscall>
  8020c8:	83 c4 18             	add    $0x18,%esp
	return;
  8020cb:	90                   	nop
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	ff 75 0c             	pushl  0xc(%ebp)
  8020da:	ff 75 08             	pushl  0x8(%ebp)
  8020dd:	6a 2d                	push   $0x2d
  8020df:	e8 dd f9 ff ff       	call   801ac1 <syscall>
  8020e4:	83 c4 18             	add    $0x18,%esp
	return;
  8020e7:	90                   	nop
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	83 e8 04             	sub    $0x4,%eax
  8020f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fc:	8b 00                	mov    (%eax),%eax
  8020fe:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
  802106:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	83 e8 04             	sub    $0x4,%eax
  80210f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802115:	8b 00                	mov    (%eax),%eax
  802117:	83 e0 01             	and    $0x1,%eax
  80211a:	85 c0                	test   %eax,%eax
  80211c:	0f 94 c0             	sete   %al
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802127:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80212e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802131:	83 f8 02             	cmp    $0x2,%eax
  802134:	74 2b                	je     802161 <alloc_block+0x40>
  802136:	83 f8 02             	cmp    $0x2,%eax
  802139:	7f 07                	jg     802142 <alloc_block+0x21>
  80213b:	83 f8 01             	cmp    $0x1,%eax
  80213e:	74 0e                	je     80214e <alloc_block+0x2d>
  802140:	eb 58                	jmp    80219a <alloc_block+0x79>
  802142:	83 f8 03             	cmp    $0x3,%eax
  802145:	74 2d                	je     802174 <alloc_block+0x53>
  802147:	83 f8 04             	cmp    $0x4,%eax
  80214a:	74 3b                	je     802187 <alloc_block+0x66>
  80214c:	eb 4c                	jmp    80219a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80214e:	83 ec 0c             	sub    $0xc,%esp
  802151:	ff 75 08             	pushl  0x8(%ebp)
  802154:	e8 11 03 00 00       	call   80246a <alloc_block_FF>
  802159:	83 c4 10             	add    $0x10,%esp
  80215c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80215f:	eb 4a                	jmp    8021ab <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802161:	83 ec 0c             	sub    $0xc,%esp
  802164:	ff 75 08             	pushl  0x8(%ebp)
  802167:	e8 fa 19 00 00       	call   803b66 <alloc_block_NF>
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802172:	eb 37                	jmp    8021ab <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802174:	83 ec 0c             	sub    $0xc,%esp
  802177:	ff 75 08             	pushl  0x8(%ebp)
  80217a:	e8 a7 07 00 00       	call   802926 <alloc_block_BF>
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802185:	eb 24                	jmp    8021ab <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802187:	83 ec 0c             	sub    $0xc,%esp
  80218a:	ff 75 08             	pushl  0x8(%ebp)
  80218d:	e8 b7 19 00 00       	call   803b49 <alloc_block_WF>
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802198:	eb 11                	jmp    8021ab <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80219a:	83 ec 0c             	sub    $0xc,%esp
  80219d:	68 90 46 80 00       	push   $0x804690
  8021a2:	e8 a8 e6 ff ff       	call   80084f <cprintf>
  8021a7:	83 c4 10             	add    $0x10,%esp
		break;
  8021aa:	90                   	nop
	}
	return va;
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021b7:	83 ec 0c             	sub    $0xc,%esp
  8021ba:	68 b0 46 80 00       	push   $0x8046b0
  8021bf:	e8 8b e6 ff ff       	call   80084f <cprintf>
  8021c4:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021c7:	83 ec 0c             	sub    $0xc,%esp
  8021ca:	68 db 46 80 00       	push   $0x8046db
  8021cf:	e8 7b e6 ff ff       	call   80084f <cprintf>
  8021d4:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021dd:	eb 37                	jmp    802216 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021df:	83 ec 0c             	sub    $0xc,%esp
  8021e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e5:	e8 19 ff ff ff       	call   802103 <is_free_block>
  8021ea:	83 c4 10             	add    $0x10,%esp
  8021ed:	0f be d8             	movsbl %al,%ebx
  8021f0:	83 ec 0c             	sub    $0xc,%esp
  8021f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f6:	e8 ef fe ff ff       	call   8020ea <get_block_size>
  8021fb:	83 c4 10             	add    $0x10,%esp
  8021fe:	83 ec 04             	sub    $0x4,%esp
  802201:	53                   	push   %ebx
  802202:	50                   	push   %eax
  802203:	68 f3 46 80 00       	push   $0x8046f3
  802208:	e8 42 e6 ff ff       	call   80084f <cprintf>
  80220d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802210:	8b 45 10             	mov    0x10(%ebp),%eax
  802213:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802216:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221a:	74 07                	je     802223 <print_blocks_list+0x73>
  80221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221f:	8b 00                	mov    (%eax),%eax
  802221:	eb 05                	jmp    802228 <print_blocks_list+0x78>
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
  802228:	89 45 10             	mov    %eax,0x10(%ebp)
  80222b:	8b 45 10             	mov    0x10(%ebp),%eax
  80222e:	85 c0                	test   %eax,%eax
  802230:	75 ad                	jne    8021df <print_blocks_list+0x2f>
  802232:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802236:	75 a7                	jne    8021df <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	68 b0 46 80 00       	push   $0x8046b0
  802240:	e8 0a e6 ff ff       	call   80084f <cprintf>
  802245:	83 c4 10             	add    $0x10,%esp

}
  802248:	90                   	nop
  802249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802254:	8b 45 0c             	mov    0xc(%ebp),%eax
  802257:	83 e0 01             	and    $0x1,%eax
  80225a:	85 c0                	test   %eax,%eax
  80225c:	74 03                	je     802261 <initialize_dynamic_allocator+0x13>
  80225e:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802261:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802265:	0f 84 c7 01 00 00    	je     802432 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80226b:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802272:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802275:	8b 55 08             	mov    0x8(%ebp),%edx
  802278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227b:	01 d0                	add    %edx,%eax
  80227d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802282:	0f 87 ad 01 00 00    	ja     802435 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	85 c0                	test   %eax,%eax
  80228d:	0f 89 a5 01 00 00    	jns    802438 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802293:	8b 55 08             	mov    0x8(%ebp),%edx
  802296:	8b 45 0c             	mov    0xc(%ebp),%eax
  802299:	01 d0                	add    %edx,%eax
  80229b:	83 e8 04             	sub    $0x4,%eax
  80229e:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8022a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8022aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b2:	e9 87 00 00 00       	jmp    80233e <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022bb:	75 14                	jne    8022d1 <initialize_dynamic_allocator+0x83>
  8022bd:	83 ec 04             	sub    $0x4,%esp
  8022c0:	68 0b 47 80 00       	push   $0x80470b
  8022c5:	6a 79                	push   $0x79
  8022c7:	68 29 47 80 00       	push   $0x804729
  8022cc:	e8 c1 e2 ff ff       	call   800592 <_panic>
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	8b 00                	mov    (%eax),%eax
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	74 10                	je     8022ea <initialize_dynamic_allocator+0x9c>
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	8b 00                	mov    (%eax),%eax
  8022df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e2:	8b 52 04             	mov    0x4(%edx),%edx
  8022e5:	89 50 04             	mov    %edx,0x4(%eax)
  8022e8:	eb 0b                	jmp    8022f5 <initialize_dynamic_allocator+0xa7>
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 40 04             	mov    0x4(%eax),%eax
  8022f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	8b 40 04             	mov    0x4(%eax),%eax
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	74 0f                	je     80230e <initialize_dynamic_allocator+0xc0>
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 40 04             	mov    0x4(%eax),%eax
  802305:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802308:	8b 12                	mov    (%edx),%edx
  80230a:	89 10                	mov    %edx,(%eax)
  80230c:	eb 0a                	jmp    802318 <initialize_dynamic_allocator+0xca>
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 00                	mov    (%eax),%eax
  802313:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232b:	a1 38 50 80 00       	mov    0x805038,%eax
  802330:	48                   	dec    %eax
  802331:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802336:	a1 34 50 80 00       	mov    0x805034,%eax
  80233b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802342:	74 07                	je     80234b <initialize_dynamic_allocator+0xfd>
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	eb 05                	jmp    802350 <initialize_dynamic_allocator+0x102>
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
  802350:	a3 34 50 80 00       	mov    %eax,0x805034
  802355:	a1 34 50 80 00       	mov    0x805034,%eax
  80235a:	85 c0                	test   %eax,%eax
  80235c:	0f 85 55 ff ff ff    	jne    8022b7 <initialize_dynamic_allocator+0x69>
  802362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802366:	0f 85 4b ff ff ff    	jne    8022b7 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802375:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80237b:	a1 44 50 80 00       	mov    0x805044,%eax
  802380:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802385:	a1 40 50 80 00       	mov    0x805040,%eax
  80238a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	83 c0 08             	add    $0x8,%eax
  802396:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	83 c0 04             	add    $0x4,%eax
  80239f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a2:	83 ea 08             	sub    $0x8,%edx
  8023a5:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ad:	01 d0                	add    %edx,%eax
  8023af:	83 e8 08             	sub    $0x8,%eax
  8023b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b5:	83 ea 08             	sub    $0x8,%edx
  8023b8:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8023ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023d1:	75 17                	jne    8023ea <initialize_dynamic_allocator+0x19c>
  8023d3:	83 ec 04             	sub    $0x4,%esp
  8023d6:	68 44 47 80 00       	push   $0x804744
  8023db:	68 90 00 00 00       	push   $0x90
  8023e0:	68 29 47 80 00       	push   $0x804729
  8023e5:	e8 a8 e1 ff ff       	call   800592 <_panic>
  8023ea:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f3:	89 10                	mov    %edx,(%eax)
  8023f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	74 0d                	je     80240b <initialize_dynamic_allocator+0x1bd>
  8023fe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802403:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802406:	89 50 04             	mov    %edx,0x4(%eax)
  802409:	eb 08                	jmp    802413 <initialize_dynamic_allocator+0x1c5>
  80240b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240e:	a3 30 50 80 00       	mov    %eax,0x805030
  802413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802416:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80241b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802425:	a1 38 50 80 00       	mov    0x805038,%eax
  80242a:	40                   	inc    %eax
  80242b:	a3 38 50 80 00       	mov    %eax,0x805038
  802430:	eb 07                	jmp    802439 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802432:	90                   	nop
  802433:	eb 04                	jmp    802439 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802435:	90                   	nop
  802436:	eb 01                	jmp    802439 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802438:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802439:	c9                   	leave  
  80243a:	c3                   	ret    

0080243b <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80243e:	8b 45 10             	mov    0x10(%ebp),%eax
  802441:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	8d 50 fc             	lea    -0x4(%eax),%edx
  80244a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244d:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	83 e8 04             	sub    $0x4,%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	83 e0 fe             	and    $0xfffffffe,%eax
  80245a:	8d 50 f8             	lea    -0x8(%eax),%edx
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	01 c2                	add    %eax,%edx
  802462:	8b 45 0c             	mov    0xc(%ebp),%eax
  802465:	89 02                	mov    %eax,(%edx)
}
  802467:	90                   	nop
  802468:	5d                   	pop    %ebp
  802469:	c3                   	ret    

0080246a <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	83 e0 01             	and    $0x1,%eax
  802476:	85 c0                	test   %eax,%eax
  802478:	74 03                	je     80247d <alloc_block_FF+0x13>
  80247a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80247d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802481:	77 07                	ja     80248a <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802483:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80248a:	a1 24 50 80 00       	mov    0x805024,%eax
  80248f:	85 c0                	test   %eax,%eax
  802491:	75 73                	jne    802506 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	83 c0 10             	add    $0x10,%eax
  802499:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80249c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a9:	01 d0                	add    %edx,%eax
  8024ab:	48                   	dec    %eax
  8024ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b7:	f7 75 ec             	divl   -0x14(%ebp)
  8024ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024bd:	29 d0                	sub    %edx,%eax
  8024bf:	c1 e8 0c             	shr    $0xc,%eax
  8024c2:	83 ec 0c             	sub    $0xc,%esp
  8024c5:	50                   	push   %eax
  8024c6:	e8 1e f1 ff ff       	call   8015e9 <sbrk>
  8024cb:	83 c4 10             	add    $0x10,%esp
  8024ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024d1:	83 ec 0c             	sub    $0xc,%esp
  8024d4:	6a 00                	push   $0x0
  8024d6:	e8 0e f1 ff ff       	call   8015e9 <sbrk>
  8024db:	83 c4 10             	add    $0x10,%esp
  8024de:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024e7:	83 ec 08             	sub    $0x8,%esp
  8024ea:	50                   	push   %eax
  8024eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024ee:	e8 5b fd ff ff       	call   80224e <initialize_dynamic_allocator>
  8024f3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024f6:	83 ec 0c             	sub    $0xc,%esp
  8024f9:	68 67 47 80 00       	push   $0x804767
  8024fe:	e8 4c e3 ff ff       	call   80084f <cprintf>
  802503:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802506:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250a:	75 0a                	jne    802516 <alloc_block_FF+0xac>
	        return NULL;
  80250c:	b8 00 00 00 00       	mov    $0x0,%eax
  802511:	e9 0e 04 00 00       	jmp    802924 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802516:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80251d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802522:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802525:	e9 f3 02 00 00       	jmp    80281d <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802530:	83 ec 0c             	sub    $0xc,%esp
  802533:	ff 75 bc             	pushl  -0x44(%ebp)
  802536:	e8 af fb ff ff       	call   8020ea <get_block_size>
  80253b:	83 c4 10             	add    $0x10,%esp
  80253e:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	83 c0 08             	add    $0x8,%eax
  802547:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80254a:	0f 87 c5 02 00 00    	ja     802815 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802550:	8b 45 08             	mov    0x8(%ebp),%eax
  802553:	83 c0 18             	add    $0x18,%eax
  802556:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802559:	0f 87 19 02 00 00    	ja     802778 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80255f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802562:	2b 45 08             	sub    0x8(%ebp),%eax
  802565:	83 e8 08             	sub    $0x8,%eax
  802568:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	8d 50 08             	lea    0x8(%eax),%edx
  802571:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802574:	01 d0                	add    %edx,%eax
  802576:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	83 c0 08             	add    $0x8,%eax
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	6a 01                	push   $0x1
  802584:	50                   	push   %eax
  802585:	ff 75 bc             	pushl  -0x44(%ebp)
  802588:	e8 ae fe ff ff       	call   80243b <set_block_data>
  80258d:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 40 04             	mov    0x4(%eax),%eax
  802596:	85 c0                	test   %eax,%eax
  802598:	75 68                	jne    802602 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80259a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80259e:	75 17                	jne    8025b7 <alloc_block_FF+0x14d>
  8025a0:	83 ec 04             	sub    $0x4,%esp
  8025a3:	68 44 47 80 00       	push   $0x804744
  8025a8:	68 d7 00 00 00       	push   $0xd7
  8025ad:	68 29 47 80 00       	push   $0x804729
  8025b2:	e8 db df ff ff       	call   800592 <_panic>
  8025b7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c0:	89 10                	mov    %edx,(%eax)
  8025c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c5:	8b 00                	mov    (%eax),%eax
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	74 0d                	je     8025d8 <alloc_block_FF+0x16e>
  8025cb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025d0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025d3:	89 50 04             	mov    %edx,0x4(%eax)
  8025d6:	eb 08                	jmp    8025e0 <alloc_block_FF+0x176>
  8025d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025db:	a3 30 50 80 00       	mov    %eax,0x805030
  8025e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8025f7:	40                   	inc    %eax
  8025f8:	a3 38 50 80 00       	mov    %eax,0x805038
  8025fd:	e9 dc 00 00 00       	jmp    8026de <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	85 c0                	test   %eax,%eax
  802609:	75 65                	jne    802670 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80260b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80260f:	75 17                	jne    802628 <alloc_block_FF+0x1be>
  802611:	83 ec 04             	sub    $0x4,%esp
  802614:	68 78 47 80 00       	push   $0x804778
  802619:	68 db 00 00 00       	push   $0xdb
  80261e:	68 29 47 80 00       	push   $0x804729
  802623:	e8 6a df ff ff       	call   800592 <_panic>
  802628:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80262e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802631:	89 50 04             	mov    %edx,0x4(%eax)
  802634:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802637:	8b 40 04             	mov    0x4(%eax),%eax
  80263a:	85 c0                	test   %eax,%eax
  80263c:	74 0c                	je     80264a <alloc_block_FF+0x1e0>
  80263e:	a1 30 50 80 00       	mov    0x805030,%eax
  802643:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802646:	89 10                	mov    %edx,(%eax)
  802648:	eb 08                	jmp    802652 <alloc_block_FF+0x1e8>
  80264a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80264d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802652:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802655:	a3 30 50 80 00       	mov    %eax,0x805030
  80265a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80265d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802663:	a1 38 50 80 00       	mov    0x805038,%eax
  802668:	40                   	inc    %eax
  802669:	a3 38 50 80 00       	mov    %eax,0x805038
  80266e:	eb 6e                	jmp    8026de <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802674:	74 06                	je     80267c <alloc_block_FF+0x212>
  802676:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80267a:	75 17                	jne    802693 <alloc_block_FF+0x229>
  80267c:	83 ec 04             	sub    $0x4,%esp
  80267f:	68 9c 47 80 00       	push   $0x80479c
  802684:	68 df 00 00 00       	push   $0xdf
  802689:	68 29 47 80 00       	push   $0x804729
  80268e:	e8 ff de ff ff       	call   800592 <_panic>
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 10                	mov    (%eax),%edx
  802698:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80269b:	89 10                	mov    %edx,(%eax)
  80269d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	74 0b                	je     8026b1 <alloc_block_FF+0x247>
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 00                	mov    (%eax),%eax
  8026ab:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026ae:	89 50 04             	mov    %edx,0x4(%eax)
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026b7:	89 10                	mov    %edx,(%eax)
  8026b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bf:	89 50 04             	mov    %edx,0x4(%eax)
  8026c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c5:	8b 00                	mov    (%eax),%eax
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	75 08                	jne    8026d3 <alloc_block_FF+0x269>
  8026cb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8026d3:	a1 38 50 80 00       	mov    0x805038,%eax
  8026d8:	40                   	inc    %eax
  8026d9:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8026de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e2:	75 17                	jne    8026fb <alloc_block_FF+0x291>
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	68 0b 47 80 00       	push   $0x80470b
  8026ec:	68 e1 00 00 00       	push   $0xe1
  8026f1:	68 29 47 80 00       	push   $0x804729
  8026f6:	e8 97 de ff ff       	call   800592 <_panic>
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 00                	mov    (%eax),%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	74 10                	je     802714 <alloc_block_FF+0x2aa>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270c:	8b 52 04             	mov    0x4(%edx),%edx
  80270f:	89 50 04             	mov    %edx,0x4(%eax)
  802712:	eb 0b                	jmp    80271f <alloc_block_FF+0x2b5>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 04             	mov    0x4(%eax),%eax
  80271a:	a3 30 50 80 00       	mov    %eax,0x805030
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 04             	mov    0x4(%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 0f                	je     802738 <alloc_block_FF+0x2ce>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 40 04             	mov    0x4(%eax),%eax
  80272f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802732:	8b 12                	mov    (%edx),%edx
  802734:	89 10                	mov    %edx,(%eax)
  802736:	eb 0a                	jmp    802742 <alloc_block_FF+0x2d8>
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802755:	a1 38 50 80 00       	mov    0x805038,%eax
  80275a:	48                   	dec    %eax
  80275b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802760:	83 ec 04             	sub    $0x4,%esp
  802763:	6a 00                	push   $0x0
  802765:	ff 75 b4             	pushl  -0x4c(%ebp)
  802768:	ff 75 b0             	pushl  -0x50(%ebp)
  80276b:	e8 cb fc ff ff       	call   80243b <set_block_data>
  802770:	83 c4 10             	add    $0x10,%esp
  802773:	e9 95 00 00 00       	jmp    80280d <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802778:	83 ec 04             	sub    $0x4,%esp
  80277b:	6a 01                	push   $0x1
  80277d:	ff 75 b8             	pushl  -0x48(%ebp)
  802780:	ff 75 bc             	pushl  -0x44(%ebp)
  802783:	e8 b3 fc ff ff       	call   80243b <set_block_data>
  802788:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80278b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278f:	75 17                	jne    8027a8 <alloc_block_FF+0x33e>
  802791:	83 ec 04             	sub    $0x4,%esp
  802794:	68 0b 47 80 00       	push   $0x80470b
  802799:	68 e8 00 00 00       	push   $0xe8
  80279e:	68 29 47 80 00       	push   $0x804729
  8027a3:	e8 ea dd ff ff       	call   800592 <_panic>
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	74 10                	je     8027c1 <alloc_block_FF+0x357>
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b9:	8b 52 04             	mov    0x4(%edx),%edx
  8027bc:	89 50 04             	mov    %edx,0x4(%eax)
  8027bf:	eb 0b                	jmp    8027cc <alloc_block_FF+0x362>
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 40 04             	mov    0x4(%eax),%eax
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	74 0f                	je     8027e5 <alloc_block_FF+0x37b>
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 04             	mov    0x4(%eax),%eax
  8027dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027df:	8b 12                	mov    (%edx),%edx
  8027e1:	89 10                	mov    %edx,(%eax)
  8027e3:	eb 0a                	jmp    8027ef <alloc_block_FF+0x385>
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802802:	a1 38 50 80 00       	mov    0x805038,%eax
  802807:	48                   	dec    %eax
  802808:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80280d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802810:	e9 0f 01 00 00       	jmp    802924 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802815:	a1 34 50 80 00       	mov    0x805034,%eax
  80281a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802821:	74 07                	je     80282a <alloc_block_FF+0x3c0>
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	eb 05                	jmp    80282f <alloc_block_FF+0x3c5>
  80282a:	b8 00 00 00 00       	mov    $0x0,%eax
  80282f:	a3 34 50 80 00       	mov    %eax,0x805034
  802834:	a1 34 50 80 00       	mov    0x805034,%eax
  802839:	85 c0                	test   %eax,%eax
  80283b:	0f 85 e9 fc ff ff    	jne    80252a <alloc_block_FF+0xc0>
  802841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802845:	0f 85 df fc ff ff    	jne    80252a <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	83 c0 08             	add    $0x8,%eax
  802851:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802854:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80285b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80285e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802861:	01 d0                	add    %edx,%eax
  802863:	48                   	dec    %eax
  802864:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802867:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80286a:	ba 00 00 00 00       	mov    $0x0,%edx
  80286f:	f7 75 d8             	divl   -0x28(%ebp)
  802872:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802875:	29 d0                	sub    %edx,%eax
  802877:	c1 e8 0c             	shr    $0xc,%eax
  80287a:	83 ec 0c             	sub    $0xc,%esp
  80287d:	50                   	push   %eax
  80287e:	e8 66 ed ff ff       	call   8015e9 <sbrk>
  802883:	83 c4 10             	add    $0x10,%esp
  802886:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802889:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80288d:	75 0a                	jne    802899 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80288f:	b8 00 00 00 00       	mov    $0x0,%eax
  802894:	e9 8b 00 00 00       	jmp    802924 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802899:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a6:	01 d0                	add    %edx,%eax
  8028a8:	48                   	dec    %eax
  8028a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028af:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b4:	f7 75 cc             	divl   -0x34(%ebp)
  8028b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028ba:	29 d0                	sub    %edx,%eax
  8028bc:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c2:	01 d0                	add    %edx,%eax
  8028c4:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8028c9:	a1 40 50 80 00       	mov    0x805040,%eax
  8028ce:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028d4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028e1:	01 d0                	add    %edx,%eax
  8028e3:	48                   	dec    %eax
  8028e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028e7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ef:	f7 75 c4             	divl   -0x3c(%ebp)
  8028f2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028f5:	29 d0                	sub    %edx,%eax
  8028f7:	83 ec 04             	sub    $0x4,%esp
  8028fa:	6a 01                	push   $0x1
  8028fc:	50                   	push   %eax
  8028fd:	ff 75 d0             	pushl  -0x30(%ebp)
  802900:	e8 36 fb ff ff       	call   80243b <set_block_data>
  802905:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802908:	83 ec 0c             	sub    $0xc,%esp
  80290b:	ff 75 d0             	pushl  -0x30(%ebp)
  80290e:	e8 1b 0a 00 00       	call   80332e <free_block>
  802913:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802916:	83 ec 0c             	sub    $0xc,%esp
  802919:	ff 75 08             	pushl  0x8(%ebp)
  80291c:	e8 49 fb ff ff       	call   80246a <alloc_block_FF>
  802921:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802924:	c9                   	leave  
  802925:	c3                   	ret    

00802926 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
  802929:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	83 e0 01             	and    $0x1,%eax
  802932:	85 c0                	test   %eax,%eax
  802934:	74 03                	je     802939 <alloc_block_BF+0x13>
  802936:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802939:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80293d:	77 07                	ja     802946 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80293f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802946:	a1 24 50 80 00       	mov    0x805024,%eax
  80294b:	85 c0                	test   %eax,%eax
  80294d:	75 73                	jne    8029c2 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	83 c0 10             	add    $0x10,%eax
  802955:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802958:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80295f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802962:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802965:	01 d0                	add    %edx,%eax
  802967:	48                   	dec    %eax
  802968:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80296b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80296e:	ba 00 00 00 00       	mov    $0x0,%edx
  802973:	f7 75 e0             	divl   -0x20(%ebp)
  802976:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802979:	29 d0                	sub    %edx,%eax
  80297b:	c1 e8 0c             	shr    $0xc,%eax
  80297e:	83 ec 0c             	sub    $0xc,%esp
  802981:	50                   	push   %eax
  802982:	e8 62 ec ff ff       	call   8015e9 <sbrk>
  802987:	83 c4 10             	add    $0x10,%esp
  80298a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80298d:	83 ec 0c             	sub    $0xc,%esp
  802990:	6a 00                	push   $0x0
  802992:	e8 52 ec ff ff       	call   8015e9 <sbrk>
  802997:	83 c4 10             	add    $0x10,%esp
  80299a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80299d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029a0:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029a3:	83 ec 08             	sub    $0x8,%esp
  8029a6:	50                   	push   %eax
  8029a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8029aa:	e8 9f f8 ff ff       	call   80224e <initialize_dynamic_allocator>
  8029af:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029b2:	83 ec 0c             	sub    $0xc,%esp
  8029b5:	68 67 47 80 00       	push   $0x804767
  8029ba:	e8 90 de ff ff       	call   80084f <cprintf>
  8029bf:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029d0:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8029de:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e6:	e9 1d 01 00 00       	jmp    802b08 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8029f1:	83 ec 0c             	sub    $0xc,%esp
  8029f4:	ff 75 a8             	pushl  -0x58(%ebp)
  8029f7:	e8 ee f6 ff ff       	call   8020ea <get_block_size>
  8029fc:	83 c4 10             	add    $0x10,%esp
  8029ff:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	83 c0 08             	add    $0x8,%eax
  802a08:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a0b:	0f 87 ef 00 00 00    	ja     802b00 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	83 c0 18             	add    $0x18,%eax
  802a17:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a1a:	77 1d                	ja     802a39 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a22:	0f 86 d8 00 00 00    	jbe    802b00 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a28:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a2e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a31:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a34:	e9 c7 00 00 00       	jmp    802b00 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	83 c0 08             	add    $0x8,%eax
  802a3f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a42:	0f 85 9d 00 00 00    	jne    802ae5 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a48:	83 ec 04             	sub    $0x4,%esp
  802a4b:	6a 01                	push   $0x1
  802a4d:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a50:	ff 75 a8             	pushl  -0x58(%ebp)
  802a53:	e8 e3 f9 ff ff       	call   80243b <set_block_data>
  802a58:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5f:	75 17                	jne    802a78 <alloc_block_BF+0x152>
  802a61:	83 ec 04             	sub    $0x4,%esp
  802a64:	68 0b 47 80 00       	push   $0x80470b
  802a69:	68 2c 01 00 00       	push   $0x12c
  802a6e:	68 29 47 80 00       	push   $0x804729
  802a73:	e8 1a db ff ff       	call   800592 <_panic>
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 10                	je     802a91 <alloc_block_BF+0x16b>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 00                	mov    (%eax),%eax
  802a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a89:	8b 52 04             	mov    0x4(%edx),%edx
  802a8c:	89 50 04             	mov    %edx,0x4(%eax)
  802a8f:	eb 0b                	jmp    802a9c <alloc_block_BF+0x176>
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 40 04             	mov    0x4(%eax),%eax
  802a97:	a3 30 50 80 00       	mov    %eax,0x805030
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 40 04             	mov    0x4(%eax),%eax
  802aa2:	85 c0                	test   %eax,%eax
  802aa4:	74 0f                	je     802ab5 <alloc_block_BF+0x18f>
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 40 04             	mov    0x4(%eax),%eax
  802aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aaf:	8b 12                	mov    (%edx),%edx
  802ab1:	89 10                	mov    %edx,(%eax)
  802ab3:	eb 0a                	jmp    802abf <alloc_block_BF+0x199>
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ad7:	48                   	dec    %eax
  802ad8:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802add:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ae0:	e9 24 04 00 00       	jmp    802f09 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802aeb:	76 13                	jbe    802b00 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802aed:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802af4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802af7:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802afa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802afd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b00:	a1 34 50 80 00       	mov    0x805034,%eax
  802b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0c:	74 07                	je     802b15 <alloc_block_BF+0x1ef>
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	eb 05                	jmp    802b1a <alloc_block_BF+0x1f4>
  802b15:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1a:	a3 34 50 80 00       	mov    %eax,0x805034
  802b1f:	a1 34 50 80 00       	mov    0x805034,%eax
  802b24:	85 c0                	test   %eax,%eax
  802b26:	0f 85 bf fe ff ff    	jne    8029eb <alloc_block_BF+0xc5>
  802b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b30:	0f 85 b5 fe ff ff    	jne    8029eb <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b3a:	0f 84 26 02 00 00    	je     802d66 <alloc_block_BF+0x440>
  802b40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b44:	0f 85 1c 02 00 00    	jne    802d66 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4d:	2b 45 08             	sub    0x8(%ebp),%eax
  802b50:	83 e8 08             	sub    $0x8,%eax
  802b53:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	8d 50 08             	lea    0x8(%eax),%edx
  802b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5f:	01 d0                	add    %edx,%eax
  802b61:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	83 c0 08             	add    $0x8,%eax
  802b6a:	83 ec 04             	sub    $0x4,%esp
  802b6d:	6a 01                	push   $0x1
  802b6f:	50                   	push   %eax
  802b70:	ff 75 f0             	pushl  -0x10(%ebp)
  802b73:	e8 c3 f8 ff ff       	call   80243b <set_block_data>
  802b78:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7e:	8b 40 04             	mov    0x4(%eax),%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	75 68                	jne    802bed <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b85:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b89:	75 17                	jne    802ba2 <alloc_block_BF+0x27c>
  802b8b:	83 ec 04             	sub    $0x4,%esp
  802b8e:	68 44 47 80 00       	push   $0x804744
  802b93:	68 45 01 00 00       	push   $0x145
  802b98:	68 29 47 80 00       	push   $0x804729
  802b9d:	e8 f0 d9 ff ff       	call   800592 <_panic>
  802ba2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ba8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bab:	89 10                	mov    %edx,(%eax)
  802bad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb0:	8b 00                	mov    (%eax),%eax
  802bb2:	85 c0                	test   %eax,%eax
  802bb4:	74 0d                	je     802bc3 <alloc_block_BF+0x29d>
  802bb6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bbb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bbe:	89 50 04             	mov    %edx,0x4(%eax)
  802bc1:	eb 08                	jmp    802bcb <alloc_block_BF+0x2a5>
  802bc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc6:	a3 30 50 80 00       	mov    %eax,0x805030
  802bcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bce:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bd3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdd:	a1 38 50 80 00       	mov    0x805038,%eax
  802be2:	40                   	inc    %eax
  802be3:	a3 38 50 80 00       	mov    %eax,0x805038
  802be8:	e9 dc 00 00 00       	jmp    802cc9 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf0:	8b 00                	mov    (%eax),%eax
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	75 65                	jne    802c5b <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bf6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bfa:	75 17                	jne    802c13 <alloc_block_BF+0x2ed>
  802bfc:	83 ec 04             	sub    $0x4,%esp
  802bff:	68 78 47 80 00       	push   $0x804778
  802c04:	68 4a 01 00 00       	push   $0x14a
  802c09:	68 29 47 80 00       	push   $0x804729
  802c0e:	e8 7f d9 ff ff       	call   800592 <_panic>
  802c13:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c1c:	89 50 04             	mov    %edx,0x4(%eax)
  802c1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c22:	8b 40 04             	mov    0x4(%eax),%eax
  802c25:	85 c0                	test   %eax,%eax
  802c27:	74 0c                	je     802c35 <alloc_block_BF+0x30f>
  802c29:	a1 30 50 80 00       	mov    0x805030,%eax
  802c2e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c31:	89 10                	mov    %edx,(%eax)
  802c33:	eb 08                	jmp    802c3d <alloc_block_BF+0x317>
  802c35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c38:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c40:	a3 30 50 80 00       	mov    %eax,0x805030
  802c45:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4e:	a1 38 50 80 00       	mov    0x805038,%eax
  802c53:	40                   	inc    %eax
  802c54:	a3 38 50 80 00       	mov    %eax,0x805038
  802c59:	eb 6e                	jmp    802cc9 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c5f:	74 06                	je     802c67 <alloc_block_BF+0x341>
  802c61:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c65:	75 17                	jne    802c7e <alloc_block_BF+0x358>
  802c67:	83 ec 04             	sub    $0x4,%esp
  802c6a:	68 9c 47 80 00       	push   $0x80479c
  802c6f:	68 4f 01 00 00       	push   $0x14f
  802c74:	68 29 47 80 00       	push   $0x804729
  802c79:	e8 14 d9 ff ff       	call   800592 <_panic>
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	8b 10                	mov    (%eax),%edx
  802c83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c86:	89 10                	mov    %edx,(%eax)
  802c88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	85 c0                	test   %eax,%eax
  802c8f:	74 0b                	je     802c9c <alloc_block_BF+0x376>
  802c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c99:	89 50 04             	mov    %edx,0x4(%eax)
  802c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ca2:	89 10                	mov    %edx,(%eax)
  802ca4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802caa:	89 50 04             	mov    %edx,0x4(%eax)
  802cad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	75 08                	jne    802cbe <alloc_block_BF+0x398>
  802cb6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb9:	a3 30 50 80 00       	mov    %eax,0x805030
  802cbe:	a1 38 50 80 00       	mov    0x805038,%eax
  802cc3:	40                   	inc    %eax
  802cc4:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802cc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ccd:	75 17                	jne    802ce6 <alloc_block_BF+0x3c0>
  802ccf:	83 ec 04             	sub    $0x4,%esp
  802cd2:	68 0b 47 80 00       	push   $0x80470b
  802cd7:	68 51 01 00 00       	push   $0x151
  802cdc:	68 29 47 80 00       	push   $0x804729
  802ce1:	e8 ac d8 ff ff       	call   800592 <_panic>
  802ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	85 c0                	test   %eax,%eax
  802ced:	74 10                	je     802cff <alloc_block_BF+0x3d9>
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf7:	8b 52 04             	mov    0x4(%edx),%edx
  802cfa:	89 50 04             	mov    %edx,0x4(%eax)
  802cfd:	eb 0b                	jmp    802d0a <alloc_block_BF+0x3e4>
  802cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d02:	8b 40 04             	mov    0x4(%eax),%eax
  802d05:	a3 30 50 80 00       	mov    %eax,0x805030
  802d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0d:	8b 40 04             	mov    0x4(%eax),%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	74 0f                	je     802d23 <alloc_block_BF+0x3fd>
  802d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d17:	8b 40 04             	mov    0x4(%eax),%eax
  802d1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1d:	8b 12                	mov    (%edx),%edx
  802d1f:	89 10                	mov    %edx,(%eax)
  802d21:	eb 0a                	jmp    802d2d <alloc_block_BF+0x407>
  802d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d40:	a1 38 50 80 00       	mov    0x805038,%eax
  802d45:	48                   	dec    %eax
  802d46:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d4b:	83 ec 04             	sub    $0x4,%esp
  802d4e:	6a 00                	push   $0x0
  802d50:	ff 75 d0             	pushl  -0x30(%ebp)
  802d53:	ff 75 cc             	pushl  -0x34(%ebp)
  802d56:	e8 e0 f6 ff ff       	call   80243b <set_block_data>
  802d5b:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d61:	e9 a3 01 00 00       	jmp    802f09 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d66:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d6a:	0f 85 9d 00 00 00    	jne    802e0d <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d70:	83 ec 04             	sub    $0x4,%esp
  802d73:	6a 01                	push   $0x1
  802d75:	ff 75 ec             	pushl  -0x14(%ebp)
  802d78:	ff 75 f0             	pushl  -0x10(%ebp)
  802d7b:	e8 bb f6 ff ff       	call   80243b <set_block_data>
  802d80:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d87:	75 17                	jne    802da0 <alloc_block_BF+0x47a>
  802d89:	83 ec 04             	sub    $0x4,%esp
  802d8c:	68 0b 47 80 00       	push   $0x80470b
  802d91:	68 58 01 00 00       	push   $0x158
  802d96:	68 29 47 80 00       	push   $0x804729
  802d9b:	e8 f2 d7 ff ff       	call   800592 <_panic>
  802da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da3:	8b 00                	mov    (%eax),%eax
  802da5:	85 c0                	test   %eax,%eax
  802da7:	74 10                	je     802db9 <alloc_block_BF+0x493>
  802da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dac:	8b 00                	mov    (%eax),%eax
  802dae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db1:	8b 52 04             	mov    0x4(%edx),%edx
  802db4:	89 50 04             	mov    %edx,0x4(%eax)
  802db7:	eb 0b                	jmp    802dc4 <alloc_block_BF+0x49e>
  802db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbc:	8b 40 04             	mov    0x4(%eax),%eax
  802dbf:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	8b 40 04             	mov    0x4(%eax),%eax
  802dca:	85 c0                	test   %eax,%eax
  802dcc:	74 0f                	je     802ddd <alloc_block_BF+0x4b7>
  802dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd1:	8b 40 04             	mov    0x4(%eax),%eax
  802dd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd7:	8b 12                	mov    (%edx),%edx
  802dd9:	89 10                	mov    %edx,(%eax)
  802ddb:	eb 0a                	jmp    802de7 <alloc_block_BF+0x4c1>
  802ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de0:	8b 00                	mov    (%eax),%eax
  802de2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfa:	a1 38 50 80 00       	mov    0x805038,%eax
  802dff:	48                   	dec    %eax
  802e00:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e08:	e9 fc 00 00 00       	jmp    802f09 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	83 c0 08             	add    $0x8,%eax
  802e13:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e16:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e1d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e20:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e23:	01 d0                	add    %edx,%eax
  802e25:	48                   	dec    %eax
  802e26:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e29:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e2c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e31:	f7 75 c4             	divl   -0x3c(%ebp)
  802e34:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e37:	29 d0                	sub    %edx,%eax
  802e39:	c1 e8 0c             	shr    $0xc,%eax
  802e3c:	83 ec 0c             	sub    $0xc,%esp
  802e3f:	50                   	push   %eax
  802e40:	e8 a4 e7 ff ff       	call   8015e9 <sbrk>
  802e45:	83 c4 10             	add    $0x10,%esp
  802e48:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e4b:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e4f:	75 0a                	jne    802e5b <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e51:	b8 00 00 00 00       	mov    $0x0,%eax
  802e56:	e9 ae 00 00 00       	jmp    802f09 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e5b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e62:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e65:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e68:	01 d0                	add    %edx,%eax
  802e6a:	48                   	dec    %eax
  802e6b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e6e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e71:	ba 00 00 00 00       	mov    $0x0,%edx
  802e76:	f7 75 b8             	divl   -0x48(%ebp)
  802e79:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e7c:	29 d0                	sub    %edx,%eax
  802e7e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e81:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e84:	01 d0                	add    %edx,%eax
  802e86:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e8b:	a1 40 50 80 00       	mov    0x805040,%eax
  802e90:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e96:	83 ec 0c             	sub    $0xc,%esp
  802e99:	68 d0 47 80 00       	push   $0x8047d0
  802e9e:	e8 ac d9 ff ff       	call   80084f <cprintf>
  802ea3:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802ea6:	83 ec 08             	sub    $0x8,%esp
  802ea9:	ff 75 bc             	pushl  -0x44(%ebp)
  802eac:	68 d5 47 80 00       	push   $0x8047d5
  802eb1:	e8 99 d9 ff ff       	call   80084f <cprintf>
  802eb6:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802eb9:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ec0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ec3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ec6:	01 d0                	add    %edx,%eax
  802ec8:	48                   	dec    %eax
  802ec9:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ecc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ecf:	ba 00 00 00 00       	mov    $0x0,%edx
  802ed4:	f7 75 b0             	divl   -0x50(%ebp)
  802ed7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802eda:	29 d0                	sub    %edx,%eax
  802edc:	83 ec 04             	sub    $0x4,%esp
  802edf:	6a 01                	push   $0x1
  802ee1:	50                   	push   %eax
  802ee2:	ff 75 bc             	pushl  -0x44(%ebp)
  802ee5:	e8 51 f5 ff ff       	call   80243b <set_block_data>
  802eea:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802eed:	83 ec 0c             	sub    $0xc,%esp
  802ef0:	ff 75 bc             	pushl  -0x44(%ebp)
  802ef3:	e8 36 04 00 00       	call   80332e <free_block>
  802ef8:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802efb:	83 ec 0c             	sub    $0xc,%esp
  802efe:	ff 75 08             	pushl  0x8(%ebp)
  802f01:	e8 20 fa ff ff       	call   802926 <alloc_block_BF>
  802f06:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f09:	c9                   	leave  
  802f0a:	c3                   	ret    

00802f0b <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f0b:	55                   	push   %ebp
  802f0c:	89 e5                	mov    %esp,%ebp
  802f0e:	53                   	push   %ebx
  802f0f:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f24:	74 1e                	je     802f44 <merging+0x39>
  802f26:	ff 75 08             	pushl  0x8(%ebp)
  802f29:	e8 bc f1 ff ff       	call   8020ea <get_block_size>
  802f2e:	83 c4 04             	add    $0x4,%esp
  802f31:	89 c2                	mov    %eax,%edx
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	01 d0                	add    %edx,%eax
  802f38:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f3b:	75 07                	jne    802f44 <merging+0x39>
		prev_is_free = 1;
  802f3d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f48:	74 1e                	je     802f68 <merging+0x5d>
  802f4a:	ff 75 10             	pushl  0x10(%ebp)
  802f4d:	e8 98 f1 ff ff       	call   8020ea <get_block_size>
  802f52:	83 c4 04             	add    $0x4,%esp
  802f55:	89 c2                	mov    %eax,%edx
  802f57:	8b 45 10             	mov    0x10(%ebp),%eax
  802f5a:	01 d0                	add    %edx,%eax
  802f5c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f5f:	75 07                	jne    802f68 <merging+0x5d>
		next_is_free = 1;
  802f61:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6c:	0f 84 cc 00 00 00    	je     80303e <merging+0x133>
  802f72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f76:	0f 84 c2 00 00 00    	je     80303e <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f7c:	ff 75 08             	pushl  0x8(%ebp)
  802f7f:	e8 66 f1 ff ff       	call   8020ea <get_block_size>
  802f84:	83 c4 04             	add    $0x4,%esp
  802f87:	89 c3                	mov    %eax,%ebx
  802f89:	ff 75 10             	pushl  0x10(%ebp)
  802f8c:	e8 59 f1 ff ff       	call   8020ea <get_block_size>
  802f91:	83 c4 04             	add    $0x4,%esp
  802f94:	01 c3                	add    %eax,%ebx
  802f96:	ff 75 0c             	pushl  0xc(%ebp)
  802f99:	e8 4c f1 ff ff       	call   8020ea <get_block_size>
  802f9e:	83 c4 04             	add    $0x4,%esp
  802fa1:	01 d8                	add    %ebx,%eax
  802fa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fa6:	6a 00                	push   $0x0
  802fa8:	ff 75 ec             	pushl  -0x14(%ebp)
  802fab:	ff 75 08             	pushl  0x8(%ebp)
  802fae:	e8 88 f4 ff ff       	call   80243b <set_block_data>
  802fb3:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802fb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fba:	75 17                	jne    802fd3 <merging+0xc8>
  802fbc:	83 ec 04             	sub    $0x4,%esp
  802fbf:	68 0b 47 80 00       	push   $0x80470b
  802fc4:	68 7d 01 00 00       	push   $0x17d
  802fc9:	68 29 47 80 00       	push   $0x804729
  802fce:	e8 bf d5 ff ff       	call   800592 <_panic>
  802fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 10                	je     802fec <merging+0xe1>
  802fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdf:	8b 00                	mov    (%eax),%eax
  802fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe4:	8b 52 04             	mov    0x4(%edx),%edx
  802fe7:	89 50 04             	mov    %edx,0x4(%eax)
  802fea:	eb 0b                	jmp    802ff7 <merging+0xec>
  802fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fef:	8b 40 04             	mov    0x4(%eax),%eax
  802ff2:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffa:	8b 40 04             	mov    0x4(%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	74 0f                	je     803010 <merging+0x105>
  803001:	8b 45 0c             	mov    0xc(%ebp),%eax
  803004:	8b 40 04             	mov    0x4(%eax),%eax
  803007:	8b 55 0c             	mov    0xc(%ebp),%edx
  80300a:	8b 12                	mov    (%edx),%edx
  80300c:	89 10                	mov    %edx,(%eax)
  80300e:	eb 0a                	jmp    80301a <merging+0x10f>
  803010:	8b 45 0c             	mov    0xc(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80301a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803023:	8b 45 0c             	mov    0xc(%ebp),%eax
  803026:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302d:	a1 38 50 80 00       	mov    0x805038,%eax
  803032:	48                   	dec    %eax
  803033:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803038:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803039:	e9 ea 02 00 00       	jmp    803328 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80303e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803042:	74 3b                	je     80307f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803044:	83 ec 0c             	sub    $0xc,%esp
  803047:	ff 75 08             	pushl  0x8(%ebp)
  80304a:	e8 9b f0 ff ff       	call   8020ea <get_block_size>
  80304f:	83 c4 10             	add    $0x10,%esp
  803052:	89 c3                	mov    %eax,%ebx
  803054:	83 ec 0c             	sub    $0xc,%esp
  803057:	ff 75 10             	pushl  0x10(%ebp)
  80305a:	e8 8b f0 ff ff       	call   8020ea <get_block_size>
  80305f:	83 c4 10             	add    $0x10,%esp
  803062:	01 d8                	add    %ebx,%eax
  803064:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803067:	83 ec 04             	sub    $0x4,%esp
  80306a:	6a 00                	push   $0x0
  80306c:	ff 75 e8             	pushl  -0x18(%ebp)
  80306f:	ff 75 08             	pushl  0x8(%ebp)
  803072:	e8 c4 f3 ff ff       	call   80243b <set_block_data>
  803077:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80307a:	e9 a9 02 00 00       	jmp    803328 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80307f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803083:	0f 84 2d 01 00 00    	je     8031b6 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803089:	83 ec 0c             	sub    $0xc,%esp
  80308c:	ff 75 10             	pushl  0x10(%ebp)
  80308f:	e8 56 f0 ff ff       	call   8020ea <get_block_size>
  803094:	83 c4 10             	add    $0x10,%esp
  803097:	89 c3                	mov    %eax,%ebx
  803099:	83 ec 0c             	sub    $0xc,%esp
  80309c:	ff 75 0c             	pushl  0xc(%ebp)
  80309f:	e8 46 f0 ff ff       	call   8020ea <get_block_size>
  8030a4:	83 c4 10             	add    $0x10,%esp
  8030a7:	01 d8                	add    %ebx,%eax
  8030a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8030ac:	83 ec 04             	sub    $0x4,%esp
  8030af:	6a 00                	push   $0x0
  8030b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030b4:	ff 75 10             	pushl  0x10(%ebp)
  8030b7:	e8 7f f3 ff ff       	call   80243b <set_block_data>
  8030bc:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8030c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030c9:	74 06                	je     8030d1 <merging+0x1c6>
  8030cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030cf:	75 17                	jne    8030e8 <merging+0x1dd>
  8030d1:	83 ec 04             	sub    $0x4,%esp
  8030d4:	68 e4 47 80 00       	push   $0x8047e4
  8030d9:	68 8d 01 00 00       	push   $0x18d
  8030de:	68 29 47 80 00       	push   $0x804729
  8030e3:	e8 aa d4 ff ff       	call   800592 <_panic>
  8030e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030eb:	8b 50 04             	mov    0x4(%eax),%edx
  8030ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f1:	89 50 04             	mov    %edx,0x4(%eax)
  8030f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030fa:	89 10                	mov    %edx,(%eax)
  8030fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ff:	8b 40 04             	mov    0x4(%eax),%eax
  803102:	85 c0                	test   %eax,%eax
  803104:	74 0d                	je     803113 <merging+0x208>
  803106:	8b 45 0c             	mov    0xc(%ebp),%eax
  803109:	8b 40 04             	mov    0x4(%eax),%eax
  80310c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80310f:	89 10                	mov    %edx,(%eax)
  803111:	eb 08                	jmp    80311b <merging+0x210>
  803113:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803116:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80311b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803121:	89 50 04             	mov    %edx,0x4(%eax)
  803124:	a1 38 50 80 00       	mov    0x805038,%eax
  803129:	40                   	inc    %eax
  80312a:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80312f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803133:	75 17                	jne    80314c <merging+0x241>
  803135:	83 ec 04             	sub    $0x4,%esp
  803138:	68 0b 47 80 00       	push   $0x80470b
  80313d:	68 8e 01 00 00       	push   $0x18e
  803142:	68 29 47 80 00       	push   $0x804729
  803147:	e8 46 d4 ff ff       	call   800592 <_panic>
  80314c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314f:	8b 00                	mov    (%eax),%eax
  803151:	85 c0                	test   %eax,%eax
  803153:	74 10                	je     803165 <merging+0x25a>
  803155:	8b 45 0c             	mov    0xc(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80315d:	8b 52 04             	mov    0x4(%edx),%edx
  803160:	89 50 04             	mov    %edx,0x4(%eax)
  803163:	eb 0b                	jmp    803170 <merging+0x265>
  803165:	8b 45 0c             	mov    0xc(%ebp),%eax
  803168:	8b 40 04             	mov    0x4(%eax),%eax
  80316b:	a3 30 50 80 00       	mov    %eax,0x805030
  803170:	8b 45 0c             	mov    0xc(%ebp),%eax
  803173:	8b 40 04             	mov    0x4(%eax),%eax
  803176:	85 c0                	test   %eax,%eax
  803178:	74 0f                	je     803189 <merging+0x27e>
  80317a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317d:	8b 40 04             	mov    0x4(%eax),%eax
  803180:	8b 55 0c             	mov    0xc(%ebp),%edx
  803183:	8b 12                	mov    (%edx),%edx
  803185:	89 10                	mov    %edx,(%eax)
  803187:	eb 0a                	jmp    803193 <merging+0x288>
  803189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318c:	8b 00                	mov    (%eax),%eax
  80318e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803193:	8b 45 0c             	mov    0xc(%ebp),%eax
  803196:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80319c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80319f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8031ab:	48                   	dec    %eax
  8031ac:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031b1:	e9 72 01 00 00       	jmp    803328 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8031b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8031b9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c0:	74 79                	je     80323b <merging+0x330>
  8031c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031c6:	74 73                	je     80323b <merging+0x330>
  8031c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031cc:	74 06                	je     8031d4 <merging+0x2c9>
  8031ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031d2:	75 17                	jne    8031eb <merging+0x2e0>
  8031d4:	83 ec 04             	sub    $0x4,%esp
  8031d7:	68 9c 47 80 00       	push   $0x80479c
  8031dc:	68 94 01 00 00       	push   $0x194
  8031e1:	68 29 47 80 00       	push   $0x804729
  8031e6:	e8 a7 d3 ff ff       	call   800592 <_panic>
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	8b 10                	mov    (%eax),%edx
  8031f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f3:	89 10                	mov    %edx,(%eax)
  8031f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	85 c0                	test   %eax,%eax
  8031fc:	74 0b                	je     803209 <merging+0x2fe>
  8031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803206:	89 50 04             	mov    %edx,0x4(%eax)
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80320f:	89 10                	mov    %edx,(%eax)
  803211:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803214:	8b 55 08             	mov    0x8(%ebp),%edx
  803217:	89 50 04             	mov    %edx,0x4(%eax)
  80321a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321d:	8b 00                	mov    (%eax),%eax
  80321f:	85 c0                	test   %eax,%eax
  803221:	75 08                	jne    80322b <merging+0x320>
  803223:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803226:	a3 30 50 80 00       	mov    %eax,0x805030
  80322b:	a1 38 50 80 00       	mov    0x805038,%eax
  803230:	40                   	inc    %eax
  803231:	a3 38 50 80 00       	mov    %eax,0x805038
  803236:	e9 ce 00 00 00       	jmp    803309 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80323b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323f:	74 65                	je     8032a6 <merging+0x39b>
  803241:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803245:	75 17                	jne    80325e <merging+0x353>
  803247:	83 ec 04             	sub    $0x4,%esp
  80324a:	68 78 47 80 00       	push   $0x804778
  80324f:	68 95 01 00 00       	push   $0x195
  803254:	68 29 47 80 00       	push   $0x804729
  803259:	e8 34 d3 ff ff       	call   800592 <_panic>
  80325e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803264:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803267:	89 50 04             	mov    %edx,0x4(%eax)
  80326a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80326d:	8b 40 04             	mov    0x4(%eax),%eax
  803270:	85 c0                	test   %eax,%eax
  803272:	74 0c                	je     803280 <merging+0x375>
  803274:	a1 30 50 80 00       	mov    0x805030,%eax
  803279:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80327c:	89 10                	mov    %edx,(%eax)
  80327e:	eb 08                	jmp    803288 <merging+0x37d>
  803280:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803283:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803288:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328b:	a3 30 50 80 00       	mov    %eax,0x805030
  803290:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803299:	a1 38 50 80 00       	mov    0x805038,%eax
  80329e:	40                   	inc    %eax
  80329f:	a3 38 50 80 00       	mov    %eax,0x805038
  8032a4:	eb 63                	jmp    803309 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8032a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032aa:	75 17                	jne    8032c3 <merging+0x3b8>
  8032ac:	83 ec 04             	sub    $0x4,%esp
  8032af:	68 44 47 80 00       	push   $0x804744
  8032b4:	68 98 01 00 00       	push   $0x198
  8032b9:	68 29 47 80 00       	push   $0x804729
  8032be:	e8 cf d2 ff ff       	call   800592 <_panic>
  8032c3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032cc:	89 10                	mov    %edx,(%eax)
  8032ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d1:	8b 00                	mov    (%eax),%eax
  8032d3:	85 c0                	test   %eax,%eax
  8032d5:	74 0d                	je     8032e4 <merging+0x3d9>
  8032d7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032df:	89 50 04             	mov    %edx,0x4(%eax)
  8032e2:	eb 08                	jmp    8032ec <merging+0x3e1>
  8032e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8032ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fe:	a1 38 50 80 00       	mov    0x805038,%eax
  803303:	40                   	inc    %eax
  803304:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803309:	83 ec 0c             	sub    $0xc,%esp
  80330c:	ff 75 10             	pushl  0x10(%ebp)
  80330f:	e8 d6 ed ff ff       	call   8020ea <get_block_size>
  803314:	83 c4 10             	add    $0x10,%esp
  803317:	83 ec 04             	sub    $0x4,%esp
  80331a:	6a 00                	push   $0x0
  80331c:	50                   	push   %eax
  80331d:	ff 75 10             	pushl  0x10(%ebp)
  803320:	e8 16 f1 ff ff       	call   80243b <set_block_data>
  803325:	83 c4 10             	add    $0x10,%esp
	}
}
  803328:	90                   	nop
  803329:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80332c:	c9                   	leave  
  80332d:	c3                   	ret    

0080332e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80332e:	55                   	push   %ebp
  80332f:	89 e5                	mov    %esp,%ebp
  803331:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803334:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803339:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80333c:	a1 30 50 80 00       	mov    0x805030,%eax
  803341:	3b 45 08             	cmp    0x8(%ebp),%eax
  803344:	73 1b                	jae    803361 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803346:	a1 30 50 80 00       	mov    0x805030,%eax
  80334b:	83 ec 04             	sub    $0x4,%esp
  80334e:	ff 75 08             	pushl  0x8(%ebp)
  803351:	6a 00                	push   $0x0
  803353:	50                   	push   %eax
  803354:	e8 b2 fb ff ff       	call   802f0b <merging>
  803359:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80335c:	e9 8b 00 00 00       	jmp    8033ec <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803361:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803366:	3b 45 08             	cmp    0x8(%ebp),%eax
  803369:	76 18                	jbe    803383 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80336b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803370:	83 ec 04             	sub    $0x4,%esp
  803373:	ff 75 08             	pushl  0x8(%ebp)
  803376:	50                   	push   %eax
  803377:	6a 00                	push   $0x0
  803379:	e8 8d fb ff ff       	call   802f0b <merging>
  80337e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803381:	eb 69                	jmp    8033ec <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803383:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803388:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80338b:	eb 39                	jmp    8033c6 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	3b 45 08             	cmp    0x8(%ebp),%eax
  803393:	73 29                	jae    8033be <free_block+0x90>
  803395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803398:	8b 00                	mov    (%eax),%eax
  80339a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80339d:	76 1f                	jbe    8033be <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8033a7:	83 ec 04             	sub    $0x4,%esp
  8033aa:	ff 75 08             	pushl  0x8(%ebp)
  8033ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8033b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8033b3:	e8 53 fb ff ff       	call   802f0b <merging>
  8033b8:	83 c4 10             	add    $0x10,%esp
			break;
  8033bb:	90                   	nop
		}
	}
}
  8033bc:	eb 2e                	jmp    8033ec <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033be:	a1 34 50 80 00       	mov    0x805034,%eax
  8033c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ca:	74 07                	je     8033d3 <free_block+0xa5>
  8033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cf:	8b 00                	mov    (%eax),%eax
  8033d1:	eb 05                	jmp    8033d8 <free_block+0xaa>
  8033d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d8:	a3 34 50 80 00       	mov    %eax,0x805034
  8033dd:	a1 34 50 80 00       	mov    0x805034,%eax
  8033e2:	85 c0                	test   %eax,%eax
  8033e4:	75 a7                	jne    80338d <free_block+0x5f>
  8033e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ea:	75 a1                	jne    80338d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033ec:	90                   	nop
  8033ed:	c9                   	leave  
  8033ee:	c3                   	ret    

008033ef <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033ef:	55                   	push   %ebp
  8033f0:	89 e5                	mov    %esp,%ebp
  8033f2:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033f5:	ff 75 08             	pushl  0x8(%ebp)
  8033f8:	e8 ed ec ff ff       	call   8020ea <get_block_size>
  8033fd:	83 c4 04             	add    $0x4,%esp
  803400:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803403:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80340a:	eb 17                	jmp    803423 <copy_data+0x34>
  80340c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80340f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803412:	01 c2                	add    %eax,%edx
  803414:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803417:	8b 45 08             	mov    0x8(%ebp),%eax
  80341a:	01 c8                	add    %ecx,%eax
  80341c:	8a 00                	mov    (%eax),%al
  80341e:	88 02                	mov    %al,(%edx)
  803420:	ff 45 fc             	incl   -0x4(%ebp)
  803423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803426:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803429:	72 e1                	jb     80340c <copy_data+0x1d>
}
  80342b:	90                   	nop
  80342c:	c9                   	leave  
  80342d:	c3                   	ret    

0080342e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80342e:	55                   	push   %ebp
  80342f:	89 e5                	mov    %esp,%ebp
  803431:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803434:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803438:	75 23                	jne    80345d <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80343a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80343e:	74 13                	je     803453 <realloc_block_FF+0x25>
  803440:	83 ec 0c             	sub    $0xc,%esp
  803443:	ff 75 0c             	pushl  0xc(%ebp)
  803446:	e8 1f f0 ff ff       	call   80246a <alloc_block_FF>
  80344b:	83 c4 10             	add    $0x10,%esp
  80344e:	e9 f4 06 00 00       	jmp    803b47 <realloc_block_FF+0x719>
		return NULL;
  803453:	b8 00 00 00 00       	mov    $0x0,%eax
  803458:	e9 ea 06 00 00       	jmp    803b47 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80345d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803461:	75 18                	jne    80347b <realloc_block_FF+0x4d>
	{
		free_block(va);
  803463:	83 ec 0c             	sub    $0xc,%esp
  803466:	ff 75 08             	pushl  0x8(%ebp)
  803469:	e8 c0 fe ff ff       	call   80332e <free_block>
  80346e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803471:	b8 00 00 00 00       	mov    $0x0,%eax
  803476:	e9 cc 06 00 00       	jmp    803b47 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80347b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80347f:	77 07                	ja     803488 <realloc_block_FF+0x5a>
  803481:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348b:	83 e0 01             	and    $0x1,%eax
  80348e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803491:	8b 45 0c             	mov    0xc(%ebp),%eax
  803494:	83 c0 08             	add    $0x8,%eax
  803497:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80349a:	83 ec 0c             	sub    $0xc,%esp
  80349d:	ff 75 08             	pushl  0x8(%ebp)
  8034a0:	e8 45 ec ff ff       	call   8020ea <get_block_size>
  8034a5:	83 c4 10             	add    $0x10,%esp
  8034a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ae:	83 e8 08             	sub    $0x8,%eax
  8034b1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b7:	83 e8 04             	sub    $0x4,%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	83 e0 fe             	and    $0xfffffffe,%eax
  8034bf:	89 c2                	mov    %eax,%edx
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	01 d0                	add    %edx,%eax
  8034c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034c9:	83 ec 0c             	sub    $0xc,%esp
  8034cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034cf:	e8 16 ec ff ff       	call   8020ea <get_block_size>
  8034d4:	83 c4 10             	add    $0x10,%esp
  8034d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034dd:	83 e8 08             	sub    $0x8,%eax
  8034e0:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034e9:	75 08                	jne    8034f3 <realloc_block_FF+0xc5>
	{
		 return va;
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	e9 54 06 00 00       	jmp    803b47 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8034f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034f9:	0f 83 e5 03 00 00    	jae    8038e4 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803502:	2b 45 0c             	sub    0xc(%ebp),%eax
  803505:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803508:	83 ec 0c             	sub    $0xc,%esp
  80350b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80350e:	e8 f0 eb ff ff       	call   802103 <is_free_block>
  803513:	83 c4 10             	add    $0x10,%esp
  803516:	84 c0                	test   %al,%al
  803518:	0f 84 3b 01 00 00    	je     803659 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80351e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803521:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803524:	01 d0                	add    %edx,%eax
  803526:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803529:	83 ec 04             	sub    $0x4,%esp
  80352c:	6a 01                	push   $0x1
  80352e:	ff 75 f0             	pushl  -0x10(%ebp)
  803531:	ff 75 08             	pushl  0x8(%ebp)
  803534:	e8 02 ef ff ff       	call   80243b <set_block_data>
  803539:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80353c:	8b 45 08             	mov    0x8(%ebp),%eax
  80353f:	83 e8 04             	sub    $0x4,%eax
  803542:	8b 00                	mov    (%eax),%eax
  803544:	83 e0 fe             	and    $0xfffffffe,%eax
  803547:	89 c2                	mov    %eax,%edx
  803549:	8b 45 08             	mov    0x8(%ebp),%eax
  80354c:	01 d0                	add    %edx,%eax
  80354e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803551:	83 ec 04             	sub    $0x4,%esp
  803554:	6a 00                	push   $0x0
  803556:	ff 75 cc             	pushl  -0x34(%ebp)
  803559:	ff 75 c8             	pushl  -0x38(%ebp)
  80355c:	e8 da ee ff ff       	call   80243b <set_block_data>
  803561:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803564:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803568:	74 06                	je     803570 <realloc_block_FF+0x142>
  80356a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80356e:	75 17                	jne    803587 <realloc_block_FF+0x159>
  803570:	83 ec 04             	sub    $0x4,%esp
  803573:	68 9c 47 80 00       	push   $0x80479c
  803578:	68 f6 01 00 00       	push   $0x1f6
  80357d:	68 29 47 80 00       	push   $0x804729
  803582:	e8 0b d0 ff ff       	call   800592 <_panic>
  803587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358a:	8b 10                	mov    (%eax),%edx
  80358c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80358f:	89 10                	mov    %edx,(%eax)
  803591:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803594:	8b 00                	mov    (%eax),%eax
  803596:	85 c0                	test   %eax,%eax
  803598:	74 0b                	je     8035a5 <realloc_block_FF+0x177>
  80359a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359d:	8b 00                	mov    (%eax),%eax
  80359f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035a2:	89 50 04             	mov    %edx,0x4(%eax)
  8035a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035ab:	89 10                	mov    %edx,(%eax)
  8035ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035b3:	89 50 04             	mov    %edx,0x4(%eax)
  8035b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035b9:	8b 00                	mov    (%eax),%eax
  8035bb:	85 c0                	test   %eax,%eax
  8035bd:	75 08                	jne    8035c7 <realloc_block_FF+0x199>
  8035bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c7:	a1 38 50 80 00       	mov    0x805038,%eax
  8035cc:	40                   	inc    %eax
  8035cd:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035d6:	75 17                	jne    8035ef <realloc_block_FF+0x1c1>
  8035d8:	83 ec 04             	sub    $0x4,%esp
  8035db:	68 0b 47 80 00       	push   $0x80470b
  8035e0:	68 f7 01 00 00       	push   $0x1f7
  8035e5:	68 29 47 80 00       	push   $0x804729
  8035ea:	e8 a3 cf ff ff       	call   800592 <_panic>
  8035ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f2:	8b 00                	mov    (%eax),%eax
  8035f4:	85 c0                	test   %eax,%eax
  8035f6:	74 10                	je     803608 <realloc_block_FF+0x1da>
  8035f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fb:	8b 00                	mov    (%eax),%eax
  8035fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803600:	8b 52 04             	mov    0x4(%edx),%edx
  803603:	89 50 04             	mov    %edx,0x4(%eax)
  803606:	eb 0b                	jmp    803613 <realloc_block_FF+0x1e5>
  803608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360b:	8b 40 04             	mov    0x4(%eax),%eax
  80360e:	a3 30 50 80 00       	mov    %eax,0x805030
  803613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803616:	8b 40 04             	mov    0x4(%eax),%eax
  803619:	85 c0                	test   %eax,%eax
  80361b:	74 0f                	je     80362c <realloc_block_FF+0x1fe>
  80361d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803620:	8b 40 04             	mov    0x4(%eax),%eax
  803623:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803626:	8b 12                	mov    (%edx),%edx
  803628:	89 10                	mov    %edx,(%eax)
  80362a:	eb 0a                	jmp    803636 <realloc_block_FF+0x208>
  80362c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362f:	8b 00                	mov    (%eax),%eax
  803631:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803639:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80363f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803642:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803649:	a1 38 50 80 00       	mov    0x805038,%eax
  80364e:	48                   	dec    %eax
  80364f:	a3 38 50 80 00       	mov    %eax,0x805038
  803654:	e9 83 02 00 00       	jmp    8038dc <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803659:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80365d:	0f 86 69 02 00 00    	jbe    8038cc <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803663:	83 ec 04             	sub    $0x4,%esp
  803666:	6a 01                	push   $0x1
  803668:	ff 75 f0             	pushl  -0x10(%ebp)
  80366b:	ff 75 08             	pushl  0x8(%ebp)
  80366e:	e8 c8 ed ff ff       	call   80243b <set_block_data>
  803673:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803676:	8b 45 08             	mov    0x8(%ebp),%eax
  803679:	83 e8 04             	sub    $0x4,%eax
  80367c:	8b 00                	mov    (%eax),%eax
  80367e:	83 e0 fe             	and    $0xfffffffe,%eax
  803681:	89 c2                	mov    %eax,%edx
  803683:	8b 45 08             	mov    0x8(%ebp),%eax
  803686:	01 d0                	add    %edx,%eax
  803688:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80368b:	a1 38 50 80 00       	mov    0x805038,%eax
  803690:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803693:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803697:	75 68                	jne    803701 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803699:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80369d:	75 17                	jne    8036b6 <realloc_block_FF+0x288>
  80369f:	83 ec 04             	sub    $0x4,%esp
  8036a2:	68 44 47 80 00       	push   $0x804744
  8036a7:	68 06 02 00 00       	push   $0x206
  8036ac:	68 29 47 80 00       	push   $0x804729
  8036b1:	e8 dc ce ff ff       	call   800592 <_panic>
  8036b6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036bf:	89 10                	mov    %edx,(%eax)
  8036c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c4:	8b 00                	mov    (%eax),%eax
  8036c6:	85 c0                	test   %eax,%eax
  8036c8:	74 0d                	je     8036d7 <realloc_block_FF+0x2a9>
  8036ca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036d2:	89 50 04             	mov    %edx,0x4(%eax)
  8036d5:	eb 08                	jmp    8036df <realloc_block_FF+0x2b1>
  8036d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036da:	a3 30 50 80 00       	mov    %eax,0x805030
  8036df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f1:	a1 38 50 80 00       	mov    0x805038,%eax
  8036f6:	40                   	inc    %eax
  8036f7:	a3 38 50 80 00       	mov    %eax,0x805038
  8036fc:	e9 b0 01 00 00       	jmp    8038b1 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803701:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803706:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803709:	76 68                	jbe    803773 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80370b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80370f:	75 17                	jne    803728 <realloc_block_FF+0x2fa>
  803711:	83 ec 04             	sub    $0x4,%esp
  803714:	68 44 47 80 00       	push   $0x804744
  803719:	68 0b 02 00 00       	push   $0x20b
  80371e:	68 29 47 80 00       	push   $0x804729
  803723:	e8 6a ce ff ff       	call   800592 <_panic>
  803728:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80372e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803731:	89 10                	mov    %edx,(%eax)
  803733:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803736:	8b 00                	mov    (%eax),%eax
  803738:	85 c0                	test   %eax,%eax
  80373a:	74 0d                	je     803749 <realloc_block_FF+0x31b>
  80373c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803741:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803744:	89 50 04             	mov    %edx,0x4(%eax)
  803747:	eb 08                	jmp    803751 <realloc_block_FF+0x323>
  803749:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80374c:	a3 30 50 80 00       	mov    %eax,0x805030
  803751:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803754:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803759:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80375c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803763:	a1 38 50 80 00       	mov    0x805038,%eax
  803768:	40                   	inc    %eax
  803769:	a3 38 50 80 00       	mov    %eax,0x805038
  80376e:	e9 3e 01 00 00       	jmp    8038b1 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803773:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803778:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80377b:	73 68                	jae    8037e5 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80377d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803781:	75 17                	jne    80379a <realloc_block_FF+0x36c>
  803783:	83 ec 04             	sub    $0x4,%esp
  803786:	68 78 47 80 00       	push   $0x804778
  80378b:	68 10 02 00 00       	push   $0x210
  803790:	68 29 47 80 00       	push   $0x804729
  803795:	e8 f8 cd ff ff       	call   800592 <_panic>
  80379a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a3:	89 50 04             	mov    %edx,0x4(%eax)
  8037a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ac:	85 c0                	test   %eax,%eax
  8037ae:	74 0c                	je     8037bc <realloc_block_FF+0x38e>
  8037b0:	a1 30 50 80 00       	mov    0x805030,%eax
  8037b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037b8:	89 10                	mov    %edx,(%eax)
  8037ba:	eb 08                	jmp    8037c4 <realloc_block_FF+0x396>
  8037bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037bf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8037cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8037da:	40                   	inc    %eax
  8037db:	a3 38 50 80 00       	mov    %eax,0x805038
  8037e0:	e9 cc 00 00 00       	jmp    8038b1 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037ec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f4:	e9 8a 00 00 00       	jmp    803883 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037ff:	73 7a                	jae    80387b <realloc_block_FF+0x44d>
  803801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803804:	8b 00                	mov    (%eax),%eax
  803806:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803809:	73 70                	jae    80387b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80380b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80380f:	74 06                	je     803817 <realloc_block_FF+0x3e9>
  803811:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803815:	75 17                	jne    80382e <realloc_block_FF+0x400>
  803817:	83 ec 04             	sub    $0x4,%esp
  80381a:	68 9c 47 80 00       	push   $0x80479c
  80381f:	68 1a 02 00 00       	push   $0x21a
  803824:	68 29 47 80 00       	push   $0x804729
  803829:	e8 64 cd ff ff       	call   800592 <_panic>
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	8b 10                	mov    (%eax),%edx
  803833:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803836:	89 10                	mov    %edx,(%eax)
  803838:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383b:	8b 00                	mov    (%eax),%eax
  80383d:	85 c0                	test   %eax,%eax
  80383f:	74 0b                	je     80384c <realloc_block_FF+0x41e>
  803841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803844:	8b 00                	mov    (%eax),%eax
  803846:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803849:	89 50 04             	mov    %edx,0x4(%eax)
  80384c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803852:	89 10                	mov    %edx,(%eax)
  803854:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803857:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80385a:	89 50 04             	mov    %edx,0x4(%eax)
  80385d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803860:	8b 00                	mov    (%eax),%eax
  803862:	85 c0                	test   %eax,%eax
  803864:	75 08                	jne    80386e <realloc_block_FF+0x440>
  803866:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803869:	a3 30 50 80 00       	mov    %eax,0x805030
  80386e:	a1 38 50 80 00       	mov    0x805038,%eax
  803873:	40                   	inc    %eax
  803874:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803879:	eb 36                	jmp    8038b1 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80387b:	a1 34 50 80 00       	mov    0x805034,%eax
  803880:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803887:	74 07                	je     803890 <realloc_block_FF+0x462>
  803889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388c:	8b 00                	mov    (%eax),%eax
  80388e:	eb 05                	jmp    803895 <realloc_block_FF+0x467>
  803890:	b8 00 00 00 00       	mov    $0x0,%eax
  803895:	a3 34 50 80 00       	mov    %eax,0x805034
  80389a:	a1 34 50 80 00       	mov    0x805034,%eax
  80389f:	85 c0                	test   %eax,%eax
  8038a1:	0f 85 52 ff ff ff    	jne    8037f9 <realloc_block_FF+0x3cb>
  8038a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ab:	0f 85 48 ff ff ff    	jne    8037f9 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8038b1:	83 ec 04             	sub    $0x4,%esp
  8038b4:	6a 00                	push   $0x0
  8038b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8038b9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038bc:	e8 7a eb ff ff       	call   80243b <set_block_data>
  8038c1:	83 c4 10             	add    $0x10,%esp
				return va;
  8038c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c7:	e9 7b 02 00 00       	jmp    803b47 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8038cc:	83 ec 0c             	sub    $0xc,%esp
  8038cf:	68 19 48 80 00       	push   $0x804819
  8038d4:	e8 76 cf ff ff       	call   80084f <cprintf>
  8038d9:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8038dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038df:	e9 63 02 00 00       	jmp    803b47 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8038e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038ea:	0f 86 4d 02 00 00    	jbe    803b3d <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8038f0:	83 ec 0c             	sub    $0xc,%esp
  8038f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038f6:	e8 08 e8 ff ff       	call   802103 <is_free_block>
  8038fb:	83 c4 10             	add    $0x10,%esp
  8038fe:	84 c0                	test   %al,%al
  803900:	0f 84 37 02 00 00    	je     803b3d <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803906:	8b 45 0c             	mov    0xc(%ebp),%eax
  803909:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80390c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80390f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803912:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803915:	76 38                	jbe    80394f <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803917:	83 ec 0c             	sub    $0xc,%esp
  80391a:	ff 75 08             	pushl  0x8(%ebp)
  80391d:	e8 0c fa ff ff       	call   80332e <free_block>
  803922:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803925:	83 ec 0c             	sub    $0xc,%esp
  803928:	ff 75 0c             	pushl  0xc(%ebp)
  80392b:	e8 3a eb ff ff       	call   80246a <alloc_block_FF>
  803930:	83 c4 10             	add    $0x10,%esp
  803933:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803936:	83 ec 08             	sub    $0x8,%esp
  803939:	ff 75 c0             	pushl  -0x40(%ebp)
  80393c:	ff 75 08             	pushl  0x8(%ebp)
  80393f:	e8 ab fa ff ff       	call   8033ef <copy_data>
  803944:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803947:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80394a:	e9 f8 01 00 00       	jmp    803b47 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80394f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803952:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803955:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803958:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80395c:	0f 87 a0 00 00 00    	ja     803a02 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803962:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803966:	75 17                	jne    80397f <realloc_block_FF+0x551>
  803968:	83 ec 04             	sub    $0x4,%esp
  80396b:	68 0b 47 80 00       	push   $0x80470b
  803970:	68 38 02 00 00       	push   $0x238
  803975:	68 29 47 80 00       	push   $0x804729
  80397a:	e8 13 cc ff ff       	call   800592 <_panic>
  80397f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803982:	8b 00                	mov    (%eax),%eax
  803984:	85 c0                	test   %eax,%eax
  803986:	74 10                	je     803998 <realloc_block_FF+0x56a>
  803988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398b:	8b 00                	mov    (%eax),%eax
  80398d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803990:	8b 52 04             	mov    0x4(%edx),%edx
  803993:	89 50 04             	mov    %edx,0x4(%eax)
  803996:	eb 0b                	jmp    8039a3 <realloc_block_FF+0x575>
  803998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399b:	8b 40 04             	mov    0x4(%eax),%eax
  80399e:	a3 30 50 80 00       	mov    %eax,0x805030
  8039a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a6:	8b 40 04             	mov    0x4(%eax),%eax
  8039a9:	85 c0                	test   %eax,%eax
  8039ab:	74 0f                	je     8039bc <realloc_block_FF+0x58e>
  8039ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b0:	8b 40 04             	mov    0x4(%eax),%eax
  8039b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039b6:	8b 12                	mov    (%edx),%edx
  8039b8:	89 10                	mov    %edx,(%eax)
  8039ba:	eb 0a                	jmp    8039c6 <realloc_block_FF+0x598>
  8039bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bf:	8b 00                	mov    (%eax),%eax
  8039c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8039de:	48                   	dec    %eax
  8039df:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039ea:	01 d0                	add    %edx,%eax
  8039ec:	83 ec 04             	sub    $0x4,%esp
  8039ef:	6a 01                	push   $0x1
  8039f1:	50                   	push   %eax
  8039f2:	ff 75 08             	pushl  0x8(%ebp)
  8039f5:	e8 41 ea ff ff       	call   80243b <set_block_data>
  8039fa:	83 c4 10             	add    $0x10,%esp
  8039fd:	e9 36 01 00 00       	jmp    803b38 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803a02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a05:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a08:	01 d0                	add    %edx,%eax
  803a0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a0d:	83 ec 04             	sub    $0x4,%esp
  803a10:	6a 01                	push   $0x1
  803a12:	ff 75 f0             	pushl  -0x10(%ebp)
  803a15:	ff 75 08             	pushl  0x8(%ebp)
  803a18:	e8 1e ea ff ff       	call   80243b <set_block_data>
  803a1d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a20:	8b 45 08             	mov    0x8(%ebp),%eax
  803a23:	83 e8 04             	sub    $0x4,%eax
  803a26:	8b 00                	mov    (%eax),%eax
  803a28:	83 e0 fe             	and    $0xfffffffe,%eax
  803a2b:	89 c2                	mov    %eax,%edx
  803a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a30:	01 d0                	add    %edx,%eax
  803a32:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a39:	74 06                	je     803a41 <realloc_block_FF+0x613>
  803a3b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a3f:	75 17                	jne    803a58 <realloc_block_FF+0x62a>
  803a41:	83 ec 04             	sub    $0x4,%esp
  803a44:	68 9c 47 80 00       	push   $0x80479c
  803a49:	68 44 02 00 00       	push   $0x244
  803a4e:	68 29 47 80 00       	push   $0x804729
  803a53:	e8 3a cb ff ff       	call   800592 <_panic>
  803a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5b:	8b 10                	mov    (%eax),%edx
  803a5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a60:	89 10                	mov    %edx,(%eax)
  803a62:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a65:	8b 00                	mov    (%eax),%eax
  803a67:	85 c0                	test   %eax,%eax
  803a69:	74 0b                	je     803a76 <realloc_block_FF+0x648>
  803a6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6e:	8b 00                	mov    (%eax),%eax
  803a70:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a73:	89 50 04             	mov    %edx,0x4(%eax)
  803a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a79:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a7c:	89 10                	mov    %edx,(%eax)
  803a7e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a84:	89 50 04             	mov    %edx,0x4(%eax)
  803a87:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a8a:	8b 00                	mov    (%eax),%eax
  803a8c:	85 c0                	test   %eax,%eax
  803a8e:	75 08                	jne    803a98 <realloc_block_FF+0x66a>
  803a90:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a93:	a3 30 50 80 00       	mov    %eax,0x805030
  803a98:	a1 38 50 80 00       	mov    0x805038,%eax
  803a9d:	40                   	inc    %eax
  803a9e:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803aa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803aa7:	75 17                	jne    803ac0 <realloc_block_FF+0x692>
  803aa9:	83 ec 04             	sub    $0x4,%esp
  803aac:	68 0b 47 80 00       	push   $0x80470b
  803ab1:	68 45 02 00 00       	push   $0x245
  803ab6:	68 29 47 80 00       	push   $0x804729
  803abb:	e8 d2 ca ff ff       	call   800592 <_panic>
  803ac0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac3:	8b 00                	mov    (%eax),%eax
  803ac5:	85 c0                	test   %eax,%eax
  803ac7:	74 10                	je     803ad9 <realloc_block_FF+0x6ab>
  803ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acc:	8b 00                	mov    (%eax),%eax
  803ace:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad1:	8b 52 04             	mov    0x4(%edx),%edx
  803ad4:	89 50 04             	mov    %edx,0x4(%eax)
  803ad7:	eb 0b                	jmp    803ae4 <realloc_block_FF+0x6b6>
  803ad9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803adc:	8b 40 04             	mov    0x4(%eax),%eax
  803adf:	a3 30 50 80 00       	mov    %eax,0x805030
  803ae4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae7:	8b 40 04             	mov    0x4(%eax),%eax
  803aea:	85 c0                	test   %eax,%eax
  803aec:	74 0f                	je     803afd <realloc_block_FF+0x6cf>
  803aee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af1:	8b 40 04             	mov    0x4(%eax),%eax
  803af4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803af7:	8b 12                	mov    (%edx),%edx
  803af9:	89 10                	mov    %edx,(%eax)
  803afb:	eb 0a                	jmp    803b07 <realloc_block_FF+0x6d9>
  803afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b00:	8b 00                	mov    (%eax),%eax
  803b02:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b1a:	a1 38 50 80 00       	mov    0x805038,%eax
  803b1f:	48                   	dec    %eax
  803b20:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b25:	83 ec 04             	sub    $0x4,%esp
  803b28:	6a 00                	push   $0x0
  803b2a:	ff 75 bc             	pushl  -0x44(%ebp)
  803b2d:	ff 75 b8             	pushl  -0x48(%ebp)
  803b30:	e8 06 e9 ff ff       	call   80243b <set_block_data>
  803b35:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b38:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3b:	eb 0a                	jmp    803b47 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b3d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b44:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b47:	c9                   	leave  
  803b48:	c3                   	ret    

00803b49 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b49:	55                   	push   %ebp
  803b4a:	89 e5                	mov    %esp,%ebp
  803b4c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b4f:	83 ec 04             	sub    $0x4,%esp
  803b52:	68 20 48 80 00       	push   $0x804820
  803b57:	68 58 02 00 00       	push   $0x258
  803b5c:	68 29 47 80 00       	push   $0x804729
  803b61:	e8 2c ca ff ff       	call   800592 <_panic>

00803b66 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b66:	55                   	push   %ebp
  803b67:	89 e5                	mov    %esp,%ebp
  803b69:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b6c:	83 ec 04             	sub    $0x4,%esp
  803b6f:	68 48 48 80 00       	push   $0x804848
  803b74:	68 61 02 00 00       	push   $0x261
  803b79:	68 29 47 80 00       	push   $0x804729
  803b7e:	e8 0f ca ff ff       	call   800592 <_panic>
  803b83:	90                   	nop

00803b84 <__udivdi3>:
  803b84:	55                   	push   %ebp
  803b85:	57                   	push   %edi
  803b86:	56                   	push   %esi
  803b87:	53                   	push   %ebx
  803b88:	83 ec 1c             	sub    $0x1c,%esp
  803b8b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b9b:	89 ca                	mov    %ecx,%edx
  803b9d:	89 f8                	mov    %edi,%eax
  803b9f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ba3:	85 f6                	test   %esi,%esi
  803ba5:	75 2d                	jne    803bd4 <__udivdi3+0x50>
  803ba7:	39 cf                	cmp    %ecx,%edi
  803ba9:	77 65                	ja     803c10 <__udivdi3+0x8c>
  803bab:	89 fd                	mov    %edi,%ebp
  803bad:	85 ff                	test   %edi,%edi
  803baf:	75 0b                	jne    803bbc <__udivdi3+0x38>
  803bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  803bb6:	31 d2                	xor    %edx,%edx
  803bb8:	f7 f7                	div    %edi
  803bba:	89 c5                	mov    %eax,%ebp
  803bbc:	31 d2                	xor    %edx,%edx
  803bbe:	89 c8                	mov    %ecx,%eax
  803bc0:	f7 f5                	div    %ebp
  803bc2:	89 c1                	mov    %eax,%ecx
  803bc4:	89 d8                	mov    %ebx,%eax
  803bc6:	f7 f5                	div    %ebp
  803bc8:	89 cf                	mov    %ecx,%edi
  803bca:	89 fa                	mov    %edi,%edx
  803bcc:	83 c4 1c             	add    $0x1c,%esp
  803bcf:	5b                   	pop    %ebx
  803bd0:	5e                   	pop    %esi
  803bd1:	5f                   	pop    %edi
  803bd2:	5d                   	pop    %ebp
  803bd3:	c3                   	ret    
  803bd4:	39 ce                	cmp    %ecx,%esi
  803bd6:	77 28                	ja     803c00 <__udivdi3+0x7c>
  803bd8:	0f bd fe             	bsr    %esi,%edi
  803bdb:	83 f7 1f             	xor    $0x1f,%edi
  803bde:	75 40                	jne    803c20 <__udivdi3+0x9c>
  803be0:	39 ce                	cmp    %ecx,%esi
  803be2:	72 0a                	jb     803bee <__udivdi3+0x6a>
  803be4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803be8:	0f 87 9e 00 00 00    	ja     803c8c <__udivdi3+0x108>
  803bee:	b8 01 00 00 00       	mov    $0x1,%eax
  803bf3:	89 fa                	mov    %edi,%edx
  803bf5:	83 c4 1c             	add    $0x1c,%esp
  803bf8:	5b                   	pop    %ebx
  803bf9:	5e                   	pop    %esi
  803bfa:	5f                   	pop    %edi
  803bfb:	5d                   	pop    %ebp
  803bfc:	c3                   	ret    
  803bfd:	8d 76 00             	lea    0x0(%esi),%esi
  803c00:	31 ff                	xor    %edi,%edi
  803c02:	31 c0                	xor    %eax,%eax
  803c04:	89 fa                	mov    %edi,%edx
  803c06:	83 c4 1c             	add    $0x1c,%esp
  803c09:	5b                   	pop    %ebx
  803c0a:	5e                   	pop    %esi
  803c0b:	5f                   	pop    %edi
  803c0c:	5d                   	pop    %ebp
  803c0d:	c3                   	ret    
  803c0e:	66 90                	xchg   %ax,%ax
  803c10:	89 d8                	mov    %ebx,%eax
  803c12:	f7 f7                	div    %edi
  803c14:	31 ff                	xor    %edi,%edi
  803c16:	89 fa                	mov    %edi,%edx
  803c18:	83 c4 1c             	add    $0x1c,%esp
  803c1b:	5b                   	pop    %ebx
  803c1c:	5e                   	pop    %esi
  803c1d:	5f                   	pop    %edi
  803c1e:	5d                   	pop    %ebp
  803c1f:	c3                   	ret    
  803c20:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c25:	89 eb                	mov    %ebp,%ebx
  803c27:	29 fb                	sub    %edi,%ebx
  803c29:	89 f9                	mov    %edi,%ecx
  803c2b:	d3 e6                	shl    %cl,%esi
  803c2d:	89 c5                	mov    %eax,%ebp
  803c2f:	88 d9                	mov    %bl,%cl
  803c31:	d3 ed                	shr    %cl,%ebp
  803c33:	89 e9                	mov    %ebp,%ecx
  803c35:	09 f1                	or     %esi,%ecx
  803c37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c3b:	89 f9                	mov    %edi,%ecx
  803c3d:	d3 e0                	shl    %cl,%eax
  803c3f:	89 c5                	mov    %eax,%ebp
  803c41:	89 d6                	mov    %edx,%esi
  803c43:	88 d9                	mov    %bl,%cl
  803c45:	d3 ee                	shr    %cl,%esi
  803c47:	89 f9                	mov    %edi,%ecx
  803c49:	d3 e2                	shl    %cl,%edx
  803c4b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c4f:	88 d9                	mov    %bl,%cl
  803c51:	d3 e8                	shr    %cl,%eax
  803c53:	09 c2                	or     %eax,%edx
  803c55:	89 d0                	mov    %edx,%eax
  803c57:	89 f2                	mov    %esi,%edx
  803c59:	f7 74 24 0c          	divl   0xc(%esp)
  803c5d:	89 d6                	mov    %edx,%esi
  803c5f:	89 c3                	mov    %eax,%ebx
  803c61:	f7 e5                	mul    %ebp
  803c63:	39 d6                	cmp    %edx,%esi
  803c65:	72 19                	jb     803c80 <__udivdi3+0xfc>
  803c67:	74 0b                	je     803c74 <__udivdi3+0xf0>
  803c69:	89 d8                	mov    %ebx,%eax
  803c6b:	31 ff                	xor    %edi,%edi
  803c6d:	e9 58 ff ff ff       	jmp    803bca <__udivdi3+0x46>
  803c72:	66 90                	xchg   %ax,%ax
  803c74:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c78:	89 f9                	mov    %edi,%ecx
  803c7a:	d3 e2                	shl    %cl,%edx
  803c7c:	39 c2                	cmp    %eax,%edx
  803c7e:	73 e9                	jae    803c69 <__udivdi3+0xe5>
  803c80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c83:	31 ff                	xor    %edi,%edi
  803c85:	e9 40 ff ff ff       	jmp    803bca <__udivdi3+0x46>
  803c8a:	66 90                	xchg   %ax,%ax
  803c8c:	31 c0                	xor    %eax,%eax
  803c8e:	e9 37 ff ff ff       	jmp    803bca <__udivdi3+0x46>
  803c93:	90                   	nop

00803c94 <__umoddi3>:
  803c94:	55                   	push   %ebp
  803c95:	57                   	push   %edi
  803c96:	56                   	push   %esi
  803c97:	53                   	push   %ebx
  803c98:	83 ec 1c             	sub    $0x1c,%esp
  803c9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ca3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ca7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803caf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cb3:	89 f3                	mov    %esi,%ebx
  803cb5:	89 fa                	mov    %edi,%edx
  803cb7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cbb:	89 34 24             	mov    %esi,(%esp)
  803cbe:	85 c0                	test   %eax,%eax
  803cc0:	75 1a                	jne    803cdc <__umoddi3+0x48>
  803cc2:	39 f7                	cmp    %esi,%edi
  803cc4:	0f 86 a2 00 00 00    	jbe    803d6c <__umoddi3+0xd8>
  803cca:	89 c8                	mov    %ecx,%eax
  803ccc:	89 f2                	mov    %esi,%edx
  803cce:	f7 f7                	div    %edi
  803cd0:	89 d0                	mov    %edx,%eax
  803cd2:	31 d2                	xor    %edx,%edx
  803cd4:	83 c4 1c             	add    $0x1c,%esp
  803cd7:	5b                   	pop    %ebx
  803cd8:	5e                   	pop    %esi
  803cd9:	5f                   	pop    %edi
  803cda:	5d                   	pop    %ebp
  803cdb:	c3                   	ret    
  803cdc:	39 f0                	cmp    %esi,%eax
  803cde:	0f 87 ac 00 00 00    	ja     803d90 <__umoddi3+0xfc>
  803ce4:	0f bd e8             	bsr    %eax,%ebp
  803ce7:	83 f5 1f             	xor    $0x1f,%ebp
  803cea:	0f 84 ac 00 00 00    	je     803d9c <__umoddi3+0x108>
  803cf0:	bf 20 00 00 00       	mov    $0x20,%edi
  803cf5:	29 ef                	sub    %ebp,%edi
  803cf7:	89 fe                	mov    %edi,%esi
  803cf9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cfd:	89 e9                	mov    %ebp,%ecx
  803cff:	d3 e0                	shl    %cl,%eax
  803d01:	89 d7                	mov    %edx,%edi
  803d03:	89 f1                	mov    %esi,%ecx
  803d05:	d3 ef                	shr    %cl,%edi
  803d07:	09 c7                	or     %eax,%edi
  803d09:	89 e9                	mov    %ebp,%ecx
  803d0b:	d3 e2                	shl    %cl,%edx
  803d0d:	89 14 24             	mov    %edx,(%esp)
  803d10:	89 d8                	mov    %ebx,%eax
  803d12:	d3 e0                	shl    %cl,%eax
  803d14:	89 c2                	mov    %eax,%edx
  803d16:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d1a:	d3 e0                	shl    %cl,%eax
  803d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d20:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d24:	89 f1                	mov    %esi,%ecx
  803d26:	d3 e8                	shr    %cl,%eax
  803d28:	09 d0                	or     %edx,%eax
  803d2a:	d3 eb                	shr    %cl,%ebx
  803d2c:	89 da                	mov    %ebx,%edx
  803d2e:	f7 f7                	div    %edi
  803d30:	89 d3                	mov    %edx,%ebx
  803d32:	f7 24 24             	mull   (%esp)
  803d35:	89 c6                	mov    %eax,%esi
  803d37:	89 d1                	mov    %edx,%ecx
  803d39:	39 d3                	cmp    %edx,%ebx
  803d3b:	0f 82 87 00 00 00    	jb     803dc8 <__umoddi3+0x134>
  803d41:	0f 84 91 00 00 00    	je     803dd8 <__umoddi3+0x144>
  803d47:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d4b:	29 f2                	sub    %esi,%edx
  803d4d:	19 cb                	sbb    %ecx,%ebx
  803d4f:	89 d8                	mov    %ebx,%eax
  803d51:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d55:	d3 e0                	shl    %cl,%eax
  803d57:	89 e9                	mov    %ebp,%ecx
  803d59:	d3 ea                	shr    %cl,%edx
  803d5b:	09 d0                	or     %edx,%eax
  803d5d:	89 e9                	mov    %ebp,%ecx
  803d5f:	d3 eb                	shr    %cl,%ebx
  803d61:	89 da                	mov    %ebx,%edx
  803d63:	83 c4 1c             	add    $0x1c,%esp
  803d66:	5b                   	pop    %ebx
  803d67:	5e                   	pop    %esi
  803d68:	5f                   	pop    %edi
  803d69:	5d                   	pop    %ebp
  803d6a:	c3                   	ret    
  803d6b:	90                   	nop
  803d6c:	89 fd                	mov    %edi,%ebp
  803d6e:	85 ff                	test   %edi,%edi
  803d70:	75 0b                	jne    803d7d <__umoddi3+0xe9>
  803d72:	b8 01 00 00 00       	mov    $0x1,%eax
  803d77:	31 d2                	xor    %edx,%edx
  803d79:	f7 f7                	div    %edi
  803d7b:	89 c5                	mov    %eax,%ebp
  803d7d:	89 f0                	mov    %esi,%eax
  803d7f:	31 d2                	xor    %edx,%edx
  803d81:	f7 f5                	div    %ebp
  803d83:	89 c8                	mov    %ecx,%eax
  803d85:	f7 f5                	div    %ebp
  803d87:	89 d0                	mov    %edx,%eax
  803d89:	e9 44 ff ff ff       	jmp    803cd2 <__umoddi3+0x3e>
  803d8e:	66 90                	xchg   %ax,%ax
  803d90:	89 c8                	mov    %ecx,%eax
  803d92:	89 f2                	mov    %esi,%edx
  803d94:	83 c4 1c             	add    $0x1c,%esp
  803d97:	5b                   	pop    %ebx
  803d98:	5e                   	pop    %esi
  803d99:	5f                   	pop    %edi
  803d9a:	5d                   	pop    %ebp
  803d9b:	c3                   	ret    
  803d9c:	3b 04 24             	cmp    (%esp),%eax
  803d9f:	72 06                	jb     803da7 <__umoddi3+0x113>
  803da1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803da5:	77 0f                	ja     803db6 <__umoddi3+0x122>
  803da7:	89 f2                	mov    %esi,%edx
  803da9:	29 f9                	sub    %edi,%ecx
  803dab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803daf:	89 14 24             	mov    %edx,(%esp)
  803db2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803db6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dba:	8b 14 24             	mov    (%esp),%edx
  803dbd:	83 c4 1c             	add    $0x1c,%esp
  803dc0:	5b                   	pop    %ebx
  803dc1:	5e                   	pop    %esi
  803dc2:	5f                   	pop    %edi
  803dc3:	5d                   	pop    %ebp
  803dc4:	c3                   	ret    
  803dc5:	8d 76 00             	lea    0x0(%esi),%esi
  803dc8:	2b 04 24             	sub    (%esp),%eax
  803dcb:	19 fa                	sbb    %edi,%edx
  803dcd:	89 d1                	mov    %edx,%ecx
  803dcf:	89 c6                	mov    %eax,%esi
  803dd1:	e9 71 ff ff ff       	jmp    803d47 <__umoddi3+0xb3>
  803dd6:	66 90                	xchg   %ax,%ax
  803dd8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ddc:	72 ea                	jb     803dc8 <__umoddi3+0x134>
  803dde:	89 d9                	mov    %ebx,%ecx
  803de0:	e9 62 ff ff ff       	jmp    803d47 <__umoddi3+0xb3>
