
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
  80005c:	68 40 3f 80 00       	push   $0x803f40
  800061:	6a 14                	push   $0x14
  800063:	68 5c 3f 80 00       	push   $0x803f5c
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
  800082:	e8 a2 1c 00 00       	call   801d29 <sys_calculate_free_frames>
  800087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = smalloc("x", 4, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 04                	push   $0x4
  800091:	68 77 3f 80 00       	push   $0x803f77
  800096:	e8 82 18 00 00       	call   80191d <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 7c 3f 80 00       	push   $0x803f7c
  8000b8:	e8 92 07 00 00       	call   80084f <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8000c0:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8000c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ca:	e8 5a 1c 00 00       	call   801d29 <sys_calculate_free_frames>
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
  8000f3:	e8 31 1c 00 00       	call   801d29 <sys_calculate_free_frames>
  8000f8:	29 c3                	sub    %eax,%ebx
  8000fa:	89 d8                	mov    %ebx,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800102:	50                   	push   %eax
  800103:	68 e0 3f 80 00       	push   $0x803fe0
  800108:	e8 42 07 00 00       	call   80084f <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800110:	e8 14 1c 00 00       	call   801d29 <sys_calculate_free_frames>
  800115:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = smalloc("y", 4, 0);
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	6a 00                	push   $0x0
  80011d:	6a 04                	push   $0x4
  80011f:	68 78 40 80 00       	push   $0x804078
  800124:	e8 f4 17 00 00       	call   80191d <smalloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80012f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800132:	05 00 10 00 00       	add    $0x1000,%eax
  800137:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80013a:	74 17                	je     800153 <_main+0x11b>
  80013c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	68 7c 3f 80 00       	push   $0x803f7c
  80014b:	e8 ff 06 00 00       	call   80084f <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  800153:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80015a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80015d:	e8 c7 1b 00 00       	call   801d29 <sys_calculate_free_frames>
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
  800186:	e8 9e 1b 00 00       	call   801d29 <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	50                   	push   %eax
  800196:	68 e0 3f 80 00       	push   $0x803fe0
  80019b:	e8 af 06 00 00       	call   80084f <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  8001a3:	e8 81 1b 00 00       	call   801d29 <sys_calculate_free_frames>
  8001a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = smalloc("z", 4, 1);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 01                	push   $0x1
  8001b0:	6a 04                	push   $0x4
  8001b2:	68 7a 40 80 00       	push   $0x80407a
  8001b7:	e8 61 17 00 00       	call   80191d <smalloc>
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8001c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c5:	05 00 20 00 00       	add    $0x2000,%eax
  8001ca:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001cd:	74 17                	je     8001e6 <_main+0x1ae>
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	68 7c 3f 80 00       	push   $0x803f7c
  8001de:	e8 6c 06 00 00       	call   80084f <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8001e6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001f0:	e8 34 1b 00 00       	call   801d29 <sys_calculate_free_frames>
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
  800219:	e8 0b 1b 00 00       	call   801d29 <sys_calculate_free_frames>
  80021e:	29 c3                	sub    %eax,%ebx
  800220:	89 d8                	mov    %ebx,%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	50                   	push   %eax
  800229:	68 e0 3f 80 00       	push   $0x803fe0
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
  80027f:	68 7c 40 80 00       	push   $0x80407c
  800284:	e8 fb 1b 00 00       	call   801e84 <sys_create_env>
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
  8002b5:	68 7c 40 80 00       	push   $0x80407c
  8002ba:	e8 c5 1b 00 00       	call   801e84 <sys_create_env>
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
  8002eb:	68 7c 40 80 00       	push   $0x80407c
  8002f0:	e8 8f 1b 00 00       	call   801e84 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8002fb:	e8 d0 1c 00 00       	call   801fd0 <rsttst>

	sys_run_env(id1);\
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 d0             	pushl  -0x30(%ebp)
  800306:	e8 97 1b 00 00       	call   801ea2 <sys_run_env>
  80030b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 cc             	pushl  -0x34(%ebp)
  800314:	e8 89 1b 00 00       	call   801ea2 <sys_run_env>
  800319:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 c8             	pushl  -0x38(%ebp)
  800322:	e8 7b 1b 00 00       	call   801ea2 <sys_run_env>
  800327:	83 c4 10             	add    $0x10,%esp
	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  80032a:	90                   	nop
  80032b:	e8 1a 1d 00 00       	call   80204a <gettst>
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
  800349:	68 88 40 80 00       	push   $0x804088
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
  80036a:	68 d4 40 80 00       	push   $0x8040d4
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
  80039d:	68 06 41 80 00       	push   $0x804106
  8003a2:	e8 dd 1a 00 00       	call   801e84 <sys_create_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b3:	e8 ea 1a 00 00       	call   801ea2 <sys_run_env>
  8003b8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  8003bb:	90                   	nop
  8003bc:	e8 89 1c 00 00       	call   80204a <gettst>
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
  8003da:	68 88 40 80 00       	push   $0x804088
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
  8003f8:	e8 33 1c 00 00       	call   802030 <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8003fd:	90                   	nop
  8003fe:	e8 47 1c 00 00       	call   80204a <gettst>
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
  80041c:	68 88 40 80 00       	push   $0x804088
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
  800440:	68 14 41 80 00       	push   $0x804114
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
  800459:	e8 94 1a 00 00       	call   801ef2 <sys_getenvindex>
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
  8004c7:	e8 aa 17 00 00       	call   801c76 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004cc:	83 ec 0c             	sub    $0xc,%esp
  8004cf:	68 70 41 80 00       	push   $0x804170
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
  8004f7:	68 98 41 80 00       	push   $0x804198
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
  800528:	68 c0 41 80 00       	push   $0x8041c0
  80052d:	e8 1d 03 00 00       	call   80084f <cprintf>
  800532:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800535:	a1 20 50 80 00       	mov    0x805020,%eax
  80053a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	50                   	push   %eax
  800544:	68 18 42 80 00       	push   $0x804218
  800549:	e8 01 03 00 00       	call   80084f <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 70 41 80 00       	push   $0x804170
  800559:	e8 f1 02 00 00       	call   80084f <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800561:	e8 2a 17 00 00       	call   801c90 <sys_unlock_cons>
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
  800579:	e8 40 19 00 00       	call   801ebe <sys_destroy_env>
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
  80058a:	e8 95 19 00 00       	call   801f24 <sys_exit_env>
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
  8005a1:	a1 50 50 80 00       	mov    0x805050,%eax
  8005a6:	85 c0                	test   %eax,%eax
  8005a8:	74 16                	je     8005c0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005aa:	a1 50 50 80 00       	mov    0x805050,%eax
  8005af:	83 ec 08             	sub    $0x8,%esp
  8005b2:	50                   	push   %eax
  8005b3:	68 2c 42 80 00       	push   $0x80422c
  8005b8:	e8 92 02 00 00       	call   80084f <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005c0:	a1 00 50 80 00       	mov    0x805000,%eax
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	50                   	push   %eax
  8005cc:	68 31 42 80 00       	push   $0x804231
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
  8005f0:	68 4d 42 80 00       	push   $0x80424d
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
  80061f:	68 50 42 80 00       	push   $0x804250
  800624:	6a 26                	push   $0x26
  800626:	68 9c 42 80 00       	push   $0x80429c
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
  8006f4:	68 a8 42 80 00       	push   $0x8042a8
  8006f9:	6a 3a                	push   $0x3a
  8006fb:	68 9c 42 80 00       	push   $0x80429c
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
  800767:	68 fc 42 80 00       	push   $0x8042fc
  80076c:	6a 44                	push   $0x44
  80076e:	68 9c 42 80 00       	push   $0x80429c
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
  8007a6:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  8007c1:	e8 6e 14 00 00       	call   801c34 <sys_cputs>
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
  80081b:	a0 2c 50 80 00       	mov    0x80502c,%al
  800820:	0f b6 c0             	movzbl %al,%eax
  800823:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800829:	83 ec 04             	sub    $0x4,%esp
  80082c:	50                   	push   %eax
  80082d:	52                   	push   %edx
  80082e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800834:	83 c0 08             	add    $0x8,%eax
  800837:	50                   	push   %eax
  800838:	e8 f7 13 00 00       	call   801c34 <sys_cputs>
  80083d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800840:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  800855:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  800882:	e8 ef 13 00 00       	call   801c76 <sys_lock_cons>
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
  8008a2:	e8 e9 13 00 00       	call   801c90 <sys_unlock_cons>
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
  8008ec:	e8 db 33 00 00       	call   803ccc <__udivdi3>
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
  80093c:	e8 9b 34 00 00       	call   803ddc <__umoddi3>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	05 74 45 80 00       	add    $0x804574,%eax
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
  800a97:	8b 04 85 98 45 80 00 	mov    0x804598(,%eax,4),%eax
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
  800b78:	8b 34 9d e0 43 80 00 	mov    0x8043e0(,%ebx,4),%esi
  800b7f:	85 f6                	test   %esi,%esi
  800b81:	75 19                	jne    800b9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b83:	53                   	push   %ebx
  800b84:	68 85 45 80 00       	push   $0x804585
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
  800b9d:	68 8e 45 80 00       	push   $0x80458e
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
  800bca:	be 91 45 80 00       	mov    $0x804591,%esi
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
  800dc2:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800dc9:	eb 2c                	jmp    800df7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800dcb:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8015d5:	68 08 47 80 00       	push   $0x804708
  8015da:	68 3f 01 00 00       	push   $0x13f
  8015df:	68 2a 47 80 00       	push   $0x80472a
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
  8015f5:	e8 e5 0b 00 00       	call   8021df <sys_sbrk>
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
  801670:	e8 ee 09 00 00       	call   802063 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801675:	85 c0                	test   %eax,%eax
  801677:	74 16                	je     80168f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	e8 2e 0f 00 00       	call   8025b2 <alloc_block_FF>
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168a:	e9 8a 01 00 00       	jmp    801819 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80168f:	e8 00 0a 00 00       	call   802094 <sys_isUHeapPlacementStrategyBESTFIT>
  801694:	85 c0                	test   %eax,%eax
  801696:	0f 84 7d 01 00 00    	je     801819 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	e8 c7 13 00 00       	call   802a6e <alloc_block_BF>
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
  8016f2:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  80173f:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801796:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  8017f8:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8017ff:	83 ec 08             	sub    $0x8,%esp
  801802:	ff 75 08             	pushl  0x8(%ebp)
  801805:	ff 75 f0             	pushl  -0x10(%ebp)
  801808:	e8 09 0a 00 00       	call   802216 <sys_allocate_user_mem>
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
  801850:	e8 dd 09 00 00       	call   802232 <get_block_size>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 10 1c 00 00       	call   803476 <free_block>
  801866:	83 c4 10             	add    $0x10,%esp
		}

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
  80189b:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  8018a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8018a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a8:	c1 e0 0c             	shl    $0xc,%eax
  8018ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8018ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8018b5:	eb 42                	jmp    8018f9 <free+0xdb>
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
  8018d8:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  8018df:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8018e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	83 ec 08             	sub    $0x8,%esp
  8018ec:	52                   	push   %edx
  8018ed:	50                   	push   %eax
  8018ee:	e8 07 09 00 00       	call   8021fa <sys_free_user_mem>
  8018f3:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8018f6:	ff 45 f4             	incl   -0xc(%ebp)
  8018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018ff:	72 b6                	jb     8018b7 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801901:	eb 17                	jmp    80191a <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801903:	83 ec 04             	sub    $0x4,%esp
  801906:	68 38 47 80 00       	push   $0x804738
  80190b:	68 88 00 00 00       	push   $0x88
  801910:	68 62 47 80 00       	push   $0x804762
  801915:	e8 78 ec ff ff       	call   800592 <_panic>
	}
}
  80191a:	90                   	nop
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 28             	sub    $0x28,%esp
  801923:	8b 45 10             	mov    0x10(%ebp),%eax
  801926:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801929:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80192d:	75 0a                	jne    801939 <smalloc+0x1c>
  80192f:	b8 00 00 00 00       	mov    $0x0,%eax
  801934:	e9 ec 00 00 00       	jmp    801a25 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80193f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801946:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194c:	39 d0                	cmp    %edx,%eax
  80194e:	73 02                	jae    801952 <smalloc+0x35>
  801950:	89 d0                	mov    %edx,%eax
  801952:	83 ec 0c             	sub    $0xc,%esp
  801955:	50                   	push   %eax
  801956:	e8 a4 fc ff ff       	call   8015ff <malloc>
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801961:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801965:	75 0a                	jne    801971 <smalloc+0x54>
  801967:	b8 00 00 00 00       	mov    $0x0,%eax
  80196c:	e9 b4 00 00 00       	jmp    801a25 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801971:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801975:	ff 75 ec             	pushl  -0x14(%ebp)
  801978:	50                   	push   %eax
  801979:	ff 75 0c             	pushl  0xc(%ebp)
  80197c:	ff 75 08             	pushl  0x8(%ebp)
  80197f:	e8 7d 04 00 00       	call   801e01 <sys_createSharedObject>
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80198a:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80198e:	74 06                	je     801996 <smalloc+0x79>
  801990:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801994:	75 0a                	jne    8019a0 <smalloc+0x83>
  801996:	b8 00 00 00 00       	mov    $0x0,%eax
  80199b:	e9 85 00 00 00       	jmp    801a25 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8019a0:	83 ec 08             	sub    $0x8,%esp
  8019a3:	ff 75 ec             	pushl  -0x14(%ebp)
  8019a6:	68 6e 47 80 00       	push   $0x80476e
  8019ab:	e8 9f ee ff ff       	call   80084f <cprintf>
  8019b0:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8019b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8019bb:	8b 40 78             	mov    0x78(%eax),%eax
  8019be:	29 c2                	sub    %eax,%edx
  8019c0:	89 d0                	mov    %edx,%eax
  8019c2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019c7:	c1 e8 0c             	shr    $0xc,%eax
  8019ca:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8019d0:	42                   	inc    %edx
  8019d1:	89 15 24 50 80 00    	mov    %edx,0x805024
  8019d7:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8019dd:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8019e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8019ec:	8b 40 78             	mov    0x78(%eax),%eax
  8019ef:	29 c2                	sub    %eax,%edx
  8019f1:	89 d0                	mov    %edx,%eax
  8019f3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019f8:	c1 e8 0c             	shr    $0xc,%eax
  8019fb:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801a02:	a1 20 50 80 00       	mov    0x805020,%eax
  801a07:	8b 50 10             	mov    0x10(%eax),%edx
  801a0a:	89 c8                	mov    %ecx,%eax
  801a0c:	c1 e0 02             	shl    $0x2,%eax
  801a0f:	89 c1                	mov    %eax,%ecx
  801a11:	c1 e1 09             	shl    $0x9,%ecx
  801a14:	01 c8                	add    %ecx,%eax
  801a16:	01 c2                	add    %eax,%edx
  801a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a1b:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801a2d:	83 ec 08             	sub    $0x8,%esp
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	e8 f0 03 00 00       	call   801e2b <sys_getSizeOfSharedObject>
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801a41:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801a45:	75 0a                	jne    801a51 <sget+0x2a>
  801a47:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4c:	e9 e7 00 00 00       	jmp    801b38 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a57:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a64:	39 d0                	cmp    %edx,%eax
  801a66:	73 02                	jae    801a6a <sget+0x43>
  801a68:	89 d0                	mov    %edx,%eax
  801a6a:	83 ec 0c             	sub    $0xc,%esp
  801a6d:	50                   	push   %eax
  801a6e:	e8 8c fb ff ff       	call   8015ff <malloc>
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801a79:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a7d:	75 0a                	jne    801a89 <sget+0x62>
  801a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a84:	e9 af 00 00 00       	jmp    801b38 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801a89:	83 ec 04             	sub    $0x4,%esp
  801a8c:	ff 75 e8             	pushl  -0x18(%ebp)
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	e8 ae 03 00 00       	call   801e48 <sys_getSharedObject>
  801a9a:	83 c4 10             	add    $0x10,%esp
  801a9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801aa0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aa3:	a1 20 50 80 00       	mov    0x805020,%eax
  801aa8:	8b 40 78             	mov    0x78(%eax),%eax
  801aab:	29 c2                	sub    %eax,%edx
  801aad:	89 d0                	mov    %edx,%eax
  801aaf:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ab4:	c1 e8 0c             	shr    $0xc,%eax
  801ab7:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801abd:	42                   	inc    %edx
  801abe:	89 15 24 50 80 00    	mov    %edx,0x805024
  801ac4:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801aca:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801ad1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ad4:	a1 20 50 80 00       	mov    0x805020,%eax
  801ad9:	8b 40 78             	mov    0x78(%eax),%eax
  801adc:	29 c2                	sub    %eax,%edx
  801ade:	89 d0                	mov    %edx,%eax
  801ae0:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ae5:	c1 e8 0c             	shr    $0xc,%eax
  801ae8:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801aef:	a1 20 50 80 00       	mov    0x805020,%eax
  801af4:	8b 50 10             	mov    0x10(%eax),%edx
  801af7:	89 c8                	mov    %ecx,%eax
  801af9:	c1 e0 02             	shl    $0x2,%eax
  801afc:	89 c1                	mov    %eax,%ecx
  801afe:	c1 e1 09             	shl    $0x9,%ecx
  801b01:	01 c8                	add    %ecx,%eax
  801b03:	01 c2                	add    %eax,%edx
  801b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b08:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801b0f:	a1 20 50 80 00       	mov    0x805020,%eax
  801b14:	8b 40 10             	mov    0x10(%eax),%eax
  801b17:	83 ec 08             	sub    $0x8,%esp
  801b1a:	50                   	push   %eax
  801b1b:	68 7d 47 80 00       	push   $0x80477d
  801b20:	e8 2a ed ff ff       	call   80084f <cprintf>
  801b25:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801b28:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801b2c:	75 07                	jne    801b35 <sget+0x10e>
  801b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b33:	eb 03                	jmp    801b38 <sget+0x111>
	return ptr;
  801b35:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801b40:	8b 55 08             	mov    0x8(%ebp),%edx
  801b43:	a1 20 50 80 00       	mov    0x805020,%eax
  801b48:	8b 40 78             	mov    0x78(%eax),%eax
  801b4b:	29 c2                	sub    %eax,%edx
  801b4d:	89 d0                	mov    %edx,%eax
  801b4f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b54:	c1 e8 0c             	shr    $0xc,%eax
  801b57:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801b5e:	a1 20 50 80 00       	mov    0x805020,%eax
  801b63:	8b 50 10             	mov    0x10(%eax),%edx
  801b66:	89 c8                	mov    %ecx,%eax
  801b68:	c1 e0 02             	shl    $0x2,%eax
  801b6b:	89 c1                	mov    %eax,%ecx
  801b6d:	c1 e1 09             	shl    $0x9,%ecx
  801b70:	01 c8                	add    %ecx,%eax
  801b72:	01 d0                	add    %edx,%eax
  801b74:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801b7e:	83 ec 08             	sub    $0x8,%esp
  801b81:	ff 75 08             	pushl  0x8(%ebp)
  801b84:	ff 75 f4             	pushl  -0xc(%ebp)
  801b87:	e8 db 02 00 00       	call   801e67 <sys_freeSharedObject>
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801b92:	90                   	nop
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b9b:	83 ec 04             	sub    $0x4,%esp
  801b9e:	68 8c 47 80 00       	push   $0x80478c
  801ba3:	68 e5 00 00 00       	push   $0xe5
  801ba8:	68 62 47 80 00       	push   $0x804762
  801bad:	e8 e0 e9 ff ff       	call   800592 <_panic>

00801bb2 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bb8:	83 ec 04             	sub    $0x4,%esp
  801bbb:	68 b2 47 80 00       	push   $0x8047b2
  801bc0:	68 f1 00 00 00       	push   $0xf1
  801bc5:	68 62 47 80 00       	push   $0x804762
  801bca:	e8 c3 e9 ff ff       	call   800592 <_panic>

00801bcf <shrink>:

}
void shrink(uint32 newSize)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bd5:	83 ec 04             	sub    $0x4,%esp
  801bd8:	68 b2 47 80 00       	push   $0x8047b2
  801bdd:	68 f6 00 00 00       	push   $0xf6
  801be2:	68 62 47 80 00       	push   $0x804762
  801be7:	e8 a6 e9 ff ff       	call   800592 <_panic>

00801bec <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	68 b2 47 80 00       	push   $0x8047b2
  801bfa:	68 fb 00 00 00       	push   $0xfb
  801bff:	68 62 47 80 00       	push   $0x804762
  801c04:	e8 89 e9 ff ff       	call   800592 <_panic>

00801c09 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	57                   	push   %edi
  801c0d:	56                   	push   %esi
  801c0e:	53                   	push   %ebx
  801c0f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c1b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c1e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c21:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c24:	cd 30                	int    $0x30
  801c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c2c:	83 c4 10             	add    $0x10,%esp
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	5f                   	pop    %edi
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    

00801c34 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c40:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	52                   	push   %edx
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	50                   	push   %eax
  801c50:	6a 00                	push   $0x0
  801c52:	e8 b2 ff ff ff       	call   801c09 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	90                   	nop
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_cgetc>:

int
sys_cgetc(void)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 02                	push   $0x2
  801c6c:	e8 98 ff ff ff       	call   801c09 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 03                	push   $0x3
  801c85:	e8 7f ff ff ff       	call   801c09 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	90                   	nop
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 04                	push   $0x4
  801c9f:	e8 65 ff ff ff       	call   801c09 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	90                   	nop
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	52                   	push   %edx
  801cba:	50                   	push   %eax
  801cbb:	6a 08                	push   $0x8
  801cbd:	e8 47 ff ff ff       	call   801c09 <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	56                   	push   %esi
  801ccb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ccc:	8b 75 18             	mov    0x18(%ebp),%esi
  801ccf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	56                   	push   %esi
  801cdc:	53                   	push   %ebx
  801cdd:	51                   	push   %ecx
  801cde:	52                   	push   %edx
  801cdf:	50                   	push   %eax
  801ce0:	6a 09                	push   $0x9
  801ce2:	e8 22 ff ff ff       	call   801c09 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ced:	5b                   	pop    %ebx
  801cee:	5e                   	pop    %esi
  801cef:	5d                   	pop    %ebp
  801cf0:	c3                   	ret    

00801cf1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	6a 0a                	push   $0xa
  801d04:	e8 00 ff ff ff       	call   801c09 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	ff 75 0c             	pushl  0xc(%ebp)
  801d1a:	ff 75 08             	pushl  0x8(%ebp)
  801d1d:	6a 0b                	push   $0xb
  801d1f:	e8 e5 fe ff ff       	call   801c09 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 0c                	push   $0xc
  801d38:	e8 cc fe ff ff       	call   801c09 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 0d                	push   $0xd
  801d51:	e8 b3 fe ff ff       	call   801c09 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 0e                	push   $0xe
  801d6a:	e8 9a fe ff ff       	call   801c09 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 0f                	push   $0xf
  801d83:	e8 81 fe ff ff       	call   801c09 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	ff 75 08             	pushl  0x8(%ebp)
  801d9b:	6a 10                	push   $0x10
  801d9d:	e8 67 fe ff ff       	call   801c09 <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 11                	push   $0x11
  801db6:	e8 4e fe ff ff       	call   801c09 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	90                   	nop
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_cputc>:

void
sys_cputc(const char c)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 04             	sub    $0x4,%esp
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dcd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	50                   	push   %eax
  801dda:	6a 01                	push   $0x1
  801ddc:	e8 28 fe ff ff       	call   801c09 <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	90                   	nop
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 14                	push   $0x14
  801df6:	e8 0e fe ff ff       	call   801c09 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	90                   	nop
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 04             	sub    $0x4,%esp
  801e07:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e0d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e10:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	6a 00                	push   $0x0
  801e19:	51                   	push   %ecx
  801e1a:	52                   	push   %edx
  801e1b:	ff 75 0c             	pushl  0xc(%ebp)
  801e1e:	50                   	push   %eax
  801e1f:	6a 15                	push   $0x15
  801e21:	e8 e3 fd ff ff       	call   801c09 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	52                   	push   %edx
  801e3b:	50                   	push   %eax
  801e3c:	6a 16                	push   $0x16
  801e3e:	e8 c6 fd ff ff       	call   801c09 <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	51                   	push   %ecx
  801e59:	52                   	push   %edx
  801e5a:	50                   	push   %eax
  801e5b:	6a 17                	push   $0x17
  801e5d:	e8 a7 fd ff ff       	call   801c09 <syscall>
  801e62:	83 c4 18             	add    $0x18,%esp
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	52                   	push   %edx
  801e77:	50                   	push   %eax
  801e78:	6a 18                	push   $0x18
  801e7a:	e8 8a fd ff ff       	call   801c09 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	6a 00                	push   $0x0
  801e8c:	ff 75 14             	pushl  0x14(%ebp)
  801e8f:	ff 75 10             	pushl  0x10(%ebp)
  801e92:	ff 75 0c             	pushl  0xc(%ebp)
  801e95:	50                   	push   %eax
  801e96:	6a 19                	push   $0x19
  801e98:	e8 6c fd ff ff       	call   801c09 <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	50                   	push   %eax
  801eb1:	6a 1a                	push   $0x1a
  801eb3:	e8 51 fd ff ff       	call   801c09 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	90                   	nop
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	50                   	push   %eax
  801ecd:	6a 1b                	push   $0x1b
  801ecf:	e8 35 fd ff ff       	call   801c09 <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 05                	push   $0x5
  801ee8:	e8 1c fd ff ff       	call   801c09 <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 06                	push   $0x6
  801f01:	e8 03 fd ff ff       	call   801c09 <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 07                	push   $0x7
  801f1a:	e8 ea fc ff ff       	call   801c09 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_exit_env>:


void sys_exit_env(void)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 1c                	push   $0x1c
  801f33:	e8 d1 fc ff ff       	call   801c09 <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
}
  801f3b:	90                   	nop
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f44:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f47:	8d 50 04             	lea    0x4(%eax),%edx
  801f4a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	52                   	push   %edx
  801f54:	50                   	push   %eax
  801f55:	6a 1d                	push   $0x1d
  801f57:	e8 ad fc ff ff       	call   801c09 <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
	return result;
  801f5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f68:	89 01                	mov    %eax,(%ecx)
  801f6a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	c9                   	leave  
  801f71:	c2 04 00             	ret    $0x4

00801f74 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	ff 75 10             	pushl  0x10(%ebp)
  801f7e:	ff 75 0c             	pushl  0xc(%ebp)
  801f81:	ff 75 08             	pushl  0x8(%ebp)
  801f84:	6a 13                	push   $0x13
  801f86:	e8 7e fc ff ff       	call   801c09 <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8e:	90                   	nop
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 1e                	push   $0x1e
  801fa0:	e8 64 fc ff ff       	call   801c09 <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 04             	sub    $0x4,%esp
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fb6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	50                   	push   %eax
  801fc3:	6a 1f                	push   $0x1f
  801fc5:	e8 3f fc ff ff       	call   801c09 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcd:	90                   	nop
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <rsttst>:
void rsttst()
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 21                	push   $0x21
  801fdf:	e8 25 fc ff ff       	call   801c09 <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe7:	90                   	nop
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 04             	sub    $0x4,%esp
  801ff0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ff6:	8b 55 18             	mov    0x18(%ebp),%edx
  801ff9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ffd:	52                   	push   %edx
  801ffe:	50                   	push   %eax
  801fff:	ff 75 10             	pushl  0x10(%ebp)
  802002:	ff 75 0c             	pushl  0xc(%ebp)
  802005:	ff 75 08             	pushl  0x8(%ebp)
  802008:	6a 20                	push   $0x20
  80200a:	e8 fa fb ff ff       	call   801c09 <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
	return ;
  802012:	90                   	nop
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <chktst>:
void chktst(uint32 n)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	ff 75 08             	pushl  0x8(%ebp)
  802023:	6a 22                	push   $0x22
  802025:	e8 df fb ff ff       	call   801c09 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
	return ;
  80202d:	90                   	nop
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <inctst>:

void inctst()
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 23                	push   $0x23
  80203f:	e8 c5 fb ff ff       	call   801c09 <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
	return ;
  802047:	90                   	nop
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <gettst>:
uint32 gettst()
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 24                	push   $0x24
  802059:	e8 ab fb ff ff       	call   801c09 <syscall>
  80205e:	83 c4 18             	add    $0x18,%esp
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 25                	push   $0x25
  802075:	e8 8f fb ff ff       	call   801c09 <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
  80207d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802080:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802084:	75 07                	jne    80208d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802086:	b8 01 00 00 00       	mov    $0x1,%eax
  80208b:	eb 05                	jmp    802092 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80208d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 25                	push   $0x25
  8020a6:	e8 5e fb ff ff       	call   801c09 <syscall>
  8020ab:	83 c4 18             	add    $0x18,%esp
  8020ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020b1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020b5:	75 07                	jne    8020be <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8020bc:	eb 05                	jmp    8020c3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 25                	push   $0x25
  8020d7:	e8 2d fb ff ff       	call   801c09 <syscall>
  8020dc:	83 c4 18             	add    $0x18,%esp
  8020df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020e2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020e6:	75 07                	jne    8020ef <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ed:	eb 05                	jmp    8020f4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 25                	push   $0x25
  802108:	e8 fc fa ff ff       	call   801c09 <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
  802110:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802113:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802117:	75 07                	jne    802120 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802119:	b8 01 00 00 00       	mov    $0x1,%eax
  80211e:	eb 05                	jmp    802125 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	ff 75 08             	pushl  0x8(%ebp)
  802135:	6a 26                	push   $0x26
  802137:	e8 cd fa ff ff       	call   801c09 <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
	return ;
  80213f:	90                   	nop
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802146:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802149:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80214c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	6a 00                	push   $0x0
  802154:	53                   	push   %ebx
  802155:	51                   	push   %ecx
  802156:	52                   	push   %edx
  802157:	50                   	push   %eax
  802158:	6a 27                	push   $0x27
  80215a:	e8 aa fa ff ff       	call   801c09 <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
}
  802162:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80216a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	52                   	push   %edx
  802177:	50                   	push   %eax
  802178:	6a 28                	push   $0x28
  80217a:	e8 8a fa ff ff       	call   801c09 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802187:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80218a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	6a 00                	push   $0x0
  802192:	51                   	push   %ecx
  802193:	ff 75 10             	pushl  0x10(%ebp)
  802196:	52                   	push   %edx
  802197:	50                   	push   %eax
  802198:	6a 29                	push   $0x29
  80219a:	e8 6a fa ff ff       	call   801c09 <syscall>
  80219f:	83 c4 18             	add    $0x18,%esp
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	ff 75 10             	pushl  0x10(%ebp)
  8021ae:	ff 75 0c             	pushl  0xc(%ebp)
  8021b1:	ff 75 08             	pushl  0x8(%ebp)
  8021b4:	6a 12                	push   $0x12
  8021b6:	e8 4e fa ff ff       	call   801c09 <syscall>
  8021bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8021be:	90                   	nop
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	52                   	push   %edx
  8021d1:	50                   	push   %eax
  8021d2:	6a 2a                	push   $0x2a
  8021d4:	e8 30 fa ff ff       	call   801c09 <syscall>
  8021d9:	83 c4 18             	add    $0x18,%esp
	return;
  8021dc:	90                   	nop
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	50                   	push   %eax
  8021ee:	6a 2b                	push   $0x2b
  8021f0:	e8 14 fa ff ff       	call   801c09 <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	ff 75 0c             	pushl  0xc(%ebp)
  802206:	ff 75 08             	pushl  0x8(%ebp)
  802209:	6a 2c                	push   $0x2c
  80220b:	e8 f9 f9 ff ff       	call   801c09 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
	return;
  802213:	90                   	nop
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	ff 75 0c             	pushl  0xc(%ebp)
  802222:	ff 75 08             	pushl  0x8(%ebp)
  802225:	6a 2d                	push   $0x2d
  802227:	e8 dd f9 ff ff       	call   801c09 <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
	return;
  80222f:	90                   	nop
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	83 e8 04             	sub    $0x4,%eax
  80223e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802241:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802244:	8b 00                	mov    (%eax),%eax
  802246:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	83 e8 04             	sub    $0x4,%eax
  802257:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80225a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80225d:	8b 00                	mov    (%eax),%eax
  80225f:	83 e0 01             	and    $0x1,%eax
  802262:	85 c0                	test   %eax,%eax
  802264:	0f 94 c0             	sete   %al
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
  80226c:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80226f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802276:	8b 45 0c             	mov    0xc(%ebp),%eax
  802279:	83 f8 02             	cmp    $0x2,%eax
  80227c:	74 2b                	je     8022a9 <alloc_block+0x40>
  80227e:	83 f8 02             	cmp    $0x2,%eax
  802281:	7f 07                	jg     80228a <alloc_block+0x21>
  802283:	83 f8 01             	cmp    $0x1,%eax
  802286:	74 0e                	je     802296 <alloc_block+0x2d>
  802288:	eb 58                	jmp    8022e2 <alloc_block+0x79>
  80228a:	83 f8 03             	cmp    $0x3,%eax
  80228d:	74 2d                	je     8022bc <alloc_block+0x53>
  80228f:	83 f8 04             	cmp    $0x4,%eax
  802292:	74 3b                	je     8022cf <alloc_block+0x66>
  802294:	eb 4c                	jmp    8022e2 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802296:	83 ec 0c             	sub    $0xc,%esp
  802299:	ff 75 08             	pushl  0x8(%ebp)
  80229c:	e8 11 03 00 00       	call   8025b2 <alloc_block_FF>
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022a7:	eb 4a                	jmp    8022f3 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8022a9:	83 ec 0c             	sub    $0xc,%esp
  8022ac:	ff 75 08             	pushl  0x8(%ebp)
  8022af:	e8 fa 19 00 00       	call   803cae <alloc_block_NF>
  8022b4:	83 c4 10             	add    $0x10,%esp
  8022b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022ba:	eb 37                	jmp    8022f3 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8022bc:	83 ec 0c             	sub    $0xc,%esp
  8022bf:	ff 75 08             	pushl  0x8(%ebp)
  8022c2:	e8 a7 07 00 00       	call   802a6e <alloc_block_BF>
  8022c7:	83 c4 10             	add    $0x10,%esp
  8022ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022cd:	eb 24                	jmp    8022f3 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8022cf:	83 ec 0c             	sub    $0xc,%esp
  8022d2:	ff 75 08             	pushl  0x8(%ebp)
  8022d5:	e8 b7 19 00 00       	call   803c91 <alloc_block_WF>
  8022da:	83 c4 10             	add    $0x10,%esp
  8022dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022e0:	eb 11                	jmp    8022f3 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8022e2:	83 ec 0c             	sub    $0xc,%esp
  8022e5:	68 c4 47 80 00       	push   $0x8047c4
  8022ea:	e8 60 e5 ff ff       	call   80084f <cprintf>
  8022ef:	83 c4 10             	add    $0x10,%esp
		break;
  8022f2:	90                   	nop
	}
	return va;
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	53                   	push   %ebx
  8022fc:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8022ff:	83 ec 0c             	sub    $0xc,%esp
  802302:	68 e4 47 80 00       	push   $0x8047e4
  802307:	e8 43 e5 ff ff       	call   80084f <cprintf>
  80230c:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80230f:	83 ec 0c             	sub    $0xc,%esp
  802312:	68 0f 48 80 00       	push   $0x80480f
  802317:	e8 33 e5 ff ff       	call   80084f <cprintf>
  80231c:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802325:	eb 37                	jmp    80235e <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802327:	83 ec 0c             	sub    $0xc,%esp
  80232a:	ff 75 f4             	pushl  -0xc(%ebp)
  80232d:	e8 19 ff ff ff       	call   80224b <is_free_block>
  802332:	83 c4 10             	add    $0x10,%esp
  802335:	0f be d8             	movsbl %al,%ebx
  802338:	83 ec 0c             	sub    $0xc,%esp
  80233b:	ff 75 f4             	pushl  -0xc(%ebp)
  80233e:	e8 ef fe ff ff       	call   802232 <get_block_size>
  802343:	83 c4 10             	add    $0x10,%esp
  802346:	83 ec 04             	sub    $0x4,%esp
  802349:	53                   	push   %ebx
  80234a:	50                   	push   %eax
  80234b:	68 27 48 80 00       	push   $0x804827
  802350:	e8 fa e4 ff ff       	call   80084f <cprintf>
  802355:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802358:	8b 45 10             	mov    0x10(%ebp),%eax
  80235b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802362:	74 07                	je     80236b <print_blocks_list+0x73>
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 00                	mov    (%eax),%eax
  802369:	eb 05                	jmp    802370 <print_blocks_list+0x78>
  80236b:	b8 00 00 00 00       	mov    $0x0,%eax
  802370:	89 45 10             	mov    %eax,0x10(%ebp)
  802373:	8b 45 10             	mov    0x10(%ebp),%eax
  802376:	85 c0                	test   %eax,%eax
  802378:	75 ad                	jne    802327 <print_blocks_list+0x2f>
  80237a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237e:	75 a7                	jne    802327 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802380:	83 ec 0c             	sub    $0xc,%esp
  802383:	68 e4 47 80 00       	push   $0x8047e4
  802388:	e8 c2 e4 ff ff       	call   80084f <cprintf>
  80238d:	83 c4 10             	add    $0x10,%esp

}
  802390:	90                   	nop
  802391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80239c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239f:	83 e0 01             	and    $0x1,%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	74 03                	je     8023a9 <initialize_dynamic_allocator+0x13>
  8023a6:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8023a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023ad:	0f 84 c7 01 00 00    	je     80257a <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8023b3:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8023ba:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8023bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c3:	01 d0                	add    %edx,%eax
  8023c5:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8023ca:	0f 87 ad 01 00 00    	ja     80257d <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	0f 89 a5 01 00 00    	jns    802580 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8023db:	8b 55 08             	mov    0x8(%ebp),%edx
  8023de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e1:	01 d0                	add    %edx,%eax
  8023e3:	83 e8 04             	sub    $0x4,%eax
  8023e6:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8023eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8023f2:	a1 30 50 80 00       	mov    0x805030,%eax
  8023f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fa:	e9 87 00 00 00       	jmp    802486 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8023ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802403:	75 14                	jne    802419 <initialize_dynamic_allocator+0x83>
  802405:	83 ec 04             	sub    $0x4,%esp
  802408:	68 3f 48 80 00       	push   $0x80483f
  80240d:	6a 79                	push   $0x79
  80240f:	68 5d 48 80 00       	push   $0x80485d
  802414:	e8 79 e1 ff ff       	call   800592 <_panic>
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 00                	mov    (%eax),%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	74 10                	je     802432 <initialize_dynamic_allocator+0x9c>
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242a:	8b 52 04             	mov    0x4(%edx),%edx
  80242d:	89 50 04             	mov    %edx,0x4(%eax)
  802430:	eb 0b                	jmp    80243d <initialize_dynamic_allocator+0xa7>
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 40 04             	mov    0x4(%eax),%eax
  802438:	a3 34 50 80 00       	mov    %eax,0x805034
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	8b 40 04             	mov    0x4(%eax),%eax
  802443:	85 c0                	test   %eax,%eax
  802445:	74 0f                	je     802456 <initialize_dynamic_allocator+0xc0>
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 40 04             	mov    0x4(%eax),%eax
  80244d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802450:	8b 12                	mov    (%edx),%edx
  802452:	89 10                	mov    %edx,(%eax)
  802454:	eb 0a                	jmp    802460 <initialize_dynamic_allocator+0xca>
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 00                	mov    (%eax),%eax
  80245b:	a3 30 50 80 00       	mov    %eax,0x805030
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802473:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802478:	48                   	dec    %eax
  802479:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80247e:	a1 38 50 80 00       	mov    0x805038,%eax
  802483:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802486:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248a:	74 07                	je     802493 <initialize_dynamic_allocator+0xfd>
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	eb 05                	jmp    802498 <initialize_dynamic_allocator+0x102>
  802493:	b8 00 00 00 00       	mov    $0x0,%eax
  802498:	a3 38 50 80 00       	mov    %eax,0x805038
  80249d:	a1 38 50 80 00       	mov    0x805038,%eax
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	0f 85 55 ff ff ff    	jne    8023ff <initialize_dynamic_allocator+0x69>
  8024aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ae:	0f 85 4b ff ff ff    	jne    8023ff <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8024ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8024c3:	a1 48 50 80 00       	mov    0x805048,%eax
  8024c8:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8024cd:	a1 44 50 80 00       	mov    0x805044,%eax
  8024d2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	83 c0 08             	add    $0x8,%eax
  8024de:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8024e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e4:	83 c0 04             	add    $0x4,%eax
  8024e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ea:	83 ea 08             	sub    $0x8,%edx
  8024ed:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8024ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	01 d0                	add    %edx,%eax
  8024f7:	83 e8 08             	sub    $0x8,%eax
  8024fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fd:	83 ea 08             	sub    $0x8,%edx
  802500:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802505:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80250b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802515:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802519:	75 17                	jne    802532 <initialize_dynamic_allocator+0x19c>
  80251b:	83 ec 04             	sub    $0x4,%esp
  80251e:	68 78 48 80 00       	push   $0x804878
  802523:	68 90 00 00 00       	push   $0x90
  802528:	68 5d 48 80 00       	push   $0x80485d
  80252d:	e8 60 e0 ff ff       	call   800592 <_panic>
  802532:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253b:	89 10                	mov    %edx,(%eax)
  80253d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	74 0d                	je     802553 <initialize_dynamic_allocator+0x1bd>
  802546:	a1 30 50 80 00       	mov    0x805030,%eax
  80254b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80254e:	89 50 04             	mov    %edx,0x4(%eax)
  802551:	eb 08                	jmp    80255b <initialize_dynamic_allocator+0x1c5>
  802553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802556:	a3 34 50 80 00       	mov    %eax,0x805034
  80255b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255e:	a3 30 50 80 00       	mov    %eax,0x805030
  802563:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802566:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80256d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802572:	40                   	inc    %eax
  802573:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802578:	eb 07                	jmp    802581 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80257a:	90                   	nop
  80257b:	eb 04                	jmp    802581 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80257d:	90                   	nop
  80257e:	eb 01                	jmp    802581 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802580:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802586:	8b 45 10             	mov    0x10(%ebp),%eax
  802589:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802592:	8b 45 0c             	mov    0xc(%ebp),%eax
  802595:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	83 e8 04             	sub    $0x4,%eax
  80259d:	8b 00                	mov    (%eax),%eax
  80259f:	83 e0 fe             	and    $0xfffffffe,%eax
  8025a2:	8d 50 f8             	lea    -0x8(%eax),%edx
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	01 c2                	add    %eax,%edx
  8025aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ad:	89 02                	mov    %eax,(%edx)
}
  8025af:	90                   	nop
  8025b0:	5d                   	pop    %ebp
  8025b1:	c3                   	ret    

008025b2 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
  8025b5:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	83 e0 01             	and    $0x1,%eax
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	74 03                	je     8025c5 <alloc_block_FF+0x13>
  8025c2:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025c5:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025c9:	77 07                	ja     8025d2 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025cb:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025d2:	a1 28 50 80 00       	mov    0x805028,%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	75 73                	jne    80264e <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8025db:	8b 45 08             	mov    0x8(%ebp),%eax
  8025de:	83 c0 10             	add    $0x10,%eax
  8025e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8025e4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8025eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f1:	01 d0                	add    %edx,%eax
  8025f3:	48                   	dec    %eax
  8025f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8025f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ff:	f7 75 ec             	divl   -0x14(%ebp)
  802602:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802605:	29 d0                	sub    %edx,%eax
  802607:	c1 e8 0c             	shr    $0xc,%eax
  80260a:	83 ec 0c             	sub    $0xc,%esp
  80260d:	50                   	push   %eax
  80260e:	e8 d6 ef ff ff       	call   8015e9 <sbrk>
  802613:	83 c4 10             	add    $0x10,%esp
  802616:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802619:	83 ec 0c             	sub    $0xc,%esp
  80261c:	6a 00                	push   $0x0
  80261e:	e8 c6 ef ff ff       	call   8015e9 <sbrk>
  802623:	83 c4 10             	add    $0x10,%esp
  802626:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802629:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80262f:	83 ec 08             	sub    $0x8,%esp
  802632:	50                   	push   %eax
  802633:	ff 75 e4             	pushl  -0x1c(%ebp)
  802636:	e8 5b fd ff ff       	call   802396 <initialize_dynamic_allocator>
  80263b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80263e:	83 ec 0c             	sub    $0xc,%esp
  802641:	68 9b 48 80 00       	push   $0x80489b
  802646:	e8 04 e2 ff ff       	call   80084f <cprintf>
  80264b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80264e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802652:	75 0a                	jne    80265e <alloc_block_FF+0xac>
	        return NULL;
  802654:	b8 00 00 00 00       	mov    $0x0,%eax
  802659:	e9 0e 04 00 00       	jmp    802a6c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80265e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802665:	a1 30 50 80 00       	mov    0x805030,%eax
  80266a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266d:	e9 f3 02 00 00       	jmp    802965 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802678:	83 ec 0c             	sub    $0xc,%esp
  80267b:	ff 75 bc             	pushl  -0x44(%ebp)
  80267e:	e8 af fb ff ff       	call   802232 <get_block_size>
  802683:	83 c4 10             	add    $0x10,%esp
  802686:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	83 c0 08             	add    $0x8,%eax
  80268f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802692:	0f 87 c5 02 00 00    	ja     80295d <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	83 c0 18             	add    $0x18,%eax
  80269e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8026a1:	0f 87 19 02 00 00    	ja     8028c0 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8026a7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026aa:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ad:	83 e8 08             	sub    $0x8,%eax
  8026b0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	8d 50 08             	lea    0x8(%eax),%edx
  8026b9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026bc:	01 d0                	add    %edx,%eax
  8026be:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	83 c0 08             	add    $0x8,%eax
  8026c7:	83 ec 04             	sub    $0x4,%esp
  8026ca:	6a 01                	push   $0x1
  8026cc:	50                   	push   %eax
  8026cd:	ff 75 bc             	pushl  -0x44(%ebp)
  8026d0:	e8 ae fe ff ff       	call   802583 <set_block_data>
  8026d5:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	8b 40 04             	mov    0x4(%eax),%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	75 68                	jne    80274a <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026e2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026e6:	75 17                	jne    8026ff <alloc_block_FF+0x14d>
  8026e8:	83 ec 04             	sub    $0x4,%esp
  8026eb:	68 78 48 80 00       	push   $0x804878
  8026f0:	68 d7 00 00 00       	push   $0xd7
  8026f5:	68 5d 48 80 00       	push   $0x80485d
  8026fa:	e8 93 de ff ff       	call   800592 <_panic>
  8026ff:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802705:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802708:	89 10                	mov    %edx,(%eax)
  80270a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80270d:	8b 00                	mov    (%eax),%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	74 0d                	je     802720 <alloc_block_FF+0x16e>
  802713:	a1 30 50 80 00       	mov    0x805030,%eax
  802718:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80271b:	89 50 04             	mov    %edx,0x4(%eax)
  80271e:	eb 08                	jmp    802728 <alloc_block_FF+0x176>
  802720:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802723:	a3 34 50 80 00       	mov    %eax,0x805034
  802728:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80272b:	a3 30 50 80 00       	mov    %eax,0x805030
  802730:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802733:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80273f:	40                   	inc    %eax
  802740:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802745:	e9 dc 00 00 00       	jmp    802826 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 00                	mov    (%eax),%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	75 65                	jne    8027b8 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802753:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802757:	75 17                	jne    802770 <alloc_block_FF+0x1be>
  802759:	83 ec 04             	sub    $0x4,%esp
  80275c:	68 ac 48 80 00       	push   $0x8048ac
  802761:	68 db 00 00 00       	push   $0xdb
  802766:	68 5d 48 80 00       	push   $0x80485d
  80276b:	e8 22 de ff ff       	call   800592 <_panic>
  802770:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802776:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802779:	89 50 04             	mov    %edx,0x4(%eax)
  80277c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80277f:	8b 40 04             	mov    0x4(%eax),%eax
  802782:	85 c0                	test   %eax,%eax
  802784:	74 0c                	je     802792 <alloc_block_FF+0x1e0>
  802786:	a1 34 50 80 00       	mov    0x805034,%eax
  80278b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80278e:	89 10                	mov    %edx,(%eax)
  802790:	eb 08                	jmp    80279a <alloc_block_FF+0x1e8>
  802792:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802795:	a3 30 50 80 00       	mov    %eax,0x805030
  80279a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80279d:	a3 34 50 80 00       	mov    %eax,0x805034
  8027a2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ab:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027b0:	40                   	inc    %eax
  8027b1:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8027b6:	eb 6e                	jmp    802826 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8027b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bc:	74 06                	je     8027c4 <alloc_block_FF+0x212>
  8027be:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8027c2:	75 17                	jne    8027db <alloc_block_FF+0x229>
  8027c4:	83 ec 04             	sub    $0x4,%esp
  8027c7:	68 d0 48 80 00       	push   $0x8048d0
  8027cc:	68 df 00 00 00       	push   $0xdf
  8027d1:	68 5d 48 80 00       	push   $0x80485d
  8027d6:	e8 b7 dd ff ff       	call   800592 <_panic>
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 10                	mov    (%eax),%edx
  8027e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027e3:	89 10                	mov    %edx,(%eax)
  8027e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	74 0b                	je     8027f9 <alloc_block_FF+0x247>
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027f6:	89 50 04             	mov    %edx,0x4(%eax)
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027ff:	89 10                	mov    %edx,(%eax)
  802801:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802804:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802807:	89 50 04             	mov    %edx,0x4(%eax)
  80280a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	85 c0                	test   %eax,%eax
  802811:	75 08                	jne    80281b <alloc_block_FF+0x269>
  802813:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802816:	a3 34 50 80 00       	mov    %eax,0x805034
  80281b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802820:	40                   	inc    %eax
  802821:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802826:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282a:	75 17                	jne    802843 <alloc_block_FF+0x291>
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	68 3f 48 80 00       	push   $0x80483f
  802834:	68 e1 00 00 00       	push   $0xe1
  802839:	68 5d 48 80 00       	push   $0x80485d
  80283e:	e8 4f dd ff ff       	call   800592 <_panic>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 00                	mov    (%eax),%eax
  802848:	85 c0                	test   %eax,%eax
  80284a:	74 10                	je     80285c <alloc_block_FF+0x2aa>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802854:	8b 52 04             	mov    0x4(%edx),%edx
  802857:	89 50 04             	mov    %edx,0x4(%eax)
  80285a:	eb 0b                	jmp    802867 <alloc_block_FF+0x2b5>
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	a3 34 50 80 00       	mov    %eax,0x805034
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	74 0f                	je     802880 <alloc_block_FF+0x2ce>
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 40 04             	mov    0x4(%eax),%eax
  802877:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287a:	8b 12                	mov    (%edx),%edx
  80287c:	89 10                	mov    %edx,(%eax)
  80287e:	eb 0a                	jmp    80288a <alloc_block_FF+0x2d8>
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 00                	mov    (%eax),%eax
  802885:	a3 30 50 80 00       	mov    %eax,0x805030
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028a2:	48                   	dec    %eax
  8028a3:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  8028a8:	83 ec 04             	sub    $0x4,%esp
  8028ab:	6a 00                	push   $0x0
  8028ad:	ff 75 b4             	pushl  -0x4c(%ebp)
  8028b0:	ff 75 b0             	pushl  -0x50(%ebp)
  8028b3:	e8 cb fc ff ff       	call   802583 <set_block_data>
  8028b8:	83 c4 10             	add    $0x10,%esp
  8028bb:	e9 95 00 00 00       	jmp    802955 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	6a 01                	push   $0x1
  8028c5:	ff 75 b8             	pushl  -0x48(%ebp)
  8028c8:	ff 75 bc             	pushl  -0x44(%ebp)
  8028cb:	e8 b3 fc ff ff       	call   802583 <set_block_data>
  8028d0:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8028d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d7:	75 17                	jne    8028f0 <alloc_block_FF+0x33e>
  8028d9:	83 ec 04             	sub    $0x4,%esp
  8028dc:	68 3f 48 80 00       	push   $0x80483f
  8028e1:	68 e8 00 00 00       	push   $0xe8
  8028e6:	68 5d 48 80 00       	push   $0x80485d
  8028eb:	e8 a2 dc ff ff       	call   800592 <_panic>
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 10                	je     802909 <alloc_block_FF+0x357>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802901:	8b 52 04             	mov    0x4(%edx),%edx
  802904:	89 50 04             	mov    %edx,0x4(%eax)
  802907:	eb 0b                	jmp    802914 <alloc_block_FF+0x362>
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 40 04             	mov    0x4(%eax),%eax
  80290f:	a3 34 50 80 00       	mov    %eax,0x805034
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 40 04             	mov    0x4(%eax),%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	74 0f                	je     80292d <alloc_block_FF+0x37b>
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802927:	8b 12                	mov    (%edx),%edx
  802929:	89 10                	mov    %edx,(%eax)
  80292b:	eb 0a                	jmp    802937 <alloc_block_FF+0x385>
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 00                	mov    (%eax),%eax
  802932:	a3 30 50 80 00       	mov    %eax,0x805030
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80294f:	48                   	dec    %eax
  802950:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802955:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802958:	e9 0f 01 00 00       	jmp    802a6c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80295d:	a1 38 50 80 00       	mov    0x805038,%eax
  802962:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802965:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802969:	74 07                	je     802972 <alloc_block_FF+0x3c0>
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 00                	mov    (%eax),%eax
  802970:	eb 05                	jmp    802977 <alloc_block_FF+0x3c5>
  802972:	b8 00 00 00 00       	mov    $0x0,%eax
  802977:	a3 38 50 80 00       	mov    %eax,0x805038
  80297c:	a1 38 50 80 00       	mov    0x805038,%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	0f 85 e9 fc ff ff    	jne    802672 <alloc_block_FF+0xc0>
  802989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298d:	0f 85 df fc ff ff    	jne    802672 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	83 c0 08             	add    $0x8,%eax
  802999:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80299c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8029a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029a9:	01 d0                	add    %edx,%eax
  8029ab:	48                   	dec    %eax
  8029ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8029af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b7:	f7 75 d8             	divl   -0x28(%ebp)
  8029ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029bd:	29 d0                	sub    %edx,%eax
  8029bf:	c1 e8 0c             	shr    $0xc,%eax
  8029c2:	83 ec 0c             	sub    $0xc,%esp
  8029c5:	50                   	push   %eax
  8029c6:	e8 1e ec ff ff       	call   8015e9 <sbrk>
  8029cb:	83 c4 10             	add    $0x10,%esp
  8029ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8029d1:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8029d5:	75 0a                	jne    8029e1 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8029d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029dc:	e9 8b 00 00 00       	jmp    802a6c <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8029e1:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8029e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ee:	01 d0                	add    %edx,%eax
  8029f0:	48                   	dec    %eax
  8029f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8029f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029fc:	f7 75 cc             	divl   -0x34(%ebp)
  8029ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a02:	29 d0                	sub    %edx,%eax
  802a04:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a07:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a0a:	01 d0                	add    %edx,%eax
  802a0c:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802a11:	a1 44 50 80 00       	mov    0x805044,%eax
  802a16:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a1c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802a23:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a29:	01 d0                	add    %edx,%eax
  802a2b:	48                   	dec    %eax
  802a2c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802a2f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a32:	ba 00 00 00 00       	mov    $0x0,%edx
  802a37:	f7 75 c4             	divl   -0x3c(%ebp)
  802a3a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a3d:	29 d0                	sub    %edx,%eax
  802a3f:	83 ec 04             	sub    $0x4,%esp
  802a42:	6a 01                	push   $0x1
  802a44:	50                   	push   %eax
  802a45:	ff 75 d0             	pushl  -0x30(%ebp)
  802a48:	e8 36 fb ff ff       	call   802583 <set_block_data>
  802a4d:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802a50:	83 ec 0c             	sub    $0xc,%esp
  802a53:	ff 75 d0             	pushl  -0x30(%ebp)
  802a56:	e8 1b 0a 00 00       	call   803476 <free_block>
  802a5b:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802a5e:	83 ec 0c             	sub    $0xc,%esp
  802a61:	ff 75 08             	pushl  0x8(%ebp)
  802a64:	e8 49 fb ff ff       	call   8025b2 <alloc_block_FF>
  802a69:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802a6c:	c9                   	leave  
  802a6d:	c3                   	ret    

00802a6e <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a6e:	55                   	push   %ebp
  802a6f:	89 e5                	mov    %esp,%ebp
  802a71:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	83 e0 01             	and    $0x1,%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	74 03                	je     802a81 <alloc_block_BF+0x13>
  802a7e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a81:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a85:	77 07                	ja     802a8e <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a87:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a8e:	a1 28 50 80 00       	mov    0x805028,%eax
  802a93:	85 c0                	test   %eax,%eax
  802a95:	75 73                	jne    802b0a <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	83 c0 10             	add    $0x10,%eax
  802a9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802aa0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802aa7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802aaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aad:	01 d0                	add    %edx,%eax
  802aaf:	48                   	dec    %eax
  802ab0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ab3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  802abb:	f7 75 e0             	divl   -0x20(%ebp)
  802abe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ac1:	29 d0                	sub    %edx,%eax
  802ac3:	c1 e8 0c             	shr    $0xc,%eax
  802ac6:	83 ec 0c             	sub    $0xc,%esp
  802ac9:	50                   	push   %eax
  802aca:	e8 1a eb ff ff       	call   8015e9 <sbrk>
  802acf:	83 c4 10             	add    $0x10,%esp
  802ad2:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802ad5:	83 ec 0c             	sub    $0xc,%esp
  802ad8:	6a 00                	push   $0x0
  802ada:	e8 0a eb ff ff       	call   8015e9 <sbrk>
  802adf:	83 c4 10             	add    $0x10,%esp
  802ae2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ae5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ae8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802aeb:	83 ec 08             	sub    $0x8,%esp
  802aee:	50                   	push   %eax
  802aef:	ff 75 d8             	pushl  -0x28(%ebp)
  802af2:	e8 9f f8 ff ff       	call   802396 <initialize_dynamic_allocator>
  802af7:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802afa:	83 ec 0c             	sub    $0xc,%esp
  802afd:	68 9b 48 80 00       	push   $0x80489b
  802b02:	e8 48 dd ff ff       	call   80084f <cprintf>
  802b07:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802b0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802b11:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802b18:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802b1f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802b26:	a1 30 50 80 00       	mov    0x805030,%eax
  802b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2e:	e9 1d 01 00 00       	jmp    802c50 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802b39:	83 ec 0c             	sub    $0xc,%esp
  802b3c:	ff 75 a8             	pushl  -0x58(%ebp)
  802b3f:	e8 ee f6 ff ff       	call   802232 <get_block_size>
  802b44:	83 c4 10             	add    $0x10,%esp
  802b47:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	83 c0 08             	add    $0x8,%eax
  802b50:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b53:	0f 87 ef 00 00 00    	ja     802c48 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	83 c0 18             	add    $0x18,%eax
  802b5f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b62:	77 1d                	ja     802b81 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802b64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b67:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b6a:	0f 86 d8 00 00 00    	jbe    802c48 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802b70:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802b76:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b7c:	e9 c7 00 00 00       	jmp    802c48 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802b81:	8b 45 08             	mov    0x8(%ebp),%eax
  802b84:	83 c0 08             	add    $0x8,%eax
  802b87:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b8a:	0f 85 9d 00 00 00    	jne    802c2d <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802b90:	83 ec 04             	sub    $0x4,%esp
  802b93:	6a 01                	push   $0x1
  802b95:	ff 75 a4             	pushl  -0x5c(%ebp)
  802b98:	ff 75 a8             	pushl  -0x58(%ebp)
  802b9b:	e8 e3 f9 ff ff       	call   802583 <set_block_data>
  802ba0:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802ba3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba7:	75 17                	jne    802bc0 <alloc_block_BF+0x152>
  802ba9:	83 ec 04             	sub    $0x4,%esp
  802bac:	68 3f 48 80 00       	push   $0x80483f
  802bb1:	68 2c 01 00 00       	push   $0x12c
  802bb6:	68 5d 48 80 00       	push   $0x80485d
  802bbb:	e8 d2 d9 ff ff       	call   800592 <_panic>
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	74 10                	je     802bd9 <alloc_block_BF+0x16b>
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd1:	8b 52 04             	mov    0x4(%edx),%edx
  802bd4:	89 50 04             	mov    %edx,0x4(%eax)
  802bd7:	eb 0b                	jmp    802be4 <alloc_block_BF+0x176>
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 40 04             	mov    0x4(%eax),%eax
  802bdf:	a3 34 50 80 00       	mov    %eax,0x805034
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 40 04             	mov    0x4(%eax),%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	74 0f                	je     802bfd <alloc_block_BF+0x18f>
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 40 04             	mov    0x4(%eax),%eax
  802bf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf7:	8b 12                	mov    (%edx),%edx
  802bf9:	89 10                	mov    %edx,(%eax)
  802bfb:	eb 0a                	jmp    802c07 <alloc_block_BF+0x199>
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	a3 30 50 80 00       	mov    %eax,0x805030
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c1f:	48                   	dec    %eax
  802c20:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802c25:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c28:	e9 24 04 00 00       	jmp    803051 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c30:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c33:	76 13                	jbe    802c48 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802c35:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802c3c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802c42:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802c45:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802c48:	a1 38 50 80 00       	mov    0x805038,%eax
  802c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c54:	74 07                	je     802c5d <alloc_block_BF+0x1ef>
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 00                	mov    (%eax),%eax
  802c5b:	eb 05                	jmp    802c62 <alloc_block_BF+0x1f4>
  802c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c62:	a3 38 50 80 00       	mov    %eax,0x805038
  802c67:	a1 38 50 80 00       	mov    0x805038,%eax
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	0f 85 bf fe ff ff    	jne    802b33 <alloc_block_BF+0xc5>
  802c74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c78:	0f 85 b5 fe ff ff    	jne    802b33 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802c7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c82:	0f 84 26 02 00 00    	je     802eae <alloc_block_BF+0x440>
  802c88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c8c:	0f 85 1c 02 00 00    	jne    802eae <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c95:	2b 45 08             	sub    0x8(%ebp),%eax
  802c98:	83 e8 08             	sub    $0x8,%eax
  802c9b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	8d 50 08             	lea    0x8(%eax),%edx
  802ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca7:	01 d0                	add    %edx,%eax
  802ca9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	83 c0 08             	add    $0x8,%eax
  802cb2:	83 ec 04             	sub    $0x4,%esp
  802cb5:	6a 01                	push   $0x1
  802cb7:	50                   	push   %eax
  802cb8:	ff 75 f0             	pushl  -0x10(%ebp)
  802cbb:	e8 c3 f8 ff ff       	call   802583 <set_block_data>
  802cc0:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc6:	8b 40 04             	mov    0x4(%eax),%eax
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	75 68                	jne    802d35 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ccd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802cd1:	75 17                	jne    802cea <alloc_block_BF+0x27c>
  802cd3:	83 ec 04             	sub    $0x4,%esp
  802cd6:	68 78 48 80 00       	push   $0x804878
  802cdb:	68 45 01 00 00       	push   $0x145
  802ce0:	68 5d 48 80 00       	push   $0x80485d
  802ce5:	e8 a8 d8 ff ff       	call   800592 <_panic>
  802cea:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802cf0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf3:	89 10                	mov    %edx,(%eax)
  802cf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	74 0d                	je     802d0b <alloc_block_BF+0x29d>
  802cfe:	a1 30 50 80 00       	mov    0x805030,%eax
  802d03:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d06:	89 50 04             	mov    %edx,0x4(%eax)
  802d09:	eb 08                	jmp    802d13 <alloc_block_BF+0x2a5>
  802d0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d0e:	a3 34 50 80 00       	mov    %eax,0x805034
  802d13:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d16:	a3 30 50 80 00       	mov    %eax,0x805030
  802d1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d25:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d2a:	40                   	inc    %eax
  802d2b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802d30:	e9 dc 00 00 00       	jmp    802e11 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	75 65                	jne    802da3 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d3e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d42:	75 17                	jne    802d5b <alloc_block_BF+0x2ed>
  802d44:	83 ec 04             	sub    $0x4,%esp
  802d47:	68 ac 48 80 00       	push   $0x8048ac
  802d4c:	68 4a 01 00 00       	push   $0x14a
  802d51:	68 5d 48 80 00       	push   $0x80485d
  802d56:	e8 37 d8 ff ff       	call   800592 <_panic>
  802d5b:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802d61:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d64:	89 50 04             	mov    %edx,0x4(%eax)
  802d67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d6a:	8b 40 04             	mov    0x4(%eax),%eax
  802d6d:	85 c0                	test   %eax,%eax
  802d6f:	74 0c                	je     802d7d <alloc_block_BF+0x30f>
  802d71:	a1 34 50 80 00       	mov    0x805034,%eax
  802d76:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d79:	89 10                	mov    %edx,(%eax)
  802d7b:	eb 08                	jmp    802d85 <alloc_block_BF+0x317>
  802d7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d80:	a3 30 50 80 00       	mov    %eax,0x805030
  802d85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d88:	a3 34 50 80 00       	mov    %eax,0x805034
  802d8d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d96:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d9b:	40                   	inc    %eax
  802d9c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802da1:	eb 6e                	jmp    802e11 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802da3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da7:	74 06                	je     802daf <alloc_block_BF+0x341>
  802da9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802dad:	75 17                	jne    802dc6 <alloc_block_BF+0x358>
  802daf:	83 ec 04             	sub    $0x4,%esp
  802db2:	68 d0 48 80 00       	push   $0x8048d0
  802db7:	68 4f 01 00 00       	push   $0x14f
  802dbc:	68 5d 48 80 00       	push   $0x80485d
  802dc1:	e8 cc d7 ff ff       	call   800592 <_panic>
  802dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc9:	8b 10                	mov    (%eax),%edx
  802dcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dce:	89 10                	mov    %edx,(%eax)
  802dd0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	74 0b                	je     802de4 <alloc_block_BF+0x376>
  802dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddc:	8b 00                	mov    (%eax),%eax
  802dde:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802de1:	89 50 04             	mov    %edx,0x4(%eax)
  802de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802dea:	89 10                	mov    %edx,(%eax)
  802dec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802def:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df2:	89 50 04             	mov    %edx,0x4(%eax)
  802df5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802df8:	8b 00                	mov    (%eax),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	75 08                	jne    802e06 <alloc_block_BF+0x398>
  802dfe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e01:	a3 34 50 80 00       	mov    %eax,0x805034
  802e06:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e0b:	40                   	inc    %eax
  802e0c:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802e11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e15:	75 17                	jne    802e2e <alloc_block_BF+0x3c0>
  802e17:	83 ec 04             	sub    $0x4,%esp
  802e1a:	68 3f 48 80 00       	push   $0x80483f
  802e1f:	68 51 01 00 00       	push   $0x151
  802e24:	68 5d 48 80 00       	push   $0x80485d
  802e29:	e8 64 d7 ff ff       	call   800592 <_panic>
  802e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	85 c0                	test   %eax,%eax
  802e35:	74 10                	je     802e47 <alloc_block_BF+0x3d9>
  802e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e3f:	8b 52 04             	mov    0x4(%edx),%edx
  802e42:	89 50 04             	mov    %edx,0x4(%eax)
  802e45:	eb 0b                	jmp    802e52 <alloc_block_BF+0x3e4>
  802e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4a:	8b 40 04             	mov    0x4(%eax),%eax
  802e4d:	a3 34 50 80 00       	mov    %eax,0x805034
  802e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e55:	8b 40 04             	mov    0x4(%eax),%eax
  802e58:	85 c0                	test   %eax,%eax
  802e5a:	74 0f                	je     802e6b <alloc_block_BF+0x3fd>
  802e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5f:	8b 40 04             	mov    0x4(%eax),%eax
  802e62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e65:	8b 12                	mov    (%edx),%edx
  802e67:	89 10                	mov    %edx,(%eax)
  802e69:	eb 0a                	jmp    802e75 <alloc_block_BF+0x407>
  802e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	a3 30 50 80 00       	mov    %eax,0x805030
  802e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e88:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e8d:	48                   	dec    %eax
  802e8e:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802e93:	83 ec 04             	sub    $0x4,%esp
  802e96:	6a 00                	push   $0x0
  802e98:	ff 75 d0             	pushl  -0x30(%ebp)
  802e9b:	ff 75 cc             	pushl  -0x34(%ebp)
  802e9e:	e8 e0 f6 ff ff       	call   802583 <set_block_data>
  802ea3:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea9:	e9 a3 01 00 00       	jmp    803051 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802eae:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802eb2:	0f 85 9d 00 00 00    	jne    802f55 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802eb8:	83 ec 04             	sub    $0x4,%esp
  802ebb:	6a 01                	push   $0x1
  802ebd:	ff 75 ec             	pushl  -0x14(%ebp)
  802ec0:	ff 75 f0             	pushl  -0x10(%ebp)
  802ec3:	e8 bb f6 ff ff       	call   802583 <set_block_data>
  802ec8:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802ecb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ecf:	75 17                	jne    802ee8 <alloc_block_BF+0x47a>
  802ed1:	83 ec 04             	sub    $0x4,%esp
  802ed4:	68 3f 48 80 00       	push   $0x80483f
  802ed9:	68 58 01 00 00       	push   $0x158
  802ede:	68 5d 48 80 00       	push   $0x80485d
  802ee3:	e8 aa d6 ff ff       	call   800592 <_panic>
  802ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	85 c0                	test   %eax,%eax
  802eef:	74 10                	je     802f01 <alloc_block_BF+0x493>
  802ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef9:	8b 52 04             	mov    0x4(%edx),%edx
  802efc:	89 50 04             	mov    %edx,0x4(%eax)
  802eff:	eb 0b                	jmp    802f0c <alloc_block_BF+0x49e>
  802f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f04:	8b 40 04             	mov    0x4(%eax),%eax
  802f07:	a3 34 50 80 00       	mov    %eax,0x805034
  802f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	85 c0                	test   %eax,%eax
  802f14:	74 0f                	je     802f25 <alloc_block_BF+0x4b7>
  802f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f19:	8b 40 04             	mov    0x4(%eax),%eax
  802f1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f1f:	8b 12                	mov    (%edx),%edx
  802f21:	89 10                	mov    %edx,(%eax)
  802f23:	eb 0a                	jmp    802f2f <alloc_block_BF+0x4c1>
  802f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	a3 30 50 80 00       	mov    %eax,0x805030
  802f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f42:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f47:	48                   	dec    %eax
  802f48:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f50:	e9 fc 00 00 00       	jmp    803051 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	83 c0 08             	add    $0x8,%eax
  802f5b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f5e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f65:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f68:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f6b:	01 d0                	add    %edx,%eax
  802f6d:	48                   	dec    %eax
  802f6e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f71:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f74:	ba 00 00 00 00       	mov    $0x0,%edx
  802f79:	f7 75 c4             	divl   -0x3c(%ebp)
  802f7c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f7f:	29 d0                	sub    %edx,%eax
  802f81:	c1 e8 0c             	shr    $0xc,%eax
  802f84:	83 ec 0c             	sub    $0xc,%esp
  802f87:	50                   	push   %eax
  802f88:	e8 5c e6 ff ff       	call   8015e9 <sbrk>
  802f8d:	83 c4 10             	add    $0x10,%esp
  802f90:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802f93:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802f97:	75 0a                	jne    802fa3 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802f99:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9e:	e9 ae 00 00 00       	jmp    803051 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802fa3:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802faa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802fad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802fb0:	01 d0                	add    %edx,%eax
  802fb2:	48                   	dec    %eax
  802fb3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802fb6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fb9:	ba 00 00 00 00       	mov    $0x0,%edx
  802fbe:	f7 75 b8             	divl   -0x48(%ebp)
  802fc1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fc4:	29 d0                	sub    %edx,%eax
  802fc6:	8d 50 fc             	lea    -0x4(%eax),%edx
  802fc9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802fcc:	01 d0                	add    %edx,%eax
  802fce:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802fd3:	a1 44 50 80 00       	mov    0x805044,%eax
  802fd8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802fde:	83 ec 0c             	sub    $0xc,%esp
  802fe1:	68 04 49 80 00       	push   $0x804904
  802fe6:	e8 64 d8 ff ff       	call   80084f <cprintf>
  802feb:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802fee:	83 ec 08             	sub    $0x8,%esp
  802ff1:	ff 75 bc             	pushl  -0x44(%ebp)
  802ff4:	68 09 49 80 00       	push   $0x804909
  802ff9:	e8 51 d8 ff ff       	call   80084f <cprintf>
  802ffe:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803001:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803008:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80300b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80300e:	01 d0                	add    %edx,%eax
  803010:	48                   	dec    %eax
  803011:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803014:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803017:	ba 00 00 00 00       	mov    $0x0,%edx
  80301c:	f7 75 b0             	divl   -0x50(%ebp)
  80301f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803022:	29 d0                	sub    %edx,%eax
  803024:	83 ec 04             	sub    $0x4,%esp
  803027:	6a 01                	push   $0x1
  803029:	50                   	push   %eax
  80302a:	ff 75 bc             	pushl  -0x44(%ebp)
  80302d:	e8 51 f5 ff ff       	call   802583 <set_block_data>
  803032:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803035:	83 ec 0c             	sub    $0xc,%esp
  803038:	ff 75 bc             	pushl  -0x44(%ebp)
  80303b:	e8 36 04 00 00       	call   803476 <free_block>
  803040:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803043:	83 ec 0c             	sub    $0xc,%esp
  803046:	ff 75 08             	pushl  0x8(%ebp)
  803049:	e8 20 fa ff ff       	call   802a6e <alloc_block_BF>
  80304e:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803051:	c9                   	leave  
  803052:	c3                   	ret    

00803053 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803053:	55                   	push   %ebp
  803054:	89 e5                	mov    %esp,%ebp
  803056:	53                   	push   %ebx
  803057:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80305a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803061:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803068:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80306c:	74 1e                	je     80308c <merging+0x39>
  80306e:	ff 75 08             	pushl  0x8(%ebp)
  803071:	e8 bc f1 ff ff       	call   802232 <get_block_size>
  803076:	83 c4 04             	add    $0x4,%esp
  803079:	89 c2                	mov    %eax,%edx
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	01 d0                	add    %edx,%eax
  803080:	3b 45 10             	cmp    0x10(%ebp),%eax
  803083:	75 07                	jne    80308c <merging+0x39>
		prev_is_free = 1;
  803085:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80308c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803090:	74 1e                	je     8030b0 <merging+0x5d>
  803092:	ff 75 10             	pushl  0x10(%ebp)
  803095:	e8 98 f1 ff ff       	call   802232 <get_block_size>
  80309a:	83 c4 04             	add    $0x4,%esp
  80309d:	89 c2                	mov    %eax,%edx
  80309f:	8b 45 10             	mov    0x10(%ebp),%eax
  8030a2:	01 d0                	add    %edx,%eax
  8030a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030a7:	75 07                	jne    8030b0 <merging+0x5d>
		next_is_free = 1;
  8030a9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8030b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b4:	0f 84 cc 00 00 00    	je     803186 <merging+0x133>
  8030ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030be:	0f 84 c2 00 00 00    	je     803186 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8030c4:	ff 75 08             	pushl  0x8(%ebp)
  8030c7:	e8 66 f1 ff ff       	call   802232 <get_block_size>
  8030cc:	83 c4 04             	add    $0x4,%esp
  8030cf:	89 c3                	mov    %eax,%ebx
  8030d1:	ff 75 10             	pushl  0x10(%ebp)
  8030d4:	e8 59 f1 ff ff       	call   802232 <get_block_size>
  8030d9:	83 c4 04             	add    $0x4,%esp
  8030dc:	01 c3                	add    %eax,%ebx
  8030de:	ff 75 0c             	pushl  0xc(%ebp)
  8030e1:	e8 4c f1 ff ff       	call   802232 <get_block_size>
  8030e6:	83 c4 04             	add    $0x4,%esp
  8030e9:	01 d8                	add    %ebx,%eax
  8030eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8030ee:	6a 00                	push   $0x0
  8030f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8030f3:	ff 75 08             	pushl  0x8(%ebp)
  8030f6:	e8 88 f4 ff ff       	call   802583 <set_block_data>
  8030fb:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8030fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803102:	75 17                	jne    80311b <merging+0xc8>
  803104:	83 ec 04             	sub    $0x4,%esp
  803107:	68 3f 48 80 00       	push   $0x80483f
  80310c:	68 7d 01 00 00       	push   $0x17d
  803111:	68 5d 48 80 00       	push   $0x80485d
  803116:	e8 77 d4 ff ff       	call   800592 <_panic>
  80311b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 10                	je     803134 <merging+0xe1>
  803124:	8b 45 0c             	mov    0xc(%ebp),%eax
  803127:	8b 00                	mov    (%eax),%eax
  803129:	8b 55 0c             	mov    0xc(%ebp),%edx
  80312c:	8b 52 04             	mov    0x4(%edx),%edx
  80312f:	89 50 04             	mov    %edx,0x4(%eax)
  803132:	eb 0b                	jmp    80313f <merging+0xec>
  803134:	8b 45 0c             	mov    0xc(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	a3 34 50 80 00       	mov    %eax,0x805034
  80313f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803142:	8b 40 04             	mov    0x4(%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	74 0f                	je     803158 <merging+0x105>
  803149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314c:	8b 40 04             	mov    0x4(%eax),%eax
  80314f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803152:	8b 12                	mov    (%edx),%edx
  803154:	89 10                	mov    %edx,(%eax)
  803156:	eb 0a                	jmp    803162 <merging+0x10f>
  803158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	a3 30 50 80 00       	mov    %eax,0x805030
  803162:	8b 45 0c             	mov    0xc(%ebp),%eax
  803165:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803175:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80317a:	48                   	dec    %eax
  80317b:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803180:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803181:	e9 ea 02 00 00       	jmp    803470 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803186:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80318a:	74 3b                	je     8031c7 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80318c:	83 ec 0c             	sub    $0xc,%esp
  80318f:	ff 75 08             	pushl  0x8(%ebp)
  803192:	e8 9b f0 ff ff       	call   802232 <get_block_size>
  803197:	83 c4 10             	add    $0x10,%esp
  80319a:	89 c3                	mov    %eax,%ebx
  80319c:	83 ec 0c             	sub    $0xc,%esp
  80319f:	ff 75 10             	pushl  0x10(%ebp)
  8031a2:	e8 8b f0 ff ff       	call   802232 <get_block_size>
  8031a7:	83 c4 10             	add    $0x10,%esp
  8031aa:	01 d8                	add    %ebx,%eax
  8031ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8031af:	83 ec 04             	sub    $0x4,%esp
  8031b2:	6a 00                	push   $0x0
  8031b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8031b7:	ff 75 08             	pushl  0x8(%ebp)
  8031ba:	e8 c4 f3 ff ff       	call   802583 <set_block_data>
  8031bf:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031c2:	e9 a9 02 00 00       	jmp    803470 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8031c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031cb:	0f 84 2d 01 00 00    	je     8032fe <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8031d1:	83 ec 0c             	sub    $0xc,%esp
  8031d4:	ff 75 10             	pushl  0x10(%ebp)
  8031d7:	e8 56 f0 ff ff       	call   802232 <get_block_size>
  8031dc:	83 c4 10             	add    $0x10,%esp
  8031df:	89 c3                	mov    %eax,%ebx
  8031e1:	83 ec 0c             	sub    $0xc,%esp
  8031e4:	ff 75 0c             	pushl  0xc(%ebp)
  8031e7:	e8 46 f0 ff ff       	call   802232 <get_block_size>
  8031ec:	83 c4 10             	add    $0x10,%esp
  8031ef:	01 d8                	add    %ebx,%eax
  8031f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8031f4:	83 ec 04             	sub    $0x4,%esp
  8031f7:	6a 00                	push   $0x0
  8031f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031fc:	ff 75 10             	pushl  0x10(%ebp)
  8031ff:	e8 7f f3 ff ff       	call   802583 <set_block_data>
  803204:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803207:	8b 45 10             	mov    0x10(%ebp),%eax
  80320a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80320d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803211:	74 06                	je     803219 <merging+0x1c6>
  803213:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803217:	75 17                	jne    803230 <merging+0x1dd>
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	68 18 49 80 00       	push   $0x804918
  803221:	68 8d 01 00 00       	push   $0x18d
  803226:	68 5d 48 80 00       	push   $0x80485d
  80322b:	e8 62 d3 ff ff       	call   800592 <_panic>
  803230:	8b 45 0c             	mov    0xc(%ebp),%eax
  803233:	8b 50 04             	mov    0x4(%eax),%edx
  803236:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803239:	89 50 04             	mov    %edx,0x4(%eax)
  80323c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80323f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803242:	89 10                	mov    %edx,(%eax)
  803244:	8b 45 0c             	mov    0xc(%ebp),%eax
  803247:	8b 40 04             	mov    0x4(%eax),%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	74 0d                	je     80325b <merging+0x208>
  80324e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803251:	8b 40 04             	mov    0x4(%eax),%eax
  803254:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803257:	89 10                	mov    %edx,(%eax)
  803259:	eb 08                	jmp    803263 <merging+0x210>
  80325b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80325e:	a3 30 50 80 00       	mov    %eax,0x805030
  803263:	8b 45 0c             	mov    0xc(%ebp),%eax
  803266:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803269:	89 50 04             	mov    %edx,0x4(%eax)
  80326c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803271:	40                   	inc    %eax
  803272:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803277:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80327b:	75 17                	jne    803294 <merging+0x241>
  80327d:	83 ec 04             	sub    $0x4,%esp
  803280:	68 3f 48 80 00       	push   $0x80483f
  803285:	68 8e 01 00 00       	push   $0x18e
  80328a:	68 5d 48 80 00       	push   $0x80485d
  80328f:	e8 fe d2 ff ff       	call   800592 <_panic>
  803294:	8b 45 0c             	mov    0xc(%ebp),%eax
  803297:	8b 00                	mov    (%eax),%eax
  803299:	85 c0                	test   %eax,%eax
  80329b:	74 10                	je     8032ad <merging+0x25a>
  80329d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a0:	8b 00                	mov    (%eax),%eax
  8032a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032a5:	8b 52 04             	mov    0x4(%edx),%edx
  8032a8:	89 50 04             	mov    %edx,0x4(%eax)
  8032ab:	eb 0b                	jmp    8032b8 <merging+0x265>
  8032ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b0:	8b 40 04             	mov    0x4(%eax),%eax
  8032b3:	a3 34 50 80 00       	mov    %eax,0x805034
  8032b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032bb:	8b 40 04             	mov    0x4(%eax),%eax
  8032be:	85 c0                	test   %eax,%eax
  8032c0:	74 0f                	je     8032d1 <merging+0x27e>
  8032c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c5:	8b 40 04             	mov    0x4(%eax),%eax
  8032c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032cb:	8b 12                	mov    (%edx),%edx
  8032cd:	89 10                	mov    %edx,(%eax)
  8032cf:	eb 0a                	jmp    8032db <merging+0x288>
  8032d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8032db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032f3:	48                   	dec    %eax
  8032f4:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032f9:	e9 72 01 00 00       	jmp    803470 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8032fe:	8b 45 10             	mov    0x10(%ebp),%eax
  803301:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803304:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803308:	74 79                	je     803383 <merging+0x330>
  80330a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80330e:	74 73                	je     803383 <merging+0x330>
  803310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803314:	74 06                	je     80331c <merging+0x2c9>
  803316:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80331a:	75 17                	jne    803333 <merging+0x2e0>
  80331c:	83 ec 04             	sub    $0x4,%esp
  80331f:	68 d0 48 80 00       	push   $0x8048d0
  803324:	68 94 01 00 00       	push   $0x194
  803329:	68 5d 48 80 00       	push   $0x80485d
  80332e:	e8 5f d2 ff ff       	call   800592 <_panic>
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	8b 10                	mov    (%eax),%edx
  803338:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80333b:	89 10                	mov    %edx,(%eax)
  80333d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803340:	8b 00                	mov    (%eax),%eax
  803342:	85 c0                	test   %eax,%eax
  803344:	74 0b                	je     803351 <merging+0x2fe>
  803346:	8b 45 08             	mov    0x8(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80334e:	89 50 04             	mov    %edx,0x4(%eax)
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803357:	89 10                	mov    %edx,(%eax)
  803359:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80335c:	8b 55 08             	mov    0x8(%ebp),%edx
  80335f:	89 50 04             	mov    %edx,0x4(%eax)
  803362:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	85 c0                	test   %eax,%eax
  803369:	75 08                	jne    803373 <merging+0x320>
  80336b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80336e:	a3 34 50 80 00       	mov    %eax,0x805034
  803373:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803378:	40                   	inc    %eax
  803379:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80337e:	e9 ce 00 00 00       	jmp    803451 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803383:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803387:	74 65                	je     8033ee <merging+0x39b>
  803389:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80338d:	75 17                	jne    8033a6 <merging+0x353>
  80338f:	83 ec 04             	sub    $0x4,%esp
  803392:	68 ac 48 80 00       	push   $0x8048ac
  803397:	68 95 01 00 00       	push   $0x195
  80339c:	68 5d 48 80 00       	push   $0x80485d
  8033a1:	e8 ec d1 ff ff       	call   800592 <_panic>
  8033a6:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8033ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033af:	89 50 04             	mov    %edx,0x4(%eax)
  8033b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033b5:	8b 40 04             	mov    0x4(%eax),%eax
  8033b8:	85 c0                	test   %eax,%eax
  8033ba:	74 0c                	je     8033c8 <merging+0x375>
  8033bc:	a1 34 50 80 00       	mov    0x805034,%eax
  8033c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033c4:	89 10                	mov    %edx,(%eax)
  8033c6:	eb 08                	jmp    8033d0 <merging+0x37d>
  8033c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8033d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033d3:	a3 34 50 80 00       	mov    %eax,0x805034
  8033d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033e6:	40                   	inc    %eax
  8033e7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8033ec:	eb 63                	jmp    803451 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8033ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033f2:	75 17                	jne    80340b <merging+0x3b8>
  8033f4:	83 ec 04             	sub    $0x4,%esp
  8033f7:	68 78 48 80 00       	push   $0x804878
  8033fc:	68 98 01 00 00       	push   $0x198
  803401:	68 5d 48 80 00       	push   $0x80485d
  803406:	e8 87 d1 ff ff       	call   800592 <_panic>
  80340b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803411:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803414:	89 10                	mov    %edx,(%eax)
  803416:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	74 0d                	je     80342c <merging+0x3d9>
  80341f:	a1 30 50 80 00       	mov    0x805030,%eax
  803424:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803427:	89 50 04             	mov    %edx,0x4(%eax)
  80342a:	eb 08                	jmp    803434 <merging+0x3e1>
  80342c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80342f:	a3 34 50 80 00       	mov    %eax,0x805034
  803434:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803437:	a3 30 50 80 00       	mov    %eax,0x805030
  80343c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80343f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803446:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80344b:	40                   	inc    %eax
  80344c:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803451:	83 ec 0c             	sub    $0xc,%esp
  803454:	ff 75 10             	pushl  0x10(%ebp)
  803457:	e8 d6 ed ff ff       	call   802232 <get_block_size>
  80345c:	83 c4 10             	add    $0x10,%esp
  80345f:	83 ec 04             	sub    $0x4,%esp
  803462:	6a 00                	push   $0x0
  803464:	50                   	push   %eax
  803465:	ff 75 10             	pushl  0x10(%ebp)
  803468:	e8 16 f1 ff ff       	call   802583 <set_block_data>
  80346d:	83 c4 10             	add    $0x10,%esp
	}
}
  803470:	90                   	nop
  803471:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803474:	c9                   	leave  
  803475:	c3                   	ret    

00803476 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803476:	55                   	push   %ebp
  803477:	89 e5                	mov    %esp,%ebp
  803479:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80347c:	a1 30 50 80 00       	mov    0x805030,%eax
  803481:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803484:	a1 34 50 80 00       	mov    0x805034,%eax
  803489:	3b 45 08             	cmp    0x8(%ebp),%eax
  80348c:	73 1b                	jae    8034a9 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80348e:	a1 34 50 80 00       	mov    0x805034,%eax
  803493:	83 ec 04             	sub    $0x4,%esp
  803496:	ff 75 08             	pushl  0x8(%ebp)
  803499:	6a 00                	push   $0x0
  80349b:	50                   	push   %eax
  80349c:	e8 b2 fb ff ff       	call   803053 <merging>
  8034a1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8034a4:	e9 8b 00 00 00       	jmp    803534 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8034a9:	a1 30 50 80 00       	mov    0x805030,%eax
  8034ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034b1:	76 18                	jbe    8034cb <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8034b3:	a1 30 50 80 00       	mov    0x805030,%eax
  8034b8:	83 ec 04             	sub    $0x4,%esp
  8034bb:	ff 75 08             	pushl  0x8(%ebp)
  8034be:	50                   	push   %eax
  8034bf:	6a 00                	push   $0x0
  8034c1:	e8 8d fb ff ff       	call   803053 <merging>
  8034c6:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8034c9:	eb 69                	jmp    803534 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8034cb:	a1 30 50 80 00       	mov    0x805030,%eax
  8034d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034d3:	eb 39                	jmp    80350e <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034db:	73 29                	jae    803506 <free_block+0x90>
  8034dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e0:	8b 00                	mov    (%eax),%eax
  8034e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034e5:	76 1f                	jbe    803506 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8034ef:	83 ec 04             	sub    $0x4,%esp
  8034f2:	ff 75 08             	pushl  0x8(%ebp)
  8034f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8034f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8034fb:	e8 53 fb ff ff       	call   803053 <merging>
  803500:	83 c4 10             	add    $0x10,%esp
			break;
  803503:	90                   	nop
		}
	}
}
  803504:	eb 2e                	jmp    803534 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803506:	a1 38 50 80 00       	mov    0x805038,%eax
  80350b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80350e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803512:	74 07                	je     80351b <free_block+0xa5>
  803514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803517:	8b 00                	mov    (%eax),%eax
  803519:	eb 05                	jmp    803520 <free_block+0xaa>
  80351b:	b8 00 00 00 00       	mov    $0x0,%eax
  803520:	a3 38 50 80 00       	mov    %eax,0x805038
  803525:	a1 38 50 80 00       	mov    0x805038,%eax
  80352a:	85 c0                	test   %eax,%eax
  80352c:	75 a7                	jne    8034d5 <free_block+0x5f>
  80352e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803532:	75 a1                	jne    8034d5 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803534:	90                   	nop
  803535:	c9                   	leave  
  803536:	c3                   	ret    

00803537 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803537:	55                   	push   %ebp
  803538:	89 e5                	mov    %esp,%ebp
  80353a:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80353d:	ff 75 08             	pushl  0x8(%ebp)
  803540:	e8 ed ec ff ff       	call   802232 <get_block_size>
  803545:	83 c4 04             	add    $0x4,%esp
  803548:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80354b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803552:	eb 17                	jmp    80356b <copy_data+0x34>
  803554:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355a:	01 c2                	add    %eax,%edx
  80355c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	01 c8                	add    %ecx,%eax
  803564:	8a 00                	mov    (%eax),%al
  803566:	88 02                	mov    %al,(%edx)
  803568:	ff 45 fc             	incl   -0x4(%ebp)
  80356b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80356e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803571:	72 e1                	jb     803554 <copy_data+0x1d>
}
  803573:	90                   	nop
  803574:	c9                   	leave  
  803575:	c3                   	ret    

00803576 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803576:	55                   	push   %ebp
  803577:	89 e5                	mov    %esp,%ebp
  803579:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80357c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803580:	75 23                	jne    8035a5 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803582:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803586:	74 13                	je     80359b <realloc_block_FF+0x25>
  803588:	83 ec 0c             	sub    $0xc,%esp
  80358b:	ff 75 0c             	pushl  0xc(%ebp)
  80358e:	e8 1f f0 ff ff       	call   8025b2 <alloc_block_FF>
  803593:	83 c4 10             	add    $0x10,%esp
  803596:	e9 f4 06 00 00       	jmp    803c8f <realloc_block_FF+0x719>
		return NULL;
  80359b:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a0:	e9 ea 06 00 00       	jmp    803c8f <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8035a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035a9:	75 18                	jne    8035c3 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8035ab:	83 ec 0c             	sub    $0xc,%esp
  8035ae:	ff 75 08             	pushl  0x8(%ebp)
  8035b1:	e8 c0 fe ff ff       	call   803476 <free_block>
  8035b6:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8035b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035be:	e9 cc 06 00 00       	jmp    803c8f <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8035c3:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8035c7:	77 07                	ja     8035d0 <realloc_block_FF+0x5a>
  8035c9:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8035d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d3:	83 e0 01             	and    $0x1,%eax
  8035d6:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8035d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035dc:	83 c0 08             	add    $0x8,%eax
  8035df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8035e2:	83 ec 0c             	sub    $0xc,%esp
  8035e5:	ff 75 08             	pushl  0x8(%ebp)
  8035e8:	e8 45 ec ff ff       	call   802232 <get_block_size>
  8035ed:	83 c4 10             	add    $0x10,%esp
  8035f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8035f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f6:	83 e8 08             	sub    $0x8,%eax
  8035f9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8035fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ff:	83 e8 04             	sub    $0x4,%eax
  803602:	8b 00                	mov    (%eax),%eax
  803604:	83 e0 fe             	and    $0xfffffffe,%eax
  803607:	89 c2                	mov    %eax,%edx
  803609:	8b 45 08             	mov    0x8(%ebp),%eax
  80360c:	01 d0                	add    %edx,%eax
  80360e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803611:	83 ec 0c             	sub    $0xc,%esp
  803614:	ff 75 e4             	pushl  -0x1c(%ebp)
  803617:	e8 16 ec ff ff       	call   802232 <get_block_size>
  80361c:	83 c4 10             	add    $0x10,%esp
  80361f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803622:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803625:	83 e8 08             	sub    $0x8,%eax
  803628:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80362b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803631:	75 08                	jne    80363b <realloc_block_FF+0xc5>
	{
		 return va;
  803633:	8b 45 08             	mov    0x8(%ebp),%eax
  803636:	e9 54 06 00 00       	jmp    803c8f <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80363b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80363e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803641:	0f 83 e5 03 00 00    	jae    803a2c <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80364d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803650:	83 ec 0c             	sub    $0xc,%esp
  803653:	ff 75 e4             	pushl  -0x1c(%ebp)
  803656:	e8 f0 eb ff ff       	call   80224b <is_free_block>
  80365b:	83 c4 10             	add    $0x10,%esp
  80365e:	84 c0                	test   %al,%al
  803660:	0f 84 3b 01 00 00    	je     8037a1 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803666:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803669:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80366c:	01 d0                	add    %edx,%eax
  80366e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803671:	83 ec 04             	sub    $0x4,%esp
  803674:	6a 01                	push   $0x1
  803676:	ff 75 f0             	pushl  -0x10(%ebp)
  803679:	ff 75 08             	pushl  0x8(%ebp)
  80367c:	e8 02 ef ff ff       	call   802583 <set_block_data>
  803681:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803684:	8b 45 08             	mov    0x8(%ebp),%eax
  803687:	83 e8 04             	sub    $0x4,%eax
  80368a:	8b 00                	mov    (%eax),%eax
  80368c:	83 e0 fe             	and    $0xfffffffe,%eax
  80368f:	89 c2                	mov    %eax,%edx
  803691:	8b 45 08             	mov    0x8(%ebp),%eax
  803694:	01 d0                	add    %edx,%eax
  803696:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803699:	83 ec 04             	sub    $0x4,%esp
  80369c:	6a 00                	push   $0x0
  80369e:	ff 75 cc             	pushl  -0x34(%ebp)
  8036a1:	ff 75 c8             	pushl  -0x38(%ebp)
  8036a4:	e8 da ee ff ff       	call   802583 <set_block_data>
  8036a9:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036b0:	74 06                	je     8036b8 <realloc_block_FF+0x142>
  8036b2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8036b6:	75 17                	jne    8036cf <realloc_block_FF+0x159>
  8036b8:	83 ec 04             	sub    $0x4,%esp
  8036bb:	68 d0 48 80 00       	push   $0x8048d0
  8036c0:	68 f6 01 00 00       	push   $0x1f6
  8036c5:	68 5d 48 80 00       	push   $0x80485d
  8036ca:	e8 c3 ce ff ff       	call   800592 <_panic>
  8036cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d2:	8b 10                	mov    (%eax),%edx
  8036d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036d7:	89 10                	mov    %edx,(%eax)
  8036d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036dc:	8b 00                	mov    (%eax),%eax
  8036de:	85 c0                	test   %eax,%eax
  8036e0:	74 0b                	je     8036ed <realloc_block_FF+0x177>
  8036e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e5:	8b 00                	mov    (%eax),%eax
  8036e7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8036ea:	89 50 04             	mov    %edx,0x4(%eax)
  8036ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8036f3:	89 10                	mov    %edx,(%eax)
  8036f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036fb:	89 50 04             	mov    %edx,0x4(%eax)
  8036fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803701:	8b 00                	mov    (%eax),%eax
  803703:	85 c0                	test   %eax,%eax
  803705:	75 08                	jne    80370f <realloc_block_FF+0x199>
  803707:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80370a:	a3 34 50 80 00       	mov    %eax,0x805034
  80370f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803714:	40                   	inc    %eax
  803715:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80371a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80371e:	75 17                	jne    803737 <realloc_block_FF+0x1c1>
  803720:	83 ec 04             	sub    $0x4,%esp
  803723:	68 3f 48 80 00       	push   $0x80483f
  803728:	68 f7 01 00 00       	push   $0x1f7
  80372d:	68 5d 48 80 00       	push   $0x80485d
  803732:	e8 5b ce ff ff       	call   800592 <_panic>
  803737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373a:	8b 00                	mov    (%eax),%eax
  80373c:	85 c0                	test   %eax,%eax
  80373e:	74 10                	je     803750 <realloc_block_FF+0x1da>
  803740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803743:	8b 00                	mov    (%eax),%eax
  803745:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803748:	8b 52 04             	mov    0x4(%edx),%edx
  80374b:	89 50 04             	mov    %edx,0x4(%eax)
  80374e:	eb 0b                	jmp    80375b <realloc_block_FF+0x1e5>
  803750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803753:	8b 40 04             	mov    0x4(%eax),%eax
  803756:	a3 34 50 80 00       	mov    %eax,0x805034
  80375b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375e:	8b 40 04             	mov    0x4(%eax),%eax
  803761:	85 c0                	test   %eax,%eax
  803763:	74 0f                	je     803774 <realloc_block_FF+0x1fe>
  803765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803768:	8b 40 04             	mov    0x4(%eax),%eax
  80376b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80376e:	8b 12                	mov    (%edx),%edx
  803770:	89 10                	mov    %edx,(%eax)
  803772:	eb 0a                	jmp    80377e <realloc_block_FF+0x208>
  803774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803777:	8b 00                	mov    (%eax),%eax
  803779:	a3 30 50 80 00       	mov    %eax,0x805030
  80377e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803781:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803791:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803796:	48                   	dec    %eax
  803797:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80379c:	e9 83 02 00 00       	jmp    803a24 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8037a1:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8037a5:	0f 86 69 02 00 00    	jbe    803a14 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8037ab:	83 ec 04             	sub    $0x4,%esp
  8037ae:	6a 01                	push   $0x1
  8037b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8037b3:	ff 75 08             	pushl  0x8(%ebp)
  8037b6:	e8 c8 ed ff ff       	call   802583 <set_block_data>
  8037bb:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037be:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c1:	83 e8 04             	sub    $0x4,%eax
  8037c4:	8b 00                	mov    (%eax),%eax
  8037c6:	83 e0 fe             	and    $0xfffffffe,%eax
  8037c9:	89 c2                	mov    %eax,%edx
  8037cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ce:	01 d0                	add    %edx,%eax
  8037d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8037d3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8037db:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8037df:	75 68                	jne    803849 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8037e1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037e5:	75 17                	jne    8037fe <realloc_block_FF+0x288>
  8037e7:	83 ec 04             	sub    $0x4,%esp
  8037ea:	68 78 48 80 00       	push   $0x804878
  8037ef:	68 06 02 00 00       	push   $0x206
  8037f4:	68 5d 48 80 00       	push   $0x80485d
  8037f9:	e8 94 cd ff ff       	call   800592 <_panic>
  8037fe:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803807:	89 10                	mov    %edx,(%eax)
  803809:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80380c:	8b 00                	mov    (%eax),%eax
  80380e:	85 c0                	test   %eax,%eax
  803810:	74 0d                	je     80381f <realloc_block_FF+0x2a9>
  803812:	a1 30 50 80 00       	mov    0x805030,%eax
  803817:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80381a:	89 50 04             	mov    %edx,0x4(%eax)
  80381d:	eb 08                	jmp    803827 <realloc_block_FF+0x2b1>
  80381f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803822:	a3 34 50 80 00       	mov    %eax,0x805034
  803827:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80382a:	a3 30 50 80 00       	mov    %eax,0x805030
  80382f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803832:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803839:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80383e:	40                   	inc    %eax
  80383f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803844:	e9 b0 01 00 00       	jmp    8039f9 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803849:	a1 30 50 80 00       	mov    0x805030,%eax
  80384e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803851:	76 68                	jbe    8038bb <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803853:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803857:	75 17                	jne    803870 <realloc_block_FF+0x2fa>
  803859:	83 ec 04             	sub    $0x4,%esp
  80385c:	68 78 48 80 00       	push   $0x804878
  803861:	68 0b 02 00 00       	push   $0x20b
  803866:	68 5d 48 80 00       	push   $0x80485d
  80386b:	e8 22 cd ff ff       	call   800592 <_panic>
  803870:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803876:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803879:	89 10                	mov    %edx,(%eax)
  80387b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80387e:	8b 00                	mov    (%eax),%eax
  803880:	85 c0                	test   %eax,%eax
  803882:	74 0d                	je     803891 <realloc_block_FF+0x31b>
  803884:	a1 30 50 80 00       	mov    0x805030,%eax
  803889:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80388c:	89 50 04             	mov    %edx,0x4(%eax)
  80388f:	eb 08                	jmp    803899 <realloc_block_FF+0x323>
  803891:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803894:	a3 34 50 80 00       	mov    %eax,0x805034
  803899:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80389c:	a3 30 50 80 00       	mov    %eax,0x805030
  8038a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ab:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038b0:	40                   	inc    %eax
  8038b1:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8038b6:	e9 3e 01 00 00       	jmp    8039f9 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8038bb:	a1 30 50 80 00       	mov    0x805030,%eax
  8038c0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8038c3:	73 68                	jae    80392d <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8038c5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038c9:	75 17                	jne    8038e2 <realloc_block_FF+0x36c>
  8038cb:	83 ec 04             	sub    $0x4,%esp
  8038ce:	68 ac 48 80 00       	push   $0x8048ac
  8038d3:	68 10 02 00 00       	push   $0x210
  8038d8:	68 5d 48 80 00       	push   $0x80485d
  8038dd:	e8 b0 cc ff ff       	call   800592 <_panic>
  8038e2:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8038e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038eb:	89 50 04             	mov    %edx,0x4(%eax)
  8038ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038f1:	8b 40 04             	mov    0x4(%eax),%eax
  8038f4:	85 c0                	test   %eax,%eax
  8038f6:	74 0c                	je     803904 <realloc_block_FF+0x38e>
  8038f8:	a1 34 50 80 00       	mov    0x805034,%eax
  8038fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803900:	89 10                	mov    %edx,(%eax)
  803902:	eb 08                	jmp    80390c <realloc_block_FF+0x396>
  803904:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803907:	a3 30 50 80 00       	mov    %eax,0x805030
  80390c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80390f:	a3 34 50 80 00       	mov    %eax,0x805034
  803914:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803917:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80391d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803922:	40                   	inc    %eax
  803923:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803928:	e9 cc 00 00 00       	jmp    8039f9 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80392d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803934:	a1 30 50 80 00       	mov    0x805030,%eax
  803939:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80393c:	e9 8a 00 00 00       	jmp    8039cb <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803944:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803947:	73 7a                	jae    8039c3 <realloc_block_FF+0x44d>
  803949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803951:	73 70                	jae    8039c3 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803953:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803957:	74 06                	je     80395f <realloc_block_FF+0x3e9>
  803959:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80395d:	75 17                	jne    803976 <realloc_block_FF+0x400>
  80395f:	83 ec 04             	sub    $0x4,%esp
  803962:	68 d0 48 80 00       	push   $0x8048d0
  803967:	68 1a 02 00 00       	push   $0x21a
  80396c:	68 5d 48 80 00       	push   $0x80485d
  803971:	e8 1c cc ff ff       	call   800592 <_panic>
  803976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803979:	8b 10                	mov    (%eax),%edx
  80397b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80397e:	89 10                	mov    %edx,(%eax)
  803980:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803983:	8b 00                	mov    (%eax),%eax
  803985:	85 c0                	test   %eax,%eax
  803987:	74 0b                	je     803994 <realloc_block_FF+0x41e>
  803989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398c:	8b 00                	mov    (%eax),%eax
  80398e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803991:	89 50 04             	mov    %edx,0x4(%eax)
  803994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803997:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80399a:	89 10                	mov    %edx,(%eax)
  80399c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80399f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039a2:	89 50 04             	mov    %edx,0x4(%eax)
  8039a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a8:	8b 00                	mov    (%eax),%eax
  8039aa:	85 c0                	test   %eax,%eax
  8039ac:	75 08                	jne    8039b6 <realloc_block_FF+0x440>
  8039ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039b1:	a3 34 50 80 00       	mov    %eax,0x805034
  8039b6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039bb:	40                   	inc    %eax
  8039bc:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  8039c1:	eb 36                	jmp    8039f9 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8039c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8039c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039cf:	74 07                	je     8039d8 <realloc_block_FF+0x462>
  8039d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d4:	8b 00                	mov    (%eax),%eax
  8039d6:	eb 05                	jmp    8039dd <realloc_block_FF+0x467>
  8039d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039dd:	a3 38 50 80 00       	mov    %eax,0x805038
  8039e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8039e7:	85 c0                	test   %eax,%eax
  8039e9:	0f 85 52 ff ff ff    	jne    803941 <realloc_block_FF+0x3cb>
  8039ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039f3:	0f 85 48 ff ff ff    	jne    803941 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8039f9:	83 ec 04             	sub    $0x4,%esp
  8039fc:	6a 00                	push   $0x0
  8039fe:	ff 75 d8             	pushl  -0x28(%ebp)
  803a01:	ff 75 d4             	pushl  -0x2c(%ebp)
  803a04:	e8 7a eb ff ff       	call   802583 <set_block_data>
  803a09:	83 c4 10             	add    $0x10,%esp
				return va;
  803a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0f:	e9 7b 02 00 00       	jmp    803c8f <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803a14:	83 ec 0c             	sub    $0xc,%esp
  803a17:	68 4d 49 80 00       	push   $0x80494d
  803a1c:	e8 2e ce ff ff       	call   80084f <cprintf>
  803a21:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803a24:	8b 45 08             	mov    0x8(%ebp),%eax
  803a27:	e9 63 02 00 00       	jmp    803c8f <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a2f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a32:	0f 86 4d 02 00 00    	jbe    803c85 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803a38:	83 ec 0c             	sub    $0xc,%esp
  803a3b:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a3e:	e8 08 e8 ff ff       	call   80224b <is_free_block>
  803a43:	83 c4 10             	add    $0x10,%esp
  803a46:	84 c0                	test   %al,%al
  803a48:	0f 84 37 02 00 00    	je     803c85 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a51:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803a54:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803a57:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a5a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803a5d:	76 38                	jbe    803a97 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803a5f:	83 ec 0c             	sub    $0xc,%esp
  803a62:	ff 75 08             	pushl  0x8(%ebp)
  803a65:	e8 0c fa ff ff       	call   803476 <free_block>
  803a6a:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803a6d:	83 ec 0c             	sub    $0xc,%esp
  803a70:	ff 75 0c             	pushl  0xc(%ebp)
  803a73:	e8 3a eb ff ff       	call   8025b2 <alloc_block_FF>
  803a78:	83 c4 10             	add    $0x10,%esp
  803a7b:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803a7e:	83 ec 08             	sub    $0x8,%esp
  803a81:	ff 75 c0             	pushl  -0x40(%ebp)
  803a84:	ff 75 08             	pushl  0x8(%ebp)
  803a87:	e8 ab fa ff ff       	call   803537 <copy_data>
  803a8c:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803a8f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a92:	e9 f8 01 00 00       	jmp    803c8f <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803a97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a9a:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803a9d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803aa0:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803aa4:	0f 87 a0 00 00 00    	ja     803b4a <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803aaa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803aae:	75 17                	jne    803ac7 <realloc_block_FF+0x551>
  803ab0:	83 ec 04             	sub    $0x4,%esp
  803ab3:	68 3f 48 80 00       	push   $0x80483f
  803ab8:	68 38 02 00 00       	push   $0x238
  803abd:	68 5d 48 80 00       	push   $0x80485d
  803ac2:	e8 cb ca ff ff       	call   800592 <_panic>
  803ac7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aca:	8b 00                	mov    (%eax),%eax
  803acc:	85 c0                	test   %eax,%eax
  803ace:	74 10                	je     803ae0 <realloc_block_FF+0x56a>
  803ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad3:	8b 00                	mov    (%eax),%eax
  803ad5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad8:	8b 52 04             	mov    0x4(%edx),%edx
  803adb:	89 50 04             	mov    %edx,0x4(%eax)
  803ade:	eb 0b                	jmp    803aeb <realloc_block_FF+0x575>
  803ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae3:	8b 40 04             	mov    0x4(%eax),%eax
  803ae6:	a3 34 50 80 00       	mov    %eax,0x805034
  803aeb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aee:	8b 40 04             	mov    0x4(%eax),%eax
  803af1:	85 c0                	test   %eax,%eax
  803af3:	74 0f                	je     803b04 <realloc_block_FF+0x58e>
  803af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af8:	8b 40 04             	mov    0x4(%eax),%eax
  803afb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803afe:	8b 12                	mov    (%edx),%edx
  803b00:	89 10                	mov    %edx,(%eax)
  803b02:	eb 0a                	jmp    803b0e <realloc_block_FF+0x598>
  803b04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b07:	8b 00                	mov    (%eax),%eax
  803b09:	a3 30 50 80 00       	mov    %eax,0x805030
  803b0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b21:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b26:	48                   	dec    %eax
  803b27:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803b2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b32:	01 d0                	add    %edx,%eax
  803b34:	83 ec 04             	sub    $0x4,%esp
  803b37:	6a 01                	push   $0x1
  803b39:	50                   	push   %eax
  803b3a:	ff 75 08             	pushl  0x8(%ebp)
  803b3d:	e8 41 ea ff ff       	call   802583 <set_block_data>
  803b42:	83 c4 10             	add    $0x10,%esp
  803b45:	e9 36 01 00 00       	jmp    803c80 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803b4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b4d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b50:	01 d0                	add    %edx,%eax
  803b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803b55:	83 ec 04             	sub    $0x4,%esp
  803b58:	6a 01                	push   $0x1
  803b5a:	ff 75 f0             	pushl  -0x10(%ebp)
  803b5d:	ff 75 08             	pushl  0x8(%ebp)
  803b60:	e8 1e ea ff ff       	call   802583 <set_block_data>
  803b65:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b68:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6b:	83 e8 04             	sub    $0x4,%eax
  803b6e:	8b 00                	mov    (%eax),%eax
  803b70:	83 e0 fe             	and    $0xfffffffe,%eax
  803b73:	89 c2                	mov    %eax,%edx
  803b75:	8b 45 08             	mov    0x8(%ebp),%eax
  803b78:	01 d0                	add    %edx,%eax
  803b7a:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b81:	74 06                	je     803b89 <realloc_block_FF+0x613>
  803b83:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803b87:	75 17                	jne    803ba0 <realloc_block_FF+0x62a>
  803b89:	83 ec 04             	sub    $0x4,%esp
  803b8c:	68 d0 48 80 00       	push   $0x8048d0
  803b91:	68 44 02 00 00       	push   $0x244
  803b96:	68 5d 48 80 00       	push   $0x80485d
  803b9b:	e8 f2 c9 ff ff       	call   800592 <_panic>
  803ba0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba3:	8b 10                	mov    (%eax),%edx
  803ba5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ba8:	89 10                	mov    %edx,(%eax)
  803baa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bad:	8b 00                	mov    (%eax),%eax
  803baf:	85 c0                	test   %eax,%eax
  803bb1:	74 0b                	je     803bbe <realloc_block_FF+0x648>
  803bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb6:	8b 00                	mov    (%eax),%eax
  803bb8:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803bbb:	89 50 04             	mov    %edx,0x4(%eax)
  803bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803bc4:	89 10                	mov    %edx,(%eax)
  803bc6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bc9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bcc:	89 50 04             	mov    %edx,0x4(%eax)
  803bcf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bd2:	8b 00                	mov    (%eax),%eax
  803bd4:	85 c0                	test   %eax,%eax
  803bd6:	75 08                	jne    803be0 <realloc_block_FF+0x66a>
  803bd8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bdb:	a3 34 50 80 00       	mov    %eax,0x805034
  803be0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803be5:	40                   	inc    %eax
  803be6:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803beb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bef:	75 17                	jne    803c08 <realloc_block_FF+0x692>
  803bf1:	83 ec 04             	sub    $0x4,%esp
  803bf4:	68 3f 48 80 00       	push   $0x80483f
  803bf9:	68 45 02 00 00       	push   $0x245
  803bfe:	68 5d 48 80 00       	push   $0x80485d
  803c03:	e8 8a c9 ff ff       	call   800592 <_panic>
  803c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0b:	8b 00                	mov    (%eax),%eax
  803c0d:	85 c0                	test   %eax,%eax
  803c0f:	74 10                	je     803c21 <realloc_block_FF+0x6ab>
  803c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c14:	8b 00                	mov    (%eax),%eax
  803c16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c19:	8b 52 04             	mov    0x4(%edx),%edx
  803c1c:	89 50 04             	mov    %edx,0x4(%eax)
  803c1f:	eb 0b                	jmp    803c2c <realloc_block_FF+0x6b6>
  803c21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c24:	8b 40 04             	mov    0x4(%eax),%eax
  803c27:	a3 34 50 80 00       	mov    %eax,0x805034
  803c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2f:	8b 40 04             	mov    0x4(%eax),%eax
  803c32:	85 c0                	test   %eax,%eax
  803c34:	74 0f                	je     803c45 <realloc_block_FF+0x6cf>
  803c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c39:	8b 40 04             	mov    0x4(%eax),%eax
  803c3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c3f:	8b 12                	mov    (%edx),%edx
  803c41:	89 10                	mov    %edx,(%eax)
  803c43:	eb 0a                	jmp    803c4f <realloc_block_FF+0x6d9>
  803c45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c48:	8b 00                	mov    (%eax),%eax
  803c4a:	a3 30 50 80 00       	mov    %eax,0x805030
  803c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c62:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c67:	48                   	dec    %eax
  803c68:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803c6d:	83 ec 04             	sub    $0x4,%esp
  803c70:	6a 00                	push   $0x0
  803c72:	ff 75 bc             	pushl  -0x44(%ebp)
  803c75:	ff 75 b8             	pushl  -0x48(%ebp)
  803c78:	e8 06 e9 ff ff       	call   802583 <set_block_data>
  803c7d:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803c80:	8b 45 08             	mov    0x8(%ebp),%eax
  803c83:	eb 0a                	jmp    803c8f <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803c85:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803c8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803c8f:	c9                   	leave  
  803c90:	c3                   	ret    

00803c91 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803c91:	55                   	push   %ebp
  803c92:	89 e5                	mov    %esp,%ebp
  803c94:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803c97:	83 ec 04             	sub    $0x4,%esp
  803c9a:	68 54 49 80 00       	push   $0x804954
  803c9f:	68 58 02 00 00       	push   $0x258
  803ca4:	68 5d 48 80 00       	push   $0x80485d
  803ca9:	e8 e4 c8 ff ff       	call   800592 <_panic>

00803cae <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803cae:	55                   	push   %ebp
  803caf:	89 e5                	mov    %esp,%ebp
  803cb1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803cb4:	83 ec 04             	sub    $0x4,%esp
  803cb7:	68 7c 49 80 00       	push   $0x80497c
  803cbc:	68 61 02 00 00       	push   $0x261
  803cc1:	68 5d 48 80 00       	push   $0x80485d
  803cc6:	e8 c7 c8 ff ff       	call   800592 <_panic>
  803ccb:	90                   	nop

00803ccc <__udivdi3>:
  803ccc:	55                   	push   %ebp
  803ccd:	57                   	push   %edi
  803cce:	56                   	push   %esi
  803ccf:	53                   	push   %ebx
  803cd0:	83 ec 1c             	sub    $0x1c,%esp
  803cd3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cd7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cdf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ce3:	89 ca                	mov    %ecx,%edx
  803ce5:	89 f8                	mov    %edi,%eax
  803ce7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ceb:	85 f6                	test   %esi,%esi
  803ced:	75 2d                	jne    803d1c <__udivdi3+0x50>
  803cef:	39 cf                	cmp    %ecx,%edi
  803cf1:	77 65                	ja     803d58 <__udivdi3+0x8c>
  803cf3:	89 fd                	mov    %edi,%ebp
  803cf5:	85 ff                	test   %edi,%edi
  803cf7:	75 0b                	jne    803d04 <__udivdi3+0x38>
  803cf9:	b8 01 00 00 00       	mov    $0x1,%eax
  803cfe:	31 d2                	xor    %edx,%edx
  803d00:	f7 f7                	div    %edi
  803d02:	89 c5                	mov    %eax,%ebp
  803d04:	31 d2                	xor    %edx,%edx
  803d06:	89 c8                	mov    %ecx,%eax
  803d08:	f7 f5                	div    %ebp
  803d0a:	89 c1                	mov    %eax,%ecx
  803d0c:	89 d8                	mov    %ebx,%eax
  803d0e:	f7 f5                	div    %ebp
  803d10:	89 cf                	mov    %ecx,%edi
  803d12:	89 fa                	mov    %edi,%edx
  803d14:	83 c4 1c             	add    $0x1c,%esp
  803d17:	5b                   	pop    %ebx
  803d18:	5e                   	pop    %esi
  803d19:	5f                   	pop    %edi
  803d1a:	5d                   	pop    %ebp
  803d1b:	c3                   	ret    
  803d1c:	39 ce                	cmp    %ecx,%esi
  803d1e:	77 28                	ja     803d48 <__udivdi3+0x7c>
  803d20:	0f bd fe             	bsr    %esi,%edi
  803d23:	83 f7 1f             	xor    $0x1f,%edi
  803d26:	75 40                	jne    803d68 <__udivdi3+0x9c>
  803d28:	39 ce                	cmp    %ecx,%esi
  803d2a:	72 0a                	jb     803d36 <__udivdi3+0x6a>
  803d2c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d30:	0f 87 9e 00 00 00    	ja     803dd4 <__udivdi3+0x108>
  803d36:	b8 01 00 00 00       	mov    $0x1,%eax
  803d3b:	89 fa                	mov    %edi,%edx
  803d3d:	83 c4 1c             	add    $0x1c,%esp
  803d40:	5b                   	pop    %ebx
  803d41:	5e                   	pop    %esi
  803d42:	5f                   	pop    %edi
  803d43:	5d                   	pop    %ebp
  803d44:	c3                   	ret    
  803d45:	8d 76 00             	lea    0x0(%esi),%esi
  803d48:	31 ff                	xor    %edi,%edi
  803d4a:	31 c0                	xor    %eax,%eax
  803d4c:	89 fa                	mov    %edi,%edx
  803d4e:	83 c4 1c             	add    $0x1c,%esp
  803d51:	5b                   	pop    %ebx
  803d52:	5e                   	pop    %esi
  803d53:	5f                   	pop    %edi
  803d54:	5d                   	pop    %ebp
  803d55:	c3                   	ret    
  803d56:	66 90                	xchg   %ax,%ax
  803d58:	89 d8                	mov    %ebx,%eax
  803d5a:	f7 f7                	div    %edi
  803d5c:	31 ff                	xor    %edi,%edi
  803d5e:	89 fa                	mov    %edi,%edx
  803d60:	83 c4 1c             	add    $0x1c,%esp
  803d63:	5b                   	pop    %ebx
  803d64:	5e                   	pop    %esi
  803d65:	5f                   	pop    %edi
  803d66:	5d                   	pop    %ebp
  803d67:	c3                   	ret    
  803d68:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d6d:	89 eb                	mov    %ebp,%ebx
  803d6f:	29 fb                	sub    %edi,%ebx
  803d71:	89 f9                	mov    %edi,%ecx
  803d73:	d3 e6                	shl    %cl,%esi
  803d75:	89 c5                	mov    %eax,%ebp
  803d77:	88 d9                	mov    %bl,%cl
  803d79:	d3 ed                	shr    %cl,%ebp
  803d7b:	89 e9                	mov    %ebp,%ecx
  803d7d:	09 f1                	or     %esi,%ecx
  803d7f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d83:	89 f9                	mov    %edi,%ecx
  803d85:	d3 e0                	shl    %cl,%eax
  803d87:	89 c5                	mov    %eax,%ebp
  803d89:	89 d6                	mov    %edx,%esi
  803d8b:	88 d9                	mov    %bl,%cl
  803d8d:	d3 ee                	shr    %cl,%esi
  803d8f:	89 f9                	mov    %edi,%ecx
  803d91:	d3 e2                	shl    %cl,%edx
  803d93:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d97:	88 d9                	mov    %bl,%cl
  803d99:	d3 e8                	shr    %cl,%eax
  803d9b:	09 c2                	or     %eax,%edx
  803d9d:	89 d0                	mov    %edx,%eax
  803d9f:	89 f2                	mov    %esi,%edx
  803da1:	f7 74 24 0c          	divl   0xc(%esp)
  803da5:	89 d6                	mov    %edx,%esi
  803da7:	89 c3                	mov    %eax,%ebx
  803da9:	f7 e5                	mul    %ebp
  803dab:	39 d6                	cmp    %edx,%esi
  803dad:	72 19                	jb     803dc8 <__udivdi3+0xfc>
  803daf:	74 0b                	je     803dbc <__udivdi3+0xf0>
  803db1:	89 d8                	mov    %ebx,%eax
  803db3:	31 ff                	xor    %edi,%edi
  803db5:	e9 58 ff ff ff       	jmp    803d12 <__udivdi3+0x46>
  803dba:	66 90                	xchg   %ax,%ax
  803dbc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803dc0:	89 f9                	mov    %edi,%ecx
  803dc2:	d3 e2                	shl    %cl,%edx
  803dc4:	39 c2                	cmp    %eax,%edx
  803dc6:	73 e9                	jae    803db1 <__udivdi3+0xe5>
  803dc8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803dcb:	31 ff                	xor    %edi,%edi
  803dcd:	e9 40 ff ff ff       	jmp    803d12 <__udivdi3+0x46>
  803dd2:	66 90                	xchg   %ax,%ax
  803dd4:	31 c0                	xor    %eax,%eax
  803dd6:	e9 37 ff ff ff       	jmp    803d12 <__udivdi3+0x46>
  803ddb:	90                   	nop

00803ddc <__umoddi3>:
  803ddc:	55                   	push   %ebp
  803ddd:	57                   	push   %edi
  803dde:	56                   	push   %esi
  803ddf:	53                   	push   %ebx
  803de0:	83 ec 1c             	sub    $0x1c,%esp
  803de3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803de7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803deb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803def:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803df3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803df7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dfb:	89 f3                	mov    %esi,%ebx
  803dfd:	89 fa                	mov    %edi,%edx
  803dff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e03:	89 34 24             	mov    %esi,(%esp)
  803e06:	85 c0                	test   %eax,%eax
  803e08:	75 1a                	jne    803e24 <__umoddi3+0x48>
  803e0a:	39 f7                	cmp    %esi,%edi
  803e0c:	0f 86 a2 00 00 00    	jbe    803eb4 <__umoddi3+0xd8>
  803e12:	89 c8                	mov    %ecx,%eax
  803e14:	89 f2                	mov    %esi,%edx
  803e16:	f7 f7                	div    %edi
  803e18:	89 d0                	mov    %edx,%eax
  803e1a:	31 d2                	xor    %edx,%edx
  803e1c:	83 c4 1c             	add    $0x1c,%esp
  803e1f:	5b                   	pop    %ebx
  803e20:	5e                   	pop    %esi
  803e21:	5f                   	pop    %edi
  803e22:	5d                   	pop    %ebp
  803e23:	c3                   	ret    
  803e24:	39 f0                	cmp    %esi,%eax
  803e26:	0f 87 ac 00 00 00    	ja     803ed8 <__umoddi3+0xfc>
  803e2c:	0f bd e8             	bsr    %eax,%ebp
  803e2f:	83 f5 1f             	xor    $0x1f,%ebp
  803e32:	0f 84 ac 00 00 00    	je     803ee4 <__umoddi3+0x108>
  803e38:	bf 20 00 00 00       	mov    $0x20,%edi
  803e3d:	29 ef                	sub    %ebp,%edi
  803e3f:	89 fe                	mov    %edi,%esi
  803e41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e45:	89 e9                	mov    %ebp,%ecx
  803e47:	d3 e0                	shl    %cl,%eax
  803e49:	89 d7                	mov    %edx,%edi
  803e4b:	89 f1                	mov    %esi,%ecx
  803e4d:	d3 ef                	shr    %cl,%edi
  803e4f:	09 c7                	or     %eax,%edi
  803e51:	89 e9                	mov    %ebp,%ecx
  803e53:	d3 e2                	shl    %cl,%edx
  803e55:	89 14 24             	mov    %edx,(%esp)
  803e58:	89 d8                	mov    %ebx,%eax
  803e5a:	d3 e0                	shl    %cl,%eax
  803e5c:	89 c2                	mov    %eax,%edx
  803e5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e62:	d3 e0                	shl    %cl,%eax
  803e64:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e68:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e6c:	89 f1                	mov    %esi,%ecx
  803e6e:	d3 e8                	shr    %cl,%eax
  803e70:	09 d0                	or     %edx,%eax
  803e72:	d3 eb                	shr    %cl,%ebx
  803e74:	89 da                	mov    %ebx,%edx
  803e76:	f7 f7                	div    %edi
  803e78:	89 d3                	mov    %edx,%ebx
  803e7a:	f7 24 24             	mull   (%esp)
  803e7d:	89 c6                	mov    %eax,%esi
  803e7f:	89 d1                	mov    %edx,%ecx
  803e81:	39 d3                	cmp    %edx,%ebx
  803e83:	0f 82 87 00 00 00    	jb     803f10 <__umoddi3+0x134>
  803e89:	0f 84 91 00 00 00    	je     803f20 <__umoddi3+0x144>
  803e8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e93:	29 f2                	sub    %esi,%edx
  803e95:	19 cb                	sbb    %ecx,%ebx
  803e97:	89 d8                	mov    %ebx,%eax
  803e99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e9d:	d3 e0                	shl    %cl,%eax
  803e9f:	89 e9                	mov    %ebp,%ecx
  803ea1:	d3 ea                	shr    %cl,%edx
  803ea3:	09 d0                	or     %edx,%eax
  803ea5:	89 e9                	mov    %ebp,%ecx
  803ea7:	d3 eb                	shr    %cl,%ebx
  803ea9:	89 da                	mov    %ebx,%edx
  803eab:	83 c4 1c             	add    $0x1c,%esp
  803eae:	5b                   	pop    %ebx
  803eaf:	5e                   	pop    %esi
  803eb0:	5f                   	pop    %edi
  803eb1:	5d                   	pop    %ebp
  803eb2:	c3                   	ret    
  803eb3:	90                   	nop
  803eb4:	89 fd                	mov    %edi,%ebp
  803eb6:	85 ff                	test   %edi,%edi
  803eb8:	75 0b                	jne    803ec5 <__umoddi3+0xe9>
  803eba:	b8 01 00 00 00       	mov    $0x1,%eax
  803ebf:	31 d2                	xor    %edx,%edx
  803ec1:	f7 f7                	div    %edi
  803ec3:	89 c5                	mov    %eax,%ebp
  803ec5:	89 f0                	mov    %esi,%eax
  803ec7:	31 d2                	xor    %edx,%edx
  803ec9:	f7 f5                	div    %ebp
  803ecb:	89 c8                	mov    %ecx,%eax
  803ecd:	f7 f5                	div    %ebp
  803ecf:	89 d0                	mov    %edx,%eax
  803ed1:	e9 44 ff ff ff       	jmp    803e1a <__umoddi3+0x3e>
  803ed6:	66 90                	xchg   %ax,%ax
  803ed8:	89 c8                	mov    %ecx,%eax
  803eda:	89 f2                	mov    %esi,%edx
  803edc:	83 c4 1c             	add    $0x1c,%esp
  803edf:	5b                   	pop    %ebx
  803ee0:	5e                   	pop    %esi
  803ee1:	5f                   	pop    %edi
  803ee2:	5d                   	pop    %ebp
  803ee3:	c3                   	ret    
  803ee4:	3b 04 24             	cmp    (%esp),%eax
  803ee7:	72 06                	jb     803eef <__umoddi3+0x113>
  803ee9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803eed:	77 0f                	ja     803efe <__umoddi3+0x122>
  803eef:	89 f2                	mov    %esi,%edx
  803ef1:	29 f9                	sub    %edi,%ecx
  803ef3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ef7:	89 14 24             	mov    %edx,(%esp)
  803efa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803efe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f02:	8b 14 24             	mov    (%esp),%edx
  803f05:	83 c4 1c             	add    $0x1c,%esp
  803f08:	5b                   	pop    %ebx
  803f09:	5e                   	pop    %esi
  803f0a:	5f                   	pop    %edi
  803f0b:	5d                   	pop    %ebp
  803f0c:	c3                   	ret    
  803f0d:	8d 76 00             	lea    0x0(%esi),%esi
  803f10:	2b 04 24             	sub    (%esp),%eax
  803f13:	19 fa                	sbb    %edi,%edx
  803f15:	89 d1                	mov    %edx,%ecx
  803f17:	89 c6                	mov    %eax,%esi
  803f19:	e9 71 ff ff ff       	jmp    803e8f <__umoddi3+0xb3>
  803f1e:	66 90                	xchg   %ax,%ax
  803f20:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f24:	72 ea                	jb     803f10 <__umoddi3+0x134>
  803f26:	89 d9                	mov    %ebx,%ecx
  803f28:	e9 62 ff ff ff       	jmp    803e8f <__umoddi3+0xb3>
