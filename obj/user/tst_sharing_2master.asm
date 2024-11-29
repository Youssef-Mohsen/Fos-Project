
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
  80005c:	68 60 3e 80 00       	push   $0x803e60
  800061:	6a 14                	push   $0x14
  800063:	68 7c 3e 80 00       	push   $0x803e7c
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
  800082:	e8 c7 1b 00 00       	call   801c4e <sys_calculate_free_frames>
  800087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = smalloc("x", 4, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 04                	push   $0x4
  800091:	68 97 3e 80 00       	push   $0x803e97
  800096:	e8 81 18 00 00       	call   80191c <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 9c 3e 80 00       	push   $0x803e9c
  8000b8:	e8 92 07 00 00       	call   80084f <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8000c0:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8000c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ca:	e8 7f 1b 00 00       	call   801c4e <sys_calculate_free_frames>
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
  8000f3:	e8 56 1b 00 00       	call   801c4e <sys_calculate_free_frames>
  8000f8:	29 c3                	sub    %eax,%ebx
  8000fa:	89 d8                	mov    %ebx,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800102:	50                   	push   %eax
  800103:	68 00 3f 80 00       	push   $0x803f00
  800108:	e8 42 07 00 00       	call   80084f <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800110:	e8 39 1b 00 00       	call   801c4e <sys_calculate_free_frames>
  800115:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = smalloc("y", 4, 0);
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	6a 00                	push   $0x0
  80011d:	6a 04                	push   $0x4
  80011f:	68 98 3f 80 00       	push   $0x803f98
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
  800146:	68 9c 3e 80 00       	push   $0x803e9c
  80014b:	e8 ff 06 00 00       	call   80084f <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  800153:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80015a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80015d:	e8 ec 1a 00 00       	call   801c4e <sys_calculate_free_frames>
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
  800186:	e8 c3 1a 00 00       	call   801c4e <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	50                   	push   %eax
  800196:	68 00 3f 80 00       	push   $0x803f00
  80019b:	e8 af 06 00 00       	call   80084f <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  8001a3:	e8 a6 1a 00 00       	call   801c4e <sys_calculate_free_frames>
  8001a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = smalloc("z", 4, 1);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 01                	push   $0x1
  8001b0:	6a 04                	push   $0x4
  8001b2:	68 9a 3f 80 00       	push   $0x803f9a
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
  8001d9:	68 9c 3e 80 00       	push   $0x803e9c
  8001de:	e8 6c 06 00 00       	call   80084f <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8001e6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001f0:	e8 59 1a 00 00       	call   801c4e <sys_calculate_free_frames>
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
  800219:	e8 30 1a 00 00       	call   801c4e <sys_calculate_free_frames>
  80021e:	29 c3                	sub    %eax,%ebx
  800220:	89 d8                	mov    %ebx,%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	50                   	push   %eax
  800229:	68 00 3f 80 00       	push   $0x803f00
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
  80027f:	68 9c 3f 80 00       	push   $0x803f9c
  800284:	e8 20 1b 00 00       	call   801da9 <sys_create_env>
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
  8002b5:	68 9c 3f 80 00       	push   $0x803f9c
  8002ba:	e8 ea 1a 00 00       	call   801da9 <sys_create_env>
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
  8002eb:	68 9c 3f 80 00       	push   $0x803f9c
  8002f0:	e8 b4 1a 00 00       	call   801da9 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8002fb:	e8 f5 1b 00 00       	call   801ef5 <rsttst>

	sys_run_env(id1);\
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 d0             	pushl  -0x30(%ebp)
  800306:	e8 bc 1a 00 00       	call   801dc7 <sys_run_env>
  80030b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 cc             	pushl  -0x34(%ebp)
  800314:	e8 ae 1a 00 00       	call   801dc7 <sys_run_env>
  800319:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 c8             	pushl  -0x38(%ebp)
  800322:	e8 a0 1a 00 00       	call   801dc7 <sys_run_env>
  800327:	83 c4 10             	add    $0x10,%esp
	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  80032a:	90                   	nop
  80032b:	e8 3f 1c 00 00       	call   801f6f <gettst>
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
  800349:	68 a8 3f 80 00       	push   $0x803fa8
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
  80036a:	68 f4 3f 80 00       	push   $0x803ff4
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
  80039d:	68 26 40 80 00       	push   $0x804026
  8003a2:	e8 02 1a 00 00       	call   801da9 <sys_create_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b3:	e8 0f 1a 00 00       	call   801dc7 <sys_run_env>
  8003b8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  8003bb:	90                   	nop
  8003bc:	e8 ae 1b 00 00       	call   801f6f <gettst>
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
  8003da:	68 a8 3f 80 00       	push   $0x803fa8
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
  8003f8:	e8 58 1b 00 00       	call   801f55 <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8003fd:	90                   	nop
  8003fe:	e8 6c 1b 00 00       	call   801f6f <gettst>
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
  80041c:	68 a8 3f 80 00       	push   $0x803fa8
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
  800440:	68 34 40 80 00       	push   $0x804034
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
  800459:	e8 b9 19 00 00       	call   801e17 <sys_getenvindex>
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
  8004c7:	e8 cf 16 00 00       	call   801b9b <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004cc:	83 ec 0c             	sub    $0xc,%esp
  8004cf:	68 90 40 80 00       	push   $0x804090
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
  8004f7:	68 b8 40 80 00       	push   $0x8040b8
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
  800528:	68 e0 40 80 00       	push   $0x8040e0
  80052d:	e8 1d 03 00 00       	call   80084f <cprintf>
  800532:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800535:	a1 20 50 80 00       	mov    0x805020,%eax
  80053a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	50                   	push   %eax
  800544:	68 38 41 80 00       	push   $0x804138
  800549:	e8 01 03 00 00       	call   80084f <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 90 40 80 00       	push   $0x804090
  800559:	e8 f1 02 00 00       	call   80084f <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800561:	e8 4f 16 00 00       	call   801bb5 <sys_unlock_cons>
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
  800579:	e8 65 18 00 00       	call   801de3 <sys_destroy_env>
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
  80058a:	e8 ba 18 00 00       	call   801e49 <sys_exit_env>
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
  8005b3:	68 4c 41 80 00       	push   $0x80414c
  8005b8:	e8 92 02 00 00       	call   80084f <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005c0:	a1 00 50 80 00       	mov    0x805000,%eax
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	50                   	push   %eax
  8005cc:	68 51 41 80 00       	push   $0x804151
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
  8005f0:	68 6d 41 80 00       	push   $0x80416d
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
  80061f:	68 70 41 80 00       	push   $0x804170
  800624:	6a 26                	push   $0x26
  800626:	68 bc 41 80 00       	push   $0x8041bc
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
  8006f4:	68 c8 41 80 00       	push   $0x8041c8
  8006f9:	6a 3a                	push   $0x3a
  8006fb:	68 bc 41 80 00       	push   $0x8041bc
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
  800767:	68 1c 42 80 00       	push   $0x80421c
  80076c:	6a 44                	push   $0x44
  80076e:	68 bc 41 80 00       	push   $0x8041bc
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
  8007c1:	e8 93 13 00 00       	call   801b59 <sys_cputs>
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
  800838:	e8 1c 13 00 00       	call   801b59 <sys_cputs>
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
  800882:	e8 14 13 00 00       	call   801b9b <sys_lock_cons>
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
  8008a2:	e8 0e 13 00 00       	call   801bb5 <sys_unlock_cons>
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
  8008ec:	e8 ff 32 00 00       	call   803bf0 <__udivdi3>
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
  80093c:	e8 bf 33 00 00       	call   803d00 <__umoddi3>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	05 94 44 80 00       	add    $0x804494,%eax
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
  800a97:	8b 04 85 b8 44 80 00 	mov    0x8044b8(,%eax,4),%eax
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
  800b78:	8b 34 9d 00 43 80 00 	mov    0x804300(,%ebx,4),%esi
  800b7f:	85 f6                	test   %esi,%esi
  800b81:	75 19                	jne    800b9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b83:	53                   	push   %ebx
  800b84:	68 a5 44 80 00       	push   $0x8044a5
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
  800b9d:	68 ae 44 80 00       	push   $0x8044ae
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
  800bca:	be b1 44 80 00       	mov    $0x8044b1,%esi
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
  8015d5:	68 28 46 80 00       	push   $0x804628
  8015da:	68 3f 01 00 00       	push   $0x13f
  8015df:	68 4a 46 80 00       	push   $0x80464a
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
  8015f5:	e8 0a 0b 00 00       	call   802104 <sys_sbrk>
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
  801670:	e8 13 09 00 00       	call   801f88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801675:	85 c0                	test   %eax,%eax
  801677:	74 16                	je     80168f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	e8 53 0e 00 00       	call   8024d7 <alloc_block_FF>
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168a:	e9 8a 01 00 00       	jmp    801819 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80168f:	e8 25 09 00 00       	call   801fb9 <sys_isUHeapPlacementStrategyBESTFIT>
  801694:	85 c0                	test   %eax,%eax
  801696:	0f 84 7d 01 00 00    	je     801819 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	e8 ec 12 00 00       	call   802993 <alloc_block_BF>
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
  801808:	e8 2e 09 00 00       	call   80213b <sys_allocate_user_mem>
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
  801850:	e8 02 09 00 00       	call   802157 <get_block_size>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 35 1b 00 00       	call   80339b <free_block>
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
  8018f8:	e8 22 08 00 00       	call   80211f <sys_free_user_mem>
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
  801906:	68 58 46 80 00       	push   $0x804658
  80190b:	68 85 00 00 00       	push   $0x85
  801910:	68 82 46 80 00       	push   $0x804682
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
  80197b:	e8 a6 03 00 00       	call   801d26 <sys_createSharedObject>
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
  80199f:	68 8e 46 80 00       	push   $0x80468e
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
  8019e3:	e8 68 03 00 00       	call   801d50 <sys_getSizeOfSharedObject>
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8019ee:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019f2:	75 07                	jne    8019fb <sget+0x27>
  8019f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f9:	eb 7f                	jmp    801a7a <sget+0xa6>
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
  801a2e:	eb 4a                	jmp    801a7a <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	ff 75 e8             	pushl  -0x18(%ebp)
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	ff 75 08             	pushl  0x8(%ebp)
  801a3c:	e8 2c 03 00 00       	call   801d6d <sys_getSharedObject>
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801a47:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a4a:	a1 20 50 80 00       	mov    0x805020,%eax
  801a4f:	8b 40 78             	mov    0x78(%eax),%eax
  801a52:	29 c2                	sub    %eax,%edx
  801a54:	89 d0                	mov    %edx,%eax
  801a56:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a5b:	c1 e8 0c             	shr    $0xc,%eax
  801a5e:	89 c2                	mov    %eax,%edx
  801a60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a63:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801a6a:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a6e:	75 07                	jne    801a77 <sget+0xa3>
  801a70:	b8 00 00 00 00       	mov    $0x0,%eax
  801a75:	eb 03                	jmp    801a7a <sget+0xa6>
	return ptr;
  801a77:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801a82:	8b 55 08             	mov    0x8(%ebp),%edx
  801a85:	a1 20 50 80 00       	mov    0x805020,%eax
  801a8a:	8b 40 78             	mov    0x78(%eax),%eax
  801a8d:	29 c2                	sub    %eax,%edx
  801a8f:	89 d0                	mov    %edx,%eax
  801a91:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a96:	c1 e8 0c             	shr    $0xc,%eax
  801a99:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801aa3:	83 ec 08             	sub    $0x8,%esp
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	ff 75 f4             	pushl  -0xc(%ebp)
  801aac:	e8 db 02 00 00       	call   801d8c <sys_freeSharedObject>
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801ab7:	90                   	nop
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	68 a0 46 80 00       	push   $0x8046a0
  801ac8:	68 de 00 00 00       	push   $0xde
  801acd:	68 82 46 80 00       	push   $0x804682
  801ad2:	e8 bb ea ff ff       	call   800592 <_panic>

00801ad7 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801add:	83 ec 04             	sub    $0x4,%esp
  801ae0:	68 c6 46 80 00       	push   $0x8046c6
  801ae5:	68 ea 00 00 00       	push   $0xea
  801aea:	68 82 46 80 00       	push   $0x804682
  801aef:	e8 9e ea ff ff       	call   800592 <_panic>

00801af4 <shrink>:

}
void shrink(uint32 newSize)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	68 c6 46 80 00       	push   $0x8046c6
  801b02:	68 ef 00 00 00       	push   $0xef
  801b07:	68 82 46 80 00       	push   $0x804682
  801b0c:	e8 81 ea ff ff       	call   800592 <_panic>

00801b11 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b17:	83 ec 04             	sub    $0x4,%esp
  801b1a:	68 c6 46 80 00       	push   $0x8046c6
  801b1f:	68 f4 00 00 00       	push   $0xf4
  801b24:	68 82 46 80 00       	push   $0x804682
  801b29:	e8 64 ea ff ff       	call   800592 <_panic>

00801b2e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	57                   	push   %edi
  801b32:	56                   	push   %esi
  801b33:	53                   	push   %ebx
  801b34:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b40:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b43:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b46:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b49:	cd 30                	int    $0x30
  801b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b51:	83 c4 10             	add    $0x10,%esp
  801b54:	5b                   	pop    %ebx
  801b55:	5e                   	pop    %esi
  801b56:	5f                   	pop    %edi
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    

00801b59 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 04             	sub    $0x4,%esp
  801b5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b65:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	52                   	push   %edx
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	50                   	push   %eax
  801b75:	6a 00                	push   $0x0
  801b77:	e8 b2 ff ff ff       	call   801b2e <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	90                   	nop
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 02                	push   $0x2
  801b91:	e8 98 ff ff ff       	call   801b2e <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 03                	push   $0x3
  801baa:	e8 7f ff ff ff       	call   801b2e <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	90                   	nop
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 04                	push   $0x4
  801bc4:	e8 65 ff ff ff       	call   801b2e <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	90                   	nop
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	52                   	push   %edx
  801bdf:	50                   	push   %eax
  801be0:	6a 08                	push   $0x8
  801be2:	e8 47 ff ff ff       	call   801b2e <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	56                   	push   %esi
  801bf0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bf1:	8b 75 18             	mov    0x18(%ebp),%esi
  801bf4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bf7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	56                   	push   %esi
  801c01:	53                   	push   %ebx
  801c02:	51                   	push   %ecx
  801c03:	52                   	push   %edx
  801c04:	50                   	push   %eax
  801c05:	6a 09                	push   $0x9
  801c07:	e8 22 ff ff ff       	call   801b2e <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c12:	5b                   	pop    %ebx
  801c13:	5e                   	pop    %esi
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    

00801c16 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	52                   	push   %edx
  801c26:	50                   	push   %eax
  801c27:	6a 0a                	push   $0xa
  801c29:	e8 00 ff ff ff       	call   801b2e <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	ff 75 0c             	pushl  0xc(%ebp)
  801c3f:	ff 75 08             	pushl  0x8(%ebp)
  801c42:	6a 0b                	push   $0xb
  801c44:	e8 e5 fe ff ff       	call   801b2e <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 0c                	push   $0xc
  801c5d:	e8 cc fe ff ff       	call   801b2e <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 0d                	push   $0xd
  801c76:	e8 b3 fe ff ff       	call   801b2e <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 0e                	push   $0xe
  801c8f:	e8 9a fe ff ff       	call   801b2e <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 0f                	push   $0xf
  801ca8:	e8 81 fe ff ff       	call   801b2e <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	ff 75 08             	pushl  0x8(%ebp)
  801cc0:	6a 10                	push   $0x10
  801cc2:	e8 67 fe ff ff       	call   801b2e <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 11                	push   $0x11
  801cdb:	e8 4e fe ff ff       	call   801b2e <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	90                   	nop
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 04             	sub    $0x4,%esp
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cf2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	50                   	push   %eax
  801cff:	6a 01                	push   $0x1
  801d01:	e8 28 fe ff ff       	call   801b2e <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	90                   	nop
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 14                	push   $0x14
  801d1b:	e8 0e fe ff ff       	call   801b2e <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
}
  801d23:	90                   	nop
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d32:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d35:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	6a 00                	push   $0x0
  801d3e:	51                   	push   %ecx
  801d3f:	52                   	push   %edx
  801d40:	ff 75 0c             	pushl  0xc(%ebp)
  801d43:	50                   	push   %eax
  801d44:	6a 15                	push   $0x15
  801d46:	e8 e3 fd ff ff       	call   801b2e <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	52                   	push   %edx
  801d60:	50                   	push   %eax
  801d61:	6a 16                	push   $0x16
  801d63:	e8 c6 fd ff ff       	call   801b2e <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d70:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	51                   	push   %ecx
  801d7e:	52                   	push   %edx
  801d7f:	50                   	push   %eax
  801d80:	6a 17                	push   $0x17
  801d82:	e8 a7 fd ff ff       	call   801b2e <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	52                   	push   %edx
  801d9c:	50                   	push   %eax
  801d9d:	6a 18                	push   $0x18
  801d9f:	e8 8a fd ff ff       	call   801b2e <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	6a 00                	push   $0x0
  801db1:	ff 75 14             	pushl  0x14(%ebp)
  801db4:	ff 75 10             	pushl  0x10(%ebp)
  801db7:	ff 75 0c             	pushl  0xc(%ebp)
  801dba:	50                   	push   %eax
  801dbb:	6a 19                	push   $0x19
  801dbd:	e8 6c fd ff ff       	call   801b2e <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	50                   	push   %eax
  801dd6:	6a 1a                	push   $0x1a
  801dd8:	e8 51 fd ff ff       	call   801b2e <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
}
  801de0:	90                   	nop
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	50                   	push   %eax
  801df2:	6a 1b                	push   $0x1b
  801df4:	e8 35 fd ff ff       	call   801b2e <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 05                	push   $0x5
  801e0d:	e8 1c fd ff ff       	call   801b2e <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 06                	push   $0x6
  801e26:	e8 03 fd ff ff       	call   801b2e <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 07                	push   $0x7
  801e3f:	e8 ea fc ff ff       	call   801b2e <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_exit_env>:


void sys_exit_env(void)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 1c                	push   $0x1c
  801e58:	e8 d1 fc ff ff       	call   801b2e <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
}
  801e60:	90                   	nop
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e69:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e6c:	8d 50 04             	lea    0x4(%eax),%edx
  801e6f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	52                   	push   %edx
  801e79:	50                   	push   %eax
  801e7a:	6a 1d                	push   $0x1d
  801e7c:	e8 ad fc ff ff       	call   801b2e <syscall>
  801e81:	83 c4 18             	add    $0x18,%esp
	return result;
  801e84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e8d:	89 01                	mov    %eax,(%ecx)
  801e8f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	c9                   	leave  
  801e96:	c2 04 00             	ret    $0x4

00801e99 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	ff 75 10             	pushl  0x10(%ebp)
  801ea3:	ff 75 0c             	pushl  0xc(%ebp)
  801ea6:	ff 75 08             	pushl  0x8(%ebp)
  801ea9:	6a 13                	push   $0x13
  801eab:	e8 7e fc ff ff       	call   801b2e <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb3:	90                   	nop
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 1e                	push   $0x1e
  801ec5:	e8 64 fc ff ff       	call   801b2e <syscall>
  801eca:	83 c4 18             	add    $0x18,%esp
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 04             	sub    $0x4,%esp
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801edb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	50                   	push   %eax
  801ee8:	6a 1f                	push   $0x1f
  801eea:	e8 3f fc ff ff       	call   801b2e <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef2:	90                   	nop
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <rsttst>:
void rsttst()
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 21                	push   $0x21
  801f04:	e8 25 fc ff ff       	call   801b2e <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0c:	90                   	nop
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	8b 45 14             	mov    0x14(%ebp),%eax
  801f18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f1b:	8b 55 18             	mov    0x18(%ebp),%edx
  801f1e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f22:	52                   	push   %edx
  801f23:	50                   	push   %eax
  801f24:	ff 75 10             	pushl  0x10(%ebp)
  801f27:	ff 75 0c             	pushl  0xc(%ebp)
  801f2a:	ff 75 08             	pushl  0x8(%ebp)
  801f2d:	6a 20                	push   $0x20
  801f2f:	e8 fa fb ff ff       	call   801b2e <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
	return ;
  801f37:	90                   	nop
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <chktst>:
void chktst(uint32 n)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	ff 75 08             	pushl  0x8(%ebp)
  801f48:	6a 22                	push   $0x22
  801f4a:	e8 df fb ff ff       	call   801b2e <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f52:	90                   	nop
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <inctst>:

void inctst()
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 23                	push   $0x23
  801f64:	e8 c5 fb ff ff       	call   801b2e <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
	return ;
  801f6c:	90                   	nop
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <gettst>:
uint32 gettst()
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 24                	push   $0x24
  801f7e:	e8 ab fb ff ff       	call   801b2e <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 25                	push   $0x25
  801f9a:	e8 8f fb ff ff       	call   801b2e <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
  801fa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fa5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fa9:	75 07                	jne    801fb2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fab:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb0:	eb 05                	jmp    801fb7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 25                	push   $0x25
  801fcb:	e8 5e fb ff ff       	call   801b2e <syscall>
  801fd0:	83 c4 18             	add    $0x18,%esp
  801fd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fd6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fda:	75 07                	jne    801fe3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fdc:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe1:	eb 05                	jmp    801fe8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 25                	push   $0x25
  801ffc:	e8 2d fb ff ff       	call   801b2e <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
  802004:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802007:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80200b:	75 07                	jne    802014 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80200d:	b8 01 00 00 00       	mov    $0x1,%eax
  802012:	eb 05                	jmp    802019 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802014:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 25                	push   $0x25
  80202d:	e8 fc fa ff ff       	call   801b2e <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
  802035:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802038:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80203c:	75 07                	jne    802045 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80203e:	b8 01 00 00 00       	mov    $0x1,%eax
  802043:	eb 05                	jmp    80204a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802045:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	ff 75 08             	pushl  0x8(%ebp)
  80205a:	6a 26                	push   $0x26
  80205c:	e8 cd fa ff ff       	call   801b2e <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
	return ;
  802064:	90                   	nop
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80206b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80206e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802071:	8b 55 0c             	mov    0xc(%ebp),%edx
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	6a 00                	push   $0x0
  802079:	53                   	push   %ebx
  80207a:	51                   	push   %ecx
  80207b:	52                   	push   %edx
  80207c:	50                   	push   %eax
  80207d:	6a 27                	push   $0x27
  80207f:	e8 aa fa ff ff       	call   801b2e <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
}
  802087:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80208f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	52                   	push   %edx
  80209c:	50                   	push   %eax
  80209d:	6a 28                	push   $0x28
  80209f:	e8 8a fa ff ff       	call   801b2e <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8020ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	6a 00                	push   $0x0
  8020b7:	51                   	push   %ecx
  8020b8:	ff 75 10             	pushl  0x10(%ebp)
  8020bb:	52                   	push   %edx
  8020bc:	50                   	push   %eax
  8020bd:	6a 29                	push   $0x29
  8020bf:	e8 6a fa ff ff       	call   801b2e <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	ff 75 10             	pushl  0x10(%ebp)
  8020d3:	ff 75 0c             	pushl  0xc(%ebp)
  8020d6:	ff 75 08             	pushl  0x8(%ebp)
  8020d9:	6a 12                	push   $0x12
  8020db:	e8 4e fa ff ff       	call   801b2e <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e3:	90                   	nop
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8020e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	52                   	push   %edx
  8020f6:	50                   	push   %eax
  8020f7:	6a 2a                	push   $0x2a
  8020f9:	e8 30 fa ff ff       	call   801b2e <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
	return;
  802101:	90                   	nop
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	50                   	push   %eax
  802113:	6a 2b                	push   $0x2b
  802115:	e8 14 fa ff ff       	call   801b2e <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	ff 75 0c             	pushl  0xc(%ebp)
  80212b:	ff 75 08             	pushl  0x8(%ebp)
  80212e:	6a 2c                	push   $0x2c
  802130:	e8 f9 f9 ff ff       	call   801b2e <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
	return;
  802138:	90                   	nop
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	ff 75 0c             	pushl  0xc(%ebp)
  802147:	ff 75 08             	pushl  0x8(%ebp)
  80214a:	6a 2d                	push   $0x2d
  80214c:	e8 dd f9 ff ff       	call   801b2e <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
	return;
  802154:	90                   	nop
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	83 e8 04             	sub    $0x4,%eax
  802163:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802166:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802169:	8b 00                	mov    (%eax),%eax
  80216b:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	83 e8 04             	sub    $0x4,%eax
  80217c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80217f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802182:	8b 00                	mov    (%eax),%eax
  802184:	83 e0 01             	and    $0x1,%eax
  802187:	85 c0                	test   %eax,%eax
  802189:	0f 94 c0             	sete   %al
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802194:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80219b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219e:	83 f8 02             	cmp    $0x2,%eax
  8021a1:	74 2b                	je     8021ce <alloc_block+0x40>
  8021a3:	83 f8 02             	cmp    $0x2,%eax
  8021a6:	7f 07                	jg     8021af <alloc_block+0x21>
  8021a8:	83 f8 01             	cmp    $0x1,%eax
  8021ab:	74 0e                	je     8021bb <alloc_block+0x2d>
  8021ad:	eb 58                	jmp    802207 <alloc_block+0x79>
  8021af:	83 f8 03             	cmp    $0x3,%eax
  8021b2:	74 2d                	je     8021e1 <alloc_block+0x53>
  8021b4:	83 f8 04             	cmp    $0x4,%eax
  8021b7:	74 3b                	je     8021f4 <alloc_block+0x66>
  8021b9:	eb 4c                	jmp    802207 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8021bb:	83 ec 0c             	sub    $0xc,%esp
  8021be:	ff 75 08             	pushl  0x8(%ebp)
  8021c1:	e8 11 03 00 00       	call   8024d7 <alloc_block_FF>
  8021c6:	83 c4 10             	add    $0x10,%esp
  8021c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021cc:	eb 4a                	jmp    802218 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8021ce:	83 ec 0c             	sub    $0xc,%esp
  8021d1:	ff 75 08             	pushl  0x8(%ebp)
  8021d4:	e8 fa 19 00 00       	call   803bd3 <alloc_block_NF>
  8021d9:	83 c4 10             	add    $0x10,%esp
  8021dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021df:	eb 37                	jmp    802218 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8021e1:	83 ec 0c             	sub    $0xc,%esp
  8021e4:	ff 75 08             	pushl  0x8(%ebp)
  8021e7:	e8 a7 07 00 00       	call   802993 <alloc_block_BF>
  8021ec:	83 c4 10             	add    $0x10,%esp
  8021ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021f2:	eb 24                	jmp    802218 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8021f4:	83 ec 0c             	sub    $0xc,%esp
  8021f7:	ff 75 08             	pushl  0x8(%ebp)
  8021fa:	e8 b7 19 00 00       	call   803bb6 <alloc_block_WF>
  8021ff:	83 c4 10             	add    $0x10,%esp
  802202:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802205:	eb 11                	jmp    802218 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802207:	83 ec 0c             	sub    $0xc,%esp
  80220a:	68 d8 46 80 00       	push   $0x8046d8
  80220f:	e8 3b e6 ff ff       	call   80084f <cprintf>
  802214:	83 c4 10             	add    $0x10,%esp
		break;
  802217:	90                   	nop
	}
	return va;
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
  802220:	53                   	push   %ebx
  802221:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802224:	83 ec 0c             	sub    $0xc,%esp
  802227:	68 f8 46 80 00       	push   $0x8046f8
  80222c:	e8 1e e6 ff ff       	call   80084f <cprintf>
  802231:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802234:	83 ec 0c             	sub    $0xc,%esp
  802237:	68 23 47 80 00       	push   $0x804723
  80223c:	e8 0e e6 ff ff       	call   80084f <cprintf>
  802241:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224a:	eb 37                	jmp    802283 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80224c:	83 ec 0c             	sub    $0xc,%esp
  80224f:	ff 75 f4             	pushl  -0xc(%ebp)
  802252:	e8 19 ff ff ff       	call   802170 <is_free_block>
  802257:	83 c4 10             	add    $0x10,%esp
  80225a:	0f be d8             	movsbl %al,%ebx
  80225d:	83 ec 0c             	sub    $0xc,%esp
  802260:	ff 75 f4             	pushl  -0xc(%ebp)
  802263:	e8 ef fe ff ff       	call   802157 <get_block_size>
  802268:	83 c4 10             	add    $0x10,%esp
  80226b:	83 ec 04             	sub    $0x4,%esp
  80226e:	53                   	push   %ebx
  80226f:	50                   	push   %eax
  802270:	68 3b 47 80 00       	push   $0x80473b
  802275:	e8 d5 e5 ff ff       	call   80084f <cprintf>
  80227a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80227d:	8b 45 10             	mov    0x10(%ebp),%eax
  802280:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802287:	74 07                	je     802290 <print_blocks_list+0x73>
  802289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228c:	8b 00                	mov    (%eax),%eax
  80228e:	eb 05                	jmp    802295 <print_blocks_list+0x78>
  802290:	b8 00 00 00 00       	mov    $0x0,%eax
  802295:	89 45 10             	mov    %eax,0x10(%ebp)
  802298:	8b 45 10             	mov    0x10(%ebp),%eax
  80229b:	85 c0                	test   %eax,%eax
  80229d:	75 ad                	jne    80224c <print_blocks_list+0x2f>
  80229f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a3:	75 a7                	jne    80224c <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8022a5:	83 ec 0c             	sub    $0xc,%esp
  8022a8:	68 f8 46 80 00       	push   $0x8046f8
  8022ad:	e8 9d e5 ff ff       	call   80084f <cprintf>
  8022b2:	83 c4 10             	add    $0x10,%esp

}
  8022b5:	90                   	nop
  8022b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8022c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c4:	83 e0 01             	and    $0x1,%eax
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	74 03                	je     8022ce <initialize_dynamic_allocator+0x13>
  8022cb:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8022ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022d2:	0f 84 c7 01 00 00    	je     80249f <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8022d8:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8022df:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8022e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e8:	01 d0                	add    %edx,%eax
  8022ea:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8022ef:	0f 87 ad 01 00 00    	ja     8024a2 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	0f 89 a5 01 00 00    	jns    8024a5 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802300:	8b 55 08             	mov    0x8(%ebp),%edx
  802303:	8b 45 0c             	mov    0xc(%ebp),%eax
  802306:	01 d0                	add    %edx,%eax
  802308:	83 e8 04             	sub    $0x4,%eax
  80230b:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802310:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802317:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80231c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231f:	e9 87 00 00 00       	jmp    8023ab <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802328:	75 14                	jne    80233e <initialize_dynamic_allocator+0x83>
  80232a:	83 ec 04             	sub    $0x4,%esp
  80232d:	68 53 47 80 00       	push   $0x804753
  802332:	6a 79                	push   $0x79
  802334:	68 71 47 80 00       	push   $0x804771
  802339:	e8 54 e2 ff ff       	call   800592 <_panic>
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 00                	mov    (%eax),%eax
  802343:	85 c0                	test   %eax,%eax
  802345:	74 10                	je     802357 <initialize_dynamic_allocator+0x9c>
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 00                	mov    (%eax),%eax
  80234c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234f:	8b 52 04             	mov    0x4(%edx),%edx
  802352:	89 50 04             	mov    %edx,0x4(%eax)
  802355:	eb 0b                	jmp    802362 <initialize_dynamic_allocator+0xa7>
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	a3 30 50 80 00       	mov    %eax,0x805030
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 40 04             	mov    0x4(%eax),%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	74 0f                	je     80237b <initialize_dynamic_allocator+0xc0>
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 40 04             	mov    0x4(%eax),%eax
  802372:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802375:	8b 12                	mov    (%edx),%edx
  802377:	89 10                	mov    %edx,(%eax)
  802379:	eb 0a                	jmp    802385 <initialize_dynamic_allocator+0xca>
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 00                	mov    (%eax),%eax
  802380:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802398:	a1 38 50 80 00       	mov    0x805038,%eax
  80239d:	48                   	dec    %eax
  80239e:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8023a3:	a1 34 50 80 00       	mov    0x805034,%eax
  8023a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023af:	74 07                	je     8023b8 <initialize_dynamic_allocator+0xfd>
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 00                	mov    (%eax),%eax
  8023b6:	eb 05                	jmp    8023bd <initialize_dynamic_allocator+0x102>
  8023b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bd:	a3 34 50 80 00       	mov    %eax,0x805034
  8023c2:	a1 34 50 80 00       	mov    0x805034,%eax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	0f 85 55 ff ff ff    	jne    802324 <initialize_dynamic_allocator+0x69>
  8023cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d3:	0f 85 4b ff ff ff    	jne    802324 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8023df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8023e8:	a1 44 50 80 00       	mov    0x805044,%eax
  8023ed:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8023f2:	a1 40 50 80 00       	mov    0x805040,%eax
  8023f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	83 c0 08             	add    $0x8,%eax
  802403:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	83 c0 04             	add    $0x4,%eax
  80240c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240f:	83 ea 08             	sub    $0x8,%edx
  802412:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802414:	8b 55 0c             	mov    0xc(%ebp),%edx
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	01 d0                	add    %edx,%eax
  80241c:	83 e8 08             	sub    $0x8,%eax
  80241f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802422:	83 ea 08             	sub    $0x8,%edx
  802425:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802427:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802430:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802433:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80243a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80243e:	75 17                	jne    802457 <initialize_dynamic_allocator+0x19c>
  802440:	83 ec 04             	sub    $0x4,%esp
  802443:	68 8c 47 80 00       	push   $0x80478c
  802448:	68 90 00 00 00       	push   $0x90
  80244d:	68 71 47 80 00       	push   $0x804771
  802452:	e8 3b e1 ff ff       	call   800592 <_panic>
  802457:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80245d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802460:	89 10                	mov    %edx,(%eax)
  802462:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802465:	8b 00                	mov    (%eax),%eax
  802467:	85 c0                	test   %eax,%eax
  802469:	74 0d                	je     802478 <initialize_dynamic_allocator+0x1bd>
  80246b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802470:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802473:	89 50 04             	mov    %edx,0x4(%eax)
  802476:	eb 08                	jmp    802480 <initialize_dynamic_allocator+0x1c5>
  802478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247b:	a3 30 50 80 00       	mov    %eax,0x805030
  802480:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802483:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802492:	a1 38 50 80 00       	mov    0x805038,%eax
  802497:	40                   	inc    %eax
  802498:	a3 38 50 80 00       	mov    %eax,0x805038
  80249d:	eb 07                	jmp    8024a6 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80249f:	90                   	nop
  8024a0:	eb 04                	jmp    8024a6 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8024a2:	90                   	nop
  8024a3:	eb 01                	jmp    8024a6 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8024a5:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8024a6:	c9                   	leave  
  8024a7:	c3                   	ret    

008024a8 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8024ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ae:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8024b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ba:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	83 e8 04             	sub    $0x4,%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	83 e0 fe             	and    $0xfffffffe,%eax
  8024c7:	8d 50 f8             	lea    -0x8(%eax),%edx
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	01 c2                	add    %eax,%edx
  8024cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d2:	89 02                	mov    %eax,(%edx)
}
  8024d4:	90                   	nop
  8024d5:	5d                   	pop    %ebp
  8024d6:	c3                   	ret    

008024d7 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
  8024da:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e0:	83 e0 01             	and    $0x1,%eax
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	74 03                	je     8024ea <alloc_block_FF+0x13>
  8024e7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024ea:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024ee:	77 07                	ja     8024f7 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024f0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8024fc:	85 c0                	test   %eax,%eax
  8024fe:	75 73                	jne    802573 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802500:	8b 45 08             	mov    0x8(%ebp),%eax
  802503:	83 c0 10             	add    $0x10,%eax
  802506:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802509:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802510:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802513:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802516:	01 d0                	add    %edx,%eax
  802518:	48                   	dec    %eax
  802519:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80251c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80251f:	ba 00 00 00 00       	mov    $0x0,%edx
  802524:	f7 75 ec             	divl   -0x14(%ebp)
  802527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80252a:	29 d0                	sub    %edx,%eax
  80252c:	c1 e8 0c             	shr    $0xc,%eax
  80252f:	83 ec 0c             	sub    $0xc,%esp
  802532:	50                   	push   %eax
  802533:	e8 b1 f0 ff ff       	call   8015e9 <sbrk>
  802538:	83 c4 10             	add    $0x10,%esp
  80253b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80253e:	83 ec 0c             	sub    $0xc,%esp
  802541:	6a 00                	push   $0x0
  802543:	e8 a1 f0 ff ff       	call   8015e9 <sbrk>
  802548:	83 c4 10             	add    $0x10,%esp
  80254b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80254e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802551:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802554:	83 ec 08             	sub    $0x8,%esp
  802557:	50                   	push   %eax
  802558:	ff 75 e4             	pushl  -0x1c(%ebp)
  80255b:	e8 5b fd ff ff       	call   8022bb <initialize_dynamic_allocator>
  802560:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802563:	83 ec 0c             	sub    $0xc,%esp
  802566:	68 af 47 80 00       	push   $0x8047af
  80256b:	e8 df e2 ff ff       	call   80084f <cprintf>
  802570:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802573:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802577:	75 0a                	jne    802583 <alloc_block_FF+0xac>
	        return NULL;
  802579:	b8 00 00 00 00       	mov    $0x0,%eax
  80257e:	e9 0e 04 00 00       	jmp    802991 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80258a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80258f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802592:	e9 f3 02 00 00       	jmp    80288a <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80259d:	83 ec 0c             	sub    $0xc,%esp
  8025a0:	ff 75 bc             	pushl  -0x44(%ebp)
  8025a3:	e8 af fb ff ff       	call   802157 <get_block_size>
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	83 c0 08             	add    $0x8,%eax
  8025b4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8025b7:	0f 87 c5 02 00 00    	ja     802882 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	83 c0 18             	add    $0x18,%eax
  8025c3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8025c6:	0f 87 19 02 00 00    	ja     8027e5 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8025cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8025cf:	2b 45 08             	sub    0x8(%ebp),%eax
  8025d2:	83 e8 08             	sub    $0x8,%eax
  8025d5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8025d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025db:	8d 50 08             	lea    0x8(%eax),%edx
  8025de:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025e1:	01 d0                	add    %edx,%eax
  8025e3:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8025e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e9:	83 c0 08             	add    $0x8,%eax
  8025ec:	83 ec 04             	sub    $0x4,%esp
  8025ef:	6a 01                	push   $0x1
  8025f1:	50                   	push   %eax
  8025f2:	ff 75 bc             	pushl  -0x44(%ebp)
  8025f5:	e8 ae fe ff ff       	call   8024a8 <set_block_data>
  8025fa:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 40 04             	mov    0x4(%eax),%eax
  802603:	85 c0                	test   %eax,%eax
  802605:	75 68                	jne    80266f <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802607:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80260b:	75 17                	jne    802624 <alloc_block_FF+0x14d>
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	68 8c 47 80 00       	push   $0x80478c
  802615:	68 d7 00 00 00       	push   $0xd7
  80261a:	68 71 47 80 00       	push   $0x804771
  80261f:	e8 6e df ff ff       	call   800592 <_panic>
  802624:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80262a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80262d:	89 10                	mov    %edx,(%eax)
  80262f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802632:	8b 00                	mov    (%eax),%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	74 0d                	je     802645 <alloc_block_FF+0x16e>
  802638:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80263d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802640:	89 50 04             	mov    %edx,0x4(%eax)
  802643:	eb 08                	jmp    80264d <alloc_block_FF+0x176>
  802645:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802648:	a3 30 50 80 00       	mov    %eax,0x805030
  80264d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802650:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802655:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802658:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80265f:	a1 38 50 80 00       	mov    0x805038,%eax
  802664:	40                   	inc    %eax
  802665:	a3 38 50 80 00       	mov    %eax,0x805038
  80266a:	e9 dc 00 00 00       	jmp    80274b <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	75 65                	jne    8026dd <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802678:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80267c:	75 17                	jne    802695 <alloc_block_FF+0x1be>
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 c0 47 80 00       	push   $0x8047c0
  802686:	68 db 00 00 00       	push   $0xdb
  80268b:	68 71 47 80 00       	push   $0x804771
  802690:	e8 fd de ff ff       	call   800592 <_panic>
  802695:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80269b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80269e:	89 50 04             	mov    %edx,0x4(%eax)
  8026a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026a4:	8b 40 04             	mov    0x4(%eax),%eax
  8026a7:	85 c0                	test   %eax,%eax
  8026a9:	74 0c                	je     8026b7 <alloc_block_FF+0x1e0>
  8026ab:	a1 30 50 80 00       	mov    0x805030,%eax
  8026b0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026b3:	89 10                	mov    %edx,(%eax)
  8026b5:	eb 08                	jmp    8026bf <alloc_block_FF+0x1e8>
  8026b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8026c7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8026d5:	40                   	inc    %eax
  8026d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8026db:	eb 6e                	jmp    80274b <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8026dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e1:	74 06                	je     8026e9 <alloc_block_FF+0x212>
  8026e3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026e7:	75 17                	jne    802700 <alloc_block_FF+0x229>
  8026e9:	83 ec 04             	sub    $0x4,%esp
  8026ec:	68 e4 47 80 00       	push   $0x8047e4
  8026f1:	68 df 00 00 00       	push   $0xdf
  8026f6:	68 71 47 80 00       	push   $0x804771
  8026fb:	e8 92 de ff ff       	call   800592 <_panic>
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 10                	mov    (%eax),%edx
  802705:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802708:	89 10                	mov    %edx,(%eax)
  80270a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80270d:	8b 00                	mov    (%eax),%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	74 0b                	je     80271e <alloc_block_FF+0x247>
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 00                	mov    (%eax),%eax
  802718:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80271b:	89 50 04             	mov    %edx,0x4(%eax)
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802724:	89 10                	mov    %edx,(%eax)
  802726:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802729:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272c:	89 50 04             	mov    %edx,0x4(%eax)
  80272f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802732:	8b 00                	mov    (%eax),%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	75 08                	jne    802740 <alloc_block_FF+0x269>
  802738:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80273b:	a3 30 50 80 00       	mov    %eax,0x805030
  802740:	a1 38 50 80 00       	mov    0x805038,%eax
  802745:	40                   	inc    %eax
  802746:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80274b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274f:	75 17                	jne    802768 <alloc_block_FF+0x291>
  802751:	83 ec 04             	sub    $0x4,%esp
  802754:	68 53 47 80 00       	push   $0x804753
  802759:	68 e1 00 00 00       	push   $0xe1
  80275e:	68 71 47 80 00       	push   $0x804771
  802763:	e8 2a de ff ff       	call   800592 <_panic>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	85 c0                	test   %eax,%eax
  80276f:	74 10                	je     802781 <alloc_block_FF+0x2aa>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802779:	8b 52 04             	mov    0x4(%edx),%edx
  80277c:	89 50 04             	mov    %edx,0x4(%eax)
  80277f:	eb 0b                	jmp    80278c <alloc_block_FF+0x2b5>
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 40 04             	mov    0x4(%eax),%eax
  802787:	a3 30 50 80 00       	mov    %eax,0x805030
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 40 04             	mov    0x4(%eax),%eax
  802792:	85 c0                	test   %eax,%eax
  802794:	74 0f                	je     8027a5 <alloc_block_FF+0x2ce>
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 40 04             	mov    0x4(%eax),%eax
  80279c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279f:	8b 12                	mov    (%edx),%edx
  8027a1:	89 10                	mov    %edx,(%eax)
  8027a3:	eb 0a                	jmp    8027af <alloc_block_FF+0x2d8>
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c2:	a1 38 50 80 00       	mov    0x805038,%eax
  8027c7:	48                   	dec    %eax
  8027c8:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8027cd:	83 ec 04             	sub    $0x4,%esp
  8027d0:	6a 00                	push   $0x0
  8027d2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8027d5:	ff 75 b0             	pushl  -0x50(%ebp)
  8027d8:	e8 cb fc ff ff       	call   8024a8 <set_block_data>
  8027dd:	83 c4 10             	add    $0x10,%esp
  8027e0:	e9 95 00 00 00       	jmp    80287a <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8027e5:	83 ec 04             	sub    $0x4,%esp
  8027e8:	6a 01                	push   $0x1
  8027ea:	ff 75 b8             	pushl  -0x48(%ebp)
  8027ed:	ff 75 bc             	pushl  -0x44(%ebp)
  8027f0:	e8 b3 fc ff ff       	call   8024a8 <set_block_data>
  8027f5:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fc:	75 17                	jne    802815 <alloc_block_FF+0x33e>
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	68 53 47 80 00       	push   $0x804753
  802806:	68 e8 00 00 00       	push   $0xe8
  80280b:	68 71 47 80 00       	push   $0x804771
  802810:	e8 7d dd ff ff       	call   800592 <_panic>
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 10                	je     80282e <alloc_block_FF+0x357>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802826:	8b 52 04             	mov    0x4(%edx),%edx
  802829:	89 50 04             	mov    %edx,0x4(%eax)
  80282c:	eb 0b                	jmp    802839 <alloc_block_FF+0x362>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	a3 30 50 80 00       	mov    %eax,0x805030
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	74 0f                	je     802852 <alloc_block_FF+0x37b>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284c:	8b 12                	mov    (%edx),%edx
  80284e:	89 10                	mov    %edx,(%eax)
  802850:	eb 0a                	jmp    80285c <alloc_block_FF+0x385>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286f:	a1 38 50 80 00       	mov    0x805038,%eax
  802874:	48                   	dec    %eax
  802875:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80287a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80287d:	e9 0f 01 00 00       	jmp    802991 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802882:	a1 34 50 80 00       	mov    0x805034,%eax
  802887:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288e:	74 07                	je     802897 <alloc_block_FF+0x3c0>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	eb 05                	jmp    80289c <alloc_block_FF+0x3c5>
  802897:	b8 00 00 00 00       	mov    $0x0,%eax
  80289c:	a3 34 50 80 00       	mov    %eax,0x805034
  8028a1:	a1 34 50 80 00       	mov    0x805034,%eax
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	0f 85 e9 fc ff ff    	jne    802597 <alloc_block_FF+0xc0>
  8028ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b2:	0f 85 df fc ff ff    	jne    802597 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8028b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bb:	83 c0 08             	add    $0x8,%eax
  8028be:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8028c1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8028c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028ce:	01 d0                	add    %edx,%eax
  8028d0:	48                   	dec    %eax
  8028d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028dc:	f7 75 d8             	divl   -0x28(%ebp)
  8028df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028e2:	29 d0                	sub    %edx,%eax
  8028e4:	c1 e8 0c             	shr    $0xc,%eax
  8028e7:	83 ec 0c             	sub    $0xc,%esp
  8028ea:	50                   	push   %eax
  8028eb:	e8 f9 ec ff ff       	call   8015e9 <sbrk>
  8028f0:	83 c4 10             	add    $0x10,%esp
  8028f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8028f6:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8028fa:	75 0a                	jne    802906 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8028fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802901:	e9 8b 00 00 00       	jmp    802991 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802906:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80290d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802910:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802913:	01 d0                	add    %edx,%eax
  802915:	48                   	dec    %eax
  802916:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802919:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80291c:	ba 00 00 00 00       	mov    $0x0,%edx
  802921:	f7 75 cc             	divl   -0x34(%ebp)
  802924:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802927:	29 d0                	sub    %edx,%eax
  802929:	8d 50 fc             	lea    -0x4(%eax),%edx
  80292c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80292f:	01 d0                	add    %edx,%eax
  802931:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802936:	a1 40 50 80 00       	mov    0x805040,%eax
  80293b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802941:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802948:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80294b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80294e:	01 d0                	add    %edx,%eax
  802950:	48                   	dec    %eax
  802951:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802954:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802957:	ba 00 00 00 00       	mov    $0x0,%edx
  80295c:	f7 75 c4             	divl   -0x3c(%ebp)
  80295f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802962:	29 d0                	sub    %edx,%eax
  802964:	83 ec 04             	sub    $0x4,%esp
  802967:	6a 01                	push   $0x1
  802969:	50                   	push   %eax
  80296a:	ff 75 d0             	pushl  -0x30(%ebp)
  80296d:	e8 36 fb ff ff       	call   8024a8 <set_block_data>
  802972:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802975:	83 ec 0c             	sub    $0xc,%esp
  802978:	ff 75 d0             	pushl  -0x30(%ebp)
  80297b:	e8 1b 0a 00 00       	call   80339b <free_block>
  802980:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802983:	83 ec 0c             	sub    $0xc,%esp
  802986:	ff 75 08             	pushl  0x8(%ebp)
  802989:	e8 49 fb ff ff       	call   8024d7 <alloc_block_FF>
  80298e:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802991:	c9                   	leave  
  802992:	c3                   	ret    

00802993 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802993:	55                   	push   %ebp
  802994:	89 e5                	mov    %esp,%ebp
  802996:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	83 e0 01             	and    $0x1,%eax
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	74 03                	je     8029a6 <alloc_block_BF+0x13>
  8029a3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8029a6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8029aa:	77 07                	ja     8029b3 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8029ac:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8029b3:	a1 24 50 80 00       	mov    0x805024,%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	75 73                	jne    802a2f <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	83 c0 10             	add    $0x10,%eax
  8029c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8029c5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8029cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d2:	01 d0                	add    %edx,%eax
  8029d4:	48                   	dec    %eax
  8029d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8029d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029db:	ba 00 00 00 00       	mov    $0x0,%edx
  8029e0:	f7 75 e0             	divl   -0x20(%ebp)
  8029e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029e6:	29 d0                	sub    %edx,%eax
  8029e8:	c1 e8 0c             	shr    $0xc,%eax
  8029eb:	83 ec 0c             	sub    $0xc,%esp
  8029ee:	50                   	push   %eax
  8029ef:	e8 f5 eb ff ff       	call   8015e9 <sbrk>
  8029f4:	83 c4 10             	add    $0x10,%esp
  8029f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029fa:	83 ec 0c             	sub    $0xc,%esp
  8029fd:	6a 00                	push   $0x0
  8029ff:	e8 e5 eb ff ff       	call   8015e9 <sbrk>
  802a04:	83 c4 10             	add    $0x10,%esp
  802a07:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a0d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802a10:	83 ec 08             	sub    $0x8,%esp
  802a13:	50                   	push   %eax
  802a14:	ff 75 d8             	pushl  -0x28(%ebp)
  802a17:	e8 9f f8 ff ff       	call   8022bb <initialize_dynamic_allocator>
  802a1c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802a1f:	83 ec 0c             	sub    $0xc,%esp
  802a22:	68 af 47 80 00       	push   $0x8047af
  802a27:	e8 23 de ff ff       	call   80084f <cprintf>
  802a2c:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802a2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802a36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802a3d:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802a44:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802a4b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a53:	e9 1d 01 00 00       	jmp    802b75 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802a5e:	83 ec 0c             	sub    $0xc,%esp
  802a61:	ff 75 a8             	pushl  -0x58(%ebp)
  802a64:	e8 ee f6 ff ff       	call   802157 <get_block_size>
  802a69:	83 c4 10             	add    $0x10,%esp
  802a6c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	83 c0 08             	add    $0x8,%eax
  802a75:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a78:	0f 87 ef 00 00 00    	ja     802b6d <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	83 c0 18             	add    $0x18,%eax
  802a84:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a87:	77 1d                	ja     802aa6 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a8f:	0f 86 d8 00 00 00    	jbe    802b6d <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a95:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a9b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802aa1:	e9 c7 00 00 00       	jmp    802b6d <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	83 c0 08             	add    $0x8,%eax
  802aac:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802aaf:	0f 85 9d 00 00 00    	jne    802b52 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	6a 01                	push   $0x1
  802aba:	ff 75 a4             	pushl  -0x5c(%ebp)
  802abd:	ff 75 a8             	pushl  -0x58(%ebp)
  802ac0:	e8 e3 f9 ff ff       	call   8024a8 <set_block_data>
  802ac5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802ac8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acc:	75 17                	jne    802ae5 <alloc_block_BF+0x152>
  802ace:	83 ec 04             	sub    $0x4,%esp
  802ad1:	68 53 47 80 00       	push   $0x804753
  802ad6:	68 2c 01 00 00       	push   $0x12c
  802adb:	68 71 47 80 00       	push   $0x804771
  802ae0:	e8 ad da ff ff       	call   800592 <_panic>
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	85 c0                	test   %eax,%eax
  802aec:	74 10                	je     802afe <alloc_block_BF+0x16b>
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af6:	8b 52 04             	mov    0x4(%edx),%edx
  802af9:	89 50 04             	mov    %edx,0x4(%eax)
  802afc:	eb 0b                	jmp    802b09 <alloc_block_BF+0x176>
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 04             	mov    0x4(%eax),%eax
  802b04:	a3 30 50 80 00       	mov    %eax,0x805030
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 40 04             	mov    0x4(%eax),%eax
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	74 0f                	je     802b22 <alloc_block_BF+0x18f>
  802b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b16:	8b 40 04             	mov    0x4(%eax),%eax
  802b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1c:	8b 12                	mov    (%edx),%edx
  802b1e:	89 10                	mov    %edx,(%eax)
  802b20:	eb 0a                	jmp    802b2c <alloc_block_BF+0x199>
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3f:	a1 38 50 80 00       	mov    0x805038,%eax
  802b44:	48                   	dec    %eax
  802b45:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802b4a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b4d:	e9 24 04 00 00       	jmp    802f76 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b58:	76 13                	jbe    802b6d <alloc_block_BF+0x1da>
					{
						internal = 1;
  802b5a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802b61:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802b67:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b6a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b6d:	a1 34 50 80 00       	mov    0x805034,%eax
  802b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b79:	74 07                	je     802b82 <alloc_block_BF+0x1ef>
  802b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	eb 05                	jmp    802b87 <alloc_block_BF+0x1f4>
  802b82:	b8 00 00 00 00       	mov    $0x0,%eax
  802b87:	a3 34 50 80 00       	mov    %eax,0x805034
  802b8c:	a1 34 50 80 00       	mov    0x805034,%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	0f 85 bf fe ff ff    	jne    802a58 <alloc_block_BF+0xc5>
  802b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9d:	0f 85 b5 fe ff ff    	jne    802a58 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802ba3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ba7:	0f 84 26 02 00 00    	je     802dd3 <alloc_block_BF+0x440>
  802bad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bb1:	0f 85 1c 02 00 00    	jne    802dd3 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bba:	2b 45 08             	sub    0x8(%ebp),%eax
  802bbd:	83 e8 08             	sub    $0x8,%eax
  802bc0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	8d 50 08             	lea    0x8(%eax),%edx
  802bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcc:	01 d0                	add    %edx,%eax
  802bce:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	83 c0 08             	add    $0x8,%eax
  802bd7:	83 ec 04             	sub    $0x4,%esp
  802bda:	6a 01                	push   $0x1
  802bdc:	50                   	push   %eax
  802bdd:	ff 75 f0             	pushl  -0x10(%ebp)
  802be0:	e8 c3 f8 ff ff       	call   8024a8 <set_block_data>
  802be5:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802beb:	8b 40 04             	mov    0x4(%eax),%eax
  802bee:	85 c0                	test   %eax,%eax
  802bf0:	75 68                	jne    802c5a <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bf2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bf6:	75 17                	jne    802c0f <alloc_block_BF+0x27c>
  802bf8:	83 ec 04             	sub    $0x4,%esp
  802bfb:	68 8c 47 80 00       	push   $0x80478c
  802c00:	68 45 01 00 00       	push   $0x145
  802c05:	68 71 47 80 00       	push   $0x804771
  802c0a:	e8 83 d9 ff ff       	call   800592 <_panic>
  802c0f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802c15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c18:	89 10                	mov    %edx,(%eax)
  802c1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c1d:	8b 00                	mov    (%eax),%eax
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	74 0d                	je     802c30 <alloc_block_BF+0x29d>
  802c23:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c28:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c2b:	89 50 04             	mov    %edx,0x4(%eax)
  802c2e:	eb 08                	jmp    802c38 <alloc_block_BF+0x2a5>
  802c30:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c33:	a3 30 50 80 00       	mov    %eax,0x805030
  802c38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c3b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c40:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4a:	a1 38 50 80 00       	mov    0x805038,%eax
  802c4f:	40                   	inc    %eax
  802c50:	a3 38 50 80 00       	mov    %eax,0x805038
  802c55:	e9 dc 00 00 00       	jmp    802d36 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5d:	8b 00                	mov    (%eax),%eax
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	75 65                	jne    802cc8 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c63:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c67:	75 17                	jne    802c80 <alloc_block_BF+0x2ed>
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	68 c0 47 80 00       	push   $0x8047c0
  802c71:	68 4a 01 00 00       	push   $0x14a
  802c76:	68 71 47 80 00       	push   $0x804771
  802c7b:	e8 12 d9 ff ff       	call   800592 <_panic>
  802c80:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c89:	89 50 04             	mov    %edx,0x4(%eax)
  802c8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c8f:	8b 40 04             	mov    0x4(%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 0c                	je     802ca2 <alloc_block_BF+0x30f>
  802c96:	a1 30 50 80 00       	mov    0x805030,%eax
  802c9b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c9e:	89 10                	mov    %edx,(%eax)
  802ca0:	eb 08                	jmp    802caa <alloc_block_BF+0x317>
  802ca2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802caa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cad:	a3 30 50 80 00       	mov    %eax,0x805030
  802cb2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbb:	a1 38 50 80 00       	mov    0x805038,%eax
  802cc0:	40                   	inc    %eax
  802cc1:	a3 38 50 80 00       	mov    %eax,0x805038
  802cc6:	eb 6e                	jmp    802d36 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802cc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ccc:	74 06                	je     802cd4 <alloc_block_BF+0x341>
  802cce:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802cd2:	75 17                	jne    802ceb <alloc_block_BF+0x358>
  802cd4:	83 ec 04             	sub    $0x4,%esp
  802cd7:	68 e4 47 80 00       	push   $0x8047e4
  802cdc:	68 4f 01 00 00       	push   $0x14f
  802ce1:	68 71 47 80 00       	push   $0x804771
  802ce6:	e8 a7 d8 ff ff       	call   800592 <_panic>
  802ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cee:	8b 10                	mov    (%eax),%edx
  802cf0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf3:	89 10                	mov    %edx,(%eax)
  802cf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	74 0b                	je     802d09 <alloc_block_BF+0x376>
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d06:	89 50 04             	mov    %edx,0x4(%eax)
  802d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d0f:	89 10                	mov    %edx,(%eax)
  802d11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d17:	89 50 04             	mov    %edx,0x4(%eax)
  802d1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	75 08                	jne    802d2b <alloc_block_BF+0x398>
  802d23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d26:	a3 30 50 80 00       	mov    %eax,0x805030
  802d2b:	a1 38 50 80 00       	mov    0x805038,%eax
  802d30:	40                   	inc    %eax
  802d31:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802d36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d3a:	75 17                	jne    802d53 <alloc_block_BF+0x3c0>
  802d3c:	83 ec 04             	sub    $0x4,%esp
  802d3f:	68 53 47 80 00       	push   $0x804753
  802d44:	68 51 01 00 00       	push   $0x151
  802d49:	68 71 47 80 00       	push   $0x804771
  802d4e:	e8 3f d8 ff ff       	call   800592 <_panic>
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 10                	je     802d6c <alloc_block_BF+0x3d9>
  802d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5f:	8b 00                	mov    (%eax),%eax
  802d61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d64:	8b 52 04             	mov    0x4(%edx),%edx
  802d67:	89 50 04             	mov    %edx,0x4(%eax)
  802d6a:	eb 0b                	jmp    802d77 <alloc_block_BF+0x3e4>
  802d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6f:	8b 40 04             	mov    0x4(%eax),%eax
  802d72:	a3 30 50 80 00       	mov    %eax,0x805030
  802d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7a:	8b 40 04             	mov    0x4(%eax),%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	74 0f                	je     802d90 <alloc_block_BF+0x3fd>
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	8b 40 04             	mov    0x4(%eax),%eax
  802d87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8a:	8b 12                	mov    (%edx),%edx
  802d8c:	89 10                	mov    %edx,(%eax)
  802d8e:	eb 0a                	jmp    802d9a <alloc_block_BF+0x407>
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dad:	a1 38 50 80 00       	mov    0x805038,%eax
  802db2:	48                   	dec    %eax
  802db3:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802db8:	83 ec 04             	sub    $0x4,%esp
  802dbb:	6a 00                	push   $0x0
  802dbd:	ff 75 d0             	pushl  -0x30(%ebp)
  802dc0:	ff 75 cc             	pushl  -0x34(%ebp)
  802dc3:	e8 e0 f6 ff ff       	call   8024a8 <set_block_data>
  802dc8:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dce:	e9 a3 01 00 00       	jmp    802f76 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802dd3:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802dd7:	0f 85 9d 00 00 00    	jne    802e7a <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ddd:	83 ec 04             	sub    $0x4,%esp
  802de0:	6a 01                	push   $0x1
  802de2:	ff 75 ec             	pushl  -0x14(%ebp)
  802de5:	ff 75 f0             	pushl  -0x10(%ebp)
  802de8:	e8 bb f6 ff ff       	call   8024a8 <set_block_data>
  802ded:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802df0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df4:	75 17                	jne    802e0d <alloc_block_BF+0x47a>
  802df6:	83 ec 04             	sub    $0x4,%esp
  802df9:	68 53 47 80 00       	push   $0x804753
  802dfe:	68 58 01 00 00       	push   $0x158
  802e03:	68 71 47 80 00       	push   $0x804771
  802e08:	e8 85 d7 ff ff       	call   800592 <_panic>
  802e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e10:	8b 00                	mov    (%eax),%eax
  802e12:	85 c0                	test   %eax,%eax
  802e14:	74 10                	je     802e26 <alloc_block_BF+0x493>
  802e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e19:	8b 00                	mov    (%eax),%eax
  802e1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e1e:	8b 52 04             	mov    0x4(%edx),%edx
  802e21:	89 50 04             	mov    %edx,0x4(%eax)
  802e24:	eb 0b                	jmp    802e31 <alloc_block_BF+0x49e>
  802e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e29:	8b 40 04             	mov    0x4(%eax),%eax
  802e2c:	a3 30 50 80 00       	mov    %eax,0x805030
  802e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e34:	8b 40 04             	mov    0x4(%eax),%eax
  802e37:	85 c0                	test   %eax,%eax
  802e39:	74 0f                	je     802e4a <alloc_block_BF+0x4b7>
  802e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3e:	8b 40 04             	mov    0x4(%eax),%eax
  802e41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e44:	8b 12                	mov    (%edx),%edx
  802e46:	89 10                	mov    %edx,(%eax)
  802e48:	eb 0a                	jmp    802e54 <alloc_block_BF+0x4c1>
  802e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4d:	8b 00                	mov    (%eax),%eax
  802e4f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e67:	a1 38 50 80 00       	mov    0x805038,%eax
  802e6c:	48                   	dec    %eax
  802e6d:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e75:	e9 fc 00 00 00       	jmp    802f76 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	83 c0 08             	add    $0x8,%eax
  802e80:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e83:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e8a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e8d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e90:	01 d0                	add    %edx,%eax
  802e92:	48                   	dec    %eax
  802e93:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e96:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e99:	ba 00 00 00 00       	mov    $0x0,%edx
  802e9e:	f7 75 c4             	divl   -0x3c(%ebp)
  802ea1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ea4:	29 d0                	sub    %edx,%eax
  802ea6:	c1 e8 0c             	shr    $0xc,%eax
  802ea9:	83 ec 0c             	sub    $0xc,%esp
  802eac:	50                   	push   %eax
  802ead:	e8 37 e7 ff ff       	call   8015e9 <sbrk>
  802eb2:	83 c4 10             	add    $0x10,%esp
  802eb5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802eb8:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802ebc:	75 0a                	jne    802ec8 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec3:	e9 ae 00 00 00       	jmp    802f76 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ec8:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802ecf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ed2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ed5:	01 d0                	add    %edx,%eax
  802ed7:	48                   	dec    %eax
  802ed8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802edb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ede:	ba 00 00 00 00       	mov    $0x0,%edx
  802ee3:	f7 75 b8             	divl   -0x48(%ebp)
  802ee6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ee9:	29 d0                	sub    %edx,%eax
  802eeb:	8d 50 fc             	lea    -0x4(%eax),%edx
  802eee:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ef1:	01 d0                	add    %edx,%eax
  802ef3:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ef8:	a1 40 50 80 00       	mov    0x805040,%eax
  802efd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802f03:	83 ec 0c             	sub    $0xc,%esp
  802f06:	68 18 48 80 00       	push   $0x804818
  802f0b:	e8 3f d9 ff ff       	call   80084f <cprintf>
  802f10:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802f13:	83 ec 08             	sub    $0x8,%esp
  802f16:	ff 75 bc             	pushl  -0x44(%ebp)
  802f19:	68 1d 48 80 00       	push   $0x80481d
  802f1e:	e8 2c d9 ff ff       	call   80084f <cprintf>
  802f23:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802f26:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802f2d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f30:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f33:	01 d0                	add    %edx,%eax
  802f35:	48                   	dec    %eax
  802f36:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802f39:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f3c:	ba 00 00 00 00       	mov    $0x0,%edx
  802f41:	f7 75 b0             	divl   -0x50(%ebp)
  802f44:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f47:	29 d0                	sub    %edx,%eax
  802f49:	83 ec 04             	sub    $0x4,%esp
  802f4c:	6a 01                	push   $0x1
  802f4e:	50                   	push   %eax
  802f4f:	ff 75 bc             	pushl  -0x44(%ebp)
  802f52:	e8 51 f5 ff ff       	call   8024a8 <set_block_data>
  802f57:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802f5a:	83 ec 0c             	sub    $0xc,%esp
  802f5d:	ff 75 bc             	pushl  -0x44(%ebp)
  802f60:	e8 36 04 00 00       	call   80339b <free_block>
  802f65:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802f68:	83 ec 0c             	sub    $0xc,%esp
  802f6b:	ff 75 08             	pushl  0x8(%ebp)
  802f6e:	e8 20 fa ff ff       	call   802993 <alloc_block_BF>
  802f73:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f76:	c9                   	leave  
  802f77:	c3                   	ret    

00802f78 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f78:	55                   	push   %ebp
  802f79:	89 e5                	mov    %esp,%ebp
  802f7b:	53                   	push   %ebx
  802f7c:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f86:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f91:	74 1e                	je     802fb1 <merging+0x39>
  802f93:	ff 75 08             	pushl  0x8(%ebp)
  802f96:	e8 bc f1 ff ff       	call   802157 <get_block_size>
  802f9b:	83 c4 04             	add    $0x4,%esp
  802f9e:	89 c2                	mov    %eax,%edx
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	01 d0                	add    %edx,%eax
  802fa5:	3b 45 10             	cmp    0x10(%ebp),%eax
  802fa8:	75 07                	jne    802fb1 <merging+0x39>
		prev_is_free = 1;
  802faa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802fb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fb5:	74 1e                	je     802fd5 <merging+0x5d>
  802fb7:	ff 75 10             	pushl  0x10(%ebp)
  802fba:	e8 98 f1 ff ff       	call   802157 <get_block_size>
  802fbf:	83 c4 04             	add    $0x4,%esp
  802fc2:	89 c2                	mov    %eax,%edx
  802fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  802fc7:	01 d0                	add    %edx,%eax
  802fc9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fcc:	75 07                	jne    802fd5 <merging+0x5d>
		next_is_free = 1;
  802fce:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802fd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd9:	0f 84 cc 00 00 00    	je     8030ab <merging+0x133>
  802fdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe3:	0f 84 c2 00 00 00    	je     8030ab <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802fe9:	ff 75 08             	pushl  0x8(%ebp)
  802fec:	e8 66 f1 ff ff       	call   802157 <get_block_size>
  802ff1:	83 c4 04             	add    $0x4,%esp
  802ff4:	89 c3                	mov    %eax,%ebx
  802ff6:	ff 75 10             	pushl  0x10(%ebp)
  802ff9:	e8 59 f1 ff ff       	call   802157 <get_block_size>
  802ffe:	83 c4 04             	add    $0x4,%esp
  803001:	01 c3                	add    %eax,%ebx
  803003:	ff 75 0c             	pushl  0xc(%ebp)
  803006:	e8 4c f1 ff ff       	call   802157 <get_block_size>
  80300b:	83 c4 04             	add    $0x4,%esp
  80300e:	01 d8                	add    %ebx,%eax
  803010:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803013:	6a 00                	push   $0x0
  803015:	ff 75 ec             	pushl  -0x14(%ebp)
  803018:	ff 75 08             	pushl  0x8(%ebp)
  80301b:	e8 88 f4 ff ff       	call   8024a8 <set_block_data>
  803020:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803023:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803027:	75 17                	jne    803040 <merging+0xc8>
  803029:	83 ec 04             	sub    $0x4,%esp
  80302c:	68 53 47 80 00       	push   $0x804753
  803031:	68 7d 01 00 00       	push   $0x17d
  803036:	68 71 47 80 00       	push   $0x804771
  80303b:	e8 52 d5 ff ff       	call   800592 <_panic>
  803040:	8b 45 0c             	mov    0xc(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	74 10                	je     803059 <merging+0xe1>
  803049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803051:	8b 52 04             	mov    0x4(%edx),%edx
  803054:	89 50 04             	mov    %edx,0x4(%eax)
  803057:	eb 0b                	jmp    803064 <merging+0xec>
  803059:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305c:	8b 40 04             	mov    0x4(%eax),%eax
  80305f:	a3 30 50 80 00       	mov    %eax,0x805030
  803064:	8b 45 0c             	mov    0xc(%ebp),%eax
  803067:	8b 40 04             	mov    0x4(%eax),%eax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	74 0f                	je     80307d <merging+0x105>
  80306e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803071:	8b 40 04             	mov    0x4(%eax),%eax
  803074:	8b 55 0c             	mov    0xc(%ebp),%edx
  803077:	8b 12                	mov    (%edx),%edx
  803079:	89 10                	mov    %edx,(%eax)
  80307b:	eb 0a                	jmp    803087 <merging+0x10f>
  80307d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80308a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803090:	8b 45 0c             	mov    0xc(%ebp),%eax
  803093:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309a:	a1 38 50 80 00       	mov    0x805038,%eax
  80309f:	48                   	dec    %eax
  8030a0:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8030a5:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030a6:	e9 ea 02 00 00       	jmp    803395 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8030ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030af:	74 3b                	je     8030ec <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8030b1:	83 ec 0c             	sub    $0xc,%esp
  8030b4:	ff 75 08             	pushl  0x8(%ebp)
  8030b7:	e8 9b f0 ff ff       	call   802157 <get_block_size>
  8030bc:	83 c4 10             	add    $0x10,%esp
  8030bf:	89 c3                	mov    %eax,%ebx
  8030c1:	83 ec 0c             	sub    $0xc,%esp
  8030c4:	ff 75 10             	pushl  0x10(%ebp)
  8030c7:	e8 8b f0 ff ff       	call   802157 <get_block_size>
  8030cc:	83 c4 10             	add    $0x10,%esp
  8030cf:	01 d8                	add    %ebx,%eax
  8030d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8030d4:	83 ec 04             	sub    $0x4,%esp
  8030d7:	6a 00                	push   $0x0
  8030d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8030dc:	ff 75 08             	pushl  0x8(%ebp)
  8030df:	e8 c4 f3 ff ff       	call   8024a8 <set_block_data>
  8030e4:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030e7:	e9 a9 02 00 00       	jmp    803395 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8030ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030f0:	0f 84 2d 01 00 00    	je     803223 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8030f6:	83 ec 0c             	sub    $0xc,%esp
  8030f9:	ff 75 10             	pushl  0x10(%ebp)
  8030fc:	e8 56 f0 ff ff       	call   802157 <get_block_size>
  803101:	83 c4 10             	add    $0x10,%esp
  803104:	89 c3                	mov    %eax,%ebx
  803106:	83 ec 0c             	sub    $0xc,%esp
  803109:	ff 75 0c             	pushl  0xc(%ebp)
  80310c:	e8 46 f0 ff ff       	call   802157 <get_block_size>
  803111:	83 c4 10             	add    $0x10,%esp
  803114:	01 d8                	add    %ebx,%eax
  803116:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803119:	83 ec 04             	sub    $0x4,%esp
  80311c:	6a 00                	push   $0x0
  80311e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803121:	ff 75 10             	pushl  0x10(%ebp)
  803124:	e8 7f f3 ff ff       	call   8024a8 <set_block_data>
  803129:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80312c:	8b 45 10             	mov    0x10(%ebp),%eax
  80312f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803132:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803136:	74 06                	je     80313e <merging+0x1c6>
  803138:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80313c:	75 17                	jne    803155 <merging+0x1dd>
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	68 2c 48 80 00       	push   $0x80482c
  803146:	68 8d 01 00 00       	push   $0x18d
  80314b:	68 71 47 80 00       	push   $0x804771
  803150:	e8 3d d4 ff ff       	call   800592 <_panic>
  803155:	8b 45 0c             	mov    0xc(%ebp),%eax
  803158:	8b 50 04             	mov    0x4(%eax),%edx
  80315b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80315e:	89 50 04             	mov    %edx,0x4(%eax)
  803161:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803164:	8b 55 0c             	mov    0xc(%ebp),%edx
  803167:	89 10                	mov    %edx,(%eax)
  803169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	74 0d                	je     803180 <merging+0x208>
  803173:	8b 45 0c             	mov    0xc(%ebp),%eax
  803176:	8b 40 04             	mov    0x4(%eax),%eax
  803179:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80317c:	89 10                	mov    %edx,(%eax)
  80317e:	eb 08                	jmp    803188 <merging+0x210>
  803180:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803183:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80318e:	89 50 04             	mov    %edx,0x4(%eax)
  803191:	a1 38 50 80 00       	mov    0x805038,%eax
  803196:	40                   	inc    %eax
  803197:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80319c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031a0:	75 17                	jne    8031b9 <merging+0x241>
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	68 53 47 80 00       	push   $0x804753
  8031aa:	68 8e 01 00 00       	push   $0x18e
  8031af:	68 71 47 80 00       	push   $0x804771
  8031b4:	e8 d9 d3 ff ff       	call   800592 <_panic>
  8031b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031bc:	8b 00                	mov    (%eax),%eax
  8031be:	85 c0                	test   %eax,%eax
  8031c0:	74 10                	je     8031d2 <merging+0x25a>
  8031c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031ca:	8b 52 04             	mov    0x4(%edx),%edx
  8031cd:	89 50 04             	mov    %edx,0x4(%eax)
  8031d0:	eb 0b                	jmp    8031dd <merging+0x265>
  8031d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d5:	8b 40 04             	mov    0x4(%eax),%eax
  8031d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8031dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e0:	8b 40 04             	mov    0x4(%eax),%eax
  8031e3:	85 c0                	test   %eax,%eax
  8031e5:	74 0f                	je     8031f6 <merging+0x27e>
  8031e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ea:	8b 40 04             	mov    0x4(%eax),%eax
  8031ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031f0:	8b 12                	mov    (%edx),%edx
  8031f2:	89 10                	mov    %edx,(%eax)
  8031f4:	eb 0a                	jmp    803200 <merging+0x288>
  8031f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803200:	8b 45 0c             	mov    0xc(%ebp),%eax
  803203:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80320c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803213:	a1 38 50 80 00       	mov    0x805038,%eax
  803218:	48                   	dec    %eax
  803219:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80321e:	e9 72 01 00 00       	jmp    803395 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803223:	8b 45 10             	mov    0x10(%ebp),%eax
  803226:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322d:	74 79                	je     8032a8 <merging+0x330>
  80322f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803233:	74 73                	je     8032a8 <merging+0x330>
  803235:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803239:	74 06                	je     803241 <merging+0x2c9>
  80323b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80323f:	75 17                	jne    803258 <merging+0x2e0>
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	68 e4 47 80 00       	push   $0x8047e4
  803249:	68 94 01 00 00       	push   $0x194
  80324e:	68 71 47 80 00       	push   $0x804771
  803253:	e8 3a d3 ff ff       	call   800592 <_panic>
  803258:	8b 45 08             	mov    0x8(%ebp),%eax
  80325b:	8b 10                	mov    (%eax),%edx
  80325d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803260:	89 10                	mov    %edx,(%eax)
  803262:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803265:	8b 00                	mov    (%eax),%eax
  803267:	85 c0                	test   %eax,%eax
  803269:	74 0b                	je     803276 <merging+0x2fe>
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803273:	89 50 04             	mov    %edx,0x4(%eax)
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80327c:	89 10                	mov    %edx,(%eax)
  80327e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803281:	8b 55 08             	mov    0x8(%ebp),%edx
  803284:	89 50 04             	mov    %edx,0x4(%eax)
  803287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	75 08                	jne    803298 <merging+0x320>
  803290:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803293:	a3 30 50 80 00       	mov    %eax,0x805030
  803298:	a1 38 50 80 00       	mov    0x805038,%eax
  80329d:	40                   	inc    %eax
  80329e:	a3 38 50 80 00       	mov    %eax,0x805038
  8032a3:	e9 ce 00 00 00       	jmp    803376 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8032a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ac:	74 65                	je     803313 <merging+0x39b>
  8032ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032b2:	75 17                	jne    8032cb <merging+0x353>
  8032b4:	83 ec 04             	sub    $0x4,%esp
  8032b7:	68 c0 47 80 00       	push   $0x8047c0
  8032bc:	68 95 01 00 00       	push   $0x195
  8032c1:	68 71 47 80 00       	push   $0x804771
  8032c6:	e8 c7 d2 ff ff       	call   800592 <_panic>
  8032cb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d4:	89 50 04             	mov    %edx,0x4(%eax)
  8032d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032da:	8b 40 04             	mov    0x4(%eax),%eax
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	74 0c                	je     8032ed <merging+0x375>
  8032e1:	a1 30 50 80 00       	mov    0x805030,%eax
  8032e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032e9:	89 10                	mov    %edx,(%eax)
  8032eb:	eb 08                	jmp    8032f5 <merging+0x37d>
  8032ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8032fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803306:	a1 38 50 80 00       	mov    0x805038,%eax
  80330b:	40                   	inc    %eax
  80330c:	a3 38 50 80 00       	mov    %eax,0x805038
  803311:	eb 63                	jmp    803376 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803313:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803317:	75 17                	jne    803330 <merging+0x3b8>
  803319:	83 ec 04             	sub    $0x4,%esp
  80331c:	68 8c 47 80 00       	push   $0x80478c
  803321:	68 98 01 00 00       	push   $0x198
  803326:	68 71 47 80 00       	push   $0x804771
  80332b:	e8 62 d2 ff ff       	call   800592 <_panic>
  803330:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803336:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803339:	89 10                	mov    %edx,(%eax)
  80333b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80333e:	8b 00                	mov    (%eax),%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	74 0d                	je     803351 <merging+0x3d9>
  803344:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803349:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80334c:	89 50 04             	mov    %edx,0x4(%eax)
  80334f:	eb 08                	jmp    803359 <merging+0x3e1>
  803351:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803354:	a3 30 50 80 00       	mov    %eax,0x805030
  803359:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80335c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803361:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803364:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336b:	a1 38 50 80 00       	mov    0x805038,%eax
  803370:	40                   	inc    %eax
  803371:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803376:	83 ec 0c             	sub    $0xc,%esp
  803379:	ff 75 10             	pushl  0x10(%ebp)
  80337c:	e8 d6 ed ff ff       	call   802157 <get_block_size>
  803381:	83 c4 10             	add    $0x10,%esp
  803384:	83 ec 04             	sub    $0x4,%esp
  803387:	6a 00                	push   $0x0
  803389:	50                   	push   %eax
  80338a:	ff 75 10             	pushl  0x10(%ebp)
  80338d:	e8 16 f1 ff ff       	call   8024a8 <set_block_data>
  803392:	83 c4 10             	add    $0x10,%esp
	}
}
  803395:	90                   	nop
  803396:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803399:	c9                   	leave  
  80339a:	c3                   	ret    

0080339b <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80339b:	55                   	push   %ebp
  80339c:	89 e5                	mov    %esp,%ebp
  80339e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8033a1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8033a9:	a1 30 50 80 00       	mov    0x805030,%eax
  8033ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033b1:	73 1b                	jae    8033ce <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8033b3:	a1 30 50 80 00       	mov    0x805030,%eax
  8033b8:	83 ec 04             	sub    $0x4,%esp
  8033bb:	ff 75 08             	pushl  0x8(%ebp)
  8033be:	6a 00                	push   $0x0
  8033c0:	50                   	push   %eax
  8033c1:	e8 b2 fb ff ff       	call   802f78 <merging>
  8033c6:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033c9:	e9 8b 00 00 00       	jmp    803459 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8033ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033d6:	76 18                	jbe    8033f0 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8033d8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033dd:	83 ec 04             	sub    $0x4,%esp
  8033e0:	ff 75 08             	pushl  0x8(%ebp)
  8033e3:	50                   	push   %eax
  8033e4:	6a 00                	push   $0x0
  8033e6:	e8 8d fb ff ff       	call   802f78 <merging>
  8033eb:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033ee:	eb 69                	jmp    803459 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033f0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033f8:	eb 39                	jmp    803433 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8033fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803400:	73 29                	jae    80342b <free_block+0x90>
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	8b 00                	mov    (%eax),%eax
  803407:	3b 45 08             	cmp    0x8(%ebp),%eax
  80340a:	76 1f                	jbe    80342b <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803414:	83 ec 04             	sub    $0x4,%esp
  803417:	ff 75 08             	pushl  0x8(%ebp)
  80341a:	ff 75 f0             	pushl  -0x10(%ebp)
  80341d:	ff 75 f4             	pushl  -0xc(%ebp)
  803420:	e8 53 fb ff ff       	call   802f78 <merging>
  803425:	83 c4 10             	add    $0x10,%esp
			break;
  803428:	90                   	nop
		}
	}
}
  803429:	eb 2e                	jmp    803459 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80342b:	a1 34 50 80 00       	mov    0x805034,%eax
  803430:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803433:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803437:	74 07                	je     803440 <free_block+0xa5>
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	8b 00                	mov    (%eax),%eax
  80343e:	eb 05                	jmp    803445 <free_block+0xaa>
  803440:	b8 00 00 00 00       	mov    $0x0,%eax
  803445:	a3 34 50 80 00       	mov    %eax,0x805034
  80344a:	a1 34 50 80 00       	mov    0x805034,%eax
  80344f:	85 c0                	test   %eax,%eax
  803451:	75 a7                	jne    8033fa <free_block+0x5f>
  803453:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803457:	75 a1                	jne    8033fa <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803459:	90                   	nop
  80345a:	c9                   	leave  
  80345b:	c3                   	ret    

0080345c <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80345c:	55                   	push   %ebp
  80345d:	89 e5                	mov    %esp,%ebp
  80345f:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803462:	ff 75 08             	pushl  0x8(%ebp)
  803465:	e8 ed ec ff ff       	call   802157 <get_block_size>
  80346a:	83 c4 04             	add    $0x4,%esp
  80346d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803470:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803477:	eb 17                	jmp    803490 <copy_data+0x34>
  803479:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80347c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80347f:	01 c2                	add    %eax,%edx
  803481:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	01 c8                	add    %ecx,%eax
  803489:	8a 00                	mov    (%eax),%al
  80348b:	88 02                	mov    %al,(%edx)
  80348d:	ff 45 fc             	incl   -0x4(%ebp)
  803490:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803493:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803496:	72 e1                	jb     803479 <copy_data+0x1d>
}
  803498:	90                   	nop
  803499:	c9                   	leave  
  80349a:	c3                   	ret    

0080349b <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80349b:	55                   	push   %ebp
  80349c:	89 e5                	mov    %esp,%ebp
  80349e:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8034a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034a5:	75 23                	jne    8034ca <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8034a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034ab:	74 13                	je     8034c0 <realloc_block_FF+0x25>
  8034ad:	83 ec 0c             	sub    $0xc,%esp
  8034b0:	ff 75 0c             	pushl  0xc(%ebp)
  8034b3:	e8 1f f0 ff ff       	call   8024d7 <alloc_block_FF>
  8034b8:	83 c4 10             	add    $0x10,%esp
  8034bb:	e9 f4 06 00 00       	jmp    803bb4 <realloc_block_FF+0x719>
		return NULL;
  8034c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c5:	e9 ea 06 00 00       	jmp    803bb4 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8034ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034ce:	75 18                	jne    8034e8 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8034d0:	83 ec 0c             	sub    $0xc,%esp
  8034d3:	ff 75 08             	pushl  0x8(%ebp)
  8034d6:	e8 c0 fe ff ff       	call   80339b <free_block>
  8034db:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8034de:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e3:	e9 cc 06 00 00       	jmp    803bb4 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8034e8:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8034ec:	77 07                	ja     8034f5 <realloc_block_FF+0x5a>
  8034ee:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8034f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f8:	83 e0 01             	and    $0x1,%eax
  8034fb:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8034fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803501:	83 c0 08             	add    $0x8,%eax
  803504:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803507:	83 ec 0c             	sub    $0xc,%esp
  80350a:	ff 75 08             	pushl  0x8(%ebp)
  80350d:	e8 45 ec ff ff       	call   802157 <get_block_size>
  803512:	83 c4 10             	add    $0x10,%esp
  803515:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351b:	83 e8 08             	sub    $0x8,%eax
  80351e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	83 e8 04             	sub    $0x4,%eax
  803527:	8b 00                	mov    (%eax),%eax
  803529:	83 e0 fe             	and    $0xfffffffe,%eax
  80352c:	89 c2                	mov    %eax,%edx
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	01 d0                	add    %edx,%eax
  803533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803536:	83 ec 0c             	sub    $0xc,%esp
  803539:	ff 75 e4             	pushl  -0x1c(%ebp)
  80353c:	e8 16 ec ff ff       	call   802157 <get_block_size>
  803541:	83 c4 10             	add    $0x10,%esp
  803544:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803547:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80354a:	83 e8 08             	sub    $0x8,%eax
  80354d:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803550:	8b 45 0c             	mov    0xc(%ebp),%eax
  803553:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803556:	75 08                	jne    803560 <realloc_block_FF+0xc5>
	{
		 return va;
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	e9 54 06 00 00       	jmp    803bb4 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803560:	8b 45 0c             	mov    0xc(%ebp),%eax
  803563:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803566:	0f 83 e5 03 00 00    	jae    803951 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80356c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356f:	2b 45 0c             	sub    0xc(%ebp),%eax
  803572:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803575:	83 ec 0c             	sub    $0xc,%esp
  803578:	ff 75 e4             	pushl  -0x1c(%ebp)
  80357b:	e8 f0 eb ff ff       	call   802170 <is_free_block>
  803580:	83 c4 10             	add    $0x10,%esp
  803583:	84 c0                	test   %al,%al
  803585:	0f 84 3b 01 00 00    	je     8036c6 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80358b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80358e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803591:	01 d0                	add    %edx,%eax
  803593:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803596:	83 ec 04             	sub    $0x4,%esp
  803599:	6a 01                	push   $0x1
  80359b:	ff 75 f0             	pushl  -0x10(%ebp)
  80359e:	ff 75 08             	pushl  0x8(%ebp)
  8035a1:	e8 02 ef ff ff       	call   8024a8 <set_block_data>
  8035a6:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8035a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ac:	83 e8 04             	sub    $0x4,%eax
  8035af:	8b 00                	mov    (%eax),%eax
  8035b1:	83 e0 fe             	and    $0xfffffffe,%eax
  8035b4:	89 c2                	mov    %eax,%edx
  8035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b9:	01 d0                	add    %edx,%eax
  8035bb:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8035be:	83 ec 04             	sub    $0x4,%esp
  8035c1:	6a 00                	push   $0x0
  8035c3:	ff 75 cc             	pushl  -0x34(%ebp)
  8035c6:	ff 75 c8             	pushl  -0x38(%ebp)
  8035c9:	e8 da ee ff ff       	call   8024a8 <set_block_data>
  8035ce:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8035d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035d5:	74 06                	je     8035dd <realloc_block_FF+0x142>
  8035d7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8035db:	75 17                	jne    8035f4 <realloc_block_FF+0x159>
  8035dd:	83 ec 04             	sub    $0x4,%esp
  8035e0:	68 e4 47 80 00       	push   $0x8047e4
  8035e5:	68 f6 01 00 00       	push   $0x1f6
  8035ea:	68 71 47 80 00       	push   $0x804771
  8035ef:	e8 9e cf ff ff       	call   800592 <_panic>
  8035f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f7:	8b 10                	mov    (%eax),%edx
  8035f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035fc:	89 10                	mov    %edx,(%eax)
  8035fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803601:	8b 00                	mov    (%eax),%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	74 0b                	je     803612 <realloc_block_FF+0x177>
  803607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80360f:	89 50 04             	mov    %edx,0x4(%eax)
  803612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803615:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803618:	89 10                	mov    %edx,(%eax)
  80361a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80361d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803620:	89 50 04             	mov    %edx,0x4(%eax)
  803623:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803626:	8b 00                	mov    (%eax),%eax
  803628:	85 c0                	test   %eax,%eax
  80362a:	75 08                	jne    803634 <realloc_block_FF+0x199>
  80362c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80362f:	a3 30 50 80 00       	mov    %eax,0x805030
  803634:	a1 38 50 80 00       	mov    0x805038,%eax
  803639:	40                   	inc    %eax
  80363a:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80363f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803643:	75 17                	jne    80365c <realloc_block_FF+0x1c1>
  803645:	83 ec 04             	sub    $0x4,%esp
  803648:	68 53 47 80 00       	push   $0x804753
  80364d:	68 f7 01 00 00       	push   $0x1f7
  803652:	68 71 47 80 00       	push   $0x804771
  803657:	e8 36 cf ff ff       	call   800592 <_panic>
  80365c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365f:	8b 00                	mov    (%eax),%eax
  803661:	85 c0                	test   %eax,%eax
  803663:	74 10                	je     803675 <realloc_block_FF+0x1da>
  803665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80366d:	8b 52 04             	mov    0x4(%edx),%edx
  803670:	89 50 04             	mov    %edx,0x4(%eax)
  803673:	eb 0b                	jmp    803680 <realloc_block_FF+0x1e5>
  803675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803678:	8b 40 04             	mov    0x4(%eax),%eax
  80367b:	a3 30 50 80 00       	mov    %eax,0x805030
  803680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803683:	8b 40 04             	mov    0x4(%eax),%eax
  803686:	85 c0                	test   %eax,%eax
  803688:	74 0f                	je     803699 <realloc_block_FF+0x1fe>
  80368a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368d:	8b 40 04             	mov    0x4(%eax),%eax
  803690:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803693:	8b 12                	mov    (%edx),%edx
  803695:	89 10                	mov    %edx,(%eax)
  803697:	eb 0a                	jmp    8036a3 <realloc_block_FF+0x208>
  803699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8036bb:	48                   	dec    %eax
  8036bc:	a3 38 50 80 00       	mov    %eax,0x805038
  8036c1:	e9 83 02 00 00       	jmp    803949 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8036c6:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8036ca:	0f 86 69 02 00 00    	jbe    803939 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8036d0:	83 ec 04             	sub    $0x4,%esp
  8036d3:	6a 01                	push   $0x1
  8036d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8036d8:	ff 75 08             	pushl  0x8(%ebp)
  8036db:	e8 c8 ed ff ff       	call   8024a8 <set_block_data>
  8036e0:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e6:	83 e8 04             	sub    $0x4,%eax
  8036e9:	8b 00                	mov    (%eax),%eax
  8036eb:	83 e0 fe             	and    $0xfffffffe,%eax
  8036ee:	89 c2                	mov    %eax,%edx
  8036f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f3:	01 d0                	add    %edx,%eax
  8036f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8036f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8036fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803700:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803704:	75 68                	jne    80376e <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803706:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80370a:	75 17                	jne    803723 <realloc_block_FF+0x288>
  80370c:	83 ec 04             	sub    $0x4,%esp
  80370f:	68 8c 47 80 00       	push   $0x80478c
  803714:	68 06 02 00 00       	push   $0x206
  803719:	68 71 47 80 00       	push   $0x804771
  80371e:	e8 6f ce ff ff       	call   800592 <_panic>
  803723:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803729:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372c:	89 10                	mov    %edx,(%eax)
  80372e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803731:	8b 00                	mov    (%eax),%eax
  803733:	85 c0                	test   %eax,%eax
  803735:	74 0d                	je     803744 <realloc_block_FF+0x2a9>
  803737:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80373c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80373f:	89 50 04             	mov    %edx,0x4(%eax)
  803742:	eb 08                	jmp    80374c <realloc_block_FF+0x2b1>
  803744:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803747:	a3 30 50 80 00       	mov    %eax,0x805030
  80374c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80374f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803757:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375e:	a1 38 50 80 00       	mov    0x805038,%eax
  803763:	40                   	inc    %eax
  803764:	a3 38 50 80 00       	mov    %eax,0x805038
  803769:	e9 b0 01 00 00       	jmp    80391e <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80376e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803773:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803776:	76 68                	jbe    8037e0 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803778:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80377c:	75 17                	jne    803795 <realloc_block_FF+0x2fa>
  80377e:	83 ec 04             	sub    $0x4,%esp
  803781:	68 8c 47 80 00       	push   $0x80478c
  803786:	68 0b 02 00 00       	push   $0x20b
  80378b:	68 71 47 80 00       	push   $0x804771
  803790:	e8 fd cd ff ff       	call   800592 <_panic>
  803795:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80379b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80379e:	89 10                	mov    %edx,(%eax)
  8037a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a3:	8b 00                	mov    (%eax),%eax
  8037a5:	85 c0                	test   %eax,%eax
  8037a7:	74 0d                	je     8037b6 <realloc_block_FF+0x31b>
  8037a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037b1:	89 50 04             	mov    %edx,0x4(%eax)
  8037b4:	eb 08                	jmp    8037be <realloc_block_FF+0x323>
  8037b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8037be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d5:	40                   	inc    %eax
  8037d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8037db:	e9 3e 01 00 00       	jmp    80391e <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8037e0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037e5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037e8:	73 68                	jae    803852 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8037ea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037ee:	75 17                	jne    803807 <realloc_block_FF+0x36c>
  8037f0:	83 ec 04             	sub    $0x4,%esp
  8037f3:	68 c0 47 80 00       	push   $0x8047c0
  8037f8:	68 10 02 00 00       	push   $0x210
  8037fd:	68 71 47 80 00       	push   $0x804771
  803802:	e8 8b cd ff ff       	call   800592 <_panic>
  803807:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80380d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803810:	89 50 04             	mov    %edx,0x4(%eax)
  803813:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803816:	8b 40 04             	mov    0x4(%eax),%eax
  803819:	85 c0                	test   %eax,%eax
  80381b:	74 0c                	je     803829 <realloc_block_FF+0x38e>
  80381d:	a1 30 50 80 00       	mov    0x805030,%eax
  803822:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803825:	89 10                	mov    %edx,(%eax)
  803827:	eb 08                	jmp    803831 <realloc_block_FF+0x396>
  803829:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80382c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803831:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803834:	a3 30 50 80 00       	mov    %eax,0x805030
  803839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803842:	a1 38 50 80 00       	mov    0x805038,%eax
  803847:	40                   	inc    %eax
  803848:	a3 38 50 80 00       	mov    %eax,0x805038
  80384d:	e9 cc 00 00 00       	jmp    80391e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803852:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803859:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80385e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803861:	e9 8a 00 00 00       	jmp    8038f0 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803869:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80386c:	73 7a                	jae    8038e8 <realloc_block_FF+0x44d>
  80386e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803876:	73 70                	jae    8038e8 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80387c:	74 06                	je     803884 <realloc_block_FF+0x3e9>
  80387e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803882:	75 17                	jne    80389b <realloc_block_FF+0x400>
  803884:	83 ec 04             	sub    $0x4,%esp
  803887:	68 e4 47 80 00       	push   $0x8047e4
  80388c:	68 1a 02 00 00       	push   $0x21a
  803891:	68 71 47 80 00       	push   $0x804771
  803896:	e8 f7 cc ff ff       	call   800592 <_panic>
  80389b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389e:	8b 10                	mov    (%eax),%edx
  8038a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a3:	89 10                	mov    %edx,(%eax)
  8038a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a8:	8b 00                	mov    (%eax),%eax
  8038aa:	85 c0                	test   %eax,%eax
  8038ac:	74 0b                	je     8038b9 <realloc_block_FF+0x41e>
  8038ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b1:	8b 00                	mov    (%eax),%eax
  8038b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038b6:	89 50 04             	mov    %edx,0x4(%eax)
  8038b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038bf:	89 10                	mov    %edx,(%eax)
  8038c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038c7:	89 50 04             	mov    %edx,0x4(%eax)
  8038ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038cd:	8b 00                	mov    (%eax),%eax
  8038cf:	85 c0                	test   %eax,%eax
  8038d1:	75 08                	jne    8038db <realloc_block_FF+0x440>
  8038d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8038db:	a1 38 50 80 00       	mov    0x805038,%eax
  8038e0:	40                   	inc    %eax
  8038e1:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8038e6:	eb 36                	jmp    80391e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8038e8:	a1 34 50 80 00       	mov    0x805034,%eax
  8038ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f4:	74 07                	je     8038fd <realloc_block_FF+0x462>
  8038f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f9:	8b 00                	mov    (%eax),%eax
  8038fb:	eb 05                	jmp    803902 <realloc_block_FF+0x467>
  8038fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803902:	a3 34 50 80 00       	mov    %eax,0x805034
  803907:	a1 34 50 80 00       	mov    0x805034,%eax
  80390c:	85 c0                	test   %eax,%eax
  80390e:	0f 85 52 ff ff ff    	jne    803866 <realloc_block_FF+0x3cb>
  803914:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803918:	0f 85 48 ff ff ff    	jne    803866 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80391e:	83 ec 04             	sub    $0x4,%esp
  803921:	6a 00                	push   $0x0
  803923:	ff 75 d8             	pushl  -0x28(%ebp)
  803926:	ff 75 d4             	pushl  -0x2c(%ebp)
  803929:	e8 7a eb ff ff       	call   8024a8 <set_block_data>
  80392e:	83 c4 10             	add    $0x10,%esp
				return va;
  803931:	8b 45 08             	mov    0x8(%ebp),%eax
  803934:	e9 7b 02 00 00       	jmp    803bb4 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803939:	83 ec 0c             	sub    $0xc,%esp
  80393c:	68 61 48 80 00       	push   $0x804861
  803941:	e8 09 cf ff ff       	call   80084f <cprintf>
  803946:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803949:	8b 45 08             	mov    0x8(%ebp),%eax
  80394c:	e9 63 02 00 00       	jmp    803bb4 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803951:	8b 45 0c             	mov    0xc(%ebp),%eax
  803954:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803957:	0f 86 4d 02 00 00    	jbe    803baa <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80395d:	83 ec 0c             	sub    $0xc,%esp
  803960:	ff 75 e4             	pushl  -0x1c(%ebp)
  803963:	e8 08 e8 ff ff       	call   802170 <is_free_block>
  803968:	83 c4 10             	add    $0x10,%esp
  80396b:	84 c0                	test   %al,%al
  80396d:	0f 84 37 02 00 00    	je     803baa <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803973:	8b 45 0c             	mov    0xc(%ebp),%eax
  803976:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803979:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80397c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80397f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803982:	76 38                	jbe    8039bc <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803984:	83 ec 0c             	sub    $0xc,%esp
  803987:	ff 75 08             	pushl  0x8(%ebp)
  80398a:	e8 0c fa ff ff       	call   80339b <free_block>
  80398f:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803992:	83 ec 0c             	sub    $0xc,%esp
  803995:	ff 75 0c             	pushl  0xc(%ebp)
  803998:	e8 3a eb ff ff       	call   8024d7 <alloc_block_FF>
  80399d:	83 c4 10             	add    $0x10,%esp
  8039a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8039a3:	83 ec 08             	sub    $0x8,%esp
  8039a6:	ff 75 c0             	pushl  -0x40(%ebp)
  8039a9:	ff 75 08             	pushl  0x8(%ebp)
  8039ac:	e8 ab fa ff ff       	call   80345c <copy_data>
  8039b1:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8039b4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8039b7:	e9 f8 01 00 00       	jmp    803bb4 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8039bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039bf:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8039c2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8039c5:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8039c9:	0f 87 a0 00 00 00    	ja     803a6f <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8039cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039d3:	75 17                	jne    8039ec <realloc_block_FF+0x551>
  8039d5:	83 ec 04             	sub    $0x4,%esp
  8039d8:	68 53 47 80 00       	push   $0x804753
  8039dd:	68 38 02 00 00       	push   $0x238
  8039e2:	68 71 47 80 00       	push   $0x804771
  8039e7:	e8 a6 cb ff ff       	call   800592 <_panic>
  8039ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ef:	8b 00                	mov    (%eax),%eax
  8039f1:	85 c0                	test   %eax,%eax
  8039f3:	74 10                	je     803a05 <realloc_block_FF+0x56a>
  8039f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f8:	8b 00                	mov    (%eax),%eax
  8039fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039fd:	8b 52 04             	mov    0x4(%edx),%edx
  803a00:	89 50 04             	mov    %edx,0x4(%eax)
  803a03:	eb 0b                	jmp    803a10 <realloc_block_FF+0x575>
  803a05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a08:	8b 40 04             	mov    0x4(%eax),%eax
  803a0b:	a3 30 50 80 00       	mov    %eax,0x805030
  803a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a13:	8b 40 04             	mov    0x4(%eax),%eax
  803a16:	85 c0                	test   %eax,%eax
  803a18:	74 0f                	je     803a29 <realloc_block_FF+0x58e>
  803a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1d:	8b 40 04             	mov    0x4(%eax),%eax
  803a20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a23:	8b 12                	mov    (%edx),%edx
  803a25:	89 10                	mov    %edx,(%eax)
  803a27:	eb 0a                	jmp    803a33 <realloc_block_FF+0x598>
  803a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2c:	8b 00                	mov    (%eax),%eax
  803a2e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a46:	a1 38 50 80 00       	mov    0x805038,%eax
  803a4b:	48                   	dec    %eax
  803a4c:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803a51:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a57:	01 d0                	add    %edx,%eax
  803a59:	83 ec 04             	sub    $0x4,%esp
  803a5c:	6a 01                	push   $0x1
  803a5e:	50                   	push   %eax
  803a5f:	ff 75 08             	pushl  0x8(%ebp)
  803a62:	e8 41 ea ff ff       	call   8024a8 <set_block_data>
  803a67:	83 c4 10             	add    $0x10,%esp
  803a6a:	e9 36 01 00 00       	jmp    803ba5 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803a6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a72:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a75:	01 d0                	add    %edx,%eax
  803a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a7a:	83 ec 04             	sub    $0x4,%esp
  803a7d:	6a 01                	push   $0x1
  803a7f:	ff 75 f0             	pushl  -0x10(%ebp)
  803a82:	ff 75 08             	pushl  0x8(%ebp)
  803a85:	e8 1e ea ff ff       	call   8024a8 <set_block_data>
  803a8a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a90:	83 e8 04             	sub    $0x4,%eax
  803a93:	8b 00                	mov    (%eax),%eax
  803a95:	83 e0 fe             	and    $0xfffffffe,%eax
  803a98:	89 c2                	mov    %eax,%edx
  803a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9d:	01 d0                	add    %edx,%eax
  803a9f:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803aa2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803aa6:	74 06                	je     803aae <realloc_block_FF+0x613>
  803aa8:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803aac:	75 17                	jne    803ac5 <realloc_block_FF+0x62a>
  803aae:	83 ec 04             	sub    $0x4,%esp
  803ab1:	68 e4 47 80 00       	push   $0x8047e4
  803ab6:	68 44 02 00 00       	push   $0x244
  803abb:	68 71 47 80 00       	push   $0x804771
  803ac0:	e8 cd ca ff ff       	call   800592 <_panic>
  803ac5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac8:	8b 10                	mov    (%eax),%edx
  803aca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803acd:	89 10                	mov    %edx,(%eax)
  803acf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ad2:	8b 00                	mov    (%eax),%eax
  803ad4:	85 c0                	test   %eax,%eax
  803ad6:	74 0b                	je     803ae3 <realloc_block_FF+0x648>
  803ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803adb:	8b 00                	mov    (%eax),%eax
  803add:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ae0:	89 50 04             	mov    %edx,0x4(%eax)
  803ae3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ae9:	89 10                	mov    %edx,(%eax)
  803aeb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803af1:	89 50 04             	mov    %edx,0x4(%eax)
  803af4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803af7:	8b 00                	mov    (%eax),%eax
  803af9:	85 c0                	test   %eax,%eax
  803afb:	75 08                	jne    803b05 <realloc_block_FF+0x66a>
  803afd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b00:	a3 30 50 80 00       	mov    %eax,0x805030
  803b05:	a1 38 50 80 00       	mov    0x805038,%eax
  803b0a:	40                   	inc    %eax
  803b0b:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803b10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b14:	75 17                	jne    803b2d <realloc_block_FF+0x692>
  803b16:	83 ec 04             	sub    $0x4,%esp
  803b19:	68 53 47 80 00       	push   $0x804753
  803b1e:	68 45 02 00 00       	push   $0x245
  803b23:	68 71 47 80 00       	push   $0x804771
  803b28:	e8 65 ca ff ff       	call   800592 <_panic>
  803b2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b30:	8b 00                	mov    (%eax),%eax
  803b32:	85 c0                	test   %eax,%eax
  803b34:	74 10                	je     803b46 <realloc_block_FF+0x6ab>
  803b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b39:	8b 00                	mov    (%eax),%eax
  803b3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b3e:	8b 52 04             	mov    0x4(%edx),%edx
  803b41:	89 50 04             	mov    %edx,0x4(%eax)
  803b44:	eb 0b                	jmp    803b51 <realloc_block_FF+0x6b6>
  803b46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b49:	8b 40 04             	mov    0x4(%eax),%eax
  803b4c:	a3 30 50 80 00       	mov    %eax,0x805030
  803b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b54:	8b 40 04             	mov    0x4(%eax),%eax
  803b57:	85 c0                	test   %eax,%eax
  803b59:	74 0f                	je     803b6a <realloc_block_FF+0x6cf>
  803b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5e:	8b 40 04             	mov    0x4(%eax),%eax
  803b61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b64:	8b 12                	mov    (%edx),%edx
  803b66:	89 10                	mov    %edx,(%eax)
  803b68:	eb 0a                	jmp    803b74 <realloc_block_FF+0x6d9>
  803b6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6d:	8b 00                	mov    (%eax),%eax
  803b6f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b87:	a1 38 50 80 00       	mov    0x805038,%eax
  803b8c:	48                   	dec    %eax
  803b8d:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b92:	83 ec 04             	sub    $0x4,%esp
  803b95:	6a 00                	push   $0x0
  803b97:	ff 75 bc             	pushl  -0x44(%ebp)
  803b9a:	ff 75 b8             	pushl  -0x48(%ebp)
  803b9d:	e8 06 e9 ff ff       	call   8024a8 <set_block_data>
  803ba2:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba8:	eb 0a                	jmp    803bb4 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803baa:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803bb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803bb4:	c9                   	leave  
  803bb5:	c3                   	ret    

00803bb6 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803bb6:	55                   	push   %ebp
  803bb7:	89 e5                	mov    %esp,%ebp
  803bb9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803bbc:	83 ec 04             	sub    $0x4,%esp
  803bbf:	68 68 48 80 00       	push   $0x804868
  803bc4:	68 58 02 00 00       	push   $0x258
  803bc9:	68 71 47 80 00       	push   $0x804771
  803bce:	e8 bf c9 ff ff       	call   800592 <_panic>

00803bd3 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803bd3:	55                   	push   %ebp
  803bd4:	89 e5                	mov    %esp,%ebp
  803bd6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803bd9:	83 ec 04             	sub    $0x4,%esp
  803bdc:	68 90 48 80 00       	push   $0x804890
  803be1:	68 61 02 00 00       	push   $0x261
  803be6:	68 71 47 80 00       	push   $0x804771
  803beb:	e8 a2 c9 ff ff       	call   800592 <_panic>

00803bf0 <__udivdi3>:
  803bf0:	55                   	push   %ebp
  803bf1:	57                   	push   %edi
  803bf2:	56                   	push   %esi
  803bf3:	53                   	push   %ebx
  803bf4:	83 ec 1c             	sub    $0x1c,%esp
  803bf7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bfb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c07:	89 ca                	mov    %ecx,%edx
  803c09:	89 f8                	mov    %edi,%eax
  803c0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c0f:	85 f6                	test   %esi,%esi
  803c11:	75 2d                	jne    803c40 <__udivdi3+0x50>
  803c13:	39 cf                	cmp    %ecx,%edi
  803c15:	77 65                	ja     803c7c <__udivdi3+0x8c>
  803c17:	89 fd                	mov    %edi,%ebp
  803c19:	85 ff                	test   %edi,%edi
  803c1b:	75 0b                	jne    803c28 <__udivdi3+0x38>
  803c1d:	b8 01 00 00 00       	mov    $0x1,%eax
  803c22:	31 d2                	xor    %edx,%edx
  803c24:	f7 f7                	div    %edi
  803c26:	89 c5                	mov    %eax,%ebp
  803c28:	31 d2                	xor    %edx,%edx
  803c2a:	89 c8                	mov    %ecx,%eax
  803c2c:	f7 f5                	div    %ebp
  803c2e:	89 c1                	mov    %eax,%ecx
  803c30:	89 d8                	mov    %ebx,%eax
  803c32:	f7 f5                	div    %ebp
  803c34:	89 cf                	mov    %ecx,%edi
  803c36:	89 fa                	mov    %edi,%edx
  803c38:	83 c4 1c             	add    $0x1c,%esp
  803c3b:	5b                   	pop    %ebx
  803c3c:	5e                   	pop    %esi
  803c3d:	5f                   	pop    %edi
  803c3e:	5d                   	pop    %ebp
  803c3f:	c3                   	ret    
  803c40:	39 ce                	cmp    %ecx,%esi
  803c42:	77 28                	ja     803c6c <__udivdi3+0x7c>
  803c44:	0f bd fe             	bsr    %esi,%edi
  803c47:	83 f7 1f             	xor    $0x1f,%edi
  803c4a:	75 40                	jne    803c8c <__udivdi3+0x9c>
  803c4c:	39 ce                	cmp    %ecx,%esi
  803c4e:	72 0a                	jb     803c5a <__udivdi3+0x6a>
  803c50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c54:	0f 87 9e 00 00 00    	ja     803cf8 <__udivdi3+0x108>
  803c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c5f:	89 fa                	mov    %edi,%edx
  803c61:	83 c4 1c             	add    $0x1c,%esp
  803c64:	5b                   	pop    %ebx
  803c65:	5e                   	pop    %esi
  803c66:	5f                   	pop    %edi
  803c67:	5d                   	pop    %ebp
  803c68:	c3                   	ret    
  803c69:	8d 76 00             	lea    0x0(%esi),%esi
  803c6c:	31 ff                	xor    %edi,%edi
  803c6e:	31 c0                	xor    %eax,%eax
  803c70:	89 fa                	mov    %edi,%edx
  803c72:	83 c4 1c             	add    $0x1c,%esp
  803c75:	5b                   	pop    %ebx
  803c76:	5e                   	pop    %esi
  803c77:	5f                   	pop    %edi
  803c78:	5d                   	pop    %ebp
  803c79:	c3                   	ret    
  803c7a:	66 90                	xchg   %ax,%ax
  803c7c:	89 d8                	mov    %ebx,%eax
  803c7e:	f7 f7                	div    %edi
  803c80:	31 ff                	xor    %edi,%edi
  803c82:	89 fa                	mov    %edi,%edx
  803c84:	83 c4 1c             	add    $0x1c,%esp
  803c87:	5b                   	pop    %ebx
  803c88:	5e                   	pop    %esi
  803c89:	5f                   	pop    %edi
  803c8a:	5d                   	pop    %ebp
  803c8b:	c3                   	ret    
  803c8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c91:	89 eb                	mov    %ebp,%ebx
  803c93:	29 fb                	sub    %edi,%ebx
  803c95:	89 f9                	mov    %edi,%ecx
  803c97:	d3 e6                	shl    %cl,%esi
  803c99:	89 c5                	mov    %eax,%ebp
  803c9b:	88 d9                	mov    %bl,%cl
  803c9d:	d3 ed                	shr    %cl,%ebp
  803c9f:	89 e9                	mov    %ebp,%ecx
  803ca1:	09 f1                	or     %esi,%ecx
  803ca3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ca7:	89 f9                	mov    %edi,%ecx
  803ca9:	d3 e0                	shl    %cl,%eax
  803cab:	89 c5                	mov    %eax,%ebp
  803cad:	89 d6                	mov    %edx,%esi
  803caf:	88 d9                	mov    %bl,%cl
  803cb1:	d3 ee                	shr    %cl,%esi
  803cb3:	89 f9                	mov    %edi,%ecx
  803cb5:	d3 e2                	shl    %cl,%edx
  803cb7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cbb:	88 d9                	mov    %bl,%cl
  803cbd:	d3 e8                	shr    %cl,%eax
  803cbf:	09 c2                	or     %eax,%edx
  803cc1:	89 d0                	mov    %edx,%eax
  803cc3:	89 f2                	mov    %esi,%edx
  803cc5:	f7 74 24 0c          	divl   0xc(%esp)
  803cc9:	89 d6                	mov    %edx,%esi
  803ccb:	89 c3                	mov    %eax,%ebx
  803ccd:	f7 e5                	mul    %ebp
  803ccf:	39 d6                	cmp    %edx,%esi
  803cd1:	72 19                	jb     803cec <__udivdi3+0xfc>
  803cd3:	74 0b                	je     803ce0 <__udivdi3+0xf0>
  803cd5:	89 d8                	mov    %ebx,%eax
  803cd7:	31 ff                	xor    %edi,%edi
  803cd9:	e9 58 ff ff ff       	jmp    803c36 <__udivdi3+0x46>
  803cde:	66 90                	xchg   %ax,%ax
  803ce0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ce4:	89 f9                	mov    %edi,%ecx
  803ce6:	d3 e2                	shl    %cl,%edx
  803ce8:	39 c2                	cmp    %eax,%edx
  803cea:	73 e9                	jae    803cd5 <__udivdi3+0xe5>
  803cec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cef:	31 ff                	xor    %edi,%edi
  803cf1:	e9 40 ff ff ff       	jmp    803c36 <__udivdi3+0x46>
  803cf6:	66 90                	xchg   %ax,%ax
  803cf8:	31 c0                	xor    %eax,%eax
  803cfa:	e9 37 ff ff ff       	jmp    803c36 <__udivdi3+0x46>
  803cff:	90                   	nop

00803d00 <__umoddi3>:
  803d00:	55                   	push   %ebp
  803d01:	57                   	push   %edi
  803d02:	56                   	push   %esi
  803d03:	53                   	push   %ebx
  803d04:	83 ec 1c             	sub    $0x1c,%esp
  803d07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d1f:	89 f3                	mov    %esi,%ebx
  803d21:	89 fa                	mov    %edi,%edx
  803d23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d27:	89 34 24             	mov    %esi,(%esp)
  803d2a:	85 c0                	test   %eax,%eax
  803d2c:	75 1a                	jne    803d48 <__umoddi3+0x48>
  803d2e:	39 f7                	cmp    %esi,%edi
  803d30:	0f 86 a2 00 00 00    	jbe    803dd8 <__umoddi3+0xd8>
  803d36:	89 c8                	mov    %ecx,%eax
  803d38:	89 f2                	mov    %esi,%edx
  803d3a:	f7 f7                	div    %edi
  803d3c:	89 d0                	mov    %edx,%eax
  803d3e:	31 d2                	xor    %edx,%edx
  803d40:	83 c4 1c             	add    $0x1c,%esp
  803d43:	5b                   	pop    %ebx
  803d44:	5e                   	pop    %esi
  803d45:	5f                   	pop    %edi
  803d46:	5d                   	pop    %ebp
  803d47:	c3                   	ret    
  803d48:	39 f0                	cmp    %esi,%eax
  803d4a:	0f 87 ac 00 00 00    	ja     803dfc <__umoddi3+0xfc>
  803d50:	0f bd e8             	bsr    %eax,%ebp
  803d53:	83 f5 1f             	xor    $0x1f,%ebp
  803d56:	0f 84 ac 00 00 00    	je     803e08 <__umoddi3+0x108>
  803d5c:	bf 20 00 00 00       	mov    $0x20,%edi
  803d61:	29 ef                	sub    %ebp,%edi
  803d63:	89 fe                	mov    %edi,%esi
  803d65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d69:	89 e9                	mov    %ebp,%ecx
  803d6b:	d3 e0                	shl    %cl,%eax
  803d6d:	89 d7                	mov    %edx,%edi
  803d6f:	89 f1                	mov    %esi,%ecx
  803d71:	d3 ef                	shr    %cl,%edi
  803d73:	09 c7                	or     %eax,%edi
  803d75:	89 e9                	mov    %ebp,%ecx
  803d77:	d3 e2                	shl    %cl,%edx
  803d79:	89 14 24             	mov    %edx,(%esp)
  803d7c:	89 d8                	mov    %ebx,%eax
  803d7e:	d3 e0                	shl    %cl,%eax
  803d80:	89 c2                	mov    %eax,%edx
  803d82:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d86:	d3 e0                	shl    %cl,%eax
  803d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d90:	89 f1                	mov    %esi,%ecx
  803d92:	d3 e8                	shr    %cl,%eax
  803d94:	09 d0                	or     %edx,%eax
  803d96:	d3 eb                	shr    %cl,%ebx
  803d98:	89 da                	mov    %ebx,%edx
  803d9a:	f7 f7                	div    %edi
  803d9c:	89 d3                	mov    %edx,%ebx
  803d9e:	f7 24 24             	mull   (%esp)
  803da1:	89 c6                	mov    %eax,%esi
  803da3:	89 d1                	mov    %edx,%ecx
  803da5:	39 d3                	cmp    %edx,%ebx
  803da7:	0f 82 87 00 00 00    	jb     803e34 <__umoddi3+0x134>
  803dad:	0f 84 91 00 00 00    	je     803e44 <__umoddi3+0x144>
  803db3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803db7:	29 f2                	sub    %esi,%edx
  803db9:	19 cb                	sbb    %ecx,%ebx
  803dbb:	89 d8                	mov    %ebx,%eax
  803dbd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803dc1:	d3 e0                	shl    %cl,%eax
  803dc3:	89 e9                	mov    %ebp,%ecx
  803dc5:	d3 ea                	shr    %cl,%edx
  803dc7:	09 d0                	or     %edx,%eax
  803dc9:	89 e9                	mov    %ebp,%ecx
  803dcb:	d3 eb                	shr    %cl,%ebx
  803dcd:	89 da                	mov    %ebx,%edx
  803dcf:	83 c4 1c             	add    $0x1c,%esp
  803dd2:	5b                   	pop    %ebx
  803dd3:	5e                   	pop    %esi
  803dd4:	5f                   	pop    %edi
  803dd5:	5d                   	pop    %ebp
  803dd6:	c3                   	ret    
  803dd7:	90                   	nop
  803dd8:	89 fd                	mov    %edi,%ebp
  803dda:	85 ff                	test   %edi,%edi
  803ddc:	75 0b                	jne    803de9 <__umoddi3+0xe9>
  803dde:	b8 01 00 00 00       	mov    $0x1,%eax
  803de3:	31 d2                	xor    %edx,%edx
  803de5:	f7 f7                	div    %edi
  803de7:	89 c5                	mov    %eax,%ebp
  803de9:	89 f0                	mov    %esi,%eax
  803deb:	31 d2                	xor    %edx,%edx
  803ded:	f7 f5                	div    %ebp
  803def:	89 c8                	mov    %ecx,%eax
  803df1:	f7 f5                	div    %ebp
  803df3:	89 d0                	mov    %edx,%eax
  803df5:	e9 44 ff ff ff       	jmp    803d3e <__umoddi3+0x3e>
  803dfa:	66 90                	xchg   %ax,%ax
  803dfc:	89 c8                	mov    %ecx,%eax
  803dfe:	89 f2                	mov    %esi,%edx
  803e00:	83 c4 1c             	add    $0x1c,%esp
  803e03:	5b                   	pop    %ebx
  803e04:	5e                   	pop    %esi
  803e05:	5f                   	pop    %edi
  803e06:	5d                   	pop    %ebp
  803e07:	c3                   	ret    
  803e08:	3b 04 24             	cmp    (%esp),%eax
  803e0b:	72 06                	jb     803e13 <__umoddi3+0x113>
  803e0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e11:	77 0f                	ja     803e22 <__umoddi3+0x122>
  803e13:	89 f2                	mov    %esi,%edx
  803e15:	29 f9                	sub    %edi,%ecx
  803e17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e1b:	89 14 24             	mov    %edx,(%esp)
  803e1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e22:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e26:	8b 14 24             	mov    (%esp),%edx
  803e29:	83 c4 1c             	add    $0x1c,%esp
  803e2c:	5b                   	pop    %ebx
  803e2d:	5e                   	pop    %esi
  803e2e:	5f                   	pop    %edi
  803e2f:	5d                   	pop    %ebp
  803e30:	c3                   	ret    
  803e31:	8d 76 00             	lea    0x0(%esi),%esi
  803e34:	2b 04 24             	sub    (%esp),%eax
  803e37:	19 fa                	sbb    %edi,%edx
  803e39:	89 d1                	mov    %edx,%ecx
  803e3b:	89 c6                	mov    %eax,%esi
  803e3d:	e9 71 ff ff ff       	jmp    803db3 <__umoddi3+0xb3>
  803e42:	66 90                	xchg   %ax,%ax
  803e44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e48:	72 ea                	jb     803e34 <__umoddi3+0x134>
  803e4a:	89 d9                	mov    %ebx,%ecx
  803e4c:	e9 62 ff ff ff       	jmp    803db3 <__umoddi3+0xb3>
