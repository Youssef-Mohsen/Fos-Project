
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
  80003f:	a1 04 30 80 00       	mov    0x803004,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 04 30 80 00       	mov    0x803004,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 a0 1d 80 00       	push   $0x801da0
  800061:	6a 0d                	push   $0xd
  800063:	68 bc 1d 80 00       	push   $0x801dbc
  800068:	e8 23 03 00 00       	call   800390 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  800074:	e8 9a 17 00 00       	call   801813 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int freeFrames, diff, expected;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 fd 14 00 00       	call   80157e <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 ab 15 00 00       	call   801631 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 d7 1d 80 00       	push   $0x801dd7
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 d6 13 00 00       	call   80146f <sget>
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
  8000b6:	68 dc 1d 80 00       	push   $0x801ddc
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 bc 1d 80 00       	push   $0x801dbc
  8000c2:	e8 c9 02 00 00       	call   800390 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 5b 15 00 00       	call   801631 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 44 15 00 00       	call   801631 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 58 1e 80 00       	push   $0x801e58
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 bc 1d 80 00       	push   $0x801dbc
  800104:	e8 87 02 00 00       	call   800390 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 8a 14 00 00       	call   801598 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 6b 14 00 00       	call   80157e <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 19 15 00 00       	call   801631 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 f0 1e 80 00       	push   $0x801ef0
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 44 13 00 00       	call   80146f <sget>
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
  80014d:	68 dc 1d 80 00       	push   $0x801ddc
  800152:	6a 31                	push   $0x31
  800154:	68 bc 1d 80 00       	push   $0x801dbc
  800159:	e8 32 02 00 00       	call   800390 <_panic>
		expected = 0;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 c4 14 00 00       	call   801631 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 ad 14 00 00       	call   801631 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 58 1e 80 00       	push   $0x801e58
  800194:	6a 34                	push   $0x34
  800196:	68 bc 1d 80 00       	push   $0x801dbc
  80019b:	e8 f0 01 00 00       	call   800390 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 f3 13 00 00       	call   801598 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 0a             	cmp    $0xa,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 f4 1e 80 00       	push   $0x801ef4
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 bc 1d 80 00       	push   $0x801dbc
  8001be:	e8 cd 01 00 00       	call   800390 <_panic>

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
  8001d9:	68 f4 1e 80 00       	push   $0x801ef4
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 bc 1d 80 00       	push   $0x801dbc
  8001e5:	e8 a6 01 00 00       	call   800390 <_panic>

	inctst();
  8001ea:	e8 49 17 00 00       	call   801938 <inctst>

	//sync with master
	while (gettst() != 5) ;
  8001ef:	90                   	nop
  8001f0:	e8 5d 17 00 00       	call   801952 <gettst>
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	75 f6                	jne    8001f0 <_main+0x1b8>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 06                	push   $0x6
  8001ff:	e8 ae 16 00 00       	call   8018b2 <sys_bypassPageFault>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	68 2c 1f 80 00       	push   $0x801f2c
  800212:	e8 36 04 00 00       	call   80064d <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 85 16 00 00       	call   8018b2 <sys_bypassPageFault>
  80022d:	83 c4 10             	add    $0x10,%esp

	inctst();
  800230:	e8 03 17 00 00       	call   801938 <inctst>
	if (*x == 100)
  800235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	83 f8 64             	cmp    $0x64,%eax
  80023d:	75 14                	jne    800253 <_main+0x21b>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 5c 1f 80 00       	push   $0x801f5c
  800247:	6a 4d                	push   $0x4d
  800249:	68 bc 1d 80 00       	push   $0x801dbc
  80024e:	e8 3d 01 00 00       	call   800390 <_panic>
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
  80025f:	e8 96 15 00 00       	call   8017fa <sys_getenvindex>
  800264:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800267:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80026a:	89 d0                	mov    %edx,%eax
  80026c:	c1 e0 02             	shl    $0x2,%eax
  80026f:	01 d0                	add    %edx,%eax
  800271:	01 c0                	add    %eax,%eax
  800273:	01 d0                	add    %edx,%eax
  800275:	c1 e0 02             	shl    $0x2,%eax
  800278:	01 d0                	add    %edx,%eax
  80027a:	01 c0                	add    %eax,%eax
  80027c:	01 d0                	add    %edx,%eax
  80027e:	c1 e0 04             	shl    $0x4,%eax
  800281:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800286:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80028b:	a1 04 30 80 00       	mov    0x803004,%eax
  800290:	8a 40 20             	mov    0x20(%eax),%al
  800293:	84 c0                	test   %al,%al
  800295:	74 0d                	je     8002a4 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800297:	a1 04 30 80 00       	mov    0x803004,%eax
  80029c:	83 c0 20             	add    $0x20,%eax
  80029f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a8:	7e 0a                	jle    8002b4 <libmain+0x5b>
		binaryname = argv[0];
  8002aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ad:	8b 00                	mov    (%eax),%eax
  8002af:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	e8 76 fd ff ff       	call   800038 <_main>
  8002c2:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8002c5:	e8 b4 12 00 00       	call   80157e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 bc 1f 80 00       	push   $0x801fbc
  8002d2:	e8 76 03 00 00       	call   80064d <cprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002da:	a1 04 30 80 00       	mov    0x803004,%eax
  8002df:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8002e5:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ea:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 e4 1f 80 00       	push   $0x801fe4
  8002fa:	e8 4e 03 00 00       	call   80064d <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800302:	a1 04 30 80 00       	mov    0x803004,%eax
  800307:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80030d:	a1 04 30 80 00       	mov    0x803004,%eax
  800312:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800318:	a1 04 30 80 00       	mov    0x803004,%eax
  80031d:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800323:	51                   	push   %ecx
  800324:	52                   	push   %edx
  800325:	50                   	push   %eax
  800326:	68 0c 20 80 00       	push   $0x80200c
  80032b:	e8 1d 03 00 00       	call   80064d <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 04 30 80 00       	mov    0x803004,%eax
  800338:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 64 20 80 00       	push   $0x802064
  800347:	e8 01 03 00 00       	call   80064d <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 bc 1f 80 00       	push   $0x801fbc
  800357:	e8 f1 02 00 00       	call   80064d <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80035f:	e8 34 12 00 00       	call   801598 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800364:	e8 19 00 00 00       	call   800382 <exit>
}
  800369:	90                   	nop
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	6a 00                	push   $0x0
  800377:	e8 4a 14 00 00       	call   8017c6 <sys_destroy_env>
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <exit>:

void
exit(void)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800388:	e8 9f 14 00 00       	call   80182c <sys_exit_env>
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800396:	8d 45 10             	lea    0x10(%ebp),%eax
  800399:	83 c0 04             	add    $0x4,%eax
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039f:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8003a4:	85 c0                	test   %eax,%eax
  8003a6:	74 16                	je     8003be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a8:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	50                   	push   %eax
  8003b1:	68 78 20 80 00       	push   $0x802078
  8003b6:	e8 92 02 00 00       	call   80064d <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 30 80 00       	mov    0x803000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 7d 20 80 00       	push   $0x80207d
  8003cf:	e8 79 02 00 00       	call   80064d <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e0:	50                   	push   %eax
  8003e1:	e8 fc 01 00 00       	call   8005e2 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	6a 00                	push   $0x0
  8003ee:	68 99 20 80 00       	push   $0x802099
  8003f3:	e8 ea 01 00 00       	call   8005e2 <vcprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fb:	e8 82 ff ff ff       	call   800382 <exit>

	// should not return here
	while (1) ;
  800400:	eb fe                	jmp    800400 <_panic+0x70>

00800402 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800408:	a1 04 30 80 00       	mov    0x803004,%eax
  80040d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800413:	8b 45 0c             	mov    0xc(%ebp),%eax
  800416:	39 c2                	cmp    %eax,%edx
  800418:	74 14                	je     80042e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80041a:	83 ec 04             	sub    $0x4,%esp
  80041d:	68 9c 20 80 00       	push   $0x80209c
  800422:	6a 26                	push   $0x26
  800424:	68 e8 20 80 00       	push   $0x8020e8
  800429:	e8 62 ff ff ff       	call   800390 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80043c:	e9 c5 00 00 00       	jmp    800506 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800444:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	01 d0                	add    %edx,%eax
  800450:	8b 00                	mov    (%eax),%eax
  800452:	85 c0                	test   %eax,%eax
  800454:	75 08                	jne    80045e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800456:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800459:	e9 a5 00 00 00       	jmp    800503 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80045e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80046c:	eb 69                	jmp    8004d7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046e:	a1 04 30 80 00       	mov    0x803004,%eax
  800473:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800479:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80047c:	89 d0                	mov    %edx,%eax
  80047e:	01 c0                	add    %eax,%eax
  800480:	01 d0                	add    %edx,%eax
  800482:	c1 e0 03             	shl    $0x3,%eax
  800485:	01 c8                	add    %ecx,%eax
  800487:	8a 40 04             	mov    0x4(%eax),%al
  80048a:	84 c0                	test   %al,%al
  80048c:	75 46                	jne    8004d4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048e:	a1 04 30 80 00       	mov    0x803004,%eax
  800493:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800499:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80049c:	89 d0                	mov    %edx,%eax
  80049e:	01 c0                	add    %eax,%eax
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	c1 e0 03             	shl    $0x3,%eax
  8004a5:	01 c8                	add    %ecx,%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	01 c8                	add    %ecx,%eax
  8004c5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	75 09                	jne    8004d4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004cb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004d2:	eb 15                	jmp    8004e9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d4:	ff 45 e8             	incl   -0x18(%ebp)
  8004d7:	a1 04 30 80 00       	mov    0x803004,%eax
  8004dc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e5:	39 c2                	cmp    %eax,%edx
  8004e7:	77 85                	ja     80046e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004ed:	75 14                	jne    800503 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	68 f4 20 80 00       	push   $0x8020f4
  8004f7:	6a 3a                	push   $0x3a
  8004f9:	68 e8 20 80 00       	push   $0x8020e8
  8004fe:	e8 8d fe ff ff       	call   800390 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800503:	ff 45 f0             	incl   -0x10(%ebp)
  800506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800509:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80050c:	0f 8c 2f ff ff ff    	jl     800441 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800512:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800519:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800520:	eb 26                	jmp    800548 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800522:	a1 04 30 80 00       	mov    0x803004,%eax
  800527:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80052d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	c1 e0 03             	shl    $0x3,%eax
  800539:	01 c8                	add    %ecx,%eax
  80053b:	8a 40 04             	mov    0x4(%eax),%al
  80053e:	3c 01                	cmp    $0x1,%al
  800540:	75 03                	jne    800545 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800542:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800545:	ff 45 e0             	incl   -0x20(%ebp)
  800548:	a1 04 30 80 00       	mov    0x803004,%eax
  80054d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800553:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800556:	39 c2                	cmp    %eax,%edx
  800558:	77 c8                	ja     800522 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80055a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80055d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800560:	74 14                	je     800576 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800562:	83 ec 04             	sub    $0x4,%esp
  800565:	68 48 21 80 00       	push   $0x802148
  80056a:	6a 44                	push   $0x44
  80056c:	68 e8 20 80 00       	push   $0x8020e8
  800571:	e8 1a fe ff ff       	call   800390 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800576:	90                   	nop
  800577:	c9                   	leave  
  800578:	c3                   	ret    

00800579 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800579:	55                   	push   %ebp
  80057a:	89 e5                	mov    %esp,%ebp
  80057c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80057f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 48 01             	lea    0x1(%eax),%ecx
  800587:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058a:	89 0a                	mov    %ecx,(%edx)
  80058c:	8b 55 08             	mov    0x8(%ebp),%edx
  80058f:	88 d1                	mov    %dl,%cl
  800591:	8b 55 0c             	mov    0xc(%ebp),%edx
  800594:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005a2:	75 2c                	jne    8005d0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005a4:	a0 08 30 80 00       	mov    0x803008,%al
  8005a9:	0f b6 c0             	movzbl %al,%eax
  8005ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005af:	8b 12                	mov    (%edx),%edx
  8005b1:	89 d1                	mov    %edx,%ecx
  8005b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b6:	83 c2 08             	add    $0x8,%edx
  8005b9:	83 ec 04             	sub    $0x4,%esp
  8005bc:	50                   	push   %eax
  8005bd:	51                   	push   %ecx
  8005be:	52                   	push   %edx
  8005bf:	e8 78 0f 00 00       	call   80153c <sys_cputs>
  8005c4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d3:	8b 40 04             	mov    0x4(%eax),%eax
  8005d6:	8d 50 01             	lea    0x1(%eax),%edx
  8005d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005df:	90                   	nop
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f2:	00 00 00 
	b.cnt = 0;
  8005f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005fc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005ff:	ff 75 0c             	pushl  0xc(%ebp)
  800602:	ff 75 08             	pushl  0x8(%ebp)
  800605:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060b:	50                   	push   %eax
  80060c:	68 79 05 80 00       	push   $0x800579
  800611:	e8 11 02 00 00       	call   800827 <vprintfmt>
  800616:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800619:	a0 08 30 80 00       	mov    0x803008,%al
  80061e:	0f b6 c0             	movzbl %al,%eax
  800621:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	50                   	push   %eax
  80062b:	52                   	push   %edx
  80062c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800632:	83 c0 08             	add    $0x8,%eax
  800635:	50                   	push   %eax
  800636:	e8 01 0f 00 00       	call   80153c <sys_cputs>
  80063b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80063e:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800645:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80064b:	c9                   	leave  
  80064c:	c3                   	ret    

0080064d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80064d:	55                   	push   %ebp
  80064e:	89 e5                	mov    %esp,%ebp
  800650:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800653:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80065a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 f4             	pushl  -0xc(%ebp)
  800669:	50                   	push   %eax
  80066a:	e8 73 ff ff ff       	call   8005e2 <vcprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800675:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800680:	e8 f9 0e 00 00       	call   80157e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800685:	8d 45 0c             	lea    0xc(%ebp),%eax
  800688:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	ff 75 f4             	pushl  -0xc(%ebp)
  800694:	50                   	push   %eax
  800695:	e8 48 ff ff ff       	call   8005e2 <vcprintf>
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006a0:	e8 f3 0e 00 00       	call   801598 <sys_unlock_cons>
	return cnt;
  8006a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006a8:	c9                   	leave  
  8006a9:	c3                   	ret    

008006aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006aa:	55                   	push   %ebp
  8006ab:	89 e5                	mov    %esp,%ebp
  8006ad:	53                   	push   %ebx
  8006ae:	83 ec 14             	sub    $0x14,%esp
  8006b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006bd:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006c8:	77 55                	ja     80071f <printnum+0x75>
  8006ca:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006cd:	72 05                	jb     8006d4 <printnum+0x2a>
  8006cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006d2:	77 4b                	ja     80071f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006d7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006da:	8b 45 18             	mov    0x18(%ebp),%eax
  8006dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e2:	52                   	push   %edx
  8006e3:	50                   	push   %eax
  8006e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8006ea:	e8 4d 14 00 00       	call   801b3c <__udivdi3>
  8006ef:	83 c4 10             	add    $0x10,%esp
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	ff 75 20             	pushl  0x20(%ebp)
  8006f8:	53                   	push   %ebx
  8006f9:	ff 75 18             	pushl  0x18(%ebp)
  8006fc:	52                   	push   %edx
  8006fd:	50                   	push   %eax
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	ff 75 08             	pushl  0x8(%ebp)
  800704:	e8 a1 ff ff ff       	call   8006aa <printnum>
  800709:	83 c4 20             	add    $0x20,%esp
  80070c:	eb 1a                	jmp    800728 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	ff 75 20             	pushl  0x20(%ebp)
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	ff d0                	call   *%eax
  80071c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80071f:	ff 4d 1c             	decl   0x1c(%ebp)
  800722:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800726:	7f e6                	jg     80070e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800728:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80072b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800733:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800736:	53                   	push   %ebx
  800737:	51                   	push   %ecx
  800738:	52                   	push   %edx
  800739:	50                   	push   %eax
  80073a:	e8 0d 15 00 00       	call   801c4c <__umoddi3>
  80073f:	83 c4 10             	add    $0x10,%esp
  800742:	05 b4 23 80 00       	add    $0x8023b4,%eax
  800747:	8a 00                	mov    (%eax),%al
  800749:	0f be c0             	movsbl %al,%eax
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	ff 75 0c             	pushl  0xc(%ebp)
  800752:	50                   	push   %eax
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	ff d0                	call   *%eax
  800758:	83 c4 10             	add    $0x10,%esp
}
  80075b:	90                   	nop
  80075c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800764:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800768:	7e 1c                	jle    800786 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	8d 50 08             	lea    0x8(%eax),%edx
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	89 10                	mov    %edx,(%eax)
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	83 e8 08             	sub    $0x8,%eax
  80077f:	8b 50 04             	mov    0x4(%eax),%edx
  800782:	8b 00                	mov    (%eax),%eax
  800784:	eb 40                	jmp    8007c6 <getuint+0x65>
	else if (lflag)
  800786:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078a:	74 1e                	je     8007aa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	8d 50 04             	lea    0x4(%eax),%edx
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	89 10                	mov    %edx,(%eax)
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	83 e8 04             	sub    $0x4,%eax
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a8:	eb 1c                	jmp    8007c6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	8d 50 04             	lea    0x4(%eax),%edx
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	89 10                	mov    %edx,(%eax)
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	83 e8 04             	sub    $0x4,%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007c6:	5d                   	pop    %ebp
  8007c7:	c3                   	ret    

008007c8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cf:	7e 1c                	jle    8007ed <getint+0x25>
		return va_arg(*ap, long long);
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	8d 50 08             	lea    0x8(%eax),%edx
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	89 10                	mov    %edx,(%eax)
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	83 e8 08             	sub    $0x8,%eax
  8007e6:	8b 50 04             	mov    0x4(%eax),%edx
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	eb 38                	jmp    800825 <getint+0x5d>
	else if (lflag)
  8007ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f1:	74 1a                	je     80080d <getint+0x45>
		return va_arg(*ap, long);
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	8d 50 04             	lea    0x4(%eax),%edx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	89 10                	mov    %edx,(%eax)
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	99                   	cltd   
  80080b:	eb 18                	jmp    800825 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	8d 50 04             	lea    0x4(%eax),%edx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 10                	mov    %edx,(%eax)
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	99                   	cltd   
}
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	56                   	push   %esi
  80082b:	53                   	push   %ebx
  80082c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082f:	eb 17                	jmp    800848 <vprintfmt+0x21>
			if (ch == '\0')
  800831:	85 db                	test   %ebx,%ebx
  800833:	0f 84 c1 03 00 00    	je     800bfa <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	ff 75 0c             	pushl  0xc(%ebp)
  80083f:	53                   	push   %ebx
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	ff d0                	call   *%eax
  800845:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800848:	8b 45 10             	mov    0x10(%ebp),%eax
  80084b:	8d 50 01             	lea    0x1(%eax),%edx
  80084e:	89 55 10             	mov    %edx,0x10(%ebp)
  800851:	8a 00                	mov    (%eax),%al
  800853:	0f b6 d8             	movzbl %al,%ebx
  800856:	83 fb 25             	cmp    $0x25,%ebx
  800859:	75 d6                	jne    800831 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80085b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80085f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800866:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80086d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800874:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087b:	8b 45 10             	mov    0x10(%ebp),%eax
  80087e:	8d 50 01             	lea    0x1(%eax),%edx
  800881:	89 55 10             	mov    %edx,0x10(%ebp)
  800884:	8a 00                	mov    (%eax),%al
  800886:	0f b6 d8             	movzbl %al,%ebx
  800889:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80088c:	83 f8 5b             	cmp    $0x5b,%eax
  80088f:	0f 87 3d 03 00 00    	ja     800bd2 <vprintfmt+0x3ab>
  800895:	8b 04 85 d8 23 80 00 	mov    0x8023d8(,%eax,4),%eax
  80089c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80089e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008a2:	eb d7                	jmp    80087b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008a4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008a8:	eb d1                	jmp    80087b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b4:	89 d0                	mov    %edx,%eax
  8008b6:	c1 e0 02             	shl    $0x2,%eax
  8008b9:	01 d0                	add    %edx,%eax
  8008bb:	01 c0                	add    %eax,%eax
  8008bd:	01 d8                	add    %ebx,%eax
  8008bf:	83 e8 30             	sub    $0x30,%eax
  8008c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c8:	8a 00                	mov    (%eax),%al
  8008ca:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008cd:	83 fb 2f             	cmp    $0x2f,%ebx
  8008d0:	7e 3e                	jle    800910 <vprintfmt+0xe9>
  8008d2:	83 fb 39             	cmp    $0x39,%ebx
  8008d5:	7f 39                	jg     800910 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008d7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008da:	eb d5                	jmp    8008b1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	83 c0 04             	add    $0x4,%eax
  8008e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e8:	83 e8 04             	sub    $0x4,%eax
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008f0:	eb 1f                	jmp    800911 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f6:	79 83                	jns    80087b <vprintfmt+0x54>
				width = 0;
  8008f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008ff:	e9 77 ff ff ff       	jmp    80087b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800904:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80090b:	e9 6b ff ff ff       	jmp    80087b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800910:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800911:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800915:	0f 89 60 ff ff ff    	jns    80087b <vprintfmt+0x54>
				width = precision, precision = -1;
  80091b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800921:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800928:	e9 4e ff ff ff       	jmp    80087b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80092d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800930:	e9 46 ff ff ff       	jmp    80087b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 c0 04             	add    $0x4,%eax
  80093b:	89 45 14             	mov    %eax,0x14(%ebp)
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	50                   	push   %eax
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			break;
  800955:	e9 9b 02 00 00       	jmp    800bf5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 c0 04             	add    $0x4,%eax
  800960:	89 45 14             	mov    %eax,0x14(%ebp)
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	83 e8 04             	sub    $0x4,%eax
  800969:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80096b:	85 db                	test   %ebx,%ebx
  80096d:	79 02                	jns    800971 <vprintfmt+0x14a>
				err = -err;
  80096f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800971:	83 fb 64             	cmp    $0x64,%ebx
  800974:	7f 0b                	jg     800981 <vprintfmt+0x15a>
  800976:	8b 34 9d 20 22 80 00 	mov    0x802220(,%ebx,4),%esi
  80097d:	85 f6                	test   %esi,%esi
  80097f:	75 19                	jne    80099a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800981:	53                   	push   %ebx
  800982:	68 c5 23 80 00       	push   $0x8023c5
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	ff 75 08             	pushl  0x8(%ebp)
  80098d:	e8 70 02 00 00       	call   800c02 <printfmt>
  800992:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800995:	e9 5b 02 00 00       	jmp    800bf5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80099a:	56                   	push   %esi
  80099b:	68 ce 23 80 00       	push   $0x8023ce
  8009a0:	ff 75 0c             	pushl  0xc(%ebp)
  8009a3:	ff 75 08             	pushl  0x8(%ebp)
  8009a6:	e8 57 02 00 00       	call   800c02 <printfmt>
  8009ab:	83 c4 10             	add    $0x10,%esp
			break;
  8009ae:	e9 42 02 00 00       	jmp    800bf5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 c0 04             	add    $0x4,%eax
  8009b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bf:	83 e8 04             	sub    $0x4,%eax
  8009c2:	8b 30                	mov    (%eax),%esi
  8009c4:	85 f6                	test   %esi,%esi
  8009c6:	75 05                	jne    8009cd <vprintfmt+0x1a6>
				p = "(null)";
  8009c8:	be d1 23 80 00       	mov    $0x8023d1,%esi
			if (width > 0 && padc != '-')
  8009cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d1:	7e 6d                	jle    800a40 <vprintfmt+0x219>
  8009d3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009d7:	74 67                	je     800a40 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	50                   	push   %eax
  8009e0:	56                   	push   %esi
  8009e1:	e8 1e 03 00 00       	call   800d04 <strnlen>
  8009e6:	83 c4 10             	add    $0x10,%esp
  8009e9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009ec:	eb 16                	jmp    800a04 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009ee:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 0c             	pushl  0xc(%ebp)
  8009f8:	50                   	push   %eax
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a01:	ff 4d e4             	decl   -0x1c(%ebp)
  800a04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a08:	7f e4                	jg     8009ee <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0a:	eb 34                	jmp    800a40 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a10:	74 1c                	je     800a2e <vprintfmt+0x207>
  800a12:	83 fb 1f             	cmp    $0x1f,%ebx
  800a15:	7e 05                	jle    800a1c <vprintfmt+0x1f5>
  800a17:	83 fb 7e             	cmp    $0x7e,%ebx
  800a1a:	7e 12                	jle    800a2e <vprintfmt+0x207>
					putch('?', putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	6a 3f                	push   $0x3f
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	ff d0                	call   *%eax
  800a29:	83 c4 10             	add    $0x10,%esp
  800a2c:	eb 0f                	jmp    800a3d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	53                   	push   %ebx
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a40:	89 f0                	mov    %esi,%eax
  800a42:	8d 70 01             	lea    0x1(%eax),%esi
  800a45:	8a 00                	mov    (%eax),%al
  800a47:	0f be d8             	movsbl %al,%ebx
  800a4a:	85 db                	test   %ebx,%ebx
  800a4c:	74 24                	je     800a72 <vprintfmt+0x24b>
  800a4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a52:	78 b8                	js     800a0c <vprintfmt+0x1e5>
  800a54:	ff 4d e0             	decl   -0x20(%ebp)
  800a57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5b:	79 af                	jns    800a0c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a5d:	eb 13                	jmp    800a72 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	6a 20                	push   $0x20
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a6f:	ff 4d e4             	decl   -0x1c(%ebp)
  800a72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a76:	7f e7                	jg     800a5f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a78:	e9 78 01 00 00       	jmp    800bf5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 e8             	pushl  -0x18(%ebp)
  800a83:	8d 45 14             	lea    0x14(%ebp),%eax
  800a86:	50                   	push   %eax
  800a87:	e8 3c fd ff ff       	call   8007c8 <getint>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9b:	85 d2                	test   %edx,%edx
  800a9d:	79 23                	jns    800ac2 <vprintfmt+0x29b>
				putch('-', putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	6a 2d                	push   $0x2d
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab5:	f7 d8                	neg    %eax
  800ab7:	83 d2 00             	adc    $0x0,%edx
  800aba:	f7 da                	neg    %edx
  800abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800abf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ac2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac9:	e9 bc 00 00 00       	jmp    800b8a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad7:	50                   	push   %eax
  800ad8:	e8 84 fc ff ff       	call   800761 <getuint>
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ae6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aed:	e9 98 00 00 00       	jmp    800b8a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	6a 58                	push   $0x58
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	ff d0                	call   *%eax
  800aff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	6a 58                	push   $0x58
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b12:	83 ec 08             	sub    $0x8,%esp
  800b15:	ff 75 0c             	pushl  0xc(%ebp)
  800b18:	6a 58                	push   $0x58
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	ff d0                	call   *%eax
  800b1f:	83 c4 10             	add    $0x10,%esp
			break;
  800b22:	e9 ce 00 00 00       	jmp    800bf5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	6a 30                	push   $0x30
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	ff d0                	call   *%eax
  800b34:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	6a 78                	push   $0x78
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	ff d0                	call   *%eax
  800b44:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	83 c0 04             	add    $0x4,%eax
  800b4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b50:	8b 45 14             	mov    0x14(%ebp),%eax
  800b53:	83 e8 04             	sub    $0x4,%eax
  800b56:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b62:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b69:	eb 1f                	jmp    800b8a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b71:	8d 45 14             	lea    0x14(%ebp),%eax
  800b74:	50                   	push   %eax
  800b75:	e8 e7 fb ff ff       	call   800761 <getuint>
  800b7a:	83 c4 10             	add    $0x10,%esp
  800b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b83:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b8a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b91:	83 ec 04             	sub    $0x4,%esp
  800b94:	52                   	push   %edx
  800b95:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b98:	50                   	push   %eax
  800b99:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9c:	ff 75 f0             	pushl  -0x10(%ebp)
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	ff 75 08             	pushl  0x8(%ebp)
  800ba5:	e8 00 fb ff ff       	call   8006aa <printnum>
  800baa:	83 c4 20             	add    $0x20,%esp
			break;
  800bad:	eb 46                	jmp    800bf5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800baf:	83 ec 08             	sub    $0x8,%esp
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	53                   	push   %ebx
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	ff d0                	call   *%eax
  800bbb:	83 c4 10             	add    $0x10,%esp
			break;
  800bbe:	eb 35                	jmp    800bf5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bc0:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800bc7:	eb 2c                	jmp    800bf5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bc9:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800bd0:	eb 23                	jmp    800bf5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	6a 25                	push   $0x25
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	ff d0                	call   *%eax
  800bdf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800be2:	ff 4d 10             	decl   0x10(%ebp)
  800be5:	eb 03                	jmp    800bea <vprintfmt+0x3c3>
  800be7:	ff 4d 10             	decl   0x10(%ebp)
  800bea:	8b 45 10             	mov    0x10(%ebp),%eax
  800bed:	48                   	dec    %eax
  800bee:	8a 00                	mov    (%eax),%al
  800bf0:	3c 25                	cmp    $0x25,%al
  800bf2:	75 f3                	jne    800be7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bf4:	90                   	nop
		}
	}
  800bf5:	e9 35 fc ff ff       	jmp    80082f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bfa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bfb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c08:	8d 45 10             	lea    0x10(%ebp),%eax
  800c0b:	83 c0 04             	add    $0x4,%eax
  800c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c11:	8b 45 10             	mov    0x10(%ebp),%eax
  800c14:	ff 75 f4             	pushl  -0xc(%ebp)
  800c17:	50                   	push   %eax
  800c18:	ff 75 0c             	pushl  0xc(%ebp)
  800c1b:	ff 75 08             	pushl  0x8(%ebp)
  800c1e:	e8 04 fc ff ff       	call   800827 <vprintfmt>
  800c23:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c26:	90                   	nop
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2f:	8b 40 08             	mov    0x8(%eax),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3e:	8b 10                	mov    (%eax),%edx
  800c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c43:	8b 40 04             	mov    0x4(%eax),%eax
  800c46:	39 c2                	cmp    %eax,%edx
  800c48:	73 12                	jae    800c5c <sprintputch+0x33>
		*b->buf++ = ch;
  800c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4d:	8b 00                	mov    (%eax),%eax
  800c4f:	8d 48 01             	lea    0x1(%eax),%ecx
  800c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c55:	89 0a                	mov    %ecx,(%edx)
  800c57:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5a:	88 10                	mov    %dl,(%eax)
}
  800c5c:	90                   	nop
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	01 d0                	add    %edx,%eax
  800c76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c84:	74 06                	je     800c8c <vsnprintf+0x2d>
  800c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8a:	7f 07                	jg     800c93 <vsnprintf+0x34>
		return -E_INVAL;
  800c8c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c91:	eb 20                	jmp    800cb3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c93:	ff 75 14             	pushl  0x14(%ebp)
  800c96:	ff 75 10             	pushl  0x10(%ebp)
  800c99:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	68 29 0c 80 00       	push   $0x800c29
  800ca2:	e8 80 fb ff ff       	call   800827 <vprintfmt>
  800ca7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cad:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cbb:	8d 45 10             	lea    0x10(%ebp),%eax
  800cbe:	83 c0 04             	add    $0x4,%eax
  800cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cca:	50                   	push   %eax
  800ccb:	ff 75 0c             	pushl  0xc(%ebp)
  800cce:	ff 75 08             	pushl  0x8(%ebp)
  800cd1:	e8 89 ff ff ff       	call   800c5f <vsnprintf>
  800cd6:	83 c4 10             	add    $0x10,%esp
  800cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cdf:	c9                   	leave  
  800ce0:	c3                   	ret    

00800ce1 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cee:	eb 06                	jmp    800cf6 <strlen+0x15>
		n++;
  800cf0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf3:	ff 45 08             	incl   0x8(%ebp)
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	84 c0                	test   %al,%al
  800cfd:	75 f1                	jne    800cf0 <strlen+0xf>
		n++;
	return n;
  800cff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d11:	eb 09                	jmp    800d1c <strnlen+0x18>
		n++;
  800d13:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d16:	ff 45 08             	incl   0x8(%ebp)
  800d19:	ff 4d 0c             	decl   0xc(%ebp)
  800d1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d20:	74 09                	je     800d2b <strnlen+0x27>
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	84 c0                	test   %al,%al
  800d29:	75 e8                	jne    800d13 <strnlen+0xf>
		n++;
	return n;
  800d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d3c:	90                   	nop
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8d 50 01             	lea    0x1(%eax),%edx
  800d43:	89 55 08             	mov    %edx,0x8(%ebp)
  800d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4f:	8a 12                	mov    (%edx),%dl
  800d51:	88 10                	mov    %dl,(%eax)
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	84 c0                	test   %al,%al
  800d57:	75 e4                	jne    800d3d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d71:	eb 1f                	jmp    800d92 <strncpy+0x34>
		*dst++ = *src;
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8d 50 01             	lea    0x1(%eax),%edx
  800d79:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7f:	8a 12                	mov    (%edx),%dl
  800d81:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	84 c0                	test   %al,%al
  800d8a:	74 03                	je     800d8f <strncpy+0x31>
			src++;
  800d8c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d8f:	ff 45 fc             	incl   -0x4(%ebp)
  800d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d95:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d98:	72 d9                	jb     800d73 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800daf:	74 30                	je     800de1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800db1:	eb 16                	jmp    800dc9 <strlcpy+0x2a>
			*dst++ = *src++;
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8d 50 01             	lea    0x1(%eax),%edx
  800db9:	89 55 08             	mov    %edx,0x8(%ebp)
  800dbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dc5:	8a 12                	mov    (%edx),%dl
  800dc7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dc9:	ff 4d 10             	decl   0x10(%ebp)
  800dcc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd0:	74 09                	je     800ddb <strlcpy+0x3c>
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	84 c0                	test   %al,%al
  800dd9:	75 d8                	jne    800db3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de7:	29 c2                	sub    %eax,%edx
  800de9:	89 d0                	mov    %edx,%eax
}
  800deb:	c9                   	leave  
  800dec:	c3                   	ret    

00800ded <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800df0:	eb 06                	jmp    800df8 <strcmp+0xb>
		p++, q++;
  800df2:	ff 45 08             	incl   0x8(%ebp)
  800df5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	84 c0                	test   %al,%al
  800dff:	74 0e                	je     800e0f <strcmp+0x22>
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 10                	mov    (%eax),%dl
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	38 c2                	cmp    %al,%dl
  800e0d:	74 e3                	je     800df2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f b6 d0             	movzbl %al,%edx
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 c0             	movzbl %al,%eax
  800e1f:	29 c2                	sub    %eax,%edx
  800e21:	89 d0                	mov    %edx,%eax
}
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    

00800e25 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e28:	eb 09                	jmp    800e33 <strncmp+0xe>
		n--, p++, q++;
  800e2a:	ff 4d 10             	decl   0x10(%ebp)
  800e2d:	ff 45 08             	incl   0x8(%ebp)
  800e30:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e37:	74 17                	je     800e50 <strncmp+0x2b>
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	74 0e                	je     800e50 <strncmp+0x2b>
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 10                	mov    (%eax),%dl
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	38 c2                	cmp    %al,%dl
  800e4e:	74 da                	je     800e2a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e54:	75 07                	jne    800e5d <strncmp+0x38>
		return 0;
  800e56:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5b:	eb 14                	jmp    800e71 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	0f b6 d0             	movzbl %al,%edx
  800e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f b6 c0             	movzbl %al,%eax
  800e6d:	29 c2                	sub    %eax,%edx
  800e6f:	89 d0                	mov    %edx,%eax
}
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	83 ec 04             	sub    $0x4,%esp
  800e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e7f:	eb 12                	jmp    800e93 <strchr+0x20>
		if (*s == c)
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e89:	75 05                	jne    800e90 <strchr+0x1d>
			return (char *) s;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	eb 11                	jmp    800ea1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e90:	ff 45 08             	incl   0x8(%ebp)
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	84 c0                	test   %al,%al
  800e9a:	75 e5                	jne    800e81 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 04             	sub    $0x4,%esp
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eaf:	eb 0d                	jmp    800ebe <strfind+0x1b>
		if (*s == c)
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eb9:	74 0e                	je     800ec9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ebb:	ff 45 08             	incl   0x8(%ebp)
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	84 c0                	test   %al,%al
  800ec5:	75 ea                	jne    800eb1 <strfind+0xe>
  800ec7:	eb 01                	jmp    800eca <strfind+0x27>
		if (*s == c)
			break;
  800ec9:	90                   	nop
	return (char *) s;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800edb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ede:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ee1:	eb 0e                	jmp    800ef1 <memset+0x22>
		*p++ = c;
  800ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee6:	8d 50 01             	lea    0x1(%eax),%edx
  800ee9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eef:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ef1:	ff 4d f8             	decl   -0x8(%ebp)
  800ef4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ef8:	79 e9                	jns    800ee3 <memset+0x14>
		*p++ = c;

	return v;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f11:	eb 16                	jmp    800f29 <memcpy+0x2a>
		*d++ = *s++;
  800f13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f16:	8d 50 01             	lea    0x1(%eax),%edx
  800f19:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f22:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f25:	8a 12                	mov    (%edx),%dl
  800f27:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f29:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f32:	85 c0                	test   %eax,%eax
  800f34:	75 dd                	jne    800f13 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f50:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f53:	73 50                	jae    800fa5 <memmove+0x6a>
  800f55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f58:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5b:	01 d0                	add    %edx,%eax
  800f5d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f60:	76 43                	jbe    800fa5 <memmove+0x6a>
		s += n;
  800f62:	8b 45 10             	mov    0x10(%ebp),%eax
  800f65:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f6e:	eb 10                	jmp    800f80 <memmove+0x45>
			*--d = *--s;
  800f70:	ff 4d f8             	decl   -0x8(%ebp)
  800f73:	ff 4d fc             	decl   -0x4(%ebp)
  800f76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f79:	8a 10                	mov    (%eax),%dl
  800f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f80:	8b 45 10             	mov    0x10(%ebp),%eax
  800f83:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f86:	89 55 10             	mov    %edx,0x10(%ebp)
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	75 e3                	jne    800f70 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f8d:	eb 23                	jmp    800fb2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f92:	8d 50 01             	lea    0x1(%eax),%edx
  800f95:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f98:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f9e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fa1:	8a 12                	mov    (%edx),%dl
  800fa3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fab:	89 55 10             	mov    %edx,0x10(%ebp)
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	75 dd                	jne    800f8f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb5:	c9                   	leave  
  800fb6:	c3                   	ret    

00800fb7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fc9:	eb 2a                	jmp    800ff5 <memcmp+0x3e>
		if (*s1 != *s2)
  800fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fce:	8a 10                	mov    (%eax),%dl
  800fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	38 c2                	cmp    %al,%dl
  800fd7:	74 16                	je     800fef <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	0f b6 d0             	movzbl %al,%edx
  800fe1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f b6 c0             	movzbl %al,%eax
  800fe9:	29 c2                	sub    %eax,%edx
  800feb:	89 d0                	mov    %edx,%eax
  800fed:	eb 18                	jmp    801007 <memcmp+0x50>
		s1++, s2++;
  800fef:	ff 45 fc             	incl   -0x4(%ebp)
  800ff2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ff5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffe:	85 c0                	test   %eax,%eax
  801000:	75 c9                	jne    800fcb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801002:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80100f:	8b 55 08             	mov    0x8(%ebp),%edx
  801012:	8b 45 10             	mov    0x10(%ebp),%eax
  801015:	01 d0                	add    %edx,%eax
  801017:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80101a:	eb 15                	jmp    801031 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f b6 d0             	movzbl %al,%edx
  801024:	8b 45 0c             	mov    0xc(%ebp),%eax
  801027:	0f b6 c0             	movzbl %al,%eax
  80102a:	39 c2                	cmp    %eax,%edx
  80102c:	74 0d                	je     80103b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80102e:	ff 45 08             	incl   0x8(%ebp)
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801037:	72 e3                	jb     80101c <memfind+0x13>
  801039:	eb 01                	jmp    80103c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80103b:	90                   	nop
	return (void *) s;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801047:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80104e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801055:	eb 03                	jmp    80105a <strtol+0x19>
		s++;
  801057:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	3c 20                	cmp    $0x20,%al
  801061:	74 f4                	je     801057 <strtol+0x16>
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 09                	cmp    $0x9,%al
  80106a:	74 eb                	je     801057 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 2b                	cmp    $0x2b,%al
  801073:	75 05                	jne    80107a <strtol+0x39>
		s++;
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	eb 13                	jmp    80108d <strtol+0x4c>
	else if (*s == '-')
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	3c 2d                	cmp    $0x2d,%al
  801081:	75 0a                	jne    80108d <strtol+0x4c>
		s++, neg = 1;
  801083:	ff 45 08             	incl   0x8(%ebp)
  801086:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80108d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801091:	74 06                	je     801099 <strtol+0x58>
  801093:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801097:	75 20                	jne    8010b9 <strtol+0x78>
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	3c 30                	cmp    $0x30,%al
  8010a0:	75 17                	jne    8010b9 <strtol+0x78>
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	40                   	inc    %eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 78                	cmp    $0x78,%al
  8010aa:	75 0d                	jne    8010b9 <strtol+0x78>
		s += 2, base = 16;
  8010ac:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010b0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010b7:	eb 28                	jmp    8010e1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	75 15                	jne    8010d4 <strtol+0x93>
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	3c 30                	cmp    $0x30,%al
  8010c6:	75 0c                	jne    8010d4 <strtol+0x93>
		s++, base = 8;
  8010c8:	ff 45 08             	incl   0x8(%ebp)
  8010cb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010d2:	eb 0d                	jmp    8010e1 <strtol+0xa0>
	else if (base == 0)
  8010d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d8:	75 07                	jne    8010e1 <strtol+0xa0>
		base = 10;
  8010da:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 2f                	cmp    $0x2f,%al
  8010e8:	7e 19                	jle    801103 <strtol+0xc2>
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 39                	cmp    $0x39,%al
  8010f1:	7f 10                	jg     801103 <strtol+0xc2>
			dig = *s - '0';
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	0f be c0             	movsbl %al,%eax
  8010fb:	83 e8 30             	sub    $0x30,%eax
  8010fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801101:	eb 42                	jmp    801145 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	3c 60                	cmp    $0x60,%al
  80110a:	7e 19                	jle    801125 <strtol+0xe4>
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	3c 7a                	cmp    $0x7a,%al
  801113:	7f 10                	jg     801125 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	0f be c0             	movsbl %al,%eax
  80111d:	83 e8 57             	sub    $0x57,%eax
  801120:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801123:	eb 20                	jmp    801145 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	3c 40                	cmp    $0x40,%al
  80112c:	7e 39                	jle    801167 <strtol+0x126>
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	3c 5a                	cmp    $0x5a,%al
  801135:	7f 30                	jg     801167 <strtol+0x126>
			dig = *s - 'A' + 10;
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	0f be c0             	movsbl %al,%eax
  80113f:	83 e8 37             	sub    $0x37,%eax
  801142:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801148:	3b 45 10             	cmp    0x10(%ebp),%eax
  80114b:	7d 19                	jge    801166 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80114d:	ff 45 08             	incl   0x8(%ebp)
  801150:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801153:	0f af 45 10          	imul   0x10(%ebp),%eax
  801157:	89 c2                	mov    %eax,%edx
  801159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801161:	e9 7b ff ff ff       	jmp    8010e1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801166:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801167:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80116b:	74 08                	je     801175 <strtol+0x134>
		*endptr = (char *) s;
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	8b 55 08             	mov    0x8(%ebp),%edx
  801173:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801175:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801179:	74 07                	je     801182 <strtol+0x141>
  80117b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117e:	f7 d8                	neg    %eax
  801180:	eb 03                	jmp    801185 <strtol+0x144>
  801182:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801185:	c9                   	leave  
  801186:	c3                   	ret    

00801187 <ltostr>:

void
ltostr(long value, char *str)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80118d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801194:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80119b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80119f:	79 13                	jns    8011b4 <ltostr+0x2d>
	{
		neg = 1;
  8011a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ae:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011b1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011bc:	99                   	cltd   
  8011bd:	f7 f9                	idiv   %ecx
  8011bf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c5:	8d 50 01             	lea    0x1(%eax),%edx
  8011c8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011cb:	89 c2                	mov    %eax,%edx
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	01 d0                	add    %edx,%eax
  8011d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011d5:	83 c2 30             	add    $0x30,%edx
  8011d8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011dd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e2:	f7 e9                	imul   %ecx
  8011e4:	c1 fa 02             	sar    $0x2,%edx
  8011e7:	89 c8                	mov    %ecx,%eax
  8011e9:	c1 f8 1f             	sar    $0x1f,%eax
  8011ec:	29 c2                	sub    %eax,%edx
  8011ee:	89 d0                	mov    %edx,%eax
  8011f0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f7:	75 bb                	jne    8011b4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801200:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801203:	48                   	dec    %eax
  801204:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801207:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120b:	74 3d                	je     80124a <ltostr+0xc3>
		start = 1 ;
  80120d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801214:	eb 34                	jmp    80124a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801216:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	01 d0                	add    %edx,%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801223:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	01 c2                	add    %eax,%edx
  80122b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80122e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801231:	01 c8                	add    %ecx,%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801237:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	01 c2                	add    %eax,%edx
  80123f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801242:	88 02                	mov    %al,(%edx)
		start++ ;
  801244:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801247:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80124a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801250:	7c c4                	jl     801216 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801252:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80125d:	90                   	nop
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    

00801260 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801266:	ff 75 08             	pushl  0x8(%ebp)
  801269:	e8 73 fa ff ff       	call   800ce1 <strlen>
  80126e:	83 c4 04             	add    $0x4,%esp
  801271:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801274:	ff 75 0c             	pushl  0xc(%ebp)
  801277:	e8 65 fa ff ff       	call   800ce1 <strlen>
  80127c:	83 c4 04             	add    $0x4,%esp
  80127f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801282:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801290:	eb 17                	jmp    8012a9 <strcconcat+0x49>
		final[s] = str1[s] ;
  801292:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801295:	8b 45 10             	mov    0x10(%ebp),%eax
  801298:	01 c2                	add    %eax,%edx
  80129a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	01 c8                	add    %ecx,%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012a6:	ff 45 fc             	incl   -0x4(%ebp)
  8012a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012af:	7c e1                	jl     801292 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012bf:	eb 1f                	jmp    8012e0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c4:	8d 50 01             	lea    0x1(%eax),%edx
  8012c7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ca:	89 c2                	mov    %eax,%edx
  8012cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cf:	01 c2                	add    %eax,%edx
  8012d1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d7:	01 c8                	add    %ecx,%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012dd:	ff 45 f8             	incl   -0x8(%ebp)
  8012e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e6:	7c d9                	jl     8012c1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ee:	01 d0                	add    %edx,%eax
  8012f0:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f3:	90                   	nop
  8012f4:	c9                   	leave  
  8012f5:	c3                   	ret    

008012f6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801302:	8b 45 14             	mov    0x14(%ebp),%eax
  801305:	8b 00                	mov    (%eax),%eax
  801307:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80130e:	8b 45 10             	mov    0x10(%ebp),%eax
  801311:	01 d0                	add    %edx,%eax
  801313:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801319:	eb 0c                	jmp    801327 <strsplit+0x31>
			*string++ = 0;
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	8d 50 01             	lea    0x1(%eax),%edx
  801321:	89 55 08             	mov    %edx,0x8(%ebp)
  801324:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	84 c0                	test   %al,%al
  80132e:	74 18                	je     801348 <strsplit+0x52>
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f be c0             	movsbl %al,%eax
  801338:	50                   	push   %eax
  801339:	ff 75 0c             	pushl  0xc(%ebp)
  80133c:	e8 32 fb ff ff       	call   800e73 <strchr>
  801341:	83 c4 08             	add    $0x8,%esp
  801344:	85 c0                	test   %eax,%eax
  801346:	75 d3                	jne    80131b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	84 c0                	test   %al,%al
  80134f:	74 5a                	je     8013ab <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801351:	8b 45 14             	mov    0x14(%ebp),%eax
  801354:	8b 00                	mov    (%eax),%eax
  801356:	83 f8 0f             	cmp    $0xf,%eax
  801359:	75 07                	jne    801362 <strsplit+0x6c>
		{
			return 0;
  80135b:	b8 00 00 00 00       	mov    $0x0,%eax
  801360:	eb 66                	jmp    8013c8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	8b 00                	mov    (%eax),%eax
  801367:	8d 48 01             	lea    0x1(%eax),%ecx
  80136a:	8b 55 14             	mov    0x14(%ebp),%edx
  80136d:	89 0a                	mov    %ecx,(%edx)
  80136f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801376:	8b 45 10             	mov    0x10(%ebp),%eax
  801379:	01 c2                	add    %eax,%edx
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801380:	eb 03                	jmp    801385 <strsplit+0x8f>
			string++;
  801382:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	84 c0                	test   %al,%al
  80138c:	74 8b                	je     801319 <strsplit+0x23>
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	0f be c0             	movsbl %al,%eax
  801396:	50                   	push   %eax
  801397:	ff 75 0c             	pushl  0xc(%ebp)
  80139a:	e8 d4 fa ff ff       	call   800e73 <strchr>
  80139f:	83 c4 08             	add    $0x8,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	74 dc                	je     801382 <strsplit+0x8c>
			string++;
	}
  8013a6:	e9 6e ff ff ff       	jmp    801319 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ab:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8013af:	8b 00                	mov    (%eax),%eax
  8013b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bb:	01 d0                	add    %edx,%eax
  8013bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    

008013ca <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8013d0:	83 ec 04             	sub    $0x4,%esp
  8013d3:	68 48 25 80 00       	push   $0x802548
  8013d8:	68 3f 01 00 00       	push   $0x13f
  8013dd:	68 6a 25 80 00       	push   $0x80256a
  8013e2:	e8 a9 ef ff ff       	call   800390 <_panic>

008013e7 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	ff 75 08             	pushl  0x8(%ebp)
  8013f3:	e8 ef 06 00 00       	call   801ae7 <sys_sbrk>
  8013f8:	83 c4 10             	add    $0x10,%esp
}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801403:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801407:	75 07                	jne    801410 <malloc+0x13>
  801409:	b8 00 00 00 00       	mov    $0x0,%eax
  80140e:	eb 14                	jmp    801424 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801410:	83 ec 04             	sub    $0x4,%esp
  801413:	68 78 25 80 00       	push   $0x802578
  801418:	6a 1b                	push   $0x1b
  80141a:	68 9d 25 80 00       	push   $0x80259d
  80141f:	e8 6c ef ff ff       	call   800390 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	68 ac 25 80 00       	push   $0x8025ac
  801434:	6a 29                	push   $0x29
  801436:	68 9d 25 80 00       	push   $0x80259d
  80143b:	e8 50 ef ff ff       	call   800390 <_panic>

00801440 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	83 ec 18             	sub    $0x18,%esp
  801446:	8b 45 10             	mov    0x10(%ebp),%eax
  801449:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80144c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801450:	75 07                	jne    801459 <smalloc+0x19>
  801452:	b8 00 00 00 00       	mov    $0x0,%eax
  801457:	eb 14                	jmp    80146d <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801459:	83 ec 04             	sub    $0x4,%esp
  80145c:	68 d0 25 80 00       	push   $0x8025d0
  801461:	6a 38                	push   $0x38
  801463:	68 9d 25 80 00       	push   $0x80259d
  801468:	e8 23 ef ff ff       	call   800390 <_panic>
	return NULL;
}
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	68 f8 25 80 00       	push   $0x8025f8
  80147d:	6a 43                	push   $0x43
  80147f:	68 9d 25 80 00       	push   $0x80259d
  801484:	e8 07 ef ff ff       	call   800390 <_panic>

00801489 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	68 1c 26 80 00       	push   $0x80261c
  801497:	6a 5b                	push   $0x5b
  801499:	68 9d 25 80 00       	push   $0x80259d
  80149e:	e8 ed ee ff ff       	call   800390 <_panic>

008014a3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014a9:	83 ec 04             	sub    $0x4,%esp
  8014ac:	68 40 26 80 00       	push   $0x802640
  8014b1:	6a 72                	push   $0x72
  8014b3:	68 9d 25 80 00       	push   $0x80259d
  8014b8:	e8 d3 ee ff ff       	call   800390 <_panic>

008014bd <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014c3:	83 ec 04             	sub    $0x4,%esp
  8014c6:	68 66 26 80 00       	push   $0x802666
  8014cb:	6a 7e                	push   $0x7e
  8014cd:	68 9d 25 80 00       	push   $0x80259d
  8014d2:	e8 b9 ee ff ff       	call   800390 <_panic>

008014d7 <shrink>:

}
void shrink(uint32 newSize)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	68 66 26 80 00       	push   $0x802666
  8014e5:	68 83 00 00 00       	push   $0x83
  8014ea:	68 9d 25 80 00       	push   $0x80259d
  8014ef:	e8 9c ee ff ff       	call   800390 <_panic>

008014f4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014fa:	83 ec 04             	sub    $0x4,%esp
  8014fd:	68 66 26 80 00       	push   $0x802666
  801502:	68 88 00 00 00       	push   $0x88
  801507:	68 9d 25 80 00       	push   $0x80259d
  80150c:	e8 7f ee ff ff       	call   800390 <_panic>

00801511 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	57                   	push   %edi
  801515:	56                   	push   %esi
  801516:	53                   	push   %ebx
  801517:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801520:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801523:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801526:	8b 7d 18             	mov    0x18(%ebp),%edi
  801529:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80152c:	cd 30                	int    $0x30
  80152e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801531:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	5b                   	pop    %ebx
  801538:	5e                   	pop    %esi
  801539:	5f                   	pop    %edi
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    

0080153c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	83 ec 04             	sub    $0x4,%esp
  801542:	8b 45 10             	mov    0x10(%ebp),%eax
  801545:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801548:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	52                   	push   %edx
  801554:	ff 75 0c             	pushl  0xc(%ebp)
  801557:	50                   	push   %eax
  801558:	6a 00                	push   $0x0
  80155a:	e8 b2 ff ff ff       	call   801511 <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	90                   	nop
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_cgetc>:

int
sys_cgetc(void)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 02                	push   $0x2
  801574:	e8 98 ff ff ff       	call   801511 <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 03                	push   $0x3
  80158d:	e8 7f ff ff ff       	call   801511 <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
}
  801595:	90                   	nop
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 04                	push   $0x4
  8015a7:	e8 65 ff ff ff       	call   801511 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	90                   	nop
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	52                   	push   %edx
  8015c2:	50                   	push   %eax
  8015c3:	6a 08                	push   $0x8
  8015c5:	e8 47 ff ff ff       	call   801511 <syscall>
  8015ca:	83 c4 18             	add    $0x18,%esp
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	56                   	push   %esi
  8015d3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015d4:	8b 75 18             	mov    0x18(%ebp),%esi
  8015d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	56                   	push   %esi
  8015e4:	53                   	push   %ebx
  8015e5:	51                   	push   %ecx
  8015e6:	52                   	push   %edx
  8015e7:	50                   	push   %eax
  8015e8:	6a 09                	push   $0x9
  8015ea:	e8 22 ff ff ff       	call   801511 <syscall>
  8015ef:	83 c4 18             	add    $0x18,%esp
}
  8015f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f5:	5b                   	pop    %ebx
  8015f6:	5e                   	pop    %esi
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    

008015f9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	52                   	push   %edx
  801609:	50                   	push   %eax
  80160a:	6a 0a                	push   $0xa
  80160c:	e8 00 ff ff ff       	call   801511 <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	ff 75 0c             	pushl  0xc(%ebp)
  801622:	ff 75 08             	pushl  0x8(%ebp)
  801625:	6a 0b                	push   $0xb
  801627:	e8 e5 fe ff ff       	call   801511 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 0c                	push   $0xc
  801640:	e8 cc fe ff ff       	call   801511 <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 0d                	push   $0xd
  801659:	e8 b3 fe ff ff       	call   801511 <syscall>
  80165e:	83 c4 18             	add    $0x18,%esp
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 0e                	push   $0xe
  801672:	e8 9a fe ff ff       	call   801511 <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 0f                	push   $0xf
  80168b:	e8 81 fe ff ff       	call   801511 <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	ff 75 08             	pushl  0x8(%ebp)
  8016a3:	6a 10                	push   $0x10
  8016a5:	e8 67 fe ff ff       	call   801511 <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 11                	push   $0x11
  8016be:	e8 4e fe ff ff       	call   801511 <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
}
  8016c6:	90                   	nop
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_cputc>:

void
sys_cputc(const char c)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016d5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	50                   	push   %eax
  8016e2:	6a 01                	push   $0x1
  8016e4:	e8 28 fe ff ff       	call   801511 <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	90                   	nop
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 14                	push   $0x14
  8016fe:	e8 0e fe ff ff       	call   801511 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	90                   	nop
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 04             	sub    $0x4,%esp
  80170f:	8b 45 10             	mov    0x10(%ebp),%eax
  801712:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801715:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801718:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	6a 00                	push   $0x0
  801721:	51                   	push   %ecx
  801722:	52                   	push   %edx
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	50                   	push   %eax
  801727:	6a 15                	push   $0x15
  801729:	e8 e3 fd ff ff       	call   801511 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801736:	8b 55 0c             	mov    0xc(%ebp),%edx
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	52                   	push   %edx
  801743:	50                   	push   %eax
  801744:	6a 16                	push   $0x16
  801746:	e8 c6 fd ff ff       	call   801511 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801753:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801756:	8b 55 0c             	mov    0xc(%ebp),%edx
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	51                   	push   %ecx
  801761:	52                   	push   %edx
  801762:	50                   	push   %eax
  801763:	6a 17                	push   $0x17
  801765:	e8 a7 fd ff ff       	call   801511 <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801772:	8b 55 0c             	mov    0xc(%ebp),%edx
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	52                   	push   %edx
  80177f:	50                   	push   %eax
  801780:	6a 18                	push   $0x18
  801782:	e8 8a fd ff ff       	call   801511 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	6a 00                	push   $0x0
  801794:	ff 75 14             	pushl  0x14(%ebp)
  801797:	ff 75 10             	pushl  0x10(%ebp)
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	50                   	push   %eax
  80179e:	6a 19                	push   $0x19
  8017a0:	e8 6c fd ff ff       	call   801511 <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	50                   	push   %eax
  8017b9:	6a 1a                	push   $0x1a
  8017bb:	e8 51 fd ff ff       	call   801511 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	90                   	nop
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	50                   	push   %eax
  8017d5:	6a 1b                	push   $0x1b
  8017d7:	e8 35 fd ff ff       	call   801511 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 05                	push   $0x5
  8017f0:	e8 1c fd ff ff       	call   801511 <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 06                	push   $0x6
  801809:	e8 03 fd ff ff       	call   801511 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 07                	push   $0x7
  801822:	e8 ea fc ff ff       	call   801511 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sys_exit_env>:


void sys_exit_env(void)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 1c                	push   $0x1c
  80183b:	e8 d1 fc ff ff       	call   801511 <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	90                   	nop
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80184c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80184f:	8d 50 04             	lea    0x4(%eax),%edx
  801852:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	52                   	push   %edx
  80185c:	50                   	push   %eax
  80185d:	6a 1d                	push   $0x1d
  80185f:	e8 ad fc ff ff       	call   801511 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
	return result;
  801867:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80186a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801870:	89 01                	mov    %eax,(%ecx)
  801872:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	c9                   	leave  
  801879:	c2 04 00             	ret    $0x4

0080187c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	ff 75 10             	pushl  0x10(%ebp)
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	ff 75 08             	pushl  0x8(%ebp)
  80188c:	6a 13                	push   $0x13
  80188e:	e8 7e fc ff ff       	call   801511 <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
	return ;
  801896:	90                   	nop
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_rcr2>:
uint32 sys_rcr2()
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 1e                	push   $0x1e
  8018a8:	e8 64 fc ff ff       	call   801511 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018be:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	50                   	push   %eax
  8018cb:	6a 1f                	push   $0x1f
  8018cd:	e8 3f fc ff ff       	call   801511 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <rsttst>:
void rsttst()
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 21                	push   $0x21
  8018e7:	e8 25 fc ff ff       	call   801511 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ef:	90                   	nop
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 04             	sub    $0x4,%esp
  8018f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018fe:	8b 55 18             	mov    0x18(%ebp),%edx
  801901:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801905:	52                   	push   %edx
  801906:	50                   	push   %eax
  801907:	ff 75 10             	pushl  0x10(%ebp)
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	ff 75 08             	pushl  0x8(%ebp)
  801910:	6a 20                	push   $0x20
  801912:	e8 fa fb ff ff       	call   801511 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
	return ;
  80191a:	90                   	nop
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <chktst>:
void chktst(uint32 n)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	ff 75 08             	pushl  0x8(%ebp)
  80192b:	6a 22                	push   $0x22
  80192d:	e8 df fb ff ff       	call   801511 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
	return ;
  801935:	90                   	nop
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <inctst>:

void inctst()
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 23                	push   $0x23
  801947:	e8 c5 fb ff ff       	call   801511 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
	return ;
  80194f:	90                   	nop
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <gettst>:
uint32 gettst()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 24                	push   $0x24
  801961:	e8 ab fb ff ff       	call   801511 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 25                	push   $0x25
  80197d:	e8 8f fb ff ff       	call   801511 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
  801985:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801988:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80198c:	75 07                	jne    801995 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80198e:	b8 01 00 00 00       	mov    $0x1,%eax
  801993:	eb 05                	jmp    80199a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801995:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 25                	push   $0x25
  8019ae:	e8 5e fb ff ff       	call   801511 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
  8019b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019b9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019bd:	75 07                	jne    8019c6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c4:	eb 05                	jmp    8019cb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 25                	push   $0x25
  8019df:	e8 2d fb ff ff       	call   801511 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
  8019e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019ea:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019ee:	75 07                	jne    8019f7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f5:	eb 05                	jmp    8019fc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8019f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 25                	push   $0x25
  801a10:	e8 fc fa ff ff       	call   801511 <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
  801a18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a1b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a1f:	75 07                	jne    801a28 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a21:	b8 01 00 00 00       	mov    $0x1,%eax
  801a26:	eb 05                	jmp    801a2d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	ff 75 08             	pushl  0x8(%ebp)
  801a3d:	6a 26                	push   $0x26
  801a3f:	e8 cd fa ff ff       	call   801511 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
	return ;
  801a47:	90                   	nop
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	53                   	push   %ebx
  801a5d:	51                   	push   %ecx
  801a5e:	52                   	push   %edx
  801a5f:	50                   	push   %eax
  801a60:	6a 27                	push   $0x27
  801a62:	e8 aa fa ff ff       	call   801511 <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	52                   	push   %edx
  801a7f:	50                   	push   %eax
  801a80:	6a 28                	push   $0x28
  801a82:	e8 8a fa ff ff       	call   801511 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a8f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	6a 00                	push   $0x0
  801a9a:	51                   	push   %ecx
  801a9b:	ff 75 10             	pushl  0x10(%ebp)
  801a9e:	52                   	push   %edx
  801a9f:	50                   	push   %eax
  801aa0:	6a 29                	push   $0x29
  801aa2:	e8 6a fa ff ff       	call   801511 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	ff 75 10             	pushl  0x10(%ebp)
  801ab6:	ff 75 0c             	pushl  0xc(%ebp)
  801ab9:	ff 75 08             	pushl  0x8(%ebp)
  801abc:	6a 12                	push   $0x12
  801abe:	e8 4e fa ff ff       	call   801511 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac6:	90                   	nop
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	6a 2a                	push   $0x2a
  801adc:	e8 30 fa ff ff       	call   801511 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
	return;
  801ae4:	90                   	nop
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	50                   	push   %eax
  801af6:	6a 2b                	push   $0x2b
  801af8:	e8 14 fa ff ff       	call   801511 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	6a 2c                	push   $0x2c
  801b13:	e8 f9 f9 ff ff       	call   801511 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	ff 75 0c             	pushl  0xc(%ebp)
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	6a 2d                	push   $0x2d
  801b2f:	e8 dd f9 ff ff       	call   801511 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
	return;
  801b37:	90                   	nop
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    
  801b3a:	66 90                	xchg   %ax,%ax

00801b3c <__udivdi3>:
  801b3c:	55                   	push   %ebp
  801b3d:	57                   	push   %edi
  801b3e:	56                   	push   %esi
  801b3f:	53                   	push   %ebx
  801b40:	83 ec 1c             	sub    $0x1c,%esp
  801b43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b53:	89 ca                	mov    %ecx,%edx
  801b55:	89 f8                	mov    %edi,%eax
  801b57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b5b:	85 f6                	test   %esi,%esi
  801b5d:	75 2d                	jne    801b8c <__udivdi3+0x50>
  801b5f:	39 cf                	cmp    %ecx,%edi
  801b61:	77 65                	ja     801bc8 <__udivdi3+0x8c>
  801b63:	89 fd                	mov    %edi,%ebp
  801b65:	85 ff                	test   %edi,%edi
  801b67:	75 0b                	jne    801b74 <__udivdi3+0x38>
  801b69:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6e:	31 d2                	xor    %edx,%edx
  801b70:	f7 f7                	div    %edi
  801b72:	89 c5                	mov    %eax,%ebp
  801b74:	31 d2                	xor    %edx,%edx
  801b76:	89 c8                	mov    %ecx,%eax
  801b78:	f7 f5                	div    %ebp
  801b7a:	89 c1                	mov    %eax,%ecx
  801b7c:	89 d8                	mov    %ebx,%eax
  801b7e:	f7 f5                	div    %ebp
  801b80:	89 cf                	mov    %ecx,%edi
  801b82:	89 fa                	mov    %edi,%edx
  801b84:	83 c4 1c             	add    $0x1c,%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
  801b8c:	39 ce                	cmp    %ecx,%esi
  801b8e:	77 28                	ja     801bb8 <__udivdi3+0x7c>
  801b90:	0f bd fe             	bsr    %esi,%edi
  801b93:	83 f7 1f             	xor    $0x1f,%edi
  801b96:	75 40                	jne    801bd8 <__udivdi3+0x9c>
  801b98:	39 ce                	cmp    %ecx,%esi
  801b9a:	72 0a                	jb     801ba6 <__udivdi3+0x6a>
  801b9c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ba0:	0f 87 9e 00 00 00    	ja     801c44 <__udivdi3+0x108>
  801ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bab:	89 fa                	mov    %edi,%edx
  801bad:	83 c4 1c             	add    $0x1c,%esp
  801bb0:	5b                   	pop    %ebx
  801bb1:	5e                   	pop    %esi
  801bb2:	5f                   	pop    %edi
  801bb3:	5d                   	pop    %ebp
  801bb4:	c3                   	ret    
  801bb5:	8d 76 00             	lea    0x0(%esi),%esi
  801bb8:	31 ff                	xor    %edi,%edi
  801bba:	31 c0                	xor    %eax,%eax
  801bbc:	89 fa                	mov    %edi,%edx
  801bbe:	83 c4 1c             	add    $0x1c,%esp
  801bc1:	5b                   	pop    %ebx
  801bc2:	5e                   	pop    %esi
  801bc3:	5f                   	pop    %edi
  801bc4:	5d                   	pop    %ebp
  801bc5:	c3                   	ret    
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	89 d8                	mov    %ebx,%eax
  801bca:	f7 f7                	div    %edi
  801bcc:	31 ff                	xor    %edi,%edi
  801bce:	89 fa                	mov    %edi,%edx
  801bd0:	83 c4 1c             	add    $0x1c,%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    
  801bd8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bdd:	89 eb                	mov    %ebp,%ebx
  801bdf:	29 fb                	sub    %edi,%ebx
  801be1:	89 f9                	mov    %edi,%ecx
  801be3:	d3 e6                	shl    %cl,%esi
  801be5:	89 c5                	mov    %eax,%ebp
  801be7:	88 d9                	mov    %bl,%cl
  801be9:	d3 ed                	shr    %cl,%ebp
  801beb:	89 e9                	mov    %ebp,%ecx
  801bed:	09 f1                	or     %esi,%ecx
  801bef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bf3:	89 f9                	mov    %edi,%ecx
  801bf5:	d3 e0                	shl    %cl,%eax
  801bf7:	89 c5                	mov    %eax,%ebp
  801bf9:	89 d6                	mov    %edx,%esi
  801bfb:	88 d9                	mov    %bl,%cl
  801bfd:	d3 ee                	shr    %cl,%esi
  801bff:	89 f9                	mov    %edi,%ecx
  801c01:	d3 e2                	shl    %cl,%edx
  801c03:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c07:	88 d9                	mov    %bl,%cl
  801c09:	d3 e8                	shr    %cl,%eax
  801c0b:	09 c2                	or     %eax,%edx
  801c0d:	89 d0                	mov    %edx,%eax
  801c0f:	89 f2                	mov    %esi,%edx
  801c11:	f7 74 24 0c          	divl   0xc(%esp)
  801c15:	89 d6                	mov    %edx,%esi
  801c17:	89 c3                	mov    %eax,%ebx
  801c19:	f7 e5                	mul    %ebp
  801c1b:	39 d6                	cmp    %edx,%esi
  801c1d:	72 19                	jb     801c38 <__udivdi3+0xfc>
  801c1f:	74 0b                	je     801c2c <__udivdi3+0xf0>
  801c21:	89 d8                	mov    %ebx,%eax
  801c23:	31 ff                	xor    %edi,%edi
  801c25:	e9 58 ff ff ff       	jmp    801b82 <__udivdi3+0x46>
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c30:	89 f9                	mov    %edi,%ecx
  801c32:	d3 e2                	shl    %cl,%edx
  801c34:	39 c2                	cmp    %eax,%edx
  801c36:	73 e9                	jae    801c21 <__udivdi3+0xe5>
  801c38:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c3b:	31 ff                	xor    %edi,%edi
  801c3d:	e9 40 ff ff ff       	jmp    801b82 <__udivdi3+0x46>
  801c42:	66 90                	xchg   %ax,%ax
  801c44:	31 c0                	xor    %eax,%eax
  801c46:	e9 37 ff ff ff       	jmp    801b82 <__udivdi3+0x46>
  801c4b:	90                   	nop

00801c4c <__umoddi3>:
  801c4c:	55                   	push   %ebp
  801c4d:	57                   	push   %edi
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 1c             	sub    $0x1c,%esp
  801c53:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c57:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c5f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c6b:	89 f3                	mov    %esi,%ebx
  801c6d:	89 fa                	mov    %edi,%edx
  801c6f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c73:	89 34 24             	mov    %esi,(%esp)
  801c76:	85 c0                	test   %eax,%eax
  801c78:	75 1a                	jne    801c94 <__umoddi3+0x48>
  801c7a:	39 f7                	cmp    %esi,%edi
  801c7c:	0f 86 a2 00 00 00    	jbe    801d24 <__umoddi3+0xd8>
  801c82:	89 c8                	mov    %ecx,%eax
  801c84:	89 f2                	mov    %esi,%edx
  801c86:	f7 f7                	div    %edi
  801c88:	89 d0                	mov    %edx,%eax
  801c8a:	31 d2                	xor    %edx,%edx
  801c8c:	83 c4 1c             	add    $0x1c,%esp
  801c8f:	5b                   	pop    %ebx
  801c90:	5e                   	pop    %esi
  801c91:	5f                   	pop    %edi
  801c92:	5d                   	pop    %ebp
  801c93:	c3                   	ret    
  801c94:	39 f0                	cmp    %esi,%eax
  801c96:	0f 87 ac 00 00 00    	ja     801d48 <__umoddi3+0xfc>
  801c9c:	0f bd e8             	bsr    %eax,%ebp
  801c9f:	83 f5 1f             	xor    $0x1f,%ebp
  801ca2:	0f 84 ac 00 00 00    	je     801d54 <__umoddi3+0x108>
  801ca8:	bf 20 00 00 00       	mov    $0x20,%edi
  801cad:	29 ef                	sub    %ebp,%edi
  801caf:	89 fe                	mov    %edi,%esi
  801cb1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cb5:	89 e9                	mov    %ebp,%ecx
  801cb7:	d3 e0                	shl    %cl,%eax
  801cb9:	89 d7                	mov    %edx,%edi
  801cbb:	89 f1                	mov    %esi,%ecx
  801cbd:	d3 ef                	shr    %cl,%edi
  801cbf:	09 c7                	or     %eax,%edi
  801cc1:	89 e9                	mov    %ebp,%ecx
  801cc3:	d3 e2                	shl    %cl,%edx
  801cc5:	89 14 24             	mov    %edx,(%esp)
  801cc8:	89 d8                	mov    %ebx,%eax
  801cca:	d3 e0                	shl    %cl,%eax
  801ccc:	89 c2                	mov    %eax,%edx
  801cce:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cd2:	d3 e0                	shl    %cl,%eax
  801cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cdc:	89 f1                	mov    %esi,%ecx
  801cde:	d3 e8                	shr    %cl,%eax
  801ce0:	09 d0                	or     %edx,%eax
  801ce2:	d3 eb                	shr    %cl,%ebx
  801ce4:	89 da                	mov    %ebx,%edx
  801ce6:	f7 f7                	div    %edi
  801ce8:	89 d3                	mov    %edx,%ebx
  801cea:	f7 24 24             	mull   (%esp)
  801ced:	89 c6                	mov    %eax,%esi
  801cef:	89 d1                	mov    %edx,%ecx
  801cf1:	39 d3                	cmp    %edx,%ebx
  801cf3:	0f 82 87 00 00 00    	jb     801d80 <__umoddi3+0x134>
  801cf9:	0f 84 91 00 00 00    	je     801d90 <__umoddi3+0x144>
  801cff:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d03:	29 f2                	sub    %esi,%edx
  801d05:	19 cb                	sbb    %ecx,%ebx
  801d07:	89 d8                	mov    %ebx,%eax
  801d09:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d0d:	d3 e0                	shl    %cl,%eax
  801d0f:	89 e9                	mov    %ebp,%ecx
  801d11:	d3 ea                	shr    %cl,%edx
  801d13:	09 d0                	or     %edx,%eax
  801d15:	89 e9                	mov    %ebp,%ecx
  801d17:	d3 eb                	shr    %cl,%ebx
  801d19:	89 da                	mov    %ebx,%edx
  801d1b:	83 c4 1c             	add    $0x1c,%esp
  801d1e:	5b                   	pop    %ebx
  801d1f:	5e                   	pop    %esi
  801d20:	5f                   	pop    %edi
  801d21:	5d                   	pop    %ebp
  801d22:	c3                   	ret    
  801d23:	90                   	nop
  801d24:	89 fd                	mov    %edi,%ebp
  801d26:	85 ff                	test   %edi,%edi
  801d28:	75 0b                	jne    801d35 <__umoddi3+0xe9>
  801d2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2f:	31 d2                	xor    %edx,%edx
  801d31:	f7 f7                	div    %edi
  801d33:	89 c5                	mov    %eax,%ebp
  801d35:	89 f0                	mov    %esi,%eax
  801d37:	31 d2                	xor    %edx,%edx
  801d39:	f7 f5                	div    %ebp
  801d3b:	89 c8                	mov    %ecx,%eax
  801d3d:	f7 f5                	div    %ebp
  801d3f:	89 d0                	mov    %edx,%eax
  801d41:	e9 44 ff ff ff       	jmp    801c8a <__umoddi3+0x3e>
  801d46:	66 90                	xchg   %ax,%ax
  801d48:	89 c8                	mov    %ecx,%eax
  801d4a:	89 f2                	mov    %esi,%edx
  801d4c:	83 c4 1c             	add    $0x1c,%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5f                   	pop    %edi
  801d52:	5d                   	pop    %ebp
  801d53:	c3                   	ret    
  801d54:	3b 04 24             	cmp    (%esp),%eax
  801d57:	72 06                	jb     801d5f <__umoddi3+0x113>
  801d59:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d5d:	77 0f                	ja     801d6e <__umoddi3+0x122>
  801d5f:	89 f2                	mov    %esi,%edx
  801d61:	29 f9                	sub    %edi,%ecx
  801d63:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d67:	89 14 24             	mov    %edx,(%esp)
  801d6a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d6e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d72:	8b 14 24             	mov    (%esp),%edx
  801d75:	83 c4 1c             	add    $0x1c,%esp
  801d78:	5b                   	pop    %ebx
  801d79:	5e                   	pop    %esi
  801d7a:	5f                   	pop    %edi
  801d7b:	5d                   	pop    %ebp
  801d7c:	c3                   	ret    
  801d7d:	8d 76 00             	lea    0x0(%esi),%esi
  801d80:	2b 04 24             	sub    (%esp),%eax
  801d83:	19 fa                	sbb    %edi,%edx
  801d85:	89 d1                	mov    %edx,%ecx
  801d87:	89 c6                	mov    %eax,%esi
  801d89:	e9 71 ff ff ff       	jmp    801cff <__umoddi3+0xb3>
  801d8e:	66 90                	xchg   %ax,%ax
  801d90:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d94:	72 ea                	jb     801d80 <__umoddi3+0x134>
  801d96:	89 d9                	mov    %ebx,%ecx
  801d98:	e9 62 ff ff ff       	jmp    801cff <__umoddi3+0xb3>
