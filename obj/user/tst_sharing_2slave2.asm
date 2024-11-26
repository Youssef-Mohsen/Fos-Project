
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
  80005c:	68 60 3c 80 00       	push   $0x803c60
  800061:	6a 0d                	push   $0xd
  800063:	68 7c 3c 80 00       	push   $0x803c7c
  800068:	e8 2b 03 00 00       	call   800398 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  800074:	e8 bd 1b 00 00       	call   801c36 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int freeFrames, diff, expected;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 20 19 00 00       	call   8019a1 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 ce 19 00 00       	call   801a54 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 97 3c 80 00       	push   $0x803c97
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
  8000b6:	68 9c 3c 80 00       	push   $0x803c9c
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 7c 3c 80 00       	push   $0x803c7c
  8000c2:	e8 d1 02 00 00       	call   800398 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 7e 19 00 00       	call   801a54 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 67 19 00 00       	call   801a54 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 18 3d 80 00       	push   $0x803d18
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 7c 3c 80 00       	push   $0x803c7c
  800104:	e8 8f 02 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 ad 18 00 00       	call   8019bb <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 8e 18 00 00       	call   8019a1 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 3c 19 00 00       	call   801a54 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 b0 3d 80 00       	push   $0x803db0
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
  80014d:	68 9c 3c 80 00       	push   $0x803c9c
  800152:	6a 31                	push   $0x31
  800154:	68 7c 3c 80 00       	push   $0x803c7c
  800159:	e8 3a 02 00 00       	call   800398 <_panic>
		expected = 0;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 e7 18 00 00       	call   801a54 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 d0 18 00 00       	call   801a54 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 18 3d 80 00       	push   $0x803d18
  800194:	6a 34                	push   $0x34
  800196:	68 7c 3c 80 00       	push   $0x803c7c
  80019b:	e8 f8 01 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 16 18 00 00       	call   8019bb <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 0a             	cmp    $0xa,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 b4 3d 80 00       	push   $0x803db4
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 7c 3c 80 00       	push   $0x803c7c
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
  8001d9:	68 b4 3d 80 00       	push   $0x803db4
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 7c 3c 80 00       	push   $0x803c7c
  8001e5:	e8 ae 01 00 00       	call   800398 <_panic>

	inctst();
  8001ea:	e8 6c 1b 00 00       	call   801d5b <inctst>

	//sync with master
	while (gettst() != 5) ;
  8001ef:	90                   	nop
  8001f0:	e8 80 1b 00 00       	call   801d75 <gettst>
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	75 f6                	jne    8001f0 <_main+0x1b8>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 06                	push   $0x6
  8001ff:	e8 d1 1a 00 00       	call   801cd5 <sys_bypassPageFault>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	68 ec 3d 80 00       	push   $0x803dec
  800212:	e8 3e 04 00 00       	call   800655 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 a8 1a 00 00       	call   801cd5 <sys_bypassPageFault>
  80022d:	83 c4 10             	add    $0x10,%esp

	inctst();
  800230:	e8 26 1b 00 00       	call   801d5b <inctst>
	if (*x == 100)
  800235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	83 f8 64             	cmp    $0x64,%eax
  80023d:	75 14                	jne    800253 <_main+0x21b>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 1c 3e 80 00       	push   $0x803e1c
  800247:	6a 4d                	push   $0x4d
  800249:	68 7c 3c 80 00       	push   $0x803c7c
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
  80025f:	e8 b9 19 00 00       	call   801c1d <sys_getenvindex>
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
  8002cd:	e8 cf 16 00 00       	call   8019a1 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	68 7c 3e 80 00       	push   $0x803e7c
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
  8002fd:	68 a4 3e 80 00       	push   $0x803ea4
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
  80032e:	68 cc 3e 80 00       	push   $0x803ecc
  800333:	e8 1d 03 00 00       	call   800655 <cprintf>
  800338:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80033b:	a1 20 50 80 00       	mov    0x805020,%eax
  800340:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	50                   	push   %eax
  80034a:	68 24 3f 80 00       	push   $0x803f24
  80034f:	e8 01 03 00 00       	call   800655 <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	68 7c 3e 80 00       	push   $0x803e7c
  80035f:	e8 f1 02 00 00       	call   800655 <cprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800367:	e8 4f 16 00 00       	call   8019bb <sys_unlock_cons>
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
  80037f:	e8 65 18 00 00       	call   801be9 <sys_destroy_env>
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
  800390:	e8 ba 18 00 00       	call   801c4f <sys_exit_env>
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
  8003b9:	68 38 3f 80 00       	push   $0x803f38
  8003be:	e8 92 02 00 00       	call   800655 <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003c6:	a1 00 50 80 00       	mov    0x805000,%eax
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	50                   	push   %eax
  8003d2:	68 3d 3f 80 00       	push   $0x803f3d
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
  8003f6:	68 59 3f 80 00       	push   $0x803f59
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
  800425:	68 5c 3f 80 00       	push   $0x803f5c
  80042a:	6a 26                	push   $0x26
  80042c:	68 a8 3f 80 00       	push   $0x803fa8
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
  8004fa:	68 b4 3f 80 00       	push   $0x803fb4
  8004ff:	6a 3a                	push   $0x3a
  800501:	68 a8 3f 80 00       	push   $0x803fa8
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
  80056d:	68 08 40 80 00       	push   $0x804008
  800572:	6a 44                	push   $0x44
  800574:	68 a8 3f 80 00       	push   $0x803fa8
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
  8005c7:	e8 93 13 00 00       	call   80195f <sys_cputs>
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
  80063e:	e8 1c 13 00 00       	call   80195f <sys_cputs>
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
  800688:	e8 14 13 00 00       	call   8019a1 <sys_lock_cons>
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
  8006a8:	e8 0e 13 00 00       	call   8019bb <sys_unlock_cons>
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
  8006f2:	e8 01 33 00 00       	call   8039f8 <__udivdi3>
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
  800742:	e8 c1 33 00 00       	call   803b08 <__umoddi3>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	05 74 42 80 00       	add    $0x804274,%eax
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
  80089d:	8b 04 85 98 42 80 00 	mov    0x804298(,%eax,4),%eax
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
  80097e:	8b 34 9d e0 40 80 00 	mov    0x8040e0(,%ebx,4),%esi
  800985:	85 f6                	test   %esi,%esi
  800987:	75 19                	jne    8009a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800989:	53                   	push   %ebx
  80098a:	68 85 42 80 00       	push   $0x804285
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
  8009a3:	68 8e 42 80 00       	push   $0x80428e
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
  8009d0:	be 91 42 80 00       	mov    $0x804291,%esi
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
  8013db:	68 08 44 80 00       	push   $0x804408
  8013e0:	68 3f 01 00 00       	push   $0x13f
  8013e5:	68 2a 44 80 00       	push   $0x80442a
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
  8013fb:	e8 0a 0b 00 00       	call   801f0a <sys_sbrk>
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
  801476:	e8 13 09 00 00       	call   801d8e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80147b:	85 c0                	test   %eax,%eax
  80147d:	74 16                	je     801495 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	e8 53 0e 00 00       	call   8022dd <alloc_block_FF>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801490:	e9 8a 01 00 00       	jmp    80161f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801495:	e8 25 09 00 00       	call   801dbf <sys_isUHeapPlacementStrategyBESTFIT>
  80149a:	85 c0                	test   %eax,%eax
  80149c:	0f 84 7d 01 00 00    	je     80161f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 ec 12 00 00       	call   802799 <alloc_block_BF>
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
  80160e:	e8 2e 09 00 00       	call   801f41 <sys_allocate_user_mem>
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
  801656:	e8 02 09 00 00       	call   801f5d <get_block_size>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	e8 35 1b 00 00       	call   8031a1 <free_block>
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
  8016fe:	e8 22 08 00 00       	call   801f25 <sys_free_user_mem>
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
  80170c:	68 38 44 80 00       	push   $0x804438
  801711:	68 85 00 00 00       	push   $0x85
  801716:	68 62 44 80 00       	push   $0x804462
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
  801781:	e8 a6 03 00 00       	call   801b2c <sys_createSharedObject>
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
  8017a5:	68 6e 44 80 00       	push   $0x80446e
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
  8017e9:	e8 68 03 00 00       	call   801b56 <sys_getSizeOfSharedObject>
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8017f4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017f8:	75 07                	jne    801801 <sget+0x27>
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ff:	eb 7f                	jmp    801880 <sget+0xa6>
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
  801834:	eb 4a                	jmp    801880 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	ff 75 e8             	pushl  -0x18(%ebp)
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	ff 75 08             	pushl  0x8(%ebp)
  801842:	e8 2c 03 00 00       	call   801b73 <sys_getSharedObject>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80184d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801850:	a1 20 50 80 00       	mov    0x805020,%eax
  801855:	8b 40 78             	mov    0x78(%eax),%eax
  801858:	29 c2                	sub    %eax,%edx
  80185a:	89 d0                	mov    %edx,%eax
  80185c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801861:	c1 e8 0c             	shr    $0xc,%eax
  801864:	89 c2                	mov    %eax,%edx
  801866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801869:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801870:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801874:	75 07                	jne    80187d <sget+0xa3>
  801876:	b8 00 00 00 00       	mov    $0x0,%eax
  80187b:	eb 03                	jmp    801880 <sget+0xa6>
	return ptr;
  80187d:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801888:	8b 55 08             	mov    0x8(%ebp),%edx
  80188b:	a1 20 50 80 00       	mov    0x805020,%eax
  801890:	8b 40 78             	mov    0x78(%eax),%eax
  801893:	29 c2                	sub    %eax,%edx
  801895:	89 d0                	mov    %edx,%eax
  801897:	2d 00 10 00 00       	sub    $0x1000,%eax
  80189c:	c1 e8 0c             	shr    $0xc,%eax
  80189f:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018a9:	83 ec 08             	sub    $0x8,%esp
  8018ac:	ff 75 08             	pushl  0x8(%ebp)
  8018af:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b2:	e8 db 02 00 00       	call   801b92 <sys_freeSharedObject>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018bd:	90                   	nop
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	68 80 44 80 00       	push   $0x804480
  8018ce:	68 de 00 00 00       	push   $0xde
  8018d3:	68 62 44 80 00       	push   $0x804462
  8018d8:	e8 bb ea ff ff       	call   800398 <_panic>

008018dd <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e3:	83 ec 04             	sub    $0x4,%esp
  8018e6:	68 a6 44 80 00       	push   $0x8044a6
  8018eb:	68 ea 00 00 00       	push   $0xea
  8018f0:	68 62 44 80 00       	push   $0x804462
  8018f5:	e8 9e ea ff ff       	call   800398 <_panic>

008018fa <shrink>:

}
void shrink(uint32 newSize)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801900:	83 ec 04             	sub    $0x4,%esp
  801903:	68 a6 44 80 00       	push   $0x8044a6
  801908:	68 ef 00 00 00       	push   $0xef
  80190d:	68 62 44 80 00       	push   $0x804462
  801912:	e8 81 ea ff ff       	call   800398 <_panic>

00801917 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80191d:	83 ec 04             	sub    $0x4,%esp
  801920:	68 a6 44 80 00       	push   $0x8044a6
  801925:	68 f4 00 00 00       	push   $0xf4
  80192a:	68 62 44 80 00       	push   $0x804462
  80192f:	e8 64 ea ff ff       	call   800398 <_panic>

00801934 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	57                   	push   %edi
  801938:	56                   	push   %esi
  801939:	53                   	push   %ebx
  80193a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	8b 55 0c             	mov    0xc(%ebp),%edx
  801943:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801946:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801949:	8b 7d 18             	mov    0x18(%ebp),%edi
  80194c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80194f:	cd 30                	int    $0x30
  801951:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801954:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	5b                   	pop    %ebx
  80195b:	5e                   	pop    %esi
  80195c:	5f                   	pop    %edi
  80195d:	5d                   	pop    %ebp
  80195e:	c3                   	ret    

0080195f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	8b 45 10             	mov    0x10(%ebp),%eax
  801968:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80196b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	52                   	push   %edx
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	50                   	push   %eax
  80197b:	6a 00                	push   $0x0
  80197d:	e8 b2 ff ff ff       	call   801934 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	90                   	nop
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_cgetc>:

int
sys_cgetc(void)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 02                	push   $0x2
  801997:	e8 98 ff ff ff       	call   801934 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 03                	push   $0x3
  8019b0:	e8 7f ff ff ff       	call   801934 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	90                   	nop
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 04                	push   $0x4
  8019ca:	e8 65 ff ff ff       	call   801934 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	90                   	nop
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	52                   	push   %edx
  8019e5:	50                   	push   %eax
  8019e6:	6a 08                	push   $0x8
  8019e8:	e8 47 ff ff ff       	call   801934 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	56                   	push   %esi
  8019f6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019f7:	8b 75 18             	mov    0x18(%ebp),%esi
  8019fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	56                   	push   %esi
  801a07:	53                   	push   %ebx
  801a08:	51                   	push   %ecx
  801a09:	52                   	push   %edx
  801a0a:	50                   	push   %eax
  801a0b:	6a 09                	push   $0x9
  801a0d:	e8 22 ff ff ff       	call   801934 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a18:	5b                   	pop    %ebx
  801a19:	5e                   	pop    %esi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    

00801a1c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	52                   	push   %edx
  801a2c:	50                   	push   %eax
  801a2d:	6a 0a                	push   $0xa
  801a2f:	e8 00 ff ff ff       	call   801934 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	ff 75 0c             	pushl  0xc(%ebp)
  801a45:	ff 75 08             	pushl  0x8(%ebp)
  801a48:	6a 0b                	push   $0xb
  801a4a:	e8 e5 fe ff ff       	call   801934 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 0c                	push   $0xc
  801a63:	e8 cc fe ff ff       	call   801934 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 0d                	push   $0xd
  801a7c:	e8 b3 fe ff ff       	call   801934 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 0e                	push   $0xe
  801a95:	e8 9a fe ff ff       	call   801934 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 0f                	push   $0xf
  801aae:	e8 81 fe ff ff       	call   801934 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	ff 75 08             	pushl  0x8(%ebp)
  801ac6:	6a 10                	push   $0x10
  801ac8:	e8 67 fe ff ff       	call   801934 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 11                	push   $0x11
  801ae1:	e8 4e fe ff ff       	call   801934 <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	90                   	nop
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_cputc>:

void
sys_cputc(const char c)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801af8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	50                   	push   %eax
  801b05:	6a 01                	push   $0x1
  801b07:	e8 28 fe ff ff       	call   801934 <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 14                	push   $0x14
  801b21:	e8 0e fe ff ff       	call   801934 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	90                   	nop
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 04             	sub    $0x4,%esp
  801b32:	8b 45 10             	mov    0x10(%ebp),%eax
  801b35:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b38:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b3b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	51                   	push   %ecx
  801b45:	52                   	push   %edx
  801b46:	ff 75 0c             	pushl  0xc(%ebp)
  801b49:	50                   	push   %eax
  801b4a:	6a 15                	push   $0x15
  801b4c:	e8 e3 fd ff ff       	call   801934 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	6a 16                	push   $0x16
  801b69:	e8 c6 fd ff ff       	call   801934 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b76:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	51                   	push   %ecx
  801b84:	52                   	push   %edx
  801b85:	50                   	push   %eax
  801b86:	6a 17                	push   $0x17
  801b88:	e8 a7 fd ff ff       	call   801934 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 18                	push   $0x18
  801ba5:	e8 8a fd ff ff       	call   801934 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	ff 75 14             	pushl  0x14(%ebp)
  801bba:	ff 75 10             	pushl  0x10(%ebp)
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	50                   	push   %eax
  801bc1:	6a 19                	push   $0x19
  801bc3:	e8 6c fd ff ff       	call   801934 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	50                   	push   %eax
  801bdc:	6a 1a                	push   $0x1a
  801bde:	e8 51 fd ff ff       	call   801934 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	90                   	nop
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	50                   	push   %eax
  801bf8:	6a 1b                	push   $0x1b
  801bfa:	e8 35 fd ff ff       	call   801934 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 05                	push   $0x5
  801c13:	e8 1c fd ff ff       	call   801934 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 06                	push   $0x6
  801c2c:	e8 03 fd ff ff       	call   801934 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 07                	push   $0x7
  801c45:	e8 ea fc ff ff       	call   801934 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_exit_env>:


void sys_exit_env(void)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 1c                	push   $0x1c
  801c5e:	e8 d1 fc ff ff       	call   801934 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	90                   	nop
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c6f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c72:	8d 50 04             	lea    0x4(%eax),%edx
  801c75:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	52                   	push   %edx
  801c7f:	50                   	push   %eax
  801c80:	6a 1d                	push   $0x1d
  801c82:	e8 ad fc ff ff       	call   801934 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
	return result;
  801c8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c93:	89 01                	mov    %eax,(%ecx)
  801c95:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	c9                   	leave  
  801c9c:	c2 04 00             	ret    $0x4

00801c9f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	ff 75 10             	pushl  0x10(%ebp)
  801ca9:	ff 75 0c             	pushl  0xc(%ebp)
  801cac:	ff 75 08             	pushl  0x8(%ebp)
  801caf:	6a 13                	push   $0x13
  801cb1:	e8 7e fc ff ff       	call   801934 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb9:	90                   	nop
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_rcr2>:
uint32 sys_rcr2()
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 1e                	push   $0x1e
  801ccb:	e8 64 fc ff ff       	call   801934 <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 04             	sub    $0x4,%esp
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ce1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	50                   	push   %eax
  801cee:	6a 1f                	push   $0x1f
  801cf0:	e8 3f fc ff ff       	call   801934 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf8:	90                   	nop
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <rsttst>:
void rsttst()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 21                	push   $0x21
  801d0a:	e8 25 fc ff ff       	call   801934 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d12:	90                   	nop
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 04             	sub    $0x4,%esp
  801d1b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d21:	8b 55 18             	mov    0x18(%ebp),%edx
  801d24:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d28:	52                   	push   %edx
  801d29:	50                   	push   %eax
  801d2a:	ff 75 10             	pushl  0x10(%ebp)
  801d2d:	ff 75 0c             	pushl  0xc(%ebp)
  801d30:	ff 75 08             	pushl  0x8(%ebp)
  801d33:	6a 20                	push   $0x20
  801d35:	e8 fa fb ff ff       	call   801934 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3d:	90                   	nop
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <chktst>:
void chktst(uint32 n)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	ff 75 08             	pushl  0x8(%ebp)
  801d4e:	6a 22                	push   $0x22
  801d50:	e8 df fb ff ff       	call   801934 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
	return ;
  801d58:	90                   	nop
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <inctst>:

void inctst()
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 23                	push   $0x23
  801d6a:	e8 c5 fb ff ff       	call   801934 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d72:	90                   	nop
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <gettst>:
uint32 gettst()
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 24                	push   $0x24
  801d84:	e8 ab fb ff ff       	call   801934 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 25                	push   $0x25
  801da0:	e8 8f fb ff ff       	call   801934 <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
  801da8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dab:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801daf:	75 07                	jne    801db8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801db1:	b8 01 00 00 00       	mov    $0x1,%eax
  801db6:	eb 05                	jmp    801dbd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 25                	push   $0x25
  801dd1:	e8 5e fb ff ff       	call   801934 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
  801dd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ddc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801de0:	75 07                	jne    801de9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801de2:	b8 01 00 00 00       	mov    $0x1,%eax
  801de7:	eb 05                	jmp    801dee <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 25                	push   $0x25
  801e02:	e8 2d fb ff ff       	call   801934 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
  801e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e0d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e11:	75 07                	jne    801e1a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e13:	b8 01 00 00 00       	mov    $0x1,%eax
  801e18:	eb 05                	jmp    801e1f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 25                	push   $0x25
  801e33:	e8 fc fa ff ff       	call   801934 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
  801e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e3e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e42:	75 07                	jne    801e4b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e44:	b8 01 00 00 00       	mov    $0x1,%eax
  801e49:	eb 05                	jmp    801e50 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	ff 75 08             	pushl  0x8(%ebp)
  801e60:	6a 26                	push   $0x26
  801e62:	e8 cd fa ff ff       	call   801934 <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6a:	90                   	nop
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e71:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e74:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7d:	6a 00                	push   $0x0
  801e7f:	53                   	push   %ebx
  801e80:	51                   	push   %ecx
  801e81:	52                   	push   %edx
  801e82:	50                   	push   %eax
  801e83:	6a 27                	push   $0x27
  801e85:	e8 aa fa ff ff       	call   801934 <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	52                   	push   %edx
  801ea2:	50                   	push   %eax
  801ea3:	6a 28                	push   $0x28
  801ea5:	e8 8a fa ff ff       	call   801934 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801eb2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	6a 00                	push   $0x0
  801ebd:	51                   	push   %ecx
  801ebe:	ff 75 10             	pushl  0x10(%ebp)
  801ec1:	52                   	push   %edx
  801ec2:	50                   	push   %eax
  801ec3:	6a 29                	push   $0x29
  801ec5:	e8 6a fa ff ff       	call   801934 <syscall>
  801eca:	83 c4 18             	add    $0x18,%esp
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	ff 75 10             	pushl  0x10(%ebp)
  801ed9:	ff 75 0c             	pushl  0xc(%ebp)
  801edc:	ff 75 08             	pushl  0x8(%ebp)
  801edf:	6a 12                	push   $0x12
  801ee1:	e8 4e fa ff ff       	call   801934 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee9:	90                   	nop
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801eef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	52                   	push   %edx
  801efc:	50                   	push   %eax
  801efd:	6a 2a                	push   $0x2a
  801eff:	e8 30 fa ff ff       	call   801934 <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
	return;
  801f07:	90                   	nop
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	50                   	push   %eax
  801f19:	6a 2b                	push   $0x2b
  801f1b:	e8 14 fa ff ff       	call   801934 <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	ff 75 08             	pushl  0x8(%ebp)
  801f34:	6a 2c                	push   $0x2c
  801f36:	e8 f9 f9 ff ff       	call   801934 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
	return;
  801f3e:	90                   	nop
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	ff 75 0c             	pushl  0xc(%ebp)
  801f4d:	ff 75 08             	pushl  0x8(%ebp)
  801f50:	6a 2d                	push   $0x2d
  801f52:	e8 dd f9 ff ff       	call   801934 <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
	return;
  801f5a:	90                   	nop
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	83 e8 04             	sub    $0x4,%eax
  801f69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6f:	8b 00                	mov    (%eax),%eax
  801f71:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	83 e8 04             	sub    $0x4,%eax
  801f82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f88:	8b 00                	mov    (%eax),%eax
  801f8a:	83 e0 01             	and    $0x1,%eax
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	0f 94 c0             	sete   %al
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa4:	83 f8 02             	cmp    $0x2,%eax
  801fa7:	74 2b                	je     801fd4 <alloc_block+0x40>
  801fa9:	83 f8 02             	cmp    $0x2,%eax
  801fac:	7f 07                	jg     801fb5 <alloc_block+0x21>
  801fae:	83 f8 01             	cmp    $0x1,%eax
  801fb1:	74 0e                	je     801fc1 <alloc_block+0x2d>
  801fb3:	eb 58                	jmp    80200d <alloc_block+0x79>
  801fb5:	83 f8 03             	cmp    $0x3,%eax
  801fb8:	74 2d                	je     801fe7 <alloc_block+0x53>
  801fba:	83 f8 04             	cmp    $0x4,%eax
  801fbd:	74 3b                	je     801ffa <alloc_block+0x66>
  801fbf:	eb 4c                	jmp    80200d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	ff 75 08             	pushl  0x8(%ebp)
  801fc7:	e8 11 03 00 00       	call   8022dd <alloc_block_FF>
  801fcc:	83 c4 10             	add    $0x10,%esp
  801fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd2:	eb 4a                	jmp    80201e <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fd4:	83 ec 0c             	sub    $0xc,%esp
  801fd7:	ff 75 08             	pushl  0x8(%ebp)
  801fda:	e8 fa 19 00 00       	call   8039d9 <alloc_block_NF>
  801fdf:	83 c4 10             	add    $0x10,%esp
  801fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe5:	eb 37                	jmp    80201e <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fe7:	83 ec 0c             	sub    $0xc,%esp
  801fea:	ff 75 08             	pushl  0x8(%ebp)
  801fed:	e8 a7 07 00 00       	call   802799 <alloc_block_BF>
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ff8:	eb 24                	jmp    80201e <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ffa:	83 ec 0c             	sub    $0xc,%esp
  801ffd:	ff 75 08             	pushl  0x8(%ebp)
  802000:	e8 b7 19 00 00       	call   8039bc <alloc_block_WF>
  802005:	83 c4 10             	add    $0x10,%esp
  802008:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80200b:	eb 11                	jmp    80201e <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80200d:	83 ec 0c             	sub    $0xc,%esp
  802010:	68 b8 44 80 00       	push   $0x8044b8
  802015:	e8 3b e6 ff ff       	call   800655 <cprintf>
  80201a:	83 c4 10             	add    $0x10,%esp
		break;
  80201d:	90                   	nop
	}
	return va;
  80201e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	53                   	push   %ebx
  802027:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	68 d8 44 80 00       	push   $0x8044d8
  802032:	e8 1e e6 ff ff       	call   800655 <cprintf>
  802037:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80203a:	83 ec 0c             	sub    $0xc,%esp
  80203d:	68 03 45 80 00       	push   $0x804503
  802042:	e8 0e e6 ff ff       	call   800655 <cprintf>
  802047:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802050:	eb 37                	jmp    802089 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802052:	83 ec 0c             	sub    $0xc,%esp
  802055:	ff 75 f4             	pushl  -0xc(%ebp)
  802058:	e8 19 ff ff ff       	call   801f76 <is_free_block>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	0f be d8             	movsbl %al,%ebx
  802063:	83 ec 0c             	sub    $0xc,%esp
  802066:	ff 75 f4             	pushl  -0xc(%ebp)
  802069:	e8 ef fe ff ff       	call   801f5d <get_block_size>
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	83 ec 04             	sub    $0x4,%esp
  802074:	53                   	push   %ebx
  802075:	50                   	push   %eax
  802076:	68 1b 45 80 00       	push   $0x80451b
  80207b:	e8 d5 e5 ff ff       	call   800655 <cprintf>
  802080:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802083:	8b 45 10             	mov    0x10(%ebp),%eax
  802086:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802089:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208d:	74 07                	je     802096 <print_blocks_list+0x73>
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	8b 00                	mov    (%eax),%eax
  802094:	eb 05                	jmp    80209b <print_blocks_list+0x78>
  802096:	b8 00 00 00 00       	mov    $0x0,%eax
  80209b:	89 45 10             	mov    %eax,0x10(%ebp)
  80209e:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	75 ad                	jne    802052 <print_blocks_list+0x2f>
  8020a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a9:	75 a7                	jne    802052 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020ab:	83 ec 0c             	sub    $0xc,%esp
  8020ae:	68 d8 44 80 00       	push   $0x8044d8
  8020b3:	e8 9d e5 ff ff       	call   800655 <cprintf>
  8020b8:	83 c4 10             	add    $0x10,%esp

}
  8020bb:	90                   	nop
  8020bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ca:	83 e0 01             	and    $0x1,%eax
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	74 03                	je     8020d4 <initialize_dynamic_allocator+0x13>
  8020d1:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020d8:	0f 84 c7 01 00 00    	je     8022a5 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020de:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020e5:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8020eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ee:	01 d0                	add    %edx,%eax
  8020f0:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020f5:	0f 87 ad 01 00 00    	ja     8022a8 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	85 c0                	test   %eax,%eax
  802100:	0f 89 a5 01 00 00    	jns    8022ab <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802106:	8b 55 08             	mov    0x8(%ebp),%edx
  802109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210c:	01 d0                	add    %edx,%eax
  80210e:	83 e8 04             	sub    $0x4,%eax
  802111:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802116:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80211d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802125:	e9 87 00 00 00       	jmp    8021b1 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80212a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212e:	75 14                	jne    802144 <initialize_dynamic_allocator+0x83>
  802130:	83 ec 04             	sub    $0x4,%esp
  802133:	68 33 45 80 00       	push   $0x804533
  802138:	6a 79                	push   $0x79
  80213a:	68 51 45 80 00       	push   $0x804551
  80213f:	e8 54 e2 ff ff       	call   800398 <_panic>
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	8b 00                	mov    (%eax),%eax
  802149:	85 c0                	test   %eax,%eax
  80214b:	74 10                	je     80215d <initialize_dynamic_allocator+0x9c>
  80214d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802150:	8b 00                	mov    (%eax),%eax
  802152:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802155:	8b 52 04             	mov    0x4(%edx),%edx
  802158:	89 50 04             	mov    %edx,0x4(%eax)
  80215b:	eb 0b                	jmp    802168 <initialize_dynamic_allocator+0xa7>
  80215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802160:	8b 40 04             	mov    0x4(%eax),%eax
  802163:	a3 30 50 80 00       	mov    %eax,0x805030
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	8b 40 04             	mov    0x4(%eax),%eax
  80216e:	85 c0                	test   %eax,%eax
  802170:	74 0f                	je     802181 <initialize_dynamic_allocator+0xc0>
  802172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802175:	8b 40 04             	mov    0x4(%eax),%eax
  802178:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217b:	8b 12                	mov    (%edx),%edx
  80217d:	89 10                	mov    %edx,(%eax)
  80217f:	eb 0a                	jmp    80218b <initialize_dynamic_allocator+0xca>
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	8b 00                	mov    (%eax),%eax
  802186:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802197:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80219e:	a1 38 50 80 00       	mov    0x805038,%eax
  8021a3:	48                   	dec    %eax
  8021a4:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021a9:	a1 34 50 80 00       	mov    0x805034,%eax
  8021ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b5:	74 07                	je     8021be <initialize_dynamic_allocator+0xfd>
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	8b 00                	mov    (%eax),%eax
  8021bc:	eb 05                	jmp    8021c3 <initialize_dynamic_allocator+0x102>
  8021be:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c3:	a3 34 50 80 00       	mov    %eax,0x805034
  8021c8:	a1 34 50 80 00       	mov    0x805034,%eax
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	0f 85 55 ff ff ff    	jne    80212a <initialize_dynamic_allocator+0x69>
  8021d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d9:	0f 85 4b ff ff ff    	jne    80212a <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021ee:	a1 44 50 80 00       	mov    0x805044,%eax
  8021f3:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021f8:	a1 40 50 80 00       	mov    0x805040,%eax
  8021fd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	83 c0 08             	add    $0x8,%eax
  802209:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	83 c0 04             	add    $0x4,%eax
  802212:	8b 55 0c             	mov    0xc(%ebp),%edx
  802215:	83 ea 08             	sub    $0x8,%edx
  802218:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80221a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	01 d0                	add    %edx,%eax
  802222:	83 e8 08             	sub    $0x8,%eax
  802225:	8b 55 0c             	mov    0xc(%ebp),%edx
  802228:	83 ea 08             	sub    $0x8,%edx
  80222b:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80222d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802230:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802236:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802239:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802240:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802244:	75 17                	jne    80225d <initialize_dynamic_allocator+0x19c>
  802246:	83 ec 04             	sub    $0x4,%esp
  802249:	68 6c 45 80 00       	push   $0x80456c
  80224e:	68 90 00 00 00       	push   $0x90
  802253:	68 51 45 80 00       	push   $0x804551
  802258:	e8 3b e1 ff ff       	call   800398 <_panic>
  80225d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802266:	89 10                	mov    %edx,(%eax)
  802268:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226b:	8b 00                	mov    (%eax),%eax
  80226d:	85 c0                	test   %eax,%eax
  80226f:	74 0d                	je     80227e <initialize_dynamic_allocator+0x1bd>
  802271:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802276:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802279:	89 50 04             	mov    %edx,0x4(%eax)
  80227c:	eb 08                	jmp    802286 <initialize_dynamic_allocator+0x1c5>
  80227e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802281:	a3 30 50 80 00       	mov    %eax,0x805030
  802286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802289:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80228e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802291:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802298:	a1 38 50 80 00       	mov    0x805038,%eax
  80229d:	40                   	inc    %eax
  80229e:	a3 38 50 80 00       	mov    %eax,0x805038
  8022a3:	eb 07                	jmp    8022ac <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022a5:	90                   	nop
  8022a6:	eb 04                	jmp    8022ac <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022a8:	90                   	nop
  8022a9:	eb 01                	jmp    8022ac <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022ab:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b4:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c0:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	83 e8 04             	sub    $0x4,%eax
  8022c8:	8b 00                	mov    (%eax),%eax
  8022ca:	83 e0 fe             	and    $0xfffffffe,%eax
  8022cd:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	01 c2                	add    %eax,%edx
  8022d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d8:	89 02                	mov    %eax,(%edx)
}
  8022da:	90                   	nop
  8022db:	5d                   	pop    %ebp
  8022dc:	c3                   	ret    

008022dd <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	83 e0 01             	and    $0x1,%eax
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	74 03                	je     8022f0 <alloc_block_FF+0x13>
  8022ed:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022f0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022f4:	77 07                	ja     8022fd <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022f6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022fd:	a1 24 50 80 00       	mov    0x805024,%eax
  802302:	85 c0                	test   %eax,%eax
  802304:	75 73                	jne    802379 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	83 c0 10             	add    $0x10,%eax
  80230c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80230f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802316:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802319:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231c:	01 d0                	add    %edx,%eax
  80231e:	48                   	dec    %eax
  80231f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802325:	ba 00 00 00 00       	mov    $0x0,%edx
  80232a:	f7 75 ec             	divl   -0x14(%ebp)
  80232d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802330:	29 d0                	sub    %edx,%eax
  802332:	c1 e8 0c             	shr    $0xc,%eax
  802335:	83 ec 0c             	sub    $0xc,%esp
  802338:	50                   	push   %eax
  802339:	e8 b1 f0 ff ff       	call   8013ef <sbrk>
  80233e:	83 c4 10             	add    $0x10,%esp
  802341:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802344:	83 ec 0c             	sub    $0xc,%esp
  802347:	6a 00                	push   $0x0
  802349:	e8 a1 f0 ff ff       	call   8013ef <sbrk>
  80234e:	83 c4 10             	add    $0x10,%esp
  802351:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802354:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802357:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80235a:	83 ec 08             	sub    $0x8,%esp
  80235d:	50                   	push   %eax
  80235e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802361:	e8 5b fd ff ff       	call   8020c1 <initialize_dynamic_allocator>
  802366:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802369:	83 ec 0c             	sub    $0xc,%esp
  80236c:	68 8f 45 80 00       	push   $0x80458f
  802371:	e8 df e2 ff ff       	call   800655 <cprintf>
  802376:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802379:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80237d:	75 0a                	jne    802389 <alloc_block_FF+0xac>
	        return NULL;
  80237f:	b8 00 00 00 00       	mov    $0x0,%eax
  802384:	e9 0e 04 00 00       	jmp    802797 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802389:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802390:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802395:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802398:	e9 f3 02 00 00       	jmp    802690 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023a3:	83 ec 0c             	sub    $0xc,%esp
  8023a6:	ff 75 bc             	pushl  -0x44(%ebp)
  8023a9:	e8 af fb ff ff       	call   801f5d <get_block_size>
  8023ae:	83 c4 10             	add    $0x10,%esp
  8023b1:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	83 c0 08             	add    $0x8,%eax
  8023ba:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023bd:	0f 87 c5 02 00 00    	ja     802688 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	83 c0 18             	add    $0x18,%eax
  8023c9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023cc:	0f 87 19 02 00 00    	ja     8025eb <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023d2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023d5:	2b 45 08             	sub    0x8(%ebp),%eax
  8023d8:	83 e8 08             	sub    $0x8,%eax
  8023db:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	8d 50 08             	lea    0x8(%eax),%edx
  8023e4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023e7:	01 d0                	add    %edx,%eax
  8023e9:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	83 c0 08             	add    $0x8,%eax
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	6a 01                	push   $0x1
  8023f7:	50                   	push   %eax
  8023f8:	ff 75 bc             	pushl  -0x44(%ebp)
  8023fb:	e8 ae fe ff ff       	call   8022ae <set_block_data>
  802400:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802406:	8b 40 04             	mov    0x4(%eax),%eax
  802409:	85 c0                	test   %eax,%eax
  80240b:	75 68                	jne    802475 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80240d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802411:	75 17                	jne    80242a <alloc_block_FF+0x14d>
  802413:	83 ec 04             	sub    $0x4,%esp
  802416:	68 6c 45 80 00       	push   $0x80456c
  80241b:	68 d7 00 00 00       	push   $0xd7
  802420:	68 51 45 80 00       	push   $0x804551
  802425:	e8 6e df ff ff       	call   800398 <_panic>
  80242a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802430:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802433:	89 10                	mov    %edx,(%eax)
  802435:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802438:	8b 00                	mov    (%eax),%eax
  80243a:	85 c0                	test   %eax,%eax
  80243c:	74 0d                	je     80244b <alloc_block_FF+0x16e>
  80243e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802443:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802446:	89 50 04             	mov    %edx,0x4(%eax)
  802449:	eb 08                	jmp    802453 <alloc_block_FF+0x176>
  80244b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244e:	a3 30 50 80 00       	mov    %eax,0x805030
  802453:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802456:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80245b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802465:	a1 38 50 80 00       	mov    0x805038,%eax
  80246a:	40                   	inc    %eax
  80246b:	a3 38 50 80 00       	mov    %eax,0x805038
  802470:	e9 dc 00 00 00       	jmp    802551 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 00                	mov    (%eax),%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	75 65                	jne    8024e3 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80247e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802482:	75 17                	jne    80249b <alloc_block_FF+0x1be>
  802484:	83 ec 04             	sub    $0x4,%esp
  802487:	68 a0 45 80 00       	push   $0x8045a0
  80248c:	68 db 00 00 00       	push   $0xdb
  802491:	68 51 45 80 00       	push   $0x804551
  802496:	e8 fd de ff ff       	call   800398 <_panic>
  80249b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a4:	89 50 04             	mov    %edx,0x4(%eax)
  8024a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024aa:	8b 40 04             	mov    0x4(%eax),%eax
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	74 0c                	je     8024bd <alloc_block_FF+0x1e0>
  8024b1:	a1 30 50 80 00       	mov    0x805030,%eax
  8024b6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024b9:	89 10                	mov    %edx,(%eax)
  8024bb:	eb 08                	jmp    8024c5 <alloc_block_FF+0x1e8>
  8024bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c8:	a3 30 50 80 00       	mov    %eax,0x805030
  8024cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8024db:	40                   	inc    %eax
  8024dc:	a3 38 50 80 00       	mov    %eax,0x805038
  8024e1:	eb 6e                	jmp    802551 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e7:	74 06                	je     8024ef <alloc_block_FF+0x212>
  8024e9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024ed:	75 17                	jne    802506 <alloc_block_FF+0x229>
  8024ef:	83 ec 04             	sub    $0x4,%esp
  8024f2:	68 c4 45 80 00       	push   $0x8045c4
  8024f7:	68 df 00 00 00       	push   $0xdf
  8024fc:	68 51 45 80 00       	push   $0x804551
  802501:	e8 92 de ff ff       	call   800398 <_panic>
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 10                	mov    (%eax),%edx
  80250b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250e:	89 10                	mov    %edx,(%eax)
  802510:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	74 0b                	je     802524 <alloc_block_FF+0x247>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802521:	89 50 04             	mov    %edx,0x4(%eax)
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80252a:	89 10                	mov    %edx,(%eax)
  80252c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80252f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802532:	89 50 04             	mov    %edx,0x4(%eax)
  802535:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802538:	8b 00                	mov    (%eax),%eax
  80253a:	85 c0                	test   %eax,%eax
  80253c:	75 08                	jne    802546 <alloc_block_FF+0x269>
  80253e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802541:	a3 30 50 80 00       	mov    %eax,0x805030
  802546:	a1 38 50 80 00       	mov    0x805038,%eax
  80254b:	40                   	inc    %eax
  80254c:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802555:	75 17                	jne    80256e <alloc_block_FF+0x291>
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	68 33 45 80 00       	push   $0x804533
  80255f:	68 e1 00 00 00       	push   $0xe1
  802564:	68 51 45 80 00       	push   $0x804551
  802569:	e8 2a de ff ff       	call   800398 <_panic>
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 00                	mov    (%eax),%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	74 10                	je     802587 <alloc_block_FF+0x2aa>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257f:	8b 52 04             	mov    0x4(%edx),%edx
  802582:	89 50 04             	mov    %edx,0x4(%eax)
  802585:	eb 0b                	jmp    802592 <alloc_block_FF+0x2b5>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	a3 30 50 80 00       	mov    %eax,0x805030
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 40 04             	mov    0x4(%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 0f                	je     8025ab <alloc_block_FF+0x2ce>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a5:	8b 12                	mov    (%edx),%edx
  8025a7:	89 10                	mov    %edx,(%eax)
  8025a9:	eb 0a                	jmp    8025b5 <alloc_block_FF+0x2d8>
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8025cd:	48                   	dec    %eax
  8025ce:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025d3:	83 ec 04             	sub    $0x4,%esp
  8025d6:	6a 00                	push   $0x0
  8025d8:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025db:	ff 75 b0             	pushl  -0x50(%ebp)
  8025de:	e8 cb fc ff ff       	call   8022ae <set_block_data>
  8025e3:	83 c4 10             	add    $0x10,%esp
  8025e6:	e9 95 00 00 00       	jmp    802680 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	6a 01                	push   $0x1
  8025f0:	ff 75 b8             	pushl  -0x48(%ebp)
  8025f3:	ff 75 bc             	pushl  -0x44(%ebp)
  8025f6:	e8 b3 fc ff ff       	call   8022ae <set_block_data>
  8025fb:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802602:	75 17                	jne    80261b <alloc_block_FF+0x33e>
  802604:	83 ec 04             	sub    $0x4,%esp
  802607:	68 33 45 80 00       	push   $0x804533
  80260c:	68 e8 00 00 00       	push   $0xe8
  802611:	68 51 45 80 00       	push   $0x804551
  802616:	e8 7d dd ff ff       	call   800398 <_panic>
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 00                	mov    (%eax),%eax
  802620:	85 c0                	test   %eax,%eax
  802622:	74 10                	je     802634 <alloc_block_FF+0x357>
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 00                	mov    (%eax),%eax
  802629:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262c:	8b 52 04             	mov    0x4(%edx),%edx
  80262f:	89 50 04             	mov    %edx,0x4(%eax)
  802632:	eb 0b                	jmp    80263f <alloc_block_FF+0x362>
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 40 04             	mov    0x4(%eax),%eax
  80263a:	a3 30 50 80 00       	mov    %eax,0x805030
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 40 04             	mov    0x4(%eax),%eax
  802645:	85 c0                	test   %eax,%eax
  802647:	74 0f                	je     802658 <alloc_block_FF+0x37b>
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 40 04             	mov    0x4(%eax),%eax
  80264f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802652:	8b 12                	mov    (%edx),%edx
  802654:	89 10                	mov    %edx,(%eax)
  802656:	eb 0a                	jmp    802662 <alloc_block_FF+0x385>
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 00                	mov    (%eax),%eax
  80265d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802675:	a1 38 50 80 00       	mov    0x805038,%eax
  80267a:	48                   	dec    %eax
  80267b:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802680:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802683:	e9 0f 01 00 00       	jmp    802797 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802688:	a1 34 50 80 00       	mov    0x805034,%eax
  80268d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802690:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802694:	74 07                	je     80269d <alloc_block_FF+0x3c0>
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 00                	mov    (%eax),%eax
  80269b:	eb 05                	jmp    8026a2 <alloc_block_FF+0x3c5>
  80269d:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a2:	a3 34 50 80 00       	mov    %eax,0x805034
  8026a7:	a1 34 50 80 00       	mov    0x805034,%eax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	0f 85 e9 fc ff ff    	jne    80239d <alloc_block_FF+0xc0>
  8026b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b8:	0f 85 df fc ff ff    	jne    80239d <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026be:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c1:	83 c0 08             	add    $0x8,%eax
  8026c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026c7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026d4:	01 d0                	add    %edx,%eax
  8026d6:	48                   	dec    %eax
  8026d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e2:	f7 75 d8             	divl   -0x28(%ebp)
  8026e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e8:	29 d0                	sub    %edx,%eax
  8026ea:	c1 e8 0c             	shr    $0xc,%eax
  8026ed:	83 ec 0c             	sub    $0xc,%esp
  8026f0:	50                   	push   %eax
  8026f1:	e8 f9 ec ff ff       	call   8013ef <sbrk>
  8026f6:	83 c4 10             	add    $0x10,%esp
  8026f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026fc:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802700:	75 0a                	jne    80270c <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802702:	b8 00 00 00 00       	mov    $0x0,%eax
  802707:	e9 8b 00 00 00       	jmp    802797 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80270c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802713:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802716:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802719:	01 d0                	add    %edx,%eax
  80271b:	48                   	dec    %eax
  80271c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80271f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802722:	ba 00 00 00 00       	mov    $0x0,%edx
  802727:	f7 75 cc             	divl   -0x34(%ebp)
  80272a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80272d:	29 d0                	sub    %edx,%eax
  80272f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802732:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802735:	01 d0                	add    %edx,%eax
  802737:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80273c:	a1 40 50 80 00       	mov    0x805040,%eax
  802741:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802747:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80274e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802751:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802754:	01 d0                	add    %edx,%eax
  802756:	48                   	dec    %eax
  802757:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80275a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80275d:	ba 00 00 00 00       	mov    $0x0,%edx
  802762:	f7 75 c4             	divl   -0x3c(%ebp)
  802765:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802768:	29 d0                	sub    %edx,%eax
  80276a:	83 ec 04             	sub    $0x4,%esp
  80276d:	6a 01                	push   $0x1
  80276f:	50                   	push   %eax
  802770:	ff 75 d0             	pushl  -0x30(%ebp)
  802773:	e8 36 fb ff ff       	call   8022ae <set_block_data>
  802778:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80277b:	83 ec 0c             	sub    $0xc,%esp
  80277e:	ff 75 d0             	pushl  -0x30(%ebp)
  802781:	e8 1b 0a 00 00       	call   8031a1 <free_block>
  802786:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802789:	83 ec 0c             	sub    $0xc,%esp
  80278c:	ff 75 08             	pushl  0x8(%ebp)
  80278f:	e8 49 fb ff ff       	call   8022dd <alloc_block_FF>
  802794:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802797:	c9                   	leave  
  802798:	c3                   	ret    

00802799 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
  80279c:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	83 e0 01             	and    $0x1,%eax
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	74 03                	je     8027ac <alloc_block_BF+0x13>
  8027a9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027ac:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027b0:	77 07                	ja     8027b9 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027b2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027b9:	a1 24 50 80 00       	mov    0x805024,%eax
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	75 73                	jne    802835 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	83 c0 10             	add    $0x10,%eax
  8027c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027cb:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d8:	01 d0                	add    %edx,%eax
  8027da:	48                   	dec    %eax
  8027db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e6:	f7 75 e0             	divl   -0x20(%ebp)
  8027e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027ec:	29 d0                	sub    %edx,%eax
  8027ee:	c1 e8 0c             	shr    $0xc,%eax
  8027f1:	83 ec 0c             	sub    $0xc,%esp
  8027f4:	50                   	push   %eax
  8027f5:	e8 f5 eb ff ff       	call   8013ef <sbrk>
  8027fa:	83 c4 10             	add    $0x10,%esp
  8027fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802800:	83 ec 0c             	sub    $0xc,%esp
  802803:	6a 00                	push   $0x0
  802805:	e8 e5 eb ff ff       	call   8013ef <sbrk>
  80280a:	83 c4 10             	add    $0x10,%esp
  80280d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802810:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802813:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802816:	83 ec 08             	sub    $0x8,%esp
  802819:	50                   	push   %eax
  80281a:	ff 75 d8             	pushl  -0x28(%ebp)
  80281d:	e8 9f f8 ff ff       	call   8020c1 <initialize_dynamic_allocator>
  802822:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802825:	83 ec 0c             	sub    $0xc,%esp
  802828:	68 8f 45 80 00       	push   $0x80458f
  80282d:	e8 23 de ff ff       	call   800655 <cprintf>
  802832:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802835:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80283c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802843:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80284a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802851:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802856:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802859:	e9 1d 01 00 00       	jmp    80297b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802864:	83 ec 0c             	sub    $0xc,%esp
  802867:	ff 75 a8             	pushl  -0x58(%ebp)
  80286a:	e8 ee f6 ff ff       	call   801f5d <get_block_size>
  80286f:	83 c4 10             	add    $0x10,%esp
  802872:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	83 c0 08             	add    $0x8,%eax
  80287b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80287e:	0f 87 ef 00 00 00    	ja     802973 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	83 c0 18             	add    $0x18,%eax
  80288a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80288d:	77 1d                	ja     8028ac <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80288f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802892:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802895:	0f 86 d8 00 00 00    	jbe    802973 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80289b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80289e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028a1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028a7:	e9 c7 00 00 00       	jmp    802973 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	83 c0 08             	add    $0x8,%eax
  8028b2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028b5:	0f 85 9d 00 00 00    	jne    802958 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028bb:	83 ec 04             	sub    $0x4,%esp
  8028be:	6a 01                	push   $0x1
  8028c0:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028c3:	ff 75 a8             	pushl  -0x58(%ebp)
  8028c6:	e8 e3 f9 ff ff       	call   8022ae <set_block_data>
  8028cb:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d2:	75 17                	jne    8028eb <alloc_block_BF+0x152>
  8028d4:	83 ec 04             	sub    $0x4,%esp
  8028d7:	68 33 45 80 00       	push   $0x804533
  8028dc:	68 2c 01 00 00       	push   $0x12c
  8028e1:	68 51 45 80 00       	push   $0x804551
  8028e6:	e8 ad da ff ff       	call   800398 <_panic>
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	74 10                	je     802904 <alloc_block_BF+0x16b>
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fc:	8b 52 04             	mov    0x4(%edx),%edx
  8028ff:	89 50 04             	mov    %edx,0x4(%eax)
  802902:	eb 0b                	jmp    80290f <alloc_block_BF+0x176>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	a3 30 50 80 00       	mov    %eax,0x805030
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 40 04             	mov    0x4(%eax),%eax
  802915:	85 c0                	test   %eax,%eax
  802917:	74 0f                	je     802928 <alloc_block_BF+0x18f>
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802922:	8b 12                	mov    (%edx),%edx
  802924:	89 10                	mov    %edx,(%eax)
  802926:	eb 0a                	jmp    802932 <alloc_block_BF+0x199>
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 00                	mov    (%eax),%eax
  80292d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802945:	a1 38 50 80 00       	mov    0x805038,%eax
  80294a:	48                   	dec    %eax
  80294b:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802950:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802953:	e9 24 04 00 00       	jmp    802d7c <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802958:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80295e:	76 13                	jbe    802973 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802960:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802967:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80296a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80296d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802970:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802973:	a1 34 50 80 00       	mov    0x805034,%eax
  802978:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297f:	74 07                	je     802988 <alloc_block_BF+0x1ef>
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	eb 05                	jmp    80298d <alloc_block_BF+0x1f4>
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
  80298d:	a3 34 50 80 00       	mov    %eax,0x805034
  802992:	a1 34 50 80 00       	mov    0x805034,%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	0f 85 bf fe ff ff    	jne    80285e <alloc_block_BF+0xc5>
  80299f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a3:	0f 85 b5 fe ff ff    	jne    80285e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ad:	0f 84 26 02 00 00    	je     802bd9 <alloc_block_BF+0x440>
  8029b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029b7:	0f 85 1c 02 00 00    	jne    802bd9 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c0:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c3:	83 e8 08             	sub    $0x8,%eax
  8029c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	8d 50 08             	lea    0x8(%eax),%edx
  8029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d2:	01 d0                	add    %edx,%eax
  8029d4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	83 c0 08             	add    $0x8,%eax
  8029dd:	83 ec 04             	sub    $0x4,%esp
  8029e0:	6a 01                	push   $0x1
  8029e2:	50                   	push   %eax
  8029e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8029e6:	e8 c3 f8 ff ff       	call   8022ae <set_block_data>
  8029eb:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 40 04             	mov    0x4(%eax),%eax
  8029f4:	85 c0                	test   %eax,%eax
  8029f6:	75 68                	jne    802a60 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029f8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029fc:	75 17                	jne    802a15 <alloc_block_BF+0x27c>
  8029fe:	83 ec 04             	sub    $0x4,%esp
  802a01:	68 6c 45 80 00       	push   $0x80456c
  802a06:	68 45 01 00 00       	push   $0x145
  802a0b:	68 51 45 80 00       	push   $0x804551
  802a10:	e8 83 d9 ff ff       	call   800398 <_panic>
  802a15:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a1e:	89 10                	mov    %edx,(%eax)
  802a20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 0d                	je     802a36 <alloc_block_BF+0x29d>
  802a29:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a2e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a31:	89 50 04             	mov    %edx,0x4(%eax)
  802a34:	eb 08                	jmp    802a3e <alloc_block_BF+0x2a5>
  802a36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a39:	a3 30 50 80 00       	mov    %eax,0x805030
  802a3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a41:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a46:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a50:	a1 38 50 80 00       	mov    0x805038,%eax
  802a55:	40                   	inc    %eax
  802a56:	a3 38 50 80 00       	mov    %eax,0x805038
  802a5b:	e9 dc 00 00 00       	jmp    802b3c <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	75 65                	jne    802ace <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a69:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a6d:	75 17                	jne    802a86 <alloc_block_BF+0x2ed>
  802a6f:	83 ec 04             	sub    $0x4,%esp
  802a72:	68 a0 45 80 00       	push   $0x8045a0
  802a77:	68 4a 01 00 00       	push   $0x14a
  802a7c:	68 51 45 80 00       	push   $0x804551
  802a81:	e8 12 d9 ff ff       	call   800398 <_panic>
  802a86:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8f:	89 50 04             	mov    %edx,0x4(%eax)
  802a92:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a95:	8b 40 04             	mov    0x4(%eax),%eax
  802a98:	85 c0                	test   %eax,%eax
  802a9a:	74 0c                	je     802aa8 <alloc_block_BF+0x30f>
  802a9c:	a1 30 50 80 00       	mov    0x805030,%eax
  802aa1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aa4:	89 10                	mov    %edx,(%eax)
  802aa6:	eb 08                	jmp    802ab0 <alloc_block_BF+0x317>
  802aa8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ab0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab3:	a3 30 50 80 00       	mov    %eax,0x805030
  802ab8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ac6:	40                   	inc    %eax
  802ac7:	a3 38 50 80 00       	mov    %eax,0x805038
  802acc:	eb 6e                	jmp    802b3c <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ace:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad2:	74 06                	je     802ada <alloc_block_BF+0x341>
  802ad4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ad8:	75 17                	jne    802af1 <alloc_block_BF+0x358>
  802ada:	83 ec 04             	sub    $0x4,%esp
  802add:	68 c4 45 80 00       	push   $0x8045c4
  802ae2:	68 4f 01 00 00       	push   $0x14f
  802ae7:	68 51 45 80 00       	push   $0x804551
  802aec:	e8 a7 d8 ff ff       	call   800398 <_panic>
  802af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af4:	8b 10                	mov    (%eax),%edx
  802af6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af9:	89 10                	mov    %edx,(%eax)
  802afb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	85 c0                	test   %eax,%eax
  802b02:	74 0b                	je     802b0f <alloc_block_BF+0x376>
  802b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b12:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b15:	89 10                	mov    %edx,(%eax)
  802b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1d:	89 50 04             	mov    %edx,0x4(%eax)
  802b20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	85 c0                	test   %eax,%eax
  802b27:	75 08                	jne    802b31 <alloc_block_BF+0x398>
  802b29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2c:	a3 30 50 80 00       	mov    %eax,0x805030
  802b31:	a1 38 50 80 00       	mov    0x805038,%eax
  802b36:	40                   	inc    %eax
  802b37:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b40:	75 17                	jne    802b59 <alloc_block_BF+0x3c0>
  802b42:	83 ec 04             	sub    $0x4,%esp
  802b45:	68 33 45 80 00       	push   $0x804533
  802b4a:	68 51 01 00 00       	push   $0x151
  802b4f:	68 51 45 80 00       	push   $0x804551
  802b54:	e8 3f d8 ff ff       	call   800398 <_panic>
  802b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 10                	je     802b72 <alloc_block_BF+0x3d9>
  802b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6a:	8b 52 04             	mov    0x4(%edx),%edx
  802b6d:	89 50 04             	mov    %edx,0x4(%eax)
  802b70:	eb 0b                	jmp    802b7d <alloc_block_BF+0x3e4>
  802b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b75:	8b 40 04             	mov    0x4(%eax),%eax
  802b78:	a3 30 50 80 00       	mov    %eax,0x805030
  802b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b80:	8b 40 04             	mov    0x4(%eax),%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	74 0f                	je     802b96 <alloc_block_BF+0x3fd>
  802b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8a:	8b 40 04             	mov    0x4(%eax),%eax
  802b8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b90:	8b 12                	mov    (%edx),%edx
  802b92:	89 10                	mov    %edx,(%eax)
  802b94:	eb 0a                	jmp    802ba0 <alloc_block_BF+0x407>
  802b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b99:	8b 00                	mov    (%eax),%eax
  802b9b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb3:	a1 38 50 80 00       	mov    0x805038,%eax
  802bb8:	48                   	dec    %eax
  802bb9:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bbe:	83 ec 04             	sub    $0x4,%esp
  802bc1:	6a 00                	push   $0x0
  802bc3:	ff 75 d0             	pushl  -0x30(%ebp)
  802bc6:	ff 75 cc             	pushl  -0x34(%ebp)
  802bc9:	e8 e0 f6 ff ff       	call   8022ae <set_block_data>
  802bce:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd4:	e9 a3 01 00 00       	jmp    802d7c <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bd9:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bdd:	0f 85 9d 00 00 00    	jne    802c80 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802be3:	83 ec 04             	sub    $0x4,%esp
  802be6:	6a 01                	push   $0x1
  802be8:	ff 75 ec             	pushl  -0x14(%ebp)
  802beb:	ff 75 f0             	pushl  -0x10(%ebp)
  802bee:	e8 bb f6 ff ff       	call   8022ae <set_block_data>
  802bf3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bf6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bfa:	75 17                	jne    802c13 <alloc_block_BF+0x47a>
  802bfc:	83 ec 04             	sub    $0x4,%esp
  802bff:	68 33 45 80 00       	push   $0x804533
  802c04:	68 58 01 00 00       	push   $0x158
  802c09:	68 51 45 80 00       	push   $0x804551
  802c0e:	e8 85 d7 ff ff       	call   800398 <_panic>
  802c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c16:	8b 00                	mov    (%eax),%eax
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	74 10                	je     802c2c <alloc_block_BF+0x493>
  802c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1f:	8b 00                	mov    (%eax),%eax
  802c21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c24:	8b 52 04             	mov    0x4(%edx),%edx
  802c27:	89 50 04             	mov    %edx,0x4(%eax)
  802c2a:	eb 0b                	jmp    802c37 <alloc_block_BF+0x49e>
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	8b 40 04             	mov    0x4(%eax),%eax
  802c32:	a3 30 50 80 00       	mov    %eax,0x805030
  802c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3a:	8b 40 04             	mov    0x4(%eax),%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	74 0f                	je     802c50 <alloc_block_BF+0x4b7>
  802c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c44:	8b 40 04             	mov    0x4(%eax),%eax
  802c47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4a:	8b 12                	mov    (%edx),%edx
  802c4c:	89 10                	mov    %edx,(%eax)
  802c4e:	eb 0a                	jmp    802c5a <alloc_block_BF+0x4c1>
  802c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6d:	a1 38 50 80 00       	mov    0x805038,%eax
  802c72:	48                   	dec    %eax
  802c73:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7b:	e9 fc 00 00 00       	jmp    802d7c <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	83 c0 08             	add    $0x8,%eax
  802c86:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c89:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c90:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c93:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c96:	01 d0                	add    %edx,%eax
  802c98:	48                   	dec    %eax
  802c99:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c9c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca4:	f7 75 c4             	divl   -0x3c(%ebp)
  802ca7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802caa:	29 d0                	sub    %edx,%eax
  802cac:	c1 e8 0c             	shr    $0xc,%eax
  802caf:	83 ec 0c             	sub    $0xc,%esp
  802cb2:	50                   	push   %eax
  802cb3:	e8 37 e7 ff ff       	call   8013ef <sbrk>
  802cb8:	83 c4 10             	add    $0x10,%esp
  802cbb:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cbe:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cc2:	75 0a                	jne    802cce <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc9:	e9 ae 00 00 00       	jmp    802d7c <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cce:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cd5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cd8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cdb:	01 d0                	add    %edx,%eax
  802cdd:	48                   	dec    %eax
  802cde:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ce1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ce9:	f7 75 b8             	divl   -0x48(%ebp)
  802cec:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cef:	29 d0                	sub    %edx,%eax
  802cf1:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cf4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cf7:	01 d0                	add    %edx,%eax
  802cf9:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cfe:	a1 40 50 80 00       	mov    0x805040,%eax
  802d03:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d09:	83 ec 0c             	sub    $0xc,%esp
  802d0c:	68 f8 45 80 00       	push   $0x8045f8
  802d11:	e8 3f d9 ff ff       	call   800655 <cprintf>
  802d16:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d19:	83 ec 08             	sub    $0x8,%esp
  802d1c:	ff 75 bc             	pushl  -0x44(%ebp)
  802d1f:	68 fd 45 80 00       	push   $0x8045fd
  802d24:	e8 2c d9 ff ff       	call   800655 <cprintf>
  802d29:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d2c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d33:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d36:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d39:	01 d0                	add    %edx,%eax
  802d3b:	48                   	dec    %eax
  802d3c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d3f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d42:	ba 00 00 00 00       	mov    $0x0,%edx
  802d47:	f7 75 b0             	divl   -0x50(%ebp)
  802d4a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d4d:	29 d0                	sub    %edx,%eax
  802d4f:	83 ec 04             	sub    $0x4,%esp
  802d52:	6a 01                	push   $0x1
  802d54:	50                   	push   %eax
  802d55:	ff 75 bc             	pushl  -0x44(%ebp)
  802d58:	e8 51 f5 ff ff       	call   8022ae <set_block_data>
  802d5d:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d60:	83 ec 0c             	sub    $0xc,%esp
  802d63:	ff 75 bc             	pushl  -0x44(%ebp)
  802d66:	e8 36 04 00 00       	call   8031a1 <free_block>
  802d6b:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d6e:	83 ec 0c             	sub    $0xc,%esp
  802d71:	ff 75 08             	pushl  0x8(%ebp)
  802d74:	e8 20 fa ff ff       	call   802799 <alloc_block_BF>
  802d79:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d7c:	c9                   	leave  
  802d7d:	c3                   	ret    

00802d7e <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d7e:	55                   	push   %ebp
  802d7f:	89 e5                	mov    %esp,%ebp
  802d81:	53                   	push   %ebx
  802d82:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d97:	74 1e                	je     802db7 <merging+0x39>
  802d99:	ff 75 08             	pushl  0x8(%ebp)
  802d9c:	e8 bc f1 ff ff       	call   801f5d <get_block_size>
  802da1:	83 c4 04             	add    $0x4,%esp
  802da4:	89 c2                	mov    %eax,%edx
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	01 d0                	add    %edx,%eax
  802dab:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dae:	75 07                	jne    802db7 <merging+0x39>
		prev_is_free = 1;
  802db0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802db7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dbb:	74 1e                	je     802ddb <merging+0x5d>
  802dbd:	ff 75 10             	pushl  0x10(%ebp)
  802dc0:	e8 98 f1 ff ff       	call   801f5d <get_block_size>
  802dc5:	83 c4 04             	add    $0x4,%esp
  802dc8:	89 c2                	mov    %eax,%edx
  802dca:	8b 45 10             	mov    0x10(%ebp),%eax
  802dcd:	01 d0                	add    %edx,%eax
  802dcf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dd2:	75 07                	jne    802ddb <merging+0x5d>
		next_is_free = 1;
  802dd4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddf:	0f 84 cc 00 00 00    	je     802eb1 <merging+0x133>
  802de5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de9:	0f 84 c2 00 00 00    	je     802eb1 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802def:	ff 75 08             	pushl  0x8(%ebp)
  802df2:	e8 66 f1 ff ff       	call   801f5d <get_block_size>
  802df7:	83 c4 04             	add    $0x4,%esp
  802dfa:	89 c3                	mov    %eax,%ebx
  802dfc:	ff 75 10             	pushl  0x10(%ebp)
  802dff:	e8 59 f1 ff ff       	call   801f5d <get_block_size>
  802e04:	83 c4 04             	add    $0x4,%esp
  802e07:	01 c3                	add    %eax,%ebx
  802e09:	ff 75 0c             	pushl  0xc(%ebp)
  802e0c:	e8 4c f1 ff ff       	call   801f5d <get_block_size>
  802e11:	83 c4 04             	add    $0x4,%esp
  802e14:	01 d8                	add    %ebx,%eax
  802e16:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e19:	6a 00                	push   $0x0
  802e1b:	ff 75 ec             	pushl  -0x14(%ebp)
  802e1e:	ff 75 08             	pushl  0x8(%ebp)
  802e21:	e8 88 f4 ff ff       	call   8022ae <set_block_data>
  802e26:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e2d:	75 17                	jne    802e46 <merging+0xc8>
  802e2f:	83 ec 04             	sub    $0x4,%esp
  802e32:	68 33 45 80 00       	push   $0x804533
  802e37:	68 7d 01 00 00       	push   $0x17d
  802e3c:	68 51 45 80 00       	push   $0x804551
  802e41:	e8 52 d5 ff ff       	call   800398 <_panic>
  802e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 10                	je     802e5f <merging+0xe1>
  802e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e52:	8b 00                	mov    (%eax),%eax
  802e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e57:	8b 52 04             	mov    0x4(%edx),%edx
  802e5a:	89 50 04             	mov    %edx,0x4(%eax)
  802e5d:	eb 0b                	jmp    802e6a <merging+0xec>
  802e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e62:	8b 40 04             	mov    0x4(%eax),%eax
  802e65:	a3 30 50 80 00       	mov    %eax,0x805030
  802e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6d:	8b 40 04             	mov    0x4(%eax),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	74 0f                	je     802e83 <merging+0x105>
  802e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e7d:	8b 12                	mov    (%edx),%edx
  802e7f:	89 10                	mov    %edx,(%eax)
  802e81:	eb 0a                	jmp    802e8d <merging+0x10f>
  802e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea0:	a1 38 50 80 00       	mov    0x805038,%eax
  802ea5:	48                   	dec    %eax
  802ea6:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802eab:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eac:	e9 ea 02 00 00       	jmp    80319b <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb5:	74 3b                	je     802ef2 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802eb7:	83 ec 0c             	sub    $0xc,%esp
  802eba:	ff 75 08             	pushl  0x8(%ebp)
  802ebd:	e8 9b f0 ff ff       	call   801f5d <get_block_size>
  802ec2:	83 c4 10             	add    $0x10,%esp
  802ec5:	89 c3                	mov    %eax,%ebx
  802ec7:	83 ec 0c             	sub    $0xc,%esp
  802eca:	ff 75 10             	pushl  0x10(%ebp)
  802ecd:	e8 8b f0 ff ff       	call   801f5d <get_block_size>
  802ed2:	83 c4 10             	add    $0x10,%esp
  802ed5:	01 d8                	add    %ebx,%eax
  802ed7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802eda:	83 ec 04             	sub    $0x4,%esp
  802edd:	6a 00                	push   $0x0
  802edf:	ff 75 e8             	pushl  -0x18(%ebp)
  802ee2:	ff 75 08             	pushl  0x8(%ebp)
  802ee5:	e8 c4 f3 ff ff       	call   8022ae <set_block_data>
  802eea:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eed:	e9 a9 02 00 00       	jmp    80319b <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ef2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef6:	0f 84 2d 01 00 00    	je     803029 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802efc:	83 ec 0c             	sub    $0xc,%esp
  802eff:	ff 75 10             	pushl  0x10(%ebp)
  802f02:	e8 56 f0 ff ff       	call   801f5d <get_block_size>
  802f07:	83 c4 10             	add    $0x10,%esp
  802f0a:	89 c3                	mov    %eax,%ebx
  802f0c:	83 ec 0c             	sub    $0xc,%esp
  802f0f:	ff 75 0c             	pushl  0xc(%ebp)
  802f12:	e8 46 f0 ff ff       	call   801f5d <get_block_size>
  802f17:	83 c4 10             	add    $0x10,%esp
  802f1a:	01 d8                	add    %ebx,%eax
  802f1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f1f:	83 ec 04             	sub    $0x4,%esp
  802f22:	6a 00                	push   $0x0
  802f24:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f27:	ff 75 10             	pushl  0x10(%ebp)
  802f2a:	e8 7f f3 ff ff       	call   8022ae <set_block_data>
  802f2f:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f32:	8b 45 10             	mov    0x10(%ebp),%eax
  802f35:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f3c:	74 06                	je     802f44 <merging+0x1c6>
  802f3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f42:	75 17                	jne    802f5b <merging+0x1dd>
  802f44:	83 ec 04             	sub    $0x4,%esp
  802f47:	68 0c 46 80 00       	push   $0x80460c
  802f4c:	68 8d 01 00 00       	push   $0x18d
  802f51:	68 51 45 80 00       	push   $0x804551
  802f56:	e8 3d d4 ff ff       	call   800398 <_panic>
  802f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5e:	8b 50 04             	mov    0x4(%eax),%edx
  802f61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f64:	89 50 04             	mov    %edx,0x4(%eax)
  802f67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f6d:	89 10                	mov    %edx,(%eax)
  802f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f72:	8b 40 04             	mov    0x4(%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 0d                	je     802f86 <merging+0x208>
  802f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f82:	89 10                	mov    %edx,(%eax)
  802f84:	eb 08                	jmp    802f8e <merging+0x210>
  802f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f89:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f91:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f94:	89 50 04             	mov    %edx,0x4(%eax)
  802f97:	a1 38 50 80 00       	mov    0x805038,%eax
  802f9c:	40                   	inc    %eax
  802f9d:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fa2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fa6:	75 17                	jne    802fbf <merging+0x241>
  802fa8:	83 ec 04             	sub    $0x4,%esp
  802fab:	68 33 45 80 00       	push   $0x804533
  802fb0:	68 8e 01 00 00       	push   $0x18e
  802fb5:	68 51 45 80 00       	push   $0x804551
  802fba:	e8 d9 d3 ff ff       	call   800398 <_panic>
  802fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc2:	8b 00                	mov    (%eax),%eax
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	74 10                	je     802fd8 <merging+0x25a>
  802fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd0:	8b 52 04             	mov    0x4(%edx),%edx
  802fd3:	89 50 04             	mov    %edx,0x4(%eax)
  802fd6:	eb 0b                	jmp    802fe3 <merging+0x265>
  802fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdb:	8b 40 04             	mov    0x4(%eax),%eax
  802fde:	a3 30 50 80 00       	mov    %eax,0x805030
  802fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe6:	8b 40 04             	mov    0x4(%eax),%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	74 0f                	je     802ffc <merging+0x27e>
  802fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff0:	8b 40 04             	mov    0x4(%eax),%eax
  802ff3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff6:	8b 12                	mov    (%edx),%edx
  802ff8:	89 10                	mov    %edx,(%eax)
  802ffa:	eb 0a                	jmp    803006 <merging+0x288>
  802ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803006:	8b 45 0c             	mov    0xc(%ebp),%eax
  803009:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803012:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803019:	a1 38 50 80 00       	mov    0x805038,%eax
  80301e:	48                   	dec    %eax
  80301f:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803024:	e9 72 01 00 00       	jmp    80319b <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803029:	8b 45 10             	mov    0x10(%ebp),%eax
  80302c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80302f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803033:	74 79                	je     8030ae <merging+0x330>
  803035:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803039:	74 73                	je     8030ae <merging+0x330>
  80303b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303f:	74 06                	je     803047 <merging+0x2c9>
  803041:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803045:	75 17                	jne    80305e <merging+0x2e0>
  803047:	83 ec 04             	sub    $0x4,%esp
  80304a:	68 c4 45 80 00       	push   $0x8045c4
  80304f:	68 94 01 00 00       	push   $0x194
  803054:	68 51 45 80 00       	push   $0x804551
  803059:	e8 3a d3 ff ff       	call   800398 <_panic>
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	8b 10                	mov    (%eax),%edx
  803063:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803066:	89 10                	mov    %edx,(%eax)
  803068:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306b:	8b 00                	mov    (%eax),%eax
  80306d:	85 c0                	test   %eax,%eax
  80306f:	74 0b                	je     80307c <merging+0x2fe>
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	8b 00                	mov    (%eax),%eax
  803076:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803079:	89 50 04             	mov    %edx,0x4(%eax)
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803082:	89 10                	mov    %edx,(%eax)
  803084:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803087:	8b 55 08             	mov    0x8(%ebp),%edx
  80308a:	89 50 04             	mov    %edx,0x4(%eax)
  80308d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	85 c0                	test   %eax,%eax
  803094:	75 08                	jne    80309e <merging+0x320>
  803096:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803099:	a3 30 50 80 00       	mov    %eax,0x805030
  80309e:	a1 38 50 80 00       	mov    0x805038,%eax
  8030a3:	40                   	inc    %eax
  8030a4:	a3 38 50 80 00       	mov    %eax,0x805038
  8030a9:	e9 ce 00 00 00       	jmp    80317c <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b2:	74 65                	je     803119 <merging+0x39b>
  8030b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030b8:	75 17                	jne    8030d1 <merging+0x353>
  8030ba:	83 ec 04             	sub    $0x4,%esp
  8030bd:	68 a0 45 80 00       	push   $0x8045a0
  8030c2:	68 95 01 00 00       	push   $0x195
  8030c7:	68 51 45 80 00       	push   $0x804551
  8030cc:	e8 c7 d2 ff ff       	call   800398 <_panic>
  8030d1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030da:	89 50 04             	mov    %edx,0x4(%eax)
  8030dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e0:	8b 40 04             	mov    0x4(%eax),%eax
  8030e3:	85 c0                	test   %eax,%eax
  8030e5:	74 0c                	je     8030f3 <merging+0x375>
  8030e7:	a1 30 50 80 00       	mov    0x805030,%eax
  8030ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ef:	89 10                	mov    %edx,(%eax)
  8030f1:	eb 08                	jmp    8030fb <merging+0x37d>
  8030f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803103:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803106:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310c:	a1 38 50 80 00       	mov    0x805038,%eax
  803111:	40                   	inc    %eax
  803112:	a3 38 50 80 00       	mov    %eax,0x805038
  803117:	eb 63                	jmp    80317c <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803119:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80311d:	75 17                	jne    803136 <merging+0x3b8>
  80311f:	83 ec 04             	sub    $0x4,%esp
  803122:	68 6c 45 80 00       	push   $0x80456c
  803127:	68 98 01 00 00       	push   $0x198
  80312c:	68 51 45 80 00       	push   $0x804551
  803131:	e8 62 d2 ff ff       	call   800398 <_panic>
  803136:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80313c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313f:	89 10                	mov    %edx,(%eax)
  803141:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	74 0d                	je     803157 <merging+0x3d9>
  80314a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80314f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803152:	89 50 04             	mov    %edx,0x4(%eax)
  803155:	eb 08                	jmp    80315f <merging+0x3e1>
  803157:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315a:	a3 30 50 80 00       	mov    %eax,0x805030
  80315f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803162:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803167:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803171:	a1 38 50 80 00       	mov    0x805038,%eax
  803176:	40                   	inc    %eax
  803177:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80317c:	83 ec 0c             	sub    $0xc,%esp
  80317f:	ff 75 10             	pushl  0x10(%ebp)
  803182:	e8 d6 ed ff ff       	call   801f5d <get_block_size>
  803187:	83 c4 10             	add    $0x10,%esp
  80318a:	83 ec 04             	sub    $0x4,%esp
  80318d:	6a 00                	push   $0x0
  80318f:	50                   	push   %eax
  803190:	ff 75 10             	pushl  0x10(%ebp)
  803193:	e8 16 f1 ff ff       	call   8022ae <set_block_data>
  803198:	83 c4 10             	add    $0x10,%esp
	}
}
  80319b:	90                   	nop
  80319c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80319f:	c9                   	leave  
  8031a0:	c3                   	ret    

008031a1 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031a1:	55                   	push   %ebp
  8031a2:	89 e5                	mov    %esp,%ebp
  8031a4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031a7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031ac:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031af:	a1 30 50 80 00       	mov    0x805030,%eax
  8031b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031b7:	73 1b                	jae    8031d4 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031b9:	a1 30 50 80 00       	mov    0x805030,%eax
  8031be:	83 ec 04             	sub    $0x4,%esp
  8031c1:	ff 75 08             	pushl  0x8(%ebp)
  8031c4:	6a 00                	push   $0x0
  8031c6:	50                   	push   %eax
  8031c7:	e8 b2 fb ff ff       	call   802d7e <merging>
  8031cc:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031cf:	e9 8b 00 00 00       	jmp    80325f <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031d4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031dc:	76 18                	jbe    8031f6 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031de:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e3:	83 ec 04             	sub    $0x4,%esp
  8031e6:	ff 75 08             	pushl  0x8(%ebp)
  8031e9:	50                   	push   %eax
  8031ea:	6a 00                	push   $0x0
  8031ec:	e8 8d fb ff ff       	call   802d7e <merging>
  8031f1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031f4:	eb 69                	jmp    80325f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031f6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031fe:	eb 39                	jmp    803239 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803203:	3b 45 08             	cmp    0x8(%ebp),%eax
  803206:	73 29                	jae    803231 <free_block+0x90>
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	8b 00                	mov    (%eax),%eax
  80320d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803210:	76 1f                	jbe    803231 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803215:	8b 00                	mov    (%eax),%eax
  803217:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80321a:	83 ec 04             	sub    $0x4,%esp
  80321d:	ff 75 08             	pushl  0x8(%ebp)
  803220:	ff 75 f0             	pushl  -0x10(%ebp)
  803223:	ff 75 f4             	pushl  -0xc(%ebp)
  803226:	e8 53 fb ff ff       	call   802d7e <merging>
  80322b:	83 c4 10             	add    $0x10,%esp
			break;
  80322e:	90                   	nop
		}
	}
}
  80322f:	eb 2e                	jmp    80325f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803231:	a1 34 50 80 00       	mov    0x805034,%eax
  803236:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803239:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323d:	74 07                	je     803246 <free_block+0xa5>
  80323f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	eb 05                	jmp    80324b <free_block+0xaa>
  803246:	b8 00 00 00 00       	mov    $0x0,%eax
  80324b:	a3 34 50 80 00       	mov    %eax,0x805034
  803250:	a1 34 50 80 00       	mov    0x805034,%eax
  803255:	85 c0                	test   %eax,%eax
  803257:	75 a7                	jne    803200 <free_block+0x5f>
  803259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325d:	75 a1                	jne    803200 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80325f:	90                   	nop
  803260:	c9                   	leave  
  803261:	c3                   	ret    

00803262 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803262:	55                   	push   %ebp
  803263:	89 e5                	mov    %esp,%ebp
  803265:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803268:	ff 75 08             	pushl  0x8(%ebp)
  80326b:	e8 ed ec ff ff       	call   801f5d <get_block_size>
  803270:	83 c4 04             	add    $0x4,%esp
  803273:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803276:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80327d:	eb 17                	jmp    803296 <copy_data+0x34>
  80327f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803282:	8b 45 0c             	mov    0xc(%ebp),%eax
  803285:	01 c2                	add    %eax,%edx
  803287:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	01 c8                	add    %ecx,%eax
  80328f:	8a 00                	mov    (%eax),%al
  803291:	88 02                	mov    %al,(%edx)
  803293:	ff 45 fc             	incl   -0x4(%ebp)
  803296:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803299:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80329c:	72 e1                	jb     80327f <copy_data+0x1d>
}
  80329e:	90                   	nop
  80329f:	c9                   	leave  
  8032a0:	c3                   	ret    

008032a1 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032a1:	55                   	push   %ebp
  8032a2:	89 e5                	mov    %esp,%ebp
  8032a4:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ab:	75 23                	jne    8032d0 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032b1:	74 13                	je     8032c6 <realloc_block_FF+0x25>
  8032b3:	83 ec 0c             	sub    $0xc,%esp
  8032b6:	ff 75 0c             	pushl  0xc(%ebp)
  8032b9:	e8 1f f0 ff ff       	call   8022dd <alloc_block_FF>
  8032be:	83 c4 10             	add    $0x10,%esp
  8032c1:	e9 f4 06 00 00       	jmp    8039ba <realloc_block_FF+0x719>
		return NULL;
  8032c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cb:	e9 ea 06 00 00       	jmp    8039ba <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032d4:	75 18                	jne    8032ee <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032d6:	83 ec 0c             	sub    $0xc,%esp
  8032d9:	ff 75 08             	pushl  0x8(%ebp)
  8032dc:	e8 c0 fe ff ff       	call   8031a1 <free_block>
  8032e1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e9:	e9 cc 06 00 00       	jmp    8039ba <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032ee:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032f2:	77 07                	ja     8032fb <realloc_block_FF+0x5a>
  8032f4:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032fe:	83 e0 01             	and    $0x1,%eax
  803301:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803304:	8b 45 0c             	mov    0xc(%ebp),%eax
  803307:	83 c0 08             	add    $0x8,%eax
  80330a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80330d:	83 ec 0c             	sub    $0xc,%esp
  803310:	ff 75 08             	pushl  0x8(%ebp)
  803313:	e8 45 ec ff ff       	call   801f5d <get_block_size>
  803318:	83 c4 10             	add    $0x10,%esp
  80331b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80331e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803321:	83 e8 08             	sub    $0x8,%eax
  803324:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	83 e8 04             	sub    $0x4,%eax
  80332d:	8b 00                	mov    (%eax),%eax
  80332f:	83 e0 fe             	and    $0xfffffffe,%eax
  803332:	89 c2                	mov    %eax,%edx
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	01 d0                	add    %edx,%eax
  803339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80333c:	83 ec 0c             	sub    $0xc,%esp
  80333f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803342:	e8 16 ec ff ff       	call   801f5d <get_block_size>
  803347:	83 c4 10             	add    $0x10,%esp
  80334a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80334d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803350:	83 e8 08             	sub    $0x8,%eax
  803353:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803356:	8b 45 0c             	mov    0xc(%ebp),%eax
  803359:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80335c:	75 08                	jne    803366 <realloc_block_FF+0xc5>
	{
		 return va;
  80335e:	8b 45 08             	mov    0x8(%ebp),%eax
  803361:	e9 54 06 00 00       	jmp    8039ba <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803366:	8b 45 0c             	mov    0xc(%ebp),%eax
  803369:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80336c:	0f 83 e5 03 00 00    	jae    803757 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803375:	2b 45 0c             	sub    0xc(%ebp),%eax
  803378:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80337b:	83 ec 0c             	sub    $0xc,%esp
  80337e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803381:	e8 f0 eb ff ff       	call   801f76 <is_free_block>
  803386:	83 c4 10             	add    $0x10,%esp
  803389:	84 c0                	test   %al,%al
  80338b:	0f 84 3b 01 00 00    	je     8034cc <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803391:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803394:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803397:	01 d0                	add    %edx,%eax
  803399:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80339c:	83 ec 04             	sub    $0x4,%esp
  80339f:	6a 01                	push   $0x1
  8033a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8033a4:	ff 75 08             	pushl  0x8(%ebp)
  8033a7:	e8 02 ef ff ff       	call   8022ae <set_block_data>
  8033ac:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	83 e8 04             	sub    $0x4,%eax
  8033b5:	8b 00                	mov    (%eax),%eax
  8033b7:	83 e0 fe             	and    $0xfffffffe,%eax
  8033ba:	89 c2                	mov    %eax,%edx
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	01 d0                	add    %edx,%eax
  8033c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033c4:	83 ec 04             	sub    $0x4,%esp
  8033c7:	6a 00                	push   $0x0
  8033c9:	ff 75 cc             	pushl  -0x34(%ebp)
  8033cc:	ff 75 c8             	pushl  -0x38(%ebp)
  8033cf:	e8 da ee ff ff       	call   8022ae <set_block_data>
  8033d4:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033db:	74 06                	je     8033e3 <realloc_block_FF+0x142>
  8033dd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033e1:	75 17                	jne    8033fa <realloc_block_FF+0x159>
  8033e3:	83 ec 04             	sub    $0x4,%esp
  8033e6:	68 c4 45 80 00       	push   $0x8045c4
  8033eb:	68 f6 01 00 00       	push   $0x1f6
  8033f0:	68 51 45 80 00       	push   $0x804551
  8033f5:	e8 9e cf ff ff       	call   800398 <_panic>
  8033fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fd:	8b 10                	mov    (%eax),%edx
  8033ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803402:	89 10                	mov    %edx,(%eax)
  803404:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803407:	8b 00                	mov    (%eax),%eax
  803409:	85 c0                	test   %eax,%eax
  80340b:	74 0b                	je     803418 <realloc_block_FF+0x177>
  80340d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803415:	89 50 04             	mov    %edx,0x4(%eax)
  803418:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80341e:	89 10                	mov    %edx,(%eax)
  803420:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803423:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803426:	89 50 04             	mov    %edx,0x4(%eax)
  803429:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80342c:	8b 00                	mov    (%eax),%eax
  80342e:	85 c0                	test   %eax,%eax
  803430:	75 08                	jne    80343a <realloc_block_FF+0x199>
  803432:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803435:	a3 30 50 80 00       	mov    %eax,0x805030
  80343a:	a1 38 50 80 00       	mov    0x805038,%eax
  80343f:	40                   	inc    %eax
  803440:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803445:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803449:	75 17                	jne    803462 <realloc_block_FF+0x1c1>
  80344b:	83 ec 04             	sub    $0x4,%esp
  80344e:	68 33 45 80 00       	push   $0x804533
  803453:	68 f7 01 00 00       	push   $0x1f7
  803458:	68 51 45 80 00       	push   $0x804551
  80345d:	e8 36 cf ff ff       	call   800398 <_panic>
  803462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803465:	8b 00                	mov    (%eax),%eax
  803467:	85 c0                	test   %eax,%eax
  803469:	74 10                	je     80347b <realloc_block_FF+0x1da>
  80346b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346e:	8b 00                	mov    (%eax),%eax
  803470:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803473:	8b 52 04             	mov    0x4(%edx),%edx
  803476:	89 50 04             	mov    %edx,0x4(%eax)
  803479:	eb 0b                	jmp    803486 <realloc_block_FF+0x1e5>
  80347b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347e:	8b 40 04             	mov    0x4(%eax),%eax
  803481:	a3 30 50 80 00       	mov    %eax,0x805030
  803486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803489:	8b 40 04             	mov    0x4(%eax),%eax
  80348c:	85 c0                	test   %eax,%eax
  80348e:	74 0f                	je     80349f <realloc_block_FF+0x1fe>
  803490:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803493:	8b 40 04             	mov    0x4(%eax),%eax
  803496:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803499:	8b 12                	mov    (%edx),%edx
  80349b:	89 10                	mov    %edx,(%eax)
  80349d:	eb 0a                	jmp    8034a9 <realloc_block_FF+0x208>
  80349f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a2:	8b 00                	mov    (%eax),%eax
  8034a4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c1:	48                   	dec    %eax
  8034c2:	a3 38 50 80 00       	mov    %eax,0x805038
  8034c7:	e9 83 02 00 00       	jmp    80374f <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034cc:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034d0:	0f 86 69 02 00 00    	jbe    80373f <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034d6:	83 ec 04             	sub    $0x4,%esp
  8034d9:	6a 01                	push   $0x1
  8034db:	ff 75 f0             	pushl  -0x10(%ebp)
  8034de:	ff 75 08             	pushl  0x8(%ebp)
  8034e1:	e8 c8 ed ff ff       	call   8022ae <set_block_data>
  8034e6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	83 e8 04             	sub    $0x4,%eax
  8034ef:	8b 00                	mov    (%eax),%eax
  8034f1:	83 e0 fe             	and    $0xfffffffe,%eax
  8034f4:	89 c2                	mov    %eax,%edx
  8034f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f9:	01 d0                	add    %edx,%eax
  8034fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034fe:	a1 38 50 80 00       	mov    0x805038,%eax
  803503:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803506:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80350a:	75 68                	jne    803574 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80350c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803510:	75 17                	jne    803529 <realloc_block_FF+0x288>
  803512:	83 ec 04             	sub    $0x4,%esp
  803515:	68 6c 45 80 00       	push   $0x80456c
  80351a:	68 06 02 00 00       	push   $0x206
  80351f:	68 51 45 80 00       	push   $0x804551
  803524:	e8 6f ce ff ff       	call   800398 <_panic>
  803529:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80352f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803532:	89 10                	mov    %edx,(%eax)
  803534:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	85 c0                	test   %eax,%eax
  80353b:	74 0d                	je     80354a <realloc_block_FF+0x2a9>
  80353d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803542:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803545:	89 50 04             	mov    %edx,0x4(%eax)
  803548:	eb 08                	jmp    803552 <realloc_block_FF+0x2b1>
  80354a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354d:	a3 30 50 80 00       	mov    %eax,0x805030
  803552:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803555:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80355a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803564:	a1 38 50 80 00       	mov    0x805038,%eax
  803569:	40                   	inc    %eax
  80356a:	a3 38 50 80 00       	mov    %eax,0x805038
  80356f:	e9 b0 01 00 00       	jmp    803724 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803574:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803579:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80357c:	76 68                	jbe    8035e6 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80357e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803582:	75 17                	jne    80359b <realloc_block_FF+0x2fa>
  803584:	83 ec 04             	sub    $0x4,%esp
  803587:	68 6c 45 80 00       	push   $0x80456c
  80358c:	68 0b 02 00 00       	push   $0x20b
  803591:	68 51 45 80 00       	push   $0x804551
  803596:	e8 fd cd ff ff       	call   800398 <_panic>
  80359b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a4:	89 10                	mov    %edx,(%eax)
  8035a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a9:	8b 00                	mov    (%eax),%eax
  8035ab:	85 c0                	test   %eax,%eax
  8035ad:	74 0d                	je     8035bc <realloc_block_FF+0x31b>
  8035af:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035b7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ba:	eb 08                	jmp    8035c4 <realloc_block_FF+0x323>
  8035bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8035db:	40                   	inc    %eax
  8035dc:	a3 38 50 80 00       	mov    %eax,0x805038
  8035e1:	e9 3e 01 00 00       	jmp    803724 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035e6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035eb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ee:	73 68                	jae    803658 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035f0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035f4:	75 17                	jne    80360d <realloc_block_FF+0x36c>
  8035f6:	83 ec 04             	sub    $0x4,%esp
  8035f9:	68 a0 45 80 00       	push   $0x8045a0
  8035fe:	68 10 02 00 00       	push   $0x210
  803603:	68 51 45 80 00       	push   $0x804551
  803608:	e8 8b cd ff ff       	call   800398 <_panic>
  80360d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803613:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803616:	89 50 04             	mov    %edx,0x4(%eax)
  803619:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361c:	8b 40 04             	mov    0x4(%eax),%eax
  80361f:	85 c0                	test   %eax,%eax
  803621:	74 0c                	je     80362f <realloc_block_FF+0x38e>
  803623:	a1 30 50 80 00       	mov    0x805030,%eax
  803628:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80362b:	89 10                	mov    %edx,(%eax)
  80362d:	eb 08                	jmp    803637 <realloc_block_FF+0x396>
  80362f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803632:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803637:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363a:	a3 30 50 80 00       	mov    %eax,0x805030
  80363f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803642:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803648:	a1 38 50 80 00       	mov    0x805038,%eax
  80364d:	40                   	inc    %eax
  80364e:	a3 38 50 80 00       	mov    %eax,0x805038
  803653:	e9 cc 00 00 00       	jmp    803724 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803658:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80365f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803664:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803667:	e9 8a 00 00 00       	jmp    8036f6 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80366c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803672:	73 7a                	jae    8036ee <realloc_block_FF+0x44d>
  803674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803677:	8b 00                	mov    (%eax),%eax
  803679:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80367c:	73 70                	jae    8036ee <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80367e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803682:	74 06                	je     80368a <realloc_block_FF+0x3e9>
  803684:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803688:	75 17                	jne    8036a1 <realloc_block_FF+0x400>
  80368a:	83 ec 04             	sub    $0x4,%esp
  80368d:	68 c4 45 80 00       	push   $0x8045c4
  803692:	68 1a 02 00 00       	push   $0x21a
  803697:	68 51 45 80 00       	push   $0x804551
  80369c:	e8 f7 cc ff ff       	call   800398 <_panic>
  8036a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a4:	8b 10                	mov    (%eax),%edx
  8036a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a9:	89 10                	mov    %edx,(%eax)
  8036ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ae:	8b 00                	mov    (%eax),%eax
  8036b0:	85 c0                	test   %eax,%eax
  8036b2:	74 0b                	je     8036bf <realloc_block_FF+0x41e>
  8036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b7:	8b 00                	mov    (%eax),%eax
  8036b9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036bc:	89 50 04             	mov    %edx,0x4(%eax)
  8036bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036c5:	89 10                	mov    %edx,(%eax)
  8036c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036cd:	89 50 04             	mov    %edx,0x4(%eax)
  8036d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d3:	8b 00                	mov    (%eax),%eax
  8036d5:	85 c0                	test   %eax,%eax
  8036d7:	75 08                	jne    8036e1 <realloc_block_FF+0x440>
  8036d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036dc:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e1:	a1 38 50 80 00       	mov    0x805038,%eax
  8036e6:	40                   	inc    %eax
  8036e7:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036ec:	eb 36                	jmp    803724 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036ee:	a1 34 50 80 00       	mov    0x805034,%eax
  8036f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036fa:	74 07                	je     803703 <realloc_block_FF+0x462>
  8036fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ff:	8b 00                	mov    (%eax),%eax
  803701:	eb 05                	jmp    803708 <realloc_block_FF+0x467>
  803703:	b8 00 00 00 00       	mov    $0x0,%eax
  803708:	a3 34 50 80 00       	mov    %eax,0x805034
  80370d:	a1 34 50 80 00       	mov    0x805034,%eax
  803712:	85 c0                	test   %eax,%eax
  803714:	0f 85 52 ff ff ff    	jne    80366c <realloc_block_FF+0x3cb>
  80371a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80371e:	0f 85 48 ff ff ff    	jne    80366c <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803724:	83 ec 04             	sub    $0x4,%esp
  803727:	6a 00                	push   $0x0
  803729:	ff 75 d8             	pushl  -0x28(%ebp)
  80372c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80372f:	e8 7a eb ff ff       	call   8022ae <set_block_data>
  803734:	83 c4 10             	add    $0x10,%esp
				return va;
  803737:	8b 45 08             	mov    0x8(%ebp),%eax
  80373a:	e9 7b 02 00 00       	jmp    8039ba <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80373f:	83 ec 0c             	sub    $0xc,%esp
  803742:	68 41 46 80 00       	push   $0x804641
  803747:	e8 09 cf ff ff       	call   800655 <cprintf>
  80374c:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80374f:	8b 45 08             	mov    0x8(%ebp),%eax
  803752:	e9 63 02 00 00       	jmp    8039ba <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80375a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80375d:	0f 86 4d 02 00 00    	jbe    8039b0 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803763:	83 ec 0c             	sub    $0xc,%esp
  803766:	ff 75 e4             	pushl  -0x1c(%ebp)
  803769:	e8 08 e8 ff ff       	call   801f76 <is_free_block>
  80376e:	83 c4 10             	add    $0x10,%esp
  803771:	84 c0                	test   %al,%al
  803773:	0f 84 37 02 00 00    	je     8039b0 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80377c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80377f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803782:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803785:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803788:	76 38                	jbe    8037c2 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80378a:	83 ec 0c             	sub    $0xc,%esp
  80378d:	ff 75 08             	pushl  0x8(%ebp)
  803790:	e8 0c fa ff ff       	call   8031a1 <free_block>
  803795:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803798:	83 ec 0c             	sub    $0xc,%esp
  80379b:	ff 75 0c             	pushl  0xc(%ebp)
  80379e:	e8 3a eb ff ff       	call   8022dd <alloc_block_FF>
  8037a3:	83 c4 10             	add    $0x10,%esp
  8037a6:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037a9:	83 ec 08             	sub    $0x8,%esp
  8037ac:	ff 75 c0             	pushl  -0x40(%ebp)
  8037af:	ff 75 08             	pushl  0x8(%ebp)
  8037b2:	e8 ab fa ff ff       	call   803262 <copy_data>
  8037b7:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037ba:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037bd:	e9 f8 01 00 00       	jmp    8039ba <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037cb:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037cf:	0f 87 a0 00 00 00    	ja     803875 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037d9:	75 17                	jne    8037f2 <realloc_block_FF+0x551>
  8037db:	83 ec 04             	sub    $0x4,%esp
  8037de:	68 33 45 80 00       	push   $0x804533
  8037e3:	68 38 02 00 00       	push   $0x238
  8037e8:	68 51 45 80 00       	push   $0x804551
  8037ed:	e8 a6 cb ff ff       	call   800398 <_panic>
  8037f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	85 c0                	test   %eax,%eax
  8037f9:	74 10                	je     80380b <realloc_block_FF+0x56a>
  8037fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fe:	8b 00                	mov    (%eax),%eax
  803800:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803803:	8b 52 04             	mov    0x4(%edx),%edx
  803806:	89 50 04             	mov    %edx,0x4(%eax)
  803809:	eb 0b                	jmp    803816 <realloc_block_FF+0x575>
  80380b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380e:	8b 40 04             	mov    0x4(%eax),%eax
  803811:	a3 30 50 80 00       	mov    %eax,0x805030
  803816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803819:	8b 40 04             	mov    0x4(%eax),%eax
  80381c:	85 c0                	test   %eax,%eax
  80381e:	74 0f                	je     80382f <realloc_block_FF+0x58e>
  803820:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803823:	8b 40 04             	mov    0x4(%eax),%eax
  803826:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803829:	8b 12                	mov    (%edx),%edx
  80382b:	89 10                	mov    %edx,(%eax)
  80382d:	eb 0a                	jmp    803839 <realloc_block_FF+0x598>
  80382f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803832:	8b 00                	mov    (%eax),%eax
  803834:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803839:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803845:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80384c:	a1 38 50 80 00       	mov    0x805038,%eax
  803851:	48                   	dec    %eax
  803852:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803857:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80385a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80385d:	01 d0                	add    %edx,%eax
  80385f:	83 ec 04             	sub    $0x4,%esp
  803862:	6a 01                	push   $0x1
  803864:	50                   	push   %eax
  803865:	ff 75 08             	pushl  0x8(%ebp)
  803868:	e8 41 ea ff ff       	call   8022ae <set_block_data>
  80386d:	83 c4 10             	add    $0x10,%esp
  803870:	e9 36 01 00 00       	jmp    8039ab <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803875:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803878:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80387b:	01 d0                	add    %edx,%eax
  80387d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803880:	83 ec 04             	sub    $0x4,%esp
  803883:	6a 01                	push   $0x1
  803885:	ff 75 f0             	pushl  -0x10(%ebp)
  803888:	ff 75 08             	pushl  0x8(%ebp)
  80388b:	e8 1e ea ff ff       	call   8022ae <set_block_data>
  803890:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803893:	8b 45 08             	mov    0x8(%ebp),%eax
  803896:	83 e8 04             	sub    $0x4,%eax
  803899:	8b 00                	mov    (%eax),%eax
  80389b:	83 e0 fe             	and    $0xfffffffe,%eax
  80389e:	89 c2                	mov    %eax,%edx
  8038a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a3:	01 d0                	add    %edx,%eax
  8038a5:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ac:	74 06                	je     8038b4 <realloc_block_FF+0x613>
  8038ae:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038b2:	75 17                	jne    8038cb <realloc_block_FF+0x62a>
  8038b4:	83 ec 04             	sub    $0x4,%esp
  8038b7:	68 c4 45 80 00       	push   $0x8045c4
  8038bc:	68 44 02 00 00       	push   $0x244
  8038c1:	68 51 45 80 00       	push   $0x804551
  8038c6:	e8 cd ca ff ff       	call   800398 <_panic>
  8038cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ce:	8b 10                	mov    (%eax),%edx
  8038d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038d3:	89 10                	mov    %edx,(%eax)
  8038d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038d8:	8b 00                	mov    (%eax),%eax
  8038da:	85 c0                	test   %eax,%eax
  8038dc:	74 0b                	je     8038e9 <realloc_block_FF+0x648>
  8038de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e1:	8b 00                	mov    (%eax),%eax
  8038e3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038e6:	89 50 04             	mov    %edx,0x4(%eax)
  8038e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ec:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038ef:	89 10                	mov    %edx,(%eax)
  8038f1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f7:	89 50 04             	mov    %edx,0x4(%eax)
  8038fa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038fd:	8b 00                	mov    (%eax),%eax
  8038ff:	85 c0                	test   %eax,%eax
  803901:	75 08                	jne    80390b <realloc_block_FF+0x66a>
  803903:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803906:	a3 30 50 80 00       	mov    %eax,0x805030
  80390b:	a1 38 50 80 00       	mov    0x805038,%eax
  803910:	40                   	inc    %eax
  803911:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803916:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80391a:	75 17                	jne    803933 <realloc_block_FF+0x692>
  80391c:	83 ec 04             	sub    $0x4,%esp
  80391f:	68 33 45 80 00       	push   $0x804533
  803924:	68 45 02 00 00       	push   $0x245
  803929:	68 51 45 80 00       	push   $0x804551
  80392e:	e8 65 ca ff ff       	call   800398 <_panic>
  803933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803936:	8b 00                	mov    (%eax),%eax
  803938:	85 c0                	test   %eax,%eax
  80393a:	74 10                	je     80394c <realloc_block_FF+0x6ab>
  80393c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393f:	8b 00                	mov    (%eax),%eax
  803941:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803944:	8b 52 04             	mov    0x4(%edx),%edx
  803947:	89 50 04             	mov    %edx,0x4(%eax)
  80394a:	eb 0b                	jmp    803957 <realloc_block_FF+0x6b6>
  80394c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394f:	8b 40 04             	mov    0x4(%eax),%eax
  803952:	a3 30 50 80 00       	mov    %eax,0x805030
  803957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395a:	8b 40 04             	mov    0x4(%eax),%eax
  80395d:	85 c0                	test   %eax,%eax
  80395f:	74 0f                	je     803970 <realloc_block_FF+0x6cf>
  803961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803964:	8b 40 04             	mov    0x4(%eax),%eax
  803967:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80396a:	8b 12                	mov    (%edx),%edx
  80396c:	89 10                	mov    %edx,(%eax)
  80396e:	eb 0a                	jmp    80397a <realloc_block_FF+0x6d9>
  803970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803973:	8b 00                	mov    (%eax),%eax
  803975:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80397a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803983:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803986:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80398d:	a1 38 50 80 00       	mov    0x805038,%eax
  803992:	48                   	dec    %eax
  803993:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803998:	83 ec 04             	sub    $0x4,%esp
  80399b:	6a 00                	push   $0x0
  80399d:	ff 75 bc             	pushl  -0x44(%ebp)
  8039a0:	ff 75 b8             	pushl  -0x48(%ebp)
  8039a3:	e8 06 e9 ff ff       	call   8022ae <set_block_data>
  8039a8:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ae:	eb 0a                	jmp    8039ba <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039b0:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039ba:	c9                   	leave  
  8039bb:	c3                   	ret    

008039bc <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039bc:	55                   	push   %ebp
  8039bd:	89 e5                	mov    %esp,%ebp
  8039bf:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039c2:	83 ec 04             	sub    $0x4,%esp
  8039c5:	68 48 46 80 00       	push   $0x804648
  8039ca:	68 58 02 00 00       	push   $0x258
  8039cf:	68 51 45 80 00       	push   $0x804551
  8039d4:	e8 bf c9 ff ff       	call   800398 <_panic>

008039d9 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039d9:	55                   	push   %ebp
  8039da:	89 e5                	mov    %esp,%ebp
  8039dc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039df:	83 ec 04             	sub    $0x4,%esp
  8039e2:	68 70 46 80 00       	push   $0x804670
  8039e7:	68 61 02 00 00       	push   $0x261
  8039ec:	68 51 45 80 00       	push   $0x804551
  8039f1:	e8 a2 c9 ff ff       	call   800398 <_panic>
  8039f6:	66 90                	xchg   %ax,%ax

008039f8 <__udivdi3>:
  8039f8:	55                   	push   %ebp
  8039f9:	57                   	push   %edi
  8039fa:	56                   	push   %esi
  8039fb:	53                   	push   %ebx
  8039fc:	83 ec 1c             	sub    $0x1c,%esp
  8039ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a0f:	89 ca                	mov    %ecx,%edx
  803a11:	89 f8                	mov    %edi,%eax
  803a13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a17:	85 f6                	test   %esi,%esi
  803a19:	75 2d                	jne    803a48 <__udivdi3+0x50>
  803a1b:	39 cf                	cmp    %ecx,%edi
  803a1d:	77 65                	ja     803a84 <__udivdi3+0x8c>
  803a1f:	89 fd                	mov    %edi,%ebp
  803a21:	85 ff                	test   %edi,%edi
  803a23:	75 0b                	jne    803a30 <__udivdi3+0x38>
  803a25:	b8 01 00 00 00       	mov    $0x1,%eax
  803a2a:	31 d2                	xor    %edx,%edx
  803a2c:	f7 f7                	div    %edi
  803a2e:	89 c5                	mov    %eax,%ebp
  803a30:	31 d2                	xor    %edx,%edx
  803a32:	89 c8                	mov    %ecx,%eax
  803a34:	f7 f5                	div    %ebp
  803a36:	89 c1                	mov    %eax,%ecx
  803a38:	89 d8                	mov    %ebx,%eax
  803a3a:	f7 f5                	div    %ebp
  803a3c:	89 cf                	mov    %ecx,%edi
  803a3e:	89 fa                	mov    %edi,%edx
  803a40:	83 c4 1c             	add    $0x1c,%esp
  803a43:	5b                   	pop    %ebx
  803a44:	5e                   	pop    %esi
  803a45:	5f                   	pop    %edi
  803a46:	5d                   	pop    %ebp
  803a47:	c3                   	ret    
  803a48:	39 ce                	cmp    %ecx,%esi
  803a4a:	77 28                	ja     803a74 <__udivdi3+0x7c>
  803a4c:	0f bd fe             	bsr    %esi,%edi
  803a4f:	83 f7 1f             	xor    $0x1f,%edi
  803a52:	75 40                	jne    803a94 <__udivdi3+0x9c>
  803a54:	39 ce                	cmp    %ecx,%esi
  803a56:	72 0a                	jb     803a62 <__udivdi3+0x6a>
  803a58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a5c:	0f 87 9e 00 00 00    	ja     803b00 <__udivdi3+0x108>
  803a62:	b8 01 00 00 00       	mov    $0x1,%eax
  803a67:	89 fa                	mov    %edi,%edx
  803a69:	83 c4 1c             	add    $0x1c,%esp
  803a6c:	5b                   	pop    %ebx
  803a6d:	5e                   	pop    %esi
  803a6e:	5f                   	pop    %edi
  803a6f:	5d                   	pop    %ebp
  803a70:	c3                   	ret    
  803a71:	8d 76 00             	lea    0x0(%esi),%esi
  803a74:	31 ff                	xor    %edi,%edi
  803a76:	31 c0                	xor    %eax,%eax
  803a78:	89 fa                	mov    %edi,%edx
  803a7a:	83 c4 1c             	add    $0x1c,%esp
  803a7d:	5b                   	pop    %ebx
  803a7e:	5e                   	pop    %esi
  803a7f:	5f                   	pop    %edi
  803a80:	5d                   	pop    %ebp
  803a81:	c3                   	ret    
  803a82:	66 90                	xchg   %ax,%ax
  803a84:	89 d8                	mov    %ebx,%eax
  803a86:	f7 f7                	div    %edi
  803a88:	31 ff                	xor    %edi,%edi
  803a8a:	89 fa                	mov    %edi,%edx
  803a8c:	83 c4 1c             	add    $0x1c,%esp
  803a8f:	5b                   	pop    %ebx
  803a90:	5e                   	pop    %esi
  803a91:	5f                   	pop    %edi
  803a92:	5d                   	pop    %ebp
  803a93:	c3                   	ret    
  803a94:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a99:	89 eb                	mov    %ebp,%ebx
  803a9b:	29 fb                	sub    %edi,%ebx
  803a9d:	89 f9                	mov    %edi,%ecx
  803a9f:	d3 e6                	shl    %cl,%esi
  803aa1:	89 c5                	mov    %eax,%ebp
  803aa3:	88 d9                	mov    %bl,%cl
  803aa5:	d3 ed                	shr    %cl,%ebp
  803aa7:	89 e9                	mov    %ebp,%ecx
  803aa9:	09 f1                	or     %esi,%ecx
  803aab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803aaf:	89 f9                	mov    %edi,%ecx
  803ab1:	d3 e0                	shl    %cl,%eax
  803ab3:	89 c5                	mov    %eax,%ebp
  803ab5:	89 d6                	mov    %edx,%esi
  803ab7:	88 d9                	mov    %bl,%cl
  803ab9:	d3 ee                	shr    %cl,%esi
  803abb:	89 f9                	mov    %edi,%ecx
  803abd:	d3 e2                	shl    %cl,%edx
  803abf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ac3:	88 d9                	mov    %bl,%cl
  803ac5:	d3 e8                	shr    %cl,%eax
  803ac7:	09 c2                	or     %eax,%edx
  803ac9:	89 d0                	mov    %edx,%eax
  803acb:	89 f2                	mov    %esi,%edx
  803acd:	f7 74 24 0c          	divl   0xc(%esp)
  803ad1:	89 d6                	mov    %edx,%esi
  803ad3:	89 c3                	mov    %eax,%ebx
  803ad5:	f7 e5                	mul    %ebp
  803ad7:	39 d6                	cmp    %edx,%esi
  803ad9:	72 19                	jb     803af4 <__udivdi3+0xfc>
  803adb:	74 0b                	je     803ae8 <__udivdi3+0xf0>
  803add:	89 d8                	mov    %ebx,%eax
  803adf:	31 ff                	xor    %edi,%edi
  803ae1:	e9 58 ff ff ff       	jmp    803a3e <__udivdi3+0x46>
  803ae6:	66 90                	xchg   %ax,%ax
  803ae8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803aec:	89 f9                	mov    %edi,%ecx
  803aee:	d3 e2                	shl    %cl,%edx
  803af0:	39 c2                	cmp    %eax,%edx
  803af2:	73 e9                	jae    803add <__udivdi3+0xe5>
  803af4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803af7:	31 ff                	xor    %edi,%edi
  803af9:	e9 40 ff ff ff       	jmp    803a3e <__udivdi3+0x46>
  803afe:	66 90                	xchg   %ax,%ax
  803b00:	31 c0                	xor    %eax,%eax
  803b02:	e9 37 ff ff ff       	jmp    803a3e <__udivdi3+0x46>
  803b07:	90                   	nop

00803b08 <__umoddi3>:
  803b08:	55                   	push   %ebp
  803b09:	57                   	push   %edi
  803b0a:	56                   	push   %esi
  803b0b:	53                   	push   %ebx
  803b0c:	83 ec 1c             	sub    $0x1c,%esp
  803b0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b13:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b27:	89 f3                	mov    %esi,%ebx
  803b29:	89 fa                	mov    %edi,%edx
  803b2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b2f:	89 34 24             	mov    %esi,(%esp)
  803b32:	85 c0                	test   %eax,%eax
  803b34:	75 1a                	jne    803b50 <__umoddi3+0x48>
  803b36:	39 f7                	cmp    %esi,%edi
  803b38:	0f 86 a2 00 00 00    	jbe    803be0 <__umoddi3+0xd8>
  803b3e:	89 c8                	mov    %ecx,%eax
  803b40:	89 f2                	mov    %esi,%edx
  803b42:	f7 f7                	div    %edi
  803b44:	89 d0                	mov    %edx,%eax
  803b46:	31 d2                	xor    %edx,%edx
  803b48:	83 c4 1c             	add    $0x1c,%esp
  803b4b:	5b                   	pop    %ebx
  803b4c:	5e                   	pop    %esi
  803b4d:	5f                   	pop    %edi
  803b4e:	5d                   	pop    %ebp
  803b4f:	c3                   	ret    
  803b50:	39 f0                	cmp    %esi,%eax
  803b52:	0f 87 ac 00 00 00    	ja     803c04 <__umoddi3+0xfc>
  803b58:	0f bd e8             	bsr    %eax,%ebp
  803b5b:	83 f5 1f             	xor    $0x1f,%ebp
  803b5e:	0f 84 ac 00 00 00    	je     803c10 <__umoddi3+0x108>
  803b64:	bf 20 00 00 00       	mov    $0x20,%edi
  803b69:	29 ef                	sub    %ebp,%edi
  803b6b:	89 fe                	mov    %edi,%esi
  803b6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b71:	89 e9                	mov    %ebp,%ecx
  803b73:	d3 e0                	shl    %cl,%eax
  803b75:	89 d7                	mov    %edx,%edi
  803b77:	89 f1                	mov    %esi,%ecx
  803b79:	d3 ef                	shr    %cl,%edi
  803b7b:	09 c7                	or     %eax,%edi
  803b7d:	89 e9                	mov    %ebp,%ecx
  803b7f:	d3 e2                	shl    %cl,%edx
  803b81:	89 14 24             	mov    %edx,(%esp)
  803b84:	89 d8                	mov    %ebx,%eax
  803b86:	d3 e0                	shl    %cl,%eax
  803b88:	89 c2                	mov    %eax,%edx
  803b8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b8e:	d3 e0                	shl    %cl,%eax
  803b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b94:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b98:	89 f1                	mov    %esi,%ecx
  803b9a:	d3 e8                	shr    %cl,%eax
  803b9c:	09 d0                	or     %edx,%eax
  803b9e:	d3 eb                	shr    %cl,%ebx
  803ba0:	89 da                	mov    %ebx,%edx
  803ba2:	f7 f7                	div    %edi
  803ba4:	89 d3                	mov    %edx,%ebx
  803ba6:	f7 24 24             	mull   (%esp)
  803ba9:	89 c6                	mov    %eax,%esi
  803bab:	89 d1                	mov    %edx,%ecx
  803bad:	39 d3                	cmp    %edx,%ebx
  803baf:	0f 82 87 00 00 00    	jb     803c3c <__umoddi3+0x134>
  803bb5:	0f 84 91 00 00 00    	je     803c4c <__umoddi3+0x144>
  803bbb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bbf:	29 f2                	sub    %esi,%edx
  803bc1:	19 cb                	sbb    %ecx,%ebx
  803bc3:	89 d8                	mov    %ebx,%eax
  803bc5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bc9:	d3 e0                	shl    %cl,%eax
  803bcb:	89 e9                	mov    %ebp,%ecx
  803bcd:	d3 ea                	shr    %cl,%edx
  803bcf:	09 d0                	or     %edx,%eax
  803bd1:	89 e9                	mov    %ebp,%ecx
  803bd3:	d3 eb                	shr    %cl,%ebx
  803bd5:	89 da                	mov    %ebx,%edx
  803bd7:	83 c4 1c             	add    $0x1c,%esp
  803bda:	5b                   	pop    %ebx
  803bdb:	5e                   	pop    %esi
  803bdc:	5f                   	pop    %edi
  803bdd:	5d                   	pop    %ebp
  803bde:	c3                   	ret    
  803bdf:	90                   	nop
  803be0:	89 fd                	mov    %edi,%ebp
  803be2:	85 ff                	test   %edi,%edi
  803be4:	75 0b                	jne    803bf1 <__umoddi3+0xe9>
  803be6:	b8 01 00 00 00       	mov    $0x1,%eax
  803beb:	31 d2                	xor    %edx,%edx
  803bed:	f7 f7                	div    %edi
  803bef:	89 c5                	mov    %eax,%ebp
  803bf1:	89 f0                	mov    %esi,%eax
  803bf3:	31 d2                	xor    %edx,%edx
  803bf5:	f7 f5                	div    %ebp
  803bf7:	89 c8                	mov    %ecx,%eax
  803bf9:	f7 f5                	div    %ebp
  803bfb:	89 d0                	mov    %edx,%eax
  803bfd:	e9 44 ff ff ff       	jmp    803b46 <__umoddi3+0x3e>
  803c02:	66 90                	xchg   %ax,%ax
  803c04:	89 c8                	mov    %ecx,%eax
  803c06:	89 f2                	mov    %esi,%edx
  803c08:	83 c4 1c             	add    $0x1c,%esp
  803c0b:	5b                   	pop    %ebx
  803c0c:	5e                   	pop    %esi
  803c0d:	5f                   	pop    %edi
  803c0e:	5d                   	pop    %ebp
  803c0f:	c3                   	ret    
  803c10:	3b 04 24             	cmp    (%esp),%eax
  803c13:	72 06                	jb     803c1b <__umoddi3+0x113>
  803c15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c19:	77 0f                	ja     803c2a <__umoddi3+0x122>
  803c1b:	89 f2                	mov    %esi,%edx
  803c1d:	29 f9                	sub    %edi,%ecx
  803c1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c23:	89 14 24             	mov    %edx,(%esp)
  803c26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c2e:	8b 14 24             	mov    (%esp),%edx
  803c31:	83 c4 1c             	add    $0x1c,%esp
  803c34:	5b                   	pop    %ebx
  803c35:	5e                   	pop    %esi
  803c36:	5f                   	pop    %edi
  803c37:	5d                   	pop    %ebp
  803c38:	c3                   	ret    
  803c39:	8d 76 00             	lea    0x0(%esi),%esi
  803c3c:	2b 04 24             	sub    (%esp),%eax
  803c3f:	19 fa                	sbb    %edi,%edx
  803c41:	89 d1                	mov    %edx,%ecx
  803c43:	89 c6                	mov    %eax,%esi
  803c45:	e9 71 ff ff ff       	jmp    803bbb <__umoddi3+0xb3>
  803c4a:	66 90                	xchg   %ax,%ax
  803c4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c50:	72 ea                	jb     803c3c <__umoddi3+0x134>
  803c52:	89 d9                	mov    %ebx,%ecx
  803c54:	e9 62 ff ff ff       	jmp    803bbb <__umoddi3+0xb3>
