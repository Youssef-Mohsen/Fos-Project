
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 11 01 00 00       	call   800147 <libmain>
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
  80003e:	a1 20 50 80 00       	mov    0x805020,%eax
  800043:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800049:	a1 20 50 80 00       	mov    0x805020,%eax
  80004e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 e0 3c 80 00       	push   $0x803ce0
  800060:	6a 0c                	push   $0xc
  800062:	68 fc 3c 80 00       	push   $0x803cfc
  800067:	e8 1a 02 00 00       	call   800286 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	x = sget(sys_getparentenvid(),"x");
  800073:	e8 87 1b 00 00       	call   801bff <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 19 3d 80 00       	push   $0x803d19
  800080:	50                   	push   %eax
  800081:	e8 95 16 00 00       	call   80171b <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 1c 3d 80 00       	push   $0x803d1c
  800094:	e8 aa 04 00 00       	call   800543 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  80009c:	e8 83 1c 00 00       	call   801d24 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 44 3d 80 00       	push   $0x803d44
  8000a9:	e8 95 04 00 00       	call   800543 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 70 17 00 00       	push   $0x1770
  8000b9:	e8 01 39 00 00       	call   8039bf <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=2) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 77 1c 00 00       	call   801d3e <gettst>
  8000c7:	83 f8 02             	cmp    $0x2,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 4c 19 00 00       	call   801a1d <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 4f 17 00 00       	call   80182e <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 64 3d 80 00       	push   $0x803d64
  8000ea:	e8 54 04 00 00       	call   800543 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	cprintf("diff 2 : %d\n",sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 1f 19 00 00       	call   801a1d <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	50                   	push   %eax
  80010b:	68 7c 3d 80 00       	push   $0x803d7c
  800110:	e8 2e 04 00 00       	call   800543 <cprintf>
  800115:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800118:	e8 00 19 00 00       	call   801a1d <sys_calculate_free_frames>
  80011d:	89 c2                	mov    %eax,%edx
  80011f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800122:	29 c2                	sub    %eax,%edx
  800124:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800127:	39 c2                	cmp    %eax,%edx
  800129:	74 14                	je     80013f <_main+0x107>
  80012b:	83 ec 04             	sub    $0x4,%esp
  80012e:	68 8c 3d 80 00       	push   $0x803d8c
  800133:	6a 27                	push   $0x27
  800135:	68 fc 3c 80 00       	push   $0x803cfc
  80013a:	e8 47 01 00 00       	call   800286 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80013f:	e8 e0 1b 00 00       	call   801d24 <inctst>
	return;
  800144:	90                   	nop
}
  800145:	c9                   	leave  
  800146:	c3                   	ret    

00800147 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014d:	e8 94 1a 00 00       	call   801be6 <sys_getenvindex>
  800152:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800155:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800158:	89 d0                	mov    %edx,%eax
  80015a:	c1 e0 03             	shl    $0x3,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800166:	01 c8                	add    %ecx,%eax
  800168:	01 c0                	add    %eax,%eax
  80016a:	01 d0                	add    %edx,%eax
  80016c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800173:	01 c8                	add    %ecx,%eax
  800175:	01 d0                	add    %edx,%eax
  800177:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80017c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800181:	a1 20 50 80 00       	mov    0x805020,%eax
  800186:	8a 40 20             	mov    0x20(%eax),%al
  800189:	84 c0                	test   %al,%al
  80018b:	74 0d                	je     80019a <libmain+0x53>
		binaryname = myEnv->prog_name;
  80018d:	a1 20 50 80 00       	mov    0x805020,%eax
  800192:	83 c0 20             	add    $0x20,%eax
  800195:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019e:	7e 0a                	jle    8001aa <libmain+0x63>
		binaryname = argv[0];
  8001a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a3:	8b 00                	mov    (%eax),%eax
  8001a5:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	ff 75 0c             	pushl  0xc(%ebp)
  8001b0:	ff 75 08             	pushl  0x8(%ebp)
  8001b3:	e8 80 fe ff ff       	call   800038 <_main>
  8001b8:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001bb:	e8 aa 17 00 00       	call   80196a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	68 4c 3e 80 00       	push   $0x803e4c
  8001c8:	e8 76 03 00 00       	call   800543 <cprintf>
  8001cd:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001db:	a1 20 50 80 00       	mov    0x805020,%eax
  8001e0:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	52                   	push   %edx
  8001ea:	50                   	push   %eax
  8001eb:	68 74 3e 80 00       	push   $0x803e74
  8001f0:	e8 4e 03 00 00       	call   800543 <cprintf>
  8001f5:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001fd:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800203:	a1 20 50 80 00       	mov    0x805020,%eax
  800208:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80020e:	a1 20 50 80 00       	mov    0x805020,%eax
  800213:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800219:	51                   	push   %ecx
  80021a:	52                   	push   %edx
  80021b:	50                   	push   %eax
  80021c:	68 9c 3e 80 00       	push   $0x803e9c
  800221:	e8 1d 03 00 00       	call   800543 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800229:	a1 20 50 80 00       	mov    0x805020,%eax
  80022e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	50                   	push   %eax
  800238:	68 f4 3e 80 00       	push   $0x803ef4
  80023d:	e8 01 03 00 00       	call   800543 <cprintf>
  800242:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	68 4c 3e 80 00       	push   $0x803e4c
  80024d:	e8 f1 02 00 00       	call   800543 <cprintf>
  800252:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800255:	e8 2a 17 00 00       	call   801984 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80025a:	e8 19 00 00 00       	call   800278 <exit>
}
  80025f:	90                   	nop
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	6a 00                	push   $0x0
  80026d:	e8 40 19 00 00       	call   801bb2 <sys_destroy_env>
  800272:	83 c4 10             	add    $0x10,%esp
}
  800275:	90                   	nop
  800276:	c9                   	leave  
  800277:	c3                   	ret    

00800278 <exit>:

void
exit(void)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027e:	e8 95 19 00 00       	call   801c18 <sys_exit_env>
}
  800283:	90                   	nop
  800284:	c9                   	leave  
  800285:	c3                   	ret    

00800286 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80028c:	8d 45 10             	lea    0x10(%ebp),%eax
  80028f:	83 c0 04             	add    $0x4,%eax
  800292:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800295:	a1 50 50 80 00       	mov    0x805050,%eax
  80029a:	85 c0                	test   %eax,%eax
  80029c:	74 16                	je     8002b4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029e:	a1 50 50 80 00       	mov    0x805050,%eax
  8002a3:	83 ec 08             	sub    $0x8,%esp
  8002a6:	50                   	push   %eax
  8002a7:	68 08 3f 80 00       	push   $0x803f08
  8002ac:	e8 92 02 00 00       	call   800543 <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b4:	a1 00 50 80 00       	mov    0x805000,%eax
  8002b9:	ff 75 0c             	pushl  0xc(%ebp)
  8002bc:	ff 75 08             	pushl  0x8(%ebp)
  8002bf:	50                   	push   %eax
  8002c0:	68 0d 3f 80 00       	push   $0x803f0d
  8002c5:	e8 79 02 00 00       	call   800543 <cprintf>
  8002ca:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d6:	50                   	push   %eax
  8002d7:	e8 fc 01 00 00       	call   8004d8 <vcprintf>
  8002dc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	6a 00                	push   $0x0
  8002e4:	68 29 3f 80 00       	push   $0x803f29
  8002e9:	e8 ea 01 00 00       	call   8004d8 <vcprintf>
  8002ee:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002f1:	e8 82 ff ff ff       	call   800278 <exit>

	// should not return here
	while (1) ;
  8002f6:	eb fe                	jmp    8002f6 <_panic+0x70>

008002f8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800303:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800309:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030c:	39 c2                	cmp    %eax,%edx
  80030e:	74 14                	je     800324 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 2c 3f 80 00       	push   $0x803f2c
  800318:	6a 26                	push   $0x26
  80031a:	68 78 3f 80 00       	push   $0x803f78
  80031f:	e8 62 ff ff ff       	call   800286 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800324:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80032b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800332:	e9 c5 00 00 00       	jmp    8003fc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800341:	8b 45 08             	mov    0x8(%ebp),%eax
  800344:	01 d0                	add    %edx,%eax
  800346:	8b 00                	mov    (%eax),%eax
  800348:	85 c0                	test   %eax,%eax
  80034a:	75 08                	jne    800354 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80034c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80034f:	e9 a5 00 00 00       	jmp    8003f9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800354:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800362:	eb 69                	jmp    8003cd <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800364:	a1 20 50 80 00       	mov    0x805020,%eax
  800369:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80036f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800372:	89 d0                	mov    %edx,%eax
  800374:	01 c0                	add    %eax,%eax
  800376:	01 d0                	add    %edx,%eax
  800378:	c1 e0 03             	shl    $0x3,%eax
  80037b:	01 c8                	add    %ecx,%eax
  80037d:	8a 40 04             	mov    0x4(%eax),%al
  800380:	84 c0                	test   %al,%al
  800382:	75 46                	jne    8003ca <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800384:	a1 20 50 80 00       	mov    0x805020,%eax
  800389:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80038f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800392:	89 d0                	mov    %edx,%eax
  800394:	01 c0                	add    %eax,%eax
  800396:	01 d0                	add    %edx,%eax
  800398:	c1 e0 03             	shl    $0x3,%eax
  80039b:	01 c8                	add    %ecx,%eax
  80039d:	8b 00                	mov    (%eax),%eax
  80039f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003aa:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003af:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	01 c8                	add    %ecx,%eax
  8003bb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003bd:	39 c2                	cmp    %eax,%edx
  8003bf:	75 09                	jne    8003ca <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003c1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c8:	eb 15                	jmp    8003df <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ca:	ff 45 e8             	incl   -0x18(%ebp)
  8003cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003db:	39 c2                	cmp    %eax,%edx
  8003dd:	77 85                	ja     800364 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e3:	75 14                	jne    8003f9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	68 84 3f 80 00       	push   $0x803f84
  8003ed:	6a 3a                	push   $0x3a
  8003ef:	68 78 3f 80 00       	push   $0x803f78
  8003f4:	e8 8d fe ff ff       	call   800286 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003f9:	ff 45 f0             	incl   -0x10(%ebp)
  8003fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800402:	0f 8c 2f ff ff ff    	jl     800337 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800408:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800416:	eb 26                	jmp    80043e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800418:	a1 20 50 80 00       	mov    0x805020,%eax
  80041d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800423:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800426:	89 d0                	mov    %edx,%eax
  800428:	01 c0                	add    %eax,%eax
  80042a:	01 d0                	add    %edx,%eax
  80042c:	c1 e0 03             	shl    $0x3,%eax
  80042f:	01 c8                	add    %ecx,%eax
  800431:	8a 40 04             	mov    0x4(%eax),%al
  800434:	3c 01                	cmp    $0x1,%al
  800436:	75 03                	jne    80043b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800438:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043b:	ff 45 e0             	incl   -0x20(%ebp)
  80043e:	a1 20 50 80 00       	mov    0x805020,%eax
  800443:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800449:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044c:	39 c2                	cmp    %eax,%edx
  80044e:	77 c8                	ja     800418 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800453:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800456:	74 14                	je     80046c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	68 d8 3f 80 00       	push   $0x803fd8
  800460:	6a 44                	push   $0x44
  800462:	68 78 3f 80 00       	push   $0x803f78
  800467:	e8 1a fe ff ff       	call   800286 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80046c:	90                   	nop
  80046d:	c9                   	leave  
  80046e:	c3                   	ret    

0080046f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800475:	8b 45 0c             	mov    0xc(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	8d 48 01             	lea    0x1(%eax),%ecx
  80047d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800480:	89 0a                	mov    %ecx,(%edx)
  800482:	8b 55 08             	mov    0x8(%ebp),%edx
  800485:	88 d1                	mov    %dl,%cl
  800487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80048e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	3d ff 00 00 00       	cmp    $0xff,%eax
  800498:	75 2c                	jne    8004c6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80049a:	a0 2c 50 80 00       	mov    0x80502c,%al
  80049f:	0f b6 c0             	movzbl %al,%eax
  8004a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a5:	8b 12                	mov    (%edx),%edx
  8004a7:	89 d1                	mov    %edx,%ecx
  8004a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ac:	83 c2 08             	add    $0x8,%edx
  8004af:	83 ec 04             	sub    $0x4,%esp
  8004b2:	50                   	push   %eax
  8004b3:	51                   	push   %ecx
  8004b4:	52                   	push   %edx
  8004b5:	e8 6e 14 00 00       	call   801928 <sys_cputs>
  8004ba:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c9:	8b 40 04             	mov    0x4(%eax),%eax
  8004cc:	8d 50 01             	lea    0x1(%eax),%edx
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d5:	90                   	nop
  8004d6:	c9                   	leave  
  8004d7:	c3                   	ret    

008004d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e8:	00 00 00 
	b.cnt = 0;
  8004eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f5:	ff 75 0c             	pushl  0xc(%ebp)
  8004f8:	ff 75 08             	pushl  0x8(%ebp)
  8004fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800501:	50                   	push   %eax
  800502:	68 6f 04 80 00       	push   $0x80046f
  800507:	e8 11 02 00 00       	call   80071d <vprintfmt>
  80050c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80050f:	a0 2c 50 80 00       	mov    0x80502c,%al
  800514:	0f b6 c0             	movzbl %al,%eax
  800517:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051d:	83 ec 04             	sub    $0x4,%esp
  800520:	50                   	push   %eax
  800521:	52                   	push   %edx
  800522:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800528:	83 c0 08             	add    $0x8,%eax
  80052b:	50                   	push   %eax
  80052c:	e8 f7 13 00 00       	call   801928 <sys_cputs>
  800531:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800534:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
	return b.cnt;
  80053b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800541:	c9                   	leave  
  800542:	c3                   	ret    

00800543 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800543:	55                   	push   %ebp
  800544:	89 e5                	mov    %esp,%ebp
  800546:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800549:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
	va_start(ap, fmt);
  800550:	8d 45 0c             	lea    0xc(%ebp),%eax
  800553:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	ff 75 f4             	pushl  -0xc(%ebp)
  80055f:	50                   	push   %eax
  800560:	e8 73 ff ff ff       	call   8004d8 <vcprintf>
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80056b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800576:	e8 ef 13 00 00       	call   80196a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80057b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800581:	8b 45 08             	mov    0x8(%ebp),%eax
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	ff 75 f4             	pushl  -0xc(%ebp)
  80058a:	50                   	push   %eax
  80058b:	e8 48 ff ff ff       	call   8004d8 <vcprintf>
  800590:	83 c4 10             	add    $0x10,%esp
  800593:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800596:	e8 e9 13 00 00       	call   801984 <sys_unlock_cons>
	return cnt;
  80059b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059e:	c9                   	leave  
  80059f:	c3                   	ret    

008005a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	53                   	push   %ebx
  8005a4:	83 ec 14             	sub    $0x14,%esp
  8005a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005be:	77 55                	ja     800615 <printnum+0x75>
  8005c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c3:	72 05                	jb     8005ca <printnum+0x2a>
  8005c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c8:	77 4b                	ja     800615 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ca:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005cd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d8:	52                   	push   %edx
  8005d9:	50                   	push   %eax
  8005da:	ff 75 f4             	pushl  -0xc(%ebp)
  8005dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e0:	e8 8f 34 00 00       	call   803a74 <__udivdi3>
  8005e5:	83 c4 10             	add    $0x10,%esp
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	ff 75 20             	pushl  0x20(%ebp)
  8005ee:	53                   	push   %ebx
  8005ef:	ff 75 18             	pushl  0x18(%ebp)
  8005f2:	52                   	push   %edx
  8005f3:	50                   	push   %eax
  8005f4:	ff 75 0c             	pushl  0xc(%ebp)
  8005f7:	ff 75 08             	pushl  0x8(%ebp)
  8005fa:	e8 a1 ff ff ff       	call   8005a0 <printnum>
  8005ff:	83 c4 20             	add    $0x20,%esp
  800602:	eb 1a                	jmp    80061e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800604:	83 ec 08             	sub    $0x8,%esp
  800607:	ff 75 0c             	pushl  0xc(%ebp)
  80060a:	ff 75 20             	pushl  0x20(%ebp)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	ff d0                	call   *%eax
  800612:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800615:	ff 4d 1c             	decl   0x1c(%ebp)
  800618:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80061c:	7f e6                	jg     800604 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800621:	bb 00 00 00 00       	mov    $0x0,%ebx
  800626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800629:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062c:	53                   	push   %ebx
  80062d:	51                   	push   %ecx
  80062e:	52                   	push   %edx
  80062f:	50                   	push   %eax
  800630:	e8 4f 35 00 00       	call   803b84 <__umoddi3>
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	05 54 42 80 00       	add    $0x804254,%eax
  80063d:	8a 00                	mov    (%eax),%al
  80063f:	0f be c0             	movsbl %al,%eax
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	50                   	push   %eax
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	ff d0                	call   *%eax
  80064e:	83 c4 10             	add    $0x10,%esp
}
  800651:	90                   	nop
  800652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800655:	c9                   	leave  
  800656:	c3                   	ret    

00800657 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80065a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065e:	7e 1c                	jle    80067c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	8d 50 08             	lea    0x8(%eax),%edx
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	89 10                	mov    %edx,(%eax)
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	8b 00                	mov    (%eax),%eax
  800672:	83 e8 08             	sub    $0x8,%eax
  800675:	8b 50 04             	mov    0x4(%eax),%edx
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	eb 40                	jmp    8006bc <getuint+0x65>
	else if (lflag)
  80067c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800680:	74 1e                	je     8006a0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 10                	mov    %edx,(%eax)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
  80069e:	eb 1c                	jmp    8006bc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	8d 50 04             	lea    0x4(%eax),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	89 10                	mov    %edx,(%eax)
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	83 e8 04             	sub    $0x4,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006bc:	5d                   	pop    %ebp
  8006bd:	c3                   	ret    

008006be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c5:	7e 1c                	jle    8006e3 <getint+0x25>
		return va_arg(*ap, long long);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 08             	lea    0x8(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 08             	sub    $0x8,%eax
  8006dc:	8b 50 04             	mov    0x4(%eax),%edx
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	eb 38                	jmp    80071b <getint+0x5d>
	else if (lflag)
  8006e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e7:	74 1a                	je     800703 <getint+0x45>
		return va_arg(*ap, long);
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	8d 50 04             	lea    0x4(%eax),%edx
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	89 10                	mov    %edx,(%eax)
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	83 e8 04             	sub    $0x4,%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	99                   	cltd   
  800701:	eb 18                	jmp    80071b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	8d 50 04             	lea    0x4(%eax),%edx
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	89 10                	mov    %edx,(%eax)
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	83 e8 04             	sub    $0x4,%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	99                   	cltd   
}
  80071b:	5d                   	pop    %ebp
  80071c:	c3                   	ret    

0080071d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80071d:	55                   	push   %ebp
  80071e:	89 e5                	mov    %esp,%ebp
  800720:	56                   	push   %esi
  800721:	53                   	push   %ebx
  800722:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800725:	eb 17                	jmp    80073e <vprintfmt+0x21>
			if (ch == '\0')
  800727:	85 db                	test   %ebx,%ebx
  800729:	0f 84 c1 03 00 00    	je     800af0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	53                   	push   %ebx
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	ff d0                	call   *%eax
  80073b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073e:	8b 45 10             	mov    0x10(%ebp),%eax
  800741:	8d 50 01             	lea    0x1(%eax),%edx
  800744:	89 55 10             	mov    %edx,0x10(%ebp)
  800747:	8a 00                	mov    (%eax),%al
  800749:	0f b6 d8             	movzbl %al,%ebx
  80074c:	83 fb 25             	cmp    $0x25,%ebx
  80074f:	75 d6                	jne    800727 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800751:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800755:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80075c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800763:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80076a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800771:	8b 45 10             	mov    0x10(%ebp),%eax
  800774:	8d 50 01             	lea    0x1(%eax),%edx
  800777:	89 55 10             	mov    %edx,0x10(%ebp)
  80077a:	8a 00                	mov    (%eax),%al
  80077c:	0f b6 d8             	movzbl %al,%ebx
  80077f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800782:	83 f8 5b             	cmp    $0x5b,%eax
  800785:	0f 87 3d 03 00 00    	ja     800ac8 <vprintfmt+0x3ab>
  80078b:	8b 04 85 78 42 80 00 	mov    0x804278(,%eax,4),%eax
  800792:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800794:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800798:	eb d7                	jmp    800771 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079e:	eb d1                	jmp    800771 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007aa:	89 d0                	mov    %edx,%eax
  8007ac:	c1 e0 02             	shl    $0x2,%eax
  8007af:	01 d0                	add    %edx,%eax
  8007b1:	01 c0                	add    %eax,%eax
  8007b3:	01 d8                	add    %ebx,%eax
  8007b5:	83 e8 30             	sub    $0x30,%eax
  8007b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007be:	8a 00                	mov    (%eax),%al
  8007c0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c6:	7e 3e                	jle    800806 <vprintfmt+0xe9>
  8007c8:	83 fb 39             	cmp    $0x39,%ebx
  8007cb:	7f 39                	jg     800806 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007cd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d0:	eb d5                	jmp    8007a7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	83 c0 04             	add    $0x4,%eax
  8007d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	83 e8 04             	sub    $0x4,%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e6:	eb 1f                	jmp    800807 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ec:	79 83                	jns    800771 <vprintfmt+0x54>
				width = 0;
  8007ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f5:	e9 77 ff ff ff       	jmp    800771 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007fa:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800801:	e9 6b ff ff ff       	jmp    800771 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800806:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800807:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080b:	0f 89 60 ff ff ff    	jns    800771 <vprintfmt+0x54>
				width = precision, precision = -1;
  800811:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800814:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800817:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081e:	e9 4e ff ff ff       	jmp    800771 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800823:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800826:	e9 46 ff ff ff       	jmp    800771 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	83 c0 04             	add    $0x4,%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	83 e8 04             	sub    $0x4,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	50                   	push   %eax
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
			break;
  80084b:	e9 9b 02 00 00       	jmp    800aeb <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 c0 04             	add    $0x4,%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 e8 04             	sub    $0x4,%eax
  80085f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800861:	85 db                	test   %ebx,%ebx
  800863:	79 02                	jns    800867 <vprintfmt+0x14a>
				err = -err;
  800865:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800867:	83 fb 64             	cmp    $0x64,%ebx
  80086a:	7f 0b                	jg     800877 <vprintfmt+0x15a>
  80086c:	8b 34 9d c0 40 80 00 	mov    0x8040c0(,%ebx,4),%esi
  800873:	85 f6                	test   %esi,%esi
  800875:	75 19                	jne    800890 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800877:	53                   	push   %ebx
  800878:	68 65 42 80 00       	push   $0x804265
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	ff 75 08             	pushl  0x8(%ebp)
  800883:	e8 70 02 00 00       	call   800af8 <printfmt>
  800888:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088b:	e9 5b 02 00 00       	jmp    800aeb <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800890:	56                   	push   %esi
  800891:	68 6e 42 80 00       	push   $0x80426e
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	ff 75 08             	pushl  0x8(%ebp)
  80089c:	e8 57 02 00 00       	call   800af8 <printfmt>
  8008a1:	83 c4 10             	add    $0x10,%esp
			break;
  8008a4:	e9 42 02 00 00       	jmp    800aeb <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	83 c0 04             	add    $0x4,%eax
  8008af:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	83 e8 04             	sub    $0x4,%eax
  8008b8:	8b 30                	mov    (%eax),%esi
  8008ba:	85 f6                	test   %esi,%esi
  8008bc:	75 05                	jne    8008c3 <vprintfmt+0x1a6>
				p = "(null)";
  8008be:	be 71 42 80 00       	mov    $0x804271,%esi
			if (width > 0 && padc != '-')
  8008c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c7:	7e 6d                	jle    800936 <vprintfmt+0x219>
  8008c9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008cd:	74 67                	je     800936 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	50                   	push   %eax
  8008d6:	56                   	push   %esi
  8008d7:	e8 1e 03 00 00       	call   800bfa <strnlen>
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e2:	eb 16                	jmp    8008fa <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	50                   	push   %eax
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	ff d0                	call   *%eax
  8008f4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fe:	7f e4                	jg     8008e4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800900:	eb 34                	jmp    800936 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800902:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800906:	74 1c                	je     800924 <vprintfmt+0x207>
  800908:	83 fb 1f             	cmp    $0x1f,%ebx
  80090b:	7e 05                	jle    800912 <vprintfmt+0x1f5>
  80090d:	83 fb 7e             	cmp    $0x7e,%ebx
  800910:	7e 12                	jle    800924 <vprintfmt+0x207>
					putch('?', putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	6a 3f                	push   $0x3f
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	ff d0                	call   *%eax
  80091f:	83 c4 10             	add    $0x10,%esp
  800922:	eb 0f                	jmp    800933 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	53                   	push   %ebx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	ff d0                	call   *%eax
  800930:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800933:	ff 4d e4             	decl   -0x1c(%ebp)
  800936:	89 f0                	mov    %esi,%eax
  800938:	8d 70 01             	lea    0x1(%eax),%esi
  80093b:	8a 00                	mov    (%eax),%al
  80093d:	0f be d8             	movsbl %al,%ebx
  800940:	85 db                	test   %ebx,%ebx
  800942:	74 24                	je     800968 <vprintfmt+0x24b>
  800944:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800948:	78 b8                	js     800902 <vprintfmt+0x1e5>
  80094a:	ff 4d e0             	decl   -0x20(%ebp)
  80094d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800951:	79 af                	jns    800902 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800953:	eb 13                	jmp    800968 <vprintfmt+0x24b>
				putch(' ', putdat);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	6a 20                	push   $0x20
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	ff d0                	call   *%eax
  800962:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800965:	ff 4d e4             	decl   -0x1c(%ebp)
  800968:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096c:	7f e7                	jg     800955 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096e:	e9 78 01 00 00       	jmp    800aeb <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	ff 75 e8             	pushl  -0x18(%ebp)
  800979:	8d 45 14             	lea    0x14(%ebp),%eax
  80097c:	50                   	push   %eax
  80097d:	e8 3c fd ff ff       	call   8006be <getint>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800988:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80098b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800991:	85 d2                	test   %edx,%edx
  800993:	79 23                	jns    8009b8 <vprintfmt+0x29b>
				putch('-', putdat);
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	ff 75 0c             	pushl  0xc(%ebp)
  80099b:	6a 2d                	push   $0x2d
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	ff d0                	call   *%eax
  8009a2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ab:	f7 d8                	neg    %eax
  8009ad:	83 d2 00             	adc    $0x0,%edx
  8009b0:	f7 da                	neg    %edx
  8009b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009bf:	e9 bc 00 00 00       	jmp    800a80 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8009cd:	50                   	push   %eax
  8009ce:	e8 84 fc ff ff       	call   800657 <getuint>
  8009d3:	83 c4 10             	add    $0x10,%esp
  8009d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009dc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e3:	e9 98 00 00 00       	jmp    800a80 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 58                	push   $0x58
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a08:	83 ec 08             	sub    $0x8,%esp
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	6a 58                	push   $0x58
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	ff d0                	call   *%eax
  800a15:	83 c4 10             	add    $0x10,%esp
			break;
  800a18:	e9 ce 00 00 00       	jmp    800aeb <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 30                	push   $0x30
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	6a 78                	push   $0x78
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	83 c0 04             	add    $0x4,%eax
  800a43:	89 45 14             	mov    %eax,0x14(%ebp)
  800a46:	8b 45 14             	mov    0x14(%ebp),%eax
  800a49:	83 e8 04             	sub    $0x4,%eax
  800a4c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a5f:	eb 1f                	jmp    800a80 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 e8             	pushl  -0x18(%ebp)
  800a67:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6a:	50                   	push   %eax
  800a6b:	e8 e7 fb ff ff       	call   800657 <getuint>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a76:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a79:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a80:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a87:	83 ec 04             	sub    $0x4,%esp
  800a8a:	52                   	push   %edx
  800a8b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8e:	50                   	push   %eax
  800a8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a92:	ff 75 f0             	pushl  -0x10(%ebp)
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	e8 00 fb ff ff       	call   8005a0 <printnum>
  800aa0:	83 c4 20             	add    $0x20,%esp
			break;
  800aa3:	eb 46                	jmp    800aeb <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa5:	83 ec 08             	sub    $0x8,%esp
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	53                   	push   %ebx
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	ff d0                	call   *%eax
  800ab1:	83 c4 10             	add    $0x10,%esp
			break;
  800ab4:	eb 35                	jmp    800aeb <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ab6:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800abd:	eb 2c                	jmp    800aeb <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800abf:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
			break;
  800ac6:	eb 23                	jmp    800aeb <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	6a 25                	push   $0x25
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	ff d0                	call   *%eax
  800ad5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad8:	ff 4d 10             	decl   0x10(%ebp)
  800adb:	eb 03                	jmp    800ae0 <vprintfmt+0x3c3>
  800add:	ff 4d 10             	decl   0x10(%ebp)
  800ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae3:	48                   	dec    %eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	3c 25                	cmp    $0x25,%al
  800ae8:	75 f3                	jne    800add <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800aea:	90                   	nop
		}
	}
  800aeb:	e9 35 fc ff ff       	jmp    800725 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800af0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800afe:	8d 45 10             	lea    0x10(%ebp),%eax
  800b01:	83 c0 04             	add    $0x4,%eax
  800b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b07:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0d:	50                   	push   %eax
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	ff 75 08             	pushl  0x8(%ebp)
  800b14:	e8 04 fc ff ff       	call   80071d <vprintfmt>
  800b19:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b1c:	90                   	nop
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8b 40 08             	mov    0x8(%eax),%eax
  800b28:	8d 50 01             	lea    0x1(%eax),%edx
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8b 10                	mov    (%eax),%edx
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8b 40 04             	mov    0x4(%eax),%eax
  800b3c:	39 c2                	cmp    %eax,%edx
  800b3e:	73 12                	jae    800b52 <sprintputch+0x33>
		*b->buf++ = ch;
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8b 00                	mov    (%eax),%eax
  800b45:	8d 48 01             	lea    0x1(%eax),%ecx
  800b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4b:	89 0a                	mov    %ecx,(%edx)
  800b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b50:	88 10                	mov    %dl,(%eax)
}
  800b52:	90                   	nop
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	01 d0                	add    %edx,%eax
  800b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b7a:	74 06                	je     800b82 <vsnprintf+0x2d>
  800b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b80:	7f 07                	jg     800b89 <vsnprintf+0x34>
		return -E_INVAL;
  800b82:	b8 03 00 00 00       	mov    $0x3,%eax
  800b87:	eb 20                	jmp    800ba9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b89:	ff 75 14             	pushl  0x14(%ebp)
  800b8c:	ff 75 10             	pushl  0x10(%ebp)
  800b8f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b92:	50                   	push   %eax
  800b93:	68 1f 0b 80 00       	push   $0x800b1f
  800b98:	e8 80 fb ff ff       	call   80071d <vprintfmt>
  800b9d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ba3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb1:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb4:	83 c0 04             	add    $0x4,%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bba:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc0:	50                   	push   %eax
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	ff 75 08             	pushl  0x8(%ebp)
  800bc7:	e8 89 ff ff ff       	call   800b55 <vsnprintf>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be4:	eb 06                	jmp    800bec <strlen+0x15>
		n++;
  800be6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800be9:	ff 45 08             	incl   0x8(%ebp)
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	84 c0                	test   %al,%al
  800bf3:	75 f1                	jne    800be6 <strlen+0xf>
		n++;
	return n;
  800bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf8:	c9                   	leave  
  800bf9:	c3                   	ret    

00800bfa <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c07:	eb 09                	jmp    800c12 <strnlen+0x18>
		n++;
  800c09:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0c:	ff 45 08             	incl   0x8(%ebp)
  800c0f:	ff 4d 0c             	decl   0xc(%ebp)
  800c12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c16:	74 09                	je     800c21 <strnlen+0x27>
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	84 c0                	test   %al,%al
  800c1f:	75 e8                	jne    800c09 <strnlen+0xf>
		n++;
	return n;
  800c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c32:	90                   	nop
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8d 50 01             	lea    0x1(%eax),%edx
  800c39:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c42:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	84 c0                	test   %al,%al
  800c4d:	75 e4                	jne    800c33 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c67:	eb 1f                	jmp    800c88 <strncpy+0x34>
		*dst++ = *src;
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8d 50 01             	lea    0x1(%eax),%edx
  800c6f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	84 c0                	test   %al,%al
  800c80:	74 03                	je     800c85 <strncpy+0x31>
			src++;
  800c82:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c85:	ff 45 fc             	incl   -0x4(%ebp)
  800c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c8e:	72 d9                	jb     800c69 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c90:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ca1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca5:	74 30                	je     800cd7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ca7:	eb 16                	jmp    800cbf <strlcpy+0x2a>
			*dst++ = *src++;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8d 50 01             	lea    0x1(%eax),%edx
  800caf:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbb:	8a 12                	mov    (%edx),%dl
  800cbd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cbf:	ff 4d 10             	decl   0x10(%ebp)
  800cc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc6:	74 09                	je     800cd1 <strlcpy+0x3c>
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	84 c0                	test   %al,%al
  800ccf:	75 d8                	jne    800ca9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdd:	29 c2                	sub    %eax,%edx
  800cdf:	89 d0                	mov    %edx,%eax
}
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    

00800ce3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ce6:	eb 06                	jmp    800cee <strcmp+0xb>
		p++, q++;
  800ce8:	ff 45 08             	incl   0x8(%ebp)
  800ceb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	74 0e                	je     800d05 <strcmp+0x22>
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 10                	mov    (%eax),%dl
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	38 c2                	cmp    %al,%dl
  800d03:	74 e3                	je     800ce8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 c0             	movzbl %al,%eax
  800d15:	29 c2                	sub    %eax,%edx
  800d17:	89 d0                	mov    %edx,%eax
}
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d1e:	eb 09                	jmp    800d29 <strncmp+0xe>
		n--, p++, q++;
  800d20:	ff 4d 10             	decl   0x10(%ebp)
  800d23:	ff 45 08             	incl   0x8(%ebp)
  800d26:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2d:	74 17                	je     800d46 <strncmp+0x2b>
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	84 c0                	test   %al,%al
  800d36:	74 0e                	je     800d46 <strncmp+0x2b>
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 10                	mov    (%eax),%dl
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	38 c2                	cmp    %al,%dl
  800d44:	74 da                	je     800d20 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4a:	75 07                	jne    800d53 <strncmp+0x38>
		return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d51:	eb 14                	jmp    800d67 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	0f b6 d0             	movzbl %al,%edx
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	0f b6 c0             	movzbl %al,%eax
  800d63:	29 c2                	sub    %eax,%edx
  800d65:	89 d0                	mov    %edx,%eax
}
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 12                	jmp    800d89 <strchr+0x20>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	75 05                	jne    800d86 <strchr+0x1d>
			return (char *) s;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	eb 11                	jmp    800d97 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d86:	ff 45 08             	incl   0x8(%ebp)
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 e5                	jne    800d77 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d97:	c9                   	leave  
  800d98:	c3                   	ret    

00800d99 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 0d                	jmp    800db4 <strfind+0x1b>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	74 0e                	je     800dbf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	75 ea                	jne    800da7 <strfind+0xe>
  800dbd:	eb 01                	jmp    800dc0 <strfind+0x27>
		if (*s == c)
			break;
  800dbf:	90                   	nop
	return (char *) s;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dd7:	eb 0e                	jmp    800de7 <memset+0x22>
		*p++ = c;
  800dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800de7:	ff 4d f8             	decl   -0x8(%ebp)
  800dea:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dee:	79 e9                	jns    800dd9 <memset+0x14>
		*p++ = c;

	return v;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e07:	eb 16                	jmp    800e1f <memcpy+0x2a>
		*d++ = *s++;
  800e09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e18:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e1b:	8a 12                	mov    (%edx),%dl
  800e1d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e25:	89 55 10             	mov    %edx,0x10(%ebp)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	75 dd                	jne    800e09 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e49:	73 50                	jae    800e9b <memmove+0x6a>
  800e4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	01 d0                	add    %edx,%eax
  800e53:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e56:	76 43                	jbe    800e9b <memmove+0x6a>
		s += n;
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e61:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e64:	eb 10                	jmp    800e76 <memmove+0x45>
			*--d = *--s;
  800e66:	ff 4d f8             	decl   -0x8(%ebp)
  800e69:	ff 4d fc             	decl   -0x4(%ebp)
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8a 10                	mov    (%eax),%dl
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e74:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e76:	8b 45 10             	mov    0x10(%ebp),%eax
  800e79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	75 e3                	jne    800e66 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e83:	eb 23                	jmp    800ea8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e88:	8d 50 01             	lea    0x1(%eax),%edx
  800e8b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e97:	8a 12                	mov    (%edx),%dl
  800e99:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	75 dd                	jne    800e85 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ebf:	eb 2a                	jmp    800eeb <memcmp+0x3e>
		if (*s1 != *s2)
  800ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec4:	8a 10                	mov    (%eax),%dl
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	38 c2                	cmp    %al,%dl
  800ecd:	74 16                	je     800ee5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f b6 d0             	movzbl %al,%edx
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	0f b6 c0             	movzbl %al,%eax
  800edf:	29 c2                	sub    %eax,%edx
  800ee1:	89 d0                	mov    %edx,%eax
  800ee3:	eb 18                	jmp    800efd <memcmp+0x50>
		s1++, s2++;
  800ee5:	ff 45 fc             	incl   -0x4(%ebp)
  800ee8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	75 c9                	jne    800ec1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0b:	01 d0                	add    %edx,%eax
  800f0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f10:	eb 15                	jmp    800f27 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	0f b6 d0             	movzbl %al,%edx
  800f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1d:	0f b6 c0             	movzbl %al,%eax
  800f20:	39 c2                	cmp    %eax,%edx
  800f22:	74 0d                	je     800f31 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f2d:	72 e3                	jb     800f12 <memfind+0x13>
  800f2f:	eb 01                	jmp    800f32 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f31:	90                   	nop
	return (void *) s;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f44:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4b:	eb 03                	jmp    800f50 <strtol+0x19>
		s++;
  800f4d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 20                	cmp    $0x20,%al
  800f57:	74 f4                	je     800f4d <strtol+0x16>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 09                	cmp    $0x9,%al
  800f60:	74 eb                	je     800f4d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	3c 2b                	cmp    $0x2b,%al
  800f69:	75 05                	jne    800f70 <strtol+0x39>
		s++;
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	eb 13                	jmp    800f83 <strtol+0x4c>
	else if (*s == '-')
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 2d                	cmp    $0x2d,%al
  800f77:	75 0a                	jne    800f83 <strtol+0x4c>
		s++, neg = 1;
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f87:	74 06                	je     800f8f <strtol+0x58>
  800f89:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f8d:	75 20                	jne    800faf <strtol+0x78>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 30                	cmp    $0x30,%al
  800f96:	75 17                	jne    800faf <strtol+0x78>
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	40                   	inc    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 78                	cmp    $0x78,%al
  800fa0:	75 0d                	jne    800faf <strtol+0x78>
		s += 2, base = 16;
  800fa2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fa6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fad:	eb 28                	jmp    800fd7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	75 15                	jne    800fca <strtol+0x93>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 30                	cmp    $0x30,%al
  800fbc:	75 0c                	jne    800fca <strtol+0x93>
		s++, base = 8;
  800fbe:	ff 45 08             	incl   0x8(%ebp)
  800fc1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fc8:	eb 0d                	jmp    800fd7 <strtol+0xa0>
	else if (base == 0)
  800fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fce:	75 07                	jne    800fd7 <strtol+0xa0>
		base = 10;
  800fd0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 2f                	cmp    $0x2f,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xc2>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 39                	cmp    $0x39,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xc2>
			dig = *s - '0';
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 30             	sub    $0x30,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 42                	jmp    80103b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 60                	cmp    $0x60,%al
  801000:	7e 19                	jle    80101b <strtol+0xe4>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 7a                	cmp    $0x7a,%al
  801009:	7f 10                	jg     80101b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 57             	sub    $0x57,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801019:	eb 20                	jmp    80103b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	3c 40                	cmp    $0x40,%al
  801022:	7e 39                	jle    80105d <strtol+0x126>
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	3c 5a                	cmp    $0x5a,%al
  80102b:	7f 30                	jg     80105d <strtol+0x126>
			dig = *s - 'A' + 10;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	0f be c0             	movsbl %al,%eax
  801035:	83 e8 37             	sub    $0x37,%eax
  801038:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80103b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801041:	7d 19                	jge    80105c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	0f af 45 10          	imul   0x10(%ebp),%eax
  80104d:	89 c2                	mov    %eax,%edx
  80104f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801052:	01 d0                	add    %edx,%eax
  801054:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801057:	e9 7b ff ff ff       	jmp    800fd7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80105c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80105d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801061:	74 08                	je     80106b <strtol+0x134>
		*endptr = (char *) s;
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80106b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80106f:	74 07                	je     801078 <strtol+0x141>
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	f7 d8                	neg    %eax
  801076:	eb 03                	jmp    80107b <strtol+0x144>
  801078:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <ltostr>:

void
ltostr(long value, char *str)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801083:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80108a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	79 13                	jns    8010aa <ltostr+0x2d>
	{
		neg = 1;
  801097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80109e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010a4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010a7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010b2:	99                   	cltd   
  8010b3:	f7 f9                	idiv   %ecx
  8010b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bb:	8d 50 01             	lea    0x1(%eax),%edx
  8010be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010cb:	83 c2 30             	add    $0x30,%edx
  8010ce:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d8:	f7 e9                	imul   %ecx
  8010da:	c1 fa 02             	sar    $0x2,%edx
  8010dd:	89 c8                	mov    %ecx,%eax
  8010df:	c1 f8 1f             	sar    $0x1f,%eax
  8010e2:	29 c2                	sub    %eax,%edx
  8010e4:	89 d0                	mov    %edx,%eax
  8010e6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ed:	75 bb                	jne    8010aa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	48                   	dec    %eax
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801101:	74 3d                	je     801140 <ltostr+0xc3>
		start = 1 ;
  801103:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110a:	eb 34                	jmp    801140 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80110c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 c2                	add    %eax,%edx
  801121:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c8                	add    %ecx,%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	01 c2                	add    %eax,%edx
  801135:	8a 45 eb             	mov    -0x15(%ebp),%al
  801138:	88 02                	mov    %al,(%edx)
		start++ ;
  80113a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801146:	7c c4                	jl     80110c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801148:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801153:	90                   	nop
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80115c:	ff 75 08             	pushl  0x8(%ebp)
  80115f:	e8 73 fa ff ff       	call   800bd7 <strlen>
  801164:	83 c4 04             	add    $0x4,%esp
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	e8 65 fa ff ff       	call   800bd7 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801186:	eb 17                	jmp    80119f <strcconcat+0x49>
		final[s] = str1[s] ;
  801188:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	01 c2                	add    %eax,%edx
  801190:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	01 c8                	add    %ecx,%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80119c:	ff 45 fc             	incl   -0x4(%ebp)
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a5:	7c e1                	jl     801188 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b5:	eb 1f                	jmp    8011d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ba:	8d 50 01             	lea    0x1(%eax),%edx
  8011bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	01 c2                	add    %eax,%edx
  8011c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	01 c8                	add    %ecx,%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dc:	7c d9                	jl     8011b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e9:	90                   	nop
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801204:	8b 45 10             	mov    0x10(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120f:	eb 0c                	jmp    80121d <strsplit+0x31>
			*string++ = 0;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	89 55 08             	mov    %edx,0x8(%ebp)
  80121a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	84 c0                	test   %al,%al
  801224:	74 18                	je     80123e <strsplit+0x52>
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f be c0             	movsbl %al,%eax
  80122e:	50                   	push   %eax
  80122f:	ff 75 0c             	pushl  0xc(%ebp)
  801232:	e8 32 fb ff ff       	call   800d69 <strchr>
  801237:	83 c4 08             	add    $0x8,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 d3                	jne    801211 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	74 5a                	je     8012a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	83 f8 0f             	cmp    $0xf,%eax
  80124f:	75 07                	jne    801258 <strsplit+0x6c>
		{
			return 0;
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	eb 66                	jmp    8012be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801258:	8b 45 14             	mov    0x14(%ebp),%eax
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8d 48 01             	lea    0x1(%eax),%ecx
  801260:	8b 55 14             	mov    0x14(%ebp),%edx
  801263:	89 0a                	mov    %ecx,(%edx)
  801265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	01 c2                	add    %eax,%edx
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801276:	eb 03                	jmp    80127b <strsplit+0x8f>
			string++;
  801278:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	84 c0                	test   %al,%al
  801282:	74 8b                	je     80120f <strsplit+0x23>
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	e8 d4 fa ff ff       	call   800d69 <strchr>
  801295:	83 c4 08             	add    $0x8,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	74 dc                	je     801278 <strsplit+0x8c>
			string++;
	}
  80129c:	e9 6e ff ff ff       	jmp    80120f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	8b 00                	mov    (%eax),%eax
  8012a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	68 e8 43 80 00       	push   $0x8043e8
  8012ce:	68 3f 01 00 00       	push   $0x13f
  8012d3:	68 0a 44 80 00       	push   $0x80440a
  8012d8:	e8 a9 ef ff ff       	call   800286 <_panic>

008012dd <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8012e3:	83 ec 0c             	sub    $0xc,%esp
  8012e6:	ff 75 08             	pushl  0x8(%ebp)
  8012e9:	e8 e5 0b 00 00       	call   801ed3 <sys_sbrk>
  8012ee:	83 c4 10             	add    $0x10,%esp
}
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8012f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012fd:	75 0a                	jne    801309 <malloc+0x16>
  8012ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801304:	e9 07 02 00 00       	jmp    801510 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801309:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801310:	8b 55 08             	mov    0x8(%ebp),%edx
  801313:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801316:	01 d0                	add    %edx,%eax
  801318:	48                   	dec    %eax
  801319:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80131c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80131f:	ba 00 00 00 00       	mov    $0x0,%edx
  801324:	f7 75 dc             	divl   -0x24(%ebp)
  801327:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80132a:	29 d0                	sub    %edx,%eax
  80132c:	c1 e8 0c             	shr    $0xc,%eax
  80132f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801332:	a1 20 50 80 00       	mov    0x805020,%eax
  801337:	8b 40 78             	mov    0x78(%eax),%eax
  80133a:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80133f:	29 c2                	sub    %eax,%edx
  801341:	89 d0                	mov    %edx,%eax
  801343:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801346:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801349:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80134e:	c1 e8 0c             	shr    $0xc,%eax
  801351:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801354:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80135b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801362:	77 42                	ja     8013a6 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801364:	e8 ee 09 00 00       	call   801d57 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801369:	85 c0                	test   %eax,%eax
  80136b:	74 16                	je     801383 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80136d:	83 ec 0c             	sub    $0xc,%esp
  801370:	ff 75 08             	pushl  0x8(%ebp)
  801373:	e8 2e 0f 00 00       	call   8022a6 <alloc_block_FF>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80137e:	e9 8a 01 00 00       	jmp    80150d <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801383:	e8 00 0a 00 00       	call   801d88 <sys_isUHeapPlacementStrategyBESTFIT>
  801388:	85 c0                	test   %eax,%eax
  80138a:	0f 84 7d 01 00 00    	je     80150d <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801390:	83 ec 0c             	sub    $0xc,%esp
  801393:	ff 75 08             	pushl  0x8(%ebp)
  801396:	e8 c7 13 00 00       	call   802762 <alloc_block_BF>
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013a1:	e9 67 01 00 00       	jmp    80150d <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8013a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8013a9:	48                   	dec    %eax
  8013aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8013ad:	0f 86 53 01 00 00    	jbe    801506 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8013b3:	a1 20 50 80 00       	mov    0x805020,%eax
  8013b8:	8b 40 78             	mov    0x78(%eax),%eax
  8013bb:	05 00 10 00 00       	add    $0x1000,%eax
  8013c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8013c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8013ca:	e9 de 00 00 00       	jmp    8014ad <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8013cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8013d4:	8b 40 78             	mov    0x78(%eax),%eax
  8013d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013da:	29 c2                	sub    %eax,%edx
  8013dc:	89 d0                	mov    %edx,%eax
  8013de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e3:	c1 e8 0c             	shr    $0xc,%eax
  8013e6:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	0f 85 ab 00 00 00    	jne    8014a0 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8013f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f8:	05 00 10 00 00       	add    $0x1000,%eax
  8013fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801400:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801407:	eb 47                	jmp    801450 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801409:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801410:	76 0a                	jbe    80141c <malloc+0x129>
  801412:	b8 00 00 00 00       	mov    $0x0,%eax
  801417:	e9 f4 00 00 00       	jmp    801510 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  80141c:	a1 20 50 80 00       	mov    0x805020,%eax
  801421:	8b 40 78             	mov    0x78(%eax),%eax
  801424:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801427:	29 c2                	sub    %eax,%edx
  801429:	89 d0                	mov    %edx,%eax
  80142b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801430:	c1 e8 0c             	shr    $0xc,%eax
  801433:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  80143a:	85 c0                	test   %eax,%eax
  80143c:	74 08                	je     801446 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  80143e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801441:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801444:	eb 5a                	jmp    8014a0 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801446:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80144d:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801450:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801453:	48                   	dec    %eax
  801454:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801457:	77 b0                	ja     801409 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801459:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801460:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801467:	eb 2f                	jmp    801498 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801469:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146c:	c1 e0 0c             	shl    $0xc,%eax
  80146f:	89 c2                	mov    %eax,%edx
  801471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801474:	01 c2                	add    %eax,%edx
  801476:	a1 20 50 80 00       	mov    0x805020,%eax
  80147b:	8b 40 78             	mov    0x78(%eax),%eax
  80147e:	29 c2                	sub    %eax,%edx
  801480:	89 d0                	mov    %edx,%eax
  801482:	2d 00 10 00 00       	sub    $0x1000,%eax
  801487:	c1 e8 0c             	shr    $0xc,%eax
  80148a:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
  801491:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801495:	ff 45 e0             	incl   -0x20(%ebp)
  801498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80149e:	72 c9                	jb     801469 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8014a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a4:	75 16                	jne    8014bc <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8014a6:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8014ad:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8014b4:	0f 86 15 ff ff ff    	jbe    8013cf <malloc+0xdc>
  8014ba:	eb 01                	jmp    8014bd <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8014bc:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8014bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014c1:	75 07                	jne    8014ca <malloc+0x1d7>
  8014c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c8:	eb 46                	jmp    801510 <malloc+0x21d>
		ptr = (void*)i;
  8014ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8014d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8014d5:	8b 40 78             	mov    0x78(%eax),%eax
  8014d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014db:	29 c2                	sub    %eax,%edx
  8014dd:	89 d0                	mov    %edx,%eax
  8014df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014e4:	c1 e8 0c             	shr    $0xc,%eax
  8014e7:	89 c2                	mov    %eax,%edx
  8014e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014ec:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	ff 75 08             	pushl  0x8(%ebp)
  8014f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8014fc:	e8 09 0a 00 00       	call   801f0a <sys_allocate_user_mem>
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	eb 07                	jmp    80150d <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801506:	b8 00 00 00 00       	mov    $0x0,%eax
  80150b:	eb 03                	jmp    801510 <malloc+0x21d>
	}
	return ptr;
  80150d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801518:	a1 20 50 80 00       	mov    0x805020,%eax
  80151d:	8b 40 78             	mov    0x78(%eax),%eax
  801520:	05 00 10 00 00       	add    $0x1000,%eax
  801525:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801528:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80152f:	a1 20 50 80 00       	mov    0x805020,%eax
  801534:	8b 50 78             	mov    0x78(%eax),%edx
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	39 c2                	cmp    %eax,%edx
  80153c:	76 24                	jbe    801562 <free+0x50>
		size = get_block_size(va);
  80153e:	83 ec 0c             	sub    $0xc,%esp
  801541:	ff 75 08             	pushl  0x8(%ebp)
  801544:	e8 dd 09 00 00       	call   801f26 <get_block_size>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80154f:	83 ec 0c             	sub    $0xc,%esp
  801552:	ff 75 08             	pushl  0x8(%ebp)
  801555:	e8 10 1c 00 00       	call   80316a <free_block>
  80155a:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80155d:	e9 ac 00 00 00       	jmp    80160e <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801568:	0f 82 89 00 00 00    	jb     8015f7 <free+0xe5>
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801576:	77 7f                	ja     8015f7 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801578:	8b 55 08             	mov    0x8(%ebp),%edx
  80157b:	a1 20 50 80 00       	mov    0x805020,%eax
  801580:	8b 40 78             	mov    0x78(%eax),%eax
  801583:	29 c2                	sub    %eax,%edx
  801585:	89 d0                	mov    %edx,%eax
  801587:	2d 00 10 00 00       	sub    $0x1000,%eax
  80158c:	c1 e8 0c             	shr    $0xc,%eax
  80158f:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  801596:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801599:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80159c:	c1 e0 0c             	shl    $0xc,%eax
  80159f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8015a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015a9:	eb 42                	jmp    8015ed <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8015ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ae:	c1 e0 0c             	shl    $0xc,%eax
  8015b1:	89 c2                	mov    %eax,%edx
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	01 c2                	add    %eax,%edx
  8015b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8015bd:	8b 40 78             	mov    0x78(%eax),%eax
  8015c0:	29 c2                	sub    %eax,%edx
  8015c2:	89 d0                	mov    %edx,%eax
  8015c4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c9:	c1 e8 0c             	shr    $0xc,%eax
  8015cc:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  8015d3:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8015d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	83 ec 08             	sub    $0x8,%esp
  8015e0:	52                   	push   %edx
  8015e1:	50                   	push   %eax
  8015e2:	e8 07 09 00 00       	call   801eee <sys_free_user_mem>
  8015e7:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8015ea:	ff 45 f4             	incl   -0xc(%ebp)
  8015ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8015f3:	72 b6                	jb     8015ab <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8015f5:	eb 17                	jmp    80160e <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  8015f7:	83 ec 04             	sub    $0x4,%esp
  8015fa:	68 18 44 80 00       	push   $0x804418
  8015ff:	68 88 00 00 00       	push   $0x88
  801604:	68 42 44 80 00       	push   $0x804442
  801609:	e8 78 ec ff ff       	call   800286 <_panic>
	}
}
  80160e:	90                   	nop
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 28             	sub    $0x28,%esp
  801617:	8b 45 10             	mov    0x10(%ebp),%eax
  80161a:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80161d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801621:	75 0a                	jne    80162d <smalloc+0x1c>
  801623:	b8 00 00 00 00       	mov    $0x0,%eax
  801628:	e9 ec 00 00 00       	jmp    801719 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80162d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801630:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801633:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80163a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80163d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801640:	39 d0                	cmp    %edx,%eax
  801642:	73 02                	jae    801646 <smalloc+0x35>
  801644:	89 d0                	mov    %edx,%eax
  801646:	83 ec 0c             	sub    $0xc,%esp
  801649:	50                   	push   %eax
  80164a:	e8 a4 fc ff ff       	call   8012f3 <malloc>
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801655:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801659:	75 0a                	jne    801665 <smalloc+0x54>
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
  801660:	e9 b4 00 00 00       	jmp    801719 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801665:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801669:	ff 75 ec             	pushl  -0x14(%ebp)
  80166c:	50                   	push   %eax
  80166d:	ff 75 0c             	pushl  0xc(%ebp)
  801670:	ff 75 08             	pushl  0x8(%ebp)
  801673:	e8 7d 04 00 00       	call   801af5 <sys_createSharedObject>
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80167e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801682:	74 06                	je     80168a <smalloc+0x79>
  801684:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801688:	75 0a                	jne    801694 <smalloc+0x83>
  80168a:	b8 00 00 00 00       	mov    $0x0,%eax
  80168f:	e9 85 00 00 00       	jmp    801719 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	ff 75 ec             	pushl  -0x14(%ebp)
  80169a:	68 4e 44 80 00       	push   $0x80444e
  80169f:	e8 9f ee ff ff       	call   800543 <cprintf>
  8016a4:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8016a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8016af:	8b 40 78             	mov    0x78(%eax),%eax
  8016b2:	29 c2                	sub    %eax,%edx
  8016b4:	89 d0                	mov    %edx,%eax
  8016b6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016bb:	c1 e8 0c             	shr    $0xc,%eax
  8016be:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8016c4:	42                   	inc    %edx
  8016c5:	89 15 24 50 80 00    	mov    %edx,0x805024
  8016cb:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8016d1:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8016d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016db:	a1 20 50 80 00       	mov    0x805020,%eax
  8016e0:	8b 40 78             	mov    0x78(%eax),%eax
  8016e3:	29 c2                	sub    %eax,%edx
  8016e5:	89 d0                	mov    %edx,%eax
  8016e7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016ec:	c1 e8 0c             	shr    $0xc,%eax
  8016ef:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8016f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8016fb:	8b 50 10             	mov    0x10(%eax),%edx
  8016fe:	89 c8                	mov    %ecx,%eax
  801700:	c1 e0 02             	shl    $0x2,%eax
  801703:	89 c1                	mov    %eax,%ecx
  801705:	c1 e1 09             	shl    $0x9,%ecx
  801708:	01 c8                	add    %ecx,%eax
  80170a:	01 c2                	add    %eax,%edx
  80170c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80170f:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801716:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801721:	83 ec 08             	sub    $0x8,%esp
  801724:	ff 75 0c             	pushl  0xc(%ebp)
  801727:	ff 75 08             	pushl  0x8(%ebp)
  80172a:	e8 f0 03 00 00       	call   801b1f <sys_getSizeOfSharedObject>
  80172f:	83 c4 10             	add    $0x10,%esp
  801732:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801735:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801739:	75 0a                	jne    801745 <sget+0x2a>
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax
  801740:	e9 e7 00 00 00       	jmp    80182c <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801748:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80174b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801752:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801758:	39 d0                	cmp    %edx,%eax
  80175a:	73 02                	jae    80175e <sget+0x43>
  80175c:	89 d0                	mov    %edx,%eax
  80175e:	83 ec 0c             	sub    $0xc,%esp
  801761:	50                   	push   %eax
  801762:	e8 8c fb ff ff       	call   8012f3 <malloc>
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80176d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801771:	75 0a                	jne    80177d <sget+0x62>
  801773:	b8 00 00 00 00       	mov    $0x0,%eax
  801778:	e9 af 00 00 00       	jmp    80182c <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80177d:	83 ec 04             	sub    $0x4,%esp
  801780:	ff 75 e8             	pushl  -0x18(%ebp)
  801783:	ff 75 0c             	pushl  0xc(%ebp)
  801786:	ff 75 08             	pushl  0x8(%ebp)
  801789:	e8 ae 03 00 00       	call   801b3c <sys_getSharedObject>
  80178e:	83 c4 10             	add    $0x10,%esp
  801791:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801794:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801797:	a1 20 50 80 00       	mov    0x805020,%eax
  80179c:	8b 40 78             	mov    0x78(%eax),%eax
  80179f:	29 c2                	sub    %eax,%edx
  8017a1:	89 d0                	mov    %edx,%eax
  8017a3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017a8:	c1 e8 0c             	shr    $0xc,%eax
  8017ab:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8017b1:	42                   	inc    %edx
  8017b2:	89 15 24 50 80 00    	mov    %edx,0x805024
  8017b8:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8017be:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8017c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8017cd:	8b 40 78             	mov    0x78(%eax),%eax
  8017d0:	29 c2                	sub    %eax,%edx
  8017d2:	89 d0                	mov    %edx,%eax
  8017d4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017d9:	c1 e8 0c             	shr    $0xc,%eax
  8017dc:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8017e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8017e8:	8b 50 10             	mov    0x10(%eax),%edx
  8017eb:	89 c8                	mov    %ecx,%eax
  8017ed:	c1 e0 02             	shl    $0x2,%eax
  8017f0:	89 c1                	mov    %eax,%ecx
  8017f2:	c1 e1 09             	shl    $0x9,%ecx
  8017f5:	01 c8                	add    %ecx,%eax
  8017f7:	01 c2                	add    %eax,%edx
  8017f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017fc:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801803:	a1 20 50 80 00       	mov    0x805020,%eax
  801808:	8b 40 10             	mov    0x10(%eax),%eax
  80180b:	83 ec 08             	sub    $0x8,%esp
  80180e:	50                   	push   %eax
  80180f:	68 5d 44 80 00       	push   $0x80445d
  801814:	e8 2a ed ff ff       	call   800543 <cprintf>
  801819:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80181c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801820:	75 07                	jne    801829 <sget+0x10e>
  801822:	b8 00 00 00 00       	mov    $0x0,%eax
  801827:	eb 03                	jmp    80182c <sget+0x111>
	return ptr;
  801829:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801834:	8b 55 08             	mov    0x8(%ebp),%edx
  801837:	a1 20 50 80 00       	mov    0x805020,%eax
  80183c:	8b 40 78             	mov    0x78(%eax),%eax
  80183f:	29 c2                	sub    %eax,%edx
  801841:	89 d0                	mov    %edx,%eax
  801843:	2d 00 10 00 00       	sub    $0x1000,%eax
  801848:	c1 e8 0c             	shr    $0xc,%eax
  80184b:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801852:	a1 20 50 80 00       	mov    0x805020,%eax
  801857:	8b 50 10             	mov    0x10(%eax),%edx
  80185a:	89 c8                	mov    %ecx,%eax
  80185c:	c1 e0 02             	shl    $0x2,%eax
  80185f:	89 c1                	mov    %eax,%ecx
  801861:	c1 e1 09             	shl    $0x9,%ecx
  801864:	01 c8                	add    %ecx,%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80186f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801872:	83 ec 08             	sub    $0x8,%esp
  801875:	ff 75 08             	pushl  0x8(%ebp)
  801878:	ff 75 f4             	pushl  -0xc(%ebp)
  80187b:	e8 db 02 00 00       	call   801b5b <sys_freeSharedObject>
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801886:	90                   	nop
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	68 6c 44 80 00       	push   $0x80446c
  801897:	68 e5 00 00 00       	push   $0xe5
  80189c:	68 42 44 80 00       	push   $0x804442
  8018a1:	e8 e0 e9 ff ff       	call   800286 <_panic>

008018a6 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	68 92 44 80 00       	push   $0x804492
  8018b4:	68 f1 00 00 00       	push   $0xf1
  8018b9:	68 42 44 80 00       	push   $0x804442
  8018be:	e8 c3 e9 ff ff       	call   800286 <_panic>

008018c3 <shrink>:

}
void shrink(uint32 newSize)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	68 92 44 80 00       	push   $0x804492
  8018d1:	68 f6 00 00 00       	push   $0xf6
  8018d6:	68 42 44 80 00       	push   $0x804442
  8018db:	e8 a6 e9 ff ff       	call   800286 <_panic>

008018e0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	68 92 44 80 00       	push   $0x804492
  8018ee:	68 fb 00 00 00       	push   $0xfb
  8018f3:	68 42 44 80 00       	push   $0x804442
  8018f8:	e8 89 e9 ff ff       	call   800286 <_panic>

008018fd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	57                   	push   %edi
  801901:	56                   	push   %esi
  801902:	53                   	push   %ebx
  801903:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801912:	8b 7d 18             	mov    0x18(%ebp),%edi
  801915:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801918:	cd 30                	int    $0x30
  80191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	5b                   	pop    %ebx
  801924:	5e                   	pop    %esi
  801925:	5f                   	pop    %edi
  801926:	5d                   	pop    %ebp
  801927:	c3                   	ret    

00801928 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	8b 45 10             	mov    0x10(%ebp),%eax
  801931:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801934:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	52                   	push   %edx
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	50                   	push   %eax
  801944:	6a 00                	push   $0x0
  801946:	e8 b2 ff ff ff       	call   8018fd <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	90                   	nop
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_cgetc>:

int
sys_cgetc(void)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 02                	push   $0x2
  801960:	e8 98 ff ff ff       	call   8018fd <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 03                	push   $0x3
  801979:	e8 7f ff ff ff       	call   8018fd <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	90                   	nop
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 04                	push   $0x4
  801993:	e8 65 ff ff ff       	call   8018fd <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	90                   	nop
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	52                   	push   %edx
  8019ae:	50                   	push   %eax
  8019af:	6a 08                	push   $0x8
  8019b1:	e8 47 ff ff ff       	call   8018fd <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	56                   	push   %esi
  8019bf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019c0:	8b 75 18             	mov    0x18(%ebp),%esi
  8019c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	56                   	push   %esi
  8019d0:	53                   	push   %ebx
  8019d1:	51                   	push   %ecx
  8019d2:	52                   	push   %edx
  8019d3:	50                   	push   %eax
  8019d4:	6a 09                	push   $0x9
  8019d6:	e8 22 ff ff ff       	call   8018fd <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e1:	5b                   	pop    %ebx
  8019e2:	5e                   	pop    %esi
  8019e3:	5d                   	pop    %ebp
  8019e4:	c3                   	ret    

008019e5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	52                   	push   %edx
  8019f5:	50                   	push   %eax
  8019f6:	6a 0a                	push   $0xa
  8019f8:	e8 00 ff ff ff       	call   8018fd <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	ff 75 08             	pushl  0x8(%ebp)
  801a11:	6a 0b                	push   $0xb
  801a13:	e8 e5 fe ff ff       	call   8018fd <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 0c                	push   $0xc
  801a2c:	e8 cc fe ff ff       	call   8018fd <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 0d                	push   $0xd
  801a45:	e8 b3 fe ff ff       	call   8018fd <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 0e                	push   $0xe
  801a5e:	e8 9a fe ff ff       	call   8018fd <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 0f                	push   $0xf
  801a77:	e8 81 fe ff ff       	call   8018fd <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	ff 75 08             	pushl  0x8(%ebp)
  801a8f:	6a 10                	push   $0x10
  801a91:	e8 67 fe ff ff       	call   8018fd <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 11                	push   $0x11
  801aaa:	e8 4e fe ff ff       	call   8018fd <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	90                   	nop
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 04             	sub    $0x4,%esp
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ac1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	50                   	push   %eax
  801ace:	6a 01                	push   $0x1
  801ad0:	e8 28 fe ff ff       	call   8018fd <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	90                   	nop
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 14                	push   $0x14
  801aea:	e8 0e fe ff ff       	call   8018fd <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	90                   	nop
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 04             	sub    $0x4,%esp
  801afb:	8b 45 10             	mov    0x10(%ebp),%eax
  801afe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b01:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b04:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	51                   	push   %ecx
  801b0e:	52                   	push   %edx
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	50                   	push   %eax
  801b13:	6a 15                	push   $0x15
  801b15:	e8 e3 fd ff ff       	call   8018fd <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	52                   	push   %edx
  801b2f:	50                   	push   %eax
  801b30:	6a 16                	push   $0x16
  801b32:	e8 c6 fd ff ff       	call   8018fd <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	51                   	push   %ecx
  801b4d:	52                   	push   %edx
  801b4e:	50                   	push   %eax
  801b4f:	6a 17                	push   $0x17
  801b51:	e8 a7 fd ff ff       	call   8018fd <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	52                   	push   %edx
  801b6b:	50                   	push   %eax
  801b6c:	6a 18                	push   $0x18
  801b6e:	e8 8a fd ff ff       	call   8018fd <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	ff 75 14             	pushl  0x14(%ebp)
  801b83:	ff 75 10             	pushl  0x10(%ebp)
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	50                   	push   %eax
  801b8a:	6a 19                	push   $0x19
  801b8c:	e8 6c fd ff ff       	call   8018fd <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	50                   	push   %eax
  801ba5:	6a 1a                	push   $0x1a
  801ba7:	e8 51 fd ff ff       	call   8018fd <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	90                   	nop
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	50                   	push   %eax
  801bc1:	6a 1b                	push   $0x1b
  801bc3:	e8 35 fd ff ff       	call   8018fd <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 05                	push   $0x5
  801bdc:	e8 1c fd ff ff       	call   8018fd <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 06                	push   $0x6
  801bf5:	e8 03 fd ff ff       	call   8018fd <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 07                	push   $0x7
  801c0e:	e8 ea fc ff ff       	call   8018fd <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_exit_env>:


void sys_exit_env(void)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 1c                	push   $0x1c
  801c27:	e8 d1 fc ff ff       	call   8018fd <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	90                   	nop
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c3b:	8d 50 04             	lea    0x4(%eax),%edx
  801c3e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	52                   	push   %edx
  801c48:	50                   	push   %eax
  801c49:	6a 1d                	push   $0x1d
  801c4b:	e8 ad fc ff ff       	call   8018fd <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
	return result;
  801c53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c5c:	89 01                	mov    %eax,(%ecx)
  801c5e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	c9                   	leave  
  801c65:	c2 04 00             	ret    $0x4

00801c68 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	ff 75 10             	pushl  0x10(%ebp)
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	6a 13                	push   $0x13
  801c7a:	e8 7e fc ff ff       	call   8018fd <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c82:	90                   	nop
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 1e                	push   $0x1e
  801c94:	e8 64 fc ff ff       	call   8018fd <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 04             	sub    $0x4,%esp
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801caa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	50                   	push   %eax
  801cb7:	6a 1f                	push   $0x1f
  801cb9:	e8 3f fc ff ff       	call   8018fd <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc1:	90                   	nop
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <rsttst>:
void rsttst()
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 21                	push   $0x21
  801cd3:	e8 25 fc ff ff       	call   8018fd <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdb:	90                   	nop
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 04             	sub    $0x4,%esp
  801ce4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cea:	8b 55 18             	mov    0x18(%ebp),%edx
  801ced:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf1:	52                   	push   %edx
  801cf2:	50                   	push   %eax
  801cf3:	ff 75 10             	pushl  0x10(%ebp)
  801cf6:	ff 75 0c             	pushl  0xc(%ebp)
  801cf9:	ff 75 08             	pushl  0x8(%ebp)
  801cfc:	6a 20                	push   $0x20
  801cfe:	e8 fa fb ff ff       	call   8018fd <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
	return ;
  801d06:	90                   	nop
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <chktst>:
void chktst(uint32 n)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	ff 75 08             	pushl  0x8(%ebp)
  801d17:	6a 22                	push   $0x22
  801d19:	e8 df fb ff ff       	call   8018fd <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d21:	90                   	nop
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <inctst>:

void inctst()
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 23                	push   $0x23
  801d33:	e8 c5 fb ff ff       	call   8018fd <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3b:	90                   	nop
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <gettst>:
uint32 gettst()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 24                	push   $0x24
  801d4d:	e8 ab fb ff ff       	call   8018fd <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 25                	push   $0x25
  801d69:	e8 8f fb ff ff       	call   8018fd <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
  801d71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d74:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d78:	75 07                	jne    801d81 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7f:	eb 05                	jmp    801d86 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 25                	push   $0x25
  801d9a:	e8 5e fb ff ff       	call   8018fd <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
  801da2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801da5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801da9:	75 07                	jne    801db2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dab:	b8 01 00 00 00       	mov    $0x1,%eax
  801db0:	eb 05                	jmp    801db7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801db2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 25                	push   $0x25
  801dcb:	e8 2d fb ff ff       	call   8018fd <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
  801dd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dd6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dda:	75 07                	jne    801de3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ddc:	b8 01 00 00 00       	mov    $0x1,%eax
  801de1:	eb 05                	jmp    801de8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 25                	push   $0x25
  801dfc:	e8 fc fa ff ff       	call   8018fd <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
  801e04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e07:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e0b:	75 07                	jne    801e14 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e12:	eb 05                	jmp    801e19 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	ff 75 08             	pushl  0x8(%ebp)
  801e29:	6a 26                	push   $0x26
  801e2b:	e8 cd fa ff ff       	call   8018fd <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
	return ;
  801e33:	90                   	nop
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e43:	8b 45 08             	mov    0x8(%ebp),%eax
  801e46:	6a 00                	push   $0x0
  801e48:	53                   	push   %ebx
  801e49:	51                   	push   %ecx
  801e4a:	52                   	push   %edx
  801e4b:	50                   	push   %eax
  801e4c:	6a 27                	push   $0x27
  801e4e:	e8 aa fa ff ff       	call   8018fd <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
}
  801e56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	52                   	push   %edx
  801e6b:	50                   	push   %eax
  801e6c:	6a 28                	push   $0x28
  801e6e:	e8 8a fa ff ff       	call   8018fd <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e7b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e81:	8b 45 08             	mov    0x8(%ebp),%eax
  801e84:	6a 00                	push   $0x0
  801e86:	51                   	push   %ecx
  801e87:	ff 75 10             	pushl  0x10(%ebp)
  801e8a:	52                   	push   %edx
  801e8b:	50                   	push   %eax
  801e8c:	6a 29                	push   $0x29
  801e8e:	e8 6a fa ff ff       	call   8018fd <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	ff 75 10             	pushl  0x10(%ebp)
  801ea2:	ff 75 0c             	pushl  0xc(%ebp)
  801ea5:	ff 75 08             	pushl  0x8(%ebp)
  801ea8:	6a 12                	push   $0x12
  801eaa:	e8 4e fa ff ff       	call   8018fd <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb2:	90                   	nop
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	52                   	push   %edx
  801ec5:	50                   	push   %eax
  801ec6:	6a 2a                	push   $0x2a
  801ec8:	e8 30 fa ff ff       	call   8018fd <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
	return;
  801ed0:	90                   	nop
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	50                   	push   %eax
  801ee2:	6a 2b                	push   $0x2b
  801ee4:	e8 14 fa ff ff       	call   8018fd <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	ff 75 0c             	pushl  0xc(%ebp)
  801efa:	ff 75 08             	pushl  0x8(%ebp)
  801efd:	6a 2c                	push   $0x2c
  801eff:	e8 f9 f9 ff ff       	call   8018fd <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
	return;
  801f07:	90                   	nop
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	ff 75 0c             	pushl  0xc(%ebp)
  801f16:	ff 75 08             	pushl  0x8(%ebp)
  801f19:	6a 2d                	push   $0x2d
  801f1b:	e8 dd f9 ff ff       	call   8018fd <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
	return;
  801f23:	90                   	nop
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	83 e8 04             	sub    $0x4,%eax
  801f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f38:	8b 00                	mov    (%eax),%eax
  801f3a:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	83 e8 04             	sub    $0x4,%eax
  801f4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f51:	8b 00                	mov    (%eax),%eax
  801f53:	83 e0 01             	and    $0x1,%eax
  801f56:	85 c0                	test   %eax,%eax
  801f58:	0f 94 c0             	sete   %al
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6d:	83 f8 02             	cmp    $0x2,%eax
  801f70:	74 2b                	je     801f9d <alloc_block+0x40>
  801f72:	83 f8 02             	cmp    $0x2,%eax
  801f75:	7f 07                	jg     801f7e <alloc_block+0x21>
  801f77:	83 f8 01             	cmp    $0x1,%eax
  801f7a:	74 0e                	je     801f8a <alloc_block+0x2d>
  801f7c:	eb 58                	jmp    801fd6 <alloc_block+0x79>
  801f7e:	83 f8 03             	cmp    $0x3,%eax
  801f81:	74 2d                	je     801fb0 <alloc_block+0x53>
  801f83:	83 f8 04             	cmp    $0x4,%eax
  801f86:	74 3b                	je     801fc3 <alloc_block+0x66>
  801f88:	eb 4c                	jmp    801fd6 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f8a:	83 ec 0c             	sub    $0xc,%esp
  801f8d:	ff 75 08             	pushl  0x8(%ebp)
  801f90:	e8 11 03 00 00       	call   8022a6 <alloc_block_FF>
  801f95:	83 c4 10             	add    $0x10,%esp
  801f98:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f9b:	eb 4a                	jmp    801fe7 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f9d:	83 ec 0c             	sub    $0xc,%esp
  801fa0:	ff 75 08             	pushl  0x8(%ebp)
  801fa3:	e8 fa 19 00 00       	call   8039a2 <alloc_block_NF>
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fae:	eb 37                	jmp    801fe7 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	ff 75 08             	pushl  0x8(%ebp)
  801fb6:	e8 a7 07 00 00       	call   802762 <alloc_block_BF>
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fc1:	eb 24                	jmp    801fe7 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fc3:	83 ec 0c             	sub    $0xc,%esp
  801fc6:	ff 75 08             	pushl  0x8(%ebp)
  801fc9:	e8 b7 19 00 00       	call   803985 <alloc_block_WF>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd4:	eb 11                	jmp    801fe7 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	68 a4 44 80 00       	push   $0x8044a4
  801fde:	e8 60 e5 ff ff       	call   800543 <cprintf>
  801fe3:	83 c4 10             	add    $0x10,%esp
		break;
  801fe6:	90                   	nop
	}
	return va;
  801fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	53                   	push   %ebx
  801ff0:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ff3:	83 ec 0c             	sub    $0xc,%esp
  801ff6:	68 c4 44 80 00       	push   $0x8044c4
  801ffb:	e8 43 e5 ff ff       	call   800543 <cprintf>
  802000:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	68 ef 44 80 00       	push   $0x8044ef
  80200b:	e8 33 e5 ff ff       	call   800543 <cprintf>
  802010:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802019:	eb 37                	jmp    802052 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	ff 75 f4             	pushl  -0xc(%ebp)
  802021:	e8 19 ff ff ff       	call   801f3f <is_free_block>
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	0f be d8             	movsbl %al,%ebx
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	ff 75 f4             	pushl  -0xc(%ebp)
  802032:	e8 ef fe ff ff       	call   801f26 <get_block_size>
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	83 ec 04             	sub    $0x4,%esp
  80203d:	53                   	push   %ebx
  80203e:	50                   	push   %eax
  80203f:	68 07 45 80 00       	push   $0x804507
  802044:	e8 fa e4 ff ff       	call   800543 <cprintf>
  802049:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80204c:	8b 45 10             	mov    0x10(%ebp),%eax
  80204f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802052:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802056:	74 07                	je     80205f <print_blocks_list+0x73>
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	8b 00                	mov    (%eax),%eax
  80205d:	eb 05                	jmp    802064 <print_blocks_list+0x78>
  80205f:	b8 00 00 00 00       	mov    $0x0,%eax
  802064:	89 45 10             	mov    %eax,0x10(%ebp)
  802067:	8b 45 10             	mov    0x10(%ebp),%eax
  80206a:	85 c0                	test   %eax,%eax
  80206c:	75 ad                	jne    80201b <print_blocks_list+0x2f>
  80206e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802072:	75 a7                	jne    80201b <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802074:	83 ec 0c             	sub    $0xc,%esp
  802077:	68 c4 44 80 00       	push   $0x8044c4
  80207c:	e8 c2 e4 ff ff       	call   800543 <cprintf>
  802081:	83 c4 10             	add    $0x10,%esp

}
  802084:	90                   	nop
  802085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802090:	8b 45 0c             	mov    0xc(%ebp),%eax
  802093:	83 e0 01             	and    $0x1,%eax
  802096:	85 c0                	test   %eax,%eax
  802098:	74 03                	je     80209d <initialize_dynamic_allocator+0x13>
  80209a:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80209d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020a1:	0f 84 c7 01 00 00    	je     80226e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020a7:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8020ae:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b7:	01 d0                	add    %edx,%eax
  8020b9:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020be:	0f 87 ad 01 00 00    	ja     802271 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	0f 89 a5 01 00 00    	jns    802274 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d5:	01 d0                	add    %edx,%eax
  8020d7:	83 e8 04             	sub    $0x4,%eax
  8020da:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8020df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020e6:	a1 30 50 80 00       	mov    0x805030,%eax
  8020eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ee:	e9 87 00 00 00       	jmp    80217a <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f7:	75 14                	jne    80210d <initialize_dynamic_allocator+0x83>
  8020f9:	83 ec 04             	sub    $0x4,%esp
  8020fc:	68 1f 45 80 00       	push   $0x80451f
  802101:	6a 79                	push   $0x79
  802103:	68 3d 45 80 00       	push   $0x80453d
  802108:	e8 79 e1 ff ff       	call   800286 <_panic>
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 00                	mov    (%eax),%eax
  802112:	85 c0                	test   %eax,%eax
  802114:	74 10                	je     802126 <initialize_dynamic_allocator+0x9c>
  802116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802119:	8b 00                	mov    (%eax),%eax
  80211b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211e:	8b 52 04             	mov    0x4(%edx),%edx
  802121:	89 50 04             	mov    %edx,0x4(%eax)
  802124:	eb 0b                	jmp    802131 <initialize_dynamic_allocator+0xa7>
  802126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802129:	8b 40 04             	mov    0x4(%eax),%eax
  80212c:	a3 34 50 80 00       	mov    %eax,0x805034
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	8b 40 04             	mov    0x4(%eax),%eax
  802137:	85 c0                	test   %eax,%eax
  802139:	74 0f                	je     80214a <initialize_dynamic_allocator+0xc0>
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	8b 40 04             	mov    0x4(%eax),%eax
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	8b 12                	mov    (%edx),%edx
  802146:	89 10                	mov    %edx,(%eax)
  802148:	eb 0a                	jmp    802154 <initialize_dynamic_allocator+0xca>
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	8b 00                	mov    (%eax),%eax
  80214f:	a3 30 50 80 00       	mov    %eax,0x805030
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802160:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802167:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80216c:	48                   	dec    %eax
  80216d:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802172:	a1 38 50 80 00       	mov    0x805038,%eax
  802177:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217e:	74 07                	je     802187 <initialize_dynamic_allocator+0xfd>
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 00                	mov    (%eax),%eax
  802185:	eb 05                	jmp    80218c <initialize_dynamic_allocator+0x102>
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	a3 38 50 80 00       	mov    %eax,0x805038
  802191:	a1 38 50 80 00       	mov    0x805038,%eax
  802196:	85 c0                	test   %eax,%eax
  802198:	0f 85 55 ff ff ff    	jne    8020f3 <initialize_dynamic_allocator+0x69>
  80219e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a2:	0f 85 4b ff ff ff    	jne    8020f3 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021b7:	a1 48 50 80 00       	mov    0x805048,%eax
  8021bc:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8021c1:	a1 44 50 80 00       	mov    0x805044,%eax
  8021c6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	83 c0 08             	add    $0x8,%eax
  8021d2:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	83 c0 04             	add    $0x4,%eax
  8021db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021de:	83 ea 08             	sub    $0x8,%edx
  8021e1:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	01 d0                	add    %edx,%eax
  8021eb:	83 e8 08             	sub    $0x8,%eax
  8021ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f1:	83 ea 08             	sub    $0x8,%edx
  8021f4:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802202:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802209:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80220d:	75 17                	jne    802226 <initialize_dynamic_allocator+0x19c>
  80220f:	83 ec 04             	sub    $0x4,%esp
  802212:	68 58 45 80 00       	push   $0x804558
  802217:	68 90 00 00 00       	push   $0x90
  80221c:	68 3d 45 80 00       	push   $0x80453d
  802221:	e8 60 e0 ff ff       	call   800286 <_panic>
  802226:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80222c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222f:	89 10                	mov    %edx,(%eax)
  802231:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802234:	8b 00                	mov    (%eax),%eax
  802236:	85 c0                	test   %eax,%eax
  802238:	74 0d                	je     802247 <initialize_dynamic_allocator+0x1bd>
  80223a:	a1 30 50 80 00       	mov    0x805030,%eax
  80223f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802242:	89 50 04             	mov    %edx,0x4(%eax)
  802245:	eb 08                	jmp    80224f <initialize_dynamic_allocator+0x1c5>
  802247:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224a:	a3 34 50 80 00       	mov    %eax,0x805034
  80224f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802252:	a3 30 50 80 00       	mov    %eax,0x805030
  802257:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802261:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802266:	40                   	inc    %eax
  802267:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80226c:	eb 07                	jmp    802275 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80226e:	90                   	nop
  80226f:	eb 04                	jmp    802275 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802271:	90                   	nop
  802272:	eb 01                	jmp    802275 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802274:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80227a:	8b 45 10             	mov    0x10(%ebp),%eax
  80227d:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	8d 50 fc             	lea    -0x4(%eax),%edx
  802286:	8b 45 0c             	mov    0xc(%ebp),%eax
  802289:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	83 e8 04             	sub    $0x4,%eax
  802291:	8b 00                	mov    (%eax),%eax
  802293:	83 e0 fe             	and    $0xfffffffe,%eax
  802296:	8d 50 f8             	lea    -0x8(%eax),%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	01 c2                	add    %eax,%edx
  80229e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a1:	89 02                	mov    %eax,(%edx)
}
  8022a3:	90                   	nop
  8022a4:	5d                   	pop    %ebp
  8022a5:	c3                   	ret    

008022a6 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	83 e0 01             	and    $0x1,%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	74 03                	je     8022b9 <alloc_block_FF+0x13>
  8022b6:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022b9:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022bd:	77 07                	ja     8022c6 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022bf:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022c6:	a1 28 50 80 00       	mov    0x805028,%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	75 73                	jne    802342 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	83 c0 10             	add    $0x10,%eax
  8022d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022d8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e5:	01 d0                	add    %edx,%eax
  8022e7:	48                   	dec    %eax
  8022e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8022f3:	f7 75 ec             	divl   -0x14(%ebp)
  8022f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022f9:	29 d0                	sub    %edx,%eax
  8022fb:	c1 e8 0c             	shr    $0xc,%eax
  8022fe:	83 ec 0c             	sub    $0xc,%esp
  802301:	50                   	push   %eax
  802302:	e8 d6 ef ff ff       	call   8012dd <sbrk>
  802307:	83 c4 10             	add    $0x10,%esp
  80230a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80230d:	83 ec 0c             	sub    $0xc,%esp
  802310:	6a 00                	push   $0x0
  802312:	e8 c6 ef ff ff       	call   8012dd <sbrk>
  802317:	83 c4 10             	add    $0x10,%esp
  80231a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80231d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802320:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802323:	83 ec 08             	sub    $0x8,%esp
  802326:	50                   	push   %eax
  802327:	ff 75 e4             	pushl  -0x1c(%ebp)
  80232a:	e8 5b fd ff ff       	call   80208a <initialize_dynamic_allocator>
  80232f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802332:	83 ec 0c             	sub    $0xc,%esp
  802335:	68 7b 45 80 00       	push   $0x80457b
  80233a:	e8 04 e2 ff ff       	call   800543 <cprintf>
  80233f:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802342:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802346:	75 0a                	jne    802352 <alloc_block_FF+0xac>
	        return NULL;
  802348:	b8 00 00 00 00       	mov    $0x0,%eax
  80234d:	e9 0e 04 00 00       	jmp    802760 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802352:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802359:	a1 30 50 80 00       	mov    0x805030,%eax
  80235e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802361:	e9 f3 02 00 00       	jmp    802659 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80236c:	83 ec 0c             	sub    $0xc,%esp
  80236f:	ff 75 bc             	pushl  -0x44(%ebp)
  802372:	e8 af fb ff ff       	call   801f26 <get_block_size>
  802377:	83 c4 10             	add    $0x10,%esp
  80237a:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	83 c0 08             	add    $0x8,%eax
  802383:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802386:	0f 87 c5 02 00 00    	ja     802651 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	83 c0 18             	add    $0x18,%eax
  802392:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802395:	0f 87 19 02 00 00    	ja     8025b4 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80239b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80239e:	2b 45 08             	sub    0x8(%ebp),%eax
  8023a1:	83 e8 08             	sub    $0x8,%eax
  8023a4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023aa:	8d 50 08             	lea    0x8(%eax),%edx
  8023ad:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023b0:	01 d0                	add    %edx,%eax
  8023b2:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	83 c0 08             	add    $0x8,%eax
  8023bb:	83 ec 04             	sub    $0x4,%esp
  8023be:	6a 01                	push   $0x1
  8023c0:	50                   	push   %eax
  8023c1:	ff 75 bc             	pushl  -0x44(%ebp)
  8023c4:	e8 ae fe ff ff       	call   802277 <set_block_data>
  8023c9:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	8b 40 04             	mov    0x4(%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	75 68                	jne    80243e <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023d6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023da:	75 17                	jne    8023f3 <alloc_block_FF+0x14d>
  8023dc:	83 ec 04             	sub    $0x4,%esp
  8023df:	68 58 45 80 00       	push   $0x804558
  8023e4:	68 d7 00 00 00       	push   $0xd7
  8023e9:	68 3d 45 80 00       	push   $0x80453d
  8023ee:	e8 93 de ff ff       	call   800286 <_panic>
  8023f3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023fc:	89 10                	mov    %edx,(%eax)
  8023fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	85 c0                	test   %eax,%eax
  802405:	74 0d                	je     802414 <alloc_block_FF+0x16e>
  802407:	a1 30 50 80 00       	mov    0x805030,%eax
  80240c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80240f:	89 50 04             	mov    %edx,0x4(%eax)
  802412:	eb 08                	jmp    80241c <alloc_block_FF+0x176>
  802414:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802417:	a3 34 50 80 00       	mov    %eax,0x805034
  80241c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241f:	a3 30 50 80 00       	mov    %eax,0x805030
  802424:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802427:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80242e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802433:	40                   	inc    %eax
  802434:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802439:	e9 dc 00 00 00       	jmp    80251a <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 00                	mov    (%eax),%eax
  802443:	85 c0                	test   %eax,%eax
  802445:	75 65                	jne    8024ac <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802447:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80244b:	75 17                	jne    802464 <alloc_block_FF+0x1be>
  80244d:	83 ec 04             	sub    $0x4,%esp
  802450:	68 8c 45 80 00       	push   $0x80458c
  802455:	68 db 00 00 00       	push   $0xdb
  80245a:	68 3d 45 80 00       	push   $0x80453d
  80245f:	e8 22 de ff ff       	call   800286 <_panic>
  802464:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80246a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246d:	89 50 04             	mov    %edx,0x4(%eax)
  802470:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802473:	8b 40 04             	mov    0x4(%eax),%eax
  802476:	85 c0                	test   %eax,%eax
  802478:	74 0c                	je     802486 <alloc_block_FF+0x1e0>
  80247a:	a1 34 50 80 00       	mov    0x805034,%eax
  80247f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802482:	89 10                	mov    %edx,(%eax)
  802484:	eb 08                	jmp    80248e <alloc_block_FF+0x1e8>
  802486:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802489:	a3 30 50 80 00       	mov    %eax,0x805030
  80248e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802491:	a3 34 50 80 00       	mov    %eax,0x805034
  802496:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8024a4:	40                   	inc    %eax
  8024a5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8024aa:	eb 6e                	jmp    80251a <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b0:	74 06                	je     8024b8 <alloc_block_FF+0x212>
  8024b2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024b6:	75 17                	jne    8024cf <alloc_block_FF+0x229>
  8024b8:	83 ec 04             	sub    $0x4,%esp
  8024bb:	68 b0 45 80 00       	push   $0x8045b0
  8024c0:	68 df 00 00 00       	push   $0xdf
  8024c5:	68 3d 45 80 00       	push   $0x80453d
  8024ca:	e8 b7 dd ff ff       	call   800286 <_panic>
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 10                	mov    (%eax),%edx
  8024d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d7:	89 10                	mov    %edx,(%eax)
  8024d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024dc:	8b 00                	mov    (%eax),%eax
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	74 0b                	je     8024ed <alloc_block_FF+0x247>
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 00                	mov    (%eax),%eax
  8024e7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024ea:	89 50 04             	mov    %edx,0x4(%eax)
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024f3:	89 10                	mov    %edx,(%eax)
  8024f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fb:	89 50 04             	mov    %edx,0x4(%eax)
  8024fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802501:	8b 00                	mov    (%eax),%eax
  802503:	85 c0                	test   %eax,%eax
  802505:	75 08                	jne    80250f <alloc_block_FF+0x269>
  802507:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250a:	a3 34 50 80 00       	mov    %eax,0x805034
  80250f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802514:	40                   	inc    %eax
  802515:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80251a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251e:	75 17                	jne    802537 <alloc_block_FF+0x291>
  802520:	83 ec 04             	sub    $0x4,%esp
  802523:	68 1f 45 80 00       	push   $0x80451f
  802528:	68 e1 00 00 00       	push   $0xe1
  80252d:	68 3d 45 80 00       	push   $0x80453d
  802532:	e8 4f dd ff ff       	call   800286 <_panic>
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 00                	mov    (%eax),%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	74 10                	je     802550 <alloc_block_FF+0x2aa>
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 00                	mov    (%eax),%eax
  802545:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802548:	8b 52 04             	mov    0x4(%edx),%edx
  80254b:	89 50 04             	mov    %edx,0x4(%eax)
  80254e:	eb 0b                	jmp    80255b <alloc_block_FF+0x2b5>
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 40 04             	mov    0x4(%eax),%eax
  802556:	a3 34 50 80 00       	mov    %eax,0x805034
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 40 04             	mov    0x4(%eax),%eax
  802561:	85 c0                	test   %eax,%eax
  802563:	74 0f                	je     802574 <alloc_block_FF+0x2ce>
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	8b 40 04             	mov    0x4(%eax),%eax
  80256b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256e:	8b 12                	mov    (%edx),%edx
  802570:	89 10                	mov    %edx,(%eax)
  802572:	eb 0a                	jmp    80257e <alloc_block_FF+0x2d8>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	a3 30 50 80 00       	mov    %eax,0x805030
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802591:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802596:	48                   	dec    %eax
  802597:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  80259c:	83 ec 04             	sub    $0x4,%esp
  80259f:	6a 00                	push   $0x0
  8025a1:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025a4:	ff 75 b0             	pushl  -0x50(%ebp)
  8025a7:	e8 cb fc ff ff       	call   802277 <set_block_data>
  8025ac:	83 c4 10             	add    $0x10,%esp
  8025af:	e9 95 00 00 00       	jmp    802649 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025b4:	83 ec 04             	sub    $0x4,%esp
  8025b7:	6a 01                	push   $0x1
  8025b9:	ff 75 b8             	pushl  -0x48(%ebp)
  8025bc:	ff 75 bc             	pushl  -0x44(%ebp)
  8025bf:	e8 b3 fc ff ff       	call   802277 <set_block_data>
  8025c4:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cb:	75 17                	jne    8025e4 <alloc_block_FF+0x33e>
  8025cd:	83 ec 04             	sub    $0x4,%esp
  8025d0:	68 1f 45 80 00       	push   $0x80451f
  8025d5:	68 e8 00 00 00       	push   $0xe8
  8025da:	68 3d 45 80 00       	push   $0x80453d
  8025df:	e8 a2 dc ff ff       	call   800286 <_panic>
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 00                	mov    (%eax),%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	74 10                	je     8025fd <alloc_block_FF+0x357>
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 00                	mov    (%eax),%eax
  8025f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f5:	8b 52 04             	mov    0x4(%edx),%edx
  8025f8:	89 50 04             	mov    %edx,0x4(%eax)
  8025fb:	eb 0b                	jmp    802608 <alloc_block_FF+0x362>
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 40 04             	mov    0x4(%eax),%eax
  802603:	a3 34 50 80 00       	mov    %eax,0x805034
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 40 04             	mov    0x4(%eax),%eax
  80260e:	85 c0                	test   %eax,%eax
  802610:	74 0f                	je     802621 <alloc_block_FF+0x37b>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 40 04             	mov    0x4(%eax),%eax
  802618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261b:	8b 12                	mov    (%edx),%edx
  80261d:	89 10                	mov    %edx,(%eax)
  80261f:	eb 0a                	jmp    80262b <alloc_block_FF+0x385>
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	8b 00                	mov    (%eax),%eax
  802626:	a3 30 50 80 00       	mov    %eax,0x805030
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802643:	48                   	dec    %eax
  802644:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802649:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80264c:	e9 0f 01 00 00       	jmp    802760 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802651:	a1 38 50 80 00       	mov    0x805038,%eax
  802656:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802659:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265d:	74 07                	je     802666 <alloc_block_FF+0x3c0>
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	eb 05                	jmp    80266b <alloc_block_FF+0x3c5>
  802666:	b8 00 00 00 00       	mov    $0x0,%eax
  80266b:	a3 38 50 80 00       	mov    %eax,0x805038
  802670:	a1 38 50 80 00       	mov    0x805038,%eax
  802675:	85 c0                	test   %eax,%eax
  802677:	0f 85 e9 fc ff ff    	jne    802366 <alloc_block_FF+0xc0>
  80267d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802681:	0f 85 df fc ff ff    	jne    802366 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	83 c0 08             	add    $0x8,%eax
  80268d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802690:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802697:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80269a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80269d:	01 d0                	add    %edx,%eax
  80269f:	48                   	dec    %eax
  8026a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ab:	f7 75 d8             	divl   -0x28(%ebp)
  8026ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026b1:	29 d0                	sub    %edx,%eax
  8026b3:	c1 e8 0c             	shr    $0xc,%eax
  8026b6:	83 ec 0c             	sub    $0xc,%esp
  8026b9:	50                   	push   %eax
  8026ba:	e8 1e ec ff ff       	call   8012dd <sbrk>
  8026bf:	83 c4 10             	add    $0x10,%esp
  8026c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026c5:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026c9:	75 0a                	jne    8026d5 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d0:	e9 8b 00 00 00       	jmp    802760 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026d5:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026e2:	01 d0                	add    %edx,%eax
  8026e4:	48                   	dec    %eax
  8026e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f0:	f7 75 cc             	divl   -0x34(%ebp)
  8026f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026f6:	29 d0                	sub    %edx,%eax
  8026f8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026fe:	01 d0                	add    %edx,%eax
  802700:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802705:	a1 44 50 80 00       	mov    0x805044,%eax
  80270a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802710:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802717:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80271a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80271d:	01 d0                	add    %edx,%eax
  80271f:	48                   	dec    %eax
  802720:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802723:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802726:	ba 00 00 00 00       	mov    $0x0,%edx
  80272b:	f7 75 c4             	divl   -0x3c(%ebp)
  80272e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802731:	29 d0                	sub    %edx,%eax
  802733:	83 ec 04             	sub    $0x4,%esp
  802736:	6a 01                	push   $0x1
  802738:	50                   	push   %eax
  802739:	ff 75 d0             	pushl  -0x30(%ebp)
  80273c:	e8 36 fb ff ff       	call   802277 <set_block_data>
  802741:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802744:	83 ec 0c             	sub    $0xc,%esp
  802747:	ff 75 d0             	pushl  -0x30(%ebp)
  80274a:	e8 1b 0a 00 00       	call   80316a <free_block>
  80274f:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802752:	83 ec 0c             	sub    $0xc,%esp
  802755:	ff 75 08             	pushl  0x8(%ebp)
  802758:	e8 49 fb ff ff       	call   8022a6 <alloc_block_FF>
  80275d:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802760:	c9                   	leave  
  802761:	c3                   	ret    

00802762 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
  802765:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802768:	8b 45 08             	mov    0x8(%ebp),%eax
  80276b:	83 e0 01             	and    $0x1,%eax
  80276e:	85 c0                	test   %eax,%eax
  802770:	74 03                	je     802775 <alloc_block_BF+0x13>
  802772:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802775:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802779:	77 07                	ja     802782 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80277b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802782:	a1 28 50 80 00       	mov    0x805028,%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	75 73                	jne    8027fe <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80278b:	8b 45 08             	mov    0x8(%ebp),%eax
  80278e:	83 c0 10             	add    $0x10,%eax
  802791:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802794:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80279b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80279e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a1:	01 d0                	add    %edx,%eax
  8027a3:	48                   	dec    %eax
  8027a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8027af:	f7 75 e0             	divl   -0x20(%ebp)
  8027b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027b5:	29 d0                	sub    %edx,%eax
  8027b7:	c1 e8 0c             	shr    $0xc,%eax
  8027ba:	83 ec 0c             	sub    $0xc,%esp
  8027bd:	50                   	push   %eax
  8027be:	e8 1a eb ff ff       	call   8012dd <sbrk>
  8027c3:	83 c4 10             	add    $0x10,%esp
  8027c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027c9:	83 ec 0c             	sub    $0xc,%esp
  8027cc:	6a 00                	push   $0x0
  8027ce:	e8 0a eb ff ff       	call   8012dd <sbrk>
  8027d3:	83 c4 10             	add    $0x10,%esp
  8027d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027dc:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027df:	83 ec 08             	sub    $0x8,%esp
  8027e2:	50                   	push   %eax
  8027e3:	ff 75 d8             	pushl  -0x28(%ebp)
  8027e6:	e8 9f f8 ff ff       	call   80208a <initialize_dynamic_allocator>
  8027eb:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027ee:	83 ec 0c             	sub    $0xc,%esp
  8027f1:	68 7b 45 80 00       	push   $0x80457b
  8027f6:	e8 48 dd ff ff       	call   800543 <cprintf>
  8027fb:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802805:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80280c:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802813:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80281a:	a1 30 50 80 00       	mov    0x805030,%eax
  80281f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802822:	e9 1d 01 00 00       	jmp    802944 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80282d:	83 ec 0c             	sub    $0xc,%esp
  802830:	ff 75 a8             	pushl  -0x58(%ebp)
  802833:	e8 ee f6 ff ff       	call   801f26 <get_block_size>
  802838:	83 c4 10             	add    $0x10,%esp
  80283b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80283e:	8b 45 08             	mov    0x8(%ebp),%eax
  802841:	83 c0 08             	add    $0x8,%eax
  802844:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802847:	0f 87 ef 00 00 00    	ja     80293c <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80284d:	8b 45 08             	mov    0x8(%ebp),%eax
  802850:	83 c0 18             	add    $0x18,%eax
  802853:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802856:	77 1d                	ja     802875 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80285e:	0f 86 d8 00 00 00    	jbe    80293c <alloc_block_BF+0x1da>
				{
					best_va = va;
  802864:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802867:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80286a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80286d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802870:	e9 c7 00 00 00       	jmp    80293c <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	83 c0 08             	add    $0x8,%eax
  80287b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80287e:	0f 85 9d 00 00 00    	jne    802921 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802884:	83 ec 04             	sub    $0x4,%esp
  802887:	6a 01                	push   $0x1
  802889:	ff 75 a4             	pushl  -0x5c(%ebp)
  80288c:	ff 75 a8             	pushl  -0x58(%ebp)
  80288f:	e8 e3 f9 ff ff       	call   802277 <set_block_data>
  802894:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802897:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289b:	75 17                	jne    8028b4 <alloc_block_BF+0x152>
  80289d:	83 ec 04             	sub    $0x4,%esp
  8028a0:	68 1f 45 80 00       	push   $0x80451f
  8028a5:	68 2c 01 00 00       	push   $0x12c
  8028aa:	68 3d 45 80 00       	push   $0x80453d
  8028af:	e8 d2 d9 ff ff       	call   800286 <_panic>
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	74 10                	je     8028cd <alloc_block_BF+0x16b>
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 00                	mov    (%eax),%eax
  8028c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c5:	8b 52 04             	mov    0x4(%edx),%edx
  8028c8:	89 50 04             	mov    %edx,0x4(%eax)
  8028cb:	eb 0b                	jmp    8028d8 <alloc_block_BF+0x176>
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 40 04             	mov    0x4(%eax),%eax
  8028d3:	a3 34 50 80 00       	mov    %eax,0x805034
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 40 04             	mov    0x4(%eax),%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	74 0f                	je     8028f1 <alloc_block_BF+0x18f>
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	8b 40 04             	mov    0x4(%eax),%eax
  8028e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028eb:	8b 12                	mov    (%edx),%edx
  8028ed:	89 10                	mov    %edx,(%eax)
  8028ef:	eb 0a                	jmp    8028fb <alloc_block_BF+0x199>
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	a3 30 50 80 00       	mov    %eax,0x805030
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80290e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802913:	48                   	dec    %eax
  802914:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802919:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80291c:	e9 24 04 00 00       	jmp    802d45 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802927:	76 13                	jbe    80293c <alloc_block_BF+0x1da>
					{
						internal = 1;
  802929:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802930:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802933:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802936:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802939:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80293c:	a1 38 50 80 00       	mov    0x805038,%eax
  802941:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802944:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802948:	74 07                	je     802951 <alloc_block_BF+0x1ef>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	eb 05                	jmp    802956 <alloc_block_BF+0x1f4>
  802951:	b8 00 00 00 00       	mov    $0x0,%eax
  802956:	a3 38 50 80 00       	mov    %eax,0x805038
  80295b:	a1 38 50 80 00       	mov    0x805038,%eax
  802960:	85 c0                	test   %eax,%eax
  802962:	0f 85 bf fe ff ff    	jne    802827 <alloc_block_BF+0xc5>
  802968:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296c:	0f 85 b5 fe ff ff    	jne    802827 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802972:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802976:	0f 84 26 02 00 00    	je     802ba2 <alloc_block_BF+0x440>
  80297c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802980:	0f 85 1c 02 00 00    	jne    802ba2 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802986:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802989:	2b 45 08             	sub    0x8(%ebp),%eax
  80298c:	83 e8 08             	sub    $0x8,%eax
  80298f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	8d 50 08             	lea    0x8(%eax),%edx
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	01 d0                	add    %edx,%eax
  80299d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	83 c0 08             	add    $0x8,%eax
  8029a6:	83 ec 04             	sub    $0x4,%esp
  8029a9:	6a 01                	push   $0x1
  8029ab:	50                   	push   %eax
  8029ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8029af:	e8 c3 f8 ff ff       	call   802277 <set_block_data>
  8029b4:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ba:	8b 40 04             	mov    0x4(%eax),%eax
  8029bd:	85 c0                	test   %eax,%eax
  8029bf:	75 68                	jne    802a29 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029c1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029c5:	75 17                	jne    8029de <alloc_block_BF+0x27c>
  8029c7:	83 ec 04             	sub    $0x4,%esp
  8029ca:	68 58 45 80 00       	push   $0x804558
  8029cf:	68 45 01 00 00       	push   $0x145
  8029d4:	68 3d 45 80 00       	push   $0x80453d
  8029d9:	e8 a8 d8 ff ff       	call   800286 <_panic>
  8029de:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e7:	89 10                	mov    %edx,(%eax)
  8029e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ec:	8b 00                	mov    (%eax),%eax
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	74 0d                	je     8029ff <alloc_block_BF+0x29d>
  8029f2:	a1 30 50 80 00       	mov    0x805030,%eax
  8029f7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029fa:	89 50 04             	mov    %edx,0x4(%eax)
  8029fd:	eb 08                	jmp    802a07 <alloc_block_BF+0x2a5>
  8029ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a02:	a3 34 50 80 00       	mov    %eax,0x805034
  802a07:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a19:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a1e:	40                   	inc    %eax
  802a1f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a24:	e9 dc 00 00 00       	jmp    802b05 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	75 65                	jne    802a97 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a32:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a36:	75 17                	jne    802a4f <alloc_block_BF+0x2ed>
  802a38:	83 ec 04             	sub    $0x4,%esp
  802a3b:	68 8c 45 80 00       	push   $0x80458c
  802a40:	68 4a 01 00 00       	push   $0x14a
  802a45:	68 3d 45 80 00       	push   $0x80453d
  802a4a:	e8 37 d8 ff ff       	call   800286 <_panic>
  802a4f:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a58:	89 50 04             	mov    %edx,0x4(%eax)
  802a5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a5e:	8b 40 04             	mov    0x4(%eax),%eax
  802a61:	85 c0                	test   %eax,%eax
  802a63:	74 0c                	je     802a71 <alloc_block_BF+0x30f>
  802a65:	a1 34 50 80 00       	mov    0x805034,%eax
  802a6a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a6d:	89 10                	mov    %edx,(%eax)
  802a6f:	eb 08                	jmp    802a79 <alloc_block_BF+0x317>
  802a71:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a74:	a3 30 50 80 00       	mov    %eax,0x805030
  802a79:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7c:	a3 34 50 80 00       	mov    %eax,0x805034
  802a81:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a8f:	40                   	inc    %eax
  802a90:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a95:	eb 6e                	jmp    802b05 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a9b:	74 06                	je     802aa3 <alloc_block_BF+0x341>
  802a9d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802aa1:	75 17                	jne    802aba <alloc_block_BF+0x358>
  802aa3:	83 ec 04             	sub    $0x4,%esp
  802aa6:	68 b0 45 80 00       	push   $0x8045b0
  802aab:	68 4f 01 00 00       	push   $0x14f
  802ab0:	68 3d 45 80 00       	push   $0x80453d
  802ab5:	e8 cc d7 ff ff       	call   800286 <_panic>
  802aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abd:	8b 10                	mov    (%eax),%edx
  802abf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac2:	89 10                	mov    %edx,(%eax)
  802ac4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac7:	8b 00                	mov    (%eax),%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	74 0b                	je     802ad8 <alloc_block_BF+0x376>
  802acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ad5:	89 50 04             	mov    %edx,0x4(%eax)
  802ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ade:	89 10                	mov    %edx,(%eax)
  802ae0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae6:	89 50 04             	mov    %edx,0x4(%eax)
  802ae9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	85 c0                	test   %eax,%eax
  802af0:	75 08                	jne    802afa <alloc_block_BF+0x398>
  802af2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af5:	a3 34 50 80 00       	mov    %eax,0x805034
  802afa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802aff:	40                   	inc    %eax
  802b00:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b09:	75 17                	jne    802b22 <alloc_block_BF+0x3c0>
  802b0b:	83 ec 04             	sub    $0x4,%esp
  802b0e:	68 1f 45 80 00       	push   $0x80451f
  802b13:	68 51 01 00 00       	push   $0x151
  802b18:	68 3d 45 80 00       	push   $0x80453d
  802b1d:	e8 64 d7 ff ff       	call   800286 <_panic>
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	74 10                	je     802b3b <alloc_block_BF+0x3d9>
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b33:	8b 52 04             	mov    0x4(%edx),%edx
  802b36:	89 50 04             	mov    %edx,0x4(%eax)
  802b39:	eb 0b                	jmp    802b46 <alloc_block_BF+0x3e4>
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	8b 40 04             	mov    0x4(%eax),%eax
  802b41:	a3 34 50 80 00       	mov    %eax,0x805034
  802b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b49:	8b 40 04             	mov    0x4(%eax),%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	74 0f                	je     802b5f <alloc_block_BF+0x3fd>
  802b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b53:	8b 40 04             	mov    0x4(%eax),%eax
  802b56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b59:	8b 12                	mov    (%edx),%edx
  802b5b:	89 10                	mov    %edx,(%eax)
  802b5d:	eb 0a                	jmp    802b69 <alloc_block_BF+0x407>
  802b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	a3 30 50 80 00       	mov    %eax,0x805030
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b81:	48                   	dec    %eax
  802b82:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802b87:	83 ec 04             	sub    $0x4,%esp
  802b8a:	6a 00                	push   $0x0
  802b8c:	ff 75 d0             	pushl  -0x30(%ebp)
  802b8f:	ff 75 cc             	pushl  -0x34(%ebp)
  802b92:	e8 e0 f6 ff ff       	call   802277 <set_block_data>
  802b97:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9d:	e9 a3 01 00 00       	jmp    802d45 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802ba2:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802ba6:	0f 85 9d 00 00 00    	jne    802c49 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bac:	83 ec 04             	sub    $0x4,%esp
  802baf:	6a 01                	push   $0x1
  802bb1:	ff 75 ec             	pushl  -0x14(%ebp)
  802bb4:	ff 75 f0             	pushl  -0x10(%ebp)
  802bb7:	e8 bb f6 ff ff       	call   802277 <set_block_data>
  802bbc:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bc3:	75 17                	jne    802bdc <alloc_block_BF+0x47a>
  802bc5:	83 ec 04             	sub    $0x4,%esp
  802bc8:	68 1f 45 80 00       	push   $0x80451f
  802bcd:	68 58 01 00 00       	push   $0x158
  802bd2:	68 3d 45 80 00       	push   $0x80453d
  802bd7:	e8 aa d6 ff ff       	call   800286 <_panic>
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	74 10                	je     802bf5 <alloc_block_BF+0x493>
  802be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be8:	8b 00                	mov    (%eax),%eax
  802bea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bed:	8b 52 04             	mov    0x4(%edx),%edx
  802bf0:	89 50 04             	mov    %edx,0x4(%eax)
  802bf3:	eb 0b                	jmp    802c00 <alloc_block_BF+0x49e>
  802bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	a3 34 50 80 00       	mov    %eax,0x805034
  802c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	85 c0                	test   %eax,%eax
  802c08:	74 0f                	je     802c19 <alloc_block_BF+0x4b7>
  802c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0d:	8b 40 04             	mov    0x4(%eax),%eax
  802c10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c13:	8b 12                	mov    (%edx),%edx
  802c15:	89 10                	mov    %edx,(%eax)
  802c17:	eb 0a                	jmp    802c23 <alloc_block_BF+0x4c1>
  802c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	a3 30 50 80 00       	mov    %eax,0x805030
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c36:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c3b:	48                   	dec    %eax
  802c3c:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c44:	e9 fc 00 00 00       	jmp    802d45 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c49:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4c:	83 c0 08             	add    $0x8,%eax
  802c4f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c52:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c59:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c5c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c5f:	01 d0                	add    %edx,%eax
  802c61:	48                   	dec    %eax
  802c62:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c65:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c68:	ba 00 00 00 00       	mov    $0x0,%edx
  802c6d:	f7 75 c4             	divl   -0x3c(%ebp)
  802c70:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c73:	29 d0                	sub    %edx,%eax
  802c75:	c1 e8 0c             	shr    $0xc,%eax
  802c78:	83 ec 0c             	sub    $0xc,%esp
  802c7b:	50                   	push   %eax
  802c7c:	e8 5c e6 ff ff       	call   8012dd <sbrk>
  802c81:	83 c4 10             	add    $0x10,%esp
  802c84:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c87:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c8b:	75 0a                	jne    802c97 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c92:	e9 ae 00 00 00       	jmp    802d45 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c97:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c9e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ca1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ca4:	01 d0                	add    %edx,%eax
  802ca6:	48                   	dec    %eax
  802ca7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802caa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cad:	ba 00 00 00 00       	mov    $0x0,%edx
  802cb2:	f7 75 b8             	divl   -0x48(%ebp)
  802cb5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cb8:	29 d0                	sub    %edx,%eax
  802cba:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cbd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cc0:	01 d0                	add    %edx,%eax
  802cc2:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802cc7:	a1 44 50 80 00       	mov    0x805044,%eax
  802ccc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802cd2:	83 ec 0c             	sub    $0xc,%esp
  802cd5:	68 e4 45 80 00       	push   $0x8045e4
  802cda:	e8 64 d8 ff ff       	call   800543 <cprintf>
  802cdf:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802ce2:	83 ec 08             	sub    $0x8,%esp
  802ce5:	ff 75 bc             	pushl  -0x44(%ebp)
  802ce8:	68 e9 45 80 00       	push   $0x8045e9
  802ced:	e8 51 d8 ff ff       	call   800543 <cprintf>
  802cf2:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cf5:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cfc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d02:	01 d0                	add    %edx,%eax
  802d04:	48                   	dec    %eax
  802d05:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d08:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d10:	f7 75 b0             	divl   -0x50(%ebp)
  802d13:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d16:	29 d0                	sub    %edx,%eax
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	6a 01                	push   $0x1
  802d1d:	50                   	push   %eax
  802d1e:	ff 75 bc             	pushl  -0x44(%ebp)
  802d21:	e8 51 f5 ff ff       	call   802277 <set_block_data>
  802d26:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d29:	83 ec 0c             	sub    $0xc,%esp
  802d2c:	ff 75 bc             	pushl  -0x44(%ebp)
  802d2f:	e8 36 04 00 00       	call   80316a <free_block>
  802d34:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d37:	83 ec 0c             	sub    $0xc,%esp
  802d3a:	ff 75 08             	pushl  0x8(%ebp)
  802d3d:	e8 20 fa ff ff       	call   802762 <alloc_block_BF>
  802d42:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d45:	c9                   	leave  
  802d46:	c3                   	ret    

00802d47 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d47:	55                   	push   %ebp
  802d48:	89 e5                	mov    %esp,%ebp
  802d4a:	53                   	push   %ebx
  802d4b:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d60:	74 1e                	je     802d80 <merging+0x39>
  802d62:	ff 75 08             	pushl  0x8(%ebp)
  802d65:	e8 bc f1 ff ff       	call   801f26 <get_block_size>
  802d6a:	83 c4 04             	add    $0x4,%esp
  802d6d:	89 c2                	mov    %eax,%edx
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	01 d0                	add    %edx,%eax
  802d74:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d77:	75 07                	jne    802d80 <merging+0x39>
		prev_is_free = 1;
  802d79:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d84:	74 1e                	je     802da4 <merging+0x5d>
  802d86:	ff 75 10             	pushl  0x10(%ebp)
  802d89:	e8 98 f1 ff ff       	call   801f26 <get_block_size>
  802d8e:	83 c4 04             	add    $0x4,%esp
  802d91:	89 c2                	mov    %eax,%edx
  802d93:	8b 45 10             	mov    0x10(%ebp),%eax
  802d96:	01 d0                	add    %edx,%eax
  802d98:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d9b:	75 07                	jne    802da4 <merging+0x5d>
		next_is_free = 1;
  802d9d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802da4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da8:	0f 84 cc 00 00 00    	je     802e7a <merging+0x133>
  802dae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db2:	0f 84 c2 00 00 00    	je     802e7a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802db8:	ff 75 08             	pushl  0x8(%ebp)
  802dbb:	e8 66 f1 ff ff       	call   801f26 <get_block_size>
  802dc0:	83 c4 04             	add    $0x4,%esp
  802dc3:	89 c3                	mov    %eax,%ebx
  802dc5:	ff 75 10             	pushl  0x10(%ebp)
  802dc8:	e8 59 f1 ff ff       	call   801f26 <get_block_size>
  802dcd:	83 c4 04             	add    $0x4,%esp
  802dd0:	01 c3                	add    %eax,%ebx
  802dd2:	ff 75 0c             	pushl  0xc(%ebp)
  802dd5:	e8 4c f1 ff ff       	call   801f26 <get_block_size>
  802dda:	83 c4 04             	add    $0x4,%esp
  802ddd:	01 d8                	add    %ebx,%eax
  802ddf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802de2:	6a 00                	push   $0x0
  802de4:	ff 75 ec             	pushl  -0x14(%ebp)
  802de7:	ff 75 08             	pushl  0x8(%ebp)
  802dea:	e8 88 f4 ff ff       	call   802277 <set_block_data>
  802def:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802df2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802df6:	75 17                	jne    802e0f <merging+0xc8>
  802df8:	83 ec 04             	sub    $0x4,%esp
  802dfb:	68 1f 45 80 00       	push   $0x80451f
  802e00:	68 7d 01 00 00       	push   $0x17d
  802e05:	68 3d 45 80 00       	push   $0x80453d
  802e0a:	e8 77 d4 ff ff       	call   800286 <_panic>
  802e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e12:	8b 00                	mov    (%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 10                	je     802e28 <merging+0xe1>
  802e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e20:	8b 52 04             	mov    0x4(%edx),%edx
  802e23:	89 50 04             	mov    %edx,0x4(%eax)
  802e26:	eb 0b                	jmp    802e33 <merging+0xec>
  802e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2b:	8b 40 04             	mov    0x4(%eax),%eax
  802e2e:	a3 34 50 80 00       	mov    %eax,0x805034
  802e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e36:	8b 40 04             	mov    0x4(%eax),%eax
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	74 0f                	je     802e4c <merging+0x105>
  802e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e40:	8b 40 04             	mov    0x4(%eax),%eax
  802e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e46:	8b 12                	mov    (%edx),%edx
  802e48:	89 10                	mov    %edx,(%eax)
  802e4a:	eb 0a                	jmp    802e56 <merging+0x10f>
  802e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4f:	8b 00                	mov    (%eax),%eax
  802e51:	a3 30 50 80 00       	mov    %eax,0x805030
  802e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e69:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e6e:	48                   	dec    %eax
  802e6f:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e74:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e75:	e9 ea 02 00 00       	jmp    803164 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7e:	74 3b                	je     802ebb <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e80:	83 ec 0c             	sub    $0xc,%esp
  802e83:	ff 75 08             	pushl  0x8(%ebp)
  802e86:	e8 9b f0 ff ff       	call   801f26 <get_block_size>
  802e8b:	83 c4 10             	add    $0x10,%esp
  802e8e:	89 c3                	mov    %eax,%ebx
  802e90:	83 ec 0c             	sub    $0xc,%esp
  802e93:	ff 75 10             	pushl  0x10(%ebp)
  802e96:	e8 8b f0 ff ff       	call   801f26 <get_block_size>
  802e9b:	83 c4 10             	add    $0x10,%esp
  802e9e:	01 d8                	add    %ebx,%eax
  802ea0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ea3:	83 ec 04             	sub    $0x4,%esp
  802ea6:	6a 00                	push   $0x0
  802ea8:	ff 75 e8             	pushl  -0x18(%ebp)
  802eab:	ff 75 08             	pushl  0x8(%ebp)
  802eae:	e8 c4 f3 ff ff       	call   802277 <set_block_data>
  802eb3:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eb6:	e9 a9 02 00 00       	jmp    803164 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ebb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ebf:	0f 84 2d 01 00 00    	je     802ff2 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ec5:	83 ec 0c             	sub    $0xc,%esp
  802ec8:	ff 75 10             	pushl  0x10(%ebp)
  802ecb:	e8 56 f0 ff ff       	call   801f26 <get_block_size>
  802ed0:	83 c4 10             	add    $0x10,%esp
  802ed3:	89 c3                	mov    %eax,%ebx
  802ed5:	83 ec 0c             	sub    $0xc,%esp
  802ed8:	ff 75 0c             	pushl  0xc(%ebp)
  802edb:	e8 46 f0 ff ff       	call   801f26 <get_block_size>
  802ee0:	83 c4 10             	add    $0x10,%esp
  802ee3:	01 d8                	add    %ebx,%eax
  802ee5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ee8:	83 ec 04             	sub    $0x4,%esp
  802eeb:	6a 00                	push   $0x0
  802eed:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ef0:	ff 75 10             	pushl  0x10(%ebp)
  802ef3:	e8 7f f3 ff ff       	call   802277 <set_block_data>
  802ef8:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802efb:	8b 45 10             	mov    0x10(%ebp),%eax
  802efe:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f05:	74 06                	je     802f0d <merging+0x1c6>
  802f07:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f0b:	75 17                	jne    802f24 <merging+0x1dd>
  802f0d:	83 ec 04             	sub    $0x4,%esp
  802f10:	68 f8 45 80 00       	push   $0x8045f8
  802f15:	68 8d 01 00 00       	push   $0x18d
  802f1a:	68 3d 45 80 00       	push   $0x80453d
  802f1f:	e8 62 d3 ff ff       	call   800286 <_panic>
  802f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f27:	8b 50 04             	mov    0x4(%eax),%edx
  802f2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2d:	89 50 04             	mov    %edx,0x4(%eax)
  802f30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	74 0d                	je     802f4f <merging+0x208>
  802f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f45:	8b 40 04             	mov    0x4(%eax),%eax
  802f48:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f4b:	89 10                	mov    %edx,(%eax)
  802f4d:	eb 08                	jmp    802f57 <merging+0x210>
  802f4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f52:	a3 30 50 80 00       	mov    %eax,0x805030
  802f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f5d:	89 50 04             	mov    %edx,0x4(%eax)
  802f60:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f65:	40                   	inc    %eax
  802f66:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  802f6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f6f:	75 17                	jne    802f88 <merging+0x241>
  802f71:	83 ec 04             	sub    $0x4,%esp
  802f74:	68 1f 45 80 00       	push   $0x80451f
  802f79:	68 8e 01 00 00       	push   $0x18e
  802f7e:	68 3d 45 80 00       	push   $0x80453d
  802f83:	e8 fe d2 ff ff       	call   800286 <_panic>
  802f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	74 10                	je     802fa1 <merging+0x25a>
  802f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f99:	8b 52 04             	mov    0x4(%edx),%edx
  802f9c:	89 50 04             	mov    %edx,0x4(%eax)
  802f9f:	eb 0b                	jmp    802fac <merging+0x265>
  802fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	a3 34 50 80 00       	mov    %eax,0x805034
  802fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	74 0f                	je     802fc5 <merging+0x27e>
  802fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb9:	8b 40 04             	mov    0x4(%eax),%eax
  802fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbf:	8b 12                	mov    (%edx),%edx
  802fc1:	89 10                	mov    %edx,(%eax)
  802fc3:	eb 0a                	jmp    802fcf <merging+0x288>
  802fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc8:	8b 00                	mov    (%eax),%eax
  802fca:	a3 30 50 80 00       	mov    %eax,0x805030
  802fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fe7:	48                   	dec    %eax
  802fe8:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fed:	e9 72 01 00 00       	jmp    803164 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  802ff5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ff8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ffc:	74 79                	je     803077 <merging+0x330>
  802ffe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803002:	74 73                	je     803077 <merging+0x330>
  803004:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803008:	74 06                	je     803010 <merging+0x2c9>
  80300a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80300e:	75 17                	jne    803027 <merging+0x2e0>
  803010:	83 ec 04             	sub    $0x4,%esp
  803013:	68 b0 45 80 00       	push   $0x8045b0
  803018:	68 94 01 00 00       	push   $0x194
  80301d:	68 3d 45 80 00       	push   $0x80453d
  803022:	e8 5f d2 ff ff       	call   800286 <_panic>
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	8b 10                	mov    (%eax),%edx
  80302c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302f:	89 10                	mov    %edx,(%eax)
  803031:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	74 0b                	je     803045 <merging+0x2fe>
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	8b 00                	mov    (%eax),%eax
  80303f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803042:	89 50 04             	mov    %edx,0x4(%eax)
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80304b:	89 10                	mov    %edx,(%eax)
  80304d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803050:	8b 55 08             	mov    0x8(%ebp),%edx
  803053:	89 50 04             	mov    %edx,0x4(%eax)
  803056:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803059:	8b 00                	mov    (%eax),%eax
  80305b:	85 c0                	test   %eax,%eax
  80305d:	75 08                	jne    803067 <merging+0x320>
  80305f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803062:	a3 34 50 80 00       	mov    %eax,0x805034
  803067:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80306c:	40                   	inc    %eax
  80306d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803072:	e9 ce 00 00 00       	jmp    803145 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803077:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307b:	74 65                	je     8030e2 <merging+0x39b>
  80307d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803081:	75 17                	jne    80309a <merging+0x353>
  803083:	83 ec 04             	sub    $0x4,%esp
  803086:	68 8c 45 80 00       	push   $0x80458c
  80308b:	68 95 01 00 00       	push   $0x195
  803090:	68 3d 45 80 00       	push   $0x80453d
  803095:	e8 ec d1 ff ff       	call   800286 <_panic>
  80309a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8030a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a3:	89 50 04             	mov    %edx,0x4(%eax)
  8030a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a9:	8b 40 04             	mov    0x4(%eax),%eax
  8030ac:	85 c0                	test   %eax,%eax
  8030ae:	74 0c                	je     8030bc <merging+0x375>
  8030b0:	a1 34 50 80 00       	mov    0x805034,%eax
  8030b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030b8:	89 10                	mov    %edx,(%eax)
  8030ba:	eb 08                	jmp    8030c4 <merging+0x37d>
  8030bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c7:	a3 34 50 80 00       	mov    %eax,0x805034
  8030cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030da:	40                   	inc    %eax
  8030db:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8030e0:	eb 63                	jmp    803145 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030e6:	75 17                	jne    8030ff <merging+0x3b8>
  8030e8:	83 ec 04             	sub    $0x4,%esp
  8030eb:	68 58 45 80 00       	push   $0x804558
  8030f0:	68 98 01 00 00       	push   $0x198
  8030f5:	68 3d 45 80 00       	push   $0x80453d
  8030fa:	e8 87 d1 ff ff       	call   800286 <_panic>
  8030ff:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803105:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803108:	89 10                	mov    %edx,(%eax)
  80310a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310d:	8b 00                	mov    (%eax),%eax
  80310f:	85 c0                	test   %eax,%eax
  803111:	74 0d                	je     803120 <merging+0x3d9>
  803113:	a1 30 50 80 00       	mov    0x805030,%eax
  803118:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80311b:	89 50 04             	mov    %edx,0x4(%eax)
  80311e:	eb 08                	jmp    803128 <merging+0x3e1>
  803120:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803123:	a3 34 50 80 00       	mov    %eax,0x805034
  803128:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312b:	a3 30 50 80 00       	mov    %eax,0x805030
  803130:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803133:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80313f:	40                   	inc    %eax
  803140:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803145:	83 ec 0c             	sub    $0xc,%esp
  803148:	ff 75 10             	pushl  0x10(%ebp)
  80314b:	e8 d6 ed ff ff       	call   801f26 <get_block_size>
  803150:	83 c4 10             	add    $0x10,%esp
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	6a 00                	push   $0x0
  803158:	50                   	push   %eax
  803159:	ff 75 10             	pushl  0x10(%ebp)
  80315c:	e8 16 f1 ff ff       	call   802277 <set_block_data>
  803161:	83 c4 10             	add    $0x10,%esp
	}
}
  803164:	90                   	nop
  803165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803168:	c9                   	leave  
  803169:	c3                   	ret    

0080316a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80316a:	55                   	push   %ebp
  80316b:	89 e5                	mov    %esp,%ebp
  80316d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803170:	a1 30 50 80 00       	mov    0x805030,%eax
  803175:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803178:	a1 34 50 80 00       	mov    0x805034,%eax
  80317d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803180:	73 1b                	jae    80319d <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803182:	a1 34 50 80 00       	mov    0x805034,%eax
  803187:	83 ec 04             	sub    $0x4,%esp
  80318a:	ff 75 08             	pushl  0x8(%ebp)
  80318d:	6a 00                	push   $0x0
  80318f:	50                   	push   %eax
  803190:	e8 b2 fb ff ff       	call   802d47 <merging>
  803195:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803198:	e9 8b 00 00 00       	jmp    803228 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80319d:	a1 30 50 80 00       	mov    0x805030,%eax
  8031a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a5:	76 18                	jbe    8031bf <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031a7:	a1 30 50 80 00       	mov    0x805030,%eax
  8031ac:	83 ec 04             	sub    $0x4,%esp
  8031af:	ff 75 08             	pushl  0x8(%ebp)
  8031b2:	50                   	push   %eax
  8031b3:	6a 00                	push   $0x0
  8031b5:	e8 8d fb ff ff       	call   802d47 <merging>
  8031ba:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031bd:	eb 69                	jmp    803228 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031bf:	a1 30 50 80 00       	mov    0x805030,%eax
  8031c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c7:	eb 39                	jmp    803202 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031cf:	73 29                	jae    8031fa <free_block+0x90>
  8031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d4:	8b 00                	mov    (%eax),%eax
  8031d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d9:	76 1f                	jbe    8031fa <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031de:	8b 00                	mov    (%eax),%eax
  8031e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031e3:	83 ec 04             	sub    $0x4,%esp
  8031e6:	ff 75 08             	pushl  0x8(%ebp)
  8031e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8031ef:	e8 53 fb ff ff       	call   802d47 <merging>
  8031f4:	83 c4 10             	add    $0x10,%esp
			break;
  8031f7:	90                   	nop
		}
	}
}
  8031f8:	eb 2e                	jmp    803228 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8031ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803202:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803206:	74 07                	je     80320f <free_block+0xa5>
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	8b 00                	mov    (%eax),%eax
  80320d:	eb 05                	jmp    803214 <free_block+0xaa>
  80320f:	b8 00 00 00 00       	mov    $0x0,%eax
  803214:	a3 38 50 80 00       	mov    %eax,0x805038
  803219:	a1 38 50 80 00       	mov    0x805038,%eax
  80321e:	85 c0                	test   %eax,%eax
  803220:	75 a7                	jne    8031c9 <free_block+0x5f>
  803222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803226:	75 a1                	jne    8031c9 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803228:	90                   	nop
  803229:	c9                   	leave  
  80322a:	c3                   	ret    

0080322b <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80322b:	55                   	push   %ebp
  80322c:	89 e5                	mov    %esp,%ebp
  80322e:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803231:	ff 75 08             	pushl  0x8(%ebp)
  803234:	e8 ed ec ff ff       	call   801f26 <get_block_size>
  803239:	83 c4 04             	add    $0x4,%esp
  80323c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80323f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803246:	eb 17                	jmp    80325f <copy_data+0x34>
  803248:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80324b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80324e:	01 c2                	add    %eax,%edx
  803250:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	01 c8                	add    %ecx,%eax
  803258:	8a 00                	mov    (%eax),%al
  80325a:	88 02                	mov    %al,(%edx)
  80325c:	ff 45 fc             	incl   -0x4(%ebp)
  80325f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803262:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803265:	72 e1                	jb     803248 <copy_data+0x1d>
}
  803267:	90                   	nop
  803268:	c9                   	leave  
  803269:	c3                   	ret    

0080326a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80326a:	55                   	push   %ebp
  80326b:	89 e5                	mov    %esp,%ebp
  80326d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803270:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803274:	75 23                	jne    803299 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803276:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80327a:	74 13                	je     80328f <realloc_block_FF+0x25>
  80327c:	83 ec 0c             	sub    $0xc,%esp
  80327f:	ff 75 0c             	pushl  0xc(%ebp)
  803282:	e8 1f f0 ff ff       	call   8022a6 <alloc_block_FF>
  803287:	83 c4 10             	add    $0x10,%esp
  80328a:	e9 f4 06 00 00       	jmp    803983 <realloc_block_FF+0x719>
		return NULL;
  80328f:	b8 00 00 00 00       	mov    $0x0,%eax
  803294:	e9 ea 06 00 00       	jmp    803983 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803299:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80329d:	75 18                	jne    8032b7 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80329f:	83 ec 0c             	sub    $0xc,%esp
  8032a2:	ff 75 08             	pushl  0x8(%ebp)
  8032a5:	e8 c0 fe ff ff       	call   80316a <free_block>
  8032aa:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b2:	e9 cc 06 00 00       	jmp    803983 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032b7:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032bb:	77 07                	ja     8032c4 <realloc_block_FF+0x5a>
  8032bd:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c7:	83 e0 01             	and    $0x1,%eax
  8032ca:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d0:	83 c0 08             	add    $0x8,%eax
  8032d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032d6:	83 ec 0c             	sub    $0xc,%esp
  8032d9:	ff 75 08             	pushl  0x8(%ebp)
  8032dc:	e8 45 ec ff ff       	call   801f26 <get_block_size>
  8032e1:	83 c4 10             	add    $0x10,%esp
  8032e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ea:	83 e8 08             	sub    $0x8,%eax
  8032ed:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	83 e8 04             	sub    $0x4,%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	83 e0 fe             	and    $0xfffffffe,%eax
  8032fb:	89 c2                	mov    %eax,%edx
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	01 d0                	add    %edx,%eax
  803302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803305:	83 ec 0c             	sub    $0xc,%esp
  803308:	ff 75 e4             	pushl  -0x1c(%ebp)
  80330b:	e8 16 ec ff ff       	call   801f26 <get_block_size>
  803310:	83 c4 10             	add    $0x10,%esp
  803313:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803316:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803319:	83 e8 08             	sub    $0x8,%eax
  80331c:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80331f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803322:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803325:	75 08                	jne    80332f <realloc_block_FF+0xc5>
	{
		 return va;
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	e9 54 06 00 00       	jmp    803983 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80332f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803332:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803335:	0f 83 e5 03 00 00    	jae    803720 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80333b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333e:	2b 45 0c             	sub    0xc(%ebp),%eax
  803341:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803344:	83 ec 0c             	sub    $0xc,%esp
  803347:	ff 75 e4             	pushl  -0x1c(%ebp)
  80334a:	e8 f0 eb ff ff       	call   801f3f <is_free_block>
  80334f:	83 c4 10             	add    $0x10,%esp
  803352:	84 c0                	test   %al,%al
  803354:	0f 84 3b 01 00 00    	je     803495 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80335a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80335d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803360:	01 d0                	add    %edx,%eax
  803362:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803365:	83 ec 04             	sub    $0x4,%esp
  803368:	6a 01                	push   $0x1
  80336a:	ff 75 f0             	pushl  -0x10(%ebp)
  80336d:	ff 75 08             	pushl  0x8(%ebp)
  803370:	e8 02 ef ff ff       	call   802277 <set_block_data>
  803375:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803378:	8b 45 08             	mov    0x8(%ebp),%eax
  80337b:	83 e8 04             	sub    $0x4,%eax
  80337e:	8b 00                	mov    (%eax),%eax
  803380:	83 e0 fe             	and    $0xfffffffe,%eax
  803383:	89 c2                	mov    %eax,%edx
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	01 d0                	add    %edx,%eax
  80338a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80338d:	83 ec 04             	sub    $0x4,%esp
  803390:	6a 00                	push   $0x0
  803392:	ff 75 cc             	pushl  -0x34(%ebp)
  803395:	ff 75 c8             	pushl  -0x38(%ebp)
  803398:	e8 da ee ff ff       	call   802277 <set_block_data>
  80339d:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033a4:	74 06                	je     8033ac <realloc_block_FF+0x142>
  8033a6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033aa:	75 17                	jne    8033c3 <realloc_block_FF+0x159>
  8033ac:	83 ec 04             	sub    $0x4,%esp
  8033af:	68 b0 45 80 00       	push   $0x8045b0
  8033b4:	68 f6 01 00 00       	push   $0x1f6
  8033b9:	68 3d 45 80 00       	push   $0x80453d
  8033be:	e8 c3 ce ff ff       	call   800286 <_panic>
  8033c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c6:	8b 10                	mov    (%eax),%edx
  8033c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033cb:	89 10                	mov    %edx,(%eax)
  8033cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033d0:	8b 00                	mov    (%eax),%eax
  8033d2:	85 c0                	test   %eax,%eax
  8033d4:	74 0b                	je     8033e1 <realloc_block_FF+0x177>
  8033d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d9:	8b 00                	mov    (%eax),%eax
  8033db:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033de:	89 50 04             	mov    %edx,0x4(%eax)
  8033e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033e7:	89 10                	mov    %edx,(%eax)
  8033e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ef:	89 50 04             	mov    %edx,0x4(%eax)
  8033f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f5:	8b 00                	mov    (%eax),%eax
  8033f7:	85 c0                	test   %eax,%eax
  8033f9:	75 08                	jne    803403 <realloc_block_FF+0x199>
  8033fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033fe:	a3 34 50 80 00       	mov    %eax,0x805034
  803403:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803408:	40                   	inc    %eax
  803409:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80340e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803412:	75 17                	jne    80342b <realloc_block_FF+0x1c1>
  803414:	83 ec 04             	sub    $0x4,%esp
  803417:	68 1f 45 80 00       	push   $0x80451f
  80341c:	68 f7 01 00 00       	push   $0x1f7
  803421:	68 3d 45 80 00       	push   $0x80453d
  803426:	e8 5b ce ff ff       	call   800286 <_panic>
  80342b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342e:	8b 00                	mov    (%eax),%eax
  803430:	85 c0                	test   %eax,%eax
  803432:	74 10                	je     803444 <realloc_block_FF+0x1da>
  803434:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803437:	8b 00                	mov    (%eax),%eax
  803439:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80343c:	8b 52 04             	mov    0x4(%edx),%edx
  80343f:	89 50 04             	mov    %edx,0x4(%eax)
  803442:	eb 0b                	jmp    80344f <realloc_block_FF+0x1e5>
  803444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803447:	8b 40 04             	mov    0x4(%eax),%eax
  80344a:	a3 34 50 80 00       	mov    %eax,0x805034
  80344f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803452:	8b 40 04             	mov    0x4(%eax),%eax
  803455:	85 c0                	test   %eax,%eax
  803457:	74 0f                	je     803468 <realloc_block_FF+0x1fe>
  803459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345c:	8b 40 04             	mov    0x4(%eax),%eax
  80345f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803462:	8b 12                	mov    (%edx),%edx
  803464:	89 10                	mov    %edx,(%eax)
  803466:	eb 0a                	jmp    803472 <realloc_block_FF+0x208>
  803468:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346b:	8b 00                	mov    (%eax),%eax
  80346d:	a3 30 50 80 00       	mov    %eax,0x805030
  803472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803475:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803485:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80348a:	48                   	dec    %eax
  80348b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803490:	e9 83 02 00 00       	jmp    803718 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803495:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803499:	0f 86 69 02 00 00    	jbe    803708 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80349f:	83 ec 04             	sub    $0x4,%esp
  8034a2:	6a 01                	push   $0x1
  8034a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8034a7:	ff 75 08             	pushl  0x8(%ebp)
  8034aa:	e8 c8 ed ff ff       	call   802277 <set_block_data>
  8034af:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b5:	83 e8 04             	sub    $0x4,%eax
  8034b8:	8b 00                	mov    (%eax),%eax
  8034ba:	83 e0 fe             	and    $0xfffffffe,%eax
  8034bd:	89 c2                	mov    %eax,%edx
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	01 d0                	add    %edx,%eax
  8034c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034c7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034cf:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034d3:	75 68                	jne    80353d <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034d5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034d9:	75 17                	jne    8034f2 <realloc_block_FF+0x288>
  8034db:	83 ec 04             	sub    $0x4,%esp
  8034de:	68 58 45 80 00       	push   $0x804558
  8034e3:	68 06 02 00 00       	push   $0x206
  8034e8:	68 3d 45 80 00       	push   $0x80453d
  8034ed:	e8 94 cd ff ff       	call   800286 <_panic>
  8034f2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fb:	89 10                	mov    %edx,(%eax)
  8034fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803500:	8b 00                	mov    (%eax),%eax
  803502:	85 c0                	test   %eax,%eax
  803504:	74 0d                	je     803513 <realloc_block_FF+0x2a9>
  803506:	a1 30 50 80 00       	mov    0x805030,%eax
  80350b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80350e:	89 50 04             	mov    %edx,0x4(%eax)
  803511:	eb 08                	jmp    80351b <realloc_block_FF+0x2b1>
  803513:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803516:	a3 34 50 80 00       	mov    %eax,0x805034
  80351b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351e:	a3 30 50 80 00       	mov    %eax,0x805030
  803523:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803526:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803532:	40                   	inc    %eax
  803533:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803538:	e9 b0 01 00 00       	jmp    8036ed <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80353d:	a1 30 50 80 00       	mov    0x805030,%eax
  803542:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803545:	76 68                	jbe    8035af <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803547:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80354b:	75 17                	jne    803564 <realloc_block_FF+0x2fa>
  80354d:	83 ec 04             	sub    $0x4,%esp
  803550:	68 58 45 80 00       	push   $0x804558
  803555:	68 0b 02 00 00       	push   $0x20b
  80355a:	68 3d 45 80 00       	push   $0x80453d
  80355f:	e8 22 cd ff ff       	call   800286 <_panic>
  803564:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80356a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356d:	89 10                	mov    %edx,(%eax)
  80356f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803572:	8b 00                	mov    (%eax),%eax
  803574:	85 c0                	test   %eax,%eax
  803576:	74 0d                	je     803585 <realloc_block_FF+0x31b>
  803578:	a1 30 50 80 00       	mov    0x805030,%eax
  80357d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803580:	89 50 04             	mov    %edx,0x4(%eax)
  803583:	eb 08                	jmp    80358d <realloc_block_FF+0x323>
  803585:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803588:	a3 34 50 80 00       	mov    %eax,0x805034
  80358d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803590:	a3 30 50 80 00       	mov    %eax,0x805030
  803595:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803598:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035a4:	40                   	inc    %eax
  8035a5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035aa:	e9 3e 01 00 00       	jmp    8036ed <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035af:	a1 30 50 80 00       	mov    0x805030,%eax
  8035b4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035b7:	73 68                	jae    803621 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035b9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035bd:	75 17                	jne    8035d6 <realloc_block_FF+0x36c>
  8035bf:	83 ec 04             	sub    $0x4,%esp
  8035c2:	68 8c 45 80 00       	push   $0x80458c
  8035c7:	68 10 02 00 00       	push   $0x210
  8035cc:	68 3d 45 80 00       	push   $0x80453d
  8035d1:	e8 b0 cc ff ff       	call   800286 <_panic>
  8035d6:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8035dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035df:	89 50 04             	mov    %edx,0x4(%eax)
  8035e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e5:	8b 40 04             	mov    0x4(%eax),%eax
  8035e8:	85 c0                	test   %eax,%eax
  8035ea:	74 0c                	je     8035f8 <realloc_block_FF+0x38e>
  8035ec:	a1 34 50 80 00       	mov    0x805034,%eax
  8035f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035f4:	89 10                	mov    %edx,(%eax)
  8035f6:	eb 08                	jmp    803600 <realloc_block_FF+0x396>
  8035f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fb:	a3 30 50 80 00       	mov    %eax,0x805030
  803600:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803603:	a3 34 50 80 00       	mov    %eax,0x805034
  803608:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803611:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803616:	40                   	inc    %eax
  803617:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80361c:	e9 cc 00 00 00       	jmp    8036ed <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803621:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803628:	a1 30 50 80 00       	mov    0x805030,%eax
  80362d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803630:	e9 8a 00 00 00       	jmp    8036bf <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803638:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80363b:	73 7a                	jae    8036b7 <realloc_block_FF+0x44d>
  80363d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803640:	8b 00                	mov    (%eax),%eax
  803642:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803645:	73 70                	jae    8036b7 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803647:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364b:	74 06                	je     803653 <realloc_block_FF+0x3e9>
  80364d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803651:	75 17                	jne    80366a <realloc_block_FF+0x400>
  803653:	83 ec 04             	sub    $0x4,%esp
  803656:	68 b0 45 80 00       	push   $0x8045b0
  80365b:	68 1a 02 00 00       	push   $0x21a
  803660:	68 3d 45 80 00       	push   $0x80453d
  803665:	e8 1c cc ff ff       	call   800286 <_panic>
  80366a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366d:	8b 10                	mov    (%eax),%edx
  80366f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803672:	89 10                	mov    %edx,(%eax)
  803674:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803677:	8b 00                	mov    (%eax),%eax
  803679:	85 c0                	test   %eax,%eax
  80367b:	74 0b                	je     803688 <realloc_block_FF+0x41e>
  80367d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803680:	8b 00                	mov    (%eax),%eax
  803682:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803685:	89 50 04             	mov    %edx,0x4(%eax)
  803688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80368e:	89 10                	mov    %edx,(%eax)
  803690:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803693:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803696:	89 50 04             	mov    %edx,0x4(%eax)
  803699:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	75 08                	jne    8036aa <realloc_block_FF+0x440>
  8036a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a5:	a3 34 50 80 00       	mov    %eax,0x805034
  8036aa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036af:	40                   	inc    %eax
  8036b0:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  8036b5:	eb 36                	jmp    8036ed <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8036bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036c3:	74 07                	je     8036cc <realloc_block_FF+0x462>
  8036c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c8:	8b 00                	mov    (%eax),%eax
  8036ca:	eb 05                	jmp    8036d1 <realloc_block_FF+0x467>
  8036cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8036d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8036db:	85 c0                	test   %eax,%eax
  8036dd:	0f 85 52 ff ff ff    	jne    803635 <realloc_block_FF+0x3cb>
  8036e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e7:	0f 85 48 ff ff ff    	jne    803635 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036ed:	83 ec 04             	sub    $0x4,%esp
  8036f0:	6a 00                	push   $0x0
  8036f2:	ff 75 d8             	pushl  -0x28(%ebp)
  8036f5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036f8:	e8 7a eb ff ff       	call   802277 <set_block_data>
  8036fd:	83 c4 10             	add    $0x10,%esp
				return va;
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	e9 7b 02 00 00       	jmp    803983 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803708:	83 ec 0c             	sub    $0xc,%esp
  80370b:	68 2d 46 80 00       	push   $0x80462d
  803710:	e8 2e ce ff ff       	call   800543 <cprintf>
  803715:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803718:	8b 45 08             	mov    0x8(%ebp),%eax
  80371b:	e9 63 02 00 00       	jmp    803983 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803720:	8b 45 0c             	mov    0xc(%ebp),%eax
  803723:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803726:	0f 86 4d 02 00 00    	jbe    803979 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80372c:	83 ec 0c             	sub    $0xc,%esp
  80372f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803732:	e8 08 e8 ff ff       	call   801f3f <is_free_block>
  803737:	83 c4 10             	add    $0x10,%esp
  80373a:	84 c0                	test   %al,%al
  80373c:	0f 84 37 02 00 00    	je     803979 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803742:	8b 45 0c             	mov    0xc(%ebp),%eax
  803745:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803748:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80374b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80374e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803751:	76 38                	jbe    80378b <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803753:	83 ec 0c             	sub    $0xc,%esp
  803756:	ff 75 08             	pushl  0x8(%ebp)
  803759:	e8 0c fa ff ff       	call   80316a <free_block>
  80375e:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803761:	83 ec 0c             	sub    $0xc,%esp
  803764:	ff 75 0c             	pushl  0xc(%ebp)
  803767:	e8 3a eb ff ff       	call   8022a6 <alloc_block_FF>
  80376c:	83 c4 10             	add    $0x10,%esp
  80376f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803772:	83 ec 08             	sub    $0x8,%esp
  803775:	ff 75 c0             	pushl  -0x40(%ebp)
  803778:	ff 75 08             	pushl  0x8(%ebp)
  80377b:	e8 ab fa ff ff       	call   80322b <copy_data>
  803780:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803783:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803786:	e9 f8 01 00 00       	jmp    803983 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80378b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80378e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803791:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803794:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803798:	0f 87 a0 00 00 00    	ja     80383e <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80379e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037a2:	75 17                	jne    8037bb <realloc_block_FF+0x551>
  8037a4:	83 ec 04             	sub    $0x4,%esp
  8037a7:	68 1f 45 80 00       	push   $0x80451f
  8037ac:	68 38 02 00 00       	push   $0x238
  8037b1:	68 3d 45 80 00       	push   $0x80453d
  8037b6:	e8 cb ca ff ff       	call   800286 <_panic>
  8037bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037be:	8b 00                	mov    (%eax),%eax
  8037c0:	85 c0                	test   %eax,%eax
  8037c2:	74 10                	je     8037d4 <realloc_block_FF+0x56a>
  8037c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c7:	8b 00                	mov    (%eax),%eax
  8037c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037cc:	8b 52 04             	mov    0x4(%edx),%edx
  8037cf:	89 50 04             	mov    %edx,0x4(%eax)
  8037d2:	eb 0b                	jmp    8037df <realloc_block_FF+0x575>
  8037d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d7:	8b 40 04             	mov    0x4(%eax),%eax
  8037da:	a3 34 50 80 00       	mov    %eax,0x805034
  8037df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e2:	8b 40 04             	mov    0x4(%eax),%eax
  8037e5:	85 c0                	test   %eax,%eax
  8037e7:	74 0f                	je     8037f8 <realloc_block_FF+0x58e>
  8037e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ec:	8b 40 04             	mov    0x4(%eax),%eax
  8037ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037f2:	8b 12                	mov    (%edx),%edx
  8037f4:	89 10                	mov    %edx,(%eax)
  8037f6:	eb 0a                	jmp    803802 <realloc_block_FF+0x598>
  8037f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fb:	8b 00                	mov    (%eax),%eax
  8037fd:	a3 30 50 80 00       	mov    %eax,0x805030
  803802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803805:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80380b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803815:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80381a:	48                   	dec    %eax
  80381b:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803820:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803823:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803826:	01 d0                	add    %edx,%eax
  803828:	83 ec 04             	sub    $0x4,%esp
  80382b:	6a 01                	push   $0x1
  80382d:	50                   	push   %eax
  80382e:	ff 75 08             	pushl  0x8(%ebp)
  803831:	e8 41 ea ff ff       	call   802277 <set_block_data>
  803836:	83 c4 10             	add    $0x10,%esp
  803839:	e9 36 01 00 00       	jmp    803974 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80383e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803841:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803844:	01 d0                	add    %edx,%eax
  803846:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803849:	83 ec 04             	sub    $0x4,%esp
  80384c:	6a 01                	push   $0x1
  80384e:	ff 75 f0             	pushl  -0x10(%ebp)
  803851:	ff 75 08             	pushl  0x8(%ebp)
  803854:	e8 1e ea ff ff       	call   802277 <set_block_data>
  803859:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80385c:	8b 45 08             	mov    0x8(%ebp),%eax
  80385f:	83 e8 04             	sub    $0x4,%eax
  803862:	8b 00                	mov    (%eax),%eax
  803864:	83 e0 fe             	and    $0xfffffffe,%eax
  803867:	89 c2                	mov    %eax,%edx
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	01 d0                	add    %edx,%eax
  80386e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803871:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803875:	74 06                	je     80387d <realloc_block_FF+0x613>
  803877:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80387b:	75 17                	jne    803894 <realloc_block_FF+0x62a>
  80387d:	83 ec 04             	sub    $0x4,%esp
  803880:	68 b0 45 80 00       	push   $0x8045b0
  803885:	68 44 02 00 00       	push   $0x244
  80388a:	68 3d 45 80 00       	push   $0x80453d
  80388f:	e8 f2 c9 ff ff       	call   800286 <_panic>
  803894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803897:	8b 10                	mov    (%eax),%edx
  803899:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80389c:	89 10                	mov    %edx,(%eax)
  80389e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038a1:	8b 00                	mov    (%eax),%eax
  8038a3:	85 c0                	test   %eax,%eax
  8038a5:	74 0b                	je     8038b2 <realloc_block_FF+0x648>
  8038a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038aa:	8b 00                	mov    (%eax),%eax
  8038ac:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038af:	89 50 04             	mov    %edx,0x4(%eax)
  8038b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b5:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038b8:	89 10                	mov    %edx,(%eax)
  8038ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c0:	89 50 04             	mov    %edx,0x4(%eax)
  8038c3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038c6:	8b 00                	mov    (%eax),%eax
  8038c8:	85 c0                	test   %eax,%eax
  8038ca:	75 08                	jne    8038d4 <realloc_block_FF+0x66a>
  8038cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038cf:	a3 34 50 80 00       	mov    %eax,0x805034
  8038d4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038d9:	40                   	inc    %eax
  8038da:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038e3:	75 17                	jne    8038fc <realloc_block_FF+0x692>
  8038e5:	83 ec 04             	sub    $0x4,%esp
  8038e8:	68 1f 45 80 00       	push   $0x80451f
  8038ed:	68 45 02 00 00       	push   $0x245
  8038f2:	68 3d 45 80 00       	push   $0x80453d
  8038f7:	e8 8a c9 ff ff       	call   800286 <_panic>
  8038fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ff:	8b 00                	mov    (%eax),%eax
  803901:	85 c0                	test   %eax,%eax
  803903:	74 10                	je     803915 <realloc_block_FF+0x6ab>
  803905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803908:	8b 00                	mov    (%eax),%eax
  80390a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80390d:	8b 52 04             	mov    0x4(%edx),%edx
  803910:	89 50 04             	mov    %edx,0x4(%eax)
  803913:	eb 0b                	jmp    803920 <realloc_block_FF+0x6b6>
  803915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803918:	8b 40 04             	mov    0x4(%eax),%eax
  80391b:	a3 34 50 80 00       	mov    %eax,0x805034
  803920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803923:	8b 40 04             	mov    0x4(%eax),%eax
  803926:	85 c0                	test   %eax,%eax
  803928:	74 0f                	je     803939 <realloc_block_FF+0x6cf>
  80392a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392d:	8b 40 04             	mov    0x4(%eax),%eax
  803930:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803933:	8b 12                	mov    (%edx),%edx
  803935:	89 10                	mov    %edx,(%eax)
  803937:	eb 0a                	jmp    803943 <realloc_block_FF+0x6d9>
  803939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393c:	8b 00                	mov    (%eax),%eax
  80393e:	a3 30 50 80 00       	mov    %eax,0x805030
  803943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803946:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80394c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803956:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80395b:	48                   	dec    %eax
  80395c:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803961:	83 ec 04             	sub    $0x4,%esp
  803964:	6a 00                	push   $0x0
  803966:	ff 75 bc             	pushl  -0x44(%ebp)
  803969:	ff 75 b8             	pushl  -0x48(%ebp)
  80396c:	e8 06 e9 ff ff       	call   802277 <set_block_data>
  803971:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803974:	8b 45 08             	mov    0x8(%ebp),%eax
  803977:	eb 0a                	jmp    803983 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803979:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803980:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803983:	c9                   	leave  
  803984:	c3                   	ret    

00803985 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803985:	55                   	push   %ebp
  803986:	89 e5                	mov    %esp,%ebp
  803988:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80398b:	83 ec 04             	sub    $0x4,%esp
  80398e:	68 34 46 80 00       	push   $0x804634
  803993:	68 58 02 00 00       	push   $0x258
  803998:	68 3d 45 80 00       	push   $0x80453d
  80399d:	e8 e4 c8 ff ff       	call   800286 <_panic>

008039a2 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039a2:	55                   	push   %ebp
  8039a3:	89 e5                	mov    %esp,%ebp
  8039a5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039a8:	83 ec 04             	sub    $0x4,%esp
  8039ab:	68 5c 46 80 00       	push   $0x80465c
  8039b0:	68 61 02 00 00       	push   $0x261
  8039b5:	68 3d 45 80 00       	push   $0x80453d
  8039ba:	e8 c7 c8 ff ff       	call   800286 <_panic>

008039bf <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8039bf:	55                   	push   %ebp
  8039c0:	89 e5                	mov    %esp,%ebp
  8039c2:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8039c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8039c8:	89 d0                	mov    %edx,%eax
  8039ca:	c1 e0 02             	shl    $0x2,%eax
  8039cd:	01 d0                	add    %edx,%eax
  8039cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039d6:	01 d0                	add    %edx,%eax
  8039d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039df:	01 d0                	add    %edx,%eax
  8039e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039e8:	01 d0                	add    %edx,%eax
  8039ea:	c1 e0 04             	shl    $0x4,%eax
  8039ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8039f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8039f7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8039fa:	83 ec 0c             	sub    $0xc,%esp
  8039fd:	50                   	push   %eax
  8039fe:	e8 2f e2 ff ff       	call   801c32 <sys_get_virtual_time>
  803a03:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803a06:	eb 41                	jmp    803a49 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803a08:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803a0b:	83 ec 0c             	sub    $0xc,%esp
  803a0e:	50                   	push   %eax
  803a0f:	e8 1e e2 ff ff       	call   801c32 <sys_get_virtual_time>
  803a14:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803a17:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1d:	29 c2                	sub    %eax,%edx
  803a1f:	89 d0                	mov    %edx,%eax
  803a21:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803a24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a2a:	89 d1                	mov    %edx,%ecx
  803a2c:	29 c1                	sub    %eax,%ecx
  803a2e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a34:	39 c2                	cmp    %eax,%edx
  803a36:	0f 97 c0             	seta   %al
  803a39:	0f b6 c0             	movzbl %al,%eax
  803a3c:	29 c1                	sub    %eax,%ecx
  803a3e:	89 c8                	mov    %ecx,%eax
  803a40:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803a43:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803a4f:	72 b7                	jb     803a08 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803a51:	90                   	nop
  803a52:	c9                   	leave  
  803a53:	c3                   	ret    

00803a54 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803a54:	55                   	push   %ebp
  803a55:	89 e5                	mov    %esp,%ebp
  803a57:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803a5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803a61:	eb 03                	jmp    803a66 <busy_wait+0x12>
  803a63:	ff 45 fc             	incl   -0x4(%ebp)
  803a66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a69:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a6c:	72 f5                	jb     803a63 <busy_wait+0xf>
	return i;
  803a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803a71:	c9                   	leave  
  803a72:	c3                   	ret    
  803a73:	90                   	nop

00803a74 <__udivdi3>:
  803a74:	55                   	push   %ebp
  803a75:	57                   	push   %edi
  803a76:	56                   	push   %esi
  803a77:	53                   	push   %ebx
  803a78:	83 ec 1c             	sub    $0x1c,%esp
  803a7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a8b:	89 ca                	mov    %ecx,%edx
  803a8d:	89 f8                	mov    %edi,%eax
  803a8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a93:	85 f6                	test   %esi,%esi
  803a95:	75 2d                	jne    803ac4 <__udivdi3+0x50>
  803a97:	39 cf                	cmp    %ecx,%edi
  803a99:	77 65                	ja     803b00 <__udivdi3+0x8c>
  803a9b:	89 fd                	mov    %edi,%ebp
  803a9d:	85 ff                	test   %edi,%edi
  803a9f:	75 0b                	jne    803aac <__udivdi3+0x38>
  803aa1:	b8 01 00 00 00       	mov    $0x1,%eax
  803aa6:	31 d2                	xor    %edx,%edx
  803aa8:	f7 f7                	div    %edi
  803aaa:	89 c5                	mov    %eax,%ebp
  803aac:	31 d2                	xor    %edx,%edx
  803aae:	89 c8                	mov    %ecx,%eax
  803ab0:	f7 f5                	div    %ebp
  803ab2:	89 c1                	mov    %eax,%ecx
  803ab4:	89 d8                	mov    %ebx,%eax
  803ab6:	f7 f5                	div    %ebp
  803ab8:	89 cf                	mov    %ecx,%edi
  803aba:	89 fa                	mov    %edi,%edx
  803abc:	83 c4 1c             	add    $0x1c,%esp
  803abf:	5b                   	pop    %ebx
  803ac0:	5e                   	pop    %esi
  803ac1:	5f                   	pop    %edi
  803ac2:	5d                   	pop    %ebp
  803ac3:	c3                   	ret    
  803ac4:	39 ce                	cmp    %ecx,%esi
  803ac6:	77 28                	ja     803af0 <__udivdi3+0x7c>
  803ac8:	0f bd fe             	bsr    %esi,%edi
  803acb:	83 f7 1f             	xor    $0x1f,%edi
  803ace:	75 40                	jne    803b10 <__udivdi3+0x9c>
  803ad0:	39 ce                	cmp    %ecx,%esi
  803ad2:	72 0a                	jb     803ade <__udivdi3+0x6a>
  803ad4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ad8:	0f 87 9e 00 00 00    	ja     803b7c <__udivdi3+0x108>
  803ade:	b8 01 00 00 00       	mov    $0x1,%eax
  803ae3:	89 fa                	mov    %edi,%edx
  803ae5:	83 c4 1c             	add    $0x1c,%esp
  803ae8:	5b                   	pop    %ebx
  803ae9:	5e                   	pop    %esi
  803aea:	5f                   	pop    %edi
  803aeb:	5d                   	pop    %ebp
  803aec:	c3                   	ret    
  803aed:	8d 76 00             	lea    0x0(%esi),%esi
  803af0:	31 ff                	xor    %edi,%edi
  803af2:	31 c0                	xor    %eax,%eax
  803af4:	89 fa                	mov    %edi,%edx
  803af6:	83 c4 1c             	add    $0x1c,%esp
  803af9:	5b                   	pop    %ebx
  803afa:	5e                   	pop    %esi
  803afb:	5f                   	pop    %edi
  803afc:	5d                   	pop    %ebp
  803afd:	c3                   	ret    
  803afe:	66 90                	xchg   %ax,%ax
  803b00:	89 d8                	mov    %ebx,%eax
  803b02:	f7 f7                	div    %edi
  803b04:	31 ff                	xor    %edi,%edi
  803b06:	89 fa                	mov    %edi,%edx
  803b08:	83 c4 1c             	add    $0x1c,%esp
  803b0b:	5b                   	pop    %ebx
  803b0c:	5e                   	pop    %esi
  803b0d:	5f                   	pop    %edi
  803b0e:	5d                   	pop    %ebp
  803b0f:	c3                   	ret    
  803b10:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b15:	89 eb                	mov    %ebp,%ebx
  803b17:	29 fb                	sub    %edi,%ebx
  803b19:	89 f9                	mov    %edi,%ecx
  803b1b:	d3 e6                	shl    %cl,%esi
  803b1d:	89 c5                	mov    %eax,%ebp
  803b1f:	88 d9                	mov    %bl,%cl
  803b21:	d3 ed                	shr    %cl,%ebp
  803b23:	89 e9                	mov    %ebp,%ecx
  803b25:	09 f1                	or     %esi,%ecx
  803b27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b2b:	89 f9                	mov    %edi,%ecx
  803b2d:	d3 e0                	shl    %cl,%eax
  803b2f:	89 c5                	mov    %eax,%ebp
  803b31:	89 d6                	mov    %edx,%esi
  803b33:	88 d9                	mov    %bl,%cl
  803b35:	d3 ee                	shr    %cl,%esi
  803b37:	89 f9                	mov    %edi,%ecx
  803b39:	d3 e2                	shl    %cl,%edx
  803b3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b3f:	88 d9                	mov    %bl,%cl
  803b41:	d3 e8                	shr    %cl,%eax
  803b43:	09 c2                	or     %eax,%edx
  803b45:	89 d0                	mov    %edx,%eax
  803b47:	89 f2                	mov    %esi,%edx
  803b49:	f7 74 24 0c          	divl   0xc(%esp)
  803b4d:	89 d6                	mov    %edx,%esi
  803b4f:	89 c3                	mov    %eax,%ebx
  803b51:	f7 e5                	mul    %ebp
  803b53:	39 d6                	cmp    %edx,%esi
  803b55:	72 19                	jb     803b70 <__udivdi3+0xfc>
  803b57:	74 0b                	je     803b64 <__udivdi3+0xf0>
  803b59:	89 d8                	mov    %ebx,%eax
  803b5b:	31 ff                	xor    %edi,%edi
  803b5d:	e9 58 ff ff ff       	jmp    803aba <__udivdi3+0x46>
  803b62:	66 90                	xchg   %ax,%ax
  803b64:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b68:	89 f9                	mov    %edi,%ecx
  803b6a:	d3 e2                	shl    %cl,%edx
  803b6c:	39 c2                	cmp    %eax,%edx
  803b6e:	73 e9                	jae    803b59 <__udivdi3+0xe5>
  803b70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b73:	31 ff                	xor    %edi,%edi
  803b75:	e9 40 ff ff ff       	jmp    803aba <__udivdi3+0x46>
  803b7a:	66 90                	xchg   %ax,%ax
  803b7c:	31 c0                	xor    %eax,%eax
  803b7e:	e9 37 ff ff ff       	jmp    803aba <__udivdi3+0x46>
  803b83:	90                   	nop

00803b84 <__umoddi3>:
  803b84:	55                   	push   %ebp
  803b85:	57                   	push   %edi
  803b86:	56                   	push   %esi
  803b87:	53                   	push   %ebx
  803b88:	83 ec 1c             	sub    $0x1c,%esp
  803b8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ba3:	89 f3                	mov    %esi,%ebx
  803ba5:	89 fa                	mov    %edi,%edx
  803ba7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bab:	89 34 24             	mov    %esi,(%esp)
  803bae:	85 c0                	test   %eax,%eax
  803bb0:	75 1a                	jne    803bcc <__umoddi3+0x48>
  803bb2:	39 f7                	cmp    %esi,%edi
  803bb4:	0f 86 a2 00 00 00    	jbe    803c5c <__umoddi3+0xd8>
  803bba:	89 c8                	mov    %ecx,%eax
  803bbc:	89 f2                	mov    %esi,%edx
  803bbe:	f7 f7                	div    %edi
  803bc0:	89 d0                	mov    %edx,%eax
  803bc2:	31 d2                	xor    %edx,%edx
  803bc4:	83 c4 1c             	add    $0x1c,%esp
  803bc7:	5b                   	pop    %ebx
  803bc8:	5e                   	pop    %esi
  803bc9:	5f                   	pop    %edi
  803bca:	5d                   	pop    %ebp
  803bcb:	c3                   	ret    
  803bcc:	39 f0                	cmp    %esi,%eax
  803bce:	0f 87 ac 00 00 00    	ja     803c80 <__umoddi3+0xfc>
  803bd4:	0f bd e8             	bsr    %eax,%ebp
  803bd7:	83 f5 1f             	xor    $0x1f,%ebp
  803bda:	0f 84 ac 00 00 00    	je     803c8c <__umoddi3+0x108>
  803be0:	bf 20 00 00 00       	mov    $0x20,%edi
  803be5:	29 ef                	sub    %ebp,%edi
  803be7:	89 fe                	mov    %edi,%esi
  803be9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bed:	89 e9                	mov    %ebp,%ecx
  803bef:	d3 e0                	shl    %cl,%eax
  803bf1:	89 d7                	mov    %edx,%edi
  803bf3:	89 f1                	mov    %esi,%ecx
  803bf5:	d3 ef                	shr    %cl,%edi
  803bf7:	09 c7                	or     %eax,%edi
  803bf9:	89 e9                	mov    %ebp,%ecx
  803bfb:	d3 e2                	shl    %cl,%edx
  803bfd:	89 14 24             	mov    %edx,(%esp)
  803c00:	89 d8                	mov    %ebx,%eax
  803c02:	d3 e0                	shl    %cl,%eax
  803c04:	89 c2                	mov    %eax,%edx
  803c06:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c0a:	d3 e0                	shl    %cl,%eax
  803c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c10:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c14:	89 f1                	mov    %esi,%ecx
  803c16:	d3 e8                	shr    %cl,%eax
  803c18:	09 d0                	or     %edx,%eax
  803c1a:	d3 eb                	shr    %cl,%ebx
  803c1c:	89 da                	mov    %ebx,%edx
  803c1e:	f7 f7                	div    %edi
  803c20:	89 d3                	mov    %edx,%ebx
  803c22:	f7 24 24             	mull   (%esp)
  803c25:	89 c6                	mov    %eax,%esi
  803c27:	89 d1                	mov    %edx,%ecx
  803c29:	39 d3                	cmp    %edx,%ebx
  803c2b:	0f 82 87 00 00 00    	jb     803cb8 <__umoddi3+0x134>
  803c31:	0f 84 91 00 00 00    	je     803cc8 <__umoddi3+0x144>
  803c37:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c3b:	29 f2                	sub    %esi,%edx
  803c3d:	19 cb                	sbb    %ecx,%ebx
  803c3f:	89 d8                	mov    %ebx,%eax
  803c41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c45:	d3 e0                	shl    %cl,%eax
  803c47:	89 e9                	mov    %ebp,%ecx
  803c49:	d3 ea                	shr    %cl,%edx
  803c4b:	09 d0                	or     %edx,%eax
  803c4d:	89 e9                	mov    %ebp,%ecx
  803c4f:	d3 eb                	shr    %cl,%ebx
  803c51:	89 da                	mov    %ebx,%edx
  803c53:	83 c4 1c             	add    $0x1c,%esp
  803c56:	5b                   	pop    %ebx
  803c57:	5e                   	pop    %esi
  803c58:	5f                   	pop    %edi
  803c59:	5d                   	pop    %ebp
  803c5a:	c3                   	ret    
  803c5b:	90                   	nop
  803c5c:	89 fd                	mov    %edi,%ebp
  803c5e:	85 ff                	test   %edi,%edi
  803c60:	75 0b                	jne    803c6d <__umoddi3+0xe9>
  803c62:	b8 01 00 00 00       	mov    $0x1,%eax
  803c67:	31 d2                	xor    %edx,%edx
  803c69:	f7 f7                	div    %edi
  803c6b:	89 c5                	mov    %eax,%ebp
  803c6d:	89 f0                	mov    %esi,%eax
  803c6f:	31 d2                	xor    %edx,%edx
  803c71:	f7 f5                	div    %ebp
  803c73:	89 c8                	mov    %ecx,%eax
  803c75:	f7 f5                	div    %ebp
  803c77:	89 d0                	mov    %edx,%eax
  803c79:	e9 44 ff ff ff       	jmp    803bc2 <__umoddi3+0x3e>
  803c7e:	66 90                	xchg   %ax,%ax
  803c80:	89 c8                	mov    %ecx,%eax
  803c82:	89 f2                	mov    %esi,%edx
  803c84:	83 c4 1c             	add    $0x1c,%esp
  803c87:	5b                   	pop    %ebx
  803c88:	5e                   	pop    %esi
  803c89:	5f                   	pop    %edi
  803c8a:	5d                   	pop    %ebp
  803c8b:	c3                   	ret    
  803c8c:	3b 04 24             	cmp    (%esp),%eax
  803c8f:	72 06                	jb     803c97 <__umoddi3+0x113>
  803c91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c95:	77 0f                	ja     803ca6 <__umoddi3+0x122>
  803c97:	89 f2                	mov    %esi,%edx
  803c99:	29 f9                	sub    %edi,%ecx
  803c9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c9f:	89 14 24             	mov    %edx,(%esp)
  803ca2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ca6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803caa:	8b 14 24             	mov    (%esp),%edx
  803cad:	83 c4 1c             	add    $0x1c,%esp
  803cb0:	5b                   	pop    %ebx
  803cb1:	5e                   	pop    %esi
  803cb2:	5f                   	pop    %edi
  803cb3:	5d                   	pop    %ebp
  803cb4:	c3                   	ret    
  803cb5:	8d 76 00             	lea    0x0(%esi),%esi
  803cb8:	2b 04 24             	sub    (%esp),%eax
  803cbb:	19 fa                	sbb    %edi,%edx
  803cbd:	89 d1                	mov    %edx,%ecx
  803cbf:	89 c6                	mov    %eax,%esi
  803cc1:	e9 71 ff ff ff       	jmp    803c37 <__umoddi3+0xb3>
  803cc6:	66 90                	xchg   %ax,%ax
  803cc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ccc:	72 ea                	jb     803cb8 <__umoddi3+0x134>
  803cce:	89 d9                	mov    %ebx,%ecx
  803cd0:	e9 62 ff ff ff       	jmp    803c37 <__umoddi3+0xb3>
