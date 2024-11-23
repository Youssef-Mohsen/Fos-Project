
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
  80005c:	68 40 3c 80 00       	push   $0x803c40
  800061:	6a 0d                	push   $0xd
  800063:	68 5c 3c 80 00       	push   $0x803c5c
  800068:	e8 2b 03 00 00       	call   800398 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  800074:	e8 9a 1b 00 00       	call   801c13 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int freeFrames, diff, expected;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 fd 18 00 00       	call   80197e <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 ab 19 00 00       	call   801a31 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 77 3c 80 00       	push   $0x803c77
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 41 17 00 00       	call   8017da <sget>
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
  8000b6:	68 7c 3c 80 00       	push   $0x803c7c
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 5c 3c 80 00       	push   $0x803c5c
  8000c2:	e8 d1 02 00 00       	call   800398 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 5b 19 00 00       	call   801a31 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 44 19 00 00       	call   801a31 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 f8 3c 80 00       	push   $0x803cf8
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 5c 3c 80 00       	push   $0x803c5c
  800104:	e8 8f 02 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 8a 18 00 00       	call   801998 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 6b 18 00 00       	call   80197e <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 19 19 00 00       	call   801a31 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 90 3d 80 00       	push   $0x803d90
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 af 16 00 00       	call   8017da <sget>
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
  80014d:	68 7c 3c 80 00       	push   $0x803c7c
  800152:	6a 31                	push   $0x31
  800154:	68 5c 3c 80 00       	push   $0x803c5c
  800159:	e8 3a 02 00 00       	call   800398 <_panic>
		expected = 0;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 c4 18 00 00       	call   801a31 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 ad 18 00 00       	call   801a31 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 f8 3c 80 00       	push   $0x803cf8
  800194:	6a 34                	push   $0x34
  800196:	68 5c 3c 80 00       	push   $0x803c5c
  80019b:	e8 f8 01 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 f3 17 00 00       	call   801998 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 0a             	cmp    $0xa,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 94 3d 80 00       	push   $0x803d94
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 5c 3c 80 00       	push   $0x803c5c
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
  8001d9:	68 94 3d 80 00       	push   $0x803d94
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 5c 3c 80 00       	push   $0x803c5c
  8001e5:	e8 ae 01 00 00       	call   800398 <_panic>

	inctst();
  8001ea:	e8 49 1b 00 00       	call   801d38 <inctst>

	//sync with master
	while (gettst() != 5) ;
  8001ef:	90                   	nop
  8001f0:	e8 5d 1b 00 00       	call   801d52 <gettst>
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	75 f6                	jne    8001f0 <_main+0x1b8>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 06                	push   $0x6
  8001ff:	e8 ae 1a 00 00       	call   801cb2 <sys_bypassPageFault>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	68 cc 3d 80 00       	push   $0x803dcc
  800212:	e8 3e 04 00 00       	call   800655 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 85 1a 00 00       	call   801cb2 <sys_bypassPageFault>
  80022d:	83 c4 10             	add    $0x10,%esp

	inctst();
  800230:	e8 03 1b 00 00       	call   801d38 <inctst>
	if (*x == 100)
  800235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	83 f8 64             	cmp    $0x64,%eax
  80023d:	75 14                	jne    800253 <_main+0x21b>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 fc 3d 80 00       	push   $0x803dfc
  800247:	6a 4d                	push   $0x4d
  800249:	68 5c 3c 80 00       	push   $0x803c5c
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
  80025f:	e8 96 19 00 00       	call   801bfa <sys_getenvindex>
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
  8002cd:	e8 ac 16 00 00       	call   80197e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	68 5c 3e 80 00       	push   $0x803e5c
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
  8002fd:	68 84 3e 80 00       	push   $0x803e84
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
  80032e:	68 ac 3e 80 00       	push   $0x803eac
  800333:	e8 1d 03 00 00       	call   800655 <cprintf>
  800338:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80033b:	a1 20 50 80 00       	mov    0x805020,%eax
  800340:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	50                   	push   %eax
  80034a:	68 04 3f 80 00       	push   $0x803f04
  80034f:	e8 01 03 00 00       	call   800655 <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	68 5c 3e 80 00       	push   $0x803e5c
  80035f:	e8 f1 02 00 00       	call   800655 <cprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800367:	e8 2c 16 00 00       	call   801998 <sys_unlock_cons>
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
  80037f:	e8 42 18 00 00       	call   801bc6 <sys_destroy_env>
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
  800390:	e8 97 18 00 00       	call   801c2c <sys_exit_env>
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
  8003b9:	68 18 3f 80 00       	push   $0x803f18
  8003be:	e8 92 02 00 00       	call   800655 <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003c6:	a1 00 50 80 00       	mov    0x805000,%eax
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	50                   	push   %eax
  8003d2:	68 1d 3f 80 00       	push   $0x803f1d
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
  8003f6:	68 39 3f 80 00       	push   $0x803f39
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
  800425:	68 3c 3f 80 00       	push   $0x803f3c
  80042a:	6a 26                	push   $0x26
  80042c:	68 88 3f 80 00       	push   $0x803f88
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
  8004fa:	68 94 3f 80 00       	push   $0x803f94
  8004ff:	6a 3a                	push   $0x3a
  800501:	68 88 3f 80 00       	push   $0x803f88
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
  80056d:	68 e8 3f 80 00       	push   $0x803fe8
  800572:	6a 44                	push   $0x44
  800574:	68 88 3f 80 00       	push   $0x803f88
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
  8005c7:	e8 70 13 00 00       	call   80193c <sys_cputs>
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
  80063e:	e8 f9 12 00 00       	call   80193c <sys_cputs>
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
  800688:	e8 f1 12 00 00       	call   80197e <sys_lock_cons>
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
  8006a8:	e8 eb 12 00 00       	call   801998 <sys_unlock_cons>
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
  8006f2:	e8 dd 32 00 00       	call   8039d4 <__udivdi3>
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
  800742:	e8 9d 33 00 00       	call   803ae4 <__umoddi3>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	05 54 42 80 00       	add    $0x804254,%eax
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
  80089d:	8b 04 85 78 42 80 00 	mov    0x804278(,%eax,4),%eax
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
  80097e:	8b 34 9d c0 40 80 00 	mov    0x8040c0(,%ebx,4),%esi
  800985:	85 f6                	test   %esi,%esi
  800987:	75 19                	jne    8009a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800989:	53                   	push   %ebx
  80098a:	68 65 42 80 00       	push   $0x804265
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
  8009a3:	68 6e 42 80 00       	push   $0x80426e
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
  8009d0:	be 71 42 80 00       	mov    $0x804271,%esi
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
  8013db:	68 e8 43 80 00       	push   $0x8043e8
  8013e0:	68 3f 01 00 00       	push   $0x13f
  8013e5:	68 0a 44 80 00       	push   $0x80440a
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
  8013fb:	e8 e7 0a 00 00       	call   801ee7 <sys_sbrk>
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
  801476:	e8 f0 08 00 00       	call   801d6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80147b:	85 c0                	test   %eax,%eax
  80147d:	74 16                	je     801495 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	e8 30 0e 00 00       	call   8022ba <alloc_block_FF>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801490:	e9 8a 01 00 00       	jmp    80161f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801495:	e8 02 09 00 00       	call   801d9c <sys_isUHeapPlacementStrategyBESTFIT>
  80149a:	85 c0                	test   %eax,%eax
  80149c:	0f 84 7d 01 00 00    	je     80161f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 c9 12 00 00       	call   802776 <alloc_block_BF>
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
  8014f8:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801545:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  80159c:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  8015fe:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801605:	83 ec 08             	sub    $0x8,%esp
  801608:	ff 75 08             	pushl  0x8(%ebp)
  80160b:	ff 75 f0             	pushl  -0x10(%ebp)
  80160e:	e8 0b 09 00 00       	call   801f1e <sys_allocate_user_mem>
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
  801656:	e8 df 08 00 00       	call   801f3a <get_block_size>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	e8 12 1b 00 00       	call   80317e <free_block>
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
  8016a1:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  8016de:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  8016fe:	e8 ff 07 00 00       	call   801f02 <sys_free_user_mem>
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
  80170c:	68 18 44 80 00       	push   $0x804418
  801711:	68 85 00 00 00       	push   $0x85
  801716:	68 42 44 80 00       	push   $0x804442
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
  801732:	75 0a                	jne    80173e <smalloc+0x1c>
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
  801739:	e9 9a 00 00 00       	jmp    8017d8 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80173e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801741:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801744:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80174b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801751:	39 d0                	cmp    %edx,%eax
  801753:	73 02                	jae    801757 <smalloc+0x35>
  801755:	89 d0                	mov    %edx,%eax
  801757:	83 ec 0c             	sub    $0xc,%esp
  80175a:	50                   	push   %eax
  80175b:	e8 a5 fc ff ff       	call   801405 <malloc>
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801766:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80176a:	75 07                	jne    801773 <smalloc+0x51>
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
  801771:	eb 65                	jmp    8017d8 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801773:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801777:	ff 75 ec             	pushl  -0x14(%ebp)
  80177a:	50                   	push   %eax
  80177b:	ff 75 0c             	pushl  0xc(%ebp)
  80177e:	ff 75 08             	pushl  0x8(%ebp)
  801781:	e8 83 03 00 00       	call   801b09 <sys_createSharedObject>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80178c:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801790:	74 06                	je     801798 <smalloc+0x76>
  801792:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801796:	75 07                	jne    80179f <smalloc+0x7d>
  801798:	b8 00 00 00 00       	mov    $0x0,%eax
  80179d:	eb 39                	jmp    8017d8 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8017a5:	68 4e 44 80 00       	push   $0x80444e
  8017aa:	e8 a6 ee ff ff       	call   800655 <cprintf>
  8017af:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8017b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8017ba:	8b 40 78             	mov    0x78(%eax),%eax
  8017bd:	29 c2                	sub    %eax,%edx
  8017bf:	89 d0                	mov    %edx,%eax
  8017c1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017c6:	c1 e8 0c             	shr    $0xc,%eax
  8017c9:	89 c2                	mov    %eax,%edx
  8017cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ce:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8017d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017e0:	83 ec 08             	sub    $0x8,%esp
  8017e3:	ff 75 0c             	pushl  0xc(%ebp)
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	e8 45 03 00 00       	call   801b33 <sys_getSizeOfSharedObject>
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8017f4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017f8:	75 07                	jne    801801 <sget+0x27>
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ff:	eb 5c                	jmp    80185d <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801804:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801807:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80180e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801814:	39 d0                	cmp    %edx,%eax
  801816:	7d 02                	jge    80181a <sget+0x40>
  801818:	89 d0                	mov    %edx,%eax
  80181a:	83 ec 0c             	sub    $0xc,%esp
  80181d:	50                   	push   %eax
  80181e:	e8 e2 fb ff ff       	call   801405 <malloc>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801829:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80182d:	75 07                	jne    801836 <sget+0x5c>
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
  801834:	eb 27                	jmp    80185d <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	ff 75 e8             	pushl  -0x18(%ebp)
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	ff 75 08             	pushl  0x8(%ebp)
  801842:	e8 09 03 00 00       	call   801b50 <sys_getSharedObject>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80184d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801851:	75 07                	jne    80185a <sget+0x80>
  801853:	b8 00 00 00 00       	mov    $0x0,%eax
  801858:	eb 03                	jmp    80185d <sget+0x83>
	return ptr;
  80185a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801865:	8b 55 08             	mov    0x8(%ebp),%edx
  801868:	a1 20 50 80 00       	mov    0x805020,%eax
  80186d:	8b 40 78             	mov    0x78(%eax),%eax
  801870:	29 c2                	sub    %eax,%edx
  801872:	89 d0                	mov    %edx,%eax
  801874:	2d 00 10 00 00       	sub    $0x1000,%eax
  801879:	c1 e8 0c             	shr    $0xc,%eax
  80187c:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801883:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801886:	83 ec 08             	sub    $0x8,%esp
  801889:	ff 75 08             	pushl  0x8(%ebp)
  80188c:	ff 75 f4             	pushl  -0xc(%ebp)
  80188f:	e8 db 02 00 00       	call   801b6f <sys_freeSharedObject>
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80189a:	90                   	nop
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018a3:	83 ec 04             	sub    $0x4,%esp
  8018a6:	68 60 44 80 00       	push   $0x804460
  8018ab:	68 dd 00 00 00       	push   $0xdd
  8018b0:	68 42 44 80 00       	push   $0x804442
  8018b5:	e8 de ea ff ff       	call   800398 <_panic>

008018ba <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	68 86 44 80 00       	push   $0x804486
  8018c8:	68 e9 00 00 00       	push   $0xe9
  8018cd:	68 42 44 80 00       	push   $0x804442
  8018d2:	e8 c1 ea ff ff       	call   800398 <_panic>

008018d7 <shrink>:

}
void shrink(uint32 newSize)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	68 86 44 80 00       	push   $0x804486
  8018e5:	68 ee 00 00 00       	push   $0xee
  8018ea:	68 42 44 80 00       	push   $0x804442
  8018ef:	e8 a4 ea ff ff       	call   800398 <_panic>

008018f4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	68 86 44 80 00       	push   $0x804486
  801902:	68 f3 00 00 00       	push   $0xf3
  801907:	68 42 44 80 00       	push   $0x804442
  80190c:	e8 87 ea ff ff       	call   800398 <_panic>

00801911 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	57                   	push   %edi
  801915:	56                   	push   %esi
  801916:	53                   	push   %ebx
  801917:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801920:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801923:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801926:	8b 7d 18             	mov    0x18(%ebp),%edi
  801929:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80192c:	cd 30                	int    $0x30
  80192e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801931:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	5b                   	pop    %ebx
  801938:	5e                   	pop    %esi
  801939:	5f                   	pop    %edi
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	8b 45 10             	mov    0x10(%ebp),%eax
  801945:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801948:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	52                   	push   %edx
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	50                   	push   %eax
  801958:	6a 00                	push   $0x0
  80195a:	e8 b2 ff ff ff       	call   801911 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	90                   	nop
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_cgetc>:

int
sys_cgetc(void)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 02                	push   $0x2
  801974:	e8 98 ff ff ff       	call   801911 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 03                	push   $0x3
  80198d:	e8 7f ff ff ff       	call   801911 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	90                   	nop
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 04                	push   $0x4
  8019a7:	e8 65 ff ff ff       	call   801911 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	90                   	nop
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	52                   	push   %edx
  8019c2:	50                   	push   %eax
  8019c3:	6a 08                	push   $0x8
  8019c5:	e8 47 ff ff ff       	call   801911 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	56                   	push   %esi
  8019d3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019d4:	8b 75 18             	mov    0x18(%ebp),%esi
  8019d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	56                   	push   %esi
  8019e4:	53                   	push   %ebx
  8019e5:	51                   	push   %ecx
  8019e6:	52                   	push   %edx
  8019e7:	50                   	push   %eax
  8019e8:	6a 09                	push   $0x9
  8019ea:	e8 22 ff ff ff       	call   801911 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f5:	5b                   	pop    %ebx
  8019f6:	5e                   	pop    %esi
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    

008019f9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	52                   	push   %edx
  801a09:	50                   	push   %eax
  801a0a:	6a 0a                	push   $0xa
  801a0c:	e8 00 ff ff ff       	call   801911 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	ff 75 08             	pushl  0x8(%ebp)
  801a25:	6a 0b                	push   $0xb
  801a27:	e8 e5 fe ff ff       	call   801911 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 0c                	push   $0xc
  801a40:	e8 cc fe ff ff       	call   801911 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 0d                	push   $0xd
  801a59:	e8 b3 fe ff ff       	call   801911 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 0e                	push   $0xe
  801a72:	e8 9a fe ff ff       	call   801911 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 0f                	push   $0xf
  801a8b:	e8 81 fe ff ff       	call   801911 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	ff 75 08             	pushl  0x8(%ebp)
  801aa3:	6a 10                	push   $0x10
  801aa5:	e8 67 fe ff ff       	call   801911 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 11                	push   $0x11
  801abe:	e8 4e fe ff ff       	call   801911 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	90                   	nop
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 04             	sub    $0x4,%esp
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ad5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	50                   	push   %eax
  801ae2:	6a 01                	push   $0x1
  801ae4:	e8 28 fe ff ff       	call   801911 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	90                   	nop
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 14                	push   $0x14
  801afe:	e8 0e fe ff ff       	call   801911 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	90                   	nop
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 04             	sub    $0x4,%esp
  801b0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b12:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b15:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b18:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	51                   	push   %ecx
  801b22:	52                   	push   %edx
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	50                   	push   %eax
  801b27:	6a 15                	push   $0x15
  801b29:	e8 e3 fd ff ff       	call   801911 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	52                   	push   %edx
  801b43:	50                   	push   %eax
  801b44:	6a 16                	push   $0x16
  801b46:	e8 c6 fd ff ff       	call   801911 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	51                   	push   %ecx
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 17                	push   $0x17
  801b65:	e8 a7 fd ff ff       	call   801911 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	52                   	push   %edx
  801b7f:	50                   	push   %eax
  801b80:	6a 18                	push   $0x18
  801b82:	e8 8a fd ff ff       	call   801911 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	ff 75 14             	pushl  0x14(%ebp)
  801b97:	ff 75 10             	pushl  0x10(%ebp)
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	50                   	push   %eax
  801b9e:	6a 19                	push   $0x19
  801ba0:	e8 6c fd ff ff       	call   801911 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_run_env>:

void sys_run_env(int32 envId)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	50                   	push   %eax
  801bb9:	6a 1a                	push   $0x1a
  801bbb:	e8 51 fd ff ff       	call   801911 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	90                   	nop
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	50                   	push   %eax
  801bd5:	6a 1b                	push   $0x1b
  801bd7:	e8 35 fd ff ff       	call   801911 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 05                	push   $0x5
  801bf0:	e8 1c fd ff ff       	call   801911 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 06                	push   $0x6
  801c09:	e8 03 fd ff ff       	call   801911 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 07                	push   $0x7
  801c22:	e8 ea fc ff ff       	call   801911 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_exit_env>:


void sys_exit_env(void)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 1c                	push   $0x1c
  801c3b:	e8 d1 fc ff ff       	call   801911 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c4c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c4f:	8d 50 04             	lea    0x4(%eax),%edx
  801c52:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	52                   	push   %edx
  801c5c:	50                   	push   %eax
  801c5d:	6a 1d                	push   $0x1d
  801c5f:	e8 ad fc ff ff       	call   801911 <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
	return result;
  801c67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c70:	89 01                	mov    %eax,(%ecx)
  801c72:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	c9                   	leave  
  801c79:	c2 04 00             	ret    $0x4

00801c7c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	ff 75 10             	pushl  0x10(%ebp)
  801c86:	ff 75 0c             	pushl  0xc(%ebp)
  801c89:	ff 75 08             	pushl  0x8(%ebp)
  801c8c:	6a 13                	push   $0x13
  801c8e:	e8 7e fc ff ff       	call   801911 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return ;
  801c96:	90                   	nop
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 1e                	push   $0x1e
  801ca8:	e8 64 fc ff ff       	call   801911 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 04             	sub    $0x4,%esp
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cbe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	50                   	push   %eax
  801ccb:	6a 1f                	push   $0x1f
  801ccd:	e8 3f fc ff ff       	call   801911 <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd5:	90                   	nop
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <rsttst>:
void rsttst()
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 21                	push   $0x21
  801ce7:	e8 25 fc ff ff       	call   801911 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
	return ;
  801cef:	90                   	nop
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 04             	sub    $0x4,%esp
  801cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  801cfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cfe:	8b 55 18             	mov    0x18(%ebp),%edx
  801d01:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d05:	52                   	push   %edx
  801d06:	50                   	push   %eax
  801d07:	ff 75 10             	pushl  0x10(%ebp)
  801d0a:	ff 75 0c             	pushl  0xc(%ebp)
  801d0d:	ff 75 08             	pushl  0x8(%ebp)
  801d10:	6a 20                	push   $0x20
  801d12:	e8 fa fb ff ff       	call   801911 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1a:	90                   	nop
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <chktst>:
void chktst(uint32 n)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	ff 75 08             	pushl  0x8(%ebp)
  801d2b:	6a 22                	push   $0x22
  801d2d:	e8 df fb ff ff       	call   801911 <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
	return ;
  801d35:	90                   	nop
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <inctst>:

void inctst()
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 23                	push   $0x23
  801d47:	e8 c5 fb ff ff       	call   801911 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4f:	90                   	nop
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <gettst>:
uint32 gettst()
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 24                	push   $0x24
  801d61:	e8 ab fb ff ff       	call   801911 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 25                	push   $0x25
  801d7d:	e8 8f fb ff ff       	call   801911 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
  801d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d88:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d8c:	75 07                	jne    801d95 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d93:	eb 05                	jmp    801d9a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 25                	push   $0x25
  801dae:	e8 5e fb ff ff       	call   801911 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
  801db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801db9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dbd:	75 07                	jne    801dc6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc4:	eb 05                	jmp    801dcb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 25                	push   $0x25
  801ddf:	e8 2d fb ff ff       	call   801911 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
  801de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dea:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dee:	75 07                	jne    801df7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df0:	b8 01 00 00 00       	mov    $0x1,%eax
  801df5:	eb 05                	jmp    801dfc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 25                	push   $0x25
  801e10:	e8 fc fa ff ff       	call   801911 <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
  801e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e1b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e1f:	75 07                	jne    801e28 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e21:	b8 01 00 00 00       	mov    $0x1,%eax
  801e26:	eb 05                	jmp    801e2d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	ff 75 08             	pushl  0x8(%ebp)
  801e3d:	6a 26                	push   $0x26
  801e3f:	e8 cd fa ff ff       	call   801911 <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
	return ;
  801e47:	90                   	nop
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	6a 00                	push   $0x0
  801e5c:	53                   	push   %ebx
  801e5d:	51                   	push   %ecx
  801e5e:	52                   	push   %edx
  801e5f:	50                   	push   %eax
  801e60:	6a 27                	push   $0x27
  801e62:	e8 aa fa ff ff       	call   801911 <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
}
  801e6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	52                   	push   %edx
  801e7f:	50                   	push   %eax
  801e80:	6a 28                	push   $0x28
  801e82:	e8 8a fa ff ff       	call   801911 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e8f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	6a 00                	push   $0x0
  801e9a:	51                   	push   %ecx
  801e9b:	ff 75 10             	pushl  0x10(%ebp)
  801e9e:	52                   	push   %edx
  801e9f:	50                   	push   %eax
  801ea0:	6a 29                	push   $0x29
  801ea2:	e8 6a fa ff ff       	call   801911 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	ff 75 10             	pushl  0x10(%ebp)
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	ff 75 08             	pushl  0x8(%ebp)
  801ebc:	6a 12                	push   $0x12
  801ebe:	e8 4e fa ff ff       	call   801911 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec6:	90                   	nop
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	52                   	push   %edx
  801ed9:	50                   	push   %eax
  801eda:	6a 2a                	push   $0x2a
  801edc:	e8 30 fa ff ff       	call   801911 <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
	return;
  801ee4:	90                   	nop
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	50                   	push   %eax
  801ef6:	6a 2b                	push   $0x2b
  801ef8:	e8 14 fa ff ff       	call   801911 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	ff 75 0c             	pushl  0xc(%ebp)
  801f0e:	ff 75 08             	pushl  0x8(%ebp)
  801f11:	6a 2c                	push   $0x2c
  801f13:	e8 f9 f9 ff ff       	call   801911 <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
	return;
  801f1b:	90                   	nop
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	ff 75 0c             	pushl  0xc(%ebp)
  801f2a:	ff 75 08             	pushl  0x8(%ebp)
  801f2d:	6a 2d                	push   $0x2d
  801f2f:	e8 dd f9 ff ff       	call   801911 <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
	return;
  801f37:	90                   	nop
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	83 e8 04             	sub    $0x4,%eax
  801f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4c:	8b 00                	mov    (%eax),%eax
  801f4e:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	83 e8 04             	sub    $0x4,%eax
  801f5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f65:	8b 00                	mov    (%eax),%eax
  801f67:	83 e0 01             	and    $0x1,%eax
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	0f 94 c0             	sete   %al
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f81:	83 f8 02             	cmp    $0x2,%eax
  801f84:	74 2b                	je     801fb1 <alloc_block+0x40>
  801f86:	83 f8 02             	cmp    $0x2,%eax
  801f89:	7f 07                	jg     801f92 <alloc_block+0x21>
  801f8b:	83 f8 01             	cmp    $0x1,%eax
  801f8e:	74 0e                	je     801f9e <alloc_block+0x2d>
  801f90:	eb 58                	jmp    801fea <alloc_block+0x79>
  801f92:	83 f8 03             	cmp    $0x3,%eax
  801f95:	74 2d                	je     801fc4 <alloc_block+0x53>
  801f97:	83 f8 04             	cmp    $0x4,%eax
  801f9a:	74 3b                	je     801fd7 <alloc_block+0x66>
  801f9c:	eb 4c                	jmp    801fea <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f9e:	83 ec 0c             	sub    $0xc,%esp
  801fa1:	ff 75 08             	pushl  0x8(%ebp)
  801fa4:	e8 11 03 00 00       	call   8022ba <alloc_block_FF>
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801faf:	eb 4a                	jmp    801ffb <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fb1:	83 ec 0c             	sub    $0xc,%esp
  801fb4:	ff 75 08             	pushl  0x8(%ebp)
  801fb7:	e8 fa 19 00 00       	call   8039b6 <alloc_block_NF>
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fc2:	eb 37                	jmp    801ffb <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	ff 75 08             	pushl  0x8(%ebp)
  801fca:	e8 a7 07 00 00       	call   802776 <alloc_block_BF>
  801fcf:	83 c4 10             	add    $0x10,%esp
  801fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd5:	eb 24                	jmp    801ffb <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fd7:	83 ec 0c             	sub    $0xc,%esp
  801fda:	ff 75 08             	pushl  0x8(%ebp)
  801fdd:	e8 b7 19 00 00       	call   803999 <alloc_block_WF>
  801fe2:	83 c4 10             	add    $0x10,%esp
  801fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe8:	eb 11                	jmp    801ffb <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fea:	83 ec 0c             	sub    $0xc,%esp
  801fed:	68 98 44 80 00       	push   $0x804498
  801ff2:	e8 5e e6 ff ff       	call   800655 <cprintf>
  801ff7:	83 c4 10             	add    $0x10,%esp
		break;
  801ffa:	90                   	nop
	}
	return va;
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	53                   	push   %ebx
  802004:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	68 b8 44 80 00       	push   $0x8044b8
  80200f:	e8 41 e6 ff ff       	call   800655 <cprintf>
  802014:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	68 e3 44 80 00       	push   $0x8044e3
  80201f:	e8 31 e6 ff ff       	call   800655 <cprintf>
  802024:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202d:	eb 37                	jmp    802066 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	ff 75 f4             	pushl  -0xc(%ebp)
  802035:	e8 19 ff ff ff       	call   801f53 <is_free_block>
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	0f be d8             	movsbl %al,%ebx
  802040:	83 ec 0c             	sub    $0xc,%esp
  802043:	ff 75 f4             	pushl  -0xc(%ebp)
  802046:	e8 ef fe ff ff       	call   801f3a <get_block_size>
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	83 ec 04             	sub    $0x4,%esp
  802051:	53                   	push   %ebx
  802052:	50                   	push   %eax
  802053:	68 fb 44 80 00       	push   $0x8044fb
  802058:	e8 f8 e5 ff ff       	call   800655 <cprintf>
  80205d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802060:	8b 45 10             	mov    0x10(%ebp),%eax
  802063:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802066:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206a:	74 07                	je     802073 <print_blocks_list+0x73>
  80206c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206f:	8b 00                	mov    (%eax),%eax
  802071:	eb 05                	jmp    802078 <print_blocks_list+0x78>
  802073:	b8 00 00 00 00       	mov    $0x0,%eax
  802078:	89 45 10             	mov    %eax,0x10(%ebp)
  80207b:	8b 45 10             	mov    0x10(%ebp),%eax
  80207e:	85 c0                	test   %eax,%eax
  802080:	75 ad                	jne    80202f <print_blocks_list+0x2f>
  802082:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802086:	75 a7                	jne    80202f <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	68 b8 44 80 00       	push   $0x8044b8
  802090:	e8 c0 e5 ff ff       	call   800655 <cprintf>
  802095:	83 c4 10             	add    $0x10,%esp

}
  802098:	90                   	nop
  802099:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a7:	83 e0 01             	and    $0x1,%eax
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	74 03                	je     8020b1 <initialize_dynamic_allocator+0x13>
  8020ae:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020b5:	0f 84 c7 01 00 00    	je     802282 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020bb:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020c2:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cb:	01 d0                	add    %edx,%eax
  8020cd:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020d2:	0f 87 ad 01 00 00    	ja     802285 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	0f 89 a5 01 00 00    	jns    802288 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e9:	01 d0                	add    %edx,%eax
  8020eb:	83 e8 04             	sub    $0x4,%eax
  8020ee:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020fa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802102:	e9 87 00 00 00       	jmp    80218e <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210b:	75 14                	jne    802121 <initialize_dynamic_allocator+0x83>
  80210d:	83 ec 04             	sub    $0x4,%esp
  802110:	68 13 45 80 00       	push   $0x804513
  802115:	6a 79                	push   $0x79
  802117:	68 31 45 80 00       	push   $0x804531
  80211c:	e8 77 e2 ff ff       	call   800398 <_panic>
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	8b 00                	mov    (%eax),%eax
  802126:	85 c0                	test   %eax,%eax
  802128:	74 10                	je     80213a <initialize_dynamic_allocator+0x9c>
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	8b 00                	mov    (%eax),%eax
  80212f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802132:	8b 52 04             	mov    0x4(%edx),%edx
  802135:	89 50 04             	mov    %edx,0x4(%eax)
  802138:	eb 0b                	jmp    802145 <initialize_dynamic_allocator+0xa7>
  80213a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213d:	8b 40 04             	mov    0x4(%eax),%eax
  802140:	a3 30 50 80 00       	mov    %eax,0x805030
  802145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802148:	8b 40 04             	mov    0x4(%eax),%eax
  80214b:	85 c0                	test   %eax,%eax
  80214d:	74 0f                	je     80215e <initialize_dynamic_allocator+0xc0>
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	8b 40 04             	mov    0x4(%eax),%eax
  802155:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802158:	8b 12                	mov    (%edx),%edx
  80215a:	89 10                	mov    %edx,(%eax)
  80215c:	eb 0a                	jmp    802168 <initialize_dynamic_allocator+0xca>
  80215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802161:	8b 00                	mov    (%eax),%eax
  802163:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80217b:	a1 38 50 80 00       	mov    0x805038,%eax
  802180:	48                   	dec    %eax
  802181:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802186:	a1 34 50 80 00       	mov    0x805034,%eax
  80218b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802192:	74 07                	je     80219b <initialize_dynamic_allocator+0xfd>
  802194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802197:	8b 00                	mov    (%eax),%eax
  802199:	eb 05                	jmp    8021a0 <initialize_dynamic_allocator+0x102>
  80219b:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a0:	a3 34 50 80 00       	mov    %eax,0x805034
  8021a5:	a1 34 50 80 00       	mov    0x805034,%eax
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	0f 85 55 ff ff ff    	jne    802107 <initialize_dynamic_allocator+0x69>
  8021b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b6:	0f 85 4b ff ff ff    	jne    802107 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021cb:	a1 44 50 80 00       	mov    0x805044,%eax
  8021d0:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021d5:	a1 40 50 80 00       	mov    0x805040,%eax
  8021da:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	83 c0 08             	add    $0x8,%eax
  8021e6:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	83 c0 04             	add    $0x4,%eax
  8021ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f2:	83 ea 08             	sub    $0x8,%edx
  8021f5:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	01 d0                	add    %edx,%eax
  8021ff:	83 e8 08             	sub    $0x8,%eax
  802202:	8b 55 0c             	mov    0xc(%ebp),%edx
  802205:	83 ea 08             	sub    $0x8,%edx
  802208:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80220a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802213:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802216:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80221d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802221:	75 17                	jne    80223a <initialize_dynamic_allocator+0x19c>
  802223:	83 ec 04             	sub    $0x4,%esp
  802226:	68 4c 45 80 00       	push   $0x80454c
  80222b:	68 90 00 00 00       	push   $0x90
  802230:	68 31 45 80 00       	push   $0x804531
  802235:	e8 5e e1 ff ff       	call   800398 <_panic>
  80223a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802240:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802243:	89 10                	mov    %edx,(%eax)
  802245:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	74 0d                	je     80225b <initialize_dynamic_allocator+0x1bd>
  80224e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802253:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802256:	89 50 04             	mov    %edx,0x4(%eax)
  802259:	eb 08                	jmp    802263 <initialize_dynamic_allocator+0x1c5>
  80225b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225e:	a3 30 50 80 00       	mov    %eax,0x805030
  802263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802266:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80226b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802275:	a1 38 50 80 00       	mov    0x805038,%eax
  80227a:	40                   	inc    %eax
  80227b:	a3 38 50 80 00       	mov    %eax,0x805038
  802280:	eb 07                	jmp    802289 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802282:	90                   	nop
  802283:	eb 04                	jmp    802289 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802285:	90                   	nop
  802286:	eb 01                	jmp    802289 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802288:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80228e:	8b 45 10             	mov    0x10(%ebp),%eax
  802291:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	8d 50 fc             	lea    -0x4(%eax),%edx
  80229a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229d:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	83 e8 04             	sub    $0x4,%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	83 e0 fe             	and    $0xfffffffe,%eax
  8022aa:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	01 c2                	add    %eax,%edx
  8022b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b5:	89 02                	mov    %eax,(%edx)
}
  8022b7:	90                   	nop
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    

008022ba <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	83 e0 01             	and    $0x1,%eax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	74 03                	je     8022cd <alloc_block_FF+0x13>
  8022ca:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022cd:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022d1:	77 07                	ja     8022da <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022d3:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022da:	a1 24 50 80 00       	mov    0x805024,%eax
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	75 73                	jne    802356 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	83 c0 10             	add    $0x10,%eax
  8022e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022ec:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f9:	01 d0                	add    %edx,%eax
  8022fb:	48                   	dec    %eax
  8022fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802302:	ba 00 00 00 00       	mov    $0x0,%edx
  802307:	f7 75 ec             	divl   -0x14(%ebp)
  80230a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80230d:	29 d0                	sub    %edx,%eax
  80230f:	c1 e8 0c             	shr    $0xc,%eax
  802312:	83 ec 0c             	sub    $0xc,%esp
  802315:	50                   	push   %eax
  802316:	e8 d4 f0 ff ff       	call   8013ef <sbrk>
  80231b:	83 c4 10             	add    $0x10,%esp
  80231e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802321:	83 ec 0c             	sub    $0xc,%esp
  802324:	6a 00                	push   $0x0
  802326:	e8 c4 f0 ff ff       	call   8013ef <sbrk>
  80232b:	83 c4 10             	add    $0x10,%esp
  80232e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802331:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802334:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802337:	83 ec 08             	sub    $0x8,%esp
  80233a:	50                   	push   %eax
  80233b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80233e:	e8 5b fd ff ff       	call   80209e <initialize_dynamic_allocator>
  802343:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802346:	83 ec 0c             	sub    $0xc,%esp
  802349:	68 6f 45 80 00       	push   $0x80456f
  80234e:	e8 02 e3 ff ff       	call   800655 <cprintf>
  802353:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802356:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80235a:	75 0a                	jne    802366 <alloc_block_FF+0xac>
	        return NULL;
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
  802361:	e9 0e 04 00 00       	jmp    802774 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802366:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80236d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802372:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802375:	e9 f3 02 00 00       	jmp    80266d <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802380:	83 ec 0c             	sub    $0xc,%esp
  802383:	ff 75 bc             	pushl  -0x44(%ebp)
  802386:	e8 af fb ff ff       	call   801f3a <get_block_size>
  80238b:	83 c4 10             	add    $0x10,%esp
  80238e:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	83 c0 08             	add    $0x8,%eax
  802397:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80239a:	0f 87 c5 02 00 00    	ja     802665 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	83 c0 18             	add    $0x18,%eax
  8023a6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023a9:	0f 87 19 02 00 00    	ja     8025c8 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023b2:	2b 45 08             	sub    0x8(%ebp),%eax
  8023b5:	83 e8 08             	sub    $0x8,%eax
  8023b8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	8d 50 08             	lea    0x8(%eax),%edx
  8023c1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023c4:	01 d0                	add    %edx,%eax
  8023c6:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	83 c0 08             	add    $0x8,%eax
  8023cf:	83 ec 04             	sub    $0x4,%esp
  8023d2:	6a 01                	push   $0x1
  8023d4:	50                   	push   %eax
  8023d5:	ff 75 bc             	pushl  -0x44(%ebp)
  8023d8:	e8 ae fe ff ff       	call   80228b <set_block_data>
  8023dd:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 40 04             	mov    0x4(%eax),%eax
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	75 68                	jne    802452 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023ea:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023ee:	75 17                	jne    802407 <alloc_block_FF+0x14d>
  8023f0:	83 ec 04             	sub    $0x4,%esp
  8023f3:	68 4c 45 80 00       	push   $0x80454c
  8023f8:	68 d7 00 00 00       	push   $0xd7
  8023fd:	68 31 45 80 00       	push   $0x804531
  802402:	e8 91 df ff ff       	call   800398 <_panic>
  802407:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80240d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802410:	89 10                	mov    %edx,(%eax)
  802412:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802415:	8b 00                	mov    (%eax),%eax
  802417:	85 c0                	test   %eax,%eax
  802419:	74 0d                	je     802428 <alloc_block_FF+0x16e>
  80241b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802420:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802423:	89 50 04             	mov    %edx,0x4(%eax)
  802426:	eb 08                	jmp    802430 <alloc_block_FF+0x176>
  802428:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80242b:	a3 30 50 80 00       	mov    %eax,0x805030
  802430:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802433:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802438:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802442:	a1 38 50 80 00       	mov    0x805038,%eax
  802447:	40                   	inc    %eax
  802448:	a3 38 50 80 00       	mov    %eax,0x805038
  80244d:	e9 dc 00 00 00       	jmp    80252e <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	85 c0                	test   %eax,%eax
  802459:	75 65                	jne    8024c0 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80245b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80245f:	75 17                	jne    802478 <alloc_block_FF+0x1be>
  802461:	83 ec 04             	sub    $0x4,%esp
  802464:	68 80 45 80 00       	push   $0x804580
  802469:	68 db 00 00 00       	push   $0xdb
  80246e:	68 31 45 80 00       	push   $0x804531
  802473:	e8 20 df ff ff       	call   800398 <_panic>
  802478:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80247e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802481:	89 50 04             	mov    %edx,0x4(%eax)
  802484:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802487:	8b 40 04             	mov    0x4(%eax),%eax
  80248a:	85 c0                	test   %eax,%eax
  80248c:	74 0c                	je     80249a <alloc_block_FF+0x1e0>
  80248e:	a1 30 50 80 00       	mov    0x805030,%eax
  802493:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802496:	89 10                	mov    %edx,(%eax)
  802498:	eb 08                	jmp    8024a2 <alloc_block_FF+0x1e8>
  80249a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80249d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024a2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a5:	a3 30 50 80 00       	mov    %eax,0x805030
  8024aa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8024b8:	40                   	inc    %eax
  8024b9:	a3 38 50 80 00       	mov    %eax,0x805038
  8024be:	eb 6e                	jmp    80252e <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c4:	74 06                	je     8024cc <alloc_block_FF+0x212>
  8024c6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024ca:	75 17                	jne    8024e3 <alloc_block_FF+0x229>
  8024cc:	83 ec 04             	sub    $0x4,%esp
  8024cf:	68 a4 45 80 00       	push   $0x8045a4
  8024d4:	68 df 00 00 00       	push   $0xdf
  8024d9:	68 31 45 80 00       	push   $0x804531
  8024de:	e8 b5 de ff ff       	call   800398 <_panic>
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 10                	mov    (%eax),%edx
  8024e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024eb:	89 10                	mov    %edx,(%eax)
  8024ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	74 0b                	je     802501 <alloc_block_FF+0x247>
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	8b 00                	mov    (%eax),%eax
  8024fb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024fe:	89 50 04             	mov    %edx,0x4(%eax)
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802507:	89 10                	mov    %edx,(%eax)
  802509:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250f:	89 50 04             	mov    %edx,0x4(%eax)
  802512:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	85 c0                	test   %eax,%eax
  802519:	75 08                	jne    802523 <alloc_block_FF+0x269>
  80251b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251e:	a3 30 50 80 00       	mov    %eax,0x805030
  802523:	a1 38 50 80 00       	mov    0x805038,%eax
  802528:	40                   	inc    %eax
  802529:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80252e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802532:	75 17                	jne    80254b <alloc_block_FF+0x291>
  802534:	83 ec 04             	sub    $0x4,%esp
  802537:	68 13 45 80 00       	push   $0x804513
  80253c:	68 e1 00 00 00       	push   $0xe1
  802541:	68 31 45 80 00       	push   $0x804531
  802546:	e8 4d de ff ff       	call   800398 <_panic>
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	85 c0                	test   %eax,%eax
  802552:	74 10                	je     802564 <alloc_block_FF+0x2aa>
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255c:	8b 52 04             	mov    0x4(%edx),%edx
  80255f:	89 50 04             	mov    %edx,0x4(%eax)
  802562:	eb 0b                	jmp    80256f <alloc_block_FF+0x2b5>
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 40 04             	mov    0x4(%eax),%eax
  80256a:	a3 30 50 80 00       	mov    %eax,0x805030
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 40 04             	mov    0x4(%eax),%eax
  802575:	85 c0                	test   %eax,%eax
  802577:	74 0f                	je     802588 <alloc_block_FF+0x2ce>
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 40 04             	mov    0x4(%eax),%eax
  80257f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802582:	8b 12                	mov    (%edx),%edx
  802584:	89 10                	mov    %edx,(%eax)
  802586:	eb 0a                	jmp    802592 <alloc_block_FF+0x2d8>
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 00                	mov    (%eax),%eax
  80258d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8025aa:	48                   	dec    %eax
  8025ab:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025b0:	83 ec 04             	sub    $0x4,%esp
  8025b3:	6a 00                	push   $0x0
  8025b5:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025b8:	ff 75 b0             	pushl  -0x50(%ebp)
  8025bb:	e8 cb fc ff ff       	call   80228b <set_block_data>
  8025c0:	83 c4 10             	add    $0x10,%esp
  8025c3:	e9 95 00 00 00       	jmp    80265d <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025c8:	83 ec 04             	sub    $0x4,%esp
  8025cb:	6a 01                	push   $0x1
  8025cd:	ff 75 b8             	pushl  -0x48(%ebp)
  8025d0:	ff 75 bc             	pushl  -0x44(%ebp)
  8025d3:	e8 b3 fc ff ff       	call   80228b <set_block_data>
  8025d8:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025df:	75 17                	jne    8025f8 <alloc_block_FF+0x33e>
  8025e1:	83 ec 04             	sub    $0x4,%esp
  8025e4:	68 13 45 80 00       	push   $0x804513
  8025e9:	68 e8 00 00 00       	push   $0xe8
  8025ee:	68 31 45 80 00       	push   $0x804531
  8025f3:	e8 a0 dd ff ff       	call   800398 <_panic>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	74 10                	je     802611 <alloc_block_FF+0x357>
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802609:	8b 52 04             	mov    0x4(%edx),%edx
  80260c:	89 50 04             	mov    %edx,0x4(%eax)
  80260f:	eb 0b                	jmp    80261c <alloc_block_FF+0x362>
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 40 04             	mov    0x4(%eax),%eax
  802617:	a3 30 50 80 00       	mov    %eax,0x805030
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 40 04             	mov    0x4(%eax),%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	74 0f                	je     802635 <alloc_block_FF+0x37b>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 40 04             	mov    0x4(%eax),%eax
  80262c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262f:	8b 12                	mov    (%edx),%edx
  802631:	89 10                	mov    %edx,(%eax)
  802633:	eb 0a                	jmp    80263f <alloc_block_FF+0x385>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 00                	mov    (%eax),%eax
  80263a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802652:	a1 38 50 80 00       	mov    0x805038,%eax
  802657:	48                   	dec    %eax
  802658:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80265d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802660:	e9 0f 01 00 00       	jmp    802774 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802665:	a1 34 50 80 00       	mov    0x805034,%eax
  80266a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802671:	74 07                	je     80267a <alloc_block_FF+0x3c0>
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 00                	mov    (%eax),%eax
  802678:	eb 05                	jmp    80267f <alloc_block_FF+0x3c5>
  80267a:	b8 00 00 00 00       	mov    $0x0,%eax
  80267f:	a3 34 50 80 00       	mov    %eax,0x805034
  802684:	a1 34 50 80 00       	mov    0x805034,%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	0f 85 e9 fc ff ff    	jne    80237a <alloc_block_FF+0xc0>
  802691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802695:	0f 85 df fc ff ff    	jne    80237a <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	83 c0 08             	add    $0x8,%eax
  8026a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026a4:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026b1:	01 d0                	add    %edx,%eax
  8026b3:	48                   	dec    %eax
  8026b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8026bf:	f7 75 d8             	divl   -0x28(%ebp)
  8026c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026c5:	29 d0                	sub    %edx,%eax
  8026c7:	c1 e8 0c             	shr    $0xc,%eax
  8026ca:	83 ec 0c             	sub    $0xc,%esp
  8026cd:	50                   	push   %eax
  8026ce:	e8 1c ed ff ff       	call   8013ef <sbrk>
  8026d3:	83 c4 10             	add    $0x10,%esp
  8026d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026d9:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026dd:	75 0a                	jne    8026e9 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	e9 8b 00 00 00       	jmp    802774 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026e9:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026f6:	01 d0                	add    %edx,%eax
  8026f8:	48                   	dec    %eax
  8026f9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802704:	f7 75 cc             	divl   -0x34(%ebp)
  802707:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80270a:	29 d0                	sub    %edx,%eax
  80270c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80270f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802712:	01 d0                	add    %edx,%eax
  802714:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802719:	a1 40 50 80 00       	mov    0x805040,%eax
  80271e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802724:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80272b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80272e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802731:	01 d0                	add    %edx,%eax
  802733:	48                   	dec    %eax
  802734:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802737:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80273a:	ba 00 00 00 00       	mov    $0x0,%edx
  80273f:	f7 75 c4             	divl   -0x3c(%ebp)
  802742:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802745:	29 d0                	sub    %edx,%eax
  802747:	83 ec 04             	sub    $0x4,%esp
  80274a:	6a 01                	push   $0x1
  80274c:	50                   	push   %eax
  80274d:	ff 75 d0             	pushl  -0x30(%ebp)
  802750:	e8 36 fb ff ff       	call   80228b <set_block_data>
  802755:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802758:	83 ec 0c             	sub    $0xc,%esp
  80275b:	ff 75 d0             	pushl  -0x30(%ebp)
  80275e:	e8 1b 0a 00 00       	call   80317e <free_block>
  802763:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802766:	83 ec 0c             	sub    $0xc,%esp
  802769:	ff 75 08             	pushl  0x8(%ebp)
  80276c:	e8 49 fb ff ff       	call   8022ba <alloc_block_FF>
  802771:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802774:	c9                   	leave  
  802775:	c3                   	ret    

00802776 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
  802779:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	83 e0 01             	and    $0x1,%eax
  802782:	85 c0                	test   %eax,%eax
  802784:	74 03                	je     802789 <alloc_block_BF+0x13>
  802786:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802789:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80278d:	77 07                	ja     802796 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80278f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802796:	a1 24 50 80 00       	mov    0x805024,%eax
  80279b:	85 c0                	test   %eax,%eax
  80279d:	75 73                	jne    802812 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	83 c0 10             	add    $0x10,%eax
  8027a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027a8:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b5:	01 d0                	add    %edx,%eax
  8027b7:	48                   	dec    %eax
  8027b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027be:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c3:	f7 75 e0             	divl   -0x20(%ebp)
  8027c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027c9:	29 d0                	sub    %edx,%eax
  8027cb:	c1 e8 0c             	shr    $0xc,%eax
  8027ce:	83 ec 0c             	sub    $0xc,%esp
  8027d1:	50                   	push   %eax
  8027d2:	e8 18 ec ff ff       	call   8013ef <sbrk>
  8027d7:	83 c4 10             	add    $0x10,%esp
  8027da:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027dd:	83 ec 0c             	sub    $0xc,%esp
  8027e0:	6a 00                	push   $0x0
  8027e2:	e8 08 ec ff ff       	call   8013ef <sbrk>
  8027e7:	83 c4 10             	add    $0x10,%esp
  8027ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027f0:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027f3:	83 ec 08             	sub    $0x8,%esp
  8027f6:	50                   	push   %eax
  8027f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8027fa:	e8 9f f8 ff ff       	call   80209e <initialize_dynamic_allocator>
  8027ff:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802802:	83 ec 0c             	sub    $0xc,%esp
  802805:	68 6f 45 80 00       	push   $0x80456f
  80280a:	e8 46 de ff ff       	call   800655 <cprintf>
  80280f:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802812:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802819:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802820:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802827:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80282e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802833:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802836:	e9 1d 01 00 00       	jmp    802958 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802841:	83 ec 0c             	sub    $0xc,%esp
  802844:	ff 75 a8             	pushl  -0x58(%ebp)
  802847:	e8 ee f6 ff ff       	call   801f3a <get_block_size>
  80284c:	83 c4 10             	add    $0x10,%esp
  80284f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	83 c0 08             	add    $0x8,%eax
  802858:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80285b:	0f 87 ef 00 00 00    	ja     802950 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	83 c0 18             	add    $0x18,%eax
  802867:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80286a:	77 1d                	ja     802889 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80286c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802872:	0f 86 d8 00 00 00    	jbe    802950 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802878:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80287b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80287e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802881:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802884:	e9 c7 00 00 00       	jmp    802950 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	83 c0 08             	add    $0x8,%eax
  80288f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802892:	0f 85 9d 00 00 00    	jne    802935 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802898:	83 ec 04             	sub    $0x4,%esp
  80289b:	6a 01                	push   $0x1
  80289d:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028a0:	ff 75 a8             	pushl  -0x58(%ebp)
  8028a3:	e8 e3 f9 ff ff       	call   80228b <set_block_data>
  8028a8:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028af:	75 17                	jne    8028c8 <alloc_block_BF+0x152>
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	68 13 45 80 00       	push   $0x804513
  8028b9:	68 2c 01 00 00       	push   $0x12c
  8028be:	68 31 45 80 00       	push   $0x804531
  8028c3:	e8 d0 da ff ff       	call   800398 <_panic>
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 10                	je     8028e1 <alloc_block_BF+0x16b>
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d9:	8b 52 04             	mov    0x4(%edx),%edx
  8028dc:	89 50 04             	mov    %edx,0x4(%eax)
  8028df:	eb 0b                	jmp    8028ec <alloc_block_BF+0x176>
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 40 04             	mov    0x4(%eax),%eax
  8028e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 40 04             	mov    0x4(%eax),%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	74 0f                	je     802905 <alloc_block_BF+0x18f>
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 40 04             	mov    0x4(%eax),%eax
  8028fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ff:	8b 12                	mov    (%edx),%edx
  802901:	89 10                	mov    %edx,(%eax)
  802903:	eb 0a                	jmp    80290f <alloc_block_BF+0x199>
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802922:	a1 38 50 80 00       	mov    0x805038,%eax
  802927:	48                   	dec    %eax
  802928:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80292d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802930:	e9 24 04 00 00       	jmp    802d59 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802935:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802938:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80293b:	76 13                	jbe    802950 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80293d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802944:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802947:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80294a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80294d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802950:	a1 34 50 80 00       	mov    0x805034,%eax
  802955:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295c:	74 07                	je     802965 <alloc_block_BF+0x1ef>
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	eb 05                	jmp    80296a <alloc_block_BF+0x1f4>
  802965:	b8 00 00 00 00       	mov    $0x0,%eax
  80296a:	a3 34 50 80 00       	mov    %eax,0x805034
  80296f:	a1 34 50 80 00       	mov    0x805034,%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	0f 85 bf fe ff ff    	jne    80283b <alloc_block_BF+0xc5>
  80297c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802980:	0f 85 b5 fe ff ff    	jne    80283b <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802986:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80298a:	0f 84 26 02 00 00    	je     802bb6 <alloc_block_BF+0x440>
  802990:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802994:	0f 85 1c 02 00 00    	jne    802bb6 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80299a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299d:	2b 45 08             	sub    0x8(%ebp),%eax
  8029a0:	83 e8 08             	sub    $0x8,%eax
  8029a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	8d 50 08             	lea    0x8(%eax),%edx
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	01 d0                	add    %edx,%eax
  8029b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	83 c0 08             	add    $0x8,%eax
  8029ba:	83 ec 04             	sub    $0x4,%esp
  8029bd:	6a 01                	push   $0x1
  8029bf:	50                   	push   %eax
  8029c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8029c3:	e8 c3 f8 ff ff       	call   80228b <set_block_data>
  8029c8:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ce:	8b 40 04             	mov    0x4(%eax),%eax
  8029d1:	85 c0                	test   %eax,%eax
  8029d3:	75 68                	jne    802a3d <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029d5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029d9:	75 17                	jne    8029f2 <alloc_block_BF+0x27c>
  8029db:	83 ec 04             	sub    $0x4,%esp
  8029de:	68 4c 45 80 00       	push   $0x80454c
  8029e3:	68 45 01 00 00       	push   $0x145
  8029e8:	68 31 45 80 00       	push   $0x804531
  8029ed:	e8 a6 d9 ff ff       	call   800398 <_panic>
  8029f2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fb:	89 10                	mov    %edx,(%eax)
  8029fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	74 0d                	je     802a13 <alloc_block_BF+0x29d>
  802a06:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a0b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a0e:	89 50 04             	mov    %edx,0x4(%eax)
  802a11:	eb 08                	jmp    802a1b <alloc_block_BF+0x2a5>
  802a13:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a16:	a3 30 50 80 00       	mov    %eax,0x805030
  802a1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a1e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2d:	a1 38 50 80 00       	mov    0x805038,%eax
  802a32:	40                   	inc    %eax
  802a33:	a3 38 50 80 00       	mov    %eax,0x805038
  802a38:	e9 dc 00 00 00       	jmp    802b19 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	75 65                	jne    802aab <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a46:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a4a:	75 17                	jne    802a63 <alloc_block_BF+0x2ed>
  802a4c:	83 ec 04             	sub    $0x4,%esp
  802a4f:	68 80 45 80 00       	push   $0x804580
  802a54:	68 4a 01 00 00       	push   $0x14a
  802a59:	68 31 45 80 00       	push   $0x804531
  802a5e:	e8 35 d9 ff ff       	call   800398 <_panic>
  802a63:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a69:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6c:	89 50 04             	mov    %edx,0x4(%eax)
  802a6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a72:	8b 40 04             	mov    0x4(%eax),%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	74 0c                	je     802a85 <alloc_block_BF+0x30f>
  802a79:	a1 30 50 80 00       	mov    0x805030,%eax
  802a7e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a81:	89 10                	mov    %edx,(%eax)
  802a83:	eb 08                	jmp    802a8d <alloc_block_BF+0x317>
  802a85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a88:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a8d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a90:	a3 30 50 80 00       	mov    %eax,0x805030
  802a95:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9e:	a1 38 50 80 00       	mov    0x805038,%eax
  802aa3:	40                   	inc    %eax
  802aa4:	a3 38 50 80 00       	mov    %eax,0x805038
  802aa9:	eb 6e                	jmp    802b19 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802aab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aaf:	74 06                	je     802ab7 <alloc_block_BF+0x341>
  802ab1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ab5:	75 17                	jne    802ace <alloc_block_BF+0x358>
  802ab7:	83 ec 04             	sub    $0x4,%esp
  802aba:	68 a4 45 80 00       	push   $0x8045a4
  802abf:	68 4f 01 00 00       	push   $0x14f
  802ac4:	68 31 45 80 00       	push   $0x804531
  802ac9:	e8 ca d8 ff ff       	call   800398 <_panic>
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	8b 10                	mov    (%eax),%edx
  802ad3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad6:	89 10                	mov    %edx,(%eax)
  802ad8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	85 c0                	test   %eax,%eax
  802adf:	74 0b                	je     802aec <alloc_block_BF+0x376>
  802ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae4:	8b 00                	mov    (%eax),%eax
  802ae6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ae9:	89 50 04             	mov    %edx,0x4(%eax)
  802aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aef:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802af2:	89 10                	mov    %edx,(%eax)
  802af4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802afa:	89 50 04             	mov    %edx,0x4(%eax)
  802afd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	85 c0                	test   %eax,%eax
  802b04:	75 08                	jne    802b0e <alloc_block_BF+0x398>
  802b06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b09:	a3 30 50 80 00       	mov    %eax,0x805030
  802b0e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b13:	40                   	inc    %eax
  802b14:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b1d:	75 17                	jne    802b36 <alloc_block_BF+0x3c0>
  802b1f:	83 ec 04             	sub    $0x4,%esp
  802b22:	68 13 45 80 00       	push   $0x804513
  802b27:	68 51 01 00 00       	push   $0x151
  802b2c:	68 31 45 80 00       	push   $0x804531
  802b31:	e8 62 d8 ff ff       	call   800398 <_panic>
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	74 10                	je     802b4f <alloc_block_BF+0x3d9>
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b47:	8b 52 04             	mov    0x4(%edx),%edx
  802b4a:	89 50 04             	mov    %edx,0x4(%eax)
  802b4d:	eb 0b                	jmp    802b5a <alloc_block_BF+0x3e4>
  802b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b52:	8b 40 04             	mov    0x4(%eax),%eax
  802b55:	a3 30 50 80 00       	mov    %eax,0x805030
  802b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5d:	8b 40 04             	mov    0x4(%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	74 0f                	je     802b73 <alloc_block_BF+0x3fd>
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	8b 40 04             	mov    0x4(%eax),%eax
  802b6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6d:	8b 12                	mov    (%edx),%edx
  802b6f:	89 10                	mov    %edx,(%eax)
  802b71:	eb 0a                	jmp    802b7d <alloc_block_BF+0x407>
  802b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b76:	8b 00                	mov    (%eax),%eax
  802b78:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b90:	a1 38 50 80 00       	mov    0x805038,%eax
  802b95:	48                   	dec    %eax
  802b96:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b9b:	83 ec 04             	sub    $0x4,%esp
  802b9e:	6a 00                	push   $0x0
  802ba0:	ff 75 d0             	pushl  -0x30(%ebp)
  802ba3:	ff 75 cc             	pushl  -0x34(%ebp)
  802ba6:	e8 e0 f6 ff ff       	call   80228b <set_block_data>
  802bab:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	e9 a3 01 00 00       	jmp    802d59 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bb6:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bba:	0f 85 9d 00 00 00    	jne    802c5d <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bc0:	83 ec 04             	sub    $0x4,%esp
  802bc3:	6a 01                	push   $0x1
  802bc5:	ff 75 ec             	pushl  -0x14(%ebp)
  802bc8:	ff 75 f0             	pushl  -0x10(%ebp)
  802bcb:	e8 bb f6 ff ff       	call   80228b <set_block_data>
  802bd0:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bd7:	75 17                	jne    802bf0 <alloc_block_BF+0x47a>
  802bd9:	83 ec 04             	sub    $0x4,%esp
  802bdc:	68 13 45 80 00       	push   $0x804513
  802be1:	68 58 01 00 00       	push   $0x158
  802be6:	68 31 45 80 00       	push   $0x804531
  802beb:	e8 a8 d7 ff ff       	call   800398 <_panic>
  802bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf3:	8b 00                	mov    (%eax),%eax
  802bf5:	85 c0                	test   %eax,%eax
  802bf7:	74 10                	je     802c09 <alloc_block_BF+0x493>
  802bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c01:	8b 52 04             	mov    0x4(%edx),%edx
  802c04:	89 50 04             	mov    %edx,0x4(%eax)
  802c07:	eb 0b                	jmp    802c14 <alloc_block_BF+0x49e>
  802c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0c:	8b 40 04             	mov    0x4(%eax),%eax
  802c0f:	a3 30 50 80 00       	mov    %eax,0x805030
  802c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c17:	8b 40 04             	mov    0x4(%eax),%eax
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	74 0f                	je     802c2d <alloc_block_BF+0x4b7>
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	8b 40 04             	mov    0x4(%eax),%eax
  802c24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c27:	8b 12                	mov    (%edx),%edx
  802c29:	89 10                	mov    %edx,(%eax)
  802c2b:	eb 0a                	jmp    802c37 <alloc_block_BF+0x4c1>
  802c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4a:	a1 38 50 80 00       	mov    0x805038,%eax
  802c4f:	48                   	dec    %eax
  802c50:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c58:	e9 fc 00 00 00       	jmp    802d59 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	83 c0 08             	add    $0x8,%eax
  802c63:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c66:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c6d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c70:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c73:	01 d0                	add    %edx,%eax
  802c75:	48                   	dec    %eax
  802c76:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c79:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c7c:	ba 00 00 00 00       	mov    $0x0,%edx
  802c81:	f7 75 c4             	divl   -0x3c(%ebp)
  802c84:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c87:	29 d0                	sub    %edx,%eax
  802c89:	c1 e8 0c             	shr    $0xc,%eax
  802c8c:	83 ec 0c             	sub    $0xc,%esp
  802c8f:	50                   	push   %eax
  802c90:	e8 5a e7 ff ff       	call   8013ef <sbrk>
  802c95:	83 c4 10             	add    $0x10,%esp
  802c98:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c9b:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c9f:	75 0a                	jne    802cab <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca6:	e9 ae 00 00 00       	jmp    802d59 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cab:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cb2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cb5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cb8:	01 d0                	add    %edx,%eax
  802cba:	48                   	dec    %eax
  802cbb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cbe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc6:	f7 75 b8             	divl   -0x48(%ebp)
  802cc9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ccc:	29 d0                	sub    %edx,%eax
  802cce:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cd1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cd4:	01 d0                	add    %edx,%eax
  802cd6:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cdb:	a1 40 50 80 00       	mov    0x805040,%eax
  802ce0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ce6:	83 ec 0c             	sub    $0xc,%esp
  802ce9:	68 d8 45 80 00       	push   $0x8045d8
  802cee:	e8 62 d9 ff ff       	call   800655 <cprintf>
  802cf3:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802cf6:	83 ec 08             	sub    $0x8,%esp
  802cf9:	ff 75 bc             	pushl  -0x44(%ebp)
  802cfc:	68 dd 45 80 00       	push   $0x8045dd
  802d01:	e8 4f d9 ff ff       	call   800655 <cprintf>
  802d06:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d09:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d10:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d13:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d16:	01 d0                	add    %edx,%eax
  802d18:	48                   	dec    %eax
  802d19:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d1c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d24:	f7 75 b0             	divl   -0x50(%ebp)
  802d27:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d2a:	29 d0                	sub    %edx,%eax
  802d2c:	83 ec 04             	sub    $0x4,%esp
  802d2f:	6a 01                	push   $0x1
  802d31:	50                   	push   %eax
  802d32:	ff 75 bc             	pushl  -0x44(%ebp)
  802d35:	e8 51 f5 ff ff       	call   80228b <set_block_data>
  802d3a:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d3d:	83 ec 0c             	sub    $0xc,%esp
  802d40:	ff 75 bc             	pushl  -0x44(%ebp)
  802d43:	e8 36 04 00 00       	call   80317e <free_block>
  802d48:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d4b:	83 ec 0c             	sub    $0xc,%esp
  802d4e:	ff 75 08             	pushl  0x8(%ebp)
  802d51:	e8 20 fa ff ff       	call   802776 <alloc_block_BF>
  802d56:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d59:	c9                   	leave  
  802d5a:	c3                   	ret    

00802d5b <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d5b:	55                   	push   %ebp
  802d5c:	89 e5                	mov    %esp,%ebp
  802d5e:	53                   	push   %ebx
  802d5f:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d69:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d74:	74 1e                	je     802d94 <merging+0x39>
  802d76:	ff 75 08             	pushl  0x8(%ebp)
  802d79:	e8 bc f1 ff ff       	call   801f3a <get_block_size>
  802d7e:	83 c4 04             	add    $0x4,%esp
  802d81:	89 c2                	mov    %eax,%edx
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	01 d0                	add    %edx,%eax
  802d88:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d8b:	75 07                	jne    802d94 <merging+0x39>
		prev_is_free = 1;
  802d8d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d98:	74 1e                	je     802db8 <merging+0x5d>
  802d9a:	ff 75 10             	pushl  0x10(%ebp)
  802d9d:	e8 98 f1 ff ff       	call   801f3a <get_block_size>
  802da2:	83 c4 04             	add    $0x4,%esp
  802da5:	89 c2                	mov    %eax,%edx
  802da7:	8b 45 10             	mov    0x10(%ebp),%eax
  802daa:	01 d0                	add    %edx,%eax
  802dac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802daf:	75 07                	jne    802db8 <merging+0x5d>
		next_is_free = 1;
  802db1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802db8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbc:	0f 84 cc 00 00 00    	je     802e8e <merging+0x133>
  802dc2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc6:	0f 84 c2 00 00 00    	je     802e8e <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dcc:	ff 75 08             	pushl  0x8(%ebp)
  802dcf:	e8 66 f1 ff ff       	call   801f3a <get_block_size>
  802dd4:	83 c4 04             	add    $0x4,%esp
  802dd7:	89 c3                	mov    %eax,%ebx
  802dd9:	ff 75 10             	pushl  0x10(%ebp)
  802ddc:	e8 59 f1 ff ff       	call   801f3a <get_block_size>
  802de1:	83 c4 04             	add    $0x4,%esp
  802de4:	01 c3                	add    %eax,%ebx
  802de6:	ff 75 0c             	pushl  0xc(%ebp)
  802de9:	e8 4c f1 ff ff       	call   801f3a <get_block_size>
  802dee:	83 c4 04             	add    $0x4,%esp
  802df1:	01 d8                	add    %ebx,%eax
  802df3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802df6:	6a 00                	push   $0x0
  802df8:	ff 75 ec             	pushl  -0x14(%ebp)
  802dfb:	ff 75 08             	pushl  0x8(%ebp)
  802dfe:	e8 88 f4 ff ff       	call   80228b <set_block_data>
  802e03:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e0a:	75 17                	jne    802e23 <merging+0xc8>
  802e0c:	83 ec 04             	sub    $0x4,%esp
  802e0f:	68 13 45 80 00       	push   $0x804513
  802e14:	68 7d 01 00 00       	push   $0x17d
  802e19:	68 31 45 80 00       	push   $0x804531
  802e1e:	e8 75 d5 ff ff       	call   800398 <_panic>
  802e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	74 10                	je     802e3c <merging+0xe1>
  802e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e34:	8b 52 04             	mov    0x4(%edx),%edx
  802e37:	89 50 04             	mov    %edx,0x4(%eax)
  802e3a:	eb 0b                	jmp    802e47 <merging+0xec>
  802e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3f:	8b 40 04             	mov    0x4(%eax),%eax
  802e42:	a3 30 50 80 00       	mov    %eax,0x805030
  802e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4a:	8b 40 04             	mov    0x4(%eax),%eax
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	74 0f                	je     802e60 <merging+0x105>
  802e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e54:	8b 40 04             	mov    0x4(%eax),%eax
  802e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e5a:	8b 12                	mov    (%edx),%edx
  802e5c:	89 10                	mov    %edx,(%eax)
  802e5e:	eb 0a                	jmp    802e6a <merging+0x10f>
  802e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e63:	8b 00                	mov    (%eax),%eax
  802e65:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7d:	a1 38 50 80 00       	mov    0x805038,%eax
  802e82:	48                   	dec    %eax
  802e83:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e88:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e89:	e9 ea 02 00 00       	jmp    803178 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e92:	74 3b                	je     802ecf <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e94:	83 ec 0c             	sub    $0xc,%esp
  802e97:	ff 75 08             	pushl  0x8(%ebp)
  802e9a:	e8 9b f0 ff ff       	call   801f3a <get_block_size>
  802e9f:	83 c4 10             	add    $0x10,%esp
  802ea2:	89 c3                	mov    %eax,%ebx
  802ea4:	83 ec 0c             	sub    $0xc,%esp
  802ea7:	ff 75 10             	pushl  0x10(%ebp)
  802eaa:	e8 8b f0 ff ff       	call   801f3a <get_block_size>
  802eaf:	83 c4 10             	add    $0x10,%esp
  802eb2:	01 d8                	add    %ebx,%eax
  802eb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802eb7:	83 ec 04             	sub    $0x4,%esp
  802eba:	6a 00                	push   $0x0
  802ebc:	ff 75 e8             	pushl  -0x18(%ebp)
  802ebf:	ff 75 08             	pushl  0x8(%ebp)
  802ec2:	e8 c4 f3 ff ff       	call   80228b <set_block_data>
  802ec7:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eca:	e9 a9 02 00 00       	jmp    803178 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ecf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed3:	0f 84 2d 01 00 00    	je     803006 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ed9:	83 ec 0c             	sub    $0xc,%esp
  802edc:	ff 75 10             	pushl  0x10(%ebp)
  802edf:	e8 56 f0 ff ff       	call   801f3a <get_block_size>
  802ee4:	83 c4 10             	add    $0x10,%esp
  802ee7:	89 c3                	mov    %eax,%ebx
  802ee9:	83 ec 0c             	sub    $0xc,%esp
  802eec:	ff 75 0c             	pushl  0xc(%ebp)
  802eef:	e8 46 f0 ff ff       	call   801f3a <get_block_size>
  802ef4:	83 c4 10             	add    $0x10,%esp
  802ef7:	01 d8                	add    %ebx,%eax
  802ef9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802efc:	83 ec 04             	sub    $0x4,%esp
  802eff:	6a 00                	push   $0x0
  802f01:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f04:	ff 75 10             	pushl  0x10(%ebp)
  802f07:	e8 7f f3 ff ff       	call   80228b <set_block_data>
  802f0c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  802f12:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f19:	74 06                	je     802f21 <merging+0x1c6>
  802f1b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f1f:	75 17                	jne    802f38 <merging+0x1dd>
  802f21:	83 ec 04             	sub    $0x4,%esp
  802f24:	68 ec 45 80 00       	push   $0x8045ec
  802f29:	68 8d 01 00 00       	push   $0x18d
  802f2e:	68 31 45 80 00       	push   $0x804531
  802f33:	e8 60 d4 ff ff       	call   800398 <_panic>
  802f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3b:	8b 50 04             	mov    0x4(%eax),%edx
  802f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f41:	89 50 04             	mov    %edx,0x4(%eax)
  802f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f4a:	89 10                	mov    %edx,(%eax)
  802f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4f:	8b 40 04             	mov    0x4(%eax),%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	74 0d                	je     802f63 <merging+0x208>
  802f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f59:	8b 40 04             	mov    0x4(%eax),%eax
  802f5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f5f:	89 10                	mov    %edx,(%eax)
  802f61:	eb 08                	jmp    802f6b <merging+0x210>
  802f63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f66:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f71:	89 50 04             	mov    %edx,0x4(%eax)
  802f74:	a1 38 50 80 00       	mov    0x805038,%eax
  802f79:	40                   	inc    %eax
  802f7a:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f83:	75 17                	jne    802f9c <merging+0x241>
  802f85:	83 ec 04             	sub    $0x4,%esp
  802f88:	68 13 45 80 00       	push   $0x804513
  802f8d:	68 8e 01 00 00       	push   $0x18e
  802f92:	68 31 45 80 00       	push   $0x804531
  802f97:	e8 fc d3 ff ff       	call   800398 <_panic>
  802f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	74 10                	je     802fb5 <merging+0x25a>
  802fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fad:	8b 52 04             	mov    0x4(%edx),%edx
  802fb0:	89 50 04             	mov    %edx,0x4(%eax)
  802fb3:	eb 0b                	jmp    802fc0 <merging+0x265>
  802fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb8:	8b 40 04             	mov    0x4(%eax),%eax
  802fbb:	a3 30 50 80 00       	mov    %eax,0x805030
  802fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc3:	8b 40 04             	mov    0x4(%eax),%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	74 0f                	je     802fd9 <merging+0x27e>
  802fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcd:	8b 40 04             	mov    0x4(%eax),%eax
  802fd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd3:	8b 12                	mov    (%edx),%edx
  802fd5:	89 10                	mov    %edx,(%eax)
  802fd7:	eb 0a                	jmp    802fe3 <merging+0x288>
  802fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff6:	a1 38 50 80 00       	mov    0x805038,%eax
  802ffb:	48                   	dec    %eax
  802ffc:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803001:	e9 72 01 00 00       	jmp    803178 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803006:	8b 45 10             	mov    0x10(%ebp),%eax
  803009:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80300c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803010:	74 79                	je     80308b <merging+0x330>
  803012:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803016:	74 73                	je     80308b <merging+0x330>
  803018:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301c:	74 06                	je     803024 <merging+0x2c9>
  80301e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803022:	75 17                	jne    80303b <merging+0x2e0>
  803024:	83 ec 04             	sub    $0x4,%esp
  803027:	68 a4 45 80 00       	push   $0x8045a4
  80302c:	68 94 01 00 00       	push   $0x194
  803031:	68 31 45 80 00       	push   $0x804531
  803036:	e8 5d d3 ff ff       	call   800398 <_panic>
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	8b 10                	mov    (%eax),%edx
  803040:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803043:	89 10                	mov    %edx,(%eax)
  803045:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803048:	8b 00                	mov    (%eax),%eax
  80304a:	85 c0                	test   %eax,%eax
  80304c:	74 0b                	je     803059 <merging+0x2fe>
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803056:	89 50 04             	mov    %edx,0x4(%eax)
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80305f:	89 10                	mov    %edx,(%eax)
  803061:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803064:	8b 55 08             	mov    0x8(%ebp),%edx
  803067:	89 50 04             	mov    %edx,0x4(%eax)
  80306a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	75 08                	jne    80307b <merging+0x320>
  803073:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803076:	a3 30 50 80 00       	mov    %eax,0x805030
  80307b:	a1 38 50 80 00       	mov    0x805038,%eax
  803080:	40                   	inc    %eax
  803081:	a3 38 50 80 00       	mov    %eax,0x805038
  803086:	e9 ce 00 00 00       	jmp    803159 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80308b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80308f:	74 65                	je     8030f6 <merging+0x39b>
  803091:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803095:	75 17                	jne    8030ae <merging+0x353>
  803097:	83 ec 04             	sub    $0x4,%esp
  80309a:	68 80 45 80 00       	push   $0x804580
  80309f:	68 95 01 00 00       	push   $0x195
  8030a4:	68 31 45 80 00       	push   $0x804531
  8030a9:	e8 ea d2 ff ff       	call   800398 <_panic>
  8030ae:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bd:	8b 40 04             	mov    0x4(%eax),%eax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	74 0c                	je     8030d0 <merging+0x375>
  8030c4:	a1 30 50 80 00       	mov    0x805030,%eax
  8030c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030cc:	89 10                	mov    %edx,(%eax)
  8030ce:	eb 08                	jmp    8030d8 <merging+0x37d>
  8030d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030db:	a3 30 50 80 00       	mov    %eax,0x805030
  8030e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8030ee:	40                   	inc    %eax
  8030ef:	a3 38 50 80 00       	mov    %eax,0x805038
  8030f4:	eb 63                	jmp    803159 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030fa:	75 17                	jne    803113 <merging+0x3b8>
  8030fc:	83 ec 04             	sub    $0x4,%esp
  8030ff:	68 4c 45 80 00       	push   $0x80454c
  803104:	68 98 01 00 00       	push   $0x198
  803109:	68 31 45 80 00       	push   $0x804531
  80310e:	e8 85 d2 ff ff       	call   800398 <_panic>
  803113:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803119:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311c:	89 10                	mov    %edx,(%eax)
  80311e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	85 c0                	test   %eax,%eax
  803125:	74 0d                	je     803134 <merging+0x3d9>
  803127:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80312c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80312f:	89 50 04             	mov    %edx,0x4(%eax)
  803132:	eb 08                	jmp    80313c <merging+0x3e1>
  803134:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803137:	a3 30 50 80 00       	mov    %eax,0x805030
  80313c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803144:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803147:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314e:	a1 38 50 80 00       	mov    0x805038,%eax
  803153:	40                   	inc    %eax
  803154:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803159:	83 ec 0c             	sub    $0xc,%esp
  80315c:	ff 75 10             	pushl  0x10(%ebp)
  80315f:	e8 d6 ed ff ff       	call   801f3a <get_block_size>
  803164:	83 c4 10             	add    $0x10,%esp
  803167:	83 ec 04             	sub    $0x4,%esp
  80316a:	6a 00                	push   $0x0
  80316c:	50                   	push   %eax
  80316d:	ff 75 10             	pushl  0x10(%ebp)
  803170:	e8 16 f1 ff ff       	call   80228b <set_block_data>
  803175:	83 c4 10             	add    $0x10,%esp
	}
}
  803178:	90                   	nop
  803179:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80317c:	c9                   	leave  
  80317d:	c3                   	ret    

0080317e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80317e:	55                   	push   %ebp
  80317f:	89 e5                	mov    %esp,%ebp
  803181:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803184:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803189:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80318c:	a1 30 50 80 00       	mov    0x805030,%eax
  803191:	3b 45 08             	cmp    0x8(%ebp),%eax
  803194:	73 1b                	jae    8031b1 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803196:	a1 30 50 80 00       	mov    0x805030,%eax
  80319b:	83 ec 04             	sub    $0x4,%esp
  80319e:	ff 75 08             	pushl  0x8(%ebp)
  8031a1:	6a 00                	push   $0x0
  8031a3:	50                   	push   %eax
  8031a4:	e8 b2 fb ff ff       	call   802d5b <merging>
  8031a9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031ac:	e9 8b 00 00 00       	jmp    80323c <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031b9:	76 18                	jbe    8031d3 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c0:	83 ec 04             	sub    $0x4,%esp
  8031c3:	ff 75 08             	pushl  0x8(%ebp)
  8031c6:	50                   	push   %eax
  8031c7:	6a 00                	push   $0x0
  8031c9:	e8 8d fb ff ff       	call   802d5b <merging>
  8031ce:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031d1:	eb 69                	jmp    80323c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031db:	eb 39                	jmp    803216 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e3:	73 29                	jae    80320e <free_block+0x90>
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	8b 00                	mov    (%eax),%eax
  8031ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ed:	76 1f                	jbe    80320e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f2:	8b 00                	mov    (%eax),%eax
  8031f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031f7:	83 ec 04             	sub    $0x4,%esp
  8031fa:	ff 75 08             	pushl  0x8(%ebp)
  8031fd:	ff 75 f0             	pushl  -0x10(%ebp)
  803200:	ff 75 f4             	pushl  -0xc(%ebp)
  803203:	e8 53 fb ff ff       	call   802d5b <merging>
  803208:	83 c4 10             	add    $0x10,%esp
			break;
  80320b:	90                   	nop
		}
	}
}
  80320c:	eb 2e                	jmp    80323c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80320e:	a1 34 50 80 00       	mov    0x805034,%eax
  803213:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803216:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80321a:	74 07                	je     803223 <free_block+0xa5>
  80321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	eb 05                	jmp    803228 <free_block+0xaa>
  803223:	b8 00 00 00 00       	mov    $0x0,%eax
  803228:	a3 34 50 80 00       	mov    %eax,0x805034
  80322d:	a1 34 50 80 00       	mov    0x805034,%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	75 a7                	jne    8031dd <free_block+0x5f>
  803236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323a:	75 a1                	jne    8031dd <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80323c:	90                   	nop
  80323d:	c9                   	leave  
  80323e:	c3                   	ret    

0080323f <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80323f:	55                   	push   %ebp
  803240:	89 e5                	mov    %esp,%ebp
  803242:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803245:	ff 75 08             	pushl  0x8(%ebp)
  803248:	e8 ed ec ff ff       	call   801f3a <get_block_size>
  80324d:	83 c4 04             	add    $0x4,%esp
  803250:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803253:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80325a:	eb 17                	jmp    803273 <copy_data+0x34>
  80325c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80325f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803262:	01 c2                	add    %eax,%edx
  803264:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	01 c8                	add    %ecx,%eax
  80326c:	8a 00                	mov    (%eax),%al
  80326e:	88 02                	mov    %al,(%edx)
  803270:	ff 45 fc             	incl   -0x4(%ebp)
  803273:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803276:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803279:	72 e1                	jb     80325c <copy_data+0x1d>
}
  80327b:	90                   	nop
  80327c:	c9                   	leave  
  80327d:	c3                   	ret    

0080327e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80327e:	55                   	push   %ebp
  80327f:	89 e5                	mov    %esp,%ebp
  803281:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803284:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803288:	75 23                	jne    8032ad <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80328a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80328e:	74 13                	je     8032a3 <realloc_block_FF+0x25>
  803290:	83 ec 0c             	sub    $0xc,%esp
  803293:	ff 75 0c             	pushl  0xc(%ebp)
  803296:	e8 1f f0 ff ff       	call   8022ba <alloc_block_FF>
  80329b:	83 c4 10             	add    $0x10,%esp
  80329e:	e9 f4 06 00 00       	jmp    803997 <realloc_block_FF+0x719>
		return NULL;
  8032a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a8:	e9 ea 06 00 00       	jmp    803997 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032b1:	75 18                	jne    8032cb <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032b3:	83 ec 0c             	sub    $0xc,%esp
  8032b6:	ff 75 08             	pushl  0x8(%ebp)
  8032b9:	e8 c0 fe ff ff       	call   80317e <free_block>
  8032be:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c6:	e9 cc 06 00 00       	jmp    803997 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032cb:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032cf:	77 07                	ja     8032d8 <realloc_block_FF+0x5a>
  8032d1:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032db:	83 e0 01             	and    $0x1,%eax
  8032de:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e4:	83 c0 08             	add    $0x8,%eax
  8032e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032ea:	83 ec 0c             	sub    $0xc,%esp
  8032ed:	ff 75 08             	pushl  0x8(%ebp)
  8032f0:	e8 45 ec ff ff       	call   801f3a <get_block_size>
  8032f5:	83 c4 10             	add    $0x10,%esp
  8032f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fe:	83 e8 08             	sub    $0x8,%eax
  803301:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	83 e8 04             	sub    $0x4,%eax
  80330a:	8b 00                	mov    (%eax),%eax
  80330c:	83 e0 fe             	and    $0xfffffffe,%eax
  80330f:	89 c2                	mov    %eax,%edx
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	01 d0                	add    %edx,%eax
  803316:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803319:	83 ec 0c             	sub    $0xc,%esp
  80331c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80331f:	e8 16 ec ff ff       	call   801f3a <get_block_size>
  803324:	83 c4 10             	add    $0x10,%esp
  803327:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80332a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80332d:	83 e8 08             	sub    $0x8,%eax
  803330:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803333:	8b 45 0c             	mov    0xc(%ebp),%eax
  803336:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803339:	75 08                	jne    803343 <realloc_block_FF+0xc5>
	{
		 return va;
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	e9 54 06 00 00       	jmp    803997 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803343:	8b 45 0c             	mov    0xc(%ebp),%eax
  803346:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803349:	0f 83 e5 03 00 00    	jae    803734 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	2b 45 0c             	sub    0xc(%ebp),%eax
  803355:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803358:	83 ec 0c             	sub    $0xc,%esp
  80335b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80335e:	e8 f0 eb ff ff       	call   801f53 <is_free_block>
  803363:	83 c4 10             	add    $0x10,%esp
  803366:	84 c0                	test   %al,%al
  803368:	0f 84 3b 01 00 00    	je     8034a9 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80336e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803371:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803374:	01 d0                	add    %edx,%eax
  803376:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803379:	83 ec 04             	sub    $0x4,%esp
  80337c:	6a 01                	push   $0x1
  80337e:	ff 75 f0             	pushl  -0x10(%ebp)
  803381:	ff 75 08             	pushl  0x8(%ebp)
  803384:	e8 02 ef ff ff       	call   80228b <set_block_data>
  803389:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	83 e8 04             	sub    $0x4,%eax
  803392:	8b 00                	mov    (%eax),%eax
  803394:	83 e0 fe             	and    $0xfffffffe,%eax
  803397:	89 c2                	mov    %eax,%edx
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	01 d0                	add    %edx,%eax
  80339e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033a1:	83 ec 04             	sub    $0x4,%esp
  8033a4:	6a 00                	push   $0x0
  8033a6:	ff 75 cc             	pushl  -0x34(%ebp)
  8033a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8033ac:	e8 da ee ff ff       	call   80228b <set_block_data>
  8033b1:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033b8:	74 06                	je     8033c0 <realloc_block_FF+0x142>
  8033ba:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033be:	75 17                	jne    8033d7 <realloc_block_FF+0x159>
  8033c0:	83 ec 04             	sub    $0x4,%esp
  8033c3:	68 a4 45 80 00       	push   $0x8045a4
  8033c8:	68 f6 01 00 00       	push   $0x1f6
  8033cd:	68 31 45 80 00       	push   $0x804531
  8033d2:	e8 c1 cf ff ff       	call   800398 <_panic>
  8033d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033da:	8b 10                	mov    (%eax),%edx
  8033dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033df:	89 10                	mov    %edx,(%eax)
  8033e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e4:	8b 00                	mov    (%eax),%eax
  8033e6:	85 c0                	test   %eax,%eax
  8033e8:	74 0b                	je     8033f5 <realloc_block_FF+0x177>
  8033ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ed:	8b 00                	mov    (%eax),%eax
  8033ef:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033f2:	89 50 04             	mov    %edx,0x4(%eax)
  8033f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033fb:	89 10                	mov    %edx,(%eax)
  8033fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803400:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803403:	89 50 04             	mov    %edx,0x4(%eax)
  803406:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803409:	8b 00                	mov    (%eax),%eax
  80340b:	85 c0                	test   %eax,%eax
  80340d:	75 08                	jne    803417 <realloc_block_FF+0x199>
  80340f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803412:	a3 30 50 80 00       	mov    %eax,0x805030
  803417:	a1 38 50 80 00       	mov    0x805038,%eax
  80341c:	40                   	inc    %eax
  80341d:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803422:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803426:	75 17                	jne    80343f <realloc_block_FF+0x1c1>
  803428:	83 ec 04             	sub    $0x4,%esp
  80342b:	68 13 45 80 00       	push   $0x804513
  803430:	68 f7 01 00 00       	push   $0x1f7
  803435:	68 31 45 80 00       	push   $0x804531
  80343a:	e8 59 cf ff ff       	call   800398 <_panic>
  80343f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	85 c0                	test   %eax,%eax
  803446:	74 10                	je     803458 <realloc_block_FF+0x1da>
  803448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803450:	8b 52 04             	mov    0x4(%edx),%edx
  803453:	89 50 04             	mov    %edx,0x4(%eax)
  803456:	eb 0b                	jmp    803463 <realloc_block_FF+0x1e5>
  803458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345b:	8b 40 04             	mov    0x4(%eax),%eax
  80345e:	a3 30 50 80 00       	mov    %eax,0x805030
  803463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803466:	8b 40 04             	mov    0x4(%eax),%eax
  803469:	85 c0                	test   %eax,%eax
  80346b:	74 0f                	je     80347c <realloc_block_FF+0x1fe>
  80346d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803470:	8b 40 04             	mov    0x4(%eax),%eax
  803473:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803476:	8b 12                	mov    (%edx),%edx
  803478:	89 10                	mov    %edx,(%eax)
  80347a:	eb 0a                	jmp    803486 <realloc_block_FF+0x208>
  80347c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803489:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80348f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803492:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803499:	a1 38 50 80 00       	mov    0x805038,%eax
  80349e:	48                   	dec    %eax
  80349f:	a3 38 50 80 00       	mov    %eax,0x805038
  8034a4:	e9 83 02 00 00       	jmp    80372c <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034a9:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034ad:	0f 86 69 02 00 00    	jbe    80371c <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034b3:	83 ec 04             	sub    $0x4,%esp
  8034b6:	6a 01                	push   $0x1
  8034b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8034bb:	ff 75 08             	pushl  0x8(%ebp)
  8034be:	e8 c8 ed ff ff       	call   80228b <set_block_data>
  8034c3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c9:	83 e8 04             	sub    $0x4,%eax
  8034cc:	8b 00                	mov    (%eax),%eax
  8034ce:	83 e0 fe             	and    $0xfffffffe,%eax
  8034d1:	89 c2                	mov    %eax,%edx
  8034d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d6:	01 d0                	add    %edx,%eax
  8034d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034db:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034e7:	75 68                	jne    803551 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034e9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034ed:	75 17                	jne    803506 <realloc_block_FF+0x288>
  8034ef:	83 ec 04             	sub    $0x4,%esp
  8034f2:	68 4c 45 80 00       	push   $0x80454c
  8034f7:	68 06 02 00 00       	push   $0x206
  8034fc:	68 31 45 80 00       	push   $0x804531
  803501:	e8 92 ce ff ff       	call   800398 <_panic>
  803506:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80350c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350f:	89 10                	mov    %edx,(%eax)
  803511:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803514:	8b 00                	mov    (%eax),%eax
  803516:	85 c0                	test   %eax,%eax
  803518:	74 0d                	je     803527 <realloc_block_FF+0x2a9>
  80351a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80351f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803522:	89 50 04             	mov    %edx,0x4(%eax)
  803525:	eb 08                	jmp    80352f <realloc_block_FF+0x2b1>
  803527:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352a:	a3 30 50 80 00       	mov    %eax,0x805030
  80352f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803532:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803537:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803541:	a1 38 50 80 00       	mov    0x805038,%eax
  803546:	40                   	inc    %eax
  803547:	a3 38 50 80 00       	mov    %eax,0x805038
  80354c:	e9 b0 01 00 00       	jmp    803701 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803551:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803556:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803559:	76 68                	jbe    8035c3 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80355b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80355f:	75 17                	jne    803578 <realloc_block_FF+0x2fa>
  803561:	83 ec 04             	sub    $0x4,%esp
  803564:	68 4c 45 80 00       	push   $0x80454c
  803569:	68 0b 02 00 00       	push   $0x20b
  80356e:	68 31 45 80 00       	push   $0x804531
  803573:	e8 20 ce ff ff       	call   800398 <_panic>
  803578:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80357e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803581:	89 10                	mov    %edx,(%eax)
  803583:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803586:	8b 00                	mov    (%eax),%eax
  803588:	85 c0                	test   %eax,%eax
  80358a:	74 0d                	je     803599 <realloc_block_FF+0x31b>
  80358c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803591:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803594:	89 50 04             	mov    %edx,0x4(%eax)
  803597:	eb 08                	jmp    8035a1 <realloc_block_FF+0x323>
  803599:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359c:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8035b8:	40                   	inc    %eax
  8035b9:	a3 38 50 80 00       	mov    %eax,0x805038
  8035be:	e9 3e 01 00 00       	jmp    803701 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035c3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035c8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035cb:	73 68                	jae    803635 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035cd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035d1:	75 17                	jne    8035ea <realloc_block_FF+0x36c>
  8035d3:	83 ec 04             	sub    $0x4,%esp
  8035d6:	68 80 45 80 00       	push   $0x804580
  8035db:	68 10 02 00 00       	push   $0x210
  8035e0:	68 31 45 80 00       	push   $0x804531
  8035e5:	e8 ae cd ff ff       	call   800398 <_panic>
  8035ea:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f3:	89 50 04             	mov    %edx,0x4(%eax)
  8035f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f9:	8b 40 04             	mov    0x4(%eax),%eax
  8035fc:	85 c0                	test   %eax,%eax
  8035fe:	74 0c                	je     80360c <realloc_block_FF+0x38e>
  803600:	a1 30 50 80 00       	mov    0x805030,%eax
  803605:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803608:	89 10                	mov    %edx,(%eax)
  80360a:	eb 08                	jmp    803614 <realloc_block_FF+0x396>
  80360c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803614:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803617:	a3 30 50 80 00       	mov    %eax,0x805030
  80361c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803625:	a1 38 50 80 00       	mov    0x805038,%eax
  80362a:	40                   	inc    %eax
  80362b:	a3 38 50 80 00       	mov    %eax,0x805038
  803630:	e9 cc 00 00 00       	jmp    803701 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803635:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80363c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803641:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803644:	e9 8a 00 00 00       	jmp    8036d3 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80364f:	73 7a                	jae    8036cb <realloc_block_FF+0x44d>
  803651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803654:	8b 00                	mov    (%eax),%eax
  803656:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803659:	73 70                	jae    8036cb <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80365b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365f:	74 06                	je     803667 <realloc_block_FF+0x3e9>
  803661:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803665:	75 17                	jne    80367e <realloc_block_FF+0x400>
  803667:	83 ec 04             	sub    $0x4,%esp
  80366a:	68 a4 45 80 00       	push   $0x8045a4
  80366f:	68 1a 02 00 00       	push   $0x21a
  803674:	68 31 45 80 00       	push   $0x804531
  803679:	e8 1a cd ff ff       	call   800398 <_panic>
  80367e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803681:	8b 10                	mov    (%eax),%edx
  803683:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803686:	89 10                	mov    %edx,(%eax)
  803688:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368b:	8b 00                	mov    (%eax),%eax
  80368d:	85 c0                	test   %eax,%eax
  80368f:	74 0b                	je     80369c <realloc_block_FF+0x41e>
  803691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803694:	8b 00                	mov    (%eax),%eax
  803696:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803699:	89 50 04             	mov    %edx,0x4(%eax)
  80369c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a2:	89 10                	mov    %edx,(%eax)
  8036a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036aa:	89 50 04             	mov    %edx,0x4(%eax)
  8036ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b0:	8b 00                	mov    (%eax),%eax
  8036b2:	85 c0                	test   %eax,%eax
  8036b4:	75 08                	jne    8036be <realloc_block_FF+0x440>
  8036b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8036be:	a1 38 50 80 00       	mov    0x805038,%eax
  8036c3:	40                   	inc    %eax
  8036c4:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036c9:	eb 36                	jmp    803701 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036cb:	a1 34 50 80 00       	mov    0x805034,%eax
  8036d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d7:	74 07                	je     8036e0 <realloc_block_FF+0x462>
  8036d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036dc:	8b 00                	mov    (%eax),%eax
  8036de:	eb 05                	jmp    8036e5 <realloc_block_FF+0x467>
  8036e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e5:	a3 34 50 80 00       	mov    %eax,0x805034
  8036ea:	a1 34 50 80 00       	mov    0x805034,%eax
  8036ef:	85 c0                	test   %eax,%eax
  8036f1:	0f 85 52 ff ff ff    	jne    803649 <realloc_block_FF+0x3cb>
  8036f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036fb:	0f 85 48 ff ff ff    	jne    803649 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803701:	83 ec 04             	sub    $0x4,%esp
  803704:	6a 00                	push   $0x0
  803706:	ff 75 d8             	pushl  -0x28(%ebp)
  803709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80370c:	e8 7a eb ff ff       	call   80228b <set_block_data>
  803711:	83 c4 10             	add    $0x10,%esp
				return va;
  803714:	8b 45 08             	mov    0x8(%ebp),%eax
  803717:	e9 7b 02 00 00       	jmp    803997 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80371c:	83 ec 0c             	sub    $0xc,%esp
  80371f:	68 21 46 80 00       	push   $0x804621
  803724:	e8 2c cf ff ff       	call   800655 <cprintf>
  803729:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	e9 63 02 00 00       	jmp    803997 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803734:	8b 45 0c             	mov    0xc(%ebp),%eax
  803737:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80373a:	0f 86 4d 02 00 00    	jbe    80398d <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803740:	83 ec 0c             	sub    $0xc,%esp
  803743:	ff 75 e4             	pushl  -0x1c(%ebp)
  803746:	e8 08 e8 ff ff       	call   801f53 <is_free_block>
  80374b:	83 c4 10             	add    $0x10,%esp
  80374e:	84 c0                	test   %al,%al
  803750:	0f 84 37 02 00 00    	je     80398d <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803756:	8b 45 0c             	mov    0xc(%ebp),%eax
  803759:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80375c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80375f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803762:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803765:	76 38                	jbe    80379f <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803767:	83 ec 0c             	sub    $0xc,%esp
  80376a:	ff 75 08             	pushl  0x8(%ebp)
  80376d:	e8 0c fa ff ff       	call   80317e <free_block>
  803772:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803775:	83 ec 0c             	sub    $0xc,%esp
  803778:	ff 75 0c             	pushl  0xc(%ebp)
  80377b:	e8 3a eb ff ff       	call   8022ba <alloc_block_FF>
  803780:	83 c4 10             	add    $0x10,%esp
  803783:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803786:	83 ec 08             	sub    $0x8,%esp
  803789:	ff 75 c0             	pushl  -0x40(%ebp)
  80378c:	ff 75 08             	pushl  0x8(%ebp)
  80378f:	e8 ab fa ff ff       	call   80323f <copy_data>
  803794:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803797:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80379a:	e9 f8 01 00 00       	jmp    803997 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80379f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037a2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037a5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037a8:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037ac:	0f 87 a0 00 00 00    	ja     803852 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037b6:	75 17                	jne    8037cf <realloc_block_FF+0x551>
  8037b8:	83 ec 04             	sub    $0x4,%esp
  8037bb:	68 13 45 80 00       	push   $0x804513
  8037c0:	68 38 02 00 00       	push   $0x238
  8037c5:	68 31 45 80 00       	push   $0x804531
  8037ca:	e8 c9 cb ff ff       	call   800398 <_panic>
  8037cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d2:	8b 00                	mov    (%eax),%eax
  8037d4:	85 c0                	test   %eax,%eax
  8037d6:	74 10                	je     8037e8 <realloc_block_FF+0x56a>
  8037d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037db:	8b 00                	mov    (%eax),%eax
  8037dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037e0:	8b 52 04             	mov    0x4(%edx),%edx
  8037e3:	89 50 04             	mov    %edx,0x4(%eax)
  8037e6:	eb 0b                	jmp    8037f3 <realloc_block_FF+0x575>
  8037e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037eb:	8b 40 04             	mov    0x4(%eax),%eax
  8037ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8037f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f6:	8b 40 04             	mov    0x4(%eax),%eax
  8037f9:	85 c0                	test   %eax,%eax
  8037fb:	74 0f                	je     80380c <realloc_block_FF+0x58e>
  8037fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803800:	8b 40 04             	mov    0x4(%eax),%eax
  803803:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803806:	8b 12                	mov    (%edx),%edx
  803808:	89 10                	mov    %edx,(%eax)
  80380a:	eb 0a                	jmp    803816 <realloc_block_FF+0x598>
  80380c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380f:	8b 00                	mov    (%eax),%eax
  803811:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80381f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803822:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803829:	a1 38 50 80 00       	mov    0x805038,%eax
  80382e:	48                   	dec    %eax
  80382f:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803834:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80383a:	01 d0                	add    %edx,%eax
  80383c:	83 ec 04             	sub    $0x4,%esp
  80383f:	6a 01                	push   $0x1
  803841:	50                   	push   %eax
  803842:	ff 75 08             	pushl  0x8(%ebp)
  803845:	e8 41 ea ff ff       	call   80228b <set_block_data>
  80384a:	83 c4 10             	add    $0x10,%esp
  80384d:	e9 36 01 00 00       	jmp    803988 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803852:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803855:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803858:	01 d0                	add    %edx,%eax
  80385a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80385d:	83 ec 04             	sub    $0x4,%esp
  803860:	6a 01                	push   $0x1
  803862:	ff 75 f0             	pushl  -0x10(%ebp)
  803865:	ff 75 08             	pushl  0x8(%ebp)
  803868:	e8 1e ea ff ff       	call   80228b <set_block_data>
  80386d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803870:	8b 45 08             	mov    0x8(%ebp),%eax
  803873:	83 e8 04             	sub    $0x4,%eax
  803876:	8b 00                	mov    (%eax),%eax
  803878:	83 e0 fe             	and    $0xfffffffe,%eax
  80387b:	89 c2                	mov    %eax,%edx
  80387d:	8b 45 08             	mov    0x8(%ebp),%eax
  803880:	01 d0                	add    %edx,%eax
  803882:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803885:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803889:	74 06                	je     803891 <realloc_block_FF+0x613>
  80388b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80388f:	75 17                	jne    8038a8 <realloc_block_FF+0x62a>
  803891:	83 ec 04             	sub    $0x4,%esp
  803894:	68 a4 45 80 00       	push   $0x8045a4
  803899:	68 44 02 00 00       	push   $0x244
  80389e:	68 31 45 80 00       	push   $0x804531
  8038a3:	e8 f0 ca ff ff       	call   800398 <_panic>
  8038a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ab:	8b 10                	mov    (%eax),%edx
  8038ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b0:	89 10                	mov    %edx,(%eax)
  8038b2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b5:	8b 00                	mov    (%eax),%eax
  8038b7:	85 c0                	test   %eax,%eax
  8038b9:	74 0b                	je     8038c6 <realloc_block_FF+0x648>
  8038bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038be:	8b 00                	mov    (%eax),%eax
  8038c0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038c3:	89 50 04             	mov    %edx,0x4(%eax)
  8038c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038cc:	89 10                	mov    %edx,(%eax)
  8038ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d4:	89 50 04             	mov    %edx,0x4(%eax)
  8038d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038da:	8b 00                	mov    (%eax),%eax
  8038dc:	85 c0                	test   %eax,%eax
  8038de:	75 08                	jne    8038e8 <realloc_block_FF+0x66a>
  8038e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8038e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ed:	40                   	inc    %eax
  8038ee:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038f7:	75 17                	jne    803910 <realloc_block_FF+0x692>
  8038f9:	83 ec 04             	sub    $0x4,%esp
  8038fc:	68 13 45 80 00       	push   $0x804513
  803901:	68 45 02 00 00       	push   $0x245
  803906:	68 31 45 80 00       	push   $0x804531
  80390b:	e8 88 ca ff ff       	call   800398 <_panic>
  803910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803913:	8b 00                	mov    (%eax),%eax
  803915:	85 c0                	test   %eax,%eax
  803917:	74 10                	je     803929 <realloc_block_FF+0x6ab>
  803919:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391c:	8b 00                	mov    (%eax),%eax
  80391e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803921:	8b 52 04             	mov    0x4(%edx),%edx
  803924:	89 50 04             	mov    %edx,0x4(%eax)
  803927:	eb 0b                	jmp    803934 <realloc_block_FF+0x6b6>
  803929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392c:	8b 40 04             	mov    0x4(%eax),%eax
  80392f:	a3 30 50 80 00       	mov    %eax,0x805030
  803934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803937:	8b 40 04             	mov    0x4(%eax),%eax
  80393a:	85 c0                	test   %eax,%eax
  80393c:	74 0f                	je     80394d <realloc_block_FF+0x6cf>
  80393e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803941:	8b 40 04             	mov    0x4(%eax),%eax
  803944:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803947:	8b 12                	mov    (%edx),%edx
  803949:	89 10                	mov    %edx,(%eax)
  80394b:	eb 0a                	jmp    803957 <realloc_block_FF+0x6d9>
  80394d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803950:	8b 00                	mov    (%eax),%eax
  803952:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803963:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80396a:	a1 38 50 80 00       	mov    0x805038,%eax
  80396f:	48                   	dec    %eax
  803970:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803975:	83 ec 04             	sub    $0x4,%esp
  803978:	6a 00                	push   $0x0
  80397a:	ff 75 bc             	pushl  -0x44(%ebp)
  80397d:	ff 75 b8             	pushl  -0x48(%ebp)
  803980:	e8 06 e9 ff ff       	call   80228b <set_block_data>
  803985:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803988:	8b 45 08             	mov    0x8(%ebp),%eax
  80398b:	eb 0a                	jmp    803997 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80398d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803994:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803997:	c9                   	leave  
  803998:	c3                   	ret    

00803999 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803999:	55                   	push   %ebp
  80399a:	89 e5                	mov    %esp,%ebp
  80399c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80399f:	83 ec 04             	sub    $0x4,%esp
  8039a2:	68 28 46 80 00       	push   $0x804628
  8039a7:	68 58 02 00 00       	push   $0x258
  8039ac:	68 31 45 80 00       	push   $0x804531
  8039b1:	e8 e2 c9 ff ff       	call   800398 <_panic>

008039b6 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039b6:	55                   	push   %ebp
  8039b7:	89 e5                	mov    %esp,%ebp
  8039b9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039bc:	83 ec 04             	sub    $0x4,%esp
  8039bf:	68 50 46 80 00       	push   $0x804650
  8039c4:	68 61 02 00 00       	push   $0x261
  8039c9:	68 31 45 80 00       	push   $0x804531
  8039ce:	e8 c5 c9 ff ff       	call   800398 <_panic>
  8039d3:	90                   	nop

008039d4 <__udivdi3>:
  8039d4:	55                   	push   %ebp
  8039d5:	57                   	push   %edi
  8039d6:	56                   	push   %esi
  8039d7:	53                   	push   %ebx
  8039d8:	83 ec 1c             	sub    $0x1c,%esp
  8039db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039eb:	89 ca                	mov    %ecx,%edx
  8039ed:	89 f8                	mov    %edi,%eax
  8039ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039f3:	85 f6                	test   %esi,%esi
  8039f5:	75 2d                	jne    803a24 <__udivdi3+0x50>
  8039f7:	39 cf                	cmp    %ecx,%edi
  8039f9:	77 65                	ja     803a60 <__udivdi3+0x8c>
  8039fb:	89 fd                	mov    %edi,%ebp
  8039fd:	85 ff                	test   %edi,%edi
  8039ff:	75 0b                	jne    803a0c <__udivdi3+0x38>
  803a01:	b8 01 00 00 00       	mov    $0x1,%eax
  803a06:	31 d2                	xor    %edx,%edx
  803a08:	f7 f7                	div    %edi
  803a0a:	89 c5                	mov    %eax,%ebp
  803a0c:	31 d2                	xor    %edx,%edx
  803a0e:	89 c8                	mov    %ecx,%eax
  803a10:	f7 f5                	div    %ebp
  803a12:	89 c1                	mov    %eax,%ecx
  803a14:	89 d8                	mov    %ebx,%eax
  803a16:	f7 f5                	div    %ebp
  803a18:	89 cf                	mov    %ecx,%edi
  803a1a:	89 fa                	mov    %edi,%edx
  803a1c:	83 c4 1c             	add    $0x1c,%esp
  803a1f:	5b                   	pop    %ebx
  803a20:	5e                   	pop    %esi
  803a21:	5f                   	pop    %edi
  803a22:	5d                   	pop    %ebp
  803a23:	c3                   	ret    
  803a24:	39 ce                	cmp    %ecx,%esi
  803a26:	77 28                	ja     803a50 <__udivdi3+0x7c>
  803a28:	0f bd fe             	bsr    %esi,%edi
  803a2b:	83 f7 1f             	xor    $0x1f,%edi
  803a2e:	75 40                	jne    803a70 <__udivdi3+0x9c>
  803a30:	39 ce                	cmp    %ecx,%esi
  803a32:	72 0a                	jb     803a3e <__udivdi3+0x6a>
  803a34:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a38:	0f 87 9e 00 00 00    	ja     803adc <__udivdi3+0x108>
  803a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a43:	89 fa                	mov    %edi,%edx
  803a45:	83 c4 1c             	add    $0x1c,%esp
  803a48:	5b                   	pop    %ebx
  803a49:	5e                   	pop    %esi
  803a4a:	5f                   	pop    %edi
  803a4b:	5d                   	pop    %ebp
  803a4c:	c3                   	ret    
  803a4d:	8d 76 00             	lea    0x0(%esi),%esi
  803a50:	31 ff                	xor    %edi,%edi
  803a52:	31 c0                	xor    %eax,%eax
  803a54:	89 fa                	mov    %edi,%edx
  803a56:	83 c4 1c             	add    $0x1c,%esp
  803a59:	5b                   	pop    %ebx
  803a5a:	5e                   	pop    %esi
  803a5b:	5f                   	pop    %edi
  803a5c:	5d                   	pop    %ebp
  803a5d:	c3                   	ret    
  803a5e:	66 90                	xchg   %ax,%ax
  803a60:	89 d8                	mov    %ebx,%eax
  803a62:	f7 f7                	div    %edi
  803a64:	31 ff                	xor    %edi,%edi
  803a66:	89 fa                	mov    %edi,%edx
  803a68:	83 c4 1c             	add    $0x1c,%esp
  803a6b:	5b                   	pop    %ebx
  803a6c:	5e                   	pop    %esi
  803a6d:	5f                   	pop    %edi
  803a6e:	5d                   	pop    %ebp
  803a6f:	c3                   	ret    
  803a70:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a75:	89 eb                	mov    %ebp,%ebx
  803a77:	29 fb                	sub    %edi,%ebx
  803a79:	89 f9                	mov    %edi,%ecx
  803a7b:	d3 e6                	shl    %cl,%esi
  803a7d:	89 c5                	mov    %eax,%ebp
  803a7f:	88 d9                	mov    %bl,%cl
  803a81:	d3 ed                	shr    %cl,%ebp
  803a83:	89 e9                	mov    %ebp,%ecx
  803a85:	09 f1                	or     %esi,%ecx
  803a87:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a8b:	89 f9                	mov    %edi,%ecx
  803a8d:	d3 e0                	shl    %cl,%eax
  803a8f:	89 c5                	mov    %eax,%ebp
  803a91:	89 d6                	mov    %edx,%esi
  803a93:	88 d9                	mov    %bl,%cl
  803a95:	d3 ee                	shr    %cl,%esi
  803a97:	89 f9                	mov    %edi,%ecx
  803a99:	d3 e2                	shl    %cl,%edx
  803a9b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a9f:	88 d9                	mov    %bl,%cl
  803aa1:	d3 e8                	shr    %cl,%eax
  803aa3:	09 c2                	or     %eax,%edx
  803aa5:	89 d0                	mov    %edx,%eax
  803aa7:	89 f2                	mov    %esi,%edx
  803aa9:	f7 74 24 0c          	divl   0xc(%esp)
  803aad:	89 d6                	mov    %edx,%esi
  803aaf:	89 c3                	mov    %eax,%ebx
  803ab1:	f7 e5                	mul    %ebp
  803ab3:	39 d6                	cmp    %edx,%esi
  803ab5:	72 19                	jb     803ad0 <__udivdi3+0xfc>
  803ab7:	74 0b                	je     803ac4 <__udivdi3+0xf0>
  803ab9:	89 d8                	mov    %ebx,%eax
  803abb:	31 ff                	xor    %edi,%edi
  803abd:	e9 58 ff ff ff       	jmp    803a1a <__udivdi3+0x46>
  803ac2:	66 90                	xchg   %ax,%ax
  803ac4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ac8:	89 f9                	mov    %edi,%ecx
  803aca:	d3 e2                	shl    %cl,%edx
  803acc:	39 c2                	cmp    %eax,%edx
  803ace:	73 e9                	jae    803ab9 <__udivdi3+0xe5>
  803ad0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ad3:	31 ff                	xor    %edi,%edi
  803ad5:	e9 40 ff ff ff       	jmp    803a1a <__udivdi3+0x46>
  803ada:	66 90                	xchg   %ax,%ax
  803adc:	31 c0                	xor    %eax,%eax
  803ade:	e9 37 ff ff ff       	jmp    803a1a <__udivdi3+0x46>
  803ae3:	90                   	nop

00803ae4 <__umoddi3>:
  803ae4:	55                   	push   %ebp
  803ae5:	57                   	push   %edi
  803ae6:	56                   	push   %esi
  803ae7:	53                   	push   %ebx
  803ae8:	83 ec 1c             	sub    $0x1c,%esp
  803aeb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803aef:	8b 74 24 34          	mov    0x34(%esp),%esi
  803af3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803af7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803afb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803aff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b03:	89 f3                	mov    %esi,%ebx
  803b05:	89 fa                	mov    %edi,%edx
  803b07:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b0b:	89 34 24             	mov    %esi,(%esp)
  803b0e:	85 c0                	test   %eax,%eax
  803b10:	75 1a                	jne    803b2c <__umoddi3+0x48>
  803b12:	39 f7                	cmp    %esi,%edi
  803b14:	0f 86 a2 00 00 00    	jbe    803bbc <__umoddi3+0xd8>
  803b1a:	89 c8                	mov    %ecx,%eax
  803b1c:	89 f2                	mov    %esi,%edx
  803b1e:	f7 f7                	div    %edi
  803b20:	89 d0                	mov    %edx,%eax
  803b22:	31 d2                	xor    %edx,%edx
  803b24:	83 c4 1c             	add    $0x1c,%esp
  803b27:	5b                   	pop    %ebx
  803b28:	5e                   	pop    %esi
  803b29:	5f                   	pop    %edi
  803b2a:	5d                   	pop    %ebp
  803b2b:	c3                   	ret    
  803b2c:	39 f0                	cmp    %esi,%eax
  803b2e:	0f 87 ac 00 00 00    	ja     803be0 <__umoddi3+0xfc>
  803b34:	0f bd e8             	bsr    %eax,%ebp
  803b37:	83 f5 1f             	xor    $0x1f,%ebp
  803b3a:	0f 84 ac 00 00 00    	je     803bec <__umoddi3+0x108>
  803b40:	bf 20 00 00 00       	mov    $0x20,%edi
  803b45:	29 ef                	sub    %ebp,%edi
  803b47:	89 fe                	mov    %edi,%esi
  803b49:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b4d:	89 e9                	mov    %ebp,%ecx
  803b4f:	d3 e0                	shl    %cl,%eax
  803b51:	89 d7                	mov    %edx,%edi
  803b53:	89 f1                	mov    %esi,%ecx
  803b55:	d3 ef                	shr    %cl,%edi
  803b57:	09 c7                	or     %eax,%edi
  803b59:	89 e9                	mov    %ebp,%ecx
  803b5b:	d3 e2                	shl    %cl,%edx
  803b5d:	89 14 24             	mov    %edx,(%esp)
  803b60:	89 d8                	mov    %ebx,%eax
  803b62:	d3 e0                	shl    %cl,%eax
  803b64:	89 c2                	mov    %eax,%edx
  803b66:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b6a:	d3 e0                	shl    %cl,%eax
  803b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b70:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b74:	89 f1                	mov    %esi,%ecx
  803b76:	d3 e8                	shr    %cl,%eax
  803b78:	09 d0                	or     %edx,%eax
  803b7a:	d3 eb                	shr    %cl,%ebx
  803b7c:	89 da                	mov    %ebx,%edx
  803b7e:	f7 f7                	div    %edi
  803b80:	89 d3                	mov    %edx,%ebx
  803b82:	f7 24 24             	mull   (%esp)
  803b85:	89 c6                	mov    %eax,%esi
  803b87:	89 d1                	mov    %edx,%ecx
  803b89:	39 d3                	cmp    %edx,%ebx
  803b8b:	0f 82 87 00 00 00    	jb     803c18 <__umoddi3+0x134>
  803b91:	0f 84 91 00 00 00    	je     803c28 <__umoddi3+0x144>
  803b97:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b9b:	29 f2                	sub    %esi,%edx
  803b9d:	19 cb                	sbb    %ecx,%ebx
  803b9f:	89 d8                	mov    %ebx,%eax
  803ba1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ba5:	d3 e0                	shl    %cl,%eax
  803ba7:	89 e9                	mov    %ebp,%ecx
  803ba9:	d3 ea                	shr    %cl,%edx
  803bab:	09 d0                	or     %edx,%eax
  803bad:	89 e9                	mov    %ebp,%ecx
  803baf:	d3 eb                	shr    %cl,%ebx
  803bb1:	89 da                	mov    %ebx,%edx
  803bb3:	83 c4 1c             	add    $0x1c,%esp
  803bb6:	5b                   	pop    %ebx
  803bb7:	5e                   	pop    %esi
  803bb8:	5f                   	pop    %edi
  803bb9:	5d                   	pop    %ebp
  803bba:	c3                   	ret    
  803bbb:	90                   	nop
  803bbc:	89 fd                	mov    %edi,%ebp
  803bbe:	85 ff                	test   %edi,%edi
  803bc0:	75 0b                	jne    803bcd <__umoddi3+0xe9>
  803bc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc7:	31 d2                	xor    %edx,%edx
  803bc9:	f7 f7                	div    %edi
  803bcb:	89 c5                	mov    %eax,%ebp
  803bcd:	89 f0                	mov    %esi,%eax
  803bcf:	31 d2                	xor    %edx,%edx
  803bd1:	f7 f5                	div    %ebp
  803bd3:	89 c8                	mov    %ecx,%eax
  803bd5:	f7 f5                	div    %ebp
  803bd7:	89 d0                	mov    %edx,%eax
  803bd9:	e9 44 ff ff ff       	jmp    803b22 <__umoddi3+0x3e>
  803bde:	66 90                	xchg   %ax,%ax
  803be0:	89 c8                	mov    %ecx,%eax
  803be2:	89 f2                	mov    %esi,%edx
  803be4:	83 c4 1c             	add    $0x1c,%esp
  803be7:	5b                   	pop    %ebx
  803be8:	5e                   	pop    %esi
  803be9:	5f                   	pop    %edi
  803bea:	5d                   	pop    %ebp
  803beb:	c3                   	ret    
  803bec:	3b 04 24             	cmp    (%esp),%eax
  803bef:	72 06                	jb     803bf7 <__umoddi3+0x113>
  803bf1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bf5:	77 0f                	ja     803c06 <__umoddi3+0x122>
  803bf7:	89 f2                	mov    %esi,%edx
  803bf9:	29 f9                	sub    %edi,%ecx
  803bfb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bff:	89 14 24             	mov    %edx,(%esp)
  803c02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c06:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c0a:	8b 14 24             	mov    (%esp),%edx
  803c0d:	83 c4 1c             	add    $0x1c,%esp
  803c10:	5b                   	pop    %ebx
  803c11:	5e                   	pop    %esi
  803c12:	5f                   	pop    %edi
  803c13:	5d                   	pop    %ebp
  803c14:	c3                   	ret    
  803c15:	8d 76 00             	lea    0x0(%esi),%esi
  803c18:	2b 04 24             	sub    (%esp),%eax
  803c1b:	19 fa                	sbb    %edi,%edx
  803c1d:	89 d1                	mov    %edx,%ecx
  803c1f:	89 c6                	mov    %eax,%esi
  803c21:	e9 71 ff ff ff       	jmp    803b97 <__umoddi3+0xb3>
  803c26:	66 90                	xchg   %ax,%ax
  803c28:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c2c:	72 ea                	jb     803c18 <__umoddi3+0x134>
  803c2e:	89 d9                	mov    %ebx,%ecx
  803c30:	e9 62 ff ff ff       	jmp    803b97 <__umoddi3+0xb3>
