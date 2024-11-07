
obj/user/tst_syscalls_2_slave3:     file format elf32-i386


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
  800031:	e8 36 00 00 00       	call   80006c <libmain>
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
	//[2] Invalid Range (Cross USER_LIMIT)
	sys_free_user_mem(USER_HEAP_MAX - PAGE_SIZE, PAGE_SIZE + 10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	68 0a 10 00 00       	push   $0x100a
  800046:	68 00 f0 ff 9f       	push   $0x9ffff000
  80004b:	e8 9b 17 00 00       	call   8017eb <sys_free_user_mem>
  800050:	83 c4 10             	add    $0x10,%esp
	inctst();
  800053:	e8 c9 15 00 00       	call   801621 <inctst>
	panic("tst system calls #2 failed: sys_free_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 a0 1a 80 00       	push   $0x801aa0
  800060:	6a 0a                	push   $0xa
  800062:	68 1e 1b 80 00       	push   $0x801b1e
  800067:	e8 37 01 00 00       	call   8001a3 <_panic>

0080006c <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80006c:	55                   	push   %ebp
  80006d:	89 e5                	mov    %esp,%ebp
  80006f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800072:	e8 6c 14 00 00       	call   8014e3 <sys_getenvindex>
  800077:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80007a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007d:	89 d0                	mov    %edx,%eax
  80007f:	c1 e0 02             	shl    $0x2,%eax
  800082:	01 d0                	add    %edx,%eax
  800084:	01 c0                	add    %eax,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	c1 e0 02             	shl    $0x2,%eax
  80008b:	01 d0                	add    %edx,%eax
  80008d:	01 c0                	add    %eax,%eax
  80008f:	01 d0                	add    %edx,%eax
  800091:	c1 e0 04             	shl    $0x4,%eax
  800094:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800099:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009e:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a3:	8a 40 20             	mov    0x20(%eax),%al
  8000a6:	84 c0                	test   %al,%al
  8000a8:	74 0d                	je     8000b7 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000aa:	a1 04 30 80 00       	mov    0x803004,%eax
  8000af:	83 c0 20             	add    $0x20,%eax
  8000b2:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000bb:	7e 0a                	jle    8000c7 <libmain+0x5b>
		binaryname = argv[0];
  8000bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c0:	8b 00                	mov    (%eax),%eax
  8000c2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	ff 75 0c             	pushl  0xc(%ebp)
  8000cd:	ff 75 08             	pushl  0x8(%ebp)
  8000d0:	e8 63 ff ff ff       	call   800038 <_main>
  8000d5:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000d8:	e8 8a 11 00 00       	call   801267 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 54 1b 80 00       	push   $0x801b54
  8000e5:	e8 76 03 00 00       	call   800460 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000ed:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f2:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000fd:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	52                   	push   %edx
  800107:	50                   	push   %eax
  800108:	68 7c 1b 80 00       	push   $0x801b7c
  80010d:	e8 4e 03 00 00       	call   800460 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800115:	a1 04 30 80 00       	mov    0x803004,%eax
  80011a:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800120:	a1 04 30 80 00       	mov    0x803004,%eax
  800125:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  80012b:	a1 04 30 80 00       	mov    0x803004,%eax
  800130:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800136:	51                   	push   %ecx
  800137:	52                   	push   %edx
  800138:	50                   	push   %eax
  800139:	68 a4 1b 80 00       	push   $0x801ba4
  80013e:	e8 1d 03 00 00       	call   800460 <cprintf>
  800143:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800146:	a1 04 30 80 00       	mov    0x803004,%eax
  80014b:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	50                   	push   %eax
  800155:	68 fc 1b 80 00       	push   $0x801bfc
  80015a:	e8 01 03 00 00       	call   800460 <cprintf>
  80015f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 54 1b 80 00       	push   $0x801b54
  80016a:	e8 f1 02 00 00       	call   800460 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800172:	e8 0a 11 00 00       	call   801281 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800177:	e8 19 00 00 00       	call   800195 <exit>
}
  80017c:	90                   	nop
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    

0080017f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	6a 00                	push   $0x0
  80018a:	e8 20 13 00 00       	call   8014af <sys_destroy_env>
  80018f:	83 c4 10             	add    $0x10,%esp
}
  800192:	90                   	nop
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <exit>:

void
exit(void)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80019b:	e8 75 13 00 00       	call   801515 <sys_exit_env>
}
  8001a0:	90                   	nop
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8001ac:	83 c0 04             	add    $0x4,%eax
  8001af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001b2:	a1 24 30 80 00       	mov    0x803024,%eax
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	74 16                	je     8001d1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001bb:	a1 24 30 80 00       	mov    0x803024,%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 10 1c 80 00       	push   $0x801c10
  8001c9:	e8 92 02 00 00       	call   800460 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001d1:	a1 00 30 80 00       	mov    0x803000,%eax
  8001d6:	ff 75 0c             	pushl  0xc(%ebp)
  8001d9:	ff 75 08             	pushl  0x8(%ebp)
  8001dc:	50                   	push   %eax
  8001dd:	68 15 1c 80 00       	push   $0x801c15
  8001e2:	e8 79 02 00 00       	call   800460 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ed:	83 ec 08             	sub    $0x8,%esp
  8001f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f3:	50                   	push   %eax
  8001f4:	e8 fc 01 00 00       	call   8003f5 <vcprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001fc:	83 ec 08             	sub    $0x8,%esp
  8001ff:	6a 00                	push   $0x0
  800201:	68 31 1c 80 00       	push   $0x801c31
  800206:	e8 ea 01 00 00       	call   8003f5 <vcprintf>
  80020b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80020e:	e8 82 ff ff ff       	call   800195 <exit>

	// should not return here
	while (1) ;
  800213:	eb fe                	jmp    800213 <_panic+0x70>

00800215 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80021b:	a1 04 30 80 00       	mov    0x803004,%eax
  800220:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800226:	8b 45 0c             	mov    0xc(%ebp),%eax
  800229:	39 c2                	cmp    %eax,%edx
  80022b:	74 14                	je     800241 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80022d:	83 ec 04             	sub    $0x4,%esp
  800230:	68 34 1c 80 00       	push   $0x801c34
  800235:	6a 26                	push   $0x26
  800237:	68 80 1c 80 00       	push   $0x801c80
  80023c:	e8 62 ff ff ff       	call   8001a3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800241:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800248:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80024f:	e9 c5 00 00 00       	jmp    800319 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800257:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	01 d0                	add    %edx,%eax
  800263:	8b 00                	mov    (%eax),%eax
  800265:	85 c0                	test   %eax,%eax
  800267:	75 08                	jne    800271 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800269:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80026c:	e9 a5 00 00 00       	jmp    800316 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800271:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800278:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80027f:	eb 69                	jmp    8002ea <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800281:	a1 04 30 80 00       	mov    0x803004,%eax
  800286:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80028c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80028f:	89 d0                	mov    %edx,%eax
  800291:	01 c0                	add    %eax,%eax
  800293:	01 d0                	add    %edx,%eax
  800295:	c1 e0 03             	shl    $0x3,%eax
  800298:	01 c8                	add    %ecx,%eax
  80029a:	8a 40 04             	mov    0x4(%eax),%al
  80029d:	84 c0                	test   %al,%al
  80029f:	75 46                	jne    8002e7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002a1:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a6:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8002ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	01 c0                	add    %eax,%eax
  8002b3:	01 d0                	add    %edx,%eax
  8002b5:	c1 e0 03             	shl    $0x3,%eax
  8002b8:	01 c8                	add    %ecx,%eax
  8002ba:	8b 00                	mov    (%eax),%eax
  8002bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002cc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002da:	39 c2                	cmp    %eax,%edx
  8002dc:	75 09                	jne    8002e7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002de:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002e5:	eb 15                	jmp    8002fc <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e7:	ff 45 e8             	incl   -0x18(%ebp)
  8002ea:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ef:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f8:	39 c2                	cmp    %eax,%edx
  8002fa:	77 85                	ja     800281 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800300:	75 14                	jne    800316 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800302:	83 ec 04             	sub    $0x4,%esp
  800305:	68 8c 1c 80 00       	push   $0x801c8c
  80030a:	6a 3a                	push   $0x3a
  80030c:	68 80 1c 80 00       	push   $0x801c80
  800311:	e8 8d fe ff ff       	call   8001a3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800316:	ff 45 f0             	incl   -0x10(%ebp)
  800319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80031f:	0f 8c 2f ff ff ff    	jl     800254 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800325:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800333:	eb 26                	jmp    80035b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800335:	a1 04 30 80 00       	mov    0x803004,%eax
  80033a:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800340:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800343:	89 d0                	mov    %edx,%eax
  800345:	01 c0                	add    %eax,%eax
  800347:	01 d0                	add    %edx,%eax
  800349:	c1 e0 03             	shl    $0x3,%eax
  80034c:	01 c8                	add    %ecx,%eax
  80034e:	8a 40 04             	mov    0x4(%eax),%al
  800351:	3c 01                	cmp    $0x1,%al
  800353:	75 03                	jne    800358 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800355:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800358:	ff 45 e0             	incl   -0x20(%ebp)
  80035b:	a1 04 30 80 00       	mov    0x803004,%eax
  800360:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800369:	39 c2                	cmp    %eax,%edx
  80036b:	77 c8                	ja     800335 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80036d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800370:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800373:	74 14                	je     800389 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800375:	83 ec 04             	sub    $0x4,%esp
  800378:	68 e0 1c 80 00       	push   $0x801ce0
  80037d:	6a 44                	push   $0x44
  80037f:	68 80 1c 80 00       	push   $0x801c80
  800384:	e8 1a fe ff ff       	call   8001a3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800389:	90                   	nop
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800392:	8b 45 0c             	mov    0xc(%ebp),%eax
  800395:	8b 00                	mov    (%eax),%eax
  800397:	8d 48 01             	lea    0x1(%eax),%ecx
  80039a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039d:	89 0a                	mov    %ecx,(%edx)
  80039f:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a2:	88 d1                	mov    %dl,%cl
  8003a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ae:	8b 00                	mov    (%eax),%eax
  8003b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b5:	75 2c                	jne    8003e3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b7:	a0 08 30 80 00       	mov    0x803008,%al
  8003bc:	0f b6 c0             	movzbl %al,%eax
  8003bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c2:	8b 12                	mov    (%edx),%edx
  8003c4:	89 d1                	mov    %edx,%ecx
  8003c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c9:	83 c2 08             	add    $0x8,%edx
  8003cc:	83 ec 04             	sub    $0x4,%esp
  8003cf:	50                   	push   %eax
  8003d0:	51                   	push   %ecx
  8003d1:	52                   	push   %edx
  8003d2:	e8 4e 0e 00 00       	call   801225 <sys_cputs>
  8003d7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e6:	8b 40 04             	mov    0x4(%eax),%eax
  8003e9:	8d 50 01             	lea    0x1(%eax),%edx
  8003ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ef:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003f2:	90                   	nop
  8003f3:	c9                   	leave  
  8003f4:	c3                   	ret    

008003f5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
  8003f8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800405:	00 00 00 
	b.cnt = 0;
  800408:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80040f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800412:	ff 75 0c             	pushl  0xc(%ebp)
  800415:	ff 75 08             	pushl  0x8(%ebp)
  800418:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80041e:	50                   	push   %eax
  80041f:	68 8c 03 80 00       	push   $0x80038c
  800424:	e8 11 02 00 00       	call   80063a <vprintfmt>
  800429:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80042c:	a0 08 30 80 00       	mov    0x803008,%al
  800431:	0f b6 c0             	movzbl %al,%eax
  800434:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80043a:	83 ec 04             	sub    $0x4,%esp
  80043d:	50                   	push   %eax
  80043e:	52                   	push   %edx
  80043f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800445:	83 c0 08             	add    $0x8,%eax
  800448:	50                   	push   %eax
  800449:	e8 d7 0d 00 00       	call   801225 <sys_cputs>
  80044e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800451:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800458:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80045e:	c9                   	leave  
  80045f:	c3                   	ret    

00800460 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800466:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80046d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800470:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	ff 75 f4             	pushl  -0xc(%ebp)
  80047c:	50                   	push   %eax
  80047d:	e8 73 ff ff ff       	call   8003f5 <vcprintf>
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800488:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80048b:	c9                   	leave  
  80048c:	c3                   	ret    

0080048d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80048d:	55                   	push   %ebp
  80048e:	89 e5                	mov    %esp,%ebp
  800490:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800493:	e8 cf 0d 00 00       	call   801267 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800498:	8d 45 0c             	lea    0xc(%ebp),%eax
  80049b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a7:	50                   	push   %eax
  8004a8:	e8 48 ff ff ff       	call   8003f5 <vcprintf>
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004b3:	e8 c9 0d 00 00       	call   801281 <sys_unlock_cons>
	return cnt;
  8004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004bb:	c9                   	leave  
  8004bc:	c3                   	ret    

008004bd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	53                   	push   %ebx
  8004c1:	83 ec 14             	sub    $0x14,%esp
  8004c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004db:	77 55                	ja     800532 <printnum+0x75>
  8004dd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e0:	72 05                	jb     8004e7 <printnum+0x2a>
  8004e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e5:	77 4b                	ja     800532 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004ea:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004ed:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f5:	52                   	push   %edx
  8004f6:	50                   	push   %eax
  8004f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8004fd:	e8 22 13 00 00       	call   801824 <__udivdi3>
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	ff 75 20             	pushl  0x20(%ebp)
  80050b:	53                   	push   %ebx
  80050c:	ff 75 18             	pushl  0x18(%ebp)
  80050f:	52                   	push   %edx
  800510:	50                   	push   %eax
  800511:	ff 75 0c             	pushl  0xc(%ebp)
  800514:	ff 75 08             	pushl  0x8(%ebp)
  800517:	e8 a1 ff ff ff       	call   8004bd <printnum>
  80051c:	83 c4 20             	add    $0x20,%esp
  80051f:	eb 1a                	jmp    80053b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	ff 75 0c             	pushl  0xc(%ebp)
  800527:	ff 75 20             	pushl  0x20(%ebp)
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	ff d0                	call   *%eax
  80052f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800532:	ff 4d 1c             	decl   0x1c(%ebp)
  800535:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800539:	7f e6                	jg     800521 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80053e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800549:	53                   	push   %ebx
  80054a:	51                   	push   %ecx
  80054b:	52                   	push   %edx
  80054c:	50                   	push   %eax
  80054d:	e8 e2 13 00 00       	call   801934 <__umoddi3>
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	05 54 1f 80 00       	add    $0x801f54,%eax
  80055a:	8a 00                	mov    (%eax),%al
  80055c:	0f be c0             	movsbl %al,%eax
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	ff 75 0c             	pushl  0xc(%ebp)
  800565:	50                   	push   %eax
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	ff d0                	call   *%eax
  80056b:	83 c4 10             	add    $0x10,%esp
}
  80056e:	90                   	nop
  80056f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800572:	c9                   	leave  
  800573:	c3                   	ret    

00800574 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800577:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80057b:	7e 1c                	jle    800599 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	8d 50 08             	lea    0x8(%eax),%edx
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	89 10                	mov    %edx,(%eax)
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	83 e8 08             	sub    $0x8,%eax
  800592:	8b 50 04             	mov    0x4(%eax),%edx
  800595:	8b 00                	mov    (%eax),%eax
  800597:	eb 40                	jmp    8005d9 <getuint+0x65>
	else if (lflag)
  800599:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80059d:	74 1e                	je     8005bd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80059f:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	8d 50 04             	lea    0x4(%eax),%edx
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	89 10                	mov    %edx,(%eax)
  8005ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	83 e8 04             	sub    $0x4,%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bb:	eb 1c                	jmp    8005d9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	8b 00                	mov    (%eax),%eax
  8005c2:	8d 50 04             	lea    0x4(%eax),%edx
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	89 10                	mov    %edx,(%eax)
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	83 e8 04             	sub    $0x4,%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d9:	5d                   	pop    %ebp
  8005da:	c3                   	ret    

008005db <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005db:	55                   	push   %ebp
  8005dc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005de:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005e2:	7e 1c                	jle    800600 <getint+0x25>
		return va_arg(*ap, long long);
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	8d 50 08             	lea    0x8(%eax),%edx
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	89 10                	mov    %edx,(%eax)
  8005f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	83 e8 08             	sub    $0x8,%eax
  8005f9:	8b 50 04             	mov    0x4(%eax),%edx
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	eb 38                	jmp    800638 <getint+0x5d>
	else if (lflag)
  800600:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800604:	74 1a                	je     800620 <getint+0x45>
		return va_arg(*ap, long);
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	8d 50 04             	lea    0x4(%eax),%edx
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	89 10                	mov    %edx,(%eax)
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	83 e8 04             	sub    $0x4,%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	99                   	cltd   
  80061e:	eb 18                	jmp    800638 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800620:	8b 45 08             	mov    0x8(%ebp),%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	8d 50 04             	lea    0x4(%eax),%edx
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	89 10                	mov    %edx,(%eax)
  80062d:	8b 45 08             	mov    0x8(%ebp),%eax
  800630:	8b 00                	mov    (%eax),%eax
  800632:	83 e8 04             	sub    $0x4,%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	99                   	cltd   
}
  800638:	5d                   	pop    %ebp
  800639:	c3                   	ret    

0080063a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
  80063d:	56                   	push   %esi
  80063e:	53                   	push   %ebx
  80063f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800642:	eb 17                	jmp    80065b <vprintfmt+0x21>
			if (ch == '\0')
  800644:	85 db                	test   %ebx,%ebx
  800646:	0f 84 c1 03 00 00    	je     800a0d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80064c:	83 ec 08             	sub    $0x8,%esp
  80064f:	ff 75 0c             	pushl  0xc(%ebp)
  800652:	53                   	push   %ebx
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	ff d0                	call   *%eax
  800658:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065b:	8b 45 10             	mov    0x10(%ebp),%eax
  80065e:	8d 50 01             	lea    0x1(%eax),%edx
  800661:	89 55 10             	mov    %edx,0x10(%ebp)
  800664:	8a 00                	mov    (%eax),%al
  800666:	0f b6 d8             	movzbl %al,%ebx
  800669:	83 fb 25             	cmp    $0x25,%ebx
  80066c:	75 d6                	jne    800644 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80066e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800672:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800679:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800680:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800687:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068e:	8b 45 10             	mov    0x10(%ebp),%eax
  800691:	8d 50 01             	lea    0x1(%eax),%edx
  800694:	89 55 10             	mov    %edx,0x10(%ebp)
  800697:	8a 00                	mov    (%eax),%al
  800699:	0f b6 d8             	movzbl %al,%ebx
  80069c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80069f:	83 f8 5b             	cmp    $0x5b,%eax
  8006a2:	0f 87 3d 03 00 00    	ja     8009e5 <vprintfmt+0x3ab>
  8006a8:	8b 04 85 78 1f 80 00 	mov    0x801f78(,%eax,4),%eax
  8006af:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b5:	eb d7                	jmp    80068e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006bb:	eb d1                	jmp    80068e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c7:	89 d0                	mov    %edx,%eax
  8006c9:	c1 e0 02             	shl    $0x2,%eax
  8006cc:	01 d0                	add    %edx,%eax
  8006ce:	01 c0                	add    %eax,%eax
  8006d0:	01 d8                	add    %ebx,%eax
  8006d2:	83 e8 30             	sub    $0x30,%eax
  8006d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006db:	8a 00                	mov    (%eax),%al
  8006dd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e0:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e3:	7e 3e                	jle    800723 <vprintfmt+0xe9>
  8006e5:	83 fb 39             	cmp    $0x39,%ebx
  8006e8:	7f 39                	jg     800723 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ea:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006ed:	eb d5                	jmp    8006c4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	83 c0 04             	add    $0x4,%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	83 e8 04             	sub    $0x4,%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800703:	eb 1f                	jmp    800724 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800705:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800709:	79 83                	jns    80068e <vprintfmt+0x54>
				width = 0;
  80070b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800712:	e9 77 ff ff ff       	jmp    80068e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800717:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80071e:	e9 6b ff ff ff       	jmp    80068e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800723:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800724:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800728:	0f 89 60 ff ff ff    	jns    80068e <vprintfmt+0x54>
				width = precision, precision = -1;
  80072e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800734:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80073b:	e9 4e ff ff ff       	jmp    80068e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800740:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800743:	e9 46 ff ff ff       	jmp    80068e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	83 c0 04             	add    $0x4,%eax
  80074e:	89 45 14             	mov    %eax,0x14(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	83 e8 04             	sub    $0x4,%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	ff 75 0c             	pushl  0xc(%ebp)
  80075f:	50                   	push   %eax
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	ff d0                	call   *%eax
  800765:	83 c4 10             	add    $0x10,%esp
			break;
  800768:	e9 9b 02 00 00       	jmp    800a08 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	83 c0 04             	add    $0x4,%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	83 e8 04             	sub    $0x4,%eax
  80077c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80077e:	85 db                	test   %ebx,%ebx
  800780:	79 02                	jns    800784 <vprintfmt+0x14a>
				err = -err;
  800782:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800784:	83 fb 64             	cmp    $0x64,%ebx
  800787:	7f 0b                	jg     800794 <vprintfmt+0x15a>
  800789:	8b 34 9d c0 1d 80 00 	mov    0x801dc0(,%ebx,4),%esi
  800790:	85 f6                	test   %esi,%esi
  800792:	75 19                	jne    8007ad <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800794:	53                   	push   %ebx
  800795:	68 65 1f 80 00       	push   $0x801f65
  80079a:	ff 75 0c             	pushl  0xc(%ebp)
  80079d:	ff 75 08             	pushl  0x8(%ebp)
  8007a0:	e8 70 02 00 00       	call   800a15 <printfmt>
  8007a5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a8:	e9 5b 02 00 00       	jmp    800a08 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007ad:	56                   	push   %esi
  8007ae:	68 6e 1f 80 00       	push   $0x801f6e
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	e8 57 02 00 00       	call   800a15 <printfmt>
  8007be:	83 c4 10             	add    $0x10,%esp
			break;
  8007c1:	e9 42 02 00 00       	jmp    800a08 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	83 c0 04             	add    $0x4,%eax
  8007cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	83 e8 04             	sub    $0x4,%eax
  8007d5:	8b 30                	mov    (%eax),%esi
  8007d7:	85 f6                	test   %esi,%esi
  8007d9:	75 05                	jne    8007e0 <vprintfmt+0x1a6>
				p = "(null)";
  8007db:	be 71 1f 80 00       	mov    $0x801f71,%esi
			if (width > 0 && padc != '-')
  8007e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e4:	7e 6d                	jle    800853 <vprintfmt+0x219>
  8007e6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007ea:	74 67                	je     800853 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	50                   	push   %eax
  8007f3:	56                   	push   %esi
  8007f4:	e8 1e 03 00 00       	call   800b17 <strnlen>
  8007f9:	83 c4 10             	add    $0x10,%esp
  8007fc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007ff:	eb 16                	jmp    800817 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800801:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	50                   	push   %eax
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	ff d0                	call   *%eax
  800811:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800814:	ff 4d e4             	decl   -0x1c(%ebp)
  800817:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081b:	7f e4                	jg     800801 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081d:	eb 34                	jmp    800853 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80081f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800823:	74 1c                	je     800841 <vprintfmt+0x207>
  800825:	83 fb 1f             	cmp    $0x1f,%ebx
  800828:	7e 05                	jle    80082f <vprintfmt+0x1f5>
  80082a:	83 fb 7e             	cmp    $0x7e,%ebx
  80082d:	7e 12                	jle    800841 <vprintfmt+0x207>
					putch('?', putdat);
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	6a 3f                	push   $0x3f
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	eb 0f                	jmp    800850 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	53                   	push   %ebx
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800850:	ff 4d e4             	decl   -0x1c(%ebp)
  800853:	89 f0                	mov    %esi,%eax
  800855:	8d 70 01             	lea    0x1(%eax),%esi
  800858:	8a 00                	mov    (%eax),%al
  80085a:	0f be d8             	movsbl %al,%ebx
  80085d:	85 db                	test   %ebx,%ebx
  80085f:	74 24                	je     800885 <vprintfmt+0x24b>
  800861:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800865:	78 b8                	js     80081f <vprintfmt+0x1e5>
  800867:	ff 4d e0             	decl   -0x20(%ebp)
  80086a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086e:	79 af                	jns    80081f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800870:	eb 13                	jmp    800885 <vprintfmt+0x24b>
				putch(' ', putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	6a 20                	push   $0x20
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	ff d0                	call   *%eax
  80087f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800882:	ff 4d e4             	decl   -0x1c(%ebp)
  800885:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800889:	7f e7                	jg     800872 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80088b:	e9 78 01 00 00       	jmp    800a08 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	ff 75 e8             	pushl  -0x18(%ebp)
  800896:	8d 45 14             	lea    0x14(%ebp),%eax
  800899:	50                   	push   %eax
  80089a:	e8 3c fd ff ff       	call   8005db <getint>
  80089f:	83 c4 10             	add    $0x10,%esp
  8008a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ae:	85 d2                	test   %edx,%edx
  8008b0:	79 23                	jns    8008d5 <vprintfmt+0x29b>
				putch('-', putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	6a 2d                	push   $0x2d
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c8:	f7 d8                	neg    %eax
  8008ca:	83 d2 00             	adc    $0x0,%edx
  8008cd:	f7 da                	neg    %edx
  8008cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008dc:	e9 bc 00 00 00       	jmp    80099d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e7:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ea:	50                   	push   %eax
  8008eb:	e8 84 fc ff ff       	call   800574 <getuint>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800900:	e9 98 00 00 00       	jmp    80099d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	6a 58                	push   $0x58
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	6a 58                	push   $0x58
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	6a 58                	push   $0x58
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	ff d0                	call   *%eax
  800932:	83 c4 10             	add    $0x10,%esp
			break;
  800935:	e9 ce 00 00 00       	jmp    800a08 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	6a 30                	push   $0x30
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	ff d0                	call   *%eax
  800947:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	6a 78                	push   $0x78
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 c0 04             	add    $0x4,%eax
  800960:	89 45 14             	mov    %eax,0x14(%ebp)
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	83 e8 04             	sub    $0x4,%eax
  800969:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80096b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800975:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80097c:	eb 1f                	jmp    80099d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 e8             	pushl  -0x18(%ebp)
  800984:	8d 45 14             	lea    0x14(%ebp),%eax
  800987:	50                   	push   %eax
  800988:	e8 e7 fb ff ff       	call   800574 <getuint>
  80098d:	83 c4 10             	add    $0x10,%esp
  800990:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800993:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800996:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80099d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a4:	83 ec 04             	sub    $0x4,%esp
  8009a7:	52                   	push   %edx
  8009a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009ab:	50                   	push   %eax
  8009ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8009af:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	ff 75 08             	pushl  0x8(%ebp)
  8009b8:	e8 00 fb ff ff       	call   8004bd <printnum>
  8009bd:	83 c4 20             	add    $0x20,%esp
			break;
  8009c0:	eb 46                	jmp    800a08 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	53                   	push   %ebx
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	ff d0                	call   *%eax
  8009ce:	83 c4 10             	add    $0x10,%esp
			break;
  8009d1:	eb 35                	jmp    800a08 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009d3:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009da:	eb 2c                	jmp    800a08 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009dc:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009e3:	eb 23                	jmp    800a08 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	6a 25                	push   $0x25
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	ff d0                	call   *%eax
  8009f2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f5:	ff 4d 10             	decl   0x10(%ebp)
  8009f8:	eb 03                	jmp    8009fd <vprintfmt+0x3c3>
  8009fa:	ff 4d 10             	decl   0x10(%ebp)
  8009fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800a00:	48                   	dec    %eax
  800a01:	8a 00                	mov    (%eax),%al
  800a03:	3c 25                	cmp    $0x25,%al
  800a05:	75 f3                	jne    8009fa <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a07:	90                   	nop
		}
	}
  800a08:	e9 35 fc ff ff       	jmp    800642 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a0d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a11:	5b                   	pop    %ebx
  800a12:	5e                   	pop    %esi
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a1b:	8d 45 10             	lea    0x10(%ebp),%eax
  800a1e:	83 c0 04             	add    $0x4,%eax
  800a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a24:	8b 45 10             	mov    0x10(%ebp),%eax
  800a27:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2a:	50                   	push   %eax
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	ff 75 08             	pushl  0x8(%ebp)
  800a31:	e8 04 fc ff ff       	call   80063a <vprintfmt>
  800a36:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a39:	90                   	nop
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	8b 40 08             	mov    0x8(%eax),%eax
  800a45:	8d 50 01             	lea    0x1(%eax),%edx
  800a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a51:	8b 10                	mov    (%eax),%edx
  800a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a56:	8b 40 04             	mov    0x4(%eax),%eax
  800a59:	39 c2                	cmp    %eax,%edx
  800a5b:	73 12                	jae    800a6f <sprintputch+0x33>
		*b->buf++ = ch;
  800a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a60:	8b 00                	mov    (%eax),%eax
  800a62:	8d 48 01             	lea    0x1(%eax),%ecx
  800a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a68:	89 0a                	mov    %ecx,(%edx)
  800a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6d:	88 10                	mov    %dl,(%eax)
}
  800a6f:	90                   	nop
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a81:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	01 d0                	add    %edx,%eax
  800a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a97:	74 06                	je     800a9f <vsnprintf+0x2d>
  800a99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a9d:	7f 07                	jg     800aa6 <vsnprintf+0x34>
		return -E_INVAL;
  800a9f:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa4:	eb 20                	jmp    800ac6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa6:	ff 75 14             	pushl  0x14(%ebp)
  800aa9:	ff 75 10             	pushl  0x10(%ebp)
  800aac:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aaf:	50                   	push   %eax
  800ab0:	68 3c 0a 80 00       	push   $0x800a3c
  800ab5:	e8 80 fb ff ff       	call   80063a <vprintfmt>
  800aba:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ace:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	50                   	push   %eax
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	ff 75 08             	pushl  0x8(%ebp)
  800ae4:	e8 89 ff ff ff       	call   800a72 <vsnprintf>
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800afa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b01:	eb 06                	jmp    800b09 <strlen+0x15>
		n++;
  800b03:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b06:	ff 45 08             	incl   0x8(%ebp)
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8a 00                	mov    (%eax),%al
  800b0e:	84 c0                	test   %al,%al
  800b10:	75 f1                	jne    800b03 <strlen+0xf>
		n++;
	return n;
  800b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b15:	c9                   	leave  
  800b16:	c3                   	ret    

00800b17 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b24:	eb 09                	jmp    800b2f <strnlen+0x18>
		n++;
  800b26:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b29:	ff 45 08             	incl   0x8(%ebp)
  800b2c:	ff 4d 0c             	decl   0xc(%ebp)
  800b2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b33:	74 09                	je     800b3e <strnlen+0x27>
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	8a 00                	mov    (%eax),%al
  800b3a:	84 c0                	test   %al,%al
  800b3c:	75 e8                	jne    800b26 <strnlen+0xf>
		n++;
	return n;
  800b3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b41:	c9                   	leave  
  800b42:	c3                   	ret    

00800b43 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b4f:	90                   	nop
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8d 50 01             	lea    0x1(%eax),%edx
  800b56:	89 55 08             	mov    %edx,0x8(%ebp)
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b5f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b62:	8a 12                	mov    (%edx),%dl
  800b64:	88 10                	mov    %dl,(%eax)
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	84 c0                	test   %al,%al
  800b6a:	75 e4                	jne    800b50 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b84:	eb 1f                	jmp    800ba5 <strncpy+0x34>
		*dst++ = *src;
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	8d 50 01             	lea    0x1(%eax),%edx
  800b8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b92:	8a 12                	mov    (%edx),%dl
  800b94:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	84 c0                	test   %al,%al
  800b9d:	74 03                	je     800ba2 <strncpy+0x31>
			src++;
  800b9f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba2:	ff 45 fc             	incl   -0x4(%ebp)
  800ba5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bab:	72 d9                	jb     800b86 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bb0:	c9                   	leave  
  800bb1:	c3                   	ret    

00800bb2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc2:	74 30                	je     800bf4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bc4:	eb 16                	jmp    800bdc <strlcpy+0x2a>
			*dst++ = *src++;
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	8d 50 01             	lea    0x1(%eax),%edx
  800bcc:	89 55 08             	mov    %edx,0x8(%ebp)
  800bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd8:	8a 12                	mov    (%edx),%dl
  800bda:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bdc:	ff 4d 10             	decl   0x10(%ebp)
  800bdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be3:	74 09                	je     800bee <strlcpy+0x3c>
  800be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be8:	8a 00                	mov    (%eax),%al
  800bea:	84 c0                	test   %al,%al
  800bec:	75 d8                	jne    800bc6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfa:	29 c2                	sub    %eax,%edx
  800bfc:	89 d0                	mov    %edx,%eax
}
  800bfe:	c9                   	leave  
  800bff:	c3                   	ret    

00800c00 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c03:	eb 06                	jmp    800c0b <strcmp+0xb>
		p++, q++;
  800c05:	ff 45 08             	incl   0x8(%ebp)
  800c08:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8a 00                	mov    (%eax),%al
  800c10:	84 c0                	test   %al,%al
  800c12:	74 0e                	je     800c22 <strcmp+0x22>
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8a 10                	mov    (%eax),%dl
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	38 c2                	cmp    %al,%dl
  800c20:	74 e3                	je     800c05 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8a 00                	mov    (%eax),%al
  800c27:	0f b6 d0             	movzbl %al,%edx
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	0f b6 c0             	movzbl %al,%eax
  800c32:	29 c2                	sub    %eax,%edx
  800c34:	89 d0                	mov    %edx,%eax
}
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    

00800c38 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c3b:	eb 09                	jmp    800c46 <strncmp+0xe>
		n--, p++, q++;
  800c3d:	ff 4d 10             	decl   0x10(%ebp)
  800c40:	ff 45 08             	incl   0x8(%ebp)
  800c43:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4a:	74 17                	je     800c63 <strncmp+0x2b>
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	8a 00                	mov    (%eax),%al
  800c51:	84 c0                	test   %al,%al
  800c53:	74 0e                	je     800c63 <strncmp+0x2b>
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8a 10                	mov    (%eax),%dl
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	38 c2                	cmp    %al,%dl
  800c61:	74 da                	je     800c3d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c67:	75 07                	jne    800c70 <strncmp+0x38>
		return 0;
  800c69:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6e:	eb 14                	jmp    800c84 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	8a 00                	mov    (%eax),%al
  800c75:	0f b6 d0             	movzbl %al,%edx
  800c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7b:	8a 00                	mov    (%eax),%al
  800c7d:	0f b6 c0             	movzbl %al,%eax
  800c80:	29 c2                	sub    %eax,%edx
  800c82:	89 d0                	mov    %edx,%eax
}
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c92:	eb 12                	jmp    800ca6 <strchr+0x20>
		if (*s == c)
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c9c:	75 05                	jne    800ca3 <strchr+0x1d>
			return (char *) s;
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	eb 11                	jmp    800cb4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ca3:	ff 45 08             	incl   0x8(%ebp)
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	75 e5                	jne    800c94 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800caf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb4:	c9                   	leave  
  800cb5:	c3                   	ret    

00800cb6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 04             	sub    $0x4,%esp
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cc2:	eb 0d                	jmp    800cd1 <strfind+0x1b>
		if (*s == c)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ccc:	74 0e                	je     800cdc <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cce:	ff 45 08             	incl   0x8(%ebp)
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	84 c0                	test   %al,%al
  800cd8:	75 ea                	jne    800cc4 <strfind+0xe>
  800cda:	eb 01                	jmp    800cdd <strfind+0x27>
		if (*s == c)
			break;
  800cdc:	90                   	nop
	return (char *) s;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce0:	c9                   	leave  
  800ce1:	c3                   	ret    

00800ce2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cee:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cf4:	eb 0e                	jmp    800d04 <memset+0x22>
		*p++ = c;
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	8d 50 01             	lea    0x1(%eax),%edx
  800cfc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d02:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d04:	ff 4d f8             	decl   -0x8(%ebp)
  800d07:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d0b:	79 e9                	jns    800cf6 <memset+0x14>
		*p++ = c;

	return v;
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d24:	eb 16                	jmp    800d3c <memcpy+0x2a>
		*d++ = *s++;
  800d26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d29:	8d 50 01             	lea    0x1(%eax),%edx
  800d2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d35:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d38:	8a 12                	mov    (%edx),%dl
  800d3a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d42:	89 55 10             	mov    %edx,0x10(%ebp)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	75 dd                	jne    800d26 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
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
	if (s < d && s + n > d) {
  800d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d63:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d66:	73 50                	jae    800db8 <memmove+0x6a>
  800d68:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6e:	01 d0                	add    %edx,%eax
  800d70:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d73:	76 43                	jbe    800db8 <memmove+0x6a>
		s += n;
  800d75:	8b 45 10             	mov    0x10(%ebp),%eax
  800d78:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d81:	eb 10                	jmp    800d93 <memmove+0x45>
			*--d = *--s;
  800d83:	ff 4d f8             	decl   -0x8(%ebp)
  800d86:	ff 4d fc             	decl   -0x4(%ebp)
  800d89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8c:	8a 10                	mov    (%eax),%dl
  800d8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d91:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d93:	8b 45 10             	mov    0x10(%ebp),%eax
  800d96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d99:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	75 e3                	jne    800d83 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da0:	eb 23                	jmp    800dc5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800da2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da5:	8d 50 01             	lea    0x1(%eax),%edx
  800da8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dae:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db4:	8a 12                	mov    (%edx),%dl
  800db6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800db8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	75 dd                	jne    800da2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc8:	c9                   	leave  
  800dc9:	c3                   	ret    

00800dca <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ddc:	eb 2a                	jmp    800e08 <memcmp+0x3e>
		if (*s1 != *s2)
  800dde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de1:	8a 10                	mov    (%eax),%dl
  800de3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de6:	8a 00                	mov    (%eax),%al
  800de8:	38 c2                	cmp    %al,%dl
  800dea:	74 16                	je     800e02 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	0f b6 d0             	movzbl %al,%edx
  800df4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 c0             	movzbl %al,%eax
  800dfc:	29 c2                	sub    %eax,%edx
  800dfe:	89 d0                	mov    %edx,%eax
  800e00:	eb 18                	jmp    800e1a <memcmp+0x50>
		s1++, s2++;
  800e02:	ff 45 fc             	incl   -0x4(%ebp)
  800e05:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e11:	85 c0                	test   %eax,%eax
  800e13:	75 c9                	jne    800dde <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1a:	c9                   	leave  
  800e1b:	c3                   	ret    

00800e1c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 45 10             	mov    0x10(%ebp),%eax
  800e28:	01 d0                	add    %edx,%eax
  800e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e2d:	eb 15                	jmp    800e44 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8a 00                	mov    (%eax),%al
  800e34:	0f b6 d0             	movzbl %al,%edx
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	0f b6 c0             	movzbl %al,%eax
  800e3d:	39 c2                	cmp    %eax,%edx
  800e3f:	74 0d                	je     800e4e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e4a:	72 e3                	jb     800e2f <memfind+0x13>
  800e4c:	eb 01                	jmp    800e4f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e4e:	90                   	nop
	return (void *) s;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e61:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e68:	eb 03                	jmp    800e6d <strtol+0x19>
		s++;
  800e6a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	3c 20                	cmp    $0x20,%al
  800e74:	74 f4                	je     800e6a <strtol+0x16>
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	3c 09                	cmp    $0x9,%al
  800e7d:	74 eb                	je     800e6a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	3c 2b                	cmp    $0x2b,%al
  800e86:	75 05                	jne    800e8d <strtol+0x39>
		s++;
  800e88:	ff 45 08             	incl   0x8(%ebp)
  800e8b:	eb 13                	jmp    800ea0 <strtol+0x4c>
	else if (*s == '-')
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	3c 2d                	cmp    $0x2d,%al
  800e94:	75 0a                	jne    800ea0 <strtol+0x4c>
		s++, neg = 1;
  800e96:	ff 45 08             	incl   0x8(%ebp)
  800e99:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea4:	74 06                	je     800eac <strtol+0x58>
  800ea6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eaa:	75 20                	jne    800ecc <strtol+0x78>
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	3c 30                	cmp    $0x30,%al
  800eb3:	75 17                	jne    800ecc <strtol+0x78>
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	40                   	inc    %eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	3c 78                	cmp    $0x78,%al
  800ebd:	75 0d                	jne    800ecc <strtol+0x78>
		s += 2, base = 16;
  800ebf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ec3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eca:	eb 28                	jmp    800ef4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ecc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed0:	75 15                	jne    800ee7 <strtol+0x93>
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3c 30                	cmp    $0x30,%al
  800ed9:	75 0c                	jne    800ee7 <strtol+0x93>
		s++, base = 8;
  800edb:	ff 45 08             	incl   0x8(%ebp)
  800ede:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ee5:	eb 0d                	jmp    800ef4 <strtol+0xa0>
	else if (base == 0)
  800ee7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eeb:	75 07                	jne    800ef4 <strtol+0xa0>
		base = 10;
  800eed:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	3c 2f                	cmp    $0x2f,%al
  800efb:	7e 19                	jle    800f16 <strtol+0xc2>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	3c 39                	cmp    $0x39,%al
  800f04:	7f 10                	jg     800f16 <strtol+0xc2>
			dig = *s - '0';
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	0f be c0             	movsbl %al,%eax
  800f0e:	83 e8 30             	sub    $0x30,%eax
  800f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f14:	eb 42                	jmp    800f58 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	3c 60                	cmp    $0x60,%al
  800f1d:	7e 19                	jle    800f38 <strtol+0xe4>
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	3c 7a                	cmp    $0x7a,%al
  800f26:	7f 10                	jg     800f38 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	0f be c0             	movsbl %al,%eax
  800f30:	83 e8 57             	sub    $0x57,%eax
  800f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f36:	eb 20                	jmp    800f58 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3c 40                	cmp    $0x40,%al
  800f3f:	7e 39                	jle    800f7a <strtol+0x126>
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	3c 5a                	cmp    $0x5a,%al
  800f48:	7f 30                	jg     800f7a <strtol+0x126>
			dig = *s - 'A' + 10;
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	0f be c0             	movsbl %al,%eax
  800f52:	83 e8 37             	sub    $0x37,%eax
  800f55:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f5e:	7d 19                	jge    800f79 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f60:	ff 45 08             	incl   0x8(%ebp)
  800f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f66:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f6a:	89 c2                	mov    %eax,%edx
  800f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6f:	01 d0                	add    %edx,%eax
  800f71:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f74:	e9 7b ff ff ff       	jmp    800ef4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f79:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f7e:	74 08                	je     800f88 <strtol+0x134>
		*endptr = (char *) s;
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8b 55 08             	mov    0x8(%ebp),%edx
  800f86:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f88:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f8c:	74 07                	je     800f95 <strtol+0x141>
  800f8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f91:	f7 d8                	neg    %eax
  800f93:	eb 03                	jmp    800f98 <strtol+0x144>
  800f95:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    

00800f9a <ltostr>:

void
ltostr(long value, char *str)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fa0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fa7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fb2:	79 13                	jns    800fc7 <ltostr+0x2d>
	{
		neg = 1;
  800fb4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fc1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fc4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fcf:	99                   	cltd   
  800fd0:	f7 f9                	idiv   %ecx
  800fd2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd8:	8d 50 01             	lea    0x1(%eax),%edx
  800fdb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fde:	89 c2                	mov    %eax,%edx
  800fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe3:	01 d0                	add    %edx,%eax
  800fe5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fe8:	83 c2 30             	add    $0x30,%edx
  800feb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff5:	f7 e9                	imul   %ecx
  800ff7:	c1 fa 02             	sar    $0x2,%edx
  800ffa:	89 c8                	mov    %ecx,%eax
  800ffc:	c1 f8 1f             	sar    $0x1f,%eax
  800fff:	29 c2                	sub    %eax,%edx
  801001:	89 d0                	mov    %edx,%eax
  801003:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801006:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100a:	75 bb                	jne    800fc7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80100c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801013:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801016:	48                   	dec    %eax
  801017:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80101a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101e:	74 3d                	je     80105d <ltostr+0xc3>
		start = 1 ;
  801020:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801027:	eb 34                	jmp    80105d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	01 d0                	add    %edx,%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801036:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	01 c2                	add    %eax,%edx
  80103e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	01 c8                	add    %ecx,%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80104a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80104d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801050:	01 c2                	add    %eax,%edx
  801052:	8a 45 eb             	mov    -0x15(%ebp),%al
  801055:	88 02                	mov    %al,(%edx)
		start++ ;
  801057:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80105a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80105d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801060:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801063:	7c c4                	jl     801029 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801065:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	01 d0                	add    %edx,%eax
  80106d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801070:	90                   	nop
  801071:	c9                   	leave  
  801072:	c3                   	ret    

00801073 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801079:	ff 75 08             	pushl  0x8(%ebp)
  80107c:	e8 73 fa ff ff       	call   800af4 <strlen>
  801081:	83 c4 04             	add    $0x4,%esp
  801084:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801087:	ff 75 0c             	pushl  0xc(%ebp)
  80108a:	e8 65 fa ff ff       	call   800af4 <strlen>
  80108f:	83 c4 04             	add    $0x4,%esp
  801092:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80109c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a3:	eb 17                	jmp    8010bc <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ab:	01 c2                	add    %eax,%edx
  8010ad:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	01 c8                	add    %ecx,%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010b9:	ff 45 fc             	incl   -0x4(%ebp)
  8010bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c2:	7c e1                	jl     8010a5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d2:	eb 1f                	jmp    8010f3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010dd:	89 c2                	mov    %eax,%edx
  8010df:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e2:	01 c2                	add    %eax,%edx
  8010e4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ea:	01 c8                	add    %ecx,%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f0:	ff 45 f8             	incl   -0x8(%ebp)
  8010f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f9:	7c d9                	jl     8010d4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801101:	01 d0                	add    %edx,%eax
  801103:	c6 00 00             	movb   $0x0,(%eax)
}
  801106:	90                   	nop
  801107:	c9                   	leave  
  801108:	c3                   	ret    

00801109 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80110c:	8b 45 14             	mov    0x14(%ebp),%eax
  80110f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801115:	8b 45 14             	mov    0x14(%ebp),%eax
  801118:	8b 00                	mov    (%eax),%eax
  80111a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801121:	8b 45 10             	mov    0x10(%ebp),%eax
  801124:	01 d0                	add    %edx,%eax
  801126:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112c:	eb 0c                	jmp    80113a <strsplit+0x31>
			*string++ = 0;
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	89 55 08             	mov    %edx,0x8(%ebp)
  801137:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	84 c0                	test   %al,%al
  801141:	74 18                	je     80115b <strsplit+0x52>
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	0f be c0             	movsbl %al,%eax
  80114b:	50                   	push   %eax
  80114c:	ff 75 0c             	pushl  0xc(%ebp)
  80114f:	e8 32 fb ff ff       	call   800c86 <strchr>
  801154:	83 c4 08             	add    $0x8,%esp
  801157:	85 c0                	test   %eax,%eax
  801159:	75 d3                	jne    80112e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	84 c0                	test   %al,%al
  801162:	74 5a                	je     8011be <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801164:	8b 45 14             	mov    0x14(%ebp),%eax
  801167:	8b 00                	mov    (%eax),%eax
  801169:	83 f8 0f             	cmp    $0xf,%eax
  80116c:	75 07                	jne    801175 <strsplit+0x6c>
		{
			return 0;
  80116e:	b8 00 00 00 00       	mov    $0x0,%eax
  801173:	eb 66                	jmp    8011db <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801175:	8b 45 14             	mov    0x14(%ebp),%eax
  801178:	8b 00                	mov    (%eax),%eax
  80117a:	8d 48 01             	lea    0x1(%eax),%ecx
  80117d:	8b 55 14             	mov    0x14(%ebp),%edx
  801180:	89 0a                	mov    %ecx,(%edx)
  801182:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801189:	8b 45 10             	mov    0x10(%ebp),%eax
  80118c:	01 c2                	add    %eax,%edx
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801193:	eb 03                	jmp    801198 <strsplit+0x8f>
			string++;
  801195:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	84 c0                	test   %al,%al
  80119f:	74 8b                	je     80112c <strsplit+0x23>
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	0f be c0             	movsbl %al,%eax
  8011a9:	50                   	push   %eax
  8011aa:	ff 75 0c             	pushl  0xc(%ebp)
  8011ad:	e8 d4 fa ff ff       	call   800c86 <strchr>
  8011b2:	83 c4 08             	add    $0x8,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	74 dc                	je     801195 <strsplit+0x8c>
			string++;
	}
  8011b9:	e9 6e ff ff ff       	jmp    80112c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011be:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c2:	8b 00                	mov    (%eax),%eax
  8011c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ce:	01 d0                	add    %edx,%eax
  8011d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011e3:	83 ec 04             	sub    $0x4,%esp
  8011e6:	68 e8 20 80 00       	push   $0x8020e8
  8011eb:	68 3f 01 00 00       	push   $0x13f
  8011f0:	68 0a 21 80 00       	push   $0x80210a
  8011f5:	e8 a9 ef ff ff       	call   8001a3 <_panic>

008011fa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	57                   	push   %edi
  8011fe:	56                   	push   %esi
  8011ff:	53                   	push   %ebx
  801200:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8b 55 0c             	mov    0xc(%ebp),%edx
  801209:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80120c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80120f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801212:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801215:	cd 30                	int    $0x30
  801217:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80121a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	5b                   	pop    %ebx
  801221:	5e                   	pop    %esi
  801222:	5f                   	pop    %edi
  801223:	5d                   	pop    %ebp
  801224:	c3                   	ret    

00801225 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	83 ec 04             	sub    $0x4,%esp
  80122b:	8b 45 10             	mov    0x10(%ebp),%eax
  80122e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801231:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	6a 00                	push   $0x0
  80123a:	6a 00                	push   $0x0
  80123c:	52                   	push   %edx
  80123d:	ff 75 0c             	pushl  0xc(%ebp)
  801240:	50                   	push   %eax
  801241:	6a 00                	push   $0x0
  801243:	e8 b2 ff ff ff       	call   8011fa <syscall>
  801248:	83 c4 18             	add    $0x18,%esp
}
  80124b:	90                   	nop
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <sys_cgetc>:

int
sys_cgetc(void)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	6a 02                	push   $0x2
  80125d:	e8 98 ff ff ff       	call   8011fa <syscall>
  801262:	83 c4 18             	add    $0x18,%esp
}
  801265:	c9                   	leave  
  801266:	c3                   	ret    

00801267 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	6a 03                	push   $0x3
  801276:	e8 7f ff ff ff       	call   8011fa <syscall>
  80127b:	83 c4 18             	add    $0x18,%esp
}
  80127e:	90                   	nop
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 00                	push   $0x0
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	6a 04                	push   $0x4
  801290:	e8 65 ff ff ff       	call   8011fa <syscall>
  801295:	83 c4 18             	add    $0x18,%esp
}
  801298:	90                   	nop
  801299:	c9                   	leave  
  80129a:	c3                   	ret    

0080129b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80129e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	52                   	push   %edx
  8012ab:	50                   	push   %eax
  8012ac:	6a 08                	push   $0x8
  8012ae:	e8 47 ff ff ff       	call   8011fa <syscall>
  8012b3:	83 c4 18             	add    $0x18,%esp
}
  8012b6:	c9                   	leave  
  8012b7:	c3                   	ret    

008012b8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	56                   	push   %esi
  8012bc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012bd:	8b 75 18             	mov    0x18(%ebp),%esi
  8012c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	56                   	push   %esi
  8012cd:	53                   	push   %ebx
  8012ce:	51                   	push   %ecx
  8012cf:	52                   	push   %edx
  8012d0:	50                   	push   %eax
  8012d1:	6a 09                	push   $0x9
  8012d3:	e8 22 ff ff ff       	call   8011fa <syscall>
  8012d8:	83 c4 18             	add    $0x18,%esp
}
  8012db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012de:	5b                   	pop    %ebx
  8012df:	5e                   	pop    %esi
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    

008012e2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	52                   	push   %edx
  8012f2:	50                   	push   %eax
  8012f3:	6a 0a                	push   $0xa
  8012f5:	e8 00 ff ff ff       	call   8011fa <syscall>
  8012fa:	83 c4 18             	add    $0x18,%esp
}
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	ff 75 0c             	pushl  0xc(%ebp)
  80130b:	ff 75 08             	pushl  0x8(%ebp)
  80130e:	6a 0b                	push   $0xb
  801310:	e8 e5 fe ff ff       	call   8011fa <syscall>
  801315:	83 c4 18             	add    $0x18,%esp
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 0c                	push   $0xc
  801329:	e8 cc fe ff ff       	call   8011fa <syscall>
  80132e:	83 c4 18             	add    $0x18,%esp
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 0d                	push   $0xd
  801342:	e8 b3 fe ff ff       	call   8011fa <syscall>
  801347:	83 c4 18             	add    $0x18,%esp
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 0e                	push   $0xe
  80135b:	e8 9a fe ff ff       	call   8011fa <syscall>
  801360:	83 c4 18             	add    $0x18,%esp
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 0f                	push   $0xf
  801374:	e8 81 fe ff ff       	call   8011fa <syscall>
  801379:	83 c4 18             	add    $0x18,%esp
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	ff 75 08             	pushl  0x8(%ebp)
  80138c:	6a 10                	push   $0x10
  80138e:	e8 67 fe ff ff       	call   8011fa <syscall>
  801393:	83 c4 18             	add    $0x18,%esp
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 11                	push   $0x11
  8013a7:	e8 4e fe ff ff       	call   8011fa <syscall>
  8013ac:	83 c4 18             	add    $0x18,%esp
}
  8013af:	90                   	nop
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	83 ec 04             	sub    $0x4,%esp
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013be:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	50                   	push   %eax
  8013cb:	6a 01                	push   $0x1
  8013cd:	e8 28 fe ff ff       	call   8011fa <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
}
  8013d5:	90                   	nop
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 14                	push   $0x14
  8013e7:	e8 0e fe ff ff       	call   8011fa <syscall>
  8013ec:	83 c4 18             	add    $0x18,%esp
}
  8013ef:	90                   	nop
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	83 ec 04             	sub    $0x4,%esp
  8013f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013fe:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801401:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	6a 00                	push   $0x0
  80140a:	51                   	push   %ecx
  80140b:	52                   	push   %edx
  80140c:	ff 75 0c             	pushl  0xc(%ebp)
  80140f:	50                   	push   %eax
  801410:	6a 15                	push   $0x15
  801412:	e8 e3 fd ff ff       	call   8011fa <syscall>
  801417:	83 c4 18             	add    $0x18,%esp
}
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80141f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	52                   	push   %edx
  80142c:	50                   	push   %eax
  80142d:	6a 16                	push   $0x16
  80142f:	e8 c6 fd ff ff       	call   8011fa <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80143c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80143f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	51                   	push   %ecx
  80144a:	52                   	push   %edx
  80144b:	50                   	push   %eax
  80144c:	6a 17                	push   $0x17
  80144e:	e8 a7 fd ff ff       	call   8011fa <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80145b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	52                   	push   %edx
  801468:	50                   	push   %eax
  801469:	6a 18                	push   $0x18
  80146b:	e8 8a fd ff ff       	call   8011fa <syscall>
  801470:	83 c4 18             	add    $0x18,%esp
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	6a 00                	push   $0x0
  80147d:	ff 75 14             	pushl  0x14(%ebp)
  801480:	ff 75 10             	pushl  0x10(%ebp)
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	50                   	push   %eax
  801487:	6a 19                	push   $0x19
  801489:	e8 6c fd ff ff       	call   8011fa <syscall>
  80148e:	83 c4 18             	add    $0x18,%esp
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	50                   	push   %eax
  8014a2:	6a 1a                	push   $0x1a
  8014a4:	e8 51 fd ff ff       	call   8011fa <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	90                   	nop
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	50                   	push   %eax
  8014be:	6a 1b                	push   $0x1b
  8014c0:	e8 35 fd ff ff       	call   8011fa <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 05                	push   $0x5
  8014d9:	e8 1c fd ff ff       	call   8011fa <syscall>
  8014de:	83 c4 18             	add    $0x18,%esp
}
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 06                	push   $0x6
  8014f2:	e8 03 fd ff ff       	call   8011fa <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 07                	push   $0x7
  80150b:	e8 ea fc ff ff       	call   8011fa <syscall>
  801510:	83 c4 18             	add    $0x18,%esp
}
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <sys_exit_env>:


void sys_exit_env(void)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 1c                	push   $0x1c
  801524:	e8 d1 fc ff ff       	call   8011fa <syscall>
  801529:	83 c4 18             	add    $0x18,%esp
}
  80152c:	90                   	nop
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801535:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801538:	8d 50 04             	lea    0x4(%eax),%edx
  80153b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	52                   	push   %edx
  801545:	50                   	push   %eax
  801546:	6a 1d                	push   $0x1d
  801548:	e8 ad fc ff ff       	call   8011fa <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
	return result;
  801550:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801553:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801556:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801559:	89 01                	mov    %eax,(%ecx)
  80155b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	c9                   	leave  
  801562:	c2 04 00             	ret    $0x4

00801565 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	ff 75 10             	pushl  0x10(%ebp)
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	ff 75 08             	pushl  0x8(%ebp)
  801575:	6a 13                	push   $0x13
  801577:	e8 7e fc ff ff       	call   8011fa <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
	return ;
  80157f:	90                   	nop
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <sys_rcr2>:
uint32 sys_rcr2()
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 1e                	push   $0x1e
  801591:	e8 64 fc ff ff       	call   8011fa <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015a7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	50                   	push   %eax
  8015b4:	6a 1f                	push   $0x1f
  8015b6:	e8 3f fc ff ff       	call   8011fa <syscall>
  8015bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8015be:	90                   	nop
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <rsttst>:
void rsttst()
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 21                	push   $0x21
  8015d0:	e8 25 fc ff ff       	call   8011fa <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d8:	90                   	nop
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015e7:	8b 55 18             	mov    0x18(%ebp),%edx
  8015ea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015ee:	52                   	push   %edx
  8015ef:	50                   	push   %eax
  8015f0:	ff 75 10             	pushl  0x10(%ebp)
  8015f3:	ff 75 0c             	pushl  0xc(%ebp)
  8015f6:	ff 75 08             	pushl  0x8(%ebp)
  8015f9:	6a 20                	push   $0x20
  8015fb:	e8 fa fb ff ff       	call   8011fa <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
	return ;
  801603:	90                   	nop
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <chktst>:
void chktst(uint32 n)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	ff 75 08             	pushl  0x8(%ebp)
  801614:	6a 22                	push   $0x22
  801616:	e8 df fb ff ff       	call   8011fa <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
	return ;
  80161e:	90                   	nop
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <inctst>:

void inctst()
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 23                	push   $0x23
  801630:	e8 c5 fb ff ff       	call   8011fa <syscall>
  801635:	83 c4 18             	add    $0x18,%esp
	return ;
  801638:	90                   	nop
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <gettst>:
uint32 gettst()
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 24                	push   $0x24
  80164a:	e8 ab fb ff ff       	call   8011fa <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 25                	push   $0x25
  801666:	e8 8f fb ff ff       	call   8011fa <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
  80166e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801671:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801675:	75 07                	jne    80167e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801677:	b8 01 00 00 00       	mov    $0x1,%eax
  80167c:	eb 05                	jmp    801683 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 25                	push   $0x25
  801697:	e8 5e fb ff ff       	call   8011fa <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
  80169f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016a2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016a6:	75 07                	jne    8016af <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ad:	eb 05                	jmp    8016b4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 25                	push   $0x25
  8016c8:	e8 2d fb ff ff       	call   8011fa <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
  8016d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016d3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016d7:	75 07                	jne    8016e0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8016de:	eb 05                	jmp    8016e5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 25                	push   $0x25
  8016f9:	e8 fc fa ff ff       	call   8011fa <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
  801701:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801704:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801708:	75 07                	jne    801711 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80170a:	b8 01 00 00 00       	mov    $0x1,%eax
  80170f:	eb 05                	jmp    801716 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	ff 75 08             	pushl  0x8(%ebp)
  801726:	6a 26                	push   $0x26
  801728:	e8 cd fa ff ff       	call   8011fa <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
	return ;
  801730:	90                   	nop
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801737:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	6a 00                	push   $0x0
  801745:	53                   	push   %ebx
  801746:	51                   	push   %ecx
  801747:	52                   	push   %edx
  801748:	50                   	push   %eax
  801749:	6a 27                	push   $0x27
  80174b:	e8 aa fa ff ff       	call   8011fa <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80175b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	52                   	push   %edx
  801768:	50                   	push   %eax
  801769:	6a 28                	push   $0x28
  80176b:	e8 8a fa ff ff       	call   8011fa <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801778:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80177b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	6a 00                	push   $0x0
  801783:	51                   	push   %ecx
  801784:	ff 75 10             	pushl  0x10(%ebp)
  801787:	52                   	push   %edx
  801788:	50                   	push   %eax
  801789:	6a 29                	push   $0x29
  80178b:	e8 6a fa ff ff       	call   8011fa <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	ff 75 10             	pushl  0x10(%ebp)
  80179f:	ff 75 0c             	pushl  0xc(%ebp)
  8017a2:	ff 75 08             	pushl  0x8(%ebp)
  8017a5:	6a 12                	push   $0x12
  8017a7:	e8 4e fa ff ff       	call   8011fa <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8017af:	90                   	nop
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	52                   	push   %edx
  8017c2:	50                   	push   %eax
  8017c3:	6a 2a                	push   $0x2a
  8017c5:	e8 30 fa ff ff       	call   8011fa <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
	return;
  8017cd:	90                   	nop
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	50                   	push   %eax
  8017df:	6a 2b                	push   $0x2b
  8017e1:	e8 14 fa ff ff       	call   8011fa <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	ff 75 08             	pushl  0x8(%ebp)
  8017fa:	6a 2c                	push   $0x2c
  8017fc:	e8 f9 f9 ff ff       	call   8011fa <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
	return;
  801804:	90                   	nop
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	ff 75 0c             	pushl  0xc(%ebp)
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	6a 2d                	push   $0x2d
  801818:	e8 dd f9 ff ff       	call   8011fa <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
	return;
  801820:	90                   	nop
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    
  801823:	90                   	nop

00801824 <__udivdi3>:
  801824:	55                   	push   %ebp
  801825:	57                   	push   %edi
  801826:	56                   	push   %esi
  801827:	53                   	push   %ebx
  801828:	83 ec 1c             	sub    $0x1c,%esp
  80182b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80182f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801837:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80183b:	89 ca                	mov    %ecx,%edx
  80183d:	89 f8                	mov    %edi,%eax
  80183f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801843:	85 f6                	test   %esi,%esi
  801845:	75 2d                	jne    801874 <__udivdi3+0x50>
  801847:	39 cf                	cmp    %ecx,%edi
  801849:	77 65                	ja     8018b0 <__udivdi3+0x8c>
  80184b:	89 fd                	mov    %edi,%ebp
  80184d:	85 ff                	test   %edi,%edi
  80184f:	75 0b                	jne    80185c <__udivdi3+0x38>
  801851:	b8 01 00 00 00       	mov    $0x1,%eax
  801856:	31 d2                	xor    %edx,%edx
  801858:	f7 f7                	div    %edi
  80185a:	89 c5                	mov    %eax,%ebp
  80185c:	31 d2                	xor    %edx,%edx
  80185e:	89 c8                	mov    %ecx,%eax
  801860:	f7 f5                	div    %ebp
  801862:	89 c1                	mov    %eax,%ecx
  801864:	89 d8                	mov    %ebx,%eax
  801866:	f7 f5                	div    %ebp
  801868:	89 cf                	mov    %ecx,%edi
  80186a:	89 fa                	mov    %edi,%edx
  80186c:	83 c4 1c             	add    $0x1c,%esp
  80186f:	5b                   	pop    %ebx
  801870:	5e                   	pop    %esi
  801871:	5f                   	pop    %edi
  801872:	5d                   	pop    %ebp
  801873:	c3                   	ret    
  801874:	39 ce                	cmp    %ecx,%esi
  801876:	77 28                	ja     8018a0 <__udivdi3+0x7c>
  801878:	0f bd fe             	bsr    %esi,%edi
  80187b:	83 f7 1f             	xor    $0x1f,%edi
  80187e:	75 40                	jne    8018c0 <__udivdi3+0x9c>
  801880:	39 ce                	cmp    %ecx,%esi
  801882:	72 0a                	jb     80188e <__udivdi3+0x6a>
  801884:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801888:	0f 87 9e 00 00 00    	ja     80192c <__udivdi3+0x108>
  80188e:	b8 01 00 00 00       	mov    $0x1,%eax
  801893:	89 fa                	mov    %edi,%edx
  801895:	83 c4 1c             	add    $0x1c,%esp
  801898:	5b                   	pop    %ebx
  801899:	5e                   	pop    %esi
  80189a:	5f                   	pop    %edi
  80189b:	5d                   	pop    %ebp
  80189c:	c3                   	ret    
  80189d:	8d 76 00             	lea    0x0(%esi),%esi
  8018a0:	31 ff                	xor    %edi,%edi
  8018a2:	31 c0                	xor    %eax,%eax
  8018a4:	89 fa                	mov    %edi,%edx
  8018a6:	83 c4 1c             	add    $0x1c,%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5e                   	pop    %esi
  8018ab:	5f                   	pop    %edi
  8018ac:	5d                   	pop    %ebp
  8018ad:	c3                   	ret    
  8018ae:	66 90                	xchg   %ax,%ax
  8018b0:	89 d8                	mov    %ebx,%eax
  8018b2:	f7 f7                	div    %edi
  8018b4:	31 ff                	xor    %edi,%edi
  8018b6:	89 fa                	mov    %edi,%edx
  8018b8:	83 c4 1c             	add    $0x1c,%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5f                   	pop    %edi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    
  8018c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018c5:	89 eb                	mov    %ebp,%ebx
  8018c7:	29 fb                	sub    %edi,%ebx
  8018c9:	89 f9                	mov    %edi,%ecx
  8018cb:	d3 e6                	shl    %cl,%esi
  8018cd:	89 c5                	mov    %eax,%ebp
  8018cf:	88 d9                	mov    %bl,%cl
  8018d1:	d3 ed                	shr    %cl,%ebp
  8018d3:	89 e9                	mov    %ebp,%ecx
  8018d5:	09 f1                	or     %esi,%ecx
  8018d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018db:	89 f9                	mov    %edi,%ecx
  8018dd:	d3 e0                	shl    %cl,%eax
  8018df:	89 c5                	mov    %eax,%ebp
  8018e1:	89 d6                	mov    %edx,%esi
  8018e3:	88 d9                	mov    %bl,%cl
  8018e5:	d3 ee                	shr    %cl,%esi
  8018e7:	89 f9                	mov    %edi,%ecx
  8018e9:	d3 e2                	shl    %cl,%edx
  8018eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018ef:	88 d9                	mov    %bl,%cl
  8018f1:	d3 e8                	shr    %cl,%eax
  8018f3:	09 c2                	or     %eax,%edx
  8018f5:	89 d0                	mov    %edx,%eax
  8018f7:	89 f2                	mov    %esi,%edx
  8018f9:	f7 74 24 0c          	divl   0xc(%esp)
  8018fd:	89 d6                	mov    %edx,%esi
  8018ff:	89 c3                	mov    %eax,%ebx
  801901:	f7 e5                	mul    %ebp
  801903:	39 d6                	cmp    %edx,%esi
  801905:	72 19                	jb     801920 <__udivdi3+0xfc>
  801907:	74 0b                	je     801914 <__udivdi3+0xf0>
  801909:	89 d8                	mov    %ebx,%eax
  80190b:	31 ff                	xor    %edi,%edi
  80190d:	e9 58 ff ff ff       	jmp    80186a <__udivdi3+0x46>
  801912:	66 90                	xchg   %ax,%ax
  801914:	8b 54 24 08          	mov    0x8(%esp),%edx
  801918:	89 f9                	mov    %edi,%ecx
  80191a:	d3 e2                	shl    %cl,%edx
  80191c:	39 c2                	cmp    %eax,%edx
  80191e:	73 e9                	jae    801909 <__udivdi3+0xe5>
  801920:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801923:	31 ff                	xor    %edi,%edi
  801925:	e9 40 ff ff ff       	jmp    80186a <__udivdi3+0x46>
  80192a:	66 90                	xchg   %ax,%ax
  80192c:	31 c0                	xor    %eax,%eax
  80192e:	e9 37 ff ff ff       	jmp    80186a <__udivdi3+0x46>
  801933:	90                   	nop

00801934 <__umoddi3>:
  801934:	55                   	push   %ebp
  801935:	57                   	push   %edi
  801936:	56                   	push   %esi
  801937:	53                   	push   %ebx
  801938:	83 ec 1c             	sub    $0x1c,%esp
  80193b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80193f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801943:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801947:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80194b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80194f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801953:	89 f3                	mov    %esi,%ebx
  801955:	89 fa                	mov    %edi,%edx
  801957:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80195b:	89 34 24             	mov    %esi,(%esp)
  80195e:	85 c0                	test   %eax,%eax
  801960:	75 1a                	jne    80197c <__umoddi3+0x48>
  801962:	39 f7                	cmp    %esi,%edi
  801964:	0f 86 a2 00 00 00    	jbe    801a0c <__umoddi3+0xd8>
  80196a:	89 c8                	mov    %ecx,%eax
  80196c:	89 f2                	mov    %esi,%edx
  80196e:	f7 f7                	div    %edi
  801970:	89 d0                	mov    %edx,%eax
  801972:	31 d2                	xor    %edx,%edx
  801974:	83 c4 1c             	add    $0x1c,%esp
  801977:	5b                   	pop    %ebx
  801978:	5e                   	pop    %esi
  801979:	5f                   	pop    %edi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    
  80197c:	39 f0                	cmp    %esi,%eax
  80197e:	0f 87 ac 00 00 00    	ja     801a30 <__umoddi3+0xfc>
  801984:	0f bd e8             	bsr    %eax,%ebp
  801987:	83 f5 1f             	xor    $0x1f,%ebp
  80198a:	0f 84 ac 00 00 00    	je     801a3c <__umoddi3+0x108>
  801990:	bf 20 00 00 00       	mov    $0x20,%edi
  801995:	29 ef                	sub    %ebp,%edi
  801997:	89 fe                	mov    %edi,%esi
  801999:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80199d:	89 e9                	mov    %ebp,%ecx
  80199f:	d3 e0                	shl    %cl,%eax
  8019a1:	89 d7                	mov    %edx,%edi
  8019a3:	89 f1                	mov    %esi,%ecx
  8019a5:	d3 ef                	shr    %cl,%edi
  8019a7:	09 c7                	or     %eax,%edi
  8019a9:	89 e9                	mov    %ebp,%ecx
  8019ab:	d3 e2                	shl    %cl,%edx
  8019ad:	89 14 24             	mov    %edx,(%esp)
  8019b0:	89 d8                	mov    %ebx,%eax
  8019b2:	d3 e0                	shl    %cl,%eax
  8019b4:	89 c2                	mov    %eax,%edx
  8019b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019ba:	d3 e0                	shl    %cl,%eax
  8019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019c4:	89 f1                	mov    %esi,%ecx
  8019c6:	d3 e8                	shr    %cl,%eax
  8019c8:	09 d0                	or     %edx,%eax
  8019ca:	d3 eb                	shr    %cl,%ebx
  8019cc:	89 da                	mov    %ebx,%edx
  8019ce:	f7 f7                	div    %edi
  8019d0:	89 d3                	mov    %edx,%ebx
  8019d2:	f7 24 24             	mull   (%esp)
  8019d5:	89 c6                	mov    %eax,%esi
  8019d7:	89 d1                	mov    %edx,%ecx
  8019d9:	39 d3                	cmp    %edx,%ebx
  8019db:	0f 82 87 00 00 00    	jb     801a68 <__umoddi3+0x134>
  8019e1:	0f 84 91 00 00 00    	je     801a78 <__umoddi3+0x144>
  8019e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019eb:	29 f2                	sub    %esi,%edx
  8019ed:	19 cb                	sbb    %ecx,%ebx
  8019ef:	89 d8                	mov    %ebx,%eax
  8019f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019f5:	d3 e0                	shl    %cl,%eax
  8019f7:	89 e9                	mov    %ebp,%ecx
  8019f9:	d3 ea                	shr    %cl,%edx
  8019fb:	09 d0                	or     %edx,%eax
  8019fd:	89 e9                	mov    %ebp,%ecx
  8019ff:	d3 eb                	shr    %cl,%ebx
  801a01:	89 da                	mov    %ebx,%edx
  801a03:	83 c4 1c             	add    $0x1c,%esp
  801a06:	5b                   	pop    %ebx
  801a07:	5e                   	pop    %esi
  801a08:	5f                   	pop    %edi
  801a09:	5d                   	pop    %ebp
  801a0a:	c3                   	ret    
  801a0b:	90                   	nop
  801a0c:	89 fd                	mov    %edi,%ebp
  801a0e:	85 ff                	test   %edi,%edi
  801a10:	75 0b                	jne    801a1d <__umoddi3+0xe9>
  801a12:	b8 01 00 00 00       	mov    $0x1,%eax
  801a17:	31 d2                	xor    %edx,%edx
  801a19:	f7 f7                	div    %edi
  801a1b:	89 c5                	mov    %eax,%ebp
  801a1d:	89 f0                	mov    %esi,%eax
  801a1f:	31 d2                	xor    %edx,%edx
  801a21:	f7 f5                	div    %ebp
  801a23:	89 c8                	mov    %ecx,%eax
  801a25:	f7 f5                	div    %ebp
  801a27:	89 d0                	mov    %edx,%eax
  801a29:	e9 44 ff ff ff       	jmp    801972 <__umoddi3+0x3e>
  801a2e:	66 90                	xchg   %ax,%ax
  801a30:	89 c8                	mov    %ecx,%eax
  801a32:	89 f2                	mov    %esi,%edx
  801a34:	83 c4 1c             	add    $0x1c,%esp
  801a37:	5b                   	pop    %ebx
  801a38:	5e                   	pop    %esi
  801a39:	5f                   	pop    %edi
  801a3a:	5d                   	pop    %ebp
  801a3b:	c3                   	ret    
  801a3c:	3b 04 24             	cmp    (%esp),%eax
  801a3f:	72 06                	jb     801a47 <__umoddi3+0x113>
  801a41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a45:	77 0f                	ja     801a56 <__umoddi3+0x122>
  801a47:	89 f2                	mov    %esi,%edx
  801a49:	29 f9                	sub    %edi,%ecx
  801a4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a4f:	89 14 24             	mov    %edx,(%esp)
  801a52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a56:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a5a:	8b 14 24             	mov    (%esp),%edx
  801a5d:	83 c4 1c             	add    $0x1c,%esp
  801a60:	5b                   	pop    %ebx
  801a61:	5e                   	pop    %esi
  801a62:	5f                   	pop    %edi
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    
  801a65:	8d 76 00             	lea    0x0(%esi),%esi
  801a68:	2b 04 24             	sub    (%esp),%eax
  801a6b:	19 fa                	sbb    %edi,%edx
  801a6d:	89 d1                	mov    %edx,%ecx
  801a6f:	89 c6                	mov    %eax,%esi
  801a71:	e9 71 ff ff ff       	jmp    8019e7 <__umoddi3+0xb3>
  801a76:	66 90                	xchg   %ax,%ax
  801a78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a7c:	72 ea                	jb     801a68 <__umoddi3+0x134>
  801a7e:	89 d9                	mov    %ebx,%ecx
  801a80:	e9 62 ff ff ff       	jmp    8019e7 <__umoddi3+0xb3>
