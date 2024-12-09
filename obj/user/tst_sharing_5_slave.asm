
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
  80005b:	68 80 3b 80 00       	push   $0x803b80
  800060:	6a 0c                	push   $0xc
  800062:	68 9c 3b 80 00       	push   $0x803b9c
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
  80007b:	68 b7 3b 80 00       	push   $0x803bb7
  800080:	50                   	push   %eax
  800081:	e8 fa 15 00 00       	call   801680 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80008c:	e8 69 18 00 00       	call   8018fa <sys_calculate_free_frames>
  800091:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 bc 3b 80 00       	push   $0x803bbc
  80009c:	e8 6c 04 00 00       	call   80050d <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000aa:	e8 79 16 00 00       	call   801728 <sfree>
  8000af:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave env removed x\n");
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 e0 3b 80 00       	push   $0x803be0
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
  8000e0:	68 f5 3b 80 00       	push   $0x803bf5
  8000e5:	e8 23 04 00 00       	call   80050d <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000f3:	74 14                	je     800109 <_main+0xd1>
  8000f5:	83 ec 04             	sub    $0x4,%esp
  8000f8:	68 00 3c 80 00       	push   $0x803c00
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 9c 3b 80 00       	push   $0x803b9c
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
  80018d:	68 a4 3c 80 00       	push   $0x803ca4
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
  8001b5:	68 cc 3c 80 00       	push   $0x803ccc
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
  8001e6:	68 f4 3c 80 00       	push   $0x803cf4
  8001eb:	e8 1d 03 00 00       	call   80050d <cprintf>
  8001f0:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	50                   	push   %eax
  800202:	68 4c 3d 80 00       	push   $0x803d4c
  800207:	e8 01 03 00 00       	call   80050d <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 a4 3c 80 00       	push   $0x803ca4
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
  800271:	68 60 3d 80 00       	push   $0x803d60
  800276:	e8 92 02 00 00       	call   80050d <cprintf>
  80027b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80027e:	a1 00 50 80 00       	mov    0x805000,%eax
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	50                   	push   %eax
  80028a:	68 65 3d 80 00       	push   $0x803d65
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
  8002ae:	68 81 3d 80 00       	push   $0x803d81
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
  8002dd:	68 84 3d 80 00       	push   $0x803d84
  8002e2:	6a 26                	push   $0x26
  8002e4:	68 d0 3d 80 00       	push   $0x803dd0
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
  8003b2:	68 dc 3d 80 00       	push   $0x803ddc
  8003b7:	6a 3a                	push   $0x3a
  8003b9:	68 d0 3d 80 00       	push   $0x803dd0
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
  800425:	68 30 3e 80 00       	push   $0x803e30
  80042a:	6a 44                	push   $0x44
  80042c:	68 d0 3d 80 00       	push   $0x803dd0
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
  8005aa:	e8 59 33 00 00       	call   803908 <__udivdi3>
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
  8005fa:	e8 19 34 00 00       	call   803a18 <__umoddi3>
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	05 94 40 80 00       	add    $0x804094,%eax
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
  800755:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
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
  800836:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  80083d:	85 f6                	test   %esi,%esi
  80083f:	75 19                	jne    80085a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800841:	53                   	push   %ebx
  800842:	68 a5 40 80 00       	push   $0x8040a5
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
  80085b:	68 ae 40 80 00       	push   $0x8040ae
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
  800888:	be b1 40 80 00       	mov    $0x8040b1,%esi
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
  801293:	68 28 42 80 00       	push   $0x804228
  801298:	68 3f 01 00 00       	push   $0x13f
  80129d:	68 4a 42 80 00       	push   $0x80424a
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
  80133d:	e8 dd 0e 00 00       	call   80221f <alloc_block_FF>
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
  801360:	e8 76 13 00 00       	call   8026db <alloc_block_BF>
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
  80150e:	e8 8c 09 00 00       	call   801e9f <get_block_size>
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801519:	83 ec 0c             	sub    $0xc,%esp
  80151c:	ff 75 08             	pushl  0x8(%ebp)
  80151f:	e8 9c 1b 00 00       	call   8030c0 <free_block>
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
  8015c4:	68 58 42 80 00       	push   $0x804258
  8015c9:	68 87 00 00 00       	push   $0x87
  8015ce:	68 82 42 80 00       	push   $0x804282
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
  80176f:	68 90 42 80 00       	push   $0x804290
  801774:	68 e4 00 00 00       	push   $0xe4
  801779:	68 82 42 80 00       	push   $0x804282
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
  80178c:	68 b6 42 80 00       	push   $0x8042b6
  801791:	68 f0 00 00 00       	push   $0xf0
  801796:	68 82 42 80 00       	push   $0x804282
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
  8017a9:	68 b6 42 80 00       	push   $0x8042b6
  8017ae:	68 f5 00 00 00       	push   $0xf5
  8017b3:	68 82 42 80 00       	push   $0x804282
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
  8017c6:	68 b6 42 80 00       	push   $0x8042b6
  8017cb:	68 fa 00 00 00       	push   $0xfa
  8017d0:	68 82 42 80 00       	push   $0x804282
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

00801e03 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 2e                	push   $0x2e
  801e15:	e8 c0 f9 ff ff       	call   8017da <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
  801e1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	50                   	push   %eax
  801e34:	6a 2f                	push   $0x2f
  801e36:	e8 9f f9 ff ff       	call   8017da <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
	return;
  801e3e:	90                   	nop
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801e44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	52                   	push   %edx
  801e51:	50                   	push   %eax
  801e52:	6a 30                	push   $0x30
  801e54:	e8 81 f9 ff ff       	call   8017da <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
	return;
  801e5c:	90                   	nop
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	50                   	push   %eax
  801e71:	6a 31                	push   $0x31
  801e73:	e8 62 f9 ff ff       	call   8017da <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
  801e7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	50                   	push   %eax
  801e92:	6a 32                	push   $0x32
  801e94:	e8 41 f9 ff ff       	call   8017da <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
	return;
  801e9c:	90                   	nop
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	83 e8 04             	sub    $0x4,%eax
  801eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eb1:	8b 00                	mov    (%eax),%eax
  801eb3:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec1:	83 e8 04             	sub    $0x4,%eax
  801ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eca:	8b 00                	mov    (%eax),%eax
  801ecc:	83 e0 01             	and    $0x1,%eax
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	0f 94 c0             	sete   %al
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801edc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee6:	83 f8 02             	cmp    $0x2,%eax
  801ee9:	74 2b                	je     801f16 <alloc_block+0x40>
  801eeb:	83 f8 02             	cmp    $0x2,%eax
  801eee:	7f 07                	jg     801ef7 <alloc_block+0x21>
  801ef0:	83 f8 01             	cmp    $0x1,%eax
  801ef3:	74 0e                	je     801f03 <alloc_block+0x2d>
  801ef5:	eb 58                	jmp    801f4f <alloc_block+0x79>
  801ef7:	83 f8 03             	cmp    $0x3,%eax
  801efa:	74 2d                	je     801f29 <alloc_block+0x53>
  801efc:	83 f8 04             	cmp    $0x4,%eax
  801eff:	74 3b                	je     801f3c <alloc_block+0x66>
  801f01:	eb 4c                	jmp    801f4f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	ff 75 08             	pushl  0x8(%ebp)
  801f09:	e8 11 03 00 00       	call   80221f <alloc_block_FF>
  801f0e:	83 c4 10             	add    $0x10,%esp
  801f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f14:	eb 4a                	jmp    801f60 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f16:	83 ec 0c             	sub    $0xc,%esp
  801f19:	ff 75 08             	pushl  0x8(%ebp)
  801f1c:	e8 c7 19 00 00       	call   8038e8 <alloc_block_NF>
  801f21:	83 c4 10             	add    $0x10,%esp
  801f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f27:	eb 37                	jmp    801f60 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f29:	83 ec 0c             	sub    $0xc,%esp
  801f2c:	ff 75 08             	pushl  0x8(%ebp)
  801f2f:	e8 a7 07 00 00       	call   8026db <alloc_block_BF>
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f3a:	eb 24                	jmp    801f60 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	ff 75 08             	pushl  0x8(%ebp)
  801f42:	e8 84 19 00 00       	call   8038cb <alloc_block_WF>
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f4d:	eb 11                	jmp    801f60 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	68 c8 42 80 00       	push   $0x8042c8
  801f57:	e8 b1 e5 ff ff       	call   80050d <cprintf>
  801f5c:	83 c4 10             	add    $0x10,%esp
		break;
  801f5f:	90                   	nop
	}
	return va;
  801f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	53                   	push   %ebx
  801f69:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f6c:	83 ec 0c             	sub    $0xc,%esp
  801f6f:	68 e8 42 80 00       	push   $0x8042e8
  801f74:	e8 94 e5 ff ff       	call   80050d <cprintf>
  801f79:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	68 13 43 80 00       	push   $0x804313
  801f84:	e8 84 e5 ff ff       	call   80050d <cprintf>
  801f89:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f92:	eb 37                	jmp    801fcb <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f94:	83 ec 0c             	sub    $0xc,%esp
  801f97:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9a:	e8 19 ff ff ff       	call   801eb8 <is_free_block>
  801f9f:	83 c4 10             	add    $0x10,%esp
  801fa2:	0f be d8             	movsbl %al,%ebx
  801fa5:	83 ec 0c             	sub    $0xc,%esp
  801fa8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fab:	e8 ef fe ff ff       	call   801e9f <get_block_size>
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	83 ec 04             	sub    $0x4,%esp
  801fb6:	53                   	push   %ebx
  801fb7:	50                   	push   %eax
  801fb8:	68 2b 43 80 00       	push   $0x80432b
  801fbd:	e8 4b e5 ff ff       	call   80050d <cprintf>
  801fc2:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcf:	74 07                	je     801fd8 <print_blocks_list+0x73>
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	8b 00                	mov    (%eax),%eax
  801fd6:	eb 05                	jmp    801fdd <print_blocks_list+0x78>
  801fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdd:	89 45 10             	mov    %eax,0x10(%ebp)
  801fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	75 ad                	jne    801f94 <print_blocks_list+0x2f>
  801fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801feb:	75 a7                	jne    801f94 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	68 e8 42 80 00       	push   $0x8042e8
  801ff5:	e8 13 e5 ff ff       	call   80050d <cprintf>
  801ffa:	83 c4 10             	add    $0x10,%esp

}
  801ffd:	90                   	nop
  801ffe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200c:	83 e0 01             	and    $0x1,%eax
  80200f:	85 c0                	test   %eax,%eax
  802011:	74 03                	je     802016 <initialize_dynamic_allocator+0x13>
  802013:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802016:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80201a:	0f 84 c7 01 00 00    	je     8021e7 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802020:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802027:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80202a:	8b 55 08             	mov    0x8(%ebp),%edx
  80202d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802030:	01 d0                	add    %edx,%eax
  802032:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802037:	0f 87 ad 01 00 00    	ja     8021ea <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	85 c0                	test   %eax,%eax
  802042:	0f 89 a5 01 00 00    	jns    8021ed <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802048:	8b 55 08             	mov    0x8(%ebp),%edx
  80204b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204e:	01 d0                	add    %edx,%eax
  802050:	83 e8 04             	sub    $0x4,%eax
  802053:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802058:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80205f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802064:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802067:	e9 87 00 00 00       	jmp    8020f3 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80206c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802070:	75 14                	jne    802086 <initialize_dynamic_allocator+0x83>
  802072:	83 ec 04             	sub    $0x4,%esp
  802075:	68 43 43 80 00       	push   $0x804343
  80207a:	6a 79                	push   $0x79
  80207c:	68 61 43 80 00       	push   $0x804361
  802081:	e8 ca e1 ff ff       	call   800250 <_panic>
  802086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802089:	8b 00                	mov    (%eax),%eax
  80208b:	85 c0                	test   %eax,%eax
  80208d:	74 10                	je     80209f <initialize_dynamic_allocator+0x9c>
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	8b 00                	mov    (%eax),%eax
  802094:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802097:	8b 52 04             	mov    0x4(%edx),%edx
  80209a:	89 50 04             	mov    %edx,0x4(%eax)
  80209d:	eb 0b                	jmp    8020aa <initialize_dynamic_allocator+0xa7>
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	8b 40 04             	mov    0x4(%eax),%eax
  8020a5:	a3 30 50 80 00       	mov    %eax,0x805030
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	8b 40 04             	mov    0x4(%eax),%eax
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	74 0f                	je     8020c3 <initialize_dynamic_allocator+0xc0>
  8020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b7:	8b 40 04             	mov    0x4(%eax),%eax
  8020ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bd:	8b 12                	mov    (%edx),%edx
  8020bf:	89 10                	mov    %edx,(%eax)
  8020c1:	eb 0a                	jmp    8020cd <initialize_dynamic_allocator+0xca>
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	8b 00                	mov    (%eax),%eax
  8020c8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8020e5:	48                   	dec    %eax
  8020e6:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8020eb:	a1 34 50 80 00       	mov    0x805034,%eax
  8020f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f7:	74 07                	je     802100 <initialize_dynamic_allocator+0xfd>
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	8b 00                	mov    (%eax),%eax
  8020fe:	eb 05                	jmp    802105 <initialize_dynamic_allocator+0x102>
  802100:	b8 00 00 00 00       	mov    $0x0,%eax
  802105:	a3 34 50 80 00       	mov    %eax,0x805034
  80210a:	a1 34 50 80 00       	mov    0x805034,%eax
  80210f:	85 c0                	test   %eax,%eax
  802111:	0f 85 55 ff ff ff    	jne    80206c <initialize_dynamic_allocator+0x69>
  802117:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211b:	0f 85 4b ff ff ff    	jne    80206c <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802130:	a1 44 50 80 00       	mov    0x805044,%eax
  802135:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80213a:	a1 40 50 80 00       	mov    0x805040,%eax
  80213f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	83 c0 08             	add    $0x8,%eax
  80214b:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	83 c0 04             	add    $0x4,%eax
  802154:	8b 55 0c             	mov    0xc(%ebp),%edx
  802157:	83 ea 08             	sub    $0x8,%edx
  80215a:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80215c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	01 d0                	add    %edx,%eax
  802164:	83 e8 08             	sub    $0x8,%eax
  802167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216a:	83 ea 08             	sub    $0x8,%edx
  80216d:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80216f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802172:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802182:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802186:	75 17                	jne    80219f <initialize_dynamic_allocator+0x19c>
  802188:	83 ec 04             	sub    $0x4,%esp
  80218b:	68 7c 43 80 00       	push   $0x80437c
  802190:	68 90 00 00 00       	push   $0x90
  802195:	68 61 43 80 00       	push   $0x804361
  80219a:	e8 b1 e0 ff ff       	call   800250 <_panic>
  80219f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a8:	89 10                	mov    %edx,(%eax)
  8021aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ad:	8b 00                	mov    (%eax),%eax
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	74 0d                	je     8021c0 <initialize_dynamic_allocator+0x1bd>
  8021b3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021bb:	89 50 04             	mov    %edx,0x4(%eax)
  8021be:	eb 08                	jmp    8021c8 <initialize_dynamic_allocator+0x1c5>
  8021c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c3:	a3 30 50 80 00       	mov    %eax,0x805030
  8021c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021cb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021da:	a1 38 50 80 00       	mov    0x805038,%eax
  8021df:	40                   	inc    %eax
  8021e0:	a3 38 50 80 00       	mov    %eax,0x805038
  8021e5:	eb 07                	jmp    8021ee <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8021e7:	90                   	nop
  8021e8:	eb 04                	jmp    8021ee <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8021ea:	90                   	nop
  8021eb:	eb 01                	jmp    8021ee <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8021ed:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f6:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802202:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	83 e8 04             	sub    $0x4,%eax
  80220a:	8b 00                	mov    (%eax),%eax
  80220c:	83 e0 fe             	and    $0xfffffffe,%eax
  80220f:	8d 50 f8             	lea    -0x8(%eax),%edx
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	01 c2                	add    %eax,%edx
  802217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221a:	89 02                	mov    %eax,(%edx)
}
  80221c:	90                   	nop
  80221d:	5d                   	pop    %ebp
  80221e:	c3                   	ret    

0080221f <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	83 e0 01             	and    $0x1,%eax
  80222b:	85 c0                	test   %eax,%eax
  80222d:	74 03                	je     802232 <alloc_block_FF+0x13>
  80222f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802232:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802236:	77 07                	ja     80223f <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802238:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80223f:	a1 24 50 80 00       	mov    0x805024,%eax
  802244:	85 c0                	test   %eax,%eax
  802246:	75 73                	jne    8022bb <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	83 c0 10             	add    $0x10,%eax
  80224e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802251:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802258:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80225b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225e:	01 d0                	add    %edx,%eax
  802260:	48                   	dec    %eax
  802261:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802267:	ba 00 00 00 00       	mov    $0x0,%edx
  80226c:	f7 75 ec             	divl   -0x14(%ebp)
  80226f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802272:	29 d0                	sub    %edx,%eax
  802274:	c1 e8 0c             	shr    $0xc,%eax
  802277:	83 ec 0c             	sub    $0xc,%esp
  80227a:	50                   	push   %eax
  80227b:	e8 27 f0 ff ff       	call   8012a7 <sbrk>
  802280:	83 c4 10             	add    $0x10,%esp
  802283:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802286:	83 ec 0c             	sub    $0xc,%esp
  802289:	6a 00                	push   $0x0
  80228b:	e8 17 f0 ff ff       	call   8012a7 <sbrk>
  802290:	83 c4 10             	add    $0x10,%esp
  802293:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802296:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802299:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80229c:	83 ec 08             	sub    $0x8,%esp
  80229f:	50                   	push   %eax
  8022a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022a3:	e8 5b fd ff ff       	call   802003 <initialize_dynamic_allocator>
  8022a8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022ab:	83 ec 0c             	sub    $0xc,%esp
  8022ae:	68 9f 43 80 00       	push   $0x80439f
  8022b3:	e8 55 e2 ff ff       	call   80050d <cprintf>
  8022b8:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022bf:	75 0a                	jne    8022cb <alloc_block_FF+0xac>
	        return NULL;
  8022c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c6:	e9 0e 04 00 00       	jmp    8026d9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8022cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022d2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022da:	e9 f3 02 00 00       	jmp    8025d2 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022e5:	83 ec 0c             	sub    $0xc,%esp
  8022e8:	ff 75 bc             	pushl  -0x44(%ebp)
  8022eb:	e8 af fb ff ff       	call   801e9f <get_block_size>
  8022f0:	83 c4 10             	add    $0x10,%esp
  8022f3:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	83 c0 08             	add    $0x8,%eax
  8022fc:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022ff:	0f 87 c5 02 00 00    	ja     8025ca <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	83 c0 18             	add    $0x18,%eax
  80230b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80230e:	0f 87 19 02 00 00    	ja     80252d <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802314:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802317:	2b 45 08             	sub    0x8(%ebp),%eax
  80231a:	83 e8 08             	sub    $0x8,%eax
  80231d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	8d 50 08             	lea    0x8(%eax),%edx
  802326:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802329:	01 d0                	add    %edx,%eax
  80232b:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	83 c0 08             	add    $0x8,%eax
  802334:	83 ec 04             	sub    $0x4,%esp
  802337:	6a 01                	push   $0x1
  802339:	50                   	push   %eax
  80233a:	ff 75 bc             	pushl  -0x44(%ebp)
  80233d:	e8 ae fe ff ff       	call   8021f0 <set_block_data>
  802342:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 40 04             	mov    0x4(%eax),%eax
  80234b:	85 c0                	test   %eax,%eax
  80234d:	75 68                	jne    8023b7 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80234f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802353:	75 17                	jne    80236c <alloc_block_FF+0x14d>
  802355:	83 ec 04             	sub    $0x4,%esp
  802358:	68 7c 43 80 00       	push   $0x80437c
  80235d:	68 d7 00 00 00       	push   $0xd7
  802362:	68 61 43 80 00       	push   $0x804361
  802367:	e8 e4 de ff ff       	call   800250 <_panic>
  80236c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802372:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802375:	89 10                	mov    %edx,(%eax)
  802377:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	74 0d                	je     80238d <alloc_block_FF+0x16e>
  802380:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802385:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802388:	89 50 04             	mov    %edx,0x4(%eax)
  80238b:	eb 08                	jmp    802395 <alloc_block_FF+0x176>
  80238d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802390:	a3 30 50 80 00       	mov    %eax,0x805030
  802395:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802398:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80239d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a7:	a1 38 50 80 00       	mov    0x805038,%eax
  8023ac:	40                   	inc    %eax
  8023ad:	a3 38 50 80 00       	mov    %eax,0x805038
  8023b2:	e9 dc 00 00 00       	jmp    802493 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 00                	mov    (%eax),%eax
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	75 65                	jne    802425 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023c0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023c4:	75 17                	jne    8023dd <alloc_block_FF+0x1be>
  8023c6:	83 ec 04             	sub    $0x4,%esp
  8023c9:	68 b0 43 80 00       	push   $0x8043b0
  8023ce:	68 db 00 00 00       	push   $0xdb
  8023d3:	68 61 43 80 00       	push   $0x804361
  8023d8:	e8 73 de ff ff       	call   800250 <_panic>
  8023dd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e6:	89 50 04             	mov    %edx,0x4(%eax)
  8023e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ec:	8b 40 04             	mov    0x4(%eax),%eax
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	74 0c                	je     8023ff <alloc_block_FF+0x1e0>
  8023f3:	a1 30 50 80 00       	mov    0x805030,%eax
  8023f8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023fb:	89 10                	mov    %edx,(%eax)
  8023fd:	eb 08                	jmp    802407 <alloc_block_FF+0x1e8>
  8023ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802402:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802407:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240a:	a3 30 50 80 00       	mov    %eax,0x805030
  80240f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802418:	a1 38 50 80 00       	mov    0x805038,%eax
  80241d:	40                   	inc    %eax
  80241e:	a3 38 50 80 00       	mov    %eax,0x805038
  802423:	eb 6e                	jmp    802493 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802429:	74 06                	je     802431 <alloc_block_FF+0x212>
  80242b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80242f:	75 17                	jne    802448 <alloc_block_FF+0x229>
  802431:	83 ec 04             	sub    $0x4,%esp
  802434:	68 d4 43 80 00       	push   $0x8043d4
  802439:	68 df 00 00 00       	push   $0xdf
  80243e:	68 61 43 80 00       	push   $0x804361
  802443:	e8 08 de ff ff       	call   800250 <_panic>
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 10                	mov    (%eax),%edx
  80244d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802450:	89 10                	mov    %edx,(%eax)
  802452:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	85 c0                	test   %eax,%eax
  802459:	74 0b                	je     802466 <alloc_block_FF+0x247>
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 00                	mov    (%eax),%eax
  802460:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802463:	89 50 04             	mov    %edx,0x4(%eax)
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80246c:	89 10                	mov    %edx,(%eax)
  80246e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802471:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802474:	89 50 04             	mov    %edx,0x4(%eax)
  802477:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247a:	8b 00                	mov    (%eax),%eax
  80247c:	85 c0                	test   %eax,%eax
  80247e:	75 08                	jne    802488 <alloc_block_FF+0x269>
  802480:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802483:	a3 30 50 80 00       	mov    %eax,0x805030
  802488:	a1 38 50 80 00       	mov    0x805038,%eax
  80248d:	40                   	inc    %eax
  80248e:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802497:	75 17                	jne    8024b0 <alloc_block_FF+0x291>
  802499:	83 ec 04             	sub    $0x4,%esp
  80249c:	68 43 43 80 00       	push   $0x804343
  8024a1:	68 e1 00 00 00       	push   $0xe1
  8024a6:	68 61 43 80 00       	push   $0x804361
  8024ab:	e8 a0 dd ff ff       	call   800250 <_panic>
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	74 10                	je     8024c9 <alloc_block_FF+0x2aa>
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c1:	8b 52 04             	mov    0x4(%edx),%edx
  8024c4:	89 50 04             	mov    %edx,0x4(%eax)
  8024c7:	eb 0b                	jmp    8024d4 <alloc_block_FF+0x2b5>
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 40 04             	mov    0x4(%eax),%eax
  8024cf:	a3 30 50 80 00       	mov    %eax,0x805030
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 04             	mov    0x4(%eax),%eax
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	74 0f                	je     8024ed <alloc_block_FF+0x2ce>
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 04             	mov    0x4(%eax),%eax
  8024e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e7:	8b 12                	mov    (%edx),%edx
  8024e9:	89 10                	mov    %edx,(%eax)
  8024eb:	eb 0a                	jmp    8024f7 <alloc_block_FF+0x2d8>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250a:	a1 38 50 80 00       	mov    0x805038,%eax
  80250f:	48                   	dec    %eax
  802510:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802515:	83 ec 04             	sub    $0x4,%esp
  802518:	6a 00                	push   $0x0
  80251a:	ff 75 b4             	pushl  -0x4c(%ebp)
  80251d:	ff 75 b0             	pushl  -0x50(%ebp)
  802520:	e8 cb fc ff ff       	call   8021f0 <set_block_data>
  802525:	83 c4 10             	add    $0x10,%esp
  802528:	e9 95 00 00 00       	jmp    8025c2 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80252d:	83 ec 04             	sub    $0x4,%esp
  802530:	6a 01                	push   $0x1
  802532:	ff 75 b8             	pushl  -0x48(%ebp)
  802535:	ff 75 bc             	pushl  -0x44(%ebp)
  802538:	e8 b3 fc ff ff       	call   8021f0 <set_block_data>
  80253d:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802544:	75 17                	jne    80255d <alloc_block_FF+0x33e>
  802546:	83 ec 04             	sub    $0x4,%esp
  802549:	68 43 43 80 00       	push   $0x804343
  80254e:	68 e8 00 00 00       	push   $0xe8
  802553:	68 61 43 80 00       	push   $0x804361
  802558:	e8 f3 dc ff ff       	call   800250 <_panic>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	85 c0                	test   %eax,%eax
  802564:	74 10                	je     802576 <alloc_block_FF+0x357>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256e:	8b 52 04             	mov    0x4(%edx),%edx
  802571:	89 50 04             	mov    %edx,0x4(%eax)
  802574:	eb 0b                	jmp    802581 <alloc_block_FF+0x362>
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 04             	mov    0x4(%eax),%eax
  80257c:	a3 30 50 80 00       	mov    %eax,0x805030
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 40 04             	mov    0x4(%eax),%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	74 0f                	je     80259a <alloc_block_FF+0x37b>
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 40 04             	mov    0x4(%eax),%eax
  802591:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802594:	8b 12                	mov    (%edx),%edx
  802596:	89 10                	mov    %edx,(%eax)
  802598:	eb 0a                	jmp    8025a4 <alloc_block_FF+0x385>
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	8b 00                	mov    (%eax),%eax
  80259f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8025bc:	48                   	dec    %eax
  8025bd:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8025c2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025c5:	e9 0f 01 00 00       	jmp    8026d9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8025ca:	a1 34 50 80 00       	mov    0x805034,%eax
  8025cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d6:	74 07                	je     8025df <alloc_block_FF+0x3c0>
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 00                	mov    (%eax),%eax
  8025dd:	eb 05                	jmp    8025e4 <alloc_block_FF+0x3c5>
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e4:	a3 34 50 80 00       	mov    %eax,0x805034
  8025e9:	a1 34 50 80 00       	mov    0x805034,%eax
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	0f 85 e9 fc ff ff    	jne    8022df <alloc_block_FF+0xc0>
  8025f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fa:	0f 85 df fc ff ff    	jne    8022df <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	83 c0 08             	add    $0x8,%eax
  802606:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802609:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802610:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802613:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802616:	01 d0                	add    %edx,%eax
  802618:	48                   	dec    %eax
  802619:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80261c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80261f:	ba 00 00 00 00       	mov    $0x0,%edx
  802624:	f7 75 d8             	divl   -0x28(%ebp)
  802627:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80262a:	29 d0                	sub    %edx,%eax
  80262c:	c1 e8 0c             	shr    $0xc,%eax
  80262f:	83 ec 0c             	sub    $0xc,%esp
  802632:	50                   	push   %eax
  802633:	e8 6f ec ff ff       	call   8012a7 <sbrk>
  802638:	83 c4 10             	add    $0x10,%esp
  80263b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80263e:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802642:	75 0a                	jne    80264e <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802644:	b8 00 00 00 00       	mov    $0x0,%eax
  802649:	e9 8b 00 00 00       	jmp    8026d9 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80264e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802655:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802658:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80265b:	01 d0                	add    %edx,%eax
  80265d:	48                   	dec    %eax
  80265e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802661:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802664:	ba 00 00 00 00       	mov    $0x0,%edx
  802669:	f7 75 cc             	divl   -0x34(%ebp)
  80266c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80266f:	29 d0                	sub    %edx,%eax
  802671:	8d 50 fc             	lea    -0x4(%eax),%edx
  802674:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802677:	01 d0                	add    %edx,%eax
  802679:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80267e:	a1 40 50 80 00       	mov    0x805040,%eax
  802683:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802689:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802690:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802693:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802696:	01 d0                	add    %edx,%eax
  802698:	48                   	dec    %eax
  802699:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80269c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80269f:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a4:	f7 75 c4             	divl   -0x3c(%ebp)
  8026a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026aa:	29 d0                	sub    %edx,%eax
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	6a 01                	push   $0x1
  8026b1:	50                   	push   %eax
  8026b2:	ff 75 d0             	pushl  -0x30(%ebp)
  8026b5:	e8 36 fb ff ff       	call   8021f0 <set_block_data>
  8026ba:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	ff 75 d0             	pushl  -0x30(%ebp)
  8026c3:	e8 f8 09 00 00       	call   8030c0 <free_block>
  8026c8:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8026cb:	83 ec 0c             	sub    $0xc,%esp
  8026ce:	ff 75 08             	pushl  0x8(%ebp)
  8026d1:	e8 49 fb ff ff       	call   80221f <alloc_block_FF>
  8026d6:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    

008026db <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	83 e0 01             	and    $0x1,%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	74 03                	je     8026ee <alloc_block_BF+0x13>
  8026eb:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026ee:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026f2:	77 07                	ja     8026fb <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026f4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026fb:	a1 24 50 80 00       	mov    0x805024,%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	75 73                	jne    802777 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	83 c0 10             	add    $0x10,%eax
  80270a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80270d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802714:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802717:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271a:	01 d0                	add    %edx,%eax
  80271c:	48                   	dec    %eax
  80271d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802720:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802723:	ba 00 00 00 00       	mov    $0x0,%edx
  802728:	f7 75 e0             	divl   -0x20(%ebp)
  80272b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80272e:	29 d0                	sub    %edx,%eax
  802730:	c1 e8 0c             	shr    $0xc,%eax
  802733:	83 ec 0c             	sub    $0xc,%esp
  802736:	50                   	push   %eax
  802737:	e8 6b eb ff ff       	call   8012a7 <sbrk>
  80273c:	83 c4 10             	add    $0x10,%esp
  80273f:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802742:	83 ec 0c             	sub    $0xc,%esp
  802745:	6a 00                	push   $0x0
  802747:	e8 5b eb ff ff       	call   8012a7 <sbrk>
  80274c:	83 c4 10             	add    $0x10,%esp
  80274f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802752:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802755:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802758:	83 ec 08             	sub    $0x8,%esp
  80275b:	50                   	push   %eax
  80275c:	ff 75 d8             	pushl  -0x28(%ebp)
  80275f:	e8 9f f8 ff ff       	call   802003 <initialize_dynamic_allocator>
  802764:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802767:	83 ec 0c             	sub    $0xc,%esp
  80276a:	68 9f 43 80 00       	push   $0x80439f
  80276f:	e8 99 dd ff ff       	call   80050d <cprintf>
  802774:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80277e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802785:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80278c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802793:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802798:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279b:	e9 1d 01 00 00       	jmp    8028bd <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027a6:	83 ec 0c             	sub    $0xc,%esp
  8027a9:	ff 75 a8             	pushl  -0x58(%ebp)
  8027ac:	e8 ee f6 ff ff       	call   801e9f <get_block_size>
  8027b1:	83 c4 10             	add    $0x10,%esp
  8027b4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	83 c0 08             	add    $0x8,%eax
  8027bd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027c0:	0f 87 ef 00 00 00    	ja     8028b5 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	83 c0 18             	add    $0x18,%eax
  8027cc:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027cf:	77 1d                	ja     8027ee <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8027d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027d7:	0f 86 d8 00 00 00    	jbe    8028b5 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8027dd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8027e3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027e9:	e9 c7 00 00 00       	jmp    8028b5 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8027ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f1:	83 c0 08             	add    $0x8,%eax
  8027f4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027f7:	0f 85 9d 00 00 00    	jne    80289a <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027fd:	83 ec 04             	sub    $0x4,%esp
  802800:	6a 01                	push   $0x1
  802802:	ff 75 a4             	pushl  -0x5c(%ebp)
  802805:	ff 75 a8             	pushl  -0x58(%ebp)
  802808:	e8 e3 f9 ff ff       	call   8021f0 <set_block_data>
  80280d:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802814:	75 17                	jne    80282d <alloc_block_BF+0x152>
  802816:	83 ec 04             	sub    $0x4,%esp
  802819:	68 43 43 80 00       	push   $0x804343
  80281e:	68 2c 01 00 00       	push   $0x12c
  802823:	68 61 43 80 00       	push   $0x804361
  802828:	e8 23 da ff ff       	call   800250 <_panic>
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 00                	mov    (%eax),%eax
  802832:	85 c0                	test   %eax,%eax
  802834:	74 10                	je     802846 <alloc_block_BF+0x16b>
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283e:	8b 52 04             	mov    0x4(%edx),%edx
  802841:	89 50 04             	mov    %edx,0x4(%eax)
  802844:	eb 0b                	jmp    802851 <alloc_block_BF+0x176>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 04             	mov    0x4(%eax),%eax
  80284c:	a3 30 50 80 00       	mov    %eax,0x805030
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 40 04             	mov    0x4(%eax),%eax
  802857:	85 c0                	test   %eax,%eax
  802859:	74 0f                	je     80286a <alloc_block_BF+0x18f>
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 40 04             	mov    0x4(%eax),%eax
  802861:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802864:	8b 12                	mov    (%edx),%edx
  802866:	89 10                	mov    %edx,(%eax)
  802868:	eb 0a                	jmp    802874 <alloc_block_BF+0x199>
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802887:	a1 38 50 80 00       	mov    0x805038,%eax
  80288c:	48                   	dec    %eax
  80288d:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802892:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802895:	e9 01 04 00 00       	jmp    802c9b <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80289a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a0:	76 13                	jbe    8028b5 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8028a2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028a9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8028af:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028b2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8028b5:	a1 34 50 80 00       	mov    0x805034,%eax
  8028ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c1:	74 07                	je     8028ca <alloc_block_BF+0x1ef>
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 00                	mov    (%eax),%eax
  8028c8:	eb 05                	jmp    8028cf <alloc_block_BF+0x1f4>
  8028ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cf:	a3 34 50 80 00       	mov    %eax,0x805034
  8028d4:	a1 34 50 80 00       	mov    0x805034,%eax
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	0f 85 bf fe ff ff    	jne    8027a0 <alloc_block_BF+0xc5>
  8028e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e5:	0f 85 b5 fe ff ff    	jne    8027a0 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8028eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ef:	0f 84 26 02 00 00    	je     802b1b <alloc_block_BF+0x440>
  8028f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028f9:	0f 85 1c 02 00 00    	jne    802b1b <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802902:	2b 45 08             	sub    0x8(%ebp),%eax
  802905:	83 e8 08             	sub    $0x8,%eax
  802908:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	8d 50 08             	lea    0x8(%eax),%edx
  802911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802914:	01 d0                	add    %edx,%eax
  802916:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	83 c0 08             	add    $0x8,%eax
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	6a 01                	push   $0x1
  802924:	50                   	push   %eax
  802925:	ff 75 f0             	pushl  -0x10(%ebp)
  802928:	e8 c3 f8 ff ff       	call   8021f0 <set_block_data>
  80292d:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802933:	8b 40 04             	mov    0x4(%eax),%eax
  802936:	85 c0                	test   %eax,%eax
  802938:	75 68                	jne    8029a2 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80293a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80293e:	75 17                	jne    802957 <alloc_block_BF+0x27c>
  802940:	83 ec 04             	sub    $0x4,%esp
  802943:	68 7c 43 80 00       	push   $0x80437c
  802948:	68 45 01 00 00       	push   $0x145
  80294d:	68 61 43 80 00       	push   $0x804361
  802952:	e8 f9 d8 ff ff       	call   800250 <_panic>
  802957:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80295d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802960:	89 10                	mov    %edx,(%eax)
  802962:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	85 c0                	test   %eax,%eax
  802969:	74 0d                	je     802978 <alloc_block_BF+0x29d>
  80296b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802970:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802973:	89 50 04             	mov    %edx,0x4(%eax)
  802976:	eb 08                	jmp    802980 <alloc_block_BF+0x2a5>
  802978:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297b:	a3 30 50 80 00       	mov    %eax,0x805030
  802980:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802983:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802988:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80298b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802992:	a1 38 50 80 00       	mov    0x805038,%eax
  802997:	40                   	inc    %eax
  802998:	a3 38 50 80 00       	mov    %eax,0x805038
  80299d:	e9 dc 00 00 00       	jmp    802a7e <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	8b 00                	mov    (%eax),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	75 65                	jne    802a10 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029ab:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029af:	75 17                	jne    8029c8 <alloc_block_BF+0x2ed>
  8029b1:	83 ec 04             	sub    $0x4,%esp
  8029b4:	68 b0 43 80 00       	push   $0x8043b0
  8029b9:	68 4a 01 00 00       	push   $0x14a
  8029be:	68 61 43 80 00       	push   $0x804361
  8029c3:	e8 88 d8 ff ff       	call   800250 <_panic>
  8029c8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d1:	89 50 04             	mov    %edx,0x4(%eax)
  8029d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d7:	8b 40 04             	mov    0x4(%eax),%eax
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	74 0c                	je     8029ea <alloc_block_BF+0x30f>
  8029de:	a1 30 50 80 00       	mov    0x805030,%eax
  8029e3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029e6:	89 10                	mov    %edx,(%eax)
  8029e8:	eb 08                	jmp    8029f2 <alloc_block_BF+0x317>
  8029ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8029fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a03:	a1 38 50 80 00       	mov    0x805038,%eax
  802a08:	40                   	inc    %eax
  802a09:	a3 38 50 80 00       	mov    %eax,0x805038
  802a0e:	eb 6e                	jmp    802a7e <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a14:	74 06                	je     802a1c <alloc_block_BF+0x341>
  802a16:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a1a:	75 17                	jne    802a33 <alloc_block_BF+0x358>
  802a1c:	83 ec 04             	sub    $0x4,%esp
  802a1f:	68 d4 43 80 00       	push   $0x8043d4
  802a24:	68 4f 01 00 00       	push   $0x14f
  802a29:	68 61 43 80 00       	push   $0x804361
  802a2e:	e8 1d d8 ff ff       	call   800250 <_panic>
  802a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a36:	8b 10                	mov    (%eax),%edx
  802a38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3b:	89 10                	mov    %edx,(%eax)
  802a3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	74 0b                	je     802a51 <alloc_block_BF+0x376>
  802a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a4e:	89 50 04             	mov    %edx,0x4(%eax)
  802a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a54:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a57:	89 10                	mov    %edx,(%eax)
  802a59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5f:	89 50 04             	mov    %edx,0x4(%eax)
  802a62:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	75 08                	jne    802a73 <alloc_block_BF+0x398>
  802a6b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6e:	a3 30 50 80 00       	mov    %eax,0x805030
  802a73:	a1 38 50 80 00       	mov    0x805038,%eax
  802a78:	40                   	inc    %eax
  802a79:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a82:	75 17                	jne    802a9b <alloc_block_BF+0x3c0>
  802a84:	83 ec 04             	sub    $0x4,%esp
  802a87:	68 43 43 80 00       	push   $0x804343
  802a8c:	68 51 01 00 00       	push   $0x151
  802a91:	68 61 43 80 00       	push   $0x804361
  802a96:	e8 b5 d7 ff ff       	call   800250 <_panic>
  802a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	74 10                	je     802ab4 <alloc_block_BF+0x3d9>
  802aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aac:	8b 52 04             	mov    0x4(%edx),%edx
  802aaf:	89 50 04             	mov    %edx,0x4(%eax)
  802ab2:	eb 0b                	jmp    802abf <alloc_block_BF+0x3e4>
  802ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	a3 30 50 80 00       	mov    %eax,0x805030
  802abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac2:	8b 40 04             	mov    0x4(%eax),%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	74 0f                	je     802ad8 <alloc_block_BF+0x3fd>
  802ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acc:	8b 40 04             	mov    0x4(%eax),%eax
  802acf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ad2:	8b 12                	mov    (%edx),%edx
  802ad4:	89 10                	mov    %edx,(%eax)
  802ad6:	eb 0a                	jmp    802ae2 <alloc_block_BF+0x407>
  802ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af5:	a1 38 50 80 00       	mov    0x805038,%eax
  802afa:	48                   	dec    %eax
  802afb:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b00:	83 ec 04             	sub    $0x4,%esp
  802b03:	6a 00                	push   $0x0
  802b05:	ff 75 d0             	pushl  -0x30(%ebp)
  802b08:	ff 75 cc             	pushl  -0x34(%ebp)
  802b0b:	e8 e0 f6 ff ff       	call   8021f0 <set_block_data>
  802b10:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b16:	e9 80 01 00 00       	jmp    802c9b <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802b1b:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b1f:	0f 85 9d 00 00 00    	jne    802bc2 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b25:	83 ec 04             	sub    $0x4,%esp
  802b28:	6a 01                	push   $0x1
  802b2a:	ff 75 ec             	pushl  -0x14(%ebp)
  802b2d:	ff 75 f0             	pushl  -0x10(%ebp)
  802b30:	e8 bb f6 ff ff       	call   8021f0 <set_block_data>
  802b35:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b3c:	75 17                	jne    802b55 <alloc_block_BF+0x47a>
  802b3e:	83 ec 04             	sub    $0x4,%esp
  802b41:	68 43 43 80 00       	push   $0x804343
  802b46:	68 58 01 00 00       	push   $0x158
  802b4b:	68 61 43 80 00       	push   $0x804361
  802b50:	e8 fb d6 ff ff       	call   800250 <_panic>
  802b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	74 10                	je     802b6e <alloc_block_BF+0x493>
  802b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b66:	8b 52 04             	mov    0x4(%edx),%edx
  802b69:	89 50 04             	mov    %edx,0x4(%eax)
  802b6c:	eb 0b                	jmp    802b79 <alloc_block_BF+0x49e>
  802b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b71:	8b 40 04             	mov    0x4(%eax),%eax
  802b74:	a3 30 50 80 00       	mov    %eax,0x805030
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	8b 40 04             	mov    0x4(%eax),%eax
  802b7f:	85 c0                	test   %eax,%eax
  802b81:	74 0f                	je     802b92 <alloc_block_BF+0x4b7>
  802b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b86:	8b 40 04             	mov    0x4(%eax),%eax
  802b89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8c:	8b 12                	mov    (%edx),%edx
  802b8e:	89 10                	mov    %edx,(%eax)
  802b90:	eb 0a                	jmp    802b9c <alloc_block_BF+0x4c1>
  802b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802baf:	a1 38 50 80 00       	mov    0x805038,%eax
  802bb4:	48                   	dec    %eax
  802bb5:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbd:	e9 d9 00 00 00       	jmp    802c9b <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	83 c0 08             	add    $0x8,%eax
  802bc8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802bcb:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802bd2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bd5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bd8:	01 d0                	add    %edx,%eax
  802bda:	48                   	dec    %eax
  802bdb:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bde:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802be1:	ba 00 00 00 00       	mov    $0x0,%edx
  802be6:	f7 75 c4             	divl   -0x3c(%ebp)
  802be9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bec:	29 d0                	sub    %edx,%eax
  802bee:	c1 e8 0c             	shr    $0xc,%eax
  802bf1:	83 ec 0c             	sub    $0xc,%esp
  802bf4:	50                   	push   %eax
  802bf5:	e8 ad e6 ff ff       	call   8012a7 <sbrk>
  802bfa:	83 c4 10             	add    $0x10,%esp
  802bfd:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c00:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c04:	75 0a                	jne    802c10 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c06:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0b:	e9 8b 00 00 00       	jmp    802c9b <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c10:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c17:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c1a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c1d:	01 d0                	add    %edx,%eax
  802c1f:	48                   	dec    %eax
  802c20:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c23:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c26:	ba 00 00 00 00       	mov    $0x0,%edx
  802c2b:	f7 75 b8             	divl   -0x48(%ebp)
  802c2e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c31:	29 d0                	sub    %edx,%eax
  802c33:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c36:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c39:	01 d0                	add    %edx,%eax
  802c3b:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c40:	a1 40 50 80 00       	mov    0x805040,%eax
  802c45:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c4b:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c52:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c58:	01 d0                	add    %edx,%eax
  802c5a:	48                   	dec    %eax
  802c5b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c5e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c61:	ba 00 00 00 00       	mov    $0x0,%edx
  802c66:	f7 75 b0             	divl   -0x50(%ebp)
  802c69:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c6c:	29 d0                	sub    %edx,%eax
  802c6e:	83 ec 04             	sub    $0x4,%esp
  802c71:	6a 01                	push   $0x1
  802c73:	50                   	push   %eax
  802c74:	ff 75 bc             	pushl  -0x44(%ebp)
  802c77:	e8 74 f5 ff ff       	call   8021f0 <set_block_data>
  802c7c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c7f:	83 ec 0c             	sub    $0xc,%esp
  802c82:	ff 75 bc             	pushl  -0x44(%ebp)
  802c85:	e8 36 04 00 00       	call   8030c0 <free_block>
  802c8a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c8d:	83 ec 0c             	sub    $0xc,%esp
  802c90:	ff 75 08             	pushl  0x8(%ebp)
  802c93:	e8 43 fa ff ff       	call   8026db <alloc_block_BF>
  802c98:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c9b:	c9                   	leave  
  802c9c:	c3                   	ret    

00802c9d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c9d:	55                   	push   %ebp
  802c9e:	89 e5                	mov    %esp,%ebp
  802ca0:	53                   	push   %ebx
  802ca1:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ca4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb6:	74 1e                	je     802cd6 <merging+0x39>
  802cb8:	ff 75 08             	pushl  0x8(%ebp)
  802cbb:	e8 df f1 ff ff       	call   801e9f <get_block_size>
  802cc0:	83 c4 04             	add    $0x4,%esp
  802cc3:	89 c2                	mov    %eax,%edx
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	01 d0                	add    %edx,%eax
  802cca:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ccd:	75 07                	jne    802cd6 <merging+0x39>
		prev_is_free = 1;
  802ccf:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802cd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cda:	74 1e                	je     802cfa <merging+0x5d>
  802cdc:	ff 75 10             	pushl  0x10(%ebp)
  802cdf:	e8 bb f1 ff ff       	call   801e9f <get_block_size>
  802ce4:	83 c4 04             	add    $0x4,%esp
  802ce7:	89 c2                	mov    %eax,%edx
  802ce9:	8b 45 10             	mov    0x10(%ebp),%eax
  802cec:	01 d0                	add    %edx,%eax
  802cee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cf1:	75 07                	jne    802cfa <merging+0x5d>
		next_is_free = 1;
  802cf3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802cfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfe:	0f 84 cc 00 00 00    	je     802dd0 <merging+0x133>
  802d04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d08:	0f 84 c2 00 00 00    	je     802dd0 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d0e:	ff 75 08             	pushl  0x8(%ebp)
  802d11:	e8 89 f1 ff ff       	call   801e9f <get_block_size>
  802d16:	83 c4 04             	add    $0x4,%esp
  802d19:	89 c3                	mov    %eax,%ebx
  802d1b:	ff 75 10             	pushl  0x10(%ebp)
  802d1e:	e8 7c f1 ff ff       	call   801e9f <get_block_size>
  802d23:	83 c4 04             	add    $0x4,%esp
  802d26:	01 c3                	add    %eax,%ebx
  802d28:	ff 75 0c             	pushl  0xc(%ebp)
  802d2b:	e8 6f f1 ff ff       	call   801e9f <get_block_size>
  802d30:	83 c4 04             	add    $0x4,%esp
  802d33:	01 d8                	add    %ebx,%eax
  802d35:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d38:	6a 00                	push   $0x0
  802d3a:	ff 75 ec             	pushl  -0x14(%ebp)
  802d3d:	ff 75 08             	pushl  0x8(%ebp)
  802d40:	e8 ab f4 ff ff       	call   8021f0 <set_block_data>
  802d45:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d4c:	75 17                	jne    802d65 <merging+0xc8>
  802d4e:	83 ec 04             	sub    $0x4,%esp
  802d51:	68 43 43 80 00       	push   $0x804343
  802d56:	68 7d 01 00 00       	push   $0x17d
  802d5b:	68 61 43 80 00       	push   $0x804361
  802d60:	e8 eb d4 ff ff       	call   800250 <_panic>
  802d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d68:	8b 00                	mov    (%eax),%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	74 10                	je     802d7e <merging+0xe1>
  802d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d71:	8b 00                	mov    (%eax),%eax
  802d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d76:	8b 52 04             	mov    0x4(%edx),%edx
  802d79:	89 50 04             	mov    %edx,0x4(%eax)
  802d7c:	eb 0b                	jmp    802d89 <merging+0xec>
  802d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d81:	8b 40 04             	mov    0x4(%eax),%eax
  802d84:	a3 30 50 80 00       	mov    %eax,0x805030
  802d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8c:	8b 40 04             	mov    0x4(%eax),%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	74 0f                	je     802da2 <merging+0x105>
  802d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d96:	8b 40 04             	mov    0x4(%eax),%eax
  802d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d9c:	8b 12                	mov    (%edx),%edx
  802d9e:	89 10                	mov    %edx,(%eax)
  802da0:	eb 0a                	jmp    802dac <merging+0x10f>
  802da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802daf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbf:	a1 38 50 80 00       	mov    0x805038,%eax
  802dc4:	48                   	dec    %eax
  802dc5:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802dca:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dcb:	e9 ea 02 00 00       	jmp    8030ba <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802dd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd4:	74 3b                	je     802e11 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802dd6:	83 ec 0c             	sub    $0xc,%esp
  802dd9:	ff 75 08             	pushl  0x8(%ebp)
  802ddc:	e8 be f0 ff ff       	call   801e9f <get_block_size>
  802de1:	83 c4 10             	add    $0x10,%esp
  802de4:	89 c3                	mov    %eax,%ebx
  802de6:	83 ec 0c             	sub    $0xc,%esp
  802de9:	ff 75 10             	pushl  0x10(%ebp)
  802dec:	e8 ae f0 ff ff       	call   801e9f <get_block_size>
  802df1:	83 c4 10             	add    $0x10,%esp
  802df4:	01 d8                	add    %ebx,%eax
  802df6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802df9:	83 ec 04             	sub    $0x4,%esp
  802dfc:	6a 00                	push   $0x0
  802dfe:	ff 75 e8             	pushl  -0x18(%ebp)
  802e01:	ff 75 08             	pushl  0x8(%ebp)
  802e04:	e8 e7 f3 ff ff       	call   8021f0 <set_block_data>
  802e09:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e0c:	e9 a9 02 00 00       	jmp    8030ba <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e15:	0f 84 2d 01 00 00    	je     802f48 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e1b:	83 ec 0c             	sub    $0xc,%esp
  802e1e:	ff 75 10             	pushl  0x10(%ebp)
  802e21:	e8 79 f0 ff ff       	call   801e9f <get_block_size>
  802e26:	83 c4 10             	add    $0x10,%esp
  802e29:	89 c3                	mov    %eax,%ebx
  802e2b:	83 ec 0c             	sub    $0xc,%esp
  802e2e:	ff 75 0c             	pushl  0xc(%ebp)
  802e31:	e8 69 f0 ff ff       	call   801e9f <get_block_size>
  802e36:	83 c4 10             	add    $0x10,%esp
  802e39:	01 d8                	add    %ebx,%eax
  802e3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e3e:	83 ec 04             	sub    $0x4,%esp
  802e41:	6a 00                	push   $0x0
  802e43:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e46:	ff 75 10             	pushl  0x10(%ebp)
  802e49:	e8 a2 f3 ff ff       	call   8021f0 <set_block_data>
  802e4e:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e51:	8b 45 10             	mov    0x10(%ebp),%eax
  802e54:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e5b:	74 06                	je     802e63 <merging+0x1c6>
  802e5d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e61:	75 17                	jne    802e7a <merging+0x1dd>
  802e63:	83 ec 04             	sub    $0x4,%esp
  802e66:	68 08 44 80 00       	push   $0x804408
  802e6b:	68 8d 01 00 00       	push   $0x18d
  802e70:	68 61 43 80 00       	push   $0x804361
  802e75:	e8 d6 d3 ff ff       	call   800250 <_panic>
  802e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7d:	8b 50 04             	mov    0x4(%eax),%edx
  802e80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e83:	89 50 04             	mov    %edx,0x4(%eax)
  802e86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e89:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e8c:	89 10                	mov    %edx,(%eax)
  802e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e91:	8b 40 04             	mov    0x4(%eax),%eax
  802e94:	85 c0                	test   %eax,%eax
  802e96:	74 0d                	je     802ea5 <merging+0x208>
  802e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9b:	8b 40 04             	mov    0x4(%eax),%eax
  802e9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ea1:	89 10                	mov    %edx,(%eax)
  802ea3:	eb 08                	jmp    802ead <merging+0x210>
  802ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eb3:	89 50 04             	mov    %edx,0x4(%eax)
  802eb6:	a1 38 50 80 00       	mov    0x805038,%eax
  802ebb:	40                   	inc    %eax
  802ebc:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802ec1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ec5:	75 17                	jne    802ede <merging+0x241>
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	68 43 43 80 00       	push   $0x804343
  802ecf:	68 8e 01 00 00       	push   $0x18e
  802ed4:	68 61 43 80 00       	push   $0x804361
  802ed9:	e8 72 d3 ff ff       	call   800250 <_panic>
  802ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	74 10                	je     802ef7 <merging+0x25a>
  802ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eea:	8b 00                	mov    (%eax),%eax
  802eec:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eef:	8b 52 04             	mov    0x4(%edx),%edx
  802ef2:	89 50 04             	mov    %edx,0x4(%eax)
  802ef5:	eb 0b                	jmp    802f02 <merging+0x265>
  802ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802efa:	8b 40 04             	mov    0x4(%eax),%eax
  802efd:	a3 30 50 80 00       	mov    %eax,0x805030
  802f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f05:	8b 40 04             	mov    0x4(%eax),%eax
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	74 0f                	je     802f1b <merging+0x27e>
  802f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f15:	8b 12                	mov    (%edx),%edx
  802f17:	89 10                	mov    %edx,(%eax)
  802f19:	eb 0a                	jmp    802f25 <merging+0x288>
  802f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f38:	a1 38 50 80 00       	mov    0x805038,%eax
  802f3d:	48                   	dec    %eax
  802f3e:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f43:	e9 72 01 00 00       	jmp    8030ba <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f48:	8b 45 10             	mov    0x10(%ebp),%eax
  802f4b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f52:	74 79                	je     802fcd <merging+0x330>
  802f54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f58:	74 73                	je     802fcd <merging+0x330>
  802f5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5e:	74 06                	je     802f66 <merging+0x2c9>
  802f60:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f64:	75 17                	jne    802f7d <merging+0x2e0>
  802f66:	83 ec 04             	sub    $0x4,%esp
  802f69:	68 d4 43 80 00       	push   $0x8043d4
  802f6e:	68 94 01 00 00       	push   $0x194
  802f73:	68 61 43 80 00       	push   $0x804361
  802f78:	e8 d3 d2 ff ff       	call   800250 <_panic>
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	8b 10                	mov    (%eax),%edx
  802f82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f85:	89 10                	mov    %edx,(%eax)
  802f87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8a:	8b 00                	mov    (%eax),%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	74 0b                	je     802f9b <merging+0x2fe>
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	8b 00                	mov    (%eax),%eax
  802f95:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f98:	89 50 04             	mov    %edx,0x4(%eax)
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fa1:	89 10                	mov    %edx,(%eax)
  802fa3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa9:	89 50 04             	mov    %edx,0x4(%eax)
  802fac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	85 c0                	test   %eax,%eax
  802fb3:	75 08                	jne    802fbd <merging+0x320>
  802fb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb8:	a3 30 50 80 00       	mov    %eax,0x805030
  802fbd:	a1 38 50 80 00       	mov    0x805038,%eax
  802fc2:	40                   	inc    %eax
  802fc3:	a3 38 50 80 00       	mov    %eax,0x805038
  802fc8:	e9 ce 00 00 00       	jmp    80309b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802fcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd1:	74 65                	je     803038 <merging+0x39b>
  802fd3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fd7:	75 17                	jne    802ff0 <merging+0x353>
  802fd9:	83 ec 04             	sub    $0x4,%esp
  802fdc:	68 b0 43 80 00       	push   $0x8043b0
  802fe1:	68 95 01 00 00       	push   $0x195
  802fe6:	68 61 43 80 00       	push   $0x804361
  802feb:	e8 60 d2 ff ff       	call   800250 <_panic>
  802ff0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ff6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff9:	89 50 04             	mov    %edx,0x4(%eax)
  802ffc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fff:	8b 40 04             	mov    0x4(%eax),%eax
  803002:	85 c0                	test   %eax,%eax
  803004:	74 0c                	je     803012 <merging+0x375>
  803006:	a1 30 50 80 00       	mov    0x805030,%eax
  80300b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80300e:	89 10                	mov    %edx,(%eax)
  803010:	eb 08                	jmp    80301a <merging+0x37d>
  803012:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803015:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80301a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301d:	a3 30 50 80 00       	mov    %eax,0x805030
  803022:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803025:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302b:	a1 38 50 80 00       	mov    0x805038,%eax
  803030:	40                   	inc    %eax
  803031:	a3 38 50 80 00       	mov    %eax,0x805038
  803036:	eb 63                	jmp    80309b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803038:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80303c:	75 17                	jne    803055 <merging+0x3b8>
  80303e:	83 ec 04             	sub    $0x4,%esp
  803041:	68 7c 43 80 00       	push   $0x80437c
  803046:	68 98 01 00 00       	push   $0x198
  80304b:	68 61 43 80 00       	push   $0x804361
  803050:	e8 fb d1 ff ff       	call   800250 <_panic>
  803055:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80305b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305e:	89 10                	mov    %edx,(%eax)
  803060:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	74 0d                	je     803076 <merging+0x3d9>
  803069:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80306e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803071:	89 50 04             	mov    %edx,0x4(%eax)
  803074:	eb 08                	jmp    80307e <merging+0x3e1>
  803076:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803079:	a3 30 50 80 00       	mov    %eax,0x805030
  80307e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803081:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803086:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803089:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803090:	a1 38 50 80 00       	mov    0x805038,%eax
  803095:	40                   	inc    %eax
  803096:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80309b:	83 ec 0c             	sub    $0xc,%esp
  80309e:	ff 75 10             	pushl  0x10(%ebp)
  8030a1:	e8 f9 ed ff ff       	call   801e9f <get_block_size>
  8030a6:	83 c4 10             	add    $0x10,%esp
  8030a9:	83 ec 04             	sub    $0x4,%esp
  8030ac:	6a 00                	push   $0x0
  8030ae:	50                   	push   %eax
  8030af:	ff 75 10             	pushl  0x10(%ebp)
  8030b2:	e8 39 f1 ff ff       	call   8021f0 <set_block_data>
  8030b7:	83 c4 10             	add    $0x10,%esp
	}
}
  8030ba:	90                   	nop
  8030bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030be:	c9                   	leave  
  8030bf:	c3                   	ret    

008030c0 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030c0:	55                   	push   %ebp
  8030c1:	89 e5                	mov    %esp,%ebp
  8030c3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030cb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030ce:	a1 30 50 80 00       	mov    0x805030,%eax
  8030d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d6:	73 1b                	jae    8030f3 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030d8:	a1 30 50 80 00       	mov    0x805030,%eax
  8030dd:	83 ec 04             	sub    $0x4,%esp
  8030e0:	ff 75 08             	pushl  0x8(%ebp)
  8030e3:	6a 00                	push   $0x0
  8030e5:	50                   	push   %eax
  8030e6:	e8 b2 fb ff ff       	call   802c9d <merging>
  8030eb:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030ee:	e9 8b 00 00 00       	jmp    80317e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030f3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030fb:	76 18                	jbe    803115 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803102:	83 ec 04             	sub    $0x4,%esp
  803105:	ff 75 08             	pushl  0x8(%ebp)
  803108:	50                   	push   %eax
  803109:	6a 00                	push   $0x0
  80310b:	e8 8d fb ff ff       	call   802c9d <merging>
  803110:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803113:	eb 69                	jmp    80317e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803115:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80311a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80311d:	eb 39                	jmp    803158 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803122:	3b 45 08             	cmp    0x8(%ebp),%eax
  803125:	73 29                	jae    803150 <free_block+0x90>
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80312f:	76 1f                	jbe    803150 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803139:	83 ec 04             	sub    $0x4,%esp
  80313c:	ff 75 08             	pushl  0x8(%ebp)
  80313f:	ff 75 f0             	pushl  -0x10(%ebp)
  803142:	ff 75 f4             	pushl  -0xc(%ebp)
  803145:	e8 53 fb ff ff       	call   802c9d <merging>
  80314a:	83 c4 10             	add    $0x10,%esp
			break;
  80314d:	90                   	nop
		}
	}
}
  80314e:	eb 2e                	jmp    80317e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803150:	a1 34 50 80 00       	mov    0x805034,%eax
  803155:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803158:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315c:	74 07                	je     803165 <free_block+0xa5>
  80315e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	eb 05                	jmp    80316a <free_block+0xaa>
  803165:	b8 00 00 00 00       	mov    $0x0,%eax
  80316a:	a3 34 50 80 00       	mov    %eax,0x805034
  80316f:	a1 34 50 80 00       	mov    0x805034,%eax
  803174:	85 c0                	test   %eax,%eax
  803176:	75 a7                	jne    80311f <free_block+0x5f>
  803178:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317c:	75 a1                	jne    80311f <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80317e:	90                   	nop
  80317f:	c9                   	leave  
  803180:	c3                   	ret    

00803181 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803181:	55                   	push   %ebp
  803182:	89 e5                	mov    %esp,%ebp
  803184:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803187:	ff 75 08             	pushl  0x8(%ebp)
  80318a:	e8 10 ed ff ff       	call   801e9f <get_block_size>
  80318f:	83 c4 04             	add    $0x4,%esp
  803192:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803195:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80319c:	eb 17                	jmp    8031b5 <copy_data+0x34>
  80319e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a4:	01 c2                	add    %eax,%edx
  8031a6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	01 c8                	add    %ecx,%eax
  8031ae:	8a 00                	mov    (%eax),%al
  8031b0:	88 02                	mov    %al,(%edx)
  8031b2:	ff 45 fc             	incl   -0x4(%ebp)
  8031b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031bb:	72 e1                	jb     80319e <copy_data+0x1d>
}
  8031bd:	90                   	nop
  8031be:	c9                   	leave  
  8031bf:	c3                   	ret    

008031c0 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031c0:	55                   	push   %ebp
  8031c1:	89 e5                	mov    %esp,%ebp
  8031c3:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ca:	75 23                	jne    8031ef <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8031cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031d0:	74 13                	je     8031e5 <realloc_block_FF+0x25>
  8031d2:	83 ec 0c             	sub    $0xc,%esp
  8031d5:	ff 75 0c             	pushl  0xc(%ebp)
  8031d8:	e8 42 f0 ff ff       	call   80221f <alloc_block_FF>
  8031dd:	83 c4 10             	add    $0x10,%esp
  8031e0:	e9 e4 06 00 00       	jmp    8038c9 <realloc_block_FF+0x709>
		return NULL;
  8031e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ea:	e9 da 06 00 00       	jmp    8038c9 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8031ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031f3:	75 18                	jne    80320d <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031f5:	83 ec 0c             	sub    $0xc,%esp
  8031f8:	ff 75 08             	pushl  0x8(%ebp)
  8031fb:	e8 c0 fe ff ff       	call   8030c0 <free_block>
  803200:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803203:	b8 00 00 00 00       	mov    $0x0,%eax
  803208:	e9 bc 06 00 00       	jmp    8038c9 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  80320d:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803211:	77 07                	ja     80321a <realloc_block_FF+0x5a>
  803213:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80321a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80321d:	83 e0 01             	and    $0x1,%eax
  803220:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803223:	8b 45 0c             	mov    0xc(%ebp),%eax
  803226:	83 c0 08             	add    $0x8,%eax
  803229:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80322c:	83 ec 0c             	sub    $0xc,%esp
  80322f:	ff 75 08             	pushl  0x8(%ebp)
  803232:	e8 68 ec ff ff       	call   801e9f <get_block_size>
  803237:	83 c4 10             	add    $0x10,%esp
  80323a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80323d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803240:	83 e8 08             	sub    $0x8,%eax
  803243:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	83 e8 04             	sub    $0x4,%eax
  80324c:	8b 00                	mov    (%eax),%eax
  80324e:	83 e0 fe             	and    $0xfffffffe,%eax
  803251:	89 c2                	mov    %eax,%edx
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	01 d0                	add    %edx,%eax
  803258:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80325b:	83 ec 0c             	sub    $0xc,%esp
  80325e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803261:	e8 39 ec ff ff       	call   801e9f <get_block_size>
  803266:	83 c4 10             	add    $0x10,%esp
  803269:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80326c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80326f:	83 e8 08             	sub    $0x8,%eax
  803272:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803275:	8b 45 0c             	mov    0xc(%ebp),%eax
  803278:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80327b:	75 08                	jne    803285 <realloc_block_FF+0xc5>
	{
		 return va;
  80327d:	8b 45 08             	mov    0x8(%ebp),%eax
  803280:	e9 44 06 00 00       	jmp    8038c9 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803285:	8b 45 0c             	mov    0xc(%ebp),%eax
  803288:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80328b:	0f 83 d5 03 00 00    	jae    803666 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803294:	2b 45 0c             	sub    0xc(%ebp),%eax
  803297:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80329a:	83 ec 0c             	sub    $0xc,%esp
  80329d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032a0:	e8 13 ec ff ff       	call   801eb8 <is_free_block>
  8032a5:	83 c4 10             	add    $0x10,%esp
  8032a8:	84 c0                	test   %al,%al
  8032aa:	0f 84 3b 01 00 00    	je     8033eb <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8032b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032b6:	01 d0                	add    %edx,%eax
  8032b8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8032bb:	83 ec 04             	sub    $0x4,%esp
  8032be:	6a 01                	push   $0x1
  8032c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8032c3:	ff 75 08             	pushl  0x8(%ebp)
  8032c6:	e8 25 ef ff ff       	call   8021f0 <set_block_data>
  8032cb:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	83 e8 04             	sub    $0x4,%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	83 e0 fe             	and    $0xfffffffe,%eax
  8032d9:	89 c2                	mov    %eax,%edx
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	01 d0                	add    %edx,%eax
  8032e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8032e3:	83 ec 04             	sub    $0x4,%esp
  8032e6:	6a 00                	push   $0x0
  8032e8:	ff 75 cc             	pushl  -0x34(%ebp)
  8032eb:	ff 75 c8             	pushl  -0x38(%ebp)
  8032ee:	e8 fd ee ff ff       	call   8021f0 <set_block_data>
  8032f3:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032fa:	74 06                	je     803302 <realloc_block_FF+0x142>
  8032fc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803300:	75 17                	jne    803319 <realloc_block_FF+0x159>
  803302:	83 ec 04             	sub    $0x4,%esp
  803305:	68 d4 43 80 00       	push   $0x8043d4
  80330a:	68 f6 01 00 00       	push   $0x1f6
  80330f:	68 61 43 80 00       	push   $0x804361
  803314:	e8 37 cf ff ff       	call   800250 <_panic>
  803319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331c:	8b 10                	mov    (%eax),%edx
  80331e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803321:	89 10                	mov    %edx,(%eax)
  803323:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803326:	8b 00                	mov    (%eax),%eax
  803328:	85 c0                	test   %eax,%eax
  80332a:	74 0b                	je     803337 <realloc_block_FF+0x177>
  80332c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332f:	8b 00                	mov    (%eax),%eax
  803331:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803334:	89 50 04             	mov    %edx,0x4(%eax)
  803337:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80333d:	89 10                	mov    %edx,(%eax)
  80333f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803345:	89 50 04             	mov    %edx,0x4(%eax)
  803348:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	85 c0                	test   %eax,%eax
  80334f:	75 08                	jne    803359 <realloc_block_FF+0x199>
  803351:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803354:	a3 30 50 80 00       	mov    %eax,0x805030
  803359:	a1 38 50 80 00       	mov    0x805038,%eax
  80335e:	40                   	inc    %eax
  80335f:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803364:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803368:	75 17                	jne    803381 <realloc_block_FF+0x1c1>
  80336a:	83 ec 04             	sub    $0x4,%esp
  80336d:	68 43 43 80 00       	push   $0x804343
  803372:	68 f7 01 00 00       	push   $0x1f7
  803377:	68 61 43 80 00       	push   $0x804361
  80337c:	e8 cf ce ff ff       	call   800250 <_panic>
  803381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	85 c0                	test   %eax,%eax
  803388:	74 10                	je     80339a <realloc_block_FF+0x1da>
  80338a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338d:	8b 00                	mov    (%eax),%eax
  80338f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803392:	8b 52 04             	mov    0x4(%edx),%edx
  803395:	89 50 04             	mov    %edx,0x4(%eax)
  803398:	eb 0b                	jmp    8033a5 <realloc_block_FF+0x1e5>
  80339a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339d:	8b 40 04             	mov    0x4(%eax),%eax
  8033a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8033a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a8:	8b 40 04             	mov    0x4(%eax),%eax
  8033ab:	85 c0                	test   %eax,%eax
  8033ad:	74 0f                	je     8033be <realloc_block_FF+0x1fe>
  8033af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b2:	8b 40 04             	mov    0x4(%eax),%eax
  8033b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033b8:	8b 12                	mov    (%edx),%edx
  8033ba:	89 10                	mov    %edx,(%eax)
  8033bc:	eb 0a                	jmp    8033c8 <realloc_block_FF+0x208>
  8033be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c1:	8b 00                	mov    (%eax),%eax
  8033c3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033db:	a1 38 50 80 00       	mov    0x805038,%eax
  8033e0:	48                   	dec    %eax
  8033e1:	a3 38 50 80 00       	mov    %eax,0x805038
  8033e6:	e9 73 02 00 00       	jmp    80365e <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8033eb:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033ef:	0f 86 69 02 00 00    	jbe    80365e <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033f5:	83 ec 04             	sub    $0x4,%esp
  8033f8:	6a 01                	push   $0x1
  8033fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8033fd:	ff 75 08             	pushl  0x8(%ebp)
  803400:	e8 eb ed ff ff       	call   8021f0 <set_block_data>
  803405:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	83 e8 04             	sub    $0x4,%eax
  80340e:	8b 00                	mov    (%eax),%eax
  803410:	83 e0 fe             	and    $0xfffffffe,%eax
  803413:	89 c2                	mov    %eax,%edx
  803415:	8b 45 08             	mov    0x8(%ebp),%eax
  803418:	01 d0                	add    %edx,%eax
  80341a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80341d:	a1 38 50 80 00       	mov    0x805038,%eax
  803422:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803425:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803429:	75 68                	jne    803493 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80342b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80342f:	75 17                	jne    803448 <realloc_block_FF+0x288>
  803431:	83 ec 04             	sub    $0x4,%esp
  803434:	68 7c 43 80 00       	push   $0x80437c
  803439:	68 06 02 00 00       	push   $0x206
  80343e:	68 61 43 80 00       	push   $0x804361
  803443:	e8 08 ce ff ff       	call   800250 <_panic>
  803448:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80344e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803451:	89 10                	mov    %edx,(%eax)
  803453:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803456:	8b 00                	mov    (%eax),%eax
  803458:	85 c0                	test   %eax,%eax
  80345a:	74 0d                	je     803469 <realloc_block_FF+0x2a9>
  80345c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803461:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803464:	89 50 04             	mov    %edx,0x4(%eax)
  803467:	eb 08                	jmp    803471 <realloc_block_FF+0x2b1>
  803469:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346c:	a3 30 50 80 00       	mov    %eax,0x805030
  803471:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803474:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803479:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803483:	a1 38 50 80 00       	mov    0x805038,%eax
  803488:	40                   	inc    %eax
  803489:	a3 38 50 80 00       	mov    %eax,0x805038
  80348e:	e9 b0 01 00 00       	jmp    803643 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803493:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803498:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80349b:	76 68                	jbe    803505 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80349d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034a1:	75 17                	jne    8034ba <realloc_block_FF+0x2fa>
  8034a3:	83 ec 04             	sub    $0x4,%esp
  8034a6:	68 7c 43 80 00       	push   $0x80437c
  8034ab:	68 0b 02 00 00       	push   $0x20b
  8034b0:	68 61 43 80 00       	push   $0x804361
  8034b5:	e8 96 cd ff ff       	call   800250 <_panic>
  8034ba:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c3:	89 10                	mov    %edx,(%eax)
  8034c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c8:	8b 00                	mov    (%eax),%eax
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	74 0d                	je     8034db <realloc_block_FF+0x31b>
  8034ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034d6:	89 50 04             	mov    %edx,0x4(%eax)
  8034d9:	eb 08                	jmp    8034e3 <realloc_block_FF+0x323>
  8034db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034de:	a3 30 50 80 00       	mov    %eax,0x805030
  8034e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8034fa:	40                   	inc    %eax
  8034fb:	a3 38 50 80 00       	mov    %eax,0x805038
  803500:	e9 3e 01 00 00       	jmp    803643 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803505:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80350a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80350d:	73 68                	jae    803577 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80350f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803513:	75 17                	jne    80352c <realloc_block_FF+0x36c>
  803515:	83 ec 04             	sub    $0x4,%esp
  803518:	68 b0 43 80 00       	push   $0x8043b0
  80351d:	68 10 02 00 00       	push   $0x210
  803522:	68 61 43 80 00       	push   $0x804361
  803527:	e8 24 cd ff ff       	call   800250 <_panic>
  80352c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803535:	89 50 04             	mov    %edx,0x4(%eax)
  803538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353b:	8b 40 04             	mov    0x4(%eax),%eax
  80353e:	85 c0                	test   %eax,%eax
  803540:	74 0c                	je     80354e <realloc_block_FF+0x38e>
  803542:	a1 30 50 80 00       	mov    0x805030,%eax
  803547:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80354a:	89 10                	mov    %edx,(%eax)
  80354c:	eb 08                	jmp    803556 <realloc_block_FF+0x396>
  80354e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803551:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803559:	a3 30 50 80 00       	mov    %eax,0x805030
  80355e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803561:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803567:	a1 38 50 80 00       	mov    0x805038,%eax
  80356c:	40                   	inc    %eax
  80356d:	a3 38 50 80 00       	mov    %eax,0x805038
  803572:	e9 cc 00 00 00       	jmp    803643 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803577:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80357e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803583:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803586:	e9 8a 00 00 00       	jmp    803615 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803591:	73 7a                	jae    80360d <realloc_block_FF+0x44d>
  803593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803596:	8b 00                	mov    (%eax),%eax
  803598:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80359b:	73 70                	jae    80360d <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80359d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a1:	74 06                	je     8035a9 <realloc_block_FF+0x3e9>
  8035a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035a7:	75 17                	jne    8035c0 <realloc_block_FF+0x400>
  8035a9:	83 ec 04             	sub    $0x4,%esp
  8035ac:	68 d4 43 80 00       	push   $0x8043d4
  8035b1:	68 1a 02 00 00       	push   $0x21a
  8035b6:	68 61 43 80 00       	push   $0x804361
  8035bb:	e8 90 cc ff ff       	call   800250 <_panic>
  8035c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c3:	8b 10                	mov    (%eax),%edx
  8035c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c8:	89 10                	mov    %edx,(%eax)
  8035ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cd:	8b 00                	mov    (%eax),%eax
  8035cf:	85 c0                	test   %eax,%eax
  8035d1:	74 0b                	je     8035de <realloc_block_FF+0x41e>
  8035d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d6:	8b 00                	mov    (%eax),%eax
  8035d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035db:	89 50 04             	mov    %edx,0x4(%eax)
  8035de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035e4:	89 10                	mov    %edx,(%eax)
  8035e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ec:	89 50 04             	mov    %edx,0x4(%eax)
  8035ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f2:	8b 00                	mov    (%eax),%eax
  8035f4:	85 c0                	test   %eax,%eax
  8035f6:	75 08                	jne    803600 <realloc_block_FF+0x440>
  8035f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fb:	a3 30 50 80 00       	mov    %eax,0x805030
  803600:	a1 38 50 80 00       	mov    0x805038,%eax
  803605:	40                   	inc    %eax
  803606:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80360b:	eb 36                	jmp    803643 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80360d:	a1 34 50 80 00       	mov    0x805034,%eax
  803612:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803619:	74 07                	je     803622 <realloc_block_FF+0x462>
  80361b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361e:	8b 00                	mov    (%eax),%eax
  803620:	eb 05                	jmp    803627 <realloc_block_FF+0x467>
  803622:	b8 00 00 00 00       	mov    $0x0,%eax
  803627:	a3 34 50 80 00       	mov    %eax,0x805034
  80362c:	a1 34 50 80 00       	mov    0x805034,%eax
  803631:	85 c0                	test   %eax,%eax
  803633:	0f 85 52 ff ff ff    	jne    80358b <realloc_block_FF+0x3cb>
  803639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80363d:	0f 85 48 ff ff ff    	jne    80358b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803643:	83 ec 04             	sub    $0x4,%esp
  803646:	6a 00                	push   $0x0
  803648:	ff 75 d8             	pushl  -0x28(%ebp)
  80364b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80364e:	e8 9d eb ff ff       	call   8021f0 <set_block_data>
  803653:	83 c4 10             	add    $0x10,%esp
				return va;
  803656:	8b 45 08             	mov    0x8(%ebp),%eax
  803659:	e9 6b 02 00 00       	jmp    8038c9 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	e9 63 02 00 00       	jmp    8038c9 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803666:	8b 45 0c             	mov    0xc(%ebp),%eax
  803669:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80366c:	0f 86 4d 02 00 00    	jbe    8038bf <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803672:	83 ec 0c             	sub    $0xc,%esp
  803675:	ff 75 e4             	pushl  -0x1c(%ebp)
  803678:	e8 3b e8 ff ff       	call   801eb8 <is_free_block>
  80367d:	83 c4 10             	add    $0x10,%esp
  803680:	84 c0                	test   %al,%al
  803682:	0f 84 37 02 00 00    	je     8038bf <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80368e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803691:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803697:	76 38                	jbe    8036d1 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803699:	83 ec 0c             	sub    $0xc,%esp
  80369c:	ff 75 0c             	pushl  0xc(%ebp)
  80369f:	e8 7b eb ff ff       	call   80221f <alloc_block_FF>
  8036a4:	83 c4 10             	add    $0x10,%esp
  8036a7:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8036aa:	83 ec 08             	sub    $0x8,%esp
  8036ad:	ff 75 c0             	pushl  -0x40(%ebp)
  8036b0:	ff 75 08             	pushl  0x8(%ebp)
  8036b3:	e8 c9 fa ff ff       	call   803181 <copy_data>
  8036b8:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8036bb:	83 ec 0c             	sub    $0xc,%esp
  8036be:	ff 75 08             	pushl  0x8(%ebp)
  8036c1:	e8 fa f9 ff ff       	call   8030c0 <free_block>
  8036c6:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036c9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036cc:	e9 f8 01 00 00       	jmp    8038c9 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d4:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8036d7:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8036da:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8036de:	0f 87 a0 00 00 00    	ja     803784 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8036e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036e8:	75 17                	jne    803701 <realloc_block_FF+0x541>
  8036ea:	83 ec 04             	sub    $0x4,%esp
  8036ed:	68 43 43 80 00       	push   $0x804343
  8036f2:	68 38 02 00 00       	push   $0x238
  8036f7:	68 61 43 80 00       	push   $0x804361
  8036fc:	e8 4f cb ff ff       	call   800250 <_panic>
  803701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803704:	8b 00                	mov    (%eax),%eax
  803706:	85 c0                	test   %eax,%eax
  803708:	74 10                	je     80371a <realloc_block_FF+0x55a>
  80370a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803712:	8b 52 04             	mov    0x4(%edx),%edx
  803715:	89 50 04             	mov    %edx,0x4(%eax)
  803718:	eb 0b                	jmp    803725 <realloc_block_FF+0x565>
  80371a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371d:	8b 40 04             	mov    0x4(%eax),%eax
  803720:	a3 30 50 80 00       	mov    %eax,0x805030
  803725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803728:	8b 40 04             	mov    0x4(%eax),%eax
  80372b:	85 c0                	test   %eax,%eax
  80372d:	74 0f                	je     80373e <realloc_block_FF+0x57e>
  80372f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803732:	8b 40 04             	mov    0x4(%eax),%eax
  803735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803738:	8b 12                	mov    (%edx),%edx
  80373a:	89 10                	mov    %edx,(%eax)
  80373c:	eb 0a                	jmp    803748 <realloc_block_FF+0x588>
  80373e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803741:	8b 00                	mov    (%eax),%eax
  803743:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803754:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375b:	a1 38 50 80 00       	mov    0x805038,%eax
  803760:	48                   	dec    %eax
  803761:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803766:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80376c:	01 d0                	add    %edx,%eax
  80376e:	83 ec 04             	sub    $0x4,%esp
  803771:	6a 01                	push   $0x1
  803773:	50                   	push   %eax
  803774:	ff 75 08             	pushl  0x8(%ebp)
  803777:	e8 74 ea ff ff       	call   8021f0 <set_block_data>
  80377c:	83 c4 10             	add    $0x10,%esp
  80377f:	e9 36 01 00 00       	jmp    8038ba <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803784:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803787:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80378a:	01 d0                	add    %edx,%eax
  80378c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80378f:	83 ec 04             	sub    $0x4,%esp
  803792:	6a 01                	push   $0x1
  803794:	ff 75 f0             	pushl  -0x10(%ebp)
  803797:	ff 75 08             	pushl  0x8(%ebp)
  80379a:	e8 51 ea ff ff       	call   8021f0 <set_block_data>
  80379f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a5:	83 e8 04             	sub    $0x4,%eax
  8037a8:	8b 00                	mov    (%eax),%eax
  8037aa:	83 e0 fe             	and    $0xfffffffe,%eax
  8037ad:	89 c2                	mov    %eax,%edx
  8037af:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b2:	01 d0                	add    %edx,%eax
  8037b4:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037bb:	74 06                	je     8037c3 <realloc_block_FF+0x603>
  8037bd:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037c1:	75 17                	jne    8037da <realloc_block_FF+0x61a>
  8037c3:	83 ec 04             	sub    $0x4,%esp
  8037c6:	68 d4 43 80 00       	push   $0x8043d4
  8037cb:	68 44 02 00 00       	push   $0x244
  8037d0:	68 61 43 80 00       	push   $0x804361
  8037d5:	e8 76 ca ff ff       	call   800250 <_panic>
  8037da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037dd:	8b 10                	mov    (%eax),%edx
  8037df:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037e2:	89 10                	mov    %edx,(%eax)
  8037e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037e7:	8b 00                	mov    (%eax),%eax
  8037e9:	85 c0                	test   %eax,%eax
  8037eb:	74 0b                	je     8037f8 <realloc_block_FF+0x638>
  8037ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037f5:	89 50 04             	mov    %edx,0x4(%eax)
  8037f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fb:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037fe:	89 10                	mov    %edx,(%eax)
  803800:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803803:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803806:	89 50 04             	mov    %edx,0x4(%eax)
  803809:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80380c:	8b 00                	mov    (%eax),%eax
  80380e:	85 c0                	test   %eax,%eax
  803810:	75 08                	jne    80381a <realloc_block_FF+0x65a>
  803812:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803815:	a3 30 50 80 00       	mov    %eax,0x805030
  80381a:	a1 38 50 80 00       	mov    0x805038,%eax
  80381f:	40                   	inc    %eax
  803820:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803825:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803829:	75 17                	jne    803842 <realloc_block_FF+0x682>
  80382b:	83 ec 04             	sub    $0x4,%esp
  80382e:	68 43 43 80 00       	push   $0x804343
  803833:	68 45 02 00 00       	push   $0x245
  803838:	68 61 43 80 00       	push   $0x804361
  80383d:	e8 0e ca ff ff       	call   800250 <_panic>
  803842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803845:	8b 00                	mov    (%eax),%eax
  803847:	85 c0                	test   %eax,%eax
  803849:	74 10                	je     80385b <realloc_block_FF+0x69b>
  80384b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384e:	8b 00                	mov    (%eax),%eax
  803850:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803853:	8b 52 04             	mov    0x4(%edx),%edx
  803856:	89 50 04             	mov    %edx,0x4(%eax)
  803859:	eb 0b                	jmp    803866 <realloc_block_FF+0x6a6>
  80385b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385e:	8b 40 04             	mov    0x4(%eax),%eax
  803861:	a3 30 50 80 00       	mov    %eax,0x805030
  803866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803869:	8b 40 04             	mov    0x4(%eax),%eax
  80386c:	85 c0                	test   %eax,%eax
  80386e:	74 0f                	je     80387f <realloc_block_FF+0x6bf>
  803870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803873:	8b 40 04             	mov    0x4(%eax),%eax
  803876:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803879:	8b 12                	mov    (%edx),%edx
  80387b:	89 10                	mov    %edx,(%eax)
  80387d:	eb 0a                	jmp    803889 <realloc_block_FF+0x6c9>
  80387f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803882:	8b 00                	mov    (%eax),%eax
  803884:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803892:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803895:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80389c:	a1 38 50 80 00       	mov    0x805038,%eax
  8038a1:	48                   	dec    %eax
  8038a2:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8038a7:	83 ec 04             	sub    $0x4,%esp
  8038aa:	6a 00                	push   $0x0
  8038ac:	ff 75 bc             	pushl  -0x44(%ebp)
  8038af:	ff 75 b8             	pushl  -0x48(%ebp)
  8038b2:	e8 39 e9 ff ff       	call   8021f0 <set_block_data>
  8038b7:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8038ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bd:	eb 0a                	jmp    8038c9 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8038bf:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038c9:	c9                   	leave  
  8038ca:	c3                   	ret    

008038cb <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038cb:	55                   	push   %ebp
  8038cc:	89 e5                	mov    %esp,%ebp
  8038ce:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038d1:	83 ec 04             	sub    $0x4,%esp
  8038d4:	68 40 44 80 00       	push   $0x804440
  8038d9:	68 58 02 00 00       	push   $0x258
  8038de:	68 61 43 80 00       	push   $0x804361
  8038e3:	e8 68 c9 ff ff       	call   800250 <_panic>

008038e8 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038e8:	55                   	push   %ebp
  8038e9:	89 e5                	mov    %esp,%ebp
  8038eb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038ee:	83 ec 04             	sub    $0x4,%esp
  8038f1:	68 68 44 80 00       	push   $0x804468
  8038f6:	68 61 02 00 00       	push   $0x261
  8038fb:	68 61 43 80 00       	push   $0x804361
  803900:	e8 4b c9 ff ff       	call   800250 <_panic>
  803905:	66 90                	xchg   %ax,%ax
  803907:	90                   	nop

00803908 <__udivdi3>:
  803908:	55                   	push   %ebp
  803909:	57                   	push   %edi
  80390a:	56                   	push   %esi
  80390b:	53                   	push   %ebx
  80390c:	83 ec 1c             	sub    $0x1c,%esp
  80390f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803913:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803917:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80391b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80391f:	89 ca                	mov    %ecx,%edx
  803921:	89 f8                	mov    %edi,%eax
  803923:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803927:	85 f6                	test   %esi,%esi
  803929:	75 2d                	jne    803958 <__udivdi3+0x50>
  80392b:	39 cf                	cmp    %ecx,%edi
  80392d:	77 65                	ja     803994 <__udivdi3+0x8c>
  80392f:	89 fd                	mov    %edi,%ebp
  803931:	85 ff                	test   %edi,%edi
  803933:	75 0b                	jne    803940 <__udivdi3+0x38>
  803935:	b8 01 00 00 00       	mov    $0x1,%eax
  80393a:	31 d2                	xor    %edx,%edx
  80393c:	f7 f7                	div    %edi
  80393e:	89 c5                	mov    %eax,%ebp
  803940:	31 d2                	xor    %edx,%edx
  803942:	89 c8                	mov    %ecx,%eax
  803944:	f7 f5                	div    %ebp
  803946:	89 c1                	mov    %eax,%ecx
  803948:	89 d8                	mov    %ebx,%eax
  80394a:	f7 f5                	div    %ebp
  80394c:	89 cf                	mov    %ecx,%edi
  80394e:	89 fa                	mov    %edi,%edx
  803950:	83 c4 1c             	add    $0x1c,%esp
  803953:	5b                   	pop    %ebx
  803954:	5e                   	pop    %esi
  803955:	5f                   	pop    %edi
  803956:	5d                   	pop    %ebp
  803957:	c3                   	ret    
  803958:	39 ce                	cmp    %ecx,%esi
  80395a:	77 28                	ja     803984 <__udivdi3+0x7c>
  80395c:	0f bd fe             	bsr    %esi,%edi
  80395f:	83 f7 1f             	xor    $0x1f,%edi
  803962:	75 40                	jne    8039a4 <__udivdi3+0x9c>
  803964:	39 ce                	cmp    %ecx,%esi
  803966:	72 0a                	jb     803972 <__udivdi3+0x6a>
  803968:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80396c:	0f 87 9e 00 00 00    	ja     803a10 <__udivdi3+0x108>
  803972:	b8 01 00 00 00       	mov    $0x1,%eax
  803977:	89 fa                	mov    %edi,%edx
  803979:	83 c4 1c             	add    $0x1c,%esp
  80397c:	5b                   	pop    %ebx
  80397d:	5e                   	pop    %esi
  80397e:	5f                   	pop    %edi
  80397f:	5d                   	pop    %ebp
  803980:	c3                   	ret    
  803981:	8d 76 00             	lea    0x0(%esi),%esi
  803984:	31 ff                	xor    %edi,%edi
  803986:	31 c0                	xor    %eax,%eax
  803988:	89 fa                	mov    %edi,%edx
  80398a:	83 c4 1c             	add    $0x1c,%esp
  80398d:	5b                   	pop    %ebx
  80398e:	5e                   	pop    %esi
  80398f:	5f                   	pop    %edi
  803990:	5d                   	pop    %ebp
  803991:	c3                   	ret    
  803992:	66 90                	xchg   %ax,%ax
  803994:	89 d8                	mov    %ebx,%eax
  803996:	f7 f7                	div    %edi
  803998:	31 ff                	xor    %edi,%edi
  80399a:	89 fa                	mov    %edi,%edx
  80399c:	83 c4 1c             	add    $0x1c,%esp
  80399f:	5b                   	pop    %ebx
  8039a0:	5e                   	pop    %esi
  8039a1:	5f                   	pop    %edi
  8039a2:	5d                   	pop    %ebp
  8039a3:	c3                   	ret    
  8039a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039a9:	89 eb                	mov    %ebp,%ebx
  8039ab:	29 fb                	sub    %edi,%ebx
  8039ad:	89 f9                	mov    %edi,%ecx
  8039af:	d3 e6                	shl    %cl,%esi
  8039b1:	89 c5                	mov    %eax,%ebp
  8039b3:	88 d9                	mov    %bl,%cl
  8039b5:	d3 ed                	shr    %cl,%ebp
  8039b7:	89 e9                	mov    %ebp,%ecx
  8039b9:	09 f1                	or     %esi,%ecx
  8039bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039bf:	89 f9                	mov    %edi,%ecx
  8039c1:	d3 e0                	shl    %cl,%eax
  8039c3:	89 c5                	mov    %eax,%ebp
  8039c5:	89 d6                	mov    %edx,%esi
  8039c7:	88 d9                	mov    %bl,%cl
  8039c9:	d3 ee                	shr    %cl,%esi
  8039cb:	89 f9                	mov    %edi,%ecx
  8039cd:	d3 e2                	shl    %cl,%edx
  8039cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039d3:	88 d9                	mov    %bl,%cl
  8039d5:	d3 e8                	shr    %cl,%eax
  8039d7:	09 c2                	or     %eax,%edx
  8039d9:	89 d0                	mov    %edx,%eax
  8039db:	89 f2                	mov    %esi,%edx
  8039dd:	f7 74 24 0c          	divl   0xc(%esp)
  8039e1:	89 d6                	mov    %edx,%esi
  8039e3:	89 c3                	mov    %eax,%ebx
  8039e5:	f7 e5                	mul    %ebp
  8039e7:	39 d6                	cmp    %edx,%esi
  8039e9:	72 19                	jb     803a04 <__udivdi3+0xfc>
  8039eb:	74 0b                	je     8039f8 <__udivdi3+0xf0>
  8039ed:	89 d8                	mov    %ebx,%eax
  8039ef:	31 ff                	xor    %edi,%edi
  8039f1:	e9 58 ff ff ff       	jmp    80394e <__udivdi3+0x46>
  8039f6:	66 90                	xchg   %ax,%ax
  8039f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039fc:	89 f9                	mov    %edi,%ecx
  8039fe:	d3 e2                	shl    %cl,%edx
  803a00:	39 c2                	cmp    %eax,%edx
  803a02:	73 e9                	jae    8039ed <__udivdi3+0xe5>
  803a04:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a07:	31 ff                	xor    %edi,%edi
  803a09:	e9 40 ff ff ff       	jmp    80394e <__udivdi3+0x46>
  803a0e:	66 90                	xchg   %ax,%ax
  803a10:	31 c0                	xor    %eax,%eax
  803a12:	e9 37 ff ff ff       	jmp    80394e <__udivdi3+0x46>
  803a17:	90                   	nop

00803a18 <__umoddi3>:
  803a18:	55                   	push   %ebp
  803a19:	57                   	push   %edi
  803a1a:	56                   	push   %esi
  803a1b:	53                   	push   %ebx
  803a1c:	83 ec 1c             	sub    $0x1c,%esp
  803a1f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a23:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a37:	89 f3                	mov    %esi,%ebx
  803a39:	89 fa                	mov    %edi,%edx
  803a3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a3f:	89 34 24             	mov    %esi,(%esp)
  803a42:	85 c0                	test   %eax,%eax
  803a44:	75 1a                	jne    803a60 <__umoddi3+0x48>
  803a46:	39 f7                	cmp    %esi,%edi
  803a48:	0f 86 a2 00 00 00    	jbe    803af0 <__umoddi3+0xd8>
  803a4e:	89 c8                	mov    %ecx,%eax
  803a50:	89 f2                	mov    %esi,%edx
  803a52:	f7 f7                	div    %edi
  803a54:	89 d0                	mov    %edx,%eax
  803a56:	31 d2                	xor    %edx,%edx
  803a58:	83 c4 1c             	add    $0x1c,%esp
  803a5b:	5b                   	pop    %ebx
  803a5c:	5e                   	pop    %esi
  803a5d:	5f                   	pop    %edi
  803a5e:	5d                   	pop    %ebp
  803a5f:	c3                   	ret    
  803a60:	39 f0                	cmp    %esi,%eax
  803a62:	0f 87 ac 00 00 00    	ja     803b14 <__umoddi3+0xfc>
  803a68:	0f bd e8             	bsr    %eax,%ebp
  803a6b:	83 f5 1f             	xor    $0x1f,%ebp
  803a6e:	0f 84 ac 00 00 00    	je     803b20 <__umoddi3+0x108>
  803a74:	bf 20 00 00 00       	mov    $0x20,%edi
  803a79:	29 ef                	sub    %ebp,%edi
  803a7b:	89 fe                	mov    %edi,%esi
  803a7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a81:	89 e9                	mov    %ebp,%ecx
  803a83:	d3 e0                	shl    %cl,%eax
  803a85:	89 d7                	mov    %edx,%edi
  803a87:	89 f1                	mov    %esi,%ecx
  803a89:	d3 ef                	shr    %cl,%edi
  803a8b:	09 c7                	or     %eax,%edi
  803a8d:	89 e9                	mov    %ebp,%ecx
  803a8f:	d3 e2                	shl    %cl,%edx
  803a91:	89 14 24             	mov    %edx,(%esp)
  803a94:	89 d8                	mov    %ebx,%eax
  803a96:	d3 e0                	shl    %cl,%eax
  803a98:	89 c2                	mov    %eax,%edx
  803a9a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a9e:	d3 e0                	shl    %cl,%eax
  803aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803aa4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aa8:	89 f1                	mov    %esi,%ecx
  803aaa:	d3 e8                	shr    %cl,%eax
  803aac:	09 d0                	or     %edx,%eax
  803aae:	d3 eb                	shr    %cl,%ebx
  803ab0:	89 da                	mov    %ebx,%edx
  803ab2:	f7 f7                	div    %edi
  803ab4:	89 d3                	mov    %edx,%ebx
  803ab6:	f7 24 24             	mull   (%esp)
  803ab9:	89 c6                	mov    %eax,%esi
  803abb:	89 d1                	mov    %edx,%ecx
  803abd:	39 d3                	cmp    %edx,%ebx
  803abf:	0f 82 87 00 00 00    	jb     803b4c <__umoddi3+0x134>
  803ac5:	0f 84 91 00 00 00    	je     803b5c <__umoddi3+0x144>
  803acb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803acf:	29 f2                	sub    %esi,%edx
  803ad1:	19 cb                	sbb    %ecx,%ebx
  803ad3:	89 d8                	mov    %ebx,%eax
  803ad5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ad9:	d3 e0                	shl    %cl,%eax
  803adb:	89 e9                	mov    %ebp,%ecx
  803add:	d3 ea                	shr    %cl,%edx
  803adf:	09 d0                	or     %edx,%eax
  803ae1:	89 e9                	mov    %ebp,%ecx
  803ae3:	d3 eb                	shr    %cl,%ebx
  803ae5:	89 da                	mov    %ebx,%edx
  803ae7:	83 c4 1c             	add    $0x1c,%esp
  803aea:	5b                   	pop    %ebx
  803aeb:	5e                   	pop    %esi
  803aec:	5f                   	pop    %edi
  803aed:	5d                   	pop    %ebp
  803aee:	c3                   	ret    
  803aef:	90                   	nop
  803af0:	89 fd                	mov    %edi,%ebp
  803af2:	85 ff                	test   %edi,%edi
  803af4:	75 0b                	jne    803b01 <__umoddi3+0xe9>
  803af6:	b8 01 00 00 00       	mov    $0x1,%eax
  803afb:	31 d2                	xor    %edx,%edx
  803afd:	f7 f7                	div    %edi
  803aff:	89 c5                	mov    %eax,%ebp
  803b01:	89 f0                	mov    %esi,%eax
  803b03:	31 d2                	xor    %edx,%edx
  803b05:	f7 f5                	div    %ebp
  803b07:	89 c8                	mov    %ecx,%eax
  803b09:	f7 f5                	div    %ebp
  803b0b:	89 d0                	mov    %edx,%eax
  803b0d:	e9 44 ff ff ff       	jmp    803a56 <__umoddi3+0x3e>
  803b12:	66 90                	xchg   %ax,%ax
  803b14:	89 c8                	mov    %ecx,%eax
  803b16:	89 f2                	mov    %esi,%edx
  803b18:	83 c4 1c             	add    $0x1c,%esp
  803b1b:	5b                   	pop    %ebx
  803b1c:	5e                   	pop    %esi
  803b1d:	5f                   	pop    %edi
  803b1e:	5d                   	pop    %ebp
  803b1f:	c3                   	ret    
  803b20:	3b 04 24             	cmp    (%esp),%eax
  803b23:	72 06                	jb     803b2b <__umoddi3+0x113>
  803b25:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b29:	77 0f                	ja     803b3a <__umoddi3+0x122>
  803b2b:	89 f2                	mov    %esi,%edx
  803b2d:	29 f9                	sub    %edi,%ecx
  803b2f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b33:	89 14 24             	mov    %edx,(%esp)
  803b36:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b3a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b3e:	8b 14 24             	mov    (%esp),%edx
  803b41:	83 c4 1c             	add    $0x1c,%esp
  803b44:	5b                   	pop    %ebx
  803b45:	5e                   	pop    %esi
  803b46:	5f                   	pop    %edi
  803b47:	5d                   	pop    %ebp
  803b48:	c3                   	ret    
  803b49:	8d 76 00             	lea    0x0(%esi),%esi
  803b4c:	2b 04 24             	sub    (%esp),%eax
  803b4f:	19 fa                	sbb    %edi,%edx
  803b51:	89 d1                	mov    %edx,%ecx
  803b53:	89 c6                	mov    %eax,%esi
  803b55:	e9 71 ff ff ff       	jmp    803acb <__umoddi3+0xb3>
  803b5a:	66 90                	xchg   %ax,%ax
  803b5c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b60:	72 ea                	jb     803b4c <__umoddi3+0x134>
  803b62:	89 d9                	mov    %ebx,%ecx
  803b64:	e9 62 ff ff ff       	jmp    803acb <__umoddi3+0xb3>
