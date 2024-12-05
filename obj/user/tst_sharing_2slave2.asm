
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
  80005c:	68 20 3c 80 00       	push   $0x803c20
  800061:	6a 0d                	push   $0xd
  800063:	68 3c 3c 80 00       	push   $0x803c3c
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
  80008c:	68 57 3c 80 00       	push   $0x803c57
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
  8000b6:	68 5c 3c 80 00       	push   $0x803c5c
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 3c 3c 80 00       	push   $0x803c3c
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
  8000f8:	68 d8 3c 80 00       	push   $0x803cd8
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 3c 3c 80 00       	push   $0x803c3c
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
  80011e:	68 70 3d 80 00       	push   $0x803d70
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
  80014d:	68 5c 3c 80 00       	push   $0x803c5c
  800152:	6a 31                	push   $0x31
  800154:	68 3c 3c 80 00       	push   $0x803c3c
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
  80018f:	68 d8 3c 80 00       	push   $0x803cd8
  800194:	6a 34                	push   $0x34
  800196:	68 3c 3c 80 00       	push   $0x803c3c
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
  8001b2:	68 74 3d 80 00       	push   $0x803d74
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 3c 3c 80 00       	push   $0x803c3c
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
  8001d9:	68 74 3d 80 00       	push   $0x803d74
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 3c 3c 80 00       	push   $0x803c3c
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
  80020d:	68 ac 3d 80 00       	push   $0x803dac
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
  800242:	68 dc 3d 80 00       	push   $0x803ddc
  800247:	6a 4d                	push   $0x4d
  800249:	68 3c 3c 80 00       	push   $0x803c3c
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
  8002d5:	68 3c 3e 80 00       	push   $0x803e3c
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
  8002fd:	68 64 3e 80 00       	push   $0x803e64
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
  80032e:	68 8c 3e 80 00       	push   $0x803e8c
  800333:	e8 1d 03 00 00       	call   800655 <cprintf>
  800338:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80033b:	a1 20 50 80 00       	mov    0x805020,%eax
  800340:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	50                   	push   %eax
  80034a:	68 e4 3e 80 00       	push   $0x803ee4
  80034f:	e8 01 03 00 00       	call   800655 <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	68 3c 3e 80 00       	push   $0x803e3c
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
  8003b9:	68 f8 3e 80 00       	push   $0x803ef8
  8003be:	e8 92 02 00 00       	call   800655 <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003c6:	a1 00 50 80 00       	mov    0x805000,%eax
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	50                   	push   %eax
  8003d2:	68 fd 3e 80 00       	push   $0x803efd
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
  8003f6:	68 19 3f 80 00       	push   $0x803f19
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
  800425:	68 1c 3f 80 00       	push   $0x803f1c
  80042a:	6a 26                	push   $0x26
  80042c:	68 68 3f 80 00       	push   $0x803f68
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
  8004fa:	68 74 3f 80 00       	push   $0x803f74
  8004ff:	6a 3a                	push   $0x3a
  800501:	68 68 3f 80 00       	push   $0x803f68
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
  80056d:	68 c8 3f 80 00       	push   $0x803fc8
  800572:	6a 44                	push   $0x44
  800574:	68 68 3f 80 00       	push   $0x803f68
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
  8006f2:	e8 bd 32 00 00       	call   8039b4 <__udivdi3>
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
  800742:	e8 7d 33 00 00       	call   803ac4 <__umoddi3>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	05 34 42 80 00       	add    $0x804234,%eax
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
  80089d:	8b 04 85 58 42 80 00 	mov    0x804258(,%eax,4),%eax
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
  80097e:	8b 34 9d a0 40 80 00 	mov    0x8040a0(,%ebx,4),%esi
  800985:	85 f6                	test   %esi,%esi
  800987:	75 19                	jne    8009a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800989:	53                   	push   %ebx
  80098a:	68 45 42 80 00       	push   $0x804245
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
  8009a3:	68 4e 42 80 00       	push   $0x80424e
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
  8009d0:	be 51 42 80 00       	mov    $0x804251,%esi
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
  8013db:	68 c8 43 80 00       	push   $0x8043c8
  8013e0:	68 3f 01 00 00       	push   $0x13f
  8013e5:	68 ea 43 80 00       	push   $0x8043ea
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
  801485:	e8 41 0e 00 00       	call   8022cb <alloc_block_FF>
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
  8014a8:	e8 da 12 00 00       	call   802787 <alloc_block_BF>
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
  801656:	e8 f0 08 00 00       	call   801f4b <get_block_size>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	e8 00 1b 00 00       	call   80316c <free_block>
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
  80170c:	68 f8 43 80 00       	push   $0x8043f8
  801711:	68 87 00 00 00       	push   $0x87
  801716:	68 22 44 80 00       	push   $0x804422
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
  8018b7:	68 30 44 80 00       	push   $0x804430
  8018bc:	68 e4 00 00 00       	push   $0xe4
  8018c1:	68 22 44 80 00       	push   $0x804422
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
  8018d4:	68 56 44 80 00       	push   $0x804456
  8018d9:	68 f0 00 00 00       	push   $0xf0
  8018de:	68 22 44 80 00       	push   $0x804422
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
  8018f1:	68 56 44 80 00       	push   $0x804456
  8018f6:	68 f5 00 00 00       	push   $0xf5
  8018fb:	68 22 44 80 00       	push   $0x804422
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
  80190e:	68 56 44 80 00       	push   $0x804456
  801913:	68 fa 00 00 00       	push   $0xfa
  801918:	68 22 44 80 00       	push   $0x804422
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

00801f4b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	83 e8 04             	sub    $0x4,%eax
  801f57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5d:	8b 00                	mov    (%eax),%eax
  801f5f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	83 e8 04             	sub    $0x4,%eax
  801f70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f76:	8b 00                	mov    (%eax),%eax
  801f78:	83 e0 01             	and    $0x1,%eax
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	0f 94 c0             	sete   %al
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f92:	83 f8 02             	cmp    $0x2,%eax
  801f95:	74 2b                	je     801fc2 <alloc_block+0x40>
  801f97:	83 f8 02             	cmp    $0x2,%eax
  801f9a:	7f 07                	jg     801fa3 <alloc_block+0x21>
  801f9c:	83 f8 01             	cmp    $0x1,%eax
  801f9f:	74 0e                	je     801faf <alloc_block+0x2d>
  801fa1:	eb 58                	jmp    801ffb <alloc_block+0x79>
  801fa3:	83 f8 03             	cmp    $0x3,%eax
  801fa6:	74 2d                	je     801fd5 <alloc_block+0x53>
  801fa8:	83 f8 04             	cmp    $0x4,%eax
  801fab:	74 3b                	je     801fe8 <alloc_block+0x66>
  801fad:	eb 4c                	jmp    801ffb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801faf:	83 ec 0c             	sub    $0xc,%esp
  801fb2:	ff 75 08             	pushl  0x8(%ebp)
  801fb5:	e8 11 03 00 00       	call   8022cb <alloc_block_FF>
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fc0:	eb 4a                	jmp    80200c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fc2:	83 ec 0c             	sub    $0xc,%esp
  801fc5:	ff 75 08             	pushl  0x8(%ebp)
  801fc8:	e8 c7 19 00 00       	call   803994 <alloc_block_NF>
  801fcd:	83 c4 10             	add    $0x10,%esp
  801fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd3:	eb 37                	jmp    80200c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	e8 a7 07 00 00       	call   802787 <alloc_block_BF>
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe6:	eb 24                	jmp    80200c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	ff 75 08             	pushl  0x8(%ebp)
  801fee:	e8 84 19 00 00       	call   803977 <alloc_block_WF>
  801ff3:	83 c4 10             	add    $0x10,%esp
  801ff6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ff9:	eb 11                	jmp    80200c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ffb:	83 ec 0c             	sub    $0xc,%esp
  801ffe:	68 68 44 80 00       	push   $0x804468
  802003:	e8 4d e6 ff ff       	call   800655 <cprintf>
  802008:	83 c4 10             	add    $0x10,%esp
		break;
  80200b:	90                   	nop
	}
	return va;
  80200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	53                   	push   %ebx
  802015:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	68 88 44 80 00       	push   $0x804488
  802020:	e8 30 e6 ff ff       	call   800655 <cprintf>
  802025:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802028:	83 ec 0c             	sub    $0xc,%esp
  80202b:	68 b3 44 80 00       	push   $0x8044b3
  802030:	e8 20 e6 ff ff       	call   800655 <cprintf>
  802035:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203e:	eb 37                	jmp    802077 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802040:	83 ec 0c             	sub    $0xc,%esp
  802043:	ff 75 f4             	pushl  -0xc(%ebp)
  802046:	e8 19 ff ff ff       	call   801f64 <is_free_block>
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	0f be d8             	movsbl %al,%ebx
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	ff 75 f4             	pushl  -0xc(%ebp)
  802057:	e8 ef fe ff ff       	call   801f4b <get_block_size>
  80205c:	83 c4 10             	add    $0x10,%esp
  80205f:	83 ec 04             	sub    $0x4,%esp
  802062:	53                   	push   %ebx
  802063:	50                   	push   %eax
  802064:	68 cb 44 80 00       	push   $0x8044cb
  802069:	e8 e7 e5 ff ff       	call   800655 <cprintf>
  80206e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802071:	8b 45 10             	mov    0x10(%ebp),%eax
  802074:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802077:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207b:	74 07                	je     802084 <print_blocks_list+0x73>
  80207d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802080:	8b 00                	mov    (%eax),%eax
  802082:	eb 05                	jmp    802089 <print_blocks_list+0x78>
  802084:	b8 00 00 00 00       	mov    $0x0,%eax
  802089:	89 45 10             	mov    %eax,0x10(%ebp)
  80208c:	8b 45 10             	mov    0x10(%ebp),%eax
  80208f:	85 c0                	test   %eax,%eax
  802091:	75 ad                	jne    802040 <print_blocks_list+0x2f>
  802093:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802097:	75 a7                	jne    802040 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802099:	83 ec 0c             	sub    $0xc,%esp
  80209c:	68 88 44 80 00       	push   $0x804488
  8020a1:	e8 af e5 ff ff       	call   800655 <cprintf>
  8020a6:	83 c4 10             	add    $0x10,%esp

}
  8020a9:	90                   	nop
  8020aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b8:	83 e0 01             	and    $0x1,%eax
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	74 03                	je     8020c2 <initialize_dynamic_allocator+0x13>
  8020bf:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020c6:	0f 84 c7 01 00 00    	je     802293 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020cc:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020d3:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020dc:	01 d0                	add    %edx,%eax
  8020de:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020e3:	0f 87 ad 01 00 00    	ja     802296 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	0f 89 a5 01 00 00    	jns    802299 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fa:	01 d0                	add    %edx,%eax
  8020fc:	83 e8 04             	sub    $0x4,%eax
  8020ff:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802104:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80210b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802110:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802113:	e9 87 00 00 00       	jmp    80219f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802118:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211c:	75 14                	jne    802132 <initialize_dynamic_allocator+0x83>
  80211e:	83 ec 04             	sub    $0x4,%esp
  802121:	68 e3 44 80 00       	push   $0x8044e3
  802126:	6a 79                	push   $0x79
  802128:	68 01 45 80 00       	push   $0x804501
  80212d:	e8 66 e2 ff ff       	call   800398 <_panic>
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 00                	mov    (%eax),%eax
  802137:	85 c0                	test   %eax,%eax
  802139:	74 10                	je     80214b <initialize_dynamic_allocator+0x9c>
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	8b 00                	mov    (%eax),%eax
  802140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802143:	8b 52 04             	mov    0x4(%edx),%edx
  802146:	89 50 04             	mov    %edx,0x4(%eax)
  802149:	eb 0b                	jmp    802156 <initialize_dynamic_allocator+0xa7>
  80214b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214e:	8b 40 04             	mov    0x4(%eax),%eax
  802151:	a3 30 50 80 00       	mov    %eax,0x805030
  802156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802159:	8b 40 04             	mov    0x4(%eax),%eax
  80215c:	85 c0                	test   %eax,%eax
  80215e:	74 0f                	je     80216f <initialize_dynamic_allocator+0xc0>
  802160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802163:	8b 40 04             	mov    0x4(%eax),%eax
  802166:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802169:	8b 12                	mov    (%edx),%edx
  80216b:	89 10                	mov    %edx,(%eax)
  80216d:	eb 0a                	jmp    802179 <initialize_dynamic_allocator+0xca>
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	8b 00                	mov    (%eax),%eax
  802174:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218c:	a1 38 50 80 00       	mov    0x805038,%eax
  802191:	48                   	dec    %eax
  802192:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802197:	a1 34 50 80 00       	mov    0x805034,%eax
  80219c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a3:	74 07                	je     8021ac <initialize_dynamic_allocator+0xfd>
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	8b 00                	mov    (%eax),%eax
  8021aa:	eb 05                	jmp    8021b1 <initialize_dynamic_allocator+0x102>
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b1:	a3 34 50 80 00       	mov    %eax,0x805034
  8021b6:	a1 34 50 80 00       	mov    0x805034,%eax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	0f 85 55 ff ff ff    	jne    802118 <initialize_dynamic_allocator+0x69>
  8021c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c7:	0f 85 4b ff ff ff    	jne    802118 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021dc:	a1 44 50 80 00       	mov    0x805044,%eax
  8021e1:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021e6:	a1 40 50 80 00       	mov    0x805040,%eax
  8021eb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	83 c0 08             	add    $0x8,%eax
  8021f7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	83 c0 04             	add    $0x4,%eax
  802200:	8b 55 0c             	mov    0xc(%ebp),%edx
  802203:	83 ea 08             	sub    $0x8,%edx
  802206:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802208:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	01 d0                	add    %edx,%eax
  802210:	83 e8 08             	sub    $0x8,%eax
  802213:	8b 55 0c             	mov    0xc(%ebp),%edx
  802216:	83 ea 08             	sub    $0x8,%edx
  802219:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80221b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802227:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80222e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802232:	75 17                	jne    80224b <initialize_dynamic_allocator+0x19c>
  802234:	83 ec 04             	sub    $0x4,%esp
  802237:	68 1c 45 80 00       	push   $0x80451c
  80223c:	68 90 00 00 00       	push   $0x90
  802241:	68 01 45 80 00       	push   $0x804501
  802246:	e8 4d e1 ff ff       	call   800398 <_panic>
  80224b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802251:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802254:	89 10                	mov    %edx,(%eax)
  802256:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802259:	8b 00                	mov    (%eax),%eax
  80225b:	85 c0                	test   %eax,%eax
  80225d:	74 0d                	je     80226c <initialize_dynamic_allocator+0x1bd>
  80225f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802264:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802267:	89 50 04             	mov    %edx,0x4(%eax)
  80226a:	eb 08                	jmp    802274 <initialize_dynamic_allocator+0x1c5>
  80226c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226f:	a3 30 50 80 00       	mov    %eax,0x805030
  802274:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802277:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80227c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802286:	a1 38 50 80 00       	mov    0x805038,%eax
  80228b:	40                   	inc    %eax
  80228c:	a3 38 50 80 00       	mov    %eax,0x805038
  802291:	eb 07                	jmp    80229a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802293:	90                   	nop
  802294:	eb 04                	jmp    80229a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802296:	90                   	nop
  802297:	eb 01                	jmp    80229a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802299:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80229f:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a2:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ae:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	83 e8 04             	sub    $0x4,%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	83 e0 fe             	and    $0xfffffffe,%eax
  8022bb:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	01 c2                	add    %eax,%edx
  8022c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c6:	89 02                	mov    %eax,(%edx)
}
  8022c8:	90                   	nop
  8022c9:	5d                   	pop    %ebp
  8022ca:	c3                   	ret    

008022cb <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	83 e0 01             	and    $0x1,%eax
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	74 03                	je     8022de <alloc_block_FF+0x13>
  8022db:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022de:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022e2:	77 07                	ja     8022eb <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022e4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022eb:	a1 24 50 80 00       	mov    0x805024,%eax
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	75 73                	jne    802367 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	83 c0 10             	add    $0x10,%eax
  8022fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022fd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802304:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230a:	01 d0                	add    %edx,%eax
  80230c:	48                   	dec    %eax
  80230d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802310:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802313:	ba 00 00 00 00       	mov    $0x0,%edx
  802318:	f7 75 ec             	divl   -0x14(%ebp)
  80231b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80231e:	29 d0                	sub    %edx,%eax
  802320:	c1 e8 0c             	shr    $0xc,%eax
  802323:	83 ec 0c             	sub    $0xc,%esp
  802326:	50                   	push   %eax
  802327:	e8 c3 f0 ff ff       	call   8013ef <sbrk>
  80232c:	83 c4 10             	add    $0x10,%esp
  80232f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802332:	83 ec 0c             	sub    $0xc,%esp
  802335:	6a 00                	push   $0x0
  802337:	e8 b3 f0 ff ff       	call   8013ef <sbrk>
  80233c:	83 c4 10             	add    $0x10,%esp
  80233f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802345:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802348:	83 ec 08             	sub    $0x8,%esp
  80234b:	50                   	push   %eax
  80234c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80234f:	e8 5b fd ff ff       	call   8020af <initialize_dynamic_allocator>
  802354:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802357:	83 ec 0c             	sub    $0xc,%esp
  80235a:	68 3f 45 80 00       	push   $0x80453f
  80235f:	e8 f1 e2 ff ff       	call   800655 <cprintf>
  802364:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802367:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80236b:	75 0a                	jne    802377 <alloc_block_FF+0xac>
	        return NULL;
  80236d:	b8 00 00 00 00       	mov    $0x0,%eax
  802372:	e9 0e 04 00 00       	jmp    802785 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802377:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80237e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802386:	e9 f3 02 00 00       	jmp    80267e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802391:	83 ec 0c             	sub    $0xc,%esp
  802394:	ff 75 bc             	pushl  -0x44(%ebp)
  802397:	e8 af fb ff ff       	call   801f4b <get_block_size>
  80239c:	83 c4 10             	add    $0x10,%esp
  80239f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	83 c0 08             	add    $0x8,%eax
  8023a8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023ab:	0f 87 c5 02 00 00    	ja     802676 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	83 c0 18             	add    $0x18,%eax
  8023b7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023ba:	0f 87 19 02 00 00    	ja     8025d9 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023c3:	2b 45 08             	sub    0x8(%ebp),%eax
  8023c6:	83 e8 08             	sub    $0x8,%eax
  8023c9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	8d 50 08             	lea    0x8(%eax),%edx
  8023d2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023d5:	01 d0                	add    %edx,%eax
  8023d7:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	83 c0 08             	add    $0x8,%eax
  8023e0:	83 ec 04             	sub    $0x4,%esp
  8023e3:	6a 01                	push   $0x1
  8023e5:	50                   	push   %eax
  8023e6:	ff 75 bc             	pushl  -0x44(%ebp)
  8023e9:	e8 ae fe ff ff       	call   80229c <set_block_data>
  8023ee:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	8b 40 04             	mov    0x4(%eax),%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	75 68                	jne    802463 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023fb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023ff:	75 17                	jne    802418 <alloc_block_FF+0x14d>
  802401:	83 ec 04             	sub    $0x4,%esp
  802404:	68 1c 45 80 00       	push   $0x80451c
  802409:	68 d7 00 00 00       	push   $0xd7
  80240e:	68 01 45 80 00       	push   $0x804501
  802413:	e8 80 df ff ff       	call   800398 <_panic>
  802418:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80241e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802421:	89 10                	mov    %edx,(%eax)
  802423:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802426:	8b 00                	mov    (%eax),%eax
  802428:	85 c0                	test   %eax,%eax
  80242a:	74 0d                	je     802439 <alloc_block_FF+0x16e>
  80242c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802431:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802434:	89 50 04             	mov    %edx,0x4(%eax)
  802437:	eb 08                	jmp    802441 <alloc_block_FF+0x176>
  802439:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243c:	a3 30 50 80 00       	mov    %eax,0x805030
  802441:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802444:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802449:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802453:	a1 38 50 80 00       	mov    0x805038,%eax
  802458:	40                   	inc    %eax
  802459:	a3 38 50 80 00       	mov    %eax,0x805038
  80245e:	e9 dc 00 00 00       	jmp    80253f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	85 c0                	test   %eax,%eax
  80246a:	75 65                	jne    8024d1 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80246c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802470:	75 17                	jne    802489 <alloc_block_FF+0x1be>
  802472:	83 ec 04             	sub    $0x4,%esp
  802475:	68 50 45 80 00       	push   $0x804550
  80247a:	68 db 00 00 00       	push   $0xdb
  80247f:	68 01 45 80 00       	push   $0x804501
  802484:	e8 0f df ff ff       	call   800398 <_panic>
  802489:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80248f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802492:	89 50 04             	mov    %edx,0x4(%eax)
  802495:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802498:	8b 40 04             	mov    0x4(%eax),%eax
  80249b:	85 c0                	test   %eax,%eax
  80249d:	74 0c                	je     8024ab <alloc_block_FF+0x1e0>
  80249f:	a1 30 50 80 00       	mov    0x805030,%eax
  8024a4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024a7:	89 10                	mov    %edx,(%eax)
  8024a9:	eb 08                	jmp    8024b3 <alloc_block_FF+0x1e8>
  8024ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8024bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c4:	a1 38 50 80 00       	mov    0x805038,%eax
  8024c9:	40                   	inc    %eax
  8024ca:	a3 38 50 80 00       	mov    %eax,0x805038
  8024cf:	eb 6e                	jmp    80253f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d5:	74 06                	je     8024dd <alloc_block_FF+0x212>
  8024d7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024db:	75 17                	jne    8024f4 <alloc_block_FF+0x229>
  8024dd:	83 ec 04             	sub    $0x4,%esp
  8024e0:	68 74 45 80 00       	push   $0x804574
  8024e5:	68 df 00 00 00       	push   $0xdf
  8024ea:	68 01 45 80 00       	push   $0x804501
  8024ef:	e8 a4 de ff ff       	call   800398 <_panic>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 10                	mov    (%eax),%edx
  8024f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fc:	89 10                	mov    %edx,(%eax)
  8024fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802501:	8b 00                	mov    (%eax),%eax
  802503:	85 c0                	test   %eax,%eax
  802505:	74 0b                	je     802512 <alloc_block_FF+0x247>
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 00                	mov    (%eax),%eax
  80250c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80250f:	89 50 04             	mov    %edx,0x4(%eax)
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802518:	89 10                	mov    %edx,(%eax)
  80251a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802520:	89 50 04             	mov    %edx,0x4(%eax)
  802523:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802526:	8b 00                	mov    (%eax),%eax
  802528:	85 c0                	test   %eax,%eax
  80252a:	75 08                	jne    802534 <alloc_block_FF+0x269>
  80252c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80252f:	a3 30 50 80 00       	mov    %eax,0x805030
  802534:	a1 38 50 80 00       	mov    0x805038,%eax
  802539:	40                   	inc    %eax
  80253a:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80253f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802543:	75 17                	jne    80255c <alloc_block_FF+0x291>
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	68 e3 44 80 00       	push   $0x8044e3
  80254d:	68 e1 00 00 00       	push   $0xe1
  802552:	68 01 45 80 00       	push   $0x804501
  802557:	e8 3c de ff ff       	call   800398 <_panic>
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	8b 00                	mov    (%eax),%eax
  802561:	85 c0                	test   %eax,%eax
  802563:	74 10                	je     802575 <alloc_block_FF+0x2aa>
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256d:	8b 52 04             	mov    0x4(%edx),%edx
  802570:	89 50 04             	mov    %edx,0x4(%eax)
  802573:	eb 0b                	jmp    802580 <alloc_block_FF+0x2b5>
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 40 04             	mov    0x4(%eax),%eax
  80257b:	a3 30 50 80 00       	mov    %eax,0x805030
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 04             	mov    0x4(%eax),%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	74 0f                	je     802599 <alloc_block_FF+0x2ce>
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 40 04             	mov    0x4(%eax),%eax
  802590:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802593:	8b 12                	mov    (%edx),%edx
  802595:	89 10                	mov    %edx,(%eax)
  802597:	eb 0a                	jmp    8025a3 <alloc_block_FF+0x2d8>
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 00                	mov    (%eax),%eax
  80259e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8025bb:	48                   	dec    %eax
  8025bc:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025c1:	83 ec 04             	sub    $0x4,%esp
  8025c4:	6a 00                	push   $0x0
  8025c6:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025c9:	ff 75 b0             	pushl  -0x50(%ebp)
  8025cc:	e8 cb fc ff ff       	call   80229c <set_block_data>
  8025d1:	83 c4 10             	add    $0x10,%esp
  8025d4:	e9 95 00 00 00       	jmp    80266e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025d9:	83 ec 04             	sub    $0x4,%esp
  8025dc:	6a 01                	push   $0x1
  8025de:	ff 75 b8             	pushl  -0x48(%ebp)
  8025e1:	ff 75 bc             	pushl  -0x44(%ebp)
  8025e4:	e8 b3 fc ff ff       	call   80229c <set_block_data>
  8025e9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f0:	75 17                	jne    802609 <alloc_block_FF+0x33e>
  8025f2:	83 ec 04             	sub    $0x4,%esp
  8025f5:	68 e3 44 80 00       	push   $0x8044e3
  8025fa:	68 e8 00 00 00       	push   $0xe8
  8025ff:	68 01 45 80 00       	push   $0x804501
  802604:	e8 8f dd ff ff       	call   800398 <_panic>
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	8b 00                	mov    (%eax),%eax
  80260e:	85 c0                	test   %eax,%eax
  802610:	74 10                	je     802622 <alloc_block_FF+0x357>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261a:	8b 52 04             	mov    0x4(%edx),%edx
  80261d:	89 50 04             	mov    %edx,0x4(%eax)
  802620:	eb 0b                	jmp    80262d <alloc_block_FF+0x362>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 40 04             	mov    0x4(%eax),%eax
  802628:	a3 30 50 80 00       	mov    %eax,0x805030
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 40 04             	mov    0x4(%eax),%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	74 0f                	je     802646 <alloc_block_FF+0x37b>
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 40 04             	mov    0x4(%eax),%eax
  80263d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802640:	8b 12                	mov    (%edx),%edx
  802642:	89 10                	mov    %edx,(%eax)
  802644:	eb 0a                	jmp    802650 <alloc_block_FF+0x385>
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 00                	mov    (%eax),%eax
  80264b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802663:	a1 38 50 80 00       	mov    0x805038,%eax
  802668:	48                   	dec    %eax
  802669:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80266e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802671:	e9 0f 01 00 00       	jmp    802785 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802676:	a1 34 50 80 00       	mov    0x805034,%eax
  80267b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802682:	74 07                	je     80268b <alloc_block_FF+0x3c0>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	eb 05                	jmp    802690 <alloc_block_FF+0x3c5>
  80268b:	b8 00 00 00 00       	mov    $0x0,%eax
  802690:	a3 34 50 80 00       	mov    %eax,0x805034
  802695:	a1 34 50 80 00       	mov    0x805034,%eax
  80269a:	85 c0                	test   %eax,%eax
  80269c:	0f 85 e9 fc ff ff    	jne    80238b <alloc_block_FF+0xc0>
  8026a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a6:	0f 85 df fc ff ff    	jne    80238b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	83 c0 08             	add    $0x8,%eax
  8026b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026b5:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026c2:	01 d0                	add    %edx,%eax
  8026c4:	48                   	dec    %eax
  8026c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d0:	f7 75 d8             	divl   -0x28(%ebp)
  8026d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026d6:	29 d0                	sub    %edx,%eax
  8026d8:	c1 e8 0c             	shr    $0xc,%eax
  8026db:	83 ec 0c             	sub    $0xc,%esp
  8026de:	50                   	push   %eax
  8026df:	e8 0b ed ff ff       	call   8013ef <sbrk>
  8026e4:	83 c4 10             	add    $0x10,%esp
  8026e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026ea:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026ee:	75 0a                	jne    8026fa <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f5:	e9 8b 00 00 00       	jmp    802785 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026fa:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802701:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802704:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802707:	01 d0                	add    %edx,%eax
  802709:	48                   	dec    %eax
  80270a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80270d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802710:	ba 00 00 00 00       	mov    $0x0,%edx
  802715:	f7 75 cc             	divl   -0x34(%ebp)
  802718:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80271b:	29 d0                	sub    %edx,%eax
  80271d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802720:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802723:	01 d0                	add    %edx,%eax
  802725:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80272a:	a1 40 50 80 00       	mov    0x805040,%eax
  80272f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802735:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80273c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80273f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802742:	01 d0                	add    %edx,%eax
  802744:	48                   	dec    %eax
  802745:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802748:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80274b:	ba 00 00 00 00       	mov    $0x0,%edx
  802750:	f7 75 c4             	divl   -0x3c(%ebp)
  802753:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802756:	29 d0                	sub    %edx,%eax
  802758:	83 ec 04             	sub    $0x4,%esp
  80275b:	6a 01                	push   $0x1
  80275d:	50                   	push   %eax
  80275e:	ff 75 d0             	pushl  -0x30(%ebp)
  802761:	e8 36 fb ff ff       	call   80229c <set_block_data>
  802766:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802769:	83 ec 0c             	sub    $0xc,%esp
  80276c:	ff 75 d0             	pushl  -0x30(%ebp)
  80276f:	e8 f8 09 00 00       	call   80316c <free_block>
  802774:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802777:	83 ec 0c             	sub    $0xc,%esp
  80277a:	ff 75 08             	pushl  0x8(%ebp)
  80277d:	e8 49 fb ff ff       	call   8022cb <alloc_block_FF>
  802782:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80278d:	8b 45 08             	mov    0x8(%ebp),%eax
  802790:	83 e0 01             	and    $0x1,%eax
  802793:	85 c0                	test   %eax,%eax
  802795:	74 03                	je     80279a <alloc_block_BF+0x13>
  802797:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80279a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80279e:	77 07                	ja     8027a7 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027a0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027a7:	a1 24 50 80 00       	mov    0x805024,%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	75 73                	jne    802823 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b3:	83 c0 10             	add    $0x10,%eax
  8027b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027b9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c6:	01 d0                	add    %edx,%eax
  8027c8:	48                   	dec    %eax
  8027c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d4:	f7 75 e0             	divl   -0x20(%ebp)
  8027d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027da:	29 d0                	sub    %edx,%eax
  8027dc:	c1 e8 0c             	shr    $0xc,%eax
  8027df:	83 ec 0c             	sub    $0xc,%esp
  8027e2:	50                   	push   %eax
  8027e3:	e8 07 ec ff ff       	call   8013ef <sbrk>
  8027e8:	83 c4 10             	add    $0x10,%esp
  8027eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027ee:	83 ec 0c             	sub    $0xc,%esp
  8027f1:	6a 00                	push   $0x0
  8027f3:	e8 f7 eb ff ff       	call   8013ef <sbrk>
  8027f8:	83 c4 10             	add    $0x10,%esp
  8027fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802801:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802804:	83 ec 08             	sub    $0x8,%esp
  802807:	50                   	push   %eax
  802808:	ff 75 d8             	pushl  -0x28(%ebp)
  80280b:	e8 9f f8 ff ff       	call   8020af <initialize_dynamic_allocator>
  802810:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802813:	83 ec 0c             	sub    $0xc,%esp
  802816:	68 3f 45 80 00       	push   $0x80453f
  80281b:	e8 35 de ff ff       	call   800655 <cprintf>
  802820:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802823:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80282a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802831:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802838:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80283f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802844:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802847:	e9 1d 01 00 00       	jmp    802969 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802852:	83 ec 0c             	sub    $0xc,%esp
  802855:	ff 75 a8             	pushl  -0x58(%ebp)
  802858:	e8 ee f6 ff ff       	call   801f4b <get_block_size>
  80285d:	83 c4 10             	add    $0x10,%esp
  802860:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	83 c0 08             	add    $0x8,%eax
  802869:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80286c:	0f 87 ef 00 00 00    	ja     802961 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	83 c0 18             	add    $0x18,%eax
  802878:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80287b:	77 1d                	ja     80289a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80287d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802880:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802883:	0f 86 d8 00 00 00    	jbe    802961 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802889:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80288c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80288f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802892:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802895:	e9 c7 00 00 00       	jmp    802961 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	83 c0 08             	add    $0x8,%eax
  8028a0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a3:	0f 85 9d 00 00 00    	jne    802946 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028a9:	83 ec 04             	sub    $0x4,%esp
  8028ac:	6a 01                	push   $0x1
  8028ae:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028b1:	ff 75 a8             	pushl  -0x58(%ebp)
  8028b4:	e8 e3 f9 ff ff       	call   80229c <set_block_data>
  8028b9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c0:	75 17                	jne    8028d9 <alloc_block_BF+0x152>
  8028c2:	83 ec 04             	sub    $0x4,%esp
  8028c5:	68 e3 44 80 00       	push   $0x8044e3
  8028ca:	68 2c 01 00 00       	push   $0x12c
  8028cf:	68 01 45 80 00       	push   $0x804501
  8028d4:	e8 bf da ff ff       	call   800398 <_panic>
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	74 10                	je     8028f2 <alloc_block_BF+0x16b>
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ea:	8b 52 04             	mov    0x4(%edx),%edx
  8028ed:	89 50 04             	mov    %edx,0x4(%eax)
  8028f0:	eb 0b                	jmp    8028fd <alloc_block_BF+0x176>
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	8b 40 04             	mov    0x4(%eax),%eax
  8028f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 40 04             	mov    0x4(%eax),%eax
  802903:	85 c0                	test   %eax,%eax
  802905:	74 0f                	je     802916 <alloc_block_BF+0x18f>
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	8b 40 04             	mov    0x4(%eax),%eax
  80290d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802910:	8b 12                	mov    (%edx),%edx
  802912:	89 10                	mov    %edx,(%eax)
  802914:	eb 0a                	jmp    802920 <alloc_block_BF+0x199>
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802933:	a1 38 50 80 00       	mov    0x805038,%eax
  802938:	48                   	dec    %eax
  802939:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80293e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802941:	e9 01 04 00 00       	jmp    802d47 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802949:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80294c:	76 13                	jbe    802961 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80294e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802955:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802958:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80295b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80295e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802961:	a1 34 50 80 00       	mov    0x805034,%eax
  802966:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802969:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296d:	74 07                	je     802976 <alloc_block_BF+0x1ef>
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 00                	mov    (%eax),%eax
  802974:	eb 05                	jmp    80297b <alloc_block_BF+0x1f4>
  802976:	b8 00 00 00 00       	mov    $0x0,%eax
  80297b:	a3 34 50 80 00       	mov    %eax,0x805034
  802980:	a1 34 50 80 00       	mov    0x805034,%eax
  802985:	85 c0                	test   %eax,%eax
  802987:	0f 85 bf fe ff ff    	jne    80284c <alloc_block_BF+0xc5>
  80298d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802991:	0f 85 b5 fe ff ff    	jne    80284c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802997:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80299b:	0f 84 26 02 00 00    	je     802bc7 <alloc_block_BF+0x440>
  8029a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029a5:	0f 85 1c 02 00 00    	jne    802bc7 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ae:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b1:	83 e8 08             	sub    $0x8,%eax
  8029b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	8d 50 08             	lea    0x8(%eax),%edx
  8029bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c0:	01 d0                	add    %edx,%eax
  8029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c8:	83 c0 08             	add    $0x8,%eax
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	6a 01                	push   $0x1
  8029d0:	50                   	push   %eax
  8029d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8029d4:	e8 c3 f8 ff ff       	call   80229c <set_block_data>
  8029d9:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029df:	8b 40 04             	mov    0x4(%eax),%eax
  8029e2:	85 c0                	test   %eax,%eax
  8029e4:	75 68                	jne    802a4e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029ea:	75 17                	jne    802a03 <alloc_block_BF+0x27c>
  8029ec:	83 ec 04             	sub    $0x4,%esp
  8029ef:	68 1c 45 80 00       	push   $0x80451c
  8029f4:	68 45 01 00 00       	push   $0x145
  8029f9:	68 01 45 80 00       	push   $0x804501
  8029fe:	e8 95 d9 ff ff       	call   800398 <_panic>
  802a03:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0c:	89 10                	mov    %edx,(%eax)
  802a0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a11:	8b 00                	mov    (%eax),%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	74 0d                	je     802a24 <alloc_block_BF+0x29d>
  802a17:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a1c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a1f:	89 50 04             	mov    %edx,0x4(%eax)
  802a22:	eb 08                	jmp    802a2c <alloc_block_BF+0x2a5>
  802a24:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a27:	a3 30 50 80 00       	mov    %eax,0x805030
  802a2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3e:	a1 38 50 80 00       	mov    0x805038,%eax
  802a43:	40                   	inc    %eax
  802a44:	a3 38 50 80 00       	mov    %eax,0x805038
  802a49:	e9 dc 00 00 00       	jmp    802b2a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	8b 00                	mov    (%eax),%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	75 65                	jne    802abc <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a57:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a5b:	75 17                	jne    802a74 <alloc_block_BF+0x2ed>
  802a5d:	83 ec 04             	sub    $0x4,%esp
  802a60:	68 50 45 80 00       	push   $0x804550
  802a65:	68 4a 01 00 00       	push   $0x14a
  802a6a:	68 01 45 80 00       	push   $0x804501
  802a6f:	e8 24 d9 ff ff       	call   800398 <_panic>
  802a74:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7d:	89 50 04             	mov    %edx,0x4(%eax)
  802a80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a83:	8b 40 04             	mov    0x4(%eax),%eax
  802a86:	85 c0                	test   %eax,%eax
  802a88:	74 0c                	je     802a96 <alloc_block_BF+0x30f>
  802a8a:	a1 30 50 80 00       	mov    0x805030,%eax
  802a8f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a92:	89 10                	mov    %edx,(%eax)
  802a94:	eb 08                	jmp    802a9e <alloc_block_BF+0x317>
  802a96:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a99:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa1:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aaf:	a1 38 50 80 00       	mov    0x805038,%eax
  802ab4:	40                   	inc    %eax
  802ab5:	a3 38 50 80 00       	mov    %eax,0x805038
  802aba:	eb 6e                	jmp    802b2a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802abc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac0:	74 06                	je     802ac8 <alloc_block_BF+0x341>
  802ac2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ac6:	75 17                	jne    802adf <alloc_block_BF+0x358>
  802ac8:	83 ec 04             	sub    $0x4,%esp
  802acb:	68 74 45 80 00       	push   $0x804574
  802ad0:	68 4f 01 00 00       	push   $0x14f
  802ad5:	68 01 45 80 00       	push   $0x804501
  802ada:	e8 b9 d8 ff ff       	call   800398 <_panic>
  802adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae2:	8b 10                	mov    (%eax),%edx
  802ae4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae7:	89 10                	mov    %edx,(%eax)
  802ae9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	85 c0                	test   %eax,%eax
  802af0:	74 0b                	je     802afd <alloc_block_BF+0x376>
  802af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af5:	8b 00                	mov    (%eax),%eax
  802af7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802afa:	89 50 04             	mov    %edx,0x4(%eax)
  802afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b00:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b03:	89 10                	mov    %edx,(%eax)
  802b05:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0b:	89 50 04             	mov    %edx,0x4(%eax)
  802b0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	75 08                	jne    802b1f <alloc_block_BF+0x398>
  802b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1a:	a3 30 50 80 00       	mov    %eax,0x805030
  802b1f:	a1 38 50 80 00       	mov    0x805038,%eax
  802b24:	40                   	inc    %eax
  802b25:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b2e:	75 17                	jne    802b47 <alloc_block_BF+0x3c0>
  802b30:	83 ec 04             	sub    $0x4,%esp
  802b33:	68 e3 44 80 00       	push   $0x8044e3
  802b38:	68 51 01 00 00       	push   $0x151
  802b3d:	68 01 45 80 00       	push   $0x804501
  802b42:	e8 51 d8 ff ff       	call   800398 <_panic>
  802b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	74 10                	je     802b60 <alloc_block_BF+0x3d9>
  802b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b58:	8b 52 04             	mov    0x4(%edx),%edx
  802b5b:	89 50 04             	mov    %edx,0x4(%eax)
  802b5e:	eb 0b                	jmp    802b6b <alloc_block_BF+0x3e4>
  802b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b63:	8b 40 04             	mov    0x4(%eax),%eax
  802b66:	a3 30 50 80 00       	mov    %eax,0x805030
  802b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6e:	8b 40 04             	mov    0x4(%eax),%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	74 0f                	je     802b84 <alloc_block_BF+0x3fd>
  802b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b78:	8b 40 04             	mov    0x4(%eax),%eax
  802b7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7e:	8b 12                	mov    (%edx),%edx
  802b80:	89 10                	mov    %edx,(%eax)
  802b82:	eb 0a                	jmp    802b8e <alloc_block_BF+0x407>
  802b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b87:	8b 00                	mov    (%eax),%eax
  802b89:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ba6:	48                   	dec    %eax
  802ba7:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bac:	83 ec 04             	sub    $0x4,%esp
  802baf:	6a 00                	push   $0x0
  802bb1:	ff 75 d0             	pushl  -0x30(%ebp)
  802bb4:	ff 75 cc             	pushl  -0x34(%ebp)
  802bb7:	e8 e0 f6 ff ff       	call   80229c <set_block_data>
  802bbc:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc2:	e9 80 01 00 00       	jmp    802d47 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802bc7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bcb:	0f 85 9d 00 00 00    	jne    802c6e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bd1:	83 ec 04             	sub    $0x4,%esp
  802bd4:	6a 01                	push   $0x1
  802bd6:	ff 75 ec             	pushl  -0x14(%ebp)
  802bd9:	ff 75 f0             	pushl  -0x10(%ebp)
  802bdc:	e8 bb f6 ff ff       	call   80229c <set_block_data>
  802be1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802be4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be8:	75 17                	jne    802c01 <alloc_block_BF+0x47a>
  802bea:	83 ec 04             	sub    $0x4,%esp
  802bed:	68 e3 44 80 00       	push   $0x8044e3
  802bf2:	68 58 01 00 00       	push   $0x158
  802bf7:	68 01 45 80 00       	push   $0x804501
  802bfc:	e8 97 d7 ff ff       	call   800398 <_panic>
  802c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	85 c0                	test   %eax,%eax
  802c08:	74 10                	je     802c1a <alloc_block_BF+0x493>
  802c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c12:	8b 52 04             	mov    0x4(%edx),%edx
  802c15:	89 50 04             	mov    %edx,0x4(%eax)
  802c18:	eb 0b                	jmp    802c25 <alloc_block_BF+0x49e>
  802c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1d:	8b 40 04             	mov    0x4(%eax),%eax
  802c20:	a3 30 50 80 00       	mov    %eax,0x805030
  802c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c28:	8b 40 04             	mov    0x4(%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	74 0f                	je     802c3e <alloc_block_BF+0x4b7>
  802c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c32:	8b 40 04             	mov    0x4(%eax),%eax
  802c35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c38:	8b 12                	mov    (%edx),%edx
  802c3a:	89 10                	mov    %edx,(%eax)
  802c3c:	eb 0a                	jmp    802c48 <alloc_block_BF+0x4c1>
  802c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5b:	a1 38 50 80 00       	mov    0x805038,%eax
  802c60:	48                   	dec    %eax
  802c61:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c69:	e9 d9 00 00 00       	jmp    802d47 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	83 c0 08             	add    $0x8,%eax
  802c74:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c77:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c7e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c84:	01 d0                	add    %edx,%eax
  802c86:	48                   	dec    %eax
  802c87:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c8a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  802c92:	f7 75 c4             	divl   -0x3c(%ebp)
  802c95:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c98:	29 d0                	sub    %edx,%eax
  802c9a:	c1 e8 0c             	shr    $0xc,%eax
  802c9d:	83 ec 0c             	sub    $0xc,%esp
  802ca0:	50                   	push   %eax
  802ca1:	e8 49 e7 ff ff       	call   8013ef <sbrk>
  802ca6:	83 c4 10             	add    $0x10,%esp
  802ca9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cac:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cb0:	75 0a                	jne    802cbc <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb7:	e9 8b 00 00 00       	jmp    802d47 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cbc:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cc3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cc6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cc9:	01 d0                	add    %edx,%eax
  802ccb:	48                   	dec    %eax
  802ccc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ccf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd7:	f7 75 b8             	divl   -0x48(%ebp)
  802cda:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cdd:	29 d0                	sub    %edx,%eax
  802cdf:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ce2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ce5:	01 d0                	add    %edx,%eax
  802ce7:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cec:	a1 40 50 80 00       	mov    0x805040,%eax
  802cf1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cf7:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cfe:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d01:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d04:	01 d0                	add    %edx,%eax
  802d06:	48                   	dec    %eax
  802d07:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d0a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d0d:	ba 00 00 00 00       	mov    $0x0,%edx
  802d12:	f7 75 b0             	divl   -0x50(%ebp)
  802d15:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d18:	29 d0                	sub    %edx,%eax
  802d1a:	83 ec 04             	sub    $0x4,%esp
  802d1d:	6a 01                	push   $0x1
  802d1f:	50                   	push   %eax
  802d20:	ff 75 bc             	pushl  -0x44(%ebp)
  802d23:	e8 74 f5 ff ff       	call   80229c <set_block_data>
  802d28:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d2b:	83 ec 0c             	sub    $0xc,%esp
  802d2e:	ff 75 bc             	pushl  -0x44(%ebp)
  802d31:	e8 36 04 00 00       	call   80316c <free_block>
  802d36:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d39:	83 ec 0c             	sub    $0xc,%esp
  802d3c:	ff 75 08             	pushl  0x8(%ebp)
  802d3f:	e8 43 fa ff ff       	call   802787 <alloc_block_BF>
  802d44:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d47:	c9                   	leave  
  802d48:	c3                   	ret    

00802d49 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d49:	55                   	push   %ebp
  802d4a:	89 e5                	mov    %esp,%ebp
  802d4c:	53                   	push   %ebx
  802d4d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d62:	74 1e                	je     802d82 <merging+0x39>
  802d64:	ff 75 08             	pushl  0x8(%ebp)
  802d67:	e8 df f1 ff ff       	call   801f4b <get_block_size>
  802d6c:	83 c4 04             	add    $0x4,%esp
  802d6f:	89 c2                	mov    %eax,%edx
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	01 d0                	add    %edx,%eax
  802d76:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d79:	75 07                	jne    802d82 <merging+0x39>
		prev_is_free = 1;
  802d7b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d86:	74 1e                	je     802da6 <merging+0x5d>
  802d88:	ff 75 10             	pushl  0x10(%ebp)
  802d8b:	e8 bb f1 ff ff       	call   801f4b <get_block_size>
  802d90:	83 c4 04             	add    $0x4,%esp
  802d93:	89 c2                	mov    %eax,%edx
  802d95:	8b 45 10             	mov    0x10(%ebp),%eax
  802d98:	01 d0                	add    %edx,%eax
  802d9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d9d:	75 07                	jne    802da6 <merging+0x5d>
		next_is_free = 1;
  802d9f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802da6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802daa:	0f 84 cc 00 00 00    	je     802e7c <merging+0x133>
  802db0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db4:	0f 84 c2 00 00 00    	je     802e7c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dba:	ff 75 08             	pushl  0x8(%ebp)
  802dbd:	e8 89 f1 ff ff       	call   801f4b <get_block_size>
  802dc2:	83 c4 04             	add    $0x4,%esp
  802dc5:	89 c3                	mov    %eax,%ebx
  802dc7:	ff 75 10             	pushl  0x10(%ebp)
  802dca:	e8 7c f1 ff ff       	call   801f4b <get_block_size>
  802dcf:	83 c4 04             	add    $0x4,%esp
  802dd2:	01 c3                	add    %eax,%ebx
  802dd4:	ff 75 0c             	pushl  0xc(%ebp)
  802dd7:	e8 6f f1 ff ff       	call   801f4b <get_block_size>
  802ddc:	83 c4 04             	add    $0x4,%esp
  802ddf:	01 d8                	add    %ebx,%eax
  802de1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802de4:	6a 00                	push   $0x0
  802de6:	ff 75 ec             	pushl  -0x14(%ebp)
  802de9:	ff 75 08             	pushl  0x8(%ebp)
  802dec:	e8 ab f4 ff ff       	call   80229c <set_block_data>
  802df1:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802df4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802df8:	75 17                	jne    802e11 <merging+0xc8>
  802dfa:	83 ec 04             	sub    $0x4,%esp
  802dfd:	68 e3 44 80 00       	push   $0x8044e3
  802e02:	68 7d 01 00 00       	push   $0x17d
  802e07:	68 01 45 80 00       	push   $0x804501
  802e0c:	e8 87 d5 ff ff       	call   800398 <_panic>
  802e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 10                	je     802e2a <merging+0xe1>
  802e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e22:	8b 52 04             	mov    0x4(%edx),%edx
  802e25:	89 50 04             	mov    %edx,0x4(%eax)
  802e28:	eb 0b                	jmp    802e35 <merging+0xec>
  802e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2d:	8b 40 04             	mov    0x4(%eax),%eax
  802e30:	a3 30 50 80 00       	mov    %eax,0x805030
  802e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	74 0f                	je     802e4e <merging+0x105>
  802e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e48:	8b 12                	mov    (%edx),%edx
  802e4a:	89 10                	mov    %edx,(%eax)
  802e4c:	eb 0a                	jmp    802e58 <merging+0x10f>
  802e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6b:	a1 38 50 80 00       	mov    0x805038,%eax
  802e70:	48                   	dec    %eax
  802e71:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e76:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e77:	e9 ea 02 00 00       	jmp    803166 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e80:	74 3b                	je     802ebd <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e82:	83 ec 0c             	sub    $0xc,%esp
  802e85:	ff 75 08             	pushl  0x8(%ebp)
  802e88:	e8 be f0 ff ff       	call   801f4b <get_block_size>
  802e8d:	83 c4 10             	add    $0x10,%esp
  802e90:	89 c3                	mov    %eax,%ebx
  802e92:	83 ec 0c             	sub    $0xc,%esp
  802e95:	ff 75 10             	pushl  0x10(%ebp)
  802e98:	e8 ae f0 ff ff       	call   801f4b <get_block_size>
  802e9d:	83 c4 10             	add    $0x10,%esp
  802ea0:	01 d8                	add    %ebx,%eax
  802ea2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	6a 00                	push   $0x0
  802eaa:	ff 75 e8             	pushl  -0x18(%ebp)
  802ead:	ff 75 08             	pushl  0x8(%ebp)
  802eb0:	e8 e7 f3 ff ff       	call   80229c <set_block_data>
  802eb5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eb8:	e9 a9 02 00 00       	jmp    803166 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ebd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec1:	0f 84 2d 01 00 00    	je     802ff4 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ec7:	83 ec 0c             	sub    $0xc,%esp
  802eca:	ff 75 10             	pushl  0x10(%ebp)
  802ecd:	e8 79 f0 ff ff       	call   801f4b <get_block_size>
  802ed2:	83 c4 10             	add    $0x10,%esp
  802ed5:	89 c3                	mov    %eax,%ebx
  802ed7:	83 ec 0c             	sub    $0xc,%esp
  802eda:	ff 75 0c             	pushl  0xc(%ebp)
  802edd:	e8 69 f0 ff ff       	call   801f4b <get_block_size>
  802ee2:	83 c4 10             	add    $0x10,%esp
  802ee5:	01 d8                	add    %ebx,%eax
  802ee7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802eea:	83 ec 04             	sub    $0x4,%esp
  802eed:	6a 00                	push   $0x0
  802eef:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ef2:	ff 75 10             	pushl  0x10(%ebp)
  802ef5:	e8 a2 f3 ff ff       	call   80229c <set_block_data>
  802efa:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802efd:	8b 45 10             	mov    0x10(%ebp),%eax
  802f00:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f07:	74 06                	je     802f0f <merging+0x1c6>
  802f09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f0d:	75 17                	jne    802f26 <merging+0x1dd>
  802f0f:	83 ec 04             	sub    $0x4,%esp
  802f12:	68 a8 45 80 00       	push   $0x8045a8
  802f17:	68 8d 01 00 00       	push   $0x18d
  802f1c:	68 01 45 80 00       	push   $0x804501
  802f21:	e8 72 d4 ff ff       	call   800398 <_panic>
  802f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f29:	8b 50 04             	mov    0x4(%eax),%edx
  802f2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2f:	89 50 04             	mov    %edx,0x4(%eax)
  802f32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f38:	89 10                	mov    %edx,(%eax)
  802f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3d:	8b 40 04             	mov    0x4(%eax),%eax
  802f40:	85 c0                	test   %eax,%eax
  802f42:	74 0d                	je     802f51 <merging+0x208>
  802f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f47:	8b 40 04             	mov    0x4(%eax),%eax
  802f4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f4d:	89 10                	mov    %edx,(%eax)
  802f4f:	eb 08                	jmp    802f59 <merging+0x210>
  802f51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f54:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f5f:	89 50 04             	mov    %edx,0x4(%eax)
  802f62:	a1 38 50 80 00       	mov    0x805038,%eax
  802f67:	40                   	inc    %eax
  802f68:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f71:	75 17                	jne    802f8a <merging+0x241>
  802f73:	83 ec 04             	sub    $0x4,%esp
  802f76:	68 e3 44 80 00       	push   $0x8044e3
  802f7b:	68 8e 01 00 00       	push   $0x18e
  802f80:	68 01 45 80 00       	push   $0x804501
  802f85:	e8 0e d4 ff ff       	call   800398 <_panic>
  802f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	85 c0                	test   %eax,%eax
  802f91:	74 10                	je     802fa3 <merging+0x25a>
  802f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f96:	8b 00                	mov    (%eax),%eax
  802f98:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f9b:	8b 52 04             	mov    0x4(%edx),%edx
  802f9e:	89 50 04             	mov    %edx,0x4(%eax)
  802fa1:	eb 0b                	jmp    802fae <merging+0x265>
  802fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa6:	8b 40 04             	mov    0x4(%eax),%eax
  802fa9:	a3 30 50 80 00       	mov    %eax,0x805030
  802fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb1:	8b 40 04             	mov    0x4(%eax),%eax
  802fb4:	85 c0                	test   %eax,%eax
  802fb6:	74 0f                	je     802fc7 <merging+0x27e>
  802fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbb:	8b 40 04             	mov    0x4(%eax),%eax
  802fbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc1:	8b 12                	mov    (%edx),%edx
  802fc3:	89 10                	mov    %edx,(%eax)
  802fc5:	eb 0a                	jmp    802fd1 <merging+0x288>
  802fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fca:	8b 00                	mov    (%eax),%eax
  802fcc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe4:	a1 38 50 80 00       	mov    0x805038,%eax
  802fe9:	48                   	dec    %eax
  802fea:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fef:	e9 72 01 00 00       	jmp    803166 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  802ff7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ffa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ffe:	74 79                	je     803079 <merging+0x330>
  803000:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803004:	74 73                	je     803079 <merging+0x330>
  803006:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300a:	74 06                	je     803012 <merging+0x2c9>
  80300c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803010:	75 17                	jne    803029 <merging+0x2e0>
  803012:	83 ec 04             	sub    $0x4,%esp
  803015:	68 74 45 80 00       	push   $0x804574
  80301a:	68 94 01 00 00       	push   $0x194
  80301f:	68 01 45 80 00       	push   $0x804501
  803024:	e8 6f d3 ff ff       	call   800398 <_panic>
  803029:	8b 45 08             	mov    0x8(%ebp),%eax
  80302c:	8b 10                	mov    (%eax),%edx
  80302e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803031:	89 10                	mov    %edx,(%eax)
  803033:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	85 c0                	test   %eax,%eax
  80303a:	74 0b                	je     803047 <merging+0x2fe>
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	8b 00                	mov    (%eax),%eax
  803041:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803044:	89 50 04             	mov    %edx,0x4(%eax)
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80304d:	89 10                	mov    %edx,(%eax)
  80304f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803052:	8b 55 08             	mov    0x8(%ebp),%edx
  803055:	89 50 04             	mov    %edx,0x4(%eax)
  803058:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	85 c0                	test   %eax,%eax
  80305f:	75 08                	jne    803069 <merging+0x320>
  803061:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803064:	a3 30 50 80 00       	mov    %eax,0x805030
  803069:	a1 38 50 80 00       	mov    0x805038,%eax
  80306e:	40                   	inc    %eax
  80306f:	a3 38 50 80 00       	mov    %eax,0x805038
  803074:	e9 ce 00 00 00       	jmp    803147 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803079:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307d:	74 65                	je     8030e4 <merging+0x39b>
  80307f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803083:	75 17                	jne    80309c <merging+0x353>
  803085:	83 ec 04             	sub    $0x4,%esp
  803088:	68 50 45 80 00       	push   $0x804550
  80308d:	68 95 01 00 00       	push   $0x195
  803092:	68 01 45 80 00       	push   $0x804501
  803097:	e8 fc d2 ff ff       	call   800398 <_panic>
  80309c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a5:	89 50 04             	mov    %edx,0x4(%eax)
  8030a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ab:	8b 40 04             	mov    0x4(%eax),%eax
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	74 0c                	je     8030be <merging+0x375>
  8030b2:	a1 30 50 80 00       	mov    0x805030,%eax
  8030b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ba:	89 10                	mov    %edx,(%eax)
  8030bc:	eb 08                	jmp    8030c6 <merging+0x37d>
  8030be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8030dc:	40                   	inc    %eax
  8030dd:	a3 38 50 80 00       	mov    %eax,0x805038
  8030e2:	eb 63                	jmp    803147 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030e8:	75 17                	jne    803101 <merging+0x3b8>
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	68 1c 45 80 00       	push   $0x80451c
  8030f2:	68 98 01 00 00       	push   $0x198
  8030f7:	68 01 45 80 00       	push   $0x804501
  8030fc:	e8 97 d2 ff ff       	call   800398 <_panic>
  803101:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803107:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310a:	89 10                	mov    %edx,(%eax)
  80310c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310f:	8b 00                	mov    (%eax),%eax
  803111:	85 c0                	test   %eax,%eax
  803113:	74 0d                	je     803122 <merging+0x3d9>
  803115:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80311a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80311d:	89 50 04             	mov    %edx,0x4(%eax)
  803120:	eb 08                	jmp    80312a <merging+0x3e1>
  803122:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803125:	a3 30 50 80 00       	mov    %eax,0x805030
  80312a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803132:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803135:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313c:	a1 38 50 80 00       	mov    0x805038,%eax
  803141:	40                   	inc    %eax
  803142:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803147:	83 ec 0c             	sub    $0xc,%esp
  80314a:	ff 75 10             	pushl  0x10(%ebp)
  80314d:	e8 f9 ed ff ff       	call   801f4b <get_block_size>
  803152:	83 c4 10             	add    $0x10,%esp
  803155:	83 ec 04             	sub    $0x4,%esp
  803158:	6a 00                	push   $0x0
  80315a:	50                   	push   %eax
  80315b:	ff 75 10             	pushl  0x10(%ebp)
  80315e:	e8 39 f1 ff ff       	call   80229c <set_block_data>
  803163:	83 c4 10             	add    $0x10,%esp
	}
}
  803166:	90                   	nop
  803167:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80316a:	c9                   	leave  
  80316b:	c3                   	ret    

0080316c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80316c:	55                   	push   %ebp
  80316d:	89 e5                	mov    %esp,%ebp
  80316f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803172:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803177:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80317a:	a1 30 50 80 00       	mov    0x805030,%eax
  80317f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803182:	73 1b                	jae    80319f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803184:	a1 30 50 80 00       	mov    0x805030,%eax
  803189:	83 ec 04             	sub    $0x4,%esp
  80318c:	ff 75 08             	pushl  0x8(%ebp)
  80318f:	6a 00                	push   $0x0
  803191:	50                   	push   %eax
  803192:	e8 b2 fb ff ff       	call   802d49 <merging>
  803197:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80319a:	e9 8b 00 00 00       	jmp    80322a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80319f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a7:	76 18                	jbe    8031c1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031ae:	83 ec 04             	sub    $0x4,%esp
  8031b1:	ff 75 08             	pushl  0x8(%ebp)
  8031b4:	50                   	push   %eax
  8031b5:	6a 00                	push   $0x0
  8031b7:	e8 8d fb ff ff       	call   802d49 <merging>
  8031bc:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031bf:	eb 69                	jmp    80322a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c9:	eb 39                	jmp    803204 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d1:	73 29                	jae    8031fc <free_block+0x90>
  8031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d6:	8b 00                	mov    (%eax),%eax
  8031d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031db:	76 1f                	jbe    8031fc <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031e5:	83 ec 04             	sub    $0x4,%esp
  8031e8:	ff 75 08             	pushl  0x8(%ebp)
  8031eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8031f1:	e8 53 fb ff ff       	call   802d49 <merging>
  8031f6:	83 c4 10             	add    $0x10,%esp
			break;
  8031f9:	90                   	nop
		}
	}
}
  8031fa:	eb 2e                	jmp    80322a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031fc:	a1 34 50 80 00       	mov    0x805034,%eax
  803201:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803208:	74 07                	je     803211 <free_block+0xa5>
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	8b 00                	mov    (%eax),%eax
  80320f:	eb 05                	jmp    803216 <free_block+0xaa>
  803211:	b8 00 00 00 00       	mov    $0x0,%eax
  803216:	a3 34 50 80 00       	mov    %eax,0x805034
  80321b:	a1 34 50 80 00       	mov    0x805034,%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	75 a7                	jne    8031cb <free_block+0x5f>
  803224:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803228:	75 a1                	jne    8031cb <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80322a:	90                   	nop
  80322b:	c9                   	leave  
  80322c:	c3                   	ret    

0080322d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80322d:	55                   	push   %ebp
  80322e:	89 e5                	mov    %esp,%ebp
  803230:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803233:	ff 75 08             	pushl  0x8(%ebp)
  803236:	e8 10 ed ff ff       	call   801f4b <get_block_size>
  80323b:	83 c4 04             	add    $0x4,%esp
  80323e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803241:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803248:	eb 17                	jmp    803261 <copy_data+0x34>
  80324a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80324d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803250:	01 c2                	add    %eax,%edx
  803252:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	01 c8                	add    %ecx,%eax
  80325a:	8a 00                	mov    (%eax),%al
  80325c:	88 02                	mov    %al,(%edx)
  80325e:	ff 45 fc             	incl   -0x4(%ebp)
  803261:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803264:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803267:	72 e1                	jb     80324a <copy_data+0x1d>
}
  803269:	90                   	nop
  80326a:	c9                   	leave  
  80326b:	c3                   	ret    

0080326c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80326c:	55                   	push   %ebp
  80326d:	89 e5                	mov    %esp,%ebp
  80326f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803272:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803276:	75 23                	jne    80329b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803278:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80327c:	74 13                	je     803291 <realloc_block_FF+0x25>
  80327e:	83 ec 0c             	sub    $0xc,%esp
  803281:	ff 75 0c             	pushl  0xc(%ebp)
  803284:	e8 42 f0 ff ff       	call   8022cb <alloc_block_FF>
  803289:	83 c4 10             	add    $0x10,%esp
  80328c:	e9 e4 06 00 00       	jmp    803975 <realloc_block_FF+0x709>
		return NULL;
  803291:	b8 00 00 00 00       	mov    $0x0,%eax
  803296:	e9 da 06 00 00       	jmp    803975 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  80329b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80329f:	75 18                	jne    8032b9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032a1:	83 ec 0c             	sub    $0xc,%esp
  8032a4:	ff 75 08             	pushl  0x8(%ebp)
  8032a7:	e8 c0 fe ff ff       	call   80316c <free_block>
  8032ac:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032af:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b4:	e9 bc 06 00 00       	jmp    803975 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8032b9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032bd:	77 07                	ja     8032c6 <realloc_block_FF+0x5a>
  8032bf:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c9:	83 e0 01             	and    $0x1,%eax
  8032cc:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d2:	83 c0 08             	add    $0x8,%eax
  8032d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032d8:	83 ec 0c             	sub    $0xc,%esp
  8032db:	ff 75 08             	pushl  0x8(%ebp)
  8032de:	e8 68 ec ff ff       	call   801f4b <get_block_size>
  8032e3:	83 c4 10             	add    $0x10,%esp
  8032e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ec:	83 e8 08             	sub    $0x8,%eax
  8032ef:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	83 e8 04             	sub    $0x4,%eax
  8032f8:	8b 00                	mov    (%eax),%eax
  8032fa:	83 e0 fe             	and    $0xfffffffe,%eax
  8032fd:	89 c2                	mov    %eax,%edx
  8032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803302:	01 d0                	add    %edx,%eax
  803304:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803307:	83 ec 0c             	sub    $0xc,%esp
  80330a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80330d:	e8 39 ec ff ff       	call   801f4b <get_block_size>
  803312:	83 c4 10             	add    $0x10,%esp
  803315:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803318:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80331b:	83 e8 08             	sub    $0x8,%eax
  80331e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803321:	8b 45 0c             	mov    0xc(%ebp),%eax
  803324:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803327:	75 08                	jne    803331 <realloc_block_FF+0xc5>
	{
		 return va;
  803329:	8b 45 08             	mov    0x8(%ebp),%eax
  80332c:	e9 44 06 00 00       	jmp    803975 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803331:	8b 45 0c             	mov    0xc(%ebp),%eax
  803334:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803337:	0f 83 d5 03 00 00    	jae    803712 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80333d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803340:	2b 45 0c             	sub    0xc(%ebp),%eax
  803343:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803346:	83 ec 0c             	sub    $0xc,%esp
  803349:	ff 75 e4             	pushl  -0x1c(%ebp)
  80334c:	e8 13 ec ff ff       	call   801f64 <is_free_block>
  803351:	83 c4 10             	add    $0x10,%esp
  803354:	84 c0                	test   %al,%al
  803356:	0f 84 3b 01 00 00    	je     803497 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80335c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80335f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803362:	01 d0                	add    %edx,%eax
  803364:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803367:	83 ec 04             	sub    $0x4,%esp
  80336a:	6a 01                	push   $0x1
  80336c:	ff 75 f0             	pushl  -0x10(%ebp)
  80336f:	ff 75 08             	pushl  0x8(%ebp)
  803372:	e8 25 ef ff ff       	call   80229c <set_block_data>
  803377:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	83 e8 04             	sub    $0x4,%eax
  803380:	8b 00                	mov    (%eax),%eax
  803382:	83 e0 fe             	and    $0xfffffffe,%eax
  803385:	89 c2                	mov    %eax,%edx
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	01 d0                	add    %edx,%eax
  80338c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80338f:	83 ec 04             	sub    $0x4,%esp
  803392:	6a 00                	push   $0x0
  803394:	ff 75 cc             	pushl  -0x34(%ebp)
  803397:	ff 75 c8             	pushl  -0x38(%ebp)
  80339a:	e8 fd ee ff ff       	call   80229c <set_block_data>
  80339f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033a6:	74 06                	je     8033ae <realloc_block_FF+0x142>
  8033a8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033ac:	75 17                	jne    8033c5 <realloc_block_FF+0x159>
  8033ae:	83 ec 04             	sub    $0x4,%esp
  8033b1:	68 74 45 80 00       	push   $0x804574
  8033b6:	68 f6 01 00 00       	push   $0x1f6
  8033bb:	68 01 45 80 00       	push   $0x804501
  8033c0:	e8 d3 cf ff ff       	call   800398 <_panic>
  8033c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c8:	8b 10                	mov    (%eax),%edx
  8033ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033cd:	89 10                	mov    %edx,(%eax)
  8033cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	74 0b                	je     8033e3 <realloc_block_FF+0x177>
  8033d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033db:	8b 00                	mov    (%eax),%eax
  8033dd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033e0:	89 50 04             	mov    %edx,0x4(%eax)
  8033e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033e9:	89 10                	mov    %edx,(%eax)
  8033eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033f1:	89 50 04             	mov    %edx,0x4(%eax)
  8033f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	75 08                	jne    803405 <realloc_block_FF+0x199>
  8033fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803400:	a3 30 50 80 00       	mov    %eax,0x805030
  803405:	a1 38 50 80 00       	mov    0x805038,%eax
  80340a:	40                   	inc    %eax
  80340b:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803410:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803414:	75 17                	jne    80342d <realloc_block_FF+0x1c1>
  803416:	83 ec 04             	sub    $0x4,%esp
  803419:	68 e3 44 80 00       	push   $0x8044e3
  80341e:	68 f7 01 00 00       	push   $0x1f7
  803423:	68 01 45 80 00       	push   $0x804501
  803428:	e8 6b cf ff ff       	call   800398 <_panic>
  80342d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803430:	8b 00                	mov    (%eax),%eax
  803432:	85 c0                	test   %eax,%eax
  803434:	74 10                	je     803446 <realloc_block_FF+0x1da>
  803436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80343e:	8b 52 04             	mov    0x4(%edx),%edx
  803441:	89 50 04             	mov    %edx,0x4(%eax)
  803444:	eb 0b                	jmp    803451 <realloc_block_FF+0x1e5>
  803446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803449:	8b 40 04             	mov    0x4(%eax),%eax
  80344c:	a3 30 50 80 00       	mov    %eax,0x805030
  803451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803454:	8b 40 04             	mov    0x4(%eax),%eax
  803457:	85 c0                	test   %eax,%eax
  803459:	74 0f                	je     80346a <realloc_block_FF+0x1fe>
  80345b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345e:	8b 40 04             	mov    0x4(%eax),%eax
  803461:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803464:	8b 12                	mov    (%edx),%edx
  803466:	89 10                	mov    %edx,(%eax)
  803468:	eb 0a                	jmp    803474 <realloc_block_FF+0x208>
  80346a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346d:	8b 00                	mov    (%eax),%eax
  80346f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803477:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803480:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803487:	a1 38 50 80 00       	mov    0x805038,%eax
  80348c:	48                   	dec    %eax
  80348d:	a3 38 50 80 00       	mov    %eax,0x805038
  803492:	e9 73 02 00 00       	jmp    80370a <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803497:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80349b:	0f 86 69 02 00 00    	jbe    80370a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034a1:	83 ec 04             	sub    $0x4,%esp
  8034a4:	6a 01                	push   $0x1
  8034a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8034a9:	ff 75 08             	pushl  0x8(%ebp)
  8034ac:	e8 eb ed ff ff       	call   80229c <set_block_data>
  8034b1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b7:	83 e8 04             	sub    $0x4,%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	83 e0 fe             	and    $0xfffffffe,%eax
  8034bf:	89 c2                	mov    %eax,%edx
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	01 d0                	add    %edx,%eax
  8034c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034d1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034d5:	75 68                	jne    80353f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034d7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034db:	75 17                	jne    8034f4 <realloc_block_FF+0x288>
  8034dd:	83 ec 04             	sub    $0x4,%esp
  8034e0:	68 1c 45 80 00       	push   $0x80451c
  8034e5:	68 06 02 00 00       	push   $0x206
  8034ea:	68 01 45 80 00       	push   $0x804501
  8034ef:	e8 a4 ce ff ff       	call   800398 <_panic>
  8034f4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fd:	89 10                	mov    %edx,(%eax)
  8034ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803502:	8b 00                	mov    (%eax),%eax
  803504:	85 c0                	test   %eax,%eax
  803506:	74 0d                	je     803515 <realloc_block_FF+0x2a9>
  803508:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80350d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803510:	89 50 04             	mov    %edx,0x4(%eax)
  803513:	eb 08                	jmp    80351d <realloc_block_FF+0x2b1>
  803515:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803518:	a3 30 50 80 00       	mov    %eax,0x805030
  80351d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803520:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803525:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803528:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352f:	a1 38 50 80 00       	mov    0x805038,%eax
  803534:	40                   	inc    %eax
  803535:	a3 38 50 80 00       	mov    %eax,0x805038
  80353a:	e9 b0 01 00 00       	jmp    8036ef <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80353f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803544:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803547:	76 68                	jbe    8035b1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803549:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80354d:	75 17                	jne    803566 <realloc_block_FF+0x2fa>
  80354f:	83 ec 04             	sub    $0x4,%esp
  803552:	68 1c 45 80 00       	push   $0x80451c
  803557:	68 0b 02 00 00       	push   $0x20b
  80355c:	68 01 45 80 00       	push   $0x804501
  803561:	e8 32 ce ff ff       	call   800398 <_panic>
  803566:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80356c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356f:	89 10                	mov    %edx,(%eax)
  803571:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803574:	8b 00                	mov    (%eax),%eax
  803576:	85 c0                	test   %eax,%eax
  803578:	74 0d                	je     803587 <realloc_block_FF+0x31b>
  80357a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80357f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803582:	89 50 04             	mov    %edx,0x4(%eax)
  803585:	eb 08                	jmp    80358f <realloc_block_FF+0x323>
  803587:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358a:	a3 30 50 80 00       	mov    %eax,0x805030
  80358f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803592:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803597:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8035a6:	40                   	inc    %eax
  8035a7:	a3 38 50 80 00       	mov    %eax,0x805038
  8035ac:	e9 3e 01 00 00       	jmp    8036ef <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035b6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035b9:	73 68                	jae    803623 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035bf:	75 17                	jne    8035d8 <realloc_block_FF+0x36c>
  8035c1:	83 ec 04             	sub    $0x4,%esp
  8035c4:	68 50 45 80 00       	push   $0x804550
  8035c9:	68 10 02 00 00       	push   $0x210
  8035ce:	68 01 45 80 00       	push   $0x804501
  8035d3:	e8 c0 cd ff ff       	call   800398 <_panic>
  8035d8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e1:	89 50 04             	mov    %edx,0x4(%eax)
  8035e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	74 0c                	je     8035fa <realloc_block_FF+0x38e>
  8035ee:	a1 30 50 80 00       	mov    0x805030,%eax
  8035f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035f6:	89 10                	mov    %edx,(%eax)
  8035f8:	eb 08                	jmp    803602 <realloc_block_FF+0x396>
  8035fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803602:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803605:	a3 30 50 80 00       	mov    %eax,0x805030
  80360a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803613:	a1 38 50 80 00       	mov    0x805038,%eax
  803618:	40                   	inc    %eax
  803619:	a3 38 50 80 00       	mov    %eax,0x805038
  80361e:	e9 cc 00 00 00       	jmp    8036ef <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803623:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80362a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80362f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803632:	e9 8a 00 00 00       	jmp    8036c1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80363d:	73 7a                	jae    8036b9 <realloc_block_FF+0x44d>
  80363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803642:	8b 00                	mov    (%eax),%eax
  803644:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803647:	73 70                	jae    8036b9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364d:	74 06                	je     803655 <realloc_block_FF+0x3e9>
  80364f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803653:	75 17                	jne    80366c <realloc_block_FF+0x400>
  803655:	83 ec 04             	sub    $0x4,%esp
  803658:	68 74 45 80 00       	push   $0x804574
  80365d:	68 1a 02 00 00       	push   $0x21a
  803662:	68 01 45 80 00       	push   $0x804501
  803667:	e8 2c cd ff ff       	call   800398 <_panic>
  80366c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366f:	8b 10                	mov    (%eax),%edx
  803671:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803674:	89 10                	mov    %edx,(%eax)
  803676:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803679:	8b 00                	mov    (%eax),%eax
  80367b:	85 c0                	test   %eax,%eax
  80367d:	74 0b                	je     80368a <realloc_block_FF+0x41e>
  80367f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803682:	8b 00                	mov    (%eax),%eax
  803684:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803687:	89 50 04             	mov    %edx,0x4(%eax)
  80368a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803690:	89 10                	mov    %edx,(%eax)
  803692:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803695:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803698:	89 50 04             	mov    %edx,0x4(%eax)
  80369b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369e:	8b 00                	mov    (%eax),%eax
  8036a0:	85 c0                	test   %eax,%eax
  8036a2:	75 08                	jne    8036ac <realloc_block_FF+0x440>
  8036a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a7:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b1:	40                   	inc    %eax
  8036b2:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036b7:	eb 36                	jmp    8036ef <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036b9:	a1 34 50 80 00       	mov    0x805034,%eax
  8036be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036c5:	74 07                	je     8036ce <realloc_block_FF+0x462>
  8036c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ca:	8b 00                	mov    (%eax),%eax
  8036cc:	eb 05                	jmp    8036d3 <realloc_block_FF+0x467>
  8036ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d3:	a3 34 50 80 00       	mov    %eax,0x805034
  8036d8:	a1 34 50 80 00       	mov    0x805034,%eax
  8036dd:	85 c0                	test   %eax,%eax
  8036df:	0f 85 52 ff ff ff    	jne    803637 <realloc_block_FF+0x3cb>
  8036e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e9:	0f 85 48 ff ff ff    	jne    803637 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036ef:	83 ec 04             	sub    $0x4,%esp
  8036f2:	6a 00                	push   $0x0
  8036f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8036f7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036fa:	e8 9d eb ff ff       	call   80229c <set_block_data>
  8036ff:	83 c4 10             	add    $0x10,%esp
				return va;
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	e9 6b 02 00 00       	jmp    803975 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  80370a:	8b 45 08             	mov    0x8(%ebp),%eax
  80370d:	e9 63 02 00 00       	jmp    803975 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803712:	8b 45 0c             	mov    0xc(%ebp),%eax
  803715:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803718:	0f 86 4d 02 00 00    	jbe    80396b <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  80371e:	83 ec 0c             	sub    $0xc,%esp
  803721:	ff 75 e4             	pushl  -0x1c(%ebp)
  803724:	e8 3b e8 ff ff       	call   801f64 <is_free_block>
  803729:	83 c4 10             	add    $0x10,%esp
  80372c:	84 c0                	test   %al,%al
  80372e:	0f 84 37 02 00 00    	je     80396b <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803734:	8b 45 0c             	mov    0xc(%ebp),%eax
  803737:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80373a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80373d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803740:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803743:	76 38                	jbe    80377d <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803745:	83 ec 0c             	sub    $0xc,%esp
  803748:	ff 75 0c             	pushl  0xc(%ebp)
  80374b:	e8 7b eb ff ff       	call   8022cb <alloc_block_FF>
  803750:	83 c4 10             	add    $0x10,%esp
  803753:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803756:	83 ec 08             	sub    $0x8,%esp
  803759:	ff 75 c0             	pushl  -0x40(%ebp)
  80375c:	ff 75 08             	pushl  0x8(%ebp)
  80375f:	e8 c9 fa ff ff       	call   80322d <copy_data>
  803764:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803767:	83 ec 0c             	sub    $0xc,%esp
  80376a:	ff 75 08             	pushl  0x8(%ebp)
  80376d:	e8 fa f9 ff ff       	call   80316c <free_block>
  803772:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803775:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803778:	e9 f8 01 00 00       	jmp    803975 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80377d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803780:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803783:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803786:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80378a:	0f 87 a0 00 00 00    	ja     803830 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803790:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803794:	75 17                	jne    8037ad <realloc_block_FF+0x541>
  803796:	83 ec 04             	sub    $0x4,%esp
  803799:	68 e3 44 80 00       	push   $0x8044e3
  80379e:	68 38 02 00 00       	push   $0x238
  8037a3:	68 01 45 80 00       	push   $0x804501
  8037a8:	e8 eb cb ff ff       	call   800398 <_panic>
  8037ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b0:	8b 00                	mov    (%eax),%eax
  8037b2:	85 c0                	test   %eax,%eax
  8037b4:	74 10                	je     8037c6 <realloc_block_FF+0x55a>
  8037b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b9:	8b 00                	mov    (%eax),%eax
  8037bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037be:	8b 52 04             	mov    0x4(%edx),%edx
  8037c1:	89 50 04             	mov    %edx,0x4(%eax)
  8037c4:	eb 0b                	jmp    8037d1 <realloc_block_FF+0x565>
  8037c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c9:	8b 40 04             	mov    0x4(%eax),%eax
  8037cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8037d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d4:	8b 40 04             	mov    0x4(%eax),%eax
  8037d7:	85 c0                	test   %eax,%eax
  8037d9:	74 0f                	je     8037ea <realloc_block_FF+0x57e>
  8037db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037de:	8b 40 04             	mov    0x4(%eax),%eax
  8037e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037e4:	8b 12                	mov    (%edx),%edx
  8037e6:	89 10                	mov    %edx,(%eax)
  8037e8:	eb 0a                	jmp    8037f4 <realloc_block_FF+0x588>
  8037ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ed:	8b 00                	mov    (%eax),%eax
  8037ef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803800:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803807:	a1 38 50 80 00       	mov    0x805038,%eax
  80380c:	48                   	dec    %eax
  80380d:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803812:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803815:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803818:	01 d0                	add    %edx,%eax
  80381a:	83 ec 04             	sub    $0x4,%esp
  80381d:	6a 01                	push   $0x1
  80381f:	50                   	push   %eax
  803820:	ff 75 08             	pushl  0x8(%ebp)
  803823:	e8 74 ea ff ff       	call   80229c <set_block_data>
  803828:	83 c4 10             	add    $0x10,%esp
  80382b:	e9 36 01 00 00       	jmp    803966 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803830:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803833:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803836:	01 d0                	add    %edx,%eax
  803838:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80383b:	83 ec 04             	sub    $0x4,%esp
  80383e:	6a 01                	push   $0x1
  803840:	ff 75 f0             	pushl  -0x10(%ebp)
  803843:	ff 75 08             	pushl  0x8(%ebp)
  803846:	e8 51 ea ff ff       	call   80229c <set_block_data>
  80384b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80384e:	8b 45 08             	mov    0x8(%ebp),%eax
  803851:	83 e8 04             	sub    $0x4,%eax
  803854:	8b 00                	mov    (%eax),%eax
  803856:	83 e0 fe             	and    $0xfffffffe,%eax
  803859:	89 c2                	mov    %eax,%edx
  80385b:	8b 45 08             	mov    0x8(%ebp),%eax
  80385e:	01 d0                	add    %edx,%eax
  803860:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803863:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803867:	74 06                	je     80386f <realloc_block_FF+0x603>
  803869:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80386d:	75 17                	jne    803886 <realloc_block_FF+0x61a>
  80386f:	83 ec 04             	sub    $0x4,%esp
  803872:	68 74 45 80 00       	push   $0x804574
  803877:	68 44 02 00 00       	push   $0x244
  80387c:	68 01 45 80 00       	push   $0x804501
  803881:	e8 12 cb ff ff       	call   800398 <_panic>
  803886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803889:	8b 10                	mov    (%eax),%edx
  80388b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80388e:	89 10                	mov    %edx,(%eax)
  803890:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803893:	8b 00                	mov    (%eax),%eax
  803895:	85 c0                	test   %eax,%eax
  803897:	74 0b                	je     8038a4 <realloc_block_FF+0x638>
  803899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389c:	8b 00                	mov    (%eax),%eax
  80389e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038a1:	89 50 04             	mov    %edx,0x4(%eax)
  8038a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038aa:	89 10                	mov    %edx,(%eax)
  8038ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b2:	89 50 04             	mov    %edx,0x4(%eax)
  8038b5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b8:	8b 00                	mov    (%eax),%eax
  8038ba:	85 c0                	test   %eax,%eax
  8038bc:	75 08                	jne    8038c6 <realloc_block_FF+0x65a>
  8038be:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038c1:	a3 30 50 80 00       	mov    %eax,0x805030
  8038c6:	a1 38 50 80 00       	mov    0x805038,%eax
  8038cb:	40                   	inc    %eax
  8038cc:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038d5:	75 17                	jne    8038ee <realloc_block_FF+0x682>
  8038d7:	83 ec 04             	sub    $0x4,%esp
  8038da:	68 e3 44 80 00       	push   $0x8044e3
  8038df:	68 45 02 00 00       	push   $0x245
  8038e4:	68 01 45 80 00       	push   $0x804501
  8038e9:	e8 aa ca ff ff       	call   800398 <_panic>
  8038ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f1:	8b 00                	mov    (%eax),%eax
  8038f3:	85 c0                	test   %eax,%eax
  8038f5:	74 10                	je     803907 <realloc_block_FF+0x69b>
  8038f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fa:	8b 00                	mov    (%eax),%eax
  8038fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ff:	8b 52 04             	mov    0x4(%edx),%edx
  803902:	89 50 04             	mov    %edx,0x4(%eax)
  803905:	eb 0b                	jmp    803912 <realloc_block_FF+0x6a6>
  803907:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390a:	8b 40 04             	mov    0x4(%eax),%eax
  80390d:	a3 30 50 80 00       	mov    %eax,0x805030
  803912:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803915:	8b 40 04             	mov    0x4(%eax),%eax
  803918:	85 c0                	test   %eax,%eax
  80391a:	74 0f                	je     80392b <realloc_block_FF+0x6bf>
  80391c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391f:	8b 40 04             	mov    0x4(%eax),%eax
  803922:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803925:	8b 12                	mov    (%edx),%edx
  803927:	89 10                	mov    %edx,(%eax)
  803929:	eb 0a                	jmp    803935 <realloc_block_FF+0x6c9>
  80392b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392e:	8b 00                	mov    (%eax),%eax
  803930:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803938:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80393e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803941:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803948:	a1 38 50 80 00       	mov    0x805038,%eax
  80394d:	48                   	dec    %eax
  80394e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803953:	83 ec 04             	sub    $0x4,%esp
  803956:	6a 00                	push   $0x0
  803958:	ff 75 bc             	pushl  -0x44(%ebp)
  80395b:	ff 75 b8             	pushl  -0x48(%ebp)
  80395e:	e8 39 e9 ff ff       	call   80229c <set_block_data>
  803963:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803966:	8b 45 08             	mov    0x8(%ebp),%eax
  803969:	eb 0a                	jmp    803975 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80396b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803972:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803975:	c9                   	leave  
  803976:	c3                   	ret    

00803977 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803977:	55                   	push   %ebp
  803978:	89 e5                	mov    %esp,%ebp
  80397a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80397d:	83 ec 04             	sub    $0x4,%esp
  803980:	68 e0 45 80 00       	push   $0x8045e0
  803985:	68 58 02 00 00       	push   $0x258
  80398a:	68 01 45 80 00       	push   $0x804501
  80398f:	e8 04 ca ff ff       	call   800398 <_panic>

00803994 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803994:	55                   	push   %ebp
  803995:	89 e5                	mov    %esp,%ebp
  803997:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80399a:	83 ec 04             	sub    $0x4,%esp
  80399d:	68 08 46 80 00       	push   $0x804608
  8039a2:	68 61 02 00 00       	push   $0x261
  8039a7:	68 01 45 80 00       	push   $0x804501
  8039ac:	e8 e7 c9 ff ff       	call   800398 <_panic>
  8039b1:	66 90                	xchg   %ax,%ax
  8039b3:	90                   	nop

008039b4 <__udivdi3>:
  8039b4:	55                   	push   %ebp
  8039b5:	57                   	push   %edi
  8039b6:	56                   	push   %esi
  8039b7:	53                   	push   %ebx
  8039b8:	83 ec 1c             	sub    $0x1c,%esp
  8039bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039cb:	89 ca                	mov    %ecx,%edx
  8039cd:	89 f8                	mov    %edi,%eax
  8039cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039d3:	85 f6                	test   %esi,%esi
  8039d5:	75 2d                	jne    803a04 <__udivdi3+0x50>
  8039d7:	39 cf                	cmp    %ecx,%edi
  8039d9:	77 65                	ja     803a40 <__udivdi3+0x8c>
  8039db:	89 fd                	mov    %edi,%ebp
  8039dd:	85 ff                	test   %edi,%edi
  8039df:	75 0b                	jne    8039ec <__udivdi3+0x38>
  8039e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8039e6:	31 d2                	xor    %edx,%edx
  8039e8:	f7 f7                	div    %edi
  8039ea:	89 c5                	mov    %eax,%ebp
  8039ec:	31 d2                	xor    %edx,%edx
  8039ee:	89 c8                	mov    %ecx,%eax
  8039f0:	f7 f5                	div    %ebp
  8039f2:	89 c1                	mov    %eax,%ecx
  8039f4:	89 d8                	mov    %ebx,%eax
  8039f6:	f7 f5                	div    %ebp
  8039f8:	89 cf                	mov    %ecx,%edi
  8039fa:	89 fa                	mov    %edi,%edx
  8039fc:	83 c4 1c             	add    $0x1c,%esp
  8039ff:	5b                   	pop    %ebx
  803a00:	5e                   	pop    %esi
  803a01:	5f                   	pop    %edi
  803a02:	5d                   	pop    %ebp
  803a03:	c3                   	ret    
  803a04:	39 ce                	cmp    %ecx,%esi
  803a06:	77 28                	ja     803a30 <__udivdi3+0x7c>
  803a08:	0f bd fe             	bsr    %esi,%edi
  803a0b:	83 f7 1f             	xor    $0x1f,%edi
  803a0e:	75 40                	jne    803a50 <__udivdi3+0x9c>
  803a10:	39 ce                	cmp    %ecx,%esi
  803a12:	72 0a                	jb     803a1e <__udivdi3+0x6a>
  803a14:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a18:	0f 87 9e 00 00 00    	ja     803abc <__udivdi3+0x108>
  803a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a23:	89 fa                	mov    %edi,%edx
  803a25:	83 c4 1c             	add    $0x1c,%esp
  803a28:	5b                   	pop    %ebx
  803a29:	5e                   	pop    %esi
  803a2a:	5f                   	pop    %edi
  803a2b:	5d                   	pop    %ebp
  803a2c:	c3                   	ret    
  803a2d:	8d 76 00             	lea    0x0(%esi),%esi
  803a30:	31 ff                	xor    %edi,%edi
  803a32:	31 c0                	xor    %eax,%eax
  803a34:	89 fa                	mov    %edi,%edx
  803a36:	83 c4 1c             	add    $0x1c,%esp
  803a39:	5b                   	pop    %ebx
  803a3a:	5e                   	pop    %esi
  803a3b:	5f                   	pop    %edi
  803a3c:	5d                   	pop    %ebp
  803a3d:	c3                   	ret    
  803a3e:	66 90                	xchg   %ax,%ax
  803a40:	89 d8                	mov    %ebx,%eax
  803a42:	f7 f7                	div    %edi
  803a44:	31 ff                	xor    %edi,%edi
  803a46:	89 fa                	mov    %edi,%edx
  803a48:	83 c4 1c             	add    $0x1c,%esp
  803a4b:	5b                   	pop    %ebx
  803a4c:	5e                   	pop    %esi
  803a4d:	5f                   	pop    %edi
  803a4e:	5d                   	pop    %ebp
  803a4f:	c3                   	ret    
  803a50:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a55:	89 eb                	mov    %ebp,%ebx
  803a57:	29 fb                	sub    %edi,%ebx
  803a59:	89 f9                	mov    %edi,%ecx
  803a5b:	d3 e6                	shl    %cl,%esi
  803a5d:	89 c5                	mov    %eax,%ebp
  803a5f:	88 d9                	mov    %bl,%cl
  803a61:	d3 ed                	shr    %cl,%ebp
  803a63:	89 e9                	mov    %ebp,%ecx
  803a65:	09 f1                	or     %esi,%ecx
  803a67:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a6b:	89 f9                	mov    %edi,%ecx
  803a6d:	d3 e0                	shl    %cl,%eax
  803a6f:	89 c5                	mov    %eax,%ebp
  803a71:	89 d6                	mov    %edx,%esi
  803a73:	88 d9                	mov    %bl,%cl
  803a75:	d3 ee                	shr    %cl,%esi
  803a77:	89 f9                	mov    %edi,%ecx
  803a79:	d3 e2                	shl    %cl,%edx
  803a7b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a7f:	88 d9                	mov    %bl,%cl
  803a81:	d3 e8                	shr    %cl,%eax
  803a83:	09 c2                	or     %eax,%edx
  803a85:	89 d0                	mov    %edx,%eax
  803a87:	89 f2                	mov    %esi,%edx
  803a89:	f7 74 24 0c          	divl   0xc(%esp)
  803a8d:	89 d6                	mov    %edx,%esi
  803a8f:	89 c3                	mov    %eax,%ebx
  803a91:	f7 e5                	mul    %ebp
  803a93:	39 d6                	cmp    %edx,%esi
  803a95:	72 19                	jb     803ab0 <__udivdi3+0xfc>
  803a97:	74 0b                	je     803aa4 <__udivdi3+0xf0>
  803a99:	89 d8                	mov    %ebx,%eax
  803a9b:	31 ff                	xor    %edi,%edi
  803a9d:	e9 58 ff ff ff       	jmp    8039fa <__udivdi3+0x46>
  803aa2:	66 90                	xchg   %ax,%ax
  803aa4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803aa8:	89 f9                	mov    %edi,%ecx
  803aaa:	d3 e2                	shl    %cl,%edx
  803aac:	39 c2                	cmp    %eax,%edx
  803aae:	73 e9                	jae    803a99 <__udivdi3+0xe5>
  803ab0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ab3:	31 ff                	xor    %edi,%edi
  803ab5:	e9 40 ff ff ff       	jmp    8039fa <__udivdi3+0x46>
  803aba:	66 90                	xchg   %ax,%ax
  803abc:	31 c0                	xor    %eax,%eax
  803abe:	e9 37 ff ff ff       	jmp    8039fa <__udivdi3+0x46>
  803ac3:	90                   	nop

00803ac4 <__umoddi3>:
  803ac4:	55                   	push   %ebp
  803ac5:	57                   	push   %edi
  803ac6:	56                   	push   %esi
  803ac7:	53                   	push   %ebx
  803ac8:	83 ec 1c             	sub    $0x1c,%esp
  803acb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803acf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ad7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803adb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803adf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ae3:	89 f3                	mov    %esi,%ebx
  803ae5:	89 fa                	mov    %edi,%edx
  803ae7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aeb:	89 34 24             	mov    %esi,(%esp)
  803aee:	85 c0                	test   %eax,%eax
  803af0:	75 1a                	jne    803b0c <__umoddi3+0x48>
  803af2:	39 f7                	cmp    %esi,%edi
  803af4:	0f 86 a2 00 00 00    	jbe    803b9c <__umoddi3+0xd8>
  803afa:	89 c8                	mov    %ecx,%eax
  803afc:	89 f2                	mov    %esi,%edx
  803afe:	f7 f7                	div    %edi
  803b00:	89 d0                	mov    %edx,%eax
  803b02:	31 d2                	xor    %edx,%edx
  803b04:	83 c4 1c             	add    $0x1c,%esp
  803b07:	5b                   	pop    %ebx
  803b08:	5e                   	pop    %esi
  803b09:	5f                   	pop    %edi
  803b0a:	5d                   	pop    %ebp
  803b0b:	c3                   	ret    
  803b0c:	39 f0                	cmp    %esi,%eax
  803b0e:	0f 87 ac 00 00 00    	ja     803bc0 <__umoddi3+0xfc>
  803b14:	0f bd e8             	bsr    %eax,%ebp
  803b17:	83 f5 1f             	xor    $0x1f,%ebp
  803b1a:	0f 84 ac 00 00 00    	je     803bcc <__umoddi3+0x108>
  803b20:	bf 20 00 00 00       	mov    $0x20,%edi
  803b25:	29 ef                	sub    %ebp,%edi
  803b27:	89 fe                	mov    %edi,%esi
  803b29:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b2d:	89 e9                	mov    %ebp,%ecx
  803b2f:	d3 e0                	shl    %cl,%eax
  803b31:	89 d7                	mov    %edx,%edi
  803b33:	89 f1                	mov    %esi,%ecx
  803b35:	d3 ef                	shr    %cl,%edi
  803b37:	09 c7                	or     %eax,%edi
  803b39:	89 e9                	mov    %ebp,%ecx
  803b3b:	d3 e2                	shl    %cl,%edx
  803b3d:	89 14 24             	mov    %edx,(%esp)
  803b40:	89 d8                	mov    %ebx,%eax
  803b42:	d3 e0                	shl    %cl,%eax
  803b44:	89 c2                	mov    %eax,%edx
  803b46:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b4a:	d3 e0                	shl    %cl,%eax
  803b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b50:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b54:	89 f1                	mov    %esi,%ecx
  803b56:	d3 e8                	shr    %cl,%eax
  803b58:	09 d0                	or     %edx,%eax
  803b5a:	d3 eb                	shr    %cl,%ebx
  803b5c:	89 da                	mov    %ebx,%edx
  803b5e:	f7 f7                	div    %edi
  803b60:	89 d3                	mov    %edx,%ebx
  803b62:	f7 24 24             	mull   (%esp)
  803b65:	89 c6                	mov    %eax,%esi
  803b67:	89 d1                	mov    %edx,%ecx
  803b69:	39 d3                	cmp    %edx,%ebx
  803b6b:	0f 82 87 00 00 00    	jb     803bf8 <__umoddi3+0x134>
  803b71:	0f 84 91 00 00 00    	je     803c08 <__umoddi3+0x144>
  803b77:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b7b:	29 f2                	sub    %esi,%edx
  803b7d:	19 cb                	sbb    %ecx,%ebx
  803b7f:	89 d8                	mov    %ebx,%eax
  803b81:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b85:	d3 e0                	shl    %cl,%eax
  803b87:	89 e9                	mov    %ebp,%ecx
  803b89:	d3 ea                	shr    %cl,%edx
  803b8b:	09 d0                	or     %edx,%eax
  803b8d:	89 e9                	mov    %ebp,%ecx
  803b8f:	d3 eb                	shr    %cl,%ebx
  803b91:	89 da                	mov    %ebx,%edx
  803b93:	83 c4 1c             	add    $0x1c,%esp
  803b96:	5b                   	pop    %ebx
  803b97:	5e                   	pop    %esi
  803b98:	5f                   	pop    %edi
  803b99:	5d                   	pop    %ebp
  803b9a:	c3                   	ret    
  803b9b:	90                   	nop
  803b9c:	89 fd                	mov    %edi,%ebp
  803b9e:	85 ff                	test   %edi,%edi
  803ba0:	75 0b                	jne    803bad <__umoddi3+0xe9>
  803ba2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ba7:	31 d2                	xor    %edx,%edx
  803ba9:	f7 f7                	div    %edi
  803bab:	89 c5                	mov    %eax,%ebp
  803bad:	89 f0                	mov    %esi,%eax
  803baf:	31 d2                	xor    %edx,%edx
  803bb1:	f7 f5                	div    %ebp
  803bb3:	89 c8                	mov    %ecx,%eax
  803bb5:	f7 f5                	div    %ebp
  803bb7:	89 d0                	mov    %edx,%eax
  803bb9:	e9 44 ff ff ff       	jmp    803b02 <__umoddi3+0x3e>
  803bbe:	66 90                	xchg   %ax,%ax
  803bc0:	89 c8                	mov    %ecx,%eax
  803bc2:	89 f2                	mov    %esi,%edx
  803bc4:	83 c4 1c             	add    $0x1c,%esp
  803bc7:	5b                   	pop    %ebx
  803bc8:	5e                   	pop    %esi
  803bc9:	5f                   	pop    %edi
  803bca:	5d                   	pop    %ebp
  803bcb:	c3                   	ret    
  803bcc:	3b 04 24             	cmp    (%esp),%eax
  803bcf:	72 06                	jb     803bd7 <__umoddi3+0x113>
  803bd1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bd5:	77 0f                	ja     803be6 <__umoddi3+0x122>
  803bd7:	89 f2                	mov    %esi,%edx
  803bd9:	29 f9                	sub    %edi,%ecx
  803bdb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bdf:	89 14 24             	mov    %edx,(%esp)
  803be2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803be6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bea:	8b 14 24             	mov    (%esp),%edx
  803bed:	83 c4 1c             	add    $0x1c,%esp
  803bf0:	5b                   	pop    %ebx
  803bf1:	5e                   	pop    %esi
  803bf2:	5f                   	pop    %edi
  803bf3:	5d                   	pop    %ebp
  803bf4:	c3                   	ret    
  803bf5:	8d 76 00             	lea    0x0(%esi),%esi
  803bf8:	2b 04 24             	sub    (%esp),%eax
  803bfb:	19 fa                	sbb    %edi,%edx
  803bfd:	89 d1                	mov    %edx,%ecx
  803bff:	89 c6                	mov    %eax,%esi
  803c01:	e9 71 ff ff ff       	jmp    803b77 <__umoddi3+0xb3>
  803c06:	66 90                	xchg   %ax,%ax
  803c08:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c0c:	72 ea                	jb     803bf8 <__umoddi3+0x134>
  803c0e:	89 d9                	mov    %ebx,%ecx
  803c10:	e9 62 ff ff ff       	jmp    803b77 <__umoddi3+0xb3>
