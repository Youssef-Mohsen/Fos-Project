
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
  80005c:	68 40 3d 80 00       	push   $0x803d40
  800061:	6a 0d                	push   $0xd
  800063:	68 5c 3d 80 00       	push   $0x803d5c
  800068:	e8 2b 03 00 00       	call   800398 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  800074:	e8 98 1c 00 00       	call   801d11 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int freeFrames, diff, expected;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 fb 19 00 00       	call   801a7c <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 a9 1a 00 00       	call   801b2f <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 77 3d 80 00       	push   $0x803d77
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 94 17 00 00       	call   80182d <sget>
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
  8000b6:	68 7c 3d 80 00       	push   $0x803d7c
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 5c 3d 80 00       	push   $0x803d5c
  8000c2:	e8 d1 02 00 00       	call   800398 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 59 1a 00 00       	call   801b2f <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 42 1a 00 00       	call   801b2f <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 f8 3d 80 00       	push   $0x803df8
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 5c 3d 80 00       	push   $0x803d5c
  800104:	e8 8f 02 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 88 19 00 00       	call   801a96 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 69 19 00 00       	call   801a7c <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 17 1a 00 00       	call   801b2f <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 90 3e 80 00       	push   $0x803e90
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 02 17 00 00       	call   80182d <sget>
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
  80014d:	68 7c 3d 80 00       	push   $0x803d7c
  800152:	6a 31                	push   $0x31
  800154:	68 5c 3d 80 00       	push   $0x803d5c
  800159:	e8 3a 02 00 00       	call   800398 <_panic>
		expected = 0;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 c2 19 00 00       	call   801b2f <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 ab 19 00 00       	call   801b2f <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 f8 3d 80 00       	push   $0x803df8
  800194:	6a 34                	push   $0x34
  800196:	68 5c 3d 80 00       	push   $0x803d5c
  80019b:	e8 f8 01 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 f1 18 00 00       	call   801a96 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 0a             	cmp    $0xa,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 94 3e 80 00       	push   $0x803e94
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 5c 3d 80 00       	push   $0x803d5c
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
  8001d9:	68 94 3e 80 00       	push   $0x803e94
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 5c 3d 80 00       	push   $0x803d5c
  8001e5:	e8 ae 01 00 00       	call   800398 <_panic>

	inctst();
  8001ea:	e8 47 1c 00 00       	call   801e36 <inctst>

	//sync with master
	while (gettst() != 5) ;
  8001ef:	90                   	nop
  8001f0:	e8 5b 1c 00 00       	call   801e50 <gettst>
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	75 f6                	jne    8001f0 <_main+0x1b8>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 06                	push   $0x6
  8001ff:	e8 ac 1b 00 00       	call   801db0 <sys_bypassPageFault>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	68 cc 3e 80 00       	push   $0x803ecc
  800212:	e8 3e 04 00 00       	call   800655 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 83 1b 00 00       	call   801db0 <sys_bypassPageFault>
  80022d:	83 c4 10             	add    $0x10,%esp

	inctst();
  800230:	e8 01 1c 00 00       	call   801e36 <inctst>
	if (*x == 100)
  800235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	83 f8 64             	cmp    $0x64,%eax
  80023d:	75 14                	jne    800253 <_main+0x21b>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 fc 3e 80 00       	push   $0x803efc
  800247:	6a 4d                	push   $0x4d
  800249:	68 5c 3d 80 00       	push   $0x803d5c
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
  80025f:	e8 94 1a 00 00       	call   801cf8 <sys_getenvindex>
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
  8002cd:	e8 aa 17 00 00       	call   801a7c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	68 5c 3f 80 00       	push   $0x803f5c
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
  8002fd:	68 84 3f 80 00       	push   $0x803f84
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
  80032e:	68 ac 3f 80 00       	push   $0x803fac
  800333:	e8 1d 03 00 00       	call   800655 <cprintf>
  800338:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80033b:	a1 20 50 80 00       	mov    0x805020,%eax
  800340:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	50                   	push   %eax
  80034a:	68 04 40 80 00       	push   $0x804004
  80034f:	e8 01 03 00 00       	call   800655 <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	68 5c 3f 80 00       	push   $0x803f5c
  80035f:	e8 f1 02 00 00       	call   800655 <cprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800367:	e8 2a 17 00 00       	call   801a96 <sys_unlock_cons>
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
  80037f:	e8 40 19 00 00       	call   801cc4 <sys_destroy_env>
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
  800390:	e8 95 19 00 00       	call   801d2a <sys_exit_env>
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
  8003a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8003ac:	85 c0                	test   %eax,%eax
  8003ae:	74 16                	je     8003c6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	50                   	push   %eax
  8003b9:	68 18 40 80 00       	push   $0x804018
  8003be:	e8 92 02 00 00       	call   800655 <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003c6:	a1 00 50 80 00       	mov    0x805000,%eax
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	50                   	push   %eax
  8003d2:	68 1d 40 80 00       	push   $0x80401d
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
  8003f6:	68 39 40 80 00       	push   $0x804039
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
  800425:	68 3c 40 80 00       	push   $0x80403c
  80042a:	6a 26                	push   $0x26
  80042c:	68 88 40 80 00       	push   $0x804088
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
  8004fa:	68 94 40 80 00       	push   $0x804094
  8004ff:	6a 3a                	push   $0x3a
  800501:	68 88 40 80 00       	push   $0x804088
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
  80056d:	68 e8 40 80 00       	push   $0x8040e8
  800572:	6a 44                	push   $0x44
  800574:	68 88 40 80 00       	push   $0x804088
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
  8005ac:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  8005c7:	e8 6e 14 00 00       	call   801a3a <sys_cputs>
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
  800621:	a0 2c 50 80 00       	mov    0x80502c,%al
  800626:	0f b6 c0             	movzbl %al,%eax
  800629:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	50                   	push   %eax
  800633:	52                   	push   %edx
  800634:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80063a:	83 c0 08             	add    $0x8,%eax
  80063d:	50                   	push   %eax
  80063e:	e8 f7 13 00 00       	call   801a3a <sys_cputs>
  800643:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800646:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  80065b:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  800688:	e8 ef 13 00 00       	call   801a7c <sys_lock_cons>
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
  8006a8:	e8 e9 13 00 00       	call   801a96 <sys_unlock_cons>
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
  8006f2:	e8 dd 33 00 00       	call   803ad4 <__udivdi3>
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
  800742:	e8 9d 34 00 00       	call   803be4 <__umoddi3>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	05 54 43 80 00       	add    $0x804354,%eax
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
  80089d:	8b 04 85 78 43 80 00 	mov    0x804378(,%eax,4),%eax
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
  80097e:	8b 34 9d c0 41 80 00 	mov    0x8041c0(,%ebx,4),%esi
  800985:	85 f6                	test   %esi,%esi
  800987:	75 19                	jne    8009a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800989:	53                   	push   %ebx
  80098a:	68 65 43 80 00       	push   $0x804365
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
  8009a3:	68 6e 43 80 00       	push   $0x80436e
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
  8009d0:	be 71 43 80 00       	mov    $0x804371,%esi
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
  800bc8:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800bcf:	eb 2c                	jmp    800bfd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bd1:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8013db:	68 e8 44 80 00       	push   $0x8044e8
  8013e0:	68 3f 01 00 00       	push   $0x13f
  8013e5:	68 0a 45 80 00       	push   $0x80450a
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
  8013fb:	e8 e5 0b 00 00       	call   801fe5 <sys_sbrk>
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
  801476:	e8 ee 09 00 00       	call   801e69 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80147b:	85 c0                	test   %eax,%eax
  80147d:	74 16                	je     801495 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	e8 2e 0f 00 00       	call   8023b8 <alloc_block_FF>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801490:	e9 8a 01 00 00       	jmp    80161f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801495:	e8 00 0a 00 00       	call   801e9a <sys_isUHeapPlacementStrategyBESTFIT>
  80149a:	85 c0                	test   %eax,%eax
  80149c:	0f 84 7d 01 00 00    	je     80161f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 c7 13 00 00       	call   802874 <alloc_block_BF>
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
  8014f8:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801545:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  80159c:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  8015fe:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801605:	83 ec 08             	sub    $0x8,%esp
  801608:	ff 75 08             	pushl  0x8(%ebp)
  80160b:	ff 75 f0             	pushl  -0x10(%ebp)
  80160e:	e8 09 0a 00 00       	call   80201c <sys_allocate_user_mem>
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
  801656:	e8 dd 09 00 00       	call   802038 <get_block_size>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	e8 10 1c 00 00       	call   80327c <free_block>
  80166c:	83 c4 10             	add    $0x10,%esp
		}

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
  8016a1:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  8016a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8016ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ae:	c1 e0 0c             	shl    $0xc,%eax
  8016b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8016b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016bb:	eb 42                	jmp    8016ff <free+0xdb>
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
  8016de:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  8016e5:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8016e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	52                   	push   %edx
  8016f3:	50                   	push   %eax
  8016f4:	e8 07 09 00 00       	call   802000 <sys_free_user_mem>
  8016f9:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8016fc:	ff 45 f4             	incl   -0xc(%ebp)
  8016ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801702:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801705:	72 b6                	jb     8016bd <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801707:	eb 17                	jmp    801720 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801709:	83 ec 04             	sub    $0x4,%esp
  80170c:	68 18 45 80 00       	push   $0x804518
  801711:	68 88 00 00 00       	push   $0x88
  801716:	68 42 45 80 00       	push   $0x804542
  80171b:	e8 78 ec ff ff       	call   800398 <_panic>
	}
}
  801720:	90                   	nop
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 28             	sub    $0x28,%esp
  801729:	8b 45 10             	mov    0x10(%ebp),%eax
  80172c:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80172f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801733:	75 0a                	jne    80173f <smalloc+0x1c>
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
  80173a:	e9 ec 00 00 00       	jmp    80182b <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80173f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801745:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80174c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801752:	39 d0                	cmp    %edx,%eax
  801754:	73 02                	jae    801758 <smalloc+0x35>
  801756:	89 d0                	mov    %edx,%eax
  801758:	83 ec 0c             	sub    $0xc,%esp
  80175b:	50                   	push   %eax
  80175c:	e8 a4 fc ff ff       	call   801405 <malloc>
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801767:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80176b:	75 0a                	jne    801777 <smalloc+0x54>
  80176d:	b8 00 00 00 00       	mov    $0x0,%eax
  801772:	e9 b4 00 00 00       	jmp    80182b <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801777:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80177b:	ff 75 ec             	pushl  -0x14(%ebp)
  80177e:	50                   	push   %eax
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	ff 75 08             	pushl  0x8(%ebp)
  801785:	e8 7d 04 00 00       	call   801c07 <sys_createSharedObject>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801790:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801794:	74 06                	je     80179c <smalloc+0x79>
  801796:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80179a:	75 0a                	jne    8017a6 <smalloc+0x83>
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a1:	e9 85 00 00 00       	jmp    80182b <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8017ac:	68 4e 45 80 00       	push   $0x80454e
  8017b1:	e8 9f ee ff ff       	call   800655 <cprintf>
  8017b6:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8017b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8017c1:	8b 40 78             	mov    0x78(%eax),%eax
  8017c4:	29 c2                	sub    %eax,%edx
  8017c6:	89 d0                	mov    %edx,%eax
  8017c8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017cd:	c1 e8 0c             	shr    $0xc,%eax
  8017d0:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8017d6:	42                   	inc    %edx
  8017d7:	89 15 24 50 80 00    	mov    %edx,0x805024
  8017dd:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8017e3:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8017ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8017f2:	8b 40 78             	mov    0x78(%eax),%eax
  8017f5:	29 c2                	sub    %eax,%edx
  8017f7:	89 d0                	mov    %edx,%eax
  8017f9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017fe:	c1 e8 0c             	shr    $0xc,%eax
  801801:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801808:	a1 20 50 80 00       	mov    0x805020,%eax
  80180d:	8b 50 10             	mov    0x10(%eax),%edx
  801810:	89 c8                	mov    %ecx,%eax
  801812:	c1 e0 02             	shl    $0x2,%eax
  801815:	89 c1                	mov    %eax,%ecx
  801817:	c1 e1 09             	shl    $0x9,%ecx
  80181a:	01 c8                	add    %ecx,%eax
  80181c:	01 c2                	add    %eax,%edx
  80181e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801821:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801828:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801833:	83 ec 08             	sub    $0x8,%esp
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	ff 75 08             	pushl  0x8(%ebp)
  80183c:	e8 f0 03 00 00       	call   801c31 <sys_getSizeOfSharedObject>
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801847:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80184b:	75 0a                	jne    801857 <sget+0x2a>
  80184d:	b8 00 00 00 00       	mov    $0x0,%eax
  801852:	e9 e7 00 00 00       	jmp    80193e <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80185d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801864:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186a:	39 d0                	cmp    %edx,%eax
  80186c:	73 02                	jae    801870 <sget+0x43>
  80186e:	89 d0                	mov    %edx,%eax
  801870:	83 ec 0c             	sub    $0xc,%esp
  801873:	50                   	push   %eax
  801874:	e8 8c fb ff ff       	call   801405 <malloc>
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80187f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801883:	75 0a                	jne    80188f <sget+0x62>
  801885:	b8 00 00 00 00       	mov    $0x0,%eax
  80188a:	e9 af 00 00 00       	jmp    80193e <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	ff 75 e8             	pushl  -0x18(%ebp)
  801895:	ff 75 0c             	pushl  0xc(%ebp)
  801898:	ff 75 08             	pushl  0x8(%ebp)
  80189b:	e8 ae 03 00 00       	call   801c4e <sys_getSharedObject>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8018a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8018ae:	8b 40 78             	mov    0x78(%eax),%eax
  8018b1:	29 c2                	sub    %eax,%edx
  8018b3:	89 d0                	mov    %edx,%eax
  8018b5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018ba:	c1 e8 0c             	shr    $0xc,%eax
  8018bd:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8018c3:	42                   	inc    %edx
  8018c4:	89 15 24 50 80 00    	mov    %edx,0x805024
  8018ca:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8018d0:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8018d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018da:	a1 20 50 80 00       	mov    0x805020,%eax
  8018df:	8b 40 78             	mov    0x78(%eax),%eax
  8018e2:	29 c2                	sub    %eax,%edx
  8018e4:	89 d0                	mov    %edx,%eax
  8018e6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018eb:	c1 e8 0c             	shr    $0xc,%eax
  8018ee:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8018f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8018fa:	8b 50 10             	mov    0x10(%eax),%edx
  8018fd:	89 c8                	mov    %ecx,%eax
  8018ff:	c1 e0 02             	shl    $0x2,%eax
  801902:	89 c1                	mov    %eax,%ecx
  801904:	c1 e1 09             	shl    $0x9,%ecx
  801907:	01 c8                	add    %ecx,%eax
  801909:	01 c2                	add    %eax,%edx
  80190b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80190e:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801915:	a1 20 50 80 00       	mov    0x805020,%eax
  80191a:	8b 40 10             	mov    0x10(%eax),%eax
  80191d:	83 ec 08             	sub    $0x8,%esp
  801920:	50                   	push   %eax
  801921:	68 5d 45 80 00       	push   $0x80455d
  801926:	e8 2a ed ff ff       	call   800655 <cprintf>
  80192b:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80192e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801932:	75 07                	jne    80193b <sget+0x10e>
  801934:	b8 00 00 00 00       	mov    $0x0,%eax
  801939:	eb 03                	jmp    80193e <sget+0x111>
	return ptr;
  80193b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801946:	8b 55 08             	mov    0x8(%ebp),%edx
  801949:	a1 20 50 80 00       	mov    0x805020,%eax
  80194e:	8b 40 78             	mov    0x78(%eax),%eax
  801951:	29 c2                	sub    %eax,%edx
  801953:	89 d0                	mov    %edx,%eax
  801955:	2d 00 10 00 00       	sub    $0x1000,%eax
  80195a:	c1 e8 0c             	shr    $0xc,%eax
  80195d:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801964:	a1 20 50 80 00       	mov    0x805020,%eax
  801969:	8b 50 10             	mov    0x10(%eax),%edx
  80196c:	89 c8                	mov    %ecx,%eax
  80196e:	c1 e0 02             	shl    $0x2,%eax
  801971:	89 c1                	mov    %eax,%ecx
  801973:	c1 e1 09             	shl    $0x9,%ecx
  801976:	01 c8                	add    %ecx,%eax
  801978:	01 d0                	add    %edx,%eax
  80197a:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801981:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	ff 75 08             	pushl  0x8(%ebp)
  80198a:	ff 75 f4             	pushl  -0xc(%ebp)
  80198d:	e8 db 02 00 00       	call   801c6d <sys_freeSharedObject>
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019a1:	83 ec 04             	sub    $0x4,%esp
  8019a4:	68 6c 45 80 00       	push   $0x80456c
  8019a9:	68 e5 00 00 00       	push   $0xe5
  8019ae:	68 42 45 80 00       	push   $0x804542
  8019b3:	e8 e0 e9 ff ff       	call   800398 <_panic>

008019b8 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019be:	83 ec 04             	sub    $0x4,%esp
  8019c1:	68 92 45 80 00       	push   $0x804592
  8019c6:	68 f1 00 00 00       	push   $0xf1
  8019cb:	68 42 45 80 00       	push   $0x804542
  8019d0:	e8 c3 e9 ff ff       	call   800398 <_panic>

008019d5 <shrink>:

}
void shrink(uint32 newSize)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019db:	83 ec 04             	sub    $0x4,%esp
  8019de:	68 92 45 80 00       	push   $0x804592
  8019e3:	68 f6 00 00 00       	push   $0xf6
  8019e8:	68 42 45 80 00       	push   $0x804542
  8019ed:	e8 a6 e9 ff ff       	call   800398 <_panic>

008019f2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	68 92 45 80 00       	push   $0x804592
  801a00:	68 fb 00 00 00       	push   $0xfb
  801a05:	68 42 45 80 00       	push   $0x804542
  801a0a:	e8 89 e9 ff ff       	call   800398 <_panic>

00801a0f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	57                   	push   %edi
  801a13:	56                   	push   %esi
  801a14:	53                   	push   %ebx
  801a15:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a21:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a24:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a27:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a2a:	cd 30                	int    $0x30
  801a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a32:	83 c4 10             	add    $0x10,%esp
  801a35:	5b                   	pop    %ebx
  801a36:	5e                   	pop    %esi
  801a37:	5f                   	pop    %edi
  801a38:	5d                   	pop    %ebp
  801a39:	c3                   	ret    

00801a3a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	8b 45 10             	mov    0x10(%ebp),%eax
  801a43:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a46:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	52                   	push   %edx
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	50                   	push   %eax
  801a56:	6a 00                	push   $0x0
  801a58:	e8 b2 ff ff ff       	call   801a0f <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	90                   	nop
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 02                	push   $0x2
  801a72:	e8 98 ff ff ff       	call   801a0f <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 03                	push   $0x3
  801a8b:	e8 7f ff ff ff       	call   801a0f <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 04                	push   $0x4
  801aa5:	e8 65 ff ff ff       	call   801a0f <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	90                   	nop
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	52                   	push   %edx
  801ac0:	50                   	push   %eax
  801ac1:	6a 08                	push   $0x8
  801ac3:	e8 47 ff ff ff       	call   801a0f <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	56                   	push   %esi
  801ad1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ad2:	8b 75 18             	mov    0x18(%ebp),%esi
  801ad5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	56                   	push   %esi
  801ae2:	53                   	push   %ebx
  801ae3:	51                   	push   %ecx
  801ae4:	52                   	push   %edx
  801ae5:	50                   	push   %eax
  801ae6:	6a 09                	push   $0x9
  801ae8:	e8 22 ff ff ff       	call   801a0f <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af3:	5b                   	pop    %ebx
  801af4:	5e                   	pop    %esi
  801af5:	5d                   	pop    %ebp
  801af6:	c3                   	ret    

00801af7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 0a                	push   $0xa
  801b0a:	e8 00 ff ff ff       	call   801a0f <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	6a 0b                	push   $0xb
  801b25:	e8 e5 fe ff ff       	call   801a0f <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 0c                	push   $0xc
  801b3e:	e8 cc fe ff ff       	call   801a0f <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 0d                	push   $0xd
  801b57:	e8 b3 fe ff ff       	call   801a0f <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 0e                	push   $0xe
  801b70:	e8 9a fe ff ff       	call   801a0f <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 0f                	push   $0xf
  801b89:	e8 81 fe ff ff       	call   801a0f <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	ff 75 08             	pushl  0x8(%ebp)
  801ba1:	6a 10                	push   $0x10
  801ba3:	e8 67 fe ff ff       	call   801a0f <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 11                	push   $0x11
  801bbc:	e8 4e fe ff ff       	call   801a0f <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	90                   	nop
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_cputc>:

void
sys_cputc(const char c)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 04             	sub    $0x4,%esp
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bd3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	50                   	push   %eax
  801be0:	6a 01                	push   $0x1
  801be2:	e8 28 fe ff ff       	call   801a0f <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	90                   	nop
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 14                	push   $0x14
  801bfc:	e8 0e fe ff ff       	call   801a0f <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	90                   	nop
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 04             	sub    $0x4,%esp
  801c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c10:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c13:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c16:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	6a 00                	push   $0x0
  801c1f:	51                   	push   %ecx
  801c20:	52                   	push   %edx
  801c21:	ff 75 0c             	pushl  0xc(%ebp)
  801c24:	50                   	push   %eax
  801c25:	6a 15                	push   $0x15
  801c27:	e8 e3 fd ff ff       	call   801a0f <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	52                   	push   %edx
  801c41:	50                   	push   %eax
  801c42:	6a 16                	push   $0x16
  801c44:	e8 c6 fd ff ff       	call   801a0f <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	51                   	push   %ecx
  801c5f:	52                   	push   %edx
  801c60:	50                   	push   %eax
  801c61:	6a 17                	push   $0x17
  801c63:	e8 a7 fd ff ff       	call   801a0f <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	52                   	push   %edx
  801c7d:	50                   	push   %eax
  801c7e:	6a 18                	push   $0x18
  801c80:	e8 8a fd ff ff       	call   801a0f <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	6a 00                	push   $0x0
  801c92:	ff 75 14             	pushl  0x14(%ebp)
  801c95:	ff 75 10             	pushl  0x10(%ebp)
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	50                   	push   %eax
  801c9c:	6a 19                	push   $0x19
  801c9e:	e8 6c fd ff ff       	call   801a0f <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	50                   	push   %eax
  801cb7:	6a 1a                	push   $0x1a
  801cb9:	e8 51 fd ff ff       	call   801a0f <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
}
  801cc1:	90                   	nop
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	50                   	push   %eax
  801cd3:	6a 1b                	push   $0x1b
  801cd5:	e8 35 fd ff ff       	call   801a0f <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 05                	push   $0x5
  801cee:	e8 1c fd ff ff       	call   801a0f <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 06                	push   $0x6
  801d07:	e8 03 fd ff ff       	call   801a0f <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 07                	push   $0x7
  801d20:	e8 ea fc ff ff       	call   801a0f <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_exit_env>:


void sys_exit_env(void)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 1c                	push   $0x1c
  801d39:	e8 d1 fc ff ff       	call   801a0f <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
}
  801d41:	90                   	nop
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d4a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d4d:	8d 50 04             	lea    0x4(%eax),%edx
  801d50:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	52                   	push   %edx
  801d5a:	50                   	push   %eax
  801d5b:	6a 1d                	push   $0x1d
  801d5d:	e8 ad fc ff ff       	call   801a0f <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
	return result;
  801d65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d6e:	89 01                	mov    %eax,(%ecx)
  801d70:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	c9                   	leave  
  801d77:	c2 04 00             	ret    $0x4

00801d7a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	ff 75 10             	pushl  0x10(%ebp)
  801d84:	ff 75 0c             	pushl  0xc(%ebp)
  801d87:	ff 75 08             	pushl  0x8(%ebp)
  801d8a:	6a 13                	push   $0x13
  801d8c:	e8 7e fc ff ff       	call   801a0f <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
	return ;
  801d94:	90                   	nop
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 1e                	push   $0x1e
  801da6:	e8 64 fc ff ff       	call   801a0f <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 04             	sub    $0x4,%esp
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dbc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	50                   	push   %eax
  801dc9:	6a 1f                	push   $0x1f
  801dcb:	e8 3f fc ff ff       	call   801a0f <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd3:	90                   	nop
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <rsttst>:
void rsttst()
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 21                	push   $0x21
  801de5:	e8 25 fc ff ff       	call   801a0f <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ded:	90                   	nop
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 04             	sub    $0x4,%esp
  801df6:	8b 45 14             	mov    0x14(%ebp),%eax
  801df9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dfc:	8b 55 18             	mov    0x18(%ebp),%edx
  801dff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e03:	52                   	push   %edx
  801e04:	50                   	push   %eax
  801e05:	ff 75 10             	pushl  0x10(%ebp)
  801e08:	ff 75 0c             	pushl  0xc(%ebp)
  801e0b:	ff 75 08             	pushl  0x8(%ebp)
  801e0e:	6a 20                	push   $0x20
  801e10:	e8 fa fb ff ff       	call   801a0f <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
	return ;
  801e18:	90                   	nop
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <chktst>:
void chktst(uint32 n)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	ff 75 08             	pushl  0x8(%ebp)
  801e29:	6a 22                	push   $0x22
  801e2b:	e8 df fb ff ff       	call   801a0f <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
	return ;
  801e33:	90                   	nop
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <inctst>:

void inctst()
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 23                	push   $0x23
  801e45:	e8 c5 fb ff ff       	call   801a0f <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4d:	90                   	nop
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <gettst>:
uint32 gettst()
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 24                	push   $0x24
  801e5f:	e8 ab fb ff ff       	call   801a0f <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 25                	push   $0x25
  801e7b:	e8 8f fb ff ff       	call   801a0f <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
  801e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e86:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e8a:	75 07                	jne    801e93 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e91:	eb 05                	jmp    801e98 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 25                	push   $0x25
  801eac:	e8 5e fb ff ff       	call   801a0f <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
  801eb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eb7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ebb:	75 07                	jne    801ec4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ebd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec2:	eb 05                	jmp    801ec9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 25                	push   $0x25
  801edd:	e8 2d fb ff ff       	call   801a0f <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
  801ee5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ee8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eec:	75 07                	jne    801ef5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef3:	eb 05                	jmp    801efa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 25                	push   $0x25
  801f0e:	e8 fc fa ff ff       	call   801a0f <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
  801f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f19:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f1d:	75 07                	jne    801f26 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f24:	eb 05                	jmp    801f2b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	ff 75 08             	pushl  0x8(%ebp)
  801f3b:	6a 26                	push   $0x26
  801f3d:	e8 cd fa ff ff       	call   801a0f <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
	return ;
  801f45:	90                   	nop
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f4c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	6a 00                	push   $0x0
  801f5a:	53                   	push   %ebx
  801f5b:	51                   	push   %ecx
  801f5c:	52                   	push   %edx
  801f5d:	50                   	push   %eax
  801f5e:	6a 27                	push   $0x27
  801f60:	e8 aa fa ff ff       	call   801a0f <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	52                   	push   %edx
  801f7d:	50                   	push   %eax
  801f7e:	6a 28                	push   $0x28
  801f80:	e8 8a fa ff ff       	call   801a0f <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f8d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	6a 00                	push   $0x0
  801f98:	51                   	push   %ecx
  801f99:	ff 75 10             	pushl  0x10(%ebp)
  801f9c:	52                   	push   %edx
  801f9d:	50                   	push   %eax
  801f9e:	6a 29                	push   $0x29
  801fa0:	e8 6a fa ff ff       	call   801a0f <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	ff 75 10             	pushl  0x10(%ebp)
  801fb4:	ff 75 0c             	pushl  0xc(%ebp)
  801fb7:	ff 75 08             	pushl  0x8(%ebp)
  801fba:	6a 12                	push   $0x12
  801fbc:	e8 4e fa ff ff       	call   801a0f <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc4:	90                   	nop
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	52                   	push   %edx
  801fd7:	50                   	push   %eax
  801fd8:	6a 2a                	push   $0x2a
  801fda:	e8 30 fa ff ff       	call   801a0f <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
	return;
  801fe2:	90                   	nop
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	50                   	push   %eax
  801ff4:	6a 2b                	push   $0x2b
  801ff6:	e8 14 fa ff ff       	call   801a0f <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	ff 75 0c             	pushl  0xc(%ebp)
  80200c:	ff 75 08             	pushl  0x8(%ebp)
  80200f:	6a 2c                	push   $0x2c
  802011:	e8 f9 f9 ff ff       	call   801a0f <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
	return;
  802019:	90                   	nop
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	ff 75 0c             	pushl  0xc(%ebp)
  802028:	ff 75 08             	pushl  0x8(%ebp)
  80202b:	6a 2d                	push   $0x2d
  80202d:	e8 dd f9 ff ff       	call   801a0f <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
	return;
  802035:	90                   	nop
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	83 e8 04             	sub    $0x4,%eax
  802044:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802047:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204a:	8b 00                	mov    (%eax),%eax
  80204c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	83 e8 04             	sub    $0x4,%eax
  80205d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802060:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802063:	8b 00                	mov    (%eax),%eax
  802065:	83 e0 01             	and    $0x1,%eax
  802068:	85 c0                	test   %eax,%eax
  80206a:	0f 94 c0             	sete   %al
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802075:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80207c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207f:	83 f8 02             	cmp    $0x2,%eax
  802082:	74 2b                	je     8020af <alloc_block+0x40>
  802084:	83 f8 02             	cmp    $0x2,%eax
  802087:	7f 07                	jg     802090 <alloc_block+0x21>
  802089:	83 f8 01             	cmp    $0x1,%eax
  80208c:	74 0e                	je     80209c <alloc_block+0x2d>
  80208e:	eb 58                	jmp    8020e8 <alloc_block+0x79>
  802090:	83 f8 03             	cmp    $0x3,%eax
  802093:	74 2d                	je     8020c2 <alloc_block+0x53>
  802095:	83 f8 04             	cmp    $0x4,%eax
  802098:	74 3b                	je     8020d5 <alloc_block+0x66>
  80209a:	eb 4c                	jmp    8020e8 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	ff 75 08             	pushl  0x8(%ebp)
  8020a2:	e8 11 03 00 00       	call   8023b8 <alloc_block_FF>
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020ad:	eb 4a                	jmp    8020f9 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020af:	83 ec 0c             	sub    $0xc,%esp
  8020b2:	ff 75 08             	pushl  0x8(%ebp)
  8020b5:	e8 fa 19 00 00       	call   803ab4 <alloc_block_NF>
  8020ba:	83 c4 10             	add    $0x10,%esp
  8020bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020c0:	eb 37                	jmp    8020f9 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020c2:	83 ec 0c             	sub    $0xc,%esp
  8020c5:	ff 75 08             	pushl  0x8(%ebp)
  8020c8:	e8 a7 07 00 00       	call   802874 <alloc_block_BF>
  8020cd:	83 c4 10             	add    $0x10,%esp
  8020d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020d3:	eb 24                	jmp    8020f9 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	ff 75 08             	pushl  0x8(%ebp)
  8020db:	e8 b7 19 00 00       	call   803a97 <alloc_block_WF>
  8020e0:	83 c4 10             	add    $0x10,%esp
  8020e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e6:	eb 11                	jmp    8020f9 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020e8:	83 ec 0c             	sub    $0xc,%esp
  8020eb:	68 a4 45 80 00       	push   $0x8045a4
  8020f0:	e8 60 e5 ff ff       	call   800655 <cprintf>
  8020f5:	83 c4 10             	add    $0x10,%esp
		break;
  8020f8:	90                   	nop
	}
	return va;
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	53                   	push   %ebx
  802102:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	68 c4 45 80 00       	push   $0x8045c4
  80210d:	e8 43 e5 ff ff       	call   800655 <cprintf>
  802112:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802115:	83 ec 0c             	sub    $0xc,%esp
  802118:	68 ef 45 80 00       	push   $0x8045ef
  80211d:	e8 33 e5 ff ff       	call   800655 <cprintf>
  802122:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212b:	eb 37                	jmp    802164 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80212d:	83 ec 0c             	sub    $0xc,%esp
  802130:	ff 75 f4             	pushl  -0xc(%ebp)
  802133:	e8 19 ff ff ff       	call   802051 <is_free_block>
  802138:	83 c4 10             	add    $0x10,%esp
  80213b:	0f be d8             	movsbl %al,%ebx
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	ff 75 f4             	pushl  -0xc(%ebp)
  802144:	e8 ef fe ff ff       	call   802038 <get_block_size>
  802149:	83 c4 10             	add    $0x10,%esp
  80214c:	83 ec 04             	sub    $0x4,%esp
  80214f:	53                   	push   %ebx
  802150:	50                   	push   %eax
  802151:	68 07 46 80 00       	push   $0x804607
  802156:	e8 fa e4 ff ff       	call   800655 <cprintf>
  80215b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80215e:	8b 45 10             	mov    0x10(%ebp),%eax
  802161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802164:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802168:	74 07                	je     802171 <print_blocks_list+0x73>
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 00                	mov    (%eax),%eax
  80216f:	eb 05                	jmp    802176 <print_blocks_list+0x78>
  802171:	b8 00 00 00 00       	mov    $0x0,%eax
  802176:	89 45 10             	mov    %eax,0x10(%ebp)
  802179:	8b 45 10             	mov    0x10(%ebp),%eax
  80217c:	85 c0                	test   %eax,%eax
  80217e:	75 ad                	jne    80212d <print_blocks_list+0x2f>
  802180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802184:	75 a7                	jne    80212d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802186:	83 ec 0c             	sub    $0xc,%esp
  802189:	68 c4 45 80 00       	push   $0x8045c4
  80218e:	e8 c2 e4 ff ff       	call   800655 <cprintf>
  802193:	83 c4 10             	add    $0x10,%esp

}
  802196:	90                   	nop
  802197:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a5:	83 e0 01             	and    $0x1,%eax
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	74 03                	je     8021af <initialize_dynamic_allocator+0x13>
  8021ac:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021b3:	0f 84 c7 01 00 00    	je     802380 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021b9:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8021c0:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8021c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c9:	01 d0                	add    %edx,%eax
  8021cb:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8021d0:	0f 87 ad 01 00 00    	ja     802383 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	0f 89 a5 01 00 00    	jns    802386 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8021e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e7:	01 d0                	add    %edx,%eax
  8021e9:	83 e8 04             	sub    $0x4,%eax
  8021ec:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8021f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8021f8:	a1 30 50 80 00       	mov    0x805030,%eax
  8021fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802200:	e9 87 00 00 00       	jmp    80228c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802209:	75 14                	jne    80221f <initialize_dynamic_allocator+0x83>
  80220b:	83 ec 04             	sub    $0x4,%esp
  80220e:	68 1f 46 80 00       	push   $0x80461f
  802213:	6a 79                	push   $0x79
  802215:	68 3d 46 80 00       	push   $0x80463d
  80221a:	e8 79 e1 ff ff       	call   800398 <_panic>
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 00                	mov    (%eax),%eax
  802224:	85 c0                	test   %eax,%eax
  802226:	74 10                	je     802238 <initialize_dynamic_allocator+0x9c>
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	8b 00                	mov    (%eax),%eax
  80222d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802230:	8b 52 04             	mov    0x4(%edx),%edx
  802233:	89 50 04             	mov    %edx,0x4(%eax)
  802236:	eb 0b                	jmp    802243 <initialize_dynamic_allocator+0xa7>
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 40 04             	mov    0x4(%eax),%eax
  80223e:	a3 34 50 80 00       	mov    %eax,0x805034
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	8b 40 04             	mov    0x4(%eax),%eax
  802249:	85 c0                	test   %eax,%eax
  80224b:	74 0f                	je     80225c <initialize_dynamic_allocator+0xc0>
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 40 04             	mov    0x4(%eax),%eax
  802253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802256:	8b 12                	mov    (%edx),%edx
  802258:	89 10                	mov    %edx,(%eax)
  80225a:	eb 0a                	jmp    802266 <initialize_dynamic_allocator+0xca>
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 00                	mov    (%eax),%eax
  802261:	a3 30 50 80 00       	mov    %eax,0x805030
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802279:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80227e:	48                   	dec    %eax
  80227f:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802284:	a1 38 50 80 00       	mov    0x805038,%eax
  802289:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80228c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802290:	74 07                	je     802299 <initialize_dynamic_allocator+0xfd>
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	8b 00                	mov    (%eax),%eax
  802297:	eb 05                	jmp    80229e <initialize_dynamic_allocator+0x102>
  802299:	b8 00 00 00 00       	mov    $0x0,%eax
  80229e:	a3 38 50 80 00       	mov    %eax,0x805038
  8022a3:	a1 38 50 80 00       	mov    0x805038,%eax
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	0f 85 55 ff ff ff    	jne    802205 <initialize_dynamic_allocator+0x69>
  8022b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b4:	0f 85 4b ff ff ff    	jne    802205 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8022c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8022c9:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ce:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8022d3:	a1 44 50 80 00       	mov    0x805044,%eax
  8022d8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	83 c0 08             	add    $0x8,%eax
  8022e4:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	83 c0 04             	add    $0x4,%eax
  8022ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f0:	83 ea 08             	sub    $0x8,%edx
  8022f3:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	01 d0                	add    %edx,%eax
  8022fd:	83 e8 08             	sub    $0x8,%eax
  802300:	8b 55 0c             	mov    0xc(%ebp),%edx
  802303:	83 ea 08             	sub    $0x8,%edx
  802306:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802311:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802314:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80231b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80231f:	75 17                	jne    802338 <initialize_dynamic_allocator+0x19c>
  802321:	83 ec 04             	sub    $0x4,%esp
  802324:	68 58 46 80 00       	push   $0x804658
  802329:	68 90 00 00 00       	push   $0x90
  80232e:	68 3d 46 80 00       	push   $0x80463d
  802333:	e8 60 e0 ff ff       	call   800398 <_panic>
  802338:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80233e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802341:	89 10                	mov    %edx,(%eax)
  802343:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802346:	8b 00                	mov    (%eax),%eax
  802348:	85 c0                	test   %eax,%eax
  80234a:	74 0d                	je     802359 <initialize_dynamic_allocator+0x1bd>
  80234c:	a1 30 50 80 00       	mov    0x805030,%eax
  802351:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802354:	89 50 04             	mov    %edx,0x4(%eax)
  802357:	eb 08                	jmp    802361 <initialize_dynamic_allocator+0x1c5>
  802359:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235c:	a3 34 50 80 00       	mov    %eax,0x805034
  802361:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802364:	a3 30 50 80 00       	mov    %eax,0x805030
  802369:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802373:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802378:	40                   	inc    %eax
  802379:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80237e:	eb 07                	jmp    802387 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802380:	90                   	nop
  802381:	eb 04                	jmp    802387 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802383:	90                   	nop
  802384:	eb 01                	jmp    802387 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802386:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80238c:	8b 45 10             	mov    0x10(%ebp),%eax
  80238f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	8d 50 fc             	lea    -0x4(%eax),%edx
  802398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	83 e8 04             	sub    $0x4,%eax
  8023a3:	8b 00                	mov    (%eax),%eax
  8023a5:	83 e0 fe             	and    $0xfffffffe,%eax
  8023a8:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	01 c2                	add    %eax,%edx
  8023b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b3:	89 02                	mov    %eax,(%edx)
}
  8023b5:	90                   	nop
  8023b6:	5d                   	pop    %ebp
  8023b7:	c3                   	ret    

008023b8 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	83 e0 01             	and    $0x1,%eax
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	74 03                	je     8023cb <alloc_block_FF+0x13>
  8023c8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8023cb:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8023cf:	77 07                	ja     8023d8 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8023d1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8023d8:	a1 28 50 80 00       	mov    0x805028,%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	75 73                	jne    802454 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	83 c0 10             	add    $0x10,%eax
  8023e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8023ea:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f7:	01 d0                	add    %edx,%eax
  8023f9:	48                   	dec    %eax
  8023fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802400:	ba 00 00 00 00       	mov    $0x0,%edx
  802405:	f7 75 ec             	divl   -0x14(%ebp)
  802408:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80240b:	29 d0                	sub    %edx,%eax
  80240d:	c1 e8 0c             	shr    $0xc,%eax
  802410:	83 ec 0c             	sub    $0xc,%esp
  802413:	50                   	push   %eax
  802414:	e8 d6 ef ff ff       	call   8013ef <sbrk>
  802419:	83 c4 10             	add    $0x10,%esp
  80241c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80241f:	83 ec 0c             	sub    $0xc,%esp
  802422:	6a 00                	push   $0x0
  802424:	e8 c6 ef ff ff       	call   8013ef <sbrk>
  802429:	83 c4 10             	add    $0x10,%esp
  80242c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80242f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802432:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802435:	83 ec 08             	sub    $0x8,%esp
  802438:	50                   	push   %eax
  802439:	ff 75 e4             	pushl  -0x1c(%ebp)
  80243c:	e8 5b fd ff ff       	call   80219c <initialize_dynamic_allocator>
  802441:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802444:	83 ec 0c             	sub    $0xc,%esp
  802447:	68 7b 46 80 00       	push   $0x80467b
  80244c:	e8 04 e2 ff ff       	call   800655 <cprintf>
  802451:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802454:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802458:	75 0a                	jne    802464 <alloc_block_FF+0xac>
	        return NULL;
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	e9 0e 04 00 00       	jmp    802872 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802464:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80246b:	a1 30 50 80 00       	mov    0x805030,%eax
  802470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802473:	e9 f3 02 00 00       	jmp    80276b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80247e:	83 ec 0c             	sub    $0xc,%esp
  802481:	ff 75 bc             	pushl  -0x44(%ebp)
  802484:	e8 af fb ff ff       	call   802038 <get_block_size>
  802489:	83 c4 10             	add    $0x10,%esp
  80248c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	83 c0 08             	add    $0x8,%eax
  802495:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802498:	0f 87 c5 02 00 00    	ja     802763 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	83 c0 18             	add    $0x18,%eax
  8024a4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024a7:	0f 87 19 02 00 00    	ja     8026c6 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024b0:	2b 45 08             	sub    0x8(%ebp),%eax
  8024b3:	83 e8 08             	sub    $0x8,%eax
  8024b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	8d 50 08             	lea    0x8(%eax),%edx
  8024bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024c2:	01 d0                	add    %edx,%eax
  8024c4:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	83 c0 08             	add    $0x8,%eax
  8024cd:	83 ec 04             	sub    $0x4,%esp
  8024d0:	6a 01                	push   $0x1
  8024d2:	50                   	push   %eax
  8024d3:	ff 75 bc             	pushl  -0x44(%ebp)
  8024d6:	e8 ae fe ff ff       	call   802389 <set_block_data>
  8024db:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 04             	mov    0x4(%eax),%eax
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	75 68                	jne    802550 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024e8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024ec:	75 17                	jne    802505 <alloc_block_FF+0x14d>
  8024ee:	83 ec 04             	sub    $0x4,%esp
  8024f1:	68 58 46 80 00       	push   $0x804658
  8024f6:	68 d7 00 00 00       	push   $0xd7
  8024fb:	68 3d 46 80 00       	push   $0x80463d
  802500:	e8 93 de ff ff       	call   800398 <_panic>
  802505:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80250b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250e:	89 10                	mov    %edx,(%eax)
  802510:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	74 0d                	je     802526 <alloc_block_FF+0x16e>
  802519:	a1 30 50 80 00       	mov    0x805030,%eax
  80251e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802521:	89 50 04             	mov    %edx,0x4(%eax)
  802524:	eb 08                	jmp    80252e <alloc_block_FF+0x176>
  802526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802529:	a3 34 50 80 00       	mov    %eax,0x805034
  80252e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802531:	a3 30 50 80 00       	mov    %eax,0x805030
  802536:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802540:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802545:	40                   	inc    %eax
  802546:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80254b:	e9 dc 00 00 00       	jmp    80262c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 00                	mov    (%eax),%eax
  802555:	85 c0                	test   %eax,%eax
  802557:	75 65                	jne    8025be <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802559:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80255d:	75 17                	jne    802576 <alloc_block_FF+0x1be>
  80255f:	83 ec 04             	sub    $0x4,%esp
  802562:	68 8c 46 80 00       	push   $0x80468c
  802567:	68 db 00 00 00       	push   $0xdb
  80256c:	68 3d 46 80 00       	push   $0x80463d
  802571:	e8 22 de ff ff       	call   800398 <_panic>
  802576:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80257c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80257f:	89 50 04             	mov    %edx,0x4(%eax)
  802582:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802585:	8b 40 04             	mov    0x4(%eax),%eax
  802588:	85 c0                	test   %eax,%eax
  80258a:	74 0c                	je     802598 <alloc_block_FF+0x1e0>
  80258c:	a1 34 50 80 00       	mov    0x805034,%eax
  802591:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802594:	89 10                	mov    %edx,(%eax)
  802596:	eb 08                	jmp    8025a0 <alloc_block_FF+0x1e8>
  802598:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80259b:	a3 30 50 80 00       	mov    %eax,0x805030
  8025a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8025a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8025b6:	40                   	inc    %eax
  8025b7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8025bc:	eb 6e                	jmp    80262c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8025be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c2:	74 06                	je     8025ca <alloc_block_FF+0x212>
  8025c4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025c8:	75 17                	jne    8025e1 <alloc_block_FF+0x229>
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 b0 46 80 00       	push   $0x8046b0
  8025d2:	68 df 00 00 00       	push   $0xdf
  8025d7:	68 3d 46 80 00       	push   $0x80463d
  8025dc:	e8 b7 dd ff ff       	call   800398 <_panic>
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 10                	mov    (%eax),%edx
  8025e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e9:	89 10                	mov    %edx,(%eax)
  8025eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	74 0b                	je     8025ff <alloc_block_FF+0x247>
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 00                	mov    (%eax),%eax
  8025f9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025fc:	89 50 04             	mov    %edx,0x4(%eax)
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802605:	89 10                	mov    %edx,(%eax)
  802607:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260d:	89 50 04             	mov    %edx,0x4(%eax)
  802610:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802613:	8b 00                	mov    (%eax),%eax
  802615:	85 c0                	test   %eax,%eax
  802617:	75 08                	jne    802621 <alloc_block_FF+0x269>
  802619:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80261c:	a3 34 50 80 00       	mov    %eax,0x805034
  802621:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802626:	40                   	inc    %eax
  802627:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80262c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802630:	75 17                	jne    802649 <alloc_block_FF+0x291>
  802632:	83 ec 04             	sub    $0x4,%esp
  802635:	68 1f 46 80 00       	push   $0x80461f
  80263a:	68 e1 00 00 00       	push   $0xe1
  80263f:	68 3d 46 80 00       	push   $0x80463d
  802644:	e8 4f dd ff ff       	call   800398 <_panic>
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 00                	mov    (%eax),%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	74 10                	je     802662 <alloc_block_FF+0x2aa>
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265a:	8b 52 04             	mov    0x4(%edx),%edx
  80265d:	89 50 04             	mov    %edx,0x4(%eax)
  802660:	eb 0b                	jmp    80266d <alloc_block_FF+0x2b5>
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 40 04             	mov    0x4(%eax),%eax
  802668:	a3 34 50 80 00       	mov    %eax,0x805034
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 40 04             	mov    0x4(%eax),%eax
  802673:	85 c0                	test   %eax,%eax
  802675:	74 0f                	je     802686 <alloc_block_FF+0x2ce>
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 40 04             	mov    0x4(%eax),%eax
  80267d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802680:	8b 12                	mov    (%edx),%edx
  802682:	89 10                	mov    %edx,(%eax)
  802684:	eb 0a                	jmp    802690 <alloc_block_FF+0x2d8>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	a3 30 50 80 00       	mov    %eax,0x805030
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026a8:	48                   	dec    %eax
  8026a9:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  8026ae:	83 ec 04             	sub    $0x4,%esp
  8026b1:	6a 00                	push   $0x0
  8026b3:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026b6:	ff 75 b0             	pushl  -0x50(%ebp)
  8026b9:	e8 cb fc ff ff       	call   802389 <set_block_data>
  8026be:	83 c4 10             	add    $0x10,%esp
  8026c1:	e9 95 00 00 00       	jmp    80275b <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8026c6:	83 ec 04             	sub    $0x4,%esp
  8026c9:	6a 01                	push   $0x1
  8026cb:	ff 75 b8             	pushl  -0x48(%ebp)
  8026ce:	ff 75 bc             	pushl  -0x44(%ebp)
  8026d1:	e8 b3 fc ff ff       	call   802389 <set_block_data>
  8026d6:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8026d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dd:	75 17                	jne    8026f6 <alloc_block_FF+0x33e>
  8026df:	83 ec 04             	sub    $0x4,%esp
  8026e2:	68 1f 46 80 00       	push   $0x80461f
  8026e7:	68 e8 00 00 00       	push   $0xe8
  8026ec:	68 3d 46 80 00       	push   $0x80463d
  8026f1:	e8 a2 dc ff ff       	call   800398 <_panic>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	74 10                	je     80270f <alloc_block_FF+0x357>
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 00                	mov    (%eax),%eax
  802704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802707:	8b 52 04             	mov    0x4(%edx),%edx
  80270a:	89 50 04             	mov    %edx,0x4(%eax)
  80270d:	eb 0b                	jmp    80271a <alloc_block_FF+0x362>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 04             	mov    0x4(%eax),%eax
  802715:	a3 34 50 80 00       	mov    %eax,0x805034
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 40 04             	mov    0x4(%eax),%eax
  802720:	85 c0                	test   %eax,%eax
  802722:	74 0f                	je     802733 <alloc_block_FF+0x37b>
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 04             	mov    0x4(%eax),%eax
  80272a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272d:	8b 12                	mov    (%edx),%edx
  80272f:	89 10                	mov    %edx,(%eax)
  802731:	eb 0a                	jmp    80273d <alloc_block_FF+0x385>
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	a3 30 50 80 00       	mov    %eax,0x805030
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802750:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802755:	48                   	dec    %eax
  802756:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  80275b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80275e:	e9 0f 01 00 00       	jmp    802872 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802763:	a1 38 50 80 00       	mov    0x805038,%eax
  802768:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276f:	74 07                	je     802778 <alloc_block_FF+0x3c0>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	eb 05                	jmp    80277d <alloc_block_FF+0x3c5>
  802778:	b8 00 00 00 00       	mov    $0x0,%eax
  80277d:	a3 38 50 80 00       	mov    %eax,0x805038
  802782:	a1 38 50 80 00       	mov    0x805038,%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	0f 85 e9 fc ff ff    	jne    802478 <alloc_block_FF+0xc0>
  80278f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802793:	0f 85 df fc ff ff    	jne    802478 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	83 c0 08             	add    $0x8,%eax
  80279f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027a2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027af:	01 d0                	add    %edx,%eax
  8027b1:	48                   	dec    %eax
  8027b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8027bd:	f7 75 d8             	divl   -0x28(%ebp)
  8027c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027c3:	29 d0                	sub    %edx,%eax
  8027c5:	c1 e8 0c             	shr    $0xc,%eax
  8027c8:	83 ec 0c             	sub    $0xc,%esp
  8027cb:	50                   	push   %eax
  8027cc:	e8 1e ec ff ff       	call   8013ef <sbrk>
  8027d1:	83 c4 10             	add    $0x10,%esp
  8027d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8027d7:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027db:	75 0a                	jne    8027e7 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8027dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e2:	e9 8b 00 00 00       	jmp    802872 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8027e7:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8027ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f4:	01 d0                	add    %edx,%eax
  8027f6:	48                   	dec    %eax
  8027f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8027fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802802:	f7 75 cc             	divl   -0x34(%ebp)
  802805:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802808:	29 d0                	sub    %edx,%eax
  80280a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80280d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802810:	01 d0                	add    %edx,%eax
  802812:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802817:	a1 44 50 80 00       	mov    0x805044,%eax
  80281c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802822:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802829:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80282c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80282f:	01 d0                	add    %edx,%eax
  802831:	48                   	dec    %eax
  802832:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802835:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802838:	ba 00 00 00 00       	mov    $0x0,%edx
  80283d:	f7 75 c4             	divl   -0x3c(%ebp)
  802840:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802843:	29 d0                	sub    %edx,%eax
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	6a 01                	push   $0x1
  80284a:	50                   	push   %eax
  80284b:	ff 75 d0             	pushl  -0x30(%ebp)
  80284e:	e8 36 fb ff ff       	call   802389 <set_block_data>
  802853:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802856:	83 ec 0c             	sub    $0xc,%esp
  802859:	ff 75 d0             	pushl  -0x30(%ebp)
  80285c:	e8 1b 0a 00 00       	call   80327c <free_block>
  802861:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802864:	83 ec 0c             	sub    $0xc,%esp
  802867:	ff 75 08             	pushl  0x8(%ebp)
  80286a:	e8 49 fb ff ff       	call   8023b8 <alloc_block_FF>
  80286f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80287a:	8b 45 08             	mov    0x8(%ebp),%eax
  80287d:	83 e0 01             	and    $0x1,%eax
  802880:	85 c0                	test   %eax,%eax
  802882:	74 03                	je     802887 <alloc_block_BF+0x13>
  802884:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802887:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80288b:	77 07                	ja     802894 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80288d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802894:	a1 28 50 80 00       	mov    0x805028,%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	75 73                	jne    802910 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80289d:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a0:	83 c0 10             	add    $0x10,%eax
  8028a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028a6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b3:	01 d0                	add    %edx,%eax
  8028b5:	48                   	dec    %eax
  8028b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c1:	f7 75 e0             	divl   -0x20(%ebp)
  8028c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028c7:	29 d0                	sub    %edx,%eax
  8028c9:	c1 e8 0c             	shr    $0xc,%eax
  8028cc:	83 ec 0c             	sub    $0xc,%esp
  8028cf:	50                   	push   %eax
  8028d0:	e8 1a eb ff ff       	call   8013ef <sbrk>
  8028d5:	83 c4 10             	add    $0x10,%esp
  8028d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028db:	83 ec 0c             	sub    $0xc,%esp
  8028de:	6a 00                	push   $0x0
  8028e0:	e8 0a eb ff ff       	call   8013ef <sbrk>
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028ee:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8028f1:	83 ec 08             	sub    $0x8,%esp
  8028f4:	50                   	push   %eax
  8028f5:	ff 75 d8             	pushl  -0x28(%ebp)
  8028f8:	e8 9f f8 ff ff       	call   80219c <initialize_dynamic_allocator>
  8028fd:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802900:	83 ec 0c             	sub    $0xc,%esp
  802903:	68 7b 46 80 00       	push   $0x80467b
  802908:	e8 48 dd ff ff       	call   800655 <cprintf>
  80290d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802917:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80291e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802925:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80292c:	a1 30 50 80 00       	mov    0x805030,%eax
  802931:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802934:	e9 1d 01 00 00       	jmp    802a56 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80293f:	83 ec 0c             	sub    $0xc,%esp
  802942:	ff 75 a8             	pushl  -0x58(%ebp)
  802945:	e8 ee f6 ff ff       	call   802038 <get_block_size>
  80294a:	83 c4 10             	add    $0x10,%esp
  80294d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	83 c0 08             	add    $0x8,%eax
  802956:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802959:	0f 87 ef 00 00 00    	ja     802a4e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80295f:	8b 45 08             	mov    0x8(%ebp),%eax
  802962:	83 c0 18             	add    $0x18,%eax
  802965:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802968:	77 1d                	ja     802987 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80296a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802970:	0f 86 d8 00 00 00    	jbe    802a4e <alloc_block_BF+0x1da>
				{
					best_va = va;
  802976:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802979:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80297c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80297f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802982:	e9 c7 00 00 00       	jmp    802a4e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	83 c0 08             	add    $0x8,%eax
  80298d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802990:	0f 85 9d 00 00 00    	jne    802a33 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802996:	83 ec 04             	sub    $0x4,%esp
  802999:	6a 01                	push   $0x1
  80299b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80299e:	ff 75 a8             	pushl  -0x58(%ebp)
  8029a1:	e8 e3 f9 ff ff       	call   802389 <set_block_data>
  8029a6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ad:	75 17                	jne    8029c6 <alloc_block_BF+0x152>
  8029af:	83 ec 04             	sub    $0x4,%esp
  8029b2:	68 1f 46 80 00       	push   $0x80461f
  8029b7:	68 2c 01 00 00       	push   $0x12c
  8029bc:	68 3d 46 80 00       	push   $0x80463d
  8029c1:	e8 d2 d9 ff ff       	call   800398 <_panic>
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	74 10                	je     8029df <alloc_block_BF+0x16b>
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	8b 00                	mov    (%eax),%eax
  8029d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d7:	8b 52 04             	mov    0x4(%edx),%edx
  8029da:	89 50 04             	mov    %edx,0x4(%eax)
  8029dd:	eb 0b                	jmp    8029ea <alloc_block_BF+0x176>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 40 04             	mov    0x4(%eax),%eax
  8029e5:	a3 34 50 80 00       	mov    %eax,0x805034
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 40 04             	mov    0x4(%eax),%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	74 0f                	je     802a03 <alloc_block_BF+0x18f>
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 40 04             	mov    0x4(%eax),%eax
  8029fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fd:	8b 12                	mov    (%edx),%edx
  8029ff:	89 10                	mov    %edx,(%eax)
  802a01:	eb 0a                	jmp    802a0d <alloc_block_BF+0x199>
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	8b 00                	mov    (%eax),%eax
  802a08:	a3 30 50 80 00       	mov    %eax,0x805030
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a20:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a25:	48                   	dec    %eax
  802a26:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802a2b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a2e:	e9 24 04 00 00       	jmp    802e57 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a36:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a39:	76 13                	jbe    802a4e <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a3b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a42:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a48:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a4b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a4e:	a1 38 50 80 00       	mov    0x805038,%eax
  802a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5a:	74 07                	je     802a63 <alloc_block_BF+0x1ef>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	eb 05                	jmp    802a68 <alloc_block_BF+0x1f4>
  802a63:	b8 00 00 00 00       	mov    $0x0,%eax
  802a68:	a3 38 50 80 00       	mov    %eax,0x805038
  802a6d:	a1 38 50 80 00       	mov    0x805038,%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	0f 85 bf fe ff ff    	jne    802939 <alloc_block_BF+0xc5>
  802a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7e:	0f 85 b5 fe ff ff    	jne    802939 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a88:	0f 84 26 02 00 00    	je     802cb4 <alloc_block_BF+0x440>
  802a8e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a92:	0f 85 1c 02 00 00    	jne    802cb4 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a9e:	83 e8 08             	sub    $0x8,%eax
  802aa1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	8d 50 08             	lea    0x8(%eax),%edx
  802aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aad:	01 d0                	add    %edx,%eax
  802aaf:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	83 c0 08             	add    $0x8,%eax
  802ab8:	83 ec 04             	sub    $0x4,%esp
  802abb:	6a 01                	push   $0x1
  802abd:	50                   	push   %eax
  802abe:	ff 75 f0             	pushl  -0x10(%ebp)
  802ac1:	e8 c3 f8 ff ff       	call   802389 <set_block_data>
  802ac6:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acc:	8b 40 04             	mov    0x4(%eax),%eax
  802acf:	85 c0                	test   %eax,%eax
  802ad1:	75 68                	jne    802b3b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ad3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ad7:	75 17                	jne    802af0 <alloc_block_BF+0x27c>
  802ad9:	83 ec 04             	sub    $0x4,%esp
  802adc:	68 58 46 80 00       	push   $0x804658
  802ae1:	68 45 01 00 00       	push   $0x145
  802ae6:	68 3d 46 80 00       	push   $0x80463d
  802aeb:	e8 a8 d8 ff ff       	call   800398 <_panic>
  802af0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802af6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af9:	89 10                	mov    %edx,(%eax)
  802afb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	85 c0                	test   %eax,%eax
  802b02:	74 0d                	je     802b11 <alloc_block_BF+0x29d>
  802b04:	a1 30 50 80 00       	mov    0x805030,%eax
  802b09:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	eb 08                	jmp    802b19 <alloc_block_BF+0x2a5>
  802b11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b14:	a3 34 50 80 00       	mov    %eax,0x805034
  802b19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1c:	a3 30 50 80 00       	mov    %eax,0x805030
  802b21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b30:	40                   	inc    %eax
  802b31:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b36:	e9 dc 00 00 00       	jmp    802c17 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	85 c0                	test   %eax,%eax
  802b42:	75 65                	jne    802ba9 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b44:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b48:	75 17                	jne    802b61 <alloc_block_BF+0x2ed>
  802b4a:	83 ec 04             	sub    $0x4,%esp
  802b4d:	68 8c 46 80 00       	push   $0x80468c
  802b52:	68 4a 01 00 00       	push   $0x14a
  802b57:	68 3d 46 80 00       	push   $0x80463d
  802b5c:	e8 37 d8 ff ff       	call   800398 <_panic>
  802b61:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802b67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b6a:	89 50 04             	mov    %edx,0x4(%eax)
  802b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b70:	8b 40 04             	mov    0x4(%eax),%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	74 0c                	je     802b83 <alloc_block_BF+0x30f>
  802b77:	a1 34 50 80 00       	mov    0x805034,%eax
  802b7c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b7f:	89 10                	mov    %edx,(%eax)
  802b81:	eb 08                	jmp    802b8b <alloc_block_BF+0x317>
  802b83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b86:	a3 30 50 80 00       	mov    %eax,0x805030
  802b8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8e:	a3 34 50 80 00       	mov    %eax,0x805034
  802b93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ba1:	40                   	inc    %eax
  802ba2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ba7:	eb 6e                	jmp    802c17 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ba9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bad:	74 06                	je     802bb5 <alloc_block_BF+0x341>
  802baf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bb3:	75 17                	jne    802bcc <alloc_block_BF+0x358>
  802bb5:	83 ec 04             	sub    $0x4,%esp
  802bb8:	68 b0 46 80 00       	push   $0x8046b0
  802bbd:	68 4f 01 00 00       	push   $0x14f
  802bc2:	68 3d 46 80 00       	push   $0x80463d
  802bc7:	e8 cc d7 ff ff       	call   800398 <_panic>
  802bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcf:	8b 10                	mov    (%eax),%edx
  802bd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd4:	89 10                	mov    %edx,(%eax)
  802bd6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 0b                	je     802bea <alloc_block_BF+0x376>
  802bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802be7:	89 50 04             	mov    %edx,0x4(%eax)
  802bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bed:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bf0:	89 10                	mov    %edx,(%eax)
  802bf2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf8:	89 50 04             	mov    %edx,0x4(%eax)
  802bfb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	75 08                	jne    802c0c <alloc_block_BF+0x398>
  802c04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c07:	a3 34 50 80 00       	mov    %eax,0x805034
  802c0c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c11:	40                   	inc    %eax
  802c12:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c1b:	75 17                	jne    802c34 <alloc_block_BF+0x3c0>
  802c1d:	83 ec 04             	sub    $0x4,%esp
  802c20:	68 1f 46 80 00       	push   $0x80461f
  802c25:	68 51 01 00 00       	push   $0x151
  802c2a:	68 3d 46 80 00       	push   $0x80463d
  802c2f:	e8 64 d7 ff ff       	call   800398 <_panic>
  802c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	85 c0                	test   %eax,%eax
  802c3b:	74 10                	je     802c4d <alloc_block_BF+0x3d9>
  802c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c45:	8b 52 04             	mov    0x4(%edx),%edx
  802c48:	89 50 04             	mov    %edx,0x4(%eax)
  802c4b:	eb 0b                	jmp    802c58 <alloc_block_BF+0x3e4>
  802c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	a3 34 50 80 00       	mov    %eax,0x805034
  802c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	74 0f                	je     802c71 <alloc_block_BF+0x3fd>
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	8b 40 04             	mov    0x4(%eax),%eax
  802c68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c6b:	8b 12                	mov    (%edx),%edx
  802c6d:	89 10                	mov    %edx,(%eax)
  802c6f:	eb 0a                	jmp    802c7b <alloc_block_BF+0x407>
  802c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c74:	8b 00                	mov    (%eax),%eax
  802c76:	a3 30 50 80 00       	mov    %eax,0x805030
  802c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c93:	48                   	dec    %eax
  802c94:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802c99:	83 ec 04             	sub    $0x4,%esp
  802c9c:	6a 00                	push   $0x0
  802c9e:	ff 75 d0             	pushl  -0x30(%ebp)
  802ca1:	ff 75 cc             	pushl  -0x34(%ebp)
  802ca4:	e8 e0 f6 ff ff       	call   802389 <set_block_data>
  802ca9:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caf:	e9 a3 01 00 00       	jmp    802e57 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802cb4:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802cb8:	0f 85 9d 00 00 00    	jne    802d5b <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802cbe:	83 ec 04             	sub    $0x4,%esp
  802cc1:	6a 01                	push   $0x1
  802cc3:	ff 75 ec             	pushl  -0x14(%ebp)
  802cc6:	ff 75 f0             	pushl  -0x10(%ebp)
  802cc9:	e8 bb f6 ff ff       	call   802389 <set_block_data>
  802cce:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802cd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd5:	75 17                	jne    802cee <alloc_block_BF+0x47a>
  802cd7:	83 ec 04             	sub    $0x4,%esp
  802cda:	68 1f 46 80 00       	push   $0x80461f
  802cdf:	68 58 01 00 00       	push   $0x158
  802ce4:	68 3d 46 80 00       	push   $0x80463d
  802ce9:	e8 aa d6 ff ff       	call   800398 <_panic>
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	74 10                	je     802d07 <alloc_block_BF+0x493>
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cff:	8b 52 04             	mov    0x4(%edx),%edx
  802d02:	89 50 04             	mov    %edx,0x4(%eax)
  802d05:	eb 0b                	jmp    802d12 <alloc_block_BF+0x49e>
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	8b 40 04             	mov    0x4(%eax),%eax
  802d0d:	a3 34 50 80 00       	mov    %eax,0x805034
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	8b 40 04             	mov    0x4(%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0f                	je     802d2b <alloc_block_BF+0x4b7>
  802d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1f:	8b 40 04             	mov    0x4(%eax),%eax
  802d22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d25:	8b 12                	mov    (%edx),%edx
  802d27:	89 10                	mov    %edx,(%eax)
  802d29:	eb 0a                	jmp    802d35 <alloc_block_BF+0x4c1>
  802d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2e:	8b 00                	mov    (%eax),%eax
  802d30:	a3 30 50 80 00       	mov    %eax,0x805030
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d48:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d4d:	48                   	dec    %eax
  802d4e:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	e9 fc 00 00 00       	jmp    802e57 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	83 c0 08             	add    $0x8,%eax
  802d61:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d64:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d6b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d6e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d71:	01 d0                	add    %edx,%eax
  802d73:	48                   	dec    %eax
  802d74:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d77:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d7a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d7f:	f7 75 c4             	divl   -0x3c(%ebp)
  802d82:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d85:	29 d0                	sub    %edx,%eax
  802d87:	c1 e8 0c             	shr    $0xc,%eax
  802d8a:	83 ec 0c             	sub    $0xc,%esp
  802d8d:	50                   	push   %eax
  802d8e:	e8 5c e6 ff ff       	call   8013ef <sbrk>
  802d93:	83 c4 10             	add    $0x10,%esp
  802d96:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d99:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d9d:	75 0a                	jne    802da9 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802da4:	e9 ae 00 00 00       	jmp    802e57 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802da9:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802db0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802db3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802db6:	01 d0                	add    %edx,%eax
  802db8:	48                   	dec    %eax
  802db9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802dbc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc4:	f7 75 b8             	divl   -0x48(%ebp)
  802dc7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dca:	29 d0                	sub    %edx,%eax
  802dcc:	8d 50 fc             	lea    -0x4(%eax),%edx
  802dcf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dd2:	01 d0                	add    %edx,%eax
  802dd4:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802dd9:	a1 44 50 80 00       	mov    0x805044,%eax
  802dde:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802de4:	83 ec 0c             	sub    $0xc,%esp
  802de7:	68 e4 46 80 00       	push   $0x8046e4
  802dec:	e8 64 d8 ff ff       	call   800655 <cprintf>
  802df1:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802df4:	83 ec 08             	sub    $0x8,%esp
  802df7:	ff 75 bc             	pushl  -0x44(%ebp)
  802dfa:	68 e9 46 80 00       	push   $0x8046e9
  802dff:	e8 51 d8 ff ff       	call   800655 <cprintf>
  802e04:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e07:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e0e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e11:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e14:	01 d0                	add    %edx,%eax
  802e16:	48                   	dec    %eax
  802e17:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e1a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e1d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e22:	f7 75 b0             	divl   -0x50(%ebp)
  802e25:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e28:	29 d0                	sub    %edx,%eax
  802e2a:	83 ec 04             	sub    $0x4,%esp
  802e2d:	6a 01                	push   $0x1
  802e2f:	50                   	push   %eax
  802e30:	ff 75 bc             	pushl  -0x44(%ebp)
  802e33:	e8 51 f5 ff ff       	call   802389 <set_block_data>
  802e38:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e3b:	83 ec 0c             	sub    $0xc,%esp
  802e3e:	ff 75 bc             	pushl  -0x44(%ebp)
  802e41:	e8 36 04 00 00       	call   80327c <free_block>
  802e46:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e49:	83 ec 0c             	sub    $0xc,%esp
  802e4c:	ff 75 08             	pushl  0x8(%ebp)
  802e4f:	e8 20 fa ff ff       	call   802874 <alloc_block_BF>
  802e54:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e57:	c9                   	leave  
  802e58:	c3                   	ret    

00802e59 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e59:	55                   	push   %ebp
  802e5a:	89 e5                	mov    %esp,%ebp
  802e5c:	53                   	push   %ebx
  802e5d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e72:	74 1e                	je     802e92 <merging+0x39>
  802e74:	ff 75 08             	pushl  0x8(%ebp)
  802e77:	e8 bc f1 ff ff       	call   802038 <get_block_size>
  802e7c:	83 c4 04             	add    $0x4,%esp
  802e7f:	89 c2                	mov    %eax,%edx
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	01 d0                	add    %edx,%eax
  802e86:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e89:	75 07                	jne    802e92 <merging+0x39>
		prev_is_free = 1;
  802e8b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e96:	74 1e                	je     802eb6 <merging+0x5d>
  802e98:	ff 75 10             	pushl  0x10(%ebp)
  802e9b:	e8 98 f1 ff ff       	call   802038 <get_block_size>
  802ea0:	83 c4 04             	add    $0x4,%esp
  802ea3:	89 c2                	mov    %eax,%edx
  802ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  802ea8:	01 d0                	add    %edx,%eax
  802eaa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ead:	75 07                	jne    802eb6 <merging+0x5d>
		next_is_free = 1;
  802eaf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802eb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eba:	0f 84 cc 00 00 00    	je     802f8c <merging+0x133>
  802ec0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec4:	0f 84 c2 00 00 00    	je     802f8c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802eca:	ff 75 08             	pushl  0x8(%ebp)
  802ecd:	e8 66 f1 ff ff       	call   802038 <get_block_size>
  802ed2:	83 c4 04             	add    $0x4,%esp
  802ed5:	89 c3                	mov    %eax,%ebx
  802ed7:	ff 75 10             	pushl  0x10(%ebp)
  802eda:	e8 59 f1 ff ff       	call   802038 <get_block_size>
  802edf:	83 c4 04             	add    $0x4,%esp
  802ee2:	01 c3                	add    %eax,%ebx
  802ee4:	ff 75 0c             	pushl  0xc(%ebp)
  802ee7:	e8 4c f1 ff ff       	call   802038 <get_block_size>
  802eec:	83 c4 04             	add    $0x4,%esp
  802eef:	01 d8                	add    %ebx,%eax
  802ef1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ef4:	6a 00                	push   $0x0
  802ef6:	ff 75 ec             	pushl  -0x14(%ebp)
  802ef9:	ff 75 08             	pushl  0x8(%ebp)
  802efc:	e8 88 f4 ff ff       	call   802389 <set_block_data>
  802f01:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f08:	75 17                	jne    802f21 <merging+0xc8>
  802f0a:	83 ec 04             	sub    $0x4,%esp
  802f0d:	68 1f 46 80 00       	push   $0x80461f
  802f12:	68 7d 01 00 00       	push   $0x17d
  802f17:	68 3d 46 80 00       	push   $0x80463d
  802f1c:	e8 77 d4 ff ff       	call   800398 <_panic>
  802f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f24:	8b 00                	mov    (%eax),%eax
  802f26:	85 c0                	test   %eax,%eax
  802f28:	74 10                	je     802f3a <merging+0xe1>
  802f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f32:	8b 52 04             	mov    0x4(%edx),%edx
  802f35:	89 50 04             	mov    %edx,0x4(%eax)
  802f38:	eb 0b                	jmp    802f45 <merging+0xec>
  802f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3d:	8b 40 04             	mov    0x4(%eax),%eax
  802f40:	a3 34 50 80 00       	mov    %eax,0x805034
  802f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f48:	8b 40 04             	mov    0x4(%eax),%eax
  802f4b:	85 c0                	test   %eax,%eax
  802f4d:	74 0f                	je     802f5e <merging+0x105>
  802f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f52:	8b 40 04             	mov    0x4(%eax),%eax
  802f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f58:	8b 12                	mov    (%edx),%edx
  802f5a:	89 10                	mov    %edx,(%eax)
  802f5c:	eb 0a                	jmp    802f68 <merging+0x10f>
  802f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f61:	8b 00                	mov    (%eax),%eax
  802f63:	a3 30 50 80 00       	mov    %eax,0x805030
  802f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f80:	48                   	dec    %eax
  802f81:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f86:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f87:	e9 ea 02 00 00       	jmp    803276 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f90:	74 3b                	je     802fcd <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f92:	83 ec 0c             	sub    $0xc,%esp
  802f95:	ff 75 08             	pushl  0x8(%ebp)
  802f98:	e8 9b f0 ff ff       	call   802038 <get_block_size>
  802f9d:	83 c4 10             	add    $0x10,%esp
  802fa0:	89 c3                	mov    %eax,%ebx
  802fa2:	83 ec 0c             	sub    $0xc,%esp
  802fa5:	ff 75 10             	pushl  0x10(%ebp)
  802fa8:	e8 8b f0 ff ff       	call   802038 <get_block_size>
  802fad:	83 c4 10             	add    $0x10,%esp
  802fb0:	01 d8                	add    %ebx,%eax
  802fb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fb5:	83 ec 04             	sub    $0x4,%esp
  802fb8:	6a 00                	push   $0x0
  802fba:	ff 75 e8             	pushl  -0x18(%ebp)
  802fbd:	ff 75 08             	pushl  0x8(%ebp)
  802fc0:	e8 c4 f3 ff ff       	call   802389 <set_block_data>
  802fc5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fc8:	e9 a9 02 00 00       	jmp    803276 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802fcd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fd1:	0f 84 2d 01 00 00    	je     803104 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802fd7:	83 ec 0c             	sub    $0xc,%esp
  802fda:	ff 75 10             	pushl  0x10(%ebp)
  802fdd:	e8 56 f0 ff ff       	call   802038 <get_block_size>
  802fe2:	83 c4 10             	add    $0x10,%esp
  802fe5:	89 c3                	mov    %eax,%ebx
  802fe7:	83 ec 0c             	sub    $0xc,%esp
  802fea:	ff 75 0c             	pushl  0xc(%ebp)
  802fed:	e8 46 f0 ff ff       	call   802038 <get_block_size>
  802ff2:	83 c4 10             	add    $0x10,%esp
  802ff5:	01 d8                	add    %ebx,%eax
  802ff7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	6a 00                	push   $0x0
  802fff:	ff 75 e4             	pushl  -0x1c(%ebp)
  803002:	ff 75 10             	pushl  0x10(%ebp)
  803005:	e8 7f f3 ff ff       	call   802389 <set_block_data>
  80300a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80300d:	8b 45 10             	mov    0x10(%ebp),%eax
  803010:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803013:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803017:	74 06                	je     80301f <merging+0x1c6>
  803019:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80301d:	75 17                	jne    803036 <merging+0x1dd>
  80301f:	83 ec 04             	sub    $0x4,%esp
  803022:	68 f8 46 80 00       	push   $0x8046f8
  803027:	68 8d 01 00 00       	push   $0x18d
  80302c:	68 3d 46 80 00       	push   $0x80463d
  803031:	e8 62 d3 ff ff       	call   800398 <_panic>
  803036:	8b 45 0c             	mov    0xc(%ebp),%eax
  803039:	8b 50 04             	mov    0x4(%eax),%edx
  80303c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303f:	89 50 04             	mov    %edx,0x4(%eax)
  803042:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803045:	8b 55 0c             	mov    0xc(%ebp),%edx
  803048:	89 10                	mov    %edx,(%eax)
  80304a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304d:	8b 40 04             	mov    0x4(%eax),%eax
  803050:	85 c0                	test   %eax,%eax
  803052:	74 0d                	je     803061 <merging+0x208>
  803054:	8b 45 0c             	mov    0xc(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80305d:	89 10                	mov    %edx,(%eax)
  80305f:	eb 08                	jmp    803069 <merging+0x210>
  803061:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803064:	a3 30 50 80 00       	mov    %eax,0x805030
  803069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80306f:	89 50 04             	mov    %edx,0x4(%eax)
  803072:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803077:	40                   	inc    %eax
  803078:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80307d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803081:	75 17                	jne    80309a <merging+0x241>
  803083:	83 ec 04             	sub    $0x4,%esp
  803086:	68 1f 46 80 00       	push   $0x80461f
  80308b:	68 8e 01 00 00       	push   $0x18e
  803090:	68 3d 46 80 00       	push   $0x80463d
  803095:	e8 fe d2 ff ff       	call   800398 <_panic>
  80309a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309d:	8b 00                	mov    (%eax),%eax
  80309f:	85 c0                	test   %eax,%eax
  8030a1:	74 10                	je     8030b3 <merging+0x25a>
  8030a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a6:	8b 00                	mov    (%eax),%eax
  8030a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ab:	8b 52 04             	mov    0x4(%edx),%edx
  8030ae:	89 50 04             	mov    %edx,0x4(%eax)
  8030b1:	eb 0b                	jmp    8030be <merging+0x265>
  8030b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b6:	8b 40 04             	mov    0x4(%eax),%eax
  8030b9:	a3 34 50 80 00       	mov    %eax,0x805034
  8030be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c1:	8b 40 04             	mov    0x4(%eax),%eax
  8030c4:	85 c0                	test   %eax,%eax
  8030c6:	74 0f                	je     8030d7 <merging+0x27e>
  8030c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030cb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030d1:	8b 12                	mov    (%edx),%edx
  8030d3:	89 10                	mov    %edx,(%eax)
  8030d5:	eb 0a                	jmp    8030e1 <merging+0x288>
  8030d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030da:	8b 00                	mov    (%eax),%eax
  8030dc:	a3 30 50 80 00       	mov    %eax,0x805030
  8030e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030f9:	48                   	dec    %eax
  8030fa:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030ff:	e9 72 01 00 00       	jmp    803276 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803104:	8b 45 10             	mov    0x10(%ebp),%eax
  803107:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80310a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310e:	74 79                	je     803189 <merging+0x330>
  803110:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803114:	74 73                	je     803189 <merging+0x330>
  803116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80311a:	74 06                	je     803122 <merging+0x2c9>
  80311c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803120:	75 17                	jne    803139 <merging+0x2e0>
  803122:	83 ec 04             	sub    $0x4,%esp
  803125:	68 b0 46 80 00       	push   $0x8046b0
  80312a:	68 94 01 00 00       	push   $0x194
  80312f:	68 3d 46 80 00       	push   $0x80463d
  803134:	e8 5f d2 ff ff       	call   800398 <_panic>
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	8b 10                	mov    (%eax),%edx
  80313e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803141:	89 10                	mov    %edx,(%eax)
  803143:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	85 c0                	test   %eax,%eax
  80314a:	74 0b                	je     803157 <merging+0x2fe>
  80314c:	8b 45 08             	mov    0x8(%ebp),%eax
  80314f:	8b 00                	mov    (%eax),%eax
  803151:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803154:	89 50 04             	mov    %edx,0x4(%eax)
  803157:	8b 45 08             	mov    0x8(%ebp),%eax
  80315a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80315d:	89 10                	mov    %edx,(%eax)
  80315f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803162:	8b 55 08             	mov    0x8(%ebp),%edx
  803165:	89 50 04             	mov    %edx,0x4(%eax)
  803168:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316b:	8b 00                	mov    (%eax),%eax
  80316d:	85 c0                	test   %eax,%eax
  80316f:	75 08                	jne    803179 <merging+0x320>
  803171:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803174:	a3 34 50 80 00       	mov    %eax,0x805034
  803179:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80317e:	40                   	inc    %eax
  80317f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803184:	e9 ce 00 00 00       	jmp    803257 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803189:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318d:	74 65                	je     8031f4 <merging+0x39b>
  80318f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803193:	75 17                	jne    8031ac <merging+0x353>
  803195:	83 ec 04             	sub    $0x4,%esp
  803198:	68 8c 46 80 00       	push   $0x80468c
  80319d:	68 95 01 00 00       	push   $0x195
  8031a2:	68 3d 46 80 00       	push   $0x80463d
  8031a7:	e8 ec d1 ff ff       	call   800398 <_panic>
  8031ac:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8031b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b5:	89 50 04             	mov    %edx,0x4(%eax)
  8031b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031bb:	8b 40 04             	mov    0x4(%eax),%eax
  8031be:	85 c0                	test   %eax,%eax
  8031c0:	74 0c                	je     8031ce <merging+0x375>
  8031c2:	a1 34 50 80 00       	mov    0x805034,%eax
  8031c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ca:	89 10                	mov    %edx,(%eax)
  8031cc:	eb 08                	jmp    8031d6 <merging+0x37d>
  8031ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8031d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d9:	a3 34 50 80 00       	mov    %eax,0x805034
  8031de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031ec:	40                   	inc    %eax
  8031ed:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8031f2:	eb 63                	jmp    803257 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8031f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031f8:	75 17                	jne    803211 <merging+0x3b8>
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	68 58 46 80 00       	push   $0x804658
  803202:	68 98 01 00 00       	push   $0x198
  803207:	68 3d 46 80 00       	push   $0x80463d
  80320c:	e8 87 d1 ff ff       	call   800398 <_panic>
  803211:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803217:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321a:	89 10                	mov    %edx,(%eax)
  80321c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	74 0d                	je     803232 <merging+0x3d9>
  803225:	a1 30 50 80 00       	mov    0x805030,%eax
  80322a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80322d:	89 50 04             	mov    %edx,0x4(%eax)
  803230:	eb 08                	jmp    80323a <merging+0x3e1>
  803232:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803235:	a3 34 50 80 00       	mov    %eax,0x805034
  80323a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323d:	a3 30 50 80 00       	mov    %eax,0x805030
  803242:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803245:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803251:	40                   	inc    %eax
  803252:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803257:	83 ec 0c             	sub    $0xc,%esp
  80325a:	ff 75 10             	pushl  0x10(%ebp)
  80325d:	e8 d6 ed ff ff       	call   802038 <get_block_size>
  803262:	83 c4 10             	add    $0x10,%esp
  803265:	83 ec 04             	sub    $0x4,%esp
  803268:	6a 00                	push   $0x0
  80326a:	50                   	push   %eax
  80326b:	ff 75 10             	pushl  0x10(%ebp)
  80326e:	e8 16 f1 ff ff       	call   802389 <set_block_data>
  803273:	83 c4 10             	add    $0x10,%esp
	}
}
  803276:	90                   	nop
  803277:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80327a:	c9                   	leave  
  80327b:	c3                   	ret    

0080327c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80327c:	55                   	push   %ebp
  80327d:	89 e5                	mov    %esp,%ebp
  80327f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803282:	a1 30 50 80 00       	mov    0x805030,%eax
  803287:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80328a:	a1 34 50 80 00       	mov    0x805034,%eax
  80328f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803292:	73 1b                	jae    8032af <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803294:	a1 34 50 80 00       	mov    0x805034,%eax
  803299:	83 ec 04             	sub    $0x4,%esp
  80329c:	ff 75 08             	pushl  0x8(%ebp)
  80329f:	6a 00                	push   $0x0
  8032a1:	50                   	push   %eax
  8032a2:	e8 b2 fb ff ff       	call   802e59 <merging>
  8032a7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032aa:	e9 8b 00 00 00       	jmp    80333a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8032af:	a1 30 50 80 00       	mov    0x805030,%eax
  8032b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032b7:	76 18                	jbe    8032d1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8032b9:	a1 30 50 80 00       	mov    0x805030,%eax
  8032be:	83 ec 04             	sub    $0x4,%esp
  8032c1:	ff 75 08             	pushl  0x8(%ebp)
  8032c4:	50                   	push   %eax
  8032c5:	6a 00                	push   $0x0
  8032c7:	e8 8d fb ff ff       	call   802e59 <merging>
  8032cc:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032cf:	eb 69                	jmp    80333a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032d1:	a1 30 50 80 00       	mov    0x805030,%eax
  8032d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d9:	eb 39                	jmp    803314 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032e1:	73 29                	jae    80330c <free_block+0x90>
  8032e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e6:	8b 00                	mov    (%eax),%eax
  8032e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032eb:	76 1f                	jbe    80330c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8032f5:	83 ec 04             	sub    $0x4,%esp
  8032f8:	ff 75 08             	pushl  0x8(%ebp)
  8032fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8032fe:	ff 75 f4             	pushl  -0xc(%ebp)
  803301:	e8 53 fb ff ff       	call   802e59 <merging>
  803306:	83 c4 10             	add    $0x10,%esp
			break;
  803309:	90                   	nop
		}
	}
}
  80330a:	eb 2e                	jmp    80333a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80330c:	a1 38 50 80 00       	mov    0x805038,%eax
  803311:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803318:	74 07                	je     803321 <free_block+0xa5>
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	eb 05                	jmp    803326 <free_block+0xaa>
  803321:	b8 00 00 00 00       	mov    $0x0,%eax
  803326:	a3 38 50 80 00       	mov    %eax,0x805038
  80332b:	a1 38 50 80 00       	mov    0x805038,%eax
  803330:	85 c0                	test   %eax,%eax
  803332:	75 a7                	jne    8032db <free_block+0x5f>
  803334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803338:	75 a1                	jne    8032db <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80333a:	90                   	nop
  80333b:	c9                   	leave  
  80333c:	c3                   	ret    

0080333d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80333d:	55                   	push   %ebp
  80333e:	89 e5                	mov    %esp,%ebp
  803340:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803343:	ff 75 08             	pushl  0x8(%ebp)
  803346:	e8 ed ec ff ff       	call   802038 <get_block_size>
  80334b:	83 c4 04             	add    $0x4,%esp
  80334e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803351:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803358:	eb 17                	jmp    803371 <copy_data+0x34>
  80335a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80335d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803360:	01 c2                	add    %eax,%edx
  803362:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	01 c8                	add    %ecx,%eax
  80336a:	8a 00                	mov    (%eax),%al
  80336c:	88 02                	mov    %al,(%edx)
  80336e:	ff 45 fc             	incl   -0x4(%ebp)
  803371:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803374:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803377:	72 e1                	jb     80335a <copy_data+0x1d>
}
  803379:	90                   	nop
  80337a:	c9                   	leave  
  80337b:	c3                   	ret    

0080337c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80337c:	55                   	push   %ebp
  80337d:	89 e5                	mov    %esp,%ebp
  80337f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803386:	75 23                	jne    8033ab <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803388:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80338c:	74 13                	je     8033a1 <realloc_block_FF+0x25>
  80338e:	83 ec 0c             	sub    $0xc,%esp
  803391:	ff 75 0c             	pushl  0xc(%ebp)
  803394:	e8 1f f0 ff ff       	call   8023b8 <alloc_block_FF>
  803399:	83 c4 10             	add    $0x10,%esp
  80339c:	e9 f4 06 00 00       	jmp    803a95 <realloc_block_FF+0x719>
		return NULL;
  8033a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a6:	e9 ea 06 00 00       	jmp    803a95 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8033ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033af:	75 18                	jne    8033c9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8033b1:	83 ec 0c             	sub    $0xc,%esp
  8033b4:	ff 75 08             	pushl  0x8(%ebp)
  8033b7:	e8 c0 fe ff ff       	call   80327c <free_block>
  8033bc:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c4:	e9 cc 06 00 00       	jmp    803a95 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8033c9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033cd:	77 07                	ja     8033d6 <realloc_block_FF+0x5a>
  8033cf:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8033d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d9:	83 e0 01             	and    $0x1,%eax
  8033dc:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8033df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e2:	83 c0 08             	add    $0x8,%eax
  8033e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8033e8:	83 ec 0c             	sub    $0xc,%esp
  8033eb:	ff 75 08             	pushl  0x8(%ebp)
  8033ee:	e8 45 ec ff ff       	call   802038 <get_block_size>
  8033f3:	83 c4 10             	add    $0x10,%esp
  8033f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fc:	83 e8 08             	sub    $0x8,%eax
  8033ff:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	83 e8 04             	sub    $0x4,%eax
  803408:	8b 00                	mov    (%eax),%eax
  80340a:	83 e0 fe             	and    $0xfffffffe,%eax
  80340d:	89 c2                	mov    %eax,%edx
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	01 d0                	add    %edx,%eax
  803414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803417:	83 ec 0c             	sub    $0xc,%esp
  80341a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80341d:	e8 16 ec ff ff       	call   802038 <get_block_size>
  803422:	83 c4 10             	add    $0x10,%esp
  803425:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342b:	83 e8 08             	sub    $0x8,%eax
  80342e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803431:	8b 45 0c             	mov    0xc(%ebp),%eax
  803434:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803437:	75 08                	jne    803441 <realloc_block_FF+0xc5>
	{
		 return va;
  803439:	8b 45 08             	mov    0x8(%ebp),%eax
  80343c:	e9 54 06 00 00       	jmp    803a95 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803441:	8b 45 0c             	mov    0xc(%ebp),%eax
  803444:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803447:	0f 83 e5 03 00 00    	jae    803832 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80344d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803450:	2b 45 0c             	sub    0xc(%ebp),%eax
  803453:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803456:	83 ec 0c             	sub    $0xc,%esp
  803459:	ff 75 e4             	pushl  -0x1c(%ebp)
  80345c:	e8 f0 eb ff ff       	call   802051 <is_free_block>
  803461:	83 c4 10             	add    $0x10,%esp
  803464:	84 c0                	test   %al,%al
  803466:	0f 84 3b 01 00 00    	je     8035a7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80346c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80346f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803472:	01 d0                	add    %edx,%eax
  803474:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803477:	83 ec 04             	sub    $0x4,%esp
  80347a:	6a 01                	push   $0x1
  80347c:	ff 75 f0             	pushl  -0x10(%ebp)
  80347f:	ff 75 08             	pushl  0x8(%ebp)
  803482:	e8 02 ef ff ff       	call   802389 <set_block_data>
  803487:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80348a:	8b 45 08             	mov    0x8(%ebp),%eax
  80348d:	83 e8 04             	sub    $0x4,%eax
  803490:	8b 00                	mov    (%eax),%eax
  803492:	83 e0 fe             	and    $0xfffffffe,%eax
  803495:	89 c2                	mov    %eax,%edx
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	01 d0                	add    %edx,%eax
  80349c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80349f:	83 ec 04             	sub    $0x4,%esp
  8034a2:	6a 00                	push   $0x0
  8034a4:	ff 75 cc             	pushl  -0x34(%ebp)
  8034a7:	ff 75 c8             	pushl  -0x38(%ebp)
  8034aa:	e8 da ee ff ff       	call   802389 <set_block_data>
  8034af:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8034b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034b6:	74 06                	je     8034be <realloc_block_FF+0x142>
  8034b8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8034bc:	75 17                	jne    8034d5 <realloc_block_FF+0x159>
  8034be:	83 ec 04             	sub    $0x4,%esp
  8034c1:	68 b0 46 80 00       	push   $0x8046b0
  8034c6:	68 f6 01 00 00       	push   $0x1f6
  8034cb:	68 3d 46 80 00       	push   $0x80463d
  8034d0:	e8 c3 ce ff ff       	call   800398 <_panic>
  8034d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d8:	8b 10                	mov    (%eax),%edx
  8034da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034dd:	89 10                	mov    %edx,(%eax)
  8034df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034e2:	8b 00                	mov    (%eax),%eax
  8034e4:	85 c0                	test   %eax,%eax
  8034e6:	74 0b                	je     8034f3 <realloc_block_FF+0x177>
  8034e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034eb:	8b 00                	mov    (%eax),%eax
  8034ed:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034f0:	89 50 04             	mov    %edx,0x4(%eax)
  8034f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034f9:	89 10                	mov    %edx,(%eax)
  8034fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803501:	89 50 04             	mov    %edx,0x4(%eax)
  803504:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803507:	8b 00                	mov    (%eax),%eax
  803509:	85 c0                	test   %eax,%eax
  80350b:	75 08                	jne    803515 <realloc_block_FF+0x199>
  80350d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803510:	a3 34 50 80 00       	mov    %eax,0x805034
  803515:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80351a:	40                   	inc    %eax
  80351b:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803520:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803524:	75 17                	jne    80353d <realloc_block_FF+0x1c1>
  803526:	83 ec 04             	sub    $0x4,%esp
  803529:	68 1f 46 80 00       	push   $0x80461f
  80352e:	68 f7 01 00 00       	push   $0x1f7
  803533:	68 3d 46 80 00       	push   $0x80463d
  803538:	e8 5b ce ff ff       	call   800398 <_panic>
  80353d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803540:	8b 00                	mov    (%eax),%eax
  803542:	85 c0                	test   %eax,%eax
  803544:	74 10                	je     803556 <realloc_block_FF+0x1da>
  803546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803549:	8b 00                	mov    (%eax),%eax
  80354b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80354e:	8b 52 04             	mov    0x4(%edx),%edx
  803551:	89 50 04             	mov    %edx,0x4(%eax)
  803554:	eb 0b                	jmp    803561 <realloc_block_FF+0x1e5>
  803556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803559:	8b 40 04             	mov    0x4(%eax),%eax
  80355c:	a3 34 50 80 00       	mov    %eax,0x805034
  803561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803564:	8b 40 04             	mov    0x4(%eax),%eax
  803567:	85 c0                	test   %eax,%eax
  803569:	74 0f                	je     80357a <realloc_block_FF+0x1fe>
  80356b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356e:	8b 40 04             	mov    0x4(%eax),%eax
  803571:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803574:	8b 12                	mov    (%edx),%edx
  803576:	89 10                	mov    %edx,(%eax)
  803578:	eb 0a                	jmp    803584 <realloc_block_FF+0x208>
  80357a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357d:	8b 00                	mov    (%eax),%eax
  80357f:	a3 30 50 80 00       	mov    %eax,0x805030
  803584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80358d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803590:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803597:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80359c:	48                   	dec    %eax
  80359d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035a2:	e9 83 02 00 00       	jmp    80382a <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8035a7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8035ab:	0f 86 69 02 00 00    	jbe    80381a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8035b1:	83 ec 04             	sub    $0x4,%esp
  8035b4:	6a 01                	push   $0x1
  8035b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8035b9:	ff 75 08             	pushl  0x8(%ebp)
  8035bc:	e8 c8 ed ff ff       	call   802389 <set_block_data>
  8035c1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c7:	83 e8 04             	sub    $0x4,%eax
  8035ca:	8b 00                	mov    (%eax),%eax
  8035cc:	83 e0 fe             	and    $0xfffffffe,%eax
  8035cf:	89 c2                	mov    %eax,%edx
  8035d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d4:	01 d0                	add    %edx,%eax
  8035d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8035d9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035de:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8035e1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8035e5:	75 68                	jne    80364f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035e7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035eb:	75 17                	jne    803604 <realloc_block_FF+0x288>
  8035ed:	83 ec 04             	sub    $0x4,%esp
  8035f0:	68 58 46 80 00       	push   $0x804658
  8035f5:	68 06 02 00 00       	push   $0x206
  8035fa:	68 3d 46 80 00       	push   $0x80463d
  8035ff:	e8 94 cd ff ff       	call   800398 <_panic>
  803604:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80360a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360d:	89 10                	mov    %edx,(%eax)
  80360f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803612:	8b 00                	mov    (%eax),%eax
  803614:	85 c0                	test   %eax,%eax
  803616:	74 0d                	je     803625 <realloc_block_FF+0x2a9>
  803618:	a1 30 50 80 00       	mov    0x805030,%eax
  80361d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803620:	89 50 04             	mov    %edx,0x4(%eax)
  803623:	eb 08                	jmp    80362d <realloc_block_FF+0x2b1>
  803625:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803628:	a3 34 50 80 00       	mov    %eax,0x805034
  80362d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803630:	a3 30 50 80 00       	mov    %eax,0x805030
  803635:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803638:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803644:	40                   	inc    %eax
  803645:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80364a:	e9 b0 01 00 00       	jmp    8037ff <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80364f:	a1 30 50 80 00       	mov    0x805030,%eax
  803654:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803657:	76 68                	jbe    8036c1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803659:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80365d:	75 17                	jne    803676 <realloc_block_FF+0x2fa>
  80365f:	83 ec 04             	sub    $0x4,%esp
  803662:	68 58 46 80 00       	push   $0x804658
  803667:	68 0b 02 00 00       	push   $0x20b
  80366c:	68 3d 46 80 00       	push   $0x80463d
  803671:	e8 22 cd ff ff       	call   800398 <_panic>
  803676:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80367c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367f:	89 10                	mov    %edx,(%eax)
  803681:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803684:	8b 00                	mov    (%eax),%eax
  803686:	85 c0                	test   %eax,%eax
  803688:	74 0d                	je     803697 <realloc_block_FF+0x31b>
  80368a:	a1 30 50 80 00       	mov    0x805030,%eax
  80368f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803692:	89 50 04             	mov    %edx,0x4(%eax)
  803695:	eb 08                	jmp    80369f <realloc_block_FF+0x323>
  803697:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369a:	a3 34 50 80 00       	mov    %eax,0x805034
  80369f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8036a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036b6:	40                   	inc    %eax
  8036b7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036bc:	e9 3e 01 00 00       	jmp    8037ff <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8036c1:	a1 30 50 80 00       	mov    0x805030,%eax
  8036c6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036c9:	73 68                	jae    803733 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036cf:	75 17                	jne    8036e8 <realloc_block_FF+0x36c>
  8036d1:	83 ec 04             	sub    $0x4,%esp
  8036d4:	68 8c 46 80 00       	push   $0x80468c
  8036d9:	68 10 02 00 00       	push   $0x210
  8036de:	68 3d 46 80 00       	push   $0x80463d
  8036e3:	e8 b0 cc ff ff       	call   800398 <_panic>
  8036e8:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8036ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f1:	89 50 04             	mov    %edx,0x4(%eax)
  8036f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f7:	8b 40 04             	mov    0x4(%eax),%eax
  8036fa:	85 c0                	test   %eax,%eax
  8036fc:	74 0c                	je     80370a <realloc_block_FF+0x38e>
  8036fe:	a1 34 50 80 00       	mov    0x805034,%eax
  803703:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803706:	89 10                	mov    %edx,(%eax)
  803708:	eb 08                	jmp    803712 <realloc_block_FF+0x396>
  80370a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80370d:	a3 30 50 80 00       	mov    %eax,0x805030
  803712:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803715:	a3 34 50 80 00       	mov    %eax,0x805034
  80371a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803723:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803728:	40                   	inc    %eax
  803729:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80372e:	e9 cc 00 00 00       	jmp    8037ff <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803733:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80373a:	a1 30 50 80 00       	mov    0x805030,%eax
  80373f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803742:	e9 8a 00 00 00       	jmp    8037d1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80374d:	73 7a                	jae    8037c9 <realloc_block_FF+0x44d>
  80374f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803752:	8b 00                	mov    (%eax),%eax
  803754:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803757:	73 70                	jae    8037c9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803759:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80375d:	74 06                	je     803765 <realloc_block_FF+0x3e9>
  80375f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803763:	75 17                	jne    80377c <realloc_block_FF+0x400>
  803765:	83 ec 04             	sub    $0x4,%esp
  803768:	68 b0 46 80 00       	push   $0x8046b0
  80376d:	68 1a 02 00 00       	push   $0x21a
  803772:	68 3d 46 80 00       	push   $0x80463d
  803777:	e8 1c cc ff ff       	call   800398 <_panic>
  80377c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377f:	8b 10                	mov    (%eax),%edx
  803781:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803784:	89 10                	mov    %edx,(%eax)
  803786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803789:	8b 00                	mov    (%eax),%eax
  80378b:	85 c0                	test   %eax,%eax
  80378d:	74 0b                	je     80379a <realloc_block_FF+0x41e>
  80378f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803792:	8b 00                	mov    (%eax),%eax
  803794:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803797:	89 50 04             	mov    %edx,0x4(%eax)
  80379a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037a0:	89 10                	mov    %edx,(%eax)
  8037a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037a8:	89 50 04             	mov    %edx,0x4(%eax)
  8037ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ae:	8b 00                	mov    (%eax),%eax
  8037b0:	85 c0                	test   %eax,%eax
  8037b2:	75 08                	jne    8037bc <realloc_block_FF+0x440>
  8037b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b7:	a3 34 50 80 00       	mov    %eax,0x805034
  8037bc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037c1:	40                   	inc    %eax
  8037c2:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  8037c7:	eb 36                	jmp    8037ff <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d5:	74 07                	je     8037de <realloc_block_FF+0x462>
  8037d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037da:	8b 00                	mov    (%eax),%eax
  8037dc:	eb 05                	jmp    8037e3 <realloc_block_FF+0x467>
  8037de:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e3:	a3 38 50 80 00       	mov    %eax,0x805038
  8037e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ed:	85 c0                	test   %eax,%eax
  8037ef:	0f 85 52 ff ff ff    	jne    803747 <realloc_block_FF+0x3cb>
  8037f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f9:	0f 85 48 ff ff ff    	jne    803747 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8037ff:	83 ec 04             	sub    $0x4,%esp
  803802:	6a 00                	push   $0x0
  803804:	ff 75 d8             	pushl  -0x28(%ebp)
  803807:	ff 75 d4             	pushl  -0x2c(%ebp)
  80380a:	e8 7a eb ff ff       	call   802389 <set_block_data>
  80380f:	83 c4 10             	add    $0x10,%esp
				return va;
  803812:	8b 45 08             	mov    0x8(%ebp),%eax
  803815:	e9 7b 02 00 00       	jmp    803a95 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80381a:	83 ec 0c             	sub    $0xc,%esp
  80381d:	68 2d 47 80 00       	push   $0x80472d
  803822:	e8 2e ce ff ff       	call   800655 <cprintf>
  803827:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80382a:	8b 45 08             	mov    0x8(%ebp),%eax
  80382d:	e9 63 02 00 00       	jmp    803a95 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803832:	8b 45 0c             	mov    0xc(%ebp),%eax
  803835:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803838:	0f 86 4d 02 00 00    	jbe    803a8b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80383e:	83 ec 0c             	sub    $0xc,%esp
  803841:	ff 75 e4             	pushl  -0x1c(%ebp)
  803844:	e8 08 e8 ff ff       	call   802051 <is_free_block>
  803849:	83 c4 10             	add    $0x10,%esp
  80384c:	84 c0                	test   %al,%al
  80384e:	0f 84 37 02 00 00    	je     803a8b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803854:	8b 45 0c             	mov    0xc(%ebp),%eax
  803857:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80385a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80385d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803860:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803863:	76 38                	jbe    80389d <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803865:	83 ec 0c             	sub    $0xc,%esp
  803868:	ff 75 08             	pushl  0x8(%ebp)
  80386b:	e8 0c fa ff ff       	call   80327c <free_block>
  803870:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803873:	83 ec 0c             	sub    $0xc,%esp
  803876:	ff 75 0c             	pushl  0xc(%ebp)
  803879:	e8 3a eb ff ff       	call   8023b8 <alloc_block_FF>
  80387e:	83 c4 10             	add    $0x10,%esp
  803881:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803884:	83 ec 08             	sub    $0x8,%esp
  803887:	ff 75 c0             	pushl  -0x40(%ebp)
  80388a:	ff 75 08             	pushl  0x8(%ebp)
  80388d:	e8 ab fa ff ff       	call   80333d <copy_data>
  803892:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803895:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803898:	e9 f8 01 00 00       	jmp    803a95 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80389d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038a0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038a3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038a6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8038aa:	0f 87 a0 00 00 00    	ja     803950 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8038b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038b4:	75 17                	jne    8038cd <realloc_block_FF+0x551>
  8038b6:	83 ec 04             	sub    $0x4,%esp
  8038b9:	68 1f 46 80 00       	push   $0x80461f
  8038be:	68 38 02 00 00       	push   $0x238
  8038c3:	68 3d 46 80 00       	push   $0x80463d
  8038c8:	e8 cb ca ff ff       	call   800398 <_panic>
  8038cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d0:	8b 00                	mov    (%eax),%eax
  8038d2:	85 c0                	test   %eax,%eax
  8038d4:	74 10                	je     8038e6 <realloc_block_FF+0x56a>
  8038d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d9:	8b 00                	mov    (%eax),%eax
  8038db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038de:	8b 52 04             	mov    0x4(%edx),%edx
  8038e1:	89 50 04             	mov    %edx,0x4(%eax)
  8038e4:	eb 0b                	jmp    8038f1 <realloc_block_FF+0x575>
  8038e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e9:	8b 40 04             	mov    0x4(%eax),%eax
  8038ec:	a3 34 50 80 00       	mov    %eax,0x805034
  8038f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f4:	8b 40 04             	mov    0x4(%eax),%eax
  8038f7:	85 c0                	test   %eax,%eax
  8038f9:	74 0f                	je     80390a <realloc_block_FF+0x58e>
  8038fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fe:	8b 40 04             	mov    0x4(%eax),%eax
  803901:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803904:	8b 12                	mov    (%edx),%edx
  803906:	89 10                	mov    %edx,(%eax)
  803908:	eb 0a                	jmp    803914 <realloc_block_FF+0x598>
  80390a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390d:	8b 00                	mov    (%eax),%eax
  80390f:	a3 30 50 80 00       	mov    %eax,0x805030
  803914:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803917:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80391d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803920:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803927:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80392c:	48                   	dec    %eax
  80392d:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803932:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803935:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803938:	01 d0                	add    %edx,%eax
  80393a:	83 ec 04             	sub    $0x4,%esp
  80393d:	6a 01                	push   $0x1
  80393f:	50                   	push   %eax
  803940:	ff 75 08             	pushl  0x8(%ebp)
  803943:	e8 41 ea ff ff       	call   802389 <set_block_data>
  803948:	83 c4 10             	add    $0x10,%esp
  80394b:	e9 36 01 00 00       	jmp    803a86 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803950:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803953:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803956:	01 d0                	add    %edx,%eax
  803958:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80395b:	83 ec 04             	sub    $0x4,%esp
  80395e:	6a 01                	push   $0x1
  803960:	ff 75 f0             	pushl  -0x10(%ebp)
  803963:	ff 75 08             	pushl  0x8(%ebp)
  803966:	e8 1e ea ff ff       	call   802389 <set_block_data>
  80396b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80396e:	8b 45 08             	mov    0x8(%ebp),%eax
  803971:	83 e8 04             	sub    $0x4,%eax
  803974:	8b 00                	mov    (%eax),%eax
  803976:	83 e0 fe             	and    $0xfffffffe,%eax
  803979:	89 c2                	mov    %eax,%edx
  80397b:	8b 45 08             	mov    0x8(%ebp),%eax
  80397e:	01 d0                	add    %edx,%eax
  803980:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803987:	74 06                	je     80398f <realloc_block_FF+0x613>
  803989:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80398d:	75 17                	jne    8039a6 <realloc_block_FF+0x62a>
  80398f:	83 ec 04             	sub    $0x4,%esp
  803992:	68 b0 46 80 00       	push   $0x8046b0
  803997:	68 44 02 00 00       	push   $0x244
  80399c:	68 3d 46 80 00       	push   $0x80463d
  8039a1:	e8 f2 c9 ff ff       	call   800398 <_panic>
  8039a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a9:	8b 10                	mov    (%eax),%edx
  8039ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039ae:	89 10                	mov    %edx,(%eax)
  8039b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039b3:	8b 00                	mov    (%eax),%eax
  8039b5:	85 c0                	test   %eax,%eax
  8039b7:	74 0b                	je     8039c4 <realloc_block_FF+0x648>
  8039b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bc:	8b 00                	mov    (%eax),%eax
  8039be:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039c1:	89 50 04             	mov    %edx,0x4(%eax)
  8039c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039ca:	89 10                	mov    %edx,(%eax)
  8039cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d2:	89 50 04             	mov    %edx,0x4(%eax)
  8039d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039d8:	8b 00                	mov    (%eax),%eax
  8039da:	85 c0                	test   %eax,%eax
  8039dc:	75 08                	jne    8039e6 <realloc_block_FF+0x66a>
  8039de:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039e1:	a3 34 50 80 00       	mov    %eax,0x805034
  8039e6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039eb:	40                   	inc    %eax
  8039ec:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039f5:	75 17                	jne    803a0e <realloc_block_FF+0x692>
  8039f7:	83 ec 04             	sub    $0x4,%esp
  8039fa:	68 1f 46 80 00       	push   $0x80461f
  8039ff:	68 45 02 00 00       	push   $0x245
  803a04:	68 3d 46 80 00       	push   $0x80463d
  803a09:	e8 8a c9 ff ff       	call   800398 <_panic>
  803a0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a11:	8b 00                	mov    (%eax),%eax
  803a13:	85 c0                	test   %eax,%eax
  803a15:	74 10                	je     803a27 <realloc_block_FF+0x6ab>
  803a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1a:	8b 00                	mov    (%eax),%eax
  803a1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a1f:	8b 52 04             	mov    0x4(%edx),%edx
  803a22:	89 50 04             	mov    %edx,0x4(%eax)
  803a25:	eb 0b                	jmp    803a32 <realloc_block_FF+0x6b6>
  803a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2a:	8b 40 04             	mov    0x4(%eax),%eax
  803a2d:	a3 34 50 80 00       	mov    %eax,0x805034
  803a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a35:	8b 40 04             	mov    0x4(%eax),%eax
  803a38:	85 c0                	test   %eax,%eax
  803a3a:	74 0f                	je     803a4b <realloc_block_FF+0x6cf>
  803a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3f:	8b 40 04             	mov    0x4(%eax),%eax
  803a42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a45:	8b 12                	mov    (%edx),%edx
  803a47:	89 10                	mov    %edx,(%eax)
  803a49:	eb 0a                	jmp    803a55 <realloc_block_FF+0x6d9>
  803a4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4e:	8b 00                	mov    (%eax),%eax
  803a50:	a3 30 50 80 00       	mov    %eax,0x805030
  803a55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a68:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a6d:	48                   	dec    %eax
  803a6e:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803a73:	83 ec 04             	sub    $0x4,%esp
  803a76:	6a 00                	push   $0x0
  803a78:	ff 75 bc             	pushl  -0x44(%ebp)
  803a7b:	ff 75 b8             	pushl  -0x48(%ebp)
  803a7e:	e8 06 e9 ff ff       	call   802389 <set_block_data>
  803a83:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a86:	8b 45 08             	mov    0x8(%ebp),%eax
  803a89:	eb 0a                	jmp    803a95 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a8b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a95:	c9                   	leave  
  803a96:	c3                   	ret    

00803a97 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a97:	55                   	push   %ebp
  803a98:	89 e5                	mov    %esp,%ebp
  803a9a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a9d:	83 ec 04             	sub    $0x4,%esp
  803aa0:	68 34 47 80 00       	push   $0x804734
  803aa5:	68 58 02 00 00       	push   $0x258
  803aaa:	68 3d 46 80 00       	push   $0x80463d
  803aaf:	e8 e4 c8 ff ff       	call   800398 <_panic>

00803ab4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ab4:	55                   	push   %ebp
  803ab5:	89 e5                	mov    %esp,%ebp
  803ab7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803aba:	83 ec 04             	sub    $0x4,%esp
  803abd:	68 5c 47 80 00       	push   $0x80475c
  803ac2:	68 61 02 00 00       	push   $0x261
  803ac7:	68 3d 46 80 00       	push   $0x80463d
  803acc:	e8 c7 c8 ff ff       	call   800398 <_panic>
  803ad1:	66 90                	xchg   %ax,%ax
  803ad3:	90                   	nop

00803ad4 <__udivdi3>:
  803ad4:	55                   	push   %ebp
  803ad5:	57                   	push   %edi
  803ad6:	56                   	push   %esi
  803ad7:	53                   	push   %ebx
  803ad8:	83 ec 1c             	sub    $0x1c,%esp
  803adb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803adf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ae3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ae7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803aeb:	89 ca                	mov    %ecx,%edx
  803aed:	89 f8                	mov    %edi,%eax
  803aef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803af3:	85 f6                	test   %esi,%esi
  803af5:	75 2d                	jne    803b24 <__udivdi3+0x50>
  803af7:	39 cf                	cmp    %ecx,%edi
  803af9:	77 65                	ja     803b60 <__udivdi3+0x8c>
  803afb:	89 fd                	mov    %edi,%ebp
  803afd:	85 ff                	test   %edi,%edi
  803aff:	75 0b                	jne    803b0c <__udivdi3+0x38>
  803b01:	b8 01 00 00 00       	mov    $0x1,%eax
  803b06:	31 d2                	xor    %edx,%edx
  803b08:	f7 f7                	div    %edi
  803b0a:	89 c5                	mov    %eax,%ebp
  803b0c:	31 d2                	xor    %edx,%edx
  803b0e:	89 c8                	mov    %ecx,%eax
  803b10:	f7 f5                	div    %ebp
  803b12:	89 c1                	mov    %eax,%ecx
  803b14:	89 d8                	mov    %ebx,%eax
  803b16:	f7 f5                	div    %ebp
  803b18:	89 cf                	mov    %ecx,%edi
  803b1a:	89 fa                	mov    %edi,%edx
  803b1c:	83 c4 1c             	add    $0x1c,%esp
  803b1f:	5b                   	pop    %ebx
  803b20:	5e                   	pop    %esi
  803b21:	5f                   	pop    %edi
  803b22:	5d                   	pop    %ebp
  803b23:	c3                   	ret    
  803b24:	39 ce                	cmp    %ecx,%esi
  803b26:	77 28                	ja     803b50 <__udivdi3+0x7c>
  803b28:	0f bd fe             	bsr    %esi,%edi
  803b2b:	83 f7 1f             	xor    $0x1f,%edi
  803b2e:	75 40                	jne    803b70 <__udivdi3+0x9c>
  803b30:	39 ce                	cmp    %ecx,%esi
  803b32:	72 0a                	jb     803b3e <__udivdi3+0x6a>
  803b34:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b38:	0f 87 9e 00 00 00    	ja     803bdc <__udivdi3+0x108>
  803b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b43:	89 fa                	mov    %edi,%edx
  803b45:	83 c4 1c             	add    $0x1c,%esp
  803b48:	5b                   	pop    %ebx
  803b49:	5e                   	pop    %esi
  803b4a:	5f                   	pop    %edi
  803b4b:	5d                   	pop    %ebp
  803b4c:	c3                   	ret    
  803b4d:	8d 76 00             	lea    0x0(%esi),%esi
  803b50:	31 ff                	xor    %edi,%edi
  803b52:	31 c0                	xor    %eax,%eax
  803b54:	89 fa                	mov    %edi,%edx
  803b56:	83 c4 1c             	add    $0x1c,%esp
  803b59:	5b                   	pop    %ebx
  803b5a:	5e                   	pop    %esi
  803b5b:	5f                   	pop    %edi
  803b5c:	5d                   	pop    %ebp
  803b5d:	c3                   	ret    
  803b5e:	66 90                	xchg   %ax,%ax
  803b60:	89 d8                	mov    %ebx,%eax
  803b62:	f7 f7                	div    %edi
  803b64:	31 ff                	xor    %edi,%edi
  803b66:	89 fa                	mov    %edi,%edx
  803b68:	83 c4 1c             	add    $0x1c,%esp
  803b6b:	5b                   	pop    %ebx
  803b6c:	5e                   	pop    %esi
  803b6d:	5f                   	pop    %edi
  803b6e:	5d                   	pop    %ebp
  803b6f:	c3                   	ret    
  803b70:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b75:	89 eb                	mov    %ebp,%ebx
  803b77:	29 fb                	sub    %edi,%ebx
  803b79:	89 f9                	mov    %edi,%ecx
  803b7b:	d3 e6                	shl    %cl,%esi
  803b7d:	89 c5                	mov    %eax,%ebp
  803b7f:	88 d9                	mov    %bl,%cl
  803b81:	d3 ed                	shr    %cl,%ebp
  803b83:	89 e9                	mov    %ebp,%ecx
  803b85:	09 f1                	or     %esi,%ecx
  803b87:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b8b:	89 f9                	mov    %edi,%ecx
  803b8d:	d3 e0                	shl    %cl,%eax
  803b8f:	89 c5                	mov    %eax,%ebp
  803b91:	89 d6                	mov    %edx,%esi
  803b93:	88 d9                	mov    %bl,%cl
  803b95:	d3 ee                	shr    %cl,%esi
  803b97:	89 f9                	mov    %edi,%ecx
  803b99:	d3 e2                	shl    %cl,%edx
  803b9b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b9f:	88 d9                	mov    %bl,%cl
  803ba1:	d3 e8                	shr    %cl,%eax
  803ba3:	09 c2                	or     %eax,%edx
  803ba5:	89 d0                	mov    %edx,%eax
  803ba7:	89 f2                	mov    %esi,%edx
  803ba9:	f7 74 24 0c          	divl   0xc(%esp)
  803bad:	89 d6                	mov    %edx,%esi
  803baf:	89 c3                	mov    %eax,%ebx
  803bb1:	f7 e5                	mul    %ebp
  803bb3:	39 d6                	cmp    %edx,%esi
  803bb5:	72 19                	jb     803bd0 <__udivdi3+0xfc>
  803bb7:	74 0b                	je     803bc4 <__udivdi3+0xf0>
  803bb9:	89 d8                	mov    %ebx,%eax
  803bbb:	31 ff                	xor    %edi,%edi
  803bbd:	e9 58 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803bc2:	66 90                	xchg   %ax,%ax
  803bc4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bc8:	89 f9                	mov    %edi,%ecx
  803bca:	d3 e2                	shl    %cl,%edx
  803bcc:	39 c2                	cmp    %eax,%edx
  803bce:	73 e9                	jae    803bb9 <__udivdi3+0xe5>
  803bd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bd3:	31 ff                	xor    %edi,%edi
  803bd5:	e9 40 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803bda:	66 90                	xchg   %ax,%ax
  803bdc:	31 c0                	xor    %eax,%eax
  803bde:	e9 37 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803be3:	90                   	nop

00803be4 <__umoddi3>:
  803be4:	55                   	push   %ebp
  803be5:	57                   	push   %edi
  803be6:	56                   	push   %esi
  803be7:	53                   	push   %ebx
  803be8:	83 ec 1c             	sub    $0x1c,%esp
  803beb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bef:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bf7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bfb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c03:	89 f3                	mov    %esi,%ebx
  803c05:	89 fa                	mov    %edi,%edx
  803c07:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c0b:	89 34 24             	mov    %esi,(%esp)
  803c0e:	85 c0                	test   %eax,%eax
  803c10:	75 1a                	jne    803c2c <__umoddi3+0x48>
  803c12:	39 f7                	cmp    %esi,%edi
  803c14:	0f 86 a2 00 00 00    	jbe    803cbc <__umoddi3+0xd8>
  803c1a:	89 c8                	mov    %ecx,%eax
  803c1c:	89 f2                	mov    %esi,%edx
  803c1e:	f7 f7                	div    %edi
  803c20:	89 d0                	mov    %edx,%eax
  803c22:	31 d2                	xor    %edx,%edx
  803c24:	83 c4 1c             	add    $0x1c,%esp
  803c27:	5b                   	pop    %ebx
  803c28:	5e                   	pop    %esi
  803c29:	5f                   	pop    %edi
  803c2a:	5d                   	pop    %ebp
  803c2b:	c3                   	ret    
  803c2c:	39 f0                	cmp    %esi,%eax
  803c2e:	0f 87 ac 00 00 00    	ja     803ce0 <__umoddi3+0xfc>
  803c34:	0f bd e8             	bsr    %eax,%ebp
  803c37:	83 f5 1f             	xor    $0x1f,%ebp
  803c3a:	0f 84 ac 00 00 00    	je     803cec <__umoddi3+0x108>
  803c40:	bf 20 00 00 00       	mov    $0x20,%edi
  803c45:	29 ef                	sub    %ebp,%edi
  803c47:	89 fe                	mov    %edi,%esi
  803c49:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c4d:	89 e9                	mov    %ebp,%ecx
  803c4f:	d3 e0                	shl    %cl,%eax
  803c51:	89 d7                	mov    %edx,%edi
  803c53:	89 f1                	mov    %esi,%ecx
  803c55:	d3 ef                	shr    %cl,%edi
  803c57:	09 c7                	or     %eax,%edi
  803c59:	89 e9                	mov    %ebp,%ecx
  803c5b:	d3 e2                	shl    %cl,%edx
  803c5d:	89 14 24             	mov    %edx,(%esp)
  803c60:	89 d8                	mov    %ebx,%eax
  803c62:	d3 e0                	shl    %cl,%eax
  803c64:	89 c2                	mov    %eax,%edx
  803c66:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c6a:	d3 e0                	shl    %cl,%eax
  803c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c70:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c74:	89 f1                	mov    %esi,%ecx
  803c76:	d3 e8                	shr    %cl,%eax
  803c78:	09 d0                	or     %edx,%eax
  803c7a:	d3 eb                	shr    %cl,%ebx
  803c7c:	89 da                	mov    %ebx,%edx
  803c7e:	f7 f7                	div    %edi
  803c80:	89 d3                	mov    %edx,%ebx
  803c82:	f7 24 24             	mull   (%esp)
  803c85:	89 c6                	mov    %eax,%esi
  803c87:	89 d1                	mov    %edx,%ecx
  803c89:	39 d3                	cmp    %edx,%ebx
  803c8b:	0f 82 87 00 00 00    	jb     803d18 <__umoddi3+0x134>
  803c91:	0f 84 91 00 00 00    	je     803d28 <__umoddi3+0x144>
  803c97:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c9b:	29 f2                	sub    %esi,%edx
  803c9d:	19 cb                	sbb    %ecx,%ebx
  803c9f:	89 d8                	mov    %ebx,%eax
  803ca1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ca5:	d3 e0                	shl    %cl,%eax
  803ca7:	89 e9                	mov    %ebp,%ecx
  803ca9:	d3 ea                	shr    %cl,%edx
  803cab:	09 d0                	or     %edx,%eax
  803cad:	89 e9                	mov    %ebp,%ecx
  803caf:	d3 eb                	shr    %cl,%ebx
  803cb1:	89 da                	mov    %ebx,%edx
  803cb3:	83 c4 1c             	add    $0x1c,%esp
  803cb6:	5b                   	pop    %ebx
  803cb7:	5e                   	pop    %esi
  803cb8:	5f                   	pop    %edi
  803cb9:	5d                   	pop    %ebp
  803cba:	c3                   	ret    
  803cbb:	90                   	nop
  803cbc:	89 fd                	mov    %edi,%ebp
  803cbe:	85 ff                	test   %edi,%edi
  803cc0:	75 0b                	jne    803ccd <__umoddi3+0xe9>
  803cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cc7:	31 d2                	xor    %edx,%edx
  803cc9:	f7 f7                	div    %edi
  803ccb:	89 c5                	mov    %eax,%ebp
  803ccd:	89 f0                	mov    %esi,%eax
  803ccf:	31 d2                	xor    %edx,%edx
  803cd1:	f7 f5                	div    %ebp
  803cd3:	89 c8                	mov    %ecx,%eax
  803cd5:	f7 f5                	div    %ebp
  803cd7:	89 d0                	mov    %edx,%eax
  803cd9:	e9 44 ff ff ff       	jmp    803c22 <__umoddi3+0x3e>
  803cde:	66 90                	xchg   %ax,%ax
  803ce0:	89 c8                	mov    %ecx,%eax
  803ce2:	89 f2                	mov    %esi,%edx
  803ce4:	83 c4 1c             	add    $0x1c,%esp
  803ce7:	5b                   	pop    %ebx
  803ce8:	5e                   	pop    %esi
  803ce9:	5f                   	pop    %edi
  803cea:	5d                   	pop    %ebp
  803ceb:	c3                   	ret    
  803cec:	3b 04 24             	cmp    (%esp),%eax
  803cef:	72 06                	jb     803cf7 <__umoddi3+0x113>
  803cf1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cf5:	77 0f                	ja     803d06 <__umoddi3+0x122>
  803cf7:	89 f2                	mov    %esi,%edx
  803cf9:	29 f9                	sub    %edi,%ecx
  803cfb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cff:	89 14 24             	mov    %edx,(%esp)
  803d02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d06:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d0a:	8b 14 24             	mov    (%esp),%edx
  803d0d:	83 c4 1c             	add    $0x1c,%esp
  803d10:	5b                   	pop    %ebx
  803d11:	5e                   	pop    %esi
  803d12:	5f                   	pop    %edi
  803d13:	5d                   	pop    %ebp
  803d14:	c3                   	ret    
  803d15:	8d 76 00             	lea    0x0(%esi),%esi
  803d18:	2b 04 24             	sub    (%esp),%eax
  803d1b:	19 fa                	sbb    %edi,%edx
  803d1d:	89 d1                	mov    %edx,%ecx
  803d1f:	89 c6                	mov    %eax,%esi
  803d21:	e9 71 ff ff ff       	jmp    803c97 <__umoddi3+0xb3>
  803d26:	66 90                	xchg   %ax,%ax
  803d28:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d2c:	72 ea                	jb     803d18 <__umoddi3+0x134>
  803d2e:	89 d9                	mov    %ebx,%ecx
  803d30:	e9 62 ff ff ff       	jmp    803c97 <__umoddi3+0xb3>
