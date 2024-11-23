
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
  80005c:	68 40 3e 80 00       	push   $0x803e40
  800061:	6a 14                	push   $0x14
  800063:	68 5c 3e 80 00       	push   $0x803e5c
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
  800082:	e8 a4 1b 00 00       	call   801c2b <sys_calculate_free_frames>
  800087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = smalloc("x", 4, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 04                	push   $0x4
  800091:	68 77 3e 80 00       	push   $0x803e77
  800096:	e8 81 18 00 00       	call   80191c <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 7c 3e 80 00       	push   $0x803e7c
  8000b8:	e8 92 07 00 00       	call   80084f <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8000c0:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8000c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ca:	e8 5c 1b 00 00       	call   801c2b <sys_calculate_free_frames>
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
  8000f3:	e8 33 1b 00 00       	call   801c2b <sys_calculate_free_frames>
  8000f8:	29 c3                	sub    %eax,%ebx
  8000fa:	89 d8                	mov    %ebx,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800102:	50                   	push   %eax
  800103:	68 e0 3e 80 00       	push   $0x803ee0
  800108:	e8 42 07 00 00       	call   80084f <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800110:	e8 16 1b 00 00       	call   801c2b <sys_calculate_free_frames>
  800115:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = smalloc("y", 4, 0);
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	6a 00                	push   $0x0
  80011d:	6a 04                	push   $0x4
  80011f:	68 78 3f 80 00       	push   $0x803f78
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
  800146:	68 7c 3e 80 00       	push   $0x803e7c
  80014b:	e8 ff 06 00 00       	call   80084f <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  800153:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80015a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80015d:	e8 c9 1a 00 00       	call   801c2b <sys_calculate_free_frames>
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
  800186:	e8 a0 1a 00 00       	call   801c2b <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	50                   	push   %eax
  800196:	68 e0 3e 80 00       	push   $0x803ee0
  80019b:	e8 af 06 00 00       	call   80084f <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  8001a3:	e8 83 1a 00 00       	call   801c2b <sys_calculate_free_frames>
  8001a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = smalloc("z", 4, 1);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 01                	push   $0x1
  8001b0:	6a 04                	push   $0x4
  8001b2:	68 7a 3f 80 00       	push   $0x803f7a
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
  8001d9:	68 7c 3e 80 00       	push   $0x803e7c
  8001de:	e8 6c 06 00 00       	call   80084f <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8001e6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001f0:	e8 36 1a 00 00       	call   801c2b <sys_calculate_free_frames>
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
  800219:	e8 0d 1a 00 00       	call   801c2b <sys_calculate_free_frames>
  80021e:	29 c3                	sub    %eax,%ebx
  800220:	89 d8                	mov    %ebx,%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	50                   	push   %eax
  800229:	68 e0 3e 80 00       	push   $0x803ee0
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
  80027f:	68 7c 3f 80 00       	push   $0x803f7c
  800284:	e8 fd 1a 00 00       	call   801d86 <sys_create_env>
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
  8002b5:	68 7c 3f 80 00       	push   $0x803f7c
  8002ba:	e8 c7 1a 00 00       	call   801d86 <sys_create_env>
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
  8002eb:	68 7c 3f 80 00       	push   $0x803f7c
  8002f0:	e8 91 1a 00 00       	call   801d86 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8002fb:	e8 d2 1b 00 00       	call   801ed2 <rsttst>

	sys_run_env(id1);\
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 d0             	pushl  -0x30(%ebp)
  800306:	e8 99 1a 00 00       	call   801da4 <sys_run_env>
  80030b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 cc             	pushl  -0x34(%ebp)
  800314:	e8 8b 1a 00 00       	call   801da4 <sys_run_env>
  800319:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 c8             	pushl  -0x38(%ebp)
  800322:	e8 7d 1a 00 00       	call   801da4 <sys_run_env>
  800327:	83 c4 10             	add    $0x10,%esp
	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  80032a:	90                   	nop
  80032b:	e8 1c 1c 00 00       	call   801f4c <gettst>
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
  800349:	68 88 3f 80 00       	push   $0x803f88
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
  80036a:	68 d4 3f 80 00       	push   $0x803fd4
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
  80039d:	68 06 40 80 00       	push   $0x804006
  8003a2:	e8 df 19 00 00       	call   801d86 <sys_create_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b3:	e8 ec 19 00 00       	call   801da4 <sys_run_env>
  8003b8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  8003bb:	90                   	nop
  8003bc:	e8 8b 1b 00 00       	call   801f4c <gettst>
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
  8003da:	68 88 3f 80 00       	push   $0x803f88
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
  8003f8:	e8 35 1b 00 00       	call   801f32 <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8003fd:	90                   	nop
  8003fe:	e8 49 1b 00 00       	call   801f4c <gettst>
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
  80041c:	68 88 3f 80 00       	push   $0x803f88
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
  800440:	68 14 40 80 00       	push   $0x804014
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
  800459:	e8 96 19 00 00       	call   801df4 <sys_getenvindex>
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
  8004c7:	e8 ac 16 00 00       	call   801b78 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004cc:	83 ec 0c             	sub    $0xc,%esp
  8004cf:	68 70 40 80 00       	push   $0x804070
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
  8004f7:	68 98 40 80 00       	push   $0x804098
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
  800528:	68 c0 40 80 00       	push   $0x8040c0
  80052d:	e8 1d 03 00 00       	call   80084f <cprintf>
  800532:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800535:	a1 20 50 80 00       	mov    0x805020,%eax
  80053a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	50                   	push   %eax
  800544:	68 18 41 80 00       	push   $0x804118
  800549:	e8 01 03 00 00       	call   80084f <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 70 40 80 00       	push   $0x804070
  800559:	e8 f1 02 00 00       	call   80084f <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800561:	e8 2c 16 00 00       	call   801b92 <sys_unlock_cons>
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
  800579:	e8 42 18 00 00       	call   801dc0 <sys_destroy_env>
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
  80058a:	e8 97 18 00 00       	call   801e26 <sys_exit_env>
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
  8005b3:	68 2c 41 80 00       	push   $0x80412c
  8005b8:	e8 92 02 00 00       	call   80084f <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005c0:	a1 00 50 80 00       	mov    0x805000,%eax
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	50                   	push   %eax
  8005cc:	68 31 41 80 00       	push   $0x804131
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
  8005f0:	68 4d 41 80 00       	push   $0x80414d
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
  80061f:	68 50 41 80 00       	push   $0x804150
  800624:	6a 26                	push   $0x26
  800626:	68 9c 41 80 00       	push   $0x80419c
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
  8006f4:	68 a8 41 80 00       	push   $0x8041a8
  8006f9:	6a 3a                	push   $0x3a
  8006fb:	68 9c 41 80 00       	push   $0x80419c
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
  800767:	68 fc 41 80 00       	push   $0x8041fc
  80076c:	6a 44                	push   $0x44
  80076e:	68 9c 41 80 00       	push   $0x80419c
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
  8007c1:	e8 70 13 00 00       	call   801b36 <sys_cputs>
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
  800838:	e8 f9 12 00 00       	call   801b36 <sys_cputs>
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
  800882:	e8 f1 12 00 00       	call   801b78 <sys_lock_cons>
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
  8008a2:	e8 eb 12 00 00       	call   801b92 <sys_unlock_cons>
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
  8008ec:	e8 df 32 00 00       	call   803bd0 <__udivdi3>
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
  80093c:	e8 9f 33 00 00       	call   803ce0 <__umoddi3>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	05 74 44 80 00       	add    $0x804474,%eax
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
  800a97:	8b 04 85 98 44 80 00 	mov    0x804498(,%eax,4),%eax
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
  800b78:	8b 34 9d e0 42 80 00 	mov    0x8042e0(,%ebx,4),%esi
  800b7f:	85 f6                	test   %esi,%esi
  800b81:	75 19                	jne    800b9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b83:	53                   	push   %ebx
  800b84:	68 85 44 80 00       	push   $0x804485
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
  800b9d:	68 8e 44 80 00       	push   $0x80448e
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
  800bca:	be 91 44 80 00       	mov    $0x804491,%esi
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
  8015d5:	68 08 46 80 00       	push   $0x804608
  8015da:	68 3f 01 00 00       	push   $0x13f
  8015df:	68 2a 46 80 00       	push   $0x80462a
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
  8015f5:	e8 e7 0a 00 00       	call   8020e1 <sys_sbrk>
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
  801670:	e8 f0 08 00 00       	call   801f65 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801675:	85 c0                	test   %eax,%eax
  801677:	74 16                	je     80168f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	e8 30 0e 00 00       	call   8024b4 <alloc_block_FF>
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168a:	e9 8a 01 00 00       	jmp    801819 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80168f:	e8 02 09 00 00       	call   801f96 <sys_isUHeapPlacementStrategyBESTFIT>
  801694:	85 c0                	test   %eax,%eax
  801696:	0f 84 7d 01 00 00    	je     801819 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	e8 c9 12 00 00       	call   802970 <alloc_block_BF>
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
  8016f2:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  80173f:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801796:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  8017f8:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8017ff:	83 ec 08             	sub    $0x8,%esp
  801802:	ff 75 08             	pushl  0x8(%ebp)
  801805:	ff 75 f0             	pushl  -0x10(%ebp)
  801808:	e8 0b 09 00 00       	call   802118 <sys_allocate_user_mem>
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
  801850:	e8 df 08 00 00       	call   802134 <get_block_size>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 12 1b 00 00       	call   803378 <free_block>
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
  80189b:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  8018d8:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  8018f8:	e8 ff 07 00 00       	call   8020fc <sys_free_user_mem>
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
  801906:	68 38 46 80 00       	push   $0x804638
  80190b:	68 85 00 00 00       	push   $0x85
  801910:	68 62 46 80 00       	push   $0x804662
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
  80192c:	75 0a                	jne    801938 <smalloc+0x1c>
  80192e:	b8 00 00 00 00       	mov    $0x0,%eax
  801933:	e9 9a 00 00 00       	jmp    8019d2 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80193e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801945:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194b:	39 d0                	cmp    %edx,%eax
  80194d:	73 02                	jae    801951 <smalloc+0x35>
  80194f:	89 d0                	mov    %edx,%eax
  801951:	83 ec 0c             	sub    $0xc,%esp
  801954:	50                   	push   %eax
  801955:	e8 a5 fc ff ff       	call   8015ff <malloc>
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801960:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801964:	75 07                	jne    80196d <smalloc+0x51>
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	eb 65                	jmp    8019d2 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80196d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801971:	ff 75 ec             	pushl  -0x14(%ebp)
  801974:	50                   	push   %eax
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	ff 75 08             	pushl  0x8(%ebp)
  80197b:	e8 83 03 00 00       	call   801d03 <sys_createSharedObject>
  801980:	83 c4 10             	add    $0x10,%esp
  801983:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801986:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80198a:	74 06                	je     801992 <smalloc+0x76>
  80198c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801990:	75 07                	jne    801999 <smalloc+0x7d>
  801992:	b8 00 00 00 00       	mov    $0x0,%eax
  801997:	eb 39                	jmp    8019d2 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801999:	83 ec 08             	sub    $0x8,%esp
  80199c:	ff 75 ec             	pushl  -0x14(%ebp)
  80199f:	68 6e 46 80 00       	push   $0x80466e
  8019a4:	e8 a6 ee ff ff       	call   80084f <cprintf>
  8019a9:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8019ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019af:	a1 20 50 80 00       	mov    0x805020,%eax
  8019b4:	8b 40 78             	mov    0x78(%eax),%eax
  8019b7:	29 c2                	sub    %eax,%edx
  8019b9:	89 d0                	mov    %edx,%eax
  8019bb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019c0:	c1 e8 0c             	shr    $0xc,%eax
  8019c3:	89 c2                	mov    %eax,%edx
  8019c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019c8:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8019cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8019da:	83 ec 08             	sub    $0x8,%esp
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	ff 75 08             	pushl  0x8(%ebp)
  8019e3:	e8 45 03 00 00       	call   801d2d <sys_getSizeOfSharedObject>
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8019ee:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019f2:	75 07                	jne    8019fb <sget+0x27>
  8019f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f9:	eb 5c                	jmp    801a57 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8019fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a01:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0e:	39 d0                	cmp    %edx,%eax
  801a10:	7d 02                	jge    801a14 <sget+0x40>
  801a12:	89 d0                	mov    %edx,%eax
  801a14:	83 ec 0c             	sub    $0xc,%esp
  801a17:	50                   	push   %eax
  801a18:	e8 e2 fb ff ff       	call   8015ff <malloc>
  801a1d:	83 c4 10             	add    $0x10,%esp
  801a20:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801a23:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a27:	75 07                	jne    801a30 <sget+0x5c>
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2e:	eb 27                	jmp    801a57 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	ff 75 e8             	pushl  -0x18(%ebp)
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	ff 75 08             	pushl  0x8(%ebp)
  801a3c:	e8 09 03 00 00       	call   801d4a <sys_getSharedObject>
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801a47:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a4b:	75 07                	jne    801a54 <sget+0x80>
  801a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a52:	eb 03                	jmp    801a57 <sget+0x83>
	return ptr;
  801a54:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801a5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a62:	a1 20 50 80 00       	mov    0x805020,%eax
  801a67:	8b 40 78             	mov    0x78(%eax),%eax
  801a6a:	29 c2                	sub    %eax,%edx
  801a6c:	89 d0                	mov    %edx,%eax
  801a6e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a73:	c1 e8 0c             	shr    $0xc,%eax
  801a76:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	ff 75 08             	pushl  0x8(%ebp)
  801a86:	ff 75 f4             	pushl  -0xc(%ebp)
  801a89:	e8 db 02 00 00       	call   801d69 <sys_freeSharedObject>
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801a94:	90                   	nop
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	68 80 46 80 00       	push   $0x804680
  801aa5:	68 dd 00 00 00       	push   $0xdd
  801aaa:	68 62 46 80 00       	push   $0x804662
  801aaf:	e8 de ea ff ff       	call   800592 <_panic>

00801ab4 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aba:	83 ec 04             	sub    $0x4,%esp
  801abd:	68 a6 46 80 00       	push   $0x8046a6
  801ac2:	68 e9 00 00 00       	push   $0xe9
  801ac7:	68 62 46 80 00       	push   $0x804662
  801acc:	e8 c1 ea ff ff       	call   800592 <_panic>

00801ad1 <shrink>:

}
void shrink(uint32 newSize)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ad7:	83 ec 04             	sub    $0x4,%esp
  801ada:	68 a6 46 80 00       	push   $0x8046a6
  801adf:	68 ee 00 00 00       	push   $0xee
  801ae4:	68 62 46 80 00       	push   $0x804662
  801ae9:	e8 a4 ea ff ff       	call   800592 <_panic>

00801aee <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801af4:	83 ec 04             	sub    $0x4,%esp
  801af7:	68 a6 46 80 00       	push   $0x8046a6
  801afc:	68 f3 00 00 00       	push   $0xf3
  801b01:	68 62 46 80 00       	push   $0x804662
  801b06:	e8 87 ea ff ff       	call   800592 <_panic>

00801b0b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	57                   	push   %edi
  801b0f:	56                   	push   %esi
  801b10:	53                   	push   %ebx
  801b11:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b20:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b23:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b26:	cd 30                	int    $0x30
  801b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	5b                   	pop    %ebx
  801b32:	5e                   	pop    %esi
  801b33:	5f                   	pop    %edi
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    

00801b36 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	83 ec 04             	sub    $0x4,%esp
  801b3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b42:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	52                   	push   %edx
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	50                   	push   %eax
  801b52:	6a 00                	push   $0x0
  801b54:	e8 b2 ff ff ff       	call   801b0b <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	90                   	nop
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_cgetc>:

int
sys_cgetc(void)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 02                	push   $0x2
  801b6e:	e8 98 ff ff ff       	call   801b0b <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 03                	push   $0x3
  801b87:	e8 7f ff ff ff       	call   801b0b <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	90                   	nop
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 04                	push   $0x4
  801ba1:	e8 65 ff ff ff       	call   801b0b <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	90                   	nop
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801baf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	52                   	push   %edx
  801bbc:	50                   	push   %eax
  801bbd:	6a 08                	push   $0x8
  801bbf:	e8 47 ff ff ff       	call   801b0b <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	56                   	push   %esi
  801bcd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bce:	8b 75 18             	mov    0x18(%ebp),%esi
  801bd1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bd4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	56                   	push   %esi
  801bde:	53                   	push   %ebx
  801bdf:	51                   	push   %ecx
  801be0:	52                   	push   %edx
  801be1:	50                   	push   %eax
  801be2:	6a 09                	push   $0x9
  801be4:	e8 22 ff ff ff       	call   801b0b <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    

00801bf3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	52                   	push   %edx
  801c03:	50                   	push   %eax
  801c04:	6a 0a                	push   $0xa
  801c06:	e8 00 ff ff ff       	call   801b0b <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	ff 75 0c             	pushl  0xc(%ebp)
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	6a 0b                	push   $0xb
  801c21:	e8 e5 fe ff ff       	call   801b0b <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 0c                	push   $0xc
  801c3a:	e8 cc fe ff ff       	call   801b0b <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 0d                	push   $0xd
  801c53:	e8 b3 fe ff ff       	call   801b0b <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 0e                	push   $0xe
  801c6c:	e8 9a fe ff ff       	call   801b0b <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 0f                	push   $0xf
  801c85:	e8 81 fe ff ff       	call   801b0b <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	ff 75 08             	pushl  0x8(%ebp)
  801c9d:	6a 10                	push   $0x10
  801c9f:	e8 67 fe ff ff       	call   801b0b <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 11                	push   $0x11
  801cb8:	e8 4e fe ff ff       	call   801b0b <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	90                   	nop
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_cputc>:

void
sys_cputc(const char c)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ccf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	50                   	push   %eax
  801cdc:	6a 01                	push   $0x1
  801cde:	e8 28 fe ff ff       	call   801b0b <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	90                   	nop
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 14                	push   $0x14
  801cf8:	e8 0e fe ff ff       	call   801b0b <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	90                   	nop
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d0f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d12:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	6a 00                	push   $0x0
  801d1b:	51                   	push   %ecx
  801d1c:	52                   	push   %edx
  801d1d:	ff 75 0c             	pushl  0xc(%ebp)
  801d20:	50                   	push   %eax
  801d21:	6a 15                	push   $0x15
  801d23:	e8 e3 fd ff ff       	call   801b0b <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	52                   	push   %edx
  801d3d:	50                   	push   %eax
  801d3e:	6a 16                	push   $0x16
  801d40:	e8 c6 fd ff ff       	call   801b0b <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	51                   	push   %ecx
  801d5b:	52                   	push   %edx
  801d5c:	50                   	push   %eax
  801d5d:	6a 17                	push   $0x17
  801d5f:	e8 a7 fd ff ff       	call   801b0b <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	52                   	push   %edx
  801d79:	50                   	push   %eax
  801d7a:	6a 18                	push   $0x18
  801d7c:	e8 8a fd ff ff       	call   801b0b <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	6a 00                	push   $0x0
  801d8e:	ff 75 14             	pushl  0x14(%ebp)
  801d91:	ff 75 10             	pushl  0x10(%ebp)
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	50                   	push   %eax
  801d98:	6a 19                	push   $0x19
  801d9a:	e8 6c fd ff ff       	call   801b0b <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801da7:	8b 45 08             	mov    0x8(%ebp),%eax
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	50                   	push   %eax
  801db3:	6a 1a                	push   $0x1a
  801db5:	e8 51 fd ff ff       	call   801b0b <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	90                   	nop
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	50                   	push   %eax
  801dcf:	6a 1b                	push   $0x1b
  801dd1:	e8 35 fd ff ff       	call   801b0b <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 05                	push   $0x5
  801dea:	e8 1c fd ff ff       	call   801b0b <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 06                	push   $0x6
  801e03:	e8 03 fd ff ff       	call   801b0b <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 07                	push   $0x7
  801e1c:	e8 ea fc ff ff       	call   801b0b <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_exit_env>:


void sys_exit_env(void)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 1c                	push   $0x1c
  801e35:	e8 d1 fc ff ff       	call   801b0b <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	90                   	nop
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e46:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e49:	8d 50 04             	lea    0x4(%eax),%edx
  801e4c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	52                   	push   %edx
  801e56:	50                   	push   %eax
  801e57:	6a 1d                	push   $0x1d
  801e59:	e8 ad fc ff ff       	call   801b0b <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
	return result;
  801e61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e6a:	89 01                	mov    %eax,(%ecx)
  801e6c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	c9                   	leave  
  801e73:	c2 04 00             	ret    $0x4

00801e76 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	ff 75 10             	pushl  0x10(%ebp)
  801e80:	ff 75 0c             	pushl  0xc(%ebp)
  801e83:	ff 75 08             	pushl  0x8(%ebp)
  801e86:	6a 13                	push   $0x13
  801e88:	e8 7e fc ff ff       	call   801b0b <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e90:	90                   	nop
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 1e                	push   $0x1e
  801ea2:	e8 64 fc ff ff       	call   801b0b <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 04             	sub    $0x4,%esp
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801eb8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	50                   	push   %eax
  801ec5:	6a 1f                	push   $0x1f
  801ec7:	e8 3f fc ff ff       	call   801b0b <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecf:	90                   	nop
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <rsttst>:
void rsttst()
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 21                	push   $0x21
  801ee1:	e8 25 fc ff ff       	call   801b0b <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee9:	90                   	nop
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ef8:	8b 55 18             	mov    0x18(%ebp),%edx
  801efb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eff:	52                   	push   %edx
  801f00:	50                   	push   %eax
  801f01:	ff 75 10             	pushl  0x10(%ebp)
  801f04:	ff 75 0c             	pushl  0xc(%ebp)
  801f07:	ff 75 08             	pushl  0x8(%ebp)
  801f0a:	6a 20                	push   $0x20
  801f0c:	e8 fa fb ff ff       	call   801b0b <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
	return ;
  801f14:	90                   	nop
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <chktst>:
void chktst(uint32 n)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	ff 75 08             	pushl  0x8(%ebp)
  801f25:	6a 22                	push   $0x22
  801f27:	e8 df fb ff ff       	call   801b0b <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2f:	90                   	nop
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <inctst>:

void inctst()
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 23                	push   $0x23
  801f41:	e8 c5 fb ff ff       	call   801b0b <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
	return ;
  801f49:	90                   	nop
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <gettst>:
uint32 gettst()
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 24                	push   $0x24
  801f5b:	e8 ab fb ff ff       	call   801b0b <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 25                	push   $0x25
  801f77:	e8 8f fb ff ff       	call   801b0b <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
  801f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f82:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f86:	75 07                	jne    801f8f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f88:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8d:	eb 05                	jmp    801f94 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 25                	push   $0x25
  801fa8:	e8 5e fb ff ff       	call   801b0b <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
  801fb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fb3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fb7:	75 07                	jne    801fc0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbe:	eb 05                	jmp    801fc5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 25                	push   $0x25
  801fd9:	e8 2d fb ff ff       	call   801b0b <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
  801fe1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fe4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fe8:	75 07                	jne    801ff1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fea:	b8 01 00 00 00       	mov    $0x1,%eax
  801fef:	eb 05                	jmp    801ff6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ff1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
  801ffb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 25                	push   $0x25
  80200a:	e8 fc fa ff ff       	call   801b0b <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
  802012:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802015:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802019:	75 07                	jne    802022 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80201b:	b8 01 00 00 00       	mov    $0x1,%eax
  802020:	eb 05                	jmp    802027 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	ff 75 08             	pushl  0x8(%ebp)
  802037:	6a 26                	push   $0x26
  802039:	e8 cd fa ff ff       	call   801b0b <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
	return ;
  802041:	90                   	nop
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802048:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80204b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	6a 00                	push   $0x0
  802056:	53                   	push   %ebx
  802057:	51                   	push   %ecx
  802058:	52                   	push   %edx
  802059:	50                   	push   %eax
  80205a:	6a 27                	push   $0x27
  80205c:	e8 aa fa ff ff       	call   801b0b <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
}
  802064:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80206c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	52                   	push   %edx
  802079:	50                   	push   %eax
  80207a:	6a 28                	push   $0x28
  80207c:	e8 8a fa ff ff       	call   801b0b <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802089:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80208c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	6a 00                	push   $0x0
  802094:	51                   	push   %ecx
  802095:	ff 75 10             	pushl  0x10(%ebp)
  802098:	52                   	push   %edx
  802099:	50                   	push   %eax
  80209a:	6a 29                	push   $0x29
  80209c:	e8 6a fa ff ff       	call   801b0b <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	ff 75 10             	pushl  0x10(%ebp)
  8020b0:	ff 75 0c             	pushl  0xc(%ebp)
  8020b3:	ff 75 08             	pushl  0x8(%ebp)
  8020b6:	6a 12                	push   $0x12
  8020b8:	e8 4e fa ff ff       	call   801b0b <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c0:	90                   	nop
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8020c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	52                   	push   %edx
  8020d3:	50                   	push   %eax
  8020d4:	6a 2a                	push   $0x2a
  8020d6:	e8 30 fa ff ff       	call   801b0b <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
	return;
  8020de:	90                   	nop
}
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	50                   	push   %eax
  8020f0:	6a 2b                	push   $0x2b
  8020f2:	e8 14 fa ff ff       	call   801b0b <syscall>
  8020f7:	83 c4 18             	add    $0x18,%esp
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	ff 75 0c             	pushl  0xc(%ebp)
  802108:	ff 75 08             	pushl  0x8(%ebp)
  80210b:	6a 2c                	push   $0x2c
  80210d:	e8 f9 f9 ff ff       	call   801b0b <syscall>
  802112:	83 c4 18             	add    $0x18,%esp
	return;
  802115:	90                   	nop
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	ff 75 0c             	pushl  0xc(%ebp)
  802124:	ff 75 08             	pushl  0x8(%ebp)
  802127:	6a 2d                	push   $0x2d
  802129:	e8 dd f9 ff ff       	call   801b0b <syscall>
  80212e:	83 c4 18             	add    $0x18,%esp
	return;
  802131:	90                   	nop
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	83 e8 04             	sub    $0x4,%eax
  802140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802143:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802146:	8b 00                	mov    (%eax),%eax
  802148:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	83 e8 04             	sub    $0x4,%eax
  802159:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80215c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215f:	8b 00                	mov    (%eax),%eax
  802161:	83 e0 01             	and    $0x1,%eax
  802164:	85 c0                	test   %eax,%eax
  802166:	0f 94 c0             	sete   %al
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802171:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217b:	83 f8 02             	cmp    $0x2,%eax
  80217e:	74 2b                	je     8021ab <alloc_block+0x40>
  802180:	83 f8 02             	cmp    $0x2,%eax
  802183:	7f 07                	jg     80218c <alloc_block+0x21>
  802185:	83 f8 01             	cmp    $0x1,%eax
  802188:	74 0e                	je     802198 <alloc_block+0x2d>
  80218a:	eb 58                	jmp    8021e4 <alloc_block+0x79>
  80218c:	83 f8 03             	cmp    $0x3,%eax
  80218f:	74 2d                	je     8021be <alloc_block+0x53>
  802191:	83 f8 04             	cmp    $0x4,%eax
  802194:	74 3b                	je     8021d1 <alloc_block+0x66>
  802196:	eb 4c                	jmp    8021e4 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802198:	83 ec 0c             	sub    $0xc,%esp
  80219b:	ff 75 08             	pushl  0x8(%ebp)
  80219e:	e8 11 03 00 00       	call   8024b4 <alloc_block_FF>
  8021a3:	83 c4 10             	add    $0x10,%esp
  8021a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021a9:	eb 4a                	jmp    8021f5 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8021ab:	83 ec 0c             	sub    $0xc,%esp
  8021ae:	ff 75 08             	pushl  0x8(%ebp)
  8021b1:	e8 fa 19 00 00       	call   803bb0 <alloc_block_NF>
  8021b6:	83 c4 10             	add    $0x10,%esp
  8021b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021bc:	eb 37                	jmp    8021f5 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8021be:	83 ec 0c             	sub    $0xc,%esp
  8021c1:	ff 75 08             	pushl  0x8(%ebp)
  8021c4:	e8 a7 07 00 00       	call   802970 <alloc_block_BF>
  8021c9:	83 c4 10             	add    $0x10,%esp
  8021cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021cf:	eb 24                	jmp    8021f5 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8021d1:	83 ec 0c             	sub    $0xc,%esp
  8021d4:	ff 75 08             	pushl  0x8(%ebp)
  8021d7:	e8 b7 19 00 00       	call   803b93 <alloc_block_WF>
  8021dc:	83 c4 10             	add    $0x10,%esp
  8021df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021e2:	eb 11                	jmp    8021f5 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8021e4:	83 ec 0c             	sub    $0xc,%esp
  8021e7:	68 b8 46 80 00       	push   $0x8046b8
  8021ec:	e8 5e e6 ff ff       	call   80084f <cprintf>
  8021f1:	83 c4 10             	add    $0x10,%esp
		break;
  8021f4:	90                   	nop
	}
	return va;
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	53                   	push   %ebx
  8021fe:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802201:	83 ec 0c             	sub    $0xc,%esp
  802204:	68 d8 46 80 00       	push   $0x8046d8
  802209:	e8 41 e6 ff ff       	call   80084f <cprintf>
  80220e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802211:	83 ec 0c             	sub    $0xc,%esp
  802214:	68 03 47 80 00       	push   $0x804703
  802219:	e8 31 e6 ff ff       	call   80084f <cprintf>
  80221e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802227:	eb 37                	jmp    802260 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802229:	83 ec 0c             	sub    $0xc,%esp
  80222c:	ff 75 f4             	pushl  -0xc(%ebp)
  80222f:	e8 19 ff ff ff       	call   80214d <is_free_block>
  802234:	83 c4 10             	add    $0x10,%esp
  802237:	0f be d8             	movsbl %al,%ebx
  80223a:	83 ec 0c             	sub    $0xc,%esp
  80223d:	ff 75 f4             	pushl  -0xc(%ebp)
  802240:	e8 ef fe ff ff       	call   802134 <get_block_size>
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	83 ec 04             	sub    $0x4,%esp
  80224b:	53                   	push   %ebx
  80224c:	50                   	push   %eax
  80224d:	68 1b 47 80 00       	push   $0x80471b
  802252:	e8 f8 e5 ff ff       	call   80084f <cprintf>
  802257:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80225a:	8b 45 10             	mov    0x10(%ebp),%eax
  80225d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802264:	74 07                	je     80226d <print_blocks_list+0x73>
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	8b 00                	mov    (%eax),%eax
  80226b:	eb 05                	jmp    802272 <print_blocks_list+0x78>
  80226d:	b8 00 00 00 00       	mov    $0x0,%eax
  802272:	89 45 10             	mov    %eax,0x10(%ebp)
  802275:	8b 45 10             	mov    0x10(%ebp),%eax
  802278:	85 c0                	test   %eax,%eax
  80227a:	75 ad                	jne    802229 <print_blocks_list+0x2f>
  80227c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802280:	75 a7                	jne    802229 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802282:	83 ec 0c             	sub    $0xc,%esp
  802285:	68 d8 46 80 00       	push   $0x8046d8
  80228a:	e8 c0 e5 ff ff       	call   80084f <cprintf>
  80228f:	83 c4 10             	add    $0x10,%esp

}
  802292:	90                   	nop
  802293:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80229e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a1:	83 e0 01             	and    $0x1,%eax
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	74 03                	je     8022ab <initialize_dynamic_allocator+0x13>
  8022a8:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8022ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022af:	0f 84 c7 01 00 00    	je     80247c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8022b5:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8022bc:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8022bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c5:	01 d0                	add    %edx,%eax
  8022c7:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8022cc:	0f 87 ad 01 00 00    	ja     80247f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	0f 89 a5 01 00 00    	jns    802482 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8022dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e3:	01 d0                	add    %edx,%eax
  8022e5:	83 e8 04             	sub    $0x4,%eax
  8022e8:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8022ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8022f4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fc:	e9 87 00 00 00       	jmp    802388 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802301:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802305:	75 14                	jne    80231b <initialize_dynamic_allocator+0x83>
  802307:	83 ec 04             	sub    $0x4,%esp
  80230a:	68 33 47 80 00       	push   $0x804733
  80230f:	6a 79                	push   $0x79
  802311:	68 51 47 80 00       	push   $0x804751
  802316:	e8 77 e2 ff ff       	call   800592 <_panic>
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 00                	mov    (%eax),%eax
  802320:	85 c0                	test   %eax,%eax
  802322:	74 10                	je     802334 <initialize_dynamic_allocator+0x9c>
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	8b 00                	mov    (%eax),%eax
  802329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232c:	8b 52 04             	mov    0x4(%edx),%edx
  80232f:	89 50 04             	mov    %edx,0x4(%eax)
  802332:	eb 0b                	jmp    80233f <initialize_dynamic_allocator+0xa7>
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	8b 40 04             	mov    0x4(%eax),%eax
  80233a:	a3 30 50 80 00       	mov    %eax,0x805030
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	8b 40 04             	mov    0x4(%eax),%eax
  802345:	85 c0                	test   %eax,%eax
  802347:	74 0f                	je     802358 <initialize_dynamic_allocator+0xc0>
  802349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234c:	8b 40 04             	mov    0x4(%eax),%eax
  80234f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802352:	8b 12                	mov    (%edx),%edx
  802354:	89 10                	mov    %edx,(%eax)
  802356:	eb 0a                	jmp    802362 <initialize_dynamic_allocator+0xca>
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 00                	mov    (%eax),%eax
  80235d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802375:	a1 38 50 80 00       	mov    0x805038,%eax
  80237a:	48                   	dec    %eax
  80237b:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802380:	a1 34 50 80 00       	mov    0x805034,%eax
  802385:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238c:	74 07                	je     802395 <initialize_dynamic_allocator+0xfd>
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 00                	mov    (%eax),%eax
  802393:	eb 05                	jmp    80239a <initialize_dynamic_allocator+0x102>
  802395:	b8 00 00 00 00       	mov    $0x0,%eax
  80239a:	a3 34 50 80 00       	mov    %eax,0x805034
  80239f:	a1 34 50 80 00       	mov    0x805034,%eax
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	0f 85 55 ff ff ff    	jne    802301 <initialize_dynamic_allocator+0x69>
  8023ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b0:	0f 85 4b ff ff ff    	jne    802301 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8023bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8023c5:	a1 44 50 80 00       	mov    0x805044,%eax
  8023ca:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8023cf:	a1 40 50 80 00       	mov    0x805040,%eax
  8023d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	83 c0 08             	add    $0x8,%eax
  8023e0:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	83 c0 04             	add    $0x4,%eax
  8023e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ec:	83 ea 08             	sub    $0x8,%edx
  8023ef:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	01 d0                	add    %edx,%eax
  8023f9:	83 e8 08             	sub    $0x8,%eax
  8023fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ff:	83 ea 08             	sub    $0x8,%edx
  802402:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802407:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80240d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802410:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802417:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80241b:	75 17                	jne    802434 <initialize_dynamic_allocator+0x19c>
  80241d:	83 ec 04             	sub    $0x4,%esp
  802420:	68 6c 47 80 00       	push   $0x80476c
  802425:	68 90 00 00 00       	push   $0x90
  80242a:	68 51 47 80 00       	push   $0x804751
  80242f:	e8 5e e1 ff ff       	call   800592 <_panic>
  802434:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80243a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243d:	89 10                	mov    %edx,(%eax)
  80243f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	74 0d                	je     802455 <initialize_dynamic_allocator+0x1bd>
  802448:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80244d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802450:	89 50 04             	mov    %edx,0x4(%eax)
  802453:	eb 08                	jmp    80245d <initialize_dynamic_allocator+0x1c5>
  802455:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802458:	a3 30 50 80 00       	mov    %eax,0x805030
  80245d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802460:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802465:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802468:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246f:	a1 38 50 80 00       	mov    0x805038,%eax
  802474:	40                   	inc    %eax
  802475:	a3 38 50 80 00       	mov    %eax,0x805038
  80247a:	eb 07                	jmp    802483 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80247c:	90                   	nop
  80247d:	eb 04                	jmp    802483 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80247f:	90                   	nop
  802480:	eb 01                	jmp    802483 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802482:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802488:	8b 45 10             	mov    0x10(%ebp),%eax
  80248b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	8d 50 fc             	lea    -0x4(%eax),%edx
  802494:	8b 45 0c             	mov    0xc(%ebp),%eax
  802497:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	83 e8 04             	sub    $0x4,%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	83 e0 fe             	and    $0xfffffffe,%eax
  8024a4:	8d 50 f8             	lea    -0x8(%eax),%edx
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	01 c2                	add    %eax,%edx
  8024ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024af:	89 02                	mov    %eax,(%edx)
}
  8024b1:	90                   	nop
  8024b2:	5d                   	pop    %ebp
  8024b3:	c3                   	ret    

008024b4 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	83 e0 01             	and    $0x1,%eax
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	74 03                	je     8024c7 <alloc_block_FF+0x13>
  8024c4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024c7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024cb:	77 07                	ja     8024d4 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024cd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024d4:	a1 24 50 80 00       	mov    0x805024,%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	75 73                	jne    802550 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e0:	83 c0 10             	add    $0x10,%eax
  8024e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024e6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f3:	01 d0                	add    %edx,%eax
  8024f5:	48                   	dec    %eax
  8024f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802501:	f7 75 ec             	divl   -0x14(%ebp)
  802504:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802507:	29 d0                	sub    %edx,%eax
  802509:	c1 e8 0c             	shr    $0xc,%eax
  80250c:	83 ec 0c             	sub    $0xc,%esp
  80250f:	50                   	push   %eax
  802510:	e8 d4 f0 ff ff       	call   8015e9 <sbrk>
  802515:	83 c4 10             	add    $0x10,%esp
  802518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80251b:	83 ec 0c             	sub    $0xc,%esp
  80251e:	6a 00                	push   $0x0
  802520:	e8 c4 f0 ff ff       	call   8015e9 <sbrk>
  802525:	83 c4 10             	add    $0x10,%esp
  802528:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80252b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80252e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802531:	83 ec 08             	sub    $0x8,%esp
  802534:	50                   	push   %eax
  802535:	ff 75 e4             	pushl  -0x1c(%ebp)
  802538:	e8 5b fd ff ff       	call   802298 <initialize_dynamic_allocator>
  80253d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802540:	83 ec 0c             	sub    $0xc,%esp
  802543:	68 8f 47 80 00       	push   $0x80478f
  802548:	e8 02 e3 ff ff       	call   80084f <cprintf>
  80254d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802550:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802554:	75 0a                	jne    802560 <alloc_block_FF+0xac>
	        return NULL;
  802556:	b8 00 00 00 00       	mov    $0x0,%eax
  80255b:	e9 0e 04 00 00       	jmp    80296e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802560:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802567:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80256c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256f:	e9 f3 02 00 00       	jmp    802867 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80257a:	83 ec 0c             	sub    $0xc,%esp
  80257d:	ff 75 bc             	pushl  -0x44(%ebp)
  802580:	e8 af fb ff ff       	call   802134 <get_block_size>
  802585:	83 c4 10             	add    $0x10,%esp
  802588:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	83 c0 08             	add    $0x8,%eax
  802591:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802594:	0f 87 c5 02 00 00    	ja     80285f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	83 c0 18             	add    $0x18,%eax
  8025a0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8025a3:	0f 87 19 02 00 00    	ja     8027c2 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8025a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8025ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8025af:	83 e8 08             	sub    $0x8,%eax
  8025b2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	8d 50 08             	lea    0x8(%eax),%edx
  8025bb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025be:	01 d0                	add    %edx,%eax
  8025c0:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	83 c0 08             	add    $0x8,%eax
  8025c9:	83 ec 04             	sub    $0x4,%esp
  8025cc:	6a 01                	push   $0x1
  8025ce:	50                   	push   %eax
  8025cf:	ff 75 bc             	pushl  -0x44(%ebp)
  8025d2:	e8 ae fe ff ff       	call   802485 <set_block_data>
  8025d7:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 40 04             	mov    0x4(%eax),%eax
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	75 68                	jne    80264c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025e4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025e8:	75 17                	jne    802601 <alloc_block_FF+0x14d>
  8025ea:	83 ec 04             	sub    $0x4,%esp
  8025ed:	68 6c 47 80 00       	push   $0x80476c
  8025f2:	68 d7 00 00 00       	push   $0xd7
  8025f7:	68 51 47 80 00       	push   $0x804751
  8025fc:	e8 91 df ff ff       	call   800592 <_panic>
  802601:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802607:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260a:	89 10                	mov    %edx,(%eax)
  80260c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260f:	8b 00                	mov    (%eax),%eax
  802611:	85 c0                	test   %eax,%eax
  802613:	74 0d                	je     802622 <alloc_block_FF+0x16e>
  802615:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80261a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80261d:	89 50 04             	mov    %edx,0x4(%eax)
  802620:	eb 08                	jmp    80262a <alloc_block_FF+0x176>
  802622:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802625:	a3 30 50 80 00       	mov    %eax,0x805030
  80262a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80262d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802632:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802635:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263c:	a1 38 50 80 00       	mov    0x805038,%eax
  802641:	40                   	inc    %eax
  802642:	a3 38 50 80 00       	mov    %eax,0x805038
  802647:	e9 dc 00 00 00       	jmp    802728 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	85 c0                	test   %eax,%eax
  802653:	75 65                	jne    8026ba <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802655:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802659:	75 17                	jne    802672 <alloc_block_FF+0x1be>
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	68 a0 47 80 00       	push   $0x8047a0
  802663:	68 db 00 00 00       	push   $0xdb
  802668:	68 51 47 80 00       	push   $0x804751
  80266d:	e8 20 df ff ff       	call   800592 <_panic>
  802672:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802678:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80267b:	89 50 04             	mov    %edx,0x4(%eax)
  80267e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802681:	8b 40 04             	mov    0x4(%eax),%eax
  802684:	85 c0                	test   %eax,%eax
  802686:	74 0c                	je     802694 <alloc_block_FF+0x1e0>
  802688:	a1 30 50 80 00       	mov    0x805030,%eax
  80268d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802690:	89 10                	mov    %edx,(%eax)
  802692:	eb 08                	jmp    80269c <alloc_block_FF+0x1e8>
  802694:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802697:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80269c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80269f:	a3 30 50 80 00       	mov    %eax,0x805030
  8026a4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8026b2:	40                   	inc    %eax
  8026b3:	a3 38 50 80 00       	mov    %eax,0x805038
  8026b8:	eb 6e                	jmp    802728 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8026ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026be:	74 06                	je     8026c6 <alloc_block_FF+0x212>
  8026c0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026c4:	75 17                	jne    8026dd <alloc_block_FF+0x229>
  8026c6:	83 ec 04             	sub    $0x4,%esp
  8026c9:	68 c4 47 80 00       	push   $0x8047c4
  8026ce:	68 df 00 00 00       	push   $0xdf
  8026d3:	68 51 47 80 00       	push   $0x804751
  8026d8:	e8 b5 de ff ff       	call   800592 <_panic>
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 10                	mov    (%eax),%edx
  8026e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e5:	89 10                	mov    %edx,(%eax)
  8026e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	74 0b                	je     8026fb <alloc_block_FF+0x247>
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	8b 00                	mov    (%eax),%eax
  8026f5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026f8:	89 50 04             	mov    %edx,0x4(%eax)
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802701:	89 10                	mov    %edx,(%eax)
  802703:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802709:	89 50 04             	mov    %edx,0x4(%eax)
  80270c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	85 c0                	test   %eax,%eax
  802713:	75 08                	jne    80271d <alloc_block_FF+0x269>
  802715:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802718:	a3 30 50 80 00       	mov    %eax,0x805030
  80271d:	a1 38 50 80 00       	mov    0x805038,%eax
  802722:	40                   	inc    %eax
  802723:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802728:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272c:	75 17                	jne    802745 <alloc_block_FF+0x291>
  80272e:	83 ec 04             	sub    $0x4,%esp
  802731:	68 33 47 80 00       	push   $0x804733
  802736:	68 e1 00 00 00       	push   $0xe1
  80273b:	68 51 47 80 00       	push   $0x804751
  802740:	e8 4d de ff ff       	call   800592 <_panic>
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 00                	mov    (%eax),%eax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	74 10                	je     80275e <alloc_block_FF+0x2aa>
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802756:	8b 52 04             	mov    0x4(%edx),%edx
  802759:	89 50 04             	mov    %edx,0x4(%eax)
  80275c:	eb 0b                	jmp    802769 <alloc_block_FF+0x2b5>
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 40 04             	mov    0x4(%eax),%eax
  802764:	a3 30 50 80 00       	mov    %eax,0x805030
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 40 04             	mov    0x4(%eax),%eax
  80276f:	85 c0                	test   %eax,%eax
  802771:	74 0f                	je     802782 <alloc_block_FF+0x2ce>
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 40 04             	mov    0x4(%eax),%eax
  802779:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277c:	8b 12                	mov    (%edx),%edx
  80277e:	89 10                	mov    %edx,(%eax)
  802780:	eb 0a                	jmp    80278c <alloc_block_FF+0x2d8>
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279f:	a1 38 50 80 00       	mov    0x805038,%eax
  8027a4:	48                   	dec    %eax
  8027a5:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8027aa:	83 ec 04             	sub    $0x4,%esp
  8027ad:	6a 00                	push   $0x0
  8027af:	ff 75 b4             	pushl  -0x4c(%ebp)
  8027b2:	ff 75 b0             	pushl  -0x50(%ebp)
  8027b5:	e8 cb fc ff ff       	call   802485 <set_block_data>
  8027ba:	83 c4 10             	add    $0x10,%esp
  8027bd:	e9 95 00 00 00       	jmp    802857 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8027c2:	83 ec 04             	sub    $0x4,%esp
  8027c5:	6a 01                	push   $0x1
  8027c7:	ff 75 b8             	pushl  -0x48(%ebp)
  8027ca:	ff 75 bc             	pushl  -0x44(%ebp)
  8027cd:	e8 b3 fc ff ff       	call   802485 <set_block_data>
  8027d2:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8027d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d9:	75 17                	jne    8027f2 <alloc_block_FF+0x33e>
  8027db:	83 ec 04             	sub    $0x4,%esp
  8027de:	68 33 47 80 00       	push   $0x804733
  8027e3:	68 e8 00 00 00       	push   $0xe8
  8027e8:	68 51 47 80 00       	push   $0x804751
  8027ed:	e8 a0 dd ff ff       	call   800592 <_panic>
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	74 10                	je     80280b <alloc_block_FF+0x357>
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 00                	mov    (%eax),%eax
  802800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802803:	8b 52 04             	mov    0x4(%edx),%edx
  802806:	89 50 04             	mov    %edx,0x4(%eax)
  802809:	eb 0b                	jmp    802816 <alloc_block_FF+0x362>
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 40 04             	mov    0x4(%eax),%eax
  802811:	a3 30 50 80 00       	mov    %eax,0x805030
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 40 04             	mov    0x4(%eax),%eax
  80281c:	85 c0                	test   %eax,%eax
  80281e:	74 0f                	je     80282f <alloc_block_FF+0x37b>
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 40 04             	mov    0x4(%eax),%eax
  802826:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802829:	8b 12                	mov    (%edx),%edx
  80282b:	89 10                	mov    %edx,(%eax)
  80282d:	eb 0a                	jmp    802839 <alloc_block_FF+0x385>
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 00                	mov    (%eax),%eax
  802834:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80284c:	a1 38 50 80 00       	mov    0x805038,%eax
  802851:	48                   	dec    %eax
  802852:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802857:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80285a:	e9 0f 01 00 00       	jmp    80296e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80285f:	a1 34 50 80 00       	mov    0x805034,%eax
  802864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286b:	74 07                	je     802874 <alloc_block_FF+0x3c0>
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	eb 05                	jmp    802879 <alloc_block_FF+0x3c5>
  802874:	b8 00 00 00 00       	mov    $0x0,%eax
  802879:	a3 34 50 80 00       	mov    %eax,0x805034
  80287e:	a1 34 50 80 00       	mov    0x805034,%eax
  802883:	85 c0                	test   %eax,%eax
  802885:	0f 85 e9 fc ff ff    	jne    802574 <alloc_block_FF+0xc0>
  80288b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288f:	0f 85 df fc ff ff    	jne    802574 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	83 c0 08             	add    $0x8,%eax
  80289b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80289e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8028a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028ab:	01 d0                	add    %edx,%eax
  8028ad:	48                   	dec    %eax
  8028ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b9:	f7 75 d8             	divl   -0x28(%ebp)
  8028bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028bf:	29 d0                	sub    %edx,%eax
  8028c1:	c1 e8 0c             	shr    $0xc,%eax
  8028c4:	83 ec 0c             	sub    $0xc,%esp
  8028c7:	50                   	push   %eax
  8028c8:	e8 1c ed ff ff       	call   8015e9 <sbrk>
  8028cd:	83 c4 10             	add    $0x10,%esp
  8028d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8028d3:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8028d7:	75 0a                	jne    8028e3 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8028d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028de:	e9 8b 00 00 00       	jmp    80296e <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8028e3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f0:	01 d0                	add    %edx,%eax
  8028f2:	48                   	dec    %eax
  8028f3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8028fe:	f7 75 cc             	divl   -0x34(%ebp)
  802901:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802904:	29 d0                	sub    %edx,%eax
  802906:	8d 50 fc             	lea    -0x4(%eax),%edx
  802909:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80290c:	01 d0                	add    %edx,%eax
  80290e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802913:	a1 40 50 80 00       	mov    0x805040,%eax
  802918:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80291e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802925:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802928:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80292b:	01 d0                	add    %edx,%eax
  80292d:	48                   	dec    %eax
  80292e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802931:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802934:	ba 00 00 00 00       	mov    $0x0,%edx
  802939:	f7 75 c4             	divl   -0x3c(%ebp)
  80293c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80293f:	29 d0                	sub    %edx,%eax
  802941:	83 ec 04             	sub    $0x4,%esp
  802944:	6a 01                	push   $0x1
  802946:	50                   	push   %eax
  802947:	ff 75 d0             	pushl  -0x30(%ebp)
  80294a:	e8 36 fb ff ff       	call   802485 <set_block_data>
  80294f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802952:	83 ec 0c             	sub    $0xc,%esp
  802955:	ff 75 d0             	pushl  -0x30(%ebp)
  802958:	e8 1b 0a 00 00       	call   803378 <free_block>
  80295d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802960:	83 ec 0c             	sub    $0xc,%esp
  802963:	ff 75 08             	pushl  0x8(%ebp)
  802966:	e8 49 fb ff ff       	call   8024b4 <alloc_block_FF>
  80296b:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80296e:	c9                   	leave  
  80296f:	c3                   	ret    

00802970 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
  802973:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	83 e0 01             	and    $0x1,%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	74 03                	je     802983 <alloc_block_BF+0x13>
  802980:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802983:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802987:	77 07                	ja     802990 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802989:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802990:	a1 24 50 80 00       	mov    0x805024,%eax
  802995:	85 c0                	test   %eax,%eax
  802997:	75 73                	jne    802a0c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	83 c0 10             	add    $0x10,%eax
  80299f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8029a2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8029a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029af:	01 d0                	add    %edx,%eax
  8029b1:	48                   	dec    %eax
  8029b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8029b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8029bd:	f7 75 e0             	divl   -0x20(%ebp)
  8029c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029c3:	29 d0                	sub    %edx,%eax
  8029c5:	c1 e8 0c             	shr    $0xc,%eax
  8029c8:	83 ec 0c             	sub    $0xc,%esp
  8029cb:	50                   	push   %eax
  8029cc:	e8 18 ec ff ff       	call   8015e9 <sbrk>
  8029d1:	83 c4 10             	add    $0x10,%esp
  8029d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029d7:	83 ec 0c             	sub    $0xc,%esp
  8029da:	6a 00                	push   $0x0
  8029dc:	e8 08 ec ff ff       	call   8015e9 <sbrk>
  8029e1:	83 c4 10             	add    $0x10,%esp
  8029e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029ea:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029ed:	83 ec 08             	sub    $0x8,%esp
  8029f0:	50                   	push   %eax
  8029f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8029f4:	e8 9f f8 ff ff       	call   802298 <initialize_dynamic_allocator>
  8029f9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029fc:	83 ec 0c             	sub    $0xc,%esp
  8029ff:	68 8f 47 80 00       	push   $0x80478f
  802a04:	e8 46 de ff ff       	call   80084f <cprintf>
  802a09:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802a0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802a13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802a1a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802a21:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802a28:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a30:	e9 1d 01 00 00       	jmp    802b52 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802a3b:	83 ec 0c             	sub    $0xc,%esp
  802a3e:	ff 75 a8             	pushl  -0x58(%ebp)
  802a41:	e8 ee f6 ff ff       	call   802134 <get_block_size>
  802a46:	83 c4 10             	add    $0x10,%esp
  802a49:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	83 c0 08             	add    $0x8,%eax
  802a52:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a55:	0f 87 ef 00 00 00    	ja     802b4a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	83 c0 18             	add    $0x18,%eax
  802a61:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a64:	77 1d                	ja     802a83 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a69:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a6c:	0f 86 d8 00 00 00    	jbe    802b4a <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a72:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a78:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a7e:	e9 c7 00 00 00       	jmp    802b4a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	83 c0 08             	add    $0x8,%eax
  802a89:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a8c:	0f 85 9d 00 00 00    	jne    802b2f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a92:	83 ec 04             	sub    $0x4,%esp
  802a95:	6a 01                	push   $0x1
  802a97:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a9a:	ff 75 a8             	pushl  -0x58(%ebp)
  802a9d:	e8 e3 f9 ff ff       	call   802485 <set_block_data>
  802aa2:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802aa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa9:	75 17                	jne    802ac2 <alloc_block_BF+0x152>
  802aab:	83 ec 04             	sub    $0x4,%esp
  802aae:	68 33 47 80 00       	push   $0x804733
  802ab3:	68 2c 01 00 00       	push   $0x12c
  802ab8:	68 51 47 80 00       	push   $0x804751
  802abd:	e8 d0 da ff ff       	call   800592 <_panic>
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	74 10                	je     802adb <alloc_block_BF+0x16b>
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad3:	8b 52 04             	mov    0x4(%edx),%edx
  802ad6:	89 50 04             	mov    %edx,0x4(%eax)
  802ad9:	eb 0b                	jmp    802ae6 <alloc_block_BF+0x176>
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 04             	mov    0x4(%eax),%eax
  802ae1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 40 04             	mov    0x4(%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	74 0f                	je     802aff <alloc_block_BF+0x18f>
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 40 04             	mov    0x4(%eax),%eax
  802af6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af9:	8b 12                	mov    (%edx),%edx
  802afb:	89 10                	mov    %edx,(%eax)
  802afd:	eb 0a                	jmp    802b09 <alloc_block_BF+0x199>
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1c:	a1 38 50 80 00       	mov    0x805038,%eax
  802b21:	48                   	dec    %eax
  802b22:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802b27:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b2a:	e9 24 04 00 00       	jmp    802f53 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802b2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b32:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b35:	76 13                	jbe    802b4a <alloc_block_BF+0x1da>
					{
						internal = 1;
  802b37:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802b3e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802b44:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b47:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b4a:	a1 34 50 80 00       	mov    0x805034,%eax
  802b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b56:	74 07                	je     802b5f <alloc_block_BF+0x1ef>
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	eb 05                	jmp    802b64 <alloc_block_BF+0x1f4>
  802b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b64:	a3 34 50 80 00       	mov    %eax,0x805034
  802b69:	a1 34 50 80 00       	mov    0x805034,%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	0f 85 bf fe ff ff    	jne    802a35 <alloc_block_BF+0xc5>
  802b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7a:	0f 85 b5 fe ff ff    	jne    802a35 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b84:	0f 84 26 02 00 00    	je     802db0 <alloc_block_BF+0x440>
  802b8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b8e:	0f 85 1c 02 00 00    	jne    802db0 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b97:	2b 45 08             	sub    0x8(%ebp),%eax
  802b9a:	83 e8 08             	sub    $0x8,%eax
  802b9d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	8d 50 08             	lea    0x8(%eax),%edx
  802ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba9:	01 d0                	add    %edx,%eax
  802bab:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	83 c0 08             	add    $0x8,%eax
  802bb4:	83 ec 04             	sub    $0x4,%esp
  802bb7:	6a 01                	push   $0x1
  802bb9:	50                   	push   %eax
  802bba:	ff 75 f0             	pushl  -0x10(%ebp)
  802bbd:	e8 c3 f8 ff ff       	call   802485 <set_block_data>
  802bc2:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc8:	8b 40 04             	mov    0x4(%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	75 68                	jne    802c37 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bcf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bd3:	75 17                	jne    802bec <alloc_block_BF+0x27c>
  802bd5:	83 ec 04             	sub    $0x4,%esp
  802bd8:	68 6c 47 80 00       	push   $0x80476c
  802bdd:	68 45 01 00 00       	push   $0x145
  802be2:	68 51 47 80 00       	push   $0x804751
  802be7:	e8 a6 d9 ff ff       	call   800592 <_panic>
  802bec:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802bf2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf5:	89 10                	mov    %edx,(%eax)
  802bf7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 0d                	je     802c0d <alloc_block_BF+0x29d>
  802c00:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c05:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c08:	89 50 04             	mov    %edx,0x4(%eax)
  802c0b:	eb 08                	jmp    802c15 <alloc_block_BF+0x2a5>
  802c0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c10:	a3 30 50 80 00       	mov    %eax,0x805030
  802c15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c18:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c27:	a1 38 50 80 00       	mov    0x805038,%eax
  802c2c:	40                   	inc    %eax
  802c2d:	a3 38 50 80 00       	mov    %eax,0x805038
  802c32:	e9 dc 00 00 00       	jmp    802d13 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	85 c0                	test   %eax,%eax
  802c3e:	75 65                	jne    802ca5 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c40:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c44:	75 17                	jne    802c5d <alloc_block_BF+0x2ed>
  802c46:	83 ec 04             	sub    $0x4,%esp
  802c49:	68 a0 47 80 00       	push   $0x8047a0
  802c4e:	68 4a 01 00 00       	push   $0x14a
  802c53:	68 51 47 80 00       	push   $0x804751
  802c58:	e8 35 d9 ff ff       	call   800592 <_panic>
  802c5d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c63:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c66:	89 50 04             	mov    %edx,0x4(%eax)
  802c69:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c6c:	8b 40 04             	mov    0x4(%eax),%eax
  802c6f:	85 c0                	test   %eax,%eax
  802c71:	74 0c                	je     802c7f <alloc_block_BF+0x30f>
  802c73:	a1 30 50 80 00       	mov    0x805030,%eax
  802c78:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c7b:	89 10                	mov    %edx,(%eax)
  802c7d:	eb 08                	jmp    802c87 <alloc_block_BF+0x317>
  802c7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c82:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c8a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c98:	a1 38 50 80 00       	mov    0x805038,%eax
  802c9d:	40                   	inc    %eax
  802c9e:	a3 38 50 80 00       	mov    %eax,0x805038
  802ca3:	eb 6e                	jmp    802d13 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ca5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca9:	74 06                	je     802cb1 <alloc_block_BF+0x341>
  802cab:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802caf:	75 17                	jne    802cc8 <alloc_block_BF+0x358>
  802cb1:	83 ec 04             	sub    $0x4,%esp
  802cb4:	68 c4 47 80 00       	push   $0x8047c4
  802cb9:	68 4f 01 00 00       	push   $0x14f
  802cbe:	68 51 47 80 00       	push   $0x804751
  802cc3:	e8 ca d8 ff ff       	call   800592 <_panic>
  802cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccb:	8b 10                	mov    (%eax),%edx
  802ccd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd0:	89 10                	mov    %edx,(%eax)
  802cd2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	74 0b                	je     802ce6 <alloc_block_BF+0x376>
  802cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ce3:	89 50 04             	mov    %edx,0x4(%eax)
  802ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cec:	89 10                	mov    %edx,(%eax)
  802cee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf4:	89 50 04             	mov    %edx,0x4(%eax)
  802cf7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	75 08                	jne    802d08 <alloc_block_BF+0x398>
  802d00:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d03:	a3 30 50 80 00       	mov    %eax,0x805030
  802d08:	a1 38 50 80 00       	mov    0x805038,%eax
  802d0d:	40                   	inc    %eax
  802d0e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802d13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d17:	75 17                	jne    802d30 <alloc_block_BF+0x3c0>
  802d19:	83 ec 04             	sub    $0x4,%esp
  802d1c:	68 33 47 80 00       	push   $0x804733
  802d21:	68 51 01 00 00       	push   $0x151
  802d26:	68 51 47 80 00       	push   $0x804751
  802d2b:	e8 62 d8 ff ff       	call   800592 <_panic>
  802d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	74 10                	je     802d49 <alloc_block_BF+0x3d9>
  802d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d41:	8b 52 04             	mov    0x4(%edx),%edx
  802d44:	89 50 04             	mov    %edx,0x4(%eax)
  802d47:	eb 0b                	jmp    802d54 <alloc_block_BF+0x3e4>
  802d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4c:	8b 40 04             	mov    0x4(%eax),%eax
  802d4f:	a3 30 50 80 00       	mov    %eax,0x805030
  802d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d57:	8b 40 04             	mov    0x4(%eax),%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	74 0f                	je     802d6d <alloc_block_BF+0x3fd>
  802d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d67:	8b 12                	mov    (%edx),%edx
  802d69:	89 10                	mov    %edx,(%eax)
  802d6b:	eb 0a                	jmp    802d77 <alloc_block_BF+0x407>
  802d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8a:	a1 38 50 80 00       	mov    0x805038,%eax
  802d8f:	48                   	dec    %eax
  802d90:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d95:	83 ec 04             	sub    $0x4,%esp
  802d98:	6a 00                	push   $0x0
  802d9a:	ff 75 d0             	pushl  -0x30(%ebp)
  802d9d:	ff 75 cc             	pushl  -0x34(%ebp)
  802da0:	e8 e0 f6 ff ff       	call   802485 <set_block_data>
  802da5:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dab:	e9 a3 01 00 00       	jmp    802f53 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802db0:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802db4:	0f 85 9d 00 00 00    	jne    802e57 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802dba:	83 ec 04             	sub    $0x4,%esp
  802dbd:	6a 01                	push   $0x1
  802dbf:	ff 75 ec             	pushl  -0x14(%ebp)
  802dc2:	ff 75 f0             	pushl  -0x10(%ebp)
  802dc5:	e8 bb f6 ff ff       	call   802485 <set_block_data>
  802dca:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802dcd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd1:	75 17                	jne    802dea <alloc_block_BF+0x47a>
  802dd3:	83 ec 04             	sub    $0x4,%esp
  802dd6:	68 33 47 80 00       	push   $0x804733
  802ddb:	68 58 01 00 00       	push   $0x158
  802de0:	68 51 47 80 00       	push   $0x804751
  802de5:	e8 a8 d7 ff ff       	call   800592 <_panic>
  802dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	85 c0                	test   %eax,%eax
  802df1:	74 10                	je     802e03 <alloc_block_BF+0x493>
  802df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dfb:	8b 52 04             	mov    0x4(%edx),%edx
  802dfe:	89 50 04             	mov    %edx,0x4(%eax)
  802e01:	eb 0b                	jmp    802e0e <alloc_block_BF+0x49e>
  802e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e06:	8b 40 04             	mov    0x4(%eax),%eax
  802e09:	a3 30 50 80 00       	mov    %eax,0x805030
  802e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 0f                	je     802e27 <alloc_block_BF+0x4b7>
  802e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1b:	8b 40 04             	mov    0x4(%eax),%eax
  802e1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e21:	8b 12                	mov    (%edx),%edx
  802e23:	89 10                	mov    %edx,(%eax)
  802e25:	eb 0a                	jmp    802e31 <alloc_block_BF+0x4c1>
  802e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2a:	8b 00                	mov    (%eax),%eax
  802e2c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e44:	a1 38 50 80 00       	mov    0x805038,%eax
  802e49:	48                   	dec    %eax
  802e4a:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e52:	e9 fc 00 00 00       	jmp    802f53 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	83 c0 08             	add    $0x8,%eax
  802e5d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e60:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e67:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e6a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e6d:	01 d0                	add    %edx,%eax
  802e6f:	48                   	dec    %eax
  802e70:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e73:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e76:	ba 00 00 00 00       	mov    $0x0,%edx
  802e7b:	f7 75 c4             	divl   -0x3c(%ebp)
  802e7e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e81:	29 d0                	sub    %edx,%eax
  802e83:	c1 e8 0c             	shr    $0xc,%eax
  802e86:	83 ec 0c             	sub    $0xc,%esp
  802e89:	50                   	push   %eax
  802e8a:	e8 5a e7 ff ff       	call   8015e9 <sbrk>
  802e8f:	83 c4 10             	add    $0x10,%esp
  802e92:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e95:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e99:	75 0a                	jne    802ea5 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea0:	e9 ae 00 00 00       	jmp    802f53 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ea5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802eac:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802eaf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802eb2:	01 d0                	add    %edx,%eax
  802eb4:	48                   	dec    %eax
  802eb5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802eb8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ebb:	ba 00 00 00 00       	mov    $0x0,%edx
  802ec0:	f7 75 b8             	divl   -0x48(%ebp)
  802ec3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ec6:	29 d0                	sub    %edx,%eax
  802ec8:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ecb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ece:	01 d0                	add    %edx,%eax
  802ed0:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ed5:	a1 40 50 80 00       	mov    0x805040,%eax
  802eda:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ee0:	83 ec 0c             	sub    $0xc,%esp
  802ee3:	68 f8 47 80 00       	push   $0x8047f8
  802ee8:	e8 62 d9 ff ff       	call   80084f <cprintf>
  802eed:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802ef0:	83 ec 08             	sub    $0x8,%esp
  802ef3:	ff 75 bc             	pushl  -0x44(%ebp)
  802ef6:	68 fd 47 80 00       	push   $0x8047fd
  802efb:	e8 4f d9 ff ff       	call   80084f <cprintf>
  802f00:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802f03:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802f0a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f0d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f10:	01 d0                	add    %edx,%eax
  802f12:	48                   	dec    %eax
  802f13:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802f16:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f19:	ba 00 00 00 00       	mov    $0x0,%edx
  802f1e:	f7 75 b0             	divl   -0x50(%ebp)
  802f21:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f24:	29 d0                	sub    %edx,%eax
  802f26:	83 ec 04             	sub    $0x4,%esp
  802f29:	6a 01                	push   $0x1
  802f2b:	50                   	push   %eax
  802f2c:	ff 75 bc             	pushl  -0x44(%ebp)
  802f2f:	e8 51 f5 ff ff       	call   802485 <set_block_data>
  802f34:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802f37:	83 ec 0c             	sub    $0xc,%esp
  802f3a:	ff 75 bc             	pushl  -0x44(%ebp)
  802f3d:	e8 36 04 00 00       	call   803378 <free_block>
  802f42:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802f45:	83 ec 0c             	sub    $0xc,%esp
  802f48:	ff 75 08             	pushl  0x8(%ebp)
  802f4b:	e8 20 fa ff ff       	call   802970 <alloc_block_BF>
  802f50:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f53:	c9                   	leave  
  802f54:	c3                   	ret    

00802f55 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f55:	55                   	push   %ebp
  802f56:	89 e5                	mov    %esp,%ebp
  802f58:	53                   	push   %ebx
  802f59:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6e:	74 1e                	je     802f8e <merging+0x39>
  802f70:	ff 75 08             	pushl  0x8(%ebp)
  802f73:	e8 bc f1 ff ff       	call   802134 <get_block_size>
  802f78:	83 c4 04             	add    $0x4,%esp
  802f7b:	89 c2                	mov    %eax,%edx
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	01 d0                	add    %edx,%eax
  802f82:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f85:	75 07                	jne    802f8e <merging+0x39>
		prev_is_free = 1;
  802f87:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f92:	74 1e                	je     802fb2 <merging+0x5d>
  802f94:	ff 75 10             	pushl  0x10(%ebp)
  802f97:	e8 98 f1 ff ff       	call   802134 <get_block_size>
  802f9c:	83 c4 04             	add    $0x4,%esp
  802f9f:	89 c2                	mov    %eax,%edx
  802fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  802fa4:	01 d0                	add    %edx,%eax
  802fa6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fa9:	75 07                	jne    802fb2 <merging+0x5d>
		next_is_free = 1;
  802fab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802fb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb6:	0f 84 cc 00 00 00    	je     803088 <merging+0x133>
  802fbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fc0:	0f 84 c2 00 00 00    	je     803088 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802fc6:	ff 75 08             	pushl  0x8(%ebp)
  802fc9:	e8 66 f1 ff ff       	call   802134 <get_block_size>
  802fce:	83 c4 04             	add    $0x4,%esp
  802fd1:	89 c3                	mov    %eax,%ebx
  802fd3:	ff 75 10             	pushl  0x10(%ebp)
  802fd6:	e8 59 f1 ff ff       	call   802134 <get_block_size>
  802fdb:	83 c4 04             	add    $0x4,%esp
  802fde:	01 c3                	add    %eax,%ebx
  802fe0:	ff 75 0c             	pushl  0xc(%ebp)
  802fe3:	e8 4c f1 ff ff       	call   802134 <get_block_size>
  802fe8:	83 c4 04             	add    $0x4,%esp
  802feb:	01 d8                	add    %ebx,%eax
  802fed:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ff0:	6a 00                	push   $0x0
  802ff2:	ff 75 ec             	pushl  -0x14(%ebp)
  802ff5:	ff 75 08             	pushl  0x8(%ebp)
  802ff8:	e8 88 f4 ff ff       	call   802485 <set_block_data>
  802ffd:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803000:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803004:	75 17                	jne    80301d <merging+0xc8>
  803006:	83 ec 04             	sub    $0x4,%esp
  803009:	68 33 47 80 00       	push   $0x804733
  80300e:	68 7d 01 00 00       	push   $0x17d
  803013:	68 51 47 80 00       	push   $0x804751
  803018:	e8 75 d5 ff ff       	call   800592 <_panic>
  80301d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	74 10                	je     803036 <merging+0xe1>
  803026:	8b 45 0c             	mov    0xc(%ebp),%eax
  803029:	8b 00                	mov    (%eax),%eax
  80302b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302e:	8b 52 04             	mov    0x4(%edx),%edx
  803031:	89 50 04             	mov    %edx,0x4(%eax)
  803034:	eb 0b                	jmp    803041 <merging+0xec>
  803036:	8b 45 0c             	mov    0xc(%ebp),%eax
  803039:	8b 40 04             	mov    0x4(%eax),%eax
  80303c:	a3 30 50 80 00       	mov    %eax,0x805030
  803041:	8b 45 0c             	mov    0xc(%ebp),%eax
  803044:	8b 40 04             	mov    0x4(%eax),%eax
  803047:	85 c0                	test   %eax,%eax
  803049:	74 0f                	je     80305a <merging+0x105>
  80304b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304e:	8b 40 04             	mov    0x4(%eax),%eax
  803051:	8b 55 0c             	mov    0xc(%ebp),%edx
  803054:	8b 12                	mov    (%edx),%edx
  803056:	89 10                	mov    %edx,(%eax)
  803058:	eb 0a                	jmp    803064 <merging+0x10f>
  80305a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305d:	8b 00                	mov    (%eax),%eax
  80305f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803064:	8b 45 0c             	mov    0xc(%ebp),%eax
  803067:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803070:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803077:	a1 38 50 80 00       	mov    0x805038,%eax
  80307c:	48                   	dec    %eax
  80307d:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803082:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803083:	e9 ea 02 00 00       	jmp    803372 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803088:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308c:	74 3b                	je     8030c9 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80308e:	83 ec 0c             	sub    $0xc,%esp
  803091:	ff 75 08             	pushl  0x8(%ebp)
  803094:	e8 9b f0 ff ff       	call   802134 <get_block_size>
  803099:	83 c4 10             	add    $0x10,%esp
  80309c:	89 c3                	mov    %eax,%ebx
  80309e:	83 ec 0c             	sub    $0xc,%esp
  8030a1:	ff 75 10             	pushl  0x10(%ebp)
  8030a4:	e8 8b f0 ff ff       	call   802134 <get_block_size>
  8030a9:	83 c4 10             	add    $0x10,%esp
  8030ac:	01 d8                	add    %ebx,%eax
  8030ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8030b1:	83 ec 04             	sub    $0x4,%esp
  8030b4:	6a 00                	push   $0x0
  8030b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8030b9:	ff 75 08             	pushl  0x8(%ebp)
  8030bc:	e8 c4 f3 ff ff       	call   802485 <set_block_data>
  8030c1:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030c4:	e9 a9 02 00 00       	jmp    803372 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8030c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030cd:	0f 84 2d 01 00 00    	je     803200 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8030d3:	83 ec 0c             	sub    $0xc,%esp
  8030d6:	ff 75 10             	pushl  0x10(%ebp)
  8030d9:	e8 56 f0 ff ff       	call   802134 <get_block_size>
  8030de:	83 c4 10             	add    $0x10,%esp
  8030e1:	89 c3                	mov    %eax,%ebx
  8030e3:	83 ec 0c             	sub    $0xc,%esp
  8030e6:	ff 75 0c             	pushl  0xc(%ebp)
  8030e9:	e8 46 f0 ff ff       	call   802134 <get_block_size>
  8030ee:	83 c4 10             	add    $0x10,%esp
  8030f1:	01 d8                	add    %ebx,%eax
  8030f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8030f6:	83 ec 04             	sub    $0x4,%esp
  8030f9:	6a 00                	push   $0x0
  8030fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030fe:	ff 75 10             	pushl  0x10(%ebp)
  803101:	e8 7f f3 ff ff       	call   802485 <set_block_data>
  803106:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803109:	8b 45 10             	mov    0x10(%ebp),%eax
  80310c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80310f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803113:	74 06                	je     80311b <merging+0x1c6>
  803115:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803119:	75 17                	jne    803132 <merging+0x1dd>
  80311b:	83 ec 04             	sub    $0x4,%esp
  80311e:	68 0c 48 80 00       	push   $0x80480c
  803123:	68 8d 01 00 00       	push   $0x18d
  803128:	68 51 47 80 00       	push   $0x804751
  80312d:	e8 60 d4 ff ff       	call   800592 <_panic>
  803132:	8b 45 0c             	mov    0xc(%ebp),%eax
  803135:	8b 50 04             	mov    0x4(%eax),%edx
  803138:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80313b:	89 50 04             	mov    %edx,0x4(%eax)
  80313e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803141:	8b 55 0c             	mov    0xc(%ebp),%edx
  803144:	89 10                	mov    %edx,(%eax)
  803146:	8b 45 0c             	mov    0xc(%ebp),%eax
  803149:	8b 40 04             	mov    0x4(%eax),%eax
  80314c:	85 c0                	test   %eax,%eax
  80314e:	74 0d                	je     80315d <merging+0x208>
  803150:	8b 45 0c             	mov    0xc(%ebp),%eax
  803153:	8b 40 04             	mov    0x4(%eax),%eax
  803156:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803159:	89 10                	mov    %edx,(%eax)
  80315b:	eb 08                	jmp    803165 <merging+0x210>
  80315d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803160:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803165:	8b 45 0c             	mov    0xc(%ebp),%eax
  803168:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80316b:	89 50 04             	mov    %edx,0x4(%eax)
  80316e:	a1 38 50 80 00       	mov    0x805038,%eax
  803173:	40                   	inc    %eax
  803174:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803179:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80317d:	75 17                	jne    803196 <merging+0x241>
  80317f:	83 ec 04             	sub    $0x4,%esp
  803182:	68 33 47 80 00       	push   $0x804733
  803187:	68 8e 01 00 00       	push   $0x18e
  80318c:	68 51 47 80 00       	push   $0x804751
  803191:	e8 fc d3 ff ff       	call   800592 <_panic>
  803196:	8b 45 0c             	mov    0xc(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	74 10                	je     8031af <merging+0x25a>
  80319f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a2:	8b 00                	mov    (%eax),%eax
  8031a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a7:	8b 52 04             	mov    0x4(%edx),%edx
  8031aa:	89 50 04             	mov    %edx,0x4(%eax)
  8031ad:	eb 0b                	jmp    8031ba <merging+0x265>
  8031af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b2:	8b 40 04             	mov    0x4(%eax),%eax
  8031b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8031ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031bd:	8b 40 04             	mov    0x4(%eax),%eax
  8031c0:	85 c0                	test   %eax,%eax
  8031c2:	74 0f                	je     8031d3 <merging+0x27e>
  8031c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031cd:	8b 12                	mov    (%edx),%edx
  8031cf:	89 10                	mov    %edx,(%eax)
  8031d1:	eb 0a                	jmp    8031dd <merging+0x288>
  8031d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d6:	8b 00                	mov    (%eax),%eax
  8031d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f0:	a1 38 50 80 00       	mov    0x805038,%eax
  8031f5:	48                   	dec    %eax
  8031f6:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031fb:	e9 72 01 00 00       	jmp    803372 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803200:	8b 45 10             	mov    0x10(%ebp),%eax
  803203:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803206:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320a:	74 79                	je     803285 <merging+0x330>
  80320c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803210:	74 73                	je     803285 <merging+0x330>
  803212:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803216:	74 06                	je     80321e <merging+0x2c9>
  803218:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80321c:	75 17                	jne    803235 <merging+0x2e0>
  80321e:	83 ec 04             	sub    $0x4,%esp
  803221:	68 c4 47 80 00       	push   $0x8047c4
  803226:	68 94 01 00 00       	push   $0x194
  80322b:	68 51 47 80 00       	push   $0x804751
  803230:	e8 5d d3 ff ff       	call   800592 <_panic>
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	8b 10                	mov    (%eax),%edx
  80323a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323d:	89 10                	mov    %edx,(%eax)
  80323f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	74 0b                	je     803253 <merging+0x2fe>
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	8b 00                	mov    (%eax),%eax
  80324d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803250:	89 50 04             	mov    %edx,0x4(%eax)
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803259:	89 10                	mov    %edx,(%eax)
  80325b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325e:	8b 55 08             	mov    0x8(%ebp),%edx
  803261:	89 50 04             	mov    %edx,0x4(%eax)
  803264:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803267:	8b 00                	mov    (%eax),%eax
  803269:	85 c0                	test   %eax,%eax
  80326b:	75 08                	jne    803275 <merging+0x320>
  80326d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803270:	a3 30 50 80 00       	mov    %eax,0x805030
  803275:	a1 38 50 80 00       	mov    0x805038,%eax
  80327a:	40                   	inc    %eax
  80327b:	a3 38 50 80 00       	mov    %eax,0x805038
  803280:	e9 ce 00 00 00       	jmp    803353 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803285:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803289:	74 65                	je     8032f0 <merging+0x39b>
  80328b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80328f:	75 17                	jne    8032a8 <merging+0x353>
  803291:	83 ec 04             	sub    $0x4,%esp
  803294:	68 a0 47 80 00       	push   $0x8047a0
  803299:	68 95 01 00 00       	push   $0x195
  80329e:	68 51 47 80 00       	push   $0x804751
  8032a3:	e8 ea d2 ff ff       	call   800592 <_panic>
  8032a8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b1:	89 50 04             	mov    %edx,0x4(%eax)
  8032b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ba:	85 c0                	test   %eax,%eax
  8032bc:	74 0c                	je     8032ca <merging+0x375>
  8032be:	a1 30 50 80 00       	mov    0x805030,%eax
  8032c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032c6:	89 10                	mov    %edx,(%eax)
  8032c8:	eb 08                	jmp    8032d2 <merging+0x37d>
  8032ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032cd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8032da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8032e8:	40                   	inc    %eax
  8032e9:	a3 38 50 80 00       	mov    %eax,0x805038
  8032ee:	eb 63                	jmp    803353 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8032f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032f4:	75 17                	jne    80330d <merging+0x3b8>
  8032f6:	83 ec 04             	sub    $0x4,%esp
  8032f9:	68 6c 47 80 00       	push   $0x80476c
  8032fe:	68 98 01 00 00       	push   $0x198
  803303:	68 51 47 80 00       	push   $0x804751
  803308:	e8 85 d2 ff ff       	call   800592 <_panic>
  80330d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803313:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803316:	89 10                	mov    %edx,(%eax)
  803318:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80331b:	8b 00                	mov    (%eax),%eax
  80331d:	85 c0                	test   %eax,%eax
  80331f:	74 0d                	je     80332e <merging+0x3d9>
  803321:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803326:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803329:	89 50 04             	mov    %edx,0x4(%eax)
  80332c:	eb 08                	jmp    803336 <merging+0x3e1>
  80332e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803331:	a3 30 50 80 00       	mov    %eax,0x805030
  803336:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803339:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80333e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803341:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803348:	a1 38 50 80 00       	mov    0x805038,%eax
  80334d:	40                   	inc    %eax
  80334e:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803353:	83 ec 0c             	sub    $0xc,%esp
  803356:	ff 75 10             	pushl  0x10(%ebp)
  803359:	e8 d6 ed ff ff       	call   802134 <get_block_size>
  80335e:	83 c4 10             	add    $0x10,%esp
  803361:	83 ec 04             	sub    $0x4,%esp
  803364:	6a 00                	push   $0x0
  803366:	50                   	push   %eax
  803367:	ff 75 10             	pushl  0x10(%ebp)
  80336a:	e8 16 f1 ff ff       	call   802485 <set_block_data>
  80336f:	83 c4 10             	add    $0x10,%esp
	}
}
  803372:	90                   	nop
  803373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803376:	c9                   	leave  
  803377:	c3                   	ret    

00803378 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803378:	55                   	push   %ebp
  803379:	89 e5                	mov    %esp,%ebp
  80337b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80337e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803383:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803386:	a1 30 50 80 00       	mov    0x805030,%eax
  80338b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80338e:	73 1b                	jae    8033ab <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803390:	a1 30 50 80 00       	mov    0x805030,%eax
  803395:	83 ec 04             	sub    $0x4,%esp
  803398:	ff 75 08             	pushl  0x8(%ebp)
  80339b:	6a 00                	push   $0x0
  80339d:	50                   	push   %eax
  80339e:	e8 b2 fb ff ff       	call   802f55 <merging>
  8033a3:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033a6:	e9 8b 00 00 00       	jmp    803436 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8033ab:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033b3:	76 18                	jbe    8033cd <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8033b5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033ba:	83 ec 04             	sub    $0x4,%esp
  8033bd:	ff 75 08             	pushl  0x8(%ebp)
  8033c0:	50                   	push   %eax
  8033c1:	6a 00                	push   $0x0
  8033c3:	e8 8d fb ff ff       	call   802f55 <merging>
  8033c8:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033cb:	eb 69                	jmp    803436 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033cd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d5:	eb 39                	jmp    803410 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033dd:	73 29                	jae    803408 <free_block+0x90>
  8033df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e2:	8b 00                	mov    (%eax),%eax
  8033e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033e7:	76 1f                	jbe    803408 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8033f1:	83 ec 04             	sub    $0x4,%esp
  8033f4:	ff 75 08             	pushl  0x8(%ebp)
  8033f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8033fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8033fd:	e8 53 fb ff ff       	call   802f55 <merging>
  803402:	83 c4 10             	add    $0x10,%esp
			break;
  803405:	90                   	nop
		}
	}
}
  803406:	eb 2e                	jmp    803436 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803408:	a1 34 50 80 00       	mov    0x805034,%eax
  80340d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803414:	74 07                	je     80341d <free_block+0xa5>
  803416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	eb 05                	jmp    803422 <free_block+0xaa>
  80341d:	b8 00 00 00 00       	mov    $0x0,%eax
  803422:	a3 34 50 80 00       	mov    %eax,0x805034
  803427:	a1 34 50 80 00       	mov    0x805034,%eax
  80342c:	85 c0                	test   %eax,%eax
  80342e:	75 a7                	jne    8033d7 <free_block+0x5f>
  803430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803434:	75 a1                	jne    8033d7 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803436:	90                   	nop
  803437:	c9                   	leave  
  803438:	c3                   	ret    

00803439 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803439:	55                   	push   %ebp
  80343a:	89 e5                	mov    %esp,%ebp
  80343c:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80343f:	ff 75 08             	pushl  0x8(%ebp)
  803442:	e8 ed ec ff ff       	call   802134 <get_block_size>
  803447:	83 c4 04             	add    $0x4,%esp
  80344a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80344d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803454:	eb 17                	jmp    80346d <copy_data+0x34>
  803456:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803459:	8b 45 0c             	mov    0xc(%ebp),%eax
  80345c:	01 c2                	add    %eax,%edx
  80345e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	01 c8                	add    %ecx,%eax
  803466:	8a 00                	mov    (%eax),%al
  803468:	88 02                	mov    %al,(%edx)
  80346a:	ff 45 fc             	incl   -0x4(%ebp)
  80346d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803470:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803473:	72 e1                	jb     803456 <copy_data+0x1d>
}
  803475:	90                   	nop
  803476:	c9                   	leave  
  803477:	c3                   	ret    

00803478 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803478:	55                   	push   %ebp
  803479:	89 e5                	mov    %esp,%ebp
  80347b:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80347e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803482:	75 23                	jne    8034a7 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803484:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803488:	74 13                	je     80349d <realloc_block_FF+0x25>
  80348a:	83 ec 0c             	sub    $0xc,%esp
  80348d:	ff 75 0c             	pushl  0xc(%ebp)
  803490:	e8 1f f0 ff ff       	call   8024b4 <alloc_block_FF>
  803495:	83 c4 10             	add    $0x10,%esp
  803498:	e9 f4 06 00 00       	jmp    803b91 <realloc_block_FF+0x719>
		return NULL;
  80349d:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a2:	e9 ea 06 00 00       	jmp    803b91 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8034a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034ab:	75 18                	jne    8034c5 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8034ad:	83 ec 0c             	sub    $0xc,%esp
  8034b0:	ff 75 08             	pushl  0x8(%ebp)
  8034b3:	e8 c0 fe ff ff       	call   803378 <free_block>
  8034b8:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8034bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c0:	e9 cc 06 00 00       	jmp    803b91 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8034c5:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8034c9:	77 07                	ja     8034d2 <realloc_block_FF+0x5a>
  8034cb:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8034d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d5:	83 e0 01             	and    $0x1,%eax
  8034d8:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8034db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034de:	83 c0 08             	add    $0x8,%eax
  8034e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8034e4:	83 ec 0c             	sub    $0xc,%esp
  8034e7:	ff 75 08             	pushl  0x8(%ebp)
  8034ea:	e8 45 ec ff ff       	call   802134 <get_block_size>
  8034ef:	83 c4 10             	add    $0x10,%esp
  8034f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f8:	83 e8 08             	sub    $0x8,%eax
  8034fb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	83 e8 04             	sub    $0x4,%eax
  803504:	8b 00                	mov    (%eax),%eax
  803506:	83 e0 fe             	and    $0xfffffffe,%eax
  803509:	89 c2                	mov    %eax,%edx
  80350b:	8b 45 08             	mov    0x8(%ebp),%eax
  80350e:	01 d0                	add    %edx,%eax
  803510:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803513:	83 ec 0c             	sub    $0xc,%esp
  803516:	ff 75 e4             	pushl  -0x1c(%ebp)
  803519:	e8 16 ec ff ff       	call   802134 <get_block_size>
  80351e:	83 c4 10             	add    $0x10,%esp
  803521:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803527:	83 e8 08             	sub    $0x8,%eax
  80352a:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80352d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803530:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803533:	75 08                	jne    80353d <realloc_block_FF+0xc5>
	{
		 return va;
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	e9 54 06 00 00       	jmp    803b91 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80353d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803540:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803543:	0f 83 e5 03 00 00    	jae    80392e <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803549:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80354f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803552:	83 ec 0c             	sub    $0xc,%esp
  803555:	ff 75 e4             	pushl  -0x1c(%ebp)
  803558:	e8 f0 eb ff ff       	call   80214d <is_free_block>
  80355d:	83 c4 10             	add    $0x10,%esp
  803560:	84 c0                	test   %al,%al
  803562:	0f 84 3b 01 00 00    	je     8036a3 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803568:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80356b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80356e:	01 d0                	add    %edx,%eax
  803570:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803573:	83 ec 04             	sub    $0x4,%esp
  803576:	6a 01                	push   $0x1
  803578:	ff 75 f0             	pushl  -0x10(%ebp)
  80357b:	ff 75 08             	pushl  0x8(%ebp)
  80357e:	e8 02 ef ff ff       	call   802485 <set_block_data>
  803583:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803586:	8b 45 08             	mov    0x8(%ebp),%eax
  803589:	83 e8 04             	sub    $0x4,%eax
  80358c:	8b 00                	mov    (%eax),%eax
  80358e:	83 e0 fe             	and    $0xfffffffe,%eax
  803591:	89 c2                	mov    %eax,%edx
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	01 d0                	add    %edx,%eax
  803598:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80359b:	83 ec 04             	sub    $0x4,%esp
  80359e:	6a 00                	push   $0x0
  8035a0:	ff 75 cc             	pushl  -0x34(%ebp)
  8035a3:	ff 75 c8             	pushl  -0x38(%ebp)
  8035a6:	e8 da ee ff ff       	call   802485 <set_block_data>
  8035ab:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8035ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035b2:	74 06                	je     8035ba <realloc_block_FF+0x142>
  8035b4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8035b8:	75 17                	jne    8035d1 <realloc_block_FF+0x159>
  8035ba:	83 ec 04             	sub    $0x4,%esp
  8035bd:	68 c4 47 80 00       	push   $0x8047c4
  8035c2:	68 f6 01 00 00       	push   $0x1f6
  8035c7:	68 51 47 80 00       	push   $0x804751
  8035cc:	e8 c1 cf ff ff       	call   800592 <_panic>
  8035d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d4:	8b 10                	mov    (%eax),%edx
  8035d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035d9:	89 10                	mov    %edx,(%eax)
  8035db:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035de:	8b 00                	mov    (%eax),%eax
  8035e0:	85 c0                	test   %eax,%eax
  8035e2:	74 0b                	je     8035ef <realloc_block_FF+0x177>
  8035e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035ec:	89 50 04             	mov    %edx,0x4(%eax)
  8035ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035f5:	89 10                	mov    %edx,(%eax)
  8035f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035fd:	89 50 04             	mov    %edx,0x4(%eax)
  803600:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803603:	8b 00                	mov    (%eax),%eax
  803605:	85 c0                	test   %eax,%eax
  803607:	75 08                	jne    803611 <realloc_block_FF+0x199>
  803609:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80360c:	a3 30 50 80 00       	mov    %eax,0x805030
  803611:	a1 38 50 80 00       	mov    0x805038,%eax
  803616:	40                   	inc    %eax
  803617:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80361c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803620:	75 17                	jne    803639 <realloc_block_FF+0x1c1>
  803622:	83 ec 04             	sub    $0x4,%esp
  803625:	68 33 47 80 00       	push   $0x804733
  80362a:	68 f7 01 00 00       	push   $0x1f7
  80362f:	68 51 47 80 00       	push   $0x804751
  803634:	e8 59 cf ff ff       	call   800592 <_panic>
  803639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363c:	8b 00                	mov    (%eax),%eax
  80363e:	85 c0                	test   %eax,%eax
  803640:	74 10                	je     803652 <realloc_block_FF+0x1da>
  803642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803645:	8b 00                	mov    (%eax),%eax
  803647:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80364a:	8b 52 04             	mov    0x4(%edx),%edx
  80364d:	89 50 04             	mov    %edx,0x4(%eax)
  803650:	eb 0b                	jmp    80365d <realloc_block_FF+0x1e5>
  803652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803655:	8b 40 04             	mov    0x4(%eax),%eax
  803658:	a3 30 50 80 00       	mov    %eax,0x805030
  80365d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803660:	8b 40 04             	mov    0x4(%eax),%eax
  803663:	85 c0                	test   %eax,%eax
  803665:	74 0f                	je     803676 <realloc_block_FF+0x1fe>
  803667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366a:	8b 40 04             	mov    0x4(%eax),%eax
  80366d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803670:	8b 12                	mov    (%edx),%edx
  803672:	89 10                	mov    %edx,(%eax)
  803674:	eb 0a                	jmp    803680 <realloc_block_FF+0x208>
  803676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803679:	8b 00                	mov    (%eax),%eax
  80367b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803683:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803693:	a1 38 50 80 00       	mov    0x805038,%eax
  803698:	48                   	dec    %eax
  803699:	a3 38 50 80 00       	mov    %eax,0x805038
  80369e:	e9 83 02 00 00       	jmp    803926 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8036a3:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8036a7:	0f 86 69 02 00 00    	jbe    803916 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8036ad:	83 ec 04             	sub    $0x4,%esp
  8036b0:	6a 01                	push   $0x1
  8036b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8036b5:	ff 75 08             	pushl  0x8(%ebp)
  8036b8:	e8 c8 ed ff ff       	call   802485 <set_block_data>
  8036bd:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c3:	83 e8 04             	sub    $0x4,%eax
  8036c6:	8b 00                	mov    (%eax),%eax
  8036c8:	83 e0 fe             	and    $0xfffffffe,%eax
  8036cb:	89 c2                	mov    %eax,%edx
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	01 d0                	add    %edx,%eax
  8036d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8036d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8036da:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8036dd:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8036e1:	75 68                	jne    80374b <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036e3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036e7:	75 17                	jne    803700 <realloc_block_FF+0x288>
  8036e9:	83 ec 04             	sub    $0x4,%esp
  8036ec:	68 6c 47 80 00       	push   $0x80476c
  8036f1:	68 06 02 00 00       	push   $0x206
  8036f6:	68 51 47 80 00       	push   $0x804751
  8036fb:	e8 92 ce ff ff       	call   800592 <_panic>
  803700:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803706:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803709:	89 10                	mov    %edx,(%eax)
  80370b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80370e:	8b 00                	mov    (%eax),%eax
  803710:	85 c0                	test   %eax,%eax
  803712:	74 0d                	je     803721 <realloc_block_FF+0x2a9>
  803714:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803719:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80371c:	89 50 04             	mov    %edx,0x4(%eax)
  80371f:	eb 08                	jmp    803729 <realloc_block_FF+0x2b1>
  803721:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803724:	a3 30 50 80 00       	mov    %eax,0x805030
  803729:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803731:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803734:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373b:	a1 38 50 80 00       	mov    0x805038,%eax
  803740:	40                   	inc    %eax
  803741:	a3 38 50 80 00       	mov    %eax,0x805038
  803746:	e9 b0 01 00 00       	jmp    8038fb <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80374b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803750:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803753:	76 68                	jbe    8037bd <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803755:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803759:	75 17                	jne    803772 <realloc_block_FF+0x2fa>
  80375b:	83 ec 04             	sub    $0x4,%esp
  80375e:	68 6c 47 80 00       	push   $0x80476c
  803763:	68 0b 02 00 00       	push   $0x20b
  803768:	68 51 47 80 00       	push   $0x804751
  80376d:	e8 20 ce ff ff       	call   800592 <_panic>
  803772:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80377b:	89 10                	mov    %edx,(%eax)
  80377d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803780:	8b 00                	mov    (%eax),%eax
  803782:	85 c0                	test   %eax,%eax
  803784:	74 0d                	je     803793 <realloc_block_FF+0x31b>
  803786:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80378b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80378e:	89 50 04             	mov    %edx,0x4(%eax)
  803791:	eb 08                	jmp    80379b <realloc_block_FF+0x323>
  803793:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803796:	a3 30 50 80 00       	mov    %eax,0x805030
  80379b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80379e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8037b2:	40                   	inc    %eax
  8037b3:	a3 38 50 80 00       	mov    %eax,0x805038
  8037b8:	e9 3e 01 00 00       	jmp    8038fb <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8037bd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037c2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037c5:	73 68                	jae    80382f <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8037c7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037cb:	75 17                	jne    8037e4 <realloc_block_FF+0x36c>
  8037cd:	83 ec 04             	sub    $0x4,%esp
  8037d0:	68 a0 47 80 00       	push   $0x8047a0
  8037d5:	68 10 02 00 00       	push   $0x210
  8037da:	68 51 47 80 00       	push   $0x804751
  8037df:	e8 ae cd ff ff       	call   800592 <_panic>
  8037e4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ed:	89 50 04             	mov    %edx,0x4(%eax)
  8037f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037f3:	8b 40 04             	mov    0x4(%eax),%eax
  8037f6:	85 c0                	test   %eax,%eax
  8037f8:	74 0c                	je     803806 <realloc_block_FF+0x38e>
  8037fa:	a1 30 50 80 00       	mov    0x805030,%eax
  8037ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803802:	89 10                	mov    %edx,(%eax)
  803804:	eb 08                	jmp    80380e <realloc_block_FF+0x396>
  803806:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803809:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80380e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803811:	a3 30 50 80 00       	mov    %eax,0x805030
  803816:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80381f:	a1 38 50 80 00       	mov    0x805038,%eax
  803824:	40                   	inc    %eax
  803825:	a3 38 50 80 00       	mov    %eax,0x805038
  80382a:	e9 cc 00 00 00       	jmp    8038fb <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80382f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803836:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80383b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80383e:	e9 8a 00 00 00       	jmp    8038cd <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803846:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803849:	73 7a                	jae    8038c5 <realloc_block_FF+0x44d>
  80384b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384e:	8b 00                	mov    (%eax),%eax
  803850:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803853:	73 70                	jae    8038c5 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803859:	74 06                	je     803861 <realloc_block_FF+0x3e9>
  80385b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80385f:	75 17                	jne    803878 <realloc_block_FF+0x400>
  803861:	83 ec 04             	sub    $0x4,%esp
  803864:	68 c4 47 80 00       	push   $0x8047c4
  803869:	68 1a 02 00 00       	push   $0x21a
  80386e:	68 51 47 80 00       	push   $0x804751
  803873:	e8 1a cd ff ff       	call   800592 <_panic>
  803878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387b:	8b 10                	mov    (%eax),%edx
  80387d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803880:	89 10                	mov    %edx,(%eax)
  803882:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803885:	8b 00                	mov    (%eax),%eax
  803887:	85 c0                	test   %eax,%eax
  803889:	74 0b                	je     803896 <realloc_block_FF+0x41e>
  80388b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388e:	8b 00                	mov    (%eax),%eax
  803890:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803893:	89 50 04             	mov    %edx,0x4(%eax)
  803896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803899:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80389c:	89 10                	mov    %edx,(%eax)
  80389e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038a4:	89 50 04             	mov    %edx,0x4(%eax)
  8038a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038aa:	8b 00                	mov    (%eax),%eax
  8038ac:	85 c0                	test   %eax,%eax
  8038ae:	75 08                	jne    8038b8 <realloc_block_FF+0x440>
  8038b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8038b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8038bd:	40                   	inc    %eax
  8038be:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8038c3:	eb 36                	jmp    8038fb <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8038c5:	a1 34 50 80 00       	mov    0x805034,%eax
  8038ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d1:	74 07                	je     8038da <realloc_block_FF+0x462>
  8038d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d6:	8b 00                	mov    (%eax),%eax
  8038d8:	eb 05                	jmp    8038df <realloc_block_FF+0x467>
  8038da:	b8 00 00 00 00       	mov    $0x0,%eax
  8038df:	a3 34 50 80 00       	mov    %eax,0x805034
  8038e4:	a1 34 50 80 00       	mov    0x805034,%eax
  8038e9:	85 c0                	test   %eax,%eax
  8038eb:	0f 85 52 ff ff ff    	jne    803843 <realloc_block_FF+0x3cb>
  8038f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f5:	0f 85 48 ff ff ff    	jne    803843 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8038fb:	83 ec 04             	sub    $0x4,%esp
  8038fe:	6a 00                	push   $0x0
  803900:	ff 75 d8             	pushl  -0x28(%ebp)
  803903:	ff 75 d4             	pushl  -0x2c(%ebp)
  803906:	e8 7a eb ff ff       	call   802485 <set_block_data>
  80390b:	83 c4 10             	add    $0x10,%esp
				return va;
  80390e:	8b 45 08             	mov    0x8(%ebp),%eax
  803911:	e9 7b 02 00 00       	jmp    803b91 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803916:	83 ec 0c             	sub    $0xc,%esp
  803919:	68 41 48 80 00       	push   $0x804841
  80391e:	e8 2c cf ff ff       	call   80084f <cprintf>
  803923:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803926:	8b 45 08             	mov    0x8(%ebp),%eax
  803929:	e9 63 02 00 00       	jmp    803b91 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80392e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803931:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803934:	0f 86 4d 02 00 00    	jbe    803b87 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80393a:	83 ec 0c             	sub    $0xc,%esp
  80393d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803940:	e8 08 e8 ff ff       	call   80214d <is_free_block>
  803945:	83 c4 10             	add    $0x10,%esp
  803948:	84 c0                	test   %al,%al
  80394a:	0f 84 37 02 00 00    	je     803b87 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803950:	8b 45 0c             	mov    0xc(%ebp),%eax
  803953:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803956:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803959:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80395c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80395f:	76 38                	jbe    803999 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803961:	83 ec 0c             	sub    $0xc,%esp
  803964:	ff 75 08             	pushl  0x8(%ebp)
  803967:	e8 0c fa ff ff       	call   803378 <free_block>
  80396c:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80396f:	83 ec 0c             	sub    $0xc,%esp
  803972:	ff 75 0c             	pushl  0xc(%ebp)
  803975:	e8 3a eb ff ff       	call   8024b4 <alloc_block_FF>
  80397a:	83 c4 10             	add    $0x10,%esp
  80397d:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803980:	83 ec 08             	sub    $0x8,%esp
  803983:	ff 75 c0             	pushl  -0x40(%ebp)
  803986:	ff 75 08             	pushl  0x8(%ebp)
  803989:	e8 ab fa ff ff       	call   803439 <copy_data>
  80398e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803991:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803994:	e9 f8 01 00 00       	jmp    803b91 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803999:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80399c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80399f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8039a2:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8039a6:	0f 87 a0 00 00 00    	ja     803a4c <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8039ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039b0:	75 17                	jne    8039c9 <realloc_block_FF+0x551>
  8039b2:	83 ec 04             	sub    $0x4,%esp
  8039b5:	68 33 47 80 00       	push   $0x804733
  8039ba:	68 38 02 00 00       	push   $0x238
  8039bf:	68 51 47 80 00       	push   $0x804751
  8039c4:	e8 c9 cb ff ff       	call   800592 <_panic>
  8039c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cc:	8b 00                	mov    (%eax),%eax
  8039ce:	85 c0                	test   %eax,%eax
  8039d0:	74 10                	je     8039e2 <realloc_block_FF+0x56a>
  8039d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d5:	8b 00                	mov    (%eax),%eax
  8039d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039da:	8b 52 04             	mov    0x4(%edx),%edx
  8039dd:	89 50 04             	mov    %edx,0x4(%eax)
  8039e0:	eb 0b                	jmp    8039ed <realloc_block_FF+0x575>
  8039e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e5:	8b 40 04             	mov    0x4(%eax),%eax
  8039e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8039ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f0:	8b 40 04             	mov    0x4(%eax),%eax
  8039f3:	85 c0                	test   %eax,%eax
  8039f5:	74 0f                	je     803a06 <realloc_block_FF+0x58e>
  8039f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fa:	8b 40 04             	mov    0x4(%eax),%eax
  8039fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a00:	8b 12                	mov    (%edx),%edx
  803a02:	89 10                	mov    %edx,(%eax)
  803a04:	eb 0a                	jmp    803a10 <realloc_block_FF+0x598>
  803a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a09:	8b 00                	mov    (%eax),%eax
  803a0b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a23:	a1 38 50 80 00       	mov    0x805038,%eax
  803a28:	48                   	dec    %eax
  803a29:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803a2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a34:	01 d0                	add    %edx,%eax
  803a36:	83 ec 04             	sub    $0x4,%esp
  803a39:	6a 01                	push   $0x1
  803a3b:	50                   	push   %eax
  803a3c:	ff 75 08             	pushl  0x8(%ebp)
  803a3f:	e8 41 ea ff ff       	call   802485 <set_block_data>
  803a44:	83 c4 10             	add    $0x10,%esp
  803a47:	e9 36 01 00 00       	jmp    803b82 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803a4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a4f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a52:	01 d0                	add    %edx,%eax
  803a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a57:	83 ec 04             	sub    $0x4,%esp
  803a5a:	6a 01                	push   $0x1
  803a5c:	ff 75 f0             	pushl  -0x10(%ebp)
  803a5f:	ff 75 08             	pushl  0x8(%ebp)
  803a62:	e8 1e ea ff ff       	call   802485 <set_block_data>
  803a67:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6d:	83 e8 04             	sub    $0x4,%eax
  803a70:	8b 00                	mov    (%eax),%eax
  803a72:	83 e0 fe             	and    $0xfffffffe,%eax
  803a75:	89 c2                	mov    %eax,%edx
  803a77:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7a:	01 d0                	add    %edx,%eax
  803a7c:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a83:	74 06                	je     803a8b <realloc_block_FF+0x613>
  803a85:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a89:	75 17                	jne    803aa2 <realloc_block_FF+0x62a>
  803a8b:	83 ec 04             	sub    $0x4,%esp
  803a8e:	68 c4 47 80 00       	push   $0x8047c4
  803a93:	68 44 02 00 00       	push   $0x244
  803a98:	68 51 47 80 00       	push   $0x804751
  803a9d:	e8 f0 ca ff ff       	call   800592 <_panic>
  803aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa5:	8b 10                	mov    (%eax),%edx
  803aa7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aaa:	89 10                	mov    %edx,(%eax)
  803aac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aaf:	8b 00                	mov    (%eax),%eax
  803ab1:	85 c0                	test   %eax,%eax
  803ab3:	74 0b                	je     803ac0 <realloc_block_FF+0x648>
  803ab5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab8:	8b 00                	mov    (%eax),%eax
  803aba:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803abd:	89 50 04             	mov    %edx,0x4(%eax)
  803ac0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ac6:	89 10                	mov    %edx,(%eax)
  803ac8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ace:	89 50 04             	mov    %edx,0x4(%eax)
  803ad1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ad4:	8b 00                	mov    (%eax),%eax
  803ad6:	85 c0                	test   %eax,%eax
  803ad8:	75 08                	jne    803ae2 <realloc_block_FF+0x66a>
  803ada:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803add:	a3 30 50 80 00       	mov    %eax,0x805030
  803ae2:	a1 38 50 80 00       	mov    0x805038,%eax
  803ae7:	40                   	inc    %eax
  803ae8:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803aed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803af1:	75 17                	jne    803b0a <realloc_block_FF+0x692>
  803af3:	83 ec 04             	sub    $0x4,%esp
  803af6:	68 33 47 80 00       	push   $0x804733
  803afb:	68 45 02 00 00       	push   $0x245
  803b00:	68 51 47 80 00       	push   $0x804751
  803b05:	e8 88 ca ff ff       	call   800592 <_panic>
  803b0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0d:	8b 00                	mov    (%eax),%eax
  803b0f:	85 c0                	test   %eax,%eax
  803b11:	74 10                	je     803b23 <realloc_block_FF+0x6ab>
  803b13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b16:	8b 00                	mov    (%eax),%eax
  803b18:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b1b:	8b 52 04             	mov    0x4(%edx),%edx
  803b1e:	89 50 04             	mov    %edx,0x4(%eax)
  803b21:	eb 0b                	jmp    803b2e <realloc_block_FF+0x6b6>
  803b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b26:	8b 40 04             	mov    0x4(%eax),%eax
  803b29:	a3 30 50 80 00       	mov    %eax,0x805030
  803b2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b31:	8b 40 04             	mov    0x4(%eax),%eax
  803b34:	85 c0                	test   %eax,%eax
  803b36:	74 0f                	je     803b47 <realloc_block_FF+0x6cf>
  803b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b3b:	8b 40 04             	mov    0x4(%eax),%eax
  803b3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b41:	8b 12                	mov    (%edx),%edx
  803b43:	89 10                	mov    %edx,(%eax)
  803b45:	eb 0a                	jmp    803b51 <realloc_block_FF+0x6d9>
  803b47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b4a:	8b 00                	mov    (%eax),%eax
  803b4c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b64:	a1 38 50 80 00       	mov    0x805038,%eax
  803b69:	48                   	dec    %eax
  803b6a:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b6f:	83 ec 04             	sub    $0x4,%esp
  803b72:	6a 00                	push   $0x0
  803b74:	ff 75 bc             	pushl  -0x44(%ebp)
  803b77:	ff 75 b8             	pushl  -0x48(%ebp)
  803b7a:	e8 06 e9 ff ff       	call   802485 <set_block_data>
  803b7f:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b82:	8b 45 08             	mov    0x8(%ebp),%eax
  803b85:	eb 0a                	jmp    803b91 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b87:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b91:	c9                   	leave  
  803b92:	c3                   	ret    

00803b93 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b93:	55                   	push   %ebp
  803b94:	89 e5                	mov    %esp,%ebp
  803b96:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b99:	83 ec 04             	sub    $0x4,%esp
  803b9c:	68 48 48 80 00       	push   $0x804848
  803ba1:	68 58 02 00 00       	push   $0x258
  803ba6:	68 51 47 80 00       	push   $0x804751
  803bab:	e8 e2 c9 ff ff       	call   800592 <_panic>

00803bb0 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803bb0:	55                   	push   %ebp
  803bb1:	89 e5                	mov    %esp,%ebp
  803bb3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803bb6:	83 ec 04             	sub    $0x4,%esp
  803bb9:	68 70 48 80 00       	push   $0x804870
  803bbe:	68 61 02 00 00       	push   $0x261
  803bc3:	68 51 47 80 00       	push   $0x804751
  803bc8:	e8 c5 c9 ff ff       	call   800592 <_panic>
  803bcd:	66 90                	xchg   %ax,%ax
  803bcf:	90                   	nop

00803bd0 <__udivdi3>:
  803bd0:	55                   	push   %ebp
  803bd1:	57                   	push   %edi
  803bd2:	56                   	push   %esi
  803bd3:	53                   	push   %ebx
  803bd4:	83 ec 1c             	sub    $0x1c,%esp
  803bd7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bdb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803be3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803be7:	89 ca                	mov    %ecx,%edx
  803be9:	89 f8                	mov    %edi,%eax
  803beb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bef:	85 f6                	test   %esi,%esi
  803bf1:	75 2d                	jne    803c20 <__udivdi3+0x50>
  803bf3:	39 cf                	cmp    %ecx,%edi
  803bf5:	77 65                	ja     803c5c <__udivdi3+0x8c>
  803bf7:	89 fd                	mov    %edi,%ebp
  803bf9:	85 ff                	test   %edi,%edi
  803bfb:	75 0b                	jne    803c08 <__udivdi3+0x38>
  803bfd:	b8 01 00 00 00       	mov    $0x1,%eax
  803c02:	31 d2                	xor    %edx,%edx
  803c04:	f7 f7                	div    %edi
  803c06:	89 c5                	mov    %eax,%ebp
  803c08:	31 d2                	xor    %edx,%edx
  803c0a:	89 c8                	mov    %ecx,%eax
  803c0c:	f7 f5                	div    %ebp
  803c0e:	89 c1                	mov    %eax,%ecx
  803c10:	89 d8                	mov    %ebx,%eax
  803c12:	f7 f5                	div    %ebp
  803c14:	89 cf                	mov    %ecx,%edi
  803c16:	89 fa                	mov    %edi,%edx
  803c18:	83 c4 1c             	add    $0x1c,%esp
  803c1b:	5b                   	pop    %ebx
  803c1c:	5e                   	pop    %esi
  803c1d:	5f                   	pop    %edi
  803c1e:	5d                   	pop    %ebp
  803c1f:	c3                   	ret    
  803c20:	39 ce                	cmp    %ecx,%esi
  803c22:	77 28                	ja     803c4c <__udivdi3+0x7c>
  803c24:	0f bd fe             	bsr    %esi,%edi
  803c27:	83 f7 1f             	xor    $0x1f,%edi
  803c2a:	75 40                	jne    803c6c <__udivdi3+0x9c>
  803c2c:	39 ce                	cmp    %ecx,%esi
  803c2e:	72 0a                	jb     803c3a <__udivdi3+0x6a>
  803c30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c34:	0f 87 9e 00 00 00    	ja     803cd8 <__udivdi3+0x108>
  803c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c3f:	89 fa                	mov    %edi,%edx
  803c41:	83 c4 1c             	add    $0x1c,%esp
  803c44:	5b                   	pop    %ebx
  803c45:	5e                   	pop    %esi
  803c46:	5f                   	pop    %edi
  803c47:	5d                   	pop    %ebp
  803c48:	c3                   	ret    
  803c49:	8d 76 00             	lea    0x0(%esi),%esi
  803c4c:	31 ff                	xor    %edi,%edi
  803c4e:	31 c0                	xor    %eax,%eax
  803c50:	89 fa                	mov    %edi,%edx
  803c52:	83 c4 1c             	add    $0x1c,%esp
  803c55:	5b                   	pop    %ebx
  803c56:	5e                   	pop    %esi
  803c57:	5f                   	pop    %edi
  803c58:	5d                   	pop    %ebp
  803c59:	c3                   	ret    
  803c5a:	66 90                	xchg   %ax,%ax
  803c5c:	89 d8                	mov    %ebx,%eax
  803c5e:	f7 f7                	div    %edi
  803c60:	31 ff                	xor    %edi,%edi
  803c62:	89 fa                	mov    %edi,%edx
  803c64:	83 c4 1c             	add    $0x1c,%esp
  803c67:	5b                   	pop    %ebx
  803c68:	5e                   	pop    %esi
  803c69:	5f                   	pop    %edi
  803c6a:	5d                   	pop    %ebp
  803c6b:	c3                   	ret    
  803c6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c71:	89 eb                	mov    %ebp,%ebx
  803c73:	29 fb                	sub    %edi,%ebx
  803c75:	89 f9                	mov    %edi,%ecx
  803c77:	d3 e6                	shl    %cl,%esi
  803c79:	89 c5                	mov    %eax,%ebp
  803c7b:	88 d9                	mov    %bl,%cl
  803c7d:	d3 ed                	shr    %cl,%ebp
  803c7f:	89 e9                	mov    %ebp,%ecx
  803c81:	09 f1                	or     %esi,%ecx
  803c83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c87:	89 f9                	mov    %edi,%ecx
  803c89:	d3 e0                	shl    %cl,%eax
  803c8b:	89 c5                	mov    %eax,%ebp
  803c8d:	89 d6                	mov    %edx,%esi
  803c8f:	88 d9                	mov    %bl,%cl
  803c91:	d3 ee                	shr    %cl,%esi
  803c93:	89 f9                	mov    %edi,%ecx
  803c95:	d3 e2                	shl    %cl,%edx
  803c97:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c9b:	88 d9                	mov    %bl,%cl
  803c9d:	d3 e8                	shr    %cl,%eax
  803c9f:	09 c2                	or     %eax,%edx
  803ca1:	89 d0                	mov    %edx,%eax
  803ca3:	89 f2                	mov    %esi,%edx
  803ca5:	f7 74 24 0c          	divl   0xc(%esp)
  803ca9:	89 d6                	mov    %edx,%esi
  803cab:	89 c3                	mov    %eax,%ebx
  803cad:	f7 e5                	mul    %ebp
  803caf:	39 d6                	cmp    %edx,%esi
  803cb1:	72 19                	jb     803ccc <__udivdi3+0xfc>
  803cb3:	74 0b                	je     803cc0 <__udivdi3+0xf0>
  803cb5:	89 d8                	mov    %ebx,%eax
  803cb7:	31 ff                	xor    %edi,%edi
  803cb9:	e9 58 ff ff ff       	jmp    803c16 <__udivdi3+0x46>
  803cbe:	66 90                	xchg   %ax,%ax
  803cc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803cc4:	89 f9                	mov    %edi,%ecx
  803cc6:	d3 e2                	shl    %cl,%edx
  803cc8:	39 c2                	cmp    %eax,%edx
  803cca:	73 e9                	jae    803cb5 <__udivdi3+0xe5>
  803ccc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ccf:	31 ff                	xor    %edi,%edi
  803cd1:	e9 40 ff ff ff       	jmp    803c16 <__udivdi3+0x46>
  803cd6:	66 90                	xchg   %ax,%ax
  803cd8:	31 c0                	xor    %eax,%eax
  803cda:	e9 37 ff ff ff       	jmp    803c16 <__udivdi3+0x46>
  803cdf:	90                   	nop

00803ce0 <__umoddi3>:
  803ce0:	55                   	push   %ebp
  803ce1:	57                   	push   %edi
  803ce2:	56                   	push   %esi
  803ce3:	53                   	push   %ebx
  803ce4:	83 ec 1c             	sub    $0x1c,%esp
  803ce7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ceb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cf3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cf7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cff:	89 f3                	mov    %esi,%ebx
  803d01:	89 fa                	mov    %edi,%edx
  803d03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d07:	89 34 24             	mov    %esi,(%esp)
  803d0a:	85 c0                	test   %eax,%eax
  803d0c:	75 1a                	jne    803d28 <__umoddi3+0x48>
  803d0e:	39 f7                	cmp    %esi,%edi
  803d10:	0f 86 a2 00 00 00    	jbe    803db8 <__umoddi3+0xd8>
  803d16:	89 c8                	mov    %ecx,%eax
  803d18:	89 f2                	mov    %esi,%edx
  803d1a:	f7 f7                	div    %edi
  803d1c:	89 d0                	mov    %edx,%eax
  803d1e:	31 d2                	xor    %edx,%edx
  803d20:	83 c4 1c             	add    $0x1c,%esp
  803d23:	5b                   	pop    %ebx
  803d24:	5e                   	pop    %esi
  803d25:	5f                   	pop    %edi
  803d26:	5d                   	pop    %ebp
  803d27:	c3                   	ret    
  803d28:	39 f0                	cmp    %esi,%eax
  803d2a:	0f 87 ac 00 00 00    	ja     803ddc <__umoddi3+0xfc>
  803d30:	0f bd e8             	bsr    %eax,%ebp
  803d33:	83 f5 1f             	xor    $0x1f,%ebp
  803d36:	0f 84 ac 00 00 00    	je     803de8 <__umoddi3+0x108>
  803d3c:	bf 20 00 00 00       	mov    $0x20,%edi
  803d41:	29 ef                	sub    %ebp,%edi
  803d43:	89 fe                	mov    %edi,%esi
  803d45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d49:	89 e9                	mov    %ebp,%ecx
  803d4b:	d3 e0                	shl    %cl,%eax
  803d4d:	89 d7                	mov    %edx,%edi
  803d4f:	89 f1                	mov    %esi,%ecx
  803d51:	d3 ef                	shr    %cl,%edi
  803d53:	09 c7                	or     %eax,%edi
  803d55:	89 e9                	mov    %ebp,%ecx
  803d57:	d3 e2                	shl    %cl,%edx
  803d59:	89 14 24             	mov    %edx,(%esp)
  803d5c:	89 d8                	mov    %ebx,%eax
  803d5e:	d3 e0                	shl    %cl,%eax
  803d60:	89 c2                	mov    %eax,%edx
  803d62:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d66:	d3 e0                	shl    %cl,%eax
  803d68:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d70:	89 f1                	mov    %esi,%ecx
  803d72:	d3 e8                	shr    %cl,%eax
  803d74:	09 d0                	or     %edx,%eax
  803d76:	d3 eb                	shr    %cl,%ebx
  803d78:	89 da                	mov    %ebx,%edx
  803d7a:	f7 f7                	div    %edi
  803d7c:	89 d3                	mov    %edx,%ebx
  803d7e:	f7 24 24             	mull   (%esp)
  803d81:	89 c6                	mov    %eax,%esi
  803d83:	89 d1                	mov    %edx,%ecx
  803d85:	39 d3                	cmp    %edx,%ebx
  803d87:	0f 82 87 00 00 00    	jb     803e14 <__umoddi3+0x134>
  803d8d:	0f 84 91 00 00 00    	je     803e24 <__umoddi3+0x144>
  803d93:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d97:	29 f2                	sub    %esi,%edx
  803d99:	19 cb                	sbb    %ecx,%ebx
  803d9b:	89 d8                	mov    %ebx,%eax
  803d9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803da1:	d3 e0                	shl    %cl,%eax
  803da3:	89 e9                	mov    %ebp,%ecx
  803da5:	d3 ea                	shr    %cl,%edx
  803da7:	09 d0                	or     %edx,%eax
  803da9:	89 e9                	mov    %ebp,%ecx
  803dab:	d3 eb                	shr    %cl,%ebx
  803dad:	89 da                	mov    %ebx,%edx
  803daf:	83 c4 1c             	add    $0x1c,%esp
  803db2:	5b                   	pop    %ebx
  803db3:	5e                   	pop    %esi
  803db4:	5f                   	pop    %edi
  803db5:	5d                   	pop    %ebp
  803db6:	c3                   	ret    
  803db7:	90                   	nop
  803db8:	89 fd                	mov    %edi,%ebp
  803dba:	85 ff                	test   %edi,%edi
  803dbc:	75 0b                	jne    803dc9 <__umoddi3+0xe9>
  803dbe:	b8 01 00 00 00       	mov    $0x1,%eax
  803dc3:	31 d2                	xor    %edx,%edx
  803dc5:	f7 f7                	div    %edi
  803dc7:	89 c5                	mov    %eax,%ebp
  803dc9:	89 f0                	mov    %esi,%eax
  803dcb:	31 d2                	xor    %edx,%edx
  803dcd:	f7 f5                	div    %ebp
  803dcf:	89 c8                	mov    %ecx,%eax
  803dd1:	f7 f5                	div    %ebp
  803dd3:	89 d0                	mov    %edx,%eax
  803dd5:	e9 44 ff ff ff       	jmp    803d1e <__umoddi3+0x3e>
  803dda:	66 90                	xchg   %ax,%ax
  803ddc:	89 c8                	mov    %ecx,%eax
  803dde:	89 f2                	mov    %esi,%edx
  803de0:	83 c4 1c             	add    $0x1c,%esp
  803de3:	5b                   	pop    %ebx
  803de4:	5e                   	pop    %esi
  803de5:	5f                   	pop    %edi
  803de6:	5d                   	pop    %ebp
  803de7:	c3                   	ret    
  803de8:	3b 04 24             	cmp    (%esp),%eax
  803deb:	72 06                	jb     803df3 <__umoddi3+0x113>
  803ded:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803df1:	77 0f                	ja     803e02 <__umoddi3+0x122>
  803df3:	89 f2                	mov    %esi,%edx
  803df5:	29 f9                	sub    %edi,%ecx
  803df7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dfb:	89 14 24             	mov    %edx,(%esp)
  803dfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e02:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e06:	8b 14 24             	mov    (%esp),%edx
  803e09:	83 c4 1c             	add    $0x1c,%esp
  803e0c:	5b                   	pop    %ebx
  803e0d:	5e                   	pop    %esi
  803e0e:	5f                   	pop    %edi
  803e0f:	5d                   	pop    %ebp
  803e10:	c3                   	ret    
  803e11:	8d 76 00             	lea    0x0(%esi),%esi
  803e14:	2b 04 24             	sub    (%esp),%eax
  803e17:	19 fa                	sbb    %edi,%edx
  803e19:	89 d1                	mov    %edx,%ecx
  803e1b:	89 c6                	mov    %eax,%esi
  803e1d:	e9 71 ff ff ff       	jmp    803d93 <__umoddi3+0xb3>
  803e22:	66 90                	xchg   %ax,%ax
  803e24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e28:	72 ea                	jb     803e14 <__umoddi3+0x134>
  803e2a:	89 d9                	mov    %ebx,%ecx
  803e2c:	e9 62 ff ff ff       	jmp    803d93 <__umoddi3+0xb3>
