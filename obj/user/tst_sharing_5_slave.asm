
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
  800031:	e8 db 00 00 00       	call   800111 <libmain>
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
  800067:	e8 e4 01 00 00       	call   800250 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	x = sget(sys_getparentenvid(),"x");
  800073:	e8 64 1a 00 00       	call   801adc <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 17 3b 80 00       	push   $0x803b17
  800080:	50                   	push   %eax
  800081:	e8 fa 15 00 00       	call   801680 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80008c:	e8 69 18 00 00       	call   8018fa <sys_calculate_free_frames>
  800091:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 1c 3b 80 00       	push   $0x803b1c
  80009c:	e8 6c 04 00 00       	call   80050d <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000aa:	e8 79 16 00 00       	call   801728 <sfree>
  8000af:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave env removed x\n");
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 40 3b 80 00       	push   $0x803b40
  8000ba:	e8 4e 04 00 00       	call   80050d <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp

	diff = (sys_calculate_free_frames() - freeFrames);
  8000c2:	e8 33 18 00 00       	call   8018fa <sys_calculate_free_frames>
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cc:	29 c2                	sub    %eax,%edx
  8000ce:	89 d0                	mov    %edx,%eax
  8000d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	expected = 1;
  8000d3:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	cprintf("Free: %d\n",diff);
  8000da:	83 ec 08             	sub    $0x8,%esp
  8000dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8000e0:	68 55 3b 80 00       	push   $0x803b55
  8000e5:	e8 23 04 00 00       	call   80050d <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000f3:	74 14                	je     800109 <_main+0xd1>
  8000f5:	83 ec 04             	sub    $0x4,%esp
  8000f8:	68 60 3b 80 00       	push   $0x803b60
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 fc 3a 80 00       	push   $0x803afc
  800104:	e8 47 01 00 00       	call   800250 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800109:	e8 f3 1a 00 00       	call   801c01 <inctst>

	return;
  80010e:	90                   	nop
}
  80010f:	c9                   	leave  
  800110:	c3                   	ret    

00800111 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800117:	e8 a7 19 00 00       	call   801ac3 <sys_getenvindex>
  80011c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80011f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800122:	89 d0                	mov    %edx,%eax
  800124:	c1 e0 03             	shl    $0x3,%eax
  800127:	01 d0                	add    %edx,%eax
  800129:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800130:	01 c8                	add    %ecx,%eax
  800132:	01 c0                	add    %eax,%eax
  800134:	01 d0                	add    %edx,%eax
  800136:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80013d:	01 c8                	add    %ecx,%eax
  80013f:	01 d0                	add    %edx,%eax
  800141:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800146:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80014b:	a1 20 50 80 00       	mov    0x805020,%eax
  800150:	8a 40 20             	mov    0x20(%eax),%al
  800153:	84 c0                	test   %al,%al
  800155:	74 0d                	je     800164 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800157:	a1 20 50 80 00       	mov    0x805020,%eax
  80015c:	83 c0 20             	add    $0x20,%eax
  80015f:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800164:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800168:	7e 0a                	jle    800174 <libmain+0x63>
		binaryname = argv[0];
  80016a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80016d:	8b 00                	mov    (%eax),%eax
  80016f:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800174:	83 ec 08             	sub    $0x8,%esp
  800177:	ff 75 0c             	pushl  0xc(%ebp)
  80017a:	ff 75 08             	pushl  0x8(%ebp)
  80017d:	e8 b6 fe ff ff       	call   800038 <_main>
  800182:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800185:	e8 bd 16 00 00       	call   801847 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	68 04 3c 80 00       	push   $0x803c04
  800192:	e8 76 03 00 00       	call   80050d <cprintf>
  800197:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80019a:	a1 20 50 80 00       	mov    0x805020,%eax
  80019f:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8001aa:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	52                   	push   %edx
  8001b4:	50                   	push   %eax
  8001b5:	68 2c 3c 80 00       	push   $0x803c2c
  8001ba:	e8 4e 03 00 00       	call   80050d <cprintf>
  8001bf:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c7:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d2:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001dd:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001e3:	51                   	push   %ecx
  8001e4:	52                   	push   %edx
  8001e5:	50                   	push   %eax
  8001e6:	68 54 3c 80 00       	push   $0x803c54
  8001eb:	e8 1d 03 00 00       	call   80050d <cprintf>
  8001f0:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	50                   	push   %eax
  800202:	68 ac 3c 80 00       	push   $0x803cac
  800207:	e8 01 03 00 00       	call   80050d <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 04 3c 80 00       	push   $0x803c04
  800217:	e8 f1 02 00 00       	call   80050d <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80021f:	e8 3d 16 00 00       	call   801861 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800224:	e8 19 00 00 00       	call   800242 <exit>
}
  800229:	90                   	nop
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	6a 00                	push   $0x0
  800237:	e8 53 18 00 00       	call   801a8f <sys_destroy_env>
  80023c:	83 c4 10             	add    $0x10,%esp
}
  80023f:	90                   	nop
  800240:	c9                   	leave  
  800241:	c3                   	ret    

00800242 <exit>:

void
exit(void)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800248:	e8 a8 18 00 00       	call   801af5 <sys_exit_env>
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800256:	8d 45 10             	lea    0x10(%ebp),%eax
  800259:	83 c0 04             	add    $0x4,%eax
  80025c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80025f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800264:	85 c0                	test   %eax,%eax
  800266:	74 16                	je     80027e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800268:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80026d:	83 ec 08             	sub    $0x8,%esp
  800270:	50                   	push   %eax
  800271:	68 c0 3c 80 00       	push   $0x803cc0
  800276:	e8 92 02 00 00       	call   80050d <cprintf>
  80027b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80027e:	a1 00 50 80 00       	mov    0x805000,%eax
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	50                   	push   %eax
  80028a:	68 c5 3c 80 00       	push   $0x803cc5
  80028f:	e8 79 02 00 00       	call   80050d <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800297:	8b 45 10             	mov    0x10(%ebp),%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a0:	50                   	push   %eax
  8002a1:	e8 fc 01 00 00       	call   8004a2 <vcprintf>
  8002a6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002a9:	83 ec 08             	sub    $0x8,%esp
  8002ac:	6a 00                	push   $0x0
  8002ae:	68 e1 3c 80 00       	push   $0x803ce1
  8002b3:	e8 ea 01 00 00       	call   8004a2 <vcprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002bb:	e8 82 ff ff ff       	call   800242 <exit>

	// should not return here
	while (1) ;
  8002c0:	eb fe                	jmp    8002c0 <_panic+0x70>

008002c2 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002cd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d6:	39 c2                	cmp    %eax,%edx
  8002d8:	74 14                	je     8002ee <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002da:	83 ec 04             	sub    $0x4,%esp
  8002dd:	68 e4 3c 80 00       	push   $0x803ce4
  8002e2:	6a 26                	push   $0x26
  8002e4:	68 30 3d 80 00       	push   $0x803d30
  8002e9:	e8 62 ff ff ff       	call   800250 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002fc:	e9 c5 00 00 00       	jmp    8003c6 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030b:	8b 45 08             	mov    0x8(%ebp),%eax
  80030e:	01 d0                	add    %edx,%eax
  800310:	8b 00                	mov    (%eax),%eax
  800312:	85 c0                	test   %eax,%eax
  800314:	75 08                	jne    80031e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800316:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800319:	e9 a5 00 00 00       	jmp    8003c3 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80031e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800325:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80032c:	eb 69                	jmp    800397 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80032e:	a1 20 50 80 00       	mov    0x805020,%eax
  800333:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800339:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80033c:	89 d0                	mov    %edx,%eax
  80033e:	01 c0                	add    %eax,%eax
  800340:	01 d0                	add    %edx,%eax
  800342:	c1 e0 03             	shl    $0x3,%eax
  800345:	01 c8                	add    %ecx,%eax
  800347:	8a 40 04             	mov    0x4(%eax),%al
  80034a:	84 c0                	test   %al,%al
  80034c:	75 46                	jne    800394 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80034e:	a1 20 50 80 00       	mov    0x805020,%eax
  800353:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800359:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035c:	89 d0                	mov    %edx,%eax
  80035e:	01 c0                	add    %eax,%eax
  800360:	01 d0                	add    %edx,%eax
  800362:	c1 e0 03             	shl    $0x3,%eax
  800365:	01 c8                	add    %ecx,%eax
  800367:	8b 00                	mov    (%eax),%eax
  800369:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80036c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80036f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800374:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800379:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	01 c8                	add    %ecx,%eax
  800385:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800387:	39 c2                	cmp    %eax,%edx
  800389:	75 09                	jne    800394 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80038b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800392:	eb 15                	jmp    8003a9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800394:	ff 45 e8             	incl   -0x18(%ebp)
  800397:	a1 20 50 80 00       	mov    0x805020,%eax
  80039c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	77 85                	ja     80032e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ad:	75 14                	jne    8003c3 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	68 3c 3d 80 00       	push   $0x803d3c
  8003b7:	6a 3a                	push   $0x3a
  8003b9:	68 30 3d 80 00       	push   $0x803d30
  8003be:	e8 8d fe ff ff       	call   800250 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003c3:	ff 45 f0             	incl   -0x10(%ebp)
  8003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cc:	0f 8c 2f ff ff ff    	jl     800301 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003d2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003e0:	eb 26                	jmp    800408 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e7:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8003ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f0:	89 d0                	mov    %edx,%eax
  8003f2:	01 c0                	add    %eax,%eax
  8003f4:	01 d0                	add    %edx,%eax
  8003f6:	c1 e0 03             	shl    $0x3,%eax
  8003f9:	01 c8                	add    %ecx,%eax
  8003fb:	8a 40 04             	mov    0x4(%eax),%al
  8003fe:	3c 01                	cmp    $0x1,%al
  800400:	75 03                	jne    800405 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800402:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	ff 45 e0             	incl   -0x20(%ebp)
  800408:	a1 20 50 80 00       	mov    0x805020,%eax
  80040d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800416:	39 c2                	cmp    %eax,%edx
  800418:	77 c8                	ja     8003e2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800420:	74 14                	je     800436 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800422:	83 ec 04             	sub    $0x4,%esp
  800425:	68 90 3d 80 00       	push   $0x803d90
  80042a:	6a 44                	push   $0x44
  80042c:	68 30 3d 80 00       	push   $0x803d30
  800431:	e8 1a fe ff ff       	call   800250 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800436:	90                   	nop
  800437:	c9                   	leave  
  800438:	c3                   	ret    

00800439 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80043f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	8d 48 01             	lea    0x1(%eax),%ecx
  800447:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044a:	89 0a                	mov    %ecx,(%edx)
  80044c:	8b 55 08             	mov    0x8(%ebp),%edx
  80044f:	88 d1                	mov    %dl,%cl
  800451:	8b 55 0c             	mov    0xc(%ebp),%edx
  800454:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800462:	75 2c                	jne    800490 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800464:	a0 28 50 80 00       	mov    0x805028,%al
  800469:	0f b6 c0             	movzbl %al,%eax
  80046c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046f:	8b 12                	mov    (%edx),%edx
  800471:	89 d1                	mov    %edx,%ecx
  800473:	8b 55 0c             	mov    0xc(%ebp),%edx
  800476:	83 c2 08             	add    $0x8,%edx
  800479:	83 ec 04             	sub    $0x4,%esp
  80047c:	50                   	push   %eax
  80047d:	51                   	push   %ecx
  80047e:	52                   	push   %edx
  80047f:	e8 81 13 00 00       	call   801805 <sys_cputs>
  800484:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800490:	8b 45 0c             	mov    0xc(%ebp),%eax
  800493:	8b 40 04             	mov    0x4(%eax),%eax
  800496:	8d 50 01             	lea    0x1(%eax),%edx
  800499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80049f:	90                   	nop
  8004a0:	c9                   	leave  
  8004a1:	c3                   	ret    

008004a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004b2:	00 00 00 
	b.cnt = 0;
  8004b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004bf:	ff 75 0c             	pushl  0xc(%ebp)
  8004c2:	ff 75 08             	pushl  0x8(%ebp)
  8004c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004cb:	50                   	push   %eax
  8004cc:	68 39 04 80 00       	push   $0x800439
  8004d1:	e8 11 02 00 00       	call   8006e7 <vprintfmt>
  8004d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004d9:	a0 28 50 80 00       	mov    0x805028,%al
  8004de:	0f b6 c0             	movzbl %al,%eax
  8004e1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004e7:	83 ec 04             	sub    $0x4,%esp
  8004ea:	50                   	push   %eax
  8004eb:	52                   	push   %edx
  8004ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f2:	83 c0 08             	add    $0x8,%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 0a 13 00 00       	call   801805 <sys_cputs>
  8004fb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004fe:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800505:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    

0080050d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800513:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  80051a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80051d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	83 ec 08             	sub    $0x8,%esp
  800526:	ff 75 f4             	pushl  -0xc(%ebp)
  800529:	50                   	push   %eax
  80052a:	e8 73 ff ff ff       	call   8004a2 <vcprintf>
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800535:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800538:	c9                   	leave  
  800539:	c3                   	ret    

0080053a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80053a:	55                   	push   %ebp
  80053b:	89 e5                	mov    %esp,%ebp
  80053d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800540:	e8 02 13 00 00       	call   801847 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800545:	8d 45 0c             	lea    0xc(%ebp),%eax
  800548:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80054b:	8b 45 08             	mov    0x8(%ebp),%eax
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	ff 75 f4             	pushl  -0xc(%ebp)
  800554:	50                   	push   %eax
  800555:	e8 48 ff ff ff       	call   8004a2 <vcprintf>
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800560:	e8 fc 12 00 00       	call   801861 <sys_unlock_cons>
	return cnt;
  800565:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	53                   	push   %ebx
  80056e:	83 ec 14             	sub    $0x14,%esp
  800571:	8b 45 10             	mov    0x10(%ebp),%eax
  800574:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057d:	8b 45 18             	mov    0x18(%ebp),%eax
  800580:	ba 00 00 00 00       	mov    $0x0,%edx
  800585:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800588:	77 55                	ja     8005df <printnum+0x75>
  80058a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058d:	72 05                	jb     800594 <printnum+0x2a>
  80058f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800592:	77 4b                	ja     8005df <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800594:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800597:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80059a:	8b 45 18             	mov    0x18(%ebp),%eax
  80059d:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a2:	52                   	push   %edx
  8005a3:	50                   	push   %eax
  8005a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8005aa:	e8 bd 32 00 00       	call   80386c <__udivdi3>
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	83 ec 04             	sub    $0x4,%esp
  8005b5:	ff 75 20             	pushl  0x20(%ebp)
  8005b8:	53                   	push   %ebx
  8005b9:	ff 75 18             	pushl  0x18(%ebp)
  8005bc:	52                   	push   %edx
  8005bd:	50                   	push   %eax
  8005be:	ff 75 0c             	pushl  0xc(%ebp)
  8005c1:	ff 75 08             	pushl  0x8(%ebp)
  8005c4:	e8 a1 ff ff ff       	call   80056a <printnum>
  8005c9:	83 c4 20             	add    $0x20,%esp
  8005cc:	eb 1a                	jmp    8005e8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	ff 75 0c             	pushl  0xc(%ebp)
  8005d4:	ff 75 20             	pushl  0x20(%ebp)
  8005d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005da:	ff d0                	call   *%eax
  8005dc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005df:	ff 4d 1c             	decl   0x1c(%ebp)
  8005e2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005e6:	7f e6                	jg     8005ce <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005e8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f6:	53                   	push   %ebx
  8005f7:	51                   	push   %ecx
  8005f8:	52                   	push   %edx
  8005f9:	50                   	push   %eax
  8005fa:	e8 7d 33 00 00       	call   80397c <__umoddi3>
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	05 f4 3f 80 00       	add    $0x803ff4,%eax
  800607:	8a 00                	mov    (%eax),%al
  800609:	0f be c0             	movsbl %al,%eax
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	ff 75 0c             	pushl  0xc(%ebp)
  800612:	50                   	push   %eax
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	ff d0                	call   *%eax
  800618:	83 c4 10             	add    $0x10,%esp
}
  80061b:	90                   	nop
  80061c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80061f:	c9                   	leave  
  800620:	c3                   	ret    

00800621 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800621:	55                   	push   %ebp
  800622:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800624:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800628:	7e 1c                	jle    800646 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	8d 50 08             	lea    0x8(%eax),%edx
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	89 10                	mov    %edx,(%eax)
  800637:	8b 45 08             	mov    0x8(%ebp),%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	83 e8 08             	sub    $0x8,%eax
  80063f:	8b 50 04             	mov    0x4(%eax),%edx
  800642:	8b 00                	mov    (%eax),%eax
  800644:	eb 40                	jmp    800686 <getuint+0x65>
	else if (lflag)
  800646:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80064a:	74 1e                	je     80066a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	8d 50 04             	lea    0x4(%eax),%edx
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	89 10                	mov    %edx,(%eax)
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	83 e8 04             	sub    $0x4,%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	ba 00 00 00 00       	mov    $0x0,%edx
  800668:	eb 1c                	jmp    800686 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	8d 50 04             	lea    0x4(%eax),%edx
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	89 10                	mov    %edx,(%eax)
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	83 e8 04             	sub    $0x4,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800686:	5d                   	pop    %ebp
  800687:	c3                   	ret    

00800688 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80068b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068f:	7e 1c                	jle    8006ad <getint+0x25>
		return va_arg(*ap, long long);
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	8d 50 08             	lea    0x8(%eax),%edx
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	89 10                	mov    %edx,(%eax)
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	83 e8 08             	sub    $0x8,%eax
  8006a6:	8b 50 04             	mov    0x4(%eax),%edx
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	eb 38                	jmp    8006e5 <getint+0x5d>
	else if (lflag)
  8006ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b1:	74 1a                	je     8006cd <getint+0x45>
		return va_arg(*ap, long);
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	8d 50 04             	lea    0x4(%eax),%edx
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	89 10                	mov    %edx,(%eax)
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	83 e8 04             	sub    $0x4,%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	99                   	cltd   
  8006cb:	eb 18                	jmp    8006e5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	8d 50 04             	lea    0x4(%eax),%edx
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	89 10                	mov    %edx,(%eax)
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	83 e8 04             	sub    $0x4,%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	99                   	cltd   
}
  8006e5:	5d                   	pop    %ebp
  8006e6:	c3                   	ret    

008006e7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e7:	55                   	push   %ebp
  8006e8:	89 e5                	mov    %esp,%ebp
  8006ea:	56                   	push   %esi
  8006eb:	53                   	push   %ebx
  8006ec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ef:	eb 17                	jmp    800708 <vprintfmt+0x21>
			if (ch == '\0')
  8006f1:	85 db                	test   %ebx,%ebx
  8006f3:	0f 84 c1 03 00 00    	je     800aba <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	ff 75 0c             	pushl  0xc(%ebp)
  8006ff:	53                   	push   %ebx
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	ff d0                	call   *%eax
  800705:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800708:	8b 45 10             	mov    0x10(%ebp),%eax
  80070b:	8d 50 01             	lea    0x1(%eax),%edx
  80070e:	89 55 10             	mov    %edx,0x10(%ebp)
  800711:	8a 00                	mov    (%eax),%al
  800713:	0f b6 d8             	movzbl %al,%ebx
  800716:	83 fb 25             	cmp    $0x25,%ebx
  800719:	75 d6                	jne    8006f1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80071b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80071f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800726:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80072d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800734:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073b:	8b 45 10             	mov    0x10(%ebp),%eax
  80073e:	8d 50 01             	lea    0x1(%eax),%edx
  800741:	89 55 10             	mov    %edx,0x10(%ebp)
  800744:	8a 00                	mov    (%eax),%al
  800746:	0f b6 d8             	movzbl %al,%ebx
  800749:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80074c:	83 f8 5b             	cmp    $0x5b,%eax
  80074f:	0f 87 3d 03 00 00    	ja     800a92 <vprintfmt+0x3ab>
  800755:	8b 04 85 18 40 80 00 	mov    0x804018(,%eax,4),%eax
  80075c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80075e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800762:	eb d7                	jmp    80073b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800764:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800768:	eb d1                	jmp    80073b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80076a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800771:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800774:	89 d0                	mov    %edx,%eax
  800776:	c1 e0 02             	shl    $0x2,%eax
  800779:	01 d0                	add    %edx,%eax
  80077b:	01 c0                	add    %eax,%eax
  80077d:	01 d8                	add    %ebx,%eax
  80077f:	83 e8 30             	sub    $0x30,%eax
  800782:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800785:	8b 45 10             	mov    0x10(%ebp),%eax
  800788:	8a 00                	mov    (%eax),%al
  80078a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80078d:	83 fb 2f             	cmp    $0x2f,%ebx
  800790:	7e 3e                	jle    8007d0 <vprintfmt+0xe9>
  800792:	83 fb 39             	cmp    $0x39,%ebx
  800795:	7f 39                	jg     8007d0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800797:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80079a:	eb d5                	jmp    800771 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	83 c0 04             	add    $0x4,%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	83 e8 04             	sub    $0x4,%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007b0:	eb 1f                	jmp    8007d1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b6:	79 83                	jns    80073b <vprintfmt+0x54>
				width = 0;
  8007b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007bf:	e9 77 ff ff ff       	jmp    80073b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007c4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007cb:	e9 6b ff ff ff       	jmp    80073b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007d0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d5:	0f 89 60 ff ff ff    	jns    80073b <vprintfmt+0x54>
				width = precision, precision = -1;
  8007db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007e8:	e9 4e ff ff ff       	jmp    80073b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ed:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007f0:	e9 46 ff ff ff       	jmp    80073b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 c0 04             	add    $0x4,%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 0c             	pushl  0xc(%ebp)
  80080c:	50                   	push   %eax
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	ff d0                	call   *%eax
  800812:	83 c4 10             	add    $0x10,%esp
			break;
  800815:	e9 9b 02 00 00       	jmp    800ab5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 c0 04             	add    $0x4,%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	83 e8 04             	sub    $0x4,%eax
  800829:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80082b:	85 db                	test   %ebx,%ebx
  80082d:	79 02                	jns    800831 <vprintfmt+0x14a>
				err = -err;
  80082f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800831:	83 fb 64             	cmp    $0x64,%ebx
  800834:	7f 0b                	jg     800841 <vprintfmt+0x15a>
  800836:	8b 34 9d 60 3e 80 00 	mov    0x803e60(,%ebx,4),%esi
  80083d:	85 f6                	test   %esi,%esi
  80083f:	75 19                	jne    80085a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800841:	53                   	push   %ebx
  800842:	68 05 40 80 00       	push   $0x804005
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	ff 75 08             	pushl  0x8(%ebp)
  80084d:	e8 70 02 00 00       	call   800ac2 <printfmt>
  800852:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800855:	e9 5b 02 00 00       	jmp    800ab5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80085a:	56                   	push   %esi
  80085b:	68 0e 40 80 00       	push   $0x80400e
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	ff 75 08             	pushl  0x8(%ebp)
  800866:	e8 57 02 00 00       	call   800ac2 <printfmt>
  80086b:	83 c4 10             	add    $0x10,%esp
			break;
  80086e:	e9 42 02 00 00       	jmp    800ab5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 c0 04             	add    $0x4,%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	83 e8 04             	sub    $0x4,%eax
  800882:	8b 30                	mov    (%eax),%esi
  800884:	85 f6                	test   %esi,%esi
  800886:	75 05                	jne    80088d <vprintfmt+0x1a6>
				p = "(null)";
  800888:	be 11 40 80 00       	mov    $0x804011,%esi
			if (width > 0 && padc != '-')
  80088d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800891:	7e 6d                	jle    800900 <vprintfmt+0x219>
  800893:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800897:	74 67                	je     800900 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800899:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	50                   	push   %eax
  8008a0:	56                   	push   %esi
  8008a1:	e8 1e 03 00 00       	call   800bc4 <strnlen>
  8008a6:	83 c4 10             	add    $0x10,%esp
  8008a9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ac:	eb 16                	jmp    8008c4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008ae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	50                   	push   %eax
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	ff d0                	call   *%eax
  8008be:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c8:	7f e4                	jg     8008ae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ca:	eb 34                	jmp    800900 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008d0:	74 1c                	je     8008ee <vprintfmt+0x207>
  8008d2:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d5:	7e 05                	jle    8008dc <vprintfmt+0x1f5>
  8008d7:	83 fb 7e             	cmp    $0x7e,%ebx
  8008da:	7e 12                	jle    8008ee <vprintfmt+0x207>
					putch('?', putdat);
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 0c             	pushl  0xc(%ebp)
  8008e2:	6a 3f                	push   $0x3f
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
  8008ec:	eb 0f                	jmp    8008fd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	53                   	push   %ebx
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	ff d0                	call   *%eax
  8008fa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008fd:	ff 4d e4             	decl   -0x1c(%ebp)
  800900:	89 f0                	mov    %esi,%eax
  800902:	8d 70 01             	lea    0x1(%eax),%esi
  800905:	8a 00                	mov    (%eax),%al
  800907:	0f be d8             	movsbl %al,%ebx
  80090a:	85 db                	test   %ebx,%ebx
  80090c:	74 24                	je     800932 <vprintfmt+0x24b>
  80090e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800912:	78 b8                	js     8008cc <vprintfmt+0x1e5>
  800914:	ff 4d e0             	decl   -0x20(%ebp)
  800917:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091b:	79 af                	jns    8008cc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091d:	eb 13                	jmp    800932 <vprintfmt+0x24b>
				putch(' ', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	6a 20                	push   $0x20
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80092f:	ff 4d e4             	decl   -0x1c(%ebp)
  800932:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800936:	7f e7                	jg     80091f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800938:	e9 78 01 00 00       	jmp    800ab5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 e8             	pushl  -0x18(%ebp)
  800943:	8d 45 14             	lea    0x14(%ebp),%eax
  800946:	50                   	push   %eax
  800947:	e8 3c fd ff ff       	call   800688 <getint>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800952:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800958:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095b:	85 d2                	test   %edx,%edx
  80095d:	79 23                	jns    800982 <vprintfmt+0x29b>
				putch('-', putdat);
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	ff 75 0c             	pushl  0xc(%ebp)
  800965:	6a 2d                	push   $0x2d
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	ff d0                	call   *%eax
  80096c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80096f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800972:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800975:	f7 d8                	neg    %eax
  800977:	83 d2 00             	adc    $0x0,%edx
  80097a:	f7 da                	neg    %edx
  80097c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800982:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800989:	e9 bc 00 00 00       	jmp    800a4a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 e8             	pushl  -0x18(%ebp)
  800994:	8d 45 14             	lea    0x14(%ebp),%eax
  800997:	50                   	push   %eax
  800998:	e8 84 fc ff ff       	call   800621 <getuint>
  80099d:	83 c4 10             	add    $0x10,%esp
  8009a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ad:	e9 98 00 00 00       	jmp    800a4a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	6a 58                	push   $0x58
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	ff d0                	call   *%eax
  8009bf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	6a 58                	push   $0x58
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	6a 58                	push   $0x58
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	ff d0                	call   *%eax
  8009df:	83 c4 10             	add    $0x10,%esp
			break;
  8009e2:	e9 ce 00 00 00       	jmp    800ab5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	6a 30                	push   $0x30
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009f7:	83 ec 08             	sub    $0x8,%esp
  8009fa:	ff 75 0c             	pushl  0xc(%ebp)
  8009fd:	6a 78                	push   $0x78
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	ff d0                	call   *%eax
  800a04:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	83 c0 04             	add    $0x4,%eax
  800a0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	83 e8 04             	sub    $0x4,%eax
  800a16:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a22:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a29:	eb 1f                	jmp    800a4a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a31:	8d 45 14             	lea    0x14(%ebp),%eax
  800a34:	50                   	push   %eax
  800a35:	e8 e7 fb ff ff       	call   800621 <getuint>
  800a3a:	83 c4 10             	add    $0x10,%esp
  800a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a43:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a4a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a51:	83 ec 04             	sub    $0x4,%esp
  800a54:	52                   	push   %edx
  800a55:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a58:	50                   	push   %eax
  800a59:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	ff 75 08             	pushl  0x8(%ebp)
  800a65:	e8 00 fb ff ff       	call   80056a <printnum>
  800a6a:	83 c4 20             	add    $0x20,%esp
			break;
  800a6d:	eb 46                	jmp    800ab5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	53                   	push   %ebx
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
			break;
  800a7e:	eb 35                	jmp    800ab5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a80:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800a87:	eb 2c                	jmp    800ab5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a89:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800a90:	eb 23                	jmp    800ab5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	6a 25                	push   $0x25
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	ff d0                	call   *%eax
  800a9f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa2:	ff 4d 10             	decl   0x10(%ebp)
  800aa5:	eb 03                	jmp    800aaa <vprintfmt+0x3c3>
  800aa7:	ff 4d 10             	decl   0x10(%ebp)
  800aaa:	8b 45 10             	mov    0x10(%ebp),%eax
  800aad:	48                   	dec    %eax
  800aae:	8a 00                	mov    (%eax),%al
  800ab0:	3c 25                	cmp    $0x25,%al
  800ab2:	75 f3                	jne    800aa7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ab4:	90                   	nop
		}
	}
  800ab5:	e9 35 fc ff ff       	jmp    8006ef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aba:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800abb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800abe:	5b                   	pop    %ebx
  800abf:	5e                   	pop    %esi
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ac8:	8d 45 10             	lea    0x10(%ebp),%eax
  800acb:	83 c0 04             	add    $0x4,%eax
  800ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	ff 75 08             	pushl  0x8(%ebp)
  800ade:	e8 04 fc ff ff       	call   8006e7 <vprintfmt>
  800ae3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ae6:	90                   	nop
  800ae7:	c9                   	leave  
  800ae8:	c3                   	ret    

00800ae9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aef:	8b 40 08             	mov    0x8(%eax),%eax
  800af2:	8d 50 01             	lea    0x1(%eax),%edx
  800af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	8b 10                	mov    (%eax),%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 40 04             	mov    0x4(%eax),%eax
  800b06:	39 c2                	cmp    %eax,%edx
  800b08:	73 12                	jae    800b1c <sprintputch+0x33>
		*b->buf++ = ch;
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	8b 00                	mov    (%eax),%eax
  800b0f:	8d 48 01             	lea    0x1(%eax),%ecx
  800b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b15:	89 0a                	mov    %ecx,(%edx)
  800b17:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1a:	88 10                	mov    %dl,(%eax)
}
  800b1c:	90                   	nop
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	01 d0                	add    %edx,%eax
  800b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b44:	74 06                	je     800b4c <vsnprintf+0x2d>
  800b46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4a:	7f 07                	jg     800b53 <vsnprintf+0x34>
		return -E_INVAL;
  800b4c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b51:	eb 20                	jmp    800b73 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b53:	ff 75 14             	pushl  0x14(%ebp)
  800b56:	ff 75 10             	pushl  0x10(%ebp)
  800b59:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b5c:	50                   	push   %eax
  800b5d:	68 e9 0a 80 00       	push   $0x800ae9
  800b62:	e8 80 fb ff ff       	call   8006e7 <vprintfmt>
  800b67:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b6d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b73:	c9                   	leave  
  800b74:	c3                   	ret    

00800b75 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b7e:	83 c0 04             	add    $0x4,%eax
  800b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8a:	50                   	push   %eax
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	ff 75 08             	pushl  0x8(%ebp)
  800b91:	e8 89 ff ff ff       	call   800b1f <vsnprintf>
  800b96:	83 c4 10             	add    $0x10,%esp
  800b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b9f:	c9                   	leave  
  800ba0:	c3                   	ret    

00800ba1 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bae:	eb 06                	jmp    800bb6 <strlen+0x15>
		n++;
  800bb0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb3:	ff 45 08             	incl   0x8(%ebp)
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	8a 00                	mov    (%eax),%al
  800bbb:	84 c0                	test   %al,%al
  800bbd:	75 f1                	jne    800bb0 <strlen+0xf>
		n++;
	return n;
  800bbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd1:	eb 09                	jmp    800bdc <strnlen+0x18>
		n++;
  800bd3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	ff 45 08             	incl   0x8(%ebp)
  800bd9:	ff 4d 0c             	decl   0xc(%ebp)
  800bdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be0:	74 09                	je     800beb <strnlen+0x27>
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	8a 00                	mov    (%eax),%al
  800be7:	84 c0                	test   %al,%al
  800be9:	75 e8                	jne    800bd3 <strnlen+0xf>
		n++;
	return n;
  800beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bee:	c9                   	leave  
  800bef:	c3                   	ret    

00800bf0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bfc:	90                   	nop
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8d 50 01             	lea    0x1(%eax),%edx
  800c03:	89 55 08             	mov    %edx,0x8(%ebp)
  800c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c0f:	8a 12                	mov    (%edx),%dl
  800c11:	88 10                	mov    %dl,(%eax)
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	84 c0                	test   %al,%al
  800c17:	75 e4                	jne    800bfd <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1c:	c9                   	leave  
  800c1d:	c3                   	ret    

00800c1e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c31:	eb 1f                	jmp    800c52 <strncpy+0x34>
		*dst++ = *src;
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8d 50 01             	lea    0x1(%eax),%edx
  800c39:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3f:	8a 12                	mov    (%edx),%dl
  800c41:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c46:	8a 00                	mov    (%eax),%al
  800c48:	84 c0                	test   %al,%al
  800c4a:	74 03                	je     800c4f <strncpy+0x31>
			src++;
  800c4c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c4f:	ff 45 fc             	incl   -0x4(%ebp)
  800c52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c55:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c58:	72 d9                	jb     800c33 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6f:	74 30                	je     800ca1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c71:	eb 16                	jmp    800c89 <strlcpy+0x2a>
			*dst++ = *src++;
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8d 50 01             	lea    0x1(%eax),%edx
  800c79:	89 55 08             	mov    %edx,0x8(%ebp)
  800c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c82:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c85:	8a 12                	mov    (%edx),%dl
  800c87:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c89:	ff 4d 10             	decl   0x10(%ebp)
  800c8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c90:	74 09                	je     800c9b <strlcpy+0x3c>
  800c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c95:	8a 00                	mov    (%eax),%al
  800c97:	84 c0                	test   %al,%al
  800c99:	75 d8                	jne    800c73 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca7:	29 c2                	sub    %eax,%edx
  800ca9:	89 d0                	mov    %edx,%eax
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb0:	eb 06                	jmp    800cb8 <strcmp+0xb>
		p++, q++;
  800cb2:	ff 45 08             	incl   0x8(%ebp)
  800cb5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	84 c0                	test   %al,%al
  800cbf:	74 0e                	je     800ccf <strcmp+0x22>
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8a 10                	mov    (%eax),%dl
  800cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	38 c2                	cmp    %al,%dl
  800ccd:	74 e3                	je     800cb2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	0f b6 d0             	movzbl %al,%edx
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	0f b6 c0             	movzbl %al,%eax
  800cdf:	29 c2                	sub    %eax,%edx
  800ce1:	89 d0                	mov    %edx,%eax
}
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ce8:	eb 09                	jmp    800cf3 <strncmp+0xe>
		n--, p++, q++;
  800cea:	ff 4d 10             	decl   0x10(%ebp)
  800ced:	ff 45 08             	incl   0x8(%ebp)
  800cf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf7:	74 17                	je     800d10 <strncmp+0x2b>
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	84 c0                	test   %al,%al
  800d00:	74 0e                	je     800d10 <strncmp+0x2b>
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 10                	mov    (%eax),%dl
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	38 c2                	cmp    %al,%dl
  800d0e:	74 da                	je     800cea <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d14:	75 07                	jne    800d1d <strncmp+0x38>
		return 0;
  800d16:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1b:	eb 14                	jmp    800d31 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	0f b6 d0             	movzbl %al,%edx
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	0f b6 c0             	movzbl %al,%eax
  800d2d:	29 c2                	sub    %eax,%edx
  800d2f:	89 d0                	mov    %edx,%eax
}
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d3f:	eb 12                	jmp    800d53 <strchr+0x20>
		if (*s == c)
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d49:	75 05                	jne    800d50 <strchr+0x1d>
			return (char *) s;
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	eb 11                	jmp    800d61 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	84 c0                	test   %al,%al
  800d5a:	75 e5                	jne    800d41 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d61:	c9                   	leave  
  800d62:	c3                   	ret    

00800d63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 04             	sub    $0x4,%esp
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d6f:	eb 0d                	jmp    800d7e <strfind+0x1b>
		if (*s == c)
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d79:	74 0e                	je     800d89 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d7b:	ff 45 08             	incl   0x8(%ebp)
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	84 c0                	test   %al,%al
  800d85:	75 ea                	jne    800d71 <strfind+0xe>
  800d87:	eb 01                	jmp    800d8a <strfind+0x27>
		if (*s == c)
			break;
  800d89:	90                   	nop
	return (char *) s;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8d:	c9                   	leave  
  800d8e:	c3                   	ret    

00800d8f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da1:	eb 0e                	jmp    800db1 <memset+0x22>
		*p++ = c;
  800da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da6:	8d 50 01             	lea    0x1(%eax),%edx
  800da9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800daf:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db1:	ff 4d f8             	decl   -0x8(%ebp)
  800db4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800db8:	79 e9                	jns    800da3 <memset+0x14>
		*p++ = c;

	return v;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd1:	eb 16                	jmp    800de9 <memcpy+0x2a>
		*d++ = *s++;
  800dd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd6:	8d 50 01             	lea    0x1(%eax),%edx
  800dd9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ddc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ddf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de5:	8a 12                	mov    (%edx),%dl
  800de7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800de9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dec:	8d 50 ff             	lea    -0x1(%eax),%edx
  800def:	89 55 10             	mov    %edx,0x10(%ebp)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	75 dd                	jne    800dd3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df9:	c9                   	leave  
  800dfa:	c3                   	ret    

00800dfb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e10:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e13:	73 50                	jae    800e65 <memmove+0x6a>
  800e15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	01 d0                	add    %edx,%eax
  800e1d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e20:	76 43                	jbe    800e65 <memmove+0x6a>
		s += n;
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e2e:	eb 10                	jmp    800e40 <memmove+0x45>
			*--d = *--s;
  800e30:	ff 4d f8             	decl   -0x8(%ebp)
  800e33:	ff 4d fc             	decl   -0x4(%ebp)
  800e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e39:	8a 10                	mov    (%eax),%dl
  800e3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e40:	8b 45 10             	mov    0x10(%ebp),%eax
  800e43:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e46:	89 55 10             	mov    %edx,0x10(%ebp)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	75 e3                	jne    800e30 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e4d:	eb 23                	jmp    800e72 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	8d 50 01             	lea    0x1(%eax),%edx
  800e55:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e61:	8a 12                	mov    (%edx),%dl
  800e63:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 dd                	jne    800e4f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e86:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e89:	eb 2a                	jmp    800eb5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8e:	8a 10                	mov    (%eax),%dl
  800e90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	38 c2                	cmp    %al,%dl
  800e97:	74 16                	je     800eaf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	0f b6 d0             	movzbl %al,%edx
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	0f b6 c0             	movzbl %al,%eax
  800ea9:	29 c2                	sub    %eax,%edx
  800eab:	89 d0                	mov    %edx,%eax
  800ead:	eb 18                	jmp    800ec7 <memcmp+0x50>
		s1++, s2++;
  800eaf:	ff 45 fc             	incl   -0x4(%ebp)
  800eb2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	75 c9                	jne    800e8b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 d0                	add    %edx,%eax
  800ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eda:	eb 15                	jmp    800ef1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	0f b6 d0             	movzbl %al,%edx
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	0f b6 c0             	movzbl %al,%eax
  800eea:	39 c2                	cmp    %eax,%edx
  800eec:	74 0d                	je     800efb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef7:	72 e3                	jb     800edc <memfind+0x13>
  800ef9:	eb 01                	jmp    800efc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800efb:	90                   	nop
	return (void *) s;
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eff:	c9                   	leave  
  800f00:	c3                   	ret    

00800f01 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f0e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f15:	eb 03                	jmp    800f1a <strtol+0x19>
		s++;
  800f17:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	3c 20                	cmp    $0x20,%al
  800f21:	74 f4                	je     800f17 <strtol+0x16>
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3c 09                	cmp    $0x9,%al
  800f2a:	74 eb                	je     800f17 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	3c 2b                	cmp    $0x2b,%al
  800f33:	75 05                	jne    800f3a <strtol+0x39>
		s++;
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	eb 13                	jmp    800f4d <strtol+0x4c>
	else if (*s == '-')
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 2d                	cmp    $0x2d,%al
  800f41:	75 0a                	jne    800f4d <strtol+0x4c>
		s++, neg = 1;
  800f43:	ff 45 08             	incl   0x8(%ebp)
  800f46:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f51:	74 06                	je     800f59 <strtol+0x58>
  800f53:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f57:	75 20                	jne    800f79 <strtol+0x78>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 30                	cmp    $0x30,%al
  800f60:	75 17                	jne    800f79 <strtol+0x78>
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	40                   	inc    %eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	3c 78                	cmp    $0x78,%al
  800f6a:	75 0d                	jne    800f79 <strtol+0x78>
		s += 2, base = 16;
  800f6c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f70:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f77:	eb 28                	jmp    800fa1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7d:	75 15                	jne    800f94 <strtol+0x93>
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	3c 30                	cmp    $0x30,%al
  800f86:	75 0c                	jne    800f94 <strtol+0x93>
		s++, base = 8;
  800f88:	ff 45 08             	incl   0x8(%ebp)
  800f8b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f92:	eb 0d                	jmp    800fa1 <strtol+0xa0>
	else if (base == 0)
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	75 07                	jne    800fa1 <strtol+0xa0>
		base = 10;
  800f9a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 2f                	cmp    $0x2f,%al
  800fa8:	7e 19                	jle    800fc3 <strtol+0xc2>
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 39                	cmp    $0x39,%al
  800fb1:	7f 10                	jg     800fc3 <strtol+0xc2>
			dig = *s - '0';
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f be c0             	movsbl %al,%eax
  800fbb:	83 e8 30             	sub    $0x30,%eax
  800fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc1:	eb 42                	jmp    801005 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	3c 60                	cmp    $0x60,%al
  800fca:	7e 19                	jle    800fe5 <strtol+0xe4>
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	3c 7a                	cmp    $0x7a,%al
  800fd3:	7f 10                	jg     800fe5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	0f be c0             	movsbl %al,%eax
  800fdd:	83 e8 57             	sub    $0x57,%eax
  800fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe3:	eb 20                	jmp    801005 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3c 40                	cmp    $0x40,%al
  800fec:	7e 39                	jle    801027 <strtol+0x126>
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3c 5a                	cmp    $0x5a,%al
  800ff5:	7f 30                	jg     801027 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	0f be c0             	movsbl %al,%eax
  800fff:	83 e8 37             	sub    $0x37,%eax
  801002:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801008:	3b 45 10             	cmp    0x10(%ebp),%eax
  80100b:	7d 19                	jge    801026 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801013:	0f af 45 10          	imul   0x10(%ebp),%eax
  801017:	89 c2                	mov    %eax,%edx
  801019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101c:	01 d0                	add    %edx,%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801021:	e9 7b ff ff ff       	jmp    800fa1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801026:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801027:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102b:	74 08                	je     801035 <strtol+0x134>
		*endptr = (char *) s;
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801035:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801039:	74 07                	je     801042 <strtol+0x141>
  80103b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103e:	f7 d8                	neg    %eax
  801040:	eb 03                	jmp    801045 <strtol+0x144>
  801042:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <ltostr>:

void
ltostr(long value, char *str)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80104d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801054:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80105b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80105f:	79 13                	jns    801074 <ltostr+0x2d>
	{
		neg = 1;
  801061:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80106e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801071:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80107c:	99                   	cltd   
  80107d:	f7 f9                	idiv   %ecx
  80107f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108b:	89 c2                	mov    %eax,%edx
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	01 d0                	add    %edx,%eax
  801092:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801095:	83 c2 30             	add    $0x30,%edx
  801098:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80109a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a2:	f7 e9                	imul   %ecx
  8010a4:	c1 fa 02             	sar    $0x2,%edx
  8010a7:	89 c8                	mov    %ecx,%eax
  8010a9:	c1 f8 1f             	sar    $0x1f,%eax
  8010ac:	29 c2                	sub    %eax,%edx
  8010ae:	89 d0                	mov    %edx,%eax
  8010b0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b7:	75 bb                	jne    801074 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c3:	48                   	dec    %eax
  8010c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010cb:	74 3d                	je     80110a <ltostr+0xc3>
		start = 1 ;
  8010cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010d4:	eb 34                	jmp    80110a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	01 d0                	add    %edx,%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	01 c2                	add    %eax,%edx
  8010ff:	8a 45 eb             	mov    -0x15(%ebp),%al
  801102:	88 02                	mov    %al,(%edx)
		start++ ;
  801104:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801107:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80110a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801110:	7c c4                	jl     8010d6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801112:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801115:	8b 45 0c             	mov    0xc(%ebp),%eax
  801118:	01 d0                	add    %edx,%eax
  80111a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80111d:	90                   	nop
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801126:	ff 75 08             	pushl  0x8(%ebp)
  801129:	e8 73 fa ff ff       	call   800ba1 <strlen>
  80112e:	83 c4 04             	add    $0x4,%esp
  801131:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801134:	ff 75 0c             	pushl  0xc(%ebp)
  801137:	e8 65 fa ff ff       	call   800ba1 <strlen>
  80113c:	83 c4 04             	add    $0x4,%esp
  80113f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801142:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801149:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801150:	eb 17                	jmp    801169 <strcconcat+0x49>
		final[s] = str1[s] ;
  801152:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801155:	8b 45 10             	mov    0x10(%ebp),%eax
  801158:	01 c2                	add    %eax,%edx
  80115a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	01 c8                	add    %ecx,%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801166:	ff 45 fc             	incl   -0x4(%ebp)
  801169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80116f:	7c e1                	jl     801152 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801171:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801178:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80117f:	eb 1f                	jmp    8011a0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801181:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 c2                	add    %eax,%edx
  801191:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	01 c8                	add    %ecx,%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80119d:	ff 45 f8             	incl   -0x8(%ebp)
  8011a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a6:	7c d9                	jl     801181 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	01 d0                	add    %edx,%eax
  8011b0:	c6 00 00             	movb   $0x0,(%eax)
}
  8011b3:	90                   	nop
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    

008011b6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c5:	8b 00                	mov    (%eax),%eax
  8011c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d9:	eb 0c                	jmp    8011e7 <strsplit+0x31>
			*string++ = 0;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8d 50 01             	lea    0x1(%eax),%edx
  8011e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 18                	je     801208 <strsplit+0x52>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	0f be c0             	movsbl %al,%eax
  8011f8:	50                   	push   %eax
  8011f9:	ff 75 0c             	pushl  0xc(%ebp)
  8011fc:	e8 32 fb ff ff       	call   800d33 <strchr>
  801201:	83 c4 08             	add    $0x8,%esp
  801204:	85 c0                	test   %eax,%eax
  801206:	75 d3                	jne    8011db <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	84 c0                	test   %al,%al
  80120f:	74 5a                	je     80126b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801211:	8b 45 14             	mov    0x14(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 f8 0f             	cmp    $0xf,%eax
  801219:	75 07                	jne    801222 <strsplit+0x6c>
		{
			return 0;
  80121b:	b8 00 00 00 00       	mov    $0x0,%eax
  801220:	eb 66                	jmp    801288 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801222:	8b 45 14             	mov    0x14(%ebp),%eax
  801225:	8b 00                	mov    (%eax),%eax
  801227:	8d 48 01             	lea    0x1(%eax),%ecx
  80122a:	8b 55 14             	mov    0x14(%ebp),%edx
  80122d:	89 0a                	mov    %ecx,(%edx)
  80122f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 c2                	add    %eax,%edx
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801240:	eb 03                	jmp    801245 <strsplit+0x8f>
			string++;
  801242:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	84 c0                	test   %al,%al
  80124c:	74 8b                	je     8011d9 <strsplit+0x23>
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	0f be c0             	movsbl %al,%eax
  801256:	50                   	push   %eax
  801257:	ff 75 0c             	pushl  0xc(%ebp)
  80125a:	e8 d4 fa ff ff       	call   800d33 <strchr>
  80125f:	83 c4 08             	add    $0x8,%esp
  801262:	85 c0                	test   %eax,%eax
  801264:	74 dc                	je     801242 <strsplit+0x8c>
			string++;
	}
  801266:	e9 6e ff ff ff       	jmp    8011d9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80126b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	8b 00                	mov    (%eax),%eax
  801271:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801278:	8b 45 10             	mov    0x10(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801283:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	68 88 41 80 00       	push   $0x804188
  801298:	68 3f 01 00 00       	push   $0x13f
  80129d:	68 aa 41 80 00       	push   $0x8041aa
  8012a2:	e8 a9 ef ff ff       	call   800250 <_panic>

008012a7 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	ff 75 08             	pushl  0x8(%ebp)
  8012b3:	e8 f8 0a 00 00       	call   801db0 <sys_sbrk>
  8012b8:	83 c4 10             	add    $0x10,%esp
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8012c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012c7:	75 0a                	jne    8012d3 <malloc+0x16>
  8012c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ce:	e9 07 02 00 00       	jmp    8014da <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8012d3:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8012da:	8b 55 08             	mov    0x8(%ebp),%edx
  8012dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	48                   	dec    %eax
  8012e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8012e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ee:	f7 75 dc             	divl   -0x24(%ebp)
  8012f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012f4:	29 d0                	sub    %edx,%eax
  8012f6:	c1 e8 0c             	shr    $0xc,%eax
  8012f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8012fc:	a1 20 50 80 00       	mov    0x805020,%eax
  801301:	8b 40 78             	mov    0x78(%eax),%eax
  801304:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801309:	29 c2                	sub    %eax,%edx
  80130b:	89 d0                	mov    %edx,%eax
  80130d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801310:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801313:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801318:	c1 e8 0c             	shr    $0xc,%eax
  80131b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  80131e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801325:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80132c:	77 42                	ja     801370 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80132e:	e8 01 09 00 00       	call   801c34 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801333:	85 c0                	test   %eax,%eax
  801335:	74 16                	je     80134d <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801337:	83 ec 0c             	sub    $0xc,%esp
  80133a:	ff 75 08             	pushl  0x8(%ebp)
  80133d:	e8 41 0e 00 00       	call   802183 <alloc_block_FF>
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801348:	e9 8a 01 00 00       	jmp    8014d7 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80134d:	e8 13 09 00 00       	call   801c65 <sys_isUHeapPlacementStrategyBESTFIT>
  801352:	85 c0                	test   %eax,%eax
  801354:	0f 84 7d 01 00 00    	je     8014d7 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80135a:	83 ec 0c             	sub    $0xc,%esp
  80135d:	ff 75 08             	pushl  0x8(%ebp)
  801360:	e8 da 12 00 00       	call   80263f <alloc_block_BF>
  801365:	83 c4 10             	add    $0x10,%esp
  801368:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80136b:	e9 67 01 00 00       	jmp    8014d7 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801370:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801373:	48                   	dec    %eax
  801374:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801377:	0f 86 53 01 00 00    	jbe    8014d0 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  80137d:	a1 20 50 80 00       	mov    0x805020,%eax
  801382:	8b 40 78             	mov    0x78(%eax),%eax
  801385:	05 00 10 00 00       	add    $0x1000,%eax
  80138a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  80138d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801394:	e9 de 00 00 00       	jmp    801477 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801399:	a1 20 50 80 00       	mov    0x805020,%eax
  80139e:	8b 40 78             	mov    0x78(%eax),%eax
  8013a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a4:	29 c2                	sub    %eax,%edx
  8013a6:	89 d0                	mov    %edx,%eax
  8013a8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ad:	c1 e8 0c             	shr    $0xc,%eax
  8013b0:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	0f 85 ab 00 00 00    	jne    80146a <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  8013bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c2:	05 00 10 00 00       	add    $0x1000,%eax
  8013c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8013ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  8013d1:	eb 47                	jmp    80141a <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8013d3:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8013da:	76 0a                	jbe    8013e6 <malloc+0x129>
  8013dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e1:	e9 f4 00 00 00       	jmp    8014da <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8013e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8013eb:	8b 40 78             	mov    0x78(%eax),%eax
  8013ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013f1:	29 c2                	sub    %eax,%edx
  8013f3:	89 d0                	mov    %edx,%eax
  8013f5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013fa:	c1 e8 0c             	shr    $0xc,%eax
  8013fd:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801404:	85 c0                	test   %eax,%eax
  801406:	74 08                	je     801410 <malloc+0x153>
					{
						
						i = j;
  801408:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  80140e:	eb 5a                	jmp    80146a <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801410:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801417:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  80141a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80141d:	48                   	dec    %eax
  80141e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801421:	77 b0                	ja     8013d3 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801423:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  80142a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801431:	eb 2f                	jmp    801462 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	c1 e0 0c             	shl    $0xc,%eax
  801439:	89 c2                	mov    %eax,%edx
  80143b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143e:	01 c2                	add    %eax,%edx
  801440:	a1 20 50 80 00       	mov    0x805020,%eax
  801445:	8b 40 78             	mov    0x78(%eax),%eax
  801448:	29 c2                	sub    %eax,%edx
  80144a:	89 d0                	mov    %edx,%eax
  80144c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801451:	c1 e8 0c             	shr    $0xc,%eax
  801454:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  80145b:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  80145f:	ff 45 e0             	incl   -0x20(%ebp)
  801462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801465:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801468:	72 c9                	jb     801433 <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  80146a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80146e:	75 16                	jne    801486 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801470:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801477:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80147e:	0f 86 15 ff ff ff    	jbe    801399 <malloc+0xdc>
  801484:	eb 01                	jmp    801487 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801486:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801487:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80148b:	75 07                	jne    801494 <malloc+0x1d7>
  80148d:	b8 00 00 00 00       	mov    $0x0,%eax
  801492:	eb 46                	jmp    8014da <malloc+0x21d>
		ptr = (void*)i;
  801494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801497:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  80149a:	a1 20 50 80 00       	mov    0x805020,%eax
  80149f:	8b 40 78             	mov    0x78(%eax),%eax
  8014a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014a5:	29 c2                	sub    %eax,%edx
  8014a7:	89 d0                	mov    %edx,%eax
  8014a9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014ae:	c1 e8 0c             	shr    $0xc,%eax
  8014b1:	89 c2                	mov    %eax,%edx
  8014b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014b6:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	ff 75 08             	pushl  0x8(%ebp)
  8014c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8014c6:	e8 1c 09 00 00       	call   801de7 <sys_allocate_user_mem>
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	eb 07                	jmp    8014d7 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  8014d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d5:	eb 03                	jmp    8014da <malloc+0x21d>
	}
	return ptr;
  8014d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  8014e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8014e7:	8b 40 78             	mov    0x78(%eax),%eax
  8014ea:	05 00 10 00 00       	add    $0x1000,%eax
  8014ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  8014f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  8014f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8014fe:	8b 50 78             	mov    0x78(%eax),%edx
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	39 c2                	cmp    %eax,%edx
  801506:	76 24                	jbe    80152c <free+0x50>
		size = get_block_size(va);
  801508:	83 ec 0c             	sub    $0xc,%esp
  80150b:	ff 75 08             	pushl  0x8(%ebp)
  80150e:	e8 f0 08 00 00       	call   801e03 <get_block_size>
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801519:	83 ec 0c             	sub    $0xc,%esp
  80151c:	ff 75 08             	pushl  0x8(%ebp)
  80151f:	e8 00 1b 00 00       	call   803024 <free_block>
  801524:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801527:	e9 ac 00 00 00       	jmp    8015d8 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801532:	0f 82 89 00 00 00    	jb     8015c1 <free+0xe5>
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801540:	77 7f                	ja     8015c1 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801542:	8b 55 08             	mov    0x8(%ebp),%edx
  801545:	a1 20 50 80 00       	mov    0x805020,%eax
  80154a:	8b 40 78             	mov    0x78(%eax),%eax
  80154d:	29 c2                	sub    %eax,%edx
  80154f:	89 d0                	mov    %edx,%eax
  801551:	2d 00 10 00 00       	sub    $0x1000,%eax
  801556:	c1 e8 0c             	shr    $0xc,%eax
  801559:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801560:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801563:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801566:	c1 e0 0c             	shl    $0xc,%eax
  801569:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80156c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801573:	eb 42                	jmp    8015b7 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801578:	c1 e0 0c             	shl    $0xc,%eax
  80157b:	89 c2                	mov    %eax,%edx
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	01 c2                	add    %eax,%edx
  801582:	a1 20 50 80 00       	mov    0x805020,%eax
  801587:	8b 40 78             	mov    0x78(%eax),%eax
  80158a:	29 c2                	sub    %eax,%edx
  80158c:	89 d0                	mov    %edx,%eax
  80158e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801593:	c1 e8 0c             	shr    $0xc,%eax
  801596:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  80159d:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8015a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	83 ec 08             	sub    $0x8,%esp
  8015aa:	52                   	push   %edx
  8015ab:	50                   	push   %eax
  8015ac:	e8 1a 08 00 00       	call   801dcb <sys_free_user_mem>
  8015b1:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8015b4:	ff 45 f4             	incl   -0xc(%ebp)
  8015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ba:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8015bd:	72 b6                	jb     801575 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8015bf:	eb 17                	jmp    8015d8 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	68 b8 41 80 00       	push   $0x8041b8
  8015c9:	68 87 00 00 00       	push   $0x87
  8015ce:	68 e2 41 80 00       	push   $0x8041e2
  8015d3:	e8 78 ec ff ff       	call   800250 <_panic>
	}
}
  8015d8:	90                   	nop
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 28             	sub    $0x28,%esp
  8015e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e4:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8015e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015eb:	75 0a                	jne    8015f7 <smalloc+0x1c>
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f2:	e9 87 00 00 00       	jmp    80167e <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8015f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015fd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801604:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160a:	39 d0                	cmp    %edx,%eax
  80160c:	73 02                	jae    801610 <smalloc+0x35>
  80160e:	89 d0                	mov    %edx,%eax
  801610:	83 ec 0c             	sub    $0xc,%esp
  801613:	50                   	push   %eax
  801614:	e8 a4 fc ff ff       	call   8012bd <malloc>
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80161f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801623:	75 07                	jne    80162c <smalloc+0x51>
  801625:	b8 00 00 00 00       	mov    $0x0,%eax
  80162a:	eb 52                	jmp    80167e <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80162c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801630:	ff 75 ec             	pushl  -0x14(%ebp)
  801633:	50                   	push   %eax
  801634:	ff 75 0c             	pushl  0xc(%ebp)
  801637:	ff 75 08             	pushl  0x8(%ebp)
  80163a:	e8 93 03 00 00       	call   8019d2 <sys_createSharedObject>
  80163f:	83 c4 10             	add    $0x10,%esp
  801642:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801645:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801649:	74 06                	je     801651 <smalloc+0x76>
  80164b:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80164f:	75 07                	jne    801658 <smalloc+0x7d>
  801651:	b8 00 00 00 00       	mov    $0x0,%eax
  801656:	eb 26                	jmp    80167e <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801658:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80165b:	a1 20 50 80 00       	mov    0x805020,%eax
  801660:	8b 40 78             	mov    0x78(%eax),%eax
  801663:	29 c2                	sub    %eax,%edx
  801665:	89 d0                	mov    %edx,%eax
  801667:	2d 00 10 00 00       	sub    $0x1000,%eax
  80166c:	c1 e8 0c             	shr    $0xc,%eax
  80166f:	89 c2                	mov    %eax,%edx
  801671:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801674:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80167b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801686:	83 ec 08             	sub    $0x8,%esp
  801689:	ff 75 0c             	pushl  0xc(%ebp)
  80168c:	ff 75 08             	pushl  0x8(%ebp)
  80168f:	e8 68 03 00 00       	call   8019fc <sys_getSizeOfSharedObject>
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80169a:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80169e:	75 07                	jne    8016a7 <sget+0x27>
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a5:	eb 7f                	jmp    801726 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ad:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ba:	39 d0                	cmp    %edx,%eax
  8016bc:	73 02                	jae    8016c0 <sget+0x40>
  8016be:	89 d0                	mov    %edx,%eax
  8016c0:	83 ec 0c             	sub    $0xc,%esp
  8016c3:	50                   	push   %eax
  8016c4:	e8 f4 fb ff ff       	call   8012bd <malloc>
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8016cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016d3:	75 07                	jne    8016dc <sget+0x5c>
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	eb 4a                	jmp    801726 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	ff 75 e8             	pushl  -0x18(%ebp)
  8016e2:	ff 75 0c             	pushl  0xc(%ebp)
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	e8 2c 03 00 00       	call   801a19 <sys_getSharedObject>
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8016f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8016fb:	8b 40 78             	mov    0x78(%eax),%eax
  8016fe:	29 c2                	sub    %eax,%edx
  801700:	89 d0                	mov    %edx,%eax
  801702:	2d 00 10 00 00       	sub    $0x1000,%eax
  801707:	c1 e8 0c             	shr    $0xc,%eax
  80170a:	89 c2                	mov    %eax,%edx
  80170c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80170f:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801716:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80171a:	75 07                	jne    801723 <sget+0xa3>
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
  801721:	eb 03                	jmp    801726 <sget+0xa6>
	return ptr;
  801723:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80172e:	8b 55 08             	mov    0x8(%ebp),%edx
  801731:	a1 20 50 80 00       	mov    0x805020,%eax
  801736:	8b 40 78             	mov    0x78(%eax),%eax
  801739:	29 c2                	sub    %eax,%edx
  80173b:	89 d0                	mov    %edx,%eax
  80173d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801742:	c1 e8 0c             	shr    $0xc,%eax
  801745:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80174c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80174f:	83 ec 08             	sub    $0x8,%esp
  801752:	ff 75 08             	pushl  0x8(%ebp)
  801755:	ff 75 f4             	pushl  -0xc(%ebp)
  801758:	e8 db 02 00 00       	call   801a38 <sys_freeSharedObject>
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801763:	90                   	nop
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	68 f0 41 80 00       	push   $0x8041f0
  801774:	68 e4 00 00 00       	push   $0xe4
  801779:	68 e2 41 80 00       	push   $0x8041e2
  80177e:	e8 cd ea ff ff       	call   800250 <_panic>

00801783 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	68 16 42 80 00       	push   $0x804216
  801791:	68 f0 00 00 00       	push   $0xf0
  801796:	68 e2 41 80 00       	push   $0x8041e2
  80179b:	e8 b0 ea ff ff       	call   800250 <_panic>

008017a0 <shrink>:

}
void shrink(uint32 newSize)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	68 16 42 80 00       	push   $0x804216
  8017ae:	68 f5 00 00 00       	push   $0xf5
  8017b3:	68 e2 41 80 00       	push   $0x8041e2
  8017b8:	e8 93 ea ff ff       	call   800250 <_panic>

008017bd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	68 16 42 80 00       	push   $0x804216
  8017cb:	68 fa 00 00 00       	push   $0xfa
  8017d0:	68 e2 41 80 00       	push   $0x8041e2
  8017d5:	e8 76 ea ff ff       	call   800250 <_panic>

008017da <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	57                   	push   %edi
  8017de:	56                   	push   %esi
  8017df:	53                   	push   %ebx
  8017e0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ef:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f5:	cd 30                	int    $0x30
  8017f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	5b                   	pop    %ebx
  801801:	5e                   	pop    %esi
  801802:	5f                   	pop    %edi
  801803:	5d                   	pop    %ebp
  801804:	c3                   	ret    

00801805 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	8b 45 10             	mov    0x10(%ebp),%eax
  80180e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801811:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	52                   	push   %edx
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	50                   	push   %eax
  801821:	6a 00                	push   $0x0
  801823:	e8 b2 ff ff ff       	call   8017da <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	90                   	nop
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_cgetc>:

int
sys_cgetc(void)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 02                	push   $0x2
  80183d:	e8 98 ff ff ff       	call   8017da <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 03                	push   $0x3
  801856:	e8 7f ff ff ff       	call   8017da <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	90                   	nop
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 04                	push   $0x4
  801870:	e8 65 ff ff ff       	call   8017da <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	90                   	nop
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80187e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	52                   	push   %edx
  80188b:	50                   	push   %eax
  80188c:	6a 08                	push   $0x8
  80188e:	e8 47 ff ff ff       	call   8017da <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	56                   	push   %esi
  80189c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80189d:	8b 75 18             	mov    0x18(%ebp),%esi
  8018a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	56                   	push   %esi
  8018ad:	53                   	push   %ebx
  8018ae:	51                   	push   %ecx
  8018af:	52                   	push   %edx
  8018b0:	50                   	push   %eax
  8018b1:	6a 09                	push   $0x9
  8018b3:	e8 22 ff ff ff       	call   8017da <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018be:	5b                   	pop    %ebx
  8018bf:	5e                   	pop    %esi
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    

008018c2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	52                   	push   %edx
  8018d2:	50                   	push   %eax
  8018d3:	6a 0a                	push   $0xa
  8018d5:	e8 00 ff ff ff       	call   8017da <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	ff 75 0c             	pushl  0xc(%ebp)
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	6a 0b                	push   $0xb
  8018f0:	e8 e5 fe ff ff       	call   8017da <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 0c                	push   $0xc
  801909:	e8 cc fe ff ff       	call   8017da <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 0d                	push   $0xd
  801922:	e8 b3 fe ff ff       	call   8017da <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 0e                	push   $0xe
  80193b:	e8 9a fe ff ff       	call   8017da <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 0f                	push   $0xf
  801954:	e8 81 fe ff ff       	call   8017da <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	ff 75 08             	pushl  0x8(%ebp)
  80196c:	6a 10                	push   $0x10
  80196e:	e8 67 fe ff ff       	call   8017da <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 11                	push   $0x11
  801987:	e8 4e fe ff ff       	call   8017da <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	90                   	nop
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_cputc>:

void
sys_cputc(const char c)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80199e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	50                   	push   %eax
  8019ab:	6a 01                	push   $0x1
  8019ad:	e8 28 fe ff ff       	call   8017da <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	90                   	nop
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 14                	push   $0x14
  8019c7:	e8 0e fe ff ff       	call   8017da <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 04             	sub    $0x4,%esp
  8019d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019db:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019de:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	51                   	push   %ecx
  8019eb:	52                   	push   %edx
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	6a 15                	push   $0x15
  8019f2:	e8 e3 fd ff ff       	call   8017da <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	52                   	push   %edx
  801a0c:	50                   	push   %eax
  801a0d:	6a 16                	push   $0x16
  801a0f:	e8 c6 fd ff ff       	call   8017da <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	51                   	push   %ecx
  801a2a:	52                   	push   %edx
  801a2b:	50                   	push   %eax
  801a2c:	6a 17                	push   $0x17
  801a2e:	e8 a7 fd ff ff       	call   8017da <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	52                   	push   %edx
  801a48:	50                   	push   %eax
  801a49:	6a 18                	push   $0x18
  801a4b:	e8 8a fd ff ff       	call   8017da <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	ff 75 14             	pushl  0x14(%ebp)
  801a60:	ff 75 10             	pushl  0x10(%ebp)
  801a63:	ff 75 0c             	pushl  0xc(%ebp)
  801a66:	50                   	push   %eax
  801a67:	6a 19                	push   $0x19
  801a69:	e8 6c fd ff ff       	call   8017da <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	50                   	push   %eax
  801a82:	6a 1a                	push   $0x1a
  801a84:	e8 51 fd ff ff       	call   8017da <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	90                   	nop
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	50                   	push   %eax
  801a9e:	6a 1b                	push   $0x1b
  801aa0:	e8 35 fd ff ff       	call   8017da <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 05                	push   $0x5
  801ab9:	e8 1c fd ff ff       	call   8017da <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 06                	push   $0x6
  801ad2:	e8 03 fd ff ff       	call   8017da <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 07                	push   $0x7
  801aeb:	e8 ea fc ff ff       	call   8017da <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_exit_env>:


void sys_exit_env(void)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 1c                	push   $0x1c
  801b04:	e8 d1 fc ff ff       	call   8017da <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	90                   	nop
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b15:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b18:	8d 50 04             	lea    0x4(%eax),%edx
  801b1b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	52                   	push   %edx
  801b25:	50                   	push   %eax
  801b26:	6a 1d                	push   $0x1d
  801b28:	e8 ad fc ff ff       	call   8017da <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
	return result;
  801b30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b39:	89 01                	mov    %eax,(%ecx)
  801b3b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	c9                   	leave  
  801b42:	c2 04 00             	ret    $0x4

00801b45 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	ff 75 10             	pushl  0x10(%ebp)
  801b4f:	ff 75 0c             	pushl  0xc(%ebp)
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	6a 13                	push   $0x13
  801b57:	e8 7e fc ff ff       	call   8017da <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5f:	90                   	nop
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 1e                	push   $0x1e
  801b71:	e8 64 fc ff ff       	call   8017da <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b87:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	50                   	push   %eax
  801b94:	6a 1f                	push   $0x1f
  801b96:	e8 3f fc ff ff       	call   8017da <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9e:	90                   	nop
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <rsttst>:
void rsttst()
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 21                	push   $0x21
  801bb0:	e8 25 fc ff ff       	call   8017da <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb8:	90                   	nop
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bc7:	8b 55 18             	mov    0x18(%ebp),%edx
  801bca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	ff 75 10             	pushl  0x10(%ebp)
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	6a 20                	push   $0x20
  801bdb:	e8 fa fb ff ff       	call   8017da <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
	return ;
  801be3:	90                   	nop
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <chktst>:
void chktst(uint32 n)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	ff 75 08             	pushl  0x8(%ebp)
  801bf4:	6a 22                	push   $0x22
  801bf6:	e8 df fb ff ff       	call   8017da <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfe:	90                   	nop
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <inctst>:

void inctst()
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 23                	push   $0x23
  801c10:	e8 c5 fb ff ff       	call   8017da <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
	return ;
  801c18:	90                   	nop
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <gettst>:
uint32 gettst()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 24                	push   $0x24
  801c2a:	e8 ab fb ff ff       	call   8017da <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 25                	push   $0x25
  801c46:	e8 8f fb ff ff       	call   8017da <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
  801c4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c51:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c55:	75 07                	jne    801c5e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c57:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5c:	eb 05                	jmp    801c63 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 25                	push   $0x25
  801c77:	e8 5e fb ff ff       	call   8017da <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
  801c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c82:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c86:	75 07                	jne    801c8f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c88:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8d:	eb 05                	jmp    801c94 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 25                	push   $0x25
  801ca8:	e8 2d fb ff ff       	call   8017da <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
  801cb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cb3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cb7:	75 07                	jne    801cc0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbe:	eb 05                	jmp    801cc5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 25                	push   $0x25
  801cd9:	e8 fc fa ff ff       	call   8017da <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
  801ce1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ce4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ce8:	75 07                	jne    801cf1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cea:	b8 01 00 00 00       	mov    $0x1,%eax
  801cef:	eb 05                	jmp    801cf6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	ff 75 08             	pushl  0x8(%ebp)
  801d06:	6a 26                	push   $0x26
  801d08:	e8 cd fa ff ff       	call   8017da <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d10:	90                   	nop
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d17:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	6a 00                	push   $0x0
  801d25:	53                   	push   %ebx
  801d26:	51                   	push   %ecx
  801d27:	52                   	push   %edx
  801d28:	50                   	push   %eax
  801d29:	6a 27                	push   $0x27
  801d2b:	e8 aa fa ff ff       	call   8017da <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	52                   	push   %edx
  801d48:	50                   	push   %eax
  801d49:	6a 28                	push   $0x28
  801d4b:	e8 8a fa ff ff       	call   8017da <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d58:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	6a 00                	push   $0x0
  801d63:	51                   	push   %ecx
  801d64:	ff 75 10             	pushl  0x10(%ebp)
  801d67:	52                   	push   %edx
  801d68:	50                   	push   %eax
  801d69:	6a 29                	push   $0x29
  801d6b:	e8 6a fa ff ff       	call   8017da <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	ff 75 10             	pushl  0x10(%ebp)
  801d7f:	ff 75 0c             	pushl  0xc(%ebp)
  801d82:	ff 75 08             	pushl  0x8(%ebp)
  801d85:	6a 12                	push   $0x12
  801d87:	e8 4e fa ff ff       	call   8017da <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8f:	90                   	nop
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	52                   	push   %edx
  801da2:	50                   	push   %eax
  801da3:	6a 2a                	push   $0x2a
  801da5:	e8 30 fa ff ff       	call   8017da <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
	return;
  801dad:	90                   	nop
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	50                   	push   %eax
  801dbf:	6a 2b                	push   $0x2b
  801dc1:	e8 14 fa ff ff       	call   8017da <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	ff 75 0c             	pushl  0xc(%ebp)
  801dd7:	ff 75 08             	pushl  0x8(%ebp)
  801dda:	6a 2c                	push   $0x2c
  801ddc:	e8 f9 f9 ff ff       	call   8017da <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
	return;
  801de4:	90                   	nop
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	ff 75 0c             	pushl  0xc(%ebp)
  801df3:	ff 75 08             	pushl  0x8(%ebp)
  801df6:	6a 2d                	push   $0x2d
  801df8:	e8 dd f9 ff ff       	call   8017da <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
	return;
  801e00:	90                   	nop
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	83 e8 04             	sub    $0x4,%eax
  801e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e15:	8b 00                	mov    (%eax),%eax
  801e17:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	83 e8 04             	sub    $0x4,%eax
  801e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e2e:	8b 00                	mov    (%eax),%eax
  801e30:	83 e0 01             	and    $0x1,%eax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	0f 94 c0             	sete   %al
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4a:	83 f8 02             	cmp    $0x2,%eax
  801e4d:	74 2b                	je     801e7a <alloc_block+0x40>
  801e4f:	83 f8 02             	cmp    $0x2,%eax
  801e52:	7f 07                	jg     801e5b <alloc_block+0x21>
  801e54:	83 f8 01             	cmp    $0x1,%eax
  801e57:	74 0e                	je     801e67 <alloc_block+0x2d>
  801e59:	eb 58                	jmp    801eb3 <alloc_block+0x79>
  801e5b:	83 f8 03             	cmp    $0x3,%eax
  801e5e:	74 2d                	je     801e8d <alloc_block+0x53>
  801e60:	83 f8 04             	cmp    $0x4,%eax
  801e63:	74 3b                	je     801ea0 <alloc_block+0x66>
  801e65:	eb 4c                	jmp    801eb3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	ff 75 08             	pushl  0x8(%ebp)
  801e6d:	e8 11 03 00 00       	call   802183 <alloc_block_FF>
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e78:	eb 4a                	jmp    801ec4 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e7a:	83 ec 0c             	sub    $0xc,%esp
  801e7d:	ff 75 08             	pushl  0x8(%ebp)
  801e80:	e8 c7 19 00 00       	call   80384c <alloc_block_NF>
  801e85:	83 c4 10             	add    $0x10,%esp
  801e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e8b:	eb 37                	jmp    801ec4 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e8d:	83 ec 0c             	sub    $0xc,%esp
  801e90:	ff 75 08             	pushl  0x8(%ebp)
  801e93:	e8 a7 07 00 00       	call   80263f <alloc_block_BF>
  801e98:	83 c4 10             	add    $0x10,%esp
  801e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e9e:	eb 24                	jmp    801ec4 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ea0:	83 ec 0c             	sub    $0xc,%esp
  801ea3:	ff 75 08             	pushl  0x8(%ebp)
  801ea6:	e8 84 19 00 00       	call   80382f <alloc_block_WF>
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eb1:	eb 11                	jmp    801ec4 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801eb3:	83 ec 0c             	sub    $0xc,%esp
  801eb6:	68 28 42 80 00       	push   $0x804228
  801ebb:	e8 4d e6 ff ff       	call   80050d <cprintf>
  801ec0:	83 c4 10             	add    $0x10,%esp
		break;
  801ec3:	90                   	nop
	}
	return va;
  801ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	53                   	push   %ebx
  801ecd:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	68 48 42 80 00       	push   $0x804248
  801ed8:	e8 30 e6 ff ff       	call   80050d <cprintf>
  801edd:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	68 73 42 80 00       	push   $0x804273
  801ee8:	e8 20 e6 ff ff       	call   80050d <cprintf>
  801eed:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef6:	eb 37                	jmp    801f2f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801ef8:	83 ec 0c             	sub    $0xc,%esp
  801efb:	ff 75 f4             	pushl  -0xc(%ebp)
  801efe:	e8 19 ff ff ff       	call   801e1c <is_free_block>
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	0f be d8             	movsbl %al,%ebx
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0f:	e8 ef fe ff ff       	call   801e03 <get_block_size>
  801f14:	83 c4 10             	add    $0x10,%esp
  801f17:	83 ec 04             	sub    $0x4,%esp
  801f1a:	53                   	push   %ebx
  801f1b:	50                   	push   %eax
  801f1c:	68 8b 42 80 00       	push   $0x80428b
  801f21:	e8 e7 e5 ff ff       	call   80050d <cprintf>
  801f26:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f29:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f33:	74 07                	je     801f3c <print_blocks_list+0x73>
  801f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f38:	8b 00                	mov    (%eax),%eax
  801f3a:	eb 05                	jmp    801f41 <print_blocks_list+0x78>
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f41:	89 45 10             	mov    %eax,0x10(%ebp)
  801f44:	8b 45 10             	mov    0x10(%ebp),%eax
  801f47:	85 c0                	test   %eax,%eax
  801f49:	75 ad                	jne    801ef8 <print_blocks_list+0x2f>
  801f4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4f:	75 a7                	jne    801ef8 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	68 48 42 80 00       	push   $0x804248
  801f59:	e8 af e5 ff ff       	call   80050d <cprintf>
  801f5e:	83 c4 10             	add    $0x10,%esp

}
  801f61:	90                   	nop
  801f62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f70:	83 e0 01             	and    $0x1,%eax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	74 03                	je     801f7a <initialize_dynamic_allocator+0x13>
  801f77:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f7e:	0f 84 c7 01 00 00    	je     80214b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f84:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f8b:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f94:	01 d0                	add    %edx,%eax
  801f96:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f9b:	0f 87 ad 01 00 00    	ja     80214e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	0f 89 a5 01 00 00    	jns    802151 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801fac:	8b 55 08             	mov    0x8(%ebp),%edx
  801faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb2:	01 d0                	add    %edx,%eax
  801fb4:	83 e8 04             	sub    $0x4,%eax
  801fb7:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801fbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801fc3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fcb:	e9 87 00 00 00       	jmp    802057 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd4:	75 14                	jne    801fea <initialize_dynamic_allocator+0x83>
  801fd6:	83 ec 04             	sub    $0x4,%esp
  801fd9:	68 a3 42 80 00       	push   $0x8042a3
  801fde:	6a 79                	push   $0x79
  801fe0:	68 c1 42 80 00       	push   $0x8042c1
  801fe5:	e8 66 e2 ff ff       	call   800250 <_panic>
  801fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fed:	8b 00                	mov    (%eax),%eax
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	74 10                	je     802003 <initialize_dynamic_allocator+0x9c>
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	8b 00                	mov    (%eax),%eax
  801ff8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffb:	8b 52 04             	mov    0x4(%edx),%edx
  801ffe:	89 50 04             	mov    %edx,0x4(%eax)
  802001:	eb 0b                	jmp    80200e <initialize_dynamic_allocator+0xa7>
  802003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802006:	8b 40 04             	mov    0x4(%eax),%eax
  802009:	a3 30 50 80 00       	mov    %eax,0x805030
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	8b 40 04             	mov    0x4(%eax),%eax
  802014:	85 c0                	test   %eax,%eax
  802016:	74 0f                	je     802027 <initialize_dynamic_allocator+0xc0>
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	8b 40 04             	mov    0x4(%eax),%eax
  80201e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802021:	8b 12                	mov    (%edx),%edx
  802023:	89 10                	mov    %edx,(%eax)
  802025:	eb 0a                	jmp    802031 <initialize_dynamic_allocator+0xca>
  802027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202a:	8b 00                	mov    (%eax),%eax
  80202c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80203a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802044:	a1 38 50 80 00       	mov    0x805038,%eax
  802049:	48                   	dec    %eax
  80204a:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80204f:	a1 34 50 80 00       	mov    0x805034,%eax
  802054:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802057:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205b:	74 07                	je     802064 <initialize_dynamic_allocator+0xfd>
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	8b 00                	mov    (%eax),%eax
  802062:	eb 05                	jmp    802069 <initialize_dynamic_allocator+0x102>
  802064:	b8 00 00 00 00       	mov    $0x0,%eax
  802069:	a3 34 50 80 00       	mov    %eax,0x805034
  80206e:	a1 34 50 80 00       	mov    0x805034,%eax
  802073:	85 c0                	test   %eax,%eax
  802075:	0f 85 55 ff ff ff    	jne    801fd0 <initialize_dynamic_allocator+0x69>
  80207b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207f:	0f 85 4b ff ff ff    	jne    801fd0 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80208b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802094:	a1 44 50 80 00       	mov    0x805044,%eax
  802099:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80209e:	a1 40 50 80 00       	mov    0x805040,%eax
  8020a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	83 c0 08             	add    $0x8,%eax
  8020af:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	83 c0 04             	add    $0x4,%eax
  8020b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bb:	83 ea 08             	sub    $0x8,%edx
  8020be:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	01 d0                	add    %edx,%eax
  8020c8:	83 e8 08             	sub    $0x8,%eax
  8020cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ce:	83 ea 08             	sub    $0x8,%edx
  8020d1:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020ea:	75 17                	jne    802103 <initialize_dynamic_allocator+0x19c>
  8020ec:	83 ec 04             	sub    $0x4,%esp
  8020ef:	68 dc 42 80 00       	push   $0x8042dc
  8020f4:	68 90 00 00 00       	push   $0x90
  8020f9:	68 c1 42 80 00       	push   $0x8042c1
  8020fe:	e8 4d e1 ff ff       	call   800250 <_panic>
  802103:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210c:	89 10                	mov    %edx,(%eax)
  80210e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802111:	8b 00                	mov    (%eax),%eax
  802113:	85 c0                	test   %eax,%eax
  802115:	74 0d                	je     802124 <initialize_dynamic_allocator+0x1bd>
  802117:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80211c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80211f:	89 50 04             	mov    %edx,0x4(%eax)
  802122:	eb 08                	jmp    80212c <initialize_dynamic_allocator+0x1c5>
  802124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802127:	a3 30 50 80 00       	mov    %eax,0x805030
  80212c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802137:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80213e:	a1 38 50 80 00       	mov    0x805038,%eax
  802143:	40                   	inc    %eax
  802144:	a3 38 50 80 00       	mov    %eax,0x805038
  802149:	eb 07                	jmp    802152 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80214b:	90                   	nop
  80214c:	eb 04                	jmp    802152 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80214e:	90                   	nop
  80214f:	eb 01                	jmp    802152 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802151:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802157:	8b 45 10             	mov    0x10(%ebp),%eax
  80215a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	8d 50 fc             	lea    -0x4(%eax),%edx
  802163:	8b 45 0c             	mov    0xc(%ebp),%eax
  802166:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	83 e8 04             	sub    $0x4,%eax
  80216e:	8b 00                	mov    (%eax),%eax
  802170:	83 e0 fe             	and    $0xfffffffe,%eax
  802173:	8d 50 f8             	lea    -0x8(%eax),%edx
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	01 c2                	add    %eax,%edx
  80217b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217e:	89 02                	mov    %eax,(%edx)
}
  802180:	90                   	nop
  802181:	5d                   	pop    %ebp
  802182:	c3                   	ret    

00802183 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	83 e0 01             	and    $0x1,%eax
  80218f:	85 c0                	test   %eax,%eax
  802191:	74 03                	je     802196 <alloc_block_FF+0x13>
  802193:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802196:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80219a:	77 07                	ja     8021a3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80219c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	75 73                	jne    80221f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	83 c0 10             	add    $0x10,%eax
  8021b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021b5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8021bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c2:	01 d0                	add    %edx,%eax
  8021c4:	48                   	dec    %eax
  8021c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d0:	f7 75 ec             	divl   -0x14(%ebp)
  8021d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021d6:	29 d0                	sub    %edx,%eax
  8021d8:	c1 e8 0c             	shr    $0xc,%eax
  8021db:	83 ec 0c             	sub    $0xc,%esp
  8021de:	50                   	push   %eax
  8021df:	e8 c3 f0 ff ff       	call   8012a7 <sbrk>
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021ea:	83 ec 0c             	sub    $0xc,%esp
  8021ed:	6a 00                	push   $0x0
  8021ef:	e8 b3 f0 ff ff       	call   8012a7 <sbrk>
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8021fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021fd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802200:	83 ec 08             	sub    $0x8,%esp
  802203:	50                   	push   %eax
  802204:	ff 75 e4             	pushl  -0x1c(%ebp)
  802207:	e8 5b fd ff ff       	call   801f67 <initialize_dynamic_allocator>
  80220c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80220f:	83 ec 0c             	sub    $0xc,%esp
  802212:	68 ff 42 80 00       	push   $0x8042ff
  802217:	e8 f1 e2 ff ff       	call   80050d <cprintf>
  80221c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80221f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802223:	75 0a                	jne    80222f <alloc_block_FF+0xac>
	        return NULL;
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
  80222a:	e9 0e 04 00 00       	jmp    80263d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80222f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802236:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80223b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80223e:	e9 f3 02 00 00       	jmp    802536 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	ff 75 bc             	pushl  -0x44(%ebp)
  80224f:	e8 af fb ff ff       	call   801e03 <get_block_size>
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	83 c0 08             	add    $0x8,%eax
  802260:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802263:	0f 87 c5 02 00 00    	ja     80252e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	83 c0 18             	add    $0x18,%eax
  80226f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802272:	0f 87 19 02 00 00    	ja     802491 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802278:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80227b:	2b 45 08             	sub    0x8(%ebp),%eax
  80227e:	83 e8 08             	sub    $0x8,%eax
  802281:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	8d 50 08             	lea    0x8(%eax),%edx
  80228a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80228d:	01 d0                	add    %edx,%eax
  80228f:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	83 c0 08             	add    $0x8,%eax
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	6a 01                	push   $0x1
  80229d:	50                   	push   %eax
  80229e:	ff 75 bc             	pushl  -0x44(%ebp)
  8022a1:	e8 ae fe ff ff       	call   802154 <set_block_data>
  8022a6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 40 04             	mov    0x4(%eax),%eax
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	75 68                	jne    80231b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022b3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022b7:	75 17                	jne    8022d0 <alloc_block_FF+0x14d>
  8022b9:	83 ec 04             	sub    $0x4,%esp
  8022bc:	68 dc 42 80 00       	push   $0x8042dc
  8022c1:	68 d7 00 00 00       	push   $0xd7
  8022c6:	68 c1 42 80 00       	push   $0x8042c1
  8022cb:	e8 80 df ff ff       	call   800250 <_panic>
  8022d0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d9:	89 10                	mov    %edx,(%eax)
  8022db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	74 0d                	je     8022f1 <alloc_block_FF+0x16e>
  8022e4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022e9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022ec:	89 50 04             	mov    %edx,0x4(%eax)
  8022ef:	eb 08                	jmp    8022f9 <alloc_block_FF+0x176>
  8022f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8022f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802301:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802304:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230b:	a1 38 50 80 00       	mov    0x805038,%eax
  802310:	40                   	inc    %eax
  802311:	a3 38 50 80 00       	mov    %eax,0x805038
  802316:	e9 dc 00 00 00       	jmp    8023f7 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 00                	mov    (%eax),%eax
  802320:	85 c0                	test   %eax,%eax
  802322:	75 65                	jne    802389 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802324:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802328:	75 17                	jne    802341 <alloc_block_FF+0x1be>
  80232a:	83 ec 04             	sub    $0x4,%esp
  80232d:	68 10 43 80 00       	push   $0x804310
  802332:	68 db 00 00 00       	push   $0xdb
  802337:	68 c1 42 80 00       	push   $0x8042c1
  80233c:	e8 0f df ff ff       	call   800250 <_panic>
  802341:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802347:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234a:	89 50 04             	mov    %edx,0x4(%eax)
  80234d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802350:	8b 40 04             	mov    0x4(%eax),%eax
  802353:	85 c0                	test   %eax,%eax
  802355:	74 0c                	je     802363 <alloc_block_FF+0x1e0>
  802357:	a1 30 50 80 00       	mov    0x805030,%eax
  80235c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80235f:	89 10                	mov    %edx,(%eax)
  802361:	eb 08                	jmp    80236b <alloc_block_FF+0x1e8>
  802363:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802366:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80236b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80236e:	a3 30 50 80 00       	mov    %eax,0x805030
  802373:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802376:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237c:	a1 38 50 80 00       	mov    0x805038,%eax
  802381:	40                   	inc    %eax
  802382:	a3 38 50 80 00       	mov    %eax,0x805038
  802387:	eb 6e                	jmp    8023f7 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238d:	74 06                	je     802395 <alloc_block_FF+0x212>
  80238f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802393:	75 17                	jne    8023ac <alloc_block_FF+0x229>
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	68 34 43 80 00       	push   $0x804334
  80239d:	68 df 00 00 00       	push   $0xdf
  8023a2:	68 c1 42 80 00       	push   $0x8042c1
  8023a7:	e8 a4 de ff ff       	call   800250 <_panic>
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 10                	mov    (%eax),%edx
  8023b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b4:	89 10                	mov    %edx,(%eax)
  8023b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b9:	8b 00                	mov    (%eax),%eax
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	74 0b                	je     8023ca <alloc_block_FF+0x247>
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023c7:	89 50 04             	mov    %edx,0x4(%eax)
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023d0:	89 10                	mov    %edx,(%eax)
  8023d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d8:	89 50 04             	mov    %edx,0x4(%eax)
  8023db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023de:	8b 00                	mov    (%eax),%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	75 08                	jne    8023ec <alloc_block_FF+0x269>
  8023e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8023f1:	40                   	inc    %eax
  8023f2:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fb:	75 17                	jne    802414 <alloc_block_FF+0x291>
  8023fd:	83 ec 04             	sub    $0x4,%esp
  802400:	68 a3 42 80 00       	push   $0x8042a3
  802405:	68 e1 00 00 00       	push   $0xe1
  80240a:	68 c1 42 80 00       	push   $0x8042c1
  80240f:	e8 3c de ff ff       	call   800250 <_panic>
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 00                	mov    (%eax),%eax
  802419:	85 c0                	test   %eax,%eax
  80241b:	74 10                	je     80242d <alloc_block_FF+0x2aa>
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	8b 00                	mov    (%eax),%eax
  802422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802425:	8b 52 04             	mov    0x4(%edx),%edx
  802428:	89 50 04             	mov    %edx,0x4(%eax)
  80242b:	eb 0b                	jmp    802438 <alloc_block_FF+0x2b5>
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 40 04             	mov    0x4(%eax),%eax
  802433:	a3 30 50 80 00       	mov    %eax,0x805030
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 40 04             	mov    0x4(%eax),%eax
  80243e:	85 c0                	test   %eax,%eax
  802440:	74 0f                	je     802451 <alloc_block_FF+0x2ce>
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	8b 40 04             	mov    0x4(%eax),%eax
  802448:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244b:	8b 12                	mov    (%edx),%edx
  80244d:	89 10                	mov    %edx,(%eax)
  80244f:	eb 0a                	jmp    80245b <alloc_block_FF+0x2d8>
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 00                	mov    (%eax),%eax
  802456:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246e:	a1 38 50 80 00       	mov    0x805038,%eax
  802473:	48                   	dec    %eax
  802474:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802479:	83 ec 04             	sub    $0x4,%esp
  80247c:	6a 00                	push   $0x0
  80247e:	ff 75 b4             	pushl  -0x4c(%ebp)
  802481:	ff 75 b0             	pushl  -0x50(%ebp)
  802484:	e8 cb fc ff ff       	call   802154 <set_block_data>
  802489:	83 c4 10             	add    $0x10,%esp
  80248c:	e9 95 00 00 00       	jmp    802526 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802491:	83 ec 04             	sub    $0x4,%esp
  802494:	6a 01                	push   $0x1
  802496:	ff 75 b8             	pushl  -0x48(%ebp)
  802499:	ff 75 bc             	pushl  -0x44(%ebp)
  80249c:	e8 b3 fc ff ff       	call   802154 <set_block_data>
  8024a1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a8:	75 17                	jne    8024c1 <alloc_block_FF+0x33e>
  8024aa:	83 ec 04             	sub    $0x4,%esp
  8024ad:	68 a3 42 80 00       	push   $0x8042a3
  8024b2:	68 e8 00 00 00       	push   $0xe8
  8024b7:	68 c1 42 80 00       	push   $0x8042c1
  8024bc:	e8 8f dd ff ff       	call   800250 <_panic>
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	74 10                	je     8024da <alloc_block_FF+0x357>
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d2:	8b 52 04             	mov    0x4(%edx),%edx
  8024d5:	89 50 04             	mov    %edx,0x4(%eax)
  8024d8:	eb 0b                	jmp    8024e5 <alloc_block_FF+0x362>
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 40 04             	mov    0x4(%eax),%eax
  8024e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	74 0f                	je     8024fe <alloc_block_FF+0x37b>
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	8b 40 04             	mov    0x4(%eax),%eax
  8024f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f8:	8b 12                	mov    (%edx),%edx
  8024fa:	89 10                	mov    %edx,(%eax)
  8024fc:	eb 0a                	jmp    802508 <alloc_block_FF+0x385>
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 00                	mov    (%eax),%eax
  802503:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251b:	a1 38 50 80 00       	mov    0x805038,%eax
  802520:	48                   	dec    %eax
  802521:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802526:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802529:	e9 0f 01 00 00       	jmp    80263d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80252e:	a1 34 50 80 00       	mov    0x805034,%eax
  802533:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253a:	74 07                	je     802543 <alloc_block_FF+0x3c0>
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 00                	mov    (%eax),%eax
  802541:	eb 05                	jmp    802548 <alloc_block_FF+0x3c5>
  802543:	b8 00 00 00 00       	mov    $0x0,%eax
  802548:	a3 34 50 80 00       	mov    %eax,0x805034
  80254d:	a1 34 50 80 00       	mov    0x805034,%eax
  802552:	85 c0                	test   %eax,%eax
  802554:	0f 85 e9 fc ff ff    	jne    802243 <alloc_block_FF+0xc0>
  80255a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255e:	0f 85 df fc ff ff    	jne    802243 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	83 c0 08             	add    $0x8,%eax
  80256a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80256d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802574:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802577:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80257a:	01 d0                	add    %edx,%eax
  80257c:	48                   	dec    %eax
  80257d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802583:	ba 00 00 00 00       	mov    $0x0,%edx
  802588:	f7 75 d8             	divl   -0x28(%ebp)
  80258b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80258e:	29 d0                	sub    %edx,%eax
  802590:	c1 e8 0c             	shr    $0xc,%eax
  802593:	83 ec 0c             	sub    $0xc,%esp
  802596:	50                   	push   %eax
  802597:	e8 0b ed ff ff       	call   8012a7 <sbrk>
  80259c:	83 c4 10             	add    $0x10,%esp
  80259f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025a2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025a6:	75 0a                	jne    8025b2 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ad:	e9 8b 00 00 00       	jmp    80263d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025b2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025bf:	01 d0                	add    %edx,%eax
  8025c1:	48                   	dec    %eax
  8025c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8025cd:	f7 75 cc             	divl   -0x34(%ebp)
  8025d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025d3:	29 d0                	sub    %edx,%eax
  8025d5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025db:	01 d0                	add    %edx,%eax
  8025dd:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8025e2:	a1 40 50 80 00       	mov    0x805040,%eax
  8025e7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025ed:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025fa:	01 d0                	add    %edx,%eax
  8025fc:	48                   	dec    %eax
  8025fd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802600:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802603:	ba 00 00 00 00       	mov    $0x0,%edx
  802608:	f7 75 c4             	divl   -0x3c(%ebp)
  80260b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80260e:	29 d0                	sub    %edx,%eax
  802610:	83 ec 04             	sub    $0x4,%esp
  802613:	6a 01                	push   $0x1
  802615:	50                   	push   %eax
  802616:	ff 75 d0             	pushl  -0x30(%ebp)
  802619:	e8 36 fb ff ff       	call   802154 <set_block_data>
  80261e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802621:	83 ec 0c             	sub    $0xc,%esp
  802624:	ff 75 d0             	pushl  -0x30(%ebp)
  802627:	e8 f8 09 00 00       	call   803024 <free_block>
  80262c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80262f:	83 ec 0c             	sub    $0xc,%esp
  802632:	ff 75 08             	pushl  0x8(%ebp)
  802635:	e8 49 fb ff ff       	call   802183 <alloc_block_FF>
  80263a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80263d:	c9                   	leave  
  80263e:	c3                   	ret    

0080263f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	83 e0 01             	and    $0x1,%eax
  80264b:	85 c0                	test   %eax,%eax
  80264d:	74 03                	je     802652 <alloc_block_BF+0x13>
  80264f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802652:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802656:	77 07                	ja     80265f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802658:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80265f:	a1 24 50 80 00       	mov    0x805024,%eax
  802664:	85 c0                	test   %eax,%eax
  802666:	75 73                	jne    8026db <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802668:	8b 45 08             	mov    0x8(%ebp),%eax
  80266b:	83 c0 10             	add    $0x10,%eax
  80266e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802671:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802678:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80267b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267e:	01 d0                	add    %edx,%eax
  802680:	48                   	dec    %eax
  802681:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802684:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802687:	ba 00 00 00 00       	mov    $0x0,%edx
  80268c:	f7 75 e0             	divl   -0x20(%ebp)
  80268f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802692:	29 d0                	sub    %edx,%eax
  802694:	c1 e8 0c             	shr    $0xc,%eax
  802697:	83 ec 0c             	sub    $0xc,%esp
  80269a:	50                   	push   %eax
  80269b:	e8 07 ec ff ff       	call   8012a7 <sbrk>
  8026a0:	83 c4 10             	add    $0x10,%esp
  8026a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026a6:	83 ec 0c             	sub    $0xc,%esp
  8026a9:	6a 00                	push   $0x0
  8026ab:	e8 f7 eb ff ff       	call   8012a7 <sbrk>
  8026b0:	83 c4 10             	add    $0x10,%esp
  8026b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026b9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8026bc:	83 ec 08             	sub    $0x8,%esp
  8026bf:	50                   	push   %eax
  8026c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8026c3:	e8 9f f8 ff ff       	call   801f67 <initialize_dynamic_allocator>
  8026c8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026cb:	83 ec 0c             	sub    $0xc,%esp
  8026ce:	68 ff 42 80 00       	push   $0x8042ff
  8026d3:	e8 35 de ff ff       	call   80050d <cprintf>
  8026d8:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026e9:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8026f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ff:	e9 1d 01 00 00       	jmp    802821 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80270a:	83 ec 0c             	sub    $0xc,%esp
  80270d:	ff 75 a8             	pushl  -0x58(%ebp)
  802710:	e8 ee f6 ff ff       	call   801e03 <get_block_size>
  802715:	83 c4 10             	add    $0x10,%esp
  802718:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	83 c0 08             	add    $0x8,%eax
  802721:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802724:	0f 87 ef 00 00 00    	ja     802819 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	83 c0 18             	add    $0x18,%eax
  802730:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802733:	77 1d                	ja     802752 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802738:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80273b:	0f 86 d8 00 00 00    	jbe    802819 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802741:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802744:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802747:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80274a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80274d:	e9 c7 00 00 00       	jmp    802819 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	83 c0 08             	add    $0x8,%eax
  802758:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80275b:	0f 85 9d 00 00 00    	jne    8027fe <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802761:	83 ec 04             	sub    $0x4,%esp
  802764:	6a 01                	push   $0x1
  802766:	ff 75 a4             	pushl  -0x5c(%ebp)
  802769:	ff 75 a8             	pushl  -0x58(%ebp)
  80276c:	e8 e3 f9 ff ff       	call   802154 <set_block_data>
  802771:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802774:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802778:	75 17                	jne    802791 <alloc_block_BF+0x152>
  80277a:	83 ec 04             	sub    $0x4,%esp
  80277d:	68 a3 42 80 00       	push   $0x8042a3
  802782:	68 2c 01 00 00       	push   $0x12c
  802787:	68 c1 42 80 00       	push   $0x8042c1
  80278c:	e8 bf da ff ff       	call   800250 <_panic>
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 00                	mov    (%eax),%eax
  802796:	85 c0                	test   %eax,%eax
  802798:	74 10                	je     8027aa <alloc_block_BF+0x16b>
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a2:	8b 52 04             	mov    0x4(%edx),%edx
  8027a5:	89 50 04             	mov    %edx,0x4(%eax)
  8027a8:	eb 0b                	jmp    8027b5 <alloc_block_BF+0x176>
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 40 04             	mov    0x4(%eax),%eax
  8027b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 04             	mov    0x4(%eax),%eax
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	74 0f                	je     8027ce <alloc_block_BF+0x18f>
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 40 04             	mov    0x4(%eax),%eax
  8027c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c8:	8b 12                	mov    (%edx),%edx
  8027ca:	89 10                	mov    %edx,(%eax)
  8027cc:	eb 0a                	jmp    8027d8 <alloc_block_BF+0x199>
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 00                	mov    (%eax),%eax
  8027d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f0:	48                   	dec    %eax
  8027f1:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8027f6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027f9:	e9 01 04 00 00       	jmp    802bff <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  8027fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802801:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802804:	76 13                	jbe    802819 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802806:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80280d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802810:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802813:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802816:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802819:	a1 34 50 80 00       	mov    0x805034,%eax
  80281e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802825:	74 07                	je     80282e <alloc_block_BF+0x1ef>
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	eb 05                	jmp    802833 <alloc_block_BF+0x1f4>
  80282e:	b8 00 00 00 00       	mov    $0x0,%eax
  802833:	a3 34 50 80 00       	mov    %eax,0x805034
  802838:	a1 34 50 80 00       	mov    0x805034,%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	0f 85 bf fe ff ff    	jne    802704 <alloc_block_BF+0xc5>
  802845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802849:	0f 85 b5 fe ff ff    	jne    802704 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80284f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802853:	0f 84 26 02 00 00    	je     802a7f <alloc_block_BF+0x440>
  802859:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80285d:	0f 85 1c 02 00 00    	jne    802a7f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802866:	2b 45 08             	sub    0x8(%ebp),%eax
  802869:	83 e8 08             	sub    $0x8,%eax
  80286c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	8d 50 08             	lea    0x8(%eax),%edx
  802875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802878:	01 d0                	add    %edx,%eax
  80287a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	83 c0 08             	add    $0x8,%eax
  802883:	83 ec 04             	sub    $0x4,%esp
  802886:	6a 01                	push   $0x1
  802888:	50                   	push   %eax
  802889:	ff 75 f0             	pushl  -0x10(%ebp)
  80288c:	e8 c3 f8 ff ff       	call   802154 <set_block_data>
  802891:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	8b 40 04             	mov    0x4(%eax),%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	75 68                	jne    802906 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80289e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028a2:	75 17                	jne    8028bb <alloc_block_BF+0x27c>
  8028a4:	83 ec 04             	sub    $0x4,%esp
  8028a7:	68 dc 42 80 00       	push   $0x8042dc
  8028ac:	68 45 01 00 00       	push   $0x145
  8028b1:	68 c1 42 80 00       	push   $0x8042c1
  8028b6:	e8 95 d9 ff ff       	call   800250 <_panic>
  8028bb:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c4:	89 10                	mov    %edx,(%eax)
  8028c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c9:	8b 00                	mov    (%eax),%eax
  8028cb:	85 c0                	test   %eax,%eax
  8028cd:	74 0d                	je     8028dc <alloc_block_BF+0x29d>
  8028cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028d4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028d7:	89 50 04             	mov    %edx,0x4(%eax)
  8028da:	eb 08                	jmp    8028e4 <alloc_block_BF+0x2a5>
  8028dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028df:	a3 30 50 80 00       	mov    %eax,0x805030
  8028e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8028fb:	40                   	inc    %eax
  8028fc:	a3 38 50 80 00       	mov    %eax,0x805038
  802901:	e9 dc 00 00 00       	jmp    8029e2 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	8b 00                	mov    (%eax),%eax
  80290b:	85 c0                	test   %eax,%eax
  80290d:	75 65                	jne    802974 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80290f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802913:	75 17                	jne    80292c <alloc_block_BF+0x2ed>
  802915:	83 ec 04             	sub    $0x4,%esp
  802918:	68 10 43 80 00       	push   $0x804310
  80291d:	68 4a 01 00 00       	push   $0x14a
  802922:	68 c1 42 80 00       	push   $0x8042c1
  802927:	e8 24 d9 ff ff       	call   800250 <_panic>
  80292c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802932:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802935:	89 50 04             	mov    %edx,0x4(%eax)
  802938:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80293b:	8b 40 04             	mov    0x4(%eax),%eax
  80293e:	85 c0                	test   %eax,%eax
  802940:	74 0c                	je     80294e <alloc_block_BF+0x30f>
  802942:	a1 30 50 80 00       	mov    0x805030,%eax
  802947:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80294a:	89 10                	mov    %edx,(%eax)
  80294c:	eb 08                	jmp    802956 <alloc_block_BF+0x317>
  80294e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802951:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802956:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802959:	a3 30 50 80 00       	mov    %eax,0x805030
  80295e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802961:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802967:	a1 38 50 80 00       	mov    0x805038,%eax
  80296c:	40                   	inc    %eax
  80296d:	a3 38 50 80 00       	mov    %eax,0x805038
  802972:	eb 6e                	jmp    8029e2 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802974:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802978:	74 06                	je     802980 <alloc_block_BF+0x341>
  80297a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80297e:	75 17                	jne    802997 <alloc_block_BF+0x358>
  802980:	83 ec 04             	sub    $0x4,%esp
  802983:	68 34 43 80 00       	push   $0x804334
  802988:	68 4f 01 00 00       	push   $0x14f
  80298d:	68 c1 42 80 00       	push   $0x8042c1
  802992:	e8 b9 d8 ff ff       	call   800250 <_panic>
  802997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299a:	8b 10                	mov    (%eax),%edx
  80299c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80299f:	89 10                	mov    %edx,(%eax)
  8029a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a4:	8b 00                	mov    (%eax),%eax
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	74 0b                	je     8029b5 <alloc_block_BF+0x376>
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029b2:	89 50 04             	mov    %edx,0x4(%eax)
  8029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029bb:	89 10                	mov    %edx,(%eax)
  8029bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c3:	89 50 04             	mov    %edx,0x4(%eax)
  8029c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	75 08                	jne    8029d7 <alloc_block_BF+0x398>
  8029cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d2:	a3 30 50 80 00       	mov    %eax,0x805030
  8029d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8029dc:	40                   	inc    %eax
  8029dd:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e6:	75 17                	jne    8029ff <alloc_block_BF+0x3c0>
  8029e8:	83 ec 04             	sub    $0x4,%esp
  8029eb:	68 a3 42 80 00       	push   $0x8042a3
  8029f0:	68 51 01 00 00       	push   $0x151
  8029f5:	68 c1 42 80 00       	push   $0x8042c1
  8029fa:	e8 51 d8 ff ff       	call   800250 <_panic>
  8029ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	74 10                	je     802a18 <alloc_block_BF+0x3d9>
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	8b 00                	mov    (%eax),%eax
  802a0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a10:	8b 52 04             	mov    0x4(%edx),%edx
  802a13:	89 50 04             	mov    %edx,0x4(%eax)
  802a16:	eb 0b                	jmp    802a23 <alloc_block_BF+0x3e4>
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	8b 40 04             	mov    0x4(%eax),%eax
  802a1e:	a3 30 50 80 00       	mov    %eax,0x805030
  802a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a26:	8b 40 04             	mov    0x4(%eax),%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	74 0f                	je     802a3c <alloc_block_BF+0x3fd>
  802a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a30:	8b 40 04             	mov    0x4(%eax),%eax
  802a33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a36:	8b 12                	mov    (%edx),%edx
  802a38:	89 10                	mov    %edx,(%eax)
  802a3a:	eb 0a                	jmp    802a46 <alloc_block_BF+0x407>
  802a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a59:	a1 38 50 80 00       	mov    0x805038,%eax
  802a5e:	48                   	dec    %eax
  802a5f:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a64:	83 ec 04             	sub    $0x4,%esp
  802a67:	6a 00                	push   $0x0
  802a69:	ff 75 d0             	pushl  -0x30(%ebp)
  802a6c:	ff 75 cc             	pushl  -0x34(%ebp)
  802a6f:	e8 e0 f6 ff ff       	call   802154 <set_block_data>
  802a74:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7a:	e9 80 01 00 00       	jmp    802bff <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802a7f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a83:	0f 85 9d 00 00 00    	jne    802b26 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a89:	83 ec 04             	sub    $0x4,%esp
  802a8c:	6a 01                	push   $0x1
  802a8e:	ff 75 ec             	pushl  -0x14(%ebp)
  802a91:	ff 75 f0             	pushl  -0x10(%ebp)
  802a94:	e8 bb f6 ff ff       	call   802154 <set_block_data>
  802a99:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aa0:	75 17                	jne    802ab9 <alloc_block_BF+0x47a>
  802aa2:	83 ec 04             	sub    $0x4,%esp
  802aa5:	68 a3 42 80 00       	push   $0x8042a3
  802aaa:	68 58 01 00 00       	push   $0x158
  802aaf:	68 c1 42 80 00       	push   $0x8042c1
  802ab4:	e8 97 d7 ff ff       	call   800250 <_panic>
  802ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 10                	je     802ad2 <alloc_block_BF+0x493>
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aca:	8b 52 04             	mov    0x4(%edx),%edx
  802acd:	89 50 04             	mov    %edx,0x4(%eax)
  802ad0:	eb 0b                	jmp    802add <alloc_block_BF+0x49e>
  802ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad5:	8b 40 04             	mov    0x4(%eax),%eax
  802ad8:	a3 30 50 80 00       	mov    %eax,0x805030
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	8b 40 04             	mov    0x4(%eax),%eax
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	74 0f                	je     802af6 <alloc_block_BF+0x4b7>
  802ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af0:	8b 12                	mov    (%edx),%edx
  802af2:	89 10                	mov    %edx,(%eax)
  802af4:	eb 0a                	jmp    802b00 <alloc_block_BF+0x4c1>
  802af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b13:	a1 38 50 80 00       	mov    0x805038,%eax
  802b18:	48                   	dec    %eax
  802b19:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b21:	e9 d9 00 00 00       	jmp    802bff <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	83 c0 08             	add    $0x8,%eax
  802b2c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b2f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b36:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b3c:	01 d0                	add    %edx,%eax
  802b3e:	48                   	dec    %eax
  802b3f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b42:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b45:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4a:	f7 75 c4             	divl   -0x3c(%ebp)
  802b4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b50:	29 d0                	sub    %edx,%eax
  802b52:	c1 e8 0c             	shr    $0xc,%eax
  802b55:	83 ec 0c             	sub    $0xc,%esp
  802b58:	50                   	push   %eax
  802b59:	e8 49 e7 ff ff       	call   8012a7 <sbrk>
  802b5e:	83 c4 10             	add    $0x10,%esp
  802b61:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b64:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b68:	75 0a                	jne    802b74 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6f:	e9 8b 00 00 00       	jmp    802bff <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b74:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b7b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b7e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b81:	01 d0                	add    %edx,%eax
  802b83:	48                   	dec    %eax
  802b84:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b87:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  802b8f:	f7 75 b8             	divl   -0x48(%ebp)
  802b92:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b95:	29 d0                	sub    %edx,%eax
  802b97:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b9a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b9d:	01 d0                	add    %edx,%eax
  802b9f:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ba4:	a1 40 50 80 00       	mov    0x805040,%eax
  802ba9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802baf:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802bb6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bb9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bbc:	01 d0                	add    %edx,%eax
  802bbe:	48                   	dec    %eax
  802bbf:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802bc2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bc5:	ba 00 00 00 00       	mov    $0x0,%edx
  802bca:	f7 75 b0             	divl   -0x50(%ebp)
  802bcd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bd0:	29 d0                	sub    %edx,%eax
  802bd2:	83 ec 04             	sub    $0x4,%esp
  802bd5:	6a 01                	push   $0x1
  802bd7:	50                   	push   %eax
  802bd8:	ff 75 bc             	pushl  -0x44(%ebp)
  802bdb:	e8 74 f5 ff ff       	call   802154 <set_block_data>
  802be0:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802be3:	83 ec 0c             	sub    $0xc,%esp
  802be6:	ff 75 bc             	pushl  -0x44(%ebp)
  802be9:	e8 36 04 00 00       	call   803024 <free_block>
  802bee:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802bf1:	83 ec 0c             	sub    $0xc,%esp
  802bf4:	ff 75 08             	pushl  0x8(%ebp)
  802bf7:	e8 43 fa ff ff       	call   80263f <alloc_block_BF>
  802bfc:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802bff:	c9                   	leave  
  802c00:	c3                   	ret    

00802c01 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c01:	55                   	push   %ebp
  802c02:	89 e5                	mov    %esp,%ebp
  802c04:	53                   	push   %ebx
  802c05:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c1a:	74 1e                	je     802c3a <merging+0x39>
  802c1c:	ff 75 08             	pushl  0x8(%ebp)
  802c1f:	e8 df f1 ff ff       	call   801e03 <get_block_size>
  802c24:	83 c4 04             	add    $0x4,%esp
  802c27:	89 c2                	mov    %eax,%edx
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	01 d0                	add    %edx,%eax
  802c2e:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c31:	75 07                	jne    802c3a <merging+0x39>
		prev_is_free = 1;
  802c33:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c3e:	74 1e                	je     802c5e <merging+0x5d>
  802c40:	ff 75 10             	pushl  0x10(%ebp)
  802c43:	e8 bb f1 ff ff       	call   801e03 <get_block_size>
  802c48:	83 c4 04             	add    $0x4,%esp
  802c4b:	89 c2                	mov    %eax,%edx
  802c4d:	8b 45 10             	mov    0x10(%ebp),%eax
  802c50:	01 d0                	add    %edx,%eax
  802c52:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c55:	75 07                	jne    802c5e <merging+0x5d>
		next_is_free = 1;
  802c57:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c62:	0f 84 cc 00 00 00    	je     802d34 <merging+0x133>
  802c68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c6c:	0f 84 c2 00 00 00    	je     802d34 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c72:	ff 75 08             	pushl  0x8(%ebp)
  802c75:	e8 89 f1 ff ff       	call   801e03 <get_block_size>
  802c7a:	83 c4 04             	add    $0x4,%esp
  802c7d:	89 c3                	mov    %eax,%ebx
  802c7f:	ff 75 10             	pushl  0x10(%ebp)
  802c82:	e8 7c f1 ff ff       	call   801e03 <get_block_size>
  802c87:	83 c4 04             	add    $0x4,%esp
  802c8a:	01 c3                	add    %eax,%ebx
  802c8c:	ff 75 0c             	pushl  0xc(%ebp)
  802c8f:	e8 6f f1 ff ff       	call   801e03 <get_block_size>
  802c94:	83 c4 04             	add    $0x4,%esp
  802c97:	01 d8                	add    %ebx,%eax
  802c99:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c9c:	6a 00                	push   $0x0
  802c9e:	ff 75 ec             	pushl  -0x14(%ebp)
  802ca1:	ff 75 08             	pushl  0x8(%ebp)
  802ca4:	e8 ab f4 ff ff       	call   802154 <set_block_data>
  802ca9:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802cac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cb0:	75 17                	jne    802cc9 <merging+0xc8>
  802cb2:	83 ec 04             	sub    $0x4,%esp
  802cb5:	68 a3 42 80 00       	push   $0x8042a3
  802cba:	68 7d 01 00 00       	push   $0x17d
  802cbf:	68 c1 42 80 00       	push   $0x8042c1
  802cc4:	e8 87 d5 ff ff       	call   800250 <_panic>
  802cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ccc:	8b 00                	mov    (%eax),%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	74 10                	je     802ce2 <merging+0xe1>
  802cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cda:	8b 52 04             	mov    0x4(%edx),%edx
  802cdd:	89 50 04             	mov    %edx,0x4(%eax)
  802ce0:	eb 0b                	jmp    802ced <merging+0xec>
  802ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce5:	8b 40 04             	mov    0x4(%eax),%eax
  802ce8:	a3 30 50 80 00       	mov    %eax,0x805030
  802ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	74 0f                	je     802d06 <merging+0x105>
  802cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfa:	8b 40 04             	mov    0x4(%eax),%eax
  802cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d00:	8b 12                	mov    (%edx),%edx
  802d02:	89 10                	mov    %edx,(%eax)
  802d04:	eb 0a                	jmp    802d10 <merging+0x10f>
  802d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d09:	8b 00                	mov    (%eax),%eax
  802d0b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d23:	a1 38 50 80 00       	mov    0x805038,%eax
  802d28:	48                   	dec    %eax
  802d29:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d2e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d2f:	e9 ea 02 00 00       	jmp    80301e <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d38:	74 3b                	je     802d75 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d3a:	83 ec 0c             	sub    $0xc,%esp
  802d3d:	ff 75 08             	pushl  0x8(%ebp)
  802d40:	e8 be f0 ff ff       	call   801e03 <get_block_size>
  802d45:	83 c4 10             	add    $0x10,%esp
  802d48:	89 c3                	mov    %eax,%ebx
  802d4a:	83 ec 0c             	sub    $0xc,%esp
  802d4d:	ff 75 10             	pushl  0x10(%ebp)
  802d50:	e8 ae f0 ff ff       	call   801e03 <get_block_size>
  802d55:	83 c4 10             	add    $0x10,%esp
  802d58:	01 d8                	add    %ebx,%eax
  802d5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d5d:	83 ec 04             	sub    $0x4,%esp
  802d60:	6a 00                	push   $0x0
  802d62:	ff 75 e8             	pushl  -0x18(%ebp)
  802d65:	ff 75 08             	pushl  0x8(%ebp)
  802d68:	e8 e7 f3 ff ff       	call   802154 <set_block_data>
  802d6d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d70:	e9 a9 02 00 00       	jmp    80301e <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d79:	0f 84 2d 01 00 00    	je     802eac <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d7f:	83 ec 0c             	sub    $0xc,%esp
  802d82:	ff 75 10             	pushl  0x10(%ebp)
  802d85:	e8 79 f0 ff ff       	call   801e03 <get_block_size>
  802d8a:	83 c4 10             	add    $0x10,%esp
  802d8d:	89 c3                	mov    %eax,%ebx
  802d8f:	83 ec 0c             	sub    $0xc,%esp
  802d92:	ff 75 0c             	pushl  0xc(%ebp)
  802d95:	e8 69 f0 ff ff       	call   801e03 <get_block_size>
  802d9a:	83 c4 10             	add    $0x10,%esp
  802d9d:	01 d8                	add    %ebx,%eax
  802d9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802da2:	83 ec 04             	sub    $0x4,%esp
  802da5:	6a 00                	push   $0x0
  802da7:	ff 75 e4             	pushl  -0x1c(%ebp)
  802daa:	ff 75 10             	pushl  0x10(%ebp)
  802dad:	e8 a2 f3 ff ff       	call   802154 <set_block_data>
  802db2:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802db5:	8b 45 10             	mov    0x10(%ebp),%eax
  802db8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802dbb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dbf:	74 06                	je     802dc7 <merging+0x1c6>
  802dc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dc5:	75 17                	jne    802dde <merging+0x1dd>
  802dc7:	83 ec 04             	sub    $0x4,%esp
  802dca:	68 68 43 80 00       	push   $0x804368
  802dcf:	68 8d 01 00 00       	push   $0x18d
  802dd4:	68 c1 42 80 00       	push   $0x8042c1
  802dd9:	e8 72 d4 ff ff       	call   800250 <_panic>
  802dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de1:	8b 50 04             	mov    0x4(%eax),%edx
  802de4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
  802dea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ded:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df0:	89 10                	mov    %edx,(%eax)
  802df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df5:	8b 40 04             	mov    0x4(%eax),%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	74 0d                	je     802e09 <merging+0x208>
  802dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dff:	8b 40 04             	mov    0x4(%eax),%eax
  802e02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e05:	89 10                	mov    %edx,(%eax)
  802e07:	eb 08                	jmp    802e11 <merging+0x210>
  802e09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e17:	89 50 04             	mov    %edx,0x4(%eax)
  802e1a:	a1 38 50 80 00       	mov    0x805038,%eax
  802e1f:	40                   	inc    %eax
  802e20:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e29:	75 17                	jne    802e42 <merging+0x241>
  802e2b:	83 ec 04             	sub    $0x4,%esp
  802e2e:	68 a3 42 80 00       	push   $0x8042a3
  802e33:	68 8e 01 00 00       	push   $0x18e
  802e38:	68 c1 42 80 00       	push   $0x8042c1
  802e3d:	e8 0e d4 ff ff       	call   800250 <_panic>
  802e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e45:	8b 00                	mov    (%eax),%eax
  802e47:	85 c0                	test   %eax,%eax
  802e49:	74 10                	je     802e5b <merging+0x25a>
  802e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e53:	8b 52 04             	mov    0x4(%edx),%edx
  802e56:	89 50 04             	mov    %edx,0x4(%eax)
  802e59:	eb 0b                	jmp    802e66 <merging+0x265>
  802e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5e:	8b 40 04             	mov    0x4(%eax),%eax
  802e61:	a3 30 50 80 00       	mov    %eax,0x805030
  802e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e69:	8b 40 04             	mov    0x4(%eax),%eax
  802e6c:	85 c0                	test   %eax,%eax
  802e6e:	74 0f                	je     802e7f <merging+0x27e>
  802e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e73:	8b 40 04             	mov    0x4(%eax),%eax
  802e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e79:	8b 12                	mov    (%edx),%edx
  802e7b:	89 10                	mov    %edx,(%eax)
  802e7d:	eb 0a                	jmp    802e89 <merging+0x288>
  802e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e82:	8b 00                	mov    (%eax),%eax
  802e84:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9c:	a1 38 50 80 00       	mov    0x805038,%eax
  802ea1:	48                   	dec    %eax
  802ea2:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ea7:	e9 72 01 00 00       	jmp    80301e <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802eac:	8b 45 10             	mov    0x10(%ebp),%eax
  802eaf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802eb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb6:	74 79                	je     802f31 <merging+0x330>
  802eb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ebc:	74 73                	je     802f31 <merging+0x330>
  802ebe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec2:	74 06                	je     802eca <merging+0x2c9>
  802ec4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ec8:	75 17                	jne    802ee1 <merging+0x2e0>
  802eca:	83 ec 04             	sub    $0x4,%esp
  802ecd:	68 34 43 80 00       	push   $0x804334
  802ed2:	68 94 01 00 00       	push   $0x194
  802ed7:	68 c1 42 80 00       	push   $0x8042c1
  802edc:	e8 6f d3 ff ff       	call   800250 <_panic>
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	8b 10                	mov    (%eax),%edx
  802ee6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee9:	89 10                	mov    %edx,(%eax)
  802eeb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eee:	8b 00                	mov    (%eax),%eax
  802ef0:	85 c0                	test   %eax,%eax
  802ef2:	74 0b                	je     802eff <merging+0x2fe>
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	8b 00                	mov    (%eax),%eax
  802ef9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802efc:	89 50 04             	mov    %edx,0x4(%eax)
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f05:	89 10                	mov    %edx,(%eax)
  802f07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0d:	89 50 04             	mov    %edx,0x4(%eax)
  802f10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f13:	8b 00                	mov    (%eax),%eax
  802f15:	85 c0                	test   %eax,%eax
  802f17:	75 08                	jne    802f21 <merging+0x320>
  802f19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1c:	a3 30 50 80 00       	mov    %eax,0x805030
  802f21:	a1 38 50 80 00       	mov    0x805038,%eax
  802f26:	40                   	inc    %eax
  802f27:	a3 38 50 80 00       	mov    %eax,0x805038
  802f2c:	e9 ce 00 00 00       	jmp    802fff <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f35:	74 65                	je     802f9c <merging+0x39b>
  802f37:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f3b:	75 17                	jne    802f54 <merging+0x353>
  802f3d:	83 ec 04             	sub    $0x4,%esp
  802f40:	68 10 43 80 00       	push   $0x804310
  802f45:	68 95 01 00 00       	push   $0x195
  802f4a:	68 c1 42 80 00       	push   $0x8042c1
  802f4f:	e8 fc d2 ff ff       	call   800250 <_panic>
  802f54:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5d:	89 50 04             	mov    %edx,0x4(%eax)
  802f60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f63:	8b 40 04             	mov    0x4(%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 0c                	je     802f76 <merging+0x375>
  802f6a:	a1 30 50 80 00       	mov    0x805030,%eax
  802f6f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f72:	89 10                	mov    %edx,(%eax)
  802f74:	eb 08                	jmp    802f7e <merging+0x37d>
  802f76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f79:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f81:	a3 30 50 80 00       	mov    %eax,0x805030
  802f86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8f:	a1 38 50 80 00       	mov    0x805038,%eax
  802f94:	40                   	inc    %eax
  802f95:	a3 38 50 80 00       	mov    %eax,0x805038
  802f9a:	eb 63                	jmp    802fff <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fa0:	75 17                	jne    802fb9 <merging+0x3b8>
  802fa2:	83 ec 04             	sub    $0x4,%esp
  802fa5:	68 dc 42 80 00       	push   $0x8042dc
  802faa:	68 98 01 00 00       	push   $0x198
  802faf:	68 c1 42 80 00       	push   $0x8042c1
  802fb4:	e8 97 d2 ff ff       	call   800250 <_panic>
  802fb9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802fbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc2:	89 10                	mov    %edx,(%eax)
  802fc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc7:	8b 00                	mov    (%eax),%eax
  802fc9:	85 c0                	test   %eax,%eax
  802fcb:	74 0d                	je     802fda <merging+0x3d9>
  802fcd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fd2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fd5:	89 50 04             	mov    %edx,0x4(%eax)
  802fd8:	eb 08                	jmp    802fe2 <merging+0x3e1>
  802fda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdd:	a3 30 50 80 00       	mov    %eax,0x805030
  802fe2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff4:	a1 38 50 80 00       	mov    0x805038,%eax
  802ff9:	40                   	inc    %eax
  802ffa:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802fff:	83 ec 0c             	sub    $0xc,%esp
  803002:	ff 75 10             	pushl  0x10(%ebp)
  803005:	e8 f9 ed ff ff       	call   801e03 <get_block_size>
  80300a:	83 c4 10             	add    $0x10,%esp
  80300d:	83 ec 04             	sub    $0x4,%esp
  803010:	6a 00                	push   $0x0
  803012:	50                   	push   %eax
  803013:	ff 75 10             	pushl  0x10(%ebp)
  803016:	e8 39 f1 ff ff       	call   802154 <set_block_data>
  80301b:	83 c4 10             	add    $0x10,%esp
	}
}
  80301e:	90                   	nop
  80301f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803022:	c9                   	leave  
  803023:	c3                   	ret    

00803024 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803024:	55                   	push   %ebp
  803025:	89 e5                	mov    %esp,%ebp
  803027:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80302a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80302f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803032:	a1 30 50 80 00       	mov    0x805030,%eax
  803037:	3b 45 08             	cmp    0x8(%ebp),%eax
  80303a:	73 1b                	jae    803057 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80303c:	a1 30 50 80 00       	mov    0x805030,%eax
  803041:	83 ec 04             	sub    $0x4,%esp
  803044:	ff 75 08             	pushl  0x8(%ebp)
  803047:	6a 00                	push   $0x0
  803049:	50                   	push   %eax
  80304a:	e8 b2 fb ff ff       	call   802c01 <merging>
  80304f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803052:	e9 8b 00 00 00       	jmp    8030e2 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803057:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80305c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80305f:	76 18                	jbe    803079 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803061:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803066:	83 ec 04             	sub    $0x4,%esp
  803069:	ff 75 08             	pushl  0x8(%ebp)
  80306c:	50                   	push   %eax
  80306d:	6a 00                	push   $0x0
  80306f:	e8 8d fb ff ff       	call   802c01 <merging>
  803074:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803077:	eb 69                	jmp    8030e2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803079:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80307e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803081:	eb 39                	jmp    8030bc <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	3b 45 08             	cmp    0x8(%ebp),%eax
  803089:	73 29                	jae    8030b4 <free_block+0x90>
  80308b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	3b 45 08             	cmp    0x8(%ebp),%eax
  803093:	76 1f                	jbe    8030b4 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	8b 00                	mov    (%eax),%eax
  80309a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80309d:	83 ec 04             	sub    $0x4,%esp
  8030a0:	ff 75 08             	pushl  0x8(%ebp)
  8030a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8030a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8030a9:	e8 53 fb ff ff       	call   802c01 <merging>
  8030ae:	83 c4 10             	add    $0x10,%esp
			break;
  8030b1:	90                   	nop
		}
	}
}
  8030b2:	eb 2e                	jmp    8030e2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030b4:	a1 34 50 80 00       	mov    0x805034,%eax
  8030b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c0:	74 07                	je     8030c9 <free_block+0xa5>
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	8b 00                	mov    (%eax),%eax
  8030c7:	eb 05                	jmp    8030ce <free_block+0xaa>
  8030c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ce:	a3 34 50 80 00       	mov    %eax,0x805034
  8030d3:	a1 34 50 80 00       	mov    0x805034,%eax
  8030d8:	85 c0                	test   %eax,%eax
  8030da:	75 a7                	jne    803083 <free_block+0x5f>
  8030dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e0:	75 a1                	jne    803083 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030e2:	90                   	nop
  8030e3:	c9                   	leave  
  8030e4:	c3                   	ret    

008030e5 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8030e5:	55                   	push   %ebp
  8030e6:	89 e5                	mov    %esp,%ebp
  8030e8:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8030eb:	ff 75 08             	pushl  0x8(%ebp)
  8030ee:	e8 10 ed ff ff       	call   801e03 <get_block_size>
  8030f3:	83 c4 04             	add    $0x4,%esp
  8030f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8030f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803100:	eb 17                	jmp    803119 <copy_data+0x34>
  803102:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803105:	8b 45 0c             	mov    0xc(%ebp),%eax
  803108:	01 c2                	add    %eax,%edx
  80310a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	01 c8                	add    %ecx,%eax
  803112:	8a 00                	mov    (%eax),%al
  803114:	88 02                	mov    %al,(%edx)
  803116:	ff 45 fc             	incl   -0x4(%ebp)
  803119:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80311c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80311f:	72 e1                	jb     803102 <copy_data+0x1d>
}
  803121:	90                   	nop
  803122:	c9                   	leave  
  803123:	c3                   	ret    

00803124 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803124:	55                   	push   %ebp
  803125:	89 e5                	mov    %esp,%ebp
  803127:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80312a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312e:	75 23                	jne    803153 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803130:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803134:	74 13                	je     803149 <realloc_block_FF+0x25>
  803136:	83 ec 0c             	sub    $0xc,%esp
  803139:	ff 75 0c             	pushl  0xc(%ebp)
  80313c:	e8 42 f0 ff ff       	call   802183 <alloc_block_FF>
  803141:	83 c4 10             	add    $0x10,%esp
  803144:	e9 e4 06 00 00       	jmp    80382d <realloc_block_FF+0x709>
		return NULL;
  803149:	b8 00 00 00 00       	mov    $0x0,%eax
  80314e:	e9 da 06 00 00       	jmp    80382d <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803153:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803157:	75 18                	jne    803171 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803159:	83 ec 0c             	sub    $0xc,%esp
  80315c:	ff 75 08             	pushl  0x8(%ebp)
  80315f:	e8 c0 fe ff ff       	call   803024 <free_block>
  803164:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803167:	b8 00 00 00 00       	mov    $0x0,%eax
  80316c:	e9 bc 06 00 00       	jmp    80382d <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803171:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803175:	77 07                	ja     80317e <realloc_block_FF+0x5a>
  803177:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80317e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803181:	83 e0 01             	and    $0x1,%eax
  803184:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318a:	83 c0 08             	add    $0x8,%eax
  80318d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803190:	83 ec 0c             	sub    $0xc,%esp
  803193:	ff 75 08             	pushl  0x8(%ebp)
  803196:	e8 68 ec ff ff       	call   801e03 <get_block_size>
  80319b:	83 c4 10             	add    $0x10,%esp
  80319e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a4:	83 e8 08             	sub    $0x8,%eax
  8031a7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	83 e8 04             	sub    $0x4,%eax
  8031b0:	8b 00                	mov    (%eax),%eax
  8031b2:	83 e0 fe             	and    $0xfffffffe,%eax
  8031b5:	89 c2                	mov    %eax,%edx
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	01 d0                	add    %edx,%eax
  8031bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031bf:	83 ec 0c             	sub    $0xc,%esp
  8031c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031c5:	e8 39 ec ff ff       	call   801e03 <get_block_size>
  8031ca:	83 c4 10             	add    $0x10,%esp
  8031cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d3:	83 e8 08             	sub    $0x8,%eax
  8031d6:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8031d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031dc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031df:	75 08                	jne    8031e9 <realloc_block_FF+0xc5>
	{
		 return va;
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	e9 44 06 00 00       	jmp    80382d <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8031e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ec:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031ef:	0f 83 d5 03 00 00    	jae    8035ca <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8031f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f8:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8031fe:	83 ec 0c             	sub    $0xc,%esp
  803201:	ff 75 e4             	pushl  -0x1c(%ebp)
  803204:	e8 13 ec ff ff       	call   801e1c <is_free_block>
  803209:	83 c4 10             	add    $0x10,%esp
  80320c:	84 c0                	test   %al,%al
  80320e:	0f 84 3b 01 00 00    	je     80334f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803214:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80321a:	01 d0                	add    %edx,%eax
  80321c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80321f:	83 ec 04             	sub    $0x4,%esp
  803222:	6a 01                	push   $0x1
  803224:	ff 75 f0             	pushl  -0x10(%ebp)
  803227:	ff 75 08             	pushl  0x8(%ebp)
  80322a:	e8 25 ef ff ff       	call   802154 <set_block_data>
  80322f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	83 e8 04             	sub    $0x4,%eax
  803238:	8b 00                	mov    (%eax),%eax
  80323a:	83 e0 fe             	and    $0xfffffffe,%eax
  80323d:	89 c2                	mov    %eax,%edx
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	01 d0                	add    %edx,%eax
  803244:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803247:	83 ec 04             	sub    $0x4,%esp
  80324a:	6a 00                	push   $0x0
  80324c:	ff 75 cc             	pushl  -0x34(%ebp)
  80324f:	ff 75 c8             	pushl  -0x38(%ebp)
  803252:	e8 fd ee ff ff       	call   802154 <set_block_data>
  803257:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80325a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80325e:	74 06                	je     803266 <realloc_block_FF+0x142>
  803260:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803264:	75 17                	jne    80327d <realloc_block_FF+0x159>
  803266:	83 ec 04             	sub    $0x4,%esp
  803269:	68 34 43 80 00       	push   $0x804334
  80326e:	68 f6 01 00 00       	push   $0x1f6
  803273:	68 c1 42 80 00       	push   $0x8042c1
  803278:	e8 d3 cf ff ff       	call   800250 <_panic>
  80327d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803280:	8b 10                	mov    (%eax),%edx
  803282:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803285:	89 10                	mov    %edx,(%eax)
  803287:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	74 0b                	je     80329b <realloc_block_FF+0x177>
  803290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803293:	8b 00                	mov    (%eax),%eax
  803295:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803298:	89 50 04             	mov    %edx,0x4(%eax)
  80329b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032a1:	89 10                	mov    %edx,(%eax)
  8032a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032a9:	89 50 04             	mov    %edx,0x4(%eax)
  8032ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	85 c0                	test   %eax,%eax
  8032b3:	75 08                	jne    8032bd <realloc_block_FF+0x199>
  8032b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8032bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8032c2:	40                   	inc    %eax
  8032c3:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032cc:	75 17                	jne    8032e5 <realloc_block_FF+0x1c1>
  8032ce:	83 ec 04             	sub    $0x4,%esp
  8032d1:	68 a3 42 80 00       	push   $0x8042a3
  8032d6:	68 f7 01 00 00       	push   $0x1f7
  8032db:	68 c1 42 80 00       	push   $0x8042c1
  8032e0:	e8 6b cf ff ff       	call   800250 <_panic>
  8032e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e8:	8b 00                	mov    (%eax),%eax
  8032ea:	85 c0                	test   %eax,%eax
  8032ec:	74 10                	je     8032fe <realloc_block_FF+0x1da>
  8032ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032f6:	8b 52 04             	mov    0x4(%edx),%edx
  8032f9:	89 50 04             	mov    %edx,0x4(%eax)
  8032fc:	eb 0b                	jmp    803309 <realloc_block_FF+0x1e5>
  8032fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803301:	8b 40 04             	mov    0x4(%eax),%eax
  803304:	a3 30 50 80 00       	mov    %eax,0x805030
  803309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330c:	8b 40 04             	mov    0x4(%eax),%eax
  80330f:	85 c0                	test   %eax,%eax
  803311:	74 0f                	je     803322 <realloc_block_FF+0x1fe>
  803313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803316:	8b 40 04             	mov    0x4(%eax),%eax
  803319:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80331c:	8b 12                	mov    (%edx),%edx
  80331e:	89 10                	mov    %edx,(%eax)
  803320:	eb 0a                	jmp    80332c <realloc_block_FF+0x208>
  803322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80332c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803335:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803338:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333f:	a1 38 50 80 00       	mov    0x805038,%eax
  803344:	48                   	dec    %eax
  803345:	a3 38 50 80 00       	mov    %eax,0x805038
  80334a:	e9 73 02 00 00       	jmp    8035c2 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80334f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803353:	0f 86 69 02 00 00    	jbe    8035c2 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803359:	83 ec 04             	sub    $0x4,%esp
  80335c:	6a 01                	push   $0x1
  80335e:	ff 75 f0             	pushl  -0x10(%ebp)
  803361:	ff 75 08             	pushl  0x8(%ebp)
  803364:	e8 eb ed ff ff       	call   802154 <set_block_data>
  803369:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	83 e8 04             	sub    $0x4,%eax
  803372:	8b 00                	mov    (%eax),%eax
  803374:	83 e0 fe             	and    $0xfffffffe,%eax
  803377:	89 c2                	mov    %eax,%edx
  803379:	8b 45 08             	mov    0x8(%ebp),%eax
  80337c:	01 d0                	add    %edx,%eax
  80337e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803381:	a1 38 50 80 00       	mov    0x805038,%eax
  803386:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803389:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80338d:	75 68                	jne    8033f7 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80338f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803393:	75 17                	jne    8033ac <realloc_block_FF+0x288>
  803395:	83 ec 04             	sub    $0x4,%esp
  803398:	68 dc 42 80 00       	push   $0x8042dc
  80339d:	68 06 02 00 00       	push   $0x206
  8033a2:	68 c1 42 80 00       	push   $0x8042c1
  8033a7:	e8 a4 ce ff ff       	call   800250 <_panic>
  8033ac:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b5:	89 10                	mov    %edx,(%eax)
  8033b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ba:	8b 00                	mov    (%eax),%eax
  8033bc:	85 c0                	test   %eax,%eax
  8033be:	74 0d                	je     8033cd <realloc_block_FF+0x2a9>
  8033c0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033c8:	89 50 04             	mov    %edx,0x4(%eax)
  8033cb:	eb 08                	jmp    8033d5 <realloc_block_FF+0x2b1>
  8033cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8033d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e7:	a1 38 50 80 00       	mov    0x805038,%eax
  8033ec:	40                   	inc    %eax
  8033ed:	a3 38 50 80 00       	mov    %eax,0x805038
  8033f2:	e9 b0 01 00 00       	jmp    8035a7 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8033f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033fc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033ff:	76 68                	jbe    803469 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803401:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803405:	75 17                	jne    80341e <realloc_block_FF+0x2fa>
  803407:	83 ec 04             	sub    $0x4,%esp
  80340a:	68 dc 42 80 00       	push   $0x8042dc
  80340f:	68 0b 02 00 00       	push   $0x20b
  803414:	68 c1 42 80 00       	push   $0x8042c1
  803419:	e8 32 ce ff ff       	call   800250 <_panic>
  80341e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803424:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803427:	89 10                	mov    %edx,(%eax)
  803429:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342c:	8b 00                	mov    (%eax),%eax
  80342e:	85 c0                	test   %eax,%eax
  803430:	74 0d                	je     80343f <realloc_block_FF+0x31b>
  803432:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803437:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80343a:	89 50 04             	mov    %edx,0x4(%eax)
  80343d:	eb 08                	jmp    803447 <realloc_block_FF+0x323>
  80343f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803442:	a3 30 50 80 00       	mov    %eax,0x805030
  803447:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80344f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803452:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803459:	a1 38 50 80 00       	mov    0x805038,%eax
  80345e:	40                   	inc    %eax
  80345f:	a3 38 50 80 00       	mov    %eax,0x805038
  803464:	e9 3e 01 00 00       	jmp    8035a7 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803469:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80346e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803471:	73 68                	jae    8034db <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803473:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803477:	75 17                	jne    803490 <realloc_block_FF+0x36c>
  803479:	83 ec 04             	sub    $0x4,%esp
  80347c:	68 10 43 80 00       	push   $0x804310
  803481:	68 10 02 00 00       	push   $0x210
  803486:	68 c1 42 80 00       	push   $0x8042c1
  80348b:	e8 c0 cd ff ff       	call   800250 <_panic>
  803490:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803496:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803499:	89 50 04             	mov    %edx,0x4(%eax)
  80349c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349f:	8b 40 04             	mov    0x4(%eax),%eax
  8034a2:	85 c0                	test   %eax,%eax
  8034a4:	74 0c                	je     8034b2 <realloc_block_FF+0x38e>
  8034a6:	a1 30 50 80 00       	mov    0x805030,%eax
  8034ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034ae:	89 10                	mov    %edx,(%eax)
  8034b0:	eb 08                	jmp    8034ba <realloc_block_FF+0x396>
  8034b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8034c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8034d0:	40                   	inc    %eax
  8034d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8034d6:	e9 cc 00 00 00       	jmp    8035a7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8034db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8034e2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034ea:	e9 8a 00 00 00       	jmp    803579 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034f5:	73 7a                	jae    803571 <realloc_block_FF+0x44d>
  8034f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fa:	8b 00                	mov    (%eax),%eax
  8034fc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034ff:	73 70                	jae    803571 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803501:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803505:	74 06                	je     80350d <realloc_block_FF+0x3e9>
  803507:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80350b:	75 17                	jne    803524 <realloc_block_FF+0x400>
  80350d:	83 ec 04             	sub    $0x4,%esp
  803510:	68 34 43 80 00       	push   $0x804334
  803515:	68 1a 02 00 00       	push   $0x21a
  80351a:	68 c1 42 80 00       	push   $0x8042c1
  80351f:	e8 2c cd ff ff       	call   800250 <_panic>
  803524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803527:	8b 10                	mov    (%eax),%edx
  803529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352c:	89 10                	mov    %edx,(%eax)
  80352e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803531:	8b 00                	mov    (%eax),%eax
  803533:	85 c0                	test   %eax,%eax
  803535:	74 0b                	je     803542 <realloc_block_FF+0x41e>
  803537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353a:	8b 00                	mov    (%eax),%eax
  80353c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80353f:	89 50 04             	mov    %edx,0x4(%eax)
  803542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803545:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803548:	89 10                	mov    %edx,(%eax)
  80354a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803550:	89 50 04             	mov    %edx,0x4(%eax)
  803553:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803556:	8b 00                	mov    (%eax),%eax
  803558:	85 c0                	test   %eax,%eax
  80355a:	75 08                	jne    803564 <realloc_block_FF+0x440>
  80355c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355f:	a3 30 50 80 00       	mov    %eax,0x805030
  803564:	a1 38 50 80 00       	mov    0x805038,%eax
  803569:	40                   	inc    %eax
  80356a:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80356f:	eb 36                	jmp    8035a7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803571:	a1 34 50 80 00       	mov    0x805034,%eax
  803576:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80357d:	74 07                	je     803586 <realloc_block_FF+0x462>
  80357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803582:	8b 00                	mov    (%eax),%eax
  803584:	eb 05                	jmp    80358b <realloc_block_FF+0x467>
  803586:	b8 00 00 00 00       	mov    $0x0,%eax
  80358b:	a3 34 50 80 00       	mov    %eax,0x805034
  803590:	a1 34 50 80 00       	mov    0x805034,%eax
  803595:	85 c0                	test   %eax,%eax
  803597:	0f 85 52 ff ff ff    	jne    8034ef <realloc_block_FF+0x3cb>
  80359d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a1:	0f 85 48 ff ff ff    	jne    8034ef <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035a7:	83 ec 04             	sub    $0x4,%esp
  8035aa:	6a 00                	push   $0x0
  8035ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8035af:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035b2:	e8 9d eb ff ff       	call   802154 <set_block_data>
  8035b7:	83 c4 10             	add    $0x10,%esp
				return va;
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	e9 6b 02 00 00       	jmp    80382d <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	e9 63 02 00 00       	jmp    80382d <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8035ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035cd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035d0:	0f 86 4d 02 00 00    	jbe    803823 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8035d6:	83 ec 0c             	sub    $0xc,%esp
  8035d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035dc:	e8 3b e8 ff ff       	call   801e1c <is_free_block>
  8035e1:	83 c4 10             	add    $0x10,%esp
  8035e4:	84 c0                	test   %al,%al
  8035e6:	0f 84 37 02 00 00    	je     803823 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8035ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ef:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8035f2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8035f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035f8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035fb:	76 38                	jbe    803635 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8035fd:	83 ec 0c             	sub    $0xc,%esp
  803600:	ff 75 0c             	pushl  0xc(%ebp)
  803603:	e8 7b eb ff ff       	call   802183 <alloc_block_FF>
  803608:	83 c4 10             	add    $0x10,%esp
  80360b:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80360e:	83 ec 08             	sub    $0x8,%esp
  803611:	ff 75 c0             	pushl  -0x40(%ebp)
  803614:	ff 75 08             	pushl  0x8(%ebp)
  803617:	e8 c9 fa ff ff       	call   8030e5 <copy_data>
  80361c:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80361f:	83 ec 0c             	sub    $0xc,%esp
  803622:	ff 75 08             	pushl  0x8(%ebp)
  803625:	e8 fa f9 ff ff       	call   803024 <free_block>
  80362a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80362d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803630:	e9 f8 01 00 00       	jmp    80382d <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803635:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803638:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80363b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80363e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803642:	0f 87 a0 00 00 00    	ja     8036e8 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803648:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80364c:	75 17                	jne    803665 <realloc_block_FF+0x541>
  80364e:	83 ec 04             	sub    $0x4,%esp
  803651:	68 a3 42 80 00       	push   $0x8042a3
  803656:	68 38 02 00 00       	push   $0x238
  80365b:	68 c1 42 80 00       	push   $0x8042c1
  803660:	e8 eb cb ff ff       	call   800250 <_panic>
  803665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	85 c0                	test   %eax,%eax
  80366c:	74 10                	je     80367e <realloc_block_FF+0x55a>
  80366e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803671:	8b 00                	mov    (%eax),%eax
  803673:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803676:	8b 52 04             	mov    0x4(%edx),%edx
  803679:	89 50 04             	mov    %edx,0x4(%eax)
  80367c:	eb 0b                	jmp    803689 <realloc_block_FF+0x565>
  80367e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803681:	8b 40 04             	mov    0x4(%eax),%eax
  803684:	a3 30 50 80 00       	mov    %eax,0x805030
  803689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368c:	8b 40 04             	mov    0x4(%eax),%eax
  80368f:	85 c0                	test   %eax,%eax
  803691:	74 0f                	je     8036a2 <realloc_block_FF+0x57e>
  803693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803696:	8b 40 04             	mov    0x4(%eax),%eax
  803699:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80369c:	8b 12                	mov    (%edx),%edx
  80369e:	89 10                	mov    %edx,(%eax)
  8036a0:	eb 0a                	jmp    8036ac <realloc_block_FF+0x588>
  8036a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a5:	8b 00                	mov    (%eax),%eax
  8036a7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036bf:	a1 38 50 80 00       	mov    0x805038,%eax
  8036c4:	48                   	dec    %eax
  8036c5:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8036ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d0:	01 d0                	add    %edx,%eax
  8036d2:	83 ec 04             	sub    $0x4,%esp
  8036d5:	6a 01                	push   $0x1
  8036d7:	50                   	push   %eax
  8036d8:	ff 75 08             	pushl  0x8(%ebp)
  8036db:	e8 74 ea ff ff       	call   802154 <set_block_data>
  8036e0:	83 c4 10             	add    $0x10,%esp
  8036e3:	e9 36 01 00 00       	jmp    80381e <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8036e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036ee:	01 d0                	add    %edx,%eax
  8036f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	6a 01                	push   $0x1
  8036f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8036fb:	ff 75 08             	pushl  0x8(%ebp)
  8036fe:	e8 51 ea ff ff       	call   802154 <set_block_data>
  803703:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803706:	8b 45 08             	mov    0x8(%ebp),%eax
  803709:	83 e8 04             	sub    $0x4,%eax
  80370c:	8b 00                	mov    (%eax),%eax
  80370e:	83 e0 fe             	and    $0xfffffffe,%eax
  803711:	89 c2                	mov    %eax,%edx
  803713:	8b 45 08             	mov    0x8(%ebp),%eax
  803716:	01 d0                	add    %edx,%eax
  803718:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80371b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80371f:	74 06                	je     803727 <realloc_block_FF+0x603>
  803721:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803725:	75 17                	jne    80373e <realloc_block_FF+0x61a>
  803727:	83 ec 04             	sub    $0x4,%esp
  80372a:	68 34 43 80 00       	push   $0x804334
  80372f:	68 44 02 00 00       	push   $0x244
  803734:	68 c1 42 80 00       	push   $0x8042c1
  803739:	e8 12 cb ff ff       	call   800250 <_panic>
  80373e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803741:	8b 10                	mov    (%eax),%edx
  803743:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803746:	89 10                	mov    %edx,(%eax)
  803748:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	85 c0                	test   %eax,%eax
  80374f:	74 0b                	je     80375c <realloc_block_FF+0x638>
  803751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803754:	8b 00                	mov    (%eax),%eax
  803756:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803759:	89 50 04             	mov    %edx,0x4(%eax)
  80375c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803762:	89 10                	mov    %edx,(%eax)
  803764:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803767:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80376a:	89 50 04             	mov    %edx,0x4(%eax)
  80376d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803770:	8b 00                	mov    (%eax),%eax
  803772:	85 c0                	test   %eax,%eax
  803774:	75 08                	jne    80377e <realloc_block_FF+0x65a>
  803776:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803779:	a3 30 50 80 00       	mov    %eax,0x805030
  80377e:	a1 38 50 80 00       	mov    0x805038,%eax
  803783:	40                   	inc    %eax
  803784:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803789:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80378d:	75 17                	jne    8037a6 <realloc_block_FF+0x682>
  80378f:	83 ec 04             	sub    $0x4,%esp
  803792:	68 a3 42 80 00       	push   $0x8042a3
  803797:	68 45 02 00 00       	push   $0x245
  80379c:	68 c1 42 80 00       	push   $0x8042c1
  8037a1:	e8 aa ca ff ff       	call   800250 <_panic>
  8037a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a9:	8b 00                	mov    (%eax),%eax
  8037ab:	85 c0                	test   %eax,%eax
  8037ad:	74 10                	je     8037bf <realloc_block_FF+0x69b>
  8037af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b2:	8b 00                	mov    (%eax),%eax
  8037b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037b7:	8b 52 04             	mov    0x4(%edx),%edx
  8037ba:	89 50 04             	mov    %edx,0x4(%eax)
  8037bd:	eb 0b                	jmp    8037ca <realloc_block_FF+0x6a6>
  8037bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c2:	8b 40 04             	mov    0x4(%eax),%eax
  8037c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8037ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cd:	8b 40 04             	mov    0x4(%eax),%eax
  8037d0:	85 c0                	test   %eax,%eax
  8037d2:	74 0f                	je     8037e3 <realloc_block_FF+0x6bf>
  8037d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d7:	8b 40 04             	mov    0x4(%eax),%eax
  8037da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037dd:	8b 12                	mov    (%edx),%edx
  8037df:	89 10                	mov    %edx,(%eax)
  8037e1:	eb 0a                	jmp    8037ed <realloc_block_FF+0x6c9>
  8037e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e6:	8b 00                	mov    (%eax),%eax
  8037e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803800:	a1 38 50 80 00       	mov    0x805038,%eax
  803805:	48                   	dec    %eax
  803806:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80380b:	83 ec 04             	sub    $0x4,%esp
  80380e:	6a 00                	push   $0x0
  803810:	ff 75 bc             	pushl  -0x44(%ebp)
  803813:	ff 75 b8             	pushl  -0x48(%ebp)
  803816:	e8 39 e9 ff ff       	call   802154 <set_block_data>
  80381b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80381e:	8b 45 08             	mov    0x8(%ebp),%eax
  803821:	eb 0a                	jmp    80382d <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803823:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80382a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80382d:	c9                   	leave  
  80382e:	c3                   	ret    

0080382f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80382f:	55                   	push   %ebp
  803830:	89 e5                	mov    %esp,%ebp
  803832:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803835:	83 ec 04             	sub    $0x4,%esp
  803838:	68 a0 43 80 00       	push   $0x8043a0
  80383d:	68 58 02 00 00       	push   $0x258
  803842:	68 c1 42 80 00       	push   $0x8042c1
  803847:	e8 04 ca ff ff       	call   800250 <_panic>

0080384c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80384c:	55                   	push   %ebp
  80384d:	89 e5                	mov    %esp,%ebp
  80384f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803852:	83 ec 04             	sub    $0x4,%esp
  803855:	68 c8 43 80 00       	push   $0x8043c8
  80385a:	68 61 02 00 00       	push   $0x261
  80385f:	68 c1 42 80 00       	push   $0x8042c1
  803864:	e8 e7 c9 ff ff       	call   800250 <_panic>
  803869:	66 90                	xchg   %ax,%ax
  80386b:	90                   	nop

0080386c <__udivdi3>:
  80386c:	55                   	push   %ebp
  80386d:	57                   	push   %edi
  80386e:	56                   	push   %esi
  80386f:	53                   	push   %ebx
  803870:	83 ec 1c             	sub    $0x1c,%esp
  803873:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803877:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80387b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80387f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803883:	89 ca                	mov    %ecx,%edx
  803885:	89 f8                	mov    %edi,%eax
  803887:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80388b:	85 f6                	test   %esi,%esi
  80388d:	75 2d                	jne    8038bc <__udivdi3+0x50>
  80388f:	39 cf                	cmp    %ecx,%edi
  803891:	77 65                	ja     8038f8 <__udivdi3+0x8c>
  803893:	89 fd                	mov    %edi,%ebp
  803895:	85 ff                	test   %edi,%edi
  803897:	75 0b                	jne    8038a4 <__udivdi3+0x38>
  803899:	b8 01 00 00 00       	mov    $0x1,%eax
  80389e:	31 d2                	xor    %edx,%edx
  8038a0:	f7 f7                	div    %edi
  8038a2:	89 c5                	mov    %eax,%ebp
  8038a4:	31 d2                	xor    %edx,%edx
  8038a6:	89 c8                	mov    %ecx,%eax
  8038a8:	f7 f5                	div    %ebp
  8038aa:	89 c1                	mov    %eax,%ecx
  8038ac:	89 d8                	mov    %ebx,%eax
  8038ae:	f7 f5                	div    %ebp
  8038b0:	89 cf                	mov    %ecx,%edi
  8038b2:	89 fa                	mov    %edi,%edx
  8038b4:	83 c4 1c             	add    $0x1c,%esp
  8038b7:	5b                   	pop    %ebx
  8038b8:	5e                   	pop    %esi
  8038b9:	5f                   	pop    %edi
  8038ba:	5d                   	pop    %ebp
  8038bb:	c3                   	ret    
  8038bc:	39 ce                	cmp    %ecx,%esi
  8038be:	77 28                	ja     8038e8 <__udivdi3+0x7c>
  8038c0:	0f bd fe             	bsr    %esi,%edi
  8038c3:	83 f7 1f             	xor    $0x1f,%edi
  8038c6:	75 40                	jne    803908 <__udivdi3+0x9c>
  8038c8:	39 ce                	cmp    %ecx,%esi
  8038ca:	72 0a                	jb     8038d6 <__udivdi3+0x6a>
  8038cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038d0:	0f 87 9e 00 00 00    	ja     803974 <__udivdi3+0x108>
  8038d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038db:	89 fa                	mov    %edi,%edx
  8038dd:	83 c4 1c             	add    $0x1c,%esp
  8038e0:	5b                   	pop    %ebx
  8038e1:	5e                   	pop    %esi
  8038e2:	5f                   	pop    %edi
  8038e3:	5d                   	pop    %ebp
  8038e4:	c3                   	ret    
  8038e5:	8d 76 00             	lea    0x0(%esi),%esi
  8038e8:	31 ff                	xor    %edi,%edi
  8038ea:	31 c0                	xor    %eax,%eax
  8038ec:	89 fa                	mov    %edi,%edx
  8038ee:	83 c4 1c             	add    $0x1c,%esp
  8038f1:	5b                   	pop    %ebx
  8038f2:	5e                   	pop    %esi
  8038f3:	5f                   	pop    %edi
  8038f4:	5d                   	pop    %ebp
  8038f5:	c3                   	ret    
  8038f6:	66 90                	xchg   %ax,%ax
  8038f8:	89 d8                	mov    %ebx,%eax
  8038fa:	f7 f7                	div    %edi
  8038fc:	31 ff                	xor    %edi,%edi
  8038fe:	89 fa                	mov    %edi,%edx
  803900:	83 c4 1c             	add    $0x1c,%esp
  803903:	5b                   	pop    %ebx
  803904:	5e                   	pop    %esi
  803905:	5f                   	pop    %edi
  803906:	5d                   	pop    %ebp
  803907:	c3                   	ret    
  803908:	bd 20 00 00 00       	mov    $0x20,%ebp
  80390d:	89 eb                	mov    %ebp,%ebx
  80390f:	29 fb                	sub    %edi,%ebx
  803911:	89 f9                	mov    %edi,%ecx
  803913:	d3 e6                	shl    %cl,%esi
  803915:	89 c5                	mov    %eax,%ebp
  803917:	88 d9                	mov    %bl,%cl
  803919:	d3 ed                	shr    %cl,%ebp
  80391b:	89 e9                	mov    %ebp,%ecx
  80391d:	09 f1                	or     %esi,%ecx
  80391f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803923:	89 f9                	mov    %edi,%ecx
  803925:	d3 e0                	shl    %cl,%eax
  803927:	89 c5                	mov    %eax,%ebp
  803929:	89 d6                	mov    %edx,%esi
  80392b:	88 d9                	mov    %bl,%cl
  80392d:	d3 ee                	shr    %cl,%esi
  80392f:	89 f9                	mov    %edi,%ecx
  803931:	d3 e2                	shl    %cl,%edx
  803933:	8b 44 24 08          	mov    0x8(%esp),%eax
  803937:	88 d9                	mov    %bl,%cl
  803939:	d3 e8                	shr    %cl,%eax
  80393b:	09 c2                	or     %eax,%edx
  80393d:	89 d0                	mov    %edx,%eax
  80393f:	89 f2                	mov    %esi,%edx
  803941:	f7 74 24 0c          	divl   0xc(%esp)
  803945:	89 d6                	mov    %edx,%esi
  803947:	89 c3                	mov    %eax,%ebx
  803949:	f7 e5                	mul    %ebp
  80394b:	39 d6                	cmp    %edx,%esi
  80394d:	72 19                	jb     803968 <__udivdi3+0xfc>
  80394f:	74 0b                	je     80395c <__udivdi3+0xf0>
  803951:	89 d8                	mov    %ebx,%eax
  803953:	31 ff                	xor    %edi,%edi
  803955:	e9 58 ff ff ff       	jmp    8038b2 <__udivdi3+0x46>
  80395a:	66 90                	xchg   %ax,%ax
  80395c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803960:	89 f9                	mov    %edi,%ecx
  803962:	d3 e2                	shl    %cl,%edx
  803964:	39 c2                	cmp    %eax,%edx
  803966:	73 e9                	jae    803951 <__udivdi3+0xe5>
  803968:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80396b:	31 ff                	xor    %edi,%edi
  80396d:	e9 40 ff ff ff       	jmp    8038b2 <__udivdi3+0x46>
  803972:	66 90                	xchg   %ax,%ax
  803974:	31 c0                	xor    %eax,%eax
  803976:	e9 37 ff ff ff       	jmp    8038b2 <__udivdi3+0x46>
  80397b:	90                   	nop

0080397c <__umoddi3>:
  80397c:	55                   	push   %ebp
  80397d:	57                   	push   %edi
  80397e:	56                   	push   %esi
  80397f:	53                   	push   %ebx
  803980:	83 ec 1c             	sub    $0x1c,%esp
  803983:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803987:	8b 74 24 34          	mov    0x34(%esp),%esi
  80398b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80398f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803993:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803997:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80399b:	89 f3                	mov    %esi,%ebx
  80399d:	89 fa                	mov    %edi,%edx
  80399f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039a3:	89 34 24             	mov    %esi,(%esp)
  8039a6:	85 c0                	test   %eax,%eax
  8039a8:	75 1a                	jne    8039c4 <__umoddi3+0x48>
  8039aa:	39 f7                	cmp    %esi,%edi
  8039ac:	0f 86 a2 00 00 00    	jbe    803a54 <__umoddi3+0xd8>
  8039b2:	89 c8                	mov    %ecx,%eax
  8039b4:	89 f2                	mov    %esi,%edx
  8039b6:	f7 f7                	div    %edi
  8039b8:	89 d0                	mov    %edx,%eax
  8039ba:	31 d2                	xor    %edx,%edx
  8039bc:	83 c4 1c             	add    $0x1c,%esp
  8039bf:	5b                   	pop    %ebx
  8039c0:	5e                   	pop    %esi
  8039c1:	5f                   	pop    %edi
  8039c2:	5d                   	pop    %ebp
  8039c3:	c3                   	ret    
  8039c4:	39 f0                	cmp    %esi,%eax
  8039c6:	0f 87 ac 00 00 00    	ja     803a78 <__umoddi3+0xfc>
  8039cc:	0f bd e8             	bsr    %eax,%ebp
  8039cf:	83 f5 1f             	xor    $0x1f,%ebp
  8039d2:	0f 84 ac 00 00 00    	je     803a84 <__umoddi3+0x108>
  8039d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8039dd:	29 ef                	sub    %ebp,%edi
  8039df:	89 fe                	mov    %edi,%esi
  8039e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039e5:	89 e9                	mov    %ebp,%ecx
  8039e7:	d3 e0                	shl    %cl,%eax
  8039e9:	89 d7                	mov    %edx,%edi
  8039eb:	89 f1                	mov    %esi,%ecx
  8039ed:	d3 ef                	shr    %cl,%edi
  8039ef:	09 c7                	or     %eax,%edi
  8039f1:	89 e9                	mov    %ebp,%ecx
  8039f3:	d3 e2                	shl    %cl,%edx
  8039f5:	89 14 24             	mov    %edx,(%esp)
  8039f8:	89 d8                	mov    %ebx,%eax
  8039fa:	d3 e0                	shl    %cl,%eax
  8039fc:	89 c2                	mov    %eax,%edx
  8039fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a02:	d3 e0                	shl    %cl,%eax
  803a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a08:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a0c:	89 f1                	mov    %esi,%ecx
  803a0e:	d3 e8                	shr    %cl,%eax
  803a10:	09 d0                	or     %edx,%eax
  803a12:	d3 eb                	shr    %cl,%ebx
  803a14:	89 da                	mov    %ebx,%edx
  803a16:	f7 f7                	div    %edi
  803a18:	89 d3                	mov    %edx,%ebx
  803a1a:	f7 24 24             	mull   (%esp)
  803a1d:	89 c6                	mov    %eax,%esi
  803a1f:	89 d1                	mov    %edx,%ecx
  803a21:	39 d3                	cmp    %edx,%ebx
  803a23:	0f 82 87 00 00 00    	jb     803ab0 <__umoddi3+0x134>
  803a29:	0f 84 91 00 00 00    	je     803ac0 <__umoddi3+0x144>
  803a2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a33:	29 f2                	sub    %esi,%edx
  803a35:	19 cb                	sbb    %ecx,%ebx
  803a37:	89 d8                	mov    %ebx,%eax
  803a39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a3d:	d3 e0                	shl    %cl,%eax
  803a3f:	89 e9                	mov    %ebp,%ecx
  803a41:	d3 ea                	shr    %cl,%edx
  803a43:	09 d0                	or     %edx,%eax
  803a45:	89 e9                	mov    %ebp,%ecx
  803a47:	d3 eb                	shr    %cl,%ebx
  803a49:	89 da                	mov    %ebx,%edx
  803a4b:	83 c4 1c             	add    $0x1c,%esp
  803a4e:	5b                   	pop    %ebx
  803a4f:	5e                   	pop    %esi
  803a50:	5f                   	pop    %edi
  803a51:	5d                   	pop    %ebp
  803a52:	c3                   	ret    
  803a53:	90                   	nop
  803a54:	89 fd                	mov    %edi,%ebp
  803a56:	85 ff                	test   %edi,%edi
  803a58:	75 0b                	jne    803a65 <__umoddi3+0xe9>
  803a5a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a5f:	31 d2                	xor    %edx,%edx
  803a61:	f7 f7                	div    %edi
  803a63:	89 c5                	mov    %eax,%ebp
  803a65:	89 f0                	mov    %esi,%eax
  803a67:	31 d2                	xor    %edx,%edx
  803a69:	f7 f5                	div    %ebp
  803a6b:	89 c8                	mov    %ecx,%eax
  803a6d:	f7 f5                	div    %ebp
  803a6f:	89 d0                	mov    %edx,%eax
  803a71:	e9 44 ff ff ff       	jmp    8039ba <__umoddi3+0x3e>
  803a76:	66 90                	xchg   %ax,%ax
  803a78:	89 c8                	mov    %ecx,%eax
  803a7a:	89 f2                	mov    %esi,%edx
  803a7c:	83 c4 1c             	add    $0x1c,%esp
  803a7f:	5b                   	pop    %ebx
  803a80:	5e                   	pop    %esi
  803a81:	5f                   	pop    %edi
  803a82:	5d                   	pop    %ebp
  803a83:	c3                   	ret    
  803a84:	3b 04 24             	cmp    (%esp),%eax
  803a87:	72 06                	jb     803a8f <__umoddi3+0x113>
  803a89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a8d:	77 0f                	ja     803a9e <__umoddi3+0x122>
  803a8f:	89 f2                	mov    %esi,%edx
  803a91:	29 f9                	sub    %edi,%ecx
  803a93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a97:	89 14 24             	mov    %edx,(%esp)
  803a9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803aa2:	8b 14 24             	mov    (%esp),%edx
  803aa5:	83 c4 1c             	add    $0x1c,%esp
  803aa8:	5b                   	pop    %ebx
  803aa9:	5e                   	pop    %esi
  803aaa:	5f                   	pop    %edi
  803aab:	5d                   	pop    %ebp
  803aac:	c3                   	ret    
  803aad:	8d 76 00             	lea    0x0(%esi),%esi
  803ab0:	2b 04 24             	sub    (%esp),%eax
  803ab3:	19 fa                	sbb    %edi,%edx
  803ab5:	89 d1                	mov    %edx,%ecx
  803ab7:	89 c6                	mov    %eax,%esi
  803ab9:	e9 71 ff ff ff       	jmp    803a2f <__umoddi3+0xb3>
  803abe:	66 90                	xchg   %ax,%ax
  803ac0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ac4:	72 ea                	jb     803ab0 <__umoddi3+0x134>
  803ac6:	89 d9                	mov    %ebx,%ecx
  803ac8:	e9 62 ff ff ff       	jmp    803a2f <__umoddi3+0xb3>
