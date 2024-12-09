
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
  80005c:	68 c0 3c 80 00       	push   $0x803cc0
  800061:	6a 0d                	push   $0xd
  800063:	68 dc 3c 80 00       	push   $0x803cdc
  800068:	e8 2b 03 00 00       	call   800398 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  800074:	e8 ab 1b 00 00       	call   801c24 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int freeFrames, diff, expected;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 0e 19 00 00       	call   80198f <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 bc 19 00 00       	call   801a42 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 f7 3c 80 00       	push   $0x803cf7
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 2f 17 00 00       	call   8017c8 <sget>
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
  8000b6:	68 fc 3c 80 00       	push   $0x803cfc
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 dc 3c 80 00       	push   $0x803cdc
  8000c2:	e8 d1 02 00 00       	call   800398 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 6c 19 00 00       	call   801a42 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 55 19 00 00       	call   801a42 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 78 3d 80 00       	push   $0x803d78
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 dc 3c 80 00       	push   $0x803cdc
  800104:	e8 8f 02 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 9b 18 00 00       	call   8019a9 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 7c 18 00 00       	call   80198f <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 2a 19 00 00       	call   801a42 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 10 3e 80 00       	push   $0x803e10
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 9d 16 00 00       	call   8017c8 <sget>
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
  80014d:	68 fc 3c 80 00       	push   $0x803cfc
  800152:	6a 31                	push   $0x31
  800154:	68 dc 3c 80 00       	push   $0x803cdc
  800159:	e8 3a 02 00 00       	call   800398 <_panic>
		expected = 0;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 d5 18 00 00       	call   801a42 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 be 18 00 00       	call   801a42 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 78 3d 80 00       	push   $0x803d78
  800194:	6a 34                	push   $0x34
  800196:	68 dc 3c 80 00       	push   $0x803cdc
  80019b:	e8 f8 01 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 04 18 00 00       	call   8019a9 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 0a             	cmp    $0xa,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 14 3e 80 00       	push   $0x803e14
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 dc 3c 80 00       	push   $0x803cdc
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
  8001d9:	68 14 3e 80 00       	push   $0x803e14
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 dc 3c 80 00       	push   $0x803cdc
  8001e5:	e8 ae 01 00 00       	call   800398 <_panic>

	inctst();
  8001ea:	e8 5a 1b 00 00       	call   801d49 <inctst>

	//sync with master
	while (gettst() != 5) ;
  8001ef:	90                   	nop
  8001f0:	e8 6e 1b 00 00       	call   801d63 <gettst>
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	75 f6                	jne    8001f0 <_main+0x1b8>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 06                	push   $0x6
  8001ff:	e8 bf 1a 00 00       	call   801cc3 <sys_bypassPageFault>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	68 4c 3e 80 00       	push   $0x803e4c
  800212:	e8 3e 04 00 00       	call   800655 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 96 1a 00 00       	call   801cc3 <sys_bypassPageFault>
  80022d:	83 c4 10             	add    $0x10,%esp

	inctst();
  800230:	e8 14 1b 00 00       	call   801d49 <inctst>
	if (*x == 100)
  800235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	83 f8 64             	cmp    $0x64,%eax
  80023d:	75 14                	jne    800253 <_main+0x21b>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 7c 3e 80 00       	push   $0x803e7c
  800247:	6a 4d                	push   $0x4d
  800249:	68 dc 3c 80 00       	push   $0x803cdc
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
  80025f:	e8 a7 19 00 00       	call   801c0b <sys_getenvindex>
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
  8002cd:	e8 bd 16 00 00       	call   80198f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	68 dc 3e 80 00       	push   $0x803edc
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
  8002fd:	68 04 3f 80 00       	push   $0x803f04
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
  80032e:	68 2c 3f 80 00       	push   $0x803f2c
  800333:	e8 1d 03 00 00       	call   800655 <cprintf>
  800338:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80033b:	a1 20 50 80 00       	mov    0x805020,%eax
  800340:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	50                   	push   %eax
  80034a:	68 84 3f 80 00       	push   $0x803f84
  80034f:	e8 01 03 00 00       	call   800655 <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	68 dc 3e 80 00       	push   $0x803edc
  80035f:	e8 f1 02 00 00       	call   800655 <cprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800367:	e8 3d 16 00 00       	call   8019a9 <sys_unlock_cons>
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
  80037f:	e8 53 18 00 00       	call   801bd7 <sys_destroy_env>
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
  800390:	e8 a8 18 00 00       	call   801c3d <sys_exit_env>
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
  8003b9:	68 98 3f 80 00       	push   $0x803f98
  8003be:	e8 92 02 00 00       	call   800655 <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003c6:	a1 00 50 80 00       	mov    0x805000,%eax
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	50                   	push   %eax
  8003d2:	68 9d 3f 80 00       	push   $0x803f9d
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
  8003f6:	68 b9 3f 80 00       	push   $0x803fb9
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
  800425:	68 bc 3f 80 00       	push   $0x803fbc
  80042a:	6a 26                	push   $0x26
  80042c:	68 08 40 80 00       	push   $0x804008
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
  8004fa:	68 14 40 80 00       	push   $0x804014
  8004ff:	6a 3a                	push   $0x3a
  800501:	68 08 40 80 00       	push   $0x804008
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
  80056d:	68 68 40 80 00       	push   $0x804068
  800572:	6a 44                	push   $0x44
  800574:	68 08 40 80 00       	push   $0x804008
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
  8005c7:	e8 81 13 00 00       	call   80194d <sys_cputs>
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
  80063e:	e8 0a 13 00 00       	call   80194d <sys_cputs>
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
  800688:	e8 02 13 00 00       	call   80198f <sys_lock_cons>
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
  8006a8:	e8 fc 12 00 00       	call   8019a9 <sys_unlock_cons>
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
  8006f2:	e8 59 33 00 00       	call   803a50 <__udivdi3>
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
  800742:	e8 19 34 00 00       	call   803b60 <__umoddi3>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	05 d4 42 80 00       	add    $0x8042d4,%eax
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
  80089d:	8b 04 85 f8 42 80 00 	mov    0x8042f8(,%eax,4),%eax
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
  80097e:	8b 34 9d 40 41 80 00 	mov    0x804140(,%ebx,4),%esi
  800985:	85 f6                	test   %esi,%esi
  800987:	75 19                	jne    8009a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800989:	53                   	push   %ebx
  80098a:	68 e5 42 80 00       	push   $0x8042e5
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
  8009a3:	68 ee 42 80 00       	push   $0x8042ee
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
  8009d0:	be f1 42 80 00       	mov    $0x8042f1,%esi
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
  8013db:	68 68 44 80 00       	push   $0x804468
  8013e0:	68 3f 01 00 00       	push   $0x13f
  8013e5:	68 8a 44 80 00       	push   $0x80448a
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
  8013fb:	e8 f8 0a 00 00       	call   801ef8 <sys_sbrk>
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
  801476:	e8 01 09 00 00       	call   801d7c <sys_isUHeapPlacementStrategyFIRSTFIT>
  80147b:	85 c0                	test   %eax,%eax
  80147d:	74 16                	je     801495 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	e8 dd 0e 00 00       	call   802367 <alloc_block_FF>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801490:	e9 8a 01 00 00       	jmp    80161f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801495:	e8 13 09 00 00       	call   801dad <sys_isUHeapPlacementStrategyBESTFIT>
  80149a:	85 c0                	test   %eax,%eax
  80149c:	0f 84 7d 01 00 00    	je     80161f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 76 13 00 00       	call   802823 <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150a:	05 00 10 00 00       	add    $0x1000,%eax
  80150f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801512:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  8015b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015b6:	75 16                	jne    8015ce <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8015b8:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8015bf:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8015c6:	0f 86 15 ff ff ff    	jbe    8014e1 <malloc+0xdc>
  8015cc:	eb 01                	jmp    8015cf <malloc+0x1ca>
				}
				

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
  80160e:	e8 1c 09 00 00       	call   801f2f <sys_allocate_user_mem>
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	eb 07                	jmp    80161f <malloc+0x21a>
		
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
  801656:	e8 8c 09 00 00       	call   801fe7 <get_block_size>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	e8 9c 1b 00 00       	call   803208 <free_block>
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
  8016a1:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  8016de:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  8016e5:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8016e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	52                   	push   %edx
  8016f3:	50                   	push   %eax
  8016f4:	e8 1a 08 00 00       	call   801f13 <sys_free_user_mem>
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
  80170c:	68 98 44 80 00       	push   $0x804498
  801711:	68 87 00 00 00       	push   $0x87
  801716:	68 c2 44 80 00       	push   $0x8044c2
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
  80173a:	e9 87 00 00 00       	jmp    8017c6 <smalloc+0xa3>
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
  80176b:	75 07                	jne    801774 <smalloc+0x51>
  80176d:	b8 00 00 00 00       	mov    $0x0,%eax
  801772:	eb 52                	jmp    8017c6 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801774:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801778:	ff 75 ec             	pushl  -0x14(%ebp)
  80177b:	50                   	push   %eax
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	ff 75 08             	pushl  0x8(%ebp)
  801782:	e8 93 03 00 00       	call   801b1a <sys_createSharedObject>
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80178d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801791:	74 06                	je     801799 <smalloc+0x76>
  801793:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801797:	75 07                	jne    8017a0 <smalloc+0x7d>
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
  80179e:	eb 26                	jmp    8017c6 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8017a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8017a8:	8b 40 78             	mov    0x78(%eax),%eax
  8017ab:	29 c2                	sub    %eax,%edx
  8017ad:	89 d0                	mov    %edx,%eax
  8017af:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017b4:	c1 e8 0c             	shr    $0xc,%eax
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017bc:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8017c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017ce:	83 ec 08             	sub    $0x8,%esp
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	e8 68 03 00 00       	call   801b44 <sys_getSizeOfSharedObject>
  8017dc:	83 c4 10             	add    $0x10,%esp
  8017df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8017e2:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017e6:	75 07                	jne    8017ef <sget+0x27>
  8017e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ed:	eb 7f                	jmp    80186e <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8017ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017f5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801802:	39 d0                	cmp    %edx,%eax
  801804:	73 02                	jae    801808 <sget+0x40>
  801806:	89 d0                	mov    %edx,%eax
  801808:	83 ec 0c             	sub    $0xc,%esp
  80180b:	50                   	push   %eax
  80180c:	e8 f4 fb ff ff       	call   801405 <malloc>
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801817:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80181b:	75 07                	jne    801824 <sget+0x5c>
  80181d:	b8 00 00 00 00       	mov    $0x0,%eax
  801822:	eb 4a                	jmp    80186e <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801824:	83 ec 04             	sub    $0x4,%esp
  801827:	ff 75 e8             	pushl  -0x18(%ebp)
  80182a:	ff 75 0c             	pushl  0xc(%ebp)
  80182d:	ff 75 08             	pushl  0x8(%ebp)
  801830:	e8 2c 03 00 00       	call   801b61 <sys_getSharedObject>
  801835:	83 c4 10             	add    $0x10,%esp
  801838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80183b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80183e:	a1 20 50 80 00       	mov    0x805020,%eax
  801843:	8b 40 78             	mov    0x78(%eax),%eax
  801846:	29 c2                	sub    %eax,%edx
  801848:	89 d0                	mov    %edx,%eax
  80184a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80184f:	c1 e8 0c             	shr    $0xc,%eax
  801852:	89 c2                	mov    %eax,%edx
  801854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801857:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80185e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801862:	75 07                	jne    80186b <sget+0xa3>
  801864:	b8 00 00 00 00       	mov    $0x0,%eax
  801869:	eb 03                	jmp    80186e <sget+0xa6>
	return ptr;
  80186b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801876:	8b 55 08             	mov    0x8(%ebp),%edx
  801879:	a1 20 50 80 00       	mov    0x805020,%eax
  80187e:	8b 40 78             	mov    0x78(%eax),%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
  801885:	2d 00 10 00 00       	sub    $0x1000,%eax
  80188a:	c1 e8 0c             	shr    $0xc,%eax
  80188d:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801894:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801897:	83 ec 08             	sub    $0x8,%esp
  80189a:	ff 75 08             	pushl  0x8(%ebp)
  80189d:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a0:	e8 db 02 00 00       	call   801b80 <sys_freeSharedObject>
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018ab:	90                   	nop
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	68 d0 44 80 00       	push   $0x8044d0
  8018bc:	68 e4 00 00 00       	push   $0xe4
  8018c1:	68 c2 44 80 00       	push   $0x8044c2
  8018c6:	e8 cd ea ff ff       	call   800398 <_panic>

008018cb <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d1:	83 ec 04             	sub    $0x4,%esp
  8018d4:	68 f6 44 80 00       	push   $0x8044f6
  8018d9:	68 f0 00 00 00       	push   $0xf0
  8018de:	68 c2 44 80 00       	push   $0x8044c2
  8018e3:	e8 b0 ea ff ff       	call   800398 <_panic>

008018e8 <shrink>:

}
void shrink(uint32 newSize)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	68 f6 44 80 00       	push   $0x8044f6
  8018f6:	68 f5 00 00 00       	push   $0xf5
  8018fb:	68 c2 44 80 00       	push   $0x8044c2
  801900:	e8 93 ea ff ff       	call   800398 <_panic>

00801905 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80190b:	83 ec 04             	sub    $0x4,%esp
  80190e:	68 f6 44 80 00       	push   $0x8044f6
  801913:	68 fa 00 00 00       	push   $0xfa
  801918:	68 c2 44 80 00       	push   $0x8044c2
  80191d:	e8 76 ea ff ff       	call   800398 <_panic>

00801922 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	57                   	push   %edi
  801926:	56                   	push   %esi
  801927:	53                   	push   %ebx
  801928:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801931:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801934:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801937:	8b 7d 18             	mov    0x18(%ebp),%edi
  80193a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80193d:	cd 30                	int    $0x30
  80193f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801942:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	5b                   	pop    %ebx
  801949:	5e                   	pop    %esi
  80194a:	5f                   	pop    %edi
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    

0080194d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	8b 45 10             	mov    0x10(%ebp),%eax
  801956:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801959:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	52                   	push   %edx
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	50                   	push   %eax
  801969:	6a 00                	push   $0x0
  80196b:	e8 b2 ff ff ff       	call   801922 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	90                   	nop
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_cgetc>:

int
sys_cgetc(void)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 02                	push   $0x2
  801985:	e8 98 ff ff ff       	call   801922 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 03                	push   $0x3
  80199e:	e8 7f ff ff ff       	call   801922 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	90                   	nop
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 04                	push   $0x4
  8019b8:	e8 65 ff ff ff       	call   801922 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	90                   	nop
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	52                   	push   %edx
  8019d3:	50                   	push   %eax
  8019d4:	6a 08                	push   $0x8
  8019d6:	e8 47 ff ff ff       	call   801922 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	56                   	push   %esi
  8019e4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019e5:	8b 75 18             	mov    0x18(%ebp),%esi
  8019e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	56                   	push   %esi
  8019f5:	53                   	push   %ebx
  8019f6:	51                   	push   %ecx
  8019f7:	52                   	push   %edx
  8019f8:	50                   	push   %eax
  8019f9:	6a 09                	push   $0x9
  8019fb:	e8 22 ff ff ff       	call   801922 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a06:	5b                   	pop    %ebx
  801a07:	5e                   	pop    %esi
  801a08:	5d                   	pop    %ebp
  801a09:	c3                   	ret    

00801a0a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	52                   	push   %edx
  801a1a:	50                   	push   %eax
  801a1b:	6a 0a                	push   $0xa
  801a1d:	e8 00 ff ff ff       	call   801922 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	6a 0b                	push   $0xb
  801a38:	e8 e5 fe ff ff       	call   801922 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 0c                	push   $0xc
  801a51:	e8 cc fe ff ff       	call   801922 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 0d                	push   $0xd
  801a6a:	e8 b3 fe ff ff       	call   801922 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 0e                	push   $0xe
  801a83:	e8 9a fe ff ff       	call   801922 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 0f                	push   $0xf
  801a9c:	e8 81 fe ff ff       	call   801922 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	6a 10                	push   $0x10
  801ab6:	e8 67 fe ff ff       	call   801922 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 11                	push   $0x11
  801acf:	e8 4e fe ff ff       	call   801922 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	90                   	nop
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_cputc>:

void
sys_cputc(const char c)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 04             	sub    $0x4,%esp
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ae6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	50                   	push   %eax
  801af3:	6a 01                	push   $0x1
  801af5:	e8 28 fe ff ff       	call   801922 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	90                   	nop
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 14                	push   $0x14
  801b0f:	e8 0e fe ff ff       	call   801922 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	90                   	nop
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 04             	sub    $0x4,%esp
  801b20:	8b 45 10             	mov    0x10(%ebp),%eax
  801b23:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b26:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b29:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	6a 00                	push   $0x0
  801b32:	51                   	push   %ecx
  801b33:	52                   	push   %edx
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	50                   	push   %eax
  801b38:	6a 15                	push   $0x15
  801b3a:	e8 e3 fd ff ff       	call   801922 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	52                   	push   %edx
  801b54:	50                   	push   %eax
  801b55:	6a 16                	push   $0x16
  801b57:	e8 c6 fd ff ff       	call   801922 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	51                   	push   %ecx
  801b72:	52                   	push   %edx
  801b73:	50                   	push   %eax
  801b74:	6a 17                	push   $0x17
  801b76:	e8 a7 fd ff ff       	call   801922 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	52                   	push   %edx
  801b90:	50                   	push   %eax
  801b91:	6a 18                	push   $0x18
  801b93:	e8 8a fd ff ff       	call   801922 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	ff 75 14             	pushl  0x14(%ebp)
  801ba8:	ff 75 10             	pushl  0x10(%ebp)
  801bab:	ff 75 0c             	pushl  0xc(%ebp)
  801bae:	50                   	push   %eax
  801baf:	6a 19                	push   $0x19
  801bb1:	e8 6c fd ff ff       	call   801922 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	50                   	push   %eax
  801bca:	6a 1a                	push   $0x1a
  801bcc:	e8 51 fd ff ff       	call   801922 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	90                   	nop
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	50                   	push   %eax
  801be6:	6a 1b                	push   $0x1b
  801be8:	e8 35 fd ff ff       	call   801922 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 05                	push   $0x5
  801c01:	e8 1c fd ff ff       	call   801922 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 06                	push   $0x6
  801c1a:	e8 03 fd ff ff       	call   801922 <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 07                	push   $0x7
  801c33:	e8 ea fc ff ff       	call   801922 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_exit_env>:


void sys_exit_env(void)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 1c                	push   $0x1c
  801c4c:	e8 d1 fc ff ff       	call   801922 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	90                   	nop
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c5d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c60:	8d 50 04             	lea    0x4(%eax),%edx
  801c63:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	52                   	push   %edx
  801c6d:	50                   	push   %eax
  801c6e:	6a 1d                	push   $0x1d
  801c70:	e8 ad fc ff ff       	call   801922 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
	return result;
  801c78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c81:	89 01                	mov    %eax,(%ecx)
  801c83:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	c9                   	leave  
  801c8a:	c2 04 00             	ret    $0x4

00801c8d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	ff 75 10             	pushl  0x10(%ebp)
  801c97:	ff 75 0c             	pushl  0xc(%ebp)
  801c9a:	ff 75 08             	pushl  0x8(%ebp)
  801c9d:	6a 13                	push   $0x13
  801c9f:	e8 7e fc ff ff       	call   801922 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca7:	90                   	nop
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_rcr2>:
uint32 sys_rcr2()
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 1e                	push   $0x1e
  801cb9:	e8 64 fc ff ff       	call   801922 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ccf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	50                   	push   %eax
  801cdc:	6a 1f                	push   $0x1f
  801cde:	e8 3f fc ff ff       	call   801922 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce6:	90                   	nop
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <rsttst>:
void rsttst()
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 21                	push   $0x21
  801cf8:	e8 25 fc ff ff       	call   801922 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
	return ;
  801d00:	90                   	nop
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d0f:	8b 55 18             	mov    0x18(%ebp),%edx
  801d12:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d16:	52                   	push   %edx
  801d17:	50                   	push   %eax
  801d18:	ff 75 10             	pushl  0x10(%ebp)
  801d1b:	ff 75 0c             	pushl  0xc(%ebp)
  801d1e:	ff 75 08             	pushl  0x8(%ebp)
  801d21:	6a 20                	push   $0x20
  801d23:	e8 fa fb ff ff       	call   801922 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2b:	90                   	nop
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <chktst>:
void chktst(uint32 n)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	ff 75 08             	pushl  0x8(%ebp)
  801d3c:	6a 22                	push   $0x22
  801d3e:	e8 df fb ff ff       	call   801922 <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
	return ;
  801d46:	90                   	nop
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <inctst>:

void inctst()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 23                	push   $0x23
  801d58:	e8 c5 fb ff ff       	call   801922 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d60:	90                   	nop
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <gettst>:
uint32 gettst()
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 24                	push   $0x24
  801d72:	e8 ab fb ff ff       	call   801922 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 25                	push   $0x25
  801d8e:	e8 8f fb ff ff       	call   801922 <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
  801d96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d99:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d9d:	75 07                	jne    801da6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801da4:	eb 05                	jmp    801dab <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801da6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 25                	push   $0x25
  801dbf:	e8 5e fb ff ff       	call   801922 <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
  801dc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dca:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dce:	75 07                	jne    801dd7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd5:	eb 05                	jmp    801ddc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 25                	push   $0x25
  801df0:	e8 2d fb ff ff       	call   801922 <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
  801df8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dfb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dff:	75 07                	jne    801e08 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e01:	b8 01 00 00 00       	mov    $0x1,%eax
  801e06:	eb 05                	jmp    801e0d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 25                	push   $0x25
  801e21:	e8 fc fa ff ff       	call   801922 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
  801e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e2c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e30:	75 07                	jne    801e39 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e32:	b8 01 00 00 00       	mov    $0x1,%eax
  801e37:	eb 05                	jmp    801e3e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	ff 75 08             	pushl  0x8(%ebp)
  801e4e:	6a 26                	push   $0x26
  801e50:	e8 cd fa ff ff       	call   801922 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
	return ;
  801e58:	90                   	nop
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e5f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	6a 00                	push   $0x0
  801e6d:	53                   	push   %ebx
  801e6e:	51                   	push   %ecx
  801e6f:	52                   	push   %edx
  801e70:	50                   	push   %eax
  801e71:	6a 27                	push   $0x27
  801e73:	e8 aa fa ff ff       	call   801922 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	52                   	push   %edx
  801e90:	50                   	push   %eax
  801e91:	6a 28                	push   $0x28
  801e93:	e8 8a fa ff ff       	call   801922 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ea0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	6a 00                	push   $0x0
  801eab:	51                   	push   %ecx
  801eac:	ff 75 10             	pushl  0x10(%ebp)
  801eaf:	52                   	push   %edx
  801eb0:	50                   	push   %eax
  801eb1:	6a 29                	push   $0x29
  801eb3:	e8 6a fa ff ff       	call   801922 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	ff 75 10             	pushl  0x10(%ebp)
  801ec7:	ff 75 0c             	pushl  0xc(%ebp)
  801eca:	ff 75 08             	pushl  0x8(%ebp)
  801ecd:	6a 12                	push   $0x12
  801ecf:	e8 4e fa ff ff       	call   801922 <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed7:	90                   	nop
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801edd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	52                   	push   %edx
  801eea:	50                   	push   %eax
  801eeb:	6a 2a                	push   $0x2a
  801eed:	e8 30 fa ff ff       	call   801922 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
	return;
  801ef5:	90                   	nop
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	50                   	push   %eax
  801f07:	6a 2b                	push   $0x2b
  801f09:	e8 14 fa ff ff       	call   801922 <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	ff 75 08             	pushl  0x8(%ebp)
  801f22:	6a 2c                	push   $0x2c
  801f24:	e8 f9 f9 ff ff       	call   801922 <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
	return;
  801f2c:	90                   	nop
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	ff 75 0c             	pushl  0xc(%ebp)
  801f3b:	ff 75 08             	pushl  0x8(%ebp)
  801f3e:	6a 2d                	push   $0x2d
  801f40:	e8 dd f9 ff ff       	call   801922 <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
	return;
  801f48:	90                   	nop
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 2e                	push   $0x2e
  801f5d:	e8 c0 f9 ff ff       	call   801922 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
  801f65:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	50                   	push   %eax
  801f7c:	6a 2f                	push   $0x2f
  801f7e:	e8 9f f9 ff ff       	call   801922 <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
	return;
  801f86:	90                   	nop
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801f8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	52                   	push   %edx
  801f99:	50                   	push   %eax
  801f9a:	6a 30                	push   $0x30
  801f9c:	e8 81 f9 ff ff       	call   801922 <syscall>
  801fa1:	83 c4 18             	add    $0x18,%esp
	return;
  801fa4:	90                   	nop
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	50                   	push   %eax
  801fb9:	6a 31                	push   $0x31
  801fbb:	e8 62 f9 ff ff       	call   801922 <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
  801fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801fc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	50                   	push   %eax
  801fda:	6a 32                	push   $0x32
  801fdc:	e8 41 f9 ff ff       	call   801922 <syscall>
  801fe1:	83 c4 18             	add    $0x18,%esp
	return;
  801fe4:	90                   	nop
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	83 e8 04             	sub    $0x4,%eax
  801ff3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff9:	8b 00                	mov    (%eax),%eax
  801ffb:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	83 e8 04             	sub    $0x4,%eax
  80200c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80200f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802012:	8b 00                	mov    (%eax),%eax
  802014:	83 e0 01             	and    $0x1,%eax
  802017:	85 c0                	test   %eax,%eax
  802019:	0f 94 c0             	sete   %al
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802024:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80202b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202e:	83 f8 02             	cmp    $0x2,%eax
  802031:	74 2b                	je     80205e <alloc_block+0x40>
  802033:	83 f8 02             	cmp    $0x2,%eax
  802036:	7f 07                	jg     80203f <alloc_block+0x21>
  802038:	83 f8 01             	cmp    $0x1,%eax
  80203b:	74 0e                	je     80204b <alloc_block+0x2d>
  80203d:	eb 58                	jmp    802097 <alloc_block+0x79>
  80203f:	83 f8 03             	cmp    $0x3,%eax
  802042:	74 2d                	je     802071 <alloc_block+0x53>
  802044:	83 f8 04             	cmp    $0x4,%eax
  802047:	74 3b                	je     802084 <alloc_block+0x66>
  802049:	eb 4c                	jmp    802097 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80204b:	83 ec 0c             	sub    $0xc,%esp
  80204e:	ff 75 08             	pushl  0x8(%ebp)
  802051:	e8 11 03 00 00       	call   802367 <alloc_block_FF>
  802056:	83 c4 10             	add    $0x10,%esp
  802059:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80205c:	eb 4a                	jmp    8020a8 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80205e:	83 ec 0c             	sub    $0xc,%esp
  802061:	ff 75 08             	pushl  0x8(%ebp)
  802064:	e8 c7 19 00 00       	call   803a30 <alloc_block_NF>
  802069:	83 c4 10             	add    $0x10,%esp
  80206c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80206f:	eb 37                	jmp    8020a8 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802071:	83 ec 0c             	sub    $0xc,%esp
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	e8 a7 07 00 00       	call   802823 <alloc_block_BF>
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802082:	eb 24                	jmp    8020a8 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802084:	83 ec 0c             	sub    $0xc,%esp
  802087:	ff 75 08             	pushl  0x8(%ebp)
  80208a:	e8 84 19 00 00       	call   803a13 <alloc_block_WF>
  80208f:	83 c4 10             	add    $0x10,%esp
  802092:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802095:	eb 11                	jmp    8020a8 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802097:	83 ec 0c             	sub    $0xc,%esp
  80209a:	68 08 45 80 00       	push   $0x804508
  80209f:	e8 b1 e5 ff ff       	call   800655 <cprintf>
  8020a4:	83 c4 10             	add    $0x10,%esp
		break;
  8020a7:	90                   	nop
	}
	return va;
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	53                   	push   %ebx
  8020b1:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8020b4:	83 ec 0c             	sub    $0xc,%esp
  8020b7:	68 28 45 80 00       	push   $0x804528
  8020bc:	e8 94 e5 ff ff       	call   800655 <cprintf>
  8020c1:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8020c4:	83 ec 0c             	sub    $0xc,%esp
  8020c7:	68 53 45 80 00       	push   $0x804553
  8020cc:	e8 84 e5 ff ff       	call   800655 <cprintf>
  8020d1:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020da:	eb 37                	jmp    802113 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e2:	e8 19 ff ff ff       	call   802000 <is_free_block>
  8020e7:	83 c4 10             	add    $0x10,%esp
  8020ea:	0f be d8             	movsbl %al,%ebx
  8020ed:	83 ec 0c             	sub    $0xc,%esp
  8020f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f3:	e8 ef fe ff ff       	call   801fe7 <get_block_size>
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	83 ec 04             	sub    $0x4,%esp
  8020fe:	53                   	push   %ebx
  8020ff:	50                   	push   %eax
  802100:	68 6b 45 80 00       	push   $0x80456b
  802105:	e8 4b e5 ff ff       	call   800655 <cprintf>
  80210a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80210d:	8b 45 10             	mov    0x10(%ebp),%eax
  802110:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802113:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802117:	74 07                	je     802120 <print_blocks_list+0x73>
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	8b 00                	mov    (%eax),%eax
  80211e:	eb 05                	jmp    802125 <print_blocks_list+0x78>
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
  802125:	89 45 10             	mov    %eax,0x10(%ebp)
  802128:	8b 45 10             	mov    0x10(%ebp),%eax
  80212b:	85 c0                	test   %eax,%eax
  80212d:	75 ad                	jne    8020dc <print_blocks_list+0x2f>
  80212f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802133:	75 a7                	jne    8020dc <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802135:	83 ec 0c             	sub    $0xc,%esp
  802138:	68 28 45 80 00       	push   $0x804528
  80213d:	e8 13 e5 ff ff       	call   800655 <cprintf>
  802142:	83 c4 10             	add    $0x10,%esp

}
  802145:	90                   	nop
  802146:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802151:	8b 45 0c             	mov    0xc(%ebp),%eax
  802154:	83 e0 01             	and    $0x1,%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	74 03                	je     80215e <initialize_dynamic_allocator+0x13>
  80215b:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80215e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802162:	0f 84 c7 01 00 00    	je     80232f <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802168:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80216f:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802172:	8b 55 08             	mov    0x8(%ebp),%edx
  802175:	8b 45 0c             	mov    0xc(%ebp),%eax
  802178:	01 d0                	add    %edx,%eax
  80217a:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80217f:	0f 87 ad 01 00 00    	ja     802332 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	0f 89 a5 01 00 00    	jns    802335 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802190:	8b 55 08             	mov    0x8(%ebp),%edx
  802193:	8b 45 0c             	mov    0xc(%ebp),%eax
  802196:	01 d0                	add    %edx,%eax
  802198:	83 e8 04             	sub    $0x4,%eax
  80219b:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8021a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8021a7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021af:	e9 87 00 00 00       	jmp    80223b <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8021b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b8:	75 14                	jne    8021ce <initialize_dynamic_allocator+0x83>
  8021ba:	83 ec 04             	sub    $0x4,%esp
  8021bd:	68 83 45 80 00       	push   $0x804583
  8021c2:	6a 79                	push   $0x79
  8021c4:	68 a1 45 80 00       	push   $0x8045a1
  8021c9:	e8 ca e1 ff ff       	call   800398 <_panic>
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	8b 00                	mov    (%eax),%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 10                	je     8021e7 <initialize_dynamic_allocator+0x9c>
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	8b 00                	mov    (%eax),%eax
  8021dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021df:	8b 52 04             	mov    0x4(%edx),%edx
  8021e2:	89 50 04             	mov    %edx,0x4(%eax)
  8021e5:	eb 0b                	jmp    8021f2 <initialize_dynamic_allocator+0xa7>
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	8b 40 04             	mov    0x4(%eax),%eax
  8021ed:	a3 30 50 80 00       	mov    %eax,0x805030
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	8b 40 04             	mov    0x4(%eax),%eax
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	74 0f                	je     80220b <initialize_dynamic_allocator+0xc0>
  8021fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ff:	8b 40 04             	mov    0x4(%eax),%eax
  802202:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802205:	8b 12                	mov    (%edx),%edx
  802207:	89 10                	mov    %edx,(%eax)
  802209:	eb 0a                	jmp    802215 <initialize_dynamic_allocator+0xca>
  80220b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220e:	8b 00                	mov    (%eax),%eax
  802210:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802218:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802228:	a1 38 50 80 00       	mov    0x805038,%eax
  80222d:	48                   	dec    %eax
  80222e:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802233:	a1 34 50 80 00       	mov    0x805034,%eax
  802238:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80223b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223f:	74 07                	je     802248 <initialize_dynamic_allocator+0xfd>
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 00                	mov    (%eax),%eax
  802246:	eb 05                	jmp    80224d <initialize_dynamic_allocator+0x102>
  802248:	b8 00 00 00 00       	mov    $0x0,%eax
  80224d:	a3 34 50 80 00       	mov    %eax,0x805034
  802252:	a1 34 50 80 00       	mov    0x805034,%eax
  802257:	85 c0                	test   %eax,%eax
  802259:	0f 85 55 ff ff ff    	jne    8021b4 <initialize_dynamic_allocator+0x69>
  80225f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802263:	0f 85 4b ff ff ff    	jne    8021b4 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80226f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802272:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802278:	a1 44 50 80 00       	mov    0x805044,%eax
  80227d:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802282:	a1 40 50 80 00       	mov    0x805040,%eax
  802287:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	83 c0 08             	add    $0x8,%eax
  802293:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	83 c0 04             	add    $0x4,%eax
  80229c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229f:	83 ea 08             	sub    $0x8,%edx
  8022a2:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	01 d0                	add    %edx,%eax
  8022ac:	83 e8 08             	sub    $0x8,%eax
  8022af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b2:	83 ea 08             	sub    $0x8,%edx
  8022b5:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8022b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8022c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8022ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022ce:	75 17                	jne    8022e7 <initialize_dynamic_allocator+0x19c>
  8022d0:	83 ec 04             	sub    $0x4,%esp
  8022d3:	68 bc 45 80 00       	push   $0x8045bc
  8022d8:	68 90 00 00 00       	push   $0x90
  8022dd:	68 a1 45 80 00       	push   $0x8045a1
  8022e2:	e8 b1 e0 ff ff       	call   800398 <_panic>
  8022e7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f0:	89 10                	mov    %edx,(%eax)
  8022f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f5:	8b 00                	mov    (%eax),%eax
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	74 0d                	je     802308 <initialize_dynamic_allocator+0x1bd>
  8022fb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802300:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802303:	89 50 04             	mov    %edx,0x4(%eax)
  802306:	eb 08                	jmp    802310 <initialize_dynamic_allocator+0x1c5>
  802308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230b:	a3 30 50 80 00       	mov    %eax,0x805030
  802310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802313:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802322:	a1 38 50 80 00       	mov    0x805038,%eax
  802327:	40                   	inc    %eax
  802328:	a3 38 50 80 00       	mov    %eax,0x805038
  80232d:	eb 07                	jmp    802336 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80232f:	90                   	nop
  802330:	eb 04                	jmp    802336 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802332:	90                   	nop
  802333:	eb 01                	jmp    802336 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802335:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80233b:	8b 45 10             	mov    0x10(%ebp),%eax
  80233e:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	8d 50 fc             	lea    -0x4(%eax),%edx
  802347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234a:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	83 e8 04             	sub    $0x4,%eax
  802352:	8b 00                	mov    (%eax),%eax
  802354:	83 e0 fe             	and    $0xfffffffe,%eax
  802357:	8d 50 f8             	lea    -0x8(%eax),%edx
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	01 c2                	add    %eax,%edx
  80235f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802362:	89 02                	mov    %eax,(%edx)
}
  802364:	90                   	nop
  802365:	5d                   	pop    %ebp
  802366:	c3                   	ret    

00802367 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	83 e0 01             	and    $0x1,%eax
  802373:	85 c0                	test   %eax,%eax
  802375:	74 03                	je     80237a <alloc_block_FF+0x13>
  802377:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80237a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80237e:	77 07                	ja     802387 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802380:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802387:	a1 24 50 80 00       	mov    0x805024,%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	75 73                	jne    802403 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	83 c0 10             	add    $0x10,%eax
  802396:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802399:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a6:	01 d0                	add    %edx,%eax
  8023a8:	48                   	dec    %eax
  8023a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023af:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b4:	f7 75 ec             	divl   -0x14(%ebp)
  8023b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ba:	29 d0                	sub    %edx,%eax
  8023bc:	c1 e8 0c             	shr    $0xc,%eax
  8023bf:	83 ec 0c             	sub    $0xc,%esp
  8023c2:	50                   	push   %eax
  8023c3:	e8 27 f0 ff ff       	call   8013ef <sbrk>
  8023c8:	83 c4 10             	add    $0x10,%esp
  8023cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8023ce:	83 ec 0c             	sub    $0xc,%esp
  8023d1:	6a 00                	push   $0x0
  8023d3:	e8 17 f0 ff ff       	call   8013ef <sbrk>
  8023d8:	83 c4 10             	add    $0x10,%esp
  8023db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8023de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023e1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8023e4:	83 ec 08             	sub    $0x8,%esp
  8023e7:	50                   	push   %eax
  8023e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023eb:	e8 5b fd ff ff       	call   80214b <initialize_dynamic_allocator>
  8023f0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8023f3:	83 ec 0c             	sub    $0xc,%esp
  8023f6:	68 df 45 80 00       	push   $0x8045df
  8023fb:	e8 55 e2 ff ff       	call   800655 <cprintf>
  802400:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802403:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802407:	75 0a                	jne    802413 <alloc_block_FF+0xac>
	        return NULL;
  802409:	b8 00 00 00 00       	mov    $0x0,%eax
  80240e:	e9 0e 04 00 00       	jmp    802821 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802413:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80241a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80241f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802422:	e9 f3 02 00 00       	jmp    80271a <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80242d:	83 ec 0c             	sub    $0xc,%esp
  802430:	ff 75 bc             	pushl  -0x44(%ebp)
  802433:	e8 af fb ff ff       	call   801fe7 <get_block_size>
  802438:	83 c4 10             	add    $0x10,%esp
  80243b:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	83 c0 08             	add    $0x8,%eax
  802444:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802447:	0f 87 c5 02 00 00    	ja     802712 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	83 c0 18             	add    $0x18,%eax
  802453:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802456:	0f 87 19 02 00 00    	ja     802675 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80245c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80245f:	2b 45 08             	sub    0x8(%ebp),%eax
  802462:	83 e8 08             	sub    $0x8,%eax
  802465:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	8d 50 08             	lea    0x8(%eax),%edx
  80246e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802471:	01 d0                	add    %edx,%eax
  802473:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	83 c0 08             	add    $0x8,%eax
  80247c:	83 ec 04             	sub    $0x4,%esp
  80247f:	6a 01                	push   $0x1
  802481:	50                   	push   %eax
  802482:	ff 75 bc             	pushl  -0x44(%ebp)
  802485:	e8 ae fe ff ff       	call   802338 <set_block_data>
  80248a:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 40 04             	mov    0x4(%eax),%eax
  802493:	85 c0                	test   %eax,%eax
  802495:	75 68                	jne    8024ff <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802497:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80249b:	75 17                	jne    8024b4 <alloc_block_FF+0x14d>
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	68 bc 45 80 00       	push   $0x8045bc
  8024a5:	68 d7 00 00 00       	push   $0xd7
  8024aa:	68 a1 45 80 00       	push   $0x8045a1
  8024af:	e8 e4 de ff ff       	call   800398 <_panic>
  8024b4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8024ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bd:	89 10                	mov    %edx,(%eax)
  8024bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 0d                	je     8024d5 <alloc_block_FF+0x16e>
  8024c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024cd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024d0:	89 50 04             	mov    %edx,0x4(%eax)
  8024d3:	eb 08                	jmp    8024dd <alloc_block_FF+0x176>
  8024d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8024dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8024f4:	40                   	inc    %eax
  8024f5:	a3 38 50 80 00       	mov    %eax,0x805038
  8024fa:	e9 dc 00 00 00       	jmp    8025db <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 00                	mov    (%eax),%eax
  802504:	85 c0                	test   %eax,%eax
  802506:	75 65                	jne    80256d <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802508:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80250c:	75 17                	jne    802525 <alloc_block_FF+0x1be>
  80250e:	83 ec 04             	sub    $0x4,%esp
  802511:	68 f0 45 80 00       	push   $0x8045f0
  802516:	68 db 00 00 00       	push   $0xdb
  80251b:	68 a1 45 80 00       	push   $0x8045a1
  802520:	e8 73 de ff ff       	call   800398 <_panic>
  802525:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80252b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80252e:	89 50 04             	mov    %edx,0x4(%eax)
  802531:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802534:	8b 40 04             	mov    0x4(%eax),%eax
  802537:	85 c0                	test   %eax,%eax
  802539:	74 0c                	je     802547 <alloc_block_FF+0x1e0>
  80253b:	a1 30 50 80 00       	mov    0x805030,%eax
  802540:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802543:	89 10                	mov    %edx,(%eax)
  802545:	eb 08                	jmp    80254f <alloc_block_FF+0x1e8>
  802547:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80254a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80254f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802552:	a3 30 50 80 00       	mov    %eax,0x805030
  802557:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80255a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802560:	a1 38 50 80 00       	mov    0x805038,%eax
  802565:	40                   	inc    %eax
  802566:	a3 38 50 80 00       	mov    %eax,0x805038
  80256b:	eb 6e                	jmp    8025db <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80256d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802571:	74 06                	je     802579 <alloc_block_FF+0x212>
  802573:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802577:	75 17                	jne    802590 <alloc_block_FF+0x229>
  802579:	83 ec 04             	sub    $0x4,%esp
  80257c:	68 14 46 80 00       	push   $0x804614
  802581:	68 df 00 00 00       	push   $0xdf
  802586:	68 a1 45 80 00       	push   $0x8045a1
  80258b:	e8 08 de ff ff       	call   800398 <_panic>
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 10                	mov    (%eax),%edx
  802595:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802598:	89 10                	mov    %edx,(%eax)
  80259a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80259d:	8b 00                	mov    (%eax),%eax
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	74 0b                	je     8025ae <alloc_block_FF+0x247>
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 00                	mov    (%eax),%eax
  8025a8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025ab:	89 50 04             	mov    %edx,0x4(%eax)
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025b4:	89 10                	mov    %edx,(%eax)
  8025b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bc:	89 50 04             	mov    %edx,0x4(%eax)
  8025bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c2:	8b 00                	mov    (%eax),%eax
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	75 08                	jne    8025d0 <alloc_block_FF+0x269>
  8025c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8025d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8025d5:	40                   	inc    %eax
  8025d6:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8025db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025df:	75 17                	jne    8025f8 <alloc_block_FF+0x291>
  8025e1:	83 ec 04             	sub    $0x4,%esp
  8025e4:	68 83 45 80 00       	push   $0x804583
  8025e9:	68 e1 00 00 00       	push   $0xe1
  8025ee:	68 a1 45 80 00       	push   $0x8045a1
  8025f3:	e8 a0 dd ff ff       	call   800398 <_panic>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	74 10                	je     802611 <alloc_block_FF+0x2aa>
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802609:	8b 52 04             	mov    0x4(%edx),%edx
  80260c:	89 50 04             	mov    %edx,0x4(%eax)
  80260f:	eb 0b                	jmp    80261c <alloc_block_FF+0x2b5>
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 40 04             	mov    0x4(%eax),%eax
  802617:	a3 30 50 80 00       	mov    %eax,0x805030
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 40 04             	mov    0x4(%eax),%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	74 0f                	je     802635 <alloc_block_FF+0x2ce>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 40 04             	mov    0x4(%eax),%eax
  80262c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262f:	8b 12                	mov    (%edx),%edx
  802631:	89 10                	mov    %edx,(%eax)
  802633:	eb 0a                	jmp    80263f <alloc_block_FF+0x2d8>
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
				set_block_data(new_block_va, remaining_size, 0);
  80265d:	83 ec 04             	sub    $0x4,%esp
  802660:	6a 00                	push   $0x0
  802662:	ff 75 b4             	pushl  -0x4c(%ebp)
  802665:	ff 75 b0             	pushl  -0x50(%ebp)
  802668:	e8 cb fc ff ff       	call   802338 <set_block_data>
  80266d:	83 c4 10             	add    $0x10,%esp
  802670:	e9 95 00 00 00       	jmp    80270a <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	6a 01                	push   $0x1
  80267a:	ff 75 b8             	pushl  -0x48(%ebp)
  80267d:	ff 75 bc             	pushl  -0x44(%ebp)
  802680:	e8 b3 fc ff ff       	call   802338 <set_block_data>
  802685:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802688:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268c:	75 17                	jne    8026a5 <alloc_block_FF+0x33e>
  80268e:	83 ec 04             	sub    $0x4,%esp
  802691:	68 83 45 80 00       	push   $0x804583
  802696:	68 e8 00 00 00       	push   $0xe8
  80269b:	68 a1 45 80 00       	push   $0x8045a1
  8026a0:	e8 f3 dc ff ff       	call   800398 <_panic>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	74 10                	je     8026be <alloc_block_FF+0x357>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b6:	8b 52 04             	mov    0x4(%edx),%edx
  8026b9:	89 50 04             	mov    %edx,0x4(%eax)
  8026bc:	eb 0b                	jmp    8026c9 <alloc_block_FF+0x362>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 40 04             	mov    0x4(%eax),%eax
  8026c4:	a3 30 50 80 00       	mov    %eax,0x805030
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 04             	mov    0x4(%eax),%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	74 0f                	je     8026e2 <alloc_block_FF+0x37b>
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 40 04             	mov    0x4(%eax),%eax
  8026d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026dc:	8b 12                	mov    (%edx),%edx
  8026de:	89 10                	mov    %edx,(%eax)
  8026e0:	eb 0a                	jmp    8026ec <alloc_block_FF+0x385>
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ff:	a1 38 50 80 00       	mov    0x805038,%eax
  802704:	48                   	dec    %eax
  802705:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80270a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80270d:	e9 0f 01 00 00       	jmp    802821 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802712:	a1 34 50 80 00       	mov    0x805034,%eax
  802717:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271e:	74 07                	je     802727 <alloc_block_FF+0x3c0>
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	eb 05                	jmp    80272c <alloc_block_FF+0x3c5>
  802727:	b8 00 00 00 00       	mov    $0x0,%eax
  80272c:	a3 34 50 80 00       	mov    %eax,0x805034
  802731:	a1 34 50 80 00       	mov    0x805034,%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	0f 85 e9 fc ff ff    	jne    802427 <alloc_block_FF+0xc0>
  80273e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802742:	0f 85 df fc ff ff    	jne    802427 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802748:	8b 45 08             	mov    0x8(%ebp),%eax
  80274b:	83 c0 08             	add    $0x8,%eax
  80274e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802751:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802758:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80275b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80275e:	01 d0                	add    %edx,%eax
  802760:	48                   	dec    %eax
  802761:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802764:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802767:	ba 00 00 00 00       	mov    $0x0,%edx
  80276c:	f7 75 d8             	divl   -0x28(%ebp)
  80276f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802772:	29 d0                	sub    %edx,%eax
  802774:	c1 e8 0c             	shr    $0xc,%eax
  802777:	83 ec 0c             	sub    $0xc,%esp
  80277a:	50                   	push   %eax
  80277b:	e8 6f ec ff ff       	call   8013ef <sbrk>
  802780:	83 c4 10             	add    $0x10,%esp
  802783:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802786:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80278a:	75 0a                	jne    802796 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80278c:	b8 00 00 00 00       	mov    $0x0,%eax
  802791:	e9 8b 00 00 00       	jmp    802821 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802796:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80279d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027a3:	01 d0                	add    %edx,%eax
  8027a5:	48                   	dec    %eax
  8027a6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8027a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b1:	f7 75 cc             	divl   -0x34(%ebp)
  8027b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027b7:	29 d0                	sub    %edx,%eax
  8027b9:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027bf:	01 d0                	add    %edx,%eax
  8027c1:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8027c6:	a1 40 50 80 00       	mov    0x805040,%eax
  8027cb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8027d1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8027d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027db:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027de:	01 d0                	add    %edx,%eax
  8027e0:	48                   	dec    %eax
  8027e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8027e4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ec:	f7 75 c4             	divl   -0x3c(%ebp)
  8027ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027f2:	29 d0                	sub    %edx,%eax
  8027f4:	83 ec 04             	sub    $0x4,%esp
  8027f7:	6a 01                	push   $0x1
  8027f9:	50                   	push   %eax
  8027fa:	ff 75 d0             	pushl  -0x30(%ebp)
  8027fd:	e8 36 fb ff ff       	call   802338 <set_block_data>
  802802:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802805:	83 ec 0c             	sub    $0xc,%esp
  802808:	ff 75 d0             	pushl  -0x30(%ebp)
  80280b:	e8 f8 09 00 00       	call   803208 <free_block>
  802810:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802813:	83 ec 0c             	sub    $0xc,%esp
  802816:	ff 75 08             	pushl  0x8(%ebp)
  802819:	e8 49 fb ff ff       	call   802367 <alloc_block_FF>
  80281e:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802821:	c9                   	leave  
  802822:	c3                   	ret    

00802823 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
  802826:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	83 e0 01             	and    $0x1,%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	74 03                	je     802836 <alloc_block_BF+0x13>
  802833:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802836:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80283a:	77 07                	ja     802843 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80283c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802843:	a1 24 50 80 00       	mov    0x805024,%eax
  802848:	85 c0                	test   %eax,%eax
  80284a:	75 73                	jne    8028bf <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	83 c0 10             	add    $0x10,%eax
  802852:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802855:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80285c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80285f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802862:	01 d0                	add    %edx,%eax
  802864:	48                   	dec    %eax
  802865:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802868:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80286b:	ba 00 00 00 00       	mov    $0x0,%edx
  802870:	f7 75 e0             	divl   -0x20(%ebp)
  802873:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802876:	29 d0                	sub    %edx,%eax
  802878:	c1 e8 0c             	shr    $0xc,%eax
  80287b:	83 ec 0c             	sub    $0xc,%esp
  80287e:	50                   	push   %eax
  80287f:	e8 6b eb ff ff       	call   8013ef <sbrk>
  802884:	83 c4 10             	add    $0x10,%esp
  802887:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80288a:	83 ec 0c             	sub    $0xc,%esp
  80288d:	6a 00                	push   $0x0
  80288f:	e8 5b eb ff ff       	call   8013ef <sbrk>
  802894:	83 c4 10             	add    $0x10,%esp
  802897:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80289a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80289d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8028a0:	83 ec 08             	sub    $0x8,%esp
  8028a3:	50                   	push   %eax
  8028a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8028a7:	e8 9f f8 ff ff       	call   80214b <initialize_dynamic_allocator>
  8028ac:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8028af:	83 ec 0c             	sub    $0xc,%esp
  8028b2:	68 df 45 80 00       	push   $0x8045df
  8028b7:	e8 99 dd ff ff       	call   800655 <cprintf>
  8028bc:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8028bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8028c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8028cd:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8028d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8028db:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e3:	e9 1d 01 00 00       	jmp    802a05 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8028ee:	83 ec 0c             	sub    $0xc,%esp
  8028f1:	ff 75 a8             	pushl  -0x58(%ebp)
  8028f4:	e8 ee f6 ff ff       	call   801fe7 <get_block_size>
  8028f9:	83 c4 10             	add    $0x10,%esp
  8028fc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	83 c0 08             	add    $0x8,%eax
  802905:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802908:	0f 87 ef 00 00 00    	ja     8029fd <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	83 c0 18             	add    $0x18,%eax
  802914:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802917:	77 1d                	ja     802936 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802919:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80291f:	0f 86 d8 00 00 00    	jbe    8029fd <alloc_block_BF+0x1da>
				{
					best_va = va;
  802925:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802928:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80292b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80292e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802931:	e9 c7 00 00 00       	jmp    8029fd <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	83 c0 08             	add    $0x8,%eax
  80293c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80293f:	0f 85 9d 00 00 00    	jne    8029e2 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802945:	83 ec 04             	sub    $0x4,%esp
  802948:	6a 01                	push   $0x1
  80294a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80294d:	ff 75 a8             	pushl  -0x58(%ebp)
  802950:	e8 e3 f9 ff ff       	call   802338 <set_block_data>
  802955:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295c:	75 17                	jne    802975 <alloc_block_BF+0x152>
  80295e:	83 ec 04             	sub    $0x4,%esp
  802961:	68 83 45 80 00       	push   $0x804583
  802966:	68 2c 01 00 00       	push   $0x12c
  80296b:	68 a1 45 80 00       	push   $0x8045a1
  802970:	e8 23 da ff ff       	call   800398 <_panic>
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 00                	mov    (%eax),%eax
  80297a:	85 c0                	test   %eax,%eax
  80297c:	74 10                	je     80298e <alloc_block_BF+0x16b>
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802986:	8b 52 04             	mov    0x4(%edx),%edx
  802989:	89 50 04             	mov    %edx,0x4(%eax)
  80298c:	eb 0b                	jmp    802999 <alloc_block_BF+0x176>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 40 04             	mov    0x4(%eax),%eax
  802994:	a3 30 50 80 00       	mov    %eax,0x805030
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 40 04             	mov    0x4(%eax),%eax
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	74 0f                	je     8029b2 <alloc_block_BF+0x18f>
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 40 04             	mov    0x4(%eax),%eax
  8029a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ac:	8b 12                	mov    (%edx),%edx
  8029ae:	89 10                	mov    %edx,(%eax)
  8029b0:	eb 0a                	jmp    8029bc <alloc_block_BF+0x199>
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 00                	mov    (%eax),%eax
  8029b7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8029d4:	48                   	dec    %eax
  8029d5:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8029da:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029dd:	e9 01 04 00 00       	jmp    802de3 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029e8:	76 13                	jbe    8029fd <alloc_block_BF+0x1da>
					{
						internal = 1;
  8029ea:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8029f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8029f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029fa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029fd:	a1 34 50 80 00       	mov    0x805034,%eax
  802a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a09:	74 07                	je     802a12 <alloc_block_BF+0x1ef>
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	eb 05                	jmp    802a17 <alloc_block_BF+0x1f4>
  802a12:	b8 00 00 00 00       	mov    $0x0,%eax
  802a17:	a3 34 50 80 00       	mov    %eax,0x805034
  802a1c:	a1 34 50 80 00       	mov    0x805034,%eax
  802a21:	85 c0                	test   %eax,%eax
  802a23:	0f 85 bf fe ff ff    	jne    8028e8 <alloc_block_BF+0xc5>
  802a29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2d:	0f 85 b5 fe ff ff    	jne    8028e8 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a37:	0f 84 26 02 00 00    	je     802c63 <alloc_block_BF+0x440>
  802a3d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a41:	0f 85 1c 02 00 00    	jne    802c63 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4a:	2b 45 08             	sub    0x8(%ebp),%eax
  802a4d:	83 e8 08             	sub    $0x8,%eax
  802a50:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	8d 50 08             	lea    0x8(%eax),%edx
  802a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5c:	01 d0                	add    %edx,%eax
  802a5e:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	83 c0 08             	add    $0x8,%eax
  802a67:	83 ec 04             	sub    $0x4,%esp
  802a6a:	6a 01                	push   $0x1
  802a6c:	50                   	push   %eax
  802a6d:	ff 75 f0             	pushl  -0x10(%ebp)
  802a70:	e8 c3 f8 ff ff       	call   802338 <set_block_data>
  802a75:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7b:	8b 40 04             	mov    0x4(%eax),%eax
  802a7e:	85 c0                	test   %eax,%eax
  802a80:	75 68                	jne    802aea <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a82:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a86:	75 17                	jne    802a9f <alloc_block_BF+0x27c>
  802a88:	83 ec 04             	sub    $0x4,%esp
  802a8b:	68 bc 45 80 00       	push   $0x8045bc
  802a90:	68 45 01 00 00       	push   $0x145
  802a95:	68 a1 45 80 00       	push   $0x8045a1
  802a9a:	e8 f9 d8 ff ff       	call   800398 <_panic>
  802a9f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802aa5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa8:	89 10                	mov    %edx,(%eax)
  802aaa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aad:	8b 00                	mov    (%eax),%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	74 0d                	je     802ac0 <alloc_block_BF+0x29d>
  802ab3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ab8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802abb:	89 50 04             	mov    %edx,0x4(%eax)
  802abe:	eb 08                	jmp    802ac8 <alloc_block_BF+0x2a5>
  802ac0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac3:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802acb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ad0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ada:	a1 38 50 80 00       	mov    0x805038,%eax
  802adf:	40                   	inc    %eax
  802ae0:	a3 38 50 80 00       	mov    %eax,0x805038
  802ae5:	e9 dc 00 00 00       	jmp    802bc6 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aed:	8b 00                	mov    (%eax),%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	75 65                	jne    802b58 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802af3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802af7:	75 17                	jne    802b10 <alloc_block_BF+0x2ed>
  802af9:	83 ec 04             	sub    $0x4,%esp
  802afc:	68 f0 45 80 00       	push   $0x8045f0
  802b01:	68 4a 01 00 00       	push   $0x14a
  802b06:	68 a1 45 80 00       	push   $0x8045a1
  802b0b:	e8 88 d8 ff ff       	call   800398 <_panic>
  802b10:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b19:	89 50 04             	mov    %edx,0x4(%eax)
  802b1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 0c                	je     802b32 <alloc_block_BF+0x30f>
  802b26:	a1 30 50 80 00       	mov    0x805030,%eax
  802b2b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b2e:	89 10                	mov    %edx,(%eax)
  802b30:	eb 08                	jmp    802b3a <alloc_block_BF+0x317>
  802b32:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b35:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b3a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4b:	a1 38 50 80 00       	mov    0x805038,%eax
  802b50:	40                   	inc    %eax
  802b51:	a3 38 50 80 00       	mov    %eax,0x805038
  802b56:	eb 6e                	jmp    802bc6 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b5c:	74 06                	je     802b64 <alloc_block_BF+0x341>
  802b5e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b62:	75 17                	jne    802b7b <alloc_block_BF+0x358>
  802b64:	83 ec 04             	sub    $0x4,%esp
  802b67:	68 14 46 80 00       	push   $0x804614
  802b6c:	68 4f 01 00 00       	push   $0x14f
  802b71:	68 a1 45 80 00       	push   $0x8045a1
  802b76:	e8 1d d8 ff ff       	call   800398 <_panic>
  802b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7e:	8b 10                	mov    (%eax),%edx
  802b80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b83:	89 10                	mov    %edx,(%eax)
  802b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	74 0b                	je     802b99 <alloc_block_BF+0x376>
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	8b 00                	mov    (%eax),%eax
  802b93:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b96:	89 50 04             	mov    %edx,0x4(%eax)
  802b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b9f:	89 10                	mov    %edx,(%eax)
  802ba1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba7:	89 50 04             	mov    %edx,0x4(%eax)
  802baa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	85 c0                	test   %eax,%eax
  802bb1:	75 08                	jne    802bbb <alloc_block_BF+0x398>
  802bb3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb6:	a3 30 50 80 00       	mov    %eax,0x805030
  802bbb:	a1 38 50 80 00       	mov    0x805038,%eax
  802bc0:	40                   	inc    %eax
  802bc1:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802bc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bca:	75 17                	jne    802be3 <alloc_block_BF+0x3c0>
  802bcc:	83 ec 04             	sub    $0x4,%esp
  802bcf:	68 83 45 80 00       	push   $0x804583
  802bd4:	68 51 01 00 00       	push   $0x151
  802bd9:	68 a1 45 80 00       	push   $0x8045a1
  802bde:	e8 b5 d7 ff ff       	call   800398 <_panic>
  802be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	85 c0                	test   %eax,%eax
  802bea:	74 10                	je     802bfc <alloc_block_BF+0x3d9>
  802bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bef:	8b 00                	mov    (%eax),%eax
  802bf1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf4:	8b 52 04             	mov    0x4(%edx),%edx
  802bf7:	89 50 04             	mov    %edx,0x4(%eax)
  802bfa:	eb 0b                	jmp    802c07 <alloc_block_BF+0x3e4>
  802bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bff:	8b 40 04             	mov    0x4(%eax),%eax
  802c02:	a3 30 50 80 00       	mov    %eax,0x805030
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	8b 40 04             	mov    0x4(%eax),%eax
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	74 0f                	je     802c20 <alloc_block_BF+0x3fd>
  802c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c14:	8b 40 04             	mov    0x4(%eax),%eax
  802c17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c1a:	8b 12                	mov    (%edx),%edx
  802c1c:	89 10                	mov    %edx,(%eax)
  802c1e:	eb 0a                	jmp    802c2a <alloc_block_BF+0x407>
  802c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c23:	8b 00                	mov    (%eax),%eax
  802c25:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3d:	a1 38 50 80 00       	mov    0x805038,%eax
  802c42:	48                   	dec    %eax
  802c43:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802c48:	83 ec 04             	sub    $0x4,%esp
  802c4b:	6a 00                	push   $0x0
  802c4d:	ff 75 d0             	pushl  -0x30(%ebp)
  802c50:	ff 75 cc             	pushl  -0x34(%ebp)
  802c53:	e8 e0 f6 ff ff       	call   802338 <set_block_data>
  802c58:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5e:	e9 80 01 00 00       	jmp    802de3 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802c63:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c67:	0f 85 9d 00 00 00    	jne    802d0a <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c6d:	83 ec 04             	sub    $0x4,%esp
  802c70:	6a 01                	push   $0x1
  802c72:	ff 75 ec             	pushl  -0x14(%ebp)
  802c75:	ff 75 f0             	pushl  -0x10(%ebp)
  802c78:	e8 bb f6 ff ff       	call   802338 <set_block_data>
  802c7d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c84:	75 17                	jne    802c9d <alloc_block_BF+0x47a>
  802c86:	83 ec 04             	sub    $0x4,%esp
  802c89:	68 83 45 80 00       	push   $0x804583
  802c8e:	68 58 01 00 00       	push   $0x158
  802c93:	68 a1 45 80 00       	push   $0x8045a1
  802c98:	e8 fb d6 ff ff       	call   800398 <_panic>
  802c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	85 c0                	test   %eax,%eax
  802ca4:	74 10                	je     802cb6 <alloc_block_BF+0x493>
  802ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca9:	8b 00                	mov    (%eax),%eax
  802cab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cae:	8b 52 04             	mov    0x4(%edx),%edx
  802cb1:	89 50 04             	mov    %edx,0x4(%eax)
  802cb4:	eb 0b                	jmp    802cc1 <alloc_block_BF+0x49e>
  802cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb9:	8b 40 04             	mov    0x4(%eax),%eax
  802cbc:	a3 30 50 80 00       	mov    %eax,0x805030
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	8b 40 04             	mov    0x4(%eax),%eax
  802cc7:	85 c0                	test   %eax,%eax
  802cc9:	74 0f                	je     802cda <alloc_block_BF+0x4b7>
  802ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cce:	8b 40 04             	mov    0x4(%eax),%eax
  802cd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd4:	8b 12                	mov    (%edx),%edx
  802cd6:	89 10                	mov    %edx,(%eax)
  802cd8:	eb 0a                	jmp    802ce4 <alloc_block_BF+0x4c1>
  802cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdd:	8b 00                	mov    (%eax),%eax
  802cdf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf7:	a1 38 50 80 00       	mov    0x805038,%eax
  802cfc:	48                   	dec    %eax
  802cfd:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d05:	e9 d9 00 00 00       	jmp    802de3 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	83 c0 08             	add    $0x8,%eax
  802d10:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d13:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d1a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d1d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d20:	01 d0                	add    %edx,%eax
  802d22:	48                   	dec    %eax
  802d23:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d26:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d29:	ba 00 00 00 00       	mov    $0x0,%edx
  802d2e:	f7 75 c4             	divl   -0x3c(%ebp)
  802d31:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d34:	29 d0                	sub    %edx,%eax
  802d36:	c1 e8 0c             	shr    $0xc,%eax
  802d39:	83 ec 0c             	sub    $0xc,%esp
  802d3c:	50                   	push   %eax
  802d3d:	e8 ad e6 ff ff       	call   8013ef <sbrk>
  802d42:	83 c4 10             	add    $0x10,%esp
  802d45:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d48:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d4c:	75 0a                	jne    802d58 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d53:	e9 8b 00 00 00       	jmp    802de3 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d58:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d5f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d62:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d65:	01 d0                	add    %edx,%eax
  802d67:	48                   	dec    %eax
  802d68:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d6b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d6e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d73:	f7 75 b8             	divl   -0x48(%ebp)
  802d76:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d79:	29 d0                	sub    %edx,%eax
  802d7b:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d7e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d81:	01 d0                	add    %edx,%eax
  802d83:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d88:	a1 40 50 80 00       	mov    0x805040,%eax
  802d8d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d93:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d9a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d9d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802da0:	01 d0                	add    %edx,%eax
  802da2:	48                   	dec    %eax
  802da3:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802da6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802da9:	ba 00 00 00 00       	mov    $0x0,%edx
  802dae:	f7 75 b0             	divl   -0x50(%ebp)
  802db1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802db4:	29 d0                	sub    %edx,%eax
  802db6:	83 ec 04             	sub    $0x4,%esp
  802db9:	6a 01                	push   $0x1
  802dbb:	50                   	push   %eax
  802dbc:	ff 75 bc             	pushl  -0x44(%ebp)
  802dbf:	e8 74 f5 ff ff       	call   802338 <set_block_data>
  802dc4:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802dc7:	83 ec 0c             	sub    $0xc,%esp
  802dca:	ff 75 bc             	pushl  -0x44(%ebp)
  802dcd:	e8 36 04 00 00       	call   803208 <free_block>
  802dd2:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802dd5:	83 ec 0c             	sub    $0xc,%esp
  802dd8:	ff 75 08             	pushl  0x8(%ebp)
  802ddb:	e8 43 fa ff ff       	call   802823 <alloc_block_BF>
  802de0:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802de3:	c9                   	leave  
  802de4:	c3                   	ret    

00802de5 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802de5:	55                   	push   %ebp
  802de6:	89 e5                	mov    %esp,%ebp
  802de8:	53                   	push   %ebx
  802de9:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802dec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802df3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802dfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfe:	74 1e                	je     802e1e <merging+0x39>
  802e00:	ff 75 08             	pushl  0x8(%ebp)
  802e03:	e8 df f1 ff ff       	call   801fe7 <get_block_size>
  802e08:	83 c4 04             	add    $0x4,%esp
  802e0b:	89 c2                	mov    %eax,%edx
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	01 d0                	add    %edx,%eax
  802e12:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e15:	75 07                	jne    802e1e <merging+0x39>
		prev_is_free = 1;
  802e17:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e22:	74 1e                	je     802e42 <merging+0x5d>
  802e24:	ff 75 10             	pushl  0x10(%ebp)
  802e27:	e8 bb f1 ff ff       	call   801fe7 <get_block_size>
  802e2c:	83 c4 04             	add    $0x4,%esp
  802e2f:	89 c2                	mov    %eax,%edx
  802e31:	8b 45 10             	mov    0x10(%ebp),%eax
  802e34:	01 d0                	add    %edx,%eax
  802e36:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e39:	75 07                	jne    802e42 <merging+0x5d>
		next_is_free = 1;
  802e3b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e46:	0f 84 cc 00 00 00    	je     802f18 <merging+0x133>
  802e4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e50:	0f 84 c2 00 00 00    	je     802f18 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e56:	ff 75 08             	pushl  0x8(%ebp)
  802e59:	e8 89 f1 ff ff       	call   801fe7 <get_block_size>
  802e5e:	83 c4 04             	add    $0x4,%esp
  802e61:	89 c3                	mov    %eax,%ebx
  802e63:	ff 75 10             	pushl  0x10(%ebp)
  802e66:	e8 7c f1 ff ff       	call   801fe7 <get_block_size>
  802e6b:	83 c4 04             	add    $0x4,%esp
  802e6e:	01 c3                	add    %eax,%ebx
  802e70:	ff 75 0c             	pushl  0xc(%ebp)
  802e73:	e8 6f f1 ff ff       	call   801fe7 <get_block_size>
  802e78:	83 c4 04             	add    $0x4,%esp
  802e7b:	01 d8                	add    %ebx,%eax
  802e7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e80:	6a 00                	push   $0x0
  802e82:	ff 75 ec             	pushl  -0x14(%ebp)
  802e85:	ff 75 08             	pushl  0x8(%ebp)
  802e88:	e8 ab f4 ff ff       	call   802338 <set_block_data>
  802e8d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e94:	75 17                	jne    802ead <merging+0xc8>
  802e96:	83 ec 04             	sub    $0x4,%esp
  802e99:	68 83 45 80 00       	push   $0x804583
  802e9e:	68 7d 01 00 00       	push   $0x17d
  802ea3:	68 a1 45 80 00       	push   $0x8045a1
  802ea8:	e8 eb d4 ff ff       	call   800398 <_panic>
  802ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb0:	8b 00                	mov    (%eax),%eax
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	74 10                	je     802ec6 <merging+0xe1>
  802eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ebe:	8b 52 04             	mov    0x4(%edx),%edx
  802ec1:	89 50 04             	mov    %edx,0x4(%eax)
  802ec4:	eb 0b                	jmp    802ed1 <merging+0xec>
  802ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	a3 30 50 80 00       	mov    %eax,0x805030
  802ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed4:	8b 40 04             	mov    0x4(%eax),%eax
  802ed7:	85 c0                	test   %eax,%eax
  802ed9:	74 0f                	je     802eea <merging+0x105>
  802edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ede:	8b 40 04             	mov    0x4(%eax),%eax
  802ee1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee4:	8b 12                	mov    (%edx),%edx
  802ee6:	89 10                	mov    %edx,(%eax)
  802ee8:	eb 0a                	jmp    802ef4 <merging+0x10f>
  802eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f07:	a1 38 50 80 00       	mov    0x805038,%eax
  802f0c:	48                   	dec    %eax
  802f0d:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f12:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f13:	e9 ea 02 00 00       	jmp    803202 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1c:	74 3b                	je     802f59 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f1e:	83 ec 0c             	sub    $0xc,%esp
  802f21:	ff 75 08             	pushl  0x8(%ebp)
  802f24:	e8 be f0 ff ff       	call   801fe7 <get_block_size>
  802f29:	83 c4 10             	add    $0x10,%esp
  802f2c:	89 c3                	mov    %eax,%ebx
  802f2e:	83 ec 0c             	sub    $0xc,%esp
  802f31:	ff 75 10             	pushl  0x10(%ebp)
  802f34:	e8 ae f0 ff ff       	call   801fe7 <get_block_size>
  802f39:	83 c4 10             	add    $0x10,%esp
  802f3c:	01 d8                	add    %ebx,%eax
  802f3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f41:	83 ec 04             	sub    $0x4,%esp
  802f44:	6a 00                	push   $0x0
  802f46:	ff 75 e8             	pushl  -0x18(%ebp)
  802f49:	ff 75 08             	pushl  0x8(%ebp)
  802f4c:	e8 e7 f3 ff ff       	call   802338 <set_block_data>
  802f51:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f54:	e9 a9 02 00 00       	jmp    803202 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f5d:	0f 84 2d 01 00 00    	je     803090 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f63:	83 ec 0c             	sub    $0xc,%esp
  802f66:	ff 75 10             	pushl  0x10(%ebp)
  802f69:	e8 79 f0 ff ff       	call   801fe7 <get_block_size>
  802f6e:	83 c4 10             	add    $0x10,%esp
  802f71:	89 c3                	mov    %eax,%ebx
  802f73:	83 ec 0c             	sub    $0xc,%esp
  802f76:	ff 75 0c             	pushl  0xc(%ebp)
  802f79:	e8 69 f0 ff ff       	call   801fe7 <get_block_size>
  802f7e:	83 c4 10             	add    $0x10,%esp
  802f81:	01 d8                	add    %ebx,%eax
  802f83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	6a 00                	push   $0x0
  802f8b:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f8e:	ff 75 10             	pushl  0x10(%ebp)
  802f91:	e8 a2 f3 ff ff       	call   802338 <set_block_data>
  802f96:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f99:	8b 45 10             	mov    0x10(%ebp),%eax
  802f9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fa3:	74 06                	je     802fab <merging+0x1c6>
  802fa5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fa9:	75 17                	jne    802fc2 <merging+0x1dd>
  802fab:	83 ec 04             	sub    $0x4,%esp
  802fae:	68 48 46 80 00       	push   $0x804648
  802fb3:	68 8d 01 00 00       	push   $0x18d
  802fb8:	68 a1 45 80 00       	push   $0x8045a1
  802fbd:	e8 d6 d3 ff ff       	call   800398 <_panic>
  802fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc5:	8b 50 04             	mov    0x4(%eax),%edx
  802fc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fcb:	89 50 04             	mov    %edx,0x4(%eax)
  802fce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd4:	89 10                	mov    %edx,(%eax)
  802fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd9:	8b 40 04             	mov    0x4(%eax),%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 0d                	je     802fed <merging+0x208>
  802fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe3:	8b 40 04             	mov    0x4(%eax),%eax
  802fe6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fe9:	89 10                	mov    %edx,(%eax)
  802feb:	eb 08                	jmp    802ff5 <merging+0x210>
  802fed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ffb:	89 50 04             	mov    %edx,0x4(%eax)
  802ffe:	a1 38 50 80 00       	mov    0x805038,%eax
  803003:	40                   	inc    %eax
  803004:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803009:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80300d:	75 17                	jne    803026 <merging+0x241>
  80300f:	83 ec 04             	sub    $0x4,%esp
  803012:	68 83 45 80 00       	push   $0x804583
  803017:	68 8e 01 00 00       	push   $0x18e
  80301c:	68 a1 45 80 00       	push   $0x8045a1
  803021:	e8 72 d3 ff ff       	call   800398 <_panic>
  803026:	8b 45 0c             	mov    0xc(%ebp),%eax
  803029:	8b 00                	mov    (%eax),%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	74 10                	je     80303f <merging+0x25a>
  80302f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803032:	8b 00                	mov    (%eax),%eax
  803034:	8b 55 0c             	mov    0xc(%ebp),%edx
  803037:	8b 52 04             	mov    0x4(%edx),%edx
  80303a:	89 50 04             	mov    %edx,0x4(%eax)
  80303d:	eb 0b                	jmp    80304a <merging+0x265>
  80303f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	a3 30 50 80 00       	mov    %eax,0x805030
  80304a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304d:	8b 40 04             	mov    0x4(%eax),%eax
  803050:	85 c0                	test   %eax,%eax
  803052:	74 0f                	je     803063 <merging+0x27e>
  803054:	8b 45 0c             	mov    0xc(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80305d:	8b 12                	mov    (%edx),%edx
  80305f:	89 10                	mov    %edx,(%eax)
  803061:	eb 0a                	jmp    80306d <merging+0x288>
  803063:	8b 45 0c             	mov    0xc(%ebp),%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80306d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803076:	8b 45 0c             	mov    0xc(%ebp),%eax
  803079:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803080:	a1 38 50 80 00       	mov    0x805038,%eax
  803085:	48                   	dec    %eax
  803086:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80308b:	e9 72 01 00 00       	jmp    803202 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803090:	8b 45 10             	mov    0x10(%ebp),%eax
  803093:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803096:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309a:	74 79                	je     803115 <merging+0x330>
  80309c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030a0:	74 73                	je     803115 <merging+0x330>
  8030a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a6:	74 06                	je     8030ae <merging+0x2c9>
  8030a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030ac:	75 17                	jne    8030c5 <merging+0x2e0>
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	68 14 46 80 00       	push   $0x804614
  8030b6:	68 94 01 00 00       	push   $0x194
  8030bb:	68 a1 45 80 00       	push   $0x8045a1
  8030c0:	e8 d3 d2 ff ff       	call   800398 <_panic>
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	8b 10                	mov    (%eax),%edx
  8030ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030cd:	89 10                	mov    %edx,(%eax)
  8030cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 0b                	je     8030e3 <merging+0x2fe>
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030e9:	89 10                	mov    %edx,(%eax)
  8030eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f1:	89 50 04             	mov    %edx,0x4(%eax)
  8030f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	75 08                	jne    803105 <merging+0x320>
  8030fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803100:	a3 30 50 80 00       	mov    %eax,0x805030
  803105:	a1 38 50 80 00       	mov    0x805038,%eax
  80310a:	40                   	inc    %eax
  80310b:	a3 38 50 80 00       	mov    %eax,0x805038
  803110:	e9 ce 00 00 00       	jmp    8031e3 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803119:	74 65                	je     803180 <merging+0x39b>
  80311b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80311f:	75 17                	jne    803138 <merging+0x353>
  803121:	83 ec 04             	sub    $0x4,%esp
  803124:	68 f0 45 80 00       	push   $0x8045f0
  803129:	68 95 01 00 00       	push   $0x195
  80312e:	68 a1 45 80 00       	push   $0x8045a1
  803133:	e8 60 d2 ff ff       	call   800398 <_panic>
  803138:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80313e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803141:	89 50 04             	mov    %edx,0x4(%eax)
  803144:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803147:	8b 40 04             	mov    0x4(%eax),%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	74 0c                	je     80315a <merging+0x375>
  80314e:	a1 30 50 80 00       	mov    0x805030,%eax
  803153:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803156:	89 10                	mov    %edx,(%eax)
  803158:	eb 08                	jmp    803162 <merging+0x37d>
  80315a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803162:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803165:	a3 30 50 80 00       	mov    %eax,0x805030
  80316a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803173:	a1 38 50 80 00       	mov    0x805038,%eax
  803178:	40                   	inc    %eax
  803179:	a3 38 50 80 00       	mov    %eax,0x805038
  80317e:	eb 63                	jmp    8031e3 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803180:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803184:	75 17                	jne    80319d <merging+0x3b8>
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	68 bc 45 80 00       	push   $0x8045bc
  80318e:	68 98 01 00 00       	push   $0x198
  803193:	68 a1 45 80 00       	push   $0x8045a1
  803198:	e8 fb d1 ff ff       	call   800398 <_panic>
  80319d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031a6:	89 10                	mov    %edx,(%eax)
  8031a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ab:	8b 00                	mov    (%eax),%eax
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	74 0d                	je     8031be <merging+0x3d9>
  8031b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031b9:	89 50 04             	mov    %edx,0x4(%eax)
  8031bc:	eb 08                	jmp    8031c6 <merging+0x3e1>
  8031be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c1:	a3 30 50 80 00       	mov    %eax,0x805030
  8031c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8031dd:	40                   	inc    %eax
  8031de:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8031e3:	83 ec 0c             	sub    $0xc,%esp
  8031e6:	ff 75 10             	pushl  0x10(%ebp)
  8031e9:	e8 f9 ed ff ff       	call   801fe7 <get_block_size>
  8031ee:	83 c4 10             	add    $0x10,%esp
  8031f1:	83 ec 04             	sub    $0x4,%esp
  8031f4:	6a 00                	push   $0x0
  8031f6:	50                   	push   %eax
  8031f7:	ff 75 10             	pushl  0x10(%ebp)
  8031fa:	e8 39 f1 ff ff       	call   802338 <set_block_data>
  8031ff:	83 c4 10             	add    $0x10,%esp
	}
}
  803202:	90                   	nop
  803203:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803206:	c9                   	leave  
  803207:	c3                   	ret    

00803208 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803208:	55                   	push   %ebp
  803209:	89 e5                	mov    %esp,%ebp
  80320b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80320e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803213:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803216:	a1 30 50 80 00       	mov    0x805030,%eax
  80321b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80321e:	73 1b                	jae    80323b <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803220:	a1 30 50 80 00       	mov    0x805030,%eax
  803225:	83 ec 04             	sub    $0x4,%esp
  803228:	ff 75 08             	pushl  0x8(%ebp)
  80322b:	6a 00                	push   $0x0
  80322d:	50                   	push   %eax
  80322e:	e8 b2 fb ff ff       	call   802de5 <merging>
  803233:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803236:	e9 8b 00 00 00       	jmp    8032c6 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80323b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803240:	3b 45 08             	cmp    0x8(%ebp),%eax
  803243:	76 18                	jbe    80325d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803245:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80324a:	83 ec 04             	sub    $0x4,%esp
  80324d:	ff 75 08             	pushl  0x8(%ebp)
  803250:	50                   	push   %eax
  803251:	6a 00                	push   $0x0
  803253:	e8 8d fb ff ff       	call   802de5 <merging>
  803258:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80325b:	eb 69                	jmp    8032c6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80325d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803265:	eb 39                	jmp    8032a0 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80326d:	73 29                	jae    803298 <free_block+0x90>
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	8b 00                	mov    (%eax),%eax
  803274:	3b 45 08             	cmp    0x8(%ebp),%eax
  803277:	76 1f                	jbe    803298 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803281:	83 ec 04             	sub    $0x4,%esp
  803284:	ff 75 08             	pushl  0x8(%ebp)
  803287:	ff 75 f0             	pushl  -0x10(%ebp)
  80328a:	ff 75 f4             	pushl  -0xc(%ebp)
  80328d:	e8 53 fb ff ff       	call   802de5 <merging>
  803292:	83 c4 10             	add    $0x10,%esp
			break;
  803295:	90                   	nop
		}
	}
}
  803296:	eb 2e                	jmp    8032c6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803298:	a1 34 50 80 00       	mov    0x805034,%eax
  80329d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a4:	74 07                	je     8032ad <free_block+0xa5>
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	eb 05                	jmp    8032b2 <free_block+0xaa>
  8032ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b2:	a3 34 50 80 00       	mov    %eax,0x805034
  8032b7:	a1 34 50 80 00       	mov    0x805034,%eax
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	75 a7                	jne    803267 <free_block+0x5f>
  8032c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c4:	75 a1                	jne    803267 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032c6:	90                   	nop
  8032c7:	c9                   	leave  
  8032c8:	c3                   	ret    

008032c9 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8032c9:	55                   	push   %ebp
  8032ca:	89 e5                	mov    %esp,%ebp
  8032cc:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8032cf:	ff 75 08             	pushl  0x8(%ebp)
  8032d2:	e8 10 ed ff ff       	call   801fe7 <get_block_size>
  8032d7:	83 c4 04             	add    $0x4,%esp
  8032da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8032dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032e4:	eb 17                	jmp    8032fd <copy_data+0x34>
  8032e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ec:	01 c2                	add    %eax,%edx
  8032ee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	01 c8                	add    %ecx,%eax
  8032f6:	8a 00                	mov    (%eax),%al
  8032f8:	88 02                	mov    %al,(%edx)
  8032fa:	ff 45 fc             	incl   -0x4(%ebp)
  8032fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803300:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803303:	72 e1                	jb     8032e6 <copy_data+0x1d>
}
  803305:	90                   	nop
  803306:	c9                   	leave  
  803307:	c3                   	ret    

00803308 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803308:	55                   	push   %ebp
  803309:	89 e5                	mov    %esp,%ebp
  80330b:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80330e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803312:	75 23                	jne    803337 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803314:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803318:	74 13                	je     80332d <realloc_block_FF+0x25>
  80331a:	83 ec 0c             	sub    $0xc,%esp
  80331d:	ff 75 0c             	pushl  0xc(%ebp)
  803320:	e8 42 f0 ff ff       	call   802367 <alloc_block_FF>
  803325:	83 c4 10             	add    $0x10,%esp
  803328:	e9 e4 06 00 00       	jmp    803a11 <realloc_block_FF+0x709>
		return NULL;
  80332d:	b8 00 00 00 00       	mov    $0x0,%eax
  803332:	e9 da 06 00 00       	jmp    803a11 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803337:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80333b:	75 18                	jne    803355 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80333d:	83 ec 0c             	sub    $0xc,%esp
  803340:	ff 75 08             	pushl  0x8(%ebp)
  803343:	e8 c0 fe ff ff       	call   803208 <free_block>
  803348:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80334b:	b8 00 00 00 00       	mov    $0x0,%eax
  803350:	e9 bc 06 00 00       	jmp    803a11 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803355:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803359:	77 07                	ja     803362 <realloc_block_FF+0x5a>
  80335b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803362:	8b 45 0c             	mov    0xc(%ebp),%eax
  803365:	83 e0 01             	and    $0x1,%eax
  803368:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80336b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336e:	83 c0 08             	add    $0x8,%eax
  803371:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803374:	83 ec 0c             	sub    $0xc,%esp
  803377:	ff 75 08             	pushl  0x8(%ebp)
  80337a:	e8 68 ec ff ff       	call   801fe7 <get_block_size>
  80337f:	83 c4 10             	add    $0x10,%esp
  803382:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803385:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803388:	83 e8 08             	sub    $0x8,%eax
  80338b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	83 e8 04             	sub    $0x4,%eax
  803394:	8b 00                	mov    (%eax),%eax
  803396:	83 e0 fe             	and    $0xfffffffe,%eax
  803399:	89 c2                	mov    %eax,%edx
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	01 d0                	add    %edx,%eax
  8033a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8033a3:	83 ec 0c             	sub    $0xc,%esp
  8033a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033a9:	e8 39 ec ff ff       	call   801fe7 <get_block_size>
  8033ae:	83 c4 10             	add    $0x10,%esp
  8033b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b7:	83 e8 08             	sub    $0x8,%eax
  8033ba:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8033bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033c3:	75 08                	jne    8033cd <realloc_block_FF+0xc5>
	{
		 return va;
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	e9 44 06 00 00       	jmp    803a11 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8033cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033d3:	0f 83 d5 03 00 00    	jae    8037ae <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8033e2:	83 ec 0c             	sub    $0xc,%esp
  8033e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033e8:	e8 13 ec ff ff       	call   802000 <is_free_block>
  8033ed:	83 c4 10             	add    $0x10,%esp
  8033f0:	84 c0                	test   %al,%al
  8033f2:	0f 84 3b 01 00 00    	je     803533 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033fe:	01 d0                	add    %edx,%eax
  803400:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803403:	83 ec 04             	sub    $0x4,%esp
  803406:	6a 01                	push   $0x1
  803408:	ff 75 f0             	pushl  -0x10(%ebp)
  80340b:	ff 75 08             	pushl  0x8(%ebp)
  80340e:	e8 25 ef ff ff       	call   802338 <set_block_data>
  803413:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	83 e8 04             	sub    $0x4,%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	83 e0 fe             	and    $0xfffffffe,%eax
  803421:	89 c2                	mov    %eax,%edx
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	01 d0                	add    %edx,%eax
  803428:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80342b:	83 ec 04             	sub    $0x4,%esp
  80342e:	6a 00                	push   $0x0
  803430:	ff 75 cc             	pushl  -0x34(%ebp)
  803433:	ff 75 c8             	pushl  -0x38(%ebp)
  803436:	e8 fd ee ff ff       	call   802338 <set_block_data>
  80343b:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80343e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803442:	74 06                	je     80344a <realloc_block_FF+0x142>
  803444:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803448:	75 17                	jne    803461 <realloc_block_FF+0x159>
  80344a:	83 ec 04             	sub    $0x4,%esp
  80344d:	68 14 46 80 00       	push   $0x804614
  803452:	68 f6 01 00 00       	push   $0x1f6
  803457:	68 a1 45 80 00       	push   $0x8045a1
  80345c:	e8 37 cf ff ff       	call   800398 <_panic>
  803461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803464:	8b 10                	mov    (%eax),%edx
  803466:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803469:	89 10                	mov    %edx,(%eax)
  80346b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80346e:	8b 00                	mov    (%eax),%eax
  803470:	85 c0                	test   %eax,%eax
  803472:	74 0b                	je     80347f <realloc_block_FF+0x177>
  803474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803477:	8b 00                	mov    (%eax),%eax
  803479:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80347c:	89 50 04             	mov    %edx,0x4(%eax)
  80347f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803482:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803485:	89 10                	mov    %edx,(%eax)
  803487:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80348a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348d:	89 50 04             	mov    %edx,0x4(%eax)
  803490:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803493:	8b 00                	mov    (%eax),%eax
  803495:	85 c0                	test   %eax,%eax
  803497:	75 08                	jne    8034a1 <realloc_block_FF+0x199>
  803499:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80349c:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8034a6:	40                   	inc    %eax
  8034a7:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8034ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034b0:	75 17                	jne    8034c9 <realloc_block_FF+0x1c1>
  8034b2:	83 ec 04             	sub    $0x4,%esp
  8034b5:	68 83 45 80 00       	push   $0x804583
  8034ba:	68 f7 01 00 00       	push   $0x1f7
  8034bf:	68 a1 45 80 00       	push   $0x8045a1
  8034c4:	e8 cf ce ff ff       	call   800398 <_panic>
  8034c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cc:	8b 00                	mov    (%eax),%eax
  8034ce:	85 c0                	test   %eax,%eax
  8034d0:	74 10                	je     8034e2 <realloc_block_FF+0x1da>
  8034d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d5:	8b 00                	mov    (%eax),%eax
  8034d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034da:	8b 52 04             	mov    0x4(%edx),%edx
  8034dd:	89 50 04             	mov    %edx,0x4(%eax)
  8034e0:	eb 0b                	jmp    8034ed <realloc_block_FF+0x1e5>
  8034e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e5:	8b 40 04             	mov    0x4(%eax),%eax
  8034e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f0:	8b 40 04             	mov    0x4(%eax),%eax
  8034f3:	85 c0                	test   %eax,%eax
  8034f5:	74 0f                	je     803506 <realloc_block_FF+0x1fe>
  8034f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fa:	8b 40 04             	mov    0x4(%eax),%eax
  8034fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803500:	8b 12                	mov    (%edx),%edx
  803502:	89 10                	mov    %edx,(%eax)
  803504:	eb 0a                	jmp    803510 <realloc_block_FF+0x208>
  803506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803509:	8b 00                	mov    (%eax),%eax
  80350b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803513:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803523:	a1 38 50 80 00       	mov    0x805038,%eax
  803528:	48                   	dec    %eax
  803529:	a3 38 50 80 00       	mov    %eax,0x805038
  80352e:	e9 73 02 00 00       	jmp    8037a6 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803533:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803537:	0f 86 69 02 00 00    	jbe    8037a6 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80353d:	83 ec 04             	sub    $0x4,%esp
  803540:	6a 01                	push   $0x1
  803542:	ff 75 f0             	pushl  -0x10(%ebp)
  803545:	ff 75 08             	pushl  0x8(%ebp)
  803548:	e8 eb ed ff ff       	call   802338 <set_block_data>
  80354d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803550:	8b 45 08             	mov    0x8(%ebp),%eax
  803553:	83 e8 04             	sub    $0x4,%eax
  803556:	8b 00                	mov    (%eax),%eax
  803558:	83 e0 fe             	and    $0xfffffffe,%eax
  80355b:	89 c2                	mov    %eax,%edx
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	01 d0                	add    %edx,%eax
  803562:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803565:	a1 38 50 80 00       	mov    0x805038,%eax
  80356a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80356d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803571:	75 68                	jne    8035db <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803573:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803577:	75 17                	jne    803590 <realloc_block_FF+0x288>
  803579:	83 ec 04             	sub    $0x4,%esp
  80357c:	68 bc 45 80 00       	push   $0x8045bc
  803581:	68 06 02 00 00       	push   $0x206
  803586:	68 a1 45 80 00       	push   $0x8045a1
  80358b:	e8 08 ce ff ff       	call   800398 <_panic>
  803590:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803596:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803599:	89 10                	mov    %edx,(%eax)
  80359b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359e:	8b 00                	mov    (%eax),%eax
  8035a0:	85 c0                	test   %eax,%eax
  8035a2:	74 0d                	je     8035b1 <realloc_block_FF+0x2a9>
  8035a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ac:	89 50 04             	mov    %edx,0x4(%eax)
  8035af:	eb 08                	jmp    8035b9 <realloc_block_FF+0x2b1>
  8035b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d0:	40                   	inc    %eax
  8035d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8035d6:	e9 b0 01 00 00       	jmp    80378b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8035db:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035e0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035e3:	76 68                	jbe    80364d <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035e9:	75 17                	jne    803602 <realloc_block_FF+0x2fa>
  8035eb:	83 ec 04             	sub    $0x4,%esp
  8035ee:	68 bc 45 80 00       	push   $0x8045bc
  8035f3:	68 0b 02 00 00       	push   $0x20b
  8035f8:	68 a1 45 80 00       	push   $0x8045a1
  8035fd:	e8 96 cd ff ff       	call   800398 <_panic>
  803602:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803608:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360b:	89 10                	mov    %edx,(%eax)
  80360d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803610:	8b 00                	mov    (%eax),%eax
  803612:	85 c0                	test   %eax,%eax
  803614:	74 0d                	je     803623 <realloc_block_FF+0x31b>
  803616:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80361b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80361e:	89 50 04             	mov    %edx,0x4(%eax)
  803621:	eb 08                	jmp    80362b <realloc_block_FF+0x323>
  803623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803626:	a3 30 50 80 00       	mov    %eax,0x805030
  80362b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803633:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803636:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363d:	a1 38 50 80 00       	mov    0x805038,%eax
  803642:	40                   	inc    %eax
  803643:	a3 38 50 80 00       	mov    %eax,0x805038
  803648:	e9 3e 01 00 00       	jmp    80378b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80364d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803652:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803655:	73 68                	jae    8036bf <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803657:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80365b:	75 17                	jne    803674 <realloc_block_FF+0x36c>
  80365d:	83 ec 04             	sub    $0x4,%esp
  803660:	68 f0 45 80 00       	push   $0x8045f0
  803665:	68 10 02 00 00       	push   $0x210
  80366a:	68 a1 45 80 00       	push   $0x8045a1
  80366f:	e8 24 cd ff ff       	call   800398 <_panic>
  803674:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80367a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367d:	89 50 04             	mov    %edx,0x4(%eax)
  803680:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803683:	8b 40 04             	mov    0x4(%eax),%eax
  803686:	85 c0                	test   %eax,%eax
  803688:	74 0c                	je     803696 <realloc_block_FF+0x38e>
  80368a:	a1 30 50 80 00       	mov    0x805030,%eax
  80368f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803692:	89 10                	mov    %edx,(%eax)
  803694:	eb 08                	jmp    80369e <realloc_block_FF+0x396>
  803696:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803699:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80369e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8036a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036af:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b4:	40                   	inc    %eax
  8036b5:	a3 38 50 80 00       	mov    %eax,0x805038
  8036ba:	e9 cc 00 00 00       	jmp    80378b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8036bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8036c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ce:	e9 8a 00 00 00       	jmp    80375d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8036d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036d9:	73 7a                	jae    803755 <realloc_block_FF+0x44d>
  8036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036de:	8b 00                	mov    (%eax),%eax
  8036e0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036e3:	73 70                	jae    803755 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e9:	74 06                	je     8036f1 <realloc_block_FF+0x3e9>
  8036eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036ef:	75 17                	jne    803708 <realloc_block_FF+0x400>
  8036f1:	83 ec 04             	sub    $0x4,%esp
  8036f4:	68 14 46 80 00       	push   $0x804614
  8036f9:	68 1a 02 00 00       	push   $0x21a
  8036fe:	68 a1 45 80 00       	push   $0x8045a1
  803703:	e8 90 cc ff ff       	call   800398 <_panic>
  803708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370b:	8b 10                	mov    (%eax),%edx
  80370d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803710:	89 10                	mov    %edx,(%eax)
  803712:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803715:	8b 00                	mov    (%eax),%eax
  803717:	85 c0                	test   %eax,%eax
  803719:	74 0b                	je     803726 <realloc_block_FF+0x41e>
  80371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371e:	8b 00                	mov    (%eax),%eax
  803720:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803723:	89 50 04             	mov    %edx,0x4(%eax)
  803726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803729:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80372c:	89 10                	mov    %edx,(%eax)
  80372e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803734:	89 50 04             	mov    %edx,0x4(%eax)
  803737:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373a:	8b 00                	mov    (%eax),%eax
  80373c:	85 c0                	test   %eax,%eax
  80373e:	75 08                	jne    803748 <realloc_block_FF+0x440>
  803740:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803743:	a3 30 50 80 00       	mov    %eax,0x805030
  803748:	a1 38 50 80 00       	mov    0x805038,%eax
  80374d:	40                   	inc    %eax
  80374e:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803753:	eb 36                	jmp    80378b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803755:	a1 34 50 80 00       	mov    0x805034,%eax
  80375a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80375d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803761:	74 07                	je     80376a <realloc_block_FF+0x462>
  803763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	eb 05                	jmp    80376f <realloc_block_FF+0x467>
  80376a:	b8 00 00 00 00       	mov    $0x0,%eax
  80376f:	a3 34 50 80 00       	mov    %eax,0x805034
  803774:	a1 34 50 80 00       	mov    0x805034,%eax
  803779:	85 c0                	test   %eax,%eax
  80377b:	0f 85 52 ff ff ff    	jne    8036d3 <realloc_block_FF+0x3cb>
  803781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803785:	0f 85 48 ff ff ff    	jne    8036d3 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80378b:	83 ec 04             	sub    $0x4,%esp
  80378e:	6a 00                	push   $0x0
  803790:	ff 75 d8             	pushl  -0x28(%ebp)
  803793:	ff 75 d4             	pushl  -0x2c(%ebp)
  803796:	e8 9d eb ff ff       	call   802338 <set_block_data>
  80379b:	83 c4 10             	add    $0x10,%esp
				return va;
  80379e:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a1:	e9 6b 02 00 00       	jmp    803a11 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8037a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a9:	e9 63 02 00 00       	jmp    803a11 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8037ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037b4:	0f 86 4d 02 00 00    	jbe    803a07 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8037ba:	83 ec 0c             	sub    $0xc,%esp
  8037bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037c0:	e8 3b e8 ff ff       	call   802000 <is_free_block>
  8037c5:	83 c4 10             	add    $0x10,%esp
  8037c8:	84 c0                	test   %al,%al
  8037ca:	0f 84 37 02 00 00    	je     803a07 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037dc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037df:	76 38                	jbe    803819 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037e1:	83 ec 0c             	sub    $0xc,%esp
  8037e4:	ff 75 0c             	pushl  0xc(%ebp)
  8037e7:	e8 7b eb ff ff       	call   802367 <alloc_block_FF>
  8037ec:	83 c4 10             	add    $0x10,%esp
  8037ef:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037f2:	83 ec 08             	sub    $0x8,%esp
  8037f5:	ff 75 c0             	pushl  -0x40(%ebp)
  8037f8:	ff 75 08             	pushl  0x8(%ebp)
  8037fb:	e8 c9 fa ff ff       	call   8032c9 <copy_data>
  803800:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803803:	83 ec 0c             	sub    $0xc,%esp
  803806:	ff 75 08             	pushl  0x8(%ebp)
  803809:	e8 fa f9 ff ff       	call   803208 <free_block>
  80380e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803811:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803814:	e9 f8 01 00 00       	jmp    803a11 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803819:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80381c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80381f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803822:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803826:	0f 87 a0 00 00 00    	ja     8038cc <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80382c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803830:	75 17                	jne    803849 <realloc_block_FF+0x541>
  803832:	83 ec 04             	sub    $0x4,%esp
  803835:	68 83 45 80 00       	push   $0x804583
  80383a:	68 38 02 00 00       	push   $0x238
  80383f:	68 a1 45 80 00       	push   $0x8045a1
  803844:	e8 4f cb ff ff       	call   800398 <_panic>
  803849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384c:	8b 00                	mov    (%eax),%eax
  80384e:	85 c0                	test   %eax,%eax
  803850:	74 10                	je     803862 <realloc_block_FF+0x55a>
  803852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803855:	8b 00                	mov    (%eax),%eax
  803857:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80385a:	8b 52 04             	mov    0x4(%edx),%edx
  80385d:	89 50 04             	mov    %edx,0x4(%eax)
  803860:	eb 0b                	jmp    80386d <realloc_block_FF+0x565>
  803862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803865:	8b 40 04             	mov    0x4(%eax),%eax
  803868:	a3 30 50 80 00       	mov    %eax,0x805030
  80386d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803870:	8b 40 04             	mov    0x4(%eax),%eax
  803873:	85 c0                	test   %eax,%eax
  803875:	74 0f                	je     803886 <realloc_block_FF+0x57e>
  803877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387a:	8b 40 04             	mov    0x4(%eax),%eax
  80387d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803880:	8b 12                	mov    (%edx),%edx
  803882:	89 10                	mov    %edx,(%eax)
  803884:	eb 0a                	jmp    803890 <realloc_block_FF+0x588>
  803886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803889:	8b 00                	mov    (%eax),%eax
  80388b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803890:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a3:	a1 38 50 80 00       	mov    0x805038,%eax
  8038a8:	48                   	dec    %eax
  8038a9:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8038ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b4:	01 d0                	add    %edx,%eax
  8038b6:	83 ec 04             	sub    $0x4,%esp
  8038b9:	6a 01                	push   $0x1
  8038bb:	50                   	push   %eax
  8038bc:	ff 75 08             	pushl  0x8(%ebp)
  8038bf:	e8 74 ea ff ff       	call   802338 <set_block_data>
  8038c4:	83 c4 10             	add    $0x10,%esp
  8038c7:	e9 36 01 00 00       	jmp    803a02 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8038cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038d2:	01 d0                	add    %edx,%eax
  8038d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038d7:	83 ec 04             	sub    $0x4,%esp
  8038da:	6a 01                	push   $0x1
  8038dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8038df:	ff 75 08             	pushl  0x8(%ebp)
  8038e2:	e8 51 ea ff ff       	call   802338 <set_block_data>
  8038e7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ed:	83 e8 04             	sub    $0x4,%eax
  8038f0:	8b 00                	mov    (%eax),%eax
  8038f2:	83 e0 fe             	and    $0xfffffffe,%eax
  8038f5:	89 c2                	mov    %eax,%edx
  8038f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fa:	01 d0                	add    %edx,%eax
  8038fc:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803903:	74 06                	je     80390b <realloc_block_FF+0x603>
  803905:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803909:	75 17                	jne    803922 <realloc_block_FF+0x61a>
  80390b:	83 ec 04             	sub    $0x4,%esp
  80390e:	68 14 46 80 00       	push   $0x804614
  803913:	68 44 02 00 00       	push   $0x244
  803918:	68 a1 45 80 00       	push   $0x8045a1
  80391d:	e8 76 ca ff ff       	call   800398 <_panic>
  803922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803925:	8b 10                	mov    (%eax),%edx
  803927:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80392a:	89 10                	mov    %edx,(%eax)
  80392c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80392f:	8b 00                	mov    (%eax),%eax
  803931:	85 c0                	test   %eax,%eax
  803933:	74 0b                	je     803940 <realloc_block_FF+0x638>
  803935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803938:	8b 00                	mov    (%eax),%eax
  80393a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80393d:	89 50 04             	mov    %edx,0x4(%eax)
  803940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803943:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803946:	89 10                	mov    %edx,(%eax)
  803948:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80394b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80394e:	89 50 04             	mov    %edx,0x4(%eax)
  803951:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803954:	8b 00                	mov    (%eax),%eax
  803956:	85 c0                	test   %eax,%eax
  803958:	75 08                	jne    803962 <realloc_block_FF+0x65a>
  80395a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80395d:	a3 30 50 80 00       	mov    %eax,0x805030
  803962:	a1 38 50 80 00       	mov    0x805038,%eax
  803967:	40                   	inc    %eax
  803968:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80396d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803971:	75 17                	jne    80398a <realloc_block_FF+0x682>
  803973:	83 ec 04             	sub    $0x4,%esp
  803976:	68 83 45 80 00       	push   $0x804583
  80397b:	68 45 02 00 00       	push   $0x245
  803980:	68 a1 45 80 00       	push   $0x8045a1
  803985:	e8 0e ca ff ff       	call   800398 <_panic>
  80398a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398d:	8b 00                	mov    (%eax),%eax
  80398f:	85 c0                	test   %eax,%eax
  803991:	74 10                	je     8039a3 <realloc_block_FF+0x69b>
  803993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803996:	8b 00                	mov    (%eax),%eax
  803998:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80399b:	8b 52 04             	mov    0x4(%edx),%edx
  80399e:	89 50 04             	mov    %edx,0x4(%eax)
  8039a1:	eb 0b                	jmp    8039ae <realloc_block_FF+0x6a6>
  8039a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a6:	8b 40 04             	mov    0x4(%eax),%eax
  8039a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8039ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b1:	8b 40 04             	mov    0x4(%eax),%eax
  8039b4:	85 c0                	test   %eax,%eax
  8039b6:	74 0f                	je     8039c7 <realloc_block_FF+0x6bf>
  8039b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bb:	8b 40 04             	mov    0x4(%eax),%eax
  8039be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c1:	8b 12                	mov    (%edx),%edx
  8039c3:	89 10                	mov    %edx,(%eax)
  8039c5:	eb 0a                	jmp    8039d1 <realloc_block_FF+0x6c9>
  8039c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ca:	8b 00                	mov    (%eax),%eax
  8039cc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8039e9:	48                   	dec    %eax
  8039ea:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039ef:	83 ec 04             	sub    $0x4,%esp
  8039f2:	6a 00                	push   $0x0
  8039f4:	ff 75 bc             	pushl  -0x44(%ebp)
  8039f7:	ff 75 b8             	pushl  -0x48(%ebp)
  8039fa:	e8 39 e9 ff ff       	call   802338 <set_block_data>
  8039ff:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a02:	8b 45 08             	mov    0x8(%ebp),%eax
  803a05:	eb 0a                	jmp    803a11 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a07:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a0e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a11:	c9                   	leave  
  803a12:	c3                   	ret    

00803a13 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a13:	55                   	push   %ebp
  803a14:	89 e5                	mov    %esp,%ebp
  803a16:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a19:	83 ec 04             	sub    $0x4,%esp
  803a1c:	68 80 46 80 00       	push   $0x804680
  803a21:	68 58 02 00 00       	push   $0x258
  803a26:	68 a1 45 80 00       	push   $0x8045a1
  803a2b:	e8 68 c9 ff ff       	call   800398 <_panic>

00803a30 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a30:	55                   	push   %ebp
  803a31:	89 e5                	mov    %esp,%ebp
  803a33:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a36:	83 ec 04             	sub    $0x4,%esp
  803a39:	68 a8 46 80 00       	push   $0x8046a8
  803a3e:	68 61 02 00 00       	push   $0x261
  803a43:	68 a1 45 80 00       	push   $0x8045a1
  803a48:	e8 4b c9 ff ff       	call   800398 <_panic>
  803a4d:	66 90                	xchg   %ax,%ax
  803a4f:	90                   	nop

00803a50 <__udivdi3>:
  803a50:	55                   	push   %ebp
  803a51:	57                   	push   %edi
  803a52:	56                   	push   %esi
  803a53:	53                   	push   %ebx
  803a54:	83 ec 1c             	sub    $0x1c,%esp
  803a57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a67:	89 ca                	mov    %ecx,%edx
  803a69:	89 f8                	mov    %edi,%eax
  803a6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a6f:	85 f6                	test   %esi,%esi
  803a71:	75 2d                	jne    803aa0 <__udivdi3+0x50>
  803a73:	39 cf                	cmp    %ecx,%edi
  803a75:	77 65                	ja     803adc <__udivdi3+0x8c>
  803a77:	89 fd                	mov    %edi,%ebp
  803a79:	85 ff                	test   %edi,%edi
  803a7b:	75 0b                	jne    803a88 <__udivdi3+0x38>
  803a7d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a82:	31 d2                	xor    %edx,%edx
  803a84:	f7 f7                	div    %edi
  803a86:	89 c5                	mov    %eax,%ebp
  803a88:	31 d2                	xor    %edx,%edx
  803a8a:	89 c8                	mov    %ecx,%eax
  803a8c:	f7 f5                	div    %ebp
  803a8e:	89 c1                	mov    %eax,%ecx
  803a90:	89 d8                	mov    %ebx,%eax
  803a92:	f7 f5                	div    %ebp
  803a94:	89 cf                	mov    %ecx,%edi
  803a96:	89 fa                	mov    %edi,%edx
  803a98:	83 c4 1c             	add    $0x1c,%esp
  803a9b:	5b                   	pop    %ebx
  803a9c:	5e                   	pop    %esi
  803a9d:	5f                   	pop    %edi
  803a9e:	5d                   	pop    %ebp
  803a9f:	c3                   	ret    
  803aa0:	39 ce                	cmp    %ecx,%esi
  803aa2:	77 28                	ja     803acc <__udivdi3+0x7c>
  803aa4:	0f bd fe             	bsr    %esi,%edi
  803aa7:	83 f7 1f             	xor    $0x1f,%edi
  803aaa:	75 40                	jne    803aec <__udivdi3+0x9c>
  803aac:	39 ce                	cmp    %ecx,%esi
  803aae:	72 0a                	jb     803aba <__udivdi3+0x6a>
  803ab0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ab4:	0f 87 9e 00 00 00    	ja     803b58 <__udivdi3+0x108>
  803aba:	b8 01 00 00 00       	mov    $0x1,%eax
  803abf:	89 fa                	mov    %edi,%edx
  803ac1:	83 c4 1c             	add    $0x1c,%esp
  803ac4:	5b                   	pop    %ebx
  803ac5:	5e                   	pop    %esi
  803ac6:	5f                   	pop    %edi
  803ac7:	5d                   	pop    %ebp
  803ac8:	c3                   	ret    
  803ac9:	8d 76 00             	lea    0x0(%esi),%esi
  803acc:	31 ff                	xor    %edi,%edi
  803ace:	31 c0                	xor    %eax,%eax
  803ad0:	89 fa                	mov    %edi,%edx
  803ad2:	83 c4 1c             	add    $0x1c,%esp
  803ad5:	5b                   	pop    %ebx
  803ad6:	5e                   	pop    %esi
  803ad7:	5f                   	pop    %edi
  803ad8:	5d                   	pop    %ebp
  803ad9:	c3                   	ret    
  803ada:	66 90                	xchg   %ax,%ax
  803adc:	89 d8                	mov    %ebx,%eax
  803ade:	f7 f7                	div    %edi
  803ae0:	31 ff                	xor    %edi,%edi
  803ae2:	89 fa                	mov    %edi,%edx
  803ae4:	83 c4 1c             	add    $0x1c,%esp
  803ae7:	5b                   	pop    %ebx
  803ae8:	5e                   	pop    %esi
  803ae9:	5f                   	pop    %edi
  803aea:	5d                   	pop    %ebp
  803aeb:	c3                   	ret    
  803aec:	bd 20 00 00 00       	mov    $0x20,%ebp
  803af1:	89 eb                	mov    %ebp,%ebx
  803af3:	29 fb                	sub    %edi,%ebx
  803af5:	89 f9                	mov    %edi,%ecx
  803af7:	d3 e6                	shl    %cl,%esi
  803af9:	89 c5                	mov    %eax,%ebp
  803afb:	88 d9                	mov    %bl,%cl
  803afd:	d3 ed                	shr    %cl,%ebp
  803aff:	89 e9                	mov    %ebp,%ecx
  803b01:	09 f1                	or     %esi,%ecx
  803b03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b07:	89 f9                	mov    %edi,%ecx
  803b09:	d3 e0                	shl    %cl,%eax
  803b0b:	89 c5                	mov    %eax,%ebp
  803b0d:	89 d6                	mov    %edx,%esi
  803b0f:	88 d9                	mov    %bl,%cl
  803b11:	d3 ee                	shr    %cl,%esi
  803b13:	89 f9                	mov    %edi,%ecx
  803b15:	d3 e2                	shl    %cl,%edx
  803b17:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b1b:	88 d9                	mov    %bl,%cl
  803b1d:	d3 e8                	shr    %cl,%eax
  803b1f:	09 c2                	or     %eax,%edx
  803b21:	89 d0                	mov    %edx,%eax
  803b23:	89 f2                	mov    %esi,%edx
  803b25:	f7 74 24 0c          	divl   0xc(%esp)
  803b29:	89 d6                	mov    %edx,%esi
  803b2b:	89 c3                	mov    %eax,%ebx
  803b2d:	f7 e5                	mul    %ebp
  803b2f:	39 d6                	cmp    %edx,%esi
  803b31:	72 19                	jb     803b4c <__udivdi3+0xfc>
  803b33:	74 0b                	je     803b40 <__udivdi3+0xf0>
  803b35:	89 d8                	mov    %ebx,%eax
  803b37:	31 ff                	xor    %edi,%edi
  803b39:	e9 58 ff ff ff       	jmp    803a96 <__udivdi3+0x46>
  803b3e:	66 90                	xchg   %ax,%ax
  803b40:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b44:	89 f9                	mov    %edi,%ecx
  803b46:	d3 e2                	shl    %cl,%edx
  803b48:	39 c2                	cmp    %eax,%edx
  803b4a:	73 e9                	jae    803b35 <__udivdi3+0xe5>
  803b4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b4f:	31 ff                	xor    %edi,%edi
  803b51:	e9 40 ff ff ff       	jmp    803a96 <__udivdi3+0x46>
  803b56:	66 90                	xchg   %ax,%ax
  803b58:	31 c0                	xor    %eax,%eax
  803b5a:	e9 37 ff ff ff       	jmp    803a96 <__udivdi3+0x46>
  803b5f:	90                   	nop

00803b60 <__umoddi3>:
  803b60:	55                   	push   %ebp
  803b61:	57                   	push   %edi
  803b62:	56                   	push   %esi
  803b63:	53                   	push   %ebx
  803b64:	83 ec 1c             	sub    $0x1c,%esp
  803b67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b7f:	89 f3                	mov    %esi,%ebx
  803b81:	89 fa                	mov    %edi,%edx
  803b83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b87:	89 34 24             	mov    %esi,(%esp)
  803b8a:	85 c0                	test   %eax,%eax
  803b8c:	75 1a                	jne    803ba8 <__umoddi3+0x48>
  803b8e:	39 f7                	cmp    %esi,%edi
  803b90:	0f 86 a2 00 00 00    	jbe    803c38 <__umoddi3+0xd8>
  803b96:	89 c8                	mov    %ecx,%eax
  803b98:	89 f2                	mov    %esi,%edx
  803b9a:	f7 f7                	div    %edi
  803b9c:	89 d0                	mov    %edx,%eax
  803b9e:	31 d2                	xor    %edx,%edx
  803ba0:	83 c4 1c             	add    $0x1c,%esp
  803ba3:	5b                   	pop    %ebx
  803ba4:	5e                   	pop    %esi
  803ba5:	5f                   	pop    %edi
  803ba6:	5d                   	pop    %ebp
  803ba7:	c3                   	ret    
  803ba8:	39 f0                	cmp    %esi,%eax
  803baa:	0f 87 ac 00 00 00    	ja     803c5c <__umoddi3+0xfc>
  803bb0:	0f bd e8             	bsr    %eax,%ebp
  803bb3:	83 f5 1f             	xor    $0x1f,%ebp
  803bb6:	0f 84 ac 00 00 00    	je     803c68 <__umoddi3+0x108>
  803bbc:	bf 20 00 00 00       	mov    $0x20,%edi
  803bc1:	29 ef                	sub    %ebp,%edi
  803bc3:	89 fe                	mov    %edi,%esi
  803bc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bc9:	89 e9                	mov    %ebp,%ecx
  803bcb:	d3 e0                	shl    %cl,%eax
  803bcd:	89 d7                	mov    %edx,%edi
  803bcf:	89 f1                	mov    %esi,%ecx
  803bd1:	d3 ef                	shr    %cl,%edi
  803bd3:	09 c7                	or     %eax,%edi
  803bd5:	89 e9                	mov    %ebp,%ecx
  803bd7:	d3 e2                	shl    %cl,%edx
  803bd9:	89 14 24             	mov    %edx,(%esp)
  803bdc:	89 d8                	mov    %ebx,%eax
  803bde:	d3 e0                	shl    %cl,%eax
  803be0:	89 c2                	mov    %eax,%edx
  803be2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be6:	d3 e0                	shl    %cl,%eax
  803be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bec:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf0:	89 f1                	mov    %esi,%ecx
  803bf2:	d3 e8                	shr    %cl,%eax
  803bf4:	09 d0                	or     %edx,%eax
  803bf6:	d3 eb                	shr    %cl,%ebx
  803bf8:	89 da                	mov    %ebx,%edx
  803bfa:	f7 f7                	div    %edi
  803bfc:	89 d3                	mov    %edx,%ebx
  803bfe:	f7 24 24             	mull   (%esp)
  803c01:	89 c6                	mov    %eax,%esi
  803c03:	89 d1                	mov    %edx,%ecx
  803c05:	39 d3                	cmp    %edx,%ebx
  803c07:	0f 82 87 00 00 00    	jb     803c94 <__umoddi3+0x134>
  803c0d:	0f 84 91 00 00 00    	je     803ca4 <__umoddi3+0x144>
  803c13:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c17:	29 f2                	sub    %esi,%edx
  803c19:	19 cb                	sbb    %ecx,%ebx
  803c1b:	89 d8                	mov    %ebx,%eax
  803c1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c21:	d3 e0                	shl    %cl,%eax
  803c23:	89 e9                	mov    %ebp,%ecx
  803c25:	d3 ea                	shr    %cl,%edx
  803c27:	09 d0                	or     %edx,%eax
  803c29:	89 e9                	mov    %ebp,%ecx
  803c2b:	d3 eb                	shr    %cl,%ebx
  803c2d:	89 da                	mov    %ebx,%edx
  803c2f:	83 c4 1c             	add    $0x1c,%esp
  803c32:	5b                   	pop    %ebx
  803c33:	5e                   	pop    %esi
  803c34:	5f                   	pop    %edi
  803c35:	5d                   	pop    %ebp
  803c36:	c3                   	ret    
  803c37:	90                   	nop
  803c38:	89 fd                	mov    %edi,%ebp
  803c3a:	85 ff                	test   %edi,%edi
  803c3c:	75 0b                	jne    803c49 <__umoddi3+0xe9>
  803c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c43:	31 d2                	xor    %edx,%edx
  803c45:	f7 f7                	div    %edi
  803c47:	89 c5                	mov    %eax,%ebp
  803c49:	89 f0                	mov    %esi,%eax
  803c4b:	31 d2                	xor    %edx,%edx
  803c4d:	f7 f5                	div    %ebp
  803c4f:	89 c8                	mov    %ecx,%eax
  803c51:	f7 f5                	div    %ebp
  803c53:	89 d0                	mov    %edx,%eax
  803c55:	e9 44 ff ff ff       	jmp    803b9e <__umoddi3+0x3e>
  803c5a:	66 90                	xchg   %ax,%ax
  803c5c:	89 c8                	mov    %ecx,%eax
  803c5e:	89 f2                	mov    %esi,%edx
  803c60:	83 c4 1c             	add    $0x1c,%esp
  803c63:	5b                   	pop    %ebx
  803c64:	5e                   	pop    %esi
  803c65:	5f                   	pop    %edi
  803c66:	5d                   	pop    %ebp
  803c67:	c3                   	ret    
  803c68:	3b 04 24             	cmp    (%esp),%eax
  803c6b:	72 06                	jb     803c73 <__umoddi3+0x113>
  803c6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c71:	77 0f                	ja     803c82 <__umoddi3+0x122>
  803c73:	89 f2                	mov    %esi,%edx
  803c75:	29 f9                	sub    %edi,%ecx
  803c77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c7b:	89 14 24             	mov    %edx,(%esp)
  803c7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c82:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c86:	8b 14 24             	mov    (%esp),%edx
  803c89:	83 c4 1c             	add    $0x1c,%esp
  803c8c:	5b                   	pop    %ebx
  803c8d:	5e                   	pop    %esi
  803c8e:	5f                   	pop    %edi
  803c8f:	5d                   	pop    %ebp
  803c90:	c3                   	ret    
  803c91:	8d 76 00             	lea    0x0(%esi),%esi
  803c94:	2b 04 24             	sub    (%esp),%eax
  803c97:	19 fa                	sbb    %edi,%edx
  803c99:	89 d1                	mov    %edx,%ecx
  803c9b:	89 c6                	mov    %eax,%esi
  803c9d:	e9 71 ff ff ff       	jmp    803c13 <__umoddi3+0xb3>
  803ca2:	66 90                	xchg   %ax,%ax
  803ca4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ca8:	72 ea                	jb     803c94 <__umoddi3+0x134>
  803caa:	89 d9                	mov    %ebx,%ecx
  803cac:	e9 62 ff ff ff       	jmp    803c13 <__umoddi3+0xb3>
