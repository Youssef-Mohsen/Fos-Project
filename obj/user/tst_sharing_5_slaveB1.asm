
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
  80005b:	68 c0 3b 80 00       	push   $0x803bc0
  800060:	6a 0c                	push   $0xc
  800062:	68 dc 3b 80 00       	push   $0x803bdc
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
  800073:	e8 9a 1a 00 00       	call   801b12 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 f9 3b 80 00       	push   $0x803bf9
  800080:	50                   	push   %eax
  800081:	e8 30 16 00 00       	call   8016b6 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 fc 3b 80 00       	push   $0x803bfc
  800094:	e8 aa 04 00 00       	call   800543 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  80009c:	e8 96 1b 00 00       	call   801c37 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 24 3c 80 00       	push   $0x803c24
  8000a9:	e8 95 04 00 00       	call   800543 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 70 17 00 00       	push   $0x1770
  8000b9:	e8 e1 37 00 00       	call   80389f <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=2) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 8a 1b 00 00       	call   801c51 <gettst>
  8000c7:	83 f8 02             	cmp    $0x2,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 5f 18 00 00       	call   801930 <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 7f 16 00 00       	call   80175e <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 44 3c 80 00       	push   $0x803c44
  8000ea:	e8 54 04 00 00       	call   800543 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 1+1; /*1page+1table*/
  8000f2:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
	cprintf("diff 2 : %d\n",sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 32 18 00 00       	call   801930 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	50                   	push   %eax
  80010b:	68 5c 3c 80 00       	push   $0x803c5c
  800110:	e8 2e 04 00 00       	call   800543 <cprintf>
  800115:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800118:	e8 13 18 00 00       	call   801930 <sys_calculate_free_frames>
  80011d:	89 c2                	mov    %eax,%edx
  80011f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800122:	29 c2                	sub    %eax,%edx
  800124:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800127:	39 c2                	cmp    %eax,%edx
  800129:	74 14                	je     80013f <_main+0x107>
  80012b:	83 ec 04             	sub    $0x4,%esp
  80012e:	68 6c 3c 80 00       	push   $0x803c6c
  800133:	6a 27                	push   $0x27
  800135:	68 dc 3b 80 00       	push   $0x803bdc
  80013a:	e8 47 01 00 00       	call   800286 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80013f:	e8 f3 1a 00 00       	call   801c37 <inctst>
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
  80014d:	e8 a7 19 00 00       	call   801af9 <sys_getenvindex>
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
  8001bb:	e8 bd 16 00 00       	call   80187d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	68 2c 3d 80 00       	push   $0x803d2c
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
  8001eb:	68 54 3d 80 00       	push   $0x803d54
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
  80021c:	68 7c 3d 80 00       	push   $0x803d7c
  800221:	e8 1d 03 00 00       	call   800543 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800229:	a1 20 50 80 00       	mov    0x805020,%eax
  80022e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	50                   	push   %eax
  800238:	68 d4 3d 80 00       	push   $0x803dd4
  80023d:	e8 01 03 00 00       	call   800543 <cprintf>
  800242:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	68 2c 3d 80 00       	push   $0x803d2c
  80024d:	e8 f1 02 00 00       	call   800543 <cprintf>
  800252:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800255:	e8 3d 16 00 00       	call   801897 <sys_unlock_cons>
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
  80026d:	e8 53 18 00 00       	call   801ac5 <sys_destroy_env>
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
  80027e:	e8 a8 18 00 00       	call   801b2b <sys_exit_env>
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
  800295:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80029a:	85 c0                	test   %eax,%eax
  80029c:	74 16                	je     8002b4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8002a3:	83 ec 08             	sub    $0x8,%esp
  8002a6:	50                   	push   %eax
  8002a7:	68 e8 3d 80 00       	push   $0x803de8
  8002ac:	e8 92 02 00 00       	call   800543 <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b4:	a1 00 50 80 00       	mov    0x805000,%eax
  8002b9:	ff 75 0c             	pushl  0xc(%ebp)
  8002bc:	ff 75 08             	pushl  0x8(%ebp)
  8002bf:	50                   	push   %eax
  8002c0:	68 ed 3d 80 00       	push   $0x803ded
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
  8002e4:	68 09 3e 80 00       	push   $0x803e09
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
  800313:	68 0c 3e 80 00       	push   $0x803e0c
  800318:	6a 26                	push   $0x26
  80031a:	68 58 3e 80 00       	push   $0x803e58
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
  8003e8:	68 64 3e 80 00       	push   $0x803e64
  8003ed:	6a 3a                	push   $0x3a
  8003ef:	68 58 3e 80 00       	push   $0x803e58
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
  80045b:	68 b8 3e 80 00       	push   $0x803eb8
  800460:	6a 44                	push   $0x44
  800462:	68 58 3e 80 00       	push   $0x803e58
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
  80049a:	a0 28 50 80 00       	mov    0x805028,%al
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
  8004b5:	e8 81 13 00 00       	call   80183b <sys_cputs>
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
  80050f:	a0 28 50 80 00       	mov    0x805028,%al
  800514:	0f b6 c0             	movzbl %al,%eax
  800517:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051d:	83 ec 04             	sub    $0x4,%esp
  800520:	50                   	push   %eax
  800521:	52                   	push   %edx
  800522:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800528:	83 c0 08             	add    $0x8,%eax
  80052b:	50                   	push   %eax
  80052c:	e8 0a 13 00 00       	call   80183b <sys_cputs>
  800531:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800534:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  800549:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  800576:	e8 02 13 00 00       	call   80187d <sys_lock_cons>
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
  800596:	e8 fc 12 00 00       	call   801897 <sys_unlock_cons>
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
  8005e0:	e8 6f 33 00 00       	call   803954 <__udivdi3>
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
  800630:	e8 2f 34 00 00       	call   803a64 <__umoddi3>
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	05 34 41 80 00       	add    $0x804134,%eax
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
  80078b:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
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
  80086c:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  800873:	85 f6                	test   %esi,%esi
  800875:	75 19                	jne    800890 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800877:	53                   	push   %ebx
  800878:	68 45 41 80 00       	push   $0x804145
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
  800891:	68 4e 41 80 00       	push   $0x80414e
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
  8008be:	be 51 41 80 00       	mov    $0x804151,%esi
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
  800ab6:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800abd:	eb 2c                	jmp    800aeb <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800abf:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  8012c9:	68 c8 42 80 00       	push   $0x8042c8
  8012ce:	68 3f 01 00 00       	push   $0x13f
  8012d3:	68 ea 42 80 00       	push   $0x8042ea
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
  8012e9:	e8 f8 0a 00 00       	call   801de6 <sys_sbrk>
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
  801364:	e8 01 09 00 00       	call   801c6a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801369:	85 c0                	test   %eax,%eax
  80136b:	74 16                	je     801383 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  80136d:	83 ec 0c             	sub    $0xc,%esp
  801370:	ff 75 08             	pushl  0x8(%ebp)
  801373:	e8 41 0e 00 00       	call   8021b9 <alloc_block_FF>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80137e:	e9 8a 01 00 00       	jmp    80150d <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801383:	e8 13 09 00 00       	call   801c9b <sys_isUHeapPlacementStrategyBESTFIT>
  801388:	85 c0                	test   %eax,%eax
  80138a:	0f 84 7d 01 00 00    	je     80150d <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801390:	83 ec 0c             	sub    $0xc,%esp
  801393:	ff 75 08             	pushl  0x8(%ebp)
  801396:	e8 da 12 00 00       	call   802675 <alloc_block_BF>
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
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8013cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8013d4:	8b 40 78             	mov    0x78(%eax),%eax
  8013d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013da:	29 c2                	sub    %eax,%edx
  8013dc:	89 d0                	mov    %edx,%eax
  8013de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e3:	c1 e8 0c             	shr    $0xc,%eax
  8013e6:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	0f 85 ab 00 00 00    	jne    8014a0 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  8013f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f8:	05 00 10 00 00       	add    $0x1000,%eax
  8013fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801400:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
  801433:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  80143a:	85 c0                	test   %eax,%eax
  80143c:	74 08                	je     801446 <malloc+0x153>
					{
						
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
  80148a:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
				

			}
			sayed:
			if(ok) break;
  8014a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a4:	75 16                	jne    8014bc <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8014a6:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8014ad:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8014b4:	0f 86 15 ff ff ff    	jbe    8013cf <malloc+0xdc>
  8014ba:	eb 01                	jmp    8014bd <malloc+0x1ca>
				}
				

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
  8014ec:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	ff 75 08             	pushl  0x8(%ebp)
  8014f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8014fc:	e8 1c 09 00 00       	call   801e1d <sys_allocate_user_mem>
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	eb 07                	jmp    80150d <malloc+0x21a>
		
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
  801544:	e8 f0 08 00 00       	call   801e39 <get_block_size>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80154f:	83 ec 0c             	sub    $0xc,%esp
  801552:	ff 75 08             	pushl  0x8(%ebp)
  801555:	e8 00 1b 00 00       	call   80305a <free_block>
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
  80158f:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  8015cc:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  8015d3:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8015d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	83 ec 08             	sub    $0x8,%esp
  8015e0:	52                   	push   %edx
  8015e1:	50                   	push   %eax
  8015e2:	e8 1a 08 00 00       	call   801e01 <sys_free_user_mem>
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
  8015fa:	68 f8 42 80 00       	push   $0x8042f8
  8015ff:	68 87 00 00 00       	push   $0x87
  801604:	68 22 43 80 00       	push   $0x804322
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
  801628:	e9 87 00 00 00       	jmp    8016b4 <smalloc+0xa3>
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
  801659:	75 07                	jne    801662 <smalloc+0x51>
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
  801660:	eb 52                	jmp    8016b4 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801662:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801666:	ff 75 ec             	pushl  -0x14(%ebp)
  801669:	50                   	push   %eax
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	ff 75 08             	pushl  0x8(%ebp)
  801670:	e8 93 03 00 00       	call   801a08 <sys_createSharedObject>
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80167b:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80167f:	74 06                	je     801687 <smalloc+0x76>
  801681:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801685:	75 07                	jne    80168e <smalloc+0x7d>
  801687:	b8 00 00 00 00       	mov    $0x0,%eax
  80168c:	eb 26                	jmp    8016b4 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80168e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801691:	a1 20 50 80 00       	mov    0x805020,%eax
  801696:	8b 40 78             	mov    0x78(%eax),%eax
  801699:	29 c2                	sub    %eax,%edx
  80169b:	89 d0                	mov    %edx,%eax
  80169d:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016a2:	c1 e8 0c             	shr    $0xc,%eax
  8016a5:	89 c2                	mov    %eax,%edx
  8016a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016aa:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016bc:	83 ec 08             	sub    $0x8,%esp
  8016bf:	ff 75 0c             	pushl  0xc(%ebp)
  8016c2:	ff 75 08             	pushl  0x8(%ebp)
  8016c5:	e8 68 03 00 00       	call   801a32 <sys_getSizeOfSharedObject>
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016d0:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016d4:	75 07                	jne    8016dd <sget+0x27>
  8016d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016db:	eb 7f                	jmp    80175c <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f0:	39 d0                	cmp    %edx,%eax
  8016f2:	73 02                	jae    8016f6 <sget+0x40>
  8016f4:	89 d0                	mov    %edx,%eax
  8016f6:	83 ec 0c             	sub    $0xc,%esp
  8016f9:	50                   	push   %eax
  8016fa:	e8 f4 fb ff ff       	call   8012f3 <malloc>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801705:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801709:	75 07                	jne    801712 <sget+0x5c>
  80170b:	b8 00 00 00 00       	mov    $0x0,%eax
  801710:	eb 4a                	jmp    80175c <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801712:	83 ec 04             	sub    $0x4,%esp
  801715:	ff 75 e8             	pushl  -0x18(%ebp)
  801718:	ff 75 0c             	pushl  0xc(%ebp)
  80171b:	ff 75 08             	pushl  0x8(%ebp)
  80171e:	e8 2c 03 00 00       	call   801a4f <sys_getSharedObject>
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801729:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80172c:	a1 20 50 80 00       	mov    0x805020,%eax
  801731:	8b 40 78             	mov    0x78(%eax),%eax
  801734:	29 c2                	sub    %eax,%edx
  801736:	89 d0                	mov    %edx,%eax
  801738:	2d 00 10 00 00       	sub    $0x1000,%eax
  80173d:	c1 e8 0c             	shr    $0xc,%eax
  801740:	89 c2                	mov    %eax,%edx
  801742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801745:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80174c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801750:	75 07                	jne    801759 <sget+0xa3>
  801752:	b8 00 00 00 00       	mov    $0x0,%eax
  801757:	eb 03                	jmp    80175c <sget+0xa6>
	return ptr;
  801759:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801764:	8b 55 08             	mov    0x8(%ebp),%edx
  801767:	a1 20 50 80 00       	mov    0x805020,%eax
  80176c:	8b 40 78             	mov    0x78(%eax),%eax
  80176f:	29 c2                	sub    %eax,%edx
  801771:	89 d0                	mov    %edx,%eax
  801773:	2d 00 10 00 00       	sub    $0x1000,%eax
  801778:	c1 e8 0c             	shr    $0xc,%eax
  80177b:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801782:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801785:	83 ec 08             	sub    $0x8,%esp
  801788:	ff 75 08             	pushl  0x8(%ebp)
  80178b:	ff 75 f4             	pushl  -0xc(%ebp)
  80178e:	e8 db 02 00 00       	call   801a6e <sys_freeSharedObject>
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801799:	90                   	nop
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	68 30 43 80 00       	push   $0x804330
  8017aa:	68 e4 00 00 00       	push   $0xe4
  8017af:	68 22 43 80 00       	push   $0x804322
  8017b4:	e8 cd ea ff ff       	call   800286 <_panic>

008017b9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 56 43 80 00       	push   $0x804356
  8017c7:	68 f0 00 00 00       	push   $0xf0
  8017cc:	68 22 43 80 00       	push   $0x804322
  8017d1:	e8 b0 ea ff ff       	call   800286 <_panic>

008017d6 <shrink>:

}
void shrink(uint32 newSize)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	68 56 43 80 00       	push   $0x804356
  8017e4:	68 f5 00 00 00       	push   $0xf5
  8017e9:	68 22 43 80 00       	push   $0x804322
  8017ee:	e8 93 ea ff ff       	call   800286 <_panic>

008017f3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	68 56 43 80 00       	push   $0x804356
  801801:	68 fa 00 00 00       	push   $0xfa
  801806:	68 22 43 80 00       	push   $0x804322
  80180b:	e8 76 ea ff ff       	call   800286 <_panic>

00801810 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	57                   	push   %edi
  801814:	56                   	push   %esi
  801815:	53                   	push   %ebx
  801816:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801822:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801825:	8b 7d 18             	mov    0x18(%ebp),%edi
  801828:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80182b:	cd 30                	int    $0x30
  80182d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801830:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	5b                   	pop    %ebx
  801837:	5e                   	pop    %esi
  801838:	5f                   	pop    %edi
  801839:	5d                   	pop    %ebp
  80183a:	c3                   	ret    

0080183b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 04             	sub    $0x4,%esp
  801841:	8b 45 10             	mov    0x10(%ebp),%eax
  801844:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801847:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	52                   	push   %edx
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	50                   	push   %eax
  801857:	6a 00                	push   $0x0
  801859:	e8 b2 ff ff ff       	call   801810 <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	90                   	nop
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_cgetc>:

int
sys_cgetc(void)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 02                	push   $0x2
  801873:	e8 98 ff ff ff       	call   801810 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 03                	push   $0x3
  80188c:	e8 7f ff ff ff       	call   801810 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	90                   	nop
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 04                	push   $0x4
  8018a6:	e8 65 ff ff ff       	call   801810 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	90                   	nop
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	52                   	push   %edx
  8018c1:	50                   	push   %eax
  8018c2:	6a 08                	push   $0x8
  8018c4:	e8 47 ff ff ff       	call   801810 <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	56                   	push   %esi
  8018d2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018d3:	8b 75 18             	mov    0x18(%ebp),%esi
  8018d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	56                   	push   %esi
  8018e3:	53                   	push   %ebx
  8018e4:	51                   	push   %ecx
  8018e5:	52                   	push   %edx
  8018e6:	50                   	push   %eax
  8018e7:	6a 09                	push   $0x9
  8018e9:	e8 22 ff ff ff       	call   801810 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f4:	5b                   	pop    %ebx
  8018f5:	5e                   	pop    %esi
  8018f6:	5d                   	pop    %ebp
  8018f7:	c3                   	ret    

008018f8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	52                   	push   %edx
  801908:	50                   	push   %eax
  801909:	6a 0a                	push   $0xa
  80190b:	e8 00 ff ff ff       	call   801810 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	ff 75 0c             	pushl  0xc(%ebp)
  801921:	ff 75 08             	pushl  0x8(%ebp)
  801924:	6a 0b                	push   $0xb
  801926:	e8 e5 fe ff ff       	call   801810 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 0c                	push   $0xc
  80193f:	e8 cc fe ff ff       	call   801810 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 0d                	push   $0xd
  801958:	e8 b3 fe ff ff       	call   801810 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 0e                	push   $0xe
  801971:	e8 9a fe ff ff       	call   801810 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 0f                	push   $0xf
  80198a:	e8 81 fe ff ff       	call   801810 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	6a 10                	push   $0x10
  8019a4:	e8 67 fe ff ff       	call   801810 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 11                	push   $0x11
  8019bd:	e8 4e fe ff ff       	call   801810 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	90                   	nop
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019d4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	50                   	push   %eax
  8019e1:	6a 01                	push   $0x1
  8019e3:	e8 28 fe ff ff       	call   801810 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	90                   	nop
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 14                	push   $0x14
  8019fd:	e8 0e fe ff ff       	call   801810 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	90                   	nop
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a11:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a14:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a17:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	6a 00                	push   $0x0
  801a20:	51                   	push   %ecx
  801a21:	52                   	push   %edx
  801a22:	ff 75 0c             	pushl  0xc(%ebp)
  801a25:	50                   	push   %eax
  801a26:	6a 15                	push   $0x15
  801a28:	e8 e3 fd ff ff       	call   801810 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	52                   	push   %edx
  801a42:	50                   	push   %eax
  801a43:	6a 16                	push   $0x16
  801a45:	e8 c6 fd ff ff       	call   801810 <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	51                   	push   %ecx
  801a60:	52                   	push   %edx
  801a61:	50                   	push   %eax
  801a62:	6a 17                	push   $0x17
  801a64:	e8 a7 fd ff ff       	call   801810 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	52                   	push   %edx
  801a7e:	50                   	push   %eax
  801a7f:	6a 18                	push   $0x18
  801a81:	e8 8a fd ff ff       	call   801810 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	ff 75 14             	pushl  0x14(%ebp)
  801a96:	ff 75 10             	pushl  0x10(%ebp)
  801a99:	ff 75 0c             	pushl  0xc(%ebp)
  801a9c:	50                   	push   %eax
  801a9d:	6a 19                	push   $0x19
  801a9f:	e8 6c fd ff ff       	call   801810 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	50                   	push   %eax
  801ab8:	6a 1a                	push   $0x1a
  801aba:	e8 51 fd ff ff       	call   801810 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	90                   	nop
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	50                   	push   %eax
  801ad4:	6a 1b                	push   $0x1b
  801ad6:	e8 35 fd ff ff       	call   801810 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 05                	push   $0x5
  801aef:	e8 1c fd ff ff       	call   801810 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 06                	push   $0x6
  801b08:	e8 03 fd ff ff       	call   801810 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 07                	push   $0x7
  801b21:	e8 ea fc ff ff       	call   801810 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_exit_env>:


void sys_exit_env(void)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 1c                	push   $0x1c
  801b3a:	e8 d1 fc ff ff       	call   801810 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	90                   	nop
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b4b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b4e:	8d 50 04             	lea    0x4(%eax),%edx
  801b51:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	6a 1d                	push   $0x1d
  801b5e:	e8 ad fc ff ff       	call   801810 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
	return result;
  801b66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b6f:	89 01                	mov    %eax,(%ecx)
  801b71:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	c9                   	leave  
  801b78:	c2 04 00             	ret    $0x4

00801b7b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	ff 75 10             	pushl  0x10(%ebp)
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	ff 75 08             	pushl  0x8(%ebp)
  801b8b:	6a 13                	push   $0x13
  801b8d:	e8 7e fc ff ff       	call   801810 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
	return ;
  801b95:	90                   	nop
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 1e                	push   $0x1e
  801ba7:	e8 64 fc ff ff       	call   801810 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bbd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	50                   	push   %eax
  801bca:	6a 1f                	push   $0x1f
  801bcc:	e8 3f fc ff ff       	call   801810 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd4:	90                   	nop
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <rsttst>:
void rsttst()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 21                	push   $0x21
  801be6:	e8 25 fc ff ff       	call   801810 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bee:	90                   	nop
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 04             	sub    $0x4,%esp
  801bf7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bfd:	8b 55 18             	mov    0x18(%ebp),%edx
  801c00:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c04:	52                   	push   %edx
  801c05:	50                   	push   %eax
  801c06:	ff 75 10             	pushl  0x10(%ebp)
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	6a 20                	push   $0x20
  801c11:	e8 fa fb ff ff       	call   801810 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
	return ;
  801c19:	90                   	nop
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <chktst>:
void chktst(uint32 n)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	ff 75 08             	pushl  0x8(%ebp)
  801c2a:	6a 22                	push   $0x22
  801c2c:	e8 df fb ff ff       	call   801810 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
	return ;
  801c34:	90                   	nop
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <inctst>:

void inctst()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 23                	push   $0x23
  801c46:	e8 c5 fb ff ff       	call   801810 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4e:	90                   	nop
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <gettst>:
uint32 gettst()
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 24                	push   $0x24
  801c60:	e8 ab fb ff ff       	call   801810 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 25                	push   $0x25
  801c7c:	e8 8f fb ff ff       	call   801810 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
  801c84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c87:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c8b:	75 07                	jne    801c94 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c92:	eb 05                	jmp    801c99 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 25                	push   $0x25
  801cad:	e8 5e fb ff ff       	call   801810 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
  801cb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cb8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cbc:	75 07                	jne    801cc5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc3:	eb 05                	jmp    801cca <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 25                	push   $0x25
  801cde:	e8 2d fb ff ff       	call   801810 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
  801ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ce9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ced:	75 07                	jne    801cf6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cef:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf4:	eb 05                	jmp    801cfb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 25                	push   $0x25
  801d0f:	e8 fc fa ff ff       	call   801810 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
  801d17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d1a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d1e:	75 07                	jne    801d27 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d20:	b8 01 00 00 00       	mov    $0x1,%eax
  801d25:	eb 05                	jmp    801d2c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	ff 75 08             	pushl  0x8(%ebp)
  801d3c:	6a 26                	push   $0x26
  801d3e:	e8 cd fa ff ff       	call   801810 <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
	return ;
  801d46:	90                   	nop
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d50:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	53                   	push   %ebx
  801d5c:	51                   	push   %ecx
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	6a 27                	push   $0x27
  801d61:	e8 aa fa ff ff       	call   801810 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	52                   	push   %edx
  801d7e:	50                   	push   %eax
  801d7f:	6a 28                	push   $0x28
  801d81:	e8 8a fa ff ff       	call   801810 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	6a 00                	push   $0x0
  801d99:	51                   	push   %ecx
  801d9a:	ff 75 10             	pushl  0x10(%ebp)
  801d9d:	52                   	push   %edx
  801d9e:	50                   	push   %eax
  801d9f:	6a 29                	push   $0x29
  801da1:	e8 6a fa ff ff       	call   801810 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	ff 75 10             	pushl  0x10(%ebp)
  801db5:	ff 75 0c             	pushl  0xc(%ebp)
  801db8:	ff 75 08             	pushl  0x8(%ebp)
  801dbb:	6a 12                	push   $0x12
  801dbd:	e8 4e fa ff ff       	call   801810 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc5:	90                   	nop
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	52                   	push   %edx
  801dd8:	50                   	push   %eax
  801dd9:	6a 2a                	push   $0x2a
  801ddb:	e8 30 fa ff ff       	call   801810 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
	return;
  801de3:	90                   	nop
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	50                   	push   %eax
  801df5:	6a 2b                	push   $0x2b
  801df7:	e8 14 fa ff ff       	call   801810 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	ff 75 0c             	pushl  0xc(%ebp)
  801e0d:	ff 75 08             	pushl  0x8(%ebp)
  801e10:	6a 2c                	push   $0x2c
  801e12:	e8 f9 f9 ff ff       	call   801810 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
	return;
  801e1a:	90                   	nop
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	ff 75 08             	pushl  0x8(%ebp)
  801e2c:	6a 2d                	push   $0x2d
  801e2e:	e8 dd f9 ff ff       	call   801810 <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
	return;
  801e36:	90                   	nop
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	83 e8 04             	sub    $0x4,%eax
  801e45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4b:	8b 00                	mov    (%eax),%eax
  801e4d:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	83 e8 04             	sub    $0x4,%eax
  801e5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e64:	8b 00                	mov    (%eax),%eax
  801e66:	83 e0 01             	and    $0x1,%eax
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	0f 94 c0             	sete   %al
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e80:	83 f8 02             	cmp    $0x2,%eax
  801e83:	74 2b                	je     801eb0 <alloc_block+0x40>
  801e85:	83 f8 02             	cmp    $0x2,%eax
  801e88:	7f 07                	jg     801e91 <alloc_block+0x21>
  801e8a:	83 f8 01             	cmp    $0x1,%eax
  801e8d:	74 0e                	je     801e9d <alloc_block+0x2d>
  801e8f:	eb 58                	jmp    801ee9 <alloc_block+0x79>
  801e91:	83 f8 03             	cmp    $0x3,%eax
  801e94:	74 2d                	je     801ec3 <alloc_block+0x53>
  801e96:	83 f8 04             	cmp    $0x4,%eax
  801e99:	74 3b                	je     801ed6 <alloc_block+0x66>
  801e9b:	eb 4c                	jmp    801ee9 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e9d:	83 ec 0c             	sub    $0xc,%esp
  801ea0:	ff 75 08             	pushl  0x8(%ebp)
  801ea3:	e8 11 03 00 00       	call   8021b9 <alloc_block_FF>
  801ea8:	83 c4 10             	add    $0x10,%esp
  801eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eae:	eb 4a                	jmp    801efa <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	ff 75 08             	pushl  0x8(%ebp)
  801eb6:	e8 c7 19 00 00       	call   803882 <alloc_block_NF>
  801ebb:	83 c4 10             	add    $0x10,%esp
  801ebe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ec1:	eb 37                	jmp    801efa <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ec3:	83 ec 0c             	sub    $0xc,%esp
  801ec6:	ff 75 08             	pushl  0x8(%ebp)
  801ec9:	e8 a7 07 00 00       	call   802675 <alloc_block_BF>
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ed4:	eb 24                	jmp    801efa <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ed6:	83 ec 0c             	sub    $0xc,%esp
  801ed9:	ff 75 08             	pushl  0x8(%ebp)
  801edc:	e8 84 19 00 00       	call   803865 <alloc_block_WF>
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ee7:	eb 11                	jmp    801efa <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ee9:	83 ec 0c             	sub    $0xc,%esp
  801eec:	68 68 43 80 00       	push   $0x804368
  801ef1:	e8 4d e6 ff ff       	call   800543 <cprintf>
  801ef6:	83 c4 10             	add    $0x10,%esp
		break;
  801ef9:	90                   	nop
	}
	return va;
  801efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	53                   	push   %ebx
  801f03:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f06:	83 ec 0c             	sub    $0xc,%esp
  801f09:	68 88 43 80 00       	push   $0x804388
  801f0e:	e8 30 e6 ff ff       	call   800543 <cprintf>
  801f13:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f16:	83 ec 0c             	sub    $0xc,%esp
  801f19:	68 b3 43 80 00       	push   $0x8043b3
  801f1e:	e8 20 e6 ff ff       	call   800543 <cprintf>
  801f23:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2c:	eb 37                	jmp    801f65 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f2e:	83 ec 0c             	sub    $0xc,%esp
  801f31:	ff 75 f4             	pushl  -0xc(%ebp)
  801f34:	e8 19 ff ff ff       	call   801e52 <is_free_block>
  801f39:	83 c4 10             	add    $0x10,%esp
  801f3c:	0f be d8             	movsbl %al,%ebx
  801f3f:	83 ec 0c             	sub    $0xc,%esp
  801f42:	ff 75 f4             	pushl  -0xc(%ebp)
  801f45:	e8 ef fe ff ff       	call   801e39 <get_block_size>
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	83 ec 04             	sub    $0x4,%esp
  801f50:	53                   	push   %ebx
  801f51:	50                   	push   %eax
  801f52:	68 cb 43 80 00       	push   $0x8043cb
  801f57:	e8 e7 e5 ff ff       	call   800543 <cprintf>
  801f5c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f69:	74 07                	je     801f72 <print_blocks_list+0x73>
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 00                	mov    (%eax),%eax
  801f70:	eb 05                	jmp    801f77 <print_blocks_list+0x78>
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
  801f77:	89 45 10             	mov    %eax,0x10(%ebp)
  801f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	75 ad                	jne    801f2e <print_blocks_list+0x2f>
  801f81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f85:	75 a7                	jne    801f2e <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f87:	83 ec 0c             	sub    $0xc,%esp
  801f8a:	68 88 43 80 00       	push   $0x804388
  801f8f:	e8 af e5 ff ff       	call   800543 <cprintf>
  801f94:	83 c4 10             	add    $0x10,%esp

}
  801f97:	90                   	nop
  801f98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa6:	83 e0 01             	and    $0x1,%eax
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	74 03                	je     801fb0 <initialize_dynamic_allocator+0x13>
  801fad:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fb4:	0f 84 c7 01 00 00    	je     802181 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801fba:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801fc1:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fca:	01 d0                	add    %edx,%eax
  801fcc:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801fd1:	0f 87 ad 01 00 00    	ja     802184 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	0f 89 a5 01 00 00    	jns    802187 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe8:	01 d0                	add    %edx,%eax
  801fea:	83 e8 04             	sub    $0x4,%eax
  801fed:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801ff9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802001:	e9 87 00 00 00       	jmp    80208d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802006:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200a:	75 14                	jne    802020 <initialize_dynamic_allocator+0x83>
  80200c:	83 ec 04             	sub    $0x4,%esp
  80200f:	68 e3 43 80 00       	push   $0x8043e3
  802014:	6a 79                	push   $0x79
  802016:	68 01 44 80 00       	push   $0x804401
  80201b:	e8 66 e2 ff ff       	call   800286 <_panic>
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	8b 00                	mov    (%eax),%eax
  802025:	85 c0                	test   %eax,%eax
  802027:	74 10                	je     802039 <initialize_dynamic_allocator+0x9c>
  802029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202c:	8b 00                	mov    (%eax),%eax
  80202e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802031:	8b 52 04             	mov    0x4(%edx),%edx
  802034:	89 50 04             	mov    %edx,0x4(%eax)
  802037:	eb 0b                	jmp    802044 <initialize_dynamic_allocator+0xa7>
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	8b 40 04             	mov    0x4(%eax),%eax
  80203f:	a3 30 50 80 00       	mov    %eax,0x805030
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 40 04             	mov    0x4(%eax),%eax
  80204a:	85 c0                	test   %eax,%eax
  80204c:	74 0f                	je     80205d <initialize_dynamic_allocator+0xc0>
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	8b 40 04             	mov    0x4(%eax),%eax
  802054:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802057:	8b 12                	mov    (%edx),%edx
  802059:	89 10                	mov    %edx,(%eax)
  80205b:	eb 0a                	jmp    802067 <initialize_dynamic_allocator+0xca>
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	8b 00                	mov    (%eax),%eax
  802062:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802073:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80207a:	a1 38 50 80 00       	mov    0x805038,%eax
  80207f:	48                   	dec    %eax
  802080:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802085:	a1 34 50 80 00       	mov    0x805034,%eax
  80208a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802091:	74 07                	je     80209a <initialize_dynamic_allocator+0xfd>
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	8b 00                	mov    (%eax),%eax
  802098:	eb 05                	jmp    80209f <initialize_dynamic_allocator+0x102>
  80209a:	b8 00 00 00 00       	mov    $0x0,%eax
  80209f:	a3 34 50 80 00       	mov    %eax,0x805034
  8020a4:	a1 34 50 80 00       	mov    0x805034,%eax
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	0f 85 55 ff ff ff    	jne    802006 <initialize_dynamic_allocator+0x69>
  8020b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b5:	0f 85 4b ff ff ff    	jne    802006 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8020ca:	a1 44 50 80 00       	mov    0x805044,%eax
  8020cf:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8020d4:	a1 40 50 80 00       	mov    0x805040,%eax
  8020d9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	83 c0 08             	add    $0x8,%eax
  8020e5:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	83 c0 04             	add    $0x4,%eax
  8020ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f1:	83 ea 08             	sub    $0x8,%edx
  8020f4:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	01 d0                	add    %edx,%eax
  8020fe:	83 e8 08             	sub    $0x8,%eax
  802101:	8b 55 0c             	mov    0xc(%ebp),%edx
  802104:	83 ea 08             	sub    $0x8,%edx
  802107:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802112:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802115:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80211c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802120:	75 17                	jne    802139 <initialize_dynamic_allocator+0x19c>
  802122:	83 ec 04             	sub    $0x4,%esp
  802125:	68 1c 44 80 00       	push   $0x80441c
  80212a:	68 90 00 00 00       	push   $0x90
  80212f:	68 01 44 80 00       	push   $0x804401
  802134:	e8 4d e1 ff ff       	call   800286 <_panic>
  802139:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80213f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802142:	89 10                	mov    %edx,(%eax)
  802144:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802147:	8b 00                	mov    (%eax),%eax
  802149:	85 c0                	test   %eax,%eax
  80214b:	74 0d                	je     80215a <initialize_dynamic_allocator+0x1bd>
  80214d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802152:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802155:	89 50 04             	mov    %edx,0x4(%eax)
  802158:	eb 08                	jmp    802162 <initialize_dynamic_allocator+0x1c5>
  80215a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215d:	a3 30 50 80 00       	mov    %eax,0x805030
  802162:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802165:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80216a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802174:	a1 38 50 80 00       	mov    0x805038,%eax
  802179:	40                   	inc    %eax
  80217a:	a3 38 50 80 00       	mov    %eax,0x805038
  80217f:	eb 07                	jmp    802188 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802181:	90                   	nop
  802182:	eb 04                	jmp    802188 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802184:	90                   	nop
  802185:	eb 01                	jmp    802188 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802187:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80218d:	8b 45 10             	mov    0x10(%ebp),%eax
  802190:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8d 50 fc             	lea    -0x4(%eax),%edx
  802199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	83 e8 04             	sub    $0x4,%eax
  8021a4:	8b 00                	mov    (%eax),%eax
  8021a6:	83 e0 fe             	and    $0xfffffffe,%eax
  8021a9:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	01 c2                	add    %eax,%edx
  8021b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b4:	89 02                	mov    %eax,(%edx)
}
  8021b6:	90                   	nop
  8021b7:	5d                   	pop    %ebp
  8021b8:	c3                   	ret    

008021b9 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	83 e0 01             	and    $0x1,%eax
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	74 03                	je     8021cc <alloc_block_FF+0x13>
  8021c9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8021cc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8021d0:	77 07                	ja     8021d9 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8021d2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021d9:	a1 24 50 80 00       	mov    0x805024,%eax
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	75 73                	jne    802255 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	83 c0 10             	add    $0x10,%eax
  8021e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021eb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8021f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f8:	01 d0                	add    %edx,%eax
  8021fa:	48                   	dec    %eax
  8021fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802201:	ba 00 00 00 00       	mov    $0x0,%edx
  802206:	f7 75 ec             	divl   -0x14(%ebp)
  802209:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80220c:	29 d0                	sub    %edx,%eax
  80220e:	c1 e8 0c             	shr    $0xc,%eax
  802211:	83 ec 0c             	sub    $0xc,%esp
  802214:	50                   	push   %eax
  802215:	e8 c3 f0 ff ff       	call   8012dd <sbrk>
  80221a:	83 c4 10             	add    $0x10,%esp
  80221d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802220:	83 ec 0c             	sub    $0xc,%esp
  802223:	6a 00                	push   $0x0
  802225:	e8 b3 f0 ff ff       	call   8012dd <sbrk>
  80222a:	83 c4 10             	add    $0x10,%esp
  80222d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802233:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802236:	83 ec 08             	sub    $0x8,%esp
  802239:	50                   	push   %eax
  80223a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80223d:	e8 5b fd ff ff       	call   801f9d <initialize_dynamic_allocator>
  802242:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802245:	83 ec 0c             	sub    $0xc,%esp
  802248:	68 3f 44 80 00       	push   $0x80443f
  80224d:	e8 f1 e2 ff ff       	call   800543 <cprintf>
  802252:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802255:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802259:	75 0a                	jne    802265 <alloc_block_FF+0xac>
	        return NULL;
  80225b:	b8 00 00 00 00       	mov    $0x0,%eax
  802260:	e9 0e 04 00 00       	jmp    802673 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802265:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80226c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802271:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802274:	e9 f3 02 00 00       	jmp    80256c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80227f:	83 ec 0c             	sub    $0xc,%esp
  802282:	ff 75 bc             	pushl  -0x44(%ebp)
  802285:	e8 af fb ff ff       	call   801e39 <get_block_size>
  80228a:	83 c4 10             	add    $0x10,%esp
  80228d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	83 c0 08             	add    $0x8,%eax
  802296:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802299:	0f 87 c5 02 00 00    	ja     802564 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	83 c0 18             	add    $0x18,%eax
  8022a5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022a8:	0f 87 19 02 00 00    	ja     8024c7 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8022b4:	83 e8 08             	sub    $0x8,%eax
  8022b7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	8d 50 08             	lea    0x8(%eax),%edx
  8022c0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022c3:	01 d0                	add    %edx,%eax
  8022c5:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	83 c0 08             	add    $0x8,%eax
  8022ce:	83 ec 04             	sub    $0x4,%esp
  8022d1:	6a 01                	push   $0x1
  8022d3:	50                   	push   %eax
  8022d4:	ff 75 bc             	pushl  -0x44(%ebp)
  8022d7:	e8 ae fe ff ff       	call   80218a <set_block_data>
  8022dc:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 40 04             	mov    0x4(%eax),%eax
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	75 68                	jne    802351 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022e9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022ed:	75 17                	jne    802306 <alloc_block_FF+0x14d>
  8022ef:	83 ec 04             	sub    $0x4,%esp
  8022f2:	68 1c 44 80 00       	push   $0x80441c
  8022f7:	68 d7 00 00 00       	push   $0xd7
  8022fc:	68 01 44 80 00       	push   $0x804401
  802301:	e8 80 df ff ff       	call   800286 <_panic>
  802306:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80230c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80230f:	89 10                	mov    %edx,(%eax)
  802311:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802314:	8b 00                	mov    (%eax),%eax
  802316:	85 c0                	test   %eax,%eax
  802318:	74 0d                	je     802327 <alloc_block_FF+0x16e>
  80231a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80231f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802322:	89 50 04             	mov    %edx,0x4(%eax)
  802325:	eb 08                	jmp    80232f <alloc_block_FF+0x176>
  802327:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80232a:	a3 30 50 80 00       	mov    %eax,0x805030
  80232f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802332:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802337:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80233a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802341:	a1 38 50 80 00       	mov    0x805038,%eax
  802346:	40                   	inc    %eax
  802347:	a3 38 50 80 00       	mov    %eax,0x805038
  80234c:	e9 dc 00 00 00       	jmp    80242d <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	75 65                	jne    8023bf <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80235a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80235e:	75 17                	jne    802377 <alloc_block_FF+0x1be>
  802360:	83 ec 04             	sub    $0x4,%esp
  802363:	68 50 44 80 00       	push   $0x804450
  802368:	68 db 00 00 00       	push   $0xdb
  80236d:	68 01 44 80 00       	push   $0x804401
  802372:	e8 0f df ff ff       	call   800286 <_panic>
  802377:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80237d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802380:	89 50 04             	mov    %edx,0x4(%eax)
  802383:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802386:	8b 40 04             	mov    0x4(%eax),%eax
  802389:	85 c0                	test   %eax,%eax
  80238b:	74 0c                	je     802399 <alloc_block_FF+0x1e0>
  80238d:	a1 30 50 80 00       	mov    0x805030,%eax
  802392:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802395:	89 10                	mov    %edx,(%eax)
  802397:	eb 08                	jmp    8023a1 <alloc_block_FF+0x1e8>
  802399:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80239c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8023a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8023b7:	40                   	inc    %eax
  8023b8:	a3 38 50 80 00       	mov    %eax,0x805038
  8023bd:	eb 6e                	jmp    80242d <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c3:	74 06                	je     8023cb <alloc_block_FF+0x212>
  8023c5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023c9:	75 17                	jne    8023e2 <alloc_block_FF+0x229>
  8023cb:	83 ec 04             	sub    $0x4,%esp
  8023ce:	68 74 44 80 00       	push   $0x804474
  8023d3:	68 df 00 00 00       	push   $0xdf
  8023d8:	68 01 44 80 00       	push   $0x804401
  8023dd:	e8 a4 de ff ff       	call   800286 <_panic>
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 10                	mov    (%eax),%edx
  8023e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ea:	89 10                	mov    %edx,(%eax)
  8023ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ef:	8b 00                	mov    (%eax),%eax
  8023f1:	85 c0                	test   %eax,%eax
  8023f3:	74 0b                	je     802400 <alloc_block_FF+0x247>
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023fd:	89 50 04             	mov    %edx,0x4(%eax)
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802403:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802406:	89 10                	mov    %edx,(%eax)
  802408:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240e:	89 50 04             	mov    %edx,0x4(%eax)
  802411:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802414:	8b 00                	mov    (%eax),%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	75 08                	jne    802422 <alloc_block_FF+0x269>
  80241a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241d:	a3 30 50 80 00       	mov    %eax,0x805030
  802422:	a1 38 50 80 00       	mov    0x805038,%eax
  802427:	40                   	inc    %eax
  802428:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80242d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802431:	75 17                	jne    80244a <alloc_block_FF+0x291>
  802433:	83 ec 04             	sub    $0x4,%esp
  802436:	68 e3 43 80 00       	push   $0x8043e3
  80243b:	68 e1 00 00 00       	push   $0xe1
  802440:	68 01 44 80 00       	push   $0x804401
  802445:	e8 3c de ff ff       	call   800286 <_panic>
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 00                	mov    (%eax),%eax
  80244f:	85 c0                	test   %eax,%eax
  802451:	74 10                	je     802463 <alloc_block_FF+0x2aa>
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245b:	8b 52 04             	mov    0x4(%edx),%edx
  80245e:	89 50 04             	mov    %edx,0x4(%eax)
  802461:	eb 0b                	jmp    80246e <alloc_block_FF+0x2b5>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 40 04             	mov    0x4(%eax),%eax
  802469:	a3 30 50 80 00       	mov    %eax,0x805030
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 40 04             	mov    0x4(%eax),%eax
  802474:	85 c0                	test   %eax,%eax
  802476:	74 0f                	je     802487 <alloc_block_FF+0x2ce>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 40 04             	mov    0x4(%eax),%eax
  80247e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802481:	8b 12                	mov    (%edx),%edx
  802483:	89 10                	mov    %edx,(%eax)
  802485:	eb 0a                	jmp    802491 <alloc_block_FF+0x2d8>
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 00                	mov    (%eax),%eax
  80248c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8024a9:	48                   	dec    %eax
  8024aa:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024af:	83 ec 04             	sub    $0x4,%esp
  8024b2:	6a 00                	push   $0x0
  8024b4:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024b7:	ff 75 b0             	pushl  -0x50(%ebp)
  8024ba:	e8 cb fc ff ff       	call   80218a <set_block_data>
  8024bf:	83 c4 10             	add    $0x10,%esp
  8024c2:	e9 95 00 00 00       	jmp    80255c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024c7:	83 ec 04             	sub    $0x4,%esp
  8024ca:	6a 01                	push   $0x1
  8024cc:	ff 75 b8             	pushl  -0x48(%ebp)
  8024cf:	ff 75 bc             	pushl  -0x44(%ebp)
  8024d2:	e8 b3 fc ff ff       	call   80218a <set_block_data>
  8024d7:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024de:	75 17                	jne    8024f7 <alloc_block_FF+0x33e>
  8024e0:	83 ec 04             	sub    $0x4,%esp
  8024e3:	68 e3 43 80 00       	push   $0x8043e3
  8024e8:	68 e8 00 00 00       	push   $0xe8
  8024ed:	68 01 44 80 00       	push   $0x804401
  8024f2:	e8 8f dd ff ff       	call   800286 <_panic>
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	8b 00                	mov    (%eax),%eax
  8024fc:	85 c0                	test   %eax,%eax
  8024fe:	74 10                	je     802510 <alloc_block_FF+0x357>
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 00                	mov    (%eax),%eax
  802505:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802508:	8b 52 04             	mov    0x4(%edx),%edx
  80250b:	89 50 04             	mov    %edx,0x4(%eax)
  80250e:	eb 0b                	jmp    80251b <alloc_block_FF+0x362>
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 40 04             	mov    0x4(%eax),%eax
  802516:	a3 30 50 80 00       	mov    %eax,0x805030
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 40 04             	mov    0x4(%eax),%eax
  802521:	85 c0                	test   %eax,%eax
  802523:	74 0f                	je     802534 <alloc_block_FF+0x37b>
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 40 04             	mov    0x4(%eax),%eax
  80252b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252e:	8b 12                	mov    (%edx),%edx
  802530:	89 10                	mov    %edx,(%eax)
  802532:	eb 0a                	jmp    80253e <alloc_block_FF+0x385>
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 00                	mov    (%eax),%eax
  802539:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802551:	a1 38 50 80 00       	mov    0x805038,%eax
  802556:	48                   	dec    %eax
  802557:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80255c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80255f:	e9 0f 01 00 00       	jmp    802673 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802564:	a1 34 50 80 00       	mov    0x805034,%eax
  802569:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802570:	74 07                	je     802579 <alloc_block_FF+0x3c0>
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 00                	mov    (%eax),%eax
  802577:	eb 05                	jmp    80257e <alloc_block_FF+0x3c5>
  802579:	b8 00 00 00 00       	mov    $0x0,%eax
  80257e:	a3 34 50 80 00       	mov    %eax,0x805034
  802583:	a1 34 50 80 00       	mov    0x805034,%eax
  802588:	85 c0                	test   %eax,%eax
  80258a:	0f 85 e9 fc ff ff    	jne    802279 <alloc_block_FF+0xc0>
  802590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802594:	0f 85 df fc ff ff    	jne    802279 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	83 c0 08             	add    $0x8,%eax
  8025a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8025a3:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025b0:	01 d0                	add    %edx,%eax
  8025b2:	48                   	dec    %eax
  8025b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8025be:	f7 75 d8             	divl   -0x28(%ebp)
  8025c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025c4:	29 d0                	sub    %edx,%eax
  8025c6:	c1 e8 0c             	shr    $0xc,%eax
  8025c9:	83 ec 0c             	sub    $0xc,%esp
  8025cc:	50                   	push   %eax
  8025cd:	e8 0b ed ff ff       	call   8012dd <sbrk>
  8025d2:	83 c4 10             	add    $0x10,%esp
  8025d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025d8:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025dc:	75 0a                	jne    8025e8 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025de:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e3:	e9 8b 00 00 00       	jmp    802673 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025e8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025f5:	01 d0                	add    %edx,%eax
  8025f7:	48                   	dec    %eax
  8025f8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025fe:	ba 00 00 00 00       	mov    $0x0,%edx
  802603:	f7 75 cc             	divl   -0x34(%ebp)
  802606:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802609:	29 d0                	sub    %edx,%eax
  80260b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80260e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802611:	01 d0                	add    %edx,%eax
  802613:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802618:	a1 40 50 80 00       	mov    0x805040,%eax
  80261d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802623:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80262a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80262d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802630:	01 d0                	add    %edx,%eax
  802632:	48                   	dec    %eax
  802633:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802636:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802639:	ba 00 00 00 00       	mov    $0x0,%edx
  80263e:	f7 75 c4             	divl   -0x3c(%ebp)
  802641:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802644:	29 d0                	sub    %edx,%eax
  802646:	83 ec 04             	sub    $0x4,%esp
  802649:	6a 01                	push   $0x1
  80264b:	50                   	push   %eax
  80264c:	ff 75 d0             	pushl  -0x30(%ebp)
  80264f:	e8 36 fb ff ff       	call   80218a <set_block_data>
  802654:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802657:	83 ec 0c             	sub    $0xc,%esp
  80265a:	ff 75 d0             	pushl  -0x30(%ebp)
  80265d:	e8 f8 09 00 00       	call   80305a <free_block>
  802662:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802665:	83 ec 0c             	sub    $0xc,%esp
  802668:	ff 75 08             	pushl  0x8(%ebp)
  80266b:	e8 49 fb ff ff       	call   8021b9 <alloc_block_FF>
  802670:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	83 e0 01             	and    $0x1,%eax
  802681:	85 c0                	test   %eax,%eax
  802683:	74 03                	je     802688 <alloc_block_BF+0x13>
  802685:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802688:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80268c:	77 07                	ja     802695 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80268e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802695:	a1 24 50 80 00       	mov    0x805024,%eax
  80269a:	85 c0                	test   %eax,%eax
  80269c:	75 73                	jne    802711 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	83 c0 10             	add    $0x10,%eax
  8026a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026a7:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b4:	01 d0                	add    %edx,%eax
  8026b6:	48                   	dec    %eax
  8026b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c2:	f7 75 e0             	divl   -0x20(%ebp)
  8026c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026c8:	29 d0                	sub    %edx,%eax
  8026ca:	c1 e8 0c             	shr    $0xc,%eax
  8026cd:	83 ec 0c             	sub    $0xc,%esp
  8026d0:	50                   	push   %eax
  8026d1:	e8 07 ec ff ff       	call   8012dd <sbrk>
  8026d6:	83 c4 10             	add    $0x10,%esp
  8026d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026dc:	83 ec 0c             	sub    $0xc,%esp
  8026df:	6a 00                	push   $0x0
  8026e1:	e8 f7 eb ff ff       	call   8012dd <sbrk>
  8026e6:	83 c4 10             	add    $0x10,%esp
  8026e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ef:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8026f2:	83 ec 08             	sub    $0x8,%esp
  8026f5:	50                   	push   %eax
  8026f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8026f9:	e8 9f f8 ff ff       	call   801f9d <initialize_dynamic_allocator>
  8026fe:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802701:	83 ec 0c             	sub    $0xc,%esp
  802704:	68 3f 44 80 00       	push   $0x80443f
  802709:	e8 35 de ff ff       	call   800543 <cprintf>
  80270e:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802711:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802718:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80271f:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802726:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80272d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802732:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802735:	e9 1d 01 00 00       	jmp    802857 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802740:	83 ec 0c             	sub    $0xc,%esp
  802743:	ff 75 a8             	pushl  -0x58(%ebp)
  802746:	e8 ee f6 ff ff       	call   801e39 <get_block_size>
  80274b:	83 c4 10             	add    $0x10,%esp
  80274e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	83 c0 08             	add    $0x8,%eax
  802757:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80275a:	0f 87 ef 00 00 00    	ja     80284f <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	83 c0 18             	add    $0x18,%eax
  802766:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802769:	77 1d                	ja     802788 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80276b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802771:	0f 86 d8 00 00 00    	jbe    80284f <alloc_block_BF+0x1da>
				{
					best_va = va;
  802777:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80277a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80277d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802780:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802783:	e9 c7 00 00 00       	jmp    80284f <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	83 c0 08             	add    $0x8,%eax
  80278e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802791:	0f 85 9d 00 00 00    	jne    802834 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802797:	83 ec 04             	sub    $0x4,%esp
  80279a:	6a 01                	push   $0x1
  80279c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80279f:	ff 75 a8             	pushl  -0x58(%ebp)
  8027a2:	e8 e3 f9 ff ff       	call   80218a <set_block_data>
  8027a7:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8027aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ae:	75 17                	jne    8027c7 <alloc_block_BF+0x152>
  8027b0:	83 ec 04             	sub    $0x4,%esp
  8027b3:	68 e3 43 80 00       	push   $0x8043e3
  8027b8:	68 2c 01 00 00       	push   $0x12c
  8027bd:	68 01 44 80 00       	push   $0x804401
  8027c2:	e8 bf da ff ff       	call   800286 <_panic>
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 00                	mov    (%eax),%eax
  8027cc:	85 c0                	test   %eax,%eax
  8027ce:	74 10                	je     8027e0 <alloc_block_BF+0x16b>
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 00                	mov    (%eax),%eax
  8027d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d8:	8b 52 04             	mov    0x4(%edx),%edx
  8027db:	89 50 04             	mov    %edx,0x4(%eax)
  8027de:	eb 0b                	jmp    8027eb <alloc_block_BF+0x176>
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 40 04             	mov    0x4(%eax),%eax
  8027e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 40 04             	mov    0x4(%eax),%eax
  8027f1:	85 c0                	test   %eax,%eax
  8027f3:	74 0f                	je     802804 <alloc_block_BF+0x18f>
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 40 04             	mov    0x4(%eax),%eax
  8027fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fe:	8b 12                	mov    (%edx),%edx
  802800:	89 10                	mov    %edx,(%eax)
  802802:	eb 0a                	jmp    80280e <alloc_block_BF+0x199>
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 00                	mov    (%eax),%eax
  802809:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802821:	a1 38 50 80 00       	mov    0x805038,%eax
  802826:	48                   	dec    %eax
  802827:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80282c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80282f:	e9 01 04 00 00       	jmp    802c35 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802834:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802837:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80283a:	76 13                	jbe    80284f <alloc_block_BF+0x1da>
					{
						internal = 1;
  80283c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802843:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802846:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802849:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80284c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80284f:	a1 34 50 80 00       	mov    0x805034,%eax
  802854:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802857:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285b:	74 07                	je     802864 <alloc_block_BF+0x1ef>
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 00                	mov    (%eax),%eax
  802862:	eb 05                	jmp    802869 <alloc_block_BF+0x1f4>
  802864:	b8 00 00 00 00       	mov    $0x0,%eax
  802869:	a3 34 50 80 00       	mov    %eax,0x805034
  80286e:	a1 34 50 80 00       	mov    0x805034,%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	0f 85 bf fe ff ff    	jne    80273a <alloc_block_BF+0xc5>
  80287b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287f:	0f 85 b5 fe ff ff    	jne    80273a <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802885:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802889:	0f 84 26 02 00 00    	je     802ab5 <alloc_block_BF+0x440>
  80288f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802893:	0f 85 1c 02 00 00    	jne    802ab5 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289c:	2b 45 08             	sub    0x8(%ebp),%eax
  80289f:	83 e8 08             	sub    $0x8,%eax
  8028a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	8d 50 08             	lea    0x8(%eax),%edx
  8028ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ae:	01 d0                	add    %edx,%eax
  8028b0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	83 c0 08             	add    $0x8,%eax
  8028b9:	83 ec 04             	sub    $0x4,%esp
  8028bc:	6a 01                	push   $0x1
  8028be:	50                   	push   %eax
  8028bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8028c2:	e8 c3 f8 ff ff       	call   80218a <set_block_data>
  8028c7:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8028ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cd:	8b 40 04             	mov    0x4(%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	75 68                	jne    80293c <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028d4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028d8:	75 17                	jne    8028f1 <alloc_block_BF+0x27c>
  8028da:	83 ec 04             	sub    $0x4,%esp
  8028dd:	68 1c 44 80 00       	push   $0x80441c
  8028e2:	68 45 01 00 00       	push   $0x145
  8028e7:	68 01 44 80 00       	push   $0x804401
  8028ec:	e8 95 d9 ff ff       	call   800286 <_panic>
  8028f1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028fa:	89 10                	mov    %edx,(%eax)
  8028fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	74 0d                	je     802912 <alloc_block_BF+0x29d>
  802905:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80290a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80290d:	89 50 04             	mov    %edx,0x4(%eax)
  802910:	eb 08                	jmp    80291a <alloc_block_BF+0x2a5>
  802912:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802915:	a3 30 50 80 00       	mov    %eax,0x805030
  80291a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80291d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802922:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802925:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292c:	a1 38 50 80 00       	mov    0x805038,%eax
  802931:	40                   	inc    %eax
  802932:	a3 38 50 80 00       	mov    %eax,0x805038
  802937:	e9 dc 00 00 00       	jmp    802a18 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80293c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293f:	8b 00                	mov    (%eax),%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	75 65                	jne    8029aa <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802945:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802949:	75 17                	jne    802962 <alloc_block_BF+0x2ed>
  80294b:	83 ec 04             	sub    $0x4,%esp
  80294e:	68 50 44 80 00       	push   $0x804450
  802953:	68 4a 01 00 00       	push   $0x14a
  802958:	68 01 44 80 00       	push   $0x804401
  80295d:	e8 24 d9 ff ff       	call   800286 <_panic>
  802962:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802968:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80296b:	89 50 04             	mov    %edx,0x4(%eax)
  80296e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802971:	8b 40 04             	mov    0x4(%eax),%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	74 0c                	je     802984 <alloc_block_BF+0x30f>
  802978:	a1 30 50 80 00       	mov    0x805030,%eax
  80297d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802980:	89 10                	mov    %edx,(%eax)
  802982:	eb 08                	jmp    80298c <alloc_block_BF+0x317>
  802984:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802987:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80298c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80298f:	a3 30 50 80 00       	mov    %eax,0x805030
  802994:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299d:	a1 38 50 80 00       	mov    0x805038,%eax
  8029a2:	40                   	inc    %eax
  8029a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8029a8:	eb 6e                	jmp    802a18 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8029aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ae:	74 06                	je     8029b6 <alloc_block_BF+0x341>
  8029b0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029b4:	75 17                	jne    8029cd <alloc_block_BF+0x358>
  8029b6:	83 ec 04             	sub    $0x4,%esp
  8029b9:	68 74 44 80 00       	push   $0x804474
  8029be:	68 4f 01 00 00       	push   $0x14f
  8029c3:	68 01 44 80 00       	push   $0x804401
  8029c8:	e8 b9 d8 ff ff       	call   800286 <_panic>
  8029cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d0:	8b 10                	mov    (%eax),%edx
  8029d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d5:	89 10                	mov    %edx,(%eax)
  8029d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029da:	8b 00                	mov    (%eax),%eax
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	74 0b                	je     8029eb <alloc_block_BF+0x376>
  8029e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029e8:	89 50 04             	mov    %edx,0x4(%eax)
  8029eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ee:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029f1:	89 10                	mov    %edx,(%eax)
  8029f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f9:	89 50 04             	mov    %edx,0x4(%eax)
  8029fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	85 c0                	test   %eax,%eax
  802a03:	75 08                	jne    802a0d <alloc_block_BF+0x398>
  802a05:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a08:	a3 30 50 80 00       	mov    %eax,0x805030
  802a0d:	a1 38 50 80 00       	mov    0x805038,%eax
  802a12:	40                   	inc    %eax
  802a13:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a1c:	75 17                	jne    802a35 <alloc_block_BF+0x3c0>
  802a1e:	83 ec 04             	sub    $0x4,%esp
  802a21:	68 e3 43 80 00       	push   $0x8043e3
  802a26:	68 51 01 00 00       	push   $0x151
  802a2b:	68 01 44 80 00       	push   $0x804401
  802a30:	e8 51 d8 ff ff       	call   800286 <_panic>
  802a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a38:	8b 00                	mov    (%eax),%eax
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	74 10                	je     802a4e <alloc_block_BF+0x3d9>
  802a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a46:	8b 52 04             	mov    0x4(%edx),%edx
  802a49:	89 50 04             	mov    %edx,0x4(%eax)
  802a4c:	eb 0b                	jmp    802a59 <alloc_block_BF+0x3e4>
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	a3 30 50 80 00       	mov    %eax,0x805030
  802a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5c:	8b 40 04             	mov    0x4(%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	74 0f                	je     802a72 <alloc_block_BF+0x3fd>
  802a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a66:	8b 40 04             	mov    0x4(%eax),%eax
  802a69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a6c:	8b 12                	mov    (%edx),%edx
  802a6e:	89 10                	mov    %edx,(%eax)
  802a70:	eb 0a                	jmp    802a7c <alloc_block_BF+0x407>
  802a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8f:	a1 38 50 80 00       	mov    0x805038,%eax
  802a94:	48                   	dec    %eax
  802a95:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a9a:	83 ec 04             	sub    $0x4,%esp
  802a9d:	6a 00                	push   $0x0
  802a9f:	ff 75 d0             	pushl  -0x30(%ebp)
  802aa2:	ff 75 cc             	pushl  -0x34(%ebp)
  802aa5:	e8 e0 f6 ff ff       	call   80218a <set_block_data>
  802aaa:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab0:	e9 80 01 00 00       	jmp    802c35 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802ab5:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802ab9:	0f 85 9d 00 00 00    	jne    802b5c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802abf:	83 ec 04             	sub    $0x4,%esp
  802ac2:	6a 01                	push   $0x1
  802ac4:	ff 75 ec             	pushl  -0x14(%ebp)
  802ac7:	ff 75 f0             	pushl  -0x10(%ebp)
  802aca:	e8 bb f6 ff ff       	call   80218a <set_block_data>
  802acf:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802ad2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad6:	75 17                	jne    802aef <alloc_block_BF+0x47a>
  802ad8:	83 ec 04             	sub    $0x4,%esp
  802adb:	68 e3 43 80 00       	push   $0x8043e3
  802ae0:	68 58 01 00 00       	push   $0x158
  802ae5:	68 01 44 80 00       	push   $0x804401
  802aea:	e8 97 d7 ff ff       	call   800286 <_panic>
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	85 c0                	test   %eax,%eax
  802af6:	74 10                	je     802b08 <alloc_block_BF+0x493>
  802af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b00:	8b 52 04             	mov    0x4(%edx),%edx
  802b03:	89 50 04             	mov    %edx,0x4(%eax)
  802b06:	eb 0b                	jmp    802b13 <alloc_block_BF+0x49e>
  802b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0b:	8b 40 04             	mov    0x4(%eax),%eax
  802b0e:	a3 30 50 80 00       	mov    %eax,0x805030
  802b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b16:	8b 40 04             	mov    0x4(%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	74 0f                	je     802b2c <alloc_block_BF+0x4b7>
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	8b 40 04             	mov    0x4(%eax),%eax
  802b23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b26:	8b 12                	mov    (%edx),%edx
  802b28:	89 10                	mov    %edx,(%eax)
  802b2a:	eb 0a                	jmp    802b36 <alloc_block_BF+0x4c1>
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b49:	a1 38 50 80 00       	mov    0x805038,%eax
  802b4e:	48                   	dec    %eax
  802b4f:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	e9 d9 00 00 00       	jmp    802c35 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	83 c0 08             	add    $0x8,%eax
  802b62:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b65:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b6c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b6f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b72:	01 d0                	add    %edx,%eax
  802b74:	48                   	dec    %eax
  802b75:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b78:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b80:	f7 75 c4             	divl   -0x3c(%ebp)
  802b83:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b86:	29 d0                	sub    %edx,%eax
  802b88:	c1 e8 0c             	shr    $0xc,%eax
  802b8b:	83 ec 0c             	sub    $0xc,%esp
  802b8e:	50                   	push   %eax
  802b8f:	e8 49 e7 ff ff       	call   8012dd <sbrk>
  802b94:	83 c4 10             	add    $0x10,%esp
  802b97:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b9a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b9e:	75 0a                	jne    802baa <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba5:	e9 8b 00 00 00       	jmp    802c35 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802baa:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802bb1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bb4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bb7:	01 d0                	add    %edx,%eax
  802bb9:	48                   	dec    %eax
  802bba:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802bbd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc5:	f7 75 b8             	divl   -0x48(%ebp)
  802bc8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bcb:	29 d0                	sub    %edx,%eax
  802bcd:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bd0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bd3:	01 d0                	add    %edx,%eax
  802bd5:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802bda:	a1 40 50 80 00       	mov    0x805040,%eax
  802bdf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802be5:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802bec:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bf2:	01 d0                	add    %edx,%eax
  802bf4:	48                   	dec    %eax
  802bf5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802bf8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  802c00:	f7 75 b0             	divl   -0x50(%ebp)
  802c03:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c06:	29 d0                	sub    %edx,%eax
  802c08:	83 ec 04             	sub    $0x4,%esp
  802c0b:	6a 01                	push   $0x1
  802c0d:	50                   	push   %eax
  802c0e:	ff 75 bc             	pushl  -0x44(%ebp)
  802c11:	e8 74 f5 ff ff       	call   80218a <set_block_data>
  802c16:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c19:	83 ec 0c             	sub    $0xc,%esp
  802c1c:	ff 75 bc             	pushl  -0x44(%ebp)
  802c1f:	e8 36 04 00 00       	call   80305a <free_block>
  802c24:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c27:	83 ec 0c             	sub    $0xc,%esp
  802c2a:	ff 75 08             	pushl  0x8(%ebp)
  802c2d:	e8 43 fa ff ff       	call   802675 <alloc_block_BF>
  802c32:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c35:	c9                   	leave  
  802c36:	c3                   	ret    

00802c37 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c37:	55                   	push   %ebp
  802c38:	89 e5                	mov    %esp,%ebp
  802c3a:	53                   	push   %ebx
  802c3b:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c50:	74 1e                	je     802c70 <merging+0x39>
  802c52:	ff 75 08             	pushl  0x8(%ebp)
  802c55:	e8 df f1 ff ff       	call   801e39 <get_block_size>
  802c5a:	83 c4 04             	add    $0x4,%esp
  802c5d:	89 c2                	mov    %eax,%edx
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	01 d0                	add    %edx,%eax
  802c64:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c67:	75 07                	jne    802c70 <merging+0x39>
		prev_is_free = 1;
  802c69:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c74:	74 1e                	je     802c94 <merging+0x5d>
  802c76:	ff 75 10             	pushl  0x10(%ebp)
  802c79:	e8 bb f1 ff ff       	call   801e39 <get_block_size>
  802c7e:	83 c4 04             	add    $0x4,%esp
  802c81:	89 c2                	mov    %eax,%edx
  802c83:	8b 45 10             	mov    0x10(%ebp),%eax
  802c86:	01 d0                	add    %edx,%eax
  802c88:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c8b:	75 07                	jne    802c94 <merging+0x5d>
		next_is_free = 1;
  802c8d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c98:	0f 84 cc 00 00 00    	je     802d6a <merging+0x133>
  802c9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca2:	0f 84 c2 00 00 00    	je     802d6a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ca8:	ff 75 08             	pushl  0x8(%ebp)
  802cab:	e8 89 f1 ff ff       	call   801e39 <get_block_size>
  802cb0:	83 c4 04             	add    $0x4,%esp
  802cb3:	89 c3                	mov    %eax,%ebx
  802cb5:	ff 75 10             	pushl  0x10(%ebp)
  802cb8:	e8 7c f1 ff ff       	call   801e39 <get_block_size>
  802cbd:	83 c4 04             	add    $0x4,%esp
  802cc0:	01 c3                	add    %eax,%ebx
  802cc2:	ff 75 0c             	pushl  0xc(%ebp)
  802cc5:	e8 6f f1 ff ff       	call   801e39 <get_block_size>
  802cca:	83 c4 04             	add    $0x4,%esp
  802ccd:	01 d8                	add    %ebx,%eax
  802ccf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cd2:	6a 00                	push   $0x0
  802cd4:	ff 75 ec             	pushl  -0x14(%ebp)
  802cd7:	ff 75 08             	pushl  0x8(%ebp)
  802cda:	e8 ab f4 ff ff       	call   80218a <set_block_data>
  802cdf:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ce2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ce6:	75 17                	jne    802cff <merging+0xc8>
  802ce8:	83 ec 04             	sub    $0x4,%esp
  802ceb:	68 e3 43 80 00       	push   $0x8043e3
  802cf0:	68 7d 01 00 00       	push   $0x17d
  802cf5:	68 01 44 80 00       	push   $0x804401
  802cfa:	e8 87 d5 ff ff       	call   800286 <_panic>
  802cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	85 c0                	test   %eax,%eax
  802d06:	74 10                	je     802d18 <merging+0xe1>
  802d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d10:	8b 52 04             	mov    0x4(%edx),%edx
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	eb 0b                	jmp    802d23 <merging+0xec>
  802d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1b:	8b 40 04             	mov    0x4(%eax),%eax
  802d1e:	a3 30 50 80 00       	mov    %eax,0x805030
  802d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d26:	8b 40 04             	mov    0x4(%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 0f                	je     802d3c <merging+0x105>
  802d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d30:	8b 40 04             	mov    0x4(%eax),%eax
  802d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d36:	8b 12                	mov    (%edx),%edx
  802d38:	89 10                	mov    %edx,(%eax)
  802d3a:	eb 0a                	jmp    802d46 <merging+0x10f>
  802d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d59:	a1 38 50 80 00       	mov    0x805038,%eax
  802d5e:	48                   	dec    %eax
  802d5f:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d64:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d65:	e9 ea 02 00 00       	jmp    803054 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6e:	74 3b                	je     802dab <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d70:	83 ec 0c             	sub    $0xc,%esp
  802d73:	ff 75 08             	pushl  0x8(%ebp)
  802d76:	e8 be f0 ff ff       	call   801e39 <get_block_size>
  802d7b:	83 c4 10             	add    $0x10,%esp
  802d7e:	89 c3                	mov    %eax,%ebx
  802d80:	83 ec 0c             	sub    $0xc,%esp
  802d83:	ff 75 10             	pushl  0x10(%ebp)
  802d86:	e8 ae f0 ff ff       	call   801e39 <get_block_size>
  802d8b:	83 c4 10             	add    $0x10,%esp
  802d8e:	01 d8                	add    %ebx,%eax
  802d90:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d93:	83 ec 04             	sub    $0x4,%esp
  802d96:	6a 00                	push   $0x0
  802d98:	ff 75 e8             	pushl  -0x18(%ebp)
  802d9b:	ff 75 08             	pushl  0x8(%ebp)
  802d9e:	e8 e7 f3 ff ff       	call   80218a <set_block_data>
  802da3:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802da6:	e9 a9 02 00 00       	jmp    803054 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802dab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802daf:	0f 84 2d 01 00 00    	je     802ee2 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802db5:	83 ec 0c             	sub    $0xc,%esp
  802db8:	ff 75 10             	pushl  0x10(%ebp)
  802dbb:	e8 79 f0 ff ff       	call   801e39 <get_block_size>
  802dc0:	83 c4 10             	add    $0x10,%esp
  802dc3:	89 c3                	mov    %eax,%ebx
  802dc5:	83 ec 0c             	sub    $0xc,%esp
  802dc8:	ff 75 0c             	pushl  0xc(%ebp)
  802dcb:	e8 69 f0 ff ff       	call   801e39 <get_block_size>
  802dd0:	83 c4 10             	add    $0x10,%esp
  802dd3:	01 d8                	add    %ebx,%eax
  802dd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802dd8:	83 ec 04             	sub    $0x4,%esp
  802ddb:	6a 00                	push   $0x0
  802ddd:	ff 75 e4             	pushl  -0x1c(%ebp)
  802de0:	ff 75 10             	pushl  0x10(%ebp)
  802de3:	e8 a2 f3 ff ff       	call   80218a <set_block_data>
  802de8:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802deb:	8b 45 10             	mov    0x10(%ebp),%eax
  802dee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802df1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802df5:	74 06                	je     802dfd <merging+0x1c6>
  802df7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dfb:	75 17                	jne    802e14 <merging+0x1dd>
  802dfd:	83 ec 04             	sub    $0x4,%esp
  802e00:	68 a8 44 80 00       	push   $0x8044a8
  802e05:	68 8d 01 00 00       	push   $0x18d
  802e0a:	68 01 44 80 00       	push   $0x804401
  802e0f:	e8 72 d4 ff ff       	call   800286 <_panic>
  802e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e17:	8b 50 04             	mov    0x4(%eax),%edx
  802e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1d:	89 50 04             	mov    %edx,0x4(%eax)
  802e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e26:	89 10                	mov    %edx,(%eax)
  802e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2b:	8b 40 04             	mov    0x4(%eax),%eax
  802e2e:	85 c0                	test   %eax,%eax
  802e30:	74 0d                	je     802e3f <merging+0x208>
  802e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e35:	8b 40 04             	mov    0x4(%eax),%eax
  802e38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e3b:	89 10                	mov    %edx,(%eax)
  802e3d:	eb 08                	jmp    802e47 <merging+0x210>
  802e3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e42:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e4d:	89 50 04             	mov    %edx,0x4(%eax)
  802e50:	a1 38 50 80 00       	mov    0x805038,%eax
  802e55:	40                   	inc    %eax
  802e56:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e5f:	75 17                	jne    802e78 <merging+0x241>
  802e61:	83 ec 04             	sub    $0x4,%esp
  802e64:	68 e3 43 80 00       	push   $0x8043e3
  802e69:	68 8e 01 00 00       	push   $0x18e
  802e6e:	68 01 44 80 00       	push   $0x804401
  802e73:	e8 0e d4 ff ff       	call   800286 <_panic>
  802e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7b:	8b 00                	mov    (%eax),%eax
  802e7d:	85 c0                	test   %eax,%eax
  802e7f:	74 10                	je     802e91 <merging+0x25a>
  802e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e84:	8b 00                	mov    (%eax),%eax
  802e86:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e89:	8b 52 04             	mov    0x4(%edx),%edx
  802e8c:	89 50 04             	mov    %edx,0x4(%eax)
  802e8f:	eb 0b                	jmp    802e9c <merging+0x265>
  802e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e94:	8b 40 04             	mov    0x4(%eax),%eax
  802e97:	a3 30 50 80 00       	mov    %eax,0x805030
  802e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	74 0f                	je     802eb5 <merging+0x27e>
  802ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea9:	8b 40 04             	mov    0x4(%eax),%eax
  802eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eaf:	8b 12                	mov    (%edx),%edx
  802eb1:	89 10                	mov    %edx,(%eax)
  802eb3:	eb 0a                	jmp    802ebf <merging+0x288>
  802eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb8:	8b 00                	mov    (%eax),%eax
  802eba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ecb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ed7:	48                   	dec    %eax
  802ed8:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802edd:	e9 72 01 00 00       	jmp    803054 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  802ee5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ee8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eec:	74 79                	je     802f67 <merging+0x330>
  802eee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ef2:	74 73                	je     802f67 <merging+0x330>
  802ef4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef8:	74 06                	je     802f00 <merging+0x2c9>
  802efa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802efe:	75 17                	jne    802f17 <merging+0x2e0>
  802f00:	83 ec 04             	sub    $0x4,%esp
  802f03:	68 74 44 80 00       	push   $0x804474
  802f08:	68 94 01 00 00       	push   $0x194
  802f0d:	68 01 44 80 00       	push   $0x804401
  802f12:	e8 6f d3 ff ff       	call   800286 <_panic>
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	8b 10                	mov    (%eax),%edx
  802f1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1f:	89 10                	mov    %edx,(%eax)
  802f21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f24:	8b 00                	mov    (%eax),%eax
  802f26:	85 c0                	test   %eax,%eax
  802f28:	74 0b                	je     802f35 <merging+0x2fe>
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f32:	89 50 04             	mov    %edx,0x4(%eax)
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f3b:	89 10                	mov    %edx,(%eax)
  802f3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f40:	8b 55 08             	mov    0x8(%ebp),%edx
  802f43:	89 50 04             	mov    %edx,0x4(%eax)
  802f46:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	85 c0                	test   %eax,%eax
  802f4d:	75 08                	jne    802f57 <merging+0x320>
  802f4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f52:	a3 30 50 80 00       	mov    %eax,0x805030
  802f57:	a1 38 50 80 00       	mov    0x805038,%eax
  802f5c:	40                   	inc    %eax
  802f5d:	a3 38 50 80 00       	mov    %eax,0x805038
  802f62:	e9 ce 00 00 00       	jmp    803035 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6b:	74 65                	je     802fd2 <merging+0x39b>
  802f6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f71:	75 17                	jne    802f8a <merging+0x353>
  802f73:	83 ec 04             	sub    $0x4,%esp
  802f76:	68 50 44 80 00       	push   $0x804450
  802f7b:	68 95 01 00 00       	push   $0x195
  802f80:	68 01 44 80 00       	push   $0x804401
  802f85:	e8 fc d2 ff ff       	call   800286 <_panic>
  802f8a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f93:	89 50 04             	mov    %edx,0x4(%eax)
  802f96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f99:	8b 40 04             	mov    0x4(%eax),%eax
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	74 0c                	je     802fac <merging+0x375>
  802fa0:	a1 30 50 80 00       	mov    0x805030,%eax
  802fa5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fa8:	89 10                	mov    %edx,(%eax)
  802faa:	eb 08                	jmp    802fb4 <merging+0x37d>
  802fac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802faf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb7:	a3 30 50 80 00       	mov    %eax,0x805030
  802fbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc5:	a1 38 50 80 00       	mov    0x805038,%eax
  802fca:	40                   	inc    %eax
  802fcb:	a3 38 50 80 00       	mov    %eax,0x805038
  802fd0:	eb 63                	jmp    803035 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fd2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fd6:	75 17                	jne    802fef <merging+0x3b8>
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 1c 44 80 00       	push   $0x80441c
  802fe0:	68 98 01 00 00       	push   $0x198
  802fe5:	68 01 44 80 00       	push   $0x804401
  802fea:	e8 97 d2 ff ff       	call   800286 <_panic>
  802fef:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ff5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff8:	89 10                	mov    %edx,(%eax)
  802ffa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	74 0d                	je     803010 <merging+0x3d9>
  803003:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803008:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80300b:	89 50 04             	mov    %edx,0x4(%eax)
  80300e:	eb 08                	jmp    803018 <merging+0x3e1>
  803010:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803013:	a3 30 50 80 00       	mov    %eax,0x805030
  803018:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803020:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803023:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302a:	a1 38 50 80 00       	mov    0x805038,%eax
  80302f:	40                   	inc    %eax
  803030:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803035:	83 ec 0c             	sub    $0xc,%esp
  803038:	ff 75 10             	pushl  0x10(%ebp)
  80303b:	e8 f9 ed ff ff       	call   801e39 <get_block_size>
  803040:	83 c4 10             	add    $0x10,%esp
  803043:	83 ec 04             	sub    $0x4,%esp
  803046:	6a 00                	push   $0x0
  803048:	50                   	push   %eax
  803049:	ff 75 10             	pushl  0x10(%ebp)
  80304c:	e8 39 f1 ff ff       	call   80218a <set_block_data>
  803051:	83 c4 10             	add    $0x10,%esp
	}
}
  803054:	90                   	nop
  803055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803058:	c9                   	leave  
  803059:	c3                   	ret    

0080305a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80305a:	55                   	push   %ebp
  80305b:	89 e5                	mov    %esp,%ebp
  80305d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803060:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803065:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803068:	a1 30 50 80 00       	mov    0x805030,%eax
  80306d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803070:	73 1b                	jae    80308d <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803072:	a1 30 50 80 00       	mov    0x805030,%eax
  803077:	83 ec 04             	sub    $0x4,%esp
  80307a:	ff 75 08             	pushl  0x8(%ebp)
  80307d:	6a 00                	push   $0x0
  80307f:	50                   	push   %eax
  803080:	e8 b2 fb ff ff       	call   802c37 <merging>
  803085:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803088:	e9 8b 00 00 00       	jmp    803118 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80308d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803092:	3b 45 08             	cmp    0x8(%ebp),%eax
  803095:	76 18                	jbe    8030af <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803097:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	ff 75 08             	pushl  0x8(%ebp)
  8030a2:	50                   	push   %eax
  8030a3:	6a 00                	push   $0x0
  8030a5:	e8 8d fb ff ff       	call   802c37 <merging>
  8030aa:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030ad:	eb 69                	jmp    803118 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030af:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b7:	eb 39                	jmp    8030f2 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030bf:	73 29                	jae    8030ea <free_block+0x90>
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 00                	mov    (%eax),%eax
  8030c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c9:	76 1f                	jbe    8030ea <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	ff 75 08             	pushl  0x8(%ebp)
  8030d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8030dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8030df:	e8 53 fb ff ff       	call   802c37 <merging>
  8030e4:	83 c4 10             	add    $0x10,%esp
			break;
  8030e7:	90                   	nop
		}
	}
}
  8030e8:	eb 2e                	jmp    803118 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030ea:	a1 34 50 80 00       	mov    0x805034,%eax
  8030ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f6:	74 07                	je     8030ff <free_block+0xa5>
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	eb 05                	jmp    803104 <free_block+0xaa>
  8030ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803104:	a3 34 50 80 00       	mov    %eax,0x805034
  803109:	a1 34 50 80 00       	mov    0x805034,%eax
  80310e:	85 c0                	test   %eax,%eax
  803110:	75 a7                	jne    8030b9 <free_block+0x5f>
  803112:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803116:	75 a1                	jne    8030b9 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803118:	90                   	nop
  803119:	c9                   	leave  
  80311a:	c3                   	ret    

0080311b <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80311b:	55                   	push   %ebp
  80311c:	89 e5                	mov    %esp,%ebp
  80311e:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803121:	ff 75 08             	pushl  0x8(%ebp)
  803124:	e8 10 ed ff ff       	call   801e39 <get_block_size>
  803129:	83 c4 04             	add    $0x4,%esp
  80312c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80312f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803136:	eb 17                	jmp    80314f <copy_data+0x34>
  803138:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80313b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313e:	01 c2                	add    %eax,%edx
  803140:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803143:	8b 45 08             	mov    0x8(%ebp),%eax
  803146:	01 c8                	add    %ecx,%eax
  803148:	8a 00                	mov    (%eax),%al
  80314a:	88 02                	mov    %al,(%edx)
  80314c:	ff 45 fc             	incl   -0x4(%ebp)
  80314f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803152:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803155:	72 e1                	jb     803138 <copy_data+0x1d>
}
  803157:	90                   	nop
  803158:	c9                   	leave  
  803159:	c3                   	ret    

0080315a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80315a:	55                   	push   %ebp
  80315b:	89 e5                	mov    %esp,%ebp
  80315d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803160:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803164:	75 23                	jne    803189 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803166:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80316a:	74 13                	je     80317f <realloc_block_FF+0x25>
  80316c:	83 ec 0c             	sub    $0xc,%esp
  80316f:	ff 75 0c             	pushl  0xc(%ebp)
  803172:	e8 42 f0 ff ff       	call   8021b9 <alloc_block_FF>
  803177:	83 c4 10             	add    $0x10,%esp
  80317a:	e9 e4 06 00 00       	jmp    803863 <realloc_block_FF+0x709>
		return NULL;
  80317f:	b8 00 00 00 00       	mov    $0x0,%eax
  803184:	e9 da 06 00 00       	jmp    803863 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803189:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80318d:	75 18                	jne    8031a7 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80318f:	83 ec 0c             	sub    $0xc,%esp
  803192:	ff 75 08             	pushl  0x8(%ebp)
  803195:	e8 c0 fe ff ff       	call   80305a <free_block>
  80319a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80319d:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a2:	e9 bc 06 00 00       	jmp    803863 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8031a7:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031ab:	77 07                	ja     8031b4 <realloc_block_FF+0x5a>
  8031ad:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b7:	83 e0 01             	and    $0x1,%eax
  8031ba:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c0:	83 c0 08             	add    $0x8,%eax
  8031c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031c6:	83 ec 0c             	sub    $0xc,%esp
  8031c9:	ff 75 08             	pushl  0x8(%ebp)
  8031cc:	e8 68 ec ff ff       	call   801e39 <get_block_size>
  8031d1:	83 c4 10             	add    $0x10,%esp
  8031d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031da:	83 e8 08             	sub    $0x8,%eax
  8031dd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	83 e8 04             	sub    $0x4,%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	83 e0 fe             	and    $0xfffffffe,%eax
  8031eb:	89 c2                	mov    %eax,%edx
  8031ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f0:	01 d0                	add    %edx,%eax
  8031f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031f5:	83 ec 0c             	sub    $0xc,%esp
  8031f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031fb:	e8 39 ec ff ff       	call   801e39 <get_block_size>
  803200:	83 c4 10             	add    $0x10,%esp
  803203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803209:	83 e8 08             	sub    $0x8,%eax
  80320c:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80320f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803212:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803215:	75 08                	jne    80321f <realloc_block_FF+0xc5>
	{
		 return va;
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	e9 44 06 00 00       	jmp    803863 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80321f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803222:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803225:	0f 83 d5 03 00 00    	jae    803600 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80322b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322e:	2b 45 0c             	sub    0xc(%ebp),%eax
  803231:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803234:	83 ec 0c             	sub    $0xc,%esp
  803237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80323a:	e8 13 ec ff ff       	call   801e52 <is_free_block>
  80323f:	83 c4 10             	add    $0x10,%esp
  803242:	84 c0                	test   %al,%al
  803244:	0f 84 3b 01 00 00    	je     803385 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80324a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80324d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803250:	01 d0                	add    %edx,%eax
  803252:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803255:	83 ec 04             	sub    $0x4,%esp
  803258:	6a 01                	push   $0x1
  80325a:	ff 75 f0             	pushl  -0x10(%ebp)
  80325d:	ff 75 08             	pushl  0x8(%ebp)
  803260:	e8 25 ef ff ff       	call   80218a <set_block_data>
  803265:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	83 e8 04             	sub    $0x4,%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	83 e0 fe             	and    $0xfffffffe,%eax
  803273:	89 c2                	mov    %eax,%edx
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	01 d0                	add    %edx,%eax
  80327a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80327d:	83 ec 04             	sub    $0x4,%esp
  803280:	6a 00                	push   $0x0
  803282:	ff 75 cc             	pushl  -0x34(%ebp)
  803285:	ff 75 c8             	pushl  -0x38(%ebp)
  803288:	e8 fd ee ff ff       	call   80218a <set_block_data>
  80328d:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803290:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803294:	74 06                	je     80329c <realloc_block_FF+0x142>
  803296:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80329a:	75 17                	jne    8032b3 <realloc_block_FF+0x159>
  80329c:	83 ec 04             	sub    $0x4,%esp
  80329f:	68 74 44 80 00       	push   $0x804474
  8032a4:	68 f6 01 00 00       	push   $0x1f6
  8032a9:	68 01 44 80 00       	push   $0x804401
  8032ae:	e8 d3 cf ff ff       	call   800286 <_panic>
  8032b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b6:	8b 10                	mov    (%eax),%edx
  8032b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032bb:	89 10                	mov    %edx,(%eax)
  8032bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	85 c0                	test   %eax,%eax
  8032c4:	74 0b                	je     8032d1 <realloc_block_FF+0x177>
  8032c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c9:	8b 00                	mov    (%eax),%eax
  8032cb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032ce:	89 50 04             	mov    %edx,0x4(%eax)
  8032d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032d7:	89 10                	mov    %edx,(%eax)
  8032d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032df:	89 50 04             	mov    %edx,0x4(%eax)
  8032e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	85 c0                	test   %eax,%eax
  8032e9:	75 08                	jne    8032f3 <realloc_block_FF+0x199>
  8032eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8032f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8032f8:	40                   	inc    %eax
  8032f9:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803302:	75 17                	jne    80331b <realloc_block_FF+0x1c1>
  803304:	83 ec 04             	sub    $0x4,%esp
  803307:	68 e3 43 80 00       	push   $0x8043e3
  80330c:	68 f7 01 00 00       	push   $0x1f7
  803311:	68 01 44 80 00       	push   $0x804401
  803316:	e8 6b cf ff ff       	call   800286 <_panic>
  80331b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	85 c0                	test   %eax,%eax
  803322:	74 10                	je     803334 <realloc_block_FF+0x1da>
  803324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80332c:	8b 52 04             	mov    0x4(%edx),%edx
  80332f:	89 50 04             	mov    %edx,0x4(%eax)
  803332:	eb 0b                	jmp    80333f <realloc_block_FF+0x1e5>
  803334:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803337:	8b 40 04             	mov    0x4(%eax),%eax
  80333a:	a3 30 50 80 00       	mov    %eax,0x805030
  80333f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803342:	8b 40 04             	mov    0x4(%eax),%eax
  803345:	85 c0                	test   %eax,%eax
  803347:	74 0f                	je     803358 <realloc_block_FF+0x1fe>
  803349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334c:	8b 40 04             	mov    0x4(%eax),%eax
  80334f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803352:	8b 12                	mov    (%edx),%edx
  803354:	89 10                	mov    %edx,(%eax)
  803356:	eb 0a                	jmp    803362 <realloc_block_FF+0x208>
  803358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803375:	a1 38 50 80 00       	mov    0x805038,%eax
  80337a:	48                   	dec    %eax
  80337b:	a3 38 50 80 00       	mov    %eax,0x805038
  803380:	e9 73 02 00 00       	jmp    8035f8 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803385:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803389:	0f 86 69 02 00 00    	jbe    8035f8 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80338f:	83 ec 04             	sub    $0x4,%esp
  803392:	6a 01                	push   $0x1
  803394:	ff 75 f0             	pushl  -0x10(%ebp)
  803397:	ff 75 08             	pushl  0x8(%ebp)
  80339a:	e8 eb ed ff ff       	call   80218a <set_block_data>
  80339f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	83 e8 04             	sub    $0x4,%eax
  8033a8:	8b 00                	mov    (%eax),%eax
  8033aa:	83 e0 fe             	and    $0xfffffffe,%eax
  8033ad:	89 c2                	mov    %eax,%edx
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	01 d0                	add    %edx,%eax
  8033b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8033bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033bf:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033c3:	75 68                	jne    80342d <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033c5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033c9:	75 17                	jne    8033e2 <realloc_block_FF+0x288>
  8033cb:	83 ec 04             	sub    $0x4,%esp
  8033ce:	68 1c 44 80 00       	push   $0x80441c
  8033d3:	68 06 02 00 00       	push   $0x206
  8033d8:	68 01 44 80 00       	push   $0x804401
  8033dd:	e8 a4 ce ff ff       	call   800286 <_panic>
  8033e2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033eb:	89 10                	mov    %edx,(%eax)
  8033ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f0:	8b 00                	mov    (%eax),%eax
  8033f2:	85 c0                	test   %eax,%eax
  8033f4:	74 0d                	je     803403 <realloc_block_FF+0x2a9>
  8033f6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033fe:	89 50 04             	mov    %edx,0x4(%eax)
  803401:	eb 08                	jmp    80340b <realloc_block_FF+0x2b1>
  803403:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803406:	a3 30 50 80 00       	mov    %eax,0x805030
  80340b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803413:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803416:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341d:	a1 38 50 80 00       	mov    0x805038,%eax
  803422:	40                   	inc    %eax
  803423:	a3 38 50 80 00       	mov    %eax,0x805038
  803428:	e9 b0 01 00 00       	jmp    8035dd <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80342d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803432:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803435:	76 68                	jbe    80349f <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803437:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80343b:	75 17                	jne    803454 <realloc_block_FF+0x2fa>
  80343d:	83 ec 04             	sub    $0x4,%esp
  803440:	68 1c 44 80 00       	push   $0x80441c
  803445:	68 0b 02 00 00       	push   $0x20b
  80344a:	68 01 44 80 00       	push   $0x804401
  80344f:	e8 32 ce ff ff       	call   800286 <_panic>
  803454:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80345a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345d:	89 10                	mov    %edx,(%eax)
  80345f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	85 c0                	test   %eax,%eax
  803466:	74 0d                	je     803475 <realloc_block_FF+0x31b>
  803468:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80346d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803470:	89 50 04             	mov    %edx,0x4(%eax)
  803473:	eb 08                	jmp    80347d <realloc_block_FF+0x323>
  803475:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803478:	a3 30 50 80 00       	mov    %eax,0x805030
  80347d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803480:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803485:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803488:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80348f:	a1 38 50 80 00       	mov    0x805038,%eax
  803494:	40                   	inc    %eax
  803495:	a3 38 50 80 00       	mov    %eax,0x805038
  80349a:	e9 3e 01 00 00       	jmp    8035dd <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80349f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034a4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034a7:	73 68                	jae    803511 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034a9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034ad:	75 17                	jne    8034c6 <realloc_block_FF+0x36c>
  8034af:	83 ec 04             	sub    $0x4,%esp
  8034b2:	68 50 44 80 00       	push   $0x804450
  8034b7:	68 10 02 00 00       	push   $0x210
  8034bc:	68 01 44 80 00       	push   $0x804401
  8034c1:	e8 c0 cd ff ff       	call   800286 <_panic>
  8034c6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034cf:	89 50 04             	mov    %edx,0x4(%eax)
  8034d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d5:	8b 40 04             	mov    0x4(%eax),%eax
  8034d8:	85 c0                	test   %eax,%eax
  8034da:	74 0c                	je     8034e8 <realloc_block_FF+0x38e>
  8034dc:	a1 30 50 80 00       	mov    0x805030,%eax
  8034e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034e4:	89 10                	mov    %edx,(%eax)
  8034e6:	eb 08                	jmp    8034f0 <realloc_block_FF+0x396>
  8034e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034eb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803501:	a1 38 50 80 00       	mov    0x805038,%eax
  803506:	40                   	inc    %eax
  803507:	a3 38 50 80 00       	mov    %eax,0x805038
  80350c:	e9 cc 00 00 00       	jmp    8035dd <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803511:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803518:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80351d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803520:	e9 8a 00 00 00       	jmp    8035af <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803528:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80352b:	73 7a                	jae    8035a7 <realloc_block_FF+0x44d>
  80352d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803530:	8b 00                	mov    (%eax),%eax
  803532:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803535:	73 70                	jae    8035a7 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80353b:	74 06                	je     803543 <realloc_block_FF+0x3e9>
  80353d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803541:	75 17                	jne    80355a <realloc_block_FF+0x400>
  803543:	83 ec 04             	sub    $0x4,%esp
  803546:	68 74 44 80 00       	push   $0x804474
  80354b:	68 1a 02 00 00       	push   $0x21a
  803550:	68 01 44 80 00       	push   $0x804401
  803555:	e8 2c cd ff ff       	call   800286 <_panic>
  80355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355d:	8b 10                	mov    (%eax),%edx
  80355f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803562:	89 10                	mov    %edx,(%eax)
  803564:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803567:	8b 00                	mov    (%eax),%eax
  803569:	85 c0                	test   %eax,%eax
  80356b:	74 0b                	je     803578 <realloc_block_FF+0x41e>
  80356d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803570:	8b 00                	mov    (%eax),%eax
  803572:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803575:	89 50 04             	mov    %edx,0x4(%eax)
  803578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80357e:	89 10                	mov    %edx,(%eax)
  803580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803583:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803586:	89 50 04             	mov    %edx,0x4(%eax)
  803589:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358c:	8b 00                	mov    (%eax),%eax
  80358e:	85 c0                	test   %eax,%eax
  803590:	75 08                	jne    80359a <realloc_block_FF+0x440>
  803592:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803595:	a3 30 50 80 00       	mov    %eax,0x805030
  80359a:	a1 38 50 80 00       	mov    0x805038,%eax
  80359f:	40                   	inc    %eax
  8035a0:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035a5:	eb 36                	jmp    8035dd <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035a7:	a1 34 50 80 00       	mov    0x805034,%eax
  8035ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b3:	74 07                	je     8035bc <realloc_block_FF+0x462>
  8035b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b8:	8b 00                	mov    (%eax),%eax
  8035ba:	eb 05                	jmp    8035c1 <realloc_block_FF+0x467>
  8035bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c1:	a3 34 50 80 00       	mov    %eax,0x805034
  8035c6:	a1 34 50 80 00       	mov    0x805034,%eax
  8035cb:	85 c0                	test   %eax,%eax
  8035cd:	0f 85 52 ff ff ff    	jne    803525 <realloc_block_FF+0x3cb>
  8035d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d7:	0f 85 48 ff ff ff    	jne    803525 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035dd:	83 ec 04             	sub    $0x4,%esp
  8035e0:	6a 00                	push   $0x0
  8035e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8035e5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035e8:	e8 9d eb ff ff       	call   80218a <set_block_data>
  8035ed:	83 c4 10             	add    $0x10,%esp
				return va;
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	e9 6b 02 00 00       	jmp    803863 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8035f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fb:	e9 63 02 00 00       	jmp    803863 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803600:	8b 45 0c             	mov    0xc(%ebp),%eax
  803603:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803606:	0f 86 4d 02 00 00    	jbe    803859 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  80360c:	83 ec 0c             	sub    $0xc,%esp
  80360f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803612:	e8 3b e8 ff ff       	call   801e52 <is_free_block>
  803617:	83 c4 10             	add    $0x10,%esp
  80361a:	84 c0                	test   %al,%al
  80361c:	0f 84 37 02 00 00    	je     803859 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803622:	8b 45 0c             	mov    0xc(%ebp),%eax
  803625:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803628:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80362b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80362e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803631:	76 38                	jbe    80366b <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803633:	83 ec 0c             	sub    $0xc,%esp
  803636:	ff 75 0c             	pushl  0xc(%ebp)
  803639:	e8 7b eb ff ff       	call   8021b9 <alloc_block_FF>
  80363e:	83 c4 10             	add    $0x10,%esp
  803641:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803644:	83 ec 08             	sub    $0x8,%esp
  803647:	ff 75 c0             	pushl  -0x40(%ebp)
  80364a:	ff 75 08             	pushl  0x8(%ebp)
  80364d:	e8 c9 fa ff ff       	call   80311b <copy_data>
  803652:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803655:	83 ec 0c             	sub    $0xc,%esp
  803658:	ff 75 08             	pushl  0x8(%ebp)
  80365b:	e8 fa f9 ff ff       	call   80305a <free_block>
  803660:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803663:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803666:	e9 f8 01 00 00       	jmp    803863 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80366b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80366e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803671:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803674:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803678:	0f 87 a0 00 00 00    	ja     80371e <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80367e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803682:	75 17                	jne    80369b <realloc_block_FF+0x541>
  803684:	83 ec 04             	sub    $0x4,%esp
  803687:	68 e3 43 80 00       	push   $0x8043e3
  80368c:	68 38 02 00 00       	push   $0x238
  803691:	68 01 44 80 00       	push   $0x804401
  803696:	e8 eb cb ff ff       	call   800286 <_panic>
  80369b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369e:	8b 00                	mov    (%eax),%eax
  8036a0:	85 c0                	test   %eax,%eax
  8036a2:	74 10                	je     8036b4 <realloc_block_FF+0x55a>
  8036a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a7:	8b 00                	mov    (%eax),%eax
  8036a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ac:	8b 52 04             	mov    0x4(%edx),%edx
  8036af:	89 50 04             	mov    %edx,0x4(%eax)
  8036b2:	eb 0b                	jmp    8036bf <realloc_block_FF+0x565>
  8036b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b7:	8b 40 04             	mov    0x4(%eax),%eax
  8036ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8036bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c2:	8b 40 04             	mov    0x4(%eax),%eax
  8036c5:	85 c0                	test   %eax,%eax
  8036c7:	74 0f                	je     8036d8 <realloc_block_FF+0x57e>
  8036c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036cc:	8b 40 04             	mov    0x4(%eax),%eax
  8036cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d2:	8b 12                	mov    (%edx),%edx
  8036d4:	89 10                	mov    %edx,(%eax)
  8036d6:	eb 0a                	jmp    8036e2 <realloc_block_FF+0x588>
  8036d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036db:	8b 00                	mov    (%eax),%eax
  8036dd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8036fa:	48                   	dec    %eax
  8036fb:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803700:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803706:	01 d0                	add    %edx,%eax
  803708:	83 ec 04             	sub    $0x4,%esp
  80370b:	6a 01                	push   $0x1
  80370d:	50                   	push   %eax
  80370e:	ff 75 08             	pushl  0x8(%ebp)
  803711:	e8 74 ea ff ff       	call   80218a <set_block_data>
  803716:	83 c4 10             	add    $0x10,%esp
  803719:	e9 36 01 00 00       	jmp    803854 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80371e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803721:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803724:	01 d0                	add    %edx,%eax
  803726:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803729:	83 ec 04             	sub    $0x4,%esp
  80372c:	6a 01                	push   $0x1
  80372e:	ff 75 f0             	pushl  -0x10(%ebp)
  803731:	ff 75 08             	pushl  0x8(%ebp)
  803734:	e8 51 ea ff ff       	call   80218a <set_block_data>
  803739:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80373c:	8b 45 08             	mov    0x8(%ebp),%eax
  80373f:	83 e8 04             	sub    $0x4,%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	83 e0 fe             	and    $0xfffffffe,%eax
  803747:	89 c2                	mov    %eax,%edx
  803749:	8b 45 08             	mov    0x8(%ebp),%eax
  80374c:	01 d0                	add    %edx,%eax
  80374e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803751:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803755:	74 06                	je     80375d <realloc_block_FF+0x603>
  803757:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80375b:	75 17                	jne    803774 <realloc_block_FF+0x61a>
  80375d:	83 ec 04             	sub    $0x4,%esp
  803760:	68 74 44 80 00       	push   $0x804474
  803765:	68 44 02 00 00       	push   $0x244
  80376a:	68 01 44 80 00       	push   $0x804401
  80376f:	e8 12 cb ff ff       	call   800286 <_panic>
  803774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803777:	8b 10                	mov    (%eax),%edx
  803779:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80377c:	89 10                	mov    %edx,(%eax)
  80377e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803781:	8b 00                	mov    (%eax),%eax
  803783:	85 c0                	test   %eax,%eax
  803785:	74 0b                	je     803792 <realloc_block_FF+0x638>
  803787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378a:	8b 00                	mov    (%eax),%eax
  80378c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80378f:	89 50 04             	mov    %edx,0x4(%eax)
  803792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803795:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803798:	89 10                	mov    %edx,(%eax)
  80379a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80379d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a0:	89 50 04             	mov    %edx,0x4(%eax)
  8037a3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037a6:	8b 00                	mov    (%eax),%eax
  8037a8:	85 c0                	test   %eax,%eax
  8037aa:	75 08                	jne    8037b4 <realloc_block_FF+0x65a>
  8037ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037af:	a3 30 50 80 00       	mov    %eax,0x805030
  8037b4:	a1 38 50 80 00       	mov    0x805038,%eax
  8037b9:	40                   	inc    %eax
  8037ba:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037c3:	75 17                	jne    8037dc <realloc_block_FF+0x682>
  8037c5:	83 ec 04             	sub    $0x4,%esp
  8037c8:	68 e3 43 80 00       	push   $0x8043e3
  8037cd:	68 45 02 00 00       	push   $0x245
  8037d2:	68 01 44 80 00       	push   $0x804401
  8037d7:	e8 aa ca ff ff       	call   800286 <_panic>
  8037dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037df:	8b 00                	mov    (%eax),%eax
  8037e1:	85 c0                	test   %eax,%eax
  8037e3:	74 10                	je     8037f5 <realloc_block_FF+0x69b>
  8037e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e8:	8b 00                	mov    (%eax),%eax
  8037ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ed:	8b 52 04             	mov    0x4(%edx),%edx
  8037f0:	89 50 04             	mov    %edx,0x4(%eax)
  8037f3:	eb 0b                	jmp    803800 <realloc_block_FF+0x6a6>
  8037f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f8:	8b 40 04             	mov    0x4(%eax),%eax
  8037fb:	a3 30 50 80 00       	mov    %eax,0x805030
  803800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803803:	8b 40 04             	mov    0x4(%eax),%eax
  803806:	85 c0                	test   %eax,%eax
  803808:	74 0f                	je     803819 <realloc_block_FF+0x6bf>
  80380a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380d:	8b 40 04             	mov    0x4(%eax),%eax
  803810:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803813:	8b 12                	mov    (%edx),%edx
  803815:	89 10                	mov    %edx,(%eax)
  803817:	eb 0a                	jmp    803823 <realloc_block_FF+0x6c9>
  803819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803823:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803826:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80382c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803836:	a1 38 50 80 00       	mov    0x805038,%eax
  80383b:	48                   	dec    %eax
  80383c:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803841:	83 ec 04             	sub    $0x4,%esp
  803844:	6a 00                	push   $0x0
  803846:	ff 75 bc             	pushl  -0x44(%ebp)
  803849:	ff 75 b8             	pushl  -0x48(%ebp)
  80384c:	e8 39 e9 ff ff       	call   80218a <set_block_data>
  803851:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803854:	8b 45 08             	mov    0x8(%ebp),%eax
  803857:	eb 0a                	jmp    803863 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803859:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803860:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803863:	c9                   	leave  
  803864:	c3                   	ret    

00803865 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803865:	55                   	push   %ebp
  803866:	89 e5                	mov    %esp,%ebp
  803868:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80386b:	83 ec 04             	sub    $0x4,%esp
  80386e:	68 e0 44 80 00       	push   $0x8044e0
  803873:	68 58 02 00 00       	push   $0x258
  803878:	68 01 44 80 00       	push   $0x804401
  80387d:	e8 04 ca ff ff       	call   800286 <_panic>

00803882 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803882:	55                   	push   %ebp
  803883:	89 e5                	mov    %esp,%ebp
  803885:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803888:	83 ec 04             	sub    $0x4,%esp
  80388b:	68 08 45 80 00       	push   $0x804508
  803890:	68 61 02 00 00       	push   $0x261
  803895:	68 01 44 80 00       	push   $0x804401
  80389a:	e8 e7 c9 ff ff       	call   800286 <_panic>

0080389f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80389f:	55                   	push   %ebp
  8038a0:	89 e5                	mov    %esp,%ebp
  8038a2:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8038a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8038a8:	89 d0                	mov    %edx,%eax
  8038aa:	c1 e0 02             	shl    $0x2,%eax
  8038ad:	01 d0                	add    %edx,%eax
  8038af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038b6:	01 d0                	add    %edx,%eax
  8038b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038bf:	01 d0                	add    %edx,%eax
  8038c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038c8:	01 d0                	add    %edx,%eax
  8038ca:	c1 e0 04             	shl    $0x4,%eax
  8038cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8038d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8038d7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8038da:	83 ec 0c             	sub    $0xc,%esp
  8038dd:	50                   	push   %eax
  8038de:	e8 62 e2 ff ff       	call   801b45 <sys_get_virtual_time>
  8038e3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8038e6:	eb 41                	jmp    803929 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8038e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8038eb:	83 ec 0c             	sub    $0xc,%esp
  8038ee:	50                   	push   %eax
  8038ef:	e8 51 e2 ff ff       	call   801b45 <sys_get_virtual_time>
  8038f4:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8038f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fd:	29 c2                	sub    %eax,%edx
  8038ff:	89 d0                	mov    %edx,%eax
  803901:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803904:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803907:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80390a:	89 d1                	mov    %edx,%ecx
  80390c:	29 c1                	sub    %eax,%ecx
  80390e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803911:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803914:	39 c2                	cmp    %eax,%edx
  803916:	0f 97 c0             	seta   %al
  803919:	0f b6 c0             	movzbl %al,%eax
  80391c:	29 c1                	sub    %eax,%ecx
  80391e:	89 c8                	mov    %ecx,%eax
  803920:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803923:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803926:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80392f:	72 b7                	jb     8038e8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803931:	90                   	nop
  803932:	c9                   	leave  
  803933:	c3                   	ret    

00803934 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803934:	55                   	push   %ebp
  803935:	89 e5                	mov    %esp,%ebp
  803937:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80393a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803941:	eb 03                	jmp    803946 <busy_wait+0x12>
  803943:	ff 45 fc             	incl   -0x4(%ebp)
  803946:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803949:	3b 45 08             	cmp    0x8(%ebp),%eax
  80394c:	72 f5                	jb     803943 <busy_wait+0xf>
	return i;
  80394e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803951:	c9                   	leave  
  803952:	c3                   	ret    
  803953:	90                   	nop

00803954 <__udivdi3>:
  803954:	55                   	push   %ebp
  803955:	57                   	push   %edi
  803956:	56                   	push   %esi
  803957:	53                   	push   %ebx
  803958:	83 ec 1c             	sub    $0x1c,%esp
  80395b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80395f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803963:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803967:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80396b:	89 ca                	mov    %ecx,%edx
  80396d:	89 f8                	mov    %edi,%eax
  80396f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803973:	85 f6                	test   %esi,%esi
  803975:	75 2d                	jne    8039a4 <__udivdi3+0x50>
  803977:	39 cf                	cmp    %ecx,%edi
  803979:	77 65                	ja     8039e0 <__udivdi3+0x8c>
  80397b:	89 fd                	mov    %edi,%ebp
  80397d:	85 ff                	test   %edi,%edi
  80397f:	75 0b                	jne    80398c <__udivdi3+0x38>
  803981:	b8 01 00 00 00       	mov    $0x1,%eax
  803986:	31 d2                	xor    %edx,%edx
  803988:	f7 f7                	div    %edi
  80398a:	89 c5                	mov    %eax,%ebp
  80398c:	31 d2                	xor    %edx,%edx
  80398e:	89 c8                	mov    %ecx,%eax
  803990:	f7 f5                	div    %ebp
  803992:	89 c1                	mov    %eax,%ecx
  803994:	89 d8                	mov    %ebx,%eax
  803996:	f7 f5                	div    %ebp
  803998:	89 cf                	mov    %ecx,%edi
  80399a:	89 fa                	mov    %edi,%edx
  80399c:	83 c4 1c             	add    $0x1c,%esp
  80399f:	5b                   	pop    %ebx
  8039a0:	5e                   	pop    %esi
  8039a1:	5f                   	pop    %edi
  8039a2:	5d                   	pop    %ebp
  8039a3:	c3                   	ret    
  8039a4:	39 ce                	cmp    %ecx,%esi
  8039a6:	77 28                	ja     8039d0 <__udivdi3+0x7c>
  8039a8:	0f bd fe             	bsr    %esi,%edi
  8039ab:	83 f7 1f             	xor    $0x1f,%edi
  8039ae:	75 40                	jne    8039f0 <__udivdi3+0x9c>
  8039b0:	39 ce                	cmp    %ecx,%esi
  8039b2:	72 0a                	jb     8039be <__udivdi3+0x6a>
  8039b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039b8:	0f 87 9e 00 00 00    	ja     803a5c <__udivdi3+0x108>
  8039be:	b8 01 00 00 00       	mov    $0x1,%eax
  8039c3:	89 fa                	mov    %edi,%edx
  8039c5:	83 c4 1c             	add    $0x1c,%esp
  8039c8:	5b                   	pop    %ebx
  8039c9:	5e                   	pop    %esi
  8039ca:	5f                   	pop    %edi
  8039cb:	5d                   	pop    %ebp
  8039cc:	c3                   	ret    
  8039cd:	8d 76 00             	lea    0x0(%esi),%esi
  8039d0:	31 ff                	xor    %edi,%edi
  8039d2:	31 c0                	xor    %eax,%eax
  8039d4:	89 fa                	mov    %edi,%edx
  8039d6:	83 c4 1c             	add    $0x1c,%esp
  8039d9:	5b                   	pop    %ebx
  8039da:	5e                   	pop    %esi
  8039db:	5f                   	pop    %edi
  8039dc:	5d                   	pop    %ebp
  8039dd:	c3                   	ret    
  8039de:	66 90                	xchg   %ax,%ax
  8039e0:	89 d8                	mov    %ebx,%eax
  8039e2:	f7 f7                	div    %edi
  8039e4:	31 ff                	xor    %edi,%edi
  8039e6:	89 fa                	mov    %edi,%edx
  8039e8:	83 c4 1c             	add    $0x1c,%esp
  8039eb:	5b                   	pop    %ebx
  8039ec:	5e                   	pop    %esi
  8039ed:	5f                   	pop    %edi
  8039ee:	5d                   	pop    %ebp
  8039ef:	c3                   	ret    
  8039f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039f5:	89 eb                	mov    %ebp,%ebx
  8039f7:	29 fb                	sub    %edi,%ebx
  8039f9:	89 f9                	mov    %edi,%ecx
  8039fb:	d3 e6                	shl    %cl,%esi
  8039fd:	89 c5                	mov    %eax,%ebp
  8039ff:	88 d9                	mov    %bl,%cl
  803a01:	d3 ed                	shr    %cl,%ebp
  803a03:	89 e9                	mov    %ebp,%ecx
  803a05:	09 f1                	or     %esi,%ecx
  803a07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a0b:	89 f9                	mov    %edi,%ecx
  803a0d:	d3 e0                	shl    %cl,%eax
  803a0f:	89 c5                	mov    %eax,%ebp
  803a11:	89 d6                	mov    %edx,%esi
  803a13:	88 d9                	mov    %bl,%cl
  803a15:	d3 ee                	shr    %cl,%esi
  803a17:	89 f9                	mov    %edi,%ecx
  803a19:	d3 e2                	shl    %cl,%edx
  803a1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a1f:	88 d9                	mov    %bl,%cl
  803a21:	d3 e8                	shr    %cl,%eax
  803a23:	09 c2                	or     %eax,%edx
  803a25:	89 d0                	mov    %edx,%eax
  803a27:	89 f2                	mov    %esi,%edx
  803a29:	f7 74 24 0c          	divl   0xc(%esp)
  803a2d:	89 d6                	mov    %edx,%esi
  803a2f:	89 c3                	mov    %eax,%ebx
  803a31:	f7 e5                	mul    %ebp
  803a33:	39 d6                	cmp    %edx,%esi
  803a35:	72 19                	jb     803a50 <__udivdi3+0xfc>
  803a37:	74 0b                	je     803a44 <__udivdi3+0xf0>
  803a39:	89 d8                	mov    %ebx,%eax
  803a3b:	31 ff                	xor    %edi,%edi
  803a3d:	e9 58 ff ff ff       	jmp    80399a <__udivdi3+0x46>
  803a42:	66 90                	xchg   %ax,%ax
  803a44:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a48:	89 f9                	mov    %edi,%ecx
  803a4a:	d3 e2                	shl    %cl,%edx
  803a4c:	39 c2                	cmp    %eax,%edx
  803a4e:	73 e9                	jae    803a39 <__udivdi3+0xe5>
  803a50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a53:	31 ff                	xor    %edi,%edi
  803a55:	e9 40 ff ff ff       	jmp    80399a <__udivdi3+0x46>
  803a5a:	66 90                	xchg   %ax,%ax
  803a5c:	31 c0                	xor    %eax,%eax
  803a5e:	e9 37 ff ff ff       	jmp    80399a <__udivdi3+0x46>
  803a63:	90                   	nop

00803a64 <__umoddi3>:
  803a64:	55                   	push   %ebp
  803a65:	57                   	push   %edi
  803a66:	56                   	push   %esi
  803a67:	53                   	push   %ebx
  803a68:	83 ec 1c             	sub    $0x1c,%esp
  803a6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a83:	89 f3                	mov    %esi,%ebx
  803a85:	89 fa                	mov    %edi,%edx
  803a87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a8b:	89 34 24             	mov    %esi,(%esp)
  803a8e:	85 c0                	test   %eax,%eax
  803a90:	75 1a                	jne    803aac <__umoddi3+0x48>
  803a92:	39 f7                	cmp    %esi,%edi
  803a94:	0f 86 a2 00 00 00    	jbe    803b3c <__umoddi3+0xd8>
  803a9a:	89 c8                	mov    %ecx,%eax
  803a9c:	89 f2                	mov    %esi,%edx
  803a9e:	f7 f7                	div    %edi
  803aa0:	89 d0                	mov    %edx,%eax
  803aa2:	31 d2                	xor    %edx,%edx
  803aa4:	83 c4 1c             	add    $0x1c,%esp
  803aa7:	5b                   	pop    %ebx
  803aa8:	5e                   	pop    %esi
  803aa9:	5f                   	pop    %edi
  803aaa:	5d                   	pop    %ebp
  803aab:	c3                   	ret    
  803aac:	39 f0                	cmp    %esi,%eax
  803aae:	0f 87 ac 00 00 00    	ja     803b60 <__umoddi3+0xfc>
  803ab4:	0f bd e8             	bsr    %eax,%ebp
  803ab7:	83 f5 1f             	xor    $0x1f,%ebp
  803aba:	0f 84 ac 00 00 00    	je     803b6c <__umoddi3+0x108>
  803ac0:	bf 20 00 00 00       	mov    $0x20,%edi
  803ac5:	29 ef                	sub    %ebp,%edi
  803ac7:	89 fe                	mov    %edi,%esi
  803ac9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803acd:	89 e9                	mov    %ebp,%ecx
  803acf:	d3 e0                	shl    %cl,%eax
  803ad1:	89 d7                	mov    %edx,%edi
  803ad3:	89 f1                	mov    %esi,%ecx
  803ad5:	d3 ef                	shr    %cl,%edi
  803ad7:	09 c7                	or     %eax,%edi
  803ad9:	89 e9                	mov    %ebp,%ecx
  803adb:	d3 e2                	shl    %cl,%edx
  803add:	89 14 24             	mov    %edx,(%esp)
  803ae0:	89 d8                	mov    %ebx,%eax
  803ae2:	d3 e0                	shl    %cl,%eax
  803ae4:	89 c2                	mov    %eax,%edx
  803ae6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aea:	d3 e0                	shl    %cl,%eax
  803aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  803af0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803af4:	89 f1                	mov    %esi,%ecx
  803af6:	d3 e8                	shr    %cl,%eax
  803af8:	09 d0                	or     %edx,%eax
  803afa:	d3 eb                	shr    %cl,%ebx
  803afc:	89 da                	mov    %ebx,%edx
  803afe:	f7 f7                	div    %edi
  803b00:	89 d3                	mov    %edx,%ebx
  803b02:	f7 24 24             	mull   (%esp)
  803b05:	89 c6                	mov    %eax,%esi
  803b07:	89 d1                	mov    %edx,%ecx
  803b09:	39 d3                	cmp    %edx,%ebx
  803b0b:	0f 82 87 00 00 00    	jb     803b98 <__umoddi3+0x134>
  803b11:	0f 84 91 00 00 00    	je     803ba8 <__umoddi3+0x144>
  803b17:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b1b:	29 f2                	sub    %esi,%edx
  803b1d:	19 cb                	sbb    %ecx,%ebx
  803b1f:	89 d8                	mov    %ebx,%eax
  803b21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b25:	d3 e0                	shl    %cl,%eax
  803b27:	89 e9                	mov    %ebp,%ecx
  803b29:	d3 ea                	shr    %cl,%edx
  803b2b:	09 d0                	or     %edx,%eax
  803b2d:	89 e9                	mov    %ebp,%ecx
  803b2f:	d3 eb                	shr    %cl,%ebx
  803b31:	89 da                	mov    %ebx,%edx
  803b33:	83 c4 1c             	add    $0x1c,%esp
  803b36:	5b                   	pop    %ebx
  803b37:	5e                   	pop    %esi
  803b38:	5f                   	pop    %edi
  803b39:	5d                   	pop    %ebp
  803b3a:	c3                   	ret    
  803b3b:	90                   	nop
  803b3c:	89 fd                	mov    %edi,%ebp
  803b3e:	85 ff                	test   %edi,%edi
  803b40:	75 0b                	jne    803b4d <__umoddi3+0xe9>
  803b42:	b8 01 00 00 00       	mov    $0x1,%eax
  803b47:	31 d2                	xor    %edx,%edx
  803b49:	f7 f7                	div    %edi
  803b4b:	89 c5                	mov    %eax,%ebp
  803b4d:	89 f0                	mov    %esi,%eax
  803b4f:	31 d2                	xor    %edx,%edx
  803b51:	f7 f5                	div    %ebp
  803b53:	89 c8                	mov    %ecx,%eax
  803b55:	f7 f5                	div    %ebp
  803b57:	89 d0                	mov    %edx,%eax
  803b59:	e9 44 ff ff ff       	jmp    803aa2 <__umoddi3+0x3e>
  803b5e:	66 90                	xchg   %ax,%ax
  803b60:	89 c8                	mov    %ecx,%eax
  803b62:	89 f2                	mov    %esi,%edx
  803b64:	83 c4 1c             	add    $0x1c,%esp
  803b67:	5b                   	pop    %ebx
  803b68:	5e                   	pop    %esi
  803b69:	5f                   	pop    %edi
  803b6a:	5d                   	pop    %ebp
  803b6b:	c3                   	ret    
  803b6c:	3b 04 24             	cmp    (%esp),%eax
  803b6f:	72 06                	jb     803b77 <__umoddi3+0x113>
  803b71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b75:	77 0f                	ja     803b86 <__umoddi3+0x122>
  803b77:	89 f2                	mov    %esi,%edx
  803b79:	29 f9                	sub    %edi,%ecx
  803b7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b7f:	89 14 24             	mov    %edx,(%esp)
  803b82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b86:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b8a:	8b 14 24             	mov    (%esp),%edx
  803b8d:	83 c4 1c             	add    $0x1c,%esp
  803b90:	5b                   	pop    %ebx
  803b91:	5e                   	pop    %esi
  803b92:	5f                   	pop    %edi
  803b93:	5d                   	pop    %ebp
  803b94:	c3                   	ret    
  803b95:	8d 76 00             	lea    0x0(%esi),%esi
  803b98:	2b 04 24             	sub    (%esp),%eax
  803b9b:	19 fa                	sbb    %edi,%edx
  803b9d:	89 d1                	mov    %edx,%ecx
  803b9f:	89 c6                	mov    %eax,%esi
  803ba1:	e9 71 ff ff ff       	jmp    803b17 <__umoddi3+0xb3>
  803ba6:	66 90                	xchg   %ax,%ax
  803ba8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bac:	72 ea                	jb     803b98 <__umoddi3+0x134>
  803bae:	89 d9                	mov    %ebx,%ecx
  803bb0:	e9 62 ff ff ff       	jmp    803b17 <__umoddi3+0xb3>
