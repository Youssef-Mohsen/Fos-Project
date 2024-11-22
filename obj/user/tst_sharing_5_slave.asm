
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 c8 00 00 00       	call   8000fe <libmain>
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
  80003b:	83 ec 28             	sub    $0x28,%esp
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
  80005b:	68 a0 3a 80 00       	push   $0x803aa0
  800060:	6a 0c                	push   $0xc
  800062:	68 bc 3a 80 00       	push   $0x803abc
  800067:	e8 d1 01 00 00       	call   80023d <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	x = sget(sys_getparentenvid(),"x");
  800073:	e8 f6 19 00 00       	call   801a6e <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 d7 3a 80 00       	push   $0x803ad7
  800080:	50                   	push   %eax
  800081:	e8 d0 15 00 00       	call   801656 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80008c:	e8 fb 17 00 00       	call   80188c <sys_calculate_free_frames>
  800091:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 dc 3a 80 00       	push   $0x803adc
  80009c:	e8 59 04 00 00       	call   8004fa <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000aa:	e8 2c 16 00 00       	call   8016db <sfree>
  8000af:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave env removed x\n");
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 00 3b 80 00       	push   $0x803b00
  8000ba:	e8 3b 04 00 00       	call   8004fa <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp

	diff = (sys_calculate_free_frames() - freeFrames);
  8000c2:	e8 c5 17 00 00       	call   80188c <sys_calculate_free_frames>
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cc:	29 c2                	sub    %eax,%edx
  8000ce:	89 d0                	mov    %edx,%eax
  8000d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	expected = 1;
  8000d3:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000dd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000e0:	74 14                	je     8000f6 <_main+0xbe>
  8000e2:	83 ec 04             	sub    $0x4,%esp
  8000e5:	68 18 3b 80 00       	push   $0x803b18
  8000ea:	6a 23                	push   $0x23
  8000ec:	68 bc 3a 80 00       	push   $0x803abc
  8000f1:	e8 47 01 00 00       	call   80023d <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  8000f6:	e8 98 1a 00 00       	call   801b93 <inctst>

	return;
  8000fb:	90                   	nop
}
  8000fc:	c9                   	leave  
  8000fd:	c3                   	ret    

008000fe <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800104:	e8 4c 19 00 00       	call   801a55 <sys_getenvindex>
  800109:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80010c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80010f:	89 d0                	mov    %edx,%eax
  800111:	c1 e0 03             	shl    $0x3,%eax
  800114:	01 d0                	add    %edx,%eax
  800116:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80011d:	01 c8                	add    %ecx,%eax
  80011f:	01 c0                	add    %eax,%eax
  800121:	01 d0                	add    %edx,%eax
  800123:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80012a:	01 c8                	add    %ecx,%eax
  80012c:	01 d0                	add    %edx,%eax
  80012e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800133:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800138:	a1 20 50 80 00       	mov    0x805020,%eax
  80013d:	8a 40 20             	mov    0x20(%eax),%al
  800140:	84 c0                	test   %al,%al
  800142:	74 0d                	je     800151 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800144:	a1 20 50 80 00       	mov    0x805020,%eax
  800149:	83 c0 20             	add    $0x20,%eax
  80014c:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800151:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800155:	7e 0a                	jle    800161 <libmain+0x63>
		binaryname = argv[0];
  800157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015a:	8b 00                	mov    (%eax),%eax
  80015c:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	ff 75 0c             	pushl  0xc(%ebp)
  800167:	ff 75 08             	pushl  0x8(%ebp)
  80016a:	e8 c9 fe ff ff       	call   800038 <_main>
  80016f:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800172:	e8 62 16 00 00       	call   8017d9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 bc 3b 80 00       	push   $0x803bbc
  80017f:	e8 76 03 00 00       	call   8004fa <cprintf>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800187:	a1 20 50 80 00       	mov    0x805020,%eax
  80018c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800192:	a1 20 50 80 00       	mov    0x805020,%eax
  800197:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80019d:	83 ec 04             	sub    $0x4,%esp
  8001a0:	52                   	push   %edx
  8001a1:	50                   	push   %eax
  8001a2:	68 e4 3b 80 00       	push   $0x803be4
  8001a7:	e8 4e 03 00 00       	call   8004fa <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001af:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b4:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8001bf:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ca:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001d0:	51                   	push   %ecx
  8001d1:	52                   	push   %edx
  8001d2:	50                   	push   %eax
  8001d3:	68 0c 3c 80 00       	push   $0x803c0c
  8001d8:	e8 1d 03 00 00       	call   8004fa <cprintf>
  8001dd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001e5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001eb:	83 ec 08             	sub    $0x8,%esp
  8001ee:	50                   	push   %eax
  8001ef:	68 64 3c 80 00       	push   $0x803c64
  8001f4:	e8 01 03 00 00       	call   8004fa <cprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	68 bc 3b 80 00       	push   $0x803bbc
  800204:	e8 f1 02 00 00       	call   8004fa <cprintf>
  800209:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80020c:	e8 e2 15 00 00       	call   8017f3 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800211:	e8 19 00 00 00       	call   80022f <exit>
}
  800216:	90                   	nop
  800217:	c9                   	leave  
  800218:	c3                   	ret    

00800219 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	6a 00                	push   $0x0
  800224:	e8 f8 17 00 00       	call   801a21 <sys_destroy_env>
  800229:	83 c4 10             	add    $0x10,%esp
}
  80022c:	90                   	nop
  80022d:	c9                   	leave  
  80022e:	c3                   	ret    

0080022f <exit>:

void
exit(void)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800235:	e8 4d 18 00 00       	call   801a87 <sys_exit_env>
}
  80023a:	90                   	nop
  80023b:	c9                   	leave  
  80023c:	c3                   	ret    

0080023d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800243:	8d 45 10             	lea    0x10(%ebp),%eax
  800246:	83 c0 04             	add    $0x4,%eax
  800249:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80024c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800251:	85 c0                	test   %eax,%eax
  800253:	74 16                	je     80026b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800255:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	50                   	push   %eax
  80025e:	68 78 3c 80 00       	push   $0x803c78
  800263:	e8 92 02 00 00       	call   8004fa <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80026b:	a1 00 50 80 00       	mov    0x805000,%eax
  800270:	ff 75 0c             	pushl  0xc(%ebp)
  800273:	ff 75 08             	pushl  0x8(%ebp)
  800276:	50                   	push   %eax
  800277:	68 7d 3c 80 00       	push   $0x803c7d
  80027c:	e8 79 02 00 00       	call   8004fa <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800284:	8b 45 10             	mov    0x10(%ebp),%eax
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	ff 75 f4             	pushl  -0xc(%ebp)
  80028d:	50                   	push   %eax
  80028e:	e8 fc 01 00 00       	call   80048f <vcprintf>
  800293:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	6a 00                	push   $0x0
  80029b:	68 99 3c 80 00       	push   $0x803c99
  8002a0:	e8 ea 01 00 00       	call   80048f <vcprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002a8:	e8 82 ff ff ff       	call   80022f <exit>

	// should not return here
	while (1) ;
  8002ad:	eb fe                	jmp    8002ad <_panic+0x70>

008002af <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ba:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 9c 3c 80 00       	push   $0x803c9c
  8002cf:	6a 26                	push   $0x26
  8002d1:	68 e8 3c 80 00       	push   $0x803ce8
  8002d6:	e8 62 ff ff ff       	call   80023d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002e9:	e9 c5 00 00 00       	jmp    8003b3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fb:	01 d0                	add    %edx,%eax
  8002fd:	8b 00                	mov    (%eax),%eax
  8002ff:	85 c0                	test   %eax,%eax
  800301:	75 08                	jne    80030b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800303:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800306:	e9 a5 00 00 00       	jmp    8003b0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80030b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800312:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800319:	eb 69                	jmp    800384 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80031b:	a1 20 50 80 00       	mov    0x805020,%eax
  800320:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800326:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800329:	89 d0                	mov    %edx,%eax
  80032b:	01 c0                	add    %eax,%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	c1 e0 03             	shl    $0x3,%eax
  800332:	01 c8                	add    %ecx,%eax
  800334:	8a 40 04             	mov    0x4(%eax),%al
  800337:	84 c0                	test   %al,%al
  800339:	75 46                	jne    800381 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80033b:	a1 20 50 80 00       	mov    0x805020,%eax
  800340:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800346:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800349:	89 d0                	mov    %edx,%eax
  80034b:	01 c0                	add    %eax,%eax
  80034d:	01 d0                	add    %edx,%eax
  80034f:	c1 e0 03             	shl    $0x3,%eax
  800352:	01 c8                	add    %ecx,%eax
  800354:	8b 00                	mov    (%eax),%eax
  800356:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800359:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80035c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800361:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800366:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	01 c8                	add    %ecx,%eax
  800372:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800374:	39 c2                	cmp    %eax,%edx
  800376:	75 09                	jne    800381 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800378:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80037f:	eb 15                	jmp    800396 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800381:	ff 45 e8             	incl   -0x18(%ebp)
  800384:	a1 20 50 80 00       	mov    0x805020,%eax
  800389:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80038f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800392:	39 c2                	cmp    %eax,%edx
  800394:	77 85                	ja     80031b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800396:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80039a:	75 14                	jne    8003b0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80039c:	83 ec 04             	sub    $0x4,%esp
  80039f:	68 f4 3c 80 00       	push   $0x803cf4
  8003a4:	6a 3a                	push   $0x3a
  8003a6:	68 e8 3c 80 00       	push   $0x803ce8
  8003ab:	e8 8d fe ff ff       	call   80023d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003b0:	ff 45 f0             	incl   -0x10(%ebp)
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003b9:	0f 8c 2f ff ff ff    	jl     8002ee <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003cd:	eb 26                	jmp    8003f5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8003da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003dd:	89 d0                	mov    %edx,%eax
  8003df:	01 c0                	add    %eax,%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	c1 e0 03             	shl    $0x3,%eax
  8003e6:	01 c8                	add    %ecx,%eax
  8003e8:	8a 40 04             	mov    0x4(%eax),%al
  8003eb:	3c 01                	cmp    $0x1,%al
  8003ed:	75 03                	jne    8003f2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003ef:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f2:	ff 45 e0             	incl   -0x20(%ebp)
  8003f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fa:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800400:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800403:	39 c2                	cmp    %eax,%edx
  800405:	77 c8                	ja     8003cf <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80040d:	74 14                	je     800423 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 48 3d 80 00       	push   $0x803d48
  800417:	6a 44                	push   $0x44
  800419:	68 e8 3c 80 00       	push   $0x803ce8
  80041e:	e8 1a fe ff ff       	call   80023d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800423:	90                   	nop
  800424:	c9                   	leave  
  800425:	c3                   	ret    

00800426 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80042c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	8d 48 01             	lea    0x1(%eax),%ecx
  800434:	8b 55 0c             	mov    0xc(%ebp),%edx
  800437:	89 0a                	mov    %ecx,(%edx)
  800439:	8b 55 08             	mov    0x8(%ebp),%edx
  80043c:	88 d1                	mov    %dl,%cl
  80043e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800441:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800445:	8b 45 0c             	mov    0xc(%ebp),%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80044f:	75 2c                	jne    80047d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800451:	a0 28 50 80 00       	mov    0x805028,%al
  800456:	0f b6 c0             	movzbl %al,%eax
  800459:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045c:	8b 12                	mov    (%edx),%edx
  80045e:	89 d1                	mov    %edx,%ecx
  800460:	8b 55 0c             	mov    0xc(%ebp),%edx
  800463:	83 c2 08             	add    $0x8,%edx
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	50                   	push   %eax
  80046a:	51                   	push   %ecx
  80046b:	52                   	push   %edx
  80046c:	e8 26 13 00 00       	call   801797 <sys_cputs>
  800471:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800474:	8b 45 0c             	mov    0xc(%ebp),%eax
  800477:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80047d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800480:	8b 40 04             	mov    0x4(%eax),%eax
  800483:	8d 50 01             	lea    0x1(%eax),%edx
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	89 50 04             	mov    %edx,0x4(%eax)
}
  80048c:	90                   	nop
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800498:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80049f:	00 00 00 
	b.cnt = 0;
  8004a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004a9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004ac:	ff 75 0c             	pushl  0xc(%ebp)
  8004af:	ff 75 08             	pushl  0x8(%ebp)
  8004b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b8:	50                   	push   %eax
  8004b9:	68 26 04 80 00       	push   $0x800426
  8004be:	e8 11 02 00 00       	call   8006d4 <vprintfmt>
  8004c3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004c6:	a0 28 50 80 00       	mov    0x805028,%al
  8004cb:	0f b6 c0             	movzbl %al,%eax
  8004ce:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004d4:	83 ec 04             	sub    $0x4,%esp
  8004d7:	50                   	push   %eax
  8004d8:	52                   	push   %edx
  8004d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004df:	83 c0 08             	add    $0x8,%eax
  8004e2:	50                   	push   %eax
  8004e3:	e8 af 12 00 00       	call   801797 <sys_cputs>
  8004e8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004eb:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8004f2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800500:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800507:	8d 45 0c             	lea    0xc(%ebp),%eax
  80050a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	ff 75 f4             	pushl  -0xc(%ebp)
  800516:	50                   	push   %eax
  800517:	e8 73 ff ff ff       	call   80048f <vcprintf>
  80051c:	83 c4 10             	add    $0x10,%esp
  80051f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800522:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800525:	c9                   	leave  
  800526:	c3                   	ret    

00800527 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80052d:	e8 a7 12 00 00       	call   8017d9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800532:	8d 45 0c             	lea    0xc(%ebp),%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 48 ff ff ff       	call   80048f <vcprintf>
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80054d:	e8 a1 12 00 00       	call   8017f3 <sys_unlock_cons>
	return cnt;
  800552:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800555:	c9                   	leave  
  800556:	c3                   	ret    

00800557 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800557:	55                   	push   %ebp
  800558:	89 e5                	mov    %esp,%ebp
  80055a:	53                   	push   %ebx
  80055b:	83 ec 14             	sub    $0x14,%esp
  80055e:	8b 45 10             	mov    0x10(%ebp),%eax
  800561:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80056a:	8b 45 18             	mov    0x18(%ebp),%eax
  80056d:	ba 00 00 00 00       	mov    $0x0,%edx
  800572:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800575:	77 55                	ja     8005cc <printnum+0x75>
  800577:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80057a:	72 05                	jb     800581 <printnum+0x2a>
  80057c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80057f:	77 4b                	ja     8005cc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800581:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800584:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800587:	8b 45 18             	mov    0x18(%ebp),%eax
  80058a:	ba 00 00 00 00       	mov    $0x0,%edx
  80058f:	52                   	push   %edx
  800590:	50                   	push   %eax
  800591:	ff 75 f4             	pushl  -0xc(%ebp)
  800594:	ff 75 f0             	pushl  -0x10(%ebp)
  800597:	e8 94 32 00 00       	call   803830 <__udivdi3>
  80059c:	83 c4 10             	add    $0x10,%esp
  80059f:	83 ec 04             	sub    $0x4,%esp
  8005a2:	ff 75 20             	pushl  0x20(%ebp)
  8005a5:	53                   	push   %ebx
  8005a6:	ff 75 18             	pushl  0x18(%ebp)
  8005a9:	52                   	push   %edx
  8005aa:	50                   	push   %eax
  8005ab:	ff 75 0c             	pushl  0xc(%ebp)
  8005ae:	ff 75 08             	pushl  0x8(%ebp)
  8005b1:	e8 a1 ff ff ff       	call   800557 <printnum>
  8005b6:	83 c4 20             	add    $0x20,%esp
  8005b9:	eb 1a                	jmp    8005d5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	ff 75 0c             	pushl  0xc(%ebp)
  8005c1:	ff 75 20             	pushl  0x20(%ebp)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	ff d0                	call   *%eax
  8005c9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005cc:	ff 4d 1c             	decl   0x1c(%ebp)
  8005cf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005d3:	7f e6                	jg     8005bb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005d5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005e3:	53                   	push   %ebx
  8005e4:	51                   	push   %ecx
  8005e5:	52                   	push   %edx
  8005e6:	50                   	push   %eax
  8005e7:	e8 54 33 00 00       	call   803940 <__umoddi3>
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	05 b4 3f 80 00       	add    $0x803fb4,%eax
  8005f4:	8a 00                	mov    (%eax),%al
  8005f6:	0f be c0             	movsbl %al,%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 0c             	pushl  0xc(%ebp)
  8005ff:	50                   	push   %eax
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
}
  800608:	90                   	nop
  800609:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800611:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800615:	7e 1c                	jle    800633 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	8d 50 08             	lea    0x8(%eax),%edx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	89 10                	mov    %edx,(%eax)
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	83 e8 08             	sub    $0x8,%eax
  80062c:	8b 50 04             	mov    0x4(%eax),%edx
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	eb 40                	jmp    800673 <getuint+0x65>
	else if (lflag)
  800633:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800637:	74 1e                	je     800657 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	8d 50 04             	lea    0x4(%eax),%edx
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	89 10                	mov    %edx,(%eax)
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	83 e8 04             	sub    $0x4,%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	ba 00 00 00 00       	mov    $0x0,%edx
  800655:	eb 1c                	jmp    800673 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	8d 50 04             	lea    0x4(%eax),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	89 10                	mov    %edx,(%eax)
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	83 e8 04             	sub    $0x4,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800673:	5d                   	pop    %ebp
  800674:	c3                   	ret    

00800675 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800675:	55                   	push   %ebp
  800676:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800678:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80067c:	7e 1c                	jle    80069a <getint+0x25>
		return va_arg(*ap, long long);
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	8d 50 08             	lea    0x8(%eax),%edx
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	89 10                	mov    %edx,(%eax)
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	83 e8 08             	sub    $0x8,%eax
  800693:	8b 50 04             	mov    0x4(%eax),%edx
  800696:	8b 00                	mov    (%eax),%eax
  800698:	eb 38                	jmp    8006d2 <getint+0x5d>
	else if (lflag)
  80069a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80069e:	74 1a                	je     8006ba <getint+0x45>
		return va_arg(*ap, long);
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	8d 50 04             	lea    0x4(%eax),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	89 10                	mov    %edx,(%eax)
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	83 e8 04             	sub    $0x4,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	99                   	cltd   
  8006b8:	eb 18                	jmp    8006d2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 04             	lea    0x4(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 04             	sub    $0x4,%eax
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	99                   	cltd   
}
  8006d2:	5d                   	pop    %ebp
  8006d3:	c3                   	ret    

008006d4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	56                   	push   %esi
  8006d8:	53                   	push   %ebx
  8006d9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006dc:	eb 17                	jmp    8006f5 <vprintfmt+0x21>
			if (ch == '\0')
  8006de:	85 db                	test   %ebx,%ebx
  8006e0:	0f 84 c1 03 00 00    	je     800aa7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	53                   	push   %ebx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	ff d0                	call   *%eax
  8006f2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f8:	8d 50 01             	lea    0x1(%eax),%edx
  8006fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8006fe:	8a 00                	mov    (%eax),%al
  800700:	0f b6 d8             	movzbl %al,%ebx
  800703:	83 fb 25             	cmp    $0x25,%ebx
  800706:	75 d6                	jne    8006de <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800708:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80070c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800713:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80071a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800721:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800728:	8b 45 10             	mov    0x10(%ebp),%eax
  80072b:	8d 50 01             	lea    0x1(%eax),%edx
  80072e:	89 55 10             	mov    %edx,0x10(%ebp)
  800731:	8a 00                	mov    (%eax),%al
  800733:	0f b6 d8             	movzbl %al,%ebx
  800736:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800739:	83 f8 5b             	cmp    $0x5b,%eax
  80073c:	0f 87 3d 03 00 00    	ja     800a7f <vprintfmt+0x3ab>
  800742:	8b 04 85 d8 3f 80 00 	mov    0x803fd8(,%eax,4),%eax
  800749:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80074b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80074f:	eb d7                	jmp    800728 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800751:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800755:	eb d1                	jmp    800728 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800757:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80075e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800761:	89 d0                	mov    %edx,%eax
  800763:	c1 e0 02             	shl    $0x2,%eax
  800766:	01 d0                	add    %edx,%eax
  800768:	01 c0                	add    %eax,%eax
  80076a:	01 d8                	add    %ebx,%eax
  80076c:	83 e8 30             	sub    $0x30,%eax
  80076f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	8a 00                	mov    (%eax),%al
  800777:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80077a:	83 fb 2f             	cmp    $0x2f,%ebx
  80077d:	7e 3e                	jle    8007bd <vprintfmt+0xe9>
  80077f:	83 fb 39             	cmp    $0x39,%ebx
  800782:	7f 39                	jg     8007bd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800784:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800787:	eb d5                	jmp    80075e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	83 c0 04             	add    $0x4,%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	83 e8 04             	sub    $0x4,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80079d:	eb 1f                	jmp    8007be <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80079f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a3:	79 83                	jns    800728 <vprintfmt+0x54>
				width = 0;
  8007a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007ac:	e9 77 ff ff ff       	jmp    800728 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007b1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007b8:	e9 6b ff ff ff       	jmp    800728 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007bd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c2:	0f 89 60 ff ff ff    	jns    800728 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007d5:	e9 4e ff ff ff       	jmp    800728 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007da:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007dd:	e9 46 ff ff ff       	jmp    800728 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	83 c0 04             	add    $0x4,%eax
  8007e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	83 e8 04             	sub    $0x4,%eax
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	ff 75 0c             	pushl  0xc(%ebp)
  8007f9:	50                   	push   %eax
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	ff d0                	call   *%eax
  8007ff:	83 c4 10             	add    $0x10,%esp
			break;
  800802:	e9 9b 02 00 00       	jmp    800aa2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	83 c0 04             	add    $0x4,%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	83 e8 04             	sub    $0x4,%eax
  800816:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800818:	85 db                	test   %ebx,%ebx
  80081a:	79 02                	jns    80081e <vprintfmt+0x14a>
				err = -err;
  80081c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80081e:	83 fb 64             	cmp    $0x64,%ebx
  800821:	7f 0b                	jg     80082e <vprintfmt+0x15a>
  800823:	8b 34 9d 20 3e 80 00 	mov    0x803e20(,%ebx,4),%esi
  80082a:	85 f6                	test   %esi,%esi
  80082c:	75 19                	jne    800847 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80082e:	53                   	push   %ebx
  80082f:	68 c5 3f 80 00       	push   $0x803fc5
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	ff 75 08             	pushl  0x8(%ebp)
  80083a:	e8 70 02 00 00       	call   800aaf <printfmt>
  80083f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800842:	e9 5b 02 00 00       	jmp    800aa2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800847:	56                   	push   %esi
  800848:	68 ce 3f 80 00       	push   $0x803fce
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	ff 75 08             	pushl  0x8(%ebp)
  800853:	e8 57 02 00 00       	call   800aaf <printfmt>
  800858:	83 c4 10             	add    $0x10,%esp
			break;
  80085b:	e9 42 02 00 00       	jmp    800aa2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	83 c0 04             	add    $0x4,%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 e8 04             	sub    $0x4,%eax
  80086f:	8b 30                	mov    (%eax),%esi
  800871:	85 f6                	test   %esi,%esi
  800873:	75 05                	jne    80087a <vprintfmt+0x1a6>
				p = "(null)";
  800875:	be d1 3f 80 00       	mov    $0x803fd1,%esi
			if (width > 0 && padc != '-')
  80087a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087e:	7e 6d                	jle    8008ed <vprintfmt+0x219>
  800880:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800884:	74 67                	je     8008ed <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800886:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	50                   	push   %eax
  80088d:	56                   	push   %esi
  80088e:	e8 1e 03 00 00       	call   800bb1 <strnlen>
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800899:	eb 16                	jmp    8008b1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80089b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	50                   	push   %eax
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	ff d0                	call   *%eax
  8008ab:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ae:	ff 4d e4             	decl   -0x1c(%ebp)
  8008b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b5:	7f e4                	jg     80089b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b7:	eb 34                	jmp    8008ed <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008bd:	74 1c                	je     8008db <vprintfmt+0x207>
  8008bf:	83 fb 1f             	cmp    $0x1f,%ebx
  8008c2:	7e 05                	jle    8008c9 <vprintfmt+0x1f5>
  8008c4:	83 fb 7e             	cmp    $0x7e,%ebx
  8008c7:	7e 12                	jle    8008db <vprintfmt+0x207>
					putch('?', putdat);
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	ff 75 0c             	pushl  0xc(%ebp)
  8008cf:	6a 3f                	push   $0x3f
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
  8008d9:	eb 0f                	jmp    8008ea <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	53                   	push   %ebx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ed:	89 f0                	mov    %esi,%eax
  8008ef:	8d 70 01             	lea    0x1(%eax),%esi
  8008f2:	8a 00                	mov    (%eax),%al
  8008f4:	0f be d8             	movsbl %al,%ebx
  8008f7:	85 db                	test   %ebx,%ebx
  8008f9:	74 24                	je     80091f <vprintfmt+0x24b>
  8008fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008ff:	78 b8                	js     8008b9 <vprintfmt+0x1e5>
  800901:	ff 4d e0             	decl   -0x20(%ebp)
  800904:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800908:	79 af                	jns    8008b9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80090a:	eb 13                	jmp    80091f <vprintfmt+0x24b>
				putch(' ', putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	6a 20                	push   $0x20
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	ff d0                	call   *%eax
  800919:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091c:	ff 4d e4             	decl   -0x1c(%ebp)
  80091f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800923:	7f e7                	jg     80090c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800925:	e9 78 01 00 00       	jmp    800aa2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 e8             	pushl  -0x18(%ebp)
  800930:	8d 45 14             	lea    0x14(%ebp),%eax
  800933:	50                   	push   %eax
  800934:	e8 3c fd ff ff       	call   800675 <getint>
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80093f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800945:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800948:	85 d2                	test   %edx,%edx
  80094a:	79 23                	jns    80096f <vprintfmt+0x29b>
				putch('-', putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	6a 2d                	push   $0x2d
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	ff d0                	call   *%eax
  800959:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80095c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800962:	f7 d8                	neg    %eax
  800964:	83 d2 00             	adc    $0x0,%edx
  800967:	f7 da                	neg    %edx
  800969:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80096f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800976:	e9 bc 00 00 00       	jmp    800a37 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	ff 75 e8             	pushl  -0x18(%ebp)
  800981:	8d 45 14             	lea    0x14(%ebp),%eax
  800984:	50                   	push   %eax
  800985:	e8 84 fc ff ff       	call   80060e <getuint>
  80098a:	83 c4 10             	add    $0x10,%esp
  80098d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800990:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800993:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80099a:	e9 98 00 00 00       	jmp    800a37 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	ff 75 0c             	pushl  0xc(%ebp)
  8009a5:	6a 58                	push   $0x58
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	ff d0                	call   *%eax
  8009ac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 58                	push   $0x58
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	ff 75 0c             	pushl  0xc(%ebp)
  8009c5:	6a 58                	push   $0x58
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	ff d0                	call   *%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
			break;
  8009cf:	e9 ce 00 00 00       	jmp    800aa2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 30                	push   $0x30
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	6a 78                	push   $0x78
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	ff d0                	call   *%eax
  8009f1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f7:	83 c0 04             	add    $0x4,%eax
  8009fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	83 e8 04             	sub    $0x4,%eax
  800a03:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a0f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a16:	eb 1f                	jmp    800a37 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a18:	83 ec 08             	sub    $0x8,%esp
  800a1b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a21:	50                   	push   %eax
  800a22:	e8 e7 fb ff ff       	call   80060e <getuint>
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a30:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a37:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a3e:	83 ec 04             	sub    $0x4,%esp
  800a41:	52                   	push   %edx
  800a42:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a45:	50                   	push   %eax
  800a46:	ff 75 f4             	pushl  -0xc(%ebp)
  800a49:	ff 75 f0             	pushl  -0x10(%ebp)
  800a4c:	ff 75 0c             	pushl  0xc(%ebp)
  800a4f:	ff 75 08             	pushl  0x8(%ebp)
  800a52:	e8 00 fb ff ff       	call   800557 <printnum>
  800a57:	83 c4 20             	add    $0x20,%esp
			break;
  800a5a:	eb 46                	jmp    800aa2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	53                   	push   %ebx
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
			break;
  800a6b:	eb 35                	jmp    800aa2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a6d:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800a74:	eb 2c                	jmp    800aa2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a76:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800a7d:	eb 23                	jmp    800aa2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 25                	push   $0x25
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a8f:	ff 4d 10             	decl   0x10(%ebp)
  800a92:	eb 03                	jmp    800a97 <vprintfmt+0x3c3>
  800a94:	ff 4d 10             	decl   0x10(%ebp)
  800a97:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9a:	48                   	dec    %eax
  800a9b:	8a 00                	mov    (%eax),%al
  800a9d:	3c 25                	cmp    $0x25,%al
  800a9f:	75 f3                	jne    800a94 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800aa1:	90                   	nop
		}
	}
  800aa2:	e9 35 fc ff ff       	jmp    8006dc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aa7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aab:	5b                   	pop    %ebx
  800aac:	5e                   	pop    %esi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ab5:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab8:	83 c0 04             	add    $0x4,%eax
  800abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800abe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac4:	50                   	push   %eax
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	ff 75 08             	pushl  0x8(%ebp)
  800acb:	e8 04 fc ff ff       	call   8006d4 <vprintfmt>
  800ad0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ad3:	90                   	nop
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	8b 40 08             	mov    0x8(%eax),%eax
  800adf:	8d 50 01             	lea    0x1(%eax),%edx
  800ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aeb:	8b 10                	mov    (%eax),%edx
  800aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af0:	8b 40 04             	mov    0x4(%eax),%eax
  800af3:	39 c2                	cmp    %eax,%edx
  800af5:	73 12                	jae    800b09 <sprintputch+0x33>
		*b->buf++ = ch;
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	8d 48 01             	lea    0x1(%eax),%ecx
  800aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b02:	89 0a                	mov    %ecx,(%edx)
  800b04:	8b 55 08             	mov    0x8(%ebp),%edx
  800b07:	88 10                	mov    %dl,(%eax)
}
  800b09:	90                   	nop
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	01 d0                	add    %edx,%eax
  800b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b31:	74 06                	je     800b39 <vsnprintf+0x2d>
  800b33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b37:	7f 07                	jg     800b40 <vsnprintf+0x34>
		return -E_INVAL;
  800b39:	b8 03 00 00 00       	mov    $0x3,%eax
  800b3e:	eb 20                	jmp    800b60 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b40:	ff 75 14             	pushl  0x14(%ebp)
  800b43:	ff 75 10             	pushl  0x10(%ebp)
  800b46:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	68 d6 0a 80 00       	push   $0x800ad6
  800b4f:	e8 80 fb ff ff       	call   8006d4 <vprintfmt>
  800b54:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b60:	c9                   	leave  
  800b61:	c3                   	ret    

00800b62 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b68:	8d 45 10             	lea    0x10(%ebp),%eax
  800b6b:	83 c0 04             	add    $0x4,%eax
  800b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b71:	8b 45 10             	mov    0x10(%ebp),%eax
  800b74:	ff 75 f4             	pushl  -0xc(%ebp)
  800b77:	50                   	push   %eax
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	ff 75 08             	pushl  0x8(%ebp)
  800b7e:	e8 89 ff ff ff       	call   800b0c <vsnprintf>
  800b83:	83 c4 10             	add    $0x10,%esp
  800b86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8c:	c9                   	leave  
  800b8d:	c3                   	ret    

00800b8e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9b:	eb 06                	jmp    800ba3 <strlen+0x15>
		n++;
  800b9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba0:	ff 45 08             	incl   0x8(%ebp)
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	8a 00                	mov    (%eax),%al
  800ba8:	84 c0                	test   %al,%al
  800baa:	75 f1                	jne    800b9d <strlen+0xf>
		n++;
	return n;
  800bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bbe:	eb 09                	jmp    800bc9 <strnlen+0x18>
		n++;
  800bc0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc3:	ff 45 08             	incl   0x8(%ebp)
  800bc6:	ff 4d 0c             	decl   0xc(%ebp)
  800bc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bcd:	74 09                	je     800bd8 <strnlen+0x27>
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8a 00                	mov    (%eax),%al
  800bd4:	84 c0                	test   %al,%al
  800bd6:	75 e8                	jne    800bc0 <strnlen+0xf>
		n++;
	return n;
  800bd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bdb:	c9                   	leave  
  800bdc:	c3                   	ret    

00800bdd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800be9:	90                   	nop
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	8d 50 01             	lea    0x1(%eax),%edx
  800bf0:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bfc:	8a 12                	mov    (%edx),%dl
  800bfe:	88 10                	mov    %dl,(%eax)
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	75 e4                	jne    800bea <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1e:	eb 1f                	jmp    800c3f <strncpy+0x34>
		*dst++ = *src;
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8d 50 01             	lea    0x1(%eax),%edx
  800c26:	89 55 08             	mov    %edx,0x8(%ebp)
  800c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2c:	8a 12                	mov    (%edx),%dl
  800c2e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c33:	8a 00                	mov    (%eax),%al
  800c35:	84 c0                	test   %al,%al
  800c37:	74 03                	je     800c3c <strncpy+0x31>
			src++;
  800c39:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3c:	ff 45 fc             	incl   -0x4(%ebp)
  800c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c42:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c45:	72 d9                	jb     800c20 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c47:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5c:	74 30                	je     800c8e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c5e:	eb 16                	jmp    800c76 <strlcpy+0x2a>
			*dst++ = *src++;
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	89 55 08             	mov    %edx,0x8(%ebp)
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c72:	8a 12                	mov    (%edx),%dl
  800c74:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c76:	ff 4d 10             	decl   0x10(%ebp)
  800c79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7d:	74 09                	je     800c88 <strlcpy+0x3c>
  800c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	84 c0                	test   %al,%al
  800c86:	75 d8                	jne    800c60 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c94:	29 c2                	sub    %eax,%edx
  800c96:	89 d0                	mov    %edx,%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c9d:	eb 06                	jmp    800ca5 <strcmp+0xb>
		p++, q++;
  800c9f:	ff 45 08             	incl   0x8(%ebp)
  800ca2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	84 c0                	test   %al,%al
  800cac:	74 0e                	je     800cbc <strcmp+0x22>
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8a 10                	mov    (%eax),%dl
  800cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	38 c2                	cmp    %al,%dl
  800cba:	74 e3                	je     800c9f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	0f b6 d0             	movzbl %al,%edx
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	0f b6 c0             	movzbl %al,%eax
  800ccc:	29 c2                	sub    %eax,%edx
  800cce:	89 d0                	mov    %edx,%eax
}
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd5:	eb 09                	jmp    800ce0 <strncmp+0xe>
		n--, p++, q++;
  800cd7:	ff 4d 10             	decl   0x10(%ebp)
  800cda:	ff 45 08             	incl   0x8(%ebp)
  800cdd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ce0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce4:	74 17                	je     800cfd <strncmp+0x2b>
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	84 c0                	test   %al,%al
  800ced:	74 0e                	je     800cfd <strncmp+0x2b>
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8a 10                	mov    (%eax),%dl
  800cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	38 c2                	cmp    %al,%dl
  800cfb:	74 da                	je     800cd7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d01:	75 07                	jne    800d0a <strncmp+0x38>
		return 0;
  800d03:	b8 00 00 00 00       	mov    $0x0,%eax
  800d08:	eb 14                	jmp    800d1e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	0f b6 d0             	movzbl %al,%edx
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	0f b6 c0             	movzbl %al,%eax
  800d1a:	29 c2                	sub    %eax,%edx
  800d1c:	89 d0                	mov    %edx,%eax
}
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 04             	sub    $0x4,%esp
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2c:	eb 12                	jmp    800d40 <strchr+0x20>
		if (*s == c)
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d36:	75 05                	jne    800d3d <strchr+0x1d>
			return (char *) s;
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	eb 11                	jmp    800d4e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d3d:	ff 45 08             	incl   0x8(%ebp)
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	75 e5                	jne    800d2e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 04             	sub    $0x4,%esp
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5c:	eb 0d                	jmp    800d6b <strfind+0x1b>
		if (*s == c)
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d66:	74 0e                	je     800d76 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d68:	ff 45 08             	incl   0x8(%ebp)
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	84 c0                	test   %al,%al
  800d72:	75 ea                	jne    800d5e <strfind+0xe>
  800d74:	eb 01                	jmp    800d77 <strfind+0x27>
		if (*s == c)
			break;
  800d76:	90                   	nop
	return (char *) s;
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7a:	c9                   	leave  
  800d7b:	c3                   	ret    

00800d7c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d88:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d8e:	eb 0e                	jmp    800d9e <memset+0x22>
		*p++ = c;
  800d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d93:	8d 50 01             	lea    0x1(%eax),%edx
  800d96:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d9e:	ff 4d f8             	decl   -0x8(%ebp)
  800da1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da5:	79 e9                	jns    800d90 <memset+0x14>
		*p++ = c;

	return v;
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dbe:	eb 16                	jmp    800dd6 <memcpy+0x2a>
		*d++ = *s++;
  800dc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc3:	8d 50 01             	lea    0x1(%eax),%edx
  800dc6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dcf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd2:	8a 12                	mov    (%edx),%dl
  800dd4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddc:	89 55 10             	mov    %edx,0x10(%ebp)
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	75 dd                	jne    800dc0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e00:	73 50                	jae    800e52 <memmove+0x6a>
  800e02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e05:	8b 45 10             	mov    0x10(%ebp),%eax
  800e08:	01 d0                	add    %edx,%eax
  800e0a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e0d:	76 43                	jbe    800e52 <memmove+0x6a>
		s += n;
  800e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e12:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1b:	eb 10                	jmp    800e2d <memmove+0x45>
			*--d = *--s;
  800e1d:	ff 4d f8             	decl   -0x8(%ebp)
  800e20:	ff 4d fc             	decl   -0x4(%ebp)
  800e23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e26:	8a 10                	mov    (%eax),%dl
  800e28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e33:	89 55 10             	mov    %edx,0x10(%ebp)
  800e36:	85 c0                	test   %eax,%eax
  800e38:	75 e3                	jne    800e1d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e3a:	eb 23                	jmp    800e5f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3f:	8d 50 01             	lea    0x1(%eax),%edx
  800e42:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e48:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4e:	8a 12                	mov    (%edx),%dl
  800e50:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e52:	8b 45 10             	mov    0x10(%ebp),%eax
  800e55:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e58:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	75 dd                	jne    800e3c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    

00800e64 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e73:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e76:	eb 2a                	jmp    800ea2 <memcmp+0x3e>
		if (*s1 != *s2)
  800e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7b:	8a 10                	mov    (%eax),%dl
  800e7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	38 c2                	cmp    %al,%dl
  800e84:	74 16                	je     800e9c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	0f b6 d0             	movzbl %al,%edx
  800e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e91:	8a 00                	mov    (%eax),%al
  800e93:	0f b6 c0             	movzbl %al,%eax
  800e96:	29 c2                	sub    %eax,%edx
  800e98:	89 d0                	mov    %edx,%eax
  800e9a:	eb 18                	jmp    800eb4 <memcmp+0x50>
		s1++, s2++;
  800e9c:	ff 45 fc             	incl   -0x4(%ebp)
  800e9f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea8:	89 55 10             	mov    %edx,0x10(%ebp)
  800eab:	85 c0                	test   %eax,%eax
  800ead:	75 c9                	jne    800e78 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ec7:	eb 15                	jmp    800ede <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8a 00                	mov    (%eax),%al
  800ece:	0f b6 d0             	movzbl %al,%edx
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	0f b6 c0             	movzbl %al,%eax
  800ed7:	39 c2                	cmp    %eax,%edx
  800ed9:	74 0d                	je     800ee8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800edb:	ff 45 08             	incl   0x8(%ebp)
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee4:	72 e3                	jb     800ec9 <memfind+0x13>
  800ee6:	eb 01                	jmp    800ee9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ee8:	90                   	nop
	return (void *) s;
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800efb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f02:	eb 03                	jmp    800f07 <strtol+0x19>
		s++;
  800f04:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 20                	cmp    $0x20,%al
  800f0e:	74 f4                	je     800f04 <strtol+0x16>
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	3c 09                	cmp    $0x9,%al
  800f17:	74 eb                	je     800f04 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	3c 2b                	cmp    $0x2b,%al
  800f20:	75 05                	jne    800f27 <strtol+0x39>
		s++;
  800f22:	ff 45 08             	incl   0x8(%ebp)
  800f25:	eb 13                	jmp    800f3a <strtol+0x4c>
	else if (*s == '-')
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	3c 2d                	cmp    $0x2d,%al
  800f2e:	75 0a                	jne    800f3a <strtol+0x4c>
		s++, neg = 1;
  800f30:	ff 45 08             	incl   0x8(%ebp)
  800f33:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3e:	74 06                	je     800f46 <strtol+0x58>
  800f40:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f44:	75 20                	jne    800f66 <strtol+0x78>
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	3c 30                	cmp    $0x30,%al
  800f4d:	75 17                	jne    800f66 <strtol+0x78>
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	40                   	inc    %eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 78                	cmp    $0x78,%al
  800f57:	75 0d                	jne    800f66 <strtol+0x78>
		s += 2, base = 16;
  800f59:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f5d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f64:	eb 28                	jmp    800f8e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6a:	75 15                	jne    800f81 <strtol+0x93>
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 30                	cmp    $0x30,%al
  800f73:	75 0c                	jne    800f81 <strtol+0x93>
		s++, base = 8;
  800f75:	ff 45 08             	incl   0x8(%ebp)
  800f78:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f7f:	eb 0d                	jmp    800f8e <strtol+0xa0>
	else if (base == 0)
  800f81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f85:	75 07                	jne    800f8e <strtol+0xa0>
		base = 10;
  800f87:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	3c 2f                	cmp    $0x2f,%al
  800f95:	7e 19                	jle    800fb0 <strtol+0xc2>
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	3c 39                	cmp    $0x39,%al
  800f9e:	7f 10                	jg     800fb0 <strtol+0xc2>
			dig = *s - '0';
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	0f be c0             	movsbl %al,%eax
  800fa8:	83 e8 30             	sub    $0x30,%eax
  800fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fae:	eb 42                	jmp    800ff2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	3c 60                	cmp    $0x60,%al
  800fb7:	7e 19                	jle    800fd2 <strtol+0xe4>
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	3c 7a                	cmp    $0x7a,%al
  800fc0:	7f 10                	jg     800fd2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	0f be c0             	movsbl %al,%eax
  800fca:	83 e8 57             	sub    $0x57,%eax
  800fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd0:	eb 20                	jmp    800ff2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 40                	cmp    $0x40,%al
  800fd9:	7e 39                	jle    801014 <strtol+0x126>
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3c 5a                	cmp    $0x5a,%al
  800fe2:	7f 30                	jg     801014 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	0f be c0             	movsbl %al,%eax
  800fec:	83 e8 37             	sub    $0x37,%eax
  800fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ff8:	7d 19                	jge    801013 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ffa:	ff 45 08             	incl   0x8(%ebp)
  800ffd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801000:	0f af 45 10          	imul   0x10(%ebp),%eax
  801004:	89 c2                	mov    %eax,%edx
  801006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801009:	01 d0                	add    %edx,%eax
  80100b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80100e:	e9 7b ff ff ff       	jmp    800f8e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801013:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801014:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801018:	74 08                	je     801022 <strtol+0x134>
		*endptr = (char *) s;
  80101a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101d:	8b 55 08             	mov    0x8(%ebp),%edx
  801020:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801022:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801026:	74 07                	je     80102f <strtol+0x141>
  801028:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102b:	f7 d8                	neg    %eax
  80102d:	eb 03                	jmp    801032 <strtol+0x144>
  80102f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801032:	c9                   	leave  
  801033:	c3                   	ret    

00801034 <ltostr>:

void
ltostr(long value, char *str)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80103a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801041:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801048:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104c:	79 13                	jns    801061 <ltostr+0x2d>
	{
		neg = 1;
  80104e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80105b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80105e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801069:	99                   	cltd   
  80106a:	f7 f9                	idiv   %ecx
  80106c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80106f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801072:	8d 50 01             	lea    0x1(%eax),%edx
  801075:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801078:	89 c2                	mov    %eax,%edx
  80107a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107d:	01 d0                	add    %edx,%eax
  80107f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801082:	83 c2 30             	add    $0x30,%edx
  801085:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801087:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80108f:	f7 e9                	imul   %ecx
  801091:	c1 fa 02             	sar    $0x2,%edx
  801094:	89 c8                	mov    %ecx,%eax
  801096:	c1 f8 1f             	sar    $0x1f,%eax
  801099:	29 c2                	sub    %eax,%edx
  80109b:	89 d0                	mov    %edx,%eax
  80109d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a4:	75 bb                	jne    801061 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b0:	48                   	dec    %eax
  8010b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b8:	74 3d                	je     8010f7 <ltostr+0xc3>
		start = 1 ;
  8010ba:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010c1:	eb 34                	jmp    8010f7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	01 d0                	add    %edx,%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	01 c2                	add    %eax,%edx
  8010d8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	01 c8                	add    %ecx,%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ea:	01 c2                	add    %eax,%edx
  8010ec:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010ef:	88 02                	mov    %al,(%edx)
		start++ ;
  8010f1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010f4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010fd:	7c c4                	jl     8010c3 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010ff:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	01 d0                	add    %edx,%eax
  801107:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80110a:	90                   	nop
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    

0080110d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801113:	ff 75 08             	pushl  0x8(%ebp)
  801116:	e8 73 fa ff ff       	call   800b8e <strlen>
  80111b:	83 c4 04             	add    $0x4,%esp
  80111e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	e8 65 fa ff ff       	call   800b8e <strlen>
  801129:	83 c4 04             	add    $0x4,%esp
  80112c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80112f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801136:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80113d:	eb 17                	jmp    801156 <strcconcat+0x49>
		final[s] = str1[s] ;
  80113f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801142:	8b 45 10             	mov    0x10(%ebp),%eax
  801145:	01 c2                	add    %eax,%edx
  801147:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	01 c8                	add    %ecx,%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801153:	ff 45 fc             	incl   -0x4(%ebp)
  801156:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801159:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80115c:	7c e1                	jl     80113f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801165:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80116c:	eb 1f                	jmp    80118d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80116e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801171:	8d 50 01             	lea    0x1(%eax),%edx
  801174:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801177:	89 c2                	mov    %eax,%edx
  801179:	8b 45 10             	mov    0x10(%ebp),%eax
  80117c:	01 c2                	add    %eax,%edx
  80117e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	01 c8                	add    %ecx,%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80118a:	ff 45 f8             	incl   -0x8(%ebp)
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801193:	7c d9                	jl     80116e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801195:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801198:	8b 45 10             	mov    0x10(%ebp),%eax
  80119b:	01 d0                	add    %edx,%eax
  80119d:	c6 00 00             	movb   $0x0,(%eax)
}
  8011a0:	90                   	nop
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    

008011a3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011af:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b2:	8b 00                	mov    (%eax),%eax
  8011b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011be:	01 d0                	add    %edx,%eax
  8011c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011c6:	eb 0c                	jmp    8011d4 <strsplit+0x31>
			*string++ = 0;
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8d 50 01             	lea    0x1(%eax),%edx
  8011ce:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	84 c0                	test   %al,%al
  8011db:	74 18                	je     8011f5 <strsplit+0x52>
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f be c0             	movsbl %al,%eax
  8011e5:	50                   	push   %eax
  8011e6:	ff 75 0c             	pushl  0xc(%ebp)
  8011e9:	e8 32 fb ff ff       	call   800d20 <strchr>
  8011ee:	83 c4 08             	add    $0x8,%esp
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	75 d3                	jne    8011c8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	84 c0                	test   %al,%al
  8011fc:	74 5a                	je     801258 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801201:	8b 00                	mov    (%eax),%eax
  801203:	83 f8 0f             	cmp    $0xf,%eax
  801206:	75 07                	jne    80120f <strsplit+0x6c>
		{
			return 0;
  801208:	b8 00 00 00 00       	mov    $0x0,%eax
  80120d:	eb 66                	jmp    801275 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80120f:	8b 45 14             	mov    0x14(%ebp),%eax
  801212:	8b 00                	mov    (%eax),%eax
  801214:	8d 48 01             	lea    0x1(%eax),%ecx
  801217:	8b 55 14             	mov    0x14(%ebp),%edx
  80121a:	89 0a                	mov    %ecx,(%edx)
  80121c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801223:	8b 45 10             	mov    0x10(%ebp),%eax
  801226:	01 c2                	add    %eax,%edx
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80122d:	eb 03                	jmp    801232 <strsplit+0x8f>
			string++;
  80122f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	84 c0                	test   %al,%al
  801239:	74 8b                	je     8011c6 <strsplit+0x23>
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	0f be c0             	movsbl %al,%eax
  801243:	50                   	push   %eax
  801244:	ff 75 0c             	pushl  0xc(%ebp)
  801247:	e8 d4 fa ff ff       	call   800d20 <strchr>
  80124c:	83 c4 08             	add    $0x8,%esp
  80124f:	85 c0                	test   %eax,%eax
  801251:	74 dc                	je     80122f <strsplit+0x8c>
			string++;
	}
  801253:	e9 6e ff ff ff       	jmp    8011c6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801258:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801259:	8b 45 14             	mov    0x14(%ebp),%eax
  80125c:	8b 00                	mov    (%eax),%eax
  80125e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801265:	8b 45 10             	mov    0x10(%ebp),%eax
  801268:	01 d0                	add    %edx,%eax
  80126a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801270:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80127d:	83 ec 04             	sub    $0x4,%esp
  801280:	68 48 41 80 00       	push   $0x804148
  801285:	68 3f 01 00 00       	push   $0x13f
  80128a:	68 6a 41 80 00       	push   $0x80416a
  80128f:	e8 a9 ef ff ff       	call   80023d <_panic>

00801294 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80129a:	83 ec 0c             	sub    $0xc,%esp
  80129d:	ff 75 08             	pushl  0x8(%ebp)
  8012a0:	e8 9d 0a 00 00       	call   801d42 <sys_sbrk>
  8012a5:	83 c4 10             	add    $0x10,%esp
}
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8012b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b4:	75 0a                	jne    8012c0 <malloc+0x16>
  8012b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bb:	e9 07 02 00 00       	jmp    8014c7 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8012c0:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8012c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012cd:	01 d0                	add    %edx,%eax
  8012cf:	48                   	dec    %eax
  8012d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8012d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012db:	f7 75 dc             	divl   -0x24(%ebp)
  8012de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012e1:	29 d0                	sub    %edx,%eax
  8012e3:	c1 e8 0c             	shr    $0xc,%eax
  8012e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8012e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8012ee:	8b 40 78             	mov    0x78(%eax),%eax
  8012f1:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8012f6:	29 c2                	sub    %eax,%edx
  8012f8:	89 d0                	mov    %edx,%eax
  8012fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8012fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801300:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801305:	c1 e8 0c             	shr    $0xc,%eax
  801308:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  80130b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801312:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801319:	77 42                	ja     80135d <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80131b:	e8 a6 08 00 00       	call   801bc6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801320:	85 c0                	test   %eax,%eax
  801322:	74 16                	je     80133a <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801324:	83 ec 0c             	sub    $0xc,%esp
  801327:	ff 75 08             	pushl  0x8(%ebp)
  80132a:	e8 e6 0d 00 00       	call   802115 <alloc_block_FF>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801335:	e9 8a 01 00 00       	jmp    8014c4 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80133a:	e8 b8 08 00 00       	call   801bf7 <sys_isUHeapPlacementStrategyBESTFIT>
  80133f:	85 c0                	test   %eax,%eax
  801341:	0f 84 7d 01 00 00    	je     8014c4 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801347:	83 ec 0c             	sub    $0xc,%esp
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	e8 7f 12 00 00       	call   8025d1 <alloc_block_BF>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801358:	e9 67 01 00 00       	jmp    8014c4 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  80135d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801360:	48                   	dec    %eax
  801361:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801364:	0f 86 53 01 00 00    	jbe    8014bd <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  80136a:	a1 20 50 80 00       	mov    0x805020,%eax
  80136f:	8b 40 78             	mov    0x78(%eax),%eax
  801372:	05 00 10 00 00       	add    $0x1000,%eax
  801377:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  80137a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801381:	e9 de 00 00 00       	jmp    801464 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801386:	a1 20 50 80 00       	mov    0x805020,%eax
  80138b:	8b 40 78             	mov    0x78(%eax),%eax
  80138e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801391:	29 c2                	sub    %eax,%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139a:	c1 e8 0c             	shr    $0xc,%eax
  80139d:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	0f 85 ab 00 00 00    	jne    801457 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8013ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013af:	05 00 10 00 00       	add    $0x1000,%eax
  8013b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8013b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8013be:	eb 47                	jmp    801407 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8013c0:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8013c7:	76 0a                	jbe    8013d3 <malloc+0x129>
  8013c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ce:	e9 f4 00 00 00       	jmp    8014c7 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8013d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8013d8:	8b 40 78             	mov    0x78(%eax),%eax
  8013db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013de:	29 c2                	sub    %eax,%edx
  8013e0:	89 d0                	mov    %edx,%eax
  8013e2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e7:	c1 e8 0c             	shr    $0xc,%eax
  8013ea:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	74 08                	je     8013fd <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  8013f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  8013fb:	eb 5a                	jmp    801457 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  8013fd:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801404:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801407:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80140a:	48                   	dec    %eax
  80140b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80140e:	77 b0                	ja     8013c0 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801410:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801417:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80141e:	eb 2f                	jmp    80144f <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801423:	c1 e0 0c             	shl    $0xc,%eax
  801426:	89 c2                	mov    %eax,%edx
  801428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142b:	01 c2                	add    %eax,%edx
  80142d:	a1 20 50 80 00       	mov    0x805020,%eax
  801432:	8b 40 78             	mov    0x78(%eax),%eax
  801435:	29 c2                	sub    %eax,%edx
  801437:	89 d0                	mov    %edx,%eax
  801439:	2d 00 10 00 00       	sub    $0x1000,%eax
  80143e:	c1 e8 0c             	shr    $0xc,%eax
  801441:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  801448:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  80144c:	ff 45 e0             	incl   -0x20(%ebp)
  80144f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801452:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801455:	72 c9                	jb     801420 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801457:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80145b:	75 16                	jne    801473 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  80145d:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801464:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80146b:	0f 86 15 ff ff ff    	jbe    801386 <malloc+0xdc>
  801471:	eb 01                	jmp    801474 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801473:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801474:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801478:	75 07                	jne    801481 <malloc+0x1d7>
  80147a:	b8 00 00 00 00       	mov    $0x0,%eax
  80147f:	eb 46                	jmp    8014c7 <malloc+0x21d>
		ptr = (void*)i;
  801481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801484:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801487:	a1 20 50 80 00       	mov    0x805020,%eax
  80148c:	8b 40 78             	mov    0x78(%eax),%eax
  80148f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801492:	29 c2                	sub    %eax,%edx
  801494:	89 d0                	mov    %edx,%eax
  801496:	2d 00 10 00 00       	sub    $0x1000,%eax
  80149b:	c1 e8 0c             	shr    $0xc,%eax
  80149e:	89 c2                	mov    %eax,%edx
  8014a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014a3:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	ff 75 08             	pushl  0x8(%ebp)
  8014b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b3:	e8 c1 08 00 00       	call   801d79 <sys_allocate_user_mem>
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	eb 07                	jmp    8014c4 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c2:	eb 03                	jmp    8014c7 <malloc+0x21d>
	}
	return ptr;
  8014c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  8014cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8014d4:	8b 40 78             	mov    0x78(%eax),%eax
  8014d7:	05 00 10 00 00       	add    $0x1000,%eax
  8014dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  8014df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  8014e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8014eb:	8b 50 78             	mov    0x78(%eax),%edx
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	39 c2                	cmp    %eax,%edx
  8014f3:	76 24                	jbe    801519 <free+0x50>
		size = get_block_size(va);
  8014f5:	83 ec 0c             	sub    $0xc,%esp
  8014f8:	ff 75 08             	pushl  0x8(%ebp)
  8014fb:	e8 95 08 00 00       	call   801d95 <get_block_size>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801506:	83 ec 0c             	sub    $0xc,%esp
  801509:	ff 75 08             	pushl  0x8(%ebp)
  80150c:	e8 c8 1a 00 00       	call   802fd9 <free_block>
  801511:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801514:	e9 ac 00 00 00       	jmp    8015c5 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80151f:	0f 82 89 00 00 00    	jb     8015ae <free+0xe5>
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  80152d:	77 7f                	ja     8015ae <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  80152f:	8b 55 08             	mov    0x8(%ebp),%edx
  801532:	a1 20 50 80 00       	mov    0x805020,%eax
  801537:	8b 40 78             	mov    0x78(%eax),%eax
  80153a:	29 c2                	sub    %eax,%edx
  80153c:	89 d0                	mov    %edx,%eax
  80153e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801543:	c1 e8 0c             	shr    $0xc,%eax
  801546:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  80154d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801550:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801553:	c1 e0 0c             	shl    $0xc,%eax
  801556:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801560:	eb 2f                	jmp    801591 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801565:	c1 e0 0c             	shl    $0xc,%eax
  801568:	89 c2                	mov    %eax,%edx
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	01 c2                	add    %eax,%edx
  80156f:	a1 20 50 80 00       	mov    0x805020,%eax
  801574:	8b 40 78             	mov    0x78(%eax),%eax
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 d0                	mov    %edx,%eax
  80157b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801580:	c1 e8 0c             	shr    $0xc,%eax
  801583:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  80158a:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  80158e:	ff 45 f4             	incl   -0xc(%ebp)
  801591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801594:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801597:	72 c9                	jb     801562 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	83 ec 08             	sub    $0x8,%esp
  80159f:	ff 75 ec             	pushl  -0x14(%ebp)
  8015a2:	50                   	push   %eax
  8015a3:	e8 b5 07 00 00       	call   801d5d <sys_free_user_mem>
  8015a8:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8015ab:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8015ac:	eb 17                	jmp    8015c5 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	68 78 41 80 00       	push   $0x804178
  8015b6:	68 84 00 00 00       	push   $0x84
  8015bb:	68 a2 41 80 00       	push   $0x8041a2
  8015c0:	e8 78 ec ff ff       	call   80023d <_panic>
	}
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 28             	sub    $0x28,%esp
  8015cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d0:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8015d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d7:	75 07                	jne    8015e0 <smalloc+0x19>
  8015d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015de:	eb 74                	jmp    801654 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8015e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015e6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f3:	39 d0                	cmp    %edx,%eax
  8015f5:	73 02                	jae    8015f9 <smalloc+0x32>
  8015f7:	89 d0                	mov    %edx,%eax
  8015f9:	83 ec 0c             	sub    $0xc,%esp
  8015fc:	50                   	push   %eax
  8015fd:	e8 a8 fc ff ff       	call   8012aa <malloc>
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801608:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80160c:	75 07                	jne    801615 <smalloc+0x4e>
  80160e:	b8 00 00 00 00       	mov    $0x0,%eax
  801613:	eb 3f                	jmp    801654 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801615:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801619:	ff 75 ec             	pushl  -0x14(%ebp)
  80161c:	50                   	push   %eax
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	ff 75 08             	pushl  0x8(%ebp)
  801623:	e8 3c 03 00 00       	call   801964 <sys_createSharedObject>
  801628:	83 c4 10             	add    $0x10,%esp
  80162b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80162e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801632:	74 06                	je     80163a <smalloc+0x73>
  801634:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801638:	75 07                	jne    801641 <smalloc+0x7a>
  80163a:	b8 00 00 00 00       	mov    $0x0,%eax
  80163f:	eb 13                	jmp    801654 <smalloc+0x8d>
	 cprintf("153\n");
  801641:	83 ec 0c             	sub    $0xc,%esp
  801644:	68 ae 41 80 00       	push   $0x8041ae
  801649:	e8 ac ee ff ff       	call   8004fa <cprintf>
  80164e:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801651:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80165c:	83 ec 08             	sub    $0x8,%esp
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	ff 75 08             	pushl  0x8(%ebp)
  801665:	e8 24 03 00 00       	call   80198e <sys_getSizeOfSharedObject>
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801670:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801674:	75 07                	jne    80167d <sget+0x27>
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
  80167b:	eb 5c                	jmp    8016d9 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80167d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801680:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801683:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80168a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80168d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801690:	39 d0                	cmp    %edx,%eax
  801692:	7d 02                	jge    801696 <sget+0x40>
  801694:	89 d0                	mov    %edx,%eax
  801696:	83 ec 0c             	sub    $0xc,%esp
  801699:	50                   	push   %eax
  80169a:	e8 0b fc ff ff       	call   8012aa <malloc>
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8016a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016a9:	75 07                	jne    8016b2 <sget+0x5c>
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b0:	eb 27                	jmp    8016d9 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8016b2:	83 ec 04             	sub    $0x4,%esp
  8016b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	e8 e8 02 00 00       	call   8019ab <sys_getSharedObject>
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8016c9:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8016cd:	75 07                	jne    8016d6 <sget+0x80>
  8016cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d4:	eb 03                	jmp    8016d9 <sget+0x83>
	return ptr;
  8016d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016e1:	83 ec 04             	sub    $0x4,%esp
  8016e4:	68 b4 41 80 00       	push   $0x8041b4
  8016e9:	68 c2 00 00 00       	push   $0xc2
  8016ee:	68 a2 41 80 00       	push   $0x8041a2
  8016f3:	e8 45 eb ff ff       	call   80023d <_panic>

008016f8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016fe:	83 ec 04             	sub    $0x4,%esp
  801701:	68 d8 41 80 00       	push   $0x8041d8
  801706:	68 d9 00 00 00       	push   $0xd9
  80170b:	68 a2 41 80 00       	push   $0x8041a2
  801710:	e8 28 eb ff ff       	call   80023d <_panic>

00801715 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	68 fe 41 80 00       	push   $0x8041fe
  801723:	68 e5 00 00 00       	push   $0xe5
  801728:	68 a2 41 80 00       	push   $0x8041a2
  80172d:	e8 0b eb ff ff       	call   80023d <_panic>

00801732 <shrink>:

}
void shrink(uint32 newSize)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801738:	83 ec 04             	sub    $0x4,%esp
  80173b:	68 fe 41 80 00       	push   $0x8041fe
  801740:	68 ea 00 00 00       	push   $0xea
  801745:	68 a2 41 80 00       	push   $0x8041a2
  80174a:	e8 ee ea ff ff       	call   80023d <_panic>

0080174f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	68 fe 41 80 00       	push   $0x8041fe
  80175d:	68 ef 00 00 00       	push   $0xef
  801762:	68 a2 41 80 00       	push   $0x8041a2
  801767:	e8 d1 ea ff ff       	call   80023d <_panic>

0080176c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	57                   	push   %edi
  801770:	56                   	push   %esi
  801771:	53                   	push   %ebx
  801772:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801781:	8b 7d 18             	mov    0x18(%ebp),%edi
  801784:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801787:	cd 30                	int    $0x30
  801789:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80178c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	5b                   	pop    %ebx
  801793:	5e                   	pop    %esi
  801794:	5f                   	pop    %edi
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    

00801797 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017a3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	52                   	push   %edx
  8017af:	ff 75 0c             	pushl  0xc(%ebp)
  8017b2:	50                   	push   %eax
  8017b3:	6a 00                	push   $0x0
  8017b5:	e8 b2 ff ff ff       	call   80176c <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
}
  8017bd:	90                   	nop
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 02                	push   $0x2
  8017cf:	e8 98 ff ff ff       	call   80176c <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 03                	push   $0x3
  8017e8:	e8 7f ff ff ff       	call   80176c <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	90                   	nop
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 04                	push   $0x4
  801802:	e8 65 ff ff ff       	call   80176c <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	90                   	nop
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801810:	8b 55 0c             	mov    0xc(%ebp),%edx
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	52                   	push   %edx
  80181d:	50                   	push   %eax
  80181e:	6a 08                	push   $0x8
  801820:	e8 47 ff ff ff       	call   80176c <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	56                   	push   %esi
  80182e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80182f:	8b 75 18             	mov    0x18(%ebp),%esi
  801832:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801835:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	56                   	push   %esi
  80183f:	53                   	push   %ebx
  801840:	51                   	push   %ecx
  801841:	52                   	push   %edx
  801842:	50                   	push   %eax
  801843:	6a 09                	push   $0x9
  801845:	e8 22 ff ff ff       	call   80176c <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801850:	5b                   	pop    %ebx
  801851:	5e                   	pop    %esi
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    

00801854 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	52                   	push   %edx
  801864:	50                   	push   %eax
  801865:	6a 0a                	push   $0xa
  801867:	e8 00 ff ff ff       	call   80176c <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	ff 75 08             	pushl  0x8(%ebp)
  801880:	6a 0b                	push   $0xb
  801882:	e8 e5 fe ff ff       	call   80176c <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 0c                	push   $0xc
  80189b:	e8 cc fe ff ff       	call   80176c <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 0d                	push   $0xd
  8018b4:	e8 b3 fe ff ff       	call   80176c <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 0e                	push   $0xe
  8018cd:	e8 9a fe ff ff       	call   80176c <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 0f                	push   $0xf
  8018e6:	e8 81 fe ff ff       	call   80176c <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	ff 75 08             	pushl  0x8(%ebp)
  8018fe:	6a 10                	push   $0x10
  801900:	e8 67 fe ff ff       	call   80176c <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 11                	push   $0x11
  801919:	e8 4e fe ff ff       	call   80176c <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_cputc>:

void
sys_cputc(const char c)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801930:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	50                   	push   %eax
  80193d:	6a 01                	push   $0x1
  80193f:	e8 28 fe ff ff       	call   80176c <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	90                   	nop
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 14                	push   $0x14
  801959:	e8 0e fe ff ff       	call   80176c <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	90                   	nop
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	8b 45 10             	mov    0x10(%ebp),%eax
  80196d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801970:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801973:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	6a 00                	push   $0x0
  80197c:	51                   	push   %ecx
  80197d:	52                   	push   %edx
  80197e:	ff 75 0c             	pushl  0xc(%ebp)
  801981:	50                   	push   %eax
  801982:	6a 15                	push   $0x15
  801984:	e8 e3 fd ff ff       	call   80176c <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801991:	8b 55 0c             	mov    0xc(%ebp),%edx
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	52                   	push   %edx
  80199e:	50                   	push   %eax
  80199f:	6a 16                	push   $0x16
  8019a1:	e8 c6 fd ff ff       	call   80176c <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	51                   	push   %ecx
  8019bc:	52                   	push   %edx
  8019bd:	50                   	push   %eax
  8019be:	6a 17                	push   $0x17
  8019c0:	e8 a7 fd ff ff       	call   80176c <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	52                   	push   %edx
  8019da:	50                   	push   %eax
  8019db:	6a 18                	push   $0x18
  8019dd:	e8 8a fd ff ff       	call   80176c <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	6a 00                	push   $0x0
  8019ef:	ff 75 14             	pushl  0x14(%ebp)
  8019f2:	ff 75 10             	pushl  0x10(%ebp)
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	50                   	push   %eax
  8019f9:	6a 19                	push   $0x19
  8019fb:	e8 6c fd ff ff       	call   80176c <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	50                   	push   %eax
  801a14:	6a 1a                	push   $0x1a
  801a16:	e8 51 fd ff ff       	call   80176c <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	90                   	nop
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	50                   	push   %eax
  801a30:	6a 1b                	push   $0x1b
  801a32:	e8 35 fd ff ff       	call   80176c <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 05                	push   $0x5
  801a4b:	e8 1c fd ff ff       	call   80176c <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 06                	push   $0x6
  801a64:	e8 03 fd ff ff       	call   80176c <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 07                	push   $0x7
  801a7d:	e8 ea fc ff ff       	call   80176c <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_exit_env>:


void sys_exit_env(void)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 1c                	push   $0x1c
  801a96:	e8 d1 fc ff ff       	call   80176c <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	90                   	nop
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aa7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aaa:	8d 50 04             	lea    0x4(%eax),%edx
  801aad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	52                   	push   %edx
  801ab7:	50                   	push   %eax
  801ab8:	6a 1d                	push   $0x1d
  801aba:	e8 ad fc ff ff       	call   80176c <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
	return result;
  801ac2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ac5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801acb:	89 01                	mov    %eax,(%ecx)
  801acd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	c9                   	leave  
  801ad4:	c2 04 00             	ret    $0x4

00801ad7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	ff 75 10             	pushl  0x10(%ebp)
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	ff 75 08             	pushl  0x8(%ebp)
  801ae7:	6a 13                	push   $0x13
  801ae9:	e8 7e fc ff ff       	call   80176c <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
	return ;
  801af1:	90                   	nop
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 1e                	push   $0x1e
  801b03:	e8 64 fc ff ff       	call   80176c <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b19:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	50                   	push   %eax
  801b26:	6a 1f                	push   $0x1f
  801b28:	e8 3f fc ff ff       	call   80176c <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b30:	90                   	nop
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <rsttst>:
void rsttst()
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 21                	push   $0x21
  801b42:	e8 25 fc ff ff       	call   80176c <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4a:	90                   	nop
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 04             	sub    $0x4,%esp
  801b53:	8b 45 14             	mov    0x14(%ebp),%eax
  801b56:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b59:	8b 55 18             	mov    0x18(%ebp),%edx
  801b5c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b60:	52                   	push   %edx
  801b61:	50                   	push   %eax
  801b62:	ff 75 10             	pushl  0x10(%ebp)
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	6a 20                	push   $0x20
  801b6d:	e8 fa fb ff ff       	call   80176c <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
	return ;
  801b75:	90                   	nop
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <chktst>:
void chktst(uint32 n)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	ff 75 08             	pushl  0x8(%ebp)
  801b86:	6a 22                	push   $0x22
  801b88:	e8 df fb ff ff       	call   80176c <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b90:	90                   	nop
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <inctst>:

void inctst()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 23                	push   $0x23
  801ba2:	e8 c5 fb ff ff       	call   80176c <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
	return ;
  801baa:	90                   	nop
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <gettst>:
uint32 gettst()
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 24                	push   $0x24
  801bbc:	e8 ab fb ff ff       	call   80176c <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 25                	push   $0x25
  801bd8:	e8 8f fb ff ff       	call   80176c <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
  801be0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801be3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801be7:	75 07                	jne    801bf0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801be9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bee:	eb 05                	jmp    801bf5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 25                	push   $0x25
  801c09:	e8 5e fb ff ff       	call   80176c <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
  801c11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c14:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c18:	75 07                	jne    801c21 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1f:	eb 05                	jmp    801c26 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 25                	push   $0x25
  801c3a:	e8 2d fb ff ff       	call   80176c <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
  801c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c45:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c49:	75 07                	jne    801c52 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c50:	eb 05                	jmp    801c57 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 25                	push   $0x25
  801c6b:	e8 fc fa ff ff       	call   80176c <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
  801c73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c76:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c7a:	75 07                	jne    801c83 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c7c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c81:	eb 05                	jmp    801c88 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	ff 75 08             	pushl  0x8(%ebp)
  801c98:	6a 26                	push   $0x26
  801c9a:	e8 cd fa ff ff       	call   80176c <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca2:	90                   	nop
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ca9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801caf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	53                   	push   %ebx
  801cb8:	51                   	push   %ecx
  801cb9:	52                   	push   %edx
  801cba:	50                   	push   %eax
  801cbb:	6a 27                	push   $0x27
  801cbd:	e8 aa fa ff ff       	call   80176c <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	52                   	push   %edx
  801cda:	50                   	push   %eax
  801cdb:	6a 28                	push   $0x28
  801cdd:	e8 8a fa ff ff       	call   80176c <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	6a 00                	push   $0x0
  801cf5:	51                   	push   %ecx
  801cf6:	ff 75 10             	pushl  0x10(%ebp)
  801cf9:	52                   	push   %edx
  801cfa:	50                   	push   %eax
  801cfb:	6a 29                	push   $0x29
  801cfd:	e8 6a fa ff ff       	call   80176c <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	ff 75 10             	pushl  0x10(%ebp)
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	ff 75 08             	pushl  0x8(%ebp)
  801d17:	6a 12                	push   $0x12
  801d19:	e8 4e fa ff ff       	call   80176c <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d21:	90                   	nop
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	52                   	push   %edx
  801d34:	50                   	push   %eax
  801d35:	6a 2a                	push   $0x2a
  801d37:	e8 30 fa ff ff       	call   80176c <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
	return;
  801d3f:	90                   	nop
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	50                   	push   %eax
  801d51:	6a 2b                	push   $0x2b
  801d53:	e8 14 fa ff ff       	call   80176c <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	ff 75 08             	pushl  0x8(%ebp)
  801d6c:	6a 2c                	push   $0x2c
  801d6e:	e8 f9 f9 ff ff       	call   80176c <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
	return;
  801d76:	90                   	nop
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	ff 75 0c             	pushl  0xc(%ebp)
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	6a 2d                	push   $0x2d
  801d8a:	e8 dd f9 ff ff       	call   80176c <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
	return;
  801d92:	90                   	nop
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	83 e8 04             	sub    $0x4,%eax
  801da1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801da4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801da7:	8b 00                	mov    (%eax),%eax
  801da9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	83 e8 04             	sub    $0x4,%eax
  801dba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dc0:	8b 00                	mov    (%eax),%eax
  801dc2:	83 e0 01             	and    $0x1,%eax
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	0f 94 c0             	sete   %al
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801dd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddc:	83 f8 02             	cmp    $0x2,%eax
  801ddf:	74 2b                	je     801e0c <alloc_block+0x40>
  801de1:	83 f8 02             	cmp    $0x2,%eax
  801de4:	7f 07                	jg     801ded <alloc_block+0x21>
  801de6:	83 f8 01             	cmp    $0x1,%eax
  801de9:	74 0e                	je     801df9 <alloc_block+0x2d>
  801deb:	eb 58                	jmp    801e45 <alloc_block+0x79>
  801ded:	83 f8 03             	cmp    $0x3,%eax
  801df0:	74 2d                	je     801e1f <alloc_block+0x53>
  801df2:	83 f8 04             	cmp    $0x4,%eax
  801df5:	74 3b                	je     801e32 <alloc_block+0x66>
  801df7:	eb 4c                	jmp    801e45 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801df9:	83 ec 0c             	sub    $0xc,%esp
  801dfc:	ff 75 08             	pushl  0x8(%ebp)
  801dff:	e8 11 03 00 00       	call   802115 <alloc_block_FF>
  801e04:	83 c4 10             	add    $0x10,%esp
  801e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e0a:	eb 4a                	jmp    801e56 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	ff 75 08             	pushl  0x8(%ebp)
  801e12:	e8 fa 19 00 00       	call   803811 <alloc_block_NF>
  801e17:	83 c4 10             	add    $0x10,%esp
  801e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e1d:	eb 37                	jmp    801e56 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e1f:	83 ec 0c             	sub    $0xc,%esp
  801e22:	ff 75 08             	pushl  0x8(%ebp)
  801e25:	e8 a7 07 00 00       	call   8025d1 <alloc_block_BF>
  801e2a:	83 c4 10             	add    $0x10,%esp
  801e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e30:	eb 24                	jmp    801e56 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e32:	83 ec 0c             	sub    $0xc,%esp
  801e35:	ff 75 08             	pushl  0x8(%ebp)
  801e38:	e8 b7 19 00 00       	call   8037f4 <alloc_block_WF>
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e43:	eb 11                	jmp    801e56 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	68 10 42 80 00       	push   $0x804210
  801e4d:	e8 a8 e6 ff ff       	call   8004fa <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
		break;
  801e55:	90                   	nop
	}
	return va;
  801e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	53                   	push   %ebx
  801e5f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	68 30 42 80 00       	push   $0x804230
  801e6a:	e8 8b e6 ff ff       	call   8004fa <cprintf>
  801e6f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	68 5b 42 80 00       	push   $0x80425b
  801e7a:	e8 7b e6 ff ff       	call   8004fa <cprintf>
  801e7f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e88:	eb 37                	jmp    801ec1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e8a:	83 ec 0c             	sub    $0xc,%esp
  801e8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e90:	e8 19 ff ff ff       	call   801dae <is_free_block>
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	0f be d8             	movsbl %al,%ebx
  801e9b:	83 ec 0c             	sub    $0xc,%esp
  801e9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea1:	e8 ef fe ff ff       	call   801d95 <get_block_size>
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	53                   	push   %ebx
  801ead:	50                   	push   %eax
  801eae:	68 73 42 80 00       	push   $0x804273
  801eb3:	e8 42 e6 ff ff       	call   8004fa <cprintf>
  801eb8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec5:	74 07                	je     801ece <print_blocks_list+0x73>
  801ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eca:	8b 00                	mov    (%eax),%eax
  801ecc:	eb 05                	jmp    801ed3 <print_blocks_list+0x78>
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	89 45 10             	mov    %eax,0x10(%ebp)
  801ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	75 ad                	jne    801e8a <print_blocks_list+0x2f>
  801edd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee1:	75 a7                	jne    801e8a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	68 30 42 80 00       	push   $0x804230
  801eeb:	e8 0a e6 ff ff       	call   8004fa <cprintf>
  801ef0:	83 c4 10             	add    $0x10,%esp

}
  801ef3:	90                   	nop
  801ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f02:	83 e0 01             	and    $0x1,%eax
  801f05:	85 c0                	test   %eax,%eax
  801f07:	74 03                	je     801f0c <initialize_dynamic_allocator+0x13>
  801f09:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f10:	0f 84 c7 01 00 00    	je     8020dd <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f16:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f1d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f20:	8b 55 08             	mov    0x8(%ebp),%edx
  801f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f26:	01 d0                	add    %edx,%eax
  801f28:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f2d:	0f 87 ad 01 00 00    	ja     8020e0 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	85 c0                	test   %eax,%eax
  801f38:	0f 89 a5 01 00 00    	jns    8020e3 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f44:	01 d0                	add    %edx,%eax
  801f46:	83 e8 04             	sub    $0x4,%eax
  801f49:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f55:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f5d:	e9 87 00 00 00       	jmp    801fe9 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f66:	75 14                	jne    801f7c <initialize_dynamic_allocator+0x83>
  801f68:	83 ec 04             	sub    $0x4,%esp
  801f6b:	68 8b 42 80 00       	push   $0x80428b
  801f70:	6a 79                	push   $0x79
  801f72:	68 a9 42 80 00       	push   $0x8042a9
  801f77:	e8 c1 e2 ff ff       	call   80023d <_panic>
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	8b 00                	mov    (%eax),%eax
  801f81:	85 c0                	test   %eax,%eax
  801f83:	74 10                	je     801f95 <initialize_dynamic_allocator+0x9c>
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	8b 00                	mov    (%eax),%eax
  801f8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8d:	8b 52 04             	mov    0x4(%edx),%edx
  801f90:	89 50 04             	mov    %edx,0x4(%eax)
  801f93:	eb 0b                	jmp    801fa0 <initialize_dynamic_allocator+0xa7>
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	8b 40 04             	mov    0x4(%eax),%eax
  801f9b:	a3 30 50 80 00       	mov    %eax,0x805030
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	8b 40 04             	mov    0x4(%eax),%eax
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	74 0f                	je     801fb9 <initialize_dynamic_allocator+0xc0>
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 40 04             	mov    0x4(%eax),%eax
  801fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb3:	8b 12                	mov    (%edx),%edx
  801fb5:	89 10                	mov    %edx,(%eax)
  801fb7:	eb 0a                	jmp    801fc3 <initialize_dynamic_allocator+0xca>
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	8b 00                	mov    (%eax),%eax
  801fbe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fd6:	a1 38 50 80 00       	mov    0x805038,%eax
  801fdb:	48                   	dec    %eax
  801fdc:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801fe1:	a1 34 50 80 00       	mov    0x805034,%eax
  801fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fed:	74 07                	je     801ff6 <initialize_dynamic_allocator+0xfd>
  801fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff2:	8b 00                	mov    (%eax),%eax
  801ff4:	eb 05                	jmp    801ffb <initialize_dynamic_allocator+0x102>
  801ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffb:	a3 34 50 80 00       	mov    %eax,0x805034
  802000:	a1 34 50 80 00       	mov    0x805034,%eax
  802005:	85 c0                	test   %eax,%eax
  802007:	0f 85 55 ff ff ff    	jne    801f62 <initialize_dynamic_allocator+0x69>
  80200d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802011:	0f 85 4b ff ff ff    	jne    801f62 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80201d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802020:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802026:	a1 44 50 80 00       	mov    0x805044,%eax
  80202b:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802030:	a1 40 50 80 00       	mov    0x805040,%eax
  802035:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	83 c0 08             	add    $0x8,%eax
  802041:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	83 c0 04             	add    $0x4,%eax
  80204a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204d:	83 ea 08             	sub    $0x8,%edx
  802050:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802052:	8b 55 0c             	mov    0xc(%ebp),%edx
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	01 d0                	add    %edx,%eax
  80205a:	83 e8 08             	sub    $0x8,%eax
  80205d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802060:	83 ea 08             	sub    $0x8,%edx
  802063:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802065:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802068:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80206e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802071:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802078:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80207c:	75 17                	jne    802095 <initialize_dynamic_allocator+0x19c>
  80207e:	83 ec 04             	sub    $0x4,%esp
  802081:	68 c4 42 80 00       	push   $0x8042c4
  802086:	68 90 00 00 00       	push   $0x90
  80208b:	68 a9 42 80 00       	push   $0x8042a9
  802090:	e8 a8 e1 ff ff       	call   80023d <_panic>
  802095:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80209b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209e:	89 10                	mov    %edx,(%eax)
  8020a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a3:	8b 00                	mov    (%eax),%eax
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	74 0d                	je     8020b6 <initialize_dynamic_allocator+0x1bd>
  8020a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020b1:	89 50 04             	mov    %edx,0x4(%eax)
  8020b4:	eb 08                	jmp    8020be <initialize_dynamic_allocator+0x1c5>
  8020b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8020be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8020d5:	40                   	inc    %eax
  8020d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8020db:	eb 07                	jmp    8020e4 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8020dd:	90                   	nop
  8020de:	eb 04                	jmp    8020e4 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8020e0:	90                   	nop
  8020e1:	eb 01                	jmp    8020e4 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8020e3:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8020e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ec:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8020f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f8:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	83 e8 04             	sub    $0x4,%eax
  802100:	8b 00                	mov    (%eax),%eax
  802102:	83 e0 fe             	and    $0xfffffffe,%eax
  802105:	8d 50 f8             	lea    -0x8(%eax),%edx
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	01 c2                	add    %eax,%edx
  80210d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802110:	89 02                	mov    %eax,(%edx)
}
  802112:	90                   	nop
  802113:	5d                   	pop    %ebp
  802114:	c3                   	ret    

00802115 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	83 e0 01             	and    $0x1,%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	74 03                	je     802128 <alloc_block_FF+0x13>
  802125:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802128:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80212c:	77 07                	ja     802135 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80212e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802135:	a1 24 50 80 00       	mov    0x805024,%eax
  80213a:	85 c0                	test   %eax,%eax
  80213c:	75 73                	jne    8021b1 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	83 c0 10             	add    $0x10,%eax
  802144:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802147:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80214e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802151:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802154:	01 d0                	add    %edx,%eax
  802156:	48                   	dec    %eax
  802157:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80215a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80215d:	ba 00 00 00 00       	mov    $0x0,%edx
  802162:	f7 75 ec             	divl   -0x14(%ebp)
  802165:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802168:	29 d0                	sub    %edx,%eax
  80216a:	c1 e8 0c             	shr    $0xc,%eax
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	50                   	push   %eax
  802171:	e8 1e f1 ff ff       	call   801294 <sbrk>
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80217c:	83 ec 0c             	sub    $0xc,%esp
  80217f:	6a 00                	push   $0x0
  802181:	e8 0e f1 ff ff       	call   801294 <sbrk>
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80218c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80218f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802192:	83 ec 08             	sub    $0x8,%esp
  802195:	50                   	push   %eax
  802196:	ff 75 e4             	pushl  -0x1c(%ebp)
  802199:	e8 5b fd ff ff       	call   801ef9 <initialize_dynamic_allocator>
  80219e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8021a1:	83 ec 0c             	sub    $0xc,%esp
  8021a4:	68 e7 42 80 00       	push   $0x8042e7
  8021a9:	e8 4c e3 ff ff       	call   8004fa <cprintf>
  8021ae:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8021b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b5:	75 0a                	jne    8021c1 <alloc_block_FF+0xac>
	        return NULL;
  8021b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bc:	e9 0e 04 00 00       	jmp    8025cf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8021c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8021c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d0:	e9 f3 02 00 00       	jmp    8024c8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8021d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8021db:	83 ec 0c             	sub    $0xc,%esp
  8021de:	ff 75 bc             	pushl  -0x44(%ebp)
  8021e1:	e8 af fb ff ff       	call   801d95 <get_block_size>
  8021e6:	83 c4 10             	add    $0x10,%esp
  8021e9:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	83 c0 08             	add    $0x8,%eax
  8021f2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021f5:	0f 87 c5 02 00 00    	ja     8024c0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	83 c0 18             	add    $0x18,%eax
  802201:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802204:	0f 87 19 02 00 00    	ja     802423 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80220a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80220d:	2b 45 08             	sub    0x8(%ebp),%eax
  802210:	83 e8 08             	sub    $0x8,%eax
  802213:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	8d 50 08             	lea    0x8(%eax),%edx
  80221c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80221f:	01 d0                	add    %edx,%eax
  802221:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	83 c0 08             	add    $0x8,%eax
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	6a 01                	push   $0x1
  80222f:	50                   	push   %eax
  802230:	ff 75 bc             	pushl  -0x44(%ebp)
  802233:	e8 ae fe ff ff       	call   8020e6 <set_block_data>
  802238:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80223b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223e:	8b 40 04             	mov    0x4(%eax),%eax
  802241:	85 c0                	test   %eax,%eax
  802243:	75 68                	jne    8022ad <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802245:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802249:	75 17                	jne    802262 <alloc_block_FF+0x14d>
  80224b:	83 ec 04             	sub    $0x4,%esp
  80224e:	68 c4 42 80 00       	push   $0x8042c4
  802253:	68 d7 00 00 00       	push   $0xd7
  802258:	68 a9 42 80 00       	push   $0x8042a9
  80225d:	e8 db df ff ff       	call   80023d <_panic>
  802262:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802268:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80226b:	89 10                	mov    %edx,(%eax)
  80226d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802270:	8b 00                	mov    (%eax),%eax
  802272:	85 c0                	test   %eax,%eax
  802274:	74 0d                	je     802283 <alloc_block_FF+0x16e>
  802276:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80227b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80227e:	89 50 04             	mov    %edx,0x4(%eax)
  802281:	eb 08                	jmp    80228b <alloc_block_FF+0x176>
  802283:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802286:	a3 30 50 80 00       	mov    %eax,0x805030
  80228b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80228e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802293:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802296:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80229d:	a1 38 50 80 00       	mov    0x805038,%eax
  8022a2:	40                   	inc    %eax
  8022a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8022a8:	e9 dc 00 00 00       	jmp    802389 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b0:	8b 00                	mov    (%eax),%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	75 65                	jne    80231b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022b6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022ba:	75 17                	jne    8022d3 <alloc_block_FF+0x1be>
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	68 f8 42 80 00       	push   $0x8042f8
  8022c4:	68 db 00 00 00       	push   $0xdb
  8022c9:	68 a9 42 80 00       	push   $0x8042a9
  8022ce:	e8 6a df ff ff       	call   80023d <_panic>
  8022d3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8022d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022dc:	89 50 04             	mov    %edx,0x4(%eax)
  8022df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e2:	8b 40 04             	mov    0x4(%eax),%eax
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	74 0c                	je     8022f5 <alloc_block_FF+0x1e0>
  8022e9:	a1 30 50 80 00       	mov    0x805030,%eax
  8022ee:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022f1:	89 10                	mov    %edx,(%eax)
  8022f3:	eb 08                	jmp    8022fd <alloc_block_FF+0x1e8>
  8022f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802300:	a3 30 50 80 00       	mov    %eax,0x805030
  802305:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802308:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80230e:	a1 38 50 80 00       	mov    0x805038,%eax
  802313:	40                   	inc    %eax
  802314:	a3 38 50 80 00       	mov    %eax,0x805038
  802319:	eb 6e                	jmp    802389 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80231b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231f:	74 06                	je     802327 <alloc_block_FF+0x212>
  802321:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802325:	75 17                	jne    80233e <alloc_block_FF+0x229>
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	68 1c 43 80 00       	push   $0x80431c
  80232f:	68 df 00 00 00       	push   $0xdf
  802334:	68 a9 42 80 00       	push   $0x8042a9
  802339:	e8 ff de ff ff       	call   80023d <_panic>
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 10                	mov    (%eax),%edx
  802343:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802346:	89 10                	mov    %edx,(%eax)
  802348:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	74 0b                	je     80235c <alloc_block_FF+0x247>
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802359:	89 50 04             	mov    %edx,0x4(%eax)
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802362:	89 10                	mov    %edx,(%eax)
  802364:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236a:	89 50 04             	mov    %edx,0x4(%eax)
  80236d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802370:	8b 00                	mov    (%eax),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	75 08                	jne    80237e <alloc_block_FF+0x269>
  802376:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802379:	a3 30 50 80 00       	mov    %eax,0x805030
  80237e:	a1 38 50 80 00       	mov    0x805038,%eax
  802383:	40                   	inc    %eax
  802384:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238d:	75 17                	jne    8023a6 <alloc_block_FF+0x291>
  80238f:	83 ec 04             	sub    $0x4,%esp
  802392:	68 8b 42 80 00       	push   $0x80428b
  802397:	68 e1 00 00 00       	push   $0xe1
  80239c:	68 a9 42 80 00       	push   $0x8042a9
  8023a1:	e8 97 de ff ff       	call   80023d <_panic>
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 00                	mov    (%eax),%eax
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	74 10                	je     8023bf <alloc_block_FF+0x2aa>
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b7:	8b 52 04             	mov    0x4(%edx),%edx
  8023ba:	89 50 04             	mov    %edx,0x4(%eax)
  8023bd:	eb 0b                	jmp    8023ca <alloc_block_FF+0x2b5>
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 40 04             	mov    0x4(%eax),%eax
  8023c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 40 04             	mov    0x4(%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	74 0f                	je     8023e3 <alloc_block_FF+0x2ce>
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 40 04             	mov    0x4(%eax),%eax
  8023da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023dd:	8b 12                	mov    (%edx),%edx
  8023df:	89 10                	mov    %edx,(%eax)
  8023e1:	eb 0a                	jmp    8023ed <alloc_block_FF+0x2d8>
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802400:	a1 38 50 80 00       	mov    0x805038,%eax
  802405:	48                   	dec    %eax
  802406:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80240b:	83 ec 04             	sub    $0x4,%esp
  80240e:	6a 00                	push   $0x0
  802410:	ff 75 b4             	pushl  -0x4c(%ebp)
  802413:	ff 75 b0             	pushl  -0x50(%ebp)
  802416:	e8 cb fc ff ff       	call   8020e6 <set_block_data>
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	e9 95 00 00 00       	jmp    8024b8 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802423:	83 ec 04             	sub    $0x4,%esp
  802426:	6a 01                	push   $0x1
  802428:	ff 75 b8             	pushl  -0x48(%ebp)
  80242b:	ff 75 bc             	pushl  -0x44(%ebp)
  80242e:	e8 b3 fc ff ff       	call   8020e6 <set_block_data>
  802433:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802436:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243a:	75 17                	jne    802453 <alloc_block_FF+0x33e>
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	68 8b 42 80 00       	push   $0x80428b
  802444:	68 e8 00 00 00       	push   $0xe8
  802449:	68 a9 42 80 00       	push   $0x8042a9
  80244e:	e8 ea dd ff ff       	call   80023d <_panic>
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	85 c0                	test   %eax,%eax
  80245a:	74 10                	je     80246c <alloc_block_FF+0x357>
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 00                	mov    (%eax),%eax
  802461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802464:	8b 52 04             	mov    0x4(%edx),%edx
  802467:	89 50 04             	mov    %edx,0x4(%eax)
  80246a:	eb 0b                	jmp    802477 <alloc_block_FF+0x362>
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 04             	mov    0x4(%eax),%eax
  802472:	a3 30 50 80 00       	mov    %eax,0x805030
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 40 04             	mov    0x4(%eax),%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	74 0f                	je     802490 <alloc_block_FF+0x37b>
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 40 04             	mov    0x4(%eax),%eax
  802487:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248a:	8b 12                	mov    (%edx),%edx
  80248c:	89 10                	mov    %edx,(%eax)
  80248e:	eb 0a                	jmp    80249a <alloc_block_FF+0x385>
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 00                	mov    (%eax),%eax
  802495:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8024b2:	48                   	dec    %eax
  8024b3:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8024b8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024bb:	e9 0f 01 00 00       	jmp    8025cf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024c0:	a1 34 50 80 00       	mov    0x805034,%eax
  8024c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cc:	74 07                	je     8024d5 <alloc_block_FF+0x3c0>
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 00                	mov    (%eax),%eax
  8024d3:	eb 05                	jmp    8024da <alloc_block_FF+0x3c5>
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024da:	a3 34 50 80 00       	mov    %eax,0x805034
  8024df:	a1 34 50 80 00       	mov    0x805034,%eax
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	0f 85 e9 fc ff ff    	jne    8021d5 <alloc_block_FF+0xc0>
  8024ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f0:	0f 85 df fc ff ff    	jne    8021d5 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	83 c0 08             	add    $0x8,%eax
  8024fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8024ff:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802506:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802509:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80250c:	01 d0                	add    %edx,%eax
  80250e:	48                   	dec    %eax
  80250f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802512:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802515:	ba 00 00 00 00       	mov    $0x0,%edx
  80251a:	f7 75 d8             	divl   -0x28(%ebp)
  80251d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802520:	29 d0                	sub    %edx,%eax
  802522:	c1 e8 0c             	shr    $0xc,%eax
  802525:	83 ec 0c             	sub    $0xc,%esp
  802528:	50                   	push   %eax
  802529:	e8 66 ed ff ff       	call   801294 <sbrk>
  80252e:	83 c4 10             	add    $0x10,%esp
  802531:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802534:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802538:	75 0a                	jne    802544 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80253a:	b8 00 00 00 00       	mov    $0x0,%eax
  80253f:	e9 8b 00 00 00       	jmp    8025cf <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802544:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80254b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80254e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802551:	01 d0                	add    %edx,%eax
  802553:	48                   	dec    %eax
  802554:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802557:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80255a:	ba 00 00 00 00       	mov    $0x0,%edx
  80255f:	f7 75 cc             	divl   -0x34(%ebp)
  802562:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802565:	29 d0                	sub    %edx,%eax
  802567:	8d 50 fc             	lea    -0x4(%eax),%edx
  80256a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80256d:	01 d0                	add    %edx,%eax
  80256f:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802574:	a1 40 50 80 00       	mov    0x805040,%eax
  802579:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80257f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802586:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802589:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80258c:	01 d0                	add    %edx,%eax
  80258e:	48                   	dec    %eax
  80258f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802592:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802595:	ba 00 00 00 00       	mov    $0x0,%edx
  80259a:	f7 75 c4             	divl   -0x3c(%ebp)
  80259d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025a0:	29 d0                	sub    %edx,%eax
  8025a2:	83 ec 04             	sub    $0x4,%esp
  8025a5:	6a 01                	push   $0x1
  8025a7:	50                   	push   %eax
  8025a8:	ff 75 d0             	pushl  -0x30(%ebp)
  8025ab:	e8 36 fb ff ff       	call   8020e6 <set_block_data>
  8025b0:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8025b3:	83 ec 0c             	sub    $0xc,%esp
  8025b6:	ff 75 d0             	pushl  -0x30(%ebp)
  8025b9:	e8 1b 0a 00 00       	call   802fd9 <free_block>
  8025be:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8025c1:	83 ec 0c             	sub    $0xc,%esp
  8025c4:	ff 75 08             	pushl  0x8(%ebp)
  8025c7:	e8 49 fb ff ff       	call   802115 <alloc_block_FF>
  8025cc:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	83 e0 01             	and    $0x1,%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 03                	je     8025e4 <alloc_block_BF+0x13>
  8025e1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025e4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025e8:	77 07                	ja     8025f1 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025ea:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025f1:	a1 24 50 80 00       	mov    0x805024,%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	75 73                	jne    80266d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	83 c0 10             	add    $0x10,%eax
  802600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802603:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80260a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80260d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802610:	01 d0                	add    %edx,%eax
  802612:	48                   	dec    %eax
  802613:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802616:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802619:	ba 00 00 00 00       	mov    $0x0,%edx
  80261e:	f7 75 e0             	divl   -0x20(%ebp)
  802621:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802624:	29 d0                	sub    %edx,%eax
  802626:	c1 e8 0c             	shr    $0xc,%eax
  802629:	83 ec 0c             	sub    $0xc,%esp
  80262c:	50                   	push   %eax
  80262d:	e8 62 ec ff ff       	call   801294 <sbrk>
  802632:	83 c4 10             	add    $0x10,%esp
  802635:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802638:	83 ec 0c             	sub    $0xc,%esp
  80263b:	6a 00                	push   $0x0
  80263d:	e8 52 ec ff ff       	call   801294 <sbrk>
  802642:	83 c4 10             	add    $0x10,%esp
  802645:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802648:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80264b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80264e:	83 ec 08             	sub    $0x8,%esp
  802651:	50                   	push   %eax
  802652:	ff 75 d8             	pushl  -0x28(%ebp)
  802655:	e8 9f f8 ff ff       	call   801ef9 <initialize_dynamic_allocator>
  80265a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80265d:	83 ec 0c             	sub    $0xc,%esp
  802660:	68 e7 42 80 00       	push   $0x8042e7
  802665:	e8 90 de ff ff       	call   8004fa <cprintf>
  80266a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80266d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802674:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80267b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802682:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802689:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80268e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802691:	e9 1d 01 00 00       	jmp    8027b3 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80269c:	83 ec 0c             	sub    $0xc,%esp
  80269f:	ff 75 a8             	pushl  -0x58(%ebp)
  8026a2:	e8 ee f6 ff ff       	call   801d95 <get_block_size>
  8026a7:	83 c4 10             	add    $0x10,%esp
  8026aa:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	83 c0 08             	add    $0x8,%eax
  8026b3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026b6:	0f 87 ef 00 00 00    	ja     8027ab <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8026bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bf:	83 c0 18             	add    $0x18,%eax
  8026c2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026c5:	77 1d                	ja     8026e4 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8026c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ca:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026cd:	0f 86 d8 00 00 00    	jbe    8027ab <alloc_block_BF+0x1da>
				{
					best_va = va;
  8026d3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8026d9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026df:	e9 c7 00 00 00       	jmp    8027ab <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	83 c0 08             	add    $0x8,%eax
  8026ea:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026ed:	0f 85 9d 00 00 00    	jne    802790 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8026f3:	83 ec 04             	sub    $0x4,%esp
  8026f6:	6a 01                	push   $0x1
  8026f8:	ff 75 a4             	pushl  -0x5c(%ebp)
  8026fb:	ff 75 a8             	pushl  -0x58(%ebp)
  8026fe:	e8 e3 f9 ff ff       	call   8020e6 <set_block_data>
  802703:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802706:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270a:	75 17                	jne    802723 <alloc_block_BF+0x152>
  80270c:	83 ec 04             	sub    $0x4,%esp
  80270f:	68 8b 42 80 00       	push   $0x80428b
  802714:	68 2c 01 00 00       	push   $0x12c
  802719:	68 a9 42 80 00       	push   $0x8042a9
  80271e:	e8 1a db ff ff       	call   80023d <_panic>
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 00                	mov    (%eax),%eax
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 10                	je     80273c <alloc_block_BF+0x16b>
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 00                	mov    (%eax),%eax
  802731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802734:	8b 52 04             	mov    0x4(%edx),%edx
  802737:	89 50 04             	mov    %edx,0x4(%eax)
  80273a:	eb 0b                	jmp    802747 <alloc_block_BF+0x176>
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	8b 40 04             	mov    0x4(%eax),%eax
  802742:	a3 30 50 80 00       	mov    %eax,0x805030
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 40 04             	mov    0x4(%eax),%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	74 0f                	je     802760 <alloc_block_BF+0x18f>
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 40 04             	mov    0x4(%eax),%eax
  802757:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275a:	8b 12                	mov    (%edx),%edx
  80275c:	89 10                	mov    %edx,(%eax)
  80275e:	eb 0a                	jmp    80276a <alloc_block_BF+0x199>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277d:	a1 38 50 80 00       	mov    0x805038,%eax
  802782:	48                   	dec    %eax
  802783:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802788:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80278b:	e9 24 04 00 00       	jmp    802bb4 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802793:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802796:	76 13                	jbe    8027ab <alloc_block_BF+0x1da>
					{
						internal = 1;
  802798:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80279f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8027a5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027a8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8027ab:	a1 34 50 80 00       	mov    0x805034,%eax
  8027b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b7:	74 07                	je     8027c0 <alloc_block_BF+0x1ef>
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 00                	mov    (%eax),%eax
  8027be:	eb 05                	jmp    8027c5 <alloc_block_BF+0x1f4>
  8027c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c5:	a3 34 50 80 00       	mov    %eax,0x805034
  8027ca:	a1 34 50 80 00       	mov    0x805034,%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	0f 85 bf fe ff ff    	jne    802696 <alloc_block_BF+0xc5>
  8027d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027db:	0f 85 b5 fe ff ff    	jne    802696 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8027e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027e5:	0f 84 26 02 00 00    	je     802a11 <alloc_block_BF+0x440>
  8027eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027ef:	0f 85 1c 02 00 00    	jne    802a11 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8027f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f8:	2b 45 08             	sub    0x8(%ebp),%eax
  8027fb:	83 e8 08             	sub    $0x8,%eax
  8027fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	8d 50 08             	lea    0x8(%eax),%edx
  802807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280a:	01 d0                	add    %edx,%eax
  80280c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80280f:	8b 45 08             	mov    0x8(%ebp),%eax
  802812:	83 c0 08             	add    $0x8,%eax
  802815:	83 ec 04             	sub    $0x4,%esp
  802818:	6a 01                	push   $0x1
  80281a:	50                   	push   %eax
  80281b:	ff 75 f0             	pushl  -0x10(%ebp)
  80281e:	e8 c3 f8 ff ff       	call   8020e6 <set_block_data>
  802823:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	8b 40 04             	mov    0x4(%eax),%eax
  80282c:	85 c0                	test   %eax,%eax
  80282e:	75 68                	jne    802898 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802830:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802834:	75 17                	jne    80284d <alloc_block_BF+0x27c>
  802836:	83 ec 04             	sub    $0x4,%esp
  802839:	68 c4 42 80 00       	push   $0x8042c4
  80283e:	68 45 01 00 00       	push   $0x145
  802843:	68 a9 42 80 00       	push   $0x8042a9
  802848:	e8 f0 d9 ff ff       	call   80023d <_panic>
  80284d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802853:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802856:	89 10                	mov    %edx,(%eax)
  802858:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	74 0d                	je     80286e <alloc_block_BF+0x29d>
  802861:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802869:	89 50 04             	mov    %edx,0x4(%eax)
  80286c:	eb 08                	jmp    802876 <alloc_block_BF+0x2a5>
  80286e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802871:	a3 30 50 80 00       	mov    %eax,0x805030
  802876:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802879:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80287e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802881:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802888:	a1 38 50 80 00       	mov    0x805038,%eax
  80288d:	40                   	inc    %eax
  80288e:	a3 38 50 80 00       	mov    %eax,0x805038
  802893:	e9 dc 00 00 00       	jmp    802974 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	75 65                	jne    802906 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028a1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028a5:	75 17                	jne    8028be <alloc_block_BF+0x2ed>
  8028a7:	83 ec 04             	sub    $0x4,%esp
  8028aa:	68 f8 42 80 00       	push   $0x8042f8
  8028af:	68 4a 01 00 00       	push   $0x14a
  8028b4:	68 a9 42 80 00       	push   $0x8042a9
  8028b9:	e8 7f d9 ff ff       	call   80023d <_panic>
  8028be:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028cd:	8b 40 04             	mov    0x4(%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 0c                	je     8028e0 <alloc_block_BF+0x30f>
  8028d4:	a1 30 50 80 00       	mov    0x805030,%eax
  8028d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028dc:	89 10                	mov    %edx,(%eax)
  8028de:	eb 08                	jmp    8028e8 <alloc_block_BF+0x317>
  8028e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028eb:	a3 30 50 80 00       	mov    %eax,0x805030
  8028f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8028fe:	40                   	inc    %eax
  8028ff:	a3 38 50 80 00       	mov    %eax,0x805038
  802904:	eb 6e                	jmp    802974 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802906:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80290a:	74 06                	je     802912 <alloc_block_BF+0x341>
  80290c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802910:	75 17                	jne    802929 <alloc_block_BF+0x358>
  802912:	83 ec 04             	sub    $0x4,%esp
  802915:	68 1c 43 80 00       	push   $0x80431c
  80291a:	68 4f 01 00 00       	push   $0x14f
  80291f:	68 a9 42 80 00       	push   $0x8042a9
  802924:	e8 14 d9 ff ff       	call   80023d <_panic>
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	8b 10                	mov    (%eax),%edx
  80292e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802931:	89 10                	mov    %edx,(%eax)
  802933:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	85 c0                	test   %eax,%eax
  80293a:	74 0b                	je     802947 <alloc_block_BF+0x376>
  80293c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293f:	8b 00                	mov    (%eax),%eax
  802941:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802944:	89 50 04             	mov    %edx,0x4(%eax)
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80294d:	89 10                	mov    %edx,(%eax)
  80294f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802955:	89 50 04             	mov    %edx,0x4(%eax)
  802958:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295b:	8b 00                	mov    (%eax),%eax
  80295d:	85 c0                	test   %eax,%eax
  80295f:	75 08                	jne    802969 <alloc_block_BF+0x398>
  802961:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802964:	a3 30 50 80 00       	mov    %eax,0x805030
  802969:	a1 38 50 80 00       	mov    0x805038,%eax
  80296e:	40                   	inc    %eax
  80296f:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802974:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802978:	75 17                	jne    802991 <alloc_block_BF+0x3c0>
  80297a:	83 ec 04             	sub    $0x4,%esp
  80297d:	68 8b 42 80 00       	push   $0x80428b
  802982:	68 51 01 00 00       	push   $0x151
  802987:	68 a9 42 80 00       	push   $0x8042a9
  80298c:	e8 ac d8 ff ff       	call   80023d <_panic>
  802991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802994:	8b 00                	mov    (%eax),%eax
  802996:	85 c0                	test   %eax,%eax
  802998:	74 10                	je     8029aa <alloc_block_BF+0x3d9>
  80299a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a2:	8b 52 04             	mov    0x4(%edx),%edx
  8029a5:	89 50 04             	mov    %edx,0x4(%eax)
  8029a8:	eb 0b                	jmp    8029b5 <alloc_block_BF+0x3e4>
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	8b 40 04             	mov    0x4(%eax),%eax
  8029b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b8:	8b 40 04             	mov    0x4(%eax),%eax
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	74 0f                	je     8029ce <alloc_block_BF+0x3fd>
  8029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c2:	8b 40 04             	mov    0x4(%eax),%eax
  8029c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c8:	8b 12                	mov    (%edx),%edx
  8029ca:	89 10                	mov    %edx,(%eax)
  8029cc:	eb 0a                	jmp    8029d8 <alloc_block_BF+0x407>
  8029ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d1:	8b 00                	mov    (%eax),%eax
  8029d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8029f0:	48                   	dec    %eax
  8029f1:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8029f6:	83 ec 04             	sub    $0x4,%esp
  8029f9:	6a 00                	push   $0x0
  8029fb:	ff 75 d0             	pushl  -0x30(%ebp)
  8029fe:	ff 75 cc             	pushl  -0x34(%ebp)
  802a01:	e8 e0 f6 ff ff       	call   8020e6 <set_block_data>
  802a06:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0c:	e9 a3 01 00 00       	jmp    802bb4 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a11:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a15:	0f 85 9d 00 00 00    	jne    802ab8 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a1b:	83 ec 04             	sub    $0x4,%esp
  802a1e:	6a 01                	push   $0x1
  802a20:	ff 75 ec             	pushl  -0x14(%ebp)
  802a23:	ff 75 f0             	pushl  -0x10(%ebp)
  802a26:	e8 bb f6 ff ff       	call   8020e6 <set_block_data>
  802a2b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a32:	75 17                	jne    802a4b <alloc_block_BF+0x47a>
  802a34:	83 ec 04             	sub    $0x4,%esp
  802a37:	68 8b 42 80 00       	push   $0x80428b
  802a3c:	68 58 01 00 00       	push   $0x158
  802a41:	68 a9 42 80 00       	push   $0x8042a9
  802a46:	e8 f2 d7 ff ff       	call   80023d <_panic>
  802a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	74 10                	je     802a64 <alloc_block_BF+0x493>
  802a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a57:	8b 00                	mov    (%eax),%eax
  802a59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5c:	8b 52 04             	mov    0x4(%edx),%edx
  802a5f:	89 50 04             	mov    %edx,0x4(%eax)
  802a62:	eb 0b                	jmp    802a6f <alloc_block_BF+0x49e>
  802a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a67:	8b 40 04             	mov    0x4(%eax),%eax
  802a6a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a72:	8b 40 04             	mov    0x4(%eax),%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	74 0f                	je     802a88 <alloc_block_BF+0x4b7>
  802a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7c:	8b 40 04             	mov    0x4(%eax),%eax
  802a7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a82:	8b 12                	mov    (%edx),%edx
  802a84:	89 10                	mov    %edx,(%eax)
  802a86:	eb 0a                	jmp    802a92 <alloc_block_BF+0x4c1>
  802a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8b:	8b 00                	mov    (%eax),%eax
  802a8d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa5:	a1 38 50 80 00       	mov    0x805038,%eax
  802aaa:	48                   	dec    %eax
  802aab:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab3:	e9 fc 00 00 00       	jmp    802bb4 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	83 c0 08             	add    $0x8,%eax
  802abe:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ac1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ac8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802acb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ace:	01 d0                	add    %edx,%eax
  802ad0:	48                   	dec    %eax
  802ad1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ad4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  802adc:	f7 75 c4             	divl   -0x3c(%ebp)
  802adf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ae2:	29 d0                	sub    %edx,%eax
  802ae4:	c1 e8 0c             	shr    $0xc,%eax
  802ae7:	83 ec 0c             	sub    $0xc,%esp
  802aea:	50                   	push   %eax
  802aeb:	e8 a4 e7 ff ff       	call   801294 <sbrk>
  802af0:	83 c4 10             	add    $0x10,%esp
  802af3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802af6:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802afa:	75 0a                	jne    802b06 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802afc:	b8 00 00 00 00       	mov    $0x0,%eax
  802b01:	e9 ae 00 00 00       	jmp    802bb4 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b06:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b0d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b10:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b13:	01 d0                	add    %edx,%eax
  802b15:	48                   	dec    %eax
  802b16:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b19:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b1c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b21:	f7 75 b8             	divl   -0x48(%ebp)
  802b24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b27:	29 d0                	sub    %edx,%eax
  802b29:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b2c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b2f:	01 d0                	add    %edx,%eax
  802b31:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b36:	a1 40 50 80 00       	mov    0x805040,%eax
  802b3b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b41:	83 ec 0c             	sub    $0xc,%esp
  802b44:	68 50 43 80 00       	push   $0x804350
  802b49:	e8 ac d9 ff ff       	call   8004fa <cprintf>
  802b4e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b51:	83 ec 08             	sub    $0x8,%esp
  802b54:	ff 75 bc             	pushl  -0x44(%ebp)
  802b57:	68 55 43 80 00       	push   $0x804355
  802b5c:	e8 99 d9 ff ff       	call   8004fa <cprintf>
  802b61:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b64:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b6b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b71:	01 d0                	add    %edx,%eax
  802b73:	48                   	dec    %eax
  802b74:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b77:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b7a:	ba 00 00 00 00       	mov    $0x0,%edx
  802b7f:	f7 75 b0             	divl   -0x50(%ebp)
  802b82:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b85:	29 d0                	sub    %edx,%eax
  802b87:	83 ec 04             	sub    $0x4,%esp
  802b8a:	6a 01                	push   $0x1
  802b8c:	50                   	push   %eax
  802b8d:	ff 75 bc             	pushl  -0x44(%ebp)
  802b90:	e8 51 f5 ff ff       	call   8020e6 <set_block_data>
  802b95:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b98:	83 ec 0c             	sub    $0xc,%esp
  802b9b:	ff 75 bc             	pushl  -0x44(%ebp)
  802b9e:	e8 36 04 00 00       	call   802fd9 <free_block>
  802ba3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ba6:	83 ec 0c             	sub    $0xc,%esp
  802ba9:	ff 75 08             	pushl  0x8(%ebp)
  802bac:	e8 20 fa ff ff       	call   8025d1 <alloc_block_BF>
  802bb1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
  802bb9:	53                   	push   %ebx
  802bba:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802bbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802bc4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802bcb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bcf:	74 1e                	je     802bef <merging+0x39>
  802bd1:	ff 75 08             	pushl  0x8(%ebp)
  802bd4:	e8 bc f1 ff ff       	call   801d95 <get_block_size>
  802bd9:	83 c4 04             	add    $0x4,%esp
  802bdc:	89 c2                	mov    %eax,%edx
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	01 d0                	add    %edx,%eax
  802be3:	3b 45 10             	cmp    0x10(%ebp),%eax
  802be6:	75 07                	jne    802bef <merging+0x39>
		prev_is_free = 1;
  802be8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802bef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bf3:	74 1e                	je     802c13 <merging+0x5d>
  802bf5:	ff 75 10             	pushl  0x10(%ebp)
  802bf8:	e8 98 f1 ff ff       	call   801d95 <get_block_size>
  802bfd:	83 c4 04             	add    $0x4,%esp
  802c00:	89 c2                	mov    %eax,%edx
  802c02:	8b 45 10             	mov    0x10(%ebp),%eax
  802c05:	01 d0                	add    %edx,%eax
  802c07:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c0a:	75 07                	jne    802c13 <merging+0x5d>
		next_is_free = 1;
  802c0c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c17:	0f 84 cc 00 00 00    	je     802ce9 <merging+0x133>
  802c1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c21:	0f 84 c2 00 00 00    	je     802ce9 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c27:	ff 75 08             	pushl  0x8(%ebp)
  802c2a:	e8 66 f1 ff ff       	call   801d95 <get_block_size>
  802c2f:	83 c4 04             	add    $0x4,%esp
  802c32:	89 c3                	mov    %eax,%ebx
  802c34:	ff 75 10             	pushl  0x10(%ebp)
  802c37:	e8 59 f1 ff ff       	call   801d95 <get_block_size>
  802c3c:	83 c4 04             	add    $0x4,%esp
  802c3f:	01 c3                	add    %eax,%ebx
  802c41:	ff 75 0c             	pushl  0xc(%ebp)
  802c44:	e8 4c f1 ff ff       	call   801d95 <get_block_size>
  802c49:	83 c4 04             	add    $0x4,%esp
  802c4c:	01 d8                	add    %ebx,%eax
  802c4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c51:	6a 00                	push   $0x0
  802c53:	ff 75 ec             	pushl  -0x14(%ebp)
  802c56:	ff 75 08             	pushl  0x8(%ebp)
  802c59:	e8 88 f4 ff ff       	call   8020e6 <set_block_data>
  802c5e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c65:	75 17                	jne    802c7e <merging+0xc8>
  802c67:	83 ec 04             	sub    $0x4,%esp
  802c6a:	68 8b 42 80 00       	push   $0x80428b
  802c6f:	68 7d 01 00 00       	push   $0x17d
  802c74:	68 a9 42 80 00       	push   $0x8042a9
  802c79:	e8 bf d5 ff ff       	call   80023d <_panic>
  802c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	74 10                	je     802c97 <merging+0xe1>
  802c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c8f:	8b 52 04             	mov    0x4(%edx),%edx
  802c92:	89 50 04             	mov    %edx,0x4(%eax)
  802c95:	eb 0b                	jmp    802ca2 <merging+0xec>
  802c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9a:	8b 40 04             	mov    0x4(%eax),%eax
  802c9d:	a3 30 50 80 00       	mov    %eax,0x805030
  802ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	74 0f                	je     802cbb <merging+0x105>
  802cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802caf:	8b 40 04             	mov    0x4(%eax),%eax
  802cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cb5:	8b 12                	mov    (%edx),%edx
  802cb7:	89 10                	mov    %edx,(%eax)
  802cb9:	eb 0a                	jmp    802cc5 <merging+0x10f>
  802cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd8:	a1 38 50 80 00       	mov    0x805038,%eax
  802cdd:	48                   	dec    %eax
  802cde:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ce3:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ce4:	e9 ea 02 00 00       	jmp    802fd3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ce9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ced:	74 3b                	je     802d2a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802cef:	83 ec 0c             	sub    $0xc,%esp
  802cf2:	ff 75 08             	pushl  0x8(%ebp)
  802cf5:	e8 9b f0 ff ff       	call   801d95 <get_block_size>
  802cfa:	83 c4 10             	add    $0x10,%esp
  802cfd:	89 c3                	mov    %eax,%ebx
  802cff:	83 ec 0c             	sub    $0xc,%esp
  802d02:	ff 75 10             	pushl  0x10(%ebp)
  802d05:	e8 8b f0 ff ff       	call   801d95 <get_block_size>
  802d0a:	83 c4 10             	add    $0x10,%esp
  802d0d:	01 d8                	add    %ebx,%eax
  802d0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d12:	83 ec 04             	sub    $0x4,%esp
  802d15:	6a 00                	push   $0x0
  802d17:	ff 75 e8             	pushl  -0x18(%ebp)
  802d1a:	ff 75 08             	pushl  0x8(%ebp)
  802d1d:	e8 c4 f3 ff ff       	call   8020e6 <set_block_data>
  802d22:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d25:	e9 a9 02 00 00       	jmp    802fd3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d2e:	0f 84 2d 01 00 00    	je     802e61 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d34:	83 ec 0c             	sub    $0xc,%esp
  802d37:	ff 75 10             	pushl  0x10(%ebp)
  802d3a:	e8 56 f0 ff ff       	call   801d95 <get_block_size>
  802d3f:	83 c4 10             	add    $0x10,%esp
  802d42:	89 c3                	mov    %eax,%ebx
  802d44:	83 ec 0c             	sub    $0xc,%esp
  802d47:	ff 75 0c             	pushl  0xc(%ebp)
  802d4a:	e8 46 f0 ff ff       	call   801d95 <get_block_size>
  802d4f:	83 c4 10             	add    $0x10,%esp
  802d52:	01 d8                	add    %ebx,%eax
  802d54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d57:	83 ec 04             	sub    $0x4,%esp
  802d5a:	6a 00                	push   $0x0
  802d5c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d5f:	ff 75 10             	pushl  0x10(%ebp)
  802d62:	e8 7f f3 ff ff       	call   8020e6 <set_block_data>
  802d67:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  802d6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d74:	74 06                	je     802d7c <merging+0x1c6>
  802d76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d7a:	75 17                	jne    802d93 <merging+0x1dd>
  802d7c:	83 ec 04             	sub    $0x4,%esp
  802d7f:	68 64 43 80 00       	push   $0x804364
  802d84:	68 8d 01 00 00       	push   $0x18d
  802d89:	68 a9 42 80 00       	push   $0x8042a9
  802d8e:	e8 aa d4 ff ff       	call   80023d <_panic>
  802d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d96:	8b 50 04             	mov    0x4(%eax),%edx
  802d99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9c:	89 50 04             	mov    %edx,0x4(%eax)
  802d9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da5:	89 10                	mov    %edx,(%eax)
  802da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802daa:	8b 40 04             	mov    0x4(%eax),%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	74 0d                	je     802dbe <merging+0x208>
  802db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db4:	8b 40 04             	mov    0x4(%eax),%eax
  802db7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dba:	89 10                	mov    %edx,(%eax)
  802dbc:	eb 08                	jmp    802dc6 <merging+0x210>
  802dbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dcc:	89 50 04             	mov    %edx,0x4(%eax)
  802dcf:	a1 38 50 80 00       	mov    0x805038,%eax
  802dd4:	40                   	inc    %eax
  802dd5:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802dda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dde:	75 17                	jne    802df7 <merging+0x241>
  802de0:	83 ec 04             	sub    $0x4,%esp
  802de3:	68 8b 42 80 00       	push   $0x80428b
  802de8:	68 8e 01 00 00       	push   $0x18e
  802ded:	68 a9 42 80 00       	push   $0x8042a9
  802df2:	e8 46 d4 ff ff       	call   80023d <_panic>
  802df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfa:	8b 00                	mov    (%eax),%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	74 10                	je     802e10 <merging+0x25a>
  802e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e08:	8b 52 04             	mov    0x4(%edx),%edx
  802e0b:	89 50 04             	mov    %edx,0x4(%eax)
  802e0e:	eb 0b                	jmp    802e1b <merging+0x265>
  802e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1e:	8b 40 04             	mov    0x4(%eax),%eax
  802e21:	85 c0                	test   %eax,%eax
  802e23:	74 0f                	je     802e34 <merging+0x27e>
  802e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e2e:	8b 12                	mov    (%edx),%edx
  802e30:	89 10                	mov    %edx,(%eax)
  802e32:	eb 0a                	jmp    802e3e <merging+0x288>
  802e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e51:	a1 38 50 80 00       	mov    0x805038,%eax
  802e56:	48                   	dec    %eax
  802e57:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e5c:	e9 72 01 00 00       	jmp    802fd3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e61:	8b 45 10             	mov    0x10(%ebp),%eax
  802e64:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6b:	74 79                	je     802ee6 <merging+0x330>
  802e6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e71:	74 73                	je     802ee6 <merging+0x330>
  802e73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e77:	74 06                	je     802e7f <merging+0x2c9>
  802e79:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e7d:	75 17                	jne    802e96 <merging+0x2e0>
  802e7f:	83 ec 04             	sub    $0x4,%esp
  802e82:	68 1c 43 80 00       	push   $0x80431c
  802e87:	68 94 01 00 00       	push   $0x194
  802e8c:	68 a9 42 80 00       	push   $0x8042a9
  802e91:	e8 a7 d3 ff ff       	call   80023d <_panic>
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	8b 10                	mov    (%eax),%edx
  802e9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9e:	89 10                	mov    %edx,(%eax)
  802ea0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea3:	8b 00                	mov    (%eax),%eax
  802ea5:	85 c0                	test   %eax,%eax
  802ea7:	74 0b                	je     802eb4 <merging+0x2fe>
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	8b 00                	mov    (%eax),%eax
  802eae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eb1:	89 50 04             	mov    %edx,0x4(%eax)
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eba:	89 10                	mov    %edx,(%eax)
  802ebc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec2:	89 50 04             	mov    %edx,0x4(%eax)
  802ec5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec8:	8b 00                	mov    (%eax),%eax
  802eca:	85 c0                	test   %eax,%eax
  802ecc:	75 08                	jne    802ed6 <merging+0x320>
  802ece:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ed6:	a1 38 50 80 00       	mov    0x805038,%eax
  802edb:	40                   	inc    %eax
  802edc:	a3 38 50 80 00       	mov    %eax,0x805038
  802ee1:	e9 ce 00 00 00       	jmp    802fb4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802ee6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eea:	74 65                	je     802f51 <merging+0x39b>
  802eec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ef0:	75 17                	jne    802f09 <merging+0x353>
  802ef2:	83 ec 04             	sub    $0x4,%esp
  802ef5:	68 f8 42 80 00       	push   $0x8042f8
  802efa:	68 95 01 00 00       	push   $0x195
  802eff:	68 a9 42 80 00       	push   $0x8042a9
  802f04:	e8 34 d3 ff ff       	call   80023d <_panic>
  802f09:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f12:	89 50 04             	mov    %edx,0x4(%eax)
  802f15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f18:	8b 40 04             	mov    0x4(%eax),%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	74 0c                	je     802f2b <merging+0x375>
  802f1f:	a1 30 50 80 00       	mov    0x805030,%eax
  802f24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f27:	89 10                	mov    %edx,(%eax)
  802f29:	eb 08                	jmp    802f33 <merging+0x37d>
  802f2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f2e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f36:	a3 30 50 80 00       	mov    %eax,0x805030
  802f3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f44:	a1 38 50 80 00       	mov    0x805038,%eax
  802f49:	40                   	inc    %eax
  802f4a:	a3 38 50 80 00       	mov    %eax,0x805038
  802f4f:	eb 63                	jmp    802fb4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f51:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f55:	75 17                	jne    802f6e <merging+0x3b8>
  802f57:	83 ec 04             	sub    $0x4,%esp
  802f5a:	68 c4 42 80 00       	push   $0x8042c4
  802f5f:	68 98 01 00 00       	push   $0x198
  802f64:	68 a9 42 80 00       	push   $0x8042a9
  802f69:	e8 cf d2 ff ff       	call   80023d <_panic>
  802f6e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802f74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f77:	89 10                	mov    %edx,(%eax)
  802f79:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	74 0d                	je     802f8f <merging+0x3d9>
  802f82:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f87:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f8a:	89 50 04             	mov    %edx,0x4(%eax)
  802f8d:	eb 08                	jmp    802f97 <merging+0x3e1>
  802f8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f92:	a3 30 50 80 00       	mov    %eax,0x805030
  802f97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa9:	a1 38 50 80 00       	mov    0x805038,%eax
  802fae:	40                   	inc    %eax
  802faf:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802fb4:	83 ec 0c             	sub    $0xc,%esp
  802fb7:	ff 75 10             	pushl  0x10(%ebp)
  802fba:	e8 d6 ed ff ff       	call   801d95 <get_block_size>
  802fbf:	83 c4 10             	add    $0x10,%esp
  802fc2:	83 ec 04             	sub    $0x4,%esp
  802fc5:	6a 00                	push   $0x0
  802fc7:	50                   	push   %eax
  802fc8:	ff 75 10             	pushl  0x10(%ebp)
  802fcb:	e8 16 f1 ff ff       	call   8020e6 <set_block_data>
  802fd0:	83 c4 10             	add    $0x10,%esp
	}
}
  802fd3:	90                   	nop
  802fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fd7:	c9                   	leave  
  802fd8:	c3                   	ret    

00802fd9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802fd9:	55                   	push   %ebp
  802fda:	89 e5                	mov    %esp,%ebp
  802fdc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802fdf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802fe7:	a1 30 50 80 00       	mov    0x805030,%eax
  802fec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fef:	73 1b                	jae    80300c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802ff1:	a1 30 50 80 00       	mov    0x805030,%eax
  802ff6:	83 ec 04             	sub    $0x4,%esp
  802ff9:	ff 75 08             	pushl  0x8(%ebp)
  802ffc:	6a 00                	push   $0x0
  802ffe:	50                   	push   %eax
  802fff:	e8 b2 fb ff ff       	call   802bb6 <merging>
  803004:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803007:	e9 8b 00 00 00       	jmp    803097 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80300c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803011:	3b 45 08             	cmp    0x8(%ebp),%eax
  803014:	76 18                	jbe    80302e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803016:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80301b:	83 ec 04             	sub    $0x4,%esp
  80301e:	ff 75 08             	pushl  0x8(%ebp)
  803021:	50                   	push   %eax
  803022:	6a 00                	push   $0x0
  803024:	e8 8d fb ff ff       	call   802bb6 <merging>
  803029:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80302c:	eb 69                	jmp    803097 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80302e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803033:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803036:	eb 39                	jmp    803071 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80303e:	73 29                	jae    803069 <free_block+0x90>
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	3b 45 08             	cmp    0x8(%ebp),%eax
  803048:	76 1f                	jbe    803069 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80304a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304d:	8b 00                	mov    (%eax),%eax
  80304f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803052:	83 ec 04             	sub    $0x4,%esp
  803055:	ff 75 08             	pushl  0x8(%ebp)
  803058:	ff 75 f0             	pushl  -0x10(%ebp)
  80305b:	ff 75 f4             	pushl  -0xc(%ebp)
  80305e:	e8 53 fb ff ff       	call   802bb6 <merging>
  803063:	83 c4 10             	add    $0x10,%esp
			break;
  803066:	90                   	nop
		}
	}
}
  803067:	eb 2e                	jmp    803097 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803069:	a1 34 50 80 00       	mov    0x805034,%eax
  80306e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803071:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803075:	74 07                	je     80307e <free_block+0xa5>
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	eb 05                	jmp    803083 <free_block+0xaa>
  80307e:	b8 00 00 00 00       	mov    $0x0,%eax
  803083:	a3 34 50 80 00       	mov    %eax,0x805034
  803088:	a1 34 50 80 00       	mov    0x805034,%eax
  80308d:	85 c0                	test   %eax,%eax
  80308f:	75 a7                	jne    803038 <free_block+0x5f>
  803091:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803095:	75 a1                	jne    803038 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803097:	90                   	nop
  803098:	c9                   	leave  
  803099:	c3                   	ret    

0080309a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80309a:	55                   	push   %ebp
  80309b:	89 e5                	mov    %esp,%ebp
  80309d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8030a0:	ff 75 08             	pushl  0x8(%ebp)
  8030a3:	e8 ed ec ff ff       	call   801d95 <get_block_size>
  8030a8:	83 c4 04             	add    $0x4,%esp
  8030ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8030ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8030b5:	eb 17                	jmp    8030ce <copy_data+0x34>
  8030b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030bd:	01 c2                	add    %eax,%edx
  8030bf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	01 c8                	add    %ecx,%eax
  8030c7:	8a 00                	mov    (%eax),%al
  8030c9:	88 02                	mov    %al,(%edx)
  8030cb:	ff 45 fc             	incl   -0x4(%ebp)
  8030ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8030d4:	72 e1                	jb     8030b7 <copy_data+0x1d>
}
  8030d6:	90                   	nop
  8030d7:	c9                   	leave  
  8030d8:	c3                   	ret    

008030d9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8030d9:	55                   	push   %ebp
  8030da:	89 e5                	mov    %esp,%ebp
  8030dc:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8030df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e3:	75 23                	jne    803108 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8030e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030e9:	74 13                	je     8030fe <realloc_block_FF+0x25>
  8030eb:	83 ec 0c             	sub    $0xc,%esp
  8030ee:	ff 75 0c             	pushl  0xc(%ebp)
  8030f1:	e8 1f f0 ff ff       	call   802115 <alloc_block_FF>
  8030f6:	83 c4 10             	add    $0x10,%esp
  8030f9:	e9 f4 06 00 00       	jmp    8037f2 <realloc_block_FF+0x719>
		return NULL;
  8030fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803103:	e9 ea 06 00 00       	jmp    8037f2 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803108:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80310c:	75 18                	jne    803126 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80310e:	83 ec 0c             	sub    $0xc,%esp
  803111:	ff 75 08             	pushl  0x8(%ebp)
  803114:	e8 c0 fe ff ff       	call   802fd9 <free_block>
  803119:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80311c:	b8 00 00 00 00       	mov    $0x0,%eax
  803121:	e9 cc 06 00 00       	jmp    8037f2 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803126:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80312a:	77 07                	ja     803133 <realloc_block_FF+0x5a>
  80312c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803133:	8b 45 0c             	mov    0xc(%ebp),%eax
  803136:	83 e0 01             	and    $0x1,%eax
  803139:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80313c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313f:	83 c0 08             	add    $0x8,%eax
  803142:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803145:	83 ec 0c             	sub    $0xc,%esp
  803148:	ff 75 08             	pushl  0x8(%ebp)
  80314b:	e8 45 ec ff ff       	call   801d95 <get_block_size>
  803150:	83 c4 10             	add    $0x10,%esp
  803153:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803159:	83 e8 08             	sub    $0x8,%eax
  80315c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	83 e8 04             	sub    $0x4,%eax
  803165:	8b 00                	mov    (%eax),%eax
  803167:	83 e0 fe             	and    $0xfffffffe,%eax
  80316a:	89 c2                	mov    %eax,%edx
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	01 d0                	add    %edx,%eax
  803171:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803174:	83 ec 0c             	sub    $0xc,%esp
  803177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80317a:	e8 16 ec ff ff       	call   801d95 <get_block_size>
  80317f:	83 c4 10             	add    $0x10,%esp
  803182:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803188:	83 e8 08             	sub    $0x8,%eax
  80318b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80318e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803191:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803194:	75 08                	jne    80319e <realloc_block_FF+0xc5>
	{
		 return va;
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	e9 54 06 00 00       	jmp    8037f2 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80319e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031a4:	0f 83 e5 03 00 00    	jae    80358f <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8031b3:	83 ec 0c             	sub    $0xc,%esp
  8031b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031b9:	e8 f0 eb ff ff       	call   801dae <is_free_block>
  8031be:	83 c4 10             	add    $0x10,%esp
  8031c1:	84 c0                	test   %al,%al
  8031c3:	0f 84 3b 01 00 00    	je     803304 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8031c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031cf:	01 d0                	add    %edx,%eax
  8031d1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8031d4:	83 ec 04             	sub    $0x4,%esp
  8031d7:	6a 01                	push   $0x1
  8031d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8031dc:	ff 75 08             	pushl  0x8(%ebp)
  8031df:	e8 02 ef ff ff       	call   8020e6 <set_block_data>
  8031e4:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	83 e8 04             	sub    $0x4,%eax
  8031ed:	8b 00                	mov    (%eax),%eax
  8031ef:	83 e0 fe             	and    $0xfffffffe,%eax
  8031f2:	89 c2                	mov    %eax,%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	01 d0                	add    %edx,%eax
  8031f9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8031fc:	83 ec 04             	sub    $0x4,%esp
  8031ff:	6a 00                	push   $0x0
  803201:	ff 75 cc             	pushl  -0x34(%ebp)
  803204:	ff 75 c8             	pushl  -0x38(%ebp)
  803207:	e8 da ee ff ff       	call   8020e6 <set_block_data>
  80320c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80320f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803213:	74 06                	je     80321b <realloc_block_FF+0x142>
  803215:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803219:	75 17                	jne    803232 <realloc_block_FF+0x159>
  80321b:	83 ec 04             	sub    $0x4,%esp
  80321e:	68 1c 43 80 00       	push   $0x80431c
  803223:	68 f6 01 00 00       	push   $0x1f6
  803228:	68 a9 42 80 00       	push   $0x8042a9
  80322d:	e8 0b d0 ff ff       	call   80023d <_panic>
  803232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803235:	8b 10                	mov    (%eax),%edx
  803237:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80323a:	89 10                	mov    %edx,(%eax)
  80323c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80323f:	8b 00                	mov    (%eax),%eax
  803241:	85 c0                	test   %eax,%eax
  803243:	74 0b                	je     803250 <realloc_block_FF+0x177>
  803245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803248:	8b 00                	mov    (%eax),%eax
  80324a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80324d:	89 50 04             	mov    %edx,0x4(%eax)
  803250:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803253:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803256:	89 10                	mov    %edx,(%eax)
  803258:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80325b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803264:	8b 00                	mov    (%eax),%eax
  803266:	85 c0                	test   %eax,%eax
  803268:	75 08                	jne    803272 <realloc_block_FF+0x199>
  80326a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80326d:	a3 30 50 80 00       	mov    %eax,0x805030
  803272:	a1 38 50 80 00       	mov    0x805038,%eax
  803277:	40                   	inc    %eax
  803278:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80327d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803281:	75 17                	jne    80329a <realloc_block_FF+0x1c1>
  803283:	83 ec 04             	sub    $0x4,%esp
  803286:	68 8b 42 80 00       	push   $0x80428b
  80328b:	68 f7 01 00 00       	push   $0x1f7
  803290:	68 a9 42 80 00       	push   $0x8042a9
  803295:	e8 a3 cf ff ff       	call   80023d <_panic>
  80329a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329d:	8b 00                	mov    (%eax),%eax
  80329f:	85 c0                	test   %eax,%eax
  8032a1:	74 10                	je     8032b3 <realloc_block_FF+0x1da>
  8032a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a6:	8b 00                	mov    (%eax),%eax
  8032a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032ab:	8b 52 04             	mov    0x4(%edx),%edx
  8032ae:	89 50 04             	mov    %edx,0x4(%eax)
  8032b1:	eb 0b                	jmp    8032be <realloc_block_FF+0x1e5>
  8032b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b6:	8b 40 04             	mov    0x4(%eax),%eax
  8032b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8032be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c1:	8b 40 04             	mov    0x4(%eax),%eax
  8032c4:	85 c0                	test   %eax,%eax
  8032c6:	74 0f                	je     8032d7 <realloc_block_FF+0x1fe>
  8032c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032d1:	8b 12                	mov    (%edx),%edx
  8032d3:	89 10                	mov    %edx,(%eax)
  8032d5:	eb 0a                	jmp    8032e1 <realloc_block_FF+0x208>
  8032d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032da:	8b 00                	mov    (%eax),%eax
  8032dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8032f9:	48                   	dec    %eax
  8032fa:	a3 38 50 80 00       	mov    %eax,0x805038
  8032ff:	e9 83 02 00 00       	jmp    803587 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803304:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803308:	0f 86 69 02 00 00    	jbe    803577 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80330e:	83 ec 04             	sub    $0x4,%esp
  803311:	6a 01                	push   $0x1
  803313:	ff 75 f0             	pushl  -0x10(%ebp)
  803316:	ff 75 08             	pushl  0x8(%ebp)
  803319:	e8 c8 ed ff ff       	call   8020e6 <set_block_data>
  80331e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803321:	8b 45 08             	mov    0x8(%ebp),%eax
  803324:	83 e8 04             	sub    $0x4,%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	83 e0 fe             	and    $0xfffffffe,%eax
  80332c:	89 c2                	mov    %eax,%edx
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	01 d0                	add    %edx,%eax
  803333:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803336:	a1 38 50 80 00       	mov    0x805038,%eax
  80333b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80333e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803342:	75 68                	jne    8033ac <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803344:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803348:	75 17                	jne    803361 <realloc_block_FF+0x288>
  80334a:	83 ec 04             	sub    $0x4,%esp
  80334d:	68 c4 42 80 00       	push   $0x8042c4
  803352:	68 06 02 00 00       	push   $0x206
  803357:	68 a9 42 80 00       	push   $0x8042a9
  80335c:	e8 dc ce ff ff       	call   80023d <_panic>
  803361:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803367:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336a:	89 10                	mov    %edx,(%eax)
  80336c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336f:	8b 00                	mov    (%eax),%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	74 0d                	je     803382 <realloc_block_FF+0x2a9>
  803375:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80337a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80337d:	89 50 04             	mov    %edx,0x4(%eax)
  803380:	eb 08                	jmp    80338a <realloc_block_FF+0x2b1>
  803382:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803385:	a3 30 50 80 00       	mov    %eax,0x805030
  80338a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80338d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803392:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803395:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339c:	a1 38 50 80 00       	mov    0x805038,%eax
  8033a1:	40                   	inc    %eax
  8033a2:	a3 38 50 80 00       	mov    %eax,0x805038
  8033a7:	e9 b0 01 00 00       	jmp    80355c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8033ac:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033b1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033b4:	76 68                	jbe    80341e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033b6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033ba:	75 17                	jne    8033d3 <realloc_block_FF+0x2fa>
  8033bc:	83 ec 04             	sub    $0x4,%esp
  8033bf:	68 c4 42 80 00       	push   $0x8042c4
  8033c4:	68 0b 02 00 00       	push   $0x20b
  8033c9:	68 a9 42 80 00       	push   $0x8042a9
  8033ce:	e8 6a ce ff ff       	call   80023d <_panic>
  8033d3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033dc:	89 10                	mov    %edx,(%eax)
  8033de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e1:	8b 00                	mov    (%eax),%eax
  8033e3:	85 c0                	test   %eax,%eax
  8033e5:	74 0d                	je     8033f4 <realloc_block_FF+0x31b>
  8033e7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033ef:	89 50 04             	mov    %edx,0x4(%eax)
  8033f2:	eb 08                	jmp    8033fc <realloc_block_FF+0x323>
  8033f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f7:	a3 30 50 80 00       	mov    %eax,0x805030
  8033fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ff:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803404:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803407:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340e:	a1 38 50 80 00       	mov    0x805038,%eax
  803413:	40                   	inc    %eax
  803414:	a3 38 50 80 00       	mov    %eax,0x805038
  803419:	e9 3e 01 00 00       	jmp    80355c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80341e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803423:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803426:	73 68                	jae    803490 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803428:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80342c:	75 17                	jne    803445 <realloc_block_FF+0x36c>
  80342e:	83 ec 04             	sub    $0x4,%esp
  803431:	68 f8 42 80 00       	push   $0x8042f8
  803436:	68 10 02 00 00       	push   $0x210
  80343b:	68 a9 42 80 00       	push   $0x8042a9
  803440:	e8 f8 cd ff ff       	call   80023d <_panic>
  803445:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80344b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344e:	89 50 04             	mov    %edx,0x4(%eax)
  803451:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803454:	8b 40 04             	mov    0x4(%eax),%eax
  803457:	85 c0                	test   %eax,%eax
  803459:	74 0c                	je     803467 <realloc_block_FF+0x38e>
  80345b:	a1 30 50 80 00       	mov    0x805030,%eax
  803460:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803463:	89 10                	mov    %edx,(%eax)
  803465:	eb 08                	jmp    80346f <realloc_block_FF+0x396>
  803467:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80346f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803472:	a3 30 50 80 00       	mov    %eax,0x805030
  803477:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803480:	a1 38 50 80 00       	mov    0x805038,%eax
  803485:	40                   	inc    %eax
  803486:	a3 38 50 80 00       	mov    %eax,0x805038
  80348b:	e9 cc 00 00 00       	jmp    80355c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803490:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803497:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80349c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80349f:	e9 8a 00 00 00       	jmp    80352e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034aa:	73 7a                	jae    803526 <realloc_block_FF+0x44d>
  8034ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034b4:	73 70                	jae    803526 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8034b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ba:	74 06                	je     8034c2 <realloc_block_FF+0x3e9>
  8034bc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034c0:	75 17                	jne    8034d9 <realloc_block_FF+0x400>
  8034c2:	83 ec 04             	sub    $0x4,%esp
  8034c5:	68 1c 43 80 00       	push   $0x80431c
  8034ca:	68 1a 02 00 00       	push   $0x21a
  8034cf:	68 a9 42 80 00       	push   $0x8042a9
  8034d4:	e8 64 cd ff ff       	call   80023d <_panic>
  8034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dc:	8b 10                	mov    (%eax),%edx
  8034de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e1:	89 10                	mov    %edx,(%eax)
  8034e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e6:	8b 00                	mov    (%eax),%eax
  8034e8:	85 c0                	test   %eax,%eax
  8034ea:	74 0b                	je     8034f7 <realloc_block_FF+0x41e>
  8034ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ef:	8b 00                	mov    (%eax),%eax
  8034f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034f4:	89 50 04             	mov    %edx,0x4(%eax)
  8034f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034fd:	89 10                	mov    %edx,(%eax)
  8034ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803502:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803505:	89 50 04             	mov    %edx,0x4(%eax)
  803508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350b:	8b 00                	mov    (%eax),%eax
  80350d:	85 c0                	test   %eax,%eax
  80350f:	75 08                	jne    803519 <realloc_block_FF+0x440>
  803511:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803514:	a3 30 50 80 00       	mov    %eax,0x805030
  803519:	a1 38 50 80 00       	mov    0x805038,%eax
  80351e:	40                   	inc    %eax
  80351f:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803524:	eb 36                	jmp    80355c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803526:	a1 34 50 80 00       	mov    0x805034,%eax
  80352b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80352e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803532:	74 07                	je     80353b <realloc_block_FF+0x462>
  803534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	eb 05                	jmp    803540 <realloc_block_FF+0x467>
  80353b:	b8 00 00 00 00       	mov    $0x0,%eax
  803540:	a3 34 50 80 00       	mov    %eax,0x805034
  803545:	a1 34 50 80 00       	mov    0x805034,%eax
  80354a:	85 c0                	test   %eax,%eax
  80354c:	0f 85 52 ff ff ff    	jne    8034a4 <realloc_block_FF+0x3cb>
  803552:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803556:	0f 85 48 ff ff ff    	jne    8034a4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80355c:	83 ec 04             	sub    $0x4,%esp
  80355f:	6a 00                	push   $0x0
  803561:	ff 75 d8             	pushl  -0x28(%ebp)
  803564:	ff 75 d4             	pushl  -0x2c(%ebp)
  803567:	e8 7a eb ff ff       	call   8020e6 <set_block_data>
  80356c:	83 c4 10             	add    $0x10,%esp
				return va;
  80356f:	8b 45 08             	mov    0x8(%ebp),%eax
  803572:	e9 7b 02 00 00       	jmp    8037f2 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803577:	83 ec 0c             	sub    $0xc,%esp
  80357a:	68 99 43 80 00       	push   $0x804399
  80357f:	e8 76 cf ff ff       	call   8004fa <cprintf>
  803584:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	e9 63 02 00 00       	jmp    8037f2 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80358f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803592:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803595:	0f 86 4d 02 00 00    	jbe    8037e8 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80359b:	83 ec 0c             	sub    $0xc,%esp
  80359e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035a1:	e8 08 e8 ff ff       	call   801dae <is_free_block>
  8035a6:	83 c4 10             	add    $0x10,%esp
  8035a9:	84 c0                	test   %al,%al
  8035ab:	0f 84 37 02 00 00    	je     8037e8 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8035b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8035b7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8035ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035bd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035c0:	76 38                	jbe    8035fa <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8035c2:	83 ec 0c             	sub    $0xc,%esp
  8035c5:	ff 75 08             	pushl  0x8(%ebp)
  8035c8:	e8 0c fa ff ff       	call   802fd9 <free_block>
  8035cd:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8035d0:	83 ec 0c             	sub    $0xc,%esp
  8035d3:	ff 75 0c             	pushl  0xc(%ebp)
  8035d6:	e8 3a eb ff ff       	call   802115 <alloc_block_FF>
  8035db:	83 c4 10             	add    $0x10,%esp
  8035de:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8035e1:	83 ec 08             	sub    $0x8,%esp
  8035e4:	ff 75 c0             	pushl  -0x40(%ebp)
  8035e7:	ff 75 08             	pushl  0x8(%ebp)
  8035ea:	e8 ab fa ff ff       	call   80309a <copy_data>
  8035ef:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8035f2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035f5:	e9 f8 01 00 00       	jmp    8037f2 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8035fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035fd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803600:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803603:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803607:	0f 87 a0 00 00 00    	ja     8036ad <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80360d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803611:	75 17                	jne    80362a <realloc_block_FF+0x551>
  803613:	83 ec 04             	sub    $0x4,%esp
  803616:	68 8b 42 80 00       	push   $0x80428b
  80361b:	68 38 02 00 00       	push   $0x238
  803620:	68 a9 42 80 00       	push   $0x8042a9
  803625:	e8 13 cc ff ff       	call   80023d <_panic>
  80362a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362d:	8b 00                	mov    (%eax),%eax
  80362f:	85 c0                	test   %eax,%eax
  803631:	74 10                	je     803643 <realloc_block_FF+0x56a>
  803633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803636:	8b 00                	mov    (%eax),%eax
  803638:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80363b:	8b 52 04             	mov    0x4(%edx),%edx
  80363e:	89 50 04             	mov    %edx,0x4(%eax)
  803641:	eb 0b                	jmp    80364e <realloc_block_FF+0x575>
  803643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803646:	8b 40 04             	mov    0x4(%eax),%eax
  803649:	a3 30 50 80 00       	mov    %eax,0x805030
  80364e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803651:	8b 40 04             	mov    0x4(%eax),%eax
  803654:	85 c0                	test   %eax,%eax
  803656:	74 0f                	je     803667 <realloc_block_FF+0x58e>
  803658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365b:	8b 40 04             	mov    0x4(%eax),%eax
  80365e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803661:	8b 12                	mov    (%edx),%edx
  803663:	89 10                	mov    %edx,(%eax)
  803665:	eb 0a                	jmp    803671 <realloc_block_FF+0x598>
  803667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366a:	8b 00                	mov    (%eax),%eax
  80366c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803674:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80367a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803684:	a1 38 50 80 00       	mov    0x805038,%eax
  803689:	48                   	dec    %eax
  80368a:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80368f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803695:	01 d0                	add    %edx,%eax
  803697:	83 ec 04             	sub    $0x4,%esp
  80369a:	6a 01                	push   $0x1
  80369c:	50                   	push   %eax
  80369d:	ff 75 08             	pushl  0x8(%ebp)
  8036a0:	e8 41 ea ff ff       	call   8020e6 <set_block_data>
  8036a5:	83 c4 10             	add    $0x10,%esp
  8036a8:	e9 36 01 00 00       	jmp    8037e3 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8036ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036b0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036b3:	01 d0                	add    %edx,%eax
  8036b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8036b8:	83 ec 04             	sub    $0x4,%esp
  8036bb:	6a 01                	push   $0x1
  8036bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8036c0:	ff 75 08             	pushl  0x8(%ebp)
  8036c3:	e8 1e ea ff ff       	call   8020e6 <set_block_data>
  8036c8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ce:	83 e8 04             	sub    $0x4,%eax
  8036d1:	8b 00                	mov    (%eax),%eax
  8036d3:	83 e0 fe             	and    $0xfffffffe,%eax
  8036d6:	89 c2                	mov    %eax,%edx
  8036d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036db:	01 d0                	add    %edx,%eax
  8036dd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036e4:	74 06                	je     8036ec <realloc_block_FF+0x613>
  8036e6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8036ea:	75 17                	jne    803703 <realloc_block_FF+0x62a>
  8036ec:	83 ec 04             	sub    $0x4,%esp
  8036ef:	68 1c 43 80 00       	push   $0x80431c
  8036f4:	68 44 02 00 00       	push   $0x244
  8036f9:	68 a9 42 80 00       	push   $0x8042a9
  8036fe:	e8 3a cb ff ff       	call   80023d <_panic>
  803703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803706:	8b 10                	mov    (%eax),%edx
  803708:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80370b:	89 10                	mov    %edx,(%eax)
  80370d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803710:	8b 00                	mov    (%eax),%eax
  803712:	85 c0                	test   %eax,%eax
  803714:	74 0b                	je     803721 <realloc_block_FF+0x648>
  803716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803719:	8b 00                	mov    (%eax),%eax
  80371b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80371e:	89 50 04             	mov    %edx,0x4(%eax)
  803721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803724:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803727:	89 10                	mov    %edx,(%eax)
  803729:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80372c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80372f:	89 50 04             	mov    %edx,0x4(%eax)
  803732:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803735:	8b 00                	mov    (%eax),%eax
  803737:	85 c0                	test   %eax,%eax
  803739:	75 08                	jne    803743 <realloc_block_FF+0x66a>
  80373b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80373e:	a3 30 50 80 00       	mov    %eax,0x805030
  803743:	a1 38 50 80 00       	mov    0x805038,%eax
  803748:	40                   	inc    %eax
  803749:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80374e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803752:	75 17                	jne    80376b <realloc_block_FF+0x692>
  803754:	83 ec 04             	sub    $0x4,%esp
  803757:	68 8b 42 80 00       	push   $0x80428b
  80375c:	68 45 02 00 00       	push   $0x245
  803761:	68 a9 42 80 00       	push   $0x8042a9
  803766:	e8 d2 ca ff ff       	call   80023d <_panic>
  80376b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376e:	8b 00                	mov    (%eax),%eax
  803770:	85 c0                	test   %eax,%eax
  803772:	74 10                	je     803784 <realloc_block_FF+0x6ab>
  803774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803777:	8b 00                	mov    (%eax),%eax
  803779:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80377c:	8b 52 04             	mov    0x4(%edx),%edx
  80377f:	89 50 04             	mov    %edx,0x4(%eax)
  803782:	eb 0b                	jmp    80378f <realloc_block_FF+0x6b6>
  803784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803787:	8b 40 04             	mov    0x4(%eax),%eax
  80378a:	a3 30 50 80 00       	mov    %eax,0x805030
  80378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803792:	8b 40 04             	mov    0x4(%eax),%eax
  803795:	85 c0                	test   %eax,%eax
  803797:	74 0f                	je     8037a8 <realloc_block_FF+0x6cf>
  803799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379c:	8b 40 04             	mov    0x4(%eax),%eax
  80379f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a2:	8b 12                	mov    (%edx),%edx
  8037a4:	89 10                	mov    %edx,(%eax)
  8037a6:	eb 0a                	jmp    8037b2 <realloc_block_FF+0x6d9>
  8037a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ab:	8b 00                	mov    (%eax),%eax
  8037ad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ca:	48                   	dec    %eax
  8037cb:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8037d0:	83 ec 04             	sub    $0x4,%esp
  8037d3:	6a 00                	push   $0x0
  8037d5:	ff 75 bc             	pushl  -0x44(%ebp)
  8037d8:	ff 75 b8             	pushl  -0x48(%ebp)
  8037db:	e8 06 e9 ff ff       	call   8020e6 <set_block_data>
  8037e0:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	eb 0a                	jmp    8037f2 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8037e8:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8037ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8037f2:	c9                   	leave  
  8037f3:	c3                   	ret    

008037f4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8037f4:	55                   	push   %ebp
  8037f5:	89 e5                	mov    %esp,%ebp
  8037f7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8037fa:	83 ec 04             	sub    $0x4,%esp
  8037fd:	68 a0 43 80 00       	push   $0x8043a0
  803802:	68 58 02 00 00       	push   $0x258
  803807:	68 a9 42 80 00       	push   $0x8042a9
  80380c:	e8 2c ca ff ff       	call   80023d <_panic>

00803811 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803811:	55                   	push   %ebp
  803812:	89 e5                	mov    %esp,%ebp
  803814:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803817:	83 ec 04             	sub    $0x4,%esp
  80381a:	68 c8 43 80 00       	push   $0x8043c8
  80381f:	68 61 02 00 00       	push   $0x261
  803824:	68 a9 42 80 00       	push   $0x8042a9
  803829:	e8 0f ca ff ff       	call   80023d <_panic>
  80382e:	66 90                	xchg   %ax,%ax

00803830 <__udivdi3>:
  803830:	55                   	push   %ebp
  803831:	57                   	push   %edi
  803832:	56                   	push   %esi
  803833:	53                   	push   %ebx
  803834:	83 ec 1c             	sub    $0x1c,%esp
  803837:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80383b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80383f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803843:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803847:	89 ca                	mov    %ecx,%edx
  803849:	89 f8                	mov    %edi,%eax
  80384b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80384f:	85 f6                	test   %esi,%esi
  803851:	75 2d                	jne    803880 <__udivdi3+0x50>
  803853:	39 cf                	cmp    %ecx,%edi
  803855:	77 65                	ja     8038bc <__udivdi3+0x8c>
  803857:	89 fd                	mov    %edi,%ebp
  803859:	85 ff                	test   %edi,%edi
  80385b:	75 0b                	jne    803868 <__udivdi3+0x38>
  80385d:	b8 01 00 00 00       	mov    $0x1,%eax
  803862:	31 d2                	xor    %edx,%edx
  803864:	f7 f7                	div    %edi
  803866:	89 c5                	mov    %eax,%ebp
  803868:	31 d2                	xor    %edx,%edx
  80386a:	89 c8                	mov    %ecx,%eax
  80386c:	f7 f5                	div    %ebp
  80386e:	89 c1                	mov    %eax,%ecx
  803870:	89 d8                	mov    %ebx,%eax
  803872:	f7 f5                	div    %ebp
  803874:	89 cf                	mov    %ecx,%edi
  803876:	89 fa                	mov    %edi,%edx
  803878:	83 c4 1c             	add    $0x1c,%esp
  80387b:	5b                   	pop    %ebx
  80387c:	5e                   	pop    %esi
  80387d:	5f                   	pop    %edi
  80387e:	5d                   	pop    %ebp
  80387f:	c3                   	ret    
  803880:	39 ce                	cmp    %ecx,%esi
  803882:	77 28                	ja     8038ac <__udivdi3+0x7c>
  803884:	0f bd fe             	bsr    %esi,%edi
  803887:	83 f7 1f             	xor    $0x1f,%edi
  80388a:	75 40                	jne    8038cc <__udivdi3+0x9c>
  80388c:	39 ce                	cmp    %ecx,%esi
  80388e:	72 0a                	jb     80389a <__udivdi3+0x6a>
  803890:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803894:	0f 87 9e 00 00 00    	ja     803938 <__udivdi3+0x108>
  80389a:	b8 01 00 00 00       	mov    $0x1,%eax
  80389f:	89 fa                	mov    %edi,%edx
  8038a1:	83 c4 1c             	add    $0x1c,%esp
  8038a4:	5b                   	pop    %ebx
  8038a5:	5e                   	pop    %esi
  8038a6:	5f                   	pop    %edi
  8038a7:	5d                   	pop    %ebp
  8038a8:	c3                   	ret    
  8038a9:	8d 76 00             	lea    0x0(%esi),%esi
  8038ac:	31 ff                	xor    %edi,%edi
  8038ae:	31 c0                	xor    %eax,%eax
  8038b0:	89 fa                	mov    %edi,%edx
  8038b2:	83 c4 1c             	add    $0x1c,%esp
  8038b5:	5b                   	pop    %ebx
  8038b6:	5e                   	pop    %esi
  8038b7:	5f                   	pop    %edi
  8038b8:	5d                   	pop    %ebp
  8038b9:	c3                   	ret    
  8038ba:	66 90                	xchg   %ax,%ax
  8038bc:	89 d8                	mov    %ebx,%eax
  8038be:	f7 f7                	div    %edi
  8038c0:	31 ff                	xor    %edi,%edi
  8038c2:	89 fa                	mov    %edi,%edx
  8038c4:	83 c4 1c             	add    $0x1c,%esp
  8038c7:	5b                   	pop    %ebx
  8038c8:	5e                   	pop    %esi
  8038c9:	5f                   	pop    %edi
  8038ca:	5d                   	pop    %ebp
  8038cb:	c3                   	ret    
  8038cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038d1:	89 eb                	mov    %ebp,%ebx
  8038d3:	29 fb                	sub    %edi,%ebx
  8038d5:	89 f9                	mov    %edi,%ecx
  8038d7:	d3 e6                	shl    %cl,%esi
  8038d9:	89 c5                	mov    %eax,%ebp
  8038db:	88 d9                	mov    %bl,%cl
  8038dd:	d3 ed                	shr    %cl,%ebp
  8038df:	89 e9                	mov    %ebp,%ecx
  8038e1:	09 f1                	or     %esi,%ecx
  8038e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038e7:	89 f9                	mov    %edi,%ecx
  8038e9:	d3 e0                	shl    %cl,%eax
  8038eb:	89 c5                	mov    %eax,%ebp
  8038ed:	89 d6                	mov    %edx,%esi
  8038ef:	88 d9                	mov    %bl,%cl
  8038f1:	d3 ee                	shr    %cl,%esi
  8038f3:	89 f9                	mov    %edi,%ecx
  8038f5:	d3 e2                	shl    %cl,%edx
  8038f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038fb:	88 d9                	mov    %bl,%cl
  8038fd:	d3 e8                	shr    %cl,%eax
  8038ff:	09 c2                	or     %eax,%edx
  803901:	89 d0                	mov    %edx,%eax
  803903:	89 f2                	mov    %esi,%edx
  803905:	f7 74 24 0c          	divl   0xc(%esp)
  803909:	89 d6                	mov    %edx,%esi
  80390b:	89 c3                	mov    %eax,%ebx
  80390d:	f7 e5                	mul    %ebp
  80390f:	39 d6                	cmp    %edx,%esi
  803911:	72 19                	jb     80392c <__udivdi3+0xfc>
  803913:	74 0b                	je     803920 <__udivdi3+0xf0>
  803915:	89 d8                	mov    %ebx,%eax
  803917:	31 ff                	xor    %edi,%edi
  803919:	e9 58 ff ff ff       	jmp    803876 <__udivdi3+0x46>
  80391e:	66 90                	xchg   %ax,%ax
  803920:	8b 54 24 08          	mov    0x8(%esp),%edx
  803924:	89 f9                	mov    %edi,%ecx
  803926:	d3 e2                	shl    %cl,%edx
  803928:	39 c2                	cmp    %eax,%edx
  80392a:	73 e9                	jae    803915 <__udivdi3+0xe5>
  80392c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80392f:	31 ff                	xor    %edi,%edi
  803931:	e9 40 ff ff ff       	jmp    803876 <__udivdi3+0x46>
  803936:	66 90                	xchg   %ax,%ax
  803938:	31 c0                	xor    %eax,%eax
  80393a:	e9 37 ff ff ff       	jmp    803876 <__udivdi3+0x46>
  80393f:	90                   	nop

00803940 <__umoddi3>:
  803940:	55                   	push   %ebp
  803941:	57                   	push   %edi
  803942:	56                   	push   %esi
  803943:	53                   	push   %ebx
  803944:	83 ec 1c             	sub    $0x1c,%esp
  803947:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80394b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80394f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803953:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803957:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80395b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80395f:	89 f3                	mov    %esi,%ebx
  803961:	89 fa                	mov    %edi,%edx
  803963:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803967:	89 34 24             	mov    %esi,(%esp)
  80396a:	85 c0                	test   %eax,%eax
  80396c:	75 1a                	jne    803988 <__umoddi3+0x48>
  80396e:	39 f7                	cmp    %esi,%edi
  803970:	0f 86 a2 00 00 00    	jbe    803a18 <__umoddi3+0xd8>
  803976:	89 c8                	mov    %ecx,%eax
  803978:	89 f2                	mov    %esi,%edx
  80397a:	f7 f7                	div    %edi
  80397c:	89 d0                	mov    %edx,%eax
  80397e:	31 d2                	xor    %edx,%edx
  803980:	83 c4 1c             	add    $0x1c,%esp
  803983:	5b                   	pop    %ebx
  803984:	5e                   	pop    %esi
  803985:	5f                   	pop    %edi
  803986:	5d                   	pop    %ebp
  803987:	c3                   	ret    
  803988:	39 f0                	cmp    %esi,%eax
  80398a:	0f 87 ac 00 00 00    	ja     803a3c <__umoddi3+0xfc>
  803990:	0f bd e8             	bsr    %eax,%ebp
  803993:	83 f5 1f             	xor    $0x1f,%ebp
  803996:	0f 84 ac 00 00 00    	je     803a48 <__umoddi3+0x108>
  80399c:	bf 20 00 00 00       	mov    $0x20,%edi
  8039a1:	29 ef                	sub    %ebp,%edi
  8039a3:	89 fe                	mov    %edi,%esi
  8039a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039a9:	89 e9                	mov    %ebp,%ecx
  8039ab:	d3 e0                	shl    %cl,%eax
  8039ad:	89 d7                	mov    %edx,%edi
  8039af:	89 f1                	mov    %esi,%ecx
  8039b1:	d3 ef                	shr    %cl,%edi
  8039b3:	09 c7                	or     %eax,%edi
  8039b5:	89 e9                	mov    %ebp,%ecx
  8039b7:	d3 e2                	shl    %cl,%edx
  8039b9:	89 14 24             	mov    %edx,(%esp)
  8039bc:	89 d8                	mov    %ebx,%eax
  8039be:	d3 e0                	shl    %cl,%eax
  8039c0:	89 c2                	mov    %eax,%edx
  8039c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039c6:	d3 e0                	shl    %cl,%eax
  8039c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039d0:	89 f1                	mov    %esi,%ecx
  8039d2:	d3 e8                	shr    %cl,%eax
  8039d4:	09 d0                	or     %edx,%eax
  8039d6:	d3 eb                	shr    %cl,%ebx
  8039d8:	89 da                	mov    %ebx,%edx
  8039da:	f7 f7                	div    %edi
  8039dc:	89 d3                	mov    %edx,%ebx
  8039de:	f7 24 24             	mull   (%esp)
  8039e1:	89 c6                	mov    %eax,%esi
  8039e3:	89 d1                	mov    %edx,%ecx
  8039e5:	39 d3                	cmp    %edx,%ebx
  8039e7:	0f 82 87 00 00 00    	jb     803a74 <__umoddi3+0x134>
  8039ed:	0f 84 91 00 00 00    	je     803a84 <__umoddi3+0x144>
  8039f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039f7:	29 f2                	sub    %esi,%edx
  8039f9:	19 cb                	sbb    %ecx,%ebx
  8039fb:	89 d8                	mov    %ebx,%eax
  8039fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a01:	d3 e0                	shl    %cl,%eax
  803a03:	89 e9                	mov    %ebp,%ecx
  803a05:	d3 ea                	shr    %cl,%edx
  803a07:	09 d0                	or     %edx,%eax
  803a09:	89 e9                	mov    %ebp,%ecx
  803a0b:	d3 eb                	shr    %cl,%ebx
  803a0d:	89 da                	mov    %ebx,%edx
  803a0f:	83 c4 1c             	add    $0x1c,%esp
  803a12:	5b                   	pop    %ebx
  803a13:	5e                   	pop    %esi
  803a14:	5f                   	pop    %edi
  803a15:	5d                   	pop    %ebp
  803a16:	c3                   	ret    
  803a17:	90                   	nop
  803a18:	89 fd                	mov    %edi,%ebp
  803a1a:	85 ff                	test   %edi,%edi
  803a1c:	75 0b                	jne    803a29 <__umoddi3+0xe9>
  803a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a23:	31 d2                	xor    %edx,%edx
  803a25:	f7 f7                	div    %edi
  803a27:	89 c5                	mov    %eax,%ebp
  803a29:	89 f0                	mov    %esi,%eax
  803a2b:	31 d2                	xor    %edx,%edx
  803a2d:	f7 f5                	div    %ebp
  803a2f:	89 c8                	mov    %ecx,%eax
  803a31:	f7 f5                	div    %ebp
  803a33:	89 d0                	mov    %edx,%eax
  803a35:	e9 44 ff ff ff       	jmp    80397e <__umoddi3+0x3e>
  803a3a:	66 90                	xchg   %ax,%ax
  803a3c:	89 c8                	mov    %ecx,%eax
  803a3e:	89 f2                	mov    %esi,%edx
  803a40:	83 c4 1c             	add    $0x1c,%esp
  803a43:	5b                   	pop    %ebx
  803a44:	5e                   	pop    %esi
  803a45:	5f                   	pop    %edi
  803a46:	5d                   	pop    %ebp
  803a47:	c3                   	ret    
  803a48:	3b 04 24             	cmp    (%esp),%eax
  803a4b:	72 06                	jb     803a53 <__umoddi3+0x113>
  803a4d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a51:	77 0f                	ja     803a62 <__umoddi3+0x122>
  803a53:	89 f2                	mov    %esi,%edx
  803a55:	29 f9                	sub    %edi,%ecx
  803a57:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a5b:	89 14 24             	mov    %edx,(%esp)
  803a5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a62:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a66:	8b 14 24             	mov    (%esp),%edx
  803a69:	83 c4 1c             	add    $0x1c,%esp
  803a6c:	5b                   	pop    %ebx
  803a6d:	5e                   	pop    %esi
  803a6e:	5f                   	pop    %edi
  803a6f:	5d                   	pop    %ebp
  803a70:	c3                   	ret    
  803a71:	8d 76 00             	lea    0x0(%esi),%esi
  803a74:	2b 04 24             	sub    (%esp),%eax
  803a77:	19 fa                	sbb    %edi,%edx
  803a79:	89 d1                	mov    %edx,%ecx
  803a7b:	89 c6                	mov    %eax,%esi
  803a7d:	e9 71 ff ff ff       	jmp    8039f3 <__umoddi3+0xb3>
  803a82:	66 90                	xchg   %ax,%ax
  803a84:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a88:	72 ea                	jb     803a74 <__umoddi3+0x134>
  803a8a:	89 d9                	mov    %ebx,%ecx
  803a8c:	e9 62 ff ff ff       	jmp    8039f3 <__umoddi3+0xb3>
