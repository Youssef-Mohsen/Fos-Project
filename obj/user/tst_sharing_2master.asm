
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
  80005c:	68 80 3d 80 00       	push   $0x803d80
  800061:	6a 14                	push   $0x14
  800063:	68 9c 3d 80 00       	push   $0x803d9c
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
  800082:	e8 f2 1a 00 00       	call   801b79 <sys_calculate_free_frames>
  800087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = smalloc("x", 4, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 04                	push   $0x4
  800091:	68 b7 3d 80 00       	push   $0x803db7
  800096:	e8 81 18 00 00       	call   80191c <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 bc 3d 80 00       	push   $0x803dbc
  8000b8:	e8 92 07 00 00       	call   80084f <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8000c0:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8000c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ca:	e8 aa 1a 00 00       	call   801b79 <sys_calculate_free_frames>
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
  8000f3:	e8 81 1a 00 00       	call   801b79 <sys_calculate_free_frames>
  8000f8:	29 c3                	sub    %eax,%ebx
  8000fa:	89 d8                	mov    %ebx,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800102:	50                   	push   %eax
  800103:	68 20 3e 80 00       	push   $0x803e20
  800108:	e8 42 07 00 00       	call   80084f <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800110:	e8 64 1a 00 00       	call   801b79 <sys_calculate_free_frames>
  800115:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = smalloc("y", 4, 0);
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	6a 00                	push   $0x0
  80011d:	6a 04                	push   $0x4
  80011f:	68 b8 3e 80 00       	push   $0x803eb8
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
  800146:	68 bc 3d 80 00       	push   $0x803dbc
  80014b:	e8 ff 06 00 00       	call   80084f <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  800153:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80015a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80015d:	e8 17 1a 00 00       	call   801b79 <sys_calculate_free_frames>
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
  800186:	e8 ee 19 00 00       	call   801b79 <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	50                   	push   %eax
  800196:	68 20 3e 80 00       	push   $0x803e20
  80019b:	e8 af 06 00 00       	call   80084f <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  8001a3:	e8 d1 19 00 00       	call   801b79 <sys_calculate_free_frames>
  8001a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = smalloc("z", 4, 1);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 01                	push   $0x1
  8001b0:	6a 04                	push   $0x4
  8001b2:	68 ba 3e 80 00       	push   $0x803eba
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
  8001d9:	68 bc 3d 80 00       	push   $0x803dbc
  8001de:	e8 6c 06 00 00       	call   80084f <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8001e6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001f0:	e8 84 19 00 00       	call   801b79 <sys_calculate_free_frames>
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
  800219:	e8 5b 19 00 00       	call   801b79 <sys_calculate_free_frames>
  80021e:	29 c3                	sub    %eax,%ebx
  800220:	89 d8                	mov    %ebx,%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	50                   	push   %eax
  800229:	68 20 3e 80 00       	push   $0x803e20
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
  80027f:	68 bc 3e 80 00       	push   $0x803ebc
  800284:	e8 4b 1a 00 00       	call   801cd4 <sys_create_env>
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
  8002b5:	68 bc 3e 80 00       	push   $0x803ebc
  8002ba:	e8 15 1a 00 00       	call   801cd4 <sys_create_env>
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
  8002eb:	68 bc 3e 80 00       	push   $0x803ebc
  8002f0:	e8 df 19 00 00       	call   801cd4 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8002fb:	e8 20 1b 00 00       	call   801e20 <rsttst>

	sys_run_env(id1);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 d0             	pushl  -0x30(%ebp)
  800306:	e8 e7 19 00 00       	call   801cf2 <sys_run_env>
  80030b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 cc             	pushl  -0x34(%ebp)
  800314:	e8 d9 19 00 00       	call   801cf2 <sys_run_env>
  800319:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 c8             	pushl  -0x38(%ebp)
  800322:	e8 cb 19 00 00       	call   801cf2 <sys_run_env>
  800327:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  80032a:	90                   	nop
  80032b:	e8 6a 1b 00 00       	call   801e9a <gettst>
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
  800349:	68 c8 3e 80 00       	push   $0x803ec8
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
  80036a:	68 14 3f 80 00       	push   $0x803f14
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
  80039d:	68 46 3f 80 00       	push   $0x803f46
  8003a2:	e8 2d 19 00 00       	call   801cd4 <sys_create_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b3:	e8 3a 19 00 00       	call   801cf2 <sys_run_env>
  8003b8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  8003bb:	90                   	nop
  8003bc:	e8 d9 1a 00 00       	call   801e9a <gettst>
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
  8003da:	68 c8 3e 80 00       	push   $0x803ec8
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
  8003f8:	e8 83 1a 00 00       	call   801e80 <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8003fd:	90                   	nop
  8003fe:	e8 97 1a 00 00       	call   801e9a <gettst>
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
  80041c:	68 c8 3e 80 00       	push   $0x803ec8
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
  800440:	68 54 3f 80 00       	push   $0x803f54
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
  800459:	e8 e4 18 00 00       	call   801d42 <sys_getenvindex>
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
  8004c7:	e8 fa 15 00 00       	call   801ac6 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004cc:	83 ec 0c             	sub    $0xc,%esp
  8004cf:	68 b0 3f 80 00       	push   $0x803fb0
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
  8004f7:	68 d8 3f 80 00       	push   $0x803fd8
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
  800528:	68 00 40 80 00       	push   $0x804000
  80052d:	e8 1d 03 00 00       	call   80084f <cprintf>
  800532:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800535:	a1 20 50 80 00       	mov    0x805020,%eax
  80053a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	50                   	push   %eax
  800544:	68 58 40 80 00       	push   $0x804058
  800549:	e8 01 03 00 00       	call   80084f <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 b0 3f 80 00       	push   $0x803fb0
  800559:	e8 f1 02 00 00       	call   80084f <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800561:	e8 7a 15 00 00       	call   801ae0 <sys_unlock_cons>
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
  800579:	e8 90 17 00 00       	call   801d0e <sys_destroy_env>
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
  80058a:	e8 e5 17 00 00       	call   801d74 <sys_exit_env>
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
  8005b3:	68 6c 40 80 00       	push   $0x80406c
  8005b8:	e8 92 02 00 00       	call   80084f <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005c0:	a1 00 50 80 00       	mov    0x805000,%eax
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	50                   	push   %eax
  8005cc:	68 71 40 80 00       	push   $0x804071
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
  8005f0:	68 8d 40 80 00       	push   $0x80408d
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
  80061f:	68 90 40 80 00       	push   $0x804090
  800624:	6a 26                	push   $0x26
  800626:	68 dc 40 80 00       	push   $0x8040dc
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
  8006f4:	68 e8 40 80 00       	push   $0x8040e8
  8006f9:	6a 3a                	push   $0x3a
  8006fb:	68 dc 40 80 00       	push   $0x8040dc
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
  800767:	68 3c 41 80 00       	push   $0x80413c
  80076c:	6a 44                	push   $0x44
  80076e:	68 dc 40 80 00       	push   $0x8040dc
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
  8007c1:	e8 be 12 00 00       	call   801a84 <sys_cputs>
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
  800838:	e8 47 12 00 00       	call   801a84 <sys_cputs>
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
  800882:	e8 3f 12 00 00       	call   801ac6 <sys_lock_cons>
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
  8008a2:	e8 39 12 00 00       	call   801ae0 <sys_unlock_cons>
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
  8008ec:	e8 2b 32 00 00       	call   803b1c <__udivdi3>
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
  80093c:	e8 eb 32 00 00       	call   803c2c <__umoddi3>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	05 b4 43 80 00       	add    $0x8043b4,%eax
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
  800a97:	8b 04 85 d8 43 80 00 	mov    0x8043d8(,%eax,4),%eax
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
  800b78:	8b 34 9d 20 42 80 00 	mov    0x804220(,%ebx,4),%esi
  800b7f:	85 f6                	test   %esi,%esi
  800b81:	75 19                	jne    800b9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b83:	53                   	push   %ebx
  800b84:	68 c5 43 80 00       	push   $0x8043c5
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
  800b9d:	68 ce 43 80 00       	push   $0x8043ce
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
  800bca:	be d1 43 80 00       	mov    $0x8043d1,%esi
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
  8015d5:	68 48 45 80 00       	push   $0x804548
  8015da:	68 3f 01 00 00       	push   $0x13f
  8015df:	68 6a 45 80 00       	push   $0x80456a
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
  8015f5:	e8 35 0a 00 00       	call   80202f <sys_sbrk>
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
  801670:	e8 3e 08 00 00       	call   801eb3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801675:	85 c0                	test   %eax,%eax
  801677:	74 16                	je     80168f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	e8 7e 0d 00 00       	call   802402 <alloc_block_FF>
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168a:	e9 8a 01 00 00       	jmp    801819 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80168f:	e8 50 08 00 00       	call   801ee4 <sys_isUHeapPlacementStrategyBESTFIT>
  801694:	85 c0                	test   %eax,%eax
  801696:	0f 84 7d 01 00 00    	je     801819 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	e8 17 12 00 00       	call   8028be <alloc_block_BF>
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
  801808:	e8 59 08 00 00       	call   802066 <sys_allocate_user_mem>
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
  801850:	e8 2d 08 00 00       	call   802082 <get_block_size>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 60 1a 00 00       	call   8032c6 <free_block>
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
  8018f8:	e8 4d 07 00 00       	call   80204a <sys_free_user_mem>
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
  801906:	68 78 45 80 00       	push   $0x804578
  80190b:	68 84 00 00 00       	push   $0x84
  801910:	68 a2 45 80 00       	push   $0x8045a2
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
  801978:	e8 d4 02 00 00       	call   801c51 <sys_createSharedObject>
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
  801999:	68 ae 45 80 00       	push   $0x8045ae
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
  8019ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	68 b4 45 80 00       	push   $0x8045b4
  8019b9:	68 a4 00 00 00       	push   $0xa4
  8019be:	68 a2 45 80 00       	push   $0x8045a2
  8019c3:	e8 ca eb ff ff       	call   800592 <_panic>

008019c8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	68 d8 45 80 00       	push   $0x8045d8
  8019d6:	68 bc 00 00 00       	push   $0xbc
  8019db:	68 a2 45 80 00       	push   $0x8045a2
  8019e0:	e8 ad eb ff ff       	call   800592 <_panic>

008019e5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	68 fc 45 80 00       	push   $0x8045fc
  8019f3:	68 d3 00 00 00       	push   $0xd3
  8019f8:	68 a2 45 80 00       	push   $0x8045a2
  8019fd:	e8 90 eb ff ff       	call   800592 <_panic>

00801a02 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	68 22 46 80 00       	push   $0x804622
  801a10:	68 df 00 00 00       	push   $0xdf
  801a15:	68 a2 45 80 00       	push   $0x8045a2
  801a1a:	e8 73 eb ff ff       	call   800592 <_panic>

00801a1f <shrink>:

}
void shrink(uint32 newSize)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	68 22 46 80 00       	push   $0x804622
  801a2d:	68 e4 00 00 00       	push   $0xe4
  801a32:	68 a2 45 80 00       	push   $0x8045a2
  801a37:	e8 56 eb ff ff       	call   800592 <_panic>

00801a3c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	68 22 46 80 00       	push   $0x804622
  801a4a:	68 e9 00 00 00       	push   $0xe9
  801a4f:	68 a2 45 80 00       	push   $0x8045a2
  801a54:	e8 39 eb ff ff       	call   800592 <_panic>

00801a59 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	57                   	push   %edi
  801a5d:	56                   	push   %esi
  801a5e:	53                   	push   %ebx
  801a5f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a6e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a71:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a74:	cd 30                	int    $0x30
  801a76:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5f                   	pop    %edi
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    

00801a84 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a90:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	52                   	push   %edx
  801a9c:	ff 75 0c             	pushl  0xc(%ebp)
  801a9f:	50                   	push   %eax
  801aa0:	6a 00                	push   $0x0
  801aa2:	e8 b2 ff ff ff       	call   801a59 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	90                   	nop
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_cgetc>:

int
sys_cgetc(void)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 02                	push   $0x2
  801abc:	e8 98 ff ff ff       	call   801a59 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 03                	push   $0x3
  801ad5:	e8 7f ff ff ff       	call   801a59 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 04                	push   $0x4
  801aef:	e8 65 ff ff ff       	call   801a59 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	90                   	nop
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	52                   	push   %edx
  801b0a:	50                   	push   %eax
  801b0b:	6a 08                	push   $0x8
  801b0d:	e8 47 ff ff ff       	call   801a59 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	56                   	push   %esi
  801b1b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b1c:	8b 75 18             	mov    0x18(%ebp),%esi
  801b1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	56                   	push   %esi
  801b2c:	53                   	push   %ebx
  801b2d:	51                   	push   %ecx
  801b2e:	52                   	push   %edx
  801b2f:	50                   	push   %eax
  801b30:	6a 09                	push   $0x9
  801b32:	e8 22 ff ff ff       	call   801a59 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5e                   	pop    %esi
  801b3f:	5d                   	pop    %ebp
  801b40:	c3                   	ret    

00801b41 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	52                   	push   %edx
  801b51:	50                   	push   %eax
  801b52:	6a 0a                	push   $0xa
  801b54:	e8 00 ff ff ff       	call   801a59 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	ff 75 08             	pushl  0x8(%ebp)
  801b6d:	6a 0b                	push   $0xb
  801b6f:	e8 e5 fe ff ff       	call   801a59 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 0c                	push   $0xc
  801b88:	e8 cc fe ff ff       	call   801a59 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 0d                	push   $0xd
  801ba1:	e8 b3 fe ff ff       	call   801a59 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 0e                	push   $0xe
  801bba:	e8 9a fe ff ff       	call   801a59 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 0f                	push   $0xf
  801bd3:	e8 81 fe ff ff       	call   801a59 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	6a 10                	push   $0x10
  801bed:	e8 67 fe ff ff       	call   801a59 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 11                	push   $0x11
  801c06:	e8 4e fe ff ff       	call   801a59 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	90                   	nop
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 04             	sub    $0x4,%esp
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c1d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	50                   	push   %eax
  801c2a:	6a 01                	push   $0x1
  801c2c:	e8 28 fe ff ff       	call   801a59 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
}
  801c34:	90                   	nop
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 14                	push   $0x14
  801c46:	e8 0e fe ff ff       	call   801a59 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	90                   	nop
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 04             	sub    $0x4,%esp
  801c57:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c5d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c60:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	6a 00                	push   $0x0
  801c69:	51                   	push   %ecx
  801c6a:	52                   	push   %edx
  801c6b:	ff 75 0c             	pushl  0xc(%ebp)
  801c6e:	50                   	push   %eax
  801c6f:	6a 15                	push   $0x15
  801c71:	e8 e3 fd ff ff       	call   801a59 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	52                   	push   %edx
  801c8b:	50                   	push   %eax
  801c8c:	6a 16                	push   $0x16
  801c8e:	e8 c6 fd ff ff       	call   801a59 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	51                   	push   %ecx
  801ca9:	52                   	push   %edx
  801caa:	50                   	push   %eax
  801cab:	6a 17                	push   $0x17
  801cad:	e8 a7 fd ff ff       	call   801a59 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	52                   	push   %edx
  801cc7:	50                   	push   %eax
  801cc8:	6a 18                	push   $0x18
  801cca:	e8 8a fd ff ff       	call   801a59 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	ff 75 14             	pushl  0x14(%ebp)
  801cdf:	ff 75 10             	pushl  0x10(%ebp)
  801ce2:	ff 75 0c             	pushl  0xc(%ebp)
  801ce5:	50                   	push   %eax
  801ce6:	6a 19                	push   $0x19
  801ce8:	e8 6c fd ff ff       	call   801a59 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	50                   	push   %eax
  801d01:	6a 1a                	push   $0x1a
  801d03:	e8 51 fd ff ff       	call   801a59 <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	90                   	nop
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	50                   	push   %eax
  801d1d:	6a 1b                	push   $0x1b
  801d1f:	e8 35 fd ff ff       	call   801a59 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 05                	push   $0x5
  801d38:	e8 1c fd ff ff       	call   801a59 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 06                	push   $0x6
  801d51:	e8 03 fd ff ff       	call   801a59 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 07                	push   $0x7
  801d6a:	e8 ea fc ff ff       	call   801a59 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_exit_env>:


void sys_exit_env(void)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 1c                	push   $0x1c
  801d83:	e8 d1 fc ff ff       	call   801a59 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	90                   	nop
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d94:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d97:	8d 50 04             	lea    0x4(%eax),%edx
  801d9a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	52                   	push   %edx
  801da4:	50                   	push   %eax
  801da5:	6a 1d                	push   $0x1d
  801da7:	e8 ad fc ff ff       	call   801a59 <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
	return result;
  801daf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801db5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801db8:	89 01                	mov    %eax,(%ecx)
  801dba:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	c9                   	leave  
  801dc1:	c2 04 00             	ret    $0x4

00801dc4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	ff 75 10             	pushl  0x10(%ebp)
  801dce:	ff 75 0c             	pushl  0xc(%ebp)
  801dd1:	ff 75 08             	pushl  0x8(%ebp)
  801dd4:	6a 13                	push   $0x13
  801dd6:	e8 7e fc ff ff       	call   801a59 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dde:	90                   	nop
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 1e                	push   $0x1e
  801df0:	e8 64 fc ff ff       	call   801a59 <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	83 ec 04             	sub    $0x4,%esp
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e06:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	50                   	push   %eax
  801e13:	6a 1f                	push   $0x1f
  801e15:	e8 3f fc ff ff       	call   801a59 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1d:	90                   	nop
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <rsttst>:
void rsttst()
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 21                	push   $0x21
  801e2f:	e8 25 fc ff ff       	call   801a59 <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
	return ;
  801e37:	90                   	nop
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	8b 45 14             	mov    0x14(%ebp),%eax
  801e43:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e46:	8b 55 18             	mov    0x18(%ebp),%edx
  801e49:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e4d:	52                   	push   %edx
  801e4e:	50                   	push   %eax
  801e4f:	ff 75 10             	pushl  0x10(%ebp)
  801e52:	ff 75 0c             	pushl  0xc(%ebp)
  801e55:	ff 75 08             	pushl  0x8(%ebp)
  801e58:	6a 20                	push   $0x20
  801e5a:	e8 fa fb ff ff       	call   801a59 <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e62:	90                   	nop
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <chktst>:
void chktst(uint32 n)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	ff 75 08             	pushl  0x8(%ebp)
  801e73:	6a 22                	push   $0x22
  801e75:	e8 df fb ff ff       	call   801a59 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7d:	90                   	nop
}
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <inctst>:

void inctst()
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 23                	push   $0x23
  801e8f:	e8 c5 fb ff ff       	call   801a59 <syscall>
  801e94:	83 c4 18             	add    $0x18,%esp
	return ;
  801e97:	90                   	nop
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <gettst>:
uint32 gettst()
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 24                	push   $0x24
  801ea9:	e8 ab fb ff ff       	call   801a59 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 25                	push   $0x25
  801ec5:	e8 8f fb ff ff       	call   801a59 <syscall>
  801eca:	83 c4 18             	add    $0x18,%esp
  801ecd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ed0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ed4:	75 07                	jne    801edd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ed6:	b8 01 00 00 00       	mov    $0x1,%eax
  801edb:	eb 05                	jmp    801ee2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801edd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 25                	push   $0x25
  801ef6:	e8 5e fb ff ff       	call   801a59 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
  801efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f01:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f05:	75 07                	jne    801f0e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f07:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0c:	eb 05                	jmp    801f13 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 25                	push   $0x25
  801f27:	e8 2d fb ff ff       	call   801a59 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
  801f2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f32:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f36:	75 07                	jne    801f3f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f38:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3d:	eb 05                	jmp    801f44 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 25                	push   $0x25
  801f58:	e8 fc fa ff ff       	call   801a59 <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
  801f60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f63:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f67:	75 07                	jne    801f70 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f69:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6e:	eb 05                	jmp    801f75 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 08             	pushl  0x8(%ebp)
  801f85:	6a 26                	push   $0x26
  801f87:	e8 cd fa ff ff       	call   801a59 <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8f:	90                   	nop
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f96:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	53                   	push   %ebx
  801fa5:	51                   	push   %ecx
  801fa6:	52                   	push   %edx
  801fa7:	50                   	push   %eax
  801fa8:	6a 27                	push   $0x27
  801faa:	e8 aa fa ff ff       	call   801a59 <syscall>
  801faf:	83 c4 18             	add    $0x18,%esp
}
  801fb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	52                   	push   %edx
  801fc7:	50                   	push   %eax
  801fc8:	6a 28                	push   $0x28
  801fca:	e8 8a fa ff ff       	call   801a59 <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fd7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	51                   	push   %ecx
  801fe3:	ff 75 10             	pushl  0x10(%ebp)
  801fe6:	52                   	push   %edx
  801fe7:	50                   	push   %eax
  801fe8:	6a 29                	push   $0x29
  801fea:	e8 6a fa ff ff       	call   801a59 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	ff 75 10             	pushl  0x10(%ebp)
  801ffe:	ff 75 0c             	pushl  0xc(%ebp)
  802001:	ff 75 08             	pushl  0x8(%ebp)
  802004:	6a 12                	push   $0x12
  802006:	e8 4e fa ff ff       	call   801a59 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
	return ;
  80200e:	90                   	nop
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802014:	8b 55 0c             	mov    0xc(%ebp),%edx
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	52                   	push   %edx
  802021:	50                   	push   %eax
  802022:	6a 2a                	push   $0x2a
  802024:	e8 30 fa ff ff       	call   801a59 <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
	return;
  80202c:	90                   	nop
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	50                   	push   %eax
  80203e:	6a 2b                	push   $0x2b
  802040:	e8 14 fa ff ff       	call   801a59 <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	ff 75 0c             	pushl  0xc(%ebp)
  802056:	ff 75 08             	pushl  0x8(%ebp)
  802059:	6a 2c                	push   $0x2c
  80205b:	e8 f9 f9 ff ff       	call   801a59 <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
	return;
  802063:	90                   	nop
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	ff 75 0c             	pushl  0xc(%ebp)
  802072:	ff 75 08             	pushl  0x8(%ebp)
  802075:	6a 2d                	push   $0x2d
  802077:	e8 dd f9 ff ff       	call   801a59 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
	return;
  80207f:	90                   	nop
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	83 e8 04             	sub    $0x4,%eax
  80208e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802091:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802094:	8b 00                	mov    (%eax),%eax
  802096:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	83 e8 04             	sub    $0x4,%eax
  8020a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ad:	8b 00                	mov    (%eax),%eax
  8020af:	83 e0 01             	and    $0x1,%eax
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	0f 94 c0             	sete   %al
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c9:	83 f8 02             	cmp    $0x2,%eax
  8020cc:	74 2b                	je     8020f9 <alloc_block+0x40>
  8020ce:	83 f8 02             	cmp    $0x2,%eax
  8020d1:	7f 07                	jg     8020da <alloc_block+0x21>
  8020d3:	83 f8 01             	cmp    $0x1,%eax
  8020d6:	74 0e                	je     8020e6 <alloc_block+0x2d>
  8020d8:	eb 58                	jmp    802132 <alloc_block+0x79>
  8020da:	83 f8 03             	cmp    $0x3,%eax
  8020dd:	74 2d                	je     80210c <alloc_block+0x53>
  8020df:	83 f8 04             	cmp    $0x4,%eax
  8020e2:	74 3b                	je     80211f <alloc_block+0x66>
  8020e4:	eb 4c                	jmp    802132 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020e6:	83 ec 0c             	sub    $0xc,%esp
  8020e9:	ff 75 08             	pushl  0x8(%ebp)
  8020ec:	e8 11 03 00 00       	call   802402 <alloc_block_FF>
  8020f1:	83 c4 10             	add    $0x10,%esp
  8020f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f7:	eb 4a                	jmp    802143 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020f9:	83 ec 0c             	sub    $0xc,%esp
  8020fc:	ff 75 08             	pushl  0x8(%ebp)
  8020ff:	e8 fa 19 00 00       	call   803afe <alloc_block_NF>
  802104:	83 c4 10             	add    $0x10,%esp
  802107:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80210a:	eb 37                	jmp    802143 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80210c:	83 ec 0c             	sub    $0xc,%esp
  80210f:	ff 75 08             	pushl  0x8(%ebp)
  802112:	e8 a7 07 00 00       	call   8028be <alloc_block_BF>
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80211d:	eb 24                	jmp    802143 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80211f:	83 ec 0c             	sub    $0xc,%esp
  802122:	ff 75 08             	pushl  0x8(%ebp)
  802125:	e8 b7 19 00 00       	call   803ae1 <alloc_block_WF>
  80212a:	83 c4 10             	add    $0x10,%esp
  80212d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802130:	eb 11                	jmp    802143 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802132:	83 ec 0c             	sub    $0xc,%esp
  802135:	68 34 46 80 00       	push   $0x804634
  80213a:	e8 10 e7 ff ff       	call   80084f <cprintf>
  80213f:	83 c4 10             	add    $0x10,%esp
		break;
  802142:	90                   	nop
	}
	return va;
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	53                   	push   %ebx
  80214c:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80214f:	83 ec 0c             	sub    $0xc,%esp
  802152:	68 54 46 80 00       	push   $0x804654
  802157:	e8 f3 e6 ff ff       	call   80084f <cprintf>
  80215c:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80215f:	83 ec 0c             	sub    $0xc,%esp
  802162:	68 7f 46 80 00       	push   $0x80467f
  802167:	e8 e3 e6 ff ff       	call   80084f <cprintf>
  80216c:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802175:	eb 37                	jmp    8021ae <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802177:	83 ec 0c             	sub    $0xc,%esp
  80217a:	ff 75 f4             	pushl  -0xc(%ebp)
  80217d:	e8 19 ff ff ff       	call   80209b <is_free_block>
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	0f be d8             	movsbl %al,%ebx
  802188:	83 ec 0c             	sub    $0xc,%esp
  80218b:	ff 75 f4             	pushl  -0xc(%ebp)
  80218e:	e8 ef fe ff ff       	call   802082 <get_block_size>
  802193:	83 c4 10             	add    $0x10,%esp
  802196:	83 ec 04             	sub    $0x4,%esp
  802199:	53                   	push   %ebx
  80219a:	50                   	push   %eax
  80219b:	68 97 46 80 00       	push   $0x804697
  8021a0:	e8 aa e6 ff ff       	call   80084f <cprintf>
  8021a5:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b2:	74 07                	je     8021bb <print_blocks_list+0x73>
  8021b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b7:	8b 00                	mov    (%eax),%eax
  8021b9:	eb 05                	jmp    8021c0 <print_blocks_list+0x78>
  8021bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c0:	89 45 10             	mov    %eax,0x10(%ebp)
  8021c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	75 ad                	jne    802177 <print_blocks_list+0x2f>
  8021ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ce:	75 a7                	jne    802177 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021d0:	83 ec 0c             	sub    $0xc,%esp
  8021d3:	68 54 46 80 00       	push   $0x804654
  8021d8:	e8 72 e6 ff ff       	call   80084f <cprintf>
  8021dd:	83 c4 10             	add    $0x10,%esp

}
  8021e0:	90                   	nop
  8021e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ef:	83 e0 01             	and    $0x1,%eax
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	74 03                	je     8021f9 <initialize_dynamic_allocator+0x13>
  8021f6:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021fd:	0f 84 c7 01 00 00    	je     8023ca <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802203:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80220a:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80220d:	8b 55 08             	mov    0x8(%ebp),%edx
  802210:	8b 45 0c             	mov    0xc(%ebp),%eax
  802213:	01 d0                	add    %edx,%eax
  802215:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80221a:	0f 87 ad 01 00 00    	ja     8023cd <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	85 c0                	test   %eax,%eax
  802225:	0f 89 a5 01 00 00    	jns    8023d0 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80222b:	8b 55 08             	mov    0x8(%ebp),%edx
  80222e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802231:	01 d0                	add    %edx,%eax
  802233:	83 e8 04             	sub    $0x4,%eax
  802236:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80223b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802242:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802247:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224a:	e9 87 00 00 00       	jmp    8022d6 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80224f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802253:	75 14                	jne    802269 <initialize_dynamic_allocator+0x83>
  802255:	83 ec 04             	sub    $0x4,%esp
  802258:	68 af 46 80 00       	push   $0x8046af
  80225d:	6a 79                	push   $0x79
  80225f:	68 cd 46 80 00       	push   $0x8046cd
  802264:	e8 29 e3 ff ff       	call   800592 <_panic>
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 00                	mov    (%eax),%eax
  80226e:	85 c0                	test   %eax,%eax
  802270:	74 10                	je     802282 <initialize_dynamic_allocator+0x9c>
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 00                	mov    (%eax),%eax
  802277:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227a:	8b 52 04             	mov    0x4(%edx),%edx
  80227d:	89 50 04             	mov    %edx,0x4(%eax)
  802280:	eb 0b                	jmp    80228d <initialize_dynamic_allocator+0xa7>
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 40 04             	mov    0x4(%eax),%eax
  802288:	a3 30 50 80 00       	mov    %eax,0x805030
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	8b 40 04             	mov    0x4(%eax),%eax
  802293:	85 c0                	test   %eax,%eax
  802295:	74 0f                	je     8022a6 <initialize_dynamic_allocator+0xc0>
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	8b 40 04             	mov    0x4(%eax),%eax
  80229d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a0:	8b 12                	mov    (%edx),%edx
  8022a2:	89 10                	mov    %edx,(%eax)
  8022a4:	eb 0a                	jmp    8022b0 <initialize_dynamic_allocator+0xca>
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	8b 00                	mov    (%eax),%eax
  8022ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8022c8:	48                   	dec    %eax
  8022c9:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8022ce:	a1 34 50 80 00       	mov    0x805034,%eax
  8022d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022da:	74 07                	je     8022e3 <initialize_dynamic_allocator+0xfd>
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	8b 00                	mov    (%eax),%eax
  8022e1:	eb 05                	jmp    8022e8 <initialize_dynamic_allocator+0x102>
  8022e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e8:	a3 34 50 80 00       	mov    %eax,0x805034
  8022ed:	a1 34 50 80 00       	mov    0x805034,%eax
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	0f 85 55 ff ff ff    	jne    80224f <initialize_dynamic_allocator+0x69>
  8022fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fe:	0f 85 4b ff ff ff    	jne    80224f <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80230a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802313:	a1 44 50 80 00       	mov    0x805044,%eax
  802318:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80231d:	a1 40 50 80 00       	mov    0x805040,%eax
  802322:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	83 c0 08             	add    $0x8,%eax
  80232e:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	83 c0 04             	add    $0x4,%eax
  802337:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233a:	83 ea 08             	sub    $0x8,%edx
  80233d:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80233f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	01 d0                	add    %edx,%eax
  802347:	83 e8 08             	sub    $0x8,%eax
  80234a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234d:	83 ea 08             	sub    $0x8,%edx
  802350:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802352:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802355:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80235b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802365:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802369:	75 17                	jne    802382 <initialize_dynamic_allocator+0x19c>
  80236b:	83 ec 04             	sub    $0x4,%esp
  80236e:	68 e8 46 80 00       	push   $0x8046e8
  802373:	68 90 00 00 00       	push   $0x90
  802378:	68 cd 46 80 00       	push   $0x8046cd
  80237d:	e8 10 e2 ff ff       	call   800592 <_panic>
  802382:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238b:	89 10                	mov    %edx,(%eax)
  80238d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	85 c0                	test   %eax,%eax
  802394:	74 0d                	je     8023a3 <initialize_dynamic_allocator+0x1bd>
  802396:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80239b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80239e:	89 50 04             	mov    %edx,0x4(%eax)
  8023a1:	eb 08                	jmp    8023ab <initialize_dynamic_allocator+0x1c5>
  8023a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8023c2:	40                   	inc    %eax
  8023c3:	a3 38 50 80 00       	mov    %eax,0x805038
  8023c8:	eb 07                	jmp    8023d1 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8023ca:	90                   	nop
  8023cb:	eb 04                	jmp    8023d1 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023cd:	90                   	nop
  8023ce:	eb 01                	jmp    8023d1 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8023d0:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8023d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d9:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e5:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	83 e8 04             	sub    $0x4,%eax
  8023ed:	8b 00                	mov    (%eax),%eax
  8023ef:	83 e0 fe             	and    $0xfffffffe,%eax
  8023f2:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	01 c2                	add    %eax,%edx
  8023fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fd:	89 02                	mov    %eax,(%edx)
}
  8023ff:	90                   	nop
  802400:	5d                   	pop    %ebp
  802401:	c3                   	ret    

00802402 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	83 e0 01             	and    $0x1,%eax
  80240e:	85 c0                	test   %eax,%eax
  802410:	74 03                	je     802415 <alloc_block_FF+0x13>
  802412:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802415:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802419:	77 07                	ja     802422 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80241b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802422:	a1 24 50 80 00       	mov    0x805024,%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	75 73                	jne    80249e <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	83 c0 10             	add    $0x10,%eax
  802431:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802434:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80243b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802441:	01 d0                	add    %edx,%eax
  802443:	48                   	dec    %eax
  802444:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80244a:	ba 00 00 00 00       	mov    $0x0,%edx
  80244f:	f7 75 ec             	divl   -0x14(%ebp)
  802452:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802455:	29 d0                	sub    %edx,%eax
  802457:	c1 e8 0c             	shr    $0xc,%eax
  80245a:	83 ec 0c             	sub    $0xc,%esp
  80245d:	50                   	push   %eax
  80245e:	e8 86 f1 ff ff       	call   8015e9 <sbrk>
  802463:	83 c4 10             	add    $0x10,%esp
  802466:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802469:	83 ec 0c             	sub    $0xc,%esp
  80246c:	6a 00                	push   $0x0
  80246e:	e8 76 f1 ff ff       	call   8015e9 <sbrk>
  802473:	83 c4 10             	add    $0x10,%esp
  802476:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802479:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80247c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80247f:	83 ec 08             	sub    $0x8,%esp
  802482:	50                   	push   %eax
  802483:	ff 75 e4             	pushl  -0x1c(%ebp)
  802486:	e8 5b fd ff ff       	call   8021e6 <initialize_dynamic_allocator>
  80248b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80248e:	83 ec 0c             	sub    $0xc,%esp
  802491:	68 0b 47 80 00       	push   $0x80470b
  802496:	e8 b4 e3 ff ff       	call   80084f <cprintf>
  80249b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80249e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024a2:	75 0a                	jne    8024ae <alloc_block_FF+0xac>
	        return NULL;
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a9:	e9 0e 04 00 00       	jmp    8028bc <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8024ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024b5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bd:	e9 f3 02 00 00       	jmp    8027b5 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8024c8:	83 ec 0c             	sub    $0xc,%esp
  8024cb:	ff 75 bc             	pushl  -0x44(%ebp)
  8024ce:	e8 af fb ff ff       	call   802082 <get_block_size>
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	83 c0 08             	add    $0x8,%eax
  8024df:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024e2:	0f 87 c5 02 00 00    	ja     8027ad <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	83 c0 18             	add    $0x18,%eax
  8024ee:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024f1:	0f 87 19 02 00 00    	ja     802710 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024fa:	2b 45 08             	sub    0x8(%ebp),%eax
  8024fd:	83 e8 08             	sub    $0x8,%eax
  802500:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	8d 50 08             	lea    0x8(%eax),%edx
  802509:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80250c:	01 d0                	add    %edx,%eax
  80250e:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802511:	8b 45 08             	mov    0x8(%ebp),%eax
  802514:	83 c0 08             	add    $0x8,%eax
  802517:	83 ec 04             	sub    $0x4,%esp
  80251a:	6a 01                	push   $0x1
  80251c:	50                   	push   %eax
  80251d:	ff 75 bc             	pushl  -0x44(%ebp)
  802520:	e8 ae fe ff ff       	call   8023d3 <set_block_data>
  802525:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 40 04             	mov    0x4(%eax),%eax
  80252e:	85 c0                	test   %eax,%eax
  802530:	75 68                	jne    80259a <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802532:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802536:	75 17                	jne    80254f <alloc_block_FF+0x14d>
  802538:	83 ec 04             	sub    $0x4,%esp
  80253b:	68 e8 46 80 00       	push   $0x8046e8
  802540:	68 d7 00 00 00       	push   $0xd7
  802545:	68 cd 46 80 00       	push   $0x8046cd
  80254a:	e8 43 e0 ff ff       	call   800592 <_panic>
  80254f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802555:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802558:	89 10                	mov    %edx,(%eax)
  80255a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80255d:	8b 00                	mov    (%eax),%eax
  80255f:	85 c0                	test   %eax,%eax
  802561:	74 0d                	je     802570 <alloc_block_FF+0x16e>
  802563:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802568:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80256b:	89 50 04             	mov    %edx,0x4(%eax)
  80256e:	eb 08                	jmp    802578 <alloc_block_FF+0x176>
  802570:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802573:	a3 30 50 80 00       	mov    %eax,0x805030
  802578:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80257b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802580:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802583:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80258a:	a1 38 50 80 00       	mov    0x805038,%eax
  80258f:	40                   	inc    %eax
  802590:	a3 38 50 80 00       	mov    %eax,0x805038
  802595:	e9 dc 00 00 00       	jmp    802676 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	8b 00                	mov    (%eax),%eax
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	75 65                	jne    802608 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025a3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025a7:	75 17                	jne    8025c0 <alloc_block_FF+0x1be>
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	68 1c 47 80 00       	push   $0x80471c
  8025b1:	68 db 00 00 00       	push   $0xdb
  8025b6:	68 cd 46 80 00       	push   $0x8046cd
  8025bb:	e8 d2 df ff ff       	call   800592 <_panic>
  8025c0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8025c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c9:	89 50 04             	mov    %edx,0x4(%eax)
  8025cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025cf:	8b 40 04             	mov    0x4(%eax),%eax
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	74 0c                	je     8025e2 <alloc_block_FF+0x1e0>
  8025d6:	a1 30 50 80 00       	mov    0x805030,%eax
  8025db:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025de:	89 10                	mov    %edx,(%eax)
  8025e0:	eb 08                	jmp    8025ea <alloc_block_FF+0x1e8>
  8025e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ed:	a3 30 50 80 00       	mov    %eax,0x805030
  8025f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fb:	a1 38 50 80 00       	mov    0x805038,%eax
  802600:	40                   	inc    %eax
  802601:	a3 38 50 80 00       	mov    %eax,0x805038
  802606:	eb 6e                	jmp    802676 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260c:	74 06                	je     802614 <alloc_block_FF+0x212>
  80260e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802612:	75 17                	jne    80262b <alloc_block_FF+0x229>
  802614:	83 ec 04             	sub    $0x4,%esp
  802617:	68 40 47 80 00       	push   $0x804740
  80261c:	68 df 00 00 00       	push   $0xdf
  802621:	68 cd 46 80 00       	push   $0x8046cd
  802626:	e8 67 df ff ff       	call   800592 <_panic>
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 10                	mov    (%eax),%edx
  802630:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802633:	89 10                	mov    %edx,(%eax)
  802635:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802638:	8b 00                	mov    (%eax),%eax
  80263a:	85 c0                	test   %eax,%eax
  80263c:	74 0b                	je     802649 <alloc_block_FF+0x247>
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 00                	mov    (%eax),%eax
  802643:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802646:	89 50 04             	mov    %edx,0x4(%eax)
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80264f:	89 10                	mov    %edx,(%eax)
  802651:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802657:	89 50 04             	mov    %edx,0x4(%eax)
  80265a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80265d:	8b 00                	mov    (%eax),%eax
  80265f:	85 c0                	test   %eax,%eax
  802661:	75 08                	jne    80266b <alloc_block_FF+0x269>
  802663:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802666:	a3 30 50 80 00       	mov    %eax,0x805030
  80266b:	a1 38 50 80 00       	mov    0x805038,%eax
  802670:	40                   	inc    %eax
  802671:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267a:	75 17                	jne    802693 <alloc_block_FF+0x291>
  80267c:	83 ec 04             	sub    $0x4,%esp
  80267f:	68 af 46 80 00       	push   $0x8046af
  802684:	68 e1 00 00 00       	push   $0xe1
  802689:	68 cd 46 80 00       	push   $0x8046cd
  80268e:	e8 ff de ff ff       	call   800592 <_panic>
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 00                	mov    (%eax),%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	74 10                	je     8026ac <alloc_block_FF+0x2aa>
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a4:	8b 52 04             	mov    0x4(%edx),%edx
  8026a7:	89 50 04             	mov    %edx,0x4(%eax)
  8026aa:	eb 0b                	jmp    8026b7 <alloc_block_FF+0x2b5>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 40 04             	mov    0x4(%eax),%eax
  8026b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 40 04             	mov    0x4(%eax),%eax
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	74 0f                	je     8026d0 <alloc_block_FF+0x2ce>
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 40 04             	mov    0x4(%eax),%eax
  8026c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ca:	8b 12                	mov    (%edx),%edx
  8026cc:	89 10                	mov    %edx,(%eax)
  8026ce:	eb 0a                	jmp    8026da <alloc_block_FF+0x2d8>
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8026f2:	48                   	dec    %eax
  8026f3:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8026f8:	83 ec 04             	sub    $0x4,%esp
  8026fb:	6a 00                	push   $0x0
  8026fd:	ff 75 b4             	pushl  -0x4c(%ebp)
  802700:	ff 75 b0             	pushl  -0x50(%ebp)
  802703:	e8 cb fc ff ff       	call   8023d3 <set_block_data>
  802708:	83 c4 10             	add    $0x10,%esp
  80270b:	e9 95 00 00 00       	jmp    8027a5 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	6a 01                	push   $0x1
  802715:	ff 75 b8             	pushl  -0x48(%ebp)
  802718:	ff 75 bc             	pushl  -0x44(%ebp)
  80271b:	e8 b3 fc ff ff       	call   8023d3 <set_block_data>
  802720:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802727:	75 17                	jne    802740 <alloc_block_FF+0x33e>
  802729:	83 ec 04             	sub    $0x4,%esp
  80272c:	68 af 46 80 00       	push   $0x8046af
  802731:	68 e8 00 00 00       	push   $0xe8
  802736:	68 cd 46 80 00       	push   $0x8046cd
  80273b:	e8 52 de ff ff       	call   800592 <_panic>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	85 c0                	test   %eax,%eax
  802747:	74 10                	je     802759 <alloc_block_FF+0x357>
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802751:	8b 52 04             	mov    0x4(%edx),%edx
  802754:	89 50 04             	mov    %edx,0x4(%eax)
  802757:	eb 0b                	jmp    802764 <alloc_block_FF+0x362>
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 40 04             	mov    0x4(%eax),%eax
  80275f:	a3 30 50 80 00       	mov    %eax,0x805030
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 40 04             	mov    0x4(%eax),%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	74 0f                	je     80277d <alloc_block_FF+0x37b>
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 40 04             	mov    0x4(%eax),%eax
  802774:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802777:	8b 12                	mov    (%edx),%edx
  802779:	89 10                	mov    %edx,(%eax)
  80277b:	eb 0a                	jmp    802787 <alloc_block_FF+0x385>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279a:	a1 38 50 80 00       	mov    0x805038,%eax
  80279f:	48                   	dec    %eax
  8027a0:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8027a5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027a8:	e9 0f 01 00 00       	jmp    8028bc <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027ad:	a1 34 50 80 00       	mov    0x805034,%eax
  8027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b9:	74 07                	je     8027c2 <alloc_block_FF+0x3c0>
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	eb 05                	jmp    8027c7 <alloc_block_FF+0x3c5>
  8027c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c7:	a3 34 50 80 00       	mov    %eax,0x805034
  8027cc:	a1 34 50 80 00       	mov    0x805034,%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	0f 85 e9 fc ff ff    	jne    8024c2 <alloc_block_FF+0xc0>
  8027d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027dd:	0f 85 df fc ff ff    	jne    8024c2 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	83 c0 08             	add    $0x8,%eax
  8027e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027ec:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027f9:	01 d0                	add    %edx,%eax
  8027fb:	48                   	dec    %eax
  8027fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802802:	ba 00 00 00 00       	mov    $0x0,%edx
  802807:	f7 75 d8             	divl   -0x28(%ebp)
  80280a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80280d:	29 d0                	sub    %edx,%eax
  80280f:	c1 e8 0c             	shr    $0xc,%eax
  802812:	83 ec 0c             	sub    $0xc,%esp
  802815:	50                   	push   %eax
  802816:	e8 ce ed ff ff       	call   8015e9 <sbrk>
  80281b:	83 c4 10             	add    $0x10,%esp
  80281e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802821:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802825:	75 0a                	jne    802831 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802827:	b8 00 00 00 00       	mov    $0x0,%eax
  80282c:	e9 8b 00 00 00       	jmp    8028bc <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802831:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802838:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80283b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283e:	01 d0                	add    %edx,%eax
  802840:	48                   	dec    %eax
  802841:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802844:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802847:	ba 00 00 00 00       	mov    $0x0,%edx
  80284c:	f7 75 cc             	divl   -0x34(%ebp)
  80284f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802852:	29 d0                	sub    %edx,%eax
  802854:	8d 50 fc             	lea    -0x4(%eax),%edx
  802857:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80285a:	01 d0                	add    %edx,%eax
  80285c:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802861:	a1 40 50 80 00       	mov    0x805040,%eax
  802866:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80286c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802873:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802876:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802879:	01 d0                	add    %edx,%eax
  80287b:	48                   	dec    %eax
  80287c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80287f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802882:	ba 00 00 00 00       	mov    $0x0,%edx
  802887:	f7 75 c4             	divl   -0x3c(%ebp)
  80288a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80288d:	29 d0                	sub    %edx,%eax
  80288f:	83 ec 04             	sub    $0x4,%esp
  802892:	6a 01                	push   $0x1
  802894:	50                   	push   %eax
  802895:	ff 75 d0             	pushl  -0x30(%ebp)
  802898:	e8 36 fb ff ff       	call   8023d3 <set_block_data>
  80289d:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8028a0:	83 ec 0c             	sub    $0xc,%esp
  8028a3:	ff 75 d0             	pushl  -0x30(%ebp)
  8028a6:	e8 1b 0a 00 00       	call   8032c6 <free_block>
  8028ab:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8028ae:	83 ec 0c             	sub    $0xc,%esp
  8028b1:	ff 75 08             	pushl  0x8(%ebp)
  8028b4:	e8 49 fb ff ff       	call   802402 <alloc_block_FF>
  8028b9:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028bc:	c9                   	leave  
  8028bd:	c3                   	ret    

008028be <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028be:	55                   	push   %ebp
  8028bf:	89 e5                	mov    %esp,%ebp
  8028c1:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	83 e0 01             	and    $0x1,%eax
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	74 03                	je     8028d1 <alloc_block_BF+0x13>
  8028ce:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028d1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028d5:	77 07                	ja     8028de <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028d7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028de:	a1 24 50 80 00       	mov    0x805024,%eax
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	75 73                	jne    80295a <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	83 c0 10             	add    $0x10,%eax
  8028ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028f0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028fd:	01 d0                	add    %edx,%eax
  8028ff:	48                   	dec    %eax
  802900:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802903:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802906:	ba 00 00 00 00       	mov    $0x0,%edx
  80290b:	f7 75 e0             	divl   -0x20(%ebp)
  80290e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802911:	29 d0                	sub    %edx,%eax
  802913:	c1 e8 0c             	shr    $0xc,%eax
  802916:	83 ec 0c             	sub    $0xc,%esp
  802919:	50                   	push   %eax
  80291a:	e8 ca ec ff ff       	call   8015e9 <sbrk>
  80291f:	83 c4 10             	add    $0x10,%esp
  802922:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802925:	83 ec 0c             	sub    $0xc,%esp
  802928:	6a 00                	push   $0x0
  80292a:	e8 ba ec ff ff       	call   8015e9 <sbrk>
  80292f:	83 c4 10             	add    $0x10,%esp
  802932:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802935:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802938:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80293b:	83 ec 08             	sub    $0x8,%esp
  80293e:	50                   	push   %eax
  80293f:	ff 75 d8             	pushl  -0x28(%ebp)
  802942:	e8 9f f8 ff ff       	call   8021e6 <initialize_dynamic_allocator>
  802947:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80294a:	83 ec 0c             	sub    $0xc,%esp
  80294d:	68 0b 47 80 00       	push   $0x80470b
  802952:	e8 f8 de ff ff       	call   80084f <cprintf>
  802957:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80295a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802961:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802968:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80296f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802976:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80297b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297e:	e9 1d 01 00 00       	jmp    802aa0 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802989:	83 ec 0c             	sub    $0xc,%esp
  80298c:	ff 75 a8             	pushl  -0x58(%ebp)
  80298f:	e8 ee f6 ff ff       	call   802082 <get_block_size>
  802994:	83 c4 10             	add    $0x10,%esp
  802997:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	83 c0 08             	add    $0x8,%eax
  8029a0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029a3:	0f 87 ef 00 00 00    	ja     802a98 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	83 c0 18             	add    $0x18,%eax
  8029af:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029b2:	77 1d                	ja     8029d1 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029ba:	0f 86 d8 00 00 00    	jbe    802a98 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8029c0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8029c6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029cc:	e9 c7 00 00 00       	jmp    802a98 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	83 c0 08             	add    $0x8,%eax
  8029d7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029da:	0f 85 9d 00 00 00    	jne    802a7d <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029e0:	83 ec 04             	sub    $0x4,%esp
  8029e3:	6a 01                	push   $0x1
  8029e5:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029e8:	ff 75 a8             	pushl  -0x58(%ebp)
  8029eb:	e8 e3 f9 ff ff       	call   8023d3 <set_block_data>
  8029f0:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f7:	75 17                	jne    802a10 <alloc_block_BF+0x152>
  8029f9:	83 ec 04             	sub    $0x4,%esp
  8029fc:	68 af 46 80 00       	push   $0x8046af
  802a01:	68 2c 01 00 00       	push   $0x12c
  802a06:	68 cd 46 80 00       	push   $0x8046cd
  802a0b:	e8 82 db ff ff       	call   800592 <_panic>
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 00                	mov    (%eax),%eax
  802a15:	85 c0                	test   %eax,%eax
  802a17:	74 10                	je     802a29 <alloc_block_BF+0x16b>
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 00                	mov    (%eax),%eax
  802a1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a21:	8b 52 04             	mov    0x4(%edx),%edx
  802a24:	89 50 04             	mov    %edx,0x4(%eax)
  802a27:	eb 0b                	jmp    802a34 <alloc_block_BF+0x176>
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 40 04             	mov    0x4(%eax),%eax
  802a2f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 40 04             	mov    0x4(%eax),%eax
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	74 0f                	je     802a4d <alloc_block_BF+0x18f>
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 40 04             	mov    0x4(%eax),%eax
  802a44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a47:	8b 12                	mov    (%edx),%edx
  802a49:	89 10                	mov    %edx,(%eax)
  802a4b:	eb 0a                	jmp    802a57 <alloc_block_BF+0x199>
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 00                	mov    (%eax),%eax
  802a52:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6a:	a1 38 50 80 00       	mov    0x805038,%eax
  802a6f:	48                   	dec    %eax
  802a70:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a75:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a78:	e9 24 04 00 00       	jmp    802ea1 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a80:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a83:	76 13                	jbe    802a98 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a85:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a8c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a92:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a95:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a98:	a1 34 50 80 00       	mov    0x805034,%eax
  802a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa4:	74 07                	je     802aad <alloc_block_BF+0x1ef>
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	eb 05                	jmp    802ab2 <alloc_block_BF+0x1f4>
  802aad:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab2:	a3 34 50 80 00       	mov    %eax,0x805034
  802ab7:	a1 34 50 80 00       	mov    0x805034,%eax
  802abc:	85 c0                	test   %eax,%eax
  802abe:	0f 85 bf fe ff ff    	jne    802983 <alloc_block_BF+0xc5>
  802ac4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac8:	0f 85 b5 fe ff ff    	jne    802983 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802ace:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad2:	0f 84 26 02 00 00    	je     802cfe <alloc_block_BF+0x440>
  802ad8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802adc:	0f 85 1c 02 00 00    	jne    802cfe <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae5:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae8:	83 e8 08             	sub    $0x8,%eax
  802aeb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802aee:	8b 45 08             	mov    0x8(%ebp),%eax
  802af1:	8d 50 08             	lea    0x8(%eax),%edx
  802af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af7:	01 d0                	add    %edx,%eax
  802af9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	83 c0 08             	add    $0x8,%eax
  802b02:	83 ec 04             	sub    $0x4,%esp
  802b05:	6a 01                	push   $0x1
  802b07:	50                   	push   %eax
  802b08:	ff 75 f0             	pushl  -0x10(%ebp)
  802b0b:	e8 c3 f8 ff ff       	call   8023d3 <set_block_data>
  802b10:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b16:	8b 40 04             	mov    0x4(%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	75 68                	jne    802b85 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b1d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b21:	75 17                	jne    802b3a <alloc_block_BF+0x27c>
  802b23:	83 ec 04             	sub    $0x4,%esp
  802b26:	68 e8 46 80 00       	push   $0x8046e8
  802b2b:	68 45 01 00 00       	push   $0x145
  802b30:	68 cd 46 80 00       	push   $0x8046cd
  802b35:	e8 58 da ff ff       	call   800592 <_panic>
  802b3a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b40:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b43:	89 10                	mov    %edx,(%eax)
  802b45:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	74 0d                	je     802b5b <alloc_block_BF+0x29d>
  802b4e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b53:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b56:	89 50 04             	mov    %edx,0x4(%eax)
  802b59:	eb 08                	jmp    802b63 <alloc_block_BF+0x2a5>
  802b5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b5e:	a3 30 50 80 00       	mov    %eax,0x805030
  802b63:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b66:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b6b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b75:	a1 38 50 80 00       	mov    0x805038,%eax
  802b7a:	40                   	inc    %eax
  802b7b:	a3 38 50 80 00       	mov    %eax,0x805038
  802b80:	e9 dc 00 00 00       	jmp    802c61 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	75 65                	jne    802bf3 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b8e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b92:	75 17                	jne    802bab <alloc_block_BF+0x2ed>
  802b94:	83 ec 04             	sub    $0x4,%esp
  802b97:	68 1c 47 80 00       	push   $0x80471c
  802b9c:	68 4a 01 00 00       	push   $0x14a
  802ba1:	68 cd 46 80 00       	push   $0x8046cd
  802ba6:	e8 e7 d9 ff ff       	call   800592 <_panic>
  802bab:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802bb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb4:	89 50 04             	mov    %edx,0x4(%eax)
  802bb7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bba:	8b 40 04             	mov    0x4(%eax),%eax
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	74 0c                	je     802bcd <alloc_block_BF+0x30f>
  802bc1:	a1 30 50 80 00       	mov    0x805030,%eax
  802bc6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bc9:	89 10                	mov    %edx,(%eax)
  802bcb:	eb 08                	jmp    802bd5 <alloc_block_BF+0x317>
  802bcd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd8:	a3 30 50 80 00       	mov    %eax,0x805030
  802bdd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be6:	a1 38 50 80 00       	mov    0x805038,%eax
  802beb:	40                   	inc    %eax
  802bec:	a3 38 50 80 00       	mov    %eax,0x805038
  802bf1:	eb 6e                	jmp    802c61 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bf7:	74 06                	je     802bff <alloc_block_BF+0x341>
  802bf9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bfd:	75 17                	jne    802c16 <alloc_block_BF+0x358>
  802bff:	83 ec 04             	sub    $0x4,%esp
  802c02:	68 40 47 80 00       	push   $0x804740
  802c07:	68 4f 01 00 00       	push   $0x14f
  802c0c:	68 cd 46 80 00       	push   $0x8046cd
  802c11:	e8 7c d9 ff ff       	call   800592 <_panic>
  802c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c19:	8b 10                	mov    (%eax),%edx
  802c1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c1e:	89 10                	mov    %edx,(%eax)
  802c20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c23:	8b 00                	mov    (%eax),%eax
  802c25:	85 c0                	test   %eax,%eax
  802c27:	74 0b                	je     802c34 <alloc_block_BF+0x376>
  802c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c31:	89 50 04             	mov    %edx,0x4(%eax)
  802c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c37:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c3a:	89 10                	mov    %edx,(%eax)
  802c3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c42:	89 50 04             	mov    %edx,0x4(%eax)
  802c45:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c48:	8b 00                	mov    (%eax),%eax
  802c4a:	85 c0                	test   %eax,%eax
  802c4c:	75 08                	jne    802c56 <alloc_block_BF+0x398>
  802c4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c51:	a3 30 50 80 00       	mov    %eax,0x805030
  802c56:	a1 38 50 80 00       	mov    0x805038,%eax
  802c5b:	40                   	inc    %eax
  802c5c:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c65:	75 17                	jne    802c7e <alloc_block_BF+0x3c0>
  802c67:	83 ec 04             	sub    $0x4,%esp
  802c6a:	68 af 46 80 00       	push   $0x8046af
  802c6f:	68 51 01 00 00       	push   $0x151
  802c74:	68 cd 46 80 00       	push   $0x8046cd
  802c79:	e8 14 d9 ff ff       	call   800592 <_panic>
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	74 10                	je     802c97 <alloc_block_BF+0x3d9>
  802c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c8f:	8b 52 04             	mov    0x4(%edx),%edx
  802c92:	89 50 04             	mov    %edx,0x4(%eax)
  802c95:	eb 0b                	jmp    802ca2 <alloc_block_BF+0x3e4>
  802c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9a:	8b 40 04             	mov    0x4(%eax),%eax
  802c9d:	a3 30 50 80 00       	mov    %eax,0x805030
  802ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	74 0f                	je     802cbb <alloc_block_BF+0x3fd>
  802cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caf:	8b 40 04             	mov    0x4(%eax),%eax
  802cb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb5:	8b 12                	mov    (%edx),%edx
  802cb7:	89 10                	mov    %edx,(%eax)
  802cb9:	eb 0a                	jmp    802cc5 <alloc_block_BF+0x407>
  802cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd8:	a1 38 50 80 00       	mov    0x805038,%eax
  802cdd:	48                   	dec    %eax
  802cde:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802ce3:	83 ec 04             	sub    $0x4,%esp
  802ce6:	6a 00                	push   $0x0
  802ce8:	ff 75 d0             	pushl  -0x30(%ebp)
  802ceb:	ff 75 cc             	pushl  -0x34(%ebp)
  802cee:	e8 e0 f6 ff ff       	call   8023d3 <set_block_data>
  802cf3:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	e9 a3 01 00 00       	jmp    802ea1 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802cfe:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d02:	0f 85 9d 00 00 00    	jne    802da5 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d08:	83 ec 04             	sub    $0x4,%esp
  802d0b:	6a 01                	push   $0x1
  802d0d:	ff 75 ec             	pushl  -0x14(%ebp)
  802d10:	ff 75 f0             	pushl  -0x10(%ebp)
  802d13:	e8 bb f6 ff ff       	call   8023d3 <set_block_data>
  802d18:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d1f:	75 17                	jne    802d38 <alloc_block_BF+0x47a>
  802d21:	83 ec 04             	sub    $0x4,%esp
  802d24:	68 af 46 80 00       	push   $0x8046af
  802d29:	68 58 01 00 00       	push   $0x158
  802d2e:	68 cd 46 80 00       	push   $0x8046cd
  802d33:	e8 5a d8 ff ff       	call   800592 <_panic>
  802d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	74 10                	je     802d51 <alloc_block_BF+0x493>
  802d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d49:	8b 52 04             	mov    0x4(%edx),%edx
  802d4c:	89 50 04             	mov    %edx,0x4(%eax)
  802d4f:	eb 0b                	jmp    802d5c <alloc_block_BF+0x49e>
  802d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d54:	8b 40 04             	mov    0x4(%eax),%eax
  802d57:	a3 30 50 80 00       	mov    %eax,0x805030
  802d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5f:	8b 40 04             	mov    0x4(%eax),%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	74 0f                	je     802d75 <alloc_block_BF+0x4b7>
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	8b 40 04             	mov    0x4(%eax),%eax
  802d6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d6f:	8b 12                	mov    (%edx),%edx
  802d71:	89 10                	mov    %edx,(%eax)
  802d73:	eb 0a                	jmp    802d7f <alloc_block_BF+0x4c1>
  802d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d78:	8b 00                	mov    (%eax),%eax
  802d7a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d92:	a1 38 50 80 00       	mov    0x805038,%eax
  802d97:	48                   	dec    %eax
  802d98:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da0:	e9 fc 00 00 00       	jmp    802ea1 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	83 c0 08             	add    $0x8,%eax
  802dab:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802dae:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802db5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802db8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802dbb:	01 d0                	add    %edx,%eax
  802dbd:	48                   	dec    %eax
  802dbe:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802dc1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dc4:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc9:	f7 75 c4             	divl   -0x3c(%ebp)
  802dcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dcf:	29 d0                	sub    %edx,%eax
  802dd1:	c1 e8 0c             	shr    $0xc,%eax
  802dd4:	83 ec 0c             	sub    $0xc,%esp
  802dd7:	50                   	push   %eax
  802dd8:	e8 0c e8 ff ff       	call   8015e9 <sbrk>
  802ddd:	83 c4 10             	add    $0x10,%esp
  802de0:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802de3:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802de7:	75 0a                	jne    802df3 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802de9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dee:	e9 ae 00 00 00       	jmp    802ea1 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802df3:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802dfa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dfd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e00:	01 d0                	add    %edx,%eax
  802e02:	48                   	dec    %eax
  802e03:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e06:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e09:	ba 00 00 00 00       	mov    $0x0,%edx
  802e0e:	f7 75 b8             	divl   -0x48(%ebp)
  802e11:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e14:	29 d0                	sub    %edx,%eax
  802e16:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e19:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e1c:	01 d0                	add    %edx,%eax
  802e1e:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e23:	a1 40 50 80 00       	mov    0x805040,%eax
  802e28:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e2e:	83 ec 0c             	sub    $0xc,%esp
  802e31:	68 74 47 80 00       	push   $0x804774
  802e36:	e8 14 da ff ff       	call   80084f <cprintf>
  802e3b:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e3e:	83 ec 08             	sub    $0x8,%esp
  802e41:	ff 75 bc             	pushl  -0x44(%ebp)
  802e44:	68 79 47 80 00       	push   $0x804779
  802e49:	e8 01 da ff ff       	call   80084f <cprintf>
  802e4e:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e51:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e58:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e5b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e5e:	01 d0                	add    %edx,%eax
  802e60:	48                   	dec    %eax
  802e61:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e64:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e67:	ba 00 00 00 00       	mov    $0x0,%edx
  802e6c:	f7 75 b0             	divl   -0x50(%ebp)
  802e6f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e72:	29 d0                	sub    %edx,%eax
  802e74:	83 ec 04             	sub    $0x4,%esp
  802e77:	6a 01                	push   $0x1
  802e79:	50                   	push   %eax
  802e7a:	ff 75 bc             	pushl  -0x44(%ebp)
  802e7d:	e8 51 f5 ff ff       	call   8023d3 <set_block_data>
  802e82:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e85:	83 ec 0c             	sub    $0xc,%esp
  802e88:	ff 75 bc             	pushl  -0x44(%ebp)
  802e8b:	e8 36 04 00 00       	call   8032c6 <free_block>
  802e90:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e93:	83 ec 0c             	sub    $0xc,%esp
  802e96:	ff 75 08             	pushl  0x8(%ebp)
  802e99:	e8 20 fa ff ff       	call   8028be <alloc_block_BF>
  802e9e:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ea1:	c9                   	leave  
  802ea2:	c3                   	ret    

00802ea3 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802ea3:	55                   	push   %ebp
  802ea4:	89 e5                	mov    %esp,%ebp
  802ea6:	53                   	push   %ebx
  802ea7:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802eaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802eb1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802eb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ebc:	74 1e                	je     802edc <merging+0x39>
  802ebe:	ff 75 08             	pushl  0x8(%ebp)
  802ec1:	e8 bc f1 ff ff       	call   802082 <get_block_size>
  802ec6:	83 c4 04             	add    $0x4,%esp
  802ec9:	89 c2                	mov    %eax,%edx
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	01 d0                	add    %edx,%eax
  802ed0:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ed3:	75 07                	jne    802edc <merging+0x39>
		prev_is_free = 1;
  802ed5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802edc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ee0:	74 1e                	je     802f00 <merging+0x5d>
  802ee2:	ff 75 10             	pushl  0x10(%ebp)
  802ee5:	e8 98 f1 ff ff       	call   802082 <get_block_size>
  802eea:	83 c4 04             	add    $0x4,%esp
  802eed:	89 c2                	mov    %eax,%edx
  802eef:	8b 45 10             	mov    0x10(%ebp),%eax
  802ef2:	01 d0                	add    %edx,%eax
  802ef4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ef7:	75 07                	jne    802f00 <merging+0x5d>
		next_is_free = 1;
  802ef9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f04:	0f 84 cc 00 00 00    	je     802fd6 <merging+0x133>
  802f0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f0e:	0f 84 c2 00 00 00    	je     802fd6 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f14:	ff 75 08             	pushl  0x8(%ebp)
  802f17:	e8 66 f1 ff ff       	call   802082 <get_block_size>
  802f1c:	83 c4 04             	add    $0x4,%esp
  802f1f:	89 c3                	mov    %eax,%ebx
  802f21:	ff 75 10             	pushl  0x10(%ebp)
  802f24:	e8 59 f1 ff ff       	call   802082 <get_block_size>
  802f29:	83 c4 04             	add    $0x4,%esp
  802f2c:	01 c3                	add    %eax,%ebx
  802f2e:	ff 75 0c             	pushl  0xc(%ebp)
  802f31:	e8 4c f1 ff ff       	call   802082 <get_block_size>
  802f36:	83 c4 04             	add    $0x4,%esp
  802f39:	01 d8                	add    %ebx,%eax
  802f3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f3e:	6a 00                	push   $0x0
  802f40:	ff 75 ec             	pushl  -0x14(%ebp)
  802f43:	ff 75 08             	pushl  0x8(%ebp)
  802f46:	e8 88 f4 ff ff       	call   8023d3 <set_block_data>
  802f4b:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f52:	75 17                	jne    802f6b <merging+0xc8>
  802f54:	83 ec 04             	sub    $0x4,%esp
  802f57:	68 af 46 80 00       	push   $0x8046af
  802f5c:	68 7d 01 00 00       	push   $0x17d
  802f61:	68 cd 46 80 00       	push   $0x8046cd
  802f66:	e8 27 d6 ff ff       	call   800592 <_panic>
  802f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6e:	8b 00                	mov    (%eax),%eax
  802f70:	85 c0                	test   %eax,%eax
  802f72:	74 10                	je     802f84 <merging+0xe1>
  802f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f77:	8b 00                	mov    (%eax),%eax
  802f79:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f7c:	8b 52 04             	mov    0x4(%edx),%edx
  802f7f:	89 50 04             	mov    %edx,0x4(%eax)
  802f82:	eb 0b                	jmp    802f8f <merging+0xec>
  802f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f87:	8b 40 04             	mov    0x4(%eax),%eax
  802f8a:	a3 30 50 80 00       	mov    %eax,0x805030
  802f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f92:	8b 40 04             	mov    0x4(%eax),%eax
  802f95:	85 c0                	test   %eax,%eax
  802f97:	74 0f                	je     802fa8 <merging+0x105>
  802f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9c:	8b 40 04             	mov    0x4(%eax),%eax
  802f9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fa2:	8b 12                	mov    (%edx),%edx
  802fa4:	89 10                	mov    %edx,(%eax)
  802fa6:	eb 0a                	jmp    802fb2 <merging+0x10f>
  802fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc5:	a1 38 50 80 00       	mov    0x805038,%eax
  802fca:	48                   	dec    %eax
  802fcb:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802fd0:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fd1:	e9 ea 02 00 00       	jmp    8032c0 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802fd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fda:	74 3b                	je     803017 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802fdc:	83 ec 0c             	sub    $0xc,%esp
  802fdf:	ff 75 08             	pushl  0x8(%ebp)
  802fe2:	e8 9b f0 ff ff       	call   802082 <get_block_size>
  802fe7:	83 c4 10             	add    $0x10,%esp
  802fea:	89 c3                	mov    %eax,%ebx
  802fec:	83 ec 0c             	sub    $0xc,%esp
  802fef:	ff 75 10             	pushl  0x10(%ebp)
  802ff2:	e8 8b f0 ff ff       	call   802082 <get_block_size>
  802ff7:	83 c4 10             	add    $0x10,%esp
  802ffa:	01 d8                	add    %ebx,%eax
  802ffc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fff:	83 ec 04             	sub    $0x4,%esp
  803002:	6a 00                	push   $0x0
  803004:	ff 75 e8             	pushl  -0x18(%ebp)
  803007:	ff 75 08             	pushl  0x8(%ebp)
  80300a:	e8 c4 f3 ff ff       	call   8023d3 <set_block_data>
  80300f:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803012:	e9 a9 02 00 00       	jmp    8032c0 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803017:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80301b:	0f 84 2d 01 00 00    	je     80314e <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803021:	83 ec 0c             	sub    $0xc,%esp
  803024:	ff 75 10             	pushl  0x10(%ebp)
  803027:	e8 56 f0 ff ff       	call   802082 <get_block_size>
  80302c:	83 c4 10             	add    $0x10,%esp
  80302f:	89 c3                	mov    %eax,%ebx
  803031:	83 ec 0c             	sub    $0xc,%esp
  803034:	ff 75 0c             	pushl  0xc(%ebp)
  803037:	e8 46 f0 ff ff       	call   802082 <get_block_size>
  80303c:	83 c4 10             	add    $0x10,%esp
  80303f:	01 d8                	add    %ebx,%eax
  803041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803044:	83 ec 04             	sub    $0x4,%esp
  803047:	6a 00                	push   $0x0
  803049:	ff 75 e4             	pushl  -0x1c(%ebp)
  80304c:	ff 75 10             	pushl  0x10(%ebp)
  80304f:	e8 7f f3 ff ff       	call   8023d3 <set_block_data>
  803054:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803057:	8b 45 10             	mov    0x10(%ebp),%eax
  80305a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80305d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803061:	74 06                	je     803069 <merging+0x1c6>
  803063:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803067:	75 17                	jne    803080 <merging+0x1dd>
  803069:	83 ec 04             	sub    $0x4,%esp
  80306c:	68 88 47 80 00       	push   $0x804788
  803071:	68 8d 01 00 00       	push   $0x18d
  803076:	68 cd 46 80 00       	push   $0x8046cd
  80307b:	e8 12 d5 ff ff       	call   800592 <_panic>
  803080:	8b 45 0c             	mov    0xc(%ebp),%eax
  803083:	8b 50 04             	mov    0x4(%eax),%edx
  803086:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803089:	89 50 04             	mov    %edx,0x4(%eax)
  80308c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803092:	89 10                	mov    %edx,(%eax)
  803094:	8b 45 0c             	mov    0xc(%ebp),%eax
  803097:	8b 40 04             	mov    0x4(%eax),%eax
  80309a:	85 c0                	test   %eax,%eax
  80309c:	74 0d                	je     8030ab <merging+0x208>
  80309e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a1:	8b 40 04             	mov    0x4(%eax),%eax
  8030a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030a7:	89 10                	mov    %edx,(%eax)
  8030a9:	eb 08                	jmp    8030b3 <merging+0x210>
  8030ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030b9:	89 50 04             	mov    %edx,0x4(%eax)
  8030bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8030c1:	40                   	inc    %eax
  8030c2:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8030c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030cb:	75 17                	jne    8030e4 <merging+0x241>
  8030cd:	83 ec 04             	sub    $0x4,%esp
  8030d0:	68 af 46 80 00       	push   $0x8046af
  8030d5:	68 8e 01 00 00       	push   $0x18e
  8030da:	68 cd 46 80 00       	push   $0x8046cd
  8030df:	e8 ae d4 ff ff       	call   800592 <_panic>
  8030e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e7:	8b 00                	mov    (%eax),%eax
  8030e9:	85 c0                	test   %eax,%eax
  8030eb:	74 10                	je     8030fd <merging+0x25a>
  8030ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f0:	8b 00                	mov    (%eax),%eax
  8030f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030f5:	8b 52 04             	mov    0x4(%edx),%edx
  8030f8:	89 50 04             	mov    %edx,0x4(%eax)
  8030fb:	eb 0b                	jmp    803108 <merging+0x265>
  8030fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803100:	8b 40 04             	mov    0x4(%eax),%eax
  803103:	a3 30 50 80 00       	mov    %eax,0x805030
  803108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310b:	8b 40 04             	mov    0x4(%eax),%eax
  80310e:	85 c0                	test   %eax,%eax
  803110:	74 0f                	je     803121 <merging+0x27e>
  803112:	8b 45 0c             	mov    0xc(%ebp),%eax
  803115:	8b 40 04             	mov    0x4(%eax),%eax
  803118:	8b 55 0c             	mov    0xc(%ebp),%edx
  80311b:	8b 12                	mov    (%edx),%edx
  80311d:	89 10                	mov    %edx,(%eax)
  80311f:	eb 0a                	jmp    80312b <merging+0x288>
  803121:	8b 45 0c             	mov    0xc(%ebp),%eax
  803124:	8b 00                	mov    (%eax),%eax
  803126:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80312b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80312e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803134:	8b 45 0c             	mov    0xc(%ebp),%eax
  803137:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313e:	a1 38 50 80 00       	mov    0x805038,%eax
  803143:	48                   	dec    %eax
  803144:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803149:	e9 72 01 00 00       	jmp    8032c0 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80314e:	8b 45 10             	mov    0x10(%ebp),%eax
  803151:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803154:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803158:	74 79                	je     8031d3 <merging+0x330>
  80315a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80315e:	74 73                	je     8031d3 <merging+0x330>
  803160:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803164:	74 06                	je     80316c <merging+0x2c9>
  803166:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80316a:	75 17                	jne    803183 <merging+0x2e0>
  80316c:	83 ec 04             	sub    $0x4,%esp
  80316f:	68 40 47 80 00       	push   $0x804740
  803174:	68 94 01 00 00       	push   $0x194
  803179:	68 cd 46 80 00       	push   $0x8046cd
  80317e:	e8 0f d4 ff ff       	call   800592 <_panic>
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	8b 10                	mov    (%eax),%edx
  803188:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318b:	89 10                	mov    %edx,(%eax)
  80318d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803190:	8b 00                	mov    (%eax),%eax
  803192:	85 c0                	test   %eax,%eax
  803194:	74 0b                	je     8031a1 <merging+0x2fe>
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80319e:	89 50 04             	mov    %edx,0x4(%eax)
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031a7:	89 10                	mov    %edx,(%eax)
  8031a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8031af:	89 50 04             	mov    %edx,0x4(%eax)
  8031b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	85 c0                	test   %eax,%eax
  8031b9:	75 08                	jne    8031c3 <merging+0x320>
  8031bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031be:	a3 30 50 80 00       	mov    %eax,0x805030
  8031c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8031c8:	40                   	inc    %eax
  8031c9:	a3 38 50 80 00       	mov    %eax,0x805038
  8031ce:	e9 ce 00 00 00       	jmp    8032a1 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8031d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d7:	74 65                	je     80323e <merging+0x39b>
  8031d9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031dd:	75 17                	jne    8031f6 <merging+0x353>
  8031df:	83 ec 04             	sub    $0x4,%esp
  8031e2:	68 1c 47 80 00       	push   $0x80471c
  8031e7:	68 95 01 00 00       	push   $0x195
  8031ec:	68 cd 46 80 00       	push   $0x8046cd
  8031f1:	e8 9c d3 ff ff       	call   800592 <_panic>
  8031f6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ff:	89 50 04             	mov    %edx,0x4(%eax)
  803202:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803205:	8b 40 04             	mov    0x4(%eax),%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 0c                	je     803218 <merging+0x375>
  80320c:	a1 30 50 80 00       	mov    0x805030,%eax
  803211:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803214:	89 10                	mov    %edx,(%eax)
  803216:	eb 08                	jmp    803220 <merging+0x37d>
  803218:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803220:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803223:	a3 30 50 80 00       	mov    %eax,0x805030
  803228:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80322b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803231:	a1 38 50 80 00       	mov    0x805038,%eax
  803236:	40                   	inc    %eax
  803237:	a3 38 50 80 00       	mov    %eax,0x805038
  80323c:	eb 63                	jmp    8032a1 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80323e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803242:	75 17                	jne    80325b <merging+0x3b8>
  803244:	83 ec 04             	sub    $0x4,%esp
  803247:	68 e8 46 80 00       	push   $0x8046e8
  80324c:	68 98 01 00 00       	push   $0x198
  803251:	68 cd 46 80 00       	push   $0x8046cd
  803256:	e8 37 d3 ff ff       	call   800592 <_panic>
  80325b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803261:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803264:	89 10                	mov    %edx,(%eax)
  803266:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803269:	8b 00                	mov    (%eax),%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	74 0d                	je     80327c <merging+0x3d9>
  80326f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803274:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803277:	89 50 04             	mov    %edx,0x4(%eax)
  80327a:	eb 08                	jmp    803284 <merging+0x3e1>
  80327c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80327f:	a3 30 50 80 00       	mov    %eax,0x805030
  803284:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803287:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80328c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803296:	a1 38 50 80 00       	mov    0x805038,%eax
  80329b:	40                   	inc    %eax
  80329c:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8032a1:	83 ec 0c             	sub    $0xc,%esp
  8032a4:	ff 75 10             	pushl  0x10(%ebp)
  8032a7:	e8 d6 ed ff ff       	call   802082 <get_block_size>
  8032ac:	83 c4 10             	add    $0x10,%esp
  8032af:	83 ec 04             	sub    $0x4,%esp
  8032b2:	6a 00                	push   $0x0
  8032b4:	50                   	push   %eax
  8032b5:	ff 75 10             	pushl  0x10(%ebp)
  8032b8:	e8 16 f1 ff ff       	call   8023d3 <set_block_data>
  8032bd:	83 c4 10             	add    $0x10,%esp
	}
}
  8032c0:	90                   	nop
  8032c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032c4:	c9                   	leave  
  8032c5:	c3                   	ret    

008032c6 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8032c6:	55                   	push   %ebp
  8032c7:	89 e5                	mov    %esp,%ebp
  8032c9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8032cc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8032d4:	a1 30 50 80 00       	mov    0x805030,%eax
  8032d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032dc:	73 1b                	jae    8032f9 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8032de:	a1 30 50 80 00       	mov    0x805030,%eax
  8032e3:	83 ec 04             	sub    $0x4,%esp
  8032e6:	ff 75 08             	pushl  0x8(%ebp)
  8032e9:	6a 00                	push   $0x0
  8032eb:	50                   	push   %eax
  8032ec:	e8 b2 fb ff ff       	call   802ea3 <merging>
  8032f1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032f4:	e9 8b 00 00 00       	jmp    803384 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8032f9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  803301:	76 18                	jbe    80331b <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803303:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803308:	83 ec 04             	sub    $0x4,%esp
  80330b:	ff 75 08             	pushl  0x8(%ebp)
  80330e:	50                   	push   %eax
  80330f:	6a 00                	push   $0x0
  803311:	e8 8d fb ff ff       	call   802ea3 <merging>
  803316:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803319:	eb 69                	jmp    803384 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80331b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803320:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803323:	eb 39                	jmp    80335e <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803328:	3b 45 08             	cmp    0x8(%ebp),%eax
  80332b:	73 29                	jae    803356 <free_block+0x90>
  80332d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	3b 45 08             	cmp    0x8(%ebp),%eax
  803335:	76 1f                	jbe    803356 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333a:	8b 00                	mov    (%eax),%eax
  80333c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80333f:	83 ec 04             	sub    $0x4,%esp
  803342:	ff 75 08             	pushl  0x8(%ebp)
  803345:	ff 75 f0             	pushl  -0x10(%ebp)
  803348:	ff 75 f4             	pushl  -0xc(%ebp)
  80334b:	e8 53 fb ff ff       	call   802ea3 <merging>
  803350:	83 c4 10             	add    $0x10,%esp
			break;
  803353:	90                   	nop
		}
	}
}
  803354:	eb 2e                	jmp    803384 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803356:	a1 34 50 80 00       	mov    0x805034,%eax
  80335b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80335e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803362:	74 07                	je     80336b <free_block+0xa5>
  803364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803367:	8b 00                	mov    (%eax),%eax
  803369:	eb 05                	jmp    803370 <free_block+0xaa>
  80336b:	b8 00 00 00 00       	mov    $0x0,%eax
  803370:	a3 34 50 80 00       	mov    %eax,0x805034
  803375:	a1 34 50 80 00       	mov    0x805034,%eax
  80337a:	85 c0                	test   %eax,%eax
  80337c:	75 a7                	jne    803325 <free_block+0x5f>
  80337e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803382:	75 a1                	jne    803325 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803384:	90                   	nop
  803385:	c9                   	leave  
  803386:	c3                   	ret    

00803387 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803387:	55                   	push   %ebp
  803388:	89 e5                	mov    %esp,%ebp
  80338a:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80338d:	ff 75 08             	pushl  0x8(%ebp)
  803390:	e8 ed ec ff ff       	call   802082 <get_block_size>
  803395:	83 c4 04             	add    $0x4,%esp
  803398:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80339b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033a2:	eb 17                	jmp    8033bb <copy_data+0x34>
  8033a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033aa:	01 c2                	add    %eax,%edx
  8033ac:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	01 c8                	add    %ecx,%eax
  8033b4:	8a 00                	mov    (%eax),%al
  8033b6:	88 02                	mov    %al,(%edx)
  8033b8:	ff 45 fc             	incl   -0x4(%ebp)
  8033bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8033c1:	72 e1                	jb     8033a4 <copy_data+0x1d>
}
  8033c3:	90                   	nop
  8033c4:	c9                   	leave  
  8033c5:	c3                   	ret    

008033c6 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8033c6:	55                   	push   %ebp
  8033c7:	89 e5                	mov    %esp,%ebp
  8033c9:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8033cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d0:	75 23                	jne    8033f5 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8033d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033d6:	74 13                	je     8033eb <realloc_block_FF+0x25>
  8033d8:	83 ec 0c             	sub    $0xc,%esp
  8033db:	ff 75 0c             	pushl  0xc(%ebp)
  8033de:	e8 1f f0 ff ff       	call   802402 <alloc_block_FF>
  8033e3:	83 c4 10             	add    $0x10,%esp
  8033e6:	e9 f4 06 00 00       	jmp    803adf <realloc_block_FF+0x719>
		return NULL;
  8033eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f0:	e9 ea 06 00 00       	jmp    803adf <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8033f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033f9:	75 18                	jne    803413 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8033fb:	83 ec 0c             	sub    $0xc,%esp
  8033fe:	ff 75 08             	pushl  0x8(%ebp)
  803401:	e8 c0 fe ff ff       	call   8032c6 <free_block>
  803406:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803409:	b8 00 00 00 00       	mov    $0x0,%eax
  80340e:	e9 cc 06 00 00       	jmp    803adf <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803413:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803417:	77 07                	ja     803420 <realloc_block_FF+0x5a>
  803419:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803420:	8b 45 0c             	mov    0xc(%ebp),%eax
  803423:	83 e0 01             	and    $0x1,%eax
  803426:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80342c:	83 c0 08             	add    $0x8,%eax
  80342f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803432:	83 ec 0c             	sub    $0xc,%esp
  803435:	ff 75 08             	pushl  0x8(%ebp)
  803438:	e8 45 ec ff ff       	call   802082 <get_block_size>
  80343d:	83 c4 10             	add    $0x10,%esp
  803440:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803443:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803446:	83 e8 08             	sub    $0x8,%eax
  803449:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80344c:	8b 45 08             	mov    0x8(%ebp),%eax
  80344f:	83 e8 04             	sub    $0x4,%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	83 e0 fe             	and    $0xfffffffe,%eax
  803457:	89 c2                	mov    %eax,%edx
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	01 d0                	add    %edx,%eax
  80345e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803461:	83 ec 0c             	sub    $0xc,%esp
  803464:	ff 75 e4             	pushl  -0x1c(%ebp)
  803467:	e8 16 ec ff ff       	call   802082 <get_block_size>
  80346c:	83 c4 10             	add    $0x10,%esp
  80346f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803475:	83 e8 08             	sub    $0x8,%eax
  803478:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80347b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80347e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803481:	75 08                	jne    80348b <realloc_block_FF+0xc5>
	{
		 return va;
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	e9 54 06 00 00       	jmp    803adf <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80348b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803491:	0f 83 e5 03 00 00    	jae    80387c <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80349d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034a0:	83 ec 0c             	sub    $0xc,%esp
  8034a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034a6:	e8 f0 eb ff ff       	call   80209b <is_free_block>
  8034ab:	83 c4 10             	add    $0x10,%esp
  8034ae:	84 c0                	test   %al,%al
  8034b0:	0f 84 3b 01 00 00    	je     8035f1 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8034b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034bc:	01 d0                	add    %edx,%eax
  8034be:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	6a 01                	push   $0x1
  8034c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8034c9:	ff 75 08             	pushl  0x8(%ebp)
  8034cc:	e8 02 ef ff ff       	call   8023d3 <set_block_data>
  8034d1:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8034d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d7:	83 e8 04             	sub    $0x4,%eax
  8034da:	8b 00                	mov    (%eax),%eax
  8034dc:	83 e0 fe             	and    $0xfffffffe,%eax
  8034df:	89 c2                	mov    %eax,%edx
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	01 d0                	add    %edx,%eax
  8034e6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8034e9:	83 ec 04             	sub    $0x4,%esp
  8034ec:	6a 00                	push   $0x0
  8034ee:	ff 75 cc             	pushl  -0x34(%ebp)
  8034f1:	ff 75 c8             	pushl  -0x38(%ebp)
  8034f4:	e8 da ee ff ff       	call   8023d3 <set_block_data>
  8034f9:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8034fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803500:	74 06                	je     803508 <realloc_block_FF+0x142>
  803502:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803506:	75 17                	jne    80351f <realloc_block_FF+0x159>
  803508:	83 ec 04             	sub    $0x4,%esp
  80350b:	68 40 47 80 00       	push   $0x804740
  803510:	68 f6 01 00 00       	push   $0x1f6
  803515:	68 cd 46 80 00       	push   $0x8046cd
  80351a:	e8 73 d0 ff ff       	call   800592 <_panic>
  80351f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803522:	8b 10                	mov    (%eax),%edx
  803524:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803527:	89 10                	mov    %edx,(%eax)
  803529:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80352c:	8b 00                	mov    (%eax),%eax
  80352e:	85 c0                	test   %eax,%eax
  803530:	74 0b                	je     80353d <realloc_block_FF+0x177>
  803532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803535:	8b 00                	mov    (%eax),%eax
  803537:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80353a:	89 50 04             	mov    %edx,0x4(%eax)
  80353d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803540:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803543:	89 10                	mov    %edx,(%eax)
  803545:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803548:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80354b:	89 50 04             	mov    %edx,0x4(%eax)
  80354e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803551:	8b 00                	mov    (%eax),%eax
  803553:	85 c0                	test   %eax,%eax
  803555:	75 08                	jne    80355f <realloc_block_FF+0x199>
  803557:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80355a:	a3 30 50 80 00       	mov    %eax,0x805030
  80355f:	a1 38 50 80 00       	mov    0x805038,%eax
  803564:	40                   	inc    %eax
  803565:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80356a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80356e:	75 17                	jne    803587 <realloc_block_FF+0x1c1>
  803570:	83 ec 04             	sub    $0x4,%esp
  803573:	68 af 46 80 00       	push   $0x8046af
  803578:	68 f7 01 00 00       	push   $0x1f7
  80357d:	68 cd 46 80 00       	push   $0x8046cd
  803582:	e8 0b d0 ff ff       	call   800592 <_panic>
  803587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358a:	8b 00                	mov    (%eax),%eax
  80358c:	85 c0                	test   %eax,%eax
  80358e:	74 10                	je     8035a0 <realloc_block_FF+0x1da>
  803590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803598:	8b 52 04             	mov    0x4(%edx),%edx
  80359b:	89 50 04             	mov    %edx,0x4(%eax)
  80359e:	eb 0b                	jmp    8035ab <realloc_block_FF+0x1e5>
  8035a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a3:	8b 40 04             	mov    0x4(%eax),%eax
  8035a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ae:	8b 40 04             	mov    0x4(%eax),%eax
  8035b1:	85 c0                	test   %eax,%eax
  8035b3:	74 0f                	je     8035c4 <realloc_block_FF+0x1fe>
  8035b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b8:	8b 40 04             	mov    0x4(%eax),%eax
  8035bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035be:	8b 12                	mov    (%edx),%edx
  8035c0:	89 10                	mov    %edx,(%eax)
  8035c2:	eb 0a                	jmp    8035ce <realloc_block_FF+0x208>
  8035c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c7:	8b 00                	mov    (%eax),%eax
  8035c9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e1:	a1 38 50 80 00       	mov    0x805038,%eax
  8035e6:	48                   	dec    %eax
  8035e7:	a3 38 50 80 00       	mov    %eax,0x805038
  8035ec:	e9 83 02 00 00       	jmp    803874 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8035f1:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8035f5:	0f 86 69 02 00 00    	jbe    803864 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8035fb:	83 ec 04             	sub    $0x4,%esp
  8035fe:	6a 01                	push   $0x1
  803600:	ff 75 f0             	pushl  -0x10(%ebp)
  803603:	ff 75 08             	pushl  0x8(%ebp)
  803606:	e8 c8 ed ff ff       	call   8023d3 <set_block_data>
  80360b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80360e:	8b 45 08             	mov    0x8(%ebp),%eax
  803611:	83 e8 04             	sub    $0x4,%eax
  803614:	8b 00                	mov    (%eax),%eax
  803616:	83 e0 fe             	and    $0xfffffffe,%eax
  803619:	89 c2                	mov    %eax,%edx
  80361b:	8b 45 08             	mov    0x8(%ebp),%eax
  80361e:	01 d0                	add    %edx,%eax
  803620:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803623:	a1 38 50 80 00       	mov    0x805038,%eax
  803628:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80362b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80362f:	75 68                	jne    803699 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803631:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803635:	75 17                	jne    80364e <realloc_block_FF+0x288>
  803637:	83 ec 04             	sub    $0x4,%esp
  80363a:	68 e8 46 80 00       	push   $0x8046e8
  80363f:	68 06 02 00 00       	push   $0x206
  803644:	68 cd 46 80 00       	push   $0x8046cd
  803649:	e8 44 cf ff ff       	call   800592 <_panic>
  80364e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803654:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803657:	89 10                	mov    %edx,(%eax)
  803659:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365c:	8b 00                	mov    (%eax),%eax
  80365e:	85 c0                	test   %eax,%eax
  803660:	74 0d                	je     80366f <realloc_block_FF+0x2a9>
  803662:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803667:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80366a:	89 50 04             	mov    %edx,0x4(%eax)
  80366d:	eb 08                	jmp    803677 <realloc_block_FF+0x2b1>
  80366f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803672:	a3 30 50 80 00       	mov    %eax,0x805030
  803677:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80367f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803682:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803689:	a1 38 50 80 00       	mov    0x805038,%eax
  80368e:	40                   	inc    %eax
  80368f:	a3 38 50 80 00       	mov    %eax,0x805038
  803694:	e9 b0 01 00 00       	jmp    803849 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803699:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80369e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036a1:	76 68                	jbe    80370b <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036a7:	75 17                	jne    8036c0 <realloc_block_FF+0x2fa>
  8036a9:	83 ec 04             	sub    $0x4,%esp
  8036ac:	68 e8 46 80 00       	push   $0x8046e8
  8036b1:	68 0b 02 00 00       	push   $0x20b
  8036b6:	68 cd 46 80 00       	push   $0x8046cd
  8036bb:	e8 d2 ce ff ff       	call   800592 <_panic>
  8036c0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c9:	89 10                	mov    %edx,(%eax)
  8036cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ce:	8b 00                	mov    (%eax),%eax
  8036d0:	85 c0                	test   %eax,%eax
  8036d2:	74 0d                	je     8036e1 <realloc_block_FF+0x31b>
  8036d4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036dc:	89 50 04             	mov    %edx,0x4(%eax)
  8036df:	eb 08                	jmp    8036e9 <realloc_block_FF+0x323>
  8036e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036fb:	a1 38 50 80 00       	mov    0x805038,%eax
  803700:	40                   	inc    %eax
  803701:	a3 38 50 80 00       	mov    %eax,0x805038
  803706:	e9 3e 01 00 00       	jmp    803849 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80370b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803710:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803713:	73 68                	jae    80377d <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803715:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803719:	75 17                	jne    803732 <realloc_block_FF+0x36c>
  80371b:	83 ec 04             	sub    $0x4,%esp
  80371e:	68 1c 47 80 00       	push   $0x80471c
  803723:	68 10 02 00 00       	push   $0x210
  803728:	68 cd 46 80 00       	push   $0x8046cd
  80372d:	e8 60 ce ff ff       	call   800592 <_panic>
  803732:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803738:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373b:	89 50 04             	mov    %edx,0x4(%eax)
  80373e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803741:	8b 40 04             	mov    0x4(%eax),%eax
  803744:	85 c0                	test   %eax,%eax
  803746:	74 0c                	je     803754 <realloc_block_FF+0x38e>
  803748:	a1 30 50 80 00       	mov    0x805030,%eax
  80374d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803750:	89 10                	mov    %edx,(%eax)
  803752:	eb 08                	jmp    80375c <realloc_block_FF+0x396>
  803754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803757:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80375c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80375f:	a3 30 50 80 00       	mov    %eax,0x805030
  803764:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803767:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80376d:	a1 38 50 80 00       	mov    0x805038,%eax
  803772:	40                   	inc    %eax
  803773:	a3 38 50 80 00       	mov    %eax,0x805038
  803778:	e9 cc 00 00 00       	jmp    803849 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80377d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803784:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803789:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80378c:	e9 8a 00 00 00       	jmp    80381b <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803794:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803797:	73 7a                	jae    803813 <realloc_block_FF+0x44d>
  803799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379c:	8b 00                	mov    (%eax),%eax
  80379e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037a1:	73 70                	jae    803813 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037a7:	74 06                	je     8037af <realloc_block_FF+0x3e9>
  8037a9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037ad:	75 17                	jne    8037c6 <realloc_block_FF+0x400>
  8037af:	83 ec 04             	sub    $0x4,%esp
  8037b2:	68 40 47 80 00       	push   $0x804740
  8037b7:	68 1a 02 00 00       	push   $0x21a
  8037bc:	68 cd 46 80 00       	push   $0x8046cd
  8037c1:	e8 cc cd ff ff       	call   800592 <_panic>
  8037c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c9:	8b 10                	mov    (%eax),%edx
  8037cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ce:	89 10                	mov    %edx,(%eax)
  8037d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037d3:	8b 00                	mov    (%eax),%eax
  8037d5:	85 c0                	test   %eax,%eax
  8037d7:	74 0b                	je     8037e4 <realloc_block_FF+0x41e>
  8037d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037dc:	8b 00                	mov    (%eax),%eax
  8037de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037e1:	89 50 04             	mov    %edx,0x4(%eax)
  8037e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037ea:	89 10                	mov    %edx,(%eax)
  8037ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037f2:	89 50 04             	mov    %edx,0x4(%eax)
  8037f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037f8:	8b 00                	mov    (%eax),%eax
  8037fa:	85 c0                	test   %eax,%eax
  8037fc:	75 08                	jne    803806 <realloc_block_FF+0x440>
  8037fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803801:	a3 30 50 80 00       	mov    %eax,0x805030
  803806:	a1 38 50 80 00       	mov    0x805038,%eax
  80380b:	40                   	inc    %eax
  80380c:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803811:	eb 36                	jmp    803849 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803813:	a1 34 50 80 00       	mov    0x805034,%eax
  803818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80381b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381f:	74 07                	je     803828 <realloc_block_FF+0x462>
  803821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803824:	8b 00                	mov    (%eax),%eax
  803826:	eb 05                	jmp    80382d <realloc_block_FF+0x467>
  803828:	b8 00 00 00 00       	mov    $0x0,%eax
  80382d:	a3 34 50 80 00       	mov    %eax,0x805034
  803832:	a1 34 50 80 00       	mov    0x805034,%eax
  803837:	85 c0                	test   %eax,%eax
  803839:	0f 85 52 ff ff ff    	jne    803791 <realloc_block_FF+0x3cb>
  80383f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803843:	0f 85 48 ff ff ff    	jne    803791 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803849:	83 ec 04             	sub    $0x4,%esp
  80384c:	6a 00                	push   $0x0
  80384e:	ff 75 d8             	pushl  -0x28(%ebp)
  803851:	ff 75 d4             	pushl  -0x2c(%ebp)
  803854:	e8 7a eb ff ff       	call   8023d3 <set_block_data>
  803859:	83 c4 10             	add    $0x10,%esp
				return va;
  80385c:	8b 45 08             	mov    0x8(%ebp),%eax
  80385f:	e9 7b 02 00 00       	jmp    803adf <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803864:	83 ec 0c             	sub    $0xc,%esp
  803867:	68 bd 47 80 00       	push   $0x8047bd
  80386c:	e8 de cf ff ff       	call   80084f <cprintf>
  803871:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803874:	8b 45 08             	mov    0x8(%ebp),%eax
  803877:	e9 63 02 00 00       	jmp    803adf <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80387c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80387f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803882:	0f 86 4d 02 00 00    	jbe    803ad5 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803888:	83 ec 0c             	sub    $0xc,%esp
  80388b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80388e:	e8 08 e8 ff ff       	call   80209b <is_free_block>
  803893:	83 c4 10             	add    $0x10,%esp
  803896:	84 c0                	test   %al,%al
  803898:	0f 84 37 02 00 00    	je     803ad5 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80389e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038aa:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038ad:	76 38                	jbe    8038e7 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8038af:	83 ec 0c             	sub    $0xc,%esp
  8038b2:	ff 75 08             	pushl  0x8(%ebp)
  8038b5:	e8 0c fa ff ff       	call   8032c6 <free_block>
  8038ba:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038bd:	83 ec 0c             	sub    $0xc,%esp
  8038c0:	ff 75 0c             	pushl  0xc(%ebp)
  8038c3:	e8 3a eb ff ff       	call   802402 <alloc_block_FF>
  8038c8:	83 c4 10             	add    $0x10,%esp
  8038cb:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8038ce:	83 ec 08             	sub    $0x8,%esp
  8038d1:	ff 75 c0             	pushl  -0x40(%ebp)
  8038d4:	ff 75 08             	pushl  0x8(%ebp)
  8038d7:	e8 ab fa ff ff       	call   803387 <copy_data>
  8038dc:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8038df:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038e2:	e9 f8 01 00 00       	jmp    803adf <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8038e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038ea:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038ed:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038f0:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8038f4:	0f 87 a0 00 00 00    	ja     80399a <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8038fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038fe:	75 17                	jne    803917 <realloc_block_FF+0x551>
  803900:	83 ec 04             	sub    $0x4,%esp
  803903:	68 af 46 80 00       	push   $0x8046af
  803908:	68 38 02 00 00       	push   $0x238
  80390d:	68 cd 46 80 00       	push   $0x8046cd
  803912:	e8 7b cc ff ff       	call   800592 <_panic>
  803917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	85 c0                	test   %eax,%eax
  80391e:	74 10                	je     803930 <realloc_block_FF+0x56a>
  803920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803923:	8b 00                	mov    (%eax),%eax
  803925:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803928:	8b 52 04             	mov    0x4(%edx),%edx
  80392b:	89 50 04             	mov    %edx,0x4(%eax)
  80392e:	eb 0b                	jmp    80393b <realloc_block_FF+0x575>
  803930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803933:	8b 40 04             	mov    0x4(%eax),%eax
  803936:	a3 30 50 80 00       	mov    %eax,0x805030
  80393b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393e:	8b 40 04             	mov    0x4(%eax),%eax
  803941:	85 c0                	test   %eax,%eax
  803943:	74 0f                	je     803954 <realloc_block_FF+0x58e>
  803945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803948:	8b 40 04             	mov    0x4(%eax),%eax
  80394b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80394e:	8b 12                	mov    (%edx),%edx
  803950:	89 10                	mov    %edx,(%eax)
  803952:	eb 0a                	jmp    80395e <realloc_block_FF+0x598>
  803954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803957:	8b 00                	mov    (%eax),%eax
  803959:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80395e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803961:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803971:	a1 38 50 80 00       	mov    0x805038,%eax
  803976:	48                   	dec    %eax
  803977:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80397c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80397f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803982:	01 d0                	add    %edx,%eax
  803984:	83 ec 04             	sub    $0x4,%esp
  803987:	6a 01                	push   $0x1
  803989:	50                   	push   %eax
  80398a:	ff 75 08             	pushl  0x8(%ebp)
  80398d:	e8 41 ea ff ff       	call   8023d3 <set_block_data>
  803992:	83 c4 10             	add    $0x10,%esp
  803995:	e9 36 01 00 00       	jmp    803ad0 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80399a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80399d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039a0:	01 d0                	add    %edx,%eax
  8039a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039a5:	83 ec 04             	sub    $0x4,%esp
  8039a8:	6a 01                	push   $0x1
  8039aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8039ad:	ff 75 08             	pushl  0x8(%ebp)
  8039b0:	e8 1e ea ff ff       	call   8023d3 <set_block_data>
  8039b5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bb:	83 e8 04             	sub    $0x4,%eax
  8039be:	8b 00                	mov    (%eax),%eax
  8039c0:	83 e0 fe             	and    $0xfffffffe,%eax
  8039c3:	89 c2                	mov    %eax,%edx
  8039c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c8:	01 d0                	add    %edx,%eax
  8039ca:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039d1:	74 06                	je     8039d9 <realloc_block_FF+0x613>
  8039d3:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8039d7:	75 17                	jne    8039f0 <realloc_block_FF+0x62a>
  8039d9:	83 ec 04             	sub    $0x4,%esp
  8039dc:	68 40 47 80 00       	push   $0x804740
  8039e1:	68 44 02 00 00       	push   $0x244
  8039e6:	68 cd 46 80 00       	push   $0x8046cd
  8039eb:	e8 a2 cb ff ff       	call   800592 <_panic>
  8039f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f3:	8b 10                	mov    (%eax),%edx
  8039f5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039f8:	89 10                	mov    %edx,(%eax)
  8039fa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039fd:	8b 00                	mov    (%eax),%eax
  8039ff:	85 c0                	test   %eax,%eax
  803a01:	74 0b                	je     803a0e <realloc_block_FF+0x648>
  803a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a06:	8b 00                	mov    (%eax),%eax
  803a08:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a0b:	89 50 04             	mov    %edx,0x4(%eax)
  803a0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a11:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a14:	89 10                	mov    %edx,(%eax)
  803a16:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a1c:	89 50 04             	mov    %edx,0x4(%eax)
  803a1f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a22:	8b 00                	mov    (%eax),%eax
  803a24:	85 c0                	test   %eax,%eax
  803a26:	75 08                	jne    803a30 <realloc_block_FF+0x66a>
  803a28:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a2b:	a3 30 50 80 00       	mov    %eax,0x805030
  803a30:	a1 38 50 80 00       	mov    0x805038,%eax
  803a35:	40                   	inc    %eax
  803a36:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a3f:	75 17                	jne    803a58 <realloc_block_FF+0x692>
  803a41:	83 ec 04             	sub    $0x4,%esp
  803a44:	68 af 46 80 00       	push   $0x8046af
  803a49:	68 45 02 00 00       	push   $0x245
  803a4e:	68 cd 46 80 00       	push   $0x8046cd
  803a53:	e8 3a cb ff ff       	call   800592 <_panic>
  803a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5b:	8b 00                	mov    (%eax),%eax
  803a5d:	85 c0                	test   %eax,%eax
  803a5f:	74 10                	je     803a71 <realloc_block_FF+0x6ab>
  803a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a64:	8b 00                	mov    (%eax),%eax
  803a66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a69:	8b 52 04             	mov    0x4(%edx),%edx
  803a6c:	89 50 04             	mov    %edx,0x4(%eax)
  803a6f:	eb 0b                	jmp    803a7c <realloc_block_FF+0x6b6>
  803a71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a74:	8b 40 04             	mov    0x4(%eax),%eax
  803a77:	a3 30 50 80 00       	mov    %eax,0x805030
  803a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7f:	8b 40 04             	mov    0x4(%eax),%eax
  803a82:	85 c0                	test   %eax,%eax
  803a84:	74 0f                	je     803a95 <realloc_block_FF+0x6cf>
  803a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a89:	8b 40 04             	mov    0x4(%eax),%eax
  803a8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a8f:	8b 12                	mov    (%edx),%edx
  803a91:	89 10                	mov    %edx,(%eax)
  803a93:	eb 0a                	jmp    803a9f <realloc_block_FF+0x6d9>
  803a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a98:	8b 00                	mov    (%eax),%eax
  803a9a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ab2:	a1 38 50 80 00       	mov    0x805038,%eax
  803ab7:	48                   	dec    %eax
  803ab8:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803abd:	83 ec 04             	sub    $0x4,%esp
  803ac0:	6a 00                	push   $0x0
  803ac2:	ff 75 bc             	pushl  -0x44(%ebp)
  803ac5:	ff 75 b8             	pushl  -0x48(%ebp)
  803ac8:	e8 06 e9 ff ff       	call   8023d3 <set_block_data>
  803acd:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad3:	eb 0a                	jmp    803adf <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803ad5:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803adc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803adf:	c9                   	leave  
  803ae0:	c3                   	ret    

00803ae1 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803ae1:	55                   	push   %ebp
  803ae2:	89 e5                	mov    %esp,%ebp
  803ae4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803ae7:	83 ec 04             	sub    $0x4,%esp
  803aea:	68 c4 47 80 00       	push   $0x8047c4
  803aef:	68 58 02 00 00       	push   $0x258
  803af4:	68 cd 46 80 00       	push   $0x8046cd
  803af9:	e8 94 ca ff ff       	call   800592 <_panic>

00803afe <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803afe:	55                   	push   %ebp
  803aff:	89 e5                	mov    %esp,%ebp
  803b01:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b04:	83 ec 04             	sub    $0x4,%esp
  803b07:	68 ec 47 80 00       	push   $0x8047ec
  803b0c:	68 61 02 00 00       	push   $0x261
  803b11:	68 cd 46 80 00       	push   $0x8046cd
  803b16:	e8 77 ca ff ff       	call   800592 <_panic>
  803b1b:	90                   	nop

00803b1c <__udivdi3>:
  803b1c:	55                   	push   %ebp
  803b1d:	57                   	push   %edi
  803b1e:	56                   	push   %esi
  803b1f:	53                   	push   %ebx
  803b20:	83 ec 1c             	sub    $0x1c,%esp
  803b23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b33:	89 ca                	mov    %ecx,%edx
  803b35:	89 f8                	mov    %edi,%eax
  803b37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b3b:	85 f6                	test   %esi,%esi
  803b3d:	75 2d                	jne    803b6c <__udivdi3+0x50>
  803b3f:	39 cf                	cmp    %ecx,%edi
  803b41:	77 65                	ja     803ba8 <__udivdi3+0x8c>
  803b43:	89 fd                	mov    %edi,%ebp
  803b45:	85 ff                	test   %edi,%edi
  803b47:	75 0b                	jne    803b54 <__udivdi3+0x38>
  803b49:	b8 01 00 00 00       	mov    $0x1,%eax
  803b4e:	31 d2                	xor    %edx,%edx
  803b50:	f7 f7                	div    %edi
  803b52:	89 c5                	mov    %eax,%ebp
  803b54:	31 d2                	xor    %edx,%edx
  803b56:	89 c8                	mov    %ecx,%eax
  803b58:	f7 f5                	div    %ebp
  803b5a:	89 c1                	mov    %eax,%ecx
  803b5c:	89 d8                	mov    %ebx,%eax
  803b5e:	f7 f5                	div    %ebp
  803b60:	89 cf                	mov    %ecx,%edi
  803b62:	89 fa                	mov    %edi,%edx
  803b64:	83 c4 1c             	add    $0x1c,%esp
  803b67:	5b                   	pop    %ebx
  803b68:	5e                   	pop    %esi
  803b69:	5f                   	pop    %edi
  803b6a:	5d                   	pop    %ebp
  803b6b:	c3                   	ret    
  803b6c:	39 ce                	cmp    %ecx,%esi
  803b6e:	77 28                	ja     803b98 <__udivdi3+0x7c>
  803b70:	0f bd fe             	bsr    %esi,%edi
  803b73:	83 f7 1f             	xor    $0x1f,%edi
  803b76:	75 40                	jne    803bb8 <__udivdi3+0x9c>
  803b78:	39 ce                	cmp    %ecx,%esi
  803b7a:	72 0a                	jb     803b86 <__udivdi3+0x6a>
  803b7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b80:	0f 87 9e 00 00 00    	ja     803c24 <__udivdi3+0x108>
  803b86:	b8 01 00 00 00       	mov    $0x1,%eax
  803b8b:	89 fa                	mov    %edi,%edx
  803b8d:	83 c4 1c             	add    $0x1c,%esp
  803b90:	5b                   	pop    %ebx
  803b91:	5e                   	pop    %esi
  803b92:	5f                   	pop    %edi
  803b93:	5d                   	pop    %ebp
  803b94:	c3                   	ret    
  803b95:	8d 76 00             	lea    0x0(%esi),%esi
  803b98:	31 ff                	xor    %edi,%edi
  803b9a:	31 c0                	xor    %eax,%eax
  803b9c:	89 fa                	mov    %edi,%edx
  803b9e:	83 c4 1c             	add    $0x1c,%esp
  803ba1:	5b                   	pop    %ebx
  803ba2:	5e                   	pop    %esi
  803ba3:	5f                   	pop    %edi
  803ba4:	5d                   	pop    %ebp
  803ba5:	c3                   	ret    
  803ba6:	66 90                	xchg   %ax,%ax
  803ba8:	89 d8                	mov    %ebx,%eax
  803baa:	f7 f7                	div    %edi
  803bac:	31 ff                	xor    %edi,%edi
  803bae:	89 fa                	mov    %edi,%edx
  803bb0:	83 c4 1c             	add    $0x1c,%esp
  803bb3:	5b                   	pop    %ebx
  803bb4:	5e                   	pop    %esi
  803bb5:	5f                   	pop    %edi
  803bb6:	5d                   	pop    %ebp
  803bb7:	c3                   	ret    
  803bb8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bbd:	89 eb                	mov    %ebp,%ebx
  803bbf:	29 fb                	sub    %edi,%ebx
  803bc1:	89 f9                	mov    %edi,%ecx
  803bc3:	d3 e6                	shl    %cl,%esi
  803bc5:	89 c5                	mov    %eax,%ebp
  803bc7:	88 d9                	mov    %bl,%cl
  803bc9:	d3 ed                	shr    %cl,%ebp
  803bcb:	89 e9                	mov    %ebp,%ecx
  803bcd:	09 f1                	or     %esi,%ecx
  803bcf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bd3:	89 f9                	mov    %edi,%ecx
  803bd5:	d3 e0                	shl    %cl,%eax
  803bd7:	89 c5                	mov    %eax,%ebp
  803bd9:	89 d6                	mov    %edx,%esi
  803bdb:	88 d9                	mov    %bl,%cl
  803bdd:	d3 ee                	shr    %cl,%esi
  803bdf:	89 f9                	mov    %edi,%ecx
  803be1:	d3 e2                	shl    %cl,%edx
  803be3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be7:	88 d9                	mov    %bl,%cl
  803be9:	d3 e8                	shr    %cl,%eax
  803beb:	09 c2                	or     %eax,%edx
  803bed:	89 d0                	mov    %edx,%eax
  803bef:	89 f2                	mov    %esi,%edx
  803bf1:	f7 74 24 0c          	divl   0xc(%esp)
  803bf5:	89 d6                	mov    %edx,%esi
  803bf7:	89 c3                	mov    %eax,%ebx
  803bf9:	f7 e5                	mul    %ebp
  803bfb:	39 d6                	cmp    %edx,%esi
  803bfd:	72 19                	jb     803c18 <__udivdi3+0xfc>
  803bff:	74 0b                	je     803c0c <__udivdi3+0xf0>
  803c01:	89 d8                	mov    %ebx,%eax
  803c03:	31 ff                	xor    %edi,%edi
  803c05:	e9 58 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c0a:	66 90                	xchg   %ax,%ax
  803c0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c10:	89 f9                	mov    %edi,%ecx
  803c12:	d3 e2                	shl    %cl,%edx
  803c14:	39 c2                	cmp    %eax,%edx
  803c16:	73 e9                	jae    803c01 <__udivdi3+0xe5>
  803c18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c1b:	31 ff                	xor    %edi,%edi
  803c1d:	e9 40 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c22:	66 90                	xchg   %ax,%ax
  803c24:	31 c0                	xor    %eax,%eax
  803c26:	e9 37 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c2b:	90                   	nop

00803c2c <__umoddi3>:
  803c2c:	55                   	push   %ebp
  803c2d:	57                   	push   %edi
  803c2e:	56                   	push   %esi
  803c2f:	53                   	push   %ebx
  803c30:	83 ec 1c             	sub    $0x1c,%esp
  803c33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c37:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c4b:	89 f3                	mov    %esi,%ebx
  803c4d:	89 fa                	mov    %edi,%edx
  803c4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c53:	89 34 24             	mov    %esi,(%esp)
  803c56:	85 c0                	test   %eax,%eax
  803c58:	75 1a                	jne    803c74 <__umoddi3+0x48>
  803c5a:	39 f7                	cmp    %esi,%edi
  803c5c:	0f 86 a2 00 00 00    	jbe    803d04 <__umoddi3+0xd8>
  803c62:	89 c8                	mov    %ecx,%eax
  803c64:	89 f2                	mov    %esi,%edx
  803c66:	f7 f7                	div    %edi
  803c68:	89 d0                	mov    %edx,%eax
  803c6a:	31 d2                	xor    %edx,%edx
  803c6c:	83 c4 1c             	add    $0x1c,%esp
  803c6f:	5b                   	pop    %ebx
  803c70:	5e                   	pop    %esi
  803c71:	5f                   	pop    %edi
  803c72:	5d                   	pop    %ebp
  803c73:	c3                   	ret    
  803c74:	39 f0                	cmp    %esi,%eax
  803c76:	0f 87 ac 00 00 00    	ja     803d28 <__umoddi3+0xfc>
  803c7c:	0f bd e8             	bsr    %eax,%ebp
  803c7f:	83 f5 1f             	xor    $0x1f,%ebp
  803c82:	0f 84 ac 00 00 00    	je     803d34 <__umoddi3+0x108>
  803c88:	bf 20 00 00 00       	mov    $0x20,%edi
  803c8d:	29 ef                	sub    %ebp,%edi
  803c8f:	89 fe                	mov    %edi,%esi
  803c91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c95:	89 e9                	mov    %ebp,%ecx
  803c97:	d3 e0                	shl    %cl,%eax
  803c99:	89 d7                	mov    %edx,%edi
  803c9b:	89 f1                	mov    %esi,%ecx
  803c9d:	d3 ef                	shr    %cl,%edi
  803c9f:	09 c7                	or     %eax,%edi
  803ca1:	89 e9                	mov    %ebp,%ecx
  803ca3:	d3 e2                	shl    %cl,%edx
  803ca5:	89 14 24             	mov    %edx,(%esp)
  803ca8:	89 d8                	mov    %ebx,%eax
  803caa:	d3 e0                	shl    %cl,%eax
  803cac:	89 c2                	mov    %eax,%edx
  803cae:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cb2:	d3 e0                	shl    %cl,%eax
  803cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cb8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cbc:	89 f1                	mov    %esi,%ecx
  803cbe:	d3 e8                	shr    %cl,%eax
  803cc0:	09 d0                	or     %edx,%eax
  803cc2:	d3 eb                	shr    %cl,%ebx
  803cc4:	89 da                	mov    %ebx,%edx
  803cc6:	f7 f7                	div    %edi
  803cc8:	89 d3                	mov    %edx,%ebx
  803cca:	f7 24 24             	mull   (%esp)
  803ccd:	89 c6                	mov    %eax,%esi
  803ccf:	89 d1                	mov    %edx,%ecx
  803cd1:	39 d3                	cmp    %edx,%ebx
  803cd3:	0f 82 87 00 00 00    	jb     803d60 <__umoddi3+0x134>
  803cd9:	0f 84 91 00 00 00    	je     803d70 <__umoddi3+0x144>
  803cdf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ce3:	29 f2                	sub    %esi,%edx
  803ce5:	19 cb                	sbb    %ecx,%ebx
  803ce7:	89 d8                	mov    %ebx,%eax
  803ce9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ced:	d3 e0                	shl    %cl,%eax
  803cef:	89 e9                	mov    %ebp,%ecx
  803cf1:	d3 ea                	shr    %cl,%edx
  803cf3:	09 d0                	or     %edx,%eax
  803cf5:	89 e9                	mov    %ebp,%ecx
  803cf7:	d3 eb                	shr    %cl,%ebx
  803cf9:	89 da                	mov    %ebx,%edx
  803cfb:	83 c4 1c             	add    $0x1c,%esp
  803cfe:	5b                   	pop    %ebx
  803cff:	5e                   	pop    %esi
  803d00:	5f                   	pop    %edi
  803d01:	5d                   	pop    %ebp
  803d02:	c3                   	ret    
  803d03:	90                   	nop
  803d04:	89 fd                	mov    %edi,%ebp
  803d06:	85 ff                	test   %edi,%edi
  803d08:	75 0b                	jne    803d15 <__umoddi3+0xe9>
  803d0a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d0f:	31 d2                	xor    %edx,%edx
  803d11:	f7 f7                	div    %edi
  803d13:	89 c5                	mov    %eax,%ebp
  803d15:	89 f0                	mov    %esi,%eax
  803d17:	31 d2                	xor    %edx,%edx
  803d19:	f7 f5                	div    %ebp
  803d1b:	89 c8                	mov    %ecx,%eax
  803d1d:	f7 f5                	div    %ebp
  803d1f:	89 d0                	mov    %edx,%eax
  803d21:	e9 44 ff ff ff       	jmp    803c6a <__umoddi3+0x3e>
  803d26:	66 90                	xchg   %ax,%ax
  803d28:	89 c8                	mov    %ecx,%eax
  803d2a:	89 f2                	mov    %esi,%edx
  803d2c:	83 c4 1c             	add    $0x1c,%esp
  803d2f:	5b                   	pop    %ebx
  803d30:	5e                   	pop    %esi
  803d31:	5f                   	pop    %edi
  803d32:	5d                   	pop    %ebp
  803d33:	c3                   	ret    
  803d34:	3b 04 24             	cmp    (%esp),%eax
  803d37:	72 06                	jb     803d3f <__umoddi3+0x113>
  803d39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d3d:	77 0f                	ja     803d4e <__umoddi3+0x122>
  803d3f:	89 f2                	mov    %esi,%edx
  803d41:	29 f9                	sub    %edi,%ecx
  803d43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d47:	89 14 24             	mov    %edx,(%esp)
  803d4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d52:	8b 14 24             	mov    (%esp),%edx
  803d55:	83 c4 1c             	add    $0x1c,%esp
  803d58:	5b                   	pop    %ebx
  803d59:	5e                   	pop    %esi
  803d5a:	5f                   	pop    %edi
  803d5b:	5d                   	pop    %ebp
  803d5c:	c3                   	ret    
  803d5d:	8d 76 00             	lea    0x0(%esi),%esi
  803d60:	2b 04 24             	sub    (%esp),%eax
  803d63:	19 fa                	sbb    %edi,%edx
  803d65:	89 d1                	mov    %edx,%ecx
  803d67:	89 c6                	mov    %eax,%esi
  803d69:	e9 71 ff ff ff       	jmp    803cdf <__umoddi3+0xb3>
  803d6e:	66 90                	xchg   %ax,%ax
  803d70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d74:	72 ea                	jb     803d60 <__umoddi3+0x134>
  803d76:	89 d9                	mov    %ebx,%ecx
  803d78:	e9 62 ff ff ff       	jmp    803cdf <__umoddi3+0xb3>
