
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
  800048:	e8 d0 17 00 00       	call   80181d <sys_allocate_user_mem>
  80004d:	83 c4 10             	add    $0x10,%esp
	inctst();
  800050:	e8 df 15 00 00       	call   801634 <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	68 a0 1a 80 00       	push   $0x801aa0
  80005d:	6a 0a                	push   $0xa
  80005f:	68 22 1b 80 00       	push   $0x801b22
  800064:	e8 4d 01 00 00       	call   8001b6 <_panic>

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
  80006f:	e8 82 14 00 00       	call   8014f6 <sys_getenvindex>
  800074:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007a:	89 d0                	mov    %edx,%eax
  80007c:	c1 e0 06             	shl    $0x6,%eax
  80007f:	29 d0                	sub    %edx,%eax
  800081:	c1 e0 02             	shl    $0x2,%eax
  800084:	01 d0                	add    %edx,%eax
  800086:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80008d:	01 c8                	add    %ecx,%eax
  80008f:	c1 e0 03             	shl    $0x3,%eax
  800092:	01 d0                	add    %edx,%eax
  800094:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80009b:	29 c2                	sub    %eax,%edx
  80009d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000a4:	89 c2                	mov    %eax,%edx
  8000a6:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000ac:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000b1:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b6:	8a 40 20             	mov    0x20(%eax),%al
  8000b9:	84 c0                	test   %al,%al
  8000bb:	74 0d                	je     8000ca <libmain+0x61>
		binaryname = myEnv->prog_name;
  8000bd:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c2:	83 c0 20             	add    $0x20,%eax
  8000c5:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ce:	7e 0a                	jle    8000da <libmain+0x71>
		binaryname = argv[0];
  8000d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d3:	8b 00                	mov    (%eax),%eax
  8000d5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000da:	83 ec 08             	sub    $0x8,%esp
  8000dd:	ff 75 0c             	pushl  0xc(%ebp)
  8000e0:	ff 75 08             	pushl  0x8(%ebp)
  8000e3:	e8 50 ff ff ff       	call   800038 <_main>
  8000e8:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000eb:	e8 8a 11 00 00       	call   80127a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	68 58 1b 80 00       	push   $0x801b58
  8000f8:	e8 76 03 00 00       	call   800473 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800100:	a1 04 30 80 00       	mov    0x803004,%eax
  800105:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80010b:	a1 04 30 80 00       	mov    0x803004,%eax
  800110:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800116:	83 ec 04             	sub    $0x4,%esp
  800119:	52                   	push   %edx
  80011a:	50                   	push   %eax
  80011b:	68 80 1b 80 00       	push   $0x801b80
  800120:	e8 4e 03 00 00       	call   800473 <cprintf>
  800125:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800128:	a1 04 30 80 00       	mov    0x803004,%eax
  80012d:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800133:	a1 04 30 80 00       	mov    0x803004,%eax
  800138:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80013e:	a1 04 30 80 00       	mov    0x803004,%eax
  800143:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800149:	51                   	push   %ecx
  80014a:	52                   	push   %edx
  80014b:	50                   	push   %eax
  80014c:	68 a8 1b 80 00       	push   $0x801ba8
  800151:	e8 1d 03 00 00       	call   800473 <cprintf>
  800156:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800159:	a1 04 30 80 00       	mov    0x803004,%eax
  80015e:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	50                   	push   %eax
  800168:	68 00 1c 80 00       	push   $0x801c00
  80016d:	e8 01 03 00 00       	call   800473 <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800175:	83 ec 0c             	sub    $0xc,%esp
  800178:	68 58 1b 80 00       	push   $0x801b58
  80017d:	e8 f1 02 00 00       	call   800473 <cprintf>
  800182:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800185:	e8 0a 11 00 00       	call   801294 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80018a:	e8 19 00 00 00       	call   8001a8 <exit>
}
  80018f:	90                   	nop
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800198:	83 ec 0c             	sub    $0xc,%esp
  80019b:	6a 00                	push   $0x0
  80019d:	e8 20 13 00 00       	call   8014c2 <sys_destroy_env>
  8001a2:	83 c4 10             	add    $0x10,%esp
}
  8001a5:	90                   	nop
  8001a6:	c9                   	leave  
  8001a7:	c3                   	ret    

008001a8 <exit>:

void
exit(void)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001ae:	e8 75 13 00 00       	call   801528 <sys_exit_env>
}
  8001b3:	90                   	nop
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8001bf:	83 c0 04             	add    $0x4,%eax
  8001c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001c5:	a1 24 30 80 00       	mov    0x803024,%eax
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	74 16                	je     8001e4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001ce:	a1 24 30 80 00       	mov    0x803024,%eax
  8001d3:	83 ec 08             	sub    $0x8,%esp
  8001d6:	50                   	push   %eax
  8001d7:	68 14 1c 80 00       	push   $0x801c14
  8001dc:	e8 92 02 00 00       	call   800473 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001e4:	a1 00 30 80 00       	mov    0x803000,%eax
  8001e9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ec:	ff 75 08             	pushl  0x8(%ebp)
  8001ef:	50                   	push   %eax
  8001f0:	68 19 1c 80 00       	push   $0x801c19
  8001f5:	e8 79 02 00 00       	call   800473 <cprintf>
  8001fa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800200:	83 ec 08             	sub    $0x8,%esp
  800203:	ff 75 f4             	pushl  -0xc(%ebp)
  800206:	50                   	push   %eax
  800207:	e8 fc 01 00 00       	call   800408 <vcprintf>
  80020c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80020f:	83 ec 08             	sub    $0x8,%esp
  800212:	6a 00                	push   $0x0
  800214:	68 35 1c 80 00       	push   $0x801c35
  800219:	e8 ea 01 00 00       	call   800408 <vcprintf>
  80021e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800221:	e8 82 ff ff ff       	call   8001a8 <exit>

	// should not return here
	while (1) ;
  800226:	eb fe                	jmp    800226 <_panic+0x70>

00800228 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80022e:	a1 04 30 80 00       	mov    0x803004,%eax
  800233:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023c:	39 c2                	cmp    %eax,%edx
  80023e:	74 14                	je     800254 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 38 1c 80 00       	push   $0x801c38
  800248:	6a 26                	push   $0x26
  80024a:	68 84 1c 80 00       	push   $0x801c84
  80024f:	e8 62 ff ff ff       	call   8001b6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800254:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80025b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800262:	e9 c5 00 00 00       	jmp    80032c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80026a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800271:	8b 45 08             	mov    0x8(%ebp),%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	8b 00                	mov    (%eax),%eax
  800278:	85 c0                	test   %eax,%eax
  80027a:	75 08                	jne    800284 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80027c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80027f:	e9 a5 00 00 00       	jmp    800329 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800284:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80028b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800292:	eb 69                	jmp    8002fd <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800294:	a1 04 30 80 00       	mov    0x803004,%eax
  800299:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80029f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002a2:	89 d0                	mov    %edx,%eax
  8002a4:	01 c0                	add    %eax,%eax
  8002a6:	01 d0                	add    %edx,%eax
  8002a8:	c1 e0 03             	shl    $0x3,%eax
  8002ab:	01 c8                	add    %ecx,%eax
  8002ad:	8a 40 04             	mov    0x4(%eax),%al
  8002b0:	84 c0                	test   %al,%al
  8002b2:	75 46                	jne    8002fa <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002b4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002b9:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8002bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002c2:	89 d0                	mov    %edx,%eax
  8002c4:	01 c0                	add    %eax,%eax
  8002c6:	01 d0                	add    %edx,%eax
  8002c8:	c1 e0 03             	shl    $0x3,%eax
  8002cb:	01 c8                	add    %ecx,%eax
  8002cd:	8b 00                	mov    (%eax),%eax
  8002cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002da:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002df:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e9:	01 c8                	add    %ecx,%eax
  8002eb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002ed:	39 c2                	cmp    %eax,%edx
  8002ef:	75 09                	jne    8002fa <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002f1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002f8:	eb 15                	jmp    80030f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002fa:	ff 45 e8             	incl   -0x18(%ebp)
  8002fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800302:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800308:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	77 85                	ja     800294 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80030f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800313:	75 14                	jne    800329 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800315:	83 ec 04             	sub    $0x4,%esp
  800318:	68 90 1c 80 00       	push   $0x801c90
  80031d:	6a 3a                	push   $0x3a
  80031f:	68 84 1c 80 00       	push   $0x801c84
  800324:	e8 8d fe ff ff       	call   8001b6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800329:	ff 45 f0             	incl   -0x10(%ebp)
  80032c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800332:	0f 8c 2f ff ff ff    	jl     800267 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800338:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80033f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800346:	eb 26                	jmp    80036e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800348:	a1 04 30 80 00       	mov    0x803004,%eax
  80034d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800353:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800356:	89 d0                	mov    %edx,%eax
  800358:	01 c0                	add    %eax,%eax
  80035a:	01 d0                	add    %edx,%eax
  80035c:	c1 e0 03             	shl    $0x3,%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8a 40 04             	mov    0x4(%eax),%al
  800364:	3c 01                	cmp    $0x1,%al
  800366:	75 03                	jne    80036b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800368:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80036b:	ff 45 e0             	incl   -0x20(%ebp)
  80036e:	a1 04 30 80 00       	mov    0x803004,%eax
  800373:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037c:	39 c2                	cmp    %eax,%edx
  80037e:	77 c8                	ja     800348 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800383:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800386:	74 14                	je     80039c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800388:	83 ec 04             	sub    $0x4,%esp
  80038b:	68 e4 1c 80 00       	push   $0x801ce4
  800390:	6a 44                	push   $0x44
  800392:	68 84 1c 80 00       	push   $0x801c84
  800397:	e8 1a fe ff ff       	call   8001b6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8003ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b0:	89 0a                	mov    %ecx,(%edx)
  8003b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b5:	88 d1                	mov    %dl,%cl
  8003b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ba:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c8:	75 2c                	jne    8003f6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003ca:	a0 08 30 80 00       	mov    0x803008,%al
  8003cf:	0f b6 c0             	movzbl %al,%eax
  8003d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d5:	8b 12                	mov    (%edx),%edx
  8003d7:	89 d1                	mov    %edx,%ecx
  8003d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003dc:	83 c2 08             	add    $0x8,%edx
  8003df:	83 ec 04             	sub    $0x4,%esp
  8003e2:	50                   	push   %eax
  8003e3:	51                   	push   %ecx
  8003e4:	52                   	push   %edx
  8003e5:	e8 4e 0e 00 00       	call   801238 <sys_cputs>
  8003ea:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f9:	8b 40 04             	mov    0x4(%eax),%eax
  8003fc:	8d 50 01             	lea    0x1(%eax),%edx
  8003ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800402:	89 50 04             	mov    %edx,0x4(%eax)
}
  800405:	90                   	nop
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800411:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800418:	00 00 00 
	b.cnt = 0;
  80041b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800422:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800425:	ff 75 0c             	pushl  0xc(%ebp)
  800428:	ff 75 08             	pushl  0x8(%ebp)
  80042b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800431:	50                   	push   %eax
  800432:	68 9f 03 80 00       	push   $0x80039f
  800437:	e8 11 02 00 00       	call   80064d <vprintfmt>
  80043c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80043f:	a0 08 30 80 00       	mov    0x803008,%al
  800444:	0f b6 c0             	movzbl %al,%eax
  800447:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80044d:	83 ec 04             	sub    $0x4,%esp
  800450:	50                   	push   %eax
  800451:	52                   	push   %edx
  800452:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800458:	83 c0 08             	add    $0x8,%eax
  80045b:	50                   	push   %eax
  80045c:	e8 d7 0d 00 00       	call   801238 <sys_cputs>
  800461:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800464:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80046b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800479:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800480:	8d 45 0c             	lea    0xc(%ebp),%eax
  800483:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800486:	8b 45 08             	mov    0x8(%ebp),%eax
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	ff 75 f4             	pushl  -0xc(%ebp)
  80048f:	50                   	push   %eax
  800490:	e8 73 ff ff ff       	call   800408 <vcprintf>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80049b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80049e:	c9                   	leave  
  80049f:	c3                   	ret    

008004a0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004a6:	e8 cf 0d 00 00       	call   80127a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004ab:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ba:	50                   	push   %eax
  8004bb:	e8 48 ff ff ff       	call   800408 <vcprintf>
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004c6:	e8 c9 0d 00 00       	call   801294 <sys_unlock_cons>
	return cnt;
  8004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004ce:	c9                   	leave  
  8004cf:	c3                   	ret    

008004d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	53                   	push   %ebx
  8004d4:	83 ec 14             	sub    $0x14,%esp
  8004d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e3:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004eb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004ee:	77 55                	ja     800545 <printnum+0x75>
  8004f0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004f3:	72 05                	jb     8004fa <printnum+0x2a>
  8004f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004f8:	77 4b                	ja     800545 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004fa:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004fd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800500:	8b 45 18             	mov    0x18(%ebp),%eax
  800503:	ba 00 00 00 00       	mov    $0x0,%edx
  800508:	52                   	push   %edx
  800509:	50                   	push   %eax
  80050a:	ff 75 f4             	pushl  -0xc(%ebp)
  80050d:	ff 75 f0             	pushl  -0x10(%ebp)
  800510:	e8 27 13 00 00       	call   80183c <__udivdi3>
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	ff 75 20             	pushl  0x20(%ebp)
  80051e:	53                   	push   %ebx
  80051f:	ff 75 18             	pushl  0x18(%ebp)
  800522:	52                   	push   %edx
  800523:	50                   	push   %eax
  800524:	ff 75 0c             	pushl  0xc(%ebp)
  800527:	ff 75 08             	pushl  0x8(%ebp)
  80052a:	e8 a1 ff ff ff       	call   8004d0 <printnum>
  80052f:	83 c4 20             	add    $0x20,%esp
  800532:	eb 1a                	jmp    80054e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 20             	pushl  0x20(%ebp)
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	ff d0                	call   *%eax
  800542:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800545:	ff 4d 1c             	decl   0x1c(%ebp)
  800548:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80054c:	7f e6                	jg     800534 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800551:	bb 00 00 00 00       	mov    $0x0,%ebx
  800556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80055c:	53                   	push   %ebx
  80055d:	51                   	push   %ecx
  80055e:	52                   	push   %edx
  80055f:	50                   	push   %eax
  800560:	e8 e7 13 00 00       	call   80194c <__umoddi3>
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	05 54 1f 80 00       	add    $0x801f54,%eax
  80056d:	8a 00                	mov    (%eax),%al
  80056f:	0f be c0             	movsbl %al,%eax
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	ff 75 0c             	pushl  0xc(%ebp)
  800578:	50                   	push   %eax
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	ff d0                	call   *%eax
  80057e:	83 c4 10             	add    $0x10,%esp
}
  800581:	90                   	nop
  800582:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800585:	c9                   	leave  
  800586:	c3                   	ret    

00800587 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800587:	55                   	push   %ebp
  800588:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80058a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80058e:	7e 1c                	jle    8005ac <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800590:	8b 45 08             	mov    0x8(%ebp),%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	8d 50 08             	lea    0x8(%eax),%edx
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	89 10                	mov    %edx,(%eax)
  80059d:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	83 e8 08             	sub    $0x8,%eax
  8005a5:	8b 50 04             	mov    0x4(%eax),%edx
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	eb 40                	jmp    8005ec <getuint+0x65>
	else if (lflag)
  8005ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005b0:	74 1e                	je     8005d0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	89 10                	mov    %edx,(%eax)
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	83 e8 04             	sub    $0x4,%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ce:	eb 1c                	jmp    8005ec <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	8d 50 04             	lea    0x4(%eax),%edx
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	89 10                	mov    %edx,(%eax)
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 e8 04             	sub    $0x4,%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005ec:	5d                   	pop    %ebp
  8005ed:	c3                   	ret    

008005ee <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005ee:	55                   	push   %ebp
  8005ef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005f1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005f5:	7e 1c                	jle    800613 <getint+0x25>
		return va_arg(*ap, long long);
  8005f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	8d 50 08             	lea    0x8(%eax),%edx
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	89 10                	mov    %edx,(%eax)
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	83 e8 08             	sub    $0x8,%eax
  80060c:	8b 50 04             	mov    0x4(%eax),%edx
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	eb 38                	jmp    80064b <getint+0x5d>
	else if (lflag)
  800613:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800617:	74 1a                	je     800633 <getint+0x45>
		return va_arg(*ap, long);
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	8b 00                	mov    (%eax),%eax
  80061e:	8d 50 04             	lea    0x4(%eax),%edx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	89 10                	mov    %edx,(%eax)
  800626:	8b 45 08             	mov    0x8(%ebp),%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	83 e8 04             	sub    $0x4,%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	99                   	cltd   
  800631:	eb 18                	jmp    80064b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	8d 50 04             	lea    0x4(%eax),%edx
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	89 10                	mov    %edx,(%eax)
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	83 e8 04             	sub    $0x4,%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	99                   	cltd   
}
  80064b:	5d                   	pop    %ebp
  80064c:	c3                   	ret    

0080064d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80064d:	55                   	push   %ebp
  80064e:	89 e5                	mov    %esp,%ebp
  800650:	56                   	push   %esi
  800651:	53                   	push   %ebx
  800652:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	eb 17                	jmp    80066e <vprintfmt+0x21>
			if (ch == '\0')
  800657:	85 db                	test   %ebx,%ebx
  800659:	0f 84 c1 03 00 00    	je     800a20 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	53                   	push   %ebx
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	ff d0                	call   *%eax
  80066b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066e:	8b 45 10             	mov    0x10(%ebp),%eax
  800671:	8d 50 01             	lea    0x1(%eax),%edx
  800674:	89 55 10             	mov    %edx,0x10(%ebp)
  800677:	8a 00                	mov    (%eax),%al
  800679:	0f b6 d8             	movzbl %al,%ebx
  80067c:	83 fb 25             	cmp    $0x25,%ebx
  80067f:	75 d6                	jne    800657 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800681:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800685:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80068c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800693:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80069a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a4:	8d 50 01             	lea    0x1(%eax),%edx
  8006a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8006aa:	8a 00                	mov    (%eax),%al
  8006ac:	0f b6 d8             	movzbl %al,%ebx
  8006af:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006b2:	83 f8 5b             	cmp    $0x5b,%eax
  8006b5:	0f 87 3d 03 00 00    	ja     8009f8 <vprintfmt+0x3ab>
  8006bb:	8b 04 85 78 1f 80 00 	mov    0x801f78(,%eax,4),%eax
  8006c2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006c4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006c8:	eb d7                	jmp    8006a1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ca:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006ce:	eb d1                	jmp    8006a1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006da:	89 d0                	mov    %edx,%eax
  8006dc:	c1 e0 02             	shl    $0x2,%eax
  8006df:	01 d0                	add    %edx,%eax
  8006e1:	01 c0                	add    %eax,%eax
  8006e3:	01 d8                	add    %ebx,%eax
  8006e5:	83 e8 30             	sub    $0x30,%eax
  8006e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ee:	8a 00                	mov    (%eax),%al
  8006f0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006f3:	83 fb 2f             	cmp    $0x2f,%ebx
  8006f6:	7e 3e                	jle    800736 <vprintfmt+0xe9>
  8006f8:	83 fb 39             	cmp    $0x39,%ebx
  8006fb:	7f 39                	jg     800736 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006fd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800700:	eb d5                	jmp    8006d7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	83 c0 04             	add    $0x4,%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	83 e8 04             	sub    $0x4,%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800716:	eb 1f                	jmp    800737 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800718:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071c:	79 83                	jns    8006a1 <vprintfmt+0x54>
				width = 0;
  80071e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800725:	e9 77 ff ff ff       	jmp    8006a1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80072a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800731:	e9 6b ff ff ff       	jmp    8006a1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800736:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800737:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073b:	0f 89 60 ff ff ff    	jns    8006a1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800741:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800744:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800747:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80074e:	e9 4e ff ff ff       	jmp    8006a1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800753:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800756:	e9 46 ff ff ff       	jmp    8006a1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	83 c0 04             	add    $0x4,%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	83 e8 04             	sub    $0x4,%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	ff 75 0c             	pushl  0xc(%ebp)
  800772:	50                   	push   %eax
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	ff d0                	call   *%eax
  800778:	83 c4 10             	add    $0x10,%esp
			break;
  80077b:	e9 9b 02 00 00       	jmp    800a1b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	83 c0 04             	add    $0x4,%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	83 e8 04             	sub    $0x4,%eax
  80078f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800791:	85 db                	test   %ebx,%ebx
  800793:	79 02                	jns    800797 <vprintfmt+0x14a>
				err = -err;
  800795:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800797:	83 fb 64             	cmp    $0x64,%ebx
  80079a:	7f 0b                	jg     8007a7 <vprintfmt+0x15a>
  80079c:	8b 34 9d c0 1d 80 00 	mov    0x801dc0(,%ebx,4),%esi
  8007a3:	85 f6                	test   %esi,%esi
  8007a5:	75 19                	jne    8007c0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007a7:	53                   	push   %ebx
  8007a8:	68 65 1f 80 00       	push   $0x801f65
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 70 02 00 00       	call   800a28 <printfmt>
  8007b8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007bb:	e9 5b 02 00 00       	jmp    800a1b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007c0:	56                   	push   %esi
  8007c1:	68 6e 1f 80 00       	push   $0x801f6e
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	ff 75 08             	pushl  0x8(%ebp)
  8007cc:	e8 57 02 00 00       	call   800a28 <printfmt>
  8007d1:	83 c4 10             	add    $0x10,%esp
			break;
  8007d4:	e9 42 02 00 00       	jmp    800a1b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	83 c0 04             	add    $0x4,%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	83 e8 04             	sub    $0x4,%eax
  8007e8:	8b 30                	mov    (%eax),%esi
  8007ea:	85 f6                	test   %esi,%esi
  8007ec:	75 05                	jne    8007f3 <vprintfmt+0x1a6>
				p = "(null)";
  8007ee:	be 71 1f 80 00       	mov    $0x801f71,%esi
			if (width > 0 && padc != '-')
  8007f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f7:	7e 6d                	jle    800866 <vprintfmt+0x219>
  8007f9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007fd:	74 67                	je     800866 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	50                   	push   %eax
  800806:	56                   	push   %esi
  800807:	e8 1e 03 00 00       	call   800b2a <strnlen>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800812:	eb 16                	jmp    80082a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800814:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	ff 75 0c             	pushl  0xc(%ebp)
  80081e:	50                   	push   %eax
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	ff d0                	call   *%eax
  800824:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800827:	ff 4d e4             	decl   -0x1c(%ebp)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	7f e4                	jg     800814 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800830:	eb 34                	jmp    800866 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800832:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800836:	74 1c                	je     800854 <vprintfmt+0x207>
  800838:	83 fb 1f             	cmp    $0x1f,%ebx
  80083b:	7e 05                	jle    800842 <vprintfmt+0x1f5>
  80083d:	83 fb 7e             	cmp    $0x7e,%ebx
  800840:	7e 12                	jle    800854 <vprintfmt+0x207>
					putch('?', putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	6a 3f                	push   $0x3f
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	ff d0                	call   *%eax
  80084f:	83 c4 10             	add    $0x10,%esp
  800852:	eb 0f                	jmp    800863 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	53                   	push   %ebx
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	ff d0                	call   *%eax
  800860:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800863:	ff 4d e4             	decl   -0x1c(%ebp)
  800866:	89 f0                	mov    %esi,%eax
  800868:	8d 70 01             	lea    0x1(%eax),%esi
  80086b:	8a 00                	mov    (%eax),%al
  80086d:	0f be d8             	movsbl %al,%ebx
  800870:	85 db                	test   %ebx,%ebx
  800872:	74 24                	je     800898 <vprintfmt+0x24b>
  800874:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800878:	78 b8                	js     800832 <vprintfmt+0x1e5>
  80087a:	ff 4d e0             	decl   -0x20(%ebp)
  80087d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800881:	79 af                	jns    800832 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800883:	eb 13                	jmp    800898 <vprintfmt+0x24b>
				putch(' ', putdat);
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	6a 20                	push   $0x20
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	ff d0                	call   *%eax
  800892:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800895:	ff 4d e4             	decl   -0x1c(%ebp)
  800898:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089c:	7f e7                	jg     800885 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80089e:	e9 78 01 00 00       	jmp    800a1b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a9:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ac:	50                   	push   %eax
  8008ad:	e8 3c fd ff ff       	call   8005ee <getint>
  8008b2:	83 c4 10             	add    $0x10,%esp
  8008b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c1:	85 d2                	test   %edx,%edx
  8008c3:	79 23                	jns    8008e8 <vprintfmt+0x29b>
				putch('-', putdat);
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	6a 2d                	push   $0x2d
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	ff d0                	call   *%eax
  8008d2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008db:	f7 d8                	neg    %eax
  8008dd:	83 d2 00             	adc    $0x0,%edx
  8008e0:	f7 da                	neg    %edx
  8008e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008e8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ef:	e9 bc 00 00 00       	jmp    8009b0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8008fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8008fd:	50                   	push   %eax
  8008fe:	e8 84 fc ff ff       	call   800587 <getuint>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800909:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80090c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800913:	e9 98 00 00 00       	jmp    8009b0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	6a 58                	push   $0x58
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	ff d0                	call   *%eax
  800925:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	6a 58                	push   $0x58
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	6a 58                	push   $0x58
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
			break;
  800948:	e9 ce 00 00 00       	jmp    800a1b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	6a 30                	push   $0x30
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	ff d0                	call   *%eax
  80095a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	6a 78                	push   $0x78
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	ff d0                	call   *%eax
  80096a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	83 c0 04             	add    $0x4,%eax
  800973:	89 45 14             	mov    %eax,0x14(%ebp)
  800976:	8b 45 14             	mov    0x14(%ebp),%eax
  800979:	83 e8 04             	sub    $0x4,%eax
  80097c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800981:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800988:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80098f:	eb 1f                	jmp    8009b0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 e8             	pushl  -0x18(%ebp)
  800997:	8d 45 14             	lea    0x14(%ebp),%eax
  80099a:	50                   	push   %eax
  80099b:	e8 e7 fb ff ff       	call   800587 <getuint>
  8009a0:	83 c4 10             	add    $0x10,%esp
  8009a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009a9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009b0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b7:	83 ec 04             	sub    $0x4,%esp
  8009ba:	52                   	push   %edx
  8009bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009be:	50                   	push   %eax
  8009bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	ff 75 08             	pushl  0x8(%ebp)
  8009cb:	e8 00 fb ff ff       	call   8004d0 <printnum>
  8009d0:	83 c4 20             	add    $0x20,%esp
			break;
  8009d3:	eb 46                	jmp    800a1b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	53                   	push   %ebx
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	eb 35                	jmp    800a1b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009e6:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009ed:	eb 2c                	jmp    800a1b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009ef:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009f6:	eb 23                	jmp    800a1b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 25                	push   $0x25
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a08:	ff 4d 10             	decl   0x10(%ebp)
  800a0b:	eb 03                	jmp    800a10 <vprintfmt+0x3c3>
  800a0d:	ff 4d 10             	decl   0x10(%ebp)
  800a10:	8b 45 10             	mov    0x10(%ebp),%eax
  800a13:	48                   	dec    %eax
  800a14:	8a 00                	mov    (%eax),%al
  800a16:	3c 25                	cmp    $0x25,%al
  800a18:	75 f3                	jne    800a0d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a1a:	90                   	nop
		}
	}
  800a1b:	e9 35 fc ff ff       	jmp    800655 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a20:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a24:	5b                   	pop    %ebx
  800a25:	5e                   	pop    %esi
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800a31:	83 c0 04             	add    $0x4,%eax
  800a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a37:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a3d:	50                   	push   %eax
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	ff 75 08             	pushl  0x8(%ebp)
  800a44:	e8 04 fc ff ff       	call   80064d <vprintfmt>
  800a49:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a4c:	90                   	nop
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a55:	8b 40 08             	mov    0x8(%eax),%eax
  800a58:	8d 50 01             	lea    0x1(%eax),%edx
  800a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a64:	8b 10                	mov    (%eax),%edx
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8b 40 04             	mov    0x4(%eax),%eax
  800a6c:	39 c2                	cmp    %eax,%edx
  800a6e:	73 12                	jae    800a82 <sprintputch+0x33>
		*b->buf++ = ch;
  800a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a73:	8b 00                	mov    (%eax),%eax
  800a75:	8d 48 01             	lea    0x1(%eax),%ecx
  800a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7b:	89 0a                	mov    %ecx,(%edx)
  800a7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800a80:	88 10                	mov    %dl,(%eax)
}
  800a82:	90                   	nop
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	01 d0                	add    %edx,%eax
  800a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aa6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aaa:	74 06                	je     800ab2 <vsnprintf+0x2d>
  800aac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab0:	7f 07                	jg     800ab9 <vsnprintf+0x34>
		return -E_INVAL;
  800ab2:	b8 03 00 00 00       	mov    $0x3,%eax
  800ab7:	eb 20                	jmp    800ad9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab9:	ff 75 14             	pushl  0x14(%ebp)
  800abc:	ff 75 10             	pushl  0x10(%ebp)
  800abf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ac2:	50                   	push   %eax
  800ac3:	68 4f 0a 80 00       	push   $0x800a4f
  800ac8:	e8 80 fb ff ff       	call   80064d <vprintfmt>
  800acd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ad9:	c9                   	leave  
  800ada:	c3                   	ret    

00800adb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ae1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae4:	83 c0 04             	add    $0x4,%eax
  800ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800aea:	8b 45 10             	mov    0x10(%ebp),%eax
  800aed:	ff 75 f4             	pushl  -0xc(%ebp)
  800af0:	50                   	push   %eax
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	ff 75 08             	pushl  0x8(%ebp)
  800af7:	e8 89 ff ff ff       	call   800a85 <vsnprintf>
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b14:	eb 06                	jmp    800b1c <strlen+0x15>
		n++;
  800b16:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b19:	ff 45 08             	incl   0x8(%ebp)
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	8a 00                	mov    (%eax),%al
  800b21:	84 c0                	test   %al,%al
  800b23:	75 f1                	jne    800b16 <strlen+0xf>
		n++;
	return n;
  800b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b28:	c9                   	leave  
  800b29:	c3                   	ret    

00800b2a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b37:	eb 09                	jmp    800b42 <strnlen+0x18>
		n++;
  800b39:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b3c:	ff 45 08             	incl   0x8(%ebp)
  800b3f:	ff 4d 0c             	decl   0xc(%ebp)
  800b42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b46:	74 09                	je     800b51 <strnlen+0x27>
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8a 00                	mov    (%eax),%al
  800b4d:	84 c0                	test   %al,%al
  800b4f:	75 e8                	jne    800b39 <strnlen+0xf>
		n++;
	return n;
  800b51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b62:	90                   	nop
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8d 50 01             	lea    0x1(%eax),%edx
  800b69:	89 55 08             	mov    %edx,0x8(%ebp)
  800b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b75:	8a 12                	mov    (%edx),%dl
  800b77:	88 10                	mov    %dl,(%eax)
  800b79:	8a 00                	mov    (%eax),%al
  800b7b:	84 c0                	test   %al,%al
  800b7d:	75 e4                	jne    800b63 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b97:	eb 1f                	jmp    800bb8 <strncpy+0x34>
		*dst++ = *src;
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8d 50 01             	lea    0x1(%eax),%edx
  800b9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba5:	8a 12                	mov    (%edx),%dl
  800ba7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8a 00                	mov    (%eax),%al
  800bae:	84 c0                	test   %al,%al
  800bb0:	74 03                	je     800bb5 <strncpy+0x31>
			src++;
  800bb2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bb5:	ff 45 fc             	incl   -0x4(%ebp)
  800bb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bbb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bbe:	72 d9                	jb     800b99 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd5:	74 30                	je     800c07 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bd7:	eb 16                	jmp    800bef <strlcpy+0x2a>
			*dst++ = *src++;
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	8d 50 01             	lea    0x1(%eax),%edx
  800bdf:	89 55 08             	mov    %edx,0x8(%ebp)
  800be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800beb:	8a 12                	mov    (%edx),%dl
  800bed:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bef:	ff 4d 10             	decl   0x10(%ebp)
  800bf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf6:	74 09                	je     800c01 <strlcpy+0x3c>
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	8a 00                	mov    (%eax),%al
  800bfd:	84 c0                	test   %al,%al
  800bff:	75 d8                	jne    800bd9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c07:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0d:	29 c2                	sub    %eax,%edx
  800c0f:	89 d0                	mov    %edx,%eax
}
  800c11:	c9                   	leave  
  800c12:	c3                   	ret    

00800c13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c16:	eb 06                	jmp    800c1e <strcmp+0xb>
		p++, q++;
  800c18:	ff 45 08             	incl   0x8(%ebp)
  800c1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	84 c0                	test   %al,%al
  800c25:	74 0e                	je     800c35 <strcmp+0x22>
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8a 10                	mov    (%eax),%dl
  800c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2f:	8a 00                	mov    (%eax),%al
  800c31:	38 c2                	cmp    %al,%dl
  800c33:	74 e3                	je     800c18 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 d0             	movzbl %al,%edx
  800c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	0f b6 c0             	movzbl %al,%eax
  800c45:	29 c2                	sub    %eax,%edx
  800c47:	89 d0                	mov    %edx,%eax
}
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c4e:	eb 09                	jmp    800c59 <strncmp+0xe>
		n--, p++, q++;
  800c50:	ff 4d 10             	decl   0x10(%ebp)
  800c53:	ff 45 08             	incl   0x8(%ebp)
  800c56:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5d:	74 17                	je     800c76 <strncmp+0x2b>
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8a 00                	mov    (%eax),%al
  800c64:	84 c0                	test   %al,%al
  800c66:	74 0e                	je     800c76 <strncmp+0x2b>
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8a 10                	mov    (%eax),%dl
  800c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	38 c2                	cmp    %al,%dl
  800c74:	74 da                	je     800c50 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7a:	75 07                	jne    800c83 <strncmp+0x38>
		return 0;
  800c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c81:	eb 14                	jmp    800c97 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 d0             	movzbl %al,%edx
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	8a 00                	mov    (%eax),%al
  800c90:	0f b6 c0             	movzbl %al,%eax
  800c93:	29 c2                	sub    %eax,%edx
  800c95:	89 d0                	mov    %edx,%eax
}
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 04             	sub    $0x4,%esp
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca5:	eb 12                	jmp    800cb9 <strchr+0x20>
		if (*s == c)
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800caf:	75 05                	jne    800cb6 <strchr+0x1d>
			return (char *) s;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	eb 11                	jmp    800cc7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 e5                	jne    800ca7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 04             	sub    $0x4,%esp
  800ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cd5:	eb 0d                	jmp    800ce4 <strfind+0x1b>
		if (*s == c)
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cdf:	74 0e                	je     800cef <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ce1:	ff 45 08             	incl   0x8(%ebp)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	75 ea                	jne    800cd7 <strfind+0xe>
  800ced:	eb 01                	jmp    800cf0 <strfind+0x27>
		if (*s == c)
			break;
  800cef:	90                   	nop
	return (char *) s;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf3:	c9                   	leave  
  800cf4:	c3                   	ret    

00800cf5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d01:	8b 45 10             	mov    0x10(%ebp),%eax
  800d04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d07:	eb 0e                	jmp    800d17 <memset+0x22>
		*p++ = c;
  800d09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0c:	8d 50 01             	lea    0x1(%eax),%edx
  800d0f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d15:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d17:	ff 4d f8             	decl   -0x8(%ebp)
  800d1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d1e:	79 e9                	jns    800d09 <memset+0x14>
		*p++ = c;

	return v;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d37:	eb 16                	jmp    800d4f <memcpy+0x2a>
		*d++ = *s++;
  800d39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d3c:	8d 50 01             	lea    0x1(%eax),%edx
  800d3f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d48:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d4b:	8a 12                	mov    (%edx),%dl
  800d4d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d55:	89 55 10             	mov    %edx,0x10(%ebp)
  800d58:	85 c0                	test   %eax,%eax
  800d5a:	75 dd                	jne    800d39 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5f:	c9                   	leave  
  800d60:	c3                   	ret    

00800d61 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d79:	73 50                	jae    800dcb <memmove+0x6a>
  800d7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d81:	01 d0                	add    %edx,%eax
  800d83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d86:	76 43                	jbe    800dcb <memmove+0x6a>
		s += n;
  800d88:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d91:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d94:	eb 10                	jmp    800da6 <memmove+0x45>
			*--d = *--s;
  800d96:	ff 4d f8             	decl   -0x8(%ebp)
  800d99:	ff 4d fc             	decl   -0x4(%ebp)
  800d9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9f:	8a 10                	mov    (%eax),%dl
  800da1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800da6:	8b 45 10             	mov    0x10(%ebp),%eax
  800da9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dac:	89 55 10             	mov    %edx,0x10(%ebp)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	75 e3                	jne    800d96 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800db3:	eb 23                	jmp    800dd8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800db5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db8:	8d 50 01             	lea    0x1(%eax),%edx
  800dbb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dbe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dc7:	8a 12                	mov    (%edx),%dl
  800dc9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dce:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd1:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd4:	85 c0                	test   %eax,%eax
  800dd6:	75 dd                	jne    800db5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800def:	eb 2a                	jmp    800e1b <memcmp+0x3e>
		if (*s1 != *s2)
  800df1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df4:	8a 10                	mov    (%eax),%dl
  800df6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	38 c2                	cmp    %al,%dl
  800dfd:	74 16                	je     800e15 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	0f b6 d0             	movzbl %al,%edx
  800e07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	0f b6 c0             	movzbl %al,%eax
  800e0f:	29 c2                	sub    %eax,%edx
  800e11:	89 d0                	mov    %edx,%eax
  800e13:	eb 18                	jmp    800e2d <memcmp+0x50>
		s1++, s2++;
  800e15:	ff 45 fc             	incl   -0x4(%ebp)
  800e18:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e21:	89 55 10             	mov    %edx,0x10(%ebp)
  800e24:	85 c0                	test   %eax,%eax
  800e26:	75 c9                	jne    800df1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e35:	8b 55 08             	mov    0x8(%ebp),%edx
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	01 d0                	add    %edx,%eax
  800e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e40:	eb 15                	jmp    800e57 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	0f b6 d0             	movzbl %al,%edx
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	0f b6 c0             	movzbl %al,%eax
  800e50:	39 c2                	cmp    %eax,%edx
  800e52:	74 0d                	je     800e61 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e54:	ff 45 08             	incl   0x8(%ebp)
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e5d:	72 e3                	jb     800e42 <memfind+0x13>
  800e5f:	eb 01                	jmp    800e62 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e61:	90                   	nop
	return (void *) s;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e74:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e7b:	eb 03                	jmp    800e80 <strtol+0x19>
		s++;
  800e7d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	3c 20                	cmp    $0x20,%al
  800e87:	74 f4                	je     800e7d <strtol+0x16>
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	3c 09                	cmp    $0x9,%al
  800e90:	74 eb                	je     800e7d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	3c 2b                	cmp    $0x2b,%al
  800e99:	75 05                	jne    800ea0 <strtol+0x39>
		s++;
  800e9b:	ff 45 08             	incl   0x8(%ebp)
  800e9e:	eb 13                	jmp    800eb3 <strtol+0x4c>
	else if (*s == '-')
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	3c 2d                	cmp    $0x2d,%al
  800ea7:	75 0a                	jne    800eb3 <strtol+0x4c>
		s++, neg = 1;
  800ea9:	ff 45 08             	incl   0x8(%ebp)
  800eac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb7:	74 06                	je     800ebf <strtol+0x58>
  800eb9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ebd:	75 20                	jne    800edf <strtol+0x78>
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	3c 30                	cmp    $0x30,%al
  800ec6:	75 17                	jne    800edf <strtol+0x78>
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	40                   	inc    %eax
  800ecc:	8a 00                	mov    (%eax),%al
  800ece:	3c 78                	cmp    $0x78,%al
  800ed0:	75 0d                	jne    800edf <strtol+0x78>
		s += 2, base = 16;
  800ed2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ed6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800edd:	eb 28                	jmp    800f07 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800edf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee3:	75 15                	jne    800efa <strtol+0x93>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 30                	cmp    $0x30,%al
  800eec:	75 0c                	jne    800efa <strtol+0x93>
		s++, base = 8;
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ef8:	eb 0d                	jmp    800f07 <strtol+0xa0>
	else if (base == 0)
  800efa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efe:	75 07                	jne    800f07 <strtol+0xa0>
		base = 10;
  800f00:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 2f                	cmp    $0x2f,%al
  800f0e:	7e 19                	jle    800f29 <strtol+0xc2>
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	3c 39                	cmp    $0x39,%al
  800f17:	7f 10                	jg     800f29 <strtol+0xc2>
			dig = *s - '0';
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	0f be c0             	movsbl %al,%eax
  800f21:	83 e8 30             	sub    $0x30,%eax
  800f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f27:	eb 42                	jmp    800f6b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 60                	cmp    $0x60,%al
  800f30:	7e 19                	jle    800f4b <strtol+0xe4>
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 7a                	cmp    $0x7a,%al
  800f39:	7f 10                	jg     800f4b <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f be c0             	movsbl %al,%eax
  800f43:	83 e8 57             	sub    $0x57,%eax
  800f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f49:	eb 20                	jmp    800f6b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	3c 40                	cmp    $0x40,%al
  800f52:	7e 39                	jle    800f8d <strtol+0x126>
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	3c 5a                	cmp    $0x5a,%al
  800f5b:	7f 30                	jg     800f8d <strtol+0x126>
			dig = *s - 'A' + 10;
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	0f be c0             	movsbl %al,%eax
  800f65:	83 e8 37             	sub    $0x37,%eax
  800f68:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f71:	7d 19                	jge    800f8c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f73:	ff 45 08             	incl   0x8(%ebp)
  800f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f79:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f7d:	89 c2                	mov    %eax,%edx
  800f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f82:	01 d0                	add    %edx,%eax
  800f84:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f87:	e9 7b ff ff ff       	jmp    800f07 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f8c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f91:	74 08                	je     800f9b <strtol+0x134>
		*endptr = (char *) s;
  800f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f96:	8b 55 08             	mov    0x8(%ebp),%edx
  800f99:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f9f:	74 07                	je     800fa8 <strtol+0x141>
  800fa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa4:	f7 d8                	neg    %eax
  800fa6:	eb 03                	jmp    800fab <strtol+0x144>
  800fa8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <ltostr>:

void
ltostr(long value, char *str)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fc5:	79 13                	jns    800fda <ltostr+0x2d>
	{
		neg = 1;
  800fc7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fd4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fd7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fe2:	99                   	cltd   
  800fe3:	f7 f9                	idiv   %ecx
  800fe5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	8d 50 01             	lea    0x1(%eax),%edx
  800fee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff1:	89 c2                	mov    %eax,%edx
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ffb:	83 c2 30             	add    $0x30,%edx
  800ffe:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801000:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801003:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801008:	f7 e9                	imul   %ecx
  80100a:	c1 fa 02             	sar    $0x2,%edx
  80100d:	89 c8                	mov    %ecx,%eax
  80100f:	c1 f8 1f             	sar    $0x1f,%eax
  801012:	29 c2                	sub    %eax,%edx
  801014:	89 d0                	mov    %edx,%eax
  801016:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801019:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80101d:	75 bb                	jne    800fda <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80101f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801026:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801029:	48                   	dec    %eax
  80102a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80102d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801031:	74 3d                	je     801070 <ltostr+0xc3>
		start = 1 ;
  801033:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80103a:	eb 34                	jmp    801070 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80103c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801042:	01 d0                	add    %edx,%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801049:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	01 c2                	add    %eax,%edx
  801051:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	01 c8                	add    %ecx,%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80105d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801060:	8b 45 0c             	mov    0xc(%ebp),%eax
  801063:	01 c2                	add    %eax,%edx
  801065:	8a 45 eb             	mov    -0x15(%ebp),%al
  801068:	88 02                	mov    %al,(%edx)
		start++ ;
  80106a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80106d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801073:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801076:	7c c4                	jl     80103c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801078:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	01 d0                	add    %edx,%eax
  801080:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801083:	90                   	nop
  801084:	c9                   	leave  
  801085:	c3                   	ret    

00801086 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80108c:	ff 75 08             	pushl  0x8(%ebp)
  80108f:	e8 73 fa ff ff       	call   800b07 <strlen>
  801094:	83 c4 04             	add    $0x4,%esp
  801097:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80109a:	ff 75 0c             	pushl  0xc(%ebp)
  80109d:	e8 65 fa ff ff       	call   800b07 <strlen>
  8010a2:	83 c4 04             	add    $0x4,%esp
  8010a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b6:	eb 17                	jmp    8010cf <strcconcat+0x49>
		final[s] = str1[s] ;
  8010b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010be:	01 c2                	add    %eax,%edx
  8010c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	01 c8                	add    %ecx,%eax
  8010c8:	8a 00                	mov    (%eax),%al
  8010ca:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010cc:	ff 45 fc             	incl   -0x4(%ebp)
  8010cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d5:	7c e1                	jl     8010b8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010e5:	eb 1f                	jmp    801106 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ea:	8d 50 01             	lea    0x1(%eax),%edx
  8010ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f0:	89 c2                	mov    %eax,%edx
  8010f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f5:	01 c2                	add    %eax,%edx
  8010f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	01 c8                	add    %ecx,%eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801103:	ff 45 f8             	incl   -0x8(%ebp)
  801106:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801109:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80110c:	7c d9                	jl     8010e7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80110e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801111:	8b 45 10             	mov    0x10(%ebp),%eax
  801114:	01 d0                	add    %edx,%eax
  801116:	c6 00 00             	movb   $0x0,(%eax)
}
  801119:	90                   	nop
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80111f:	8b 45 14             	mov    0x14(%ebp),%eax
  801122:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801128:	8b 45 14             	mov    0x14(%ebp),%eax
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801134:	8b 45 10             	mov    0x10(%ebp),%eax
  801137:	01 d0                	add    %edx,%eax
  801139:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113f:	eb 0c                	jmp    80114d <strsplit+0x31>
			*string++ = 0;
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8d 50 01             	lea    0x1(%eax),%edx
  801147:	89 55 08             	mov    %edx,0x8(%ebp)
  80114a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	84 c0                	test   %al,%al
  801154:	74 18                	je     80116e <strsplit+0x52>
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	0f be c0             	movsbl %al,%eax
  80115e:	50                   	push   %eax
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	e8 32 fb ff ff       	call   800c99 <strchr>
  801167:	83 c4 08             	add    $0x8,%esp
  80116a:	85 c0                	test   %eax,%eax
  80116c:	75 d3                	jne    801141 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	84 c0                	test   %al,%al
  801175:	74 5a                	je     8011d1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801177:	8b 45 14             	mov    0x14(%ebp),%eax
  80117a:	8b 00                	mov    (%eax),%eax
  80117c:	83 f8 0f             	cmp    $0xf,%eax
  80117f:	75 07                	jne    801188 <strsplit+0x6c>
		{
			return 0;
  801181:	b8 00 00 00 00       	mov    $0x0,%eax
  801186:	eb 66                	jmp    8011ee <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801188:	8b 45 14             	mov    0x14(%ebp),%eax
  80118b:	8b 00                	mov    (%eax),%eax
  80118d:	8d 48 01             	lea    0x1(%eax),%ecx
  801190:	8b 55 14             	mov    0x14(%ebp),%edx
  801193:	89 0a                	mov    %ecx,(%edx)
  801195:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80119c:	8b 45 10             	mov    0x10(%ebp),%eax
  80119f:	01 c2                	add    %eax,%edx
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a6:	eb 03                	jmp    8011ab <strsplit+0x8f>
			string++;
  8011a8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	84 c0                	test   %al,%al
  8011b2:	74 8b                	je     80113f <strsplit+0x23>
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	0f be c0             	movsbl %al,%eax
  8011bc:	50                   	push   %eax
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	e8 d4 fa ff ff       	call   800c99 <strchr>
  8011c5:	83 c4 08             	add    $0x8,%esp
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	74 dc                	je     8011a8 <strsplit+0x8c>
			string++;
	}
  8011cc:	e9 6e ff ff ff       	jmp    80113f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011d1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d5:	8b 00                	mov    (%eax),%eax
  8011d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	68 e8 20 80 00       	push   $0x8020e8
  8011fe:	68 3f 01 00 00       	push   $0x13f
  801203:	68 0a 21 80 00       	push   $0x80210a
  801208:	e8 a9 ef ff ff       	call   8001b6 <_panic>

0080120d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	57                   	push   %edi
  801211:	56                   	push   %esi
  801212:	53                   	push   %ebx
  801213:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80121f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801222:	8b 7d 18             	mov    0x18(%ebp),%edi
  801225:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801228:	cd 30                	int    $0x30
  80122a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80122d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	5b                   	pop    %ebx
  801234:	5e                   	pop    %esi
  801235:	5f                   	pop    %edi
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    

00801238 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 04             	sub    $0x4,%esp
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801244:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	52                   	push   %edx
  801250:	ff 75 0c             	pushl  0xc(%ebp)
  801253:	50                   	push   %eax
  801254:	6a 00                	push   $0x0
  801256:	e8 b2 ff ff ff       	call   80120d <syscall>
  80125b:	83 c4 18             	add    $0x18,%esp
}
  80125e:	90                   	nop
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <sys_cgetc>:

int
sys_cgetc(void)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 02                	push   $0x2
  801270:	e8 98 ff ff ff       	call   80120d <syscall>
  801275:	83 c4 18             	add    $0x18,%esp
}
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 00                	push   $0x0
  801287:	6a 03                	push   $0x3
  801289:	e8 7f ff ff ff       	call   80120d <syscall>
  80128e:	83 c4 18             	add    $0x18,%esp
}
  801291:	90                   	nop
  801292:	c9                   	leave  
  801293:	c3                   	ret    

00801294 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	6a 04                	push   $0x4
  8012a3:	e8 65 ff ff ff       	call   80120d <syscall>
  8012a8:	83 c4 18             	add    $0x18,%esp
}
  8012ab:	90                   	nop
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	52                   	push   %edx
  8012be:	50                   	push   %eax
  8012bf:	6a 08                	push   $0x8
  8012c1:	e8 47 ff ff ff       	call   80120d <syscall>
  8012c6:	83 c4 18             	add    $0x18,%esp
}
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	56                   	push   %esi
  8012cf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012d0:	8b 75 18             	mov    0x18(%ebp),%esi
  8012d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	56                   	push   %esi
  8012e0:	53                   	push   %ebx
  8012e1:	51                   	push   %ecx
  8012e2:	52                   	push   %edx
  8012e3:	50                   	push   %eax
  8012e4:	6a 09                	push   $0x9
  8012e6:	e8 22 ff ff ff       	call   80120d <syscall>
  8012eb:	83 c4 18             	add    $0x18,%esp
}
  8012ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012f1:	5b                   	pop    %ebx
  8012f2:	5e                   	pop    %esi
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    

008012f5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	52                   	push   %edx
  801305:	50                   	push   %eax
  801306:	6a 0a                	push   $0xa
  801308:	e8 00 ff ff ff       	call   80120d <syscall>
  80130d:	83 c4 18             	add    $0x18,%esp
}
  801310:	c9                   	leave  
  801311:	c3                   	ret    

00801312 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	ff 75 08             	pushl  0x8(%ebp)
  801321:	6a 0b                	push   $0xb
  801323:	e8 e5 fe ff ff       	call   80120d <syscall>
  801328:	83 c4 18             	add    $0x18,%esp
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 0c                	push   $0xc
  80133c:	e8 cc fe ff ff       	call   80120d <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 0d                	push   $0xd
  801355:	e8 b3 fe ff ff       	call   80120d <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 0e                	push   $0xe
  80136e:	e8 9a fe ff ff       	call   80120d <syscall>
  801373:	83 c4 18             	add    $0x18,%esp
}
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 0f                	push   $0xf
  801387:	e8 81 fe ff ff       	call   80120d <syscall>
  80138c:	83 c4 18             	add    $0x18,%esp
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	ff 75 08             	pushl  0x8(%ebp)
  80139f:	6a 10                	push   $0x10
  8013a1:	e8 67 fe ff ff       	call   80120d <syscall>
  8013a6:	83 c4 18             	add    $0x18,%esp
}
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    

008013ab <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 11                	push   $0x11
  8013ba:	e8 4e fe ff ff       	call   80120d <syscall>
  8013bf:	83 c4 18             	add    $0x18,%esp
}
  8013c2:	90                   	nop
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    

008013c5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	83 ec 04             	sub    $0x4,%esp
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013d1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	50                   	push   %eax
  8013de:	6a 01                	push   $0x1
  8013e0:	e8 28 fe ff ff       	call   80120d <syscall>
  8013e5:	83 c4 18             	add    $0x18,%esp
}
  8013e8:	90                   	nop
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 14                	push   $0x14
  8013fa:	e8 0e fe ff ff       	call   80120d <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 04             	sub    $0x4,%esp
  80140b:	8b 45 10             	mov    0x10(%ebp),%eax
  80140e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801411:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801414:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	6a 00                	push   $0x0
  80141d:	51                   	push   %ecx
  80141e:	52                   	push   %edx
  80141f:	ff 75 0c             	pushl  0xc(%ebp)
  801422:	50                   	push   %eax
  801423:	6a 15                	push   $0x15
  801425:	e8 e3 fd ff ff       	call   80120d <syscall>
  80142a:	83 c4 18             	add    $0x18,%esp
}
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801432:	8b 55 0c             	mov    0xc(%ebp),%edx
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	52                   	push   %edx
  80143f:	50                   	push   %eax
  801440:	6a 16                	push   $0x16
  801442:	e8 c6 fd ff ff       	call   80120d <syscall>
  801447:	83 c4 18             	add    $0x18,%esp
}
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80144f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801452:	8b 55 0c             	mov    0xc(%ebp),%edx
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	51                   	push   %ecx
  80145d:	52                   	push   %edx
  80145e:	50                   	push   %eax
  80145f:	6a 17                	push   $0x17
  801461:	e8 a7 fd ff ff       	call   80120d <syscall>
  801466:	83 c4 18             	add    $0x18,%esp
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80146e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	52                   	push   %edx
  80147b:	50                   	push   %eax
  80147c:	6a 18                	push   $0x18
  80147e:	e8 8a fd ff ff       	call   80120d <syscall>
  801483:	83 c4 18             	add    $0x18,%esp
}
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	6a 00                	push   $0x0
  801490:	ff 75 14             	pushl  0x14(%ebp)
  801493:	ff 75 10             	pushl  0x10(%ebp)
  801496:	ff 75 0c             	pushl  0xc(%ebp)
  801499:	50                   	push   %eax
  80149a:	6a 19                	push   $0x19
  80149c:	e8 6c fd ff ff       	call   80120d <syscall>
  8014a1:	83 c4 18             	add    $0x18,%esp
}
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    

008014a6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	50                   	push   %eax
  8014b5:	6a 1a                	push   $0x1a
  8014b7:	e8 51 fd ff ff       	call   80120d <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
}
  8014bf:	90                   	nop
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	50                   	push   %eax
  8014d1:	6a 1b                	push   $0x1b
  8014d3:	e8 35 fd ff ff       	call   80120d <syscall>
  8014d8:	83 c4 18             	add    $0x18,%esp
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 05                	push   $0x5
  8014ec:	e8 1c fd ff ff       	call   80120d <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 06                	push   $0x6
  801505:	e8 03 fd ff ff       	call   80120d <syscall>
  80150a:	83 c4 18             	add    $0x18,%esp
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 07                	push   $0x7
  80151e:	e8 ea fc ff ff       	call   80120d <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sys_exit_env>:


void sys_exit_env(void)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 1c                	push   $0x1c
  801537:	e8 d1 fc ff ff       	call   80120d <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
}
  80153f:	90                   	nop
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801548:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80154b:	8d 50 04             	lea    0x4(%eax),%edx
  80154e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	52                   	push   %edx
  801558:	50                   	push   %eax
  801559:	6a 1d                	push   $0x1d
  80155b:	e8 ad fc ff ff       	call   80120d <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
	return result;
  801563:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801566:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801569:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80156c:	89 01                	mov    %eax,(%ecx)
  80156e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	c9                   	leave  
  801575:	c2 04 00             	ret    $0x4

00801578 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	ff 75 10             	pushl  0x10(%ebp)
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	ff 75 08             	pushl  0x8(%ebp)
  801588:	6a 13                	push   $0x13
  80158a:	e8 7e fc ff ff       	call   80120d <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
	return ;
  801592:	90                   	nop
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_rcr2>:
uint32 sys_rcr2()
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 1e                	push   $0x1e
  8015a4:	e8 64 fc ff ff       	call   80120d <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015ba:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	50                   	push   %eax
  8015c7:	6a 1f                	push   $0x1f
  8015c9:	e8 3f fc ff ff       	call   80120d <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d1:	90                   	nop
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <rsttst>:
void rsttst()
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 21                	push   $0x21
  8015e3:	e8 25 fc ff ff       	call   80120d <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015eb:	90                   	nop
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 04             	sub    $0x4,%esp
  8015f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015fa:	8b 55 18             	mov    0x18(%ebp),%edx
  8015fd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801601:	52                   	push   %edx
  801602:	50                   	push   %eax
  801603:	ff 75 10             	pushl  0x10(%ebp)
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	ff 75 08             	pushl  0x8(%ebp)
  80160c:	6a 20                	push   $0x20
  80160e:	e8 fa fb ff ff       	call   80120d <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
	return ;
  801616:	90                   	nop
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <chktst>:
void chktst(uint32 n)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	ff 75 08             	pushl  0x8(%ebp)
  801627:	6a 22                	push   $0x22
  801629:	e8 df fb ff ff       	call   80120d <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
	return ;
  801631:	90                   	nop
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <inctst>:

void inctst()
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 23                	push   $0x23
  801643:	e8 c5 fb ff ff       	call   80120d <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
	return ;
  80164b:	90                   	nop
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <gettst>:
uint32 gettst()
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 24                	push   $0x24
  80165d:	e8 ab fb ff ff       	call   80120d <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 25                	push   $0x25
  801679:	e8 8f fb ff ff       	call   80120d <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
  801681:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801684:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801688:	75 07                	jne    801691 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80168a:	b8 01 00 00 00       	mov    $0x1,%eax
  80168f:	eb 05                	jmp    801696 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801691:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 25                	push   $0x25
  8016aa:	e8 5e fb ff ff       	call   80120d <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
  8016b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016b5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016b9:	75 07                	jne    8016c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8016c0:	eb 05                	jmp    8016c7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 25                	push   $0x25
  8016db:	e8 2d fb ff ff       	call   80120d <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
  8016e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016e6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016ea:	75 07                	jne    8016f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f1:	eb 05                	jmp    8016f8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 25                	push   $0x25
  80170c:	e8 fc fa ff ff       	call   80120d <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
  801714:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801717:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80171b:	75 07                	jne    801724 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80171d:	b8 01 00 00 00       	mov    $0x1,%eax
  801722:	eb 05                	jmp    801729 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801724:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	ff 75 08             	pushl  0x8(%ebp)
  801739:	6a 26                	push   $0x26
  80173b:	e8 cd fa ff ff       	call   80120d <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
	return ;
  801743:	90                   	nop
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80174a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801750:	8b 55 0c             	mov    0xc(%ebp),%edx
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	6a 00                	push   $0x0
  801758:	53                   	push   %ebx
  801759:	51                   	push   %ecx
  80175a:	52                   	push   %edx
  80175b:	50                   	push   %eax
  80175c:	6a 27                	push   $0x27
  80175e:	e8 aa fa ff ff       	call   80120d <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80176e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	52                   	push   %edx
  80177b:	50                   	push   %eax
  80177c:	6a 28                	push   $0x28
  80177e:	e8 8a fa ff ff       	call   80120d <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80178b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	6a 00                	push   $0x0
  801796:	51                   	push   %ecx
  801797:	ff 75 10             	pushl  0x10(%ebp)
  80179a:	52                   	push   %edx
  80179b:	50                   	push   %eax
  80179c:	6a 29                	push   $0x29
  80179e:	e8 6a fa ff ff       	call   80120d <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	ff 75 10             	pushl  0x10(%ebp)
  8017b2:	ff 75 0c             	pushl  0xc(%ebp)
  8017b5:	ff 75 08             	pushl  0x8(%ebp)
  8017b8:	6a 12                	push   $0x12
  8017ba:	e8 4e fa ff ff       	call   80120d <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c2:	90                   	nop
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	52                   	push   %edx
  8017d5:	50                   	push   %eax
  8017d6:	6a 2a                	push   $0x2a
  8017d8:	e8 30 fa ff ff       	call   80120d <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
	return;
  8017e0:	90                   	nop
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017e9:	83 ec 04             	sub    $0x4,%esp
  8017ec:	68 17 21 80 00       	push   $0x802117
  8017f1:	68 2e 01 00 00       	push   $0x12e
  8017f6:	68 2b 21 80 00       	push   $0x80212b
  8017fb:	e8 b6 e9 ff ff       	call   8001b6 <_panic>

00801800 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	68 17 21 80 00       	push   $0x802117
  80180e:	68 35 01 00 00       	push   $0x135
  801813:	68 2b 21 80 00       	push   $0x80212b
  801818:	e8 99 e9 ff ff       	call   8001b6 <_panic>

0080181d <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	68 17 21 80 00       	push   $0x802117
  80182b:	68 3b 01 00 00       	push   $0x13b
  801830:	68 2b 21 80 00       	push   $0x80212b
  801835:	e8 7c e9 ff ff       	call   8001b6 <_panic>
  80183a:	66 90                	xchg   %ax,%ax

0080183c <__udivdi3>:
  80183c:	55                   	push   %ebp
  80183d:	57                   	push   %edi
  80183e:	56                   	push   %esi
  80183f:	53                   	push   %ebx
  801840:	83 ec 1c             	sub    $0x1c,%esp
  801843:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801847:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80184b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80184f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801853:	89 ca                	mov    %ecx,%edx
  801855:	89 f8                	mov    %edi,%eax
  801857:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80185b:	85 f6                	test   %esi,%esi
  80185d:	75 2d                	jne    80188c <__udivdi3+0x50>
  80185f:	39 cf                	cmp    %ecx,%edi
  801861:	77 65                	ja     8018c8 <__udivdi3+0x8c>
  801863:	89 fd                	mov    %edi,%ebp
  801865:	85 ff                	test   %edi,%edi
  801867:	75 0b                	jne    801874 <__udivdi3+0x38>
  801869:	b8 01 00 00 00       	mov    $0x1,%eax
  80186e:	31 d2                	xor    %edx,%edx
  801870:	f7 f7                	div    %edi
  801872:	89 c5                	mov    %eax,%ebp
  801874:	31 d2                	xor    %edx,%edx
  801876:	89 c8                	mov    %ecx,%eax
  801878:	f7 f5                	div    %ebp
  80187a:	89 c1                	mov    %eax,%ecx
  80187c:	89 d8                	mov    %ebx,%eax
  80187e:	f7 f5                	div    %ebp
  801880:	89 cf                	mov    %ecx,%edi
  801882:	89 fa                	mov    %edi,%edx
  801884:	83 c4 1c             	add    $0x1c,%esp
  801887:	5b                   	pop    %ebx
  801888:	5e                   	pop    %esi
  801889:	5f                   	pop    %edi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    
  80188c:	39 ce                	cmp    %ecx,%esi
  80188e:	77 28                	ja     8018b8 <__udivdi3+0x7c>
  801890:	0f bd fe             	bsr    %esi,%edi
  801893:	83 f7 1f             	xor    $0x1f,%edi
  801896:	75 40                	jne    8018d8 <__udivdi3+0x9c>
  801898:	39 ce                	cmp    %ecx,%esi
  80189a:	72 0a                	jb     8018a6 <__udivdi3+0x6a>
  80189c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018a0:	0f 87 9e 00 00 00    	ja     801944 <__udivdi3+0x108>
  8018a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ab:	89 fa                	mov    %edi,%edx
  8018ad:	83 c4 1c             	add    $0x1c,%esp
  8018b0:	5b                   	pop    %ebx
  8018b1:	5e                   	pop    %esi
  8018b2:	5f                   	pop    %edi
  8018b3:	5d                   	pop    %ebp
  8018b4:	c3                   	ret    
  8018b5:	8d 76 00             	lea    0x0(%esi),%esi
  8018b8:	31 ff                	xor    %edi,%edi
  8018ba:	31 c0                	xor    %eax,%eax
  8018bc:	89 fa                	mov    %edi,%edx
  8018be:	83 c4 1c             	add    $0x1c,%esp
  8018c1:	5b                   	pop    %ebx
  8018c2:	5e                   	pop    %esi
  8018c3:	5f                   	pop    %edi
  8018c4:	5d                   	pop    %ebp
  8018c5:	c3                   	ret    
  8018c6:	66 90                	xchg   %ax,%ax
  8018c8:	89 d8                	mov    %ebx,%eax
  8018ca:	f7 f7                	div    %edi
  8018cc:	31 ff                	xor    %edi,%edi
  8018ce:	89 fa                	mov    %edi,%edx
  8018d0:	83 c4 1c             	add    $0x1c,%esp
  8018d3:	5b                   	pop    %ebx
  8018d4:	5e                   	pop    %esi
  8018d5:	5f                   	pop    %edi
  8018d6:	5d                   	pop    %ebp
  8018d7:	c3                   	ret    
  8018d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018dd:	89 eb                	mov    %ebp,%ebx
  8018df:	29 fb                	sub    %edi,%ebx
  8018e1:	89 f9                	mov    %edi,%ecx
  8018e3:	d3 e6                	shl    %cl,%esi
  8018e5:	89 c5                	mov    %eax,%ebp
  8018e7:	88 d9                	mov    %bl,%cl
  8018e9:	d3 ed                	shr    %cl,%ebp
  8018eb:	89 e9                	mov    %ebp,%ecx
  8018ed:	09 f1                	or     %esi,%ecx
  8018ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018f3:	89 f9                	mov    %edi,%ecx
  8018f5:	d3 e0                	shl    %cl,%eax
  8018f7:	89 c5                	mov    %eax,%ebp
  8018f9:	89 d6                	mov    %edx,%esi
  8018fb:	88 d9                	mov    %bl,%cl
  8018fd:	d3 ee                	shr    %cl,%esi
  8018ff:	89 f9                	mov    %edi,%ecx
  801901:	d3 e2                	shl    %cl,%edx
  801903:	8b 44 24 08          	mov    0x8(%esp),%eax
  801907:	88 d9                	mov    %bl,%cl
  801909:	d3 e8                	shr    %cl,%eax
  80190b:	09 c2                	or     %eax,%edx
  80190d:	89 d0                	mov    %edx,%eax
  80190f:	89 f2                	mov    %esi,%edx
  801911:	f7 74 24 0c          	divl   0xc(%esp)
  801915:	89 d6                	mov    %edx,%esi
  801917:	89 c3                	mov    %eax,%ebx
  801919:	f7 e5                	mul    %ebp
  80191b:	39 d6                	cmp    %edx,%esi
  80191d:	72 19                	jb     801938 <__udivdi3+0xfc>
  80191f:	74 0b                	je     80192c <__udivdi3+0xf0>
  801921:	89 d8                	mov    %ebx,%eax
  801923:	31 ff                	xor    %edi,%edi
  801925:	e9 58 ff ff ff       	jmp    801882 <__udivdi3+0x46>
  80192a:	66 90                	xchg   %ax,%ax
  80192c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801930:	89 f9                	mov    %edi,%ecx
  801932:	d3 e2                	shl    %cl,%edx
  801934:	39 c2                	cmp    %eax,%edx
  801936:	73 e9                	jae    801921 <__udivdi3+0xe5>
  801938:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80193b:	31 ff                	xor    %edi,%edi
  80193d:	e9 40 ff ff ff       	jmp    801882 <__udivdi3+0x46>
  801942:	66 90                	xchg   %ax,%ax
  801944:	31 c0                	xor    %eax,%eax
  801946:	e9 37 ff ff ff       	jmp    801882 <__udivdi3+0x46>
  80194b:	90                   	nop

0080194c <__umoddi3>:
  80194c:	55                   	push   %ebp
  80194d:	57                   	push   %edi
  80194e:	56                   	push   %esi
  80194f:	53                   	push   %ebx
  801950:	83 ec 1c             	sub    $0x1c,%esp
  801953:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801957:	8b 74 24 34          	mov    0x34(%esp),%esi
  80195b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80195f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801963:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801967:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80196b:	89 f3                	mov    %esi,%ebx
  80196d:	89 fa                	mov    %edi,%edx
  80196f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801973:	89 34 24             	mov    %esi,(%esp)
  801976:	85 c0                	test   %eax,%eax
  801978:	75 1a                	jne    801994 <__umoddi3+0x48>
  80197a:	39 f7                	cmp    %esi,%edi
  80197c:	0f 86 a2 00 00 00    	jbe    801a24 <__umoddi3+0xd8>
  801982:	89 c8                	mov    %ecx,%eax
  801984:	89 f2                	mov    %esi,%edx
  801986:	f7 f7                	div    %edi
  801988:	89 d0                	mov    %edx,%eax
  80198a:	31 d2                	xor    %edx,%edx
  80198c:	83 c4 1c             	add    $0x1c,%esp
  80198f:	5b                   	pop    %ebx
  801990:	5e                   	pop    %esi
  801991:	5f                   	pop    %edi
  801992:	5d                   	pop    %ebp
  801993:	c3                   	ret    
  801994:	39 f0                	cmp    %esi,%eax
  801996:	0f 87 ac 00 00 00    	ja     801a48 <__umoddi3+0xfc>
  80199c:	0f bd e8             	bsr    %eax,%ebp
  80199f:	83 f5 1f             	xor    $0x1f,%ebp
  8019a2:	0f 84 ac 00 00 00    	je     801a54 <__umoddi3+0x108>
  8019a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8019ad:	29 ef                	sub    %ebp,%edi
  8019af:	89 fe                	mov    %edi,%esi
  8019b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019b5:	89 e9                	mov    %ebp,%ecx
  8019b7:	d3 e0                	shl    %cl,%eax
  8019b9:	89 d7                	mov    %edx,%edi
  8019bb:	89 f1                	mov    %esi,%ecx
  8019bd:	d3 ef                	shr    %cl,%edi
  8019bf:	09 c7                	or     %eax,%edi
  8019c1:	89 e9                	mov    %ebp,%ecx
  8019c3:	d3 e2                	shl    %cl,%edx
  8019c5:	89 14 24             	mov    %edx,(%esp)
  8019c8:	89 d8                	mov    %ebx,%eax
  8019ca:	d3 e0                	shl    %cl,%eax
  8019cc:	89 c2                	mov    %eax,%edx
  8019ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019d2:	d3 e0                	shl    %cl,%eax
  8019d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019dc:	89 f1                	mov    %esi,%ecx
  8019de:	d3 e8                	shr    %cl,%eax
  8019e0:	09 d0                	or     %edx,%eax
  8019e2:	d3 eb                	shr    %cl,%ebx
  8019e4:	89 da                	mov    %ebx,%edx
  8019e6:	f7 f7                	div    %edi
  8019e8:	89 d3                	mov    %edx,%ebx
  8019ea:	f7 24 24             	mull   (%esp)
  8019ed:	89 c6                	mov    %eax,%esi
  8019ef:	89 d1                	mov    %edx,%ecx
  8019f1:	39 d3                	cmp    %edx,%ebx
  8019f3:	0f 82 87 00 00 00    	jb     801a80 <__umoddi3+0x134>
  8019f9:	0f 84 91 00 00 00    	je     801a90 <__umoddi3+0x144>
  8019ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a03:	29 f2                	sub    %esi,%edx
  801a05:	19 cb                	sbb    %ecx,%ebx
  801a07:	89 d8                	mov    %ebx,%eax
  801a09:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a0d:	d3 e0                	shl    %cl,%eax
  801a0f:	89 e9                	mov    %ebp,%ecx
  801a11:	d3 ea                	shr    %cl,%edx
  801a13:	09 d0                	or     %edx,%eax
  801a15:	89 e9                	mov    %ebp,%ecx
  801a17:	d3 eb                	shr    %cl,%ebx
  801a19:	89 da                	mov    %ebx,%edx
  801a1b:	83 c4 1c             	add    $0x1c,%esp
  801a1e:	5b                   	pop    %ebx
  801a1f:	5e                   	pop    %esi
  801a20:	5f                   	pop    %edi
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    
  801a23:	90                   	nop
  801a24:	89 fd                	mov    %edi,%ebp
  801a26:	85 ff                	test   %edi,%edi
  801a28:	75 0b                	jne    801a35 <__umoddi3+0xe9>
  801a2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2f:	31 d2                	xor    %edx,%edx
  801a31:	f7 f7                	div    %edi
  801a33:	89 c5                	mov    %eax,%ebp
  801a35:	89 f0                	mov    %esi,%eax
  801a37:	31 d2                	xor    %edx,%edx
  801a39:	f7 f5                	div    %ebp
  801a3b:	89 c8                	mov    %ecx,%eax
  801a3d:	f7 f5                	div    %ebp
  801a3f:	89 d0                	mov    %edx,%eax
  801a41:	e9 44 ff ff ff       	jmp    80198a <__umoddi3+0x3e>
  801a46:	66 90                	xchg   %ax,%ax
  801a48:	89 c8                	mov    %ecx,%eax
  801a4a:	89 f2                	mov    %esi,%edx
  801a4c:	83 c4 1c             	add    $0x1c,%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5e                   	pop    %esi
  801a51:	5f                   	pop    %edi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    
  801a54:	3b 04 24             	cmp    (%esp),%eax
  801a57:	72 06                	jb     801a5f <__umoddi3+0x113>
  801a59:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a5d:	77 0f                	ja     801a6e <__umoddi3+0x122>
  801a5f:	89 f2                	mov    %esi,%edx
  801a61:	29 f9                	sub    %edi,%ecx
  801a63:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a67:	89 14 24             	mov    %edx,(%esp)
  801a6a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a6e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a72:	8b 14 24             	mov    (%esp),%edx
  801a75:	83 c4 1c             	add    $0x1c,%esp
  801a78:	5b                   	pop    %ebx
  801a79:	5e                   	pop    %esi
  801a7a:	5f                   	pop    %edi
  801a7b:	5d                   	pop    %ebp
  801a7c:	c3                   	ret    
  801a7d:	8d 76 00             	lea    0x0(%esi),%esi
  801a80:	2b 04 24             	sub    (%esp),%eax
  801a83:	19 fa                	sbb    %edi,%edx
  801a85:	89 d1                	mov    %edx,%ecx
  801a87:	89 c6                	mov    %eax,%esi
  801a89:	e9 71 ff ff ff       	jmp    8019ff <__umoddi3+0xb3>
  801a8e:	66 90                	xchg   %ax,%ax
  801a90:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a94:	72 ea                	jb     801a80 <__umoddi3+0x134>
  801a96:	89 d9                	mov    %ebx,%ecx
  801a98:	e9 62 ff ff ff       	jmp    8019ff <__umoddi3+0xb3>
