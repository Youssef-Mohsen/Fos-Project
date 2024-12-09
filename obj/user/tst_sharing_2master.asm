
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
  80005c:	68 c0 3e 80 00       	push   $0x803ec0
  800061:	6a 14                	push   $0x14
  800063:	68 dc 3e 80 00       	push   $0x803edc
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
  800091:	68 f7 3e 80 00       	push   $0x803ef7
  800096:	e8 82 18 00 00       	call   80191d <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 fc 3e 80 00       	push   $0x803efc
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
  800103:	68 60 3f 80 00       	push   $0x803f60
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
  80011f:	68 f8 3f 80 00       	push   $0x803ff8
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
  800146:	68 fc 3e 80 00       	push   $0x803efc
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
  800196:	68 60 3f 80 00       	push   $0x803f60
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
  8001b2:	68 fa 3f 80 00       	push   $0x803ffa
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
  8001d9:	68 fc 3e 80 00       	push   $0x803efc
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
  800229:	68 60 3f 80 00       	push   $0x803f60
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
  80027f:	68 fc 3f 80 00       	push   $0x803ffc
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
  8002b5:	68 fc 3f 80 00       	push   $0x803ffc
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
  8002eb:	68 fc 3f 80 00       	push   $0x803ffc
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
  800349:	68 08 40 80 00       	push   $0x804008
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
  80036a:	68 54 40 80 00       	push   $0x804054
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
  80039d:	68 86 40 80 00       	push   $0x804086
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
  8003da:	68 08 40 80 00       	push   $0x804008
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
  80041c:	68 08 40 80 00       	push   $0x804008
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
  800440:	68 94 40 80 00       	push   $0x804094
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
  8004cf:	68 f0 40 80 00       	push   $0x8040f0
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
  8004f7:	68 18 41 80 00       	push   $0x804118
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
  800528:	68 40 41 80 00       	push   $0x804140
  80052d:	e8 1d 03 00 00       	call   80084f <cprintf>
  800532:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800535:	a1 20 50 80 00       	mov    0x805020,%eax
  80053a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	50                   	push   %eax
  800544:	68 98 41 80 00       	push   $0x804198
  800549:	e8 01 03 00 00       	call   80084f <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 f0 40 80 00       	push   $0x8040f0
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
  8005b3:	68 ac 41 80 00       	push   $0x8041ac
  8005b8:	e8 92 02 00 00       	call   80084f <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005c0:	a1 00 50 80 00       	mov    0x805000,%eax
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	50                   	push   %eax
  8005cc:	68 b1 41 80 00       	push   $0x8041b1
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
  8005f0:	68 cd 41 80 00       	push   $0x8041cd
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
  80061f:	68 d0 41 80 00       	push   $0x8041d0
  800624:	6a 26                	push   $0x26
  800626:	68 1c 42 80 00       	push   $0x80421c
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
  8006f4:	68 28 42 80 00       	push   $0x804228
  8006f9:	6a 3a                	push   $0x3a
  8006fb:	68 1c 42 80 00       	push   $0x80421c
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
  800767:	68 7c 42 80 00       	push   $0x80427c
  80076c:	6a 44                	push   $0x44
  80076e:	68 1c 42 80 00       	push   $0x80421c
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
  8008ec:	e8 57 33 00 00       	call   803c48 <__udivdi3>
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
  80093c:	e8 17 34 00 00       	call   803d58 <__umoddi3>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	05 f4 44 80 00       	add    $0x8044f4,%eax
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
  800a97:	8b 04 85 18 45 80 00 	mov    0x804518(,%eax,4),%eax
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
  800b78:	8b 34 9d 60 43 80 00 	mov    0x804360(,%ebx,4),%esi
  800b7f:	85 f6                	test   %esi,%esi
  800b81:	75 19                	jne    800b9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b83:	53                   	push   %ebx
  800b84:	68 05 45 80 00       	push   $0x804505
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
  800b9d:	68 0e 45 80 00       	push   $0x80450e
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
  800bca:	be 11 45 80 00       	mov    $0x804511,%esi
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
  8015d5:	68 88 46 80 00       	push   $0x804688
  8015da:	68 3f 01 00 00       	push   $0x13f
  8015df:	68 aa 46 80 00       	push   $0x8046aa
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
  80167f:	e8 dd 0e 00 00       	call   802561 <alloc_block_FF>
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
  8016a2:	e8 76 13 00 00       	call   802a1d <alloc_block_BF>
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
  801850:	e8 8c 09 00 00       	call   8021e1 <get_block_size>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 9c 1b 00 00       	call   803402 <free_block>
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
  801906:	68 b8 46 80 00       	push   $0x8046b8
  80190b:	68 87 00 00 00       	push   $0x87
  801910:	68 e2 46 80 00       	push   $0x8046e2
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
  801ab1:	68 f0 46 80 00       	push   $0x8046f0
  801ab6:	68 e4 00 00 00       	push   $0xe4
  801abb:	68 e2 46 80 00       	push   $0x8046e2
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
  801ace:	68 16 47 80 00       	push   $0x804716
  801ad3:	68 f0 00 00 00       	push   $0xf0
  801ad8:	68 e2 46 80 00       	push   $0x8046e2
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
  801aeb:	68 16 47 80 00       	push   $0x804716
  801af0:	68 f5 00 00 00       	push   $0xf5
  801af5:	68 e2 46 80 00       	push   $0x8046e2
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
  801b08:	68 16 47 80 00       	push   $0x804716
  801b0d:	68 fa 00 00 00       	push   $0xfa
  801b12:	68 e2 46 80 00       	push   $0x8046e2
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

00802145 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 2e                	push   $0x2e
  802157:	e8 c0 f9 ff ff       	call   801b1c <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
  80215f:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802162:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	50                   	push   %eax
  802176:	6a 2f                	push   $0x2f
  802178:	e8 9f f9 ff ff       	call   801b1c <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
	return;
  802180:	90                   	nop
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  802186:	8b 55 0c             	mov    0xc(%ebp),%edx
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	52                   	push   %edx
  802193:	50                   	push   %eax
  802194:	6a 30                	push   $0x30
  802196:	e8 81 f9 ff ff       	call   801b1c <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
	return;
  80219e:	90                   	nop
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	50                   	push   %eax
  8021b3:	6a 31                	push   $0x31
  8021b5:	e8 62 f9 ff ff       	call   801b1c <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
  8021bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8021c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	50                   	push   %eax
  8021d4:	6a 32                	push   $0x32
  8021d6:	e8 41 f9 ff ff       	call   801b1c <syscall>
  8021db:	83 c4 18             	add    $0x18,%esp
	return;
  8021de:	90                   	nop
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	83 e8 04             	sub    $0x4,%eax
  8021ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8021f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f3:	8b 00                	mov    (%eax),%eax
  8021f5:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	83 e8 04             	sub    $0x4,%eax
  802206:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802209:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80220c:	8b 00                	mov    (%eax),%eax
  80220e:	83 e0 01             	and    $0x1,%eax
  802211:	85 c0                	test   %eax,%eax
  802213:	0f 94 c0             	sete   %al
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80221e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802225:	8b 45 0c             	mov    0xc(%ebp),%eax
  802228:	83 f8 02             	cmp    $0x2,%eax
  80222b:	74 2b                	je     802258 <alloc_block+0x40>
  80222d:	83 f8 02             	cmp    $0x2,%eax
  802230:	7f 07                	jg     802239 <alloc_block+0x21>
  802232:	83 f8 01             	cmp    $0x1,%eax
  802235:	74 0e                	je     802245 <alloc_block+0x2d>
  802237:	eb 58                	jmp    802291 <alloc_block+0x79>
  802239:	83 f8 03             	cmp    $0x3,%eax
  80223c:	74 2d                	je     80226b <alloc_block+0x53>
  80223e:	83 f8 04             	cmp    $0x4,%eax
  802241:	74 3b                	je     80227e <alloc_block+0x66>
  802243:	eb 4c                	jmp    802291 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802245:	83 ec 0c             	sub    $0xc,%esp
  802248:	ff 75 08             	pushl  0x8(%ebp)
  80224b:	e8 11 03 00 00       	call   802561 <alloc_block_FF>
  802250:	83 c4 10             	add    $0x10,%esp
  802253:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802256:	eb 4a                	jmp    8022a2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802258:	83 ec 0c             	sub    $0xc,%esp
  80225b:	ff 75 08             	pushl  0x8(%ebp)
  80225e:	e8 c7 19 00 00       	call   803c2a <alloc_block_NF>
  802263:	83 c4 10             	add    $0x10,%esp
  802266:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802269:	eb 37                	jmp    8022a2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80226b:	83 ec 0c             	sub    $0xc,%esp
  80226e:	ff 75 08             	pushl  0x8(%ebp)
  802271:	e8 a7 07 00 00       	call   802a1d <alloc_block_BF>
  802276:	83 c4 10             	add    $0x10,%esp
  802279:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80227c:	eb 24                	jmp    8022a2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80227e:	83 ec 0c             	sub    $0xc,%esp
  802281:	ff 75 08             	pushl  0x8(%ebp)
  802284:	e8 84 19 00 00       	call   803c0d <alloc_block_WF>
  802289:	83 c4 10             	add    $0x10,%esp
  80228c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80228f:	eb 11                	jmp    8022a2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802291:	83 ec 0c             	sub    $0xc,%esp
  802294:	68 28 47 80 00       	push   $0x804728
  802299:	e8 b1 e5 ff ff       	call   80084f <cprintf>
  80229e:	83 c4 10             	add    $0x10,%esp
		break;
  8022a1:	90                   	nop
	}
	return va;
  8022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	53                   	push   %ebx
  8022ab:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8022ae:	83 ec 0c             	sub    $0xc,%esp
  8022b1:	68 48 47 80 00       	push   $0x804748
  8022b6:	e8 94 e5 ff ff       	call   80084f <cprintf>
  8022bb:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8022be:	83 ec 0c             	sub    $0xc,%esp
  8022c1:	68 73 47 80 00       	push   $0x804773
  8022c6:	e8 84 e5 ff ff       	call   80084f <cprintf>
  8022cb:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d4:	eb 37                	jmp    80230d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8022d6:	83 ec 0c             	sub    $0xc,%esp
  8022d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8022dc:	e8 19 ff ff ff       	call   8021fa <is_free_block>
  8022e1:	83 c4 10             	add    $0x10,%esp
  8022e4:	0f be d8             	movsbl %al,%ebx
  8022e7:	83 ec 0c             	sub    $0xc,%esp
  8022ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ed:	e8 ef fe ff ff       	call   8021e1 <get_block_size>
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	83 ec 04             	sub    $0x4,%esp
  8022f8:	53                   	push   %ebx
  8022f9:	50                   	push   %eax
  8022fa:	68 8b 47 80 00       	push   $0x80478b
  8022ff:	e8 4b e5 ff ff       	call   80084f <cprintf>
  802304:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802307:	8b 45 10             	mov    0x10(%ebp),%eax
  80230a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802311:	74 07                	je     80231a <print_blocks_list+0x73>
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 00                	mov    (%eax),%eax
  802318:	eb 05                	jmp    80231f <print_blocks_list+0x78>
  80231a:	b8 00 00 00 00       	mov    $0x0,%eax
  80231f:	89 45 10             	mov    %eax,0x10(%ebp)
  802322:	8b 45 10             	mov    0x10(%ebp),%eax
  802325:	85 c0                	test   %eax,%eax
  802327:	75 ad                	jne    8022d6 <print_blocks_list+0x2f>
  802329:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232d:	75 a7                	jne    8022d6 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80232f:	83 ec 0c             	sub    $0xc,%esp
  802332:	68 48 47 80 00       	push   $0x804748
  802337:	e8 13 e5 ff ff       	call   80084f <cprintf>
  80233c:	83 c4 10             	add    $0x10,%esp

}
  80233f:	90                   	nop
  802340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80234b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234e:	83 e0 01             	and    $0x1,%eax
  802351:	85 c0                	test   %eax,%eax
  802353:	74 03                	je     802358 <initialize_dynamic_allocator+0x13>
  802355:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802358:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80235c:	0f 84 c7 01 00 00    	je     802529 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802362:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802369:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80236c:	8b 55 08             	mov    0x8(%ebp),%edx
  80236f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802372:	01 d0                	add    %edx,%eax
  802374:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802379:	0f 87 ad 01 00 00    	ja     80252c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	85 c0                	test   %eax,%eax
  802384:	0f 89 a5 01 00 00    	jns    80252f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80238a:	8b 55 08             	mov    0x8(%ebp),%edx
  80238d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802390:	01 d0                	add    %edx,%eax
  802392:	83 e8 04             	sub    $0x4,%eax
  802395:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80239a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8023a1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a9:	e9 87 00 00 00       	jmp    802435 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8023ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b2:	75 14                	jne    8023c8 <initialize_dynamic_allocator+0x83>
  8023b4:	83 ec 04             	sub    $0x4,%esp
  8023b7:	68 a3 47 80 00       	push   $0x8047a3
  8023bc:	6a 79                	push   $0x79
  8023be:	68 c1 47 80 00       	push   $0x8047c1
  8023c3:	e8 ca e1 ff ff       	call   800592 <_panic>
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 00                	mov    (%eax),%eax
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	74 10                	je     8023e1 <initialize_dynamic_allocator+0x9c>
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d9:	8b 52 04             	mov    0x4(%edx),%edx
  8023dc:	89 50 04             	mov    %edx,0x4(%eax)
  8023df:	eb 0b                	jmp    8023ec <initialize_dynamic_allocator+0xa7>
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 40 04             	mov    0x4(%eax),%eax
  8023e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 40 04             	mov    0x4(%eax),%eax
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	74 0f                	je     802405 <initialize_dynamic_allocator+0xc0>
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	8b 40 04             	mov    0x4(%eax),%eax
  8023fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ff:	8b 12                	mov    (%edx),%edx
  802401:	89 10                	mov    %edx,(%eax)
  802403:	eb 0a                	jmp    80240f <initialize_dynamic_allocator+0xca>
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 00                	mov    (%eax),%eax
  80240a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802422:	a1 38 50 80 00       	mov    0x805038,%eax
  802427:	48                   	dec    %eax
  802428:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80242d:	a1 34 50 80 00       	mov    0x805034,%eax
  802432:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802435:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802439:	74 07                	je     802442 <initialize_dynamic_allocator+0xfd>
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	eb 05                	jmp    802447 <initialize_dynamic_allocator+0x102>
  802442:	b8 00 00 00 00       	mov    $0x0,%eax
  802447:	a3 34 50 80 00       	mov    %eax,0x805034
  80244c:	a1 34 50 80 00       	mov    0x805034,%eax
  802451:	85 c0                	test   %eax,%eax
  802453:	0f 85 55 ff ff ff    	jne    8023ae <initialize_dynamic_allocator+0x69>
  802459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245d:	0f 85 4b ff ff ff    	jne    8023ae <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802472:	a1 44 50 80 00       	mov    0x805044,%eax
  802477:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80247c:	a1 40 50 80 00       	mov    0x805040,%eax
  802481:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	83 c0 08             	add    $0x8,%eax
  80248d:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802490:	8b 45 08             	mov    0x8(%ebp),%eax
  802493:	83 c0 04             	add    $0x4,%eax
  802496:	8b 55 0c             	mov    0xc(%ebp),%edx
  802499:	83 ea 08             	sub    $0x8,%edx
  80249c:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80249e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	01 d0                	add    %edx,%eax
  8024a6:	83 e8 08             	sub    $0x8,%eax
  8024a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ac:	83 ea 08             	sub    $0x8,%edx
  8024af:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8024b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8024ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8024c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024c8:	75 17                	jne    8024e1 <initialize_dynamic_allocator+0x19c>
  8024ca:	83 ec 04             	sub    $0x4,%esp
  8024cd:	68 dc 47 80 00       	push   $0x8047dc
  8024d2:	68 90 00 00 00       	push   $0x90
  8024d7:	68 c1 47 80 00       	push   $0x8047c1
  8024dc:	e8 b1 e0 ff ff       	call   800592 <_panic>
  8024e1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8024e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ea:	89 10                	mov    %edx,(%eax)
  8024ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ef:	8b 00                	mov    (%eax),%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 0d                	je     802502 <initialize_dynamic_allocator+0x1bd>
  8024f5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024fd:	89 50 04             	mov    %edx,0x4(%eax)
  802500:	eb 08                	jmp    80250a <initialize_dynamic_allocator+0x1c5>
  802502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802505:	a3 30 50 80 00       	mov    %eax,0x805030
  80250a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802512:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802515:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251c:	a1 38 50 80 00       	mov    0x805038,%eax
  802521:	40                   	inc    %eax
  802522:	a3 38 50 80 00       	mov    %eax,0x805038
  802527:	eb 07                	jmp    802530 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802529:	90                   	nop
  80252a:	eb 04                	jmp    802530 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80252c:	90                   	nop
  80252d:	eb 01                	jmp    802530 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80252f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802535:	8b 45 10             	mov    0x10(%ebp),%eax
  802538:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802541:	8b 45 0c             	mov    0xc(%ebp),%eax
  802544:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	83 e8 04             	sub    $0x4,%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	83 e0 fe             	and    $0xfffffffe,%eax
  802551:	8d 50 f8             	lea    -0x8(%eax),%edx
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	01 c2                	add    %eax,%edx
  802559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255c:	89 02                	mov    %eax,(%edx)
}
  80255e:	90                   	nop
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    

00802561 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	83 e0 01             	and    $0x1,%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	74 03                	je     802574 <alloc_block_FF+0x13>
  802571:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802574:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802578:	77 07                	ja     802581 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80257a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802581:	a1 24 50 80 00       	mov    0x805024,%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	75 73                	jne    8025fd <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	83 c0 10             	add    $0x10,%eax
  802590:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802593:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80259a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80259d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a0:	01 d0                	add    %edx,%eax
  8025a2:	48                   	dec    %eax
  8025a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8025a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ae:	f7 75 ec             	divl   -0x14(%ebp)
  8025b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b4:	29 d0                	sub    %edx,%eax
  8025b6:	c1 e8 0c             	shr    $0xc,%eax
  8025b9:	83 ec 0c             	sub    $0xc,%esp
  8025bc:	50                   	push   %eax
  8025bd:	e8 27 f0 ff ff       	call   8015e9 <sbrk>
  8025c2:	83 c4 10             	add    $0x10,%esp
  8025c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025c8:	83 ec 0c             	sub    $0xc,%esp
  8025cb:	6a 00                	push   $0x0
  8025cd:	e8 17 f0 ff ff       	call   8015e9 <sbrk>
  8025d2:	83 c4 10             	add    $0x10,%esp
  8025d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8025d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025db:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8025de:	83 ec 08             	sub    $0x8,%esp
  8025e1:	50                   	push   %eax
  8025e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025e5:	e8 5b fd ff ff       	call   802345 <initialize_dynamic_allocator>
  8025ea:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025ed:	83 ec 0c             	sub    $0xc,%esp
  8025f0:	68 ff 47 80 00       	push   $0x8047ff
  8025f5:	e8 55 e2 ff ff       	call   80084f <cprintf>
  8025fa:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8025fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802601:	75 0a                	jne    80260d <alloc_block_FF+0xac>
	        return NULL;
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
  802608:	e9 0e 04 00 00       	jmp    802a1b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80260d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802614:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802619:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261c:	e9 f3 02 00 00       	jmp    802914 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802627:	83 ec 0c             	sub    $0xc,%esp
  80262a:	ff 75 bc             	pushl  -0x44(%ebp)
  80262d:	e8 af fb ff ff       	call   8021e1 <get_block_size>
  802632:	83 c4 10             	add    $0x10,%esp
  802635:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802638:	8b 45 08             	mov    0x8(%ebp),%eax
  80263b:	83 c0 08             	add    $0x8,%eax
  80263e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802641:	0f 87 c5 02 00 00    	ja     80290c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	83 c0 18             	add    $0x18,%eax
  80264d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802650:	0f 87 19 02 00 00    	ja     80286f <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802656:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802659:	2b 45 08             	sub    0x8(%ebp),%eax
  80265c:	83 e8 08             	sub    $0x8,%eax
  80265f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	8d 50 08             	lea    0x8(%eax),%edx
  802668:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80266b:	01 d0                	add    %edx,%eax
  80266d:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802670:	8b 45 08             	mov    0x8(%ebp),%eax
  802673:	83 c0 08             	add    $0x8,%eax
  802676:	83 ec 04             	sub    $0x4,%esp
  802679:	6a 01                	push   $0x1
  80267b:	50                   	push   %eax
  80267c:	ff 75 bc             	pushl  -0x44(%ebp)
  80267f:	e8 ae fe ff ff       	call   802532 <set_block_data>
  802684:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 40 04             	mov    0x4(%eax),%eax
  80268d:	85 c0                	test   %eax,%eax
  80268f:	75 68                	jne    8026f9 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802691:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802695:	75 17                	jne    8026ae <alloc_block_FF+0x14d>
  802697:	83 ec 04             	sub    $0x4,%esp
  80269a:	68 dc 47 80 00       	push   $0x8047dc
  80269f:	68 d7 00 00 00       	push   $0xd7
  8026a4:	68 c1 47 80 00       	push   $0x8047c1
  8026a9:	e8 e4 de ff ff       	call   800592 <_panic>
  8026ae:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8026b4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026b7:	89 10                	mov    %edx,(%eax)
  8026b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026bc:	8b 00                	mov    (%eax),%eax
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	74 0d                	je     8026cf <alloc_block_FF+0x16e>
  8026c2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026c7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026ca:	89 50 04             	mov    %edx,0x4(%eax)
  8026cd:	eb 08                	jmp    8026d7 <alloc_block_FF+0x176>
  8026cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026d2:	a3 30 50 80 00       	mov    %eax,0x805030
  8026d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026da:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8026ee:	40                   	inc    %eax
  8026ef:	a3 38 50 80 00       	mov    %eax,0x805038
  8026f4:	e9 dc 00 00 00       	jmp    8027d5 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	85 c0                	test   %eax,%eax
  802700:	75 65                	jne    802767 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802702:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802706:	75 17                	jne    80271f <alloc_block_FF+0x1be>
  802708:	83 ec 04             	sub    $0x4,%esp
  80270b:	68 10 48 80 00       	push   $0x804810
  802710:	68 db 00 00 00       	push   $0xdb
  802715:	68 c1 47 80 00       	push   $0x8047c1
  80271a:	e8 73 de ff ff       	call   800592 <_panic>
  80271f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802725:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802728:	89 50 04             	mov    %edx,0x4(%eax)
  80272b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80272e:	8b 40 04             	mov    0x4(%eax),%eax
  802731:	85 c0                	test   %eax,%eax
  802733:	74 0c                	je     802741 <alloc_block_FF+0x1e0>
  802735:	a1 30 50 80 00       	mov    0x805030,%eax
  80273a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80273d:	89 10                	mov    %edx,(%eax)
  80273f:	eb 08                	jmp    802749 <alloc_block_FF+0x1e8>
  802741:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802744:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802749:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80274c:	a3 30 50 80 00       	mov    %eax,0x805030
  802751:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802754:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275a:	a1 38 50 80 00       	mov    0x805038,%eax
  80275f:	40                   	inc    %eax
  802760:	a3 38 50 80 00       	mov    %eax,0x805038
  802765:	eb 6e                	jmp    8027d5 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802767:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276b:	74 06                	je     802773 <alloc_block_FF+0x212>
  80276d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802771:	75 17                	jne    80278a <alloc_block_FF+0x229>
  802773:	83 ec 04             	sub    $0x4,%esp
  802776:	68 34 48 80 00       	push   $0x804834
  80277b:	68 df 00 00 00       	push   $0xdf
  802780:	68 c1 47 80 00       	push   $0x8047c1
  802785:	e8 08 de ff ff       	call   800592 <_panic>
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 10                	mov    (%eax),%edx
  80278f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802792:	89 10                	mov    %edx,(%eax)
  802794:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	85 c0                	test   %eax,%eax
  80279b:	74 0b                	je     8027a8 <alloc_block_FF+0x247>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027a5:	89 50 04             	mov    %edx,0x4(%eax)
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027ae:	89 10                	mov    %edx,(%eax)
  8027b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b6:	89 50 04             	mov    %edx,0x4(%eax)
  8027b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027bc:	8b 00                	mov    (%eax),%eax
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	75 08                	jne    8027ca <alloc_block_FF+0x269>
  8027c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8027ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8027cf:	40                   	inc    %eax
  8027d0:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8027d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d9:	75 17                	jne    8027f2 <alloc_block_FF+0x291>
  8027db:	83 ec 04             	sub    $0x4,%esp
  8027de:	68 a3 47 80 00       	push   $0x8047a3
  8027e3:	68 e1 00 00 00       	push   $0xe1
  8027e8:	68 c1 47 80 00       	push   $0x8047c1
  8027ed:	e8 a0 dd ff ff       	call   800592 <_panic>
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	74 10                	je     80280b <alloc_block_FF+0x2aa>
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 00                	mov    (%eax),%eax
  802800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802803:	8b 52 04             	mov    0x4(%edx),%edx
  802806:	89 50 04             	mov    %edx,0x4(%eax)
  802809:	eb 0b                	jmp    802816 <alloc_block_FF+0x2b5>
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 40 04             	mov    0x4(%eax),%eax
  802811:	a3 30 50 80 00       	mov    %eax,0x805030
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 40 04             	mov    0x4(%eax),%eax
  80281c:	85 c0                	test   %eax,%eax
  80281e:	74 0f                	je     80282f <alloc_block_FF+0x2ce>
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 40 04             	mov    0x4(%eax),%eax
  802826:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802829:	8b 12                	mov    (%edx),%edx
  80282b:	89 10                	mov    %edx,(%eax)
  80282d:	eb 0a                	jmp    802839 <alloc_block_FF+0x2d8>
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
				set_block_data(new_block_va, remaining_size, 0);
  802857:	83 ec 04             	sub    $0x4,%esp
  80285a:	6a 00                	push   $0x0
  80285c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80285f:	ff 75 b0             	pushl  -0x50(%ebp)
  802862:	e8 cb fc ff ff       	call   802532 <set_block_data>
  802867:	83 c4 10             	add    $0x10,%esp
  80286a:	e9 95 00 00 00       	jmp    802904 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80286f:	83 ec 04             	sub    $0x4,%esp
  802872:	6a 01                	push   $0x1
  802874:	ff 75 b8             	pushl  -0x48(%ebp)
  802877:	ff 75 bc             	pushl  -0x44(%ebp)
  80287a:	e8 b3 fc ff ff       	call   802532 <set_block_data>
  80287f:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802882:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802886:	75 17                	jne    80289f <alloc_block_FF+0x33e>
  802888:	83 ec 04             	sub    $0x4,%esp
  80288b:	68 a3 47 80 00       	push   $0x8047a3
  802890:	68 e8 00 00 00       	push   $0xe8
  802895:	68 c1 47 80 00       	push   $0x8047c1
  80289a:	e8 f3 dc ff ff       	call   800592 <_panic>
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	74 10                	je     8028b8 <alloc_block_FF+0x357>
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b0:	8b 52 04             	mov    0x4(%edx),%edx
  8028b3:	89 50 04             	mov    %edx,0x4(%eax)
  8028b6:	eb 0b                	jmp    8028c3 <alloc_block_FF+0x362>
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	a3 30 50 80 00       	mov    %eax,0x805030
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	74 0f                	je     8028dc <alloc_block_FF+0x37b>
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 40 04             	mov    0x4(%eax),%eax
  8028d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d6:	8b 12                	mov    (%edx),%edx
  8028d8:	89 10                	mov    %edx,(%eax)
  8028da:	eb 0a                	jmp    8028e6 <alloc_block_FF+0x385>
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8028fe:	48                   	dec    %eax
  8028ff:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802904:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802907:	e9 0f 01 00 00       	jmp    802a1b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80290c:	a1 34 50 80 00       	mov    0x805034,%eax
  802911:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802914:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802918:	74 07                	je     802921 <alloc_block_FF+0x3c0>
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 00                	mov    (%eax),%eax
  80291f:	eb 05                	jmp    802926 <alloc_block_FF+0x3c5>
  802921:	b8 00 00 00 00       	mov    $0x0,%eax
  802926:	a3 34 50 80 00       	mov    %eax,0x805034
  80292b:	a1 34 50 80 00       	mov    0x805034,%eax
  802930:	85 c0                	test   %eax,%eax
  802932:	0f 85 e9 fc ff ff    	jne    802621 <alloc_block_FF+0xc0>
  802938:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293c:	0f 85 df fc ff ff    	jne    802621 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	83 c0 08             	add    $0x8,%eax
  802948:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80294b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802952:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802958:	01 d0                	add    %edx,%eax
  80295a:	48                   	dec    %eax
  80295b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80295e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802961:	ba 00 00 00 00       	mov    $0x0,%edx
  802966:	f7 75 d8             	divl   -0x28(%ebp)
  802969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80296c:	29 d0                	sub    %edx,%eax
  80296e:	c1 e8 0c             	shr    $0xc,%eax
  802971:	83 ec 0c             	sub    $0xc,%esp
  802974:	50                   	push   %eax
  802975:	e8 6f ec ff ff       	call   8015e9 <sbrk>
  80297a:	83 c4 10             	add    $0x10,%esp
  80297d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802980:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802984:	75 0a                	jne    802990 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802986:	b8 00 00 00 00       	mov    $0x0,%eax
  80298b:	e9 8b 00 00 00       	jmp    802a1b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802990:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802997:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80299a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80299d:	01 d0                	add    %edx,%eax
  80299f:	48                   	dec    %eax
  8029a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8029a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ab:	f7 75 cc             	divl   -0x34(%ebp)
  8029ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029b1:	29 d0                	sub    %edx,%eax
  8029b3:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029b9:	01 d0                	add    %edx,%eax
  8029bb:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8029c0:	a1 40 50 80 00       	mov    0x805040,%eax
  8029c5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8029cb:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8029d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029d8:	01 d0                	add    %edx,%eax
  8029da:	48                   	dec    %eax
  8029db:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8029de:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8029e6:	f7 75 c4             	divl   -0x3c(%ebp)
  8029e9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029ec:	29 d0                	sub    %edx,%eax
  8029ee:	83 ec 04             	sub    $0x4,%esp
  8029f1:	6a 01                	push   $0x1
  8029f3:	50                   	push   %eax
  8029f4:	ff 75 d0             	pushl  -0x30(%ebp)
  8029f7:	e8 36 fb ff ff       	call   802532 <set_block_data>
  8029fc:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8029ff:	83 ec 0c             	sub    $0xc,%esp
  802a02:	ff 75 d0             	pushl  -0x30(%ebp)
  802a05:	e8 f8 09 00 00       	call   803402 <free_block>
  802a0a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802a0d:	83 ec 0c             	sub    $0xc,%esp
  802a10:	ff 75 08             	pushl  0x8(%ebp)
  802a13:	e8 49 fb ff ff       	call   802561 <alloc_block_FF>
  802a18:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802a1b:	c9                   	leave  
  802a1c:	c3                   	ret    

00802a1d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a1d:	55                   	push   %ebp
  802a1e:	89 e5                	mov    %esp,%ebp
  802a20:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a23:	8b 45 08             	mov    0x8(%ebp),%eax
  802a26:	83 e0 01             	and    $0x1,%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	74 03                	je     802a30 <alloc_block_BF+0x13>
  802a2d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a30:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a34:	77 07                	ja     802a3d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a36:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a3d:	a1 24 50 80 00       	mov    0x805024,%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	75 73                	jne    802ab9 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	83 c0 10             	add    $0x10,%eax
  802a4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a4f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802a56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5c:	01 d0                	add    %edx,%eax
  802a5e:	48                   	dec    %eax
  802a5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802a62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a65:	ba 00 00 00 00       	mov    $0x0,%edx
  802a6a:	f7 75 e0             	divl   -0x20(%ebp)
  802a6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a70:	29 d0                	sub    %edx,%eax
  802a72:	c1 e8 0c             	shr    $0xc,%eax
  802a75:	83 ec 0c             	sub    $0xc,%esp
  802a78:	50                   	push   %eax
  802a79:	e8 6b eb ff ff       	call   8015e9 <sbrk>
  802a7e:	83 c4 10             	add    $0x10,%esp
  802a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a84:	83 ec 0c             	sub    $0xc,%esp
  802a87:	6a 00                	push   $0x0
  802a89:	e8 5b eb ff ff       	call   8015e9 <sbrk>
  802a8e:	83 c4 10             	add    $0x10,%esp
  802a91:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a97:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802a9a:	83 ec 08             	sub    $0x8,%esp
  802a9d:	50                   	push   %eax
  802a9e:	ff 75 d8             	pushl  -0x28(%ebp)
  802aa1:	e8 9f f8 ff ff       	call   802345 <initialize_dynamic_allocator>
  802aa6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802aa9:	83 ec 0c             	sub    $0xc,%esp
  802aac:	68 ff 47 80 00       	push   $0x8047ff
  802ab1:	e8 99 dd ff ff       	call   80084f <cprintf>
  802ab6:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802ab9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ac0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ac7:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802ace:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802ad5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802add:	e9 1d 01 00 00       	jmp    802bff <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802ae8:	83 ec 0c             	sub    $0xc,%esp
  802aeb:	ff 75 a8             	pushl  -0x58(%ebp)
  802aee:	e8 ee f6 ff ff       	call   8021e1 <get_block_size>
  802af3:	83 c4 10             	add    $0x10,%esp
  802af6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802af9:	8b 45 08             	mov    0x8(%ebp),%eax
  802afc:	83 c0 08             	add    $0x8,%eax
  802aff:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b02:	0f 87 ef 00 00 00    	ja     802bf7 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	83 c0 18             	add    $0x18,%eax
  802b0e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b11:	77 1d                	ja     802b30 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b16:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b19:	0f 86 d8 00 00 00    	jbe    802bf7 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802b1f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802b25:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b2b:	e9 c7 00 00 00       	jmp    802bf7 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	83 c0 08             	add    $0x8,%eax
  802b36:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b39:	0f 85 9d 00 00 00    	jne    802bdc <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	6a 01                	push   $0x1
  802b44:	ff 75 a4             	pushl  -0x5c(%ebp)
  802b47:	ff 75 a8             	pushl  -0x58(%ebp)
  802b4a:	e8 e3 f9 ff ff       	call   802532 <set_block_data>
  802b4f:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b56:	75 17                	jne    802b6f <alloc_block_BF+0x152>
  802b58:	83 ec 04             	sub    $0x4,%esp
  802b5b:	68 a3 47 80 00       	push   $0x8047a3
  802b60:	68 2c 01 00 00       	push   $0x12c
  802b65:	68 c1 47 80 00       	push   $0x8047c1
  802b6a:	e8 23 da ff ff       	call   800592 <_panic>
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 00                	mov    (%eax),%eax
  802b74:	85 c0                	test   %eax,%eax
  802b76:	74 10                	je     802b88 <alloc_block_BF+0x16b>
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 00                	mov    (%eax),%eax
  802b7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b80:	8b 52 04             	mov    0x4(%edx),%edx
  802b83:	89 50 04             	mov    %edx,0x4(%eax)
  802b86:	eb 0b                	jmp    802b93 <alloc_block_BF+0x176>
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 40 04             	mov    0x4(%eax),%eax
  802b8e:	a3 30 50 80 00       	mov    %eax,0x805030
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	8b 40 04             	mov    0x4(%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	74 0f                	je     802bac <alloc_block_BF+0x18f>
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 40 04             	mov    0x4(%eax),%eax
  802ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba6:	8b 12                	mov    (%edx),%edx
  802ba8:	89 10                	mov    %edx,(%eax)
  802baa:	eb 0a                	jmp    802bb6 <alloc_block_BF+0x199>
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc9:	a1 38 50 80 00       	mov    0x805038,%eax
  802bce:	48                   	dec    %eax
  802bcf:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802bd4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802bd7:	e9 01 04 00 00       	jmp    802fdd <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdf:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802be2:	76 13                	jbe    802bf7 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802be4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802beb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802bf1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802bf4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802bf7:	a1 34 50 80 00       	mov    0x805034,%eax
  802bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c03:	74 07                	je     802c0c <alloc_block_BF+0x1ef>
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	eb 05                	jmp    802c11 <alloc_block_BF+0x1f4>
  802c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c11:	a3 34 50 80 00       	mov    %eax,0x805034
  802c16:	a1 34 50 80 00       	mov    0x805034,%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	0f 85 bf fe ff ff    	jne    802ae2 <alloc_block_BF+0xc5>
  802c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c27:	0f 85 b5 fe ff ff    	jne    802ae2 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802c2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c31:	0f 84 26 02 00 00    	je     802e5d <alloc_block_BF+0x440>
  802c37:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c3b:	0f 85 1c 02 00 00    	jne    802e5d <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c44:	2b 45 08             	sub    0x8(%ebp),%eax
  802c47:	83 e8 08             	sub    $0x8,%eax
  802c4a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	8d 50 08             	lea    0x8(%eax),%edx
  802c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c56:	01 d0                	add    %edx,%eax
  802c58:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	83 c0 08             	add    $0x8,%eax
  802c61:	83 ec 04             	sub    $0x4,%esp
  802c64:	6a 01                	push   $0x1
  802c66:	50                   	push   %eax
  802c67:	ff 75 f0             	pushl  -0x10(%ebp)
  802c6a:	e8 c3 f8 ff ff       	call   802532 <set_block_data>
  802c6f:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c75:	8b 40 04             	mov    0x4(%eax),%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	75 68                	jne    802ce4 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c7c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c80:	75 17                	jne    802c99 <alloc_block_BF+0x27c>
  802c82:	83 ec 04             	sub    $0x4,%esp
  802c85:	68 dc 47 80 00       	push   $0x8047dc
  802c8a:	68 45 01 00 00       	push   $0x145
  802c8f:	68 c1 47 80 00       	push   $0x8047c1
  802c94:	e8 f9 d8 ff ff       	call   800592 <_panic>
  802c99:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802c9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca2:	89 10                	mov    %edx,(%eax)
  802ca4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	74 0d                	je     802cba <alloc_block_BF+0x29d>
  802cad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802cb2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cb5:	89 50 04             	mov    %edx,0x4(%eax)
  802cb8:	eb 08                	jmp    802cc2 <alloc_block_BF+0x2a5>
  802cba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cbd:	a3 30 50 80 00       	mov    %eax,0x805030
  802cc2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ccd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd4:	a1 38 50 80 00       	mov    0x805038,%eax
  802cd9:	40                   	inc    %eax
  802cda:	a3 38 50 80 00       	mov    %eax,0x805038
  802cdf:	e9 dc 00 00 00       	jmp    802dc0 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	75 65                	jne    802d52 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ced:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802cf1:	75 17                	jne    802d0a <alloc_block_BF+0x2ed>
  802cf3:	83 ec 04             	sub    $0x4,%esp
  802cf6:	68 10 48 80 00       	push   $0x804810
  802cfb:	68 4a 01 00 00       	push   $0x14a
  802d00:	68 c1 47 80 00       	push   $0x8047c1
  802d05:	e8 88 d8 ff ff       	call   800592 <_panic>
  802d0a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802d10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d19:	8b 40 04             	mov    0x4(%eax),%eax
  802d1c:	85 c0                	test   %eax,%eax
  802d1e:	74 0c                	je     802d2c <alloc_block_BF+0x30f>
  802d20:	a1 30 50 80 00       	mov    0x805030,%eax
  802d25:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d28:	89 10                	mov    %edx,(%eax)
  802d2a:	eb 08                	jmp    802d34 <alloc_block_BF+0x317>
  802d2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d2f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d37:	a3 30 50 80 00       	mov    %eax,0x805030
  802d3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d45:	a1 38 50 80 00       	mov    0x805038,%eax
  802d4a:	40                   	inc    %eax
  802d4b:	a3 38 50 80 00       	mov    %eax,0x805038
  802d50:	eb 6e                	jmp    802dc0 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802d52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d56:	74 06                	je     802d5e <alloc_block_BF+0x341>
  802d58:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d5c:	75 17                	jne    802d75 <alloc_block_BF+0x358>
  802d5e:	83 ec 04             	sub    $0x4,%esp
  802d61:	68 34 48 80 00       	push   $0x804834
  802d66:	68 4f 01 00 00       	push   $0x14f
  802d6b:	68 c1 47 80 00       	push   $0x8047c1
  802d70:	e8 1d d8 ff ff       	call   800592 <_panic>
  802d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d78:	8b 10                	mov    (%eax),%edx
  802d7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d7d:	89 10                	mov    %edx,(%eax)
  802d7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	85 c0                	test   %eax,%eax
  802d86:	74 0b                	je     802d93 <alloc_block_BF+0x376>
  802d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8b:	8b 00                	mov    (%eax),%eax
  802d8d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d90:	89 50 04             	mov    %edx,0x4(%eax)
  802d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d96:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d99:	89 10                	mov    %edx,(%eax)
  802d9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da1:	89 50 04             	mov    %edx,0x4(%eax)
  802da4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	85 c0                	test   %eax,%eax
  802dab:	75 08                	jne    802db5 <alloc_block_BF+0x398>
  802dad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802db0:	a3 30 50 80 00       	mov    %eax,0x805030
  802db5:	a1 38 50 80 00       	mov    0x805038,%eax
  802dba:	40                   	inc    %eax
  802dbb:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802dc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc4:	75 17                	jne    802ddd <alloc_block_BF+0x3c0>
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	68 a3 47 80 00       	push   $0x8047a3
  802dce:	68 51 01 00 00       	push   $0x151
  802dd3:	68 c1 47 80 00       	push   $0x8047c1
  802dd8:	e8 b5 d7 ff ff       	call   800592 <_panic>
  802ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de0:	8b 00                	mov    (%eax),%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	74 10                	je     802df6 <alloc_block_BF+0x3d9>
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dee:	8b 52 04             	mov    0x4(%edx),%edx
  802df1:	89 50 04             	mov    %edx,0x4(%eax)
  802df4:	eb 0b                	jmp    802e01 <alloc_block_BF+0x3e4>
  802df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df9:	8b 40 04             	mov    0x4(%eax),%eax
  802dfc:	a3 30 50 80 00       	mov    %eax,0x805030
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	8b 40 04             	mov    0x4(%eax),%eax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	74 0f                	je     802e1a <alloc_block_BF+0x3fd>
  802e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0e:	8b 40 04             	mov    0x4(%eax),%eax
  802e11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e14:	8b 12                	mov    (%edx),%edx
  802e16:	89 10                	mov    %edx,(%eax)
  802e18:	eb 0a                	jmp    802e24 <alloc_block_BF+0x407>
  802e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e37:	a1 38 50 80 00       	mov    0x805038,%eax
  802e3c:	48                   	dec    %eax
  802e3d:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802e42:	83 ec 04             	sub    $0x4,%esp
  802e45:	6a 00                	push   $0x0
  802e47:	ff 75 d0             	pushl  -0x30(%ebp)
  802e4a:	ff 75 cc             	pushl  -0x34(%ebp)
  802e4d:	e8 e0 f6 ff ff       	call   802532 <set_block_data>
  802e52:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e58:	e9 80 01 00 00       	jmp    802fdd <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802e5d:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802e61:	0f 85 9d 00 00 00    	jne    802f04 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802e67:	83 ec 04             	sub    $0x4,%esp
  802e6a:	6a 01                	push   $0x1
  802e6c:	ff 75 ec             	pushl  -0x14(%ebp)
  802e6f:	ff 75 f0             	pushl  -0x10(%ebp)
  802e72:	e8 bb f6 ff ff       	call   802532 <set_block_data>
  802e77:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802e7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e7e:	75 17                	jne    802e97 <alloc_block_BF+0x47a>
  802e80:	83 ec 04             	sub    $0x4,%esp
  802e83:	68 a3 47 80 00       	push   $0x8047a3
  802e88:	68 58 01 00 00       	push   $0x158
  802e8d:	68 c1 47 80 00       	push   $0x8047c1
  802e92:	e8 fb d6 ff ff       	call   800592 <_panic>
  802e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9a:	8b 00                	mov    (%eax),%eax
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	74 10                	je     802eb0 <alloc_block_BF+0x493>
  802ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea3:	8b 00                	mov    (%eax),%eax
  802ea5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea8:	8b 52 04             	mov    0x4(%edx),%edx
  802eab:	89 50 04             	mov    %edx,0x4(%eax)
  802eae:	eb 0b                	jmp    802ebb <alloc_block_BF+0x49e>
  802eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb3:	8b 40 04             	mov    0x4(%eax),%eax
  802eb6:	a3 30 50 80 00       	mov    %eax,0x805030
  802ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebe:	8b 40 04             	mov    0x4(%eax),%eax
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	74 0f                	je     802ed4 <alloc_block_BF+0x4b7>
  802ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec8:	8b 40 04             	mov    0x4(%eax),%eax
  802ecb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ece:	8b 12                	mov    (%edx),%edx
  802ed0:	89 10                	mov    %edx,(%eax)
  802ed2:	eb 0a                	jmp    802ede <alloc_block_BF+0x4c1>
  802ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed7:	8b 00                	mov    (%eax),%eax
  802ed9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ef6:	48                   	dec    %eax
  802ef7:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eff:	e9 d9 00 00 00       	jmp    802fdd <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	83 c0 08             	add    $0x8,%eax
  802f0a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f0d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f14:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f17:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f1a:	01 d0                	add    %edx,%eax
  802f1c:	48                   	dec    %eax
  802f1d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f20:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f23:	ba 00 00 00 00       	mov    $0x0,%edx
  802f28:	f7 75 c4             	divl   -0x3c(%ebp)
  802f2b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f2e:	29 d0                	sub    %edx,%eax
  802f30:	c1 e8 0c             	shr    $0xc,%eax
  802f33:	83 ec 0c             	sub    $0xc,%esp
  802f36:	50                   	push   %eax
  802f37:	e8 ad e6 ff ff       	call   8015e9 <sbrk>
  802f3c:	83 c4 10             	add    $0x10,%esp
  802f3f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802f42:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802f46:	75 0a                	jne    802f52 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802f48:	b8 00 00 00 00       	mov    $0x0,%eax
  802f4d:	e9 8b 00 00 00       	jmp    802fdd <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f52:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802f59:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f5c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802f5f:	01 d0                	add    %edx,%eax
  802f61:	48                   	dec    %eax
  802f62:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802f65:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f68:	ba 00 00 00 00       	mov    $0x0,%edx
  802f6d:	f7 75 b8             	divl   -0x48(%ebp)
  802f70:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f73:	29 d0                	sub    %edx,%eax
  802f75:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f78:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f7b:	01 d0                	add    %edx,%eax
  802f7d:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802f82:	a1 40 50 80 00       	mov    0x805040,%eax
  802f87:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802f8d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802f94:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f97:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f9a:	01 d0                	add    %edx,%eax
  802f9c:	48                   	dec    %eax
  802f9d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802fa0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802fa3:	ba 00 00 00 00       	mov    $0x0,%edx
  802fa8:	f7 75 b0             	divl   -0x50(%ebp)
  802fab:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802fae:	29 d0                	sub    %edx,%eax
  802fb0:	83 ec 04             	sub    $0x4,%esp
  802fb3:	6a 01                	push   $0x1
  802fb5:	50                   	push   %eax
  802fb6:	ff 75 bc             	pushl  -0x44(%ebp)
  802fb9:	e8 74 f5 ff ff       	call   802532 <set_block_data>
  802fbe:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802fc1:	83 ec 0c             	sub    $0xc,%esp
  802fc4:	ff 75 bc             	pushl  -0x44(%ebp)
  802fc7:	e8 36 04 00 00       	call   803402 <free_block>
  802fcc:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802fcf:	83 ec 0c             	sub    $0xc,%esp
  802fd2:	ff 75 08             	pushl  0x8(%ebp)
  802fd5:	e8 43 fa ff ff       	call   802a1d <alloc_block_BF>
  802fda:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802fdd:	c9                   	leave  
  802fde:	c3                   	ret    

00802fdf <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802fdf:	55                   	push   %ebp
  802fe0:	89 e5                	mov    %esp,%ebp
  802fe2:	53                   	push   %ebx
  802fe3:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802fe6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802fed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ff4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff8:	74 1e                	je     803018 <merging+0x39>
  802ffa:	ff 75 08             	pushl  0x8(%ebp)
  802ffd:	e8 df f1 ff ff       	call   8021e1 <get_block_size>
  803002:	83 c4 04             	add    $0x4,%esp
  803005:	89 c2                	mov    %eax,%edx
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	01 d0                	add    %edx,%eax
  80300c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80300f:	75 07                	jne    803018 <merging+0x39>
		prev_is_free = 1;
  803011:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803018:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80301c:	74 1e                	je     80303c <merging+0x5d>
  80301e:	ff 75 10             	pushl  0x10(%ebp)
  803021:	e8 bb f1 ff ff       	call   8021e1 <get_block_size>
  803026:	83 c4 04             	add    $0x4,%esp
  803029:	89 c2                	mov    %eax,%edx
  80302b:	8b 45 10             	mov    0x10(%ebp),%eax
  80302e:	01 d0                	add    %edx,%eax
  803030:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803033:	75 07                	jne    80303c <merging+0x5d>
		next_is_free = 1;
  803035:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80303c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803040:	0f 84 cc 00 00 00    	je     803112 <merging+0x133>
  803046:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80304a:	0f 84 c2 00 00 00    	je     803112 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803050:	ff 75 08             	pushl  0x8(%ebp)
  803053:	e8 89 f1 ff ff       	call   8021e1 <get_block_size>
  803058:	83 c4 04             	add    $0x4,%esp
  80305b:	89 c3                	mov    %eax,%ebx
  80305d:	ff 75 10             	pushl  0x10(%ebp)
  803060:	e8 7c f1 ff ff       	call   8021e1 <get_block_size>
  803065:	83 c4 04             	add    $0x4,%esp
  803068:	01 c3                	add    %eax,%ebx
  80306a:	ff 75 0c             	pushl  0xc(%ebp)
  80306d:	e8 6f f1 ff ff       	call   8021e1 <get_block_size>
  803072:	83 c4 04             	add    $0x4,%esp
  803075:	01 d8                	add    %ebx,%eax
  803077:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80307a:	6a 00                	push   $0x0
  80307c:	ff 75 ec             	pushl  -0x14(%ebp)
  80307f:	ff 75 08             	pushl  0x8(%ebp)
  803082:	e8 ab f4 ff ff       	call   802532 <set_block_data>
  803087:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80308a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80308e:	75 17                	jne    8030a7 <merging+0xc8>
  803090:	83 ec 04             	sub    $0x4,%esp
  803093:	68 a3 47 80 00       	push   $0x8047a3
  803098:	68 7d 01 00 00       	push   $0x17d
  80309d:	68 c1 47 80 00       	push   $0x8047c1
  8030a2:	e8 eb d4 ff ff       	call   800592 <_panic>
  8030a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	85 c0                	test   %eax,%eax
  8030ae:	74 10                	je     8030c0 <merging+0xe1>
  8030b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b3:	8b 00                	mov    (%eax),%eax
  8030b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030b8:	8b 52 04             	mov    0x4(%edx),%edx
  8030bb:	89 50 04             	mov    %edx,0x4(%eax)
  8030be:	eb 0b                	jmp    8030cb <merging+0xec>
  8030c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c3:	8b 40 04             	mov    0x4(%eax),%eax
  8030c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8030cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ce:	8b 40 04             	mov    0x4(%eax),%eax
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	74 0f                	je     8030e4 <merging+0x105>
  8030d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d8:	8b 40 04             	mov    0x4(%eax),%eax
  8030db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030de:	8b 12                	mov    (%edx),%edx
  8030e0:	89 10                	mov    %edx,(%eax)
  8030e2:	eb 0a                	jmp    8030ee <merging+0x10f>
  8030e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e7:	8b 00                	mov    (%eax),%eax
  8030e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803101:	a1 38 50 80 00       	mov    0x805038,%eax
  803106:	48                   	dec    %eax
  803107:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80310c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80310d:	e9 ea 02 00 00       	jmp    8033fc <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803112:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803116:	74 3b                	je     803153 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803118:	83 ec 0c             	sub    $0xc,%esp
  80311b:	ff 75 08             	pushl  0x8(%ebp)
  80311e:	e8 be f0 ff ff       	call   8021e1 <get_block_size>
  803123:	83 c4 10             	add    $0x10,%esp
  803126:	89 c3                	mov    %eax,%ebx
  803128:	83 ec 0c             	sub    $0xc,%esp
  80312b:	ff 75 10             	pushl  0x10(%ebp)
  80312e:	e8 ae f0 ff ff       	call   8021e1 <get_block_size>
  803133:	83 c4 10             	add    $0x10,%esp
  803136:	01 d8                	add    %ebx,%eax
  803138:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80313b:	83 ec 04             	sub    $0x4,%esp
  80313e:	6a 00                	push   $0x0
  803140:	ff 75 e8             	pushl  -0x18(%ebp)
  803143:	ff 75 08             	pushl  0x8(%ebp)
  803146:	e8 e7 f3 ff ff       	call   802532 <set_block_data>
  80314b:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80314e:	e9 a9 02 00 00       	jmp    8033fc <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803153:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803157:	0f 84 2d 01 00 00    	je     80328a <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80315d:	83 ec 0c             	sub    $0xc,%esp
  803160:	ff 75 10             	pushl  0x10(%ebp)
  803163:	e8 79 f0 ff ff       	call   8021e1 <get_block_size>
  803168:	83 c4 10             	add    $0x10,%esp
  80316b:	89 c3                	mov    %eax,%ebx
  80316d:	83 ec 0c             	sub    $0xc,%esp
  803170:	ff 75 0c             	pushl  0xc(%ebp)
  803173:	e8 69 f0 ff ff       	call   8021e1 <get_block_size>
  803178:	83 c4 10             	add    $0x10,%esp
  80317b:	01 d8                	add    %ebx,%eax
  80317d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803180:	83 ec 04             	sub    $0x4,%esp
  803183:	6a 00                	push   $0x0
  803185:	ff 75 e4             	pushl  -0x1c(%ebp)
  803188:	ff 75 10             	pushl  0x10(%ebp)
  80318b:	e8 a2 f3 ff ff       	call   802532 <set_block_data>
  803190:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803193:	8b 45 10             	mov    0x10(%ebp),%eax
  803196:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803199:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80319d:	74 06                	je     8031a5 <merging+0x1c6>
  80319f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031a3:	75 17                	jne    8031bc <merging+0x1dd>
  8031a5:	83 ec 04             	sub    $0x4,%esp
  8031a8:	68 68 48 80 00       	push   $0x804868
  8031ad:	68 8d 01 00 00       	push   $0x18d
  8031b2:	68 c1 47 80 00       	push   $0x8047c1
  8031b7:	e8 d6 d3 ff ff       	call   800592 <_panic>
  8031bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031bf:	8b 50 04             	mov    0x4(%eax),%edx
  8031c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c5:	89 50 04             	mov    %edx,0x4(%eax)
  8031c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031ce:	89 10                	mov    %edx,(%eax)
  8031d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d3:	8b 40 04             	mov    0x4(%eax),%eax
  8031d6:	85 c0                	test   %eax,%eax
  8031d8:	74 0d                	je     8031e7 <merging+0x208>
  8031da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031dd:	8b 40 04             	mov    0x4(%eax),%eax
  8031e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031e3:	89 10                	mov    %edx,(%eax)
  8031e5:	eb 08                	jmp    8031ef <merging+0x210>
  8031e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031f5:	89 50 04             	mov    %edx,0x4(%eax)
  8031f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8031fd:	40                   	inc    %eax
  8031fe:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803203:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803207:	75 17                	jne    803220 <merging+0x241>
  803209:	83 ec 04             	sub    $0x4,%esp
  80320c:	68 a3 47 80 00       	push   $0x8047a3
  803211:	68 8e 01 00 00       	push   $0x18e
  803216:	68 c1 47 80 00       	push   $0x8047c1
  80321b:	e8 72 d3 ff ff       	call   800592 <_panic>
  803220:	8b 45 0c             	mov    0xc(%ebp),%eax
  803223:	8b 00                	mov    (%eax),%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	74 10                	je     803239 <merging+0x25a>
  803229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803231:	8b 52 04             	mov    0x4(%edx),%edx
  803234:	89 50 04             	mov    %edx,0x4(%eax)
  803237:	eb 0b                	jmp    803244 <merging+0x265>
  803239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80323c:	8b 40 04             	mov    0x4(%eax),%eax
  80323f:	a3 30 50 80 00       	mov    %eax,0x805030
  803244:	8b 45 0c             	mov    0xc(%ebp),%eax
  803247:	8b 40 04             	mov    0x4(%eax),%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	74 0f                	je     80325d <merging+0x27e>
  80324e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803251:	8b 40 04             	mov    0x4(%eax),%eax
  803254:	8b 55 0c             	mov    0xc(%ebp),%edx
  803257:	8b 12                	mov    (%edx),%edx
  803259:	89 10                	mov    %edx,(%eax)
  80325b:	eb 0a                	jmp    803267 <merging+0x288>
  80325d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803260:	8b 00                	mov    (%eax),%eax
  803262:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80326a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803270:	8b 45 0c             	mov    0xc(%ebp),%eax
  803273:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327a:	a1 38 50 80 00       	mov    0x805038,%eax
  80327f:	48                   	dec    %eax
  803280:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803285:	e9 72 01 00 00       	jmp    8033fc <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80328a:	8b 45 10             	mov    0x10(%ebp),%eax
  80328d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803290:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803294:	74 79                	je     80330f <merging+0x330>
  803296:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80329a:	74 73                	je     80330f <merging+0x330>
  80329c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a0:	74 06                	je     8032a8 <merging+0x2c9>
  8032a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032a6:	75 17                	jne    8032bf <merging+0x2e0>
  8032a8:	83 ec 04             	sub    $0x4,%esp
  8032ab:	68 34 48 80 00       	push   $0x804834
  8032b0:	68 94 01 00 00       	push   $0x194
  8032b5:	68 c1 47 80 00       	push   $0x8047c1
  8032ba:	e8 d3 d2 ff ff       	call   800592 <_panic>
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	8b 10                	mov    (%eax),%edx
  8032c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c7:	89 10                	mov    %edx,(%eax)
  8032c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032cc:	8b 00                	mov    (%eax),%eax
  8032ce:	85 c0                	test   %eax,%eax
  8032d0:	74 0b                	je     8032dd <merging+0x2fe>
  8032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d5:	8b 00                	mov    (%eax),%eax
  8032d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032da:	89 50 04             	mov    %edx,0x4(%eax)
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032e3:	89 10                	mov    %edx,(%eax)
  8032e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032eb:	89 50 04             	mov    %edx,0x4(%eax)
  8032ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	85 c0                	test   %eax,%eax
  8032f5:	75 08                	jne    8032ff <merging+0x320>
  8032f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8032ff:	a1 38 50 80 00       	mov    0x805038,%eax
  803304:	40                   	inc    %eax
  803305:	a3 38 50 80 00       	mov    %eax,0x805038
  80330a:	e9 ce 00 00 00       	jmp    8033dd <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80330f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803313:	74 65                	je     80337a <merging+0x39b>
  803315:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803319:	75 17                	jne    803332 <merging+0x353>
  80331b:	83 ec 04             	sub    $0x4,%esp
  80331e:	68 10 48 80 00       	push   $0x804810
  803323:	68 95 01 00 00       	push   $0x195
  803328:	68 c1 47 80 00       	push   $0x8047c1
  80332d:	e8 60 d2 ff ff       	call   800592 <_panic>
  803332:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803338:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80333b:	89 50 04             	mov    %edx,0x4(%eax)
  80333e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 0c                	je     803354 <merging+0x375>
  803348:	a1 30 50 80 00       	mov    0x805030,%eax
  80334d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803350:	89 10                	mov    %edx,(%eax)
  803352:	eb 08                	jmp    80335c <merging+0x37d>
  803354:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803357:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80335c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80335f:	a3 30 50 80 00       	mov    %eax,0x805030
  803364:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803367:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336d:	a1 38 50 80 00       	mov    0x805038,%eax
  803372:	40                   	inc    %eax
  803373:	a3 38 50 80 00       	mov    %eax,0x805038
  803378:	eb 63                	jmp    8033dd <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80337a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80337e:	75 17                	jne    803397 <merging+0x3b8>
  803380:	83 ec 04             	sub    $0x4,%esp
  803383:	68 dc 47 80 00       	push   $0x8047dc
  803388:	68 98 01 00 00       	push   $0x198
  80338d:	68 c1 47 80 00       	push   $0x8047c1
  803392:	e8 fb d1 ff ff       	call   800592 <_panic>
  803397:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80339d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033a0:	89 10                	mov    %edx,(%eax)
  8033a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033a5:	8b 00                	mov    (%eax),%eax
  8033a7:	85 c0                	test   %eax,%eax
  8033a9:	74 0d                	je     8033b8 <merging+0x3d9>
  8033ab:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033b3:	89 50 04             	mov    %edx,0x4(%eax)
  8033b6:	eb 08                	jmp    8033c0 <merging+0x3e1>
  8033b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8033c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033c3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d2:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d7:	40                   	inc    %eax
  8033d8:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8033dd:	83 ec 0c             	sub    $0xc,%esp
  8033e0:	ff 75 10             	pushl  0x10(%ebp)
  8033e3:	e8 f9 ed ff ff       	call   8021e1 <get_block_size>
  8033e8:	83 c4 10             	add    $0x10,%esp
  8033eb:	83 ec 04             	sub    $0x4,%esp
  8033ee:	6a 00                	push   $0x0
  8033f0:	50                   	push   %eax
  8033f1:	ff 75 10             	pushl  0x10(%ebp)
  8033f4:	e8 39 f1 ff ff       	call   802532 <set_block_data>
  8033f9:	83 c4 10             	add    $0x10,%esp
	}
}
  8033fc:	90                   	nop
  8033fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803400:	c9                   	leave  
  803401:	c3                   	ret    

00803402 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803402:	55                   	push   %ebp
  803403:	89 e5                	mov    %esp,%ebp
  803405:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803408:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80340d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803410:	a1 30 50 80 00       	mov    0x805030,%eax
  803415:	3b 45 08             	cmp    0x8(%ebp),%eax
  803418:	73 1b                	jae    803435 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80341a:	a1 30 50 80 00       	mov    0x805030,%eax
  80341f:	83 ec 04             	sub    $0x4,%esp
  803422:	ff 75 08             	pushl  0x8(%ebp)
  803425:	6a 00                	push   $0x0
  803427:	50                   	push   %eax
  803428:	e8 b2 fb ff ff       	call   802fdf <merging>
  80342d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803430:	e9 8b 00 00 00       	jmp    8034c0 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803435:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80343a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80343d:	76 18                	jbe    803457 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80343f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803444:	83 ec 04             	sub    $0x4,%esp
  803447:	ff 75 08             	pushl  0x8(%ebp)
  80344a:	50                   	push   %eax
  80344b:	6a 00                	push   $0x0
  80344d:	e8 8d fb ff ff       	call   802fdf <merging>
  803452:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803455:	eb 69                	jmp    8034c0 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803457:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80345c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80345f:	eb 39                	jmp    80349a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803464:	3b 45 08             	cmp    0x8(%ebp),%eax
  803467:	73 29                	jae    803492 <free_block+0x90>
  803469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346c:	8b 00                	mov    (%eax),%eax
  80346e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803471:	76 1f                	jbe    803492 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80347b:	83 ec 04             	sub    $0x4,%esp
  80347e:	ff 75 08             	pushl  0x8(%ebp)
  803481:	ff 75 f0             	pushl  -0x10(%ebp)
  803484:	ff 75 f4             	pushl  -0xc(%ebp)
  803487:	e8 53 fb ff ff       	call   802fdf <merging>
  80348c:	83 c4 10             	add    $0x10,%esp
			break;
  80348f:	90                   	nop
		}
	}
}
  803490:	eb 2e                	jmp    8034c0 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803492:	a1 34 50 80 00       	mov    0x805034,%eax
  803497:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80349a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349e:	74 07                	je     8034a7 <free_block+0xa5>
  8034a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	eb 05                	jmp    8034ac <free_block+0xaa>
  8034a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ac:	a3 34 50 80 00       	mov    %eax,0x805034
  8034b1:	a1 34 50 80 00       	mov    0x805034,%eax
  8034b6:	85 c0                	test   %eax,%eax
  8034b8:	75 a7                	jne    803461 <free_block+0x5f>
  8034ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034be:	75 a1                	jne    803461 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8034c0:	90                   	nop
  8034c1:	c9                   	leave  
  8034c2:	c3                   	ret    

008034c3 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8034c3:	55                   	push   %ebp
  8034c4:	89 e5                	mov    %esp,%ebp
  8034c6:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8034c9:	ff 75 08             	pushl  0x8(%ebp)
  8034cc:	e8 10 ed ff ff       	call   8021e1 <get_block_size>
  8034d1:	83 c4 04             	add    $0x4,%esp
  8034d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8034d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8034de:	eb 17                	jmp    8034f7 <copy_data+0x34>
  8034e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8034e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e6:	01 c2                	add    %eax,%edx
  8034e8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	01 c8                	add    %ecx,%eax
  8034f0:	8a 00                	mov    (%eax),%al
  8034f2:	88 02                	mov    %al,(%edx)
  8034f4:	ff 45 fc             	incl   -0x4(%ebp)
  8034f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8034fd:	72 e1                	jb     8034e0 <copy_data+0x1d>
}
  8034ff:	90                   	nop
  803500:	c9                   	leave  
  803501:	c3                   	ret    

00803502 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803502:	55                   	push   %ebp
  803503:	89 e5                	mov    %esp,%ebp
  803505:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803508:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80350c:	75 23                	jne    803531 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80350e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803512:	74 13                	je     803527 <realloc_block_FF+0x25>
  803514:	83 ec 0c             	sub    $0xc,%esp
  803517:	ff 75 0c             	pushl  0xc(%ebp)
  80351a:	e8 42 f0 ff ff       	call   802561 <alloc_block_FF>
  80351f:	83 c4 10             	add    $0x10,%esp
  803522:	e9 e4 06 00 00       	jmp    803c0b <realloc_block_FF+0x709>
		return NULL;
  803527:	b8 00 00 00 00       	mov    $0x0,%eax
  80352c:	e9 da 06 00 00       	jmp    803c0b <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803531:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803535:	75 18                	jne    80354f <realloc_block_FF+0x4d>
	{
		free_block(va);
  803537:	83 ec 0c             	sub    $0xc,%esp
  80353a:	ff 75 08             	pushl  0x8(%ebp)
  80353d:	e8 c0 fe ff ff       	call   803402 <free_block>
  803542:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803545:	b8 00 00 00 00       	mov    $0x0,%eax
  80354a:	e9 bc 06 00 00       	jmp    803c0b <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  80354f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803553:	77 07                	ja     80355c <realloc_block_FF+0x5a>
  803555:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80355c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355f:	83 e0 01             	and    $0x1,%eax
  803562:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803565:	8b 45 0c             	mov    0xc(%ebp),%eax
  803568:	83 c0 08             	add    $0x8,%eax
  80356b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80356e:	83 ec 0c             	sub    $0xc,%esp
  803571:	ff 75 08             	pushl  0x8(%ebp)
  803574:	e8 68 ec ff ff       	call   8021e1 <get_block_size>
  803579:	83 c4 10             	add    $0x10,%esp
  80357c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80357f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803582:	83 e8 08             	sub    $0x8,%eax
  803585:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803588:	8b 45 08             	mov    0x8(%ebp),%eax
  80358b:	83 e8 04             	sub    $0x4,%eax
  80358e:	8b 00                	mov    (%eax),%eax
  803590:	83 e0 fe             	and    $0xfffffffe,%eax
  803593:	89 c2                	mov    %eax,%edx
  803595:	8b 45 08             	mov    0x8(%ebp),%eax
  803598:	01 d0                	add    %edx,%eax
  80359a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80359d:	83 ec 0c             	sub    $0xc,%esp
  8035a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035a3:	e8 39 ec ff ff       	call   8021e1 <get_block_size>
  8035a8:	83 c4 10             	add    $0x10,%esp
  8035ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8035ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035b1:	83 e8 08             	sub    $0x8,%eax
  8035b4:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8035b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ba:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035bd:	75 08                	jne    8035c7 <realloc_block_FF+0xc5>
	{
		 return va;
  8035bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c2:	e9 44 06 00 00       	jmp    803c0b <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8035c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ca:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035cd:	0f 83 d5 03 00 00    	jae    8039a8 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8035d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d6:	2b 45 0c             	sub    0xc(%ebp),%eax
  8035d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8035dc:	83 ec 0c             	sub    $0xc,%esp
  8035df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035e2:	e8 13 ec ff ff       	call   8021fa <is_free_block>
  8035e7:	83 c4 10             	add    $0x10,%esp
  8035ea:	84 c0                	test   %al,%al
  8035ec:	0f 84 3b 01 00 00    	je     80372d <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8035f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035f8:	01 d0                	add    %edx,%eax
  8035fa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8035fd:	83 ec 04             	sub    $0x4,%esp
  803600:	6a 01                	push   $0x1
  803602:	ff 75 f0             	pushl  -0x10(%ebp)
  803605:	ff 75 08             	pushl  0x8(%ebp)
  803608:	e8 25 ef ff ff       	call   802532 <set_block_data>
  80360d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803610:	8b 45 08             	mov    0x8(%ebp),%eax
  803613:	83 e8 04             	sub    $0x4,%eax
  803616:	8b 00                	mov    (%eax),%eax
  803618:	83 e0 fe             	and    $0xfffffffe,%eax
  80361b:	89 c2                	mov    %eax,%edx
  80361d:	8b 45 08             	mov    0x8(%ebp),%eax
  803620:	01 d0                	add    %edx,%eax
  803622:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803625:	83 ec 04             	sub    $0x4,%esp
  803628:	6a 00                	push   $0x0
  80362a:	ff 75 cc             	pushl  -0x34(%ebp)
  80362d:	ff 75 c8             	pushl  -0x38(%ebp)
  803630:	e8 fd ee ff ff       	call   802532 <set_block_data>
  803635:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803638:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80363c:	74 06                	je     803644 <realloc_block_FF+0x142>
  80363e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803642:	75 17                	jne    80365b <realloc_block_FF+0x159>
  803644:	83 ec 04             	sub    $0x4,%esp
  803647:	68 34 48 80 00       	push   $0x804834
  80364c:	68 f6 01 00 00       	push   $0x1f6
  803651:	68 c1 47 80 00       	push   $0x8047c1
  803656:	e8 37 cf ff ff       	call   800592 <_panic>
  80365b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365e:	8b 10                	mov    (%eax),%edx
  803660:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803663:	89 10                	mov    %edx,(%eax)
  803665:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	85 c0                	test   %eax,%eax
  80366c:	74 0b                	je     803679 <realloc_block_FF+0x177>
  80366e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803671:	8b 00                	mov    (%eax),%eax
  803673:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803676:	89 50 04             	mov    %edx,0x4(%eax)
  803679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80367f:	89 10                	mov    %edx,(%eax)
  803681:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803684:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803687:	89 50 04             	mov    %edx,0x4(%eax)
  80368a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	85 c0                	test   %eax,%eax
  803691:	75 08                	jne    80369b <realloc_block_FF+0x199>
  803693:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803696:	a3 30 50 80 00       	mov    %eax,0x805030
  80369b:	a1 38 50 80 00       	mov    0x805038,%eax
  8036a0:	40                   	inc    %eax
  8036a1:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8036a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036aa:	75 17                	jne    8036c3 <realloc_block_FF+0x1c1>
  8036ac:	83 ec 04             	sub    $0x4,%esp
  8036af:	68 a3 47 80 00       	push   $0x8047a3
  8036b4:	68 f7 01 00 00       	push   $0x1f7
  8036b9:	68 c1 47 80 00       	push   $0x8047c1
  8036be:	e8 cf ce ff ff       	call   800592 <_panic>
  8036c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c6:	8b 00                	mov    (%eax),%eax
  8036c8:	85 c0                	test   %eax,%eax
  8036ca:	74 10                	je     8036dc <realloc_block_FF+0x1da>
  8036cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036cf:	8b 00                	mov    (%eax),%eax
  8036d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d4:	8b 52 04             	mov    0x4(%edx),%edx
  8036d7:	89 50 04             	mov    %edx,0x4(%eax)
  8036da:	eb 0b                	jmp    8036e7 <realloc_block_FF+0x1e5>
  8036dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036df:	8b 40 04             	mov    0x4(%eax),%eax
  8036e2:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ea:	8b 40 04             	mov    0x4(%eax),%eax
  8036ed:	85 c0                	test   %eax,%eax
  8036ef:	74 0f                	je     803700 <realloc_block_FF+0x1fe>
  8036f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f4:	8b 40 04             	mov    0x4(%eax),%eax
  8036f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036fa:	8b 12                	mov    (%edx),%edx
  8036fc:	89 10                	mov    %edx,(%eax)
  8036fe:	eb 0a                	jmp    80370a <realloc_block_FF+0x208>
  803700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803703:	8b 00                	mov    (%eax),%eax
  803705:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80370a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803716:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371d:	a1 38 50 80 00       	mov    0x805038,%eax
  803722:	48                   	dec    %eax
  803723:	a3 38 50 80 00       	mov    %eax,0x805038
  803728:	e9 73 02 00 00       	jmp    8039a0 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80372d:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803731:	0f 86 69 02 00 00    	jbe    8039a0 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803737:	83 ec 04             	sub    $0x4,%esp
  80373a:	6a 01                	push   $0x1
  80373c:	ff 75 f0             	pushl  -0x10(%ebp)
  80373f:	ff 75 08             	pushl  0x8(%ebp)
  803742:	e8 eb ed ff ff       	call   802532 <set_block_data>
  803747:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80374a:	8b 45 08             	mov    0x8(%ebp),%eax
  80374d:	83 e8 04             	sub    $0x4,%eax
  803750:	8b 00                	mov    (%eax),%eax
  803752:	83 e0 fe             	and    $0xfffffffe,%eax
  803755:	89 c2                	mov    %eax,%edx
  803757:	8b 45 08             	mov    0x8(%ebp),%eax
  80375a:	01 d0                	add    %edx,%eax
  80375c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80375f:	a1 38 50 80 00       	mov    0x805038,%eax
  803764:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803767:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80376b:	75 68                	jne    8037d5 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80376d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803771:	75 17                	jne    80378a <realloc_block_FF+0x288>
  803773:	83 ec 04             	sub    $0x4,%esp
  803776:	68 dc 47 80 00       	push   $0x8047dc
  80377b:	68 06 02 00 00       	push   $0x206
  803780:	68 c1 47 80 00       	push   $0x8047c1
  803785:	e8 08 ce ff ff       	call   800592 <_panic>
  80378a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803790:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803793:	89 10                	mov    %edx,(%eax)
  803795:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803798:	8b 00                	mov    (%eax),%eax
  80379a:	85 c0                	test   %eax,%eax
  80379c:	74 0d                	je     8037ab <realloc_block_FF+0x2a9>
  80379e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037a6:	89 50 04             	mov    %edx,0x4(%eax)
  8037a9:	eb 08                	jmp    8037b3 <realloc_block_FF+0x2b1>
  8037ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8037b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ca:	40                   	inc    %eax
  8037cb:	a3 38 50 80 00       	mov    %eax,0x805038
  8037d0:	e9 b0 01 00 00       	jmp    803985 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8037d5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037da:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037dd:	76 68                	jbe    803847 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8037df:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037e3:	75 17                	jne    8037fc <realloc_block_FF+0x2fa>
  8037e5:	83 ec 04             	sub    $0x4,%esp
  8037e8:	68 dc 47 80 00       	push   $0x8047dc
  8037ed:	68 0b 02 00 00       	push   $0x20b
  8037f2:	68 c1 47 80 00       	push   $0x8047c1
  8037f7:	e8 96 cd ff ff       	call   800592 <_panic>
  8037fc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803802:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803805:	89 10                	mov    %edx,(%eax)
  803807:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	85 c0                	test   %eax,%eax
  80380e:	74 0d                	je     80381d <realloc_block_FF+0x31b>
  803810:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803815:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803818:	89 50 04             	mov    %edx,0x4(%eax)
  80381b:	eb 08                	jmp    803825 <realloc_block_FF+0x323>
  80381d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803820:	a3 30 50 80 00       	mov    %eax,0x805030
  803825:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803828:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80382d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803830:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803837:	a1 38 50 80 00       	mov    0x805038,%eax
  80383c:	40                   	inc    %eax
  80383d:	a3 38 50 80 00       	mov    %eax,0x805038
  803842:	e9 3e 01 00 00       	jmp    803985 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803847:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80384c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80384f:	73 68                	jae    8038b9 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803851:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803855:	75 17                	jne    80386e <realloc_block_FF+0x36c>
  803857:	83 ec 04             	sub    $0x4,%esp
  80385a:	68 10 48 80 00       	push   $0x804810
  80385f:	68 10 02 00 00       	push   $0x210
  803864:	68 c1 47 80 00       	push   $0x8047c1
  803869:	e8 24 cd ff ff       	call   800592 <_panic>
  80386e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803874:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803877:	89 50 04             	mov    %edx,0x4(%eax)
  80387a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80387d:	8b 40 04             	mov    0x4(%eax),%eax
  803880:	85 c0                	test   %eax,%eax
  803882:	74 0c                	je     803890 <realloc_block_FF+0x38e>
  803884:	a1 30 50 80 00       	mov    0x805030,%eax
  803889:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80388c:	89 10                	mov    %edx,(%eax)
  80388e:	eb 08                	jmp    803898 <realloc_block_FF+0x396>
  803890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803893:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80389b:	a3 30 50 80 00       	mov    %eax,0x805030
  8038a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a9:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ae:	40                   	inc    %eax
  8038af:	a3 38 50 80 00       	mov    %eax,0x805038
  8038b4:	e9 cc 00 00 00       	jmp    803985 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8038b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8038c0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038c8:	e9 8a 00 00 00       	jmp    803957 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8038cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8038d3:	73 7a                	jae    80394f <realloc_block_FF+0x44d>
  8038d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d8:	8b 00                	mov    (%eax),%eax
  8038da:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8038dd:	73 70                	jae    80394f <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8038df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038e3:	74 06                	je     8038eb <realloc_block_FF+0x3e9>
  8038e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038e9:	75 17                	jne    803902 <realloc_block_FF+0x400>
  8038eb:	83 ec 04             	sub    $0x4,%esp
  8038ee:	68 34 48 80 00       	push   $0x804834
  8038f3:	68 1a 02 00 00       	push   $0x21a
  8038f8:	68 c1 47 80 00       	push   $0x8047c1
  8038fd:	e8 90 cc ff ff       	call   800592 <_panic>
  803902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803905:	8b 10                	mov    (%eax),%edx
  803907:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80390a:	89 10                	mov    %edx,(%eax)
  80390c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80390f:	8b 00                	mov    (%eax),%eax
  803911:	85 c0                	test   %eax,%eax
  803913:	74 0b                	je     803920 <realloc_block_FF+0x41e>
  803915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803918:	8b 00                	mov    (%eax),%eax
  80391a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80391d:	89 50 04             	mov    %edx,0x4(%eax)
  803920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803923:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803926:	89 10                	mov    %edx,(%eax)
  803928:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80392b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80392e:	89 50 04             	mov    %edx,0x4(%eax)
  803931:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803934:	8b 00                	mov    (%eax),%eax
  803936:	85 c0                	test   %eax,%eax
  803938:	75 08                	jne    803942 <realloc_block_FF+0x440>
  80393a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80393d:	a3 30 50 80 00       	mov    %eax,0x805030
  803942:	a1 38 50 80 00       	mov    0x805038,%eax
  803947:	40                   	inc    %eax
  803948:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80394d:	eb 36                	jmp    803985 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80394f:	a1 34 50 80 00       	mov    0x805034,%eax
  803954:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803957:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80395b:	74 07                	je     803964 <realloc_block_FF+0x462>
  80395d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803960:	8b 00                	mov    (%eax),%eax
  803962:	eb 05                	jmp    803969 <realloc_block_FF+0x467>
  803964:	b8 00 00 00 00       	mov    $0x0,%eax
  803969:	a3 34 50 80 00       	mov    %eax,0x805034
  80396e:	a1 34 50 80 00       	mov    0x805034,%eax
  803973:	85 c0                	test   %eax,%eax
  803975:	0f 85 52 ff ff ff    	jne    8038cd <realloc_block_FF+0x3cb>
  80397b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80397f:	0f 85 48 ff ff ff    	jne    8038cd <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803985:	83 ec 04             	sub    $0x4,%esp
  803988:	6a 00                	push   $0x0
  80398a:	ff 75 d8             	pushl  -0x28(%ebp)
  80398d:	ff 75 d4             	pushl  -0x2c(%ebp)
  803990:	e8 9d eb ff ff       	call   802532 <set_block_data>
  803995:	83 c4 10             	add    $0x10,%esp
				return va;
  803998:	8b 45 08             	mov    0x8(%ebp),%eax
  80399b:	e9 6b 02 00 00       	jmp    803c0b <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8039a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a3:	e9 63 02 00 00       	jmp    803c0b <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8039a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ab:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039ae:	0f 86 4d 02 00 00    	jbe    803c01 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8039b4:	83 ec 0c             	sub    $0xc,%esp
  8039b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039ba:	e8 3b e8 ff ff       	call   8021fa <is_free_block>
  8039bf:	83 c4 10             	add    $0x10,%esp
  8039c2:	84 c0                	test   %al,%al
  8039c4:	0f 84 37 02 00 00    	je     803c01 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8039ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039cd:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8039d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8039d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8039d9:	76 38                	jbe    803a13 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8039db:	83 ec 0c             	sub    $0xc,%esp
  8039de:	ff 75 0c             	pushl  0xc(%ebp)
  8039e1:	e8 7b eb ff ff       	call   802561 <alloc_block_FF>
  8039e6:	83 c4 10             	add    $0x10,%esp
  8039e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8039ec:	83 ec 08             	sub    $0x8,%esp
  8039ef:	ff 75 c0             	pushl  -0x40(%ebp)
  8039f2:	ff 75 08             	pushl  0x8(%ebp)
  8039f5:	e8 c9 fa ff ff       	call   8034c3 <copy_data>
  8039fa:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8039fd:	83 ec 0c             	sub    $0xc,%esp
  803a00:	ff 75 08             	pushl  0x8(%ebp)
  803a03:	e8 fa f9 ff ff       	call   803402 <free_block>
  803a08:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803a0b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a0e:	e9 f8 01 00 00       	jmp    803c0b <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803a13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a16:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803a19:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803a1c:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803a20:	0f 87 a0 00 00 00    	ja     803ac6 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803a26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a2a:	75 17                	jne    803a43 <realloc_block_FF+0x541>
  803a2c:	83 ec 04             	sub    $0x4,%esp
  803a2f:	68 a3 47 80 00       	push   $0x8047a3
  803a34:	68 38 02 00 00       	push   $0x238
  803a39:	68 c1 47 80 00       	push   $0x8047c1
  803a3e:	e8 4f cb ff ff       	call   800592 <_panic>
  803a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a46:	8b 00                	mov    (%eax),%eax
  803a48:	85 c0                	test   %eax,%eax
  803a4a:	74 10                	je     803a5c <realloc_block_FF+0x55a>
  803a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4f:	8b 00                	mov    (%eax),%eax
  803a51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a54:	8b 52 04             	mov    0x4(%edx),%edx
  803a57:	89 50 04             	mov    %edx,0x4(%eax)
  803a5a:	eb 0b                	jmp    803a67 <realloc_block_FF+0x565>
  803a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5f:	8b 40 04             	mov    0x4(%eax),%eax
  803a62:	a3 30 50 80 00       	mov    %eax,0x805030
  803a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6a:	8b 40 04             	mov    0x4(%eax),%eax
  803a6d:	85 c0                	test   %eax,%eax
  803a6f:	74 0f                	je     803a80 <realloc_block_FF+0x57e>
  803a71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a74:	8b 40 04             	mov    0x4(%eax),%eax
  803a77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a7a:	8b 12                	mov    (%edx),%edx
  803a7c:	89 10                	mov    %edx,(%eax)
  803a7e:	eb 0a                	jmp    803a8a <realloc_block_FF+0x588>
  803a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a83:	8b 00                	mov    (%eax),%eax
  803a85:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a9d:	a1 38 50 80 00       	mov    0x805038,%eax
  803aa2:	48                   	dec    %eax
  803aa3:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803aa8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aae:	01 d0                	add    %edx,%eax
  803ab0:	83 ec 04             	sub    $0x4,%esp
  803ab3:	6a 01                	push   $0x1
  803ab5:	50                   	push   %eax
  803ab6:	ff 75 08             	pushl  0x8(%ebp)
  803ab9:	e8 74 ea ff ff       	call   802532 <set_block_data>
  803abe:	83 c4 10             	add    $0x10,%esp
  803ac1:	e9 36 01 00 00       	jmp    803bfc <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803ac6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ac9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803acc:	01 d0                	add    %edx,%eax
  803ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803ad1:	83 ec 04             	sub    $0x4,%esp
  803ad4:	6a 01                	push   $0x1
  803ad6:	ff 75 f0             	pushl  -0x10(%ebp)
  803ad9:	ff 75 08             	pushl  0x8(%ebp)
  803adc:	e8 51 ea ff ff       	call   802532 <set_block_data>
  803ae1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae7:	83 e8 04             	sub    $0x4,%eax
  803aea:	8b 00                	mov    (%eax),%eax
  803aec:	83 e0 fe             	and    $0xfffffffe,%eax
  803aef:	89 c2                	mov    %eax,%edx
  803af1:	8b 45 08             	mov    0x8(%ebp),%eax
  803af4:	01 d0                	add    %edx,%eax
  803af6:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803af9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803afd:	74 06                	je     803b05 <realloc_block_FF+0x603>
  803aff:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803b03:	75 17                	jne    803b1c <realloc_block_FF+0x61a>
  803b05:	83 ec 04             	sub    $0x4,%esp
  803b08:	68 34 48 80 00       	push   $0x804834
  803b0d:	68 44 02 00 00       	push   $0x244
  803b12:	68 c1 47 80 00       	push   $0x8047c1
  803b17:	e8 76 ca ff ff       	call   800592 <_panic>
  803b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1f:	8b 10                	mov    (%eax),%edx
  803b21:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b24:	89 10                	mov    %edx,(%eax)
  803b26:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b29:	8b 00                	mov    (%eax),%eax
  803b2b:	85 c0                	test   %eax,%eax
  803b2d:	74 0b                	je     803b3a <realloc_block_FF+0x638>
  803b2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b32:	8b 00                	mov    (%eax),%eax
  803b34:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803b37:	89 50 04             	mov    %edx,0x4(%eax)
  803b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b3d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803b40:	89 10                	mov    %edx,(%eax)
  803b42:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b48:	89 50 04             	mov    %edx,0x4(%eax)
  803b4b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b4e:	8b 00                	mov    (%eax),%eax
  803b50:	85 c0                	test   %eax,%eax
  803b52:	75 08                	jne    803b5c <realloc_block_FF+0x65a>
  803b54:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b57:	a3 30 50 80 00       	mov    %eax,0x805030
  803b5c:	a1 38 50 80 00       	mov    0x805038,%eax
  803b61:	40                   	inc    %eax
  803b62:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803b67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b6b:	75 17                	jne    803b84 <realloc_block_FF+0x682>
  803b6d:	83 ec 04             	sub    $0x4,%esp
  803b70:	68 a3 47 80 00       	push   $0x8047a3
  803b75:	68 45 02 00 00       	push   $0x245
  803b7a:	68 c1 47 80 00       	push   $0x8047c1
  803b7f:	e8 0e ca ff ff       	call   800592 <_panic>
  803b84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b87:	8b 00                	mov    (%eax),%eax
  803b89:	85 c0                	test   %eax,%eax
  803b8b:	74 10                	je     803b9d <realloc_block_FF+0x69b>
  803b8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b90:	8b 00                	mov    (%eax),%eax
  803b92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b95:	8b 52 04             	mov    0x4(%edx),%edx
  803b98:	89 50 04             	mov    %edx,0x4(%eax)
  803b9b:	eb 0b                	jmp    803ba8 <realloc_block_FF+0x6a6>
  803b9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba0:	8b 40 04             	mov    0x4(%eax),%eax
  803ba3:	a3 30 50 80 00       	mov    %eax,0x805030
  803ba8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bab:	8b 40 04             	mov    0x4(%eax),%eax
  803bae:	85 c0                	test   %eax,%eax
  803bb0:	74 0f                	je     803bc1 <realloc_block_FF+0x6bf>
  803bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb5:	8b 40 04             	mov    0x4(%eax),%eax
  803bb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bbb:	8b 12                	mov    (%edx),%edx
  803bbd:	89 10                	mov    %edx,(%eax)
  803bbf:	eb 0a                	jmp    803bcb <realloc_block_FF+0x6c9>
  803bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc4:	8b 00                	mov    (%eax),%eax
  803bc6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bde:	a1 38 50 80 00       	mov    0x805038,%eax
  803be3:	48                   	dec    %eax
  803be4:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803be9:	83 ec 04             	sub    $0x4,%esp
  803bec:	6a 00                	push   $0x0
  803bee:	ff 75 bc             	pushl  -0x44(%ebp)
  803bf1:	ff 75 b8             	pushl  -0x48(%ebp)
  803bf4:	e8 39 e9 ff ff       	call   802532 <set_block_data>
  803bf9:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  803bff:	eb 0a                	jmp    803c0b <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803c01:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803c08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803c0b:	c9                   	leave  
  803c0c:	c3                   	ret    

00803c0d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803c0d:	55                   	push   %ebp
  803c0e:	89 e5                	mov    %esp,%ebp
  803c10:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803c13:	83 ec 04             	sub    $0x4,%esp
  803c16:	68 a0 48 80 00       	push   $0x8048a0
  803c1b:	68 58 02 00 00       	push   $0x258
  803c20:	68 c1 47 80 00       	push   $0x8047c1
  803c25:	e8 68 c9 ff ff       	call   800592 <_panic>

00803c2a <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803c2a:	55                   	push   %ebp
  803c2b:	89 e5                	mov    %esp,%ebp
  803c2d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803c30:	83 ec 04             	sub    $0x4,%esp
  803c33:	68 c8 48 80 00       	push   $0x8048c8
  803c38:	68 61 02 00 00       	push   $0x261
  803c3d:	68 c1 47 80 00       	push   $0x8047c1
  803c42:	e8 4b c9 ff ff       	call   800592 <_panic>
  803c47:	90                   	nop

00803c48 <__udivdi3>:
  803c48:	55                   	push   %ebp
  803c49:	57                   	push   %edi
  803c4a:	56                   	push   %esi
  803c4b:	53                   	push   %ebx
  803c4c:	83 ec 1c             	sub    $0x1c,%esp
  803c4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c5f:	89 ca                	mov    %ecx,%edx
  803c61:	89 f8                	mov    %edi,%eax
  803c63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c67:	85 f6                	test   %esi,%esi
  803c69:	75 2d                	jne    803c98 <__udivdi3+0x50>
  803c6b:	39 cf                	cmp    %ecx,%edi
  803c6d:	77 65                	ja     803cd4 <__udivdi3+0x8c>
  803c6f:	89 fd                	mov    %edi,%ebp
  803c71:	85 ff                	test   %edi,%edi
  803c73:	75 0b                	jne    803c80 <__udivdi3+0x38>
  803c75:	b8 01 00 00 00       	mov    $0x1,%eax
  803c7a:	31 d2                	xor    %edx,%edx
  803c7c:	f7 f7                	div    %edi
  803c7e:	89 c5                	mov    %eax,%ebp
  803c80:	31 d2                	xor    %edx,%edx
  803c82:	89 c8                	mov    %ecx,%eax
  803c84:	f7 f5                	div    %ebp
  803c86:	89 c1                	mov    %eax,%ecx
  803c88:	89 d8                	mov    %ebx,%eax
  803c8a:	f7 f5                	div    %ebp
  803c8c:	89 cf                	mov    %ecx,%edi
  803c8e:	89 fa                	mov    %edi,%edx
  803c90:	83 c4 1c             	add    $0x1c,%esp
  803c93:	5b                   	pop    %ebx
  803c94:	5e                   	pop    %esi
  803c95:	5f                   	pop    %edi
  803c96:	5d                   	pop    %ebp
  803c97:	c3                   	ret    
  803c98:	39 ce                	cmp    %ecx,%esi
  803c9a:	77 28                	ja     803cc4 <__udivdi3+0x7c>
  803c9c:	0f bd fe             	bsr    %esi,%edi
  803c9f:	83 f7 1f             	xor    $0x1f,%edi
  803ca2:	75 40                	jne    803ce4 <__udivdi3+0x9c>
  803ca4:	39 ce                	cmp    %ecx,%esi
  803ca6:	72 0a                	jb     803cb2 <__udivdi3+0x6a>
  803ca8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cac:	0f 87 9e 00 00 00    	ja     803d50 <__udivdi3+0x108>
  803cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cb7:	89 fa                	mov    %edi,%edx
  803cb9:	83 c4 1c             	add    $0x1c,%esp
  803cbc:	5b                   	pop    %ebx
  803cbd:	5e                   	pop    %esi
  803cbe:	5f                   	pop    %edi
  803cbf:	5d                   	pop    %ebp
  803cc0:	c3                   	ret    
  803cc1:	8d 76 00             	lea    0x0(%esi),%esi
  803cc4:	31 ff                	xor    %edi,%edi
  803cc6:	31 c0                	xor    %eax,%eax
  803cc8:	89 fa                	mov    %edi,%edx
  803cca:	83 c4 1c             	add    $0x1c,%esp
  803ccd:	5b                   	pop    %ebx
  803cce:	5e                   	pop    %esi
  803ccf:	5f                   	pop    %edi
  803cd0:	5d                   	pop    %ebp
  803cd1:	c3                   	ret    
  803cd2:	66 90                	xchg   %ax,%ax
  803cd4:	89 d8                	mov    %ebx,%eax
  803cd6:	f7 f7                	div    %edi
  803cd8:	31 ff                	xor    %edi,%edi
  803cda:	89 fa                	mov    %edi,%edx
  803cdc:	83 c4 1c             	add    $0x1c,%esp
  803cdf:	5b                   	pop    %ebx
  803ce0:	5e                   	pop    %esi
  803ce1:	5f                   	pop    %edi
  803ce2:	5d                   	pop    %ebp
  803ce3:	c3                   	ret    
  803ce4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ce9:	89 eb                	mov    %ebp,%ebx
  803ceb:	29 fb                	sub    %edi,%ebx
  803ced:	89 f9                	mov    %edi,%ecx
  803cef:	d3 e6                	shl    %cl,%esi
  803cf1:	89 c5                	mov    %eax,%ebp
  803cf3:	88 d9                	mov    %bl,%cl
  803cf5:	d3 ed                	shr    %cl,%ebp
  803cf7:	89 e9                	mov    %ebp,%ecx
  803cf9:	09 f1                	or     %esi,%ecx
  803cfb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803cff:	89 f9                	mov    %edi,%ecx
  803d01:	d3 e0                	shl    %cl,%eax
  803d03:	89 c5                	mov    %eax,%ebp
  803d05:	89 d6                	mov    %edx,%esi
  803d07:	88 d9                	mov    %bl,%cl
  803d09:	d3 ee                	shr    %cl,%esi
  803d0b:	89 f9                	mov    %edi,%ecx
  803d0d:	d3 e2                	shl    %cl,%edx
  803d0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d13:	88 d9                	mov    %bl,%cl
  803d15:	d3 e8                	shr    %cl,%eax
  803d17:	09 c2                	or     %eax,%edx
  803d19:	89 d0                	mov    %edx,%eax
  803d1b:	89 f2                	mov    %esi,%edx
  803d1d:	f7 74 24 0c          	divl   0xc(%esp)
  803d21:	89 d6                	mov    %edx,%esi
  803d23:	89 c3                	mov    %eax,%ebx
  803d25:	f7 e5                	mul    %ebp
  803d27:	39 d6                	cmp    %edx,%esi
  803d29:	72 19                	jb     803d44 <__udivdi3+0xfc>
  803d2b:	74 0b                	je     803d38 <__udivdi3+0xf0>
  803d2d:	89 d8                	mov    %ebx,%eax
  803d2f:	31 ff                	xor    %edi,%edi
  803d31:	e9 58 ff ff ff       	jmp    803c8e <__udivdi3+0x46>
  803d36:	66 90                	xchg   %ax,%ax
  803d38:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d3c:	89 f9                	mov    %edi,%ecx
  803d3e:	d3 e2                	shl    %cl,%edx
  803d40:	39 c2                	cmp    %eax,%edx
  803d42:	73 e9                	jae    803d2d <__udivdi3+0xe5>
  803d44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d47:	31 ff                	xor    %edi,%edi
  803d49:	e9 40 ff ff ff       	jmp    803c8e <__udivdi3+0x46>
  803d4e:	66 90                	xchg   %ax,%ax
  803d50:	31 c0                	xor    %eax,%eax
  803d52:	e9 37 ff ff ff       	jmp    803c8e <__udivdi3+0x46>
  803d57:	90                   	nop

00803d58 <__umoddi3>:
  803d58:	55                   	push   %ebp
  803d59:	57                   	push   %edi
  803d5a:	56                   	push   %esi
  803d5b:	53                   	push   %ebx
  803d5c:	83 ec 1c             	sub    $0x1c,%esp
  803d5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d63:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d77:	89 f3                	mov    %esi,%ebx
  803d79:	89 fa                	mov    %edi,%edx
  803d7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d7f:	89 34 24             	mov    %esi,(%esp)
  803d82:	85 c0                	test   %eax,%eax
  803d84:	75 1a                	jne    803da0 <__umoddi3+0x48>
  803d86:	39 f7                	cmp    %esi,%edi
  803d88:	0f 86 a2 00 00 00    	jbe    803e30 <__umoddi3+0xd8>
  803d8e:	89 c8                	mov    %ecx,%eax
  803d90:	89 f2                	mov    %esi,%edx
  803d92:	f7 f7                	div    %edi
  803d94:	89 d0                	mov    %edx,%eax
  803d96:	31 d2                	xor    %edx,%edx
  803d98:	83 c4 1c             	add    $0x1c,%esp
  803d9b:	5b                   	pop    %ebx
  803d9c:	5e                   	pop    %esi
  803d9d:	5f                   	pop    %edi
  803d9e:	5d                   	pop    %ebp
  803d9f:	c3                   	ret    
  803da0:	39 f0                	cmp    %esi,%eax
  803da2:	0f 87 ac 00 00 00    	ja     803e54 <__umoddi3+0xfc>
  803da8:	0f bd e8             	bsr    %eax,%ebp
  803dab:	83 f5 1f             	xor    $0x1f,%ebp
  803dae:	0f 84 ac 00 00 00    	je     803e60 <__umoddi3+0x108>
  803db4:	bf 20 00 00 00       	mov    $0x20,%edi
  803db9:	29 ef                	sub    %ebp,%edi
  803dbb:	89 fe                	mov    %edi,%esi
  803dbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803dc1:	89 e9                	mov    %ebp,%ecx
  803dc3:	d3 e0                	shl    %cl,%eax
  803dc5:	89 d7                	mov    %edx,%edi
  803dc7:	89 f1                	mov    %esi,%ecx
  803dc9:	d3 ef                	shr    %cl,%edi
  803dcb:	09 c7                	or     %eax,%edi
  803dcd:	89 e9                	mov    %ebp,%ecx
  803dcf:	d3 e2                	shl    %cl,%edx
  803dd1:	89 14 24             	mov    %edx,(%esp)
  803dd4:	89 d8                	mov    %ebx,%eax
  803dd6:	d3 e0                	shl    %cl,%eax
  803dd8:	89 c2                	mov    %eax,%edx
  803dda:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dde:	d3 e0                	shl    %cl,%eax
  803de0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803de4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803de8:	89 f1                	mov    %esi,%ecx
  803dea:	d3 e8                	shr    %cl,%eax
  803dec:	09 d0                	or     %edx,%eax
  803dee:	d3 eb                	shr    %cl,%ebx
  803df0:	89 da                	mov    %ebx,%edx
  803df2:	f7 f7                	div    %edi
  803df4:	89 d3                	mov    %edx,%ebx
  803df6:	f7 24 24             	mull   (%esp)
  803df9:	89 c6                	mov    %eax,%esi
  803dfb:	89 d1                	mov    %edx,%ecx
  803dfd:	39 d3                	cmp    %edx,%ebx
  803dff:	0f 82 87 00 00 00    	jb     803e8c <__umoddi3+0x134>
  803e05:	0f 84 91 00 00 00    	je     803e9c <__umoddi3+0x144>
  803e0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e0f:	29 f2                	sub    %esi,%edx
  803e11:	19 cb                	sbb    %ecx,%ebx
  803e13:	89 d8                	mov    %ebx,%eax
  803e15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e19:	d3 e0                	shl    %cl,%eax
  803e1b:	89 e9                	mov    %ebp,%ecx
  803e1d:	d3 ea                	shr    %cl,%edx
  803e1f:	09 d0                	or     %edx,%eax
  803e21:	89 e9                	mov    %ebp,%ecx
  803e23:	d3 eb                	shr    %cl,%ebx
  803e25:	89 da                	mov    %ebx,%edx
  803e27:	83 c4 1c             	add    $0x1c,%esp
  803e2a:	5b                   	pop    %ebx
  803e2b:	5e                   	pop    %esi
  803e2c:	5f                   	pop    %edi
  803e2d:	5d                   	pop    %ebp
  803e2e:	c3                   	ret    
  803e2f:	90                   	nop
  803e30:	89 fd                	mov    %edi,%ebp
  803e32:	85 ff                	test   %edi,%edi
  803e34:	75 0b                	jne    803e41 <__umoddi3+0xe9>
  803e36:	b8 01 00 00 00       	mov    $0x1,%eax
  803e3b:	31 d2                	xor    %edx,%edx
  803e3d:	f7 f7                	div    %edi
  803e3f:	89 c5                	mov    %eax,%ebp
  803e41:	89 f0                	mov    %esi,%eax
  803e43:	31 d2                	xor    %edx,%edx
  803e45:	f7 f5                	div    %ebp
  803e47:	89 c8                	mov    %ecx,%eax
  803e49:	f7 f5                	div    %ebp
  803e4b:	89 d0                	mov    %edx,%eax
  803e4d:	e9 44 ff ff ff       	jmp    803d96 <__umoddi3+0x3e>
  803e52:	66 90                	xchg   %ax,%ax
  803e54:	89 c8                	mov    %ecx,%eax
  803e56:	89 f2                	mov    %esi,%edx
  803e58:	83 c4 1c             	add    $0x1c,%esp
  803e5b:	5b                   	pop    %ebx
  803e5c:	5e                   	pop    %esi
  803e5d:	5f                   	pop    %edi
  803e5e:	5d                   	pop    %ebp
  803e5f:	c3                   	ret    
  803e60:	3b 04 24             	cmp    (%esp),%eax
  803e63:	72 06                	jb     803e6b <__umoddi3+0x113>
  803e65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e69:	77 0f                	ja     803e7a <__umoddi3+0x122>
  803e6b:	89 f2                	mov    %esi,%edx
  803e6d:	29 f9                	sub    %edi,%ecx
  803e6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e73:	89 14 24             	mov    %edx,(%esp)
  803e76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e7e:	8b 14 24             	mov    (%esp),%edx
  803e81:	83 c4 1c             	add    $0x1c,%esp
  803e84:	5b                   	pop    %ebx
  803e85:	5e                   	pop    %esi
  803e86:	5f                   	pop    %edi
  803e87:	5d                   	pop    %ebp
  803e88:	c3                   	ret    
  803e89:	8d 76 00             	lea    0x0(%esi),%esi
  803e8c:	2b 04 24             	sub    (%esp),%eax
  803e8f:	19 fa                	sbb    %edi,%edx
  803e91:	89 d1                	mov    %edx,%ecx
  803e93:	89 c6                	mov    %eax,%esi
  803e95:	e9 71 ff ff ff       	jmp    803e0b <__umoddi3+0xb3>
  803e9a:	66 90                	xchg   %ax,%ax
  803e9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ea0:	72 ea                	jb     803e8c <__umoddi3+0x134>
  803ea2:	89 d9                	mov    %ebx,%ecx
  803ea4:	e9 62 ff ff ff       	jmp    803e0b <__umoddi3+0xb3>
