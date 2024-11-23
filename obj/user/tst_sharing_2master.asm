
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
  80005c:	68 e0 3d 80 00       	push   $0x803de0
  800061:	6a 14                	push   $0x14
  800063:	68 fc 3d 80 00       	push   $0x803dfc
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
  800082:	e8 4a 1b 00 00       	call   801bd1 <sys_calculate_free_frames>
  800087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = smalloc("x", 4, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 04                	push   $0x4
  800091:	68 17 3e 80 00       	push   $0x803e17
  800096:	e8 81 18 00 00       	call   80191c <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 1c 3e 80 00       	push   $0x803e1c
  8000b8:	e8 92 07 00 00       	call   80084f <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8000c0:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8000c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ca:	e8 02 1b 00 00       	call   801bd1 <sys_calculate_free_frames>
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
  8000f3:	e8 d9 1a 00 00       	call   801bd1 <sys_calculate_free_frames>
  8000f8:	29 c3                	sub    %eax,%ebx
  8000fa:	89 d8                	mov    %ebx,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800102:	50                   	push   %eax
  800103:	68 80 3e 80 00       	push   $0x803e80
  800108:	e8 42 07 00 00       	call   80084f <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800110:	e8 bc 1a 00 00       	call   801bd1 <sys_calculate_free_frames>
  800115:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = smalloc("y", 4, 0);
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	6a 00                	push   $0x0
  80011d:	6a 04                	push   $0x4
  80011f:	68 18 3f 80 00       	push   $0x803f18
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
  800146:	68 1c 3e 80 00       	push   $0x803e1c
  80014b:	e8 ff 06 00 00       	call   80084f <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  800153:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80015a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80015d:	e8 6f 1a 00 00       	call   801bd1 <sys_calculate_free_frames>
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
  800186:	e8 46 1a 00 00       	call   801bd1 <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	50                   	push   %eax
  800196:	68 80 3e 80 00       	push   $0x803e80
  80019b:	e8 af 06 00 00       	call   80084f <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  8001a3:	e8 29 1a 00 00       	call   801bd1 <sys_calculate_free_frames>
  8001a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = smalloc("z", 4, 1);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 01                	push   $0x1
  8001b0:	6a 04                	push   $0x4
  8001b2:	68 1a 3f 80 00       	push   $0x803f1a
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
  8001d9:	68 1c 3e 80 00       	push   $0x803e1c
  8001de:	e8 6c 06 00 00       	call   80084f <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8001e6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001f0:	e8 dc 19 00 00       	call   801bd1 <sys_calculate_free_frames>
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
  800219:	e8 b3 19 00 00       	call   801bd1 <sys_calculate_free_frames>
  80021e:	29 c3                	sub    %eax,%ebx
  800220:	89 d8                	mov    %ebx,%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	50                   	push   %eax
  800229:	68 80 3e 80 00       	push   $0x803e80
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
  80027f:	68 1c 3f 80 00       	push   $0x803f1c
  800284:	e8 a3 1a 00 00       	call   801d2c <sys_create_env>
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
  8002b5:	68 1c 3f 80 00       	push   $0x803f1c
  8002ba:	e8 6d 1a 00 00       	call   801d2c <sys_create_env>
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
  8002eb:	68 1c 3f 80 00       	push   $0x803f1c
  8002f0:	e8 37 1a 00 00       	call   801d2c <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8002fb:	e8 78 1b 00 00       	call   801e78 <rsttst>

	sys_run_env(id1);\
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 d0             	pushl  -0x30(%ebp)
  800306:	e8 3f 1a 00 00       	call   801d4a <sys_run_env>
  80030b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 cc             	pushl  -0x34(%ebp)
  800314:	e8 31 1a 00 00       	call   801d4a <sys_run_env>
  800319:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 c8             	pushl  -0x38(%ebp)
  800322:	e8 23 1a 00 00       	call   801d4a <sys_run_env>
  800327:	83 c4 10             	add    $0x10,%esp
	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  80032a:	90                   	nop
  80032b:	e8 c2 1b 00 00       	call   801ef2 <gettst>
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
  800349:	68 28 3f 80 00       	push   $0x803f28
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
  80036a:	68 74 3f 80 00       	push   $0x803f74
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
  80039d:	68 a6 3f 80 00       	push   $0x803fa6
  8003a2:	e8 85 19 00 00       	call   801d2c <sys_create_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b3:	e8 92 19 00 00       	call   801d4a <sys_run_env>
  8003b8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  8003bb:	90                   	nop
  8003bc:	e8 31 1b 00 00       	call   801ef2 <gettst>
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
  8003da:	68 28 3f 80 00       	push   $0x803f28
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
  8003f8:	e8 db 1a 00 00       	call   801ed8 <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8003fd:	90                   	nop
  8003fe:	e8 ef 1a 00 00       	call   801ef2 <gettst>
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
  80041c:	68 28 3f 80 00       	push   $0x803f28
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
  800440:	68 b4 3f 80 00       	push   $0x803fb4
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
  800459:	e8 3c 19 00 00       	call   801d9a <sys_getenvindex>
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
  8004c7:	e8 52 16 00 00       	call   801b1e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004cc:	83 ec 0c             	sub    $0xc,%esp
  8004cf:	68 10 40 80 00       	push   $0x804010
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
  8004f7:	68 38 40 80 00       	push   $0x804038
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
  800528:	68 60 40 80 00       	push   $0x804060
  80052d:	e8 1d 03 00 00       	call   80084f <cprintf>
  800532:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800535:	a1 20 50 80 00       	mov    0x805020,%eax
  80053a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	50                   	push   %eax
  800544:	68 b8 40 80 00       	push   $0x8040b8
  800549:	e8 01 03 00 00       	call   80084f <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 10 40 80 00       	push   $0x804010
  800559:	e8 f1 02 00 00       	call   80084f <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800561:	e8 d2 15 00 00       	call   801b38 <sys_unlock_cons>
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
  800579:	e8 e8 17 00 00       	call   801d66 <sys_destroy_env>
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
  80058a:	e8 3d 18 00 00       	call   801dcc <sys_exit_env>
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
  8005b3:	68 cc 40 80 00       	push   $0x8040cc
  8005b8:	e8 92 02 00 00       	call   80084f <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005c0:	a1 00 50 80 00       	mov    0x805000,%eax
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	50                   	push   %eax
  8005cc:	68 d1 40 80 00       	push   $0x8040d1
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
  8005f0:	68 ed 40 80 00       	push   $0x8040ed
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
  80061f:	68 f0 40 80 00       	push   $0x8040f0
  800624:	6a 26                	push   $0x26
  800626:	68 3c 41 80 00       	push   $0x80413c
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
  8006f4:	68 48 41 80 00       	push   $0x804148
  8006f9:	6a 3a                	push   $0x3a
  8006fb:	68 3c 41 80 00       	push   $0x80413c
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
  800767:	68 9c 41 80 00       	push   $0x80419c
  80076c:	6a 44                	push   $0x44
  80076e:	68 3c 41 80 00       	push   $0x80413c
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
  8007c1:	e8 16 13 00 00       	call   801adc <sys_cputs>
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
  800838:	e8 9f 12 00 00       	call   801adc <sys_cputs>
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
  800882:	e8 97 12 00 00       	call   801b1e <sys_lock_cons>
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
  8008a2:	e8 91 12 00 00       	call   801b38 <sys_unlock_cons>
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
  8008ec:	e8 83 32 00 00       	call   803b74 <__udivdi3>
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
  80093c:	e8 43 33 00 00       	call   803c84 <__umoddi3>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	05 14 44 80 00       	add    $0x804414,%eax
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
  800a97:	8b 04 85 38 44 80 00 	mov    0x804438(,%eax,4),%eax
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
  800b78:	8b 34 9d 80 42 80 00 	mov    0x804280(,%ebx,4),%esi
  800b7f:	85 f6                	test   %esi,%esi
  800b81:	75 19                	jne    800b9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b83:	53                   	push   %ebx
  800b84:	68 25 44 80 00       	push   $0x804425
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
  800b9d:	68 2e 44 80 00       	push   $0x80442e
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
  800bca:	be 31 44 80 00       	mov    $0x804431,%esi
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
  8015d5:	68 a8 45 80 00       	push   $0x8045a8
  8015da:	68 3f 01 00 00       	push   $0x13f
  8015df:	68 ca 45 80 00       	push   $0x8045ca
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
  8015f5:	e8 8d 0a 00 00       	call   802087 <sys_sbrk>
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
  801670:	e8 96 08 00 00       	call   801f0b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801675:	85 c0                	test   %eax,%eax
  801677:	74 16                	je     80168f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	e8 d6 0d 00 00       	call   80245a <alloc_block_FF>
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168a:	e9 8a 01 00 00       	jmp    801819 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80168f:	e8 a8 08 00 00       	call   801f3c <sys_isUHeapPlacementStrategyBESTFIT>
  801694:	85 c0                	test   %eax,%eax
  801696:	0f 84 7d 01 00 00    	je     801819 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	e8 6f 12 00 00       	call   802916 <alloc_block_BF>
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
  801808:	e8 b1 08 00 00       	call   8020be <sys_allocate_user_mem>
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
  801850:	e8 85 08 00 00       	call   8020da <get_block_size>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 b8 1a 00 00       	call   80331e <free_block>
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
  8018f8:	e8 a5 07 00 00       	call   8020a2 <sys_free_user_mem>
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
  801906:	68 d8 45 80 00       	push   $0x8045d8
  80190b:	68 84 00 00 00       	push   $0x84
  801910:	68 02 46 80 00       	push   $0x804602
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
  801933:	eb 64                	jmp    801999 <smalloc+0x7d>
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
  801968:	eb 2f                	jmp    801999 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80196a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80196e:	ff 75 ec             	pushl  -0x14(%ebp)
  801971:	50                   	push   %eax
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	e8 2c 03 00 00       	call   801ca9 <sys_createSharedObject>
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801983:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801987:	74 06                	je     80198f <smalloc+0x73>
  801989:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80198d:	75 07                	jne    801996 <smalloc+0x7a>
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
  801994:	eb 03                	jmp    801999 <smalloc+0x7d>
	 return ptr;
  801996:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8019a1:	83 ec 08             	sub    $0x8,%esp
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	e8 24 03 00 00       	call   801cd3 <sys_getSizeOfSharedObject>
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8019b5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019b9:	75 07                	jne    8019c2 <sget+0x27>
  8019bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c0:	eb 5c                	jmp    801a1e <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8019c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019c8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d5:	39 d0                	cmp    %edx,%eax
  8019d7:	7d 02                	jge    8019db <sget+0x40>
  8019d9:	89 d0                	mov    %edx,%eax
  8019db:	83 ec 0c             	sub    $0xc,%esp
  8019de:	50                   	push   %eax
  8019df:	e8 1b fc ff ff       	call   8015ff <malloc>
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8019ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019ee:	75 07                	jne    8019f7 <sget+0x5c>
  8019f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f5:	eb 27                	jmp    801a1e <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	ff 75 08             	pushl  0x8(%ebp)
  801a03:	e8 e8 02 00 00       	call   801cf0 <sys_getSharedObject>
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801a0e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a12:	75 07                	jne    801a1b <sget+0x80>
  801a14:	b8 00 00 00 00       	mov    $0x0,%eax
  801a19:	eb 03                	jmp    801a1e <sget+0x83>
	return ptr;
  801a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a26:	83 ec 04             	sub    $0x4,%esp
  801a29:	68 10 46 80 00       	push   $0x804610
  801a2e:	68 c1 00 00 00       	push   $0xc1
  801a33:	68 02 46 80 00       	push   $0x804602
  801a38:	e8 55 eb ff ff       	call   800592 <_panic>

00801a3d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a43:	83 ec 04             	sub    $0x4,%esp
  801a46:	68 34 46 80 00       	push   $0x804634
  801a4b:	68 d8 00 00 00       	push   $0xd8
  801a50:	68 02 46 80 00       	push   $0x804602
  801a55:	e8 38 eb ff ff       	call   800592 <_panic>

00801a5a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a60:	83 ec 04             	sub    $0x4,%esp
  801a63:	68 5a 46 80 00       	push   $0x80465a
  801a68:	68 e4 00 00 00       	push   $0xe4
  801a6d:	68 02 46 80 00       	push   $0x804602
  801a72:	e8 1b eb ff ff       	call   800592 <_panic>

00801a77 <shrink>:

}
void shrink(uint32 newSize)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a7d:	83 ec 04             	sub    $0x4,%esp
  801a80:	68 5a 46 80 00       	push   $0x80465a
  801a85:	68 e9 00 00 00       	push   $0xe9
  801a8a:	68 02 46 80 00       	push   $0x804602
  801a8f:	e8 fe ea ff ff       	call   800592 <_panic>

00801a94 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	68 5a 46 80 00       	push   $0x80465a
  801aa2:	68 ee 00 00 00       	push   $0xee
  801aa7:	68 02 46 80 00       	push   $0x804602
  801aac:	e8 e1 ea ff ff       	call   800592 <_panic>

00801ab1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	57                   	push   %edi
  801ab5:	56                   	push   %esi
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac6:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ac9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801acc:	cd 30                	int    $0x30
  801ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5f                   	pop    %edi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    

00801adc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ae8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	52                   	push   %edx
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	50                   	push   %eax
  801af8:	6a 00                	push   $0x0
  801afa:	e8 b2 ff ff ff       	call   801ab1 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	90                   	nop
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 02                	push   $0x2
  801b14:	e8 98 ff ff ff       	call   801ab1 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 03                	push   $0x3
  801b2d:	e8 7f ff ff ff       	call   801ab1 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	90                   	nop
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 04                	push   $0x4
  801b47:	e8 65 ff ff ff       	call   801ab1 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 08                	push   $0x8
  801b65:	e8 47 ff ff ff       	call   801ab1 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	56                   	push   %esi
  801b73:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b74:	8b 75 18             	mov    0x18(%ebp),%esi
  801b77:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	56                   	push   %esi
  801b84:	53                   	push   %ebx
  801b85:	51                   	push   %ecx
  801b86:	52                   	push   %edx
  801b87:	50                   	push   %eax
  801b88:	6a 09                	push   $0x9
  801b8a:	e8 22 ff ff ff       	call   801ab1 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b95:	5b                   	pop    %ebx
  801b96:	5e                   	pop    %esi
  801b97:	5d                   	pop    %ebp
  801b98:	c3                   	ret    

00801b99 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	52                   	push   %edx
  801ba9:	50                   	push   %eax
  801baa:	6a 0a                	push   $0xa
  801bac:	e8 00 ff ff ff       	call   801ab1 <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	ff 75 08             	pushl  0x8(%ebp)
  801bc5:	6a 0b                	push   $0xb
  801bc7:	e8 e5 fe ff ff       	call   801ab1 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 0c                	push   $0xc
  801be0:	e8 cc fe ff ff       	call   801ab1 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 0d                	push   $0xd
  801bf9:	e8 b3 fe ff ff       	call   801ab1 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 0e                	push   $0xe
  801c12:	e8 9a fe ff ff       	call   801ab1 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 0f                	push   $0xf
  801c2b:	e8 81 fe ff ff       	call   801ab1 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	ff 75 08             	pushl  0x8(%ebp)
  801c43:	6a 10                	push   $0x10
  801c45:	e8 67 fe ff ff       	call   801ab1 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 11                	push   $0x11
  801c5e:	e8 4e fe ff ff       	call   801ab1 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	90                   	nop
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c75:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	50                   	push   %eax
  801c82:	6a 01                	push   $0x1
  801c84:	e8 28 fe ff ff       	call   801ab1 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	90                   	nop
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 14                	push   $0x14
  801c9e:	e8 0e fe ff ff       	call   801ab1 <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	90                   	nop
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 04             	sub    $0x4,%esp
  801caf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cb5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cb8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	6a 00                	push   $0x0
  801cc1:	51                   	push   %ecx
  801cc2:	52                   	push   %edx
  801cc3:	ff 75 0c             	pushl  0xc(%ebp)
  801cc6:	50                   	push   %eax
  801cc7:	6a 15                	push   $0x15
  801cc9:	e8 e3 fd ff ff       	call   801ab1 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	52                   	push   %edx
  801ce3:	50                   	push   %eax
  801ce4:	6a 16                	push   $0x16
  801ce6:	e8 c6 fd ff ff       	call   801ab1 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cf3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	51                   	push   %ecx
  801d01:	52                   	push   %edx
  801d02:	50                   	push   %eax
  801d03:	6a 17                	push   $0x17
  801d05:	e8 a7 fd ff ff       	call   801ab1 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	52                   	push   %edx
  801d1f:	50                   	push   %eax
  801d20:	6a 18                	push   $0x18
  801d22:	e8 8a fd ff ff       	call   801ab1 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	6a 00                	push   $0x0
  801d34:	ff 75 14             	pushl  0x14(%ebp)
  801d37:	ff 75 10             	pushl  0x10(%ebp)
  801d3a:	ff 75 0c             	pushl  0xc(%ebp)
  801d3d:	50                   	push   %eax
  801d3e:	6a 19                	push   $0x19
  801d40:	e8 6c fd ff ff       	call   801ab1 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	50                   	push   %eax
  801d59:	6a 1a                	push   $0x1a
  801d5b:	e8 51 fd ff ff       	call   801ab1 <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
}
  801d63:	90                   	nop
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	50                   	push   %eax
  801d75:	6a 1b                	push   $0x1b
  801d77:	e8 35 fd ff ff       	call   801ab1 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 05                	push   $0x5
  801d90:	e8 1c fd ff ff       	call   801ab1 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 06                	push   $0x6
  801da9:	e8 03 fd ff ff       	call   801ab1 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 07                	push   $0x7
  801dc2:	e8 ea fc ff ff       	call   801ab1 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_exit_env>:


void sys_exit_env(void)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 1c                	push   $0x1c
  801ddb:	e8 d1 fc ff ff       	call   801ab1 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	90                   	nop
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801def:	8d 50 04             	lea    0x4(%eax),%edx
  801df2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	52                   	push   %edx
  801dfc:	50                   	push   %eax
  801dfd:	6a 1d                	push   $0x1d
  801dff:	e8 ad fc ff ff       	call   801ab1 <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
	return result;
  801e07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e10:	89 01                	mov    %eax,(%ecx)
  801e12:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e15:	8b 45 08             	mov    0x8(%ebp),%eax
  801e18:	c9                   	leave  
  801e19:	c2 04 00             	ret    $0x4

00801e1c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	ff 75 10             	pushl  0x10(%ebp)
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	ff 75 08             	pushl  0x8(%ebp)
  801e2c:	6a 13                	push   $0x13
  801e2e:	e8 7e fc ff ff       	call   801ab1 <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
	return ;
  801e36:	90                   	nop
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 1e                	push   $0x1e
  801e48:	e8 64 fc ff ff       	call   801ab1 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 04             	sub    $0x4,%esp
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e5e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	50                   	push   %eax
  801e6b:	6a 1f                	push   $0x1f
  801e6d:	e8 3f fc ff ff       	call   801ab1 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
	return ;
  801e75:	90                   	nop
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <rsttst>:
void rsttst()
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 21                	push   $0x21
  801e87:	e8 25 fc ff ff       	call   801ab1 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8f:	90                   	nop
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 04             	sub    $0x4,%esp
  801e98:	8b 45 14             	mov    0x14(%ebp),%eax
  801e9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e9e:	8b 55 18             	mov    0x18(%ebp),%edx
  801ea1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ea5:	52                   	push   %edx
  801ea6:	50                   	push   %eax
  801ea7:	ff 75 10             	pushl  0x10(%ebp)
  801eaa:	ff 75 0c             	pushl  0xc(%ebp)
  801ead:	ff 75 08             	pushl  0x8(%ebp)
  801eb0:	6a 20                	push   $0x20
  801eb2:	e8 fa fb ff ff       	call   801ab1 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eba:	90                   	nop
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <chktst>:
void chktst(uint32 n)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	ff 75 08             	pushl  0x8(%ebp)
  801ecb:	6a 22                	push   $0x22
  801ecd:	e8 df fb ff ff       	call   801ab1 <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed5:	90                   	nop
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <inctst>:

void inctst()
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 23                	push   $0x23
  801ee7:	e8 c5 fb ff ff       	call   801ab1 <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
	return ;
  801eef:	90                   	nop
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <gettst>:
uint32 gettst()
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 24                	push   $0x24
  801f01:	e8 ab fb ff ff       	call   801ab1 <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 25                	push   $0x25
  801f1d:	e8 8f fb ff ff       	call   801ab1 <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
  801f25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f28:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f2c:	75 07                	jne    801f35 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f33:	eb 05                	jmp    801f3a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 25                	push   $0x25
  801f4e:	e8 5e fb ff ff       	call   801ab1 <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
  801f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f59:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f5d:	75 07                	jne    801f66 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f64:	eb 05                	jmp    801f6b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 25                	push   $0x25
  801f7f:	e8 2d fb ff ff       	call   801ab1 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
  801f87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f8a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f8e:	75 07                	jne    801f97 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f90:	b8 01 00 00 00       	mov    $0x1,%eax
  801f95:	eb 05                	jmp    801f9c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 25                	push   $0x25
  801fb0:	e8 fc fa ff ff       	call   801ab1 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
  801fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fbb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fbf:	75 07                	jne    801fc8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc6:	eb 05                	jmp    801fcd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	ff 75 08             	pushl  0x8(%ebp)
  801fdd:	6a 26                	push   $0x26
  801fdf:	e8 cd fa ff ff       	call   801ab1 <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe7:	90                   	nop
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ff1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ff4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	6a 00                	push   $0x0
  801ffc:	53                   	push   %ebx
  801ffd:	51                   	push   %ecx
  801ffe:	52                   	push   %edx
  801fff:	50                   	push   %eax
  802000:	6a 27                	push   $0x27
  802002:	e8 aa fa ff ff       	call   801ab1 <syscall>
  802007:	83 c4 18             	add    $0x18,%esp
}
  80200a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802012:	8b 55 0c             	mov    0xc(%ebp),%edx
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	52                   	push   %edx
  80201f:	50                   	push   %eax
  802020:	6a 28                	push   $0x28
  802022:	e8 8a fa ff ff       	call   801ab1 <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80202f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802032:	8b 55 0c             	mov    0xc(%ebp),%edx
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	6a 00                	push   $0x0
  80203a:	51                   	push   %ecx
  80203b:	ff 75 10             	pushl  0x10(%ebp)
  80203e:	52                   	push   %edx
  80203f:	50                   	push   %eax
  802040:	6a 29                	push   $0x29
  802042:	e8 6a fa ff ff       	call   801ab1 <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	ff 75 10             	pushl  0x10(%ebp)
  802056:	ff 75 0c             	pushl  0xc(%ebp)
  802059:	ff 75 08             	pushl  0x8(%ebp)
  80205c:	6a 12                	push   $0x12
  80205e:	e8 4e fa ff ff       	call   801ab1 <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
	return ;
  802066:	90                   	nop
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80206c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	52                   	push   %edx
  802079:	50                   	push   %eax
  80207a:	6a 2a                	push   $0x2a
  80207c:	e8 30 fa ff ff       	call   801ab1 <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
	return;
  802084:	90                   	nop
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	50                   	push   %eax
  802096:	6a 2b                	push   $0x2b
  802098:	e8 14 fa ff ff       	call   801ab1 <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	ff 75 0c             	pushl  0xc(%ebp)
  8020ae:	ff 75 08             	pushl  0x8(%ebp)
  8020b1:	6a 2c                	push   $0x2c
  8020b3:	e8 f9 f9 ff ff       	call   801ab1 <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
	return;
  8020bb:	90                   	nop
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ca:	ff 75 08             	pushl  0x8(%ebp)
  8020cd:	6a 2d                	push   $0x2d
  8020cf:	e8 dd f9 ff ff       	call   801ab1 <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
	return;
  8020d7:	90                   	nop
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	83 e8 04             	sub    $0x4,%eax
  8020e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ec:	8b 00                	mov    (%eax),%eax
  8020ee:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	83 e8 04             	sub    $0x4,%eax
  8020ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	83 e0 01             	and    $0x1,%eax
  80210a:	85 c0                	test   %eax,%eax
  80210c:	0f 94 c0             	sete   %al
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80211e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802121:	83 f8 02             	cmp    $0x2,%eax
  802124:	74 2b                	je     802151 <alloc_block+0x40>
  802126:	83 f8 02             	cmp    $0x2,%eax
  802129:	7f 07                	jg     802132 <alloc_block+0x21>
  80212b:	83 f8 01             	cmp    $0x1,%eax
  80212e:	74 0e                	je     80213e <alloc_block+0x2d>
  802130:	eb 58                	jmp    80218a <alloc_block+0x79>
  802132:	83 f8 03             	cmp    $0x3,%eax
  802135:	74 2d                	je     802164 <alloc_block+0x53>
  802137:	83 f8 04             	cmp    $0x4,%eax
  80213a:	74 3b                	je     802177 <alloc_block+0x66>
  80213c:	eb 4c                	jmp    80218a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	ff 75 08             	pushl  0x8(%ebp)
  802144:	e8 11 03 00 00       	call   80245a <alloc_block_FF>
  802149:	83 c4 10             	add    $0x10,%esp
  80214c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80214f:	eb 4a                	jmp    80219b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802151:	83 ec 0c             	sub    $0xc,%esp
  802154:	ff 75 08             	pushl  0x8(%ebp)
  802157:	e8 fa 19 00 00       	call   803b56 <alloc_block_NF>
  80215c:	83 c4 10             	add    $0x10,%esp
  80215f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802162:	eb 37                	jmp    80219b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802164:	83 ec 0c             	sub    $0xc,%esp
  802167:	ff 75 08             	pushl  0x8(%ebp)
  80216a:	e8 a7 07 00 00       	call   802916 <alloc_block_BF>
  80216f:	83 c4 10             	add    $0x10,%esp
  802172:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802175:	eb 24                	jmp    80219b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802177:	83 ec 0c             	sub    $0xc,%esp
  80217a:	ff 75 08             	pushl  0x8(%ebp)
  80217d:	e8 b7 19 00 00       	call   803b39 <alloc_block_WF>
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802188:	eb 11                	jmp    80219b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80218a:	83 ec 0c             	sub    $0xc,%esp
  80218d:	68 6c 46 80 00       	push   $0x80466c
  802192:	e8 b8 e6 ff ff       	call   80084f <cprintf>
  802197:	83 c4 10             	add    $0x10,%esp
		break;
  80219a:	90                   	nop
	}
	return va;
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	53                   	push   %ebx
  8021a4:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021a7:	83 ec 0c             	sub    $0xc,%esp
  8021aa:	68 8c 46 80 00       	push   $0x80468c
  8021af:	e8 9b e6 ff ff       	call   80084f <cprintf>
  8021b4:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021b7:	83 ec 0c             	sub    $0xc,%esp
  8021ba:	68 b7 46 80 00       	push   $0x8046b7
  8021bf:	e8 8b e6 ff ff       	call   80084f <cprintf>
  8021c4:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021cd:	eb 37                	jmp    802206 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021cf:	83 ec 0c             	sub    $0xc,%esp
  8021d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d5:	e8 19 ff ff ff       	call   8020f3 <is_free_block>
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	0f be d8             	movsbl %al,%ebx
  8021e0:	83 ec 0c             	sub    $0xc,%esp
  8021e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e6:	e8 ef fe ff ff       	call   8020da <get_block_size>
  8021eb:	83 c4 10             	add    $0x10,%esp
  8021ee:	83 ec 04             	sub    $0x4,%esp
  8021f1:	53                   	push   %ebx
  8021f2:	50                   	push   %eax
  8021f3:	68 cf 46 80 00       	push   $0x8046cf
  8021f8:	e8 52 e6 ff ff       	call   80084f <cprintf>
  8021fd:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802200:	8b 45 10             	mov    0x10(%ebp),%eax
  802203:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220a:	74 07                	je     802213 <print_blocks_list+0x73>
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	8b 00                	mov    (%eax),%eax
  802211:	eb 05                	jmp    802218 <print_blocks_list+0x78>
  802213:	b8 00 00 00 00       	mov    $0x0,%eax
  802218:	89 45 10             	mov    %eax,0x10(%ebp)
  80221b:	8b 45 10             	mov    0x10(%ebp),%eax
  80221e:	85 c0                	test   %eax,%eax
  802220:	75 ad                	jne    8021cf <print_blocks_list+0x2f>
  802222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802226:	75 a7                	jne    8021cf <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802228:	83 ec 0c             	sub    $0xc,%esp
  80222b:	68 8c 46 80 00       	push   $0x80468c
  802230:	e8 1a e6 ff ff       	call   80084f <cprintf>
  802235:	83 c4 10             	add    $0x10,%esp

}
  802238:	90                   	nop
  802239:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802244:	8b 45 0c             	mov    0xc(%ebp),%eax
  802247:	83 e0 01             	and    $0x1,%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	74 03                	je     802251 <initialize_dynamic_allocator+0x13>
  80224e:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802251:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802255:	0f 84 c7 01 00 00    	je     802422 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80225b:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802262:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802265:	8b 55 08             	mov    0x8(%ebp),%edx
  802268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226b:	01 d0                	add    %edx,%eax
  80226d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802272:	0f 87 ad 01 00 00    	ja     802425 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	85 c0                	test   %eax,%eax
  80227d:	0f 89 a5 01 00 00    	jns    802428 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802283:	8b 55 08             	mov    0x8(%ebp),%edx
  802286:	8b 45 0c             	mov    0xc(%ebp),%eax
  802289:	01 d0                	add    %edx,%eax
  80228b:	83 e8 04             	sub    $0x4,%eax
  80228e:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802293:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80229a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80229f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a2:	e9 87 00 00 00       	jmp    80232e <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ab:	75 14                	jne    8022c1 <initialize_dynamic_allocator+0x83>
  8022ad:	83 ec 04             	sub    $0x4,%esp
  8022b0:	68 e7 46 80 00       	push   $0x8046e7
  8022b5:	6a 79                	push   $0x79
  8022b7:	68 05 47 80 00       	push   $0x804705
  8022bc:	e8 d1 e2 ff ff       	call   800592 <_panic>
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 00                	mov    (%eax),%eax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	74 10                	je     8022da <initialize_dynamic_allocator+0x9c>
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d2:	8b 52 04             	mov    0x4(%edx),%edx
  8022d5:	89 50 04             	mov    %edx,0x4(%eax)
  8022d8:	eb 0b                	jmp    8022e5 <initialize_dynamic_allocator+0xa7>
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	8b 40 04             	mov    0x4(%eax),%eax
  8022e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e8:	8b 40 04             	mov    0x4(%eax),%eax
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	74 0f                	je     8022fe <initialize_dynamic_allocator+0xc0>
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	8b 40 04             	mov    0x4(%eax),%eax
  8022f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f8:	8b 12                	mov    (%edx),%edx
  8022fa:	89 10                	mov    %edx,(%eax)
  8022fc:	eb 0a                	jmp    802308 <initialize_dynamic_allocator+0xca>
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	8b 00                	mov    (%eax),%eax
  802303:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80231b:	a1 38 50 80 00       	mov    0x805038,%eax
  802320:	48                   	dec    %eax
  802321:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802326:	a1 34 50 80 00       	mov    0x805034,%eax
  80232b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802332:	74 07                	je     80233b <initialize_dynamic_allocator+0xfd>
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	8b 00                	mov    (%eax),%eax
  802339:	eb 05                	jmp    802340 <initialize_dynamic_allocator+0x102>
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
  802340:	a3 34 50 80 00       	mov    %eax,0x805034
  802345:	a1 34 50 80 00       	mov    0x805034,%eax
  80234a:	85 c0                	test   %eax,%eax
  80234c:	0f 85 55 ff ff ff    	jne    8022a7 <initialize_dynamic_allocator+0x69>
  802352:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802356:	0f 85 4b ff ff ff    	jne    8022a7 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802365:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80236b:	a1 44 50 80 00       	mov    0x805044,%eax
  802370:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802375:	a1 40 50 80 00       	mov    0x805040,%eax
  80237a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	83 c0 08             	add    $0x8,%eax
  802386:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	83 c0 04             	add    $0x4,%eax
  80238f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802392:	83 ea 08             	sub    $0x8,%edx
  802395:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	01 d0                	add    %edx,%eax
  80239f:	83 e8 08             	sub    $0x8,%eax
  8023a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a5:	83 ea 08             	sub    $0x8,%edx
  8023a8:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8023aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023c1:	75 17                	jne    8023da <initialize_dynamic_allocator+0x19c>
  8023c3:	83 ec 04             	sub    $0x4,%esp
  8023c6:	68 20 47 80 00       	push   $0x804720
  8023cb:	68 90 00 00 00       	push   $0x90
  8023d0:	68 05 47 80 00       	push   $0x804705
  8023d5:	e8 b8 e1 ff ff       	call   800592 <_panic>
  8023da:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e3:	89 10                	mov    %edx,(%eax)
  8023e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 0d                	je     8023fb <initialize_dynamic_allocator+0x1bd>
  8023ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023f6:	89 50 04             	mov    %edx,0x4(%eax)
  8023f9:	eb 08                	jmp    802403 <initialize_dynamic_allocator+0x1c5>
  8023fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fe:	a3 30 50 80 00       	mov    %eax,0x805030
  802403:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802406:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80240b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802415:	a1 38 50 80 00       	mov    0x805038,%eax
  80241a:	40                   	inc    %eax
  80241b:	a3 38 50 80 00       	mov    %eax,0x805038
  802420:	eb 07                	jmp    802429 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802422:	90                   	nop
  802423:	eb 04                	jmp    802429 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802425:	90                   	nop
  802426:	eb 01                	jmp    802429 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802428:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80242e:	8b 45 10             	mov    0x10(%ebp),%eax
  802431:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	8d 50 fc             	lea    -0x4(%eax),%edx
  80243a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243d:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	83 e8 04             	sub    $0x4,%eax
  802445:	8b 00                	mov    (%eax),%eax
  802447:	83 e0 fe             	and    $0xfffffffe,%eax
  80244a:	8d 50 f8             	lea    -0x8(%eax),%edx
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	01 c2                	add    %eax,%edx
  802452:	8b 45 0c             	mov    0xc(%ebp),%eax
  802455:	89 02                	mov    %eax,(%edx)
}
  802457:	90                   	nop
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    

0080245a <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802460:	8b 45 08             	mov    0x8(%ebp),%eax
  802463:	83 e0 01             	and    $0x1,%eax
  802466:	85 c0                	test   %eax,%eax
  802468:	74 03                	je     80246d <alloc_block_FF+0x13>
  80246a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80246d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802471:	77 07                	ja     80247a <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802473:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80247a:	a1 24 50 80 00       	mov    0x805024,%eax
  80247f:	85 c0                	test   %eax,%eax
  802481:	75 73                	jne    8024f6 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	83 c0 10             	add    $0x10,%eax
  802489:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80248c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802493:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802496:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802499:	01 d0                	add    %edx,%eax
  80249b:	48                   	dec    %eax
  80249c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80249f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a7:	f7 75 ec             	divl   -0x14(%ebp)
  8024aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ad:	29 d0                	sub    %edx,%eax
  8024af:	c1 e8 0c             	shr    $0xc,%eax
  8024b2:	83 ec 0c             	sub    $0xc,%esp
  8024b5:	50                   	push   %eax
  8024b6:	e8 2e f1 ff ff       	call   8015e9 <sbrk>
  8024bb:	83 c4 10             	add    $0x10,%esp
  8024be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024c1:	83 ec 0c             	sub    $0xc,%esp
  8024c4:	6a 00                	push   $0x0
  8024c6:	e8 1e f1 ff ff       	call   8015e9 <sbrk>
  8024cb:	83 c4 10             	add    $0x10,%esp
  8024ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024d7:	83 ec 08             	sub    $0x8,%esp
  8024da:	50                   	push   %eax
  8024db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024de:	e8 5b fd ff ff       	call   80223e <initialize_dynamic_allocator>
  8024e3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024e6:	83 ec 0c             	sub    $0xc,%esp
  8024e9:	68 43 47 80 00       	push   $0x804743
  8024ee:	e8 5c e3 ff ff       	call   80084f <cprintf>
  8024f3:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8024f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024fa:	75 0a                	jne    802506 <alloc_block_FF+0xac>
	        return NULL;
  8024fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802501:	e9 0e 04 00 00       	jmp    802914 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802506:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80250d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802515:	e9 f3 02 00 00       	jmp    80280d <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802520:	83 ec 0c             	sub    $0xc,%esp
  802523:	ff 75 bc             	pushl  -0x44(%ebp)
  802526:	e8 af fb ff ff       	call   8020da <get_block_size>
  80252b:	83 c4 10             	add    $0x10,%esp
  80252e:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	83 c0 08             	add    $0x8,%eax
  802537:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80253a:	0f 87 c5 02 00 00    	ja     802805 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	83 c0 18             	add    $0x18,%eax
  802546:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802549:	0f 87 19 02 00 00    	ja     802768 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80254f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802552:	2b 45 08             	sub    0x8(%ebp),%eax
  802555:	83 e8 08             	sub    $0x8,%eax
  802558:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	8d 50 08             	lea    0x8(%eax),%edx
  802561:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802564:	01 d0                	add    %edx,%eax
  802566:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802569:	8b 45 08             	mov    0x8(%ebp),%eax
  80256c:	83 c0 08             	add    $0x8,%eax
  80256f:	83 ec 04             	sub    $0x4,%esp
  802572:	6a 01                	push   $0x1
  802574:	50                   	push   %eax
  802575:	ff 75 bc             	pushl  -0x44(%ebp)
  802578:	e8 ae fe ff ff       	call   80242b <set_block_data>
  80257d:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 04             	mov    0x4(%eax),%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	75 68                	jne    8025f2 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80258a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80258e:	75 17                	jne    8025a7 <alloc_block_FF+0x14d>
  802590:	83 ec 04             	sub    $0x4,%esp
  802593:	68 20 47 80 00       	push   $0x804720
  802598:	68 d7 00 00 00       	push   $0xd7
  80259d:	68 05 47 80 00       	push   $0x804705
  8025a2:	e8 eb df ff ff       	call   800592 <_panic>
  8025a7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b0:	89 10                	mov    %edx,(%eax)
  8025b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b5:	8b 00                	mov    (%eax),%eax
  8025b7:	85 c0                	test   %eax,%eax
  8025b9:	74 0d                	je     8025c8 <alloc_block_FF+0x16e>
  8025bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025c0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025c3:	89 50 04             	mov    %edx,0x4(%eax)
  8025c6:	eb 08                	jmp    8025d0 <alloc_block_FF+0x176>
  8025c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8025d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8025e7:	40                   	inc    %eax
  8025e8:	a3 38 50 80 00       	mov    %eax,0x805038
  8025ed:	e9 dc 00 00 00       	jmp    8026ce <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 00                	mov    (%eax),%eax
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	75 65                	jne    802660 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025fb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025ff:	75 17                	jne    802618 <alloc_block_FF+0x1be>
  802601:	83 ec 04             	sub    $0x4,%esp
  802604:	68 54 47 80 00       	push   $0x804754
  802609:	68 db 00 00 00       	push   $0xdb
  80260e:	68 05 47 80 00       	push   $0x804705
  802613:	e8 7a df ff ff       	call   800592 <_panic>
  802618:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80261e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802621:	89 50 04             	mov    %edx,0x4(%eax)
  802624:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802627:	8b 40 04             	mov    0x4(%eax),%eax
  80262a:	85 c0                	test   %eax,%eax
  80262c:	74 0c                	je     80263a <alloc_block_FF+0x1e0>
  80262e:	a1 30 50 80 00       	mov    0x805030,%eax
  802633:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802636:	89 10                	mov    %edx,(%eax)
  802638:	eb 08                	jmp    802642 <alloc_block_FF+0x1e8>
  80263a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80263d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802642:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802645:	a3 30 50 80 00       	mov    %eax,0x805030
  80264a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80264d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802653:	a1 38 50 80 00       	mov    0x805038,%eax
  802658:	40                   	inc    %eax
  802659:	a3 38 50 80 00       	mov    %eax,0x805038
  80265e:	eb 6e                	jmp    8026ce <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802664:	74 06                	je     80266c <alloc_block_FF+0x212>
  802666:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80266a:	75 17                	jne    802683 <alloc_block_FF+0x229>
  80266c:	83 ec 04             	sub    $0x4,%esp
  80266f:	68 78 47 80 00       	push   $0x804778
  802674:	68 df 00 00 00       	push   $0xdf
  802679:	68 05 47 80 00       	push   $0x804705
  80267e:	e8 0f df ff ff       	call   800592 <_panic>
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 10                	mov    (%eax),%edx
  802688:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80268b:	89 10                	mov    %edx,(%eax)
  80268d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	85 c0                	test   %eax,%eax
  802694:	74 0b                	je     8026a1 <alloc_block_FF+0x247>
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 00                	mov    (%eax),%eax
  80269b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80269e:	89 50 04             	mov    %edx,0x4(%eax)
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026a7:	89 10                	mov    %edx,(%eax)
  8026a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026af:	89 50 04             	mov    %edx,0x4(%eax)
  8026b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026b5:	8b 00                	mov    (%eax),%eax
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	75 08                	jne    8026c3 <alloc_block_FF+0x269>
  8026bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026be:	a3 30 50 80 00       	mov    %eax,0x805030
  8026c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8026c8:	40                   	inc    %eax
  8026c9:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8026ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d2:	75 17                	jne    8026eb <alloc_block_FF+0x291>
  8026d4:	83 ec 04             	sub    $0x4,%esp
  8026d7:	68 e7 46 80 00       	push   $0x8046e7
  8026dc:	68 e1 00 00 00       	push   $0xe1
  8026e1:	68 05 47 80 00       	push   $0x804705
  8026e6:	e8 a7 de ff ff       	call   800592 <_panic>
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 00                	mov    (%eax),%eax
  8026f0:	85 c0                	test   %eax,%eax
  8026f2:	74 10                	je     802704 <alloc_block_FF+0x2aa>
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 00                	mov    (%eax),%eax
  8026f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fc:	8b 52 04             	mov    0x4(%edx),%edx
  8026ff:	89 50 04             	mov    %edx,0x4(%eax)
  802702:	eb 0b                	jmp    80270f <alloc_block_FF+0x2b5>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 04             	mov    0x4(%eax),%eax
  80270a:	a3 30 50 80 00       	mov    %eax,0x805030
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 04             	mov    0x4(%eax),%eax
  802715:	85 c0                	test   %eax,%eax
  802717:	74 0f                	je     802728 <alloc_block_FF+0x2ce>
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 40 04             	mov    0x4(%eax),%eax
  80271f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802722:	8b 12                	mov    (%edx),%edx
  802724:	89 10                	mov    %edx,(%eax)
  802726:	eb 0a                	jmp    802732 <alloc_block_FF+0x2d8>
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 00                	mov    (%eax),%eax
  80272d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802745:	a1 38 50 80 00       	mov    0x805038,%eax
  80274a:	48                   	dec    %eax
  80274b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802750:	83 ec 04             	sub    $0x4,%esp
  802753:	6a 00                	push   $0x0
  802755:	ff 75 b4             	pushl  -0x4c(%ebp)
  802758:	ff 75 b0             	pushl  -0x50(%ebp)
  80275b:	e8 cb fc ff ff       	call   80242b <set_block_data>
  802760:	83 c4 10             	add    $0x10,%esp
  802763:	e9 95 00 00 00       	jmp    8027fd <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	6a 01                	push   $0x1
  80276d:	ff 75 b8             	pushl  -0x48(%ebp)
  802770:	ff 75 bc             	pushl  -0x44(%ebp)
  802773:	e8 b3 fc ff ff       	call   80242b <set_block_data>
  802778:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80277b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277f:	75 17                	jne    802798 <alloc_block_FF+0x33e>
  802781:	83 ec 04             	sub    $0x4,%esp
  802784:	68 e7 46 80 00       	push   $0x8046e7
  802789:	68 e8 00 00 00       	push   $0xe8
  80278e:	68 05 47 80 00       	push   $0x804705
  802793:	e8 fa dd ff ff       	call   800592 <_panic>
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	85 c0                	test   %eax,%eax
  80279f:	74 10                	je     8027b1 <alloc_block_FF+0x357>
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a9:	8b 52 04             	mov    0x4(%edx),%edx
  8027ac:	89 50 04             	mov    %edx,0x4(%eax)
  8027af:	eb 0b                	jmp    8027bc <alloc_block_FF+0x362>
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 40 04             	mov    0x4(%eax),%eax
  8027b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 40 04             	mov    0x4(%eax),%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	74 0f                	je     8027d5 <alloc_block_FF+0x37b>
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 40 04             	mov    0x4(%eax),%eax
  8027cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027cf:	8b 12                	mov    (%edx),%edx
  8027d1:	89 10                	mov    %edx,(%eax)
  8027d3:	eb 0a                	jmp    8027df <alloc_block_FF+0x385>
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 00                	mov    (%eax),%eax
  8027da:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f7:	48                   	dec    %eax
  8027f8:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8027fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802800:	e9 0f 01 00 00       	jmp    802914 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802805:	a1 34 50 80 00       	mov    0x805034,%eax
  80280a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802811:	74 07                	je     80281a <alloc_block_FF+0x3c0>
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	eb 05                	jmp    80281f <alloc_block_FF+0x3c5>
  80281a:	b8 00 00 00 00       	mov    $0x0,%eax
  80281f:	a3 34 50 80 00       	mov    %eax,0x805034
  802824:	a1 34 50 80 00       	mov    0x805034,%eax
  802829:	85 c0                	test   %eax,%eax
  80282b:	0f 85 e9 fc ff ff    	jne    80251a <alloc_block_FF+0xc0>
  802831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802835:	0f 85 df fc ff ff    	jne    80251a <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	83 c0 08             	add    $0x8,%eax
  802841:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802844:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80284b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80284e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802851:	01 d0                	add    %edx,%eax
  802853:	48                   	dec    %eax
  802854:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802857:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80285a:	ba 00 00 00 00       	mov    $0x0,%edx
  80285f:	f7 75 d8             	divl   -0x28(%ebp)
  802862:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802865:	29 d0                	sub    %edx,%eax
  802867:	c1 e8 0c             	shr    $0xc,%eax
  80286a:	83 ec 0c             	sub    $0xc,%esp
  80286d:	50                   	push   %eax
  80286e:	e8 76 ed ff ff       	call   8015e9 <sbrk>
  802873:	83 c4 10             	add    $0x10,%esp
  802876:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802879:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80287d:	75 0a                	jne    802889 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80287f:	b8 00 00 00 00       	mov    $0x0,%eax
  802884:	e9 8b 00 00 00       	jmp    802914 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802889:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802890:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802893:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802896:	01 d0                	add    %edx,%eax
  802898:	48                   	dec    %eax
  802899:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80289c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80289f:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a4:	f7 75 cc             	divl   -0x34(%ebp)
  8028a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028aa:	29 d0                	sub    %edx,%eax
  8028ac:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028b2:	01 d0                	add    %edx,%eax
  8028b4:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8028b9:	a1 40 50 80 00       	mov    0x805040,%eax
  8028be:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028c4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028d1:	01 d0                	add    %edx,%eax
  8028d3:	48                   	dec    %eax
  8028d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028d7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028da:	ba 00 00 00 00       	mov    $0x0,%edx
  8028df:	f7 75 c4             	divl   -0x3c(%ebp)
  8028e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028e5:	29 d0                	sub    %edx,%eax
  8028e7:	83 ec 04             	sub    $0x4,%esp
  8028ea:	6a 01                	push   $0x1
  8028ec:	50                   	push   %eax
  8028ed:	ff 75 d0             	pushl  -0x30(%ebp)
  8028f0:	e8 36 fb ff ff       	call   80242b <set_block_data>
  8028f5:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8028f8:	83 ec 0c             	sub    $0xc,%esp
  8028fb:	ff 75 d0             	pushl  -0x30(%ebp)
  8028fe:	e8 1b 0a 00 00       	call   80331e <free_block>
  802903:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802906:	83 ec 0c             	sub    $0xc,%esp
  802909:	ff 75 08             	pushl  0x8(%ebp)
  80290c:	e8 49 fb ff ff       	call   80245a <alloc_block_FF>
  802911:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	83 e0 01             	and    $0x1,%eax
  802922:	85 c0                	test   %eax,%eax
  802924:	74 03                	je     802929 <alloc_block_BF+0x13>
  802926:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802929:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80292d:	77 07                	ja     802936 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80292f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802936:	a1 24 50 80 00       	mov    0x805024,%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	75 73                	jne    8029b2 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	83 c0 10             	add    $0x10,%eax
  802945:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802948:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80294f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802952:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802955:	01 d0                	add    %edx,%eax
  802957:	48                   	dec    %eax
  802958:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80295b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80295e:	ba 00 00 00 00       	mov    $0x0,%edx
  802963:	f7 75 e0             	divl   -0x20(%ebp)
  802966:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802969:	29 d0                	sub    %edx,%eax
  80296b:	c1 e8 0c             	shr    $0xc,%eax
  80296e:	83 ec 0c             	sub    $0xc,%esp
  802971:	50                   	push   %eax
  802972:	e8 72 ec ff ff       	call   8015e9 <sbrk>
  802977:	83 c4 10             	add    $0x10,%esp
  80297a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80297d:	83 ec 0c             	sub    $0xc,%esp
  802980:	6a 00                	push   $0x0
  802982:	e8 62 ec ff ff       	call   8015e9 <sbrk>
  802987:	83 c4 10             	add    $0x10,%esp
  80298a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80298d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802990:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802993:	83 ec 08             	sub    $0x8,%esp
  802996:	50                   	push   %eax
  802997:	ff 75 d8             	pushl  -0x28(%ebp)
  80299a:	e8 9f f8 ff ff       	call   80223e <initialize_dynamic_allocator>
  80299f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029a2:	83 ec 0c             	sub    $0xc,%esp
  8029a5:	68 43 47 80 00       	push   $0x804743
  8029aa:	e8 a0 de ff ff       	call   80084f <cprintf>
  8029af:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029c0:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8029ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d6:	e9 1d 01 00 00       	jmp    802af8 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8029e1:	83 ec 0c             	sub    $0xc,%esp
  8029e4:	ff 75 a8             	pushl  -0x58(%ebp)
  8029e7:	e8 ee f6 ff ff       	call   8020da <get_block_size>
  8029ec:	83 c4 10             	add    $0x10,%esp
  8029ef:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	83 c0 08             	add    $0x8,%eax
  8029f8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029fb:	0f 87 ef 00 00 00    	ja     802af0 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	83 c0 18             	add    $0x18,%eax
  802a07:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a0a:	77 1d                	ja     802a29 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a12:	0f 86 d8 00 00 00    	jbe    802af0 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a18:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a1e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a21:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a24:	e9 c7 00 00 00       	jmp    802af0 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	83 c0 08             	add    $0x8,%eax
  802a2f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a32:	0f 85 9d 00 00 00    	jne    802ad5 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a38:	83 ec 04             	sub    $0x4,%esp
  802a3b:	6a 01                	push   $0x1
  802a3d:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a40:	ff 75 a8             	pushl  -0x58(%ebp)
  802a43:	e8 e3 f9 ff ff       	call   80242b <set_block_data>
  802a48:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4f:	75 17                	jne    802a68 <alloc_block_BF+0x152>
  802a51:	83 ec 04             	sub    $0x4,%esp
  802a54:	68 e7 46 80 00       	push   $0x8046e7
  802a59:	68 2c 01 00 00       	push   $0x12c
  802a5e:	68 05 47 80 00       	push   $0x804705
  802a63:	e8 2a db ff ff       	call   800592 <_panic>
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 00                	mov    (%eax),%eax
  802a6d:	85 c0                	test   %eax,%eax
  802a6f:	74 10                	je     802a81 <alloc_block_BF+0x16b>
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 00                	mov    (%eax),%eax
  802a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a79:	8b 52 04             	mov    0x4(%edx),%edx
  802a7c:	89 50 04             	mov    %edx,0x4(%eax)
  802a7f:	eb 0b                	jmp    802a8c <alloc_block_BF+0x176>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 40 04             	mov    0x4(%eax),%eax
  802a87:	a3 30 50 80 00       	mov    %eax,0x805030
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 04             	mov    0x4(%eax),%eax
  802a92:	85 c0                	test   %eax,%eax
  802a94:	74 0f                	je     802aa5 <alloc_block_BF+0x18f>
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	8b 40 04             	mov    0x4(%eax),%eax
  802a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9f:	8b 12                	mov    (%edx),%edx
  802aa1:	89 10                	mov    %edx,(%eax)
  802aa3:	eb 0a                	jmp    802aaf <alloc_block_BF+0x199>
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 00                	mov    (%eax),%eax
  802aaa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ac7:	48                   	dec    %eax
  802ac8:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802acd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ad0:	e9 24 04 00 00       	jmp    802ef9 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802adb:	76 13                	jbe    802af0 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802add:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ae4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ae7:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802aea:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802aed:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802af0:	a1 34 50 80 00       	mov    0x805034,%eax
  802af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afc:	74 07                	je     802b05 <alloc_block_BF+0x1ef>
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 00                	mov    (%eax),%eax
  802b03:	eb 05                	jmp    802b0a <alloc_block_BF+0x1f4>
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0a:	a3 34 50 80 00       	mov    %eax,0x805034
  802b0f:	a1 34 50 80 00       	mov    0x805034,%eax
  802b14:	85 c0                	test   %eax,%eax
  802b16:	0f 85 bf fe ff ff    	jne    8029db <alloc_block_BF+0xc5>
  802b1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b20:	0f 85 b5 fe ff ff    	jne    8029db <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b2a:	0f 84 26 02 00 00    	je     802d56 <alloc_block_BF+0x440>
  802b30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b34:	0f 85 1c 02 00 00    	jne    802d56 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3d:	2b 45 08             	sub    0x8(%ebp),%eax
  802b40:	83 e8 08             	sub    $0x8,%eax
  802b43:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	8d 50 08             	lea    0x8(%eax),%edx
  802b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4f:	01 d0                	add    %edx,%eax
  802b51:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	83 c0 08             	add    $0x8,%eax
  802b5a:	83 ec 04             	sub    $0x4,%esp
  802b5d:	6a 01                	push   $0x1
  802b5f:	50                   	push   %eax
  802b60:	ff 75 f0             	pushl  -0x10(%ebp)
  802b63:	e8 c3 f8 ff ff       	call   80242b <set_block_data>
  802b68:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6e:	8b 40 04             	mov    0x4(%eax),%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	75 68                	jne    802bdd <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b75:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b79:	75 17                	jne    802b92 <alloc_block_BF+0x27c>
  802b7b:	83 ec 04             	sub    $0x4,%esp
  802b7e:	68 20 47 80 00       	push   $0x804720
  802b83:	68 45 01 00 00       	push   $0x145
  802b88:	68 05 47 80 00       	push   $0x804705
  802b8d:	e8 00 da ff ff       	call   800592 <_panic>
  802b92:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b9b:	89 10                	mov    %edx,(%eax)
  802b9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	85 c0                	test   %eax,%eax
  802ba4:	74 0d                	je     802bb3 <alloc_block_BF+0x29d>
  802ba6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bab:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bae:	89 50 04             	mov    %edx,0x4(%eax)
  802bb1:	eb 08                	jmp    802bbb <alloc_block_BF+0x2a5>
  802bb3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb6:	a3 30 50 80 00       	mov    %eax,0x805030
  802bbb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bbe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcd:	a1 38 50 80 00       	mov    0x805038,%eax
  802bd2:	40                   	inc    %eax
  802bd3:	a3 38 50 80 00       	mov    %eax,0x805038
  802bd8:	e9 dc 00 00 00       	jmp    802cb9 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	75 65                	jne    802c4b <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802be6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bea:	75 17                	jne    802c03 <alloc_block_BF+0x2ed>
  802bec:	83 ec 04             	sub    $0x4,%esp
  802bef:	68 54 47 80 00       	push   $0x804754
  802bf4:	68 4a 01 00 00       	push   $0x14a
  802bf9:	68 05 47 80 00       	push   $0x804705
  802bfe:	e8 8f d9 ff ff       	call   800592 <_panic>
  802c03:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c0c:	89 50 04             	mov    %edx,0x4(%eax)
  802c0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c12:	8b 40 04             	mov    0x4(%eax),%eax
  802c15:	85 c0                	test   %eax,%eax
  802c17:	74 0c                	je     802c25 <alloc_block_BF+0x30f>
  802c19:	a1 30 50 80 00       	mov    0x805030,%eax
  802c1e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c21:	89 10                	mov    %edx,(%eax)
  802c23:	eb 08                	jmp    802c2d <alloc_block_BF+0x317>
  802c25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c28:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c30:	a3 30 50 80 00       	mov    %eax,0x805030
  802c35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3e:	a1 38 50 80 00       	mov    0x805038,%eax
  802c43:	40                   	inc    %eax
  802c44:	a3 38 50 80 00       	mov    %eax,0x805038
  802c49:	eb 6e                	jmp    802cb9 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c4f:	74 06                	je     802c57 <alloc_block_BF+0x341>
  802c51:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c55:	75 17                	jne    802c6e <alloc_block_BF+0x358>
  802c57:	83 ec 04             	sub    $0x4,%esp
  802c5a:	68 78 47 80 00       	push   $0x804778
  802c5f:	68 4f 01 00 00       	push   $0x14f
  802c64:	68 05 47 80 00       	push   $0x804705
  802c69:	e8 24 d9 ff ff       	call   800592 <_panic>
  802c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c71:	8b 10                	mov    (%eax),%edx
  802c73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c76:	89 10                	mov    %edx,(%eax)
  802c78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	74 0b                	je     802c8c <alloc_block_BF+0x376>
  802c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c84:	8b 00                	mov    (%eax),%eax
  802c86:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c89:	89 50 04             	mov    %edx,0x4(%eax)
  802c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c92:	89 10                	mov    %edx,(%eax)
  802c94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c9a:	89 50 04             	mov    %edx,0x4(%eax)
  802c9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	85 c0                	test   %eax,%eax
  802ca4:	75 08                	jne    802cae <alloc_block_BF+0x398>
  802ca6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca9:	a3 30 50 80 00       	mov    %eax,0x805030
  802cae:	a1 38 50 80 00       	mov    0x805038,%eax
  802cb3:	40                   	inc    %eax
  802cb4:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802cb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cbd:	75 17                	jne    802cd6 <alloc_block_BF+0x3c0>
  802cbf:	83 ec 04             	sub    $0x4,%esp
  802cc2:	68 e7 46 80 00       	push   $0x8046e7
  802cc7:	68 51 01 00 00       	push   $0x151
  802ccc:	68 05 47 80 00       	push   $0x804705
  802cd1:	e8 bc d8 ff ff       	call   800592 <_panic>
  802cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd9:	8b 00                	mov    (%eax),%eax
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	74 10                	je     802cef <alloc_block_BF+0x3d9>
  802cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce2:	8b 00                	mov    (%eax),%eax
  802ce4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce7:	8b 52 04             	mov    0x4(%edx),%edx
  802cea:	89 50 04             	mov    %edx,0x4(%eax)
  802ced:	eb 0b                	jmp    802cfa <alloc_block_BF+0x3e4>
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	8b 40 04             	mov    0x4(%eax),%eax
  802cf5:	a3 30 50 80 00       	mov    %eax,0x805030
  802cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfd:	8b 40 04             	mov    0x4(%eax),%eax
  802d00:	85 c0                	test   %eax,%eax
  802d02:	74 0f                	je     802d13 <alloc_block_BF+0x3fd>
  802d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d07:	8b 40 04             	mov    0x4(%eax),%eax
  802d0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0d:	8b 12                	mov    (%edx),%edx
  802d0f:	89 10                	mov    %edx,(%eax)
  802d11:	eb 0a                	jmp    802d1d <alloc_block_BF+0x407>
  802d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d16:	8b 00                	mov    (%eax),%eax
  802d18:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d30:	a1 38 50 80 00       	mov    0x805038,%eax
  802d35:	48                   	dec    %eax
  802d36:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d3b:	83 ec 04             	sub    $0x4,%esp
  802d3e:	6a 00                	push   $0x0
  802d40:	ff 75 d0             	pushl  -0x30(%ebp)
  802d43:	ff 75 cc             	pushl  -0x34(%ebp)
  802d46:	e8 e0 f6 ff ff       	call   80242b <set_block_data>
  802d4b:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d51:	e9 a3 01 00 00       	jmp    802ef9 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d56:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d5a:	0f 85 9d 00 00 00    	jne    802dfd <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d60:	83 ec 04             	sub    $0x4,%esp
  802d63:	6a 01                	push   $0x1
  802d65:	ff 75 ec             	pushl  -0x14(%ebp)
  802d68:	ff 75 f0             	pushl  -0x10(%ebp)
  802d6b:	e8 bb f6 ff ff       	call   80242b <set_block_data>
  802d70:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d77:	75 17                	jne    802d90 <alloc_block_BF+0x47a>
  802d79:	83 ec 04             	sub    $0x4,%esp
  802d7c:	68 e7 46 80 00       	push   $0x8046e7
  802d81:	68 58 01 00 00       	push   $0x158
  802d86:	68 05 47 80 00       	push   $0x804705
  802d8b:	e8 02 d8 ff ff       	call   800592 <_panic>
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	85 c0                	test   %eax,%eax
  802d97:	74 10                	je     802da9 <alloc_block_BF+0x493>
  802d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9c:	8b 00                	mov    (%eax),%eax
  802d9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da1:	8b 52 04             	mov    0x4(%edx),%edx
  802da4:	89 50 04             	mov    %edx,0x4(%eax)
  802da7:	eb 0b                	jmp    802db4 <alloc_block_BF+0x49e>
  802da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dac:	8b 40 04             	mov    0x4(%eax),%eax
  802daf:	a3 30 50 80 00       	mov    %eax,0x805030
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	8b 40 04             	mov    0x4(%eax),%eax
  802dba:	85 c0                	test   %eax,%eax
  802dbc:	74 0f                	je     802dcd <alloc_block_BF+0x4b7>
  802dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc1:	8b 40 04             	mov    0x4(%eax),%eax
  802dc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc7:	8b 12                	mov    (%edx),%edx
  802dc9:	89 10                	mov    %edx,(%eax)
  802dcb:	eb 0a                	jmp    802dd7 <alloc_block_BF+0x4c1>
  802dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd0:	8b 00                	mov    (%eax),%eax
  802dd2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dea:	a1 38 50 80 00       	mov    0x805038,%eax
  802def:	48                   	dec    %eax
  802df0:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df8:	e9 fc 00 00 00       	jmp    802ef9 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	83 c0 08             	add    $0x8,%eax
  802e03:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e06:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e0d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e10:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e13:	01 d0                	add    %edx,%eax
  802e15:	48                   	dec    %eax
  802e16:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e19:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e21:	f7 75 c4             	divl   -0x3c(%ebp)
  802e24:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e27:	29 d0                	sub    %edx,%eax
  802e29:	c1 e8 0c             	shr    $0xc,%eax
  802e2c:	83 ec 0c             	sub    $0xc,%esp
  802e2f:	50                   	push   %eax
  802e30:	e8 b4 e7 ff ff       	call   8015e9 <sbrk>
  802e35:	83 c4 10             	add    $0x10,%esp
  802e38:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e3b:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e3f:	75 0a                	jne    802e4b <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e41:	b8 00 00 00 00       	mov    $0x0,%eax
  802e46:	e9 ae 00 00 00       	jmp    802ef9 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e4b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e52:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e55:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e58:	01 d0                	add    %edx,%eax
  802e5a:	48                   	dec    %eax
  802e5b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e5e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e61:	ba 00 00 00 00       	mov    $0x0,%edx
  802e66:	f7 75 b8             	divl   -0x48(%ebp)
  802e69:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e6c:	29 d0                	sub    %edx,%eax
  802e6e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e71:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e74:	01 d0                	add    %edx,%eax
  802e76:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e7b:	a1 40 50 80 00       	mov    0x805040,%eax
  802e80:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e86:	83 ec 0c             	sub    $0xc,%esp
  802e89:	68 ac 47 80 00       	push   $0x8047ac
  802e8e:	e8 bc d9 ff ff       	call   80084f <cprintf>
  802e93:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e96:	83 ec 08             	sub    $0x8,%esp
  802e99:	ff 75 bc             	pushl  -0x44(%ebp)
  802e9c:	68 b1 47 80 00       	push   $0x8047b1
  802ea1:	e8 a9 d9 ff ff       	call   80084f <cprintf>
  802ea6:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ea9:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802eb0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802eb3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802eb6:	01 d0                	add    %edx,%eax
  802eb8:	48                   	dec    %eax
  802eb9:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ebc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  802ec4:	f7 75 b0             	divl   -0x50(%ebp)
  802ec7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802eca:	29 d0                	sub    %edx,%eax
  802ecc:	83 ec 04             	sub    $0x4,%esp
  802ecf:	6a 01                	push   $0x1
  802ed1:	50                   	push   %eax
  802ed2:	ff 75 bc             	pushl  -0x44(%ebp)
  802ed5:	e8 51 f5 ff ff       	call   80242b <set_block_data>
  802eda:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802edd:	83 ec 0c             	sub    $0xc,%esp
  802ee0:	ff 75 bc             	pushl  -0x44(%ebp)
  802ee3:	e8 36 04 00 00       	call   80331e <free_block>
  802ee8:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802eeb:	83 ec 0c             	sub    $0xc,%esp
  802eee:	ff 75 08             	pushl  0x8(%ebp)
  802ef1:	e8 20 fa ff ff       	call   802916 <alloc_block_BF>
  802ef6:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ef9:	c9                   	leave  
  802efa:	c3                   	ret    

00802efb <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802efb:	55                   	push   %ebp
  802efc:	89 e5                	mov    %esp,%ebp
  802efe:	53                   	push   %ebx
  802eff:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f14:	74 1e                	je     802f34 <merging+0x39>
  802f16:	ff 75 08             	pushl  0x8(%ebp)
  802f19:	e8 bc f1 ff ff       	call   8020da <get_block_size>
  802f1e:	83 c4 04             	add    $0x4,%esp
  802f21:	89 c2                	mov    %eax,%edx
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	01 d0                	add    %edx,%eax
  802f28:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f2b:	75 07                	jne    802f34 <merging+0x39>
		prev_is_free = 1;
  802f2d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f38:	74 1e                	je     802f58 <merging+0x5d>
  802f3a:	ff 75 10             	pushl  0x10(%ebp)
  802f3d:	e8 98 f1 ff ff       	call   8020da <get_block_size>
  802f42:	83 c4 04             	add    $0x4,%esp
  802f45:	89 c2                	mov    %eax,%edx
  802f47:	8b 45 10             	mov    0x10(%ebp),%eax
  802f4a:	01 d0                	add    %edx,%eax
  802f4c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f4f:	75 07                	jne    802f58 <merging+0x5d>
		next_is_free = 1;
  802f51:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5c:	0f 84 cc 00 00 00    	je     80302e <merging+0x133>
  802f62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f66:	0f 84 c2 00 00 00    	je     80302e <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f6c:	ff 75 08             	pushl  0x8(%ebp)
  802f6f:	e8 66 f1 ff ff       	call   8020da <get_block_size>
  802f74:	83 c4 04             	add    $0x4,%esp
  802f77:	89 c3                	mov    %eax,%ebx
  802f79:	ff 75 10             	pushl  0x10(%ebp)
  802f7c:	e8 59 f1 ff ff       	call   8020da <get_block_size>
  802f81:	83 c4 04             	add    $0x4,%esp
  802f84:	01 c3                	add    %eax,%ebx
  802f86:	ff 75 0c             	pushl  0xc(%ebp)
  802f89:	e8 4c f1 ff ff       	call   8020da <get_block_size>
  802f8e:	83 c4 04             	add    $0x4,%esp
  802f91:	01 d8                	add    %ebx,%eax
  802f93:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f96:	6a 00                	push   $0x0
  802f98:	ff 75 ec             	pushl  -0x14(%ebp)
  802f9b:	ff 75 08             	pushl  0x8(%ebp)
  802f9e:	e8 88 f4 ff ff       	call   80242b <set_block_data>
  802fa3:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802fa6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802faa:	75 17                	jne    802fc3 <merging+0xc8>
  802fac:	83 ec 04             	sub    $0x4,%esp
  802faf:	68 e7 46 80 00       	push   $0x8046e7
  802fb4:	68 7d 01 00 00       	push   $0x17d
  802fb9:	68 05 47 80 00       	push   $0x804705
  802fbe:	e8 cf d5 ff ff       	call   800592 <_panic>
  802fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 10                	je     802fdc <merging+0xe1>
  802fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd4:	8b 52 04             	mov    0x4(%edx),%edx
  802fd7:	89 50 04             	mov    %edx,0x4(%eax)
  802fda:	eb 0b                	jmp    802fe7 <merging+0xec>
  802fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdf:	8b 40 04             	mov    0x4(%eax),%eax
  802fe2:	a3 30 50 80 00       	mov    %eax,0x805030
  802fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fea:	8b 40 04             	mov    0x4(%eax),%eax
  802fed:	85 c0                	test   %eax,%eax
  802fef:	74 0f                	je     803000 <merging+0x105>
  802ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff4:	8b 40 04             	mov    0x4(%eax),%eax
  802ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ffa:	8b 12                	mov    (%edx),%edx
  802ffc:	89 10                	mov    %edx,(%eax)
  802ffe:	eb 0a                	jmp    80300a <merging+0x10f>
  803000:	8b 45 0c             	mov    0xc(%ebp),%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80300a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803013:	8b 45 0c             	mov    0xc(%ebp),%eax
  803016:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301d:	a1 38 50 80 00       	mov    0x805038,%eax
  803022:	48                   	dec    %eax
  803023:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803028:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803029:	e9 ea 02 00 00       	jmp    803318 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80302e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803032:	74 3b                	je     80306f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803034:	83 ec 0c             	sub    $0xc,%esp
  803037:	ff 75 08             	pushl  0x8(%ebp)
  80303a:	e8 9b f0 ff ff       	call   8020da <get_block_size>
  80303f:	83 c4 10             	add    $0x10,%esp
  803042:	89 c3                	mov    %eax,%ebx
  803044:	83 ec 0c             	sub    $0xc,%esp
  803047:	ff 75 10             	pushl  0x10(%ebp)
  80304a:	e8 8b f0 ff ff       	call   8020da <get_block_size>
  80304f:	83 c4 10             	add    $0x10,%esp
  803052:	01 d8                	add    %ebx,%eax
  803054:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803057:	83 ec 04             	sub    $0x4,%esp
  80305a:	6a 00                	push   $0x0
  80305c:	ff 75 e8             	pushl  -0x18(%ebp)
  80305f:	ff 75 08             	pushl  0x8(%ebp)
  803062:	e8 c4 f3 ff ff       	call   80242b <set_block_data>
  803067:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80306a:	e9 a9 02 00 00       	jmp    803318 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80306f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803073:	0f 84 2d 01 00 00    	je     8031a6 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803079:	83 ec 0c             	sub    $0xc,%esp
  80307c:	ff 75 10             	pushl  0x10(%ebp)
  80307f:	e8 56 f0 ff ff       	call   8020da <get_block_size>
  803084:	83 c4 10             	add    $0x10,%esp
  803087:	89 c3                	mov    %eax,%ebx
  803089:	83 ec 0c             	sub    $0xc,%esp
  80308c:	ff 75 0c             	pushl  0xc(%ebp)
  80308f:	e8 46 f0 ff ff       	call   8020da <get_block_size>
  803094:	83 c4 10             	add    $0x10,%esp
  803097:	01 d8                	add    %ebx,%eax
  803099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	6a 00                	push   $0x0
  8030a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030a4:	ff 75 10             	pushl  0x10(%ebp)
  8030a7:	e8 7f f3 ff ff       	call   80242b <set_block_data>
  8030ac:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030af:	8b 45 10             	mov    0x10(%ebp),%eax
  8030b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030b9:	74 06                	je     8030c1 <merging+0x1c6>
  8030bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030bf:	75 17                	jne    8030d8 <merging+0x1dd>
  8030c1:	83 ec 04             	sub    $0x4,%esp
  8030c4:	68 c0 47 80 00       	push   $0x8047c0
  8030c9:	68 8d 01 00 00       	push   $0x18d
  8030ce:	68 05 47 80 00       	push   $0x804705
  8030d3:	e8 ba d4 ff ff       	call   800592 <_panic>
  8030d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030db:	8b 50 04             	mov    0x4(%eax),%edx
  8030de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e1:	89 50 04             	mov    %edx,0x4(%eax)
  8030e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ea:	89 10                	mov    %edx,(%eax)
  8030ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ef:	8b 40 04             	mov    0x4(%eax),%eax
  8030f2:	85 c0                	test   %eax,%eax
  8030f4:	74 0d                	je     803103 <merging+0x208>
  8030f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f9:	8b 40 04             	mov    0x4(%eax),%eax
  8030fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ff:	89 10                	mov    %edx,(%eax)
  803101:	eb 08                	jmp    80310b <merging+0x210>
  803103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803106:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80310b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803111:	89 50 04             	mov    %edx,0x4(%eax)
  803114:	a1 38 50 80 00       	mov    0x805038,%eax
  803119:	40                   	inc    %eax
  80311a:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80311f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803123:	75 17                	jne    80313c <merging+0x241>
  803125:	83 ec 04             	sub    $0x4,%esp
  803128:	68 e7 46 80 00       	push   $0x8046e7
  80312d:	68 8e 01 00 00       	push   $0x18e
  803132:	68 05 47 80 00       	push   $0x804705
  803137:	e8 56 d4 ff ff       	call   800592 <_panic>
  80313c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	74 10                	je     803155 <merging+0x25a>
  803145:	8b 45 0c             	mov    0xc(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80314d:	8b 52 04             	mov    0x4(%edx),%edx
  803150:	89 50 04             	mov    %edx,0x4(%eax)
  803153:	eb 0b                	jmp    803160 <merging+0x265>
  803155:	8b 45 0c             	mov    0xc(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	a3 30 50 80 00       	mov    %eax,0x805030
  803160:	8b 45 0c             	mov    0xc(%ebp),%eax
  803163:	8b 40 04             	mov    0x4(%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	74 0f                	je     803179 <merging+0x27e>
  80316a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316d:	8b 40 04             	mov    0x4(%eax),%eax
  803170:	8b 55 0c             	mov    0xc(%ebp),%edx
  803173:	8b 12                	mov    (%edx),%edx
  803175:	89 10                	mov    %edx,(%eax)
  803177:	eb 0a                	jmp    803183 <merging+0x288>
  803179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317c:	8b 00                	mov    (%eax),%eax
  80317e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803183:	8b 45 0c             	mov    0xc(%ebp),%eax
  803186:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803196:	a1 38 50 80 00       	mov    0x805038,%eax
  80319b:	48                   	dec    %eax
  80319c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031a1:	e9 72 01 00 00       	jmp    803318 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8031a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8031a9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b0:	74 79                	je     80322b <merging+0x330>
  8031b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031b6:	74 73                	je     80322b <merging+0x330>
  8031b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031bc:	74 06                	je     8031c4 <merging+0x2c9>
  8031be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031c2:	75 17                	jne    8031db <merging+0x2e0>
  8031c4:	83 ec 04             	sub    $0x4,%esp
  8031c7:	68 78 47 80 00       	push   $0x804778
  8031cc:	68 94 01 00 00       	push   $0x194
  8031d1:	68 05 47 80 00       	push   $0x804705
  8031d6:	e8 b7 d3 ff ff       	call   800592 <_panic>
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	8b 10                	mov    (%eax),%edx
  8031e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e3:	89 10                	mov    %edx,(%eax)
  8031e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e8:	8b 00                	mov    (%eax),%eax
  8031ea:	85 c0                	test   %eax,%eax
  8031ec:	74 0b                	je     8031f9 <merging+0x2fe>
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	8b 00                	mov    (%eax),%eax
  8031f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031f6:	89 50 04             	mov    %edx,0x4(%eax)
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803204:	8b 55 08             	mov    0x8(%ebp),%edx
  803207:	89 50 04             	mov    %edx,0x4(%eax)
  80320a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80320d:	8b 00                	mov    (%eax),%eax
  80320f:	85 c0                	test   %eax,%eax
  803211:	75 08                	jne    80321b <merging+0x320>
  803213:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803216:	a3 30 50 80 00       	mov    %eax,0x805030
  80321b:	a1 38 50 80 00       	mov    0x805038,%eax
  803220:	40                   	inc    %eax
  803221:	a3 38 50 80 00       	mov    %eax,0x805038
  803226:	e9 ce 00 00 00       	jmp    8032f9 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80322b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322f:	74 65                	je     803296 <merging+0x39b>
  803231:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803235:	75 17                	jne    80324e <merging+0x353>
  803237:	83 ec 04             	sub    $0x4,%esp
  80323a:	68 54 47 80 00       	push   $0x804754
  80323f:	68 95 01 00 00       	push   $0x195
  803244:	68 05 47 80 00       	push   $0x804705
  803249:	e8 44 d3 ff ff       	call   800592 <_panic>
  80324e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803254:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803257:	89 50 04             	mov    %edx,0x4(%eax)
  80325a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325d:	8b 40 04             	mov    0x4(%eax),%eax
  803260:	85 c0                	test   %eax,%eax
  803262:	74 0c                	je     803270 <merging+0x375>
  803264:	a1 30 50 80 00       	mov    0x805030,%eax
  803269:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80326c:	89 10                	mov    %edx,(%eax)
  80326e:	eb 08                	jmp    803278 <merging+0x37d>
  803270:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803273:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803278:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80327b:	a3 30 50 80 00       	mov    %eax,0x805030
  803280:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803289:	a1 38 50 80 00       	mov    0x805038,%eax
  80328e:	40                   	inc    %eax
  80328f:	a3 38 50 80 00       	mov    %eax,0x805038
  803294:	eb 63                	jmp    8032f9 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803296:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80329a:	75 17                	jne    8032b3 <merging+0x3b8>
  80329c:	83 ec 04             	sub    $0x4,%esp
  80329f:	68 20 47 80 00       	push   $0x804720
  8032a4:	68 98 01 00 00       	push   $0x198
  8032a9:	68 05 47 80 00       	push   $0x804705
  8032ae:	e8 df d2 ff ff       	call   800592 <_panic>
  8032b3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032bc:	89 10                	mov    %edx,(%eax)
  8032be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c1:	8b 00                	mov    (%eax),%eax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	74 0d                	je     8032d4 <merging+0x3d9>
  8032c7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032cf:	89 50 04             	mov    %edx,0x4(%eax)
  8032d2:	eb 08                	jmp    8032dc <merging+0x3e1>
  8032d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8032dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032df:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8032f3:	40                   	inc    %eax
  8032f4:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8032f9:	83 ec 0c             	sub    $0xc,%esp
  8032fc:	ff 75 10             	pushl  0x10(%ebp)
  8032ff:	e8 d6 ed ff ff       	call   8020da <get_block_size>
  803304:	83 c4 10             	add    $0x10,%esp
  803307:	83 ec 04             	sub    $0x4,%esp
  80330a:	6a 00                	push   $0x0
  80330c:	50                   	push   %eax
  80330d:	ff 75 10             	pushl  0x10(%ebp)
  803310:	e8 16 f1 ff ff       	call   80242b <set_block_data>
  803315:	83 c4 10             	add    $0x10,%esp
	}
}
  803318:	90                   	nop
  803319:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80331c:	c9                   	leave  
  80331d:	c3                   	ret    

0080331e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80331e:	55                   	push   %ebp
  80331f:	89 e5                	mov    %esp,%ebp
  803321:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803324:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803329:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80332c:	a1 30 50 80 00       	mov    0x805030,%eax
  803331:	3b 45 08             	cmp    0x8(%ebp),%eax
  803334:	73 1b                	jae    803351 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803336:	a1 30 50 80 00       	mov    0x805030,%eax
  80333b:	83 ec 04             	sub    $0x4,%esp
  80333e:	ff 75 08             	pushl  0x8(%ebp)
  803341:	6a 00                	push   $0x0
  803343:	50                   	push   %eax
  803344:	e8 b2 fb ff ff       	call   802efb <merging>
  803349:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80334c:	e9 8b 00 00 00       	jmp    8033dc <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803351:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803356:	3b 45 08             	cmp    0x8(%ebp),%eax
  803359:	76 18                	jbe    803373 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80335b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803360:	83 ec 04             	sub    $0x4,%esp
  803363:	ff 75 08             	pushl  0x8(%ebp)
  803366:	50                   	push   %eax
  803367:	6a 00                	push   $0x0
  803369:	e8 8d fb ff ff       	call   802efb <merging>
  80336e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803371:	eb 69                	jmp    8033dc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803373:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803378:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80337b:	eb 39                	jmp    8033b6 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	3b 45 08             	cmp    0x8(%ebp),%eax
  803383:	73 29                	jae    8033ae <free_block+0x90>
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	8b 00                	mov    (%eax),%eax
  80338a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80338d:	76 1f                	jbe    8033ae <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	8b 00                	mov    (%eax),%eax
  803394:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803397:	83 ec 04             	sub    $0x4,%esp
  80339a:	ff 75 08             	pushl  0x8(%ebp)
  80339d:	ff 75 f0             	pushl  -0x10(%ebp)
  8033a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8033a3:	e8 53 fb ff ff       	call   802efb <merging>
  8033a8:	83 c4 10             	add    $0x10,%esp
			break;
  8033ab:	90                   	nop
		}
	}
}
  8033ac:	eb 2e                	jmp    8033dc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033ae:	a1 34 50 80 00       	mov    0x805034,%eax
  8033b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ba:	74 07                	je     8033c3 <free_block+0xa5>
  8033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	eb 05                	jmp    8033c8 <free_block+0xaa>
  8033c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c8:	a3 34 50 80 00       	mov    %eax,0x805034
  8033cd:	a1 34 50 80 00       	mov    0x805034,%eax
  8033d2:	85 c0                	test   %eax,%eax
  8033d4:	75 a7                	jne    80337d <free_block+0x5f>
  8033d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033da:	75 a1                	jne    80337d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033dc:	90                   	nop
  8033dd:	c9                   	leave  
  8033de:	c3                   	ret    

008033df <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033df:	55                   	push   %ebp
  8033e0:	89 e5                	mov    %esp,%ebp
  8033e2:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033e5:	ff 75 08             	pushl  0x8(%ebp)
  8033e8:	e8 ed ec ff ff       	call   8020da <get_block_size>
  8033ed:	83 c4 04             	add    $0x4,%esp
  8033f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033fa:	eb 17                	jmp    803413 <copy_data+0x34>
  8033fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803402:	01 c2                	add    %eax,%edx
  803404:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	01 c8                	add    %ecx,%eax
  80340c:	8a 00                	mov    (%eax),%al
  80340e:	88 02                	mov    %al,(%edx)
  803410:	ff 45 fc             	incl   -0x4(%ebp)
  803413:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803416:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803419:	72 e1                	jb     8033fc <copy_data+0x1d>
}
  80341b:	90                   	nop
  80341c:	c9                   	leave  
  80341d:	c3                   	ret    

0080341e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80341e:	55                   	push   %ebp
  80341f:	89 e5                	mov    %esp,%ebp
  803421:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803424:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803428:	75 23                	jne    80344d <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80342a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80342e:	74 13                	je     803443 <realloc_block_FF+0x25>
  803430:	83 ec 0c             	sub    $0xc,%esp
  803433:	ff 75 0c             	pushl  0xc(%ebp)
  803436:	e8 1f f0 ff ff       	call   80245a <alloc_block_FF>
  80343b:	83 c4 10             	add    $0x10,%esp
  80343e:	e9 f4 06 00 00       	jmp    803b37 <realloc_block_FF+0x719>
		return NULL;
  803443:	b8 00 00 00 00       	mov    $0x0,%eax
  803448:	e9 ea 06 00 00       	jmp    803b37 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80344d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803451:	75 18                	jne    80346b <realloc_block_FF+0x4d>
	{
		free_block(va);
  803453:	83 ec 0c             	sub    $0xc,%esp
  803456:	ff 75 08             	pushl  0x8(%ebp)
  803459:	e8 c0 fe ff ff       	call   80331e <free_block>
  80345e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803461:	b8 00 00 00 00       	mov    $0x0,%eax
  803466:	e9 cc 06 00 00       	jmp    803b37 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80346b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80346f:	77 07                	ja     803478 <realloc_block_FF+0x5a>
  803471:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80347b:	83 e0 01             	and    $0x1,%eax
  80347e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803481:	8b 45 0c             	mov    0xc(%ebp),%eax
  803484:	83 c0 08             	add    $0x8,%eax
  803487:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80348a:	83 ec 0c             	sub    $0xc,%esp
  80348d:	ff 75 08             	pushl  0x8(%ebp)
  803490:	e8 45 ec ff ff       	call   8020da <get_block_size>
  803495:	83 c4 10             	add    $0x10,%esp
  803498:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80349b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349e:	83 e8 08             	sub    $0x8,%eax
  8034a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a7:	83 e8 04             	sub    $0x4,%eax
  8034aa:	8b 00                	mov    (%eax),%eax
  8034ac:	83 e0 fe             	and    $0xfffffffe,%eax
  8034af:	89 c2                	mov    %eax,%edx
  8034b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b4:	01 d0                	add    %edx,%eax
  8034b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034b9:	83 ec 0c             	sub    $0xc,%esp
  8034bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034bf:	e8 16 ec ff ff       	call   8020da <get_block_size>
  8034c4:	83 c4 10             	add    $0x10,%esp
  8034c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034cd:	83 e8 08             	sub    $0x8,%eax
  8034d0:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034d9:	75 08                	jne    8034e3 <realloc_block_FF+0xc5>
	{
		 return va;
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	e9 54 06 00 00       	jmp    803b37 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8034e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034e9:	0f 83 e5 03 00 00    	jae    8038d4 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f2:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034f8:	83 ec 0c             	sub    $0xc,%esp
  8034fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034fe:	e8 f0 eb ff ff       	call   8020f3 <is_free_block>
  803503:	83 c4 10             	add    $0x10,%esp
  803506:	84 c0                	test   %al,%al
  803508:	0f 84 3b 01 00 00    	je     803649 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80350e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803511:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803514:	01 d0                	add    %edx,%eax
  803516:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803519:	83 ec 04             	sub    $0x4,%esp
  80351c:	6a 01                	push   $0x1
  80351e:	ff 75 f0             	pushl  -0x10(%ebp)
  803521:	ff 75 08             	pushl  0x8(%ebp)
  803524:	e8 02 ef ff ff       	call   80242b <set_block_data>
  803529:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80352c:	8b 45 08             	mov    0x8(%ebp),%eax
  80352f:	83 e8 04             	sub    $0x4,%eax
  803532:	8b 00                	mov    (%eax),%eax
  803534:	83 e0 fe             	and    $0xfffffffe,%eax
  803537:	89 c2                	mov    %eax,%edx
  803539:	8b 45 08             	mov    0x8(%ebp),%eax
  80353c:	01 d0                	add    %edx,%eax
  80353e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803541:	83 ec 04             	sub    $0x4,%esp
  803544:	6a 00                	push   $0x0
  803546:	ff 75 cc             	pushl  -0x34(%ebp)
  803549:	ff 75 c8             	pushl  -0x38(%ebp)
  80354c:	e8 da ee ff ff       	call   80242b <set_block_data>
  803551:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803554:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803558:	74 06                	je     803560 <realloc_block_FF+0x142>
  80355a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80355e:	75 17                	jne    803577 <realloc_block_FF+0x159>
  803560:	83 ec 04             	sub    $0x4,%esp
  803563:	68 78 47 80 00       	push   $0x804778
  803568:	68 f6 01 00 00       	push   $0x1f6
  80356d:	68 05 47 80 00       	push   $0x804705
  803572:	e8 1b d0 ff ff       	call   800592 <_panic>
  803577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357a:	8b 10                	mov    (%eax),%edx
  80357c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80357f:	89 10                	mov    %edx,(%eax)
  803581:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803584:	8b 00                	mov    (%eax),%eax
  803586:	85 c0                	test   %eax,%eax
  803588:	74 0b                	je     803595 <realloc_block_FF+0x177>
  80358a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358d:	8b 00                	mov    (%eax),%eax
  80358f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803592:	89 50 04             	mov    %edx,0x4(%eax)
  803595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803598:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80359b:	89 10                	mov    %edx,(%eax)
  80359d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a3:	89 50 04             	mov    %edx,0x4(%eax)
  8035a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035a9:	8b 00                	mov    (%eax),%eax
  8035ab:	85 c0                	test   %eax,%eax
  8035ad:	75 08                	jne    8035b7 <realloc_block_FF+0x199>
  8035af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8035bc:	40                   	inc    %eax
  8035bd:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035c6:	75 17                	jne    8035df <realloc_block_FF+0x1c1>
  8035c8:	83 ec 04             	sub    $0x4,%esp
  8035cb:	68 e7 46 80 00       	push   $0x8046e7
  8035d0:	68 f7 01 00 00       	push   $0x1f7
  8035d5:	68 05 47 80 00       	push   $0x804705
  8035da:	e8 b3 cf ff ff       	call   800592 <_panic>
  8035df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	85 c0                	test   %eax,%eax
  8035e6:	74 10                	je     8035f8 <realloc_block_FF+0x1da>
  8035e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035eb:	8b 00                	mov    (%eax),%eax
  8035ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f0:	8b 52 04             	mov    0x4(%edx),%edx
  8035f3:	89 50 04             	mov    %edx,0x4(%eax)
  8035f6:	eb 0b                	jmp    803603 <realloc_block_FF+0x1e5>
  8035f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fb:	8b 40 04             	mov    0x4(%eax),%eax
  8035fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803606:	8b 40 04             	mov    0x4(%eax),%eax
  803609:	85 c0                	test   %eax,%eax
  80360b:	74 0f                	je     80361c <realloc_block_FF+0x1fe>
  80360d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803610:	8b 40 04             	mov    0x4(%eax),%eax
  803613:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803616:	8b 12                	mov    (%edx),%edx
  803618:	89 10                	mov    %edx,(%eax)
  80361a:	eb 0a                	jmp    803626 <realloc_block_FF+0x208>
  80361c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361f:	8b 00                	mov    (%eax),%eax
  803621:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803639:	a1 38 50 80 00       	mov    0x805038,%eax
  80363e:	48                   	dec    %eax
  80363f:	a3 38 50 80 00       	mov    %eax,0x805038
  803644:	e9 83 02 00 00       	jmp    8038cc <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803649:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80364d:	0f 86 69 02 00 00    	jbe    8038bc <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803653:	83 ec 04             	sub    $0x4,%esp
  803656:	6a 01                	push   $0x1
  803658:	ff 75 f0             	pushl  -0x10(%ebp)
  80365b:	ff 75 08             	pushl  0x8(%ebp)
  80365e:	e8 c8 ed ff ff       	call   80242b <set_block_data>
  803663:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803666:	8b 45 08             	mov    0x8(%ebp),%eax
  803669:	83 e8 04             	sub    $0x4,%eax
  80366c:	8b 00                	mov    (%eax),%eax
  80366e:	83 e0 fe             	and    $0xfffffffe,%eax
  803671:	89 c2                	mov    %eax,%edx
  803673:	8b 45 08             	mov    0x8(%ebp),%eax
  803676:	01 d0                	add    %edx,%eax
  803678:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80367b:	a1 38 50 80 00       	mov    0x805038,%eax
  803680:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803683:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803687:	75 68                	jne    8036f1 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803689:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80368d:	75 17                	jne    8036a6 <realloc_block_FF+0x288>
  80368f:	83 ec 04             	sub    $0x4,%esp
  803692:	68 20 47 80 00       	push   $0x804720
  803697:	68 06 02 00 00       	push   $0x206
  80369c:	68 05 47 80 00       	push   $0x804705
  8036a1:	e8 ec ce ff ff       	call   800592 <_panic>
  8036a6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036af:	89 10                	mov    %edx,(%eax)
  8036b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b4:	8b 00                	mov    (%eax),%eax
  8036b6:	85 c0                	test   %eax,%eax
  8036b8:	74 0d                	je     8036c7 <realloc_block_FF+0x2a9>
  8036ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036c2:	89 50 04             	mov    %edx,0x4(%eax)
  8036c5:	eb 08                	jmp    8036cf <realloc_block_FF+0x2b1>
  8036c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8036cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e1:	a1 38 50 80 00       	mov    0x805038,%eax
  8036e6:	40                   	inc    %eax
  8036e7:	a3 38 50 80 00       	mov    %eax,0x805038
  8036ec:	e9 b0 01 00 00       	jmp    8038a1 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036f1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036f6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036f9:	76 68                	jbe    803763 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036fb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036ff:	75 17                	jne    803718 <realloc_block_FF+0x2fa>
  803701:	83 ec 04             	sub    $0x4,%esp
  803704:	68 20 47 80 00       	push   $0x804720
  803709:	68 0b 02 00 00       	push   $0x20b
  80370e:	68 05 47 80 00       	push   $0x804705
  803713:	e8 7a ce ff ff       	call   800592 <_panic>
  803718:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80371e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803721:	89 10                	mov    %edx,(%eax)
  803723:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803726:	8b 00                	mov    (%eax),%eax
  803728:	85 c0                	test   %eax,%eax
  80372a:	74 0d                	je     803739 <realloc_block_FF+0x31b>
  80372c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803731:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803734:	89 50 04             	mov    %edx,0x4(%eax)
  803737:	eb 08                	jmp    803741 <realloc_block_FF+0x323>
  803739:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373c:	a3 30 50 80 00       	mov    %eax,0x805030
  803741:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803744:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803749:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80374c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803753:	a1 38 50 80 00       	mov    0x805038,%eax
  803758:	40                   	inc    %eax
  803759:	a3 38 50 80 00       	mov    %eax,0x805038
  80375e:	e9 3e 01 00 00       	jmp    8038a1 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803763:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803768:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80376b:	73 68                	jae    8037d5 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80376d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803771:	75 17                	jne    80378a <realloc_block_FF+0x36c>
  803773:	83 ec 04             	sub    $0x4,%esp
  803776:	68 54 47 80 00       	push   $0x804754
  80377b:	68 10 02 00 00       	push   $0x210
  803780:	68 05 47 80 00       	push   $0x804705
  803785:	e8 08 ce ff ff       	call   800592 <_panic>
  80378a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803790:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803793:	89 50 04             	mov    %edx,0x4(%eax)
  803796:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803799:	8b 40 04             	mov    0x4(%eax),%eax
  80379c:	85 c0                	test   %eax,%eax
  80379e:	74 0c                	je     8037ac <realloc_block_FF+0x38e>
  8037a0:	a1 30 50 80 00       	mov    0x805030,%eax
  8037a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037a8:	89 10                	mov    %edx,(%eax)
  8037aa:	eb 08                	jmp    8037b4 <realloc_block_FF+0x396>
  8037ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037af:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8037bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ca:	40                   	inc    %eax
  8037cb:	a3 38 50 80 00       	mov    %eax,0x805038
  8037d0:	e9 cc 00 00 00       	jmp    8038a1 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037e4:	e9 8a 00 00 00       	jmp    803873 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ec:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037ef:	73 7a                	jae    80386b <realloc_block_FF+0x44d>
  8037f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f4:	8b 00                	mov    (%eax),%eax
  8037f6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037f9:	73 70                	jae    80386b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ff:	74 06                	je     803807 <realloc_block_FF+0x3e9>
  803801:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803805:	75 17                	jne    80381e <realloc_block_FF+0x400>
  803807:	83 ec 04             	sub    $0x4,%esp
  80380a:	68 78 47 80 00       	push   $0x804778
  80380f:	68 1a 02 00 00       	push   $0x21a
  803814:	68 05 47 80 00       	push   $0x804705
  803819:	e8 74 cd ff ff       	call   800592 <_panic>
  80381e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803821:	8b 10                	mov    (%eax),%edx
  803823:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803826:	89 10                	mov    %edx,(%eax)
  803828:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80382b:	8b 00                	mov    (%eax),%eax
  80382d:	85 c0                	test   %eax,%eax
  80382f:	74 0b                	je     80383c <realloc_block_FF+0x41e>
  803831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803834:	8b 00                	mov    (%eax),%eax
  803836:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803839:	89 50 04             	mov    %edx,0x4(%eax)
  80383c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803842:	89 10                	mov    %edx,(%eax)
  803844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80384a:	89 50 04             	mov    %edx,0x4(%eax)
  80384d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803850:	8b 00                	mov    (%eax),%eax
  803852:	85 c0                	test   %eax,%eax
  803854:	75 08                	jne    80385e <realloc_block_FF+0x440>
  803856:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803859:	a3 30 50 80 00       	mov    %eax,0x805030
  80385e:	a1 38 50 80 00       	mov    0x805038,%eax
  803863:	40                   	inc    %eax
  803864:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803869:	eb 36                	jmp    8038a1 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80386b:	a1 34 50 80 00       	mov    0x805034,%eax
  803870:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803877:	74 07                	je     803880 <realloc_block_FF+0x462>
  803879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387c:	8b 00                	mov    (%eax),%eax
  80387e:	eb 05                	jmp    803885 <realloc_block_FF+0x467>
  803880:	b8 00 00 00 00       	mov    $0x0,%eax
  803885:	a3 34 50 80 00       	mov    %eax,0x805034
  80388a:	a1 34 50 80 00       	mov    0x805034,%eax
  80388f:	85 c0                	test   %eax,%eax
  803891:	0f 85 52 ff ff ff    	jne    8037e9 <realloc_block_FF+0x3cb>
  803897:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80389b:	0f 85 48 ff ff ff    	jne    8037e9 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8038a1:	83 ec 04             	sub    $0x4,%esp
  8038a4:	6a 00                	push   $0x0
  8038a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8038a9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038ac:	e8 7a eb ff ff       	call   80242b <set_block_data>
  8038b1:	83 c4 10             	add    $0x10,%esp
				return va;
  8038b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b7:	e9 7b 02 00 00       	jmp    803b37 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8038bc:	83 ec 0c             	sub    $0xc,%esp
  8038bf:	68 f5 47 80 00       	push   $0x8047f5
  8038c4:	e8 86 cf ff ff       	call   80084f <cprintf>
  8038c9:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cf:	e9 63 02 00 00       	jmp    803b37 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8038d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038d7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038da:	0f 86 4d 02 00 00    	jbe    803b2d <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8038e0:	83 ec 0c             	sub    $0xc,%esp
  8038e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038e6:	e8 08 e8 ff ff       	call   8020f3 <is_free_block>
  8038eb:	83 c4 10             	add    $0x10,%esp
  8038ee:	84 c0                	test   %al,%al
  8038f0:	0f 84 37 02 00 00    	je     803b2d <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038fc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038ff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803902:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803905:	76 38                	jbe    80393f <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803907:	83 ec 0c             	sub    $0xc,%esp
  80390a:	ff 75 08             	pushl  0x8(%ebp)
  80390d:	e8 0c fa ff ff       	call   80331e <free_block>
  803912:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803915:	83 ec 0c             	sub    $0xc,%esp
  803918:	ff 75 0c             	pushl  0xc(%ebp)
  80391b:	e8 3a eb ff ff       	call   80245a <alloc_block_FF>
  803920:	83 c4 10             	add    $0x10,%esp
  803923:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803926:	83 ec 08             	sub    $0x8,%esp
  803929:	ff 75 c0             	pushl  -0x40(%ebp)
  80392c:	ff 75 08             	pushl  0x8(%ebp)
  80392f:	e8 ab fa ff ff       	call   8033df <copy_data>
  803934:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803937:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80393a:	e9 f8 01 00 00       	jmp    803b37 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80393f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803942:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803945:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803948:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80394c:	0f 87 a0 00 00 00    	ja     8039f2 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803952:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803956:	75 17                	jne    80396f <realloc_block_FF+0x551>
  803958:	83 ec 04             	sub    $0x4,%esp
  80395b:	68 e7 46 80 00       	push   $0x8046e7
  803960:	68 38 02 00 00       	push   $0x238
  803965:	68 05 47 80 00       	push   $0x804705
  80396a:	e8 23 cc ff ff       	call   800592 <_panic>
  80396f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803972:	8b 00                	mov    (%eax),%eax
  803974:	85 c0                	test   %eax,%eax
  803976:	74 10                	je     803988 <realloc_block_FF+0x56a>
  803978:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397b:	8b 00                	mov    (%eax),%eax
  80397d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803980:	8b 52 04             	mov    0x4(%edx),%edx
  803983:	89 50 04             	mov    %edx,0x4(%eax)
  803986:	eb 0b                	jmp    803993 <realloc_block_FF+0x575>
  803988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398b:	8b 40 04             	mov    0x4(%eax),%eax
  80398e:	a3 30 50 80 00       	mov    %eax,0x805030
  803993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803996:	8b 40 04             	mov    0x4(%eax),%eax
  803999:	85 c0                	test   %eax,%eax
  80399b:	74 0f                	je     8039ac <realloc_block_FF+0x58e>
  80399d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a0:	8b 40 04             	mov    0x4(%eax),%eax
  8039a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039a6:	8b 12                	mov    (%edx),%edx
  8039a8:	89 10                	mov    %edx,(%eax)
  8039aa:	eb 0a                	jmp    8039b6 <realloc_block_FF+0x598>
  8039ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039af:	8b 00                	mov    (%eax),%eax
  8039b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8039ce:	48                   	dec    %eax
  8039cf:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039da:	01 d0                	add    %edx,%eax
  8039dc:	83 ec 04             	sub    $0x4,%esp
  8039df:	6a 01                	push   $0x1
  8039e1:	50                   	push   %eax
  8039e2:	ff 75 08             	pushl  0x8(%ebp)
  8039e5:	e8 41 ea ff ff       	call   80242b <set_block_data>
  8039ea:	83 c4 10             	add    $0x10,%esp
  8039ed:	e9 36 01 00 00       	jmp    803b28 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039f8:	01 d0                	add    %edx,%eax
  8039fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039fd:	83 ec 04             	sub    $0x4,%esp
  803a00:	6a 01                	push   $0x1
  803a02:	ff 75 f0             	pushl  -0x10(%ebp)
  803a05:	ff 75 08             	pushl  0x8(%ebp)
  803a08:	e8 1e ea ff ff       	call   80242b <set_block_data>
  803a0d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a10:	8b 45 08             	mov    0x8(%ebp),%eax
  803a13:	83 e8 04             	sub    $0x4,%eax
  803a16:	8b 00                	mov    (%eax),%eax
  803a18:	83 e0 fe             	and    $0xfffffffe,%eax
  803a1b:	89 c2                	mov    %eax,%edx
  803a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a20:	01 d0                	add    %edx,%eax
  803a22:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a29:	74 06                	je     803a31 <realloc_block_FF+0x613>
  803a2b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a2f:	75 17                	jne    803a48 <realloc_block_FF+0x62a>
  803a31:	83 ec 04             	sub    $0x4,%esp
  803a34:	68 78 47 80 00       	push   $0x804778
  803a39:	68 44 02 00 00       	push   $0x244
  803a3e:	68 05 47 80 00       	push   $0x804705
  803a43:	e8 4a cb ff ff       	call   800592 <_panic>
  803a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4b:	8b 10                	mov    (%eax),%edx
  803a4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a50:	89 10                	mov    %edx,(%eax)
  803a52:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a55:	8b 00                	mov    (%eax),%eax
  803a57:	85 c0                	test   %eax,%eax
  803a59:	74 0b                	je     803a66 <realloc_block_FF+0x648>
  803a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5e:	8b 00                	mov    (%eax),%eax
  803a60:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a63:	89 50 04             	mov    %edx,0x4(%eax)
  803a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a69:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a6c:	89 10                	mov    %edx,(%eax)
  803a6e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a74:	89 50 04             	mov    %edx,0x4(%eax)
  803a77:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a7a:	8b 00                	mov    (%eax),%eax
  803a7c:	85 c0                	test   %eax,%eax
  803a7e:	75 08                	jne    803a88 <realloc_block_FF+0x66a>
  803a80:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a83:	a3 30 50 80 00       	mov    %eax,0x805030
  803a88:	a1 38 50 80 00       	mov    0x805038,%eax
  803a8d:	40                   	inc    %eax
  803a8e:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a97:	75 17                	jne    803ab0 <realloc_block_FF+0x692>
  803a99:	83 ec 04             	sub    $0x4,%esp
  803a9c:	68 e7 46 80 00       	push   $0x8046e7
  803aa1:	68 45 02 00 00       	push   $0x245
  803aa6:	68 05 47 80 00       	push   $0x804705
  803aab:	e8 e2 ca ff ff       	call   800592 <_panic>
  803ab0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab3:	8b 00                	mov    (%eax),%eax
  803ab5:	85 c0                	test   %eax,%eax
  803ab7:	74 10                	je     803ac9 <realloc_block_FF+0x6ab>
  803ab9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abc:	8b 00                	mov    (%eax),%eax
  803abe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ac1:	8b 52 04             	mov    0x4(%edx),%edx
  803ac4:	89 50 04             	mov    %edx,0x4(%eax)
  803ac7:	eb 0b                	jmp    803ad4 <realloc_block_FF+0x6b6>
  803ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acc:	8b 40 04             	mov    0x4(%eax),%eax
  803acf:	a3 30 50 80 00       	mov    %eax,0x805030
  803ad4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad7:	8b 40 04             	mov    0x4(%eax),%eax
  803ada:	85 c0                	test   %eax,%eax
  803adc:	74 0f                	je     803aed <realloc_block_FF+0x6cf>
  803ade:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae1:	8b 40 04             	mov    0x4(%eax),%eax
  803ae4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ae7:	8b 12                	mov    (%edx),%edx
  803ae9:	89 10                	mov    %edx,(%eax)
  803aeb:	eb 0a                	jmp    803af7 <realloc_block_FF+0x6d9>
  803aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af0:	8b 00                	mov    (%eax),%eax
  803af2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b0a:	a1 38 50 80 00       	mov    0x805038,%eax
  803b0f:	48                   	dec    %eax
  803b10:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b15:	83 ec 04             	sub    $0x4,%esp
  803b18:	6a 00                	push   $0x0
  803b1a:	ff 75 bc             	pushl  -0x44(%ebp)
  803b1d:	ff 75 b8             	pushl  -0x48(%ebp)
  803b20:	e8 06 e9 ff ff       	call   80242b <set_block_data>
  803b25:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b28:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2b:	eb 0a                	jmp    803b37 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b2d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b37:	c9                   	leave  
  803b38:	c3                   	ret    

00803b39 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b39:	55                   	push   %ebp
  803b3a:	89 e5                	mov    %esp,%ebp
  803b3c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b3f:	83 ec 04             	sub    $0x4,%esp
  803b42:	68 fc 47 80 00       	push   $0x8047fc
  803b47:	68 58 02 00 00       	push   $0x258
  803b4c:	68 05 47 80 00       	push   $0x804705
  803b51:	e8 3c ca ff ff       	call   800592 <_panic>

00803b56 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b56:	55                   	push   %ebp
  803b57:	89 e5                	mov    %esp,%ebp
  803b59:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b5c:	83 ec 04             	sub    $0x4,%esp
  803b5f:	68 24 48 80 00       	push   $0x804824
  803b64:	68 61 02 00 00       	push   $0x261
  803b69:	68 05 47 80 00       	push   $0x804705
  803b6e:	e8 1f ca ff ff       	call   800592 <_panic>
  803b73:	90                   	nop

00803b74 <__udivdi3>:
  803b74:	55                   	push   %ebp
  803b75:	57                   	push   %edi
  803b76:	56                   	push   %esi
  803b77:	53                   	push   %ebx
  803b78:	83 ec 1c             	sub    $0x1c,%esp
  803b7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b8b:	89 ca                	mov    %ecx,%edx
  803b8d:	89 f8                	mov    %edi,%eax
  803b8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b93:	85 f6                	test   %esi,%esi
  803b95:	75 2d                	jne    803bc4 <__udivdi3+0x50>
  803b97:	39 cf                	cmp    %ecx,%edi
  803b99:	77 65                	ja     803c00 <__udivdi3+0x8c>
  803b9b:	89 fd                	mov    %edi,%ebp
  803b9d:	85 ff                	test   %edi,%edi
  803b9f:	75 0b                	jne    803bac <__udivdi3+0x38>
  803ba1:	b8 01 00 00 00       	mov    $0x1,%eax
  803ba6:	31 d2                	xor    %edx,%edx
  803ba8:	f7 f7                	div    %edi
  803baa:	89 c5                	mov    %eax,%ebp
  803bac:	31 d2                	xor    %edx,%edx
  803bae:	89 c8                	mov    %ecx,%eax
  803bb0:	f7 f5                	div    %ebp
  803bb2:	89 c1                	mov    %eax,%ecx
  803bb4:	89 d8                	mov    %ebx,%eax
  803bb6:	f7 f5                	div    %ebp
  803bb8:	89 cf                	mov    %ecx,%edi
  803bba:	89 fa                	mov    %edi,%edx
  803bbc:	83 c4 1c             	add    $0x1c,%esp
  803bbf:	5b                   	pop    %ebx
  803bc0:	5e                   	pop    %esi
  803bc1:	5f                   	pop    %edi
  803bc2:	5d                   	pop    %ebp
  803bc3:	c3                   	ret    
  803bc4:	39 ce                	cmp    %ecx,%esi
  803bc6:	77 28                	ja     803bf0 <__udivdi3+0x7c>
  803bc8:	0f bd fe             	bsr    %esi,%edi
  803bcb:	83 f7 1f             	xor    $0x1f,%edi
  803bce:	75 40                	jne    803c10 <__udivdi3+0x9c>
  803bd0:	39 ce                	cmp    %ecx,%esi
  803bd2:	72 0a                	jb     803bde <__udivdi3+0x6a>
  803bd4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bd8:	0f 87 9e 00 00 00    	ja     803c7c <__udivdi3+0x108>
  803bde:	b8 01 00 00 00       	mov    $0x1,%eax
  803be3:	89 fa                	mov    %edi,%edx
  803be5:	83 c4 1c             	add    $0x1c,%esp
  803be8:	5b                   	pop    %ebx
  803be9:	5e                   	pop    %esi
  803bea:	5f                   	pop    %edi
  803beb:	5d                   	pop    %ebp
  803bec:	c3                   	ret    
  803bed:	8d 76 00             	lea    0x0(%esi),%esi
  803bf0:	31 ff                	xor    %edi,%edi
  803bf2:	31 c0                	xor    %eax,%eax
  803bf4:	89 fa                	mov    %edi,%edx
  803bf6:	83 c4 1c             	add    $0x1c,%esp
  803bf9:	5b                   	pop    %ebx
  803bfa:	5e                   	pop    %esi
  803bfb:	5f                   	pop    %edi
  803bfc:	5d                   	pop    %ebp
  803bfd:	c3                   	ret    
  803bfe:	66 90                	xchg   %ax,%ax
  803c00:	89 d8                	mov    %ebx,%eax
  803c02:	f7 f7                	div    %edi
  803c04:	31 ff                	xor    %edi,%edi
  803c06:	89 fa                	mov    %edi,%edx
  803c08:	83 c4 1c             	add    $0x1c,%esp
  803c0b:	5b                   	pop    %ebx
  803c0c:	5e                   	pop    %esi
  803c0d:	5f                   	pop    %edi
  803c0e:	5d                   	pop    %ebp
  803c0f:	c3                   	ret    
  803c10:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c15:	89 eb                	mov    %ebp,%ebx
  803c17:	29 fb                	sub    %edi,%ebx
  803c19:	89 f9                	mov    %edi,%ecx
  803c1b:	d3 e6                	shl    %cl,%esi
  803c1d:	89 c5                	mov    %eax,%ebp
  803c1f:	88 d9                	mov    %bl,%cl
  803c21:	d3 ed                	shr    %cl,%ebp
  803c23:	89 e9                	mov    %ebp,%ecx
  803c25:	09 f1                	or     %esi,%ecx
  803c27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c2b:	89 f9                	mov    %edi,%ecx
  803c2d:	d3 e0                	shl    %cl,%eax
  803c2f:	89 c5                	mov    %eax,%ebp
  803c31:	89 d6                	mov    %edx,%esi
  803c33:	88 d9                	mov    %bl,%cl
  803c35:	d3 ee                	shr    %cl,%esi
  803c37:	89 f9                	mov    %edi,%ecx
  803c39:	d3 e2                	shl    %cl,%edx
  803c3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c3f:	88 d9                	mov    %bl,%cl
  803c41:	d3 e8                	shr    %cl,%eax
  803c43:	09 c2                	or     %eax,%edx
  803c45:	89 d0                	mov    %edx,%eax
  803c47:	89 f2                	mov    %esi,%edx
  803c49:	f7 74 24 0c          	divl   0xc(%esp)
  803c4d:	89 d6                	mov    %edx,%esi
  803c4f:	89 c3                	mov    %eax,%ebx
  803c51:	f7 e5                	mul    %ebp
  803c53:	39 d6                	cmp    %edx,%esi
  803c55:	72 19                	jb     803c70 <__udivdi3+0xfc>
  803c57:	74 0b                	je     803c64 <__udivdi3+0xf0>
  803c59:	89 d8                	mov    %ebx,%eax
  803c5b:	31 ff                	xor    %edi,%edi
  803c5d:	e9 58 ff ff ff       	jmp    803bba <__udivdi3+0x46>
  803c62:	66 90                	xchg   %ax,%ax
  803c64:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c68:	89 f9                	mov    %edi,%ecx
  803c6a:	d3 e2                	shl    %cl,%edx
  803c6c:	39 c2                	cmp    %eax,%edx
  803c6e:	73 e9                	jae    803c59 <__udivdi3+0xe5>
  803c70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c73:	31 ff                	xor    %edi,%edi
  803c75:	e9 40 ff ff ff       	jmp    803bba <__udivdi3+0x46>
  803c7a:	66 90                	xchg   %ax,%ax
  803c7c:	31 c0                	xor    %eax,%eax
  803c7e:	e9 37 ff ff ff       	jmp    803bba <__udivdi3+0x46>
  803c83:	90                   	nop

00803c84 <__umoddi3>:
  803c84:	55                   	push   %ebp
  803c85:	57                   	push   %edi
  803c86:	56                   	push   %esi
  803c87:	53                   	push   %ebx
  803c88:	83 ec 1c             	sub    $0x1c,%esp
  803c8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ca3:	89 f3                	mov    %esi,%ebx
  803ca5:	89 fa                	mov    %edi,%edx
  803ca7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cab:	89 34 24             	mov    %esi,(%esp)
  803cae:	85 c0                	test   %eax,%eax
  803cb0:	75 1a                	jne    803ccc <__umoddi3+0x48>
  803cb2:	39 f7                	cmp    %esi,%edi
  803cb4:	0f 86 a2 00 00 00    	jbe    803d5c <__umoddi3+0xd8>
  803cba:	89 c8                	mov    %ecx,%eax
  803cbc:	89 f2                	mov    %esi,%edx
  803cbe:	f7 f7                	div    %edi
  803cc0:	89 d0                	mov    %edx,%eax
  803cc2:	31 d2                	xor    %edx,%edx
  803cc4:	83 c4 1c             	add    $0x1c,%esp
  803cc7:	5b                   	pop    %ebx
  803cc8:	5e                   	pop    %esi
  803cc9:	5f                   	pop    %edi
  803cca:	5d                   	pop    %ebp
  803ccb:	c3                   	ret    
  803ccc:	39 f0                	cmp    %esi,%eax
  803cce:	0f 87 ac 00 00 00    	ja     803d80 <__umoddi3+0xfc>
  803cd4:	0f bd e8             	bsr    %eax,%ebp
  803cd7:	83 f5 1f             	xor    $0x1f,%ebp
  803cda:	0f 84 ac 00 00 00    	je     803d8c <__umoddi3+0x108>
  803ce0:	bf 20 00 00 00       	mov    $0x20,%edi
  803ce5:	29 ef                	sub    %ebp,%edi
  803ce7:	89 fe                	mov    %edi,%esi
  803ce9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ced:	89 e9                	mov    %ebp,%ecx
  803cef:	d3 e0                	shl    %cl,%eax
  803cf1:	89 d7                	mov    %edx,%edi
  803cf3:	89 f1                	mov    %esi,%ecx
  803cf5:	d3 ef                	shr    %cl,%edi
  803cf7:	09 c7                	or     %eax,%edi
  803cf9:	89 e9                	mov    %ebp,%ecx
  803cfb:	d3 e2                	shl    %cl,%edx
  803cfd:	89 14 24             	mov    %edx,(%esp)
  803d00:	89 d8                	mov    %ebx,%eax
  803d02:	d3 e0                	shl    %cl,%eax
  803d04:	89 c2                	mov    %eax,%edx
  803d06:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d0a:	d3 e0                	shl    %cl,%eax
  803d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d10:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d14:	89 f1                	mov    %esi,%ecx
  803d16:	d3 e8                	shr    %cl,%eax
  803d18:	09 d0                	or     %edx,%eax
  803d1a:	d3 eb                	shr    %cl,%ebx
  803d1c:	89 da                	mov    %ebx,%edx
  803d1e:	f7 f7                	div    %edi
  803d20:	89 d3                	mov    %edx,%ebx
  803d22:	f7 24 24             	mull   (%esp)
  803d25:	89 c6                	mov    %eax,%esi
  803d27:	89 d1                	mov    %edx,%ecx
  803d29:	39 d3                	cmp    %edx,%ebx
  803d2b:	0f 82 87 00 00 00    	jb     803db8 <__umoddi3+0x134>
  803d31:	0f 84 91 00 00 00    	je     803dc8 <__umoddi3+0x144>
  803d37:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d3b:	29 f2                	sub    %esi,%edx
  803d3d:	19 cb                	sbb    %ecx,%ebx
  803d3f:	89 d8                	mov    %ebx,%eax
  803d41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d45:	d3 e0                	shl    %cl,%eax
  803d47:	89 e9                	mov    %ebp,%ecx
  803d49:	d3 ea                	shr    %cl,%edx
  803d4b:	09 d0                	or     %edx,%eax
  803d4d:	89 e9                	mov    %ebp,%ecx
  803d4f:	d3 eb                	shr    %cl,%ebx
  803d51:	89 da                	mov    %ebx,%edx
  803d53:	83 c4 1c             	add    $0x1c,%esp
  803d56:	5b                   	pop    %ebx
  803d57:	5e                   	pop    %esi
  803d58:	5f                   	pop    %edi
  803d59:	5d                   	pop    %ebp
  803d5a:	c3                   	ret    
  803d5b:	90                   	nop
  803d5c:	89 fd                	mov    %edi,%ebp
  803d5e:	85 ff                	test   %edi,%edi
  803d60:	75 0b                	jne    803d6d <__umoddi3+0xe9>
  803d62:	b8 01 00 00 00       	mov    $0x1,%eax
  803d67:	31 d2                	xor    %edx,%edx
  803d69:	f7 f7                	div    %edi
  803d6b:	89 c5                	mov    %eax,%ebp
  803d6d:	89 f0                	mov    %esi,%eax
  803d6f:	31 d2                	xor    %edx,%edx
  803d71:	f7 f5                	div    %ebp
  803d73:	89 c8                	mov    %ecx,%eax
  803d75:	f7 f5                	div    %ebp
  803d77:	89 d0                	mov    %edx,%eax
  803d79:	e9 44 ff ff ff       	jmp    803cc2 <__umoddi3+0x3e>
  803d7e:	66 90                	xchg   %ax,%ax
  803d80:	89 c8                	mov    %ecx,%eax
  803d82:	89 f2                	mov    %esi,%edx
  803d84:	83 c4 1c             	add    $0x1c,%esp
  803d87:	5b                   	pop    %ebx
  803d88:	5e                   	pop    %esi
  803d89:	5f                   	pop    %edi
  803d8a:	5d                   	pop    %ebp
  803d8b:	c3                   	ret    
  803d8c:	3b 04 24             	cmp    (%esp),%eax
  803d8f:	72 06                	jb     803d97 <__umoddi3+0x113>
  803d91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d95:	77 0f                	ja     803da6 <__umoddi3+0x122>
  803d97:	89 f2                	mov    %esi,%edx
  803d99:	29 f9                	sub    %edi,%ecx
  803d9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d9f:	89 14 24             	mov    %edx,(%esp)
  803da2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803da6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803daa:	8b 14 24             	mov    (%esp),%edx
  803dad:	83 c4 1c             	add    $0x1c,%esp
  803db0:	5b                   	pop    %ebx
  803db1:	5e                   	pop    %esi
  803db2:	5f                   	pop    %edi
  803db3:	5d                   	pop    %ebp
  803db4:	c3                   	ret    
  803db5:	8d 76 00             	lea    0x0(%esi),%esi
  803db8:	2b 04 24             	sub    (%esp),%eax
  803dbb:	19 fa                	sbb    %edi,%edx
  803dbd:	89 d1                	mov    %edx,%ecx
  803dbf:	89 c6                	mov    %eax,%esi
  803dc1:	e9 71 ff ff ff       	jmp    803d37 <__umoddi3+0xb3>
  803dc6:	66 90                	xchg   %ax,%ax
  803dc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dcc:	72 ea                	jb     803db8 <__umoddi3+0x134>
  803dce:	89 d9                	mov    %ebx,%ecx
  803dd0:	e9 62 ff ff ff       	jmp    803d37 <__umoddi3+0xb3>
