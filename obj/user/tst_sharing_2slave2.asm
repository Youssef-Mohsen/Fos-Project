
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
  80005c:	68 e0 3b 80 00       	push   $0x803be0
  800061:	6a 0d                	push   $0xd
  800063:	68 fc 3b 80 00       	push   $0x803bfc
  800068:	e8 2b 03 00 00       	call   800398 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  800074:	e8 40 1b 00 00       	call   801bb9 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int freeFrames, diff, expected;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 a3 18 00 00       	call   801924 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 51 19 00 00       	call   8019d7 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 17 3c 80 00       	push   $0x803c17
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 08 17 00 00       	call   8017a1 <sget>
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
  8000b6:	68 1c 3c 80 00       	push   $0x803c1c
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 fc 3b 80 00       	push   $0x803bfc
  8000c2:	e8 d1 02 00 00       	call   800398 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 01 19 00 00       	call   8019d7 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 ea 18 00 00       	call   8019d7 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 98 3c 80 00       	push   $0x803c98
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 fc 3b 80 00       	push   $0x803bfc
  800104:	e8 8f 02 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 30 18 00 00       	call   80193e <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 11 18 00 00       	call   801924 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 bf 18 00 00       	call   8019d7 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 30 3d 80 00       	push   $0x803d30
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 76 16 00 00       	call   8017a1 <sget>
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
  80014d:	68 1c 3c 80 00       	push   $0x803c1c
  800152:	6a 31                	push   $0x31
  800154:	68 fc 3b 80 00       	push   $0x803bfc
  800159:	e8 3a 02 00 00       	call   800398 <_panic>
		expected = 0;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 6a 18 00 00       	call   8019d7 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 53 18 00 00       	call   8019d7 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 98 3c 80 00       	push   $0x803c98
  800194:	6a 34                	push   $0x34
  800196:	68 fc 3b 80 00       	push   $0x803bfc
  80019b:	e8 f8 01 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 99 17 00 00       	call   80193e <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 0a             	cmp    $0xa,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 34 3d 80 00       	push   $0x803d34
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 fc 3b 80 00       	push   $0x803bfc
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
  8001d9:	68 34 3d 80 00       	push   $0x803d34
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 fc 3b 80 00       	push   $0x803bfc
  8001e5:	e8 ae 01 00 00       	call   800398 <_panic>

	inctst();
  8001ea:	e8 ef 1a 00 00       	call   801cde <inctst>

	//sync with master
	while (gettst() != 5) ;
  8001ef:	90                   	nop
  8001f0:	e8 03 1b 00 00       	call   801cf8 <gettst>
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	75 f6                	jne    8001f0 <_main+0x1b8>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 06                	push   $0x6
  8001ff:	e8 54 1a 00 00       	call   801c58 <sys_bypassPageFault>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	68 6c 3d 80 00       	push   $0x803d6c
  800212:	e8 3e 04 00 00       	call   800655 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 2b 1a 00 00       	call   801c58 <sys_bypassPageFault>
  80022d:	83 c4 10             	add    $0x10,%esp

	inctst();
  800230:	e8 a9 1a 00 00       	call   801cde <inctst>
	if (*x == 100)
  800235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	83 f8 64             	cmp    $0x64,%eax
  80023d:	75 14                	jne    800253 <_main+0x21b>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 9c 3d 80 00       	push   $0x803d9c
  800247:	6a 4d                	push   $0x4d
  800249:	68 fc 3b 80 00       	push   $0x803bfc
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
  80025f:	e8 3c 19 00 00       	call   801ba0 <sys_getenvindex>
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
  8002cd:	e8 52 16 00 00       	call   801924 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	68 fc 3d 80 00       	push   $0x803dfc
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
  8002fd:	68 24 3e 80 00       	push   $0x803e24
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
  80032e:	68 4c 3e 80 00       	push   $0x803e4c
  800333:	e8 1d 03 00 00       	call   800655 <cprintf>
  800338:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80033b:	a1 20 50 80 00       	mov    0x805020,%eax
  800340:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	50                   	push   %eax
  80034a:	68 a4 3e 80 00       	push   $0x803ea4
  80034f:	e8 01 03 00 00       	call   800655 <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	68 fc 3d 80 00       	push   $0x803dfc
  80035f:	e8 f1 02 00 00       	call   800655 <cprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800367:	e8 d2 15 00 00       	call   80193e <sys_unlock_cons>
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
  80037f:	e8 e8 17 00 00       	call   801b6c <sys_destroy_env>
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
  800390:	e8 3d 18 00 00       	call   801bd2 <sys_exit_env>
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
  8003b9:	68 b8 3e 80 00       	push   $0x803eb8
  8003be:	e8 92 02 00 00       	call   800655 <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003c6:	a1 00 50 80 00       	mov    0x805000,%eax
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	50                   	push   %eax
  8003d2:	68 bd 3e 80 00       	push   $0x803ebd
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
  8003f6:	68 d9 3e 80 00       	push   $0x803ed9
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
  800425:	68 dc 3e 80 00       	push   $0x803edc
  80042a:	6a 26                	push   $0x26
  80042c:	68 28 3f 80 00       	push   $0x803f28
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
  8004fa:	68 34 3f 80 00       	push   $0x803f34
  8004ff:	6a 3a                	push   $0x3a
  800501:	68 28 3f 80 00       	push   $0x803f28
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
  80056d:	68 88 3f 80 00       	push   $0x803f88
  800572:	6a 44                	push   $0x44
  800574:	68 28 3f 80 00       	push   $0x803f28
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
  8005c7:	e8 16 13 00 00       	call   8018e2 <sys_cputs>
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
  80063e:	e8 9f 12 00 00       	call   8018e2 <sys_cputs>
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
  800688:	e8 97 12 00 00       	call   801924 <sys_lock_cons>
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
  8006a8:	e8 91 12 00 00       	call   80193e <sys_unlock_cons>
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
  8006f2:	e8 85 32 00 00       	call   80397c <__udivdi3>
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
  800742:	e8 45 33 00 00       	call   803a8c <__umoddi3>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	05 f4 41 80 00       	add    $0x8041f4,%eax
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
  80089d:	8b 04 85 18 42 80 00 	mov    0x804218(,%eax,4),%eax
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
  80097e:	8b 34 9d 60 40 80 00 	mov    0x804060(,%ebx,4),%esi
  800985:	85 f6                	test   %esi,%esi
  800987:	75 19                	jne    8009a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800989:	53                   	push   %ebx
  80098a:	68 05 42 80 00       	push   $0x804205
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
  8009a3:	68 0e 42 80 00       	push   $0x80420e
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
  8009d0:	be 11 42 80 00       	mov    $0x804211,%esi
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
  8013db:	68 88 43 80 00       	push   $0x804388
  8013e0:	68 3f 01 00 00       	push   $0x13f
  8013e5:	68 aa 43 80 00       	push   $0x8043aa
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
  8013fb:	e8 8d 0a 00 00       	call   801e8d <sys_sbrk>
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
  801476:	e8 96 08 00 00       	call   801d11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80147b:	85 c0                	test   %eax,%eax
  80147d:	74 16                	je     801495 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	e8 d6 0d 00 00       	call   802260 <alloc_block_FF>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801490:	e9 8a 01 00 00       	jmp    80161f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801495:	e8 a8 08 00 00       	call   801d42 <sys_isUHeapPlacementStrategyBESTFIT>
  80149a:	85 c0                	test   %eax,%eax
  80149c:	0f 84 7d 01 00 00    	je     80161f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 6f 12 00 00       	call   80271c <alloc_block_BF>
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
  80160e:	e8 b1 08 00 00       	call   801ec4 <sys_allocate_user_mem>
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
  801656:	e8 85 08 00 00       	call   801ee0 <get_block_size>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	e8 b8 1a 00 00       	call   803124 <free_block>
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
  8016fe:	e8 a5 07 00 00       	call   801ea8 <sys_free_user_mem>
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
  80170c:	68 b8 43 80 00       	push   $0x8043b8
  801711:	68 84 00 00 00       	push   $0x84
  801716:	68 e2 43 80 00       	push   $0x8043e2
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
  801739:	eb 64                	jmp    80179f <smalloc+0x7d>
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
  80176e:	eb 2f                	jmp    80179f <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801770:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801774:	ff 75 ec             	pushl  -0x14(%ebp)
  801777:	50                   	push   %eax
  801778:	ff 75 0c             	pushl  0xc(%ebp)
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	e8 2c 03 00 00       	call   801aaf <sys_createSharedObject>
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801789:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80178d:	74 06                	je     801795 <smalloc+0x73>
  80178f:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801793:	75 07                	jne    80179c <smalloc+0x7a>
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
  80179a:	eb 03                	jmp    80179f <smalloc+0x7d>
	 return ptr;
  80179c:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017a7:	83 ec 08             	sub    $0x8,%esp
  8017aa:	ff 75 0c             	pushl  0xc(%ebp)
  8017ad:	ff 75 08             	pushl  0x8(%ebp)
  8017b0:	e8 24 03 00 00       	call   801ad9 <sys_getSizeOfSharedObject>
  8017b5:	83 c4 10             	add    $0x10,%esp
  8017b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8017bb:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017bf:	75 07                	jne    8017c8 <sget+0x27>
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c6:	eb 5c                	jmp    801824 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017ce:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017db:	39 d0                	cmp    %edx,%eax
  8017dd:	7d 02                	jge    8017e1 <sget+0x40>
  8017df:	89 d0                	mov    %edx,%eax
  8017e1:	83 ec 0c             	sub    $0xc,%esp
  8017e4:	50                   	push   %eax
  8017e5:	e8 1b fc ff ff       	call   801405 <malloc>
  8017ea:	83 c4 10             	add    $0x10,%esp
  8017ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8017f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017f4:	75 07                	jne    8017fd <sget+0x5c>
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fb:	eb 27                	jmp    801824 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8017fd:	83 ec 04             	sub    $0x4,%esp
  801800:	ff 75 e8             	pushl  -0x18(%ebp)
  801803:	ff 75 0c             	pushl  0xc(%ebp)
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 e8 02 00 00       	call   801af6 <sys_getSharedObject>
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801814:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801818:	75 07                	jne    801821 <sget+0x80>
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
  80181f:	eb 03                	jmp    801824 <sget+0x83>
	return ptr;
  801821:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80182c:	83 ec 04             	sub    $0x4,%esp
  80182f:	68 f0 43 80 00       	push   $0x8043f0
  801834:	68 c1 00 00 00       	push   $0xc1
  801839:	68 e2 43 80 00       	push   $0x8043e2
  80183e:	e8 55 eb ff ff       	call   800398 <_panic>

00801843 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801849:	83 ec 04             	sub    $0x4,%esp
  80184c:	68 14 44 80 00       	push   $0x804414
  801851:	68 d8 00 00 00       	push   $0xd8
  801856:	68 e2 43 80 00       	push   $0x8043e2
  80185b:	e8 38 eb ff ff       	call   800398 <_panic>

00801860 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801866:	83 ec 04             	sub    $0x4,%esp
  801869:	68 3a 44 80 00       	push   $0x80443a
  80186e:	68 e4 00 00 00       	push   $0xe4
  801873:	68 e2 43 80 00       	push   $0x8043e2
  801878:	e8 1b eb ff ff       	call   800398 <_panic>

0080187d <shrink>:

}
void shrink(uint32 newSize)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801883:	83 ec 04             	sub    $0x4,%esp
  801886:	68 3a 44 80 00       	push   $0x80443a
  80188b:	68 e9 00 00 00       	push   $0xe9
  801890:	68 e2 43 80 00       	push   $0x8043e2
  801895:	e8 fe ea ff ff       	call   800398 <_panic>

0080189a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a0:	83 ec 04             	sub    $0x4,%esp
  8018a3:	68 3a 44 80 00       	push   $0x80443a
  8018a8:	68 ee 00 00 00       	push   $0xee
  8018ad:	68 e2 43 80 00       	push   $0x8043e2
  8018b2:	e8 e1 ea ff ff       	call   800398 <_panic>

008018b7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	57                   	push   %edi
  8018bb:	56                   	push   %esi
  8018bc:	53                   	push   %ebx
  8018bd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018cf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018d2:	cd 30                	int    $0x30
  8018d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	5b                   	pop    %ebx
  8018de:	5e                   	pop    %esi
  8018df:	5f                   	pop    %edi
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018ee:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	52                   	push   %edx
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	50                   	push   %eax
  8018fe:	6a 00                	push   $0x0
  801900:	e8 b2 ff ff ff       	call   8018b7 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	90                   	nop
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_cgetc>:

int
sys_cgetc(void)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 02                	push   $0x2
  80191a:	e8 98 ff ff ff       	call   8018b7 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 03                	push   $0x3
  801933:	e8 7f ff ff ff       	call   8018b7 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	90                   	nop
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 04                	push   $0x4
  80194d:	e8 65 ff ff ff       	call   8018b7 <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	90                   	nop
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80195b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	52                   	push   %edx
  801968:	50                   	push   %eax
  801969:	6a 08                	push   $0x8
  80196b:	e8 47 ff ff ff       	call   8018b7 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	56                   	push   %esi
  801979:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80197a:	8b 75 18             	mov    0x18(%ebp),%esi
  80197d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801980:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	56                   	push   %esi
  80198a:	53                   	push   %ebx
  80198b:	51                   	push   %ecx
  80198c:	52                   	push   %edx
  80198d:	50                   	push   %eax
  80198e:	6a 09                	push   $0x9
  801990:	e8 22 ff ff ff       	call   8018b7 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199b:	5b                   	pop    %ebx
  80199c:	5e                   	pop    %esi
  80199d:	5d                   	pop    %ebp
  80199e:	c3                   	ret    

0080199f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	52                   	push   %edx
  8019af:	50                   	push   %eax
  8019b0:	6a 0a                	push   $0xa
  8019b2:	e8 00 ff ff ff       	call   8018b7 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	ff 75 08             	pushl  0x8(%ebp)
  8019cb:	6a 0b                	push   $0xb
  8019cd:	e8 e5 fe ff ff       	call   8018b7 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 0c                	push   $0xc
  8019e6:	e8 cc fe ff ff       	call   8018b7 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 0d                	push   $0xd
  8019ff:	e8 b3 fe ff ff       	call   8018b7 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 0e                	push   $0xe
  801a18:	e8 9a fe ff ff       	call   8018b7 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 0f                	push   $0xf
  801a31:	e8 81 fe ff ff       	call   8018b7 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	ff 75 08             	pushl  0x8(%ebp)
  801a49:	6a 10                	push   $0x10
  801a4b:	e8 67 fe ff ff       	call   8018b7 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 11                	push   $0x11
  801a64:	e8 4e fe ff ff       	call   8018b7 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	90                   	nop
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_cputc>:

void
sys_cputc(const char c)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a7b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	50                   	push   %eax
  801a88:	6a 01                	push   $0x1
  801a8a:	e8 28 fe ff ff       	call   8018b7 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	90                   	nop
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 14                	push   $0x14
  801aa4:	e8 0e fe ff ff       	call   8018b7 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801abb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801abe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	6a 00                	push   $0x0
  801ac7:	51                   	push   %ecx
  801ac8:	52                   	push   %edx
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	50                   	push   %eax
  801acd:	6a 15                	push   $0x15
  801acf:	e8 e3 fd ff ff       	call   8018b7 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801adc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	52                   	push   %edx
  801ae9:	50                   	push   %eax
  801aea:	6a 16                	push   $0x16
  801aec:	e8 c6 fd ff ff       	call   8018b7 <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801af9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	51                   	push   %ecx
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 17                	push   $0x17
  801b0b:	e8 a7 fd ff ff       	call   8018b7 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	52                   	push   %edx
  801b25:	50                   	push   %eax
  801b26:	6a 18                	push   $0x18
  801b28:	e8 8a fd ff ff       	call   8018b7 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	ff 75 14             	pushl  0x14(%ebp)
  801b3d:	ff 75 10             	pushl  0x10(%ebp)
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	50                   	push   %eax
  801b44:	6a 19                	push   $0x19
  801b46:	e8 6c fd ff ff       	call   8018b7 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	50                   	push   %eax
  801b5f:	6a 1a                	push   $0x1a
  801b61:	e8 51 fd ff ff       	call   8018b7 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	90                   	nop
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	50                   	push   %eax
  801b7b:	6a 1b                	push   $0x1b
  801b7d:	e8 35 fd ff ff       	call   8018b7 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 05                	push   $0x5
  801b96:	e8 1c fd ff ff       	call   8018b7 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 06                	push   $0x6
  801baf:	e8 03 fd ff ff       	call   8018b7 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 07                	push   $0x7
  801bc8:	e8 ea fc ff ff       	call   8018b7 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 1c                	push   $0x1c
  801be1:	e8 d1 fc ff ff       	call   8018b7 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	90                   	nop
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf5:	8d 50 04             	lea    0x4(%eax),%edx
  801bf8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	52                   	push   %edx
  801c02:	50                   	push   %eax
  801c03:	6a 1d                	push   $0x1d
  801c05:	e8 ad fc ff ff       	call   8018b7 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c16:	89 01                	mov    %eax,(%ecx)
  801c18:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	c9                   	leave  
  801c1f:	c2 04 00             	ret    $0x4

00801c22 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	ff 75 10             	pushl  0x10(%ebp)
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	6a 13                	push   $0x13
  801c34:	e8 7e fc ff ff       	call   8018b7 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3c:	90                   	nop
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 1e                	push   $0x1e
  801c4e:	e8 64 fc ff ff       	call   8018b7 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c64:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	50                   	push   %eax
  801c71:	6a 1f                	push   $0x1f
  801c73:	e8 3f fc ff ff       	call   8018b7 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7b:	90                   	nop
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <rsttst>:
void rsttst()
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 21                	push   $0x21
  801c8d:	e8 25 fc ff ff       	call   8018b7 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
	return ;
  801c95:	90                   	nop
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ca4:	8b 55 18             	mov    0x18(%ebp),%edx
  801ca7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cab:	52                   	push   %edx
  801cac:	50                   	push   %eax
  801cad:	ff 75 10             	pushl  0x10(%ebp)
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	ff 75 08             	pushl  0x8(%ebp)
  801cb6:	6a 20                	push   $0x20
  801cb8:	e8 fa fb ff ff       	call   8018b7 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc0:	90                   	nop
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <chktst>:
void chktst(uint32 n)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	ff 75 08             	pushl  0x8(%ebp)
  801cd1:	6a 22                	push   $0x22
  801cd3:	e8 df fb ff ff       	call   8018b7 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdb:	90                   	nop
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <inctst>:

void inctst()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 23                	push   $0x23
  801ced:	e8 c5 fb ff ff       	call   8018b7 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf5:	90                   	nop
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <gettst>:
uint32 gettst()
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 24                	push   $0x24
  801d07:	e8 ab fb ff ff       	call   8018b7 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 25                	push   $0x25
  801d23:	e8 8f fb ff ff       	call   8018b7 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
  801d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d2e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d32:	75 07                	jne    801d3b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d34:	b8 01 00 00 00       	mov    $0x1,%eax
  801d39:	eb 05                	jmp    801d40 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 25                	push   $0x25
  801d54:	e8 5e fb ff ff       	call   8018b7 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
  801d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d5f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d63:	75 07                	jne    801d6c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d65:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6a:	eb 05                	jmp    801d71 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 25                	push   $0x25
  801d85:	e8 2d fb ff ff       	call   8018b7 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
  801d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d90:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d94:	75 07                	jne    801d9d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d96:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9b:	eb 05                	jmp    801da2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 25                	push   $0x25
  801db6:	e8 fc fa ff ff       	call   8018b7 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
  801dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dc1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dc5:	75 07                	jne    801dce <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcc:	eb 05                	jmp    801dd3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	6a 26                	push   $0x26
  801de5:	e8 cd fa ff ff       	call   8018b7 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ded:	90                   	nop
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801df4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	6a 00                	push   $0x0
  801e02:	53                   	push   %ebx
  801e03:	51                   	push   %ecx
  801e04:	52                   	push   %edx
  801e05:	50                   	push   %eax
  801e06:	6a 27                	push   $0x27
  801e08:	e8 aa fa ff ff       	call   8018b7 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
}
  801e10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	52                   	push   %edx
  801e25:	50                   	push   %eax
  801e26:	6a 28                	push   $0x28
  801e28:	e8 8a fa ff ff       	call   8018b7 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e35:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	6a 00                	push   $0x0
  801e40:	51                   	push   %ecx
  801e41:	ff 75 10             	pushl  0x10(%ebp)
  801e44:	52                   	push   %edx
  801e45:	50                   	push   %eax
  801e46:	6a 29                	push   $0x29
  801e48:	e8 6a fa ff ff       	call   8018b7 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	ff 75 10             	pushl  0x10(%ebp)
  801e5c:	ff 75 0c             	pushl  0xc(%ebp)
  801e5f:	ff 75 08             	pushl  0x8(%ebp)
  801e62:	6a 12                	push   $0x12
  801e64:	e8 4e fa ff ff       	call   8018b7 <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6c:	90                   	nop
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	52                   	push   %edx
  801e7f:	50                   	push   %eax
  801e80:	6a 2a                	push   $0x2a
  801e82:	e8 30 fa ff ff       	call   8018b7 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
	return;
  801e8a:	90                   	nop
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	50                   	push   %eax
  801e9c:	6a 2b                	push   $0x2b
  801e9e:	e8 14 fa ff ff       	call   8018b7 <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	ff 75 0c             	pushl  0xc(%ebp)
  801eb4:	ff 75 08             	pushl  0x8(%ebp)
  801eb7:	6a 2c                	push   $0x2c
  801eb9:	e8 f9 f9 ff ff       	call   8018b7 <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
	return;
  801ec1:	90                   	nop
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	ff 75 08             	pushl  0x8(%ebp)
  801ed3:	6a 2d                	push   $0x2d
  801ed5:	e8 dd f9 ff ff       	call   8018b7 <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
	return;
  801edd:	90                   	nop
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	83 e8 04             	sub    $0x4,%eax
  801eec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801eef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef2:	8b 00                	mov    (%eax),%eax
  801ef4:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	83 e8 04             	sub    $0x4,%eax
  801f05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f0b:	8b 00                	mov    (%eax),%eax
  801f0d:	83 e0 01             	and    $0x1,%eax
  801f10:	85 c0                	test   %eax,%eax
  801f12:	0f 94 c0             	sete   %al
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f27:	83 f8 02             	cmp    $0x2,%eax
  801f2a:	74 2b                	je     801f57 <alloc_block+0x40>
  801f2c:	83 f8 02             	cmp    $0x2,%eax
  801f2f:	7f 07                	jg     801f38 <alloc_block+0x21>
  801f31:	83 f8 01             	cmp    $0x1,%eax
  801f34:	74 0e                	je     801f44 <alloc_block+0x2d>
  801f36:	eb 58                	jmp    801f90 <alloc_block+0x79>
  801f38:	83 f8 03             	cmp    $0x3,%eax
  801f3b:	74 2d                	je     801f6a <alloc_block+0x53>
  801f3d:	83 f8 04             	cmp    $0x4,%eax
  801f40:	74 3b                	je     801f7d <alloc_block+0x66>
  801f42:	eb 4c                	jmp    801f90 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	ff 75 08             	pushl  0x8(%ebp)
  801f4a:	e8 11 03 00 00       	call   802260 <alloc_block_FF>
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f55:	eb 4a                	jmp    801fa1 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f57:	83 ec 0c             	sub    $0xc,%esp
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	e8 fa 19 00 00       	call   80395c <alloc_block_NF>
  801f62:	83 c4 10             	add    $0x10,%esp
  801f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f68:	eb 37                	jmp    801fa1 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f6a:	83 ec 0c             	sub    $0xc,%esp
  801f6d:	ff 75 08             	pushl  0x8(%ebp)
  801f70:	e8 a7 07 00 00       	call   80271c <alloc_block_BF>
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f7b:	eb 24                	jmp    801fa1 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	ff 75 08             	pushl  0x8(%ebp)
  801f83:	e8 b7 19 00 00       	call   80393f <alloc_block_WF>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f8e:	eb 11                	jmp    801fa1 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f90:	83 ec 0c             	sub    $0xc,%esp
  801f93:	68 4c 44 80 00       	push   $0x80444c
  801f98:	e8 b8 e6 ff ff       	call   800655 <cprintf>
  801f9d:	83 c4 10             	add    $0x10,%esp
		break;
  801fa0:	90                   	nop
	}
	return va;
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	53                   	push   %ebx
  801faa:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fad:	83 ec 0c             	sub    $0xc,%esp
  801fb0:	68 6c 44 80 00       	push   $0x80446c
  801fb5:	e8 9b e6 ff ff       	call   800655 <cprintf>
  801fba:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	68 97 44 80 00       	push   $0x804497
  801fc5:	e8 8b e6 ff ff       	call   800655 <cprintf>
  801fca:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd3:	eb 37                	jmp    80200c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdb:	e8 19 ff ff ff       	call   801ef9 <is_free_block>
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	0f be d8             	movsbl %al,%ebx
  801fe6:	83 ec 0c             	sub    $0xc,%esp
  801fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fec:	e8 ef fe ff ff       	call   801ee0 <get_block_size>
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	53                   	push   %ebx
  801ff8:	50                   	push   %eax
  801ff9:	68 af 44 80 00       	push   $0x8044af
  801ffe:	e8 52 e6 ff ff       	call   800655 <cprintf>
  802003:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802006:	8b 45 10             	mov    0x10(%ebp),%eax
  802009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802010:	74 07                	je     802019 <print_blocks_list+0x73>
  802012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802015:	8b 00                	mov    (%eax),%eax
  802017:	eb 05                	jmp    80201e <print_blocks_list+0x78>
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
  80201e:	89 45 10             	mov    %eax,0x10(%ebp)
  802021:	8b 45 10             	mov    0x10(%ebp),%eax
  802024:	85 c0                	test   %eax,%eax
  802026:	75 ad                	jne    801fd5 <print_blocks_list+0x2f>
  802028:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202c:	75 a7                	jne    801fd5 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80202e:	83 ec 0c             	sub    $0xc,%esp
  802031:	68 6c 44 80 00       	push   $0x80446c
  802036:	e8 1a e6 ff ff       	call   800655 <cprintf>
  80203b:	83 c4 10             	add    $0x10,%esp

}
  80203e:	90                   	nop
  80203f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80204a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204d:	83 e0 01             	and    $0x1,%eax
  802050:	85 c0                	test   %eax,%eax
  802052:	74 03                	je     802057 <initialize_dynamic_allocator+0x13>
  802054:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802057:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80205b:	0f 84 c7 01 00 00    	je     802228 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802061:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802068:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80206b:	8b 55 08             	mov    0x8(%ebp),%edx
  80206e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802071:	01 d0                	add    %edx,%eax
  802073:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802078:	0f 87 ad 01 00 00    	ja     80222b <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	85 c0                	test   %eax,%eax
  802083:	0f 89 a5 01 00 00    	jns    80222e <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802089:	8b 55 08             	mov    0x8(%ebp),%edx
  80208c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208f:	01 d0                	add    %edx,%eax
  802091:	83 e8 04             	sub    $0x4,%eax
  802094:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020a0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a8:	e9 87 00 00 00       	jmp    802134 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b1:	75 14                	jne    8020c7 <initialize_dynamic_allocator+0x83>
  8020b3:	83 ec 04             	sub    $0x4,%esp
  8020b6:	68 c7 44 80 00       	push   $0x8044c7
  8020bb:	6a 79                	push   $0x79
  8020bd:	68 e5 44 80 00       	push   $0x8044e5
  8020c2:	e8 d1 e2 ff ff       	call   800398 <_panic>
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	8b 00                	mov    (%eax),%eax
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	74 10                	je     8020e0 <initialize_dynamic_allocator+0x9c>
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	8b 00                	mov    (%eax),%eax
  8020d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d8:	8b 52 04             	mov    0x4(%edx),%edx
  8020db:	89 50 04             	mov    %edx,0x4(%eax)
  8020de:	eb 0b                	jmp    8020eb <initialize_dynamic_allocator+0xa7>
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	8b 40 04             	mov    0x4(%eax),%eax
  8020e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 40 04             	mov    0x4(%eax),%eax
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	74 0f                	je     802104 <initialize_dynamic_allocator+0xc0>
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	8b 40 04             	mov    0x4(%eax),%eax
  8020fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fe:	8b 12                	mov    (%edx),%edx
  802100:	89 10                	mov    %edx,(%eax)
  802102:	eb 0a                	jmp    80210e <initialize_dynamic_allocator+0xca>
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	8b 00                	mov    (%eax),%eax
  802109:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802121:	a1 38 50 80 00       	mov    0x805038,%eax
  802126:	48                   	dec    %eax
  802127:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80212c:	a1 34 50 80 00       	mov    0x805034,%eax
  802131:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802134:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802138:	74 07                	je     802141 <initialize_dynamic_allocator+0xfd>
  80213a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	eb 05                	jmp    802146 <initialize_dynamic_allocator+0x102>
  802141:	b8 00 00 00 00       	mov    $0x0,%eax
  802146:	a3 34 50 80 00       	mov    %eax,0x805034
  80214b:	a1 34 50 80 00       	mov    0x805034,%eax
  802150:	85 c0                	test   %eax,%eax
  802152:	0f 85 55 ff ff ff    	jne    8020ad <initialize_dynamic_allocator+0x69>
  802158:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215c:	0f 85 4b ff ff ff    	jne    8020ad <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802171:	a1 44 50 80 00       	mov    0x805044,%eax
  802176:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80217b:	a1 40 50 80 00       	mov    0x805040,%eax
  802180:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	83 c0 08             	add    $0x8,%eax
  80218c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	83 c0 04             	add    $0x4,%eax
  802195:	8b 55 0c             	mov    0xc(%ebp),%edx
  802198:	83 ea 08             	sub    $0x8,%edx
  80219b:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80219d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	01 d0                	add    %edx,%eax
  8021a5:	83 e8 08             	sub    $0x8,%eax
  8021a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ab:	83 ea 08             	sub    $0x8,%edx
  8021ae:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021c7:	75 17                	jne    8021e0 <initialize_dynamic_allocator+0x19c>
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	68 00 45 80 00       	push   $0x804500
  8021d1:	68 90 00 00 00       	push   $0x90
  8021d6:	68 e5 44 80 00       	push   $0x8044e5
  8021db:	e8 b8 e1 ff ff       	call   800398 <_panic>
  8021e0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e9:	89 10                	mov    %edx,(%eax)
  8021eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	74 0d                	je     802201 <initialize_dynamic_allocator+0x1bd>
  8021f4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021fc:	89 50 04             	mov    %edx,0x4(%eax)
  8021ff:	eb 08                	jmp    802209 <initialize_dynamic_allocator+0x1c5>
  802201:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802204:	a3 30 50 80 00       	mov    %eax,0x805030
  802209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802214:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80221b:	a1 38 50 80 00       	mov    0x805038,%eax
  802220:	40                   	inc    %eax
  802221:	a3 38 50 80 00       	mov    %eax,0x805038
  802226:	eb 07                	jmp    80222f <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802228:	90                   	nop
  802229:	eb 04                	jmp    80222f <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80222b:	90                   	nop
  80222c:	eb 01                	jmp    80222f <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80222e:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802234:	8b 45 10             	mov    0x10(%ebp),%eax
  802237:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802240:	8b 45 0c             	mov    0xc(%ebp),%eax
  802243:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	83 e8 04             	sub    $0x4,%eax
  80224b:	8b 00                	mov    (%eax),%eax
  80224d:	83 e0 fe             	and    $0xfffffffe,%eax
  802250:	8d 50 f8             	lea    -0x8(%eax),%edx
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	01 c2                	add    %eax,%edx
  802258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225b:	89 02                	mov    %eax,(%edx)
}
  80225d:	90                   	nop
  80225e:	5d                   	pop    %ebp
  80225f:	c3                   	ret    

00802260 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	83 e0 01             	and    $0x1,%eax
  80226c:	85 c0                	test   %eax,%eax
  80226e:	74 03                	je     802273 <alloc_block_FF+0x13>
  802270:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802273:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802277:	77 07                	ja     802280 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802279:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802280:	a1 24 50 80 00       	mov    0x805024,%eax
  802285:	85 c0                	test   %eax,%eax
  802287:	75 73                	jne    8022fc <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	83 c0 10             	add    $0x10,%eax
  80228f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802292:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802299:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80229c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229f:	01 d0                	add    %edx,%eax
  8022a1:	48                   	dec    %eax
  8022a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ad:	f7 75 ec             	divl   -0x14(%ebp)
  8022b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b3:	29 d0                	sub    %edx,%eax
  8022b5:	c1 e8 0c             	shr    $0xc,%eax
  8022b8:	83 ec 0c             	sub    $0xc,%esp
  8022bb:	50                   	push   %eax
  8022bc:	e8 2e f1 ff ff       	call   8013ef <sbrk>
  8022c1:	83 c4 10             	add    $0x10,%esp
  8022c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8022c7:	83 ec 0c             	sub    $0xc,%esp
  8022ca:	6a 00                	push   $0x0
  8022cc:	e8 1e f1 ff ff       	call   8013ef <sbrk>
  8022d1:	83 c4 10             	add    $0x10,%esp
  8022d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8022d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022da:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8022dd:	83 ec 08             	sub    $0x8,%esp
  8022e0:	50                   	push   %eax
  8022e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022e4:	e8 5b fd ff ff       	call   802044 <initialize_dynamic_allocator>
  8022e9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022ec:	83 ec 0c             	sub    $0xc,%esp
  8022ef:	68 23 45 80 00       	push   $0x804523
  8022f4:	e8 5c e3 ff ff       	call   800655 <cprintf>
  8022f9:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802300:	75 0a                	jne    80230c <alloc_block_FF+0xac>
	        return NULL;
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
  802307:	e9 0e 04 00 00       	jmp    80271a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80230c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802313:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231b:	e9 f3 02 00 00       	jmp    802613 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802326:	83 ec 0c             	sub    $0xc,%esp
  802329:	ff 75 bc             	pushl  -0x44(%ebp)
  80232c:	e8 af fb ff ff       	call   801ee0 <get_block_size>
  802331:	83 c4 10             	add    $0x10,%esp
  802334:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	83 c0 08             	add    $0x8,%eax
  80233d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802340:	0f 87 c5 02 00 00    	ja     80260b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	83 c0 18             	add    $0x18,%eax
  80234c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80234f:	0f 87 19 02 00 00    	ja     80256e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802355:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802358:	2b 45 08             	sub    0x8(%ebp),%eax
  80235b:	83 e8 08             	sub    $0x8,%eax
  80235e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	8d 50 08             	lea    0x8(%eax),%edx
  802367:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80236a:	01 d0                	add    %edx,%eax
  80236c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	83 c0 08             	add    $0x8,%eax
  802375:	83 ec 04             	sub    $0x4,%esp
  802378:	6a 01                	push   $0x1
  80237a:	50                   	push   %eax
  80237b:	ff 75 bc             	pushl  -0x44(%ebp)
  80237e:	e8 ae fe ff ff       	call   802231 <set_block_data>
  802383:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 40 04             	mov    0x4(%eax),%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	75 68                	jne    8023f8 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802390:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802394:	75 17                	jne    8023ad <alloc_block_FF+0x14d>
  802396:	83 ec 04             	sub    $0x4,%esp
  802399:	68 00 45 80 00       	push   $0x804500
  80239e:	68 d7 00 00 00       	push   $0xd7
  8023a3:	68 e5 44 80 00       	push   $0x8044e5
  8023a8:	e8 eb df ff ff       	call   800398 <_panic>
  8023ad:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b6:	89 10                	mov    %edx,(%eax)
  8023b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023bb:	8b 00                	mov    (%eax),%eax
  8023bd:	85 c0                	test   %eax,%eax
  8023bf:	74 0d                	je     8023ce <alloc_block_FF+0x16e>
  8023c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023c6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023c9:	89 50 04             	mov    %edx,0x4(%eax)
  8023cc:	eb 08                	jmp    8023d6 <alloc_block_FF+0x176>
  8023ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8023d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8023ed:	40                   	inc    %eax
  8023ee:	a3 38 50 80 00       	mov    %eax,0x805038
  8023f3:	e9 dc 00 00 00       	jmp    8024d4 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fb:	8b 00                	mov    (%eax),%eax
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	75 65                	jne    802466 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802401:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802405:	75 17                	jne    80241e <alloc_block_FF+0x1be>
  802407:	83 ec 04             	sub    $0x4,%esp
  80240a:	68 34 45 80 00       	push   $0x804534
  80240f:	68 db 00 00 00       	push   $0xdb
  802414:	68 e5 44 80 00       	push   $0x8044e5
  802419:	e8 7a df ff ff       	call   800398 <_panic>
  80241e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802424:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802427:	89 50 04             	mov    %edx,0x4(%eax)
  80242a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80242d:	8b 40 04             	mov    0x4(%eax),%eax
  802430:	85 c0                	test   %eax,%eax
  802432:	74 0c                	je     802440 <alloc_block_FF+0x1e0>
  802434:	a1 30 50 80 00       	mov    0x805030,%eax
  802439:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80243c:	89 10                	mov    %edx,(%eax)
  80243e:	eb 08                	jmp    802448 <alloc_block_FF+0x1e8>
  802440:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802443:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802448:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244b:	a3 30 50 80 00       	mov    %eax,0x805030
  802450:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802453:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802459:	a1 38 50 80 00       	mov    0x805038,%eax
  80245e:	40                   	inc    %eax
  80245f:	a3 38 50 80 00       	mov    %eax,0x805038
  802464:	eb 6e                	jmp    8024d4 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246a:	74 06                	je     802472 <alloc_block_FF+0x212>
  80246c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802470:	75 17                	jne    802489 <alloc_block_FF+0x229>
  802472:	83 ec 04             	sub    $0x4,%esp
  802475:	68 58 45 80 00       	push   $0x804558
  80247a:	68 df 00 00 00       	push   $0xdf
  80247f:	68 e5 44 80 00       	push   $0x8044e5
  802484:	e8 0f df ff ff       	call   800398 <_panic>
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 10                	mov    (%eax),%edx
  80248e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802491:	89 10                	mov    %edx,(%eax)
  802493:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802496:	8b 00                	mov    (%eax),%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	74 0b                	je     8024a7 <alloc_block_FF+0x247>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024a4:	89 50 04             	mov    %edx,0x4(%eax)
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024ad:	89 10                	mov    %edx,(%eax)
  8024af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b5:	89 50 04             	mov    %edx,0x4(%eax)
  8024b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	75 08                	jne    8024c9 <alloc_block_FF+0x269>
  8024c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c4:	a3 30 50 80 00       	mov    %eax,0x805030
  8024c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8024ce:	40                   	inc    %eax
  8024cf:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8024d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d8:	75 17                	jne    8024f1 <alloc_block_FF+0x291>
  8024da:	83 ec 04             	sub    $0x4,%esp
  8024dd:	68 c7 44 80 00       	push   $0x8044c7
  8024e2:	68 e1 00 00 00       	push   $0xe1
  8024e7:	68 e5 44 80 00       	push   $0x8044e5
  8024ec:	e8 a7 de ff ff       	call   800398 <_panic>
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 00                	mov    (%eax),%eax
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	74 10                	je     80250a <alloc_block_FF+0x2aa>
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 00                	mov    (%eax),%eax
  8024ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802502:	8b 52 04             	mov    0x4(%edx),%edx
  802505:	89 50 04             	mov    %edx,0x4(%eax)
  802508:	eb 0b                	jmp    802515 <alloc_block_FF+0x2b5>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 40 04             	mov    0x4(%eax),%eax
  802510:	a3 30 50 80 00       	mov    %eax,0x805030
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 40 04             	mov    0x4(%eax),%eax
  80251b:	85 c0                	test   %eax,%eax
  80251d:	74 0f                	je     80252e <alloc_block_FF+0x2ce>
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 40 04             	mov    0x4(%eax),%eax
  802525:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802528:	8b 12                	mov    (%edx),%edx
  80252a:	89 10                	mov    %edx,(%eax)
  80252c:	eb 0a                	jmp    802538 <alloc_block_FF+0x2d8>
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	8b 00                	mov    (%eax),%eax
  802533:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80254b:	a1 38 50 80 00       	mov    0x805038,%eax
  802550:	48                   	dec    %eax
  802551:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802556:	83 ec 04             	sub    $0x4,%esp
  802559:	6a 00                	push   $0x0
  80255b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80255e:	ff 75 b0             	pushl  -0x50(%ebp)
  802561:	e8 cb fc ff ff       	call   802231 <set_block_data>
  802566:	83 c4 10             	add    $0x10,%esp
  802569:	e9 95 00 00 00       	jmp    802603 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80256e:	83 ec 04             	sub    $0x4,%esp
  802571:	6a 01                	push   $0x1
  802573:	ff 75 b8             	pushl  -0x48(%ebp)
  802576:	ff 75 bc             	pushl  -0x44(%ebp)
  802579:	e8 b3 fc ff ff       	call   802231 <set_block_data>
  80257e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802581:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802585:	75 17                	jne    80259e <alloc_block_FF+0x33e>
  802587:	83 ec 04             	sub    $0x4,%esp
  80258a:	68 c7 44 80 00       	push   $0x8044c7
  80258f:	68 e8 00 00 00       	push   $0xe8
  802594:	68 e5 44 80 00       	push   $0x8044e5
  802599:	e8 fa dd ff ff       	call   800398 <_panic>
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 00                	mov    (%eax),%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	74 10                	je     8025b7 <alloc_block_FF+0x357>
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025af:	8b 52 04             	mov    0x4(%edx),%edx
  8025b2:	89 50 04             	mov    %edx,0x4(%eax)
  8025b5:	eb 0b                	jmp    8025c2 <alloc_block_FF+0x362>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 04             	mov    0x4(%eax),%eax
  8025bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 04             	mov    0x4(%eax),%eax
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	74 0f                	je     8025db <alloc_block_FF+0x37b>
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 40 04             	mov    0x4(%eax),%eax
  8025d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d5:	8b 12                	mov    (%edx),%edx
  8025d7:	89 10                	mov    %edx,(%eax)
  8025d9:	eb 0a                	jmp    8025e5 <alloc_block_FF+0x385>
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 00                	mov    (%eax),%eax
  8025e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8025fd:	48                   	dec    %eax
  8025fe:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802603:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802606:	e9 0f 01 00 00       	jmp    80271a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80260b:	a1 34 50 80 00       	mov    0x805034,%eax
  802610:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802617:	74 07                	je     802620 <alloc_block_FF+0x3c0>
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 00                	mov    (%eax),%eax
  80261e:	eb 05                	jmp    802625 <alloc_block_FF+0x3c5>
  802620:	b8 00 00 00 00       	mov    $0x0,%eax
  802625:	a3 34 50 80 00       	mov    %eax,0x805034
  80262a:	a1 34 50 80 00       	mov    0x805034,%eax
  80262f:	85 c0                	test   %eax,%eax
  802631:	0f 85 e9 fc ff ff    	jne    802320 <alloc_block_FF+0xc0>
  802637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263b:	0f 85 df fc ff ff    	jne    802320 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802641:	8b 45 08             	mov    0x8(%ebp),%eax
  802644:	83 c0 08             	add    $0x8,%eax
  802647:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80264a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802651:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802654:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802657:	01 d0                	add    %edx,%eax
  802659:	48                   	dec    %eax
  80265a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80265d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802660:	ba 00 00 00 00       	mov    $0x0,%edx
  802665:	f7 75 d8             	divl   -0x28(%ebp)
  802668:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80266b:	29 d0                	sub    %edx,%eax
  80266d:	c1 e8 0c             	shr    $0xc,%eax
  802670:	83 ec 0c             	sub    $0xc,%esp
  802673:	50                   	push   %eax
  802674:	e8 76 ed ff ff       	call   8013ef <sbrk>
  802679:	83 c4 10             	add    $0x10,%esp
  80267c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80267f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802683:	75 0a                	jne    80268f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802685:	b8 00 00 00 00       	mov    $0x0,%eax
  80268a:	e9 8b 00 00 00       	jmp    80271a <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80268f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802696:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802699:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80269c:	01 d0                	add    %edx,%eax
  80269e:	48                   	dec    %eax
  80269f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8026aa:	f7 75 cc             	divl   -0x34(%ebp)
  8026ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026b0:	29 d0                	sub    %edx,%eax
  8026b2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026b8:	01 d0                	add    %edx,%eax
  8026ba:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026bf:	a1 40 50 80 00       	mov    0x805040,%eax
  8026c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8026ca:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8026d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026d7:	01 d0                	add    %edx,%eax
  8026d9:	48                   	dec    %eax
  8026da:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026dd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e5:	f7 75 c4             	divl   -0x3c(%ebp)
  8026e8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026eb:	29 d0                	sub    %edx,%eax
  8026ed:	83 ec 04             	sub    $0x4,%esp
  8026f0:	6a 01                	push   $0x1
  8026f2:	50                   	push   %eax
  8026f3:	ff 75 d0             	pushl  -0x30(%ebp)
  8026f6:	e8 36 fb ff ff       	call   802231 <set_block_data>
  8026fb:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026fe:	83 ec 0c             	sub    $0xc,%esp
  802701:	ff 75 d0             	pushl  -0x30(%ebp)
  802704:	e8 1b 0a 00 00       	call   803124 <free_block>
  802709:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80270c:	83 ec 0c             	sub    $0xc,%esp
  80270f:	ff 75 08             	pushl  0x8(%ebp)
  802712:	e8 49 fb ff ff       	call   802260 <alloc_block_FF>
  802717:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80271a:	c9                   	leave  
  80271b:	c3                   	ret    

0080271c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
  80271f:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802722:	8b 45 08             	mov    0x8(%ebp),%eax
  802725:	83 e0 01             	and    $0x1,%eax
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 03                	je     80272f <alloc_block_BF+0x13>
  80272c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80272f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802733:	77 07                	ja     80273c <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802735:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80273c:	a1 24 50 80 00       	mov    0x805024,%eax
  802741:	85 c0                	test   %eax,%eax
  802743:	75 73                	jne    8027b8 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802745:	8b 45 08             	mov    0x8(%ebp),%eax
  802748:	83 c0 10             	add    $0x10,%eax
  80274b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80274e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80275b:	01 d0                	add    %edx,%eax
  80275d:	48                   	dec    %eax
  80275e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802761:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802764:	ba 00 00 00 00       	mov    $0x0,%edx
  802769:	f7 75 e0             	divl   -0x20(%ebp)
  80276c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80276f:	29 d0                	sub    %edx,%eax
  802771:	c1 e8 0c             	shr    $0xc,%eax
  802774:	83 ec 0c             	sub    $0xc,%esp
  802777:	50                   	push   %eax
  802778:	e8 72 ec ff ff       	call   8013ef <sbrk>
  80277d:	83 c4 10             	add    $0x10,%esp
  802780:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802783:	83 ec 0c             	sub    $0xc,%esp
  802786:	6a 00                	push   $0x0
  802788:	e8 62 ec ff ff       	call   8013ef <sbrk>
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802793:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802796:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802799:	83 ec 08             	sub    $0x8,%esp
  80279c:	50                   	push   %eax
  80279d:	ff 75 d8             	pushl  -0x28(%ebp)
  8027a0:	e8 9f f8 ff ff       	call   802044 <initialize_dynamic_allocator>
  8027a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027a8:	83 ec 0c             	sub    $0xc,%esp
  8027ab:	68 23 45 80 00       	push   $0x804523
  8027b0:	e8 a0 de ff ff       	call   800655 <cprintf>
  8027b5:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8027c6:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8027d4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027dc:	e9 1d 01 00 00       	jmp    8028fe <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027e7:	83 ec 0c             	sub    $0xc,%esp
  8027ea:	ff 75 a8             	pushl  -0x58(%ebp)
  8027ed:	e8 ee f6 ff ff       	call   801ee0 <get_block_size>
  8027f2:	83 c4 10             	add    $0x10,%esp
  8027f5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	83 c0 08             	add    $0x8,%eax
  8027fe:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802801:	0f 87 ef 00 00 00    	ja     8028f6 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802807:	8b 45 08             	mov    0x8(%ebp),%eax
  80280a:	83 c0 18             	add    $0x18,%eax
  80280d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802810:	77 1d                	ja     80282f <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802815:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802818:	0f 86 d8 00 00 00    	jbe    8028f6 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80281e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802821:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802824:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802827:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80282a:	e9 c7 00 00 00       	jmp    8028f6 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80282f:	8b 45 08             	mov    0x8(%ebp),%eax
  802832:	83 c0 08             	add    $0x8,%eax
  802835:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802838:	0f 85 9d 00 00 00    	jne    8028db <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80283e:	83 ec 04             	sub    $0x4,%esp
  802841:	6a 01                	push   $0x1
  802843:	ff 75 a4             	pushl  -0x5c(%ebp)
  802846:	ff 75 a8             	pushl  -0x58(%ebp)
  802849:	e8 e3 f9 ff ff       	call   802231 <set_block_data>
  80284e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	75 17                	jne    80286e <alloc_block_BF+0x152>
  802857:	83 ec 04             	sub    $0x4,%esp
  80285a:	68 c7 44 80 00       	push   $0x8044c7
  80285f:	68 2c 01 00 00       	push   $0x12c
  802864:	68 e5 44 80 00       	push   $0x8044e5
  802869:	e8 2a db ff ff       	call   800398 <_panic>
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 00                	mov    (%eax),%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	74 10                	je     802887 <alloc_block_BF+0x16b>
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287f:	8b 52 04             	mov    0x4(%edx),%edx
  802882:	89 50 04             	mov    %edx,0x4(%eax)
  802885:	eb 0b                	jmp    802892 <alloc_block_BF+0x176>
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 40 04             	mov    0x4(%eax),%eax
  80288d:	a3 30 50 80 00       	mov    %eax,0x805030
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 40 04             	mov    0x4(%eax),%eax
  802898:	85 c0                	test   %eax,%eax
  80289a:	74 0f                	je     8028ab <alloc_block_BF+0x18f>
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a5:	8b 12                	mov    (%edx),%edx
  8028a7:	89 10                	mov    %edx,(%eax)
  8028a9:	eb 0a                	jmp    8028b5 <alloc_block_BF+0x199>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8028cd:	48                   	dec    %eax
  8028ce:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8028d3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028d6:	e9 24 04 00 00       	jmp    802cff <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8028db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028de:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028e1:	76 13                	jbe    8028f6 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8028e3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028ea:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8028f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028f3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8028f6:	a1 34 50 80 00       	mov    0x805034,%eax
  8028fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802902:	74 07                	je     80290b <alloc_block_BF+0x1ef>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	eb 05                	jmp    802910 <alloc_block_BF+0x1f4>
  80290b:	b8 00 00 00 00       	mov    $0x0,%eax
  802910:	a3 34 50 80 00       	mov    %eax,0x805034
  802915:	a1 34 50 80 00       	mov    0x805034,%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	0f 85 bf fe ff ff    	jne    8027e1 <alloc_block_BF+0xc5>
  802922:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802926:	0f 85 b5 fe ff ff    	jne    8027e1 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80292c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802930:	0f 84 26 02 00 00    	je     802b5c <alloc_block_BF+0x440>
  802936:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80293a:	0f 85 1c 02 00 00    	jne    802b5c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802940:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802943:	2b 45 08             	sub    0x8(%ebp),%eax
  802946:	83 e8 08             	sub    $0x8,%eax
  802949:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	8d 50 08             	lea    0x8(%eax),%edx
  802952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802955:	01 d0                	add    %edx,%eax
  802957:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80295a:	8b 45 08             	mov    0x8(%ebp),%eax
  80295d:	83 c0 08             	add    $0x8,%eax
  802960:	83 ec 04             	sub    $0x4,%esp
  802963:	6a 01                	push   $0x1
  802965:	50                   	push   %eax
  802966:	ff 75 f0             	pushl  -0x10(%ebp)
  802969:	e8 c3 f8 ff ff       	call   802231 <set_block_data>
  80296e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802974:	8b 40 04             	mov    0x4(%eax),%eax
  802977:	85 c0                	test   %eax,%eax
  802979:	75 68                	jne    8029e3 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80297b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80297f:	75 17                	jne    802998 <alloc_block_BF+0x27c>
  802981:	83 ec 04             	sub    $0x4,%esp
  802984:	68 00 45 80 00       	push   $0x804500
  802989:	68 45 01 00 00       	push   $0x145
  80298e:	68 e5 44 80 00       	push   $0x8044e5
  802993:	e8 00 da ff ff       	call   800398 <_panic>
  802998:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80299e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a1:	89 10                	mov    %edx,(%eax)
  8029a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	74 0d                	je     8029b9 <alloc_block_BF+0x29d>
  8029ac:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029b1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029b4:	89 50 04             	mov    %edx,0x4(%eax)
  8029b7:	eb 08                	jmp    8029c1 <alloc_block_BF+0x2a5>
  8029b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8029c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d3:	a1 38 50 80 00       	mov    0x805038,%eax
  8029d8:	40                   	inc    %eax
  8029d9:	a3 38 50 80 00       	mov    %eax,0x805038
  8029de:	e9 dc 00 00 00       	jmp    802abf <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8029e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e6:	8b 00                	mov    (%eax),%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	75 65                	jne    802a51 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029ec:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029f0:	75 17                	jne    802a09 <alloc_block_BF+0x2ed>
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	68 34 45 80 00       	push   $0x804534
  8029fa:	68 4a 01 00 00       	push   $0x14a
  8029ff:	68 e5 44 80 00       	push   $0x8044e5
  802a04:	e8 8f d9 ff ff       	call   800398 <_panic>
  802a09:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a12:	89 50 04             	mov    %edx,0x4(%eax)
  802a15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a18:	8b 40 04             	mov    0x4(%eax),%eax
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	74 0c                	je     802a2b <alloc_block_BF+0x30f>
  802a1f:	a1 30 50 80 00       	mov    0x805030,%eax
  802a24:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a27:	89 10                	mov    %edx,(%eax)
  802a29:	eb 08                	jmp    802a33 <alloc_block_BF+0x317>
  802a2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a33:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a36:	a3 30 50 80 00       	mov    %eax,0x805030
  802a3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a44:	a1 38 50 80 00       	mov    0x805038,%eax
  802a49:	40                   	inc    %eax
  802a4a:	a3 38 50 80 00       	mov    %eax,0x805038
  802a4f:	eb 6e                	jmp    802abf <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a55:	74 06                	je     802a5d <alloc_block_BF+0x341>
  802a57:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a5b:	75 17                	jne    802a74 <alloc_block_BF+0x358>
  802a5d:	83 ec 04             	sub    $0x4,%esp
  802a60:	68 58 45 80 00       	push   $0x804558
  802a65:	68 4f 01 00 00       	push   $0x14f
  802a6a:	68 e5 44 80 00       	push   $0x8044e5
  802a6f:	e8 24 d9 ff ff       	call   800398 <_panic>
  802a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a77:	8b 10                	mov    (%eax),%edx
  802a79:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7c:	89 10                	mov    %edx,(%eax)
  802a7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	74 0b                	je     802a92 <alloc_block_BF+0x376>
  802a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a8f:	89 50 04             	mov    %edx,0x4(%eax)
  802a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a95:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a98:	89 10                	mov    %edx,(%eax)
  802a9a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa0:	89 50 04             	mov    %edx,0x4(%eax)
  802aa3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa6:	8b 00                	mov    (%eax),%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	75 08                	jne    802ab4 <alloc_block_BF+0x398>
  802aac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aaf:	a3 30 50 80 00       	mov    %eax,0x805030
  802ab4:	a1 38 50 80 00       	mov    0x805038,%eax
  802ab9:	40                   	inc    %eax
  802aba:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802abf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac3:	75 17                	jne    802adc <alloc_block_BF+0x3c0>
  802ac5:	83 ec 04             	sub    $0x4,%esp
  802ac8:	68 c7 44 80 00       	push   $0x8044c7
  802acd:	68 51 01 00 00       	push   $0x151
  802ad2:	68 e5 44 80 00       	push   $0x8044e5
  802ad7:	e8 bc d8 ff ff       	call   800398 <_panic>
  802adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	74 10                	je     802af5 <alloc_block_BF+0x3d9>
  802ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aed:	8b 52 04             	mov    0x4(%edx),%edx
  802af0:	89 50 04             	mov    %edx,0x4(%eax)
  802af3:	eb 0b                	jmp    802b00 <alloc_block_BF+0x3e4>
  802af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af8:	8b 40 04             	mov    0x4(%eax),%eax
  802afb:	a3 30 50 80 00       	mov    %eax,0x805030
  802b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b03:	8b 40 04             	mov    0x4(%eax),%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	74 0f                	je     802b19 <alloc_block_BF+0x3fd>
  802b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0d:	8b 40 04             	mov    0x4(%eax),%eax
  802b10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b13:	8b 12                	mov    (%edx),%edx
  802b15:	89 10                	mov    %edx,(%eax)
  802b17:	eb 0a                	jmp    802b23 <alloc_block_BF+0x407>
  802b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1c:	8b 00                	mov    (%eax),%eax
  802b1e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b36:	a1 38 50 80 00       	mov    0x805038,%eax
  802b3b:	48                   	dec    %eax
  802b3c:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b41:	83 ec 04             	sub    $0x4,%esp
  802b44:	6a 00                	push   $0x0
  802b46:	ff 75 d0             	pushl  -0x30(%ebp)
  802b49:	ff 75 cc             	pushl  -0x34(%ebp)
  802b4c:	e8 e0 f6 ff ff       	call   802231 <set_block_data>
  802b51:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	e9 a3 01 00 00       	jmp    802cff <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b5c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b60:	0f 85 9d 00 00 00    	jne    802c03 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b66:	83 ec 04             	sub    $0x4,%esp
  802b69:	6a 01                	push   $0x1
  802b6b:	ff 75 ec             	pushl  -0x14(%ebp)
  802b6e:	ff 75 f0             	pushl  -0x10(%ebp)
  802b71:	e8 bb f6 ff ff       	call   802231 <set_block_data>
  802b76:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7d:	75 17                	jne    802b96 <alloc_block_BF+0x47a>
  802b7f:	83 ec 04             	sub    $0x4,%esp
  802b82:	68 c7 44 80 00       	push   $0x8044c7
  802b87:	68 58 01 00 00       	push   $0x158
  802b8c:	68 e5 44 80 00       	push   $0x8044e5
  802b91:	e8 02 d8 ff ff       	call   800398 <_panic>
  802b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b99:	8b 00                	mov    (%eax),%eax
  802b9b:	85 c0                	test   %eax,%eax
  802b9d:	74 10                	je     802baf <alloc_block_BF+0x493>
  802b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba7:	8b 52 04             	mov    0x4(%edx),%edx
  802baa:	89 50 04             	mov    %edx,0x4(%eax)
  802bad:	eb 0b                	jmp    802bba <alloc_block_BF+0x49e>
  802baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb2:	8b 40 04             	mov    0x4(%eax),%eax
  802bb5:	a3 30 50 80 00       	mov    %eax,0x805030
  802bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbd:	8b 40 04             	mov    0x4(%eax),%eax
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	74 0f                	je     802bd3 <alloc_block_BF+0x4b7>
  802bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc7:	8b 40 04             	mov    0x4(%eax),%eax
  802bca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bcd:	8b 12                	mov    (%edx),%edx
  802bcf:	89 10                	mov    %edx,(%eax)
  802bd1:	eb 0a                	jmp    802bdd <alloc_block_BF+0x4c1>
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf0:	a1 38 50 80 00       	mov    0x805038,%eax
  802bf5:	48                   	dec    %eax
  802bf6:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	e9 fc 00 00 00       	jmp    802cff <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	83 c0 08             	add    $0x8,%eax
  802c09:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c0c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c13:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c19:	01 d0                	add    %edx,%eax
  802c1b:	48                   	dec    %eax
  802c1c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c1f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c22:	ba 00 00 00 00       	mov    $0x0,%edx
  802c27:	f7 75 c4             	divl   -0x3c(%ebp)
  802c2a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c2d:	29 d0                	sub    %edx,%eax
  802c2f:	c1 e8 0c             	shr    $0xc,%eax
  802c32:	83 ec 0c             	sub    $0xc,%esp
  802c35:	50                   	push   %eax
  802c36:	e8 b4 e7 ff ff       	call   8013ef <sbrk>
  802c3b:	83 c4 10             	add    $0x10,%esp
  802c3e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c41:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c45:	75 0a                	jne    802c51 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c47:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4c:	e9 ae 00 00 00       	jmp    802cff <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c51:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c58:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c5b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c5e:	01 d0                	add    %edx,%eax
  802c60:	48                   	dec    %eax
  802c61:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c64:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c67:	ba 00 00 00 00       	mov    $0x0,%edx
  802c6c:	f7 75 b8             	divl   -0x48(%ebp)
  802c6f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c72:	29 d0                	sub    %edx,%eax
  802c74:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c77:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c7a:	01 d0                	add    %edx,%eax
  802c7c:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c81:	a1 40 50 80 00       	mov    0x805040,%eax
  802c86:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c8c:	83 ec 0c             	sub    $0xc,%esp
  802c8f:	68 8c 45 80 00       	push   $0x80458c
  802c94:	e8 bc d9 ff ff       	call   800655 <cprintf>
  802c99:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c9c:	83 ec 08             	sub    $0x8,%esp
  802c9f:	ff 75 bc             	pushl  -0x44(%ebp)
  802ca2:	68 91 45 80 00       	push   $0x804591
  802ca7:	e8 a9 d9 ff ff       	call   800655 <cprintf>
  802cac:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802caf:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cb6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cb9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cbc:	01 d0                	add    %edx,%eax
  802cbe:	48                   	dec    %eax
  802cbf:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802cc2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cca:	f7 75 b0             	divl   -0x50(%ebp)
  802ccd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cd0:	29 d0                	sub    %edx,%eax
  802cd2:	83 ec 04             	sub    $0x4,%esp
  802cd5:	6a 01                	push   $0x1
  802cd7:	50                   	push   %eax
  802cd8:	ff 75 bc             	pushl  -0x44(%ebp)
  802cdb:	e8 51 f5 ff ff       	call   802231 <set_block_data>
  802ce0:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ce3:	83 ec 0c             	sub    $0xc,%esp
  802ce6:	ff 75 bc             	pushl  -0x44(%ebp)
  802ce9:	e8 36 04 00 00       	call   803124 <free_block>
  802cee:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802cf1:	83 ec 0c             	sub    $0xc,%esp
  802cf4:	ff 75 08             	pushl  0x8(%ebp)
  802cf7:	e8 20 fa ff ff       	call   80271c <alloc_block_BF>
  802cfc:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802cff:	c9                   	leave  
  802d00:	c3                   	ret    

00802d01 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d01:	55                   	push   %ebp
  802d02:	89 e5                	mov    %esp,%ebp
  802d04:	53                   	push   %ebx
  802d05:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d1a:	74 1e                	je     802d3a <merging+0x39>
  802d1c:	ff 75 08             	pushl  0x8(%ebp)
  802d1f:	e8 bc f1 ff ff       	call   801ee0 <get_block_size>
  802d24:	83 c4 04             	add    $0x4,%esp
  802d27:	89 c2                	mov    %eax,%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	01 d0                	add    %edx,%eax
  802d2e:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d31:	75 07                	jne    802d3a <merging+0x39>
		prev_is_free = 1;
  802d33:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d3e:	74 1e                	je     802d5e <merging+0x5d>
  802d40:	ff 75 10             	pushl  0x10(%ebp)
  802d43:	e8 98 f1 ff ff       	call   801ee0 <get_block_size>
  802d48:	83 c4 04             	add    $0x4,%esp
  802d4b:	89 c2                	mov    %eax,%edx
  802d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  802d50:	01 d0                	add    %edx,%eax
  802d52:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d55:	75 07                	jne    802d5e <merging+0x5d>
		next_is_free = 1;
  802d57:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d62:	0f 84 cc 00 00 00    	je     802e34 <merging+0x133>
  802d68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d6c:	0f 84 c2 00 00 00    	je     802e34 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d72:	ff 75 08             	pushl  0x8(%ebp)
  802d75:	e8 66 f1 ff ff       	call   801ee0 <get_block_size>
  802d7a:	83 c4 04             	add    $0x4,%esp
  802d7d:	89 c3                	mov    %eax,%ebx
  802d7f:	ff 75 10             	pushl  0x10(%ebp)
  802d82:	e8 59 f1 ff ff       	call   801ee0 <get_block_size>
  802d87:	83 c4 04             	add    $0x4,%esp
  802d8a:	01 c3                	add    %eax,%ebx
  802d8c:	ff 75 0c             	pushl  0xc(%ebp)
  802d8f:	e8 4c f1 ff ff       	call   801ee0 <get_block_size>
  802d94:	83 c4 04             	add    $0x4,%esp
  802d97:	01 d8                	add    %ebx,%eax
  802d99:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d9c:	6a 00                	push   $0x0
  802d9e:	ff 75 ec             	pushl  -0x14(%ebp)
  802da1:	ff 75 08             	pushl  0x8(%ebp)
  802da4:	e8 88 f4 ff ff       	call   802231 <set_block_data>
  802da9:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802dac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802db0:	75 17                	jne    802dc9 <merging+0xc8>
  802db2:	83 ec 04             	sub    $0x4,%esp
  802db5:	68 c7 44 80 00       	push   $0x8044c7
  802dba:	68 7d 01 00 00       	push   $0x17d
  802dbf:	68 e5 44 80 00       	push   $0x8044e5
  802dc4:	e8 cf d5 ff ff       	call   800398 <_panic>
  802dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcc:	8b 00                	mov    (%eax),%eax
  802dce:	85 c0                	test   %eax,%eax
  802dd0:	74 10                	je     802de2 <merging+0xe1>
  802dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dda:	8b 52 04             	mov    0x4(%edx),%edx
  802ddd:	89 50 04             	mov    %edx,0x4(%eax)
  802de0:	eb 0b                	jmp    802ded <merging+0xec>
  802de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de5:	8b 40 04             	mov    0x4(%eax),%eax
  802de8:	a3 30 50 80 00       	mov    %eax,0x805030
  802ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df0:	8b 40 04             	mov    0x4(%eax),%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	74 0f                	je     802e06 <merging+0x105>
  802df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfa:	8b 40 04             	mov    0x4(%eax),%eax
  802dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e00:	8b 12                	mov    (%edx),%edx
  802e02:	89 10                	mov    %edx,(%eax)
  802e04:	eb 0a                	jmp    802e10 <merging+0x10f>
  802e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e09:	8b 00                	mov    (%eax),%eax
  802e0b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e23:	a1 38 50 80 00       	mov    0x805038,%eax
  802e28:	48                   	dec    %eax
  802e29:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e2e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e2f:	e9 ea 02 00 00       	jmp    80311e <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e38:	74 3b                	je     802e75 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e3a:	83 ec 0c             	sub    $0xc,%esp
  802e3d:	ff 75 08             	pushl  0x8(%ebp)
  802e40:	e8 9b f0 ff ff       	call   801ee0 <get_block_size>
  802e45:	83 c4 10             	add    $0x10,%esp
  802e48:	89 c3                	mov    %eax,%ebx
  802e4a:	83 ec 0c             	sub    $0xc,%esp
  802e4d:	ff 75 10             	pushl  0x10(%ebp)
  802e50:	e8 8b f0 ff ff       	call   801ee0 <get_block_size>
  802e55:	83 c4 10             	add    $0x10,%esp
  802e58:	01 d8                	add    %ebx,%eax
  802e5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	6a 00                	push   $0x0
  802e62:	ff 75 e8             	pushl  -0x18(%ebp)
  802e65:	ff 75 08             	pushl  0x8(%ebp)
  802e68:	e8 c4 f3 ff ff       	call   802231 <set_block_data>
  802e6d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e70:	e9 a9 02 00 00       	jmp    80311e <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e79:	0f 84 2d 01 00 00    	je     802fac <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e7f:	83 ec 0c             	sub    $0xc,%esp
  802e82:	ff 75 10             	pushl  0x10(%ebp)
  802e85:	e8 56 f0 ff ff       	call   801ee0 <get_block_size>
  802e8a:	83 c4 10             	add    $0x10,%esp
  802e8d:	89 c3                	mov    %eax,%ebx
  802e8f:	83 ec 0c             	sub    $0xc,%esp
  802e92:	ff 75 0c             	pushl  0xc(%ebp)
  802e95:	e8 46 f0 ff ff       	call   801ee0 <get_block_size>
  802e9a:	83 c4 10             	add    $0x10,%esp
  802e9d:	01 d8                	add    %ebx,%eax
  802e9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ea2:	83 ec 04             	sub    $0x4,%esp
  802ea5:	6a 00                	push   $0x0
  802ea7:	ff 75 e4             	pushl  -0x1c(%ebp)
  802eaa:	ff 75 10             	pushl  0x10(%ebp)
  802ead:	e8 7f f3 ff ff       	call   802231 <set_block_data>
  802eb2:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  802eb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802ebb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ebf:	74 06                	je     802ec7 <merging+0x1c6>
  802ec1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ec5:	75 17                	jne    802ede <merging+0x1dd>
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	68 a0 45 80 00       	push   $0x8045a0
  802ecf:	68 8d 01 00 00       	push   $0x18d
  802ed4:	68 e5 44 80 00       	push   $0x8044e5
  802ed9:	e8 ba d4 ff ff       	call   800398 <_panic>
  802ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee1:	8b 50 04             	mov    0x4(%eax),%edx
  802ee4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee7:	89 50 04             	mov    %edx,0x4(%eax)
  802eea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ef0:	89 10                	mov    %edx,(%eax)
  802ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	74 0d                	je     802f09 <merging+0x208>
  802efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eff:	8b 40 04             	mov    0x4(%eax),%eax
  802f02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f05:	89 10                	mov    %edx,(%eax)
  802f07:	eb 08                	jmp    802f11 <merging+0x210>
  802f09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f0c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f17:	89 50 04             	mov    %edx,0x4(%eax)
  802f1a:	a1 38 50 80 00       	mov    0x805038,%eax
  802f1f:	40                   	inc    %eax
  802f20:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f29:	75 17                	jne    802f42 <merging+0x241>
  802f2b:	83 ec 04             	sub    $0x4,%esp
  802f2e:	68 c7 44 80 00       	push   $0x8044c7
  802f33:	68 8e 01 00 00       	push   $0x18e
  802f38:	68 e5 44 80 00       	push   $0x8044e5
  802f3d:	e8 56 d4 ff ff       	call   800398 <_panic>
  802f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	74 10                	je     802f5b <merging+0x25a>
  802f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f53:	8b 52 04             	mov    0x4(%edx),%edx
  802f56:	89 50 04             	mov    %edx,0x4(%eax)
  802f59:	eb 0b                	jmp    802f66 <merging+0x265>
  802f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	a3 30 50 80 00       	mov    %eax,0x805030
  802f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 0f                	je     802f7f <merging+0x27e>
  802f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f79:	8b 12                	mov    (%edx),%edx
  802f7b:	89 10                	mov    %edx,(%eax)
  802f7d:	eb 0a                	jmp    802f89 <merging+0x288>
  802f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f82:	8b 00                	mov    (%eax),%eax
  802f84:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9c:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa1:	48                   	dec    %eax
  802fa2:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fa7:	e9 72 01 00 00       	jmp    80311e <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fac:	8b 45 10             	mov    0x10(%ebp),%eax
  802faf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802fb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb6:	74 79                	je     803031 <merging+0x330>
  802fb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fbc:	74 73                	je     803031 <merging+0x330>
  802fbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc2:	74 06                	je     802fca <merging+0x2c9>
  802fc4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fc8:	75 17                	jne    802fe1 <merging+0x2e0>
  802fca:	83 ec 04             	sub    $0x4,%esp
  802fcd:	68 58 45 80 00       	push   $0x804558
  802fd2:	68 94 01 00 00       	push   $0x194
  802fd7:	68 e5 44 80 00       	push   $0x8044e5
  802fdc:	e8 b7 d3 ff ff       	call   800398 <_panic>
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	8b 10                	mov    (%eax),%edx
  802fe6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe9:	89 10                	mov    %edx,(%eax)
  802feb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	74 0b                	je     802fff <merging+0x2fe>
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ffc:	89 50 04             	mov    %edx,0x4(%eax)
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803005:	89 10                	mov    %edx,(%eax)
  803007:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300a:	8b 55 08             	mov    0x8(%ebp),%edx
  80300d:	89 50 04             	mov    %edx,0x4(%eax)
  803010:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	85 c0                	test   %eax,%eax
  803017:	75 08                	jne    803021 <merging+0x320>
  803019:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301c:	a3 30 50 80 00       	mov    %eax,0x805030
  803021:	a1 38 50 80 00       	mov    0x805038,%eax
  803026:	40                   	inc    %eax
  803027:	a3 38 50 80 00       	mov    %eax,0x805038
  80302c:	e9 ce 00 00 00       	jmp    8030ff <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803031:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803035:	74 65                	je     80309c <merging+0x39b>
  803037:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80303b:	75 17                	jne    803054 <merging+0x353>
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 34 45 80 00       	push   $0x804534
  803045:	68 95 01 00 00       	push   $0x195
  80304a:	68 e5 44 80 00       	push   $0x8044e5
  80304f:	e8 44 d3 ff ff       	call   800398 <_panic>
  803054:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80305a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803063:	8b 40 04             	mov    0x4(%eax),%eax
  803066:	85 c0                	test   %eax,%eax
  803068:	74 0c                	je     803076 <merging+0x375>
  80306a:	a1 30 50 80 00       	mov    0x805030,%eax
  80306f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803072:	89 10                	mov    %edx,(%eax)
  803074:	eb 08                	jmp    80307e <merging+0x37d>
  803076:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803079:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80307e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803081:	a3 30 50 80 00       	mov    %eax,0x805030
  803086:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803089:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308f:	a1 38 50 80 00       	mov    0x805038,%eax
  803094:	40                   	inc    %eax
  803095:	a3 38 50 80 00       	mov    %eax,0x805038
  80309a:	eb 63                	jmp    8030ff <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80309c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030a0:	75 17                	jne    8030b9 <merging+0x3b8>
  8030a2:	83 ec 04             	sub    $0x4,%esp
  8030a5:	68 00 45 80 00       	push   $0x804500
  8030aa:	68 98 01 00 00       	push   $0x198
  8030af:	68 e5 44 80 00       	push   $0x8044e5
  8030b4:	e8 df d2 ff ff       	call   800398 <_panic>
  8030b9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c2:	89 10                	mov    %edx,(%eax)
  8030c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c7:	8b 00                	mov    (%eax),%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	74 0d                	je     8030da <merging+0x3d9>
  8030cd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030d5:	89 50 04             	mov    %edx,0x4(%eax)
  8030d8:	eb 08                	jmp    8030e2 <merging+0x3e1>
  8030da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8030e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8030f9:	40                   	inc    %eax
  8030fa:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8030ff:	83 ec 0c             	sub    $0xc,%esp
  803102:	ff 75 10             	pushl  0x10(%ebp)
  803105:	e8 d6 ed ff ff       	call   801ee0 <get_block_size>
  80310a:	83 c4 10             	add    $0x10,%esp
  80310d:	83 ec 04             	sub    $0x4,%esp
  803110:	6a 00                	push   $0x0
  803112:	50                   	push   %eax
  803113:	ff 75 10             	pushl  0x10(%ebp)
  803116:	e8 16 f1 ff ff       	call   802231 <set_block_data>
  80311b:	83 c4 10             	add    $0x10,%esp
	}
}
  80311e:	90                   	nop
  80311f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803122:	c9                   	leave  
  803123:	c3                   	ret    

00803124 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803124:	55                   	push   %ebp
  803125:	89 e5                	mov    %esp,%ebp
  803127:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80312a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80312f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803132:	a1 30 50 80 00       	mov    0x805030,%eax
  803137:	3b 45 08             	cmp    0x8(%ebp),%eax
  80313a:	73 1b                	jae    803157 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80313c:	a1 30 50 80 00       	mov    0x805030,%eax
  803141:	83 ec 04             	sub    $0x4,%esp
  803144:	ff 75 08             	pushl  0x8(%ebp)
  803147:	6a 00                	push   $0x0
  803149:	50                   	push   %eax
  80314a:	e8 b2 fb ff ff       	call   802d01 <merging>
  80314f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803152:	e9 8b 00 00 00       	jmp    8031e2 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803157:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80315c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80315f:	76 18                	jbe    803179 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803161:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803166:	83 ec 04             	sub    $0x4,%esp
  803169:	ff 75 08             	pushl  0x8(%ebp)
  80316c:	50                   	push   %eax
  80316d:	6a 00                	push   $0x0
  80316f:	e8 8d fb ff ff       	call   802d01 <merging>
  803174:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803177:	eb 69                	jmp    8031e2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803179:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80317e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803181:	eb 39                	jmp    8031bc <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803186:	3b 45 08             	cmp    0x8(%ebp),%eax
  803189:	73 29                	jae    8031b4 <free_block+0x90>
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	8b 00                	mov    (%eax),%eax
  803190:	3b 45 08             	cmp    0x8(%ebp),%eax
  803193:	76 1f                	jbe    8031b4 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80319d:	83 ec 04             	sub    $0x4,%esp
  8031a0:	ff 75 08             	pushl  0x8(%ebp)
  8031a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8031a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8031a9:	e8 53 fb ff ff       	call   802d01 <merging>
  8031ae:	83 c4 10             	add    $0x10,%esp
			break;
  8031b1:	90                   	nop
		}
	}
}
  8031b2:	eb 2e                	jmp    8031e2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031b4:	a1 34 50 80 00       	mov    0x805034,%eax
  8031b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c0:	74 07                	je     8031c9 <free_block+0xa5>
  8031c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	eb 05                	jmp    8031ce <free_block+0xaa>
  8031c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ce:	a3 34 50 80 00       	mov    %eax,0x805034
  8031d3:	a1 34 50 80 00       	mov    0x805034,%eax
  8031d8:	85 c0                	test   %eax,%eax
  8031da:	75 a7                	jne    803183 <free_block+0x5f>
  8031dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e0:	75 a1                	jne    803183 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031e2:	90                   	nop
  8031e3:	c9                   	leave  
  8031e4:	c3                   	ret    

008031e5 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8031e5:	55                   	push   %ebp
  8031e6:	89 e5                	mov    %esp,%ebp
  8031e8:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8031eb:	ff 75 08             	pushl  0x8(%ebp)
  8031ee:	e8 ed ec ff ff       	call   801ee0 <get_block_size>
  8031f3:	83 c4 04             	add    $0x4,%esp
  8031f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8031f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803200:	eb 17                	jmp    803219 <copy_data+0x34>
  803202:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803205:	8b 45 0c             	mov    0xc(%ebp),%eax
  803208:	01 c2                	add    %eax,%edx
  80320a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	01 c8                	add    %ecx,%eax
  803212:	8a 00                	mov    (%eax),%al
  803214:	88 02                	mov    %al,(%edx)
  803216:	ff 45 fc             	incl   -0x4(%ebp)
  803219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80321c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80321f:	72 e1                	jb     803202 <copy_data+0x1d>
}
  803221:	90                   	nop
  803222:	c9                   	leave  
  803223:	c3                   	ret    

00803224 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803224:	55                   	push   %ebp
  803225:	89 e5                	mov    %esp,%ebp
  803227:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80322a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322e:	75 23                	jne    803253 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803230:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803234:	74 13                	je     803249 <realloc_block_FF+0x25>
  803236:	83 ec 0c             	sub    $0xc,%esp
  803239:	ff 75 0c             	pushl  0xc(%ebp)
  80323c:	e8 1f f0 ff ff       	call   802260 <alloc_block_FF>
  803241:	83 c4 10             	add    $0x10,%esp
  803244:	e9 f4 06 00 00       	jmp    80393d <realloc_block_FF+0x719>
		return NULL;
  803249:	b8 00 00 00 00       	mov    $0x0,%eax
  80324e:	e9 ea 06 00 00       	jmp    80393d <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803253:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803257:	75 18                	jne    803271 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803259:	83 ec 0c             	sub    $0xc,%esp
  80325c:	ff 75 08             	pushl  0x8(%ebp)
  80325f:	e8 c0 fe ff ff       	call   803124 <free_block>
  803264:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803267:	b8 00 00 00 00       	mov    $0x0,%eax
  80326c:	e9 cc 06 00 00       	jmp    80393d <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803271:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803275:	77 07                	ja     80327e <realloc_block_FF+0x5a>
  803277:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80327e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803281:	83 e0 01             	and    $0x1,%eax
  803284:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80328a:	83 c0 08             	add    $0x8,%eax
  80328d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803290:	83 ec 0c             	sub    $0xc,%esp
  803293:	ff 75 08             	pushl  0x8(%ebp)
  803296:	e8 45 ec ff ff       	call   801ee0 <get_block_size>
  80329b:	83 c4 10             	add    $0x10,%esp
  80329e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a4:	83 e8 08             	sub    $0x8,%eax
  8032a7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	83 e8 04             	sub    $0x4,%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	83 e0 fe             	and    $0xfffffffe,%eax
  8032b5:	89 c2                	mov    %eax,%edx
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	01 d0                	add    %edx,%eax
  8032bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032bf:	83 ec 0c             	sub    $0xc,%esp
  8032c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032c5:	e8 16 ec ff ff       	call   801ee0 <get_block_size>
  8032ca:	83 c4 10             	add    $0x10,%esp
  8032cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d3:	83 e8 08             	sub    $0x8,%eax
  8032d6:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032dc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032df:	75 08                	jne    8032e9 <realloc_block_FF+0xc5>
	{
		 return va;
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	e9 54 06 00 00       	jmp    80393d <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8032e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ec:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032ef:	0f 83 e5 03 00 00    	jae    8036da <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8032f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f8:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8032fe:	83 ec 0c             	sub    $0xc,%esp
  803301:	ff 75 e4             	pushl  -0x1c(%ebp)
  803304:	e8 f0 eb ff ff       	call   801ef9 <is_free_block>
  803309:	83 c4 10             	add    $0x10,%esp
  80330c:	84 c0                	test   %al,%al
  80330e:	0f 84 3b 01 00 00    	je     80344f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803314:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803317:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80331a:	01 d0                	add    %edx,%eax
  80331c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80331f:	83 ec 04             	sub    $0x4,%esp
  803322:	6a 01                	push   $0x1
  803324:	ff 75 f0             	pushl  -0x10(%ebp)
  803327:	ff 75 08             	pushl  0x8(%ebp)
  80332a:	e8 02 ef ff ff       	call   802231 <set_block_data>
  80332f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803332:	8b 45 08             	mov    0x8(%ebp),%eax
  803335:	83 e8 04             	sub    $0x4,%eax
  803338:	8b 00                	mov    (%eax),%eax
  80333a:	83 e0 fe             	and    $0xfffffffe,%eax
  80333d:	89 c2                	mov    %eax,%edx
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	01 d0                	add    %edx,%eax
  803344:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803347:	83 ec 04             	sub    $0x4,%esp
  80334a:	6a 00                	push   $0x0
  80334c:	ff 75 cc             	pushl  -0x34(%ebp)
  80334f:	ff 75 c8             	pushl  -0x38(%ebp)
  803352:	e8 da ee ff ff       	call   802231 <set_block_data>
  803357:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80335a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80335e:	74 06                	je     803366 <realloc_block_FF+0x142>
  803360:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803364:	75 17                	jne    80337d <realloc_block_FF+0x159>
  803366:	83 ec 04             	sub    $0x4,%esp
  803369:	68 58 45 80 00       	push   $0x804558
  80336e:	68 f6 01 00 00       	push   $0x1f6
  803373:	68 e5 44 80 00       	push   $0x8044e5
  803378:	e8 1b d0 ff ff       	call   800398 <_panic>
  80337d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803380:	8b 10                	mov    (%eax),%edx
  803382:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803385:	89 10                	mov    %edx,(%eax)
  803387:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80338a:	8b 00                	mov    (%eax),%eax
  80338c:	85 c0                	test   %eax,%eax
  80338e:	74 0b                	je     80339b <realloc_block_FF+0x177>
  803390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803393:	8b 00                	mov    (%eax),%eax
  803395:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803398:	89 50 04             	mov    %edx,0x4(%eax)
  80339b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033a1:	89 10                	mov    %edx,(%eax)
  8033a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033a9:	89 50 04             	mov    %edx,0x4(%eax)
  8033ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	85 c0                	test   %eax,%eax
  8033b3:	75 08                	jne    8033bd <realloc_block_FF+0x199>
  8033b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8033bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8033c2:	40                   	inc    %eax
  8033c3:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033cc:	75 17                	jne    8033e5 <realloc_block_FF+0x1c1>
  8033ce:	83 ec 04             	sub    $0x4,%esp
  8033d1:	68 c7 44 80 00       	push   $0x8044c7
  8033d6:	68 f7 01 00 00       	push   $0x1f7
  8033db:	68 e5 44 80 00       	push   $0x8044e5
  8033e0:	e8 b3 cf ff ff       	call   800398 <_panic>
  8033e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e8:	8b 00                	mov    (%eax),%eax
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	74 10                	je     8033fe <realloc_block_FF+0x1da>
  8033ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f1:	8b 00                	mov    (%eax),%eax
  8033f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033f6:	8b 52 04             	mov    0x4(%edx),%edx
  8033f9:	89 50 04             	mov    %edx,0x4(%eax)
  8033fc:	eb 0b                	jmp    803409 <realloc_block_FF+0x1e5>
  8033fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803401:	8b 40 04             	mov    0x4(%eax),%eax
  803404:	a3 30 50 80 00       	mov    %eax,0x805030
  803409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340c:	8b 40 04             	mov    0x4(%eax),%eax
  80340f:	85 c0                	test   %eax,%eax
  803411:	74 0f                	je     803422 <realloc_block_FF+0x1fe>
  803413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803416:	8b 40 04             	mov    0x4(%eax),%eax
  803419:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80341c:	8b 12                	mov    (%edx),%edx
  80341e:	89 10                	mov    %edx,(%eax)
  803420:	eb 0a                	jmp    80342c <realloc_block_FF+0x208>
  803422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803425:	8b 00                	mov    (%eax),%eax
  803427:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80342c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803438:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80343f:	a1 38 50 80 00       	mov    0x805038,%eax
  803444:	48                   	dec    %eax
  803445:	a3 38 50 80 00       	mov    %eax,0x805038
  80344a:	e9 83 02 00 00       	jmp    8036d2 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80344f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803453:	0f 86 69 02 00 00    	jbe    8036c2 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803459:	83 ec 04             	sub    $0x4,%esp
  80345c:	6a 01                	push   $0x1
  80345e:	ff 75 f0             	pushl  -0x10(%ebp)
  803461:	ff 75 08             	pushl  0x8(%ebp)
  803464:	e8 c8 ed ff ff       	call   802231 <set_block_data>
  803469:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80346c:	8b 45 08             	mov    0x8(%ebp),%eax
  80346f:	83 e8 04             	sub    $0x4,%eax
  803472:	8b 00                	mov    (%eax),%eax
  803474:	83 e0 fe             	and    $0xfffffffe,%eax
  803477:	89 c2                	mov    %eax,%edx
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	01 d0                	add    %edx,%eax
  80347e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803481:	a1 38 50 80 00       	mov    0x805038,%eax
  803486:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803489:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80348d:	75 68                	jne    8034f7 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80348f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803493:	75 17                	jne    8034ac <realloc_block_FF+0x288>
  803495:	83 ec 04             	sub    $0x4,%esp
  803498:	68 00 45 80 00       	push   $0x804500
  80349d:	68 06 02 00 00       	push   $0x206
  8034a2:	68 e5 44 80 00       	push   $0x8044e5
  8034a7:	e8 ec ce ff ff       	call   800398 <_panic>
  8034ac:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b5:	89 10                	mov    %edx,(%eax)
  8034b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	74 0d                	je     8034cd <realloc_block_FF+0x2a9>
  8034c0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034c8:	89 50 04             	mov    %edx,0x4(%eax)
  8034cb:	eb 08                	jmp    8034d5 <realloc_block_FF+0x2b1>
  8034cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8034d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e7:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ec:	40                   	inc    %eax
  8034ed:	a3 38 50 80 00       	mov    %eax,0x805038
  8034f2:	e9 b0 01 00 00       	jmp    8036a7 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8034f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034fc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034ff:	76 68                	jbe    803569 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803501:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803505:	75 17                	jne    80351e <realloc_block_FF+0x2fa>
  803507:	83 ec 04             	sub    $0x4,%esp
  80350a:	68 00 45 80 00       	push   $0x804500
  80350f:	68 0b 02 00 00       	push   $0x20b
  803514:	68 e5 44 80 00       	push   $0x8044e5
  803519:	e8 7a ce ff ff       	call   800398 <_panic>
  80351e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803524:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803527:	89 10                	mov    %edx,(%eax)
  803529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352c:	8b 00                	mov    (%eax),%eax
  80352e:	85 c0                	test   %eax,%eax
  803530:	74 0d                	je     80353f <realloc_block_FF+0x31b>
  803532:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803537:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80353a:	89 50 04             	mov    %edx,0x4(%eax)
  80353d:	eb 08                	jmp    803547 <realloc_block_FF+0x323>
  80353f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803542:	a3 30 50 80 00       	mov    %eax,0x805030
  803547:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80354f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803552:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803559:	a1 38 50 80 00       	mov    0x805038,%eax
  80355e:	40                   	inc    %eax
  80355f:	a3 38 50 80 00       	mov    %eax,0x805038
  803564:	e9 3e 01 00 00       	jmp    8036a7 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803569:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80356e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803571:	73 68                	jae    8035db <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803573:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803577:	75 17                	jne    803590 <realloc_block_FF+0x36c>
  803579:	83 ec 04             	sub    $0x4,%esp
  80357c:	68 34 45 80 00       	push   $0x804534
  803581:	68 10 02 00 00       	push   $0x210
  803586:	68 e5 44 80 00       	push   $0x8044e5
  80358b:	e8 08 ce ff ff       	call   800398 <_panic>
  803590:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803596:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803599:	89 50 04             	mov    %edx,0x4(%eax)
  80359c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359f:	8b 40 04             	mov    0x4(%eax),%eax
  8035a2:	85 c0                	test   %eax,%eax
  8035a4:	74 0c                	je     8035b2 <realloc_block_FF+0x38e>
  8035a6:	a1 30 50 80 00       	mov    0x805030,%eax
  8035ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ae:	89 10                	mov    %edx,(%eax)
  8035b0:	eb 08                	jmp    8035ba <realloc_block_FF+0x396>
  8035b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d0:	40                   	inc    %eax
  8035d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8035d6:	e9 cc 00 00 00       	jmp    8036a7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8035e2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ea:	e9 8a 00 00 00       	jmp    803679 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035f5:	73 7a                	jae    803671 <realloc_block_FF+0x44d>
  8035f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fa:	8b 00                	mov    (%eax),%eax
  8035fc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ff:	73 70                	jae    803671 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803605:	74 06                	je     80360d <realloc_block_FF+0x3e9>
  803607:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80360b:	75 17                	jne    803624 <realloc_block_FF+0x400>
  80360d:	83 ec 04             	sub    $0x4,%esp
  803610:	68 58 45 80 00       	push   $0x804558
  803615:	68 1a 02 00 00       	push   $0x21a
  80361a:	68 e5 44 80 00       	push   $0x8044e5
  80361f:	e8 74 cd ff ff       	call   800398 <_panic>
  803624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803627:	8b 10                	mov    (%eax),%edx
  803629:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362c:	89 10                	mov    %edx,(%eax)
  80362e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803631:	8b 00                	mov    (%eax),%eax
  803633:	85 c0                	test   %eax,%eax
  803635:	74 0b                	je     803642 <realloc_block_FF+0x41e>
  803637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363a:	8b 00                	mov    (%eax),%eax
  80363c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80363f:	89 50 04             	mov    %edx,0x4(%eax)
  803642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803645:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803648:	89 10                	mov    %edx,(%eax)
  80364a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803650:	89 50 04             	mov    %edx,0x4(%eax)
  803653:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803656:	8b 00                	mov    (%eax),%eax
  803658:	85 c0                	test   %eax,%eax
  80365a:	75 08                	jne    803664 <realloc_block_FF+0x440>
  80365c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365f:	a3 30 50 80 00       	mov    %eax,0x805030
  803664:	a1 38 50 80 00       	mov    0x805038,%eax
  803669:	40                   	inc    %eax
  80366a:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80366f:	eb 36                	jmp    8036a7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803671:	a1 34 50 80 00       	mov    0x805034,%eax
  803676:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367d:	74 07                	je     803686 <realloc_block_FF+0x462>
  80367f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803682:	8b 00                	mov    (%eax),%eax
  803684:	eb 05                	jmp    80368b <realloc_block_FF+0x467>
  803686:	b8 00 00 00 00       	mov    $0x0,%eax
  80368b:	a3 34 50 80 00       	mov    %eax,0x805034
  803690:	a1 34 50 80 00       	mov    0x805034,%eax
  803695:	85 c0                	test   %eax,%eax
  803697:	0f 85 52 ff ff ff    	jne    8035ef <realloc_block_FF+0x3cb>
  80369d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a1:	0f 85 48 ff ff ff    	jne    8035ef <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036a7:	83 ec 04             	sub    $0x4,%esp
  8036aa:	6a 00                	push   $0x0
  8036ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8036af:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036b2:	e8 7a eb ff ff       	call   802231 <set_block_data>
  8036b7:	83 c4 10             	add    $0x10,%esp
				return va;
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	e9 7b 02 00 00       	jmp    80393d <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8036c2:	83 ec 0c             	sub    $0xc,%esp
  8036c5:	68 d5 45 80 00       	push   $0x8045d5
  8036ca:	e8 86 cf ff ff       	call   800655 <cprintf>
  8036cf:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	e9 63 02 00 00       	jmp    80393d <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8036da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036dd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036e0:	0f 86 4d 02 00 00    	jbe    803933 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8036e6:	83 ec 0c             	sub    $0xc,%esp
  8036e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036ec:	e8 08 e8 ff ff       	call   801ef9 <is_free_block>
  8036f1:	83 c4 10             	add    $0x10,%esp
  8036f4:	84 c0                	test   %al,%al
  8036f6:	0f 84 37 02 00 00    	je     803933 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8036fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ff:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803702:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803705:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803708:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80370b:	76 38                	jbe    803745 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80370d:	83 ec 0c             	sub    $0xc,%esp
  803710:	ff 75 08             	pushl  0x8(%ebp)
  803713:	e8 0c fa ff ff       	call   803124 <free_block>
  803718:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80371b:	83 ec 0c             	sub    $0xc,%esp
  80371e:	ff 75 0c             	pushl  0xc(%ebp)
  803721:	e8 3a eb ff ff       	call   802260 <alloc_block_FF>
  803726:	83 c4 10             	add    $0x10,%esp
  803729:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80372c:	83 ec 08             	sub    $0x8,%esp
  80372f:	ff 75 c0             	pushl  -0x40(%ebp)
  803732:	ff 75 08             	pushl  0x8(%ebp)
  803735:	e8 ab fa ff ff       	call   8031e5 <copy_data>
  80373a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80373d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803740:	e9 f8 01 00 00       	jmp    80393d <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803748:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80374b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80374e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803752:	0f 87 a0 00 00 00    	ja     8037f8 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803758:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80375c:	75 17                	jne    803775 <realloc_block_FF+0x551>
  80375e:	83 ec 04             	sub    $0x4,%esp
  803761:	68 c7 44 80 00       	push   $0x8044c7
  803766:	68 38 02 00 00       	push   $0x238
  80376b:	68 e5 44 80 00       	push   $0x8044e5
  803770:	e8 23 cc ff ff       	call   800398 <_panic>
  803775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803778:	8b 00                	mov    (%eax),%eax
  80377a:	85 c0                	test   %eax,%eax
  80377c:	74 10                	je     80378e <realloc_block_FF+0x56a>
  80377e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803781:	8b 00                	mov    (%eax),%eax
  803783:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803786:	8b 52 04             	mov    0x4(%edx),%edx
  803789:	89 50 04             	mov    %edx,0x4(%eax)
  80378c:	eb 0b                	jmp    803799 <realloc_block_FF+0x575>
  80378e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803791:	8b 40 04             	mov    0x4(%eax),%eax
  803794:	a3 30 50 80 00       	mov    %eax,0x805030
  803799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379c:	8b 40 04             	mov    0x4(%eax),%eax
  80379f:	85 c0                	test   %eax,%eax
  8037a1:	74 0f                	je     8037b2 <realloc_block_FF+0x58e>
  8037a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a6:	8b 40 04             	mov    0x4(%eax),%eax
  8037a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ac:	8b 12                	mov    (%edx),%edx
  8037ae:	89 10                	mov    %edx,(%eax)
  8037b0:	eb 0a                	jmp    8037bc <realloc_block_FF+0x598>
  8037b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b5:	8b 00                	mov    (%eax),%eax
  8037b7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d4:	48                   	dec    %eax
  8037d5:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e0:	01 d0                	add    %edx,%eax
  8037e2:	83 ec 04             	sub    $0x4,%esp
  8037e5:	6a 01                	push   $0x1
  8037e7:	50                   	push   %eax
  8037e8:	ff 75 08             	pushl  0x8(%ebp)
  8037eb:	e8 41 ea ff ff       	call   802231 <set_block_data>
  8037f0:	83 c4 10             	add    $0x10,%esp
  8037f3:	e9 36 01 00 00       	jmp    80392e <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8037f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037fb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037fe:	01 d0                	add    %edx,%eax
  803800:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803803:	83 ec 04             	sub    $0x4,%esp
  803806:	6a 01                	push   $0x1
  803808:	ff 75 f0             	pushl  -0x10(%ebp)
  80380b:	ff 75 08             	pushl  0x8(%ebp)
  80380e:	e8 1e ea ff ff       	call   802231 <set_block_data>
  803813:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803816:	8b 45 08             	mov    0x8(%ebp),%eax
  803819:	83 e8 04             	sub    $0x4,%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	83 e0 fe             	and    $0xfffffffe,%eax
  803821:	89 c2                	mov    %eax,%edx
  803823:	8b 45 08             	mov    0x8(%ebp),%eax
  803826:	01 d0                	add    %edx,%eax
  803828:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80382b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80382f:	74 06                	je     803837 <realloc_block_FF+0x613>
  803831:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803835:	75 17                	jne    80384e <realloc_block_FF+0x62a>
  803837:	83 ec 04             	sub    $0x4,%esp
  80383a:	68 58 45 80 00       	push   $0x804558
  80383f:	68 44 02 00 00       	push   $0x244
  803844:	68 e5 44 80 00       	push   $0x8044e5
  803849:	e8 4a cb ff ff       	call   800398 <_panic>
  80384e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803851:	8b 10                	mov    (%eax),%edx
  803853:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803856:	89 10                	mov    %edx,(%eax)
  803858:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80385b:	8b 00                	mov    (%eax),%eax
  80385d:	85 c0                	test   %eax,%eax
  80385f:	74 0b                	je     80386c <realloc_block_FF+0x648>
  803861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803869:	89 50 04             	mov    %edx,0x4(%eax)
  80386c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803872:	89 10                	mov    %edx,(%eax)
  803874:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803877:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387a:	89 50 04             	mov    %edx,0x4(%eax)
  80387d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803880:	8b 00                	mov    (%eax),%eax
  803882:	85 c0                	test   %eax,%eax
  803884:	75 08                	jne    80388e <realloc_block_FF+0x66a>
  803886:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803889:	a3 30 50 80 00       	mov    %eax,0x805030
  80388e:	a1 38 50 80 00       	mov    0x805038,%eax
  803893:	40                   	inc    %eax
  803894:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803899:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80389d:	75 17                	jne    8038b6 <realloc_block_FF+0x692>
  80389f:	83 ec 04             	sub    $0x4,%esp
  8038a2:	68 c7 44 80 00       	push   $0x8044c7
  8038a7:	68 45 02 00 00       	push   $0x245
  8038ac:	68 e5 44 80 00       	push   $0x8044e5
  8038b1:	e8 e2 ca ff ff       	call   800398 <_panic>
  8038b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b9:	8b 00                	mov    (%eax),%eax
  8038bb:	85 c0                	test   %eax,%eax
  8038bd:	74 10                	je     8038cf <realloc_block_FF+0x6ab>
  8038bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c2:	8b 00                	mov    (%eax),%eax
  8038c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c7:	8b 52 04             	mov    0x4(%edx),%edx
  8038ca:	89 50 04             	mov    %edx,0x4(%eax)
  8038cd:	eb 0b                	jmp    8038da <realloc_block_FF+0x6b6>
  8038cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d2:	8b 40 04             	mov    0x4(%eax),%eax
  8038d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8038da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038dd:	8b 40 04             	mov    0x4(%eax),%eax
  8038e0:	85 c0                	test   %eax,%eax
  8038e2:	74 0f                	je     8038f3 <realloc_block_FF+0x6cf>
  8038e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ed:	8b 12                	mov    (%edx),%edx
  8038ef:	89 10                	mov    %edx,(%eax)
  8038f1:	eb 0a                	jmp    8038fd <realloc_block_FF+0x6d9>
  8038f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f6:	8b 00                	mov    (%eax),%eax
  8038f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803909:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803910:	a1 38 50 80 00       	mov    0x805038,%eax
  803915:	48                   	dec    %eax
  803916:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80391b:	83 ec 04             	sub    $0x4,%esp
  80391e:	6a 00                	push   $0x0
  803920:	ff 75 bc             	pushl  -0x44(%ebp)
  803923:	ff 75 b8             	pushl  -0x48(%ebp)
  803926:	e8 06 e9 ff ff       	call   802231 <set_block_data>
  80392b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80392e:	8b 45 08             	mov    0x8(%ebp),%eax
  803931:	eb 0a                	jmp    80393d <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803933:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80393a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80393d:	c9                   	leave  
  80393e:	c3                   	ret    

0080393f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80393f:	55                   	push   %ebp
  803940:	89 e5                	mov    %esp,%ebp
  803942:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803945:	83 ec 04             	sub    $0x4,%esp
  803948:	68 dc 45 80 00       	push   $0x8045dc
  80394d:	68 58 02 00 00       	push   $0x258
  803952:	68 e5 44 80 00       	push   $0x8044e5
  803957:	e8 3c ca ff ff       	call   800398 <_panic>

0080395c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80395c:	55                   	push   %ebp
  80395d:	89 e5                	mov    %esp,%ebp
  80395f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803962:	83 ec 04             	sub    $0x4,%esp
  803965:	68 04 46 80 00       	push   $0x804604
  80396a:	68 61 02 00 00       	push   $0x261
  80396f:	68 e5 44 80 00       	push   $0x8044e5
  803974:	e8 1f ca ff ff       	call   800398 <_panic>
  803979:	66 90                	xchg   %ax,%ax
  80397b:	90                   	nop

0080397c <__udivdi3>:
  80397c:	55                   	push   %ebp
  80397d:	57                   	push   %edi
  80397e:	56                   	push   %esi
  80397f:	53                   	push   %ebx
  803980:	83 ec 1c             	sub    $0x1c,%esp
  803983:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803987:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80398b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80398f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803993:	89 ca                	mov    %ecx,%edx
  803995:	89 f8                	mov    %edi,%eax
  803997:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80399b:	85 f6                	test   %esi,%esi
  80399d:	75 2d                	jne    8039cc <__udivdi3+0x50>
  80399f:	39 cf                	cmp    %ecx,%edi
  8039a1:	77 65                	ja     803a08 <__udivdi3+0x8c>
  8039a3:	89 fd                	mov    %edi,%ebp
  8039a5:	85 ff                	test   %edi,%edi
  8039a7:	75 0b                	jne    8039b4 <__udivdi3+0x38>
  8039a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ae:	31 d2                	xor    %edx,%edx
  8039b0:	f7 f7                	div    %edi
  8039b2:	89 c5                	mov    %eax,%ebp
  8039b4:	31 d2                	xor    %edx,%edx
  8039b6:	89 c8                	mov    %ecx,%eax
  8039b8:	f7 f5                	div    %ebp
  8039ba:	89 c1                	mov    %eax,%ecx
  8039bc:	89 d8                	mov    %ebx,%eax
  8039be:	f7 f5                	div    %ebp
  8039c0:	89 cf                	mov    %ecx,%edi
  8039c2:	89 fa                	mov    %edi,%edx
  8039c4:	83 c4 1c             	add    $0x1c,%esp
  8039c7:	5b                   	pop    %ebx
  8039c8:	5e                   	pop    %esi
  8039c9:	5f                   	pop    %edi
  8039ca:	5d                   	pop    %ebp
  8039cb:	c3                   	ret    
  8039cc:	39 ce                	cmp    %ecx,%esi
  8039ce:	77 28                	ja     8039f8 <__udivdi3+0x7c>
  8039d0:	0f bd fe             	bsr    %esi,%edi
  8039d3:	83 f7 1f             	xor    $0x1f,%edi
  8039d6:	75 40                	jne    803a18 <__udivdi3+0x9c>
  8039d8:	39 ce                	cmp    %ecx,%esi
  8039da:	72 0a                	jb     8039e6 <__udivdi3+0x6a>
  8039dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039e0:	0f 87 9e 00 00 00    	ja     803a84 <__udivdi3+0x108>
  8039e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039eb:	89 fa                	mov    %edi,%edx
  8039ed:	83 c4 1c             	add    $0x1c,%esp
  8039f0:	5b                   	pop    %ebx
  8039f1:	5e                   	pop    %esi
  8039f2:	5f                   	pop    %edi
  8039f3:	5d                   	pop    %ebp
  8039f4:	c3                   	ret    
  8039f5:	8d 76 00             	lea    0x0(%esi),%esi
  8039f8:	31 ff                	xor    %edi,%edi
  8039fa:	31 c0                	xor    %eax,%eax
  8039fc:	89 fa                	mov    %edi,%edx
  8039fe:	83 c4 1c             	add    $0x1c,%esp
  803a01:	5b                   	pop    %ebx
  803a02:	5e                   	pop    %esi
  803a03:	5f                   	pop    %edi
  803a04:	5d                   	pop    %ebp
  803a05:	c3                   	ret    
  803a06:	66 90                	xchg   %ax,%ax
  803a08:	89 d8                	mov    %ebx,%eax
  803a0a:	f7 f7                	div    %edi
  803a0c:	31 ff                	xor    %edi,%edi
  803a0e:	89 fa                	mov    %edi,%edx
  803a10:	83 c4 1c             	add    $0x1c,%esp
  803a13:	5b                   	pop    %ebx
  803a14:	5e                   	pop    %esi
  803a15:	5f                   	pop    %edi
  803a16:	5d                   	pop    %ebp
  803a17:	c3                   	ret    
  803a18:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a1d:	89 eb                	mov    %ebp,%ebx
  803a1f:	29 fb                	sub    %edi,%ebx
  803a21:	89 f9                	mov    %edi,%ecx
  803a23:	d3 e6                	shl    %cl,%esi
  803a25:	89 c5                	mov    %eax,%ebp
  803a27:	88 d9                	mov    %bl,%cl
  803a29:	d3 ed                	shr    %cl,%ebp
  803a2b:	89 e9                	mov    %ebp,%ecx
  803a2d:	09 f1                	or     %esi,%ecx
  803a2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a33:	89 f9                	mov    %edi,%ecx
  803a35:	d3 e0                	shl    %cl,%eax
  803a37:	89 c5                	mov    %eax,%ebp
  803a39:	89 d6                	mov    %edx,%esi
  803a3b:	88 d9                	mov    %bl,%cl
  803a3d:	d3 ee                	shr    %cl,%esi
  803a3f:	89 f9                	mov    %edi,%ecx
  803a41:	d3 e2                	shl    %cl,%edx
  803a43:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a47:	88 d9                	mov    %bl,%cl
  803a49:	d3 e8                	shr    %cl,%eax
  803a4b:	09 c2                	or     %eax,%edx
  803a4d:	89 d0                	mov    %edx,%eax
  803a4f:	89 f2                	mov    %esi,%edx
  803a51:	f7 74 24 0c          	divl   0xc(%esp)
  803a55:	89 d6                	mov    %edx,%esi
  803a57:	89 c3                	mov    %eax,%ebx
  803a59:	f7 e5                	mul    %ebp
  803a5b:	39 d6                	cmp    %edx,%esi
  803a5d:	72 19                	jb     803a78 <__udivdi3+0xfc>
  803a5f:	74 0b                	je     803a6c <__udivdi3+0xf0>
  803a61:	89 d8                	mov    %ebx,%eax
  803a63:	31 ff                	xor    %edi,%edi
  803a65:	e9 58 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a6a:	66 90                	xchg   %ax,%ax
  803a6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a70:	89 f9                	mov    %edi,%ecx
  803a72:	d3 e2                	shl    %cl,%edx
  803a74:	39 c2                	cmp    %eax,%edx
  803a76:	73 e9                	jae    803a61 <__udivdi3+0xe5>
  803a78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a7b:	31 ff                	xor    %edi,%edi
  803a7d:	e9 40 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a82:	66 90                	xchg   %ax,%ax
  803a84:	31 c0                	xor    %eax,%eax
  803a86:	e9 37 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a8b:	90                   	nop

00803a8c <__umoddi3>:
  803a8c:	55                   	push   %ebp
  803a8d:	57                   	push   %edi
  803a8e:	56                   	push   %esi
  803a8f:	53                   	push   %ebx
  803a90:	83 ec 1c             	sub    $0x1c,%esp
  803a93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a97:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aa3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803aa7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803aab:	89 f3                	mov    %esi,%ebx
  803aad:	89 fa                	mov    %edi,%edx
  803aaf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ab3:	89 34 24             	mov    %esi,(%esp)
  803ab6:	85 c0                	test   %eax,%eax
  803ab8:	75 1a                	jne    803ad4 <__umoddi3+0x48>
  803aba:	39 f7                	cmp    %esi,%edi
  803abc:	0f 86 a2 00 00 00    	jbe    803b64 <__umoddi3+0xd8>
  803ac2:	89 c8                	mov    %ecx,%eax
  803ac4:	89 f2                	mov    %esi,%edx
  803ac6:	f7 f7                	div    %edi
  803ac8:	89 d0                	mov    %edx,%eax
  803aca:	31 d2                	xor    %edx,%edx
  803acc:	83 c4 1c             	add    $0x1c,%esp
  803acf:	5b                   	pop    %ebx
  803ad0:	5e                   	pop    %esi
  803ad1:	5f                   	pop    %edi
  803ad2:	5d                   	pop    %ebp
  803ad3:	c3                   	ret    
  803ad4:	39 f0                	cmp    %esi,%eax
  803ad6:	0f 87 ac 00 00 00    	ja     803b88 <__umoddi3+0xfc>
  803adc:	0f bd e8             	bsr    %eax,%ebp
  803adf:	83 f5 1f             	xor    $0x1f,%ebp
  803ae2:	0f 84 ac 00 00 00    	je     803b94 <__umoddi3+0x108>
  803ae8:	bf 20 00 00 00       	mov    $0x20,%edi
  803aed:	29 ef                	sub    %ebp,%edi
  803aef:	89 fe                	mov    %edi,%esi
  803af1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803af5:	89 e9                	mov    %ebp,%ecx
  803af7:	d3 e0                	shl    %cl,%eax
  803af9:	89 d7                	mov    %edx,%edi
  803afb:	89 f1                	mov    %esi,%ecx
  803afd:	d3 ef                	shr    %cl,%edi
  803aff:	09 c7                	or     %eax,%edi
  803b01:	89 e9                	mov    %ebp,%ecx
  803b03:	d3 e2                	shl    %cl,%edx
  803b05:	89 14 24             	mov    %edx,(%esp)
  803b08:	89 d8                	mov    %ebx,%eax
  803b0a:	d3 e0                	shl    %cl,%eax
  803b0c:	89 c2                	mov    %eax,%edx
  803b0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b12:	d3 e0                	shl    %cl,%eax
  803b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b18:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b1c:	89 f1                	mov    %esi,%ecx
  803b1e:	d3 e8                	shr    %cl,%eax
  803b20:	09 d0                	or     %edx,%eax
  803b22:	d3 eb                	shr    %cl,%ebx
  803b24:	89 da                	mov    %ebx,%edx
  803b26:	f7 f7                	div    %edi
  803b28:	89 d3                	mov    %edx,%ebx
  803b2a:	f7 24 24             	mull   (%esp)
  803b2d:	89 c6                	mov    %eax,%esi
  803b2f:	89 d1                	mov    %edx,%ecx
  803b31:	39 d3                	cmp    %edx,%ebx
  803b33:	0f 82 87 00 00 00    	jb     803bc0 <__umoddi3+0x134>
  803b39:	0f 84 91 00 00 00    	je     803bd0 <__umoddi3+0x144>
  803b3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b43:	29 f2                	sub    %esi,%edx
  803b45:	19 cb                	sbb    %ecx,%ebx
  803b47:	89 d8                	mov    %ebx,%eax
  803b49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b4d:	d3 e0                	shl    %cl,%eax
  803b4f:	89 e9                	mov    %ebp,%ecx
  803b51:	d3 ea                	shr    %cl,%edx
  803b53:	09 d0                	or     %edx,%eax
  803b55:	89 e9                	mov    %ebp,%ecx
  803b57:	d3 eb                	shr    %cl,%ebx
  803b59:	89 da                	mov    %ebx,%edx
  803b5b:	83 c4 1c             	add    $0x1c,%esp
  803b5e:	5b                   	pop    %ebx
  803b5f:	5e                   	pop    %esi
  803b60:	5f                   	pop    %edi
  803b61:	5d                   	pop    %ebp
  803b62:	c3                   	ret    
  803b63:	90                   	nop
  803b64:	89 fd                	mov    %edi,%ebp
  803b66:	85 ff                	test   %edi,%edi
  803b68:	75 0b                	jne    803b75 <__umoddi3+0xe9>
  803b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6f:	31 d2                	xor    %edx,%edx
  803b71:	f7 f7                	div    %edi
  803b73:	89 c5                	mov    %eax,%ebp
  803b75:	89 f0                	mov    %esi,%eax
  803b77:	31 d2                	xor    %edx,%edx
  803b79:	f7 f5                	div    %ebp
  803b7b:	89 c8                	mov    %ecx,%eax
  803b7d:	f7 f5                	div    %ebp
  803b7f:	89 d0                	mov    %edx,%eax
  803b81:	e9 44 ff ff ff       	jmp    803aca <__umoddi3+0x3e>
  803b86:	66 90                	xchg   %ax,%ax
  803b88:	89 c8                	mov    %ecx,%eax
  803b8a:	89 f2                	mov    %esi,%edx
  803b8c:	83 c4 1c             	add    $0x1c,%esp
  803b8f:	5b                   	pop    %ebx
  803b90:	5e                   	pop    %esi
  803b91:	5f                   	pop    %edi
  803b92:	5d                   	pop    %ebp
  803b93:	c3                   	ret    
  803b94:	3b 04 24             	cmp    (%esp),%eax
  803b97:	72 06                	jb     803b9f <__umoddi3+0x113>
  803b99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b9d:	77 0f                	ja     803bae <__umoddi3+0x122>
  803b9f:	89 f2                	mov    %esi,%edx
  803ba1:	29 f9                	sub    %edi,%ecx
  803ba3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ba7:	89 14 24             	mov    %edx,(%esp)
  803baa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bae:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bb2:	8b 14 24             	mov    (%esp),%edx
  803bb5:	83 c4 1c             	add    $0x1c,%esp
  803bb8:	5b                   	pop    %ebx
  803bb9:	5e                   	pop    %esi
  803bba:	5f                   	pop    %edi
  803bbb:	5d                   	pop    %ebp
  803bbc:	c3                   	ret    
  803bbd:	8d 76 00             	lea    0x0(%esi),%esi
  803bc0:	2b 04 24             	sub    (%esp),%eax
  803bc3:	19 fa                	sbb    %edi,%edx
  803bc5:	89 d1                	mov    %edx,%ecx
  803bc7:	89 c6                	mov    %eax,%esi
  803bc9:	e9 71 ff ff ff       	jmp    803b3f <__umoddi3+0xb3>
  803bce:	66 90                	xchg   %ax,%ax
  803bd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bd4:	72 ea                	jb     803bc0 <__umoddi3+0x134>
  803bd6:	89 d9                	mov    %ebx,%ecx
  803bd8:	e9 62 ff ff ff       	jmp    803b3f <__umoddi3+0xb3>
