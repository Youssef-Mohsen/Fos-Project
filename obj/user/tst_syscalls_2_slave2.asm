
obj/user/tst_syscalls_2_slave2:     file format elf32-i386


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
  800031:	e8 33 00 00 00       	call   800069 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the correct validation of system call params
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	//[2] Invalid Range (outside User Heap)
	sys_allocate_user_mem(USER_HEAP_MAX, 10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	6a 0a                	push   $0xa
  800043:	68 00 00 00 a0       	push   $0xa0000000
  800048:	e8 bf 17 00 00       	call   80180c <sys_allocate_user_mem>
  80004d:	83 c4 10             	add    $0x10,%esp
	inctst();
  800050:	e8 d1 15 00 00       	call   801626 <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	68 a0 1a 80 00       	push   $0x801aa0
  80005d:	6a 0a                	push   $0xa
  80005f:	68 22 1b 80 00       	push   $0x801b22
  800064:	e8 3f 01 00 00       	call   8001a8 <_panic>

00800069 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800069:	55                   	push   %ebp
  80006a:	89 e5                	mov    %esp,%ebp
  80006c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006f:	e8 74 14 00 00       	call   8014e8 <sys_getenvindex>
  800074:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007a:	89 d0                	mov    %edx,%eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	01 d0                	add    %edx,%eax
  800081:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800088:	01 c8                	add    %ecx,%eax
  80008a:	01 c0                	add    %eax,%eax
  80008c:	01 d0                	add    %edx,%eax
  80008e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800095:	01 c8                	add    %ecx,%eax
  800097:	01 d0                	add    %edx,%eax
  800099:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009e:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000a3:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a8:	8a 40 20             	mov    0x20(%eax),%al
  8000ab:	84 c0                	test   %al,%al
  8000ad:	74 0d                	je     8000bc <libmain+0x53>
		binaryname = myEnv->prog_name;
  8000af:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b4:	83 c0 20             	add    $0x20,%eax
  8000b7:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c0:	7e 0a                	jle    8000cc <libmain+0x63>
		binaryname = argv[0];
  8000c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c5:	8b 00                	mov    (%eax),%eax
  8000c7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 0c             	pushl  0xc(%ebp)
  8000d2:	ff 75 08             	pushl  0x8(%ebp)
  8000d5:	e8 5e ff ff ff       	call   800038 <_main>
  8000da:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000dd:	e8 8a 11 00 00       	call   80126c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 58 1b 80 00       	push   $0x801b58
  8000ea:	e8 76 03 00 00       	call   800465 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800102:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	52                   	push   %edx
  80010c:	50                   	push   %eax
  80010d:	68 80 1b 80 00       	push   $0x801b80
  800112:	e8 4e 03 00 00       	call   800465 <cprintf>
  800117:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80011a:	a1 04 30 80 00       	mov    0x803004,%eax
  80011f:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800125:	a1 04 30 80 00       	mov    0x803004,%eax
  80012a:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800130:	a1 04 30 80 00       	mov    0x803004,%eax
  800135:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80013b:	51                   	push   %ecx
  80013c:	52                   	push   %edx
  80013d:	50                   	push   %eax
  80013e:	68 a8 1b 80 00       	push   $0x801ba8
  800143:	e8 1d 03 00 00       	call   800465 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80014b:	a1 04 30 80 00       	mov    0x803004,%eax
  800150:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800156:	83 ec 08             	sub    $0x8,%esp
  800159:	50                   	push   %eax
  80015a:	68 00 1c 80 00       	push   $0x801c00
  80015f:	e8 01 03 00 00       	call   800465 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 58 1b 80 00       	push   $0x801b58
  80016f:	e8 f1 02 00 00       	call   800465 <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800177:	e8 0a 11 00 00       	call   801286 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80017c:	e8 19 00 00 00       	call   80019a <exit>
}
  800181:	90                   	nop
  800182:	c9                   	leave  
  800183:	c3                   	ret    

00800184 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	6a 00                	push   $0x0
  80018f:	e8 20 13 00 00       	call   8014b4 <sys_destroy_env>
  800194:	83 c4 10             	add    $0x10,%esp
}
  800197:	90                   	nop
  800198:	c9                   	leave  
  800199:	c3                   	ret    

0080019a <exit>:

void
exit(void)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001a0:	e8 75 13 00 00       	call   80151a <sys_exit_env>
}
  8001a5:	90                   	nop
  8001a6:	c9                   	leave  
  8001a7:	c3                   	ret    

008001a8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001ae:	8d 45 10             	lea    0x10(%ebp),%eax
  8001b1:	83 c0 04             	add    $0x4,%eax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001b7:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001bc:	85 c0                	test   %eax,%eax
  8001be:	74 16                	je     8001d6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001c0:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	50                   	push   %eax
  8001c9:	68 14 1c 80 00       	push   $0x801c14
  8001ce:	e8 92 02 00 00       	call   800465 <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001d6:	a1 00 30 80 00       	mov    0x803000,%eax
  8001db:	ff 75 0c             	pushl  0xc(%ebp)
  8001de:	ff 75 08             	pushl  0x8(%ebp)
  8001e1:	50                   	push   %eax
  8001e2:	68 19 1c 80 00       	push   $0x801c19
  8001e7:	e8 79 02 00 00       	call   800465 <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	e8 fc 01 00 00       	call   8003fa <vcprintf>
  8001fe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	6a 00                	push   $0x0
  800206:	68 35 1c 80 00       	push   $0x801c35
  80020b:	e8 ea 01 00 00       	call   8003fa <vcprintf>
  800210:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800213:	e8 82 ff ff ff       	call   80019a <exit>

	// should not return here
	while (1) ;
  800218:	eb fe                	jmp    800218 <_panic+0x70>

0080021a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800220:	a1 04 30 80 00       	mov    0x803004,%eax
  800225:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80022b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022e:	39 c2                	cmp    %eax,%edx
  800230:	74 14                	je     800246 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 38 1c 80 00       	push   $0x801c38
  80023a:	6a 26                	push   $0x26
  80023c:	68 84 1c 80 00       	push   $0x801c84
  800241:	e8 62 ff ff ff       	call   8001a8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800246:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80024d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800254:	e9 c5 00 00 00       	jmp    80031e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80025c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800263:	8b 45 08             	mov    0x8(%ebp),%eax
  800266:	01 d0                	add    %edx,%eax
  800268:	8b 00                	mov    (%eax),%eax
  80026a:	85 c0                	test   %eax,%eax
  80026c:	75 08                	jne    800276 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80026e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800271:	e9 a5 00 00 00       	jmp    80031b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800276:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80027d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800284:	eb 69                	jmp    8002ef <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800286:	a1 04 30 80 00       	mov    0x803004,%eax
  80028b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800291:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800294:	89 d0                	mov    %edx,%eax
  800296:	01 c0                	add    %eax,%eax
  800298:	01 d0                	add    %edx,%eax
  80029a:	c1 e0 03             	shl    $0x3,%eax
  80029d:	01 c8                	add    %ecx,%eax
  80029f:	8a 40 04             	mov    0x4(%eax),%al
  8002a2:	84 c0                	test   %al,%al
  8002a4:	75 46                	jne    8002ec <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002a6:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ab:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8002b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002b4:	89 d0                	mov    %edx,%eax
  8002b6:	01 c0                	add    %eax,%eax
  8002b8:	01 d0                	add    %edx,%eax
  8002ba:	c1 e0 03             	shl    $0x3,%eax
  8002bd:	01 c8                	add    %ecx,%eax
  8002bf:	8b 00                	mov    (%eax),%eax
  8002c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002cc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002db:	01 c8                	add    %ecx,%eax
  8002dd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002df:	39 c2                	cmp    %eax,%edx
  8002e1:	75 09                	jne    8002ec <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002e3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002ea:	eb 15                	jmp    800301 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002ec:	ff 45 e8             	incl   -0x18(%ebp)
  8002ef:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	77 85                	ja     800286 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800301:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800305:	75 14                	jne    80031b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800307:	83 ec 04             	sub    $0x4,%esp
  80030a:	68 90 1c 80 00       	push   $0x801c90
  80030f:	6a 3a                	push   $0x3a
  800311:	68 84 1c 80 00       	push   $0x801c84
  800316:	e8 8d fe ff ff       	call   8001a8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80031b:	ff 45 f0             	incl   -0x10(%ebp)
  80031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800321:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800324:	0f 8c 2f ff ff ff    	jl     800259 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80032a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800331:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800338:	eb 26                	jmp    800360 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80033a:	a1 04 30 80 00       	mov    0x803004,%eax
  80033f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800345:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800348:	89 d0                	mov    %edx,%eax
  80034a:	01 c0                	add    %eax,%eax
  80034c:	01 d0                	add    %edx,%eax
  80034e:	c1 e0 03             	shl    $0x3,%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8a 40 04             	mov    0x4(%eax),%al
  800356:	3c 01                	cmp    $0x1,%al
  800358:	75 03                	jne    80035d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80035a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035d:	ff 45 e0             	incl   -0x20(%ebp)
  800360:	a1 04 30 80 00       	mov    0x803004,%eax
  800365:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80036b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036e:	39 c2                	cmp    %eax,%edx
  800370:	77 c8                	ja     80033a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800375:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800378:	74 14                	je     80038e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80037a:	83 ec 04             	sub    $0x4,%esp
  80037d:	68 e4 1c 80 00       	push   $0x801ce4
  800382:	6a 44                	push   $0x44
  800384:	68 84 1c 80 00       	push   $0x801c84
  800389:	e8 1a fe ff ff       	call   8001a8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80038e:	90                   	nop
  80038f:	c9                   	leave  
  800390:	c3                   	ret    

00800391 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039a:	8b 00                	mov    (%eax),%eax
  80039c:	8d 48 01             	lea    0x1(%eax),%ecx
  80039f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a2:	89 0a                	mov    %ecx,(%edx)
  8003a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a7:	88 d1                	mov    %dl,%cl
  8003a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ac:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ba:	75 2c                	jne    8003e8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003bc:	a0 08 30 80 00       	mov    0x803008,%al
  8003c1:	0f b6 c0             	movzbl %al,%eax
  8003c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c7:	8b 12                	mov    (%edx),%edx
  8003c9:	89 d1                	mov    %edx,%ecx
  8003cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ce:	83 c2 08             	add    $0x8,%edx
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	50                   	push   %eax
  8003d5:	51                   	push   %ecx
  8003d6:	52                   	push   %edx
  8003d7:	e8 4e 0e 00 00       	call   80122a <sys_cputs>
  8003dc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003eb:	8b 40 04             	mov    0x4(%eax),%eax
  8003ee:	8d 50 01             	lea    0x1(%eax),%edx
  8003f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003f7:	90                   	nop
  8003f8:	c9                   	leave  
  8003f9:	c3                   	ret    

008003fa <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800403:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80040a:	00 00 00 
	b.cnt = 0;
  80040d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800414:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800417:	ff 75 0c             	pushl  0xc(%ebp)
  80041a:	ff 75 08             	pushl  0x8(%ebp)
  80041d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800423:	50                   	push   %eax
  800424:	68 91 03 80 00       	push   $0x800391
  800429:	e8 11 02 00 00       	call   80063f <vprintfmt>
  80042e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800431:	a0 08 30 80 00       	mov    0x803008,%al
  800436:	0f b6 c0             	movzbl %al,%eax
  800439:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80043f:	83 ec 04             	sub    $0x4,%esp
  800442:	50                   	push   %eax
  800443:	52                   	push   %edx
  800444:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80044a:	83 c0 08             	add    $0x8,%eax
  80044d:	50                   	push   %eax
  80044e:	e8 d7 0d 00 00       	call   80122a <sys_cputs>
  800453:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800456:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80045d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
  800468:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80046b:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800472:	8d 45 0c             	lea    0xc(%ebp),%eax
  800475:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 f4             	pushl  -0xc(%ebp)
  800481:	50                   	push   %eax
  800482:	e8 73 ff ff ff       	call   8003fa <vcprintf>
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80048d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800490:	c9                   	leave  
  800491:	c3                   	ret    

00800492 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800498:	e8 cf 0d 00 00       	call   80126c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80049d:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ac:	50                   	push   %eax
  8004ad:	e8 48 ff ff ff       	call   8003fa <vcprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp
  8004b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004b8:	e8 c9 0d 00 00       	call   801286 <sys_unlock_cons>
	return cnt;
  8004bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004c0:	c9                   	leave  
  8004c1:	c3                   	ret    

008004c2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	53                   	push   %ebx
  8004c6:	83 ec 14             	sub    $0x14,%esp
  8004c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004dd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e0:	77 55                	ja     800537 <printnum+0x75>
  8004e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e5:	72 05                	jb     8004ec <printnum+0x2a>
  8004e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004ea:	77 4b                	ja     800537 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ec:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004ef:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fa:	52                   	push   %edx
  8004fb:	50                   	push   %eax
  8004fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800502:	e8 21 13 00 00       	call   801828 <__udivdi3>
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	83 ec 04             	sub    $0x4,%esp
  80050d:	ff 75 20             	pushl  0x20(%ebp)
  800510:	53                   	push   %ebx
  800511:	ff 75 18             	pushl  0x18(%ebp)
  800514:	52                   	push   %edx
  800515:	50                   	push   %eax
  800516:	ff 75 0c             	pushl  0xc(%ebp)
  800519:	ff 75 08             	pushl  0x8(%ebp)
  80051c:	e8 a1 ff ff ff       	call   8004c2 <printnum>
  800521:	83 c4 20             	add    $0x20,%esp
  800524:	eb 1a                	jmp    800540 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	ff 75 0c             	pushl  0xc(%ebp)
  80052c:	ff 75 20             	pushl  0x20(%ebp)
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	ff d0                	call   *%eax
  800534:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800537:	ff 4d 1c             	decl   0x1c(%ebp)
  80053a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80053e:	7f e6                	jg     800526 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800540:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800543:	bb 00 00 00 00       	mov    $0x0,%ebx
  800548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80054e:	53                   	push   %ebx
  80054f:	51                   	push   %ecx
  800550:	52                   	push   %edx
  800551:	50                   	push   %eax
  800552:	e8 e1 13 00 00       	call   801938 <__umoddi3>
  800557:	83 c4 10             	add    $0x10,%esp
  80055a:	05 54 1f 80 00       	add    $0x801f54,%eax
  80055f:	8a 00                	mov    (%eax),%al
  800561:	0f be c0             	movsbl %al,%eax
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	ff 75 0c             	pushl  0xc(%ebp)
  80056a:	50                   	push   %eax
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	ff d0                	call   *%eax
  800570:	83 c4 10             	add    $0x10,%esp
}
  800573:	90                   	nop
  800574:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800577:	c9                   	leave  
  800578:	c3                   	ret    

00800579 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800579:	55                   	push   %ebp
  80057a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80057c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800580:	7e 1c                	jle    80059e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	8b 00                	mov    (%eax),%eax
  800587:	8d 50 08             	lea    0x8(%eax),%edx
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	89 10                	mov    %edx,(%eax)
  80058f:	8b 45 08             	mov    0x8(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	83 e8 08             	sub    $0x8,%eax
  800597:	8b 50 04             	mov    0x4(%eax),%edx
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	eb 40                	jmp    8005de <getuint+0x65>
	else if (lflag)
  80059e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005a2:	74 1e                	je     8005c2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	8d 50 04             	lea    0x4(%eax),%edx
  8005ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8005af:	89 10                	mov    %edx,(%eax)
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	83 e8 04             	sub    $0x4,%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	eb 1c                	jmp    8005de <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	89 10                	mov    %edx,(%eax)
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	83 e8 04             	sub    $0x4,%eax
  8005d7:	8b 00                	mov    (%eax),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005de:	5d                   	pop    %ebp
  8005df:	c3                   	ret    

008005e0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005e7:	7e 1c                	jle    800605 <getint+0x25>
		return va_arg(*ap, long long);
  8005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	8d 50 08             	lea    0x8(%eax),%edx
  8005f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f4:	89 10                	mov    %edx,(%eax)
  8005f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f9:	8b 00                	mov    (%eax),%eax
  8005fb:	83 e8 08             	sub    $0x8,%eax
  8005fe:	8b 50 04             	mov    0x4(%eax),%edx
  800601:	8b 00                	mov    (%eax),%eax
  800603:	eb 38                	jmp    80063d <getint+0x5d>
	else if (lflag)
  800605:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800609:	74 1a                	je     800625 <getint+0x45>
		return va_arg(*ap, long);
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	8d 50 04             	lea    0x4(%eax),%edx
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	89 10                	mov    %edx,(%eax)
  800618:	8b 45 08             	mov    0x8(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	83 e8 04             	sub    $0x4,%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	99                   	cltd   
  800623:	eb 18                	jmp    80063d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	8d 50 04             	lea    0x4(%eax),%edx
  80062d:	8b 45 08             	mov    0x8(%ebp),%eax
  800630:	89 10                	mov    %edx,(%eax)
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	83 e8 04             	sub    $0x4,%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	99                   	cltd   
}
  80063d:	5d                   	pop    %ebp
  80063e:	c3                   	ret    

0080063f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
  800642:	56                   	push   %esi
  800643:	53                   	push   %ebx
  800644:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800647:	eb 17                	jmp    800660 <vprintfmt+0x21>
			if (ch == '\0')
  800649:	85 db                	test   %ebx,%ebx
  80064b:	0f 84 c1 03 00 00    	je     800a12 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	ff 75 0c             	pushl  0xc(%ebp)
  800657:	53                   	push   %ebx
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	ff d0                	call   *%eax
  80065d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800660:	8b 45 10             	mov    0x10(%ebp),%eax
  800663:	8d 50 01             	lea    0x1(%eax),%edx
  800666:	89 55 10             	mov    %edx,0x10(%ebp)
  800669:	8a 00                	mov    (%eax),%al
  80066b:	0f b6 d8             	movzbl %al,%ebx
  80066e:	83 fb 25             	cmp    $0x25,%ebx
  800671:	75 d6                	jne    800649 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800673:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800677:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80067e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800685:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80068c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800693:	8b 45 10             	mov    0x10(%ebp),%eax
  800696:	8d 50 01             	lea    0x1(%eax),%edx
  800699:	89 55 10             	mov    %edx,0x10(%ebp)
  80069c:	8a 00                	mov    (%eax),%al
  80069e:	0f b6 d8             	movzbl %al,%ebx
  8006a1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006a4:	83 f8 5b             	cmp    $0x5b,%eax
  8006a7:	0f 87 3d 03 00 00    	ja     8009ea <vprintfmt+0x3ab>
  8006ad:	8b 04 85 78 1f 80 00 	mov    0x801f78(,%eax,4),%eax
  8006b4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006ba:	eb d7                	jmp    800693 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006bc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006c0:	eb d1                	jmp    800693 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006cc:	89 d0                	mov    %edx,%eax
  8006ce:	c1 e0 02             	shl    $0x2,%eax
  8006d1:	01 d0                	add    %edx,%eax
  8006d3:	01 c0                	add    %eax,%eax
  8006d5:	01 d8                	add    %ebx,%eax
  8006d7:	83 e8 30             	sub    $0x30,%eax
  8006da:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e0:	8a 00                	mov    (%eax),%al
  8006e2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e5:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e8:	7e 3e                	jle    800728 <vprintfmt+0xe9>
  8006ea:	83 fb 39             	cmp    $0x39,%ebx
  8006ed:	7f 39                	jg     800728 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ef:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f2:	eb d5                	jmp    8006c9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	83 c0 04             	add    $0x4,%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	83 e8 04             	sub    $0x4,%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800708:	eb 1f                	jmp    800729 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80070a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070e:	79 83                	jns    800693 <vprintfmt+0x54>
				width = 0;
  800710:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800717:	e9 77 ff ff ff       	jmp    800693 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80071c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800723:	e9 6b ff ff ff       	jmp    800693 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800728:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800729:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072d:	0f 89 60 ff ff ff    	jns    800693 <vprintfmt+0x54>
				width = precision, precision = -1;
  800733:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800739:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800740:	e9 4e ff ff ff       	jmp    800693 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800745:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800748:	e9 46 ff ff ff       	jmp    800693 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	83 c0 04             	add    $0x4,%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	83 e8 04             	sub    $0x4,%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	50                   	push   %eax
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	ff d0                	call   *%eax
  80076a:	83 c4 10             	add    $0x10,%esp
			break;
  80076d:	e9 9b 02 00 00       	jmp    800a0d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	83 c0 04             	add    $0x4,%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	83 e8 04             	sub    $0x4,%eax
  800781:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800783:	85 db                	test   %ebx,%ebx
  800785:	79 02                	jns    800789 <vprintfmt+0x14a>
				err = -err;
  800787:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800789:	83 fb 64             	cmp    $0x64,%ebx
  80078c:	7f 0b                	jg     800799 <vprintfmt+0x15a>
  80078e:	8b 34 9d c0 1d 80 00 	mov    0x801dc0(,%ebx,4),%esi
  800795:	85 f6                	test   %esi,%esi
  800797:	75 19                	jne    8007b2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800799:	53                   	push   %ebx
  80079a:	68 65 1f 80 00       	push   $0x801f65
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	ff 75 08             	pushl  0x8(%ebp)
  8007a5:	e8 70 02 00 00       	call   800a1a <printfmt>
  8007aa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007ad:	e9 5b 02 00 00       	jmp    800a0d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007b2:	56                   	push   %esi
  8007b3:	68 6e 1f 80 00       	push   $0x801f6e
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	ff 75 08             	pushl  0x8(%ebp)
  8007be:	e8 57 02 00 00       	call   800a1a <printfmt>
  8007c3:	83 c4 10             	add    $0x10,%esp
			break;
  8007c6:	e9 42 02 00 00       	jmp    800a0d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 c0 04             	add    $0x4,%eax
  8007d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	83 e8 04             	sub    $0x4,%eax
  8007da:	8b 30                	mov    (%eax),%esi
  8007dc:	85 f6                	test   %esi,%esi
  8007de:	75 05                	jne    8007e5 <vprintfmt+0x1a6>
				p = "(null)";
  8007e0:	be 71 1f 80 00       	mov    $0x801f71,%esi
			if (width > 0 && padc != '-')
  8007e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e9:	7e 6d                	jle    800858 <vprintfmt+0x219>
  8007eb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007ef:	74 67                	je     800858 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	50                   	push   %eax
  8007f8:	56                   	push   %esi
  8007f9:	e8 1e 03 00 00       	call   800b1c <strnlen>
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800804:	eb 16                	jmp    80081c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800806:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	50                   	push   %eax
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800819:	ff 4d e4             	decl   -0x1c(%ebp)
  80081c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800820:	7f e4                	jg     800806 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800822:	eb 34                	jmp    800858 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800824:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800828:	74 1c                	je     800846 <vprintfmt+0x207>
  80082a:	83 fb 1f             	cmp    $0x1f,%ebx
  80082d:	7e 05                	jle    800834 <vprintfmt+0x1f5>
  80082f:	83 fb 7e             	cmp    $0x7e,%ebx
  800832:	7e 12                	jle    800846 <vprintfmt+0x207>
					putch('?', putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	6a 3f                	push   $0x3f
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	ff d0                	call   *%eax
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	eb 0f                	jmp    800855 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	53                   	push   %ebx
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	ff d0                	call   *%eax
  800852:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800855:	ff 4d e4             	decl   -0x1c(%ebp)
  800858:	89 f0                	mov    %esi,%eax
  80085a:	8d 70 01             	lea    0x1(%eax),%esi
  80085d:	8a 00                	mov    (%eax),%al
  80085f:	0f be d8             	movsbl %al,%ebx
  800862:	85 db                	test   %ebx,%ebx
  800864:	74 24                	je     80088a <vprintfmt+0x24b>
  800866:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086a:	78 b8                	js     800824 <vprintfmt+0x1e5>
  80086c:	ff 4d e0             	decl   -0x20(%ebp)
  80086f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800873:	79 af                	jns    800824 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800875:	eb 13                	jmp    80088a <vprintfmt+0x24b>
				putch(' ', putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	6a 20                	push   $0x20
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	ff d0                	call   *%eax
  800884:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800887:	ff 4d e4             	decl   -0x1c(%ebp)
  80088a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088e:	7f e7                	jg     800877 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800890:	e9 78 01 00 00       	jmp    800a0d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	ff 75 e8             	pushl  -0x18(%ebp)
  80089b:	8d 45 14             	lea    0x14(%ebp),%eax
  80089e:	50                   	push   %eax
  80089f:	e8 3c fd ff ff       	call   8005e0 <getint>
  8008a4:	83 c4 10             	add    $0x10,%esp
  8008a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b3:	85 d2                	test   %edx,%edx
  8008b5:	79 23                	jns    8008da <vprintfmt+0x29b>
				putch('-', putdat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	6a 2d                	push   $0x2d
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	ff d0                	call   *%eax
  8008c4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cd:	f7 d8                	neg    %eax
  8008cf:	83 d2 00             	adc    $0x0,%edx
  8008d2:	f7 da                	neg    %edx
  8008d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008da:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008e1:	e9 bc 00 00 00       	jmp    8009a2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ef:	50                   	push   %eax
  8008f0:	e8 84 fc ff ff       	call   800579 <getuint>
  8008f5:	83 c4 10             	add    $0x10,%esp
  8008f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008fe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800905:	e9 98 00 00 00       	jmp    8009a2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80090a:	83 ec 08             	sub    $0x8,%esp
  80090d:	ff 75 0c             	pushl  0xc(%ebp)
  800910:	6a 58                	push   $0x58
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	6a 58                	push   $0x58
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	6a 58                	push   $0x58
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			break;
  80093a:	e9 ce 00 00 00       	jmp    800a0d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	6a 30                	push   $0x30
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	ff d0                	call   *%eax
  80094c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	ff 75 0c             	pushl  0xc(%ebp)
  800955:	6a 78                	push   $0x78
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	ff d0                	call   *%eax
  80095c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80095f:	8b 45 14             	mov    0x14(%ebp),%eax
  800962:	83 c0 04             	add    $0x4,%eax
  800965:	89 45 14             	mov    %eax,0x14(%ebp)
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	83 e8 04             	sub    $0x4,%eax
  80096e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800970:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800973:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80097a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800981:	eb 1f                	jmp    8009a2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 e8             	pushl  -0x18(%ebp)
  800989:	8d 45 14             	lea    0x14(%ebp),%eax
  80098c:	50                   	push   %eax
  80098d:	e8 e7 fb ff ff       	call   800579 <getuint>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800998:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80099b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009a2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a9:	83 ec 04             	sub    $0x4,%esp
  8009ac:	52                   	push   %edx
  8009ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009b0:	50                   	push   %eax
  8009b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	ff 75 08             	pushl  0x8(%ebp)
  8009bd:	e8 00 fb ff ff       	call   8004c2 <printnum>
  8009c2:	83 c4 20             	add    $0x20,%esp
			break;
  8009c5:	eb 46                	jmp    800a0d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	53                   	push   %ebx
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
			break;
  8009d6:	eb 35                	jmp    800a0d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009d8:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009df:	eb 2c                	jmp    800a0d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009e1:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009e8:	eb 23                	jmp    800a0d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 25                	push   $0x25
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009fa:	ff 4d 10             	decl   0x10(%ebp)
  8009fd:	eb 03                	jmp    800a02 <vprintfmt+0x3c3>
  8009ff:	ff 4d 10             	decl   0x10(%ebp)
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	48                   	dec    %eax
  800a06:	8a 00                	mov    (%eax),%al
  800a08:	3c 25                	cmp    $0x25,%al
  800a0a:	75 f3                	jne    8009ff <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a0c:	90                   	nop
		}
	}
  800a0d:	e9 35 fc ff ff       	jmp    800647 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a12:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a16:	5b                   	pop    %ebx
  800a17:	5e                   	pop    %esi
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a20:	8d 45 10             	lea    0x10(%ebp),%eax
  800a23:	83 c0 04             	add    $0x4,%eax
  800a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a29:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2f:	50                   	push   %eax
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	ff 75 08             	pushl  0x8(%ebp)
  800a36:	e8 04 fc ff ff       	call   80063f <vprintfmt>
  800a3b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a3e:	90                   	nop
  800a3f:	c9                   	leave  
  800a40:	c3                   	ret    

00800a41 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	8b 40 08             	mov    0x8(%eax),%eax
  800a4a:	8d 50 01             	lea    0x1(%eax),%edx
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a56:	8b 10                	mov    (%eax),%edx
  800a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5b:	8b 40 04             	mov    0x4(%eax),%eax
  800a5e:	39 c2                	cmp    %eax,%edx
  800a60:	73 12                	jae    800a74 <sprintputch+0x33>
		*b->buf++ = ch;
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a65:	8b 00                	mov    (%eax),%eax
  800a67:	8d 48 01             	lea    0x1(%eax),%ecx
  800a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6d:	89 0a                	mov    %ecx,(%edx)
  800a6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800a72:	88 10                	mov    %dl,(%eax)
}
  800a74:	90                   	nop
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	01 d0                	add    %edx,%eax
  800a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a9c:	74 06                	je     800aa4 <vsnprintf+0x2d>
  800a9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa2:	7f 07                	jg     800aab <vsnprintf+0x34>
		return -E_INVAL;
  800aa4:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa9:	eb 20                	jmp    800acb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aab:	ff 75 14             	pushl  0x14(%ebp)
  800aae:	ff 75 10             	pushl  0x10(%ebp)
  800ab1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ab4:	50                   	push   %eax
  800ab5:	68 41 0a 80 00       	push   $0x800a41
  800aba:	e8 80 fb ff ff       	call   80063f <vprintfmt>
  800abf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ad3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad6:	83 c0 04             	add    $0x4,%eax
  800ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800adc:	8b 45 10             	mov    0x10(%ebp),%eax
  800adf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae2:	50                   	push   %eax
  800ae3:	ff 75 0c             	pushl  0xc(%ebp)
  800ae6:	ff 75 08             	pushl  0x8(%ebp)
  800ae9:	e8 89 ff ff ff       	call   800a77 <vsnprintf>
  800aee:	83 c4 10             	add    $0x10,%esp
  800af1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af7:	c9                   	leave  
  800af8:	c3                   	ret    

00800af9 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800aff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b06:	eb 06                	jmp    800b0e <strlen+0x15>
		n++;
  800b08:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0b:	ff 45 08             	incl   0x8(%ebp)
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	84 c0                	test   %al,%al
  800b15:	75 f1                	jne    800b08 <strlen+0xf>
		n++;
	return n;
  800b17:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b29:	eb 09                	jmp    800b34 <strnlen+0x18>
		n++;
  800b2b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2e:	ff 45 08             	incl   0x8(%ebp)
  800b31:	ff 4d 0c             	decl   0xc(%ebp)
  800b34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b38:	74 09                	je     800b43 <strnlen+0x27>
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8a 00                	mov    (%eax),%al
  800b3f:	84 c0                	test   %al,%al
  800b41:	75 e8                	jne    800b2b <strnlen+0xf>
		n++;
	return n;
  800b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b54:	90                   	nop
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8d 50 01             	lea    0x1(%eax),%edx
  800b5b:	89 55 08             	mov    %edx,0x8(%ebp)
  800b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b61:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b64:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b67:	8a 12                	mov    (%edx),%dl
  800b69:	88 10                	mov    %dl,(%eax)
  800b6b:	8a 00                	mov    (%eax),%al
  800b6d:	84 c0                	test   %al,%al
  800b6f:	75 e4                	jne    800b55 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b89:	eb 1f                	jmp    800baa <strncpy+0x34>
		*dst++ = *src;
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8d 50 01             	lea    0x1(%eax),%edx
  800b91:	89 55 08             	mov    %edx,0x8(%ebp)
  800b94:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b97:	8a 12                	mov    (%edx),%dl
  800b99:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	84 c0                	test   %al,%al
  800ba2:	74 03                	je     800ba7 <strncpy+0x31>
			src++;
  800ba4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba7:	ff 45 fc             	incl   -0x4(%ebp)
  800baa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bad:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bb0:	72 d9                	jb     800b8b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bb5:	c9                   	leave  
  800bb6:	c3                   	ret    

00800bb7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc7:	74 30                	je     800bf9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bc9:	eb 16                	jmp    800be1 <strlcpy+0x2a>
			*dst++ = *src++;
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8d 50 01             	lea    0x1(%eax),%edx
  800bd1:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bda:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bdd:	8a 12                	mov    (%edx),%dl
  800bdf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800be1:	ff 4d 10             	decl   0x10(%ebp)
  800be4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be8:	74 09                	je     800bf3 <strlcpy+0x3c>
  800bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bed:	8a 00                	mov    (%eax),%al
  800bef:	84 c0                	test   %al,%al
  800bf1:	75 d8                	jne    800bcb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bff:	29 c2                	sub    %eax,%edx
  800c01:	89 d0                	mov    %edx,%eax
}
  800c03:	c9                   	leave  
  800c04:	c3                   	ret    

00800c05 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c08:	eb 06                	jmp    800c10 <strcmp+0xb>
		p++, q++;
  800c0a:	ff 45 08             	incl   0x8(%ebp)
  800c0d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	84 c0                	test   %al,%al
  800c17:	74 0e                	je     800c27 <strcmp+0x22>
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 10                	mov    (%eax),%dl
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	38 c2                	cmp    %al,%dl
  800c25:	74 e3                	je     800c0a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	0f b6 d0             	movzbl %al,%edx
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8a 00                	mov    (%eax),%al
  800c34:	0f b6 c0             	movzbl %al,%eax
  800c37:	29 c2                	sub    %eax,%edx
  800c39:	89 d0                	mov    %edx,%eax
}
  800c3b:	5d                   	pop    %ebp
  800c3c:	c3                   	ret    

00800c3d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c40:	eb 09                	jmp    800c4b <strncmp+0xe>
		n--, p++, q++;
  800c42:	ff 4d 10             	decl   0x10(%ebp)
  800c45:	ff 45 08             	incl   0x8(%ebp)
  800c48:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4f:	74 17                	je     800c68 <strncmp+0x2b>
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8a 00                	mov    (%eax),%al
  800c56:	84 c0                	test   %al,%al
  800c58:	74 0e                	je     800c68 <strncmp+0x2b>
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8a 10                	mov    (%eax),%dl
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	8a 00                	mov    (%eax),%al
  800c64:	38 c2                	cmp    %al,%dl
  800c66:	74 da                	je     800c42 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6c:	75 07                	jne    800c75 <strncmp+0x38>
		return 0;
  800c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c73:	eb 14                	jmp    800c89 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	0f b6 d0             	movzbl %al,%edx
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8a 00                	mov    (%eax),%al
  800c82:	0f b6 c0             	movzbl %al,%eax
  800c85:	29 c2                	sub    %eax,%edx
  800c87:	89 d0                	mov    %edx,%eax
}
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	83 ec 04             	sub    $0x4,%esp
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c97:	eb 12                	jmp    800cab <strchr+0x20>
		if (*s == c)
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ca1:	75 05                	jne    800ca8 <strchr+0x1d>
			return (char *) s;
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	eb 11                	jmp    800cb9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ca8:	ff 45 08             	incl   0x8(%ebp)
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	84 c0                	test   %al,%al
  800cb2:	75 e5                	jne    800c99 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 04             	sub    $0x4,%esp
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cc7:	eb 0d                	jmp    800cd6 <strfind+0x1b>
		if (*s == c)
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cd1:	74 0e                	je     800ce1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd3:	ff 45 08             	incl   0x8(%ebp)
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	84 c0                	test   %al,%al
  800cdd:	75 ea                	jne    800cc9 <strfind+0xe>
  800cdf:	eb 01                	jmp    800ce2 <strfind+0x27>
		if (*s == c)
			break;
  800ce1:	90                   	nop
	return (char *) s;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cf9:	eb 0e                	jmp    800d09 <memset+0x22>
		*p++ = c;
  800cfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfe:	8d 50 01             	lea    0x1(%eax),%edx
  800d01:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d07:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d09:	ff 4d f8             	decl   -0x8(%ebp)
  800d0c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d10:	79 e9                	jns    800cfb <memset+0x14>
		*p++ = c;

	return v;
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d15:	c9                   	leave  
  800d16:	c3                   	ret    

00800d17 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d29:	eb 16                	jmp    800d41 <memcpy+0x2a>
		*d++ = *s++;
  800d2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2e:	8d 50 01             	lea    0x1(%eax),%edx
  800d31:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d34:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d37:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d3d:	8a 12                	mov    (%edx),%dl
  800d3f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d41:	8b 45 10             	mov    0x10(%ebp),%eax
  800d44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d47:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4a:	85 c0                	test   %eax,%eax
  800d4c:	75 dd                	jne    800d2b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6b:	73 50                	jae    800dbd <memmove+0x6a>
  800d6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d70:	8b 45 10             	mov    0x10(%ebp),%eax
  800d73:	01 d0                	add    %edx,%eax
  800d75:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d78:	76 43                	jbe    800dbd <memmove+0x6a>
		s += n;
  800d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d80:	8b 45 10             	mov    0x10(%ebp),%eax
  800d83:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d86:	eb 10                	jmp    800d98 <memmove+0x45>
			*--d = *--s;
  800d88:	ff 4d f8             	decl   -0x8(%ebp)
  800d8b:	ff 4d fc             	decl   -0x4(%ebp)
  800d8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d91:	8a 10                	mov    (%eax),%dl
  800d93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d96:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d98:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9e:	89 55 10             	mov    %edx,0x10(%ebp)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	75 e3                	jne    800d88 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da5:	eb 23                	jmp    800dca <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800da7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800daa:	8d 50 01             	lea    0x1(%eax),%edx
  800dad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db9:	8a 12                	mov    (%edx),%dl
  800dbb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc3:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc6:	85 c0                	test   %eax,%eax
  800dc8:	75 dd                	jne    800da7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dde:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800de1:	eb 2a                	jmp    800e0d <memcmp+0x3e>
		if (*s1 != *s2)
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de6:	8a 10                	mov    (%eax),%dl
  800de8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	38 c2                	cmp    %al,%dl
  800def:	74 16                	je     800e07 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800df1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	0f b6 d0             	movzbl %al,%edx
  800df9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfc:	8a 00                	mov    (%eax),%al
  800dfe:	0f b6 c0             	movzbl %al,%eax
  800e01:	29 c2                	sub    %eax,%edx
  800e03:	89 d0                	mov    %edx,%eax
  800e05:	eb 18                	jmp    800e1f <memcmp+0x50>
		s1++, s2++;
  800e07:	ff 45 fc             	incl   -0x4(%ebp)
  800e0a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e13:	89 55 10             	mov    %edx,0x10(%ebp)
  800e16:	85 c0                	test   %eax,%eax
  800e18:	75 c9                	jne    800de3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1f:	c9                   	leave  
  800e20:	c3                   	ret    

00800e21 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e27:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2d:	01 d0                	add    %edx,%eax
  800e2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e32:	eb 15                	jmp    800e49 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	0f b6 d0             	movzbl %al,%edx
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	0f b6 c0             	movzbl %al,%eax
  800e42:	39 c2                	cmp    %eax,%edx
  800e44:	74 0d                	je     800e53 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e46:	ff 45 08             	incl   0x8(%ebp)
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e4f:	72 e3                	jb     800e34 <memfind+0x13>
  800e51:	eb 01                	jmp    800e54 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e53:	90                   	nop
	return (void *) s;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e66:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6d:	eb 03                	jmp    800e72 <strtol+0x19>
		s++;
  800e6f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	3c 20                	cmp    $0x20,%al
  800e79:	74 f4                	je     800e6f <strtol+0x16>
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	3c 09                	cmp    $0x9,%al
  800e82:	74 eb                	je     800e6f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	3c 2b                	cmp    $0x2b,%al
  800e8b:	75 05                	jne    800e92 <strtol+0x39>
		s++;
  800e8d:	ff 45 08             	incl   0x8(%ebp)
  800e90:	eb 13                	jmp    800ea5 <strtol+0x4c>
	else if (*s == '-')
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	3c 2d                	cmp    $0x2d,%al
  800e99:	75 0a                	jne    800ea5 <strtol+0x4c>
		s++, neg = 1;
  800e9b:	ff 45 08             	incl   0x8(%ebp)
  800e9e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea9:	74 06                	je     800eb1 <strtol+0x58>
  800eab:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eaf:	75 20                	jne    800ed1 <strtol+0x78>
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	3c 30                	cmp    $0x30,%al
  800eb8:	75 17                	jne    800ed1 <strtol+0x78>
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	40                   	inc    %eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	3c 78                	cmp    $0x78,%al
  800ec2:	75 0d                	jne    800ed1 <strtol+0x78>
		s += 2, base = 16;
  800ec4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ec8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ecf:	eb 28                	jmp    800ef9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ed1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed5:	75 15                	jne    800eec <strtol+0x93>
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	3c 30                	cmp    $0x30,%al
  800ede:	75 0c                	jne    800eec <strtol+0x93>
		s++, base = 8;
  800ee0:	ff 45 08             	incl   0x8(%ebp)
  800ee3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800eea:	eb 0d                	jmp    800ef9 <strtol+0xa0>
	else if (base == 0)
  800eec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef0:	75 07                	jne    800ef9 <strtol+0xa0>
		base = 10;
  800ef2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	3c 2f                	cmp    $0x2f,%al
  800f00:	7e 19                	jle    800f1b <strtol+0xc2>
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3c 39                	cmp    $0x39,%al
  800f09:	7f 10                	jg     800f1b <strtol+0xc2>
			dig = *s - '0';
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	0f be c0             	movsbl %al,%eax
  800f13:	83 e8 30             	sub    $0x30,%eax
  800f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f19:	eb 42                	jmp    800f5d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 60                	cmp    $0x60,%al
  800f22:	7e 19                	jle    800f3d <strtol+0xe4>
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	3c 7a                	cmp    $0x7a,%al
  800f2b:	7f 10                	jg     800f3d <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	0f be c0             	movsbl %al,%eax
  800f35:	83 e8 57             	sub    $0x57,%eax
  800f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f3b:	eb 20                	jmp    800f5d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	3c 40                	cmp    $0x40,%al
  800f44:	7e 39                	jle    800f7f <strtol+0x126>
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	3c 5a                	cmp    $0x5a,%al
  800f4d:	7f 30                	jg     800f7f <strtol+0x126>
			dig = *s - 'A' + 10;
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	0f be c0             	movsbl %al,%eax
  800f57:	83 e8 37             	sub    $0x37,%eax
  800f5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f60:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f63:	7d 19                	jge    800f7e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f65:	ff 45 08             	incl   0x8(%ebp)
  800f68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f6f:	89 c2                	mov    %eax,%edx
  800f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f74:	01 d0                	add    %edx,%eax
  800f76:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f79:	e9 7b ff ff ff       	jmp    800ef9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f7e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f83:	74 08                	je     800f8d <strtol+0x134>
		*endptr = (char *) s;
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f91:	74 07                	je     800f9a <strtol+0x141>
  800f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f96:	f7 d8                	neg    %eax
  800f98:	eb 03                	jmp    800f9d <strtol+0x144>
  800f9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <ltostr>:

void
ltostr(long value, char *str)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fb7:	79 13                	jns    800fcc <ltostr+0x2d>
	{
		neg = 1;
  800fb9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fc6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fc9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fd4:	99                   	cltd   
  800fd5:	f7 f9                	idiv   %ecx
  800fd7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdd:	8d 50 01             	lea    0x1(%eax),%edx
  800fe0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe3:	89 c2                	mov    %eax,%edx
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	01 d0                	add    %edx,%eax
  800fea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fed:	83 c2 30             	add    $0x30,%edx
  800ff0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ff2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ffa:	f7 e9                	imul   %ecx
  800ffc:	c1 fa 02             	sar    $0x2,%edx
  800fff:	89 c8                	mov    %ecx,%eax
  801001:	c1 f8 1f             	sar    $0x1f,%eax
  801004:	29 c2                	sub    %eax,%edx
  801006:	89 d0                	mov    %edx,%eax
  801008:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80100b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100f:	75 bb                	jne    800fcc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801011:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801018:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101b:	48                   	dec    %eax
  80101c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80101f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801023:	74 3d                	je     801062 <ltostr+0xc3>
		start = 1 ;
  801025:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102c:	eb 34                	jmp    801062 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80102e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801031:	8b 45 0c             	mov    0xc(%ebp),%eax
  801034:	01 d0                	add    %edx,%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	01 c2                	add    %eax,%edx
  801043:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	01 c8                	add    %ecx,%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80104f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	01 c2                	add    %eax,%edx
  801057:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105a:	88 02                	mov    %al,(%edx)
		start++ ;
  80105c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80105f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801065:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801068:	7c c4                	jl     80102e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	01 d0                	add    %edx,%eax
  801072:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801075:	90                   	nop
  801076:	c9                   	leave  
  801077:	c3                   	ret    

00801078 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80107e:	ff 75 08             	pushl  0x8(%ebp)
  801081:	e8 73 fa ff ff       	call   800af9 <strlen>
  801086:	83 c4 04             	add    $0x4,%esp
  801089:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108c:	ff 75 0c             	pushl  0xc(%ebp)
  80108f:	e8 65 fa ff ff       	call   800af9 <strlen>
  801094:	83 c4 04             	add    $0x4,%esp
  801097:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a8:	eb 17                	jmp    8010c1 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b0:	01 c2                	add    %eax,%edx
  8010b2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	01 c8                	add    %ecx,%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010be:	ff 45 fc             	incl   -0x4(%ebp)
  8010c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c7:	7c e1                	jl     8010aa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d7:	eb 1f                	jmp    8010f8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dc:	8d 50 01             	lea    0x1(%eax),%edx
  8010df:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e2:	89 c2                	mov    %eax,%edx
  8010e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e7:	01 c2                	add    %eax,%edx
  8010e9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	01 c8                	add    %ecx,%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f5:	ff 45 f8             	incl   -0x8(%ebp)
  8010f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010fe:	7c d9                	jl     8010d9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801100:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	c6 00 00             	movb   $0x0,(%eax)
}
  80110b:	90                   	nop
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801111:	8b 45 14             	mov    0x14(%ebp),%eax
  801114:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111a:	8b 45 14             	mov    0x14(%ebp),%eax
  80111d:	8b 00                	mov    (%eax),%eax
  80111f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801126:	8b 45 10             	mov    0x10(%ebp),%eax
  801129:	01 d0                	add    %edx,%eax
  80112b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801131:	eb 0c                	jmp    80113f <strsplit+0x31>
			*string++ = 0;
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8d 50 01             	lea    0x1(%eax),%edx
  801139:	89 55 08             	mov    %edx,0x8(%ebp)
  80113c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	84 c0                	test   %al,%al
  801146:	74 18                	je     801160 <strsplit+0x52>
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	0f be c0             	movsbl %al,%eax
  801150:	50                   	push   %eax
  801151:	ff 75 0c             	pushl  0xc(%ebp)
  801154:	e8 32 fb ff ff       	call   800c8b <strchr>
  801159:	83 c4 08             	add    $0x8,%esp
  80115c:	85 c0                	test   %eax,%eax
  80115e:	75 d3                	jne    801133 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	84 c0                	test   %al,%al
  801167:	74 5a                	je     8011c3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801169:	8b 45 14             	mov    0x14(%ebp),%eax
  80116c:	8b 00                	mov    (%eax),%eax
  80116e:	83 f8 0f             	cmp    $0xf,%eax
  801171:	75 07                	jne    80117a <strsplit+0x6c>
		{
			return 0;
  801173:	b8 00 00 00 00       	mov    $0x0,%eax
  801178:	eb 66                	jmp    8011e0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117a:	8b 45 14             	mov    0x14(%ebp),%eax
  80117d:	8b 00                	mov    (%eax),%eax
  80117f:	8d 48 01             	lea    0x1(%eax),%ecx
  801182:	8b 55 14             	mov    0x14(%ebp),%edx
  801185:	89 0a                	mov    %ecx,(%edx)
  801187:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80118e:	8b 45 10             	mov    0x10(%ebp),%eax
  801191:	01 c2                	add    %eax,%edx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801198:	eb 03                	jmp    80119d <strsplit+0x8f>
			string++;
  80119a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	84 c0                	test   %al,%al
  8011a4:	74 8b                	je     801131 <strsplit+0x23>
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	0f be c0             	movsbl %al,%eax
  8011ae:	50                   	push   %eax
  8011af:	ff 75 0c             	pushl  0xc(%ebp)
  8011b2:	e8 d4 fa ff ff       	call   800c8b <strchr>
  8011b7:	83 c4 08             	add    $0x8,%esp
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	74 dc                	je     80119a <strsplit+0x8c>
			string++;
	}
  8011be:	e9 6e ff ff ff       	jmp    801131 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011db:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e0:	c9                   	leave  
  8011e1:	c3                   	ret    

008011e2 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011e8:	83 ec 04             	sub    $0x4,%esp
  8011eb:	68 e8 20 80 00       	push   $0x8020e8
  8011f0:	68 3f 01 00 00       	push   $0x13f
  8011f5:	68 0a 21 80 00       	push   $0x80210a
  8011fa:	e8 a9 ef ff ff       	call   8001a8 <_panic>

008011ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	57                   	push   %edi
  801203:	56                   	push   %esi
  801204:	53                   	push   %ebx
  801205:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801211:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801214:	8b 7d 18             	mov    0x18(%ebp),%edi
  801217:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80121a:	cd 30                	int    $0x30
  80121c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80121f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801222:	83 c4 10             	add    $0x10,%esp
  801225:	5b                   	pop    %ebx
  801226:	5e                   	pop    %esi
  801227:	5f                   	pop    %edi
  801228:	5d                   	pop    %ebp
  801229:	c3                   	ret    

0080122a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 04             	sub    $0x4,%esp
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801236:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	52                   	push   %edx
  801242:	ff 75 0c             	pushl  0xc(%ebp)
  801245:	50                   	push   %eax
  801246:	6a 00                	push   $0x0
  801248:	e8 b2 ff ff ff       	call   8011ff <syscall>
  80124d:	83 c4 18             	add    $0x18,%esp
}
  801250:	90                   	nop
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <sys_cgetc>:

int
sys_cgetc(void)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	6a 00                	push   $0x0
  80125e:	6a 00                	push   $0x0
  801260:	6a 02                	push   $0x2
  801262:	e8 98 ff ff ff       	call   8011ff <syscall>
  801267:	83 c4 18             	add    $0x18,%esp
}
  80126a:	c9                   	leave  
  80126b:	c3                   	ret    

0080126c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80126f:	6a 00                	push   $0x0
  801271:	6a 00                	push   $0x0
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 03                	push   $0x3
  80127b:	e8 7f ff ff ff       	call   8011ff <syscall>
  801280:	83 c4 18             	add    $0x18,%esp
}
  801283:	90                   	nop
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 04                	push   $0x4
  801295:	e8 65 ff ff ff       	call   8011ff <syscall>
  80129a:	83 c4 18             	add    $0x18,%esp
}
  80129d:	90                   	nop
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	52                   	push   %edx
  8012b0:	50                   	push   %eax
  8012b1:	6a 08                	push   $0x8
  8012b3:	e8 47 ff ff ff       	call   8011ff <syscall>
  8012b8:	83 c4 18             	add    $0x18,%esp
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012c2:	8b 75 18             	mov    0x18(%ebp),%esi
  8012c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	56                   	push   %esi
  8012d2:	53                   	push   %ebx
  8012d3:	51                   	push   %ecx
  8012d4:	52                   	push   %edx
  8012d5:	50                   	push   %eax
  8012d6:	6a 09                	push   $0x9
  8012d8:	e8 22 ff ff ff       	call   8011ff <syscall>
  8012dd:	83 c4 18             	add    $0x18,%esp
}
  8012e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e3:	5b                   	pop    %ebx
  8012e4:	5e                   	pop    %esi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    

008012e7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 00                	push   $0x0
  8012f6:	52                   	push   %edx
  8012f7:	50                   	push   %eax
  8012f8:	6a 0a                	push   $0xa
  8012fa:	e8 00 ff ff ff       	call   8011ff <syscall>
  8012ff:	83 c4 18             	add    $0x18,%esp
}
  801302:	c9                   	leave  
  801303:	c3                   	ret    

00801304 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	ff 75 08             	pushl  0x8(%ebp)
  801313:	6a 0b                	push   $0xb
  801315:	e8 e5 fe ff ff       	call   8011ff <syscall>
  80131a:	83 c4 18             	add    $0x18,%esp
}
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 0c                	push   $0xc
  80132e:	e8 cc fe ff ff       	call   8011ff <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 0d                	push   $0xd
  801347:	e8 b3 fe ff ff       	call   8011ff <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 0e                	push   $0xe
  801360:	e8 9a fe ff ff       	call   8011ff <syscall>
  801365:	83 c4 18             	add    $0x18,%esp
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 0f                	push   $0xf
  801379:	e8 81 fe ff ff       	call   8011ff <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	ff 75 08             	pushl  0x8(%ebp)
  801391:	6a 10                	push   $0x10
  801393:	e8 67 fe ff ff       	call   8011ff <syscall>
  801398:	83 c4 18             	add    $0x18,%esp
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 11                	push   $0x11
  8013ac:	e8 4e fe ff ff       	call   8011ff <syscall>
  8013b1:	83 c4 18             	add    $0x18,%esp
}
  8013b4:	90                   	nop
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 04             	sub    $0x4,%esp
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013c3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	50                   	push   %eax
  8013d0:	6a 01                	push   $0x1
  8013d2:	e8 28 fe ff ff       	call   8011ff <syscall>
  8013d7:	83 c4 18             	add    $0x18,%esp
}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 14                	push   $0x14
  8013ec:	e8 0e fe ff ff       	call   8011ff <syscall>
  8013f1:	83 c4 18             	add    $0x18,%esp
}
  8013f4:	90                   	nop
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801400:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801403:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801406:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	6a 00                	push   $0x0
  80140f:	51                   	push   %ecx
  801410:	52                   	push   %edx
  801411:	ff 75 0c             	pushl  0xc(%ebp)
  801414:	50                   	push   %eax
  801415:	6a 15                	push   $0x15
  801417:	e8 e3 fd ff ff       	call   8011ff <syscall>
  80141c:	83 c4 18             	add    $0x18,%esp
}
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801424:	8b 55 0c             	mov    0xc(%ebp),%edx
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	52                   	push   %edx
  801431:	50                   	push   %eax
  801432:	6a 16                	push   $0x16
  801434:	e8 c6 fd ff ff       	call   8011ff <syscall>
  801439:	83 c4 18             	add    $0x18,%esp
}
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801441:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801444:	8b 55 0c             	mov    0xc(%ebp),%edx
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	51                   	push   %ecx
  80144f:	52                   	push   %edx
  801450:	50                   	push   %eax
  801451:	6a 17                	push   $0x17
  801453:	e8 a7 fd ff ff       	call   8011ff <syscall>
  801458:	83 c4 18             	add    $0x18,%esp
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801460:	8b 55 0c             	mov    0xc(%ebp),%edx
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	52                   	push   %edx
  80146d:	50                   	push   %eax
  80146e:	6a 18                	push   $0x18
  801470:	e8 8a fd ff ff       	call   8011ff <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
}
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	6a 00                	push   $0x0
  801482:	ff 75 14             	pushl  0x14(%ebp)
  801485:	ff 75 10             	pushl  0x10(%ebp)
  801488:	ff 75 0c             	pushl  0xc(%ebp)
  80148b:	50                   	push   %eax
  80148c:	6a 19                	push   $0x19
  80148e:	e8 6c fd ff ff       	call   8011ff <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	50                   	push   %eax
  8014a7:	6a 1a                	push   $0x1a
  8014a9:	e8 51 fd ff ff       	call   8011ff <syscall>
  8014ae:	83 c4 18             	add    $0x18,%esp
}
  8014b1:	90                   	nop
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	50                   	push   %eax
  8014c3:	6a 1b                	push   $0x1b
  8014c5:	e8 35 fd ff ff       	call   8011ff <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 05                	push   $0x5
  8014de:	e8 1c fd ff ff       	call   8011ff <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 06                	push   $0x6
  8014f7:	e8 03 fd ff ff       	call   8011ff <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 07                	push   $0x7
  801510:	e8 ea fc ff ff       	call   8011ff <syscall>
  801515:	83 c4 18             	add    $0x18,%esp
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <sys_exit_env>:


void sys_exit_env(void)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 1c                	push   $0x1c
  801529:	e8 d1 fc ff ff       	call   8011ff <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
}
  801531:	90                   	nop
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80153a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80153d:	8d 50 04             	lea    0x4(%eax),%edx
  801540:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	52                   	push   %edx
  80154a:	50                   	push   %eax
  80154b:	6a 1d                	push   $0x1d
  80154d:	e8 ad fc ff ff       	call   8011ff <syscall>
  801552:	83 c4 18             	add    $0x18,%esp
	return result;
  801555:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801558:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80155e:	89 01                	mov    %eax,(%ecx)
  801560:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	c9                   	leave  
  801567:	c2 04 00             	ret    $0x4

0080156a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	ff 75 10             	pushl  0x10(%ebp)
  801574:	ff 75 0c             	pushl  0xc(%ebp)
  801577:	ff 75 08             	pushl  0x8(%ebp)
  80157a:	6a 13                	push   $0x13
  80157c:	e8 7e fc ff ff       	call   8011ff <syscall>
  801581:	83 c4 18             	add    $0x18,%esp
	return ;
  801584:	90                   	nop
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_rcr2>:
uint32 sys_rcr2()
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 1e                	push   $0x1e
  801596:	e8 64 fc ff ff       	call   8011ff <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015ac:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	50                   	push   %eax
  8015b9:	6a 1f                	push   $0x1f
  8015bb:	e8 3f fc ff ff       	call   8011ff <syscall>
  8015c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c3:	90                   	nop
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <rsttst>:
void rsttst()
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 21                	push   $0x21
  8015d5:	e8 25 fc ff ff       	call   8011ff <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
	return ;
  8015dd:	90                   	nop
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015ec:	8b 55 18             	mov    0x18(%ebp),%edx
  8015ef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015f3:	52                   	push   %edx
  8015f4:	50                   	push   %eax
  8015f5:	ff 75 10             	pushl  0x10(%ebp)
  8015f8:	ff 75 0c             	pushl  0xc(%ebp)
  8015fb:	ff 75 08             	pushl  0x8(%ebp)
  8015fe:	6a 20                	push   $0x20
  801600:	e8 fa fb ff ff       	call   8011ff <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
	return ;
  801608:	90                   	nop
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <chktst>:
void chktst(uint32 n)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	ff 75 08             	pushl  0x8(%ebp)
  801619:	6a 22                	push   $0x22
  80161b:	e8 df fb ff ff       	call   8011ff <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
	return ;
  801623:	90                   	nop
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <inctst>:

void inctst()
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 23                	push   $0x23
  801635:	e8 c5 fb ff ff       	call   8011ff <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
	return ;
  80163d:	90                   	nop
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <gettst>:
uint32 gettst()
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 24                	push   $0x24
  80164f:	e8 ab fb ff ff       	call   8011ff <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 25                	push   $0x25
  80166b:	e8 8f fb ff ff       	call   8011ff <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
  801673:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801676:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80167a:	75 07                	jne    801683 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80167c:	b8 01 00 00 00       	mov    $0x1,%eax
  801681:	eb 05                	jmp    801688 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 25                	push   $0x25
  80169c:	e8 5e fb ff ff       	call   8011ff <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
  8016a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016a7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016ab:	75 07                	jne    8016b4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b2:	eb 05                	jmp    8016b9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 25                	push   $0x25
  8016cd:	e8 2d fb ff ff       	call   8011ff <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
  8016d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016d8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016dc:	75 07                	jne    8016e5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016de:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e3:	eb 05                	jmp    8016ea <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 25                	push   $0x25
  8016fe:	e8 fc fa ff ff       	call   8011ff <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
  801706:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801709:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80170d:	75 07                	jne    801716 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80170f:	b8 01 00 00 00       	mov    $0x1,%eax
  801714:	eb 05                	jmp    80171b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801716:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	ff 75 08             	pushl  0x8(%ebp)
  80172b:	6a 26                	push   $0x26
  80172d:	e8 cd fa ff ff       	call   8011ff <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
	return ;
  801735:	90                   	nop
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80173c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801742:	8b 55 0c             	mov    0xc(%ebp),%edx
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	6a 00                	push   $0x0
  80174a:	53                   	push   %ebx
  80174b:	51                   	push   %ecx
  80174c:	52                   	push   %edx
  80174d:	50                   	push   %eax
  80174e:	6a 27                	push   $0x27
  801750:	e8 aa fa ff ff       	call   8011ff <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801760:	8b 55 0c             	mov    0xc(%ebp),%edx
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	52                   	push   %edx
  80176d:	50                   	push   %eax
  80176e:	6a 28                	push   $0x28
  801770:	e8 8a fa ff ff       	call   8011ff <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80177d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801780:	8b 55 0c             	mov    0xc(%ebp),%edx
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	6a 00                	push   $0x0
  801788:	51                   	push   %ecx
  801789:	ff 75 10             	pushl  0x10(%ebp)
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	6a 29                	push   $0x29
  801790:	e8 6a fa ff ff       	call   8011ff <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	ff 75 10             	pushl  0x10(%ebp)
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	ff 75 08             	pushl  0x8(%ebp)
  8017aa:	6a 12                	push   $0x12
  8017ac:	e8 4e fa ff ff       	call   8011ff <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b4:	90                   	nop
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	52                   	push   %edx
  8017c7:	50                   	push   %eax
  8017c8:	6a 2a                	push   $0x2a
  8017ca:	e8 30 fa ff ff       	call   8011ff <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
	return;
  8017d2:	90                   	nop
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	50                   	push   %eax
  8017e4:	6a 2b                	push   $0x2b
  8017e6:	e8 14 fa ff ff       	call   8011ff <syscall>
  8017eb:	83 c4 18             	add    $0x18,%esp
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	ff 75 08             	pushl  0x8(%ebp)
  8017ff:	6a 2c                	push   $0x2c
  801801:	e8 f9 f9 ff ff       	call   8011ff <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
	return;
  801809:	90                   	nop
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	ff 75 08             	pushl  0x8(%ebp)
  80181b:	6a 2d                	push   $0x2d
  80181d:	e8 dd f9 ff ff       	call   8011ff <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
	return;
  801825:	90                   	nop
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <__udivdi3>:
  801828:	55                   	push   %ebp
  801829:	57                   	push   %edi
  80182a:	56                   	push   %esi
  80182b:	53                   	push   %ebx
  80182c:	83 ec 1c             	sub    $0x1c,%esp
  80182f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801833:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801837:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80183b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80183f:	89 ca                	mov    %ecx,%edx
  801841:	89 f8                	mov    %edi,%eax
  801843:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801847:	85 f6                	test   %esi,%esi
  801849:	75 2d                	jne    801878 <__udivdi3+0x50>
  80184b:	39 cf                	cmp    %ecx,%edi
  80184d:	77 65                	ja     8018b4 <__udivdi3+0x8c>
  80184f:	89 fd                	mov    %edi,%ebp
  801851:	85 ff                	test   %edi,%edi
  801853:	75 0b                	jne    801860 <__udivdi3+0x38>
  801855:	b8 01 00 00 00       	mov    $0x1,%eax
  80185a:	31 d2                	xor    %edx,%edx
  80185c:	f7 f7                	div    %edi
  80185e:	89 c5                	mov    %eax,%ebp
  801860:	31 d2                	xor    %edx,%edx
  801862:	89 c8                	mov    %ecx,%eax
  801864:	f7 f5                	div    %ebp
  801866:	89 c1                	mov    %eax,%ecx
  801868:	89 d8                	mov    %ebx,%eax
  80186a:	f7 f5                	div    %ebp
  80186c:	89 cf                	mov    %ecx,%edi
  80186e:	89 fa                	mov    %edi,%edx
  801870:	83 c4 1c             	add    $0x1c,%esp
  801873:	5b                   	pop    %ebx
  801874:	5e                   	pop    %esi
  801875:	5f                   	pop    %edi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    
  801878:	39 ce                	cmp    %ecx,%esi
  80187a:	77 28                	ja     8018a4 <__udivdi3+0x7c>
  80187c:	0f bd fe             	bsr    %esi,%edi
  80187f:	83 f7 1f             	xor    $0x1f,%edi
  801882:	75 40                	jne    8018c4 <__udivdi3+0x9c>
  801884:	39 ce                	cmp    %ecx,%esi
  801886:	72 0a                	jb     801892 <__udivdi3+0x6a>
  801888:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80188c:	0f 87 9e 00 00 00    	ja     801930 <__udivdi3+0x108>
  801892:	b8 01 00 00 00       	mov    $0x1,%eax
  801897:	89 fa                	mov    %edi,%edx
  801899:	83 c4 1c             	add    $0x1c,%esp
  80189c:	5b                   	pop    %ebx
  80189d:	5e                   	pop    %esi
  80189e:	5f                   	pop    %edi
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    
  8018a1:	8d 76 00             	lea    0x0(%esi),%esi
  8018a4:	31 ff                	xor    %edi,%edi
  8018a6:	31 c0                	xor    %eax,%eax
  8018a8:	89 fa                	mov    %edi,%edx
  8018aa:	83 c4 1c             	add    $0x1c,%esp
  8018ad:	5b                   	pop    %ebx
  8018ae:	5e                   	pop    %esi
  8018af:	5f                   	pop    %edi
  8018b0:	5d                   	pop    %ebp
  8018b1:	c3                   	ret    
  8018b2:	66 90                	xchg   %ax,%ax
  8018b4:	89 d8                	mov    %ebx,%eax
  8018b6:	f7 f7                	div    %edi
  8018b8:	31 ff                	xor    %edi,%edi
  8018ba:	89 fa                	mov    %edi,%edx
  8018bc:	83 c4 1c             	add    $0x1c,%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5f                   	pop    %edi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    
  8018c4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018c9:	89 eb                	mov    %ebp,%ebx
  8018cb:	29 fb                	sub    %edi,%ebx
  8018cd:	89 f9                	mov    %edi,%ecx
  8018cf:	d3 e6                	shl    %cl,%esi
  8018d1:	89 c5                	mov    %eax,%ebp
  8018d3:	88 d9                	mov    %bl,%cl
  8018d5:	d3 ed                	shr    %cl,%ebp
  8018d7:	89 e9                	mov    %ebp,%ecx
  8018d9:	09 f1                	or     %esi,%ecx
  8018db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018df:	89 f9                	mov    %edi,%ecx
  8018e1:	d3 e0                	shl    %cl,%eax
  8018e3:	89 c5                	mov    %eax,%ebp
  8018e5:	89 d6                	mov    %edx,%esi
  8018e7:	88 d9                	mov    %bl,%cl
  8018e9:	d3 ee                	shr    %cl,%esi
  8018eb:	89 f9                	mov    %edi,%ecx
  8018ed:	d3 e2                	shl    %cl,%edx
  8018ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018f3:	88 d9                	mov    %bl,%cl
  8018f5:	d3 e8                	shr    %cl,%eax
  8018f7:	09 c2                	or     %eax,%edx
  8018f9:	89 d0                	mov    %edx,%eax
  8018fb:	89 f2                	mov    %esi,%edx
  8018fd:	f7 74 24 0c          	divl   0xc(%esp)
  801901:	89 d6                	mov    %edx,%esi
  801903:	89 c3                	mov    %eax,%ebx
  801905:	f7 e5                	mul    %ebp
  801907:	39 d6                	cmp    %edx,%esi
  801909:	72 19                	jb     801924 <__udivdi3+0xfc>
  80190b:	74 0b                	je     801918 <__udivdi3+0xf0>
  80190d:	89 d8                	mov    %ebx,%eax
  80190f:	31 ff                	xor    %edi,%edi
  801911:	e9 58 ff ff ff       	jmp    80186e <__udivdi3+0x46>
  801916:	66 90                	xchg   %ax,%ax
  801918:	8b 54 24 08          	mov    0x8(%esp),%edx
  80191c:	89 f9                	mov    %edi,%ecx
  80191e:	d3 e2                	shl    %cl,%edx
  801920:	39 c2                	cmp    %eax,%edx
  801922:	73 e9                	jae    80190d <__udivdi3+0xe5>
  801924:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801927:	31 ff                	xor    %edi,%edi
  801929:	e9 40 ff ff ff       	jmp    80186e <__udivdi3+0x46>
  80192e:	66 90                	xchg   %ax,%ax
  801930:	31 c0                	xor    %eax,%eax
  801932:	e9 37 ff ff ff       	jmp    80186e <__udivdi3+0x46>
  801937:	90                   	nop

00801938 <__umoddi3>:
  801938:	55                   	push   %ebp
  801939:	57                   	push   %edi
  80193a:	56                   	push   %esi
  80193b:	53                   	push   %ebx
  80193c:	83 ec 1c             	sub    $0x1c,%esp
  80193f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801943:	8b 74 24 34          	mov    0x34(%esp),%esi
  801947:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80194b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80194f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801953:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801957:	89 f3                	mov    %esi,%ebx
  801959:	89 fa                	mov    %edi,%edx
  80195b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80195f:	89 34 24             	mov    %esi,(%esp)
  801962:	85 c0                	test   %eax,%eax
  801964:	75 1a                	jne    801980 <__umoddi3+0x48>
  801966:	39 f7                	cmp    %esi,%edi
  801968:	0f 86 a2 00 00 00    	jbe    801a10 <__umoddi3+0xd8>
  80196e:	89 c8                	mov    %ecx,%eax
  801970:	89 f2                	mov    %esi,%edx
  801972:	f7 f7                	div    %edi
  801974:	89 d0                	mov    %edx,%eax
  801976:	31 d2                	xor    %edx,%edx
  801978:	83 c4 1c             	add    $0x1c,%esp
  80197b:	5b                   	pop    %ebx
  80197c:	5e                   	pop    %esi
  80197d:	5f                   	pop    %edi
  80197e:	5d                   	pop    %ebp
  80197f:	c3                   	ret    
  801980:	39 f0                	cmp    %esi,%eax
  801982:	0f 87 ac 00 00 00    	ja     801a34 <__umoddi3+0xfc>
  801988:	0f bd e8             	bsr    %eax,%ebp
  80198b:	83 f5 1f             	xor    $0x1f,%ebp
  80198e:	0f 84 ac 00 00 00    	je     801a40 <__umoddi3+0x108>
  801994:	bf 20 00 00 00       	mov    $0x20,%edi
  801999:	29 ef                	sub    %ebp,%edi
  80199b:	89 fe                	mov    %edi,%esi
  80199d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019a1:	89 e9                	mov    %ebp,%ecx
  8019a3:	d3 e0                	shl    %cl,%eax
  8019a5:	89 d7                	mov    %edx,%edi
  8019a7:	89 f1                	mov    %esi,%ecx
  8019a9:	d3 ef                	shr    %cl,%edi
  8019ab:	09 c7                	or     %eax,%edi
  8019ad:	89 e9                	mov    %ebp,%ecx
  8019af:	d3 e2                	shl    %cl,%edx
  8019b1:	89 14 24             	mov    %edx,(%esp)
  8019b4:	89 d8                	mov    %ebx,%eax
  8019b6:	d3 e0                	shl    %cl,%eax
  8019b8:	89 c2                	mov    %eax,%edx
  8019ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019be:	d3 e0                	shl    %cl,%eax
  8019c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019c8:	89 f1                	mov    %esi,%ecx
  8019ca:	d3 e8                	shr    %cl,%eax
  8019cc:	09 d0                	or     %edx,%eax
  8019ce:	d3 eb                	shr    %cl,%ebx
  8019d0:	89 da                	mov    %ebx,%edx
  8019d2:	f7 f7                	div    %edi
  8019d4:	89 d3                	mov    %edx,%ebx
  8019d6:	f7 24 24             	mull   (%esp)
  8019d9:	89 c6                	mov    %eax,%esi
  8019db:	89 d1                	mov    %edx,%ecx
  8019dd:	39 d3                	cmp    %edx,%ebx
  8019df:	0f 82 87 00 00 00    	jb     801a6c <__umoddi3+0x134>
  8019e5:	0f 84 91 00 00 00    	je     801a7c <__umoddi3+0x144>
  8019eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019ef:	29 f2                	sub    %esi,%edx
  8019f1:	19 cb                	sbb    %ecx,%ebx
  8019f3:	89 d8                	mov    %ebx,%eax
  8019f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019f9:	d3 e0                	shl    %cl,%eax
  8019fb:	89 e9                	mov    %ebp,%ecx
  8019fd:	d3 ea                	shr    %cl,%edx
  8019ff:	09 d0                	or     %edx,%eax
  801a01:	89 e9                	mov    %ebp,%ecx
  801a03:	d3 eb                	shr    %cl,%ebx
  801a05:	89 da                	mov    %ebx,%edx
  801a07:	83 c4 1c             	add    $0x1c,%esp
  801a0a:	5b                   	pop    %ebx
  801a0b:	5e                   	pop    %esi
  801a0c:	5f                   	pop    %edi
  801a0d:	5d                   	pop    %ebp
  801a0e:	c3                   	ret    
  801a0f:	90                   	nop
  801a10:	89 fd                	mov    %edi,%ebp
  801a12:	85 ff                	test   %edi,%edi
  801a14:	75 0b                	jne    801a21 <__umoddi3+0xe9>
  801a16:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1b:	31 d2                	xor    %edx,%edx
  801a1d:	f7 f7                	div    %edi
  801a1f:	89 c5                	mov    %eax,%ebp
  801a21:	89 f0                	mov    %esi,%eax
  801a23:	31 d2                	xor    %edx,%edx
  801a25:	f7 f5                	div    %ebp
  801a27:	89 c8                	mov    %ecx,%eax
  801a29:	f7 f5                	div    %ebp
  801a2b:	89 d0                	mov    %edx,%eax
  801a2d:	e9 44 ff ff ff       	jmp    801976 <__umoddi3+0x3e>
  801a32:	66 90                	xchg   %ax,%ax
  801a34:	89 c8                	mov    %ecx,%eax
  801a36:	89 f2                	mov    %esi,%edx
  801a38:	83 c4 1c             	add    $0x1c,%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5f                   	pop    %edi
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    
  801a40:	3b 04 24             	cmp    (%esp),%eax
  801a43:	72 06                	jb     801a4b <__umoddi3+0x113>
  801a45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a49:	77 0f                	ja     801a5a <__umoddi3+0x122>
  801a4b:	89 f2                	mov    %esi,%edx
  801a4d:	29 f9                	sub    %edi,%ecx
  801a4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a53:	89 14 24             	mov    %edx,(%esp)
  801a56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a5e:	8b 14 24             	mov    (%esp),%edx
  801a61:	83 c4 1c             	add    $0x1c,%esp
  801a64:	5b                   	pop    %ebx
  801a65:	5e                   	pop    %esi
  801a66:	5f                   	pop    %edi
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    
  801a69:	8d 76 00             	lea    0x0(%esi),%esi
  801a6c:	2b 04 24             	sub    (%esp),%eax
  801a6f:	19 fa                	sbb    %edi,%edx
  801a71:	89 d1                	mov    %edx,%ecx
  801a73:	89 c6                	mov    %eax,%esi
  801a75:	e9 71 ff ff ff       	jmp    8019eb <__umoddi3+0xb3>
  801a7a:	66 90                	xchg   %ax,%ax
  801a7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a80:	72 ea                	jb     801a6c <__umoddi3+0x134>
  801a82:	89 d9                	mov    %ebx,%ecx
  801a84:	e9 62 ff ff ff       	jmp    8019eb <__umoddi3+0xb3>
