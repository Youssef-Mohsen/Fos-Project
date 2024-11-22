
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
  80005b:	68 40 3a 80 00       	push   $0x803a40
  800060:	6a 0c                	push   $0xc
  800062:	68 5c 3a 80 00       	push   $0x803a5c
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
  800073:	e8 8e 19 00 00       	call   801a06 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 77 3a 80 00       	push   $0x803a77
  800080:	50                   	push   %eax
  800081:	e8 d0 15 00 00       	call   801656 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80008c:	e8 93 17 00 00       	call   801824 <sys_calculate_free_frames>
  800091:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 7c 3a 80 00       	push   $0x803a7c
  80009c:	e8 59 04 00 00       	call   8004fa <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000aa:	e8 c4 15 00 00       	call   801673 <sfree>
  8000af:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave env removed x\n");
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 a0 3a 80 00       	push   $0x803aa0
  8000ba:	e8 3b 04 00 00       	call   8004fa <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp

	diff = (sys_calculate_free_frames() - freeFrames);
  8000c2:	e8 5d 17 00 00       	call   801824 <sys_calculate_free_frames>
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
  8000e5:	68 b8 3a 80 00       	push   $0x803ab8
  8000ea:	6a 23                	push   $0x23
  8000ec:	68 5c 3a 80 00       	push   $0x803a5c
  8000f1:	e8 47 01 00 00       	call   80023d <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  8000f6:	e8 30 1a 00 00       	call   801b2b <inctst>

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
  800104:	e8 e4 18 00 00       	call   8019ed <sys_getenvindex>
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
  800172:	e8 fa 15 00 00       	call   801771 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 5c 3b 80 00       	push   $0x803b5c
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
  8001a2:	68 84 3b 80 00       	push   $0x803b84
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
  8001d3:	68 ac 3b 80 00       	push   $0x803bac
  8001d8:	e8 1d 03 00 00       	call   8004fa <cprintf>
  8001dd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001e5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001eb:	83 ec 08             	sub    $0x8,%esp
  8001ee:	50                   	push   %eax
  8001ef:	68 04 3c 80 00       	push   $0x803c04
  8001f4:	e8 01 03 00 00       	call   8004fa <cprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	68 5c 3b 80 00       	push   $0x803b5c
  800204:	e8 f1 02 00 00       	call   8004fa <cprintf>
  800209:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80020c:	e8 7a 15 00 00       	call   80178b <sys_unlock_cons>
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
  800224:	e8 90 17 00 00       	call   8019b9 <sys_destroy_env>
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
  800235:	e8 e5 17 00 00       	call   801a1f <sys_exit_env>
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
  80025e:	68 18 3c 80 00       	push   $0x803c18
  800263:	e8 92 02 00 00       	call   8004fa <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80026b:	a1 00 50 80 00       	mov    0x805000,%eax
  800270:	ff 75 0c             	pushl  0xc(%ebp)
  800273:	ff 75 08             	pushl  0x8(%ebp)
  800276:	50                   	push   %eax
  800277:	68 1d 3c 80 00       	push   $0x803c1d
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
  80029b:	68 39 3c 80 00       	push   $0x803c39
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
  8002ca:	68 3c 3c 80 00       	push   $0x803c3c
  8002cf:	6a 26                	push   $0x26
  8002d1:	68 88 3c 80 00       	push   $0x803c88
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
  80039f:	68 94 3c 80 00       	push   $0x803c94
  8003a4:	6a 3a                	push   $0x3a
  8003a6:	68 88 3c 80 00       	push   $0x803c88
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
  800412:	68 e8 3c 80 00       	push   $0x803ce8
  800417:	6a 44                	push   $0x44
  800419:	68 88 3c 80 00       	push   $0x803c88
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
  80046c:	e8 be 12 00 00       	call   80172f <sys_cputs>
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
  8004e3:	e8 47 12 00 00       	call   80172f <sys_cputs>
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
  80052d:	e8 3f 12 00 00       	call   801771 <sys_lock_cons>
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
  80054d:	e8 39 12 00 00       	call   80178b <sys_unlock_cons>
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
  800597:	e8 2c 32 00 00       	call   8037c8 <__udivdi3>
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
  8005e7:	e8 ec 32 00 00       	call   8038d8 <__umoddi3>
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	05 54 3f 80 00       	add    $0x803f54,%eax
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
  800742:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
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
  800823:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  80082a:	85 f6                	test   %esi,%esi
  80082c:	75 19                	jne    800847 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80082e:	53                   	push   %ebx
  80082f:	68 65 3f 80 00       	push   $0x803f65
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
  800848:	68 6e 3f 80 00       	push   $0x803f6e
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
  800875:	be 71 3f 80 00       	mov    $0x803f71,%esi
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
  801280:	68 e8 40 80 00       	push   $0x8040e8
  801285:	68 3f 01 00 00       	push   $0x13f
  80128a:	68 0a 41 80 00       	push   $0x80410a
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
  8012a0:	e8 35 0a 00 00       	call   801cda <sys_sbrk>
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
  80131b:	e8 3e 08 00 00       	call   801b5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801320:	85 c0                	test   %eax,%eax
  801322:	74 16                	je     80133a <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801324:	83 ec 0c             	sub    $0xc,%esp
  801327:	ff 75 08             	pushl  0x8(%ebp)
  80132a:	e8 7e 0d 00 00       	call   8020ad <alloc_block_FF>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801335:	e9 8a 01 00 00       	jmp    8014c4 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80133a:	e8 50 08 00 00       	call   801b8f <sys_isUHeapPlacementStrategyBESTFIT>
  80133f:	85 c0                	test   %eax,%eax
  801341:	0f 84 7d 01 00 00    	je     8014c4 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801347:	83 ec 0c             	sub    $0xc,%esp
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	e8 17 12 00 00       	call   802569 <alloc_block_BF>
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
  8014b3:	e8 59 08 00 00       	call   801d11 <sys_allocate_user_mem>
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
  8014fb:	e8 2d 08 00 00       	call   801d2d <get_block_size>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801506:	83 ec 0c             	sub    $0xc,%esp
  801509:	ff 75 08             	pushl  0x8(%ebp)
  80150c:	e8 60 1a 00 00       	call   802f71 <free_block>
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
  8015a3:	e8 4d 07 00 00       	call   801cf5 <sys_free_user_mem>
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
  8015b1:	68 18 41 80 00       	push   $0x804118
  8015b6:	68 84 00 00 00       	push   $0x84
  8015bb:	68 42 41 80 00       	push   $0x804142
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
  801623:	e8 d4 02 00 00       	call   8018fc <sys_createSharedObject>
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
  801644:	68 4e 41 80 00       	push   $0x80414e
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
  801659:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	68 54 41 80 00       	push   $0x804154
  801664:	68 a4 00 00 00       	push   $0xa4
  801669:	68 42 41 80 00       	push   $0x804142
  80166e:	e8 ca eb ff ff       	call   80023d <_panic>

00801673 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801679:	83 ec 04             	sub    $0x4,%esp
  80167c:	68 78 41 80 00       	push   $0x804178
  801681:	68 bc 00 00 00       	push   $0xbc
  801686:	68 42 41 80 00       	push   $0x804142
  80168b:	e8 ad eb ff ff       	call   80023d <_panic>

00801690 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	68 9c 41 80 00       	push   $0x80419c
  80169e:	68 d3 00 00 00       	push   $0xd3
  8016a3:	68 42 41 80 00       	push   $0x804142
  8016a8:	e8 90 eb ff ff       	call   80023d <_panic>

008016ad <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016b3:	83 ec 04             	sub    $0x4,%esp
  8016b6:	68 c2 41 80 00       	push   $0x8041c2
  8016bb:	68 df 00 00 00       	push   $0xdf
  8016c0:	68 42 41 80 00       	push   $0x804142
  8016c5:	e8 73 eb ff ff       	call   80023d <_panic>

008016ca <shrink>:

}
void shrink(uint32 newSize)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d0:	83 ec 04             	sub    $0x4,%esp
  8016d3:	68 c2 41 80 00       	push   $0x8041c2
  8016d8:	68 e4 00 00 00       	push   $0xe4
  8016dd:	68 42 41 80 00       	push   $0x804142
  8016e2:	e8 56 eb ff ff       	call   80023d <_panic>

008016e7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ed:	83 ec 04             	sub    $0x4,%esp
  8016f0:	68 c2 41 80 00       	push   $0x8041c2
  8016f5:	68 e9 00 00 00       	push   $0xe9
  8016fa:	68 42 41 80 00       	push   $0x804142
  8016ff:	e8 39 eb ff ff       	call   80023d <_panic>

00801704 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	57                   	push   %edi
  801708:	56                   	push   %esi
  801709:	53                   	push   %ebx
  80170a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	8b 55 0c             	mov    0xc(%ebp),%edx
  801713:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801716:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801719:	8b 7d 18             	mov    0x18(%ebp),%edi
  80171c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80171f:	cd 30                	int    $0x30
  801721:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	5b                   	pop    %ebx
  80172b:	5e                   	pop    %esi
  80172c:	5f                   	pop    %edi
  80172d:	5d                   	pop    %ebp
  80172e:	c3                   	ret    

0080172f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 04             	sub    $0x4,%esp
  801735:	8b 45 10             	mov    0x10(%ebp),%eax
  801738:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80173b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	52                   	push   %edx
  801747:	ff 75 0c             	pushl  0xc(%ebp)
  80174a:	50                   	push   %eax
  80174b:	6a 00                	push   $0x0
  80174d:	e8 b2 ff ff ff       	call   801704 <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	90                   	nop
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_cgetc>:

int
sys_cgetc(void)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 02                	push   $0x2
  801767:	e8 98 ff ff ff       	call   801704 <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 03                	push   $0x3
  801780:	e8 7f ff ff ff       	call   801704 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	90                   	nop
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 04                	push   $0x4
  80179a:	e8 65 ff ff ff       	call   801704 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
}
  8017a2:	90                   	nop
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	52                   	push   %edx
  8017b5:	50                   	push   %eax
  8017b6:	6a 08                	push   $0x8
  8017b8:	e8 47 ff ff ff       	call   801704 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	56                   	push   %esi
  8017c6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017c7:	8b 75 18             	mov    0x18(%ebp),%esi
  8017ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	56                   	push   %esi
  8017d7:	53                   	push   %ebx
  8017d8:	51                   	push   %ecx
  8017d9:	52                   	push   %edx
  8017da:	50                   	push   %eax
  8017db:	6a 09                	push   $0x9
  8017dd:	e8 22 ff ff ff       	call   801704 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e8:	5b                   	pop    %ebx
  8017e9:	5e                   	pop    %esi
  8017ea:	5d                   	pop    %ebp
  8017eb:	c3                   	ret    

008017ec <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	52                   	push   %edx
  8017fc:	50                   	push   %eax
  8017fd:	6a 0a                	push   $0xa
  8017ff:	e8 00 ff ff ff       	call   801704 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	ff 75 08             	pushl  0x8(%ebp)
  801818:	6a 0b                	push   $0xb
  80181a:	e8 e5 fe ff ff       	call   801704 <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 0c                	push   $0xc
  801833:	e8 cc fe ff ff       	call   801704 <syscall>
  801838:	83 c4 18             	add    $0x18,%esp
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 0d                	push   $0xd
  80184c:	e8 b3 fe ff ff       	call   801704 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 0e                	push   $0xe
  801865:	e8 9a fe ff ff       	call   801704 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 0f                	push   $0xf
  80187e:	e8 81 fe ff ff       	call   801704 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	ff 75 08             	pushl  0x8(%ebp)
  801896:	6a 10                	push   $0x10
  801898:	e8 67 fe ff ff       	call   801704 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 11                	push   $0x11
  8018b1:	e8 4e fe ff ff       	call   801704 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	90                   	nop
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_cputc>:

void
sys_cputc(const char c)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018c8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	50                   	push   %eax
  8018d5:	6a 01                	push   $0x1
  8018d7:	e8 28 fe ff ff       	call   801704 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	90                   	nop
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 14                	push   $0x14
  8018f1:	e8 0e fe ff ff       	call   801704 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	90                   	nop
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	8b 45 10             	mov    0x10(%ebp),%eax
  801905:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801908:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80190b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	6a 00                	push   $0x0
  801914:	51                   	push   %ecx
  801915:	52                   	push   %edx
  801916:	ff 75 0c             	pushl  0xc(%ebp)
  801919:	50                   	push   %eax
  80191a:	6a 15                	push   $0x15
  80191c:	e8 e3 fd ff ff       	call   801704 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801929:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	52                   	push   %edx
  801936:	50                   	push   %eax
  801937:	6a 16                	push   $0x16
  801939:	e8 c6 fd ff ff       	call   801704 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801946:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	51                   	push   %ecx
  801954:	52                   	push   %edx
  801955:	50                   	push   %eax
  801956:	6a 17                	push   $0x17
  801958:	e8 a7 fd ff ff       	call   801704 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801965:	8b 55 0c             	mov    0xc(%ebp),%edx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	52                   	push   %edx
  801972:	50                   	push   %eax
  801973:	6a 18                	push   $0x18
  801975:	e8 8a fd ff ff       	call   801704 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	ff 75 14             	pushl  0x14(%ebp)
  80198a:	ff 75 10             	pushl  0x10(%ebp)
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	50                   	push   %eax
  801991:	6a 19                	push   $0x19
  801993:	e8 6c fd ff ff       	call   801704 <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	50                   	push   %eax
  8019ac:	6a 1a                	push   $0x1a
  8019ae:	e8 51 fd ff ff       	call   801704 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	90                   	nop
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	50                   	push   %eax
  8019c8:	6a 1b                	push   $0x1b
  8019ca:	e8 35 fd ff ff       	call   801704 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 05                	push   $0x5
  8019e3:	e8 1c fd ff ff       	call   801704 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 06                	push   $0x6
  8019fc:	e8 03 fd ff ff       	call   801704 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 07                	push   $0x7
  801a15:	e8 ea fc ff ff       	call   801704 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_exit_env>:


void sys_exit_env(void)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 1c                	push   $0x1c
  801a2e:	e8 d1 fc ff ff       	call   801704 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	90                   	nop
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a3f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a42:	8d 50 04             	lea    0x4(%eax),%edx
  801a45:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	52                   	push   %edx
  801a4f:	50                   	push   %eax
  801a50:	6a 1d                	push   $0x1d
  801a52:	e8 ad fc ff ff       	call   801704 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
	return result;
  801a5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a63:	89 01                	mov    %eax,(%ecx)
  801a65:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	c9                   	leave  
  801a6c:	c2 04 00             	ret    $0x4

00801a6f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	ff 75 10             	pushl  0x10(%ebp)
  801a79:	ff 75 0c             	pushl  0xc(%ebp)
  801a7c:	ff 75 08             	pushl  0x8(%ebp)
  801a7f:	6a 13                	push   $0x13
  801a81:	e8 7e fc ff ff       	call   801704 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
	return ;
  801a89:	90                   	nop
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_rcr2>:
uint32 sys_rcr2()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 1e                	push   $0x1e
  801a9b:	e8 64 fc ff ff       	call   801704 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 04             	sub    $0x4,%esp
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ab1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	50                   	push   %eax
  801abe:	6a 1f                	push   $0x1f
  801ac0:	e8 3f fc ff ff       	call   801704 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <rsttst>:
void rsttst()
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 21                	push   $0x21
  801ada:	e8 25 fc ff ff       	call   801704 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae2:	90                   	nop
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 04             	sub    $0x4,%esp
  801aeb:	8b 45 14             	mov    0x14(%ebp),%eax
  801aee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801af1:	8b 55 18             	mov    0x18(%ebp),%edx
  801af4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801af8:	52                   	push   %edx
  801af9:	50                   	push   %eax
  801afa:	ff 75 10             	pushl  0x10(%ebp)
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	6a 20                	push   $0x20
  801b05:	e8 fa fb ff ff       	call   801704 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0d:	90                   	nop
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <chktst>:
void chktst(uint32 n)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	ff 75 08             	pushl  0x8(%ebp)
  801b1e:	6a 22                	push   $0x22
  801b20:	e8 df fb ff ff       	call   801704 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
	return ;
  801b28:	90                   	nop
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <inctst>:

void inctst()
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 23                	push   $0x23
  801b3a:	e8 c5 fb ff ff       	call   801704 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b42:	90                   	nop
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <gettst>:
uint32 gettst()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 24                	push   $0x24
  801b54:	e8 ab fb ff ff       	call   801704 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 25                	push   $0x25
  801b70:	e8 8f fb ff ff       	call   801704 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
  801b78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b7b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b7f:	75 07                	jne    801b88 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b81:	b8 01 00 00 00       	mov    $0x1,%eax
  801b86:	eb 05                	jmp    801b8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 25                	push   $0x25
  801ba1:	e8 5e fb ff ff       	call   801704 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
  801ba9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bac:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bb0:	75 07                	jne    801bb9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb7:	eb 05                	jmp    801bbe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 25                	push   $0x25
  801bd2:	e8 2d fb ff ff       	call   801704 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
  801bda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bdd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801be1:	75 07                	jne    801bea <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801be3:	b8 01 00 00 00       	mov    $0x1,%eax
  801be8:	eb 05                	jmp    801bef <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 25                	push   $0x25
  801c03:	e8 fc fa ff ff       	call   801704 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
  801c0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c0e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c12:	75 07                	jne    801c1b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c14:	b8 01 00 00 00       	mov    $0x1,%eax
  801c19:	eb 05                	jmp    801c20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	ff 75 08             	pushl  0x8(%ebp)
  801c30:	6a 26                	push   $0x26
  801c32:	e8 cd fa ff ff       	call   801704 <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3a:	90                   	nop
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c41:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	6a 00                	push   $0x0
  801c4f:	53                   	push   %ebx
  801c50:	51                   	push   %ecx
  801c51:	52                   	push   %edx
  801c52:	50                   	push   %eax
  801c53:	6a 27                	push   $0x27
  801c55:	e8 aa fa ff ff       	call   801704 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	52                   	push   %edx
  801c72:	50                   	push   %eax
  801c73:	6a 28                	push   $0x28
  801c75:	e8 8a fa ff ff       	call   801704 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c82:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	6a 00                	push   $0x0
  801c8d:	51                   	push   %ecx
  801c8e:	ff 75 10             	pushl  0x10(%ebp)
  801c91:	52                   	push   %edx
  801c92:	50                   	push   %eax
  801c93:	6a 29                	push   $0x29
  801c95:	e8 6a fa ff ff       	call   801704 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	ff 75 10             	pushl  0x10(%ebp)
  801ca9:	ff 75 0c             	pushl  0xc(%ebp)
  801cac:	ff 75 08             	pushl  0x8(%ebp)
  801caf:	6a 12                	push   $0x12
  801cb1:	e8 4e fa ff ff       	call   801704 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb9:	90                   	nop
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	52                   	push   %edx
  801ccc:	50                   	push   %eax
  801ccd:	6a 2a                	push   $0x2a
  801ccf:	e8 30 fa ff ff       	call   801704 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
	return;
  801cd7:	90                   	nop
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	50                   	push   %eax
  801ce9:	6a 2b                	push   $0x2b
  801ceb:	e8 14 fa ff ff       	call   801704 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	ff 75 0c             	pushl  0xc(%ebp)
  801d01:	ff 75 08             	pushl  0x8(%ebp)
  801d04:	6a 2c                	push   $0x2c
  801d06:	e8 f9 f9 ff ff       	call   801704 <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
	return;
  801d0e:	90                   	nop
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	ff 75 0c             	pushl  0xc(%ebp)
  801d1d:	ff 75 08             	pushl  0x8(%ebp)
  801d20:	6a 2d                	push   $0x2d
  801d22:	e8 dd f9 ff ff       	call   801704 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return;
  801d2a:	90                   	nop
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	83 e8 04             	sub    $0x4,%eax
  801d39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d3f:	8b 00                	mov    (%eax),%eax
  801d41:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	83 e8 04             	sub    $0x4,%eax
  801d52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d58:	8b 00                	mov    (%eax),%eax
  801d5a:	83 e0 01             	and    $0x1,%eax
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	0f 94 c0             	sete   %al
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801d6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d74:	83 f8 02             	cmp    $0x2,%eax
  801d77:	74 2b                	je     801da4 <alloc_block+0x40>
  801d79:	83 f8 02             	cmp    $0x2,%eax
  801d7c:	7f 07                	jg     801d85 <alloc_block+0x21>
  801d7e:	83 f8 01             	cmp    $0x1,%eax
  801d81:	74 0e                	je     801d91 <alloc_block+0x2d>
  801d83:	eb 58                	jmp    801ddd <alloc_block+0x79>
  801d85:	83 f8 03             	cmp    $0x3,%eax
  801d88:	74 2d                	je     801db7 <alloc_block+0x53>
  801d8a:	83 f8 04             	cmp    $0x4,%eax
  801d8d:	74 3b                	je     801dca <alloc_block+0x66>
  801d8f:	eb 4c                	jmp    801ddd <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801d91:	83 ec 0c             	sub    $0xc,%esp
  801d94:	ff 75 08             	pushl  0x8(%ebp)
  801d97:	e8 11 03 00 00       	call   8020ad <alloc_block_FF>
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801da2:	eb 4a                	jmp    801dee <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801da4:	83 ec 0c             	sub    $0xc,%esp
  801da7:	ff 75 08             	pushl  0x8(%ebp)
  801daa:	e8 fa 19 00 00       	call   8037a9 <alloc_block_NF>
  801daf:	83 c4 10             	add    $0x10,%esp
  801db2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801db5:	eb 37                	jmp    801dee <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801db7:	83 ec 0c             	sub    $0xc,%esp
  801dba:	ff 75 08             	pushl  0x8(%ebp)
  801dbd:	e8 a7 07 00 00       	call   802569 <alloc_block_BF>
  801dc2:	83 c4 10             	add    $0x10,%esp
  801dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dc8:	eb 24                	jmp    801dee <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801dca:	83 ec 0c             	sub    $0xc,%esp
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	e8 b7 19 00 00       	call   80378c <alloc_block_WF>
  801dd5:	83 c4 10             	add    $0x10,%esp
  801dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ddb:	eb 11                	jmp    801dee <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ddd:	83 ec 0c             	sub    $0xc,%esp
  801de0:	68 d4 41 80 00       	push   $0x8041d4
  801de5:	e8 10 e7 ff ff       	call   8004fa <cprintf>
  801dea:	83 c4 10             	add    $0x10,%esp
		break;
  801ded:	90                   	nop
	}
	return va;
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	53                   	push   %ebx
  801df7:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801dfa:	83 ec 0c             	sub    $0xc,%esp
  801dfd:	68 f4 41 80 00       	push   $0x8041f4
  801e02:	e8 f3 e6 ff ff       	call   8004fa <cprintf>
  801e07:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e0a:	83 ec 0c             	sub    $0xc,%esp
  801e0d:	68 1f 42 80 00       	push   $0x80421f
  801e12:	e8 e3 e6 ff ff       	call   8004fa <cprintf>
  801e17:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e20:	eb 37                	jmp    801e59 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e22:	83 ec 0c             	sub    $0xc,%esp
  801e25:	ff 75 f4             	pushl  -0xc(%ebp)
  801e28:	e8 19 ff ff ff       	call   801d46 <is_free_block>
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	0f be d8             	movsbl %al,%ebx
  801e33:	83 ec 0c             	sub    $0xc,%esp
  801e36:	ff 75 f4             	pushl  -0xc(%ebp)
  801e39:	e8 ef fe ff ff       	call   801d2d <get_block_size>
  801e3e:	83 c4 10             	add    $0x10,%esp
  801e41:	83 ec 04             	sub    $0x4,%esp
  801e44:	53                   	push   %ebx
  801e45:	50                   	push   %eax
  801e46:	68 37 42 80 00       	push   $0x804237
  801e4b:	e8 aa e6 ff ff       	call   8004fa <cprintf>
  801e50:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801e53:	8b 45 10             	mov    0x10(%ebp),%eax
  801e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5d:	74 07                	je     801e66 <print_blocks_list+0x73>
  801e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e62:	8b 00                	mov    (%eax),%eax
  801e64:	eb 05                	jmp    801e6b <print_blocks_list+0x78>
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6b:	89 45 10             	mov    %eax,0x10(%ebp)
  801e6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e71:	85 c0                	test   %eax,%eax
  801e73:	75 ad                	jne    801e22 <print_blocks_list+0x2f>
  801e75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e79:	75 a7                	jne    801e22 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801e7b:	83 ec 0c             	sub    $0xc,%esp
  801e7e:	68 f4 41 80 00       	push   $0x8041f4
  801e83:	e8 72 e6 ff ff       	call   8004fa <cprintf>
  801e88:	83 c4 10             	add    $0x10,%esp

}
  801e8b:	90                   	nop
  801e8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9a:	83 e0 01             	and    $0x1,%eax
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	74 03                	je     801ea4 <initialize_dynamic_allocator+0x13>
  801ea1:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801ea4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ea8:	0f 84 c7 01 00 00    	je     802075 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801eae:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801eb5:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebe:	01 d0                	add    %edx,%eax
  801ec0:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801ec5:	0f 87 ad 01 00 00    	ja     802078 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	0f 89 a5 01 00 00    	jns    80207b <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edc:	01 d0                	add    %edx,%eax
  801ede:	83 e8 04             	sub    $0x4,%eax
  801ee1:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801ee6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801eed:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef5:	e9 87 00 00 00       	jmp    801f81 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801efa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801efe:	75 14                	jne    801f14 <initialize_dynamic_allocator+0x83>
  801f00:	83 ec 04             	sub    $0x4,%esp
  801f03:	68 4f 42 80 00       	push   $0x80424f
  801f08:	6a 79                	push   $0x79
  801f0a:	68 6d 42 80 00       	push   $0x80426d
  801f0f:	e8 29 e3 ff ff       	call   80023d <_panic>
  801f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f17:	8b 00                	mov    (%eax),%eax
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	74 10                	je     801f2d <initialize_dynamic_allocator+0x9c>
  801f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f20:	8b 00                	mov    (%eax),%eax
  801f22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f25:	8b 52 04             	mov    0x4(%edx),%edx
  801f28:	89 50 04             	mov    %edx,0x4(%eax)
  801f2b:	eb 0b                	jmp    801f38 <initialize_dynamic_allocator+0xa7>
  801f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f30:	8b 40 04             	mov    0x4(%eax),%eax
  801f33:	a3 30 50 80 00       	mov    %eax,0x805030
  801f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3b:	8b 40 04             	mov    0x4(%eax),%eax
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	74 0f                	je     801f51 <initialize_dynamic_allocator+0xc0>
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 40 04             	mov    0x4(%eax),%eax
  801f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4b:	8b 12                	mov    (%edx),%edx
  801f4d:	89 10                	mov    %edx,(%eax)
  801f4f:	eb 0a                	jmp    801f5b <initialize_dynamic_allocator+0xca>
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	8b 00                	mov    (%eax),%eax
  801f56:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f6e:	a1 38 50 80 00       	mov    0x805038,%eax
  801f73:	48                   	dec    %eax
  801f74:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801f79:	a1 34 50 80 00       	mov    0x805034,%eax
  801f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f85:	74 07                	je     801f8e <initialize_dynamic_allocator+0xfd>
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	8b 00                	mov    (%eax),%eax
  801f8c:	eb 05                	jmp    801f93 <initialize_dynamic_allocator+0x102>
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f93:	a3 34 50 80 00       	mov    %eax,0x805034
  801f98:	a1 34 50 80 00       	mov    0x805034,%eax
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	0f 85 55 ff ff ff    	jne    801efa <initialize_dynamic_allocator+0x69>
  801fa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa9:	0f 85 4b ff ff ff    	jne    801efa <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801fbe:	a1 44 50 80 00       	mov    0x805044,%eax
  801fc3:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801fc8:	a1 40 50 80 00       	mov    0x805040,%eax
  801fcd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	83 c0 08             	add    $0x8,%eax
  801fd9:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	83 c0 04             	add    $0x4,%eax
  801fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe5:	83 ea 08             	sub    $0x8,%edx
  801fe8:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801fea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	01 d0                	add    %edx,%eax
  801ff2:	83 e8 08             	sub    $0x8,%eax
  801ff5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff8:	83 ea 08             	sub    $0x8,%edx
  801ffb:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802000:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802006:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802009:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802010:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802014:	75 17                	jne    80202d <initialize_dynamic_allocator+0x19c>
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	68 88 42 80 00       	push   $0x804288
  80201e:	68 90 00 00 00       	push   $0x90
  802023:	68 6d 42 80 00       	push   $0x80426d
  802028:	e8 10 e2 ff ff       	call   80023d <_panic>
  80202d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802033:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802036:	89 10                	mov    %edx,(%eax)
  802038:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203b:	8b 00                	mov    (%eax),%eax
  80203d:	85 c0                	test   %eax,%eax
  80203f:	74 0d                	je     80204e <initialize_dynamic_allocator+0x1bd>
  802041:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802046:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802049:	89 50 04             	mov    %edx,0x4(%eax)
  80204c:	eb 08                	jmp    802056 <initialize_dynamic_allocator+0x1c5>
  80204e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802051:	a3 30 50 80 00       	mov    %eax,0x805030
  802056:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802059:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80205e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802061:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802068:	a1 38 50 80 00       	mov    0x805038,%eax
  80206d:	40                   	inc    %eax
  80206e:	a3 38 50 80 00       	mov    %eax,0x805038
  802073:	eb 07                	jmp    80207c <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802075:	90                   	nop
  802076:	eb 04                	jmp    80207c <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802078:	90                   	nop
  802079:	eb 01                	jmp    80207c <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80207b:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802081:	8b 45 10             	mov    0x10(%ebp),%eax
  802084:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80208d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802090:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	83 e8 04             	sub    $0x4,%eax
  802098:	8b 00                	mov    (%eax),%eax
  80209a:	83 e0 fe             	and    $0xfffffffe,%eax
  80209d:	8d 50 f8             	lea    -0x8(%eax),%edx
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	01 c2                	add    %eax,%edx
  8020a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a8:	89 02                	mov    %eax,(%edx)
}
  8020aa:	90                   	nop
  8020ab:	5d                   	pop    %ebp
  8020ac:	c3                   	ret    

008020ad <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	83 e0 01             	and    $0x1,%eax
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	74 03                	je     8020c0 <alloc_block_FF+0x13>
  8020bd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8020c0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8020c4:	77 07                	ja     8020cd <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8020c6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8020cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	75 73                	jne    802149 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	83 c0 10             	add    $0x10,%eax
  8020dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8020df:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ec:	01 d0                	add    %edx,%eax
  8020ee:	48                   	dec    %eax
  8020ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8020fa:	f7 75 ec             	divl   -0x14(%ebp)
  8020fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802100:	29 d0                	sub    %edx,%eax
  802102:	c1 e8 0c             	shr    $0xc,%eax
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	50                   	push   %eax
  802109:	e8 86 f1 ff ff       	call   801294 <sbrk>
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802114:	83 ec 0c             	sub    $0xc,%esp
  802117:	6a 00                	push   $0x0
  802119:	e8 76 f1 ff ff       	call   801294 <sbrk>
  80211e:	83 c4 10             	add    $0x10,%esp
  802121:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802124:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802127:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80212a:	83 ec 08             	sub    $0x8,%esp
  80212d:	50                   	push   %eax
  80212e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802131:	e8 5b fd ff ff       	call   801e91 <initialize_dynamic_allocator>
  802136:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802139:	83 ec 0c             	sub    $0xc,%esp
  80213c:	68 ab 42 80 00       	push   $0x8042ab
  802141:	e8 b4 e3 ff ff       	call   8004fa <cprintf>
  802146:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802149:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214d:	75 0a                	jne    802159 <alloc_block_FF+0xac>
	        return NULL;
  80214f:	b8 00 00 00 00       	mov    $0x0,%eax
  802154:	e9 0e 04 00 00       	jmp    802567 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802159:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802160:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802165:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802168:	e9 f3 02 00 00       	jmp    802460 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802173:	83 ec 0c             	sub    $0xc,%esp
  802176:	ff 75 bc             	pushl  -0x44(%ebp)
  802179:	e8 af fb ff ff       	call   801d2d <get_block_size>
  80217e:	83 c4 10             	add    $0x10,%esp
  802181:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	83 c0 08             	add    $0x8,%eax
  80218a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80218d:	0f 87 c5 02 00 00    	ja     802458 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	83 c0 18             	add    $0x18,%eax
  802199:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80219c:	0f 87 19 02 00 00    	ja     8023bb <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8021a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021a5:	2b 45 08             	sub    0x8(%ebp),%eax
  8021a8:	83 e8 08             	sub    $0x8,%eax
  8021ab:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	8d 50 08             	lea    0x8(%eax),%edx
  8021b4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021b7:	01 d0                	add    %edx,%eax
  8021b9:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	83 c0 08             	add    $0x8,%eax
  8021c2:	83 ec 04             	sub    $0x4,%esp
  8021c5:	6a 01                	push   $0x1
  8021c7:	50                   	push   %eax
  8021c8:	ff 75 bc             	pushl  -0x44(%ebp)
  8021cb:	e8 ae fe ff ff       	call   80207e <set_block_data>
  8021d0:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	8b 40 04             	mov    0x4(%eax),%eax
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	75 68                	jne    802245 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8021dd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021e1:	75 17                	jne    8021fa <alloc_block_FF+0x14d>
  8021e3:	83 ec 04             	sub    $0x4,%esp
  8021e6:	68 88 42 80 00       	push   $0x804288
  8021eb:	68 d7 00 00 00       	push   $0xd7
  8021f0:	68 6d 42 80 00       	push   $0x80426d
  8021f5:	e8 43 e0 ff ff       	call   80023d <_panic>
  8021fa:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802200:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802203:	89 10                	mov    %edx,(%eax)
  802205:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802208:	8b 00                	mov    (%eax),%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	74 0d                	je     80221b <alloc_block_FF+0x16e>
  80220e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802213:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802216:	89 50 04             	mov    %edx,0x4(%eax)
  802219:	eb 08                	jmp    802223 <alloc_block_FF+0x176>
  80221b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80221e:	a3 30 50 80 00       	mov    %eax,0x805030
  802223:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802226:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80222b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80222e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802235:	a1 38 50 80 00       	mov    0x805038,%eax
  80223a:	40                   	inc    %eax
  80223b:	a3 38 50 80 00       	mov    %eax,0x805038
  802240:	e9 dc 00 00 00       	jmp    802321 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	75 65                	jne    8022b3 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80224e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802252:	75 17                	jne    80226b <alloc_block_FF+0x1be>
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	68 bc 42 80 00       	push   $0x8042bc
  80225c:	68 db 00 00 00       	push   $0xdb
  802261:	68 6d 42 80 00       	push   $0x80426d
  802266:	e8 d2 df ff ff       	call   80023d <_panic>
  80226b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802271:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802274:	89 50 04             	mov    %edx,0x4(%eax)
  802277:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80227a:	8b 40 04             	mov    0x4(%eax),%eax
  80227d:	85 c0                	test   %eax,%eax
  80227f:	74 0c                	je     80228d <alloc_block_FF+0x1e0>
  802281:	a1 30 50 80 00       	mov    0x805030,%eax
  802286:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802289:	89 10                	mov    %edx,(%eax)
  80228b:	eb 08                	jmp    802295 <alloc_block_FF+0x1e8>
  80228d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802290:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802295:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802298:	a3 30 50 80 00       	mov    %eax,0x805030
  80229d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8022ab:	40                   	inc    %eax
  8022ac:	a3 38 50 80 00       	mov    %eax,0x805038
  8022b1:	eb 6e                	jmp    802321 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8022b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b7:	74 06                	je     8022bf <alloc_block_FF+0x212>
  8022b9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022bd:	75 17                	jne    8022d6 <alloc_block_FF+0x229>
  8022bf:	83 ec 04             	sub    $0x4,%esp
  8022c2:	68 e0 42 80 00       	push   $0x8042e0
  8022c7:	68 df 00 00 00       	push   $0xdf
  8022cc:	68 6d 42 80 00       	push   $0x80426d
  8022d1:	e8 67 df ff ff       	call   80023d <_panic>
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	8b 10                	mov    (%eax),%edx
  8022db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022de:	89 10                	mov    %edx,(%eax)
  8022e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e3:	8b 00                	mov    (%eax),%eax
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	74 0b                	je     8022f4 <alloc_block_FF+0x247>
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 00                	mov    (%eax),%eax
  8022ee:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022f1:	89 50 04             	mov    %edx,0x4(%eax)
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022fa:	89 10                	mov    %edx,(%eax)
  8022fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802302:	89 50 04             	mov    %edx,0x4(%eax)
  802305:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802308:	8b 00                	mov    (%eax),%eax
  80230a:	85 c0                	test   %eax,%eax
  80230c:	75 08                	jne    802316 <alloc_block_FF+0x269>
  80230e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802311:	a3 30 50 80 00       	mov    %eax,0x805030
  802316:	a1 38 50 80 00       	mov    0x805038,%eax
  80231b:	40                   	inc    %eax
  80231c:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802321:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802325:	75 17                	jne    80233e <alloc_block_FF+0x291>
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	68 4f 42 80 00       	push   $0x80424f
  80232f:	68 e1 00 00 00       	push   $0xe1
  802334:	68 6d 42 80 00       	push   $0x80426d
  802339:	e8 ff de ff ff       	call   80023d <_panic>
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 00                	mov    (%eax),%eax
  802343:	85 c0                	test   %eax,%eax
  802345:	74 10                	je     802357 <alloc_block_FF+0x2aa>
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 00                	mov    (%eax),%eax
  80234c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234f:	8b 52 04             	mov    0x4(%edx),%edx
  802352:	89 50 04             	mov    %edx,0x4(%eax)
  802355:	eb 0b                	jmp    802362 <alloc_block_FF+0x2b5>
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	a3 30 50 80 00       	mov    %eax,0x805030
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 40 04             	mov    0x4(%eax),%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	74 0f                	je     80237b <alloc_block_FF+0x2ce>
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 40 04             	mov    0x4(%eax),%eax
  802372:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802375:	8b 12                	mov    (%edx),%edx
  802377:	89 10                	mov    %edx,(%eax)
  802379:	eb 0a                	jmp    802385 <alloc_block_FF+0x2d8>
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 00                	mov    (%eax),%eax
  802380:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802398:	a1 38 50 80 00       	mov    0x805038,%eax
  80239d:	48                   	dec    %eax
  80239e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8023a3:	83 ec 04             	sub    $0x4,%esp
  8023a6:	6a 00                	push   $0x0
  8023a8:	ff 75 b4             	pushl  -0x4c(%ebp)
  8023ab:	ff 75 b0             	pushl  -0x50(%ebp)
  8023ae:	e8 cb fc ff ff       	call   80207e <set_block_data>
  8023b3:	83 c4 10             	add    $0x10,%esp
  8023b6:	e9 95 00 00 00       	jmp    802450 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8023bb:	83 ec 04             	sub    $0x4,%esp
  8023be:	6a 01                	push   $0x1
  8023c0:	ff 75 b8             	pushl  -0x48(%ebp)
  8023c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8023c6:	e8 b3 fc ff ff       	call   80207e <set_block_data>
  8023cb:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8023ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d2:	75 17                	jne    8023eb <alloc_block_FF+0x33e>
  8023d4:	83 ec 04             	sub    $0x4,%esp
  8023d7:	68 4f 42 80 00       	push   $0x80424f
  8023dc:	68 e8 00 00 00       	push   $0xe8
  8023e1:	68 6d 42 80 00       	push   $0x80426d
  8023e6:	e8 52 de ff ff       	call   80023d <_panic>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	85 c0                	test   %eax,%eax
  8023f2:	74 10                	je     802404 <alloc_block_FF+0x357>
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023fc:	8b 52 04             	mov    0x4(%edx),%edx
  8023ff:	89 50 04             	mov    %edx,0x4(%eax)
  802402:	eb 0b                	jmp    80240f <alloc_block_FF+0x362>
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 40 04             	mov    0x4(%eax),%eax
  80240a:	a3 30 50 80 00       	mov    %eax,0x805030
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 40 04             	mov    0x4(%eax),%eax
  802415:	85 c0                	test   %eax,%eax
  802417:	74 0f                	je     802428 <alloc_block_FF+0x37b>
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 40 04             	mov    0x4(%eax),%eax
  80241f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802422:	8b 12                	mov    (%edx),%edx
  802424:	89 10                	mov    %edx,(%eax)
  802426:	eb 0a                	jmp    802432 <alloc_block_FF+0x385>
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	8b 00                	mov    (%eax),%eax
  80242d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802445:	a1 38 50 80 00       	mov    0x805038,%eax
  80244a:	48                   	dec    %eax
  80244b:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802450:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802453:	e9 0f 01 00 00       	jmp    802567 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802458:	a1 34 50 80 00       	mov    0x805034,%eax
  80245d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802460:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802464:	74 07                	je     80246d <alloc_block_FF+0x3c0>
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 00                	mov    (%eax),%eax
  80246b:	eb 05                	jmp    802472 <alloc_block_FF+0x3c5>
  80246d:	b8 00 00 00 00       	mov    $0x0,%eax
  802472:	a3 34 50 80 00       	mov    %eax,0x805034
  802477:	a1 34 50 80 00       	mov    0x805034,%eax
  80247c:	85 c0                	test   %eax,%eax
  80247e:	0f 85 e9 fc ff ff    	jne    80216d <alloc_block_FF+0xc0>
  802484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802488:	0f 85 df fc ff ff    	jne    80216d <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	83 c0 08             	add    $0x8,%eax
  802494:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802497:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80249e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024a4:	01 d0                	add    %edx,%eax
  8024a6:	48                   	dec    %eax
  8024a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8024aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b2:	f7 75 d8             	divl   -0x28(%ebp)
  8024b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024b8:	29 d0                	sub    %edx,%eax
  8024ba:	c1 e8 0c             	shr    $0xc,%eax
  8024bd:	83 ec 0c             	sub    $0xc,%esp
  8024c0:	50                   	push   %eax
  8024c1:	e8 ce ed ff ff       	call   801294 <sbrk>
  8024c6:	83 c4 10             	add    $0x10,%esp
  8024c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8024cc:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8024d0:	75 0a                	jne    8024dc <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8024d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d7:	e9 8b 00 00 00       	jmp    802567 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8024dc:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8024e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024e9:	01 d0                	add    %edx,%eax
  8024eb:	48                   	dec    %eax
  8024ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8024ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f7:	f7 75 cc             	divl   -0x34(%ebp)
  8024fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024fd:	29 d0                	sub    %edx,%eax
  8024ff:	8d 50 fc             	lea    -0x4(%eax),%edx
  802502:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802505:	01 d0                	add    %edx,%eax
  802507:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80250c:	a1 40 50 80 00       	mov    0x805040,%eax
  802511:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802517:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80251e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802521:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802524:	01 d0                	add    %edx,%eax
  802526:	48                   	dec    %eax
  802527:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80252a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80252d:	ba 00 00 00 00       	mov    $0x0,%edx
  802532:	f7 75 c4             	divl   -0x3c(%ebp)
  802535:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802538:	29 d0                	sub    %edx,%eax
  80253a:	83 ec 04             	sub    $0x4,%esp
  80253d:	6a 01                	push   $0x1
  80253f:	50                   	push   %eax
  802540:	ff 75 d0             	pushl  -0x30(%ebp)
  802543:	e8 36 fb ff ff       	call   80207e <set_block_data>
  802548:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80254b:	83 ec 0c             	sub    $0xc,%esp
  80254e:	ff 75 d0             	pushl  -0x30(%ebp)
  802551:	e8 1b 0a 00 00       	call   802f71 <free_block>
  802556:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802559:	83 ec 0c             	sub    $0xc,%esp
  80255c:	ff 75 08             	pushl  0x8(%ebp)
  80255f:	e8 49 fb ff ff       	call   8020ad <alloc_block_FF>
  802564:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	83 e0 01             	and    $0x1,%eax
  802575:	85 c0                	test   %eax,%eax
  802577:	74 03                	je     80257c <alloc_block_BF+0x13>
  802579:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80257c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802580:	77 07                	ja     802589 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802582:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802589:	a1 24 50 80 00       	mov    0x805024,%eax
  80258e:	85 c0                	test   %eax,%eax
  802590:	75 73                	jne    802605 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	83 c0 10             	add    $0x10,%eax
  802598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80259b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8025a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a8:	01 d0                	add    %edx,%eax
  8025aa:	48                   	dec    %eax
  8025ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8025ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b6:	f7 75 e0             	divl   -0x20(%ebp)
  8025b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025bc:	29 d0                	sub    %edx,%eax
  8025be:	c1 e8 0c             	shr    $0xc,%eax
  8025c1:	83 ec 0c             	sub    $0xc,%esp
  8025c4:	50                   	push   %eax
  8025c5:	e8 ca ec ff ff       	call   801294 <sbrk>
  8025ca:	83 c4 10             	add    $0x10,%esp
  8025cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025d0:	83 ec 0c             	sub    $0xc,%esp
  8025d3:	6a 00                	push   $0x0
  8025d5:	e8 ba ec ff ff       	call   801294 <sbrk>
  8025da:	83 c4 10             	add    $0x10,%esp
  8025dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8025e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025e3:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8025e6:	83 ec 08             	sub    $0x8,%esp
  8025e9:	50                   	push   %eax
  8025ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8025ed:	e8 9f f8 ff ff       	call   801e91 <initialize_dynamic_allocator>
  8025f2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025f5:	83 ec 0c             	sub    $0xc,%esp
  8025f8:	68 ab 42 80 00       	push   $0x8042ab
  8025fd:	e8 f8 de ff ff       	call   8004fa <cprintf>
  802602:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802605:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80260c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802613:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80261a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802621:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802626:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802629:	e9 1d 01 00 00       	jmp    80274b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802634:	83 ec 0c             	sub    $0xc,%esp
  802637:	ff 75 a8             	pushl  -0x58(%ebp)
  80263a:	e8 ee f6 ff ff       	call   801d2d <get_block_size>
  80263f:	83 c4 10             	add    $0x10,%esp
  802642:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	83 c0 08             	add    $0x8,%eax
  80264b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80264e:	0f 87 ef 00 00 00    	ja     802743 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802654:	8b 45 08             	mov    0x8(%ebp),%eax
  802657:	83 c0 18             	add    $0x18,%eax
  80265a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80265d:	77 1d                	ja     80267c <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80265f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802662:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802665:	0f 86 d8 00 00 00    	jbe    802743 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80266b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80266e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802671:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802674:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802677:	e9 c7 00 00 00       	jmp    802743 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80267c:	8b 45 08             	mov    0x8(%ebp),%eax
  80267f:	83 c0 08             	add    $0x8,%eax
  802682:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802685:	0f 85 9d 00 00 00    	jne    802728 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80268b:	83 ec 04             	sub    $0x4,%esp
  80268e:	6a 01                	push   $0x1
  802690:	ff 75 a4             	pushl  -0x5c(%ebp)
  802693:	ff 75 a8             	pushl  -0x58(%ebp)
  802696:	e8 e3 f9 ff ff       	call   80207e <set_block_data>
  80269b:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80269e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a2:	75 17                	jne    8026bb <alloc_block_BF+0x152>
  8026a4:	83 ec 04             	sub    $0x4,%esp
  8026a7:	68 4f 42 80 00       	push   $0x80424f
  8026ac:	68 2c 01 00 00       	push   $0x12c
  8026b1:	68 6d 42 80 00       	push   $0x80426d
  8026b6:	e8 82 db ff ff       	call   80023d <_panic>
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 00                	mov    (%eax),%eax
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	74 10                	je     8026d4 <alloc_block_BF+0x16b>
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cc:	8b 52 04             	mov    0x4(%edx),%edx
  8026cf:	89 50 04             	mov    %edx,0x4(%eax)
  8026d2:	eb 0b                	jmp    8026df <alloc_block_BF+0x176>
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 40 04             	mov    0x4(%eax),%eax
  8026da:	a3 30 50 80 00       	mov    %eax,0x805030
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 40 04             	mov    0x4(%eax),%eax
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	74 0f                	je     8026f8 <alloc_block_BF+0x18f>
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 40 04             	mov    0x4(%eax),%eax
  8026ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f2:	8b 12                	mov    (%edx),%edx
  8026f4:	89 10                	mov    %edx,(%eax)
  8026f6:	eb 0a                	jmp    802702 <alloc_block_BF+0x199>
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 00                	mov    (%eax),%eax
  8026fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802715:	a1 38 50 80 00       	mov    0x805038,%eax
  80271a:	48                   	dec    %eax
  80271b:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802720:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802723:	e9 24 04 00 00       	jmp    802b4c <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802728:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80272e:	76 13                	jbe    802743 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802730:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802737:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80273a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80273d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802740:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802743:	a1 34 50 80 00       	mov    0x805034,%eax
  802748:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274f:	74 07                	je     802758 <alloc_block_BF+0x1ef>
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 00                	mov    (%eax),%eax
  802756:	eb 05                	jmp    80275d <alloc_block_BF+0x1f4>
  802758:	b8 00 00 00 00       	mov    $0x0,%eax
  80275d:	a3 34 50 80 00       	mov    %eax,0x805034
  802762:	a1 34 50 80 00       	mov    0x805034,%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	0f 85 bf fe ff ff    	jne    80262e <alloc_block_BF+0xc5>
  80276f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802773:	0f 85 b5 fe ff ff    	jne    80262e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802779:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277d:	0f 84 26 02 00 00    	je     8029a9 <alloc_block_BF+0x440>
  802783:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802787:	0f 85 1c 02 00 00    	jne    8029a9 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80278d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802790:	2b 45 08             	sub    0x8(%ebp),%eax
  802793:	83 e8 08             	sub    $0x8,%eax
  802796:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	8d 50 08             	lea    0x8(%eax),%edx
  80279f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a2:	01 d0                	add    %edx,%eax
  8027a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	83 c0 08             	add    $0x8,%eax
  8027ad:	83 ec 04             	sub    $0x4,%esp
  8027b0:	6a 01                	push   $0x1
  8027b2:	50                   	push   %eax
  8027b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8027b6:	e8 c3 f8 ff ff       	call   80207e <set_block_data>
  8027bb:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8027be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c1:	8b 40 04             	mov    0x4(%eax),%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	75 68                	jne    802830 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027cc:	75 17                	jne    8027e5 <alloc_block_BF+0x27c>
  8027ce:	83 ec 04             	sub    $0x4,%esp
  8027d1:	68 88 42 80 00       	push   $0x804288
  8027d6:	68 45 01 00 00       	push   $0x145
  8027db:	68 6d 42 80 00       	push   $0x80426d
  8027e0:	e8 58 da ff ff       	call   80023d <_panic>
  8027e5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8027eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ee:	89 10                	mov    %edx,(%eax)
  8027f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	74 0d                	je     802806 <alloc_block_BF+0x29d>
  8027f9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027fe:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802801:	89 50 04             	mov    %edx,0x4(%eax)
  802804:	eb 08                	jmp    80280e <alloc_block_BF+0x2a5>
  802806:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802809:	a3 30 50 80 00       	mov    %eax,0x805030
  80280e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802811:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802816:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802819:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802820:	a1 38 50 80 00       	mov    0x805038,%eax
  802825:	40                   	inc    %eax
  802826:	a3 38 50 80 00       	mov    %eax,0x805038
  80282b:	e9 dc 00 00 00       	jmp    80290c <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	85 c0                	test   %eax,%eax
  802837:	75 65                	jne    80289e <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802839:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80283d:	75 17                	jne    802856 <alloc_block_BF+0x2ed>
  80283f:	83 ec 04             	sub    $0x4,%esp
  802842:	68 bc 42 80 00       	push   $0x8042bc
  802847:	68 4a 01 00 00       	push   $0x14a
  80284c:	68 6d 42 80 00       	push   $0x80426d
  802851:	e8 e7 d9 ff ff       	call   80023d <_panic>
  802856:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80285c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285f:	89 50 04             	mov    %edx,0x4(%eax)
  802862:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802865:	8b 40 04             	mov    0x4(%eax),%eax
  802868:	85 c0                	test   %eax,%eax
  80286a:	74 0c                	je     802878 <alloc_block_BF+0x30f>
  80286c:	a1 30 50 80 00       	mov    0x805030,%eax
  802871:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802874:	89 10                	mov    %edx,(%eax)
  802876:	eb 08                	jmp    802880 <alloc_block_BF+0x317>
  802878:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80287b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802880:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802883:	a3 30 50 80 00       	mov    %eax,0x805030
  802888:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80288b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802891:	a1 38 50 80 00       	mov    0x805038,%eax
  802896:	40                   	inc    %eax
  802897:	a3 38 50 80 00       	mov    %eax,0x805038
  80289c:	eb 6e                	jmp    80290c <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80289e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028a2:	74 06                	je     8028aa <alloc_block_BF+0x341>
  8028a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028a8:	75 17                	jne    8028c1 <alloc_block_BF+0x358>
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	68 e0 42 80 00       	push   $0x8042e0
  8028b2:	68 4f 01 00 00       	push   $0x14f
  8028b7:	68 6d 42 80 00       	push   $0x80426d
  8028bc:	e8 7c d9 ff ff       	call   80023d <_panic>
  8028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c4:	8b 10                	mov    (%eax),%edx
  8028c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c9:	89 10                	mov    %edx,(%eax)
  8028cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ce:	8b 00                	mov    (%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 0b                	je     8028df <alloc_block_BF+0x376>
  8028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028dc:	89 50 04             	mov    %edx,0x4(%eax)
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028e5:	89 10                	mov    %edx,(%eax)
  8028e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ed:	89 50 04             	mov    %edx,0x4(%eax)
  8028f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	75 08                	jne    802901 <alloc_block_BF+0x398>
  8028f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028fc:	a3 30 50 80 00       	mov    %eax,0x805030
  802901:	a1 38 50 80 00       	mov    0x805038,%eax
  802906:	40                   	inc    %eax
  802907:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80290c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802910:	75 17                	jne    802929 <alloc_block_BF+0x3c0>
  802912:	83 ec 04             	sub    $0x4,%esp
  802915:	68 4f 42 80 00       	push   $0x80424f
  80291a:	68 51 01 00 00       	push   $0x151
  80291f:	68 6d 42 80 00       	push   $0x80426d
  802924:	e8 14 d9 ff ff       	call   80023d <_panic>
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	8b 00                	mov    (%eax),%eax
  80292e:	85 c0                	test   %eax,%eax
  802930:	74 10                	je     802942 <alloc_block_BF+0x3d9>
  802932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802935:	8b 00                	mov    (%eax),%eax
  802937:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293a:	8b 52 04             	mov    0x4(%edx),%edx
  80293d:	89 50 04             	mov    %edx,0x4(%eax)
  802940:	eb 0b                	jmp    80294d <alloc_block_BF+0x3e4>
  802942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802945:	8b 40 04             	mov    0x4(%eax),%eax
  802948:	a3 30 50 80 00       	mov    %eax,0x805030
  80294d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802950:	8b 40 04             	mov    0x4(%eax),%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	74 0f                	je     802966 <alloc_block_BF+0x3fd>
  802957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295a:	8b 40 04             	mov    0x4(%eax),%eax
  80295d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802960:	8b 12                	mov    (%edx),%edx
  802962:	89 10                	mov    %edx,(%eax)
  802964:	eb 0a                	jmp    802970 <alloc_block_BF+0x407>
  802966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802969:	8b 00                	mov    (%eax),%eax
  80296b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802973:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802983:	a1 38 50 80 00       	mov    0x805038,%eax
  802988:	48                   	dec    %eax
  802989:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80298e:	83 ec 04             	sub    $0x4,%esp
  802991:	6a 00                	push   $0x0
  802993:	ff 75 d0             	pushl  -0x30(%ebp)
  802996:	ff 75 cc             	pushl  -0x34(%ebp)
  802999:	e8 e0 f6 ff ff       	call   80207e <set_block_data>
  80299e:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8029a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a4:	e9 a3 01 00 00       	jmp    802b4c <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8029a9:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8029ad:	0f 85 9d 00 00 00    	jne    802a50 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8029b3:	83 ec 04             	sub    $0x4,%esp
  8029b6:	6a 01                	push   $0x1
  8029b8:	ff 75 ec             	pushl  -0x14(%ebp)
  8029bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8029be:	e8 bb f6 ff ff       	call   80207e <set_block_data>
  8029c3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8029c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ca:	75 17                	jne    8029e3 <alloc_block_BF+0x47a>
  8029cc:	83 ec 04             	sub    $0x4,%esp
  8029cf:	68 4f 42 80 00       	push   $0x80424f
  8029d4:	68 58 01 00 00       	push   $0x158
  8029d9:	68 6d 42 80 00       	push   $0x80426d
  8029de:	e8 5a d8 ff ff       	call   80023d <_panic>
  8029e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e6:	8b 00                	mov    (%eax),%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	74 10                	je     8029fc <alloc_block_BF+0x493>
  8029ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ef:	8b 00                	mov    (%eax),%eax
  8029f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f4:	8b 52 04             	mov    0x4(%edx),%edx
  8029f7:	89 50 04             	mov    %edx,0x4(%eax)
  8029fa:	eb 0b                	jmp    802a07 <alloc_block_BF+0x49e>
  8029fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ff:	8b 40 04             	mov    0x4(%eax),%eax
  802a02:	a3 30 50 80 00       	mov    %eax,0x805030
  802a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0a:	8b 40 04             	mov    0x4(%eax),%eax
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	74 0f                	je     802a20 <alloc_block_BF+0x4b7>
  802a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a14:	8b 40 04             	mov    0x4(%eax),%eax
  802a17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1a:	8b 12                	mov    (%edx),%edx
  802a1c:	89 10                	mov    %edx,(%eax)
  802a1e:	eb 0a                	jmp    802a2a <alloc_block_BF+0x4c1>
  802a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3d:	a1 38 50 80 00       	mov    0x805038,%eax
  802a42:	48                   	dec    %eax
  802a43:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4b:	e9 fc 00 00 00       	jmp    802b4c <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802a50:	8b 45 08             	mov    0x8(%ebp),%eax
  802a53:	83 c0 08             	add    $0x8,%eax
  802a56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a59:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802a60:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a63:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a66:	01 d0                	add    %edx,%eax
  802a68:	48                   	dec    %eax
  802a69:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802a6c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a6f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a74:	f7 75 c4             	divl   -0x3c(%ebp)
  802a77:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a7a:	29 d0                	sub    %edx,%eax
  802a7c:	c1 e8 0c             	shr    $0xc,%eax
  802a7f:	83 ec 0c             	sub    $0xc,%esp
  802a82:	50                   	push   %eax
  802a83:	e8 0c e8 ff ff       	call   801294 <sbrk>
  802a88:	83 c4 10             	add    $0x10,%esp
  802a8b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802a8e:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802a92:	75 0a                	jne    802a9e <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
  802a99:	e9 ae 00 00 00       	jmp    802b4c <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a9e:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802aa5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802aa8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802aab:	01 d0                	add    %edx,%eax
  802aad:	48                   	dec    %eax
  802aae:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ab1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ab9:	f7 75 b8             	divl   -0x48(%ebp)
  802abc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802abf:	29 d0                	sub    %edx,%eax
  802ac1:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ac4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ac7:	01 d0                	add    %edx,%eax
  802ac9:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ace:	a1 40 50 80 00       	mov    0x805040,%eax
  802ad3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ad9:	83 ec 0c             	sub    $0xc,%esp
  802adc:	68 14 43 80 00       	push   $0x804314
  802ae1:	e8 14 da ff ff       	call   8004fa <cprintf>
  802ae6:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802ae9:	83 ec 08             	sub    $0x8,%esp
  802aec:	ff 75 bc             	pushl  -0x44(%ebp)
  802aef:	68 19 43 80 00       	push   $0x804319
  802af4:	e8 01 da ff ff       	call   8004fa <cprintf>
  802af9:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802afc:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b03:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b06:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b09:	01 d0                	add    %edx,%eax
  802b0b:	48                   	dec    %eax
  802b0c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b0f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b12:	ba 00 00 00 00       	mov    $0x0,%edx
  802b17:	f7 75 b0             	divl   -0x50(%ebp)
  802b1a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b1d:	29 d0                	sub    %edx,%eax
  802b1f:	83 ec 04             	sub    $0x4,%esp
  802b22:	6a 01                	push   $0x1
  802b24:	50                   	push   %eax
  802b25:	ff 75 bc             	pushl  -0x44(%ebp)
  802b28:	e8 51 f5 ff ff       	call   80207e <set_block_data>
  802b2d:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b30:	83 ec 0c             	sub    $0xc,%esp
  802b33:	ff 75 bc             	pushl  -0x44(%ebp)
  802b36:	e8 36 04 00 00       	call   802f71 <free_block>
  802b3b:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802b3e:	83 ec 0c             	sub    $0xc,%esp
  802b41:	ff 75 08             	pushl  0x8(%ebp)
  802b44:	e8 20 fa ff ff       	call   802569 <alloc_block_BF>
  802b49:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802b4c:	c9                   	leave  
  802b4d:	c3                   	ret    

00802b4e <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802b4e:	55                   	push   %ebp
  802b4f:	89 e5                	mov    %esp,%ebp
  802b51:	53                   	push   %ebx
  802b52:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802b55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b5c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802b63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b67:	74 1e                	je     802b87 <merging+0x39>
  802b69:	ff 75 08             	pushl  0x8(%ebp)
  802b6c:	e8 bc f1 ff ff       	call   801d2d <get_block_size>
  802b71:	83 c4 04             	add    $0x4,%esp
  802b74:	89 c2                	mov    %eax,%edx
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	01 d0                	add    %edx,%eax
  802b7b:	3b 45 10             	cmp    0x10(%ebp),%eax
  802b7e:	75 07                	jne    802b87 <merging+0x39>
		prev_is_free = 1;
  802b80:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802b87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b8b:	74 1e                	je     802bab <merging+0x5d>
  802b8d:	ff 75 10             	pushl  0x10(%ebp)
  802b90:	e8 98 f1 ff ff       	call   801d2d <get_block_size>
  802b95:	83 c4 04             	add    $0x4,%esp
  802b98:	89 c2                	mov    %eax,%edx
  802b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  802b9d:	01 d0                	add    %edx,%eax
  802b9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ba2:	75 07                	jne    802bab <merging+0x5d>
		next_is_free = 1;
  802ba4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802bab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802baf:	0f 84 cc 00 00 00    	je     802c81 <merging+0x133>
  802bb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb9:	0f 84 c2 00 00 00    	je     802c81 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802bbf:	ff 75 08             	pushl  0x8(%ebp)
  802bc2:	e8 66 f1 ff ff       	call   801d2d <get_block_size>
  802bc7:	83 c4 04             	add    $0x4,%esp
  802bca:	89 c3                	mov    %eax,%ebx
  802bcc:	ff 75 10             	pushl  0x10(%ebp)
  802bcf:	e8 59 f1 ff ff       	call   801d2d <get_block_size>
  802bd4:	83 c4 04             	add    $0x4,%esp
  802bd7:	01 c3                	add    %eax,%ebx
  802bd9:	ff 75 0c             	pushl  0xc(%ebp)
  802bdc:	e8 4c f1 ff ff       	call   801d2d <get_block_size>
  802be1:	83 c4 04             	add    $0x4,%esp
  802be4:	01 d8                	add    %ebx,%eax
  802be6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802be9:	6a 00                	push   $0x0
  802beb:	ff 75 ec             	pushl  -0x14(%ebp)
  802bee:	ff 75 08             	pushl  0x8(%ebp)
  802bf1:	e8 88 f4 ff ff       	call   80207e <set_block_data>
  802bf6:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802bf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bfd:	75 17                	jne    802c16 <merging+0xc8>
  802bff:	83 ec 04             	sub    $0x4,%esp
  802c02:	68 4f 42 80 00       	push   $0x80424f
  802c07:	68 7d 01 00 00       	push   $0x17d
  802c0c:	68 6d 42 80 00       	push   $0x80426d
  802c11:	e8 27 d6 ff ff       	call   80023d <_panic>
  802c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	74 10                	je     802c2f <merging+0xe1>
  802c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c27:	8b 52 04             	mov    0x4(%edx),%edx
  802c2a:	89 50 04             	mov    %edx,0x4(%eax)
  802c2d:	eb 0b                	jmp    802c3a <merging+0xec>
  802c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c32:	8b 40 04             	mov    0x4(%eax),%eax
  802c35:	a3 30 50 80 00       	mov    %eax,0x805030
  802c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c3d:	8b 40 04             	mov    0x4(%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	74 0f                	je     802c53 <merging+0x105>
  802c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c47:	8b 40 04             	mov    0x4(%eax),%eax
  802c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c4d:	8b 12                	mov    (%edx),%edx
  802c4f:	89 10                	mov    %edx,(%eax)
  802c51:	eb 0a                	jmp    802c5d <merging+0x10f>
  802c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c70:	a1 38 50 80 00       	mov    0x805038,%eax
  802c75:	48                   	dec    %eax
  802c76:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802c7b:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c7c:	e9 ea 02 00 00       	jmp    802f6b <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802c81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c85:	74 3b                	je     802cc2 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802c87:	83 ec 0c             	sub    $0xc,%esp
  802c8a:	ff 75 08             	pushl  0x8(%ebp)
  802c8d:	e8 9b f0 ff ff       	call   801d2d <get_block_size>
  802c92:	83 c4 10             	add    $0x10,%esp
  802c95:	89 c3                	mov    %eax,%ebx
  802c97:	83 ec 0c             	sub    $0xc,%esp
  802c9a:	ff 75 10             	pushl  0x10(%ebp)
  802c9d:	e8 8b f0 ff ff       	call   801d2d <get_block_size>
  802ca2:	83 c4 10             	add    $0x10,%esp
  802ca5:	01 d8                	add    %ebx,%eax
  802ca7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802caa:	83 ec 04             	sub    $0x4,%esp
  802cad:	6a 00                	push   $0x0
  802caf:	ff 75 e8             	pushl  -0x18(%ebp)
  802cb2:	ff 75 08             	pushl  0x8(%ebp)
  802cb5:	e8 c4 f3 ff ff       	call   80207e <set_block_data>
  802cba:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cbd:	e9 a9 02 00 00       	jmp    802f6b <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802cc2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc6:	0f 84 2d 01 00 00    	je     802df9 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ccc:	83 ec 0c             	sub    $0xc,%esp
  802ccf:	ff 75 10             	pushl  0x10(%ebp)
  802cd2:	e8 56 f0 ff ff       	call   801d2d <get_block_size>
  802cd7:	83 c4 10             	add    $0x10,%esp
  802cda:	89 c3                	mov    %eax,%ebx
  802cdc:	83 ec 0c             	sub    $0xc,%esp
  802cdf:	ff 75 0c             	pushl  0xc(%ebp)
  802ce2:	e8 46 f0 ff ff       	call   801d2d <get_block_size>
  802ce7:	83 c4 10             	add    $0x10,%esp
  802cea:	01 d8                	add    %ebx,%eax
  802cec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802cef:	83 ec 04             	sub    $0x4,%esp
  802cf2:	6a 00                	push   $0x0
  802cf4:	ff 75 e4             	pushl  -0x1c(%ebp)
  802cf7:	ff 75 10             	pushl  0x10(%ebp)
  802cfa:	e8 7f f3 ff ff       	call   80207e <set_block_data>
  802cff:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d02:	8b 45 10             	mov    0x10(%ebp),%eax
  802d05:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d0c:	74 06                	je     802d14 <merging+0x1c6>
  802d0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d12:	75 17                	jne    802d2b <merging+0x1dd>
  802d14:	83 ec 04             	sub    $0x4,%esp
  802d17:	68 28 43 80 00       	push   $0x804328
  802d1c:	68 8d 01 00 00       	push   $0x18d
  802d21:	68 6d 42 80 00       	push   $0x80426d
  802d26:	e8 12 d5 ff ff       	call   80023d <_panic>
  802d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2e:	8b 50 04             	mov    0x4(%eax),%edx
  802d31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d34:	89 50 04             	mov    %edx,0x4(%eax)
  802d37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3d:	89 10                	mov    %edx,(%eax)
  802d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d42:	8b 40 04             	mov    0x4(%eax),%eax
  802d45:	85 c0                	test   %eax,%eax
  802d47:	74 0d                	je     802d56 <merging+0x208>
  802d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4c:	8b 40 04             	mov    0x4(%eax),%eax
  802d4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d52:	89 10                	mov    %edx,(%eax)
  802d54:	eb 08                	jmp    802d5e <merging+0x210>
  802d56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d59:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d61:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d64:	89 50 04             	mov    %edx,0x4(%eax)
  802d67:	a1 38 50 80 00       	mov    0x805038,%eax
  802d6c:	40                   	inc    %eax
  802d6d:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802d72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d76:	75 17                	jne    802d8f <merging+0x241>
  802d78:	83 ec 04             	sub    $0x4,%esp
  802d7b:	68 4f 42 80 00       	push   $0x80424f
  802d80:	68 8e 01 00 00       	push   $0x18e
  802d85:	68 6d 42 80 00       	push   $0x80426d
  802d8a:	e8 ae d4 ff ff       	call   80023d <_panic>
  802d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d92:	8b 00                	mov    (%eax),%eax
  802d94:	85 c0                	test   %eax,%eax
  802d96:	74 10                	je     802da8 <merging+0x25a>
  802d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da0:	8b 52 04             	mov    0x4(%edx),%edx
  802da3:	89 50 04             	mov    %edx,0x4(%eax)
  802da6:	eb 0b                	jmp    802db3 <merging+0x265>
  802da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dab:	8b 40 04             	mov    0x4(%eax),%eax
  802dae:	a3 30 50 80 00       	mov    %eax,0x805030
  802db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db6:	8b 40 04             	mov    0x4(%eax),%eax
  802db9:	85 c0                	test   %eax,%eax
  802dbb:	74 0f                	je     802dcc <merging+0x27e>
  802dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc0:	8b 40 04             	mov    0x4(%eax),%eax
  802dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc6:	8b 12                	mov    (%edx),%edx
  802dc8:	89 10                	mov    %edx,(%eax)
  802dca:	eb 0a                	jmp    802dd6 <merging+0x288>
  802dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de9:	a1 38 50 80 00       	mov    0x805038,%eax
  802dee:	48                   	dec    %eax
  802def:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802df4:	e9 72 01 00 00       	jmp    802f6b <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802df9:	8b 45 10             	mov    0x10(%ebp),%eax
  802dfc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802dff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e03:	74 79                	je     802e7e <merging+0x330>
  802e05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e09:	74 73                	je     802e7e <merging+0x330>
  802e0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e0f:	74 06                	je     802e17 <merging+0x2c9>
  802e11:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e15:	75 17                	jne    802e2e <merging+0x2e0>
  802e17:	83 ec 04             	sub    $0x4,%esp
  802e1a:	68 e0 42 80 00       	push   $0x8042e0
  802e1f:	68 94 01 00 00       	push   $0x194
  802e24:	68 6d 42 80 00       	push   $0x80426d
  802e29:	e8 0f d4 ff ff       	call   80023d <_panic>
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	8b 10                	mov    (%eax),%edx
  802e33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e36:	89 10                	mov    %edx,(%eax)
  802e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	85 c0                	test   %eax,%eax
  802e3f:	74 0b                	je     802e4c <merging+0x2fe>
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	8b 00                	mov    (%eax),%eax
  802e46:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e49:	89 50 04             	mov    %edx,0x4(%eax)
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e52:	89 10                	mov    %edx,(%eax)
  802e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e57:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5a:	89 50 04             	mov    %edx,0x4(%eax)
  802e5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	85 c0                	test   %eax,%eax
  802e64:	75 08                	jne    802e6e <merging+0x320>
  802e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e69:	a3 30 50 80 00       	mov    %eax,0x805030
  802e6e:	a1 38 50 80 00       	mov    0x805038,%eax
  802e73:	40                   	inc    %eax
  802e74:	a3 38 50 80 00       	mov    %eax,0x805038
  802e79:	e9 ce 00 00 00       	jmp    802f4c <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802e7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e82:	74 65                	je     802ee9 <merging+0x39b>
  802e84:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e88:	75 17                	jne    802ea1 <merging+0x353>
  802e8a:	83 ec 04             	sub    $0x4,%esp
  802e8d:	68 bc 42 80 00       	push   $0x8042bc
  802e92:	68 95 01 00 00       	push   $0x195
  802e97:	68 6d 42 80 00       	push   $0x80426d
  802e9c:	e8 9c d3 ff ff       	call   80023d <_panic>
  802ea1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ea7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eaa:	89 50 04             	mov    %edx,0x4(%eax)
  802ead:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb0:	8b 40 04             	mov    0x4(%eax),%eax
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	74 0c                	je     802ec3 <merging+0x375>
  802eb7:	a1 30 50 80 00       	mov    0x805030,%eax
  802ebc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ebf:	89 10                	mov    %edx,(%eax)
  802ec1:	eb 08                	jmp    802ecb <merging+0x37d>
  802ec3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ecb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ece:	a3 30 50 80 00       	mov    %eax,0x805030
  802ed3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802edc:	a1 38 50 80 00       	mov    0x805038,%eax
  802ee1:	40                   	inc    %eax
  802ee2:	a3 38 50 80 00       	mov    %eax,0x805038
  802ee7:	eb 63                	jmp    802f4c <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802ee9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802eed:	75 17                	jne    802f06 <merging+0x3b8>
  802eef:	83 ec 04             	sub    $0x4,%esp
  802ef2:	68 88 42 80 00       	push   $0x804288
  802ef7:	68 98 01 00 00       	push   $0x198
  802efc:	68 6d 42 80 00       	push   $0x80426d
  802f01:	e8 37 d3 ff ff       	call   80023d <_panic>
  802f06:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802f0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0f:	89 10                	mov    %edx,(%eax)
  802f11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f14:	8b 00                	mov    (%eax),%eax
  802f16:	85 c0                	test   %eax,%eax
  802f18:	74 0d                	je     802f27 <merging+0x3d9>
  802f1a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f22:	89 50 04             	mov    %edx,0x4(%eax)
  802f25:	eb 08                	jmp    802f2f <merging+0x3e1>
  802f27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f2a:	a3 30 50 80 00       	mov    %eax,0x805030
  802f2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f32:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f41:	a1 38 50 80 00       	mov    0x805038,%eax
  802f46:	40                   	inc    %eax
  802f47:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802f4c:	83 ec 0c             	sub    $0xc,%esp
  802f4f:	ff 75 10             	pushl  0x10(%ebp)
  802f52:	e8 d6 ed ff ff       	call   801d2d <get_block_size>
  802f57:	83 c4 10             	add    $0x10,%esp
  802f5a:	83 ec 04             	sub    $0x4,%esp
  802f5d:	6a 00                	push   $0x0
  802f5f:	50                   	push   %eax
  802f60:	ff 75 10             	pushl  0x10(%ebp)
  802f63:	e8 16 f1 ff ff       	call   80207e <set_block_data>
  802f68:	83 c4 10             	add    $0x10,%esp
	}
}
  802f6b:	90                   	nop
  802f6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f6f:	c9                   	leave  
  802f70:	c3                   	ret    

00802f71 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802f71:	55                   	push   %ebp
  802f72:	89 e5                	mov    %esp,%ebp
  802f74:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802f77:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802f7f:	a1 30 50 80 00       	mov    0x805030,%eax
  802f84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f87:	73 1b                	jae    802fa4 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802f89:	a1 30 50 80 00       	mov    0x805030,%eax
  802f8e:	83 ec 04             	sub    $0x4,%esp
  802f91:	ff 75 08             	pushl  0x8(%ebp)
  802f94:	6a 00                	push   $0x0
  802f96:	50                   	push   %eax
  802f97:	e8 b2 fb ff ff       	call   802b4e <merging>
  802f9c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f9f:	e9 8b 00 00 00       	jmp    80302f <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802fa4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fa9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fac:	76 18                	jbe    802fc6 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802fae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fb3:	83 ec 04             	sub    $0x4,%esp
  802fb6:	ff 75 08             	pushl  0x8(%ebp)
  802fb9:	50                   	push   %eax
  802fba:	6a 00                	push   $0x0
  802fbc:	e8 8d fb ff ff       	call   802b4e <merging>
  802fc1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fc4:	eb 69                	jmp    80302f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802fc6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fce:	eb 39                	jmp    803009 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fd6:	73 29                	jae    803001 <free_block+0x90>
  802fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdb:	8b 00                	mov    (%eax),%eax
  802fdd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe0:	76 1f                	jbe    803001 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe5:	8b 00                	mov    (%eax),%eax
  802fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802fea:	83 ec 04             	sub    $0x4,%esp
  802fed:	ff 75 08             	pushl  0x8(%ebp)
  802ff0:	ff 75 f0             	pushl  -0x10(%ebp)
  802ff3:	ff 75 f4             	pushl  -0xc(%ebp)
  802ff6:	e8 53 fb ff ff       	call   802b4e <merging>
  802ffb:	83 c4 10             	add    $0x10,%esp
			break;
  802ffe:	90                   	nop
		}
	}
}
  802fff:	eb 2e                	jmp    80302f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803001:	a1 34 50 80 00       	mov    0x805034,%eax
  803006:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803009:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300d:	74 07                	je     803016 <free_block+0xa5>
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	8b 00                	mov    (%eax),%eax
  803014:	eb 05                	jmp    80301b <free_block+0xaa>
  803016:	b8 00 00 00 00       	mov    $0x0,%eax
  80301b:	a3 34 50 80 00       	mov    %eax,0x805034
  803020:	a1 34 50 80 00       	mov    0x805034,%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	75 a7                	jne    802fd0 <free_block+0x5f>
  803029:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302d:	75 a1                	jne    802fd0 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80302f:	90                   	nop
  803030:	c9                   	leave  
  803031:	c3                   	ret    

00803032 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803032:	55                   	push   %ebp
  803033:	89 e5                	mov    %esp,%ebp
  803035:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803038:	ff 75 08             	pushl  0x8(%ebp)
  80303b:	e8 ed ec ff ff       	call   801d2d <get_block_size>
  803040:	83 c4 04             	add    $0x4,%esp
  803043:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803046:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80304d:	eb 17                	jmp    803066 <copy_data+0x34>
  80304f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803052:	8b 45 0c             	mov    0xc(%ebp),%eax
  803055:	01 c2                	add    %eax,%edx
  803057:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	01 c8                	add    %ecx,%eax
  80305f:	8a 00                	mov    (%eax),%al
  803061:	88 02                	mov    %al,(%edx)
  803063:	ff 45 fc             	incl   -0x4(%ebp)
  803066:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803069:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80306c:	72 e1                	jb     80304f <copy_data+0x1d>
}
  80306e:	90                   	nop
  80306f:	c9                   	leave  
  803070:	c3                   	ret    

00803071 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803071:	55                   	push   %ebp
  803072:	89 e5                	mov    %esp,%ebp
  803074:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803077:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307b:	75 23                	jne    8030a0 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80307d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803081:	74 13                	je     803096 <realloc_block_FF+0x25>
  803083:	83 ec 0c             	sub    $0xc,%esp
  803086:	ff 75 0c             	pushl  0xc(%ebp)
  803089:	e8 1f f0 ff ff       	call   8020ad <alloc_block_FF>
  80308e:	83 c4 10             	add    $0x10,%esp
  803091:	e9 f4 06 00 00       	jmp    80378a <realloc_block_FF+0x719>
		return NULL;
  803096:	b8 00 00 00 00       	mov    $0x0,%eax
  80309b:	e9 ea 06 00 00       	jmp    80378a <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8030a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030a4:	75 18                	jne    8030be <realloc_block_FF+0x4d>
	{
		free_block(va);
  8030a6:	83 ec 0c             	sub    $0xc,%esp
  8030a9:	ff 75 08             	pushl  0x8(%ebp)
  8030ac:	e8 c0 fe ff ff       	call   802f71 <free_block>
  8030b1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8030b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b9:	e9 cc 06 00 00       	jmp    80378a <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8030be:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8030c2:	77 07                	ja     8030cb <realloc_block_FF+0x5a>
  8030c4:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8030cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ce:	83 e0 01             	and    $0x1,%eax
  8030d1:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8030d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d7:	83 c0 08             	add    $0x8,%eax
  8030da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8030dd:	83 ec 0c             	sub    $0xc,%esp
  8030e0:	ff 75 08             	pushl  0x8(%ebp)
  8030e3:	e8 45 ec ff ff       	call   801d2d <get_block_size>
  8030e8:	83 c4 10             	add    $0x10,%esp
  8030eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8030ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f1:	83 e8 08             	sub    $0x8,%eax
  8030f4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	83 e8 04             	sub    $0x4,%eax
  8030fd:	8b 00                	mov    (%eax),%eax
  8030ff:	83 e0 fe             	and    $0xfffffffe,%eax
  803102:	89 c2                	mov    %eax,%edx
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	01 d0                	add    %edx,%eax
  803109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80310c:	83 ec 0c             	sub    $0xc,%esp
  80310f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803112:	e8 16 ec ff ff       	call   801d2d <get_block_size>
  803117:	83 c4 10             	add    $0x10,%esp
  80311a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80311d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803120:	83 e8 08             	sub    $0x8,%eax
  803123:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803126:	8b 45 0c             	mov    0xc(%ebp),%eax
  803129:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80312c:	75 08                	jne    803136 <realloc_block_FF+0xc5>
	{
		 return va;
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	e9 54 06 00 00       	jmp    80378a <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803136:	8b 45 0c             	mov    0xc(%ebp),%eax
  803139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80313c:	0f 83 e5 03 00 00    	jae    803527 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	2b 45 0c             	sub    0xc(%ebp),%eax
  803148:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80314b:	83 ec 0c             	sub    $0xc,%esp
  80314e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803151:	e8 f0 eb ff ff       	call   801d46 <is_free_block>
  803156:	83 c4 10             	add    $0x10,%esp
  803159:	84 c0                	test   %al,%al
  80315b:	0f 84 3b 01 00 00    	je     80329c <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803161:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803164:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803167:	01 d0                	add    %edx,%eax
  803169:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80316c:	83 ec 04             	sub    $0x4,%esp
  80316f:	6a 01                	push   $0x1
  803171:	ff 75 f0             	pushl  -0x10(%ebp)
  803174:	ff 75 08             	pushl  0x8(%ebp)
  803177:	e8 02 ef ff ff       	call   80207e <set_block_data>
  80317c:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	83 e8 04             	sub    $0x4,%eax
  803185:	8b 00                	mov    (%eax),%eax
  803187:	83 e0 fe             	and    $0xfffffffe,%eax
  80318a:	89 c2                	mov    %eax,%edx
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	01 d0                	add    %edx,%eax
  803191:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803194:	83 ec 04             	sub    $0x4,%esp
  803197:	6a 00                	push   $0x0
  803199:	ff 75 cc             	pushl  -0x34(%ebp)
  80319c:	ff 75 c8             	pushl  -0x38(%ebp)
  80319f:	e8 da ee ff ff       	call   80207e <set_block_data>
  8031a4:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8031a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031ab:	74 06                	je     8031b3 <realloc_block_FF+0x142>
  8031ad:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8031b1:	75 17                	jne    8031ca <realloc_block_FF+0x159>
  8031b3:	83 ec 04             	sub    $0x4,%esp
  8031b6:	68 e0 42 80 00       	push   $0x8042e0
  8031bb:	68 f6 01 00 00       	push   $0x1f6
  8031c0:	68 6d 42 80 00       	push   $0x80426d
  8031c5:	e8 73 d0 ff ff       	call   80023d <_panic>
  8031ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031cd:	8b 10                	mov    (%eax),%edx
  8031cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031d2:	89 10                	mov    %edx,(%eax)
  8031d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031d7:	8b 00                	mov    (%eax),%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	74 0b                	je     8031e8 <realloc_block_FF+0x177>
  8031dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031e5:	89 50 04             	mov    %edx,0x4(%eax)
  8031e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031eb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031ee:	89 10                	mov    %edx,(%eax)
  8031f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031f6:	89 50 04             	mov    %edx,0x4(%eax)
  8031f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	75 08                	jne    80320a <realloc_block_FF+0x199>
  803202:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803205:	a3 30 50 80 00       	mov    %eax,0x805030
  80320a:	a1 38 50 80 00       	mov    0x805038,%eax
  80320f:	40                   	inc    %eax
  803210:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803215:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803219:	75 17                	jne    803232 <realloc_block_FF+0x1c1>
  80321b:	83 ec 04             	sub    $0x4,%esp
  80321e:	68 4f 42 80 00       	push   $0x80424f
  803223:	68 f7 01 00 00       	push   $0x1f7
  803228:	68 6d 42 80 00       	push   $0x80426d
  80322d:	e8 0b d0 ff ff       	call   80023d <_panic>
  803232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803235:	8b 00                	mov    (%eax),%eax
  803237:	85 c0                	test   %eax,%eax
  803239:	74 10                	je     80324b <realloc_block_FF+0x1da>
  80323b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323e:	8b 00                	mov    (%eax),%eax
  803240:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803243:	8b 52 04             	mov    0x4(%edx),%edx
  803246:	89 50 04             	mov    %edx,0x4(%eax)
  803249:	eb 0b                	jmp    803256 <realloc_block_FF+0x1e5>
  80324b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324e:	8b 40 04             	mov    0x4(%eax),%eax
  803251:	a3 30 50 80 00       	mov    %eax,0x805030
  803256:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803259:	8b 40 04             	mov    0x4(%eax),%eax
  80325c:	85 c0                	test   %eax,%eax
  80325e:	74 0f                	je     80326f <realloc_block_FF+0x1fe>
  803260:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803263:	8b 40 04             	mov    0x4(%eax),%eax
  803266:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803269:	8b 12                	mov    (%edx),%edx
  80326b:	89 10                	mov    %edx,(%eax)
  80326d:	eb 0a                	jmp    803279 <realloc_block_FF+0x208>
  80326f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803272:	8b 00                	mov    (%eax),%eax
  803274:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803279:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803285:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328c:	a1 38 50 80 00       	mov    0x805038,%eax
  803291:	48                   	dec    %eax
  803292:	a3 38 50 80 00       	mov    %eax,0x805038
  803297:	e9 83 02 00 00       	jmp    80351f <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80329c:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8032a0:	0f 86 69 02 00 00    	jbe    80350f <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8032a6:	83 ec 04             	sub    $0x4,%esp
  8032a9:	6a 01                	push   $0x1
  8032ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8032ae:	ff 75 08             	pushl  0x8(%ebp)
  8032b1:	e8 c8 ed ff ff       	call   80207e <set_block_data>
  8032b6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bc:	83 e8 04             	sub    $0x4,%eax
  8032bf:	8b 00                	mov    (%eax),%eax
  8032c1:	83 e0 fe             	and    $0xfffffffe,%eax
  8032c4:	89 c2                	mov    %eax,%edx
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	01 d0                	add    %edx,%eax
  8032cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8032ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8032d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8032d6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8032da:	75 68                	jne    803344 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032e0:	75 17                	jne    8032f9 <realloc_block_FF+0x288>
  8032e2:	83 ec 04             	sub    $0x4,%esp
  8032e5:	68 88 42 80 00       	push   $0x804288
  8032ea:	68 06 02 00 00       	push   $0x206
  8032ef:	68 6d 42 80 00       	push   $0x80426d
  8032f4:	e8 44 cf ff ff       	call   80023d <_panic>
  8032f9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803302:	89 10                	mov    %edx,(%eax)
  803304:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803307:	8b 00                	mov    (%eax),%eax
  803309:	85 c0                	test   %eax,%eax
  80330b:	74 0d                	je     80331a <realloc_block_FF+0x2a9>
  80330d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803312:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803315:	89 50 04             	mov    %edx,0x4(%eax)
  803318:	eb 08                	jmp    803322 <realloc_block_FF+0x2b1>
  80331a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80331d:	a3 30 50 80 00       	mov    %eax,0x805030
  803322:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803325:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80332a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80332d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803334:	a1 38 50 80 00       	mov    0x805038,%eax
  803339:	40                   	inc    %eax
  80333a:	a3 38 50 80 00       	mov    %eax,0x805038
  80333f:	e9 b0 01 00 00       	jmp    8034f4 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803344:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803349:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80334c:	76 68                	jbe    8033b6 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80334e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803352:	75 17                	jne    80336b <realloc_block_FF+0x2fa>
  803354:	83 ec 04             	sub    $0x4,%esp
  803357:	68 88 42 80 00       	push   $0x804288
  80335c:	68 0b 02 00 00       	push   $0x20b
  803361:	68 6d 42 80 00       	push   $0x80426d
  803366:	e8 d2 ce ff ff       	call   80023d <_panic>
  80336b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803374:	89 10                	mov    %edx,(%eax)
  803376:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803379:	8b 00                	mov    (%eax),%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	74 0d                	je     80338c <realloc_block_FF+0x31b>
  80337f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803384:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803387:	89 50 04             	mov    %edx,0x4(%eax)
  80338a:	eb 08                	jmp    803394 <realloc_block_FF+0x323>
  80338c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80338f:	a3 30 50 80 00       	mov    %eax,0x805030
  803394:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803397:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80339c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8033ab:	40                   	inc    %eax
  8033ac:	a3 38 50 80 00       	mov    %eax,0x805038
  8033b1:	e9 3e 01 00 00       	jmp    8034f4 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8033b6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033bb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033be:	73 68                	jae    803428 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033c0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033c4:	75 17                	jne    8033dd <realloc_block_FF+0x36c>
  8033c6:	83 ec 04             	sub    $0x4,%esp
  8033c9:	68 bc 42 80 00       	push   $0x8042bc
  8033ce:	68 10 02 00 00       	push   $0x210
  8033d3:	68 6d 42 80 00       	push   $0x80426d
  8033d8:	e8 60 ce ff ff       	call   80023d <_panic>
  8033dd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8033e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e6:	89 50 04             	mov    %edx,0x4(%eax)
  8033e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ec:	8b 40 04             	mov    0x4(%eax),%eax
  8033ef:	85 c0                	test   %eax,%eax
  8033f1:	74 0c                	je     8033ff <realloc_block_FF+0x38e>
  8033f3:	a1 30 50 80 00       	mov    0x805030,%eax
  8033f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033fb:	89 10                	mov    %edx,(%eax)
  8033fd:	eb 08                	jmp    803407 <realloc_block_FF+0x396>
  8033ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803402:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803407:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340a:	a3 30 50 80 00       	mov    %eax,0x805030
  80340f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803418:	a1 38 50 80 00       	mov    0x805038,%eax
  80341d:	40                   	inc    %eax
  80341e:	a3 38 50 80 00       	mov    %eax,0x805038
  803423:	e9 cc 00 00 00       	jmp    8034f4 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803428:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80342f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803437:	e9 8a 00 00 00       	jmp    8034c6 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80343c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803442:	73 7a                	jae    8034be <realloc_block_FF+0x44d>
  803444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803447:	8b 00                	mov    (%eax),%eax
  803449:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80344c:	73 70                	jae    8034be <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80344e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803452:	74 06                	je     80345a <realloc_block_FF+0x3e9>
  803454:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803458:	75 17                	jne    803471 <realloc_block_FF+0x400>
  80345a:	83 ec 04             	sub    $0x4,%esp
  80345d:	68 e0 42 80 00       	push   $0x8042e0
  803462:	68 1a 02 00 00       	push   $0x21a
  803467:	68 6d 42 80 00       	push   $0x80426d
  80346c:	e8 cc cd ff ff       	call   80023d <_panic>
  803471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803474:	8b 10                	mov    (%eax),%edx
  803476:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803479:	89 10                	mov    %edx,(%eax)
  80347b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347e:	8b 00                	mov    (%eax),%eax
  803480:	85 c0                	test   %eax,%eax
  803482:	74 0b                	je     80348f <realloc_block_FF+0x41e>
  803484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803487:	8b 00                	mov    (%eax),%eax
  803489:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80348c:	89 50 04             	mov    %edx,0x4(%eax)
  80348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803492:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803495:	89 10                	mov    %edx,(%eax)
  803497:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349d:	89 50 04             	mov    %edx,0x4(%eax)
  8034a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	75 08                	jne    8034b1 <realloc_block_FF+0x440>
  8034a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8034b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8034b6:	40                   	inc    %eax
  8034b7:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8034bc:	eb 36                	jmp    8034f4 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8034be:	a1 34 50 80 00       	mov    0x805034,%eax
  8034c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ca:	74 07                	je     8034d3 <realloc_block_FF+0x462>
  8034cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cf:	8b 00                	mov    (%eax),%eax
  8034d1:	eb 05                	jmp    8034d8 <realloc_block_FF+0x467>
  8034d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d8:	a3 34 50 80 00       	mov    %eax,0x805034
  8034dd:	a1 34 50 80 00       	mov    0x805034,%eax
  8034e2:	85 c0                	test   %eax,%eax
  8034e4:	0f 85 52 ff ff ff    	jne    80343c <realloc_block_FF+0x3cb>
  8034ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ee:	0f 85 48 ff ff ff    	jne    80343c <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8034f4:	83 ec 04             	sub    $0x4,%esp
  8034f7:	6a 00                	push   $0x0
  8034f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8034fc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034ff:	e8 7a eb ff ff       	call   80207e <set_block_data>
  803504:	83 c4 10             	add    $0x10,%esp
				return va;
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	e9 7b 02 00 00       	jmp    80378a <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80350f:	83 ec 0c             	sub    $0xc,%esp
  803512:	68 5d 43 80 00       	push   $0x80435d
  803517:	e8 de cf ff ff       	call   8004fa <cprintf>
  80351c:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	e9 63 02 00 00       	jmp    80378a <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80352d:	0f 86 4d 02 00 00    	jbe    803780 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803533:	83 ec 0c             	sub    $0xc,%esp
  803536:	ff 75 e4             	pushl  -0x1c(%ebp)
  803539:	e8 08 e8 ff ff       	call   801d46 <is_free_block>
  80353e:	83 c4 10             	add    $0x10,%esp
  803541:	84 c0                	test   %al,%al
  803543:	0f 84 37 02 00 00    	je     803780 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80354f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803552:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803555:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803558:	76 38                	jbe    803592 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80355a:	83 ec 0c             	sub    $0xc,%esp
  80355d:	ff 75 08             	pushl  0x8(%ebp)
  803560:	e8 0c fa ff ff       	call   802f71 <free_block>
  803565:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803568:	83 ec 0c             	sub    $0xc,%esp
  80356b:	ff 75 0c             	pushl  0xc(%ebp)
  80356e:	e8 3a eb ff ff       	call   8020ad <alloc_block_FF>
  803573:	83 c4 10             	add    $0x10,%esp
  803576:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803579:	83 ec 08             	sub    $0x8,%esp
  80357c:	ff 75 c0             	pushl  -0x40(%ebp)
  80357f:	ff 75 08             	pushl  0x8(%ebp)
  803582:	e8 ab fa ff ff       	call   803032 <copy_data>
  803587:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80358a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80358d:	e9 f8 01 00 00       	jmp    80378a <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803595:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803598:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80359b:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80359f:	0f 87 a0 00 00 00    	ja     803645 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8035a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a9:	75 17                	jne    8035c2 <realloc_block_FF+0x551>
  8035ab:	83 ec 04             	sub    $0x4,%esp
  8035ae:	68 4f 42 80 00       	push   $0x80424f
  8035b3:	68 38 02 00 00       	push   $0x238
  8035b8:	68 6d 42 80 00       	push   $0x80426d
  8035bd:	e8 7b cc ff ff       	call   80023d <_panic>
  8035c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c5:	8b 00                	mov    (%eax),%eax
  8035c7:	85 c0                	test   %eax,%eax
  8035c9:	74 10                	je     8035db <realloc_block_FF+0x56a>
  8035cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ce:	8b 00                	mov    (%eax),%eax
  8035d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d3:	8b 52 04             	mov    0x4(%edx),%edx
  8035d6:	89 50 04             	mov    %edx,0x4(%eax)
  8035d9:	eb 0b                	jmp    8035e6 <realloc_block_FF+0x575>
  8035db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035de:	8b 40 04             	mov    0x4(%eax),%eax
  8035e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e9:	8b 40 04             	mov    0x4(%eax),%eax
  8035ec:	85 c0                	test   %eax,%eax
  8035ee:	74 0f                	je     8035ff <realloc_block_FF+0x58e>
  8035f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f3:	8b 40 04             	mov    0x4(%eax),%eax
  8035f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f9:	8b 12                	mov    (%edx),%edx
  8035fb:	89 10                	mov    %edx,(%eax)
  8035fd:	eb 0a                	jmp    803609 <realloc_block_FF+0x598>
  8035ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803602:	8b 00                	mov    (%eax),%eax
  803604:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803615:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361c:	a1 38 50 80 00       	mov    0x805038,%eax
  803621:	48                   	dec    %eax
  803622:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803627:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80362a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80362d:	01 d0                	add    %edx,%eax
  80362f:	83 ec 04             	sub    $0x4,%esp
  803632:	6a 01                	push   $0x1
  803634:	50                   	push   %eax
  803635:	ff 75 08             	pushl  0x8(%ebp)
  803638:	e8 41 ea ff ff       	call   80207e <set_block_data>
  80363d:	83 c4 10             	add    $0x10,%esp
  803640:	e9 36 01 00 00       	jmp    80377b <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803645:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803648:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80364b:	01 d0                	add    %edx,%eax
  80364d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803650:	83 ec 04             	sub    $0x4,%esp
  803653:	6a 01                	push   $0x1
  803655:	ff 75 f0             	pushl  -0x10(%ebp)
  803658:	ff 75 08             	pushl  0x8(%ebp)
  80365b:	e8 1e ea ff ff       	call   80207e <set_block_data>
  803660:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	83 e8 04             	sub    $0x4,%eax
  803669:	8b 00                	mov    (%eax),%eax
  80366b:	83 e0 fe             	and    $0xfffffffe,%eax
  80366e:	89 c2                	mov    %eax,%edx
  803670:	8b 45 08             	mov    0x8(%ebp),%eax
  803673:	01 d0                	add    %edx,%eax
  803675:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803678:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80367c:	74 06                	je     803684 <realloc_block_FF+0x613>
  80367e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803682:	75 17                	jne    80369b <realloc_block_FF+0x62a>
  803684:	83 ec 04             	sub    $0x4,%esp
  803687:	68 e0 42 80 00       	push   $0x8042e0
  80368c:	68 44 02 00 00       	push   $0x244
  803691:	68 6d 42 80 00       	push   $0x80426d
  803696:	e8 a2 cb ff ff       	call   80023d <_panic>
  80369b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369e:	8b 10                	mov    (%eax),%edx
  8036a0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036a3:	89 10                	mov    %edx,(%eax)
  8036a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036a8:	8b 00                	mov    (%eax),%eax
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	74 0b                	je     8036b9 <realloc_block_FF+0x648>
  8036ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b1:	8b 00                	mov    (%eax),%eax
  8036b3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8036b6:	89 50 04             	mov    %edx,0x4(%eax)
  8036b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036bc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8036bf:	89 10                	mov    %edx,(%eax)
  8036c1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036c7:	89 50 04             	mov    %edx,0x4(%eax)
  8036ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036cd:	8b 00                	mov    (%eax),%eax
  8036cf:	85 c0                	test   %eax,%eax
  8036d1:	75 08                	jne    8036db <realloc_block_FF+0x66a>
  8036d3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8036db:	a1 38 50 80 00       	mov    0x805038,%eax
  8036e0:	40                   	inc    %eax
  8036e1:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8036e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036ea:	75 17                	jne    803703 <realloc_block_FF+0x692>
  8036ec:	83 ec 04             	sub    $0x4,%esp
  8036ef:	68 4f 42 80 00       	push   $0x80424f
  8036f4:	68 45 02 00 00       	push   $0x245
  8036f9:	68 6d 42 80 00       	push   $0x80426d
  8036fe:	e8 3a cb ff ff       	call   80023d <_panic>
  803703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803706:	8b 00                	mov    (%eax),%eax
  803708:	85 c0                	test   %eax,%eax
  80370a:	74 10                	je     80371c <realloc_block_FF+0x6ab>
  80370c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370f:	8b 00                	mov    (%eax),%eax
  803711:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803714:	8b 52 04             	mov    0x4(%edx),%edx
  803717:	89 50 04             	mov    %edx,0x4(%eax)
  80371a:	eb 0b                	jmp    803727 <realloc_block_FF+0x6b6>
  80371c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371f:	8b 40 04             	mov    0x4(%eax),%eax
  803722:	a3 30 50 80 00       	mov    %eax,0x805030
  803727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372a:	8b 40 04             	mov    0x4(%eax),%eax
  80372d:	85 c0                	test   %eax,%eax
  80372f:	74 0f                	je     803740 <realloc_block_FF+0x6cf>
  803731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803734:	8b 40 04             	mov    0x4(%eax),%eax
  803737:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80373a:	8b 12                	mov    (%edx),%edx
  80373c:	89 10                	mov    %edx,(%eax)
  80373e:	eb 0a                	jmp    80374a <realloc_block_FF+0x6d9>
  803740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803743:	8b 00                	mov    (%eax),%eax
  803745:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80374a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803756:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375d:	a1 38 50 80 00       	mov    0x805038,%eax
  803762:	48                   	dec    %eax
  803763:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803768:	83 ec 04             	sub    $0x4,%esp
  80376b:	6a 00                	push   $0x0
  80376d:	ff 75 bc             	pushl  -0x44(%ebp)
  803770:	ff 75 b8             	pushl  -0x48(%ebp)
  803773:	e8 06 e9 ff ff       	call   80207e <set_block_data>
  803778:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80377b:	8b 45 08             	mov    0x8(%ebp),%eax
  80377e:	eb 0a                	jmp    80378a <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803780:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803787:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80378a:	c9                   	leave  
  80378b:	c3                   	ret    

0080378c <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80378c:	55                   	push   %ebp
  80378d:	89 e5                	mov    %esp,%ebp
  80378f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803792:	83 ec 04             	sub    $0x4,%esp
  803795:	68 64 43 80 00       	push   $0x804364
  80379a:	68 58 02 00 00       	push   $0x258
  80379f:	68 6d 42 80 00       	push   $0x80426d
  8037a4:	e8 94 ca ff ff       	call   80023d <_panic>

008037a9 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8037a9:	55                   	push   %ebp
  8037aa:	89 e5                	mov    %esp,%ebp
  8037ac:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8037af:	83 ec 04             	sub    $0x4,%esp
  8037b2:	68 8c 43 80 00       	push   $0x80438c
  8037b7:	68 61 02 00 00       	push   $0x261
  8037bc:	68 6d 42 80 00       	push   $0x80426d
  8037c1:	e8 77 ca ff ff       	call   80023d <_panic>
  8037c6:	66 90                	xchg   %ax,%ax

008037c8 <__udivdi3>:
  8037c8:	55                   	push   %ebp
  8037c9:	57                   	push   %edi
  8037ca:	56                   	push   %esi
  8037cb:	53                   	push   %ebx
  8037cc:	83 ec 1c             	sub    $0x1c,%esp
  8037cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037df:	89 ca                	mov    %ecx,%edx
  8037e1:	89 f8                	mov    %edi,%eax
  8037e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037e7:	85 f6                	test   %esi,%esi
  8037e9:	75 2d                	jne    803818 <__udivdi3+0x50>
  8037eb:	39 cf                	cmp    %ecx,%edi
  8037ed:	77 65                	ja     803854 <__udivdi3+0x8c>
  8037ef:	89 fd                	mov    %edi,%ebp
  8037f1:	85 ff                	test   %edi,%edi
  8037f3:	75 0b                	jne    803800 <__udivdi3+0x38>
  8037f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8037fa:	31 d2                	xor    %edx,%edx
  8037fc:	f7 f7                	div    %edi
  8037fe:	89 c5                	mov    %eax,%ebp
  803800:	31 d2                	xor    %edx,%edx
  803802:	89 c8                	mov    %ecx,%eax
  803804:	f7 f5                	div    %ebp
  803806:	89 c1                	mov    %eax,%ecx
  803808:	89 d8                	mov    %ebx,%eax
  80380a:	f7 f5                	div    %ebp
  80380c:	89 cf                	mov    %ecx,%edi
  80380e:	89 fa                	mov    %edi,%edx
  803810:	83 c4 1c             	add    $0x1c,%esp
  803813:	5b                   	pop    %ebx
  803814:	5e                   	pop    %esi
  803815:	5f                   	pop    %edi
  803816:	5d                   	pop    %ebp
  803817:	c3                   	ret    
  803818:	39 ce                	cmp    %ecx,%esi
  80381a:	77 28                	ja     803844 <__udivdi3+0x7c>
  80381c:	0f bd fe             	bsr    %esi,%edi
  80381f:	83 f7 1f             	xor    $0x1f,%edi
  803822:	75 40                	jne    803864 <__udivdi3+0x9c>
  803824:	39 ce                	cmp    %ecx,%esi
  803826:	72 0a                	jb     803832 <__udivdi3+0x6a>
  803828:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80382c:	0f 87 9e 00 00 00    	ja     8038d0 <__udivdi3+0x108>
  803832:	b8 01 00 00 00       	mov    $0x1,%eax
  803837:	89 fa                	mov    %edi,%edx
  803839:	83 c4 1c             	add    $0x1c,%esp
  80383c:	5b                   	pop    %ebx
  80383d:	5e                   	pop    %esi
  80383e:	5f                   	pop    %edi
  80383f:	5d                   	pop    %ebp
  803840:	c3                   	ret    
  803841:	8d 76 00             	lea    0x0(%esi),%esi
  803844:	31 ff                	xor    %edi,%edi
  803846:	31 c0                	xor    %eax,%eax
  803848:	89 fa                	mov    %edi,%edx
  80384a:	83 c4 1c             	add    $0x1c,%esp
  80384d:	5b                   	pop    %ebx
  80384e:	5e                   	pop    %esi
  80384f:	5f                   	pop    %edi
  803850:	5d                   	pop    %ebp
  803851:	c3                   	ret    
  803852:	66 90                	xchg   %ax,%ax
  803854:	89 d8                	mov    %ebx,%eax
  803856:	f7 f7                	div    %edi
  803858:	31 ff                	xor    %edi,%edi
  80385a:	89 fa                	mov    %edi,%edx
  80385c:	83 c4 1c             	add    $0x1c,%esp
  80385f:	5b                   	pop    %ebx
  803860:	5e                   	pop    %esi
  803861:	5f                   	pop    %edi
  803862:	5d                   	pop    %ebp
  803863:	c3                   	ret    
  803864:	bd 20 00 00 00       	mov    $0x20,%ebp
  803869:	89 eb                	mov    %ebp,%ebx
  80386b:	29 fb                	sub    %edi,%ebx
  80386d:	89 f9                	mov    %edi,%ecx
  80386f:	d3 e6                	shl    %cl,%esi
  803871:	89 c5                	mov    %eax,%ebp
  803873:	88 d9                	mov    %bl,%cl
  803875:	d3 ed                	shr    %cl,%ebp
  803877:	89 e9                	mov    %ebp,%ecx
  803879:	09 f1                	or     %esi,%ecx
  80387b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80387f:	89 f9                	mov    %edi,%ecx
  803881:	d3 e0                	shl    %cl,%eax
  803883:	89 c5                	mov    %eax,%ebp
  803885:	89 d6                	mov    %edx,%esi
  803887:	88 d9                	mov    %bl,%cl
  803889:	d3 ee                	shr    %cl,%esi
  80388b:	89 f9                	mov    %edi,%ecx
  80388d:	d3 e2                	shl    %cl,%edx
  80388f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803893:	88 d9                	mov    %bl,%cl
  803895:	d3 e8                	shr    %cl,%eax
  803897:	09 c2                	or     %eax,%edx
  803899:	89 d0                	mov    %edx,%eax
  80389b:	89 f2                	mov    %esi,%edx
  80389d:	f7 74 24 0c          	divl   0xc(%esp)
  8038a1:	89 d6                	mov    %edx,%esi
  8038a3:	89 c3                	mov    %eax,%ebx
  8038a5:	f7 e5                	mul    %ebp
  8038a7:	39 d6                	cmp    %edx,%esi
  8038a9:	72 19                	jb     8038c4 <__udivdi3+0xfc>
  8038ab:	74 0b                	je     8038b8 <__udivdi3+0xf0>
  8038ad:	89 d8                	mov    %ebx,%eax
  8038af:	31 ff                	xor    %edi,%edi
  8038b1:	e9 58 ff ff ff       	jmp    80380e <__udivdi3+0x46>
  8038b6:	66 90                	xchg   %ax,%ax
  8038b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038bc:	89 f9                	mov    %edi,%ecx
  8038be:	d3 e2                	shl    %cl,%edx
  8038c0:	39 c2                	cmp    %eax,%edx
  8038c2:	73 e9                	jae    8038ad <__udivdi3+0xe5>
  8038c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038c7:	31 ff                	xor    %edi,%edi
  8038c9:	e9 40 ff ff ff       	jmp    80380e <__udivdi3+0x46>
  8038ce:	66 90                	xchg   %ax,%ax
  8038d0:	31 c0                	xor    %eax,%eax
  8038d2:	e9 37 ff ff ff       	jmp    80380e <__udivdi3+0x46>
  8038d7:	90                   	nop

008038d8 <__umoddi3>:
  8038d8:	55                   	push   %ebp
  8038d9:	57                   	push   %edi
  8038da:	56                   	push   %esi
  8038db:	53                   	push   %ebx
  8038dc:	83 ec 1c             	sub    $0x1c,%esp
  8038df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038f7:	89 f3                	mov    %esi,%ebx
  8038f9:	89 fa                	mov    %edi,%edx
  8038fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038ff:	89 34 24             	mov    %esi,(%esp)
  803902:	85 c0                	test   %eax,%eax
  803904:	75 1a                	jne    803920 <__umoddi3+0x48>
  803906:	39 f7                	cmp    %esi,%edi
  803908:	0f 86 a2 00 00 00    	jbe    8039b0 <__umoddi3+0xd8>
  80390e:	89 c8                	mov    %ecx,%eax
  803910:	89 f2                	mov    %esi,%edx
  803912:	f7 f7                	div    %edi
  803914:	89 d0                	mov    %edx,%eax
  803916:	31 d2                	xor    %edx,%edx
  803918:	83 c4 1c             	add    $0x1c,%esp
  80391b:	5b                   	pop    %ebx
  80391c:	5e                   	pop    %esi
  80391d:	5f                   	pop    %edi
  80391e:	5d                   	pop    %ebp
  80391f:	c3                   	ret    
  803920:	39 f0                	cmp    %esi,%eax
  803922:	0f 87 ac 00 00 00    	ja     8039d4 <__umoddi3+0xfc>
  803928:	0f bd e8             	bsr    %eax,%ebp
  80392b:	83 f5 1f             	xor    $0x1f,%ebp
  80392e:	0f 84 ac 00 00 00    	je     8039e0 <__umoddi3+0x108>
  803934:	bf 20 00 00 00       	mov    $0x20,%edi
  803939:	29 ef                	sub    %ebp,%edi
  80393b:	89 fe                	mov    %edi,%esi
  80393d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803941:	89 e9                	mov    %ebp,%ecx
  803943:	d3 e0                	shl    %cl,%eax
  803945:	89 d7                	mov    %edx,%edi
  803947:	89 f1                	mov    %esi,%ecx
  803949:	d3 ef                	shr    %cl,%edi
  80394b:	09 c7                	or     %eax,%edi
  80394d:	89 e9                	mov    %ebp,%ecx
  80394f:	d3 e2                	shl    %cl,%edx
  803951:	89 14 24             	mov    %edx,(%esp)
  803954:	89 d8                	mov    %ebx,%eax
  803956:	d3 e0                	shl    %cl,%eax
  803958:	89 c2                	mov    %eax,%edx
  80395a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80395e:	d3 e0                	shl    %cl,%eax
  803960:	89 44 24 04          	mov    %eax,0x4(%esp)
  803964:	8b 44 24 08          	mov    0x8(%esp),%eax
  803968:	89 f1                	mov    %esi,%ecx
  80396a:	d3 e8                	shr    %cl,%eax
  80396c:	09 d0                	or     %edx,%eax
  80396e:	d3 eb                	shr    %cl,%ebx
  803970:	89 da                	mov    %ebx,%edx
  803972:	f7 f7                	div    %edi
  803974:	89 d3                	mov    %edx,%ebx
  803976:	f7 24 24             	mull   (%esp)
  803979:	89 c6                	mov    %eax,%esi
  80397b:	89 d1                	mov    %edx,%ecx
  80397d:	39 d3                	cmp    %edx,%ebx
  80397f:	0f 82 87 00 00 00    	jb     803a0c <__umoddi3+0x134>
  803985:	0f 84 91 00 00 00    	je     803a1c <__umoddi3+0x144>
  80398b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80398f:	29 f2                	sub    %esi,%edx
  803991:	19 cb                	sbb    %ecx,%ebx
  803993:	89 d8                	mov    %ebx,%eax
  803995:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803999:	d3 e0                	shl    %cl,%eax
  80399b:	89 e9                	mov    %ebp,%ecx
  80399d:	d3 ea                	shr    %cl,%edx
  80399f:	09 d0                	or     %edx,%eax
  8039a1:	89 e9                	mov    %ebp,%ecx
  8039a3:	d3 eb                	shr    %cl,%ebx
  8039a5:	89 da                	mov    %ebx,%edx
  8039a7:	83 c4 1c             	add    $0x1c,%esp
  8039aa:	5b                   	pop    %ebx
  8039ab:	5e                   	pop    %esi
  8039ac:	5f                   	pop    %edi
  8039ad:	5d                   	pop    %ebp
  8039ae:	c3                   	ret    
  8039af:	90                   	nop
  8039b0:	89 fd                	mov    %edi,%ebp
  8039b2:	85 ff                	test   %edi,%edi
  8039b4:	75 0b                	jne    8039c1 <__umoddi3+0xe9>
  8039b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039bb:	31 d2                	xor    %edx,%edx
  8039bd:	f7 f7                	div    %edi
  8039bf:	89 c5                	mov    %eax,%ebp
  8039c1:	89 f0                	mov    %esi,%eax
  8039c3:	31 d2                	xor    %edx,%edx
  8039c5:	f7 f5                	div    %ebp
  8039c7:	89 c8                	mov    %ecx,%eax
  8039c9:	f7 f5                	div    %ebp
  8039cb:	89 d0                	mov    %edx,%eax
  8039cd:	e9 44 ff ff ff       	jmp    803916 <__umoddi3+0x3e>
  8039d2:	66 90                	xchg   %ax,%ax
  8039d4:	89 c8                	mov    %ecx,%eax
  8039d6:	89 f2                	mov    %esi,%edx
  8039d8:	83 c4 1c             	add    $0x1c,%esp
  8039db:	5b                   	pop    %ebx
  8039dc:	5e                   	pop    %esi
  8039dd:	5f                   	pop    %edi
  8039de:	5d                   	pop    %ebp
  8039df:	c3                   	ret    
  8039e0:	3b 04 24             	cmp    (%esp),%eax
  8039e3:	72 06                	jb     8039eb <__umoddi3+0x113>
  8039e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039e9:	77 0f                	ja     8039fa <__umoddi3+0x122>
  8039eb:	89 f2                	mov    %esi,%edx
  8039ed:	29 f9                	sub    %edi,%ecx
  8039ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039f3:	89 14 24             	mov    %edx,(%esp)
  8039f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039fe:	8b 14 24             	mov    (%esp),%edx
  803a01:	83 c4 1c             	add    $0x1c,%esp
  803a04:	5b                   	pop    %ebx
  803a05:	5e                   	pop    %esi
  803a06:	5f                   	pop    %edi
  803a07:	5d                   	pop    %ebp
  803a08:	c3                   	ret    
  803a09:	8d 76 00             	lea    0x0(%esi),%esi
  803a0c:	2b 04 24             	sub    (%esp),%eax
  803a0f:	19 fa                	sbb    %edi,%edx
  803a11:	89 d1                	mov    %edx,%ecx
  803a13:	89 c6                	mov    %eax,%esi
  803a15:	e9 71 ff ff ff       	jmp    80398b <__umoddi3+0xb3>
  803a1a:	66 90                	xchg   %ax,%ax
  803a1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a20:	72 ea                	jb     803a0c <__umoddi3+0x134>
  803a22:	89 d9                	mov    %ebx,%ecx
  803a24:	e9 62 ff ff ff       	jmp    80398b <__umoddi3+0xb3>
