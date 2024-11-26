
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
  80005b:	68 20 3b 80 00       	push   $0x803b20
  800060:	6a 0c                	push   $0xc
  800062:	68 3c 3b 80 00       	push   $0x803b3c
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
  800073:	e8 76 1a 00 00       	call   801aee <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 57 3b 80 00       	push   $0x803b57
  800080:	50                   	push   %eax
  800081:	e8 0c 16 00 00       	call   801692 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80008c:	e8 7b 18 00 00       	call   80190c <sys_calculate_free_frames>
  800091:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 5c 3b 80 00       	push   $0x803b5c
  80009c:	e8 6c 04 00 00       	call   80050d <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000aa:	e8 8b 16 00 00       	call   80173a <sfree>
  8000af:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave env removed x\n");
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 80 3b 80 00       	push   $0x803b80
  8000ba:	e8 4e 04 00 00       	call   80050d <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp

	diff = (sys_calculate_free_frames() - freeFrames);
  8000c2:	e8 45 18 00 00       	call   80190c <sys_calculate_free_frames>
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
  8000e0:	68 95 3b 80 00       	push   $0x803b95
  8000e5:	e8 23 04 00 00       	call   80050d <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000f3:	74 14                	je     800109 <_main+0xd1>
  8000f5:	83 ec 04             	sub    $0x4,%esp
  8000f8:	68 a0 3b 80 00       	push   $0x803ba0
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 3c 3b 80 00       	push   $0x803b3c
  800104:	e8 47 01 00 00       	call   800250 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800109:	e8 05 1b 00 00       	call   801c13 <inctst>

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
  800117:	e8 b9 19 00 00       	call   801ad5 <sys_getenvindex>
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
  800185:	e8 cf 16 00 00       	call   801859 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	68 44 3c 80 00       	push   $0x803c44
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
  8001b5:	68 6c 3c 80 00       	push   $0x803c6c
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
  8001e6:	68 94 3c 80 00       	push   $0x803c94
  8001eb:	e8 1d 03 00 00       	call   80050d <cprintf>
  8001f0:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	50                   	push   %eax
  800202:	68 ec 3c 80 00       	push   $0x803cec
  800207:	e8 01 03 00 00       	call   80050d <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 44 3c 80 00       	push   $0x803c44
  800217:	e8 f1 02 00 00       	call   80050d <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80021f:	e8 4f 16 00 00       	call   801873 <sys_unlock_cons>
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
  800237:	e8 65 18 00 00       	call   801aa1 <sys_destroy_env>
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
  800248:	e8 ba 18 00 00       	call   801b07 <sys_exit_env>
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
  800271:	68 00 3d 80 00       	push   $0x803d00
  800276:	e8 92 02 00 00       	call   80050d <cprintf>
  80027b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80027e:	a1 00 50 80 00       	mov    0x805000,%eax
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	50                   	push   %eax
  80028a:	68 05 3d 80 00       	push   $0x803d05
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
  8002ae:	68 21 3d 80 00       	push   $0x803d21
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
  8002dd:	68 24 3d 80 00       	push   $0x803d24
  8002e2:	6a 26                	push   $0x26
  8002e4:	68 70 3d 80 00       	push   $0x803d70
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
  8003b2:	68 7c 3d 80 00       	push   $0x803d7c
  8003b7:	6a 3a                	push   $0x3a
  8003b9:	68 70 3d 80 00       	push   $0x803d70
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
  800425:	68 d0 3d 80 00       	push   $0x803dd0
  80042a:	6a 44                	push   $0x44
  80042c:	68 70 3d 80 00       	push   $0x803d70
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
  80047f:	e8 93 13 00 00       	call   801817 <sys_cputs>
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
  8004f6:	e8 1c 13 00 00       	call   801817 <sys_cputs>
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
  800540:	e8 14 13 00 00       	call   801859 <sys_lock_cons>
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
  800560:	e8 0e 13 00 00       	call   801873 <sys_unlock_cons>
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
  8005aa:	e8 01 33 00 00       	call   8038b0 <__udivdi3>
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
  8005fa:	e8 c1 33 00 00       	call   8039c0 <__umoddi3>
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	05 34 40 80 00       	add    $0x804034,%eax
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
  800755:	8b 04 85 58 40 80 00 	mov    0x804058(,%eax,4),%eax
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
  800836:	8b 34 9d a0 3e 80 00 	mov    0x803ea0(,%ebx,4),%esi
  80083d:	85 f6                	test   %esi,%esi
  80083f:	75 19                	jne    80085a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800841:	53                   	push   %ebx
  800842:	68 45 40 80 00       	push   $0x804045
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
  80085b:	68 4e 40 80 00       	push   $0x80404e
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
  800888:	be 51 40 80 00       	mov    $0x804051,%esi
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
  801293:	68 c8 41 80 00       	push   $0x8041c8
  801298:	68 3f 01 00 00       	push   $0x13f
  80129d:	68 ea 41 80 00       	push   $0x8041ea
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
  8012b3:	e8 0a 0b 00 00       	call   801dc2 <sys_sbrk>
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
  80132e:	e8 13 09 00 00       	call   801c46 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801333:	85 c0                	test   %eax,%eax
  801335:	74 16                	je     80134d <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801337:	83 ec 0c             	sub    $0xc,%esp
  80133a:	ff 75 08             	pushl  0x8(%ebp)
  80133d:	e8 53 0e 00 00       	call   802195 <alloc_block_FF>
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801348:	e9 8a 01 00 00       	jmp    8014d7 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80134d:	e8 25 09 00 00       	call   801c77 <sys_isUHeapPlacementStrategyBESTFIT>
  801352:	85 c0                	test   %eax,%eax
  801354:	0f 84 7d 01 00 00    	je     8014d7 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80135a:	83 ec 0c             	sub    $0xc,%esp
  80135d:	ff 75 08             	pushl  0x8(%ebp)
  801360:	e8 ec 12 00 00       	call   802651 <alloc_block_BF>
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
		//cprintf("52\n");
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
			//cprintf("57\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8013bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c2:	05 00 10 00 00       	add    $0x1000,%eax
  8013c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8013ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
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
						//cprintf("71\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
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
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80146a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80146e:	75 16                	jne    801486 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801470:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801477:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80147e:	0f 86 15 ff ff ff    	jbe    801399 <malloc+0xdc>
  801484:	eb 01                	jmp    801487 <malloc+0x1ca>
				}
				//cprintf("79\n");

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
  8014c6:	e8 2e 09 00 00       	call   801df9 <sys_allocate_user_mem>
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	eb 07                	jmp    8014d7 <malloc+0x21a>
		//cprintf("91\n");
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
  80150e:	e8 02 09 00 00       	call   801e15 <get_block_size>
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801519:	83 ec 0c             	sub    $0xc,%esp
  80151c:	ff 75 08             	pushl  0x8(%ebp)
  80151f:	e8 35 1b 00 00       	call   803059 <free_block>
  801524:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  801573:	eb 2f                	jmp    8015a4 <free+0xc8>
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
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8015a1:	ff 45 f4             	incl   -0xc(%ebp)
  8015a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8015aa:	72 c9                	jb     801575 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	83 ec 08             	sub    $0x8,%esp
  8015b2:	ff 75 ec             	pushl  -0x14(%ebp)
  8015b5:	50                   	push   %eax
  8015b6:	e8 22 08 00 00       	call   801ddd <sys_free_user_mem>
  8015bb:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8015be:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8015bf:	eb 17                	jmp    8015d8 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	68 f8 41 80 00       	push   $0x8041f8
  8015c9:	68 85 00 00 00       	push   $0x85
  8015ce:	68 22 42 80 00       	push   $0x804222
  8015d3:	e8 78 ec ff ff       	call   800250 <_panic>
	}
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 28             	sub    $0x28,%esp
  8015e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e3:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8015e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ea:	75 0a                	jne    8015f6 <smalloc+0x1c>
  8015ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f1:	e9 9a 00 00 00       	jmp    801690 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015fc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801603:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801609:	39 d0                	cmp    %edx,%eax
  80160b:	73 02                	jae    80160f <smalloc+0x35>
  80160d:	89 d0                	mov    %edx,%eax
  80160f:	83 ec 0c             	sub    $0xc,%esp
  801612:	50                   	push   %eax
  801613:	e8 a5 fc ff ff       	call   8012bd <malloc>
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80161e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801622:	75 07                	jne    80162b <smalloc+0x51>
  801624:	b8 00 00 00 00       	mov    $0x0,%eax
  801629:	eb 65                	jmp    801690 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80162b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80162f:	ff 75 ec             	pushl  -0x14(%ebp)
  801632:	50                   	push   %eax
  801633:	ff 75 0c             	pushl  0xc(%ebp)
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 a6 03 00 00       	call   8019e4 <sys_createSharedObject>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801644:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801648:	74 06                	je     801650 <smalloc+0x76>
  80164a:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80164e:	75 07                	jne    801657 <smalloc+0x7d>
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
  801655:	eb 39                	jmp    801690 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801657:	83 ec 08             	sub    $0x8,%esp
  80165a:	ff 75 ec             	pushl  -0x14(%ebp)
  80165d:	68 2e 42 80 00       	push   $0x80422e
  801662:	e8 a6 ee ff ff       	call   80050d <cprintf>
  801667:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80166a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80166d:	a1 20 50 80 00       	mov    0x805020,%eax
  801672:	8b 40 78             	mov    0x78(%eax),%eax
  801675:	29 c2                	sub    %eax,%edx
  801677:	89 d0                	mov    %edx,%eax
  801679:	2d 00 10 00 00       	sub    $0x1000,%eax
  80167e:	c1 e8 0c             	shr    $0xc,%eax
  801681:	89 c2                	mov    %eax,%edx
  801683:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801686:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80168d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801698:	83 ec 08             	sub    $0x8,%esp
  80169b:	ff 75 0c             	pushl  0xc(%ebp)
  80169e:	ff 75 08             	pushl  0x8(%ebp)
  8016a1:	e8 68 03 00 00       	call   801a0e <sys_getSizeOfSharedObject>
  8016a6:	83 c4 10             	add    $0x10,%esp
  8016a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016ac:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016b0:	75 07                	jne    8016b9 <sget+0x27>
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b7:	eb 7f                	jmp    801738 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016bf:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cc:	39 d0                	cmp    %edx,%eax
  8016ce:	7d 02                	jge    8016d2 <sget+0x40>
  8016d0:	89 d0                	mov    %edx,%eax
  8016d2:	83 ec 0c             	sub    $0xc,%esp
  8016d5:	50                   	push   %eax
  8016d6:	e8 e2 fb ff ff       	call   8012bd <malloc>
  8016db:	83 c4 10             	add    $0x10,%esp
  8016de:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8016e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016e5:	75 07                	jne    8016ee <sget+0x5c>
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ec:	eb 4a                	jmp    801738 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8016f4:	ff 75 0c             	pushl  0xc(%ebp)
  8016f7:	ff 75 08             	pushl  0x8(%ebp)
  8016fa:	e8 2c 03 00 00       	call   801a2b <sys_getSharedObject>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801705:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801708:	a1 20 50 80 00       	mov    0x805020,%eax
  80170d:	8b 40 78             	mov    0x78(%eax),%eax
  801710:	29 c2                	sub    %eax,%edx
  801712:	89 d0                	mov    %edx,%eax
  801714:	2d 00 10 00 00       	sub    $0x1000,%eax
  801719:	c1 e8 0c             	shr    $0xc,%eax
  80171c:	89 c2                	mov    %eax,%edx
  80171e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801721:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801728:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80172c:	75 07                	jne    801735 <sget+0xa3>
  80172e:	b8 00 00 00 00       	mov    $0x0,%eax
  801733:	eb 03                	jmp    801738 <sget+0xa6>
	return ptr;
  801735:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801740:	8b 55 08             	mov    0x8(%ebp),%edx
  801743:	a1 20 50 80 00       	mov    0x805020,%eax
  801748:	8b 40 78             	mov    0x78(%eax),%eax
  80174b:	29 c2                	sub    %eax,%edx
  80174d:	89 d0                	mov    %edx,%eax
  80174f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801754:	c1 e8 0c             	shr    $0xc,%eax
  801757:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80175e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	ff 75 08             	pushl  0x8(%ebp)
  801767:	ff 75 f4             	pushl  -0xc(%ebp)
  80176a:	e8 db 02 00 00       	call   801a4a <sys_freeSharedObject>
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801775:	90                   	nop
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	68 40 42 80 00       	push   $0x804240
  801786:	68 de 00 00 00       	push   $0xde
  80178b:	68 22 42 80 00       	push   $0x804222
  801790:	e8 bb ea ff ff       	call   800250 <_panic>

00801795 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	68 66 42 80 00       	push   $0x804266
  8017a3:	68 ea 00 00 00       	push   $0xea
  8017a8:	68 22 42 80 00       	push   $0x804222
  8017ad:	e8 9e ea ff ff       	call   800250 <_panic>

008017b2 <shrink>:

}
void shrink(uint32 newSize)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	68 66 42 80 00       	push   $0x804266
  8017c0:	68 ef 00 00 00       	push   $0xef
  8017c5:	68 22 42 80 00       	push   $0x804222
  8017ca:	e8 81 ea ff ff       	call   800250 <_panic>

008017cf <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	68 66 42 80 00       	push   $0x804266
  8017dd:	68 f4 00 00 00       	push   $0xf4
  8017e2:	68 22 42 80 00       	push   $0x804222
  8017e7:	e8 64 ea ff ff       	call   800250 <_panic>

008017ec <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	57                   	push   %edi
  8017f0:	56                   	push   %esi
  8017f1:	53                   	push   %ebx
  8017f2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801801:	8b 7d 18             	mov    0x18(%ebp),%edi
  801804:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801807:	cd 30                	int    $0x30
  801809:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80180c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	5b                   	pop    %ebx
  801813:	5e                   	pop    %esi
  801814:	5f                   	pop    %edi
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    

00801817 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 04             	sub    $0x4,%esp
  80181d:	8b 45 10             	mov    0x10(%ebp),%eax
  801820:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801823:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	52                   	push   %edx
  80182f:	ff 75 0c             	pushl  0xc(%ebp)
  801832:	50                   	push   %eax
  801833:	6a 00                	push   $0x0
  801835:	e8 b2 ff ff ff       	call   8017ec <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	90                   	nop
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_cgetc>:

int
sys_cgetc(void)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 02                	push   $0x2
  80184f:	e8 98 ff ff ff       	call   8017ec <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 03                	push   $0x3
  801868:	e8 7f ff ff ff       	call   8017ec <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	90                   	nop
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 04                	push   $0x4
  801882:	e8 65 ff ff ff       	call   8017ec <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801890:	8b 55 0c             	mov    0xc(%ebp),%edx
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	52                   	push   %edx
  80189d:	50                   	push   %eax
  80189e:	6a 08                	push   $0x8
  8018a0:	e8 47 ff ff ff       	call   8017ec <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	56                   	push   %esi
  8018ae:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018af:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	56                   	push   %esi
  8018bf:	53                   	push   %ebx
  8018c0:	51                   	push   %ecx
  8018c1:	52                   	push   %edx
  8018c2:	50                   	push   %eax
  8018c3:	6a 09                	push   $0x9
  8018c5:	e8 22 ff ff ff       	call   8017ec <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d0:	5b                   	pop    %ebx
  8018d1:	5e                   	pop    %esi
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    

008018d4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	52                   	push   %edx
  8018e4:	50                   	push   %eax
  8018e5:	6a 0a                	push   $0xa
  8018e7:	e8 00 ff ff ff       	call   8017ec <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	ff 75 08             	pushl  0x8(%ebp)
  801900:	6a 0b                	push   $0xb
  801902:	e8 e5 fe ff ff       	call   8017ec <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 0c                	push   $0xc
  80191b:	e8 cc fe ff ff       	call   8017ec <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 0d                	push   $0xd
  801934:	e8 b3 fe ff ff       	call   8017ec <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 0e                	push   $0xe
  80194d:	e8 9a fe ff ff       	call   8017ec <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 0f                	push   $0xf
  801966:	e8 81 fe ff ff       	call   8017ec <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	ff 75 08             	pushl  0x8(%ebp)
  80197e:	6a 10                	push   $0x10
  801980:	e8 67 fe ff ff       	call   8017ec <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 11                	push   $0x11
  801999:	e8 4e fe ff ff       	call   8017ec <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	90                   	nop
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019b0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	50                   	push   %eax
  8019bd:	6a 01                	push   $0x1
  8019bf:	e8 28 fe ff ff       	call   8017ec <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	90                   	nop
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 14                	push   $0x14
  8019d9:	e8 0e fe ff ff       	call   8017ec <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019f0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019f3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	51                   	push   %ecx
  8019fd:	52                   	push   %edx
  8019fe:	ff 75 0c             	pushl  0xc(%ebp)
  801a01:	50                   	push   %eax
  801a02:	6a 15                	push   $0x15
  801a04:	e8 e3 fd ff ff       	call   8017ec <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	52                   	push   %edx
  801a1e:	50                   	push   %eax
  801a1f:	6a 16                	push   $0x16
  801a21:	e8 c6 fd ff ff       	call   8017ec <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	51                   	push   %ecx
  801a3c:	52                   	push   %edx
  801a3d:	50                   	push   %eax
  801a3e:	6a 17                	push   $0x17
  801a40:	e8 a7 fd ff ff       	call   8017ec <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	52                   	push   %edx
  801a5a:	50                   	push   %eax
  801a5b:	6a 18                	push   $0x18
  801a5d:	e8 8a fd ff ff       	call   8017ec <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	6a 00                	push   $0x0
  801a6f:	ff 75 14             	pushl  0x14(%ebp)
  801a72:	ff 75 10             	pushl  0x10(%ebp)
  801a75:	ff 75 0c             	pushl  0xc(%ebp)
  801a78:	50                   	push   %eax
  801a79:	6a 19                	push   $0x19
  801a7b:	e8 6c fd ff ff       	call   8017ec <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	50                   	push   %eax
  801a94:	6a 1a                	push   $0x1a
  801a96:	e8 51 fd ff ff       	call   8017ec <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	90                   	nop
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	50                   	push   %eax
  801ab0:	6a 1b                	push   $0x1b
  801ab2:	e8 35 fd ff ff       	call   8017ec <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 05                	push   $0x5
  801acb:	e8 1c fd ff ff       	call   8017ec <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 06                	push   $0x6
  801ae4:	e8 03 fd ff ff       	call   8017ec <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 07                	push   $0x7
  801afd:	e8 ea fc ff ff       	call   8017ec <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_exit_env>:


void sys_exit_env(void)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 1c                	push   $0x1c
  801b16:	e8 d1 fc ff ff       	call   8017ec <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	90                   	nop
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b27:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b2a:	8d 50 04             	lea    0x4(%eax),%edx
  801b2d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	52                   	push   %edx
  801b37:	50                   	push   %eax
  801b38:	6a 1d                	push   $0x1d
  801b3a:	e8 ad fc ff ff       	call   8017ec <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
	return result;
  801b42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4b:	89 01                	mov    %eax,(%ecx)
  801b4d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	c9                   	leave  
  801b54:	c2 04 00             	ret    $0x4

00801b57 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	ff 75 10             	pushl  0x10(%ebp)
  801b61:	ff 75 0c             	pushl  0xc(%ebp)
  801b64:	ff 75 08             	pushl  0x8(%ebp)
  801b67:	6a 13                	push   $0x13
  801b69:	e8 7e fc ff ff       	call   8017ec <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b71:	90                   	nop
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 1e                	push   $0x1e
  801b83:	e8 64 fc ff ff       	call   8017ec <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	83 ec 04             	sub    $0x4,%esp
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b99:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	50                   	push   %eax
  801ba6:	6a 1f                	push   $0x1f
  801ba8:	e8 3f fc ff ff       	call   8017ec <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb0:	90                   	nop
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <rsttst>:
void rsttst()
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 21                	push   $0x21
  801bc2:	e8 25 fc ff ff       	call   8017ec <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bca:	90                   	nop
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 04             	sub    $0x4,%esp
  801bd3:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bd9:	8b 55 18             	mov    0x18(%ebp),%edx
  801bdc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be0:	52                   	push   %edx
  801be1:	50                   	push   %eax
  801be2:	ff 75 10             	pushl  0x10(%ebp)
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	6a 20                	push   $0x20
  801bed:	e8 fa fb ff ff       	call   8017ec <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf5:	90                   	nop
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <chktst>:
void chktst(uint32 n)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	ff 75 08             	pushl  0x8(%ebp)
  801c06:	6a 22                	push   $0x22
  801c08:	e8 df fb ff ff       	call   8017ec <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c10:	90                   	nop
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <inctst>:

void inctst()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 23                	push   $0x23
  801c22:	e8 c5 fb ff ff       	call   8017ec <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2a:	90                   	nop
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <gettst>:
uint32 gettst()
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 24                	push   $0x24
  801c3c:	e8 ab fb ff ff       	call   8017ec <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 25                	push   $0x25
  801c58:	e8 8f fb ff ff       	call   8017ec <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
  801c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c63:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c67:	75 07                	jne    801c70 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c69:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6e:	eb 05                	jmp    801c75 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 25                	push   $0x25
  801c89:	e8 5e fb ff ff       	call   8017ec <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
  801c91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c94:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c98:	75 07                	jne    801ca1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9f:	eb 05                	jmp    801ca6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 25                	push   $0x25
  801cba:	e8 2d fb ff ff       	call   8017ec <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
  801cc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cc5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cc9:	75 07                	jne    801cd2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ccb:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd0:	eb 05                	jmp    801cd7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 25                	push   $0x25
  801ceb:	e8 fc fa ff ff       	call   8017ec <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
  801cf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cf6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cfa:	75 07                	jne    801d03 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cfc:	b8 01 00 00 00       	mov    $0x1,%eax
  801d01:	eb 05                	jmp    801d08 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	ff 75 08             	pushl  0x8(%ebp)
  801d18:	6a 26                	push   $0x26
  801d1a:	e8 cd fa ff ff       	call   8017ec <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d22:	90                   	nop
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d29:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	6a 00                	push   $0x0
  801d37:	53                   	push   %ebx
  801d38:	51                   	push   %ecx
  801d39:	52                   	push   %edx
  801d3a:	50                   	push   %eax
  801d3b:	6a 27                	push   $0x27
  801d3d:	e8 aa fa ff ff       	call   8017ec <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d50:	8b 45 08             	mov    0x8(%ebp),%eax
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	52                   	push   %edx
  801d5a:	50                   	push   %eax
  801d5b:	6a 28                	push   $0x28
  801d5d:	e8 8a fa ff ff       	call   8017ec <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d6a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	6a 00                	push   $0x0
  801d75:	51                   	push   %ecx
  801d76:	ff 75 10             	pushl  0x10(%ebp)
  801d79:	52                   	push   %edx
  801d7a:	50                   	push   %eax
  801d7b:	6a 29                	push   $0x29
  801d7d:	e8 6a fa ff ff       	call   8017ec <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	ff 75 10             	pushl  0x10(%ebp)
  801d91:	ff 75 0c             	pushl  0xc(%ebp)
  801d94:	ff 75 08             	pushl  0x8(%ebp)
  801d97:	6a 12                	push   $0x12
  801d99:	e8 4e fa ff ff       	call   8017ec <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801da1:	90                   	nop
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801da7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	52                   	push   %edx
  801db4:	50                   	push   %eax
  801db5:	6a 2a                	push   $0x2a
  801db7:	e8 30 fa ff ff       	call   8017ec <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
	return;
  801dbf:	90                   	nop
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	50                   	push   %eax
  801dd1:	6a 2b                	push   $0x2b
  801dd3:	e8 14 fa ff ff       	call   8017ec <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	ff 75 0c             	pushl  0xc(%ebp)
  801de9:	ff 75 08             	pushl  0x8(%ebp)
  801dec:	6a 2c                	push   $0x2c
  801dee:	e8 f9 f9 ff ff       	call   8017ec <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
	return;
  801df6:	90                   	nop
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	ff 75 0c             	pushl  0xc(%ebp)
  801e05:	ff 75 08             	pushl  0x8(%ebp)
  801e08:	6a 2d                	push   $0x2d
  801e0a:	e8 dd f9 ff ff       	call   8017ec <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
	return;
  801e12:	90                   	nop
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	83 e8 04             	sub    $0x4,%eax
  801e21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e27:	8b 00                	mov    (%eax),%eax
  801e29:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	83 e8 04             	sub    $0x4,%eax
  801e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e40:	8b 00                	mov    (%eax),%eax
  801e42:	83 e0 01             	and    $0x1,%eax
  801e45:	85 c0                	test   %eax,%eax
  801e47:	0f 94 c0             	sete   %al
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5c:	83 f8 02             	cmp    $0x2,%eax
  801e5f:	74 2b                	je     801e8c <alloc_block+0x40>
  801e61:	83 f8 02             	cmp    $0x2,%eax
  801e64:	7f 07                	jg     801e6d <alloc_block+0x21>
  801e66:	83 f8 01             	cmp    $0x1,%eax
  801e69:	74 0e                	je     801e79 <alloc_block+0x2d>
  801e6b:	eb 58                	jmp    801ec5 <alloc_block+0x79>
  801e6d:	83 f8 03             	cmp    $0x3,%eax
  801e70:	74 2d                	je     801e9f <alloc_block+0x53>
  801e72:	83 f8 04             	cmp    $0x4,%eax
  801e75:	74 3b                	je     801eb2 <alloc_block+0x66>
  801e77:	eb 4c                	jmp    801ec5 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	ff 75 08             	pushl  0x8(%ebp)
  801e7f:	e8 11 03 00 00       	call   802195 <alloc_block_FF>
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e8a:	eb 4a                	jmp    801ed6 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e8c:	83 ec 0c             	sub    $0xc,%esp
  801e8f:	ff 75 08             	pushl  0x8(%ebp)
  801e92:	e8 fa 19 00 00       	call   803891 <alloc_block_NF>
  801e97:	83 c4 10             	add    $0x10,%esp
  801e9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e9d:	eb 37                	jmp    801ed6 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	ff 75 08             	pushl  0x8(%ebp)
  801ea5:	e8 a7 07 00 00       	call   802651 <alloc_block_BF>
  801eaa:	83 c4 10             	add    $0x10,%esp
  801ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eb0:	eb 24                	jmp    801ed6 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801eb2:	83 ec 0c             	sub    $0xc,%esp
  801eb5:	ff 75 08             	pushl  0x8(%ebp)
  801eb8:	e8 b7 19 00 00       	call   803874 <alloc_block_WF>
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ec3:	eb 11                	jmp    801ed6 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	68 78 42 80 00       	push   $0x804278
  801ecd:	e8 3b e6 ff ff       	call   80050d <cprintf>
  801ed2:	83 c4 10             	add    $0x10,%esp
		break;
  801ed5:	90                   	nop
	}
	return va;
  801ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	53                   	push   %ebx
  801edf:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	68 98 42 80 00       	push   $0x804298
  801eea:	e8 1e e6 ff ff       	call   80050d <cprintf>
  801eef:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ef2:	83 ec 0c             	sub    $0xc,%esp
  801ef5:	68 c3 42 80 00       	push   $0x8042c3
  801efa:	e8 0e e6 ff ff       	call   80050d <cprintf>
  801eff:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f08:	eb 37                	jmp    801f41 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f10:	e8 19 ff ff ff       	call   801e2e <is_free_block>
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	0f be d8             	movsbl %al,%ebx
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f21:	e8 ef fe ff ff       	call   801e15 <get_block_size>
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	83 ec 04             	sub    $0x4,%esp
  801f2c:	53                   	push   %ebx
  801f2d:	50                   	push   %eax
  801f2e:	68 db 42 80 00       	push   $0x8042db
  801f33:	e8 d5 e5 ff ff       	call   80050d <cprintf>
  801f38:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f45:	74 07                	je     801f4e <print_blocks_list+0x73>
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	8b 00                	mov    (%eax),%eax
  801f4c:	eb 05                	jmp    801f53 <print_blocks_list+0x78>
  801f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f53:	89 45 10             	mov    %eax,0x10(%ebp)
  801f56:	8b 45 10             	mov    0x10(%ebp),%eax
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	75 ad                	jne    801f0a <print_blocks_list+0x2f>
  801f5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f61:	75 a7                	jne    801f0a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f63:	83 ec 0c             	sub    $0xc,%esp
  801f66:	68 98 42 80 00       	push   $0x804298
  801f6b:	e8 9d e5 ff ff       	call   80050d <cprintf>
  801f70:	83 c4 10             	add    $0x10,%esp

}
  801f73:	90                   	nop
  801f74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f82:	83 e0 01             	and    $0x1,%eax
  801f85:	85 c0                	test   %eax,%eax
  801f87:	74 03                	je     801f8c <initialize_dynamic_allocator+0x13>
  801f89:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f90:	0f 84 c7 01 00 00    	je     80215d <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f96:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f9d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa6:	01 d0                	add    %edx,%eax
  801fa8:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801fad:	0f 87 ad 01 00 00    	ja     802160 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	0f 89 a5 01 00 00    	jns    802163 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801fbe:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc4:	01 d0                	add    %edx,%eax
  801fc6:	83 e8 04             	sub    $0x4,%eax
  801fc9:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801fce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801fd5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fdd:	e9 87 00 00 00       	jmp    802069 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe6:	75 14                	jne    801ffc <initialize_dynamic_allocator+0x83>
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	68 f3 42 80 00       	push   $0x8042f3
  801ff0:	6a 79                	push   $0x79
  801ff2:	68 11 43 80 00       	push   $0x804311
  801ff7:	e8 54 e2 ff ff       	call   800250 <_panic>
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	8b 00                	mov    (%eax),%eax
  802001:	85 c0                	test   %eax,%eax
  802003:	74 10                	je     802015 <initialize_dynamic_allocator+0x9c>
  802005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802008:	8b 00                	mov    (%eax),%eax
  80200a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200d:	8b 52 04             	mov    0x4(%edx),%edx
  802010:	89 50 04             	mov    %edx,0x4(%eax)
  802013:	eb 0b                	jmp    802020 <initialize_dynamic_allocator+0xa7>
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	8b 40 04             	mov    0x4(%eax),%eax
  80201b:	a3 30 50 80 00       	mov    %eax,0x805030
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	8b 40 04             	mov    0x4(%eax),%eax
  802026:	85 c0                	test   %eax,%eax
  802028:	74 0f                	je     802039 <initialize_dynamic_allocator+0xc0>
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	8b 40 04             	mov    0x4(%eax),%eax
  802030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802033:	8b 12                	mov    (%edx),%edx
  802035:	89 10                	mov    %edx,(%eax)
  802037:	eb 0a                	jmp    802043 <initialize_dynamic_allocator+0xca>
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	8b 00                	mov    (%eax),%eax
  80203e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802046:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802056:	a1 38 50 80 00       	mov    0x805038,%eax
  80205b:	48                   	dec    %eax
  80205c:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802061:	a1 34 50 80 00       	mov    0x805034,%eax
  802066:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802069:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206d:	74 07                	je     802076 <initialize_dynamic_allocator+0xfd>
  80206f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802072:	8b 00                	mov    (%eax),%eax
  802074:	eb 05                	jmp    80207b <initialize_dynamic_allocator+0x102>
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
  80207b:	a3 34 50 80 00       	mov    %eax,0x805034
  802080:	a1 34 50 80 00       	mov    0x805034,%eax
  802085:	85 c0                	test   %eax,%eax
  802087:	0f 85 55 ff ff ff    	jne    801fe2 <initialize_dynamic_allocator+0x69>
  80208d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802091:	0f 85 4b ff ff ff    	jne    801fe2 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80209d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8020a6:	a1 44 50 80 00       	mov    0x805044,%eax
  8020ab:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8020b0:	a1 40 50 80 00       	mov    0x805040,%eax
  8020b5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	83 c0 08             	add    $0x8,%eax
  8020c1:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	83 c0 04             	add    $0x4,%eax
  8020ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cd:	83 ea 08             	sub    $0x8,%edx
  8020d0:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	01 d0                	add    %edx,%eax
  8020da:	83 e8 08             	sub    $0x8,%eax
  8020dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e0:	83 ea 08             	sub    $0x8,%edx
  8020e3:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020fc:	75 17                	jne    802115 <initialize_dynamic_allocator+0x19c>
  8020fe:	83 ec 04             	sub    $0x4,%esp
  802101:	68 2c 43 80 00       	push   $0x80432c
  802106:	68 90 00 00 00       	push   $0x90
  80210b:	68 11 43 80 00       	push   $0x804311
  802110:	e8 3b e1 ff ff       	call   800250 <_panic>
  802115:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80211b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211e:	89 10                	mov    %edx,(%eax)
  802120:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802123:	8b 00                	mov    (%eax),%eax
  802125:	85 c0                	test   %eax,%eax
  802127:	74 0d                	je     802136 <initialize_dynamic_allocator+0x1bd>
  802129:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80212e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802131:	89 50 04             	mov    %edx,0x4(%eax)
  802134:	eb 08                	jmp    80213e <initialize_dynamic_allocator+0x1c5>
  802136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802139:	a3 30 50 80 00       	mov    %eax,0x805030
  80213e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802141:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802149:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802150:	a1 38 50 80 00       	mov    0x805038,%eax
  802155:	40                   	inc    %eax
  802156:	a3 38 50 80 00       	mov    %eax,0x805038
  80215b:	eb 07                	jmp    802164 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80215d:	90                   	nop
  80215e:	eb 04                	jmp    802164 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802160:	90                   	nop
  802161:	eb 01                	jmp    802164 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802163:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802169:	8b 45 10             	mov    0x10(%ebp),%eax
  80216c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	8d 50 fc             	lea    -0x4(%eax),%edx
  802175:	8b 45 0c             	mov    0xc(%ebp),%eax
  802178:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	83 e8 04             	sub    $0x4,%eax
  802180:	8b 00                	mov    (%eax),%eax
  802182:	83 e0 fe             	and    $0xfffffffe,%eax
  802185:	8d 50 f8             	lea    -0x8(%eax),%edx
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	01 c2                	add    %eax,%edx
  80218d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802190:	89 02                	mov    %eax,(%edx)
}
  802192:	90                   	nop
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    

00802195 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	83 e0 01             	and    $0x1,%eax
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	74 03                	je     8021a8 <alloc_block_FF+0x13>
  8021a5:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8021a8:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8021ac:	77 07                	ja     8021b5 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8021ae:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021b5:	a1 24 50 80 00       	mov    0x805024,%eax
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	75 73                	jne    802231 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	83 c0 10             	add    $0x10,%eax
  8021c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021c7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8021ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d4:	01 d0                	add    %edx,%eax
  8021d6:	48                   	dec    %eax
  8021d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e2:	f7 75 ec             	divl   -0x14(%ebp)
  8021e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021e8:	29 d0                	sub    %edx,%eax
  8021ea:	c1 e8 0c             	shr    $0xc,%eax
  8021ed:	83 ec 0c             	sub    $0xc,%esp
  8021f0:	50                   	push   %eax
  8021f1:	e8 b1 f0 ff ff       	call   8012a7 <sbrk>
  8021f6:	83 c4 10             	add    $0x10,%esp
  8021f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021fc:	83 ec 0c             	sub    $0xc,%esp
  8021ff:	6a 00                	push   $0x0
  802201:	e8 a1 f0 ff ff       	call   8012a7 <sbrk>
  802206:	83 c4 10             	add    $0x10,%esp
  802209:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80220c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80220f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802212:	83 ec 08             	sub    $0x8,%esp
  802215:	50                   	push   %eax
  802216:	ff 75 e4             	pushl  -0x1c(%ebp)
  802219:	e8 5b fd ff ff       	call   801f79 <initialize_dynamic_allocator>
  80221e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802221:	83 ec 0c             	sub    $0xc,%esp
  802224:	68 4f 43 80 00       	push   $0x80434f
  802229:	e8 df e2 ff ff       	call   80050d <cprintf>
  80222e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802231:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802235:	75 0a                	jne    802241 <alloc_block_FF+0xac>
	        return NULL;
  802237:	b8 00 00 00 00       	mov    $0x0,%eax
  80223c:	e9 0e 04 00 00       	jmp    80264f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802241:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802248:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80224d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802250:	e9 f3 02 00 00       	jmp    802548 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80225b:	83 ec 0c             	sub    $0xc,%esp
  80225e:	ff 75 bc             	pushl  -0x44(%ebp)
  802261:	e8 af fb ff ff       	call   801e15 <get_block_size>
  802266:	83 c4 10             	add    $0x10,%esp
  802269:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	83 c0 08             	add    $0x8,%eax
  802272:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802275:	0f 87 c5 02 00 00    	ja     802540 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	83 c0 18             	add    $0x18,%eax
  802281:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802284:	0f 87 19 02 00 00    	ja     8024a3 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80228a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80228d:	2b 45 08             	sub    0x8(%ebp),%eax
  802290:	83 e8 08             	sub    $0x8,%eax
  802293:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	8d 50 08             	lea    0x8(%eax),%edx
  80229c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80229f:	01 d0                	add    %edx,%eax
  8022a1:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	83 c0 08             	add    $0x8,%eax
  8022aa:	83 ec 04             	sub    $0x4,%esp
  8022ad:	6a 01                	push   $0x1
  8022af:	50                   	push   %eax
  8022b0:	ff 75 bc             	pushl  -0x44(%ebp)
  8022b3:	e8 ae fe ff ff       	call   802166 <set_block_data>
  8022b8:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 40 04             	mov    0x4(%eax),%eax
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	75 68                	jne    80232d <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022c5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022c9:	75 17                	jne    8022e2 <alloc_block_FF+0x14d>
  8022cb:	83 ec 04             	sub    $0x4,%esp
  8022ce:	68 2c 43 80 00       	push   $0x80432c
  8022d3:	68 d7 00 00 00       	push   $0xd7
  8022d8:	68 11 43 80 00       	push   $0x804311
  8022dd:	e8 6e df ff ff       	call   800250 <_panic>
  8022e2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022eb:	89 10                	mov    %edx,(%eax)
  8022ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f0:	8b 00                	mov    (%eax),%eax
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	74 0d                	je     802303 <alloc_block_FF+0x16e>
  8022f6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022fb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022fe:	89 50 04             	mov    %edx,0x4(%eax)
  802301:	eb 08                	jmp    80230b <alloc_block_FF+0x176>
  802303:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802306:	a3 30 50 80 00       	mov    %eax,0x805030
  80230b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80230e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802313:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802316:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80231d:	a1 38 50 80 00       	mov    0x805038,%eax
  802322:	40                   	inc    %eax
  802323:	a3 38 50 80 00       	mov    %eax,0x805038
  802328:	e9 dc 00 00 00       	jmp    802409 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	85 c0                	test   %eax,%eax
  802334:	75 65                	jne    80239b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802336:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80233a:	75 17                	jne    802353 <alloc_block_FF+0x1be>
  80233c:	83 ec 04             	sub    $0x4,%esp
  80233f:	68 60 43 80 00       	push   $0x804360
  802344:	68 db 00 00 00       	push   $0xdb
  802349:	68 11 43 80 00       	push   $0x804311
  80234e:	e8 fd de ff ff       	call   800250 <_panic>
  802353:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802359:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80235c:	89 50 04             	mov    %edx,0x4(%eax)
  80235f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802362:	8b 40 04             	mov    0x4(%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	74 0c                	je     802375 <alloc_block_FF+0x1e0>
  802369:	a1 30 50 80 00       	mov    0x805030,%eax
  80236e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802371:	89 10                	mov    %edx,(%eax)
  802373:	eb 08                	jmp    80237d <alloc_block_FF+0x1e8>
  802375:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802378:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80237d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802380:	a3 30 50 80 00       	mov    %eax,0x805030
  802385:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238e:	a1 38 50 80 00       	mov    0x805038,%eax
  802393:	40                   	inc    %eax
  802394:	a3 38 50 80 00       	mov    %eax,0x805038
  802399:	eb 6e                	jmp    802409 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80239b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239f:	74 06                	je     8023a7 <alloc_block_FF+0x212>
  8023a1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023a5:	75 17                	jne    8023be <alloc_block_FF+0x229>
  8023a7:	83 ec 04             	sub    $0x4,%esp
  8023aa:	68 84 43 80 00       	push   $0x804384
  8023af:	68 df 00 00 00       	push   $0xdf
  8023b4:	68 11 43 80 00       	push   $0x804311
  8023b9:	e8 92 de ff ff       	call   800250 <_panic>
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	8b 10                	mov    (%eax),%edx
  8023c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c6:	89 10                	mov    %edx,(%eax)
  8023c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023cb:	8b 00                	mov    (%eax),%eax
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	74 0b                	je     8023dc <alloc_block_FF+0x247>
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023d9:	89 50 04             	mov    %edx,0x4(%eax)
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023e2:	89 10                	mov    %edx,(%eax)
  8023e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ea:	89 50 04             	mov    %edx,0x4(%eax)
  8023ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f0:	8b 00                	mov    (%eax),%eax
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	75 08                	jne    8023fe <alloc_block_FF+0x269>
  8023f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8023fe:	a1 38 50 80 00       	mov    0x805038,%eax
  802403:	40                   	inc    %eax
  802404:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	75 17                	jne    802426 <alloc_block_FF+0x291>
  80240f:	83 ec 04             	sub    $0x4,%esp
  802412:	68 f3 42 80 00       	push   $0x8042f3
  802417:	68 e1 00 00 00       	push   $0xe1
  80241c:	68 11 43 80 00       	push   $0x804311
  802421:	e8 2a de ff ff       	call   800250 <_panic>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	74 10                	je     80243f <alloc_block_FF+0x2aa>
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802437:	8b 52 04             	mov    0x4(%edx),%edx
  80243a:	89 50 04             	mov    %edx,0x4(%eax)
  80243d:	eb 0b                	jmp    80244a <alloc_block_FF+0x2b5>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 40 04             	mov    0x4(%eax),%eax
  802445:	a3 30 50 80 00       	mov    %eax,0x805030
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 40 04             	mov    0x4(%eax),%eax
  802450:	85 c0                	test   %eax,%eax
  802452:	74 0f                	je     802463 <alloc_block_FF+0x2ce>
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245d:	8b 12                	mov    (%edx),%edx
  80245f:	89 10                	mov    %edx,(%eax)
  802461:	eb 0a                	jmp    80246d <alloc_block_FF+0x2d8>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802480:	a1 38 50 80 00       	mov    0x805038,%eax
  802485:	48                   	dec    %eax
  802486:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80248b:	83 ec 04             	sub    $0x4,%esp
  80248e:	6a 00                	push   $0x0
  802490:	ff 75 b4             	pushl  -0x4c(%ebp)
  802493:	ff 75 b0             	pushl  -0x50(%ebp)
  802496:	e8 cb fc ff ff       	call   802166 <set_block_data>
  80249b:	83 c4 10             	add    $0x10,%esp
  80249e:	e9 95 00 00 00       	jmp    802538 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024a3:	83 ec 04             	sub    $0x4,%esp
  8024a6:	6a 01                	push   $0x1
  8024a8:	ff 75 b8             	pushl  -0x48(%ebp)
  8024ab:	ff 75 bc             	pushl  -0x44(%ebp)
  8024ae:	e8 b3 fc ff ff       	call   802166 <set_block_data>
  8024b3:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ba:	75 17                	jne    8024d3 <alloc_block_FF+0x33e>
  8024bc:	83 ec 04             	sub    $0x4,%esp
  8024bf:	68 f3 42 80 00       	push   $0x8042f3
  8024c4:	68 e8 00 00 00       	push   $0xe8
  8024c9:	68 11 43 80 00       	push   $0x804311
  8024ce:	e8 7d dd ff ff       	call   800250 <_panic>
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 00                	mov    (%eax),%eax
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	74 10                	je     8024ec <alloc_block_FF+0x357>
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e4:	8b 52 04             	mov    0x4(%edx),%edx
  8024e7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ea:	eb 0b                	jmp    8024f7 <alloc_block_FF+0x362>
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 40 04             	mov    0x4(%eax),%eax
  8024f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	8b 40 04             	mov    0x4(%eax),%eax
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	74 0f                	je     802510 <alloc_block_FF+0x37b>
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 40 04             	mov    0x4(%eax),%eax
  802507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250a:	8b 12                	mov    (%edx),%edx
  80250c:	89 10                	mov    %edx,(%eax)
  80250e:	eb 0a                	jmp    80251a <alloc_block_FF+0x385>
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252d:	a1 38 50 80 00       	mov    0x805038,%eax
  802532:	48                   	dec    %eax
  802533:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802538:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80253b:	e9 0f 01 00 00       	jmp    80264f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802540:	a1 34 50 80 00       	mov    0x805034,%eax
  802545:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254c:	74 07                	je     802555 <alloc_block_FF+0x3c0>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	eb 05                	jmp    80255a <alloc_block_FF+0x3c5>
  802555:	b8 00 00 00 00       	mov    $0x0,%eax
  80255a:	a3 34 50 80 00       	mov    %eax,0x805034
  80255f:	a1 34 50 80 00       	mov    0x805034,%eax
  802564:	85 c0                	test   %eax,%eax
  802566:	0f 85 e9 fc ff ff    	jne    802255 <alloc_block_FF+0xc0>
  80256c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802570:	0f 85 df fc ff ff    	jne    802255 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	83 c0 08             	add    $0x8,%eax
  80257c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80257f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802586:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802589:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80258c:	01 d0                	add    %edx,%eax
  80258e:	48                   	dec    %eax
  80258f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802592:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802595:	ba 00 00 00 00       	mov    $0x0,%edx
  80259a:	f7 75 d8             	divl   -0x28(%ebp)
  80259d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025a0:	29 d0                	sub    %edx,%eax
  8025a2:	c1 e8 0c             	shr    $0xc,%eax
  8025a5:	83 ec 0c             	sub    $0xc,%esp
  8025a8:	50                   	push   %eax
  8025a9:	e8 f9 ec ff ff       	call   8012a7 <sbrk>
  8025ae:	83 c4 10             	add    $0x10,%esp
  8025b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025b4:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025b8:	75 0a                	jne    8025c4 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bf:	e9 8b 00 00 00       	jmp    80264f <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025c4:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025d1:	01 d0                	add    %edx,%eax
  8025d3:	48                   	dec    %eax
  8025d4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025da:	ba 00 00 00 00       	mov    $0x0,%edx
  8025df:	f7 75 cc             	divl   -0x34(%ebp)
  8025e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025e5:	29 d0                	sub    %edx,%eax
  8025e7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025ed:	01 d0                	add    %edx,%eax
  8025ef:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8025f4:	a1 40 50 80 00       	mov    0x805040,%eax
  8025f9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025ff:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802606:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802609:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80260c:	01 d0                	add    %edx,%eax
  80260e:	48                   	dec    %eax
  80260f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802612:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802615:	ba 00 00 00 00       	mov    $0x0,%edx
  80261a:	f7 75 c4             	divl   -0x3c(%ebp)
  80261d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802620:	29 d0                	sub    %edx,%eax
  802622:	83 ec 04             	sub    $0x4,%esp
  802625:	6a 01                	push   $0x1
  802627:	50                   	push   %eax
  802628:	ff 75 d0             	pushl  -0x30(%ebp)
  80262b:	e8 36 fb ff ff       	call   802166 <set_block_data>
  802630:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802633:	83 ec 0c             	sub    $0xc,%esp
  802636:	ff 75 d0             	pushl  -0x30(%ebp)
  802639:	e8 1b 0a 00 00       	call   803059 <free_block>
  80263e:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802641:	83 ec 0c             	sub    $0xc,%esp
  802644:	ff 75 08             	pushl  0x8(%ebp)
  802647:	e8 49 fb ff ff       	call   802195 <alloc_block_FF>
  80264c:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802657:	8b 45 08             	mov    0x8(%ebp),%eax
  80265a:	83 e0 01             	and    $0x1,%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 03                	je     802664 <alloc_block_BF+0x13>
  802661:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802664:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802668:	77 07                	ja     802671 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80266a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802671:	a1 24 50 80 00       	mov    0x805024,%eax
  802676:	85 c0                	test   %eax,%eax
  802678:	75 73                	jne    8026ed <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80267a:	8b 45 08             	mov    0x8(%ebp),%eax
  80267d:	83 c0 10             	add    $0x10,%eax
  802680:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802683:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80268a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80268d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802690:	01 d0                	add    %edx,%eax
  802692:	48                   	dec    %eax
  802693:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802696:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802699:	ba 00 00 00 00       	mov    $0x0,%edx
  80269e:	f7 75 e0             	divl   -0x20(%ebp)
  8026a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026a4:	29 d0                	sub    %edx,%eax
  8026a6:	c1 e8 0c             	shr    $0xc,%eax
  8026a9:	83 ec 0c             	sub    $0xc,%esp
  8026ac:	50                   	push   %eax
  8026ad:	e8 f5 eb ff ff       	call   8012a7 <sbrk>
  8026b2:	83 c4 10             	add    $0x10,%esp
  8026b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026b8:	83 ec 0c             	sub    $0xc,%esp
  8026bb:	6a 00                	push   $0x0
  8026bd:	e8 e5 eb ff ff       	call   8012a7 <sbrk>
  8026c2:	83 c4 10             	add    $0x10,%esp
  8026c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026cb:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8026ce:	83 ec 08             	sub    $0x8,%esp
  8026d1:	50                   	push   %eax
  8026d2:	ff 75 d8             	pushl  -0x28(%ebp)
  8026d5:	e8 9f f8 ff ff       	call   801f79 <initialize_dynamic_allocator>
  8026da:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026dd:	83 ec 0c             	sub    $0xc,%esp
  8026e0:	68 4f 43 80 00       	push   $0x80434f
  8026e5:	e8 23 de ff ff       	call   80050d <cprintf>
  8026ea:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026fb:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802702:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802709:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80270e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802711:	e9 1d 01 00 00       	jmp    802833 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80271c:	83 ec 0c             	sub    $0xc,%esp
  80271f:	ff 75 a8             	pushl  -0x58(%ebp)
  802722:	e8 ee f6 ff ff       	call   801e15 <get_block_size>
  802727:	83 c4 10             	add    $0x10,%esp
  80272a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	83 c0 08             	add    $0x8,%eax
  802733:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802736:	0f 87 ef 00 00 00    	ja     80282b <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	83 c0 18             	add    $0x18,%eax
  802742:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802745:	77 1d                	ja     802764 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802747:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80274d:	0f 86 d8 00 00 00    	jbe    80282b <alloc_block_BF+0x1da>
				{
					best_va = va;
  802753:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802756:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802759:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80275c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80275f:	e9 c7 00 00 00       	jmp    80282b <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802764:	8b 45 08             	mov    0x8(%ebp),%eax
  802767:	83 c0 08             	add    $0x8,%eax
  80276a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80276d:	0f 85 9d 00 00 00    	jne    802810 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802773:	83 ec 04             	sub    $0x4,%esp
  802776:	6a 01                	push   $0x1
  802778:	ff 75 a4             	pushl  -0x5c(%ebp)
  80277b:	ff 75 a8             	pushl  -0x58(%ebp)
  80277e:	e8 e3 f9 ff ff       	call   802166 <set_block_data>
  802783:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802786:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278a:	75 17                	jne    8027a3 <alloc_block_BF+0x152>
  80278c:	83 ec 04             	sub    $0x4,%esp
  80278f:	68 f3 42 80 00       	push   $0x8042f3
  802794:	68 2c 01 00 00       	push   $0x12c
  802799:	68 11 43 80 00       	push   $0x804311
  80279e:	e8 ad da ff ff       	call   800250 <_panic>
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 00                	mov    (%eax),%eax
  8027a8:	85 c0                	test   %eax,%eax
  8027aa:	74 10                	je     8027bc <alloc_block_BF+0x16b>
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b4:	8b 52 04             	mov    0x4(%edx),%edx
  8027b7:	89 50 04             	mov    %edx,0x4(%eax)
  8027ba:	eb 0b                	jmp    8027c7 <alloc_block_BF+0x176>
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 40 04             	mov    0x4(%eax),%eax
  8027c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 40 04             	mov    0x4(%eax),%eax
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	74 0f                	je     8027e0 <alloc_block_BF+0x18f>
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027da:	8b 12                	mov    (%edx),%edx
  8027dc:	89 10                	mov    %edx,(%eax)
  8027de:	eb 0a                	jmp    8027ea <alloc_block_BF+0x199>
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 00                	mov    (%eax),%eax
  8027e5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027fd:	a1 38 50 80 00       	mov    0x805038,%eax
  802802:	48                   	dec    %eax
  802803:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802808:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80280b:	e9 24 04 00 00       	jmp    802c34 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802813:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802816:	76 13                	jbe    80282b <alloc_block_BF+0x1da>
					{
						internal = 1;
  802818:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80281f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802822:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802825:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802828:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80282b:	a1 34 50 80 00       	mov    0x805034,%eax
  802830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802833:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802837:	74 07                	je     802840 <alloc_block_BF+0x1ef>
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	eb 05                	jmp    802845 <alloc_block_BF+0x1f4>
  802840:	b8 00 00 00 00       	mov    $0x0,%eax
  802845:	a3 34 50 80 00       	mov    %eax,0x805034
  80284a:	a1 34 50 80 00       	mov    0x805034,%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	0f 85 bf fe ff ff    	jne    802716 <alloc_block_BF+0xc5>
  802857:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285b:	0f 85 b5 fe ff ff    	jne    802716 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802861:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802865:	0f 84 26 02 00 00    	je     802a91 <alloc_block_BF+0x440>
  80286b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80286f:	0f 85 1c 02 00 00    	jne    802a91 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802878:	2b 45 08             	sub    0x8(%ebp),%eax
  80287b:	83 e8 08             	sub    $0x8,%eax
  80287e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802881:	8b 45 08             	mov    0x8(%ebp),%eax
  802884:	8d 50 08             	lea    0x8(%eax),%edx
  802887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288a:	01 d0                	add    %edx,%eax
  80288c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	83 c0 08             	add    $0x8,%eax
  802895:	83 ec 04             	sub    $0x4,%esp
  802898:	6a 01                	push   $0x1
  80289a:	50                   	push   %eax
  80289b:	ff 75 f0             	pushl  -0x10(%ebp)
  80289e:	e8 c3 f8 ff ff       	call   802166 <set_block_data>
  8028a3:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8028a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	75 68                	jne    802918 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028b0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028b4:	75 17                	jne    8028cd <alloc_block_BF+0x27c>
  8028b6:	83 ec 04             	sub    $0x4,%esp
  8028b9:	68 2c 43 80 00       	push   $0x80432c
  8028be:	68 45 01 00 00       	push   $0x145
  8028c3:	68 11 43 80 00       	push   $0x804311
  8028c8:	e8 83 d9 ff ff       	call   800250 <_panic>
  8028cd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d6:	89 10                	mov    %edx,(%eax)
  8028d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028db:	8b 00                	mov    (%eax),%eax
  8028dd:	85 c0                	test   %eax,%eax
  8028df:	74 0d                	je     8028ee <alloc_block_BF+0x29d>
  8028e1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028e6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028e9:	89 50 04             	mov    %edx,0x4(%eax)
  8028ec:	eb 08                	jmp    8028f6 <alloc_block_BF+0x2a5>
  8028ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8028f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802901:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802908:	a1 38 50 80 00       	mov    0x805038,%eax
  80290d:	40                   	inc    %eax
  80290e:	a3 38 50 80 00       	mov    %eax,0x805038
  802913:	e9 dc 00 00 00       	jmp    8029f4 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	75 65                	jne    802986 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802921:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802925:	75 17                	jne    80293e <alloc_block_BF+0x2ed>
  802927:	83 ec 04             	sub    $0x4,%esp
  80292a:	68 60 43 80 00       	push   $0x804360
  80292f:	68 4a 01 00 00       	push   $0x14a
  802934:	68 11 43 80 00       	push   $0x804311
  802939:	e8 12 d9 ff ff       	call   800250 <_panic>
  80293e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802944:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802947:	89 50 04             	mov    %edx,0x4(%eax)
  80294a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80294d:	8b 40 04             	mov    0x4(%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	74 0c                	je     802960 <alloc_block_BF+0x30f>
  802954:	a1 30 50 80 00       	mov    0x805030,%eax
  802959:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80295c:	89 10                	mov    %edx,(%eax)
  80295e:	eb 08                	jmp    802968 <alloc_block_BF+0x317>
  802960:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802963:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802968:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80296b:	a3 30 50 80 00       	mov    %eax,0x805030
  802970:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802973:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802979:	a1 38 50 80 00       	mov    0x805038,%eax
  80297e:	40                   	inc    %eax
  80297f:	a3 38 50 80 00       	mov    %eax,0x805038
  802984:	eb 6e                	jmp    8029f4 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802986:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80298a:	74 06                	je     802992 <alloc_block_BF+0x341>
  80298c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802990:	75 17                	jne    8029a9 <alloc_block_BF+0x358>
  802992:	83 ec 04             	sub    $0x4,%esp
  802995:	68 84 43 80 00       	push   $0x804384
  80299a:	68 4f 01 00 00       	push   $0x14f
  80299f:	68 11 43 80 00       	push   $0x804311
  8029a4:	e8 a7 d8 ff ff       	call   800250 <_panic>
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	8b 10                	mov    (%eax),%edx
  8029ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b1:	89 10                	mov    %edx,(%eax)
  8029b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	74 0b                	je     8029c7 <alloc_block_BF+0x376>
  8029bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029c4:	89 50 04             	mov    %edx,0x4(%eax)
  8029c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ca:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029cd:	89 10                	mov    %edx,(%eax)
  8029cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d5:	89 50 04             	mov    %edx,0x4(%eax)
  8029d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029db:	8b 00                	mov    (%eax),%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	75 08                	jne    8029e9 <alloc_block_BF+0x398>
  8029e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8029e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8029ee:	40                   	inc    %eax
  8029ef:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f8:	75 17                	jne    802a11 <alloc_block_BF+0x3c0>
  8029fa:	83 ec 04             	sub    $0x4,%esp
  8029fd:	68 f3 42 80 00       	push   $0x8042f3
  802a02:	68 51 01 00 00       	push   $0x151
  802a07:	68 11 43 80 00       	push   $0x804311
  802a0c:	e8 3f d8 ff ff       	call   800250 <_panic>
  802a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a14:	8b 00                	mov    (%eax),%eax
  802a16:	85 c0                	test   %eax,%eax
  802a18:	74 10                	je     802a2a <alloc_block_BF+0x3d9>
  802a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1d:	8b 00                	mov    (%eax),%eax
  802a1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a22:	8b 52 04             	mov    0x4(%edx),%edx
  802a25:	89 50 04             	mov    %edx,0x4(%eax)
  802a28:	eb 0b                	jmp    802a35 <alloc_block_BF+0x3e4>
  802a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2d:	8b 40 04             	mov    0x4(%eax),%eax
  802a30:	a3 30 50 80 00       	mov    %eax,0x805030
  802a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a38:	8b 40 04             	mov    0x4(%eax),%eax
  802a3b:	85 c0                	test   %eax,%eax
  802a3d:	74 0f                	je     802a4e <alloc_block_BF+0x3fd>
  802a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a42:	8b 40 04             	mov    0x4(%eax),%eax
  802a45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a48:	8b 12                	mov    (%edx),%edx
  802a4a:	89 10                	mov    %edx,(%eax)
  802a4c:	eb 0a                	jmp    802a58 <alloc_block_BF+0x407>
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	8b 00                	mov    (%eax),%eax
  802a53:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6b:	a1 38 50 80 00       	mov    0x805038,%eax
  802a70:	48                   	dec    %eax
  802a71:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a76:	83 ec 04             	sub    $0x4,%esp
  802a79:	6a 00                	push   $0x0
  802a7b:	ff 75 d0             	pushl  -0x30(%ebp)
  802a7e:	ff 75 cc             	pushl  -0x34(%ebp)
  802a81:	e8 e0 f6 ff ff       	call   802166 <set_block_data>
  802a86:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8c:	e9 a3 01 00 00       	jmp    802c34 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a91:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a95:	0f 85 9d 00 00 00    	jne    802b38 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a9b:	83 ec 04             	sub    $0x4,%esp
  802a9e:	6a 01                	push   $0x1
  802aa0:	ff 75 ec             	pushl  -0x14(%ebp)
  802aa3:	ff 75 f0             	pushl  -0x10(%ebp)
  802aa6:	e8 bb f6 ff ff       	call   802166 <set_block_data>
  802aab:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802aae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ab2:	75 17                	jne    802acb <alloc_block_BF+0x47a>
  802ab4:	83 ec 04             	sub    $0x4,%esp
  802ab7:	68 f3 42 80 00       	push   $0x8042f3
  802abc:	68 58 01 00 00       	push   $0x158
  802ac1:	68 11 43 80 00       	push   $0x804311
  802ac6:	e8 85 d7 ff ff       	call   800250 <_panic>
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	85 c0                	test   %eax,%eax
  802ad2:	74 10                	je     802ae4 <alloc_block_BF+0x493>
  802ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802adc:	8b 52 04             	mov    0x4(%edx),%edx
  802adf:	89 50 04             	mov    %edx,0x4(%eax)
  802ae2:	eb 0b                	jmp    802aef <alloc_block_BF+0x49e>
  802ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae7:	8b 40 04             	mov    0x4(%eax),%eax
  802aea:	a3 30 50 80 00       	mov    %eax,0x805030
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	8b 40 04             	mov    0x4(%eax),%eax
  802af5:	85 c0                	test   %eax,%eax
  802af7:	74 0f                	je     802b08 <alloc_block_BF+0x4b7>
  802af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b02:	8b 12                	mov    (%edx),%edx
  802b04:	89 10                	mov    %edx,(%eax)
  802b06:	eb 0a                	jmp    802b12 <alloc_block_BF+0x4c1>
  802b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b25:	a1 38 50 80 00       	mov    0x805038,%eax
  802b2a:	48                   	dec    %eax
  802b2b:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b33:	e9 fc 00 00 00       	jmp    802c34 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	83 c0 08             	add    $0x8,%eax
  802b3e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b41:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b48:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b4e:	01 d0                	add    %edx,%eax
  802b50:	48                   	dec    %eax
  802b51:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b54:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b57:	ba 00 00 00 00       	mov    $0x0,%edx
  802b5c:	f7 75 c4             	divl   -0x3c(%ebp)
  802b5f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b62:	29 d0                	sub    %edx,%eax
  802b64:	c1 e8 0c             	shr    $0xc,%eax
  802b67:	83 ec 0c             	sub    $0xc,%esp
  802b6a:	50                   	push   %eax
  802b6b:	e8 37 e7 ff ff       	call   8012a7 <sbrk>
  802b70:	83 c4 10             	add    $0x10,%esp
  802b73:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b76:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b7a:	75 0a                	jne    802b86 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b81:	e9 ae 00 00 00       	jmp    802c34 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b86:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b8d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b90:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b93:	01 d0                	add    %edx,%eax
  802b95:	48                   	dec    %eax
  802b96:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b99:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba1:	f7 75 b8             	divl   -0x48(%ebp)
  802ba4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ba7:	29 d0                	sub    %edx,%eax
  802ba9:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802baf:	01 d0                	add    %edx,%eax
  802bb1:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802bb6:	a1 40 50 80 00       	mov    0x805040,%eax
  802bbb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802bc1:	83 ec 0c             	sub    $0xc,%esp
  802bc4:	68 b8 43 80 00       	push   $0x8043b8
  802bc9:	e8 3f d9 ff ff       	call   80050d <cprintf>
  802bce:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802bd1:	83 ec 08             	sub    $0x8,%esp
  802bd4:	ff 75 bc             	pushl  -0x44(%ebp)
  802bd7:	68 bd 43 80 00       	push   $0x8043bd
  802bdc:	e8 2c d9 ff ff       	call   80050d <cprintf>
  802be1:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802be4:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802beb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bf1:	01 d0                	add    %edx,%eax
  802bf3:	48                   	dec    %eax
  802bf4:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802bf7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  802bff:	f7 75 b0             	divl   -0x50(%ebp)
  802c02:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c05:	29 d0                	sub    %edx,%eax
  802c07:	83 ec 04             	sub    $0x4,%esp
  802c0a:	6a 01                	push   $0x1
  802c0c:	50                   	push   %eax
  802c0d:	ff 75 bc             	pushl  -0x44(%ebp)
  802c10:	e8 51 f5 ff ff       	call   802166 <set_block_data>
  802c15:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c18:	83 ec 0c             	sub    $0xc,%esp
  802c1b:	ff 75 bc             	pushl  -0x44(%ebp)
  802c1e:	e8 36 04 00 00       	call   803059 <free_block>
  802c23:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c26:	83 ec 0c             	sub    $0xc,%esp
  802c29:	ff 75 08             	pushl  0x8(%ebp)
  802c2c:	e8 20 fa ff ff       	call   802651 <alloc_block_BF>
  802c31:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c34:	c9                   	leave  
  802c35:	c3                   	ret    

00802c36 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c36:	55                   	push   %ebp
  802c37:	89 e5                	mov    %esp,%ebp
  802c39:	53                   	push   %ebx
  802c3a:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4f:	74 1e                	je     802c6f <merging+0x39>
  802c51:	ff 75 08             	pushl  0x8(%ebp)
  802c54:	e8 bc f1 ff ff       	call   801e15 <get_block_size>
  802c59:	83 c4 04             	add    $0x4,%esp
  802c5c:	89 c2                	mov    %eax,%edx
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	01 d0                	add    %edx,%eax
  802c63:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c66:	75 07                	jne    802c6f <merging+0x39>
		prev_is_free = 1;
  802c68:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c73:	74 1e                	je     802c93 <merging+0x5d>
  802c75:	ff 75 10             	pushl  0x10(%ebp)
  802c78:	e8 98 f1 ff ff       	call   801e15 <get_block_size>
  802c7d:	83 c4 04             	add    $0x4,%esp
  802c80:	89 c2                	mov    %eax,%edx
  802c82:	8b 45 10             	mov    0x10(%ebp),%eax
  802c85:	01 d0                	add    %edx,%eax
  802c87:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c8a:	75 07                	jne    802c93 <merging+0x5d>
		next_is_free = 1;
  802c8c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c97:	0f 84 cc 00 00 00    	je     802d69 <merging+0x133>
  802c9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca1:	0f 84 c2 00 00 00    	je     802d69 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ca7:	ff 75 08             	pushl  0x8(%ebp)
  802caa:	e8 66 f1 ff ff       	call   801e15 <get_block_size>
  802caf:	83 c4 04             	add    $0x4,%esp
  802cb2:	89 c3                	mov    %eax,%ebx
  802cb4:	ff 75 10             	pushl  0x10(%ebp)
  802cb7:	e8 59 f1 ff ff       	call   801e15 <get_block_size>
  802cbc:	83 c4 04             	add    $0x4,%esp
  802cbf:	01 c3                	add    %eax,%ebx
  802cc1:	ff 75 0c             	pushl  0xc(%ebp)
  802cc4:	e8 4c f1 ff ff       	call   801e15 <get_block_size>
  802cc9:	83 c4 04             	add    $0x4,%esp
  802ccc:	01 d8                	add    %ebx,%eax
  802cce:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cd1:	6a 00                	push   $0x0
  802cd3:	ff 75 ec             	pushl  -0x14(%ebp)
  802cd6:	ff 75 08             	pushl  0x8(%ebp)
  802cd9:	e8 88 f4 ff ff       	call   802166 <set_block_data>
  802cde:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ce1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ce5:	75 17                	jne    802cfe <merging+0xc8>
  802ce7:	83 ec 04             	sub    $0x4,%esp
  802cea:	68 f3 42 80 00       	push   $0x8042f3
  802cef:	68 7d 01 00 00       	push   $0x17d
  802cf4:	68 11 43 80 00       	push   $0x804311
  802cf9:	e8 52 d5 ff ff       	call   800250 <_panic>
  802cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	85 c0                	test   %eax,%eax
  802d05:	74 10                	je     802d17 <merging+0xe1>
  802d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d0f:	8b 52 04             	mov    0x4(%edx),%edx
  802d12:	89 50 04             	mov    %edx,0x4(%eax)
  802d15:	eb 0b                	jmp    802d22 <merging+0xec>
  802d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1a:	8b 40 04             	mov    0x4(%eax),%eax
  802d1d:	a3 30 50 80 00       	mov    %eax,0x805030
  802d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 0f                	je     802d3b <merging+0x105>
  802d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2f:	8b 40 04             	mov    0x4(%eax),%eax
  802d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d35:	8b 12                	mov    (%edx),%edx
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	eb 0a                	jmp    802d45 <merging+0x10f>
  802d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d58:	a1 38 50 80 00       	mov    0x805038,%eax
  802d5d:	48                   	dec    %eax
  802d5e:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d63:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d64:	e9 ea 02 00 00       	jmp    803053 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6d:	74 3b                	je     802daa <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d6f:	83 ec 0c             	sub    $0xc,%esp
  802d72:	ff 75 08             	pushl  0x8(%ebp)
  802d75:	e8 9b f0 ff ff       	call   801e15 <get_block_size>
  802d7a:	83 c4 10             	add    $0x10,%esp
  802d7d:	89 c3                	mov    %eax,%ebx
  802d7f:	83 ec 0c             	sub    $0xc,%esp
  802d82:	ff 75 10             	pushl  0x10(%ebp)
  802d85:	e8 8b f0 ff ff       	call   801e15 <get_block_size>
  802d8a:	83 c4 10             	add    $0x10,%esp
  802d8d:	01 d8                	add    %ebx,%eax
  802d8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d92:	83 ec 04             	sub    $0x4,%esp
  802d95:	6a 00                	push   $0x0
  802d97:	ff 75 e8             	pushl  -0x18(%ebp)
  802d9a:	ff 75 08             	pushl  0x8(%ebp)
  802d9d:	e8 c4 f3 ff ff       	call   802166 <set_block_data>
  802da2:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802da5:	e9 a9 02 00 00       	jmp    803053 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802daa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dae:	0f 84 2d 01 00 00    	je     802ee1 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802db4:	83 ec 0c             	sub    $0xc,%esp
  802db7:	ff 75 10             	pushl  0x10(%ebp)
  802dba:	e8 56 f0 ff ff       	call   801e15 <get_block_size>
  802dbf:	83 c4 10             	add    $0x10,%esp
  802dc2:	89 c3                	mov    %eax,%ebx
  802dc4:	83 ec 0c             	sub    $0xc,%esp
  802dc7:	ff 75 0c             	pushl  0xc(%ebp)
  802dca:	e8 46 f0 ff ff       	call   801e15 <get_block_size>
  802dcf:	83 c4 10             	add    $0x10,%esp
  802dd2:	01 d8                	add    %ebx,%eax
  802dd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802dd7:	83 ec 04             	sub    $0x4,%esp
  802dda:	6a 00                	push   $0x0
  802ddc:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ddf:	ff 75 10             	pushl  0x10(%ebp)
  802de2:	e8 7f f3 ff ff       	call   802166 <set_block_data>
  802de7:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802dea:	8b 45 10             	mov    0x10(%ebp),%eax
  802ded:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802df0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802df4:	74 06                	je     802dfc <merging+0x1c6>
  802df6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dfa:	75 17                	jne    802e13 <merging+0x1dd>
  802dfc:	83 ec 04             	sub    $0x4,%esp
  802dff:	68 cc 43 80 00       	push   $0x8043cc
  802e04:	68 8d 01 00 00       	push   $0x18d
  802e09:	68 11 43 80 00       	push   $0x804311
  802e0e:	e8 3d d4 ff ff       	call   800250 <_panic>
  802e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e16:	8b 50 04             	mov    0x4(%eax),%edx
  802e19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1c:	89 50 04             	mov    %edx,0x4(%eax)
  802e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e22:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e25:	89 10                	mov    %edx,(%eax)
  802e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2a:	8b 40 04             	mov    0x4(%eax),%eax
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	74 0d                	je     802e3e <merging+0x208>
  802e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e34:	8b 40 04             	mov    0x4(%eax),%eax
  802e37:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e3a:	89 10                	mov    %edx,(%eax)
  802e3c:	eb 08                	jmp    802e46 <merging+0x210>
  802e3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e41:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e4c:	89 50 04             	mov    %edx,0x4(%eax)
  802e4f:	a1 38 50 80 00       	mov    0x805038,%eax
  802e54:	40                   	inc    %eax
  802e55:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e5e:	75 17                	jne    802e77 <merging+0x241>
  802e60:	83 ec 04             	sub    $0x4,%esp
  802e63:	68 f3 42 80 00       	push   $0x8042f3
  802e68:	68 8e 01 00 00       	push   $0x18e
  802e6d:	68 11 43 80 00       	push   $0x804311
  802e72:	e8 d9 d3 ff ff       	call   800250 <_panic>
  802e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	74 10                	je     802e90 <merging+0x25a>
  802e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e88:	8b 52 04             	mov    0x4(%edx),%edx
  802e8b:	89 50 04             	mov    %edx,0x4(%eax)
  802e8e:	eb 0b                	jmp    802e9b <merging+0x265>
  802e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	a3 30 50 80 00       	mov    %eax,0x805030
  802e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	74 0f                	je     802eb4 <merging+0x27e>
  802ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea8:	8b 40 04             	mov    0x4(%eax),%eax
  802eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eae:	8b 12                	mov    (%edx),%edx
  802eb0:	89 10                	mov    %edx,(%eax)
  802eb2:	eb 0a                	jmp    802ebe <merging+0x288>
  802eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb7:	8b 00                	mov    (%eax),%eax
  802eb9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ed6:	48                   	dec    %eax
  802ed7:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802edc:	e9 72 01 00 00       	jmp    803053 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  802ee4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ee7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eeb:	74 79                	je     802f66 <merging+0x330>
  802eed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ef1:	74 73                	je     802f66 <merging+0x330>
  802ef3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef7:	74 06                	je     802eff <merging+0x2c9>
  802ef9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802efd:	75 17                	jne    802f16 <merging+0x2e0>
  802eff:	83 ec 04             	sub    $0x4,%esp
  802f02:	68 84 43 80 00       	push   $0x804384
  802f07:	68 94 01 00 00       	push   $0x194
  802f0c:	68 11 43 80 00       	push   $0x804311
  802f11:	e8 3a d3 ff ff       	call   800250 <_panic>
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	8b 10                	mov    (%eax),%edx
  802f1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1e:	89 10                	mov    %edx,(%eax)
  802f20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f23:	8b 00                	mov    (%eax),%eax
  802f25:	85 c0                	test   %eax,%eax
  802f27:	74 0b                	je     802f34 <merging+0x2fe>
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	8b 00                	mov    (%eax),%eax
  802f2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f31:	89 50 04             	mov    %edx,0x4(%eax)
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f3a:	89 10                	mov    %edx,(%eax)
  802f3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f42:	89 50 04             	mov    %edx,0x4(%eax)
  802f45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	75 08                	jne    802f56 <merging+0x320>
  802f4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f51:	a3 30 50 80 00       	mov    %eax,0x805030
  802f56:	a1 38 50 80 00       	mov    0x805038,%eax
  802f5b:	40                   	inc    %eax
  802f5c:	a3 38 50 80 00       	mov    %eax,0x805038
  802f61:	e9 ce 00 00 00       	jmp    803034 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6a:	74 65                	je     802fd1 <merging+0x39b>
  802f6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f70:	75 17                	jne    802f89 <merging+0x353>
  802f72:	83 ec 04             	sub    $0x4,%esp
  802f75:	68 60 43 80 00       	push   $0x804360
  802f7a:	68 95 01 00 00       	push   $0x195
  802f7f:	68 11 43 80 00       	push   $0x804311
  802f84:	e8 c7 d2 ff ff       	call   800250 <_panic>
  802f89:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f92:	89 50 04             	mov    %edx,0x4(%eax)
  802f95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f98:	8b 40 04             	mov    0x4(%eax),%eax
  802f9b:	85 c0                	test   %eax,%eax
  802f9d:	74 0c                	je     802fab <merging+0x375>
  802f9f:	a1 30 50 80 00       	mov    0x805030,%eax
  802fa4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fa7:	89 10                	mov    %edx,(%eax)
  802fa9:	eb 08                	jmp    802fb3 <merging+0x37d>
  802fab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb6:	a3 30 50 80 00       	mov    %eax,0x805030
  802fbb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc4:	a1 38 50 80 00       	mov    0x805038,%eax
  802fc9:	40                   	inc    %eax
  802fca:	a3 38 50 80 00       	mov    %eax,0x805038
  802fcf:	eb 63                	jmp    803034 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fd1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fd5:	75 17                	jne    802fee <merging+0x3b8>
  802fd7:	83 ec 04             	sub    $0x4,%esp
  802fda:	68 2c 43 80 00       	push   $0x80432c
  802fdf:	68 98 01 00 00       	push   $0x198
  802fe4:	68 11 43 80 00       	push   $0x804311
  802fe9:	e8 62 d2 ff ff       	call   800250 <_panic>
  802fee:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ff4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff7:	89 10                	mov    %edx,(%eax)
  802ff9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	85 c0                	test   %eax,%eax
  803000:	74 0d                	je     80300f <merging+0x3d9>
  803002:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803007:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80300a:	89 50 04             	mov    %edx,0x4(%eax)
  80300d:	eb 08                	jmp    803017 <merging+0x3e1>
  80300f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803012:	a3 30 50 80 00       	mov    %eax,0x805030
  803017:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80301f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803022:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803029:	a1 38 50 80 00       	mov    0x805038,%eax
  80302e:	40                   	inc    %eax
  80302f:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803034:	83 ec 0c             	sub    $0xc,%esp
  803037:	ff 75 10             	pushl  0x10(%ebp)
  80303a:	e8 d6 ed ff ff       	call   801e15 <get_block_size>
  80303f:	83 c4 10             	add    $0x10,%esp
  803042:	83 ec 04             	sub    $0x4,%esp
  803045:	6a 00                	push   $0x0
  803047:	50                   	push   %eax
  803048:	ff 75 10             	pushl  0x10(%ebp)
  80304b:	e8 16 f1 ff ff       	call   802166 <set_block_data>
  803050:	83 c4 10             	add    $0x10,%esp
	}
}
  803053:	90                   	nop
  803054:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803057:	c9                   	leave  
  803058:	c3                   	ret    

00803059 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803059:	55                   	push   %ebp
  80305a:	89 e5                	mov    %esp,%ebp
  80305c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80305f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803064:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803067:	a1 30 50 80 00       	mov    0x805030,%eax
  80306c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80306f:	73 1b                	jae    80308c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803071:	a1 30 50 80 00       	mov    0x805030,%eax
  803076:	83 ec 04             	sub    $0x4,%esp
  803079:	ff 75 08             	pushl  0x8(%ebp)
  80307c:	6a 00                	push   $0x0
  80307e:	50                   	push   %eax
  80307f:	e8 b2 fb ff ff       	call   802c36 <merging>
  803084:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803087:	e9 8b 00 00 00       	jmp    803117 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80308c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803091:	3b 45 08             	cmp    0x8(%ebp),%eax
  803094:	76 18                	jbe    8030ae <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803096:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80309b:	83 ec 04             	sub    $0x4,%esp
  80309e:	ff 75 08             	pushl  0x8(%ebp)
  8030a1:	50                   	push   %eax
  8030a2:	6a 00                	push   $0x0
  8030a4:	e8 8d fb ff ff       	call   802c36 <merging>
  8030a9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030ac:	eb 69                	jmp    803117 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b6:	eb 39                	jmp    8030f1 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030be:	73 29                	jae    8030e9 <free_block+0x90>
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c8:	76 1f                	jbe    8030e9 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030d2:	83 ec 04             	sub    $0x4,%esp
  8030d5:	ff 75 08             	pushl  0x8(%ebp)
  8030d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8030db:	ff 75 f4             	pushl  -0xc(%ebp)
  8030de:	e8 53 fb ff ff       	call   802c36 <merging>
  8030e3:	83 c4 10             	add    $0x10,%esp
			break;
  8030e6:	90                   	nop
		}
	}
}
  8030e7:	eb 2e                	jmp    803117 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030e9:	a1 34 50 80 00       	mov    0x805034,%eax
  8030ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f5:	74 07                	je     8030fe <free_block+0xa5>
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	eb 05                	jmp    803103 <free_block+0xaa>
  8030fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803103:	a3 34 50 80 00       	mov    %eax,0x805034
  803108:	a1 34 50 80 00       	mov    0x805034,%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	75 a7                	jne    8030b8 <free_block+0x5f>
  803111:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803115:	75 a1                	jne    8030b8 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803117:	90                   	nop
  803118:	c9                   	leave  
  803119:	c3                   	ret    

0080311a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80311a:	55                   	push   %ebp
  80311b:	89 e5                	mov    %esp,%ebp
  80311d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803120:	ff 75 08             	pushl  0x8(%ebp)
  803123:	e8 ed ec ff ff       	call   801e15 <get_block_size>
  803128:	83 c4 04             	add    $0x4,%esp
  80312b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80312e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803135:	eb 17                	jmp    80314e <copy_data+0x34>
  803137:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80313a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313d:	01 c2                	add    %eax,%edx
  80313f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803142:	8b 45 08             	mov    0x8(%ebp),%eax
  803145:	01 c8                	add    %ecx,%eax
  803147:	8a 00                	mov    (%eax),%al
  803149:	88 02                	mov    %al,(%edx)
  80314b:	ff 45 fc             	incl   -0x4(%ebp)
  80314e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803151:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803154:	72 e1                	jb     803137 <copy_data+0x1d>
}
  803156:	90                   	nop
  803157:	c9                   	leave  
  803158:	c3                   	ret    

00803159 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803159:	55                   	push   %ebp
  80315a:	89 e5                	mov    %esp,%ebp
  80315c:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80315f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803163:	75 23                	jne    803188 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803165:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803169:	74 13                	je     80317e <realloc_block_FF+0x25>
  80316b:	83 ec 0c             	sub    $0xc,%esp
  80316e:	ff 75 0c             	pushl  0xc(%ebp)
  803171:	e8 1f f0 ff ff       	call   802195 <alloc_block_FF>
  803176:	83 c4 10             	add    $0x10,%esp
  803179:	e9 f4 06 00 00       	jmp    803872 <realloc_block_FF+0x719>
		return NULL;
  80317e:	b8 00 00 00 00       	mov    $0x0,%eax
  803183:	e9 ea 06 00 00       	jmp    803872 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803188:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80318c:	75 18                	jne    8031a6 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80318e:	83 ec 0c             	sub    $0xc,%esp
  803191:	ff 75 08             	pushl  0x8(%ebp)
  803194:	e8 c0 fe ff ff       	call   803059 <free_block>
  803199:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80319c:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a1:	e9 cc 06 00 00       	jmp    803872 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8031a6:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031aa:	77 07                	ja     8031b3 <realloc_block_FF+0x5a>
  8031ac:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b6:	83 e0 01             	and    $0x1,%eax
  8031b9:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031bf:	83 c0 08             	add    $0x8,%eax
  8031c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031c5:	83 ec 0c             	sub    $0xc,%esp
  8031c8:	ff 75 08             	pushl  0x8(%ebp)
  8031cb:	e8 45 ec ff ff       	call   801e15 <get_block_size>
  8031d0:	83 c4 10             	add    $0x10,%esp
  8031d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d9:	83 e8 08             	sub    $0x8,%eax
  8031dc:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	83 e8 04             	sub    $0x4,%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	83 e0 fe             	and    $0xfffffffe,%eax
  8031ea:	89 c2                	mov    %eax,%edx
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	01 d0                	add    %edx,%eax
  8031f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031f4:	83 ec 0c             	sub    $0xc,%esp
  8031f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031fa:	e8 16 ec ff ff       	call   801e15 <get_block_size>
  8031ff:	83 c4 10             	add    $0x10,%esp
  803202:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803205:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803208:	83 e8 08             	sub    $0x8,%eax
  80320b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80320e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803211:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803214:	75 08                	jne    80321e <realloc_block_FF+0xc5>
	{
		 return va;
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	e9 54 06 00 00       	jmp    803872 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80321e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803221:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803224:	0f 83 e5 03 00 00    	jae    80360f <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803230:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803233:	83 ec 0c             	sub    $0xc,%esp
  803236:	ff 75 e4             	pushl  -0x1c(%ebp)
  803239:	e8 f0 eb ff ff       	call   801e2e <is_free_block>
  80323e:	83 c4 10             	add    $0x10,%esp
  803241:	84 c0                	test   %al,%al
  803243:	0f 84 3b 01 00 00    	je     803384 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803249:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80324c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80324f:	01 d0                	add    %edx,%eax
  803251:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803254:	83 ec 04             	sub    $0x4,%esp
  803257:	6a 01                	push   $0x1
  803259:	ff 75 f0             	pushl  -0x10(%ebp)
  80325c:	ff 75 08             	pushl  0x8(%ebp)
  80325f:	e8 02 ef ff ff       	call   802166 <set_block_data>
  803264:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	83 e8 04             	sub    $0x4,%eax
  80326d:	8b 00                	mov    (%eax),%eax
  80326f:	83 e0 fe             	and    $0xfffffffe,%eax
  803272:	89 c2                	mov    %eax,%edx
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	01 d0                	add    %edx,%eax
  803279:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80327c:	83 ec 04             	sub    $0x4,%esp
  80327f:	6a 00                	push   $0x0
  803281:	ff 75 cc             	pushl  -0x34(%ebp)
  803284:	ff 75 c8             	pushl  -0x38(%ebp)
  803287:	e8 da ee ff ff       	call   802166 <set_block_data>
  80328c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80328f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803293:	74 06                	je     80329b <realloc_block_FF+0x142>
  803295:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803299:	75 17                	jne    8032b2 <realloc_block_FF+0x159>
  80329b:	83 ec 04             	sub    $0x4,%esp
  80329e:	68 84 43 80 00       	push   $0x804384
  8032a3:	68 f6 01 00 00       	push   $0x1f6
  8032a8:	68 11 43 80 00       	push   $0x804311
  8032ad:	e8 9e cf ff ff       	call   800250 <_panic>
  8032b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b5:	8b 10                	mov    (%eax),%edx
  8032b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ba:	89 10                	mov    %edx,(%eax)
  8032bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032bf:	8b 00                	mov    (%eax),%eax
  8032c1:	85 c0                	test   %eax,%eax
  8032c3:	74 0b                	je     8032d0 <realloc_block_FF+0x177>
  8032c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c8:	8b 00                	mov    (%eax),%eax
  8032ca:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032cd:	89 50 04             	mov    %edx,0x4(%eax)
  8032d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032d6:	89 10                	mov    %edx,(%eax)
  8032d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032de:	89 50 04             	mov    %edx,0x4(%eax)
  8032e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032e4:	8b 00                	mov    (%eax),%eax
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	75 08                	jne    8032f2 <realloc_block_FF+0x199>
  8032ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ed:	a3 30 50 80 00       	mov    %eax,0x805030
  8032f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8032f7:	40                   	inc    %eax
  8032f8:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803301:	75 17                	jne    80331a <realloc_block_FF+0x1c1>
  803303:	83 ec 04             	sub    $0x4,%esp
  803306:	68 f3 42 80 00       	push   $0x8042f3
  80330b:	68 f7 01 00 00       	push   $0x1f7
  803310:	68 11 43 80 00       	push   $0x804311
  803315:	e8 36 cf ff ff       	call   800250 <_panic>
  80331a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	74 10                	je     803333 <realloc_block_FF+0x1da>
  803323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803326:	8b 00                	mov    (%eax),%eax
  803328:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80332b:	8b 52 04             	mov    0x4(%edx),%edx
  80332e:	89 50 04             	mov    %edx,0x4(%eax)
  803331:	eb 0b                	jmp    80333e <realloc_block_FF+0x1e5>
  803333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803336:	8b 40 04             	mov    0x4(%eax),%eax
  803339:	a3 30 50 80 00       	mov    %eax,0x805030
  80333e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 0f                	je     803357 <realloc_block_FF+0x1fe>
  803348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334b:	8b 40 04             	mov    0x4(%eax),%eax
  80334e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803351:	8b 12                	mov    (%edx),%edx
  803353:	89 10                	mov    %edx,(%eax)
  803355:	eb 0a                	jmp    803361 <realloc_block_FF+0x208>
  803357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803361:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803374:	a1 38 50 80 00       	mov    0x805038,%eax
  803379:	48                   	dec    %eax
  80337a:	a3 38 50 80 00       	mov    %eax,0x805038
  80337f:	e9 83 02 00 00       	jmp    803607 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803384:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803388:	0f 86 69 02 00 00    	jbe    8035f7 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80338e:	83 ec 04             	sub    $0x4,%esp
  803391:	6a 01                	push   $0x1
  803393:	ff 75 f0             	pushl  -0x10(%ebp)
  803396:	ff 75 08             	pushl  0x8(%ebp)
  803399:	e8 c8 ed ff ff       	call   802166 <set_block_data>
  80339e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a4:	83 e8 04             	sub    $0x4,%eax
  8033a7:	8b 00                	mov    (%eax),%eax
  8033a9:	83 e0 fe             	and    $0xfffffffe,%eax
  8033ac:	89 c2                	mov    %eax,%edx
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	01 d0                	add    %edx,%eax
  8033b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8033bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033be:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033c2:	75 68                	jne    80342c <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033c8:	75 17                	jne    8033e1 <realloc_block_FF+0x288>
  8033ca:	83 ec 04             	sub    $0x4,%esp
  8033cd:	68 2c 43 80 00       	push   $0x80432c
  8033d2:	68 06 02 00 00       	push   $0x206
  8033d7:	68 11 43 80 00       	push   $0x804311
  8033dc:	e8 6f ce ff ff       	call   800250 <_panic>
  8033e1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ea:	89 10                	mov    %edx,(%eax)
  8033ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ef:	8b 00                	mov    (%eax),%eax
  8033f1:	85 c0                	test   %eax,%eax
  8033f3:	74 0d                	je     803402 <realloc_block_FF+0x2a9>
  8033f5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033fd:	89 50 04             	mov    %edx,0x4(%eax)
  803400:	eb 08                	jmp    80340a <realloc_block_FF+0x2b1>
  803402:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803405:	a3 30 50 80 00       	mov    %eax,0x805030
  80340a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803412:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803415:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341c:	a1 38 50 80 00       	mov    0x805038,%eax
  803421:	40                   	inc    %eax
  803422:	a3 38 50 80 00       	mov    %eax,0x805038
  803427:	e9 b0 01 00 00       	jmp    8035dc <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80342c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803431:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803434:	76 68                	jbe    80349e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803436:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80343a:	75 17                	jne    803453 <realloc_block_FF+0x2fa>
  80343c:	83 ec 04             	sub    $0x4,%esp
  80343f:	68 2c 43 80 00       	push   $0x80432c
  803444:	68 0b 02 00 00       	push   $0x20b
  803449:	68 11 43 80 00       	push   $0x804311
  80344e:	e8 fd cd ff ff       	call   800250 <_panic>
  803453:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803459:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345c:	89 10                	mov    %edx,(%eax)
  80345e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803461:	8b 00                	mov    (%eax),%eax
  803463:	85 c0                	test   %eax,%eax
  803465:	74 0d                	je     803474 <realloc_block_FF+0x31b>
  803467:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80346c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80346f:	89 50 04             	mov    %edx,0x4(%eax)
  803472:	eb 08                	jmp    80347c <realloc_block_FF+0x323>
  803474:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803477:	a3 30 50 80 00       	mov    %eax,0x805030
  80347c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803484:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803487:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80348e:	a1 38 50 80 00       	mov    0x805038,%eax
  803493:	40                   	inc    %eax
  803494:	a3 38 50 80 00       	mov    %eax,0x805038
  803499:	e9 3e 01 00 00       	jmp    8035dc <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80349e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034a3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034a6:	73 68                	jae    803510 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034ac:	75 17                	jne    8034c5 <realloc_block_FF+0x36c>
  8034ae:	83 ec 04             	sub    $0x4,%esp
  8034b1:	68 60 43 80 00       	push   $0x804360
  8034b6:	68 10 02 00 00       	push   $0x210
  8034bb:	68 11 43 80 00       	push   $0x804311
  8034c0:	e8 8b cd ff ff       	call   800250 <_panic>
  8034c5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ce:	89 50 04             	mov    %edx,0x4(%eax)
  8034d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d4:	8b 40 04             	mov    0x4(%eax),%eax
  8034d7:	85 c0                	test   %eax,%eax
  8034d9:	74 0c                	je     8034e7 <realloc_block_FF+0x38e>
  8034db:	a1 30 50 80 00       	mov    0x805030,%eax
  8034e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034e3:	89 10                	mov    %edx,(%eax)
  8034e5:	eb 08                	jmp    8034ef <realloc_block_FF+0x396>
  8034e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803500:	a1 38 50 80 00       	mov    0x805038,%eax
  803505:	40                   	inc    %eax
  803506:	a3 38 50 80 00       	mov    %eax,0x805038
  80350b:	e9 cc 00 00 00       	jmp    8035dc <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803510:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803517:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80351c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80351f:	e9 8a 00 00 00       	jmp    8035ae <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803527:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80352a:	73 7a                	jae    8035a6 <realloc_block_FF+0x44d>
  80352c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352f:	8b 00                	mov    (%eax),%eax
  803531:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803534:	73 70                	jae    8035a6 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80353a:	74 06                	je     803542 <realloc_block_FF+0x3e9>
  80353c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803540:	75 17                	jne    803559 <realloc_block_FF+0x400>
  803542:	83 ec 04             	sub    $0x4,%esp
  803545:	68 84 43 80 00       	push   $0x804384
  80354a:	68 1a 02 00 00       	push   $0x21a
  80354f:	68 11 43 80 00       	push   $0x804311
  803554:	e8 f7 cc ff ff       	call   800250 <_panic>
  803559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355c:	8b 10                	mov    (%eax),%edx
  80355e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803561:	89 10                	mov    %edx,(%eax)
  803563:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803566:	8b 00                	mov    (%eax),%eax
  803568:	85 c0                	test   %eax,%eax
  80356a:	74 0b                	je     803577 <realloc_block_FF+0x41e>
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 00                	mov    (%eax),%eax
  803571:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803574:	89 50 04             	mov    %edx,0x4(%eax)
  803577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80357d:	89 10                	mov    %edx,(%eax)
  80357f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803582:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803585:	89 50 04             	mov    %edx,0x4(%eax)
  803588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358b:	8b 00                	mov    (%eax),%eax
  80358d:	85 c0                	test   %eax,%eax
  80358f:	75 08                	jne    803599 <realloc_block_FF+0x440>
  803591:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803594:	a3 30 50 80 00       	mov    %eax,0x805030
  803599:	a1 38 50 80 00       	mov    0x805038,%eax
  80359e:	40                   	inc    %eax
  80359f:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035a4:	eb 36                	jmp    8035dc <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035a6:	a1 34 50 80 00       	mov    0x805034,%eax
  8035ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b2:	74 07                	je     8035bb <realloc_block_FF+0x462>
  8035b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b7:	8b 00                	mov    (%eax),%eax
  8035b9:	eb 05                	jmp    8035c0 <realloc_block_FF+0x467>
  8035bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c0:	a3 34 50 80 00       	mov    %eax,0x805034
  8035c5:	a1 34 50 80 00       	mov    0x805034,%eax
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	0f 85 52 ff ff ff    	jne    803524 <realloc_block_FF+0x3cb>
  8035d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d6:	0f 85 48 ff ff ff    	jne    803524 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035dc:	83 ec 04             	sub    $0x4,%esp
  8035df:	6a 00                	push   $0x0
  8035e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8035e4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035e7:	e8 7a eb ff ff       	call   802166 <set_block_data>
  8035ec:	83 c4 10             	add    $0x10,%esp
				return va;
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	e9 7b 02 00 00       	jmp    803872 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035f7:	83 ec 0c             	sub    $0xc,%esp
  8035fa:	68 01 44 80 00       	push   $0x804401
  8035ff:	e8 09 cf ff ff       	call   80050d <cprintf>
  803604:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	e9 63 02 00 00       	jmp    803872 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80360f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803612:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803615:	0f 86 4d 02 00 00    	jbe    803868 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80361b:	83 ec 0c             	sub    $0xc,%esp
  80361e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803621:	e8 08 e8 ff ff       	call   801e2e <is_free_block>
  803626:	83 c4 10             	add    $0x10,%esp
  803629:	84 c0                	test   %al,%al
  80362b:	0f 84 37 02 00 00    	je     803868 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803631:	8b 45 0c             	mov    0xc(%ebp),%eax
  803634:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803637:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80363a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80363d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803640:	76 38                	jbe    80367a <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803642:	83 ec 0c             	sub    $0xc,%esp
  803645:	ff 75 08             	pushl  0x8(%ebp)
  803648:	e8 0c fa ff ff       	call   803059 <free_block>
  80364d:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803650:	83 ec 0c             	sub    $0xc,%esp
  803653:	ff 75 0c             	pushl  0xc(%ebp)
  803656:	e8 3a eb ff ff       	call   802195 <alloc_block_FF>
  80365b:	83 c4 10             	add    $0x10,%esp
  80365e:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803661:	83 ec 08             	sub    $0x8,%esp
  803664:	ff 75 c0             	pushl  -0x40(%ebp)
  803667:	ff 75 08             	pushl  0x8(%ebp)
  80366a:	e8 ab fa ff ff       	call   80311a <copy_data>
  80366f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803672:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803675:	e9 f8 01 00 00       	jmp    803872 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80367a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80367d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803680:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803683:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803687:	0f 87 a0 00 00 00    	ja     80372d <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80368d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803691:	75 17                	jne    8036aa <realloc_block_FF+0x551>
  803693:	83 ec 04             	sub    $0x4,%esp
  803696:	68 f3 42 80 00       	push   $0x8042f3
  80369b:	68 38 02 00 00       	push   $0x238
  8036a0:	68 11 43 80 00       	push   $0x804311
  8036a5:	e8 a6 cb ff ff       	call   800250 <_panic>
  8036aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	85 c0                	test   %eax,%eax
  8036b1:	74 10                	je     8036c3 <realloc_block_FF+0x56a>
  8036b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b6:	8b 00                	mov    (%eax),%eax
  8036b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036bb:	8b 52 04             	mov    0x4(%edx),%edx
  8036be:	89 50 04             	mov    %edx,0x4(%eax)
  8036c1:	eb 0b                	jmp    8036ce <realloc_block_FF+0x575>
  8036c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c6:	8b 40 04             	mov    0x4(%eax),%eax
  8036c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d1:	8b 40 04             	mov    0x4(%eax),%eax
  8036d4:	85 c0                	test   %eax,%eax
  8036d6:	74 0f                	je     8036e7 <realloc_block_FF+0x58e>
  8036d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036db:	8b 40 04             	mov    0x4(%eax),%eax
  8036de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036e1:	8b 12                	mov    (%edx),%edx
  8036e3:	89 10                	mov    %edx,(%eax)
  8036e5:	eb 0a                	jmp    8036f1 <realloc_block_FF+0x598>
  8036e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ea:	8b 00                	mov    (%eax),%eax
  8036ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803704:	a1 38 50 80 00       	mov    0x805038,%eax
  803709:	48                   	dec    %eax
  80370a:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80370f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803715:	01 d0                	add    %edx,%eax
  803717:	83 ec 04             	sub    $0x4,%esp
  80371a:	6a 01                	push   $0x1
  80371c:	50                   	push   %eax
  80371d:	ff 75 08             	pushl  0x8(%ebp)
  803720:	e8 41 ea ff ff       	call   802166 <set_block_data>
  803725:	83 c4 10             	add    $0x10,%esp
  803728:	e9 36 01 00 00       	jmp    803863 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80372d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803730:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803733:	01 d0                	add    %edx,%eax
  803735:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803738:	83 ec 04             	sub    $0x4,%esp
  80373b:	6a 01                	push   $0x1
  80373d:	ff 75 f0             	pushl  -0x10(%ebp)
  803740:	ff 75 08             	pushl  0x8(%ebp)
  803743:	e8 1e ea ff ff       	call   802166 <set_block_data>
  803748:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80374b:	8b 45 08             	mov    0x8(%ebp),%eax
  80374e:	83 e8 04             	sub    $0x4,%eax
  803751:	8b 00                	mov    (%eax),%eax
  803753:	83 e0 fe             	and    $0xfffffffe,%eax
  803756:	89 c2                	mov    %eax,%edx
  803758:	8b 45 08             	mov    0x8(%ebp),%eax
  80375b:	01 d0                	add    %edx,%eax
  80375d:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803760:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803764:	74 06                	je     80376c <realloc_block_FF+0x613>
  803766:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80376a:	75 17                	jne    803783 <realloc_block_FF+0x62a>
  80376c:	83 ec 04             	sub    $0x4,%esp
  80376f:	68 84 43 80 00       	push   $0x804384
  803774:	68 44 02 00 00       	push   $0x244
  803779:	68 11 43 80 00       	push   $0x804311
  80377e:	e8 cd ca ff ff       	call   800250 <_panic>
  803783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803786:	8b 10                	mov    (%eax),%edx
  803788:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80378b:	89 10                	mov    %edx,(%eax)
  80378d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803790:	8b 00                	mov    (%eax),%eax
  803792:	85 c0                	test   %eax,%eax
  803794:	74 0b                	je     8037a1 <realloc_block_FF+0x648>
  803796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803799:	8b 00                	mov    (%eax),%eax
  80379b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80379e:	89 50 04             	mov    %edx,0x4(%eax)
  8037a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037a7:	89 10                	mov    %edx,(%eax)
  8037a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037af:	89 50 04             	mov    %edx,0x4(%eax)
  8037b2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037b5:	8b 00                	mov    (%eax),%eax
  8037b7:	85 c0                	test   %eax,%eax
  8037b9:	75 08                	jne    8037c3 <realloc_block_FF+0x66a>
  8037bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037be:	a3 30 50 80 00       	mov    %eax,0x805030
  8037c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8037c8:	40                   	inc    %eax
  8037c9:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037d2:	75 17                	jne    8037eb <realloc_block_FF+0x692>
  8037d4:	83 ec 04             	sub    $0x4,%esp
  8037d7:	68 f3 42 80 00       	push   $0x8042f3
  8037dc:	68 45 02 00 00       	push   $0x245
  8037e1:	68 11 43 80 00       	push   $0x804311
  8037e6:	e8 65 ca ff ff       	call   800250 <_panic>
  8037eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ee:	8b 00                	mov    (%eax),%eax
  8037f0:	85 c0                	test   %eax,%eax
  8037f2:	74 10                	je     803804 <realloc_block_FF+0x6ab>
  8037f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f7:	8b 00                	mov    (%eax),%eax
  8037f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037fc:	8b 52 04             	mov    0x4(%edx),%edx
  8037ff:	89 50 04             	mov    %edx,0x4(%eax)
  803802:	eb 0b                	jmp    80380f <realloc_block_FF+0x6b6>
  803804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803807:	8b 40 04             	mov    0x4(%eax),%eax
  80380a:	a3 30 50 80 00       	mov    %eax,0x805030
  80380f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803812:	8b 40 04             	mov    0x4(%eax),%eax
  803815:	85 c0                	test   %eax,%eax
  803817:	74 0f                	je     803828 <realloc_block_FF+0x6cf>
  803819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381c:	8b 40 04             	mov    0x4(%eax),%eax
  80381f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803822:	8b 12                	mov    (%edx),%edx
  803824:	89 10                	mov    %edx,(%eax)
  803826:	eb 0a                	jmp    803832 <realloc_block_FF+0x6d9>
  803828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382b:	8b 00                	mov    (%eax),%eax
  80382d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803835:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80383b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803845:	a1 38 50 80 00       	mov    0x805038,%eax
  80384a:	48                   	dec    %eax
  80384b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803850:	83 ec 04             	sub    $0x4,%esp
  803853:	6a 00                	push   $0x0
  803855:	ff 75 bc             	pushl  -0x44(%ebp)
  803858:	ff 75 b8             	pushl  -0x48(%ebp)
  80385b:	e8 06 e9 ff ff       	call   802166 <set_block_data>
  803860:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803863:	8b 45 08             	mov    0x8(%ebp),%eax
  803866:	eb 0a                	jmp    803872 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803868:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80386f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803872:	c9                   	leave  
  803873:	c3                   	ret    

00803874 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803874:	55                   	push   %ebp
  803875:	89 e5                	mov    %esp,%ebp
  803877:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80387a:	83 ec 04             	sub    $0x4,%esp
  80387d:	68 08 44 80 00       	push   $0x804408
  803882:	68 58 02 00 00       	push   $0x258
  803887:	68 11 43 80 00       	push   $0x804311
  80388c:	e8 bf c9 ff ff       	call   800250 <_panic>

00803891 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803891:	55                   	push   %ebp
  803892:	89 e5                	mov    %esp,%ebp
  803894:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803897:	83 ec 04             	sub    $0x4,%esp
  80389a:	68 30 44 80 00       	push   $0x804430
  80389f:	68 61 02 00 00       	push   $0x261
  8038a4:	68 11 43 80 00       	push   $0x804311
  8038a9:	e8 a2 c9 ff ff       	call   800250 <_panic>
  8038ae:	66 90                	xchg   %ax,%ax

008038b0 <__udivdi3>:
  8038b0:	55                   	push   %ebp
  8038b1:	57                   	push   %edi
  8038b2:	56                   	push   %esi
  8038b3:	53                   	push   %ebx
  8038b4:	83 ec 1c             	sub    $0x1c,%esp
  8038b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038c7:	89 ca                	mov    %ecx,%edx
  8038c9:	89 f8                	mov    %edi,%eax
  8038cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038cf:	85 f6                	test   %esi,%esi
  8038d1:	75 2d                	jne    803900 <__udivdi3+0x50>
  8038d3:	39 cf                	cmp    %ecx,%edi
  8038d5:	77 65                	ja     80393c <__udivdi3+0x8c>
  8038d7:	89 fd                	mov    %edi,%ebp
  8038d9:	85 ff                	test   %edi,%edi
  8038db:	75 0b                	jne    8038e8 <__udivdi3+0x38>
  8038dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8038e2:	31 d2                	xor    %edx,%edx
  8038e4:	f7 f7                	div    %edi
  8038e6:	89 c5                	mov    %eax,%ebp
  8038e8:	31 d2                	xor    %edx,%edx
  8038ea:	89 c8                	mov    %ecx,%eax
  8038ec:	f7 f5                	div    %ebp
  8038ee:	89 c1                	mov    %eax,%ecx
  8038f0:	89 d8                	mov    %ebx,%eax
  8038f2:	f7 f5                	div    %ebp
  8038f4:	89 cf                	mov    %ecx,%edi
  8038f6:	89 fa                	mov    %edi,%edx
  8038f8:	83 c4 1c             	add    $0x1c,%esp
  8038fb:	5b                   	pop    %ebx
  8038fc:	5e                   	pop    %esi
  8038fd:	5f                   	pop    %edi
  8038fe:	5d                   	pop    %ebp
  8038ff:	c3                   	ret    
  803900:	39 ce                	cmp    %ecx,%esi
  803902:	77 28                	ja     80392c <__udivdi3+0x7c>
  803904:	0f bd fe             	bsr    %esi,%edi
  803907:	83 f7 1f             	xor    $0x1f,%edi
  80390a:	75 40                	jne    80394c <__udivdi3+0x9c>
  80390c:	39 ce                	cmp    %ecx,%esi
  80390e:	72 0a                	jb     80391a <__udivdi3+0x6a>
  803910:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803914:	0f 87 9e 00 00 00    	ja     8039b8 <__udivdi3+0x108>
  80391a:	b8 01 00 00 00       	mov    $0x1,%eax
  80391f:	89 fa                	mov    %edi,%edx
  803921:	83 c4 1c             	add    $0x1c,%esp
  803924:	5b                   	pop    %ebx
  803925:	5e                   	pop    %esi
  803926:	5f                   	pop    %edi
  803927:	5d                   	pop    %ebp
  803928:	c3                   	ret    
  803929:	8d 76 00             	lea    0x0(%esi),%esi
  80392c:	31 ff                	xor    %edi,%edi
  80392e:	31 c0                	xor    %eax,%eax
  803930:	89 fa                	mov    %edi,%edx
  803932:	83 c4 1c             	add    $0x1c,%esp
  803935:	5b                   	pop    %ebx
  803936:	5e                   	pop    %esi
  803937:	5f                   	pop    %edi
  803938:	5d                   	pop    %ebp
  803939:	c3                   	ret    
  80393a:	66 90                	xchg   %ax,%ax
  80393c:	89 d8                	mov    %ebx,%eax
  80393e:	f7 f7                	div    %edi
  803940:	31 ff                	xor    %edi,%edi
  803942:	89 fa                	mov    %edi,%edx
  803944:	83 c4 1c             	add    $0x1c,%esp
  803947:	5b                   	pop    %ebx
  803948:	5e                   	pop    %esi
  803949:	5f                   	pop    %edi
  80394a:	5d                   	pop    %ebp
  80394b:	c3                   	ret    
  80394c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803951:	89 eb                	mov    %ebp,%ebx
  803953:	29 fb                	sub    %edi,%ebx
  803955:	89 f9                	mov    %edi,%ecx
  803957:	d3 e6                	shl    %cl,%esi
  803959:	89 c5                	mov    %eax,%ebp
  80395b:	88 d9                	mov    %bl,%cl
  80395d:	d3 ed                	shr    %cl,%ebp
  80395f:	89 e9                	mov    %ebp,%ecx
  803961:	09 f1                	or     %esi,%ecx
  803963:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803967:	89 f9                	mov    %edi,%ecx
  803969:	d3 e0                	shl    %cl,%eax
  80396b:	89 c5                	mov    %eax,%ebp
  80396d:	89 d6                	mov    %edx,%esi
  80396f:	88 d9                	mov    %bl,%cl
  803971:	d3 ee                	shr    %cl,%esi
  803973:	89 f9                	mov    %edi,%ecx
  803975:	d3 e2                	shl    %cl,%edx
  803977:	8b 44 24 08          	mov    0x8(%esp),%eax
  80397b:	88 d9                	mov    %bl,%cl
  80397d:	d3 e8                	shr    %cl,%eax
  80397f:	09 c2                	or     %eax,%edx
  803981:	89 d0                	mov    %edx,%eax
  803983:	89 f2                	mov    %esi,%edx
  803985:	f7 74 24 0c          	divl   0xc(%esp)
  803989:	89 d6                	mov    %edx,%esi
  80398b:	89 c3                	mov    %eax,%ebx
  80398d:	f7 e5                	mul    %ebp
  80398f:	39 d6                	cmp    %edx,%esi
  803991:	72 19                	jb     8039ac <__udivdi3+0xfc>
  803993:	74 0b                	je     8039a0 <__udivdi3+0xf0>
  803995:	89 d8                	mov    %ebx,%eax
  803997:	31 ff                	xor    %edi,%edi
  803999:	e9 58 ff ff ff       	jmp    8038f6 <__udivdi3+0x46>
  80399e:	66 90                	xchg   %ax,%ax
  8039a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039a4:	89 f9                	mov    %edi,%ecx
  8039a6:	d3 e2                	shl    %cl,%edx
  8039a8:	39 c2                	cmp    %eax,%edx
  8039aa:	73 e9                	jae    803995 <__udivdi3+0xe5>
  8039ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039af:	31 ff                	xor    %edi,%edi
  8039b1:	e9 40 ff ff ff       	jmp    8038f6 <__udivdi3+0x46>
  8039b6:	66 90                	xchg   %ax,%ax
  8039b8:	31 c0                	xor    %eax,%eax
  8039ba:	e9 37 ff ff ff       	jmp    8038f6 <__udivdi3+0x46>
  8039bf:	90                   	nop

008039c0 <__umoddi3>:
  8039c0:	55                   	push   %ebp
  8039c1:	57                   	push   %edi
  8039c2:	56                   	push   %esi
  8039c3:	53                   	push   %ebx
  8039c4:	83 ec 1c             	sub    $0x1c,%esp
  8039c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039df:	89 f3                	mov    %esi,%ebx
  8039e1:	89 fa                	mov    %edi,%edx
  8039e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039e7:	89 34 24             	mov    %esi,(%esp)
  8039ea:	85 c0                	test   %eax,%eax
  8039ec:	75 1a                	jne    803a08 <__umoddi3+0x48>
  8039ee:	39 f7                	cmp    %esi,%edi
  8039f0:	0f 86 a2 00 00 00    	jbe    803a98 <__umoddi3+0xd8>
  8039f6:	89 c8                	mov    %ecx,%eax
  8039f8:	89 f2                	mov    %esi,%edx
  8039fa:	f7 f7                	div    %edi
  8039fc:	89 d0                	mov    %edx,%eax
  8039fe:	31 d2                	xor    %edx,%edx
  803a00:	83 c4 1c             	add    $0x1c,%esp
  803a03:	5b                   	pop    %ebx
  803a04:	5e                   	pop    %esi
  803a05:	5f                   	pop    %edi
  803a06:	5d                   	pop    %ebp
  803a07:	c3                   	ret    
  803a08:	39 f0                	cmp    %esi,%eax
  803a0a:	0f 87 ac 00 00 00    	ja     803abc <__umoddi3+0xfc>
  803a10:	0f bd e8             	bsr    %eax,%ebp
  803a13:	83 f5 1f             	xor    $0x1f,%ebp
  803a16:	0f 84 ac 00 00 00    	je     803ac8 <__umoddi3+0x108>
  803a1c:	bf 20 00 00 00       	mov    $0x20,%edi
  803a21:	29 ef                	sub    %ebp,%edi
  803a23:	89 fe                	mov    %edi,%esi
  803a25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a29:	89 e9                	mov    %ebp,%ecx
  803a2b:	d3 e0                	shl    %cl,%eax
  803a2d:	89 d7                	mov    %edx,%edi
  803a2f:	89 f1                	mov    %esi,%ecx
  803a31:	d3 ef                	shr    %cl,%edi
  803a33:	09 c7                	or     %eax,%edi
  803a35:	89 e9                	mov    %ebp,%ecx
  803a37:	d3 e2                	shl    %cl,%edx
  803a39:	89 14 24             	mov    %edx,(%esp)
  803a3c:	89 d8                	mov    %ebx,%eax
  803a3e:	d3 e0                	shl    %cl,%eax
  803a40:	89 c2                	mov    %eax,%edx
  803a42:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a46:	d3 e0                	shl    %cl,%eax
  803a48:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a50:	89 f1                	mov    %esi,%ecx
  803a52:	d3 e8                	shr    %cl,%eax
  803a54:	09 d0                	or     %edx,%eax
  803a56:	d3 eb                	shr    %cl,%ebx
  803a58:	89 da                	mov    %ebx,%edx
  803a5a:	f7 f7                	div    %edi
  803a5c:	89 d3                	mov    %edx,%ebx
  803a5e:	f7 24 24             	mull   (%esp)
  803a61:	89 c6                	mov    %eax,%esi
  803a63:	89 d1                	mov    %edx,%ecx
  803a65:	39 d3                	cmp    %edx,%ebx
  803a67:	0f 82 87 00 00 00    	jb     803af4 <__umoddi3+0x134>
  803a6d:	0f 84 91 00 00 00    	je     803b04 <__umoddi3+0x144>
  803a73:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a77:	29 f2                	sub    %esi,%edx
  803a79:	19 cb                	sbb    %ecx,%ebx
  803a7b:	89 d8                	mov    %ebx,%eax
  803a7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a81:	d3 e0                	shl    %cl,%eax
  803a83:	89 e9                	mov    %ebp,%ecx
  803a85:	d3 ea                	shr    %cl,%edx
  803a87:	09 d0                	or     %edx,%eax
  803a89:	89 e9                	mov    %ebp,%ecx
  803a8b:	d3 eb                	shr    %cl,%ebx
  803a8d:	89 da                	mov    %ebx,%edx
  803a8f:	83 c4 1c             	add    $0x1c,%esp
  803a92:	5b                   	pop    %ebx
  803a93:	5e                   	pop    %esi
  803a94:	5f                   	pop    %edi
  803a95:	5d                   	pop    %ebp
  803a96:	c3                   	ret    
  803a97:	90                   	nop
  803a98:	89 fd                	mov    %edi,%ebp
  803a9a:	85 ff                	test   %edi,%edi
  803a9c:	75 0b                	jne    803aa9 <__umoddi3+0xe9>
  803a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803aa3:	31 d2                	xor    %edx,%edx
  803aa5:	f7 f7                	div    %edi
  803aa7:	89 c5                	mov    %eax,%ebp
  803aa9:	89 f0                	mov    %esi,%eax
  803aab:	31 d2                	xor    %edx,%edx
  803aad:	f7 f5                	div    %ebp
  803aaf:	89 c8                	mov    %ecx,%eax
  803ab1:	f7 f5                	div    %ebp
  803ab3:	89 d0                	mov    %edx,%eax
  803ab5:	e9 44 ff ff ff       	jmp    8039fe <__umoddi3+0x3e>
  803aba:	66 90                	xchg   %ax,%ax
  803abc:	89 c8                	mov    %ecx,%eax
  803abe:	89 f2                	mov    %esi,%edx
  803ac0:	83 c4 1c             	add    $0x1c,%esp
  803ac3:	5b                   	pop    %ebx
  803ac4:	5e                   	pop    %esi
  803ac5:	5f                   	pop    %edi
  803ac6:	5d                   	pop    %ebp
  803ac7:	c3                   	ret    
  803ac8:	3b 04 24             	cmp    (%esp),%eax
  803acb:	72 06                	jb     803ad3 <__umoddi3+0x113>
  803acd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ad1:	77 0f                	ja     803ae2 <__umoddi3+0x122>
  803ad3:	89 f2                	mov    %esi,%edx
  803ad5:	29 f9                	sub    %edi,%ecx
  803ad7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803adb:	89 14 24             	mov    %edx,(%esp)
  803ade:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ae2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ae6:	8b 14 24             	mov    (%esp),%edx
  803ae9:	83 c4 1c             	add    $0x1c,%esp
  803aec:	5b                   	pop    %ebx
  803aed:	5e                   	pop    %esi
  803aee:	5f                   	pop    %edi
  803aef:	5d                   	pop    %ebp
  803af0:	c3                   	ret    
  803af1:	8d 76 00             	lea    0x0(%esi),%esi
  803af4:	2b 04 24             	sub    (%esp),%eax
  803af7:	19 fa                	sbb    %edi,%edx
  803af9:	89 d1                	mov    %edx,%ecx
  803afb:	89 c6                	mov    %eax,%esi
  803afd:	e9 71 ff ff ff       	jmp    803a73 <__umoddi3+0xb3>
  803b02:	66 90                	xchg   %ax,%ax
  803b04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b08:	72 ea                	jb     803af4 <__umoddi3+0x134>
  803b0a:	89 d9                	mov    %ebx,%ecx
  803b0c:	e9 62 ff ff ff       	jmp    803a73 <__umoddi3+0xb3>
