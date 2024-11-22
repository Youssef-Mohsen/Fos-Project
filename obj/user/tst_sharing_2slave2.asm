
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
  80005c:	68 00 3c 80 00       	push   $0x803c00
  800061:	6a 0d                	push   $0xd
  800063:	68 1c 3c 80 00       	push   $0x803c1c
  800068:	e8 2b 03 00 00       	call   800398 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  800074:	e8 50 1b 00 00       	call   801bc9 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int freeFrames, diff, expected;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 b3 18 00 00       	call   801934 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 61 19 00 00       	call   8019e7 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 37 3c 80 00       	push   $0x803c37
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
  8000b6:	68 3c 3c 80 00       	push   $0x803c3c
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 1c 3c 80 00       	push   $0x803c1c
  8000c2:	e8 d1 02 00 00       	call   800398 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 11 19 00 00       	call   8019e7 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 fa 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 b8 3c 80 00       	push   $0x803cb8
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 1c 3c 80 00       	push   $0x803c1c
  800104:	e8 8f 02 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 40 18 00 00       	call   80194e <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 21 18 00 00       	call   801934 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 cf 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 50 3d 80 00       	push   $0x803d50
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
  80014d:	68 3c 3c 80 00       	push   $0x803c3c
  800152:	6a 31                	push   $0x31
  800154:	68 1c 3c 80 00       	push   $0x803c1c
  800159:	e8 3a 02 00 00       	call   800398 <_panic>
		expected = 0;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 7a 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 63 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 b8 3c 80 00       	push   $0x803cb8
  800194:	6a 34                	push   $0x34
  800196:	68 1c 3c 80 00       	push   $0x803c1c
  80019b:	e8 f8 01 00 00       	call   800398 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 a9 17 00 00       	call   80194e <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 0a             	cmp    $0xa,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 54 3d 80 00       	push   $0x803d54
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 1c 3c 80 00       	push   $0x803c1c
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
  8001d9:	68 54 3d 80 00       	push   $0x803d54
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 1c 3c 80 00       	push   $0x803c1c
  8001e5:	e8 ae 01 00 00       	call   800398 <_panic>

	inctst();
  8001ea:	e8 ff 1a 00 00       	call   801cee <inctst>

	//sync with master
	while (gettst() != 5) ;
  8001ef:	90                   	nop
  8001f0:	e8 13 1b 00 00       	call   801d08 <gettst>
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	75 f6                	jne    8001f0 <_main+0x1b8>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 06                	push   $0x6
  8001ff:	e8 64 1a 00 00       	call   801c68 <sys_bypassPageFault>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	68 8c 3d 80 00       	push   $0x803d8c
  800212:	e8 3e 04 00 00       	call   800655 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 3b 1a 00 00       	call   801c68 <sys_bypassPageFault>
  80022d:	83 c4 10             	add    $0x10,%esp

	inctst();
  800230:	e8 b9 1a 00 00       	call   801cee <inctst>
	if (*x == 100)
  800235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	83 f8 64             	cmp    $0x64,%eax
  80023d:	75 14                	jne    800253 <_main+0x21b>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 bc 3d 80 00       	push   $0x803dbc
  800247:	6a 4d                	push   $0x4d
  800249:	68 1c 3c 80 00       	push   $0x803c1c
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
  80025f:	e8 4c 19 00 00       	call   801bb0 <sys_getenvindex>
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
  8002cd:	e8 62 16 00 00       	call   801934 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	68 1c 3e 80 00       	push   $0x803e1c
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
  8002fd:	68 44 3e 80 00       	push   $0x803e44
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
  80032e:	68 6c 3e 80 00       	push   $0x803e6c
  800333:	e8 1d 03 00 00       	call   800655 <cprintf>
  800338:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80033b:	a1 20 50 80 00       	mov    0x805020,%eax
  800340:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	50                   	push   %eax
  80034a:	68 c4 3e 80 00       	push   $0x803ec4
  80034f:	e8 01 03 00 00       	call   800655 <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	68 1c 3e 80 00       	push   $0x803e1c
  80035f:	e8 f1 02 00 00       	call   800655 <cprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800367:	e8 e2 15 00 00       	call   80194e <sys_unlock_cons>
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
  80037f:	e8 f8 17 00 00       	call   801b7c <sys_destroy_env>
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
  800390:	e8 4d 18 00 00       	call   801be2 <sys_exit_env>
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
  8003b9:	68 d8 3e 80 00       	push   $0x803ed8
  8003be:	e8 92 02 00 00       	call   800655 <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003c6:	a1 00 50 80 00       	mov    0x805000,%eax
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	50                   	push   %eax
  8003d2:	68 dd 3e 80 00       	push   $0x803edd
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
  8003f6:	68 f9 3e 80 00       	push   $0x803ef9
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
  800425:	68 fc 3e 80 00       	push   $0x803efc
  80042a:	6a 26                	push   $0x26
  80042c:	68 48 3f 80 00       	push   $0x803f48
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
  8004fa:	68 54 3f 80 00       	push   $0x803f54
  8004ff:	6a 3a                	push   $0x3a
  800501:	68 48 3f 80 00       	push   $0x803f48
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
  80056d:	68 a8 3f 80 00       	push   $0x803fa8
  800572:	6a 44                	push   $0x44
  800574:	68 48 3f 80 00       	push   $0x803f48
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
  8005c7:	e8 26 13 00 00       	call   8018f2 <sys_cputs>
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
  80063e:	e8 af 12 00 00       	call   8018f2 <sys_cputs>
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
  800688:	e8 a7 12 00 00       	call   801934 <sys_lock_cons>
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
  8006a8:	e8 a1 12 00 00       	call   80194e <sys_unlock_cons>
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
  8006f2:	e8 95 32 00 00       	call   80398c <__udivdi3>
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
  800742:	e8 55 33 00 00       	call   803a9c <__umoddi3>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	05 14 42 80 00       	add    $0x804214,%eax
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
  80089d:	8b 04 85 38 42 80 00 	mov    0x804238(,%eax,4),%eax
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
  80097e:	8b 34 9d 80 40 80 00 	mov    0x804080(,%ebx,4),%esi
  800985:	85 f6                	test   %esi,%esi
  800987:	75 19                	jne    8009a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800989:	53                   	push   %ebx
  80098a:	68 25 42 80 00       	push   $0x804225
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
  8009a3:	68 2e 42 80 00       	push   $0x80422e
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
  8009d0:	be 31 42 80 00       	mov    $0x804231,%esi
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
  8013db:	68 a8 43 80 00       	push   $0x8043a8
  8013e0:	68 3f 01 00 00       	push   $0x13f
  8013e5:	68 ca 43 80 00       	push   $0x8043ca
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
  8013fb:	e8 9d 0a 00 00       	call   801e9d <sys_sbrk>
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
  801476:	e8 a6 08 00 00       	call   801d21 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80147b:	85 c0                	test   %eax,%eax
  80147d:	74 16                	je     801495 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	e8 e6 0d 00 00       	call   802270 <alloc_block_FF>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801490:	e9 8a 01 00 00       	jmp    80161f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801495:	e8 b8 08 00 00       	call   801d52 <sys_isUHeapPlacementStrategyBESTFIT>
  80149a:	85 c0                	test   %eax,%eax
  80149c:	0f 84 7d 01 00 00    	je     80161f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 7f 12 00 00       	call   80272c <alloc_block_BF>
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
  80160e:	e8 c1 08 00 00       	call   801ed4 <sys_allocate_user_mem>
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
  801656:	e8 95 08 00 00       	call   801ef0 <get_block_size>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	e8 c8 1a 00 00       	call   803134 <free_block>
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
  8016fe:	e8 b5 07 00 00       	call   801eb8 <sys_free_user_mem>
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
  80170c:	68 d8 43 80 00       	push   $0x8043d8
  801711:	68 84 00 00 00       	push   $0x84
  801716:	68 02 44 80 00       	push   $0x804402
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
  80177e:	e8 3c 03 00 00       	call   801abf <sys_createSharedObject>
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
  80179f:	68 0e 44 80 00       	push   $0x80440e
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
  8017b4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017b7:	83 ec 08             	sub    $0x8,%esp
  8017ba:	ff 75 0c             	pushl  0xc(%ebp)
  8017bd:	ff 75 08             	pushl  0x8(%ebp)
  8017c0:	e8 24 03 00 00       	call   801ae9 <sys_getSizeOfSharedObject>
  8017c5:	83 c4 10             	add    $0x10,%esp
  8017c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8017cb:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017cf:	75 07                	jne    8017d8 <sget+0x27>
  8017d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d6:	eb 5c                	jmp    801834 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8017d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017de:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017eb:	39 d0                	cmp    %edx,%eax
  8017ed:	7d 02                	jge    8017f1 <sget+0x40>
  8017ef:	89 d0                	mov    %edx,%eax
  8017f1:	83 ec 0c             	sub    $0xc,%esp
  8017f4:	50                   	push   %eax
  8017f5:	e8 0b fc ff ff       	call   801405 <malloc>
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801800:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801804:	75 07                	jne    80180d <sget+0x5c>
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	eb 27                	jmp    801834 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	ff 75 e8             	pushl  -0x18(%ebp)
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	e8 e8 02 00 00       	call   801b06 <sys_getSharedObject>
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801824:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801828:	75 07                	jne    801831 <sget+0x80>
  80182a:	b8 00 00 00 00       	mov    $0x0,%eax
  80182f:	eb 03                	jmp    801834 <sget+0x83>
	return ptr;
  801831:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80183c:	83 ec 04             	sub    $0x4,%esp
  80183f:	68 14 44 80 00       	push   $0x804414
  801844:	68 c2 00 00 00       	push   $0xc2
  801849:	68 02 44 80 00       	push   $0x804402
  80184e:	e8 45 eb ff ff       	call   800398 <_panic>

00801853 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	68 38 44 80 00       	push   $0x804438
  801861:	68 d9 00 00 00       	push   $0xd9
  801866:	68 02 44 80 00       	push   $0x804402
  80186b:	e8 28 eb ff ff       	call   800398 <_panic>

00801870 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	68 5e 44 80 00       	push   $0x80445e
  80187e:	68 e5 00 00 00       	push   $0xe5
  801883:	68 02 44 80 00       	push   $0x804402
  801888:	e8 0b eb ff ff       	call   800398 <_panic>

0080188d <shrink>:

}
void shrink(uint32 newSize)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	68 5e 44 80 00       	push   $0x80445e
  80189b:	68 ea 00 00 00       	push   $0xea
  8018a0:	68 02 44 80 00       	push   $0x804402
  8018a5:	e8 ee ea ff ff       	call   800398 <_panic>

008018aa <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	68 5e 44 80 00       	push   $0x80445e
  8018b8:	68 ef 00 00 00       	push   $0xef
  8018bd:	68 02 44 80 00       	push   $0x804402
  8018c2:	e8 d1 ea ff ff       	call   800398 <_panic>

008018c7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	57                   	push   %edi
  8018cb:	56                   	push   %esi
  8018cc:	53                   	push   %ebx
  8018cd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018dc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018df:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018e2:	cd 30                	int    $0x30
  8018e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5f                   	pop    %edi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    

008018f2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 04             	sub    $0x4,%esp
  8018f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	52                   	push   %edx
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	50                   	push   %eax
  80190e:	6a 00                	push   $0x0
  801910:	e8 b2 ff ff ff       	call   8018c7 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	90                   	nop
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_cgetc>:

int
sys_cgetc(void)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 02                	push   $0x2
  80192a:	e8 98 ff ff ff       	call   8018c7 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 03                	push   $0x3
  801943:	e8 7f ff ff ff       	call   8018c7 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	90                   	nop
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 04                	push   $0x4
  80195d:	e8 65 ff ff ff       	call   8018c7 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	90                   	nop
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80196b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	52                   	push   %edx
  801978:	50                   	push   %eax
  801979:	6a 08                	push   $0x8
  80197b:	e8 47 ff ff ff       	call   8018c7 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	56                   	push   %esi
  801989:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80198a:	8b 75 18             	mov    0x18(%ebp),%esi
  80198d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801990:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801993:	8b 55 0c             	mov    0xc(%ebp),%edx
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	56                   	push   %esi
  80199a:	53                   	push   %ebx
  80199b:	51                   	push   %ecx
  80199c:	52                   	push   %edx
  80199d:	50                   	push   %eax
  80199e:	6a 09                	push   $0x9
  8019a0:	e8 22 ff ff ff       	call   8018c7 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5d                   	pop    %ebp
  8019ae:	c3                   	ret    

008019af <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	52                   	push   %edx
  8019bf:	50                   	push   %eax
  8019c0:	6a 0a                	push   $0xa
  8019c2:	e8 00 ff ff ff       	call   8018c7 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	6a 0b                	push   $0xb
  8019dd:	e8 e5 fe ff ff       	call   8018c7 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 0c                	push   $0xc
  8019f6:	e8 cc fe ff ff       	call   8018c7 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 0d                	push   $0xd
  801a0f:	e8 b3 fe ff ff       	call   8018c7 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 0e                	push   $0xe
  801a28:	e8 9a fe ff ff       	call   8018c7 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 0f                	push   $0xf
  801a41:	e8 81 fe ff ff       	call   8018c7 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	ff 75 08             	pushl  0x8(%ebp)
  801a59:	6a 10                	push   $0x10
  801a5b:	e8 67 fe ff ff       	call   8018c7 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 11                	push   $0x11
  801a74:	e8 4e fe ff ff       	call   8018c7 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_cputc>:

void
sys_cputc(const char c)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 04             	sub    $0x4,%esp
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	50                   	push   %eax
  801a98:	6a 01                	push   $0x1
  801a9a:	e8 28 fe ff ff       	call   8018c7 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	90                   	nop
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 14                	push   $0x14
  801ab4:	e8 0e fe ff ff       	call   8018c7 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	90                   	nop
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 04             	sub    $0x4,%esp
  801ac5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801acb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ace:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	51                   	push   %ecx
  801ad8:	52                   	push   %edx
  801ad9:	ff 75 0c             	pushl  0xc(%ebp)
  801adc:	50                   	push   %eax
  801add:	6a 15                	push   $0x15
  801adf:	e8 e3 fd ff ff       	call   8018c7 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	52                   	push   %edx
  801af9:	50                   	push   %eax
  801afa:	6a 16                	push   $0x16
  801afc:	e8 c6 fd ff ff       	call   8018c7 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	51                   	push   %ecx
  801b17:	52                   	push   %edx
  801b18:	50                   	push   %eax
  801b19:	6a 17                	push   $0x17
  801b1b:	e8 a7 fd ff ff       	call   8018c7 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	52                   	push   %edx
  801b35:	50                   	push   %eax
  801b36:	6a 18                	push   $0x18
  801b38:	e8 8a fd ff ff       	call   8018c7 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	6a 00                	push   $0x0
  801b4a:	ff 75 14             	pushl  0x14(%ebp)
  801b4d:	ff 75 10             	pushl  0x10(%ebp)
  801b50:	ff 75 0c             	pushl  0xc(%ebp)
  801b53:	50                   	push   %eax
  801b54:	6a 19                	push   $0x19
  801b56:	e8 6c fd ff ff       	call   8018c7 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	50                   	push   %eax
  801b6f:	6a 1a                	push   $0x1a
  801b71:	e8 51 fd ff ff       	call   8018c7 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	90                   	nop
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	50                   	push   %eax
  801b8b:	6a 1b                	push   $0x1b
  801b8d:	e8 35 fd ff ff       	call   8018c7 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 05                	push   $0x5
  801ba6:	e8 1c fd ff ff       	call   8018c7 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 06                	push   $0x6
  801bbf:	e8 03 fd ff ff       	call   8018c7 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 07                	push   $0x7
  801bd8:	e8 ea fc ff ff       	call   8018c7 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_exit_env>:


void sys_exit_env(void)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 1c                	push   $0x1c
  801bf1:	e8 d1 fc ff ff       	call   8018c7 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c02:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c05:	8d 50 04             	lea    0x4(%eax),%edx
  801c08:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	52                   	push   %edx
  801c12:	50                   	push   %eax
  801c13:	6a 1d                	push   $0x1d
  801c15:	e8 ad fc ff ff       	call   8018c7 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c26:	89 01                	mov    %eax,(%ecx)
  801c28:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	c9                   	leave  
  801c2f:	c2 04 00             	ret    $0x4

00801c32 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	ff 75 10             	pushl  0x10(%ebp)
  801c3c:	ff 75 0c             	pushl  0xc(%ebp)
  801c3f:	ff 75 08             	pushl  0x8(%ebp)
  801c42:	6a 13                	push   $0x13
  801c44:	e8 7e fc ff ff       	call   8018c7 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4c:	90                   	nop
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 1e                	push   $0x1e
  801c5e:	e8 64 fc ff ff       	call   8018c7 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	83 ec 04             	sub    $0x4,%esp
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c74:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	50                   	push   %eax
  801c81:	6a 1f                	push   $0x1f
  801c83:	e8 3f fc ff ff       	call   8018c7 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8b:	90                   	nop
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <rsttst>:
void rsttst()
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 21                	push   $0x21
  801c9d:	e8 25 fc ff ff       	call   8018c7 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca5:	90                   	nop
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 04             	sub    $0x4,%esp
  801cae:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cb4:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cbb:	52                   	push   %edx
  801cbc:	50                   	push   %eax
  801cbd:	ff 75 10             	pushl  0x10(%ebp)
  801cc0:	ff 75 0c             	pushl  0xc(%ebp)
  801cc3:	ff 75 08             	pushl  0x8(%ebp)
  801cc6:	6a 20                	push   $0x20
  801cc8:	e8 fa fb ff ff       	call   8018c7 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd0:	90                   	nop
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <chktst>:
void chktst(uint32 n)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	ff 75 08             	pushl  0x8(%ebp)
  801ce1:	6a 22                	push   $0x22
  801ce3:	e8 df fb ff ff       	call   8018c7 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ceb:	90                   	nop
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <inctst>:

void inctst()
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 23                	push   $0x23
  801cfd:	e8 c5 fb ff ff       	call   8018c7 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
	return ;
  801d05:	90                   	nop
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <gettst>:
uint32 gettst()
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 24                	push   $0x24
  801d17:	e8 ab fb ff ff       	call   8018c7 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 25                	push   $0x25
  801d33:	e8 8f fb ff ff       	call   8018c7 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
  801d3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d3e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d42:	75 07                	jne    801d4b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d44:	b8 01 00 00 00       	mov    $0x1,%eax
  801d49:	eb 05                	jmp    801d50 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 25                	push   $0x25
  801d64:	e8 5e fb ff ff       	call   8018c7 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
  801d6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d6f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d73:	75 07                	jne    801d7c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d75:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7a:	eb 05                	jmp    801d81 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 25                	push   $0x25
  801d95:	e8 2d fb ff ff       	call   8018c7 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
  801d9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801da0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801da4:	75 07                	jne    801dad <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801da6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dab:	eb 05                	jmp    801db2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 25                	push   $0x25
  801dc6:	e8 fc fa ff ff       	call   8018c7 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
  801dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dd1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dd5:	75 07                	jne    801dde <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dd7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddc:	eb 05                	jmp    801de3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	6a 26                	push   $0x26
  801df5:	e8 cd fa ff ff       	call   8018c7 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfd:	90                   	nop
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e04:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	6a 00                	push   $0x0
  801e12:	53                   	push   %ebx
  801e13:	51                   	push   %ecx
  801e14:	52                   	push   %edx
  801e15:	50                   	push   %eax
  801e16:	6a 27                	push   $0x27
  801e18:	e8 aa fa ff ff       	call   8018c7 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	52                   	push   %edx
  801e35:	50                   	push   %eax
  801e36:	6a 28                	push   $0x28
  801e38:	e8 8a fa ff ff       	call   8018c7 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e45:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	6a 00                	push   $0x0
  801e50:	51                   	push   %ecx
  801e51:	ff 75 10             	pushl  0x10(%ebp)
  801e54:	52                   	push   %edx
  801e55:	50                   	push   %eax
  801e56:	6a 29                	push   $0x29
  801e58:	e8 6a fa ff ff       	call   8018c7 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	ff 75 10             	pushl  0x10(%ebp)
  801e6c:	ff 75 0c             	pushl  0xc(%ebp)
  801e6f:	ff 75 08             	pushl  0x8(%ebp)
  801e72:	6a 12                	push   $0x12
  801e74:	e8 4e fa ff ff       	call   8018c7 <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7c:	90                   	nop
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	52                   	push   %edx
  801e8f:	50                   	push   %eax
  801e90:	6a 2a                	push   $0x2a
  801e92:	e8 30 fa ff ff       	call   8018c7 <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
	return;
  801e9a:	90                   	nop
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	50                   	push   %eax
  801eac:	6a 2b                	push   $0x2b
  801eae:	e8 14 fa ff ff       	call   8018c7 <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	ff 75 0c             	pushl  0xc(%ebp)
  801ec4:	ff 75 08             	pushl  0x8(%ebp)
  801ec7:	6a 2c                	push   $0x2c
  801ec9:	e8 f9 f9 ff ff       	call   8018c7 <syscall>
  801ece:	83 c4 18             	add    $0x18,%esp
	return;
  801ed1:	90                   	nop
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	ff 75 0c             	pushl  0xc(%ebp)
  801ee0:	ff 75 08             	pushl  0x8(%ebp)
  801ee3:	6a 2d                	push   $0x2d
  801ee5:	e8 dd f9 ff ff       	call   8018c7 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
	return;
  801eed:	90                   	nop
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	83 e8 04             	sub    $0x4,%eax
  801efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f02:	8b 00                	mov    (%eax),%eax
  801f04:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	83 e8 04             	sub    $0x4,%eax
  801f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f1b:	8b 00                	mov    (%eax),%eax
  801f1d:	83 e0 01             	and    $0x1,%eax
  801f20:	85 c0                	test   %eax,%eax
  801f22:	0f 94 c0             	sete   %al
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f37:	83 f8 02             	cmp    $0x2,%eax
  801f3a:	74 2b                	je     801f67 <alloc_block+0x40>
  801f3c:	83 f8 02             	cmp    $0x2,%eax
  801f3f:	7f 07                	jg     801f48 <alloc_block+0x21>
  801f41:	83 f8 01             	cmp    $0x1,%eax
  801f44:	74 0e                	je     801f54 <alloc_block+0x2d>
  801f46:	eb 58                	jmp    801fa0 <alloc_block+0x79>
  801f48:	83 f8 03             	cmp    $0x3,%eax
  801f4b:	74 2d                	je     801f7a <alloc_block+0x53>
  801f4d:	83 f8 04             	cmp    $0x4,%eax
  801f50:	74 3b                	je     801f8d <alloc_block+0x66>
  801f52:	eb 4c                	jmp    801fa0 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f54:	83 ec 0c             	sub    $0xc,%esp
  801f57:	ff 75 08             	pushl  0x8(%ebp)
  801f5a:	e8 11 03 00 00       	call   802270 <alloc_block_FF>
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f65:	eb 4a                	jmp    801fb1 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f67:	83 ec 0c             	sub    $0xc,%esp
  801f6a:	ff 75 08             	pushl  0x8(%ebp)
  801f6d:	e8 fa 19 00 00       	call   80396c <alloc_block_NF>
  801f72:	83 c4 10             	add    $0x10,%esp
  801f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f78:	eb 37                	jmp    801fb1 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f7a:	83 ec 0c             	sub    $0xc,%esp
  801f7d:	ff 75 08             	pushl  0x8(%ebp)
  801f80:	e8 a7 07 00 00       	call   80272c <alloc_block_BF>
  801f85:	83 c4 10             	add    $0x10,%esp
  801f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f8b:	eb 24                	jmp    801fb1 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f8d:	83 ec 0c             	sub    $0xc,%esp
  801f90:	ff 75 08             	pushl  0x8(%ebp)
  801f93:	e8 b7 19 00 00       	call   80394f <alloc_block_WF>
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f9e:	eb 11                	jmp    801fb1 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fa0:	83 ec 0c             	sub    $0xc,%esp
  801fa3:	68 70 44 80 00       	push   $0x804470
  801fa8:	e8 a8 e6 ff ff       	call   800655 <cprintf>
  801fad:	83 c4 10             	add    $0x10,%esp
		break;
  801fb0:	90                   	nop
	}
	return va;
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	53                   	push   %ebx
  801fba:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	68 90 44 80 00       	push   $0x804490
  801fc5:	e8 8b e6 ff ff       	call   800655 <cprintf>
  801fca:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801fcd:	83 ec 0c             	sub    $0xc,%esp
  801fd0:	68 bb 44 80 00       	push   $0x8044bb
  801fd5:	e8 7b e6 ff ff       	call   800655 <cprintf>
  801fda:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe3:	eb 37                	jmp    80201c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801fe5:	83 ec 0c             	sub    $0xc,%esp
  801fe8:	ff 75 f4             	pushl  -0xc(%ebp)
  801feb:	e8 19 ff ff ff       	call   801f09 <is_free_block>
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	0f be d8             	movsbl %al,%ebx
  801ff6:	83 ec 0c             	sub    $0xc,%esp
  801ff9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffc:	e8 ef fe ff ff       	call   801ef0 <get_block_size>
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	83 ec 04             	sub    $0x4,%esp
  802007:	53                   	push   %ebx
  802008:	50                   	push   %eax
  802009:	68 d3 44 80 00       	push   $0x8044d3
  80200e:	e8 42 e6 ff ff       	call   800655 <cprintf>
  802013:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802016:	8b 45 10             	mov    0x10(%ebp),%eax
  802019:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802020:	74 07                	je     802029 <print_blocks_list+0x73>
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	8b 00                	mov    (%eax),%eax
  802027:	eb 05                	jmp    80202e <print_blocks_list+0x78>
  802029:	b8 00 00 00 00       	mov    $0x0,%eax
  80202e:	89 45 10             	mov    %eax,0x10(%ebp)
  802031:	8b 45 10             	mov    0x10(%ebp),%eax
  802034:	85 c0                	test   %eax,%eax
  802036:	75 ad                	jne    801fe5 <print_blocks_list+0x2f>
  802038:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203c:	75 a7                	jne    801fe5 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80203e:	83 ec 0c             	sub    $0xc,%esp
  802041:	68 90 44 80 00       	push   $0x804490
  802046:	e8 0a e6 ff ff       	call   800655 <cprintf>
  80204b:	83 c4 10             	add    $0x10,%esp

}
  80204e:	90                   	nop
  80204f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80205a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205d:	83 e0 01             	and    $0x1,%eax
  802060:	85 c0                	test   %eax,%eax
  802062:	74 03                	je     802067 <initialize_dynamic_allocator+0x13>
  802064:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802067:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80206b:	0f 84 c7 01 00 00    	je     802238 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802071:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802078:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80207b:	8b 55 08             	mov    0x8(%ebp),%edx
  80207e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802081:	01 d0                	add    %edx,%eax
  802083:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802088:	0f 87 ad 01 00 00    	ja     80223b <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	85 c0                	test   %eax,%eax
  802093:	0f 89 a5 01 00 00    	jns    80223e <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802099:	8b 55 08             	mov    0x8(%ebp),%edx
  80209c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209f:	01 d0                	add    %edx,%eax
  8020a1:	83 e8 04             	sub    $0x4,%eax
  8020a4:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020b0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b8:	e9 87 00 00 00       	jmp    802144 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c1:	75 14                	jne    8020d7 <initialize_dynamic_allocator+0x83>
  8020c3:	83 ec 04             	sub    $0x4,%esp
  8020c6:	68 eb 44 80 00       	push   $0x8044eb
  8020cb:	6a 79                	push   $0x79
  8020cd:	68 09 45 80 00       	push   $0x804509
  8020d2:	e8 c1 e2 ff ff       	call   800398 <_panic>
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	8b 00                	mov    (%eax),%eax
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	74 10                	je     8020f0 <initialize_dynamic_allocator+0x9c>
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	8b 00                	mov    (%eax),%eax
  8020e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e8:	8b 52 04             	mov    0x4(%edx),%edx
  8020eb:	89 50 04             	mov    %edx,0x4(%eax)
  8020ee:	eb 0b                	jmp    8020fb <initialize_dynamic_allocator+0xa7>
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 40 04             	mov    0x4(%eax),%eax
  8020f6:	a3 30 50 80 00       	mov    %eax,0x805030
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	8b 40 04             	mov    0x4(%eax),%eax
  802101:	85 c0                	test   %eax,%eax
  802103:	74 0f                	je     802114 <initialize_dynamic_allocator+0xc0>
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	8b 40 04             	mov    0x4(%eax),%eax
  80210b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210e:	8b 12                	mov    (%edx),%edx
  802110:	89 10                	mov    %edx,(%eax)
  802112:	eb 0a                	jmp    80211e <initialize_dynamic_allocator+0xca>
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802117:	8b 00                	mov    (%eax),%eax
  802119:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80211e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802121:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802131:	a1 38 50 80 00       	mov    0x805038,%eax
  802136:	48                   	dec    %eax
  802137:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80213c:	a1 34 50 80 00       	mov    0x805034,%eax
  802141:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802148:	74 07                	je     802151 <initialize_dynamic_allocator+0xfd>
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	8b 00                	mov    (%eax),%eax
  80214f:	eb 05                	jmp    802156 <initialize_dynamic_allocator+0x102>
  802151:	b8 00 00 00 00       	mov    $0x0,%eax
  802156:	a3 34 50 80 00       	mov    %eax,0x805034
  80215b:	a1 34 50 80 00       	mov    0x805034,%eax
  802160:	85 c0                	test   %eax,%eax
  802162:	0f 85 55 ff ff ff    	jne    8020bd <initialize_dynamic_allocator+0x69>
  802168:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216c:	0f 85 4b ff ff ff    	jne    8020bd <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802181:	a1 44 50 80 00       	mov    0x805044,%eax
  802186:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80218b:	a1 40 50 80 00       	mov    0x805040,%eax
  802190:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	83 c0 08             	add    $0x8,%eax
  80219c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	83 c0 04             	add    $0x4,%eax
  8021a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a8:	83 ea 08             	sub    $0x8,%edx
  8021ab:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	01 d0                	add    %edx,%eax
  8021b5:	83 e8 08             	sub    $0x8,%eax
  8021b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bb:	83 ea 08             	sub    $0x8,%edx
  8021be:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021d7:	75 17                	jne    8021f0 <initialize_dynamic_allocator+0x19c>
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	68 24 45 80 00       	push   $0x804524
  8021e1:	68 90 00 00 00       	push   $0x90
  8021e6:	68 09 45 80 00       	push   $0x804509
  8021eb:	e8 a8 e1 ff ff       	call   800398 <_panic>
  8021f0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f9:	89 10                	mov    %edx,(%eax)
  8021fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fe:	8b 00                	mov    (%eax),%eax
  802200:	85 c0                	test   %eax,%eax
  802202:	74 0d                	je     802211 <initialize_dynamic_allocator+0x1bd>
  802204:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802209:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80220c:	89 50 04             	mov    %edx,0x4(%eax)
  80220f:	eb 08                	jmp    802219 <initialize_dynamic_allocator+0x1c5>
  802211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802214:	a3 30 50 80 00       	mov    %eax,0x805030
  802219:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802221:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802224:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222b:	a1 38 50 80 00       	mov    0x805038,%eax
  802230:	40                   	inc    %eax
  802231:	a3 38 50 80 00       	mov    %eax,0x805038
  802236:	eb 07                	jmp    80223f <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802238:	90                   	nop
  802239:	eb 04                	jmp    80223f <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80223b:	90                   	nop
  80223c:	eb 01                	jmp    80223f <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80223e:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802244:	8b 45 10             	mov    0x10(%ebp),%eax
  802247:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802250:	8b 45 0c             	mov    0xc(%ebp),%eax
  802253:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	83 e8 04             	sub    $0x4,%eax
  80225b:	8b 00                	mov    (%eax),%eax
  80225d:	83 e0 fe             	and    $0xfffffffe,%eax
  802260:	8d 50 f8             	lea    -0x8(%eax),%edx
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	01 c2                	add    %eax,%edx
  802268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226b:	89 02                	mov    %eax,(%edx)
}
  80226d:	90                   	nop
  80226e:	5d                   	pop    %ebp
  80226f:	c3                   	ret    

00802270 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	83 e0 01             	and    $0x1,%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	74 03                	je     802283 <alloc_block_FF+0x13>
  802280:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802283:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802287:	77 07                	ja     802290 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802289:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802290:	a1 24 50 80 00       	mov    0x805024,%eax
  802295:	85 c0                	test   %eax,%eax
  802297:	75 73                	jne    80230c <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	83 c0 10             	add    $0x10,%eax
  80229f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022a2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022af:	01 d0                	add    %edx,%eax
  8022b1:	48                   	dec    %eax
  8022b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8022bd:	f7 75 ec             	divl   -0x14(%ebp)
  8022c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c3:	29 d0                	sub    %edx,%eax
  8022c5:	c1 e8 0c             	shr    $0xc,%eax
  8022c8:	83 ec 0c             	sub    $0xc,%esp
  8022cb:	50                   	push   %eax
  8022cc:	e8 1e f1 ff ff       	call   8013ef <sbrk>
  8022d1:	83 c4 10             	add    $0x10,%esp
  8022d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8022d7:	83 ec 0c             	sub    $0xc,%esp
  8022da:	6a 00                	push   $0x0
  8022dc:	e8 0e f1 ff ff       	call   8013ef <sbrk>
  8022e1:	83 c4 10             	add    $0x10,%esp
  8022e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8022e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ea:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8022ed:	83 ec 08             	sub    $0x8,%esp
  8022f0:	50                   	push   %eax
  8022f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022f4:	e8 5b fd ff ff       	call   802054 <initialize_dynamic_allocator>
  8022f9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	68 47 45 80 00       	push   $0x804547
  802304:	e8 4c e3 ff ff       	call   800655 <cprintf>
  802309:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80230c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802310:	75 0a                	jne    80231c <alloc_block_FF+0xac>
	        return NULL;
  802312:	b8 00 00 00 00       	mov    $0x0,%eax
  802317:	e9 0e 04 00 00       	jmp    80272a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80231c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802323:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232b:	e9 f3 02 00 00       	jmp    802623 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802336:	83 ec 0c             	sub    $0xc,%esp
  802339:	ff 75 bc             	pushl  -0x44(%ebp)
  80233c:	e8 af fb ff ff       	call   801ef0 <get_block_size>
  802341:	83 c4 10             	add    $0x10,%esp
  802344:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	83 c0 08             	add    $0x8,%eax
  80234d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802350:	0f 87 c5 02 00 00    	ja     80261b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	83 c0 18             	add    $0x18,%eax
  80235c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80235f:	0f 87 19 02 00 00    	ja     80257e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802365:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802368:	2b 45 08             	sub    0x8(%ebp),%eax
  80236b:	83 e8 08             	sub    $0x8,%eax
  80236e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	8d 50 08             	lea    0x8(%eax),%edx
  802377:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80237a:	01 d0                	add    %edx,%eax
  80237c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	83 c0 08             	add    $0x8,%eax
  802385:	83 ec 04             	sub    $0x4,%esp
  802388:	6a 01                	push   $0x1
  80238a:	50                   	push   %eax
  80238b:	ff 75 bc             	pushl  -0x44(%ebp)
  80238e:	e8 ae fe ff ff       	call   802241 <set_block_data>
  802393:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 40 04             	mov    0x4(%eax),%eax
  80239c:	85 c0                	test   %eax,%eax
  80239e:	75 68                	jne    802408 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023a0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023a4:	75 17                	jne    8023bd <alloc_block_FF+0x14d>
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	68 24 45 80 00       	push   $0x804524
  8023ae:	68 d7 00 00 00       	push   $0xd7
  8023b3:	68 09 45 80 00       	push   $0x804509
  8023b8:	e8 db df ff ff       	call   800398 <_panic>
  8023bd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c6:	89 10                	mov    %edx,(%eax)
  8023c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023cb:	8b 00                	mov    (%eax),%eax
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	74 0d                	je     8023de <alloc_block_FF+0x16e>
  8023d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023d6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023d9:	89 50 04             	mov    %edx,0x4(%eax)
  8023dc:	eb 08                	jmp    8023e6 <alloc_block_FF+0x176>
  8023de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8023e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8023fd:	40                   	inc    %eax
  8023fe:	a3 38 50 80 00       	mov    %eax,0x805038
  802403:	e9 dc 00 00 00       	jmp    8024e4 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	75 65                	jne    802476 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802411:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802415:	75 17                	jne    80242e <alloc_block_FF+0x1be>
  802417:	83 ec 04             	sub    $0x4,%esp
  80241a:	68 58 45 80 00       	push   $0x804558
  80241f:	68 db 00 00 00       	push   $0xdb
  802424:	68 09 45 80 00       	push   $0x804509
  802429:	e8 6a df ff ff       	call   800398 <_panic>
  80242e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802434:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802437:	89 50 04             	mov    %edx,0x4(%eax)
  80243a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243d:	8b 40 04             	mov    0x4(%eax),%eax
  802440:	85 c0                	test   %eax,%eax
  802442:	74 0c                	je     802450 <alloc_block_FF+0x1e0>
  802444:	a1 30 50 80 00       	mov    0x805030,%eax
  802449:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80244c:	89 10                	mov    %edx,(%eax)
  80244e:	eb 08                	jmp    802458 <alloc_block_FF+0x1e8>
  802450:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802453:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802458:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245b:	a3 30 50 80 00       	mov    %eax,0x805030
  802460:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802463:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802469:	a1 38 50 80 00       	mov    0x805038,%eax
  80246e:	40                   	inc    %eax
  80246f:	a3 38 50 80 00       	mov    %eax,0x805038
  802474:	eb 6e                	jmp    8024e4 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802476:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247a:	74 06                	je     802482 <alloc_block_FF+0x212>
  80247c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802480:	75 17                	jne    802499 <alloc_block_FF+0x229>
  802482:	83 ec 04             	sub    $0x4,%esp
  802485:	68 7c 45 80 00       	push   $0x80457c
  80248a:	68 df 00 00 00       	push   $0xdf
  80248f:	68 09 45 80 00       	push   $0x804509
  802494:	e8 ff de ff ff       	call   800398 <_panic>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 10                	mov    (%eax),%edx
  80249e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a1:	89 10                	mov    %edx,(%eax)
  8024a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a6:	8b 00                	mov    (%eax),%eax
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	74 0b                	je     8024b7 <alloc_block_FF+0x247>
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024b4:	89 50 04             	mov    %edx,0x4(%eax)
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024bd:	89 10                	mov    %edx,(%eax)
  8024bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c5:	89 50 04             	mov    %edx,0x4(%eax)
  8024c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	75 08                	jne    8024d9 <alloc_block_FF+0x269>
  8024d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8024d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8024de:	40                   	inc    %eax
  8024df:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8024e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e8:	75 17                	jne    802501 <alloc_block_FF+0x291>
  8024ea:	83 ec 04             	sub    $0x4,%esp
  8024ed:	68 eb 44 80 00       	push   $0x8044eb
  8024f2:	68 e1 00 00 00       	push   $0xe1
  8024f7:	68 09 45 80 00       	push   $0x804509
  8024fc:	e8 97 de ff ff       	call   800398 <_panic>
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 00                	mov    (%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 10                	je     80251a <alloc_block_FF+0x2aa>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802512:	8b 52 04             	mov    0x4(%edx),%edx
  802515:	89 50 04             	mov    %edx,0x4(%eax)
  802518:	eb 0b                	jmp    802525 <alloc_block_FF+0x2b5>
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 40 04             	mov    0x4(%eax),%eax
  802520:	a3 30 50 80 00       	mov    %eax,0x805030
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 40 04             	mov    0x4(%eax),%eax
  80252b:	85 c0                	test   %eax,%eax
  80252d:	74 0f                	je     80253e <alloc_block_FF+0x2ce>
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 40 04             	mov    0x4(%eax),%eax
  802535:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802538:	8b 12                	mov    (%edx),%edx
  80253a:	89 10                	mov    %edx,(%eax)
  80253c:	eb 0a                	jmp    802548 <alloc_block_FF+0x2d8>
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 00                	mov    (%eax),%eax
  802543:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80255b:	a1 38 50 80 00       	mov    0x805038,%eax
  802560:	48                   	dec    %eax
  802561:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802566:	83 ec 04             	sub    $0x4,%esp
  802569:	6a 00                	push   $0x0
  80256b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80256e:	ff 75 b0             	pushl  -0x50(%ebp)
  802571:	e8 cb fc ff ff       	call   802241 <set_block_data>
  802576:	83 c4 10             	add    $0x10,%esp
  802579:	e9 95 00 00 00       	jmp    802613 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80257e:	83 ec 04             	sub    $0x4,%esp
  802581:	6a 01                	push   $0x1
  802583:	ff 75 b8             	pushl  -0x48(%ebp)
  802586:	ff 75 bc             	pushl  -0x44(%ebp)
  802589:	e8 b3 fc ff ff       	call   802241 <set_block_data>
  80258e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802595:	75 17                	jne    8025ae <alloc_block_FF+0x33e>
  802597:	83 ec 04             	sub    $0x4,%esp
  80259a:	68 eb 44 80 00       	push   $0x8044eb
  80259f:	68 e8 00 00 00       	push   $0xe8
  8025a4:	68 09 45 80 00       	push   $0x804509
  8025a9:	e8 ea dd ff ff       	call   800398 <_panic>
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 10                	je     8025c7 <alloc_block_FF+0x357>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bf:	8b 52 04             	mov    0x4(%edx),%edx
  8025c2:	89 50 04             	mov    %edx,0x4(%eax)
  8025c5:	eb 0b                	jmp    8025d2 <alloc_block_FF+0x362>
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 40 04             	mov    0x4(%eax),%eax
  8025cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 40 04             	mov    0x4(%eax),%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	74 0f                	je     8025eb <alloc_block_FF+0x37b>
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 40 04             	mov    0x4(%eax),%eax
  8025e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e5:	8b 12                	mov    (%edx),%edx
  8025e7:	89 10                	mov    %edx,(%eax)
  8025e9:	eb 0a                	jmp    8025f5 <alloc_block_FF+0x385>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802608:	a1 38 50 80 00       	mov    0x805038,%eax
  80260d:	48                   	dec    %eax
  80260e:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802613:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802616:	e9 0f 01 00 00       	jmp    80272a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80261b:	a1 34 50 80 00       	mov    0x805034,%eax
  802620:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802623:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802627:	74 07                	je     802630 <alloc_block_FF+0x3c0>
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	eb 05                	jmp    802635 <alloc_block_FF+0x3c5>
  802630:	b8 00 00 00 00       	mov    $0x0,%eax
  802635:	a3 34 50 80 00       	mov    %eax,0x805034
  80263a:	a1 34 50 80 00       	mov    0x805034,%eax
  80263f:	85 c0                	test   %eax,%eax
  802641:	0f 85 e9 fc ff ff    	jne    802330 <alloc_block_FF+0xc0>
  802647:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264b:	0f 85 df fc ff ff    	jne    802330 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	83 c0 08             	add    $0x8,%eax
  802657:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80265a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802661:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802664:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802667:	01 d0                	add    %edx,%eax
  802669:	48                   	dec    %eax
  80266a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80266d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802670:	ba 00 00 00 00       	mov    $0x0,%edx
  802675:	f7 75 d8             	divl   -0x28(%ebp)
  802678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80267b:	29 d0                	sub    %edx,%eax
  80267d:	c1 e8 0c             	shr    $0xc,%eax
  802680:	83 ec 0c             	sub    $0xc,%esp
  802683:	50                   	push   %eax
  802684:	e8 66 ed ff ff       	call   8013ef <sbrk>
  802689:	83 c4 10             	add    $0x10,%esp
  80268c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80268f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802693:	75 0a                	jne    80269f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802695:	b8 00 00 00 00       	mov    $0x0,%eax
  80269a:	e9 8b 00 00 00       	jmp    80272a <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80269f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026ac:	01 d0                	add    %edx,%eax
  8026ae:	48                   	dec    %eax
  8026af:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ba:	f7 75 cc             	divl   -0x34(%ebp)
  8026bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026c0:	29 d0                	sub    %edx,%eax
  8026c2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026c8:	01 d0                	add    %edx,%eax
  8026ca:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026cf:	a1 40 50 80 00       	mov    0x805040,%eax
  8026d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8026da:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8026e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026e7:	01 d0                	add    %edx,%eax
  8026e9:	48                   	dec    %eax
  8026ea:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f5:	f7 75 c4             	divl   -0x3c(%ebp)
  8026f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026fb:	29 d0                	sub    %edx,%eax
  8026fd:	83 ec 04             	sub    $0x4,%esp
  802700:	6a 01                	push   $0x1
  802702:	50                   	push   %eax
  802703:	ff 75 d0             	pushl  -0x30(%ebp)
  802706:	e8 36 fb ff ff       	call   802241 <set_block_data>
  80270b:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80270e:	83 ec 0c             	sub    $0xc,%esp
  802711:	ff 75 d0             	pushl  -0x30(%ebp)
  802714:	e8 1b 0a 00 00       	call   803134 <free_block>
  802719:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80271c:	83 ec 0c             	sub    $0xc,%esp
  80271f:	ff 75 08             	pushl  0x8(%ebp)
  802722:	e8 49 fb ff ff       	call   802270 <alloc_block_FF>
  802727:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	83 e0 01             	and    $0x1,%eax
  802738:	85 c0                	test   %eax,%eax
  80273a:	74 03                	je     80273f <alloc_block_BF+0x13>
  80273c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80273f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802743:	77 07                	ja     80274c <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802745:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80274c:	a1 24 50 80 00       	mov    0x805024,%eax
  802751:	85 c0                	test   %eax,%eax
  802753:	75 73                	jne    8027c8 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	83 c0 10             	add    $0x10,%eax
  80275b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80275e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802765:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802768:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276b:	01 d0                	add    %edx,%eax
  80276d:	48                   	dec    %eax
  80276e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802771:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802774:	ba 00 00 00 00       	mov    $0x0,%edx
  802779:	f7 75 e0             	divl   -0x20(%ebp)
  80277c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80277f:	29 d0                	sub    %edx,%eax
  802781:	c1 e8 0c             	shr    $0xc,%eax
  802784:	83 ec 0c             	sub    $0xc,%esp
  802787:	50                   	push   %eax
  802788:	e8 62 ec ff ff       	call   8013ef <sbrk>
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802793:	83 ec 0c             	sub    $0xc,%esp
  802796:	6a 00                	push   $0x0
  802798:	e8 52 ec ff ff       	call   8013ef <sbrk>
  80279d:	83 c4 10             	add    $0x10,%esp
  8027a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027a6:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027a9:	83 ec 08             	sub    $0x8,%esp
  8027ac:	50                   	push   %eax
  8027ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8027b0:	e8 9f f8 ff ff       	call   802054 <initialize_dynamic_allocator>
  8027b5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027b8:	83 ec 0c             	sub    $0xc,%esp
  8027bb:	68 47 45 80 00       	push   $0x804547
  8027c0:	e8 90 de ff ff       	call   800655 <cprintf>
  8027c5:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8027d6:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8027e4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ec:	e9 1d 01 00 00       	jmp    80290e <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027f7:	83 ec 0c             	sub    $0xc,%esp
  8027fa:	ff 75 a8             	pushl  -0x58(%ebp)
  8027fd:	e8 ee f6 ff ff       	call   801ef0 <get_block_size>
  802802:	83 c4 10             	add    $0x10,%esp
  802805:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	83 c0 08             	add    $0x8,%eax
  80280e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802811:	0f 87 ef 00 00 00    	ja     802906 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	83 c0 18             	add    $0x18,%eax
  80281d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802820:	77 1d                	ja     80283f <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802822:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802825:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802828:	0f 86 d8 00 00 00    	jbe    802906 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80282e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802831:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802834:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802837:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80283a:	e9 c7 00 00 00       	jmp    802906 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	83 c0 08             	add    $0x8,%eax
  802845:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802848:	0f 85 9d 00 00 00    	jne    8028eb <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80284e:	83 ec 04             	sub    $0x4,%esp
  802851:	6a 01                	push   $0x1
  802853:	ff 75 a4             	pushl  -0x5c(%ebp)
  802856:	ff 75 a8             	pushl  -0x58(%ebp)
  802859:	e8 e3 f9 ff ff       	call   802241 <set_block_data>
  80285e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802865:	75 17                	jne    80287e <alloc_block_BF+0x152>
  802867:	83 ec 04             	sub    $0x4,%esp
  80286a:	68 eb 44 80 00       	push   $0x8044eb
  80286f:	68 2c 01 00 00       	push   $0x12c
  802874:	68 09 45 80 00       	push   $0x804509
  802879:	e8 1a db ff ff       	call   800398 <_panic>
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 00                	mov    (%eax),%eax
  802883:	85 c0                	test   %eax,%eax
  802885:	74 10                	je     802897 <alloc_block_BF+0x16b>
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 00                	mov    (%eax),%eax
  80288c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288f:	8b 52 04             	mov    0x4(%edx),%edx
  802892:	89 50 04             	mov    %edx,0x4(%eax)
  802895:	eb 0b                	jmp    8028a2 <alloc_block_BF+0x176>
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 40 04             	mov    0x4(%eax),%eax
  80289d:	a3 30 50 80 00       	mov    %eax,0x805030
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 40 04             	mov    0x4(%eax),%eax
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	74 0f                	je     8028bb <alloc_block_BF+0x18f>
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 40 04             	mov    0x4(%eax),%eax
  8028b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b5:	8b 12                	mov    (%edx),%edx
  8028b7:	89 10                	mov    %edx,(%eax)
  8028b9:	eb 0a                	jmp    8028c5 <alloc_block_BF+0x199>
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 00                	mov    (%eax),%eax
  8028c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8028dd:	48                   	dec    %eax
  8028de:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8028e3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028e6:	e9 24 04 00 00       	jmp    802d0f <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8028eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ee:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028f1:	76 13                	jbe    802906 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8028f3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028fa:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802900:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802903:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802906:	a1 34 50 80 00       	mov    0x805034,%eax
  80290b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802912:	74 07                	je     80291b <alloc_block_BF+0x1ef>
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	eb 05                	jmp    802920 <alloc_block_BF+0x1f4>
  80291b:	b8 00 00 00 00       	mov    $0x0,%eax
  802920:	a3 34 50 80 00       	mov    %eax,0x805034
  802925:	a1 34 50 80 00       	mov    0x805034,%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	0f 85 bf fe ff ff    	jne    8027f1 <alloc_block_BF+0xc5>
  802932:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802936:	0f 85 b5 fe ff ff    	jne    8027f1 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80293c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802940:	0f 84 26 02 00 00    	je     802b6c <alloc_block_BF+0x440>
  802946:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80294a:	0f 85 1c 02 00 00    	jne    802b6c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802953:	2b 45 08             	sub    0x8(%ebp),%eax
  802956:	83 e8 08             	sub    $0x8,%eax
  802959:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	8d 50 08             	lea    0x8(%eax),%edx
  802962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802965:	01 d0                	add    %edx,%eax
  802967:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	83 c0 08             	add    $0x8,%eax
  802970:	83 ec 04             	sub    $0x4,%esp
  802973:	6a 01                	push   $0x1
  802975:	50                   	push   %eax
  802976:	ff 75 f0             	pushl  -0x10(%ebp)
  802979:	e8 c3 f8 ff ff       	call   802241 <set_block_data>
  80297e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 40 04             	mov    0x4(%eax),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	75 68                	jne    8029f3 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80298b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80298f:	75 17                	jne    8029a8 <alloc_block_BF+0x27c>
  802991:	83 ec 04             	sub    $0x4,%esp
  802994:	68 24 45 80 00       	push   $0x804524
  802999:	68 45 01 00 00       	push   $0x145
  80299e:	68 09 45 80 00       	push   $0x804509
  8029a3:	e8 f0 d9 ff ff       	call   800398 <_panic>
  8029a8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b1:	89 10                	mov    %edx,(%eax)
  8029b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	74 0d                	je     8029c9 <alloc_block_BF+0x29d>
  8029bc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029c1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029c4:	89 50 04             	mov    %edx,0x4(%eax)
  8029c7:	eb 08                	jmp    8029d1 <alloc_block_BF+0x2a5>
  8029c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8029d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8029e8:	40                   	inc    %eax
  8029e9:	a3 38 50 80 00       	mov    %eax,0x805038
  8029ee:	e9 dc 00 00 00       	jmp    802acf <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8029f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	85 c0                	test   %eax,%eax
  8029fa:	75 65                	jne    802a61 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a00:	75 17                	jne    802a19 <alloc_block_BF+0x2ed>
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 58 45 80 00       	push   $0x804558
  802a0a:	68 4a 01 00 00       	push   $0x14a
  802a0f:	68 09 45 80 00       	push   $0x804509
  802a14:	e8 7f d9 ff ff       	call   800398 <_panic>
  802a19:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	74 0c                	je     802a3b <alloc_block_BF+0x30f>
  802a2f:	a1 30 50 80 00       	mov    0x805030,%eax
  802a34:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a37:	89 10                	mov    %edx,(%eax)
  802a39:	eb 08                	jmp    802a43 <alloc_block_BF+0x317>
  802a3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a46:	a3 30 50 80 00       	mov    %eax,0x805030
  802a4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a54:	a1 38 50 80 00       	mov    0x805038,%eax
  802a59:	40                   	inc    %eax
  802a5a:	a3 38 50 80 00       	mov    %eax,0x805038
  802a5f:	eb 6e                	jmp    802acf <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a65:	74 06                	je     802a6d <alloc_block_BF+0x341>
  802a67:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a6b:	75 17                	jne    802a84 <alloc_block_BF+0x358>
  802a6d:	83 ec 04             	sub    $0x4,%esp
  802a70:	68 7c 45 80 00       	push   $0x80457c
  802a75:	68 4f 01 00 00       	push   $0x14f
  802a7a:	68 09 45 80 00       	push   $0x804509
  802a7f:	e8 14 d9 ff ff       	call   800398 <_panic>
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 10                	mov    (%eax),%edx
  802a89:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8c:	89 10                	mov    %edx,(%eax)
  802a8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a91:	8b 00                	mov    (%eax),%eax
  802a93:	85 c0                	test   %eax,%eax
  802a95:	74 0b                	je     802aa2 <alloc_block_BF+0x376>
  802a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a9f:	89 50 04             	mov    %edx,0x4(%eax)
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aa8:	89 10                	mov    %edx,(%eax)
  802aaa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab0:	89 50 04             	mov    %edx,0x4(%eax)
  802ab3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	85 c0                	test   %eax,%eax
  802aba:	75 08                	jne    802ac4 <alloc_block_BF+0x398>
  802abc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abf:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac4:	a1 38 50 80 00       	mov    0x805038,%eax
  802ac9:	40                   	inc    %eax
  802aca:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802acf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad3:	75 17                	jne    802aec <alloc_block_BF+0x3c0>
  802ad5:	83 ec 04             	sub    $0x4,%esp
  802ad8:	68 eb 44 80 00       	push   $0x8044eb
  802add:	68 51 01 00 00       	push   $0x151
  802ae2:	68 09 45 80 00       	push   $0x804509
  802ae7:	e8 ac d8 ff ff       	call   800398 <_panic>
  802aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	74 10                	je     802b05 <alloc_block_BF+0x3d9>
  802af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af8:	8b 00                	mov    (%eax),%eax
  802afa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802afd:	8b 52 04             	mov    0x4(%edx),%edx
  802b00:	89 50 04             	mov    %edx,0x4(%eax)
  802b03:	eb 0b                	jmp    802b10 <alloc_block_BF+0x3e4>
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	8b 40 04             	mov    0x4(%eax),%eax
  802b0b:	a3 30 50 80 00       	mov    %eax,0x805030
  802b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b13:	8b 40 04             	mov    0x4(%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 0f                	je     802b29 <alloc_block_BF+0x3fd>
  802b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1d:	8b 40 04             	mov    0x4(%eax),%eax
  802b20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b23:	8b 12                	mov    (%edx),%edx
  802b25:	89 10                	mov    %edx,(%eax)
  802b27:	eb 0a                	jmp    802b33 <alloc_block_BF+0x407>
  802b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2c:	8b 00                	mov    (%eax),%eax
  802b2e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b46:	a1 38 50 80 00       	mov    0x805038,%eax
  802b4b:	48                   	dec    %eax
  802b4c:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	6a 00                	push   $0x0
  802b56:	ff 75 d0             	pushl  -0x30(%ebp)
  802b59:	ff 75 cc             	pushl  -0x34(%ebp)
  802b5c:	e8 e0 f6 ff ff       	call   802241 <set_block_data>
  802b61:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	e9 a3 01 00 00       	jmp    802d0f <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b6c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b70:	0f 85 9d 00 00 00    	jne    802c13 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b76:	83 ec 04             	sub    $0x4,%esp
  802b79:	6a 01                	push   $0x1
  802b7b:	ff 75 ec             	pushl  -0x14(%ebp)
  802b7e:	ff 75 f0             	pushl  -0x10(%ebp)
  802b81:	e8 bb f6 ff ff       	call   802241 <set_block_data>
  802b86:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b8d:	75 17                	jne    802ba6 <alloc_block_BF+0x47a>
  802b8f:	83 ec 04             	sub    $0x4,%esp
  802b92:	68 eb 44 80 00       	push   $0x8044eb
  802b97:	68 58 01 00 00       	push   $0x158
  802b9c:	68 09 45 80 00       	push   $0x804509
  802ba1:	e8 f2 d7 ff ff       	call   800398 <_panic>
  802ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	74 10                	je     802bbf <alloc_block_BF+0x493>
  802baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb7:	8b 52 04             	mov    0x4(%edx),%edx
  802bba:	89 50 04             	mov    %edx,0x4(%eax)
  802bbd:	eb 0b                	jmp    802bca <alloc_block_BF+0x49e>
  802bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc2:	8b 40 04             	mov    0x4(%eax),%eax
  802bc5:	a3 30 50 80 00       	mov    %eax,0x805030
  802bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	85 c0                	test   %eax,%eax
  802bd2:	74 0f                	je     802be3 <alloc_block_BF+0x4b7>
  802bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd7:	8b 40 04             	mov    0x4(%eax),%eax
  802bda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bdd:	8b 12                	mov    (%edx),%edx
  802bdf:	89 10                	mov    %edx,(%eax)
  802be1:	eb 0a                	jmp    802bed <alloc_block_BF+0x4c1>
  802be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c00:	a1 38 50 80 00       	mov    0x805038,%eax
  802c05:	48                   	dec    %eax
  802c06:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0e:	e9 fc 00 00 00       	jmp    802d0f <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	83 c0 08             	add    $0x8,%eax
  802c19:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c1c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c23:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c29:	01 d0                	add    %edx,%eax
  802c2b:	48                   	dec    %eax
  802c2c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c2f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c32:	ba 00 00 00 00       	mov    $0x0,%edx
  802c37:	f7 75 c4             	divl   -0x3c(%ebp)
  802c3a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c3d:	29 d0                	sub    %edx,%eax
  802c3f:	c1 e8 0c             	shr    $0xc,%eax
  802c42:	83 ec 0c             	sub    $0xc,%esp
  802c45:	50                   	push   %eax
  802c46:	e8 a4 e7 ff ff       	call   8013ef <sbrk>
  802c4b:	83 c4 10             	add    $0x10,%esp
  802c4e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c51:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c55:	75 0a                	jne    802c61 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c57:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5c:	e9 ae 00 00 00       	jmp    802d0f <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c61:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c68:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c6b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c6e:	01 d0                	add    %edx,%eax
  802c70:	48                   	dec    %eax
  802c71:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c74:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c77:	ba 00 00 00 00       	mov    $0x0,%edx
  802c7c:	f7 75 b8             	divl   -0x48(%ebp)
  802c7f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c82:	29 d0                	sub    %edx,%eax
  802c84:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c87:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c8a:	01 d0                	add    %edx,%eax
  802c8c:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c91:	a1 40 50 80 00       	mov    0x805040,%eax
  802c96:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c9c:	83 ec 0c             	sub    $0xc,%esp
  802c9f:	68 b0 45 80 00       	push   $0x8045b0
  802ca4:	e8 ac d9 ff ff       	call   800655 <cprintf>
  802ca9:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802cac:	83 ec 08             	sub    $0x8,%esp
  802caf:	ff 75 bc             	pushl  -0x44(%ebp)
  802cb2:	68 b5 45 80 00       	push   $0x8045b5
  802cb7:	e8 99 d9 ff ff       	call   800655 <cprintf>
  802cbc:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cbf:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cc6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cc9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ccc:	01 d0                	add    %edx,%eax
  802cce:	48                   	dec    %eax
  802ccf:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802cd2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cd5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cda:	f7 75 b0             	divl   -0x50(%ebp)
  802cdd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ce0:	29 d0                	sub    %edx,%eax
  802ce2:	83 ec 04             	sub    $0x4,%esp
  802ce5:	6a 01                	push   $0x1
  802ce7:	50                   	push   %eax
  802ce8:	ff 75 bc             	pushl  -0x44(%ebp)
  802ceb:	e8 51 f5 ff ff       	call   802241 <set_block_data>
  802cf0:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802cf3:	83 ec 0c             	sub    $0xc,%esp
  802cf6:	ff 75 bc             	pushl  -0x44(%ebp)
  802cf9:	e8 36 04 00 00       	call   803134 <free_block>
  802cfe:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d01:	83 ec 0c             	sub    $0xc,%esp
  802d04:	ff 75 08             	pushl  0x8(%ebp)
  802d07:	e8 20 fa ff ff       	call   80272c <alloc_block_BF>
  802d0c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d0f:	c9                   	leave  
  802d10:	c3                   	ret    

00802d11 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d11:	55                   	push   %ebp
  802d12:	89 e5                	mov    %esp,%ebp
  802d14:	53                   	push   %ebx
  802d15:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d2a:	74 1e                	je     802d4a <merging+0x39>
  802d2c:	ff 75 08             	pushl  0x8(%ebp)
  802d2f:	e8 bc f1 ff ff       	call   801ef0 <get_block_size>
  802d34:	83 c4 04             	add    $0x4,%esp
  802d37:	89 c2                	mov    %eax,%edx
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	01 d0                	add    %edx,%eax
  802d3e:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d41:	75 07                	jne    802d4a <merging+0x39>
		prev_is_free = 1;
  802d43:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d4e:	74 1e                	je     802d6e <merging+0x5d>
  802d50:	ff 75 10             	pushl  0x10(%ebp)
  802d53:	e8 98 f1 ff ff       	call   801ef0 <get_block_size>
  802d58:	83 c4 04             	add    $0x4,%esp
  802d5b:	89 c2                	mov    %eax,%edx
  802d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  802d60:	01 d0                	add    %edx,%eax
  802d62:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d65:	75 07                	jne    802d6e <merging+0x5d>
		next_is_free = 1;
  802d67:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d72:	0f 84 cc 00 00 00    	je     802e44 <merging+0x133>
  802d78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d7c:	0f 84 c2 00 00 00    	je     802e44 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d82:	ff 75 08             	pushl  0x8(%ebp)
  802d85:	e8 66 f1 ff ff       	call   801ef0 <get_block_size>
  802d8a:	83 c4 04             	add    $0x4,%esp
  802d8d:	89 c3                	mov    %eax,%ebx
  802d8f:	ff 75 10             	pushl  0x10(%ebp)
  802d92:	e8 59 f1 ff ff       	call   801ef0 <get_block_size>
  802d97:	83 c4 04             	add    $0x4,%esp
  802d9a:	01 c3                	add    %eax,%ebx
  802d9c:	ff 75 0c             	pushl  0xc(%ebp)
  802d9f:	e8 4c f1 ff ff       	call   801ef0 <get_block_size>
  802da4:	83 c4 04             	add    $0x4,%esp
  802da7:	01 d8                	add    %ebx,%eax
  802da9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dac:	6a 00                	push   $0x0
  802dae:	ff 75 ec             	pushl  -0x14(%ebp)
  802db1:	ff 75 08             	pushl  0x8(%ebp)
  802db4:	e8 88 f4 ff ff       	call   802241 <set_block_data>
  802db9:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802dbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dc0:	75 17                	jne    802dd9 <merging+0xc8>
  802dc2:	83 ec 04             	sub    $0x4,%esp
  802dc5:	68 eb 44 80 00       	push   $0x8044eb
  802dca:	68 7d 01 00 00       	push   $0x17d
  802dcf:	68 09 45 80 00       	push   $0x804509
  802dd4:	e8 bf d5 ff ff       	call   800398 <_panic>
  802dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ddc:	8b 00                	mov    (%eax),%eax
  802dde:	85 c0                	test   %eax,%eax
  802de0:	74 10                	je     802df2 <merging+0xe1>
  802de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dea:	8b 52 04             	mov    0x4(%edx),%edx
  802ded:	89 50 04             	mov    %edx,0x4(%eax)
  802df0:	eb 0b                	jmp    802dfd <merging+0xec>
  802df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df5:	8b 40 04             	mov    0x4(%eax),%eax
  802df8:	a3 30 50 80 00       	mov    %eax,0x805030
  802dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e00:	8b 40 04             	mov    0x4(%eax),%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	74 0f                	je     802e16 <merging+0x105>
  802e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e0a:	8b 40 04             	mov    0x4(%eax),%eax
  802e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e10:	8b 12                	mov    (%edx),%edx
  802e12:	89 10                	mov    %edx,(%eax)
  802e14:	eb 0a                	jmp    802e20 <merging+0x10f>
  802e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e19:	8b 00                	mov    (%eax),%eax
  802e1b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e33:	a1 38 50 80 00       	mov    0x805038,%eax
  802e38:	48                   	dec    %eax
  802e39:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e3e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e3f:	e9 ea 02 00 00       	jmp    80312e <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e48:	74 3b                	je     802e85 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e4a:	83 ec 0c             	sub    $0xc,%esp
  802e4d:	ff 75 08             	pushl  0x8(%ebp)
  802e50:	e8 9b f0 ff ff       	call   801ef0 <get_block_size>
  802e55:	83 c4 10             	add    $0x10,%esp
  802e58:	89 c3                	mov    %eax,%ebx
  802e5a:	83 ec 0c             	sub    $0xc,%esp
  802e5d:	ff 75 10             	pushl  0x10(%ebp)
  802e60:	e8 8b f0 ff ff       	call   801ef0 <get_block_size>
  802e65:	83 c4 10             	add    $0x10,%esp
  802e68:	01 d8                	add    %ebx,%eax
  802e6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e6d:	83 ec 04             	sub    $0x4,%esp
  802e70:	6a 00                	push   $0x0
  802e72:	ff 75 e8             	pushl  -0x18(%ebp)
  802e75:	ff 75 08             	pushl  0x8(%ebp)
  802e78:	e8 c4 f3 ff ff       	call   802241 <set_block_data>
  802e7d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e80:	e9 a9 02 00 00       	jmp    80312e <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e89:	0f 84 2d 01 00 00    	je     802fbc <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e8f:	83 ec 0c             	sub    $0xc,%esp
  802e92:	ff 75 10             	pushl  0x10(%ebp)
  802e95:	e8 56 f0 ff ff       	call   801ef0 <get_block_size>
  802e9a:	83 c4 10             	add    $0x10,%esp
  802e9d:	89 c3                	mov    %eax,%ebx
  802e9f:	83 ec 0c             	sub    $0xc,%esp
  802ea2:	ff 75 0c             	pushl  0xc(%ebp)
  802ea5:	e8 46 f0 ff ff       	call   801ef0 <get_block_size>
  802eaa:	83 c4 10             	add    $0x10,%esp
  802ead:	01 d8                	add    %ebx,%eax
  802eaf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802eb2:	83 ec 04             	sub    $0x4,%esp
  802eb5:	6a 00                	push   $0x0
  802eb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  802eba:	ff 75 10             	pushl  0x10(%ebp)
  802ebd:	e8 7f f3 ff ff       	call   802241 <set_block_data>
  802ec2:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ec5:	8b 45 10             	mov    0x10(%ebp),%eax
  802ec8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802ecb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ecf:	74 06                	je     802ed7 <merging+0x1c6>
  802ed1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ed5:	75 17                	jne    802eee <merging+0x1dd>
  802ed7:	83 ec 04             	sub    $0x4,%esp
  802eda:	68 c4 45 80 00       	push   $0x8045c4
  802edf:	68 8d 01 00 00       	push   $0x18d
  802ee4:	68 09 45 80 00       	push   $0x804509
  802ee9:	e8 aa d4 ff ff       	call   800398 <_panic>
  802eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef1:	8b 50 04             	mov    0x4(%eax),%edx
  802ef4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef7:	89 50 04             	mov    %edx,0x4(%eax)
  802efa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802efd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f00:	89 10                	mov    %edx,(%eax)
  802f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f05:	8b 40 04             	mov    0x4(%eax),%eax
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	74 0d                	je     802f19 <merging+0x208>
  802f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f15:	89 10                	mov    %edx,(%eax)
  802f17:	eb 08                	jmp    802f21 <merging+0x210>
  802f19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f27:	89 50 04             	mov    %edx,0x4(%eax)
  802f2a:	a1 38 50 80 00       	mov    0x805038,%eax
  802f2f:	40                   	inc    %eax
  802f30:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f39:	75 17                	jne    802f52 <merging+0x241>
  802f3b:	83 ec 04             	sub    $0x4,%esp
  802f3e:	68 eb 44 80 00       	push   $0x8044eb
  802f43:	68 8e 01 00 00       	push   $0x18e
  802f48:	68 09 45 80 00       	push   $0x804509
  802f4d:	e8 46 d4 ff ff       	call   800398 <_panic>
  802f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	74 10                	je     802f6b <merging+0x25a>
  802f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5e:	8b 00                	mov    (%eax),%eax
  802f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f63:	8b 52 04             	mov    0x4(%edx),%edx
  802f66:	89 50 04             	mov    %edx,0x4(%eax)
  802f69:	eb 0b                	jmp    802f76 <merging+0x265>
  802f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6e:	8b 40 04             	mov    0x4(%eax),%eax
  802f71:	a3 30 50 80 00       	mov    %eax,0x805030
  802f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f79:	8b 40 04             	mov    0x4(%eax),%eax
  802f7c:	85 c0                	test   %eax,%eax
  802f7e:	74 0f                	je     802f8f <merging+0x27e>
  802f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f83:	8b 40 04             	mov    0x4(%eax),%eax
  802f86:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f89:	8b 12                	mov    (%edx),%edx
  802f8b:	89 10                	mov    %edx,(%eax)
  802f8d:	eb 0a                	jmp    802f99 <merging+0x288>
  802f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fac:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb1:	48                   	dec    %eax
  802fb2:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fb7:	e9 72 01 00 00       	jmp    80312e <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  802fbf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802fc2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc6:	74 79                	je     803041 <merging+0x330>
  802fc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fcc:	74 73                	je     803041 <merging+0x330>
  802fce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd2:	74 06                	je     802fda <merging+0x2c9>
  802fd4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fd8:	75 17                	jne    802ff1 <merging+0x2e0>
  802fda:	83 ec 04             	sub    $0x4,%esp
  802fdd:	68 7c 45 80 00       	push   $0x80457c
  802fe2:	68 94 01 00 00       	push   $0x194
  802fe7:	68 09 45 80 00       	push   $0x804509
  802fec:	e8 a7 d3 ff ff       	call   800398 <_panic>
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	8b 10                	mov    (%eax),%edx
  802ff6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff9:	89 10                	mov    %edx,(%eax)
  802ffb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ffe:	8b 00                	mov    (%eax),%eax
  803000:	85 c0                	test   %eax,%eax
  803002:	74 0b                	je     80300f <merging+0x2fe>
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	8b 00                	mov    (%eax),%eax
  803009:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80300c:	89 50 04             	mov    %edx,0x4(%eax)
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803015:	89 10                	mov    %edx,(%eax)
  803017:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301a:	8b 55 08             	mov    0x8(%ebp),%edx
  80301d:	89 50 04             	mov    %edx,0x4(%eax)
  803020:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803023:	8b 00                	mov    (%eax),%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	75 08                	jne    803031 <merging+0x320>
  803029:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302c:	a3 30 50 80 00       	mov    %eax,0x805030
  803031:	a1 38 50 80 00       	mov    0x805038,%eax
  803036:	40                   	inc    %eax
  803037:	a3 38 50 80 00       	mov    %eax,0x805038
  80303c:	e9 ce 00 00 00       	jmp    80310f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803041:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803045:	74 65                	je     8030ac <merging+0x39b>
  803047:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80304b:	75 17                	jne    803064 <merging+0x353>
  80304d:	83 ec 04             	sub    $0x4,%esp
  803050:	68 58 45 80 00       	push   $0x804558
  803055:	68 95 01 00 00       	push   $0x195
  80305a:	68 09 45 80 00       	push   $0x804509
  80305f:	e8 34 d3 ff ff       	call   800398 <_panic>
  803064:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80306a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306d:	89 50 04             	mov    %edx,0x4(%eax)
  803070:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803073:	8b 40 04             	mov    0x4(%eax),%eax
  803076:	85 c0                	test   %eax,%eax
  803078:	74 0c                	je     803086 <merging+0x375>
  80307a:	a1 30 50 80 00       	mov    0x805030,%eax
  80307f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803082:	89 10                	mov    %edx,(%eax)
  803084:	eb 08                	jmp    80308e <merging+0x37d>
  803086:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803089:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80308e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803091:	a3 30 50 80 00       	mov    %eax,0x805030
  803096:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803099:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309f:	a1 38 50 80 00       	mov    0x805038,%eax
  8030a4:	40                   	inc    %eax
  8030a5:	a3 38 50 80 00       	mov    %eax,0x805038
  8030aa:	eb 63                	jmp    80310f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030b0:	75 17                	jne    8030c9 <merging+0x3b8>
  8030b2:	83 ec 04             	sub    $0x4,%esp
  8030b5:	68 24 45 80 00       	push   $0x804524
  8030ba:	68 98 01 00 00       	push   $0x198
  8030bf:	68 09 45 80 00       	push   $0x804509
  8030c4:	e8 cf d2 ff ff       	call   800398 <_panic>
  8030c9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d2:	89 10                	mov    %edx,(%eax)
  8030d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	85 c0                	test   %eax,%eax
  8030db:	74 0d                	je     8030ea <merging+0x3d9>
  8030dd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030e5:	89 50 04             	mov    %edx,0x4(%eax)
  8030e8:	eb 08                	jmp    8030f2 <merging+0x3e1>
  8030ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ed:	a3 30 50 80 00       	mov    %eax,0x805030
  8030f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803104:	a1 38 50 80 00       	mov    0x805038,%eax
  803109:	40                   	inc    %eax
  80310a:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80310f:	83 ec 0c             	sub    $0xc,%esp
  803112:	ff 75 10             	pushl  0x10(%ebp)
  803115:	e8 d6 ed ff ff       	call   801ef0 <get_block_size>
  80311a:	83 c4 10             	add    $0x10,%esp
  80311d:	83 ec 04             	sub    $0x4,%esp
  803120:	6a 00                	push   $0x0
  803122:	50                   	push   %eax
  803123:	ff 75 10             	pushl  0x10(%ebp)
  803126:	e8 16 f1 ff ff       	call   802241 <set_block_data>
  80312b:	83 c4 10             	add    $0x10,%esp
	}
}
  80312e:	90                   	nop
  80312f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803132:	c9                   	leave  
  803133:	c3                   	ret    

00803134 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803134:	55                   	push   %ebp
  803135:	89 e5                	mov    %esp,%ebp
  803137:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80313a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80313f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803142:	a1 30 50 80 00       	mov    0x805030,%eax
  803147:	3b 45 08             	cmp    0x8(%ebp),%eax
  80314a:	73 1b                	jae    803167 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80314c:	a1 30 50 80 00       	mov    0x805030,%eax
  803151:	83 ec 04             	sub    $0x4,%esp
  803154:	ff 75 08             	pushl  0x8(%ebp)
  803157:	6a 00                	push   $0x0
  803159:	50                   	push   %eax
  80315a:	e8 b2 fb ff ff       	call   802d11 <merging>
  80315f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803162:	e9 8b 00 00 00       	jmp    8031f2 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803167:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80316c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80316f:	76 18                	jbe    803189 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803171:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803176:	83 ec 04             	sub    $0x4,%esp
  803179:	ff 75 08             	pushl  0x8(%ebp)
  80317c:	50                   	push   %eax
  80317d:	6a 00                	push   $0x0
  80317f:	e8 8d fb ff ff       	call   802d11 <merging>
  803184:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803187:	eb 69                	jmp    8031f2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803189:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80318e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803191:	eb 39                	jmp    8031cc <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803196:	3b 45 08             	cmp    0x8(%ebp),%eax
  803199:	73 29                	jae    8031c4 <free_block+0x90>
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	8b 00                	mov    (%eax),%eax
  8031a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a3:	76 1f                	jbe    8031c4 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	8b 00                	mov    (%eax),%eax
  8031aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031ad:	83 ec 04             	sub    $0x4,%esp
  8031b0:	ff 75 08             	pushl  0x8(%ebp)
  8031b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8031b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8031b9:	e8 53 fb ff ff       	call   802d11 <merging>
  8031be:	83 c4 10             	add    $0x10,%esp
			break;
  8031c1:	90                   	nop
		}
	}
}
  8031c2:	eb 2e                	jmp    8031f2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031c4:	a1 34 50 80 00       	mov    0x805034,%eax
  8031c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d0:	74 07                	je     8031d9 <free_block+0xa5>
  8031d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d5:	8b 00                	mov    (%eax),%eax
  8031d7:	eb 05                	jmp    8031de <free_block+0xaa>
  8031d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031de:	a3 34 50 80 00       	mov    %eax,0x805034
  8031e3:	a1 34 50 80 00       	mov    0x805034,%eax
  8031e8:	85 c0                	test   %eax,%eax
  8031ea:	75 a7                	jne    803193 <free_block+0x5f>
  8031ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f0:	75 a1                	jne    803193 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031f2:	90                   	nop
  8031f3:	c9                   	leave  
  8031f4:	c3                   	ret    

008031f5 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8031f5:	55                   	push   %ebp
  8031f6:	89 e5                	mov    %esp,%ebp
  8031f8:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8031fb:	ff 75 08             	pushl  0x8(%ebp)
  8031fe:	e8 ed ec ff ff       	call   801ef0 <get_block_size>
  803203:	83 c4 04             	add    $0x4,%esp
  803206:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803209:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803210:	eb 17                	jmp    803229 <copy_data+0x34>
  803212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803215:	8b 45 0c             	mov    0xc(%ebp),%eax
  803218:	01 c2                	add    %eax,%edx
  80321a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	01 c8                	add    %ecx,%eax
  803222:	8a 00                	mov    (%eax),%al
  803224:	88 02                	mov    %al,(%edx)
  803226:	ff 45 fc             	incl   -0x4(%ebp)
  803229:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80322c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80322f:	72 e1                	jb     803212 <copy_data+0x1d>
}
  803231:	90                   	nop
  803232:	c9                   	leave  
  803233:	c3                   	ret    

00803234 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803234:	55                   	push   %ebp
  803235:	89 e5                	mov    %esp,%ebp
  803237:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80323a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323e:	75 23                	jne    803263 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803240:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803244:	74 13                	je     803259 <realloc_block_FF+0x25>
  803246:	83 ec 0c             	sub    $0xc,%esp
  803249:	ff 75 0c             	pushl  0xc(%ebp)
  80324c:	e8 1f f0 ff ff       	call   802270 <alloc_block_FF>
  803251:	83 c4 10             	add    $0x10,%esp
  803254:	e9 f4 06 00 00       	jmp    80394d <realloc_block_FF+0x719>
		return NULL;
  803259:	b8 00 00 00 00       	mov    $0x0,%eax
  80325e:	e9 ea 06 00 00       	jmp    80394d <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803263:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803267:	75 18                	jne    803281 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803269:	83 ec 0c             	sub    $0xc,%esp
  80326c:	ff 75 08             	pushl  0x8(%ebp)
  80326f:	e8 c0 fe ff ff       	call   803134 <free_block>
  803274:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803277:	b8 00 00 00 00       	mov    $0x0,%eax
  80327c:	e9 cc 06 00 00       	jmp    80394d <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803281:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803285:	77 07                	ja     80328e <realloc_block_FF+0x5a>
  803287:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80328e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803291:	83 e0 01             	and    $0x1,%eax
  803294:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329a:	83 c0 08             	add    $0x8,%eax
  80329d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032a0:	83 ec 0c             	sub    $0xc,%esp
  8032a3:	ff 75 08             	pushl  0x8(%ebp)
  8032a6:	e8 45 ec ff ff       	call   801ef0 <get_block_size>
  8032ab:	83 c4 10             	add    $0x10,%esp
  8032ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b4:	83 e8 08             	sub    $0x8,%eax
  8032b7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	83 e8 04             	sub    $0x4,%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	83 e0 fe             	and    $0xfffffffe,%eax
  8032c5:	89 c2                	mov    %eax,%edx
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	01 d0                	add    %edx,%eax
  8032cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032cf:	83 ec 0c             	sub    $0xc,%esp
  8032d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032d5:	e8 16 ec ff ff       	call   801ef0 <get_block_size>
  8032da:	83 c4 10             	add    $0x10,%esp
  8032dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e3:	83 e8 08             	sub    $0x8,%eax
  8032e6:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ec:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032ef:	75 08                	jne    8032f9 <realloc_block_FF+0xc5>
	{
		 return va;
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	e9 54 06 00 00       	jmp    80394d <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8032f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032fc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032ff:	0f 83 e5 03 00 00    	jae    8036ea <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803308:	2b 45 0c             	sub    0xc(%ebp),%eax
  80330b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80330e:	83 ec 0c             	sub    $0xc,%esp
  803311:	ff 75 e4             	pushl  -0x1c(%ebp)
  803314:	e8 f0 eb ff ff       	call   801f09 <is_free_block>
  803319:	83 c4 10             	add    $0x10,%esp
  80331c:	84 c0                	test   %al,%al
  80331e:	0f 84 3b 01 00 00    	je     80345f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803324:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803327:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80332a:	01 d0                	add    %edx,%eax
  80332c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80332f:	83 ec 04             	sub    $0x4,%esp
  803332:	6a 01                	push   $0x1
  803334:	ff 75 f0             	pushl  -0x10(%ebp)
  803337:	ff 75 08             	pushl  0x8(%ebp)
  80333a:	e8 02 ef ff ff       	call   802241 <set_block_data>
  80333f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	83 e8 04             	sub    $0x4,%eax
  803348:	8b 00                	mov    (%eax),%eax
  80334a:	83 e0 fe             	and    $0xfffffffe,%eax
  80334d:	89 c2                	mov    %eax,%edx
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	01 d0                	add    %edx,%eax
  803354:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803357:	83 ec 04             	sub    $0x4,%esp
  80335a:	6a 00                	push   $0x0
  80335c:	ff 75 cc             	pushl  -0x34(%ebp)
  80335f:	ff 75 c8             	pushl  -0x38(%ebp)
  803362:	e8 da ee ff ff       	call   802241 <set_block_data>
  803367:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80336a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80336e:	74 06                	je     803376 <realloc_block_FF+0x142>
  803370:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803374:	75 17                	jne    80338d <realloc_block_FF+0x159>
  803376:	83 ec 04             	sub    $0x4,%esp
  803379:	68 7c 45 80 00       	push   $0x80457c
  80337e:	68 f6 01 00 00       	push   $0x1f6
  803383:	68 09 45 80 00       	push   $0x804509
  803388:	e8 0b d0 ff ff       	call   800398 <_panic>
  80338d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803390:	8b 10                	mov    (%eax),%edx
  803392:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803395:	89 10                	mov    %edx,(%eax)
  803397:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80339a:	8b 00                	mov    (%eax),%eax
  80339c:	85 c0                	test   %eax,%eax
  80339e:	74 0b                	je     8033ab <realloc_block_FF+0x177>
  8033a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a3:	8b 00                	mov    (%eax),%eax
  8033a5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033a8:	89 50 04             	mov    %edx,0x4(%eax)
  8033ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ae:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033b1:	89 10                	mov    %edx,(%eax)
  8033b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033b9:	89 50 04             	mov    %edx,0x4(%eax)
  8033bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	85 c0                	test   %eax,%eax
  8033c3:	75 08                	jne    8033cd <realloc_block_FF+0x199>
  8033c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033c8:	a3 30 50 80 00       	mov    %eax,0x805030
  8033cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d2:	40                   	inc    %eax
  8033d3:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033dc:	75 17                	jne    8033f5 <realloc_block_FF+0x1c1>
  8033de:	83 ec 04             	sub    $0x4,%esp
  8033e1:	68 eb 44 80 00       	push   $0x8044eb
  8033e6:	68 f7 01 00 00       	push   $0x1f7
  8033eb:	68 09 45 80 00       	push   $0x804509
  8033f0:	e8 a3 cf ff ff       	call   800398 <_panic>
  8033f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f8:	8b 00                	mov    (%eax),%eax
  8033fa:	85 c0                	test   %eax,%eax
  8033fc:	74 10                	je     80340e <realloc_block_FF+0x1da>
  8033fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803401:	8b 00                	mov    (%eax),%eax
  803403:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803406:	8b 52 04             	mov    0x4(%edx),%edx
  803409:	89 50 04             	mov    %edx,0x4(%eax)
  80340c:	eb 0b                	jmp    803419 <realloc_block_FF+0x1e5>
  80340e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803411:	8b 40 04             	mov    0x4(%eax),%eax
  803414:	a3 30 50 80 00       	mov    %eax,0x805030
  803419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341c:	8b 40 04             	mov    0x4(%eax),%eax
  80341f:	85 c0                	test   %eax,%eax
  803421:	74 0f                	je     803432 <realloc_block_FF+0x1fe>
  803423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803426:	8b 40 04             	mov    0x4(%eax),%eax
  803429:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80342c:	8b 12                	mov    (%edx),%edx
  80342e:	89 10                	mov    %edx,(%eax)
  803430:	eb 0a                	jmp    80343c <realloc_block_FF+0x208>
  803432:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803435:	8b 00                	mov    (%eax),%eax
  803437:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80343c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803448:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344f:	a1 38 50 80 00       	mov    0x805038,%eax
  803454:	48                   	dec    %eax
  803455:	a3 38 50 80 00       	mov    %eax,0x805038
  80345a:	e9 83 02 00 00       	jmp    8036e2 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80345f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803463:	0f 86 69 02 00 00    	jbe    8036d2 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803469:	83 ec 04             	sub    $0x4,%esp
  80346c:	6a 01                	push   $0x1
  80346e:	ff 75 f0             	pushl  -0x10(%ebp)
  803471:	ff 75 08             	pushl  0x8(%ebp)
  803474:	e8 c8 ed ff ff       	call   802241 <set_block_data>
  803479:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80347c:	8b 45 08             	mov    0x8(%ebp),%eax
  80347f:	83 e8 04             	sub    $0x4,%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	83 e0 fe             	and    $0xfffffffe,%eax
  803487:	89 c2                	mov    %eax,%edx
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	01 d0                	add    %edx,%eax
  80348e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803491:	a1 38 50 80 00       	mov    0x805038,%eax
  803496:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803499:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80349d:	75 68                	jne    803507 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80349f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034a3:	75 17                	jne    8034bc <realloc_block_FF+0x288>
  8034a5:	83 ec 04             	sub    $0x4,%esp
  8034a8:	68 24 45 80 00       	push   $0x804524
  8034ad:	68 06 02 00 00       	push   $0x206
  8034b2:	68 09 45 80 00       	push   $0x804509
  8034b7:	e8 dc ce ff ff       	call   800398 <_panic>
  8034bc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c5:	89 10                	mov    %edx,(%eax)
  8034c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	85 c0                	test   %eax,%eax
  8034ce:	74 0d                	je     8034dd <realloc_block_FF+0x2a9>
  8034d0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034d8:	89 50 04             	mov    %edx,0x4(%eax)
  8034db:	eb 08                	jmp    8034e5 <realloc_block_FF+0x2b1>
  8034dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8034e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8034fc:	40                   	inc    %eax
  8034fd:	a3 38 50 80 00       	mov    %eax,0x805038
  803502:	e9 b0 01 00 00       	jmp    8036b7 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803507:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80350c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80350f:	76 68                	jbe    803579 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803511:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803515:	75 17                	jne    80352e <realloc_block_FF+0x2fa>
  803517:	83 ec 04             	sub    $0x4,%esp
  80351a:	68 24 45 80 00       	push   $0x804524
  80351f:	68 0b 02 00 00       	push   $0x20b
  803524:	68 09 45 80 00       	push   $0x804509
  803529:	e8 6a ce ff ff       	call   800398 <_panic>
  80352e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803534:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803537:	89 10                	mov    %edx,(%eax)
  803539:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353c:	8b 00                	mov    (%eax),%eax
  80353e:	85 c0                	test   %eax,%eax
  803540:	74 0d                	je     80354f <realloc_block_FF+0x31b>
  803542:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803547:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80354a:	89 50 04             	mov    %edx,0x4(%eax)
  80354d:	eb 08                	jmp    803557 <realloc_block_FF+0x323>
  80354f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803552:	a3 30 50 80 00       	mov    %eax,0x805030
  803557:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80355f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803562:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803569:	a1 38 50 80 00       	mov    0x805038,%eax
  80356e:	40                   	inc    %eax
  80356f:	a3 38 50 80 00       	mov    %eax,0x805038
  803574:	e9 3e 01 00 00       	jmp    8036b7 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803579:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80357e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803581:	73 68                	jae    8035eb <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803583:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803587:	75 17                	jne    8035a0 <realloc_block_FF+0x36c>
  803589:	83 ec 04             	sub    $0x4,%esp
  80358c:	68 58 45 80 00       	push   $0x804558
  803591:	68 10 02 00 00       	push   $0x210
  803596:	68 09 45 80 00       	push   $0x804509
  80359b:	e8 f8 cd ff ff       	call   800398 <_panic>
  8035a0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a9:	89 50 04             	mov    %edx,0x4(%eax)
  8035ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035af:	8b 40 04             	mov    0x4(%eax),%eax
  8035b2:	85 c0                	test   %eax,%eax
  8035b4:	74 0c                	je     8035c2 <realloc_block_FF+0x38e>
  8035b6:	a1 30 50 80 00       	mov    0x805030,%eax
  8035bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035be:	89 10                	mov    %edx,(%eax)
  8035c0:	eb 08                	jmp    8035ca <realloc_block_FF+0x396>
  8035c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8035d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035db:	a1 38 50 80 00       	mov    0x805038,%eax
  8035e0:	40                   	inc    %eax
  8035e1:	a3 38 50 80 00       	mov    %eax,0x805038
  8035e6:	e9 cc 00 00 00       	jmp    8036b7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8035f2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035fa:	e9 8a 00 00 00       	jmp    803689 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8035ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803602:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803605:	73 7a                	jae    803681 <realloc_block_FF+0x44d>
  803607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80360f:	73 70                	jae    803681 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803615:	74 06                	je     80361d <realloc_block_FF+0x3e9>
  803617:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80361b:	75 17                	jne    803634 <realloc_block_FF+0x400>
  80361d:	83 ec 04             	sub    $0x4,%esp
  803620:	68 7c 45 80 00       	push   $0x80457c
  803625:	68 1a 02 00 00       	push   $0x21a
  80362a:	68 09 45 80 00       	push   $0x804509
  80362f:	e8 64 cd ff ff       	call   800398 <_panic>
  803634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803637:	8b 10                	mov    (%eax),%edx
  803639:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363c:	89 10                	mov    %edx,(%eax)
  80363e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803641:	8b 00                	mov    (%eax),%eax
  803643:	85 c0                	test   %eax,%eax
  803645:	74 0b                	je     803652 <realloc_block_FF+0x41e>
  803647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364a:	8b 00                	mov    (%eax),%eax
  80364c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80364f:	89 50 04             	mov    %edx,0x4(%eax)
  803652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803655:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803658:	89 10                	mov    %edx,(%eax)
  80365a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803660:	89 50 04             	mov    %edx,0x4(%eax)
  803663:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803666:	8b 00                	mov    (%eax),%eax
  803668:	85 c0                	test   %eax,%eax
  80366a:	75 08                	jne    803674 <realloc_block_FF+0x440>
  80366c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366f:	a3 30 50 80 00       	mov    %eax,0x805030
  803674:	a1 38 50 80 00       	mov    0x805038,%eax
  803679:	40                   	inc    %eax
  80367a:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80367f:	eb 36                	jmp    8036b7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803681:	a1 34 50 80 00       	mov    0x805034,%eax
  803686:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803689:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80368d:	74 07                	je     803696 <realloc_block_FF+0x462>
  80368f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803692:	8b 00                	mov    (%eax),%eax
  803694:	eb 05                	jmp    80369b <realloc_block_FF+0x467>
  803696:	b8 00 00 00 00       	mov    $0x0,%eax
  80369b:	a3 34 50 80 00       	mov    %eax,0x805034
  8036a0:	a1 34 50 80 00       	mov    0x805034,%eax
  8036a5:	85 c0                	test   %eax,%eax
  8036a7:	0f 85 52 ff ff ff    	jne    8035ff <realloc_block_FF+0x3cb>
  8036ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b1:	0f 85 48 ff ff ff    	jne    8035ff <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036b7:	83 ec 04             	sub    $0x4,%esp
  8036ba:	6a 00                	push   $0x0
  8036bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8036bf:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036c2:	e8 7a eb ff ff       	call   802241 <set_block_data>
  8036c7:	83 c4 10             	add    $0x10,%esp
				return va;
  8036ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cd:	e9 7b 02 00 00       	jmp    80394d <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8036d2:	83 ec 0c             	sub    $0xc,%esp
  8036d5:	68 f9 45 80 00       	push   $0x8045f9
  8036da:	e8 76 cf ff ff       	call   800655 <cprintf>
  8036df:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8036e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e5:	e9 63 02 00 00       	jmp    80394d <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8036ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ed:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036f0:	0f 86 4d 02 00 00    	jbe    803943 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8036f6:	83 ec 0c             	sub    $0xc,%esp
  8036f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036fc:	e8 08 e8 ff ff       	call   801f09 <is_free_block>
  803701:	83 c4 10             	add    $0x10,%esp
  803704:	84 c0                	test   %al,%al
  803706:	0f 84 37 02 00 00    	je     803943 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80370c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803712:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803715:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803718:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80371b:	76 38                	jbe    803755 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80371d:	83 ec 0c             	sub    $0xc,%esp
  803720:	ff 75 08             	pushl  0x8(%ebp)
  803723:	e8 0c fa ff ff       	call   803134 <free_block>
  803728:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80372b:	83 ec 0c             	sub    $0xc,%esp
  80372e:	ff 75 0c             	pushl  0xc(%ebp)
  803731:	e8 3a eb ff ff       	call   802270 <alloc_block_FF>
  803736:	83 c4 10             	add    $0x10,%esp
  803739:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80373c:	83 ec 08             	sub    $0x8,%esp
  80373f:	ff 75 c0             	pushl  -0x40(%ebp)
  803742:	ff 75 08             	pushl  0x8(%ebp)
  803745:	e8 ab fa ff ff       	call   8031f5 <copy_data>
  80374a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80374d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803750:	e9 f8 01 00 00       	jmp    80394d <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803755:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803758:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80375b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80375e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803762:	0f 87 a0 00 00 00    	ja     803808 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803768:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80376c:	75 17                	jne    803785 <realloc_block_FF+0x551>
  80376e:	83 ec 04             	sub    $0x4,%esp
  803771:	68 eb 44 80 00       	push   $0x8044eb
  803776:	68 38 02 00 00       	push   $0x238
  80377b:	68 09 45 80 00       	push   $0x804509
  803780:	e8 13 cc ff ff       	call   800398 <_panic>
  803785:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803788:	8b 00                	mov    (%eax),%eax
  80378a:	85 c0                	test   %eax,%eax
  80378c:	74 10                	je     80379e <realloc_block_FF+0x56a>
  80378e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803791:	8b 00                	mov    (%eax),%eax
  803793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803796:	8b 52 04             	mov    0x4(%edx),%edx
  803799:	89 50 04             	mov    %edx,0x4(%eax)
  80379c:	eb 0b                	jmp    8037a9 <realloc_block_FF+0x575>
  80379e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a1:	8b 40 04             	mov    0x4(%eax),%eax
  8037a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8037a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ac:	8b 40 04             	mov    0x4(%eax),%eax
  8037af:	85 c0                	test   %eax,%eax
  8037b1:	74 0f                	je     8037c2 <realloc_block_FF+0x58e>
  8037b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b6:	8b 40 04             	mov    0x4(%eax),%eax
  8037b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037bc:	8b 12                	mov    (%edx),%edx
  8037be:	89 10                	mov    %edx,(%eax)
  8037c0:	eb 0a                	jmp    8037cc <realloc_block_FF+0x598>
  8037c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c5:	8b 00                	mov    (%eax),%eax
  8037c7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037df:	a1 38 50 80 00       	mov    0x805038,%eax
  8037e4:	48                   	dec    %eax
  8037e5:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f0:	01 d0                	add    %edx,%eax
  8037f2:	83 ec 04             	sub    $0x4,%esp
  8037f5:	6a 01                	push   $0x1
  8037f7:	50                   	push   %eax
  8037f8:	ff 75 08             	pushl  0x8(%ebp)
  8037fb:	e8 41 ea ff ff       	call   802241 <set_block_data>
  803800:	83 c4 10             	add    $0x10,%esp
  803803:	e9 36 01 00 00       	jmp    80393e <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803808:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80380b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80380e:	01 d0                	add    %edx,%eax
  803810:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803813:	83 ec 04             	sub    $0x4,%esp
  803816:	6a 01                	push   $0x1
  803818:	ff 75 f0             	pushl  -0x10(%ebp)
  80381b:	ff 75 08             	pushl  0x8(%ebp)
  80381e:	e8 1e ea ff ff       	call   802241 <set_block_data>
  803823:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803826:	8b 45 08             	mov    0x8(%ebp),%eax
  803829:	83 e8 04             	sub    $0x4,%eax
  80382c:	8b 00                	mov    (%eax),%eax
  80382e:	83 e0 fe             	and    $0xfffffffe,%eax
  803831:	89 c2                	mov    %eax,%edx
  803833:	8b 45 08             	mov    0x8(%ebp),%eax
  803836:	01 d0                	add    %edx,%eax
  803838:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80383b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80383f:	74 06                	je     803847 <realloc_block_FF+0x613>
  803841:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803845:	75 17                	jne    80385e <realloc_block_FF+0x62a>
  803847:	83 ec 04             	sub    $0x4,%esp
  80384a:	68 7c 45 80 00       	push   $0x80457c
  80384f:	68 44 02 00 00       	push   $0x244
  803854:	68 09 45 80 00       	push   $0x804509
  803859:	e8 3a cb ff ff       	call   800398 <_panic>
  80385e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803861:	8b 10                	mov    (%eax),%edx
  803863:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803866:	89 10                	mov    %edx,(%eax)
  803868:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80386b:	8b 00                	mov    (%eax),%eax
  80386d:	85 c0                	test   %eax,%eax
  80386f:	74 0b                	je     80387c <realloc_block_FF+0x648>
  803871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803874:	8b 00                	mov    (%eax),%eax
  803876:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803879:	89 50 04             	mov    %edx,0x4(%eax)
  80387c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803882:	89 10                	mov    %edx,(%eax)
  803884:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803887:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80388a:	89 50 04             	mov    %edx,0x4(%eax)
  80388d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803890:	8b 00                	mov    (%eax),%eax
  803892:	85 c0                	test   %eax,%eax
  803894:	75 08                	jne    80389e <realloc_block_FF+0x66a>
  803896:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803899:	a3 30 50 80 00       	mov    %eax,0x805030
  80389e:	a1 38 50 80 00       	mov    0x805038,%eax
  8038a3:	40                   	inc    %eax
  8038a4:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ad:	75 17                	jne    8038c6 <realloc_block_FF+0x692>
  8038af:	83 ec 04             	sub    $0x4,%esp
  8038b2:	68 eb 44 80 00       	push   $0x8044eb
  8038b7:	68 45 02 00 00       	push   $0x245
  8038bc:	68 09 45 80 00       	push   $0x804509
  8038c1:	e8 d2 ca ff ff       	call   800398 <_panic>
  8038c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c9:	8b 00                	mov    (%eax),%eax
  8038cb:	85 c0                	test   %eax,%eax
  8038cd:	74 10                	je     8038df <realloc_block_FF+0x6ab>
  8038cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d2:	8b 00                	mov    (%eax),%eax
  8038d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d7:	8b 52 04             	mov    0x4(%edx),%edx
  8038da:	89 50 04             	mov    %edx,0x4(%eax)
  8038dd:	eb 0b                	jmp    8038ea <realloc_block_FF+0x6b6>
  8038df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e2:	8b 40 04             	mov    0x4(%eax),%eax
  8038e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8038ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ed:	8b 40 04             	mov    0x4(%eax),%eax
  8038f0:	85 c0                	test   %eax,%eax
  8038f2:	74 0f                	je     803903 <realloc_block_FF+0x6cf>
  8038f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f7:	8b 40 04             	mov    0x4(%eax),%eax
  8038fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038fd:	8b 12                	mov    (%edx),%edx
  8038ff:	89 10                	mov    %edx,(%eax)
  803901:	eb 0a                	jmp    80390d <realloc_block_FF+0x6d9>
  803903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803906:	8b 00                	mov    (%eax),%eax
  803908:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80390d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803910:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803916:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803919:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803920:	a1 38 50 80 00       	mov    0x805038,%eax
  803925:	48                   	dec    %eax
  803926:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80392b:	83 ec 04             	sub    $0x4,%esp
  80392e:	6a 00                	push   $0x0
  803930:	ff 75 bc             	pushl  -0x44(%ebp)
  803933:	ff 75 b8             	pushl  -0x48(%ebp)
  803936:	e8 06 e9 ff ff       	call   802241 <set_block_data>
  80393b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80393e:	8b 45 08             	mov    0x8(%ebp),%eax
  803941:	eb 0a                	jmp    80394d <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803943:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80394a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80394d:	c9                   	leave  
  80394e:	c3                   	ret    

0080394f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80394f:	55                   	push   %ebp
  803950:	89 e5                	mov    %esp,%ebp
  803952:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803955:	83 ec 04             	sub    $0x4,%esp
  803958:	68 00 46 80 00       	push   $0x804600
  80395d:	68 58 02 00 00       	push   $0x258
  803962:	68 09 45 80 00       	push   $0x804509
  803967:	e8 2c ca ff ff       	call   800398 <_panic>

0080396c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80396c:	55                   	push   %ebp
  80396d:	89 e5                	mov    %esp,%ebp
  80396f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803972:	83 ec 04             	sub    $0x4,%esp
  803975:	68 28 46 80 00       	push   $0x804628
  80397a:	68 61 02 00 00       	push   $0x261
  80397f:	68 09 45 80 00       	push   $0x804509
  803984:	e8 0f ca ff ff       	call   800398 <_panic>
  803989:	66 90                	xchg   %ax,%ax
  80398b:	90                   	nop

0080398c <__udivdi3>:
  80398c:	55                   	push   %ebp
  80398d:	57                   	push   %edi
  80398e:	56                   	push   %esi
  80398f:	53                   	push   %ebx
  803990:	83 ec 1c             	sub    $0x1c,%esp
  803993:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803997:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80399b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80399f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039a3:	89 ca                	mov    %ecx,%edx
  8039a5:	89 f8                	mov    %edi,%eax
  8039a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039ab:	85 f6                	test   %esi,%esi
  8039ad:	75 2d                	jne    8039dc <__udivdi3+0x50>
  8039af:	39 cf                	cmp    %ecx,%edi
  8039b1:	77 65                	ja     803a18 <__udivdi3+0x8c>
  8039b3:	89 fd                	mov    %edi,%ebp
  8039b5:	85 ff                	test   %edi,%edi
  8039b7:	75 0b                	jne    8039c4 <__udivdi3+0x38>
  8039b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8039be:	31 d2                	xor    %edx,%edx
  8039c0:	f7 f7                	div    %edi
  8039c2:	89 c5                	mov    %eax,%ebp
  8039c4:	31 d2                	xor    %edx,%edx
  8039c6:	89 c8                	mov    %ecx,%eax
  8039c8:	f7 f5                	div    %ebp
  8039ca:	89 c1                	mov    %eax,%ecx
  8039cc:	89 d8                	mov    %ebx,%eax
  8039ce:	f7 f5                	div    %ebp
  8039d0:	89 cf                	mov    %ecx,%edi
  8039d2:	89 fa                	mov    %edi,%edx
  8039d4:	83 c4 1c             	add    $0x1c,%esp
  8039d7:	5b                   	pop    %ebx
  8039d8:	5e                   	pop    %esi
  8039d9:	5f                   	pop    %edi
  8039da:	5d                   	pop    %ebp
  8039db:	c3                   	ret    
  8039dc:	39 ce                	cmp    %ecx,%esi
  8039de:	77 28                	ja     803a08 <__udivdi3+0x7c>
  8039e0:	0f bd fe             	bsr    %esi,%edi
  8039e3:	83 f7 1f             	xor    $0x1f,%edi
  8039e6:	75 40                	jne    803a28 <__udivdi3+0x9c>
  8039e8:	39 ce                	cmp    %ecx,%esi
  8039ea:	72 0a                	jb     8039f6 <__udivdi3+0x6a>
  8039ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039f0:	0f 87 9e 00 00 00    	ja     803a94 <__udivdi3+0x108>
  8039f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039fb:	89 fa                	mov    %edi,%edx
  8039fd:	83 c4 1c             	add    $0x1c,%esp
  803a00:	5b                   	pop    %ebx
  803a01:	5e                   	pop    %esi
  803a02:	5f                   	pop    %edi
  803a03:	5d                   	pop    %ebp
  803a04:	c3                   	ret    
  803a05:	8d 76 00             	lea    0x0(%esi),%esi
  803a08:	31 ff                	xor    %edi,%edi
  803a0a:	31 c0                	xor    %eax,%eax
  803a0c:	89 fa                	mov    %edi,%edx
  803a0e:	83 c4 1c             	add    $0x1c,%esp
  803a11:	5b                   	pop    %ebx
  803a12:	5e                   	pop    %esi
  803a13:	5f                   	pop    %edi
  803a14:	5d                   	pop    %ebp
  803a15:	c3                   	ret    
  803a16:	66 90                	xchg   %ax,%ax
  803a18:	89 d8                	mov    %ebx,%eax
  803a1a:	f7 f7                	div    %edi
  803a1c:	31 ff                	xor    %edi,%edi
  803a1e:	89 fa                	mov    %edi,%edx
  803a20:	83 c4 1c             	add    $0x1c,%esp
  803a23:	5b                   	pop    %ebx
  803a24:	5e                   	pop    %esi
  803a25:	5f                   	pop    %edi
  803a26:	5d                   	pop    %ebp
  803a27:	c3                   	ret    
  803a28:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a2d:	89 eb                	mov    %ebp,%ebx
  803a2f:	29 fb                	sub    %edi,%ebx
  803a31:	89 f9                	mov    %edi,%ecx
  803a33:	d3 e6                	shl    %cl,%esi
  803a35:	89 c5                	mov    %eax,%ebp
  803a37:	88 d9                	mov    %bl,%cl
  803a39:	d3 ed                	shr    %cl,%ebp
  803a3b:	89 e9                	mov    %ebp,%ecx
  803a3d:	09 f1                	or     %esi,%ecx
  803a3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a43:	89 f9                	mov    %edi,%ecx
  803a45:	d3 e0                	shl    %cl,%eax
  803a47:	89 c5                	mov    %eax,%ebp
  803a49:	89 d6                	mov    %edx,%esi
  803a4b:	88 d9                	mov    %bl,%cl
  803a4d:	d3 ee                	shr    %cl,%esi
  803a4f:	89 f9                	mov    %edi,%ecx
  803a51:	d3 e2                	shl    %cl,%edx
  803a53:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a57:	88 d9                	mov    %bl,%cl
  803a59:	d3 e8                	shr    %cl,%eax
  803a5b:	09 c2                	or     %eax,%edx
  803a5d:	89 d0                	mov    %edx,%eax
  803a5f:	89 f2                	mov    %esi,%edx
  803a61:	f7 74 24 0c          	divl   0xc(%esp)
  803a65:	89 d6                	mov    %edx,%esi
  803a67:	89 c3                	mov    %eax,%ebx
  803a69:	f7 e5                	mul    %ebp
  803a6b:	39 d6                	cmp    %edx,%esi
  803a6d:	72 19                	jb     803a88 <__udivdi3+0xfc>
  803a6f:	74 0b                	je     803a7c <__udivdi3+0xf0>
  803a71:	89 d8                	mov    %ebx,%eax
  803a73:	31 ff                	xor    %edi,%edi
  803a75:	e9 58 ff ff ff       	jmp    8039d2 <__udivdi3+0x46>
  803a7a:	66 90                	xchg   %ax,%ax
  803a7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a80:	89 f9                	mov    %edi,%ecx
  803a82:	d3 e2                	shl    %cl,%edx
  803a84:	39 c2                	cmp    %eax,%edx
  803a86:	73 e9                	jae    803a71 <__udivdi3+0xe5>
  803a88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a8b:	31 ff                	xor    %edi,%edi
  803a8d:	e9 40 ff ff ff       	jmp    8039d2 <__udivdi3+0x46>
  803a92:	66 90                	xchg   %ax,%ax
  803a94:	31 c0                	xor    %eax,%eax
  803a96:	e9 37 ff ff ff       	jmp    8039d2 <__udivdi3+0x46>
  803a9b:	90                   	nop

00803a9c <__umoddi3>:
  803a9c:	55                   	push   %ebp
  803a9d:	57                   	push   %edi
  803a9e:	56                   	push   %esi
  803a9f:	53                   	push   %ebx
  803aa0:	83 ec 1c             	sub    $0x1c,%esp
  803aa3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803aa7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803aab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aaf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ab3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ab7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803abb:	89 f3                	mov    %esi,%ebx
  803abd:	89 fa                	mov    %edi,%edx
  803abf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ac3:	89 34 24             	mov    %esi,(%esp)
  803ac6:	85 c0                	test   %eax,%eax
  803ac8:	75 1a                	jne    803ae4 <__umoddi3+0x48>
  803aca:	39 f7                	cmp    %esi,%edi
  803acc:	0f 86 a2 00 00 00    	jbe    803b74 <__umoddi3+0xd8>
  803ad2:	89 c8                	mov    %ecx,%eax
  803ad4:	89 f2                	mov    %esi,%edx
  803ad6:	f7 f7                	div    %edi
  803ad8:	89 d0                	mov    %edx,%eax
  803ada:	31 d2                	xor    %edx,%edx
  803adc:	83 c4 1c             	add    $0x1c,%esp
  803adf:	5b                   	pop    %ebx
  803ae0:	5e                   	pop    %esi
  803ae1:	5f                   	pop    %edi
  803ae2:	5d                   	pop    %ebp
  803ae3:	c3                   	ret    
  803ae4:	39 f0                	cmp    %esi,%eax
  803ae6:	0f 87 ac 00 00 00    	ja     803b98 <__umoddi3+0xfc>
  803aec:	0f bd e8             	bsr    %eax,%ebp
  803aef:	83 f5 1f             	xor    $0x1f,%ebp
  803af2:	0f 84 ac 00 00 00    	je     803ba4 <__umoddi3+0x108>
  803af8:	bf 20 00 00 00       	mov    $0x20,%edi
  803afd:	29 ef                	sub    %ebp,%edi
  803aff:	89 fe                	mov    %edi,%esi
  803b01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b05:	89 e9                	mov    %ebp,%ecx
  803b07:	d3 e0                	shl    %cl,%eax
  803b09:	89 d7                	mov    %edx,%edi
  803b0b:	89 f1                	mov    %esi,%ecx
  803b0d:	d3 ef                	shr    %cl,%edi
  803b0f:	09 c7                	or     %eax,%edi
  803b11:	89 e9                	mov    %ebp,%ecx
  803b13:	d3 e2                	shl    %cl,%edx
  803b15:	89 14 24             	mov    %edx,(%esp)
  803b18:	89 d8                	mov    %ebx,%eax
  803b1a:	d3 e0                	shl    %cl,%eax
  803b1c:	89 c2                	mov    %eax,%edx
  803b1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b22:	d3 e0                	shl    %cl,%eax
  803b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b28:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b2c:	89 f1                	mov    %esi,%ecx
  803b2e:	d3 e8                	shr    %cl,%eax
  803b30:	09 d0                	or     %edx,%eax
  803b32:	d3 eb                	shr    %cl,%ebx
  803b34:	89 da                	mov    %ebx,%edx
  803b36:	f7 f7                	div    %edi
  803b38:	89 d3                	mov    %edx,%ebx
  803b3a:	f7 24 24             	mull   (%esp)
  803b3d:	89 c6                	mov    %eax,%esi
  803b3f:	89 d1                	mov    %edx,%ecx
  803b41:	39 d3                	cmp    %edx,%ebx
  803b43:	0f 82 87 00 00 00    	jb     803bd0 <__umoddi3+0x134>
  803b49:	0f 84 91 00 00 00    	je     803be0 <__umoddi3+0x144>
  803b4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b53:	29 f2                	sub    %esi,%edx
  803b55:	19 cb                	sbb    %ecx,%ebx
  803b57:	89 d8                	mov    %ebx,%eax
  803b59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b5d:	d3 e0                	shl    %cl,%eax
  803b5f:	89 e9                	mov    %ebp,%ecx
  803b61:	d3 ea                	shr    %cl,%edx
  803b63:	09 d0                	or     %edx,%eax
  803b65:	89 e9                	mov    %ebp,%ecx
  803b67:	d3 eb                	shr    %cl,%ebx
  803b69:	89 da                	mov    %ebx,%edx
  803b6b:	83 c4 1c             	add    $0x1c,%esp
  803b6e:	5b                   	pop    %ebx
  803b6f:	5e                   	pop    %esi
  803b70:	5f                   	pop    %edi
  803b71:	5d                   	pop    %ebp
  803b72:	c3                   	ret    
  803b73:	90                   	nop
  803b74:	89 fd                	mov    %edi,%ebp
  803b76:	85 ff                	test   %edi,%edi
  803b78:	75 0b                	jne    803b85 <__umoddi3+0xe9>
  803b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b7f:	31 d2                	xor    %edx,%edx
  803b81:	f7 f7                	div    %edi
  803b83:	89 c5                	mov    %eax,%ebp
  803b85:	89 f0                	mov    %esi,%eax
  803b87:	31 d2                	xor    %edx,%edx
  803b89:	f7 f5                	div    %ebp
  803b8b:	89 c8                	mov    %ecx,%eax
  803b8d:	f7 f5                	div    %ebp
  803b8f:	89 d0                	mov    %edx,%eax
  803b91:	e9 44 ff ff ff       	jmp    803ada <__umoddi3+0x3e>
  803b96:	66 90                	xchg   %ax,%ax
  803b98:	89 c8                	mov    %ecx,%eax
  803b9a:	89 f2                	mov    %esi,%edx
  803b9c:	83 c4 1c             	add    $0x1c,%esp
  803b9f:	5b                   	pop    %ebx
  803ba0:	5e                   	pop    %esi
  803ba1:	5f                   	pop    %edi
  803ba2:	5d                   	pop    %ebp
  803ba3:	c3                   	ret    
  803ba4:	3b 04 24             	cmp    (%esp),%eax
  803ba7:	72 06                	jb     803baf <__umoddi3+0x113>
  803ba9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bad:	77 0f                	ja     803bbe <__umoddi3+0x122>
  803baf:	89 f2                	mov    %esi,%edx
  803bb1:	29 f9                	sub    %edi,%ecx
  803bb3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bb7:	89 14 24             	mov    %edx,(%esp)
  803bba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bc2:	8b 14 24             	mov    (%esp),%edx
  803bc5:	83 c4 1c             	add    $0x1c,%esp
  803bc8:	5b                   	pop    %ebx
  803bc9:	5e                   	pop    %esi
  803bca:	5f                   	pop    %edi
  803bcb:	5d                   	pop    %ebp
  803bcc:	c3                   	ret    
  803bcd:	8d 76 00             	lea    0x0(%esi),%esi
  803bd0:	2b 04 24             	sub    (%esp),%eax
  803bd3:	19 fa                	sbb    %edi,%edx
  803bd5:	89 d1                	mov    %edx,%ecx
  803bd7:	89 c6                	mov    %eax,%esi
  803bd9:	e9 71 ff ff ff       	jmp    803b4f <__umoddi3+0xb3>
  803bde:	66 90                	xchg   %ax,%ax
  803be0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803be4:	72 ea                	jb     803bd0 <__umoddi3+0x134>
  803be6:	89 d9                	mov    %ebx,%ecx
  803be8:	e9 62 ff ff ff       	jmp    803b4f <__umoddi3+0xb3>
