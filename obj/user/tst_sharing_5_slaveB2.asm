
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 0d 01 00 00       	call   800143 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003e:	a1 04 30 80 00       	mov    0x803004,%eax
  800043:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800049:	a1 04 30 80 00       	mov    0x803004,%eax
  80004e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 40 1d 80 00       	push   $0x801d40
  800060:	6a 0c                	push   $0xc
  800062:	68 5c 1d 80 00       	push   $0x801d5c
  800067:	e8 0e 02 00 00       	call   80027a <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	z = sget(sys_getparentenvid(),"z");
  800073:	e8 85 16 00 00       	call   8016fd <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 79 1d 80 00       	push   $0x801d79
  800080:	50                   	push   %eax
  800081:	e8 d3 12 00 00       	call   801359 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 7c 1d 80 00       	push   $0x801d7c
  800094:	e8 9e 04 00 00       	call   800537 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  80009c:	e8 81 17 00 00       	call   801822 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 a4 1d 80 00       	push   $0x801da4
  8000a9:	e8 89 04 00 00       	call   800537 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 66 19 00 00       	call   801a24 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 75 17 00 00       	call   80183c <gettst>
  8000c7:	83 f8 03             	cmp    $0x3,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 4a 14 00 00       	call   80151b <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(z);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 94 12 00 00       	call   801373 <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 c4 1d 80 00       	push   $0x801dc4
  8000ea:	e8 48 04 00 00       	call   800537 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  8000f9:	e8 1d 14 00 00       	call   80151b <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 dc 1d 80 00       	push   $0x801ddc
  800114:	6a 28                	push   $0x28
  800116:	68 5c 1d 80 00       	push   $0x801d5c
  80011b:	e8 5a 01 00 00       	call   80027a <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 7c 1e 80 00       	push   $0x801e7c
  800128:	e8 0a 04 00 00       	call   800537 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n%~Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 a0 1e 80 00       	push   $0x801ea0
  800138:	e8 fa 03 00 00       	call   800537 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp

	return;
  800140:	90                   	nop
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800149:	e8 96 15 00 00       	call   8016e4 <sys_getenvindex>
  80014e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800154:	89 d0                	mov    %edx,%eax
  800156:	c1 e0 02             	shl    $0x2,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	01 c0                	add    %eax,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	c1 e0 02             	shl    $0x2,%eax
  800162:	01 d0                	add    %edx,%eax
  800164:	01 c0                	add    %eax,%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 04             	shl    $0x4,%eax
  80016b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800170:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800175:	a1 04 30 80 00       	mov    0x803004,%eax
  80017a:	8a 40 20             	mov    0x20(%eax),%al
  80017d:	84 c0                	test   %al,%al
  80017f:	74 0d                	je     80018e <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800181:	a1 04 30 80 00       	mov    0x803004,%eax
  800186:	83 c0 20             	add    $0x20,%eax
  800189:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800192:	7e 0a                	jle    80019e <libmain+0x5b>
		binaryname = argv[0];
  800194:	8b 45 0c             	mov    0xc(%ebp),%eax
  800197:	8b 00                	mov    (%eax),%eax
  800199:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 0c             	pushl  0xc(%ebp)
  8001a4:	ff 75 08             	pushl  0x8(%ebp)
  8001a7:	e8 8c fe ff ff       	call   800038 <_main>
  8001ac:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001af:	e8 b4 12 00 00       	call   801468 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	68 08 1f 80 00       	push   $0x801f08
  8001bc:	e8 76 03 00 00       	call   800537 <cprintf>
  8001c1:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c4:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c9:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8001cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d4:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8001da:	83 ec 04             	sub    $0x4,%esp
  8001dd:	52                   	push   %edx
  8001de:	50                   	push   %eax
  8001df:	68 30 1f 80 00       	push   $0x801f30
  8001e4:	e8 4e 03 00 00       	call   800537 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8001f1:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8001f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8001fc:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800202:	a1 04 30 80 00       	mov    0x803004,%eax
  800207:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80020d:	51                   	push   %ecx
  80020e:	52                   	push   %edx
  80020f:	50                   	push   %eax
  800210:	68 58 1f 80 00       	push   $0x801f58
  800215:	e8 1d 03 00 00       	call   800537 <cprintf>
  80021a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021d:	a1 04 30 80 00       	mov    0x803004,%eax
  800222:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	50                   	push   %eax
  80022c:	68 b0 1f 80 00       	push   $0x801fb0
  800231:	e8 01 03 00 00       	call   800537 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800239:	83 ec 0c             	sub    $0xc,%esp
  80023c:	68 08 1f 80 00       	push   $0x801f08
  800241:	e8 f1 02 00 00       	call   800537 <cprintf>
  800246:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800249:	e8 34 12 00 00       	call   801482 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80024e:	e8 19 00 00 00       	call   80026c <exit>
}
  800253:	90                   	nop
  800254:	c9                   	leave  
  800255:	c3                   	ret    

00800256 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	6a 00                	push   $0x0
  800261:	e8 4a 14 00 00       	call   8016b0 <sys_destroy_env>
  800266:	83 c4 10             	add    $0x10,%esp
}
  800269:	90                   	nop
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <exit>:

void
exit(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800272:	e8 9f 14 00 00       	call   801716 <sys_exit_env>
}
  800277:	90                   	nop
  800278:	c9                   	leave  
  800279:	c3                   	ret    

0080027a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800280:	8d 45 10             	lea    0x10(%ebp),%eax
  800283:	83 c0 04             	add    $0x4,%eax
  800286:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800289:	a1 24 30 80 00       	mov    0x803024,%eax
  80028e:	85 c0                	test   %eax,%eax
  800290:	74 16                	je     8002a8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800292:	a1 24 30 80 00       	mov    0x803024,%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 c4 1f 80 00       	push   $0x801fc4
  8002a0:	e8 92 02 00 00       	call   800537 <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a8:	a1 00 30 80 00       	mov    0x803000,%eax
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	50                   	push   %eax
  8002b4:	68 c9 1f 80 00       	push   $0x801fc9
  8002b9:	e8 79 02 00 00       	call   800537 <cprintf>
  8002be:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ca:	50                   	push   %eax
  8002cb:	e8 fc 01 00 00       	call   8004cc <vcprintf>
  8002d0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	6a 00                	push   $0x0
  8002d8:	68 e5 1f 80 00       	push   $0x801fe5
  8002dd:	e8 ea 01 00 00       	call   8004cc <vcprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e5:	e8 82 ff ff ff       	call   80026c <exit>

	// should not return here
	while (1) ;
  8002ea:	eb fe                	jmp    8002ea <_panic+0x70>

008002ec <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800300:	39 c2                	cmp    %eax,%edx
  800302:	74 14                	je     800318 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	68 e8 1f 80 00       	push   $0x801fe8
  80030c:	6a 26                	push   $0x26
  80030e:	68 34 20 80 00       	push   $0x802034
  800313:	e8 62 ff ff ff       	call   80027a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800318:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80031f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800326:	e9 c5 00 00 00       	jmp    8003f0 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80032b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800335:	8b 45 08             	mov    0x8(%ebp),%eax
  800338:	01 d0                	add    %edx,%eax
  80033a:	8b 00                	mov    (%eax),%eax
  80033c:	85 c0                	test   %eax,%eax
  80033e:	75 08                	jne    800348 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800340:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800343:	e9 a5 00 00 00       	jmp    8003ed <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800348:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80034f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800356:	eb 69                	jmp    8003c1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800358:	a1 04 30 80 00       	mov    0x803004,%eax
  80035d:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800363:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800366:	89 d0                	mov    %edx,%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	c1 e0 03             	shl    $0x3,%eax
  80036f:	01 c8                	add    %ecx,%eax
  800371:	8a 40 04             	mov    0x4(%eax),%al
  800374:	84 c0                	test   %al,%al
  800376:	75 46                	jne    8003be <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800378:	a1 04 30 80 00       	mov    0x803004,%eax
  80037d:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800383:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800386:	89 d0                	mov    %edx,%eax
  800388:	01 c0                	add    %eax,%eax
  80038a:	01 d0                	add    %edx,%eax
  80038c:	c1 e0 03             	shl    $0x3,%eax
  80038f:	01 c8                	add    %ecx,%eax
  800391:	8b 00                	mov    (%eax),%eax
  800393:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800396:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800399:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80039e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	01 c8                	add    %ecx,%eax
  8003af:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b1:	39 c2                	cmp    %eax,%edx
  8003b3:	75 09                	jne    8003be <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003b5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003bc:	eb 15                	jmp    8003d3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003be:	ff 45 e8             	incl   -0x18(%ebp)
  8003c1:	a1 04 30 80 00       	mov    0x803004,%eax
  8003c6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003cf:	39 c2                	cmp    %eax,%edx
  8003d1:	77 85                	ja     800358 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d7:	75 14                	jne    8003ed <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	68 40 20 80 00       	push   $0x802040
  8003e1:	6a 3a                	push   $0x3a
  8003e3:	68 34 20 80 00       	push   $0x802034
  8003e8:	e8 8d fe ff ff       	call   80027a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ed:	ff 45 f0             	incl   -0x10(%ebp)
  8003f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f6:	0f 8c 2f ff ff ff    	jl     80032b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800403:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040a:	eb 26                	jmp    800432 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040c:	a1 04 30 80 00       	mov    0x803004,%eax
  800411:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800417:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041a:	89 d0                	mov    %edx,%eax
  80041c:	01 c0                	add    %eax,%eax
  80041e:	01 d0                	add    %edx,%eax
  800420:	c1 e0 03             	shl    $0x3,%eax
  800423:	01 c8                	add    %ecx,%eax
  800425:	8a 40 04             	mov    0x4(%eax),%al
  800428:	3c 01                	cmp    $0x1,%al
  80042a:	75 03                	jne    80042f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80042c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042f:	ff 45 e0             	incl   -0x20(%ebp)
  800432:	a1 04 30 80 00       	mov    0x803004,%eax
  800437:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80043d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800440:	39 c2                	cmp    %eax,%edx
  800442:	77 c8                	ja     80040c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80044a:	74 14                	je     800460 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 94 20 80 00       	push   $0x802094
  800454:	6a 44                	push   $0x44
  800456:	68 34 20 80 00       	push   $0x802034
  80045b:	e8 1a fe ff ff       	call   80027a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800460:	90                   	nop
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	8d 48 01             	lea    0x1(%eax),%ecx
  800471:	8b 55 0c             	mov    0xc(%ebp),%edx
  800474:	89 0a                	mov    %ecx,(%edx)
  800476:	8b 55 08             	mov    0x8(%ebp),%edx
  800479:	88 d1                	mov    %dl,%cl
  80047b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800482:	8b 45 0c             	mov    0xc(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048c:	75 2c                	jne    8004ba <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048e:	a0 08 30 80 00       	mov    0x803008,%al
  800493:	0f b6 c0             	movzbl %al,%eax
  800496:	8b 55 0c             	mov    0xc(%ebp),%edx
  800499:	8b 12                	mov    (%edx),%edx
  80049b:	89 d1                	mov    %edx,%ecx
  80049d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a0:	83 c2 08             	add    $0x8,%edx
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	50                   	push   %eax
  8004a7:	51                   	push   %ecx
  8004a8:	52                   	push   %edx
  8004a9:	e8 78 0f 00 00       	call   801426 <sys_cputs>
  8004ae:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	8b 40 04             	mov    0x4(%eax),%eax
  8004c0:	8d 50 01             	lea    0x1(%eax),%edx
  8004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c9:	90                   	nop
  8004ca:	c9                   	leave  
  8004cb:	c3                   	ret    

008004cc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004dc:	00 00 00 
	b.cnt = 0;
  8004df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e6:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e9:	ff 75 0c             	pushl  0xc(%ebp)
  8004ec:	ff 75 08             	pushl  0x8(%ebp)
  8004ef:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	68 63 04 80 00       	push   $0x800463
  8004fb:	e8 11 02 00 00       	call   800711 <vprintfmt>
  800500:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800503:	a0 08 30 80 00       	mov    0x803008,%al
  800508:	0f b6 c0             	movzbl %al,%eax
  80050b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800511:	83 ec 04             	sub    $0x4,%esp
  800514:	50                   	push   %eax
  800515:	52                   	push   %edx
  800516:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051c:	83 c0 08             	add    $0x8,%eax
  80051f:	50                   	push   %eax
  800520:	e8 01 0f 00 00       	call   801426 <sys_cputs>
  800525:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800528:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80052f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800535:	c9                   	leave  
  800536:	c3                   	ret    

00800537 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800537:	55                   	push   %ebp
  800538:	89 e5                	mov    %esp,%ebp
  80053a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053d:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800544:	8d 45 0c             	lea    0xc(%ebp),%eax
  800547:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054a:	8b 45 08             	mov    0x8(%ebp),%eax
  80054d:	83 ec 08             	sub    $0x8,%esp
  800550:	ff 75 f4             	pushl  -0xc(%ebp)
  800553:	50                   	push   %eax
  800554:	e8 73 ff ff ff       	call   8004cc <vcprintf>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800562:	c9                   	leave  
  800563:	c3                   	ret    

00800564 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80056a:	e8 f9 0e 00 00       	call   801468 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80056f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800572:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800575:	8b 45 08             	mov    0x8(%ebp),%eax
  800578:	83 ec 08             	sub    $0x8,%esp
  80057b:	ff 75 f4             	pushl  -0xc(%ebp)
  80057e:	50                   	push   %eax
  80057f:	e8 48 ff ff ff       	call   8004cc <vcprintf>
  800584:	83 c4 10             	add    $0x10,%esp
  800587:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80058a:	e8 f3 0e 00 00       	call   801482 <sys_unlock_cons>
	return cnt;
  80058f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800592:	c9                   	leave  
  800593:	c3                   	ret    

00800594 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	53                   	push   %ebx
  800598:	83 ec 14             	sub    $0x14,%esp
  80059b:	8b 45 10             	mov    0x10(%ebp),%eax
  80059e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b2:	77 55                	ja     800609 <printnum+0x75>
  8005b4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b7:	72 05                	jb     8005be <printnum+0x2a>
  8005b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bc:	77 4b                	ja     800609 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005be:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cc:	52                   	push   %edx
  8005cd:	50                   	push   %eax
  8005ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d4:	e8 ff 14 00 00       	call   801ad8 <__udivdi3>
  8005d9:	83 c4 10             	add    $0x10,%esp
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	ff 75 20             	pushl  0x20(%ebp)
  8005e2:	53                   	push   %ebx
  8005e3:	ff 75 18             	pushl  0x18(%ebp)
  8005e6:	52                   	push   %edx
  8005e7:	50                   	push   %eax
  8005e8:	ff 75 0c             	pushl  0xc(%ebp)
  8005eb:	ff 75 08             	pushl  0x8(%ebp)
  8005ee:	e8 a1 ff ff ff       	call   800594 <printnum>
  8005f3:	83 c4 20             	add    $0x20,%esp
  8005f6:	eb 1a                	jmp    800612 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f8:	83 ec 08             	sub    $0x8,%esp
  8005fb:	ff 75 0c             	pushl  0xc(%ebp)
  8005fe:	ff 75 20             	pushl  0x20(%ebp)
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	ff d0                	call   *%eax
  800606:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800609:	ff 4d 1c             	decl   0x1c(%ebp)
  80060c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800610:	7f e6                	jg     8005f8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800612:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800615:	bb 00 00 00 00       	mov    $0x0,%ebx
  80061a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800620:	53                   	push   %ebx
  800621:	51                   	push   %ecx
  800622:	52                   	push   %edx
  800623:	50                   	push   %eax
  800624:	e8 bf 15 00 00       	call   801be8 <__umoddi3>
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	05 f4 22 80 00       	add    $0x8022f4,%eax
  800631:	8a 00                	mov    (%eax),%al
  800633:	0f be c0             	movsbl %al,%eax
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	ff 75 0c             	pushl  0xc(%ebp)
  80063c:	50                   	push   %eax
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	ff d0                	call   *%eax
  800642:	83 c4 10             	add    $0x10,%esp
}
  800645:	90                   	nop
  800646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800652:	7e 1c                	jle    800670 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	8d 50 08             	lea    0x8(%eax),%edx
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	89 10                	mov    %edx,(%eax)
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	83 e8 08             	sub    $0x8,%eax
  800669:	8b 50 04             	mov    0x4(%eax),%edx
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	eb 40                	jmp    8006b0 <getuint+0x65>
	else if (lflag)
  800670:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800674:	74 1e                	je     800694 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	8d 50 04             	lea    0x4(%eax),%edx
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	89 10                	mov    %edx,(%eax)
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	83 e8 04             	sub    $0x4,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	ba 00 00 00 00       	mov    $0x0,%edx
  800692:	eb 1c                	jmp    8006b0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	8d 50 04             	lea    0x4(%eax),%edx
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	89 10                	mov    %edx,(%eax)
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	83 e8 04             	sub    $0x4,%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006b0:	5d                   	pop    %ebp
  8006b1:	c3                   	ret    

008006b2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b2:	55                   	push   %ebp
  8006b3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b9:	7e 1c                	jle    8006d7 <getint+0x25>
		return va_arg(*ap, long long);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	8d 50 08             	lea    0x8(%eax),%edx
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	89 10                	mov    %edx,(%eax)
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	83 e8 08             	sub    $0x8,%eax
  8006d0:	8b 50 04             	mov    0x4(%eax),%edx
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	eb 38                	jmp    80070f <getint+0x5d>
	else if (lflag)
  8006d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006db:	74 1a                	je     8006f7 <getint+0x45>
		return va_arg(*ap, long);
  8006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	8d 50 04             	lea    0x4(%eax),%edx
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	89 10                	mov    %edx,(%eax)
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	83 e8 04             	sub    $0x4,%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	99                   	cltd   
  8006f5:	eb 18                	jmp    80070f <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	8d 50 04             	lea    0x4(%eax),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	89 10                	mov    %edx,(%eax)
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	83 e8 04             	sub    $0x4,%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	99                   	cltd   
}
  80070f:	5d                   	pop    %ebp
  800710:	c3                   	ret    

00800711 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	56                   	push   %esi
  800715:	53                   	push   %ebx
  800716:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800719:	eb 17                	jmp    800732 <vprintfmt+0x21>
			if (ch == '\0')
  80071b:	85 db                	test   %ebx,%ebx
  80071d:	0f 84 c1 03 00 00    	je     800ae4 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	ff 75 0c             	pushl  0xc(%ebp)
  800729:	53                   	push   %ebx
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	ff d0                	call   *%eax
  80072f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800732:	8b 45 10             	mov    0x10(%ebp),%eax
  800735:	8d 50 01             	lea    0x1(%eax),%edx
  800738:	89 55 10             	mov    %edx,0x10(%ebp)
  80073b:	8a 00                	mov    (%eax),%al
  80073d:	0f b6 d8             	movzbl %al,%ebx
  800740:	83 fb 25             	cmp    $0x25,%ebx
  800743:	75 d6                	jne    80071b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800745:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800749:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800750:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800757:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	8d 50 01             	lea    0x1(%eax),%edx
  80076b:	89 55 10             	mov    %edx,0x10(%ebp)
  80076e:	8a 00                	mov    (%eax),%al
  800770:	0f b6 d8             	movzbl %al,%ebx
  800773:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800776:	83 f8 5b             	cmp    $0x5b,%eax
  800779:	0f 87 3d 03 00 00    	ja     800abc <vprintfmt+0x3ab>
  80077f:	8b 04 85 18 23 80 00 	mov    0x802318(,%eax,4),%eax
  800786:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800788:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078c:	eb d7                	jmp    800765 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800792:	eb d1                	jmp    800765 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800794:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079e:	89 d0                	mov    %edx,%eax
  8007a0:	c1 e0 02             	shl    $0x2,%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	01 c0                	add    %eax,%eax
  8007a7:	01 d8                	add    %ebx,%eax
  8007a9:	83 e8 30             	sub    $0x30,%eax
  8007ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007af:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b2:	8a 00                	mov    (%eax),%al
  8007b4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b7:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ba:	7e 3e                	jle    8007fa <vprintfmt+0xe9>
  8007bc:	83 fb 39             	cmp    $0x39,%ebx
  8007bf:	7f 39                	jg     8007fa <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c4:	eb d5                	jmp    80079b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	83 c0 04             	add    $0x4,%eax
  8007cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	83 e8 04             	sub    $0x4,%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007da:	eb 1f                	jmp    8007fb <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e0:	79 83                	jns    800765 <vprintfmt+0x54>
				width = 0;
  8007e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e9:	e9 77 ff ff ff       	jmp    800765 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ee:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f5:	e9 6b ff ff ff       	jmp    800765 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007fa:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ff:	0f 89 60 ff ff ff    	jns    800765 <vprintfmt+0x54>
				width = precision, precision = -1;
  800805:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800808:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800812:	e9 4e ff ff ff       	jmp    800765 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800817:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80081a:	e9 46 ff ff ff       	jmp    800765 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	83 c0 04             	add    $0x4,%eax
  800825:	89 45 14             	mov    %eax,0x14(%ebp)
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	83 e8 04             	sub    $0x4,%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	50                   	push   %eax
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
			break;
  80083f:	e9 9b 02 00 00       	jmp    800adf <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	83 c0 04             	add    $0x4,%eax
  80084a:	89 45 14             	mov    %eax,0x14(%ebp)
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	83 e8 04             	sub    $0x4,%eax
  800853:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800855:	85 db                	test   %ebx,%ebx
  800857:	79 02                	jns    80085b <vprintfmt+0x14a>
				err = -err;
  800859:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085b:	83 fb 64             	cmp    $0x64,%ebx
  80085e:	7f 0b                	jg     80086b <vprintfmt+0x15a>
  800860:	8b 34 9d 60 21 80 00 	mov    0x802160(,%ebx,4),%esi
  800867:	85 f6                	test   %esi,%esi
  800869:	75 19                	jne    800884 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086b:	53                   	push   %ebx
  80086c:	68 05 23 80 00       	push   $0x802305
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	ff 75 08             	pushl  0x8(%ebp)
  800877:	e8 70 02 00 00       	call   800aec <printfmt>
  80087c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087f:	e9 5b 02 00 00       	jmp    800adf <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800884:	56                   	push   %esi
  800885:	68 0e 23 80 00       	push   $0x80230e
  80088a:	ff 75 0c             	pushl  0xc(%ebp)
  80088d:	ff 75 08             	pushl  0x8(%ebp)
  800890:	e8 57 02 00 00       	call   800aec <printfmt>
  800895:	83 c4 10             	add    $0x10,%esp
			break;
  800898:	e9 42 02 00 00       	jmp    800adf <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	83 c0 04             	add    $0x4,%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	83 e8 04             	sub    $0x4,%eax
  8008ac:	8b 30                	mov    (%eax),%esi
  8008ae:	85 f6                	test   %esi,%esi
  8008b0:	75 05                	jne    8008b7 <vprintfmt+0x1a6>
				p = "(null)";
  8008b2:	be 11 23 80 00       	mov    $0x802311,%esi
			if (width > 0 && padc != '-')
  8008b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bb:	7e 6d                	jle    80092a <vprintfmt+0x219>
  8008bd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c1:	74 67                	je     80092a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	50                   	push   %eax
  8008ca:	56                   	push   %esi
  8008cb:	e8 1e 03 00 00       	call   800bee <strnlen>
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d6:	eb 16                	jmp    8008ee <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 0c             	pushl  0xc(%ebp)
  8008e2:	50                   	push   %eax
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	ff d0                	call   *%eax
  8008e8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f2:	7f e4                	jg     8008d8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f4:	eb 34                	jmp    80092a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008fa:	74 1c                	je     800918 <vprintfmt+0x207>
  8008fc:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ff:	7e 05                	jle    800906 <vprintfmt+0x1f5>
  800901:	83 fb 7e             	cmp    $0x7e,%ebx
  800904:	7e 12                	jle    800918 <vprintfmt+0x207>
					putch('?', putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	6a 3f                	push   $0x3f
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	ff d0                	call   *%eax
  800913:	83 c4 10             	add    $0x10,%esp
  800916:	eb 0f                	jmp    800927 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	53                   	push   %ebx
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	ff d0                	call   *%eax
  800924:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	ff 4d e4             	decl   -0x1c(%ebp)
  80092a:	89 f0                	mov    %esi,%eax
  80092c:	8d 70 01             	lea    0x1(%eax),%esi
  80092f:	8a 00                	mov    (%eax),%al
  800931:	0f be d8             	movsbl %al,%ebx
  800934:	85 db                	test   %ebx,%ebx
  800936:	74 24                	je     80095c <vprintfmt+0x24b>
  800938:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093c:	78 b8                	js     8008f6 <vprintfmt+0x1e5>
  80093e:	ff 4d e0             	decl   -0x20(%ebp)
  800941:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800945:	79 af                	jns    8008f6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800947:	eb 13                	jmp    80095c <vprintfmt+0x24b>
				putch(' ', putdat);
  800949:	83 ec 08             	sub    $0x8,%esp
  80094c:	ff 75 0c             	pushl  0xc(%ebp)
  80094f:	6a 20                	push   $0x20
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800959:	ff 4d e4             	decl   -0x1c(%ebp)
  80095c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800960:	7f e7                	jg     800949 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800962:	e9 78 01 00 00       	jmp    800adf <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 e8             	pushl  -0x18(%ebp)
  80096d:	8d 45 14             	lea    0x14(%ebp),%eax
  800970:	50                   	push   %eax
  800971:	e8 3c fd ff ff       	call   8006b2 <getint>
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800985:	85 d2                	test   %edx,%edx
  800987:	79 23                	jns    8009ac <vprintfmt+0x29b>
				putch('-', putdat);
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	6a 2d                	push   $0x2d
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	ff d0                	call   *%eax
  800996:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800999:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099f:	f7 d8                	neg    %eax
  8009a1:	83 d2 00             	adc    $0x0,%edx
  8009a4:	f7 da                	neg    %edx
  8009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ac:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b3:	e9 bc 00 00 00       	jmp    800a74 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 e8             	pushl  -0x18(%ebp)
  8009be:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c1:	50                   	push   %eax
  8009c2:	e8 84 fc ff ff       	call   80064b <getuint>
  8009c7:	83 c4 10             	add    $0x10,%esp
  8009ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009d0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d7:	e9 98 00 00 00       	jmp    800a74 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	6a 58                	push   $0x58
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	ff d0                	call   *%eax
  8009e9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	6a 58                	push   $0x58
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	ff d0                	call   *%eax
  8009f9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fc:	83 ec 08             	sub    $0x8,%esp
  8009ff:	ff 75 0c             	pushl  0xc(%ebp)
  800a02:	6a 58                	push   $0x58
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	ff d0                	call   *%eax
  800a09:	83 c4 10             	add    $0x10,%esp
			break;
  800a0c:	e9 ce 00 00 00       	jmp    800adf <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a11:	83 ec 08             	sub    $0x8,%esp
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	6a 30                	push   $0x30
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	ff d0                	call   *%eax
  800a1e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a21:	83 ec 08             	sub    $0x8,%esp
  800a24:	ff 75 0c             	pushl  0xc(%ebp)
  800a27:	6a 78                	push   $0x78
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	ff d0                	call   *%eax
  800a2e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a31:	8b 45 14             	mov    0x14(%ebp),%eax
  800a34:	83 c0 04             	add    $0x4,%eax
  800a37:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3d:	83 e8 04             	sub    $0x4,%eax
  800a40:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a53:	eb 1f                	jmp    800a74 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5e:	50                   	push   %eax
  800a5f:	e8 e7 fb ff ff       	call   80064b <getuint>
  800a64:	83 c4 10             	add    $0x10,%esp
  800a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a74:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	52                   	push   %edx
  800a7f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a82:	50                   	push   %eax
  800a83:	ff 75 f4             	pushl  -0xc(%ebp)
  800a86:	ff 75 f0             	pushl  -0x10(%ebp)
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	ff 75 08             	pushl  0x8(%ebp)
  800a8f:	e8 00 fb ff ff       	call   800594 <printnum>
  800a94:	83 c4 20             	add    $0x20,%esp
			break;
  800a97:	eb 46                	jmp    800adf <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a99:	83 ec 08             	sub    $0x8,%esp
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	53                   	push   %ebx
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	ff d0                	call   *%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
			break;
  800aa8:	eb 35                	jmp    800adf <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aaa:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800ab1:	eb 2c                	jmp    800adf <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ab3:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800aba:	eb 23                	jmp    800adf <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	6a 25                	push   $0x25
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	ff d0                	call   *%eax
  800ac9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800acc:	ff 4d 10             	decl   0x10(%ebp)
  800acf:	eb 03                	jmp    800ad4 <vprintfmt+0x3c3>
  800ad1:	ff 4d 10             	decl   0x10(%ebp)
  800ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad7:	48                   	dec    %eax
  800ad8:	8a 00                	mov    (%eax),%al
  800ada:	3c 25                	cmp    $0x25,%al
  800adc:	75 f3                	jne    800ad1 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ade:	90                   	nop
		}
	}
  800adf:	e9 35 fc ff ff       	jmp    800719 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ae4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800af2:	8d 45 10             	lea    0x10(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800afb:	8b 45 10             	mov    0x10(%ebp),%eax
  800afe:	ff 75 f4             	pushl  -0xc(%ebp)
  800b01:	50                   	push   %eax
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	ff 75 08             	pushl  0x8(%ebp)
  800b08:	e8 04 fc ff ff       	call   800711 <vprintfmt>
  800b0d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b10:	90                   	nop
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    

00800b13 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 40 08             	mov    0x8(%eax),%eax
  800b1c:	8d 50 01             	lea    0x1(%eax),%edx
  800b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b22:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 10                	mov    (%eax),%edx
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 40 04             	mov    0x4(%eax),%eax
  800b30:	39 c2                	cmp    %eax,%edx
  800b32:	73 12                	jae    800b46 <sprintputch+0x33>
		*b->buf++ = ch;
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	8d 48 01             	lea    0x1(%eax),%ecx
  800b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3f:	89 0a                	mov    %ecx,(%edx)
  800b41:	8b 55 08             	mov    0x8(%ebp),%edx
  800b44:	88 10                	mov    %dl,(%eax)
}
  800b46:	90                   	nop
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	01 d0                	add    %edx,%eax
  800b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6e:	74 06                	je     800b76 <vsnprintf+0x2d>
  800b70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b74:	7f 07                	jg     800b7d <vsnprintf+0x34>
		return -E_INVAL;
  800b76:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7b:	eb 20                	jmp    800b9d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b7d:	ff 75 14             	pushl  0x14(%ebp)
  800b80:	ff 75 10             	pushl  0x10(%ebp)
  800b83:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	68 13 0b 80 00       	push   $0x800b13
  800b8c:	e8 80 fb ff ff       	call   800711 <vprintfmt>
  800b91:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b97:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba5:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba8:	83 c0 04             	add    $0x4,%eax
  800bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bae:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb4:	50                   	push   %eax
  800bb5:	ff 75 0c             	pushl  0xc(%ebp)
  800bb8:	ff 75 08             	pushl  0x8(%ebp)
  800bbb:	e8 89 ff ff ff       	call   800b49 <vsnprintf>
  800bc0:	83 c4 10             	add    $0x10,%esp
  800bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd8:	eb 06                	jmp    800be0 <strlen+0x15>
		n++;
  800bda:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bdd:	ff 45 08             	incl   0x8(%ebp)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8a 00                	mov    (%eax),%al
  800be5:	84 c0                	test   %al,%al
  800be7:	75 f1                	jne    800bda <strlen+0xf>
		n++;
	return n;
  800be9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bfb:	eb 09                	jmp    800c06 <strnlen+0x18>
		n++;
  800bfd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c00:	ff 45 08             	incl   0x8(%ebp)
  800c03:	ff 4d 0c             	decl   0xc(%ebp)
  800c06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0a:	74 09                	je     800c15 <strnlen+0x27>
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8a 00                	mov    (%eax),%al
  800c11:	84 c0                	test   %al,%al
  800c13:	75 e8                	jne    800bfd <strnlen+0xf>
		n++;
	return n;
  800c15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c26:	90                   	nop
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8d 50 01             	lea    0x1(%eax),%edx
  800c2d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c33:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c36:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c39:	8a 12                	mov    (%edx),%dl
  800c3b:	88 10                	mov    %dl,(%eax)
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	84 c0                	test   %al,%al
  800c41:	75 e4                	jne    800c27 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c43:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5b:	eb 1f                	jmp    800c7c <strncpy+0x34>
		*dst++ = *src;
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8d 50 01             	lea    0x1(%eax),%edx
  800c63:	89 55 08             	mov    %edx,0x8(%ebp)
  800c66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c69:	8a 12                	mov    (%edx),%dl
  800c6b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	84 c0                	test   %al,%al
  800c74:	74 03                	je     800c79 <strncpy+0x31>
			src++;
  800c76:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c79:	ff 45 fc             	incl   -0x4(%ebp)
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c82:	72 d9                	jb     800c5d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c84:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c99:	74 30                	je     800ccb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c9b:	eb 16                	jmp    800cb3 <strlcpy+0x2a>
			*dst++ = *src++;
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8d 50 01             	lea    0x1(%eax),%edx
  800ca3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800caf:	8a 12                	mov    (%edx),%dl
  800cb1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cb3:	ff 4d 10             	decl   0x10(%ebp)
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	74 09                	je     800cc5 <strlcpy+0x3c>
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	75 d8                	jne    800c9d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd1:	29 c2                	sub    %eax,%edx
  800cd3:	89 d0                	mov    %edx,%eax
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cda:	eb 06                	jmp    800ce2 <strcmp+0xb>
		p++, q++;
  800cdc:	ff 45 08             	incl   0x8(%ebp)
  800cdf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	84 c0                	test   %al,%al
  800ce9:	74 0e                	je     800cf9 <strcmp+0x22>
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8a 10                	mov    (%eax),%dl
  800cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	38 c2                	cmp    %al,%dl
  800cf7:	74 e3                	je     800cdc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	0f b6 d0             	movzbl %al,%edx
  800d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	0f b6 c0             	movzbl %al,%eax
  800d09:	29 c2                	sub    %eax,%edx
  800d0b:	89 d0                	mov    %edx,%eax
}
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    

00800d0f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d12:	eb 09                	jmp    800d1d <strncmp+0xe>
		n--, p++, q++;
  800d14:	ff 4d 10             	decl   0x10(%ebp)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d21:	74 17                	je     800d3a <strncmp+0x2b>
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	74 0e                	je     800d3a <strncmp+0x2b>
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 10                	mov    (%eax),%dl
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	38 c2                	cmp    %al,%dl
  800d38:	74 da                	je     800d14 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	75 07                	jne    800d47 <strncmp+0x38>
		return 0;
  800d40:	b8 00 00 00 00       	mov    $0x0,%eax
  800d45:	eb 14                	jmp    800d5b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	0f b6 d0             	movzbl %al,%edx
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	0f b6 c0             	movzbl %al,%eax
  800d57:	29 c2                	sub    %eax,%edx
  800d59:	89 d0                	mov    %edx,%eax
}
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    

00800d5d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 04             	sub    $0x4,%esp
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d69:	eb 12                	jmp    800d7d <strchr+0x20>
		if (*s == c)
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d73:	75 05                	jne    800d7a <strchr+0x1d>
			return (char *) s;
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	eb 11                	jmp    800d8b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d7a:	ff 45 08             	incl   0x8(%ebp)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	84 c0                	test   %al,%al
  800d84:	75 e5                	jne    800d6b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d8b:	c9                   	leave  
  800d8c:	c3                   	ret    

00800d8d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	83 ec 04             	sub    $0x4,%esp
  800d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d96:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d99:	eb 0d                	jmp    800da8 <strfind+0x1b>
		if (*s == c)
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da3:	74 0e                	je     800db3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da5:	ff 45 08             	incl   0x8(%ebp)
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	84 c0                	test   %al,%al
  800daf:	75 ea                	jne    800d9b <strfind+0xe>
  800db1:	eb 01                	jmp    800db4 <strfind+0x27>
		if (*s == c)
			break;
  800db3:	90                   	nop
	return (char *) s;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dcb:	eb 0e                	jmp    800ddb <memset+0x22>
		*p++ = c;
  800dcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd0:	8d 50 01             	lea    0x1(%eax),%edx
  800dd3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ddb:	ff 4d f8             	decl   -0x8(%ebp)
  800dde:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800de2:	79 e9                	jns    800dcd <memset+0x14>
		*p++ = c;

	return v;
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dfb:	eb 16                	jmp    800e13 <memcpy+0x2a>
		*d++ = *s++;
  800dfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e00:	8d 50 01             	lea    0x1(%eax),%edx
  800e03:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0f:	8a 12                	mov    (%edx),%dl
  800e11:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e19:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	75 dd                	jne    800dfd <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e3d:	73 50                	jae    800e8f <memmove+0x6a>
  800e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e42:	8b 45 10             	mov    0x10(%ebp),%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e4a:	76 43                	jbe    800e8f <memmove+0x6a>
		s += n;
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e52:	8b 45 10             	mov    0x10(%ebp),%eax
  800e55:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e58:	eb 10                	jmp    800e6a <memmove+0x45>
			*--d = *--s;
  800e5a:	ff 4d f8             	decl   -0x8(%ebp)
  800e5d:	ff 4d fc             	decl   -0x4(%ebp)
  800e60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e63:	8a 10                	mov    (%eax),%dl
  800e65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e68:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e70:	89 55 10             	mov    %edx,0x10(%ebp)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	75 e3                	jne    800e5a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e77:	eb 23                	jmp    800e9c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7c:	8d 50 01             	lea    0x1(%eax),%edx
  800e7f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e88:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8b:	8a 12                	mov    (%edx),%dl
  800e8d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e95:	89 55 10             	mov    %edx,0x10(%ebp)
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	75 dd                	jne    800e79 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9f:	c9                   	leave  
  800ea0:	c3                   	ret    

00800ea1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eb3:	eb 2a                	jmp    800edf <memcmp+0x3e>
		if (*s1 != *s2)
  800eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb8:	8a 10                	mov    (%eax),%dl
  800eba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	38 c2                	cmp    %al,%dl
  800ec1:	74 16                	je     800ed9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ec3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	0f b6 d0             	movzbl %al,%edx
  800ecb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	0f b6 c0             	movzbl %al,%eax
  800ed3:	29 c2                	sub    %eax,%edx
  800ed5:	89 d0                	mov    %edx,%eax
  800ed7:	eb 18                	jmp    800ef1 <memcmp+0x50>
		s1++, s2++;
  800ed9:	ff 45 fc             	incl   -0x4(%ebp)
  800edc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800edf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	75 c9                	jne    800eb5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	01 d0                	add    %edx,%eax
  800f01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f04:	eb 15                	jmp    800f1b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	0f b6 d0             	movzbl %al,%edx
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	0f b6 c0             	movzbl %al,%eax
  800f14:	39 c2                	cmp    %eax,%edx
  800f16:	74 0d                	je     800f25 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f18:	ff 45 08             	incl   0x8(%ebp)
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f21:	72 e3                	jb     800f06 <memfind+0x13>
  800f23:	eb 01                	jmp    800f26 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f25:	90                   	nop
	return (void *) s;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    

00800f2b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f38:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3f:	eb 03                	jmp    800f44 <strtol+0x19>
		s++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	3c 20                	cmp    $0x20,%al
  800f4b:	74 f4                	je     800f41 <strtol+0x16>
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	3c 09                	cmp    $0x9,%al
  800f54:	74 eb                	je     800f41 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	3c 2b                	cmp    $0x2b,%al
  800f5d:	75 05                	jne    800f64 <strtol+0x39>
		s++;
  800f5f:	ff 45 08             	incl   0x8(%ebp)
  800f62:	eb 13                	jmp    800f77 <strtol+0x4c>
	else if (*s == '-')
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	3c 2d                	cmp    $0x2d,%al
  800f6b:	75 0a                	jne    800f77 <strtol+0x4c>
		s++, neg = 1;
  800f6d:	ff 45 08             	incl   0x8(%ebp)
  800f70:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7b:	74 06                	je     800f83 <strtol+0x58>
  800f7d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f81:	75 20                	jne    800fa3 <strtol+0x78>
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	3c 30                	cmp    $0x30,%al
  800f8a:	75 17                	jne    800fa3 <strtol+0x78>
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	40                   	inc    %eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	3c 78                	cmp    $0x78,%al
  800f94:	75 0d                	jne    800fa3 <strtol+0x78>
		s += 2, base = 16;
  800f96:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f9a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fa1:	eb 28                	jmp    800fcb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fa3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa7:	75 15                	jne    800fbe <strtol+0x93>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 30                	cmp    $0x30,%al
  800fb0:	75 0c                	jne    800fbe <strtol+0x93>
		s++, base = 8;
  800fb2:	ff 45 08             	incl   0x8(%ebp)
  800fb5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fbc:	eb 0d                	jmp    800fcb <strtol+0xa0>
	else if (base == 0)
  800fbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc2:	75 07                	jne    800fcb <strtol+0xa0>
		base = 10;
  800fc4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	3c 2f                	cmp    $0x2f,%al
  800fd2:	7e 19                	jle    800fed <strtol+0xc2>
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	3c 39                	cmp    $0x39,%al
  800fdb:	7f 10                	jg     800fed <strtol+0xc2>
			dig = *s - '0';
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	0f be c0             	movsbl %al,%eax
  800fe5:	83 e8 30             	sub    $0x30,%eax
  800fe8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800feb:	eb 42                	jmp    80102f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3c 60                	cmp    $0x60,%al
  800ff4:	7e 19                	jle    80100f <strtol+0xe4>
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 7a                	cmp    $0x7a,%al
  800ffd:	7f 10                	jg     80100f <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	0f be c0             	movsbl %al,%eax
  801007:	83 e8 57             	sub    $0x57,%eax
  80100a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100d:	eb 20                	jmp    80102f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	3c 40                	cmp    $0x40,%al
  801016:	7e 39                	jle    801051 <strtol+0x126>
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	3c 5a                	cmp    $0x5a,%al
  80101f:	7f 30                	jg     801051 <strtol+0x126>
			dig = *s - 'A' + 10;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	0f be c0             	movsbl %al,%eax
  801029:	83 e8 37             	sub    $0x37,%eax
  80102c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80102f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801032:	3b 45 10             	cmp    0x10(%ebp),%eax
  801035:	7d 19                	jge    801050 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801037:	ff 45 08             	incl   0x8(%ebp)
  80103a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801041:	89 c2                	mov    %eax,%edx
  801043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80104b:	e9 7b ff ff ff       	jmp    800fcb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801050:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801051:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801055:	74 08                	je     80105f <strtol+0x134>
		*endptr = (char *) s;
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	8b 55 08             	mov    0x8(%ebp),%edx
  80105d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80105f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801063:	74 07                	je     80106c <strtol+0x141>
  801065:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801068:	f7 d8                	neg    %eax
  80106a:	eb 03                	jmp    80106f <strtol+0x144>
  80106c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <ltostr>:

void
ltostr(long value, char *str)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80107e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801089:	79 13                	jns    80109e <ltostr+0x2d>
	{
		neg = 1;
  80108b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801098:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80109b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a6:	99                   	cltd   
  8010a7:	f7 f9                	idiv   %ecx
  8010a9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010af:	8d 50 01             	lea    0x1(%eax),%edx
  8010b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b5:	89 c2                	mov    %eax,%edx
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	01 d0                	add    %edx,%eax
  8010bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010bf:	83 c2 30             	add    $0x30,%edx
  8010c2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cc:	f7 e9                	imul   %ecx
  8010ce:	c1 fa 02             	sar    $0x2,%edx
  8010d1:	89 c8                	mov    %ecx,%eax
  8010d3:	c1 f8 1f             	sar    $0x1f,%eax
  8010d6:	29 c2                	sub    %eax,%edx
  8010d8:	89 d0                	mov    %edx,%eax
  8010da:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010e1:	75 bb                	jne    80109e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ed:	48                   	dec    %eax
  8010ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f5:	74 3d                	je     801134 <ltostr+0xc3>
		start = 1 ;
  8010f7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010fe:	eb 34                	jmp    801134 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801100:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80110d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801110:	8b 45 0c             	mov    0xc(%ebp),%eax
  801113:	01 c2                	add    %eax,%edx
  801115:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	01 c8                	add    %ecx,%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801121:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c2                	add    %eax,%edx
  801129:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112c:	88 02                	mov    %al,(%edx)
		start++ ;
  80112e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801131:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801137:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113a:	7c c4                	jl     801100 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 d0                	add    %edx,%eax
  801144:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801147:	90                   	nop
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801150:	ff 75 08             	pushl  0x8(%ebp)
  801153:	e8 73 fa ff ff       	call   800bcb <strlen>
  801158:	83 c4 04             	add    $0x4,%esp
  80115b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80115e:	ff 75 0c             	pushl  0xc(%ebp)
  801161:	e8 65 fa ff ff       	call   800bcb <strlen>
  801166:	83 c4 04             	add    $0x4,%esp
  801169:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801173:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117a:	eb 17                	jmp    801193 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117f:	8b 45 10             	mov    0x10(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	01 c8                	add    %ecx,%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801190:	ff 45 fc             	incl   -0x4(%ebp)
  801193:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801196:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801199:	7c e1                	jl     80117c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a9:	eb 1f                	jmp    8011ca <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ae:	8d 50 01             	lea    0x1(%eax),%edx
  8011b1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b4:	89 c2                	mov    %eax,%edx
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	01 c2                	add    %eax,%edx
  8011bb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	01 c8                	add    %ecx,%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c7:	ff 45 f8             	incl   -0x8(%ebp)
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d0:	7c d9                	jl     8011ab <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d8:	01 d0                	add    %edx,%eax
  8011da:	c6 00 00             	movb   $0x0,(%eax)
}
  8011dd:	90                   	nop
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	8b 00                	mov    (%eax),%eax
  8011f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fb:	01 d0                	add    %edx,%eax
  8011fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801203:	eb 0c                	jmp    801211 <strsplit+0x31>
			*string++ = 0;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8d 50 01             	lea    0x1(%eax),%edx
  80120b:	89 55 08             	mov    %edx,0x8(%ebp)
  80120e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	84 c0                	test   %al,%al
  801218:	74 18                	je     801232 <strsplit+0x52>
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	0f be c0             	movsbl %al,%eax
  801222:	50                   	push   %eax
  801223:	ff 75 0c             	pushl  0xc(%ebp)
  801226:	e8 32 fb ff ff       	call   800d5d <strchr>
  80122b:	83 c4 08             	add    $0x8,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	75 d3                	jne    801205 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	84 c0                	test   %al,%al
  801239:	74 5a                	je     801295 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123b:	8b 45 14             	mov    0x14(%ebp),%eax
  80123e:	8b 00                	mov    (%eax),%eax
  801240:	83 f8 0f             	cmp    $0xf,%eax
  801243:	75 07                	jne    80124c <strsplit+0x6c>
		{
			return 0;
  801245:	b8 00 00 00 00       	mov    $0x0,%eax
  80124a:	eb 66                	jmp    8012b2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124c:	8b 45 14             	mov    0x14(%ebp),%eax
  80124f:	8b 00                	mov    (%eax),%eax
  801251:	8d 48 01             	lea    0x1(%eax),%ecx
  801254:	8b 55 14             	mov    0x14(%ebp),%edx
  801257:	89 0a                	mov    %ecx,(%edx)
  801259:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 c2                	add    %eax,%edx
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126a:	eb 03                	jmp    80126f <strsplit+0x8f>
			string++;
  80126c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	84 c0                	test   %al,%al
  801276:	74 8b                	je     801203 <strsplit+0x23>
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	0f be c0             	movsbl %al,%eax
  801280:	50                   	push   %eax
  801281:	ff 75 0c             	pushl  0xc(%ebp)
  801284:	e8 d4 fa ff ff       	call   800d5d <strchr>
  801289:	83 c4 08             	add    $0x8,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	74 dc                	je     80126c <strsplit+0x8c>
			string++;
	}
  801290:	e9 6e ff ff ff       	jmp    801203 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801295:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801296:	8b 45 14             	mov    0x14(%ebp),%eax
  801299:	8b 00                	mov    (%eax),%eax
  80129b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	01 d0                	add    %edx,%eax
  8012a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ad:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	68 88 24 80 00       	push   $0x802488
  8012c2:	68 3f 01 00 00       	push   $0x13f
  8012c7:	68 aa 24 80 00       	push   $0x8024aa
  8012cc:	e8 a9 ef ff ff       	call   80027a <_panic>

008012d1 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8012d7:	83 ec 0c             	sub    $0xc,%esp
  8012da:	ff 75 08             	pushl  0x8(%ebp)
  8012dd:	e8 ef 06 00 00       	call   8019d1 <sys_sbrk>
  8012e2:	83 c4 10             	add    $0x10,%esp
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8012ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f1:	75 07                	jne    8012fa <malloc+0x13>
  8012f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f8:	eb 14                	jmp    80130e <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8012fa:	83 ec 04             	sub    $0x4,%esp
  8012fd:	68 b8 24 80 00       	push   $0x8024b8
  801302:	6a 1b                	push   $0x1b
  801304:	68 dd 24 80 00       	push   $0x8024dd
  801309:	e8 6c ef ff ff       	call   80027a <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801316:	83 ec 04             	sub    $0x4,%esp
  801319:	68 ec 24 80 00       	push   $0x8024ec
  80131e:	6a 29                	push   $0x29
  801320:	68 dd 24 80 00       	push   $0x8024dd
  801325:	e8 50 ef ff ff       	call   80027a <_panic>

0080132a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 18             	sub    $0x18,%esp
  801330:	8b 45 10             	mov    0x10(%ebp),%eax
  801333:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801336:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80133a:	75 07                	jne    801343 <smalloc+0x19>
  80133c:	b8 00 00 00 00       	mov    $0x0,%eax
  801341:	eb 14                	jmp    801357 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801343:	83 ec 04             	sub    $0x4,%esp
  801346:	68 10 25 80 00       	push   $0x802510
  80134b:	6a 38                	push   $0x38
  80134d:	68 dd 24 80 00       	push   $0x8024dd
  801352:	e8 23 ef ff ff       	call   80027a <_panic>
	return NULL;
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80135f:	83 ec 04             	sub    $0x4,%esp
  801362:	68 38 25 80 00       	push   $0x802538
  801367:	6a 43                	push   $0x43
  801369:	68 dd 24 80 00       	push   $0x8024dd
  80136e:	e8 07 ef ff ff       	call   80027a <_panic>

00801373 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801379:	83 ec 04             	sub    $0x4,%esp
  80137c:	68 5c 25 80 00       	push   $0x80255c
  801381:	6a 5b                	push   $0x5b
  801383:	68 dd 24 80 00       	push   $0x8024dd
  801388:	e8 ed ee ff ff       	call   80027a <_panic>

0080138d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	68 80 25 80 00       	push   $0x802580
  80139b:	6a 72                	push   $0x72
  80139d:	68 dd 24 80 00       	push   $0x8024dd
  8013a2:	e8 d3 ee ff ff       	call   80027a <_panic>

008013a7 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013ad:	83 ec 04             	sub    $0x4,%esp
  8013b0:	68 a6 25 80 00       	push   $0x8025a6
  8013b5:	6a 7e                	push   $0x7e
  8013b7:	68 dd 24 80 00       	push   $0x8024dd
  8013bc:	e8 b9 ee ff ff       	call   80027a <_panic>

008013c1 <shrink>:

}
void shrink(uint32 newSize)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013c7:	83 ec 04             	sub    $0x4,%esp
  8013ca:	68 a6 25 80 00       	push   $0x8025a6
  8013cf:	68 83 00 00 00       	push   $0x83
  8013d4:	68 dd 24 80 00       	push   $0x8024dd
  8013d9:	e8 9c ee ff ff       	call   80027a <_panic>

008013de <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013e4:	83 ec 04             	sub    $0x4,%esp
  8013e7:	68 a6 25 80 00       	push   $0x8025a6
  8013ec:	68 88 00 00 00       	push   $0x88
  8013f1:	68 dd 24 80 00       	push   $0x8024dd
  8013f6:	e8 7f ee ff ff       	call   80027a <_panic>

008013fb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	57                   	push   %edi
  8013ff:	56                   	push   %esi
  801400:	53                   	push   %ebx
  801401:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80140d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801410:	8b 7d 18             	mov    0x18(%ebp),%edi
  801413:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801416:	cd 30                	int    $0x30
  801418:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80141b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	5b                   	pop    %ebx
  801422:	5e                   	pop    %esi
  801423:	5f                   	pop    %edi
  801424:	5d                   	pop    %ebp
  801425:	c3                   	ret    

00801426 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	83 ec 04             	sub    $0x4,%esp
  80142c:	8b 45 10             	mov    0x10(%ebp),%eax
  80142f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801432:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	52                   	push   %edx
  80143e:	ff 75 0c             	pushl  0xc(%ebp)
  801441:	50                   	push   %eax
  801442:	6a 00                	push   $0x0
  801444:	e8 b2 ff ff ff       	call   8013fb <syscall>
  801449:	83 c4 18             	add    $0x18,%esp
}
  80144c:	90                   	nop
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_cgetc>:

int
sys_cgetc(void)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 02                	push   $0x2
  80145e:	e8 98 ff ff ff       	call   8013fb <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 03                	push   $0x3
  801477:	e8 7f ff ff ff       	call   8013fb <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	90                   	nop
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 04                	push   $0x4
  801491:	e8 65 ff ff ff       	call   8013fb <syscall>
  801496:	83 c4 18             	add    $0x18,%esp
}
  801499:	90                   	nop
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80149f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	52                   	push   %edx
  8014ac:	50                   	push   %eax
  8014ad:	6a 08                	push   $0x8
  8014af:	e8 47 ff ff ff       	call   8013fb <syscall>
  8014b4:	83 c4 18             	add    $0x18,%esp
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	56                   	push   %esi
  8014bd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014be:	8b 75 18             	mov    0x18(%ebp),%esi
  8014c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	56                   	push   %esi
  8014ce:	53                   	push   %ebx
  8014cf:	51                   	push   %ecx
  8014d0:	52                   	push   %edx
  8014d1:	50                   	push   %eax
  8014d2:	6a 09                	push   $0x9
  8014d4:	e8 22 ff ff ff       	call   8013fb <syscall>
  8014d9:	83 c4 18             	add    $0x18,%esp
}
  8014dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014df:	5b                   	pop    %ebx
  8014e0:	5e                   	pop    %esi
  8014e1:	5d                   	pop    %ebp
  8014e2:	c3                   	ret    

008014e3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	52                   	push   %edx
  8014f3:	50                   	push   %eax
  8014f4:	6a 0a                	push   $0xa
  8014f6:	e8 00 ff ff ff       	call   8013fb <syscall>
  8014fb:	83 c4 18             	add    $0x18,%esp
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	ff 75 0c             	pushl  0xc(%ebp)
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	6a 0b                	push   $0xb
  801511:	e8 e5 fe ff ff       	call   8013fb <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 0c                	push   $0xc
  80152a:	e8 cc fe ff ff       	call   8013fb <syscall>
  80152f:	83 c4 18             	add    $0x18,%esp
}
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 0d                	push   $0xd
  801543:	e8 b3 fe ff ff       	call   8013fb <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 0e                	push   $0xe
  80155c:	e8 9a fe ff ff       	call   8013fb <syscall>
  801561:	83 c4 18             	add    $0x18,%esp
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 0f                	push   $0xf
  801575:	e8 81 fe ff ff       	call   8013fb <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	ff 75 08             	pushl  0x8(%ebp)
  80158d:	6a 10                	push   $0x10
  80158f:	e8 67 fe ff ff       	call   8013fb <syscall>
  801594:	83 c4 18             	add    $0x18,%esp
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 11                	push   $0x11
  8015a8:	e8 4e fe ff ff       	call   8013fb <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
}
  8015b0:	90                   	nop
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 04             	sub    $0x4,%esp
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	50                   	push   %eax
  8015cc:	6a 01                	push   $0x1
  8015ce:	e8 28 fe ff ff       	call   8013fb <syscall>
  8015d3:	83 c4 18             	add    $0x18,%esp
}
  8015d6:	90                   	nop
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 14                	push   $0x14
  8015e8:	e8 0e fe ff ff       	call   8013fb <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
}
  8015f0:	90                   	nop
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 04             	sub    $0x4,%esp
  8015f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015ff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801602:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	6a 00                	push   $0x0
  80160b:	51                   	push   %ecx
  80160c:	52                   	push   %edx
  80160d:	ff 75 0c             	pushl  0xc(%ebp)
  801610:	50                   	push   %eax
  801611:	6a 15                	push   $0x15
  801613:	e8 e3 fd ff ff       	call   8013fb <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801620:	8b 55 0c             	mov    0xc(%ebp),%edx
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	52                   	push   %edx
  80162d:	50                   	push   %eax
  80162e:	6a 16                	push   $0x16
  801630:	e8 c6 fd ff ff       	call   8013fb <syscall>
  801635:	83 c4 18             	add    $0x18,%esp
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80163d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801640:	8b 55 0c             	mov    0xc(%ebp),%edx
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	51                   	push   %ecx
  80164b:	52                   	push   %edx
  80164c:	50                   	push   %eax
  80164d:	6a 17                	push   $0x17
  80164f:	e8 a7 fd ff ff       	call   8013fb <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80165c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	52                   	push   %edx
  801669:	50                   	push   %eax
  80166a:	6a 18                	push   $0x18
  80166c:	e8 8a fd ff ff       	call   8013fb <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	6a 00                	push   $0x0
  80167e:	ff 75 14             	pushl  0x14(%ebp)
  801681:	ff 75 10             	pushl  0x10(%ebp)
  801684:	ff 75 0c             	pushl  0xc(%ebp)
  801687:	50                   	push   %eax
  801688:	6a 19                	push   $0x19
  80168a:	e8 6c fd ff ff       	call   8013fb <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	50                   	push   %eax
  8016a3:	6a 1a                	push   $0x1a
  8016a5:	e8 51 fd ff ff       	call   8013fb <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
}
  8016ad:	90                   	nop
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	50                   	push   %eax
  8016bf:	6a 1b                	push   $0x1b
  8016c1:	e8 35 fd ff ff       	call   8013fb <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 05                	push   $0x5
  8016da:	e8 1c fd ff ff       	call   8013fb <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 06                	push   $0x6
  8016f3:	e8 03 fd ff ff       	call   8013fb <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 07                	push   $0x7
  80170c:	e8 ea fc ff ff       	call   8013fb <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sys_exit_env>:


void sys_exit_env(void)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 1c                	push   $0x1c
  801725:	e8 d1 fc ff ff       	call   8013fb <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	90                   	nop
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801736:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801739:	8d 50 04             	lea    0x4(%eax),%edx
  80173c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	52                   	push   %edx
  801746:	50                   	push   %eax
  801747:	6a 1d                	push   $0x1d
  801749:	e8 ad fc ff ff       	call   8013fb <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
	return result;
  801751:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801754:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801757:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80175a:	89 01                	mov    %eax,(%ecx)
  80175c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	c9                   	leave  
  801763:	c2 04 00             	ret    $0x4

00801766 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	ff 75 10             	pushl  0x10(%ebp)
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	ff 75 08             	pushl  0x8(%ebp)
  801776:	6a 13                	push   $0x13
  801778:	e8 7e fc ff ff       	call   8013fb <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
	return ;
  801780:	90                   	nop
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_rcr2>:
uint32 sys_rcr2()
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 1e                	push   $0x1e
  801792:	e8 64 fc ff ff       	call   8013fb <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 04             	sub    $0x4,%esp
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017a8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	50                   	push   %eax
  8017b5:	6a 1f                	push   $0x1f
  8017b7:	e8 3f fc ff ff       	call   8013fb <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bf:	90                   	nop
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <rsttst>:
void rsttst()
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 21                	push   $0x21
  8017d1:	e8 25 fc ff ff       	call   8013fb <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d9:	90                   	nop
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 04             	sub    $0x4,%esp
  8017e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017e8:	8b 55 18             	mov    0x18(%ebp),%edx
  8017eb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017ef:	52                   	push   %edx
  8017f0:	50                   	push   %eax
  8017f1:	ff 75 10             	pushl  0x10(%ebp)
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	ff 75 08             	pushl  0x8(%ebp)
  8017fa:	6a 20                	push   $0x20
  8017fc:	e8 fa fb ff ff       	call   8013fb <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
	return ;
  801804:	90                   	nop
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <chktst>:
void chktst(uint32 n)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	ff 75 08             	pushl  0x8(%ebp)
  801815:	6a 22                	push   $0x22
  801817:	e8 df fb ff ff       	call   8013fb <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
	return ;
  80181f:	90                   	nop
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <inctst>:

void inctst()
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 23                	push   $0x23
  801831:	e8 c5 fb ff ff       	call   8013fb <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
	return ;
  801839:	90                   	nop
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <gettst>:
uint32 gettst()
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 24                	push   $0x24
  80184b:	e8 ab fb ff ff       	call   8013fb <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 25                	push   $0x25
  801867:	e8 8f fb ff ff       	call   8013fb <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
  80186f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801872:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801876:	75 07                	jne    80187f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801878:	b8 01 00 00 00       	mov    $0x1,%eax
  80187d:	eb 05                	jmp    801884 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80187f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 25                	push   $0x25
  801898:	e8 5e fb ff ff       	call   8013fb <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
  8018a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018a3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018a7:	75 07                	jne    8018b0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ae:	eb 05                	jmp    8018b5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8018b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 25                	push   $0x25
  8018c9:	e8 2d fb ff ff       	call   8013fb <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
  8018d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8018d4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8018d8:	75 07                	jne    8018e1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8018da:	b8 01 00 00 00       	mov    $0x1,%eax
  8018df:	eb 05                	jmp    8018e6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8018e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 25                	push   $0x25
  8018fa:	e8 fc fa ff ff       	call   8013fb <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
  801902:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801905:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801909:	75 07                	jne    801912 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80190b:	b8 01 00 00 00       	mov    $0x1,%eax
  801910:	eb 05                	jmp    801917 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801912:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	6a 26                	push   $0x26
  801929:	e8 cd fa ff ff       	call   8013fb <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
	return ;
  801931:	90                   	nop
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801938:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80193b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	6a 00                	push   $0x0
  801946:	53                   	push   %ebx
  801947:	51                   	push   %ecx
  801948:	52                   	push   %edx
  801949:	50                   	push   %eax
  80194a:	6a 27                	push   $0x27
  80194c:	e8 aa fa ff ff       	call   8013fb <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80195c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	52                   	push   %edx
  801969:	50                   	push   %eax
  80196a:	6a 28                	push   $0x28
  80196c:	e8 8a fa ff ff       	call   8013fb <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801979:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80197c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	6a 00                	push   $0x0
  801984:	51                   	push   %ecx
  801985:	ff 75 10             	pushl  0x10(%ebp)
  801988:	52                   	push   %edx
  801989:	50                   	push   %eax
  80198a:	6a 29                	push   $0x29
  80198c:	e8 6a fa ff ff       	call   8013fb <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	ff 75 10             	pushl  0x10(%ebp)
  8019a0:	ff 75 0c             	pushl  0xc(%ebp)
  8019a3:	ff 75 08             	pushl  0x8(%ebp)
  8019a6:	6a 12                	push   $0x12
  8019a8:	e8 4e fa ff ff       	call   8013fb <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b0:	90                   	nop
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	52                   	push   %edx
  8019c3:	50                   	push   %eax
  8019c4:	6a 2a                	push   $0x2a
  8019c6:	e8 30 fa ff ff       	call   8013fb <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
	return;
  8019ce:	90                   	nop
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	50                   	push   %eax
  8019e0:	6a 2b                	push   $0x2b
  8019e2:	e8 14 fa ff ff       	call   8013fb <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	6a 2c                	push   $0x2c
  8019fd:	e8 f9 f9 ff ff       	call   8013fb <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
	return;
  801a05:	90                   	nop
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	ff 75 0c             	pushl  0xc(%ebp)
  801a14:	ff 75 08             	pushl  0x8(%ebp)
  801a17:	6a 2d                	push   $0x2d
  801a19:	e8 dd f9 ff ff       	call   8013fb <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
	return;
  801a21:	90                   	nop
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801a2a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a2d:	89 d0                	mov    %edx,%eax
  801a2f:	c1 e0 02             	shl    $0x2,%eax
  801a32:	01 d0                	add    %edx,%eax
  801a34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a3b:	01 d0                	add    %edx,%eax
  801a3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a44:	01 d0                	add    %edx,%eax
  801a46:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a4d:	01 d0                	add    %edx,%eax
  801a4f:	c1 e0 04             	shl    $0x4,%eax
  801a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801a55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801a5c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801a5f:	83 ec 0c             	sub    $0xc,%esp
  801a62:	50                   	push   %eax
  801a63:	e8 c8 fc ff ff       	call   801730 <sys_get_virtual_time>
  801a68:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801a6b:	eb 41                	jmp    801aae <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801a6d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a70:	83 ec 0c             	sub    $0xc,%esp
  801a73:	50                   	push   %eax
  801a74:	e8 b7 fc ff ff       	call   801730 <sys_get_virtual_time>
  801a79:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a7c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a82:	29 c2                	sub    %eax,%edx
  801a84:	89 d0                	mov    %edx,%eax
  801a86:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a8f:	89 d1                	mov    %edx,%ecx
  801a91:	29 c1                	sub    %eax,%ecx
  801a93:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a99:	39 c2                	cmp    %eax,%edx
  801a9b:	0f 97 c0             	seta   %al
  801a9e:	0f b6 c0             	movzbl %al,%eax
  801aa1:	29 c1                	sub    %eax,%ecx
  801aa3:	89 c8                	mov    %ecx,%eax
  801aa5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801aa8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ab4:	72 b7                	jb     801a6d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801ab6:	90                   	nop
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801abf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801ac6:	eb 03                	jmp    801acb <busy_wait+0x12>
  801ac8:	ff 45 fc             	incl   -0x4(%ebp)
  801acb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ace:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ad1:	72 f5                	jb     801ac8 <busy_wait+0xf>
	return i;
  801ad3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <__udivdi3>:
  801ad8:	55                   	push   %ebp
  801ad9:	57                   	push   %edi
  801ada:	56                   	push   %esi
  801adb:	53                   	push   %ebx
  801adc:	83 ec 1c             	sub    $0x1c,%esp
  801adf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ae3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ae7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aeb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aef:	89 ca                	mov    %ecx,%edx
  801af1:	89 f8                	mov    %edi,%eax
  801af3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801af7:	85 f6                	test   %esi,%esi
  801af9:	75 2d                	jne    801b28 <__udivdi3+0x50>
  801afb:	39 cf                	cmp    %ecx,%edi
  801afd:	77 65                	ja     801b64 <__udivdi3+0x8c>
  801aff:	89 fd                	mov    %edi,%ebp
  801b01:	85 ff                	test   %edi,%edi
  801b03:	75 0b                	jne    801b10 <__udivdi3+0x38>
  801b05:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0a:	31 d2                	xor    %edx,%edx
  801b0c:	f7 f7                	div    %edi
  801b0e:	89 c5                	mov    %eax,%ebp
  801b10:	31 d2                	xor    %edx,%edx
  801b12:	89 c8                	mov    %ecx,%eax
  801b14:	f7 f5                	div    %ebp
  801b16:	89 c1                	mov    %eax,%ecx
  801b18:	89 d8                	mov    %ebx,%eax
  801b1a:	f7 f5                	div    %ebp
  801b1c:	89 cf                	mov    %ecx,%edi
  801b1e:	89 fa                	mov    %edi,%edx
  801b20:	83 c4 1c             	add    $0x1c,%esp
  801b23:	5b                   	pop    %ebx
  801b24:	5e                   	pop    %esi
  801b25:	5f                   	pop    %edi
  801b26:	5d                   	pop    %ebp
  801b27:	c3                   	ret    
  801b28:	39 ce                	cmp    %ecx,%esi
  801b2a:	77 28                	ja     801b54 <__udivdi3+0x7c>
  801b2c:	0f bd fe             	bsr    %esi,%edi
  801b2f:	83 f7 1f             	xor    $0x1f,%edi
  801b32:	75 40                	jne    801b74 <__udivdi3+0x9c>
  801b34:	39 ce                	cmp    %ecx,%esi
  801b36:	72 0a                	jb     801b42 <__udivdi3+0x6a>
  801b38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b3c:	0f 87 9e 00 00 00    	ja     801be0 <__udivdi3+0x108>
  801b42:	b8 01 00 00 00       	mov    $0x1,%eax
  801b47:	89 fa                	mov    %edi,%edx
  801b49:	83 c4 1c             	add    $0x1c,%esp
  801b4c:	5b                   	pop    %ebx
  801b4d:	5e                   	pop    %esi
  801b4e:	5f                   	pop    %edi
  801b4f:	5d                   	pop    %ebp
  801b50:	c3                   	ret    
  801b51:	8d 76 00             	lea    0x0(%esi),%esi
  801b54:	31 ff                	xor    %edi,%edi
  801b56:	31 c0                	xor    %eax,%eax
  801b58:	89 fa                	mov    %edi,%edx
  801b5a:	83 c4 1c             	add    $0x1c,%esp
  801b5d:	5b                   	pop    %ebx
  801b5e:	5e                   	pop    %esi
  801b5f:	5f                   	pop    %edi
  801b60:	5d                   	pop    %ebp
  801b61:	c3                   	ret    
  801b62:	66 90                	xchg   %ax,%ax
  801b64:	89 d8                	mov    %ebx,%eax
  801b66:	f7 f7                	div    %edi
  801b68:	31 ff                	xor    %edi,%edi
  801b6a:	89 fa                	mov    %edi,%edx
  801b6c:	83 c4 1c             	add    $0x1c,%esp
  801b6f:	5b                   	pop    %ebx
  801b70:	5e                   	pop    %esi
  801b71:	5f                   	pop    %edi
  801b72:	5d                   	pop    %ebp
  801b73:	c3                   	ret    
  801b74:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b79:	89 eb                	mov    %ebp,%ebx
  801b7b:	29 fb                	sub    %edi,%ebx
  801b7d:	89 f9                	mov    %edi,%ecx
  801b7f:	d3 e6                	shl    %cl,%esi
  801b81:	89 c5                	mov    %eax,%ebp
  801b83:	88 d9                	mov    %bl,%cl
  801b85:	d3 ed                	shr    %cl,%ebp
  801b87:	89 e9                	mov    %ebp,%ecx
  801b89:	09 f1                	or     %esi,%ecx
  801b8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b8f:	89 f9                	mov    %edi,%ecx
  801b91:	d3 e0                	shl    %cl,%eax
  801b93:	89 c5                	mov    %eax,%ebp
  801b95:	89 d6                	mov    %edx,%esi
  801b97:	88 d9                	mov    %bl,%cl
  801b99:	d3 ee                	shr    %cl,%esi
  801b9b:	89 f9                	mov    %edi,%ecx
  801b9d:	d3 e2                	shl    %cl,%edx
  801b9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba3:	88 d9                	mov    %bl,%cl
  801ba5:	d3 e8                	shr    %cl,%eax
  801ba7:	09 c2                	or     %eax,%edx
  801ba9:	89 d0                	mov    %edx,%eax
  801bab:	89 f2                	mov    %esi,%edx
  801bad:	f7 74 24 0c          	divl   0xc(%esp)
  801bb1:	89 d6                	mov    %edx,%esi
  801bb3:	89 c3                	mov    %eax,%ebx
  801bb5:	f7 e5                	mul    %ebp
  801bb7:	39 d6                	cmp    %edx,%esi
  801bb9:	72 19                	jb     801bd4 <__udivdi3+0xfc>
  801bbb:	74 0b                	je     801bc8 <__udivdi3+0xf0>
  801bbd:	89 d8                	mov    %ebx,%eax
  801bbf:	31 ff                	xor    %edi,%edi
  801bc1:	e9 58 ff ff ff       	jmp    801b1e <__udivdi3+0x46>
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bcc:	89 f9                	mov    %edi,%ecx
  801bce:	d3 e2                	shl    %cl,%edx
  801bd0:	39 c2                	cmp    %eax,%edx
  801bd2:	73 e9                	jae    801bbd <__udivdi3+0xe5>
  801bd4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bd7:	31 ff                	xor    %edi,%edi
  801bd9:	e9 40 ff ff ff       	jmp    801b1e <__udivdi3+0x46>
  801bde:	66 90                	xchg   %ax,%ax
  801be0:	31 c0                	xor    %eax,%eax
  801be2:	e9 37 ff ff ff       	jmp    801b1e <__udivdi3+0x46>
  801be7:	90                   	nop

00801be8 <__umoddi3>:
  801be8:	55                   	push   %ebp
  801be9:	57                   	push   %edi
  801bea:	56                   	push   %esi
  801beb:	53                   	push   %ebx
  801bec:	83 ec 1c             	sub    $0x1c,%esp
  801bef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bf3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bf7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bfb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c07:	89 f3                	mov    %esi,%ebx
  801c09:	89 fa                	mov    %edi,%edx
  801c0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c0f:	89 34 24             	mov    %esi,(%esp)
  801c12:	85 c0                	test   %eax,%eax
  801c14:	75 1a                	jne    801c30 <__umoddi3+0x48>
  801c16:	39 f7                	cmp    %esi,%edi
  801c18:	0f 86 a2 00 00 00    	jbe    801cc0 <__umoddi3+0xd8>
  801c1e:	89 c8                	mov    %ecx,%eax
  801c20:	89 f2                	mov    %esi,%edx
  801c22:	f7 f7                	div    %edi
  801c24:	89 d0                	mov    %edx,%eax
  801c26:	31 d2                	xor    %edx,%edx
  801c28:	83 c4 1c             	add    $0x1c,%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5f                   	pop    %edi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    
  801c30:	39 f0                	cmp    %esi,%eax
  801c32:	0f 87 ac 00 00 00    	ja     801ce4 <__umoddi3+0xfc>
  801c38:	0f bd e8             	bsr    %eax,%ebp
  801c3b:	83 f5 1f             	xor    $0x1f,%ebp
  801c3e:	0f 84 ac 00 00 00    	je     801cf0 <__umoddi3+0x108>
  801c44:	bf 20 00 00 00       	mov    $0x20,%edi
  801c49:	29 ef                	sub    %ebp,%edi
  801c4b:	89 fe                	mov    %edi,%esi
  801c4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c51:	89 e9                	mov    %ebp,%ecx
  801c53:	d3 e0                	shl    %cl,%eax
  801c55:	89 d7                	mov    %edx,%edi
  801c57:	89 f1                	mov    %esi,%ecx
  801c59:	d3 ef                	shr    %cl,%edi
  801c5b:	09 c7                	or     %eax,%edi
  801c5d:	89 e9                	mov    %ebp,%ecx
  801c5f:	d3 e2                	shl    %cl,%edx
  801c61:	89 14 24             	mov    %edx,(%esp)
  801c64:	89 d8                	mov    %ebx,%eax
  801c66:	d3 e0                	shl    %cl,%eax
  801c68:	89 c2                	mov    %eax,%edx
  801c6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c6e:	d3 e0                	shl    %cl,%eax
  801c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c74:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c78:	89 f1                	mov    %esi,%ecx
  801c7a:	d3 e8                	shr    %cl,%eax
  801c7c:	09 d0                	or     %edx,%eax
  801c7e:	d3 eb                	shr    %cl,%ebx
  801c80:	89 da                	mov    %ebx,%edx
  801c82:	f7 f7                	div    %edi
  801c84:	89 d3                	mov    %edx,%ebx
  801c86:	f7 24 24             	mull   (%esp)
  801c89:	89 c6                	mov    %eax,%esi
  801c8b:	89 d1                	mov    %edx,%ecx
  801c8d:	39 d3                	cmp    %edx,%ebx
  801c8f:	0f 82 87 00 00 00    	jb     801d1c <__umoddi3+0x134>
  801c95:	0f 84 91 00 00 00    	je     801d2c <__umoddi3+0x144>
  801c9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c9f:	29 f2                	sub    %esi,%edx
  801ca1:	19 cb                	sbb    %ecx,%ebx
  801ca3:	89 d8                	mov    %ebx,%eax
  801ca5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ca9:	d3 e0                	shl    %cl,%eax
  801cab:	89 e9                	mov    %ebp,%ecx
  801cad:	d3 ea                	shr    %cl,%edx
  801caf:	09 d0                	or     %edx,%eax
  801cb1:	89 e9                	mov    %ebp,%ecx
  801cb3:	d3 eb                	shr    %cl,%ebx
  801cb5:	89 da                	mov    %ebx,%edx
  801cb7:	83 c4 1c             	add    $0x1c,%esp
  801cba:	5b                   	pop    %ebx
  801cbb:	5e                   	pop    %esi
  801cbc:	5f                   	pop    %edi
  801cbd:	5d                   	pop    %ebp
  801cbe:	c3                   	ret    
  801cbf:	90                   	nop
  801cc0:	89 fd                	mov    %edi,%ebp
  801cc2:	85 ff                	test   %edi,%edi
  801cc4:	75 0b                	jne    801cd1 <__umoddi3+0xe9>
  801cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccb:	31 d2                	xor    %edx,%edx
  801ccd:	f7 f7                	div    %edi
  801ccf:	89 c5                	mov    %eax,%ebp
  801cd1:	89 f0                	mov    %esi,%eax
  801cd3:	31 d2                	xor    %edx,%edx
  801cd5:	f7 f5                	div    %ebp
  801cd7:	89 c8                	mov    %ecx,%eax
  801cd9:	f7 f5                	div    %ebp
  801cdb:	89 d0                	mov    %edx,%eax
  801cdd:	e9 44 ff ff ff       	jmp    801c26 <__umoddi3+0x3e>
  801ce2:	66 90                	xchg   %ax,%ax
  801ce4:	89 c8                	mov    %ecx,%eax
  801ce6:	89 f2                	mov    %esi,%edx
  801ce8:	83 c4 1c             	add    $0x1c,%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5e                   	pop    %esi
  801ced:	5f                   	pop    %edi
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    
  801cf0:	3b 04 24             	cmp    (%esp),%eax
  801cf3:	72 06                	jb     801cfb <__umoddi3+0x113>
  801cf5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cf9:	77 0f                	ja     801d0a <__umoddi3+0x122>
  801cfb:	89 f2                	mov    %esi,%edx
  801cfd:	29 f9                	sub    %edi,%ecx
  801cff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d03:	89 14 24             	mov    %edx,(%esp)
  801d06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d0e:	8b 14 24             	mov    (%esp),%edx
  801d11:	83 c4 1c             	add    $0x1c,%esp
  801d14:	5b                   	pop    %ebx
  801d15:	5e                   	pop    %esi
  801d16:	5f                   	pop    %edi
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    
  801d19:	8d 76 00             	lea    0x0(%esi),%esi
  801d1c:	2b 04 24             	sub    (%esp),%eax
  801d1f:	19 fa                	sbb    %edi,%edx
  801d21:	89 d1                	mov    %edx,%ecx
  801d23:	89 c6                	mov    %eax,%esi
  801d25:	e9 71 ff ff ff       	jmp    801c9b <__umoddi3+0xb3>
  801d2a:	66 90                	xchg   %ax,%ax
  801d2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d30:	72 ea                	jb     801d1c <__umoddi3+0x134>
  801d32:	89 d9                	mov    %ebx,%ecx
  801d34:	e9 62 ff ff ff       	jmp    801c9b <__umoddi3+0xb3>
