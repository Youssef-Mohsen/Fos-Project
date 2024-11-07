
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
  80003e:	a1 04 30 80 00       	mov    0x803004,%eax
  800043:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800049:	a1 04 30 80 00       	mov    0x803004,%eax
  80004e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 60 1c 80 00       	push   $0x801c60
  800060:	6a 0c                	push   $0xc
  800062:	68 7c 1c 80 00       	push   $0x801c7c
  800067:	e8 c9 01 00 00       	call   800235 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	x = sget(sys_getparentenvid(),"x");
  800073:	e8 40 16 00 00       	call   8016b8 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 97 1c 80 00       	push   $0x801c97
  800080:	50                   	push   %eax
  800081:	e8 8e 12 00 00       	call   801314 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80008c:	e8 45 14 00 00       	call   8014d6 <sys_calculate_free_frames>
  800091:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 9c 1c 80 00       	push   $0x801c9c
  80009c:	e8 51 04 00 00       	call   8004f2 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000aa:	e8 7f 12 00 00       	call   80132e <sfree>
  8000af:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave env removed x\n");
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 c0 1c 80 00       	push   $0x801cc0
  8000ba:	e8 33 04 00 00       	call   8004f2 <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp

	diff = (sys_calculate_free_frames() - freeFrames);
  8000c2:	e8 0f 14 00 00       	call   8014d6 <sys_calculate_free_frames>
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
  8000e5:	68 d8 1c 80 00       	push   $0x801cd8
  8000ea:	6a 23                	push   $0x23
  8000ec:	68 7c 1c 80 00       	push   $0x801c7c
  8000f1:	e8 3f 01 00 00       	call   800235 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  8000f6:	e8 e2 16 00 00       	call   8017dd <inctst>

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
  800104:	e8 96 15 00 00       	call   80169f <sys_getenvindex>
  800109:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80010c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80010f:	89 d0                	mov    %edx,%eax
  800111:	c1 e0 02             	shl    $0x2,%eax
  800114:	01 d0                	add    %edx,%eax
  800116:	01 c0                	add    %eax,%eax
  800118:	01 d0                	add    %edx,%eax
  80011a:	c1 e0 02             	shl    $0x2,%eax
  80011d:	01 d0                	add    %edx,%eax
  80011f:	01 c0                	add    %eax,%eax
  800121:	01 d0                	add    %edx,%eax
  800123:	c1 e0 04             	shl    $0x4,%eax
  800126:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012b:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800130:	a1 04 30 80 00       	mov    0x803004,%eax
  800135:	8a 40 20             	mov    0x20(%eax),%al
  800138:	84 c0                	test   %al,%al
  80013a:	74 0d                	je     800149 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80013c:	a1 04 30 80 00       	mov    0x803004,%eax
  800141:	83 c0 20             	add    $0x20,%eax
  800144:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800149:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80014d:	7e 0a                	jle    800159 <libmain+0x5b>
		binaryname = argv[0];
  80014f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800152:	8b 00                	mov    (%eax),%eax
  800154:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800159:	83 ec 08             	sub    $0x8,%esp
  80015c:	ff 75 0c             	pushl  0xc(%ebp)
  80015f:	ff 75 08             	pushl  0x8(%ebp)
  800162:	e8 d1 fe ff ff       	call   800038 <_main>
  800167:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80016a:	e8 b4 12 00 00       	call   801423 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80016f:	83 ec 0c             	sub    $0xc,%esp
  800172:	68 7c 1d 80 00       	push   $0x801d7c
  800177:	e8 76 03 00 00       	call   8004f2 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80017f:	a1 04 30 80 00       	mov    0x803004,%eax
  800184:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80018a:	a1 04 30 80 00       	mov    0x803004,%eax
  80018f:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	52                   	push   %edx
  800199:	50                   	push   %eax
  80019a:	68 a4 1d 80 00       	push   $0x801da4
  80019f:	e8 4e 03 00 00       	call   8004f2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001a7:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ac:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8001b2:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b7:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8001bd:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c2:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8001c8:	51                   	push   %ecx
  8001c9:	52                   	push   %edx
  8001ca:	50                   	push   %eax
  8001cb:	68 cc 1d 80 00       	push   $0x801dcc
  8001d0:	e8 1d 03 00 00       	call   8004f2 <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001d8:	a1 04 30 80 00       	mov    0x803004,%eax
  8001dd:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	50                   	push   %eax
  8001e7:	68 24 1e 80 00       	push   $0x801e24
  8001ec:	e8 01 03 00 00       	call   8004f2 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 7c 1d 80 00       	push   $0x801d7c
  8001fc:	e8 f1 02 00 00       	call   8004f2 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800204:	e8 34 12 00 00       	call   80143d <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800209:	e8 19 00 00 00       	call   800227 <exit>
}
  80020e:	90                   	nop
  80020f:	c9                   	leave  
  800210:	c3                   	ret    

00800211 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	6a 00                	push   $0x0
  80021c:	e8 4a 14 00 00       	call   80166b <sys_destroy_env>
  800221:	83 c4 10             	add    $0x10,%esp
}
  800224:	90                   	nop
  800225:	c9                   	leave  
  800226:	c3                   	ret    

00800227 <exit>:

void
exit(void)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80022d:	e8 9f 14 00 00       	call   8016d1 <sys_exit_env>
}
  800232:	90                   	nop
  800233:	c9                   	leave  
  800234:	c3                   	ret    

00800235 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80023b:	8d 45 10             	lea    0x10(%ebp),%eax
  80023e:	83 c0 04             	add    $0x4,%eax
  800241:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800244:	a1 24 30 80 00       	mov    0x803024,%eax
  800249:	85 c0                	test   %eax,%eax
  80024b:	74 16                	je     800263 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80024d:	a1 24 30 80 00       	mov    0x803024,%eax
  800252:	83 ec 08             	sub    $0x8,%esp
  800255:	50                   	push   %eax
  800256:	68 38 1e 80 00       	push   $0x801e38
  80025b:	e8 92 02 00 00       	call   8004f2 <cprintf>
  800260:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800263:	a1 00 30 80 00       	mov    0x803000,%eax
  800268:	ff 75 0c             	pushl  0xc(%ebp)
  80026b:	ff 75 08             	pushl  0x8(%ebp)
  80026e:	50                   	push   %eax
  80026f:	68 3d 1e 80 00       	push   $0x801e3d
  800274:	e8 79 02 00 00       	call   8004f2 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80027c:	8b 45 10             	mov    0x10(%ebp),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	ff 75 f4             	pushl  -0xc(%ebp)
  800285:	50                   	push   %eax
  800286:	e8 fc 01 00 00       	call   800487 <vcprintf>
  80028b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	6a 00                	push   $0x0
  800293:	68 59 1e 80 00       	push   $0x801e59
  800298:	e8 ea 01 00 00       	call   800487 <vcprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002a0:	e8 82 ff ff ff       	call   800227 <exit>

	// should not return here
	while (1) ;
  8002a5:	eb fe                	jmp    8002a5 <_panic+0x70>

008002a7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8002b2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bb:	39 c2                	cmp    %eax,%edx
  8002bd:	74 14                	je     8002d3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002bf:	83 ec 04             	sub    $0x4,%esp
  8002c2:	68 5c 1e 80 00       	push   $0x801e5c
  8002c7:	6a 26                	push   $0x26
  8002c9:	68 a8 1e 80 00       	push   $0x801ea8
  8002ce:	e8 62 ff ff ff       	call   800235 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002e1:	e9 c5 00 00 00       	jmp    8003ab <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f3:	01 d0                	add    %edx,%eax
  8002f5:	8b 00                	mov    (%eax),%eax
  8002f7:	85 c0                	test   %eax,%eax
  8002f9:	75 08                	jne    800303 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002fe:	e9 a5 00 00 00       	jmp    8003a8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800303:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80030a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800311:	eb 69                	jmp    80037c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800313:	a1 04 30 80 00       	mov    0x803004,%eax
  800318:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80031e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800321:	89 d0                	mov    %edx,%eax
  800323:	01 c0                	add    %eax,%eax
  800325:	01 d0                	add    %edx,%eax
  800327:	c1 e0 03             	shl    $0x3,%eax
  80032a:	01 c8                	add    %ecx,%eax
  80032c:	8a 40 04             	mov    0x4(%eax),%al
  80032f:	84 c0                	test   %al,%al
  800331:	75 46                	jne    800379 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800333:	a1 04 30 80 00       	mov    0x803004,%eax
  800338:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80033e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800341:	89 d0                	mov    %edx,%eax
  800343:	01 c0                	add    %eax,%eax
  800345:	01 d0                	add    %edx,%eax
  800347:	c1 e0 03             	shl    $0x3,%eax
  80034a:	01 c8                	add    %ecx,%eax
  80034c:	8b 00                	mov    (%eax),%eax
  80034e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800351:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800354:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800359:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80035b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 c8                	add    %ecx,%eax
  80036a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	75 09                	jne    800379 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800370:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800377:	eb 15                	jmp    80038e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800379:	ff 45 e8             	incl   -0x18(%ebp)
  80037c:	a1 04 30 80 00       	mov    0x803004,%eax
  800381:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800387:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80038a:	39 c2                	cmp    %eax,%edx
  80038c:	77 85                	ja     800313 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80038e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800392:	75 14                	jne    8003a8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800394:	83 ec 04             	sub    $0x4,%esp
  800397:	68 b4 1e 80 00       	push   $0x801eb4
  80039c:	6a 3a                	push   $0x3a
  80039e:	68 a8 1e 80 00       	push   $0x801ea8
  8003a3:	e8 8d fe ff ff       	call   800235 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003a8:	ff 45 f0             	incl   -0x10(%ebp)
  8003ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003b1:	0f 8c 2f ff ff ff    	jl     8002e6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003c5:	eb 26                	jmp    8003ed <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8003cc:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8003d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d5:	89 d0                	mov    %edx,%eax
  8003d7:	01 c0                	add    %eax,%eax
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	c1 e0 03             	shl    $0x3,%eax
  8003de:	01 c8                	add    %ecx,%eax
  8003e0:	8a 40 04             	mov    0x4(%eax),%al
  8003e3:	3c 01                	cmp    $0x1,%al
  8003e5:	75 03                	jne    8003ea <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003e7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ea:	ff 45 e0             	incl   -0x20(%ebp)
  8003ed:	a1 04 30 80 00       	mov    0x803004,%eax
  8003f2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	77 c8                	ja     8003c7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800402:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800405:	74 14                	je     80041b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800407:	83 ec 04             	sub    $0x4,%esp
  80040a:	68 08 1f 80 00       	push   $0x801f08
  80040f:	6a 44                	push   $0x44
  800411:	68 a8 1e 80 00       	push   $0x801ea8
  800416:	e8 1a fe ff ff       	call   800235 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80041b:	90                   	nop
  80041c:	c9                   	leave  
  80041d:	c3                   	ret    

0080041e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800424:	8b 45 0c             	mov    0xc(%ebp),%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	8d 48 01             	lea    0x1(%eax),%ecx
  80042c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042f:	89 0a                	mov    %ecx,(%edx)
  800431:	8b 55 08             	mov    0x8(%ebp),%edx
  800434:	88 d1                	mov    %dl,%cl
  800436:	8b 55 0c             	mov    0xc(%ebp),%edx
  800439:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80043d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	3d ff 00 00 00       	cmp    $0xff,%eax
  800447:	75 2c                	jne    800475 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800449:	a0 08 30 80 00       	mov    0x803008,%al
  80044e:	0f b6 c0             	movzbl %al,%eax
  800451:	8b 55 0c             	mov    0xc(%ebp),%edx
  800454:	8b 12                	mov    (%edx),%edx
  800456:	89 d1                	mov    %edx,%ecx
  800458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045b:	83 c2 08             	add    $0x8,%edx
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	50                   	push   %eax
  800462:	51                   	push   %ecx
  800463:	52                   	push   %edx
  800464:	e8 78 0f 00 00       	call   8013e1 <sys_cputs>
  800469:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80046c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800475:	8b 45 0c             	mov    0xc(%ebp),%eax
  800478:	8b 40 04             	mov    0x4(%eax),%eax
  80047b:	8d 50 01             	lea    0x1(%eax),%edx
  80047e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800481:	89 50 04             	mov    %edx,0x4(%eax)
}
  800484:	90                   	nop
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800490:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800497:	00 00 00 
	b.cnt = 0;
  80049a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004a1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004a4:	ff 75 0c             	pushl  0xc(%ebp)
  8004a7:	ff 75 08             	pushl  0x8(%ebp)
  8004aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b0:	50                   	push   %eax
  8004b1:	68 1e 04 80 00       	push   $0x80041e
  8004b6:	e8 11 02 00 00       	call   8006cc <vprintfmt>
  8004bb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004be:	a0 08 30 80 00       	mov    0x803008,%al
  8004c3:	0f b6 c0             	movzbl %al,%eax
  8004c6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	50                   	push   %eax
  8004d0:	52                   	push   %edx
  8004d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004d7:	83 c0 08             	add    $0x8,%eax
  8004da:	50                   	push   %eax
  8004db:	e8 01 0f 00 00       	call   8013e1 <sys_cputs>
  8004e0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004e3:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8004ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004f8:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8004ff:	8d 45 0c             	lea    0xc(%ebp),%eax
  800502:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800505:	8b 45 08             	mov    0x8(%ebp),%eax
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	ff 75 f4             	pushl  -0xc(%ebp)
  80050e:	50                   	push   %eax
  80050f:	e8 73 ff ff ff       	call   800487 <vcprintf>
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80051a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80051d:	c9                   	leave  
  80051e:	c3                   	ret    

0080051f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800525:	e8 f9 0e 00 00       	call   801423 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80052a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80052d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800530:	8b 45 08             	mov    0x8(%ebp),%eax
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	ff 75 f4             	pushl  -0xc(%ebp)
  800539:	50                   	push   %eax
  80053a:	e8 48 ff ff ff       	call   800487 <vcprintf>
  80053f:	83 c4 10             	add    $0x10,%esp
  800542:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800545:	e8 f3 0e 00 00       	call   80143d <sys_unlock_cons>
	return cnt;
  80054a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054d:	c9                   	leave  
  80054e:	c3                   	ret    

0080054f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80054f:	55                   	push   %ebp
  800550:	89 e5                	mov    %esp,%ebp
  800552:	53                   	push   %ebx
  800553:	83 ec 14             	sub    $0x14,%esp
  800556:	8b 45 10             	mov    0x10(%ebp),%eax
  800559:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800562:	8b 45 18             	mov    0x18(%ebp),%eax
  800565:	ba 00 00 00 00       	mov    $0x0,%edx
  80056a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80056d:	77 55                	ja     8005c4 <printnum+0x75>
  80056f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800572:	72 05                	jb     800579 <printnum+0x2a>
  800574:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800577:	77 4b                	ja     8005c4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800579:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80057c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80057f:	8b 45 18             	mov    0x18(%ebp),%eax
  800582:	ba 00 00 00 00       	mov    $0x0,%edx
  800587:	52                   	push   %edx
  800588:	50                   	push   %eax
  800589:	ff 75 f4             	pushl  -0xc(%ebp)
  80058c:	ff 75 f0             	pushl  -0x10(%ebp)
  80058f:	e8 4c 14 00 00       	call   8019e0 <__udivdi3>
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	83 ec 04             	sub    $0x4,%esp
  80059a:	ff 75 20             	pushl  0x20(%ebp)
  80059d:	53                   	push   %ebx
  80059e:	ff 75 18             	pushl  0x18(%ebp)
  8005a1:	52                   	push   %edx
  8005a2:	50                   	push   %eax
  8005a3:	ff 75 0c             	pushl  0xc(%ebp)
  8005a6:	ff 75 08             	pushl  0x8(%ebp)
  8005a9:	e8 a1 ff ff ff       	call   80054f <printnum>
  8005ae:	83 c4 20             	add    $0x20,%esp
  8005b1:	eb 1a                	jmp    8005cd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 0c             	pushl  0xc(%ebp)
  8005b9:	ff 75 20             	pushl  0x20(%ebp)
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	ff d0                	call   *%eax
  8005c1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005c4:	ff 4d 1c             	decl   0x1c(%ebp)
  8005c7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005cb:	7f e6                	jg     8005b3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005cd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005db:	53                   	push   %ebx
  8005dc:	51                   	push   %ecx
  8005dd:	52                   	push   %edx
  8005de:	50                   	push   %eax
  8005df:	e8 0c 15 00 00       	call   801af0 <__umoddi3>
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	05 74 21 80 00       	add    $0x802174,%eax
  8005ec:	8a 00                	mov    (%eax),%al
  8005ee:	0f be c0             	movsbl %al,%eax
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	ff 75 0c             	pushl  0xc(%ebp)
  8005f7:	50                   	push   %eax
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	ff d0                	call   *%eax
  8005fd:	83 c4 10             	add    $0x10,%esp
}
  800600:	90                   	nop
  800601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800604:	c9                   	leave  
  800605:	c3                   	ret    

00800606 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800606:	55                   	push   %ebp
  800607:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800609:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80060d:	7e 1c                	jle    80062b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	8b 00                	mov    (%eax),%eax
  800614:	8d 50 08             	lea    0x8(%eax),%edx
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	89 10                	mov    %edx,(%eax)
  80061c:	8b 45 08             	mov    0x8(%ebp),%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	83 e8 08             	sub    $0x8,%eax
  800624:	8b 50 04             	mov    0x4(%eax),%edx
  800627:	8b 00                	mov    (%eax),%eax
  800629:	eb 40                	jmp    80066b <getuint+0x65>
	else if (lflag)
  80062b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80062f:	74 1e                	je     80064f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	8d 50 04             	lea    0x4(%eax),%edx
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	89 10                	mov    %edx,(%eax)
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	83 e8 04             	sub    $0x4,%eax
  800646:	8b 00                	mov    (%eax),%eax
  800648:	ba 00 00 00 00       	mov    $0x0,%edx
  80064d:	eb 1c                	jmp    80066b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	8d 50 04             	lea    0x4(%eax),%edx
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	89 10                	mov    %edx,(%eax)
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	83 e8 04             	sub    $0x4,%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80066b:	5d                   	pop    %ebp
  80066c:	c3                   	ret    

0080066d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80066d:	55                   	push   %ebp
  80066e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800670:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800674:	7e 1c                	jle    800692 <getint+0x25>
		return va_arg(*ap, long long);
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	8d 50 08             	lea    0x8(%eax),%edx
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	89 10                	mov    %edx,(%eax)
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	83 e8 08             	sub    $0x8,%eax
  80068b:	8b 50 04             	mov    0x4(%eax),%edx
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	eb 38                	jmp    8006ca <getint+0x5d>
	else if (lflag)
  800692:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800696:	74 1a                	je     8006b2 <getint+0x45>
		return va_arg(*ap, long);
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	8d 50 04             	lea    0x4(%eax),%edx
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	89 10                	mov    %edx,(%eax)
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	83 e8 04             	sub    $0x4,%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	99                   	cltd   
  8006b0:	eb 18                	jmp    8006ca <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	89 10                	mov    %edx,(%eax)
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	83 e8 04             	sub    $0x4,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	99                   	cltd   
}
  8006ca:	5d                   	pop    %ebp
  8006cb:	c3                   	ret    

008006cc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006cc:	55                   	push   %ebp
  8006cd:	89 e5                	mov    %esp,%ebp
  8006cf:	56                   	push   %esi
  8006d0:	53                   	push   %ebx
  8006d1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d4:	eb 17                	jmp    8006ed <vprintfmt+0x21>
			if (ch == '\0')
  8006d6:	85 db                	test   %ebx,%ebx
  8006d8:	0f 84 c1 03 00 00    	je     800a9f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	ff 75 0c             	pushl  0xc(%ebp)
  8006e4:	53                   	push   %ebx
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	ff d0                	call   *%eax
  8006ea:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f0:	8d 50 01             	lea    0x1(%eax),%edx
  8006f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8006f6:	8a 00                	mov    (%eax),%al
  8006f8:	0f b6 d8             	movzbl %al,%ebx
  8006fb:	83 fb 25             	cmp    $0x25,%ebx
  8006fe:	75 d6                	jne    8006d6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800700:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800704:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80070b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800712:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800719:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	8d 50 01             	lea    0x1(%eax),%edx
  800726:	89 55 10             	mov    %edx,0x10(%ebp)
  800729:	8a 00                	mov    (%eax),%al
  80072b:	0f b6 d8             	movzbl %al,%ebx
  80072e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800731:	83 f8 5b             	cmp    $0x5b,%eax
  800734:	0f 87 3d 03 00 00    	ja     800a77 <vprintfmt+0x3ab>
  80073a:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  800741:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800743:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800747:	eb d7                	jmp    800720 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800749:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80074d:	eb d1                	jmp    800720 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80074f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800756:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800759:	89 d0                	mov    %edx,%eax
  80075b:	c1 e0 02             	shl    $0x2,%eax
  80075e:	01 d0                	add    %edx,%eax
  800760:	01 c0                	add    %eax,%eax
  800762:	01 d8                	add    %ebx,%eax
  800764:	83 e8 30             	sub    $0x30,%eax
  800767:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80076a:	8b 45 10             	mov    0x10(%ebp),%eax
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800772:	83 fb 2f             	cmp    $0x2f,%ebx
  800775:	7e 3e                	jle    8007b5 <vprintfmt+0xe9>
  800777:	83 fb 39             	cmp    $0x39,%ebx
  80077a:	7f 39                	jg     8007b5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80077c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80077f:	eb d5                	jmp    800756 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	83 c0 04             	add    $0x4,%eax
  800787:	89 45 14             	mov    %eax,0x14(%ebp)
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800795:	eb 1f                	jmp    8007b6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800797:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80079b:	79 83                	jns    800720 <vprintfmt+0x54>
				width = 0;
  80079d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007a4:	e9 77 ff ff ff       	jmp    800720 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007a9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007b0:	e9 6b ff ff ff       	jmp    800720 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007b5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ba:	0f 89 60 ff ff ff    	jns    800720 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007c6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007cd:	e9 4e ff ff ff       	jmp    800720 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007d2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007d5:	e9 46 ff ff ff       	jmp    800720 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	83 c0 04             	add    $0x4,%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	83 e8 04             	sub    $0x4,%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	50                   	push   %eax
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
			break;
  8007fa:	e9 9b 02 00 00       	jmp    800a9a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	83 c0 04             	add    $0x4,%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	83 e8 04             	sub    $0x4,%eax
  80080e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800810:	85 db                	test   %ebx,%ebx
  800812:	79 02                	jns    800816 <vprintfmt+0x14a>
				err = -err;
  800814:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800816:	83 fb 64             	cmp    $0x64,%ebx
  800819:	7f 0b                	jg     800826 <vprintfmt+0x15a>
  80081b:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  800822:	85 f6                	test   %esi,%esi
  800824:	75 19                	jne    80083f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800826:	53                   	push   %ebx
  800827:	68 85 21 80 00       	push   $0x802185
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	ff 75 08             	pushl  0x8(%ebp)
  800832:	e8 70 02 00 00       	call   800aa7 <printfmt>
  800837:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80083a:	e9 5b 02 00 00       	jmp    800a9a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80083f:	56                   	push   %esi
  800840:	68 8e 21 80 00       	push   $0x80218e
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	ff 75 08             	pushl  0x8(%ebp)
  80084b:	e8 57 02 00 00       	call   800aa7 <printfmt>
  800850:	83 c4 10             	add    $0x10,%esp
			break;
  800853:	e9 42 02 00 00       	jmp    800a9a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 e8 04             	sub    $0x4,%eax
  800867:	8b 30                	mov    (%eax),%esi
  800869:	85 f6                	test   %esi,%esi
  80086b:	75 05                	jne    800872 <vprintfmt+0x1a6>
				p = "(null)";
  80086d:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  800872:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800876:	7e 6d                	jle    8008e5 <vprintfmt+0x219>
  800878:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80087c:	74 67                	je     8008e5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80087e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	50                   	push   %eax
  800885:	56                   	push   %esi
  800886:	e8 1e 03 00 00       	call   800ba9 <strnlen>
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800891:	eb 16                	jmp    8008a9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800893:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	50                   	push   %eax
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	ff d0                	call   *%eax
  8008a3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a6:	ff 4d e4             	decl   -0x1c(%ebp)
  8008a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ad:	7f e4                	jg     800893 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008af:	eb 34                	jmp    8008e5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008b5:	74 1c                	je     8008d3 <vprintfmt+0x207>
  8008b7:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ba:	7e 05                	jle    8008c1 <vprintfmt+0x1f5>
  8008bc:	83 fb 7e             	cmp    $0x7e,%ebx
  8008bf:	7e 12                	jle    8008d3 <vprintfmt+0x207>
					putch('?', putdat);
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	6a 3f                	push   $0x3f
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
  8008d1:	eb 0f                	jmp    8008e2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	53                   	push   %ebx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e2:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e5:	89 f0                	mov    %esi,%eax
  8008e7:	8d 70 01             	lea    0x1(%eax),%esi
  8008ea:	8a 00                	mov    (%eax),%al
  8008ec:	0f be d8             	movsbl %al,%ebx
  8008ef:	85 db                	test   %ebx,%ebx
  8008f1:	74 24                	je     800917 <vprintfmt+0x24b>
  8008f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008f7:	78 b8                	js     8008b1 <vprintfmt+0x1e5>
  8008f9:	ff 4d e0             	decl   -0x20(%ebp)
  8008fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800900:	79 af                	jns    8008b1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800902:	eb 13                	jmp    800917 <vprintfmt+0x24b>
				putch(' ', putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	6a 20                	push   $0x20
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	ff d0                	call   *%eax
  800911:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800914:	ff 4d e4             	decl   -0x1c(%ebp)
  800917:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091b:	7f e7                	jg     800904 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80091d:	e9 78 01 00 00       	jmp    800a9a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 e8             	pushl  -0x18(%ebp)
  800928:	8d 45 14             	lea    0x14(%ebp),%eax
  80092b:	50                   	push   %eax
  80092c:	e8 3c fd ff ff       	call   80066d <getint>
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800937:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80093a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800940:	85 d2                	test   %edx,%edx
  800942:	79 23                	jns    800967 <vprintfmt+0x29b>
				putch('-', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 2d                	push   $0x2d
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800957:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095a:	f7 d8                	neg    %eax
  80095c:	83 d2 00             	adc    $0x0,%edx
  80095f:	f7 da                	neg    %edx
  800961:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800964:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800967:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80096e:	e9 bc 00 00 00       	jmp    800a2f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	ff 75 e8             	pushl  -0x18(%ebp)
  800979:	8d 45 14             	lea    0x14(%ebp),%eax
  80097c:	50                   	push   %eax
  80097d:	e8 84 fc ff ff       	call   800606 <getuint>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800988:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80098b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800992:	e9 98 00 00 00       	jmp    800a2f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	6a 58                	push   $0x58
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	ff d0                	call   *%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	6a 58                	push   $0x58
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	ff d0                	call   *%eax
  8009b4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	6a 58                	push   $0x58
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	ff d0                	call   *%eax
  8009c4:	83 c4 10             	add    $0x10,%esp
			break;
  8009c7:	e9 ce 00 00 00       	jmp    800a9a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009cc:	83 ec 08             	sub    $0x8,%esp
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	6a 30                	push   $0x30
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	ff d0                	call   *%eax
  8009d9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	6a 78                	push   $0x78
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	ff d0                	call   *%eax
  8009e9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	83 c0 04             	add    $0x4,%eax
  8009f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f8:	83 e8 04             	sub    $0x4,%eax
  8009fb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a0e:	eb 1f                	jmp    800a2f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 e8             	pushl  -0x18(%ebp)
  800a16:	8d 45 14             	lea    0x14(%ebp),%eax
  800a19:	50                   	push   %eax
  800a1a:	e8 e7 fb ff ff       	call   800606 <getuint>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a25:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a28:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a2f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a36:	83 ec 04             	sub    $0x4,%esp
  800a39:	52                   	push   %edx
  800a3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a3d:	50                   	push   %eax
  800a3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a41:	ff 75 f0             	pushl  -0x10(%ebp)
  800a44:	ff 75 0c             	pushl  0xc(%ebp)
  800a47:	ff 75 08             	pushl  0x8(%ebp)
  800a4a:	e8 00 fb ff ff       	call   80054f <printnum>
  800a4f:	83 c4 20             	add    $0x20,%esp
			break;
  800a52:	eb 46                	jmp    800a9a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	53                   	push   %ebx
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	eb 35                	jmp    800a9a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a65:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800a6c:	eb 2c                	jmp    800a9a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a6e:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800a75:	eb 23                	jmp    800a9a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 25                	push   $0x25
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a87:	ff 4d 10             	decl   0x10(%ebp)
  800a8a:	eb 03                	jmp    800a8f <vprintfmt+0x3c3>
  800a8c:	ff 4d 10             	decl   0x10(%ebp)
  800a8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a92:	48                   	dec    %eax
  800a93:	8a 00                	mov    (%eax),%al
  800a95:	3c 25                	cmp    $0x25,%al
  800a97:	75 f3                	jne    800a8c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a99:	90                   	nop
		}
	}
  800a9a:	e9 35 fc ff ff       	jmp    8006d4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a9f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aa3:	5b                   	pop    %ebx
  800aa4:	5e                   	pop    %esi
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aad:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab0:	83 c0 04             	add    $0x4,%eax
  800ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab9:	ff 75 f4             	pushl  -0xc(%ebp)
  800abc:	50                   	push   %eax
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	ff 75 08             	pushl  0x8(%ebp)
  800ac3:	e8 04 fc ff ff       	call   8006cc <vprintfmt>
  800ac8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800acb:	90                   	nop
  800acc:	c9                   	leave  
  800acd:	c3                   	ret    

00800ace <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad4:	8b 40 08             	mov    0x8(%eax),%eax
  800ad7:	8d 50 01             	lea    0x1(%eax),%edx
  800ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  800add:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae3:	8b 10                	mov    (%eax),%edx
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	8b 40 04             	mov    0x4(%eax),%eax
  800aeb:	39 c2                	cmp    %eax,%edx
  800aed:	73 12                	jae    800b01 <sprintputch+0x33>
		*b->buf++ = ch;
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	8d 48 01             	lea    0x1(%eax),%ecx
  800af7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afa:	89 0a                	mov    %ecx,(%edx)
  800afc:	8b 55 08             	mov    0x8(%ebp),%edx
  800aff:	88 10                	mov    %dl,(%eax)
}
  800b01:	90                   	nop
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	01 d0                	add    %edx,%eax
  800b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b29:	74 06                	je     800b31 <vsnprintf+0x2d>
  800b2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2f:	7f 07                	jg     800b38 <vsnprintf+0x34>
		return -E_INVAL;
  800b31:	b8 03 00 00 00       	mov    $0x3,%eax
  800b36:	eb 20                	jmp    800b58 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b38:	ff 75 14             	pushl  0x14(%ebp)
  800b3b:	ff 75 10             	pushl  0x10(%ebp)
  800b3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b41:	50                   	push   %eax
  800b42:	68 ce 0a 80 00       	push   $0x800ace
  800b47:	e8 80 fb ff ff       	call   8006cc <vprintfmt>
  800b4c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b52:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b58:	c9                   	leave  
  800b59:	c3                   	ret    

00800b5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b60:	8d 45 10             	lea    0x10(%ebp),%eax
  800b63:	83 c0 04             	add    $0x4,%eax
  800b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b69:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6f:	50                   	push   %eax
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	ff 75 08             	pushl  0x8(%ebp)
  800b76:	e8 89 ff ff ff       	call   800b04 <vsnprintf>
  800b7b:	83 c4 10             	add    $0x10,%esp
  800b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b93:	eb 06                	jmp    800b9b <strlen+0x15>
		n++;
  800b95:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b98:	ff 45 08             	incl   0x8(%ebp)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	84 c0                	test   %al,%al
  800ba2:	75 f1                	jne    800b95 <strlen+0xf>
		n++;
	return n;
  800ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    

00800ba9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800baf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb6:	eb 09                	jmp    800bc1 <strnlen+0x18>
		n++;
  800bb8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bbb:	ff 45 08             	incl   0x8(%ebp)
  800bbe:	ff 4d 0c             	decl   0xc(%ebp)
  800bc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc5:	74 09                	je     800bd0 <strnlen+0x27>
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8a 00                	mov    (%eax),%al
  800bcc:	84 c0                	test   %al,%al
  800bce:	75 e8                	jne    800bb8 <strnlen+0xf>
		n++;
	return n;
  800bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800be1:	90                   	nop
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	8d 50 01             	lea    0x1(%eax),%edx
  800be8:	89 55 08             	mov    %edx,0x8(%ebp)
  800beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bee:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bf4:	8a 12                	mov    (%edx),%dl
  800bf6:	88 10                	mov    %dl,(%eax)
  800bf8:	8a 00                	mov    (%eax),%al
  800bfa:	84 c0                	test   %al,%al
  800bfc:	75 e4                	jne    800be2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c16:	eb 1f                	jmp    800c37 <strncpy+0x34>
		*dst++ = *src;
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8d 50 01             	lea    0x1(%eax),%edx
  800c1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c24:	8a 12                	mov    (%edx),%dl
  800c26:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2b:	8a 00                	mov    (%eax),%al
  800c2d:	84 c0                	test   %al,%al
  800c2f:	74 03                	je     800c34 <strncpy+0x31>
			src++;
  800c31:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c34:	ff 45 fc             	incl   -0x4(%ebp)
  800c37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c3d:	72 d9                	jb     800c18 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c54:	74 30                	je     800c86 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c56:	eb 16                	jmp    800c6e <strlcpy+0x2a>
			*dst++ = *src++;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6a:	8a 12                	mov    (%edx),%dl
  800c6c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c6e:	ff 4d 10             	decl   0x10(%ebp)
  800c71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c75:	74 09                	je     800c80 <strlcpy+0x3c>
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7a:	8a 00                	mov    (%eax),%al
  800c7c:	84 c0                	test   %al,%al
  800c7e:	75 d8                	jne    800c58 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c86:	8b 55 08             	mov    0x8(%ebp),%edx
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8c:	29 c2                	sub    %eax,%edx
  800c8e:	89 d0                	mov    %edx,%eax
}
  800c90:	c9                   	leave  
  800c91:	c3                   	ret    

00800c92 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c95:	eb 06                	jmp    800c9d <strcmp+0xb>
		p++, q++;
  800c97:	ff 45 08             	incl   0x8(%ebp)
  800c9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	74 0e                	je     800cb4 <strcmp+0x22>
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8a 10                	mov    (%eax),%dl
  800cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	38 c2                	cmp    %al,%dl
  800cb2:	74 e3                	je     800c97 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	0f b6 d0             	movzbl %al,%edx
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	0f b6 c0             	movzbl %al,%eax
  800cc4:	29 c2                	sub    %eax,%edx
  800cc6:	89 d0                	mov    %edx,%eax
}
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    

00800cca <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ccd:	eb 09                	jmp    800cd8 <strncmp+0xe>
		n--, p++, q++;
  800ccf:	ff 4d 10             	decl   0x10(%ebp)
  800cd2:	ff 45 08             	incl   0x8(%ebp)
  800cd5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdc:	74 17                	je     800cf5 <strncmp+0x2b>
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	84 c0                	test   %al,%al
  800ce5:	74 0e                	je     800cf5 <strncmp+0x2b>
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 10                	mov    (%eax),%dl
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	38 c2                	cmp    %al,%dl
  800cf3:	74 da                	je     800ccf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf9:	75 07                	jne    800d02 <strncmp+0x38>
		return 0;
  800cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800d00:	eb 14                	jmp    800d16 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	0f b6 d0             	movzbl %al,%edx
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	0f b6 c0             	movzbl %al,%eax
  800d12:	29 c2                	sub    %eax,%edx
  800d14:	89 d0                	mov    %edx,%eax
}
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	83 ec 04             	sub    $0x4,%esp
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d24:	eb 12                	jmp    800d38 <strchr+0x20>
		if (*s == c)
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d2e:	75 05                	jne    800d35 <strchr+0x1d>
			return (char *) s;
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	eb 11                	jmp    800d46 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d35:	ff 45 08             	incl   0x8(%ebp)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	84 c0                	test   %al,%al
  800d3f:	75 e5                	jne    800d26 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	83 ec 04             	sub    $0x4,%esp
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d54:	eb 0d                	jmp    800d63 <strfind+0x1b>
		if (*s == c)
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5e:	74 0e                	je     800d6e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d60:	ff 45 08             	incl   0x8(%ebp)
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	84 c0                	test   %al,%al
  800d6a:	75 ea                	jne    800d56 <strfind+0xe>
  800d6c:	eb 01                	jmp    800d6f <strfind+0x27>
		if (*s == c)
			break;
  800d6e:	90                   	nop
	return (char *) s;
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d72:	c9                   	leave  
  800d73:	c3                   	ret    

00800d74 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d80:	8b 45 10             	mov    0x10(%ebp),%eax
  800d83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d86:	eb 0e                	jmp    800d96 <memset+0x22>
		*p++ = c;
  800d88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8b:	8d 50 01             	lea    0x1(%eax),%edx
  800d8e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d94:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d96:	ff 4d f8             	decl   -0x8(%ebp)
  800d99:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d9d:	79 e9                	jns    800d88 <memset+0x14>
		*p++ = c;

	return v;
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800db6:	eb 16                	jmp    800dce <memcpy+0x2a>
		*d++ = *s++;
  800db8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbb:	8d 50 01             	lea    0x1(%eax),%edx
  800dbe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dca:	8a 12                	mov    (%edx),%dl
  800dcc:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dce:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd4:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	75 dd                	jne    800db8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df8:	73 50                	jae    800e4a <memmove+0x6a>
  800dfa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	01 d0                	add    %edx,%eax
  800e02:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e05:	76 43                	jbe    800e4a <memmove+0x6a>
		s += n;
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e13:	eb 10                	jmp    800e25 <memmove+0x45>
			*--d = *--s;
  800e15:	ff 4d f8             	decl   -0x8(%ebp)
  800e18:	ff 4d fc             	decl   -0x4(%ebp)
  800e1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1e:	8a 10                	mov    (%eax),%dl
  800e20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e23:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e25:	8b 45 10             	mov    0x10(%ebp),%eax
  800e28:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	75 e3                	jne    800e15 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e32:	eb 23                	jmp    800e57 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e37:	8d 50 01             	lea    0x1(%eax),%edx
  800e3a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e43:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e46:	8a 12                	mov    (%edx),%dl
  800e48:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e50:	89 55 10             	mov    %edx,0x10(%ebp)
  800e53:	85 c0                	test   %eax,%eax
  800e55:	75 dd                	jne    800e34 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5a:	c9                   	leave  
  800e5b:	c3                   	ret    

00800e5c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e6e:	eb 2a                	jmp    800e9a <memcmp+0x3e>
		if (*s1 != *s2)
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	8a 10                	mov    (%eax),%dl
  800e75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	38 c2                	cmp    %al,%dl
  800e7c:	74 16                	je     800e94 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	0f b6 d0             	movzbl %al,%edx
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	0f b6 c0             	movzbl %al,%eax
  800e8e:	29 c2                	sub    %eax,%edx
  800e90:	89 d0                	mov    %edx,%eax
  800e92:	eb 18                	jmp    800eac <memcmp+0x50>
		s1++, s2++;
  800e94:	ff 45 fc             	incl   -0x4(%ebp)
  800e97:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea3:	85 c0                	test   %eax,%eax
  800ea5:	75 c9                	jne    800e70 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	01 d0                	add    %edx,%eax
  800ebc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ebf:	eb 15                	jmp    800ed6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	0f b6 d0             	movzbl %al,%edx
  800ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecc:	0f b6 c0             	movzbl %al,%eax
  800ecf:	39 c2                	cmp    %eax,%edx
  800ed1:	74 0d                	je     800ee0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ed3:	ff 45 08             	incl   0x8(%ebp)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800edc:	72 e3                	jb     800ec1 <memfind+0x13>
  800ede:	eb 01                	jmp    800ee1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ee0:	90                   	nop
	return (void *) s;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ef3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800efa:	eb 03                	jmp    800eff <strtol+0x19>
		s++;
  800efc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	3c 20                	cmp    $0x20,%al
  800f06:	74 f4                	je     800efc <strtol+0x16>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 09                	cmp    $0x9,%al
  800f0f:	74 eb                	je     800efc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	3c 2b                	cmp    $0x2b,%al
  800f18:	75 05                	jne    800f1f <strtol+0x39>
		s++;
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	eb 13                	jmp    800f32 <strtol+0x4c>
	else if (*s == '-')
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	3c 2d                	cmp    $0x2d,%al
  800f26:	75 0a                	jne    800f32 <strtol+0x4c>
		s++, neg = 1;
  800f28:	ff 45 08             	incl   0x8(%ebp)
  800f2b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f36:	74 06                	je     800f3e <strtol+0x58>
  800f38:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f3c:	75 20                	jne    800f5e <strtol+0x78>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	3c 30                	cmp    $0x30,%al
  800f45:	75 17                	jne    800f5e <strtol+0x78>
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	40                   	inc    %eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 78                	cmp    $0x78,%al
  800f4f:	75 0d                	jne    800f5e <strtol+0x78>
		s += 2, base = 16;
  800f51:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f55:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f5c:	eb 28                	jmp    800f86 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	75 15                	jne    800f79 <strtol+0x93>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	3c 30                	cmp    $0x30,%al
  800f6b:	75 0c                	jne    800f79 <strtol+0x93>
		s++, base = 8;
  800f6d:	ff 45 08             	incl   0x8(%ebp)
  800f70:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f77:	eb 0d                	jmp    800f86 <strtol+0xa0>
	else if (base == 0)
  800f79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7d:	75 07                	jne    800f86 <strtol+0xa0>
		base = 10;
  800f7f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 2f                	cmp    $0x2f,%al
  800f8d:	7e 19                	jle    800fa8 <strtol+0xc2>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 39                	cmp    $0x39,%al
  800f96:	7f 10                	jg     800fa8 <strtol+0xc2>
			dig = *s - '0';
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f be c0             	movsbl %al,%eax
  800fa0:	83 e8 30             	sub    $0x30,%eax
  800fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa6:	eb 42                	jmp    800fea <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	3c 60                	cmp    $0x60,%al
  800faf:	7e 19                	jle    800fca <strtol+0xe4>
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	3c 7a                	cmp    $0x7a,%al
  800fb8:	7f 10                	jg     800fca <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	0f be c0             	movsbl %al,%eax
  800fc2:	83 e8 57             	sub    $0x57,%eax
  800fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc8:	eb 20                	jmp    800fea <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 40                	cmp    $0x40,%al
  800fd1:	7e 39                	jle    80100c <strtol+0x126>
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	3c 5a                	cmp    $0x5a,%al
  800fda:	7f 30                	jg     80100c <strtol+0x126>
			dig = *s - 'A' + 10;
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	0f be c0             	movsbl %al,%eax
  800fe4:	83 e8 37             	sub    $0x37,%eax
  800fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fed:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ff0:	7d 19                	jge    80100b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ff2:	ff 45 08             	incl   0x8(%ebp)
  800ff5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ffc:	89 c2                	mov    %eax,%edx
  800ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801001:	01 d0                	add    %edx,%eax
  801003:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801006:	e9 7b ff ff ff       	jmp    800f86 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80100b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80100c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801010:	74 08                	je     80101a <strtol+0x134>
		*endptr = (char *) s;
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80101a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101e:	74 07                	je     801027 <strtol+0x141>
  801020:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801023:	f7 d8                	neg    %eax
  801025:	eb 03                	jmp    80102a <strtol+0x144>
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <ltostr>:

void
ltostr(long value, char *str)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801032:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801039:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801040:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801044:	79 13                	jns    801059 <ltostr+0x2d>
	{
		neg = 1;
  801046:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80104d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801050:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801053:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801056:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801061:	99                   	cltd   
  801062:	f7 f9                	idiv   %ecx
  801064:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106a:	8d 50 01             	lea    0x1(%eax),%edx
  80106d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801070:	89 c2                	mov    %eax,%edx
  801072:	8b 45 0c             	mov    0xc(%ebp),%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80107a:	83 c2 30             	add    $0x30,%edx
  80107d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80107f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801082:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801087:	f7 e9                	imul   %ecx
  801089:	c1 fa 02             	sar    $0x2,%edx
  80108c:	89 c8                	mov    %ecx,%eax
  80108e:	c1 f8 1f             	sar    $0x1f,%eax
  801091:	29 c2                	sub    %eax,%edx
  801093:	89 d0                	mov    %edx,%eax
  801095:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801098:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80109c:	75 bb                	jne    801059 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80109e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a8:	48                   	dec    %eax
  8010a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b0:	74 3d                	je     8010ef <ltostr+0xc3>
		start = 1 ;
  8010b2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010b9:	eb 34                	jmp    8010ef <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c1:	01 d0                	add    %edx,%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	01 c2                	add    %eax,%edx
  8010d0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	01 c8                	add    %ecx,%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 c2                	add    %eax,%edx
  8010e4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010e7:	88 02                	mov    %al,(%edx)
		start++ ;
  8010e9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010ec:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f5:	7c c4                	jl     8010bb <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010f7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	01 d0                	add    %edx,%eax
  8010ff:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801102:	90                   	nop
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80110b:	ff 75 08             	pushl  0x8(%ebp)
  80110e:	e8 73 fa ff ff       	call   800b86 <strlen>
  801113:	83 c4 04             	add    $0x4,%esp
  801116:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801119:	ff 75 0c             	pushl  0xc(%ebp)
  80111c:	e8 65 fa ff ff       	call   800b86 <strlen>
  801121:	83 c4 04             	add    $0x4,%esp
  801124:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801127:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80112e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801135:	eb 17                	jmp    80114e <strcconcat+0x49>
		final[s] = str1[s] ;
  801137:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113a:	8b 45 10             	mov    0x10(%ebp),%eax
  80113d:	01 c2                	add    %eax,%edx
  80113f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	01 c8                	add    %ecx,%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80114b:	ff 45 fc             	incl   -0x4(%ebp)
  80114e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801151:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801154:	7c e1                	jl     801137 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801156:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80115d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801164:	eb 1f                	jmp    801185 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801166:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801169:	8d 50 01             	lea    0x1(%eax),%edx
  80116c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80116f:	89 c2                	mov    %eax,%edx
  801171:	8b 45 10             	mov    0x10(%ebp),%eax
  801174:	01 c2                	add    %eax,%edx
  801176:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	01 c8                	add    %ecx,%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801182:	ff 45 f8             	incl   -0x8(%ebp)
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80118b:	7c d9                	jl     801166 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80118d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	c6 00 00             	movb   $0x0,(%eax)
}
  801198:	90                   	nop
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80119e:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011aa:	8b 00                	mov    (%eax),%eax
  8011ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011be:	eb 0c                	jmp    8011cc <strsplit+0x31>
			*string++ = 0;
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8d 50 01             	lea    0x1(%eax),%edx
  8011c6:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	84 c0                	test   %al,%al
  8011d3:	74 18                	je     8011ed <strsplit+0x52>
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	0f be c0             	movsbl %al,%eax
  8011dd:	50                   	push   %eax
  8011de:	ff 75 0c             	pushl  0xc(%ebp)
  8011e1:	e8 32 fb ff ff       	call   800d18 <strchr>
  8011e6:	83 c4 08             	add    $0x8,%esp
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	75 d3                	jne    8011c0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	84 c0                	test   %al,%al
  8011f4:	74 5a                	je     801250 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f9:	8b 00                	mov    (%eax),%eax
  8011fb:	83 f8 0f             	cmp    $0xf,%eax
  8011fe:	75 07                	jne    801207 <strsplit+0x6c>
		{
			return 0;
  801200:	b8 00 00 00 00       	mov    $0x0,%eax
  801205:	eb 66                	jmp    80126d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801207:	8b 45 14             	mov    0x14(%ebp),%eax
  80120a:	8b 00                	mov    (%eax),%eax
  80120c:	8d 48 01             	lea    0x1(%eax),%ecx
  80120f:	8b 55 14             	mov    0x14(%ebp),%edx
  801212:	89 0a                	mov    %ecx,(%edx)
  801214:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80121b:	8b 45 10             	mov    0x10(%ebp),%eax
  80121e:	01 c2                	add    %eax,%edx
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801225:	eb 03                	jmp    80122a <strsplit+0x8f>
			string++;
  801227:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	84 c0                	test   %al,%al
  801231:	74 8b                	je     8011be <strsplit+0x23>
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	50                   	push   %eax
  80123c:	ff 75 0c             	pushl  0xc(%ebp)
  80123f:	e8 d4 fa ff ff       	call   800d18 <strchr>
  801244:	83 c4 08             	add    $0x8,%esp
  801247:	85 c0                	test   %eax,%eax
  801249:	74 dc                	je     801227 <strsplit+0x8c>
			string++;
	}
  80124b:	e9 6e ff ff ff       	jmp    8011be <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801250:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801251:	8b 45 14             	mov    0x14(%ebp),%eax
  801254:	8b 00                	mov    (%eax),%eax
  801256:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125d:	8b 45 10             	mov    0x10(%ebp),%eax
  801260:	01 d0                	add    %edx,%eax
  801262:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801268:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80126d:	c9                   	leave  
  80126e:	c3                   	ret    

0080126f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801275:	83 ec 04             	sub    $0x4,%esp
  801278:	68 08 23 80 00       	push   $0x802308
  80127d:	68 3f 01 00 00       	push   $0x13f
  801282:	68 2a 23 80 00       	push   $0x80232a
  801287:	e8 a9 ef ff ff       	call   800235 <_panic>

0080128c <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801292:	83 ec 0c             	sub    $0xc,%esp
  801295:	ff 75 08             	pushl  0x8(%ebp)
  801298:	e8 ef 06 00 00       	call   80198c <sys_sbrk>
  80129d:	83 c4 10             	add    $0x10,%esp
}
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8012a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ac:	75 07                	jne    8012b5 <malloc+0x13>
  8012ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b3:	eb 14                	jmp    8012c9 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8012b5:	83 ec 04             	sub    $0x4,%esp
  8012b8:	68 38 23 80 00       	push   $0x802338
  8012bd:	6a 1b                	push   $0x1b
  8012bf:	68 5d 23 80 00       	push   $0x80235d
  8012c4:	e8 6c ef ff ff       	call   800235 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8012d1:	83 ec 04             	sub    $0x4,%esp
  8012d4:	68 6c 23 80 00       	push   $0x80236c
  8012d9:	6a 29                	push   $0x29
  8012db:	68 5d 23 80 00       	push   $0x80235d
  8012e0:	e8 50 ef ff ff       	call   800235 <_panic>

008012e5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 18             	sub    $0x18,%esp
  8012eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ee:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8012f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012f5:	75 07                	jne    8012fe <smalloc+0x19>
  8012f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fc:	eb 14                	jmp    801312 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8012fe:	83 ec 04             	sub    $0x4,%esp
  801301:	68 90 23 80 00       	push   $0x802390
  801306:	6a 38                	push   $0x38
  801308:	68 5d 23 80 00       	push   $0x80235d
  80130d:	e8 23 ef ff ff       	call   800235 <_panic>
	return NULL;
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80131a:	83 ec 04             	sub    $0x4,%esp
  80131d:	68 b8 23 80 00       	push   $0x8023b8
  801322:	6a 43                	push   $0x43
  801324:	68 5d 23 80 00       	push   $0x80235d
  801329:	e8 07 ef ff ff       	call   800235 <_panic>

0080132e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801334:	83 ec 04             	sub    $0x4,%esp
  801337:	68 dc 23 80 00       	push   $0x8023dc
  80133c:	6a 5b                	push   $0x5b
  80133e:	68 5d 23 80 00       	push   $0x80235d
  801343:	e8 ed ee ff ff       	call   800235 <_panic>

00801348 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80134e:	83 ec 04             	sub    $0x4,%esp
  801351:	68 00 24 80 00       	push   $0x802400
  801356:	6a 72                	push   $0x72
  801358:	68 5d 23 80 00       	push   $0x80235d
  80135d:	e8 d3 ee ff ff       	call   800235 <_panic>

00801362 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801368:	83 ec 04             	sub    $0x4,%esp
  80136b:	68 26 24 80 00       	push   $0x802426
  801370:	6a 7e                	push   $0x7e
  801372:	68 5d 23 80 00       	push   $0x80235d
  801377:	e8 b9 ee ff ff       	call   800235 <_panic>

0080137c <shrink>:

}
void shrink(uint32 newSize)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801382:	83 ec 04             	sub    $0x4,%esp
  801385:	68 26 24 80 00       	push   $0x802426
  80138a:	68 83 00 00 00       	push   $0x83
  80138f:	68 5d 23 80 00       	push   $0x80235d
  801394:	e8 9c ee ff ff       	call   800235 <_panic>

00801399 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80139f:	83 ec 04             	sub    $0x4,%esp
  8013a2:	68 26 24 80 00       	push   $0x802426
  8013a7:	68 88 00 00 00       	push   $0x88
  8013ac:	68 5d 23 80 00       	push   $0x80235d
  8013b1:	e8 7f ee ff ff       	call   800235 <_panic>

008013b6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	57                   	push   %edi
  8013ba:	56                   	push   %esi
  8013bb:	53                   	push   %ebx
  8013bc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013cb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013ce:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013d1:	cd 30                	int    $0x30
  8013d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8013d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013d9:	83 c4 10             	add    $0x10,%esp
  8013dc:	5b                   	pop    %ebx
  8013dd:	5e                   	pop    %esi
  8013de:	5f                   	pop    %edi
  8013df:	5d                   	pop    %ebp
  8013e0:	c3                   	ret    

008013e1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	83 ec 04             	sub    $0x4,%esp
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8013ed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	52                   	push   %edx
  8013f9:	ff 75 0c             	pushl  0xc(%ebp)
  8013fc:	50                   	push   %eax
  8013fd:	6a 00                	push   $0x0
  8013ff:	e8 b2 ff ff ff       	call   8013b6 <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
}
  801407:	90                   	nop
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <sys_cgetc>:

int
sys_cgetc(void)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 02                	push   $0x2
  801419:	e8 98 ff ff ff       	call   8013b6 <syscall>
  80141e:	83 c4 18             	add    $0x18,%esp
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 03                	push   $0x3
  801432:	e8 7f ff ff ff       	call   8013b6 <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
}
  80143a:	90                   	nop
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 04                	push   $0x4
  80144c:	e8 65 ff ff ff       	call   8013b6 <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	90                   	nop
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80145a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	52                   	push   %edx
  801467:	50                   	push   %eax
  801468:	6a 08                	push   $0x8
  80146a:	e8 47 ff ff ff       	call   8013b6 <syscall>
  80146f:	83 c4 18             	add    $0x18,%esp
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	56                   	push   %esi
  801478:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801479:	8b 75 18             	mov    0x18(%ebp),%esi
  80147c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80147f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801482:	8b 55 0c             	mov    0xc(%ebp),%edx
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	56                   	push   %esi
  801489:	53                   	push   %ebx
  80148a:	51                   	push   %ecx
  80148b:	52                   	push   %edx
  80148c:	50                   	push   %eax
  80148d:	6a 09                	push   $0x9
  80148f:	e8 22 ff ff ff       	call   8013b6 <syscall>
  801494:	83 c4 18             	add    $0x18,%esp
}
  801497:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80149a:	5b                   	pop    %ebx
  80149b:	5e                   	pop    %esi
  80149c:	5d                   	pop    %ebp
  80149d:	c3                   	ret    

0080149e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	52                   	push   %edx
  8014ae:	50                   	push   %eax
  8014af:	6a 0a                	push   $0xa
  8014b1:	e8 00 ff ff ff       	call   8013b6 <syscall>
  8014b6:	83 c4 18             	add    $0x18,%esp
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	ff 75 0c             	pushl  0xc(%ebp)
  8014c7:	ff 75 08             	pushl  0x8(%ebp)
  8014ca:	6a 0b                	push   $0xb
  8014cc:	e8 e5 fe ff ff       	call   8013b6 <syscall>
  8014d1:	83 c4 18             	add    $0x18,%esp
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 0c                	push   $0xc
  8014e5:	e8 cc fe ff ff       	call   8013b6 <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 0d                	push   $0xd
  8014fe:	e8 b3 fe ff ff       	call   8013b6 <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 0e                	push   $0xe
  801517:	e8 9a fe ff ff       	call   8013b6 <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 0f                	push   $0xf
  801530:	e8 81 fe ff ff       	call   8013b6 <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	ff 75 08             	pushl  0x8(%ebp)
  801548:	6a 10                	push   $0x10
  80154a:	e8 67 fe ff ff       	call   8013b6 <syscall>
  80154f:	83 c4 18             	add    $0x18,%esp
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 11                	push   $0x11
  801563:	e8 4e fe ff ff       	call   8013b6 <syscall>
  801568:	83 c4 18             	add    $0x18,%esp
}
  80156b:	90                   	nop
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <sys_cputc>:

void
sys_cputc(const char c)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 04             	sub    $0x4,%esp
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80157a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	50                   	push   %eax
  801587:	6a 01                	push   $0x1
  801589:	e8 28 fe ff ff       	call   8013b6 <syscall>
  80158e:	83 c4 18             	add    $0x18,%esp
}
  801591:	90                   	nop
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 14                	push   $0x14
  8015a3:	e8 0e fe ff ff       	call   8013b6 <syscall>
  8015a8:	83 c4 18             	add    $0x18,%esp
}
  8015ab:	90                   	nop
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015ba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015bd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	6a 00                	push   $0x0
  8015c6:	51                   	push   %ecx
  8015c7:	52                   	push   %edx
  8015c8:	ff 75 0c             	pushl  0xc(%ebp)
  8015cb:	50                   	push   %eax
  8015cc:	6a 15                	push   $0x15
  8015ce:	e8 e3 fd ff ff       	call   8013b6 <syscall>
  8015d3:	83 c4 18             	add    $0x18,%esp
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	52                   	push   %edx
  8015e8:	50                   	push   %eax
  8015e9:	6a 16                	push   $0x16
  8015eb:	e8 c6 fd ff ff       	call   8013b6 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	51                   	push   %ecx
  801606:	52                   	push   %edx
  801607:	50                   	push   %eax
  801608:	6a 17                	push   $0x17
  80160a:	e8 a7 fd ff ff       	call   8013b6 <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	52                   	push   %edx
  801624:	50                   	push   %eax
  801625:	6a 18                	push   $0x18
  801627:	e8 8a fd ff ff       	call   8013b6 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	6a 00                	push   $0x0
  801639:	ff 75 14             	pushl  0x14(%ebp)
  80163c:	ff 75 10             	pushl  0x10(%ebp)
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	50                   	push   %eax
  801643:	6a 19                	push   $0x19
  801645:	e8 6c fd ff ff       	call   8013b6 <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	50                   	push   %eax
  80165e:	6a 1a                	push   $0x1a
  801660:	e8 51 fd ff ff       	call   8013b6 <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
}
  801668:	90                   	nop
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	50                   	push   %eax
  80167a:	6a 1b                	push   $0x1b
  80167c:	e8 35 fd ff ff       	call   8013b6 <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 05                	push   $0x5
  801695:	e8 1c fd ff ff       	call   8013b6 <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 06                	push   $0x6
  8016ae:	e8 03 fd ff ff       	call   8013b6 <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 07                	push   $0x7
  8016c7:	e8 ea fc ff ff       	call   8013b6 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_exit_env>:


void sys_exit_env(void)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 1c                	push   $0x1c
  8016e0:	e8 d1 fc ff ff       	call   8013b6 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	90                   	nop
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016f1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016f4:	8d 50 04             	lea    0x4(%eax),%edx
  8016f7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	52                   	push   %edx
  801701:	50                   	push   %eax
  801702:	6a 1d                	push   $0x1d
  801704:	e8 ad fc ff ff       	call   8013b6 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
	return result;
  80170c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80170f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801712:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801715:	89 01                	mov    %eax,(%ecx)
  801717:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	c9                   	leave  
  80171e:	c2 04 00             	ret    $0x4

00801721 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	ff 75 10             	pushl  0x10(%ebp)
  80172b:	ff 75 0c             	pushl  0xc(%ebp)
  80172e:	ff 75 08             	pushl  0x8(%ebp)
  801731:	6a 13                	push   $0x13
  801733:	e8 7e fc ff ff       	call   8013b6 <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
	return ;
  80173b:	90                   	nop
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_rcr2>:
uint32 sys_rcr2()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 1e                	push   $0x1e
  80174d:	e8 64 fc ff ff       	call   8013b6 <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 04             	sub    $0x4,%esp
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801763:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	50                   	push   %eax
  801770:	6a 1f                	push   $0x1f
  801772:	e8 3f fc ff ff       	call   8013b6 <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
	return ;
  80177a:	90                   	nop
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <rsttst>:
void rsttst()
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 21                	push   $0x21
  80178c:	e8 25 fc ff ff       	call   8013b6 <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
	return ;
  801794:	90                   	nop
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017a3:	8b 55 18             	mov    0x18(%ebp),%edx
  8017a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017aa:	52                   	push   %edx
  8017ab:	50                   	push   %eax
  8017ac:	ff 75 10             	pushl  0x10(%ebp)
  8017af:	ff 75 0c             	pushl  0xc(%ebp)
  8017b2:	ff 75 08             	pushl  0x8(%ebp)
  8017b5:	6a 20                	push   $0x20
  8017b7:	e8 fa fb ff ff       	call   8013b6 <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bf:	90                   	nop
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <chktst>:
void chktst(uint32 n)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	6a 22                	push   $0x22
  8017d2:	e8 df fb ff ff       	call   8013b6 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017da:	90                   	nop
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <inctst>:

void inctst()
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 23                	push   $0x23
  8017ec:	e8 c5 fb ff ff       	call   8013b6 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f4:	90                   	nop
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <gettst>:
uint32 gettst()
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 24                	push   $0x24
  801806:	e8 ab fb ff ff       	call   8013b6 <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 25                	push   $0x25
  801822:	e8 8f fb ff ff       	call   8013b6 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
  80182a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80182d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801831:	75 07                	jne    80183a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801833:	b8 01 00 00 00       	mov    $0x1,%eax
  801838:	eb 05                	jmp    80183f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80183a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 25                	push   $0x25
  801853:	e8 5e fb ff ff       	call   8013b6 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
  80185b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80185e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801862:	75 07                	jne    80186b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801864:	b8 01 00 00 00       	mov    $0x1,%eax
  801869:	eb 05                	jmp    801870 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80186b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 25                	push   $0x25
  801884:	e8 2d fb ff ff       	call   8013b6 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
  80188c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80188f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801893:	75 07                	jne    80189c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801895:	b8 01 00 00 00       	mov    $0x1,%eax
  80189a:	eb 05                	jmp    8018a1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80189c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 25                	push   $0x25
  8018b5:	e8 fc fa ff ff       	call   8013b6 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
  8018bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018c0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018c4:	75 07                	jne    8018cd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018cb:	eb 05                	jmp    8018d2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	ff 75 08             	pushl  0x8(%ebp)
  8018e2:	6a 26                	push   $0x26
  8018e4:	e8 cd fa ff ff       	call   8013b6 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ec:	90                   	nop
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	6a 00                	push   $0x0
  801901:	53                   	push   %ebx
  801902:	51                   	push   %ecx
  801903:	52                   	push   %edx
  801904:	50                   	push   %eax
  801905:	6a 27                	push   $0x27
  801907:	e8 aa fa ff ff       	call   8013b6 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	52                   	push   %edx
  801924:	50                   	push   %eax
  801925:	6a 28                	push   $0x28
  801927:	e8 8a fa ff ff       	call   8013b6 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801934:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	51                   	push   %ecx
  801940:	ff 75 10             	pushl  0x10(%ebp)
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	6a 29                	push   $0x29
  801947:	e8 6a fa ff ff       	call   8013b6 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	ff 75 10             	pushl  0x10(%ebp)
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	ff 75 08             	pushl  0x8(%ebp)
  801961:	6a 12                	push   $0x12
  801963:	e8 4e fa ff ff       	call   8013b6 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
	return ;
  80196b:	90                   	nop
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801971:	8b 55 0c             	mov    0xc(%ebp),%edx
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	52                   	push   %edx
  80197e:	50                   	push   %eax
  80197f:	6a 2a                	push   $0x2a
  801981:	e8 30 fa ff ff       	call   8013b6 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
	return;
  801989:	90                   	nop
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	50                   	push   %eax
  80199b:	6a 2b                	push   $0x2b
  80199d:	e8 14 fa ff ff       	call   8013b6 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	ff 75 08             	pushl  0x8(%ebp)
  8019b6:	6a 2c                	push   $0x2c
  8019b8:	e8 f9 f9 ff ff       	call   8013b6 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
	return;
  8019c0:	90                   	nop
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	6a 2d                	push   $0x2d
  8019d4:	e8 dd f9 ff ff       	call   8013b6 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
	return;
  8019dc:	90                   	nop
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    
  8019df:	90                   	nop

008019e0 <__udivdi3>:
  8019e0:	55                   	push   %ebp
  8019e1:	57                   	push   %edi
  8019e2:	56                   	push   %esi
  8019e3:	53                   	push   %ebx
  8019e4:	83 ec 1c             	sub    $0x1c,%esp
  8019e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019f7:	89 ca                	mov    %ecx,%edx
  8019f9:	89 f8                	mov    %edi,%eax
  8019fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019ff:	85 f6                	test   %esi,%esi
  801a01:	75 2d                	jne    801a30 <__udivdi3+0x50>
  801a03:	39 cf                	cmp    %ecx,%edi
  801a05:	77 65                	ja     801a6c <__udivdi3+0x8c>
  801a07:	89 fd                	mov    %edi,%ebp
  801a09:	85 ff                	test   %edi,%edi
  801a0b:	75 0b                	jne    801a18 <__udivdi3+0x38>
  801a0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a12:	31 d2                	xor    %edx,%edx
  801a14:	f7 f7                	div    %edi
  801a16:	89 c5                	mov    %eax,%ebp
  801a18:	31 d2                	xor    %edx,%edx
  801a1a:	89 c8                	mov    %ecx,%eax
  801a1c:	f7 f5                	div    %ebp
  801a1e:	89 c1                	mov    %eax,%ecx
  801a20:	89 d8                	mov    %ebx,%eax
  801a22:	f7 f5                	div    %ebp
  801a24:	89 cf                	mov    %ecx,%edi
  801a26:	89 fa                	mov    %edi,%edx
  801a28:	83 c4 1c             	add    $0x1c,%esp
  801a2b:	5b                   	pop    %ebx
  801a2c:	5e                   	pop    %esi
  801a2d:	5f                   	pop    %edi
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    
  801a30:	39 ce                	cmp    %ecx,%esi
  801a32:	77 28                	ja     801a5c <__udivdi3+0x7c>
  801a34:	0f bd fe             	bsr    %esi,%edi
  801a37:	83 f7 1f             	xor    $0x1f,%edi
  801a3a:	75 40                	jne    801a7c <__udivdi3+0x9c>
  801a3c:	39 ce                	cmp    %ecx,%esi
  801a3e:	72 0a                	jb     801a4a <__udivdi3+0x6a>
  801a40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a44:	0f 87 9e 00 00 00    	ja     801ae8 <__udivdi3+0x108>
  801a4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4f:	89 fa                	mov    %edi,%edx
  801a51:	83 c4 1c             	add    $0x1c,%esp
  801a54:	5b                   	pop    %ebx
  801a55:	5e                   	pop    %esi
  801a56:	5f                   	pop    %edi
  801a57:	5d                   	pop    %ebp
  801a58:	c3                   	ret    
  801a59:	8d 76 00             	lea    0x0(%esi),%esi
  801a5c:	31 ff                	xor    %edi,%edi
  801a5e:	31 c0                	xor    %eax,%eax
  801a60:	89 fa                	mov    %edi,%edx
  801a62:	83 c4 1c             	add    $0x1c,%esp
  801a65:	5b                   	pop    %ebx
  801a66:	5e                   	pop    %esi
  801a67:	5f                   	pop    %edi
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    
  801a6a:	66 90                	xchg   %ax,%ax
  801a6c:	89 d8                	mov    %ebx,%eax
  801a6e:	f7 f7                	div    %edi
  801a70:	31 ff                	xor    %edi,%edi
  801a72:	89 fa                	mov    %edi,%edx
  801a74:	83 c4 1c             	add    $0x1c,%esp
  801a77:	5b                   	pop    %ebx
  801a78:	5e                   	pop    %esi
  801a79:	5f                   	pop    %edi
  801a7a:	5d                   	pop    %ebp
  801a7b:	c3                   	ret    
  801a7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a81:	89 eb                	mov    %ebp,%ebx
  801a83:	29 fb                	sub    %edi,%ebx
  801a85:	89 f9                	mov    %edi,%ecx
  801a87:	d3 e6                	shl    %cl,%esi
  801a89:	89 c5                	mov    %eax,%ebp
  801a8b:	88 d9                	mov    %bl,%cl
  801a8d:	d3 ed                	shr    %cl,%ebp
  801a8f:	89 e9                	mov    %ebp,%ecx
  801a91:	09 f1                	or     %esi,%ecx
  801a93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a97:	89 f9                	mov    %edi,%ecx
  801a99:	d3 e0                	shl    %cl,%eax
  801a9b:	89 c5                	mov    %eax,%ebp
  801a9d:	89 d6                	mov    %edx,%esi
  801a9f:	88 d9                	mov    %bl,%cl
  801aa1:	d3 ee                	shr    %cl,%esi
  801aa3:	89 f9                	mov    %edi,%ecx
  801aa5:	d3 e2                	shl    %cl,%edx
  801aa7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aab:	88 d9                	mov    %bl,%cl
  801aad:	d3 e8                	shr    %cl,%eax
  801aaf:	09 c2                	or     %eax,%edx
  801ab1:	89 d0                	mov    %edx,%eax
  801ab3:	89 f2                	mov    %esi,%edx
  801ab5:	f7 74 24 0c          	divl   0xc(%esp)
  801ab9:	89 d6                	mov    %edx,%esi
  801abb:	89 c3                	mov    %eax,%ebx
  801abd:	f7 e5                	mul    %ebp
  801abf:	39 d6                	cmp    %edx,%esi
  801ac1:	72 19                	jb     801adc <__udivdi3+0xfc>
  801ac3:	74 0b                	je     801ad0 <__udivdi3+0xf0>
  801ac5:	89 d8                	mov    %ebx,%eax
  801ac7:	31 ff                	xor    %edi,%edi
  801ac9:	e9 58 ff ff ff       	jmp    801a26 <__udivdi3+0x46>
  801ace:	66 90                	xchg   %ax,%ax
  801ad0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ad4:	89 f9                	mov    %edi,%ecx
  801ad6:	d3 e2                	shl    %cl,%edx
  801ad8:	39 c2                	cmp    %eax,%edx
  801ada:	73 e9                	jae    801ac5 <__udivdi3+0xe5>
  801adc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801adf:	31 ff                	xor    %edi,%edi
  801ae1:	e9 40 ff ff ff       	jmp    801a26 <__udivdi3+0x46>
  801ae6:	66 90                	xchg   %ax,%ax
  801ae8:	31 c0                	xor    %eax,%eax
  801aea:	e9 37 ff ff ff       	jmp    801a26 <__udivdi3+0x46>
  801aef:	90                   	nop

00801af0 <__umoddi3>:
  801af0:	55                   	push   %ebp
  801af1:	57                   	push   %edi
  801af2:	56                   	push   %esi
  801af3:	53                   	push   %ebx
  801af4:	83 ec 1c             	sub    $0x1c,%esp
  801af7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801afb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801aff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b03:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b0f:	89 f3                	mov    %esi,%ebx
  801b11:	89 fa                	mov    %edi,%edx
  801b13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b17:	89 34 24             	mov    %esi,(%esp)
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	75 1a                	jne    801b38 <__umoddi3+0x48>
  801b1e:	39 f7                	cmp    %esi,%edi
  801b20:	0f 86 a2 00 00 00    	jbe    801bc8 <__umoddi3+0xd8>
  801b26:	89 c8                	mov    %ecx,%eax
  801b28:	89 f2                	mov    %esi,%edx
  801b2a:	f7 f7                	div    %edi
  801b2c:	89 d0                	mov    %edx,%eax
  801b2e:	31 d2                	xor    %edx,%edx
  801b30:	83 c4 1c             	add    $0x1c,%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5e                   	pop    %esi
  801b35:	5f                   	pop    %edi
  801b36:	5d                   	pop    %ebp
  801b37:	c3                   	ret    
  801b38:	39 f0                	cmp    %esi,%eax
  801b3a:	0f 87 ac 00 00 00    	ja     801bec <__umoddi3+0xfc>
  801b40:	0f bd e8             	bsr    %eax,%ebp
  801b43:	83 f5 1f             	xor    $0x1f,%ebp
  801b46:	0f 84 ac 00 00 00    	je     801bf8 <__umoddi3+0x108>
  801b4c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b51:	29 ef                	sub    %ebp,%edi
  801b53:	89 fe                	mov    %edi,%esi
  801b55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b59:	89 e9                	mov    %ebp,%ecx
  801b5b:	d3 e0                	shl    %cl,%eax
  801b5d:	89 d7                	mov    %edx,%edi
  801b5f:	89 f1                	mov    %esi,%ecx
  801b61:	d3 ef                	shr    %cl,%edi
  801b63:	09 c7                	or     %eax,%edi
  801b65:	89 e9                	mov    %ebp,%ecx
  801b67:	d3 e2                	shl    %cl,%edx
  801b69:	89 14 24             	mov    %edx,(%esp)
  801b6c:	89 d8                	mov    %ebx,%eax
  801b6e:	d3 e0                	shl    %cl,%eax
  801b70:	89 c2                	mov    %eax,%edx
  801b72:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b76:	d3 e0                	shl    %cl,%eax
  801b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b80:	89 f1                	mov    %esi,%ecx
  801b82:	d3 e8                	shr    %cl,%eax
  801b84:	09 d0                	or     %edx,%eax
  801b86:	d3 eb                	shr    %cl,%ebx
  801b88:	89 da                	mov    %ebx,%edx
  801b8a:	f7 f7                	div    %edi
  801b8c:	89 d3                	mov    %edx,%ebx
  801b8e:	f7 24 24             	mull   (%esp)
  801b91:	89 c6                	mov    %eax,%esi
  801b93:	89 d1                	mov    %edx,%ecx
  801b95:	39 d3                	cmp    %edx,%ebx
  801b97:	0f 82 87 00 00 00    	jb     801c24 <__umoddi3+0x134>
  801b9d:	0f 84 91 00 00 00    	je     801c34 <__umoddi3+0x144>
  801ba3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ba7:	29 f2                	sub    %esi,%edx
  801ba9:	19 cb                	sbb    %ecx,%ebx
  801bab:	89 d8                	mov    %ebx,%eax
  801bad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bb1:	d3 e0                	shl    %cl,%eax
  801bb3:	89 e9                	mov    %ebp,%ecx
  801bb5:	d3 ea                	shr    %cl,%edx
  801bb7:	09 d0                	or     %edx,%eax
  801bb9:	89 e9                	mov    %ebp,%ecx
  801bbb:	d3 eb                	shr    %cl,%ebx
  801bbd:	89 da                	mov    %ebx,%edx
  801bbf:	83 c4 1c             	add    $0x1c,%esp
  801bc2:	5b                   	pop    %ebx
  801bc3:	5e                   	pop    %esi
  801bc4:	5f                   	pop    %edi
  801bc5:	5d                   	pop    %ebp
  801bc6:	c3                   	ret    
  801bc7:	90                   	nop
  801bc8:	89 fd                	mov    %edi,%ebp
  801bca:	85 ff                	test   %edi,%edi
  801bcc:	75 0b                	jne    801bd9 <__umoddi3+0xe9>
  801bce:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd3:	31 d2                	xor    %edx,%edx
  801bd5:	f7 f7                	div    %edi
  801bd7:	89 c5                	mov    %eax,%ebp
  801bd9:	89 f0                	mov    %esi,%eax
  801bdb:	31 d2                	xor    %edx,%edx
  801bdd:	f7 f5                	div    %ebp
  801bdf:	89 c8                	mov    %ecx,%eax
  801be1:	f7 f5                	div    %ebp
  801be3:	89 d0                	mov    %edx,%eax
  801be5:	e9 44 ff ff ff       	jmp    801b2e <__umoddi3+0x3e>
  801bea:	66 90                	xchg   %ax,%ax
  801bec:	89 c8                	mov    %ecx,%eax
  801bee:	89 f2                	mov    %esi,%edx
  801bf0:	83 c4 1c             	add    $0x1c,%esp
  801bf3:	5b                   	pop    %ebx
  801bf4:	5e                   	pop    %esi
  801bf5:	5f                   	pop    %edi
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    
  801bf8:	3b 04 24             	cmp    (%esp),%eax
  801bfb:	72 06                	jb     801c03 <__umoddi3+0x113>
  801bfd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c01:	77 0f                	ja     801c12 <__umoddi3+0x122>
  801c03:	89 f2                	mov    %esi,%edx
  801c05:	29 f9                	sub    %edi,%ecx
  801c07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c0b:	89 14 24             	mov    %edx,(%esp)
  801c0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c12:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c16:	8b 14 24             	mov    (%esp),%edx
  801c19:	83 c4 1c             	add    $0x1c,%esp
  801c1c:	5b                   	pop    %ebx
  801c1d:	5e                   	pop    %esi
  801c1e:	5f                   	pop    %edi
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    
  801c21:	8d 76 00             	lea    0x0(%esi),%esi
  801c24:	2b 04 24             	sub    (%esp),%eax
  801c27:	19 fa                	sbb    %edi,%edx
  801c29:	89 d1                	mov    %edx,%ecx
  801c2b:	89 c6                	mov    %eax,%esi
  801c2d:	e9 71 ff ff ff       	jmp    801ba3 <__umoddi3+0xb3>
  801c32:	66 90                	xchg   %ax,%ax
  801c34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c38:	72 ea                	jb     801c24 <__umoddi3+0x134>
  801c3a:	89 d9                	mov    %ebx,%ecx
  801c3c:	e9 62 ff ff ff       	jmp    801ba3 <__umoddi3+0xb3>
