
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
  80003f:	a1 04 30 80 00       	mov    0x803004,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 04 30 80 00       	mov    0x803004,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 a0 1f 80 00       	push   $0x801fa0
  800061:	6a 14                	push   $0x14
  800063:	68 bc 1f 80 00       	push   $0x801fbc
  800068:	e8 1d 05 00 00       	call   80058a <_panic>
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
  800082:	e8 a4 17 00 00       	call   80182b <sys_calculate_free_frames>
  800087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = smalloc("x", 4, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 04                	push   $0x4
  800091:	68 d7 1f 80 00       	push   $0x801fd7
  800096:	e8 9f 15 00 00       	call   80163a <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 dc 1f 80 00       	push   $0x801fdc
  8000b8:	e8 8a 07 00 00       	call   800847 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8000c0:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8000c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ca:	e8 5c 17 00 00       	call   80182b <sys_calculate_free_frames>
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
  8000f3:	e8 33 17 00 00       	call   80182b <sys_calculate_free_frames>
  8000f8:	29 c3                	sub    %eax,%ebx
  8000fa:	89 d8                	mov    %ebx,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800102:	50                   	push   %eax
  800103:	68 40 20 80 00       	push   $0x802040
  800108:	e8 3a 07 00 00       	call   800847 <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800110:	e8 16 17 00 00       	call   80182b <sys_calculate_free_frames>
  800115:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = smalloc("y", 4, 0);
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	6a 00                	push   $0x0
  80011d:	6a 04                	push   $0x4
  80011f:	68 d8 20 80 00       	push   $0x8020d8
  800124:	e8 11 15 00 00       	call   80163a <smalloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80012f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800132:	05 00 10 00 00       	add    $0x1000,%eax
  800137:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80013a:	74 17                	je     800153 <_main+0x11b>
  80013c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	68 dc 1f 80 00       	push   $0x801fdc
  80014b:	e8 f7 06 00 00       	call   800847 <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  800153:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80015a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80015d:	e8 c9 16 00 00       	call   80182b <sys_calculate_free_frames>
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
  800186:	e8 a0 16 00 00       	call   80182b <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	50                   	push   %eax
  800196:	68 40 20 80 00       	push   $0x802040
  80019b:	e8 a7 06 00 00       	call   800847 <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  8001a3:	e8 83 16 00 00       	call   80182b <sys_calculate_free_frames>
  8001a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = smalloc("z", 4, 1);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 01                	push   $0x1
  8001b0:	6a 04                	push   $0x4
  8001b2:	68 da 20 80 00       	push   $0x8020da
  8001b7:	e8 7e 14 00 00       	call   80163a <smalloc>
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8001c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c5:	05 00 20 00 00       	add    $0x2000,%eax
  8001ca:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001cd:	74 17                	je     8001e6 <_main+0x1ae>
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	68 dc 1f 80 00       	push   $0x801fdc
  8001de:	e8 64 06 00 00       	call   800847 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8001e6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001f0:	e8 36 16 00 00       	call   80182b <sys_calculate_free_frames>
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
  800219:	e8 0d 16 00 00       	call   80182b <sys_calculate_free_frames>
  80021e:	29 c3                	sub    %eax,%ebx
  800220:	89 d8                	mov    %ebx,%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	50                   	push   %eax
  800229:	68 40 20 80 00       	push   $0x802040
  80022e:	e8 14 06 00 00       	call   800847 <cprintf>
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
  800259:	a1 04 30 80 00       	mov    0x803004,%eax
  80025e:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  800264:	a1 04 30 80 00       	mov    0x803004,%eax
  800269:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  80026f:	89 c1                	mov    %eax,%ecx
  800271:	a1 04 30 80 00       	mov    0x803004,%eax
  800276:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80027c:	52                   	push   %edx
  80027d:	51                   	push   %ecx
  80027e:	50                   	push   %eax
  80027f:	68 dc 20 80 00       	push   $0x8020dc
  800284:	e8 fd 16 00 00       	call   801986 <sys_create_env>
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80028f:	a1 04 30 80 00       	mov    0x803004,%eax
  800294:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  80029a:	a1 04 30 80 00       	mov    0x803004,%eax
  80029f:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8002a5:	89 c1                	mov    %eax,%ecx
  8002a7:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ac:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002b2:	52                   	push   %edx
  8002b3:	51                   	push   %ecx
  8002b4:	50                   	push   %eax
  8002b5:	68 dc 20 80 00       	push   $0x8020dc
  8002ba:	e8 c7 16 00 00       	call   801986 <sys_create_env>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8002c5:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ca:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8002d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8002d5:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8002db:	89 c1                	mov    %eax,%ecx
  8002dd:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002e8:	52                   	push   %edx
  8002e9:	51                   	push   %ecx
  8002ea:	50                   	push   %eax
  8002eb:	68 dc 20 80 00       	push   $0x8020dc
  8002f0:	e8 91 16 00 00       	call   801986 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8002fb:	e8 d2 17 00 00       	call   801ad2 <rsttst>

	sys_run_env(id1);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 d0             	pushl  -0x30(%ebp)
  800306:	e8 99 16 00 00       	call   8019a4 <sys_run_env>
  80030b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 cc             	pushl  -0x34(%ebp)
  800314:	e8 8b 16 00 00       	call   8019a4 <sys_run_env>
  800319:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 c8             	pushl  -0x38(%ebp)
  800322:	e8 7d 16 00 00       	call   8019a4 <sys_run_env>
  800327:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  80032a:	90                   	nop
  80032b:	e8 1c 18 00 00       	call   801b4c <gettst>
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
  800349:	68 e8 20 80 00       	push   $0x8020e8
  80034e:	e8 f4 04 00 00       	call   800847 <cprintf>
  800353:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80035a:	74 04                	je     800360 <_main+0x328>
  80035c:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800360:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	atomic_cprintf("%@Now, attempting to write a ReadOnly variable\n\n\n");
  800367:	83 ec 0c             	sub    $0xc,%esp
  80036a:	68 34 21 80 00       	push   $0x802134
  80036f:	e8 00 05 00 00       	call   800874 <atomic_cprintf>
  800374:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800377:	a1 04 30 80 00       	mov    0x803004,%eax
  80037c:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  800382:	a1 04 30 80 00       	mov    0x803004,%eax
  800387:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  80038d:	89 c1                	mov    %eax,%ecx
  80038f:	a1 04 30 80 00       	mov    0x803004,%eax
  800394:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80039a:	52                   	push   %edx
  80039b:	51                   	push   %ecx
  80039c:	50                   	push   %eax
  80039d:	68 66 21 80 00       	push   $0x802166
  8003a2:	e8 df 15 00 00       	call   801986 <sys_create_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b3:	e8 ec 15 00 00       	call   8019a4 <sys_run_env>
  8003b8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  8003bb:	90                   	nop
  8003bc:	e8 8b 17 00 00       	call   801b4c <gettst>
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
  8003da:	68 e8 20 80 00       	push   $0x8020e8
  8003df:	e8 63 04 00 00       	call   800847 <cprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8003e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003eb:	74 04                	je     8003f1 <_main+0x3b9>
  8003ed:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8003f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Signal slave2
	inctst();
  8003f8:	e8 35 17 00 00       	call   801b32 <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8003fd:	90                   	nop
  8003fe:	e8 49 17 00 00       	call   801b4c <gettst>
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
  80041c:	68 e8 20 80 00       	push   $0x8020e8
  800421:	e8 21 04 00 00       	call   800847 <cprintf>
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
  800440:	68 74 21 80 00       	push   $0x802174
  800445:	e8 fd 03 00 00       	call   800847 <cprintf>
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
  800459:	e8 96 15 00 00       	call   8019f4 <sys_getenvindex>
  80045e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800464:	89 d0                	mov    %edx,%eax
  800466:	c1 e0 02             	shl    $0x2,%eax
  800469:	01 d0                	add    %edx,%eax
  80046b:	01 c0                	add    %eax,%eax
  80046d:	01 d0                	add    %edx,%eax
  80046f:	c1 e0 02             	shl    $0x2,%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	01 c0                	add    %eax,%eax
  800476:	01 d0                	add    %edx,%eax
  800478:	c1 e0 04             	shl    $0x4,%eax
  80047b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800480:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800485:	a1 04 30 80 00       	mov    0x803004,%eax
  80048a:	8a 40 20             	mov    0x20(%eax),%al
  80048d:	84 c0                	test   %al,%al
  80048f:	74 0d                	je     80049e <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800491:	a1 04 30 80 00       	mov    0x803004,%eax
  800496:	83 c0 20             	add    $0x20,%eax
  800499:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80049e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004a2:	7e 0a                	jle    8004ae <libmain+0x5b>
		binaryname = argv[0];
  8004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	ff 75 0c             	pushl  0xc(%ebp)
  8004b4:	ff 75 08             	pushl  0x8(%ebp)
  8004b7:	e8 7c fb ff ff       	call   800038 <_main>
  8004bc:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8004bf:	e8 b4 12 00 00       	call   801778 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004c4:	83 ec 0c             	sub    $0xc,%esp
  8004c7:	68 d0 21 80 00       	push   $0x8021d0
  8004cc:	e8 76 03 00 00       	call   800847 <cprintf>
  8004d1:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004d4:	a1 04 30 80 00       	mov    0x803004,%eax
  8004d9:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8004df:	a1 04 30 80 00       	mov    0x803004,%eax
  8004e4:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8004ea:	83 ec 04             	sub    $0x4,%esp
  8004ed:	52                   	push   %edx
  8004ee:	50                   	push   %eax
  8004ef:	68 f8 21 80 00       	push   $0x8021f8
  8004f4:	e8 4e 03 00 00       	call   800847 <cprintf>
  8004f9:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004fc:	a1 04 30 80 00       	mov    0x803004,%eax
  800501:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800507:	a1 04 30 80 00       	mov    0x803004,%eax
  80050c:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800512:	a1 04 30 80 00       	mov    0x803004,%eax
  800517:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80051d:	51                   	push   %ecx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	68 20 22 80 00       	push   $0x802220
  800525:	e8 1d 03 00 00       	call   800847 <cprintf>
  80052a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80052d:	a1 04 30 80 00       	mov    0x803004,%eax
  800532:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800538:	83 ec 08             	sub    $0x8,%esp
  80053b:	50                   	push   %eax
  80053c:	68 78 22 80 00       	push   $0x802278
  800541:	e8 01 03 00 00       	call   800847 <cprintf>
  800546:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	68 d0 21 80 00       	push   $0x8021d0
  800551:	e8 f1 02 00 00       	call   800847 <cprintf>
  800556:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800559:	e8 34 12 00 00       	call   801792 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80055e:	e8 19 00 00 00       	call   80057c <exit>
}
  800563:	90                   	nop
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80056c:	83 ec 0c             	sub    $0xc,%esp
  80056f:	6a 00                	push   $0x0
  800571:	e8 4a 14 00 00       	call   8019c0 <sys_destroy_env>
  800576:	83 c4 10             	add    $0x10,%esp
}
  800579:	90                   	nop
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <exit>:

void
exit(void)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800582:	e8 9f 14 00 00       	call   801a26 <sys_exit_env>
}
  800587:	90                   	nop
  800588:	c9                   	leave  
  800589:	c3                   	ret    

0080058a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80058a:	55                   	push   %ebp
  80058b:	89 e5                	mov    %esp,%ebp
  80058d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800590:	8d 45 10             	lea    0x10(%ebp),%eax
  800593:	83 c0 04             	add    $0x4,%eax
  800596:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800599:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80059e:	85 c0                	test   %eax,%eax
  8005a0:	74 16                	je     8005b8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005a2:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	50                   	push   %eax
  8005ab:	68 8c 22 80 00       	push   $0x80228c
  8005b0:	e8 92 02 00 00       	call   800847 <cprintf>
  8005b5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005b8:	a1 00 30 80 00       	mov    0x803000,%eax
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	50                   	push   %eax
  8005c4:	68 91 22 80 00       	push   $0x802291
  8005c9:	e8 79 02 00 00       	call   800847 <cprintf>
  8005ce:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005da:	50                   	push   %eax
  8005db:	e8 fc 01 00 00       	call   8007dc <vcprintf>
  8005e0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005e3:	83 ec 08             	sub    $0x8,%esp
  8005e6:	6a 00                	push   $0x0
  8005e8:	68 ad 22 80 00       	push   $0x8022ad
  8005ed:	e8 ea 01 00 00       	call   8007dc <vcprintf>
  8005f2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005f5:	e8 82 ff ff ff       	call   80057c <exit>

	// should not return here
	while (1) ;
  8005fa:	eb fe                	jmp    8005fa <_panic+0x70>

008005fc <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005fc:	55                   	push   %ebp
  8005fd:	89 e5                	mov    %esp,%ebp
  8005ff:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800602:	a1 04 30 80 00       	mov    0x803004,%eax
  800607:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80060d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800610:	39 c2                	cmp    %eax,%edx
  800612:	74 14                	je     800628 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	68 b0 22 80 00       	push   $0x8022b0
  80061c:	6a 26                	push   $0x26
  80061e:	68 fc 22 80 00       	push   $0x8022fc
  800623:	e8 62 ff ff ff       	call   80058a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800628:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80062f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800636:	e9 c5 00 00 00       	jmp    800700 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80063b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	85 c0                	test   %eax,%eax
  80064e:	75 08                	jne    800658 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800650:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800653:	e9 a5 00 00 00       	jmp    8006fd <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800658:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80065f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800666:	eb 69                	jmp    8006d1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800668:	a1 04 30 80 00       	mov    0x803004,%eax
  80066d:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800673:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800676:	89 d0                	mov    %edx,%eax
  800678:	01 c0                	add    %eax,%eax
  80067a:	01 d0                	add    %edx,%eax
  80067c:	c1 e0 03             	shl    $0x3,%eax
  80067f:	01 c8                	add    %ecx,%eax
  800681:	8a 40 04             	mov    0x4(%eax),%al
  800684:	84 c0                	test   %al,%al
  800686:	75 46                	jne    8006ce <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800688:	a1 04 30 80 00       	mov    0x803004,%eax
  80068d:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800693:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800696:	89 d0                	mov    %edx,%eax
  800698:	01 c0                	add    %eax,%eax
  80069a:	01 d0                	add    %edx,%eax
  80069c:	c1 e0 03             	shl    $0x3,%eax
  80069f:	01 c8                	add    %ecx,%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006ae:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	01 c8                	add    %ecx,%eax
  8006bf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	75 09                	jne    8006ce <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006c5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006cc:	eb 15                	jmp    8006e3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006ce:	ff 45 e8             	incl   -0x18(%ebp)
  8006d1:	a1 04 30 80 00       	mov    0x803004,%eax
  8006d6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006df:	39 c2                	cmp    %eax,%edx
  8006e1:	77 85                	ja     800668 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006e7:	75 14                	jne    8006fd <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	68 08 23 80 00       	push   $0x802308
  8006f1:	6a 3a                	push   $0x3a
  8006f3:	68 fc 22 80 00       	push   $0x8022fc
  8006f8:	e8 8d fe ff ff       	call   80058a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006fd:	ff 45 f0             	incl   -0x10(%ebp)
  800700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800703:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800706:	0f 8c 2f ff ff ff    	jl     80063b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80070c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800713:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80071a:	eb 26                	jmp    800742 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80071c:	a1 04 30 80 00       	mov    0x803004,%eax
  800721:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800727:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80072a:	89 d0                	mov    %edx,%eax
  80072c:	01 c0                	add    %eax,%eax
  80072e:	01 d0                	add    %edx,%eax
  800730:	c1 e0 03             	shl    $0x3,%eax
  800733:	01 c8                	add    %ecx,%eax
  800735:	8a 40 04             	mov    0x4(%eax),%al
  800738:	3c 01                	cmp    $0x1,%al
  80073a:	75 03                	jne    80073f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80073c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80073f:	ff 45 e0             	incl   -0x20(%ebp)
  800742:	a1 04 30 80 00       	mov    0x803004,%eax
  800747:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80074d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800750:	39 c2                	cmp    %eax,%edx
  800752:	77 c8                	ja     80071c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800757:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80075a:	74 14                	je     800770 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80075c:	83 ec 04             	sub    $0x4,%esp
  80075f:	68 5c 23 80 00       	push   $0x80235c
  800764:	6a 44                	push   $0x44
  800766:	68 fc 22 80 00       	push   $0x8022fc
  80076b:	e8 1a fe ff ff       	call   80058a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800770:	90                   	nop
  800771:	c9                   	leave  
  800772:	c3                   	ret    

00800773 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800773:	55                   	push   %ebp
  800774:	89 e5                	mov    %esp,%ebp
  800776:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	8d 48 01             	lea    0x1(%eax),%ecx
  800781:	8b 55 0c             	mov    0xc(%ebp),%edx
  800784:	89 0a                	mov    %ecx,(%edx)
  800786:	8b 55 08             	mov    0x8(%ebp),%edx
  800789:	88 d1                	mov    %dl,%cl
  80078b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80078e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800792:	8b 45 0c             	mov    0xc(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	3d ff 00 00 00       	cmp    $0xff,%eax
  80079c:	75 2c                	jne    8007ca <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80079e:	a0 08 30 80 00       	mov    0x803008,%al
  8007a3:	0f b6 c0             	movzbl %al,%eax
  8007a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a9:	8b 12                	mov    (%edx),%edx
  8007ab:	89 d1                	mov    %edx,%ecx
  8007ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b0:	83 c2 08             	add    $0x8,%edx
  8007b3:	83 ec 04             	sub    $0x4,%esp
  8007b6:	50                   	push   %eax
  8007b7:	51                   	push   %ecx
  8007b8:	52                   	push   %edx
  8007b9:	e8 78 0f 00 00       	call   801736 <sys_cputs>
  8007be:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cd:	8b 40 04             	mov    0x4(%eax),%eax
  8007d0:	8d 50 01             	lea    0x1(%eax),%edx
  8007d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007d9:	90                   	nop
  8007da:	c9                   	leave  
  8007db:	c3                   	ret    

008007dc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007e5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007ec:	00 00 00 
	b.cnt = 0;
  8007ef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007f6:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	ff 75 08             	pushl  0x8(%ebp)
  8007ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800805:	50                   	push   %eax
  800806:	68 73 07 80 00       	push   $0x800773
  80080b:	e8 11 02 00 00       	call   800a21 <vprintfmt>
  800810:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800813:	a0 08 30 80 00       	mov    0x803008,%al
  800818:	0f b6 c0             	movzbl %al,%eax
  80081b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800821:	83 ec 04             	sub    $0x4,%esp
  800824:	50                   	push   %eax
  800825:	52                   	push   %edx
  800826:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80082c:	83 c0 08             	add    $0x8,%eax
  80082f:	50                   	push   %eax
  800830:	e8 01 0f 00 00       	call   801736 <sys_cputs>
  800835:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800838:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80083f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800845:	c9                   	leave  
  800846:	c3                   	ret    

00800847 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80084d:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800854:	8d 45 0c             	lea    0xc(%ebp),%eax
  800857:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 f4             	pushl  -0xc(%ebp)
  800863:	50                   	push   %eax
  800864:	e8 73 ff ff ff       	call   8007dc <vcprintf>
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80086f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800872:	c9                   	leave  
  800873:	c3                   	ret    

00800874 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80087a:	e8 f9 0e 00 00       	call   801778 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80087f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800882:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	ff 75 f4             	pushl  -0xc(%ebp)
  80088e:	50                   	push   %eax
  80088f:	e8 48 ff ff ff       	call   8007dc <vcprintf>
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80089a:	e8 f3 0e 00 00       	call   801792 <sys_unlock_cons>
	return cnt;
  80089f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    

008008a4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	53                   	push   %ebx
  8008a8:	83 ec 14             	sub    $0x14,%esp
  8008ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008b7:	8b 45 18             	mov    0x18(%ebp),%eax
  8008ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008c2:	77 55                	ja     800919 <printnum+0x75>
  8008c4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008c7:	72 05                	jb     8008ce <printnum+0x2a>
  8008c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008cc:	77 4b                	ja     800919 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008ce:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008d1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008d4:	8b 45 18             	mov    0x18(%ebp),%eax
  8008d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dc:	52                   	push   %edx
  8008dd:	50                   	push   %eax
  8008de:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e4:	e8 4b 14 00 00       	call   801d34 <__udivdi3>
  8008e9:	83 c4 10             	add    $0x10,%esp
  8008ec:	83 ec 04             	sub    $0x4,%esp
  8008ef:	ff 75 20             	pushl  0x20(%ebp)
  8008f2:	53                   	push   %ebx
  8008f3:	ff 75 18             	pushl  0x18(%ebp)
  8008f6:	52                   	push   %edx
  8008f7:	50                   	push   %eax
  8008f8:	ff 75 0c             	pushl  0xc(%ebp)
  8008fb:	ff 75 08             	pushl  0x8(%ebp)
  8008fe:	e8 a1 ff ff ff       	call   8008a4 <printnum>
  800903:	83 c4 20             	add    $0x20,%esp
  800906:	eb 1a                	jmp    800922 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	ff 75 20             	pushl  0x20(%ebp)
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	ff d0                	call   *%eax
  800916:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800919:	ff 4d 1c             	decl   0x1c(%ebp)
  80091c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800920:	7f e6                	jg     800908 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800922:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800925:	bb 00 00 00 00       	mov    $0x0,%ebx
  80092a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800930:	53                   	push   %ebx
  800931:	51                   	push   %ecx
  800932:	52                   	push   %edx
  800933:	50                   	push   %eax
  800934:	e8 0b 15 00 00       	call   801e44 <__umoddi3>
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	05 d4 25 80 00       	add    $0x8025d4,%eax
  800941:	8a 00                	mov    (%eax),%al
  800943:	0f be c0             	movsbl %al,%eax
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	50                   	push   %eax
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
}
  800955:	90                   	nop
  800956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800959:	c9                   	leave  
  80095a:	c3                   	ret    

0080095b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80095e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800962:	7e 1c                	jle    800980 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	8b 00                	mov    (%eax),%eax
  800969:	8d 50 08             	lea    0x8(%eax),%edx
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	89 10                	mov    %edx,(%eax)
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	83 e8 08             	sub    $0x8,%eax
  800979:	8b 50 04             	mov    0x4(%eax),%edx
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	eb 40                	jmp    8009c0 <getuint+0x65>
	else if (lflag)
  800980:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800984:	74 1e                	je     8009a4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	8d 50 04             	lea    0x4(%eax),%edx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	89 10                	mov    %edx,(%eax)
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	83 e8 04             	sub    $0x4,%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a2:	eb 1c                	jmp    8009c0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	8d 50 04             	lea    0x4(%eax),%edx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	89 10                	mov    %edx,(%eax)
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009c5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009c9:	7e 1c                	jle    8009e7 <getint+0x25>
		return va_arg(*ap, long long);
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	8d 50 08             	lea    0x8(%eax),%edx
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	89 10                	mov    %edx,(%eax)
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	83 e8 08             	sub    $0x8,%eax
  8009e0:	8b 50 04             	mov    0x4(%eax),%edx
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	eb 38                	jmp    800a1f <getint+0x5d>
	else if (lflag)
  8009e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009eb:	74 1a                	je     800a07 <getint+0x45>
		return va_arg(*ap, long);
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	8d 50 04             	lea    0x4(%eax),%edx
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	89 10                	mov    %edx,(%eax)
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8b 00                	mov    (%eax),%eax
  8009ff:	83 e8 04             	sub    $0x4,%eax
  800a02:	8b 00                	mov    (%eax),%eax
  800a04:	99                   	cltd   
  800a05:	eb 18                	jmp    800a1f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 00                	mov    (%eax),%eax
  800a0c:	8d 50 04             	lea    0x4(%eax),%edx
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	89 10                	mov    %edx,(%eax)
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8b 00                	mov    (%eax),%eax
  800a19:	83 e8 04             	sub    $0x4,%eax
  800a1c:	8b 00                	mov    (%eax),%eax
  800a1e:	99                   	cltd   
}
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	56                   	push   %esi
  800a25:	53                   	push   %ebx
  800a26:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a29:	eb 17                	jmp    800a42 <vprintfmt+0x21>
			if (ch == '\0')
  800a2b:	85 db                	test   %ebx,%ebx
  800a2d:	0f 84 c1 03 00 00    	je     800df4 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	53                   	push   %ebx
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	ff d0                	call   *%eax
  800a3f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a42:	8b 45 10             	mov    0x10(%ebp),%eax
  800a45:	8d 50 01             	lea    0x1(%eax),%edx
  800a48:	89 55 10             	mov    %edx,0x10(%ebp)
  800a4b:	8a 00                	mov    (%eax),%al
  800a4d:	0f b6 d8             	movzbl %al,%ebx
  800a50:	83 fb 25             	cmp    $0x25,%ebx
  800a53:	75 d6                	jne    800a2b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a55:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a59:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a60:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a67:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a6e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a75:	8b 45 10             	mov    0x10(%ebp),%eax
  800a78:	8d 50 01             	lea    0x1(%eax),%edx
  800a7b:	89 55 10             	mov    %edx,0x10(%ebp)
  800a7e:	8a 00                	mov    (%eax),%al
  800a80:	0f b6 d8             	movzbl %al,%ebx
  800a83:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a86:	83 f8 5b             	cmp    $0x5b,%eax
  800a89:	0f 87 3d 03 00 00    	ja     800dcc <vprintfmt+0x3ab>
  800a8f:	8b 04 85 f8 25 80 00 	mov    0x8025f8(,%eax,4),%eax
  800a96:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a98:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a9c:	eb d7                	jmp    800a75 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a9e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800aa2:	eb d1                	jmp    800a75 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aa4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800aab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aae:	89 d0                	mov    %edx,%eax
  800ab0:	c1 e0 02             	shl    $0x2,%eax
  800ab3:	01 d0                	add    %edx,%eax
  800ab5:	01 c0                	add    %eax,%eax
  800ab7:	01 d8                	add    %ebx,%eax
  800ab9:	83 e8 30             	sub    $0x30,%eax
  800abc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800abf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ac7:	83 fb 2f             	cmp    $0x2f,%ebx
  800aca:	7e 3e                	jle    800b0a <vprintfmt+0xe9>
  800acc:	83 fb 39             	cmp    $0x39,%ebx
  800acf:	7f 39                	jg     800b0a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ad4:	eb d5                	jmp    800aab <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	83 c0 04             	add    $0x4,%eax
  800adc:	89 45 14             	mov    %eax,0x14(%ebp)
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	83 e8 04             	sub    $0x4,%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aea:	eb 1f                	jmp    800b0b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af0:	79 83                	jns    800a75 <vprintfmt+0x54>
				width = 0;
  800af2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800af9:	e9 77 ff ff ff       	jmp    800a75 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800afe:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b05:	e9 6b ff ff ff       	jmp    800a75 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b0a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0f:	0f 89 60 ff ff ff    	jns    800a75 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b1b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b22:	e9 4e ff ff ff       	jmp    800a75 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b27:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b2a:	e9 46 ff ff ff       	jmp    800a75 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	83 c0 04             	add    $0x4,%eax
  800b35:	89 45 14             	mov    %eax,0x14(%ebp)
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	83 e8 04             	sub    $0x4,%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	50                   	push   %eax
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	ff d0                	call   *%eax
  800b4c:	83 c4 10             	add    $0x10,%esp
			break;
  800b4f:	e9 9b 02 00 00       	jmp    800def <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 c0 04             	add    $0x4,%eax
  800b5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b60:	83 e8 04             	sub    $0x4,%eax
  800b63:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b65:	85 db                	test   %ebx,%ebx
  800b67:	79 02                	jns    800b6b <vprintfmt+0x14a>
				err = -err;
  800b69:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b6b:	83 fb 64             	cmp    $0x64,%ebx
  800b6e:	7f 0b                	jg     800b7b <vprintfmt+0x15a>
  800b70:	8b 34 9d 40 24 80 00 	mov    0x802440(,%ebx,4),%esi
  800b77:	85 f6                	test   %esi,%esi
  800b79:	75 19                	jne    800b94 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b7b:	53                   	push   %ebx
  800b7c:	68 e5 25 80 00       	push   $0x8025e5
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	ff 75 08             	pushl  0x8(%ebp)
  800b87:	e8 70 02 00 00       	call   800dfc <printfmt>
  800b8c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b8f:	e9 5b 02 00 00       	jmp    800def <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b94:	56                   	push   %esi
  800b95:	68 ee 25 80 00       	push   $0x8025ee
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	ff 75 08             	pushl  0x8(%ebp)
  800ba0:	e8 57 02 00 00       	call   800dfc <printfmt>
  800ba5:	83 c4 10             	add    $0x10,%esp
			break;
  800ba8:	e9 42 02 00 00       	jmp    800def <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bad:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb0:	83 c0 04             	add    $0x4,%eax
  800bb3:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	83 e8 04             	sub    $0x4,%eax
  800bbc:	8b 30                	mov    (%eax),%esi
  800bbe:	85 f6                	test   %esi,%esi
  800bc0:	75 05                	jne    800bc7 <vprintfmt+0x1a6>
				p = "(null)";
  800bc2:	be f1 25 80 00       	mov    $0x8025f1,%esi
			if (width > 0 && padc != '-')
  800bc7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcb:	7e 6d                	jle    800c3a <vprintfmt+0x219>
  800bcd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bd1:	74 67                	je     800c3a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	50                   	push   %eax
  800bda:	56                   	push   %esi
  800bdb:	e8 1e 03 00 00       	call   800efe <strnlen>
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800be6:	eb 16                	jmp    800bfe <vprintfmt+0x1dd>
					putch(padc, putdat);
  800be8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bec:	83 ec 08             	sub    $0x8,%esp
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	50                   	push   %eax
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	ff d0                	call   *%eax
  800bf8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bfb:	ff 4d e4             	decl   -0x1c(%ebp)
  800bfe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c02:	7f e4                	jg     800be8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c04:	eb 34                	jmp    800c3a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c06:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c0a:	74 1c                	je     800c28 <vprintfmt+0x207>
  800c0c:	83 fb 1f             	cmp    $0x1f,%ebx
  800c0f:	7e 05                	jle    800c16 <vprintfmt+0x1f5>
  800c11:	83 fb 7e             	cmp    $0x7e,%ebx
  800c14:	7e 12                	jle    800c28 <vprintfmt+0x207>
					putch('?', putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	6a 3f                	push   $0x3f
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	ff d0                	call   *%eax
  800c23:	83 c4 10             	add    $0x10,%esp
  800c26:	eb 0f                	jmp    800c37 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c28:	83 ec 08             	sub    $0x8,%esp
  800c2b:	ff 75 0c             	pushl  0xc(%ebp)
  800c2e:	53                   	push   %ebx
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c37:	ff 4d e4             	decl   -0x1c(%ebp)
  800c3a:	89 f0                	mov    %esi,%eax
  800c3c:	8d 70 01             	lea    0x1(%eax),%esi
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	0f be d8             	movsbl %al,%ebx
  800c44:	85 db                	test   %ebx,%ebx
  800c46:	74 24                	je     800c6c <vprintfmt+0x24b>
  800c48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c4c:	78 b8                	js     800c06 <vprintfmt+0x1e5>
  800c4e:	ff 4d e0             	decl   -0x20(%ebp)
  800c51:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c55:	79 af                	jns    800c06 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c57:	eb 13                	jmp    800c6c <vprintfmt+0x24b>
				putch(' ', putdat);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	6a 20                	push   $0x20
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	ff d0                	call   *%eax
  800c66:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c69:	ff 4d e4             	decl   -0x1c(%ebp)
  800c6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c70:	7f e7                	jg     800c59 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c72:	e9 78 01 00 00       	jmp    800def <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c77:	83 ec 08             	sub    $0x8,%esp
  800c7a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c80:	50                   	push   %eax
  800c81:	e8 3c fd ff ff       	call   8009c2 <getint>
  800c86:	83 c4 10             	add    $0x10,%esp
  800c89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c95:	85 d2                	test   %edx,%edx
  800c97:	79 23                	jns    800cbc <vprintfmt+0x29b>
				putch('-', putdat);
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	ff 75 0c             	pushl  0xc(%ebp)
  800c9f:	6a 2d                	push   $0x2d
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	ff d0                	call   *%eax
  800ca6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800caf:	f7 d8                	neg    %eax
  800cb1:	83 d2 00             	adc    $0x0,%edx
  800cb4:	f7 da                	neg    %edx
  800cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cbc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cc3:	e9 bc 00 00 00       	jmp    800d84 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cc8:	83 ec 08             	sub    $0x8,%esp
  800ccb:	ff 75 e8             	pushl  -0x18(%ebp)
  800cce:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd1:	50                   	push   %eax
  800cd2:	e8 84 fc ff ff       	call   80095b <getuint>
  800cd7:	83 c4 10             	add    $0x10,%esp
  800cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cdd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ce0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ce7:	e9 98 00 00 00       	jmp    800d84 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	6a 58                	push   $0x58
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	ff d0                	call   *%eax
  800cf9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cfc:	83 ec 08             	sub    $0x8,%esp
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	6a 58                	push   $0x58
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	ff d0                	call   *%eax
  800d09:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	6a 58                	push   $0x58
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	ff d0                	call   *%eax
  800d19:	83 c4 10             	add    $0x10,%esp
			break;
  800d1c:	e9 ce 00 00 00       	jmp    800def <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d21:	83 ec 08             	sub    $0x8,%esp
  800d24:	ff 75 0c             	pushl  0xc(%ebp)
  800d27:	6a 30                	push   $0x30
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	ff d0                	call   *%eax
  800d2e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d31:	83 ec 08             	sub    $0x8,%esp
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	6a 78                	push   $0x78
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	ff d0                	call   *%eax
  800d3e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 c0 04             	add    $0x4,%eax
  800d47:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4d:	83 e8 04             	sub    $0x4,%eax
  800d50:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d5c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d63:	eb 1f                	jmp    800d84 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d65:	83 ec 08             	sub    $0x8,%esp
  800d68:	ff 75 e8             	pushl  -0x18(%ebp)
  800d6b:	8d 45 14             	lea    0x14(%ebp),%eax
  800d6e:	50                   	push   %eax
  800d6f:	e8 e7 fb ff ff       	call   80095b <getuint>
  800d74:	83 c4 10             	add    $0x10,%esp
  800d77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d7d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d84:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8b:	83 ec 04             	sub    $0x4,%esp
  800d8e:	52                   	push   %edx
  800d8f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d92:	50                   	push   %eax
  800d93:	ff 75 f4             	pushl  -0xc(%ebp)
  800d96:	ff 75 f0             	pushl  -0x10(%ebp)
  800d99:	ff 75 0c             	pushl  0xc(%ebp)
  800d9c:	ff 75 08             	pushl  0x8(%ebp)
  800d9f:	e8 00 fb ff ff       	call   8008a4 <printnum>
  800da4:	83 c4 20             	add    $0x20,%esp
			break;
  800da7:	eb 46                	jmp    800def <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	ff 75 0c             	pushl  0xc(%ebp)
  800daf:	53                   	push   %ebx
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	ff d0                	call   *%eax
  800db5:	83 c4 10             	add    $0x10,%esp
			break;
  800db8:	eb 35                	jmp    800def <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800dba:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800dc1:	eb 2c                	jmp    800def <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800dc3:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800dca:	eb 23                	jmp    800def <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dcc:	83 ec 08             	sub    $0x8,%esp
  800dcf:	ff 75 0c             	pushl  0xc(%ebp)
  800dd2:	6a 25                	push   $0x25
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	ff d0                	call   *%eax
  800dd9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ddc:	ff 4d 10             	decl   0x10(%ebp)
  800ddf:	eb 03                	jmp    800de4 <vprintfmt+0x3c3>
  800de1:	ff 4d 10             	decl   0x10(%ebp)
  800de4:	8b 45 10             	mov    0x10(%ebp),%eax
  800de7:	48                   	dec    %eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	3c 25                	cmp    $0x25,%al
  800dec:	75 f3                	jne    800de1 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800dee:	90                   	nop
		}
	}
  800def:	e9 35 fc ff ff       	jmp    800a29 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800df4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800df5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e02:	8d 45 10             	lea    0x10(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e11:	50                   	push   %eax
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 04 fc ff ff       	call   800a21 <vprintfmt>
  800e1d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e20:	90                   	nop
  800e21:	c9                   	leave  
  800e22:	c3                   	ret    

00800e23 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	8b 40 08             	mov    0x8(%eax),%eax
  800e2c:	8d 50 01             	lea    0x1(%eax),%edx
  800e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e32:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e38:	8b 10                	mov    (%eax),%edx
  800e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3d:	8b 40 04             	mov    0x4(%eax),%eax
  800e40:	39 c2                	cmp    %eax,%edx
  800e42:	73 12                	jae    800e56 <sprintputch+0x33>
		*b->buf++ = ch;
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8b 00                	mov    (%eax),%eax
  800e49:	8d 48 01             	lea    0x1(%eax),%ecx
  800e4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4f:	89 0a                	mov    %ecx,(%edx)
  800e51:	8b 55 08             	mov    0x8(%ebp),%edx
  800e54:	88 10                	mov    %dl,(%eax)
}
  800e56:	90                   	nop
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	01 d0                	add    %edx,%eax
  800e70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e7e:	74 06                	je     800e86 <vsnprintf+0x2d>
  800e80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e84:	7f 07                	jg     800e8d <vsnprintf+0x34>
		return -E_INVAL;
  800e86:	b8 03 00 00 00       	mov    $0x3,%eax
  800e8b:	eb 20                	jmp    800ead <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e8d:	ff 75 14             	pushl  0x14(%ebp)
  800e90:	ff 75 10             	pushl  0x10(%ebp)
  800e93:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e96:	50                   	push   %eax
  800e97:	68 23 0e 80 00       	push   $0x800e23
  800e9c:	e8 80 fb ff ff       	call   800a21 <vprintfmt>
  800ea1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ea4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ea7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800eb5:	8d 45 10             	lea    0x10(%ebp),%eax
  800eb8:	83 c0 04             	add    $0x4,%eax
  800ebb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ec4:	50                   	push   %eax
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	ff 75 08             	pushl  0x8(%ebp)
  800ecb:	e8 89 ff ff ff       	call   800e59 <vsnprintf>
  800ed0:	83 c4 10             	add    $0x10,%esp
  800ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ee1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee8:	eb 06                	jmp    800ef0 <strlen+0x15>
		n++;
  800eea:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800eed:	ff 45 08             	incl   0x8(%ebp)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	84 c0                	test   %al,%al
  800ef7:	75 f1                	jne    800eea <strlen+0xf>
		n++;
	return n;
  800ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f0b:	eb 09                	jmp    800f16 <strnlen+0x18>
		n++;
  800f0d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f10:	ff 45 08             	incl   0x8(%ebp)
  800f13:	ff 4d 0c             	decl   0xc(%ebp)
  800f16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f1a:	74 09                	je     800f25 <strnlen+0x27>
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	84 c0                	test   %al,%al
  800f23:	75 e8                	jne    800f0d <strnlen+0xf>
		n++;
	return n;
  800f25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f28:	c9                   	leave  
  800f29:	c3                   	ret    

00800f2a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f36:	90                   	nop
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f46:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f49:	8a 12                	mov    (%edx),%dl
  800f4b:	88 10                	mov    %dl,(%eax)
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	84 c0                	test   %al,%al
  800f51:	75 e4                	jne    800f37 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f53:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f6b:	eb 1f                	jmp    800f8c <strncpy+0x34>
		*dst++ = *src;
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8d 50 01             	lea    0x1(%eax),%edx
  800f73:	89 55 08             	mov    %edx,0x8(%ebp)
  800f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f79:	8a 12                	mov    (%edx),%dl
  800f7b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	84 c0                	test   %al,%al
  800f84:	74 03                	je     800f89 <strncpy+0x31>
			src++;
  800f86:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f89:	ff 45 fc             	incl   -0x4(%ebp)
  800f8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f92:	72 d9                	jb     800f6d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f94:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fa5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa9:	74 30                	je     800fdb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fab:	eb 16                	jmp    800fc3 <strlcpy+0x2a>
			*dst++ = *src++;
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8d 50 01             	lea    0x1(%eax),%edx
  800fb3:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fbc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fbf:	8a 12                	mov    (%edx),%dl
  800fc1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fc3:	ff 4d 10             	decl   0x10(%ebp)
  800fc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fca:	74 09                	je     800fd5 <strlcpy+0x3c>
  800fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	84 c0                	test   %al,%al
  800fd3:	75 d8                	jne    800fad <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe1:	29 c2                	sub    %eax,%edx
  800fe3:	89 d0                	mov    %edx,%eax
}
  800fe5:	c9                   	leave  
  800fe6:	c3                   	ret    

00800fe7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fea:	eb 06                	jmp    800ff2 <strcmp+0xb>
		p++, q++;
  800fec:	ff 45 08             	incl   0x8(%ebp)
  800fef:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	84 c0                	test   %al,%al
  800ff9:	74 0e                	je     801009 <strcmp+0x22>
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 10                	mov    (%eax),%dl
  801000:	8b 45 0c             	mov    0xc(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	38 c2                	cmp    %al,%dl
  801007:	74 e3                	je     800fec <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	0f b6 d0             	movzbl %al,%edx
  801011:	8b 45 0c             	mov    0xc(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	0f b6 c0             	movzbl %al,%eax
  801019:	29 c2                	sub    %eax,%edx
  80101b:	89 d0                	mov    %edx,%eax
}
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    

0080101f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801022:	eb 09                	jmp    80102d <strncmp+0xe>
		n--, p++, q++;
  801024:	ff 4d 10             	decl   0x10(%ebp)
  801027:	ff 45 08             	incl   0x8(%ebp)
  80102a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80102d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801031:	74 17                	je     80104a <strncmp+0x2b>
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	84 c0                	test   %al,%al
  80103a:	74 0e                	je     80104a <strncmp+0x2b>
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	8a 10                	mov    (%eax),%dl
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	38 c2                	cmp    %al,%dl
  801048:	74 da                	je     801024 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80104a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104e:	75 07                	jne    801057 <strncmp+0x38>
		return 0;
  801050:	b8 00 00 00 00       	mov    $0x0,%eax
  801055:	eb 14                	jmp    80106b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8a 00                	mov    (%eax),%al
  80105c:	0f b6 d0             	movzbl %al,%edx
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	0f b6 c0             	movzbl %al,%eax
  801067:	29 c2                	sub    %eax,%edx
  801069:	89 d0                	mov    %edx,%eax
}
  80106b:	5d                   	pop    %ebp
  80106c:	c3                   	ret    

0080106d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 04             	sub    $0x4,%esp
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801079:	eb 12                	jmp    80108d <strchr+0x20>
		if (*s == c)
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801083:	75 05                	jne    80108a <strchr+0x1d>
			return (char *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	eb 11                	jmp    80109b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80108a:	ff 45 08             	incl   0x8(%ebp)
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	84 c0                	test   %al,%al
  801094:	75 e5                	jne    80107b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109b:	c9                   	leave  
  80109c:	c3                   	ret    

0080109d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	83 ec 04             	sub    $0x4,%esp
  8010a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010a9:	eb 0d                	jmp    8010b8 <strfind+0x1b>
		if (*s == c)
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010b3:	74 0e                	je     8010c3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010b5:	ff 45 08             	incl   0x8(%ebp)
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	84 c0                	test   %al,%al
  8010bf:	75 ea                	jne    8010ab <strfind+0xe>
  8010c1:	eb 01                	jmp    8010c4 <strfind+0x27>
		if (*s == c)
			break;
  8010c3:	90                   	nop
	return (char *) s;
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c7:	c9                   	leave  
  8010c8:	c3                   	ret    

008010c9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010db:	eb 0e                	jmp    8010eb <memset+0x22>
		*p++ = c;
  8010dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e0:	8d 50 01             	lea    0x1(%eax),%edx
  8010e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010eb:	ff 4d f8             	decl   -0x8(%ebp)
  8010ee:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010f2:	79 e9                	jns    8010dd <memset+0x14>
		*p++ = c;

	return v;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801102:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80110b:	eb 16                	jmp    801123 <memcpy+0x2a>
		*d++ = *s++;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801110:	8d 50 01             	lea    0x1(%eax),%edx
  801113:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801116:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801119:	8d 4a 01             	lea    0x1(%edx),%ecx
  80111c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80111f:	8a 12                	mov    (%edx),%dl
  801121:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801123:	8b 45 10             	mov    0x10(%ebp),%eax
  801126:	8d 50 ff             	lea    -0x1(%eax),%edx
  801129:	89 55 10             	mov    %edx,0x10(%ebp)
  80112c:	85 c0                	test   %eax,%eax
  80112e:	75 dd                	jne    80110d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801147:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80114d:	73 50                	jae    80119f <memmove+0x6a>
  80114f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801152:	8b 45 10             	mov    0x10(%ebp),%eax
  801155:	01 d0                	add    %edx,%eax
  801157:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115a:	76 43                	jbe    80119f <memmove+0x6a>
		s += n;
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801162:	8b 45 10             	mov    0x10(%ebp),%eax
  801165:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801168:	eb 10                	jmp    80117a <memmove+0x45>
			*--d = *--s;
  80116a:	ff 4d f8             	decl   -0x8(%ebp)
  80116d:	ff 4d fc             	decl   -0x4(%ebp)
  801170:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801173:	8a 10                	mov    (%eax),%dl
  801175:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801178:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801180:	89 55 10             	mov    %edx,0x10(%ebp)
  801183:	85 c0                	test   %eax,%eax
  801185:	75 e3                	jne    80116a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801187:	eb 23                	jmp    8011ac <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	8d 50 01             	lea    0x1(%eax),%edx
  80118f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801192:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801195:	8d 4a 01             	lea    0x1(%edx),%ecx
  801198:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80119b:	8a 12                	mov    (%edx),%dl
  80119d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80119f:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	75 dd                	jne    801189 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011c3:	eb 2a                	jmp    8011ef <memcmp+0x3e>
		if (*s1 != *s2)
  8011c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c8:	8a 10                	mov    (%eax),%dl
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	38 c2                	cmp    %al,%dl
  8011d1:	74 16                	je     8011e9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	8a 00                	mov    (%eax),%al
  8011d8:	0f b6 d0             	movzbl %al,%edx
  8011db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	0f b6 c0             	movzbl %al,%eax
  8011e3:	29 c2                	sub    %eax,%edx
  8011e5:	89 d0                	mov    %edx,%eax
  8011e7:	eb 18                	jmp    801201 <memcmp+0x50>
		s1++, s2++;
  8011e9:	ff 45 fc             	incl   -0x4(%ebp)
  8011ec:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	75 c9                	jne    8011c5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801209:	8b 55 08             	mov    0x8(%ebp),%edx
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	01 d0                	add    %edx,%eax
  801211:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801214:	eb 15                	jmp    80122b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	0f b6 d0             	movzbl %al,%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	0f b6 c0             	movzbl %al,%eax
  801224:	39 c2                	cmp    %eax,%edx
  801226:	74 0d                	je     801235 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801228:	ff 45 08             	incl   0x8(%ebp)
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801231:	72 e3                	jb     801216 <memfind+0x13>
  801233:	eb 01                	jmp    801236 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801235:	90                   	nop
	return (void *) s;
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801241:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801248:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80124f:	eb 03                	jmp    801254 <strtol+0x19>
		s++;
  801251:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	3c 20                	cmp    $0x20,%al
  80125b:	74 f4                	je     801251 <strtol+0x16>
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	3c 09                	cmp    $0x9,%al
  801264:	74 eb                	je     801251 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	8a 00                	mov    (%eax),%al
  80126b:	3c 2b                	cmp    $0x2b,%al
  80126d:	75 05                	jne    801274 <strtol+0x39>
		s++;
  80126f:	ff 45 08             	incl   0x8(%ebp)
  801272:	eb 13                	jmp    801287 <strtol+0x4c>
	else if (*s == '-')
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	3c 2d                	cmp    $0x2d,%al
  80127b:	75 0a                	jne    801287 <strtol+0x4c>
		s++, neg = 1;
  80127d:	ff 45 08             	incl   0x8(%ebp)
  801280:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801287:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128b:	74 06                	je     801293 <strtol+0x58>
  80128d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801291:	75 20                	jne    8012b3 <strtol+0x78>
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	3c 30                	cmp    $0x30,%al
  80129a:	75 17                	jne    8012b3 <strtol+0x78>
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	40                   	inc    %eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 78                	cmp    $0x78,%al
  8012a4:	75 0d                	jne    8012b3 <strtol+0x78>
		s += 2, base = 16;
  8012a6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012aa:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012b1:	eb 28                	jmp    8012db <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b7:	75 15                	jne    8012ce <strtol+0x93>
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	3c 30                	cmp    $0x30,%al
  8012c0:	75 0c                	jne    8012ce <strtol+0x93>
		s++, base = 8;
  8012c2:	ff 45 08             	incl   0x8(%ebp)
  8012c5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012cc:	eb 0d                	jmp    8012db <strtol+0xa0>
	else if (base == 0)
  8012ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d2:	75 07                	jne    8012db <strtol+0xa0>
		base = 10;
  8012d4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	3c 2f                	cmp    $0x2f,%al
  8012e2:	7e 19                	jle    8012fd <strtol+0xc2>
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	3c 39                	cmp    $0x39,%al
  8012eb:	7f 10                	jg     8012fd <strtol+0xc2>
			dig = *s - '0';
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	0f be c0             	movsbl %al,%eax
  8012f5:	83 e8 30             	sub    $0x30,%eax
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012fb:	eb 42                	jmp    80133f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	3c 60                	cmp    $0x60,%al
  801304:	7e 19                	jle    80131f <strtol+0xe4>
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	3c 7a                	cmp    $0x7a,%al
  80130d:	7f 10                	jg     80131f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f be c0             	movsbl %al,%eax
  801317:	83 e8 57             	sub    $0x57,%eax
  80131a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80131d:	eb 20                	jmp    80133f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	3c 40                	cmp    $0x40,%al
  801326:	7e 39                	jle    801361 <strtol+0x126>
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	3c 5a                	cmp    $0x5a,%al
  80132f:	7f 30                	jg     801361 <strtol+0x126>
			dig = *s - 'A' + 10;
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	0f be c0             	movsbl %al,%eax
  801339:	83 e8 37             	sub    $0x37,%eax
  80133c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80133f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801342:	3b 45 10             	cmp    0x10(%ebp),%eax
  801345:	7d 19                	jge    801360 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801347:	ff 45 08             	incl   0x8(%ebp)
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801351:	89 c2                	mov    %eax,%edx
  801353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80135b:	e9 7b ff ff ff       	jmp    8012db <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801360:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801361:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801365:	74 08                	je     80136f <strtol+0x134>
		*endptr = (char *) s;
  801367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136a:	8b 55 08             	mov    0x8(%ebp),%edx
  80136d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80136f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801373:	74 07                	je     80137c <strtol+0x141>
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801378:	f7 d8                	neg    %eax
  80137a:	eb 03                	jmp    80137f <strtol+0x144>
  80137c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <ltostr>:

void
ltostr(long value, char *str)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801387:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80138e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801395:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801399:	79 13                	jns    8013ae <ltostr+0x2d>
	{
		neg = 1;
  80139b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013a8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013ab:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b6:	99                   	cltd   
  8013b7:	f7 f9                	idiv   %ecx
  8013b9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013bf:	8d 50 01             	lea    0x1(%eax),%edx
  8013c2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c5:	89 c2                	mov    %eax,%edx
  8013c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ca:	01 d0                	add    %edx,%eax
  8013cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013cf:	83 c2 30             	add    $0x30,%edx
  8013d2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013dc:	f7 e9                	imul   %ecx
  8013de:	c1 fa 02             	sar    $0x2,%edx
  8013e1:	89 c8                	mov    %ecx,%eax
  8013e3:	c1 f8 1f             	sar    $0x1f,%eax
  8013e6:	29 c2                	sub    %eax,%edx
  8013e8:	89 d0                	mov    %edx,%eax
  8013ea:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f1:	75 bb                	jne    8013ae <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fd:	48                   	dec    %eax
  8013fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801401:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801405:	74 3d                	je     801444 <ltostr+0xc3>
		start = 1 ;
  801407:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80140e:	eb 34                	jmp    801444 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801410:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801413:	8b 45 0c             	mov    0xc(%ebp),%eax
  801416:	01 d0                	add    %edx,%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80141d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	01 c2                	add    %eax,%edx
  801425:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	01 c8                	add    %ecx,%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801431:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	01 c2                	add    %eax,%edx
  801439:	8a 45 eb             	mov    -0x15(%ebp),%al
  80143c:	88 02                	mov    %al,(%edx)
		start++ ;
  80143e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801441:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801447:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144a:	7c c4                	jl     801410 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80144c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80144f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801452:	01 d0                	add    %edx,%eax
  801454:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801457:	90                   	nop
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801460:	ff 75 08             	pushl  0x8(%ebp)
  801463:	e8 73 fa ff ff       	call   800edb <strlen>
  801468:	83 c4 04             	add    $0x4,%esp
  80146b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	e8 65 fa ff ff       	call   800edb <strlen>
  801476:	83 c4 04             	add    $0x4,%esp
  801479:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80147c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80148a:	eb 17                	jmp    8014a3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80148c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148f:	8b 45 10             	mov    0x10(%ebp),%eax
  801492:	01 c2                	add    %eax,%edx
  801494:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	01 c8                	add    %ecx,%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014a0:	ff 45 fc             	incl   -0x4(%ebp)
  8014a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014a9:	7c e1                	jl     80148c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014b9:	eb 1f                	jmp    8014da <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014be:	8d 50 01             	lea    0x1(%eax),%edx
  8014c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c4:	89 c2                	mov    %eax,%edx
  8014c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c9:	01 c2                	add    %eax,%edx
  8014cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	01 c8                	add    %ecx,%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014d7:	ff 45 f8             	incl   -0x8(%ebp)
  8014da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e0:	7c d9                	jl     8014bb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e8:	01 d0                	add    %edx,%eax
  8014ea:	c6 00 00             	movb   $0x0,(%eax)
}
  8014ed:	90                   	nop
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ff:	8b 00                	mov    (%eax),%eax
  801501:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801508:	8b 45 10             	mov    0x10(%ebp),%eax
  80150b:	01 d0                	add    %edx,%eax
  80150d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801513:	eb 0c                	jmp    801521 <strsplit+0x31>
			*string++ = 0;
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8d 50 01             	lea    0x1(%eax),%edx
  80151b:	89 55 08             	mov    %edx,0x8(%ebp)
  80151e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	84 c0                	test   %al,%al
  801528:	74 18                	je     801542 <strsplit+0x52>
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	0f be c0             	movsbl %al,%eax
  801532:	50                   	push   %eax
  801533:	ff 75 0c             	pushl  0xc(%ebp)
  801536:	e8 32 fb ff ff       	call   80106d <strchr>
  80153b:	83 c4 08             	add    $0x8,%esp
  80153e:	85 c0                	test   %eax,%eax
  801540:	75 d3                	jne    801515 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	84 c0                	test   %al,%al
  801549:	74 5a                	je     8015a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80154b:	8b 45 14             	mov    0x14(%ebp),%eax
  80154e:	8b 00                	mov    (%eax),%eax
  801550:	83 f8 0f             	cmp    $0xf,%eax
  801553:	75 07                	jne    80155c <strsplit+0x6c>
		{
			return 0;
  801555:	b8 00 00 00 00       	mov    $0x0,%eax
  80155a:	eb 66                	jmp    8015c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80155c:	8b 45 14             	mov    0x14(%ebp),%eax
  80155f:	8b 00                	mov    (%eax),%eax
  801561:	8d 48 01             	lea    0x1(%eax),%ecx
  801564:	8b 55 14             	mov    0x14(%ebp),%edx
  801567:	89 0a                	mov    %ecx,(%edx)
  801569:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801570:	8b 45 10             	mov    0x10(%ebp),%eax
  801573:	01 c2                	add    %eax,%edx
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157a:	eb 03                	jmp    80157f <strsplit+0x8f>
			string++;
  80157c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	8a 00                	mov    (%eax),%al
  801584:	84 c0                	test   %al,%al
  801586:	74 8b                	je     801513 <strsplit+0x23>
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8a 00                	mov    (%eax),%al
  80158d:	0f be c0             	movsbl %al,%eax
  801590:	50                   	push   %eax
  801591:	ff 75 0c             	pushl  0xc(%ebp)
  801594:	e8 d4 fa ff ff       	call   80106d <strchr>
  801599:	83 c4 08             	add    $0x8,%esp
  80159c:	85 c0                	test   %eax,%eax
  80159e:	74 dc                	je     80157c <strsplit+0x8c>
			string++;
	}
  8015a0:	e9 6e ff ff ff       	jmp    801513 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a9:	8b 00                	mov    (%eax),%eax
  8015ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b5:	01 d0                	add    %edx,%eax
  8015b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8015ca:	83 ec 04             	sub    $0x4,%esp
  8015cd:	68 68 27 80 00       	push   $0x802768
  8015d2:	68 3f 01 00 00       	push   $0x13f
  8015d7:	68 8a 27 80 00       	push   $0x80278a
  8015dc:	e8 a9 ef ff ff       	call   80058a <_panic>

008015e1 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	ff 75 08             	pushl  0x8(%ebp)
  8015ed:	e8 ef 06 00 00       	call   801ce1 <sys_sbrk>
  8015f2:	83 c4 10             	add    $0x10,%esp
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8015fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801601:	75 07                	jne    80160a <malloc+0x13>
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
  801608:	eb 14                	jmp    80161e <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80160a:	83 ec 04             	sub    $0x4,%esp
  80160d:	68 98 27 80 00       	push   $0x802798
  801612:	6a 1b                	push   $0x1b
  801614:	68 bd 27 80 00       	push   $0x8027bd
  801619:	e8 6c ef ff ff       	call   80058a <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801626:	83 ec 04             	sub    $0x4,%esp
  801629:	68 cc 27 80 00       	push   $0x8027cc
  80162e:	6a 29                	push   $0x29
  801630:	68 bd 27 80 00       	push   $0x8027bd
  801635:	e8 50 ef ff ff       	call   80058a <_panic>

0080163a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 18             	sub    $0x18,%esp
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801646:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80164a:	75 07                	jne    801653 <smalloc+0x19>
  80164c:	b8 00 00 00 00       	mov    $0x0,%eax
  801651:	eb 14                	jmp    801667 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	68 f0 27 80 00       	push   $0x8027f0
  80165b:	6a 38                	push   $0x38
  80165d:	68 bd 27 80 00       	push   $0x8027bd
  801662:	e8 23 ef ff ff       	call   80058a <_panic>
	return NULL;
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	68 18 28 80 00       	push   $0x802818
  801677:	6a 43                	push   $0x43
  801679:	68 bd 27 80 00       	push   $0x8027bd
  80167e:	e8 07 ef ff ff       	call   80058a <_panic>

00801683 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801689:	83 ec 04             	sub    $0x4,%esp
  80168c:	68 3c 28 80 00       	push   $0x80283c
  801691:	6a 5b                	push   $0x5b
  801693:	68 bd 27 80 00       	push   $0x8027bd
  801698:	e8 ed ee ff ff       	call   80058a <_panic>

0080169d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	68 60 28 80 00       	push   $0x802860
  8016ab:	6a 72                	push   $0x72
  8016ad:	68 bd 27 80 00       	push   $0x8027bd
  8016b2:	e8 d3 ee ff ff       	call   80058a <_panic>

008016b7 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016bd:	83 ec 04             	sub    $0x4,%esp
  8016c0:	68 86 28 80 00       	push   $0x802886
  8016c5:	6a 7e                	push   $0x7e
  8016c7:	68 bd 27 80 00       	push   $0x8027bd
  8016cc:	e8 b9 ee ff ff       	call   80058a <_panic>

008016d1 <shrink>:

}
void shrink(uint32 newSize)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	68 86 28 80 00       	push   $0x802886
  8016df:	68 83 00 00 00       	push   $0x83
  8016e4:	68 bd 27 80 00       	push   $0x8027bd
  8016e9:	e8 9c ee ff ff       	call   80058a <_panic>

008016ee <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016f4:	83 ec 04             	sub    $0x4,%esp
  8016f7:	68 86 28 80 00       	push   $0x802886
  8016fc:	68 88 00 00 00       	push   $0x88
  801701:	68 bd 27 80 00       	push   $0x8027bd
  801706:	e8 7f ee ff ff       	call   80058a <_panic>

0080170b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	57                   	push   %edi
  80170f:	56                   	push   %esi
  801710:	53                   	push   %ebx
  801711:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80171d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801720:	8b 7d 18             	mov    0x18(%ebp),%edi
  801723:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801726:	cd 30                	int    $0x30
  801728:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80172b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	5b                   	pop    %ebx
  801732:	5e                   	pop    %esi
  801733:	5f                   	pop    %edi
  801734:	5d                   	pop    %ebp
  801735:	c3                   	ret    

00801736 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 04             	sub    $0x4,%esp
  80173c:	8b 45 10             	mov    0x10(%ebp),%eax
  80173f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801742:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	52                   	push   %edx
  80174e:	ff 75 0c             	pushl  0xc(%ebp)
  801751:	50                   	push   %eax
  801752:	6a 00                	push   $0x0
  801754:	e8 b2 ff ff ff       	call   80170b <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
}
  80175c:	90                   	nop
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_cgetc>:

int
sys_cgetc(void)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 02                	push   $0x2
  80176e:	e8 98 ff ff ff       	call   80170b <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 03                	push   $0x3
  801787:	e8 7f ff ff ff       	call   80170b <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	90                   	nop
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 04                	push   $0x4
  8017a1:	e8 65 ff ff ff       	call   80170b <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	90                   	nop
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	52                   	push   %edx
  8017bc:	50                   	push   %eax
  8017bd:	6a 08                	push   $0x8
  8017bf:	e8 47 ff ff ff       	call   80170b <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	56                   	push   %esi
  8017cd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017ce:	8b 75 18             	mov    0x18(%ebp),%esi
  8017d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	56                   	push   %esi
  8017de:	53                   	push   %ebx
  8017df:	51                   	push   %ecx
  8017e0:	52                   	push   %edx
  8017e1:	50                   	push   %eax
  8017e2:	6a 09                	push   $0x9
  8017e4:	e8 22 ff ff ff       	call   80170b <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ef:	5b                   	pop    %ebx
  8017f0:	5e                   	pop    %esi
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	52                   	push   %edx
  801803:	50                   	push   %eax
  801804:	6a 0a                	push   $0xa
  801806:	e8 00 ff ff ff       	call   80170b <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	ff 75 0c             	pushl  0xc(%ebp)
  80181c:	ff 75 08             	pushl  0x8(%ebp)
  80181f:	6a 0b                	push   $0xb
  801821:	e8 e5 fe ff ff       	call   80170b <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 0c                	push   $0xc
  80183a:	e8 cc fe ff ff       	call   80170b <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 0d                	push   $0xd
  801853:	e8 b3 fe ff ff       	call   80170b <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 0e                	push   $0xe
  80186c:	e8 9a fe ff ff       	call   80170b <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 0f                	push   $0xf
  801885:	e8 81 fe ff ff       	call   80170b <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	ff 75 08             	pushl  0x8(%ebp)
  80189d:	6a 10                	push   $0x10
  80189f:	e8 67 fe ff ff       	call   80170b <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 11                	push   $0x11
  8018b8:	e8 4e fe ff ff       	call   80170b <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	90                   	nop
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018cf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	50                   	push   %eax
  8018dc:	6a 01                	push   $0x1
  8018de:	e8 28 fe ff ff       	call   80170b <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	90                   	nop
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 14                	push   $0x14
  8018f8:	e8 0e fe ff ff       	call   80170b <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	90                   	nop
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	8b 45 10             	mov    0x10(%ebp),%eax
  80190c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80190f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801912:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	6a 00                	push   $0x0
  80191b:	51                   	push   %ecx
  80191c:	52                   	push   %edx
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	50                   	push   %eax
  801921:	6a 15                	push   $0x15
  801923:	e8 e3 fd ff ff       	call   80170b <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801930:	8b 55 0c             	mov    0xc(%ebp),%edx
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	52                   	push   %edx
  80193d:	50                   	push   %eax
  80193e:	6a 16                	push   $0x16
  801940:	e8 c6 fd ff ff       	call   80170b <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80194d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801950:	8b 55 0c             	mov    0xc(%ebp),%edx
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	51                   	push   %ecx
  80195b:	52                   	push   %edx
  80195c:	50                   	push   %eax
  80195d:	6a 17                	push   $0x17
  80195f:	e8 a7 fd ff ff       	call   80170b <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80196c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	52                   	push   %edx
  801979:	50                   	push   %eax
  80197a:	6a 18                	push   $0x18
  80197c:	e8 8a fd ff ff       	call   80170b <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 14             	pushl  0x14(%ebp)
  801991:	ff 75 10             	pushl  0x10(%ebp)
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	50                   	push   %eax
  801998:	6a 19                	push   $0x19
  80199a:	e8 6c fd ff ff       	call   80170b <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	50                   	push   %eax
  8019b3:	6a 1a                	push   $0x1a
  8019b5:	e8 51 fd ff ff       	call   80170b <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	90                   	nop
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	50                   	push   %eax
  8019cf:	6a 1b                	push   $0x1b
  8019d1:	e8 35 fd ff ff       	call   80170b <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 05                	push   $0x5
  8019ea:	e8 1c fd ff ff       	call   80170b <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 06                	push   $0x6
  801a03:	e8 03 fd ff ff       	call   80170b <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 07                	push   $0x7
  801a1c:	e8 ea fc ff ff       	call   80170b <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_exit_env>:


void sys_exit_env(void)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 1c                	push   $0x1c
  801a35:	e8 d1 fc ff ff       	call   80170b <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a46:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a49:	8d 50 04             	lea    0x4(%eax),%edx
  801a4c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	6a 1d                	push   $0x1d
  801a59:	e8 ad fc ff ff       	call   80170b <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
	return result;
  801a61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6a:	89 01                	mov    %eax,(%ecx)
  801a6c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	c9                   	leave  
  801a73:	c2 04 00             	ret    $0x4

00801a76 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	ff 75 10             	pushl  0x10(%ebp)
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	ff 75 08             	pushl  0x8(%ebp)
  801a86:	6a 13                	push   $0x13
  801a88:	e8 7e fc ff ff       	call   80170b <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a90:	90                   	nop
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 1e                	push   $0x1e
  801aa2:	e8 64 fc ff ff       	call   80170b <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ab8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	50                   	push   %eax
  801ac5:	6a 1f                	push   $0x1f
  801ac7:	e8 3f fc ff ff       	call   80170b <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
	return ;
  801acf:	90                   	nop
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <rsttst>:
void rsttst()
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 21                	push   $0x21
  801ae1:	e8 25 fc ff ff       	call   80170b <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae9:	90                   	nop
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	8b 45 14             	mov    0x14(%ebp),%eax
  801af5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801af8:	8b 55 18             	mov    0x18(%ebp),%edx
  801afb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aff:	52                   	push   %edx
  801b00:	50                   	push   %eax
  801b01:	ff 75 10             	pushl  0x10(%ebp)
  801b04:	ff 75 0c             	pushl  0xc(%ebp)
  801b07:	ff 75 08             	pushl  0x8(%ebp)
  801b0a:	6a 20                	push   $0x20
  801b0c:	e8 fa fb ff ff       	call   80170b <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
	return ;
  801b14:	90                   	nop
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <chktst>:
void chktst(uint32 n)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	ff 75 08             	pushl  0x8(%ebp)
  801b25:	6a 22                	push   $0x22
  801b27:	e8 df fb ff ff       	call   80170b <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2f:	90                   	nop
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <inctst>:

void inctst()
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 23                	push   $0x23
  801b41:	e8 c5 fb ff ff       	call   80170b <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
	return ;
  801b49:	90                   	nop
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <gettst>:
uint32 gettst()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 24                	push   $0x24
  801b5b:	e8 ab fb ff ff       	call   80170b <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 25                	push   $0x25
  801b77:	e8 8f fb ff ff       	call   80170b <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
  801b7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b82:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b86:	75 07                	jne    801b8f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b88:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8d:	eb 05                	jmp    801b94 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 25                	push   $0x25
  801ba8:	e8 5e fb ff ff       	call   80170b <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
  801bb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bb3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bb7:	75 07                	jne    801bc0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbe:	eb 05                	jmp    801bc5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 25                	push   $0x25
  801bd9:	e8 2d fb ff ff       	call   80170b <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
  801be1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801be4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801be8:	75 07                	jne    801bf1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bea:	b8 01 00 00 00       	mov    $0x1,%eax
  801bef:	eb 05                	jmp    801bf6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 25                	push   $0x25
  801c0a:	e8 fc fa ff ff       	call   80170b <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
  801c12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c15:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c19:	75 07                	jne    801c22 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c1b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c20:	eb 05                	jmp    801c27 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	ff 75 08             	pushl  0x8(%ebp)
  801c37:	6a 26                	push   $0x26
  801c39:	e8 cd fa ff ff       	call   80170b <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c41:	90                   	nop
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c48:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	6a 00                	push   $0x0
  801c56:	53                   	push   %ebx
  801c57:	51                   	push   %ecx
  801c58:	52                   	push   %edx
  801c59:	50                   	push   %eax
  801c5a:	6a 27                	push   $0x27
  801c5c:	e8 aa fa ff ff       	call   80170b <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	52                   	push   %edx
  801c79:	50                   	push   %eax
  801c7a:	6a 28                	push   $0x28
  801c7c:	e8 8a fa ff ff       	call   80170b <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c89:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	51                   	push   %ecx
  801c95:	ff 75 10             	pushl  0x10(%ebp)
  801c98:	52                   	push   %edx
  801c99:	50                   	push   %eax
  801c9a:	6a 29                	push   $0x29
  801c9c:	e8 6a fa ff ff       	call   80170b <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	ff 75 10             	pushl  0x10(%ebp)
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	ff 75 08             	pushl  0x8(%ebp)
  801cb6:	6a 12                	push   $0x12
  801cb8:	e8 4e fa ff ff       	call   80170b <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc0:	90                   	nop
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	52                   	push   %edx
  801cd3:	50                   	push   %eax
  801cd4:	6a 2a                	push   $0x2a
  801cd6:	e8 30 fa ff ff       	call   80170b <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
	return;
  801cde:	90                   	nop
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	50                   	push   %eax
  801cf0:	6a 2b                	push   $0x2b
  801cf2:	e8 14 fa ff ff       	call   80170b <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	ff 75 0c             	pushl  0xc(%ebp)
  801d08:	ff 75 08             	pushl  0x8(%ebp)
  801d0b:	6a 2c                	push   $0x2c
  801d0d:	e8 f9 f9 ff ff       	call   80170b <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
	return;
  801d15:	90                   	nop
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	ff 75 0c             	pushl  0xc(%ebp)
  801d24:	ff 75 08             	pushl  0x8(%ebp)
  801d27:	6a 2d                	push   $0x2d
  801d29:	e8 dd f9 ff ff       	call   80170b <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return;
  801d31:	90                   	nop
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <__udivdi3>:
  801d34:	55                   	push   %ebp
  801d35:	57                   	push   %edi
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	83 ec 1c             	sub    $0x1c,%esp
  801d3b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d3f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d4b:	89 ca                	mov    %ecx,%edx
  801d4d:	89 f8                	mov    %edi,%eax
  801d4f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d53:	85 f6                	test   %esi,%esi
  801d55:	75 2d                	jne    801d84 <__udivdi3+0x50>
  801d57:	39 cf                	cmp    %ecx,%edi
  801d59:	77 65                	ja     801dc0 <__udivdi3+0x8c>
  801d5b:	89 fd                	mov    %edi,%ebp
  801d5d:	85 ff                	test   %edi,%edi
  801d5f:	75 0b                	jne    801d6c <__udivdi3+0x38>
  801d61:	b8 01 00 00 00       	mov    $0x1,%eax
  801d66:	31 d2                	xor    %edx,%edx
  801d68:	f7 f7                	div    %edi
  801d6a:	89 c5                	mov    %eax,%ebp
  801d6c:	31 d2                	xor    %edx,%edx
  801d6e:	89 c8                	mov    %ecx,%eax
  801d70:	f7 f5                	div    %ebp
  801d72:	89 c1                	mov    %eax,%ecx
  801d74:	89 d8                	mov    %ebx,%eax
  801d76:	f7 f5                	div    %ebp
  801d78:	89 cf                	mov    %ecx,%edi
  801d7a:	89 fa                	mov    %edi,%edx
  801d7c:	83 c4 1c             	add    $0x1c,%esp
  801d7f:	5b                   	pop    %ebx
  801d80:	5e                   	pop    %esi
  801d81:	5f                   	pop    %edi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    
  801d84:	39 ce                	cmp    %ecx,%esi
  801d86:	77 28                	ja     801db0 <__udivdi3+0x7c>
  801d88:	0f bd fe             	bsr    %esi,%edi
  801d8b:	83 f7 1f             	xor    $0x1f,%edi
  801d8e:	75 40                	jne    801dd0 <__udivdi3+0x9c>
  801d90:	39 ce                	cmp    %ecx,%esi
  801d92:	72 0a                	jb     801d9e <__udivdi3+0x6a>
  801d94:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d98:	0f 87 9e 00 00 00    	ja     801e3c <__udivdi3+0x108>
  801d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801da3:	89 fa                	mov    %edi,%edx
  801da5:	83 c4 1c             	add    $0x1c,%esp
  801da8:	5b                   	pop    %ebx
  801da9:	5e                   	pop    %esi
  801daa:	5f                   	pop    %edi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    
  801dad:	8d 76 00             	lea    0x0(%esi),%esi
  801db0:	31 ff                	xor    %edi,%edi
  801db2:	31 c0                	xor    %eax,%eax
  801db4:	89 fa                	mov    %edi,%edx
  801db6:	83 c4 1c             	add    $0x1c,%esp
  801db9:	5b                   	pop    %ebx
  801dba:	5e                   	pop    %esi
  801dbb:	5f                   	pop    %edi
  801dbc:	5d                   	pop    %ebp
  801dbd:	c3                   	ret    
  801dbe:	66 90                	xchg   %ax,%ax
  801dc0:	89 d8                	mov    %ebx,%eax
  801dc2:	f7 f7                	div    %edi
  801dc4:	31 ff                	xor    %edi,%edi
  801dc6:	89 fa                	mov    %edi,%edx
  801dc8:	83 c4 1c             	add    $0x1c,%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5f                   	pop    %edi
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    
  801dd0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801dd5:	89 eb                	mov    %ebp,%ebx
  801dd7:	29 fb                	sub    %edi,%ebx
  801dd9:	89 f9                	mov    %edi,%ecx
  801ddb:	d3 e6                	shl    %cl,%esi
  801ddd:	89 c5                	mov    %eax,%ebp
  801ddf:	88 d9                	mov    %bl,%cl
  801de1:	d3 ed                	shr    %cl,%ebp
  801de3:	89 e9                	mov    %ebp,%ecx
  801de5:	09 f1                	or     %esi,%ecx
  801de7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801deb:	89 f9                	mov    %edi,%ecx
  801ded:	d3 e0                	shl    %cl,%eax
  801def:	89 c5                	mov    %eax,%ebp
  801df1:	89 d6                	mov    %edx,%esi
  801df3:	88 d9                	mov    %bl,%cl
  801df5:	d3 ee                	shr    %cl,%esi
  801df7:	89 f9                	mov    %edi,%ecx
  801df9:	d3 e2                	shl    %cl,%edx
  801dfb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dff:	88 d9                	mov    %bl,%cl
  801e01:	d3 e8                	shr    %cl,%eax
  801e03:	09 c2                	or     %eax,%edx
  801e05:	89 d0                	mov    %edx,%eax
  801e07:	89 f2                	mov    %esi,%edx
  801e09:	f7 74 24 0c          	divl   0xc(%esp)
  801e0d:	89 d6                	mov    %edx,%esi
  801e0f:	89 c3                	mov    %eax,%ebx
  801e11:	f7 e5                	mul    %ebp
  801e13:	39 d6                	cmp    %edx,%esi
  801e15:	72 19                	jb     801e30 <__udivdi3+0xfc>
  801e17:	74 0b                	je     801e24 <__udivdi3+0xf0>
  801e19:	89 d8                	mov    %ebx,%eax
  801e1b:	31 ff                	xor    %edi,%edi
  801e1d:	e9 58 ff ff ff       	jmp    801d7a <__udivdi3+0x46>
  801e22:	66 90                	xchg   %ax,%ax
  801e24:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e28:	89 f9                	mov    %edi,%ecx
  801e2a:	d3 e2                	shl    %cl,%edx
  801e2c:	39 c2                	cmp    %eax,%edx
  801e2e:	73 e9                	jae    801e19 <__udivdi3+0xe5>
  801e30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e33:	31 ff                	xor    %edi,%edi
  801e35:	e9 40 ff ff ff       	jmp    801d7a <__udivdi3+0x46>
  801e3a:	66 90                	xchg   %ax,%ax
  801e3c:	31 c0                	xor    %eax,%eax
  801e3e:	e9 37 ff ff ff       	jmp    801d7a <__udivdi3+0x46>
  801e43:	90                   	nop

00801e44 <__umoddi3>:
  801e44:	55                   	push   %ebp
  801e45:	57                   	push   %edi
  801e46:	56                   	push   %esi
  801e47:	53                   	push   %ebx
  801e48:	83 ec 1c             	sub    $0x1c,%esp
  801e4b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e57:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e63:	89 f3                	mov    %esi,%ebx
  801e65:	89 fa                	mov    %edi,%edx
  801e67:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e6b:	89 34 24             	mov    %esi,(%esp)
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	75 1a                	jne    801e8c <__umoddi3+0x48>
  801e72:	39 f7                	cmp    %esi,%edi
  801e74:	0f 86 a2 00 00 00    	jbe    801f1c <__umoddi3+0xd8>
  801e7a:	89 c8                	mov    %ecx,%eax
  801e7c:	89 f2                	mov    %esi,%edx
  801e7e:	f7 f7                	div    %edi
  801e80:	89 d0                	mov    %edx,%eax
  801e82:	31 d2                	xor    %edx,%edx
  801e84:	83 c4 1c             	add    $0x1c,%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5f                   	pop    %edi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    
  801e8c:	39 f0                	cmp    %esi,%eax
  801e8e:	0f 87 ac 00 00 00    	ja     801f40 <__umoddi3+0xfc>
  801e94:	0f bd e8             	bsr    %eax,%ebp
  801e97:	83 f5 1f             	xor    $0x1f,%ebp
  801e9a:	0f 84 ac 00 00 00    	je     801f4c <__umoddi3+0x108>
  801ea0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ea5:	29 ef                	sub    %ebp,%edi
  801ea7:	89 fe                	mov    %edi,%esi
  801ea9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ead:	89 e9                	mov    %ebp,%ecx
  801eaf:	d3 e0                	shl    %cl,%eax
  801eb1:	89 d7                	mov    %edx,%edi
  801eb3:	89 f1                	mov    %esi,%ecx
  801eb5:	d3 ef                	shr    %cl,%edi
  801eb7:	09 c7                	or     %eax,%edi
  801eb9:	89 e9                	mov    %ebp,%ecx
  801ebb:	d3 e2                	shl    %cl,%edx
  801ebd:	89 14 24             	mov    %edx,(%esp)
  801ec0:	89 d8                	mov    %ebx,%eax
  801ec2:	d3 e0                	shl    %cl,%eax
  801ec4:	89 c2                	mov    %eax,%edx
  801ec6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eca:	d3 e0                	shl    %cl,%eax
  801ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ed4:	89 f1                	mov    %esi,%ecx
  801ed6:	d3 e8                	shr    %cl,%eax
  801ed8:	09 d0                	or     %edx,%eax
  801eda:	d3 eb                	shr    %cl,%ebx
  801edc:	89 da                	mov    %ebx,%edx
  801ede:	f7 f7                	div    %edi
  801ee0:	89 d3                	mov    %edx,%ebx
  801ee2:	f7 24 24             	mull   (%esp)
  801ee5:	89 c6                	mov    %eax,%esi
  801ee7:	89 d1                	mov    %edx,%ecx
  801ee9:	39 d3                	cmp    %edx,%ebx
  801eeb:	0f 82 87 00 00 00    	jb     801f78 <__umoddi3+0x134>
  801ef1:	0f 84 91 00 00 00    	je     801f88 <__umoddi3+0x144>
  801ef7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801efb:	29 f2                	sub    %esi,%edx
  801efd:	19 cb                	sbb    %ecx,%ebx
  801eff:	89 d8                	mov    %ebx,%eax
  801f01:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f05:	d3 e0                	shl    %cl,%eax
  801f07:	89 e9                	mov    %ebp,%ecx
  801f09:	d3 ea                	shr    %cl,%edx
  801f0b:	09 d0                	or     %edx,%eax
  801f0d:	89 e9                	mov    %ebp,%ecx
  801f0f:	d3 eb                	shr    %cl,%ebx
  801f11:	89 da                	mov    %ebx,%edx
  801f13:	83 c4 1c             	add    $0x1c,%esp
  801f16:	5b                   	pop    %ebx
  801f17:	5e                   	pop    %esi
  801f18:	5f                   	pop    %edi
  801f19:	5d                   	pop    %ebp
  801f1a:	c3                   	ret    
  801f1b:	90                   	nop
  801f1c:	89 fd                	mov    %edi,%ebp
  801f1e:	85 ff                	test   %edi,%edi
  801f20:	75 0b                	jne    801f2d <__umoddi3+0xe9>
  801f22:	b8 01 00 00 00       	mov    $0x1,%eax
  801f27:	31 d2                	xor    %edx,%edx
  801f29:	f7 f7                	div    %edi
  801f2b:	89 c5                	mov    %eax,%ebp
  801f2d:	89 f0                	mov    %esi,%eax
  801f2f:	31 d2                	xor    %edx,%edx
  801f31:	f7 f5                	div    %ebp
  801f33:	89 c8                	mov    %ecx,%eax
  801f35:	f7 f5                	div    %ebp
  801f37:	89 d0                	mov    %edx,%eax
  801f39:	e9 44 ff ff ff       	jmp    801e82 <__umoddi3+0x3e>
  801f3e:	66 90                	xchg   %ax,%ax
  801f40:	89 c8                	mov    %ecx,%eax
  801f42:	89 f2                	mov    %esi,%edx
  801f44:	83 c4 1c             	add    $0x1c,%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5e                   	pop    %esi
  801f49:	5f                   	pop    %edi
  801f4a:	5d                   	pop    %ebp
  801f4b:	c3                   	ret    
  801f4c:	3b 04 24             	cmp    (%esp),%eax
  801f4f:	72 06                	jb     801f57 <__umoddi3+0x113>
  801f51:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f55:	77 0f                	ja     801f66 <__umoddi3+0x122>
  801f57:	89 f2                	mov    %esi,%edx
  801f59:	29 f9                	sub    %edi,%ecx
  801f5b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f5f:	89 14 24             	mov    %edx,(%esp)
  801f62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f66:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f6a:	8b 14 24             	mov    (%esp),%edx
  801f6d:	83 c4 1c             	add    $0x1c,%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5e                   	pop    %esi
  801f72:	5f                   	pop    %edi
  801f73:	5d                   	pop    %ebp
  801f74:	c3                   	ret    
  801f75:	8d 76 00             	lea    0x0(%esi),%esi
  801f78:	2b 04 24             	sub    (%esp),%eax
  801f7b:	19 fa                	sbb    %edi,%edx
  801f7d:	89 d1                	mov    %edx,%ecx
  801f7f:	89 c6                	mov    %eax,%esi
  801f81:	e9 71 ff ff ff       	jmp    801ef7 <__umoddi3+0xb3>
  801f86:	66 90                	xchg   %ax,%ax
  801f88:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f8c:	72 ea                	jb     801f78 <__umoddi3+0x134>
  801f8e:	89 d9                	mov    %ebx,%ecx
  801f90:	e9 62 ff ff ff       	jmp    801ef7 <__umoddi3+0xb3>
