
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
  800073:	e8 e6 19 00 00       	call   801a5e <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 d7 3a 80 00       	push   $0x803ad7
  800080:	50                   	push   %eax
  800081:	e8 c0 15 00 00       	call   801646 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80008c:	e8 eb 17 00 00       	call   80187c <sys_calculate_free_frames>
  800091:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 dc 3a 80 00       	push   $0x803adc
  80009c:	e8 59 04 00 00       	call   8004fa <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000aa:	e8 1c 16 00 00       	call   8016cb <sfree>
  8000af:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave env removed x\n");
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 00 3b 80 00       	push   $0x803b00
  8000ba:	e8 3b 04 00 00       	call   8004fa <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp

	diff = (sys_calculate_free_frames() - freeFrames);
  8000c2:	e8 b5 17 00 00       	call   80187c <sys_calculate_free_frames>
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
  8000f6:	e8 88 1a 00 00       	call   801b83 <inctst>

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
  800104:	e8 3c 19 00 00       	call   801a45 <sys_getenvindex>
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
  800172:	e8 52 16 00 00       	call   8017c9 <sys_lock_cons>
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
  80020c:	e8 d2 15 00 00       	call   8017e3 <sys_unlock_cons>
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
  800224:	e8 e8 17 00 00       	call   801a11 <sys_destroy_env>
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
  800235:	e8 3d 18 00 00       	call   801a77 <sys_exit_env>
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
  80046c:	e8 16 13 00 00       	call   801787 <sys_cputs>
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
  8004e3:	e8 9f 12 00 00       	call   801787 <sys_cputs>
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
  80052d:	e8 97 12 00 00       	call   8017c9 <sys_lock_cons>
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
  80054d:	e8 91 12 00 00       	call   8017e3 <sys_unlock_cons>
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
  800597:	e8 84 32 00 00       	call   803820 <__udivdi3>
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
  8005e7:	e8 44 33 00 00       	call   803930 <__umoddi3>
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
  8012a0:	e8 8d 0a 00 00       	call   801d32 <sys_sbrk>
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
  80131b:	e8 96 08 00 00       	call   801bb6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801320:	85 c0                	test   %eax,%eax
  801322:	74 16                	je     80133a <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801324:	83 ec 0c             	sub    $0xc,%esp
  801327:	ff 75 08             	pushl  0x8(%ebp)
  80132a:	e8 d6 0d 00 00       	call   802105 <alloc_block_FF>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801335:	e9 8a 01 00 00       	jmp    8014c4 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80133a:	e8 a8 08 00 00       	call   801be7 <sys_isUHeapPlacementStrategyBESTFIT>
  80133f:	85 c0                	test   %eax,%eax
  801341:	0f 84 7d 01 00 00    	je     8014c4 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801347:	83 ec 0c             	sub    $0xc,%esp
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	e8 6f 12 00 00       	call   8025c1 <alloc_block_BF>
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
  8014b3:	e8 b1 08 00 00       	call   801d69 <sys_allocate_user_mem>
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
  8014fb:	e8 85 08 00 00       	call   801d85 <get_block_size>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801506:	83 ec 0c             	sub    $0xc,%esp
  801509:	ff 75 08             	pushl  0x8(%ebp)
  80150c:	e8 b8 1a 00 00       	call   802fc9 <free_block>
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
  8015a3:	e8 a5 07 00 00       	call   801d4d <sys_free_user_mem>
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
  8015de:	eb 64                	jmp    801644 <smalloc+0x7d>
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
  801613:	eb 2f                	jmp    801644 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801615:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801619:	ff 75 ec             	pushl  -0x14(%ebp)
  80161c:	50                   	push   %eax
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	ff 75 08             	pushl  0x8(%ebp)
  801623:	e8 2c 03 00 00       	call   801954 <sys_createSharedObject>
  801628:	83 c4 10             	add    $0x10,%esp
  80162b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80162e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801632:	74 06                	je     80163a <smalloc+0x73>
  801634:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801638:	75 07                	jne    801641 <smalloc+0x7a>
  80163a:	b8 00 00 00 00       	mov    $0x0,%eax
  80163f:	eb 03                	jmp    801644 <smalloc+0x7d>
	 return ptr;
  801641:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 0c             	pushl  0xc(%ebp)
  801652:	ff 75 08             	pushl  0x8(%ebp)
  801655:	e8 24 03 00 00       	call   80197e <sys_getSizeOfSharedObject>
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801660:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801664:	75 07                	jne    80166d <sget+0x27>
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
  80166b:	eb 5c                	jmp    8016c9 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801670:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801673:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80167a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801680:	39 d0                	cmp    %edx,%eax
  801682:	7d 02                	jge    801686 <sget+0x40>
  801684:	89 d0                	mov    %edx,%eax
  801686:	83 ec 0c             	sub    $0xc,%esp
  801689:	50                   	push   %eax
  80168a:	e8 1b fc ff ff       	call   8012aa <malloc>
  80168f:	83 c4 10             	add    $0x10,%esp
  801692:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801695:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801699:	75 07                	jne    8016a2 <sget+0x5c>
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a0:	eb 27                	jmp    8016c9 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8016a2:	83 ec 04             	sub    $0x4,%esp
  8016a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	ff 75 08             	pushl  0x8(%ebp)
  8016ae:	e8 e8 02 00 00       	call   80199b <sys_getSharedObject>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8016b9:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8016bd:	75 07                	jne    8016c6 <sget+0x80>
  8016bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c4:	eb 03                	jmp    8016c9 <sget+0x83>
	return ptr;
  8016c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	68 b0 41 80 00       	push   $0x8041b0
  8016d9:	68 c1 00 00 00       	push   $0xc1
  8016de:	68 a2 41 80 00       	push   $0x8041a2
  8016e3:	e8 55 eb ff ff       	call   80023d <_panic>

008016e8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	68 d4 41 80 00       	push   $0x8041d4
  8016f6:	68 d8 00 00 00       	push   $0xd8
  8016fb:	68 a2 41 80 00       	push   $0x8041a2
  801700:	e8 38 eb ff ff       	call   80023d <_panic>

00801705 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80170b:	83 ec 04             	sub    $0x4,%esp
  80170e:	68 fa 41 80 00       	push   $0x8041fa
  801713:	68 e4 00 00 00       	push   $0xe4
  801718:	68 a2 41 80 00       	push   $0x8041a2
  80171d:	e8 1b eb ff ff       	call   80023d <_panic>

00801722 <shrink>:

}
void shrink(uint32 newSize)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801728:	83 ec 04             	sub    $0x4,%esp
  80172b:	68 fa 41 80 00       	push   $0x8041fa
  801730:	68 e9 00 00 00       	push   $0xe9
  801735:	68 a2 41 80 00       	push   $0x8041a2
  80173a:	e8 fe ea ff ff       	call   80023d <_panic>

0080173f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	68 fa 41 80 00       	push   $0x8041fa
  80174d:	68 ee 00 00 00       	push   $0xee
  801752:	68 a2 41 80 00       	push   $0x8041a2
  801757:	e8 e1 ea ff ff       	call   80023d <_panic>

0080175c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	57                   	push   %edi
  801760:	56                   	push   %esi
  801761:	53                   	push   %ebx
  801762:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80176e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801771:	8b 7d 18             	mov    0x18(%ebp),%edi
  801774:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801777:	cd 30                	int    $0x30
  801779:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80177c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	5b                   	pop    %ebx
  801783:	5e                   	pop    %esi
  801784:	5f                   	pop    %edi
  801785:	5d                   	pop    %ebp
  801786:	c3                   	ret    

00801787 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	8b 45 10             	mov    0x10(%ebp),%eax
  801790:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801793:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	52                   	push   %edx
  80179f:	ff 75 0c             	pushl  0xc(%ebp)
  8017a2:	50                   	push   %eax
  8017a3:	6a 00                	push   $0x0
  8017a5:	e8 b2 ff ff ff       	call   80175c <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	90                   	nop
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 02                	push   $0x2
  8017bf:	e8 98 ff ff ff       	call   80175c <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 03                	push   $0x3
  8017d8:	e8 7f ff ff ff       	call   80175c <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	90                   	nop
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 04                	push   $0x4
  8017f2:	e8 65 ff ff ff       	call   80175c <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	90                   	nop
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801800:	8b 55 0c             	mov    0xc(%ebp),%edx
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	52                   	push   %edx
  80180d:	50                   	push   %eax
  80180e:	6a 08                	push   $0x8
  801810:	e8 47 ff ff ff       	call   80175c <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	56                   	push   %esi
  80181e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80181f:	8b 75 18             	mov    0x18(%ebp),%esi
  801822:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801825:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	56                   	push   %esi
  80182f:	53                   	push   %ebx
  801830:	51                   	push   %ecx
  801831:	52                   	push   %edx
  801832:	50                   	push   %eax
  801833:	6a 09                	push   $0x9
  801835:	e8 22 ff ff ff       	call   80175c <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801840:	5b                   	pop    %ebx
  801841:	5e                   	pop    %esi
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    

00801844 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	52                   	push   %edx
  801854:	50                   	push   %eax
  801855:	6a 0a                	push   $0xa
  801857:	e8 00 ff ff ff       	call   80175c <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	ff 75 08             	pushl  0x8(%ebp)
  801870:	6a 0b                	push   $0xb
  801872:	e8 e5 fe ff ff       	call   80175c <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 0c                	push   $0xc
  80188b:	e8 cc fe ff ff       	call   80175c <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 0d                	push   $0xd
  8018a4:	e8 b3 fe ff ff       	call   80175c <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 0e                	push   $0xe
  8018bd:	e8 9a fe ff ff       	call   80175c <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 0f                	push   $0xf
  8018d6:	e8 81 fe ff ff       	call   80175c <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	6a 10                	push   $0x10
  8018f0:	e8 67 fe ff ff       	call   80175c <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 11                	push   $0x11
  801909:	e8 4e fe ff ff       	call   80175c <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	90                   	nop
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_cputc>:

void
sys_cputc(const char c)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 04             	sub    $0x4,%esp
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801920:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	50                   	push   %eax
  80192d:	6a 01                	push   $0x1
  80192f:	e8 28 fe ff ff       	call   80175c <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	90                   	nop
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 14                	push   $0x14
  801949:	e8 0e fe ff ff       	call   80175c <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	90                   	nop
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	8b 45 10             	mov    0x10(%ebp),%eax
  80195d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801960:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801963:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	6a 00                	push   $0x0
  80196c:	51                   	push   %ecx
  80196d:	52                   	push   %edx
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	50                   	push   %eax
  801972:	6a 15                	push   $0x15
  801974:	e8 e3 fd ff ff       	call   80175c <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801981:	8b 55 0c             	mov    0xc(%ebp),%edx
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	52                   	push   %edx
  80198e:	50                   	push   %eax
  80198f:	6a 16                	push   $0x16
  801991:	e8 c6 fd ff ff       	call   80175c <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80199e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	51                   	push   %ecx
  8019ac:	52                   	push   %edx
  8019ad:	50                   	push   %eax
  8019ae:	6a 17                	push   $0x17
  8019b0:	e8 a7 fd ff ff       	call   80175c <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	52                   	push   %edx
  8019ca:	50                   	push   %eax
  8019cb:	6a 18                	push   $0x18
  8019cd:	e8 8a fd ff ff       	call   80175c <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	6a 00                	push   $0x0
  8019df:	ff 75 14             	pushl  0x14(%ebp)
  8019e2:	ff 75 10             	pushl  0x10(%ebp)
  8019e5:	ff 75 0c             	pushl  0xc(%ebp)
  8019e8:	50                   	push   %eax
  8019e9:	6a 19                	push   $0x19
  8019eb:	e8 6c fd ff ff       	call   80175c <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	50                   	push   %eax
  801a04:	6a 1a                	push   $0x1a
  801a06:	e8 51 fd ff ff       	call   80175c <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	90                   	nop
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	50                   	push   %eax
  801a20:	6a 1b                	push   $0x1b
  801a22:	e8 35 fd ff ff       	call   80175c <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 05                	push   $0x5
  801a3b:	e8 1c fd ff ff       	call   80175c <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 06                	push   $0x6
  801a54:	e8 03 fd ff ff       	call   80175c <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 07                	push   $0x7
  801a6d:	e8 ea fc ff ff       	call   80175c <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_exit_env>:


void sys_exit_env(void)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 1c                	push   $0x1c
  801a86:	e8 d1 fc ff ff       	call   80175c <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	90                   	nop
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a97:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a9a:	8d 50 04             	lea    0x4(%eax),%edx
  801a9d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	52                   	push   %edx
  801aa7:	50                   	push   %eax
  801aa8:	6a 1d                	push   $0x1d
  801aaa:	e8 ad fc ff ff       	call   80175c <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
	return result;
  801ab2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ab8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801abb:	89 01                	mov    %eax,(%ecx)
  801abd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	c9                   	leave  
  801ac4:	c2 04 00             	ret    $0x4

00801ac7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	ff 75 10             	pushl  0x10(%ebp)
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	ff 75 08             	pushl  0x8(%ebp)
  801ad7:	6a 13                	push   $0x13
  801ad9:	e8 7e fc ff ff       	call   80175c <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae1:	90                   	nop
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 1e                	push   $0x1e
  801af3:	e8 64 fc ff ff       	call   80175c <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	83 ec 04             	sub    $0x4,%esp
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b09:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	50                   	push   %eax
  801b16:	6a 1f                	push   $0x1f
  801b18:	e8 3f fc ff ff       	call   80175c <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b20:	90                   	nop
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <rsttst>:
void rsttst()
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 21                	push   $0x21
  801b32:	e8 25 fc ff ff       	call   80175c <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3a:	90                   	nop
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 04             	sub    $0x4,%esp
  801b43:	8b 45 14             	mov    0x14(%ebp),%eax
  801b46:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b49:	8b 55 18             	mov    0x18(%ebp),%edx
  801b4c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b50:	52                   	push   %edx
  801b51:	50                   	push   %eax
  801b52:	ff 75 10             	pushl  0x10(%ebp)
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	ff 75 08             	pushl  0x8(%ebp)
  801b5b:	6a 20                	push   $0x20
  801b5d:	e8 fa fb ff ff       	call   80175c <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
	return ;
  801b65:	90                   	nop
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <chktst>:
void chktst(uint32 n)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	ff 75 08             	pushl  0x8(%ebp)
  801b76:	6a 22                	push   $0x22
  801b78:	e8 df fb ff ff       	call   80175c <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b80:	90                   	nop
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <inctst>:

void inctst()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 23                	push   $0x23
  801b92:	e8 c5 fb ff ff       	call   80175c <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9a:	90                   	nop
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <gettst>:
uint32 gettst()
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 24                	push   $0x24
  801bac:	e8 ab fb ff ff       	call   80175c <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 25                	push   $0x25
  801bc8:	e8 8f fb ff ff       	call   80175c <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
  801bd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bd3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bd7:	75 07                	jne    801be0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bde:	eb 05                	jmp    801be5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801be0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 25                	push   $0x25
  801bf9:	e8 5e fb ff ff       	call   80175c <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
  801c01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c04:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c08:	75 07                	jne    801c11 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0f:	eb 05                	jmp    801c16 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 25                	push   $0x25
  801c2a:	e8 2d fb ff ff       	call   80175c <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
  801c32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c35:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c39:	75 07                	jne    801c42 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c40:	eb 05                	jmp    801c47 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 25                	push   $0x25
  801c5b:	e8 fc fa ff ff       	call   80175c <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
  801c63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c66:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c6a:	75 07                	jne    801c73 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c71:	eb 05                	jmp    801c78 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	ff 75 08             	pushl  0x8(%ebp)
  801c88:	6a 26                	push   $0x26
  801c8a:	e8 cd fa ff ff       	call   80175c <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c92:	90                   	nop
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c99:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	6a 00                	push   $0x0
  801ca7:	53                   	push   %ebx
  801ca8:	51                   	push   %ecx
  801ca9:	52                   	push   %edx
  801caa:	50                   	push   %eax
  801cab:	6a 27                	push   $0x27
  801cad:	e8 aa fa ff ff       	call   80175c <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	52                   	push   %edx
  801cca:	50                   	push   %eax
  801ccb:	6a 28                	push   $0x28
  801ccd:	e8 8a fa ff ff       	call   80175c <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cda:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	51                   	push   %ecx
  801ce6:	ff 75 10             	pushl  0x10(%ebp)
  801ce9:	52                   	push   %edx
  801cea:	50                   	push   %eax
  801ceb:	6a 29                	push   $0x29
  801ced:	e8 6a fa ff ff       	call   80175c <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	ff 75 10             	pushl  0x10(%ebp)
  801d01:	ff 75 0c             	pushl  0xc(%ebp)
  801d04:	ff 75 08             	pushl  0x8(%ebp)
  801d07:	6a 12                	push   $0x12
  801d09:	e8 4e fa ff ff       	call   80175c <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d11:	90                   	nop
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 2a                	push   $0x2a
  801d27:	e8 30 fa ff ff       	call   80175c <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
	return;
  801d2f:	90                   	nop
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	50                   	push   %eax
  801d41:	6a 2b                	push   $0x2b
  801d43:	e8 14 fa ff ff       	call   80175c <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	ff 75 0c             	pushl  0xc(%ebp)
  801d59:	ff 75 08             	pushl  0x8(%ebp)
  801d5c:	6a 2c                	push   $0x2c
  801d5e:	e8 f9 f9 ff ff       	call   80175c <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
	return;
  801d66:	90                   	nop
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	ff 75 0c             	pushl  0xc(%ebp)
  801d75:	ff 75 08             	pushl  0x8(%ebp)
  801d78:	6a 2d                	push   $0x2d
  801d7a:	e8 dd f9 ff ff       	call   80175c <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	83 e8 04             	sub    $0x4,%eax
  801d91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d97:	8b 00                	mov    (%eax),%eax
  801d99:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	83 e8 04             	sub    $0x4,%eax
  801daa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801dad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801db0:	8b 00                	mov    (%eax),%eax
  801db2:	83 e0 01             	and    $0x1,%eax
  801db5:	85 c0                	test   %eax,%eax
  801db7:	0f 94 c0             	sete   %al
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801dc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcc:	83 f8 02             	cmp    $0x2,%eax
  801dcf:	74 2b                	je     801dfc <alloc_block+0x40>
  801dd1:	83 f8 02             	cmp    $0x2,%eax
  801dd4:	7f 07                	jg     801ddd <alloc_block+0x21>
  801dd6:	83 f8 01             	cmp    $0x1,%eax
  801dd9:	74 0e                	je     801de9 <alloc_block+0x2d>
  801ddb:	eb 58                	jmp    801e35 <alloc_block+0x79>
  801ddd:	83 f8 03             	cmp    $0x3,%eax
  801de0:	74 2d                	je     801e0f <alloc_block+0x53>
  801de2:	83 f8 04             	cmp    $0x4,%eax
  801de5:	74 3b                	je     801e22 <alloc_block+0x66>
  801de7:	eb 4c                	jmp    801e35 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801de9:	83 ec 0c             	sub    $0xc,%esp
  801dec:	ff 75 08             	pushl  0x8(%ebp)
  801def:	e8 11 03 00 00       	call   802105 <alloc_block_FF>
  801df4:	83 c4 10             	add    $0x10,%esp
  801df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dfa:	eb 4a                	jmp    801e46 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801dfc:	83 ec 0c             	sub    $0xc,%esp
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	e8 fa 19 00 00       	call   803801 <alloc_block_NF>
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e0d:	eb 37                	jmp    801e46 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e0f:	83 ec 0c             	sub    $0xc,%esp
  801e12:	ff 75 08             	pushl  0x8(%ebp)
  801e15:	e8 a7 07 00 00       	call   8025c1 <alloc_block_BF>
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e20:	eb 24                	jmp    801e46 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e22:	83 ec 0c             	sub    $0xc,%esp
  801e25:	ff 75 08             	pushl  0x8(%ebp)
  801e28:	e8 b7 19 00 00       	call   8037e4 <alloc_block_WF>
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e33:	eb 11                	jmp    801e46 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	68 0c 42 80 00       	push   $0x80420c
  801e3d:	e8 b8 e6 ff ff       	call   8004fa <cprintf>
  801e42:	83 c4 10             	add    $0x10,%esp
		break;
  801e45:	90                   	nop
	}
	return va;
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	53                   	push   %ebx
  801e4f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e52:	83 ec 0c             	sub    $0xc,%esp
  801e55:	68 2c 42 80 00       	push   $0x80422c
  801e5a:	e8 9b e6 ff ff       	call   8004fa <cprintf>
  801e5f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	68 57 42 80 00       	push   $0x804257
  801e6a:	e8 8b e6 ff ff       	call   8004fa <cprintf>
  801e6f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e78:	eb 37                	jmp    801eb1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e7a:	83 ec 0c             	sub    $0xc,%esp
  801e7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e80:	e8 19 ff ff ff       	call   801d9e <is_free_block>
  801e85:	83 c4 10             	add    $0x10,%esp
  801e88:	0f be d8             	movsbl %al,%ebx
  801e8b:	83 ec 0c             	sub    $0xc,%esp
  801e8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e91:	e8 ef fe ff ff       	call   801d85 <get_block_size>
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	83 ec 04             	sub    $0x4,%esp
  801e9c:	53                   	push   %ebx
  801e9d:	50                   	push   %eax
  801e9e:	68 6f 42 80 00       	push   $0x80426f
  801ea3:	e8 52 e6 ff ff       	call   8004fa <cprintf>
  801ea8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801eab:	8b 45 10             	mov    0x10(%ebp),%eax
  801eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb5:	74 07                	je     801ebe <print_blocks_list+0x73>
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	8b 00                	mov    (%eax),%eax
  801ebc:	eb 05                	jmp    801ec3 <print_blocks_list+0x78>
  801ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec3:	89 45 10             	mov    %eax,0x10(%ebp)
  801ec6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	75 ad                	jne    801e7a <print_blocks_list+0x2f>
  801ecd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed1:	75 a7                	jne    801e7a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	68 2c 42 80 00       	push   $0x80422c
  801edb:	e8 1a e6 ff ff       	call   8004fa <cprintf>
  801ee0:	83 c4 10             	add    $0x10,%esp

}
  801ee3:	90                   	nop
  801ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef2:	83 e0 01             	and    $0x1,%eax
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	74 03                	je     801efc <initialize_dynamic_allocator+0x13>
  801ef9:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801efc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f00:	0f 84 c7 01 00 00    	je     8020cd <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f06:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f0d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f10:	8b 55 08             	mov    0x8(%ebp),%edx
  801f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f16:	01 d0                	add    %edx,%eax
  801f18:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f1d:	0f 87 ad 01 00 00    	ja     8020d0 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	85 c0                	test   %eax,%eax
  801f28:	0f 89 a5 01 00 00    	jns    8020d3 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f34:	01 d0                	add    %edx,%eax
  801f36:	83 e8 04             	sub    $0x4,%eax
  801f39:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f45:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4d:	e9 87 00 00 00       	jmp    801fd9 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f56:	75 14                	jne    801f6c <initialize_dynamic_allocator+0x83>
  801f58:	83 ec 04             	sub    $0x4,%esp
  801f5b:	68 87 42 80 00       	push   $0x804287
  801f60:	6a 79                	push   $0x79
  801f62:	68 a5 42 80 00       	push   $0x8042a5
  801f67:	e8 d1 e2 ff ff       	call   80023d <_panic>
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 00                	mov    (%eax),%eax
  801f71:	85 c0                	test   %eax,%eax
  801f73:	74 10                	je     801f85 <initialize_dynamic_allocator+0x9c>
  801f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f78:	8b 00                	mov    (%eax),%eax
  801f7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7d:	8b 52 04             	mov    0x4(%edx),%edx
  801f80:	89 50 04             	mov    %edx,0x4(%eax)
  801f83:	eb 0b                	jmp    801f90 <initialize_dynamic_allocator+0xa7>
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	8b 40 04             	mov    0x4(%eax),%eax
  801f8b:	a3 30 50 80 00       	mov    %eax,0x805030
  801f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f93:	8b 40 04             	mov    0x4(%eax),%eax
  801f96:	85 c0                	test   %eax,%eax
  801f98:	74 0f                	je     801fa9 <initialize_dynamic_allocator+0xc0>
  801f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9d:	8b 40 04             	mov    0x4(%eax),%eax
  801fa0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa3:	8b 12                	mov    (%edx),%edx
  801fa5:	89 10                	mov    %edx,(%eax)
  801fa7:	eb 0a                	jmp    801fb3 <initialize_dynamic_allocator+0xca>
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	8b 00                	mov    (%eax),%eax
  801fae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc6:	a1 38 50 80 00       	mov    0x805038,%eax
  801fcb:	48                   	dec    %eax
  801fcc:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801fd1:	a1 34 50 80 00       	mov    0x805034,%eax
  801fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fdd:	74 07                	je     801fe6 <initialize_dynamic_allocator+0xfd>
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	8b 00                	mov    (%eax),%eax
  801fe4:	eb 05                	jmp    801feb <initialize_dynamic_allocator+0x102>
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  801feb:	a3 34 50 80 00       	mov    %eax,0x805034
  801ff0:	a1 34 50 80 00       	mov    0x805034,%eax
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	0f 85 55 ff ff ff    	jne    801f52 <initialize_dynamic_allocator+0x69>
  801ffd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802001:	0f 85 4b ff ff ff    	jne    801f52 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80200d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802010:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802016:	a1 44 50 80 00       	mov    0x805044,%eax
  80201b:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802020:	a1 40 50 80 00       	mov    0x805040,%eax
  802025:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	83 c0 08             	add    $0x8,%eax
  802031:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	83 c0 04             	add    $0x4,%eax
  80203a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203d:	83 ea 08             	sub    $0x8,%edx
  802040:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802042:	8b 55 0c             	mov    0xc(%ebp),%edx
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	01 d0                	add    %edx,%eax
  80204a:	83 e8 08             	sub    $0x8,%eax
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	83 ea 08             	sub    $0x8,%edx
  802053:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802055:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80205e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802061:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802068:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80206c:	75 17                	jne    802085 <initialize_dynamic_allocator+0x19c>
  80206e:	83 ec 04             	sub    $0x4,%esp
  802071:	68 c0 42 80 00       	push   $0x8042c0
  802076:	68 90 00 00 00       	push   $0x90
  80207b:	68 a5 42 80 00       	push   $0x8042a5
  802080:	e8 b8 e1 ff ff       	call   80023d <_panic>
  802085:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80208b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208e:	89 10                	mov    %edx,(%eax)
  802090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802093:	8b 00                	mov    (%eax),%eax
  802095:	85 c0                	test   %eax,%eax
  802097:	74 0d                	je     8020a6 <initialize_dynamic_allocator+0x1bd>
  802099:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80209e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020a1:	89 50 04             	mov    %edx,0x4(%eax)
  8020a4:	eb 08                	jmp    8020ae <initialize_dynamic_allocator+0x1c5>
  8020a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8020ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8020c5:	40                   	inc    %eax
  8020c6:	a3 38 50 80 00       	mov    %eax,0x805038
  8020cb:	eb 07                	jmp    8020d4 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8020cd:	90                   	nop
  8020ce:	eb 04                	jmp    8020d4 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8020d0:	90                   	nop
  8020d1:	eb 01                	jmp    8020d4 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8020d3:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8020d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020dc:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8020e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e8:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	83 e8 04             	sub    $0x4,%eax
  8020f0:	8b 00                	mov    (%eax),%eax
  8020f2:	83 e0 fe             	and    $0xfffffffe,%eax
  8020f5:	8d 50 f8             	lea    -0x8(%eax),%edx
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	01 c2                	add    %eax,%edx
  8020fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802100:	89 02                	mov    %eax,(%edx)
}
  802102:	90                   	nop
  802103:	5d                   	pop    %ebp
  802104:	c3                   	ret    

00802105 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	83 e0 01             	and    $0x1,%eax
  802111:	85 c0                	test   %eax,%eax
  802113:	74 03                	je     802118 <alloc_block_FF+0x13>
  802115:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802118:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80211c:	77 07                	ja     802125 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80211e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802125:	a1 24 50 80 00       	mov    0x805024,%eax
  80212a:	85 c0                	test   %eax,%eax
  80212c:	75 73                	jne    8021a1 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	83 c0 10             	add    $0x10,%eax
  802134:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802137:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80213e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802144:	01 d0                	add    %edx,%eax
  802146:	48                   	dec    %eax
  802147:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80214a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80214d:	ba 00 00 00 00       	mov    $0x0,%edx
  802152:	f7 75 ec             	divl   -0x14(%ebp)
  802155:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802158:	29 d0                	sub    %edx,%eax
  80215a:	c1 e8 0c             	shr    $0xc,%eax
  80215d:	83 ec 0c             	sub    $0xc,%esp
  802160:	50                   	push   %eax
  802161:	e8 2e f1 ff ff       	call   801294 <sbrk>
  802166:	83 c4 10             	add    $0x10,%esp
  802169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80216c:	83 ec 0c             	sub    $0xc,%esp
  80216f:	6a 00                	push   $0x0
  802171:	e8 1e f1 ff ff       	call   801294 <sbrk>
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80217c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80217f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802182:	83 ec 08             	sub    $0x8,%esp
  802185:	50                   	push   %eax
  802186:	ff 75 e4             	pushl  -0x1c(%ebp)
  802189:	e8 5b fd ff ff       	call   801ee9 <initialize_dynamic_allocator>
  80218e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802191:	83 ec 0c             	sub    $0xc,%esp
  802194:	68 e3 42 80 00       	push   $0x8042e3
  802199:	e8 5c e3 ff ff       	call   8004fa <cprintf>
  80219e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8021a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a5:	75 0a                	jne    8021b1 <alloc_block_FF+0xac>
	        return NULL;
  8021a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ac:	e9 0e 04 00 00       	jmp    8025bf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8021b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8021b8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c0:	e9 f3 02 00 00       	jmp    8024b8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8021c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8021cb:	83 ec 0c             	sub    $0xc,%esp
  8021ce:	ff 75 bc             	pushl  -0x44(%ebp)
  8021d1:	e8 af fb ff ff       	call   801d85 <get_block_size>
  8021d6:	83 c4 10             	add    $0x10,%esp
  8021d9:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	83 c0 08             	add    $0x8,%eax
  8021e2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021e5:	0f 87 c5 02 00 00    	ja     8024b0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	83 c0 18             	add    $0x18,%eax
  8021f1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021f4:	0f 87 19 02 00 00    	ja     802413 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8021fa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021fd:	2b 45 08             	sub    0x8(%ebp),%eax
  802200:	83 e8 08             	sub    $0x8,%eax
  802203:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	8d 50 08             	lea    0x8(%eax),%edx
  80220c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80220f:	01 d0                	add    %edx,%eax
  802211:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	83 c0 08             	add    $0x8,%eax
  80221a:	83 ec 04             	sub    $0x4,%esp
  80221d:	6a 01                	push   $0x1
  80221f:	50                   	push   %eax
  802220:	ff 75 bc             	pushl  -0x44(%ebp)
  802223:	e8 ae fe ff ff       	call   8020d6 <set_block_data>
  802228:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222e:	8b 40 04             	mov    0x4(%eax),%eax
  802231:	85 c0                	test   %eax,%eax
  802233:	75 68                	jne    80229d <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802235:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802239:	75 17                	jne    802252 <alloc_block_FF+0x14d>
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	68 c0 42 80 00       	push   $0x8042c0
  802243:	68 d7 00 00 00       	push   $0xd7
  802248:	68 a5 42 80 00       	push   $0x8042a5
  80224d:	e8 eb df ff ff       	call   80023d <_panic>
  802252:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802258:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80225b:	89 10                	mov    %edx,(%eax)
  80225d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802260:	8b 00                	mov    (%eax),%eax
  802262:	85 c0                	test   %eax,%eax
  802264:	74 0d                	je     802273 <alloc_block_FF+0x16e>
  802266:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80226b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80226e:	89 50 04             	mov    %edx,0x4(%eax)
  802271:	eb 08                	jmp    80227b <alloc_block_FF+0x176>
  802273:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802276:	a3 30 50 80 00       	mov    %eax,0x805030
  80227b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80227e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802283:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802286:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80228d:	a1 38 50 80 00       	mov    0x805038,%eax
  802292:	40                   	inc    %eax
  802293:	a3 38 50 80 00       	mov    %eax,0x805038
  802298:	e9 dc 00 00 00       	jmp    802379 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a0:	8b 00                	mov    (%eax),%eax
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	75 65                	jne    80230b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022a6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022aa:	75 17                	jne    8022c3 <alloc_block_FF+0x1be>
  8022ac:	83 ec 04             	sub    $0x4,%esp
  8022af:	68 f4 42 80 00       	push   $0x8042f4
  8022b4:	68 db 00 00 00       	push   $0xdb
  8022b9:	68 a5 42 80 00       	push   $0x8042a5
  8022be:	e8 7a df ff ff       	call   80023d <_panic>
  8022c3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8022c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022cc:	89 50 04             	mov    %edx,0x4(%eax)
  8022cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d2:	8b 40 04             	mov    0x4(%eax),%eax
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	74 0c                	je     8022e5 <alloc_block_FF+0x1e0>
  8022d9:	a1 30 50 80 00       	mov    0x805030,%eax
  8022de:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022e1:	89 10                	mov    %edx,(%eax)
  8022e3:	eb 08                	jmp    8022ed <alloc_block_FF+0x1e8>
  8022e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8022f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022fe:	a1 38 50 80 00       	mov    0x805038,%eax
  802303:	40                   	inc    %eax
  802304:	a3 38 50 80 00       	mov    %eax,0x805038
  802309:	eb 6e                	jmp    802379 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80230b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230f:	74 06                	je     802317 <alloc_block_FF+0x212>
  802311:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802315:	75 17                	jne    80232e <alloc_block_FF+0x229>
  802317:	83 ec 04             	sub    $0x4,%esp
  80231a:	68 18 43 80 00       	push   $0x804318
  80231f:	68 df 00 00 00       	push   $0xdf
  802324:	68 a5 42 80 00       	push   $0x8042a5
  802329:	e8 0f df ff ff       	call   80023d <_panic>
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 10                	mov    (%eax),%edx
  802333:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802336:	89 10                	mov    %edx,(%eax)
  802338:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80233b:	8b 00                	mov    (%eax),%eax
  80233d:	85 c0                	test   %eax,%eax
  80233f:	74 0b                	je     80234c <alloc_block_FF+0x247>
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	8b 00                	mov    (%eax),%eax
  802346:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802349:	89 50 04             	mov    %edx,0x4(%eax)
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802352:	89 10                	mov    %edx,(%eax)
  802354:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802357:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235a:	89 50 04             	mov    %edx,0x4(%eax)
  80235d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802360:	8b 00                	mov    (%eax),%eax
  802362:	85 c0                	test   %eax,%eax
  802364:	75 08                	jne    80236e <alloc_block_FF+0x269>
  802366:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802369:	a3 30 50 80 00       	mov    %eax,0x805030
  80236e:	a1 38 50 80 00       	mov    0x805038,%eax
  802373:	40                   	inc    %eax
  802374:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802379:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237d:	75 17                	jne    802396 <alloc_block_FF+0x291>
  80237f:	83 ec 04             	sub    $0x4,%esp
  802382:	68 87 42 80 00       	push   $0x804287
  802387:	68 e1 00 00 00       	push   $0xe1
  80238c:	68 a5 42 80 00       	push   $0x8042a5
  802391:	e8 a7 de ff ff       	call   80023d <_panic>
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 00                	mov    (%eax),%eax
  80239b:	85 c0                	test   %eax,%eax
  80239d:	74 10                	je     8023af <alloc_block_FF+0x2aa>
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a7:	8b 52 04             	mov    0x4(%edx),%edx
  8023aa:	89 50 04             	mov    %edx,0x4(%eax)
  8023ad:	eb 0b                	jmp    8023ba <alloc_block_FF+0x2b5>
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 40 04             	mov    0x4(%eax),%eax
  8023b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	8b 40 04             	mov    0x4(%eax),%eax
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	74 0f                	je     8023d3 <alloc_block_FF+0x2ce>
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cd:	8b 12                	mov    (%edx),%edx
  8023cf:	89 10                	mov    %edx,(%eax)
  8023d1:	eb 0a                	jmp    8023dd <alloc_block_FF+0x2d8>
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 00                	mov    (%eax),%eax
  8023d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f0:	a1 38 50 80 00       	mov    0x805038,%eax
  8023f5:	48                   	dec    %eax
  8023f6:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8023fb:	83 ec 04             	sub    $0x4,%esp
  8023fe:	6a 00                	push   $0x0
  802400:	ff 75 b4             	pushl  -0x4c(%ebp)
  802403:	ff 75 b0             	pushl  -0x50(%ebp)
  802406:	e8 cb fc ff ff       	call   8020d6 <set_block_data>
  80240b:	83 c4 10             	add    $0x10,%esp
  80240e:	e9 95 00 00 00       	jmp    8024a8 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802413:	83 ec 04             	sub    $0x4,%esp
  802416:	6a 01                	push   $0x1
  802418:	ff 75 b8             	pushl  -0x48(%ebp)
  80241b:	ff 75 bc             	pushl  -0x44(%ebp)
  80241e:	e8 b3 fc ff ff       	call   8020d6 <set_block_data>
  802423:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242a:	75 17                	jne    802443 <alloc_block_FF+0x33e>
  80242c:	83 ec 04             	sub    $0x4,%esp
  80242f:	68 87 42 80 00       	push   $0x804287
  802434:	68 e8 00 00 00       	push   $0xe8
  802439:	68 a5 42 80 00       	push   $0x8042a5
  80243e:	e8 fa dd ff ff       	call   80023d <_panic>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	85 c0                	test   %eax,%eax
  80244a:	74 10                	je     80245c <alloc_block_FF+0x357>
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 00                	mov    (%eax),%eax
  802451:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802454:	8b 52 04             	mov    0x4(%edx),%edx
  802457:	89 50 04             	mov    %edx,0x4(%eax)
  80245a:	eb 0b                	jmp    802467 <alloc_block_FF+0x362>
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 40 04             	mov    0x4(%eax),%eax
  802462:	a3 30 50 80 00       	mov    %eax,0x805030
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 40 04             	mov    0x4(%eax),%eax
  80246d:	85 c0                	test   %eax,%eax
  80246f:	74 0f                	je     802480 <alloc_block_FF+0x37b>
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 40 04             	mov    0x4(%eax),%eax
  802477:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247a:	8b 12                	mov    (%edx),%edx
  80247c:	89 10                	mov    %edx,(%eax)
  80247e:	eb 0a                	jmp    80248a <alloc_block_FF+0x385>
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 00                	mov    (%eax),%eax
  802485:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249d:	a1 38 50 80 00       	mov    0x805038,%eax
  8024a2:	48                   	dec    %eax
  8024a3:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8024a8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024ab:	e9 0f 01 00 00       	jmp    8025bf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024b0:	a1 34 50 80 00       	mov    0x805034,%eax
  8024b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bc:	74 07                	je     8024c5 <alloc_block_FF+0x3c0>
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 00                	mov    (%eax),%eax
  8024c3:	eb 05                	jmp    8024ca <alloc_block_FF+0x3c5>
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ca:	a3 34 50 80 00       	mov    %eax,0x805034
  8024cf:	a1 34 50 80 00       	mov    0x805034,%eax
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	0f 85 e9 fc ff ff    	jne    8021c5 <alloc_block_FF+0xc0>
  8024dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e0:	0f 85 df fc ff ff    	jne    8021c5 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	83 c0 08             	add    $0x8,%eax
  8024ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8024ef:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8024f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024fc:	01 d0                	add    %edx,%eax
  8024fe:	48                   	dec    %eax
  8024ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802502:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802505:	ba 00 00 00 00       	mov    $0x0,%edx
  80250a:	f7 75 d8             	divl   -0x28(%ebp)
  80250d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802510:	29 d0                	sub    %edx,%eax
  802512:	c1 e8 0c             	shr    $0xc,%eax
  802515:	83 ec 0c             	sub    $0xc,%esp
  802518:	50                   	push   %eax
  802519:	e8 76 ed ff ff       	call   801294 <sbrk>
  80251e:	83 c4 10             	add    $0x10,%esp
  802521:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802524:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802528:	75 0a                	jne    802534 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80252a:	b8 00 00 00 00       	mov    $0x0,%eax
  80252f:	e9 8b 00 00 00       	jmp    8025bf <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802534:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80253b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80253e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802541:	01 d0                	add    %edx,%eax
  802543:	48                   	dec    %eax
  802544:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802547:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80254a:	ba 00 00 00 00       	mov    $0x0,%edx
  80254f:	f7 75 cc             	divl   -0x34(%ebp)
  802552:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802555:	29 d0                	sub    %edx,%eax
  802557:	8d 50 fc             	lea    -0x4(%eax),%edx
  80255a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80255d:	01 d0                	add    %edx,%eax
  80255f:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802564:	a1 40 50 80 00       	mov    0x805040,%eax
  802569:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80256f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802576:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802579:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80257c:	01 d0                	add    %edx,%eax
  80257e:	48                   	dec    %eax
  80257f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802582:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802585:	ba 00 00 00 00       	mov    $0x0,%edx
  80258a:	f7 75 c4             	divl   -0x3c(%ebp)
  80258d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802590:	29 d0                	sub    %edx,%eax
  802592:	83 ec 04             	sub    $0x4,%esp
  802595:	6a 01                	push   $0x1
  802597:	50                   	push   %eax
  802598:	ff 75 d0             	pushl  -0x30(%ebp)
  80259b:	e8 36 fb ff ff       	call   8020d6 <set_block_data>
  8025a0:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8025a3:	83 ec 0c             	sub    $0xc,%esp
  8025a6:	ff 75 d0             	pushl  -0x30(%ebp)
  8025a9:	e8 1b 0a 00 00       	call   802fc9 <free_block>
  8025ae:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8025b1:	83 ec 0c             	sub    $0xc,%esp
  8025b4:	ff 75 08             	pushl  0x8(%ebp)
  8025b7:	e8 49 fb ff ff       	call   802105 <alloc_block_FF>
  8025bc:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
  8025c4:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	83 e0 01             	and    $0x1,%eax
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	74 03                	je     8025d4 <alloc_block_BF+0x13>
  8025d1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025d4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025d8:	77 07                	ja     8025e1 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025da:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025e1:	a1 24 50 80 00       	mov    0x805024,%eax
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	75 73                	jne    80265d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	83 c0 10             	add    $0x10,%eax
  8025f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8025f3:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8025fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802600:	01 d0                	add    %edx,%eax
  802602:	48                   	dec    %eax
  802603:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802606:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802609:	ba 00 00 00 00       	mov    $0x0,%edx
  80260e:	f7 75 e0             	divl   -0x20(%ebp)
  802611:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802614:	29 d0                	sub    %edx,%eax
  802616:	c1 e8 0c             	shr    $0xc,%eax
  802619:	83 ec 0c             	sub    $0xc,%esp
  80261c:	50                   	push   %eax
  80261d:	e8 72 ec ff ff       	call   801294 <sbrk>
  802622:	83 c4 10             	add    $0x10,%esp
  802625:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802628:	83 ec 0c             	sub    $0xc,%esp
  80262b:	6a 00                	push   $0x0
  80262d:	e8 62 ec ff ff       	call   801294 <sbrk>
  802632:	83 c4 10             	add    $0x10,%esp
  802635:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802638:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80263b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80263e:	83 ec 08             	sub    $0x8,%esp
  802641:	50                   	push   %eax
  802642:	ff 75 d8             	pushl  -0x28(%ebp)
  802645:	e8 9f f8 ff ff       	call   801ee9 <initialize_dynamic_allocator>
  80264a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80264d:	83 ec 0c             	sub    $0xc,%esp
  802650:	68 e3 42 80 00       	push   $0x8042e3
  802655:	e8 a0 de ff ff       	call   8004fa <cprintf>
  80265a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80265d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802664:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80266b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802672:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802679:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80267e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802681:	e9 1d 01 00 00       	jmp    8027a3 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80268c:	83 ec 0c             	sub    $0xc,%esp
  80268f:	ff 75 a8             	pushl  -0x58(%ebp)
  802692:	e8 ee f6 ff ff       	call   801d85 <get_block_size>
  802697:	83 c4 10             	add    $0x10,%esp
  80269a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	83 c0 08             	add    $0x8,%eax
  8026a3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026a6:	0f 87 ef 00 00 00    	ja     80279b <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	83 c0 18             	add    $0x18,%eax
  8026b2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026b5:	77 1d                	ja     8026d4 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8026b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026bd:	0f 86 d8 00 00 00    	jbe    80279b <alloc_block_BF+0x1da>
				{
					best_va = va;
  8026c3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8026c9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026cf:	e9 c7 00 00 00       	jmp    80279b <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8026d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d7:	83 c0 08             	add    $0x8,%eax
  8026da:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026dd:	0f 85 9d 00 00 00    	jne    802780 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8026e3:	83 ec 04             	sub    $0x4,%esp
  8026e6:	6a 01                	push   $0x1
  8026e8:	ff 75 a4             	pushl  -0x5c(%ebp)
  8026eb:	ff 75 a8             	pushl  -0x58(%ebp)
  8026ee:	e8 e3 f9 ff ff       	call   8020d6 <set_block_data>
  8026f3:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8026f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fa:	75 17                	jne    802713 <alloc_block_BF+0x152>
  8026fc:	83 ec 04             	sub    $0x4,%esp
  8026ff:	68 87 42 80 00       	push   $0x804287
  802704:	68 2c 01 00 00       	push   $0x12c
  802709:	68 a5 42 80 00       	push   $0x8042a5
  80270e:	e8 2a db ff ff       	call   80023d <_panic>
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 00                	mov    (%eax),%eax
  802718:	85 c0                	test   %eax,%eax
  80271a:	74 10                	je     80272c <alloc_block_BF+0x16b>
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 00                	mov    (%eax),%eax
  802721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802724:	8b 52 04             	mov    0x4(%edx),%edx
  802727:	89 50 04             	mov    %edx,0x4(%eax)
  80272a:	eb 0b                	jmp    802737 <alloc_block_BF+0x176>
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 40 04             	mov    0x4(%eax),%eax
  802732:	a3 30 50 80 00       	mov    %eax,0x805030
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 40 04             	mov    0x4(%eax),%eax
  80273d:	85 c0                	test   %eax,%eax
  80273f:	74 0f                	je     802750 <alloc_block_BF+0x18f>
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 40 04             	mov    0x4(%eax),%eax
  802747:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274a:	8b 12                	mov    (%edx),%edx
  80274c:	89 10                	mov    %edx,(%eax)
  80274e:	eb 0a                	jmp    80275a <alloc_block_BF+0x199>
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 00                	mov    (%eax),%eax
  802755:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80276d:	a1 38 50 80 00       	mov    0x805038,%eax
  802772:	48                   	dec    %eax
  802773:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802778:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80277b:	e9 24 04 00 00       	jmp    802ba4 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802783:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802786:	76 13                	jbe    80279b <alloc_block_BF+0x1da>
					{
						internal = 1;
  802788:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80278f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802792:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802795:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802798:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80279b:	a1 34 50 80 00       	mov    0x805034,%eax
  8027a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a7:	74 07                	je     8027b0 <alloc_block_BF+0x1ef>
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	eb 05                	jmp    8027b5 <alloc_block_BF+0x1f4>
  8027b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b5:	a3 34 50 80 00       	mov    %eax,0x805034
  8027ba:	a1 34 50 80 00       	mov    0x805034,%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	0f 85 bf fe ff ff    	jne    802686 <alloc_block_BF+0xc5>
  8027c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cb:	0f 85 b5 fe ff ff    	jne    802686 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8027d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d5:	0f 84 26 02 00 00    	je     802a01 <alloc_block_BF+0x440>
  8027db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027df:	0f 85 1c 02 00 00    	jne    802a01 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8027e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e8:	2b 45 08             	sub    0x8(%ebp),%eax
  8027eb:	83 e8 08             	sub    $0x8,%eax
  8027ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	8d 50 08             	lea    0x8(%eax),%edx
  8027f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fa:	01 d0                	add    %edx,%eax
  8027fc:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8027ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802802:	83 c0 08             	add    $0x8,%eax
  802805:	83 ec 04             	sub    $0x4,%esp
  802808:	6a 01                	push   $0x1
  80280a:	50                   	push   %eax
  80280b:	ff 75 f0             	pushl  -0x10(%ebp)
  80280e:	e8 c3 f8 ff ff       	call   8020d6 <set_block_data>
  802813:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802819:	8b 40 04             	mov    0x4(%eax),%eax
  80281c:	85 c0                	test   %eax,%eax
  80281e:	75 68                	jne    802888 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802820:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802824:	75 17                	jne    80283d <alloc_block_BF+0x27c>
  802826:	83 ec 04             	sub    $0x4,%esp
  802829:	68 c0 42 80 00       	push   $0x8042c0
  80282e:	68 45 01 00 00       	push   $0x145
  802833:	68 a5 42 80 00       	push   $0x8042a5
  802838:	e8 00 da ff ff       	call   80023d <_panic>
  80283d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802843:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802846:	89 10                	mov    %edx,(%eax)
  802848:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	74 0d                	je     80285e <alloc_block_BF+0x29d>
  802851:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802856:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802859:	89 50 04             	mov    %edx,0x4(%eax)
  80285c:	eb 08                	jmp    802866 <alloc_block_BF+0x2a5>
  80285e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802861:	a3 30 50 80 00       	mov    %eax,0x805030
  802866:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802869:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80286e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802871:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802878:	a1 38 50 80 00       	mov    0x805038,%eax
  80287d:	40                   	inc    %eax
  80287e:	a3 38 50 80 00       	mov    %eax,0x805038
  802883:	e9 dc 00 00 00       	jmp    802964 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	75 65                	jne    8028f6 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802891:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802895:	75 17                	jne    8028ae <alloc_block_BF+0x2ed>
  802897:	83 ec 04             	sub    $0x4,%esp
  80289a:	68 f4 42 80 00       	push   $0x8042f4
  80289f:	68 4a 01 00 00       	push   $0x14a
  8028a4:	68 a5 42 80 00       	push   $0x8042a5
  8028a9:	e8 8f d9 ff ff       	call   80023d <_panic>
  8028ae:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028b7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028bd:	8b 40 04             	mov    0x4(%eax),%eax
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	74 0c                	je     8028d0 <alloc_block_BF+0x30f>
  8028c4:	a1 30 50 80 00       	mov    0x805030,%eax
  8028c9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028cc:	89 10                	mov    %edx,(%eax)
  8028ce:	eb 08                	jmp    8028d8 <alloc_block_BF+0x317>
  8028d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028db:	a3 30 50 80 00       	mov    %eax,0x805030
  8028e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8028ee:	40                   	inc    %eax
  8028ef:	a3 38 50 80 00       	mov    %eax,0x805038
  8028f4:	eb 6e                	jmp    802964 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8028f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028fa:	74 06                	je     802902 <alloc_block_BF+0x341>
  8028fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802900:	75 17                	jne    802919 <alloc_block_BF+0x358>
  802902:	83 ec 04             	sub    $0x4,%esp
  802905:	68 18 43 80 00       	push   $0x804318
  80290a:	68 4f 01 00 00       	push   $0x14f
  80290f:	68 a5 42 80 00       	push   $0x8042a5
  802914:	e8 24 d9 ff ff       	call   80023d <_panic>
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	8b 10                	mov    (%eax),%edx
  80291e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802921:	89 10                	mov    %edx,(%eax)
  802923:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	85 c0                	test   %eax,%eax
  80292a:	74 0b                	je     802937 <alloc_block_BF+0x376>
  80292c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802934:	89 50 04             	mov    %edx,0x4(%eax)
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80293d:	89 10                	mov    %edx,(%eax)
  80293f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802942:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802945:	89 50 04             	mov    %edx,0x4(%eax)
  802948:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	75 08                	jne    802959 <alloc_block_BF+0x398>
  802951:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802954:	a3 30 50 80 00       	mov    %eax,0x805030
  802959:	a1 38 50 80 00       	mov    0x805038,%eax
  80295e:	40                   	inc    %eax
  80295f:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802964:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802968:	75 17                	jne    802981 <alloc_block_BF+0x3c0>
  80296a:	83 ec 04             	sub    $0x4,%esp
  80296d:	68 87 42 80 00       	push   $0x804287
  802972:	68 51 01 00 00       	push   $0x151
  802977:	68 a5 42 80 00       	push   $0x8042a5
  80297c:	e8 bc d8 ff ff       	call   80023d <_panic>
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	74 10                	je     80299a <alloc_block_BF+0x3d9>
  80298a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802992:	8b 52 04             	mov    0x4(%edx),%edx
  802995:	89 50 04             	mov    %edx,0x4(%eax)
  802998:	eb 0b                	jmp    8029a5 <alloc_block_BF+0x3e4>
  80299a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299d:	8b 40 04             	mov    0x4(%eax),%eax
  8029a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8029a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a8:	8b 40 04             	mov    0x4(%eax),%eax
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	74 0f                	je     8029be <alloc_block_BF+0x3fd>
  8029af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b2:	8b 40 04             	mov    0x4(%eax),%eax
  8029b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b8:	8b 12                	mov    (%edx),%edx
  8029ba:	89 10                	mov    %edx,(%eax)
  8029bc:	eb 0a                	jmp    8029c8 <alloc_block_BF+0x407>
  8029be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029db:	a1 38 50 80 00       	mov    0x805038,%eax
  8029e0:	48                   	dec    %eax
  8029e1:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8029e6:	83 ec 04             	sub    $0x4,%esp
  8029e9:	6a 00                	push   $0x0
  8029eb:	ff 75 d0             	pushl  -0x30(%ebp)
  8029ee:	ff 75 cc             	pushl  -0x34(%ebp)
  8029f1:	e8 e0 f6 ff ff       	call   8020d6 <set_block_data>
  8029f6:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8029f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fc:	e9 a3 01 00 00       	jmp    802ba4 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a01:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a05:	0f 85 9d 00 00 00    	jne    802aa8 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a0b:	83 ec 04             	sub    $0x4,%esp
  802a0e:	6a 01                	push   $0x1
  802a10:	ff 75 ec             	pushl  -0x14(%ebp)
  802a13:	ff 75 f0             	pushl  -0x10(%ebp)
  802a16:	e8 bb f6 ff ff       	call   8020d6 <set_block_data>
  802a1b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a22:	75 17                	jne    802a3b <alloc_block_BF+0x47a>
  802a24:	83 ec 04             	sub    $0x4,%esp
  802a27:	68 87 42 80 00       	push   $0x804287
  802a2c:	68 58 01 00 00       	push   $0x158
  802a31:	68 a5 42 80 00       	push   $0x8042a5
  802a36:	e8 02 d8 ff ff       	call   80023d <_panic>
  802a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	74 10                	je     802a54 <alloc_block_BF+0x493>
  802a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a47:	8b 00                	mov    (%eax),%eax
  802a49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a4c:	8b 52 04             	mov    0x4(%edx),%edx
  802a4f:	89 50 04             	mov    %edx,0x4(%eax)
  802a52:	eb 0b                	jmp    802a5f <alloc_block_BF+0x49e>
  802a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a57:	8b 40 04             	mov    0x4(%eax),%eax
  802a5a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a62:	8b 40 04             	mov    0x4(%eax),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	74 0f                	je     802a78 <alloc_block_BF+0x4b7>
  802a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6c:	8b 40 04             	mov    0x4(%eax),%eax
  802a6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a72:	8b 12                	mov    (%edx),%edx
  802a74:	89 10                	mov    %edx,(%eax)
  802a76:	eb 0a                	jmp    802a82 <alloc_block_BF+0x4c1>
  802a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a95:	a1 38 50 80 00       	mov    0x805038,%eax
  802a9a:	48                   	dec    %eax
  802a9b:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa3:	e9 fc 00 00 00       	jmp    802ba4 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aab:	83 c0 08             	add    $0x8,%eax
  802aae:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ab1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ab8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802abb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802abe:	01 d0                	add    %edx,%eax
  802ac0:	48                   	dec    %eax
  802ac1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ac4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ac7:	ba 00 00 00 00       	mov    $0x0,%edx
  802acc:	f7 75 c4             	divl   -0x3c(%ebp)
  802acf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ad2:	29 d0                	sub    %edx,%eax
  802ad4:	c1 e8 0c             	shr    $0xc,%eax
  802ad7:	83 ec 0c             	sub    $0xc,%esp
  802ada:	50                   	push   %eax
  802adb:	e8 b4 e7 ff ff       	call   801294 <sbrk>
  802ae0:	83 c4 10             	add    $0x10,%esp
  802ae3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ae6:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802aea:	75 0a                	jne    802af6 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802aec:	b8 00 00 00 00       	mov    $0x0,%eax
  802af1:	e9 ae 00 00 00       	jmp    802ba4 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802af6:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802afd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b00:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b03:	01 d0                	add    %edx,%eax
  802b05:	48                   	dec    %eax
  802b06:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b09:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b0c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b11:	f7 75 b8             	divl   -0x48(%ebp)
  802b14:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b17:	29 d0                	sub    %edx,%eax
  802b19:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b1c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b1f:	01 d0                	add    %edx,%eax
  802b21:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b26:	a1 40 50 80 00       	mov    0x805040,%eax
  802b2b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b31:	83 ec 0c             	sub    $0xc,%esp
  802b34:	68 4c 43 80 00       	push   $0x80434c
  802b39:	e8 bc d9 ff ff       	call   8004fa <cprintf>
  802b3e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b41:	83 ec 08             	sub    $0x8,%esp
  802b44:	ff 75 bc             	pushl  -0x44(%ebp)
  802b47:	68 51 43 80 00       	push   $0x804351
  802b4c:	e8 a9 d9 ff ff       	call   8004fa <cprintf>
  802b51:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b54:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b5b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b5e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b61:	01 d0                	add    %edx,%eax
  802b63:	48                   	dec    %eax
  802b64:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b67:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  802b6f:	f7 75 b0             	divl   -0x50(%ebp)
  802b72:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b75:	29 d0                	sub    %edx,%eax
  802b77:	83 ec 04             	sub    $0x4,%esp
  802b7a:	6a 01                	push   $0x1
  802b7c:	50                   	push   %eax
  802b7d:	ff 75 bc             	pushl  -0x44(%ebp)
  802b80:	e8 51 f5 ff ff       	call   8020d6 <set_block_data>
  802b85:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b88:	83 ec 0c             	sub    $0xc,%esp
  802b8b:	ff 75 bc             	pushl  -0x44(%ebp)
  802b8e:	e8 36 04 00 00       	call   802fc9 <free_block>
  802b93:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802b96:	83 ec 0c             	sub    $0xc,%esp
  802b99:	ff 75 08             	pushl  0x8(%ebp)
  802b9c:	e8 20 fa ff ff       	call   8025c1 <alloc_block_BF>
  802ba1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ba4:	c9                   	leave  
  802ba5:	c3                   	ret    

00802ba6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802ba6:	55                   	push   %ebp
  802ba7:	89 e5                	mov    %esp,%ebp
  802ba9:	53                   	push   %ebx
  802baa:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802bad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802bb4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802bbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bbf:	74 1e                	je     802bdf <merging+0x39>
  802bc1:	ff 75 08             	pushl  0x8(%ebp)
  802bc4:	e8 bc f1 ff ff       	call   801d85 <get_block_size>
  802bc9:	83 c4 04             	add    $0x4,%esp
  802bcc:	89 c2                	mov    %eax,%edx
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	01 d0                	add    %edx,%eax
  802bd3:	3b 45 10             	cmp    0x10(%ebp),%eax
  802bd6:	75 07                	jne    802bdf <merging+0x39>
		prev_is_free = 1;
  802bd8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802bdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802be3:	74 1e                	je     802c03 <merging+0x5d>
  802be5:	ff 75 10             	pushl  0x10(%ebp)
  802be8:	e8 98 f1 ff ff       	call   801d85 <get_block_size>
  802bed:	83 c4 04             	add    $0x4,%esp
  802bf0:	89 c2                	mov    %eax,%edx
  802bf2:	8b 45 10             	mov    0x10(%ebp),%eax
  802bf5:	01 d0                	add    %edx,%eax
  802bf7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802bfa:	75 07                	jne    802c03 <merging+0x5d>
		next_is_free = 1;
  802bfc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c07:	0f 84 cc 00 00 00    	je     802cd9 <merging+0x133>
  802c0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c11:	0f 84 c2 00 00 00    	je     802cd9 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c17:	ff 75 08             	pushl  0x8(%ebp)
  802c1a:	e8 66 f1 ff ff       	call   801d85 <get_block_size>
  802c1f:	83 c4 04             	add    $0x4,%esp
  802c22:	89 c3                	mov    %eax,%ebx
  802c24:	ff 75 10             	pushl  0x10(%ebp)
  802c27:	e8 59 f1 ff ff       	call   801d85 <get_block_size>
  802c2c:	83 c4 04             	add    $0x4,%esp
  802c2f:	01 c3                	add    %eax,%ebx
  802c31:	ff 75 0c             	pushl  0xc(%ebp)
  802c34:	e8 4c f1 ff ff       	call   801d85 <get_block_size>
  802c39:	83 c4 04             	add    $0x4,%esp
  802c3c:	01 d8                	add    %ebx,%eax
  802c3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c41:	6a 00                	push   $0x0
  802c43:	ff 75 ec             	pushl  -0x14(%ebp)
  802c46:	ff 75 08             	pushl  0x8(%ebp)
  802c49:	e8 88 f4 ff ff       	call   8020d6 <set_block_data>
  802c4e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c55:	75 17                	jne    802c6e <merging+0xc8>
  802c57:	83 ec 04             	sub    $0x4,%esp
  802c5a:	68 87 42 80 00       	push   $0x804287
  802c5f:	68 7d 01 00 00       	push   $0x17d
  802c64:	68 a5 42 80 00       	push   $0x8042a5
  802c69:	e8 cf d5 ff ff       	call   80023d <_panic>
  802c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c71:	8b 00                	mov    (%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 10                	je     802c87 <merging+0xe1>
  802c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c7f:	8b 52 04             	mov    0x4(%edx),%edx
  802c82:	89 50 04             	mov    %edx,0x4(%eax)
  802c85:	eb 0b                	jmp    802c92 <merging+0xec>
  802c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8a:	8b 40 04             	mov    0x4(%eax),%eax
  802c8d:	a3 30 50 80 00       	mov    %eax,0x805030
  802c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c95:	8b 40 04             	mov    0x4(%eax),%eax
  802c98:	85 c0                	test   %eax,%eax
  802c9a:	74 0f                	je     802cab <merging+0x105>
  802c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca5:	8b 12                	mov    (%edx),%edx
  802ca7:	89 10                	mov    %edx,(%eax)
  802ca9:	eb 0a                	jmp    802cb5 <merging+0x10f>
  802cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cae:	8b 00                	mov    (%eax),%eax
  802cb0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc8:	a1 38 50 80 00       	mov    0x805038,%eax
  802ccd:	48                   	dec    %eax
  802cce:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802cd3:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cd4:	e9 ea 02 00 00       	jmp    802fc3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdd:	74 3b                	je     802d1a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802cdf:	83 ec 0c             	sub    $0xc,%esp
  802ce2:	ff 75 08             	pushl  0x8(%ebp)
  802ce5:	e8 9b f0 ff ff       	call   801d85 <get_block_size>
  802cea:	83 c4 10             	add    $0x10,%esp
  802ced:	89 c3                	mov    %eax,%ebx
  802cef:	83 ec 0c             	sub    $0xc,%esp
  802cf2:	ff 75 10             	pushl  0x10(%ebp)
  802cf5:	e8 8b f0 ff ff       	call   801d85 <get_block_size>
  802cfa:	83 c4 10             	add    $0x10,%esp
  802cfd:	01 d8                	add    %ebx,%eax
  802cff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	6a 00                	push   $0x0
  802d07:	ff 75 e8             	pushl  -0x18(%ebp)
  802d0a:	ff 75 08             	pushl  0x8(%ebp)
  802d0d:	e8 c4 f3 ff ff       	call   8020d6 <set_block_data>
  802d12:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d15:	e9 a9 02 00 00       	jmp    802fc3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d1e:	0f 84 2d 01 00 00    	je     802e51 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d24:	83 ec 0c             	sub    $0xc,%esp
  802d27:	ff 75 10             	pushl  0x10(%ebp)
  802d2a:	e8 56 f0 ff ff       	call   801d85 <get_block_size>
  802d2f:	83 c4 10             	add    $0x10,%esp
  802d32:	89 c3                	mov    %eax,%ebx
  802d34:	83 ec 0c             	sub    $0xc,%esp
  802d37:	ff 75 0c             	pushl  0xc(%ebp)
  802d3a:	e8 46 f0 ff ff       	call   801d85 <get_block_size>
  802d3f:	83 c4 10             	add    $0x10,%esp
  802d42:	01 d8                	add    %ebx,%eax
  802d44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d47:	83 ec 04             	sub    $0x4,%esp
  802d4a:	6a 00                	push   $0x0
  802d4c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d4f:	ff 75 10             	pushl  0x10(%ebp)
  802d52:	e8 7f f3 ff ff       	call   8020d6 <set_block_data>
  802d57:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  802d5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d64:	74 06                	je     802d6c <merging+0x1c6>
  802d66:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d6a:	75 17                	jne    802d83 <merging+0x1dd>
  802d6c:	83 ec 04             	sub    $0x4,%esp
  802d6f:	68 60 43 80 00       	push   $0x804360
  802d74:	68 8d 01 00 00       	push   $0x18d
  802d79:	68 a5 42 80 00       	push   $0x8042a5
  802d7e:	e8 ba d4 ff ff       	call   80023d <_panic>
  802d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d86:	8b 50 04             	mov    0x4(%eax),%edx
  802d89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8c:	89 50 04             	mov    %edx,0x4(%eax)
  802d8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d95:	89 10                	mov    %edx,(%eax)
  802d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9a:	8b 40 04             	mov    0x4(%eax),%eax
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	74 0d                	je     802dae <merging+0x208>
  802da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da4:	8b 40 04             	mov    0x4(%eax),%eax
  802da7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802daa:	89 10                	mov    %edx,(%eax)
  802dac:	eb 08                	jmp    802db6 <merging+0x210>
  802dae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dbc:	89 50 04             	mov    %edx,0x4(%eax)
  802dbf:	a1 38 50 80 00       	mov    0x805038,%eax
  802dc4:	40                   	inc    %eax
  802dc5:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802dca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dce:	75 17                	jne    802de7 <merging+0x241>
  802dd0:	83 ec 04             	sub    $0x4,%esp
  802dd3:	68 87 42 80 00       	push   $0x804287
  802dd8:	68 8e 01 00 00       	push   $0x18e
  802ddd:	68 a5 42 80 00       	push   $0x8042a5
  802de2:	e8 56 d4 ff ff       	call   80023d <_panic>
  802de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dea:	8b 00                	mov    (%eax),%eax
  802dec:	85 c0                	test   %eax,%eax
  802dee:	74 10                	je     802e00 <merging+0x25a>
  802df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df8:	8b 52 04             	mov    0x4(%edx),%edx
  802dfb:	89 50 04             	mov    %edx,0x4(%eax)
  802dfe:	eb 0b                	jmp    802e0b <merging+0x265>
  802e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e03:	8b 40 04             	mov    0x4(%eax),%eax
  802e06:	a3 30 50 80 00       	mov    %eax,0x805030
  802e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e0e:	8b 40 04             	mov    0x4(%eax),%eax
  802e11:	85 c0                	test   %eax,%eax
  802e13:	74 0f                	je     802e24 <merging+0x27e>
  802e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e18:	8b 40 04             	mov    0x4(%eax),%eax
  802e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e1e:	8b 12                	mov    (%edx),%edx
  802e20:	89 10                	mov    %edx,(%eax)
  802e22:	eb 0a                	jmp    802e2e <merging+0x288>
  802e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e27:	8b 00                	mov    (%eax),%eax
  802e29:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e41:	a1 38 50 80 00       	mov    0x805038,%eax
  802e46:	48                   	dec    %eax
  802e47:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e4c:	e9 72 01 00 00       	jmp    802fc3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e51:	8b 45 10             	mov    0x10(%ebp),%eax
  802e54:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5b:	74 79                	je     802ed6 <merging+0x330>
  802e5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e61:	74 73                	je     802ed6 <merging+0x330>
  802e63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e67:	74 06                	je     802e6f <merging+0x2c9>
  802e69:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e6d:	75 17                	jne    802e86 <merging+0x2e0>
  802e6f:	83 ec 04             	sub    $0x4,%esp
  802e72:	68 18 43 80 00       	push   $0x804318
  802e77:	68 94 01 00 00       	push   $0x194
  802e7c:	68 a5 42 80 00       	push   $0x8042a5
  802e81:	e8 b7 d3 ff ff       	call   80023d <_panic>
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	8b 10                	mov    (%eax),%edx
  802e8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e8e:	89 10                	mov    %edx,(%eax)
  802e90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e93:	8b 00                	mov    (%eax),%eax
  802e95:	85 c0                	test   %eax,%eax
  802e97:	74 0b                	je     802ea4 <merging+0x2fe>
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	8b 00                	mov    (%eax),%eax
  802e9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ea1:	89 50 04             	mov    %edx,0x4(%eax)
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eaa:	89 10                	mov    %edx,(%eax)
  802eac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb2:	89 50 04             	mov    %edx,0x4(%eax)
  802eb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb8:	8b 00                	mov    (%eax),%eax
  802eba:	85 c0                	test   %eax,%eax
  802ebc:	75 08                	jne    802ec6 <merging+0x320>
  802ebe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ec6:	a1 38 50 80 00       	mov    0x805038,%eax
  802ecb:	40                   	inc    %eax
  802ecc:	a3 38 50 80 00       	mov    %eax,0x805038
  802ed1:	e9 ce 00 00 00       	jmp    802fa4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802ed6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eda:	74 65                	je     802f41 <merging+0x39b>
  802edc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ee0:	75 17                	jne    802ef9 <merging+0x353>
  802ee2:	83 ec 04             	sub    $0x4,%esp
  802ee5:	68 f4 42 80 00       	push   $0x8042f4
  802eea:	68 95 01 00 00       	push   $0x195
  802eef:	68 a5 42 80 00       	push   $0x8042a5
  802ef4:	e8 44 d3 ff ff       	call   80023d <_panic>
  802ef9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802eff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f02:	89 50 04             	mov    %edx,0x4(%eax)
  802f05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f08:	8b 40 04             	mov    0x4(%eax),%eax
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	74 0c                	je     802f1b <merging+0x375>
  802f0f:	a1 30 50 80 00       	mov    0x805030,%eax
  802f14:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f17:	89 10                	mov    %edx,(%eax)
  802f19:	eb 08                	jmp    802f23 <merging+0x37d>
  802f1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f26:	a3 30 50 80 00       	mov    %eax,0x805030
  802f2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f34:	a1 38 50 80 00       	mov    0x805038,%eax
  802f39:	40                   	inc    %eax
  802f3a:	a3 38 50 80 00       	mov    %eax,0x805038
  802f3f:	eb 63                	jmp    802fa4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f41:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f45:	75 17                	jne    802f5e <merging+0x3b8>
  802f47:	83 ec 04             	sub    $0x4,%esp
  802f4a:	68 c0 42 80 00       	push   $0x8042c0
  802f4f:	68 98 01 00 00       	push   $0x198
  802f54:	68 a5 42 80 00       	push   $0x8042a5
  802f59:	e8 df d2 ff ff       	call   80023d <_panic>
  802f5e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802f64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f67:	89 10                	mov    %edx,(%eax)
  802f69:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f6c:	8b 00                	mov    (%eax),%eax
  802f6e:	85 c0                	test   %eax,%eax
  802f70:	74 0d                	je     802f7f <merging+0x3d9>
  802f72:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f77:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f7a:	89 50 04             	mov    %edx,0x4(%eax)
  802f7d:	eb 08                	jmp    802f87 <merging+0x3e1>
  802f7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f82:	a3 30 50 80 00       	mov    %eax,0x805030
  802f87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f99:	a1 38 50 80 00       	mov    0x805038,%eax
  802f9e:	40                   	inc    %eax
  802f9f:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802fa4:	83 ec 0c             	sub    $0xc,%esp
  802fa7:	ff 75 10             	pushl  0x10(%ebp)
  802faa:	e8 d6 ed ff ff       	call   801d85 <get_block_size>
  802faf:	83 c4 10             	add    $0x10,%esp
  802fb2:	83 ec 04             	sub    $0x4,%esp
  802fb5:	6a 00                	push   $0x0
  802fb7:	50                   	push   %eax
  802fb8:	ff 75 10             	pushl  0x10(%ebp)
  802fbb:	e8 16 f1 ff ff       	call   8020d6 <set_block_data>
  802fc0:	83 c4 10             	add    $0x10,%esp
	}
}
  802fc3:	90                   	nop
  802fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fc7:	c9                   	leave  
  802fc8:	c3                   	ret    

00802fc9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802fc9:	55                   	push   %ebp
  802fca:	89 e5                	mov    %esp,%ebp
  802fcc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802fcf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fd4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802fd7:	a1 30 50 80 00       	mov    0x805030,%eax
  802fdc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fdf:	73 1b                	jae    802ffc <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802fe1:	a1 30 50 80 00       	mov    0x805030,%eax
  802fe6:	83 ec 04             	sub    $0x4,%esp
  802fe9:	ff 75 08             	pushl  0x8(%ebp)
  802fec:	6a 00                	push   $0x0
  802fee:	50                   	push   %eax
  802fef:	e8 b2 fb ff ff       	call   802ba6 <merging>
  802ff4:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ff7:	e9 8b 00 00 00       	jmp    803087 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802ffc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803001:	3b 45 08             	cmp    0x8(%ebp),%eax
  803004:	76 18                	jbe    80301e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803006:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80300b:	83 ec 04             	sub    $0x4,%esp
  80300e:	ff 75 08             	pushl  0x8(%ebp)
  803011:	50                   	push   %eax
  803012:	6a 00                	push   $0x0
  803014:	e8 8d fb ff ff       	call   802ba6 <merging>
  803019:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80301c:	eb 69                	jmp    803087 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80301e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803023:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803026:	eb 39                	jmp    803061 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80302e:	73 29                	jae    803059 <free_block+0x90>
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	3b 45 08             	cmp    0x8(%ebp),%eax
  803038:	76 1f                	jbe    803059 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	8b 00                	mov    (%eax),%eax
  80303f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803042:	83 ec 04             	sub    $0x4,%esp
  803045:	ff 75 08             	pushl  0x8(%ebp)
  803048:	ff 75 f0             	pushl  -0x10(%ebp)
  80304b:	ff 75 f4             	pushl  -0xc(%ebp)
  80304e:	e8 53 fb ff ff       	call   802ba6 <merging>
  803053:	83 c4 10             	add    $0x10,%esp
			break;
  803056:	90                   	nop
		}
	}
}
  803057:	eb 2e                	jmp    803087 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803059:	a1 34 50 80 00       	mov    0x805034,%eax
  80305e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803061:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803065:	74 07                	je     80306e <free_block+0xa5>
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 00                	mov    (%eax),%eax
  80306c:	eb 05                	jmp    803073 <free_block+0xaa>
  80306e:	b8 00 00 00 00       	mov    $0x0,%eax
  803073:	a3 34 50 80 00       	mov    %eax,0x805034
  803078:	a1 34 50 80 00       	mov    0x805034,%eax
  80307d:	85 c0                	test   %eax,%eax
  80307f:	75 a7                	jne    803028 <free_block+0x5f>
  803081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803085:	75 a1                	jne    803028 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803087:	90                   	nop
  803088:	c9                   	leave  
  803089:	c3                   	ret    

0080308a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80308a:	55                   	push   %ebp
  80308b:	89 e5                	mov    %esp,%ebp
  80308d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803090:	ff 75 08             	pushl  0x8(%ebp)
  803093:	e8 ed ec ff ff       	call   801d85 <get_block_size>
  803098:	83 c4 04             	add    $0x4,%esp
  80309b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80309e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8030a5:	eb 17                	jmp    8030be <copy_data+0x34>
  8030a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ad:	01 c2                	add    %eax,%edx
  8030af:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	01 c8                	add    %ecx,%eax
  8030b7:	8a 00                	mov    (%eax),%al
  8030b9:	88 02                	mov    %al,(%edx)
  8030bb:	ff 45 fc             	incl   -0x4(%ebp)
  8030be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8030c4:	72 e1                	jb     8030a7 <copy_data+0x1d>
}
  8030c6:	90                   	nop
  8030c7:	c9                   	leave  
  8030c8:	c3                   	ret    

008030c9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8030c9:	55                   	push   %ebp
  8030ca:	89 e5                	mov    %esp,%ebp
  8030cc:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8030cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d3:	75 23                	jne    8030f8 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8030d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030d9:	74 13                	je     8030ee <realloc_block_FF+0x25>
  8030db:	83 ec 0c             	sub    $0xc,%esp
  8030de:	ff 75 0c             	pushl  0xc(%ebp)
  8030e1:	e8 1f f0 ff ff       	call   802105 <alloc_block_FF>
  8030e6:	83 c4 10             	add    $0x10,%esp
  8030e9:	e9 f4 06 00 00       	jmp    8037e2 <realloc_block_FF+0x719>
		return NULL;
  8030ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f3:	e9 ea 06 00 00       	jmp    8037e2 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8030f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030fc:	75 18                	jne    803116 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8030fe:	83 ec 0c             	sub    $0xc,%esp
  803101:	ff 75 08             	pushl  0x8(%ebp)
  803104:	e8 c0 fe ff ff       	call   802fc9 <free_block>
  803109:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80310c:	b8 00 00 00 00       	mov    $0x0,%eax
  803111:	e9 cc 06 00 00       	jmp    8037e2 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803116:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80311a:	77 07                	ja     803123 <realloc_block_FF+0x5a>
  80311c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803123:	8b 45 0c             	mov    0xc(%ebp),%eax
  803126:	83 e0 01             	and    $0x1,%eax
  803129:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80312c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80312f:	83 c0 08             	add    $0x8,%eax
  803132:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803135:	83 ec 0c             	sub    $0xc,%esp
  803138:	ff 75 08             	pushl  0x8(%ebp)
  80313b:	e8 45 ec ff ff       	call   801d85 <get_block_size>
  803140:	83 c4 10             	add    $0x10,%esp
  803143:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803149:	83 e8 08             	sub    $0x8,%eax
  80314c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	83 e8 04             	sub    $0x4,%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	83 e0 fe             	and    $0xfffffffe,%eax
  80315a:	89 c2                	mov    %eax,%edx
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	01 d0                	add    %edx,%eax
  803161:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803164:	83 ec 0c             	sub    $0xc,%esp
  803167:	ff 75 e4             	pushl  -0x1c(%ebp)
  80316a:	e8 16 ec ff ff       	call   801d85 <get_block_size>
  80316f:	83 c4 10             	add    $0x10,%esp
  803172:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803175:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803178:	83 e8 08             	sub    $0x8,%eax
  80317b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80317e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803181:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803184:	75 08                	jne    80318e <realloc_block_FF+0xc5>
	{
		 return va;
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	e9 54 06 00 00       	jmp    8037e2 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80318e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803191:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803194:	0f 83 e5 03 00 00    	jae    80357f <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80319a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319d:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8031a3:	83 ec 0c             	sub    $0xc,%esp
  8031a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031a9:	e8 f0 eb ff ff       	call   801d9e <is_free_block>
  8031ae:	83 c4 10             	add    $0x10,%esp
  8031b1:	84 c0                	test   %al,%al
  8031b3:	0f 84 3b 01 00 00    	je     8032f4 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8031b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031bf:	01 d0                	add    %edx,%eax
  8031c1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8031c4:	83 ec 04             	sub    $0x4,%esp
  8031c7:	6a 01                	push   $0x1
  8031c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8031cc:	ff 75 08             	pushl  0x8(%ebp)
  8031cf:	e8 02 ef ff ff       	call   8020d6 <set_block_data>
  8031d4:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	83 e8 04             	sub    $0x4,%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	83 e0 fe             	and    $0xfffffffe,%eax
  8031e2:	89 c2                	mov    %eax,%edx
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	01 d0                	add    %edx,%eax
  8031e9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8031ec:	83 ec 04             	sub    $0x4,%esp
  8031ef:	6a 00                	push   $0x0
  8031f1:	ff 75 cc             	pushl  -0x34(%ebp)
  8031f4:	ff 75 c8             	pushl  -0x38(%ebp)
  8031f7:	e8 da ee ff ff       	call   8020d6 <set_block_data>
  8031fc:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8031ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803203:	74 06                	je     80320b <realloc_block_FF+0x142>
  803205:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803209:	75 17                	jne    803222 <realloc_block_FF+0x159>
  80320b:	83 ec 04             	sub    $0x4,%esp
  80320e:	68 18 43 80 00       	push   $0x804318
  803213:	68 f6 01 00 00       	push   $0x1f6
  803218:	68 a5 42 80 00       	push   $0x8042a5
  80321d:	e8 1b d0 ff ff       	call   80023d <_panic>
  803222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803225:	8b 10                	mov    (%eax),%edx
  803227:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80322a:	89 10                	mov    %edx,(%eax)
  80322c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80322f:	8b 00                	mov    (%eax),%eax
  803231:	85 c0                	test   %eax,%eax
  803233:	74 0b                	je     803240 <realloc_block_FF+0x177>
  803235:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803238:	8b 00                	mov    (%eax),%eax
  80323a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80323d:	89 50 04             	mov    %edx,0x4(%eax)
  803240:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803243:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803246:	89 10                	mov    %edx,(%eax)
  803248:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80324b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80324e:	89 50 04             	mov    %edx,0x4(%eax)
  803251:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803254:	8b 00                	mov    (%eax),%eax
  803256:	85 c0                	test   %eax,%eax
  803258:	75 08                	jne    803262 <realloc_block_FF+0x199>
  80325a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80325d:	a3 30 50 80 00       	mov    %eax,0x805030
  803262:	a1 38 50 80 00       	mov    0x805038,%eax
  803267:	40                   	inc    %eax
  803268:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80326d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803271:	75 17                	jne    80328a <realloc_block_FF+0x1c1>
  803273:	83 ec 04             	sub    $0x4,%esp
  803276:	68 87 42 80 00       	push   $0x804287
  80327b:	68 f7 01 00 00       	push   $0x1f7
  803280:	68 a5 42 80 00       	push   $0x8042a5
  803285:	e8 b3 cf ff ff       	call   80023d <_panic>
  80328a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	85 c0                	test   %eax,%eax
  803291:	74 10                	je     8032a3 <realloc_block_FF+0x1da>
  803293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80329b:	8b 52 04             	mov    0x4(%edx),%edx
  80329e:	89 50 04             	mov    %edx,0x4(%eax)
  8032a1:	eb 0b                	jmp    8032ae <realloc_block_FF+0x1e5>
  8032a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a6:	8b 40 04             	mov    0x4(%eax),%eax
  8032a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8032ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b1:	8b 40 04             	mov    0x4(%eax),%eax
  8032b4:	85 c0                	test   %eax,%eax
  8032b6:	74 0f                	je     8032c7 <realloc_block_FF+0x1fe>
  8032b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bb:	8b 40 04             	mov    0x4(%eax),%eax
  8032be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032c1:	8b 12                	mov    (%edx),%edx
  8032c3:	89 10                	mov    %edx,(%eax)
  8032c5:	eb 0a                	jmp    8032d1 <realloc_block_FF+0x208>
  8032c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ca:	8b 00                	mov    (%eax),%eax
  8032cc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8032e9:	48                   	dec    %eax
  8032ea:	a3 38 50 80 00       	mov    %eax,0x805038
  8032ef:	e9 83 02 00 00       	jmp    803577 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8032f4:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8032f8:	0f 86 69 02 00 00    	jbe    803567 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8032fe:	83 ec 04             	sub    $0x4,%esp
  803301:	6a 01                	push   $0x1
  803303:	ff 75 f0             	pushl  -0x10(%ebp)
  803306:	ff 75 08             	pushl  0x8(%ebp)
  803309:	e8 c8 ed ff ff       	call   8020d6 <set_block_data>
  80330e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	83 e8 04             	sub    $0x4,%eax
  803317:	8b 00                	mov    (%eax),%eax
  803319:	83 e0 fe             	and    $0xfffffffe,%eax
  80331c:	89 c2                	mov    %eax,%edx
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	01 d0                	add    %edx,%eax
  803323:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803326:	a1 38 50 80 00       	mov    0x805038,%eax
  80332b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80332e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803332:	75 68                	jne    80339c <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803334:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803338:	75 17                	jne    803351 <realloc_block_FF+0x288>
  80333a:	83 ec 04             	sub    $0x4,%esp
  80333d:	68 c0 42 80 00       	push   $0x8042c0
  803342:	68 06 02 00 00       	push   $0x206
  803347:	68 a5 42 80 00       	push   $0x8042a5
  80334c:	e8 ec ce ff ff       	call   80023d <_panic>
  803351:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803357:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80335a:	89 10                	mov    %edx,(%eax)
  80335c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80335f:	8b 00                	mov    (%eax),%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	74 0d                	je     803372 <realloc_block_FF+0x2a9>
  803365:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80336a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80336d:	89 50 04             	mov    %edx,0x4(%eax)
  803370:	eb 08                	jmp    80337a <realloc_block_FF+0x2b1>
  803372:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803375:	a3 30 50 80 00       	mov    %eax,0x805030
  80337a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803382:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803385:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338c:	a1 38 50 80 00       	mov    0x805038,%eax
  803391:	40                   	inc    %eax
  803392:	a3 38 50 80 00       	mov    %eax,0x805038
  803397:	e9 b0 01 00 00       	jmp    80354c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80339c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033a1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033a4:	76 68                	jbe    80340e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033aa:	75 17                	jne    8033c3 <realloc_block_FF+0x2fa>
  8033ac:	83 ec 04             	sub    $0x4,%esp
  8033af:	68 c0 42 80 00       	push   $0x8042c0
  8033b4:	68 0b 02 00 00       	push   $0x20b
  8033b9:	68 a5 42 80 00       	push   $0x8042a5
  8033be:	e8 7a ce ff ff       	call   80023d <_panic>
  8033c3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033cc:	89 10                	mov    %edx,(%eax)
  8033ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d1:	8b 00                	mov    (%eax),%eax
  8033d3:	85 c0                	test   %eax,%eax
  8033d5:	74 0d                	je     8033e4 <realloc_block_FF+0x31b>
  8033d7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033df:	89 50 04             	mov    %edx,0x4(%eax)
  8033e2:	eb 08                	jmp    8033ec <realloc_block_FF+0x323>
  8033e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8033ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fe:	a1 38 50 80 00       	mov    0x805038,%eax
  803403:	40                   	inc    %eax
  803404:	a3 38 50 80 00       	mov    %eax,0x805038
  803409:	e9 3e 01 00 00       	jmp    80354c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80340e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803413:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803416:	73 68                	jae    803480 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803418:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80341c:	75 17                	jne    803435 <realloc_block_FF+0x36c>
  80341e:	83 ec 04             	sub    $0x4,%esp
  803421:	68 f4 42 80 00       	push   $0x8042f4
  803426:	68 10 02 00 00       	push   $0x210
  80342b:	68 a5 42 80 00       	push   $0x8042a5
  803430:	e8 08 ce ff ff       	call   80023d <_panic>
  803435:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80343b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80343e:	89 50 04             	mov    %edx,0x4(%eax)
  803441:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803444:	8b 40 04             	mov    0x4(%eax),%eax
  803447:	85 c0                	test   %eax,%eax
  803449:	74 0c                	je     803457 <realloc_block_FF+0x38e>
  80344b:	a1 30 50 80 00       	mov    0x805030,%eax
  803450:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803453:	89 10                	mov    %edx,(%eax)
  803455:	eb 08                	jmp    80345f <realloc_block_FF+0x396>
  803457:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80345f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803462:	a3 30 50 80 00       	mov    %eax,0x805030
  803467:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803470:	a1 38 50 80 00       	mov    0x805038,%eax
  803475:	40                   	inc    %eax
  803476:	a3 38 50 80 00       	mov    %eax,0x805038
  80347b:	e9 cc 00 00 00       	jmp    80354c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803480:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803487:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80348c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80348f:	e9 8a 00 00 00       	jmp    80351e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803497:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80349a:	73 7a                	jae    803516 <realloc_block_FF+0x44d>
  80349c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034a4:	73 70                	jae    803516 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8034a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034aa:	74 06                	je     8034b2 <realloc_block_FF+0x3e9>
  8034ac:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034b0:	75 17                	jne    8034c9 <realloc_block_FF+0x400>
  8034b2:	83 ec 04             	sub    $0x4,%esp
  8034b5:	68 18 43 80 00       	push   $0x804318
  8034ba:	68 1a 02 00 00       	push   $0x21a
  8034bf:	68 a5 42 80 00       	push   $0x8042a5
  8034c4:	e8 74 cd ff ff       	call   80023d <_panic>
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 10                	mov    (%eax),%edx
  8034ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d1:	89 10                	mov    %edx,(%eax)
  8034d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	85 c0                	test   %eax,%eax
  8034da:	74 0b                	je     8034e7 <realloc_block_FF+0x41e>
  8034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034e4:	89 50 04             	mov    %edx,0x4(%eax)
  8034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034ed:	89 10                	mov    %edx,(%eax)
  8034ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f5:	89 50 04             	mov    %edx,0x4(%eax)
  8034f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fb:	8b 00                	mov    (%eax),%eax
  8034fd:	85 c0                	test   %eax,%eax
  8034ff:	75 08                	jne    803509 <realloc_block_FF+0x440>
  803501:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803504:	a3 30 50 80 00       	mov    %eax,0x805030
  803509:	a1 38 50 80 00       	mov    0x805038,%eax
  80350e:	40                   	inc    %eax
  80350f:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803514:	eb 36                	jmp    80354c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803516:	a1 34 50 80 00       	mov    0x805034,%eax
  80351b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80351e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803522:	74 07                	je     80352b <realloc_block_FF+0x462>
  803524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803527:	8b 00                	mov    (%eax),%eax
  803529:	eb 05                	jmp    803530 <realloc_block_FF+0x467>
  80352b:	b8 00 00 00 00       	mov    $0x0,%eax
  803530:	a3 34 50 80 00       	mov    %eax,0x805034
  803535:	a1 34 50 80 00       	mov    0x805034,%eax
  80353a:	85 c0                	test   %eax,%eax
  80353c:	0f 85 52 ff ff ff    	jne    803494 <realloc_block_FF+0x3cb>
  803542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803546:	0f 85 48 ff ff ff    	jne    803494 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80354c:	83 ec 04             	sub    $0x4,%esp
  80354f:	6a 00                	push   $0x0
  803551:	ff 75 d8             	pushl  -0x28(%ebp)
  803554:	ff 75 d4             	pushl  -0x2c(%ebp)
  803557:	e8 7a eb ff ff       	call   8020d6 <set_block_data>
  80355c:	83 c4 10             	add    $0x10,%esp
				return va;
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	e9 7b 02 00 00       	jmp    8037e2 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803567:	83 ec 0c             	sub    $0xc,%esp
  80356a:	68 95 43 80 00       	push   $0x804395
  80356f:	e8 86 cf ff ff       	call   8004fa <cprintf>
  803574:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803577:	8b 45 08             	mov    0x8(%ebp),%eax
  80357a:	e9 63 02 00 00       	jmp    8037e2 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80357f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803582:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803585:	0f 86 4d 02 00 00    	jbe    8037d8 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80358b:	83 ec 0c             	sub    $0xc,%esp
  80358e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803591:	e8 08 e8 ff ff       	call   801d9e <is_free_block>
  803596:	83 c4 10             	add    $0x10,%esp
  803599:	84 c0                	test   %al,%al
  80359b:	0f 84 37 02 00 00    	je     8037d8 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8035a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8035a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8035aa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035ad:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035b0:	76 38                	jbe    8035ea <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8035b2:	83 ec 0c             	sub    $0xc,%esp
  8035b5:	ff 75 08             	pushl  0x8(%ebp)
  8035b8:	e8 0c fa ff ff       	call   802fc9 <free_block>
  8035bd:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8035c0:	83 ec 0c             	sub    $0xc,%esp
  8035c3:	ff 75 0c             	pushl  0xc(%ebp)
  8035c6:	e8 3a eb ff ff       	call   802105 <alloc_block_FF>
  8035cb:	83 c4 10             	add    $0x10,%esp
  8035ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8035d1:	83 ec 08             	sub    $0x8,%esp
  8035d4:	ff 75 c0             	pushl  -0x40(%ebp)
  8035d7:	ff 75 08             	pushl  0x8(%ebp)
  8035da:	e8 ab fa ff ff       	call   80308a <copy_data>
  8035df:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8035e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035e5:	e9 f8 01 00 00       	jmp    8037e2 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8035ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ed:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8035f0:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8035f3:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8035f7:	0f 87 a0 00 00 00    	ja     80369d <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8035fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803601:	75 17                	jne    80361a <realloc_block_FF+0x551>
  803603:	83 ec 04             	sub    $0x4,%esp
  803606:	68 87 42 80 00       	push   $0x804287
  80360b:	68 38 02 00 00       	push   $0x238
  803610:	68 a5 42 80 00       	push   $0x8042a5
  803615:	e8 23 cc ff ff       	call   80023d <_panic>
  80361a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361d:	8b 00                	mov    (%eax),%eax
  80361f:	85 c0                	test   %eax,%eax
  803621:	74 10                	je     803633 <realloc_block_FF+0x56a>
  803623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803626:	8b 00                	mov    (%eax),%eax
  803628:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80362b:	8b 52 04             	mov    0x4(%edx),%edx
  80362e:	89 50 04             	mov    %edx,0x4(%eax)
  803631:	eb 0b                	jmp    80363e <realloc_block_FF+0x575>
  803633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803636:	8b 40 04             	mov    0x4(%eax),%eax
  803639:	a3 30 50 80 00       	mov    %eax,0x805030
  80363e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803641:	8b 40 04             	mov    0x4(%eax),%eax
  803644:	85 c0                	test   %eax,%eax
  803646:	74 0f                	je     803657 <realloc_block_FF+0x58e>
  803648:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364b:	8b 40 04             	mov    0x4(%eax),%eax
  80364e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803651:	8b 12                	mov    (%edx),%edx
  803653:	89 10                	mov    %edx,(%eax)
  803655:	eb 0a                	jmp    803661 <realloc_block_FF+0x598>
  803657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365a:	8b 00                	mov    (%eax),%eax
  80365c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803664:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80366a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803674:	a1 38 50 80 00       	mov    0x805038,%eax
  803679:	48                   	dec    %eax
  80367a:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80367f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803682:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803685:	01 d0                	add    %edx,%eax
  803687:	83 ec 04             	sub    $0x4,%esp
  80368a:	6a 01                	push   $0x1
  80368c:	50                   	push   %eax
  80368d:	ff 75 08             	pushl  0x8(%ebp)
  803690:	e8 41 ea ff ff       	call   8020d6 <set_block_data>
  803695:	83 c4 10             	add    $0x10,%esp
  803698:	e9 36 01 00 00       	jmp    8037d3 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80369d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036a3:	01 d0                	add    %edx,%eax
  8036a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8036a8:	83 ec 04             	sub    $0x4,%esp
  8036ab:	6a 01                	push   $0x1
  8036ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8036b0:	ff 75 08             	pushl  0x8(%ebp)
  8036b3:	e8 1e ea ff ff       	call   8020d6 <set_block_data>
  8036b8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036be:	83 e8 04             	sub    $0x4,%eax
  8036c1:	8b 00                	mov    (%eax),%eax
  8036c3:	83 e0 fe             	and    $0xfffffffe,%eax
  8036c6:	89 c2                	mov    %eax,%edx
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	01 d0                	add    %edx,%eax
  8036cd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036d4:	74 06                	je     8036dc <realloc_block_FF+0x613>
  8036d6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8036da:	75 17                	jne    8036f3 <realloc_block_FF+0x62a>
  8036dc:	83 ec 04             	sub    $0x4,%esp
  8036df:	68 18 43 80 00       	push   $0x804318
  8036e4:	68 44 02 00 00       	push   $0x244
  8036e9:	68 a5 42 80 00       	push   $0x8042a5
  8036ee:	e8 4a cb ff ff       	call   80023d <_panic>
  8036f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f6:	8b 10                	mov    (%eax),%edx
  8036f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036fb:	89 10                	mov    %edx,(%eax)
  8036fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803700:	8b 00                	mov    (%eax),%eax
  803702:	85 c0                	test   %eax,%eax
  803704:	74 0b                	je     803711 <realloc_block_FF+0x648>
  803706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803709:	8b 00                	mov    (%eax),%eax
  80370b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80370e:	89 50 04             	mov    %edx,0x4(%eax)
  803711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803714:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803717:	89 10                	mov    %edx,(%eax)
  803719:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80371c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80371f:	89 50 04             	mov    %edx,0x4(%eax)
  803722:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803725:	8b 00                	mov    (%eax),%eax
  803727:	85 c0                	test   %eax,%eax
  803729:	75 08                	jne    803733 <realloc_block_FF+0x66a>
  80372b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80372e:	a3 30 50 80 00       	mov    %eax,0x805030
  803733:	a1 38 50 80 00       	mov    0x805038,%eax
  803738:	40                   	inc    %eax
  803739:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80373e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803742:	75 17                	jne    80375b <realloc_block_FF+0x692>
  803744:	83 ec 04             	sub    $0x4,%esp
  803747:	68 87 42 80 00       	push   $0x804287
  80374c:	68 45 02 00 00       	push   $0x245
  803751:	68 a5 42 80 00       	push   $0x8042a5
  803756:	e8 e2 ca ff ff       	call   80023d <_panic>
  80375b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375e:	8b 00                	mov    (%eax),%eax
  803760:	85 c0                	test   %eax,%eax
  803762:	74 10                	je     803774 <realloc_block_FF+0x6ab>
  803764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803767:	8b 00                	mov    (%eax),%eax
  803769:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80376c:	8b 52 04             	mov    0x4(%edx),%edx
  80376f:	89 50 04             	mov    %edx,0x4(%eax)
  803772:	eb 0b                	jmp    80377f <realloc_block_FF+0x6b6>
  803774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803777:	8b 40 04             	mov    0x4(%eax),%eax
  80377a:	a3 30 50 80 00       	mov    %eax,0x805030
  80377f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803782:	8b 40 04             	mov    0x4(%eax),%eax
  803785:	85 c0                	test   %eax,%eax
  803787:	74 0f                	je     803798 <realloc_block_FF+0x6cf>
  803789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378c:	8b 40 04             	mov    0x4(%eax),%eax
  80378f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803792:	8b 12                	mov    (%edx),%edx
  803794:	89 10                	mov    %edx,(%eax)
  803796:	eb 0a                	jmp    8037a2 <realloc_block_FF+0x6d9>
  803798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379b:	8b 00                	mov    (%eax),%eax
  80379d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b5:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ba:	48                   	dec    %eax
  8037bb:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8037c0:	83 ec 04             	sub    $0x4,%esp
  8037c3:	6a 00                	push   $0x0
  8037c5:	ff 75 bc             	pushl  -0x44(%ebp)
  8037c8:	ff 75 b8             	pushl  -0x48(%ebp)
  8037cb:	e8 06 e9 ff ff       	call   8020d6 <set_block_data>
  8037d0:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8037d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d6:	eb 0a                	jmp    8037e2 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8037d8:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8037df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8037e2:	c9                   	leave  
  8037e3:	c3                   	ret    

008037e4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8037e4:	55                   	push   %ebp
  8037e5:	89 e5                	mov    %esp,%ebp
  8037e7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8037ea:	83 ec 04             	sub    $0x4,%esp
  8037ed:	68 9c 43 80 00       	push   $0x80439c
  8037f2:	68 58 02 00 00       	push   $0x258
  8037f7:	68 a5 42 80 00       	push   $0x8042a5
  8037fc:	e8 3c ca ff ff       	call   80023d <_panic>

00803801 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803801:	55                   	push   %ebp
  803802:	89 e5                	mov    %esp,%ebp
  803804:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803807:	83 ec 04             	sub    $0x4,%esp
  80380a:	68 c4 43 80 00       	push   $0x8043c4
  80380f:	68 61 02 00 00       	push   $0x261
  803814:	68 a5 42 80 00       	push   $0x8042a5
  803819:	e8 1f ca ff ff       	call   80023d <_panic>
  80381e:	66 90                	xchg   %ax,%ax

00803820 <__udivdi3>:
  803820:	55                   	push   %ebp
  803821:	57                   	push   %edi
  803822:	56                   	push   %esi
  803823:	53                   	push   %ebx
  803824:	83 ec 1c             	sub    $0x1c,%esp
  803827:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80382b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80382f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803833:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803837:	89 ca                	mov    %ecx,%edx
  803839:	89 f8                	mov    %edi,%eax
  80383b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80383f:	85 f6                	test   %esi,%esi
  803841:	75 2d                	jne    803870 <__udivdi3+0x50>
  803843:	39 cf                	cmp    %ecx,%edi
  803845:	77 65                	ja     8038ac <__udivdi3+0x8c>
  803847:	89 fd                	mov    %edi,%ebp
  803849:	85 ff                	test   %edi,%edi
  80384b:	75 0b                	jne    803858 <__udivdi3+0x38>
  80384d:	b8 01 00 00 00       	mov    $0x1,%eax
  803852:	31 d2                	xor    %edx,%edx
  803854:	f7 f7                	div    %edi
  803856:	89 c5                	mov    %eax,%ebp
  803858:	31 d2                	xor    %edx,%edx
  80385a:	89 c8                	mov    %ecx,%eax
  80385c:	f7 f5                	div    %ebp
  80385e:	89 c1                	mov    %eax,%ecx
  803860:	89 d8                	mov    %ebx,%eax
  803862:	f7 f5                	div    %ebp
  803864:	89 cf                	mov    %ecx,%edi
  803866:	89 fa                	mov    %edi,%edx
  803868:	83 c4 1c             	add    $0x1c,%esp
  80386b:	5b                   	pop    %ebx
  80386c:	5e                   	pop    %esi
  80386d:	5f                   	pop    %edi
  80386e:	5d                   	pop    %ebp
  80386f:	c3                   	ret    
  803870:	39 ce                	cmp    %ecx,%esi
  803872:	77 28                	ja     80389c <__udivdi3+0x7c>
  803874:	0f bd fe             	bsr    %esi,%edi
  803877:	83 f7 1f             	xor    $0x1f,%edi
  80387a:	75 40                	jne    8038bc <__udivdi3+0x9c>
  80387c:	39 ce                	cmp    %ecx,%esi
  80387e:	72 0a                	jb     80388a <__udivdi3+0x6a>
  803880:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803884:	0f 87 9e 00 00 00    	ja     803928 <__udivdi3+0x108>
  80388a:	b8 01 00 00 00       	mov    $0x1,%eax
  80388f:	89 fa                	mov    %edi,%edx
  803891:	83 c4 1c             	add    $0x1c,%esp
  803894:	5b                   	pop    %ebx
  803895:	5e                   	pop    %esi
  803896:	5f                   	pop    %edi
  803897:	5d                   	pop    %ebp
  803898:	c3                   	ret    
  803899:	8d 76 00             	lea    0x0(%esi),%esi
  80389c:	31 ff                	xor    %edi,%edi
  80389e:	31 c0                	xor    %eax,%eax
  8038a0:	89 fa                	mov    %edi,%edx
  8038a2:	83 c4 1c             	add    $0x1c,%esp
  8038a5:	5b                   	pop    %ebx
  8038a6:	5e                   	pop    %esi
  8038a7:	5f                   	pop    %edi
  8038a8:	5d                   	pop    %ebp
  8038a9:	c3                   	ret    
  8038aa:	66 90                	xchg   %ax,%ax
  8038ac:	89 d8                	mov    %ebx,%eax
  8038ae:	f7 f7                	div    %edi
  8038b0:	31 ff                	xor    %edi,%edi
  8038b2:	89 fa                	mov    %edi,%edx
  8038b4:	83 c4 1c             	add    $0x1c,%esp
  8038b7:	5b                   	pop    %ebx
  8038b8:	5e                   	pop    %esi
  8038b9:	5f                   	pop    %edi
  8038ba:	5d                   	pop    %ebp
  8038bb:	c3                   	ret    
  8038bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038c1:	89 eb                	mov    %ebp,%ebx
  8038c3:	29 fb                	sub    %edi,%ebx
  8038c5:	89 f9                	mov    %edi,%ecx
  8038c7:	d3 e6                	shl    %cl,%esi
  8038c9:	89 c5                	mov    %eax,%ebp
  8038cb:	88 d9                	mov    %bl,%cl
  8038cd:	d3 ed                	shr    %cl,%ebp
  8038cf:	89 e9                	mov    %ebp,%ecx
  8038d1:	09 f1                	or     %esi,%ecx
  8038d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038d7:	89 f9                	mov    %edi,%ecx
  8038d9:	d3 e0                	shl    %cl,%eax
  8038db:	89 c5                	mov    %eax,%ebp
  8038dd:	89 d6                	mov    %edx,%esi
  8038df:	88 d9                	mov    %bl,%cl
  8038e1:	d3 ee                	shr    %cl,%esi
  8038e3:	89 f9                	mov    %edi,%ecx
  8038e5:	d3 e2                	shl    %cl,%edx
  8038e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038eb:	88 d9                	mov    %bl,%cl
  8038ed:	d3 e8                	shr    %cl,%eax
  8038ef:	09 c2                	or     %eax,%edx
  8038f1:	89 d0                	mov    %edx,%eax
  8038f3:	89 f2                	mov    %esi,%edx
  8038f5:	f7 74 24 0c          	divl   0xc(%esp)
  8038f9:	89 d6                	mov    %edx,%esi
  8038fb:	89 c3                	mov    %eax,%ebx
  8038fd:	f7 e5                	mul    %ebp
  8038ff:	39 d6                	cmp    %edx,%esi
  803901:	72 19                	jb     80391c <__udivdi3+0xfc>
  803903:	74 0b                	je     803910 <__udivdi3+0xf0>
  803905:	89 d8                	mov    %ebx,%eax
  803907:	31 ff                	xor    %edi,%edi
  803909:	e9 58 ff ff ff       	jmp    803866 <__udivdi3+0x46>
  80390e:	66 90                	xchg   %ax,%ax
  803910:	8b 54 24 08          	mov    0x8(%esp),%edx
  803914:	89 f9                	mov    %edi,%ecx
  803916:	d3 e2                	shl    %cl,%edx
  803918:	39 c2                	cmp    %eax,%edx
  80391a:	73 e9                	jae    803905 <__udivdi3+0xe5>
  80391c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80391f:	31 ff                	xor    %edi,%edi
  803921:	e9 40 ff ff ff       	jmp    803866 <__udivdi3+0x46>
  803926:	66 90                	xchg   %ax,%ax
  803928:	31 c0                	xor    %eax,%eax
  80392a:	e9 37 ff ff ff       	jmp    803866 <__udivdi3+0x46>
  80392f:	90                   	nop

00803930 <__umoddi3>:
  803930:	55                   	push   %ebp
  803931:	57                   	push   %edi
  803932:	56                   	push   %esi
  803933:	53                   	push   %ebx
  803934:	83 ec 1c             	sub    $0x1c,%esp
  803937:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80393b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80393f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803943:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803947:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80394b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80394f:	89 f3                	mov    %esi,%ebx
  803951:	89 fa                	mov    %edi,%edx
  803953:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803957:	89 34 24             	mov    %esi,(%esp)
  80395a:	85 c0                	test   %eax,%eax
  80395c:	75 1a                	jne    803978 <__umoddi3+0x48>
  80395e:	39 f7                	cmp    %esi,%edi
  803960:	0f 86 a2 00 00 00    	jbe    803a08 <__umoddi3+0xd8>
  803966:	89 c8                	mov    %ecx,%eax
  803968:	89 f2                	mov    %esi,%edx
  80396a:	f7 f7                	div    %edi
  80396c:	89 d0                	mov    %edx,%eax
  80396e:	31 d2                	xor    %edx,%edx
  803970:	83 c4 1c             	add    $0x1c,%esp
  803973:	5b                   	pop    %ebx
  803974:	5e                   	pop    %esi
  803975:	5f                   	pop    %edi
  803976:	5d                   	pop    %ebp
  803977:	c3                   	ret    
  803978:	39 f0                	cmp    %esi,%eax
  80397a:	0f 87 ac 00 00 00    	ja     803a2c <__umoddi3+0xfc>
  803980:	0f bd e8             	bsr    %eax,%ebp
  803983:	83 f5 1f             	xor    $0x1f,%ebp
  803986:	0f 84 ac 00 00 00    	je     803a38 <__umoddi3+0x108>
  80398c:	bf 20 00 00 00       	mov    $0x20,%edi
  803991:	29 ef                	sub    %ebp,%edi
  803993:	89 fe                	mov    %edi,%esi
  803995:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803999:	89 e9                	mov    %ebp,%ecx
  80399b:	d3 e0                	shl    %cl,%eax
  80399d:	89 d7                	mov    %edx,%edi
  80399f:	89 f1                	mov    %esi,%ecx
  8039a1:	d3 ef                	shr    %cl,%edi
  8039a3:	09 c7                	or     %eax,%edi
  8039a5:	89 e9                	mov    %ebp,%ecx
  8039a7:	d3 e2                	shl    %cl,%edx
  8039a9:	89 14 24             	mov    %edx,(%esp)
  8039ac:	89 d8                	mov    %ebx,%eax
  8039ae:	d3 e0                	shl    %cl,%eax
  8039b0:	89 c2                	mov    %eax,%edx
  8039b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039b6:	d3 e0                	shl    %cl,%eax
  8039b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039c0:	89 f1                	mov    %esi,%ecx
  8039c2:	d3 e8                	shr    %cl,%eax
  8039c4:	09 d0                	or     %edx,%eax
  8039c6:	d3 eb                	shr    %cl,%ebx
  8039c8:	89 da                	mov    %ebx,%edx
  8039ca:	f7 f7                	div    %edi
  8039cc:	89 d3                	mov    %edx,%ebx
  8039ce:	f7 24 24             	mull   (%esp)
  8039d1:	89 c6                	mov    %eax,%esi
  8039d3:	89 d1                	mov    %edx,%ecx
  8039d5:	39 d3                	cmp    %edx,%ebx
  8039d7:	0f 82 87 00 00 00    	jb     803a64 <__umoddi3+0x134>
  8039dd:	0f 84 91 00 00 00    	je     803a74 <__umoddi3+0x144>
  8039e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039e7:	29 f2                	sub    %esi,%edx
  8039e9:	19 cb                	sbb    %ecx,%ebx
  8039eb:	89 d8                	mov    %ebx,%eax
  8039ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039f1:	d3 e0                	shl    %cl,%eax
  8039f3:	89 e9                	mov    %ebp,%ecx
  8039f5:	d3 ea                	shr    %cl,%edx
  8039f7:	09 d0                	or     %edx,%eax
  8039f9:	89 e9                	mov    %ebp,%ecx
  8039fb:	d3 eb                	shr    %cl,%ebx
  8039fd:	89 da                	mov    %ebx,%edx
  8039ff:	83 c4 1c             	add    $0x1c,%esp
  803a02:	5b                   	pop    %ebx
  803a03:	5e                   	pop    %esi
  803a04:	5f                   	pop    %edi
  803a05:	5d                   	pop    %ebp
  803a06:	c3                   	ret    
  803a07:	90                   	nop
  803a08:	89 fd                	mov    %edi,%ebp
  803a0a:	85 ff                	test   %edi,%edi
  803a0c:	75 0b                	jne    803a19 <__umoddi3+0xe9>
  803a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a13:	31 d2                	xor    %edx,%edx
  803a15:	f7 f7                	div    %edi
  803a17:	89 c5                	mov    %eax,%ebp
  803a19:	89 f0                	mov    %esi,%eax
  803a1b:	31 d2                	xor    %edx,%edx
  803a1d:	f7 f5                	div    %ebp
  803a1f:	89 c8                	mov    %ecx,%eax
  803a21:	f7 f5                	div    %ebp
  803a23:	89 d0                	mov    %edx,%eax
  803a25:	e9 44 ff ff ff       	jmp    80396e <__umoddi3+0x3e>
  803a2a:	66 90                	xchg   %ax,%ax
  803a2c:	89 c8                	mov    %ecx,%eax
  803a2e:	89 f2                	mov    %esi,%edx
  803a30:	83 c4 1c             	add    $0x1c,%esp
  803a33:	5b                   	pop    %ebx
  803a34:	5e                   	pop    %esi
  803a35:	5f                   	pop    %edi
  803a36:	5d                   	pop    %ebp
  803a37:	c3                   	ret    
  803a38:	3b 04 24             	cmp    (%esp),%eax
  803a3b:	72 06                	jb     803a43 <__umoddi3+0x113>
  803a3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a41:	77 0f                	ja     803a52 <__umoddi3+0x122>
  803a43:	89 f2                	mov    %esi,%edx
  803a45:	29 f9                	sub    %edi,%ecx
  803a47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a4b:	89 14 24             	mov    %edx,(%esp)
  803a4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a52:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a56:	8b 14 24             	mov    (%esp),%edx
  803a59:	83 c4 1c             	add    $0x1c,%esp
  803a5c:	5b                   	pop    %ebx
  803a5d:	5e                   	pop    %esi
  803a5e:	5f                   	pop    %edi
  803a5f:	5d                   	pop    %ebp
  803a60:	c3                   	ret    
  803a61:	8d 76 00             	lea    0x0(%esi),%esi
  803a64:	2b 04 24             	sub    (%esp),%eax
  803a67:	19 fa                	sbb    %edi,%edx
  803a69:	89 d1                	mov    %edx,%ecx
  803a6b:	89 c6                	mov    %eax,%esi
  803a6d:	e9 71 ff ff ff       	jmp    8039e3 <__umoddi3+0xb3>
  803a72:	66 90                	xchg   %ax,%ax
  803a74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a78:	72 ea                	jb     803a64 <__umoddi3+0x134>
  803a7a:	89 d9                	mov    %ebx,%ecx
  803a7c:	e9 62 ff ff ff       	jmp    8039e3 <__umoddi3+0xb3>
