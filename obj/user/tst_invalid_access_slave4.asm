
obj/user/tst_invalid_access_slave4:     file format elf32-i386


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
  800031:	e8 5c 00 00 00       	call   800092 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//[4] Not in Page File, Not Stack & Not Heap
	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	{
		uint32 size = 4*kilo;
  800045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800048:	c1 e0 02             	shl    $0x2,%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);
  80004e:	c7 45 e8 00 f0 1f 00 	movl   $0x1ff000,-0x18(%ebp)

		int i=0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  80005c:	eb 0e                	jmp    80006c <_main+0x34>
		{
			x[i]=-1;
  80005e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	c6 00 ff             	movb   $0xff,(%eax)
		uint32 size = 4*kilo;

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);

		int i=0;
		for(;i< size+20;i++)
  800069:	ff 45 f4             	incl   -0xc(%ebp)
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8d 50 14             	lea    0x14(%eax),%edx
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	39 c2                	cmp    %eax,%edx
  800077:	77 e5                	ja     80005e <_main+0x26>
		{
			x[i]=-1;
		}
	}

	inctst();
  800079:	e8 df 15 00 00       	call   80165d <inctst>
	panic("tst invalid access failed: Attempt to access page that's not exist in page file, neither stack or heap.\nThe env must be killed and shouldn't return here.");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 e0 1a 80 00       	push   $0x801ae0
  800086:	6a 18                	push   $0x18
  800088:	68 7c 1b 80 00       	push   $0x801b7c
  80008d:	e8 4d 01 00 00       	call   8001df <_panic>

00800092 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800098:	e8 82 14 00 00       	call   80151f <sys_getenvindex>
  80009d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a3:	89 d0                	mov    %edx,%eax
  8000a5:	c1 e0 06             	shl    $0x6,%eax
  8000a8:	29 d0                	sub    %edx,%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	01 d0                	add    %edx,%eax
  8000af:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000b6:	01 c8                	add    %ecx,%eax
  8000b8:	c1 e0 03             	shl    $0x3,%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000c4:	29 c2                	sub    %eax,%edx
  8000c6:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000cd:	89 c2                	mov    %eax,%edx
  8000cf:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000d5:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000da:	a1 04 30 80 00       	mov    0x803004,%eax
  8000df:	8a 40 20             	mov    0x20(%eax),%al
  8000e2:	84 c0                	test   %al,%al
  8000e4:	74 0d                	je     8000f3 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8000e6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000eb:	83 c0 20             	add    $0x20,%eax
  8000ee:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000f7:	7e 0a                	jle    800103 <libmain+0x71>
		binaryname = argv[0];
  8000f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000fc:	8b 00                	mov    (%eax),%eax
  8000fe:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	ff 75 0c             	pushl  0xc(%ebp)
  800109:	ff 75 08             	pushl  0x8(%ebp)
  80010c:	e8 27 ff ff ff       	call   800038 <_main>
  800111:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800114:	e8 8a 11 00 00       	call   8012a3 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 b8 1b 80 00       	push   $0x801bb8
  800121:	e8 76 03 00 00       	call   80049c <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800129:	a1 04 30 80 00       	mov    0x803004,%eax
  80012e:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800134:	a1 04 30 80 00       	mov    0x803004,%eax
  800139:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	52                   	push   %edx
  800143:	50                   	push   %eax
  800144:	68 e0 1b 80 00       	push   $0x801be0
  800149:	e8 4e 03 00 00       	call   80049c <cprintf>
  80014e:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800151:	a1 04 30 80 00       	mov    0x803004,%eax
  800156:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80015c:	a1 04 30 80 00       	mov    0x803004,%eax
  800161:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800167:	a1 04 30 80 00       	mov    0x803004,%eax
  80016c:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800172:	51                   	push   %ecx
  800173:	52                   	push   %edx
  800174:	50                   	push   %eax
  800175:	68 08 1c 80 00       	push   $0x801c08
  80017a:	e8 1d 03 00 00       	call   80049c <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800182:	a1 04 30 80 00       	mov    0x803004,%eax
  800187:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	50                   	push   %eax
  800191:	68 60 1c 80 00       	push   $0x801c60
  800196:	e8 01 03 00 00       	call   80049c <cprintf>
  80019b:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	68 b8 1b 80 00       	push   $0x801bb8
  8001a6:	e8 f1 02 00 00       	call   80049c <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001ae:	e8 0a 11 00 00       	call   8012bd <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001b3:	e8 19 00 00 00       	call   8001d1 <exit>
}
  8001b8:	90                   	nop
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001c1:	83 ec 0c             	sub    $0xc,%esp
  8001c4:	6a 00                	push   $0x0
  8001c6:	e8 20 13 00 00       	call   8014eb <sys_destroy_env>
  8001cb:	83 c4 10             	add    $0x10,%esp
}
  8001ce:	90                   	nop
  8001cf:	c9                   	leave  
  8001d0:	c3                   	ret    

008001d1 <exit>:

void
exit(void)
{
  8001d1:	55                   	push   %ebp
  8001d2:	89 e5                	mov    %esp,%ebp
  8001d4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001d7:	e8 75 13 00 00       	call   801551 <sys_exit_env>
}
  8001dc:	90                   	nop
  8001dd:	c9                   	leave  
  8001de:	c3                   	ret    

008001df <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001e5:	8d 45 10             	lea    0x10(%ebp),%eax
  8001e8:	83 c0 04             	add    $0x4,%eax
  8001eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001ee:	a1 24 30 80 00       	mov    0x803024,%eax
  8001f3:	85 c0                	test   %eax,%eax
  8001f5:	74 16                	je     80020d <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001f7:	a1 24 30 80 00       	mov    0x803024,%eax
  8001fc:	83 ec 08             	sub    $0x8,%esp
  8001ff:	50                   	push   %eax
  800200:	68 74 1c 80 00       	push   $0x801c74
  800205:	e8 92 02 00 00       	call   80049c <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80020d:	a1 00 30 80 00       	mov    0x803000,%eax
  800212:	ff 75 0c             	pushl  0xc(%ebp)
  800215:	ff 75 08             	pushl  0x8(%ebp)
  800218:	50                   	push   %eax
  800219:	68 79 1c 80 00       	push   $0x801c79
  80021e:	e8 79 02 00 00       	call   80049c <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800226:	8b 45 10             	mov    0x10(%ebp),%eax
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	ff 75 f4             	pushl  -0xc(%ebp)
  80022f:	50                   	push   %eax
  800230:	e8 fc 01 00 00       	call   800431 <vcprintf>
  800235:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800238:	83 ec 08             	sub    $0x8,%esp
  80023b:	6a 00                	push   $0x0
  80023d:	68 95 1c 80 00       	push   $0x801c95
  800242:	e8 ea 01 00 00       	call   800431 <vcprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80024a:	e8 82 ff ff ff       	call   8001d1 <exit>

	// should not return here
	while (1) ;
  80024f:	eb fe                	jmp    80024f <_panic+0x70>

00800251 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800257:	a1 04 30 80 00       	mov    0x803004,%eax
  80025c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800262:	8b 45 0c             	mov    0xc(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 98 1c 80 00       	push   $0x801c98
  800271:	6a 26                	push   $0x26
  800273:	68 e4 1c 80 00       	push   $0x801ce4
  800278:	e8 62 ff ff ff       	call   8001df <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800284:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80028b:	e9 c5 00 00 00       	jmp    800355 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800293:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80029a:	8b 45 08             	mov    0x8(%ebp),%eax
  80029d:	01 d0                	add    %edx,%eax
  80029f:	8b 00                	mov    (%eax),%eax
  8002a1:	85 c0                	test   %eax,%eax
  8002a3:	75 08                	jne    8002ad <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002a5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002a8:	e9 a5 00 00 00       	jmp    800352 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002b4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002bb:	eb 69                	jmp    800326 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002bd:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8002c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002cb:	89 d0                	mov    %edx,%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	01 d0                	add    %edx,%eax
  8002d1:	c1 e0 03             	shl    $0x3,%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8a 40 04             	mov    0x4(%eax),%al
  8002d9:	84 c0                	test   %al,%al
  8002db:	75 46                	jne    800323 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002dd:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8002e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002eb:	89 d0                	mov    %edx,%eax
  8002ed:	01 c0                	add    %eax,%eax
  8002ef:	01 d0                	add    %edx,%eax
  8002f1:	c1 e0 03             	shl    $0x3,%eax
  8002f4:	01 c8                	add    %ecx,%eax
  8002f6:	8b 00                	mov    (%eax),%eax
  8002f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800303:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800308:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80030f:	8b 45 08             	mov    0x8(%ebp),%eax
  800312:	01 c8                	add    %ecx,%eax
  800314:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800316:	39 c2                	cmp    %eax,%edx
  800318:	75 09                	jne    800323 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80031a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800321:	eb 15                	jmp    800338 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800323:	ff 45 e8             	incl   -0x18(%ebp)
  800326:	a1 04 30 80 00       	mov    0x803004,%eax
  80032b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800334:	39 c2                	cmp    %eax,%edx
  800336:	77 85                	ja     8002bd <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800338:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80033c:	75 14                	jne    800352 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 f0 1c 80 00       	push   $0x801cf0
  800346:	6a 3a                	push   $0x3a
  800348:	68 e4 1c 80 00       	push   $0x801ce4
  80034d:	e8 8d fe ff ff       	call   8001df <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800352:	ff 45 f0             	incl   -0x10(%ebp)
  800355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800358:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80035b:	0f 8c 2f ff ff ff    	jl     800290 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800361:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800368:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80036f:	eb 26                	jmp    800397 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800371:	a1 04 30 80 00       	mov    0x803004,%eax
  800376:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80037c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80037f:	89 d0                	mov    %edx,%eax
  800381:	01 c0                	add    %eax,%eax
  800383:	01 d0                	add    %edx,%eax
  800385:	c1 e0 03             	shl    $0x3,%eax
  800388:	01 c8                	add    %ecx,%eax
  80038a:	8a 40 04             	mov    0x4(%eax),%al
  80038d:	3c 01                	cmp    $0x1,%al
  80038f:	75 03                	jne    800394 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800391:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800394:	ff 45 e0             	incl   -0x20(%ebp)
  800397:	a1 04 30 80 00       	mov    0x803004,%eax
  80039c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	77 c8                	ja     800371 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ac:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003af:	74 14                	je     8003c5 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003b1:	83 ec 04             	sub    $0x4,%esp
  8003b4:	68 44 1d 80 00       	push   $0x801d44
  8003b9:	6a 44                	push   $0x44
  8003bb:	68 e4 1c 80 00       	push   $0x801ce4
  8003c0:	e8 1a fe ff ff       	call   8001df <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003c5:	90                   	nop
  8003c6:	c9                   	leave  
  8003c7:	c3                   	ret    

008003c8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	8d 48 01             	lea    0x1(%eax),%ecx
  8003d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d9:	89 0a                	mov    %ecx,(%edx)
  8003db:	8b 55 08             	mov    0x8(%ebp),%edx
  8003de:	88 d1                	mov    %dl,%cl
  8003e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003e3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ea:	8b 00                	mov    (%eax),%eax
  8003ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003f1:	75 2c                	jne    80041f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003f3:	a0 08 30 80 00       	mov    0x803008,%al
  8003f8:	0f b6 c0             	movzbl %al,%eax
  8003fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003fe:	8b 12                	mov    (%edx),%edx
  800400:	89 d1                	mov    %edx,%ecx
  800402:	8b 55 0c             	mov    0xc(%ebp),%edx
  800405:	83 c2 08             	add    $0x8,%edx
  800408:	83 ec 04             	sub    $0x4,%esp
  80040b:	50                   	push   %eax
  80040c:	51                   	push   %ecx
  80040d:	52                   	push   %edx
  80040e:	e8 4e 0e 00 00       	call   801261 <sys_cputs>
  800413:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800416:	8b 45 0c             	mov    0xc(%ebp),%eax
  800419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8b 40 04             	mov    0x4(%eax),%eax
  800425:	8d 50 01             	lea    0x1(%eax),%edx
  800428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80042e:	90                   	nop
  80042f:	c9                   	leave  
  800430:	c3                   	ret    

00800431 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80043a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800441:	00 00 00 
	b.cnt = 0;
  800444:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80044b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80044e:	ff 75 0c             	pushl  0xc(%ebp)
  800451:	ff 75 08             	pushl  0x8(%ebp)
  800454:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80045a:	50                   	push   %eax
  80045b:	68 c8 03 80 00       	push   $0x8003c8
  800460:	e8 11 02 00 00       	call   800676 <vprintfmt>
  800465:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800468:	a0 08 30 80 00       	mov    0x803008,%al
  80046d:	0f b6 c0             	movzbl %al,%eax
  800470:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	50                   	push   %eax
  80047a:	52                   	push   %edx
  80047b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800481:	83 c0 08             	add    $0x8,%eax
  800484:	50                   	push   %eax
  800485:	e8 d7 0d 00 00       	call   801261 <sys_cputs>
  80048a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80048d:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800494:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80049a:	c9                   	leave  
  80049b:	c3                   	ret    

0080049c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004a2:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8004a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b8:	50                   	push   %eax
  8004b9:	e8 73 ff ff ff       	call   800431 <vcprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004cf:	e8 cf 0d 00 00       	call   8012a3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e3:	50                   	push   %eax
  8004e4:	e8 48 ff ff ff       	call   800431 <vcprintf>
  8004e9:	83 c4 10             	add    $0x10,%esp
  8004ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004ef:	e8 c9 0d 00 00       	call   8012bd <sys_unlock_cons>
	return cnt;
  8004f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004f7:	c9                   	leave  
  8004f8:	c3                   	ret    

008004f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	53                   	push   %ebx
  8004fd:	83 ec 14             	sub    $0x14,%esp
  800500:	8b 45 10             	mov    0x10(%ebp),%eax
  800503:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80050c:	8b 45 18             	mov    0x18(%ebp),%eax
  80050f:	ba 00 00 00 00       	mov    $0x0,%edx
  800514:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800517:	77 55                	ja     80056e <printnum+0x75>
  800519:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80051c:	72 05                	jb     800523 <printnum+0x2a>
  80051e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800521:	77 4b                	ja     80056e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800523:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800526:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800529:	8b 45 18             	mov    0x18(%ebp),%eax
  80052c:	ba 00 00 00 00       	mov    $0x0,%edx
  800531:	52                   	push   %edx
  800532:	50                   	push   %eax
  800533:	ff 75 f4             	pushl  -0xc(%ebp)
  800536:	ff 75 f0             	pushl  -0x10(%ebp)
  800539:	e8 26 13 00 00       	call   801864 <__udivdi3>
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	83 ec 04             	sub    $0x4,%esp
  800544:	ff 75 20             	pushl  0x20(%ebp)
  800547:	53                   	push   %ebx
  800548:	ff 75 18             	pushl  0x18(%ebp)
  80054b:	52                   	push   %edx
  80054c:	50                   	push   %eax
  80054d:	ff 75 0c             	pushl  0xc(%ebp)
  800550:	ff 75 08             	pushl  0x8(%ebp)
  800553:	e8 a1 ff ff ff       	call   8004f9 <printnum>
  800558:	83 c4 20             	add    $0x20,%esp
  80055b:	eb 1a                	jmp    800577 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	ff 75 0c             	pushl  0xc(%ebp)
  800563:	ff 75 20             	pushl  0x20(%ebp)
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	ff d0                	call   *%eax
  80056b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80056e:	ff 4d 1c             	decl   0x1c(%ebp)
  800571:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800575:	7f e6                	jg     80055d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800577:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80057a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80057f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800582:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800585:	53                   	push   %ebx
  800586:	51                   	push   %ecx
  800587:	52                   	push   %edx
  800588:	50                   	push   %eax
  800589:	e8 e6 13 00 00       	call   801974 <__umoddi3>
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	05 b4 1f 80 00       	add    $0x801fb4,%eax
  800596:	8a 00                	mov    (%eax),%al
  800598:	0f be c0             	movsbl %al,%eax
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 0c             	pushl  0xc(%ebp)
  8005a1:	50                   	push   %eax
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	ff d0                	call   *%eax
  8005a7:	83 c4 10             	add    $0x10,%esp
}
  8005aa:	90                   	nop
  8005ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005ae:	c9                   	leave  
  8005af:	c3                   	ret    

008005b0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005b7:	7e 1c                	jle    8005d5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bc:	8b 00                	mov    (%eax),%eax
  8005be:	8d 50 08             	lea    0x8(%eax),%edx
  8005c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c4:	89 10                	mov    %edx,(%eax)
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	83 e8 08             	sub    $0x8,%eax
  8005ce:	8b 50 04             	mov    0x4(%eax),%edx
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	eb 40                	jmp    800615 <getuint+0x65>
	else if (lflag)
  8005d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005d9:	74 1e                	je     8005f9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	8d 50 04             	lea    0x4(%eax),%edx
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	89 10                	mov    %edx,(%eax)
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	83 e8 04             	sub    $0x4,%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f7:	eb 1c                	jmp    800615 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	8d 50 04             	lea    0x4(%eax),%edx
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	89 10                	mov    %edx,(%eax)
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	83 e8 04             	sub    $0x4,%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800615:	5d                   	pop    %ebp
  800616:	c3                   	ret    

00800617 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800617:	55                   	push   %ebp
  800618:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80061a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80061e:	7e 1c                	jle    80063c <getint+0x25>
		return va_arg(*ap, long long);
  800620:	8b 45 08             	mov    0x8(%ebp),%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	8d 50 08             	lea    0x8(%eax),%edx
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	89 10                	mov    %edx,(%eax)
  80062d:	8b 45 08             	mov    0x8(%ebp),%eax
  800630:	8b 00                	mov    (%eax),%eax
  800632:	83 e8 08             	sub    $0x8,%eax
  800635:	8b 50 04             	mov    0x4(%eax),%edx
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	eb 38                	jmp    800674 <getint+0x5d>
	else if (lflag)
  80063c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800640:	74 1a                	je     80065c <getint+0x45>
		return va_arg(*ap, long);
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	8d 50 04             	lea    0x4(%eax),%edx
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	89 10                	mov    %edx,(%eax)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	83 e8 04             	sub    $0x4,%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	99                   	cltd   
  80065a:	eb 18                	jmp    800674 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	8d 50 04             	lea    0x4(%eax),%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	89 10                	mov    %edx,(%eax)
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	83 e8 04             	sub    $0x4,%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	99                   	cltd   
}
  800674:	5d                   	pop    %ebp
  800675:	c3                   	ret    

00800676 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800676:	55                   	push   %ebp
  800677:	89 e5                	mov    %esp,%ebp
  800679:	56                   	push   %esi
  80067a:	53                   	push   %ebx
  80067b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80067e:	eb 17                	jmp    800697 <vprintfmt+0x21>
			if (ch == '\0')
  800680:	85 db                	test   %ebx,%ebx
  800682:	0f 84 c1 03 00 00    	je     800a49 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	53                   	push   %ebx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	ff d0                	call   *%eax
  800694:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800697:	8b 45 10             	mov    0x10(%ebp),%eax
  80069a:	8d 50 01             	lea    0x1(%eax),%edx
  80069d:	89 55 10             	mov    %edx,0x10(%ebp)
  8006a0:	8a 00                	mov    (%eax),%al
  8006a2:	0f b6 d8             	movzbl %al,%ebx
  8006a5:	83 fb 25             	cmp    $0x25,%ebx
  8006a8:	75 d6                	jne    800680 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006aa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8006cd:	8d 50 01             	lea    0x1(%eax),%edx
  8006d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8006d3:	8a 00                	mov    (%eax),%al
  8006d5:	0f b6 d8             	movzbl %al,%ebx
  8006d8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006db:	83 f8 5b             	cmp    $0x5b,%eax
  8006de:	0f 87 3d 03 00 00    	ja     800a21 <vprintfmt+0x3ab>
  8006e4:	8b 04 85 d8 1f 80 00 	mov    0x801fd8(,%eax,4),%eax
  8006eb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ed:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006f1:	eb d7                	jmp    8006ca <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006f3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006f7:	eb d1                	jmp    8006ca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800700:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800703:	89 d0                	mov    %edx,%eax
  800705:	c1 e0 02             	shl    $0x2,%eax
  800708:	01 d0                	add    %edx,%eax
  80070a:	01 c0                	add    %eax,%eax
  80070c:	01 d8                	add    %ebx,%eax
  80070e:	83 e8 30             	sub    $0x30,%eax
  800711:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800714:	8b 45 10             	mov    0x10(%ebp),%eax
  800717:	8a 00                	mov    (%eax),%al
  800719:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80071c:	83 fb 2f             	cmp    $0x2f,%ebx
  80071f:	7e 3e                	jle    80075f <vprintfmt+0xe9>
  800721:	83 fb 39             	cmp    $0x39,%ebx
  800724:	7f 39                	jg     80075f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800726:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800729:	eb d5                	jmp    800700 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	83 c0 04             	add    $0x4,%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	83 e8 04             	sub    $0x4,%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80073f:	eb 1f                	jmp    800760 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800741:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800745:	79 83                	jns    8006ca <vprintfmt+0x54>
				width = 0;
  800747:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80074e:	e9 77 ff ff ff       	jmp    8006ca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800753:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80075a:	e9 6b ff ff ff       	jmp    8006ca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80075f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800760:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800764:	0f 89 60 ff ff ff    	jns    8006ca <vprintfmt+0x54>
				width = precision, precision = -1;
  80076a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80076d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800770:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800777:	e9 4e ff ff ff       	jmp    8006ca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80077c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80077f:	e9 46 ff ff ff       	jmp    8006ca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	83 c0 04             	add    $0x4,%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	83 e8 04             	sub    $0x4,%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	50                   	push   %eax
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	ff d0                	call   *%eax
  8007a1:	83 c4 10             	add    $0x10,%esp
			break;
  8007a4:	e9 9b 02 00 00       	jmp    800a44 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	83 c0 04             	add    $0x4,%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	83 e8 04             	sub    $0x4,%eax
  8007b8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007ba:	85 db                	test   %ebx,%ebx
  8007bc:	79 02                	jns    8007c0 <vprintfmt+0x14a>
				err = -err;
  8007be:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007c0:	83 fb 64             	cmp    $0x64,%ebx
  8007c3:	7f 0b                	jg     8007d0 <vprintfmt+0x15a>
  8007c5:	8b 34 9d 20 1e 80 00 	mov    0x801e20(,%ebx,4),%esi
  8007cc:	85 f6                	test   %esi,%esi
  8007ce:	75 19                	jne    8007e9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007d0:	53                   	push   %ebx
  8007d1:	68 c5 1f 80 00       	push   $0x801fc5
  8007d6:	ff 75 0c             	pushl  0xc(%ebp)
  8007d9:	ff 75 08             	pushl  0x8(%ebp)
  8007dc:	e8 70 02 00 00       	call   800a51 <printfmt>
  8007e1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007e4:	e9 5b 02 00 00       	jmp    800a44 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007e9:	56                   	push   %esi
  8007ea:	68 ce 1f 80 00       	push   $0x801fce
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	e8 57 02 00 00       	call   800a51 <printfmt>
  8007fa:	83 c4 10             	add    $0x10,%esp
			break;
  8007fd:	e9 42 02 00 00       	jmp    800a44 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 c0 04             	add    $0x4,%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	83 e8 04             	sub    $0x4,%eax
  800811:	8b 30                	mov    (%eax),%esi
  800813:	85 f6                	test   %esi,%esi
  800815:	75 05                	jne    80081c <vprintfmt+0x1a6>
				p = "(null)";
  800817:	be d1 1f 80 00       	mov    $0x801fd1,%esi
			if (width > 0 && padc != '-')
  80081c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800820:	7e 6d                	jle    80088f <vprintfmt+0x219>
  800822:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800826:	74 67                	je     80088f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800828:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	50                   	push   %eax
  80082f:	56                   	push   %esi
  800830:	e8 1e 03 00 00       	call   800b53 <strnlen>
  800835:	83 c4 10             	add    $0x10,%esp
  800838:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80083b:	eb 16                	jmp    800853 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80083d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	50                   	push   %eax
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800850:	ff 4d e4             	decl   -0x1c(%ebp)
  800853:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800857:	7f e4                	jg     80083d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800859:	eb 34                	jmp    80088f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80085b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80085f:	74 1c                	je     80087d <vprintfmt+0x207>
  800861:	83 fb 1f             	cmp    $0x1f,%ebx
  800864:	7e 05                	jle    80086b <vprintfmt+0x1f5>
  800866:	83 fb 7e             	cmp    $0x7e,%ebx
  800869:	7e 12                	jle    80087d <vprintfmt+0x207>
					putch('?', putdat);
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	6a 3f                	push   $0x3f
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	ff d0                	call   *%eax
  800878:	83 c4 10             	add    $0x10,%esp
  80087b:	eb 0f                	jmp    80088c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	53                   	push   %ebx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	ff d0                	call   *%eax
  800889:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80088c:	ff 4d e4             	decl   -0x1c(%ebp)
  80088f:	89 f0                	mov    %esi,%eax
  800891:	8d 70 01             	lea    0x1(%eax),%esi
  800894:	8a 00                	mov    (%eax),%al
  800896:	0f be d8             	movsbl %al,%ebx
  800899:	85 db                	test   %ebx,%ebx
  80089b:	74 24                	je     8008c1 <vprintfmt+0x24b>
  80089d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008a1:	78 b8                	js     80085b <vprintfmt+0x1e5>
  8008a3:	ff 4d e0             	decl   -0x20(%ebp)
  8008a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008aa:	79 af                	jns    80085b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008ac:	eb 13                	jmp    8008c1 <vprintfmt+0x24b>
				putch(' ', putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	6a 20                	push   $0x20
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	ff d0                	call   *%eax
  8008bb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008be:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c5:	7f e7                	jg     8008ae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008c7:	e9 78 01 00 00       	jmp    800a44 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008cc:	83 ec 08             	sub    $0x8,%esp
  8008cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d2:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d5:	50                   	push   %eax
  8008d6:	e8 3c fd ff ff       	call   800617 <getint>
  8008db:	83 c4 10             	add    $0x10,%esp
  8008de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ea:	85 d2                	test   %edx,%edx
  8008ec:	79 23                	jns    800911 <vprintfmt+0x29b>
				putch('-', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	6a 2d                	push   $0x2d
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800901:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800904:	f7 d8                	neg    %eax
  800906:	83 d2 00             	adc    $0x0,%edx
  800909:	f7 da                	neg    %edx
  80090b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80090e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800911:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800918:	e9 bc 00 00 00       	jmp    8009d9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	ff 75 e8             	pushl  -0x18(%ebp)
  800923:	8d 45 14             	lea    0x14(%ebp),%eax
  800926:	50                   	push   %eax
  800927:	e8 84 fc ff ff       	call   8005b0 <getuint>
  80092c:	83 c4 10             	add    $0x10,%esp
  80092f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800932:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800935:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80093c:	e9 98 00 00 00       	jmp    8009d9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800941:	83 ec 08             	sub    $0x8,%esp
  800944:	ff 75 0c             	pushl  0xc(%ebp)
  800947:	6a 58                	push   $0x58
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	6a 58                	push   $0x58
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	6a 58                	push   $0x58
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
			break;
  800971:	e9 ce 00 00 00       	jmp    800a44 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	6a 30                	push   $0x30
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	ff d0                	call   *%eax
  800983:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 0c             	pushl  0xc(%ebp)
  80098c:	6a 78                	push   $0x78
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	ff d0                	call   *%eax
  800993:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800996:	8b 45 14             	mov    0x14(%ebp),%eax
  800999:	83 c0 04             	add    $0x4,%eax
  80099c:	89 45 14             	mov    %eax,0x14(%ebp)
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	83 e8 04             	sub    $0x4,%eax
  8009a5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009b8:	eb 1f                	jmp    8009d9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c3:	50                   	push   %eax
  8009c4:	e8 e7 fb ff ff       	call   8005b0 <getuint>
  8009c9:	83 c4 10             	add    $0x10,%esp
  8009cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009d2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009d9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e0:	83 ec 04             	sub    $0x4,%esp
  8009e3:	52                   	push   %edx
  8009e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009e7:	50                   	push   %eax
  8009e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	ff 75 08             	pushl  0x8(%ebp)
  8009f4:	e8 00 fb ff ff       	call   8004f9 <printnum>
  8009f9:	83 c4 20             	add    $0x20,%esp
			break;
  8009fc:	eb 46                	jmp    800a44 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	53                   	push   %ebx
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	ff d0                	call   *%eax
  800a0a:	83 c4 10             	add    $0x10,%esp
			break;
  800a0d:	eb 35                	jmp    800a44 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a0f:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800a16:	eb 2c                	jmp    800a44 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a18:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800a1f:	eb 23                	jmp    800a44 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a21:	83 ec 08             	sub    $0x8,%esp
  800a24:	ff 75 0c             	pushl  0xc(%ebp)
  800a27:	6a 25                	push   $0x25
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	ff d0                	call   *%eax
  800a2e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a31:	ff 4d 10             	decl   0x10(%ebp)
  800a34:	eb 03                	jmp    800a39 <vprintfmt+0x3c3>
  800a36:	ff 4d 10             	decl   0x10(%ebp)
  800a39:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3c:	48                   	dec    %eax
  800a3d:	8a 00                	mov    (%eax),%al
  800a3f:	3c 25                	cmp    $0x25,%al
  800a41:	75 f3                	jne    800a36 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a43:	90                   	nop
		}
	}
  800a44:	e9 35 fc ff ff       	jmp    80067e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a49:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a4d:	5b                   	pop    %ebx
  800a4e:	5e                   	pop    %esi
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a57:	8d 45 10             	lea    0x10(%ebp),%eax
  800a5a:	83 c0 04             	add    $0x4,%eax
  800a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a60:	8b 45 10             	mov    0x10(%ebp),%eax
  800a63:	ff 75 f4             	pushl  -0xc(%ebp)
  800a66:	50                   	push   %eax
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	ff 75 08             	pushl  0x8(%ebp)
  800a6d:	e8 04 fc ff ff       	call   800676 <vprintfmt>
  800a72:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a75:	90                   	nop
  800a76:	c9                   	leave  
  800a77:	c3                   	ret    

00800a78 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	8b 40 08             	mov    0x8(%eax),%eax
  800a81:	8d 50 01             	lea    0x1(%eax),%edx
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8d:	8b 10                	mov    (%eax),%edx
  800a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a92:	8b 40 04             	mov    0x4(%eax),%eax
  800a95:	39 c2                	cmp    %eax,%edx
  800a97:	73 12                	jae    800aab <sprintputch+0x33>
		*b->buf++ = ch;
  800a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	8d 48 01             	lea    0x1(%eax),%ecx
  800aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa4:	89 0a                	mov    %ecx,(%edx)
  800aa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa9:	88 10                	mov    %dl,(%eax)
}
  800aab:	90                   	nop
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	01 d0                	add    %edx,%eax
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800acf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ad3:	74 06                	je     800adb <vsnprintf+0x2d>
  800ad5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad9:	7f 07                	jg     800ae2 <vsnprintf+0x34>
		return -E_INVAL;
  800adb:	b8 03 00 00 00       	mov    $0x3,%eax
  800ae0:	eb 20                	jmp    800b02 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ae2:	ff 75 14             	pushl  0x14(%ebp)
  800ae5:	ff 75 10             	pushl  0x10(%ebp)
  800ae8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aeb:	50                   	push   %eax
  800aec:	68 78 0a 80 00       	push   $0x800a78
  800af1:	e8 80 fb ff ff       	call   800676 <vprintfmt>
  800af6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800afc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b0a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b0d:	83 c0 04             	add    $0x4,%eax
  800b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b13:	8b 45 10             	mov    0x10(%ebp),%eax
  800b16:	ff 75 f4             	pushl  -0xc(%ebp)
  800b19:	50                   	push   %eax
  800b1a:	ff 75 0c             	pushl  0xc(%ebp)
  800b1d:	ff 75 08             	pushl  0x8(%ebp)
  800b20:	e8 89 ff ff ff       	call   800aae <vsnprintf>
  800b25:	83 c4 10             	add    $0x10,%esp
  800b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b3d:	eb 06                	jmp    800b45 <strlen+0x15>
		n++;
  800b3f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b42:	ff 45 08             	incl   0x8(%ebp)
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	8a 00                	mov    (%eax),%al
  800b4a:	84 c0                	test   %al,%al
  800b4c:	75 f1                	jne    800b3f <strlen+0xf>
		n++;
	return n;
  800b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b60:	eb 09                	jmp    800b6b <strnlen+0x18>
		n++;
  800b62:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b65:	ff 45 08             	incl   0x8(%ebp)
  800b68:	ff 4d 0c             	decl   0xc(%ebp)
  800b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6f:	74 09                	je     800b7a <strnlen+0x27>
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8a 00                	mov    (%eax),%al
  800b76:	84 c0                	test   %al,%al
  800b78:	75 e8                	jne    800b62 <strnlen+0xf>
		n++;
	return n;
  800b7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b8b:	90                   	nop
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8d 50 01             	lea    0x1(%eax),%edx
  800b92:	89 55 08             	mov    %edx,0x8(%ebp)
  800b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b98:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b9b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b9e:	8a 12                	mov    (%edx),%dl
  800ba0:	88 10                	mov    %dl,(%eax)
  800ba2:	8a 00                	mov    (%eax),%al
  800ba4:	84 c0                	test   %al,%al
  800ba6:	75 e4                	jne    800b8c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc0:	eb 1f                	jmp    800be1 <strncpy+0x34>
		*dst++ = *src;
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8d 50 01             	lea    0x1(%eax),%edx
  800bc8:	89 55 08             	mov    %edx,0x8(%ebp)
  800bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bce:	8a 12                	mov    (%edx),%dl
  800bd0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	84 c0                	test   %al,%al
  800bd9:	74 03                	je     800bde <strncpy+0x31>
			src++;
  800bdb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bde:	ff 45 fc             	incl   -0x4(%ebp)
  800be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800be7:	72 d9                	jb     800bc2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800be9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bfa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bfe:	74 30                	je     800c30 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c00:	eb 16                	jmp    800c18 <strlcpy+0x2a>
			*dst++ = *src++;
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c11:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c14:	8a 12                	mov    (%edx),%dl
  800c16:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c18:	ff 4d 10             	decl   0x10(%ebp)
  800c1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c1f:	74 09                	je     800c2a <strlcpy+0x3c>
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	8a 00                	mov    (%eax),%al
  800c26:	84 c0                	test   %al,%al
  800c28:	75 d8                	jne    800c02 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c30:	8b 55 08             	mov    0x8(%ebp),%edx
  800c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c36:	29 c2                	sub    %eax,%edx
  800c38:	89 d0                	mov    %edx,%eax
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c3f:	eb 06                	jmp    800c47 <strcmp+0xb>
		p++, q++;
  800c41:	ff 45 08             	incl   0x8(%ebp)
  800c44:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	84 c0                	test   %al,%al
  800c4e:	74 0e                	je     800c5e <strcmp+0x22>
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	8a 10                	mov    (%eax),%dl
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	38 c2                	cmp    %al,%dl
  800c5c:	74 e3                	je     800c41 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	0f b6 d0             	movzbl %al,%edx
  800c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c69:	8a 00                	mov    (%eax),%al
  800c6b:	0f b6 c0             	movzbl %al,%eax
  800c6e:	29 c2                	sub    %eax,%edx
  800c70:	89 d0                	mov    %edx,%eax
}
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c77:	eb 09                	jmp    800c82 <strncmp+0xe>
		n--, p++, q++;
  800c79:	ff 4d 10             	decl   0x10(%ebp)
  800c7c:	ff 45 08             	incl   0x8(%ebp)
  800c7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c86:	74 17                	je     800c9f <strncmp+0x2b>
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	8a 00                	mov    (%eax),%al
  800c8d:	84 c0                	test   %al,%al
  800c8f:	74 0e                	je     800c9f <strncmp+0x2b>
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8a 10                	mov    (%eax),%dl
  800c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	38 c2                	cmp    %al,%dl
  800c9d:	74 da                	je     800c79 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca3:	75 07                	jne    800cac <strncmp+0x38>
		return 0;
  800ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  800caa:	eb 14                	jmp    800cc0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f b6 d0             	movzbl %al,%edx
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	0f b6 c0             	movzbl %al,%eax
  800cbc:	29 c2                	sub    %eax,%edx
  800cbe:	89 d0                	mov    %edx,%eax
}
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    

00800cc2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 04             	sub    $0x4,%esp
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cce:	eb 12                	jmp    800ce2 <strchr+0x20>
		if (*s == c)
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cd8:	75 05                	jne    800cdf <strchr+0x1d>
			return (char *) s;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	eb 11                	jmp    800cf0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cdf:	ff 45 08             	incl   0x8(%ebp)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	84 c0                	test   %al,%al
  800ce9:	75 e5                	jne    800cd0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 04             	sub    $0x4,%esp
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cfe:	eb 0d                	jmp    800d0d <strfind+0x1b>
		if (*s == c)
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d08:	74 0e                	je     800d18 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d0a:	ff 45 08             	incl   0x8(%ebp)
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	75 ea                	jne    800d00 <strfind+0xe>
  800d16:	eb 01                	jmp    800d19 <strfind+0x27>
		if (*s == c)
			break;
  800d18:	90                   	nop
	return (char *) s;
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d1c:	c9                   	leave  
  800d1d:	c3                   	ret    

00800d1e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d30:	eb 0e                	jmp    800d40 <memset+0x22>
		*p++ = c;
  800d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d35:	8d 50 01             	lea    0x1(%eax),%edx
  800d38:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d40:	ff 4d f8             	decl   -0x8(%ebp)
  800d43:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d47:	79 e9                	jns    800d32 <memset+0x14>
		*p++ = c;

	return v;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d60:	eb 16                	jmp    800d78 <memcpy+0x2a>
		*d++ = *s++;
  800d62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d65:	8d 50 01             	lea    0x1(%eax),%edx
  800d68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d74:	8a 12                	mov    (%edx),%dl
  800d76:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d78:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d81:	85 c0                	test   %eax,%eax
  800d83:	75 dd                	jne    800d62 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800da2:	73 50                	jae    800df4 <memmove+0x6a>
  800da4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da7:	8b 45 10             	mov    0x10(%ebp),%eax
  800daa:	01 d0                	add    %edx,%eax
  800dac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800daf:	76 43                	jbe    800df4 <memmove+0x6a>
		s += n;
  800db1:	8b 45 10             	mov    0x10(%ebp),%eax
  800db4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800db7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dba:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800dbd:	eb 10                	jmp    800dcf <memmove+0x45>
			*--d = *--s;
  800dbf:	ff 4d f8             	decl   -0x8(%ebp)
  800dc2:	ff 4d fc             	decl   -0x4(%ebp)
  800dc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc8:	8a 10                	mov    (%eax),%dl
  800dca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dcd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800dcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd5:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	75 e3                	jne    800dbf <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ddc:	eb 23                	jmp    800e01 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de1:	8d 50 01             	lea    0x1(%eax),%edx
  800de4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ded:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df0:	8a 12                	mov    (%edx),%dl
  800df2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800df4:	8b 45 10             	mov    0x10(%ebp),%eax
  800df7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfa:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	75 dd                	jne    800dde <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e18:	eb 2a                	jmp    800e44 <memcmp+0x3e>
		if (*s1 != *s2)
  800e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1d:	8a 10                	mov    (%eax),%dl
  800e1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	38 c2                	cmp    %al,%dl
  800e26:	74 16                	je     800e3e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 d0             	movzbl %al,%edx
  800e30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	0f b6 c0             	movzbl %al,%eax
  800e38:	29 c2                	sub    %eax,%edx
  800e3a:	89 d0                	mov    %edx,%eax
  800e3c:	eb 18                	jmp    800e56 <memcmp+0x50>
		s1++, s2++;
  800e3e:	ff 45 fc             	incl   -0x4(%ebp)
  800e41:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e44:	8b 45 10             	mov    0x10(%ebp),%eax
  800e47:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	75 c9                	jne    800e1a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e61:	8b 45 10             	mov    0x10(%ebp),%eax
  800e64:	01 d0                	add    %edx,%eax
  800e66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e69:	eb 15                	jmp    800e80 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	0f b6 d0             	movzbl %al,%edx
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	0f b6 c0             	movzbl %al,%eax
  800e79:	39 c2                	cmp    %eax,%edx
  800e7b:	74 0d                	je     800e8a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e7d:	ff 45 08             	incl   0x8(%ebp)
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e86:	72 e3                	jb     800e6b <memfind+0x13>
  800e88:	eb 01                	jmp    800e8b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e8a:	90                   	nop
	return (void *) s;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8e:	c9                   	leave  
  800e8f:	c3                   	ret    

00800e90 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e9d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ea4:	eb 03                	jmp    800ea9 <strtol+0x19>
		s++;
  800ea6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	3c 20                	cmp    $0x20,%al
  800eb0:	74 f4                	je     800ea6 <strtol+0x16>
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	3c 09                	cmp    $0x9,%al
  800eb9:	74 eb                	je     800ea6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	3c 2b                	cmp    $0x2b,%al
  800ec2:	75 05                	jne    800ec9 <strtol+0x39>
		s++;
  800ec4:	ff 45 08             	incl   0x8(%ebp)
  800ec7:	eb 13                	jmp    800edc <strtol+0x4c>
	else if (*s == '-')
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8a 00                	mov    (%eax),%al
  800ece:	3c 2d                	cmp    $0x2d,%al
  800ed0:	75 0a                	jne    800edc <strtol+0x4c>
		s++, neg = 1;
  800ed2:	ff 45 08             	incl   0x8(%ebp)
  800ed5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800edc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee0:	74 06                	je     800ee8 <strtol+0x58>
  800ee2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ee6:	75 20                	jne    800f08 <strtol+0x78>
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	3c 30                	cmp    $0x30,%al
  800eef:	75 17                	jne    800f08 <strtol+0x78>
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	40                   	inc    %eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	3c 78                	cmp    $0x78,%al
  800ef9:	75 0d                	jne    800f08 <strtol+0x78>
		s += 2, base = 16;
  800efb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eff:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f06:	eb 28                	jmp    800f30 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0c:	75 15                	jne    800f23 <strtol+0x93>
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	3c 30                	cmp    $0x30,%al
  800f15:	75 0c                	jne    800f23 <strtol+0x93>
		s++, base = 8;
  800f17:	ff 45 08             	incl   0x8(%ebp)
  800f1a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f21:	eb 0d                	jmp    800f30 <strtol+0xa0>
	else if (base == 0)
  800f23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f27:	75 07                	jne    800f30 <strtol+0xa0>
		base = 10;
  800f29:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	3c 2f                	cmp    $0x2f,%al
  800f37:	7e 19                	jle    800f52 <strtol+0xc2>
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	3c 39                	cmp    $0x39,%al
  800f40:	7f 10                	jg     800f52 <strtol+0xc2>
			dig = *s - '0';
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f be c0             	movsbl %al,%eax
  800f4a:	83 e8 30             	sub    $0x30,%eax
  800f4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f50:	eb 42                	jmp    800f94 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	3c 60                	cmp    $0x60,%al
  800f59:	7e 19                	jle    800f74 <strtol+0xe4>
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	3c 7a                	cmp    $0x7a,%al
  800f62:	7f 10                	jg     800f74 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	0f be c0             	movsbl %al,%eax
  800f6c:	83 e8 57             	sub    $0x57,%eax
  800f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f72:	eb 20                	jmp    800f94 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	3c 40                	cmp    $0x40,%al
  800f7b:	7e 39                	jle    800fb6 <strtol+0x126>
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 5a                	cmp    $0x5a,%al
  800f84:	7f 30                	jg     800fb6 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f be c0             	movsbl %al,%eax
  800f8e:	83 e8 37             	sub    $0x37,%eax
  800f91:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f97:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f9a:	7d 19                	jge    800fb5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f9c:	ff 45 08             	incl   0x8(%ebp)
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fa6:	89 c2                	mov    %eax,%edx
  800fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fab:	01 d0                	add    %edx,%eax
  800fad:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fb0:	e9 7b ff ff ff       	jmp    800f30 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fb5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fba:	74 08                	je     800fc4 <strtol+0x134>
		*endptr = (char *) s;
  800fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fc8:	74 07                	je     800fd1 <strtol+0x141>
  800fca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcd:	f7 d8                	neg    %eax
  800fcf:	eb 03                	jmp    800fd4 <strtol+0x144>
  800fd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fd4:	c9                   	leave  
  800fd5:	c3                   	ret    

00800fd6 <ltostr>:

void
ltostr(long value, char *str)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fe3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fee:	79 13                	jns    801003 <ltostr+0x2d>
	{
		neg = 1;
  800ff0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ffd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801000:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80100b:	99                   	cltd   
  80100c:	f7 f9                	idiv   %ecx
  80100e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801014:	8d 50 01             	lea    0x1(%eax),%edx
  801017:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80101a:	89 c2                	mov    %eax,%edx
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	01 d0                	add    %edx,%eax
  801021:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801024:	83 c2 30             	add    $0x30,%edx
  801027:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801029:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80102c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801031:	f7 e9                	imul   %ecx
  801033:	c1 fa 02             	sar    $0x2,%edx
  801036:	89 c8                	mov    %ecx,%eax
  801038:	c1 f8 1f             	sar    $0x1f,%eax
  80103b:	29 c2                	sub    %eax,%edx
  80103d:	89 d0                	mov    %edx,%eax
  80103f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801042:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801046:	75 bb                	jne    801003 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801048:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80104f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801052:	48                   	dec    %eax
  801053:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801056:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105a:	74 3d                	je     801099 <ltostr+0xc3>
		start = 1 ;
  80105c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801063:	eb 34                	jmp    801099 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	01 d0                	add    %edx,%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	01 c2                	add    %eax,%edx
  80107a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	01 c8                	add    %ecx,%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801086:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	01 c2                	add    %eax,%edx
  80108e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801091:	88 02                	mov    %al,(%edx)
		start++ ;
  801093:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801096:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80109f:	7c c4                	jl     801065 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010ac:	90                   	nop
  8010ad:	c9                   	leave  
  8010ae:	c3                   	ret    

008010af <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010b5:	ff 75 08             	pushl  0x8(%ebp)
  8010b8:	e8 73 fa ff ff       	call   800b30 <strlen>
  8010bd:	83 c4 04             	add    $0x4,%esp
  8010c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010c3:	ff 75 0c             	pushl  0xc(%ebp)
  8010c6:	e8 65 fa ff ff       	call   800b30 <strlen>
  8010cb:	83 c4 04             	add    $0x4,%esp
  8010ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010df:	eb 17                	jmp    8010f8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e7:	01 c2                	add    %eax,%edx
  8010e9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	01 c8                	add    %ecx,%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010f5:	ff 45 fc             	incl   -0x4(%ebp)
  8010f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010fe:	7c e1                	jl     8010e1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801100:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801107:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80110e:	eb 1f                	jmp    80112f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801110:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801113:	8d 50 01             	lea    0x1(%eax),%edx
  801116:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801119:	89 c2                	mov    %eax,%edx
  80111b:	8b 45 10             	mov    0x10(%ebp),%eax
  80111e:	01 c2                	add    %eax,%edx
  801120:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	01 c8                	add    %ecx,%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80112c:	ff 45 f8             	incl   -0x8(%ebp)
  80112f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801132:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801135:	7c d9                	jl     801110 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801137:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113a:	8b 45 10             	mov    0x10(%ebp),%eax
  80113d:	01 d0                	add    %edx,%eax
  80113f:	c6 00 00             	movb   $0x0,(%eax)
}
  801142:	90                   	nop
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801148:	8b 45 14             	mov    0x14(%ebp),%eax
  80114b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801151:	8b 45 14             	mov    0x14(%ebp),%eax
  801154:	8b 00                	mov    (%eax),%eax
  801156:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	01 d0                	add    %edx,%eax
  801162:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801168:	eb 0c                	jmp    801176 <strsplit+0x31>
			*string++ = 0;
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8d 50 01             	lea    0x1(%eax),%edx
  801170:	89 55 08             	mov    %edx,0x8(%ebp)
  801173:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	84 c0                	test   %al,%al
  80117d:	74 18                	je     801197 <strsplit+0x52>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	0f be c0             	movsbl %al,%eax
  801187:	50                   	push   %eax
  801188:	ff 75 0c             	pushl  0xc(%ebp)
  80118b:	e8 32 fb ff ff       	call   800cc2 <strchr>
  801190:	83 c4 08             	add    $0x8,%esp
  801193:	85 c0                	test   %eax,%eax
  801195:	75 d3                	jne    80116a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	84 c0                	test   %al,%al
  80119e:	74 5a                	je     8011fa <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a3:	8b 00                	mov    (%eax),%eax
  8011a5:	83 f8 0f             	cmp    $0xf,%eax
  8011a8:	75 07                	jne    8011b1 <strsplit+0x6c>
		{
			return 0;
  8011aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8011af:	eb 66                	jmp    801217 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b4:	8b 00                	mov    (%eax),%eax
  8011b6:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b9:	8b 55 14             	mov    0x14(%ebp),%edx
  8011bc:	89 0a                	mov    %ecx,(%edx)
  8011be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c8:	01 c2                	add    %eax,%edx
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011cf:	eb 03                	jmp    8011d4 <strsplit+0x8f>
			string++;
  8011d1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	84 c0                	test   %al,%al
  8011db:	74 8b                	je     801168 <strsplit+0x23>
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f be c0             	movsbl %al,%eax
  8011e5:	50                   	push   %eax
  8011e6:	ff 75 0c             	pushl  0xc(%ebp)
  8011e9:	e8 d4 fa ff ff       	call   800cc2 <strchr>
  8011ee:	83 c4 08             	add    $0x8,%esp
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	74 dc                	je     8011d1 <strsplit+0x8c>
			string++;
	}
  8011f5:	e9 6e ff ff ff       	jmp    801168 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011fa:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fe:	8b 00                	mov    (%eax),%eax
  801200:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801207:	8b 45 10             	mov    0x10(%ebp),%eax
  80120a:	01 d0                	add    %edx,%eax
  80120c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801212:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801217:	c9                   	leave  
  801218:	c3                   	ret    

00801219 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	68 48 21 80 00       	push   $0x802148
  801227:	68 3f 01 00 00       	push   $0x13f
  80122c:	68 6a 21 80 00       	push   $0x80216a
  801231:	e8 a9 ef ff ff       	call   8001df <_panic>

00801236 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	57                   	push   %edi
  80123a:	56                   	push   %esi
  80123b:	53                   	push   %ebx
  80123c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8b 55 0c             	mov    0xc(%ebp),%edx
  801245:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801248:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80124b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80124e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801251:	cd 30                	int    $0x30
  801253:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801256:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	5b                   	pop    %ebx
  80125d:	5e                   	pop    %esi
  80125e:	5f                   	pop    %edi
  80125f:	5d                   	pop    %ebp
  801260:	c3                   	ret    

00801261 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	83 ec 04             	sub    $0x4,%esp
  801267:	8b 45 10             	mov    0x10(%ebp),%eax
  80126a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80126d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	6a 00                	push   $0x0
  801276:	6a 00                	push   $0x0
  801278:	52                   	push   %edx
  801279:	ff 75 0c             	pushl  0xc(%ebp)
  80127c:	50                   	push   %eax
  80127d:	6a 00                	push   $0x0
  80127f:	e8 b2 ff ff ff       	call   801236 <syscall>
  801284:	83 c4 18             	add    $0x18,%esp
}
  801287:	90                   	nop
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <sys_cgetc>:

int
sys_cgetc(void)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	6a 02                	push   $0x2
  801299:	e8 98 ff ff ff       	call   801236 <syscall>
  80129e:	83 c4 18             	add    $0x18,%esp
}
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 00                	push   $0x0
  8012b0:	6a 03                	push   $0x3
  8012b2:	e8 7f ff ff ff       	call   801236 <syscall>
  8012b7:	83 c4 18             	add    $0x18,%esp
}
  8012ba:	90                   	nop
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	6a 04                	push   $0x4
  8012cc:	e8 65 ff ff ff       	call   801236 <syscall>
  8012d1:	83 c4 18             	add    $0x18,%esp
}
  8012d4:	90                   	nop
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	52                   	push   %edx
  8012e7:	50                   	push   %eax
  8012e8:	6a 08                	push   $0x8
  8012ea:	e8 47 ff ff ff       	call   801236 <syscall>
  8012ef:	83 c4 18             	add    $0x18,%esp
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	56                   	push   %esi
  8012f8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012f9:	8b 75 18             	mov    0x18(%ebp),%esi
  8012fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801302:	8b 55 0c             	mov    0xc(%ebp),%edx
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	56                   	push   %esi
  801309:	53                   	push   %ebx
  80130a:	51                   	push   %ecx
  80130b:	52                   	push   %edx
  80130c:	50                   	push   %eax
  80130d:	6a 09                	push   $0x9
  80130f:	e8 22 ff ff ff       	call   801236 <syscall>
  801314:	83 c4 18             	add    $0x18,%esp
}
  801317:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80131a:	5b                   	pop    %ebx
  80131b:	5e                   	pop    %esi
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    

0080131e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	52                   	push   %edx
  80132e:	50                   	push   %eax
  80132f:	6a 0a                	push   $0xa
  801331:	e8 00 ff ff ff       	call   801236 <syscall>
  801336:	83 c4 18             	add    $0x18,%esp
}
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	ff 75 0c             	pushl  0xc(%ebp)
  801347:	ff 75 08             	pushl  0x8(%ebp)
  80134a:	6a 0b                	push   $0xb
  80134c:	e8 e5 fe ff ff       	call   801236 <syscall>
  801351:	83 c4 18             	add    $0x18,%esp
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 0c                	push   $0xc
  801365:	e8 cc fe ff ff       	call   801236 <syscall>
  80136a:	83 c4 18             	add    $0x18,%esp
}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 0d                	push   $0xd
  80137e:	e8 b3 fe ff ff       	call   801236 <syscall>
  801383:	83 c4 18             	add    $0x18,%esp
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 0e                	push   $0xe
  801397:	e8 9a fe ff ff       	call   801236 <syscall>
  80139c:	83 c4 18             	add    $0x18,%esp
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 0f                	push   $0xf
  8013b0:	e8 81 fe ff ff       	call   801236 <syscall>
  8013b5:	83 c4 18             	add    $0x18,%esp
}
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	ff 75 08             	pushl  0x8(%ebp)
  8013c8:	6a 10                	push   $0x10
  8013ca:	e8 67 fe ff ff       	call   801236 <syscall>
  8013cf:	83 c4 18             	add    $0x18,%esp
}
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 11                	push   $0x11
  8013e3:	e8 4e fe ff ff       	call   801236 <syscall>
  8013e8:	83 c4 18             	add    $0x18,%esp
}
  8013eb:	90                   	nop
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <sys_cputc>:

void
sys_cputc(const char c)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 04             	sub    $0x4,%esp
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	50                   	push   %eax
  801407:	6a 01                	push   $0x1
  801409:	e8 28 fe ff ff       	call   801236 <syscall>
  80140e:	83 c4 18             	add    $0x18,%esp
}
  801411:	90                   	nop
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 14                	push   $0x14
  801423:	e8 0e fe ff ff       	call   801236 <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
}
  80142b:	90                   	nop
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 04             	sub    $0x4,%esp
  801434:	8b 45 10             	mov    0x10(%ebp),%eax
  801437:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80143a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80143d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	6a 00                	push   $0x0
  801446:	51                   	push   %ecx
  801447:	52                   	push   %edx
  801448:	ff 75 0c             	pushl  0xc(%ebp)
  80144b:	50                   	push   %eax
  80144c:	6a 15                	push   $0x15
  80144e:	e8 e3 fd ff ff       	call   801236 <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80145b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	52                   	push   %edx
  801468:	50                   	push   %eax
  801469:	6a 16                	push   $0x16
  80146b:	e8 c6 fd ff ff       	call   801236 <syscall>
  801470:	83 c4 18             	add    $0x18,%esp
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801478:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80147b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	51                   	push   %ecx
  801486:	52                   	push   %edx
  801487:	50                   	push   %eax
  801488:	6a 17                	push   $0x17
  80148a:	e8 a7 fd ff ff       	call   801236 <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801497:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	52                   	push   %edx
  8014a4:	50                   	push   %eax
  8014a5:	6a 18                	push   $0x18
  8014a7:	e8 8a fd ff ff       	call   801236 <syscall>
  8014ac:	83 c4 18             	add    $0x18,%esp
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	6a 00                	push   $0x0
  8014b9:	ff 75 14             	pushl  0x14(%ebp)
  8014bc:	ff 75 10             	pushl  0x10(%ebp)
  8014bf:	ff 75 0c             	pushl  0xc(%ebp)
  8014c2:	50                   	push   %eax
  8014c3:	6a 19                	push   $0x19
  8014c5:	e8 6c fd ff ff       	call   801236 <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	50                   	push   %eax
  8014de:	6a 1a                	push   $0x1a
  8014e0:	e8 51 fd ff ff       	call   801236 <syscall>
  8014e5:	83 c4 18             	add    $0x18,%esp
}
  8014e8:	90                   	nop
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	50                   	push   %eax
  8014fa:	6a 1b                	push   $0x1b
  8014fc:	e8 35 fd ff ff       	call   801236 <syscall>
  801501:	83 c4 18             	add    $0x18,%esp
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 05                	push   $0x5
  801515:	e8 1c fd ff ff       	call   801236 <syscall>
  80151a:	83 c4 18             	add    $0x18,%esp
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 06                	push   $0x6
  80152e:	e8 03 fd ff ff       	call   801236 <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 07                	push   $0x7
  801547:	e8 ea fc ff ff       	call   801236 <syscall>
  80154c:	83 c4 18             	add    $0x18,%esp
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <sys_exit_env>:


void sys_exit_env(void)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 1c                	push   $0x1c
  801560:	e8 d1 fc ff ff       	call   801236 <syscall>
  801565:	83 c4 18             	add    $0x18,%esp
}
  801568:	90                   	nop
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801571:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801574:	8d 50 04             	lea    0x4(%eax),%edx
  801577:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	52                   	push   %edx
  801581:	50                   	push   %eax
  801582:	6a 1d                	push   $0x1d
  801584:	e8 ad fc ff ff       	call   801236 <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
	return result;
  80158c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801595:	89 01                	mov    %eax,(%ecx)
  801597:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	c9                   	leave  
  80159e:	c2 04 00             	ret    $0x4

008015a1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	ff 75 10             	pushl  0x10(%ebp)
  8015ab:	ff 75 0c             	pushl  0xc(%ebp)
  8015ae:	ff 75 08             	pushl  0x8(%ebp)
  8015b1:	6a 13                	push   $0x13
  8015b3:	e8 7e fc ff ff       	call   801236 <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015bb:	90                   	nop
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_rcr2>:
uint32 sys_rcr2()
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 1e                	push   $0x1e
  8015cd:	e8 64 fc ff ff       	call   801236 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	83 ec 04             	sub    $0x4,%esp
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015e3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	50                   	push   %eax
  8015f0:	6a 1f                	push   $0x1f
  8015f2:	e8 3f fc ff ff       	call   801236 <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8015fa:	90                   	nop
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <rsttst>:
void rsttst()
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 21                	push   $0x21
  80160c:	e8 25 fc ff ff       	call   801236 <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
	return ;
  801614:	90                   	nop
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 04             	sub    $0x4,%esp
  80161d:	8b 45 14             	mov    0x14(%ebp),%eax
  801620:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801623:	8b 55 18             	mov    0x18(%ebp),%edx
  801626:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80162a:	52                   	push   %edx
  80162b:	50                   	push   %eax
  80162c:	ff 75 10             	pushl  0x10(%ebp)
  80162f:	ff 75 0c             	pushl  0xc(%ebp)
  801632:	ff 75 08             	pushl  0x8(%ebp)
  801635:	6a 20                	push   $0x20
  801637:	e8 fa fb ff ff       	call   801236 <syscall>
  80163c:	83 c4 18             	add    $0x18,%esp
	return ;
  80163f:	90                   	nop
}
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <chktst>:
void chktst(uint32 n)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	ff 75 08             	pushl  0x8(%ebp)
  801650:	6a 22                	push   $0x22
  801652:	e8 df fb ff ff       	call   801236 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
	return ;
  80165a:	90                   	nop
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <inctst>:

void inctst()
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 23                	push   $0x23
  80166c:	e8 c5 fb ff ff       	call   801236 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
	return ;
  801674:	90                   	nop
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <gettst>:
uint32 gettst()
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 24                	push   $0x24
  801686:	e8 ab fb ff ff       	call   801236 <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 25                	push   $0x25
  8016a2:	e8 8f fb ff ff       	call   801236 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
  8016aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016ad:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016b1:	75 07                	jne    8016ba <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b8:	eb 05                	jmp    8016bf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 25                	push   $0x25
  8016d3:	e8 5e fb ff ff       	call   801236 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
  8016db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016de:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016e2:	75 07                	jne    8016eb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e9:	eb 05                	jmp    8016f0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 25                	push   $0x25
  801704:	e8 2d fb ff ff       	call   801236 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
  80170c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80170f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801713:	75 07                	jne    80171c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801715:	b8 01 00 00 00       	mov    $0x1,%eax
  80171a:	eb 05                	jmp    801721 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 25                	push   $0x25
  801735:	e8 fc fa ff ff       	call   801236 <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
  80173d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801740:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801744:	75 07                	jne    80174d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801746:	b8 01 00 00 00       	mov    $0x1,%eax
  80174b:	eb 05                	jmp    801752 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80174d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	ff 75 08             	pushl  0x8(%ebp)
  801762:	6a 26                	push   $0x26
  801764:	e8 cd fa ff ff       	call   801236 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
	return ;
  80176c:	90                   	nop
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801773:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801776:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801779:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	6a 00                	push   $0x0
  801781:	53                   	push   %ebx
  801782:	51                   	push   %ecx
  801783:	52                   	push   %edx
  801784:	50                   	push   %eax
  801785:	6a 27                	push   $0x27
  801787:	e8 aa fa ff ff       	call   801236 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801797:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	52                   	push   %edx
  8017a4:	50                   	push   %eax
  8017a5:	6a 28                	push   $0x28
  8017a7:	e8 8a fa ff ff       	call   801236 <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017b4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	6a 00                	push   $0x0
  8017bf:	51                   	push   %ecx
  8017c0:	ff 75 10             	pushl  0x10(%ebp)
  8017c3:	52                   	push   %edx
  8017c4:	50                   	push   %eax
  8017c5:	6a 29                	push   $0x29
  8017c7:	e8 6a fa ff ff       	call   801236 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	ff 75 10             	pushl  0x10(%ebp)
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	ff 75 08             	pushl  0x8(%ebp)
  8017e1:	6a 12                	push   $0x12
  8017e3:	e8 4e fa ff ff       	call   801236 <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017eb:	90                   	nop
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	52                   	push   %edx
  8017fe:	50                   	push   %eax
  8017ff:	6a 2a                	push   $0x2a
  801801:	e8 30 fa ff ff       	call   801236 <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
	return;
  801809:	90                   	nop
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801812:	83 ec 04             	sub    $0x4,%esp
  801815:	68 77 21 80 00       	push   $0x802177
  80181a:	68 2e 01 00 00       	push   $0x12e
  80181f:	68 8b 21 80 00       	push   $0x80218b
  801824:	e8 b6 e9 ff ff       	call   8001df <_panic>

00801829 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	68 77 21 80 00       	push   $0x802177
  801837:	68 35 01 00 00       	push   $0x135
  80183c:	68 8b 21 80 00       	push   $0x80218b
  801841:	e8 99 e9 ff ff       	call   8001df <_panic>

00801846 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	68 77 21 80 00       	push   $0x802177
  801854:	68 3b 01 00 00       	push   $0x13b
  801859:	68 8b 21 80 00       	push   $0x80218b
  80185e:	e8 7c e9 ff ff       	call   8001df <_panic>
  801863:	90                   	nop

00801864 <__udivdi3>:
  801864:	55                   	push   %ebp
  801865:	57                   	push   %edi
  801866:	56                   	push   %esi
  801867:	53                   	push   %ebx
  801868:	83 ec 1c             	sub    $0x1c,%esp
  80186b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80186f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801873:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801877:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80187b:	89 ca                	mov    %ecx,%edx
  80187d:	89 f8                	mov    %edi,%eax
  80187f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801883:	85 f6                	test   %esi,%esi
  801885:	75 2d                	jne    8018b4 <__udivdi3+0x50>
  801887:	39 cf                	cmp    %ecx,%edi
  801889:	77 65                	ja     8018f0 <__udivdi3+0x8c>
  80188b:	89 fd                	mov    %edi,%ebp
  80188d:	85 ff                	test   %edi,%edi
  80188f:	75 0b                	jne    80189c <__udivdi3+0x38>
  801891:	b8 01 00 00 00       	mov    $0x1,%eax
  801896:	31 d2                	xor    %edx,%edx
  801898:	f7 f7                	div    %edi
  80189a:	89 c5                	mov    %eax,%ebp
  80189c:	31 d2                	xor    %edx,%edx
  80189e:	89 c8                	mov    %ecx,%eax
  8018a0:	f7 f5                	div    %ebp
  8018a2:	89 c1                	mov    %eax,%ecx
  8018a4:	89 d8                	mov    %ebx,%eax
  8018a6:	f7 f5                	div    %ebp
  8018a8:	89 cf                	mov    %ecx,%edi
  8018aa:	89 fa                	mov    %edi,%edx
  8018ac:	83 c4 1c             	add    $0x1c,%esp
  8018af:	5b                   	pop    %ebx
  8018b0:	5e                   	pop    %esi
  8018b1:	5f                   	pop    %edi
  8018b2:	5d                   	pop    %ebp
  8018b3:	c3                   	ret    
  8018b4:	39 ce                	cmp    %ecx,%esi
  8018b6:	77 28                	ja     8018e0 <__udivdi3+0x7c>
  8018b8:	0f bd fe             	bsr    %esi,%edi
  8018bb:	83 f7 1f             	xor    $0x1f,%edi
  8018be:	75 40                	jne    801900 <__udivdi3+0x9c>
  8018c0:	39 ce                	cmp    %ecx,%esi
  8018c2:	72 0a                	jb     8018ce <__udivdi3+0x6a>
  8018c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018c8:	0f 87 9e 00 00 00    	ja     80196c <__udivdi3+0x108>
  8018ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d3:	89 fa                	mov    %edi,%edx
  8018d5:	83 c4 1c             	add    $0x1c,%esp
  8018d8:	5b                   	pop    %ebx
  8018d9:	5e                   	pop    %esi
  8018da:	5f                   	pop    %edi
  8018db:	5d                   	pop    %ebp
  8018dc:	c3                   	ret    
  8018dd:	8d 76 00             	lea    0x0(%esi),%esi
  8018e0:	31 ff                	xor    %edi,%edi
  8018e2:	31 c0                	xor    %eax,%eax
  8018e4:	89 fa                	mov    %edi,%edx
  8018e6:	83 c4 1c             	add    $0x1c,%esp
  8018e9:	5b                   	pop    %ebx
  8018ea:	5e                   	pop    %esi
  8018eb:	5f                   	pop    %edi
  8018ec:	5d                   	pop    %ebp
  8018ed:	c3                   	ret    
  8018ee:	66 90                	xchg   %ax,%ax
  8018f0:	89 d8                	mov    %ebx,%eax
  8018f2:	f7 f7                	div    %edi
  8018f4:	31 ff                	xor    %edi,%edi
  8018f6:	89 fa                	mov    %edi,%edx
  8018f8:	83 c4 1c             	add    $0x1c,%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5e                   	pop    %esi
  8018fd:	5f                   	pop    %edi
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    
  801900:	bd 20 00 00 00       	mov    $0x20,%ebp
  801905:	89 eb                	mov    %ebp,%ebx
  801907:	29 fb                	sub    %edi,%ebx
  801909:	89 f9                	mov    %edi,%ecx
  80190b:	d3 e6                	shl    %cl,%esi
  80190d:	89 c5                	mov    %eax,%ebp
  80190f:	88 d9                	mov    %bl,%cl
  801911:	d3 ed                	shr    %cl,%ebp
  801913:	89 e9                	mov    %ebp,%ecx
  801915:	09 f1                	or     %esi,%ecx
  801917:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80191b:	89 f9                	mov    %edi,%ecx
  80191d:	d3 e0                	shl    %cl,%eax
  80191f:	89 c5                	mov    %eax,%ebp
  801921:	89 d6                	mov    %edx,%esi
  801923:	88 d9                	mov    %bl,%cl
  801925:	d3 ee                	shr    %cl,%esi
  801927:	89 f9                	mov    %edi,%ecx
  801929:	d3 e2                	shl    %cl,%edx
  80192b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80192f:	88 d9                	mov    %bl,%cl
  801931:	d3 e8                	shr    %cl,%eax
  801933:	09 c2                	or     %eax,%edx
  801935:	89 d0                	mov    %edx,%eax
  801937:	89 f2                	mov    %esi,%edx
  801939:	f7 74 24 0c          	divl   0xc(%esp)
  80193d:	89 d6                	mov    %edx,%esi
  80193f:	89 c3                	mov    %eax,%ebx
  801941:	f7 e5                	mul    %ebp
  801943:	39 d6                	cmp    %edx,%esi
  801945:	72 19                	jb     801960 <__udivdi3+0xfc>
  801947:	74 0b                	je     801954 <__udivdi3+0xf0>
  801949:	89 d8                	mov    %ebx,%eax
  80194b:	31 ff                	xor    %edi,%edi
  80194d:	e9 58 ff ff ff       	jmp    8018aa <__udivdi3+0x46>
  801952:	66 90                	xchg   %ax,%ax
  801954:	8b 54 24 08          	mov    0x8(%esp),%edx
  801958:	89 f9                	mov    %edi,%ecx
  80195a:	d3 e2                	shl    %cl,%edx
  80195c:	39 c2                	cmp    %eax,%edx
  80195e:	73 e9                	jae    801949 <__udivdi3+0xe5>
  801960:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801963:	31 ff                	xor    %edi,%edi
  801965:	e9 40 ff ff ff       	jmp    8018aa <__udivdi3+0x46>
  80196a:	66 90                	xchg   %ax,%ax
  80196c:	31 c0                	xor    %eax,%eax
  80196e:	e9 37 ff ff ff       	jmp    8018aa <__udivdi3+0x46>
  801973:	90                   	nop

00801974 <__umoddi3>:
  801974:	55                   	push   %ebp
  801975:	57                   	push   %edi
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	83 ec 1c             	sub    $0x1c,%esp
  80197b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80197f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801983:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801987:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80198b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80198f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801993:	89 f3                	mov    %esi,%ebx
  801995:	89 fa                	mov    %edi,%edx
  801997:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80199b:	89 34 24             	mov    %esi,(%esp)
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	75 1a                	jne    8019bc <__umoddi3+0x48>
  8019a2:	39 f7                	cmp    %esi,%edi
  8019a4:	0f 86 a2 00 00 00    	jbe    801a4c <__umoddi3+0xd8>
  8019aa:	89 c8                	mov    %ecx,%eax
  8019ac:	89 f2                	mov    %esi,%edx
  8019ae:	f7 f7                	div    %edi
  8019b0:	89 d0                	mov    %edx,%eax
  8019b2:	31 d2                	xor    %edx,%edx
  8019b4:	83 c4 1c             	add    $0x1c,%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5e                   	pop    %esi
  8019b9:	5f                   	pop    %edi
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    
  8019bc:	39 f0                	cmp    %esi,%eax
  8019be:	0f 87 ac 00 00 00    	ja     801a70 <__umoddi3+0xfc>
  8019c4:	0f bd e8             	bsr    %eax,%ebp
  8019c7:	83 f5 1f             	xor    $0x1f,%ebp
  8019ca:	0f 84 ac 00 00 00    	je     801a7c <__umoddi3+0x108>
  8019d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8019d5:	29 ef                	sub    %ebp,%edi
  8019d7:	89 fe                	mov    %edi,%esi
  8019d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019dd:	89 e9                	mov    %ebp,%ecx
  8019df:	d3 e0                	shl    %cl,%eax
  8019e1:	89 d7                	mov    %edx,%edi
  8019e3:	89 f1                	mov    %esi,%ecx
  8019e5:	d3 ef                	shr    %cl,%edi
  8019e7:	09 c7                	or     %eax,%edi
  8019e9:	89 e9                	mov    %ebp,%ecx
  8019eb:	d3 e2                	shl    %cl,%edx
  8019ed:	89 14 24             	mov    %edx,(%esp)
  8019f0:	89 d8                	mov    %ebx,%eax
  8019f2:	d3 e0                	shl    %cl,%eax
  8019f4:	89 c2                	mov    %eax,%edx
  8019f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019fa:	d3 e0                	shl    %cl,%eax
  8019fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a00:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a04:	89 f1                	mov    %esi,%ecx
  801a06:	d3 e8                	shr    %cl,%eax
  801a08:	09 d0                	or     %edx,%eax
  801a0a:	d3 eb                	shr    %cl,%ebx
  801a0c:	89 da                	mov    %ebx,%edx
  801a0e:	f7 f7                	div    %edi
  801a10:	89 d3                	mov    %edx,%ebx
  801a12:	f7 24 24             	mull   (%esp)
  801a15:	89 c6                	mov    %eax,%esi
  801a17:	89 d1                	mov    %edx,%ecx
  801a19:	39 d3                	cmp    %edx,%ebx
  801a1b:	0f 82 87 00 00 00    	jb     801aa8 <__umoddi3+0x134>
  801a21:	0f 84 91 00 00 00    	je     801ab8 <__umoddi3+0x144>
  801a27:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a2b:	29 f2                	sub    %esi,%edx
  801a2d:	19 cb                	sbb    %ecx,%ebx
  801a2f:	89 d8                	mov    %ebx,%eax
  801a31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a35:	d3 e0                	shl    %cl,%eax
  801a37:	89 e9                	mov    %ebp,%ecx
  801a39:	d3 ea                	shr    %cl,%edx
  801a3b:	09 d0                	or     %edx,%eax
  801a3d:	89 e9                	mov    %ebp,%ecx
  801a3f:	d3 eb                	shr    %cl,%ebx
  801a41:	89 da                	mov    %ebx,%edx
  801a43:	83 c4 1c             	add    $0x1c,%esp
  801a46:	5b                   	pop    %ebx
  801a47:	5e                   	pop    %esi
  801a48:	5f                   	pop    %edi
  801a49:	5d                   	pop    %ebp
  801a4a:	c3                   	ret    
  801a4b:	90                   	nop
  801a4c:	89 fd                	mov    %edi,%ebp
  801a4e:	85 ff                	test   %edi,%edi
  801a50:	75 0b                	jne    801a5d <__umoddi3+0xe9>
  801a52:	b8 01 00 00 00       	mov    $0x1,%eax
  801a57:	31 d2                	xor    %edx,%edx
  801a59:	f7 f7                	div    %edi
  801a5b:	89 c5                	mov    %eax,%ebp
  801a5d:	89 f0                	mov    %esi,%eax
  801a5f:	31 d2                	xor    %edx,%edx
  801a61:	f7 f5                	div    %ebp
  801a63:	89 c8                	mov    %ecx,%eax
  801a65:	f7 f5                	div    %ebp
  801a67:	89 d0                	mov    %edx,%eax
  801a69:	e9 44 ff ff ff       	jmp    8019b2 <__umoddi3+0x3e>
  801a6e:	66 90                	xchg   %ax,%ax
  801a70:	89 c8                	mov    %ecx,%eax
  801a72:	89 f2                	mov    %esi,%edx
  801a74:	83 c4 1c             	add    $0x1c,%esp
  801a77:	5b                   	pop    %ebx
  801a78:	5e                   	pop    %esi
  801a79:	5f                   	pop    %edi
  801a7a:	5d                   	pop    %ebp
  801a7b:	c3                   	ret    
  801a7c:	3b 04 24             	cmp    (%esp),%eax
  801a7f:	72 06                	jb     801a87 <__umoddi3+0x113>
  801a81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a85:	77 0f                	ja     801a96 <__umoddi3+0x122>
  801a87:	89 f2                	mov    %esi,%edx
  801a89:	29 f9                	sub    %edi,%ecx
  801a8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a8f:	89 14 24             	mov    %edx,(%esp)
  801a92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a96:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a9a:	8b 14 24             	mov    (%esp),%edx
  801a9d:	83 c4 1c             	add    $0x1c,%esp
  801aa0:	5b                   	pop    %ebx
  801aa1:	5e                   	pop    %esi
  801aa2:	5f                   	pop    %edi
  801aa3:	5d                   	pop    %ebp
  801aa4:	c3                   	ret    
  801aa5:	8d 76 00             	lea    0x0(%esi),%esi
  801aa8:	2b 04 24             	sub    (%esp),%eax
  801aab:	19 fa                	sbb    %edi,%edx
  801aad:	89 d1                	mov    %edx,%ecx
  801aaf:	89 c6                	mov    %eax,%esi
  801ab1:	e9 71 ff ff ff       	jmp    801a27 <__umoddi3+0xb3>
  801ab6:	66 90                	xchg   %ax,%ax
  801ab8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801abc:	72 ea                	jb     801aa8 <__umoddi3+0x134>
  801abe:	89 d9                	mov    %ebx,%ecx
  801ac0:	e9 62 ff ff ff       	jmp    801a27 <__umoddi3+0xb3>
