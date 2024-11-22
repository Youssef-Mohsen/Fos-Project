
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 23 02 00 00       	call   800259 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
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
  80005c:	68 a0 3b 80 00       	push   $0x803ba0
  800061:	6a 0d                	push   $0xd
  800063:	68 bc 3b 80 00       	push   $0x803bbc
  800068:	e8 2b 03 00 00       	call   800398 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  800074:	e8 e8 1a 00 00       	call   801b61 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int freeFrames, diff, expected;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 4b 18 00 00       	call   8018cc <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 f9 18 00 00       	call   80197f <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 d7 3b 80 00       	push   $0x803bd7
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 18 17 00 00       	call   8017b1 <sget>
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000ab:	74 1a                	je     8000c7 <_main+0x8f>
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	68 dc 3b 80 00       	push   $0x803bdc
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 bc 3b 80 00       	push   $0x803bbc
  8000c2:	e8 d1 02 00 00       	call   800398 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 a9 18 00 00       	call   80197f <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 92 18 00 00       	call   80197f <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 58 3c 80 00       	push   $0x803c58
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 bc 3b 80 00       	push   $0x803bbc
  800104:	e8 8f 02 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 d8 17 00 00       	call   8018e6 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 b9 17 00 00       	call   8018cc <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 67 18 00 00       	call   80197f <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 f0 3c 80 00       	push   $0x803cf0
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 86 16 00 00       	call   8017b1 <sget>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800134:	05 00 10 00 00       	add    $0x1000,%eax
  800139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  80013c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	74 1a                	je     80015e <_main+0x126>
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	ff 75 d8             	pushl  -0x28(%ebp)
  80014a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014d:	68 dc 3b 80 00       	push   $0x803bdc
  800152:	6a 31                	push   $0x31
  800154:	68 bc 3b 80 00       	push   $0x803bbc
  800159:	e8 3a 02 00 00       	call   800398 <_panic>
		expected = 0;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 12 18 00 00       	call   80197f <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 fb 17 00 00       	call   80197f <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 58 3c 80 00       	push   $0x803c58
  800194:	6a 34                	push   $0x34
  800196:	68 bc 3b 80 00       	push   $0x803bbc
  80019b:	e8 f8 01 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 41 17 00 00       	call   8018e6 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 0a             	cmp    $0xa,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 f4 3c 80 00       	push   $0x803cf4
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 bc 3b 80 00       	push   $0x803bbc
  8001be:	e8 d5 01 00 00       	call   800398 <_panic>

	//Edit the writable object
	*z = 50;
  8001c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c6:	c7 00 32 00 00 00    	movl   $0x32,(%eax)
	if (*z != 50) panic("Get(): Shared Variable is not created or got correctly") ;
  8001cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001cf:	8b 00                	mov    (%eax),%eax
  8001d1:	83 f8 32             	cmp    $0x32,%eax
  8001d4:	74 14                	je     8001ea <_main+0x1b2>
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 f4 3c 80 00       	push   $0x803cf4
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 bc 3b 80 00       	push   $0x803bbc
  8001e5:	e8 ae 01 00 00       	call   800398 <_panic>

	inctst();
  8001ea:	e8 97 1a 00 00       	call   801c86 <inctst>

	//sync with master
	while (gettst() != 5) ;
  8001ef:	90                   	nop
  8001f0:	e8 ab 1a 00 00       	call   801ca0 <gettst>
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	75 f6                	jne    8001f0 <_main+0x1b8>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 06                	push   $0x6
  8001ff:	e8 fc 19 00 00       	call   801c00 <sys_bypassPageFault>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	68 2c 3d 80 00       	push   $0x803d2c
  800212:	e8 3e 04 00 00       	call   800655 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 d3 19 00 00       	call   801c00 <sys_bypassPageFault>
  80022d:	83 c4 10             	add    $0x10,%esp

	inctst();
  800230:	e8 51 1a 00 00       	call   801c86 <inctst>
	if (*x == 100)
  800235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	83 f8 64             	cmp    $0x64,%eax
  80023d:	75 14                	jne    800253 <_main+0x21b>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 5c 3d 80 00       	push   $0x803d5c
  800247:	6a 4d                	push   $0x4d
  800249:	68 bc 3b 80 00       	push   $0x803bbc
  80024e:	e8 45 01 00 00       	call   800398 <_panic>
	return;
  800253:	90                   	nop
}
  800254:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80025f:	e8 e4 18 00 00       	call   801b48 <sys_getenvindex>
  800264:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800267:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80026a:	89 d0                	mov    %edx,%eax
  80026c:	c1 e0 03             	shl    $0x3,%eax
  80026f:	01 d0                	add    %edx,%eax
  800271:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800278:	01 c8                	add    %ecx,%eax
  80027a:	01 c0                	add    %eax,%eax
  80027c:	01 d0                	add    %edx,%eax
  80027e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800285:	01 c8                	add    %ecx,%eax
  800287:	01 d0                	add    %edx,%eax
  800289:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80028e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800293:	a1 20 50 80 00       	mov    0x805020,%eax
  800298:	8a 40 20             	mov    0x20(%eax),%al
  80029b:	84 c0                	test   %al,%al
  80029d:	74 0d                	je     8002ac <libmain+0x53>
		binaryname = myEnv->prog_name;
  80029f:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a4:	83 c0 20             	add    $0x20,%eax
  8002a7:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b0:	7e 0a                	jle    8002bc <libmain+0x63>
		binaryname = argv[0];
  8002b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8002bc:	83 ec 08             	sub    $0x8,%esp
  8002bf:	ff 75 0c             	pushl  0xc(%ebp)
  8002c2:	ff 75 08             	pushl  0x8(%ebp)
  8002c5:	e8 6e fd ff ff       	call   800038 <_main>
  8002ca:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8002cd:	e8 fa 15 00 00       	call   8018cc <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	68 bc 3d 80 00       	push   $0x803dbc
  8002da:	e8 76 03 00 00       	call   800655 <cprintf>
  8002df:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f2:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	52                   	push   %edx
  8002fc:	50                   	push   %eax
  8002fd:	68 e4 3d 80 00       	push   $0x803de4
  800302:	e8 4e 03 00 00       	call   800655 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80030a:	a1 20 50 80 00       	mov    0x805020,%eax
  80030f:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800315:	a1 20 50 80 00       	mov    0x805020,%eax
  80031a:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800320:	a1 20 50 80 00       	mov    0x805020,%eax
  800325:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80032b:	51                   	push   %ecx
  80032c:	52                   	push   %edx
  80032d:	50                   	push   %eax
  80032e:	68 0c 3e 80 00       	push   $0x803e0c
  800333:	e8 1d 03 00 00       	call   800655 <cprintf>
  800338:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80033b:	a1 20 50 80 00       	mov    0x805020,%eax
  800340:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	50                   	push   %eax
  80034a:	68 64 3e 80 00       	push   $0x803e64
  80034f:	e8 01 03 00 00       	call   800655 <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	68 bc 3d 80 00       	push   $0x803dbc
  80035f:	e8 f1 02 00 00       	call   800655 <cprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800367:	e8 7a 15 00 00       	call   8018e6 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80036c:	e8 19 00 00 00       	call   80038a <exit>
}
  800371:	90                   	nop
  800372:	c9                   	leave  
  800373:	c3                   	ret    

00800374 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	6a 00                	push   $0x0
  80037f:	e8 90 17 00 00       	call   801b14 <sys_destroy_env>
  800384:	83 c4 10             	add    $0x10,%esp
}
  800387:	90                   	nop
  800388:	c9                   	leave  
  800389:	c3                   	ret    

0080038a <exit>:

void
exit(void)
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800390:	e8 e5 17 00 00       	call   801b7a <sys_exit_env>
}
  800395:	90                   	nop
  800396:	c9                   	leave  
  800397:	c3                   	ret    

00800398 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80039e:	8d 45 10             	lea    0x10(%ebp),%eax
  8003a1:	83 c0 04             	add    $0x4,%eax
  8003a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003a7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8003ac:	85 c0                	test   %eax,%eax
  8003ae:	74 16                	je     8003c6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003b0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	50                   	push   %eax
  8003b9:	68 78 3e 80 00       	push   $0x803e78
  8003be:	e8 92 02 00 00       	call   800655 <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003c6:	a1 00 50 80 00       	mov    0x805000,%eax
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	50                   	push   %eax
  8003d2:	68 7d 3e 80 00       	push   $0x803e7d
  8003d7:	e8 79 02 00 00       	call   800655 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003df:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e8:	50                   	push   %eax
  8003e9:	e8 fc 01 00 00       	call   8005ea <vcprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003f1:	83 ec 08             	sub    $0x8,%esp
  8003f4:	6a 00                	push   $0x0
  8003f6:	68 99 3e 80 00       	push   $0x803e99
  8003fb:	e8 ea 01 00 00       	call   8005ea <vcprintf>
  800400:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800403:	e8 82 ff ff ff       	call   80038a <exit>

	// should not return here
	while (1) ;
  800408:	eb fe                	jmp    800408 <_panic+0x70>

0080040a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800410:	a1 20 50 80 00       	mov    0x805020,%eax
  800415:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80041b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041e:	39 c2                	cmp    %eax,%edx
  800420:	74 14                	je     800436 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800422:	83 ec 04             	sub    $0x4,%esp
  800425:	68 9c 3e 80 00       	push   $0x803e9c
  80042a:	6a 26                	push   $0x26
  80042c:	68 e8 3e 80 00       	push   $0x803ee8
  800431:	e8 62 ff ff ff       	call   800398 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800436:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80043d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800444:	e9 c5 00 00 00       	jmp    80050e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 d0                	add    %edx,%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	85 c0                	test   %eax,%eax
  80045c:	75 08                	jne    800466 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80045e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800461:	e9 a5 00 00 00       	jmp    80050b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800466:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800474:	eb 69                	jmp    8004df <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800476:	a1 20 50 80 00       	mov    0x805020,%eax
  80047b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800481:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	01 c0                	add    %eax,%eax
  800488:	01 d0                	add    %edx,%eax
  80048a:	c1 e0 03             	shl    $0x3,%eax
  80048d:	01 c8                	add    %ecx,%eax
  80048f:	8a 40 04             	mov    0x4(%eax),%al
  800492:	84 c0                	test   %al,%al
  800494:	75 46                	jne    8004dc <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800496:	a1 20 50 80 00       	mov    0x805020,%eax
  80049b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8004a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a4:	89 d0                	mov    %edx,%eax
  8004a6:	01 c0                	add    %eax,%eax
  8004a8:	01 d0                	add    %edx,%eax
  8004aa:	c1 e0 03             	shl    $0x3,%eax
  8004ad:	01 c8                	add    %ecx,%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	01 c8                	add    %ecx,%eax
  8004cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004cf:	39 c2                	cmp    %eax,%edx
  8004d1:	75 09                	jne    8004dc <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004da:	eb 15                	jmp    8004f1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004dc:	ff 45 e8             	incl   -0x18(%ebp)
  8004df:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8004ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ed:	39 c2                	cmp    %eax,%edx
  8004ef:	77 85                	ja     800476 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004f5:	75 14                	jne    80050b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004f7:	83 ec 04             	sub    $0x4,%esp
  8004fa:	68 f4 3e 80 00       	push   $0x803ef4
  8004ff:	6a 3a                	push   $0x3a
  800501:	68 e8 3e 80 00       	push   $0x803ee8
  800506:	e8 8d fe ff ff       	call   800398 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80050b:	ff 45 f0             	incl   -0x10(%ebp)
  80050e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800511:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800514:	0f 8c 2f ff ff ff    	jl     800449 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80051a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800521:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800528:	eb 26                	jmp    800550 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80052a:	a1 20 50 80 00       	mov    0x805020,%eax
  80052f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800535:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800538:	89 d0                	mov    %edx,%eax
  80053a:	01 c0                	add    %eax,%eax
  80053c:	01 d0                	add    %edx,%eax
  80053e:	c1 e0 03             	shl    $0x3,%eax
  800541:	01 c8                	add    %ecx,%eax
  800543:	8a 40 04             	mov    0x4(%eax),%al
  800546:	3c 01                	cmp    $0x1,%al
  800548:	75 03                	jne    80054d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80054a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054d:	ff 45 e0             	incl   -0x20(%ebp)
  800550:	a1 20 50 80 00       	mov    0x805020,%eax
  800555:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80055b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055e:	39 c2                	cmp    %eax,%edx
  800560:	77 c8                	ja     80052a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800565:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800568:	74 14                	je     80057e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80056a:	83 ec 04             	sub    $0x4,%esp
  80056d:	68 48 3f 80 00       	push   $0x803f48
  800572:	6a 44                	push   $0x44
  800574:	68 e8 3e 80 00       	push   $0x803ee8
  800579:	e8 1a fe ff ff       	call   800398 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80057e:	90                   	nop
  80057f:	c9                   	leave  
  800580:	c3                   	ret    

00800581 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800581:	55                   	push   %ebp
  800582:	89 e5                	mov    %esp,%ebp
  800584:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	8d 48 01             	lea    0x1(%eax),%ecx
  80058f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800592:	89 0a                	mov    %ecx,(%edx)
  800594:	8b 55 08             	mov    0x8(%ebp),%edx
  800597:	88 d1                	mov    %dl,%cl
  800599:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005aa:	75 2c                	jne    8005d8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005ac:	a0 28 50 80 00       	mov    0x805028,%al
  8005b1:	0f b6 c0             	movzbl %al,%eax
  8005b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b7:	8b 12                	mov    (%edx),%edx
  8005b9:	89 d1                	mov    %edx,%ecx
  8005bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005be:	83 c2 08             	add    $0x8,%edx
  8005c1:	83 ec 04             	sub    $0x4,%esp
  8005c4:	50                   	push   %eax
  8005c5:	51                   	push   %ecx
  8005c6:	52                   	push   %edx
  8005c7:	e8 be 12 00 00       	call   80188a <sys_cputs>
  8005cc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005db:	8b 40 04             	mov    0x4(%eax),%eax
  8005de:	8d 50 01             	lea    0x1(%eax),%edx
  8005e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005e7:	90                   	nop
  8005e8:	c9                   	leave  
  8005e9:	c3                   	ret    

008005ea <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005fa:	00 00 00 
	b.cnt = 0;
  8005fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800604:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800607:	ff 75 0c             	pushl  0xc(%ebp)
  80060a:	ff 75 08             	pushl  0x8(%ebp)
  80060d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800613:	50                   	push   %eax
  800614:	68 81 05 80 00       	push   $0x800581
  800619:	e8 11 02 00 00       	call   80082f <vprintfmt>
  80061e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800621:	a0 28 50 80 00       	mov    0x805028,%al
  800626:	0f b6 c0             	movzbl %al,%eax
  800629:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	50                   	push   %eax
  800633:	52                   	push   %edx
  800634:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80063a:	83 c0 08             	add    $0x8,%eax
  80063d:	50                   	push   %eax
  80063e:	e8 47 12 00 00       	call   80188a <sys_cputs>
  800643:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800646:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  80064d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800653:	c9                   	leave  
  800654:	c3                   	ret    

00800655 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80065b:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800662:	8d 45 0c             	lea    0xc(%ebp),%eax
  800665:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	ff 75 f4             	pushl  -0xc(%ebp)
  800671:	50                   	push   %eax
  800672:	e8 73 ff ff ff       	call   8005ea <vcprintf>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80067d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800680:	c9                   	leave  
  800681:	c3                   	ret    

00800682 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800688:	e8 3f 12 00 00       	call   8018cc <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80068d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800690:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	ff 75 f4             	pushl  -0xc(%ebp)
  80069c:	50                   	push   %eax
  80069d:	e8 48 ff ff ff       	call   8005ea <vcprintf>
  8006a2:	83 c4 10             	add    $0x10,%esp
  8006a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006a8:	e8 39 12 00 00       	call   8018e6 <sys_unlock_cons>
	return cnt;
  8006ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006b0:	c9                   	leave  
  8006b1:	c3                   	ret    

008006b2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006b2:	55                   	push   %ebp
  8006b3:	89 e5                	mov    %esp,%ebp
  8006b5:	53                   	push   %ebx
  8006b6:	83 ec 14             	sub    $0x14,%esp
  8006b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8006bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d0:	77 55                	ja     800727 <printnum+0x75>
  8006d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d5:	72 05                	jb     8006dc <printnum+0x2a>
  8006d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006da:	77 4b                	ja     800727 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006dc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006df:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ea:	52                   	push   %edx
  8006eb:	50                   	push   %eax
  8006ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8006f2:	e8 2d 32 00 00       	call   803924 <__udivdi3>
  8006f7:	83 c4 10             	add    $0x10,%esp
  8006fa:	83 ec 04             	sub    $0x4,%esp
  8006fd:	ff 75 20             	pushl  0x20(%ebp)
  800700:	53                   	push   %ebx
  800701:	ff 75 18             	pushl  0x18(%ebp)
  800704:	52                   	push   %edx
  800705:	50                   	push   %eax
  800706:	ff 75 0c             	pushl  0xc(%ebp)
  800709:	ff 75 08             	pushl  0x8(%ebp)
  80070c:	e8 a1 ff ff ff       	call   8006b2 <printnum>
  800711:	83 c4 20             	add    $0x20,%esp
  800714:	eb 1a                	jmp    800730 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	ff 75 20             	pushl  0x20(%ebp)
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800727:	ff 4d 1c             	decl   0x1c(%ebp)
  80072a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80072e:	7f e6                	jg     800716 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800730:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800733:	bb 00 00 00 00       	mov    $0x0,%ebx
  800738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073e:	53                   	push   %ebx
  80073f:	51                   	push   %ecx
  800740:	52                   	push   %edx
  800741:	50                   	push   %eax
  800742:	e8 ed 32 00 00       	call   803a34 <__umoddi3>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	05 b4 41 80 00       	add    $0x8041b4,%eax
  80074f:	8a 00                	mov    (%eax),%al
  800751:	0f be c0             	movsbl %al,%eax
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	50                   	push   %eax
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
}
  800763:	90                   	nop
  800764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800767:	c9                   	leave  
  800768:	c3                   	ret    

00800769 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80076c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800770:	7e 1c                	jle    80078e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	8d 50 08             	lea    0x8(%eax),%edx
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	89 10                	mov    %edx,(%eax)
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	83 e8 08             	sub    $0x8,%eax
  800787:	8b 50 04             	mov    0x4(%eax),%edx
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	eb 40                	jmp    8007ce <getuint+0x65>
	else if (lflag)
  80078e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800792:	74 1e                	je     8007b2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	8d 50 04             	lea    0x4(%eax),%edx
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	89 10                	mov    %edx,(%eax)
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	83 e8 04             	sub    $0x4,%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b0:	eb 1c                	jmp    8007ce <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	89 10                	mov    %edx,(%eax)
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	83 e8 04             	sub    $0x4,%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d7:	7e 1c                	jle    8007f5 <getint+0x25>
		return va_arg(*ap, long long);
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	8d 50 08             	lea    0x8(%eax),%edx
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	89 10                	mov    %edx,(%eax)
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	83 e8 08             	sub    $0x8,%eax
  8007ee:	8b 50 04             	mov    0x4(%eax),%edx
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	eb 38                	jmp    80082d <getint+0x5d>
	else if (lflag)
  8007f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f9:	74 1a                	je     800815 <getint+0x45>
		return va_arg(*ap, long);
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	8d 50 04             	lea    0x4(%eax),%edx
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	89 10                	mov    %edx,(%eax)
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	83 e8 04             	sub    $0x4,%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	99                   	cltd   
  800813:	eb 18                	jmp    80082d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	8d 50 04             	lea    0x4(%eax),%edx
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	89 10                	mov    %edx,(%eax)
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	83 e8 04             	sub    $0x4,%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	99                   	cltd   
}
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	56                   	push   %esi
  800833:	53                   	push   %ebx
  800834:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800837:	eb 17                	jmp    800850 <vprintfmt+0x21>
			if (ch == '\0')
  800839:	85 db                	test   %ebx,%ebx
  80083b:	0f 84 c1 03 00 00    	je     800c02 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	53                   	push   %ebx
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800850:	8b 45 10             	mov    0x10(%ebp),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	89 55 10             	mov    %edx,0x10(%ebp)
  800859:	8a 00                	mov    (%eax),%al
  80085b:	0f b6 d8             	movzbl %al,%ebx
  80085e:	83 fb 25             	cmp    $0x25,%ebx
  800861:	75 d6                	jne    800839 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800863:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800867:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80086e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800875:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80087c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800883:	8b 45 10             	mov    0x10(%ebp),%eax
  800886:	8d 50 01             	lea    0x1(%eax),%edx
  800889:	89 55 10             	mov    %edx,0x10(%ebp)
  80088c:	8a 00                	mov    (%eax),%al
  80088e:	0f b6 d8             	movzbl %al,%ebx
  800891:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800894:	83 f8 5b             	cmp    $0x5b,%eax
  800897:	0f 87 3d 03 00 00    	ja     800bda <vprintfmt+0x3ab>
  80089d:	8b 04 85 d8 41 80 00 	mov    0x8041d8(,%eax,4),%eax
  8008a4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008a6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008aa:	eb d7                	jmp    800883 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ac:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008b0:	eb d1                	jmp    800883 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008bc:	89 d0                	mov    %edx,%eax
  8008be:	c1 e0 02             	shl    $0x2,%eax
  8008c1:	01 d0                	add    %edx,%eax
  8008c3:	01 c0                	add    %eax,%eax
  8008c5:	01 d8                	add    %ebx,%eax
  8008c7:	83 e8 30             	sub    $0x30,%eax
  8008ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d0:	8a 00                	mov    (%eax),%al
  8008d2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008d5:	83 fb 2f             	cmp    $0x2f,%ebx
  8008d8:	7e 3e                	jle    800918 <vprintfmt+0xe9>
  8008da:	83 fb 39             	cmp    $0x39,%ebx
  8008dd:	7f 39                	jg     800918 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008df:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008e2:	eb d5                	jmp    8008b9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	83 c0 04             	add    $0x4,%eax
  8008ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	83 e8 04             	sub    $0x4,%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008f8:	eb 1f                	jmp    800919 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fe:	79 83                	jns    800883 <vprintfmt+0x54>
				width = 0;
  800900:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800907:	e9 77 ff ff ff       	jmp    800883 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80090c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800913:	e9 6b ff ff ff       	jmp    800883 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800918:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800919:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091d:	0f 89 60 ff ff ff    	jns    800883 <vprintfmt+0x54>
				width = precision, precision = -1;
  800923:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800926:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800929:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800930:	e9 4e ff ff ff       	jmp    800883 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800935:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800938:	e9 46 ff ff ff       	jmp    800883 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	83 c0 04             	add    $0x4,%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	83 e8 04             	sub    $0x4,%eax
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	ff 75 0c             	pushl  0xc(%ebp)
  800954:	50                   	push   %eax
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	ff d0                	call   *%eax
  80095a:	83 c4 10             	add    $0x10,%esp
			break;
  80095d:	e9 9b 02 00 00       	jmp    800bfd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800962:	8b 45 14             	mov    0x14(%ebp),%eax
  800965:	83 c0 04             	add    $0x4,%eax
  800968:	89 45 14             	mov    %eax,0x14(%ebp)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 e8 04             	sub    $0x4,%eax
  800971:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800973:	85 db                	test   %ebx,%ebx
  800975:	79 02                	jns    800979 <vprintfmt+0x14a>
				err = -err;
  800977:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800979:	83 fb 64             	cmp    $0x64,%ebx
  80097c:	7f 0b                	jg     800989 <vprintfmt+0x15a>
  80097e:	8b 34 9d 20 40 80 00 	mov    0x804020(,%ebx,4),%esi
  800985:	85 f6                	test   %esi,%esi
  800987:	75 19                	jne    8009a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800989:	53                   	push   %ebx
  80098a:	68 c5 41 80 00       	push   $0x8041c5
  80098f:	ff 75 0c             	pushl  0xc(%ebp)
  800992:	ff 75 08             	pushl  0x8(%ebp)
  800995:	e8 70 02 00 00       	call   800c0a <printfmt>
  80099a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80099d:	e9 5b 02 00 00       	jmp    800bfd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009a2:	56                   	push   %esi
  8009a3:	68 ce 41 80 00       	push   $0x8041ce
  8009a8:	ff 75 0c             	pushl  0xc(%ebp)
  8009ab:	ff 75 08             	pushl  0x8(%ebp)
  8009ae:	e8 57 02 00 00       	call   800c0a <printfmt>
  8009b3:	83 c4 10             	add    $0x10,%esp
			break;
  8009b6:	e9 42 02 00 00       	jmp    800bfd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	83 c0 04             	add    $0x4,%eax
  8009c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	83 e8 04             	sub    $0x4,%eax
  8009ca:	8b 30                	mov    (%eax),%esi
  8009cc:	85 f6                	test   %esi,%esi
  8009ce:	75 05                	jne    8009d5 <vprintfmt+0x1a6>
				p = "(null)";
  8009d0:	be d1 41 80 00       	mov    $0x8041d1,%esi
			if (width > 0 && padc != '-')
  8009d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d9:	7e 6d                	jle    800a48 <vprintfmt+0x219>
  8009db:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009df:	74 67                	je     800a48 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	50                   	push   %eax
  8009e8:	56                   	push   %esi
  8009e9:	e8 1e 03 00 00       	call   800d0c <strnlen>
  8009ee:	83 c4 10             	add    $0x10,%esp
  8009f1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009f4:	eb 16                	jmp    800a0c <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009f6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	50                   	push   %eax
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a09:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a10:	7f e4                	jg     8009f6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a12:	eb 34                	jmp    800a48 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a14:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a18:	74 1c                	je     800a36 <vprintfmt+0x207>
  800a1a:	83 fb 1f             	cmp    $0x1f,%ebx
  800a1d:	7e 05                	jle    800a24 <vprintfmt+0x1f5>
  800a1f:	83 fb 7e             	cmp    $0x7e,%ebx
  800a22:	7e 12                	jle    800a36 <vprintfmt+0x207>
					putch('?', putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	6a 3f                	push   $0x3f
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
  800a34:	eb 0f                	jmp    800a45 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	53                   	push   %ebx
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	ff d0                	call   *%eax
  800a42:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a45:	ff 4d e4             	decl   -0x1c(%ebp)
  800a48:	89 f0                	mov    %esi,%eax
  800a4a:	8d 70 01             	lea    0x1(%eax),%esi
  800a4d:	8a 00                	mov    (%eax),%al
  800a4f:	0f be d8             	movsbl %al,%ebx
  800a52:	85 db                	test   %ebx,%ebx
  800a54:	74 24                	je     800a7a <vprintfmt+0x24b>
  800a56:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5a:	78 b8                	js     800a14 <vprintfmt+0x1e5>
  800a5c:	ff 4d e0             	decl   -0x20(%ebp)
  800a5f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a63:	79 af                	jns    800a14 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a65:	eb 13                	jmp    800a7a <vprintfmt+0x24b>
				putch(' ', putdat);
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	6a 20                	push   $0x20
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a77:	ff 4d e4             	decl   -0x1c(%ebp)
  800a7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7e:	7f e7                	jg     800a67 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a80:	e9 78 01 00 00       	jmp    800bfd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8e:	50                   	push   %eax
  800a8f:	e8 3c fd ff ff       	call   8007d0 <getint>
  800a94:	83 c4 10             	add    $0x10,%esp
  800a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa3:	85 d2                	test   %edx,%edx
  800aa5:	79 23                	jns    800aca <vprintfmt+0x29b>
				putch('-', putdat);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	6a 2d                	push   $0x2d
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	ff d0                	call   *%eax
  800ab4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abd:	f7 d8                	neg    %eax
  800abf:	83 d2 00             	adc    $0x0,%edx
  800ac2:	f7 da                	neg    %edx
  800ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad1:	e9 bc 00 00 00       	jmp    800b92 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	ff 75 e8             	pushl  -0x18(%ebp)
  800adc:	8d 45 14             	lea    0x14(%ebp),%eax
  800adf:	50                   	push   %eax
  800ae0:	e8 84 fc ff ff       	call   800769 <getuint>
  800ae5:	83 c4 10             	add    $0x10,%esp
  800ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af5:	e9 98 00 00 00       	jmp    800b92 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 58                	push   $0x58
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b0a:	83 ec 08             	sub    $0x8,%esp
  800b0d:	ff 75 0c             	pushl  0xc(%ebp)
  800b10:	6a 58                	push   $0x58
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	ff d0                	call   *%eax
  800b17:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	ff 75 0c             	pushl  0xc(%ebp)
  800b20:	6a 58                	push   $0x58
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	ff d0                	call   *%eax
  800b27:	83 c4 10             	add    $0x10,%esp
			break;
  800b2a:	e9 ce 00 00 00       	jmp    800bfd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	6a 30                	push   $0x30
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	ff d0                	call   *%eax
  800b3c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	ff 75 0c             	pushl  0xc(%ebp)
  800b45:	6a 78                	push   $0x78
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	ff d0                	call   *%eax
  800b4c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b52:	83 c0 04             	add    $0x4,%eax
  800b55:	89 45 14             	mov    %eax,0x14(%ebp)
  800b58:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5b:	83 e8 04             	sub    $0x4,%eax
  800b5e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b71:	eb 1f                	jmp    800b92 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	ff 75 e8             	pushl  -0x18(%ebp)
  800b79:	8d 45 14             	lea    0x14(%ebp),%eax
  800b7c:	50                   	push   %eax
  800b7d:	e8 e7 fb ff ff       	call   800769 <getuint>
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b92:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b99:	83 ec 04             	sub    $0x4,%esp
  800b9c:	52                   	push   %edx
  800b9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ba0:	50                   	push   %eax
  800ba1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	ff 75 08             	pushl  0x8(%ebp)
  800bad:	e8 00 fb ff ff       	call   8006b2 <printnum>
  800bb2:	83 c4 20             	add    $0x20,%esp
			break;
  800bb5:	eb 46                	jmp    800bfd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	53                   	push   %ebx
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	ff d0                	call   *%eax
  800bc3:	83 c4 10             	add    $0x10,%esp
			break;
  800bc6:	eb 35                	jmp    800bfd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bc8:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800bcf:	eb 2c                	jmp    800bfd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bd1:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800bd8:	eb 23                	jmp    800bfd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	6a 25                	push   $0x25
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	ff d0                	call   *%eax
  800be7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bea:	ff 4d 10             	decl   0x10(%ebp)
  800bed:	eb 03                	jmp    800bf2 <vprintfmt+0x3c3>
  800bef:	ff 4d 10             	decl   0x10(%ebp)
  800bf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf5:	48                   	dec    %eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	3c 25                	cmp    $0x25,%al
  800bfa:	75 f3                	jne    800bef <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bfc:	90                   	nop
		}
	}
  800bfd:	e9 35 fc ff ff       	jmp    800837 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c10:	8d 45 10             	lea    0x10(%ebp),%eax
  800c13:	83 c0 04             	add    $0x4,%eax
  800c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c1f:	50                   	push   %eax
  800c20:	ff 75 0c             	pushl  0xc(%ebp)
  800c23:	ff 75 08             	pushl  0x8(%ebp)
  800c26:	e8 04 fc ff ff       	call   80082f <vprintfmt>
  800c2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c2e:	90                   	nop
  800c2f:	c9                   	leave  
  800c30:	c3                   	ret    

00800c31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c37:	8b 40 08             	mov    0x8(%eax),%eax
  800c3a:	8d 50 01             	lea    0x1(%eax),%edx
  800c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c46:	8b 10                	mov    (%eax),%edx
  800c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4b:	8b 40 04             	mov    0x4(%eax),%eax
  800c4e:	39 c2                	cmp    %eax,%edx
  800c50:	73 12                	jae    800c64 <sprintputch+0x33>
		*b->buf++ = ch;
  800c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c55:	8b 00                	mov    (%eax),%eax
  800c57:	8d 48 01             	lea    0x1(%eax),%ecx
  800c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5d:	89 0a                	mov    %ecx,(%edx)
  800c5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c62:	88 10                	mov    %dl,(%eax)
}
  800c64:	90                   	nop
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	01 d0                	add    %edx,%eax
  800c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c8c:	74 06                	je     800c94 <vsnprintf+0x2d>
  800c8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c92:	7f 07                	jg     800c9b <vsnprintf+0x34>
		return -E_INVAL;
  800c94:	b8 03 00 00 00       	mov    $0x3,%eax
  800c99:	eb 20                	jmp    800cbb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c9b:	ff 75 14             	pushl  0x14(%ebp)
  800c9e:	ff 75 10             	pushl  0x10(%ebp)
  800ca1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ca4:	50                   	push   %eax
  800ca5:	68 31 0c 80 00       	push   $0x800c31
  800caa:	e8 80 fb ff ff       	call   80082f <vprintfmt>
  800caf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ccc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccf:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd2:	50                   	push   %eax
  800cd3:	ff 75 0c             	pushl  0xc(%ebp)
  800cd6:	ff 75 08             	pushl  0x8(%ebp)
  800cd9:	e8 89 ff ff ff       	call   800c67 <vsnprintf>
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf6:	eb 06                	jmp    800cfe <strlen+0x15>
		n++;
  800cf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	75 f1                	jne    800cf8 <strlen+0xf>
		n++;
	return n;
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0a:	c9                   	leave  
  800d0b:	c3                   	ret    

00800d0c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d19:	eb 09                	jmp    800d24 <strnlen+0x18>
		n++;
  800d1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d1e:	ff 45 08             	incl   0x8(%ebp)
  800d21:	ff 4d 0c             	decl   0xc(%ebp)
  800d24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d28:	74 09                	je     800d33 <strnlen+0x27>
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	84 c0                	test   %al,%al
  800d31:	75 e8                	jne    800d1b <strnlen+0xf>
		n++;
	return n;
  800d33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d44:	90                   	nop
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8d 50 01             	lea    0x1(%eax),%edx
  800d4b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d51:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d54:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d57:	8a 12                	mov    (%edx),%dl
  800d59:	88 10                	mov    %dl,(%eax)
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	84 c0                	test   %al,%al
  800d5f:	75 e4                	jne    800d45 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    

00800d66 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d79:	eb 1f                	jmp    800d9a <strncpy+0x34>
		*dst++ = *src;
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8d 50 01             	lea    0x1(%eax),%edx
  800d81:	89 55 08             	mov    %edx,0x8(%ebp)
  800d84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d87:	8a 12                	mov    (%edx),%dl
  800d89:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	84 c0                	test   %al,%al
  800d92:	74 03                	je     800d97 <strncpy+0x31>
			src++;
  800d94:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d97:	ff 45 fc             	incl   -0x4(%ebp)
  800d9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da0:	72 d9                	jb     800d7b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800da2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800db3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db7:	74 30                	je     800de9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800db9:	eb 16                	jmp    800dd1 <strlcpy+0x2a>
			*dst++ = *src++;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8d 50 01             	lea    0x1(%eax),%edx
  800dc1:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dcd:	8a 12                	mov    (%edx),%dl
  800dcf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dd1:	ff 4d 10             	decl   0x10(%ebp)
  800dd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd8:	74 09                	je     800de3 <strlcpy+0x3c>
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	84 c0                	test   %al,%al
  800de1:	75 d8                	jne    800dbb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800def:	29 c2                	sub    %eax,%edx
  800df1:	89 d0                	mov    %edx,%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800df8:	eb 06                	jmp    800e00 <strcmp+0xb>
		p++, q++;
  800dfa:	ff 45 08             	incl   0x8(%ebp)
  800dfd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	84 c0                	test   %al,%al
  800e07:	74 0e                	je     800e17 <strcmp+0x22>
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 10                	mov    (%eax),%dl
  800e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	38 c2                	cmp    %al,%dl
  800e15:	74 e3                	je     800dfa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 d0             	movzbl %al,%edx
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f b6 c0             	movzbl %al,%eax
  800e27:	29 c2                	sub    %eax,%edx
  800e29:	89 d0                	mov    %edx,%eax
}
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    

00800e2d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e30:	eb 09                	jmp    800e3b <strncmp+0xe>
		n--, p++, q++;
  800e32:	ff 4d 10             	decl   0x10(%ebp)
  800e35:	ff 45 08             	incl   0x8(%ebp)
  800e38:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3f:	74 17                	je     800e58 <strncmp+0x2b>
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	74 0e                	je     800e58 <strncmp+0x2b>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	38 c2                	cmp    %al,%dl
  800e56:	74 da                	je     800e32 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5c:	75 07                	jne    800e65 <strncmp+0x38>
		return 0;
  800e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e63:	eb 14                	jmp    800e79 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f b6 d0             	movzbl %al,%edx
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	0f b6 c0             	movzbl %al,%eax
  800e75:	29 c2                	sub    %eax,%edx
  800e77:	89 d0                	mov    %edx,%eax
}
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	83 ec 04             	sub    $0x4,%esp
  800e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e84:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e87:	eb 12                	jmp    800e9b <strchr+0x20>
		if (*s == c)
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e91:	75 05                	jne    800e98 <strchr+0x1d>
			return (char *) s;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	eb 11                	jmp    800ea9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e98:	ff 45 08             	incl   0x8(%ebp)
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8a 00                	mov    (%eax),%al
  800ea0:	84 c0                	test   %al,%al
  800ea2:	75 e5                	jne    800e89 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ea4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea9:	c9                   	leave  
  800eaa:	c3                   	ret    

00800eab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	83 ec 04             	sub    $0x4,%esp
  800eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eb7:	eb 0d                	jmp    800ec6 <strfind+0x1b>
		if (*s == c)
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec1:	74 0e                	je     800ed1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ec3:	ff 45 08             	incl   0x8(%ebp)
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	84 c0                	test   %al,%al
  800ecd:	75 ea                	jne    800eb9 <strfind+0xe>
  800ecf:	eb 01                	jmp    800ed2 <strfind+0x27>
		if (*s == c)
			break;
  800ed1:	90                   	nop
	return (char *) s;
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed5:	c9                   	leave  
  800ed6:	c3                   	ret    

00800ed7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ee9:	eb 0e                	jmp    800ef9 <memset+0x22>
		*p++ = c;
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	8d 50 01             	lea    0x1(%eax),%edx
  800ef1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ef4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ef9:	ff 4d f8             	decl   -0x8(%ebp)
  800efc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f00:	79 e9                	jns    800eeb <memset+0x14>
		*p++ = c;

	return v;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f19:	eb 16                	jmp    800f31 <memcpy+0x2a>
		*d++ = *s++;
  800f1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1e:	8d 50 01             	lea    0x1(%eax),%edx
  800f21:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f24:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f2d:	8a 12                	mov    (%edx),%dl
  800f2f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f31:	8b 45 10             	mov    0x10(%ebp),%eax
  800f34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f37:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	75 dd                	jne    800f1b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f5b:	73 50                	jae    800fad <memmove+0x6a>
  800f5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	01 d0                	add    %edx,%eax
  800f65:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f68:	76 43                	jbe    800fad <memmove+0x6a>
		s += n;
  800f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f76:	eb 10                	jmp    800f88 <memmove+0x45>
			*--d = *--s;
  800f78:	ff 4d f8             	decl   -0x8(%ebp)
  800f7b:	ff 4d fc             	decl   -0x4(%ebp)
  800f7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f81:	8a 10                	mov    (%eax),%dl
  800f83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f86:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f91:	85 c0                	test   %eax,%eax
  800f93:	75 e3                	jne    800f78 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f95:	eb 23                	jmp    800fba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fa9:	8a 12                	mov    (%edx),%dl
  800fab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fad:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	75 dd                	jne    800f97 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbd:	c9                   	leave  
  800fbe:	c3                   	ret    

00800fbf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fd1:	eb 2a                	jmp    800ffd <memcmp+0x3e>
		if (*s1 != *s2)
  800fd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd6:	8a 10                	mov    (%eax),%dl
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	38 c2                	cmp    %al,%dl
  800fdf:	74 16                	je     800ff7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fe1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f b6 d0             	movzbl %al,%edx
  800fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f b6 c0             	movzbl %al,%eax
  800ff1:	29 c2                	sub    %eax,%edx
  800ff3:	89 d0                	mov    %edx,%eax
  800ff5:	eb 18                	jmp    80100f <memcmp+0x50>
		s1++, s2++;
  800ff7:	ff 45 fc             	incl   -0x4(%ebp)
  800ffa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  801000:	8d 50 ff             	lea    -0x1(%eax),%edx
  801003:	89 55 10             	mov    %edx,0x10(%ebp)
  801006:	85 c0                	test   %eax,%eax
  801008:	75 c9                	jne    800fd3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80100a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801017:	8b 55 08             	mov    0x8(%ebp),%edx
  80101a:	8b 45 10             	mov    0x10(%ebp),%eax
  80101d:	01 d0                	add    %edx,%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801022:	eb 15                	jmp    801039 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	0f b6 d0             	movzbl %al,%edx
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	39 c2                	cmp    %eax,%edx
  801034:	74 0d                	je     801043 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801036:	ff 45 08             	incl   0x8(%ebp)
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80103f:	72 e3                	jb     801024 <memfind+0x13>
  801041:	eb 01                	jmp    801044 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801043:	90                   	nop
	return (void *) s;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801047:	c9                   	leave  
  801048:	c3                   	ret    

00801049 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80104f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801056:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80105d:	eb 03                	jmp    801062 <strtol+0x19>
		s++;
  80105f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 20                	cmp    $0x20,%al
  801069:	74 f4                	je     80105f <strtol+0x16>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 09                	cmp    $0x9,%al
  801072:	74 eb                	je     80105f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 2b                	cmp    $0x2b,%al
  80107b:	75 05                	jne    801082 <strtol+0x39>
		s++;
  80107d:	ff 45 08             	incl   0x8(%ebp)
  801080:	eb 13                	jmp    801095 <strtol+0x4c>
	else if (*s == '-')
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 2d                	cmp    $0x2d,%al
  801089:	75 0a                	jne    801095 <strtol+0x4c>
		s++, neg = 1;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801095:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801099:	74 06                	je     8010a1 <strtol+0x58>
  80109b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80109f:	75 20                	jne    8010c1 <strtol+0x78>
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	3c 30                	cmp    $0x30,%al
  8010a8:	75 17                	jne    8010c1 <strtol+0x78>
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	40                   	inc    %eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 78                	cmp    $0x78,%al
  8010b2:	75 0d                	jne    8010c1 <strtol+0x78>
		s += 2, base = 16;
  8010b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010bf:	eb 28                	jmp    8010e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c5:	75 15                	jne    8010dc <strtol+0x93>
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	3c 30                	cmp    $0x30,%al
  8010ce:	75 0c                	jne    8010dc <strtol+0x93>
		s++, base = 8;
  8010d0:	ff 45 08             	incl   0x8(%ebp)
  8010d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010da:	eb 0d                	jmp    8010e9 <strtol+0xa0>
	else if (base == 0)
  8010dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e0:	75 07                	jne    8010e9 <strtol+0xa0>
		base = 10;
  8010e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	3c 2f                	cmp    $0x2f,%al
  8010f0:	7e 19                	jle    80110b <strtol+0xc2>
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 39                	cmp    $0x39,%al
  8010f9:	7f 10                	jg     80110b <strtol+0xc2>
			dig = *s - '0';
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	0f be c0             	movsbl %al,%eax
  801103:	83 e8 30             	sub    $0x30,%eax
  801106:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801109:	eb 42                	jmp    80114d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	3c 60                	cmp    $0x60,%al
  801112:	7e 19                	jle    80112d <strtol+0xe4>
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	3c 7a                	cmp    $0x7a,%al
  80111b:	7f 10                	jg     80112d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	0f be c0             	movsbl %al,%eax
  801125:	83 e8 57             	sub    $0x57,%eax
  801128:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80112b:	eb 20                	jmp    80114d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8a 00                	mov    (%eax),%al
  801132:	3c 40                	cmp    $0x40,%al
  801134:	7e 39                	jle    80116f <strtol+0x126>
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	3c 5a                	cmp    $0x5a,%al
  80113d:	7f 30                	jg     80116f <strtol+0x126>
			dig = *s - 'A' + 10;
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	0f be c0             	movsbl %al,%eax
  801147:	83 e8 37             	sub    $0x37,%eax
  80114a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80114d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801150:	3b 45 10             	cmp    0x10(%ebp),%eax
  801153:	7d 19                	jge    80116e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801155:	ff 45 08             	incl   0x8(%ebp)
  801158:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80115f:	89 c2                	mov    %eax,%edx
  801161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801169:	e9 7b ff ff ff       	jmp    8010e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80116e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80116f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801173:	74 08                	je     80117d <strtol+0x134>
		*endptr = (char *) s;
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	8b 55 08             	mov    0x8(%ebp),%edx
  80117b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80117d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801181:	74 07                	je     80118a <strtol+0x141>
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	f7 d8                	neg    %eax
  801188:	eb 03                	jmp    80118d <strtol+0x144>
  80118a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <ltostr>:

void
ltostr(long value, char *str)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801195:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a7:	79 13                	jns    8011bc <ltostr+0x2d>
	{
		neg = 1;
  8011a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011c4:	99                   	cltd   
  8011c5:	f7 f9                	idiv   %ecx
  8011c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	8d 50 01             	lea    0x1(%eax),%edx
  8011d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011d3:	89 c2                	mov    %eax,%edx
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	01 d0                	add    %edx,%eax
  8011da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011dd:	83 c2 30             	add    $0x30,%edx
  8011e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ea:	f7 e9                	imul   %ecx
  8011ec:	c1 fa 02             	sar    $0x2,%edx
  8011ef:	89 c8                	mov    %ecx,%eax
  8011f1:	c1 f8 1f             	sar    $0x1f,%eax
  8011f4:	29 c2                	sub    %eax,%edx
  8011f6:	89 d0                	mov    %edx,%eax
  8011f8:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ff:	75 bb                	jne    8011bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801201:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801208:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120b:	48                   	dec    %eax
  80120c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80120f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801213:	74 3d                	je     801252 <ltostr+0xc3>
		start = 1 ;
  801215:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80121c:	eb 34                	jmp    801252 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80121e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	01 d0                	add    %edx,%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80122b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801231:	01 c2                	add    %eax,%edx
  801233:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	01 c8                	add    %ecx,%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80123f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801242:	8b 45 0c             	mov    0xc(%ebp),%eax
  801245:	01 c2                	add    %eax,%edx
  801247:	8a 45 eb             	mov    -0x15(%ebp),%al
  80124a:	88 02                	mov    %al,(%edx)
		start++ ;
  80124c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80124f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801255:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801258:	7c c4                	jl     80121e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80125a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 d0                	add    %edx,%eax
  801262:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801265:	90                   	nop
  801266:	c9                   	leave  
  801267:	c3                   	ret    

00801268 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80126e:	ff 75 08             	pushl  0x8(%ebp)
  801271:	e8 73 fa ff ff       	call   800ce9 <strlen>
  801276:	83 c4 04             	add    $0x4,%esp
  801279:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80127c:	ff 75 0c             	pushl  0xc(%ebp)
  80127f:	e8 65 fa ff ff       	call   800ce9 <strlen>
  801284:	83 c4 04             	add    $0x4,%esp
  801287:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80128a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801291:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801298:	eb 17                	jmp    8012b1 <strcconcat+0x49>
		final[s] = str1[s] ;
  80129a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 c2                	add    %eax,%edx
  8012a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	01 c8                	add    %ecx,%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ae:	ff 45 fc             	incl   -0x4(%ebp)
  8012b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b7:	7c e1                	jl     80129a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c7:	eb 1f                	jmp    8012e8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cc:	8d 50 01             	lea    0x1(%eax),%edx
  8012cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012d2:	89 c2                	mov    %eax,%edx
  8012d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d7:	01 c2                	add    %eax,%edx
  8012d9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	01 c8                	add    %ecx,%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e5:	ff 45 f8             	incl   -0x8(%ebp)
  8012e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ee:	7c d9                	jl     8012c9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	01 d0                	add    %edx,%eax
  8012f8:	c6 00 00             	movb   $0x0,(%eax)
}
  8012fb:	90                   	nop
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801301:	8b 45 14             	mov    0x14(%ebp),%eax
  801304:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80130a:	8b 45 14             	mov    0x14(%ebp),%eax
  80130d:	8b 00                	mov    (%eax),%eax
  80130f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	01 d0                	add    %edx,%eax
  80131b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801321:	eb 0c                	jmp    80132f <strsplit+0x31>
			*string++ = 0;
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8d 50 01             	lea    0x1(%eax),%edx
  801329:	89 55 08             	mov    %edx,0x8(%ebp)
  80132c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8a 00                	mov    (%eax),%al
  801334:	84 c0                	test   %al,%al
  801336:	74 18                	je     801350 <strsplit+0x52>
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	0f be c0             	movsbl %al,%eax
  801340:	50                   	push   %eax
  801341:	ff 75 0c             	pushl  0xc(%ebp)
  801344:	e8 32 fb ff ff       	call   800e7b <strchr>
  801349:	83 c4 08             	add    $0x8,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	75 d3                	jne    801323 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	8a 00                	mov    (%eax),%al
  801355:	84 c0                	test   %al,%al
  801357:	74 5a                	je     8013b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801359:	8b 45 14             	mov    0x14(%ebp),%eax
  80135c:	8b 00                	mov    (%eax),%eax
  80135e:	83 f8 0f             	cmp    $0xf,%eax
  801361:	75 07                	jne    80136a <strsplit+0x6c>
		{
			return 0;
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
  801368:	eb 66                	jmp    8013d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80136a:	8b 45 14             	mov    0x14(%ebp),%eax
  80136d:	8b 00                	mov    (%eax),%eax
  80136f:	8d 48 01             	lea    0x1(%eax),%ecx
  801372:	8b 55 14             	mov    0x14(%ebp),%edx
  801375:	89 0a                	mov    %ecx,(%edx)
  801377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 c2                	add    %eax,%edx
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801388:	eb 03                	jmp    80138d <strsplit+0x8f>
			string++;
  80138a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	84 c0                	test   %al,%al
  801394:	74 8b                	je     801321 <strsplit+0x23>
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	0f be c0             	movsbl %al,%eax
  80139e:	50                   	push   %eax
  80139f:	ff 75 0c             	pushl  0xc(%ebp)
  8013a2:	e8 d4 fa ff ff       	call   800e7b <strchr>
  8013a7:	83 c4 08             	add    $0x8,%esp
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	74 dc                	je     80138a <strsplit+0x8c>
			string++;
	}
  8013ae:	e9 6e ff ff ff       	jmp    801321 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	8b 00                	mov    (%eax),%eax
  8013b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	68 48 43 80 00       	push   $0x804348
  8013e0:	68 3f 01 00 00       	push   $0x13f
  8013e5:	68 6a 43 80 00       	push   $0x80436a
  8013ea:	e8 a9 ef ff ff       	call   800398 <_panic>

008013ef <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8013f5:	83 ec 0c             	sub    $0xc,%esp
  8013f8:	ff 75 08             	pushl  0x8(%ebp)
  8013fb:	e8 35 0a 00 00       	call   801e35 <sys_sbrk>
  801400:	83 c4 10             	add    $0x10,%esp
}
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80140b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80140f:	75 0a                	jne    80141b <malloc+0x16>
  801411:	b8 00 00 00 00       	mov    $0x0,%eax
  801416:	e9 07 02 00 00       	jmp    801622 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  80141b:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801422:	8b 55 08             	mov    0x8(%ebp),%edx
  801425:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801428:	01 d0                	add    %edx,%eax
  80142a:	48                   	dec    %eax
  80142b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80142e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801431:	ba 00 00 00 00       	mov    $0x0,%edx
  801436:	f7 75 dc             	divl   -0x24(%ebp)
  801439:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80143c:	29 d0                	sub    %edx,%eax
  80143e:	c1 e8 0c             	shr    $0xc,%eax
  801441:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801444:	a1 20 50 80 00       	mov    0x805020,%eax
  801449:	8b 40 78             	mov    0x78(%eax),%eax
  80144c:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801451:	29 c2                	sub    %eax,%edx
  801453:	89 d0                	mov    %edx,%eax
  801455:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801458:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80145b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801460:	c1 e8 0c             	shr    $0xc,%eax
  801463:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801466:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80146d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801474:	77 42                	ja     8014b8 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801476:	e8 3e 08 00 00       	call   801cb9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80147b:	85 c0                	test   %eax,%eax
  80147d:	74 16                	je     801495 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	e8 7e 0d 00 00       	call   802208 <alloc_block_FF>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801490:	e9 8a 01 00 00       	jmp    80161f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801495:	e8 50 08 00 00       	call   801cea <sys_isUHeapPlacementStrategyBESTFIT>
  80149a:	85 c0                	test   %eax,%eax
  80149c:	0f 84 7d 01 00 00    	je     80161f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 17 12 00 00       	call   8026c4 <alloc_block_BF>
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b3:	e9 67 01 00 00       	jmp    80161f <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8014b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014bb:	48                   	dec    %eax
  8014bc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8014bf:	0f 86 53 01 00 00    	jbe    801618 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8014c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8014ca:	8b 40 78             	mov    0x78(%eax),%eax
  8014cd:	05 00 10 00 00       	add    $0x1000,%eax
  8014d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8014d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8014dc:	e9 de 00 00 00       	jmp    8015bf <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8014e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8014e6:	8b 40 78             	mov    0x78(%eax),%eax
  8014e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ec:	29 c2                	sub    %eax,%edx
  8014ee:	89 d0                	mov    %edx,%eax
  8014f0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014f5:	c1 e8 0c             	shr    $0xc,%eax
  8014f8:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8014ff:	85 c0                	test   %eax,%eax
  801501:	0f 85 ab 00 00 00    	jne    8015b2 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150a:	05 00 10 00 00       	add    $0x1000,%eax
  80150f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801512:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801519:	eb 47                	jmp    801562 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  80151b:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801522:	76 0a                	jbe    80152e <malloc+0x129>
  801524:	b8 00 00 00 00       	mov    $0x0,%eax
  801529:	e9 f4 00 00 00       	jmp    801622 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  80152e:	a1 20 50 80 00       	mov    0x805020,%eax
  801533:	8b 40 78             	mov    0x78(%eax),%eax
  801536:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801539:	29 c2                	sub    %eax,%edx
  80153b:	89 d0                	mov    %edx,%eax
  80153d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801542:	c1 e8 0c             	shr    $0xc,%eax
  801545:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80154c:	85 c0                	test   %eax,%eax
  80154e:	74 08                	je     801558 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801550:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801553:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801556:	eb 5a                	jmp    8015b2 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801558:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80155f:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801562:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801565:	48                   	dec    %eax
  801566:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801569:	77 b0                	ja     80151b <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  80156b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801572:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801579:	eb 2f                	jmp    8015aa <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  80157b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157e:	c1 e0 0c             	shl    $0xc,%eax
  801581:	89 c2                	mov    %eax,%edx
  801583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801586:	01 c2                	add    %eax,%edx
  801588:	a1 20 50 80 00       	mov    0x805020,%eax
  80158d:	8b 40 78             	mov    0x78(%eax),%eax
  801590:	29 c2                	sub    %eax,%edx
  801592:	89 d0                	mov    %edx,%eax
  801594:	2d 00 10 00 00       	sub    $0x1000,%eax
  801599:	c1 e8 0c             	shr    $0xc,%eax
  80159c:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  8015a3:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8015a7:	ff 45 e0             	incl   -0x20(%ebp)
  8015aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ad:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8015b0:	72 c9                	jb     80157b <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8015b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015b6:	75 16                	jne    8015ce <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8015b8:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8015bf:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8015c6:	0f 86 15 ff ff ff    	jbe    8014e1 <malloc+0xdc>
  8015cc:	eb 01                	jmp    8015cf <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8015ce:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8015cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015d3:	75 07                	jne    8015dc <malloc+0x1d7>
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015da:	eb 46                	jmp    801622 <malloc+0x21d>
		ptr = (void*)i;
  8015dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8015e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8015e7:	8b 40 78             	mov    0x78(%eax),%eax
  8015ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ed:	29 c2                	sub    %eax,%edx
  8015ef:	89 d0                	mov    %edx,%eax
  8015f1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015f6:	c1 e8 0c             	shr    $0xc,%eax
  8015f9:	89 c2                	mov    %eax,%edx
  8015fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015fe:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801605:	83 ec 08             	sub    $0x8,%esp
  801608:	ff 75 08             	pushl  0x8(%ebp)
  80160b:	ff 75 f0             	pushl  -0x10(%ebp)
  80160e:	e8 59 08 00 00       	call   801e6c <sys_allocate_user_mem>
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	eb 07                	jmp    80161f <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801618:	b8 00 00 00 00       	mov    $0x0,%eax
  80161d:	eb 03                	jmp    801622 <malloc+0x21d>
	}
	return ptr;
  80161f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  80162a:	a1 20 50 80 00       	mov    0x805020,%eax
  80162f:	8b 40 78             	mov    0x78(%eax),%eax
  801632:	05 00 10 00 00       	add    $0x1000,%eax
  801637:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  80163a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801641:	a1 20 50 80 00       	mov    0x805020,%eax
  801646:	8b 50 78             	mov    0x78(%eax),%edx
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	39 c2                	cmp    %eax,%edx
  80164e:	76 24                	jbe    801674 <free+0x50>
		size = get_block_size(va);
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	ff 75 08             	pushl  0x8(%ebp)
  801656:	e8 2d 08 00 00       	call   801e88 <get_block_size>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	e8 60 1a 00 00       	call   8030cc <free_block>
  80166c:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80166f:	e9 ac 00 00 00       	jmp    801720 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80167a:	0f 82 89 00 00 00    	jb     801709 <free+0xe5>
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801688:	77 7f                	ja     801709 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  80168a:	8b 55 08             	mov    0x8(%ebp),%edx
  80168d:	a1 20 50 80 00       	mov    0x805020,%eax
  801692:	8b 40 78             	mov    0x78(%eax),%eax
  801695:	29 c2                	sub    %eax,%edx
  801697:	89 d0                	mov    %edx,%eax
  801699:	2d 00 10 00 00       	sub    $0x1000,%eax
  80169e:	c1 e8 0c             	shr    $0xc,%eax
  8016a1:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8016a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8016ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ae:	c1 e0 0c             	shl    $0xc,%eax
  8016b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8016b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016bb:	eb 2f                	jmp    8016ec <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c0:	c1 e0 0c             	shl    $0xc,%eax
  8016c3:	89 c2                	mov    %eax,%edx
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	01 c2                	add    %eax,%edx
  8016ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8016cf:	8b 40 78             	mov    0x78(%eax),%eax
  8016d2:	29 c2                	sub    %eax,%edx
  8016d4:	89 d0                	mov    %edx,%eax
  8016d6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016db:	c1 e8 0c             	shr    $0xc,%eax
  8016de:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  8016e5:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8016e9:	ff 45 f4             	incl   -0xc(%ebp)
  8016ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8016f2:	72 c9                	jb     8016bd <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	83 ec 08             	sub    $0x8,%esp
  8016fa:	ff 75 ec             	pushl  -0x14(%ebp)
  8016fd:	50                   	push   %eax
  8016fe:	e8 4d 07 00 00       	call   801e50 <sys_free_user_mem>
  801703:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801706:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801707:	eb 17                	jmp    801720 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801709:	83 ec 04             	sub    $0x4,%esp
  80170c:	68 78 43 80 00       	push   $0x804378
  801711:	68 84 00 00 00       	push   $0x84
  801716:	68 a2 43 80 00       	push   $0x8043a2
  80171b:	e8 78 ec ff ff       	call   800398 <_panic>
	}
}
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 28             	sub    $0x28,%esp
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80172e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801732:	75 07                	jne    80173b <smalloc+0x19>
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
  801739:	eb 74                	jmp    8017af <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80173b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801741:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801748:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174e:	39 d0                	cmp    %edx,%eax
  801750:	73 02                	jae    801754 <smalloc+0x32>
  801752:	89 d0                	mov    %edx,%eax
  801754:	83 ec 0c             	sub    $0xc,%esp
  801757:	50                   	push   %eax
  801758:	e8 a8 fc ff ff       	call   801405 <malloc>
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801763:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801767:	75 07                	jne    801770 <smalloc+0x4e>
  801769:	b8 00 00 00 00       	mov    $0x0,%eax
  80176e:	eb 3f                	jmp    8017af <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801770:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801774:	ff 75 ec             	pushl  -0x14(%ebp)
  801777:	50                   	push   %eax
  801778:	ff 75 0c             	pushl  0xc(%ebp)
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	e8 d4 02 00 00       	call   801a57 <sys_createSharedObject>
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801789:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80178d:	74 06                	je     801795 <smalloc+0x73>
  80178f:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801793:	75 07                	jne    80179c <smalloc+0x7a>
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
  80179a:	eb 13                	jmp    8017af <smalloc+0x8d>
	 cprintf("153\n");
  80179c:	83 ec 0c             	sub    $0xc,%esp
  80179f:	68 ae 43 80 00       	push   $0x8043ae
  8017a4:	e8 ac ee ff ff       	call   800655 <cprintf>
  8017a9:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	68 b4 43 80 00       	push   $0x8043b4
  8017bf:	68 a4 00 00 00       	push   $0xa4
  8017c4:	68 a2 43 80 00       	push   $0x8043a2
  8017c9:	e8 ca eb ff ff       	call   800398 <_panic>

008017ce <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	68 d8 43 80 00       	push   $0x8043d8
  8017dc:	68 bc 00 00 00       	push   $0xbc
  8017e1:	68 a2 43 80 00       	push   $0x8043a2
  8017e6:	e8 ad eb ff ff       	call   800398 <_panic>

008017eb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	68 fc 43 80 00       	push   $0x8043fc
  8017f9:	68 d3 00 00 00       	push   $0xd3
  8017fe:	68 a2 43 80 00       	push   $0x8043a2
  801803:	e8 90 eb ff ff       	call   800398 <_panic>

00801808 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	68 22 44 80 00       	push   $0x804422
  801816:	68 df 00 00 00       	push   $0xdf
  80181b:	68 a2 43 80 00       	push   $0x8043a2
  801820:	e8 73 eb ff ff       	call   800398 <_panic>

00801825 <shrink>:

}
void shrink(uint32 newSize)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	68 22 44 80 00       	push   $0x804422
  801833:	68 e4 00 00 00       	push   $0xe4
  801838:	68 a2 43 80 00       	push   $0x8043a2
  80183d:	e8 56 eb ff ff       	call   800398 <_panic>

00801842 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	68 22 44 80 00       	push   $0x804422
  801850:	68 e9 00 00 00       	push   $0xe9
  801855:	68 a2 43 80 00       	push   $0x8043a2
  80185a:	e8 39 eb ff ff       	call   800398 <_panic>

0080185f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	57                   	push   %edi
  801863:	56                   	push   %esi
  801864:	53                   	push   %ebx
  801865:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801871:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801874:	8b 7d 18             	mov    0x18(%ebp),%edi
  801877:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80187a:	cd 30                	int    $0x30
  80187c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80187f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	5b                   	pop    %ebx
  801886:	5e                   	pop    %esi
  801887:	5f                   	pop    %edi
  801888:	5d                   	pop    %ebp
  801889:	c3                   	ret    

0080188a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	83 ec 04             	sub    $0x4,%esp
  801890:	8b 45 10             	mov    0x10(%ebp),%eax
  801893:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801896:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	52                   	push   %edx
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	50                   	push   %eax
  8018a6:	6a 00                	push   $0x0
  8018a8:	e8 b2 ff ff ff       	call   80185f <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	90                   	nop
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 02                	push   $0x2
  8018c2:	e8 98 ff ff ff       	call   80185f <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 03                	push   $0x3
  8018db:	e8 7f ff ff ff       	call   80185f <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	90                   	nop
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 04                	push   $0x4
  8018f5:	e8 65 ff ff ff       	call   80185f <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	90                   	nop
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	52                   	push   %edx
  801910:	50                   	push   %eax
  801911:	6a 08                	push   $0x8
  801913:	e8 47 ff ff ff       	call   80185f <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	56                   	push   %esi
  801921:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801922:	8b 75 18             	mov    0x18(%ebp),%esi
  801925:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801928:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	56                   	push   %esi
  801932:	53                   	push   %ebx
  801933:	51                   	push   %ecx
  801934:	52                   	push   %edx
  801935:	50                   	push   %eax
  801936:	6a 09                	push   $0x9
  801938:	e8 22 ff ff ff       	call   80185f <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801943:	5b                   	pop    %ebx
  801944:	5e                   	pop    %esi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 0a                	push   $0xa
  80195a:	e8 00 ff ff ff       	call   80185f <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	6a 0b                	push   $0xb
  801975:	e8 e5 fe ff ff       	call   80185f <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 0c                	push   $0xc
  80198e:	e8 cc fe ff ff       	call   80185f <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 0d                	push   $0xd
  8019a7:	e8 b3 fe ff ff       	call   80185f <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 0e                	push   $0xe
  8019c0:	e8 9a fe ff ff       	call   80185f <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 0f                	push   $0xf
  8019d9:	e8 81 fe ff ff       	call   80185f <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	6a 10                	push   $0x10
  8019f3:	e8 67 fe ff ff       	call   80185f <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 11                	push   $0x11
  801a0c:	e8 4e fe ff ff       	call   80185f <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	90                   	nop
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a23:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	50                   	push   %eax
  801a30:	6a 01                	push   $0x1
  801a32:	e8 28 fe ff ff       	call   80185f <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	90                   	nop
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 14                	push   $0x14
  801a4c:	e8 0e fe ff ff       	call   80185f <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	90                   	nop
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 04             	sub    $0x4,%esp
  801a5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a60:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a63:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a66:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	6a 00                	push   $0x0
  801a6f:	51                   	push   %ecx
  801a70:	52                   	push   %edx
  801a71:	ff 75 0c             	pushl  0xc(%ebp)
  801a74:	50                   	push   %eax
  801a75:	6a 15                	push   $0x15
  801a77:	e8 e3 fd ff ff       	call   80185f <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	52                   	push   %edx
  801a91:	50                   	push   %eax
  801a92:	6a 16                	push   $0x16
  801a94:	e8 c6 fd ff ff       	call   80185f <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aa1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	51                   	push   %ecx
  801aaf:	52                   	push   %edx
  801ab0:	50                   	push   %eax
  801ab1:	6a 17                	push   $0x17
  801ab3:	e8 a7 fd ff ff       	call   80185f <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	52                   	push   %edx
  801acd:	50                   	push   %eax
  801ace:	6a 18                	push   $0x18
  801ad0:	e8 8a fd ff ff       	call   80185f <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	ff 75 14             	pushl  0x14(%ebp)
  801ae5:	ff 75 10             	pushl  0x10(%ebp)
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	50                   	push   %eax
  801aec:	6a 19                	push   $0x19
  801aee:	e8 6c fd ff ff       	call   80185f <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	50                   	push   %eax
  801b07:	6a 1a                	push   $0x1a
  801b09:	e8 51 fd ff ff       	call   80185f <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	90                   	nop
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	50                   	push   %eax
  801b23:	6a 1b                	push   $0x1b
  801b25:	e8 35 fd ff ff       	call   80185f <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 05                	push   $0x5
  801b3e:	e8 1c fd ff ff       	call   80185f <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 06                	push   $0x6
  801b57:	e8 03 fd ff ff       	call   80185f <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 07                	push   $0x7
  801b70:	e8 ea fc ff ff       	call   80185f <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_exit_env>:


void sys_exit_env(void)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 1c                	push   $0x1c
  801b89:	e8 d1 fc ff ff       	call   80185f <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	90                   	nop
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b9a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b9d:	8d 50 04             	lea    0x4(%eax),%edx
  801ba0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	52                   	push   %edx
  801baa:	50                   	push   %eax
  801bab:	6a 1d                	push   $0x1d
  801bad:	e8 ad fc ff ff       	call   80185f <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
	return result;
  801bb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bbe:	89 01                	mov    %eax,(%ecx)
  801bc0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	c9                   	leave  
  801bc7:	c2 04 00             	ret    $0x4

00801bca <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	ff 75 10             	pushl  0x10(%ebp)
  801bd4:	ff 75 0c             	pushl  0xc(%ebp)
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	6a 13                	push   $0x13
  801bdc:	e8 7e fc ff ff       	call   80185f <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
	return ;
  801be4:	90                   	nop
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 1e                	push   $0x1e
  801bf6:	e8 64 fc ff ff       	call   80185f <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c0c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	50                   	push   %eax
  801c19:	6a 1f                	push   $0x1f
  801c1b:	e8 3f fc ff ff       	call   80185f <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
	return ;
  801c23:	90                   	nop
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <rsttst>:
void rsttst()
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 21                	push   $0x21
  801c35:	e8 25 fc ff ff       	call   80185f <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3d:	90                   	nop
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	8b 45 14             	mov    0x14(%ebp),%eax
  801c49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c4c:	8b 55 18             	mov    0x18(%ebp),%edx
  801c4f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c53:	52                   	push   %edx
  801c54:	50                   	push   %eax
  801c55:	ff 75 10             	pushl  0x10(%ebp)
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	6a 20                	push   $0x20
  801c60:	e8 fa fb ff ff       	call   80185f <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
	return ;
  801c68:	90                   	nop
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <chktst>:
void chktst(uint32 n)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	ff 75 08             	pushl  0x8(%ebp)
  801c79:	6a 22                	push   $0x22
  801c7b:	e8 df fb ff ff       	call   80185f <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
	return ;
  801c83:	90                   	nop
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <inctst>:

void inctst()
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 23                	push   $0x23
  801c95:	e8 c5 fb ff ff       	call   80185f <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <gettst>:
uint32 gettst()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 24                	push   $0x24
  801caf:	e8 ab fb ff ff       	call   80185f <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 25                	push   $0x25
  801ccb:	e8 8f fb ff ff       	call   80185f <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
  801cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cd6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cda:	75 07                	jne    801ce3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cdc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce1:	eb 05                	jmp    801ce8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ce3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 25                	push   $0x25
  801cfc:	e8 5e fb ff ff       	call   80185f <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
  801d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d07:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d0b:	75 07                	jne    801d14 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d12:	eb 05                	jmp    801d19 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 25                	push   $0x25
  801d2d:	e8 2d fb ff ff       	call   80185f <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
  801d35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d38:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d3c:	75 07                	jne    801d45 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d43:	eb 05                	jmp    801d4a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 25                	push   $0x25
  801d5e:	e8 fc fa ff ff       	call   80185f <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
  801d66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d69:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d6d:	75 07                	jne    801d76 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d74:	eb 05                	jmp    801d7b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	ff 75 08             	pushl  0x8(%ebp)
  801d8b:	6a 26                	push   $0x26
  801d8d:	e8 cd fa ff ff       	call   80185f <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
	return ;
  801d95:	90                   	nop
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d9c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	6a 00                	push   $0x0
  801daa:	53                   	push   %ebx
  801dab:	51                   	push   %ecx
  801dac:	52                   	push   %edx
  801dad:	50                   	push   %eax
  801dae:	6a 27                	push   $0x27
  801db0:	e8 aa fa ff ff       	call   80185f <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
}
  801db8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	52                   	push   %edx
  801dcd:	50                   	push   %eax
  801dce:	6a 28                	push   $0x28
  801dd0:	e8 8a fa ff ff       	call   80185f <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ddd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	6a 00                	push   $0x0
  801de8:	51                   	push   %ecx
  801de9:	ff 75 10             	pushl  0x10(%ebp)
  801dec:	52                   	push   %edx
  801ded:	50                   	push   %eax
  801dee:	6a 29                	push   $0x29
  801df0:	e8 6a fa ff ff       	call   80185f <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	ff 75 10             	pushl  0x10(%ebp)
  801e04:	ff 75 0c             	pushl  0xc(%ebp)
  801e07:	ff 75 08             	pushl  0x8(%ebp)
  801e0a:	6a 12                	push   $0x12
  801e0c:	e8 4e fa ff ff       	call   80185f <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
	return ;
  801e14:	90                   	nop
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	52                   	push   %edx
  801e27:	50                   	push   %eax
  801e28:	6a 2a                	push   $0x2a
  801e2a:	e8 30 fa ff ff       	call   80185f <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
	return;
  801e32:	90                   	nop
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	50                   	push   %eax
  801e44:	6a 2b                	push   $0x2b
  801e46:	e8 14 fa ff ff       	call   80185f <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	ff 75 0c             	pushl  0xc(%ebp)
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	6a 2c                	push   $0x2c
  801e61:	e8 f9 f9 ff ff       	call   80185f <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
	return;
  801e69:	90                   	nop
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	ff 75 0c             	pushl  0xc(%ebp)
  801e78:	ff 75 08             	pushl  0x8(%ebp)
  801e7b:	6a 2d                	push   $0x2d
  801e7d:	e8 dd f9 ff ff       	call   80185f <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
	return;
  801e85:	90                   	nop
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	83 e8 04             	sub    $0x4,%eax
  801e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e9a:	8b 00                	mov    (%eax),%eax
  801e9c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	83 e8 04             	sub    $0x4,%eax
  801ead:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eb3:	8b 00                	mov    (%eax),%eax
  801eb5:	83 e0 01             	and    $0x1,%eax
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	0f 94 c0             	sete   %al
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ec5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecf:	83 f8 02             	cmp    $0x2,%eax
  801ed2:	74 2b                	je     801eff <alloc_block+0x40>
  801ed4:	83 f8 02             	cmp    $0x2,%eax
  801ed7:	7f 07                	jg     801ee0 <alloc_block+0x21>
  801ed9:	83 f8 01             	cmp    $0x1,%eax
  801edc:	74 0e                	je     801eec <alloc_block+0x2d>
  801ede:	eb 58                	jmp    801f38 <alloc_block+0x79>
  801ee0:	83 f8 03             	cmp    $0x3,%eax
  801ee3:	74 2d                	je     801f12 <alloc_block+0x53>
  801ee5:	83 f8 04             	cmp    $0x4,%eax
  801ee8:	74 3b                	je     801f25 <alloc_block+0x66>
  801eea:	eb 4c                	jmp    801f38 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	ff 75 08             	pushl  0x8(%ebp)
  801ef2:	e8 11 03 00 00       	call   802208 <alloc_block_FF>
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801efd:	eb 4a                	jmp    801f49 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801eff:	83 ec 0c             	sub    $0xc,%esp
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	e8 fa 19 00 00       	call   803904 <alloc_block_NF>
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f10:	eb 37                	jmp    801f49 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f12:	83 ec 0c             	sub    $0xc,%esp
  801f15:	ff 75 08             	pushl  0x8(%ebp)
  801f18:	e8 a7 07 00 00       	call   8026c4 <alloc_block_BF>
  801f1d:	83 c4 10             	add    $0x10,%esp
  801f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f23:	eb 24                	jmp    801f49 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	ff 75 08             	pushl  0x8(%ebp)
  801f2b:	e8 b7 19 00 00       	call   8038e7 <alloc_block_WF>
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f36:	eb 11                	jmp    801f49 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f38:	83 ec 0c             	sub    $0xc,%esp
  801f3b:	68 34 44 80 00       	push   $0x804434
  801f40:	e8 10 e7 ff ff       	call   800655 <cprintf>
  801f45:	83 c4 10             	add    $0x10,%esp
		break;
  801f48:	90                   	nop
	}
	return va;
  801f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	53                   	push   %ebx
  801f52:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	68 54 44 80 00       	push   $0x804454
  801f5d:	e8 f3 e6 ff ff       	call   800655 <cprintf>
  801f62:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	68 7f 44 80 00       	push   $0x80447f
  801f6d:	e8 e3 e6 ff ff       	call   800655 <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7b:	eb 37                	jmp    801fb4 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	ff 75 f4             	pushl  -0xc(%ebp)
  801f83:	e8 19 ff ff ff       	call   801ea1 <is_free_block>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	0f be d8             	movsbl %al,%ebx
  801f8e:	83 ec 0c             	sub    $0xc,%esp
  801f91:	ff 75 f4             	pushl  -0xc(%ebp)
  801f94:	e8 ef fe ff ff       	call   801e88 <get_block_size>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	53                   	push   %ebx
  801fa0:	50                   	push   %eax
  801fa1:	68 97 44 80 00       	push   $0x804497
  801fa6:	e8 aa e6 ff ff       	call   800655 <cprintf>
  801fab:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fae:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb8:	74 07                	je     801fc1 <print_blocks_list+0x73>
  801fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbd:	8b 00                	mov    (%eax),%eax
  801fbf:	eb 05                	jmp    801fc6 <print_blocks_list+0x78>
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc6:	89 45 10             	mov    %eax,0x10(%ebp)
  801fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	75 ad                	jne    801f7d <print_blocks_list+0x2f>
  801fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd4:	75 a7                	jne    801f7d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	68 54 44 80 00       	push   $0x804454
  801fde:	e8 72 e6 ff ff       	call   800655 <cprintf>
  801fe3:	83 c4 10             	add    $0x10,%esp

}
  801fe6:	90                   	nop
  801fe7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff5:	83 e0 01             	and    $0x1,%eax
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	74 03                	je     801fff <initialize_dynamic_allocator+0x13>
  801ffc:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802003:	0f 84 c7 01 00 00    	je     8021d0 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802009:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802010:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802013:	8b 55 08             	mov    0x8(%ebp),%edx
  802016:	8b 45 0c             	mov    0xc(%ebp),%eax
  802019:	01 d0                	add    %edx,%eax
  80201b:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802020:	0f 87 ad 01 00 00    	ja     8021d3 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	85 c0                	test   %eax,%eax
  80202b:	0f 89 a5 01 00 00    	jns    8021d6 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802031:	8b 55 08             	mov    0x8(%ebp),%edx
  802034:	8b 45 0c             	mov    0xc(%ebp),%eax
  802037:	01 d0                	add    %edx,%eax
  802039:	83 e8 04             	sub    $0x4,%eax
  80203c:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802048:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80204d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802050:	e9 87 00 00 00       	jmp    8020dc <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802055:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802059:	75 14                	jne    80206f <initialize_dynamic_allocator+0x83>
  80205b:	83 ec 04             	sub    $0x4,%esp
  80205e:	68 af 44 80 00       	push   $0x8044af
  802063:	6a 79                	push   $0x79
  802065:	68 cd 44 80 00       	push   $0x8044cd
  80206a:	e8 29 e3 ff ff       	call   800398 <_panic>
  80206f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802072:	8b 00                	mov    (%eax),%eax
  802074:	85 c0                	test   %eax,%eax
  802076:	74 10                	je     802088 <initialize_dynamic_allocator+0x9c>
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	8b 00                	mov    (%eax),%eax
  80207d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802080:	8b 52 04             	mov    0x4(%edx),%edx
  802083:	89 50 04             	mov    %edx,0x4(%eax)
  802086:	eb 0b                	jmp    802093 <initialize_dynamic_allocator+0xa7>
  802088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208b:	8b 40 04             	mov    0x4(%eax),%eax
  80208e:	a3 30 50 80 00       	mov    %eax,0x805030
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	8b 40 04             	mov    0x4(%eax),%eax
  802099:	85 c0                	test   %eax,%eax
  80209b:	74 0f                	je     8020ac <initialize_dynamic_allocator+0xc0>
  80209d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a0:	8b 40 04             	mov    0x4(%eax),%eax
  8020a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a6:	8b 12                	mov    (%edx),%edx
  8020a8:	89 10                	mov    %edx,(%eax)
  8020aa:	eb 0a                	jmp    8020b6 <initialize_dynamic_allocator+0xca>
  8020ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020af:	8b 00                	mov    (%eax),%eax
  8020b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8020ce:	48                   	dec    %eax
  8020cf:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8020d4:	a1 34 50 80 00       	mov    0x805034,%eax
  8020d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e0:	74 07                	je     8020e9 <initialize_dynamic_allocator+0xfd>
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 00                	mov    (%eax),%eax
  8020e7:	eb 05                	jmp    8020ee <initialize_dynamic_allocator+0x102>
  8020e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ee:	a3 34 50 80 00       	mov    %eax,0x805034
  8020f3:	a1 34 50 80 00       	mov    0x805034,%eax
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	0f 85 55 ff ff ff    	jne    802055 <initialize_dynamic_allocator+0x69>
  802100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802104:	0f 85 4b ff ff ff    	jne    802055 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802113:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802119:	a1 44 50 80 00       	mov    0x805044,%eax
  80211e:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802123:	a1 40 50 80 00       	mov    0x805040,%eax
  802128:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	83 c0 08             	add    $0x8,%eax
  802134:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	83 c0 04             	add    $0x4,%eax
  80213d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802140:	83 ea 08             	sub    $0x8,%edx
  802143:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802145:	8b 55 0c             	mov    0xc(%ebp),%edx
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	01 d0                	add    %edx,%eax
  80214d:	83 e8 08             	sub    $0x8,%eax
  802150:	8b 55 0c             	mov    0xc(%ebp),%edx
  802153:	83 ea 08             	sub    $0x8,%edx
  802156:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802161:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802164:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80216b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80216f:	75 17                	jne    802188 <initialize_dynamic_allocator+0x19c>
  802171:	83 ec 04             	sub    $0x4,%esp
  802174:	68 e8 44 80 00       	push   $0x8044e8
  802179:	68 90 00 00 00       	push   $0x90
  80217e:	68 cd 44 80 00       	push   $0x8044cd
  802183:	e8 10 e2 ff ff       	call   800398 <_panic>
  802188:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80218e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802191:	89 10                	mov    %edx,(%eax)
  802193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802196:	8b 00                	mov    (%eax),%eax
  802198:	85 c0                	test   %eax,%eax
  80219a:	74 0d                	je     8021a9 <initialize_dynamic_allocator+0x1bd>
  80219c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021a4:	89 50 04             	mov    %edx,0x4(%eax)
  8021a7:	eb 08                	jmp    8021b1 <initialize_dynamic_allocator+0x1c5>
  8021a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8021b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8021c8:	40                   	inc    %eax
  8021c9:	a3 38 50 80 00       	mov    %eax,0x805038
  8021ce:	eb 07                	jmp    8021d7 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8021d0:	90                   	nop
  8021d1:	eb 04                	jmp    8021d7 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8021d3:	90                   	nop
  8021d4:	eb 01                	jmp    8021d7 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8021d6:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021df:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021eb:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	83 e8 04             	sub    $0x4,%eax
  8021f3:	8b 00                	mov    (%eax),%eax
  8021f5:	83 e0 fe             	and    $0xfffffffe,%eax
  8021f8:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	01 c2                	add    %eax,%edx
  802200:	8b 45 0c             	mov    0xc(%ebp),%eax
  802203:	89 02                	mov    %eax,(%edx)
}
  802205:	90                   	nop
  802206:	5d                   	pop    %ebp
  802207:	c3                   	ret    

00802208 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	83 e0 01             	and    $0x1,%eax
  802214:	85 c0                	test   %eax,%eax
  802216:	74 03                	je     80221b <alloc_block_FF+0x13>
  802218:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80221b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80221f:	77 07                	ja     802228 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802221:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802228:	a1 24 50 80 00       	mov    0x805024,%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	75 73                	jne    8022a4 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	83 c0 10             	add    $0x10,%eax
  802237:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80223a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802241:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802247:	01 d0                	add    %edx,%eax
  802249:	48                   	dec    %eax
  80224a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80224d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802250:	ba 00 00 00 00       	mov    $0x0,%edx
  802255:	f7 75 ec             	divl   -0x14(%ebp)
  802258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80225b:	29 d0                	sub    %edx,%eax
  80225d:	c1 e8 0c             	shr    $0xc,%eax
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	50                   	push   %eax
  802264:	e8 86 f1 ff ff       	call   8013ef <sbrk>
  802269:	83 c4 10             	add    $0x10,%esp
  80226c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80226f:	83 ec 0c             	sub    $0xc,%esp
  802272:	6a 00                	push   $0x0
  802274:	e8 76 f1 ff ff       	call   8013ef <sbrk>
  802279:	83 c4 10             	add    $0x10,%esp
  80227c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80227f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802282:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802285:	83 ec 08             	sub    $0x8,%esp
  802288:	50                   	push   %eax
  802289:	ff 75 e4             	pushl  -0x1c(%ebp)
  80228c:	e8 5b fd ff ff       	call   801fec <initialize_dynamic_allocator>
  802291:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802294:	83 ec 0c             	sub    $0xc,%esp
  802297:	68 0b 45 80 00       	push   $0x80450b
  80229c:	e8 b4 e3 ff ff       	call   800655 <cprintf>
  8022a1:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a8:	75 0a                	jne    8022b4 <alloc_block_FF+0xac>
	        return NULL;
  8022aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022af:	e9 0e 04 00 00       	jmp    8026c2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8022b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c3:	e9 f3 02 00 00       	jmp    8025bb <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022ce:	83 ec 0c             	sub    $0xc,%esp
  8022d1:	ff 75 bc             	pushl  -0x44(%ebp)
  8022d4:	e8 af fb ff ff       	call   801e88 <get_block_size>
  8022d9:	83 c4 10             	add    $0x10,%esp
  8022dc:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	83 c0 08             	add    $0x8,%eax
  8022e5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022e8:	0f 87 c5 02 00 00    	ja     8025b3 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	83 c0 18             	add    $0x18,%eax
  8022f4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022f7:	0f 87 19 02 00 00    	ja     802516 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802300:	2b 45 08             	sub    0x8(%ebp),%eax
  802303:	83 e8 08             	sub    $0x8,%eax
  802306:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8d 50 08             	lea    0x8(%eax),%edx
  80230f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802312:	01 d0                	add    %edx,%eax
  802314:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	83 c0 08             	add    $0x8,%eax
  80231d:	83 ec 04             	sub    $0x4,%esp
  802320:	6a 01                	push   $0x1
  802322:	50                   	push   %eax
  802323:	ff 75 bc             	pushl  -0x44(%ebp)
  802326:	e8 ae fe ff ff       	call   8021d9 <set_block_data>
  80232b:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 40 04             	mov    0x4(%eax),%eax
  802334:	85 c0                	test   %eax,%eax
  802336:	75 68                	jne    8023a0 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802338:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80233c:	75 17                	jne    802355 <alloc_block_FF+0x14d>
  80233e:	83 ec 04             	sub    $0x4,%esp
  802341:	68 e8 44 80 00       	push   $0x8044e8
  802346:	68 d7 00 00 00       	push   $0xd7
  80234b:	68 cd 44 80 00       	push   $0x8044cd
  802350:	e8 43 e0 ff ff       	call   800398 <_panic>
  802355:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80235b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80235e:	89 10                	mov    %edx,(%eax)
  802360:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	74 0d                	je     802376 <alloc_block_FF+0x16e>
  802369:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80236e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802371:	89 50 04             	mov    %edx,0x4(%eax)
  802374:	eb 08                	jmp    80237e <alloc_block_FF+0x176>
  802376:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802379:	a3 30 50 80 00       	mov    %eax,0x805030
  80237e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802381:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802386:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802389:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802390:	a1 38 50 80 00       	mov    0x805038,%eax
  802395:	40                   	inc    %eax
  802396:	a3 38 50 80 00       	mov    %eax,0x805038
  80239b:	e9 dc 00 00 00       	jmp    80247c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 00                	mov    (%eax),%eax
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	75 65                	jne    80240e <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023a9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023ad:	75 17                	jne    8023c6 <alloc_block_FF+0x1be>
  8023af:	83 ec 04             	sub    $0x4,%esp
  8023b2:	68 1c 45 80 00       	push   $0x80451c
  8023b7:	68 db 00 00 00       	push   $0xdb
  8023bc:	68 cd 44 80 00       	push   $0x8044cd
  8023c1:	e8 d2 df ff ff       	call   800398 <_panic>
  8023c6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023cf:	89 50 04             	mov    %edx,0x4(%eax)
  8023d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d5:	8b 40 04             	mov    0x4(%eax),%eax
  8023d8:	85 c0                	test   %eax,%eax
  8023da:	74 0c                	je     8023e8 <alloc_block_FF+0x1e0>
  8023dc:	a1 30 50 80 00       	mov    0x805030,%eax
  8023e1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023e4:	89 10                	mov    %edx,(%eax)
  8023e6:	eb 08                	jmp    8023f0 <alloc_block_FF+0x1e8>
  8023e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023eb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8023f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802401:	a1 38 50 80 00       	mov    0x805038,%eax
  802406:	40                   	inc    %eax
  802407:	a3 38 50 80 00       	mov    %eax,0x805038
  80240c:	eb 6e                	jmp    80247c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80240e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802412:	74 06                	je     80241a <alloc_block_FF+0x212>
  802414:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802418:	75 17                	jne    802431 <alloc_block_FF+0x229>
  80241a:	83 ec 04             	sub    $0x4,%esp
  80241d:	68 40 45 80 00       	push   $0x804540
  802422:	68 df 00 00 00       	push   $0xdf
  802427:	68 cd 44 80 00       	push   $0x8044cd
  80242c:	e8 67 df ff ff       	call   800398 <_panic>
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 10                	mov    (%eax),%edx
  802436:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802439:	89 10                	mov    %edx,(%eax)
  80243b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	85 c0                	test   %eax,%eax
  802442:	74 0b                	je     80244f <alloc_block_FF+0x247>
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80244c:	89 50 04             	mov    %edx,0x4(%eax)
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802455:	89 10                	mov    %edx,(%eax)
  802457:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245d:	89 50 04             	mov    %edx,0x4(%eax)
  802460:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802463:	8b 00                	mov    (%eax),%eax
  802465:	85 c0                	test   %eax,%eax
  802467:	75 08                	jne    802471 <alloc_block_FF+0x269>
  802469:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246c:	a3 30 50 80 00       	mov    %eax,0x805030
  802471:	a1 38 50 80 00       	mov    0x805038,%eax
  802476:	40                   	inc    %eax
  802477:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80247c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802480:	75 17                	jne    802499 <alloc_block_FF+0x291>
  802482:	83 ec 04             	sub    $0x4,%esp
  802485:	68 af 44 80 00       	push   $0x8044af
  80248a:	68 e1 00 00 00       	push   $0xe1
  80248f:	68 cd 44 80 00       	push   $0x8044cd
  802494:	e8 ff de ff ff       	call   800398 <_panic>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	74 10                	je     8024b2 <alloc_block_FF+0x2aa>
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024aa:	8b 52 04             	mov    0x4(%edx),%edx
  8024ad:	89 50 04             	mov    %edx,0x4(%eax)
  8024b0:	eb 0b                	jmp    8024bd <alloc_block_FF+0x2b5>
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 40 04             	mov    0x4(%eax),%eax
  8024b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	74 0f                	je     8024d6 <alloc_block_FF+0x2ce>
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 40 04             	mov    0x4(%eax),%eax
  8024cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d0:	8b 12                	mov    (%edx),%edx
  8024d2:	89 10                	mov    %edx,(%eax)
  8024d4:	eb 0a                	jmp    8024e0 <alloc_block_FF+0x2d8>
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8024f8:	48                   	dec    %eax
  8024f9:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	6a 00                	push   $0x0
  802503:	ff 75 b4             	pushl  -0x4c(%ebp)
  802506:	ff 75 b0             	pushl  -0x50(%ebp)
  802509:	e8 cb fc ff ff       	call   8021d9 <set_block_data>
  80250e:	83 c4 10             	add    $0x10,%esp
  802511:	e9 95 00 00 00       	jmp    8025ab <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	6a 01                	push   $0x1
  80251b:	ff 75 b8             	pushl  -0x48(%ebp)
  80251e:	ff 75 bc             	pushl  -0x44(%ebp)
  802521:	e8 b3 fc ff ff       	call   8021d9 <set_block_data>
  802526:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252d:	75 17                	jne    802546 <alloc_block_FF+0x33e>
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	68 af 44 80 00       	push   $0x8044af
  802537:	68 e8 00 00 00       	push   $0xe8
  80253c:	68 cd 44 80 00       	push   $0x8044cd
  802541:	e8 52 de ff ff       	call   800398 <_panic>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	74 10                	je     80255f <alloc_block_FF+0x357>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802557:	8b 52 04             	mov    0x4(%edx),%edx
  80255a:	89 50 04             	mov    %edx,0x4(%eax)
  80255d:	eb 0b                	jmp    80256a <alloc_block_FF+0x362>
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 40 04             	mov    0x4(%eax),%eax
  802565:	a3 30 50 80 00       	mov    %eax,0x805030
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 04             	mov    0x4(%eax),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	74 0f                	je     802583 <alloc_block_FF+0x37b>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 40 04             	mov    0x4(%eax),%eax
  80257a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257d:	8b 12                	mov    (%edx),%edx
  80257f:	89 10                	mov    %edx,(%eax)
  802581:	eb 0a                	jmp    80258d <alloc_block_FF+0x385>
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 00                	mov    (%eax),%eax
  802588:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8025a5:	48                   	dec    %eax
  8025a6:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8025ab:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025ae:	e9 0f 01 00 00       	jmp    8026c2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8025b3:	a1 34 50 80 00       	mov    0x805034,%eax
  8025b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bf:	74 07                	je     8025c8 <alloc_block_FF+0x3c0>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	eb 05                	jmp    8025cd <alloc_block_FF+0x3c5>
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cd:	a3 34 50 80 00       	mov    %eax,0x805034
  8025d2:	a1 34 50 80 00       	mov    0x805034,%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	0f 85 e9 fc ff ff    	jne    8022c8 <alloc_block_FF+0xc0>
  8025df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e3:	0f 85 df fc ff ff    	jne    8022c8 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	83 c0 08             	add    $0x8,%eax
  8025ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8025f2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025ff:	01 d0                	add    %edx,%eax
  802601:	48                   	dec    %eax
  802602:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802605:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802608:	ba 00 00 00 00       	mov    $0x0,%edx
  80260d:	f7 75 d8             	divl   -0x28(%ebp)
  802610:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802613:	29 d0                	sub    %edx,%eax
  802615:	c1 e8 0c             	shr    $0xc,%eax
  802618:	83 ec 0c             	sub    $0xc,%esp
  80261b:	50                   	push   %eax
  80261c:	e8 ce ed ff ff       	call   8013ef <sbrk>
  802621:	83 c4 10             	add    $0x10,%esp
  802624:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802627:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80262b:	75 0a                	jne    802637 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80262d:	b8 00 00 00 00       	mov    $0x0,%eax
  802632:	e9 8b 00 00 00       	jmp    8026c2 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802637:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80263e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802641:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802644:	01 d0                	add    %edx,%eax
  802646:	48                   	dec    %eax
  802647:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80264a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80264d:	ba 00 00 00 00       	mov    $0x0,%edx
  802652:	f7 75 cc             	divl   -0x34(%ebp)
  802655:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802658:	29 d0                	sub    %edx,%eax
  80265a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80265d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802660:	01 d0                	add    %edx,%eax
  802662:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802667:	a1 40 50 80 00       	mov    0x805040,%eax
  80266c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802672:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802679:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80267c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80267f:	01 d0                	add    %edx,%eax
  802681:	48                   	dec    %eax
  802682:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802685:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802688:	ba 00 00 00 00       	mov    $0x0,%edx
  80268d:	f7 75 c4             	divl   -0x3c(%ebp)
  802690:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802693:	29 d0                	sub    %edx,%eax
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	6a 01                	push   $0x1
  80269a:	50                   	push   %eax
  80269b:	ff 75 d0             	pushl  -0x30(%ebp)
  80269e:	e8 36 fb ff ff       	call   8021d9 <set_block_data>
  8026a3:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026a6:	83 ec 0c             	sub    $0xc,%esp
  8026a9:	ff 75 d0             	pushl  -0x30(%ebp)
  8026ac:	e8 1b 0a 00 00       	call   8030cc <free_block>
  8026b1:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8026b4:	83 ec 0c             	sub    $0xc,%esp
  8026b7:	ff 75 08             	pushl  0x8(%ebp)
  8026ba:	e8 49 fb ff ff       	call   802208 <alloc_block_FF>
  8026bf:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
  8026c7:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cd:	83 e0 01             	and    $0x1,%eax
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	74 03                	je     8026d7 <alloc_block_BF+0x13>
  8026d4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026d7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026db:	77 07                	ja     8026e4 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026dd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026e4:	a1 24 50 80 00       	mov    0x805024,%eax
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	75 73                	jne    802760 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f0:	83 c0 10             	add    $0x10,%eax
  8026f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026f6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802703:	01 d0                	add    %edx,%eax
  802705:	48                   	dec    %eax
  802706:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802709:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80270c:	ba 00 00 00 00       	mov    $0x0,%edx
  802711:	f7 75 e0             	divl   -0x20(%ebp)
  802714:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802717:	29 d0                	sub    %edx,%eax
  802719:	c1 e8 0c             	shr    $0xc,%eax
  80271c:	83 ec 0c             	sub    $0xc,%esp
  80271f:	50                   	push   %eax
  802720:	e8 ca ec ff ff       	call   8013ef <sbrk>
  802725:	83 c4 10             	add    $0x10,%esp
  802728:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80272b:	83 ec 0c             	sub    $0xc,%esp
  80272e:	6a 00                	push   $0x0
  802730:	e8 ba ec ff ff       	call   8013ef <sbrk>
  802735:	83 c4 10             	add    $0x10,%esp
  802738:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80273b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80273e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802741:	83 ec 08             	sub    $0x8,%esp
  802744:	50                   	push   %eax
  802745:	ff 75 d8             	pushl  -0x28(%ebp)
  802748:	e8 9f f8 ff ff       	call   801fec <initialize_dynamic_allocator>
  80274d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802750:	83 ec 0c             	sub    $0xc,%esp
  802753:	68 0b 45 80 00       	push   $0x80450b
  802758:	e8 f8 de ff ff       	call   800655 <cprintf>
  80275d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802760:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802767:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80276e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802775:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80277c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802781:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802784:	e9 1d 01 00 00       	jmp    8028a6 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80278f:	83 ec 0c             	sub    $0xc,%esp
  802792:	ff 75 a8             	pushl  -0x58(%ebp)
  802795:	e8 ee f6 ff ff       	call   801e88 <get_block_size>
  80279a:	83 c4 10             	add    $0x10,%esp
  80279d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	83 c0 08             	add    $0x8,%eax
  8027a6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027a9:	0f 87 ef 00 00 00    	ja     80289e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	83 c0 18             	add    $0x18,%eax
  8027b5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027b8:	77 1d                	ja     8027d7 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8027ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027c0:	0f 86 d8 00 00 00    	jbe    80289e <alloc_block_BF+0x1da>
				{
					best_va = va;
  8027c6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8027cc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027d2:	e9 c7 00 00 00       	jmp    80289e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8027d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027da:	83 c0 08             	add    $0x8,%eax
  8027dd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027e0:	0f 85 9d 00 00 00    	jne    802883 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027e6:	83 ec 04             	sub    $0x4,%esp
  8027e9:	6a 01                	push   $0x1
  8027eb:	ff 75 a4             	pushl  -0x5c(%ebp)
  8027ee:	ff 75 a8             	pushl  -0x58(%ebp)
  8027f1:	e8 e3 f9 ff ff       	call   8021d9 <set_block_data>
  8027f6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8027f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fd:	75 17                	jne    802816 <alloc_block_BF+0x152>
  8027ff:	83 ec 04             	sub    $0x4,%esp
  802802:	68 af 44 80 00       	push   $0x8044af
  802807:	68 2c 01 00 00       	push   $0x12c
  80280c:	68 cd 44 80 00       	push   $0x8044cd
  802811:	e8 82 db ff ff       	call   800398 <_panic>
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 00                	mov    (%eax),%eax
  80281b:	85 c0                	test   %eax,%eax
  80281d:	74 10                	je     80282f <alloc_block_BF+0x16b>
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802827:	8b 52 04             	mov    0x4(%edx),%edx
  80282a:	89 50 04             	mov    %edx,0x4(%eax)
  80282d:	eb 0b                	jmp    80283a <alloc_block_BF+0x176>
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 40 04             	mov    0x4(%eax),%eax
  802835:	a3 30 50 80 00       	mov    %eax,0x805030
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	8b 40 04             	mov    0x4(%eax),%eax
  802840:	85 c0                	test   %eax,%eax
  802842:	74 0f                	je     802853 <alloc_block_BF+0x18f>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 40 04             	mov    0x4(%eax),%eax
  80284a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284d:	8b 12                	mov    (%edx),%edx
  80284f:	89 10                	mov    %edx,(%eax)
  802851:	eb 0a                	jmp    80285d <alloc_block_BF+0x199>
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802870:	a1 38 50 80 00       	mov    0x805038,%eax
  802875:	48                   	dec    %eax
  802876:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80287b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80287e:	e9 24 04 00 00       	jmp    802ca7 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802886:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802889:	76 13                	jbe    80289e <alloc_block_BF+0x1da>
					{
						internal = 1;
  80288b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802892:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802895:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802898:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80289b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80289e:	a1 34 50 80 00       	mov    0x805034,%eax
  8028a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028aa:	74 07                	je     8028b3 <alloc_block_BF+0x1ef>
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	eb 05                	jmp    8028b8 <alloc_block_BF+0x1f4>
  8028b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b8:	a3 34 50 80 00       	mov    %eax,0x805034
  8028bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	0f 85 bf fe ff ff    	jne    802789 <alloc_block_BF+0xc5>
  8028ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ce:	0f 85 b5 fe ff ff    	jne    802789 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8028d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028d8:	0f 84 26 02 00 00    	je     802b04 <alloc_block_BF+0x440>
  8028de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028e2:	0f 85 1c 02 00 00    	jne    802b04 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028eb:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ee:	83 e8 08             	sub    $0x8,%eax
  8028f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	8d 50 08             	lea    0x8(%eax),%edx
  8028fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fd:	01 d0                	add    %edx,%eax
  8028ff:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	83 c0 08             	add    $0x8,%eax
  802908:	83 ec 04             	sub    $0x4,%esp
  80290b:	6a 01                	push   $0x1
  80290d:	50                   	push   %eax
  80290e:	ff 75 f0             	pushl  -0x10(%ebp)
  802911:	e8 c3 f8 ff ff       	call   8021d9 <set_block_data>
  802916:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	75 68                	jne    80298b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802923:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802927:	75 17                	jne    802940 <alloc_block_BF+0x27c>
  802929:	83 ec 04             	sub    $0x4,%esp
  80292c:	68 e8 44 80 00       	push   $0x8044e8
  802931:	68 45 01 00 00       	push   $0x145
  802936:	68 cd 44 80 00       	push   $0x8044cd
  80293b:	e8 58 da ff ff       	call   800398 <_panic>
  802940:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802946:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802949:	89 10                	mov    %edx,(%eax)
  80294b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	74 0d                	je     802961 <alloc_block_BF+0x29d>
  802954:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802959:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80295c:	89 50 04             	mov    %edx,0x4(%eax)
  80295f:	eb 08                	jmp    802969 <alloc_block_BF+0x2a5>
  802961:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802964:	a3 30 50 80 00       	mov    %eax,0x805030
  802969:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80296c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802971:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802974:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297b:	a1 38 50 80 00       	mov    0x805038,%eax
  802980:	40                   	inc    %eax
  802981:	a3 38 50 80 00       	mov    %eax,0x805038
  802986:	e9 dc 00 00 00       	jmp    802a67 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	85 c0                	test   %eax,%eax
  802992:	75 65                	jne    8029f9 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802994:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802998:	75 17                	jne    8029b1 <alloc_block_BF+0x2ed>
  80299a:	83 ec 04             	sub    $0x4,%esp
  80299d:	68 1c 45 80 00       	push   $0x80451c
  8029a2:	68 4a 01 00 00       	push   $0x14a
  8029a7:	68 cd 44 80 00       	push   $0x8044cd
  8029ac:	e8 e7 d9 ff ff       	call   800398 <_panic>
  8029b1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ba:	89 50 04             	mov    %edx,0x4(%eax)
  8029bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c0:	8b 40 04             	mov    0x4(%eax),%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	74 0c                	je     8029d3 <alloc_block_BF+0x30f>
  8029c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8029cc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029cf:	89 10                	mov    %edx,(%eax)
  8029d1:	eb 08                	jmp    8029db <alloc_block_BF+0x317>
  8029d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029de:	a3 30 50 80 00       	mov    %eax,0x805030
  8029e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8029f1:	40                   	inc    %eax
  8029f2:	a3 38 50 80 00       	mov    %eax,0x805038
  8029f7:	eb 6e                	jmp    802a67 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8029f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029fd:	74 06                	je     802a05 <alloc_block_BF+0x341>
  8029ff:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a03:	75 17                	jne    802a1c <alloc_block_BF+0x358>
  802a05:	83 ec 04             	sub    $0x4,%esp
  802a08:	68 40 45 80 00       	push   $0x804540
  802a0d:	68 4f 01 00 00       	push   $0x14f
  802a12:	68 cd 44 80 00       	push   $0x8044cd
  802a17:	e8 7c d9 ff ff       	call   800398 <_panic>
  802a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1f:	8b 10                	mov    (%eax),%edx
  802a21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a24:	89 10                	mov    %edx,(%eax)
  802a26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	74 0b                	je     802a3a <alloc_block_BF+0x376>
  802a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a32:	8b 00                	mov    (%eax),%eax
  802a34:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a37:	89 50 04             	mov    %edx,0x4(%eax)
  802a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a40:	89 10                	mov    %edx,(%eax)
  802a42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a48:	89 50 04             	mov    %edx,0x4(%eax)
  802a4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	75 08                	jne    802a5c <alloc_block_BF+0x398>
  802a54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a57:	a3 30 50 80 00       	mov    %eax,0x805030
  802a5c:	a1 38 50 80 00       	mov    0x805038,%eax
  802a61:	40                   	inc    %eax
  802a62:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a6b:	75 17                	jne    802a84 <alloc_block_BF+0x3c0>
  802a6d:	83 ec 04             	sub    $0x4,%esp
  802a70:	68 af 44 80 00       	push   $0x8044af
  802a75:	68 51 01 00 00       	push   $0x151
  802a7a:	68 cd 44 80 00       	push   $0x8044cd
  802a7f:	e8 14 d9 ff ff       	call   800398 <_panic>
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	74 10                	je     802a9d <alloc_block_BF+0x3d9>
  802a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a90:	8b 00                	mov    (%eax),%eax
  802a92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a95:	8b 52 04             	mov    0x4(%edx),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
  802a9b:	eb 0b                	jmp    802aa8 <alloc_block_BF+0x3e4>
  802a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa0:	8b 40 04             	mov    0x4(%eax),%eax
  802aa3:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aab:	8b 40 04             	mov    0x4(%eax),%eax
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	74 0f                	je     802ac1 <alloc_block_BF+0x3fd>
  802ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab5:	8b 40 04             	mov    0x4(%eax),%eax
  802ab8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802abb:	8b 12                	mov    (%edx),%edx
  802abd:	89 10                	mov    %edx,(%eax)
  802abf:	eb 0a                	jmp    802acb <alloc_block_BF+0x407>
  802ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ade:	a1 38 50 80 00       	mov    0x805038,%eax
  802ae3:	48                   	dec    %eax
  802ae4:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802ae9:	83 ec 04             	sub    $0x4,%esp
  802aec:	6a 00                	push   $0x0
  802aee:	ff 75 d0             	pushl  -0x30(%ebp)
  802af1:	ff 75 cc             	pushl  -0x34(%ebp)
  802af4:	e8 e0 f6 ff ff       	call   8021d9 <set_block_data>
  802af9:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aff:	e9 a3 01 00 00       	jmp    802ca7 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b04:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b08:	0f 85 9d 00 00 00    	jne    802bab <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b0e:	83 ec 04             	sub    $0x4,%esp
  802b11:	6a 01                	push   $0x1
  802b13:	ff 75 ec             	pushl  -0x14(%ebp)
  802b16:	ff 75 f0             	pushl  -0x10(%ebp)
  802b19:	e8 bb f6 ff ff       	call   8021d9 <set_block_data>
  802b1e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b25:	75 17                	jne    802b3e <alloc_block_BF+0x47a>
  802b27:	83 ec 04             	sub    $0x4,%esp
  802b2a:	68 af 44 80 00       	push   $0x8044af
  802b2f:	68 58 01 00 00       	push   $0x158
  802b34:	68 cd 44 80 00       	push   $0x8044cd
  802b39:	e8 5a d8 ff ff       	call   800398 <_panic>
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	74 10                	je     802b57 <alloc_block_BF+0x493>
  802b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4f:	8b 52 04             	mov    0x4(%edx),%edx
  802b52:	89 50 04             	mov    %edx,0x4(%eax)
  802b55:	eb 0b                	jmp    802b62 <alloc_block_BF+0x49e>
  802b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5a:	8b 40 04             	mov    0x4(%eax),%eax
  802b5d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b65:	8b 40 04             	mov    0x4(%eax),%eax
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	74 0f                	je     802b7b <alloc_block_BF+0x4b7>
  802b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6f:	8b 40 04             	mov    0x4(%eax),%eax
  802b72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b75:	8b 12                	mov    (%edx),%edx
  802b77:	89 10                	mov    %edx,(%eax)
  802b79:	eb 0a                	jmp    802b85 <alloc_block_BF+0x4c1>
  802b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b98:	a1 38 50 80 00       	mov    0x805038,%eax
  802b9d:	48                   	dec    %eax
  802b9e:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba6:	e9 fc 00 00 00       	jmp    802ca7 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	83 c0 08             	add    $0x8,%eax
  802bb1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802bb4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802bbb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bbe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bc1:	01 d0                	add    %edx,%eax
  802bc3:	48                   	dec    %eax
  802bc4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bc7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bca:	ba 00 00 00 00       	mov    $0x0,%edx
  802bcf:	f7 75 c4             	divl   -0x3c(%ebp)
  802bd2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bd5:	29 d0                	sub    %edx,%eax
  802bd7:	c1 e8 0c             	shr    $0xc,%eax
  802bda:	83 ec 0c             	sub    $0xc,%esp
  802bdd:	50                   	push   %eax
  802bde:	e8 0c e8 ff ff       	call   8013ef <sbrk>
  802be3:	83 c4 10             	add    $0x10,%esp
  802be6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802be9:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802bed:	75 0a                	jne    802bf9 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802bef:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf4:	e9 ae 00 00 00       	jmp    802ca7 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802bf9:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c00:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c03:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c06:	01 d0                	add    %edx,%eax
  802c08:	48                   	dec    %eax
  802c09:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c0c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c0f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c14:	f7 75 b8             	divl   -0x48(%ebp)
  802c17:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c1a:	29 d0                	sub    %edx,%eax
  802c1c:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c1f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c22:	01 d0                	add    %edx,%eax
  802c24:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c29:	a1 40 50 80 00       	mov    0x805040,%eax
  802c2e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c34:	83 ec 0c             	sub    $0xc,%esp
  802c37:	68 74 45 80 00       	push   $0x804574
  802c3c:	e8 14 da ff ff       	call   800655 <cprintf>
  802c41:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c44:	83 ec 08             	sub    $0x8,%esp
  802c47:	ff 75 bc             	pushl  -0x44(%ebp)
  802c4a:	68 79 45 80 00       	push   $0x804579
  802c4f:	e8 01 da ff ff       	call   800655 <cprintf>
  802c54:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c57:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c5e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c61:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c64:	01 d0                	add    %edx,%eax
  802c66:	48                   	dec    %eax
  802c67:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c6a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  802c72:	f7 75 b0             	divl   -0x50(%ebp)
  802c75:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c78:	29 d0                	sub    %edx,%eax
  802c7a:	83 ec 04             	sub    $0x4,%esp
  802c7d:	6a 01                	push   $0x1
  802c7f:	50                   	push   %eax
  802c80:	ff 75 bc             	pushl  -0x44(%ebp)
  802c83:	e8 51 f5 ff ff       	call   8021d9 <set_block_data>
  802c88:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c8b:	83 ec 0c             	sub    $0xc,%esp
  802c8e:	ff 75 bc             	pushl  -0x44(%ebp)
  802c91:	e8 36 04 00 00       	call   8030cc <free_block>
  802c96:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c99:	83 ec 0c             	sub    $0xc,%esp
  802c9c:	ff 75 08             	pushl  0x8(%ebp)
  802c9f:	e8 20 fa ff ff       	call   8026c4 <alloc_block_BF>
  802ca4:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ca7:	c9                   	leave  
  802ca8:	c3                   	ret    

00802ca9 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802ca9:	55                   	push   %ebp
  802caa:	89 e5                	mov    %esp,%ebp
  802cac:	53                   	push   %ebx
  802cad:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802cb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cb7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802cbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc2:	74 1e                	je     802ce2 <merging+0x39>
  802cc4:	ff 75 08             	pushl  0x8(%ebp)
  802cc7:	e8 bc f1 ff ff       	call   801e88 <get_block_size>
  802ccc:	83 c4 04             	add    $0x4,%esp
  802ccf:	89 c2                	mov    %eax,%edx
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	01 d0                	add    %edx,%eax
  802cd6:	3b 45 10             	cmp    0x10(%ebp),%eax
  802cd9:	75 07                	jne    802ce2 <merging+0x39>
		prev_is_free = 1;
  802cdb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802ce2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ce6:	74 1e                	je     802d06 <merging+0x5d>
  802ce8:	ff 75 10             	pushl  0x10(%ebp)
  802ceb:	e8 98 f1 ff ff       	call   801e88 <get_block_size>
  802cf0:	83 c4 04             	add    $0x4,%esp
  802cf3:	89 c2                	mov    %eax,%edx
  802cf5:	8b 45 10             	mov    0x10(%ebp),%eax
  802cf8:	01 d0                	add    %edx,%eax
  802cfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cfd:	75 07                	jne    802d06 <merging+0x5d>
		next_is_free = 1;
  802cff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0a:	0f 84 cc 00 00 00    	je     802ddc <merging+0x133>
  802d10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d14:	0f 84 c2 00 00 00    	je     802ddc <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d1a:	ff 75 08             	pushl  0x8(%ebp)
  802d1d:	e8 66 f1 ff ff       	call   801e88 <get_block_size>
  802d22:	83 c4 04             	add    $0x4,%esp
  802d25:	89 c3                	mov    %eax,%ebx
  802d27:	ff 75 10             	pushl  0x10(%ebp)
  802d2a:	e8 59 f1 ff ff       	call   801e88 <get_block_size>
  802d2f:	83 c4 04             	add    $0x4,%esp
  802d32:	01 c3                	add    %eax,%ebx
  802d34:	ff 75 0c             	pushl  0xc(%ebp)
  802d37:	e8 4c f1 ff ff       	call   801e88 <get_block_size>
  802d3c:	83 c4 04             	add    $0x4,%esp
  802d3f:	01 d8                	add    %ebx,%eax
  802d41:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d44:	6a 00                	push   $0x0
  802d46:	ff 75 ec             	pushl  -0x14(%ebp)
  802d49:	ff 75 08             	pushl  0x8(%ebp)
  802d4c:	e8 88 f4 ff ff       	call   8021d9 <set_block_data>
  802d51:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d58:	75 17                	jne    802d71 <merging+0xc8>
  802d5a:	83 ec 04             	sub    $0x4,%esp
  802d5d:	68 af 44 80 00       	push   $0x8044af
  802d62:	68 7d 01 00 00       	push   $0x17d
  802d67:	68 cd 44 80 00       	push   $0x8044cd
  802d6c:	e8 27 d6 ff ff       	call   800398 <_panic>
  802d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d74:	8b 00                	mov    (%eax),%eax
  802d76:	85 c0                	test   %eax,%eax
  802d78:	74 10                	je     802d8a <merging+0xe1>
  802d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d82:	8b 52 04             	mov    0x4(%edx),%edx
  802d85:	89 50 04             	mov    %edx,0x4(%eax)
  802d88:	eb 0b                	jmp    802d95 <merging+0xec>
  802d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8d:	8b 40 04             	mov    0x4(%eax),%eax
  802d90:	a3 30 50 80 00       	mov    %eax,0x805030
  802d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d98:	8b 40 04             	mov    0x4(%eax),%eax
  802d9b:	85 c0                	test   %eax,%eax
  802d9d:	74 0f                	je     802dae <merging+0x105>
  802d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da2:	8b 40 04             	mov    0x4(%eax),%eax
  802da5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da8:	8b 12                	mov    (%edx),%edx
  802daa:	89 10                	mov    %edx,(%eax)
  802dac:	eb 0a                	jmp    802db8 <merging+0x10f>
  802dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db1:	8b 00                	mov    (%eax),%eax
  802db3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcb:	a1 38 50 80 00       	mov    0x805038,%eax
  802dd0:	48                   	dec    %eax
  802dd1:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802dd6:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dd7:	e9 ea 02 00 00       	jmp    8030c6 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de0:	74 3b                	je     802e1d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802de2:	83 ec 0c             	sub    $0xc,%esp
  802de5:	ff 75 08             	pushl  0x8(%ebp)
  802de8:	e8 9b f0 ff ff       	call   801e88 <get_block_size>
  802ded:	83 c4 10             	add    $0x10,%esp
  802df0:	89 c3                	mov    %eax,%ebx
  802df2:	83 ec 0c             	sub    $0xc,%esp
  802df5:	ff 75 10             	pushl  0x10(%ebp)
  802df8:	e8 8b f0 ff ff       	call   801e88 <get_block_size>
  802dfd:	83 c4 10             	add    $0x10,%esp
  802e00:	01 d8                	add    %ebx,%eax
  802e02:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e05:	83 ec 04             	sub    $0x4,%esp
  802e08:	6a 00                	push   $0x0
  802e0a:	ff 75 e8             	pushl  -0x18(%ebp)
  802e0d:	ff 75 08             	pushl  0x8(%ebp)
  802e10:	e8 c4 f3 ff ff       	call   8021d9 <set_block_data>
  802e15:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e18:	e9 a9 02 00 00       	jmp    8030c6 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e21:	0f 84 2d 01 00 00    	je     802f54 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e27:	83 ec 0c             	sub    $0xc,%esp
  802e2a:	ff 75 10             	pushl  0x10(%ebp)
  802e2d:	e8 56 f0 ff ff       	call   801e88 <get_block_size>
  802e32:	83 c4 10             	add    $0x10,%esp
  802e35:	89 c3                	mov    %eax,%ebx
  802e37:	83 ec 0c             	sub    $0xc,%esp
  802e3a:	ff 75 0c             	pushl  0xc(%ebp)
  802e3d:	e8 46 f0 ff ff       	call   801e88 <get_block_size>
  802e42:	83 c4 10             	add    $0x10,%esp
  802e45:	01 d8                	add    %ebx,%eax
  802e47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e4a:	83 ec 04             	sub    $0x4,%esp
  802e4d:	6a 00                	push   $0x0
  802e4f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e52:	ff 75 10             	pushl  0x10(%ebp)
  802e55:	e8 7f f3 ff ff       	call   8021d9 <set_block_data>
  802e5a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  802e60:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e67:	74 06                	je     802e6f <merging+0x1c6>
  802e69:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e6d:	75 17                	jne    802e86 <merging+0x1dd>
  802e6f:	83 ec 04             	sub    $0x4,%esp
  802e72:	68 88 45 80 00       	push   $0x804588
  802e77:	68 8d 01 00 00       	push   $0x18d
  802e7c:	68 cd 44 80 00       	push   $0x8044cd
  802e81:	e8 12 d5 ff ff       	call   800398 <_panic>
  802e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e89:	8b 50 04             	mov    0x4(%eax),%edx
  802e8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e8f:	89 50 04             	mov    %edx,0x4(%eax)
  802e92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e98:	89 10                	mov    %edx,(%eax)
  802e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ea0:	85 c0                	test   %eax,%eax
  802ea2:	74 0d                	je     802eb1 <merging+0x208>
  802ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea7:	8b 40 04             	mov    0x4(%eax),%eax
  802eaa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ead:	89 10                	mov    %edx,(%eax)
  802eaf:	eb 08                	jmp    802eb9 <merging+0x210>
  802eb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ebf:	89 50 04             	mov    %edx,0x4(%eax)
  802ec2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ec7:	40                   	inc    %eax
  802ec8:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802ecd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ed1:	75 17                	jne    802eea <merging+0x241>
  802ed3:	83 ec 04             	sub    $0x4,%esp
  802ed6:	68 af 44 80 00       	push   $0x8044af
  802edb:	68 8e 01 00 00       	push   $0x18e
  802ee0:	68 cd 44 80 00       	push   $0x8044cd
  802ee5:	e8 ae d4 ff ff       	call   800398 <_panic>
  802eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	85 c0                	test   %eax,%eax
  802ef1:	74 10                	je     802f03 <merging+0x25a>
  802ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef6:	8b 00                	mov    (%eax),%eax
  802ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802efb:	8b 52 04             	mov    0x4(%edx),%edx
  802efe:	89 50 04             	mov    %edx,0x4(%eax)
  802f01:	eb 0b                	jmp    802f0e <merging+0x265>
  802f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f06:	8b 40 04             	mov    0x4(%eax),%eax
  802f09:	a3 30 50 80 00       	mov    %eax,0x805030
  802f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f11:	8b 40 04             	mov    0x4(%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	74 0f                	je     802f27 <merging+0x27e>
  802f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1b:	8b 40 04             	mov    0x4(%eax),%eax
  802f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f21:	8b 12                	mov    (%edx),%edx
  802f23:	89 10                	mov    %edx,(%eax)
  802f25:	eb 0a                	jmp    802f31 <merging+0x288>
  802f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2a:	8b 00                	mov    (%eax),%eax
  802f2c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f44:	a1 38 50 80 00       	mov    0x805038,%eax
  802f49:	48                   	dec    %eax
  802f4a:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f4f:	e9 72 01 00 00       	jmp    8030c6 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f54:	8b 45 10             	mov    0x10(%ebp),%eax
  802f57:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5e:	74 79                	je     802fd9 <merging+0x330>
  802f60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f64:	74 73                	je     802fd9 <merging+0x330>
  802f66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6a:	74 06                	je     802f72 <merging+0x2c9>
  802f6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f70:	75 17                	jne    802f89 <merging+0x2e0>
  802f72:	83 ec 04             	sub    $0x4,%esp
  802f75:	68 40 45 80 00       	push   $0x804540
  802f7a:	68 94 01 00 00       	push   $0x194
  802f7f:	68 cd 44 80 00       	push   $0x8044cd
  802f84:	e8 0f d4 ff ff       	call   800398 <_panic>
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	8b 10                	mov    (%eax),%edx
  802f8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f91:	89 10                	mov    %edx,(%eax)
  802f93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f96:	8b 00                	mov    (%eax),%eax
  802f98:	85 c0                	test   %eax,%eax
  802f9a:	74 0b                	je     802fa7 <merging+0x2fe>
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fa4:	89 50 04             	mov    %edx,0x4(%eax)
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fad:	89 10                	mov    %edx,(%eax)
  802faf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb5:	89 50 04             	mov    %edx,0x4(%eax)
  802fb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	75 08                	jne    802fc9 <merging+0x320>
  802fc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc4:	a3 30 50 80 00       	mov    %eax,0x805030
  802fc9:	a1 38 50 80 00       	mov    0x805038,%eax
  802fce:	40                   	inc    %eax
  802fcf:	a3 38 50 80 00       	mov    %eax,0x805038
  802fd4:	e9 ce 00 00 00       	jmp    8030a7 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802fd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fdd:	74 65                	je     803044 <merging+0x39b>
  802fdf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fe3:	75 17                	jne    802ffc <merging+0x353>
  802fe5:	83 ec 04             	sub    $0x4,%esp
  802fe8:	68 1c 45 80 00       	push   $0x80451c
  802fed:	68 95 01 00 00       	push   $0x195
  802ff2:	68 cd 44 80 00       	push   $0x8044cd
  802ff7:	e8 9c d3 ff ff       	call   800398 <_panic>
  802ffc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803002:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803005:	89 50 04             	mov    %edx,0x4(%eax)
  803008:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300b:	8b 40 04             	mov    0x4(%eax),%eax
  80300e:	85 c0                	test   %eax,%eax
  803010:	74 0c                	je     80301e <merging+0x375>
  803012:	a1 30 50 80 00       	mov    0x805030,%eax
  803017:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	eb 08                	jmp    803026 <merging+0x37d>
  80301e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803021:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803026:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803029:	a3 30 50 80 00       	mov    %eax,0x805030
  80302e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803031:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803037:	a1 38 50 80 00       	mov    0x805038,%eax
  80303c:	40                   	inc    %eax
  80303d:	a3 38 50 80 00       	mov    %eax,0x805038
  803042:	eb 63                	jmp    8030a7 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803044:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803048:	75 17                	jne    803061 <merging+0x3b8>
  80304a:	83 ec 04             	sub    $0x4,%esp
  80304d:	68 e8 44 80 00       	push   $0x8044e8
  803052:	68 98 01 00 00       	push   $0x198
  803057:	68 cd 44 80 00       	push   $0x8044cd
  80305c:	e8 37 d3 ff ff       	call   800398 <_panic>
  803061:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803067:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306a:	89 10                	mov    %edx,(%eax)
  80306c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306f:	8b 00                	mov    (%eax),%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	74 0d                	je     803082 <merging+0x3d9>
  803075:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80307a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80307d:	89 50 04             	mov    %edx,0x4(%eax)
  803080:	eb 08                	jmp    80308a <merging+0x3e1>
  803082:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803085:	a3 30 50 80 00       	mov    %eax,0x805030
  80308a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80308d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803092:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803095:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309c:	a1 38 50 80 00       	mov    0x805038,%eax
  8030a1:	40                   	inc    %eax
  8030a2:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8030a7:	83 ec 0c             	sub    $0xc,%esp
  8030aa:	ff 75 10             	pushl  0x10(%ebp)
  8030ad:	e8 d6 ed ff ff       	call   801e88 <get_block_size>
  8030b2:	83 c4 10             	add    $0x10,%esp
  8030b5:	83 ec 04             	sub    $0x4,%esp
  8030b8:	6a 00                	push   $0x0
  8030ba:	50                   	push   %eax
  8030bb:	ff 75 10             	pushl  0x10(%ebp)
  8030be:	e8 16 f1 ff ff       	call   8021d9 <set_block_data>
  8030c3:	83 c4 10             	add    $0x10,%esp
	}
}
  8030c6:	90                   	nop
  8030c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030ca:	c9                   	leave  
  8030cb:	c3                   	ret    

008030cc <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030cc:	55                   	push   %ebp
  8030cd:	89 e5                	mov    %esp,%ebp
  8030cf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030d2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030da:	a1 30 50 80 00       	mov    0x805030,%eax
  8030df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e2:	73 1b                	jae    8030ff <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030e4:	a1 30 50 80 00       	mov    0x805030,%eax
  8030e9:	83 ec 04             	sub    $0x4,%esp
  8030ec:	ff 75 08             	pushl  0x8(%ebp)
  8030ef:	6a 00                	push   $0x0
  8030f1:	50                   	push   %eax
  8030f2:	e8 b2 fb ff ff       	call   802ca9 <merging>
  8030f7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030fa:	e9 8b 00 00 00       	jmp    80318a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030ff:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803104:	3b 45 08             	cmp    0x8(%ebp),%eax
  803107:	76 18                	jbe    803121 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803109:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80310e:	83 ec 04             	sub    $0x4,%esp
  803111:	ff 75 08             	pushl  0x8(%ebp)
  803114:	50                   	push   %eax
  803115:	6a 00                	push   $0x0
  803117:	e8 8d fb ff ff       	call   802ca9 <merging>
  80311c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80311f:	eb 69                	jmp    80318a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803121:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803126:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803129:	eb 39                	jmp    803164 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803131:	73 29                	jae    80315c <free_block+0x90>
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	3b 45 08             	cmp    0x8(%ebp),%eax
  80313b:	76 1f                	jbe    80315c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803145:	83 ec 04             	sub    $0x4,%esp
  803148:	ff 75 08             	pushl  0x8(%ebp)
  80314b:	ff 75 f0             	pushl  -0x10(%ebp)
  80314e:	ff 75 f4             	pushl  -0xc(%ebp)
  803151:	e8 53 fb ff ff       	call   802ca9 <merging>
  803156:	83 c4 10             	add    $0x10,%esp
			break;
  803159:	90                   	nop
		}
	}
}
  80315a:	eb 2e                	jmp    80318a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80315c:	a1 34 50 80 00       	mov    0x805034,%eax
  803161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803164:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803168:	74 07                	je     803171 <free_block+0xa5>
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	eb 05                	jmp    803176 <free_block+0xaa>
  803171:	b8 00 00 00 00       	mov    $0x0,%eax
  803176:	a3 34 50 80 00       	mov    %eax,0x805034
  80317b:	a1 34 50 80 00       	mov    0x805034,%eax
  803180:	85 c0                	test   %eax,%eax
  803182:	75 a7                	jne    80312b <free_block+0x5f>
  803184:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803188:	75 a1                	jne    80312b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80318a:	90                   	nop
  80318b:	c9                   	leave  
  80318c:	c3                   	ret    

0080318d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80318d:	55                   	push   %ebp
  80318e:	89 e5                	mov    %esp,%ebp
  803190:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803193:	ff 75 08             	pushl  0x8(%ebp)
  803196:	e8 ed ec ff ff       	call   801e88 <get_block_size>
  80319b:	83 c4 04             	add    $0x4,%esp
  80319e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8031a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8031a8:	eb 17                	jmp    8031c1 <copy_data+0x34>
  8031aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b0:	01 c2                	add    %eax,%edx
  8031b2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	01 c8                	add    %ecx,%eax
  8031ba:	8a 00                	mov    (%eax),%al
  8031bc:	88 02                	mov    %al,(%edx)
  8031be:	ff 45 fc             	incl   -0x4(%ebp)
  8031c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031c7:	72 e1                	jb     8031aa <copy_data+0x1d>
}
  8031c9:	90                   	nop
  8031ca:	c9                   	leave  
  8031cb:	c3                   	ret    

008031cc <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031cc:	55                   	push   %ebp
  8031cd:	89 e5                	mov    %esp,%ebp
  8031cf:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d6:	75 23                	jne    8031fb <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8031d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031dc:	74 13                	je     8031f1 <realloc_block_FF+0x25>
  8031de:	83 ec 0c             	sub    $0xc,%esp
  8031e1:	ff 75 0c             	pushl  0xc(%ebp)
  8031e4:	e8 1f f0 ff ff       	call   802208 <alloc_block_FF>
  8031e9:	83 c4 10             	add    $0x10,%esp
  8031ec:	e9 f4 06 00 00       	jmp    8038e5 <realloc_block_FF+0x719>
		return NULL;
  8031f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f6:	e9 ea 06 00 00       	jmp    8038e5 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8031fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031ff:	75 18                	jne    803219 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803201:	83 ec 0c             	sub    $0xc,%esp
  803204:	ff 75 08             	pushl  0x8(%ebp)
  803207:	e8 c0 fe ff ff       	call   8030cc <free_block>
  80320c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80320f:	b8 00 00 00 00       	mov    $0x0,%eax
  803214:	e9 cc 06 00 00       	jmp    8038e5 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803219:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80321d:	77 07                	ja     803226 <realloc_block_FF+0x5a>
  80321f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803226:	8b 45 0c             	mov    0xc(%ebp),%eax
  803229:	83 e0 01             	and    $0x1,%eax
  80322c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80322f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803232:	83 c0 08             	add    $0x8,%eax
  803235:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803238:	83 ec 0c             	sub    $0xc,%esp
  80323b:	ff 75 08             	pushl  0x8(%ebp)
  80323e:	e8 45 ec ff ff       	call   801e88 <get_block_size>
  803243:	83 c4 10             	add    $0x10,%esp
  803246:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803249:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324c:	83 e8 08             	sub    $0x8,%eax
  80324f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	83 e8 04             	sub    $0x4,%eax
  803258:	8b 00                	mov    (%eax),%eax
  80325a:	83 e0 fe             	and    $0xfffffffe,%eax
  80325d:	89 c2                	mov    %eax,%edx
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	01 d0                	add    %edx,%eax
  803264:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803267:	83 ec 0c             	sub    $0xc,%esp
  80326a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80326d:	e8 16 ec ff ff       	call   801e88 <get_block_size>
  803272:	83 c4 10             	add    $0x10,%esp
  803275:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803278:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80327b:	83 e8 08             	sub    $0x8,%eax
  80327e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803281:	8b 45 0c             	mov    0xc(%ebp),%eax
  803284:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803287:	75 08                	jne    803291 <realloc_block_FF+0xc5>
	{
		 return va;
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	e9 54 06 00 00       	jmp    8038e5 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803291:	8b 45 0c             	mov    0xc(%ebp),%eax
  803294:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803297:	0f 83 e5 03 00 00    	jae    803682 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8032a6:	83 ec 0c             	sub    $0xc,%esp
  8032a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032ac:	e8 f0 eb ff ff       	call   801ea1 <is_free_block>
  8032b1:	83 c4 10             	add    $0x10,%esp
  8032b4:	84 c0                	test   %al,%al
  8032b6:	0f 84 3b 01 00 00    	je     8033f7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8032bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032c2:	01 d0                	add    %edx,%eax
  8032c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8032c7:	83 ec 04             	sub    $0x4,%esp
  8032ca:	6a 01                	push   $0x1
  8032cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8032cf:	ff 75 08             	pushl  0x8(%ebp)
  8032d2:	e8 02 ef ff ff       	call   8021d9 <set_block_data>
  8032d7:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032da:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dd:	83 e8 04             	sub    $0x4,%eax
  8032e0:	8b 00                	mov    (%eax),%eax
  8032e2:	83 e0 fe             	and    $0xfffffffe,%eax
  8032e5:	89 c2                	mov    %eax,%edx
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	01 d0                	add    %edx,%eax
  8032ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8032ef:	83 ec 04             	sub    $0x4,%esp
  8032f2:	6a 00                	push   $0x0
  8032f4:	ff 75 cc             	pushl  -0x34(%ebp)
  8032f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8032fa:	e8 da ee ff ff       	call   8021d9 <set_block_data>
  8032ff:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803302:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803306:	74 06                	je     80330e <realloc_block_FF+0x142>
  803308:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80330c:	75 17                	jne    803325 <realloc_block_FF+0x159>
  80330e:	83 ec 04             	sub    $0x4,%esp
  803311:	68 40 45 80 00       	push   $0x804540
  803316:	68 f6 01 00 00       	push   $0x1f6
  80331b:	68 cd 44 80 00       	push   $0x8044cd
  803320:	e8 73 d0 ff ff       	call   800398 <_panic>
  803325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803328:	8b 10                	mov    (%eax),%edx
  80332a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80332d:	89 10                	mov    %edx,(%eax)
  80332f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803332:	8b 00                	mov    (%eax),%eax
  803334:	85 c0                	test   %eax,%eax
  803336:	74 0b                	je     803343 <realloc_block_FF+0x177>
  803338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333b:	8b 00                	mov    (%eax),%eax
  80333d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803340:	89 50 04             	mov    %edx,0x4(%eax)
  803343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803346:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803349:	89 10                	mov    %edx,(%eax)
  80334b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80334e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803351:	89 50 04             	mov    %edx,0x4(%eax)
  803354:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	85 c0                	test   %eax,%eax
  80335b:	75 08                	jne    803365 <realloc_block_FF+0x199>
  80335d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803360:	a3 30 50 80 00       	mov    %eax,0x805030
  803365:	a1 38 50 80 00       	mov    0x805038,%eax
  80336a:	40                   	inc    %eax
  80336b:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803370:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803374:	75 17                	jne    80338d <realloc_block_FF+0x1c1>
  803376:	83 ec 04             	sub    $0x4,%esp
  803379:	68 af 44 80 00       	push   $0x8044af
  80337e:	68 f7 01 00 00       	push   $0x1f7
  803383:	68 cd 44 80 00       	push   $0x8044cd
  803388:	e8 0b d0 ff ff       	call   800398 <_panic>
  80338d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803390:	8b 00                	mov    (%eax),%eax
  803392:	85 c0                	test   %eax,%eax
  803394:	74 10                	je     8033a6 <realloc_block_FF+0x1da>
  803396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803399:	8b 00                	mov    (%eax),%eax
  80339b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80339e:	8b 52 04             	mov    0x4(%edx),%edx
  8033a1:	89 50 04             	mov    %edx,0x4(%eax)
  8033a4:	eb 0b                	jmp    8033b1 <realloc_block_FF+0x1e5>
  8033a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a9:	8b 40 04             	mov    0x4(%eax),%eax
  8033ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8033b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b4:	8b 40 04             	mov    0x4(%eax),%eax
  8033b7:	85 c0                	test   %eax,%eax
  8033b9:	74 0f                	je     8033ca <realloc_block_FF+0x1fe>
  8033bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033be:	8b 40 04             	mov    0x4(%eax),%eax
  8033c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033c4:	8b 12                	mov    (%edx),%edx
  8033c6:	89 10                	mov    %edx,(%eax)
  8033c8:	eb 0a                	jmp    8033d4 <realloc_block_FF+0x208>
  8033ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cd:	8b 00                	mov    (%eax),%eax
  8033cf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e7:	a1 38 50 80 00       	mov    0x805038,%eax
  8033ec:	48                   	dec    %eax
  8033ed:	a3 38 50 80 00       	mov    %eax,0x805038
  8033f2:	e9 83 02 00 00       	jmp    80367a <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8033f7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033fb:	0f 86 69 02 00 00    	jbe    80366a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803401:	83 ec 04             	sub    $0x4,%esp
  803404:	6a 01                	push   $0x1
  803406:	ff 75 f0             	pushl  -0x10(%ebp)
  803409:	ff 75 08             	pushl  0x8(%ebp)
  80340c:	e8 c8 ed ff ff       	call   8021d9 <set_block_data>
  803411:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	83 e8 04             	sub    $0x4,%eax
  80341a:	8b 00                	mov    (%eax),%eax
  80341c:	83 e0 fe             	and    $0xfffffffe,%eax
  80341f:	89 c2                	mov    %eax,%edx
  803421:	8b 45 08             	mov    0x8(%ebp),%eax
  803424:	01 d0                	add    %edx,%eax
  803426:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803429:	a1 38 50 80 00       	mov    0x805038,%eax
  80342e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803431:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803435:	75 68                	jne    80349f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803437:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80343b:	75 17                	jne    803454 <realloc_block_FF+0x288>
  80343d:	83 ec 04             	sub    $0x4,%esp
  803440:	68 e8 44 80 00       	push   $0x8044e8
  803445:	68 06 02 00 00       	push   $0x206
  80344a:	68 cd 44 80 00       	push   $0x8044cd
  80344f:	e8 44 cf ff ff       	call   800398 <_panic>
  803454:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80345a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345d:	89 10                	mov    %edx,(%eax)
  80345f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	85 c0                	test   %eax,%eax
  803466:	74 0d                	je     803475 <realloc_block_FF+0x2a9>
  803468:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80346d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803470:	89 50 04             	mov    %edx,0x4(%eax)
  803473:	eb 08                	jmp    80347d <realloc_block_FF+0x2b1>
  803475:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803478:	a3 30 50 80 00       	mov    %eax,0x805030
  80347d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803480:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803485:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803488:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80348f:	a1 38 50 80 00       	mov    0x805038,%eax
  803494:	40                   	inc    %eax
  803495:	a3 38 50 80 00       	mov    %eax,0x805038
  80349a:	e9 b0 01 00 00       	jmp    80364f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80349f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034a4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034a7:	76 68                	jbe    803511 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034a9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034ad:	75 17                	jne    8034c6 <realloc_block_FF+0x2fa>
  8034af:	83 ec 04             	sub    $0x4,%esp
  8034b2:	68 e8 44 80 00       	push   $0x8044e8
  8034b7:	68 0b 02 00 00       	push   $0x20b
  8034bc:	68 cd 44 80 00       	push   $0x8044cd
  8034c1:	e8 d2 ce ff ff       	call   800398 <_panic>
  8034c6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034cf:	89 10                	mov    %edx,(%eax)
  8034d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d4:	8b 00                	mov    (%eax),%eax
  8034d6:	85 c0                	test   %eax,%eax
  8034d8:	74 0d                	je     8034e7 <realloc_block_FF+0x31b>
  8034da:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034e2:	89 50 04             	mov    %edx,0x4(%eax)
  8034e5:	eb 08                	jmp    8034ef <realloc_block_FF+0x323>
  8034e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803501:	a1 38 50 80 00       	mov    0x805038,%eax
  803506:	40                   	inc    %eax
  803507:	a3 38 50 80 00       	mov    %eax,0x805038
  80350c:	e9 3e 01 00 00       	jmp    80364f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803511:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803516:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803519:	73 68                	jae    803583 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80351b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80351f:	75 17                	jne    803538 <realloc_block_FF+0x36c>
  803521:	83 ec 04             	sub    $0x4,%esp
  803524:	68 1c 45 80 00       	push   $0x80451c
  803529:	68 10 02 00 00       	push   $0x210
  80352e:	68 cd 44 80 00       	push   $0x8044cd
  803533:	e8 60 ce ff ff       	call   800398 <_panic>
  803538:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80353e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803541:	89 50 04             	mov    %edx,0x4(%eax)
  803544:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803547:	8b 40 04             	mov    0x4(%eax),%eax
  80354a:	85 c0                	test   %eax,%eax
  80354c:	74 0c                	je     80355a <realloc_block_FF+0x38e>
  80354e:	a1 30 50 80 00       	mov    0x805030,%eax
  803553:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803556:	89 10                	mov    %edx,(%eax)
  803558:	eb 08                	jmp    803562 <realloc_block_FF+0x396>
  80355a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803562:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803565:	a3 30 50 80 00       	mov    %eax,0x805030
  80356a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803573:	a1 38 50 80 00       	mov    0x805038,%eax
  803578:	40                   	inc    %eax
  803579:	a3 38 50 80 00       	mov    %eax,0x805038
  80357e:	e9 cc 00 00 00       	jmp    80364f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80358a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80358f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803592:	e9 8a 00 00 00       	jmp    803621 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80359d:	73 7a                	jae    803619 <realloc_block_FF+0x44d>
  80359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a2:	8b 00                	mov    (%eax),%eax
  8035a4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035a7:	73 70                	jae    803619 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8035a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ad:	74 06                	je     8035b5 <realloc_block_FF+0x3e9>
  8035af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035b3:	75 17                	jne    8035cc <realloc_block_FF+0x400>
  8035b5:	83 ec 04             	sub    $0x4,%esp
  8035b8:	68 40 45 80 00       	push   $0x804540
  8035bd:	68 1a 02 00 00       	push   $0x21a
  8035c2:	68 cd 44 80 00       	push   $0x8044cd
  8035c7:	e8 cc cd ff ff       	call   800398 <_panic>
  8035cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cf:	8b 10                	mov    (%eax),%edx
  8035d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d4:	89 10                	mov    %edx,(%eax)
  8035d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d9:	8b 00                	mov    (%eax),%eax
  8035db:	85 c0                	test   %eax,%eax
  8035dd:	74 0b                	je     8035ea <realloc_block_FF+0x41e>
  8035df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035e7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035f0:	89 10                	mov    %edx,(%eax)
  8035f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f8:	89 50 04             	mov    %edx,0x4(%eax)
  8035fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fe:	8b 00                	mov    (%eax),%eax
  803600:	85 c0                	test   %eax,%eax
  803602:	75 08                	jne    80360c <realloc_block_FF+0x440>
  803604:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803607:	a3 30 50 80 00       	mov    %eax,0x805030
  80360c:	a1 38 50 80 00       	mov    0x805038,%eax
  803611:	40                   	inc    %eax
  803612:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803617:	eb 36                	jmp    80364f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803619:	a1 34 50 80 00       	mov    0x805034,%eax
  80361e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803625:	74 07                	je     80362e <realloc_block_FF+0x462>
  803627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	eb 05                	jmp    803633 <realloc_block_FF+0x467>
  80362e:	b8 00 00 00 00       	mov    $0x0,%eax
  803633:	a3 34 50 80 00       	mov    %eax,0x805034
  803638:	a1 34 50 80 00       	mov    0x805034,%eax
  80363d:	85 c0                	test   %eax,%eax
  80363f:	0f 85 52 ff ff ff    	jne    803597 <realloc_block_FF+0x3cb>
  803645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803649:	0f 85 48 ff ff ff    	jne    803597 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80364f:	83 ec 04             	sub    $0x4,%esp
  803652:	6a 00                	push   $0x0
  803654:	ff 75 d8             	pushl  -0x28(%ebp)
  803657:	ff 75 d4             	pushl  -0x2c(%ebp)
  80365a:	e8 7a eb ff ff       	call   8021d9 <set_block_data>
  80365f:	83 c4 10             	add    $0x10,%esp
				return va;
  803662:	8b 45 08             	mov    0x8(%ebp),%eax
  803665:	e9 7b 02 00 00       	jmp    8038e5 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80366a:	83 ec 0c             	sub    $0xc,%esp
  80366d:	68 bd 45 80 00       	push   $0x8045bd
  803672:	e8 de cf ff ff       	call   800655 <cprintf>
  803677:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	e9 63 02 00 00       	jmp    8038e5 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803682:	8b 45 0c             	mov    0xc(%ebp),%eax
  803685:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803688:	0f 86 4d 02 00 00    	jbe    8038db <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80368e:	83 ec 0c             	sub    $0xc,%esp
  803691:	ff 75 e4             	pushl  -0x1c(%ebp)
  803694:	e8 08 e8 ff ff       	call   801ea1 <is_free_block>
  803699:	83 c4 10             	add    $0x10,%esp
  80369c:	84 c0                	test   %al,%al
  80369e:	0f 84 37 02 00 00    	je     8038db <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8036a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8036aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8036ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036b0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036b3:	76 38                	jbe    8036ed <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8036b5:	83 ec 0c             	sub    $0xc,%esp
  8036b8:	ff 75 08             	pushl  0x8(%ebp)
  8036bb:	e8 0c fa ff ff       	call   8030cc <free_block>
  8036c0:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8036c3:	83 ec 0c             	sub    $0xc,%esp
  8036c6:	ff 75 0c             	pushl  0xc(%ebp)
  8036c9:	e8 3a eb ff ff       	call   802208 <alloc_block_FF>
  8036ce:	83 c4 10             	add    $0x10,%esp
  8036d1:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8036d4:	83 ec 08             	sub    $0x8,%esp
  8036d7:	ff 75 c0             	pushl  -0x40(%ebp)
  8036da:	ff 75 08             	pushl  0x8(%ebp)
  8036dd:	e8 ab fa ff ff       	call   80318d <copy_data>
  8036e2:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036e8:	e9 f8 01 00 00       	jmp    8038e5 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8036f3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8036f6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8036fa:	0f 87 a0 00 00 00    	ja     8037a0 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803700:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803704:	75 17                	jne    80371d <realloc_block_FF+0x551>
  803706:	83 ec 04             	sub    $0x4,%esp
  803709:	68 af 44 80 00       	push   $0x8044af
  80370e:	68 38 02 00 00       	push   $0x238
  803713:	68 cd 44 80 00       	push   $0x8044cd
  803718:	e8 7b cc ff ff       	call   800398 <_panic>
  80371d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803720:	8b 00                	mov    (%eax),%eax
  803722:	85 c0                	test   %eax,%eax
  803724:	74 10                	je     803736 <realloc_block_FF+0x56a>
  803726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803729:	8b 00                	mov    (%eax),%eax
  80372b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80372e:	8b 52 04             	mov    0x4(%edx),%edx
  803731:	89 50 04             	mov    %edx,0x4(%eax)
  803734:	eb 0b                	jmp    803741 <realloc_block_FF+0x575>
  803736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803739:	8b 40 04             	mov    0x4(%eax),%eax
  80373c:	a3 30 50 80 00       	mov    %eax,0x805030
  803741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803744:	8b 40 04             	mov    0x4(%eax),%eax
  803747:	85 c0                	test   %eax,%eax
  803749:	74 0f                	je     80375a <realloc_block_FF+0x58e>
  80374b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374e:	8b 40 04             	mov    0x4(%eax),%eax
  803751:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803754:	8b 12                	mov    (%edx),%edx
  803756:	89 10                	mov    %edx,(%eax)
  803758:	eb 0a                	jmp    803764 <realloc_block_FF+0x598>
  80375a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375d:	8b 00                	mov    (%eax),%eax
  80375f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803767:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80376d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803770:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803777:	a1 38 50 80 00       	mov    0x805038,%eax
  80377c:	48                   	dec    %eax
  80377d:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803782:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803785:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803788:	01 d0                	add    %edx,%eax
  80378a:	83 ec 04             	sub    $0x4,%esp
  80378d:	6a 01                	push   $0x1
  80378f:	50                   	push   %eax
  803790:	ff 75 08             	pushl  0x8(%ebp)
  803793:	e8 41 ea ff ff       	call   8021d9 <set_block_data>
  803798:	83 c4 10             	add    $0x10,%esp
  80379b:	e9 36 01 00 00       	jmp    8038d6 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8037a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037a6:	01 d0                	add    %edx,%eax
  8037a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8037ab:	83 ec 04             	sub    $0x4,%esp
  8037ae:	6a 01                	push   $0x1
  8037b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8037b3:	ff 75 08             	pushl  0x8(%ebp)
  8037b6:	e8 1e ea ff ff       	call   8021d9 <set_block_data>
  8037bb:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037be:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c1:	83 e8 04             	sub    $0x4,%eax
  8037c4:	8b 00                	mov    (%eax),%eax
  8037c6:	83 e0 fe             	and    $0xfffffffe,%eax
  8037c9:	89 c2                	mov    %eax,%edx
  8037cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ce:	01 d0                	add    %edx,%eax
  8037d0:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037d7:	74 06                	je     8037df <realloc_block_FF+0x613>
  8037d9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037dd:	75 17                	jne    8037f6 <realloc_block_FF+0x62a>
  8037df:	83 ec 04             	sub    $0x4,%esp
  8037e2:	68 40 45 80 00       	push   $0x804540
  8037e7:	68 44 02 00 00       	push   $0x244
  8037ec:	68 cd 44 80 00       	push   $0x8044cd
  8037f1:	e8 a2 cb ff ff       	call   800398 <_panic>
  8037f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f9:	8b 10                	mov    (%eax),%edx
  8037fb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037fe:	89 10                	mov    %edx,(%eax)
  803800:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803803:	8b 00                	mov    (%eax),%eax
  803805:	85 c0                	test   %eax,%eax
  803807:	74 0b                	je     803814 <realloc_block_FF+0x648>
  803809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380c:	8b 00                	mov    (%eax),%eax
  80380e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803811:	89 50 04             	mov    %edx,0x4(%eax)
  803814:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803817:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80381a:	89 10                	mov    %edx,(%eax)
  80381c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80381f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803822:	89 50 04             	mov    %edx,0x4(%eax)
  803825:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803828:	8b 00                	mov    (%eax),%eax
  80382a:	85 c0                	test   %eax,%eax
  80382c:	75 08                	jne    803836 <realloc_block_FF+0x66a>
  80382e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803831:	a3 30 50 80 00       	mov    %eax,0x805030
  803836:	a1 38 50 80 00       	mov    0x805038,%eax
  80383b:	40                   	inc    %eax
  80383c:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803845:	75 17                	jne    80385e <realloc_block_FF+0x692>
  803847:	83 ec 04             	sub    $0x4,%esp
  80384a:	68 af 44 80 00       	push   $0x8044af
  80384f:	68 45 02 00 00       	push   $0x245
  803854:	68 cd 44 80 00       	push   $0x8044cd
  803859:	e8 3a cb ff ff       	call   800398 <_panic>
  80385e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803861:	8b 00                	mov    (%eax),%eax
  803863:	85 c0                	test   %eax,%eax
  803865:	74 10                	je     803877 <realloc_block_FF+0x6ab>
  803867:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386a:	8b 00                	mov    (%eax),%eax
  80386c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80386f:	8b 52 04             	mov    0x4(%edx),%edx
  803872:	89 50 04             	mov    %edx,0x4(%eax)
  803875:	eb 0b                	jmp    803882 <realloc_block_FF+0x6b6>
  803877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387a:	8b 40 04             	mov    0x4(%eax),%eax
  80387d:	a3 30 50 80 00       	mov    %eax,0x805030
  803882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803885:	8b 40 04             	mov    0x4(%eax),%eax
  803888:	85 c0                	test   %eax,%eax
  80388a:	74 0f                	je     80389b <realloc_block_FF+0x6cf>
  80388c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388f:	8b 40 04             	mov    0x4(%eax),%eax
  803892:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803895:	8b 12                	mov    (%edx),%edx
  803897:	89 10                	mov    %edx,(%eax)
  803899:	eb 0a                	jmp    8038a5 <realloc_block_FF+0x6d9>
  80389b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389e:	8b 00                	mov    (%eax),%eax
  8038a0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8038bd:	48                   	dec    %eax
  8038be:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8038c3:	83 ec 04             	sub    $0x4,%esp
  8038c6:	6a 00                	push   $0x0
  8038c8:	ff 75 bc             	pushl  -0x44(%ebp)
  8038cb:	ff 75 b8             	pushl  -0x48(%ebp)
  8038ce:	e8 06 e9 ff ff       	call   8021d9 <set_block_data>
  8038d3:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	eb 0a                	jmp    8038e5 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8038db:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038e5:	c9                   	leave  
  8038e6:	c3                   	ret    

008038e7 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038e7:	55                   	push   %ebp
  8038e8:	89 e5                	mov    %esp,%ebp
  8038ea:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038ed:	83 ec 04             	sub    $0x4,%esp
  8038f0:	68 c4 45 80 00       	push   $0x8045c4
  8038f5:	68 58 02 00 00       	push   $0x258
  8038fa:	68 cd 44 80 00       	push   $0x8044cd
  8038ff:	e8 94 ca ff ff       	call   800398 <_panic>

00803904 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803904:	55                   	push   %ebp
  803905:	89 e5                	mov    %esp,%ebp
  803907:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80390a:	83 ec 04             	sub    $0x4,%esp
  80390d:	68 ec 45 80 00       	push   $0x8045ec
  803912:	68 61 02 00 00       	push   $0x261
  803917:	68 cd 44 80 00       	push   $0x8044cd
  80391c:	e8 77 ca ff ff       	call   800398 <_panic>
  803921:	66 90                	xchg   %ax,%ax
  803923:	90                   	nop

00803924 <__udivdi3>:
  803924:	55                   	push   %ebp
  803925:	57                   	push   %edi
  803926:	56                   	push   %esi
  803927:	53                   	push   %ebx
  803928:	83 ec 1c             	sub    $0x1c,%esp
  80392b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80392f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803933:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803937:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80393b:	89 ca                	mov    %ecx,%edx
  80393d:	89 f8                	mov    %edi,%eax
  80393f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803943:	85 f6                	test   %esi,%esi
  803945:	75 2d                	jne    803974 <__udivdi3+0x50>
  803947:	39 cf                	cmp    %ecx,%edi
  803949:	77 65                	ja     8039b0 <__udivdi3+0x8c>
  80394b:	89 fd                	mov    %edi,%ebp
  80394d:	85 ff                	test   %edi,%edi
  80394f:	75 0b                	jne    80395c <__udivdi3+0x38>
  803951:	b8 01 00 00 00       	mov    $0x1,%eax
  803956:	31 d2                	xor    %edx,%edx
  803958:	f7 f7                	div    %edi
  80395a:	89 c5                	mov    %eax,%ebp
  80395c:	31 d2                	xor    %edx,%edx
  80395e:	89 c8                	mov    %ecx,%eax
  803960:	f7 f5                	div    %ebp
  803962:	89 c1                	mov    %eax,%ecx
  803964:	89 d8                	mov    %ebx,%eax
  803966:	f7 f5                	div    %ebp
  803968:	89 cf                	mov    %ecx,%edi
  80396a:	89 fa                	mov    %edi,%edx
  80396c:	83 c4 1c             	add    $0x1c,%esp
  80396f:	5b                   	pop    %ebx
  803970:	5e                   	pop    %esi
  803971:	5f                   	pop    %edi
  803972:	5d                   	pop    %ebp
  803973:	c3                   	ret    
  803974:	39 ce                	cmp    %ecx,%esi
  803976:	77 28                	ja     8039a0 <__udivdi3+0x7c>
  803978:	0f bd fe             	bsr    %esi,%edi
  80397b:	83 f7 1f             	xor    $0x1f,%edi
  80397e:	75 40                	jne    8039c0 <__udivdi3+0x9c>
  803980:	39 ce                	cmp    %ecx,%esi
  803982:	72 0a                	jb     80398e <__udivdi3+0x6a>
  803984:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803988:	0f 87 9e 00 00 00    	ja     803a2c <__udivdi3+0x108>
  80398e:	b8 01 00 00 00       	mov    $0x1,%eax
  803993:	89 fa                	mov    %edi,%edx
  803995:	83 c4 1c             	add    $0x1c,%esp
  803998:	5b                   	pop    %ebx
  803999:	5e                   	pop    %esi
  80399a:	5f                   	pop    %edi
  80399b:	5d                   	pop    %ebp
  80399c:	c3                   	ret    
  80399d:	8d 76 00             	lea    0x0(%esi),%esi
  8039a0:	31 ff                	xor    %edi,%edi
  8039a2:	31 c0                	xor    %eax,%eax
  8039a4:	89 fa                	mov    %edi,%edx
  8039a6:	83 c4 1c             	add    $0x1c,%esp
  8039a9:	5b                   	pop    %ebx
  8039aa:	5e                   	pop    %esi
  8039ab:	5f                   	pop    %edi
  8039ac:	5d                   	pop    %ebp
  8039ad:	c3                   	ret    
  8039ae:	66 90                	xchg   %ax,%ax
  8039b0:	89 d8                	mov    %ebx,%eax
  8039b2:	f7 f7                	div    %edi
  8039b4:	31 ff                	xor    %edi,%edi
  8039b6:	89 fa                	mov    %edi,%edx
  8039b8:	83 c4 1c             	add    $0x1c,%esp
  8039bb:	5b                   	pop    %ebx
  8039bc:	5e                   	pop    %esi
  8039bd:	5f                   	pop    %edi
  8039be:	5d                   	pop    %ebp
  8039bf:	c3                   	ret    
  8039c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039c5:	89 eb                	mov    %ebp,%ebx
  8039c7:	29 fb                	sub    %edi,%ebx
  8039c9:	89 f9                	mov    %edi,%ecx
  8039cb:	d3 e6                	shl    %cl,%esi
  8039cd:	89 c5                	mov    %eax,%ebp
  8039cf:	88 d9                	mov    %bl,%cl
  8039d1:	d3 ed                	shr    %cl,%ebp
  8039d3:	89 e9                	mov    %ebp,%ecx
  8039d5:	09 f1                	or     %esi,%ecx
  8039d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039db:	89 f9                	mov    %edi,%ecx
  8039dd:	d3 e0                	shl    %cl,%eax
  8039df:	89 c5                	mov    %eax,%ebp
  8039e1:	89 d6                	mov    %edx,%esi
  8039e3:	88 d9                	mov    %bl,%cl
  8039e5:	d3 ee                	shr    %cl,%esi
  8039e7:	89 f9                	mov    %edi,%ecx
  8039e9:	d3 e2                	shl    %cl,%edx
  8039eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ef:	88 d9                	mov    %bl,%cl
  8039f1:	d3 e8                	shr    %cl,%eax
  8039f3:	09 c2                	or     %eax,%edx
  8039f5:	89 d0                	mov    %edx,%eax
  8039f7:	89 f2                	mov    %esi,%edx
  8039f9:	f7 74 24 0c          	divl   0xc(%esp)
  8039fd:	89 d6                	mov    %edx,%esi
  8039ff:	89 c3                	mov    %eax,%ebx
  803a01:	f7 e5                	mul    %ebp
  803a03:	39 d6                	cmp    %edx,%esi
  803a05:	72 19                	jb     803a20 <__udivdi3+0xfc>
  803a07:	74 0b                	je     803a14 <__udivdi3+0xf0>
  803a09:	89 d8                	mov    %ebx,%eax
  803a0b:	31 ff                	xor    %edi,%edi
  803a0d:	e9 58 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a12:	66 90                	xchg   %ax,%ax
  803a14:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a18:	89 f9                	mov    %edi,%ecx
  803a1a:	d3 e2                	shl    %cl,%edx
  803a1c:	39 c2                	cmp    %eax,%edx
  803a1e:	73 e9                	jae    803a09 <__udivdi3+0xe5>
  803a20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a23:	31 ff                	xor    %edi,%edi
  803a25:	e9 40 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a2a:	66 90                	xchg   %ax,%ax
  803a2c:	31 c0                	xor    %eax,%eax
  803a2e:	e9 37 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a33:	90                   	nop

00803a34 <__umoddi3>:
  803a34:	55                   	push   %ebp
  803a35:	57                   	push   %edi
  803a36:	56                   	push   %esi
  803a37:	53                   	push   %ebx
  803a38:	83 ec 1c             	sub    $0x1c,%esp
  803a3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a47:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a4f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a53:	89 f3                	mov    %esi,%ebx
  803a55:	89 fa                	mov    %edi,%edx
  803a57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a5b:	89 34 24             	mov    %esi,(%esp)
  803a5e:	85 c0                	test   %eax,%eax
  803a60:	75 1a                	jne    803a7c <__umoddi3+0x48>
  803a62:	39 f7                	cmp    %esi,%edi
  803a64:	0f 86 a2 00 00 00    	jbe    803b0c <__umoddi3+0xd8>
  803a6a:	89 c8                	mov    %ecx,%eax
  803a6c:	89 f2                	mov    %esi,%edx
  803a6e:	f7 f7                	div    %edi
  803a70:	89 d0                	mov    %edx,%eax
  803a72:	31 d2                	xor    %edx,%edx
  803a74:	83 c4 1c             	add    $0x1c,%esp
  803a77:	5b                   	pop    %ebx
  803a78:	5e                   	pop    %esi
  803a79:	5f                   	pop    %edi
  803a7a:	5d                   	pop    %ebp
  803a7b:	c3                   	ret    
  803a7c:	39 f0                	cmp    %esi,%eax
  803a7e:	0f 87 ac 00 00 00    	ja     803b30 <__umoddi3+0xfc>
  803a84:	0f bd e8             	bsr    %eax,%ebp
  803a87:	83 f5 1f             	xor    $0x1f,%ebp
  803a8a:	0f 84 ac 00 00 00    	je     803b3c <__umoddi3+0x108>
  803a90:	bf 20 00 00 00       	mov    $0x20,%edi
  803a95:	29 ef                	sub    %ebp,%edi
  803a97:	89 fe                	mov    %edi,%esi
  803a99:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a9d:	89 e9                	mov    %ebp,%ecx
  803a9f:	d3 e0                	shl    %cl,%eax
  803aa1:	89 d7                	mov    %edx,%edi
  803aa3:	89 f1                	mov    %esi,%ecx
  803aa5:	d3 ef                	shr    %cl,%edi
  803aa7:	09 c7                	or     %eax,%edi
  803aa9:	89 e9                	mov    %ebp,%ecx
  803aab:	d3 e2                	shl    %cl,%edx
  803aad:	89 14 24             	mov    %edx,(%esp)
  803ab0:	89 d8                	mov    %ebx,%eax
  803ab2:	d3 e0                	shl    %cl,%eax
  803ab4:	89 c2                	mov    %eax,%edx
  803ab6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aba:	d3 e0                	shl    %cl,%eax
  803abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ac0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ac4:	89 f1                	mov    %esi,%ecx
  803ac6:	d3 e8                	shr    %cl,%eax
  803ac8:	09 d0                	or     %edx,%eax
  803aca:	d3 eb                	shr    %cl,%ebx
  803acc:	89 da                	mov    %ebx,%edx
  803ace:	f7 f7                	div    %edi
  803ad0:	89 d3                	mov    %edx,%ebx
  803ad2:	f7 24 24             	mull   (%esp)
  803ad5:	89 c6                	mov    %eax,%esi
  803ad7:	89 d1                	mov    %edx,%ecx
  803ad9:	39 d3                	cmp    %edx,%ebx
  803adb:	0f 82 87 00 00 00    	jb     803b68 <__umoddi3+0x134>
  803ae1:	0f 84 91 00 00 00    	je     803b78 <__umoddi3+0x144>
  803ae7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803aeb:	29 f2                	sub    %esi,%edx
  803aed:	19 cb                	sbb    %ecx,%ebx
  803aef:	89 d8                	mov    %ebx,%eax
  803af1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803af5:	d3 e0                	shl    %cl,%eax
  803af7:	89 e9                	mov    %ebp,%ecx
  803af9:	d3 ea                	shr    %cl,%edx
  803afb:	09 d0                	or     %edx,%eax
  803afd:	89 e9                	mov    %ebp,%ecx
  803aff:	d3 eb                	shr    %cl,%ebx
  803b01:	89 da                	mov    %ebx,%edx
  803b03:	83 c4 1c             	add    $0x1c,%esp
  803b06:	5b                   	pop    %ebx
  803b07:	5e                   	pop    %esi
  803b08:	5f                   	pop    %edi
  803b09:	5d                   	pop    %ebp
  803b0a:	c3                   	ret    
  803b0b:	90                   	nop
  803b0c:	89 fd                	mov    %edi,%ebp
  803b0e:	85 ff                	test   %edi,%edi
  803b10:	75 0b                	jne    803b1d <__umoddi3+0xe9>
  803b12:	b8 01 00 00 00       	mov    $0x1,%eax
  803b17:	31 d2                	xor    %edx,%edx
  803b19:	f7 f7                	div    %edi
  803b1b:	89 c5                	mov    %eax,%ebp
  803b1d:	89 f0                	mov    %esi,%eax
  803b1f:	31 d2                	xor    %edx,%edx
  803b21:	f7 f5                	div    %ebp
  803b23:	89 c8                	mov    %ecx,%eax
  803b25:	f7 f5                	div    %ebp
  803b27:	89 d0                	mov    %edx,%eax
  803b29:	e9 44 ff ff ff       	jmp    803a72 <__umoddi3+0x3e>
  803b2e:	66 90                	xchg   %ax,%ax
  803b30:	89 c8                	mov    %ecx,%eax
  803b32:	89 f2                	mov    %esi,%edx
  803b34:	83 c4 1c             	add    $0x1c,%esp
  803b37:	5b                   	pop    %ebx
  803b38:	5e                   	pop    %esi
  803b39:	5f                   	pop    %edi
  803b3a:	5d                   	pop    %ebp
  803b3b:	c3                   	ret    
  803b3c:	3b 04 24             	cmp    (%esp),%eax
  803b3f:	72 06                	jb     803b47 <__umoddi3+0x113>
  803b41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b45:	77 0f                	ja     803b56 <__umoddi3+0x122>
  803b47:	89 f2                	mov    %esi,%edx
  803b49:	29 f9                	sub    %edi,%ecx
  803b4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b4f:	89 14 24             	mov    %edx,(%esp)
  803b52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b56:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b5a:	8b 14 24             	mov    (%esp),%edx
  803b5d:	83 c4 1c             	add    $0x1c,%esp
  803b60:	5b                   	pop    %ebx
  803b61:	5e                   	pop    %esi
  803b62:	5f                   	pop    %edi
  803b63:	5d                   	pop    %ebp
  803b64:	c3                   	ret    
  803b65:	8d 76 00             	lea    0x0(%esi),%esi
  803b68:	2b 04 24             	sub    (%esp),%eax
  803b6b:	19 fa                	sbb    %edi,%edx
  803b6d:	89 d1                	mov    %edx,%ecx
  803b6f:	89 c6                	mov    %eax,%esi
  803b71:	e9 71 ff ff ff       	jmp    803ae7 <__umoddi3+0xb3>
  803b76:	66 90                	xchg   %ax,%ax
  803b78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b7c:	72 ea                	jb     803b68 <__umoddi3+0x134>
  803b7e:	89 d9                	mov    %ebx,%ecx
  803b80:	e9 62 ff ff ff       	jmp    803ae7 <__umoddi3+0xb3>
