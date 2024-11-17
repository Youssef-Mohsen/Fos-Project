
obj/user/tst_syscalls_2_slave1:     file format elf32-i386


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
  800031:	e8 30 00 00 00       	call   800066 <libmain>
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
	//[1] NULL (0) address
	sys_allocate_user_mem(0,10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	6a 0a                	push   $0xa
  800043:	6a 00                	push   $0x0
  800045:	e8 b7 17 00 00       	call   801801 <sys_allocate_user_mem>
  80004a:	83 c4 10             	add    $0x10,%esp
	inctst();
  80004d:	e8 c9 15 00 00       	call   80161b <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800052:	83 ec 04             	sub    $0x4,%esp
  800055:	68 a0 1a 80 00       	push   $0x801aa0
  80005a:	6a 0a                	push   $0xa
  80005c:	68 22 1b 80 00       	push   $0x801b22
  800061:	e8 37 01 00 00       	call   80019d <_panic>

00800066 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800066:	55                   	push   %ebp
  800067:	89 e5                	mov    %esp,%ebp
  800069:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006c:	e8 6c 14 00 00       	call   8014dd <sys_getenvindex>
  800071:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800077:	89 d0                	mov    %edx,%eax
  800079:	c1 e0 02             	shl    $0x2,%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	01 c0                	add    %eax,%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	c1 e0 02             	shl    $0x2,%eax
  800085:	01 d0                	add    %edx,%eax
  800087:	01 c0                	add    %eax,%eax
  800089:	01 d0                	add    %edx,%eax
  80008b:	c1 e0 04             	shl    $0x4,%eax
  80008e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800093:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800098:	a1 04 30 80 00       	mov    0x803004,%eax
  80009d:	8a 40 20             	mov    0x20(%eax),%al
  8000a0:	84 c0                	test   %al,%al
  8000a2:	74 0d                	je     8000b1 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000a4:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a9:	83 c0 20             	add    $0x20,%eax
  8000ac:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b5:	7e 0a                	jle    8000c1 <libmain+0x5b>
		binaryname = argv[0];
  8000b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ba:	8b 00                	mov    (%eax),%eax
  8000bc:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c1:	83 ec 08             	sub    $0x8,%esp
  8000c4:	ff 75 0c             	pushl  0xc(%ebp)
  8000c7:	ff 75 08             	pushl  0x8(%ebp)
  8000ca:	e8 69 ff ff ff       	call   800038 <_main>
  8000cf:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000d2:	e8 8a 11 00 00       	call   801261 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	68 58 1b 80 00       	push   $0x801b58
  8000df:	e8 76 03 00 00       	call   80045a <cprintf>
  8000e4:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ec:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000fd:	83 ec 04             	sub    $0x4,%esp
  800100:	52                   	push   %edx
  800101:	50                   	push   %eax
  800102:	68 80 1b 80 00       	push   $0x801b80
  800107:	e8 4e 03 00 00       	call   80045a <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80010f:	a1 04 30 80 00       	mov    0x803004,%eax
  800114:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80011a:	a1 04 30 80 00       	mov    0x803004,%eax
  80011f:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800125:	a1 04 30 80 00       	mov    0x803004,%eax
  80012a:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800130:	51                   	push   %ecx
  800131:	52                   	push   %edx
  800132:	50                   	push   %eax
  800133:	68 a8 1b 80 00       	push   $0x801ba8
  800138:	e8 1d 03 00 00       	call   80045a <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800140:	a1 04 30 80 00       	mov    0x803004,%eax
  800145:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80014b:	83 ec 08             	sub    $0x8,%esp
  80014e:	50                   	push   %eax
  80014f:	68 00 1c 80 00       	push   $0x801c00
  800154:	e8 01 03 00 00       	call   80045a <cprintf>
  800159:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	68 58 1b 80 00       	push   $0x801b58
  800164:	e8 f1 02 00 00       	call   80045a <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80016c:	e8 0a 11 00 00       	call   80127b <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800171:	e8 19 00 00 00       	call   80018f <exit>
}
  800176:	90                   	nop
  800177:	c9                   	leave  
  800178:	c3                   	ret    

00800179 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	6a 00                	push   $0x0
  800184:	e8 20 13 00 00       	call   8014a9 <sys_destroy_env>
  800189:	83 c4 10             	add    $0x10,%esp
}
  80018c:	90                   	nop
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <exit>:

void
exit(void)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800195:	e8 75 13 00 00       	call   80150f <sys_exit_env>
}
  80019a:	90                   	nop
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    

0080019d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8001a6:	83 c0 04             	add    $0x4,%eax
  8001a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001ac:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001b1:	85 c0                	test   %eax,%eax
  8001b3:	74 16                	je     8001cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001b5:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8001ba:	83 ec 08             	sub    $0x8,%esp
  8001bd:	50                   	push   %eax
  8001be:	68 14 1c 80 00       	push   $0x801c14
  8001c3:	e8 92 02 00 00       	call   80045a <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001cb:	a1 00 30 80 00       	mov    0x803000,%eax
  8001d0:	ff 75 0c             	pushl  0xc(%ebp)
  8001d3:	ff 75 08             	pushl  0x8(%ebp)
  8001d6:	50                   	push   %eax
  8001d7:	68 19 1c 80 00       	push   $0x801c19
  8001dc:	e8 79 02 00 00       	call   80045a <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ed:	50                   	push   %eax
  8001ee:	e8 fc 01 00 00       	call   8003ef <vcprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	6a 00                	push   $0x0
  8001fb:	68 35 1c 80 00       	push   $0x801c35
  800200:	e8 ea 01 00 00       	call   8003ef <vcprintf>
  800205:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800208:	e8 82 ff ff ff       	call   80018f <exit>

	// should not return here
	while (1) ;
  80020d:	eb fe                	jmp    80020d <_panic+0x70>

0080020f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800215:	a1 04 30 80 00       	mov    0x803004,%eax
  80021a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800220:	8b 45 0c             	mov    0xc(%ebp),%eax
  800223:	39 c2                	cmp    %eax,%edx
  800225:	74 14                	je     80023b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800227:	83 ec 04             	sub    $0x4,%esp
  80022a:	68 38 1c 80 00       	push   $0x801c38
  80022f:	6a 26                	push   $0x26
  800231:	68 84 1c 80 00       	push   $0x801c84
  800236:	e8 62 ff ff ff       	call   80019d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80023b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800242:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800249:	e9 c5 00 00 00       	jmp    800313 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80024e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800251:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800258:	8b 45 08             	mov    0x8(%ebp),%eax
  80025b:	01 d0                	add    %edx,%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	85 c0                	test   %eax,%eax
  800261:	75 08                	jne    80026b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800263:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800266:	e9 a5 00 00 00       	jmp    800310 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80026b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800272:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800279:	eb 69                	jmp    8002e4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80027b:	a1 04 30 80 00       	mov    0x803004,%eax
  800280:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800286:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800289:	89 d0                	mov    %edx,%eax
  80028b:	01 c0                	add    %eax,%eax
  80028d:	01 d0                	add    %edx,%eax
  80028f:	c1 e0 03             	shl    $0x3,%eax
  800292:	01 c8                	add    %ecx,%eax
  800294:	8a 40 04             	mov    0x4(%eax),%al
  800297:	84 c0                	test   %al,%al
  800299:	75 46                	jne    8002e1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80029b:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a0:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8002a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002a9:	89 d0                	mov    %edx,%eax
  8002ab:	01 c0                	add    %eax,%eax
  8002ad:	01 d0                	add    %edx,%eax
  8002af:	c1 e0 03             	shl    $0x3,%eax
  8002b2:	01 c8                	add    %ecx,%eax
  8002b4:	8b 00                	mov    (%eax),%eax
  8002b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d0:	01 c8                	add    %ecx,%eax
  8002d2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002d4:	39 c2                	cmp    %eax,%edx
  8002d6:	75 09                	jne    8002e1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002d8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002df:	eb 15                	jmp    8002f6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e1:	ff 45 e8             	incl   -0x18(%ebp)
  8002e4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f2:	39 c2                	cmp    %eax,%edx
  8002f4:	77 85                	ja     80027b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002fa:	75 14                	jne    800310 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8002fc:	83 ec 04             	sub    $0x4,%esp
  8002ff:	68 90 1c 80 00       	push   $0x801c90
  800304:	6a 3a                	push   $0x3a
  800306:	68 84 1c 80 00       	push   $0x801c84
  80030b:	e8 8d fe ff ff       	call   80019d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800310:	ff 45 f0             	incl   -0x10(%ebp)
  800313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800316:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800319:	0f 8c 2f ff ff ff    	jl     80024e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80031f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800326:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80032d:	eb 26                	jmp    800355 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80032f:	a1 04 30 80 00       	mov    0x803004,%eax
  800334:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80033a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80033d:	89 d0                	mov    %edx,%eax
  80033f:	01 c0                	add    %eax,%eax
  800341:	01 d0                	add    %edx,%eax
  800343:	c1 e0 03             	shl    $0x3,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	8a 40 04             	mov    0x4(%eax),%al
  80034b:	3c 01                	cmp    $0x1,%al
  80034d:	75 03                	jne    800352 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80034f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800352:	ff 45 e0             	incl   -0x20(%ebp)
  800355:	a1 04 30 80 00       	mov    0x803004,%eax
  80035a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800360:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800363:	39 c2                	cmp    %eax,%edx
  800365:	77 c8                	ja     80032f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80036d:	74 14                	je     800383 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	68 e4 1c 80 00       	push   $0x801ce4
  800377:	6a 44                	push   $0x44
  800379:	68 84 1c 80 00       	push   $0x801c84
  80037e:	e8 1a fe ff ff       	call   80019d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800383:	90                   	nop
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	8d 48 01             	lea    0x1(%eax),%ecx
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 0a                	mov    %ecx,(%edx)
  800399:	8b 55 08             	mov    0x8(%ebp),%edx
  80039c:	88 d1                	mov    %dl,%cl
  80039e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	75 2c                	jne    8003dd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b1:	a0 08 30 80 00       	mov    0x803008,%al
  8003b6:	0f b6 c0             	movzbl %al,%eax
  8003b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bc:	8b 12                	mov    (%edx),%edx
  8003be:	89 d1                	mov    %edx,%ecx
  8003c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c3:	83 c2 08             	add    $0x8,%edx
  8003c6:	83 ec 04             	sub    $0x4,%esp
  8003c9:	50                   	push   %eax
  8003ca:	51                   	push   %ecx
  8003cb:	52                   	push   %edx
  8003cc:	e8 4e 0e 00 00       	call   80121f <sys_cputs>
  8003d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	8b 40 04             	mov    0x4(%eax),%eax
  8003e3:	8d 50 01             	lea    0x1(%eax),%edx
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ec:	90                   	nop
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ff:	00 00 00 
	b.cnt = 0;
  800402:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800409:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 08             	pushl  0x8(%ebp)
  800412:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800418:	50                   	push   %eax
  800419:	68 86 03 80 00       	push   $0x800386
  80041e:	e8 11 02 00 00       	call   800634 <vprintfmt>
  800423:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800426:	a0 08 30 80 00       	mov    0x803008,%al
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	50                   	push   %eax
  800438:	52                   	push   %edx
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	83 c0 08             	add    $0x8,%eax
  800442:	50                   	push   %eax
  800443:	e8 d7 0d 00 00       	call   80121f <sys_cputs>
  800448:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044b:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800452:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800460:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800467:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 f4             	pushl  -0xc(%ebp)
  800476:	50                   	push   %eax
  800477:	e8 73 ff ff ff       	call   8003ef <vcprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80048d:	e8 cf 0d 00 00       	call   801261 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800492:	8d 45 0c             	lea    0xc(%ebp),%eax
  800495:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a1:	50                   	push   %eax
  8004a2:	e8 48 ff ff ff       	call   8003ef <vcprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004ad:	e8 c9 0d 00 00       	call   80127b <sys_unlock_cons>
	return cnt;
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	53                   	push   %ebx
  8004bb:	83 ec 14             	sub    $0x14,%esp
  8004be:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8004cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d5:	77 55                	ja     80052c <printnum+0x75>
  8004d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004da:	72 05                	jb     8004e1 <printnum+0x2a>
  8004dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004df:	77 4b                	ja     80052c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ef:	52                   	push   %edx
  8004f0:	50                   	push   %eax
  8004f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f7:	e8 24 13 00 00       	call   801820 <__udivdi3>
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	ff 75 20             	pushl  0x20(%ebp)
  800505:	53                   	push   %ebx
  800506:	ff 75 18             	pushl  0x18(%ebp)
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 a1 ff ff ff       	call   8004b7 <printnum>
  800516:	83 c4 20             	add    $0x20,%esp
  800519:	eb 1a                	jmp    800535 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	ff 75 0c             	pushl  0xc(%ebp)
  800521:	ff 75 20             	pushl  0x20(%ebp)
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	ff d0                	call   *%eax
  800529:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052c:	ff 4d 1c             	decl   0x1c(%ebp)
  80052f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800533:	7f e6                	jg     80051b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800535:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800538:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800543:	53                   	push   %ebx
  800544:	51                   	push   %ecx
  800545:	52                   	push   %edx
  800546:	50                   	push   %eax
  800547:	e8 e4 13 00 00       	call   801930 <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 54 1f 80 00       	add    $0x801f54,%eax
  800554:	8a 00                	mov    (%eax),%al
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	50                   	push   %eax
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	ff d0                	call   *%eax
  800565:	83 c4 10             	add    $0x10,%esp
}
  800568:	90                   	nop
  800569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800571:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800575:	7e 1c                	jle    800593 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	8d 50 08             	lea    0x8(%eax),%edx
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	89 10                	mov    %edx,(%eax)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	83 e8 08             	sub    $0x8,%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	eb 40                	jmp    8005d3 <getuint+0x65>
	else if (lflag)
  800593:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800597:	74 1e                	je     8005b7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	8d 50 04             	lea    0x4(%eax),%edx
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 10                	mov    %edx,(%eax)
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	83 e8 04             	sub    $0x4,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	eb 1c                	jmp    8005d3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	8d 50 04             	lea    0x4(%eax),%edx
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	89 10                	mov    %edx,(%eax)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 e8 04             	sub    $0x4,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dc:	7e 1c                	jle    8005fa <getint+0x25>
		return va_arg(*ap, long long);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	8d 50 08             	lea    0x8(%eax),%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	89 10                	mov    %edx,(%eax)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	83 e8 08             	sub    $0x8,%eax
  8005f3:	8b 50 04             	mov    0x4(%eax),%edx
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	eb 38                	jmp    800632 <getint+0x5d>
	else if (lflag)
  8005fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005fe:	74 1a                	je     80061a <getint+0x45>
		return va_arg(*ap, long);
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	8d 50 04             	lea    0x4(%eax),%edx
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	89 10                	mov    %edx,(%eax)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	83 e8 04             	sub    $0x4,%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	99                   	cltd   
  800618:	eb 18                	jmp    800632 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	8d 50 04             	lea    0x4(%eax),%edx
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	89 10                	mov    %edx,(%eax)
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	83 e8 04             	sub    $0x4,%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	99                   	cltd   
}
  800632:	5d                   	pop    %ebp
  800633:	c3                   	ret    

00800634 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	56                   	push   %esi
  800638:	53                   	push   %ebx
  800639:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063c:	eb 17                	jmp    800655 <vprintfmt+0x21>
			if (ch == '\0')
  80063e:	85 db                	test   %ebx,%ebx
  800640:	0f 84 c1 03 00 00    	je     800a07 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	53                   	push   %ebx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	ff d0                	call   *%eax
  800652:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	8b 45 10             	mov    0x10(%ebp),%eax
  800658:	8d 50 01             	lea    0x1(%eax),%edx
  80065b:	89 55 10             	mov    %edx,0x10(%ebp)
  80065e:	8a 00                	mov    (%eax),%al
  800660:	0f b6 d8             	movzbl %al,%ebx
  800663:	83 fb 25             	cmp    $0x25,%ebx
  800666:	75 d6                	jne    80063e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800668:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800673:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800681:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800688:	8b 45 10             	mov    0x10(%ebp),%eax
  80068b:	8d 50 01             	lea    0x1(%eax),%edx
  80068e:	89 55 10             	mov    %edx,0x10(%ebp)
  800691:	8a 00                	mov    (%eax),%al
  800693:	0f b6 d8             	movzbl %al,%ebx
  800696:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800699:	83 f8 5b             	cmp    $0x5b,%eax
  80069c:	0f 87 3d 03 00 00    	ja     8009df <vprintfmt+0x3ab>
  8006a2:	8b 04 85 78 1f 80 00 	mov    0x801f78(,%eax,4),%eax
  8006a9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006af:	eb d7                	jmp    800688 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b5:	eb d1                	jmp    800688 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c1:	89 d0                	mov    %edx,%eax
  8006c3:	c1 e0 02             	shl    $0x2,%eax
  8006c6:	01 d0                	add    %edx,%eax
  8006c8:	01 c0                	add    %eax,%eax
  8006ca:	01 d8                	add    %ebx,%eax
  8006cc:	83 e8 30             	sub    $0x30,%eax
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d5:	8a 00                	mov    (%eax),%al
  8006d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006da:	83 fb 2f             	cmp    $0x2f,%ebx
  8006dd:	7e 3e                	jle    80071d <vprintfmt+0xe9>
  8006df:	83 fb 39             	cmp    $0x39,%ebx
  8006e2:	7f 39                	jg     80071d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e7:	eb d5                	jmp    8006be <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	83 c0 04             	add    $0x4,%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	83 e8 04             	sub    $0x4,%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006fd:	eb 1f                	jmp    80071e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	79 83                	jns    800688 <vprintfmt+0x54>
				width = 0;
  800705:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070c:	e9 77 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800711:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800718:	e9 6b ff ff ff       	jmp    800688 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80071e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800722:	0f 89 60 ff ff ff    	jns    800688 <vprintfmt+0x54>
				width = precision, precision = -1;
  800728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800735:	e9 4e ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073d:	e9 46 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	83 c0 04             	add    $0x4,%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 e8 04             	sub    $0x4,%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
			break;
  800762:	e9 9b 02 00 00       	jmp    800a02 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 c0 04             	add    $0x4,%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800778:	85 db                	test   %ebx,%ebx
  80077a:	79 02                	jns    80077e <vprintfmt+0x14a>
				err = -err;
  80077c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077e:	83 fb 64             	cmp    $0x64,%ebx
  800781:	7f 0b                	jg     80078e <vprintfmt+0x15a>
  800783:	8b 34 9d c0 1d 80 00 	mov    0x801dc0(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 65 1f 80 00       	push   $0x801f65
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	ff 75 08             	pushl  0x8(%ebp)
  80079a:	e8 70 02 00 00       	call   800a0f <printfmt>
  80079f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a2:	e9 5b 02 00 00       	jmp    800a02 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a7:	56                   	push   %esi
  8007a8:	68 6e 1f 80 00       	push   $0x801f6e
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 57 02 00 00       	call   800a0f <printfmt>
  8007b8:	83 c4 10             	add    $0x10,%esp
			break;
  8007bb:	e9 42 02 00 00       	jmp    800a02 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 e8 04             	sub    $0x4,%eax
  8007cf:	8b 30                	mov    (%eax),%esi
  8007d1:	85 f6                	test   %esi,%esi
  8007d3:	75 05                	jne    8007da <vprintfmt+0x1a6>
				p = "(null)";
  8007d5:	be 71 1f 80 00       	mov    $0x801f71,%esi
			if (width > 0 && padc != '-')
  8007da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007de:	7e 6d                	jle    80084d <vprintfmt+0x219>
  8007e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e4:	74 67                	je     80084d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	50                   	push   %eax
  8007ed:	56                   	push   %esi
  8007ee:	e8 1e 03 00 00       	call   800b11 <strnlen>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f9:	eb 16                	jmp    800811 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	50                   	push   %eax
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080e:	ff 4d e4             	decl   -0x1c(%ebp)
  800811:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800815:	7f e4                	jg     8007fb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800817:	eb 34                	jmp    80084d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800819:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081d:	74 1c                	je     80083b <vprintfmt+0x207>
  80081f:	83 fb 1f             	cmp    $0x1f,%ebx
  800822:	7e 05                	jle    800829 <vprintfmt+0x1f5>
  800824:	83 fb 7e             	cmp    $0x7e,%ebx
  800827:	7e 12                	jle    80083b <vprintfmt+0x207>
					putch('?', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 3f                	push   $0x3f
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	eb 0f                	jmp    80084a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	53                   	push   %ebx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084a:	ff 4d e4             	decl   -0x1c(%ebp)
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 70 01             	lea    0x1(%eax),%esi
  800852:	8a 00                	mov    (%eax),%al
  800854:	0f be d8             	movsbl %al,%ebx
  800857:	85 db                	test   %ebx,%ebx
  800859:	74 24                	je     80087f <vprintfmt+0x24b>
  80085b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085f:	78 b8                	js     800819 <vprintfmt+0x1e5>
  800861:	ff 4d e0             	decl   -0x20(%ebp)
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	79 af                	jns    800819 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086a:	eb 13                	jmp    80087f <vprintfmt+0x24b>
				putch(' ', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	6a 20                	push   $0x20
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087c:	ff 4d e4             	decl   -0x1c(%ebp)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	7f e7                	jg     80086c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800885:	e9 78 01 00 00       	jmp    800a02 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 e8             	pushl  -0x18(%ebp)
  800890:	8d 45 14             	lea    0x14(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	e8 3c fd ff ff       	call   8005d5 <getint>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	79 23                	jns    8008cf <vprintfmt+0x29b>
				putch('-', putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	6a 2d                	push   $0x2d
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c2:	f7 d8                	neg    %eax
  8008c4:	83 d2 00             	adc    $0x0,%edx
  8008c7:	f7 da                	neg    %edx
  8008c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d6:	e9 bc 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	e8 84 fc ff ff       	call   80056e <getuint>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fa:	e9 98 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	6a 58                	push   $0x58
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	6a 58                	push   $0x58
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	ff d0                	call   *%eax
  80091c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	6a 58                	push   $0x58
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
			break;
  80092f:	e9 ce 00 00 00       	jmp    800a02 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	6a 30                	push   $0x30
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 78                	push   $0x78
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 c0 04             	add    $0x4,%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	83 e8 04             	sub    $0x4,%eax
  800963:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80096f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800976:	eb 1f                	jmp    800997 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 e8             	pushl  -0x18(%ebp)
  80097e:	8d 45 14             	lea    0x14(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	e8 e7 fb ff ff       	call   80056e <getuint>
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800990:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800997:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	52                   	push   %edx
  8009a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 00 fb ff ff       	call   8004b7 <printnum>
  8009b7:	83 c4 20             	add    $0x20,%esp
			break;
  8009ba:	eb 46                	jmp    800a02 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
			break;
  8009cb:	eb 35                	jmp    800a02 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009cd:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009d4:	eb 2c                	jmp    800a02 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009d6:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009dd:	eb 23                	jmp    800a02 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 25                	push   $0x25
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009ef:	ff 4d 10             	decl   0x10(%ebp)
  8009f2:	eb 03                	jmp    8009f7 <vprintfmt+0x3c3>
  8009f4:	ff 4d 10             	decl   0x10(%ebp)
  8009f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fa:	48                   	dec    %eax
  8009fb:	8a 00                	mov    (%eax),%al
  8009fd:	3c 25                	cmp    $0x25,%al
  8009ff:	75 f3                	jne    8009f4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a01:	90                   	nop
		}
	}
  800a02:	e9 35 fc ff ff       	jmp    80063c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a07:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a0b:	5b                   	pop    %ebx
  800a0c:	5e                   	pop    %esi
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a15:	8d 45 10             	lea    0x10(%ebp),%eax
  800a18:	83 c0 04             	add    $0x4,%eax
  800a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	ff 75 f4             	pushl  -0xc(%ebp)
  800a24:	50                   	push   %eax
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	ff 75 08             	pushl  0x8(%ebp)
  800a2b:	e8 04 fc ff ff       	call   800634 <vprintfmt>
  800a30:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a33:	90                   	nop
  800a34:	c9                   	leave  
  800a35:	c3                   	ret    

00800a36 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	8b 40 08             	mov    0x8(%eax),%eax
  800a3f:	8d 50 01             	lea    0x1(%eax),%edx
  800a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a45:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4b:	8b 10                	mov    (%eax),%edx
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	8b 40 04             	mov    0x4(%eax),%eax
  800a53:	39 c2                	cmp    %eax,%edx
  800a55:	73 12                	jae    800a69 <sprintputch+0x33>
		*b->buf++ = ch;
  800a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5a:	8b 00                	mov    (%eax),%eax
  800a5c:	8d 48 01             	lea    0x1(%eax),%ecx
  800a5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a62:	89 0a                	mov    %ecx,(%edx)
  800a64:	8b 55 08             	mov    0x8(%ebp),%edx
  800a67:	88 10                	mov    %dl,(%eax)
}
  800a69:	90                   	nop
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	01 d0                	add    %edx,%eax
  800a83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a91:	74 06                	je     800a99 <vsnprintf+0x2d>
  800a93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a97:	7f 07                	jg     800aa0 <vsnprintf+0x34>
		return -E_INVAL;
  800a99:	b8 03 00 00 00       	mov    $0x3,%eax
  800a9e:	eb 20                	jmp    800ac0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa0:	ff 75 14             	pushl  0x14(%ebp)
  800aa3:	ff 75 10             	pushl  0x10(%ebp)
  800aa6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aa9:	50                   	push   %eax
  800aaa:	68 36 0a 80 00       	push   $0x800a36
  800aaf:	e8 80 fb ff ff       	call   800634 <vprintfmt>
  800ab4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac0:	c9                   	leave  
  800ac1:	c3                   	ret    

00800ac2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ac8:	8d 45 10             	lea    0x10(%ebp),%eax
  800acb:	83 c0 04             	add    $0x4,%eax
  800ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ad1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	ff 75 08             	pushl  0x8(%ebp)
  800ade:	e8 89 ff ff ff       	call   800a6c <vsnprintf>
  800ae3:	83 c4 10             	add    $0x10,%esp
  800ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800af4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800afb:	eb 06                	jmp    800b03 <strlen+0x15>
		n++;
  800afd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b00:	ff 45 08             	incl   0x8(%ebp)
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	8a 00                	mov    (%eax),%al
  800b08:	84 c0                	test   %al,%al
  800b0a:	75 f1                	jne    800afd <strlen+0xf>
		n++;
	return n;
  800b0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b1e:	eb 09                	jmp    800b29 <strnlen+0x18>
		n++;
  800b20:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b23:	ff 45 08             	incl   0x8(%ebp)
  800b26:	ff 4d 0c             	decl   0xc(%ebp)
  800b29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2d:	74 09                	je     800b38 <strnlen+0x27>
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8a 00                	mov    (%eax),%al
  800b34:	84 c0                	test   %al,%al
  800b36:	75 e8                	jne    800b20 <strnlen+0xf>
		n++;
	return n;
  800b38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    

00800b3d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b49:	90                   	nop
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	8d 50 01             	lea    0x1(%eax),%edx
  800b50:	89 55 08             	mov    %edx,0x8(%ebp)
  800b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b56:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b59:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b5c:	8a 12                	mov    (%edx),%dl
  800b5e:	88 10                	mov    %dl,(%eax)
  800b60:	8a 00                	mov    (%eax),%al
  800b62:	84 c0                	test   %al,%al
  800b64:	75 e4                	jne    800b4a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b69:	c9                   	leave  
  800b6a:	c3                   	ret    

00800b6b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b7e:	eb 1f                	jmp    800b9f <strncpy+0x34>
		*dst++ = *src;
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8d 50 01             	lea    0x1(%eax),%edx
  800b86:	89 55 08             	mov    %edx,0x8(%ebp)
  800b89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8c:	8a 12                	mov    (%edx),%dl
  800b8e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b93:	8a 00                	mov    (%eax),%al
  800b95:	84 c0                	test   %al,%al
  800b97:	74 03                	je     800b9c <strncpy+0x31>
			src++;
  800b99:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b9c:	ff 45 fc             	incl   -0x4(%ebp)
  800b9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ba5:	72 d9                	jb     800b80 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ba7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bbc:	74 30                	je     800bee <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bbe:	eb 16                	jmp    800bd6 <strlcpy+0x2a>
			*dst++ = *src++;
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8d 50 01             	lea    0x1(%eax),%edx
  800bc6:	89 55 08             	mov    %edx,0x8(%ebp)
  800bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bcf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd2:	8a 12                	mov    (%edx),%dl
  800bd4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bd6:	ff 4d 10             	decl   0x10(%ebp)
  800bd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bdd:	74 09                	je     800be8 <strlcpy+0x3c>
  800bdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	84 c0                	test   %al,%al
  800be6:	75 d8                	jne    800bc0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bee:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf4:	29 c2                	sub    %eax,%edx
  800bf6:	89 d0                	mov    %edx,%eax
}
  800bf8:	c9                   	leave  
  800bf9:	c3                   	ret    

00800bfa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bfd:	eb 06                	jmp    800c05 <strcmp+0xb>
		p++, q++;
  800bff:	ff 45 08             	incl   0x8(%ebp)
  800c02:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8a 00                	mov    (%eax),%al
  800c0a:	84 c0                	test   %al,%al
  800c0c:	74 0e                	je     800c1c <strcmp+0x22>
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8a 10                	mov    (%eax),%dl
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	38 c2                	cmp    %al,%dl
  800c1a:	74 e3                	je     800bff <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	0f b6 d0             	movzbl %al,%edx
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	0f b6 c0             	movzbl %al,%eax
  800c2c:	29 c2                	sub    %eax,%edx
  800c2e:	89 d0                	mov    %edx,%eax
}
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c35:	eb 09                	jmp    800c40 <strncmp+0xe>
		n--, p++, q++;
  800c37:	ff 4d 10             	decl   0x10(%ebp)
  800c3a:	ff 45 08             	incl   0x8(%ebp)
  800c3d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c44:	74 17                	je     800c5d <strncmp+0x2b>
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	84 c0                	test   %al,%al
  800c4d:	74 0e                	je     800c5d <strncmp+0x2b>
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8a 10                	mov    (%eax),%dl
  800c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	38 c2                	cmp    %al,%dl
  800c5b:	74 da                	je     800c37 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c61:	75 07                	jne    800c6a <strncmp+0x38>
		return 0;
  800c63:	b8 00 00 00 00       	mov    $0x0,%eax
  800c68:	eb 14                	jmp    800c7e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	0f b6 d0             	movzbl %al,%edx
  800c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c75:	8a 00                	mov    (%eax),%al
  800c77:	0f b6 c0             	movzbl %al,%eax
  800c7a:	29 c2                	sub    %eax,%edx
  800c7c:	89 d0                	mov    %edx,%eax
}
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	83 ec 04             	sub    $0x4,%esp
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c8c:	eb 12                	jmp    800ca0 <strchr+0x20>
		if (*s == c)
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c96:	75 05                	jne    800c9d <strchr+0x1d>
			return (char *) s;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	eb 11                	jmp    800cae <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c9d:	ff 45 08             	incl   0x8(%ebp)
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	8a 00                	mov    (%eax),%al
  800ca5:	84 c0                	test   %al,%al
  800ca7:	75 e5                	jne    800c8e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cbc:	eb 0d                	jmp    800ccb <strfind+0x1b>
		if (*s == c)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cc6:	74 0e                	je     800cd6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cc8:	ff 45 08             	incl   0x8(%ebp)
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	75 ea                	jne    800cbe <strfind+0xe>
  800cd4:	eb 01                	jmp    800cd7 <strfind+0x27>
		if (*s == c)
			break;
  800cd6:	90                   	nop
	return (char *) s;
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cee:	eb 0e                	jmp    800cfe <memset+0x22>
		*p++ = c;
  800cf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf3:	8d 50 01             	lea    0x1(%eax),%edx
  800cf6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfc:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cfe:	ff 4d f8             	decl   -0x8(%ebp)
  800d01:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d05:	79 e9                	jns    800cf0 <memset+0x14>
		*p++ = c;

	return v;
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d0a:	c9                   	leave  
  800d0b:	c3                   	ret    

00800d0c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d1e:	eb 16                	jmp    800d36 <memcpy+0x2a>
		*d++ = *s++;
  800d20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d23:	8d 50 01             	lea    0x1(%eax),%edx
  800d26:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d2c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d32:	8a 12                	mov    (%edx),%dl
  800d34:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d36:	8b 45 10             	mov    0x10(%ebp),%eax
  800d39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	75 dd                	jne    800d20 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d60:	73 50                	jae    800db2 <memmove+0x6a>
  800d62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d65:	8b 45 10             	mov    0x10(%ebp),%eax
  800d68:	01 d0                	add    %edx,%eax
  800d6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6d:	76 43                	jbe    800db2 <memmove+0x6a>
		s += n;
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d75:	8b 45 10             	mov    0x10(%ebp),%eax
  800d78:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d7b:	eb 10                	jmp    800d8d <memmove+0x45>
			*--d = *--s;
  800d7d:	ff 4d f8             	decl   -0x8(%ebp)
  800d80:	ff 4d fc             	decl   -0x4(%ebp)
  800d83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d86:	8a 10                	mov    (%eax),%dl
  800d88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d90:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d93:	89 55 10             	mov    %edx,0x10(%ebp)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	75 e3                	jne    800d7d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d9a:	eb 23                	jmp    800dbf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9f:	8d 50 01             	lea    0x1(%eax),%edx
  800da2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800da5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dab:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dae:	8a 12                	mov    (%edx),%dl
  800db0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dbb:	85 c0                	test   %eax,%eax
  800dbd:	75 dd                	jne    800d9c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc2:	c9                   	leave  
  800dc3:	c3                   	ret    

00800dc4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dd6:	eb 2a                	jmp    800e02 <memcmp+0x3e>
		if (*s1 != *s2)
  800dd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddb:	8a 10                	mov    (%eax),%dl
  800ddd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	38 c2                	cmp    %al,%dl
  800de4:	74 16                	je     800dfc <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	0f b6 d0             	movzbl %al,%edx
  800dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	0f b6 c0             	movzbl %al,%eax
  800df6:	29 c2                	sub    %eax,%edx
  800df8:	89 d0                	mov    %edx,%eax
  800dfa:	eb 18                	jmp    800e14 <memcmp+0x50>
		s1++, s2++;
  800dfc:	ff 45 fc             	incl   -0x4(%ebp)
  800dff:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e02:	8b 45 10             	mov    0x10(%ebp),%eax
  800e05:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e08:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	75 c9                	jne    800dd8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e14:	c9                   	leave  
  800e15:	c3                   	ret    

00800e16 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	01 d0                	add    %edx,%eax
  800e24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e27:	eb 15                	jmp    800e3e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f b6 d0             	movzbl %al,%edx
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	0f b6 c0             	movzbl %al,%eax
  800e37:	39 c2                	cmp    %eax,%edx
  800e39:	74 0d                	je     800e48 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e44:	72 e3                	jb     800e29 <memfind+0x13>
  800e46:	eb 01                	jmp    800e49 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e48:	90                   	nop
	return (void *) s;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e5b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e62:	eb 03                	jmp    800e67 <strtol+0x19>
		s++;
  800e64:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 20                	cmp    $0x20,%al
  800e6e:	74 f4                	je     800e64 <strtol+0x16>
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3c 09                	cmp    $0x9,%al
  800e77:	74 eb                	je     800e64 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	3c 2b                	cmp    $0x2b,%al
  800e80:	75 05                	jne    800e87 <strtol+0x39>
		s++;
  800e82:	ff 45 08             	incl   0x8(%ebp)
  800e85:	eb 13                	jmp    800e9a <strtol+0x4c>
	else if (*s == '-')
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	3c 2d                	cmp    $0x2d,%al
  800e8e:	75 0a                	jne    800e9a <strtol+0x4c>
		s++, neg = 1;
  800e90:	ff 45 08             	incl   0x8(%ebp)
  800e93:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9e:	74 06                	je     800ea6 <strtol+0x58>
  800ea0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ea4:	75 20                	jne    800ec6 <strtol+0x78>
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	3c 30                	cmp    $0x30,%al
  800ead:	75 17                	jne    800ec6 <strtol+0x78>
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	40                   	inc    %eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	3c 78                	cmp    $0x78,%al
  800eb7:	75 0d                	jne    800ec6 <strtol+0x78>
		s += 2, base = 16;
  800eb9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ebd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ec4:	eb 28                	jmp    800eee <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ec6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eca:	75 15                	jne    800ee1 <strtol+0x93>
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	3c 30                	cmp    $0x30,%al
  800ed3:	75 0c                	jne    800ee1 <strtol+0x93>
		s++, base = 8;
  800ed5:	ff 45 08             	incl   0x8(%ebp)
  800ed8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800edf:	eb 0d                	jmp    800eee <strtol+0xa0>
	else if (base == 0)
  800ee1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee5:	75 07                	jne    800eee <strtol+0xa0>
		base = 10;
  800ee7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	3c 2f                	cmp    $0x2f,%al
  800ef5:	7e 19                	jle    800f10 <strtol+0xc2>
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	3c 39                	cmp    $0x39,%al
  800efe:	7f 10                	jg     800f10 <strtol+0xc2>
			dig = *s - '0';
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	0f be c0             	movsbl %al,%eax
  800f08:	83 e8 30             	sub    $0x30,%eax
  800f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f0e:	eb 42                	jmp    800f52 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	3c 60                	cmp    $0x60,%al
  800f17:	7e 19                	jle    800f32 <strtol+0xe4>
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	3c 7a                	cmp    $0x7a,%al
  800f20:	7f 10                	jg     800f32 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	0f be c0             	movsbl %al,%eax
  800f2a:	83 e8 57             	sub    $0x57,%eax
  800f2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f30:	eb 20                	jmp    800f52 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 40                	cmp    $0x40,%al
  800f39:	7e 39                	jle    800f74 <strtol+0x126>
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	3c 5a                	cmp    $0x5a,%al
  800f42:	7f 30                	jg     800f74 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	0f be c0             	movsbl %al,%eax
  800f4c:	83 e8 37             	sub    $0x37,%eax
  800f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f55:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f58:	7d 19                	jge    800f73 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f60:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f64:	89 c2                	mov    %eax,%edx
  800f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
  800f6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f6e:	e9 7b ff ff ff       	jmp    800eee <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f73:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f78:	74 08                	je     800f82 <strtol+0x134>
		*endptr = (char *) s;
  800f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f82:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f86:	74 07                	je     800f8f <strtol+0x141>
  800f88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8b:	f7 d8                	neg    %eax
  800f8d:	eb 03                	jmp    800f92 <strtol+0x144>
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    

00800f94 <ltostr>:

void
ltostr(long value, char *str)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fa1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fa8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fac:	79 13                	jns    800fc1 <ltostr+0x2d>
	{
		neg = 1;
  800fae:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fbb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fbe:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fc9:	99                   	cltd   
  800fca:	f7 f9                	idiv   %ecx
  800fcc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd2:	8d 50 01             	lea    0x1(%eax),%edx
  800fd5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd8:	89 c2                	mov    %eax,%edx
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	01 d0                	add    %edx,%eax
  800fdf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fe2:	83 c2 30             	add    $0x30,%edx
  800fe5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fe7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fea:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fef:	f7 e9                	imul   %ecx
  800ff1:	c1 fa 02             	sar    $0x2,%edx
  800ff4:	89 c8                	mov    %ecx,%eax
  800ff6:	c1 f8 1f             	sar    $0x1f,%eax
  800ff9:	29 c2                	sub    %eax,%edx
  800ffb:	89 d0                	mov    %edx,%eax
  800ffd:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801000:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801004:	75 bb                	jne    800fc1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80100d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801010:	48                   	dec    %eax
  801011:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801014:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801018:	74 3d                	je     801057 <ltostr+0xc3>
		start = 1 ;
  80101a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801021:	eb 34                	jmp    801057 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 c2                	add    %eax,%edx
  801038:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80103b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103e:	01 c8                	add    %ecx,%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801044:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	01 c2                	add    %eax,%edx
  80104c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80104f:	88 02                	mov    %al,(%edx)
		start++ ;
  801051:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801054:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80105d:	7c c4                	jl     801023 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80105f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	01 d0                	add    %edx,%eax
  801067:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80106a:	90                   	nop
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

0080106d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801073:	ff 75 08             	pushl  0x8(%ebp)
  801076:	e8 73 fa ff ff       	call   800aee <strlen>
  80107b:	83 c4 04             	add    $0x4,%esp
  80107e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801081:	ff 75 0c             	pushl  0xc(%ebp)
  801084:	e8 65 fa ff ff       	call   800aee <strlen>
  801089:	83 c4 04             	add    $0x4,%esp
  80108c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80108f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109d:	eb 17                	jmp    8010b6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80109f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a5:	01 c2                	add    %eax,%edx
  8010a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	01 c8                	add    %ecx,%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010b3:	ff 45 fc             	incl   -0x4(%ebp)
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010bc:	7c e1                	jl     80109f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010cc:	eb 1f                	jmp    8010ed <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d1:	8d 50 01             	lea    0x1(%eax),%edx
  8010d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010d7:	89 c2                	mov    %eax,%edx
  8010d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010dc:	01 c2                	add    %eax,%edx
  8010de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	01 c8                	add    %ecx,%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010ea:	ff 45 f8             	incl   -0x8(%ebp)
  8010ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f3:	7c d9                	jl     8010ce <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fb:	01 d0                	add    %edx,%eax
  8010fd:	c6 00 00             	movb   $0x0,(%eax)
}
  801100:	90                   	nop
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801106:	8b 45 14             	mov    0x14(%ebp),%eax
  801109:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80110f:	8b 45 14             	mov    0x14(%ebp),%eax
  801112:	8b 00                	mov    (%eax),%eax
  801114:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80111b:	8b 45 10             	mov    0x10(%ebp),%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801126:	eb 0c                	jmp    801134 <strsplit+0x31>
			*string++ = 0;
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8d 50 01             	lea    0x1(%eax),%edx
  80112e:	89 55 08             	mov    %edx,0x8(%ebp)
  801131:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	84 c0                	test   %al,%al
  80113b:	74 18                	je     801155 <strsplit+0x52>
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	0f be c0             	movsbl %al,%eax
  801145:	50                   	push   %eax
  801146:	ff 75 0c             	pushl  0xc(%ebp)
  801149:	e8 32 fb ff ff       	call   800c80 <strchr>
  80114e:	83 c4 08             	add    $0x8,%esp
  801151:	85 c0                	test   %eax,%eax
  801153:	75 d3                	jne    801128 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	84 c0                	test   %al,%al
  80115c:	74 5a                	je     8011b8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80115e:	8b 45 14             	mov    0x14(%ebp),%eax
  801161:	8b 00                	mov    (%eax),%eax
  801163:	83 f8 0f             	cmp    $0xf,%eax
  801166:	75 07                	jne    80116f <strsplit+0x6c>
		{
			return 0;
  801168:	b8 00 00 00 00       	mov    $0x0,%eax
  80116d:	eb 66                	jmp    8011d5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80116f:	8b 45 14             	mov    0x14(%ebp),%eax
  801172:	8b 00                	mov    (%eax),%eax
  801174:	8d 48 01             	lea    0x1(%eax),%ecx
  801177:	8b 55 14             	mov    0x14(%ebp),%edx
  80117a:	89 0a                	mov    %ecx,(%edx)
  80117c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801183:	8b 45 10             	mov    0x10(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80118d:	eb 03                	jmp    801192 <strsplit+0x8f>
			string++;
  80118f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	84 c0                	test   %al,%al
  801199:	74 8b                	je     801126 <strsplit+0x23>
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f be c0             	movsbl %al,%eax
  8011a3:	50                   	push   %eax
  8011a4:	ff 75 0c             	pushl  0xc(%ebp)
  8011a7:	e8 d4 fa ff ff       	call   800c80 <strchr>
  8011ac:	83 c4 08             	add    $0x8,%esp
  8011af:	85 c0                	test   %eax,%eax
  8011b1:	74 dc                	je     80118f <strsplit+0x8c>
			string++;
	}
  8011b3:	e9 6e ff ff ff       	jmp    801126 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011b8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bc:	8b 00                	mov    (%eax),%eax
  8011be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011dd:	83 ec 04             	sub    $0x4,%esp
  8011e0:	68 e8 20 80 00       	push   $0x8020e8
  8011e5:	68 3f 01 00 00       	push   $0x13f
  8011ea:	68 0a 21 80 00       	push   $0x80210a
  8011ef:	e8 a9 ef ff ff       	call   80019d <_panic>

008011f4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	57                   	push   %edi
  8011f8:	56                   	push   %esi
  8011f9:	53                   	push   %ebx
  8011fa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8b 55 0c             	mov    0xc(%ebp),%edx
  801203:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801206:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801209:	8b 7d 18             	mov    0x18(%ebp),%edi
  80120c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80120f:	cd 30                	int    $0x30
  801211:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801214:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801217:	83 c4 10             	add    $0x10,%esp
  80121a:	5b                   	pop    %ebx
  80121b:	5e                   	pop    %esi
  80121c:	5f                   	pop    %edi
  80121d:	5d                   	pop    %ebp
  80121e:	c3                   	ret    

0080121f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	83 ec 04             	sub    $0x4,%esp
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80122b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	52                   	push   %edx
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	50                   	push   %eax
  80123b:	6a 00                	push   $0x0
  80123d:	e8 b2 ff ff ff       	call   8011f4 <syscall>
  801242:	83 c4 18             	add    $0x18,%esp
}
  801245:	90                   	nop
  801246:	c9                   	leave  
  801247:	c3                   	ret    

00801248 <sys_cgetc>:

int
sys_cgetc(void)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 02                	push   $0x2
  801257:	e8 98 ff ff ff       	call   8011f4 <syscall>
  80125c:	83 c4 18             	add    $0x18,%esp
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 03                	push   $0x3
  801270:	e8 7f ff ff ff       	call   8011f4 <syscall>
  801275:	83 c4 18             	add    $0x18,%esp
}
  801278:	90                   	nop
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 04                	push   $0x4
  80128a:	e8 65 ff ff ff       	call   8011f4 <syscall>
  80128f:	83 c4 18             	add    $0x18,%esp
}
  801292:	90                   	nop
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	6a 00                	push   $0x0
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	52                   	push   %edx
  8012a5:	50                   	push   %eax
  8012a6:	6a 08                	push   $0x8
  8012a8:	e8 47 ff ff ff       	call   8011f4 <syscall>
  8012ad:	83 c4 18             	add    $0x18,%esp
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	56                   	push   %esi
  8012b6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8012ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	56                   	push   %esi
  8012c7:	53                   	push   %ebx
  8012c8:	51                   	push   %ecx
  8012c9:	52                   	push   %edx
  8012ca:	50                   	push   %eax
  8012cb:	6a 09                	push   $0x9
  8012cd:	e8 22 ff ff ff       	call   8011f4 <syscall>
  8012d2:	83 c4 18             	add    $0x18,%esp
}
  8012d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d8:	5b                   	pop    %ebx
  8012d9:	5e                   	pop    %esi
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    

008012dc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	52                   	push   %edx
  8012ec:	50                   	push   %eax
  8012ed:	6a 0a                	push   $0xa
  8012ef:	e8 00 ff ff ff       	call   8011f4 <syscall>
  8012f4:	83 c4 18             	add    $0x18,%esp
}
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    

008012f9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	ff 75 0c             	pushl  0xc(%ebp)
  801305:	ff 75 08             	pushl  0x8(%ebp)
  801308:	6a 0b                	push   $0xb
  80130a:	e8 e5 fe ff ff       	call   8011f4 <syscall>
  80130f:	83 c4 18             	add    $0x18,%esp
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 0c                	push   $0xc
  801323:	e8 cc fe ff ff       	call   8011f4 <syscall>
  801328:	83 c4 18             	add    $0x18,%esp
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 0d                	push   $0xd
  80133c:	e8 b3 fe ff ff       	call   8011f4 <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 0e                	push   $0xe
  801355:	e8 9a fe ff ff       	call   8011f4 <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 0f                	push   $0xf
  80136e:	e8 81 fe ff ff       	call   8011f4 <syscall>
  801373:	83 c4 18             	add    $0x18,%esp
}
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	ff 75 08             	pushl  0x8(%ebp)
  801386:	6a 10                	push   $0x10
  801388:	e8 67 fe ff ff       	call   8011f4 <syscall>
  80138d:	83 c4 18             	add    $0x18,%esp
}
  801390:	c9                   	leave  
  801391:	c3                   	ret    

00801392 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 11                	push   $0x11
  8013a1:	e8 4e fe ff ff       	call   8011f4 <syscall>
  8013a6:	83 c4 18             	add    $0x18,%esp
}
  8013a9:	90                   	nop
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <sys_cputc>:

void
sys_cputc(const char c)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 04             	sub    $0x4,%esp
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013b8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	50                   	push   %eax
  8013c5:	6a 01                	push   $0x1
  8013c7:	e8 28 fe ff ff       	call   8011f4 <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
}
  8013cf:	90                   	nop
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 14                	push   $0x14
  8013e1:	e8 0e fe ff ff       	call   8011f4 <syscall>
  8013e6:	83 c4 18             	add    $0x18,%esp
}
  8013e9:	90                   	nop
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 04             	sub    $0x4,%esp
  8013f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013f8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013fb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	6a 00                	push   $0x0
  801404:	51                   	push   %ecx
  801405:	52                   	push   %edx
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	50                   	push   %eax
  80140a:	6a 15                	push   $0x15
  80140c:	e8 e3 fd ff ff       	call   8011f4 <syscall>
  801411:	83 c4 18             	add    $0x18,%esp
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	52                   	push   %edx
  801426:	50                   	push   %eax
  801427:	6a 16                	push   $0x16
  801429:	e8 c6 fd ff ff       	call   8011f4 <syscall>
  80142e:	83 c4 18             	add    $0x18,%esp
}
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801436:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801439:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	51                   	push   %ecx
  801444:	52                   	push   %edx
  801445:	50                   	push   %eax
  801446:	6a 17                	push   $0x17
  801448:	e8 a7 fd ff ff       	call   8011f4 <syscall>
  80144d:	83 c4 18             	add    $0x18,%esp
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801455:	8b 55 0c             	mov    0xc(%ebp),%edx
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	52                   	push   %edx
  801462:	50                   	push   %eax
  801463:	6a 18                	push   $0x18
  801465:	e8 8a fd ff ff       	call   8011f4 <syscall>
  80146a:	83 c4 18             	add    $0x18,%esp
}
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	6a 00                	push   $0x0
  801477:	ff 75 14             	pushl  0x14(%ebp)
  80147a:	ff 75 10             	pushl  0x10(%ebp)
  80147d:	ff 75 0c             	pushl  0xc(%ebp)
  801480:	50                   	push   %eax
  801481:	6a 19                	push   $0x19
  801483:	e8 6c fd ff ff       	call   8011f4 <syscall>
  801488:	83 c4 18             	add    $0x18,%esp
}
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	50                   	push   %eax
  80149c:	6a 1a                	push   $0x1a
  80149e:	e8 51 fd ff ff       	call   8011f4 <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
}
  8014a6:	90                   	nop
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	50                   	push   %eax
  8014b8:	6a 1b                	push   $0x1b
  8014ba:	e8 35 fd ff ff       	call   8011f4 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 05                	push   $0x5
  8014d3:	e8 1c fd ff ff       	call   8011f4 <syscall>
  8014d8:	83 c4 18             	add    $0x18,%esp
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 06                	push   $0x6
  8014ec:	e8 03 fd ff ff       	call   8011f4 <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 07                	push   $0x7
  801505:	e8 ea fc ff ff       	call   8011f4 <syscall>
  80150a:	83 c4 18             	add    $0x18,%esp
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_exit_env>:


void sys_exit_env(void)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 1c                	push   $0x1c
  80151e:	e8 d1 fc ff ff       	call   8011f4 <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
}
  801526:	90                   	nop
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80152f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801532:	8d 50 04             	lea    0x4(%eax),%edx
  801535:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	52                   	push   %edx
  80153f:	50                   	push   %eax
  801540:	6a 1d                	push   $0x1d
  801542:	e8 ad fc ff ff       	call   8011f4 <syscall>
  801547:	83 c4 18             	add    $0x18,%esp
	return result;
  80154a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801550:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801553:	89 01                	mov    %eax,(%ecx)
  801555:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	c9                   	leave  
  80155c:	c2 04 00             	ret    $0x4

0080155f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	ff 75 10             	pushl  0x10(%ebp)
  801569:	ff 75 0c             	pushl  0xc(%ebp)
  80156c:	ff 75 08             	pushl  0x8(%ebp)
  80156f:	6a 13                	push   $0x13
  801571:	e8 7e fc ff ff       	call   8011f4 <syscall>
  801576:	83 c4 18             	add    $0x18,%esp
	return ;
  801579:	90                   	nop
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <sys_rcr2>:
uint32 sys_rcr2()
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 1e                	push   $0x1e
  80158b:	e8 64 fc ff ff       	call   8011f4 <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
  80159e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015a1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	50                   	push   %eax
  8015ae:	6a 1f                	push   $0x1f
  8015b0:	e8 3f fc ff ff       	call   8011f4 <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b8:	90                   	nop
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <rsttst>:
void rsttst()
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 21                	push   $0x21
  8015ca:	e8 25 fc ff ff       	call   8011f4 <syscall>
  8015cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d2:	90                   	nop
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	8b 45 14             	mov    0x14(%ebp),%eax
  8015de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015e1:	8b 55 18             	mov    0x18(%ebp),%edx
  8015e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015e8:	52                   	push   %edx
  8015e9:	50                   	push   %eax
  8015ea:	ff 75 10             	pushl  0x10(%ebp)
  8015ed:	ff 75 0c             	pushl  0xc(%ebp)
  8015f0:	ff 75 08             	pushl  0x8(%ebp)
  8015f3:	6a 20                	push   $0x20
  8015f5:	e8 fa fb ff ff       	call   8011f4 <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8015fd:	90                   	nop
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <chktst>:
void chktst(uint32 n)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	ff 75 08             	pushl  0x8(%ebp)
  80160e:	6a 22                	push   $0x22
  801610:	e8 df fb ff ff       	call   8011f4 <syscall>
  801615:	83 c4 18             	add    $0x18,%esp
	return ;
  801618:	90                   	nop
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <inctst>:

void inctst()
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 23                	push   $0x23
  80162a:	e8 c5 fb ff ff       	call   8011f4 <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
	return ;
  801632:	90                   	nop
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <gettst>:
uint32 gettst()
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 24                	push   $0x24
  801644:	e8 ab fb ff ff       	call   8011f4 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 25                	push   $0x25
  801660:	e8 8f fb ff ff       	call   8011f4 <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
  801668:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80166b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80166f:	75 07                	jne    801678 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801671:	b8 01 00 00 00       	mov    $0x1,%eax
  801676:	eb 05                	jmp    80167d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801678:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 25                	push   $0x25
  801691:	e8 5e fb ff ff       	call   8011f4 <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
  801699:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80169c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016a0:	75 07                	jne    8016a9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a7:	eb 05                	jmp    8016ae <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 25                	push   $0x25
  8016c2:	e8 2d fb ff ff       	call   8011f4 <syscall>
  8016c7:	83 c4 18             	add    $0x18,%esp
  8016ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016cd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016d1:	75 07                	jne    8016da <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d8:	eb 05                	jmp    8016df <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 25                	push   $0x25
  8016f3:	e8 fc fa ff ff       	call   8011f4 <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
  8016fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016fe:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801702:	75 07                	jne    80170b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801704:	b8 01 00 00 00       	mov    $0x1,%eax
  801709:	eb 05                	jmp    801710 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80170b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	ff 75 08             	pushl  0x8(%ebp)
  801720:	6a 26                	push   $0x26
  801722:	e8 cd fa ff ff       	call   8011f4 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
	return ;
  80172a:	90                   	nop
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801731:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801734:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801737:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	6a 00                	push   $0x0
  80173f:	53                   	push   %ebx
  801740:	51                   	push   %ecx
  801741:	52                   	push   %edx
  801742:	50                   	push   %eax
  801743:	6a 27                	push   $0x27
  801745:	e8 aa fa ff ff       	call   8011f4 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
}
  80174d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801755:	8b 55 0c             	mov    0xc(%ebp),%edx
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	52                   	push   %edx
  801762:	50                   	push   %eax
  801763:	6a 28                	push   $0x28
  801765:	e8 8a fa ff ff       	call   8011f4 <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801772:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801775:	8b 55 0c             	mov    0xc(%ebp),%edx
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	6a 00                	push   $0x0
  80177d:	51                   	push   %ecx
  80177e:	ff 75 10             	pushl  0x10(%ebp)
  801781:	52                   	push   %edx
  801782:	50                   	push   %eax
  801783:	6a 29                	push   $0x29
  801785:	e8 6a fa ff ff       	call   8011f4 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	ff 75 10             	pushl  0x10(%ebp)
  801799:	ff 75 0c             	pushl  0xc(%ebp)
  80179c:	ff 75 08             	pushl  0x8(%ebp)
  80179f:	6a 12                	push   $0x12
  8017a1:	e8 4e fa ff ff       	call   8011f4 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a9:	90                   	nop
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	52                   	push   %edx
  8017bc:	50                   	push   %eax
  8017bd:	6a 2a                	push   $0x2a
  8017bf:	e8 30 fa ff ff       	call   8011f4 <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
	return;
  8017c7:	90                   	nop
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	50                   	push   %eax
  8017d9:	6a 2b                	push   $0x2b
  8017db:	e8 14 fa ff ff       	call   8011f4 <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	ff 75 0c             	pushl  0xc(%ebp)
  8017f1:	ff 75 08             	pushl  0x8(%ebp)
  8017f4:	6a 2c                	push   $0x2c
  8017f6:	e8 f9 f9 ff ff       	call   8011f4 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
	return;
  8017fe:	90                   	nop
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	ff 75 0c             	pushl  0xc(%ebp)
  80180d:	ff 75 08             	pushl  0x8(%ebp)
  801810:	6a 2d                	push   $0x2d
  801812:	e8 dd f9 ff ff       	call   8011f4 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
	return;
  80181a:	90                   	nop
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    
  80181d:	66 90                	xchg   %ax,%ax
  80181f:	90                   	nop

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
