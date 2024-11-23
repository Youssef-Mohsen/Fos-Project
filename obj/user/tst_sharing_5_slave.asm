
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
  80005b:	68 e0 3a 80 00       	push   $0x803ae0
  800060:	6a 0c                	push   $0xc
  800062:	68 fc 3a 80 00       	push   $0x803afc
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
  800073:	e8 40 1a 00 00       	call   801ab8 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 17 3b 80 00       	push   $0x803b17
  800080:	50                   	push   %eax
  800081:	e8 f9 15 00 00       	call   80167f <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80008c:	e8 45 18 00 00       	call   8018d6 <sys_calculate_free_frames>
  800091:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 1c 3b 80 00       	push   $0x803b1c
  80009c:	e8 59 04 00 00       	call   8004fa <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000aa:	e8 55 16 00 00       	call   801704 <sfree>
  8000af:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave env removed x\n");
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 40 3b 80 00       	push   $0x803b40
  8000ba:	e8 3b 04 00 00       	call   8004fa <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp

	diff = (sys_calculate_free_frames() - freeFrames);
  8000c2:	e8 0f 18 00 00       	call   8018d6 <sys_calculate_free_frames>
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
  8000e5:	68 58 3b 80 00       	push   $0x803b58
  8000ea:	6a 23                	push   $0x23
  8000ec:	68 fc 3a 80 00       	push   $0x803afc
  8000f1:	e8 47 01 00 00       	call   80023d <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  8000f6:	e8 e2 1a 00 00       	call   801bdd <inctst>

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
  800104:	e8 96 19 00 00       	call   801a9f <sys_getenvindex>
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
  800172:	e8 ac 16 00 00       	call   801823 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 fc 3b 80 00       	push   $0x803bfc
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
  8001a2:	68 24 3c 80 00       	push   $0x803c24
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
  8001d3:	68 4c 3c 80 00       	push   $0x803c4c
  8001d8:	e8 1d 03 00 00       	call   8004fa <cprintf>
  8001dd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001e5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001eb:	83 ec 08             	sub    $0x8,%esp
  8001ee:	50                   	push   %eax
  8001ef:	68 a4 3c 80 00       	push   $0x803ca4
  8001f4:	e8 01 03 00 00       	call   8004fa <cprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	68 fc 3b 80 00       	push   $0x803bfc
  800204:	e8 f1 02 00 00       	call   8004fa <cprintf>
  800209:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80020c:	e8 2c 16 00 00       	call   80183d <sys_unlock_cons>
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
  800224:	e8 42 18 00 00       	call   801a6b <sys_destroy_env>
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
  800235:	e8 97 18 00 00       	call   801ad1 <sys_exit_env>
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
  80025e:	68 b8 3c 80 00       	push   $0x803cb8
  800263:	e8 92 02 00 00       	call   8004fa <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80026b:	a1 00 50 80 00       	mov    0x805000,%eax
  800270:	ff 75 0c             	pushl  0xc(%ebp)
  800273:	ff 75 08             	pushl  0x8(%ebp)
  800276:	50                   	push   %eax
  800277:	68 bd 3c 80 00       	push   $0x803cbd
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
  80029b:	68 d9 3c 80 00       	push   $0x803cd9
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
  8002ca:	68 dc 3c 80 00       	push   $0x803cdc
  8002cf:	6a 26                	push   $0x26
  8002d1:	68 28 3d 80 00       	push   $0x803d28
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
  80039f:	68 34 3d 80 00       	push   $0x803d34
  8003a4:	6a 3a                	push   $0x3a
  8003a6:	68 28 3d 80 00       	push   $0x803d28
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
  800412:	68 88 3d 80 00       	push   $0x803d88
  800417:	6a 44                	push   $0x44
  800419:	68 28 3d 80 00       	push   $0x803d28
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
  80046c:	e8 70 13 00 00       	call   8017e1 <sys_cputs>
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
  8004e3:	e8 f9 12 00 00       	call   8017e1 <sys_cputs>
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
  80052d:	e8 f1 12 00 00       	call   801823 <sys_lock_cons>
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
  80054d:	e8 eb 12 00 00       	call   80183d <sys_unlock_cons>
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
  800597:	e8 dc 32 00 00       	call   803878 <__udivdi3>
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
  8005e7:	e8 9c 33 00 00       	call   803988 <__umoddi3>
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	05 f4 3f 80 00       	add    $0x803ff4,%eax
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
  800742:	8b 04 85 18 40 80 00 	mov    0x804018(,%eax,4),%eax
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
  800823:	8b 34 9d 60 3e 80 00 	mov    0x803e60(,%ebx,4),%esi
  80082a:	85 f6                	test   %esi,%esi
  80082c:	75 19                	jne    800847 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80082e:	53                   	push   %ebx
  80082f:	68 05 40 80 00       	push   $0x804005
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
  800848:	68 0e 40 80 00       	push   $0x80400e
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
  800875:	be 11 40 80 00       	mov    $0x804011,%esi
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
  801280:	68 88 41 80 00       	push   $0x804188
  801285:	68 3f 01 00 00       	push   $0x13f
  80128a:	68 aa 41 80 00       	push   $0x8041aa
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
  8012a0:	e8 e7 0a 00 00       	call   801d8c <sys_sbrk>
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
  80131b:	e8 f0 08 00 00       	call   801c10 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801320:	85 c0                	test   %eax,%eax
  801322:	74 16                	je     80133a <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801324:	83 ec 0c             	sub    $0xc,%esp
  801327:	ff 75 08             	pushl  0x8(%ebp)
  80132a:	e8 30 0e 00 00       	call   80215f <alloc_block_FF>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801335:	e9 8a 01 00 00       	jmp    8014c4 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80133a:	e8 02 09 00 00       	call   801c41 <sys_isUHeapPlacementStrategyBESTFIT>
  80133f:	85 c0                	test   %eax,%eax
  801341:	0f 84 7d 01 00 00    	je     8014c4 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801347:	83 ec 0c             	sub    $0xc,%esp
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	e8 c9 12 00 00       	call   80261b <alloc_block_BF>
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
  80139d:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8013ea:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801441:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  8014a3:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	ff 75 08             	pushl  0x8(%ebp)
  8014b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b3:	e8 0b 09 00 00       	call   801dc3 <sys_allocate_user_mem>
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
  8014fb:	e8 df 08 00 00       	call   801ddf <get_block_size>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801506:	83 ec 0c             	sub    $0xc,%esp
  801509:	ff 75 08             	pushl  0x8(%ebp)
  80150c:	e8 12 1b 00 00       	call   803023 <free_block>
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
  801546:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801583:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  8015a3:	e8 ff 07 00 00       	call   801da7 <sys_free_user_mem>
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
  8015b1:	68 b8 41 80 00       	push   $0x8041b8
  8015b6:	68 85 00 00 00       	push   $0x85
  8015bb:	68 e2 41 80 00       	push   $0x8041e2
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
  8015d7:	75 0a                	jne    8015e3 <smalloc+0x1c>
  8015d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015de:	e9 9a 00 00 00       	jmp    80167d <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8015e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015e9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f6:	39 d0                	cmp    %edx,%eax
  8015f8:	73 02                	jae    8015fc <smalloc+0x35>
  8015fa:	89 d0                	mov    %edx,%eax
  8015fc:	83 ec 0c             	sub    $0xc,%esp
  8015ff:	50                   	push   %eax
  801600:	e8 a5 fc ff ff       	call   8012aa <malloc>
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80160b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80160f:	75 07                	jne    801618 <smalloc+0x51>
  801611:	b8 00 00 00 00       	mov    $0x0,%eax
  801616:	eb 65                	jmp    80167d <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801618:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80161c:	ff 75 ec             	pushl  -0x14(%ebp)
  80161f:	50                   	push   %eax
  801620:	ff 75 0c             	pushl  0xc(%ebp)
  801623:	ff 75 08             	pushl  0x8(%ebp)
  801626:	e8 83 03 00 00       	call   8019ae <sys_createSharedObject>
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801631:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801635:	74 06                	je     80163d <smalloc+0x76>
  801637:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80163b:	75 07                	jne    801644 <smalloc+0x7d>
  80163d:	b8 00 00 00 00       	mov    $0x0,%eax
  801642:	eb 39                	jmp    80167d <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	ff 75 ec             	pushl  -0x14(%ebp)
  80164a:	68 ee 41 80 00       	push   $0x8041ee
  80164f:	e8 a6 ee ff ff       	call   8004fa <cprintf>
  801654:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801657:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80165a:	a1 20 50 80 00       	mov    0x805020,%eax
  80165f:	8b 40 78             	mov    0x78(%eax),%eax
  801662:	29 c2                	sub    %eax,%edx
  801664:	89 d0                	mov    %edx,%eax
  801666:	2d 00 10 00 00       	sub    $0x1000,%eax
  80166b:	c1 e8 0c             	shr    $0xc,%eax
  80166e:	89 c2                	mov    %eax,%edx
  801670:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801673:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80167a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	e8 45 03 00 00       	call   8019d8 <sys_getSizeOfSharedObject>
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801699:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80169d:	75 07                	jne    8016a6 <sget+0x27>
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a4:	eb 5c                	jmp    801702 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ac:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b9:	39 d0                	cmp    %edx,%eax
  8016bb:	7d 02                	jge    8016bf <sget+0x40>
  8016bd:	89 d0                	mov    %edx,%eax
  8016bf:	83 ec 0c             	sub    $0xc,%esp
  8016c2:	50                   	push   %eax
  8016c3:	e8 e2 fb ff ff       	call   8012aa <malloc>
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8016ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016d2:	75 07                	jne    8016db <sget+0x5c>
  8016d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d9:	eb 27                	jmp    801702 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	ff 75 e8             	pushl  -0x18(%ebp)
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	ff 75 08             	pushl  0x8(%ebp)
  8016e7:	e8 09 03 00 00       	call   8019f5 <sys_getSharedObject>
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8016f2:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8016f6:	75 07                	jne    8016ff <sget+0x80>
  8016f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fd:	eb 03                	jmp    801702 <sget+0x83>
	return ptr;
  8016ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80170a:	8b 55 08             	mov    0x8(%ebp),%edx
  80170d:	a1 20 50 80 00       	mov    0x805020,%eax
  801712:	8b 40 78             	mov    0x78(%eax),%eax
  801715:	29 c2                	sub    %eax,%edx
  801717:	89 d0                	mov    %edx,%eax
  801719:	2d 00 10 00 00       	sub    $0x1000,%eax
  80171e:	c1 e8 0c             	shr    $0xc,%eax
  801721:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801728:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80172b:	83 ec 08             	sub    $0x8,%esp
  80172e:	ff 75 08             	pushl  0x8(%ebp)
  801731:	ff 75 f4             	pushl  -0xc(%ebp)
  801734:	e8 db 02 00 00       	call   801a14 <sys_freeSharedObject>
  801739:	83 c4 10             	add    $0x10,%esp
  80173c:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80173f:	90                   	nop
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801748:	83 ec 04             	sub    $0x4,%esp
  80174b:	68 00 42 80 00       	push   $0x804200
  801750:	68 dd 00 00 00       	push   $0xdd
  801755:	68 e2 41 80 00       	push   $0x8041e2
  80175a:	e8 de ea ff ff       	call   80023d <_panic>

0080175f <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	68 26 42 80 00       	push   $0x804226
  80176d:	68 e9 00 00 00       	push   $0xe9
  801772:	68 e2 41 80 00       	push   $0x8041e2
  801777:	e8 c1 ea ff ff       	call   80023d <_panic>

0080177c <shrink>:

}
void shrink(uint32 newSize)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	68 26 42 80 00       	push   $0x804226
  80178a:	68 ee 00 00 00       	push   $0xee
  80178f:	68 e2 41 80 00       	push   $0x8041e2
  801794:	e8 a4 ea ff ff       	call   80023d <_panic>

00801799 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80179f:	83 ec 04             	sub    $0x4,%esp
  8017a2:	68 26 42 80 00       	push   $0x804226
  8017a7:	68 f3 00 00 00       	push   $0xf3
  8017ac:	68 e2 41 80 00       	push   $0x8041e2
  8017b1:	e8 87 ea ff ff       	call   80023d <_panic>

008017b6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	57                   	push   %edi
  8017ba:	56                   	push   %esi
  8017bb:	53                   	push   %ebx
  8017bc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017cb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ce:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017d1:	cd 30                	int    $0x30
  8017d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	5b                   	pop    %ebx
  8017dd:	5e                   	pop    %esi
  8017de:	5f                   	pop    %edi
  8017df:	5d                   	pop    %ebp
  8017e0:	c3                   	ret    

008017e1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017ed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	52                   	push   %edx
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	50                   	push   %eax
  8017fd:	6a 00                	push   $0x0
  8017ff:	e8 b2 ff ff ff       	call   8017b6 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_cgetc>:

int
sys_cgetc(void)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 02                	push   $0x2
  801819:	e8 98 ff ff ff       	call   8017b6 <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 03                	push   $0x3
  801832:	e8 7f ff ff ff       	call   8017b6 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	90                   	nop
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 04                	push   $0x4
  80184c:	e8 65 ff ff ff       	call   8017b6 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	90                   	nop
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80185a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	52                   	push   %edx
  801867:	50                   	push   %eax
  801868:	6a 08                	push   $0x8
  80186a:	e8 47 ff ff ff       	call   8017b6 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	56                   	push   %esi
  801878:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801879:	8b 75 18             	mov    0x18(%ebp),%esi
  80187c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80187f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801882:	8b 55 0c             	mov    0xc(%ebp),%edx
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	56                   	push   %esi
  801889:	53                   	push   %ebx
  80188a:	51                   	push   %ecx
  80188b:	52                   	push   %edx
  80188c:	50                   	push   %eax
  80188d:	6a 09                	push   $0x9
  80188f:	e8 22 ff ff ff       	call   8017b6 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189a:	5b                   	pop    %ebx
  80189b:	5e                   	pop    %esi
  80189c:	5d                   	pop    %ebp
  80189d:	c3                   	ret    

0080189e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	52                   	push   %edx
  8018ae:	50                   	push   %eax
  8018af:	6a 0a                	push   $0xa
  8018b1:	e8 00 ff ff ff       	call   8017b6 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	ff 75 0c             	pushl  0xc(%ebp)
  8018c7:	ff 75 08             	pushl  0x8(%ebp)
  8018ca:	6a 0b                	push   $0xb
  8018cc:	e8 e5 fe ff ff       	call   8017b6 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 0c                	push   $0xc
  8018e5:	e8 cc fe ff ff       	call   8017b6 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 0d                	push   $0xd
  8018fe:	e8 b3 fe ff ff       	call   8017b6 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 0e                	push   $0xe
  801917:	e8 9a fe ff ff       	call   8017b6 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 0f                	push   $0xf
  801930:	e8 81 fe ff ff       	call   8017b6 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	6a 10                	push   $0x10
  80194a:	e8 67 fe ff ff       	call   8017b6 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 11                	push   $0x11
  801963:	e8 4e fe ff ff       	call   8017b6 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	90                   	nop
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_cputc>:

void
sys_cputc(const char c)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 04             	sub    $0x4,%esp
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80197a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	50                   	push   %eax
  801987:	6a 01                	push   $0x1
  801989:	e8 28 fe ff ff       	call   8017b6 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	90                   	nop
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 14                	push   $0x14
  8019a3:	e8 0e fe ff ff       	call   8017b6 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019ba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019bd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	6a 00                	push   $0x0
  8019c6:	51                   	push   %ecx
  8019c7:	52                   	push   %edx
  8019c8:	ff 75 0c             	pushl  0xc(%ebp)
  8019cb:	50                   	push   %eax
  8019cc:	6a 15                	push   $0x15
  8019ce:	e8 e3 fd ff ff       	call   8017b6 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	52                   	push   %edx
  8019e8:	50                   	push   %eax
  8019e9:	6a 16                	push   $0x16
  8019eb:	e8 c6 fd ff ff       	call   8017b6 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	51                   	push   %ecx
  801a06:	52                   	push   %edx
  801a07:	50                   	push   %eax
  801a08:	6a 17                	push   $0x17
  801a0a:	e8 a7 fd ff ff       	call   8017b6 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	52                   	push   %edx
  801a24:	50                   	push   %eax
  801a25:	6a 18                	push   $0x18
  801a27:	e8 8a fd ff ff       	call   8017b6 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	ff 75 14             	pushl  0x14(%ebp)
  801a3c:	ff 75 10             	pushl  0x10(%ebp)
  801a3f:	ff 75 0c             	pushl  0xc(%ebp)
  801a42:	50                   	push   %eax
  801a43:	6a 19                	push   $0x19
  801a45:	e8 6c fd ff ff       	call   8017b6 <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	50                   	push   %eax
  801a5e:	6a 1a                	push   $0x1a
  801a60:	e8 51 fd ff ff       	call   8017b6 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	90                   	nop
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	50                   	push   %eax
  801a7a:	6a 1b                	push   $0x1b
  801a7c:	e8 35 fd ff ff       	call   8017b6 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 05                	push   $0x5
  801a95:	e8 1c fd ff ff       	call   8017b6 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 06                	push   $0x6
  801aae:	e8 03 fd ff ff       	call   8017b6 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 07                	push   $0x7
  801ac7:	e8 ea fc ff ff       	call   8017b6 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_exit_env>:


void sys_exit_env(void)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 1c                	push   $0x1c
  801ae0:	e8 d1 fc ff ff       	call   8017b6 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	90                   	nop
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801af1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801af4:	8d 50 04             	lea    0x4(%eax),%edx
  801af7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	52                   	push   %edx
  801b01:	50                   	push   %eax
  801b02:	6a 1d                	push   $0x1d
  801b04:	e8 ad fc ff ff       	call   8017b6 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
	return result;
  801b0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b15:	89 01                	mov    %eax,(%ecx)
  801b17:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	c9                   	leave  
  801b1e:	c2 04 00             	ret    $0x4

00801b21 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	ff 75 10             	pushl  0x10(%ebp)
  801b2b:	ff 75 0c             	pushl  0xc(%ebp)
  801b2e:	ff 75 08             	pushl  0x8(%ebp)
  801b31:	6a 13                	push   $0x13
  801b33:	e8 7e fc ff ff       	call   8017b6 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3b:	90                   	nop
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_rcr2>:
uint32 sys_rcr2()
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 1e                	push   $0x1e
  801b4d:	e8 64 fc ff ff       	call   8017b6 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b63:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	50                   	push   %eax
  801b70:	6a 1f                	push   $0x1f
  801b72:	e8 3f fc ff ff       	call   8017b6 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7a:	90                   	nop
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <rsttst>:
void rsttst()
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 21                	push   $0x21
  801b8c:	e8 25 fc ff ff       	call   8017b6 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
	return ;
  801b94:	90                   	nop
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 04             	sub    $0x4,%esp
  801b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ba3:	8b 55 18             	mov    0x18(%ebp),%edx
  801ba6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801baa:	52                   	push   %edx
  801bab:	50                   	push   %eax
  801bac:	ff 75 10             	pushl  0x10(%ebp)
  801baf:	ff 75 0c             	pushl  0xc(%ebp)
  801bb2:	ff 75 08             	pushl  0x8(%ebp)
  801bb5:	6a 20                	push   $0x20
  801bb7:	e8 fa fb ff ff       	call   8017b6 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbf:	90                   	nop
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <chktst>:
void chktst(uint32 n)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	6a 22                	push   $0x22
  801bd2:	e8 df fb ff ff       	call   8017b6 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bda:	90                   	nop
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <inctst>:

void inctst()
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 23                	push   $0x23
  801bec:	e8 c5 fb ff ff       	call   8017b6 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf4:	90                   	nop
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <gettst>:
uint32 gettst()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 24                	push   $0x24
  801c06:	e8 ab fb ff ff       	call   8017b6 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 25                	push   $0x25
  801c22:	e8 8f fb ff ff       	call   8017b6 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
  801c2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c2d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c31:	75 07                	jne    801c3a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c33:	b8 01 00 00 00       	mov    $0x1,%eax
  801c38:	eb 05                	jmp    801c3f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 25                	push   $0x25
  801c53:	e8 5e fb ff ff       	call   8017b6 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
  801c5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c5e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c62:	75 07                	jne    801c6b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c64:	b8 01 00 00 00       	mov    $0x1,%eax
  801c69:	eb 05                	jmp    801c70 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 25                	push   $0x25
  801c84:	e8 2d fb ff ff       	call   8017b6 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
  801c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c8f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c93:	75 07                	jne    801c9c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c95:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9a:	eb 05                	jmp    801ca1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 25                	push   $0x25
  801cb5:	e8 fc fa ff ff       	call   8017b6 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
  801cbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cc0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cc4:	75 07                	jne    801ccd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccb:	eb 05                	jmp    801cd2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ccd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	ff 75 08             	pushl  0x8(%ebp)
  801ce2:	6a 26                	push   $0x26
  801ce4:	e8 cd fa ff ff       	call   8017b6 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cec:	90                   	nop
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cf3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	6a 00                	push   $0x0
  801d01:	53                   	push   %ebx
  801d02:	51                   	push   %ecx
  801d03:	52                   	push   %edx
  801d04:	50                   	push   %eax
  801d05:	6a 27                	push   $0x27
  801d07:	e8 aa fa ff ff       	call   8017b6 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 28                	push   $0x28
  801d27:	e8 8a fa ff ff       	call   8017b6 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d34:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	51                   	push   %ecx
  801d40:	ff 75 10             	pushl  0x10(%ebp)
  801d43:	52                   	push   %edx
  801d44:	50                   	push   %eax
  801d45:	6a 29                	push   $0x29
  801d47:	e8 6a fa ff ff       	call   8017b6 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	ff 75 10             	pushl  0x10(%ebp)
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	ff 75 08             	pushl  0x8(%ebp)
  801d61:	6a 12                	push   $0x12
  801d63:	e8 4e fa ff ff       	call   8017b6 <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6b:	90                   	nop
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	52                   	push   %edx
  801d7e:	50                   	push   %eax
  801d7f:	6a 2a                	push   $0x2a
  801d81:	e8 30 fa ff ff       	call   8017b6 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
	return;
  801d89:	90                   	nop
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	50                   	push   %eax
  801d9b:	6a 2b                	push   $0x2b
  801d9d:	e8 14 fa ff ff       	call   8017b6 <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	6a 2c                	push   $0x2c
  801db8:	e8 f9 f9 ff ff       	call   8017b6 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
	return;
  801dc0:	90                   	nop
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	ff 75 0c             	pushl  0xc(%ebp)
  801dcf:	ff 75 08             	pushl  0x8(%ebp)
  801dd2:	6a 2d                	push   $0x2d
  801dd4:	e8 dd f9 ff ff       	call   8017b6 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
	return;
  801ddc:	90                   	nop
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	83 e8 04             	sub    $0x4,%eax
  801deb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801df1:	8b 00                	mov    (%eax),%eax
  801df3:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	83 e8 04             	sub    $0x4,%eax
  801e04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e0a:	8b 00                	mov    (%eax),%eax
  801e0c:	83 e0 01             	and    $0x1,%eax
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	0f 94 c0             	sete   %al
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e26:	83 f8 02             	cmp    $0x2,%eax
  801e29:	74 2b                	je     801e56 <alloc_block+0x40>
  801e2b:	83 f8 02             	cmp    $0x2,%eax
  801e2e:	7f 07                	jg     801e37 <alloc_block+0x21>
  801e30:	83 f8 01             	cmp    $0x1,%eax
  801e33:	74 0e                	je     801e43 <alloc_block+0x2d>
  801e35:	eb 58                	jmp    801e8f <alloc_block+0x79>
  801e37:	83 f8 03             	cmp    $0x3,%eax
  801e3a:	74 2d                	je     801e69 <alloc_block+0x53>
  801e3c:	83 f8 04             	cmp    $0x4,%eax
  801e3f:	74 3b                	je     801e7c <alloc_block+0x66>
  801e41:	eb 4c                	jmp    801e8f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e43:	83 ec 0c             	sub    $0xc,%esp
  801e46:	ff 75 08             	pushl  0x8(%ebp)
  801e49:	e8 11 03 00 00       	call   80215f <alloc_block_FF>
  801e4e:	83 c4 10             	add    $0x10,%esp
  801e51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e54:	eb 4a                	jmp    801ea0 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	ff 75 08             	pushl  0x8(%ebp)
  801e5c:	e8 fa 19 00 00       	call   80385b <alloc_block_NF>
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e67:	eb 37                	jmp    801ea0 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e69:	83 ec 0c             	sub    $0xc,%esp
  801e6c:	ff 75 08             	pushl  0x8(%ebp)
  801e6f:	e8 a7 07 00 00       	call   80261b <alloc_block_BF>
  801e74:	83 c4 10             	add    $0x10,%esp
  801e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e7a:	eb 24                	jmp    801ea0 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e7c:	83 ec 0c             	sub    $0xc,%esp
  801e7f:	ff 75 08             	pushl  0x8(%ebp)
  801e82:	e8 b7 19 00 00       	call   80383e <alloc_block_WF>
  801e87:	83 c4 10             	add    $0x10,%esp
  801e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e8d:	eb 11                	jmp    801ea0 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e8f:	83 ec 0c             	sub    $0xc,%esp
  801e92:	68 38 42 80 00       	push   $0x804238
  801e97:	e8 5e e6 ff ff       	call   8004fa <cprintf>
  801e9c:	83 c4 10             	add    $0x10,%esp
		break;
  801e9f:	90                   	nop
	}
	return va;
  801ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	53                   	push   %ebx
  801ea9:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801eac:	83 ec 0c             	sub    $0xc,%esp
  801eaf:	68 58 42 80 00       	push   $0x804258
  801eb4:	e8 41 e6 ff ff       	call   8004fa <cprintf>
  801eb9:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ebc:	83 ec 0c             	sub    $0xc,%esp
  801ebf:	68 83 42 80 00       	push   $0x804283
  801ec4:	e8 31 e6 ff ff       	call   8004fa <cprintf>
  801ec9:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed2:	eb 37                	jmp    801f0b <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801ed4:	83 ec 0c             	sub    $0xc,%esp
  801ed7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eda:	e8 19 ff ff ff       	call   801df8 <is_free_block>
  801edf:	83 c4 10             	add    $0x10,%esp
  801ee2:	0f be d8             	movsbl %al,%ebx
  801ee5:	83 ec 0c             	sub    $0xc,%esp
  801ee8:	ff 75 f4             	pushl  -0xc(%ebp)
  801eeb:	e8 ef fe ff ff       	call   801ddf <get_block_size>
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	83 ec 04             	sub    $0x4,%esp
  801ef6:	53                   	push   %ebx
  801ef7:	50                   	push   %eax
  801ef8:	68 9b 42 80 00       	push   $0x80429b
  801efd:	e8 f8 e5 ff ff       	call   8004fa <cprintf>
  801f02:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f05:	8b 45 10             	mov    0x10(%ebp),%eax
  801f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0f:	74 07                	je     801f18 <print_blocks_list+0x73>
  801f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f14:	8b 00                	mov    (%eax),%eax
  801f16:	eb 05                	jmp    801f1d <print_blocks_list+0x78>
  801f18:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1d:	89 45 10             	mov    %eax,0x10(%ebp)
  801f20:	8b 45 10             	mov    0x10(%ebp),%eax
  801f23:	85 c0                	test   %eax,%eax
  801f25:	75 ad                	jne    801ed4 <print_blocks_list+0x2f>
  801f27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2b:	75 a7                	jne    801ed4 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f2d:	83 ec 0c             	sub    $0xc,%esp
  801f30:	68 58 42 80 00       	push   $0x804258
  801f35:	e8 c0 e5 ff ff       	call   8004fa <cprintf>
  801f3a:	83 c4 10             	add    $0x10,%esp

}
  801f3d:	90                   	nop
  801f3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4c:	83 e0 01             	and    $0x1,%eax
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	74 03                	je     801f56 <initialize_dynamic_allocator+0x13>
  801f53:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f5a:	0f 84 c7 01 00 00    	je     802127 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f60:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f67:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f70:	01 d0                	add    %edx,%eax
  801f72:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f77:	0f 87 ad 01 00 00    	ja     80212a <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	85 c0                	test   %eax,%eax
  801f82:	0f 89 a5 01 00 00    	jns    80212d <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f88:	8b 55 08             	mov    0x8(%ebp),%edx
  801f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8e:	01 d0                	add    %edx,%eax
  801f90:	83 e8 04             	sub    $0x4,%eax
  801f93:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f9f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa7:	e9 87 00 00 00       	jmp    802033 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801fac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb0:	75 14                	jne    801fc6 <initialize_dynamic_allocator+0x83>
  801fb2:	83 ec 04             	sub    $0x4,%esp
  801fb5:	68 b3 42 80 00       	push   $0x8042b3
  801fba:	6a 79                	push   $0x79
  801fbc:	68 d1 42 80 00       	push   $0x8042d1
  801fc1:	e8 77 e2 ff ff       	call   80023d <_panic>
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	8b 00                	mov    (%eax),%eax
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	74 10                	je     801fdf <initialize_dynamic_allocator+0x9c>
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 00                	mov    (%eax),%eax
  801fd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd7:	8b 52 04             	mov    0x4(%edx),%edx
  801fda:	89 50 04             	mov    %edx,0x4(%eax)
  801fdd:	eb 0b                	jmp    801fea <initialize_dynamic_allocator+0xa7>
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	8b 40 04             	mov    0x4(%eax),%eax
  801fe5:	a3 30 50 80 00       	mov    %eax,0x805030
  801fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fed:	8b 40 04             	mov    0x4(%eax),%eax
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	74 0f                	je     802003 <initialize_dynamic_allocator+0xc0>
  801ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff7:	8b 40 04             	mov    0x4(%eax),%eax
  801ffa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffd:	8b 12                	mov    (%edx),%edx
  801fff:	89 10                	mov    %edx,(%eax)
  802001:	eb 0a                	jmp    80200d <initialize_dynamic_allocator+0xca>
  802003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802006:	8b 00                	mov    (%eax),%eax
  802008:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802019:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802020:	a1 38 50 80 00       	mov    0x805038,%eax
  802025:	48                   	dec    %eax
  802026:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80202b:	a1 34 50 80 00       	mov    0x805034,%eax
  802030:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802033:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802037:	74 07                	je     802040 <initialize_dynamic_allocator+0xfd>
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	8b 00                	mov    (%eax),%eax
  80203e:	eb 05                	jmp    802045 <initialize_dynamic_allocator+0x102>
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	a3 34 50 80 00       	mov    %eax,0x805034
  80204a:	a1 34 50 80 00       	mov    0x805034,%eax
  80204f:	85 c0                	test   %eax,%eax
  802051:	0f 85 55 ff ff ff    	jne    801fac <initialize_dynamic_allocator+0x69>
  802057:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205b:	0f 85 4b ff ff ff    	jne    801fac <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802070:	a1 44 50 80 00       	mov    0x805044,%eax
  802075:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80207a:	a1 40 50 80 00       	mov    0x805040,%eax
  80207f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	83 c0 08             	add    $0x8,%eax
  80208b:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	83 c0 04             	add    $0x4,%eax
  802094:	8b 55 0c             	mov    0xc(%ebp),%edx
  802097:	83 ea 08             	sub    $0x8,%edx
  80209a:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80209c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	01 d0                	add    %edx,%eax
  8020a4:	83 e8 08             	sub    $0x8,%eax
  8020a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020aa:	83 ea 08             	sub    $0x8,%edx
  8020ad:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020c6:	75 17                	jne    8020df <initialize_dynamic_allocator+0x19c>
  8020c8:	83 ec 04             	sub    $0x4,%esp
  8020cb:	68 ec 42 80 00       	push   $0x8042ec
  8020d0:	68 90 00 00 00       	push   $0x90
  8020d5:	68 d1 42 80 00       	push   $0x8042d1
  8020da:	e8 5e e1 ff ff       	call   80023d <_panic>
  8020df:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e8:	89 10                	mov    %edx,(%eax)
  8020ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ed:	8b 00                	mov    (%eax),%eax
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	74 0d                	je     802100 <initialize_dynamic_allocator+0x1bd>
  8020f3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020fb:	89 50 04             	mov    %edx,0x4(%eax)
  8020fe:	eb 08                	jmp    802108 <initialize_dynamic_allocator+0x1c5>
  802100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802103:	a3 30 50 80 00       	mov    %eax,0x805030
  802108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802110:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802113:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80211a:	a1 38 50 80 00       	mov    0x805038,%eax
  80211f:	40                   	inc    %eax
  802120:	a3 38 50 80 00       	mov    %eax,0x805038
  802125:	eb 07                	jmp    80212e <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802127:	90                   	nop
  802128:	eb 04                	jmp    80212e <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80212a:	90                   	nop
  80212b:	eb 01                	jmp    80212e <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80212d:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802133:	8b 45 10             	mov    0x10(%ebp),%eax
  802136:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80213f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802142:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	83 e8 04             	sub    $0x4,%eax
  80214a:	8b 00                	mov    (%eax),%eax
  80214c:	83 e0 fe             	and    $0xfffffffe,%eax
  80214f:	8d 50 f8             	lea    -0x8(%eax),%edx
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	01 c2                	add    %eax,%edx
  802157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215a:	89 02                	mov    %eax,(%edx)
}
  80215c:	90                   	nop
  80215d:	5d                   	pop    %ebp
  80215e:	c3                   	ret    

0080215f <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	83 e0 01             	and    $0x1,%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	74 03                	je     802172 <alloc_block_FF+0x13>
  80216f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802172:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802176:	77 07                	ja     80217f <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802178:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80217f:	a1 24 50 80 00       	mov    0x805024,%eax
  802184:	85 c0                	test   %eax,%eax
  802186:	75 73                	jne    8021fb <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	83 c0 10             	add    $0x10,%eax
  80218e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802191:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802198:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80219b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219e:	01 d0                	add    %edx,%eax
  8021a0:	48                   	dec    %eax
  8021a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ac:	f7 75 ec             	divl   -0x14(%ebp)
  8021af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021b2:	29 d0                	sub    %edx,%eax
  8021b4:	c1 e8 0c             	shr    $0xc,%eax
  8021b7:	83 ec 0c             	sub    $0xc,%esp
  8021ba:	50                   	push   %eax
  8021bb:	e8 d4 f0 ff ff       	call   801294 <sbrk>
  8021c0:	83 c4 10             	add    $0x10,%esp
  8021c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021c6:	83 ec 0c             	sub    $0xc,%esp
  8021c9:	6a 00                	push   $0x0
  8021cb:	e8 c4 f0 ff ff       	call   801294 <sbrk>
  8021d0:	83 c4 10             	add    $0x10,%esp
  8021d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8021d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021d9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8021dc:	83 ec 08             	sub    $0x8,%esp
  8021df:	50                   	push   %eax
  8021e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021e3:	e8 5b fd ff ff       	call   801f43 <initialize_dynamic_allocator>
  8021e8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8021eb:	83 ec 0c             	sub    $0xc,%esp
  8021ee:	68 0f 43 80 00       	push   $0x80430f
  8021f3:	e8 02 e3 ff ff       	call   8004fa <cprintf>
  8021f8:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8021fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ff:	75 0a                	jne    80220b <alloc_block_FF+0xac>
	        return NULL;
  802201:	b8 00 00 00 00       	mov    $0x0,%eax
  802206:	e9 0e 04 00 00       	jmp    802619 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80220b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802212:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221a:	e9 f3 02 00 00       	jmp    802512 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802225:	83 ec 0c             	sub    $0xc,%esp
  802228:	ff 75 bc             	pushl  -0x44(%ebp)
  80222b:	e8 af fb ff ff       	call   801ddf <get_block_size>
  802230:	83 c4 10             	add    $0x10,%esp
  802233:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	83 c0 08             	add    $0x8,%eax
  80223c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80223f:	0f 87 c5 02 00 00    	ja     80250a <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	83 c0 18             	add    $0x18,%eax
  80224b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80224e:	0f 87 19 02 00 00    	ja     80246d <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802254:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802257:	2b 45 08             	sub    0x8(%ebp),%eax
  80225a:	83 e8 08             	sub    $0x8,%eax
  80225d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	8d 50 08             	lea    0x8(%eax),%edx
  802266:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802269:	01 d0                	add    %edx,%eax
  80226b:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	83 c0 08             	add    $0x8,%eax
  802274:	83 ec 04             	sub    $0x4,%esp
  802277:	6a 01                	push   $0x1
  802279:	50                   	push   %eax
  80227a:	ff 75 bc             	pushl  -0x44(%ebp)
  80227d:	e8 ae fe ff ff       	call   802130 <set_block_data>
  802282:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	8b 40 04             	mov    0x4(%eax),%eax
  80228b:	85 c0                	test   %eax,%eax
  80228d:	75 68                	jne    8022f7 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80228f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802293:	75 17                	jne    8022ac <alloc_block_FF+0x14d>
  802295:	83 ec 04             	sub    $0x4,%esp
  802298:	68 ec 42 80 00       	push   $0x8042ec
  80229d:	68 d7 00 00 00       	push   $0xd7
  8022a2:	68 d1 42 80 00       	push   $0x8042d1
  8022a7:	e8 91 df ff ff       	call   80023d <_panic>
  8022ac:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022b5:	89 10                	mov    %edx,(%eax)
  8022b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022ba:	8b 00                	mov    (%eax),%eax
  8022bc:	85 c0                	test   %eax,%eax
  8022be:	74 0d                	je     8022cd <alloc_block_FF+0x16e>
  8022c0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022c5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022c8:	89 50 04             	mov    %edx,0x4(%eax)
  8022cb:	eb 08                	jmp    8022d5 <alloc_block_FF+0x176>
  8022cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8022d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e7:	a1 38 50 80 00       	mov    0x805038,%eax
  8022ec:	40                   	inc    %eax
  8022ed:	a3 38 50 80 00       	mov    %eax,0x805038
  8022f2:	e9 dc 00 00 00       	jmp    8023d3 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8b 00                	mov    (%eax),%eax
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	75 65                	jne    802365 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802300:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802304:	75 17                	jne    80231d <alloc_block_FF+0x1be>
  802306:	83 ec 04             	sub    $0x4,%esp
  802309:	68 20 43 80 00       	push   $0x804320
  80230e:	68 db 00 00 00       	push   $0xdb
  802313:	68 d1 42 80 00       	push   $0x8042d1
  802318:	e8 20 df ff ff       	call   80023d <_panic>
  80231d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802323:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802326:	89 50 04             	mov    %edx,0x4(%eax)
  802329:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80232c:	8b 40 04             	mov    0x4(%eax),%eax
  80232f:	85 c0                	test   %eax,%eax
  802331:	74 0c                	je     80233f <alloc_block_FF+0x1e0>
  802333:	a1 30 50 80 00       	mov    0x805030,%eax
  802338:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80233b:	89 10                	mov    %edx,(%eax)
  80233d:	eb 08                	jmp    802347 <alloc_block_FF+0x1e8>
  80233f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802342:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802347:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234a:	a3 30 50 80 00       	mov    %eax,0x805030
  80234f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802352:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802358:	a1 38 50 80 00       	mov    0x805038,%eax
  80235d:	40                   	inc    %eax
  80235e:	a3 38 50 80 00       	mov    %eax,0x805038
  802363:	eb 6e                	jmp    8023d3 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802369:	74 06                	je     802371 <alloc_block_FF+0x212>
  80236b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80236f:	75 17                	jne    802388 <alloc_block_FF+0x229>
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	68 44 43 80 00       	push   $0x804344
  802379:	68 df 00 00 00       	push   $0xdf
  80237e:	68 d1 42 80 00       	push   $0x8042d1
  802383:	e8 b5 de ff ff       	call   80023d <_panic>
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 10                	mov    (%eax),%edx
  80238d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802390:	89 10                	mov    %edx,(%eax)
  802392:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802395:	8b 00                	mov    (%eax),%eax
  802397:	85 c0                	test   %eax,%eax
  802399:	74 0b                	je     8023a6 <alloc_block_FF+0x247>
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	8b 00                	mov    (%eax),%eax
  8023a0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023a3:	89 50 04             	mov    %edx,0x4(%eax)
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023ac:	89 10                	mov    %edx,(%eax)
  8023ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b4:	89 50 04             	mov    %edx,0x4(%eax)
  8023b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ba:	8b 00                	mov    (%eax),%eax
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	75 08                	jne    8023c8 <alloc_block_FF+0x269>
  8023c0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c3:	a3 30 50 80 00       	mov    %eax,0x805030
  8023c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8023cd:	40                   	inc    %eax
  8023ce:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d7:	75 17                	jne    8023f0 <alloc_block_FF+0x291>
  8023d9:	83 ec 04             	sub    $0x4,%esp
  8023dc:	68 b3 42 80 00       	push   $0x8042b3
  8023e1:	68 e1 00 00 00       	push   $0xe1
  8023e6:	68 d1 42 80 00       	push   $0x8042d1
  8023eb:	e8 4d de ff ff       	call   80023d <_panic>
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 00                	mov    (%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 10                	je     802409 <alloc_block_FF+0x2aa>
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 00                	mov    (%eax),%eax
  8023fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802401:	8b 52 04             	mov    0x4(%edx),%edx
  802404:	89 50 04             	mov    %edx,0x4(%eax)
  802407:	eb 0b                	jmp    802414 <alloc_block_FF+0x2b5>
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	8b 40 04             	mov    0x4(%eax),%eax
  80240f:	a3 30 50 80 00       	mov    %eax,0x805030
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 40 04             	mov    0x4(%eax),%eax
  80241a:	85 c0                	test   %eax,%eax
  80241c:	74 0f                	je     80242d <alloc_block_FF+0x2ce>
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 40 04             	mov    0x4(%eax),%eax
  802424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802427:	8b 12                	mov    (%edx),%edx
  802429:	89 10                	mov    %edx,(%eax)
  80242b:	eb 0a                	jmp    802437 <alloc_block_FF+0x2d8>
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 00                	mov    (%eax),%eax
  802432:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244a:	a1 38 50 80 00       	mov    0x805038,%eax
  80244f:	48                   	dec    %eax
  802450:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802455:	83 ec 04             	sub    $0x4,%esp
  802458:	6a 00                	push   $0x0
  80245a:	ff 75 b4             	pushl  -0x4c(%ebp)
  80245d:	ff 75 b0             	pushl  -0x50(%ebp)
  802460:	e8 cb fc ff ff       	call   802130 <set_block_data>
  802465:	83 c4 10             	add    $0x10,%esp
  802468:	e9 95 00 00 00       	jmp    802502 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80246d:	83 ec 04             	sub    $0x4,%esp
  802470:	6a 01                	push   $0x1
  802472:	ff 75 b8             	pushl  -0x48(%ebp)
  802475:	ff 75 bc             	pushl  -0x44(%ebp)
  802478:	e8 b3 fc ff ff       	call   802130 <set_block_data>
  80247d:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802480:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802484:	75 17                	jne    80249d <alloc_block_FF+0x33e>
  802486:	83 ec 04             	sub    $0x4,%esp
  802489:	68 b3 42 80 00       	push   $0x8042b3
  80248e:	68 e8 00 00 00       	push   $0xe8
  802493:	68 d1 42 80 00       	push   $0x8042d1
  802498:	e8 a0 dd ff ff       	call   80023d <_panic>
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 00                	mov    (%eax),%eax
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	74 10                	je     8024b6 <alloc_block_FF+0x357>
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	8b 00                	mov    (%eax),%eax
  8024ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ae:	8b 52 04             	mov    0x4(%edx),%edx
  8024b1:	89 50 04             	mov    %edx,0x4(%eax)
  8024b4:	eb 0b                	jmp    8024c1 <alloc_block_FF+0x362>
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 40 04             	mov    0x4(%eax),%eax
  8024bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 40 04             	mov    0x4(%eax),%eax
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	74 0f                	je     8024da <alloc_block_FF+0x37b>
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 04             	mov    0x4(%eax),%eax
  8024d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d4:	8b 12                	mov    (%edx),%edx
  8024d6:	89 10                	mov    %edx,(%eax)
  8024d8:	eb 0a                	jmp    8024e4 <alloc_block_FF+0x385>
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 00                	mov    (%eax),%eax
  8024df:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8024fc:	48                   	dec    %eax
  8024fd:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802502:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802505:	e9 0f 01 00 00       	jmp    802619 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80250a:	a1 34 50 80 00       	mov    0x805034,%eax
  80250f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802516:	74 07                	je     80251f <alloc_block_FF+0x3c0>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	eb 05                	jmp    802524 <alloc_block_FF+0x3c5>
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
  802524:	a3 34 50 80 00       	mov    %eax,0x805034
  802529:	a1 34 50 80 00       	mov    0x805034,%eax
  80252e:	85 c0                	test   %eax,%eax
  802530:	0f 85 e9 fc ff ff    	jne    80221f <alloc_block_FF+0xc0>
  802536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253a:	0f 85 df fc ff ff    	jne    80221f <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	83 c0 08             	add    $0x8,%eax
  802546:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802549:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802550:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802553:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802556:	01 d0                	add    %edx,%eax
  802558:	48                   	dec    %eax
  802559:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80255c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80255f:	ba 00 00 00 00       	mov    $0x0,%edx
  802564:	f7 75 d8             	divl   -0x28(%ebp)
  802567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80256a:	29 d0                	sub    %edx,%eax
  80256c:	c1 e8 0c             	shr    $0xc,%eax
  80256f:	83 ec 0c             	sub    $0xc,%esp
  802572:	50                   	push   %eax
  802573:	e8 1c ed ff ff       	call   801294 <sbrk>
  802578:	83 c4 10             	add    $0x10,%esp
  80257b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80257e:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802582:	75 0a                	jne    80258e <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
  802589:	e9 8b 00 00 00       	jmp    802619 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80258e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802595:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802598:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80259b:	01 d0                	add    %edx,%eax
  80259d:	48                   	dec    %eax
  80259e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025a1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a9:	f7 75 cc             	divl   -0x34(%ebp)
  8025ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025af:	29 d0                	sub    %edx,%eax
  8025b1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025b7:	01 d0                	add    %edx,%eax
  8025b9:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8025be:	a1 40 50 80 00       	mov    0x805040,%eax
  8025c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025c9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025d6:	01 d0                	add    %edx,%eax
  8025d8:	48                   	dec    %eax
  8025d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8025dc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025df:	ba 00 00 00 00       	mov    $0x0,%edx
  8025e4:	f7 75 c4             	divl   -0x3c(%ebp)
  8025e7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025ea:	29 d0                	sub    %edx,%eax
  8025ec:	83 ec 04             	sub    $0x4,%esp
  8025ef:	6a 01                	push   $0x1
  8025f1:	50                   	push   %eax
  8025f2:	ff 75 d0             	pushl  -0x30(%ebp)
  8025f5:	e8 36 fb ff ff       	call   802130 <set_block_data>
  8025fa:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8025fd:	83 ec 0c             	sub    $0xc,%esp
  802600:	ff 75 d0             	pushl  -0x30(%ebp)
  802603:	e8 1b 0a 00 00       	call   803023 <free_block>
  802608:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80260b:	83 ec 0c             	sub    $0xc,%esp
  80260e:	ff 75 08             	pushl  0x8(%ebp)
  802611:	e8 49 fb ff ff       	call   80215f <alloc_block_FF>
  802616:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
  80261e:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802621:	8b 45 08             	mov    0x8(%ebp),%eax
  802624:	83 e0 01             	and    $0x1,%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	74 03                	je     80262e <alloc_block_BF+0x13>
  80262b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80262e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802632:	77 07                	ja     80263b <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802634:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80263b:	a1 24 50 80 00       	mov    0x805024,%eax
  802640:	85 c0                	test   %eax,%eax
  802642:	75 73                	jne    8026b7 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	83 c0 10             	add    $0x10,%eax
  80264a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80264d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802654:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802657:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265a:	01 d0                	add    %edx,%eax
  80265c:	48                   	dec    %eax
  80265d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802660:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802663:	ba 00 00 00 00       	mov    $0x0,%edx
  802668:	f7 75 e0             	divl   -0x20(%ebp)
  80266b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80266e:	29 d0                	sub    %edx,%eax
  802670:	c1 e8 0c             	shr    $0xc,%eax
  802673:	83 ec 0c             	sub    $0xc,%esp
  802676:	50                   	push   %eax
  802677:	e8 18 ec ff ff       	call   801294 <sbrk>
  80267c:	83 c4 10             	add    $0x10,%esp
  80267f:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802682:	83 ec 0c             	sub    $0xc,%esp
  802685:	6a 00                	push   $0x0
  802687:	e8 08 ec ff ff       	call   801294 <sbrk>
  80268c:	83 c4 10             	add    $0x10,%esp
  80268f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802692:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802695:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802698:	83 ec 08             	sub    $0x8,%esp
  80269b:	50                   	push   %eax
  80269c:	ff 75 d8             	pushl  -0x28(%ebp)
  80269f:	e8 9f f8 ff ff       	call   801f43 <initialize_dynamic_allocator>
  8026a4:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026a7:	83 ec 0c             	sub    $0xc,%esp
  8026aa:	68 0f 43 80 00       	push   $0x80430f
  8026af:	e8 46 de ff ff       	call   8004fa <cprintf>
  8026b4:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026c5:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8026cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026db:	e9 1d 01 00 00       	jmp    8027fd <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	ff 75 a8             	pushl  -0x58(%ebp)
  8026ec:	e8 ee f6 ff ff       	call   801ddf <get_block_size>
  8026f1:	83 c4 10             	add    $0x10,%esp
  8026f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	83 c0 08             	add    $0x8,%eax
  8026fd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802700:	0f 87 ef 00 00 00    	ja     8027f5 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	83 c0 18             	add    $0x18,%eax
  80270c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80270f:	77 1d                	ja     80272e <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802714:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802717:	0f 86 d8 00 00 00    	jbe    8027f5 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80271d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802720:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802723:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802726:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802729:	e9 c7 00 00 00       	jmp    8027f5 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80272e:	8b 45 08             	mov    0x8(%ebp),%eax
  802731:	83 c0 08             	add    $0x8,%eax
  802734:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802737:	0f 85 9d 00 00 00    	jne    8027da <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80273d:	83 ec 04             	sub    $0x4,%esp
  802740:	6a 01                	push   $0x1
  802742:	ff 75 a4             	pushl  -0x5c(%ebp)
  802745:	ff 75 a8             	pushl  -0x58(%ebp)
  802748:	e8 e3 f9 ff ff       	call   802130 <set_block_data>
  80274d:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802750:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802754:	75 17                	jne    80276d <alloc_block_BF+0x152>
  802756:	83 ec 04             	sub    $0x4,%esp
  802759:	68 b3 42 80 00       	push   $0x8042b3
  80275e:	68 2c 01 00 00       	push   $0x12c
  802763:	68 d1 42 80 00       	push   $0x8042d1
  802768:	e8 d0 da ff ff       	call   80023d <_panic>
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 00                	mov    (%eax),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	74 10                	je     802786 <alloc_block_BF+0x16b>
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277e:	8b 52 04             	mov    0x4(%edx),%edx
  802781:	89 50 04             	mov    %edx,0x4(%eax)
  802784:	eb 0b                	jmp    802791 <alloc_block_BF+0x176>
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 40 04             	mov    0x4(%eax),%eax
  80278c:	a3 30 50 80 00       	mov    %eax,0x805030
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 40 04             	mov    0x4(%eax),%eax
  802797:	85 c0                	test   %eax,%eax
  802799:	74 0f                	je     8027aa <alloc_block_BF+0x18f>
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 40 04             	mov    0x4(%eax),%eax
  8027a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a4:	8b 12                	mov    (%edx),%edx
  8027a6:	89 10                	mov    %edx,(%eax)
  8027a8:	eb 0a                	jmp    8027b4 <alloc_block_BF+0x199>
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 00                	mov    (%eax),%eax
  8027af:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c7:	a1 38 50 80 00       	mov    0x805038,%eax
  8027cc:	48                   	dec    %eax
  8027cd:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8027d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027d5:	e9 24 04 00 00       	jmp    802bfe <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8027da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027e0:	76 13                	jbe    8027f5 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8027e2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8027e9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8027ef:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027f2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8027f5:	a1 34 50 80 00       	mov    0x805034,%eax
  8027fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802801:	74 07                	je     80280a <alloc_block_BF+0x1ef>
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	eb 05                	jmp    80280f <alloc_block_BF+0x1f4>
  80280a:	b8 00 00 00 00       	mov    $0x0,%eax
  80280f:	a3 34 50 80 00       	mov    %eax,0x805034
  802814:	a1 34 50 80 00       	mov    0x805034,%eax
  802819:	85 c0                	test   %eax,%eax
  80281b:	0f 85 bf fe ff ff    	jne    8026e0 <alloc_block_BF+0xc5>
  802821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802825:	0f 85 b5 fe ff ff    	jne    8026e0 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80282b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80282f:	0f 84 26 02 00 00    	je     802a5b <alloc_block_BF+0x440>
  802835:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802839:	0f 85 1c 02 00 00    	jne    802a5b <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80283f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802842:	2b 45 08             	sub    0x8(%ebp),%eax
  802845:	83 e8 08             	sub    $0x8,%eax
  802848:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	8d 50 08             	lea    0x8(%eax),%edx
  802851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802854:	01 d0                	add    %edx,%eax
  802856:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802859:	8b 45 08             	mov    0x8(%ebp),%eax
  80285c:	83 c0 08             	add    $0x8,%eax
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	6a 01                	push   $0x1
  802864:	50                   	push   %eax
  802865:	ff 75 f0             	pushl  -0x10(%ebp)
  802868:	e8 c3 f8 ff ff       	call   802130 <set_block_data>
  80286d:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802873:	8b 40 04             	mov    0x4(%eax),%eax
  802876:	85 c0                	test   %eax,%eax
  802878:	75 68                	jne    8028e2 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80287a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80287e:	75 17                	jne    802897 <alloc_block_BF+0x27c>
  802880:	83 ec 04             	sub    $0x4,%esp
  802883:	68 ec 42 80 00       	push   $0x8042ec
  802888:	68 45 01 00 00       	push   $0x145
  80288d:	68 d1 42 80 00       	push   $0x8042d1
  802892:	e8 a6 d9 ff ff       	call   80023d <_panic>
  802897:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80289d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a0:	89 10                	mov    %edx,(%eax)
  8028a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a5:	8b 00                	mov    (%eax),%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	74 0d                	je     8028b8 <alloc_block_BF+0x29d>
  8028ab:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028b0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028b3:	89 50 04             	mov    %edx,0x4(%eax)
  8028b6:	eb 08                	jmp    8028c0 <alloc_block_BF+0x2a5>
  8028b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8028c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d2:	a1 38 50 80 00       	mov    0x805038,%eax
  8028d7:	40                   	inc    %eax
  8028d8:	a3 38 50 80 00       	mov    %eax,0x805038
  8028dd:	e9 dc 00 00 00       	jmp    8029be <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8028e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	75 65                	jne    802950 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028eb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028ef:	75 17                	jne    802908 <alloc_block_BF+0x2ed>
  8028f1:	83 ec 04             	sub    $0x4,%esp
  8028f4:	68 20 43 80 00       	push   $0x804320
  8028f9:	68 4a 01 00 00       	push   $0x14a
  8028fe:	68 d1 42 80 00       	push   $0x8042d1
  802903:	e8 35 d9 ff ff       	call   80023d <_panic>
  802908:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80290e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802911:	89 50 04             	mov    %edx,0x4(%eax)
  802914:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802917:	8b 40 04             	mov    0x4(%eax),%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	74 0c                	je     80292a <alloc_block_BF+0x30f>
  80291e:	a1 30 50 80 00       	mov    0x805030,%eax
  802923:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802926:	89 10                	mov    %edx,(%eax)
  802928:	eb 08                	jmp    802932 <alloc_block_BF+0x317>
  80292a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80292d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802932:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802935:	a3 30 50 80 00       	mov    %eax,0x805030
  80293a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80293d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802943:	a1 38 50 80 00       	mov    0x805038,%eax
  802948:	40                   	inc    %eax
  802949:	a3 38 50 80 00       	mov    %eax,0x805038
  80294e:	eb 6e                	jmp    8029be <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802950:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802954:	74 06                	je     80295c <alloc_block_BF+0x341>
  802956:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80295a:	75 17                	jne    802973 <alloc_block_BF+0x358>
  80295c:	83 ec 04             	sub    $0x4,%esp
  80295f:	68 44 43 80 00       	push   $0x804344
  802964:	68 4f 01 00 00       	push   $0x14f
  802969:	68 d1 42 80 00       	push   $0x8042d1
  80296e:	e8 ca d8 ff ff       	call   80023d <_panic>
  802973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802976:	8b 10                	mov    (%eax),%edx
  802978:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297b:	89 10                	mov    %edx,(%eax)
  80297d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802980:	8b 00                	mov    (%eax),%eax
  802982:	85 c0                	test   %eax,%eax
  802984:	74 0b                	je     802991 <alloc_block_BF+0x376>
  802986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802989:	8b 00                	mov    (%eax),%eax
  80298b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80298e:	89 50 04             	mov    %edx,0x4(%eax)
  802991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802994:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802997:	89 10                	mov    %edx,(%eax)
  802999:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80299c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80299f:	89 50 04             	mov    %edx,0x4(%eax)
  8029a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a5:	8b 00                	mov    (%eax),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	75 08                	jne    8029b3 <alloc_block_BF+0x398>
  8029ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8029b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8029b8:	40                   	inc    %eax
  8029b9:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029c2:	75 17                	jne    8029db <alloc_block_BF+0x3c0>
  8029c4:	83 ec 04             	sub    $0x4,%esp
  8029c7:	68 b3 42 80 00       	push   $0x8042b3
  8029cc:	68 51 01 00 00       	push   $0x151
  8029d1:	68 d1 42 80 00       	push   $0x8042d1
  8029d6:	e8 62 d8 ff ff       	call   80023d <_panic>
  8029db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	74 10                	je     8029f4 <alloc_block_BF+0x3d9>
  8029e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ec:	8b 52 04             	mov    0x4(%edx),%edx
  8029ef:	89 50 04             	mov    %edx,0x4(%eax)
  8029f2:	eb 0b                	jmp    8029ff <alloc_block_BF+0x3e4>
  8029f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f7:	8b 40 04             	mov    0x4(%eax),%eax
  8029fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8029ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a02:	8b 40 04             	mov    0x4(%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 0f                	je     802a18 <alloc_block_BF+0x3fd>
  802a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0c:	8b 40 04             	mov    0x4(%eax),%eax
  802a0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a12:	8b 12                	mov    (%edx),%edx
  802a14:	89 10                	mov    %edx,(%eax)
  802a16:	eb 0a                	jmp    802a22 <alloc_block_BF+0x407>
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a35:	a1 38 50 80 00       	mov    0x805038,%eax
  802a3a:	48                   	dec    %eax
  802a3b:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a40:	83 ec 04             	sub    $0x4,%esp
  802a43:	6a 00                	push   $0x0
  802a45:	ff 75 d0             	pushl  -0x30(%ebp)
  802a48:	ff 75 cc             	pushl  -0x34(%ebp)
  802a4b:	e8 e0 f6 ff ff       	call   802130 <set_block_data>
  802a50:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a56:	e9 a3 01 00 00       	jmp    802bfe <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a5b:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a5f:	0f 85 9d 00 00 00    	jne    802b02 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a65:	83 ec 04             	sub    $0x4,%esp
  802a68:	6a 01                	push   $0x1
  802a6a:	ff 75 ec             	pushl  -0x14(%ebp)
  802a6d:	ff 75 f0             	pushl  -0x10(%ebp)
  802a70:	e8 bb f6 ff ff       	call   802130 <set_block_data>
  802a75:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a7c:	75 17                	jne    802a95 <alloc_block_BF+0x47a>
  802a7e:	83 ec 04             	sub    $0x4,%esp
  802a81:	68 b3 42 80 00       	push   $0x8042b3
  802a86:	68 58 01 00 00       	push   $0x158
  802a8b:	68 d1 42 80 00       	push   $0x8042d1
  802a90:	e8 a8 d7 ff ff       	call   80023d <_panic>
  802a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a98:	8b 00                	mov    (%eax),%eax
  802a9a:	85 c0                	test   %eax,%eax
  802a9c:	74 10                	je     802aae <alloc_block_BF+0x493>
  802a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa6:	8b 52 04             	mov    0x4(%edx),%edx
  802aa9:	89 50 04             	mov    %edx,0x4(%eax)
  802aac:	eb 0b                	jmp    802ab9 <alloc_block_BF+0x49e>
  802aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab1:	8b 40 04             	mov    0x4(%eax),%eax
  802ab4:	a3 30 50 80 00       	mov    %eax,0x805030
  802ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abc:	8b 40 04             	mov    0x4(%eax),%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	74 0f                	je     802ad2 <alloc_block_BF+0x4b7>
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	8b 40 04             	mov    0x4(%eax),%eax
  802ac9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802acc:	8b 12                	mov    (%edx),%edx
  802ace:	89 10                	mov    %edx,(%eax)
  802ad0:	eb 0a                	jmp    802adc <alloc_block_BF+0x4c1>
  802ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad5:	8b 00                	mov    (%eax),%eax
  802ad7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aef:	a1 38 50 80 00       	mov    0x805038,%eax
  802af4:	48                   	dec    %eax
  802af5:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afd:	e9 fc 00 00 00       	jmp    802bfe <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	83 c0 08             	add    $0x8,%eax
  802b08:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b0b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b12:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b15:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b18:	01 d0                	add    %edx,%eax
  802b1a:	48                   	dec    %eax
  802b1b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b1e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b21:	ba 00 00 00 00       	mov    $0x0,%edx
  802b26:	f7 75 c4             	divl   -0x3c(%ebp)
  802b29:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b2c:	29 d0                	sub    %edx,%eax
  802b2e:	c1 e8 0c             	shr    $0xc,%eax
  802b31:	83 ec 0c             	sub    $0xc,%esp
  802b34:	50                   	push   %eax
  802b35:	e8 5a e7 ff ff       	call   801294 <sbrk>
  802b3a:	83 c4 10             	add    $0x10,%esp
  802b3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b40:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b44:	75 0a                	jne    802b50 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b46:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4b:	e9 ae 00 00 00       	jmp    802bfe <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b50:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b57:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b5a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b5d:	01 d0                	add    %edx,%eax
  802b5f:	48                   	dec    %eax
  802b60:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b63:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b66:	ba 00 00 00 00       	mov    $0x0,%edx
  802b6b:	f7 75 b8             	divl   -0x48(%ebp)
  802b6e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b71:	29 d0                	sub    %edx,%eax
  802b73:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b76:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b79:	01 d0                	add    %edx,%eax
  802b7b:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b80:	a1 40 50 80 00       	mov    0x805040,%eax
  802b85:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b8b:	83 ec 0c             	sub    $0xc,%esp
  802b8e:	68 78 43 80 00       	push   $0x804378
  802b93:	e8 62 d9 ff ff       	call   8004fa <cprintf>
  802b98:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b9b:	83 ec 08             	sub    $0x8,%esp
  802b9e:	ff 75 bc             	pushl  -0x44(%ebp)
  802ba1:	68 7d 43 80 00       	push   $0x80437d
  802ba6:	e8 4f d9 ff ff       	call   8004fa <cprintf>
  802bab:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bae:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802bb5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bb8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bbb:	01 d0                	add    %edx,%eax
  802bbd:	48                   	dec    %eax
  802bbe:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802bc1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc9:	f7 75 b0             	divl   -0x50(%ebp)
  802bcc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bcf:	29 d0                	sub    %edx,%eax
  802bd1:	83 ec 04             	sub    $0x4,%esp
  802bd4:	6a 01                	push   $0x1
  802bd6:	50                   	push   %eax
  802bd7:	ff 75 bc             	pushl  -0x44(%ebp)
  802bda:	e8 51 f5 ff ff       	call   802130 <set_block_data>
  802bdf:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802be2:	83 ec 0c             	sub    $0xc,%esp
  802be5:	ff 75 bc             	pushl  -0x44(%ebp)
  802be8:	e8 36 04 00 00       	call   803023 <free_block>
  802bed:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802bf0:	83 ec 0c             	sub    $0xc,%esp
  802bf3:	ff 75 08             	pushl  0x8(%ebp)
  802bf6:	e8 20 fa ff ff       	call   80261b <alloc_block_BF>
  802bfb:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802bfe:	c9                   	leave  
  802bff:	c3                   	ret    

00802c00 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c00:	55                   	push   %ebp
  802c01:	89 e5                	mov    %esp,%ebp
  802c03:	53                   	push   %ebx
  802c04:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c19:	74 1e                	je     802c39 <merging+0x39>
  802c1b:	ff 75 08             	pushl  0x8(%ebp)
  802c1e:	e8 bc f1 ff ff       	call   801ddf <get_block_size>
  802c23:	83 c4 04             	add    $0x4,%esp
  802c26:	89 c2                	mov    %eax,%edx
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	01 d0                	add    %edx,%eax
  802c2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c30:	75 07                	jne    802c39 <merging+0x39>
		prev_is_free = 1;
  802c32:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c3d:	74 1e                	je     802c5d <merging+0x5d>
  802c3f:	ff 75 10             	pushl  0x10(%ebp)
  802c42:	e8 98 f1 ff ff       	call   801ddf <get_block_size>
  802c47:	83 c4 04             	add    $0x4,%esp
  802c4a:	89 c2                	mov    %eax,%edx
  802c4c:	8b 45 10             	mov    0x10(%ebp),%eax
  802c4f:	01 d0                	add    %edx,%eax
  802c51:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c54:	75 07                	jne    802c5d <merging+0x5d>
		next_is_free = 1;
  802c56:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c61:	0f 84 cc 00 00 00    	je     802d33 <merging+0x133>
  802c67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c6b:	0f 84 c2 00 00 00    	je     802d33 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c71:	ff 75 08             	pushl  0x8(%ebp)
  802c74:	e8 66 f1 ff ff       	call   801ddf <get_block_size>
  802c79:	83 c4 04             	add    $0x4,%esp
  802c7c:	89 c3                	mov    %eax,%ebx
  802c7e:	ff 75 10             	pushl  0x10(%ebp)
  802c81:	e8 59 f1 ff ff       	call   801ddf <get_block_size>
  802c86:	83 c4 04             	add    $0x4,%esp
  802c89:	01 c3                	add    %eax,%ebx
  802c8b:	ff 75 0c             	pushl  0xc(%ebp)
  802c8e:	e8 4c f1 ff ff       	call   801ddf <get_block_size>
  802c93:	83 c4 04             	add    $0x4,%esp
  802c96:	01 d8                	add    %ebx,%eax
  802c98:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c9b:	6a 00                	push   $0x0
  802c9d:	ff 75 ec             	pushl  -0x14(%ebp)
  802ca0:	ff 75 08             	pushl  0x8(%ebp)
  802ca3:	e8 88 f4 ff ff       	call   802130 <set_block_data>
  802ca8:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802cab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802caf:	75 17                	jne    802cc8 <merging+0xc8>
  802cb1:	83 ec 04             	sub    $0x4,%esp
  802cb4:	68 b3 42 80 00       	push   $0x8042b3
  802cb9:	68 7d 01 00 00       	push   $0x17d
  802cbe:	68 d1 42 80 00       	push   $0x8042d1
  802cc3:	e8 75 d5 ff ff       	call   80023d <_panic>
  802cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	85 c0                	test   %eax,%eax
  802ccf:	74 10                	je     802ce1 <merging+0xe1>
  802cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd9:	8b 52 04             	mov    0x4(%edx),%edx
  802cdc:	89 50 04             	mov    %edx,0x4(%eax)
  802cdf:	eb 0b                	jmp    802cec <merging+0xec>
  802ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce4:	8b 40 04             	mov    0x4(%eax),%eax
  802ce7:	a3 30 50 80 00       	mov    %eax,0x805030
  802cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cef:	8b 40 04             	mov    0x4(%eax),%eax
  802cf2:	85 c0                	test   %eax,%eax
  802cf4:	74 0f                	je     802d05 <merging+0x105>
  802cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf9:	8b 40 04             	mov    0x4(%eax),%eax
  802cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cff:	8b 12                	mov    (%edx),%edx
  802d01:	89 10                	mov    %edx,(%eax)
  802d03:	eb 0a                	jmp    802d0f <merging+0x10f>
  802d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d22:	a1 38 50 80 00       	mov    0x805038,%eax
  802d27:	48                   	dec    %eax
  802d28:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d2d:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d2e:	e9 ea 02 00 00       	jmp    80301d <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d37:	74 3b                	je     802d74 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d39:	83 ec 0c             	sub    $0xc,%esp
  802d3c:	ff 75 08             	pushl  0x8(%ebp)
  802d3f:	e8 9b f0 ff ff       	call   801ddf <get_block_size>
  802d44:	83 c4 10             	add    $0x10,%esp
  802d47:	89 c3                	mov    %eax,%ebx
  802d49:	83 ec 0c             	sub    $0xc,%esp
  802d4c:	ff 75 10             	pushl  0x10(%ebp)
  802d4f:	e8 8b f0 ff ff       	call   801ddf <get_block_size>
  802d54:	83 c4 10             	add    $0x10,%esp
  802d57:	01 d8                	add    %ebx,%eax
  802d59:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d5c:	83 ec 04             	sub    $0x4,%esp
  802d5f:	6a 00                	push   $0x0
  802d61:	ff 75 e8             	pushl  -0x18(%ebp)
  802d64:	ff 75 08             	pushl  0x8(%ebp)
  802d67:	e8 c4 f3 ff ff       	call   802130 <set_block_data>
  802d6c:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d6f:	e9 a9 02 00 00       	jmp    80301d <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d78:	0f 84 2d 01 00 00    	je     802eab <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d7e:	83 ec 0c             	sub    $0xc,%esp
  802d81:	ff 75 10             	pushl  0x10(%ebp)
  802d84:	e8 56 f0 ff ff       	call   801ddf <get_block_size>
  802d89:	83 c4 10             	add    $0x10,%esp
  802d8c:	89 c3                	mov    %eax,%ebx
  802d8e:	83 ec 0c             	sub    $0xc,%esp
  802d91:	ff 75 0c             	pushl  0xc(%ebp)
  802d94:	e8 46 f0 ff ff       	call   801ddf <get_block_size>
  802d99:	83 c4 10             	add    $0x10,%esp
  802d9c:	01 d8                	add    %ebx,%eax
  802d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802da1:	83 ec 04             	sub    $0x4,%esp
  802da4:	6a 00                	push   $0x0
  802da6:	ff 75 e4             	pushl  -0x1c(%ebp)
  802da9:	ff 75 10             	pushl  0x10(%ebp)
  802dac:	e8 7f f3 ff ff       	call   802130 <set_block_data>
  802db1:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802db4:	8b 45 10             	mov    0x10(%ebp),%eax
  802db7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802dba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dbe:	74 06                	je     802dc6 <merging+0x1c6>
  802dc0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dc4:	75 17                	jne    802ddd <merging+0x1dd>
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	68 8c 43 80 00       	push   $0x80438c
  802dce:	68 8d 01 00 00       	push   $0x18d
  802dd3:	68 d1 42 80 00       	push   $0x8042d1
  802dd8:	e8 60 d4 ff ff       	call   80023d <_panic>
  802ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de0:	8b 50 04             	mov    0x4(%eax),%edx
  802de3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de6:	89 50 04             	mov    %edx,0x4(%eax)
  802de9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dec:	8b 55 0c             	mov    0xc(%ebp),%edx
  802def:	89 10                	mov    %edx,(%eax)
  802df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df4:	8b 40 04             	mov    0x4(%eax),%eax
  802df7:	85 c0                	test   %eax,%eax
  802df9:	74 0d                	je     802e08 <merging+0x208>
  802dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfe:	8b 40 04             	mov    0x4(%eax),%eax
  802e01:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e04:	89 10                	mov    %edx,(%eax)
  802e06:	eb 08                	jmp    802e10 <merging+0x210>
  802e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e16:	89 50 04             	mov    %edx,0x4(%eax)
  802e19:	a1 38 50 80 00       	mov    0x805038,%eax
  802e1e:	40                   	inc    %eax
  802e1f:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e28:	75 17                	jne    802e41 <merging+0x241>
  802e2a:	83 ec 04             	sub    $0x4,%esp
  802e2d:	68 b3 42 80 00       	push   $0x8042b3
  802e32:	68 8e 01 00 00       	push   $0x18e
  802e37:	68 d1 42 80 00       	push   $0x8042d1
  802e3c:	e8 fc d3 ff ff       	call   80023d <_panic>
  802e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e44:	8b 00                	mov    (%eax),%eax
  802e46:	85 c0                	test   %eax,%eax
  802e48:	74 10                	je     802e5a <merging+0x25a>
  802e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4d:	8b 00                	mov    (%eax),%eax
  802e4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e52:	8b 52 04             	mov    0x4(%edx),%edx
  802e55:	89 50 04             	mov    %edx,0x4(%eax)
  802e58:	eb 0b                	jmp    802e65 <merging+0x265>
  802e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5d:	8b 40 04             	mov    0x4(%eax),%eax
  802e60:	a3 30 50 80 00       	mov    %eax,0x805030
  802e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e68:	8b 40 04             	mov    0x4(%eax),%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	74 0f                	je     802e7e <merging+0x27e>
  802e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e78:	8b 12                	mov    (%edx),%edx
  802e7a:	89 10                	mov    %edx,(%eax)
  802e7c:	eb 0a                	jmp    802e88 <merging+0x288>
  802e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9b:	a1 38 50 80 00       	mov    0x805038,%eax
  802ea0:	48                   	dec    %eax
  802ea1:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ea6:	e9 72 01 00 00       	jmp    80301d <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802eab:	8b 45 10             	mov    0x10(%ebp),%eax
  802eae:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802eb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb5:	74 79                	je     802f30 <merging+0x330>
  802eb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ebb:	74 73                	je     802f30 <merging+0x330>
  802ebd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec1:	74 06                	je     802ec9 <merging+0x2c9>
  802ec3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ec7:	75 17                	jne    802ee0 <merging+0x2e0>
  802ec9:	83 ec 04             	sub    $0x4,%esp
  802ecc:	68 44 43 80 00       	push   $0x804344
  802ed1:	68 94 01 00 00       	push   $0x194
  802ed6:	68 d1 42 80 00       	push   $0x8042d1
  802edb:	e8 5d d3 ff ff       	call   80023d <_panic>
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	8b 10                	mov    (%eax),%edx
  802ee5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee8:	89 10                	mov    %edx,(%eax)
  802eea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	85 c0                	test   %eax,%eax
  802ef1:	74 0b                	je     802efe <merging+0x2fe>
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	8b 00                	mov    (%eax),%eax
  802ef8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802efb:	89 50 04             	mov    %edx,0x4(%eax)
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f04:	89 10                	mov    %edx,(%eax)
  802f06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f09:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0c:	89 50 04             	mov    %edx,0x4(%eax)
  802f0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f12:	8b 00                	mov    (%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	75 08                	jne    802f20 <merging+0x320>
  802f18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1b:	a3 30 50 80 00       	mov    %eax,0x805030
  802f20:	a1 38 50 80 00       	mov    0x805038,%eax
  802f25:	40                   	inc    %eax
  802f26:	a3 38 50 80 00       	mov    %eax,0x805038
  802f2b:	e9 ce 00 00 00       	jmp    802ffe <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f34:	74 65                	je     802f9b <merging+0x39b>
  802f36:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f3a:	75 17                	jne    802f53 <merging+0x353>
  802f3c:	83 ec 04             	sub    $0x4,%esp
  802f3f:	68 20 43 80 00       	push   $0x804320
  802f44:	68 95 01 00 00       	push   $0x195
  802f49:	68 d1 42 80 00       	push   $0x8042d1
  802f4e:	e8 ea d2 ff ff       	call   80023d <_panic>
  802f53:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5c:	89 50 04             	mov    %edx,0x4(%eax)
  802f5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f62:	8b 40 04             	mov    0x4(%eax),%eax
  802f65:	85 c0                	test   %eax,%eax
  802f67:	74 0c                	je     802f75 <merging+0x375>
  802f69:	a1 30 50 80 00       	mov    0x805030,%eax
  802f6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f71:	89 10                	mov    %edx,(%eax)
  802f73:	eb 08                	jmp    802f7d <merging+0x37d>
  802f75:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f78:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f80:	a3 30 50 80 00       	mov    %eax,0x805030
  802f85:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8e:	a1 38 50 80 00       	mov    0x805038,%eax
  802f93:	40                   	inc    %eax
  802f94:	a3 38 50 80 00       	mov    %eax,0x805038
  802f99:	eb 63                	jmp    802ffe <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f9f:	75 17                	jne    802fb8 <merging+0x3b8>
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	68 ec 42 80 00       	push   $0x8042ec
  802fa9:	68 98 01 00 00       	push   $0x198
  802fae:	68 d1 42 80 00       	push   $0x8042d1
  802fb3:	e8 85 d2 ff ff       	call   80023d <_panic>
  802fb8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802fbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc1:	89 10                	mov    %edx,(%eax)
  802fc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 0d                	je     802fd9 <merging+0x3d9>
  802fcc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fd4:	89 50 04             	mov    %edx,0x4(%eax)
  802fd7:	eb 08                	jmp    802fe1 <merging+0x3e1>
  802fd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdc:	a3 30 50 80 00       	mov    %eax,0x805030
  802fe1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fe9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff3:	a1 38 50 80 00       	mov    0x805038,%eax
  802ff8:	40                   	inc    %eax
  802ff9:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802ffe:	83 ec 0c             	sub    $0xc,%esp
  803001:	ff 75 10             	pushl  0x10(%ebp)
  803004:	e8 d6 ed ff ff       	call   801ddf <get_block_size>
  803009:	83 c4 10             	add    $0x10,%esp
  80300c:	83 ec 04             	sub    $0x4,%esp
  80300f:	6a 00                	push   $0x0
  803011:	50                   	push   %eax
  803012:	ff 75 10             	pushl  0x10(%ebp)
  803015:	e8 16 f1 ff ff       	call   802130 <set_block_data>
  80301a:	83 c4 10             	add    $0x10,%esp
	}
}
  80301d:	90                   	nop
  80301e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803021:	c9                   	leave  
  803022:	c3                   	ret    

00803023 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803023:	55                   	push   %ebp
  803024:	89 e5                	mov    %esp,%ebp
  803026:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803029:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80302e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803031:	a1 30 50 80 00       	mov    0x805030,%eax
  803036:	3b 45 08             	cmp    0x8(%ebp),%eax
  803039:	73 1b                	jae    803056 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80303b:	a1 30 50 80 00       	mov    0x805030,%eax
  803040:	83 ec 04             	sub    $0x4,%esp
  803043:	ff 75 08             	pushl  0x8(%ebp)
  803046:	6a 00                	push   $0x0
  803048:	50                   	push   %eax
  803049:	e8 b2 fb ff ff       	call   802c00 <merging>
  80304e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803051:	e9 8b 00 00 00       	jmp    8030e1 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803056:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80305b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80305e:	76 18                	jbe    803078 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803060:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803065:	83 ec 04             	sub    $0x4,%esp
  803068:	ff 75 08             	pushl  0x8(%ebp)
  80306b:	50                   	push   %eax
  80306c:	6a 00                	push   $0x0
  80306e:	e8 8d fb ff ff       	call   802c00 <merging>
  803073:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803076:	eb 69                	jmp    8030e1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803078:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80307d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803080:	eb 39                	jmp    8030bb <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	3b 45 08             	cmp    0x8(%ebp),%eax
  803088:	73 29                	jae    8030b3 <free_block+0x90>
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803092:	76 1f                	jbe    8030b3 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 00                	mov    (%eax),%eax
  803099:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	ff 75 08             	pushl  0x8(%ebp)
  8030a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8030a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8030a8:	e8 53 fb ff ff       	call   802c00 <merging>
  8030ad:	83 c4 10             	add    $0x10,%esp
			break;
  8030b0:	90                   	nop
		}
	}
}
  8030b1:	eb 2e                	jmp    8030e1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030b3:	a1 34 50 80 00       	mov    0x805034,%eax
  8030b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bf:	74 07                	je     8030c8 <free_block+0xa5>
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 00                	mov    (%eax),%eax
  8030c6:	eb 05                	jmp    8030cd <free_block+0xaa>
  8030c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8030cd:	a3 34 50 80 00       	mov    %eax,0x805034
  8030d2:	a1 34 50 80 00       	mov    0x805034,%eax
  8030d7:	85 c0                	test   %eax,%eax
  8030d9:	75 a7                	jne    803082 <free_block+0x5f>
  8030db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030df:	75 a1                	jne    803082 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030e1:	90                   	nop
  8030e2:	c9                   	leave  
  8030e3:	c3                   	ret    

008030e4 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8030e4:	55                   	push   %ebp
  8030e5:	89 e5                	mov    %esp,%ebp
  8030e7:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8030ea:	ff 75 08             	pushl  0x8(%ebp)
  8030ed:	e8 ed ec ff ff       	call   801ddf <get_block_size>
  8030f2:	83 c4 04             	add    $0x4,%esp
  8030f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8030f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8030ff:	eb 17                	jmp    803118 <copy_data+0x34>
  803101:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803104:	8b 45 0c             	mov    0xc(%ebp),%eax
  803107:	01 c2                	add    %eax,%edx
  803109:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	01 c8                	add    %ecx,%eax
  803111:	8a 00                	mov    (%eax),%al
  803113:	88 02                	mov    %al,(%edx)
  803115:	ff 45 fc             	incl   -0x4(%ebp)
  803118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80311b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80311e:	72 e1                	jb     803101 <copy_data+0x1d>
}
  803120:	90                   	nop
  803121:	c9                   	leave  
  803122:	c3                   	ret    

00803123 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803123:	55                   	push   %ebp
  803124:	89 e5                	mov    %esp,%ebp
  803126:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803129:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312d:	75 23                	jne    803152 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80312f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803133:	74 13                	je     803148 <realloc_block_FF+0x25>
  803135:	83 ec 0c             	sub    $0xc,%esp
  803138:	ff 75 0c             	pushl  0xc(%ebp)
  80313b:	e8 1f f0 ff ff       	call   80215f <alloc_block_FF>
  803140:	83 c4 10             	add    $0x10,%esp
  803143:	e9 f4 06 00 00       	jmp    80383c <realloc_block_FF+0x719>
		return NULL;
  803148:	b8 00 00 00 00       	mov    $0x0,%eax
  80314d:	e9 ea 06 00 00       	jmp    80383c <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803152:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803156:	75 18                	jne    803170 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803158:	83 ec 0c             	sub    $0xc,%esp
  80315b:	ff 75 08             	pushl  0x8(%ebp)
  80315e:	e8 c0 fe ff ff       	call   803023 <free_block>
  803163:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803166:	b8 00 00 00 00       	mov    $0x0,%eax
  80316b:	e9 cc 06 00 00       	jmp    80383c <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803170:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803174:	77 07                	ja     80317d <realloc_block_FF+0x5a>
  803176:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80317d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803180:	83 e0 01             	and    $0x1,%eax
  803183:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803186:	8b 45 0c             	mov    0xc(%ebp),%eax
  803189:	83 c0 08             	add    $0x8,%eax
  80318c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80318f:	83 ec 0c             	sub    $0xc,%esp
  803192:	ff 75 08             	pushl  0x8(%ebp)
  803195:	e8 45 ec ff ff       	call   801ddf <get_block_size>
  80319a:	83 c4 10             	add    $0x10,%esp
  80319d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a3:	83 e8 08             	sub    $0x8,%eax
  8031a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	83 e8 04             	sub    $0x4,%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	83 e0 fe             	and    $0xfffffffe,%eax
  8031b4:	89 c2                	mov    %eax,%edx
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	01 d0                	add    %edx,%eax
  8031bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031be:	83 ec 0c             	sub    $0xc,%esp
  8031c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031c4:	e8 16 ec ff ff       	call   801ddf <get_block_size>
  8031c9:	83 c4 10             	add    $0x10,%esp
  8031cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d2:	83 e8 08             	sub    $0x8,%eax
  8031d5:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8031d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031db:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031de:	75 08                	jne    8031e8 <realloc_block_FF+0xc5>
	{
		 return va;
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	e9 54 06 00 00       	jmp    80383c <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8031e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031eb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031ee:	0f 83 e5 03 00 00    	jae    8035d9 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8031f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f7:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8031fd:	83 ec 0c             	sub    $0xc,%esp
  803200:	ff 75 e4             	pushl  -0x1c(%ebp)
  803203:	e8 f0 eb ff ff       	call   801df8 <is_free_block>
  803208:	83 c4 10             	add    $0x10,%esp
  80320b:	84 c0                	test   %al,%al
  80320d:	0f 84 3b 01 00 00    	je     80334e <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803213:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803216:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803219:	01 d0                	add    %edx,%eax
  80321b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80321e:	83 ec 04             	sub    $0x4,%esp
  803221:	6a 01                	push   $0x1
  803223:	ff 75 f0             	pushl  -0x10(%ebp)
  803226:	ff 75 08             	pushl  0x8(%ebp)
  803229:	e8 02 ef ff ff       	call   802130 <set_block_data>
  80322e:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	83 e8 04             	sub    $0x4,%eax
  803237:	8b 00                	mov    (%eax),%eax
  803239:	83 e0 fe             	and    $0xfffffffe,%eax
  80323c:	89 c2                	mov    %eax,%edx
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	01 d0                	add    %edx,%eax
  803243:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803246:	83 ec 04             	sub    $0x4,%esp
  803249:	6a 00                	push   $0x0
  80324b:	ff 75 cc             	pushl  -0x34(%ebp)
  80324e:	ff 75 c8             	pushl  -0x38(%ebp)
  803251:	e8 da ee ff ff       	call   802130 <set_block_data>
  803256:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803259:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80325d:	74 06                	je     803265 <realloc_block_FF+0x142>
  80325f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803263:	75 17                	jne    80327c <realloc_block_FF+0x159>
  803265:	83 ec 04             	sub    $0x4,%esp
  803268:	68 44 43 80 00       	push   $0x804344
  80326d:	68 f6 01 00 00       	push   $0x1f6
  803272:	68 d1 42 80 00       	push   $0x8042d1
  803277:	e8 c1 cf ff ff       	call   80023d <_panic>
  80327c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327f:	8b 10                	mov    (%eax),%edx
  803281:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803284:	89 10                	mov    %edx,(%eax)
  803286:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803289:	8b 00                	mov    (%eax),%eax
  80328b:	85 c0                	test   %eax,%eax
  80328d:	74 0b                	je     80329a <realloc_block_FF+0x177>
  80328f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803292:	8b 00                	mov    (%eax),%eax
  803294:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803297:	89 50 04             	mov    %edx,0x4(%eax)
  80329a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032a0:	89 10                	mov    %edx,(%eax)
  8032a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032a8:	89 50 04             	mov    %edx,0x4(%eax)
  8032ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ae:	8b 00                	mov    (%eax),%eax
  8032b0:	85 c0                	test   %eax,%eax
  8032b2:	75 08                	jne    8032bc <realloc_block_FF+0x199>
  8032b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8032bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8032c1:	40                   	inc    %eax
  8032c2:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032cb:	75 17                	jne    8032e4 <realloc_block_FF+0x1c1>
  8032cd:	83 ec 04             	sub    $0x4,%esp
  8032d0:	68 b3 42 80 00       	push   $0x8042b3
  8032d5:	68 f7 01 00 00       	push   $0x1f7
  8032da:	68 d1 42 80 00       	push   $0x8042d1
  8032df:	e8 59 cf ff ff       	call   80023d <_panic>
  8032e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	74 10                	je     8032fd <realloc_block_FF+0x1da>
  8032ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032f5:	8b 52 04             	mov    0x4(%edx),%edx
  8032f8:	89 50 04             	mov    %edx,0x4(%eax)
  8032fb:	eb 0b                	jmp    803308 <realloc_block_FF+0x1e5>
  8032fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803300:	8b 40 04             	mov    0x4(%eax),%eax
  803303:	a3 30 50 80 00       	mov    %eax,0x805030
  803308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330b:	8b 40 04             	mov    0x4(%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	74 0f                	je     803321 <realloc_block_FF+0x1fe>
  803312:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803315:	8b 40 04             	mov    0x4(%eax),%eax
  803318:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80331b:	8b 12                	mov    (%edx),%edx
  80331d:	89 10                	mov    %edx,(%eax)
  80331f:	eb 0a                	jmp    80332b <realloc_block_FF+0x208>
  803321:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803324:	8b 00                	mov    (%eax),%eax
  803326:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80332b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803334:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803337:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333e:	a1 38 50 80 00       	mov    0x805038,%eax
  803343:	48                   	dec    %eax
  803344:	a3 38 50 80 00       	mov    %eax,0x805038
  803349:	e9 83 02 00 00       	jmp    8035d1 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80334e:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803352:	0f 86 69 02 00 00    	jbe    8035c1 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803358:	83 ec 04             	sub    $0x4,%esp
  80335b:	6a 01                	push   $0x1
  80335d:	ff 75 f0             	pushl  -0x10(%ebp)
  803360:	ff 75 08             	pushl  0x8(%ebp)
  803363:	e8 c8 ed ff ff       	call   802130 <set_block_data>
  803368:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	83 e8 04             	sub    $0x4,%eax
  803371:	8b 00                	mov    (%eax),%eax
  803373:	83 e0 fe             	and    $0xfffffffe,%eax
  803376:	89 c2                	mov    %eax,%edx
  803378:	8b 45 08             	mov    0x8(%ebp),%eax
  80337b:	01 d0                	add    %edx,%eax
  80337d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803380:	a1 38 50 80 00       	mov    0x805038,%eax
  803385:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803388:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80338c:	75 68                	jne    8033f6 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80338e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803392:	75 17                	jne    8033ab <realloc_block_FF+0x288>
  803394:	83 ec 04             	sub    $0x4,%esp
  803397:	68 ec 42 80 00       	push   $0x8042ec
  80339c:	68 06 02 00 00       	push   $0x206
  8033a1:	68 d1 42 80 00       	push   $0x8042d1
  8033a6:	e8 92 ce ff ff       	call   80023d <_panic>
  8033ab:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b4:	89 10                	mov    %edx,(%eax)
  8033b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b9:	8b 00                	mov    (%eax),%eax
  8033bb:	85 c0                	test   %eax,%eax
  8033bd:	74 0d                	je     8033cc <realloc_block_FF+0x2a9>
  8033bf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033c7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ca:	eb 08                	jmp    8033d4 <realloc_block_FF+0x2b1>
  8033cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033cf:	a3 30 50 80 00       	mov    %eax,0x805030
  8033d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e6:	a1 38 50 80 00       	mov    0x805038,%eax
  8033eb:	40                   	inc    %eax
  8033ec:	a3 38 50 80 00       	mov    %eax,0x805038
  8033f1:	e9 b0 01 00 00       	jmp    8035a6 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8033f6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033fb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033fe:	76 68                	jbe    803468 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803400:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803404:	75 17                	jne    80341d <realloc_block_FF+0x2fa>
  803406:	83 ec 04             	sub    $0x4,%esp
  803409:	68 ec 42 80 00       	push   $0x8042ec
  80340e:	68 0b 02 00 00       	push   $0x20b
  803413:	68 d1 42 80 00       	push   $0x8042d1
  803418:	e8 20 ce ff ff       	call   80023d <_panic>
  80341d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803423:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803426:	89 10                	mov    %edx,(%eax)
  803428:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	85 c0                	test   %eax,%eax
  80342f:	74 0d                	je     80343e <realloc_block_FF+0x31b>
  803431:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803436:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803439:	89 50 04             	mov    %edx,0x4(%eax)
  80343c:	eb 08                	jmp    803446 <realloc_block_FF+0x323>
  80343e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803441:	a3 30 50 80 00       	mov    %eax,0x805030
  803446:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803449:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80344e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803451:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803458:	a1 38 50 80 00       	mov    0x805038,%eax
  80345d:	40                   	inc    %eax
  80345e:	a3 38 50 80 00       	mov    %eax,0x805038
  803463:	e9 3e 01 00 00       	jmp    8035a6 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803468:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80346d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803470:	73 68                	jae    8034da <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803472:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803476:	75 17                	jne    80348f <realloc_block_FF+0x36c>
  803478:	83 ec 04             	sub    $0x4,%esp
  80347b:	68 20 43 80 00       	push   $0x804320
  803480:	68 10 02 00 00       	push   $0x210
  803485:	68 d1 42 80 00       	push   $0x8042d1
  80348a:	e8 ae cd ff ff       	call   80023d <_panic>
  80348f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803495:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803498:	89 50 04             	mov    %edx,0x4(%eax)
  80349b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349e:	8b 40 04             	mov    0x4(%eax),%eax
  8034a1:	85 c0                	test   %eax,%eax
  8034a3:	74 0c                	je     8034b1 <realloc_block_FF+0x38e>
  8034a5:	a1 30 50 80 00       	mov    0x805030,%eax
  8034aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034ad:	89 10                	mov    %edx,(%eax)
  8034af:	eb 08                	jmp    8034b9 <realloc_block_FF+0x396>
  8034b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8034c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8034cf:	40                   	inc    %eax
  8034d0:	a3 38 50 80 00       	mov    %eax,0x805038
  8034d5:	e9 cc 00 00 00       	jmp    8035a6 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8034da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8034e1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034e9:	e9 8a 00 00 00       	jmp    803578 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8034ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034f4:	73 7a                	jae    803570 <realloc_block_FF+0x44d>
  8034f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f9:	8b 00                	mov    (%eax),%eax
  8034fb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034fe:	73 70                	jae    803570 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803504:	74 06                	je     80350c <realloc_block_FF+0x3e9>
  803506:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80350a:	75 17                	jne    803523 <realloc_block_FF+0x400>
  80350c:	83 ec 04             	sub    $0x4,%esp
  80350f:	68 44 43 80 00       	push   $0x804344
  803514:	68 1a 02 00 00       	push   $0x21a
  803519:	68 d1 42 80 00       	push   $0x8042d1
  80351e:	e8 1a cd ff ff       	call   80023d <_panic>
  803523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803526:	8b 10                	mov    (%eax),%edx
  803528:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352b:	89 10                	mov    %edx,(%eax)
  80352d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803530:	8b 00                	mov    (%eax),%eax
  803532:	85 c0                	test   %eax,%eax
  803534:	74 0b                	je     803541 <realloc_block_FF+0x41e>
  803536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803539:	8b 00                	mov    (%eax),%eax
  80353b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80353e:	89 50 04             	mov    %edx,0x4(%eax)
  803541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803544:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803547:	89 10                	mov    %edx,(%eax)
  803549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80354f:	89 50 04             	mov    %edx,0x4(%eax)
  803552:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803555:	8b 00                	mov    (%eax),%eax
  803557:	85 c0                	test   %eax,%eax
  803559:	75 08                	jne    803563 <realloc_block_FF+0x440>
  80355b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355e:	a3 30 50 80 00       	mov    %eax,0x805030
  803563:	a1 38 50 80 00       	mov    0x805038,%eax
  803568:	40                   	inc    %eax
  803569:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80356e:	eb 36                	jmp    8035a6 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803570:	a1 34 50 80 00       	mov    0x805034,%eax
  803575:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803578:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80357c:	74 07                	je     803585 <realloc_block_FF+0x462>
  80357e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803581:	8b 00                	mov    (%eax),%eax
  803583:	eb 05                	jmp    80358a <realloc_block_FF+0x467>
  803585:	b8 00 00 00 00       	mov    $0x0,%eax
  80358a:	a3 34 50 80 00       	mov    %eax,0x805034
  80358f:	a1 34 50 80 00       	mov    0x805034,%eax
  803594:	85 c0                	test   %eax,%eax
  803596:	0f 85 52 ff ff ff    	jne    8034ee <realloc_block_FF+0x3cb>
  80359c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a0:	0f 85 48 ff ff ff    	jne    8034ee <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035a6:	83 ec 04             	sub    $0x4,%esp
  8035a9:	6a 00                	push   $0x0
  8035ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8035ae:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035b1:	e8 7a eb ff ff       	call   802130 <set_block_data>
  8035b6:	83 c4 10             	add    $0x10,%esp
				return va;
  8035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bc:	e9 7b 02 00 00       	jmp    80383c <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035c1:	83 ec 0c             	sub    $0xc,%esp
  8035c4:	68 c1 43 80 00       	push   $0x8043c1
  8035c9:	e8 2c cf ff ff       	call   8004fa <cprintf>
  8035ce:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8035d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d4:	e9 63 02 00 00       	jmp    80383c <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8035d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035dc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035df:	0f 86 4d 02 00 00    	jbe    803832 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8035e5:	83 ec 0c             	sub    $0xc,%esp
  8035e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035eb:	e8 08 e8 ff ff       	call   801df8 <is_free_block>
  8035f0:	83 c4 10             	add    $0x10,%esp
  8035f3:	84 c0                	test   %al,%al
  8035f5:	0f 84 37 02 00 00    	je     803832 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8035fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fe:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803601:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803604:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803607:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80360a:	76 38                	jbe    803644 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80360c:	83 ec 0c             	sub    $0xc,%esp
  80360f:	ff 75 08             	pushl  0x8(%ebp)
  803612:	e8 0c fa ff ff       	call   803023 <free_block>
  803617:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80361a:	83 ec 0c             	sub    $0xc,%esp
  80361d:	ff 75 0c             	pushl  0xc(%ebp)
  803620:	e8 3a eb ff ff       	call   80215f <alloc_block_FF>
  803625:	83 c4 10             	add    $0x10,%esp
  803628:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80362b:	83 ec 08             	sub    $0x8,%esp
  80362e:	ff 75 c0             	pushl  -0x40(%ebp)
  803631:	ff 75 08             	pushl  0x8(%ebp)
  803634:	e8 ab fa ff ff       	call   8030e4 <copy_data>
  803639:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80363c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80363f:	e9 f8 01 00 00       	jmp    80383c <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803644:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803647:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80364a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80364d:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803651:	0f 87 a0 00 00 00    	ja     8036f7 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803657:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80365b:	75 17                	jne    803674 <realloc_block_FF+0x551>
  80365d:	83 ec 04             	sub    $0x4,%esp
  803660:	68 b3 42 80 00       	push   $0x8042b3
  803665:	68 38 02 00 00       	push   $0x238
  80366a:	68 d1 42 80 00       	push   $0x8042d1
  80366f:	e8 c9 cb ff ff       	call   80023d <_panic>
  803674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803677:	8b 00                	mov    (%eax),%eax
  803679:	85 c0                	test   %eax,%eax
  80367b:	74 10                	je     80368d <realloc_block_FF+0x56a>
  80367d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803680:	8b 00                	mov    (%eax),%eax
  803682:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803685:	8b 52 04             	mov    0x4(%edx),%edx
  803688:	89 50 04             	mov    %edx,0x4(%eax)
  80368b:	eb 0b                	jmp    803698 <realloc_block_FF+0x575>
  80368d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803690:	8b 40 04             	mov    0x4(%eax),%eax
  803693:	a3 30 50 80 00       	mov    %eax,0x805030
  803698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369b:	8b 40 04             	mov    0x4(%eax),%eax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	74 0f                	je     8036b1 <realloc_block_FF+0x58e>
  8036a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a5:	8b 40 04             	mov    0x4(%eax),%eax
  8036a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ab:	8b 12                	mov    (%edx),%edx
  8036ad:	89 10                	mov    %edx,(%eax)
  8036af:	eb 0a                	jmp    8036bb <realloc_block_FF+0x598>
  8036b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b4:	8b 00                	mov    (%eax),%eax
  8036b6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8036d3:	48                   	dec    %eax
  8036d4:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8036d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036df:	01 d0                	add    %edx,%eax
  8036e1:	83 ec 04             	sub    $0x4,%esp
  8036e4:	6a 01                	push   $0x1
  8036e6:	50                   	push   %eax
  8036e7:	ff 75 08             	pushl  0x8(%ebp)
  8036ea:	e8 41 ea ff ff       	call   802130 <set_block_data>
  8036ef:	83 c4 10             	add    $0x10,%esp
  8036f2:	e9 36 01 00 00       	jmp    80382d <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8036f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036fa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036fd:	01 d0                	add    %edx,%eax
  8036ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803702:	83 ec 04             	sub    $0x4,%esp
  803705:	6a 01                	push   $0x1
  803707:	ff 75 f0             	pushl  -0x10(%ebp)
  80370a:	ff 75 08             	pushl  0x8(%ebp)
  80370d:	e8 1e ea ff ff       	call   802130 <set_block_data>
  803712:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	83 e8 04             	sub    $0x4,%eax
  80371b:	8b 00                	mov    (%eax),%eax
  80371d:	83 e0 fe             	and    $0xfffffffe,%eax
  803720:	89 c2                	mov    %eax,%edx
  803722:	8b 45 08             	mov    0x8(%ebp),%eax
  803725:	01 d0                	add    %edx,%eax
  803727:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80372a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80372e:	74 06                	je     803736 <realloc_block_FF+0x613>
  803730:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803734:	75 17                	jne    80374d <realloc_block_FF+0x62a>
  803736:	83 ec 04             	sub    $0x4,%esp
  803739:	68 44 43 80 00       	push   $0x804344
  80373e:	68 44 02 00 00       	push   $0x244
  803743:	68 d1 42 80 00       	push   $0x8042d1
  803748:	e8 f0 ca ff ff       	call   80023d <_panic>
  80374d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803750:	8b 10                	mov    (%eax),%edx
  803752:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803755:	89 10                	mov    %edx,(%eax)
  803757:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80375a:	8b 00                	mov    (%eax),%eax
  80375c:	85 c0                	test   %eax,%eax
  80375e:	74 0b                	je     80376b <realloc_block_FF+0x648>
  803760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803763:	8b 00                	mov    (%eax),%eax
  803765:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803768:	89 50 04             	mov    %edx,0x4(%eax)
  80376b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803771:	89 10                	mov    %edx,(%eax)
  803773:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803776:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803779:	89 50 04             	mov    %edx,0x4(%eax)
  80377c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80377f:	8b 00                	mov    (%eax),%eax
  803781:	85 c0                	test   %eax,%eax
  803783:	75 08                	jne    80378d <realloc_block_FF+0x66a>
  803785:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803788:	a3 30 50 80 00       	mov    %eax,0x805030
  80378d:	a1 38 50 80 00       	mov    0x805038,%eax
  803792:	40                   	inc    %eax
  803793:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803798:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80379c:	75 17                	jne    8037b5 <realloc_block_FF+0x692>
  80379e:	83 ec 04             	sub    $0x4,%esp
  8037a1:	68 b3 42 80 00       	push   $0x8042b3
  8037a6:	68 45 02 00 00       	push   $0x245
  8037ab:	68 d1 42 80 00       	push   $0x8042d1
  8037b0:	e8 88 ca ff ff       	call   80023d <_panic>
  8037b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b8:	8b 00                	mov    (%eax),%eax
  8037ba:	85 c0                	test   %eax,%eax
  8037bc:	74 10                	je     8037ce <realloc_block_FF+0x6ab>
  8037be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c1:	8b 00                	mov    (%eax),%eax
  8037c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037c6:	8b 52 04             	mov    0x4(%edx),%edx
  8037c9:	89 50 04             	mov    %edx,0x4(%eax)
  8037cc:	eb 0b                	jmp    8037d9 <realloc_block_FF+0x6b6>
  8037ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d1:	8b 40 04             	mov    0x4(%eax),%eax
  8037d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8037d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037dc:	8b 40 04             	mov    0x4(%eax),%eax
  8037df:	85 c0                	test   %eax,%eax
  8037e1:	74 0f                	je     8037f2 <realloc_block_FF+0x6cf>
  8037e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e6:	8b 40 04             	mov    0x4(%eax),%eax
  8037e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ec:	8b 12                	mov    (%edx),%edx
  8037ee:	89 10                	mov    %edx,(%eax)
  8037f0:	eb 0a                	jmp    8037fc <realloc_block_FF+0x6d9>
  8037f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803808:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380f:	a1 38 50 80 00       	mov    0x805038,%eax
  803814:	48                   	dec    %eax
  803815:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80381a:	83 ec 04             	sub    $0x4,%esp
  80381d:	6a 00                	push   $0x0
  80381f:	ff 75 bc             	pushl  -0x44(%ebp)
  803822:	ff 75 b8             	pushl  -0x48(%ebp)
  803825:	e8 06 e9 ff ff       	call   802130 <set_block_data>
  80382a:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	eb 0a                	jmp    80383c <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803832:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803839:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80383c:	c9                   	leave  
  80383d:	c3                   	ret    

0080383e <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80383e:	55                   	push   %ebp
  80383f:	89 e5                	mov    %esp,%ebp
  803841:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803844:	83 ec 04             	sub    $0x4,%esp
  803847:	68 c8 43 80 00       	push   $0x8043c8
  80384c:	68 58 02 00 00       	push   $0x258
  803851:	68 d1 42 80 00       	push   $0x8042d1
  803856:	e8 e2 c9 ff ff       	call   80023d <_panic>

0080385b <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80385b:	55                   	push   %ebp
  80385c:	89 e5                	mov    %esp,%ebp
  80385e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803861:	83 ec 04             	sub    $0x4,%esp
  803864:	68 f0 43 80 00       	push   $0x8043f0
  803869:	68 61 02 00 00       	push   $0x261
  80386e:	68 d1 42 80 00       	push   $0x8042d1
  803873:	e8 c5 c9 ff ff       	call   80023d <_panic>

00803878 <__udivdi3>:
  803878:	55                   	push   %ebp
  803879:	57                   	push   %edi
  80387a:	56                   	push   %esi
  80387b:	53                   	push   %ebx
  80387c:	83 ec 1c             	sub    $0x1c,%esp
  80387f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803883:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803887:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80388b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80388f:	89 ca                	mov    %ecx,%edx
  803891:	89 f8                	mov    %edi,%eax
  803893:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803897:	85 f6                	test   %esi,%esi
  803899:	75 2d                	jne    8038c8 <__udivdi3+0x50>
  80389b:	39 cf                	cmp    %ecx,%edi
  80389d:	77 65                	ja     803904 <__udivdi3+0x8c>
  80389f:	89 fd                	mov    %edi,%ebp
  8038a1:	85 ff                	test   %edi,%edi
  8038a3:	75 0b                	jne    8038b0 <__udivdi3+0x38>
  8038a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8038aa:	31 d2                	xor    %edx,%edx
  8038ac:	f7 f7                	div    %edi
  8038ae:	89 c5                	mov    %eax,%ebp
  8038b0:	31 d2                	xor    %edx,%edx
  8038b2:	89 c8                	mov    %ecx,%eax
  8038b4:	f7 f5                	div    %ebp
  8038b6:	89 c1                	mov    %eax,%ecx
  8038b8:	89 d8                	mov    %ebx,%eax
  8038ba:	f7 f5                	div    %ebp
  8038bc:	89 cf                	mov    %ecx,%edi
  8038be:	89 fa                	mov    %edi,%edx
  8038c0:	83 c4 1c             	add    $0x1c,%esp
  8038c3:	5b                   	pop    %ebx
  8038c4:	5e                   	pop    %esi
  8038c5:	5f                   	pop    %edi
  8038c6:	5d                   	pop    %ebp
  8038c7:	c3                   	ret    
  8038c8:	39 ce                	cmp    %ecx,%esi
  8038ca:	77 28                	ja     8038f4 <__udivdi3+0x7c>
  8038cc:	0f bd fe             	bsr    %esi,%edi
  8038cf:	83 f7 1f             	xor    $0x1f,%edi
  8038d2:	75 40                	jne    803914 <__udivdi3+0x9c>
  8038d4:	39 ce                	cmp    %ecx,%esi
  8038d6:	72 0a                	jb     8038e2 <__udivdi3+0x6a>
  8038d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038dc:	0f 87 9e 00 00 00    	ja     803980 <__udivdi3+0x108>
  8038e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038e7:	89 fa                	mov    %edi,%edx
  8038e9:	83 c4 1c             	add    $0x1c,%esp
  8038ec:	5b                   	pop    %ebx
  8038ed:	5e                   	pop    %esi
  8038ee:	5f                   	pop    %edi
  8038ef:	5d                   	pop    %ebp
  8038f0:	c3                   	ret    
  8038f1:	8d 76 00             	lea    0x0(%esi),%esi
  8038f4:	31 ff                	xor    %edi,%edi
  8038f6:	31 c0                	xor    %eax,%eax
  8038f8:	89 fa                	mov    %edi,%edx
  8038fa:	83 c4 1c             	add    $0x1c,%esp
  8038fd:	5b                   	pop    %ebx
  8038fe:	5e                   	pop    %esi
  8038ff:	5f                   	pop    %edi
  803900:	5d                   	pop    %ebp
  803901:	c3                   	ret    
  803902:	66 90                	xchg   %ax,%ax
  803904:	89 d8                	mov    %ebx,%eax
  803906:	f7 f7                	div    %edi
  803908:	31 ff                	xor    %edi,%edi
  80390a:	89 fa                	mov    %edi,%edx
  80390c:	83 c4 1c             	add    $0x1c,%esp
  80390f:	5b                   	pop    %ebx
  803910:	5e                   	pop    %esi
  803911:	5f                   	pop    %edi
  803912:	5d                   	pop    %ebp
  803913:	c3                   	ret    
  803914:	bd 20 00 00 00       	mov    $0x20,%ebp
  803919:	89 eb                	mov    %ebp,%ebx
  80391b:	29 fb                	sub    %edi,%ebx
  80391d:	89 f9                	mov    %edi,%ecx
  80391f:	d3 e6                	shl    %cl,%esi
  803921:	89 c5                	mov    %eax,%ebp
  803923:	88 d9                	mov    %bl,%cl
  803925:	d3 ed                	shr    %cl,%ebp
  803927:	89 e9                	mov    %ebp,%ecx
  803929:	09 f1                	or     %esi,%ecx
  80392b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80392f:	89 f9                	mov    %edi,%ecx
  803931:	d3 e0                	shl    %cl,%eax
  803933:	89 c5                	mov    %eax,%ebp
  803935:	89 d6                	mov    %edx,%esi
  803937:	88 d9                	mov    %bl,%cl
  803939:	d3 ee                	shr    %cl,%esi
  80393b:	89 f9                	mov    %edi,%ecx
  80393d:	d3 e2                	shl    %cl,%edx
  80393f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803943:	88 d9                	mov    %bl,%cl
  803945:	d3 e8                	shr    %cl,%eax
  803947:	09 c2                	or     %eax,%edx
  803949:	89 d0                	mov    %edx,%eax
  80394b:	89 f2                	mov    %esi,%edx
  80394d:	f7 74 24 0c          	divl   0xc(%esp)
  803951:	89 d6                	mov    %edx,%esi
  803953:	89 c3                	mov    %eax,%ebx
  803955:	f7 e5                	mul    %ebp
  803957:	39 d6                	cmp    %edx,%esi
  803959:	72 19                	jb     803974 <__udivdi3+0xfc>
  80395b:	74 0b                	je     803968 <__udivdi3+0xf0>
  80395d:	89 d8                	mov    %ebx,%eax
  80395f:	31 ff                	xor    %edi,%edi
  803961:	e9 58 ff ff ff       	jmp    8038be <__udivdi3+0x46>
  803966:	66 90                	xchg   %ax,%ax
  803968:	8b 54 24 08          	mov    0x8(%esp),%edx
  80396c:	89 f9                	mov    %edi,%ecx
  80396e:	d3 e2                	shl    %cl,%edx
  803970:	39 c2                	cmp    %eax,%edx
  803972:	73 e9                	jae    80395d <__udivdi3+0xe5>
  803974:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803977:	31 ff                	xor    %edi,%edi
  803979:	e9 40 ff ff ff       	jmp    8038be <__udivdi3+0x46>
  80397e:	66 90                	xchg   %ax,%ax
  803980:	31 c0                	xor    %eax,%eax
  803982:	e9 37 ff ff ff       	jmp    8038be <__udivdi3+0x46>
  803987:	90                   	nop

00803988 <__umoddi3>:
  803988:	55                   	push   %ebp
  803989:	57                   	push   %edi
  80398a:	56                   	push   %esi
  80398b:	53                   	push   %ebx
  80398c:	83 ec 1c             	sub    $0x1c,%esp
  80398f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803993:	8b 74 24 34          	mov    0x34(%esp),%esi
  803997:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80399b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80399f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039a7:	89 f3                	mov    %esi,%ebx
  8039a9:	89 fa                	mov    %edi,%edx
  8039ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039af:	89 34 24             	mov    %esi,(%esp)
  8039b2:	85 c0                	test   %eax,%eax
  8039b4:	75 1a                	jne    8039d0 <__umoddi3+0x48>
  8039b6:	39 f7                	cmp    %esi,%edi
  8039b8:	0f 86 a2 00 00 00    	jbe    803a60 <__umoddi3+0xd8>
  8039be:	89 c8                	mov    %ecx,%eax
  8039c0:	89 f2                	mov    %esi,%edx
  8039c2:	f7 f7                	div    %edi
  8039c4:	89 d0                	mov    %edx,%eax
  8039c6:	31 d2                	xor    %edx,%edx
  8039c8:	83 c4 1c             	add    $0x1c,%esp
  8039cb:	5b                   	pop    %ebx
  8039cc:	5e                   	pop    %esi
  8039cd:	5f                   	pop    %edi
  8039ce:	5d                   	pop    %ebp
  8039cf:	c3                   	ret    
  8039d0:	39 f0                	cmp    %esi,%eax
  8039d2:	0f 87 ac 00 00 00    	ja     803a84 <__umoddi3+0xfc>
  8039d8:	0f bd e8             	bsr    %eax,%ebp
  8039db:	83 f5 1f             	xor    $0x1f,%ebp
  8039de:	0f 84 ac 00 00 00    	je     803a90 <__umoddi3+0x108>
  8039e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8039e9:	29 ef                	sub    %ebp,%edi
  8039eb:	89 fe                	mov    %edi,%esi
  8039ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039f1:	89 e9                	mov    %ebp,%ecx
  8039f3:	d3 e0                	shl    %cl,%eax
  8039f5:	89 d7                	mov    %edx,%edi
  8039f7:	89 f1                	mov    %esi,%ecx
  8039f9:	d3 ef                	shr    %cl,%edi
  8039fb:	09 c7                	or     %eax,%edi
  8039fd:	89 e9                	mov    %ebp,%ecx
  8039ff:	d3 e2                	shl    %cl,%edx
  803a01:	89 14 24             	mov    %edx,(%esp)
  803a04:	89 d8                	mov    %ebx,%eax
  803a06:	d3 e0                	shl    %cl,%eax
  803a08:	89 c2                	mov    %eax,%edx
  803a0a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a0e:	d3 e0                	shl    %cl,%eax
  803a10:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a14:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a18:	89 f1                	mov    %esi,%ecx
  803a1a:	d3 e8                	shr    %cl,%eax
  803a1c:	09 d0                	or     %edx,%eax
  803a1e:	d3 eb                	shr    %cl,%ebx
  803a20:	89 da                	mov    %ebx,%edx
  803a22:	f7 f7                	div    %edi
  803a24:	89 d3                	mov    %edx,%ebx
  803a26:	f7 24 24             	mull   (%esp)
  803a29:	89 c6                	mov    %eax,%esi
  803a2b:	89 d1                	mov    %edx,%ecx
  803a2d:	39 d3                	cmp    %edx,%ebx
  803a2f:	0f 82 87 00 00 00    	jb     803abc <__umoddi3+0x134>
  803a35:	0f 84 91 00 00 00    	je     803acc <__umoddi3+0x144>
  803a3b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a3f:	29 f2                	sub    %esi,%edx
  803a41:	19 cb                	sbb    %ecx,%ebx
  803a43:	89 d8                	mov    %ebx,%eax
  803a45:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a49:	d3 e0                	shl    %cl,%eax
  803a4b:	89 e9                	mov    %ebp,%ecx
  803a4d:	d3 ea                	shr    %cl,%edx
  803a4f:	09 d0                	or     %edx,%eax
  803a51:	89 e9                	mov    %ebp,%ecx
  803a53:	d3 eb                	shr    %cl,%ebx
  803a55:	89 da                	mov    %ebx,%edx
  803a57:	83 c4 1c             	add    $0x1c,%esp
  803a5a:	5b                   	pop    %ebx
  803a5b:	5e                   	pop    %esi
  803a5c:	5f                   	pop    %edi
  803a5d:	5d                   	pop    %ebp
  803a5e:	c3                   	ret    
  803a5f:	90                   	nop
  803a60:	89 fd                	mov    %edi,%ebp
  803a62:	85 ff                	test   %edi,%edi
  803a64:	75 0b                	jne    803a71 <__umoddi3+0xe9>
  803a66:	b8 01 00 00 00       	mov    $0x1,%eax
  803a6b:	31 d2                	xor    %edx,%edx
  803a6d:	f7 f7                	div    %edi
  803a6f:	89 c5                	mov    %eax,%ebp
  803a71:	89 f0                	mov    %esi,%eax
  803a73:	31 d2                	xor    %edx,%edx
  803a75:	f7 f5                	div    %ebp
  803a77:	89 c8                	mov    %ecx,%eax
  803a79:	f7 f5                	div    %ebp
  803a7b:	89 d0                	mov    %edx,%eax
  803a7d:	e9 44 ff ff ff       	jmp    8039c6 <__umoddi3+0x3e>
  803a82:	66 90                	xchg   %ax,%ax
  803a84:	89 c8                	mov    %ecx,%eax
  803a86:	89 f2                	mov    %esi,%edx
  803a88:	83 c4 1c             	add    $0x1c,%esp
  803a8b:	5b                   	pop    %ebx
  803a8c:	5e                   	pop    %esi
  803a8d:	5f                   	pop    %edi
  803a8e:	5d                   	pop    %ebp
  803a8f:	c3                   	ret    
  803a90:	3b 04 24             	cmp    (%esp),%eax
  803a93:	72 06                	jb     803a9b <__umoddi3+0x113>
  803a95:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a99:	77 0f                	ja     803aaa <__umoddi3+0x122>
  803a9b:	89 f2                	mov    %esi,%edx
  803a9d:	29 f9                	sub    %edi,%ecx
  803a9f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aa3:	89 14 24             	mov    %edx,(%esp)
  803aa6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aaa:	8b 44 24 04          	mov    0x4(%esp),%eax
  803aae:	8b 14 24             	mov    (%esp),%edx
  803ab1:	83 c4 1c             	add    $0x1c,%esp
  803ab4:	5b                   	pop    %ebx
  803ab5:	5e                   	pop    %esi
  803ab6:	5f                   	pop    %edi
  803ab7:	5d                   	pop    %ebp
  803ab8:	c3                   	ret    
  803ab9:	8d 76 00             	lea    0x0(%esi),%esi
  803abc:	2b 04 24             	sub    (%esp),%eax
  803abf:	19 fa                	sbb    %edi,%edx
  803ac1:	89 d1                	mov    %edx,%ecx
  803ac3:	89 c6                	mov    %eax,%esi
  803ac5:	e9 71 ff ff ff       	jmp    803a3b <__umoddi3+0xb3>
  803aca:	66 90                	xchg   %ax,%ax
  803acc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ad0:	72 ea                	jb     803abc <__umoddi3+0x134>
  803ad2:	89 d9                	mov    %ebx,%ecx
  803ad4:	e9 62 ff ff ff       	jmp    803a3b <__umoddi3+0xb3>
