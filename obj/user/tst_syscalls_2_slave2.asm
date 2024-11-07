
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
  800048:	e8 b7 17 00 00       	call   801804 <sys_allocate_user_mem>
  80004d:	83 c4 10             	add    $0x10,%esp
	inctst();
  800050:	e8 c9 15 00 00       	call   80161e <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	68 a0 1a 80 00       	push   $0x801aa0
  80005d:	6a 0a                	push   $0xa
  80005f:	68 22 1b 80 00       	push   $0x801b22
  800064:	e8 37 01 00 00       	call   8001a0 <_panic>

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
  80006f:	e8 6c 14 00 00       	call   8014e0 <sys_getenvindex>
  800074:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007a:	89 d0                	mov    %edx,%eax
  80007c:	c1 e0 02             	shl    $0x2,%eax
  80007f:	01 d0                	add    %edx,%eax
  800081:	01 c0                	add    %eax,%eax
  800083:	01 d0                	add    %edx,%eax
  800085:	c1 e0 02             	shl    $0x2,%eax
  800088:	01 d0                	add    %edx,%eax
  80008a:	01 c0                	add    %eax,%eax
  80008c:	01 d0                	add    %edx,%eax
  80008e:	c1 e0 04             	shl    $0x4,%eax
  800091:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800096:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009b:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a0:	8a 40 20             	mov    0x20(%eax),%al
  8000a3:	84 c0                	test   %al,%al
  8000a5:	74 0d                	je     8000b4 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000a7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ac:	83 c0 20             	add    $0x20,%eax
  8000af:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b8:	7e 0a                	jle    8000c4 <libmain+0x5b>
		binaryname = argv[0];
  8000ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bd:	8b 00                	mov    (%eax),%eax
  8000bf:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	ff 75 0c             	pushl  0xc(%ebp)
  8000ca:	ff 75 08             	pushl  0x8(%ebp)
  8000cd:	e8 66 ff ff ff       	call   800038 <_main>
  8000d2:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000d5:	e8 8a 11 00 00       	call   801264 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 58 1b 80 00       	push   $0x801b58
  8000e2:	e8 76 03 00 00       	call   80045d <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000ea:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ef:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000f5:	a1 04 30 80 00       	mov    0x803004,%eax
  8000fa:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	52                   	push   %edx
  800104:	50                   	push   %eax
  800105:	68 80 1b 80 00       	push   $0x801b80
  80010a:	e8 4e 03 00 00       	call   80045d <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800112:	a1 04 30 80 00       	mov    0x803004,%eax
  800117:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80011d:	a1 04 30 80 00       	mov    0x803004,%eax
  800122:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800128:	a1 04 30 80 00       	mov    0x803004,%eax
  80012d:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800133:	51                   	push   %ecx
  800134:	52                   	push   %edx
  800135:	50                   	push   %eax
  800136:	68 a8 1b 80 00       	push   $0x801ba8
  80013b:	e8 1d 03 00 00       	call   80045d <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800143:	a1 04 30 80 00       	mov    0x803004,%eax
  800148:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80014e:	83 ec 08             	sub    $0x8,%esp
  800151:	50                   	push   %eax
  800152:	68 00 1c 80 00       	push   $0x801c00
  800157:	e8 01 03 00 00       	call   80045d <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80015f:	83 ec 0c             	sub    $0xc,%esp
  800162:	68 58 1b 80 00       	push   $0x801b58
  800167:	e8 f1 02 00 00       	call   80045d <cprintf>
  80016c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80016f:	e8 0a 11 00 00       	call   80127e <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800174:	e8 19 00 00 00       	call   800192 <exit>
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	6a 00                	push   $0x0
  800187:	e8 20 13 00 00       	call   8014ac <sys_destroy_env>
  80018c:	83 c4 10             	add    $0x10,%esp
}
  80018f:	90                   	nop
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <exit>:

void
exit(void)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800198:	e8 75 13 00 00       	call   801512 <sys_exit_env>
}
  80019d:	90                   	nop
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001a6:	8d 45 10             	lea    0x10(%ebp),%eax
  8001a9:	83 c0 04             	add    $0x4,%eax
  8001ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001af:	a1 24 30 80 00       	mov    0x803024,%eax
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	74 16                	je     8001ce <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001b8:	a1 24 30 80 00       	mov    0x803024,%eax
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	50                   	push   %eax
  8001c1:	68 14 1c 80 00       	push   $0x801c14
  8001c6:	e8 92 02 00 00       	call   80045d <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001ce:	a1 00 30 80 00       	mov    0x803000,%eax
  8001d3:	ff 75 0c             	pushl  0xc(%ebp)
  8001d6:	ff 75 08             	pushl  0x8(%ebp)
  8001d9:	50                   	push   %eax
  8001da:	68 19 1c 80 00       	push   $0x801c19
  8001df:	e8 79 02 00 00       	call   80045d <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f0:	50                   	push   %eax
  8001f1:	e8 fc 01 00 00       	call   8003f2 <vcprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	6a 00                	push   $0x0
  8001fe:	68 35 1c 80 00       	push   $0x801c35
  800203:	e8 ea 01 00 00       	call   8003f2 <vcprintf>
  800208:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80020b:	e8 82 ff ff ff       	call   800192 <exit>

	// should not return here
	while (1) ;
  800210:	eb fe                	jmp    800210 <_panic+0x70>

00800212 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800218:	a1 04 30 80 00       	mov    0x803004,%eax
  80021d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800223:	8b 45 0c             	mov    0xc(%ebp),%eax
  800226:	39 c2                	cmp    %eax,%edx
  800228:	74 14                	je     80023e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80022a:	83 ec 04             	sub    $0x4,%esp
  80022d:	68 38 1c 80 00       	push   $0x801c38
  800232:	6a 26                	push   $0x26
  800234:	68 84 1c 80 00       	push   $0x801c84
  800239:	e8 62 ff ff ff       	call   8001a0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80023e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800245:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80024c:	e9 c5 00 00 00       	jmp    800316 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80025b:	8b 45 08             	mov    0x8(%ebp),%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	8b 00                	mov    (%eax),%eax
  800262:	85 c0                	test   %eax,%eax
  800264:	75 08                	jne    80026e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800266:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800269:	e9 a5 00 00 00       	jmp    800313 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80026e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800275:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80027c:	eb 69                	jmp    8002e7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80027e:	a1 04 30 80 00       	mov    0x803004,%eax
  800283:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800289:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80028c:	89 d0                	mov    %edx,%eax
  80028e:	01 c0                	add    %eax,%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	c1 e0 03             	shl    $0x3,%eax
  800295:	01 c8                	add    %ecx,%eax
  800297:	8a 40 04             	mov    0x4(%eax),%al
  80029a:	84 c0                	test   %al,%al
  80029c:	75 46                	jne    8002e4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80029e:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a3:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8002a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002ac:	89 d0                	mov    %edx,%eax
  8002ae:	01 c0                	add    %eax,%eax
  8002b0:	01 d0                	add    %edx,%eax
  8002b2:	c1 e0 03             	shl    $0x3,%eax
  8002b5:	01 c8                	add    %ecx,%eax
  8002b7:	8b 00                	mov    (%eax),%eax
  8002b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d3:	01 c8                	add    %ecx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	75 09                	jne    8002e4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002db:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002e2:	eb 15                	jmp    8002f9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e4:	ff 45 e8             	incl   -0x18(%ebp)
  8002e7:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ec:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	77 85                	ja     80027e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002fd:	75 14                	jne    800313 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	68 90 1c 80 00       	push   $0x801c90
  800307:	6a 3a                	push   $0x3a
  800309:	68 84 1c 80 00       	push   $0x801c84
  80030e:	e8 8d fe ff ff       	call   8001a0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800313:	ff 45 f0             	incl   -0x10(%ebp)
  800316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800319:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80031c:	0f 8c 2f ff ff ff    	jl     800251 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800322:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800329:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800330:	eb 26                	jmp    800358 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800332:	a1 04 30 80 00       	mov    0x803004,%eax
  800337:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80033d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800340:	89 d0                	mov    %edx,%eax
  800342:	01 c0                	add    %eax,%eax
  800344:	01 d0                	add    %edx,%eax
  800346:	c1 e0 03             	shl    $0x3,%eax
  800349:	01 c8                	add    %ecx,%eax
  80034b:	8a 40 04             	mov    0x4(%eax),%al
  80034e:	3c 01                	cmp    $0x1,%al
  800350:	75 03                	jne    800355 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800352:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800355:	ff 45 e0             	incl   -0x20(%ebp)
  800358:	a1 04 30 80 00       	mov    0x803004,%eax
  80035d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800363:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800366:	39 c2                	cmp    %eax,%edx
  800368:	77 c8                	ja     800332 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80036a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800370:	74 14                	je     800386 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 e4 1c 80 00       	push   $0x801ce4
  80037a:	6a 44                	push   $0x44
  80037c:	68 84 1c 80 00       	push   $0x801c84
  800381:	e8 1a fe ff ff       	call   8001a0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800386:	90                   	nop
  800387:	c9                   	leave  
  800388:	c3                   	ret    

00800389 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800392:	8b 00                	mov    (%eax),%eax
  800394:	8d 48 01             	lea    0x1(%eax),%ecx
  800397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039a:	89 0a                	mov    %ecx,(%edx)
  80039c:	8b 55 08             	mov    0x8(%ebp),%edx
  80039f:	88 d1                	mov    %dl,%cl
  8003a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b2:	75 2c                	jne    8003e0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b4:	a0 08 30 80 00       	mov    0x803008,%al
  8003b9:	0f b6 c0             	movzbl %al,%eax
  8003bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bf:	8b 12                	mov    (%edx),%edx
  8003c1:	89 d1                	mov    %edx,%ecx
  8003c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c6:	83 c2 08             	add    $0x8,%edx
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	50                   	push   %eax
  8003cd:	51                   	push   %ecx
  8003ce:	52                   	push   %edx
  8003cf:	e8 4e 0e 00 00       	call   801222 <sys_cputs>
  8003d4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e3:	8b 40 04             	mov    0x4(%eax),%eax
  8003e6:	8d 50 01             	lea    0x1(%eax),%edx
  8003e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ec:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ef:	90                   	nop
  8003f0:	c9                   	leave  
  8003f1:	c3                   	ret    

008003f2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800402:	00 00 00 
	b.cnt = 0;
  800405:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80040c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040f:	ff 75 0c             	pushl  0xc(%ebp)
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80041b:	50                   	push   %eax
  80041c:	68 89 03 80 00       	push   $0x800389
  800421:	e8 11 02 00 00       	call   800637 <vprintfmt>
  800426:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800429:	a0 08 30 80 00       	mov    0x803008,%al
  80042e:	0f b6 c0             	movzbl %al,%eax
  800431:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800437:	83 ec 04             	sub    $0x4,%esp
  80043a:	50                   	push   %eax
  80043b:	52                   	push   %edx
  80043c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800442:	83 c0 08             	add    $0x8,%eax
  800445:	50                   	push   %eax
  800446:	e8 d7 0d 00 00       	call   801222 <sys_cputs>
  80044b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044e:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800455:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80045b:	c9                   	leave  
  80045c:	c3                   	ret    

0080045d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800463:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80046a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	ff 75 f4             	pushl  -0xc(%ebp)
  800479:	50                   	push   %eax
  80047a:	e8 73 ff ff ff       	call   8003f2 <vcprintf>
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800485:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800488:	c9                   	leave  
  800489:	c3                   	ret    

0080048a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800490:	e8 cf 0d 00 00       	call   801264 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800495:	8d 45 0c             	lea    0xc(%ebp),%eax
  800498:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a4:	50                   	push   %eax
  8004a5:	e8 48 ff ff ff       	call   8003f2 <vcprintf>
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004b0:	e8 c9 0d 00 00       	call   80127e <sys_unlock_cons>
	return cnt;
  8004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	53                   	push   %ebx
  8004be:	83 ec 14             	sub    $0x14,%esp
  8004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004cd:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d8:	77 55                	ja     80052f <printnum+0x75>
  8004da:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004dd:	72 05                	jb     8004e4 <printnum+0x2a>
  8004df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e2:	77 4b                	ja     80052f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004ea:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f2:	52                   	push   %edx
  8004f3:	50                   	push   %eax
  8004f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8004fa:	e8 21 13 00 00       	call   801820 <__udivdi3>
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	83 ec 04             	sub    $0x4,%esp
  800505:	ff 75 20             	pushl  0x20(%ebp)
  800508:	53                   	push   %ebx
  800509:	ff 75 18             	pushl  0x18(%ebp)
  80050c:	52                   	push   %edx
  80050d:	50                   	push   %eax
  80050e:	ff 75 0c             	pushl  0xc(%ebp)
  800511:	ff 75 08             	pushl  0x8(%ebp)
  800514:	e8 a1 ff ff ff       	call   8004ba <printnum>
  800519:	83 c4 20             	add    $0x20,%esp
  80051c:	eb 1a                	jmp    800538 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	ff 75 0c             	pushl  0xc(%ebp)
  800524:	ff 75 20             	pushl  0x20(%ebp)
  800527:	8b 45 08             	mov    0x8(%ebp),%eax
  80052a:	ff d0                	call   *%eax
  80052c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052f:	ff 4d 1c             	decl   0x1c(%ebp)
  800532:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800536:	7f e6                	jg     80051e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800538:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80053b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800546:	53                   	push   %ebx
  800547:	51                   	push   %ecx
  800548:	52                   	push   %edx
  800549:	50                   	push   %eax
  80054a:	e8 e1 13 00 00       	call   801930 <__umoddi3>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	05 54 1f 80 00       	add    $0x801f54,%eax
  800557:	8a 00                	mov    (%eax),%al
  800559:	0f be c0             	movsbl %al,%eax
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	ff 75 0c             	pushl  0xc(%ebp)
  800562:	50                   	push   %eax
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	ff d0                	call   *%eax
  800568:	83 c4 10             	add    $0x10,%esp
}
  80056b:	90                   	nop
  80056c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800574:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800578:	7e 1c                	jle    800596 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80057a:	8b 45 08             	mov    0x8(%ebp),%eax
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	8d 50 08             	lea    0x8(%eax),%edx
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	89 10                	mov    %edx,(%eax)
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	83 e8 08             	sub    $0x8,%eax
  80058f:	8b 50 04             	mov    0x4(%eax),%edx
  800592:	8b 00                	mov    (%eax),%eax
  800594:	eb 40                	jmp    8005d6 <getuint+0x65>
	else if (lflag)
  800596:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80059a:	74 1e                	je     8005ba <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80059c:	8b 45 08             	mov    0x8(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	8d 50 04             	lea    0x4(%eax),%edx
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	89 10                	mov    %edx,(%eax)
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	83 e8 04             	sub    $0x4,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b8:	eb 1c                	jmp    8005d6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	8d 50 04             	lea    0x4(%eax),%edx
  8005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c5:	89 10                	mov    %edx,(%eax)
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	83 e8 04             	sub    $0x4,%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d6:	5d                   	pop    %ebp
  8005d7:	c3                   	ret    

008005d8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d8:	55                   	push   %ebp
  8005d9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005db:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005df:	7e 1c                	jle    8005fd <getint+0x25>
		return va_arg(*ap, long long);
  8005e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	8d 50 08             	lea    0x8(%eax),%edx
  8005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ec:	89 10                	mov    %edx,(%eax)
  8005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	83 e8 08             	sub    $0x8,%eax
  8005f6:	8b 50 04             	mov    0x4(%eax),%edx
  8005f9:	8b 00                	mov    (%eax),%eax
  8005fb:	eb 38                	jmp    800635 <getint+0x5d>
	else if (lflag)
  8005fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800601:	74 1a                	je     80061d <getint+0x45>
		return va_arg(*ap, long);
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	8d 50 04             	lea    0x4(%eax),%edx
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	89 10                	mov    %edx,(%eax)
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	8b 00                	mov    (%eax),%eax
  800615:	83 e8 04             	sub    $0x4,%eax
  800618:	8b 00                	mov    (%eax),%eax
  80061a:	99                   	cltd   
  80061b:	eb 18                	jmp    800635 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061d:	8b 45 08             	mov    0x8(%ebp),%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	8d 50 04             	lea    0x4(%eax),%edx
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	89 10                	mov    %edx,(%eax)
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	83 e8 04             	sub    $0x4,%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	99                   	cltd   
}
  800635:	5d                   	pop    %ebp
  800636:	c3                   	ret    

00800637 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	56                   	push   %esi
  80063b:	53                   	push   %ebx
  80063c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063f:	eb 17                	jmp    800658 <vprintfmt+0x21>
			if (ch == '\0')
  800641:	85 db                	test   %ebx,%ebx
  800643:	0f 84 c1 03 00 00    	je     800a0a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	ff 75 0c             	pushl  0xc(%ebp)
  80064f:	53                   	push   %ebx
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	ff d0                	call   *%eax
  800655:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800658:	8b 45 10             	mov    0x10(%ebp),%eax
  80065b:	8d 50 01             	lea    0x1(%eax),%edx
  80065e:	89 55 10             	mov    %edx,0x10(%ebp)
  800661:	8a 00                	mov    (%eax),%al
  800663:	0f b6 d8             	movzbl %al,%ebx
  800666:	83 fb 25             	cmp    $0x25,%ebx
  800669:	75 d6                	jne    800641 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80066b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800676:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800684:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068b:	8b 45 10             	mov    0x10(%ebp),%eax
  80068e:	8d 50 01             	lea    0x1(%eax),%edx
  800691:	89 55 10             	mov    %edx,0x10(%ebp)
  800694:	8a 00                	mov    (%eax),%al
  800696:	0f b6 d8             	movzbl %al,%ebx
  800699:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80069c:	83 f8 5b             	cmp    $0x5b,%eax
  80069f:	0f 87 3d 03 00 00    	ja     8009e2 <vprintfmt+0x3ab>
  8006a5:	8b 04 85 78 1f 80 00 	mov    0x801f78(,%eax,4),%eax
  8006ac:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ae:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b2:	eb d7                	jmp    80068b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b8:	eb d1                	jmp    80068b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c4:	89 d0                	mov    %edx,%eax
  8006c6:	c1 e0 02             	shl    $0x2,%eax
  8006c9:	01 d0                	add    %edx,%eax
  8006cb:	01 c0                	add    %eax,%eax
  8006cd:	01 d8                	add    %ebx,%eax
  8006cf:	83 e8 30             	sub    $0x30,%eax
  8006d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d8:	8a 00                	mov    (%eax),%al
  8006da:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006dd:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e0:	7e 3e                	jle    800720 <vprintfmt+0xe9>
  8006e2:	83 fb 39             	cmp    $0x39,%ebx
  8006e5:	7f 39                	jg     800720 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006ea:	eb d5                	jmp    8006c1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	83 c0 04             	add    $0x4,%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	83 e8 04             	sub    $0x4,%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800700:	eb 1f                	jmp    800721 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800702:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800706:	79 83                	jns    80068b <vprintfmt+0x54>
				width = 0;
  800708:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070f:	e9 77 ff ff ff       	jmp    80068b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800714:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80071b:	e9 6b ff ff ff       	jmp    80068b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800720:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800721:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800725:	0f 89 60 ff ff ff    	jns    80068b <vprintfmt+0x54>
				width = precision, precision = -1;
  80072b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800731:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800738:	e9 4e ff ff ff       	jmp    80068b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800740:	e9 46 ff ff ff       	jmp    80068b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	83 c0 04             	add    $0x4,%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	83 e8 04             	sub    $0x4,%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	50                   	push   %eax
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
			break;
  800765:	e9 9b 02 00 00       	jmp    800a05 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	83 c0 04             	add    $0x4,%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	83 e8 04             	sub    $0x4,%eax
  800779:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80077b:	85 db                	test   %ebx,%ebx
  80077d:	79 02                	jns    800781 <vprintfmt+0x14a>
				err = -err;
  80077f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800781:	83 fb 64             	cmp    $0x64,%ebx
  800784:	7f 0b                	jg     800791 <vprintfmt+0x15a>
  800786:	8b 34 9d c0 1d 80 00 	mov    0x801dc0(,%ebx,4),%esi
  80078d:	85 f6                	test   %esi,%esi
  80078f:	75 19                	jne    8007aa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800791:	53                   	push   %ebx
  800792:	68 65 1f 80 00       	push   $0x801f65
  800797:	ff 75 0c             	pushl  0xc(%ebp)
  80079a:	ff 75 08             	pushl  0x8(%ebp)
  80079d:	e8 70 02 00 00       	call   800a12 <printfmt>
  8007a2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a5:	e9 5b 02 00 00       	jmp    800a05 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007aa:	56                   	push   %esi
  8007ab:	68 6e 1f 80 00       	push   $0x801f6e
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	ff 75 08             	pushl  0x8(%ebp)
  8007b6:	e8 57 02 00 00       	call   800a12 <printfmt>
  8007bb:	83 c4 10             	add    $0x10,%esp
			break;
  8007be:	e9 42 02 00 00       	jmp    800a05 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 c0 04             	add    $0x4,%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	83 e8 04             	sub    $0x4,%eax
  8007d2:	8b 30                	mov    (%eax),%esi
  8007d4:	85 f6                	test   %esi,%esi
  8007d6:	75 05                	jne    8007dd <vprintfmt+0x1a6>
				p = "(null)";
  8007d8:	be 71 1f 80 00       	mov    $0x801f71,%esi
			if (width > 0 && padc != '-')
  8007dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e1:	7e 6d                	jle    800850 <vprintfmt+0x219>
  8007e3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e7:	74 67                	je     800850 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	50                   	push   %eax
  8007f0:	56                   	push   %esi
  8007f1:	e8 1e 03 00 00       	call   800b14 <strnlen>
  8007f6:	83 c4 10             	add    $0x10,%esp
  8007f9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007fc:	eb 16                	jmp    800814 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fe:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	50                   	push   %eax
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	ff d0                	call   *%eax
  80080e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800811:	ff 4d e4             	decl   -0x1c(%ebp)
  800814:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800818:	7f e4                	jg     8007fe <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081a:	eb 34                	jmp    800850 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80081c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800820:	74 1c                	je     80083e <vprintfmt+0x207>
  800822:	83 fb 1f             	cmp    $0x1f,%ebx
  800825:	7e 05                	jle    80082c <vprintfmt+0x1f5>
  800827:	83 fb 7e             	cmp    $0x7e,%ebx
  80082a:	7e 12                	jle    80083e <vprintfmt+0x207>
					putch('?', putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	6a 3f                	push   $0x3f
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	ff d0                	call   *%eax
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	eb 0f                	jmp    80084d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	53                   	push   %ebx
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084d:	ff 4d e4             	decl   -0x1c(%ebp)
  800850:	89 f0                	mov    %esi,%eax
  800852:	8d 70 01             	lea    0x1(%eax),%esi
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be d8             	movsbl %al,%ebx
  80085a:	85 db                	test   %ebx,%ebx
  80085c:	74 24                	je     800882 <vprintfmt+0x24b>
  80085e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800862:	78 b8                	js     80081c <vprintfmt+0x1e5>
  800864:	ff 4d e0             	decl   -0x20(%ebp)
  800867:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086b:	79 af                	jns    80081c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086d:	eb 13                	jmp    800882 <vprintfmt+0x24b>
				putch(' ', putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	6a 20                	push   $0x20
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	ff d0                	call   *%eax
  80087c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087f:	ff 4d e4             	decl   -0x1c(%ebp)
  800882:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800886:	7f e7                	jg     80086f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800888:	e9 78 01 00 00       	jmp    800a05 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	ff 75 e8             	pushl  -0x18(%ebp)
  800893:	8d 45 14             	lea    0x14(%ebp),%eax
  800896:	50                   	push   %eax
  800897:	e8 3c fd ff ff       	call   8005d8 <getint>
  80089c:	83 c4 10             	add    $0x10,%esp
  80089f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ab:	85 d2                	test   %edx,%edx
  8008ad:	79 23                	jns    8008d2 <vprintfmt+0x29b>
				putch('-', putdat);
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	ff 75 0c             	pushl  0xc(%ebp)
  8008b5:	6a 2d                	push   $0x2d
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	ff d0                	call   *%eax
  8008bc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c5:	f7 d8                	neg    %eax
  8008c7:	83 d2 00             	adc    $0x0,%edx
  8008ca:	f7 da                	neg    %edx
  8008cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d9:	e9 bc 00 00 00       	jmp    80099a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e7:	50                   	push   %eax
  8008e8:	e8 84 fc ff ff       	call   800571 <getuint>
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fd:	e9 98 00 00 00       	jmp    80099a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	6a 58                	push   $0x58
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	6a 58                	push   $0x58
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	ff d0                	call   *%eax
  80091f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	6a 58                	push   $0x58
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	ff d0                	call   *%eax
  80092f:	83 c4 10             	add    $0x10,%esp
			break;
  800932:	e9 ce 00 00 00       	jmp    800a05 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 30                	push   $0x30
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	6a 78                	push   $0x78
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	ff d0                	call   *%eax
  800954:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	83 c0 04             	add    $0x4,%eax
  80095d:	89 45 14             	mov    %eax,0x14(%ebp)
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	83 e8 04             	sub    $0x4,%eax
  800966:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800968:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800972:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800979:	eb 1f                	jmp    80099a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	ff 75 e8             	pushl  -0x18(%ebp)
  800981:	8d 45 14             	lea    0x14(%ebp),%eax
  800984:	50                   	push   %eax
  800985:	e8 e7 fb ff ff       	call   800571 <getuint>
  80098a:	83 c4 10             	add    $0x10,%esp
  80098d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800990:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800993:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80099a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a1:	83 ec 04             	sub    $0x4,%esp
  8009a4:	52                   	push   %edx
  8009a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a8:	50                   	push   %eax
  8009a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	ff 75 08             	pushl  0x8(%ebp)
  8009b5:	e8 00 fb ff ff       	call   8004ba <printnum>
  8009ba:	83 c4 20             	add    $0x20,%esp
			break;
  8009bd:	eb 46                	jmp    800a05 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	ff 75 0c             	pushl  0xc(%ebp)
  8009c5:	53                   	push   %ebx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	ff d0                	call   *%eax
  8009cb:	83 c4 10             	add    $0x10,%esp
			break;
  8009ce:	eb 35                	jmp    800a05 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009d0:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009d7:	eb 2c                	jmp    800a05 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009d9:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009e0:	eb 23                	jmp    800a05 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	6a 25                	push   $0x25
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	ff d0                	call   *%eax
  8009ef:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f2:	ff 4d 10             	decl   0x10(%ebp)
  8009f5:	eb 03                	jmp    8009fa <vprintfmt+0x3c3>
  8009f7:	ff 4d 10             	decl   0x10(%ebp)
  8009fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fd:	48                   	dec    %eax
  8009fe:	8a 00                	mov    (%eax),%al
  800a00:	3c 25                	cmp    $0x25,%al
  800a02:	75 f3                	jne    8009f7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a04:	90                   	nop
		}
	}
  800a05:	e9 35 fc ff ff       	jmp    80063f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a0a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a0e:	5b                   	pop    %ebx
  800a0f:	5e                   	pop    %esi
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a18:	8d 45 10             	lea    0x10(%ebp),%eax
  800a1b:	83 c0 04             	add    $0x4,%eax
  800a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a21:	8b 45 10             	mov    0x10(%ebp),%eax
  800a24:	ff 75 f4             	pushl  -0xc(%ebp)
  800a27:	50                   	push   %eax
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	ff 75 08             	pushl  0x8(%ebp)
  800a2e:	e8 04 fc ff ff       	call   800637 <vprintfmt>
  800a33:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a36:	90                   	nop
  800a37:	c9                   	leave  
  800a38:	c3                   	ret    

00800a39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3f:	8b 40 08             	mov    0x8(%eax),%eax
  800a42:	8d 50 01             	lea    0x1(%eax),%edx
  800a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a48:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4e:	8b 10                	mov    (%eax),%edx
  800a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a53:	8b 40 04             	mov    0x4(%eax),%eax
  800a56:	39 c2                	cmp    %eax,%edx
  800a58:	73 12                	jae    800a6c <sprintputch+0x33>
		*b->buf++ = ch;
  800a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5d:	8b 00                	mov    (%eax),%eax
  800a5f:	8d 48 01             	lea    0x1(%eax),%ecx
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	89 0a                	mov    %ecx,(%edx)
  800a67:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6a:	88 10                	mov    %dl,(%eax)
}
  800a6c:	90                   	nop
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	01 d0                	add    %edx,%eax
  800a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a94:	74 06                	je     800a9c <vsnprintf+0x2d>
  800a96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a9a:	7f 07                	jg     800aa3 <vsnprintf+0x34>
		return -E_INVAL;
  800a9c:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa1:	eb 20                	jmp    800ac3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa3:	ff 75 14             	pushl  0x14(%ebp)
  800aa6:	ff 75 10             	pushl  0x10(%ebp)
  800aa9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	68 39 0a 80 00       	push   $0x800a39
  800ab2:	e8 80 fb ff ff       	call   800637 <vprintfmt>
  800ab7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800abd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac3:	c9                   	leave  
  800ac4:	c3                   	ret    

00800ac5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800acb:	8d 45 10             	lea    0x10(%ebp),%eax
  800ace:	83 c0 04             	add    $0x4,%eax
  800ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad7:	ff 75 f4             	pushl  -0xc(%ebp)
  800ada:	50                   	push   %eax
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	ff 75 08             	pushl  0x8(%ebp)
  800ae1:	e8 89 ff ff ff       	call   800a6f <vsnprintf>
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aef:	c9                   	leave  
  800af0:	c3                   	ret    

00800af1 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800af7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800afe:	eb 06                	jmp    800b06 <strlen+0x15>
		n++;
  800b00:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b03:	ff 45 08             	incl   0x8(%ebp)
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	8a 00                	mov    (%eax),%al
  800b0b:	84 c0                	test   %al,%al
  800b0d:	75 f1                	jne    800b00 <strlen+0xf>
		n++;
	return n;
  800b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b21:	eb 09                	jmp    800b2c <strnlen+0x18>
		n++;
  800b23:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b26:	ff 45 08             	incl   0x8(%ebp)
  800b29:	ff 4d 0c             	decl   0xc(%ebp)
  800b2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b30:	74 09                	je     800b3b <strnlen+0x27>
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	84 c0                	test   %al,%al
  800b39:	75 e8                	jne    800b23 <strnlen+0xf>
		n++;
	return n;
  800b3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b4c:	90                   	nop
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8d 50 01             	lea    0x1(%eax),%edx
  800b53:	89 55 08             	mov    %edx,0x8(%ebp)
  800b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b5f:	8a 12                	mov    (%edx),%dl
  800b61:	88 10                	mov    %dl,(%eax)
  800b63:	8a 00                	mov    (%eax),%al
  800b65:	84 c0                	test   %al,%al
  800b67:	75 e4                	jne    800b4d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b81:	eb 1f                	jmp    800ba2 <strncpy+0x34>
		*dst++ = *src;
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8d 50 01             	lea    0x1(%eax),%edx
  800b89:	89 55 08             	mov    %edx,0x8(%ebp)
  800b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8f:	8a 12                	mov    (%edx),%dl
  800b91:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b96:	8a 00                	mov    (%eax),%al
  800b98:	84 c0                	test   %al,%al
  800b9a:	74 03                	je     800b9f <strncpy+0x31>
			src++;
  800b9c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ba8:	72 d9                	jb     800b83 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800baa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bbf:	74 30                	je     800bf1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bc1:	eb 16                	jmp    800bd9 <strlcpy+0x2a>
			*dst++ = *src++;
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8d 50 01             	lea    0x1(%eax),%edx
  800bc9:	89 55 08             	mov    %edx,0x8(%ebp)
  800bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd5:	8a 12                	mov    (%edx),%dl
  800bd7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bd9:	ff 4d 10             	decl   0x10(%ebp)
  800bdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be0:	74 09                	je     800beb <strlcpy+0x3c>
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	8a 00                	mov    (%eax),%al
  800be7:	84 c0                	test   %al,%al
  800be9:	75 d8                	jne    800bc3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf7:	29 c2                	sub    %eax,%edx
  800bf9:	89 d0                	mov    %edx,%eax
}
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c00:	eb 06                	jmp    800c08 <strcmp+0xb>
		p++, q++;
  800c02:	ff 45 08             	incl   0x8(%ebp)
  800c05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	84 c0                	test   %al,%al
  800c0f:	74 0e                	je     800c1f <strcmp+0x22>
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8a 10                	mov    (%eax),%dl
  800c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	38 c2                	cmp    %al,%dl
  800c1d:	74 e3                	je     800c02 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8a 00                	mov    (%eax),%al
  800c24:	0f b6 d0             	movzbl %al,%edx
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	0f b6 c0             	movzbl %al,%eax
  800c2f:	29 c2                	sub    %eax,%edx
  800c31:	89 d0                	mov    %edx,%eax
}
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c38:	eb 09                	jmp    800c43 <strncmp+0xe>
		n--, p++, q++;
  800c3a:	ff 4d 10             	decl   0x10(%ebp)
  800c3d:	ff 45 08             	incl   0x8(%ebp)
  800c40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c47:	74 17                	je     800c60 <strncmp+0x2b>
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	84 c0                	test   %al,%al
  800c50:	74 0e                	je     800c60 <strncmp+0x2b>
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8a 10                	mov    (%eax),%dl
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	38 c2                	cmp    %al,%dl
  800c5e:	74 da                	je     800c3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c64:	75 07                	jne    800c6d <strncmp+0x38>
		return 0;
  800c66:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6b:	eb 14                	jmp    800c81 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	0f b6 d0             	movzbl %al,%edx
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	0f b6 c0             	movzbl %al,%eax
  800c7d:	29 c2                	sub    %eax,%edx
  800c7f:	89 d0                	mov    %edx,%eax
}
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 04             	sub    $0x4,%esp
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c8f:	eb 12                	jmp    800ca3 <strchr+0x20>
		if (*s == c)
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8a 00                	mov    (%eax),%al
  800c96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c99:	75 05                	jne    800ca0 <strchr+0x1d>
			return (char *) s;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	eb 11                	jmp    800cb1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ca0:	ff 45 08             	incl   0x8(%ebp)
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	84 c0                	test   %al,%al
  800caa:	75 e5                	jne    800c91 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	83 ec 04             	sub    $0x4,%esp
  800cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cbf:	eb 0d                	jmp    800cce <strfind+0x1b>
		if (*s == c)
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cc9:	74 0e                	je     800cd9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ccb:	ff 45 08             	incl   0x8(%ebp)
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	84 c0                	test   %al,%al
  800cd5:	75 ea                	jne    800cc1 <strfind+0xe>
  800cd7:	eb 01                	jmp    800cda <strfind+0x27>
		if (*s == c)
			break;
  800cd9:	90                   	nop
	return (char *) s;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    

00800cdf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cf1:	eb 0e                	jmp    800d01 <memset+0x22>
		*p++ = c;
  800cf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf6:	8d 50 01             	lea    0x1(%eax),%edx
  800cf9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cff:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d01:	ff 4d f8             	decl   -0x8(%ebp)
  800d04:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d08:	79 e9                	jns    800cf3 <memset+0x14>
		*p++ = c;

	return v;
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d0d:	c9                   	leave  
  800d0e:	c3                   	ret    

00800d0f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d21:	eb 16                	jmp    800d39 <memcpy+0x2a>
		*d++ = *s++;
  800d23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d26:	8d 50 01             	lea    0x1(%eax),%edx
  800d29:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d2f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d32:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d35:	8a 12                	mov    (%edx),%dl
  800d37:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d42:	85 c0                	test   %eax,%eax
  800d44:	75 dd                	jne    800d23 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d49:	c9                   	leave  
  800d4a:	c3                   	ret    

00800d4b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d60:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d63:	73 50                	jae    800db5 <memmove+0x6a>
  800d65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d68:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6b:	01 d0                	add    %edx,%eax
  800d6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d70:	76 43                	jbe    800db5 <memmove+0x6a>
		s += n;
  800d72:	8b 45 10             	mov    0x10(%ebp),%eax
  800d75:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d78:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d7e:	eb 10                	jmp    800d90 <memmove+0x45>
			*--d = *--s;
  800d80:	ff 4d f8             	decl   -0x8(%ebp)
  800d83:	ff 4d fc             	decl   -0x4(%ebp)
  800d86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d89:	8a 10                	mov    (%eax),%dl
  800d8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d90:	8b 45 10             	mov    0x10(%ebp),%eax
  800d93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d96:	89 55 10             	mov    %edx,0x10(%ebp)
  800d99:	85 c0                	test   %eax,%eax
  800d9b:	75 e3                	jne    800d80 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d9d:	eb 23                	jmp    800dc2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da2:	8d 50 01             	lea    0x1(%eax),%edx
  800da5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800da8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dab:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db1:	8a 12                	mov    (%edx),%dl
  800db3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800db5:	8b 45 10             	mov    0x10(%ebp),%eax
  800db8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dbe:	85 c0                	test   %eax,%eax
  800dc0:	75 dd                	jne    800d9f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    

00800dc7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dd9:	eb 2a                	jmp    800e05 <memcmp+0x3e>
		if (*s1 != *s2)
  800ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dde:	8a 10                	mov    (%eax),%dl
  800de0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	38 c2                	cmp    %al,%dl
  800de7:	74 16                	je     800dff <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800de9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f b6 d0             	movzbl %al,%edx
  800df1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	0f b6 c0             	movzbl %al,%eax
  800df9:	29 c2                	sub    %eax,%edx
  800dfb:	89 d0                	mov    %edx,%eax
  800dfd:	eb 18                	jmp    800e17 <memcmp+0x50>
		s1++, s2++;
  800dff:	ff 45 fc             	incl   -0x4(%ebp)
  800e02:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e05:	8b 45 10             	mov    0x10(%ebp),%eax
  800e08:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	75 c9                	jne    800ddb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e17:	c9                   	leave  
  800e18:	c3                   	ret    

00800e19 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e2a:	eb 15                	jmp    800e41 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	0f b6 d0             	movzbl %al,%edx
  800e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e37:	0f b6 c0             	movzbl %al,%eax
  800e3a:	39 c2                	cmp    %eax,%edx
  800e3c:	74 0d                	je     800e4b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e3e:	ff 45 08             	incl   0x8(%ebp)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e47:	72 e3                	jb     800e2c <memfind+0x13>
  800e49:	eb 01                	jmp    800e4c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e4b:	90                   	nop
	return (void *) s;
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    

00800e51 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e5e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e65:	eb 03                	jmp    800e6a <strtol+0x19>
		s++;
  800e67:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	3c 20                	cmp    $0x20,%al
  800e71:	74 f4                	je     800e67 <strtol+0x16>
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3c 09                	cmp    $0x9,%al
  800e7a:	74 eb                	je     800e67 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	3c 2b                	cmp    $0x2b,%al
  800e83:	75 05                	jne    800e8a <strtol+0x39>
		s++;
  800e85:	ff 45 08             	incl   0x8(%ebp)
  800e88:	eb 13                	jmp    800e9d <strtol+0x4c>
	else if (*s == '-')
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	3c 2d                	cmp    $0x2d,%al
  800e91:	75 0a                	jne    800e9d <strtol+0x4c>
		s++, neg = 1;
  800e93:	ff 45 08             	incl   0x8(%ebp)
  800e96:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea1:	74 06                	je     800ea9 <strtol+0x58>
  800ea3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ea7:	75 20                	jne    800ec9 <strtol+0x78>
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	3c 30                	cmp    $0x30,%al
  800eb0:	75 17                	jne    800ec9 <strtol+0x78>
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	40                   	inc    %eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	3c 78                	cmp    $0x78,%al
  800eba:	75 0d                	jne    800ec9 <strtol+0x78>
		s += 2, base = 16;
  800ebc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ec0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ec7:	eb 28                	jmp    800ef1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ec9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecd:	75 15                	jne    800ee4 <strtol+0x93>
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	3c 30                	cmp    $0x30,%al
  800ed6:	75 0c                	jne    800ee4 <strtol+0x93>
		s++, base = 8;
  800ed8:	ff 45 08             	incl   0x8(%ebp)
  800edb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ee2:	eb 0d                	jmp    800ef1 <strtol+0xa0>
	else if (base == 0)
  800ee4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee8:	75 07                	jne    800ef1 <strtol+0xa0>
		base = 10;
  800eea:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8a 00                	mov    (%eax),%al
  800ef6:	3c 2f                	cmp    $0x2f,%al
  800ef8:	7e 19                	jle    800f13 <strtol+0xc2>
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	3c 39                	cmp    $0x39,%al
  800f01:	7f 10                	jg     800f13 <strtol+0xc2>
			dig = *s - '0';
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	0f be c0             	movsbl %al,%eax
  800f0b:	83 e8 30             	sub    $0x30,%eax
  800f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f11:	eb 42                	jmp    800f55 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 60                	cmp    $0x60,%al
  800f1a:	7e 19                	jle    800f35 <strtol+0xe4>
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 7a                	cmp    $0x7a,%al
  800f23:	7f 10                	jg     800f35 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	0f be c0             	movsbl %al,%eax
  800f2d:	83 e8 57             	sub    $0x57,%eax
  800f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f33:	eb 20                	jmp    800f55 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	3c 40                	cmp    $0x40,%al
  800f3c:	7e 39                	jle    800f77 <strtol+0x126>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	3c 5a                	cmp    $0x5a,%al
  800f45:	7f 30                	jg     800f77 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	0f be c0             	movsbl %al,%eax
  800f4f:	83 e8 37             	sub    $0x37,%eax
  800f52:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f5b:	7d 19                	jge    800f76 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f5d:	ff 45 08             	incl   0x8(%ebp)
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f67:	89 c2                	mov    %eax,%edx
  800f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6c:	01 d0                	add    %edx,%eax
  800f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f71:	e9 7b ff ff ff       	jmp    800ef1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f76:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f7b:	74 08                	je     800f85 <strtol+0x134>
		*endptr = (char *) s;
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f85:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f89:	74 07                	je     800f92 <strtol+0x141>
  800f8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8e:	f7 d8                	neg    %eax
  800f90:	eb 03                	jmp    800f95 <strtol+0x144>
  800f92:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    

00800f97 <ltostr>:

void
ltostr(long value, char *str)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fa4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800faf:	79 13                	jns    800fc4 <ltostr+0x2d>
	{
		neg = 1;
  800fb1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fbe:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fc1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fcc:	99                   	cltd   
  800fcd:	f7 f9                	idiv   %ecx
  800fcf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd5:	8d 50 01             	lea    0x1(%eax),%edx
  800fd8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fdb:	89 c2                	mov    %eax,%edx
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fe5:	83 c2 30             	add    $0x30,%edx
  800fe8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff2:	f7 e9                	imul   %ecx
  800ff4:	c1 fa 02             	sar    $0x2,%edx
  800ff7:	89 c8                	mov    %ecx,%eax
  800ff9:	c1 f8 1f             	sar    $0x1f,%eax
  800ffc:	29 c2                	sub    %eax,%edx
  800ffe:	89 d0                	mov    %edx,%eax
  801000:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801003:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801007:	75 bb                	jne    800fc4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801009:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801010:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801013:	48                   	dec    %eax
  801014:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801017:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101b:	74 3d                	je     80105a <ltostr+0xc3>
		start = 1 ;
  80101d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801024:	eb 34                	jmp    80105a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801026:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102c:	01 d0                	add    %edx,%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801033:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	01 c2                	add    %eax,%edx
  80103b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	01 c8                	add    %ecx,%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801047:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80104a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104d:	01 c2                	add    %eax,%edx
  80104f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801052:	88 02                	mov    %al,(%edx)
		start++ ;
  801054:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801057:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80105a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801060:	7c c4                	jl     801026 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801062:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801065:	8b 45 0c             	mov    0xc(%ebp),%eax
  801068:	01 d0                	add    %edx,%eax
  80106a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80106d:	90                   	nop
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801076:	ff 75 08             	pushl  0x8(%ebp)
  801079:	e8 73 fa ff ff       	call   800af1 <strlen>
  80107e:	83 c4 04             	add    $0x4,%esp
  801081:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	e8 65 fa ff ff       	call   800af1 <strlen>
  80108c:	83 c4 04             	add    $0x4,%esp
  80108f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801092:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801099:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a0:	eb 17                	jmp    8010b9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a8:	01 c2                	add    %eax,%edx
  8010aa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	01 c8                	add    %ecx,%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010b6:	ff 45 fc             	incl   -0x4(%ebp)
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010bf:	7c e1                	jl     8010a2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010cf:	eb 1f                	jmp    8010f0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d4:	8d 50 01             	lea    0x1(%eax),%edx
  8010d7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010da:	89 c2                	mov    %eax,%edx
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	01 c2                	add    %eax,%edx
  8010e1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e7:	01 c8                	add    %ecx,%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010ed:	ff 45 f8             	incl   -0x8(%ebp)
  8010f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f6:	7c d9                	jl     8010d1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fe:	01 d0                	add    %edx,%eax
  801100:	c6 00 00             	movb   $0x0,(%eax)
}
  801103:	90                   	nop
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801109:	8b 45 14             	mov    0x14(%ebp),%eax
  80110c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801112:	8b 45 14             	mov    0x14(%ebp),%eax
  801115:	8b 00                	mov    (%eax),%eax
  801117:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80111e:	8b 45 10             	mov    0x10(%ebp),%eax
  801121:	01 d0                	add    %edx,%eax
  801123:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801129:	eb 0c                	jmp    801137 <strsplit+0x31>
			*string++ = 0;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8d 50 01             	lea    0x1(%eax),%edx
  801131:	89 55 08             	mov    %edx,0x8(%ebp)
  801134:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	84 c0                	test   %al,%al
  80113e:	74 18                	je     801158 <strsplit+0x52>
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	8a 00                	mov    (%eax),%al
  801145:	0f be c0             	movsbl %al,%eax
  801148:	50                   	push   %eax
  801149:	ff 75 0c             	pushl  0xc(%ebp)
  80114c:	e8 32 fb ff ff       	call   800c83 <strchr>
  801151:	83 c4 08             	add    $0x8,%esp
  801154:	85 c0                	test   %eax,%eax
  801156:	75 d3                	jne    80112b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	84 c0                	test   %al,%al
  80115f:	74 5a                	je     8011bb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801161:	8b 45 14             	mov    0x14(%ebp),%eax
  801164:	8b 00                	mov    (%eax),%eax
  801166:	83 f8 0f             	cmp    $0xf,%eax
  801169:	75 07                	jne    801172 <strsplit+0x6c>
		{
			return 0;
  80116b:	b8 00 00 00 00       	mov    $0x0,%eax
  801170:	eb 66                	jmp    8011d8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801172:	8b 45 14             	mov    0x14(%ebp),%eax
  801175:	8b 00                	mov    (%eax),%eax
  801177:	8d 48 01             	lea    0x1(%eax),%ecx
  80117a:	8b 55 14             	mov    0x14(%ebp),%edx
  80117d:	89 0a                	mov    %ecx,(%edx)
  80117f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801186:	8b 45 10             	mov    0x10(%ebp),%eax
  801189:	01 c2                	add    %eax,%edx
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801190:	eb 03                	jmp    801195 <strsplit+0x8f>
			string++;
  801192:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	84 c0                	test   %al,%al
  80119c:	74 8b                	je     801129 <strsplit+0x23>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	50                   	push   %eax
  8011a7:	ff 75 0c             	pushl  0xc(%ebp)
  8011aa:	e8 d4 fa ff ff       	call   800c83 <strchr>
  8011af:	83 c4 08             	add    $0x8,%esp
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	74 dc                	je     801192 <strsplit+0x8c>
			string++;
	}
  8011b6:	e9 6e ff ff ff       	jmp    801129 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011bb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bf:	8b 00                	mov    (%eax),%eax
  8011c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011e0:	83 ec 04             	sub    $0x4,%esp
  8011e3:	68 e8 20 80 00       	push   $0x8020e8
  8011e8:	68 3f 01 00 00       	push   $0x13f
  8011ed:	68 0a 21 80 00       	push   $0x80210a
  8011f2:	e8 a9 ef ff ff       	call   8001a0 <_panic>

008011f7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	57                   	push   %edi
  8011fb:	56                   	push   %esi
  8011fc:	53                   	push   %ebx
  8011fd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8b 55 0c             	mov    0xc(%ebp),%edx
  801206:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801209:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80120c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80120f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801212:	cd 30                	int    $0x30
  801214:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801217:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	5b                   	pop    %ebx
  80121e:	5e                   	pop    %esi
  80121f:	5f                   	pop    %edi
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	8b 45 10             	mov    0x10(%ebp),%eax
  80122b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80122e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	52                   	push   %edx
  80123a:	ff 75 0c             	pushl  0xc(%ebp)
  80123d:	50                   	push   %eax
  80123e:	6a 00                	push   $0x0
  801240:	e8 b2 ff ff ff       	call   8011f7 <syscall>
  801245:	83 c4 18             	add    $0x18,%esp
}
  801248:	90                   	nop
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <sys_cgetc>:

int
sys_cgetc(void)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 02                	push   $0x2
  80125a:	e8 98 ff ff ff       	call   8011f7 <syscall>
  80125f:	83 c4 18             	add    $0x18,%esp
}
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 00                	push   $0x0
  801271:	6a 03                	push   $0x3
  801273:	e8 7f ff ff ff       	call   8011f7 <syscall>
  801278:	83 c4 18             	add    $0x18,%esp
}
  80127b:	90                   	nop
  80127c:	c9                   	leave  
  80127d:	c3                   	ret    

0080127e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 00                	push   $0x0
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 04                	push   $0x4
  80128d:	e8 65 ff ff ff       	call   8011f7 <syscall>
  801292:	83 c4 18             	add    $0x18,%esp
}
  801295:	90                   	nop
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80129b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 00                	push   $0x0
  8012a7:	52                   	push   %edx
  8012a8:	50                   	push   %eax
  8012a9:	6a 08                	push   $0x8
  8012ab:	e8 47 ff ff ff       	call   8011f7 <syscall>
  8012b0:	83 c4 18             	add    $0x18,%esp
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	56                   	push   %esi
  8012b9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012ba:	8b 75 18             	mov    0x18(%ebp),%esi
  8012bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	56                   	push   %esi
  8012ca:	53                   	push   %ebx
  8012cb:	51                   	push   %ecx
  8012cc:	52                   	push   %edx
  8012cd:	50                   	push   %eax
  8012ce:	6a 09                	push   $0x9
  8012d0:	e8 22 ff ff ff       	call   8011f7 <syscall>
  8012d5:	83 c4 18             	add    $0x18,%esp
}
  8012d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5d                   	pop    %ebp
  8012de:	c3                   	ret    

008012df <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	52                   	push   %edx
  8012ef:	50                   	push   %eax
  8012f0:	6a 0a                	push   $0xa
  8012f2:	e8 00 ff ff ff       	call   8011f7 <syscall>
  8012f7:	83 c4 18             	add    $0x18,%esp
}
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	ff 75 0c             	pushl  0xc(%ebp)
  801308:	ff 75 08             	pushl  0x8(%ebp)
  80130b:	6a 0b                	push   $0xb
  80130d:	e8 e5 fe ff ff       	call   8011f7 <syscall>
  801312:	83 c4 18             	add    $0x18,%esp
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 0c                	push   $0xc
  801326:	e8 cc fe ff ff       	call   8011f7 <syscall>
  80132b:	83 c4 18             	add    $0x18,%esp
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 0d                	push   $0xd
  80133f:	e8 b3 fe ff ff       	call   8011f7 <syscall>
  801344:	83 c4 18             	add    $0x18,%esp
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 0e                	push   $0xe
  801358:	e8 9a fe ff ff       	call   8011f7 <syscall>
  80135d:	83 c4 18             	add    $0x18,%esp
}
  801360:	c9                   	leave  
  801361:	c3                   	ret    

00801362 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 0f                	push   $0xf
  801371:	e8 81 fe ff ff       	call   8011f7 <syscall>
  801376:	83 c4 18             	add    $0x18,%esp
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	ff 75 08             	pushl  0x8(%ebp)
  801389:	6a 10                	push   $0x10
  80138b:	e8 67 fe ff ff       	call   8011f7 <syscall>
  801390:	83 c4 18             	add    $0x18,%esp
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 11                	push   $0x11
  8013a4:	e8 4e fe ff ff       	call   8011f7 <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
}
  8013ac:	90                   	nop
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <sys_cputc>:

void
sys_cputc(const char c)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	83 ec 04             	sub    $0x4,%esp
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	50                   	push   %eax
  8013c8:	6a 01                	push   $0x1
  8013ca:	e8 28 fe ff ff       	call   8011f7 <syscall>
  8013cf:	83 c4 18             	add    $0x18,%esp
}
  8013d2:	90                   	nop
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 14                	push   $0x14
  8013e4:	e8 0e fe ff ff       	call   8011f7 <syscall>
  8013e9:	83 c4 18             	add    $0x18,%esp
}
  8013ec:	90                   	nop
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 04             	sub    $0x4,%esp
  8013f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	6a 00                	push   $0x0
  801407:	51                   	push   %ecx
  801408:	52                   	push   %edx
  801409:	ff 75 0c             	pushl  0xc(%ebp)
  80140c:	50                   	push   %eax
  80140d:	6a 15                	push   $0x15
  80140f:	e8 e3 fd ff ff       	call   8011f7 <syscall>
  801414:	83 c4 18             	add    $0x18,%esp
}
  801417:	c9                   	leave  
  801418:	c3                   	ret    

00801419 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80141c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	52                   	push   %edx
  801429:	50                   	push   %eax
  80142a:	6a 16                	push   $0x16
  80142c:	e8 c6 fd ff ff       	call   8011f7 <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801439:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80143c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	51                   	push   %ecx
  801447:	52                   	push   %edx
  801448:	50                   	push   %eax
  801449:	6a 17                	push   $0x17
  80144b:	e8 a7 fd ff ff       	call   8011f7 <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	52                   	push   %edx
  801465:	50                   	push   %eax
  801466:	6a 18                	push   $0x18
  801468:	e8 8a fd ff ff       	call   8011f7 <syscall>
  80146d:	83 c4 18             	add    $0x18,%esp
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	6a 00                	push   $0x0
  80147a:	ff 75 14             	pushl  0x14(%ebp)
  80147d:	ff 75 10             	pushl  0x10(%ebp)
  801480:	ff 75 0c             	pushl  0xc(%ebp)
  801483:	50                   	push   %eax
  801484:	6a 19                	push   $0x19
  801486:	e8 6c fd ff ff       	call   8011f7 <syscall>
  80148b:	83 c4 18             	add    $0x18,%esp
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	50                   	push   %eax
  80149f:	6a 1a                	push   $0x1a
  8014a1:	e8 51 fd ff ff       	call   8011f7 <syscall>
  8014a6:	83 c4 18             	add    $0x18,%esp
}
  8014a9:	90                   	nop
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	50                   	push   %eax
  8014bb:	6a 1b                	push   $0x1b
  8014bd:	e8 35 fd ff ff       	call   8011f7 <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 05                	push   $0x5
  8014d6:	e8 1c fd ff ff       	call   8011f7 <syscall>
  8014db:	83 c4 18             	add    $0x18,%esp
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 06                	push   $0x6
  8014ef:	e8 03 fd ff ff       	call   8011f7 <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 07                	push   $0x7
  801508:	e8 ea fc ff ff       	call   8011f7 <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_exit_env>:


void sys_exit_env(void)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 1c                	push   $0x1c
  801521:	e8 d1 fc ff ff       	call   8011f7 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	90                   	nop
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801532:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801535:	8d 50 04             	lea    0x4(%eax),%edx
  801538:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	52                   	push   %edx
  801542:	50                   	push   %eax
  801543:	6a 1d                	push   $0x1d
  801545:	e8 ad fc ff ff       	call   8011f7 <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
	return result;
  80154d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801550:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801553:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801556:	89 01                	mov    %eax,(%ecx)
  801558:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	c9                   	leave  
  80155f:	c2 04 00             	ret    $0x4

00801562 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	ff 75 10             	pushl  0x10(%ebp)
  80156c:	ff 75 0c             	pushl  0xc(%ebp)
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	6a 13                	push   $0x13
  801574:	e8 7e fc ff ff       	call   8011f7 <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
	return ;
  80157c:	90                   	nop
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_rcr2>:
uint32 sys_rcr2()
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 1e                	push   $0x1e
  80158e:	e8 64 fc ff ff       	call   8011f7 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 04             	sub    $0x4,%esp
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015a4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	50                   	push   %eax
  8015b1:	6a 1f                	push   $0x1f
  8015b3:	e8 3f fc ff ff       	call   8011f7 <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015bb:	90                   	nop
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <rsttst>:
void rsttst()
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 21                	push   $0x21
  8015cd:	e8 25 fc ff ff       	call   8011f7 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d5:	90                   	nop
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015e4:	8b 55 18             	mov    0x18(%ebp),%edx
  8015e7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015eb:	52                   	push   %edx
  8015ec:	50                   	push   %eax
  8015ed:	ff 75 10             	pushl  0x10(%ebp)
  8015f0:	ff 75 0c             	pushl  0xc(%ebp)
  8015f3:	ff 75 08             	pushl  0x8(%ebp)
  8015f6:	6a 20                	push   $0x20
  8015f8:	e8 fa fb ff ff       	call   8011f7 <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801600:	90                   	nop
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <chktst>:
void chktst(uint32 n)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	ff 75 08             	pushl  0x8(%ebp)
  801611:	6a 22                	push   $0x22
  801613:	e8 df fb ff ff       	call   8011f7 <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
	return ;
  80161b:	90                   	nop
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <inctst>:

void inctst()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 23                	push   $0x23
  80162d:	e8 c5 fb ff ff       	call   8011f7 <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
	return ;
  801635:	90                   	nop
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <gettst>:
uint32 gettst()
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 24                	push   $0x24
  801647:	e8 ab fb ff ff       	call   8011f7 <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 25                	push   $0x25
  801663:	e8 8f fb ff ff       	call   8011f7 <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
  80166b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80166e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801672:	75 07                	jne    80167b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801674:	b8 01 00 00 00       	mov    $0x1,%eax
  801679:	eb 05                	jmp    801680 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 25                	push   $0x25
  801694:	e8 5e fb ff ff       	call   8011f7 <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
  80169c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80169f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016a3:	75 07                	jne    8016ac <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8016aa:	eb 05                	jmp    8016b1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 25                	push   $0x25
  8016c5:	e8 2d fb ff ff       	call   8011f7 <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
  8016cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016d0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016d4:	75 07                	jne    8016dd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8016db:	eb 05                	jmp    8016e2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 25                	push   $0x25
  8016f6:	e8 fc fa ff ff       	call   8011f7 <syscall>
  8016fb:	83 c4 18             	add    $0x18,%esp
  8016fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801701:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801705:	75 07                	jne    80170e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801707:	b8 01 00 00 00       	mov    $0x1,%eax
  80170c:	eb 05                	jmp    801713 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80170e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	ff 75 08             	pushl  0x8(%ebp)
  801723:	6a 26                	push   $0x26
  801725:	e8 cd fa ff ff       	call   8011f7 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
	return ;
  80172d:	90                   	nop
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801734:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801737:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	6a 00                	push   $0x0
  801742:	53                   	push   %ebx
  801743:	51                   	push   %ecx
  801744:	52                   	push   %edx
  801745:	50                   	push   %eax
  801746:	6a 27                	push   $0x27
  801748:	e8 aa fa ff ff       	call   8011f7 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801758:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	52                   	push   %edx
  801765:	50                   	push   %eax
  801766:	6a 28                	push   $0x28
  801768:	e8 8a fa ff ff       	call   8011f7 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801775:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801778:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	6a 00                	push   $0x0
  801780:	51                   	push   %ecx
  801781:	ff 75 10             	pushl  0x10(%ebp)
  801784:	52                   	push   %edx
  801785:	50                   	push   %eax
  801786:	6a 29                	push   $0x29
  801788:	e8 6a fa ff ff       	call   8011f7 <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	ff 75 10             	pushl  0x10(%ebp)
  80179c:	ff 75 0c             	pushl  0xc(%ebp)
  80179f:	ff 75 08             	pushl  0x8(%ebp)
  8017a2:	6a 12                	push   $0x12
  8017a4:	e8 4e fa ff ff       	call   8011f7 <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ac:	90                   	nop
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	52                   	push   %edx
  8017bf:	50                   	push   %eax
  8017c0:	6a 2a                	push   $0x2a
  8017c2:	e8 30 fa ff ff       	call   8011f7 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
	return;
  8017ca:	90                   	nop
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	50                   	push   %eax
  8017dc:	6a 2b                	push   $0x2b
  8017de:	e8 14 fa ff ff       	call   8011f7 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	6a 2c                	push   $0x2c
  8017f9:	e8 f9 f9 ff ff       	call   8011f7 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
	return;
  801801:	90                   	nop
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	6a 2d                	push   $0x2d
  801815:	e8 dd f9 ff ff       	call   8011f7 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
	return;
  80181d:	90                   	nop
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <__udivdi3>:
  801820:	55                   	push   %ebp
  801821:	57                   	push   %edi
  801822:	56                   	push   %esi
  801823:	53                   	push   %ebx
  801824:	83 ec 1c             	sub    $0x1c,%esp
  801827:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80182b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80182f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801833:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801837:	89 ca                	mov    %ecx,%edx
  801839:	89 f8                	mov    %edi,%eax
  80183b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80183f:	85 f6                	test   %esi,%esi
  801841:	75 2d                	jne    801870 <__udivdi3+0x50>
  801843:	39 cf                	cmp    %ecx,%edi
  801845:	77 65                	ja     8018ac <__udivdi3+0x8c>
  801847:	89 fd                	mov    %edi,%ebp
  801849:	85 ff                	test   %edi,%edi
  80184b:	75 0b                	jne    801858 <__udivdi3+0x38>
  80184d:	b8 01 00 00 00       	mov    $0x1,%eax
  801852:	31 d2                	xor    %edx,%edx
  801854:	f7 f7                	div    %edi
  801856:	89 c5                	mov    %eax,%ebp
  801858:	31 d2                	xor    %edx,%edx
  80185a:	89 c8                	mov    %ecx,%eax
  80185c:	f7 f5                	div    %ebp
  80185e:	89 c1                	mov    %eax,%ecx
  801860:	89 d8                	mov    %ebx,%eax
  801862:	f7 f5                	div    %ebp
  801864:	89 cf                	mov    %ecx,%edi
  801866:	89 fa                	mov    %edi,%edx
  801868:	83 c4 1c             	add    $0x1c,%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5f                   	pop    %edi
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    
  801870:	39 ce                	cmp    %ecx,%esi
  801872:	77 28                	ja     80189c <__udivdi3+0x7c>
  801874:	0f bd fe             	bsr    %esi,%edi
  801877:	83 f7 1f             	xor    $0x1f,%edi
  80187a:	75 40                	jne    8018bc <__udivdi3+0x9c>
  80187c:	39 ce                	cmp    %ecx,%esi
  80187e:	72 0a                	jb     80188a <__udivdi3+0x6a>
  801880:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801884:	0f 87 9e 00 00 00    	ja     801928 <__udivdi3+0x108>
  80188a:	b8 01 00 00 00       	mov    $0x1,%eax
  80188f:	89 fa                	mov    %edi,%edx
  801891:	83 c4 1c             	add    $0x1c,%esp
  801894:	5b                   	pop    %ebx
  801895:	5e                   	pop    %esi
  801896:	5f                   	pop    %edi
  801897:	5d                   	pop    %ebp
  801898:	c3                   	ret    
  801899:	8d 76 00             	lea    0x0(%esi),%esi
  80189c:	31 ff                	xor    %edi,%edi
  80189e:	31 c0                	xor    %eax,%eax
  8018a0:	89 fa                	mov    %edi,%edx
  8018a2:	83 c4 1c             	add    $0x1c,%esp
  8018a5:	5b                   	pop    %ebx
  8018a6:	5e                   	pop    %esi
  8018a7:	5f                   	pop    %edi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    
  8018aa:	66 90                	xchg   %ax,%ax
  8018ac:	89 d8                	mov    %ebx,%eax
  8018ae:	f7 f7                	div    %edi
  8018b0:	31 ff                	xor    %edi,%edi
  8018b2:	89 fa                	mov    %edi,%edx
  8018b4:	83 c4 1c             	add    $0x1c,%esp
  8018b7:	5b                   	pop    %ebx
  8018b8:	5e                   	pop    %esi
  8018b9:	5f                   	pop    %edi
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    
  8018bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018c1:	89 eb                	mov    %ebp,%ebx
  8018c3:	29 fb                	sub    %edi,%ebx
  8018c5:	89 f9                	mov    %edi,%ecx
  8018c7:	d3 e6                	shl    %cl,%esi
  8018c9:	89 c5                	mov    %eax,%ebp
  8018cb:	88 d9                	mov    %bl,%cl
  8018cd:	d3 ed                	shr    %cl,%ebp
  8018cf:	89 e9                	mov    %ebp,%ecx
  8018d1:	09 f1                	or     %esi,%ecx
  8018d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018d7:	89 f9                	mov    %edi,%ecx
  8018d9:	d3 e0                	shl    %cl,%eax
  8018db:	89 c5                	mov    %eax,%ebp
  8018dd:	89 d6                	mov    %edx,%esi
  8018df:	88 d9                	mov    %bl,%cl
  8018e1:	d3 ee                	shr    %cl,%esi
  8018e3:	89 f9                	mov    %edi,%ecx
  8018e5:	d3 e2                	shl    %cl,%edx
  8018e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018eb:	88 d9                	mov    %bl,%cl
  8018ed:	d3 e8                	shr    %cl,%eax
  8018ef:	09 c2                	or     %eax,%edx
  8018f1:	89 d0                	mov    %edx,%eax
  8018f3:	89 f2                	mov    %esi,%edx
  8018f5:	f7 74 24 0c          	divl   0xc(%esp)
  8018f9:	89 d6                	mov    %edx,%esi
  8018fb:	89 c3                	mov    %eax,%ebx
  8018fd:	f7 e5                	mul    %ebp
  8018ff:	39 d6                	cmp    %edx,%esi
  801901:	72 19                	jb     80191c <__udivdi3+0xfc>
  801903:	74 0b                	je     801910 <__udivdi3+0xf0>
  801905:	89 d8                	mov    %ebx,%eax
  801907:	31 ff                	xor    %edi,%edi
  801909:	e9 58 ff ff ff       	jmp    801866 <__udivdi3+0x46>
  80190e:	66 90                	xchg   %ax,%ax
  801910:	8b 54 24 08          	mov    0x8(%esp),%edx
  801914:	89 f9                	mov    %edi,%ecx
  801916:	d3 e2                	shl    %cl,%edx
  801918:	39 c2                	cmp    %eax,%edx
  80191a:	73 e9                	jae    801905 <__udivdi3+0xe5>
  80191c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80191f:	31 ff                	xor    %edi,%edi
  801921:	e9 40 ff ff ff       	jmp    801866 <__udivdi3+0x46>
  801926:	66 90                	xchg   %ax,%ax
  801928:	31 c0                	xor    %eax,%eax
  80192a:	e9 37 ff ff ff       	jmp    801866 <__udivdi3+0x46>
  80192f:	90                   	nop

00801930 <__umoddi3>:
  801930:	55                   	push   %ebp
  801931:	57                   	push   %edi
  801932:	56                   	push   %esi
  801933:	53                   	push   %ebx
  801934:	83 ec 1c             	sub    $0x1c,%esp
  801937:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80193b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80193f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801943:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801947:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80194b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80194f:	89 f3                	mov    %esi,%ebx
  801951:	89 fa                	mov    %edi,%edx
  801953:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801957:	89 34 24             	mov    %esi,(%esp)
  80195a:	85 c0                	test   %eax,%eax
  80195c:	75 1a                	jne    801978 <__umoddi3+0x48>
  80195e:	39 f7                	cmp    %esi,%edi
  801960:	0f 86 a2 00 00 00    	jbe    801a08 <__umoddi3+0xd8>
  801966:	89 c8                	mov    %ecx,%eax
  801968:	89 f2                	mov    %esi,%edx
  80196a:	f7 f7                	div    %edi
  80196c:	89 d0                	mov    %edx,%eax
  80196e:	31 d2                	xor    %edx,%edx
  801970:	83 c4 1c             	add    $0x1c,%esp
  801973:	5b                   	pop    %ebx
  801974:	5e                   	pop    %esi
  801975:	5f                   	pop    %edi
  801976:	5d                   	pop    %ebp
  801977:	c3                   	ret    
  801978:	39 f0                	cmp    %esi,%eax
  80197a:	0f 87 ac 00 00 00    	ja     801a2c <__umoddi3+0xfc>
  801980:	0f bd e8             	bsr    %eax,%ebp
  801983:	83 f5 1f             	xor    $0x1f,%ebp
  801986:	0f 84 ac 00 00 00    	je     801a38 <__umoddi3+0x108>
  80198c:	bf 20 00 00 00       	mov    $0x20,%edi
  801991:	29 ef                	sub    %ebp,%edi
  801993:	89 fe                	mov    %edi,%esi
  801995:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801999:	89 e9                	mov    %ebp,%ecx
  80199b:	d3 e0                	shl    %cl,%eax
  80199d:	89 d7                	mov    %edx,%edi
  80199f:	89 f1                	mov    %esi,%ecx
  8019a1:	d3 ef                	shr    %cl,%edi
  8019a3:	09 c7                	or     %eax,%edi
  8019a5:	89 e9                	mov    %ebp,%ecx
  8019a7:	d3 e2                	shl    %cl,%edx
  8019a9:	89 14 24             	mov    %edx,(%esp)
  8019ac:	89 d8                	mov    %ebx,%eax
  8019ae:	d3 e0                	shl    %cl,%eax
  8019b0:	89 c2                	mov    %eax,%edx
  8019b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019b6:	d3 e0                	shl    %cl,%eax
  8019b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019c0:	89 f1                	mov    %esi,%ecx
  8019c2:	d3 e8                	shr    %cl,%eax
  8019c4:	09 d0                	or     %edx,%eax
  8019c6:	d3 eb                	shr    %cl,%ebx
  8019c8:	89 da                	mov    %ebx,%edx
  8019ca:	f7 f7                	div    %edi
  8019cc:	89 d3                	mov    %edx,%ebx
  8019ce:	f7 24 24             	mull   (%esp)
  8019d1:	89 c6                	mov    %eax,%esi
  8019d3:	89 d1                	mov    %edx,%ecx
  8019d5:	39 d3                	cmp    %edx,%ebx
  8019d7:	0f 82 87 00 00 00    	jb     801a64 <__umoddi3+0x134>
  8019dd:	0f 84 91 00 00 00    	je     801a74 <__umoddi3+0x144>
  8019e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019e7:	29 f2                	sub    %esi,%edx
  8019e9:	19 cb                	sbb    %ecx,%ebx
  8019eb:	89 d8                	mov    %ebx,%eax
  8019ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019f1:	d3 e0                	shl    %cl,%eax
  8019f3:	89 e9                	mov    %ebp,%ecx
  8019f5:	d3 ea                	shr    %cl,%edx
  8019f7:	09 d0                	or     %edx,%eax
  8019f9:	89 e9                	mov    %ebp,%ecx
  8019fb:	d3 eb                	shr    %cl,%ebx
  8019fd:	89 da                	mov    %ebx,%edx
  8019ff:	83 c4 1c             	add    $0x1c,%esp
  801a02:	5b                   	pop    %ebx
  801a03:	5e                   	pop    %esi
  801a04:	5f                   	pop    %edi
  801a05:	5d                   	pop    %ebp
  801a06:	c3                   	ret    
  801a07:	90                   	nop
  801a08:	89 fd                	mov    %edi,%ebp
  801a0a:	85 ff                	test   %edi,%edi
  801a0c:	75 0b                	jne    801a19 <__umoddi3+0xe9>
  801a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a13:	31 d2                	xor    %edx,%edx
  801a15:	f7 f7                	div    %edi
  801a17:	89 c5                	mov    %eax,%ebp
  801a19:	89 f0                	mov    %esi,%eax
  801a1b:	31 d2                	xor    %edx,%edx
  801a1d:	f7 f5                	div    %ebp
  801a1f:	89 c8                	mov    %ecx,%eax
  801a21:	f7 f5                	div    %ebp
  801a23:	89 d0                	mov    %edx,%eax
  801a25:	e9 44 ff ff ff       	jmp    80196e <__umoddi3+0x3e>
  801a2a:	66 90                	xchg   %ax,%ax
  801a2c:	89 c8                	mov    %ecx,%eax
  801a2e:	89 f2                	mov    %esi,%edx
  801a30:	83 c4 1c             	add    $0x1c,%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5f                   	pop    %edi
  801a36:	5d                   	pop    %ebp
  801a37:	c3                   	ret    
  801a38:	3b 04 24             	cmp    (%esp),%eax
  801a3b:	72 06                	jb     801a43 <__umoddi3+0x113>
  801a3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a41:	77 0f                	ja     801a52 <__umoddi3+0x122>
  801a43:	89 f2                	mov    %esi,%edx
  801a45:	29 f9                	sub    %edi,%ecx
  801a47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a4b:	89 14 24             	mov    %edx,(%esp)
  801a4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a52:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a56:	8b 14 24             	mov    (%esp),%edx
  801a59:	83 c4 1c             	add    $0x1c,%esp
  801a5c:	5b                   	pop    %ebx
  801a5d:	5e                   	pop    %esi
  801a5e:	5f                   	pop    %edi
  801a5f:	5d                   	pop    %ebp
  801a60:	c3                   	ret    
  801a61:	8d 76 00             	lea    0x0(%esi),%esi
  801a64:	2b 04 24             	sub    (%esp),%eax
  801a67:	19 fa                	sbb    %edi,%edx
  801a69:	89 d1                	mov    %edx,%ecx
  801a6b:	89 c6                	mov    %eax,%esi
  801a6d:	e9 71 ff ff ff       	jmp    8019e3 <__umoddi3+0xb3>
  801a72:	66 90                	xchg   %ax,%ax
  801a74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a78:	72 ea                	jb     801a64 <__umoddi3+0x134>
  801a7a:	89 d9                	mov    %ebx,%ecx
  801a7c:	e9 62 ff ff ff       	jmp    8019e3 <__umoddi3+0xb3>
