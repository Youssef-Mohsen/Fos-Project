
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
  80005c:	68 20 3e 80 00       	push   $0x803e20
  800061:	6a 14                	push   $0x14
  800063:	68 3c 3e 80 00       	push   $0x803e3c
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
  800082:	e8 b5 1b 00 00       	call   801c3c <sys_calculate_free_frames>
  800087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = smalloc("x", 4, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 04                	push   $0x4
  800091:	68 57 3e 80 00       	push   $0x803e57
  800096:	e8 82 18 00 00       	call   80191d <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 5c 3e 80 00       	push   $0x803e5c
  8000b8:	e8 92 07 00 00       	call   80084f <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8000c0:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8000c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ca:	e8 6d 1b 00 00       	call   801c3c <sys_calculate_free_frames>
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
  8000f3:	e8 44 1b 00 00       	call   801c3c <sys_calculate_free_frames>
  8000f8:	29 c3                	sub    %eax,%ebx
  8000fa:	89 d8                	mov    %ebx,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800102:	50                   	push   %eax
  800103:	68 c0 3e 80 00       	push   $0x803ec0
  800108:	e8 42 07 00 00       	call   80084f <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800110:	e8 27 1b 00 00       	call   801c3c <sys_calculate_free_frames>
  800115:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = smalloc("y", 4, 0);
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	6a 00                	push   $0x0
  80011d:	6a 04                	push   $0x4
  80011f:	68 58 3f 80 00       	push   $0x803f58
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
  800146:	68 5c 3e 80 00       	push   $0x803e5c
  80014b:	e8 ff 06 00 00       	call   80084f <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  800153:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80015a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80015d:	e8 da 1a 00 00       	call   801c3c <sys_calculate_free_frames>
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
  800186:	e8 b1 1a 00 00       	call   801c3c <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	50                   	push   %eax
  800196:	68 c0 3e 80 00       	push   $0x803ec0
  80019b:	e8 af 06 00 00       	call   80084f <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  8001a3:	e8 94 1a 00 00       	call   801c3c <sys_calculate_free_frames>
  8001a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = smalloc("z", 4, 1);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 01                	push   $0x1
  8001b0:	6a 04                	push   $0x4
  8001b2:	68 5a 3f 80 00       	push   $0x803f5a
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
  8001d9:	68 5c 3e 80 00       	push   $0x803e5c
  8001de:	e8 6c 06 00 00       	call   80084f <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8001e6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001f0:	e8 47 1a 00 00       	call   801c3c <sys_calculate_free_frames>
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
  800219:	e8 1e 1a 00 00       	call   801c3c <sys_calculate_free_frames>
  80021e:	29 c3                	sub    %eax,%ebx
  800220:	89 d8                	mov    %ebx,%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	50                   	push   %eax
  800229:	68 c0 3e 80 00       	push   $0x803ec0
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
  80027f:	68 5c 3f 80 00       	push   $0x803f5c
  800284:	e8 0e 1b 00 00       	call   801d97 <sys_create_env>
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
  8002b5:	68 5c 3f 80 00       	push   $0x803f5c
  8002ba:	e8 d8 1a 00 00       	call   801d97 <sys_create_env>
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
  8002eb:	68 5c 3f 80 00       	push   $0x803f5c
  8002f0:	e8 a2 1a 00 00       	call   801d97 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8002fb:	e8 e3 1b 00 00       	call   801ee3 <rsttst>

	sys_run_env(id1);\
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 d0             	pushl  -0x30(%ebp)
  800306:	e8 aa 1a 00 00       	call   801db5 <sys_run_env>
  80030b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 cc             	pushl  -0x34(%ebp)
  800314:	e8 9c 1a 00 00       	call   801db5 <sys_run_env>
  800319:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 c8             	pushl  -0x38(%ebp)
  800322:	e8 8e 1a 00 00       	call   801db5 <sys_run_env>
  800327:	83 c4 10             	add    $0x10,%esp
	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  80032a:	90                   	nop
  80032b:	e8 2d 1c 00 00       	call   801f5d <gettst>
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
  800349:	68 68 3f 80 00       	push   $0x803f68
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
  80036a:	68 b4 3f 80 00       	push   $0x803fb4
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
  80039d:	68 e6 3f 80 00       	push   $0x803fe6
  8003a2:	e8 f0 19 00 00       	call   801d97 <sys_create_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b3:	e8 fd 19 00 00       	call   801db5 <sys_run_env>
  8003b8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  8003bb:	90                   	nop
  8003bc:	e8 9c 1b 00 00       	call   801f5d <gettst>
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
  8003da:	68 68 3f 80 00       	push   $0x803f68
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
  8003f8:	e8 46 1b 00 00       	call   801f43 <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8003fd:	90                   	nop
  8003fe:	e8 5a 1b 00 00       	call   801f5d <gettst>
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
  80041c:	68 68 3f 80 00       	push   $0x803f68
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
  800440:	68 f4 3f 80 00       	push   $0x803ff4
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
  800459:	e8 a7 19 00 00       	call   801e05 <sys_getenvindex>
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
  8004c7:	e8 bd 16 00 00       	call   801b89 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004cc:	83 ec 0c             	sub    $0xc,%esp
  8004cf:	68 50 40 80 00       	push   $0x804050
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
  8004f7:	68 78 40 80 00       	push   $0x804078
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
  800528:	68 a0 40 80 00       	push   $0x8040a0
  80052d:	e8 1d 03 00 00       	call   80084f <cprintf>
  800532:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800535:	a1 20 50 80 00       	mov    0x805020,%eax
  80053a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	50                   	push   %eax
  800544:	68 f8 40 80 00       	push   $0x8040f8
  800549:	e8 01 03 00 00       	call   80084f <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 50 40 80 00       	push   $0x804050
  800559:	e8 f1 02 00 00       	call   80084f <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800561:	e8 3d 16 00 00       	call   801ba3 <sys_unlock_cons>
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
  800579:	e8 53 18 00 00       	call   801dd1 <sys_destroy_env>
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
  80058a:	e8 a8 18 00 00       	call   801e37 <sys_exit_env>
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
  8005b3:	68 0c 41 80 00       	push   $0x80410c
  8005b8:	e8 92 02 00 00       	call   80084f <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005c0:	a1 00 50 80 00       	mov    0x805000,%eax
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	50                   	push   %eax
  8005cc:	68 11 41 80 00       	push   $0x804111
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
  8005f0:	68 2d 41 80 00       	push   $0x80412d
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
  80061f:	68 30 41 80 00       	push   $0x804130
  800624:	6a 26                	push   $0x26
  800626:	68 7c 41 80 00       	push   $0x80417c
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
  8006f4:	68 88 41 80 00       	push   $0x804188
  8006f9:	6a 3a                	push   $0x3a
  8006fb:	68 7c 41 80 00       	push   $0x80417c
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
  800767:	68 dc 41 80 00       	push   $0x8041dc
  80076c:	6a 44                	push   $0x44
  80076e:	68 7c 41 80 00       	push   $0x80417c
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
  8007c1:	e8 81 13 00 00       	call   801b47 <sys_cputs>
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
  800838:	e8 0a 13 00 00       	call   801b47 <sys_cputs>
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
  800882:	e8 02 13 00 00       	call   801b89 <sys_lock_cons>
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
  8008a2:	e8 fc 12 00 00       	call   801ba3 <sys_unlock_cons>
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
  8008ec:	e8 bb 32 00 00       	call   803bac <__udivdi3>
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
  80093c:	e8 7b 33 00 00       	call   803cbc <__umoddi3>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	05 54 44 80 00       	add    $0x804454,%eax
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
  800a97:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
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
  800b78:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  800b7f:	85 f6                	test   %esi,%esi
  800b81:	75 19                	jne    800b9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b83:	53                   	push   %ebx
  800b84:	68 65 44 80 00       	push   $0x804465
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
  800b9d:	68 6e 44 80 00       	push   $0x80446e
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
  800bca:	be 71 44 80 00       	mov    $0x804471,%esi
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
  8015d5:	68 e8 45 80 00       	push   $0x8045e8
  8015da:	68 3f 01 00 00       	push   $0x13f
  8015df:	68 0a 46 80 00       	push   $0x80460a
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
  8015f5:	e8 f8 0a 00 00       	call   8020f2 <sys_sbrk>
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
  801670:	e8 01 09 00 00       	call   801f76 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801675:	85 c0                	test   %eax,%eax
  801677:	74 16                	je     80168f <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	e8 41 0e 00 00       	call   8024c5 <alloc_block_FF>
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168a:	e9 8a 01 00 00       	jmp    801819 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80168f:	e8 13 09 00 00       	call   801fa7 <sys_isUHeapPlacementStrategyBESTFIT>
  801694:	85 c0                	test   %eax,%eax
  801696:	0f 84 7d 01 00 00    	je     801819 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	e8 da 12 00 00       	call   802981 <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801704:	05 00 10 00 00       	add    $0x1000,%eax
  801709:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80170c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  8017ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017b0:	75 16                	jne    8017c8 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8017b2:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8017b9:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8017c0:	0f 86 15 ff ff ff    	jbe    8016db <malloc+0xdc>
  8017c6:	eb 01                	jmp    8017c9 <malloc+0x1ca>
				}
				

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
  801808:	e8 1c 09 00 00       	call   802129 <sys_allocate_user_mem>
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	eb 07                	jmp    801819 <malloc+0x21a>
		
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
  801850:	e8 f0 08 00 00       	call   802145 <get_block_size>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 00 1b 00 00       	call   803366 <free_block>
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
  80189b:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  8018d8:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  8018df:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8018e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	83 ec 08             	sub    $0x8,%esp
  8018ec:	52                   	push   %edx
  8018ed:	50                   	push   %eax
  8018ee:	e8 1a 08 00 00       	call   80210d <sys_free_user_mem>
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
  801906:	68 18 46 80 00       	push   $0x804618
  80190b:	68 87 00 00 00       	push   $0x87
  801910:	68 42 46 80 00       	push   $0x804642
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
  801934:	e9 87 00 00 00       	jmp    8019c0 <smalloc+0xa3>
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
  801965:	75 07                	jne    80196e <smalloc+0x51>
  801967:	b8 00 00 00 00       	mov    $0x0,%eax
  80196c:	eb 52                	jmp    8019c0 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80196e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801972:	ff 75 ec             	pushl  -0x14(%ebp)
  801975:	50                   	push   %eax
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	ff 75 08             	pushl  0x8(%ebp)
  80197c:	e8 93 03 00 00       	call   801d14 <sys_createSharedObject>
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801987:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80198b:	74 06                	je     801993 <smalloc+0x76>
  80198d:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801991:	75 07                	jne    80199a <smalloc+0x7d>
  801993:	b8 00 00 00 00       	mov    $0x0,%eax
  801998:	eb 26                	jmp    8019c0 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80199a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80199d:	a1 20 50 80 00       	mov    0x805020,%eax
  8019a2:	8b 40 78             	mov    0x78(%eax),%eax
  8019a5:	29 c2                	sub    %eax,%edx
  8019a7:	89 d0                	mov    %edx,%eax
  8019a9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019ae:	c1 e8 0c             	shr    $0xc,%eax
  8019b1:	89 c2                	mov    %eax,%edx
  8019b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019b6:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8019bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8019c8:	83 ec 08             	sub    $0x8,%esp
  8019cb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ce:	ff 75 08             	pushl  0x8(%ebp)
  8019d1:	e8 68 03 00 00       	call   801d3e <sys_getSizeOfSharedObject>
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8019dc:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019e0:	75 07                	jne    8019e9 <sget+0x27>
  8019e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e7:	eb 7f                	jmp    801a68 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8019e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019ef:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fc:	39 d0                	cmp    %edx,%eax
  8019fe:	73 02                	jae    801a02 <sget+0x40>
  801a00:	89 d0                	mov    %edx,%eax
  801a02:	83 ec 0c             	sub    $0xc,%esp
  801a05:	50                   	push   %eax
  801a06:	e8 f4 fb ff ff       	call   8015ff <malloc>
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801a11:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a15:	75 07                	jne    801a1e <sget+0x5c>
  801a17:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1c:	eb 4a                	jmp    801a68 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801a1e:	83 ec 04             	sub    $0x4,%esp
  801a21:	ff 75 e8             	pushl  -0x18(%ebp)
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	ff 75 08             	pushl  0x8(%ebp)
  801a2a:	e8 2c 03 00 00       	call   801d5b <sys_getSharedObject>
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801a35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a38:	a1 20 50 80 00       	mov    0x805020,%eax
  801a3d:	8b 40 78             	mov    0x78(%eax),%eax
  801a40:	29 c2                	sub    %eax,%edx
  801a42:	89 d0                	mov    %edx,%eax
  801a44:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a49:	c1 e8 0c             	shr    $0xc,%eax
  801a4c:	89 c2                	mov    %eax,%edx
  801a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a51:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801a58:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a5c:	75 07                	jne    801a65 <sget+0xa3>
  801a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a63:	eb 03                	jmp    801a68 <sget+0xa6>
	return ptr;
  801a65:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801a70:	8b 55 08             	mov    0x8(%ebp),%edx
  801a73:	a1 20 50 80 00       	mov    0x805020,%eax
  801a78:	8b 40 78             	mov    0x78(%eax),%eax
  801a7b:	29 c2                	sub    %eax,%edx
  801a7d:	89 d0                	mov    %edx,%eax
  801a7f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a84:	c1 e8 0c             	shr    $0xc,%eax
  801a87:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801a91:	83 ec 08             	sub    $0x8,%esp
  801a94:	ff 75 08             	pushl  0x8(%ebp)
  801a97:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9a:	e8 db 02 00 00       	call   801d7a <sys_freeSharedObject>
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801aa5:	90                   	nop
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	68 50 46 80 00       	push   $0x804650
  801ab6:	68 e4 00 00 00       	push   $0xe4
  801abb:	68 42 46 80 00       	push   $0x804642
  801ac0:	e8 cd ea ff ff       	call   800592 <_panic>

00801ac5 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	68 76 46 80 00       	push   $0x804676
  801ad3:	68 f0 00 00 00       	push   $0xf0
  801ad8:	68 42 46 80 00       	push   $0x804642
  801add:	e8 b0 ea ff ff       	call   800592 <_panic>

00801ae2 <shrink>:

}
void shrink(uint32 newSize)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae8:	83 ec 04             	sub    $0x4,%esp
  801aeb:	68 76 46 80 00       	push   $0x804676
  801af0:	68 f5 00 00 00       	push   $0xf5
  801af5:	68 42 46 80 00       	push   $0x804642
  801afa:	e8 93 ea ff ff       	call   800592 <_panic>

00801aff <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	68 76 46 80 00       	push   $0x804676
  801b0d:	68 fa 00 00 00       	push   $0xfa
  801b12:	68 42 46 80 00       	push   $0x804642
  801b17:	e8 76 ea ff ff       	call   800592 <_panic>

00801b1c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	57                   	push   %edi
  801b20:	56                   	push   %esi
  801b21:	53                   	push   %ebx
  801b22:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b31:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b34:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b37:	cd 30                	int    $0x30
  801b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	5b                   	pop    %ebx
  801b43:	5e                   	pop    %esi
  801b44:	5f                   	pop    %edi
  801b45:	5d                   	pop    %ebp
  801b46:	c3                   	ret    

00801b47 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b50:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b53:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	52                   	push   %edx
  801b5f:	ff 75 0c             	pushl  0xc(%ebp)
  801b62:	50                   	push   %eax
  801b63:	6a 00                	push   $0x0
  801b65:	e8 b2 ff ff ff       	call   801b1c <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	90                   	nop
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 02                	push   $0x2
  801b7f:	e8 98 ff ff ff       	call   801b1c <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 03                	push   $0x3
  801b98:	e8 7f ff ff ff       	call   801b1c <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	90                   	nop
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 04                	push   $0x4
  801bb2:	e8 65 ff ff ff       	call   801b1c <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	90                   	nop
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	52                   	push   %edx
  801bcd:	50                   	push   %eax
  801bce:	6a 08                	push   $0x8
  801bd0:	e8 47 ff ff ff       	call   801b1c <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	56                   	push   %esi
  801bde:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bdf:	8b 75 18             	mov    0x18(%ebp),%esi
  801be2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801be5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	56                   	push   %esi
  801bef:	53                   	push   %ebx
  801bf0:	51                   	push   %ecx
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	6a 09                	push   $0x9
  801bf5:	e8 22 ff ff ff       	call   801b1c <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    

00801c04 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	52                   	push   %edx
  801c14:	50                   	push   %eax
  801c15:	6a 0a                	push   $0xa
  801c17:	e8 00 ff ff ff       	call   801b1c <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	ff 75 0c             	pushl  0xc(%ebp)
  801c2d:	ff 75 08             	pushl  0x8(%ebp)
  801c30:	6a 0b                	push   $0xb
  801c32:	e8 e5 fe ff ff       	call   801b1c <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 0c                	push   $0xc
  801c4b:	e8 cc fe ff ff       	call   801b1c <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 0d                	push   $0xd
  801c64:	e8 b3 fe ff ff       	call   801b1c <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 0e                	push   $0xe
  801c7d:	e8 9a fe ff ff       	call   801b1c <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 0f                	push   $0xf
  801c96:	e8 81 fe ff ff       	call   801b1c <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	ff 75 08             	pushl  0x8(%ebp)
  801cae:	6a 10                	push   $0x10
  801cb0:	e8 67 fe ff ff       	call   801b1c <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 11                	push   $0x11
  801cc9:	e8 4e fe ff ff       	call   801b1c <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	90                   	nop
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_cputc>:

void
sys_cputc(const char c)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 04             	sub    $0x4,%esp
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ce0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	50                   	push   %eax
  801ced:	6a 01                	push   $0x1
  801cef:	e8 28 fe ff ff       	call   801b1c <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	90                   	nop
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 14                	push   $0x14
  801d09:	e8 0e fe ff ff       	call   801b1c <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	90                   	nop
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d20:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d23:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	6a 00                	push   $0x0
  801d2c:	51                   	push   %ecx
  801d2d:	52                   	push   %edx
  801d2e:	ff 75 0c             	pushl  0xc(%ebp)
  801d31:	50                   	push   %eax
  801d32:	6a 15                	push   $0x15
  801d34:	e8 e3 fd ff ff       	call   801b1c <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	52                   	push   %edx
  801d4e:	50                   	push   %eax
  801d4f:	6a 16                	push   $0x16
  801d51:	e8 c6 fd ff ff       	call   801b1c <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	51                   	push   %ecx
  801d6c:	52                   	push   %edx
  801d6d:	50                   	push   %eax
  801d6e:	6a 17                	push   $0x17
  801d70:	e8 a7 fd ff ff       	call   801b1c <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	6a 18                	push   $0x18
  801d8d:	e8 8a fd ff ff       	call   801b1c <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	6a 00                	push   $0x0
  801d9f:	ff 75 14             	pushl  0x14(%ebp)
  801da2:	ff 75 10             	pushl  0x10(%ebp)
  801da5:	ff 75 0c             	pushl  0xc(%ebp)
  801da8:	50                   	push   %eax
  801da9:	6a 19                	push   $0x19
  801dab:	e8 6c fd ff ff       	call   801b1c <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	50                   	push   %eax
  801dc4:	6a 1a                	push   $0x1a
  801dc6:	e8 51 fd ff ff       	call   801b1c <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	90                   	nop
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	50                   	push   %eax
  801de0:	6a 1b                	push   $0x1b
  801de2:	e8 35 fd ff ff       	call   801b1c <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 05                	push   $0x5
  801dfb:	e8 1c fd ff ff       	call   801b1c <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 06                	push   $0x6
  801e14:	e8 03 fd ff ff       	call   801b1c <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 07                	push   $0x7
  801e2d:	e8 ea fc ff ff       	call   801b1c <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_exit_env>:


void sys_exit_env(void)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 1c                	push   $0x1c
  801e46:	e8 d1 fc ff ff       	call   801b1c <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
}
  801e4e:	90                   	nop
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e57:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e5a:	8d 50 04             	lea    0x4(%eax),%edx
  801e5d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	52                   	push   %edx
  801e67:	50                   	push   %eax
  801e68:	6a 1d                	push   $0x1d
  801e6a:	e8 ad fc ff ff       	call   801b1c <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
	return result;
  801e72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e7b:	89 01                	mov    %eax,(%ecx)
  801e7d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	c9                   	leave  
  801e84:	c2 04 00             	ret    $0x4

00801e87 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	ff 75 10             	pushl  0x10(%ebp)
  801e91:	ff 75 0c             	pushl  0xc(%ebp)
  801e94:	ff 75 08             	pushl  0x8(%ebp)
  801e97:	6a 13                	push   $0x13
  801e99:	e8 7e fc ff ff       	call   801b1c <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea1:	90                   	nop
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 1e                	push   $0x1e
  801eb3:	e8 64 fc ff ff       	call   801b1c <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ec9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	50                   	push   %eax
  801ed6:	6a 1f                	push   $0x1f
  801ed8:	e8 3f fc ff ff       	call   801b1c <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee0:	90                   	nop
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <rsttst>:
void rsttst()
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 21                	push   $0x21
  801ef2:	e8 25 fc ff ff       	call   801b1c <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
	return ;
  801efa:	90                   	nop
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 04             	sub    $0x4,%esp
  801f03:	8b 45 14             	mov    0x14(%ebp),%eax
  801f06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f09:	8b 55 18             	mov    0x18(%ebp),%edx
  801f0c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f10:	52                   	push   %edx
  801f11:	50                   	push   %eax
  801f12:	ff 75 10             	pushl  0x10(%ebp)
  801f15:	ff 75 0c             	pushl  0xc(%ebp)
  801f18:	ff 75 08             	pushl  0x8(%ebp)
  801f1b:	6a 20                	push   $0x20
  801f1d:	e8 fa fb ff ff       	call   801b1c <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
	return ;
  801f25:	90                   	nop
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <chktst>:
void chktst(uint32 n)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	ff 75 08             	pushl  0x8(%ebp)
  801f36:	6a 22                	push   $0x22
  801f38:	e8 df fb ff ff       	call   801b1c <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f40:	90                   	nop
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <inctst>:

void inctst()
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 23                	push   $0x23
  801f52:	e8 c5 fb ff ff       	call   801b1c <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5a:	90                   	nop
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <gettst>:
uint32 gettst()
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 24                	push   $0x24
  801f6c:	e8 ab fb ff ff       	call   801b1c <syscall>
  801f71:	83 c4 18             	add    $0x18,%esp
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 25                	push   $0x25
  801f88:	e8 8f fb ff ff       	call   801b1c <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
  801f90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f93:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f97:	75 07                	jne    801fa0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f99:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9e:	eb 05                	jmp    801fa5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 25                	push   $0x25
  801fb9:	e8 5e fb ff ff       	call   801b1c <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
  801fc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fc4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fc8:	75 07                	jne    801fd1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fca:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcf:	eb 05                	jmp    801fd6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 25                	push   $0x25
  801fea:	e8 2d fb ff ff       	call   801b1c <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
  801ff2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ff5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ff9:	75 07                	jne    802002 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ffb:	b8 01 00 00 00       	mov    $0x1,%eax
  802000:	eb 05                	jmp    802007 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802002:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 25                	push   $0x25
  80201b:	e8 fc fa ff ff       	call   801b1c <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
  802023:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802026:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80202a:	75 07                	jne    802033 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80202c:	b8 01 00 00 00       	mov    $0x1,%eax
  802031:	eb 05                	jmp    802038 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	ff 75 08             	pushl  0x8(%ebp)
  802048:	6a 26                	push   $0x26
  80204a:	e8 cd fa ff ff       	call   801b1c <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
	return ;
  802052:	90                   	nop
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802059:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80205c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80205f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	6a 00                	push   $0x0
  802067:	53                   	push   %ebx
  802068:	51                   	push   %ecx
  802069:	52                   	push   %edx
  80206a:	50                   	push   %eax
  80206b:	6a 27                	push   $0x27
  80206d:	e8 aa fa ff ff       	call   801b1c <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
}
  802075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80207d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	52                   	push   %edx
  80208a:	50                   	push   %eax
  80208b:	6a 28                	push   $0x28
  80208d:	e8 8a fa ff ff       	call   801b1c <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80209a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80209d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	6a 00                	push   $0x0
  8020a5:	51                   	push   %ecx
  8020a6:	ff 75 10             	pushl  0x10(%ebp)
  8020a9:	52                   	push   %edx
  8020aa:	50                   	push   %eax
  8020ab:	6a 29                	push   $0x29
  8020ad:	e8 6a fa ff ff       	call   801b1c <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	ff 75 10             	pushl  0x10(%ebp)
  8020c1:	ff 75 0c             	pushl  0xc(%ebp)
  8020c4:	ff 75 08             	pushl  0x8(%ebp)
  8020c7:	6a 12                	push   $0x12
  8020c9:	e8 4e fa ff ff       	call   801b1c <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d1:	90                   	nop
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8020d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	52                   	push   %edx
  8020e4:	50                   	push   %eax
  8020e5:	6a 2a                	push   $0x2a
  8020e7:	e8 30 fa ff ff       	call   801b1c <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
	return;
  8020ef:	90                   	nop
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	50                   	push   %eax
  802101:	6a 2b                	push   $0x2b
  802103:	e8 14 fa ff ff       	call   801b1c <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	ff 75 0c             	pushl  0xc(%ebp)
  802119:	ff 75 08             	pushl  0x8(%ebp)
  80211c:	6a 2c                	push   $0x2c
  80211e:	e8 f9 f9 ff ff       	call   801b1c <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
	return;
  802126:	90                   	nop
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	ff 75 0c             	pushl  0xc(%ebp)
  802135:	ff 75 08             	pushl  0x8(%ebp)
  802138:	6a 2d                	push   $0x2d
  80213a:	e8 dd f9 ff ff       	call   801b1c <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
	return;
  802142:	90                   	nop
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	83 e8 04             	sub    $0x4,%eax
  802151:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802154:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802157:	8b 00                	mov    (%eax),%eax
  802159:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	83 e8 04             	sub    $0x4,%eax
  80216a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80216d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802170:	8b 00                	mov    (%eax),%eax
  802172:	83 e0 01             	and    $0x1,%eax
  802175:	85 c0                	test   %eax,%eax
  802177:	0f 94 c0             	sete   %al
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218c:	83 f8 02             	cmp    $0x2,%eax
  80218f:	74 2b                	je     8021bc <alloc_block+0x40>
  802191:	83 f8 02             	cmp    $0x2,%eax
  802194:	7f 07                	jg     80219d <alloc_block+0x21>
  802196:	83 f8 01             	cmp    $0x1,%eax
  802199:	74 0e                	je     8021a9 <alloc_block+0x2d>
  80219b:	eb 58                	jmp    8021f5 <alloc_block+0x79>
  80219d:	83 f8 03             	cmp    $0x3,%eax
  8021a0:	74 2d                	je     8021cf <alloc_block+0x53>
  8021a2:	83 f8 04             	cmp    $0x4,%eax
  8021a5:	74 3b                	je     8021e2 <alloc_block+0x66>
  8021a7:	eb 4c                	jmp    8021f5 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8021a9:	83 ec 0c             	sub    $0xc,%esp
  8021ac:	ff 75 08             	pushl  0x8(%ebp)
  8021af:	e8 11 03 00 00       	call   8024c5 <alloc_block_FF>
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021ba:	eb 4a                	jmp    802206 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8021bc:	83 ec 0c             	sub    $0xc,%esp
  8021bf:	ff 75 08             	pushl  0x8(%ebp)
  8021c2:	e8 c7 19 00 00       	call   803b8e <alloc_block_NF>
  8021c7:	83 c4 10             	add    $0x10,%esp
  8021ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021cd:	eb 37                	jmp    802206 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8021cf:	83 ec 0c             	sub    $0xc,%esp
  8021d2:	ff 75 08             	pushl  0x8(%ebp)
  8021d5:	e8 a7 07 00 00       	call   802981 <alloc_block_BF>
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021e0:	eb 24                	jmp    802206 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8021e2:	83 ec 0c             	sub    $0xc,%esp
  8021e5:	ff 75 08             	pushl  0x8(%ebp)
  8021e8:	e8 84 19 00 00       	call   803b71 <alloc_block_WF>
  8021ed:	83 c4 10             	add    $0x10,%esp
  8021f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021f3:	eb 11                	jmp    802206 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8021f5:	83 ec 0c             	sub    $0xc,%esp
  8021f8:	68 88 46 80 00       	push   $0x804688
  8021fd:	e8 4d e6 ff ff       	call   80084f <cprintf>
  802202:	83 c4 10             	add    $0x10,%esp
		break;
  802205:	90                   	nop
	}
	return va;
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	53                   	push   %ebx
  80220f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802212:	83 ec 0c             	sub    $0xc,%esp
  802215:	68 a8 46 80 00       	push   $0x8046a8
  80221a:	e8 30 e6 ff ff       	call   80084f <cprintf>
  80221f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802222:	83 ec 0c             	sub    $0xc,%esp
  802225:	68 d3 46 80 00       	push   $0x8046d3
  80222a:	e8 20 e6 ff ff       	call   80084f <cprintf>
  80222f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802238:	eb 37                	jmp    802271 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80223a:	83 ec 0c             	sub    $0xc,%esp
  80223d:	ff 75 f4             	pushl  -0xc(%ebp)
  802240:	e8 19 ff ff ff       	call   80215e <is_free_block>
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	0f be d8             	movsbl %al,%ebx
  80224b:	83 ec 0c             	sub    $0xc,%esp
  80224e:	ff 75 f4             	pushl  -0xc(%ebp)
  802251:	e8 ef fe ff ff       	call   802145 <get_block_size>
  802256:	83 c4 10             	add    $0x10,%esp
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	53                   	push   %ebx
  80225d:	50                   	push   %eax
  80225e:	68 eb 46 80 00       	push   $0x8046eb
  802263:	e8 e7 e5 ff ff       	call   80084f <cprintf>
  802268:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80226b:	8b 45 10             	mov    0x10(%ebp),%eax
  80226e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802275:	74 07                	je     80227e <print_blocks_list+0x73>
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	8b 00                	mov    (%eax),%eax
  80227c:	eb 05                	jmp    802283 <print_blocks_list+0x78>
  80227e:	b8 00 00 00 00       	mov    $0x0,%eax
  802283:	89 45 10             	mov    %eax,0x10(%ebp)
  802286:	8b 45 10             	mov    0x10(%ebp),%eax
  802289:	85 c0                	test   %eax,%eax
  80228b:	75 ad                	jne    80223a <print_blocks_list+0x2f>
  80228d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802291:	75 a7                	jne    80223a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802293:	83 ec 0c             	sub    $0xc,%esp
  802296:	68 a8 46 80 00       	push   $0x8046a8
  80229b:	e8 af e5 ff ff       	call   80084f <cprintf>
  8022a0:	83 c4 10             	add    $0x10,%esp

}
  8022a3:	90                   	nop
  8022a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8022af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b2:	83 e0 01             	and    $0x1,%eax
  8022b5:	85 c0                	test   %eax,%eax
  8022b7:	74 03                	je     8022bc <initialize_dynamic_allocator+0x13>
  8022b9:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8022bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022c0:	0f 84 c7 01 00 00    	je     80248d <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8022c6:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8022cd:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8022d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d6:	01 d0                	add    %edx,%eax
  8022d8:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8022dd:	0f 87 ad 01 00 00    	ja     802490 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	0f 89 a5 01 00 00    	jns    802493 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8022ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f4:	01 d0                	add    %edx,%eax
  8022f6:	83 e8 04             	sub    $0x4,%eax
  8022f9:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8022fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802305:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80230a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230d:	e9 87 00 00 00       	jmp    802399 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802316:	75 14                	jne    80232c <initialize_dynamic_allocator+0x83>
  802318:	83 ec 04             	sub    $0x4,%esp
  80231b:	68 03 47 80 00       	push   $0x804703
  802320:	6a 79                	push   $0x79
  802322:	68 21 47 80 00       	push   $0x804721
  802327:	e8 66 e2 ff ff       	call   800592 <_panic>
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	85 c0                	test   %eax,%eax
  802333:	74 10                	je     802345 <initialize_dynamic_allocator+0x9c>
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 00                	mov    (%eax),%eax
  80233a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233d:	8b 52 04             	mov    0x4(%edx),%edx
  802340:	89 50 04             	mov    %edx,0x4(%eax)
  802343:	eb 0b                	jmp    802350 <initialize_dynamic_allocator+0xa7>
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 40 04             	mov    0x4(%eax),%eax
  80234b:	a3 30 50 80 00       	mov    %eax,0x805030
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 40 04             	mov    0x4(%eax),%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	74 0f                	je     802369 <initialize_dynamic_allocator+0xc0>
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	8b 40 04             	mov    0x4(%eax),%eax
  802360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802363:	8b 12                	mov    (%edx),%edx
  802365:	89 10                	mov    %edx,(%eax)
  802367:	eb 0a                	jmp    802373 <initialize_dynamic_allocator+0xca>
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 00                	mov    (%eax),%eax
  80236e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802386:	a1 38 50 80 00       	mov    0x805038,%eax
  80238b:	48                   	dec    %eax
  80238c:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802391:	a1 34 50 80 00       	mov    0x805034,%eax
  802396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239d:	74 07                	je     8023a6 <initialize_dynamic_allocator+0xfd>
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	eb 05                	jmp    8023ab <initialize_dynamic_allocator+0x102>
  8023a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ab:	a3 34 50 80 00       	mov    %eax,0x805034
  8023b0:	a1 34 50 80 00       	mov    0x805034,%eax
  8023b5:	85 c0                	test   %eax,%eax
  8023b7:	0f 85 55 ff ff ff    	jne    802312 <initialize_dynamic_allocator+0x69>
  8023bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c1:	0f 85 4b ff ff ff    	jne    802312 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8023cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8023d6:	a1 44 50 80 00       	mov    0x805044,%eax
  8023db:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8023e0:	a1 40 50 80 00       	mov    0x805040,%eax
  8023e5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	83 c0 08             	add    $0x8,%eax
  8023f1:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	83 c0 04             	add    $0x4,%eax
  8023fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023fd:	83 ea 08             	sub    $0x8,%edx
  802400:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802402:	8b 55 0c             	mov    0xc(%ebp),%edx
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	01 d0                	add    %edx,%eax
  80240a:	83 e8 08             	sub    $0x8,%eax
  80240d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802410:	83 ea 08             	sub    $0x8,%edx
  802413:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802415:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802418:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80241e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802421:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802428:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80242c:	75 17                	jne    802445 <initialize_dynamic_allocator+0x19c>
  80242e:	83 ec 04             	sub    $0x4,%esp
  802431:	68 3c 47 80 00       	push   $0x80473c
  802436:	68 90 00 00 00       	push   $0x90
  80243b:	68 21 47 80 00       	push   $0x804721
  802440:	e8 4d e1 ff ff       	call   800592 <_panic>
  802445:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80244b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244e:	89 10                	mov    %edx,(%eax)
  802450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802453:	8b 00                	mov    (%eax),%eax
  802455:	85 c0                	test   %eax,%eax
  802457:	74 0d                	je     802466 <initialize_dynamic_allocator+0x1bd>
  802459:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80245e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802461:	89 50 04             	mov    %edx,0x4(%eax)
  802464:	eb 08                	jmp    80246e <initialize_dynamic_allocator+0x1c5>
  802466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802469:	a3 30 50 80 00       	mov    %eax,0x805030
  80246e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802471:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802480:	a1 38 50 80 00       	mov    0x805038,%eax
  802485:	40                   	inc    %eax
  802486:	a3 38 50 80 00       	mov    %eax,0x805038
  80248b:	eb 07                	jmp    802494 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80248d:	90                   	nop
  80248e:	eb 04                	jmp    802494 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802490:	90                   	nop
  802491:	eb 01                	jmp    802494 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802493:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802499:	8b 45 10             	mov    0x10(%ebp),%eax
  80249c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8024a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a8:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	83 e8 04             	sub    $0x4,%eax
  8024b0:	8b 00                	mov    (%eax),%eax
  8024b2:	83 e0 fe             	and    $0xfffffffe,%eax
  8024b5:	8d 50 f8             	lea    -0x8(%eax),%edx
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	01 c2                	add    %eax,%edx
  8024bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c0:	89 02                	mov    %eax,(%edx)
}
  8024c2:	90                   	nop
  8024c3:	5d                   	pop    %ebp
  8024c4:	c3                   	ret    

008024c5 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
  8024c8:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	83 e0 01             	and    $0x1,%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 03                	je     8024d8 <alloc_block_FF+0x13>
  8024d5:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024d8:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024dc:	77 07                	ja     8024e5 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024de:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024e5:	a1 24 50 80 00       	mov    0x805024,%eax
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	75 73                	jne    802561 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	83 c0 10             	add    $0x10,%eax
  8024f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024f7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802501:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802504:	01 d0                	add    %edx,%eax
  802506:	48                   	dec    %eax
  802507:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80250a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80250d:	ba 00 00 00 00       	mov    $0x0,%edx
  802512:	f7 75 ec             	divl   -0x14(%ebp)
  802515:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802518:	29 d0                	sub    %edx,%eax
  80251a:	c1 e8 0c             	shr    $0xc,%eax
  80251d:	83 ec 0c             	sub    $0xc,%esp
  802520:	50                   	push   %eax
  802521:	e8 c3 f0 ff ff       	call   8015e9 <sbrk>
  802526:	83 c4 10             	add    $0x10,%esp
  802529:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80252c:	83 ec 0c             	sub    $0xc,%esp
  80252f:	6a 00                	push   $0x0
  802531:	e8 b3 f0 ff ff       	call   8015e9 <sbrk>
  802536:	83 c4 10             	add    $0x10,%esp
  802539:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80253c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80253f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802542:	83 ec 08             	sub    $0x8,%esp
  802545:	50                   	push   %eax
  802546:	ff 75 e4             	pushl  -0x1c(%ebp)
  802549:	e8 5b fd ff ff       	call   8022a9 <initialize_dynamic_allocator>
  80254e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802551:	83 ec 0c             	sub    $0xc,%esp
  802554:	68 5f 47 80 00       	push   $0x80475f
  802559:	e8 f1 e2 ff ff       	call   80084f <cprintf>
  80255e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802561:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802565:	75 0a                	jne    802571 <alloc_block_FF+0xac>
	        return NULL;
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
  80256c:	e9 0e 04 00 00       	jmp    80297f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802578:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80257d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802580:	e9 f3 02 00 00       	jmp    802878 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80258b:	83 ec 0c             	sub    $0xc,%esp
  80258e:	ff 75 bc             	pushl  -0x44(%ebp)
  802591:	e8 af fb ff ff       	call   802145 <get_block_size>
  802596:	83 c4 10             	add    $0x10,%esp
  802599:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	83 c0 08             	add    $0x8,%eax
  8025a2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8025a5:	0f 87 c5 02 00 00    	ja     802870 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	83 c0 18             	add    $0x18,%eax
  8025b1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8025b4:	0f 87 19 02 00 00    	ja     8027d3 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8025ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8025bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8025c0:	83 e8 08             	sub    $0x8,%eax
  8025c3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	8d 50 08             	lea    0x8(%eax),%edx
  8025cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025cf:	01 d0                	add    %edx,%eax
  8025d1:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	83 c0 08             	add    $0x8,%eax
  8025da:	83 ec 04             	sub    $0x4,%esp
  8025dd:	6a 01                	push   $0x1
  8025df:	50                   	push   %eax
  8025e0:	ff 75 bc             	pushl  -0x44(%ebp)
  8025e3:	e8 ae fe ff ff       	call   802496 <set_block_data>
  8025e8:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 04             	mov    0x4(%eax),%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	75 68                	jne    80265d <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025f5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025f9:	75 17                	jne    802612 <alloc_block_FF+0x14d>
  8025fb:	83 ec 04             	sub    $0x4,%esp
  8025fe:	68 3c 47 80 00       	push   $0x80473c
  802603:	68 d7 00 00 00       	push   $0xd7
  802608:	68 21 47 80 00       	push   $0x804721
  80260d:	e8 80 df ff ff       	call   800592 <_panic>
  802612:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802618:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80261b:	89 10                	mov    %edx,(%eax)
  80261d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802620:	8b 00                	mov    (%eax),%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	74 0d                	je     802633 <alloc_block_FF+0x16e>
  802626:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80262b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80262e:	89 50 04             	mov    %edx,0x4(%eax)
  802631:	eb 08                	jmp    80263b <alloc_block_FF+0x176>
  802633:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802636:	a3 30 50 80 00       	mov    %eax,0x805030
  80263b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80263e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802643:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802646:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264d:	a1 38 50 80 00       	mov    0x805038,%eax
  802652:	40                   	inc    %eax
  802653:	a3 38 50 80 00       	mov    %eax,0x805038
  802658:	e9 dc 00 00 00       	jmp    802739 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 00                	mov    (%eax),%eax
  802662:	85 c0                	test   %eax,%eax
  802664:	75 65                	jne    8026cb <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802666:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80266a:	75 17                	jne    802683 <alloc_block_FF+0x1be>
  80266c:	83 ec 04             	sub    $0x4,%esp
  80266f:	68 70 47 80 00       	push   $0x804770
  802674:	68 db 00 00 00       	push   $0xdb
  802679:	68 21 47 80 00       	push   $0x804721
  80267e:	e8 0f df ff ff       	call   800592 <_panic>
  802683:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802689:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80268c:	89 50 04             	mov    %edx,0x4(%eax)
  80268f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802692:	8b 40 04             	mov    0x4(%eax),%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	74 0c                	je     8026a5 <alloc_block_FF+0x1e0>
  802699:	a1 30 50 80 00       	mov    0x805030,%eax
  80269e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026a1:	89 10                	mov    %edx,(%eax)
  8026a3:	eb 08                	jmp    8026ad <alloc_block_FF+0x1e8>
  8026a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026a8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8026b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026be:	a1 38 50 80 00       	mov    0x805038,%eax
  8026c3:	40                   	inc    %eax
  8026c4:	a3 38 50 80 00       	mov    %eax,0x805038
  8026c9:	eb 6e                	jmp    802739 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8026cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cf:	74 06                	je     8026d7 <alloc_block_FF+0x212>
  8026d1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026d5:	75 17                	jne    8026ee <alloc_block_FF+0x229>
  8026d7:	83 ec 04             	sub    $0x4,%esp
  8026da:	68 94 47 80 00       	push   $0x804794
  8026df:	68 df 00 00 00       	push   $0xdf
  8026e4:	68 21 47 80 00       	push   $0x804721
  8026e9:	e8 a4 de ff ff       	call   800592 <_panic>
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 10                	mov    (%eax),%edx
  8026f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026f6:	89 10                	mov    %edx,(%eax)
  8026f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026fb:	8b 00                	mov    (%eax),%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	74 0b                	je     80270c <alloc_block_FF+0x247>
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 00                	mov    (%eax),%eax
  802706:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802709:	89 50 04             	mov    %edx,0x4(%eax)
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802712:	89 10                	mov    %edx,(%eax)
  802714:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271a:	89 50 04             	mov    %edx,0x4(%eax)
  80271d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802720:	8b 00                	mov    (%eax),%eax
  802722:	85 c0                	test   %eax,%eax
  802724:	75 08                	jne    80272e <alloc_block_FF+0x269>
  802726:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802729:	a3 30 50 80 00       	mov    %eax,0x805030
  80272e:	a1 38 50 80 00       	mov    0x805038,%eax
  802733:	40                   	inc    %eax
  802734:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273d:	75 17                	jne    802756 <alloc_block_FF+0x291>
  80273f:	83 ec 04             	sub    $0x4,%esp
  802742:	68 03 47 80 00       	push   $0x804703
  802747:	68 e1 00 00 00       	push   $0xe1
  80274c:	68 21 47 80 00       	push   $0x804721
  802751:	e8 3c de ff ff       	call   800592 <_panic>
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	85 c0                	test   %eax,%eax
  80275d:	74 10                	je     80276f <alloc_block_FF+0x2aa>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802767:	8b 52 04             	mov    0x4(%edx),%edx
  80276a:	89 50 04             	mov    %edx,0x4(%eax)
  80276d:	eb 0b                	jmp    80277a <alloc_block_FF+0x2b5>
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 40 04             	mov    0x4(%eax),%eax
  802775:	a3 30 50 80 00       	mov    %eax,0x805030
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	8b 40 04             	mov    0x4(%eax),%eax
  802780:	85 c0                	test   %eax,%eax
  802782:	74 0f                	je     802793 <alloc_block_FF+0x2ce>
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278d:	8b 12                	mov    (%edx),%edx
  80278f:	89 10                	mov    %edx,(%eax)
  802791:	eb 0a                	jmp    80279d <alloc_block_FF+0x2d8>
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b0:	a1 38 50 80 00       	mov    0x805038,%eax
  8027b5:	48                   	dec    %eax
  8027b6:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8027bb:	83 ec 04             	sub    $0x4,%esp
  8027be:	6a 00                	push   $0x0
  8027c0:	ff 75 b4             	pushl  -0x4c(%ebp)
  8027c3:	ff 75 b0             	pushl  -0x50(%ebp)
  8027c6:	e8 cb fc ff ff       	call   802496 <set_block_data>
  8027cb:	83 c4 10             	add    $0x10,%esp
  8027ce:	e9 95 00 00 00       	jmp    802868 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8027d3:	83 ec 04             	sub    $0x4,%esp
  8027d6:	6a 01                	push   $0x1
  8027d8:	ff 75 b8             	pushl  -0x48(%ebp)
  8027db:	ff 75 bc             	pushl  -0x44(%ebp)
  8027de:	e8 b3 fc ff ff       	call   802496 <set_block_data>
  8027e3:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8027e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ea:	75 17                	jne    802803 <alloc_block_FF+0x33e>
  8027ec:	83 ec 04             	sub    $0x4,%esp
  8027ef:	68 03 47 80 00       	push   $0x804703
  8027f4:	68 e8 00 00 00       	push   $0xe8
  8027f9:	68 21 47 80 00       	push   $0x804721
  8027fe:	e8 8f dd ff ff       	call   800592 <_panic>
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	85 c0                	test   %eax,%eax
  80280a:	74 10                	je     80281c <alloc_block_FF+0x357>
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802814:	8b 52 04             	mov    0x4(%edx),%edx
  802817:	89 50 04             	mov    %edx,0x4(%eax)
  80281a:	eb 0b                	jmp    802827 <alloc_block_FF+0x362>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 40 04             	mov    0x4(%eax),%eax
  802822:	a3 30 50 80 00       	mov    %eax,0x805030
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 04             	mov    0x4(%eax),%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	74 0f                	je     802840 <alloc_block_FF+0x37b>
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 40 04             	mov    0x4(%eax),%eax
  802837:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283a:	8b 12                	mov    (%edx),%edx
  80283c:	89 10                	mov    %edx,(%eax)
  80283e:	eb 0a                	jmp    80284a <alloc_block_FF+0x385>
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285d:	a1 38 50 80 00       	mov    0x805038,%eax
  802862:	48                   	dec    %eax
  802863:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802868:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80286b:	e9 0f 01 00 00       	jmp    80297f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802870:	a1 34 50 80 00       	mov    0x805034,%eax
  802875:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287c:	74 07                	je     802885 <alloc_block_FF+0x3c0>
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 00                	mov    (%eax),%eax
  802883:	eb 05                	jmp    80288a <alloc_block_FF+0x3c5>
  802885:	b8 00 00 00 00       	mov    $0x0,%eax
  80288a:	a3 34 50 80 00       	mov    %eax,0x805034
  80288f:	a1 34 50 80 00       	mov    0x805034,%eax
  802894:	85 c0                	test   %eax,%eax
  802896:	0f 85 e9 fc ff ff    	jne    802585 <alloc_block_FF+0xc0>
  80289c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a0:	0f 85 df fc ff ff    	jne    802585 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	83 c0 08             	add    $0x8,%eax
  8028ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8028af:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8028b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028bc:	01 d0                	add    %edx,%eax
  8028be:	48                   	dec    %eax
  8028bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ca:	f7 75 d8             	divl   -0x28(%ebp)
  8028cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028d0:	29 d0                	sub    %edx,%eax
  8028d2:	c1 e8 0c             	shr    $0xc,%eax
  8028d5:	83 ec 0c             	sub    $0xc,%esp
  8028d8:	50                   	push   %eax
  8028d9:	e8 0b ed ff ff       	call   8015e9 <sbrk>
  8028de:	83 c4 10             	add    $0x10,%esp
  8028e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8028e4:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8028e8:	75 0a                	jne    8028f4 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8028ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ef:	e9 8b 00 00 00       	jmp    80297f <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8028f4:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802901:	01 d0                	add    %edx,%eax
  802903:	48                   	dec    %eax
  802904:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802907:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80290a:	ba 00 00 00 00       	mov    $0x0,%edx
  80290f:	f7 75 cc             	divl   -0x34(%ebp)
  802912:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802915:	29 d0                	sub    %edx,%eax
  802917:	8d 50 fc             	lea    -0x4(%eax),%edx
  80291a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80291d:	01 d0                	add    %edx,%eax
  80291f:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802924:	a1 40 50 80 00       	mov    0x805040,%eax
  802929:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80292f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802936:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802939:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80293c:	01 d0                	add    %edx,%eax
  80293e:	48                   	dec    %eax
  80293f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802942:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802945:	ba 00 00 00 00       	mov    $0x0,%edx
  80294a:	f7 75 c4             	divl   -0x3c(%ebp)
  80294d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802950:	29 d0                	sub    %edx,%eax
  802952:	83 ec 04             	sub    $0x4,%esp
  802955:	6a 01                	push   $0x1
  802957:	50                   	push   %eax
  802958:	ff 75 d0             	pushl  -0x30(%ebp)
  80295b:	e8 36 fb ff ff       	call   802496 <set_block_data>
  802960:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802963:	83 ec 0c             	sub    $0xc,%esp
  802966:	ff 75 d0             	pushl  -0x30(%ebp)
  802969:	e8 f8 09 00 00       	call   803366 <free_block>
  80296e:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802971:	83 ec 0c             	sub    $0xc,%esp
  802974:	ff 75 08             	pushl  0x8(%ebp)
  802977:	e8 49 fb ff ff       	call   8024c5 <alloc_block_FF>
  80297c:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80297f:	c9                   	leave  
  802980:	c3                   	ret    

00802981 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802981:	55                   	push   %ebp
  802982:	89 e5                	mov    %esp,%ebp
  802984:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	83 e0 01             	and    $0x1,%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	74 03                	je     802994 <alloc_block_BF+0x13>
  802991:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802994:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802998:	77 07                	ja     8029a1 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80299a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8029a1:	a1 24 50 80 00       	mov    0x805024,%eax
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	75 73                	jne    802a1d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	83 c0 10             	add    $0x10,%eax
  8029b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8029b3:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8029ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c0:	01 d0                	add    %edx,%eax
  8029c2:	48                   	dec    %eax
  8029c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8029c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ce:	f7 75 e0             	divl   -0x20(%ebp)
  8029d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029d4:	29 d0                	sub    %edx,%eax
  8029d6:	c1 e8 0c             	shr    $0xc,%eax
  8029d9:	83 ec 0c             	sub    $0xc,%esp
  8029dc:	50                   	push   %eax
  8029dd:	e8 07 ec ff ff       	call   8015e9 <sbrk>
  8029e2:	83 c4 10             	add    $0x10,%esp
  8029e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029e8:	83 ec 0c             	sub    $0xc,%esp
  8029eb:	6a 00                	push   $0x0
  8029ed:	e8 f7 eb ff ff       	call   8015e9 <sbrk>
  8029f2:	83 c4 10             	add    $0x10,%esp
  8029f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029fb:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029fe:	83 ec 08             	sub    $0x8,%esp
  802a01:	50                   	push   %eax
  802a02:	ff 75 d8             	pushl  -0x28(%ebp)
  802a05:	e8 9f f8 ff ff       	call   8022a9 <initialize_dynamic_allocator>
  802a0a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802a0d:	83 ec 0c             	sub    $0xc,%esp
  802a10:	68 5f 47 80 00       	push   $0x80475f
  802a15:	e8 35 de ff ff       	call   80084f <cprintf>
  802a1a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802a24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802a2b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802a32:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802a39:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a41:	e9 1d 01 00 00       	jmp    802b63 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802a4c:	83 ec 0c             	sub    $0xc,%esp
  802a4f:	ff 75 a8             	pushl  -0x58(%ebp)
  802a52:	e8 ee f6 ff ff       	call   802145 <get_block_size>
  802a57:	83 c4 10             	add    $0x10,%esp
  802a5a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	83 c0 08             	add    $0x8,%eax
  802a63:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a66:	0f 87 ef 00 00 00    	ja     802b5b <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6f:	83 c0 18             	add    $0x18,%eax
  802a72:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a75:	77 1d                	ja     802a94 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a7d:	0f 86 d8 00 00 00    	jbe    802b5b <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a83:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a89:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a8f:	e9 c7 00 00 00       	jmp    802b5b <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	83 c0 08             	add    $0x8,%eax
  802a9a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a9d:	0f 85 9d 00 00 00    	jne    802b40 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802aa3:	83 ec 04             	sub    $0x4,%esp
  802aa6:	6a 01                	push   $0x1
  802aa8:	ff 75 a4             	pushl  -0x5c(%ebp)
  802aab:	ff 75 a8             	pushl  -0x58(%ebp)
  802aae:	e8 e3 f9 ff ff       	call   802496 <set_block_data>
  802ab3:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802ab6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aba:	75 17                	jne    802ad3 <alloc_block_BF+0x152>
  802abc:	83 ec 04             	sub    $0x4,%esp
  802abf:	68 03 47 80 00       	push   $0x804703
  802ac4:	68 2c 01 00 00       	push   $0x12c
  802ac9:	68 21 47 80 00       	push   $0x804721
  802ace:	e8 bf da ff ff       	call   800592 <_panic>
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	8b 00                	mov    (%eax),%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	74 10                	je     802aec <alloc_block_BF+0x16b>
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae4:	8b 52 04             	mov    0x4(%edx),%edx
  802ae7:	89 50 04             	mov    %edx,0x4(%eax)
  802aea:	eb 0b                	jmp    802af7 <alloc_block_BF+0x176>
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 40 04             	mov    0x4(%eax),%eax
  802af2:	a3 30 50 80 00       	mov    %eax,0x805030
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	8b 40 04             	mov    0x4(%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 0f                	je     802b10 <alloc_block_BF+0x18f>
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b0a:	8b 12                	mov    (%edx),%edx
  802b0c:	89 10                	mov    %edx,(%eax)
  802b0e:	eb 0a                	jmp    802b1a <alloc_block_BF+0x199>
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2d:	a1 38 50 80 00       	mov    0x805038,%eax
  802b32:	48                   	dec    %eax
  802b33:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802b38:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b3b:	e9 01 04 00 00       	jmp    802f41 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b43:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b46:	76 13                	jbe    802b5b <alloc_block_BF+0x1da>
					{
						internal = 1;
  802b48:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802b4f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802b55:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b58:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b5b:	a1 34 50 80 00       	mov    0x805034,%eax
  802b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b67:	74 07                	je     802b70 <alloc_block_BF+0x1ef>
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	eb 05                	jmp    802b75 <alloc_block_BF+0x1f4>
  802b70:	b8 00 00 00 00       	mov    $0x0,%eax
  802b75:	a3 34 50 80 00       	mov    %eax,0x805034
  802b7a:	a1 34 50 80 00       	mov    0x805034,%eax
  802b7f:	85 c0                	test   %eax,%eax
  802b81:	0f 85 bf fe ff ff    	jne    802a46 <alloc_block_BF+0xc5>
  802b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8b:	0f 85 b5 fe ff ff    	jne    802a46 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b95:	0f 84 26 02 00 00    	je     802dc1 <alloc_block_BF+0x440>
  802b9b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b9f:	0f 85 1c 02 00 00    	jne    802dc1 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba8:	2b 45 08             	sub    0x8(%ebp),%eax
  802bab:	83 e8 08             	sub    $0x8,%eax
  802bae:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	8d 50 08             	lea    0x8(%eax),%edx
  802bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bba:	01 d0                	add    %edx,%eax
  802bbc:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	83 c0 08             	add    $0x8,%eax
  802bc5:	83 ec 04             	sub    $0x4,%esp
  802bc8:	6a 01                	push   $0x1
  802bca:	50                   	push   %eax
  802bcb:	ff 75 f0             	pushl  -0x10(%ebp)
  802bce:	e8 c3 f8 ff ff       	call   802496 <set_block_data>
  802bd3:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	8b 40 04             	mov    0x4(%eax),%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	75 68                	jne    802c48 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802be0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802be4:	75 17                	jne    802bfd <alloc_block_BF+0x27c>
  802be6:	83 ec 04             	sub    $0x4,%esp
  802be9:	68 3c 47 80 00       	push   $0x80473c
  802bee:	68 45 01 00 00       	push   $0x145
  802bf3:	68 21 47 80 00       	push   $0x804721
  802bf8:	e8 95 d9 ff ff       	call   800592 <_panic>
  802bfd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802c03:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c06:	89 10                	mov    %edx,(%eax)
  802c08:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c0b:	8b 00                	mov    (%eax),%eax
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	74 0d                	je     802c1e <alloc_block_BF+0x29d>
  802c11:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c16:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c19:	89 50 04             	mov    %edx,0x4(%eax)
  802c1c:	eb 08                	jmp    802c26 <alloc_block_BF+0x2a5>
  802c1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c21:	a3 30 50 80 00       	mov    %eax,0x805030
  802c26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c29:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c38:	a1 38 50 80 00       	mov    0x805038,%eax
  802c3d:	40                   	inc    %eax
  802c3e:	a3 38 50 80 00       	mov    %eax,0x805038
  802c43:	e9 dc 00 00 00       	jmp    802d24 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	75 65                	jne    802cb6 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c51:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c55:	75 17                	jne    802c6e <alloc_block_BF+0x2ed>
  802c57:	83 ec 04             	sub    $0x4,%esp
  802c5a:	68 70 47 80 00       	push   $0x804770
  802c5f:	68 4a 01 00 00       	push   $0x14a
  802c64:	68 21 47 80 00       	push   $0x804721
  802c69:	e8 24 d9 ff ff       	call   800592 <_panic>
  802c6e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c77:	89 50 04             	mov    %edx,0x4(%eax)
  802c7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c7d:	8b 40 04             	mov    0x4(%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 0c                	je     802c90 <alloc_block_BF+0x30f>
  802c84:	a1 30 50 80 00       	mov    0x805030,%eax
  802c89:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c8c:	89 10                	mov    %edx,(%eax)
  802c8e:	eb 08                	jmp    802c98 <alloc_block_BF+0x317>
  802c90:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c93:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c9b:	a3 30 50 80 00       	mov    %eax,0x805030
  802ca0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca9:	a1 38 50 80 00       	mov    0x805038,%eax
  802cae:	40                   	inc    %eax
  802caf:	a3 38 50 80 00       	mov    %eax,0x805038
  802cb4:	eb 6e                	jmp    802d24 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802cb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cba:	74 06                	je     802cc2 <alloc_block_BF+0x341>
  802cbc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802cc0:	75 17                	jne    802cd9 <alloc_block_BF+0x358>
  802cc2:	83 ec 04             	sub    $0x4,%esp
  802cc5:	68 94 47 80 00       	push   $0x804794
  802cca:	68 4f 01 00 00       	push   $0x14f
  802ccf:	68 21 47 80 00       	push   $0x804721
  802cd4:	e8 b9 d8 ff ff       	call   800592 <_panic>
  802cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdc:	8b 10                	mov    (%eax),%edx
  802cde:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ce1:	89 10                	mov    %edx,(%eax)
  802ce3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ce6:	8b 00                	mov    (%eax),%eax
  802ce8:	85 c0                	test   %eax,%eax
  802cea:	74 0b                	je     802cf7 <alloc_block_BF+0x376>
  802cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cf4:	89 50 04             	mov    %edx,0x4(%eax)
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cfd:	89 10                	mov    %edx,(%eax)
  802cff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d05:	89 50 04             	mov    %edx,0x4(%eax)
  802d08:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	85 c0                	test   %eax,%eax
  802d0f:	75 08                	jne    802d19 <alloc_block_BF+0x398>
  802d11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d14:	a3 30 50 80 00       	mov    %eax,0x805030
  802d19:	a1 38 50 80 00       	mov    0x805038,%eax
  802d1e:	40                   	inc    %eax
  802d1f:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802d24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d28:	75 17                	jne    802d41 <alloc_block_BF+0x3c0>
  802d2a:	83 ec 04             	sub    $0x4,%esp
  802d2d:	68 03 47 80 00       	push   $0x804703
  802d32:	68 51 01 00 00       	push   $0x151
  802d37:	68 21 47 80 00       	push   $0x804721
  802d3c:	e8 51 d8 ff ff       	call   800592 <_panic>
  802d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	85 c0                	test   %eax,%eax
  802d48:	74 10                	je     802d5a <alloc_block_BF+0x3d9>
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d52:	8b 52 04             	mov    0x4(%edx),%edx
  802d55:	89 50 04             	mov    %edx,0x4(%eax)
  802d58:	eb 0b                	jmp    802d65 <alloc_block_BF+0x3e4>
  802d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5d:	8b 40 04             	mov    0x4(%eax),%eax
  802d60:	a3 30 50 80 00       	mov    %eax,0x805030
  802d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d68:	8b 40 04             	mov    0x4(%eax),%eax
  802d6b:	85 c0                	test   %eax,%eax
  802d6d:	74 0f                	je     802d7e <alloc_block_BF+0x3fd>
  802d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d72:	8b 40 04             	mov    0x4(%eax),%eax
  802d75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d78:	8b 12                	mov    (%edx),%edx
  802d7a:	89 10                	mov    %edx,(%eax)
  802d7c:	eb 0a                	jmp    802d88 <alloc_block_BF+0x407>
  802d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d81:	8b 00                	mov    (%eax),%eax
  802d83:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9b:	a1 38 50 80 00       	mov    0x805038,%eax
  802da0:	48                   	dec    %eax
  802da1:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802da6:	83 ec 04             	sub    $0x4,%esp
  802da9:	6a 00                	push   $0x0
  802dab:	ff 75 d0             	pushl  -0x30(%ebp)
  802dae:	ff 75 cc             	pushl  -0x34(%ebp)
  802db1:	e8 e0 f6 ff ff       	call   802496 <set_block_data>
  802db6:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbc:	e9 80 01 00 00       	jmp    802f41 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802dc1:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802dc5:	0f 85 9d 00 00 00    	jne    802e68 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802dcb:	83 ec 04             	sub    $0x4,%esp
  802dce:	6a 01                	push   $0x1
  802dd0:	ff 75 ec             	pushl  -0x14(%ebp)
  802dd3:	ff 75 f0             	pushl  -0x10(%ebp)
  802dd6:	e8 bb f6 ff ff       	call   802496 <set_block_data>
  802ddb:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802dde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de2:	75 17                	jne    802dfb <alloc_block_BF+0x47a>
  802de4:	83 ec 04             	sub    $0x4,%esp
  802de7:	68 03 47 80 00       	push   $0x804703
  802dec:	68 58 01 00 00       	push   $0x158
  802df1:	68 21 47 80 00       	push   $0x804721
  802df6:	e8 97 d7 ff ff       	call   800592 <_panic>
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 10                	je     802e14 <alloc_block_BF+0x493>
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	8b 00                	mov    (%eax),%eax
  802e09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e0c:	8b 52 04             	mov    0x4(%edx),%edx
  802e0f:	89 50 04             	mov    %edx,0x4(%eax)
  802e12:	eb 0b                	jmp    802e1f <alloc_block_BF+0x49e>
  802e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e22:	8b 40 04             	mov    0x4(%eax),%eax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	74 0f                	je     802e38 <alloc_block_BF+0x4b7>
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	8b 40 04             	mov    0x4(%eax),%eax
  802e2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e32:	8b 12                	mov    (%edx),%edx
  802e34:	89 10                	mov    %edx,(%eax)
  802e36:	eb 0a                	jmp    802e42 <alloc_block_BF+0x4c1>
  802e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e55:	a1 38 50 80 00       	mov    0x805038,%eax
  802e5a:	48                   	dec    %eax
  802e5b:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e63:	e9 d9 00 00 00       	jmp    802f41 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	83 c0 08             	add    $0x8,%eax
  802e6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e71:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e78:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e7b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e7e:	01 d0                	add    %edx,%eax
  802e80:	48                   	dec    %eax
  802e81:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e84:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e87:	ba 00 00 00 00       	mov    $0x0,%edx
  802e8c:	f7 75 c4             	divl   -0x3c(%ebp)
  802e8f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e92:	29 d0                	sub    %edx,%eax
  802e94:	c1 e8 0c             	shr    $0xc,%eax
  802e97:	83 ec 0c             	sub    $0xc,%esp
  802e9a:	50                   	push   %eax
  802e9b:	e8 49 e7 ff ff       	call   8015e9 <sbrk>
  802ea0:	83 c4 10             	add    $0x10,%esp
  802ea3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ea6:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802eaa:	75 0a                	jne    802eb6 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802eac:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb1:	e9 8b 00 00 00       	jmp    802f41 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802eb6:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802ebd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ec0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ec3:	01 d0                	add    %edx,%eax
  802ec5:	48                   	dec    %eax
  802ec6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ec9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ecc:	ba 00 00 00 00       	mov    $0x0,%edx
  802ed1:	f7 75 b8             	divl   -0x48(%ebp)
  802ed4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ed7:	29 d0                	sub    %edx,%eax
  802ed9:	8d 50 fc             	lea    -0x4(%eax),%edx
  802edc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802edf:	01 d0                	add    %edx,%eax
  802ee1:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ee6:	a1 40 50 80 00       	mov    0x805040,%eax
  802eeb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ef1:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ef8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802efb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802efe:	01 d0                	add    %edx,%eax
  802f00:	48                   	dec    %eax
  802f01:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802f04:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f07:	ba 00 00 00 00       	mov    $0x0,%edx
  802f0c:	f7 75 b0             	divl   -0x50(%ebp)
  802f0f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f12:	29 d0                	sub    %edx,%eax
  802f14:	83 ec 04             	sub    $0x4,%esp
  802f17:	6a 01                	push   $0x1
  802f19:	50                   	push   %eax
  802f1a:	ff 75 bc             	pushl  -0x44(%ebp)
  802f1d:	e8 74 f5 ff ff       	call   802496 <set_block_data>
  802f22:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802f25:	83 ec 0c             	sub    $0xc,%esp
  802f28:	ff 75 bc             	pushl  -0x44(%ebp)
  802f2b:	e8 36 04 00 00       	call   803366 <free_block>
  802f30:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802f33:	83 ec 0c             	sub    $0xc,%esp
  802f36:	ff 75 08             	pushl  0x8(%ebp)
  802f39:	e8 43 fa ff ff       	call   802981 <alloc_block_BF>
  802f3e:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f41:	c9                   	leave  
  802f42:	c3                   	ret    

00802f43 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f43:	55                   	push   %ebp
  802f44:	89 e5                	mov    %esp,%ebp
  802f46:	53                   	push   %ebx
  802f47:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5c:	74 1e                	je     802f7c <merging+0x39>
  802f5e:	ff 75 08             	pushl  0x8(%ebp)
  802f61:	e8 df f1 ff ff       	call   802145 <get_block_size>
  802f66:	83 c4 04             	add    $0x4,%esp
  802f69:	89 c2                	mov    %eax,%edx
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	01 d0                	add    %edx,%eax
  802f70:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f73:	75 07                	jne    802f7c <merging+0x39>
		prev_is_free = 1;
  802f75:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f80:	74 1e                	je     802fa0 <merging+0x5d>
  802f82:	ff 75 10             	pushl  0x10(%ebp)
  802f85:	e8 bb f1 ff ff       	call   802145 <get_block_size>
  802f8a:	83 c4 04             	add    $0x4,%esp
  802f8d:	89 c2                	mov    %eax,%edx
  802f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  802f92:	01 d0                	add    %edx,%eax
  802f94:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f97:	75 07                	jne    802fa0 <merging+0x5d>
		next_is_free = 1;
  802f99:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802fa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa4:	0f 84 cc 00 00 00    	je     803076 <merging+0x133>
  802faa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fae:	0f 84 c2 00 00 00    	je     803076 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802fb4:	ff 75 08             	pushl  0x8(%ebp)
  802fb7:	e8 89 f1 ff ff       	call   802145 <get_block_size>
  802fbc:	83 c4 04             	add    $0x4,%esp
  802fbf:	89 c3                	mov    %eax,%ebx
  802fc1:	ff 75 10             	pushl  0x10(%ebp)
  802fc4:	e8 7c f1 ff ff       	call   802145 <get_block_size>
  802fc9:	83 c4 04             	add    $0x4,%esp
  802fcc:	01 c3                	add    %eax,%ebx
  802fce:	ff 75 0c             	pushl  0xc(%ebp)
  802fd1:	e8 6f f1 ff ff       	call   802145 <get_block_size>
  802fd6:	83 c4 04             	add    $0x4,%esp
  802fd9:	01 d8                	add    %ebx,%eax
  802fdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fde:	6a 00                	push   $0x0
  802fe0:	ff 75 ec             	pushl  -0x14(%ebp)
  802fe3:	ff 75 08             	pushl  0x8(%ebp)
  802fe6:	e8 ab f4 ff ff       	call   802496 <set_block_data>
  802feb:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802fee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ff2:	75 17                	jne    80300b <merging+0xc8>
  802ff4:	83 ec 04             	sub    $0x4,%esp
  802ff7:	68 03 47 80 00       	push   $0x804703
  802ffc:	68 7d 01 00 00       	push   $0x17d
  803001:	68 21 47 80 00       	push   $0x804721
  803006:	e8 87 d5 ff ff       	call   800592 <_panic>
  80300b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	74 10                	je     803024 <merging+0xe1>
  803014:	8b 45 0c             	mov    0xc(%ebp),%eax
  803017:	8b 00                	mov    (%eax),%eax
  803019:	8b 55 0c             	mov    0xc(%ebp),%edx
  80301c:	8b 52 04             	mov    0x4(%edx),%edx
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	eb 0b                	jmp    80302f <merging+0xec>
  803024:	8b 45 0c             	mov    0xc(%ebp),%eax
  803027:	8b 40 04             	mov    0x4(%eax),%eax
  80302a:	a3 30 50 80 00       	mov    %eax,0x805030
  80302f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803032:	8b 40 04             	mov    0x4(%eax),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	74 0f                	je     803048 <merging+0x105>
  803039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303c:	8b 40 04             	mov    0x4(%eax),%eax
  80303f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803042:	8b 12                	mov    (%edx),%edx
  803044:	89 10                	mov    %edx,(%eax)
  803046:	eb 0a                	jmp    803052 <merging+0x10f>
  803048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803052:	8b 45 0c             	mov    0xc(%ebp),%eax
  803055:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803065:	a1 38 50 80 00       	mov    0x805038,%eax
  80306a:	48                   	dec    %eax
  80306b:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803070:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803071:	e9 ea 02 00 00       	jmp    803360 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803076:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307a:	74 3b                	je     8030b7 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80307c:	83 ec 0c             	sub    $0xc,%esp
  80307f:	ff 75 08             	pushl  0x8(%ebp)
  803082:	e8 be f0 ff ff       	call   802145 <get_block_size>
  803087:	83 c4 10             	add    $0x10,%esp
  80308a:	89 c3                	mov    %eax,%ebx
  80308c:	83 ec 0c             	sub    $0xc,%esp
  80308f:	ff 75 10             	pushl  0x10(%ebp)
  803092:	e8 ae f0 ff ff       	call   802145 <get_block_size>
  803097:	83 c4 10             	add    $0x10,%esp
  80309a:	01 d8                	add    %ebx,%eax
  80309c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80309f:	83 ec 04             	sub    $0x4,%esp
  8030a2:	6a 00                	push   $0x0
  8030a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8030a7:	ff 75 08             	pushl  0x8(%ebp)
  8030aa:	e8 e7 f3 ff ff       	call   802496 <set_block_data>
  8030af:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030b2:	e9 a9 02 00 00       	jmp    803360 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8030b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030bb:	0f 84 2d 01 00 00    	je     8031ee <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8030c1:	83 ec 0c             	sub    $0xc,%esp
  8030c4:	ff 75 10             	pushl  0x10(%ebp)
  8030c7:	e8 79 f0 ff ff       	call   802145 <get_block_size>
  8030cc:	83 c4 10             	add    $0x10,%esp
  8030cf:	89 c3                	mov    %eax,%ebx
  8030d1:	83 ec 0c             	sub    $0xc,%esp
  8030d4:	ff 75 0c             	pushl  0xc(%ebp)
  8030d7:	e8 69 f0 ff ff       	call   802145 <get_block_size>
  8030dc:	83 c4 10             	add    $0x10,%esp
  8030df:	01 d8                	add    %ebx,%eax
  8030e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8030e4:	83 ec 04             	sub    $0x4,%esp
  8030e7:	6a 00                	push   $0x0
  8030e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030ec:	ff 75 10             	pushl  0x10(%ebp)
  8030ef:	e8 a2 f3 ff ff       	call   802496 <set_block_data>
  8030f4:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8030fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803101:	74 06                	je     803109 <merging+0x1c6>
  803103:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803107:	75 17                	jne    803120 <merging+0x1dd>
  803109:	83 ec 04             	sub    $0x4,%esp
  80310c:	68 c8 47 80 00       	push   $0x8047c8
  803111:	68 8d 01 00 00       	push   $0x18d
  803116:	68 21 47 80 00       	push   $0x804721
  80311b:	e8 72 d4 ff ff       	call   800592 <_panic>
  803120:	8b 45 0c             	mov    0xc(%ebp),%eax
  803123:	8b 50 04             	mov    0x4(%eax),%edx
  803126:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803129:	89 50 04             	mov    %edx,0x4(%eax)
  80312c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80312f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803132:	89 10                	mov    %edx,(%eax)
  803134:	8b 45 0c             	mov    0xc(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 0d                	je     80314b <merging+0x208>
  80313e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803141:	8b 40 04             	mov    0x4(%eax),%eax
  803144:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803147:	89 10                	mov    %edx,(%eax)
  803149:	eb 08                	jmp    803153 <merging+0x210>
  80314b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80314e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803153:	8b 45 0c             	mov    0xc(%ebp),%eax
  803156:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803159:	89 50 04             	mov    %edx,0x4(%eax)
  80315c:	a1 38 50 80 00       	mov    0x805038,%eax
  803161:	40                   	inc    %eax
  803162:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803167:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80316b:	75 17                	jne    803184 <merging+0x241>
  80316d:	83 ec 04             	sub    $0x4,%esp
  803170:	68 03 47 80 00       	push   $0x804703
  803175:	68 8e 01 00 00       	push   $0x18e
  80317a:	68 21 47 80 00       	push   $0x804721
  80317f:	e8 0e d4 ff ff       	call   800592 <_panic>
  803184:	8b 45 0c             	mov    0xc(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	85 c0                	test   %eax,%eax
  80318b:	74 10                	je     80319d <merging+0x25a>
  80318d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803190:	8b 00                	mov    (%eax),%eax
  803192:	8b 55 0c             	mov    0xc(%ebp),%edx
  803195:	8b 52 04             	mov    0x4(%edx),%edx
  803198:	89 50 04             	mov    %edx,0x4(%eax)
  80319b:	eb 0b                	jmp    8031a8 <merging+0x265>
  80319d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a0:	8b 40 04             	mov    0x4(%eax),%eax
  8031a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8031a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ab:	8b 40 04             	mov    0x4(%eax),%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 0f                	je     8031c1 <merging+0x27e>
  8031b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b5:	8b 40 04             	mov    0x4(%eax),%eax
  8031b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031bb:	8b 12                	mov    (%edx),%edx
  8031bd:	89 10                	mov    %edx,(%eax)
  8031bf:	eb 0a                	jmp    8031cb <merging+0x288>
  8031c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031de:	a1 38 50 80 00       	mov    0x805038,%eax
  8031e3:	48                   	dec    %eax
  8031e4:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031e9:	e9 72 01 00 00       	jmp    803360 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8031ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8031f1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f8:	74 79                	je     803273 <merging+0x330>
  8031fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031fe:	74 73                	je     803273 <merging+0x330>
  803200:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803204:	74 06                	je     80320c <merging+0x2c9>
  803206:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80320a:	75 17                	jne    803223 <merging+0x2e0>
  80320c:	83 ec 04             	sub    $0x4,%esp
  80320f:	68 94 47 80 00       	push   $0x804794
  803214:	68 94 01 00 00       	push   $0x194
  803219:	68 21 47 80 00       	push   $0x804721
  80321e:	e8 6f d3 ff ff       	call   800592 <_panic>
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	8b 10                	mov    (%eax),%edx
  803228:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80322b:	89 10                	mov    %edx,(%eax)
  80322d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803230:	8b 00                	mov    (%eax),%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	74 0b                	je     803241 <merging+0x2fe>
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	8b 00                	mov    (%eax),%eax
  80323b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80323e:	89 50 04             	mov    %edx,0x4(%eax)
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803247:	89 10                	mov    %edx,(%eax)
  803249:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80324c:	8b 55 08             	mov    0x8(%ebp),%edx
  80324f:	89 50 04             	mov    %edx,0x4(%eax)
  803252:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	85 c0                	test   %eax,%eax
  803259:	75 08                	jne    803263 <merging+0x320>
  80325b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325e:	a3 30 50 80 00       	mov    %eax,0x805030
  803263:	a1 38 50 80 00       	mov    0x805038,%eax
  803268:	40                   	inc    %eax
  803269:	a3 38 50 80 00       	mov    %eax,0x805038
  80326e:	e9 ce 00 00 00       	jmp    803341 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803273:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803277:	74 65                	je     8032de <merging+0x39b>
  803279:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80327d:	75 17                	jne    803296 <merging+0x353>
  80327f:	83 ec 04             	sub    $0x4,%esp
  803282:	68 70 47 80 00       	push   $0x804770
  803287:	68 95 01 00 00       	push   $0x195
  80328c:	68 21 47 80 00       	push   $0x804721
  803291:	e8 fc d2 ff ff       	call   800592 <_panic>
  803296:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80329c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80329f:	89 50 04             	mov    %edx,0x4(%eax)
  8032a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a5:	8b 40 04             	mov    0x4(%eax),%eax
  8032a8:	85 c0                	test   %eax,%eax
  8032aa:	74 0c                	je     8032b8 <merging+0x375>
  8032ac:	a1 30 50 80 00       	mov    0x805030,%eax
  8032b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032b4:	89 10                	mov    %edx,(%eax)
  8032b6:	eb 08                	jmp    8032c0 <merging+0x37d>
  8032b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032bb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c3:	a3 30 50 80 00       	mov    %eax,0x805030
  8032c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8032d6:	40                   	inc    %eax
  8032d7:	a3 38 50 80 00       	mov    %eax,0x805038
  8032dc:	eb 63                	jmp    803341 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8032de:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032e2:	75 17                	jne    8032fb <merging+0x3b8>
  8032e4:	83 ec 04             	sub    $0x4,%esp
  8032e7:	68 3c 47 80 00       	push   $0x80473c
  8032ec:	68 98 01 00 00       	push   $0x198
  8032f1:	68 21 47 80 00       	push   $0x804721
  8032f6:	e8 97 d2 ff ff       	call   800592 <_panic>
  8032fb:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803301:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803304:	89 10                	mov    %edx,(%eax)
  803306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803309:	8b 00                	mov    (%eax),%eax
  80330b:	85 c0                	test   %eax,%eax
  80330d:	74 0d                	je     80331c <merging+0x3d9>
  80330f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803314:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803317:	89 50 04             	mov    %edx,0x4(%eax)
  80331a:	eb 08                	jmp    803324 <merging+0x3e1>
  80331c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80331f:	a3 30 50 80 00       	mov    %eax,0x805030
  803324:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803327:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80332c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80332f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803336:	a1 38 50 80 00       	mov    0x805038,%eax
  80333b:	40                   	inc    %eax
  80333c:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803341:	83 ec 0c             	sub    $0xc,%esp
  803344:	ff 75 10             	pushl  0x10(%ebp)
  803347:	e8 f9 ed ff ff       	call   802145 <get_block_size>
  80334c:	83 c4 10             	add    $0x10,%esp
  80334f:	83 ec 04             	sub    $0x4,%esp
  803352:	6a 00                	push   $0x0
  803354:	50                   	push   %eax
  803355:	ff 75 10             	pushl  0x10(%ebp)
  803358:	e8 39 f1 ff ff       	call   802496 <set_block_data>
  80335d:	83 c4 10             	add    $0x10,%esp
	}
}
  803360:	90                   	nop
  803361:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803364:	c9                   	leave  
  803365:	c3                   	ret    

00803366 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803366:	55                   	push   %ebp
  803367:	89 e5                	mov    %esp,%ebp
  803369:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80336c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803371:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803374:	a1 30 50 80 00       	mov    0x805030,%eax
  803379:	3b 45 08             	cmp    0x8(%ebp),%eax
  80337c:	73 1b                	jae    803399 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80337e:	a1 30 50 80 00       	mov    0x805030,%eax
  803383:	83 ec 04             	sub    $0x4,%esp
  803386:	ff 75 08             	pushl  0x8(%ebp)
  803389:	6a 00                	push   $0x0
  80338b:	50                   	push   %eax
  80338c:	e8 b2 fb ff ff       	call   802f43 <merging>
  803391:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803394:	e9 8b 00 00 00       	jmp    803424 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803399:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80339e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033a1:	76 18                	jbe    8033bb <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8033a3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033a8:	83 ec 04             	sub    $0x4,%esp
  8033ab:	ff 75 08             	pushl  0x8(%ebp)
  8033ae:	50                   	push   %eax
  8033af:	6a 00                	push   $0x0
  8033b1:	e8 8d fb ff ff       	call   802f43 <merging>
  8033b6:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033b9:	eb 69                	jmp    803424 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c3:	eb 39                	jmp    8033fe <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033cb:	73 29                	jae    8033f6 <free_block+0x90>
  8033cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d0:	8b 00                	mov    (%eax),%eax
  8033d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033d5:	76 1f                	jbe    8033f6 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	8b 00                	mov    (%eax),%eax
  8033dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8033df:	83 ec 04             	sub    $0x4,%esp
  8033e2:	ff 75 08             	pushl  0x8(%ebp)
  8033e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8033e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8033eb:	e8 53 fb ff ff       	call   802f43 <merging>
  8033f0:	83 c4 10             	add    $0x10,%esp
			break;
  8033f3:	90                   	nop
		}
	}
}
  8033f4:	eb 2e                	jmp    803424 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033f6:	a1 34 50 80 00       	mov    0x805034,%eax
  8033fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803402:	74 07                	je     80340b <free_block+0xa5>
  803404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803407:	8b 00                	mov    (%eax),%eax
  803409:	eb 05                	jmp    803410 <free_block+0xaa>
  80340b:	b8 00 00 00 00       	mov    $0x0,%eax
  803410:	a3 34 50 80 00       	mov    %eax,0x805034
  803415:	a1 34 50 80 00       	mov    0x805034,%eax
  80341a:	85 c0                	test   %eax,%eax
  80341c:	75 a7                	jne    8033c5 <free_block+0x5f>
  80341e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803422:	75 a1                	jne    8033c5 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803424:	90                   	nop
  803425:	c9                   	leave  
  803426:	c3                   	ret    

00803427 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803427:	55                   	push   %ebp
  803428:	89 e5                	mov    %esp,%ebp
  80342a:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80342d:	ff 75 08             	pushl  0x8(%ebp)
  803430:	e8 10 ed ff ff       	call   802145 <get_block_size>
  803435:	83 c4 04             	add    $0x4,%esp
  803438:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80343b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803442:	eb 17                	jmp    80345b <copy_data+0x34>
  803444:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344a:	01 c2                	add    %eax,%edx
  80344c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	01 c8                	add    %ecx,%eax
  803454:	8a 00                	mov    (%eax),%al
  803456:	88 02                	mov    %al,(%edx)
  803458:	ff 45 fc             	incl   -0x4(%ebp)
  80345b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80345e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803461:	72 e1                	jb     803444 <copy_data+0x1d>
}
  803463:	90                   	nop
  803464:	c9                   	leave  
  803465:	c3                   	ret    

00803466 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803466:	55                   	push   %ebp
  803467:	89 e5                	mov    %esp,%ebp
  803469:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80346c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803470:	75 23                	jne    803495 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803472:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803476:	74 13                	je     80348b <realloc_block_FF+0x25>
  803478:	83 ec 0c             	sub    $0xc,%esp
  80347b:	ff 75 0c             	pushl  0xc(%ebp)
  80347e:	e8 42 f0 ff ff       	call   8024c5 <alloc_block_FF>
  803483:	83 c4 10             	add    $0x10,%esp
  803486:	e9 e4 06 00 00       	jmp    803b6f <realloc_block_FF+0x709>
		return NULL;
  80348b:	b8 00 00 00 00       	mov    $0x0,%eax
  803490:	e9 da 06 00 00       	jmp    803b6f <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803495:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803499:	75 18                	jne    8034b3 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80349b:	83 ec 0c             	sub    $0xc,%esp
  80349e:	ff 75 08             	pushl  0x8(%ebp)
  8034a1:	e8 c0 fe ff ff       	call   803366 <free_block>
  8034a6:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8034a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ae:	e9 bc 06 00 00       	jmp    803b6f <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8034b3:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8034b7:	77 07                	ja     8034c0 <realloc_block_FF+0x5a>
  8034b9:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8034c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c3:	83 e0 01             	and    $0x1,%eax
  8034c6:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8034c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034cc:	83 c0 08             	add    $0x8,%eax
  8034cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8034d2:	83 ec 0c             	sub    $0xc,%esp
  8034d5:	ff 75 08             	pushl  0x8(%ebp)
  8034d8:	e8 68 ec ff ff       	call   802145 <get_block_size>
  8034dd:	83 c4 10             	add    $0x10,%esp
  8034e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e6:	83 e8 08             	sub    $0x8,%eax
  8034e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ef:	83 e8 04             	sub    $0x4,%eax
  8034f2:	8b 00                	mov    (%eax),%eax
  8034f4:	83 e0 fe             	and    $0xfffffffe,%eax
  8034f7:	89 c2                	mov    %eax,%edx
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	01 d0                	add    %edx,%eax
  8034fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803501:	83 ec 0c             	sub    $0xc,%esp
  803504:	ff 75 e4             	pushl  -0x1c(%ebp)
  803507:	e8 39 ec ff ff       	call   802145 <get_block_size>
  80350c:	83 c4 10             	add    $0x10,%esp
  80350f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803515:	83 e8 08             	sub    $0x8,%eax
  803518:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80351b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803521:	75 08                	jne    80352b <realloc_block_FF+0xc5>
	{
		 return va;
  803523:	8b 45 08             	mov    0x8(%ebp),%eax
  803526:	e9 44 06 00 00       	jmp    803b6f <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80352b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803531:	0f 83 d5 03 00 00    	jae    80390c <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803537:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80353d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803540:	83 ec 0c             	sub    $0xc,%esp
  803543:	ff 75 e4             	pushl  -0x1c(%ebp)
  803546:	e8 13 ec ff ff       	call   80215e <is_free_block>
  80354b:	83 c4 10             	add    $0x10,%esp
  80354e:	84 c0                	test   %al,%al
  803550:	0f 84 3b 01 00 00    	je     803691 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803556:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803559:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80355c:	01 d0                	add    %edx,%eax
  80355e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803561:	83 ec 04             	sub    $0x4,%esp
  803564:	6a 01                	push   $0x1
  803566:	ff 75 f0             	pushl  -0x10(%ebp)
  803569:	ff 75 08             	pushl  0x8(%ebp)
  80356c:	e8 25 ef ff ff       	call   802496 <set_block_data>
  803571:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803574:	8b 45 08             	mov    0x8(%ebp),%eax
  803577:	83 e8 04             	sub    $0x4,%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	83 e0 fe             	and    $0xfffffffe,%eax
  80357f:	89 c2                	mov    %eax,%edx
  803581:	8b 45 08             	mov    0x8(%ebp),%eax
  803584:	01 d0                	add    %edx,%eax
  803586:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803589:	83 ec 04             	sub    $0x4,%esp
  80358c:	6a 00                	push   $0x0
  80358e:	ff 75 cc             	pushl  -0x34(%ebp)
  803591:	ff 75 c8             	pushl  -0x38(%ebp)
  803594:	e8 fd ee ff ff       	call   802496 <set_block_data>
  803599:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80359c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a0:	74 06                	je     8035a8 <realloc_block_FF+0x142>
  8035a2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8035a6:	75 17                	jne    8035bf <realloc_block_FF+0x159>
  8035a8:	83 ec 04             	sub    $0x4,%esp
  8035ab:	68 94 47 80 00       	push   $0x804794
  8035b0:	68 f6 01 00 00       	push   $0x1f6
  8035b5:	68 21 47 80 00       	push   $0x804721
  8035ba:	e8 d3 cf ff ff       	call   800592 <_panic>
  8035bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c2:	8b 10                	mov    (%eax),%edx
  8035c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035c7:	89 10                	mov    %edx,(%eax)
  8035c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035cc:	8b 00                	mov    (%eax),%eax
  8035ce:	85 c0                	test   %eax,%eax
  8035d0:	74 0b                	je     8035dd <realloc_block_FF+0x177>
  8035d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d5:	8b 00                	mov    (%eax),%eax
  8035d7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035da:	89 50 04             	mov    %edx,0x4(%eax)
  8035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035e3:	89 10                	mov    %edx,(%eax)
  8035e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035eb:	89 50 04             	mov    %edx,0x4(%eax)
  8035ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035f1:	8b 00                	mov    (%eax),%eax
  8035f3:	85 c0                	test   %eax,%eax
  8035f5:	75 08                	jne    8035ff <realloc_block_FF+0x199>
  8035f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ff:	a1 38 50 80 00       	mov    0x805038,%eax
  803604:	40                   	inc    %eax
  803605:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80360a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80360e:	75 17                	jne    803627 <realloc_block_FF+0x1c1>
  803610:	83 ec 04             	sub    $0x4,%esp
  803613:	68 03 47 80 00       	push   $0x804703
  803618:	68 f7 01 00 00       	push   $0x1f7
  80361d:	68 21 47 80 00       	push   $0x804721
  803622:	e8 6b cf ff ff       	call   800592 <_panic>
  803627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 10                	je     803640 <realloc_block_FF+0x1da>
  803630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803633:	8b 00                	mov    (%eax),%eax
  803635:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803638:	8b 52 04             	mov    0x4(%edx),%edx
  80363b:	89 50 04             	mov    %edx,0x4(%eax)
  80363e:	eb 0b                	jmp    80364b <realloc_block_FF+0x1e5>
  803640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803643:	8b 40 04             	mov    0x4(%eax),%eax
  803646:	a3 30 50 80 00       	mov    %eax,0x805030
  80364b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364e:	8b 40 04             	mov    0x4(%eax),%eax
  803651:	85 c0                	test   %eax,%eax
  803653:	74 0f                	je     803664 <realloc_block_FF+0x1fe>
  803655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80365e:	8b 12                	mov    (%edx),%edx
  803660:	89 10                	mov    %edx,(%eax)
  803662:	eb 0a                	jmp    80366e <realloc_block_FF+0x208>
  803664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80366e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803681:	a1 38 50 80 00       	mov    0x805038,%eax
  803686:	48                   	dec    %eax
  803687:	a3 38 50 80 00       	mov    %eax,0x805038
  80368c:	e9 73 02 00 00       	jmp    803904 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803691:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803695:	0f 86 69 02 00 00    	jbe    803904 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80369b:	83 ec 04             	sub    $0x4,%esp
  80369e:	6a 01                	push   $0x1
  8036a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8036a3:	ff 75 08             	pushl  0x8(%ebp)
  8036a6:	e8 eb ed ff ff       	call   802496 <set_block_data>
  8036ab:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b1:	83 e8 04             	sub    $0x4,%eax
  8036b4:	8b 00                	mov    (%eax),%eax
  8036b6:	83 e0 fe             	and    $0xfffffffe,%eax
  8036b9:	89 c2                	mov    %eax,%edx
  8036bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036be:	01 d0                	add    %edx,%eax
  8036c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8036c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8036c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8036cb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8036cf:	75 68                	jne    803739 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036d5:	75 17                	jne    8036ee <realloc_block_FF+0x288>
  8036d7:	83 ec 04             	sub    $0x4,%esp
  8036da:	68 3c 47 80 00       	push   $0x80473c
  8036df:	68 06 02 00 00       	push   $0x206
  8036e4:	68 21 47 80 00       	push   $0x804721
  8036e9:	e8 a4 ce ff ff       	call   800592 <_panic>
  8036ee:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f7:	89 10                	mov    %edx,(%eax)
  8036f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fc:	8b 00                	mov    (%eax),%eax
  8036fe:	85 c0                	test   %eax,%eax
  803700:	74 0d                	je     80370f <realloc_block_FF+0x2a9>
  803702:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803707:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80370a:	89 50 04             	mov    %edx,0x4(%eax)
  80370d:	eb 08                	jmp    803717 <realloc_block_FF+0x2b1>
  80370f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803712:	a3 30 50 80 00       	mov    %eax,0x805030
  803717:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80371f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803722:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803729:	a1 38 50 80 00       	mov    0x805038,%eax
  80372e:	40                   	inc    %eax
  80372f:	a3 38 50 80 00       	mov    %eax,0x805038
  803734:	e9 b0 01 00 00       	jmp    8038e9 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803739:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80373e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803741:	76 68                	jbe    8037ab <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803743:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803747:	75 17                	jne    803760 <realloc_block_FF+0x2fa>
  803749:	83 ec 04             	sub    $0x4,%esp
  80374c:	68 3c 47 80 00       	push   $0x80473c
  803751:	68 0b 02 00 00       	push   $0x20b
  803756:	68 21 47 80 00       	push   $0x804721
  80375b:	e8 32 ce ff ff       	call   800592 <_panic>
  803760:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803766:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803769:	89 10                	mov    %edx,(%eax)
  80376b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80376e:	8b 00                	mov    (%eax),%eax
  803770:	85 c0                	test   %eax,%eax
  803772:	74 0d                	je     803781 <realloc_block_FF+0x31b>
  803774:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803779:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80377c:	89 50 04             	mov    %edx,0x4(%eax)
  80377f:	eb 08                	jmp    803789 <realloc_block_FF+0x323>
  803781:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803784:	a3 30 50 80 00       	mov    %eax,0x805030
  803789:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80378c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803791:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803794:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80379b:	a1 38 50 80 00       	mov    0x805038,%eax
  8037a0:	40                   	inc    %eax
  8037a1:	a3 38 50 80 00       	mov    %eax,0x805038
  8037a6:	e9 3e 01 00 00       	jmp    8038e9 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8037ab:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037b0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037b3:	73 68                	jae    80381d <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8037b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037b9:	75 17                	jne    8037d2 <realloc_block_FF+0x36c>
  8037bb:	83 ec 04             	sub    $0x4,%esp
  8037be:	68 70 47 80 00       	push   $0x804770
  8037c3:	68 10 02 00 00       	push   $0x210
  8037c8:	68 21 47 80 00       	push   $0x804721
  8037cd:	e8 c0 cd ff ff       	call   800592 <_panic>
  8037d2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037db:	89 50 04             	mov    %edx,0x4(%eax)
  8037de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e1:	8b 40 04             	mov    0x4(%eax),%eax
  8037e4:	85 c0                	test   %eax,%eax
  8037e6:	74 0c                	je     8037f4 <realloc_block_FF+0x38e>
  8037e8:	a1 30 50 80 00       	mov    0x805030,%eax
  8037ed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037f0:	89 10                	mov    %edx,(%eax)
  8037f2:	eb 08                	jmp    8037fc <realloc_block_FF+0x396>
  8037f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037f7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ff:	a3 30 50 80 00       	mov    %eax,0x805030
  803804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803807:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80380d:	a1 38 50 80 00       	mov    0x805038,%eax
  803812:	40                   	inc    %eax
  803813:	a3 38 50 80 00       	mov    %eax,0x805038
  803818:	e9 cc 00 00 00       	jmp    8038e9 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80381d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803824:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80382c:	e9 8a 00 00 00       	jmp    8038bb <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803834:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803837:	73 7a                	jae    8038b3 <realloc_block_FF+0x44d>
  803839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383c:	8b 00                	mov    (%eax),%eax
  80383e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803841:	73 70                	jae    8038b3 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803847:	74 06                	je     80384f <realloc_block_FF+0x3e9>
  803849:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80384d:	75 17                	jne    803866 <realloc_block_FF+0x400>
  80384f:	83 ec 04             	sub    $0x4,%esp
  803852:	68 94 47 80 00       	push   $0x804794
  803857:	68 1a 02 00 00       	push   $0x21a
  80385c:	68 21 47 80 00       	push   $0x804721
  803861:	e8 2c cd ff ff       	call   800592 <_panic>
  803866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803869:	8b 10                	mov    (%eax),%edx
  80386b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80386e:	89 10                	mov    %edx,(%eax)
  803870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803873:	8b 00                	mov    (%eax),%eax
  803875:	85 c0                	test   %eax,%eax
  803877:	74 0b                	je     803884 <realloc_block_FF+0x41e>
  803879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387c:	8b 00                	mov    (%eax),%eax
  80387e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803881:	89 50 04             	mov    %edx,0x4(%eax)
  803884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803887:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80388a:	89 10                	mov    %edx,(%eax)
  80388c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80388f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803892:	89 50 04             	mov    %edx,0x4(%eax)
  803895:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803898:	8b 00                	mov    (%eax),%eax
  80389a:	85 c0                	test   %eax,%eax
  80389c:	75 08                	jne    8038a6 <realloc_block_FF+0x440>
  80389e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8038a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ab:	40                   	inc    %eax
  8038ac:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8038b1:	eb 36                	jmp    8038e9 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8038b3:	a1 34 50 80 00       	mov    0x805034,%eax
  8038b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038bf:	74 07                	je     8038c8 <realloc_block_FF+0x462>
  8038c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c4:	8b 00                	mov    (%eax),%eax
  8038c6:	eb 05                	jmp    8038cd <realloc_block_FF+0x467>
  8038c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8038cd:	a3 34 50 80 00       	mov    %eax,0x805034
  8038d2:	a1 34 50 80 00       	mov    0x805034,%eax
  8038d7:	85 c0                	test   %eax,%eax
  8038d9:	0f 85 52 ff ff ff    	jne    803831 <realloc_block_FF+0x3cb>
  8038df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038e3:	0f 85 48 ff ff ff    	jne    803831 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8038e9:	83 ec 04             	sub    $0x4,%esp
  8038ec:	6a 00                	push   $0x0
  8038ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8038f1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038f4:	e8 9d eb ff ff       	call   802496 <set_block_data>
  8038f9:	83 c4 10             	add    $0x10,%esp
				return va;
  8038fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ff:	e9 6b 02 00 00       	jmp    803b6f <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803904:	8b 45 08             	mov    0x8(%ebp),%eax
  803907:	e9 63 02 00 00       	jmp    803b6f <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  80390c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80390f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803912:	0f 86 4d 02 00 00    	jbe    803b65 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803918:	83 ec 0c             	sub    $0xc,%esp
  80391b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80391e:	e8 3b e8 ff ff       	call   80215e <is_free_block>
  803923:	83 c4 10             	add    $0x10,%esp
  803926:	84 c0                	test   %al,%al
  803928:	0f 84 37 02 00 00    	je     803b65 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80392e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803931:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803934:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803937:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80393a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80393d:	76 38                	jbe    803977 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80393f:	83 ec 0c             	sub    $0xc,%esp
  803942:	ff 75 0c             	pushl  0xc(%ebp)
  803945:	e8 7b eb ff ff       	call   8024c5 <alloc_block_FF>
  80394a:	83 c4 10             	add    $0x10,%esp
  80394d:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803950:	83 ec 08             	sub    $0x8,%esp
  803953:	ff 75 c0             	pushl  -0x40(%ebp)
  803956:	ff 75 08             	pushl  0x8(%ebp)
  803959:	e8 c9 fa ff ff       	call   803427 <copy_data>
  80395e:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803961:	83 ec 0c             	sub    $0xc,%esp
  803964:	ff 75 08             	pushl  0x8(%ebp)
  803967:	e8 fa f9 ff ff       	call   803366 <free_block>
  80396c:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80396f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803972:	e9 f8 01 00 00       	jmp    803b6f <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803977:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80397a:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80397d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803980:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803984:	0f 87 a0 00 00 00    	ja     803a2a <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80398a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80398e:	75 17                	jne    8039a7 <realloc_block_FF+0x541>
  803990:	83 ec 04             	sub    $0x4,%esp
  803993:	68 03 47 80 00       	push   $0x804703
  803998:	68 38 02 00 00       	push   $0x238
  80399d:	68 21 47 80 00       	push   $0x804721
  8039a2:	e8 eb cb ff ff       	call   800592 <_panic>
  8039a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039aa:	8b 00                	mov    (%eax),%eax
  8039ac:	85 c0                	test   %eax,%eax
  8039ae:	74 10                	je     8039c0 <realloc_block_FF+0x55a>
  8039b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b3:	8b 00                	mov    (%eax),%eax
  8039b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039b8:	8b 52 04             	mov    0x4(%edx),%edx
  8039bb:	89 50 04             	mov    %edx,0x4(%eax)
  8039be:	eb 0b                	jmp    8039cb <realloc_block_FF+0x565>
  8039c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c3:	8b 40 04             	mov    0x4(%eax),%eax
  8039c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8039cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ce:	8b 40 04             	mov    0x4(%eax),%eax
  8039d1:	85 c0                	test   %eax,%eax
  8039d3:	74 0f                	je     8039e4 <realloc_block_FF+0x57e>
  8039d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d8:	8b 40 04             	mov    0x4(%eax),%eax
  8039db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039de:	8b 12                	mov    (%edx),%edx
  8039e0:	89 10                	mov    %edx,(%eax)
  8039e2:	eb 0a                	jmp    8039ee <realloc_block_FF+0x588>
  8039e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e7:	8b 00                	mov    (%eax),%eax
  8039e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a01:	a1 38 50 80 00       	mov    0x805038,%eax
  803a06:	48                   	dec    %eax
  803a07:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803a0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a12:	01 d0                	add    %edx,%eax
  803a14:	83 ec 04             	sub    $0x4,%esp
  803a17:	6a 01                	push   $0x1
  803a19:	50                   	push   %eax
  803a1a:	ff 75 08             	pushl  0x8(%ebp)
  803a1d:	e8 74 ea ff ff       	call   802496 <set_block_data>
  803a22:	83 c4 10             	add    $0x10,%esp
  803a25:	e9 36 01 00 00       	jmp    803b60 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803a2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a2d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a30:	01 d0                	add    %edx,%eax
  803a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a35:	83 ec 04             	sub    $0x4,%esp
  803a38:	6a 01                	push   $0x1
  803a3a:	ff 75 f0             	pushl  -0x10(%ebp)
  803a3d:	ff 75 08             	pushl  0x8(%ebp)
  803a40:	e8 51 ea ff ff       	call   802496 <set_block_data>
  803a45:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a48:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4b:	83 e8 04             	sub    $0x4,%eax
  803a4e:	8b 00                	mov    (%eax),%eax
  803a50:	83 e0 fe             	and    $0xfffffffe,%eax
  803a53:	89 c2                	mov    %eax,%edx
  803a55:	8b 45 08             	mov    0x8(%ebp),%eax
  803a58:	01 d0                	add    %edx,%eax
  803a5a:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a61:	74 06                	je     803a69 <realloc_block_FF+0x603>
  803a63:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a67:	75 17                	jne    803a80 <realloc_block_FF+0x61a>
  803a69:	83 ec 04             	sub    $0x4,%esp
  803a6c:	68 94 47 80 00       	push   $0x804794
  803a71:	68 44 02 00 00       	push   $0x244
  803a76:	68 21 47 80 00       	push   $0x804721
  803a7b:	e8 12 cb ff ff       	call   800592 <_panic>
  803a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a83:	8b 10                	mov    (%eax),%edx
  803a85:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a88:	89 10                	mov    %edx,(%eax)
  803a8a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a8d:	8b 00                	mov    (%eax),%eax
  803a8f:	85 c0                	test   %eax,%eax
  803a91:	74 0b                	je     803a9e <realloc_block_FF+0x638>
  803a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a96:	8b 00                	mov    (%eax),%eax
  803a98:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a9b:	89 50 04             	mov    %edx,0x4(%eax)
  803a9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803aa4:	89 10                	mov    %edx,(%eax)
  803aa6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aa9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aac:	89 50 04             	mov    %edx,0x4(%eax)
  803aaf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ab2:	8b 00                	mov    (%eax),%eax
  803ab4:	85 c0                	test   %eax,%eax
  803ab6:	75 08                	jne    803ac0 <realloc_block_FF+0x65a>
  803ab8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803abb:	a3 30 50 80 00       	mov    %eax,0x805030
  803ac0:	a1 38 50 80 00       	mov    0x805038,%eax
  803ac5:	40                   	inc    %eax
  803ac6:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803acb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803acf:	75 17                	jne    803ae8 <realloc_block_FF+0x682>
  803ad1:	83 ec 04             	sub    $0x4,%esp
  803ad4:	68 03 47 80 00       	push   $0x804703
  803ad9:	68 45 02 00 00       	push   $0x245
  803ade:	68 21 47 80 00       	push   $0x804721
  803ae3:	e8 aa ca ff ff       	call   800592 <_panic>
  803ae8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aeb:	8b 00                	mov    (%eax),%eax
  803aed:	85 c0                	test   %eax,%eax
  803aef:	74 10                	je     803b01 <realloc_block_FF+0x69b>
  803af1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af4:	8b 00                	mov    (%eax),%eax
  803af6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803af9:	8b 52 04             	mov    0x4(%edx),%edx
  803afc:	89 50 04             	mov    %edx,0x4(%eax)
  803aff:	eb 0b                	jmp    803b0c <realloc_block_FF+0x6a6>
  803b01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b04:	8b 40 04             	mov    0x4(%eax),%eax
  803b07:	a3 30 50 80 00       	mov    %eax,0x805030
  803b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0f:	8b 40 04             	mov    0x4(%eax),%eax
  803b12:	85 c0                	test   %eax,%eax
  803b14:	74 0f                	je     803b25 <realloc_block_FF+0x6bf>
  803b16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b19:	8b 40 04             	mov    0x4(%eax),%eax
  803b1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b1f:	8b 12                	mov    (%edx),%edx
  803b21:	89 10                	mov    %edx,(%eax)
  803b23:	eb 0a                	jmp    803b2f <realloc_block_FF+0x6c9>
  803b25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b28:	8b 00                	mov    (%eax),%eax
  803b2a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b42:	a1 38 50 80 00       	mov    0x805038,%eax
  803b47:	48                   	dec    %eax
  803b48:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b4d:	83 ec 04             	sub    $0x4,%esp
  803b50:	6a 00                	push   $0x0
  803b52:	ff 75 bc             	pushl  -0x44(%ebp)
  803b55:	ff 75 b8             	pushl  -0x48(%ebp)
  803b58:	e8 39 e9 ff ff       	call   802496 <set_block_data>
  803b5d:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b60:	8b 45 08             	mov    0x8(%ebp),%eax
  803b63:	eb 0a                	jmp    803b6f <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b65:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b6f:	c9                   	leave  
  803b70:	c3                   	ret    

00803b71 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b71:	55                   	push   %ebp
  803b72:	89 e5                	mov    %esp,%ebp
  803b74:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b77:	83 ec 04             	sub    $0x4,%esp
  803b7a:	68 00 48 80 00       	push   $0x804800
  803b7f:	68 58 02 00 00       	push   $0x258
  803b84:	68 21 47 80 00       	push   $0x804721
  803b89:	e8 04 ca ff ff       	call   800592 <_panic>

00803b8e <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b8e:	55                   	push   %ebp
  803b8f:	89 e5                	mov    %esp,%ebp
  803b91:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b94:	83 ec 04             	sub    $0x4,%esp
  803b97:	68 28 48 80 00       	push   $0x804828
  803b9c:	68 61 02 00 00       	push   $0x261
  803ba1:	68 21 47 80 00       	push   $0x804721
  803ba6:	e8 e7 c9 ff ff       	call   800592 <_panic>
  803bab:	90                   	nop

00803bac <__udivdi3>:
  803bac:	55                   	push   %ebp
  803bad:	57                   	push   %edi
  803bae:	56                   	push   %esi
  803baf:	53                   	push   %ebx
  803bb0:	83 ec 1c             	sub    $0x1c,%esp
  803bb3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bb7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bc3:	89 ca                	mov    %ecx,%edx
  803bc5:	89 f8                	mov    %edi,%eax
  803bc7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bcb:	85 f6                	test   %esi,%esi
  803bcd:	75 2d                	jne    803bfc <__udivdi3+0x50>
  803bcf:	39 cf                	cmp    %ecx,%edi
  803bd1:	77 65                	ja     803c38 <__udivdi3+0x8c>
  803bd3:	89 fd                	mov    %edi,%ebp
  803bd5:	85 ff                	test   %edi,%edi
  803bd7:	75 0b                	jne    803be4 <__udivdi3+0x38>
  803bd9:	b8 01 00 00 00       	mov    $0x1,%eax
  803bde:	31 d2                	xor    %edx,%edx
  803be0:	f7 f7                	div    %edi
  803be2:	89 c5                	mov    %eax,%ebp
  803be4:	31 d2                	xor    %edx,%edx
  803be6:	89 c8                	mov    %ecx,%eax
  803be8:	f7 f5                	div    %ebp
  803bea:	89 c1                	mov    %eax,%ecx
  803bec:	89 d8                	mov    %ebx,%eax
  803bee:	f7 f5                	div    %ebp
  803bf0:	89 cf                	mov    %ecx,%edi
  803bf2:	89 fa                	mov    %edi,%edx
  803bf4:	83 c4 1c             	add    $0x1c,%esp
  803bf7:	5b                   	pop    %ebx
  803bf8:	5e                   	pop    %esi
  803bf9:	5f                   	pop    %edi
  803bfa:	5d                   	pop    %ebp
  803bfb:	c3                   	ret    
  803bfc:	39 ce                	cmp    %ecx,%esi
  803bfe:	77 28                	ja     803c28 <__udivdi3+0x7c>
  803c00:	0f bd fe             	bsr    %esi,%edi
  803c03:	83 f7 1f             	xor    $0x1f,%edi
  803c06:	75 40                	jne    803c48 <__udivdi3+0x9c>
  803c08:	39 ce                	cmp    %ecx,%esi
  803c0a:	72 0a                	jb     803c16 <__udivdi3+0x6a>
  803c0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c10:	0f 87 9e 00 00 00    	ja     803cb4 <__udivdi3+0x108>
  803c16:	b8 01 00 00 00       	mov    $0x1,%eax
  803c1b:	89 fa                	mov    %edi,%edx
  803c1d:	83 c4 1c             	add    $0x1c,%esp
  803c20:	5b                   	pop    %ebx
  803c21:	5e                   	pop    %esi
  803c22:	5f                   	pop    %edi
  803c23:	5d                   	pop    %ebp
  803c24:	c3                   	ret    
  803c25:	8d 76 00             	lea    0x0(%esi),%esi
  803c28:	31 ff                	xor    %edi,%edi
  803c2a:	31 c0                	xor    %eax,%eax
  803c2c:	89 fa                	mov    %edi,%edx
  803c2e:	83 c4 1c             	add    $0x1c,%esp
  803c31:	5b                   	pop    %ebx
  803c32:	5e                   	pop    %esi
  803c33:	5f                   	pop    %edi
  803c34:	5d                   	pop    %ebp
  803c35:	c3                   	ret    
  803c36:	66 90                	xchg   %ax,%ax
  803c38:	89 d8                	mov    %ebx,%eax
  803c3a:	f7 f7                	div    %edi
  803c3c:	31 ff                	xor    %edi,%edi
  803c3e:	89 fa                	mov    %edi,%edx
  803c40:	83 c4 1c             	add    $0x1c,%esp
  803c43:	5b                   	pop    %ebx
  803c44:	5e                   	pop    %esi
  803c45:	5f                   	pop    %edi
  803c46:	5d                   	pop    %ebp
  803c47:	c3                   	ret    
  803c48:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c4d:	89 eb                	mov    %ebp,%ebx
  803c4f:	29 fb                	sub    %edi,%ebx
  803c51:	89 f9                	mov    %edi,%ecx
  803c53:	d3 e6                	shl    %cl,%esi
  803c55:	89 c5                	mov    %eax,%ebp
  803c57:	88 d9                	mov    %bl,%cl
  803c59:	d3 ed                	shr    %cl,%ebp
  803c5b:	89 e9                	mov    %ebp,%ecx
  803c5d:	09 f1                	or     %esi,%ecx
  803c5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c63:	89 f9                	mov    %edi,%ecx
  803c65:	d3 e0                	shl    %cl,%eax
  803c67:	89 c5                	mov    %eax,%ebp
  803c69:	89 d6                	mov    %edx,%esi
  803c6b:	88 d9                	mov    %bl,%cl
  803c6d:	d3 ee                	shr    %cl,%esi
  803c6f:	89 f9                	mov    %edi,%ecx
  803c71:	d3 e2                	shl    %cl,%edx
  803c73:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c77:	88 d9                	mov    %bl,%cl
  803c79:	d3 e8                	shr    %cl,%eax
  803c7b:	09 c2                	or     %eax,%edx
  803c7d:	89 d0                	mov    %edx,%eax
  803c7f:	89 f2                	mov    %esi,%edx
  803c81:	f7 74 24 0c          	divl   0xc(%esp)
  803c85:	89 d6                	mov    %edx,%esi
  803c87:	89 c3                	mov    %eax,%ebx
  803c89:	f7 e5                	mul    %ebp
  803c8b:	39 d6                	cmp    %edx,%esi
  803c8d:	72 19                	jb     803ca8 <__udivdi3+0xfc>
  803c8f:	74 0b                	je     803c9c <__udivdi3+0xf0>
  803c91:	89 d8                	mov    %ebx,%eax
  803c93:	31 ff                	xor    %edi,%edi
  803c95:	e9 58 ff ff ff       	jmp    803bf2 <__udivdi3+0x46>
  803c9a:	66 90                	xchg   %ax,%ax
  803c9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ca0:	89 f9                	mov    %edi,%ecx
  803ca2:	d3 e2                	shl    %cl,%edx
  803ca4:	39 c2                	cmp    %eax,%edx
  803ca6:	73 e9                	jae    803c91 <__udivdi3+0xe5>
  803ca8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cab:	31 ff                	xor    %edi,%edi
  803cad:	e9 40 ff ff ff       	jmp    803bf2 <__udivdi3+0x46>
  803cb2:	66 90                	xchg   %ax,%ax
  803cb4:	31 c0                	xor    %eax,%eax
  803cb6:	e9 37 ff ff ff       	jmp    803bf2 <__udivdi3+0x46>
  803cbb:	90                   	nop

00803cbc <__umoddi3>:
  803cbc:	55                   	push   %ebp
  803cbd:	57                   	push   %edi
  803cbe:	56                   	push   %esi
  803cbf:	53                   	push   %ebx
  803cc0:	83 ec 1c             	sub    $0x1c,%esp
  803cc3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cc7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ccb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ccf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cd7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cdb:	89 f3                	mov    %esi,%ebx
  803cdd:	89 fa                	mov    %edi,%edx
  803cdf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ce3:	89 34 24             	mov    %esi,(%esp)
  803ce6:	85 c0                	test   %eax,%eax
  803ce8:	75 1a                	jne    803d04 <__umoddi3+0x48>
  803cea:	39 f7                	cmp    %esi,%edi
  803cec:	0f 86 a2 00 00 00    	jbe    803d94 <__umoddi3+0xd8>
  803cf2:	89 c8                	mov    %ecx,%eax
  803cf4:	89 f2                	mov    %esi,%edx
  803cf6:	f7 f7                	div    %edi
  803cf8:	89 d0                	mov    %edx,%eax
  803cfa:	31 d2                	xor    %edx,%edx
  803cfc:	83 c4 1c             	add    $0x1c,%esp
  803cff:	5b                   	pop    %ebx
  803d00:	5e                   	pop    %esi
  803d01:	5f                   	pop    %edi
  803d02:	5d                   	pop    %ebp
  803d03:	c3                   	ret    
  803d04:	39 f0                	cmp    %esi,%eax
  803d06:	0f 87 ac 00 00 00    	ja     803db8 <__umoddi3+0xfc>
  803d0c:	0f bd e8             	bsr    %eax,%ebp
  803d0f:	83 f5 1f             	xor    $0x1f,%ebp
  803d12:	0f 84 ac 00 00 00    	je     803dc4 <__umoddi3+0x108>
  803d18:	bf 20 00 00 00       	mov    $0x20,%edi
  803d1d:	29 ef                	sub    %ebp,%edi
  803d1f:	89 fe                	mov    %edi,%esi
  803d21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d25:	89 e9                	mov    %ebp,%ecx
  803d27:	d3 e0                	shl    %cl,%eax
  803d29:	89 d7                	mov    %edx,%edi
  803d2b:	89 f1                	mov    %esi,%ecx
  803d2d:	d3 ef                	shr    %cl,%edi
  803d2f:	09 c7                	or     %eax,%edi
  803d31:	89 e9                	mov    %ebp,%ecx
  803d33:	d3 e2                	shl    %cl,%edx
  803d35:	89 14 24             	mov    %edx,(%esp)
  803d38:	89 d8                	mov    %ebx,%eax
  803d3a:	d3 e0                	shl    %cl,%eax
  803d3c:	89 c2                	mov    %eax,%edx
  803d3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d42:	d3 e0                	shl    %cl,%eax
  803d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d48:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d4c:	89 f1                	mov    %esi,%ecx
  803d4e:	d3 e8                	shr    %cl,%eax
  803d50:	09 d0                	or     %edx,%eax
  803d52:	d3 eb                	shr    %cl,%ebx
  803d54:	89 da                	mov    %ebx,%edx
  803d56:	f7 f7                	div    %edi
  803d58:	89 d3                	mov    %edx,%ebx
  803d5a:	f7 24 24             	mull   (%esp)
  803d5d:	89 c6                	mov    %eax,%esi
  803d5f:	89 d1                	mov    %edx,%ecx
  803d61:	39 d3                	cmp    %edx,%ebx
  803d63:	0f 82 87 00 00 00    	jb     803df0 <__umoddi3+0x134>
  803d69:	0f 84 91 00 00 00    	je     803e00 <__umoddi3+0x144>
  803d6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d73:	29 f2                	sub    %esi,%edx
  803d75:	19 cb                	sbb    %ecx,%ebx
  803d77:	89 d8                	mov    %ebx,%eax
  803d79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d7d:	d3 e0                	shl    %cl,%eax
  803d7f:	89 e9                	mov    %ebp,%ecx
  803d81:	d3 ea                	shr    %cl,%edx
  803d83:	09 d0                	or     %edx,%eax
  803d85:	89 e9                	mov    %ebp,%ecx
  803d87:	d3 eb                	shr    %cl,%ebx
  803d89:	89 da                	mov    %ebx,%edx
  803d8b:	83 c4 1c             	add    $0x1c,%esp
  803d8e:	5b                   	pop    %ebx
  803d8f:	5e                   	pop    %esi
  803d90:	5f                   	pop    %edi
  803d91:	5d                   	pop    %ebp
  803d92:	c3                   	ret    
  803d93:	90                   	nop
  803d94:	89 fd                	mov    %edi,%ebp
  803d96:	85 ff                	test   %edi,%edi
  803d98:	75 0b                	jne    803da5 <__umoddi3+0xe9>
  803d9a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d9f:	31 d2                	xor    %edx,%edx
  803da1:	f7 f7                	div    %edi
  803da3:	89 c5                	mov    %eax,%ebp
  803da5:	89 f0                	mov    %esi,%eax
  803da7:	31 d2                	xor    %edx,%edx
  803da9:	f7 f5                	div    %ebp
  803dab:	89 c8                	mov    %ecx,%eax
  803dad:	f7 f5                	div    %ebp
  803daf:	89 d0                	mov    %edx,%eax
  803db1:	e9 44 ff ff ff       	jmp    803cfa <__umoddi3+0x3e>
  803db6:	66 90                	xchg   %ax,%ax
  803db8:	89 c8                	mov    %ecx,%eax
  803dba:	89 f2                	mov    %esi,%edx
  803dbc:	83 c4 1c             	add    $0x1c,%esp
  803dbf:	5b                   	pop    %ebx
  803dc0:	5e                   	pop    %esi
  803dc1:	5f                   	pop    %edi
  803dc2:	5d                   	pop    %ebp
  803dc3:	c3                   	ret    
  803dc4:	3b 04 24             	cmp    (%esp),%eax
  803dc7:	72 06                	jb     803dcf <__umoddi3+0x113>
  803dc9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dcd:	77 0f                	ja     803dde <__umoddi3+0x122>
  803dcf:	89 f2                	mov    %esi,%edx
  803dd1:	29 f9                	sub    %edi,%ecx
  803dd3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dd7:	89 14 24             	mov    %edx,(%esp)
  803dda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dde:	8b 44 24 04          	mov    0x4(%esp),%eax
  803de2:	8b 14 24             	mov    (%esp),%edx
  803de5:	83 c4 1c             	add    $0x1c,%esp
  803de8:	5b                   	pop    %ebx
  803de9:	5e                   	pop    %esi
  803dea:	5f                   	pop    %edi
  803deb:	5d                   	pop    %ebp
  803dec:	c3                   	ret    
  803ded:	8d 76 00             	lea    0x0(%esi),%esi
  803df0:	2b 04 24             	sub    (%esp),%eax
  803df3:	19 fa                	sbb    %edi,%edx
  803df5:	89 d1                	mov    %edx,%ecx
  803df7:	89 c6                	mov    %eax,%esi
  803df9:	e9 71 ff ff ff       	jmp    803d6f <__umoddi3+0xb3>
  803dfe:	66 90                	xchg   %ax,%ax
  803e00:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e04:	72 ea                	jb     803df0 <__umoddi3+0x134>
  803e06:	89 d9                	mov    %ebx,%ecx
  803e08:	e9 62 ff ff ff       	jmp    803d6f <__umoddi3+0xb3>
